Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757587Ab1ANDIa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 22:08:30 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:36959 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757884Ab1ANDH5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 22:07:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=v8zZjxq1XrXSBpuT7rQS/RILWvX1AiRhc3RgX3sAoSzcHqhGdIN285JIRwsxfXqdgT
         1HCZGBKYiXOic+qfEWLR16QXaxwjhOQJaAkovYQ/fKDxRmXoMuxUtej0AJuimZitDupA
         2V86DgYnJydJaRvQRKdk4YWHwlFePqZeizu6M=
From: Charles Manning <cdhmanning@gmail.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        akpm@linux-foundation.org
Cc: Charles Manning <cdhmanning@gmail.com>
Subject: [PATCH 10/10] Add yaffs2 file system: Hook in to Linux tree
Date: Fri, 14 Jan 2011 16:06:09 +1300
Message-Id: <1294974369-31647-11-git-send-email-cdhmanning@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1294974369-31647-1-git-send-email-cdhmanning@gmail.com>
References: <1294974369-31647-1-git-send-email-cdhmanning@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change existing Makefile, Kconfig and MAINTAINERS.
Add yaffs2 specific Makefile and Kconfig

Signed-off-by: Charles Manning <cdhmanning@gmail.com>
---
 MAINTAINERS        |    7 ++
 fs/Kconfig         |    1 +
 fs/Makefile        |    1 +
 fs/yaffs2/Kconfig  |  161 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/yaffs2/Makefile |   17 ++++++
 5 files changed, 187 insertions(+), 0 deletions(-)
 create mode 100644 fs/yaffs2/Kconfig
 create mode 100644 fs/yaffs2/Makefile

diff --git a/MAINTAINERS b/MAINTAINERS
index 64d7621..4cc7215 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6838,6 +6838,13 @@ L:	linux-serial@vger.kernel.org
 S:	Maintained
 F:	drivers/serial/uartlite.c
 
+YAFFS2 FLASH FILE SYSTEM
+M:	Charles Manning <cdhmanning@gmail.com>
+W:	http://www.yaffs.net/
+L:	yaffs@lists.aleph1.co.uk
+S:	Maintained
+F:	fs/yaffs2
+
 YAM DRIVER FOR AX.25
 M:	Jean-Paul Roubelat <jpr@f6fbb.org>
 L:	linux-hams@vger.kernel.org
diff --git a/fs/Kconfig b/fs/Kconfig
index 771f457..069abb1 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -176,6 +176,7 @@ source "fs/hfsplus/Kconfig"
 source "fs/befs/Kconfig"
 source "fs/bfs/Kconfig"
 source "fs/efs/Kconfig"
+source "fs/yaffs2/Kconfig"
 source "fs/jffs2/Kconfig"
 # UBIFS File system configuration
 source "fs/ubifs/Kconfig"
diff --git a/fs/Makefile b/fs/Makefile
index a7f7cef..e370ea5 100644
--- a/fs/Makefile
+++ b/fs/Makefile
@@ -121,3 +121,4 @@ obj-$(CONFIG_BTRFS_FS)		+= btrfs/
 obj-$(CONFIG_GFS2_FS)           += gfs2/
 obj-$(CONFIG_EXOFS_FS)          += exofs/
 obj-$(CONFIG_CEPH_FS)		+= ceph/
+obj-$(CONFIG_YAFFS_FS)		+= yaffs2/
diff --git a/fs/yaffs2/Kconfig b/fs/yaffs2/Kconfig
new file mode 100644
index 0000000..6354140
--- /dev/null
+++ b/fs/yaffs2/Kconfig
@@ -0,0 +1,161 @@
+#
+# YAFFS file system configurations
+#
+
+config YAFFS_FS
+	tristate "YAFFS2 file system support"
+	default n
+	depends on MTD_BLOCK
+	select YAFFS_YAFFS1
+	select YAFFS_YAFFS2
+	help
+	  YAFFS2, or Yet Another Flash Filing System, is a filing system
+	  optimised for NAND Flash chips.
+
+	  To compile the YAFFS2 file system support as a module, choose M
+	  here: the module will be called yaffs2.
+
+	  If unsure, say N.
+
+	  Further information on YAFFS2 is available at
+	  <http://www.aleph1.co.uk/yaffs/>.
+
+config YAFFS_YAFFS1
+	bool "512 byte / page devices"
+	depends on YAFFS_FS
+	default y
+	help
+	  Enable YAFFS1 support -- yaffs for 512 byte / page devices
+
+	  Not needed for 2K-page devices.
+
+	  If unsure, say Y.
+
+config YAFFS_9BYTE_TAGS
+	bool "Use older-style on-NAND data format with pageStatus byte"
+	depends on YAFFS_YAFFS1
+	default n
+	help
+
+	  Older-style on-NAND data format has a "pageStatus" byte to record
+	  chunk/page state.  This byte is zero when the page is discarded.
+	  Choose this option if you have existing on-NAND data using this
+	  format that you need to continue to support.  New data written
+	  also uses the older-style format.  Note: Use of this option
+	  generally requires that MTD's oob layout be adjusted to use the
+	  older-style format.  See notes on tags formats and MTD versions
+	  in yaffs_mtdif1.c.
+
+	  If unsure, say N.
+
+config YAFFS_DOES_ECC
+	bool "Lets Yaffs do its own ECC"
+	depends on YAFFS_FS && YAFFS_YAFFS1 && !YAFFS_9BYTE_TAGS
+	default n
+	help
+	  This enables Yaffs to use its own ECC functions instead of using
+	  the ones from the generic MTD-NAND driver.
+
+	  If unsure, say N.
+
+config YAFFS_ECC_WRONG_ORDER
+	bool "Use the same ecc byte order as Steven Hill's nand_ecc.c"
+	depends on YAFFS_FS && YAFFS_DOES_ECC && !YAFFS_9BYTE_TAGS
+	default n
+	help
+	  This makes yaffs_ecc.c use the same ecc byte order as Steven
+	  Hill's nand_ecc.c. If not set, then you get the same ecc byte
+	  order as SmartMedia.
+
+	  If unsure, say N.
+
+config YAFFS_YAFFS2
+	bool "2048 byte (or larger) / page devices"
+	depends on YAFFS_FS
+	default y
+	help
+	  Enable YAFFS2 support -- yaffs for >= 2K bytes per page devices
+
+	  If unsure, say Y.
+
+config YAFFS_AUTO_YAFFS2
+	bool "Autoselect yaffs2 format"
+	depends on YAFFS_YAFFS2
+	default y
+	help
+	  Without this, you need to explicitely use yaffs2 as the file
+	  system type. With this, you can say "yaffs" and yaffs or yaffs2
+	  will be used depending on the device page size (yaffs on
+	  512-byte page devices, yaffs2 on 2K page devices).
+
+	  If unsure, say Y.
+
+config YAFFS_DISABLE_TAGS_ECC
+	bool "Disable YAFFS from doing ECC on tags by default"
+	depends on YAFFS_FS && YAFFS_YAFFS2
+	default n
+	help
+	  This defaults Yaffs to using its own ECC calculations on tags instead of
+	  just relying on the MTD.
+	  This behavior can also be overridden with tags_ecc_on and
+	  tags_ecc_off mount options.
+
+	  If unsure, say N.
+
+config YAFFS_ALWAYS_CHECK_CHUNK_ERASED
+	bool "Force chunk erase check"
+	depends on YAFFS_FS
+	default n
+	help
+          Normally YAFFS only checks chunks before writing until an erased
+	  chunk is found. This helps to detect any partially written
+	  chunks that might have happened due to power loss.
+
+	  Enabling this forces on the test that chunks are erased in flash
+	  before writing to them. This takes more time but is potentially
+	  a bit more secure.
+
+	  Suggest setting Y during development and ironing out driver
+	  issues etc. Suggest setting to N if you want faster writing.
+
+	  If unsure, say Y.
+
+config YAFFS_EMPTY_LOST_AND_FOUND
+	bool "Empty lost and found on boot"
+	depends on YAFFS_FS
+	default n
+	help
+	  If this is enabled then the contents of lost and found is
+	  automatically dumped at mount.
+
+	  If unsure, say N.
+
+config YAFFS_DISABLE_BLOCK_REFRESHING
+	bool "Disable yaffs2 block refreshing"
+	depends on YAFFS_FS
+	default n
+	help
+	 If this is set, then block refreshing is disabled.
+	 Block refreshing infrequently refreshes the oldest block in
+	 a yaffs2 file system. This mechanism helps to refresh flash to
+	 mitigate against data loss. This is particularly useful for MLC.
+
+	  If unsure, say N.
+
+config YAFFS_DISABLE_BACKGROUND
+	bool "Disable yaffs2 background processing"
+	depends on YAFFS_FS
+	default n
+	help
+	 If this is set, then background processing is disabled.
+	 Background processing makes many foreground activities faster.
+
+	 If unsure, say N.
+
+config YAFFS_XATTR
+	bool "Enable yaffs2 xattr support"
+	depends on YAFFS_FS
+	default y
+	help
+	 If this is set then yaffs2 will provide xattr support.
+	 If unsure, say Y.
diff --git a/fs/yaffs2/Makefile b/fs/yaffs2/Makefile
new file mode 100644
index 0000000..e63a28a
--- /dev/null
+++ b/fs/yaffs2/Makefile
@@ -0,0 +1,17 @@
+#
+# Makefile for the linux YAFFS filesystem routines.
+#
+
+obj-$(CONFIG_YAFFS_FS) += yaffs.o
+
+yaffs-y := yaffs_ecc.o yaffs_vfs.o yaffs_guts.o yaffs_checkptrw.o
+yaffs-y += yaffs_packedtags1.o yaffs_packedtags2.o yaffs_nand.o
+yaffs-y += yaffs_tagscompat.o yaffs_tagsvalidity.o
+yaffs-y += yaffs_mtdif.o yaffs_mtdif1.o yaffs_mtdif2.o
+yaffs-y += yaffs_nameval.o yaffs_attribs.o
+yaffs-y += yaffs_allocator.o
+yaffs-y += yaffs_yaffs1.o
+yaffs-y += yaffs_yaffs2.o
+yaffs-y += yaffs_bitmap.o
+yaffs-y += yaffs_verify.o
+
-- 
1.7.1

