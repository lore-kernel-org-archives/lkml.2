Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753861Ab0H2R3B (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 13:29:01 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:51458 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753774Ab0H2R27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 13:28:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=oWGtngh5caNQgkxrTdstnWA4ozUQYFLBUWs7TvkuZ3w+QMpNuQDQfGEnfkmGFBcwJB
         z/txdh99t81Nm4hGR7No/fA8wZuYQ0LTcO2+l+DBTryrAcU4Ixp8Iy8bxYlg3tgkZYqa
         7Wd9tWg4U4iMDNmbYJo4Aad99aUl19y6SYjLY=
From: Namhyung Kim <namhyung@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Phillip Lougher <phillip@lougher.demon.co.uk>,
        Arnd Bergmann <arnd@arndb.de>, Al Viro <viro@zeniv.linux.org.uk>,
        linux-kernel@vger.kernel.org
Subject: [RFC v2 PATCH 1/3] init: add sys-wrapper.h
Date: Mon, 30 Aug 2010 02:28:46 +0900
Message-Id: <1283102928-3051-2-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1283102928-3051-1-git-send-email-namhyung@gmail.com>
References: <1283102928-3051-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sys-wrapper.h contains wrapper functions for various syscalls used in init
code. This wrappers handle proper address space conversion so that it can
remove a lot of warnings from sparse.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 init/sys-wrapper.h |  246 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 246 insertions(+), 0 deletions(-)
 create mode 100644 init/sys-wrapper.h

diff --git a/init/sys-wrapper.h b/init/sys-wrapper.h
new file mode 100644
index 0000000..e4227f9
--- /dev/null
+++ b/init/sys-wrapper.h
@@ -0,0 +1,246 @@
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
+/* These macro are called just before/after actual syscalls. */
+#define KSYS_PREPARE				\
+	mm_segment_t old_fs = get_fs();		\
+	set_fs(KERNEL_DS);
+
+#define KSYS_RESTORE				\
+	set_fs(old_fs);
+
+
+static inline int kern_sys_link(const char *oldname, const char *newname)
+{
+       int ret;
+       KSYS_PREPARE;
+
+       ret = sys_link((const char __user __force *) oldname,
+		      (const char __user __force *) newname);
+       KSYS_RESTORE;
+       return ret;
+}
+
+static inline int kern_sys_unlink(const char *pathname)
+{
+	int ret;
+	KSYS_PREPARE;
+
+	ret = sys_unlink((const char __user __force *) pathname);
+
+	KSYS_RESTORE;
+	return ret;
+}
+
+static inline int kern_sys_newlstat(const char *filename,
+				    struct stat *statbuf)
+{
+       int ret;
+       KSYS_PREPARE;
+
+       ret = sys_newlstat((const char __user __force *) filename,
+                          (struct stat __user __force *) statbuf);
+       KSYS_RESTORE;
+       return ret;
+}
+
+static inline int kern_sys_mkdir(const char *pathname, int mode)
+{
+	int ret;
+	KSYS_PREPARE;
+
+	ret = sys_mkdir((const char __user __force *) pathname, mode);
+
+	KSYS_RESTORE;
+	return ret;
+}
+
+static inline int kern_sys_rmdir(const char *pathname)
+{
+	int ret;
+	KSYS_PREPARE;
+
+	ret = sys_rmdir((const char __user __force *) pathname);
+
+	KSYS_RESTORE;
+	return ret;
+}
+
+static inline int kern_sys_mknod(const char *filename, int mode, unsigned dev)
+{
+	int ret;
+	KSYS_PREPARE;
+
+	ret = sys_mknod((const char __user __force *) filename, mode, dev);
+
+	KSYS_RESTORE;
+	return ret;
+}
+
+static inline int kern_sys_chown(const char *filename, uid_t user, gid_t group)
+{
+	int ret;
+	KSYS_PREPARE;
+
+	ret = sys_chown((const char __user __force *) filename, user, group);
+
+	KSYS_RESTORE;
+	return ret;
+}
+
+static inline int kern_sys_chmod(const char *filename, mode_t mode)
+{
+	int ret;
+	KSYS_PREPARE;
+
+	ret = sys_chmod((const char __user __force *) filename, mode);
+
+	KSYS_RESTORE;
+	return ret;
+}
+
+static inline int kern_sys_open(const char *filename, int flags, int mode)
+{
+	int ret;
+	KSYS_PREPARE;
+
+	ret = sys_open((const char __user __force *) filename, flags, mode);
+
+	KSYS_RESTORE;
+	return ret;
+}
+
+static inline int kern_sys_fchown(unsigned int fd, uid_t user, gid_t group)
+{
+	int ret;
+	KSYS_PREPARE;
+
+	ret = sys_fchown(fd, user, group);
+
+	KSYS_RESTORE;
+	return ret;
+}
+
+static inline int kern_sys_fchmod(unsigned int fd, mode_t mode)
+{
+	int ret;
+	KSYS_PREPARE;
+
+	ret = sys_fchmod(fd, mode);
+
+	KSYS_RESTORE;
+	return ret;
+}
+
+static inline int kern_sys_ftruncate(unsigned int fd, unsigned long length)
+{
+	int ret;
+	KSYS_PREPARE;
+
+	ret = sys_ftruncate(fd, length);
+
+	KSYS_RESTORE;
+	return ret;
+}
+
+static inline int kern_sys_read(unsigned int fd, char *buf, size_t count)
+{
+	int ret;
+	KSYS_PREPARE;
+
+	ret = sys_read(fd, (char __user __force *) buf, count);
+
+	KSYS_RESTORE;
+	return ret;
+}
+
+static inline int kern_sys_write(unsigned int fd, const char *buf,
+				 size_t count)
+{
+	int ret;
+	KSYS_PREPARE;
+
+	ret = sys_write(fd, (const char __user __force *) buf, count);
+
+	KSYS_RESTORE;
+	return ret;
+}
+
+static inline int kern_sys_close(unsigned int fd)
+{
+	int ret;
+	KSYS_PREPARE;
+
+	ret = sys_close(fd);
+
+	KSYS_RESTORE;
+	return ret;
+}
+
+static inline int kern_sys_symlink(const char *oldname, const char *newname)
+{
+	int ret;
+	KSYS_PREPARE;
+
+	ret = sys_symlink((const char __user __force *) oldname,
+			  (const char __user __force *) newname);
+	KSYS_RESTORE;
+	return ret;
+}
+
+static inline int kern_sys_lchown(const char *filename, uid_t user,
+				  gid_t group)
+{
+	int ret;
+	KSYS_PREPARE;
+
+	ret = sys_lchown((const char __user __force *) filename, user, group);
+
+	KSYS_RESTORE;
+	return ret;
+}
+
+static inline int kern_sys_getdents64(unsigned int fd,
+				      struct linux_dirent64 *dirent,
+				      unsigned int count)
+{
+	int ret;
+	KSYS_PREPARE;
+
+	ret = sys_getdents64(fd,
+			     (struct linux_dirent64 __user __force *) dirent,
+			     count);
+	KSYS_RESTORE;
+	return ret;
+}
+
+
+#undef KSYS_PREPARE
+#undef KSYS_RESTORE
-- 
1.7.2.2

