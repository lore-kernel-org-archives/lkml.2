Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756230Ab0H3R2k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 13:28:40 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:57857 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756184Ab0H3R2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 13:28:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=xvArMjtrTYD4ZMEQRYjqMi0AvZKMhn8kw+Cq43dLv+GdmF2ypICworR1H5mvoB/R9u
         yrGU81YUl3UuLB0BwOUe8PE45JRNALx9JU3GrKkX9Iy7bRxOLCH3M5yv+qPc2vgDtOHL
         MVRAe2uMpbrS4Rz6BpolDcCfC8ogdisnE6Cdo=
From: Namhyung Kim <namhyung@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Phillip Lougher <phillip@lougher.demon.co.uk>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: [PATCH v3 1/2] init: add sys-wrapper.h
Date: Tue, 31 Aug 2010 02:27:49 +0900
Message-Id: <1283189270-7274-2-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1283189270-7274-1-git-send-email-namhyung@gmail.com>
References: <1283189270-7274-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sys-wrapper.h contains wrapper functions for various syscalls used in init
code. This wrappers handle proper address space conversion so that it can
remove a lot of warnings from sparse.

Suggested-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 init/sys-wrapper.h |  230 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 230 insertions(+), 0 deletions(-)
 create mode 100644 init/sys-wrapper.h

diff --git a/init/sys-wrapper.h b/init/sys-wrapper.h
new file mode 100644
index 0000000..9aa904c
--- /dev/null
+++ b/init/sys-wrapper.h
@@ -0,0 +1,230 @@
+/*
+ * init/sys-wrapper.h
+ *
+ * Copyright (C) 2010  Namhyung Kim <namhyung@gmail.com>
+ *
+ * wrappers for various syscalls for use in the init code
+ *
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License v2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public
+ * License along with this program; if not, write to the
+ * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
+ * Boston, MA 021110-1307, USA.
+ */
+
+#include <linux/fs.h>
+#include <linux/types.h>
+#include <linux/fcntl.h>
+#include <linux/dirent.h>
+#include <linux/syscalls.h>
+
+
+#define kern_sys_call(call, ...)		\
+({						\
+	long result;				\
+	mm_segment_t old_fs = get_fs();		\
+	set_fs(KERNEL_DS);			\
+	result = call(__VA_ARGS__);		\
+	set_fs(old_fs);				\
+	result;					\
+})
+
+static inline int kern_sys_mount(char *dev_name, char *dir_name, char *type,
+				 unsigned long flags, void *data)
+{
+	return kern_sys_call(sys_mount,
+			     (char __user __force *) dev_name,
+			     (char __user __force *) dir_name,
+			     (char __user __force *) type,
+			     flags,
+			     (void __user __force *) data);
+}
+
+static inline int kern_sys_umount(char *name, int flags)
+{
+	return kern_sys_call(sys_umount,
+			     (char __user __force *) name, flags);
+}
+
+static inline int kern_sys_chroot(const char *pathname)
+{
+	return kern_sys_call(sys_chroot,
+			     (const char __user __force *) pathname);
+}
+
+static inline int kern_sys_link(const char *oldname, const char *newname)
+{
+	return kern_sys_call(sys_link,
+			     (const char __user __force *) oldname,
+			     (const char __user __force *) newname);
+}
+
+static inline int kern_sys_unlink(const char *pathname)
+{
+	return kern_sys_call(sys_unlink,
+			     (const char __user __force *) pathname);
+}
+
+static inline int kern_sys_newlstat(const char *filename,
+				    struct stat *statbuf)
+{
+	return kern_sys_call(sys_newlstat,
+			     (const char __user __force *) filename,
+			     (struct stat __user __force *) statbuf);
+}
+
+static inline int kern_sys_mkdir(const char *pathname, int mode)
+{
+	return kern_sys_call(sys_mkdir,
+			     (const char __user __force *) pathname, mode);
+}
+
+static inline int kern_sys_rmdir(const char *pathname)
+{
+	return kern_sys_call(sys_rmdir,
+			     (const char __user __force *) pathname);
+}
+
+static inline int kern_sys_chdir(const char *pathname)
+{
+	return kern_sys_call(sys_chdir,
+			     (const char __user __force *) pathname);
+}
+
+static inline int kern_sys_mknod(const char *filename, int mode, unsigned dev)
+{
+	return kern_sys_call(sys_mknod,
+			     (const char __user __force *) filename,
+			     mode, dev);
+}
+
+static inline int kern_sys_chown(const char *filename, uid_t user, gid_t group)
+{
+	return kern_sys_call(sys_chown,
+			     (const char __user __force *) filename,
+			     user, group);
+}
+
+static inline int kern_sys_chmod(const char *filename, mode_t mode)
+{
+	return kern_sys_call(sys_chmod,
+			     (const char __user __force *) filename, mode);
+}
+
+static inline int kern_sys_open(const char *filename, int flags, int mode)
+{
+	return kern_sys_call(sys_open,
+			     (const char __user __force *) filename,
+			     flags, mode);
+}
+
+static inline int kern_sys_fchown(unsigned int fd, uid_t user, gid_t group)
+{
+	return sys_fchown(fd, user, group);
+}
+
+static inline int kern_sys_fchmod(unsigned int fd, mode_t mode)
+{
+	return sys_fchmod(fd, mode);
+}
+
+static inline int kern_sys_fchdir(unsigned int fd)
+{
+	return sys_fchdir(fd);
+}
+
+static inline int kern_sys_ftruncate(unsigned int fd, unsigned long length)
+{
+	return sys_ftruncate(fd, length);
+}
+
+static inline int kern_sys_read(unsigned int fd, char *buf, size_t count)
+{
+	return kern_sys_call(sys_read,
+			     fd, (char __user __force *) buf, count);
+}
+
+static inline int kern_sys_write(unsigned int fd, const char *buf,
+				 size_t count)
+{
+	return kern_sys_call(sys_write,
+			     fd, (const char __user __force *) buf, count);
+}
+
+static inline int kern_sys_lseek(unsigned int fd, off_t offset,
+				 unsigned int origin)
+{
+	return sys_lseek(fd, offset, origin);
+}
+
+static inline int kern_sys_ioctl(unsigned int fd, unsigned int cmd,
+				 unsigned long arg)
+{
+	return sys_ioctl(fd, cmd, arg);
+}
+
+static inline int kern_sys_dup(unsigned int fd)
+{
+	return sys_dup(fd);
+}
+
+static inline int kern_sys_close(unsigned int fd)
+{
+	return sys_close(fd);
+}
+
+static inline int kern_sys_symlink(const char *oldname, const char *newname)
+{
+	return kern_sys_call(sys_symlink,
+			     (const char __user __force *) oldname,
+			     (const char __user __force *) newname);
+}
+
+static inline int kern_sys_lchown(const char *filename, uid_t user,
+				  gid_t group)
+{
+	return kern_sys_call(sys_lchown,
+			     (const char __user __force *) filename,
+			     user, group);
+}
+
+static inline int kern_sys_getdents64(unsigned int fd,
+				      struct linux_dirent64 *dirent,
+				      unsigned int count)
+{
+	return kern_sys_call(sys_getdents64,
+			     fd,
+			     (struct linux_dirent64 __user __force *) dirent,
+			     count);
+}
+
+static inline int kern_sys_access(const char *filename, int mode)
+{
+	return kern_sys_call(sys_access,
+			     (const char __user __force *) filename, mode);
+}
+
+static inline int kern_sys_setsid(void)
+{
+	return sys_setsid();
+}
+
+static inline int kern_sys_wait4(pid_t upid, int *stat_addr, int options,
+				 struct rusage *ru)
+{
+	return kern_sys_call(sys_wait4,
+			     upid,
+			     (int __user __force *) stat_addr,
+			     options,
+			     (struct rusage __user __force *) ru);
+}
+
-- 
1.7.2.2

