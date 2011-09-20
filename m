Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751287Ab1ITOTj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 10:19:39 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:41648 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750842Ab1ITOTi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 10:19:38 -0400
From: Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com,
        sunil.mushran@oracle.com, Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH] fs: add FS_IOC_UNRESVSP/FS_IOC_UNRESVSP64 ioctls
Date: Tue, 20 Sep 2011 18:20:00 +0400
Message-Id: <1316528400-1797-1-git-send-email-dmonakhov@openvz.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add ioctl interface for FALLOC_FL_PUNCH_HOLE. Ioctls are synonyms of
XFS_IOC_UNRESVSP ioctls. Yes probably one can say than we already have
a syscall intercase for fallocate, and in general this is right but:
 - We already have FS_IOC_RESVSP (synonym of XFS_IOC_RESVSP)
   and it heavily used. So actually this ioctl is not a
   brand new one. It just makes RSV/URSV interface complete.
 - There are miliones lines of userspace code written
   that can be reused for generic linux filesystems without
   modification. SGI has open sourced many good stuff which are
   under rapid development by linux community. For example
   kernel.org/scm/fs/xfs/xfstests-dev.git  currently is one of
   most used fs-regression testing suite.
   In other words i've added only 30lines of code, and get great
   many good tools working for me, IMHO it is good deal.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/compat_ioctl.c      |   24 ++++++++++++++++++++----
 fs/ioctl.c             |   10 +++++++---
 include/linux/falloc.h |    2 ++
 include/linux/fs.h     |    2 +-
 4 files changed, 30 insertions(+), 8 deletions(-)

diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
index 51352de..9fe290c 100644
--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -782,11 +782,13 @@ struct space_resv_32 {
 };
 
 #define FS_IOC_RESVSP_32		_IOW ('X', 40, struct space_resv_32)
+#define FS_IOC_UNRESVSP_32		_IOW ('X', 41, struct space_resv_32)
 #define FS_IOC_RESVSP64_32	_IOW ('X', 42, struct space_resv_32)
+#define FS_IOC_UNRESVSP64_32	_IOW ('X', 43, struct space_resv_32)
 
 /* just account for different alignment */
 static int compat_ioctl_preallocate(struct file *file,
-			struct space_resv_32    __user *p32)
+				struct space_resv_32 __user *p32, int mode)
 {
 	struct space_resv	__user *p = compat_alloc_user_space(sizeof(*p));
 
@@ -799,7 +801,7 @@ static int compat_ioctl_preallocate(struct file *file,
 	    copy_in_user(&p->l_pad,	&p32->l_pad,	4*sizeof(u32)))
 		return -EFAULT;
 
-	return ioctl_preallocate(file, p);
+	return ioctl_preallocate(file, p, mode);
 }
 #endif
 
@@ -1589,12 +1591,26 @@ asmlinkage long compat_sys_ioctl(unsigned int fd, unsigned int cmd,
 #if defined(CONFIG_IA64) || defined(CONFIG_X86_64)
 	case FS_IOC_RESVSP_32:
 	case FS_IOC_RESVSP64_32:
-		error = compat_ioctl_preallocate(filp, compat_ptr(arg));
+		error = compat_ioctl_preallocate(filp, compat_ptr(arg),
+			FALLOC_FL_KEEP_SIZE);
+		goto out_fput;
+
+	case FS_IOC_UNRESVSP_32:
+	case FS_IOC_UNRESVSP64_32:
+		error = compat_ioctl_preallocate(filp, compat_ptr(arg),
+			FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE);
 		goto out_fput;
 #else
 	case FS_IOC_RESVSP:
 	case FS_IOC_RESVSP64:
-		error = ioctl_preallocate(filp, compat_ptr(arg));
+		error = ioctl_preallocate(filp, compat_ptr(arg),
+			FALLOC_FL_KEEP_SIZE);
+		goto out_fput;
+	case FS_IOC_UNRESVSP:
+	case FS_IOC_UNRESVSP64:
+		error = ioctl_preallocate(filp, compat_ptr(arg),
+					FALLOC_FL_KEEP_SIZE |
+					FALLOC_FL_PUNCH_HOLE);
 		goto out_fput;
 #endif
 
diff --git a/fs/ioctl.c b/fs/ioctl.c
index 1d9b9fc..f083fec 100644
--- a/fs/ioctl.c
+++ b/fs/ioctl.c
@@ -422,7 +422,7 @@ EXPORT_SYMBOL(generic_block_fiemap);
  * Only the l_start, l_len and l_whence fields of the 'struct space_resv'
  * are used here, rest are ignored.
  */
-int ioctl_preallocate(struct file *filp, void __user *argp)
+int ioctl_preallocate(struct file *filp, void __user *argp, int mode)
 {
 	struct inode *inode = filp->f_path.dentry->d_inode;
 	struct space_resv sr;
@@ -443,7 +443,7 @@ int ioctl_preallocate(struct file *filp, void __user *argp)
 		return -EINVAL;
 	}
 
-	return do_fallocate(filp, FALLOC_FL_KEEP_SIZE, sr.l_start, sr.l_len);
+	return do_fallocate(filp, mode, sr.l_start, sr.l_len);
 }
 
 static int file_ioctl(struct file *filp, unsigned int cmd,
@@ -459,7 +459,11 @@ static int file_ioctl(struct file *filp, unsigned int cmd,
 		return put_user(i_size_read(inode) - filp->f_pos, p);
 	case FS_IOC_RESVSP:
 	case FS_IOC_RESVSP64:
-		return ioctl_preallocate(filp, p);
+		return ioctl_preallocate(filp, p, FALLOC_FL_KEEP_SIZE);
+	case FS_IOC_UNRESVSP:
+	case FS_IOC_UNRESVSP64:
+		return ioctl_preallocate(filp, p, FALLOC_FL_KEEP_SIZE |
+					FALLOC_FL_PUNCH_HOLE);
 	}
 
 	return vfs_ioctl(filp, cmd, arg);
diff --git a/include/linux/falloc.h b/include/linux/falloc.h
index 73e0b62..fd1e871 100644
--- a/include/linux/falloc.h
+++ b/include/linux/falloc.h
@@ -21,7 +21,9 @@ struct space_resv {
 };
 
 #define FS_IOC_RESVSP		_IOW('X', 40, struct space_resv)
+#define FS_IOC_UNRESVSP		_IOW('X', 41, struct space_resv)
 #define FS_IOC_RESVSP64		_IOW('X', 42, struct space_resv)
+#define FS_IOC_UNRESVSP64	_IOW('X', 43, struct space_resv)
 
 #endif /* __KERNEL__ */
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 178cdb4..d13709c 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2031,7 +2031,7 @@ extern char * getname(const char __user *);
 
 /* fs/ioctl.c */
 
-extern int ioctl_preallocate(struct file *filp, void __user *argp);
+extern int ioctl_preallocate(struct file *filp, void __user *argp, int mode);
 
 /* fs/dcache.c */
 extern void __init vfs_caches_init_early(void);
-- 
1.7.2.3

