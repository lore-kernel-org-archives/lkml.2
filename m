Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755072Ab0GLJdX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 05:33:23 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:58538 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753118Ab0GLJdV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 05:33:21 -0400
From: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: hch@infradead.org, viro@zeniv.linux.org.uk, adilger@sun.com,
        corbet@lwn.net, neilb@suse.de, npiggin@suse.de, hooanon05@yahoo.co.jp,
        bfields@fieldses.org, linux-fsdevel@vger.kernel.org,
        sfrench@us.ibm.com, philippe.deniel@CEA.FR,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -V16 02/12] vfs: Add name to file handle conversion support
In-Reply-To: <E1OYEAj-0005rI-9q@pomaz-ex.szeredi.hu>
References: <1278916545-19751-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1278916545-19751-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <E1OYEAj-0005rI-9q@pomaz-ex.szeredi.hu>
User-Agent: Notmuch/ (http://notmuchmail.org) Emacs/24.0.50.1 (i686-pc-linux-gnu)
Date: Mon, 12 Jul 2010 15:03:10 +0530
Message-ID: <87hbk5yrhl.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Jul 2010 10:15:29 +0200, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Mon, 12 Jul 2010, Aneesh Kumar K.V wrote:
> > The file handle also include mount id which can be used
> > to lookup file system specific information such as uuid
> > in /proc/<pid>mountinfo
> > 
> > Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> > ---
> >  fs/open.c                |  124 ++++++++++++++++++++++++++++++++++++++++++++++
> >  include/linux/fs.h       |    9 +++
> >  include/linux/syscalls.h |    5 ++-
> >  3 files changed, 137 insertions(+), 1 deletions(-)
> > 
> > diff --git a/fs/open.c b/fs/open.c
> > index 5463266..7ad8f28 100644
> > --- a/fs/open.c
> > +++ b/fs/open.c
> > @@ -29,6 +29,7 @@
> >  #include <linux/falloc.h>
> >  #include <linux/fs_struct.h>
> >  #include <linux/ima.h>
> > +#include <linux/exportfs.h>
> >  
> >  #include "internal.h"
> >  
> > @@ -1040,3 +1041,126 @@ int nonseekable_open(struct inode *inode, struct file *filp)
> >  }
> >  
> >  EXPORT_SYMBOL(nonseekable_open);
> > +
> > +#ifdef CONFIG_EXPORTFS
> > +/* limit the handle size to some value */
> > +#define MAX_HANDLE_SZ 4096
> > +static long do_sys_name_to_handle(struct path *path,
> > +				  struct file_handle __user *ufh)
> > +{
> > +	long retval;
> > +	int handle_size;
> > +	struct file_handle f_handle;
> > +	struct file_handle *handle = NULL;
> > +
> > +	if (copy_from_user(&f_handle, ufh, sizeof(struct file_handle))) {
> > +		retval = -EFAULT;
> > +		goto err_out;
> > +	}
> > +	if (f_handle.handle_size > MAX_HANDLE_SZ) {
> > +		retval = -EINVAL;
> > +		goto err_out;
> > +	}
> > +	handle = kmalloc(sizeof(struct file_handle) + f_handle.handle_size,
> > +			 GFP_KERNEL);
> > +	if (!handle) {
> > +		retval = -ENOMEM;
> > +		goto err_out;
> > +	}
> > +
> > +	/* convert handle size to  multiple of sizeof(u32) */
> > +	handle_size = f_handle.handle_size >> 2;
> > +
> > +	/* we ask for a non connected handle */
> > +	retval = exportfs_encode_fh(path->dentry,
> > +				    (struct fid *)handle->f_handle,
> > +				    &handle_size,  0);
> > +	/* convert handle size to bytes */
> > +	handle_size *= sizeof(u32);
> > +	handle->handle_type = retval;
> > +	handle->handle_size = handle_size;
> > +	/* copy the mount id */
> > +	handle->mnt_id = path->mnt->mnt_id;
> > +	if (handle_size > f_handle.handle_size) {
> > +		/*
> > +		 * set the handle_size to zero so we copy only
> > +		 * non variable part of the file_handle
> > +		 */
> > +		handle_size = 0;
> > +		retval = -EOVERFLOW;
> > +	} else
> > +		retval = 0;
> > +	if (copy_to_user(ufh, handle,
> > +			 sizeof(struct file_handle) + handle_size))
> > +		retval = -EFAULT;
> > +
> > +	kfree(handle);
> > +err_out:
> > +	return retval;
> > +}
> > +
> > +/**
> > + * sys_name_to_handle_at: convert name to handle
> > + * @dfd: directory relative to which name is interpreted if not absolute
> > + * @name: name that should be converted to handle.
> > + * @handle: resulting file handle
> > + * @flag: flag value to indicate whether to follow symlink or not
> > + *
> > + * @handle->handle_size indicate the space available to store the
> > + * variable part of the file handle in bytes. If there is not
> > + * enough space, the field is updated to return the minimum
> > + * value required.
> > + */
> > +SYSCALL_DEFINE4(name_to_handle_at, int, dfd, const char __user *, name,
> > +		struct file_handle __user *, handle, int, flag)
> > +{
> > +
> > +	int follow;
> > +	int fput_needed;
> > +	long ret = -EINVAL;
> > +	struct path path, *pp;
> > +	struct file *file = NULL;
> > +
> > +	if ((flag & ~AT_SYMLINK_FOLLOW) != 0)
> > +		goto err_out;
> > +
> > +	if (name == NULL && dfd != AT_FDCWD) {
> > +		file = fget_light(dfd, &fput_needed);
> > +		if (file) {
> > +			pp = &file->f_path;
> > +			ret = 0;
> > +		} else
> > +			ret = -EBADF;
> > +	} else {
> > +		follow = (flag & AT_SYMLINK_FOLLOW) ? LOOKUP_FOLLOW : 0;
> > +		ret = user_path_at(dfd, name, follow, &path);
> > +		pp = &path;
> > +	}
> > +	if (ret)
> > +		goto err_out;
> > +	/*
> > +	 * We need t make sure wether the file system
> > +	 * support decoding of the file handle
> > +	 */
> > +	if (!pp->mnt->mnt_sb->s_export_op ||
> > +	    !pp->mnt->mnt_sb->s_export_op->fh_to_dentry) {
> > +		ret = -EOPNOTSUPP;
> > +		goto out_path;
> > +	}
> > +	ret = do_sys_name_to_handle(pp, handle);
> > +
> > +out_path:
> > +	if (file)
> > +		fput_light(file, fput_needed);
> > +	else
> > +		path_put(&path);
> > +err_out:
> > +	return ret;
> > +}
> > +#else
> > +SYSCALL_DEFINE4(name_to_handle_at, int, dfd, const char __user *, name,
> > +		struct file_handle __user *, handle, int, flag)
> > +{
> > +	return -ENOSYS;
> > +}
> > +#endif
> > diff --git a/include/linux/fs.h b/include/linux/fs.h
> > index 471e1ff..0e7cf4c 100644
> > --- a/include/linux/fs.h
> > +++ b/include/linux/fs.h
> > @@ -949,6 +949,15 @@ struct file {
> >  	unsigned long f_mnt_write_state;
> >  #endif
> >  };
> > +
> > +struct file_handle {
> > +	int mnt_id;
> 
> The mount id is not part of the handle in that it's not used when
> converting back a handle to a file descriptor.  So it shouldn't be
> included here.
> 
> The uuid can be looked up based on st_dev.
>

That would include another stat call on the file to get the st_dev ? As
per the last review (Message-id:20100708082143.3701bfc7@notabene.brown)
http://article.gmane.org/gmane.linux.kernel/1007385 we discussed that
it would be nice to add st_dev as a part of handle. Later I suggested
it would be nice to get mount_id instead of st_dev because st_dev is
not stable (against remounts) for file system that doesn't have a
backing device. So instead of using something that is partially stable,
add mnt_id which is explicitly stated to be unstable across remounts.

If you are against having mount_id as a part of struct file_handle, do
you think we could add it as a extra argument to syscall ? 

-aneesh
