Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753970Ab0GLID3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 04:03:29 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:49125 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018Ab0GLID1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 04:03:27 -0400
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
CC: hch@infradead.org, viro@zeniv.linux.org.uk, adilger@sun.com,
        corbet@lwn.net, neilb@suse.de, npiggin@suse.de, hooanon05@yahoo.co.jp,
        bfields@fieldses.org, linux-fsdevel@vger.kernel.org,
        sfrench@us.ibm.com, philippe.deniel@CEA.FR,
        linux-kernel@vger.kernel.org, aneesh.kumar@linux.vnet.ibm.com
In-reply-to: <1278916545-19751-6-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH -V16 05/12] vfs: Support null pathname in readlink
References: <1278916545-19751-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1278916545-19751-6-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Message-Id: <E1OYDyZ-0005pL-OV@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 12 Jul 2010 10:02:55 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Jul 2010, Aneesh Kumar K.V wrote:
> From: NeilBrown <neilb@suse.de>
> 
> This enables to use readlink to get the link target name
> from a file descriptor point to the link. This can be used
> with open_by_handle syscall that returns a file descriptor for a link.
> We can then use this file descriptor to get the target name.
> 
> This is similar to utimensat(2) interface

We could introduce pair of new helper functions to extract the common
code from do_utimes() and this:

  err = lookup_path_at(dfd, filename, atflags, &path, &file);
  /* do something with path */
  put_path_at(&path, file);

Thanks,
Miklos

> Signed-off-by: NeilBrown <neilb@suse.de>
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> ---
>  fs/stat.c |   30 ++++++++++++++++++++++--------
>  1 files changed, 22 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/stat.c b/fs/stat.c
> index c4ecd52..a66a0ef 100644
> --- a/fs/stat.c
> +++ b/fs/stat.c
> @@ -284,26 +284,40 @@ SYSCALL_DEFINE2(newfstat, unsigned int, fd, struct stat __user *, statbuf)
>  SYSCALL_DEFINE4(readlinkat, int, dfd, const char __user *, pathname,
>  		char __user *, buf, int, bufsiz)
>  {
> -	struct path path;
> -	int error;
> +	int error = 0, fput_needed;
> +	struct path path, *pp;
> +	struct file *file = NULL;
>  
>  	if (bufsiz <= 0)
>  		return -EINVAL;
>  
> -	error = user_path_at(dfd, pathname, 0, &path);
> +	if (pathname == NULL && dfd != AT_FDCWD) {
> +		file = fget_light(dfd, &fput_needed);
> +
> +		if (file)
> +			pp = &file->f_path;
> +		else
> +			error = -EBADF;
> +	} else {
> +		error = user_path_at(dfd, pathname, 0, &path);
> +		pp = &path;
> +	}
>  	if (!error) {
> -		struct inode *inode = path.dentry->d_inode;
> +		struct inode *inode = pp->dentry->d_inode;
>  
>  		error = -EINVAL;
>  		if (inode->i_op->readlink) {
> -			error = security_inode_readlink(path.dentry);
> +			error = security_inode_readlink(pp->dentry);
>  			if (!error) {
> -				touch_atime(path.mnt, path.dentry);
> -				error = inode->i_op->readlink(path.dentry,
> +				touch_atime(pp->mnt, pp->dentry);
> +				error = inode->i_op->readlink(pp->dentry,
>  							      buf, bufsiz);
>  			}
>  		}
> -		path_put(&path);
> +		if (file)
> +			fput_light(file, fput_needed);
> +		else
> +			path_put(&path);
>  	}
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
