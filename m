Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752138Ab2CUEaj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 00:30:39 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:54602 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751067Ab2CUEah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 00:30:37 -0400
MIME-Version: 1.0
Date: Wed, 21 Mar 2012 12:30:36 +0800
Message-ID: <CAN628AFKSgd2nKY5Ga7JqhVWqAySRW8OpeLyykOwocn4K_a-qQ@mail.gmail.com>
Subject: [PATCH] VMUFAT filesystem [1/4]
From: Adrian McMenamin <lkmladrian@gmail.com>
To: viro@zeniv.linux.org.uk, LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org
Cc: Linux-sh <linux-sh@vger.kernel.org>,
        Adrian McMenamin <adrianmcmenamin@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From d587b09573c06309bb2c3ef12223b77fffc3a922 Mon Sep 17 00:00:00 2001
From: Adrian McMenamin <adrianmcmenamin@gmail.com>
Date: Wed, 21 Mar 2012 12:17:51 +0800
Subject: [PATCH] Add vmufat filesystem

---
 Documentation/filesystems/vmufat.txt |   83 +++
 fs/Kconfig                           |    1 +
 fs/Makefile                          |    1 +
 fs/vmufat/Kconfig                    |   14 +
 fs/vmufat/Makefile                   |    7 +
 fs/vmufat/inode.c                    |  951 ++++++++++++++++++++++++++++++++++
 fs/vmufat/super.c                    |  559 ++++++++++++++++++++
 fs/vmufat/vmufat.h                   |  115 ++++
 include/linux/magic.h                |    1 +
 9 files changed, 1732 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/filesystems/vmufat.txt
 create mode 100644 fs/vmufat/Kconfig
 create mode 100644 fs/vmufat/Makefile
 create mode 100644 fs/vmufat/inode.c
 create mode 100644 fs/vmufat/super.c
 create mode 100644 fs/vmufat/vmufat.h


Signed-off-by: Adrian McMenamin <adrianmcmenamin@gmail.com>

diff --git a/Documentation/filesystems/vmufat.txt
b/Documentation/filesystems/vmufat.txt
new file mode 100644
index 0000000..f700593
--- /dev/null
+++ b/Documentation/filesystems/vmufat.txt
@@ -0,0 +1,83 @@
+VMUFAT FILESYSTEM
+
+VMUFAT is the simple file allocation table (FAT) based filesystem used in Sega
+Dreamcast Visual Memory Units (VMUs) and various Dreamcast emulators and
+Android apps etc.
+
+It is not recommended for general use, but does not require a Dreamcast.
+
+All the physical VMU devices that were made were of the same size 256 blocks
+of 512 octets - 128KB in total. But the specification supports a wider range
+of sizes and the filesystem in the Linux kernel is capable of handling volumes
+of a size between 4 blocks and 65536 blocks.
+
+The standard 256 block VMU is described below:
+
+BLOCK NO	CONTENT
+0		Space used by Dreamcast
+		to save files
+199
+200		Space which can be used but
+		which the Dreamcast ignores
+240
+241		Directory (can hold 208
+		file records)
+253
+254		File Allocation Table (FAT)
+255		Root Block
+
+The standard VMU filesystem has 241 blocks which can be used for file storage
+but a Dreamcast will only use 200 of these. The Linux kernel driver prefers to
+use blocks 0 - 199 when allocating blocks to files, but will use blocks 200 -
+240 if lower numbered blocks are not available.
+
+An executible file (generally a game written in the native machine code of
+the VMU's microcontroller) must begin at block 0 and be stored linearly in
+the volume.
+
+DIRECTORY
+The directory contains records 32 octets long (format detail below from Marcus
+Comstedt's website - http://mc.pp.se/dc/vms/flashmem.html)
+0x00      : file type (0x00 = no file, 0x33 = data, 0xcc = game)
+0x01      : copy protect (0x00 = copy ok, 0xff = copy protected)
+0x02-0x03 : 16 bits (little endian) : location of first block
+0x04-0x0f : ASCII string : filename (12 characters)
+0x10-0x17 : Binary Coded Decimal timestamp: file creation time
+0x18-0x19 : 16 bits (little endian) : file size (in blocks)
+0x1a-0x1b : 16 bits (little endian) : offset of header (in blocks)
+	    from file start
+
+Header positioning is a matter for executible files written in native
+code for a physical VMU (an 8 bit Sanyo microcontroller).
+
+BCD dates are encoded as follows:
+Century prefix (eg., 20)
+Year (eg., 12)
+Month (eg., 02)
+Day in month (eg., 29)
+Hour (eg., 20)
+Minute (eg., 49)
+Second (eg., 22)
+Day of week (Monday is 00, Sunday is 06)
+
+FILE ALLOCATION TABLE
+Every block in the volume is mapped to the FAT eg., block 0 of the VMU maps to
+the first 16 bits of the FAT and so on. Blocks marked 0xFFFC are empty, blocks
+allocated to a file are either numbered with with next block or, if the final
+block are marked 0xFFFA.
+
+ROOT BLOCK
+The first 16 octets are marked as 0x55 - we use this to provide the "magic
+number" for this filesystem. The octets at 0x10 - 0x14 are used to determine
+the colour the representation of VMU is displayed in by a Dreamcast and our
+filesystem does not touch these.
+Octets 0x30 - 0x37 contain the BCD timestamp of the VMU.
+Octets 0x46 - 0x47 contain the location (little endian format) of the FAT
+Octets 0x48 - 0x49 contain the size (little endian) of the FAT
+Octets 0x4A - 0x4B contain the location (little endian) of the Directory
+Octets 0x4C - 0x4D contain the size (little endian) of the Directory
+Octets 0x4E - 0x4F is Dreamcast specific (icon shape)
+Octets 0x50 - 0x51 contain the number (little endian) of user blocks - NB this
+is marked as 200 in a physical VMU although there are in fact 241 usable
+blocks - the reason appears to be that the Directory is not big enough to
+support 1 block files in all user blocks.
diff --git a/fs/Kconfig b/fs/Kconfig
index d621f02..0caea6d 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -215,6 +215,7 @@ source "fs/pstore/Kconfig"
 source "fs/sysv/Kconfig"
 source "fs/ufs/Kconfig"
 source "fs/exofs/Kconfig"
+source "fs/vmufat/Kconfig"

 endif # MISC_FILESYSTEMS

diff --git a/fs/Makefile b/fs/Makefile
index 93804d4..777bc2a 100644
--- a/fs/Makefile
+++ b/fs/Makefile
@@ -124,3 +124,4 @@ obj-$(CONFIG_GFS2_FS)           += gfs2/
 obj-y				+= exofs/ # Multiple modules
 obj-$(CONFIG_CEPH_FS)		+= ceph/
 obj-$(CONFIG_PSTORE)		+= pstore/
+obj-$(CONFIG_VMUFAT_FS)		+= vmufat/
diff --git a/fs/vmufat/Kconfig b/fs/vmufat/Kconfig
new file mode 100644
index 0000000..bdad4c6
--- /dev/null
+++ b/fs/vmufat/Kconfig
@@ -0,0 +1,14 @@
+config VMUFAT_FS
+	tristate "Dreamcast VMU FAT filesystem"
+	depends on BLOCK
+	help
+	  This implements the simple FAT type filesystem found on SEGA
+	  Dreamcast visual memory units.
+
+	  Dreamcast users who want to mount their VMUs to view the native
+	  filesystem will say 'Y' here. The filesystem is hardware independent
+	  but is not recommended for any serious use in other circumstances, so
+	  just about everyone else should say 'N'.
+
+	  To compile this as a module say 'M' here. The module will be called
+	  vmufat
diff --git a/fs/vmufat/Makefile b/fs/vmufat/Makefile
new file mode 100644
index 0000000..da423b0
--- /dev/null
+++ b/fs/vmufat/Makefile
@@ -0,0 +1,7 @@
+#
+# Makefile for VMUFAT filesystem
+#
+
+obj-$(CONFIG_VMUFAT_FS) += vmufat.o
+
+vmufat-y := inode.o super.o
