Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754817Ab0EERe4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 13:34:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59046 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751670Ab0EERey (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 13:34:54 -0400
Date: Wed, 5 May 2010 19:34:27 +0200 (CEST)
From: John Kacur <jkacur@redhat.com>
X-X-Sender: jkacur@localhost.localdomain
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
cc: lkml <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 3/6] fat: BKL ioctl pushdown
In-Reply-To: <8739y6xrl6.fsf@devron.myhome.or.jp>
Message-ID: <alpine.LFD.2.00.1005051927210.6285@localhost.localdomain>
References: <1273065339-21669-1-git-send-email-jkacur@redhat.com> <1273065339-21669-4-git-send-email-jkacur@redhat.com> <8739y6xrl6.fsf@devron.myhome.or.jp>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 6 May 2010, OGAWA Hirofumi wrote:

> John Kacur <jkacur@redhat.com> writes:
> 
> > Convert fat_generic_ioctl and fat_dir_ioctl to unlocked_ioctls
> > and push down the bkl into those functions.
> 
> I guess this is the part of batch ioctl conversion stuff though, those
> ioctl of FAT don't need BKL at all. Because all of those should already
> be protected by inode->i_mutex.
> 
> Removing BKL and then cleanup after this patch would be almost same with
> reverting this patch. So, could you just convert to unlocked_ioctl
> instead?

That's probably not a good idea, without a little bit more analysis, 
otherwise it's quite easy to introduce subtle bugs.

> 
> Thanks.
> 
> > Signed-off-by: John Kacur <jkacur@redhat.com>
> > ---
> >  fs/fat/dir.c  |   36 ++++++++++++++++++++++++------------
> >  fs/fat/fat.h  |    3 +--
> >  fs/fat/file.c |   22 ++++++++++++++++------
> >  3 files changed, 41 insertions(+), 20 deletions(-)
> >
> > diff --git a/fs/fat/dir.c b/fs/fat/dir.c
> > index 530b4ca..1b73e60 100644
> > --- a/fs/fat/dir.c
> > +++ b/fs/fat/dir.c
> > @@ -19,6 +19,7 @@
> >  #include <linux/buffer_head.h>
> >  #include <linux/compat.h>
> >  #include <asm/uaccess.h>
> > +#include <linux/smp_lock.h>
> >  #include "fat.h"
> >  
> >  /*
> > @@ -737,10 +738,11 @@ efault:									   \
> >  
> >  FAT_IOCTL_FILLDIR_FUNC(fat_ioctl_filldir, __fat_dirent)
> >  
> > -static int fat_ioctl_readdir(struct inode *inode, struct file *filp,
> > +static long fat_ioctl_readdir(struct file *filp,
> >  			     void __user *dirent, filldir_t filldir,
> >  			     int short_only, int both)
> >  {
> > +	struct inode *inode = filp->f_dentry->d_inode;
> >  	struct fat_ioctl_filldir_callback buf;
> >  	int ret;
> >  
> > @@ -758,9 +760,10 @@ static int fat_ioctl_readdir(struct inode *inode, struct file *filp,
> >  	return ret;
> >  }
> >  
> > -static int fat_dir_ioctl(struct inode *inode, struct file *filp,
> > -			 unsigned int cmd, unsigned long arg)
> > +static long fat_dir_ioctl(struct file *filp, unsigned int cmd,
> > +			unsigned long arg)
> >  {
> > +	long error;
> >  	struct __fat_dirent __user *d1 = (struct __fat_dirent __user *)arg;
> >  	int short_only, both;
> >  
> > @@ -774,21 +777,31 @@ static int fat_dir_ioctl(struct inode *inode, struct file *filp,
> >  		both = 1;
> >  		break;
> >  	default:
> > -		return fat_generic_ioctl(inode, filp, cmd, arg);
> > +		lock_kernel();
> > +		error = fat_generic_ioctl(filp, cmd, arg);
> > +		goto out;
> >  	}
> >  
> > -	if (!access_ok(VERIFY_WRITE, d1, sizeof(struct __fat_dirent[2])))
> > -		return -EFAULT;
> > +	lock_kernel();
> > +	if (!access_ok(VERIFY_WRITE, d1, sizeof(struct __fat_dirent[2]))) {
> > +		error = -EFAULT;
> > +		goto out;
> > +	}
> >  	/*
> >  	 * Yes, we don't need this put_user() absolutely. However old
> >  	 * code didn't return the right value. So, app use this value,
> >  	 * in order to check whether it is EOF.
> >  	 */
> > -	if (put_user(0, &d1->d_reclen))
> > -		return -EFAULT;
> > +	if (put_user(0, &d1->d_reclen)) {
> > +		error = -EFAULT;
> > +		goto out;
> > +	}
> >  
> > -	return fat_ioctl_readdir(inode, filp, d1, fat_ioctl_filldir,
> > +	error = fat_ioctl_readdir(filp, d1, fat_ioctl_filldir,
> >  				 short_only, both);
> > +out:
> > +	unlock_kernel();
> > +	return error;
> >  }
> >  
> >  #ifdef CONFIG_COMPAT
> > @@ -800,7 +813,6 @@ FAT_IOCTL_FILLDIR_FUNC(fat_compat_ioctl_filldir, compat_dirent)
> >  static long fat_compat_dir_ioctl(struct file *filp, unsigned cmd,
> >  				 unsigned long arg)
> >  {
> > -	struct inode *inode = filp->f_path.dentry->d_inode;
> >  	struct compat_dirent __user *d1 = compat_ptr(arg);
> >  	int short_only, both;
> >  
> > @@ -827,7 +839,7 @@ static long fat_compat_dir_ioctl(struct file *filp, unsigned cmd,
> >  	if (put_user(0, &d1->d_reclen))
> >  		return -EFAULT;
> >  
> > -	return fat_ioctl_readdir(inode, filp, d1, fat_compat_ioctl_filldir,
> > +	return fat_ioctl_readdir(filp, d1, fat_compat_ioctl_filldir,
> >  				 short_only, both);
> >  }
> >  #endif /* CONFIG_COMPAT */
> > @@ -836,7 +848,7 @@ const struct file_operations fat_dir_operations = {
> >  	.llseek		= generic_file_llseek,
> >  	.read		= generic_read_dir,
> >  	.readdir	= fat_readdir,
> > -	.ioctl		= fat_dir_ioctl,
> > +	.unlocked_ioctl	= fat_dir_ioctl,
> >  #ifdef CONFIG_COMPAT
> >  	.compat_ioctl	= fat_compat_dir_ioctl,
> >  #endif
> > diff --git a/fs/fat/fat.h b/fs/fat/fat.h
> > index e6efdfa..23f9b2a 100644
> > --- a/fs/fat/fat.h
> > +++ b/fs/fat/fat.h
> > @@ -298,8 +298,7 @@ extern int fat_free_clusters(struct inode *inode, int cluster);
> >  extern int fat_count_free_clusters(struct super_block *sb);
> >  
> >  /* fat/file.c */
> > -extern int fat_generic_ioctl(struct inode *inode, struct file *filp,
> > -			     unsigned int cmd, unsigned long arg);
> > +extern long fat_generic_ioctl(struct file *filp, unsigned int cmd, unsigned long arg);
> >  extern const struct file_operations fat_file_operations;
> >  extern const struct inode_operations fat_file_inode_operations;
> >  extern int fat_setattr(struct dentry * dentry, struct iattr * attr);
> > diff --git a/fs/fat/file.c b/fs/fat/file.c
> > index e8c159d..4f3044f 100644
> > --- a/fs/fat/file.c
> > +++ b/fs/fat/file.c
> > @@ -16,6 +16,7 @@
> >  #include <linux/blkdev.h>
> >  #include <linux/fsnotify.h>
> >  #include <linux/security.h>
> > +#include <linux/smp_lock.h>
> >  #include "fat.h"
> >  
> >  static int fat_ioctl_get_attributes(struct inode *inode, u32 __user *user_attr)
> > @@ -114,19 +115,28 @@ out:
> >  	return err;
> >  }
> >  
> > -int fat_generic_ioctl(struct inode *inode, struct file *filp,
> > -		      unsigned int cmd, unsigned long arg)
> > +long fat_generic_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
> >  {
> > +	long error;
> > +	struct inode *inode = filp->f_dentry->d_inode;
> >  	u32 __user *user_attr = (u32 __user *)arg;
> >  
> > +	lock_kernel();
> > +
> >  	switch (cmd) {
> >  	case FAT_IOCTL_GET_ATTRIBUTES:
> > -		return fat_ioctl_get_attributes(inode, user_attr);
> > +		error = fat_ioctl_get_attributes(inode, user_attr);
> > +		break;
> >  	case FAT_IOCTL_SET_ATTRIBUTES:
> > -		return fat_ioctl_set_attributes(filp, user_attr);
> > +		error = fat_ioctl_set_attributes(filp, user_attr);
> > +		break;
> >  	default:
> > -		return -ENOTTY;	/* Inappropriate ioctl for device */
> > +		error = -ENOTTY;	/* Inappropriate ioctl for device */
> > +		break;
> >  	}
> > +
> > +	unlock_kernel();
> > +	return error;
> >  }
> >  
> >  static int fat_file_release(struct inode *inode, struct file *filp)
> > @@ -159,7 +169,7 @@ const struct file_operations fat_file_operations = {
> >  	.aio_write	= generic_file_aio_write,
> >  	.mmap		= generic_file_mmap,
> >  	.release	= fat_file_release,
> > -	.ioctl		= fat_generic_ioctl,
> > +	.unlocked_ioctl = fat_generic_ioctl,
> >  	.fsync		= fat_file_fsync,
> >  	.splice_read	= generic_file_splice_read,
> >  };
> 
> -- 
> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
