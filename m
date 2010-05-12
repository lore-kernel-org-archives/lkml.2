Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755881Ab0ELXoi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 19:44:38 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57073 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752702Ab0ELXog (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 19:44:36 -0400
Date: Thu, 13 May 2010 09:44:22 +1000
From: Neil Brown <neilb@suse.de>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: hch@infradead.org, viro@zeniv.linux.org.uk, adilger@sun.com,
       corbet@lwn.net, serue@us.ibm.com, linux-fsdevel@vger.kernel.org,
       sfrench@us.ibm.com, philippe.deniel@CEA.FR,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -V7 4/9] vfs: Add open by file handle support
Message-ID: <20100513094422.0f7991a0@notabene.brown>
In-Reply-To: <1273679444-14903-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1273679444-14903-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	<1273679444-14903-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 May 2010 21:20:39 +0530
"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com> wrote:

> Acked-by: Serge Hallyn <serue@us.ibm.com>
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> ---
>  fs/namei.c            |   24 ---------
>  fs/open.c             |  136 +++++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/namei.h |   24 +++++++++
>  3 files changed, 160 insertions(+), 24 deletions(-)
> 
> diff --git a/fs/namei.c b/fs/namei.c
> index a7dce91..a18711e 100644
> --- a/fs/namei.c
> +++ b/fs/namei.c
> @@ -1521,30 +1521,6 @@ out_unlock:
>  	return may_open(&nd->path, 0, open_flag & ~O_TRUNC);
>  }
>  
> -/*
> - * Note that while the flag value (low two bits) for sys_open means:
> - *	00 - read-only
> - *	01 - write-only
> - *	10 - read-write
> - *	11 - special
> - * it is changed into
> - *	00 - no permissions needed
> - *	01 - read-permission
> - *	10 - write-permission
> - *	11 - read-write
> - * for the internal routines (ie open_namei()/follow_link() etc)
> - * This is more logical, and also allows the 00 "no perm needed"
> - * to be used for symlinks (where the permissions are checked
> - * later).
> - *
> -*/
> -static inline int open_to_namei_flags(int flag)
> -{
> -	if ((flag+1) & O_ACCMODE)
> -		flag++;
> -	return flag;
> -}
> -
>  static int open_will_truncate(int flag, struct inode *inode)
>  {
>  	/*
> diff --git a/fs/open.c b/fs/open.c
> index 9a34b81..348a1b9 100644
> --- a/fs/open.c
> +++ b/fs/open.c
> @@ -1315,3 +1315,139 @@ err_out:
>  	asmlinkage_protect(4, ret, dfd, name, handle, flag);
>  	return ret;
>  }
> +
> +static int vfs_dentry_acceptable(void *context, struct dentry *dentry)
> +{
> +	return 1;
> +}
> +
> +static struct dentry *handle_to_dentry(struct vfsmount *mnt,
> +				struct file_handle *handle)
> +{
> +	int handle_size;
> +	struct dentry *dentry;
> +
> +	/* change the handle size to multiple of sizeof(u32) */
> +	handle_size = handle->handle_size >> 2;
> +	dentry = exportfs_decode_fh(mnt, (struct fid *)handle->f_handle,
> +					handle_size, handle->handle_type,
> +					vfs_dentry_acceptable, NULL);
> +	return dentry;
> +}
> +
> +static long do_sys_open_by_handle(struct file_handle __user *ufh, int flags)
> +{
> +	int fd;
> +	int retval = 0;
> +	int d_flags  = flags;
> +	struct file *filp;
> +	struct vfsmount *mnt;
> +	struct inode *inode;
> +	struct dentry *dentry;
> +	struct file_handle f_handle;
> +	struct file_handle *handle = NULL;
> +
> +	if (copy_from_user(&f_handle, ufh, sizeof(struct file_handle))) {
> +		retval = -EFAULT;
> +		goto out_err;
> +	}
> +	if ((f_handle.handle_size > MAX_HANDLE_SZ) ||
> +		(f_handle.handle_size <= 0)) {
> +		retval =  -EINVAL;
> +		goto out_err;
> +	}
> +	if (!capable(CAP_DAC_OVERRIDE)) {
> +		retval = -EPERM;
> +		goto out_err;
> +	}
> +	/*
> +	 * Find the vfsmount for this uuid in the
> +	 * current namespace
> +	 */
> +	mnt = fs_get_vfsmount(current, &f_handle.fsid);
> +	if (!mnt) {
> +		retval = -ESTALE;
> +		goto out_err;
> +	}
> +
> +	handle = kmalloc(sizeof(struct file_handle) + f_handle.handle_size,
> +			GFP_KERNEL);
> +	if (!handle) {
> +		retval =  -ENOMEM;
> +		goto out_mnt;
> +	}
> +	/* copy the full handle */
> +	if (copy_from_user(handle, ufh,
> +				sizeof(struct file_handle) +
> +				f_handle.handle_size)) {
> +		retval = -EFAULT;
> +		goto out_mnt;
> +	}
> +	dentry = handle_to_dentry(mnt, handle);
> +	if (IS_ERR(dentry)) {
> +		retval = PTR_ERR(dentry);
> +		goto out_mnt;
> +	}
> +	inode = dentry->d_inode;
> +	flags  = open_to_namei_flags(flags);
> +	/* O_TRUNC implies we need access checks for write permissions */
> +	if (flags & O_TRUNC)
> +		flags |= MAY_WRITE;
> +
> +	if ((!(flags & O_APPEND) || (flags & O_TRUNC)) &&
> +		(flags & FMODE_WRITE) && IS_APPEND(inode)) {
> +		retval = -EPERM;
> +		goto out_dentry;
> +	}
> +	if ((flags & FMODE_WRITE) && IS_IMMUTABLE(inode)) {
> +		retval = -EACCES;
> +		goto out_dentry;
> +	}
> +	/* Can't write directories. */
> +	if (S_ISDIR(inode->i_mode) && (flags & FMODE_WRITE)) {
> +		retval = -EISDIR;
> +		goto out_dentry;
> +	}

Including all these checks inline here seems error prone.  Can you not just
use finish_open ??  It might do more than you need, but it would be more
obvious that you didn't forget anything..


> +	fd = get_unused_fd_flags(d_flags);
> +	if (fd < 0) {
> +		retval = fd;
> +		goto out_dentry;
> +	}
> +	filp = dentry_open(dget(dentry), mntget(mnt),
> +			d_flags, current_cred());
> +	if (IS_ERR(filp)) {
> +		put_unused_fd(fd);
> +		retval =  PTR_ERR(filp);
> +		goto out_dentry;
> +	}
> +	if (inode->i_mode & S_IFREG) {

I suspect this is not the test you want.  It tests for IFREG or IFLNK or
IFSOCK.

> +		filp->f_flags |= O_NOATIME;
> +		filp->f_mode |= FMODE_NOCMTIME;
> +	}

I think you need a comment here explaining the rational for these setting.
Why is O_NOATIME important IFREG but not for IFDIR?
Why is it not sufficient to honour O_NOATIME that is passed in.
How can you ever justify setting FMODE_NOCMTIME ?
I guess you are just copying from xfs code, but it still needs justification.


NeilBrown



> +	fsnotify_open(filp->f_path.dentry);
> +	fd_install(fd, filp);
> +	retval = fd;
> +
> +out_dentry:
> +	dput(dentry);
> +out_mnt:
> +	kfree(handle);
> +	mntput(mnt);
> +out_err:
> +	return retval;
> +}
> +
> +SYSCALL_DEFINE2(open_by_handle, struct file_handle __user *, handle,
> +		int, flags)
> +{
> +	long ret;
> +
> +	if (force_o_largefile())
> +		flags |= O_LARGEFILE;
> +
> +	ret = do_sys_open_by_handle(handle, flags);
> +
> +	/* avoid REGPARM breakage on x86: */
> +	asmlinkage_protect(2, ret, handle, flags);
> +	return ret;
> +}
> diff --git a/include/linux/namei.h b/include/linux/namei.h
> index 05b441d..a853aa0 100644
> --- a/include/linux/namei.h
> +++ b/include/linux/namei.h
> @@ -4,6 +4,7 @@
>  #include <linux/dcache.h>
>  #include <linux/linkage.h>
>  #include <linux/path.h>
> +#include <asm-generic/fcntl.h>
>  
>  struct vfsmount;
>  
> @@ -96,4 +97,27 @@ static inline void nd_terminate_link(void *name, size_t len, size_t maxlen)
>  	((char *) name)[min(len, maxlen)] = '\0';
>  }
>  
> +/*
> + * Note that while the flag value (low two bits) for sys_open means:
> + *	00 - read-only
> + *	01 - write-only
> + *	10 - read-write
> + *	11 - special
> + * it is changed into
> + *	00 - no permissions needed
> + *	01 - read-permission
> + *	10 - write-permission
> + *	11 - read-write
> + * for the internal routines (ie open_namei()/follow_link() etc)
> + * This is more logical, and also allows the 00 "no perm needed"
> + * to be used for symlinks (where the permissions are checked
> + * later).
> + *
> +*/
> +static inline int open_to_namei_flags(int flag)
> +{
> +	if ((flag+1) & O_ACCMODE)
> +		flag++;
> +	return flag;
> +}
>  #endif /* _LINUX_NAMEI_H */

