Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754651Ab0FNIRj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 04:17:39 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:35520 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754366Ab0FNIRh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 04:17:37 -0400
Date: Mon, 14 Jun 2010 04:17:36 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Josef Bacik <josef@redhat.com>
Cc: linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs: make sure to invalidate pages if we fall back on
 buffered reads
Message-ID: <20100614081736.GA29239@infradead.org>
References: <1276007044-17715-1-git-send-email-josef@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1276007044-17715-1-git-send-email-josef@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 08, 2010 at 10:24:04AM -0400, Josef Bacik wrote:
> Since BTRFS can fallback on buffered reads after having done some direct reads,
> we need to make sure to invalidate any pages that we may have read by doing
> buffered IO.  This shouldn't have shown up as a visible user problem, it's just
> for correctness sake.  Thanks,

Everything else in direct I/O land uses invalidate_inode_pages2(_range),
why not this one?

>  	loff_t *ppos = &iocb->ki_pos;
> +	bool invalidate = false;
>  
>  	count = 0;
>  	retval = generic_segment_checks(iov, &nr_segs, &count, VERIFY_WRITE);
> @@ -1291,7 +1292,8 @@ generic_file_aio_read(struct kiocb *iocb, const struct iovec *iov,
>  							iov, pos, nr_segs);
>  			}
>  			if (retval > 0) {
> -				*ppos = pos + retval;
> +				pos += retval;
> +				*ppos = pos;
>  				count -= retval;
>  			}
>  
> @@ -1307,6 +1309,7 @@ generic_file_aio_read(struct kiocb *iocb, const struct iovec *iov,
>  				file_accessed(filp);
>  				goto out;
>  			}
> +			invalidate = true;
>  		}
>  	}
>  
> @@ -1343,6 +1346,10 @@ generic_file_aio_read(struct kiocb *iocb, const struct iovec *iov,
>  		if (desc.count > 0)
>  			break;
>  	}
> +	if (invalidate && retval > 0)
> +		invalidate_mapping_pages(filp->f_mapping,
> +					 pos >> PAGE_CACHE_SHIFT,
> +					 (*ppos - 1) >> PAGE_CACHE_SHIFT);

A little comment here would be surely useful.  Telling that we want to
get rid of the pages again if we were falling through from an attempted
direct I/O read.

