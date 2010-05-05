Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755551Ab0EETzr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 15:55:47 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:54165 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930Ab0EETzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 15:55:45 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: [PATCH] fat: convert to unlocked_ioctl
Date: Wed, 5 May 2010 21:55:16 +0200
User-Agent: KMail/1.13.2 (Linux/2.6.34-rc6-00090-g1509e54-dirty; KDE/4.4.2; x86_64; ; )
Cc: John Kacur <jkacur@redhat.com>, lkml <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>
References: <1273065339-21669-1-git-send-email-jkacur@redhat.com> <alpine.LFD.2.00.1005051927210.6285@localhost.localdomain> <87wrvitd5c.fsf@devron.myhome.or.jp>
In-Reply-To: <87wrvitd5c.fsf@devron.myhome.or.jp>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005052155.17249.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18oDxVaF4K8YZ2/somDaOKZXVeYLYXySCUkIjD
 lE41HTmZr8daDJJ6L/OTcOvwVEbSMSvvMNCnZGhTc7UhNOWxTn
 rSfoyv9kWHInrXNhkdk5A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FAT does not require the BKL in its ioctl function, which is already serialized
through a mutex. Since we're already touching the ioctl code, also fix the
missing handling of FAT_IOCTL_GET_ATTRIBUTES in the compat code.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
On Wednesday 05 May 2010 20:30:07 OGAWA Hirofumi wrote:
> John Kacur <jkacur@redhat.com> writes:
> > That's probably not a good idea, without a little bit more analysis, 
> > otherwise it's quite easy to introduce subtle bugs.

The chances are rather low if the maintainer confirms that the BKL
is not needed. I double-checked and found a small bug in related
code, so this does both.

> What analysis? Who do it? I thought about removing BKL of FAT from
> several years ago. I was reviewing FAT multiple times, and I'm always
> testing FAT without BKL.
> 
> If you are going to do, could you do it instead of this patch?

The only thing the series really needs to do is to remove the
usage of the deprecated ->ioctl() operation. This patch makes
FAT simply use unlocked_ioctl but does not reintroduce the
BKL.

Does that look better?

 fs/fat/dir.c  |   11 ++++++-----
 fs/fat/fat.h  |    4 ++--
 fs/fat/file.c |   19 ++++++++++++++++---
 3 files changed, 24 insertions(+), 10 deletions(-)


diff --git a/fs/fat/dir.c b/fs/fat/dir.c
index 530b4ca..d9bf865 100644
--- a/fs/fat/dir.c
+++ b/fs/fat/dir.c
@@ -758,9 +758,10 @@ static int fat_ioctl_readdir(struct inode *inode, struct file *filp,
 	return ret;
 }
 
-static int fat_dir_ioctl(struct inode *inode, struct file *filp,
-			 unsigned int cmd, unsigned long arg)
+static long fat_dir_ioctl(struct file *filp, unsigned int cmd,
+			  unsigned long arg)
 {
+	struct inode *inode = filp->f_path.dentry->d_inode;
 	struct __fat_dirent __user *d1 = (struct __fat_dirent __user *)arg;
 	int short_only, both;
 
@@ -774,7 +775,7 @@ static int fat_dir_ioctl(struct inode *inode, struct file *filp,
 		both = 1;
 		break;
 	default:
-		return fat_generic_ioctl(inode, filp, cmd, arg);
+		return fat_generic_ioctl(filp, cmd, arg);
 	}
 
 	if (!access_ok(VERIFY_WRITE, d1, sizeof(struct __fat_dirent[2])))
@@ -814,7 +815,7 @@ static long fat_compat_dir_ioctl(struct file *filp, unsigned cmd,
 		both = 1;
 		break;
 	default:
-		return -ENOIOCTLCMD;
+		return fat_generic_ioctl(filp, cmd, (unsigned long)arg);
 	}
 
 	if (!access_ok(VERIFY_WRITE, d1, sizeof(struct compat_dirent[2])))
@@ -836,7 +837,7 @@ const struct file_operations fat_dir_operations = {
 	.llseek		= generic_file_llseek,
 	.read		= generic_read_dir,
 	.readdir	= fat_readdir,
-	.ioctl		= fat_dir_ioctl,
+	.unlocked_ioctl	= fat_dir_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	= fat_compat_dir_ioctl,
 #endif
diff --git a/fs/fat/fat.h b/fs/fat/fat.h
index e6efdfa..eb821ee 100644
--- a/fs/fat/fat.h
+++ b/fs/fat/fat.h
@@ -298,8 +298,8 @@ extern int fat_free_clusters(struct inode *inode, int cluster);
 extern int fat_count_free_clusters(struct super_block *sb);
 
 /* fat/file.c */
-extern int fat_generic_ioctl(struct inode *inode, struct file *filp,
-			     unsigned int cmd, unsigned long arg);
+extern long fat_generic_ioctl(struct file *filp, unsigned int cmd,
+			      unsigned long arg);
 extern const struct file_operations fat_file_operations;
 extern const struct inode_operations fat_file_inode_operations;
 extern int fat_setattr(struct dentry * dentry, struct iattr * attr);
diff --git a/fs/fat/file.c b/fs/fat/file.c
index e8c159d..a14c2f6 100644
--- a/fs/fat/file.c
+++ b/fs/fat/file.c
@@ -8,6 +8,7 @@
 
 #include <linux/capability.h>
 #include <linux/module.h>
+#include <linux/compat.h>
 #include <linux/mount.h>
 #include <linux/time.h>
 #include <linux/buffer_head.h>
@@ -114,9 +115,9 @@ out:
 	return err;
 }
 
-int fat_generic_ioctl(struct inode *inode, struct file *filp,
-		      unsigned int cmd, unsigned long arg)
+long fat_generic_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 {
+	struct inode *inode = filp->f_path.dentry->d_inode;
 	u32 __user *user_attr = (u32 __user *)arg;
 
 	switch (cmd) {
@@ -129,6 +130,15 @@ int fat_generic_ioctl(struct inode *inode, struct file *filp,
 	}
 }
 
+#ifdef CONFIG_COMPAT
+static long fat_generic_compat_ioctl(struct file *filp, unsigned int cmd,
+				      unsigned long arg)
+
+{
+	return fat_generic_ioctl(filp, cmd, (unsigned long)compat_ptr(arg));
+}
+#endif
+
 static int fat_file_release(struct inode *inode, struct file *filp)
 {
 	if ((filp->f_mode & FMODE_WRITE) &&
@@ -159,7 +169,10 @@ const struct file_operations fat_file_operations = {
 	.aio_write	= generic_file_aio_write,
 	.mmap		= generic_file_mmap,
 	.release	= fat_file_release,
-	.ioctl		= fat_generic_ioctl,
+	.unlocked_ioctl	= fat_generic_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl	= fat_generic_compat_ioctl,
+#endif
 	.fsync		= fat_file_fsync,
 	.splice_read	= generic_file_splice_read,
 };
