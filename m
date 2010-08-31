Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932464Ab0HaPal (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 11:30:41 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:47133 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932451Ab0HaPaj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 11:30:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=kslF9+Kkj2PZS6/F1o//nTp0vkPQvcBPzRlczu/2x11uYX6Tt2PBGUskoKpcqixFNm
         JodEF2cxNLq6c3n8rSS3BPVYDAgmNY1QBtB8Zj/S/kpPjX7Q+Xgu6htr41FWCPXR5FPu
         0PUTaY49uZBimHROHLHq2B6G7SH8u8J/vAYlA=
From: Namhyung Kim <namhyung@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Arnd Bergmann <arnd@arndb.de>,
        Phillip Lougher <phillip@lougher.demon.co.uk>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: [PATCH v4 1/2] init: add sys-wrapper.h
Date: Wed,  1 Sep 2010 00:30:18 +0900
Message-Id: <1283268619-10728-2-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1283268619-10728-1-git-send-email-namhyung@gmail.com>
References: <1283268619-10728-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sys-wrapper.h contains wrapper functions for various syscalls used in init
code. This wrappers handle proper address space conversion so that it can
remove a lot of warnings from sparse.

Suggested-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 init/sys-wrapper.h |  216 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 216 insertions(+), 0 deletions(-)
 create mode 100644 init/sys-wrapper.h

diff --git a/init/sys-wrapper.h b/init/sys-wrapper.h
new file mode 100644
index 0000000..10109b6
--- /dev/null
+++ b/init/sys-wrapper.h
@@ -0,0 +1,216 @@
+/*
+ * wrappers for various syscalls for use in the init code
+ *
+ * Copyright (C) 2010  Namhyung Kim <namhyung@gmail.com>
+ *
+ * This file is released under the GPLv2.
+ */
+
+#include <linux/syscalls.h>
+#include <linux/uaccess.h>
+#include <linux/dirent.h>
+#include <linux/types.h>
+#include <linux/fs.h>
+
+
+#define kernel_sys_call(call, ...)		\
+({						\
+	long result;				\
+	mm_segment_t old_fs = get_fs();		\
+	set_fs(KERNEL_DS);			\
+	result = call(__VA_ARGS__);		\
+	set_fs(old_fs);				\
+	result;					\
+})
+
+static inline int kernel_sys_mount(char *dev_name, char *dir_name, char *type,
+				   unsigned long flags, void *data)
+{
+	return kernel_sys_call(sys_mount,
+			       (char __user __force *) dev_name,
+			       (char __user __force *) dir_name,
+			       (char __user __force *) type,
+			       flags,
+			       (void __user __force *) data);
+}
+
+static inline int kernel_sys_umount(char *name, int flags)
+{
+	return kernel_sys_call(sys_umount,
+			       (char __user __force *) name, flags);
+}
+
+static inline int kernel_sys_chroot(const char *pathname)
+{
+	return kernel_sys_call(sys_chroot,
+			       (const char __user __force *) pathname);
+}
+
+static inline int kernel_sys_link(const char *oldname, const char *newname)
+{
+	return kernel_sys_call(sys_link,
+			       (const char __user __force *) oldname,
+			       (const char __user __force *) newname);
+}
+
+static inline int kernel_sys_unlink(const char *pathname)
+{
+	return kernel_sys_call(sys_unlink,
+			       (const char __user __force *) pathname);
+}
+
+static inline int kernel_sys_newlstat(const char *filename,
+				      struct stat *statbuf)
+{
+	return kernel_sys_call(sys_newlstat,
+			       (const char __user __force *) filename,
+			       (struct stat __user __force *) statbuf);
+}
+
+static inline int kernel_sys_mkdir(const char *pathname, int mode)
+{
+	return kernel_sys_call(sys_mkdir,
+			       (const char __user __force *) pathname, mode);
+}
+
+static inline int kernel_sys_rmdir(const char *pathname)
+{
+	return kernel_sys_call(sys_rmdir,
+			       (const char __user __force *) pathname);
+}
+
+static inline int kernel_sys_chdir(const char *pathname)
+{
+	return kernel_sys_call(sys_chdir,
+			       (const char __user __force *) pathname);
+}
+
+static inline int kernel_sys_mknod(const char *filename,
+				   int mode, unsigned dev)
+{
+	return kernel_sys_call(sys_mknod,
+			       (const char __user __force *) filename,
+			       mode, dev);
+}
+
+static inline int kernel_sys_chown(const char *filename,
+				   uid_t user, gid_t group)
+{
+	return kernel_sys_call(sys_chown,
+			       (const char __user __force *) filename,
+			       user, group);
+}
+
+static inline int kernel_sys_chmod(const char *filename, mode_t mode)
+{
+	return kernel_sys_call(sys_chmod,
+			       (const char __user __force *) filename, mode);
+}
+
+static inline int kernel_sys_open(const char *filename, int flags, int mode)
+{
+	return kernel_sys_call(sys_open,
+			       (const char __user __force *) filename,
+			       flags, mode);
+}
+
+static inline int kernel_sys_fchown(unsigned int fd, uid_t user, gid_t group)
+{
+	return sys_fchown(fd, user, group);
+}
+
+static inline int kernel_sys_fchmod(unsigned int fd, mode_t mode)
+{
+	return sys_fchmod(fd, mode);
+}
+
+static inline int kernel_sys_fchdir(unsigned int fd)
+{
+	return sys_fchdir(fd);
+}
+
+static inline int kernel_sys_ftruncate(unsigned int fd, unsigned long length)
+{
+	return sys_ftruncate(fd, length);
+}
+
+static inline int kernel_sys_read(unsigned int fd, char *buf, size_t count)
+{
+	return kernel_sys_call(sys_read,
+			       fd, (char __user __force *) buf, count);
+}
+
+static inline int kernel_sys_write(unsigned int fd, const char *buf,
+				   size_t count)
+{
+	return kernel_sys_call(sys_write,
+			       fd, (const char __user __force *) buf, count);
+}
+
+static inline int kernel_sys_lseek(unsigned int fd, off_t offset,
+				   unsigned int origin)
+{
+	return sys_lseek(fd, offset, origin);
+}
+
+static inline int kernel_sys_ioctl(unsigned int fd, unsigned int cmd,
+				   unsigned long arg)
+{
+	return sys_ioctl(fd, cmd, arg);
+}
+
+static inline int kernel_sys_dup(unsigned int fd)
+{
+	return sys_dup(fd);
+}
+
+static inline int kernel_sys_close(unsigned int fd)
+{
+	return sys_close(fd);
+}
+
+static inline int kernel_sys_symlink(const char *oldname, const char *newname)
+{
+	return kernel_sys_call(sys_symlink,
+			       (const char __user __force *) oldname,
+			       (const char __user __force *) newname);
+}
+
+static inline int kernel_sys_lchown(const char *filename, uid_t user,
+				    gid_t group)
+{
+	return kernel_sys_call(sys_lchown,
+			       (const char __user __force *) filename,
+			       user, group);
+}
+
+static inline int kernel_sys_getdents64(unsigned int fd,
+					struct linux_dirent64 *dirent,
+					unsigned int count)
+{
+	return kernel_sys_call(sys_getdents64,
+			       fd,
+			       (struct linux_dirent64 __user __force *) dirent,
+			       count);
+}
+
+static inline int kernel_sys_access(const char *filename, int mode)
+{
+	return kernel_sys_call(sys_access,
+			       (const char __user __force *) filename, mode);
+}
+
+static inline int kernel_sys_setsid(void)
+{
+	return sys_setsid();
+}
+
+static inline int kernel_sys_wait4(pid_t upid, int *stat_addr, int options,
+				   struct rusage *ru)
+{
+	return kernel_sys_call(sys_wait4,
+			       upid,
+			       (int __user __force *) stat_addr,
+			       options,
+			       (struct rusage __user __force *) ru);
+}
-- 
1.7.2.2

