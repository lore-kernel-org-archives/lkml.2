Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756226Ab2FJJXs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 05:23:48 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:50509 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754626Ab2FJJXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 05:23:45 -0400
Message-ID: <4FD4661C.1060809@gmail.com>
Date: Sun, 10 Jun 2012 11:17:16 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120421 Thunderbird/12.0
MIME-Version: 1.0
To: Linux FS Devel <linux-fsdevel@vger.kernel.org>
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 17/17] pramfs: makefile and Kconfig
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marco Stornelli <marco.stornelli@gmail.com>

Makefile and Kconfig.

Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
---
diff -Nurp linux-3.5.rc2-orig/arch/Kconfig linux-3.5-rc2/arch/Kconfig
--- linux-3.5-rc2-orig/arch/Kconfig	2012-06-09 03:40:09.000000000 +0200
+++ linux-3.5-rc2/arch/Kconfig	2012-06-10 10:08:27.000000000 +0200
@@ -129,6 +129,9 @@ config USER_RETURN_NOTIFIER
 config HAVE_IOREMAP_PROT
 	bool

+config HAVE_SET_MEMORY_RO
+	bool
+
 config HAVE_KPROBES
 	bool

diff -Nurp linux-3.5-rc2-orig/fs/Kconfig linux-3.5-rc2/fs/Kconfig
--- linux-3.5-rc2-orig/fs/Kconfig	2012-06-09 03:40:09.000000000 +0200
+++ linux-3.5-rc2/fs/Kconfig	2012-06-10 10:08:27.000000000 +0200
@@ -17,7 +17,7 @@ source "fs/ext4/Kconfig"
 config FS_XIP
 # execute in place
 	bool
-	depends on EXT2_FS_XIP
+	depends on EXT2_FS_XIP || PRAMFS_XIP
 	default y

 source "fs/jbd/Kconfig"
@@ -29,7 +29,8 @@ config FS_MBCACHE
 	default y if EXT2_FS=y && EXT2_FS_XATTR
 	default y if EXT3_FS=y && EXT3_FS_XATTR
 	default y if EXT4_FS=y && EXT4_FS_XATTR
-	default m if EXT2_FS_XATTR || EXT3_FS_XATTR || EXT4_FS_XATTR
+	default y if PRAMFS=y && PRAMFS_XATTR
+	default m if EXT2_FS_XATTR || EXT3_FS_XATTR || EXT4_FS_XATTR || PRAMFS_XATTR

 source "fs/reiserfs/Kconfig"
 source "fs/jfs/Kconfig"
@@ -219,6 +220,7 @@ source "fs/romfs/Kconfig"
 source "fs/pstore/Kconfig"
 source "fs/sysv/Kconfig"
 source "fs/ufs/Kconfig"
+source "fs/pramfs/Kconfig"
 source "fs/exofs/Kconfig"

 endif # MISC_FILESYSTEMS
diff -Nurp linux-3.5-rc2-orig/fs/Makefile linux-3.5-rc2/fs/Makefile
--- linux-3.5-rc2-orig/fs/Makefile	2012-06-09 03:40:09.000000000 +0200
+++ linux-3.5-rc2/fs/Makefile	2012-06-10 10:08:28.000000000 +0200
@@ -125,3 +125,4 @@ obj-$(CONFIG_GFS2_FS)           += gfs2/
 obj-y				+= exofs/ # Multiple modules
 obj-$(CONFIG_CEPH_FS)		+= ceph/
 obj-$(CONFIG_PSTORE)		+= pstore/
+obj-$(CONFIG_PRAMFS)		+= pramfs/
diff -Nurp linux-3.5-rc2-orig/fs/pramfs/Kconfig linux-3.5-rc2/fs/pramfs/Kconfig
--- linux-3.5-rc2-orig/fs/pramfs/Kconfig	1970-01-01 01:00:00.000000000 +0100
+++ linux-3.5-rc2/fs/pramfs/Kconfig	2012-06-10 10:08:28.000000000 +0200
@@ -0,0 +1,72 @@
+config PRAMFS
+	tristate "Persistent and Protected RAM file system support"
+	depends on HAS_IOMEM && EXPERIMENTAL
+	select CRC16
+	help
+	   If your system has a block of fast (comparable in access speed to
+	   system memory) and non-volatile RAM and you wish to mount a
+	   light-weight, full-featured, and space-efficient filesystem over it,
+	   say Y here, and read <file:Documentation/filesystems/pramfs.txt>.
+
+	   To compile this as a module,  choose M here: the module will be
+	   called pramfs.
+
+config PRAMFS_XIP
+	bool "Execute-in-place in PRAMFS"
+	depends on PRAMFS && BLOCK
+	help
+	   Say Y here to enable XIP feature of PRAMFS.
+
+config PRAMFS_WRITE_PROTECT
+	bool "PRAMFS write protection"
+	depends on PRAMFS && MMU && HAVE_SET_MEMORY_RO
+	default y
+	help
+	   Say Y here to enable the write protect feature of PRAMFS.
+
+config PRAMFS_XATTR
+	bool "PRAMFS extended attributes"
+	depends on PRAMFS && BLOCK
+	help
+	  Extended attributes are name:value pairs associated with inodes by
+	  the kernel or by users (see the attr(5) manual page, or visit
+	  <http://acl.bestbits.at/> for details).
+
+	  If unsure, say N.
+
+config PRAMFS_POSIX_ACL
+	bool "PRAMFS POSIX Access Control Lists"
+	depends on PRAMFS_XATTR
+	select FS_POSIX_ACL
+	help
+	  Posix Access Control Lists (ACLs) support permissions for users and
+	  groups beyond the owner/group/world scheme.
+
+	  To learn more about Access Control Lists, visit the Posix ACLs for
+	  Linux website <http://acl.bestbits.at/>.
+
+	  If you don't know what Access Control Lists are, say N.
+
+config PRAMFS_SECURITY
+	bool "PRAMFS Security Labels"
+	depends on PRAMFS_XATTR
+	help
+	  Security labels support alternative access control models
+	  implemented by security modules like SELinux.  This option
+	  enables an extended attribute handler for file security
+	  labels in the pram filesystem.
+
+	  If you are not using a security module that requires using
+	  extended attributes for file security labels, say N.
+
+config PRAMFS_TEST
+	boolean
+	depends on PRAMFS
+
+config PRAMFS_TEST_MODULE
+	tristate "PRAMFS Test"
+	depends on PRAMFS && PRAMFS_WRITE_PROTECT && m
+	select PRAMFS_TEST
+	help
+	  Say Y here to build a simple module to test the protection of
+	  PRAMFS. The module will be called pramfs_test.
diff -Nurp linux-3.0.29-orig/fs/pramfs/Makefile linux-3.0.29/fs/pramfs/Makefile
--- linux-3.0.29-orig/fs/pramfs/Makefile	1970-01-01 01:00:00.000000000 +0100
+++ linux-3.0.29/fs/pramfs/Makefile	2012-04-30 10:16:36.000000000 +0200
@@ -0,0 +1,14 @@
+#
+# Makefile for the linux pram-filesystem routines.
+#
+
+obj-$(CONFIG_PRAMFS) += pramfs.o
+obj-$(CONFIG_PRAMFS_TEST_MODULE) += pramfs_test.o
+
+pramfs-y := balloc.o dir.o file.o inode.o namei.o super.o symlink.o ioctl.o
+
+pramfs-$(CONFIG_PRAMFS_WRITE_PROTECT) += wprotect.o
+pramfs-$(CONFIG_PRAMFS_XIP) += xip.o
+pramfs-$(CONFIG_PRAMFS_XATTR) += xattr.o xattr_user.o xattr_trusted.o desctree.o
+pramfs-$(CONFIG_PRAMFS_POSIX_ACL) += acl.o
+pramfs-$(CONFIG_PRAMFS_SECURITY) += xattr_security.o
diff -Nurp linux-3.5.rc2-orig/arch/x86/Kconfig linux-3.5-rc2/arch/x86/Kconfig
--- linux-3.5-rc2-orig/arch/x86/Kconfig	2012-06-09 03:40:09.000000000 +0200
+++ linux-3.5-rc2/arch/x86/Kconfig	2012-06-10 10:08:27.000000000 +0200
@@ -24,6 +24,7 @@ config X86
 	select HAVE_PCSPKR_PLATFORM
 	select HAVE_PERF_EVENTS
 	select HAVE_IRQ_WORK
+	select HAVE_SET_MEMORY_RO
 	select HAVE_IOREMAP_PROT
 	select HAVE_KPROBES
 	select HAVE_MEMBLOCK
diff -Nurp linux-3.5.rc2-orig/MAINTAINERS linux-3.5-rc2/MAINTAINERS
--- linux-3.5-rc2-orig/MAINTAINERS	2012-06-09 03:40:09.000000000 +0200
+++ linux-3.5-rc2/MAINTAINERS	2012-06-10 10:08:28.000000000 +0200
@@ -5407,6 +5407,15 @@ S:	Maintained
 F:	drivers/net/ppp/pptp.c
 W:	http://sourceforge.net/projects/accel-pptp

+PRAM FILE SYSTEM
+M:	Marco Stornelli <marco.stornelli@gmail.com>
+W:	http://pramfs.sourceforge.net
+L:	pramfs-devel@lists.sourceforge.net (subscribers-only)
+S:	Maintained
+F:	Documentation/filesystems/pramfs.txt
+F:	fs/pramfs/
+F:	include/linux/pram*
+
 PREEMPTIBLE KERNEL
 M:	Robert Love <rml@tech9.net>
 L:	kpreempt-tech@lists.sourceforge.net
