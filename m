Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753900Ab0H2R3I (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 13:29:08 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:51458 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753879Ab0H2R3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 13:29:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=C0qcbzQFugjO2u2BsFcZ1qACCdUZEXByQ2TZtftmBGOK9/rPlTCOO1bE2hWOgTx+P9
         OTLAc7/Q7j0qu+LIsaR4RsuFHYGi0T7j+9iSQ9cG4SgljILzbT37cTqd+7b8sO2z/ZE3
         epuo6yBqOniS+NRIe44YpuHD4+UzH6uGW16gk=
From: Namhyung Kim <namhyung@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Phillip Lougher <phillip@lougher.demon.co.uk>,
        Arnd Bergmann <arnd@arndb.de>, Al Viro <viro@zeniv.linux.org.uk>,
        linux-kernel@vger.kernel.org
Subject: [RFC v2 PATCH 3/3] init: introduce CONFIG_USE_INIT_SYSCALL_AS_KERNEL_ROUTINE
Date: Mon, 30 Aug 2010 02:28:48 +0900
Message-Id: <1283102928-3051-4-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1283102928-3051-1-git-send-email-namhyung@gmail.com>
References: <1283102928-3051-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add new config option USE_INIT_SYSCALL_AS_KERNEL_ROUTINE. This makes
some of kern_sys_*() functions call internal kernel routines directly
instead of calling syscall routine so that it can get rid of
user/kernel address space handling.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 init/Makefile      |    2 +
 init/sys-wrapper.h |   59 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 usr/Kconfig        |    7 ++++++
 3 files changed, 68 insertions(+), 0 deletions(-)

diff --git a/init/Makefile b/init/Makefile
index 0bf677a..296e5ab 100644
--- a/init/Makefile
+++ b/init/Makefile
@@ -15,6 +15,8 @@ mounts-$(CONFIG_BLK_DEV_RAM)	+= do_mounts_rd.o
 mounts-$(CONFIG_BLK_DEV_INITRD)	+= do_mounts_initrd.o
 mounts-$(CONFIG_BLK_DEV_MD)	+= do_mounts_md.o
 
+obj-$(CONFIG_USE_INIT_SYSCALL_AS_KERNEL_ROUTINE) += sys-wrapper.o
+
 # dependencies on generated files need to be listed explicitly
 $(obj)/version.o: include/generated/compile.h
 
diff --git a/init/sys-wrapper.h b/init/sys-wrapper.h
index e4227f9..38f9ec6 100644
--- a/init/sys-wrapper.h
+++ b/init/sys-wrapper.h
@@ -28,6 +28,8 @@
 #include <linux/syscalls.h>
 
 
+#ifndef CONFIG_USE_INIT_SYSCALL_AS_KERNEL_ROUTINE
+
 /* These macro are called just before/after actual syscalls. */
 #define KSYS_PREPARE				\
 	mm_segment_t old_fs = get_fs();		\
@@ -244,3 +246,60 @@ static inline int kern_sys_getdents64(unsigned int fd,
 
 #undef KSYS_PREPARE
 #undef KSYS_RESTORE
+
+#else /* !CONFIG_USE_INIT_SYSCALL_AS_KERNEL_ROUTINE */
+
+int kern_sys_link(const char *oldname, const char *newname);
+int kern_sys_unlink(const char *pathname);
+int kern_sys_newlstat(const char *filename, struct stat *statbuf);
+int kern_sys_mkdir(const char *pathname, int mode);
+int kern_sys_rmdir(const char *pathname);
+int kern_sys_mknod(const char *filename, int mode, unsigned dev);
+int kern_sys_chown(const char *filename, uid_t user, gid_t group);
+int kern_sys_chmod(const char *filename, mode_t mode);
+int kern_sys_open(const char *filename, int flags, int mode);
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
+static inline int kern_sys_ftruncate(unsigned int fd, unsigned long length)
+{
+	return sys_ftruncate(fd, length);
+}
+
+static inline int kern_sys_read(unsigned int fd, char *buf, size_t count)
+{
+	return sys_read(fd, (char __user __force *) buf, count);
+}
+
+static inline int kern_sys_write(unsigned int fd, const char *buf,
+				 size_t count)
+{
+	return sys_write(fd, (const char __user __force *) buf, count);
+}
+
+static inline int kern_sys_close(unsigned int fd)
+{
+	return sys_close(fd);
+}
+
+int kern_sys_symlink(const char *oldname, const char *newname);
+int kern_sys_lchown(const char *filename, uid_t user, gid_t group);
+
+static inline int kern_sys_getdents64(unsigned int fd,
+				      struct linux_dirent64 *dirent,
+				      unsigned int count)
+{
+	return sys_getdents64(fd,
+			      (struct linux_dirent64 __user __force *) dirent,
+			      count);
+}
+
+#endif /* !CONFIG_USE_INIT_SYSCALL_AS_KERNEL_ROUTINE */
diff --git a/usr/Kconfig b/usr/Kconfig
index e2721f5..2a914eb 100644
--- a/usr/Kconfig
+++ b/usr/Kconfig
@@ -148,3 +148,10 @@ config INITRAMFS_COMPRESSION_LZO
 	  (both compression and decompression) is the fastest.
 
 endchoice
+
+config USE_INIT_SYSCALL_AS_KERNEL_ROUTINE
+        bool "Don't call syscalls on init code"
+	depends on BLK_DEV_INITRD
+	default n
+	help
+	  replace syscalls to kernel functions in init code.
-- 
1.7.2.2

