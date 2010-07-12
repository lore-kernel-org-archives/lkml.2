Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754690Ab0GLIGM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 04:06:12 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:42439 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752402Ab0GLIGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 04:06:11 -0400
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
CC: hch@infradead.org, viro@zeniv.linux.org.uk, adilger@sun.com,
        corbet@lwn.net, neilb@suse.de, npiggin@suse.de, hooanon05@yahoo.co.jp,
        bfields@fieldses.org, linux-fsdevel@vger.kernel.org,
        sfrench@us.ibm.com, philippe.deniel@CEA.FR,
        linux-kernel@vger.kernel.org, aneesh.kumar@linux.vnet.ibm.com
In-reply-to: <1278916545-19751-8-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH -V16 07/12] vfs: Support null pathname in linkat
References: <1278916545-19751-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1278916545-19751-8-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Message-Id: <E1OYE1D-0005qC-AI@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 12 Jul 2010 10:05:39 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Jul 2010, Aneesh Kumar K.V wrote:
> This enables to use linkat to create hardlinks from a
> file descriptor pointing to the file. This can be used
> with open_by_handle syscall that returns a file descriptor.

This needs more thought, filesystems don't usually tolerate
resurrecting a file which has already been unlinked (i_nlink == 0).

Thanks,
Miklos

> 
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> ---
>  fs/namei.c |   34 +++++++++++++++++++++++++---------
>  1 files changed, 25 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/namei.c b/fs/namei.c
> index a6a8093..9a7b71a 100644
> --- a/fs/namei.c
> +++ b/fs/namei.c
> @@ -2553,16 +2553,28 @@ SYSCALL_DEFINE5(linkat, int, olddfd, const char __user *, oldname,
>  {
>  	struct dentry *new_dentry;
>  	struct nameidata nd;
> -	struct path old_path;
> -	int error;
> +	struct path old_path, *old_pathp;
> +	struct file *file = NULL;
> +	int error, fput_needed;
>  	char *to;
>  
>  	if ((flags & ~AT_SYMLINK_FOLLOW) != 0)
>  		return -EINVAL;
>  
> -	error = user_path_at(olddfd, oldname,
> -			     flags & AT_SYMLINK_FOLLOW ? LOOKUP_FOLLOW : 0,
> -			     &old_path);
> +	if (oldname == NULL && olddfd != AT_FDCWD) {
> +		file = fget_light(olddfd, &fput_needed);
> +		if (file) {
> +			old_pathp = &file->f_path;
> +			error = 0;
> +		} else
> +			error = -EBADF;
> +	} else {
> +		error = user_path_at(olddfd, oldname,
> +				     flags & AT_SYMLINK_FOLLOW ?
> +				     LOOKUP_FOLLOW : 0,
> +				     &old_path);
> +		old_pathp = &old_path;
> +	}
>  	if (error)
>  		return error;
>  
> @@ -2570,7 +2582,7 @@ SYSCALL_DEFINE5(linkat, int, olddfd, const char __user *, oldname,
>  	if (error)
>  		goto out;
>  	error = -EXDEV;
> -	if (old_path.mnt != nd.path.mnt)
> +	if (old_pathp->mnt != nd.path.mnt)
>  		goto out_release;
>  	new_dentry = lookup_create(&nd, 0);
>  	error = PTR_ERR(new_dentry);
> @@ -2579,10 +2591,11 @@ SYSCALL_DEFINE5(linkat, int, olddfd, const char __user *, oldname,
>  	error = mnt_want_write(nd.path.mnt);
>  	if (error)
>  		goto out_dput;
> -	error = security_path_link(old_path.dentry, &nd.path, new_dentry);
> +	error = security_path_link(old_pathp->dentry, &nd.path, new_dentry);
>  	if (error)
>  		goto out_drop_write;
> -	error = vfs_link(old_path.dentry, nd.path.dentry->d_inode, new_dentry);
> +	error = vfs_link(old_pathp->dentry,
> +			 nd.path.dentry->d_inode, new_dentry);
>  out_drop_write:
>  	mnt_drop_write(nd.path.mnt);
>  out_dput:
> @@ -2593,7 +2606,10 @@ out_release:
>  	path_put(&nd.path);
>  	putname(to);
>  out:
> -	path_put(&old_path);
> +	if (file)
> +		fput_light(file, fput_needed);
> +	else
> +		path_put(&old_path);
>  
>  	return error;
>  }
> -- 
> 1.7.2.rc1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
