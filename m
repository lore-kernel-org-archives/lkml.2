Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755185Ab0KWPD4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 10:03:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30126 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755153Ab0KWPDz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 10:03:55 -0500
Subject: Re: [patch 7/7] fs: fix or note I_DIRTY handling bugs in
 filesystems
From: Steven Whitehouse <swhiteho@redhat.com>
To: npiggin@kernel.dk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20101123140708.132861329@kernel.dk>
References: <20101123140610.292941494@kernel.dk>
	 <20101123140708.132861329@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Tue, 23 Nov 2010 15:04:10 +0000
Message-ID: <1290524650.2423.13.camel@dolmen>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, 2010-11-24 at 01:06 +1100, npiggin@kernel.dk wrote:
> plain text document attachment (fs-fix-dirty-flags.patch)
> Comments?
> 
> Index: linux-2.6/drivers/staging/pohmelfs/inode.c
> ===================================================================
> --- linux-2.6.orig/drivers/staging/pohmelfs/inode.c	2010-11-23 22:57:45.000000000 +1100
> +++ linux-2.6/drivers/staging/pohmelfs/inode.c	2010-11-23 22:59:47.000000000 +1100
> @@ -373,6 +373,7 @@ static int pohmelfs_write_inode_create_c
>  		dprintk("%s: parent: %llu, ino: %llu, inode: %p.\n",
>  				__func__, parent->ino, n->ino, inode);
>  
> +		/* XXX: is this race WRT writeback? */
>  		if (inode && (inode->i_state & I_DIRTY)) {
>  			struct pohmelfs_inode *pi = POHMELFS_I(inode);
>  			pohmelfs_write_create_inode(pi);
> Index: linux-2.6/fs/gfs2/file.c
> ===================================================================
> --- linux-2.6.orig/fs/gfs2/file.c	2010-11-23 22:54:47.000000000 +1100
> +++ linux-2.6/fs/gfs2/file.c	2010-11-24 00:58:42.000000000 +1100
> @@ -557,23 +557,43 @@ static int gfs2_close(struct inode *inod
>  static int gfs2_fsync(struct file *file, int datasync)
>  {
>  	struct inode *inode = file->f_mapping->host;
> -	int sync_state = inode->i_state & (I_DIRTY_SYNC|I_DIRTY_DATASYNC);
> +	unsigned dirty, mask;
>  	int ret = 0;
>  
> -	/* XXX: testing i_state is broken without proper synchronization */
> -
>  	if (gfs2_is_jdata(GFS2_I(inode))) {
>  		gfs2_log_flush(GFS2_SB(inode), GFS2_I(inode)->i_gl);
>  		return 0;
>  	}
>  
> -	if (sync_state != 0) {
> -		if (!datasync)
> -			ret = write_inode_now(inode, 0);
> +	spin_lock(&inode_lock);
> +	inode_writeback_begin(inode, 1);
> +
> +	if (datasync)
> +		mask = I_DIRTY_DATASYNC;
> +	else
> +		mask = I_DIRTY_SYNC | I_DIRTY_DATASYNC;
> +	dirty = inode->i_state & mask;
> +	inode->i_state &= ~mask;
> +	if (dirty) {
> +		spin_unlock(&inode_lock);
> +
> +		if (!datasync) {
> +			struct writeback_control wbc = {
> +				.sync_mode = WB_SYNC_ALL,
> +			};
> +			ret = inode->i_sb->s_op->write_inode(inode, &wbc);
> +		} else {
> +			if (gfs2_is_stuffed(GFS2_I(inode)))
> +				gfs2_log_flush(GFS2_SB(inode),
> +						GFS2_I(inode)->i_gl);
> +		}
>  
> -		if (gfs2_is_stuffed(GFS2_I(inode)))
> -			gfs2_log_flush(GFS2_SB(inode), GFS2_I(inode)->i_gl);
> +		spin_lock(&inode_lock);
>  	}
> +	if (ret)
> +		inode->i_state |= dirty;
> +	inode_writeback_end(inode);
> +	spin_unlock(&inode_lock);
>  
>  	return ret;
>  }

The GFS2 changes seem to make sense to me, so:
Acked-by: Steven Whitehouse <swhiteho@redhat.com>

Steve.


