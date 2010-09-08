Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754295Ab0IHUMc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 16:12:32 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39306 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753636Ab0IHUMY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 16:12:24 -0400
Date: Wed, 8 Sep 2010 13:11:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kulikov Vasiliy <segooon@gmail.com>
Cc: kernel-janitors@vger.kernel.org, Jeff Dike <jdike@addtoit.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@lst.de>,
        user-mode-linux-devel@lists.sourceforge.net,
        user-mode-linux-user@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/14] hppfs: check for IS_ERR() instead of != NULL
Message-Id: <20100908131107.3003667d.akpm@linux-foundation.org>
In-Reply-To: <1283711577-7505-1-git-send-email-segooon@gmail.com>
References: <1283711577-7505-1-git-send-email-segooon@gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun,  5 Sep 2010 22:32:56 +0400
Kulikov Vasiliy <segooon@gmail.com> wrote:

> From: Vasiliy Kulikov <segooon@gmail.com>
> 
> Function get_inode may return ERR_PTR(...). Check for it.
> 
> Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
> ---
>  Compile tested.
> 
>  fs/hppfs/hppfs.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/hppfs/hppfs.c b/fs/hppfs/hppfs.c
> index 7b02772..e7d6535 100644
> --- a/fs/hppfs/hppfs.c
> +++ b/fs/hppfs/hppfs.c
> @@ -173,7 +173,7 @@ static struct dentry *hppfs_lookup(struct inode *ino, struct dentry *dentry,
>  
>  	err = -ENOMEM;
>  	inode = get_inode(ino->i_sb, proc_dentry);
> -	if (!inode)
> +	if (IS_ERR_OR_NULL(inode))
>  		goto out_dput;
>  
>   	d_add(dentry, inode);
> @@ -730,7 +730,7 @@ static int hppfs_fill_super(struct super_block *sb, void *d, int silent)
>  
>  	err = -ENOMEM;
>  	root_inode = get_inode(sb, proc_mnt->mnt_sb->s_root);
> -	if (!root_inode)
> +	if (IS_ERR_OR_NULL(root_inode))
>  		goto out_mntput;
>  
>  	sb->s_root = d_alloc_root(root_inode);

This fix is rather half-and-half.

If we're going to *assume* that an IS_ERR_OR_NULL return from
get_inode() means ENOMEM then there was no point in returning an errno
from get_inode()!  So we can just do this:

--- a/fs/hppfs/hppfs.c~a
+++ a/fs/hppfs/hppfs.c
@@ -683,7 +683,7 @@ static struct inode *get_inode(struct su
 	struct inode *inode = new_inode(sb);
 
 	if (!inode)
-		return ERR_PTR(-ENOMEM);
+		return NULL;
 
 	if (S_ISDIR(dentry->d_inode->i_mode)) {
 		inode->i_op = &hppfs_dir_iops;
_


If, however, we want to be able to return other error codes from
get_inode() (which is generally a good idea) then we should change the
callers of get_inode() to use PTR_ERR() and to propagate the error code
upwards.

