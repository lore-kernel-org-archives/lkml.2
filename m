Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932191Ab0LPSGU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 13:06:20 -0500
Received: from mail-ey0-f171.google.com ([209.85.215.171]:52270 "EHLO
	mail-ey0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932086Ab0LPSGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 13:06:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=gqgU8LmrlgPsQMfsKV6BXekYekOzBUouzgpbTaRb7CiJYKXucwFVdJPpK+J0lW3ggH
         lZC5jjbhh54lf2EylEywu/2VtLWgNoMGy/qUrfili/Xc8WMe8w5kKqp2PxTC/UiQNa+L
         PSuHpLRJv9pxzpSnotCNHKba+6MbAnauLxxQs=
Message-ID: <4D0A5447.4040909@gmail.com>
Date: Thu, 16 Dec 2010 19:02:47 +0100
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; it; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>
CC: Linux Embedded <linux-embedded@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Tim Bird <tim.bird@am.sony.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 16/16 v5] pramfs: Makefile and Kconfig
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marco Stornelli <marco.stornelli@gmail.com>

Makefile and Kconfig.

Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
---
diff -Nurp linux-2.6.36-orig/fs/Makefile linux-2.6.36/fs/Makefile
--- linux-2.6.36-orig/fs/Makefile	2010-09-13 01:07:37.000000000 +0200
+++ linux-2.6.36/fs/Makefile	2010-09-14 18:49:52.000000000 +0200
@@ -126,3 +126,4 @@ obj-$(CONFIG_BTRFS_FS)		+= btrfs/
 obj-$(CONFIG_GFS2_FS)           += gfs2/
 obj-$(CONFIG_EXOFS_FS)          += exofs/
 obj-$(CONFIG_CEPH_FS)		+= ceph/
+obj-$(CONFIG_PRAMFS)		+= pramfs/
diff -Nurp linux-2.6.36-orig/fs/Kconfig linux-2.6.36/fs/Kconfig
--- linux-2.6.36-orig/fs/Kconfig	2010-09-13 01:07:37.000000000 +0200
+++ linux-2.6.36/fs/Kconfig	2010-09-14 18:49:52.000000000 +0200
@@ -13,7 +13,7 @@ source "fs/ext4/Kconfig"
 config FS_XIP
 # execute in place
 	bool
-	depends on EXT2_FS_XIP
+	depends on EXT2_FS_XIP || PRAMFS_XIP
 	default y
  source "fs/jbd/Kconfig"
@@ -25,13 +25,14 @@ config FS_MBCACHE
 	default y if EXT2_FS=y && EXT2_FS_XATTR
 	default y if EXT3_FS=y && EXT3_FS_XATTR
 	default y if EXT4_FS=y && EXT4_FS_XATTR
-	default m if EXT2_FS_XATTR || EXT3_FS_XATTR || EXT4_FS_XATTR
+	default y if PRAMFS=y && PRAMFS_XATTR
+	default m if EXT2_FS_XATTR || EXT3_FS_XATTR || EXT4_FS_XATTR || PRAMFS_XATTR
  source "fs/reiserfs/Kconfig"
 source "fs/jfs/Kconfig"
  config FS_POSIX_ACL
-# Posix ACL utility routines (for now, only ext2/ext3/jfs/reiserfs/nfs4)
+# Posix ACL utility routines (for now, only ext2/ext3/jfs/reiserfs/nfs4/pramfs)
 #
 # NOTE: you can implement Posix ACLs without these helpers (XFS does).
 # 	Never use this symbol for ifdefs.
@@ -189,6 +190,7 @@ source "fs/romfs/Kconfig"
 source "fs/sysv/Kconfig"
 source "fs/ufs/Kconfig"
 source "fs/exofs/Kconfig"
+source "fs/pramfs/Kconfig"
  endif # MISC_FILESYSTEMS
 diff -Nurp linux-2.6.36-orig/fs/pramfs/Kconfig linux-2.6.36/fs/pramfs/Kconfig
--- linux-2.6.36-orig/fs/pramfs/Kconfig	1970-01-01 01:00:00.000000000 +0100
+++ linux-2.6.36/fs/pramfs/Kconfig	2010-12-12 10:42:23.000000000 +0100
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
+	depends on PRAMFS
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
+	depends on PRAMFS
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
+	depends on PRAMFS && m
+	select PRAMFS_TEST
+	help
+	  Say Y here to build a simple module to test the protection of
+	  PRAMFS. The module will be called pramfs_test.
diff -Nurp linux-2.6.36-orig/arch/Kconfig linux-2.6.36/arch/Kconfig
--- linux-2.6.36-orig/arch/Kconfig	2010-10-20 22:30:22.000000000 +0200
+++ linux-2.6.36/arch/Kconfig	2010-11-01 11:42:26.000000000 +0100
@@ -83,6 +83,9 @@ config USER_RETURN_NOTIFIER
 config HAVE_IOREMAP_PROT
 	bool
 +config HAVE_SET_MEMORY_RO
+	bool
+
 config HAVE_KPROBES
 	bool
 diff -Nurp linux-2.6.36-orig/arch/x86/Kconfig linux-2.6.36/arch/x86/Kconfig
--- linux-2.6.36-orig/arch/x86/Kconfig	2010-10-20 22:30:22.000000000 +0200
+++ linux-2.6.36/arch/x86/Kconfig	2010-11-01 11:42:53.000000000 +0100
@@ -26,6 +26,7 @@ config X86
 	select HAVE_OPROFILE
 	select HAVE_PERF_EVENTS if (!M386 && !M486)
 	select HAVE_IOREMAP_PROT
+	select HAVE_SET_MEMORY_RO
 	select HAVE_KPROBES
 	select ARCH_WANT_OPTIONAL_GPIOLIB
 	select ARCH_WANT_FRAME_POINTERS
diff -Nurp linux-2.6.36-orig/fs/pramfs/Makefile linux-2.6.36/fs/pramfs/Makefile
--- linux-2.6.36-orig/fs/pramfs/Makefile	1970-01-01 01:00:00.000000000 +0100
+++ linux-2.6.36/fs/pramfs/Makefile	2010-09-14 18:49:52.000000000 +0200
@@ -0,0 +1,14 @@
+#
+# Makefile for the linux pram-filesystem routines.
+#
+
+obj-$(CONFIG_PRAMFS) += pramfs.o
+obj-$(CONFIG_PRAMFS_TEST_MODULE) += pramfs_test.o
+
+pramfs-y := balloc.o dir.o file.o inode.o namei.o super.o symlink.o
+
+pramfs-$(CONFIG_PRAMFS_WRITE_PROTECT) += wprotect.o
+pramfs-$(CONFIG_PRAMFS_XIP) += xip.o
+pramfs-$(CONFIG_PRAMFS_XATTR) += xattr.o xattr_user.o xattr_trusted.o desctree.o
+pramfs-$(CONFIG_PRAMFS_POSIX_ACL) += acl.o
+pramfs-$(CONFIG_PRAMFS_SECURITY) += xattr_security.o
 
