Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755224Ab0IWWE5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 18:04:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17556 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751108Ab0IWWE4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 18:04:56 -0400
Date: Thu, 23 Sep 2010 18:04:37 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, neilb@suse.de,
        viro@zeniv.linux.org.uk
Subject: Re: [PATCH 3/7 v3] vfs: add flag to allow rename to same inode
Message-ID: <20100923220437.GD3536@shell>
References: <20100920180404.939991832@szeredi.hu> <20100920180442.285002176@szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100920180442.285002176@szeredi.hu>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 20, 2010 at 08:04:07PM +0200, Miklos Szeredi wrote:
> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> The overlay filesystem uses dummy inodes for non-directories.  Allow
> rename to work in this case despite the inode being the same.
> 
> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
> ---
>  fs/namei.c         |    4 +++-
>  include/linux/fs.h |    1 +
>  2 files changed, 4 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6/include/linux/fs.h
> ===================================================================
> --- linux-2.6.orig/include/linux/fs.h	2010-08-25 14:19:34.000000000 +0200
> +++ linux-2.6/include/linux/fs.h	2010-08-25 14:19:53.000000000 +0200
> @@ -179,6 +179,7 @@ struct inodes_stat_t {
>  #define FS_RENAME_DOES_D_MOVE	32768	/* FS will handle d_move()
>  					 * during rename() internally.
>  					 */
> +#define FS_RENAME_SELF_ALLOW	65536	/* Allow rename to same inode */
>  
>  /*
>   * These are the fs-independent mount-flags: up to 32 flags are supported
> Index: linux-2.6/fs/namei.c
> ===================================================================
> --- linux-2.6.orig/fs/namei.c	2010-08-25 10:19:53.000000000 +0200
> +++ linux-2.6/fs/namei.c	2010-08-25 14:22:56.000000000 +0200
> @@ -2620,8 +2620,10 @@ int vfs_rename(struct inode *old_dir, st
>  	int is_dir = S_ISDIR(old_dentry->d_inode->i_mode);
>  	const unsigned char *old_name;
>  
> -	if (old_dentry->d_inode == new_dentry->d_inode)
> +	if (old_dentry->d_inode == new_dentry->d_inode &&
> +	    !(old_dir->i_sb->s_type->fs_flags & FS_RENAME_SELF_ALLOW)) {
>   		return 0;
> +	}
>   
>  	error = may_delete(old_dir, old_dentry, is_dir);
>  	if (error)
> 

Perhaps a note in the commit message to say that the (inode == inode)
check on the lower layer is done when overlayfs calls vfs_rename() on
the targets?

What other issues arise with dummy inodes?

-VAL
