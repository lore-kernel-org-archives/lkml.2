Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395Ab0DOKnM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 06:43:12 -0400
Received: from verein.lst.de ([213.95.11.210]:56112 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753318Ab0DOKnL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 06:43:11 -0400
Date: Thu, 15 Apr 2010 12:42:24 +0200
From: Christoph Hellwig <hch@lst.de>
To: Anton Blanchard <anton@samba.org>
Cc: Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Jens Axboe <jens.axboe@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix regression in O_DIRECT|O_SYNC writes to block devices
Message-ID: <20100415104224.GA27482@lst.de>
References: <20100415044039.GJ11751@kryten>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100415044039.GJ11751@kryten>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 15, 2010 at 02:40:39PM +1000, Anton Blanchard wrote:
>  int blkdev_fsync(struct file *filp, struct dentry *dentry, int datasync)
>  {
> -	struct block_device *bdev = I_BDEV(filp->f_mapping->host);
> +	struct inode *bd_inode = filp->f_mapping->host;
> +	struct block_device *bdev = I_BDEV(bd_inode);
>  	int error;
>  
> +	mutex_unlock(&bd_inode->i_mutex);
> +
>  	error = sync_blockdev(bdev);

Actually you can just drop this call entirely.  sync_blockdev is an
overcomplicated alias for filemap_write_and_wait on the  block device
inode, which is exactl what we did just before calling into ->fsync

It might be worth to still drop i_mutex for the cache flush, though.
