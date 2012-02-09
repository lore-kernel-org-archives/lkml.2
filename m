Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932253Ab2BIBRG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 20:17:06 -0500
Received: from mga09.intel.com ([134.134.136.24]:24996 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757655Ab2BIBRE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 20:17:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="105494842"
Subject: Re: [PATCH] block: remove plugging at buffered write time
From: Shaohua Li <shaohua.li@intel.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20120208110143.GA5550@localhost>
References: <20120208110143.GA5550@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 09 Feb 2012 09:14:49 +0800
Message-ID: <1328750089.5949.1.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-02-08 at 19:01 +0800, Wu Fengguang wrote:
> Buffered write(2) is not directly tied to IO, so it's not suitable to
> handle plug in generic_file_aio_write().
> 
> Also remove the redundant plug calls around ->direct_IO(), since we now
> do unplugging in the lower layer do_blockdev_direct_IO().
> 
> CC: Jens Axboe <axboe@kernel.dk>
> CC: Li Shaohua <shaohua.li@intel.com>
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> ---
>  fs/direct-io.c |    4 ++++
>  mm/filemap.c   |    7 -------
>  2 files changed, 4 insertions(+), 7 deletions(-)
> 
> --- linux-next.orig/mm/filemap.c	2012-02-08 18:51:50.000000000 +0800
> +++ linux-next/mm/filemap.c	2012-02-08 18:52:19.000000000 +0800
> @@ -1421,12 +1421,8 @@ generic_file_aio_read(struct kiocb *iocb
>  			retval = filemap_write_and_wait_range(mapping, pos,
>  					pos + iov_length(iov, nr_segs) - 1);
>  			if (!retval) {
> -				struct blk_plug plug;
> -
> -				blk_start_plug(&plug);
>  				retval = mapping->a_ops->direct_IO(READ, iocb,
>  							iov, pos, nr_segs);
> -				blk_finish_plug(&plug);
>  			}
>  			if (retval > 0) {
>  				*ppos = pos + retval;
> @@ -2610,13 +2606,11 @@ ssize_t generic_file_aio_write(struct ki
>  {
>  	struct file *file = iocb->ki_filp;
>  	struct inode *inode = file->f_mapping->host;
> -	struct blk_plug plug;
>  	ssize_t ret;
>  
>  	BUG_ON(iocb->ki_pos != pos);
>  
>  	mutex_lock(&inode->i_mutex);
> -	blk_start_plug(&plug);
>  	ret = __generic_file_aio_write(iocb, iov, nr_segs, &iocb->ki_pos);
>  	mutex_unlock(&inode->i_mutex);
>  
> @@ -2627,7 +2621,6 @@ ssize_t generic_file_aio_write(struct ki
>  		if (err < 0 && ret > 0)
>  			ret = err;
>  	}
> -	blk_finish_plug(&plug);
>  	return ret;
>  }
>  EXPORT_SYMBOL(generic_file_aio_write);
> --- linux-next.orig/fs/direct-io.c	2012-02-08 18:51:37.000000000 +0800
> +++ linux-next/fs/direct-io.c	2012-02-08 18:52:19.000000000 +0800
> @@ -1106,6 +1106,7 @@ do_blockdev_direct_IO(int rw, struct kio
>  	unsigned long user_addr;
>  	size_t bytes;
>  	struct buffer_head map_bh = { 0, };
> +	struct blk_plug plug;
>  
>  	if (rw & WRITE)
>  		rw = WRITE_ODIRECT;
> @@ -1221,6 +1222,8 @@ do_blockdev_direct_IO(int rw, struct kio
>  				PAGE_SIZE - user_addr / PAGE_SIZE);
>  	}
>  
> +	blk_start_plug(&plug);
> +
>  	for (seg = 0; seg < nr_segs; seg++) {
>  		user_addr = (unsigned long)iov[seg].iov_base;
>  		sdio.size += bytes = iov[seg].iov_len;
> @@ -1314,6 +1317,7 @@ do_blockdev_direct_IO(int rw, struct kio
>  	} else
>  		BUG_ON(retval != -EIOCBQUEUED);
>  
> +	blk_finish_plug(&plug);
This one can be moved up a little bit (before dio_cleanup)

Thanks,
Shaohua

>  out:
>  	return retval;
>  }


