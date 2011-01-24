Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753203Ab1AXD5g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jan 2011 22:57:36 -0500
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:5981 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753019Ab1AXD5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jan 2011 22:57:35 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApMEAD+FPE15LN5mgWdsb2JhbACkZRYBARYiJLsDDYVDBA
Date: Mon, 24 Jan 2011 14:57:17 +1100
From: Dave Chinner <david@fromorbit.com>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: linux-kernel@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 07/10] fs: make generic file read/write functions plug
Message-ID: <20110124035717.GC16267@dastard>
References: <1295659049-2688-1-git-send-email-jaxboe@fusionio.com>
 <1295659049-2688-8-git-send-email-jaxboe@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295659049-2688-8-git-send-email-jaxboe@fusionio.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 22, 2011 at 01:17:26AM +0000, Jens Axboe wrote:
> Signed-off-by: Jens Axboe <jaxboe@fusionio.com>
> ---
>  mm/filemap.c |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)
> 
.....
> @@ -2432,11 +2436,13 @@ ssize_t generic_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
>  {
>  	struct file *file = iocb->ki_filp;
>  	struct inode *inode = file->f_mapping->host;
> +	struct blk_plug plug;
>  	ssize_t ret;
>  
>  	BUG_ON(iocb->ki_pos != pos);
>  
>  	mutex_lock(&inode->i_mutex);
> +	blk_start_plug(&plug);
>  	ret = __generic_file_aio_write(iocb, iov, nr_segs, &iocb->ki_pos);
>  	mutex_unlock(&inode->i_mutex);
>  
> @@ -2447,6 +2453,7 @@ ssize_t generic_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
>  		if (err < 0 && ret > 0)
>  			ret = err;
>  	}
> +	blk_finish_plug(&plug);
>  	return ret;
>  }
>  EXPORT_SYMBOL(generic_file_aio_write);

Why do you want to plug all writes? For non-synchronous buffered
writes we won't be doing any IO, so why woul dwe want to plug and
unplug in that case? Shouldn't the plug/unplug be places in
.writepage for the buffered writeback case (which would handle sync
writes, too)?

Also, what is the impact of not plugging here? You change
generic_file_aio_write, but filesystems like XFS supply their own
.aio_write method and hence woul dneed some kind of change, too?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
