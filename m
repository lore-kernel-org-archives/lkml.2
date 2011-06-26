Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754151Ab1FZQU4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jun 2011 12:20:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10894 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754097Ab1FZQUj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jun 2011 12:20:39 -0400
Message-ID: <4E075C45.3010200@redhat.com>
Date: Sun, 26 Jun 2011 13:20:21 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Thunderbird/3.1.10
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] [media] v4l2 core: return -ENOIOCTLCMD if an ioctl doesn't
 exist
References: <4E0519B7.3000304@redhat.com> <4E0752E0.5030901@iki.fi>
In-Reply-To: <4E0752E0.5030901@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sakari,

Em 26-06-2011 12:40, Sakari Ailus escreveu:
> Mauro Carvalho Chehab wrote:
>> Currently, -EINVAL is used to return either when an IOCTL is not
>> implemented, or if the ioctl was not implemented.
> 
> Hi Mauro,
> 
> Thanks for the patch.
> 
> The V4L2 core probably should return -ENOIOCTLCMD when an IOCTL isn't implemented, but as long as vfs_ioctl() would stay as it is, the user space would still get -EINVAL. Or is vfs_ioctl() about to change?
> 
> fs/ioctl.c:
> ----8<-----------
> static long vfs_ioctl(struct file *filp, unsigned int cmd,
>                       unsigned long arg)
> {
>         int error = -ENOTTY;
> 
>         if (!filp->f_op || !filp->f_op->unlocked_ioctl)
>                 goto out;
> 
>         error = filp->f_op->unlocked_ioctl(filp, cmd, arg);
>         if (error == -ENOIOCTLCMD)
>                 error = -EINVAL;
>  out:
>         return error;
> }
> ----8<-----------
> 

Good catch!

At the recent git history, the return for -ENOIOCTLCMD were modified
by this changeset:

commit b19dd42faf413b4705d4adb38521e82d73fa4249
Author: Arnd Bergmann <arnd@arndb.de>
Date:   Sun Jul 4 00:15:10 2010 +0200

    bkl: Remove locked .ioctl file operation
...
@@ -39,21 +38,12 @@ static long vfs_ioctl(struct file *filp, unsigned int cmd,
 {
        int error = -ENOTTY;
 
-   if (!filp->f_op)
+ if (!filp->f_op || !filp->f_op->unlocked_ioctl)
                goto out;
 
-   if (filp->f_op->unlocked_ioctl) {
-           error = filp->f_op->unlocked_ioctl(filp, cmd, arg);
-           if (error == -ENOIOCTLCMD)
-                   error = -EINVAL;
-           goto out;
-   } else if (filp->f_op->ioctl) {
-           lock_kernel();
-           error = filp->f_op->ioctl(filp->f_path.dentry->d_inode,
-                                     filp, cmd, arg);
-           unlock_kernel();
...

Before Arnd's patch, locked ioctl's were returning -ENOIOCTLCMD, and
unlocked ones were returning -EINVAL. Now, the return of -ENOIOCTLCMD
doesn't go to userspace anymore. IMO, that's wrong and can cause
regressions, as some subsystems like DVB were returning -ENOIOCTLCMD
to userspace.

The right fix would be to remove this from fs:

diff --git a/fs/ioctl.c b/fs/ioctl.c
index 1d9b9fc..802fbbd 100644
--- a/fs/ioctl.c
+++ b/fs/ioctl.c
@@ -41,8 +41,6 @@ static long vfs_ioctl(struct file *filp, unsigned int cmd,
 		goto out;
 
 	error = filp->f_op->unlocked_ioctl(filp, cmd, arg);
-	if (error == -ENOIOCTLCMD)
-		error = -EINVAL;
  out:
 	return error;
 }

However, the replacement from -EINVAL to -ENOIOCTLCMD is there since 2.6.12 for
unlocked_ioctl:

$ git blame b19dd42f^1 fs/ioctl.c 
...
^1da177e (Linus Torvalds    2005-04-16 15:20:36 -0700  46)              error = filp->f_op->unlocked_ioctl(filp, cmd, arg);
^1da177e (Linus Torvalds    2005-04-16 15:20:36 -0700  47)              if (error == -ENOIOCTLCMD)
^1da177e (Linus Torvalds    2005-04-16 15:20:36 -0700  48)                      error = -EINVAL;

Linus,

what would be the expected behaviour?

Thanks,
Mauro
