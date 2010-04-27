Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756082Ab0D0OY7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 10:24:59 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:64001 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756063Ab0D0OYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 10:24:53 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: John Kacur <jkacur@redhat.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Jan Blunck <jblunck@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 2/7] hfsplus: push down BKL into ioctl function
Date: Tue, 27 Apr 2010 16:24:20 +0200
Message-Id: <1272378265-10909-3-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <alpine.LFD.2.00.1004271359180.3318@localhost>
References: <alpine.LFD.2.00.1004271359180.3318@localhost>
X-Provags-ID: V01U2FsdGVkX1/W4urKu3YLtW4/DjodSIdCbV6/EryEvYDz++Q
 arTjNu9IXszPx9SRF2yEtbltxWA2+05+oXoi3JlZXIGE1gb5dm
 rd1JujzdGcP2reA0fh78Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HFS is one of the remaining users of the ->ioctl function, convert it
blindly to unlocked_ioctl by pushing down the BKL.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 fs/hfsplus/dir.c        |    2 +-
 fs/hfsplus/hfsplus_fs.h |    3 +--
 fs/hfsplus/inode.c      |    2 +-
 fs/hfsplus/ioctl.c      |   12 +++++++++---
 4 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/fs/hfsplus/dir.c b/fs/hfsplus/dir.c
index 5f40236..764fd1b 100644
--- a/fs/hfsplus/dir.c
+++ b/fs/hfsplus/dir.c
@@ -494,7 +494,7 @@ const struct inode_operations hfsplus_dir_inode_operations = {
 const struct file_operations hfsplus_dir_operations = {
 	.read		= generic_read_dir,
 	.readdir	= hfsplus_readdir,
-	.ioctl          = hfsplus_ioctl,
+	.unlocked_ioctl = hfsplus_ioctl,
 	.llseek		= generic_file_llseek,
 	.release	= hfsplus_dir_release,
 };
diff --git a/fs/hfsplus/hfsplus_fs.h b/fs/hfsplus/hfsplus_fs.h
index 5c10d80..6505c30 100644
--- a/fs/hfsplus/hfsplus_fs.h
+++ b/fs/hfsplus/hfsplus_fs.h
@@ -337,8 +337,7 @@ struct inode *hfsplus_new_inode(struct super_block *, int);
 void hfsplus_delete_inode(struct inode *);
 
 /* ioctl.c */
-int hfsplus_ioctl(struct inode *inode, struct file *filp, unsigned int cmd,
-		  unsigned long arg);
+long hfsplus_ioctl(struct file *filp, unsigned int cmd, unsigned long arg);
 int hfsplus_setxattr(struct dentry *dentry, const char *name,
 		     const void *value, size_t size, int flags);
 ssize_t hfsplus_getxattr(struct dentry *dentry, const char *name,
diff --git a/fs/hfsplus/inode.c b/fs/hfsplus/inode.c
index 1bcf597..9bbb829 100644
--- a/fs/hfsplus/inode.c
+++ b/fs/hfsplus/inode.c
@@ -285,7 +285,7 @@ static const struct file_operations hfsplus_file_operations = {
 	.fsync		= file_fsync,
 	.open		= hfsplus_file_open,
 	.release	= hfsplus_file_release,
-	.ioctl          = hfsplus_ioctl,
+	.unlocked_ioctl = hfsplus_ioctl,
 };
 
 struct inode *hfsplus_new_inode(struct super_block *sb, int mode)
diff --git a/fs/hfsplus/ioctl.c b/fs/hfsplus/ioctl.c
index f457d2c..ac405f0 100644
--- a/fs/hfsplus/ioctl.c
+++ b/fs/hfsplus/ioctl.c
@@ -17,14 +17,16 @@
 #include <linux/mount.h>
 #include <linux/sched.h>
 #include <linux/xattr.h>
+#include <linux/smp_lock.h>
 #include <asm/uaccess.h>
 #include "hfsplus_fs.h"
 
-int hfsplus_ioctl(struct inode *inode, struct file *filp, unsigned int cmd,
-		  unsigned long arg)
+long hfsplus_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 {
+	struct inode *inode = filp->f_path.dentry->d_inode;
 	unsigned int flags;
 
+	lock_kernel();
 	switch (cmd) {
 	case HFSPLUS_IOC_EXT2_GETFLAGS:
 		flags = 0;
@@ -38,8 +40,10 @@ int hfsplus_ioctl(struct inode *inode, struct file *filp, unsigned int cmd,
 	case HFSPLUS_IOC_EXT2_SETFLAGS: {
 		int err = 0;
 		err = mnt_want_write(filp->f_path.mnt);
-		if (err)
+		if (err) {
+			unlock_kernel();
 			return err;
+		}
 
 		if (!is_owner_or_cap(inode)) {
 			err = -EACCES;
@@ -85,9 +89,11 @@ int hfsplus_ioctl(struct inode *inode, struct file *filp, unsigned int cmd,
 		mark_inode_dirty(inode);
 setflags_out:
 		mnt_drop_write(filp->f_path.mnt);
+		unlock_kernel();
 		return err;
 	}
 	default:
+		unlock_kernel();
 		return -ENOTTY;
 	}
 }
-- 
1.6.3.3

