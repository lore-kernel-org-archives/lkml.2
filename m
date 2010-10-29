Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933687Ab0J2J6W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 05:58:22 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:42966 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761215Ab0J2J6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 05:58:19 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: hch@infradead.org, viro@zeniv.linux.org.uk, adilger@sun.com,
        corbet@lwn.net, neilb@suse.de, npiggin@kernel.dk,
        hooanon05@yahoo.co.jp, bfields@fieldses.org, miklos@szeredi.hu
Cc: linux-fsdevel@vger.kernel.org, sfrench@us.ibm.com, philippe.deniel@CEA.FR,
        linux-kernel@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH -V22 05/14] vfs: Add handle based stat syscall
Date: Fri, 29 Oct 2010 15:27:14 +0530
Message-Id: <1288346243-12211-6-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1288346243-12211-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1288346243-12211-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 arch/x86/ia32/sys_ia32.c |   13 +++++++++++++
 fs/stat.c                |   42 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/fs.h       |    3 +++
 include/linux/syscalls.h |    9 +++++++++
 4 files changed, 67 insertions(+), 0 deletions(-)

diff --git a/arch/x86/ia32/sys_ia32.c b/arch/x86/ia32/sys_ia32.c
index 849813f..7f679e4 100644
--- a/arch/x86/ia32/sys_ia32.c
+++ b/arch/x86/ia32/sys_ia32.c
@@ -138,6 +138,19 @@ asmlinkage long sys32_fstatat(unsigned int dfd, const char __user *filename,
 	return cp_stat64(statbuf, &stat);
 }
 
+asmlinkage long sys32_handle_stat64(int mountdirfd,
+				    struct file_handle __user *ufh,
+				    struct stat64 __user *statbuf)
+{
+	struct kstat stat;
+	int error;
+
+	error = do_handle_stat(mountdirfd, ufh, &stat);
+	if (error)
+		return error;
+	return cp_stat64(statbuf, &stat);
+}
+
 /*
  * Linux/i386 didn't use to be able to handle more than
  * 4 system call parameters, so these system calls used a memory
diff --git a/fs/stat.c b/fs/stat.c
index 29052eb..d448876 100644
--- a/fs/stat.c
+++ b/fs/stat.c
@@ -286,6 +286,35 @@ SYSCALL_DEFINE2(newfstat, unsigned int, fd, struct stat __user *, statbuf)
 	return error;
 }
 
+int do_handle_stat(int mountdirfd, struct file_handle __user *ufh,
+		   struct kstat *stat)
+{
+	struct path path;
+	int error = -EINVAL;
+
+	error = handle_to_path(mountdirfd, ufh, &path);
+	if (error)
+		goto out;
+
+	error = vfs_getattr(path.mnt, path.dentry, stat);
+	path_put(&path);
+out:
+	return error;
+}
+
+SYSCALL_DEFINE3(handle_stat, int, mountdirfd,
+		struct file_handle __user *, ufh,
+		struct stat __user *, statbuf)
+{
+	struct kstat stat;
+	int error;
+
+	error = do_handle_stat(mountdirfd, ufh, &stat);
+	if (error)
+		return error;
+	return cp_new_stat(&stat, statbuf);
+}
+
 SYSCALL_DEFINE4(readlinkat, int, dfd, const char __user *, pathname,
 		char __user *, buf, int, bufsiz)
 {
@@ -434,6 +463,19 @@ SYSCALL_DEFINE4(fstatat64, int, dfd, const char __user *, filename,
 		return error;
 	return cp_new_stat64(&stat, statbuf);
 }
+
+SYSCALL_DEFINE3(handle_stat64, int, mountdirfd,
+		struct file_handle __user *, ufh,
+		struct stat64 __user *, statbuf)
+{
+	struct kstat stat;
+	int error;
+
+	error = do_handle_stat(mountdirfd, ufh, &stat);
+	if (error)
+		return error;
+	return cp_new_stat64(&stat, statbuf);
+}
 #endif /* __ARCH_WANT_STAT64 */
 
 /* Caller is here responsible for sufficient locking (ie. inode->i_lock) */
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 1f8b4d9..2ab3062 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2370,6 +2370,9 @@ extern int vfs_stat(const char __user *, struct kstat *);
 extern int vfs_lstat(const char __user *, struct kstat *);
 extern int vfs_fstat(unsigned int, struct kstat *);
 extern int vfs_fstatat(int , const char __user *, struct kstat *, int);
+extern int do_handle_stat(int mountdirfd,
+			  struct file_handle __user *ufh,
+			  struct kstat *stat);
 
 extern int do_vfs_ioctl(struct file *filp, unsigned int fd, unsigned int cmd,
 		    unsigned long arg);
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 7361880..dd1d994 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -842,4 +842,13 @@ asmlinkage long sys_open_by_handle_at(int mountdirfd,
 asmlinkage long sys_handle_readlink(int mountdirfd,
 				    struct file_handle __user *ufh,
 				    char __user *buf, int bufsiz);
+#if BITS_PER_LONG == 32
+asmlinkage long sys_handle_stat64(int mountdirfd,
+				  struct file_handle __user *ufh,
+				  struct stat64 __user *statbuf);
+#else
+asmlinkage long sys_handle_stat(int mountdirfd,
+				struct file_handle __user *ufh,
+				struct stat __user *statbuf);
+#endif
 #endif
-- 
1.7.1

