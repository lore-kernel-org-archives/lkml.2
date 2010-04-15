Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757505Ab0DOIrz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 04:47:55 -0400
Received: from cantor.suse.de ([195.135.220.2]:59586 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756053Ab0DOIrx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 04:47:53 -0400
Date: Thu, 15 Apr 2010 10:47:57 +0200
From: Jan Kara <jack@suse.cz>
To: Anton Blanchard <anton@samba.org>
Cc: Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Jens Axboe <jens.axboe@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix regression in O_DIRECT|O_SYNC writes to block
 devices
Message-ID: <20100415084757.GA3561@quack.suse.cz>
References: <20100415044039.GJ11751@kryten>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100415044039.GJ11751@kryten>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 15-04-10 14:40:39, Anton Blanchard wrote:
> 
> We are seeing a large regression in database performance on recent kernels.
> The database opens a block device with O_DIRECT|O_SYNC and a number of threads
> write to different regions of the file at the same time.
> 
> A simple test case is below. I haven't defined DEVICE to anything since getting
> it wrong will destroy your data :) On an 3 disk LVM with a 64k chunk size we
> see about 17MB/sec and only a few threads in IO wait:
> 
> procs  -----io---- -system-- -----cpu------
>  r  b     bi    bo   in   cs us sy id wa st
>  0  3      0 16170  656 2259  0  0 86 14  0
>  0  2      0 16704  695 2408  0  0 92  8  0
>  0  2      0 17308  744 2653  0  0 86 14  0
>  0  2      0 17933  759 2777  0  0 89 10  0
> 
> Most threads are blocking in vfs_fsync_range, which has:
> 
>         mutex_lock(&mapping->host->i_mutex);
>         err = fop->fsync(file, dentry, datasync);
>         if (!ret)
>                 ret = err;
>         mutex_unlock(&mapping->host->i_mutex);
  ...
  Just a few style nitpicks:

> Index: linux-2.6/fs/block_dev.c
> ===================================================================
> --- linux-2.6.orig/fs/block_dev.c	2010-04-14 12:55:50.000000000 +1000
> +++ linux-2.6/fs/block_dev.c	2010-04-14 13:17:45.000000000 +1000
> @@ -406,16 +406,24 @@ static loff_t block_llseek(struct file *
>   
>  int blkdev_fsync(struct file *filp, struct dentry *dentry, int datasync)
>  {
> -	struct block_device *bdev = I_BDEV(filp->f_mapping->host);
> +	struct inode *bd_inode = filp->f_mapping->host;
> +	struct block_device *bdev = I_BDEV(bd_inode);
>  	int error;
>  
  Could you please add a comment here? Like "There is no need to
protect syncing of the block device by i_mutex and it unnecessarily
serializes workloads with several O_SYNC writers to the block device"

> +	mutex_unlock(&bd_inode->i_mutex);
> +
>  	error = sync_blockdev(bdev);
> -	if (error)
> +	if (error) {
> +		mutex_lock(&bd_inode->i_mutex);
>  		return error;
  Usually, "goto out" is preferred instead of the above.

> +	}
>  	
>  	error = blkdev_issue_flush(bdev, NULL);
>  	if (error == -EOPNOTSUPP)
>  		error = 0;
> +
And define out: here.

> +	mutex_lock(&bd_inode->i_mutex);
> +
>  	return error;
>  }
>  EXPORT_SYMBOL(blkdev_fsync);

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
