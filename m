Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755371Ab0DVTZA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 15:25:00 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41276 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753723Ab0DVTY7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 15:24:59 -0400
Date: Thu, 22 Apr 2010 21:25:00 +0200
From: Jan Kara <jack@suse.cz>
To: Anton Blanchard <anton@samba.org>
Cc: Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Jens Axboe <jens.axboe@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix regression in O_DIRECT|O_SYNC writes to block
 devices
Message-ID: <20100422192459.GF5805@quack.suse.cz>
References: <20100415044039.GJ11751@kryten>
 <20100415104224.GA27482@lst.de>
 <20100420023047.GN11751@kryten>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100420023047.GN11751@kryten>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 20-04-10 12:30:47, Anton Blanchard wrote:
<snip>
> Signed-off-by: Anton Blanchard <anton@samba.org>
  The patch looks good to me now.

Acked-by: Jan Kara <jack@suse.cz>

> Index: linux-2.6/fs/block_dev.c
> ===================================================================
> --- linux-2.6.orig/fs/block_dev.c	2010-04-20 11:28:32.000000000 +1000
> +++ linux-2.6/fs/block_dev.c	2010-04-20 11:36:46.000000000 +1000
> @@ -406,16 +406,23 @@ static loff_t block_llseek(struct file *
>   
>  int blkdev_fsync(struct file *filp, struct dentry *dentry, int datasync)
>  {
> -	struct block_device *bdev = I_BDEV(filp->f_mapping->host);
> +	struct inode *bd_inode = filp->f_mapping->host;
> +	struct block_device *bdev = I_BDEV(bd_inode);
>  	int error;
>  
> -	error = sync_blockdev(bdev);
> -	if (error)
> -		return error;
> -	
> +	/*
> +	 * There is no need to serialise calls to blkdev_issue_flush with
> +	 * i_mutex and doing so causes performance issues with concurrent
> +	 * O_SYNC writers to a block device.
> +	 */
> +	mutex_unlock(&bd_inode->i_mutex);
> +
>  	error = blkdev_issue_flush(bdev, NULL);
>  	if (error == -EOPNOTSUPP)
>  		error = 0;
> +
> +	mutex_lock(&bd_inode->i_mutex);
> +
>  	return error;
>  }
>  EXPORT_SYMBOL(blkdev_fsync);
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
