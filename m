Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755968Ab0K3L0R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 06:26:17 -0500
Received: from daytona.panasas.com ([67.152.220.89]:5523 "EHLO
	daytona.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755521Ab0K3L0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 06:26:15 -0500
Message-ID: <4CF4DF54.7020602@panasas.com>
Date: Tue, 30 Nov 2010 13:26:12 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: npiggin@kernel.dk
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 5/7] fs: ext2 inode sync fix
References: <20101123140610.292941494@kernel.dk> <20101123140707.991528524@kernel.dk>
In-Reply-To: <20101123140707.991528524@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 30 Nov 2010 11:26:14.0052 (UTC) FILETIME=[65A27E40:01CB9081]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/23/2010 04:06 PM, npiggin@kernel.dk wrote:
> There is a big fuckup with inode metadata writeback (I suspect in a lot
> of filesystems, but I've only dared to look at a couple as yet).
> 
> ext2 relies on ->write_inode being called from sync_inode_metadata in
> fsync in order to sync the inode. However I_DIRTY_SYNC gets cleared
> after a call to this guy, and it doesn't actually write back and wait
> on the inode block unless it is called for sync. This means that write_inode
> from background writeback can kill the inode dirty bits without the data
> getting to disk. Fsync will subsequently miss it.
> 
> The fix is for ->write_inode to dirty the buffers/cache, and then ->fsync to
> write back the dirty data. In the full filesystem sync case, buffercache
> writeback in the generic code will write back the dirty data. Other
> filesystems could use ->sync_fs for this.
> 
> Signed-off-by: Nick Piggin <npiggin@kernel.dk>
> 
> Index: linux-2.6/fs/ext2/inode.c
> ===================================================================
> --- linux-2.6.orig/fs/ext2/inode.c	2010-11-23 21:56:05.000000000 +1100
> +++ linux-2.6/fs/ext2/inode.c	2010-11-23 22:05:02.000000000 +1100
> @@ -1211,7 +1211,7 @@ static int ext2_setsize(struct inode *in
>  	return 0;
>  }
>  
> -static struct ext2_inode *ext2_get_inode(struct super_block *sb, ino_t ino,
> +struct ext2_inode *ext2_get_inode(struct super_block *sb, ino_t ino,
>  					struct buffer_head **p)
>  {
>  	struct buffer_head * bh;
> @@ -1505,16 +1505,8 @@ static int __ext2_write_inode(struct ino
>  	} else for (n = 0; n < EXT2_N_BLOCKS; n++)
>  		raw_inode->i_block[n] = ei->i_data[n];
>  	mark_buffer_dirty(bh);
> -	if (do_sync) {
> -		sync_dirty_buffer(bh);
> -		if (buffer_req(bh) && !buffer_uptodate(bh)) {
> -			printk ("IO error syncing ext2 inode [%s:%08lx]\n",
> -				sb->s_id, (unsigned long) ino);
> -			err = -EIO;
> -		}
> -	}

Is .fsync the only case when .write_inode is called with do_sync==true ?

> -	ei->i_state &= ~EXT2_STATE_NEW;
>  	brelse (bh);
> +	ei->i_state &= ~EXT2_STATE_NEW;
>  	return err;
>  }
>  
> Index: linux-2.6/fs/ext2/file.c
> ===================================================================
> --- linux-2.6.orig/fs/ext2/file.c	2010-11-23 21:56:05.000000000 +1100
> +++ linux-2.6/fs/ext2/file.c	2010-11-23 22:05:02.000000000 +1100
> @@ -21,6 +21,7 @@
>  #include <linux/time.h>
>  #include <linux/pagemap.h>
>  #include <linux/quotaops.h>
> +#include <linux/buffer_head.h>
>  #include "ext2.h"
>  #include "xattr.h"
>  #include "acl.h"
> @@ -43,16 +44,33 @@ static int ext2_release_file (struct ino
>  int ext2_fsync(struct file *file, int datasync)
>  {
>  	int ret;
> -	struct super_block *sb = file->f_mapping->host->i_sb;
> -	struct address_space *mapping = sb->s_bdev->bd_inode->i_mapping;
> +	struct inode *inode = file->f_mapping->host;
> +	ino_t ino = inode->i_ino;
> +	struct super_block *sb = inode->i_sb;
> +	struct address_space *sb_mapping = sb->s_bdev->bd_inode->i_mapping;
> +	struct buffer_head *bh;
> +	struct ext2_inode *raw_inode;
>  
>  	ret = generic_file_fsync(file, datasync);
> -	if (ret == -EIO || test_and_clear_bit(AS_EIO, &mapping->flags)) {
> +	if (ret == -EIO || test_and_clear_bit(AS_EIO, &sb_mapping->flags)) {
>  		/* We don't really know where the IO error happened... */
>  		ext2_error(sb, __func__,
>  			   "detected IO error when writing metadata buffers");
> +		return -EIO;
> +	}
> +
> +	raw_inode = ext2_get_inode(sb, ino, &bh);

You use the Read-inode-from-disk-if-not-present function to associate
a bufferhead with the inode, relying on it being in memory for sure.
That's ugly. Maybe a comment?

But do you need it, since above __ext2_write_inode did mark_buffer_dirty(bh);
is it not already included in the buffers flushed to disk?

> +	if (IS_ERR(raw_inode))
> + 		return -EIO;
> +
> +	sync_dirty_buffer(bh);
> +	if (buffer_req(bh) && !buffer_uptodate(bh)) {
> +		printk ("IO error syncing ext2 inode [%s:%08lx]\n",
> +			sb->s_id, (unsigned long) ino);

Should you not use ext2_error(sb, __func__, like above?

Boaz
>  		ret = -EIO;
>  	}
> +	brelse (bh);
> +
>  	return ret;
>  }
>  
> Index: linux-2.6/fs/ext2/ext2.h
> ===================================================================
> --- linux-2.6.orig/fs/ext2/ext2.h	2010-11-23 21:56:05.000000000 +1100
> +++ linux-2.6/fs/ext2/ext2.h	2010-11-23 22:05:02.000000000 +1100
> @@ -124,6 +124,8 @@ extern int ext2_get_block(struct inode *
>  extern int ext2_setattr (struct dentry *, struct iattr *);
>  extern void ext2_set_inode_flags(struct inode *inode);
>  extern void ext2_get_inode_flags(struct ext2_inode_info *);
> +extern struct ext2_inode *ext2_get_inode(struct super_block *sb, ino_t ino,
> +					struct buffer_head **p);
>  extern int ext2_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
>  		       u64 start, u64 len);
>  
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

