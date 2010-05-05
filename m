Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933790Ab0EEOjk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 10:39:40 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54548 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760088Ab0EEOjj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 10:39:39 -0400
Date: Wed, 5 May 2010 16:39:31 +0200
From: Jan Kara <jack@suse.cz>
To: John Kacur <jkacur@redhat.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>, Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 6/6] udf: BKL ioctl pushdown
Message-ID: <20100505143931.GB3938@quack.suse.cz>
References: <1273065339-21669-1-git-send-email-jkacur@redhat.com>
 <1273065339-21669-7-git-send-email-jkacur@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1273065339-21669-7-git-send-email-jkacur@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 05-05-10 15:15:39, John Kacur wrote:
> Convert udf_ioctl to an unlocked_ioctl and push the BKL down into it.
  Thanks. Merged into UDF tree.

								Honza

> 
> Signed-off-by: John Kacur <jkacur@redhat.com
> ---
>  fs/udf/dir.c     |    2 +-
>  fs/udf/file.c    |   43 +++++++++++++++++++++++++++----------------
>  fs/udf/udfdecl.h |    3 +--
>  3 files changed, 29 insertions(+), 19 deletions(-)
> 
> diff --git a/fs/udf/dir.c b/fs/udf/dir.c
> index f0f2a43..3a84455 100644
> --- a/fs/udf/dir.c
> +++ b/fs/udf/dir.c
> @@ -209,6 +209,6 @@ static int udf_readdir(struct file *filp, void *dirent, filldir_t filldir)
>  const struct file_operations udf_dir_operations = {
>  	.read			= generic_read_dir,
>  	.readdir		= udf_readdir,
> -	.ioctl			= udf_ioctl,
> +	.unlocked_ioctl		= udf_ioctl,
>  	.fsync			= simple_fsync,
>  };
> diff --git a/fs/udf/file.c b/fs/udf/file.c
> index 4b6a46c..83092fb 100644
> --- a/fs/udf/file.c
> +++ b/fs/udf/file.c
> @@ -37,6 +37,7 @@
>  #include <linux/quotaops.h>
>  #include <linux/buffer_head.h>
>  #include <linux/aio.h>
> +#include <linux/smp_lock.h>
>  
>  #include "udf_i.h"
>  #include "udf_sb.h"
> @@ -144,50 +145,60 @@ static ssize_t udf_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
>  	return retval;
>  }
>  
> -int udf_ioctl(struct inode *inode, struct file *filp, unsigned int cmd,
> -	      unsigned long arg)
> +long udf_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
>  {
> +	struct inode *inode = filp->f_dentry->d_inode;
>  	long old_block, new_block;
>  	int result = -EINVAL;
>  
> +	lock_kernel();
> +
>  	if (file_permission(filp, MAY_READ) != 0) {
> -		udf_debug("no permission to access inode %lu\n",
> -			  inode->i_ino);
> -		return -EPERM;
> +		udf_debug("no permission to access inode %lu\n", inode->i_ino);
> +		result = -EPERM;
> +		goto out;
>  	}
>  
>  	if (!arg) {
>  		udf_debug("invalid argument to udf_ioctl\n");
> -		return -EINVAL;
> +		result = -EINVAL;
> +		goto out;
>  	}
>  
>  	switch (cmd) {
>  	case UDF_GETVOLIDENT:
>  		if (copy_to_user((char __user *)arg,
>  				 UDF_SB(inode->i_sb)->s_volume_ident, 32))
> -			return -EFAULT;
> +			result = -EFAULT;
>  		else
> -			return 0;
> +			result = 0;
> +		goto out;
>  	case UDF_RELOCATE_BLOCKS:
> -		if (!capable(CAP_SYS_ADMIN))
> -			return -EACCES;
> -		if (get_user(old_block, (long __user *)arg))
> -			return -EFAULT;
> +		if (!capable(CAP_SYS_ADMIN)) {
> +			result = -EACCES;
> +			goto out;
> +		}
> +		if (get_user(old_block, (long __user *)arg)) {
> +			result = -EFAULT;
> +			goto out;
> +		}
>  		result = udf_relocate_blocks(inode->i_sb,
>  						old_block, &new_block);
>  		if (result == 0)
>  			result = put_user(new_block, (long __user *)arg);
> -		return result;
> +		goto out;
>  	case UDF_GETEASIZE:
>  		result = put_user(UDF_I(inode)->i_lenEAttr, (int __user *)arg);
> -		break;
> +		goto out;
>  	case UDF_GETEABLOCK:
>  		result = copy_to_user((char __user *)arg,
>  				      UDF_I(inode)->i_ext.i_data,
>  				      UDF_I(inode)->i_lenEAttr) ? -EFAULT : 0;
> -		break;
> +		goto out;
>  	}
>  
> +out:
> +	unlock_kernel();
>  	return result;
>  }
>  
> @@ -207,7 +218,7 @@ static int udf_release_file(struct inode *inode, struct file *filp)
>  const struct file_operations udf_file_operations = {
>  	.read			= do_sync_read,
>  	.aio_read		= generic_file_aio_read,
> -	.ioctl			= udf_ioctl,
> +	.unlocked_ioctl		= udf_ioctl,
>  	.open			= dquot_file_open,
>  	.mmap			= generic_file_mmap,
>  	.write			= do_sync_write,
> diff --git a/fs/udf/udfdecl.h b/fs/udf/udfdecl.h
> index 702a114..9079ff7 100644
> --- a/fs/udf/udfdecl.h
> +++ b/fs/udf/udfdecl.h
> @@ -130,8 +130,7 @@ extern int udf_write_fi(struct inode *inode, struct fileIdentDesc *,
>  			uint8_t *, uint8_t *);
>  
>  /* file.c */
> -extern int udf_ioctl(struct inode *, struct file *, unsigned int,
> -		     unsigned long);
> +extern long udf_ioctl(struct file *, unsigned int, unsigned long);
>  extern int udf_setattr(struct dentry *dentry, struct iattr *iattr);
>  /* inode.c */
>  extern struct inode *udf_iget(struct super_block *, struct kernel_lb_addr *);
> -- 
> 1.6.6.1
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
