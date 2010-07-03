Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756449Ab0GCWPn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jul 2010 18:15:43 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:61812 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756172Ab0GCWPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jul 2010 18:15:33 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: John Kacur <jkacur@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
       Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 6/6] bkl: remove locked .ioctl file operation
Date: Sun,  4 Jul 2010 00:15:10 +0200
Message-Id: <1278195310-25590-7-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1278195310-25590-1-git-send-email-arnd@arndb.de>
References: <1278195310-25590-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18Fe3FlbZR88h/zQ0nnEF8Df+qh5t4/GBo0sUa
 IuKu130gNV/ZeD3NScKyzCCYE6igEk7HYVN+Nq5ghfKLzDQqfN
 wmQaym8rNimEdYhj7mo2Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The last user is gone, so we can safely remove this

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
index 96d4293..34657e0 100644
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
index 94677e7..ed7e5ef 100644
--- a/Documentation/filesystems/vfs.txt
+++ b/Documentation/filesystems/vfs.txt
@@ -727,7 +727,6 @@ struct file_operations {
 	ssize_t (*aio_write) (struct kiocb *, const struct iovec *, unsigned long, loff_t);
 	int (*readdir) (struct file *, void *, filldir_t);
 	unsigned int (*poll) (struct file *, struct poll_table_struct *);
-	int (*ioctl) (struct inode *, struct file *, unsigned int, unsigned long);
 	long (*unlocked_ioctl) (struct file *, unsigned int, unsigned long);
 	long (*compat_ioctl) (struct file *, unsigned int, unsigned long);
 	int (*mmap) (struct file *, struct vm_area_struct *);
@@ -768,10 +767,7 @@ otherwise noted.
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
index 52e59bf..f024d8a 100644
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
@@ -159,7 +153,6 @@ static const struct file_operations bad_file_ops =
 	.aio_write	= bad_file_aio_write,
 	.readdir	= bad_file_readdir,
 	.poll		= bad_file_poll,
-	.ioctl		= bad_file_ioctl,
 	.unlocked_ioctl	= bad_file_unlocked_ioctl,
 	.compat_ioctl	= bad_file_compat_ioctl,
 	.mmap		= bad_file_mmap,
diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
index 618f381..0fffcdc 100644
--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -1693,8 +1693,7 @@ asmlinkage long compat_sys_ioctl(unsigned int fd, unsigned int cmd,
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
index 471e1ff..019a1b8 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1479,8 +1479,8 @@ struct block_device_operations;
 
 /*
  * NOTE:
- * read, write, poll, fsync, readv, writev, unlocked_ioctl and compat_ioctl
- * can be called without the big kernel lock held in all filesystems.
+ * all file operations except setlease can be called without
+ * the big kernel lock held in all filesystems.
  */
 struct file_operations {
 	struct module *owner;
@@ -1491,7 +1491,6 @@ struct file_operations {
 	ssize_t (*aio_write) (struct kiocb *, const struct iovec *, unsigned long, loff_t);
 	int (*readdir) (struct file *, void *, filldir_t);
 	unsigned int (*poll) (struct file *, struct poll_table_struct *);
-	int (*ioctl) (struct inode *, struct file *, unsigned int, unsigned long);
 	long (*unlocked_ioctl) (struct file *, unsigned int, unsigned long);
 	long (*compat_ioctl) (struct file *, unsigned int, unsigned long);
 	int (*mmap) (struct file *, struct vm_area_struct *);
-- 
1.7.1

