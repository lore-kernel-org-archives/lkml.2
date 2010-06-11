Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760469Ab0FKTWK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 15:22:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1026 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756611Ab0FKTWI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 15:22:08 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Josef Bacik <josef@redhat.com>
Cc: linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs: make sure to invalidate pages if we fall back on buffered reads
References: <1276007044-17715-1-git-send-email-josef@redhat.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Fri, 11 Jun 2010 15:22:01 -0400
In-Reply-To: <1276007044-17715-1-git-send-email-josef@redhat.com> (Josef
	Bacik's message of "Tue, 8 Jun 2010 10:24:04 -0400")
Message-ID: <x4939wtidd2.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Josef Bacik <josef@redhat.com> writes:

> Since BTRFS can fallback on buffered reads after having done some direct reads,
> we need to make sure to invalidate any pages that we may have read by doing
> buffered IO.  This shouldn't have shown up as a visible user problem, it's just
> for correctness sake.  Thanks,

This looks right to me.  You definitely don't want to fill up the page
cache from direct I/O.

Reviewed-by: Jeff Moyer <jmoyer@redhat.com>

> Signed-off-by: Josef Bacik <josef@redhat.com>
> ---
>  mm/filemap.c |    9 ++++++++-
>  1 files changed, 8 insertions(+), 1 deletions(-)
>
> diff --git a/mm/filemap.c b/mm/filemap.c
> index 829ac9c..ca5aba9 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -1266,6 +1266,7 @@ generic_file_aio_read(struct kiocb *iocb, const struct iovec *iov,
>  	unsigned long seg = 0;
>  	size_t count;
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
>  out:
>  	return retval;
>  }
