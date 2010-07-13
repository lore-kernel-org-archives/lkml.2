Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750881Ab0GMEGJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 00:06:09 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:44442 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750709Ab0GMEGG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 00:06:06 -0400
X-Sasl-enc: yPrxU0H4BfxOUb2ERmMx43ok290iU66zf/bqn/aQY32I 1278993964
Date: Tue, 13 Jul 2010 12:05:56 +0800
From: Ian Kent <raven@themaw.net>
To: Valerie Aurora <vaurora@redhat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
        Miklos Szeredi <miklos@szeredi.hu>, Jan Blunck <jblunck@suse.de>,
        Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 07/38] whiteout: Set S_OPAQUE inode flag when creating
 directories
Message-ID: <20100713040555.GB3949@zeus.themaw.net>
References: <1276627208-17242-1-git-send-email-vaurora@redhat.com>
 <1276627208-17242-8-git-send-email-vaurora@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1276627208-17242-8-git-send-email-vaurora@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 15, 2010 at 11:39:37AM -0700, Valerie Aurora wrote:
> From: Jan Blunck <jblunck@suse.de>
> 
> In case of an union directory we don't want that the directories on lower
> layers of the union "show through". So to prevent that the contents of
> underlying directories magically shows up after a mkdir() we set the S_OPAQUE
> flag if directories are created where a whiteout existed before.

I found this hard to understand.

Do you mean:

For directories within a union that are whiteouts we don't want the entries of
lower layer file system to "show through". To achieve this we set the S_OPAQUE
flag after a mkdir() on directories that are whiteouts.

> 
> Signed-off-by: Jan Blunck <jblunck@suse.de>
> Signed-off-by: Valerie Aurora <vaurora@redhat.com>
> ---
>  fs/namei.c         |   11 ++++++++++-
>  include/linux/fs.h |    3 +++
>  2 files changed, 13 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/namei.c b/fs/namei.c
> index 2c723e2..8c67636 100644
> --- a/fs/namei.c
> +++ b/fs/namei.c
> @@ -2107,6 +2107,7 @@ SYSCALL_DEFINE3(mknod, const char __user *, filename, int, mode, unsigned, dev)
>  int vfs_mkdir(struct inode *dir, struct dentry *dentry, int mode)
>  {
>  	int error = may_create(dir, dentry);
> +	int opaque = 0;
>  
>  	if (error)
>  		return error;
> @@ -2119,9 +2120,17 @@ int vfs_mkdir(struct inode *dir, struct dentry *dentry, int mode)
>  	if (error)
>  		return error;
>  
> +	if (d_is_whiteout(dentry))
> +		opaque = 1;
> +
>  	error = dir->i_op->mkdir(dir, dentry, mode);
> -	if (!error)
> +	if (!error) {
>  		fsnotify_mkdir(dir, dentry);
> +		if (opaque) {
> +			dentry->d_inode->i_flags |= S_OPAQUE;
> +			mark_inode_dirty(dentry->d_inode);
> +		}
> +	}
>  	return error;
>  }
>  
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 7afdbd4..e9aa650 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -236,6 +236,7 @@ struct inodes_stat_t {
>  #define S_NOCMTIME	128	/* Do not update file c/mtime */
>  #define S_SWAPFILE	256	/* Do not truncate: swapon got its bmaps */
>  #define S_PRIVATE	512	/* Inode is fs-internal */
> +#define S_OPAQUE	1024	/* Directory is opaque */
>  
>  /*
>   * Note that nosuid etc flags are inode-specific: setting some file-system
> @@ -271,6 +272,8 @@ struct inodes_stat_t {
>  #define IS_SWAPFILE(inode)	((inode)->i_flags & S_SWAPFILE)
>  #define IS_PRIVATE(inode)	((inode)->i_flags & S_PRIVATE)
>  
> +#define IS_OPAQUE(inode)	((inode)->i_flags & S_OPAQUE)
> +
>  /* the read-only stuff doesn't really belong here, but any other place is
>     probably as bad and I don't want to create yet another include file. */
>  
> -- 
> 1.6.3.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
