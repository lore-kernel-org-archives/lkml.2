Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754052Ab0DSTM6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 15:12:58 -0400
Received: from mail.free-electrons.com ([88.191.76.200]:58526 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752425Ab0DSTM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 15:12:56 -0400
From: Albin Tonnerre <albin.tonnerre@free-electrons.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, hpa@zytor.com,
       Albin Tonnerre <albin.tonnerre@free-electrons.com>
Subject: [PATCH 2/2] Add support for in-kernel initramfs compressed with LZO
Date: Mon, 19 Apr 2010 21:03:53 +0200
Message-Id: <1271703833-20058-3-git-send-email-albin.tonnerre@free-electrons.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1271703833-20058-1-git-send-email-albin.tonnerre@free-electrons.com>
References: <1271703833-20058-1-git-send-email-albin.tonnerre@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the necessary parts to be enable the use of
LZO-compressed initramfs build into the kernel.

Signed-off-by: Albin Tonnerre <albin.tonnerre@free-electrons.com>
---
 scripts/gen_initramfs_list.sh |    1 +
 usr/Makefile                  |    5 ++++-
 usr/initramfs_data.lzo.S      |   29 +++++++++++++++++++++++++++++
 3 files changed, 34 insertions(+), 1 deletions(-)
 create mode 100644 usr/initramfs_data.lzo.S

diff --git a/scripts/gen_initramfs_list.sh b/scripts/gen_initramfs_list.sh
index 76af5f9..a932ae5 100644
--- a/scripts/gen_initramfs_list.sh
+++ b/scripts/gen_initramfs_list.sh
@@ -242,6 +242,7 @@ case "$arg" in
 		echo "$output_file" | grep -q "\.gz$" && compr="gzip -9 -f"
 		echo "$output_file" | grep -q "\.bz2$" && compr="bzip2 -9 -f"
 		echo "$output_file" | grep -q "\.lzma$" && compr="lzma -9 -f"
+		echo "$output_file" | grep -q "\.lzo$" && compr="lzop -9 -f"
 		echo "$output_file" | grep -q "\.cpio$" && compr="cat"
 		shift
 		;;
diff --git a/usr/Makefile b/usr/Makefile
index 1e6a9e4..6b4b6da 100644
--- a/usr/Makefile
+++ b/usr/Makefile
@@ -15,6 +15,9 @@ suffix_$(CONFIG_INITRAMFS_COMPRESSION_BZIP2)  = .bz2
 # Lzma
 suffix_$(CONFIG_INITRAMFS_COMPRESSION_LZMA)   = .lzma
 
+# Lzo
+suffix_$(CONFIG_INITRAMFS_COMPRESSION_LZO)   = .lzo
+
 # Generate builtin.o based on initramfs_data.o
 obj-$(CONFIG_BLK_DEV_INITRD) := initramfs_data$(suffix_y).o
 
@@ -45,7 +48,7 @@ endif
 quiet_cmd_initfs = GEN     $@
       cmd_initfs = $(initramfs) -o $@ $(ramfs-args) $(ramfs-input)
 
-targets := initramfs_data.cpio.gz initramfs_data.cpio.bz2 initramfs_data.cpio.lzma initramfs_data.cpio
+targets := initramfs_data.cpio.gz initramfs_data.cpio.bz2 initramfs_data.cpio.lzma initramfs_data.cpio.lzo initramfs_data.cpio
 # do not try to update files included in initramfs
 $(deps_initramfs): ;
 
diff --git a/usr/initramfs_data.lzo.S b/usr/initramfs_data.lzo.S
new file mode 100644
index 0000000..5921190
--- /dev/null
+++ b/usr/initramfs_data.lzo.S
@@ -0,0 +1,29 @@
+/*
+  initramfs_data includes the compressed binary that is the
+  filesystem used for early user space.
+  Note: Older versions of "as" (prior to binutils 2.11.90.0.23
+  released on 2001-07-14) dit not support .incbin.
+  If you are forced to use older binutils than that then the
+  following trick can be applied to create the resulting binary:
+
+
+  ld -m elf_i386  --format binary --oformat elf32-i386 -r \
+  -T initramfs_data.scr initramfs_data.cpio.gz -o initramfs_data.o
+   ld -m elf_i386  -r -o built-in.o initramfs_data.o
+
+  initramfs_data.scr looks like this:
+SECTIONS
+{
+       .init.ramfs : { *(.data) }
+}
+
+  The above example is for i386 - the parameters vary from architectures.
+  Eventually look up LDFLAGS_BLOB in an older version of the
+  arch/$(ARCH)/Makefile to see the flags used before .incbin was introduced.
+
+  Using .incbin has the advantage over ld that the correct flags are set
+  in the ELF header, as required by certain architectures.
+*/
+
+.section .init.ramfs,"a"
+.incbin "usr/initramfs_data.cpio.lzo"
-- 
1.7.0.4

