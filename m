Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932890Ab0E0Vig (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 17:38:36 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:49363 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757002Ab0E0Vic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 17:38:32 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [GIT PULL] Bkl ioctl pushdowns for 2.6.35-rc1
Date: Thu, 27 May 2010 23:38:24 +0200
User-Agent: KMail/1.13.2 (Linux/2.6.34-rc6-00202-gac5d593; KDE/4.4.2; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, John Kacur <jkacur@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Frederic Lassabe <frederic.lassabe@gmail.com>,
       Jesper Nilsson <jesper.nilsson@axis.com>,
       Hans Verkuil <hverkuil@xs4all.nl>,
       Tyler Hicks <tyhicks@linux.vnet.ibm.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       =?iso-8859-15?q?J=F6rn_Engel?= <joern@logfs.org>
References: <1274547426-25937-1-git-send-regression-fweisbec@gmail.com>
In-Reply-To: <1274547426-25937-1-git-send-regression-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201005272338.25049.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/YNFib+IPhEE85O1vPg9CCRNc9TcNA2bogxpo
 OYLHp8xQtSXvChvxfFruHibO2lW2qURSmmLZ2RIgztyL5u0Q8L
 wda25XnnXYINiq7g77PZw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 22 May 2010 18:57:05 Frederic Weisbecker wrote:
> Please pull the bkl/ioctl branch that can be found at:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
> 	bkl/ioctl
> 
> There are still some pushdowns left, pending for tests or in discussion.
> I guess ioctl will die for the next merge window.

Let's take a look at the final patch in the meantime. I would suggest merging
the patch below once all users we care about are done.

Right now, what remains are these trivial users:

| arch/cris/arch-v10/drivers/ds1302.c
| arch/cris/arch-v10/drivers/gpio.c
| arch/cris/arch-v10/drivers/i2c.c
| arch/cris/arch-v10/drivers/pcf8563.c
| arch/cris/arch-v10/drivers/sync_serial.c
| arch/cris/arch-v32/drivers/cryptocop.c
| arch/cris/arch-v32/drivers/i2c.c
| arch/cris/arch-v32/drivers/mach-a3/gpio.c
| arch/cris/arch-v32/drivers/mach-fs/gpio.c
| arch/cris/arch-v32/drivers/pcf8563.c
| arch/cris/arch-v32/drivers/sync_serial.c

All queued in the cris maintainer tree, but no pull request
has been sent for 2.6.35 cris.

| arch/ia64/kernel/perfmon.c

Not sure what happened to this patch. The ioctl function here
is basically empty, but the patch you did was not merged.

| drivers/media/video/v4l2-dev.c

At least two patches exist, a simple one from me and a
more complete one from Frederic. Both have been Ack-ed
by Hans Verkuil, so one of them should just go in.

| fs/autofs/root.c

A discussion came up on the naming of the function after
the patch, and another discussion on when to finally
kill this driver.

| fs/logfs/file.c
| fs/logfs/dir.c

Joern said he had this in his tree, but it was not
part of the pull request.

| fs/ecryptfs/file.c

Tyler wanted to take care of this one, it conflicted with
a bug fix he did. The bug fix should go in anyway, so we should
just do it the right way (removing the .ioctl version from there)

| sound/oss/dmasound/dmasound_core.c
| sound/oss/msnd_pinnacle.c
| sound/oss/au1550_ac97.c
| sound/oss/sh_dac_audio.c
| sound/oss/swarm_cs4297a.c
| sound/oss/vwsnd.c

The patches for this exist but are untested apparently.
A discussion came up on whether we should just kill oss.

	Arnd

---
[PATCH] Kill ioctl file operation

All instances of the .ioctl() file operation are gone now, so we can
remove the pointer itself along with the code accessing it.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---

 Documentation/filesystems/Locking |    8 +-------
 Documentation/filesystems/vfs.txt |    6 +-----
 fs/bad_inode.c                    |    7 -------
 fs/compat_ioctl.c                 |    3 +--
 fs/ioctl.c                        |   18 ++++--------------
 fs/proc/inode.c                   |   17 ++++-------------
 include/linux/fs.h                |    5 ++---
 7 files changed, 13 insertions(+), 51 deletions(-)

diff --git a/Documentation/filesystems/Locking b/Documentation/filesystems/Locking
index 61c98f0..ea8e1d2 100644
--- a/Documentation/filesystems/Locking
+++ b/Documentation/filesystems/Locking
@@ -372,8 +372,6 @@ prototypes:
 	ssize_t (*aio_write) (struct kiocb *, const struct iovec *, unsigned long, loff_t);
 	int (*readdir) (struct file *, void *, filldir_t);
 	unsigned int (*poll) (struct file *, struct poll_table_struct *);
-	int (*ioctl) (struct inode *, struct file *, unsigned int,
-			unsigned long);
 	long (*unlocked_ioctl) (struct file *, unsigned int, unsigned long);
 	long (*compat_ioctl) (struct file *, unsigned int, unsigned long);
 	int (*mmap) (struct file *, struct vm_area_struct *);
@@ -407,8 +405,7 @@ write:			no
 aio_write:		no
 readdir: 		no
 poll:			no
-ioctl:			yes	(see below)
-unlocked_ioctl:		no	(see below)
+unlocked_ioctl:		no
 compat_ioctl:		no
 mmap:			no
 open:			no
@@ -451,9 +448,6 @@ move ->readdir() to inode_operations and use a separate method for directory
 anything that resembles union-mount we won't have a struct file for all
 components. And there are other reasons why the current interface is a mess...
 
-->ioctl() on regular files is superceded by the ->unlocked_ioctl() that
-doesn't take the BKL.
-
 ->read on directories probably must go away - we should just enforce -EISDIR
 in sys_read() and friends.
 
diff --git a/Documentation/filesystems/vfs.txt b/Documentation/filesystems/vfs.txt
index b668585..caa7989 100644
--- a/Documentation/filesystems/vfs.txt
+++ b/Documentation/filesystems/vfs.txt
@@ -722,7 +722,6 @@ struct file_operations {
 	ssize_t (*aio_write) (struct kiocb *, const struct iovec *, unsigned long, loff_t);
 	int (*readdir) (struct file *, void *, filldir_t);
 	unsigned int (*poll) (struct file *, struct poll_table_struct *);
-	int (*ioctl) (struct inode *, struct file *, unsigned int, unsigned long);
 	long (*unlocked_ioctl) (struct file *, unsigned int, unsigned long);
 	long (*compat_ioctl) (struct file *, unsigned int, unsigned long);
 	int (*mmap) (struct file *, struct vm_area_struct *);
@@ -763,10 +762,7 @@ otherwise noted.
 	activity on this file and (optionally) go to sleep until there
 	is activity. Called by the select(2) and poll(2) system calls
 
-  ioctl: called by the ioctl(2) system call
-
-  unlocked_ioctl: called by the ioctl(2) system call. Filesystems that do not
-  	require the BKL should use this method instead of the ioctl() above.
+  unlocked_ioctl: called by the ioctl(2) system call.
 
   compat_ioctl: called by the ioctl(2) system call when 32 bit system calls
  	 are used on 64 bit kernels.
diff --git a/fs/bad_inode.c b/fs/bad_inode.c
index a05287a..7cb2730 100644
--- a/fs/bad_inode.c
+++ b/fs/bad_inode.c
@@ -55,12 +55,6 @@ static unsigned int bad_file_poll(struct file *filp, poll_table *wait)
 	return POLLERR;
 }
 
-static int bad_file_ioctl (struct inode *inode, struct file *filp,
-			unsigned int cmd, unsigned long arg)
-{
-	return -EIO;
-}
-
 static long bad_file_unlocked_ioctl(struct file *file, unsigned cmd,
 			unsigned long arg)
 {
@@ -160,7 +154,6 @@ static const struct file_operations bad_file_ops =
 	.aio_write	= bad_file_aio_write,
 	.readdir	= bad_file_readdir,
 	.poll		= bad_file_poll,
-	.ioctl		= bad_file_ioctl,
 	.unlocked_ioctl	= bad_file_unlocked_ioctl,
 	.compat_ioctl	= bad_file_compat_ioctl,
 	.mmap		= bad_file_mmap,
diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
index 641640d..edf72e3 100644
--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -1729,8 +1729,7 @@ asmlinkage long compat_sys_ioctl(unsigned int fd, unsigned int cmd,
 				goto out_fput;
 		}
 
-		if (!filp->f_op ||
-		    (!filp->f_op->ioctl && !filp->f_op->unlocked_ioctl))
+		if (!filp->f_op || !filp->f_op->unlocked_ioctl)
 			goto do_ioctl;
 		break;
 	}
diff --git a/fs/ioctl.c b/fs/ioctl.c
index 2d140a7..f855ea4 100644
--- a/fs/ioctl.c
+++ b/fs/ioctl.c
@@ -29,7 +29,6 @@
  * @arg:	command-specific argument for ioctl
  *
  * Invokes filesystem specific ->unlocked_ioctl, if one exists; otherwise
- * invokes filesystem specific ->ioctl method.  If neither method exists,
  * returns -ENOTTY.
  *
  * Returns 0 on success, -errno on error.
@@ -39,21 +38,12 @@ static long vfs_ioctl(struct file *filp, unsigned int cmd,
 {
 	int error = -ENOTTY;
 
-	if (!filp->f_op)
+	if (!filp->f_op || !filp->f_op->unlocked_ioctl)
 		goto out;
 
-	if (filp->f_op->unlocked_ioctl) {
-		error = filp->f_op->unlocked_ioctl(filp, cmd, arg);
-		if (error == -ENOIOCTLCMD)
-			error = -EINVAL;
-		goto out;
-	} else if (filp->f_op->ioctl) {
-		lock_kernel();
-		error = filp->f_op->ioctl(filp->f_path.dentry->d_inode,
-					  filp, cmd, arg);
-		unlock_kernel();
-	}
-
+	error = filp->f_op->unlocked_ioctl(filp, cmd, arg);
+	if (error == -ENOIOCTLCMD)
+		error = -EINVAL;
  out:
 	return error;
 }
diff --git a/fs/proc/inode.c b/fs/proc/inode.c
index aea8502..041517c 100644
--- a/fs/proc/inode.c
+++ b/fs/proc/inode.c
@@ -214,8 +214,7 @@ static long proc_reg_unlocked_ioctl(struct file *file, unsigned int cmd, unsigne
 {
 	struct proc_dir_entry *pde = PDE(file->f_path.dentry->d_inode);
 	long rv = -ENOTTY;
-	long (*unlocked_ioctl)(struct file *, unsigned int, unsigned long);
-	int (*ioctl)(struct inode *, struct file *, unsigned int, unsigned long);
+	long (*ioctl)(struct file *, unsigned int, unsigned long);
 
 	spin_lock(&pde->pde_unload_lock);
 	if (!pde->proc_fops) {
@@ -223,19 +222,11 @@ static long proc_reg_unlocked_ioctl(struct file *file, unsigned int cmd, unsigne
 		return rv;
 	}
 	pde->pde_users++;
-	unlocked_ioctl = pde->proc_fops->unlocked_ioctl;
-	ioctl = pde->proc_fops->ioctl;
+	ioctl = pde->proc_fops->unlocked_ioctl;
 	spin_unlock(&pde->pde_unload_lock);
 
-	if (unlocked_ioctl) {
-		rv = unlocked_ioctl(file, cmd, arg);
-		if (rv == -ENOIOCTLCMD)
-			rv = -EINVAL;
-	} else if (ioctl) {
-		WARN_ONCE(1, "Procfs ioctl handlers must use unlocked_ioctl, "
-			  "%pf will be called without the Bkl held\n", ioctl);
-		rv = ioctl(file->f_path.dentry->d_inode, file, cmd, arg);
-	}
+	if (ioctl)
+		rv = ioctl(file, cmd, arg);
 
 	pde_users_dec(pde);
 	return rv;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 85e823a..a92f91c 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1478,8 +1478,8 @@ struct block_device_operations;
 
 /*
  * NOTE:
- * read, write, poll, fsync, readv, writev, unlocked_ioctl and compat_ioctl
- * can be called without the big kernel lock held in all filesystems.
+ * all file operations except setlease can be called without
+ * the big kernel lock held in all filesystems.
  */
 struct file_operations {
 	struct module *owner;
@@ -1490,7 +1490,6 @@ struct file_operations {
 	ssize_t (*aio_write) (struct kiocb *, const struct iovec *, unsigned long, loff_t);
 	int (*readdir) (struct file *, void *, filldir_t);
 	unsigned int (*poll) (struct file *, struct poll_table_struct *);
-	int (*ioctl) (struct inode *, struct file *, unsigned int, unsigned long);
 	long (*unlocked_ioctl) (struct file *, unsigned int, unsigned long);
 	long (*compat_ioctl) (struct file *, unsigned int, unsigned long);
 	int (*mmap) (struct file *, struct vm_area_struct *);
