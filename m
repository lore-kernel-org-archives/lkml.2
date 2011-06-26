Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754479Ab1FZRPU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jun 2011 13:15:20 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:58355 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754312Ab1FZRNq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jun 2011 13:13:46 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH] [media] v4l2 core: return -ENOIOCTLCMD if an ioctl doesn't exist
Date: Sun, 26 Jun 2011 19:13:05 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc1nosema+; KDE/4.6.3; x86_64; ; )
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
References: <4E0519B7.3000304@redhat.com> <4E0752E0.5030901@iki.fi> <4E075C45.3010200@redhat.com>
In-Reply-To: <4E075C45.3010200@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106261913.05752.arnd@arndb.de>
X-Provags-ID: V02:K0:G4YOQEo4k+vzRKKbRd5yX5OQB/h+uv71yY5MSXWXjLq
 /qmEXzZHD/vkAcQlW0r/FyqzZK6ZwGOzpeCpc7GU0XyEzOOBBl
 TYg7zizQWeVJ35bM+apdftioNxjvLIMlVjQ0S25qiS1JGV90+Y
 3SRKQYNFcJHGyQQjV7IU13CJbY4F4hg1ddsPOEhRgiCYGv8fDL
 VDScFZ8kRXZSM9egOizrw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 26 June 2011 18:20:21 Mauro Carvalho Chehab wrote:

> > The V4L2 core probably should return -ENOIOCTLCMD when an IOCTL isn't implemented, but as long as vfs_ioctl() would stay as it is, the user space would still get -EINVAL. Or is vfs_ioctl() about to change?
> > 
> > fs/ioctl.c:
> > ----8<-----------
> > static long vfs_ioctl(struct file *filp, unsigned int cmd,
> >                       unsigned long arg)
> > {
> >         int error = -ENOTTY;
> > 
> >         if (!filp->f_op || !filp->f_op->unlocked_ioctl)
> >                 goto out;
> > 
> >         error = filp->f_op->unlocked_ioctl(filp, cmd, arg);
> >         if (error == -ENOIOCTLCMD)
> >                 error = -EINVAL;
> >  out:
> >         return error;
> > }
> > ----8<-----------

One of the differences between the old ->ioctl() and the ->unlocked_ioctl()
function is that unlocked_ioctl could point to the same function as
->compat_ioctl(), so we have to catch functions returning -ENOIOCTLCMD.

> Good catch!
> 
> At the recent git history, the return for -ENOIOCTLCMD were modified
> by this changeset:
> 
> commit b19dd42faf413b4705d4adb38521e82d73fa4249
> Author: Arnd Bergmann <arnd@arndb.de>
> Date:   Sun Jul 4 00:15:10 2010 +0200
> 
>     bkl: Remove locked .ioctl file operation
> ...
> @@ -39,21 +38,12 @@ static long vfs_ioctl(struct file *filp, unsigned int cmd,
>  {
>         int error = -ENOTTY;
>  
> -   if (!filp->f_op)
> + if (!filp->f_op || !filp->f_op->unlocked_ioctl)
>                 goto out;
>  
> -   if (filp->f_op->unlocked_ioctl) {
> -           error = filp->f_op->unlocked_ioctl(filp, cmd, arg);
> -           if (error == -ENOIOCTLCMD)
> -                   error = -EINVAL;
> -           goto out;
> -   } else if (filp->f_op->ioctl) {
> -           lock_kernel();
> -           error = filp->f_op->ioctl(filp->f_path.dentry->d_inode,
> -                                     filp, cmd, arg);
> -           unlock_kernel();
> ...
> 
> Before Arnd's patch, locked ioctl's were returning -ENOIOCTLCMD, and
> unlocked ones were returning -EINVAL. Now, the return of -ENOIOCTLCMD
> doesn't go to userspace anymore. IMO, that's wrong and can cause
> regressions, as some subsystems like DVB were returning -ENOIOCTLCMD
> to userspace.

ENOIOCTLCMD should never be returned to user space, see the comment
in include/linux/errno.h:

/*
 * These should never be seen by user programs.  To return one of ERESTART*
 * codes, signal_pending() MUST be set.  Note that ptrace can observe these
 * at syscall exit tracing, but they will never be left for the debugged user
 * process to see.
 */

There was a lot of debate whether undefined ioctls on non-ttys should
return -EINVAL or -ENOTTY, including mass-conversions from -ENOTTY to
-EINVAL at some point in the pre-git era, IIRC.

Inside of v4l2, I believe this is handled by video_usercopy(), which
turns the driver's -ENOIOCTLCMD into -ENOTTY. What cases do you observe
where this is not done correctly and we do return ENOIOCTLCMD to
vfs_ioctl?

> The right fix would be to remove this from fs:
> 
> diff --git a/fs/ioctl.c b/fs/ioctl.c
> index 1d9b9fc..802fbbd 100644
> --- a/fs/ioctl.c
> +++ b/fs/ioctl.c
> @@ -41,8 +41,6 @@ static long vfs_ioctl(struct file *filp, unsigned int cmd,
>  		goto out;
>  
>  	error = filp->f_op->unlocked_ioctl(filp, cmd, arg);
> -	if (error == -ENOIOCTLCMD)
> -		error = -EINVAL;
>   out:
>  	return error;
>  }
> 
> However, the replacement from -EINVAL to -ENOIOCTLCMD is there since 2.6.12 for
> unlocked_ioctl:
> 
> $ git blame b19dd42f^1 fs/ioctl.c 
> ...
> ^1da177e (Linus Torvalds    2005-04-16 15:20:36 -0700  46)              error = filp->f_op->unlocked_ioctl(filp, cmd, arg);
> ^1da177e (Linus Torvalds    2005-04-16 15:20:36 -0700  47)              if (error == -ENOIOCTLCMD)
> ^1da177e (Linus Torvalds    2005-04-16 15:20:36 -0700  48)                      error = -EINVAL;
> 
> Linus,
> 
> what would be the expected behaviour?

Note that 1da177e is the initial commit to git, Linus did not write that
code, although he might have an opinion.

	Arnd
