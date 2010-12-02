Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758054Ab0LBTPB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 14:15:01 -0500
Received: from mailfw02.zoner.fi ([84.34.147.249]:65049 "EHLO
	mailfw02.zoner.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758038Ab0LBTO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 14:14:59 -0500
To: linux-kernel@vger.kernel.org
Subject: [PATCH v2 RFC 3/3] x86: Support XZ-compressed kernel
Cc: linux-embedded@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Alain Knaff <alain@knaff.lu>,
        Albin Tonnerre <albin.tonnerre@free-electrons.com>,
        Phillip Lougher <phillip@lougher.demon.co.uk>,
        Andrew Morton <akpm@linux-foundation.org>
From: Lasse Collin <lasse.collin@tukaani.org>
Date: Thu, 2 Dec 2010 21:14:57 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012022114.57173.lasse.collin@tukaani.org>
X-Antivirus-Scanner: Clean mail though you should still use an Antivirus
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lasse Collin <lasse.collin@tukaani.org>

This integrates the XZ decompression code to the x86
pre-boot code.

mkpiggy.c is updated to reserve about 32 KiB more buffer safety
margin for kernel decompression. It is done unconditionally for
all decompressors to keep the code simpler.

The XZ decompressor needs around 30 KiB of heap, so the heap size
is increased to 32 KiB on both x86-32 and x86-64.

Documentation/x86/boot.txt is updated to list the XZ magic number.

With the x86 BCJ filter in XZ, XZ-compressed x86 kernel tends to be
a few percent smaller than the equivalent LZMA-compressed kernel.

Signed-off-by: Lasse Collin <lasse.collin@tukaani.org>
---

Even though the buffer safety margin has been increased,
the comments in misc.c about the safety margin calculation
were not touched. This is because the misc.c comments describe
the calculation of the margin for the .gz format.

This is only a re-diff and has no changes compared to the first
version; this is sent only for completeness.

 Documentation/x86/boot.txt         |    6 +++---
 arch/x86/Kconfig                   |    1 +
 arch/x86/boot/compressed/Makefile  |    5 ++++-
 arch/x86/boot/compressed/misc.c    |    4 ++++
 arch/x86/boot/compressed/mkpiggy.c |    2 +-
 arch/x86/include/asm/boot.h        |    6 +-----
 6 files changed, 14 insertions(+), 10 deletions(-)

diff -uprN linux-2.6.37-rc4.orig/Documentation/x86/boot.txt linux-2.6.37-rc4/Documentation/x86/boot.txt
--- linux-2.6.37-rc4.orig/Documentation/x86/boot.txt	2010-10-20 23:30:22.000000000 +0300
+++ linux-2.6.37-rc4/Documentation/x86/boot.txt	2010-11-18 19:58:57.000000000 +0200
@@ -621,9 +621,9 @@ Protocol:	2.08+
   The payload may be compressed. The format of both the compressed and
   uncompressed data should be determined using the standard magic
   numbers.  The currently supported compression formats are gzip
-  (magic numbers 1F 8B or 1F 9E), bzip2 (magic number 42 5A) and LZMA
-  (magic number 5D 00).  The uncompressed payload is currently always ELF
-  (magic number 7F 45 4C 46).
+  (magic numbers 1F 8B or 1F 9E), bzip2 (magic number 42 5A), LZMA
+  (magic number 5D 00), and XZ (magic number FD 37).  The uncompressed
+  payload is currently always ELF (magic number 7F 45 4C 46).
   
 Field name:	payload_length
 Type:		read
diff -uprN linux-2.6.37-rc4.orig/arch/x86/Kconfig linux-2.6.37-rc4/arch/x86/Kconfig
--- linux-2.6.37-rc4.orig/arch/x86/Kconfig	2010-11-30 19:49:44.000000000 +0200
+++ linux-2.6.37-rc4/arch/x86/Kconfig	2010-12-02 17:40:52.000000000 +0200
@@ -51,6 +51,7 @@ config X86
 	select HAVE_KERNEL_GZIP
 	select HAVE_KERNEL_BZIP2
 	select HAVE_KERNEL_LZMA
+	select HAVE_KERNEL_XZ
 	select HAVE_KERNEL_LZO
 	select HAVE_HW_BREAKPOINT
 	select HAVE_MIXED_BREAKPOINTS_REGS
diff -uprN linux-2.6.37-rc4.orig/arch/x86/boot/compressed/Makefile linux-2.6.37-rc4/arch/x86/boot/compressed/Makefile
--- linux-2.6.37-rc4.orig/arch/x86/boot/compressed/Makefile	2010-10-20 23:30:22.000000000 +0300
+++ linux-2.6.37-rc4/arch/x86/boot/compressed/Makefile	2010-11-16 20:36:23.000000000 +0200
@@ -4,7 +4,7 @@
 # create a compressed vmlinux image from the original vmlinux
 #
 
-targets := vmlinux.lds vmlinux vmlinux.bin vmlinux.bin.gz vmlinux.bin.bz2 vmlinux.bin.lzma vmlinux.bin.lzo 
head_$(BITS).o misc.o string.o cmdline.o early_serial_console.o piggy.o
+targets := vmlinux.lds vmlinux vmlinux.bin vmlinux.bin.gz vmlinux.bin.bz2 vmlinux.bin.lzma vmlinux.bin.xz 
vmlinux.bin.lzo head_$(BITS).o misc.o string.o cmdline.o early_serial_console.o piggy.o
 
 KBUILD_CFLAGS := -m$(BITS) -D__KERNEL__ $(LINUX_INCLUDE) -O2
 KBUILD_CFLAGS += -fno-strict-aliasing -fPIC
@@ -49,12 +49,15 @@ $(obj)/vmlinux.bin.bz2: $(vmlinux.bin.al
 	$(call if_changed,bzip2)
 $(obj)/vmlinux.bin.lzma: $(vmlinux.bin.all-y) FORCE
 	$(call if_changed,lzma)
+$(obj)/vmlinux.bin.xz: $(vmlinux.bin.all-y) FORCE
+	$(call if_changed,xzkern)
 $(obj)/vmlinux.bin.lzo: $(vmlinux.bin.all-y) FORCE
 	$(call if_changed,lzo)
 
 suffix-$(CONFIG_KERNEL_GZIP)	:= gz
 suffix-$(CONFIG_KERNEL_BZIP2)	:= bz2
 suffix-$(CONFIG_KERNEL_LZMA)	:= lzma
+suffix-$(CONFIG_KERNEL_XZ)	:= xz
 suffix-$(CONFIG_KERNEL_LZO) 	:= lzo
 
 quiet_cmd_mkpiggy = MKPIGGY $@
diff -uprN linux-2.6.37-rc4.orig/arch/x86/boot/compressed/misc.c linux-2.6.37-rc4/arch/x86/boot/compressed/misc.c
--- linux-2.6.37-rc4.orig/arch/x86/boot/compressed/misc.c	2010-11-30 19:49:44.000000000 +0200
+++ linux-2.6.37-rc4/arch/x86/boot/compressed/misc.c	2010-12-02 17:40:52.000000000 +0200
@@ -139,6 +139,10 @@ static int lines, cols;
 #include "../../../../lib/decompress_unlzma.c"
 #endif
 
+#ifdef CONFIG_KERNEL_XZ
+#include "../../../../lib/decompress_unxz.c"
+#endif
+
 #ifdef CONFIG_KERNEL_LZO
 #include "../../../../lib/decompress_unlzo.c"
 #endif
diff -uprN linux-2.6.37-rc4.orig/arch/x86/boot/compressed/mkpiggy.c linux-2.6.37-rc4/arch/x86/boot/compressed/mkpiggy.c
--- linux-2.6.37-rc4.orig/arch/x86/boot/compressed/mkpiggy.c	2010-10-20 23:30:22.000000000 +0300
+++ linux-2.6.37-rc4/arch/x86/boot/compressed/mkpiggy.c	2010-11-16 20:37:57.000000000 +0200
@@ -74,7 +74,7 @@ int main(int argc, char *argv[])
 
 	offs = (olen > ilen) ? olen - ilen : 0;
 	offs += olen >> 12;	/* Add 8 bytes for each 32K block */
-	offs += 32*1024 + 18;	/* Add 32K + 18 bytes slack */
+	offs += 64*1024 + 128;	/* Add 64K + 128 bytes slack */
 	offs = (offs+4095) & ~4095; /* Round to a 4K boundary */
 
 	printf(".section \".rodata..compressed\",\"a\",@progbits\n");
diff -uprN linux-2.6.37-rc4.orig/arch/x86/include/asm/boot.h linux-2.6.37-rc4/arch/x86/include/asm/boot.h
--- linux-2.6.37-rc4.orig/arch/x86/include/asm/boot.h	2010-10-20 23:30:22.000000000 +0300
+++ linux-2.6.37-rc4/arch/x86/include/asm/boot.h	2010-11-16 20:39:57.000000000 +0200
@@ -32,11 +32,7 @@
 #define BOOT_HEAP_SIZE             0x400000
 #else /* !CONFIG_KERNEL_BZIP2 */
 
-#ifdef CONFIG_X86_64
-#define BOOT_HEAP_SIZE	0x7000
-#else
-#define BOOT_HEAP_SIZE	0x4000
-#endif
+#define BOOT_HEAP_SIZE	0x8000
 
 #endif /* !CONFIG_KERNEL_BZIP2 */
 
