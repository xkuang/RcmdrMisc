Barplot <- function(x, by, scale=c("frequency", "percent"), 
                    conditional=TRUE,
                    style=c("divided", "parallel"),
                    col=if (missing(by)) "gray" else rainbow_hcl(length(levels(by))),
                    xlab=deparse(substitute(x)), 
                    legend.title=deparse(substitute(by)), ylab=scale, main=NULL,
                    legend.pos="above", ...){
    find.legend.columns <- function(n, target=min(4, n)){
        rem <- n %% target
        if (rem != 0 && rem < target/2) target <- target - 1
        target
    }
    if (!is.factor(x)) stop("x must be a factor")
    if (!missing(by) && !is.factor(by)) stop("by must be a factor")
    scale <- match.arg(scale)
    style <- match.arg(style)
    if (legend.pos == "above"){
        mar <- par("mar")
        mar[3] <- mar[3] + 2
        old.mar <- par(mar=mar)
        on.exit(par(old.mar))
    }
    if (missing(by)){
        y <- table(x)
        if (scale == "percent") y <- 100*y/sum(y)
        barplot(y, xlab=xlab, ylab=ylab, col=col, main=main, ...)
    }
    else{
        nlevels <- length(levels(by))
        col <- col[1:nlevels]
        y <- table(by, x)
        if (scale == "percent") {
            y <- if (conditional) 100*apply(y, 2, function(x) x/sum(x))
                 else 100*y/sum(y)
        }
        if (legend.pos == "above"){
            legend.columns <- find.legend.columns(nlevels)
            top <- 4 + ceiling(nlevels/legend.columns)
            xpd <- par(xpd=TRUE)
            on.exit(par(xpd=xpd), add=TRUE)
            barplot(y, xlab=xlab, ylab=ylab,
                    col=col, 
                    beside = style == "parallel", ...)
            usr <- par("usr")
            legend.x <- usr[1]
            legend.y <- usr[4] + 1.2*top*strheight("x")
            legend.pos <- list(x=legend.x, y=legend.y)
            title(main=main, line=mar[3] - 1)
            legend(legend.pos, title=legend.title, legend=levels(by), 
                   fill=col,
                   ncol=legend.columns, inset=0.05)
        }
        else barplot(y, xlab=xlab, ylab=ylab, main=main,
                legend.text=levels(by), col=col, 
                args.legend=list(x=legend.pos, title=legend.title, inset=0.05, bg="white"),
                beside = style == "parallel", ...)
    }
    return(invisible(NULL))
}
