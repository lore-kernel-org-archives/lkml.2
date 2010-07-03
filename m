Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755966Ab0GCWPZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jul 2010 18:15:25 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:53923 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754027Ab0GCWPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jul 2010 18:15:22 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: John Kacur <jkacur@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
       Arnd Bergmann <arnd@arndb.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Al Viro <viro@zeniv.linux.org.uk>, Ian Kent <raven@themaw.net>,
       autofs@linux.kernel.org
Subject: [PATCH 3/6] autofs/autofs4: move compat_ioctl handling into fs
Date: Sun,  4 Jul 2010 00:15:07 +0200
Message-Id: <1278195310-25590-4-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1278195310-25590-1-git-send-email-arnd@arndb.de>
References: <1278195310-25590-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19ox4YxQUJCKCOTB+VgwA0FFJmOHKYNzUxRbhb
 0yjOTIBNyDTLS8H5Iewb+LG+8sIWfD3E+PhZ2skuT2ecybszDn
 rf2DLtEn9TOEsB0J7NqLA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Handling of autofs ioctl numbers does not need to be generic
and can easily be done directly in autofs itself.

This also pushes the BKL into autofs and autofs4 ioctl
methods.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Ian Kent <raven@themaw.net>
Cc: autofs@linux.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 fs/autofs/root.c        |   67 ++++++++++++++++++++++++++++++++++++++++++++--
 fs/autofs4/root.c       |   49 ++++++++++++++++++++++++++++++++++
 fs/compat_ioctl.c       |   36 -------------------------
 include/linux/auto_fs.h |    1 +
 4 files changed, 114 insertions(+), 39 deletions(-)

diff --git a/fs/autofs/root.c b/fs/autofs/root.c
index 9a0520b..11b1ea7 100644
--- a/fs/autofs/root.c
+++ b/fs/autofs/root.c
@@ -16,6 +16,7 @@
 #include <linux/slab.h>
 #include <linux/param.h>
 #include <linux/time.h>
+#include <linux/compat.h>
 #include <linux/smp_lock.h>
 #include "autofs_i.h"
 
@@ -25,13 +26,17 @@ static int autofs_root_symlink(struct inode *,struct dentry *,const char *);
 static int autofs_root_unlink(struct inode *,struct dentry *);
 static int autofs_root_rmdir(struct inode *,struct dentry *);
 static int autofs_root_mkdir(struct inode *,struct dentry *,int);
-static int autofs_root_ioctl(struct inode *, struct file *,unsigned int,unsigned long);
+static long autofs_root_ioctl(struct file *,unsigned int,unsigned long);
+static long autofs_root_compat_ioctl(struct file *,unsigned int,unsigned long);
 
 const struct file_operations autofs_root_operations = {
 	.llseek		= generic_file_llseek,
 	.read		= generic_read_dir,
 	.readdir	= autofs_root_readdir,
-	.ioctl		= autofs_root_ioctl,
+	.unlocked_ioctl	= autofs_root_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl	= autofs_root_compat_ioctl,
+#endif
 };
 
 const struct inode_operations autofs_root_inode_operations = {
@@ -492,6 +497,25 @@ static int autofs_root_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 }
 
 /* Get/set timeout ioctl() operation */
+#ifdef CONFIG_COMPAT
+static inline int autofs_compat_get_set_timeout(struct autofs_sb_info *sbi,
+					 unsigned int __user *p)
+{
+	unsigned long ntimeout;
+
+	if (get_user(ntimeout, p) ||
+	    put_user(sbi->exp_timeout / HZ, p))
+		return -EFAULT;
+
+	if (ntimeout > UINT_MAX/HZ)
+		sbi->exp_timeout = 0;
+	else
+		sbi->exp_timeout = ntimeout * HZ;
+
+	return 0;
+}
+#endif
+
 static inline int autofs_get_set_timeout(struct autofs_sb_info *sbi,
 					 unsigned long __user *p)
 {
@@ -546,7 +570,7 @@ static inline int autofs_expire_run(struct super_block *sb,
  * ioctl()'s on the root directory is the chief method for the daemon to
  * generate kernel reactions
  */
-static int autofs_root_ioctl(struct inode *inode, struct file *filp,
+static int autofs_do_root_ioctl(struct inode *inode, struct file *filp,
 			     unsigned int cmd, unsigned long arg)
 {
 	struct autofs_sb_info *sbi = autofs_sbi(inode->i_sb);
@@ -571,6 +595,10 @@ static int autofs_root_ioctl(struct inode *inode, struct file *filp,
 		return 0;
 	case AUTOFS_IOC_PROTOVER: /* Get protocol version */
 		return autofs_get_protover(argp);
+#ifdef CONFIG_COMPAT
+	case AUTOFS_IOC_SETTIMEOUT32:
+		return autofs_compat_get_set_timeout(sbi, argp);
+#endif
 	case AUTOFS_IOC_SETTIMEOUT:
 		return autofs_get_set_timeout(sbi, argp);
 	case AUTOFS_IOC_EXPIRE:
@@ -579,4 +607,37 @@ static int autofs_root_ioctl(struct inode *inode, struct file *filp,
 	default:
 		return -ENOSYS;
 	}
+
+}
+
+static long autofs_root_ioctl(struct file *filp,
+			     unsigned int cmd, unsigned long arg)
+{
+	int ret;
+
+	lock_kernel();
+	ret = autofs_do_root_ioctl(filp->f_path.dentry->d_inode,
+				   filp, cmd, arg);
+	unlock_kernel();
+
+	return ret;
+}
+
+#ifdef CONFIG_COMPAT
+static long autofs_root_compat_ioctl(struct file *filp,
+			     unsigned int cmd, unsigned long arg)
+{
+	struct inode *inode = filp->f_path.dentry->d_inode;
+	int ret;
+
+	lock_kernel();
+	if (cmd == AUTOFS_IOC_READY || cmd == AUTOFS_IOC_FAIL)
+		ret = autofs_do_root_ioctl(inode, filp, cmd, arg);
+	else
+		ret = autofs_do_root_ioctl(inode, filp, cmd,
+			(unsigned long)compat_ptr(arg));
+	unlock_kernel();
+
+	return ret;
 }
+#endif
diff --git a/fs/autofs4/root.c b/fs/autofs4/root.c
index db4117e..48e056e 100644
--- a/fs/autofs4/root.c
+++ b/fs/autofs4/root.c
@@ -18,7 +18,9 @@
 #include <linux/slab.h>
 #include <linux/param.h>
 #include <linux/time.h>
+#include <linux/compat.h>
 #include <linux/smp_lock.h>
+
 #include "autofs_i.h"
 
 static int autofs4_dir_symlink(struct inode *,struct dentry *,const char *);
@@ -26,6 +28,7 @@ static int autofs4_dir_unlink(struct inode *,struct dentry *);
 static int autofs4_dir_rmdir(struct inode *,struct dentry *);
 static int autofs4_dir_mkdir(struct inode *,struct dentry *,int);
 static long autofs4_root_ioctl(struct file *,unsigned int,unsigned long);
+static long autofs4_root_compat_ioctl(struct file *,unsigned int,unsigned long);
 static int autofs4_dir_open(struct inode *inode, struct file *file);
 static struct dentry *autofs4_lookup(struct inode *,struct dentry *, struct nameidata *);
 static void *autofs4_follow_link(struct dentry *, struct nameidata *);
@@ -40,6 +43,9 @@ const struct file_operations autofs4_root_operations = {
 	.readdir	= dcache_readdir,
 	.llseek		= dcache_dir_lseek,
 	.unlocked_ioctl	= autofs4_root_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl	= autofs4_root_compat_ioctl,
+#endif
 };
 
 const struct file_operations autofs4_dir_operations = {
@@ -840,6 +846,26 @@ static int autofs4_dir_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 }
 
 /* Get/set timeout ioctl() operation */
+#ifdef CONFIG_COMPAT
+static inline int autofs4_compat_get_set_timeout(struct autofs_sb_info *sbi,
+					 compat_ulong_t __user *p)
+{
+	int rv;
+	unsigned long ntimeout;
+
+	if ((rv = get_user(ntimeout, p)) ||
+	     (rv = put_user(sbi->exp_timeout/HZ, p)))
+		return rv;
+
+	if (ntimeout > UINT_MAX/HZ)
+		sbi->exp_timeout = 0;
+	else
+		sbi->exp_timeout = ntimeout * HZ;
+
+	return 0;
+}
+#endif
+
 static inline int autofs4_get_set_timeout(struct autofs_sb_info *sbi,
 					 unsigned long __user *p)
 {
@@ -933,6 +959,10 @@ static int autofs4_root_ioctl_unlocked(struct inode *inode, struct file *filp,
 		return autofs4_get_protosubver(sbi, p);
 	case AUTOFS_IOC_SETTIMEOUT:
 		return autofs4_get_set_timeout(sbi, p);
+#ifdef CONFIG_COMPAT
+	case AUTOFS_IOC_SETTIMEOUT32:
+		return autofs4_compat_get_set_timeout(sbi, p);
+#endif
 
 	case AUTOFS_IOC_ASKUMOUNT:
 		return autofs4_ask_umount(filp->f_path.mnt, p);
@@ -961,3 +991,22 @@ static long autofs4_root_ioctl(struct file *filp,
 
 	return ret;
 }
+
+#ifdef CONFIG_COMPAT
+static long autofs4_root_compat_ioctl(struct file *filp,
+			     unsigned int cmd, unsigned long arg)
+{
+	struct inode *inode = filp->f_path.dentry->d_inode;
+	int ret;
+
+	lock_kernel();
+	if (cmd == AUTOFS_IOC_READY || cmd == AUTOFS_IOC_FAIL)
+		ret = autofs4_root_ioctl_unlocked(inode, filp, cmd, arg);
+	else
+		ret = autofs4_root_ioctl_unlocked(inode, filp, cmd,
+			(unsigned long)compat_ptr(arg));
+	unlock_kernel();
+
+	return ret;
+}
+#endif
diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
index 641640d..618f381 100644
--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -131,23 +131,6 @@ static int w_long(unsigned int fd, unsigned int cmd,
 	return err;
 }
 
-static int rw_long(unsigned int fd, unsigned int cmd,
-		compat_ulong_t __user *argp)
-{
-	mm_segment_t old_fs = get_fs();
-	int err;
-	unsigned long val;
-
-	if(get_user(val, argp))
-		return -EFAULT;
-	set_fs (KERNEL_DS);
-	err = sys_ioctl(fd, cmd, (unsigned long)&val);
-	set_fs (old_fs);
-	if (!err && put_user(val, argp))
-		return -EFAULT;
-	return err;
-}
-
 struct compat_video_event {
 	int32_t		type;
 	compat_time_t	timestamp;
@@ -594,12 +577,6 @@ static int do_smb_getmountuid(unsigned int fd, unsigned int cmd,
 	return err;
 }
 
-static int ioc_settimeout(unsigned int fd, unsigned int cmd,
-		compat_ulong_t __user *argp)
-{
-	return rw_long(fd, AUTOFS_IOC_SETTIMEOUT, argp);
-}
-
 /* Bluetooth ioctls */
 #define HCIUARTSETPROTO	_IOW('U', 200, int)
 #define HCIUARTGETPROTO	_IOR('U', 201, int)
@@ -1281,13 +1258,6 @@ COMPATIBLE_IOCTL(SOUND_MIXER_PRIVATE5)
 COMPATIBLE_IOCTL(SOUND_MIXER_GETLEVELS)
 COMPATIBLE_IOCTL(SOUND_MIXER_SETLEVELS)
 COMPATIBLE_IOCTL(OSS_GETVERSION)
-/* AUTOFS */
-COMPATIBLE_IOCTL(AUTOFS_IOC_CATATONIC)
-COMPATIBLE_IOCTL(AUTOFS_IOC_PROTOVER)
-COMPATIBLE_IOCTL(AUTOFS_IOC_EXPIRE)
-COMPATIBLE_IOCTL(AUTOFS_IOC_EXPIRE_MULTI)
-COMPATIBLE_IOCTL(AUTOFS_IOC_PROTOSUBVER)
-COMPATIBLE_IOCTL(AUTOFS_IOC_ASKUMOUNT)
 /* Raw devices */
 COMPATIBLE_IOCTL(RAW_SETBIND)
 COMPATIBLE_IOCTL(RAW_GETBIND)
@@ -1552,9 +1522,6 @@ static long do_ioctl_trans(int fd, unsigned int cmd,
 	case RAW_GETBIND:
 		return raw_ioctl(fd, cmd, argp);
 #endif
-#define AUTOFS_IOC_SETTIMEOUT32 _IOWR(0x93,0x64,unsigned int)
-	case AUTOFS_IOC_SETTIMEOUT32:
-		return ioc_settimeout(fd, cmd, argp);
 	/* One SMB ioctl needs translations. */
 #define SMB_IOC_GETMOUNTUID_32 _IOR('u', 1, compat_uid_t)
 	case SMB_IOC_GETMOUNTUID_32:
@@ -1609,9 +1576,6 @@ static long do_ioctl_trans(int fd, unsigned int cmd,
 	case KDSKBMETA:
 	case KDSKBLED:
 	case KDSETLED:
-	/* AUTOFS */
-	case AUTOFS_IOC_READY:
-	case AUTOFS_IOC_FAIL:
 	/* NBD */
 	case NBD_SET_SOCK:
 	case NBD_SET_BLKSIZE:
diff --git a/include/linux/auto_fs.h b/include/linux/auto_fs.h
index 7b09c83..da64e15 100644
--- a/include/linux/auto_fs.h
+++ b/include/linux/auto_fs.h
@@ -79,6 +79,7 @@ struct autofs_packet_expire {
 #define AUTOFS_IOC_FAIL       _IO(0x93,0x61)
 #define AUTOFS_IOC_CATATONIC  _IO(0x93,0x62)
 #define AUTOFS_IOC_PROTOVER   _IOR(0x93,0x63,int)
+#define AUTOFS_IOC_SETTIMEOUT32 _IOWR(0x93,0x64,compat_ulong_t)
 #define AUTOFS_IOC_SETTIMEOUT _IOWR(0x93,0x64,unsigned long)
 #define AUTOFS_IOC_EXPIRE     _IOR(0x93,0x65,struct autofs_packet_expire)
 
-- 
1.7.1

