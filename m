Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755057Ab0GLIPu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 04:15:50 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:59752 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752402Ab0GLIPt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 04:15:49 -0400
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
CC: hch@infradead.org, viro@zeniv.linux.org.uk, adilger@sun.com,
        corbet@lwn.net, neilb@suse.de, npiggin@suse.de, hooanon05@yahoo.co.jp,
        bfields@fieldses.org, linux-fsdevel@vger.kernel.org,
        sfrench@us.ibm.com, philippe.deniel@CEA.FR,
        linux-kernel@vger.kernel.org, aneesh.kumar@linux.vnet.ibm.com
In-reply-to: <1278916545-19751-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH -V16 02/12] vfs: Add name to file handle conversion support
References: <1278916545-19751-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1278916545-19751-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Message-Id: <E1OYEAj-0005rI-9q@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 12 Jul 2010 10:15:29 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Jul 2010, Aneesh Kumar K.V wrote:
> The file handle also include mount id which can be used
> to lookup file system specific information such as uuid
> in /proc/<pid>mountinfo
> 
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> ---
>  fs/open.c                |  124 ++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/fs.h       |    9 +++
>  include/linux/syscalls.h |    5 ++-
>  3 files changed, 137 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/open.c b/fs/open.c
> index 5463266..7ad8f28 100644
> --- a/fs/open.c
> +++ b/fs/open.c
> @@ -29,6 +29,7 @@
>  #include <linux/falloc.h>
>  #include <linux/fs_struct.h>
>  #include <linux/ima.h>
> +#include <linux/exportfs.h>
>  
>  #include "internal.h"
>  
> @@ -1040,3 +1041,126 @@ int nonseekable_open(struct inode *inode, struct file *filp)
>  }
>  
>  EXPORT_SYMBOL(nonseekable_open);
> +
> +#ifdef CONFIG_EXPORTFS
> +/* limit the handle size to some value */
> +#define MAX_HANDLE_SZ 4096
> +static long do_sys_name_to_handle(struct path *path,
> +				  struct file_handle __user *ufh)
> +{
> +	long retval;
> +	int handle_size;
> +	struct file_handle f_handle;
> +	struct file_handle *handle = NULL;
> +
> +	if (copy_from_user(&f_handle, ufh, sizeof(struct file_handle))) {
> +		retval = -EFAULT;
> +		goto err_out;
> +	}
> +	if (f_handle.handle_size > MAX_HANDLE_SZ) {
> +		retval = -EINVAL;
> +		goto err_out;
> +	}
> +	handle = kmalloc(sizeof(struct file_handle) + f_handle.handle_size,
> +			 GFP_KERNEL);
> +	if (!handle) {
> +		retval = -ENOMEM;
> +		goto err_out;
> +	}
> +
> +	/* convert handle size to  multiple of sizeof(u32) */
> +	handle_size = f_handle.handle_size >> 2;
> +
> +	/* we ask for a non connected handle */
> +	retval = exportfs_encode_fh(path->dentry,
> +				    (struct fid *)handle->f_handle,
> +				    &handle_size,  0);
> +	/* convert handle size to bytes */
> +	handle_size *= sizeof(u32);
> +	handle->handle_type = retval;
> +	handle->handle_size = handle_size;
> +	/* copy the mount id */
> +	handle->mnt_id = path->mnt->mnt_id;
> +	if (handle_size > f_handle.handle_size) {
> +		/*
> +		 * set the handle_size to zero so we copy only
> +		 * non variable part of the file_handle
> +		 */
> +		handle_size = 0;
> +		retval = -EOVERFLOW;
> +	} else
> +		retval = 0;
> +	if (copy_to_user(ufh, handle,
> +			 sizeof(struct file_handle) + handle_size))
> +		retval = -EFAULT;
> +
> +	kfree(handle);
> +err_out:
> +	return retval;
> +}
> +
> +/**
> + * sys_name_to_handle_at: convert name to handle
> + * @dfd: directory relative to which name is interpreted if not absolute
> + * @name: name that should be converted to handle.
> + * @handle: resulting file handle
> + * @flag: flag value to indicate whether to follow symlink or not
> + *
> + * @handle->handle_size indicate the space available to store the
> + * variable part of the file handle in bytes. If there is not
> + * enough space, the field is updated to return the minimum
> + * value required.
> + */
> +SYSCALL_DEFINE4(name_to_handle_at, int, dfd, const char __user *, name,
> +		struct file_handle __user *, handle, int, flag)
> +{
> +
> +	int follow;
> +	int fput_needed;
> +	long ret = -EINVAL;
> +	struct path path, *pp;
> +	struct file *file = NULL;
> +
> +	if ((flag & ~AT_SYMLINK_FOLLOW) != 0)
> +		goto err_out;
> +
> +	if (name == NULL && dfd != AT_FDCWD) {
> +		file = fget_light(dfd, &fput_needed);
> +		if (file) {
> +			pp = &file->f_path;
> +			ret = 0;
> +		} else
> +			ret = -EBADF;
> +	} else {
> +		follow = (flag & AT_SYMLINK_FOLLOW) ? LOOKUP_FOLLOW : 0;
> +		ret = user_path_at(dfd, name, follow, &path);
> +		pp = &path;
> +	}
> +	if (ret)
> +		goto err_out;
> +	/*
> +	 * We need t make sure wether the file system
> +	 * support decoding of the file handle
> +	 */
> +	if (!pp->mnt->mnt_sb->s_export_op ||
> +	    !pp->mnt->mnt_sb->s_export_op->fh_to_dentry) {
> +		ret = -EOPNOTSUPP;
> +		goto out_path;
> +	}
> +	ret = do_sys_name_to_handle(pp, handle);
> +
> +out_path:
> +	if (file)
> +		fput_light(file, fput_needed);
> +	else
> +		path_put(&path);
> +err_out:
> +	return ret;
> +}
> +#else
> +SYSCALL_DEFINE4(name_to_handle_at, int, dfd, const char __user *, name,
> +		struct file_handle __user *, handle, int, flag)
> +{
> +	return -ENOSYS;
> +}
> +#endif
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 471e1ff..0e7cf4c 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -949,6 +949,15 @@ struct file {
>  	unsigned long f_mnt_write_state;
>  #endif
>  };
> +
> +struct file_handle {
> +	int mnt_id;

The mount id is not part of the handle in that it's not used when
converting back a handle to a file descriptor.  So it shouldn't be
included here.

The uuid can be looked up based on st_dev.

> +	int handle_size;
> +	int handle_type;
> +	/* file identifier */
> +	unsigned char f_handle[0];
> +};
> +
>  extern spinlock_t files_lock;
>  #define file_list_lock() spin_lock(&files_lock);
>  #define file_list_unlock() spin_unlock(&files_lock);
> diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
> index 7f614ce..9d6d6e3 100644
> --- a/include/linux/syscalls.h
> +++ b/include/linux/syscalls.h
> @@ -61,6 +61,7 @@ struct robust_list_head;
>  struct getcpu_cache;
>  struct old_linux_dirent;
>  struct perf_event_attr;
> +struct file_handle;
>  
>  #include <linux/types.h>
>  #include <linux/aio_abi.h>
> @@ -823,5 +824,7 @@ asmlinkage long sys_mmap_pgoff(unsigned long addr, unsigned long len,
>  			unsigned long prot, unsigned long flags,
>  			unsigned long fd, unsigned long pgoff);
>  asmlinkage long sys_old_mmap(struct mmap_arg_struct __user *arg);
> -
> +asmlinkage long sys_name_to_handle_at(int dfd, const char __user *name,
> +				      struct file_handle __user *handle,
> +				      int flag);
>  #endif
> -- 
> 1.7.2.rc1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
