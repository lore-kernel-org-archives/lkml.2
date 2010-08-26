Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752627Ab0HZLsA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 07:48:00 -0400
Received: from mtagate5.uk.ibm.com ([194.196.100.165]:33516 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188Ab0HZLr6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 07:47:58 -0400
Message-Id: <20100826114757.300461956@linux.vnet.ibm.com>
References: <20100826114122.292120483@linux.vnet.ibm.com>
User-Agent: quilt/0.46-1
Date: Thu, 26 Aug 2010 13:41:24 +0200
From: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Michael Holzheu <holzheu@linux.vnet.ibm.com>, tabbott@ksplice.com,
        vda.linux@googlemail.com, mmarek@suse.cz, hpa@linux.intel.com,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        heiko.carstens@de.ibm.com, brueckner@linux.vnet.ibm.com,
        schwidefsky@de.ibm.com
In-Reply-To: <20100825180601.GA2116@merkur.ravnborg.org>
Subject: [PATCH v2 2/2] initramfs: Fix initramfs size calculation
Content-Disposition: inline; filename=irfs2.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The size of a built-in initramfs is calculated in init/initramfs.c by 
"__initramfs_end - __initramfs_start".  Those symbols are defined in the
linker script include/asm-generic/vmlinux.lds.h:

#define INIT_RAM_FS                                                     \
        . = ALIGN(PAGE_SIZE);                                           \
        VMLINUX_SYMBOL(__initramfs_start) = .;                          \
        *(.init.ramfs)                                                  \
        VMLINUX_SYMBOL(__initramfs_end) = .;

If the initramfs file has an odd number of bytes, the "__initramfs_end"
symbol points to an odd address, for example, the symbols in the System.map
might look like:

    0000000000572000 T __initramfs_start
    00000000005bcd05 T __initramfs_end	  <-- odd address

At least on s390 this causes a problem:

Certain s390 instructions, especially instructions for loading addresses
(larl) or branch addresses must be on even addresses. 
The compiler loads the symbol addresses with the "larl" instruction. This
instruction sets the last bit to 0 and, therefore, for odd size files, the
calculated size is one byte less than it should be:

    0000000000540a9c <populate_rootfs>:
      540a9c:     eb cf f0 78 00 24       stmg    %r12,%r15,120(%r15),
      540aa2:     c0 10 00 01 8a af       larl    %r1,572000 <__initramfs_start>
      540aa8:     c0 c0 00 03 e1 2e       larl    %r12,5bcd04 <initramfs_end>
                                                  (Instead of  5bcd05)
      ...
      540abe:     1b c1                   sr      %r12,%r1

To fix the problem, this patch introduces the global variable
__initramfs_size, which is calculated in the "usr/initramfs_data.S" file.
The populate_rootfs() function can then use the start marker of the
.init.ramfs section and the value of __initramfs_size for loading the
initramfs.  Because the start marker and size is sufficient, the
__initramfs_end symbol is no longer needed and is removed.

Signed-off-by: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Signed-off-by: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
---
 include/asm-generic/vmlinux.lds.h |    3 ++-
 init/initramfs.c                  |    9 ++++-----
 usr/initramfs_data.S              |   16 +++++++++++-----
 3 files changed, 17 insertions(+), 11 deletions(-)

--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -629,7 +629,8 @@
 	. = ALIGN(PAGE_SIZE);						\
 	VMLINUX_SYMBOL(__initramfs_start) = .;				\
 	*(.init.ramfs)							\
-	VMLINUX_SYMBOL(__initramfs_end) = .;
+	. = ALIGN(8);							\
+	*(.init.ramfs.info)
 #else
 #define INIT_RAM_FS
 #endif
--- a/init/initramfs.c
+++ b/init/initramfs.c
@@ -483,7 +483,8 @@ static int __init retain_initrd_param(ch
 }
 __setup("retain_initrd", retain_initrd_param);
 
-extern char __initramfs_start[], __initramfs_end[];
+extern char __initramfs_start[];
+extern unsigned long __initramfs_size;
 #include <linux/initrd.h>
 #include <linux/kexec.h>
 
@@ -570,8 +571,7 @@ static void __init clean_rootfs(void)
 
 static int __init populate_rootfs(void)
 {
-	char *err = unpack_to_rootfs(__initramfs_start,
-			 __initramfs_end - __initramfs_start);
+	char *err = unpack_to_rootfs(__initramfs_start, __initramfs_size);
 	if (err)
 		panic(err);	/* Failed to decompress INTERNAL initramfs */
 	if (initrd_start) {
@@ -585,8 +585,7 @@ static int __init populate_rootfs(void)
 			return 0;
 		} else {
 			clean_rootfs();
-			unpack_to_rootfs(__initramfs_start,
-				 __initramfs_end - __initramfs_start);
+			unpack_to_rootfs(__initramfs_start, __initramfs_size);
 		}
 		printk(KERN_INFO "rootfs image is not initramfs (%s)"
 				"; looks like an initrd\n", err);
--- a/usr/initramfs_data.S
+++ b/usr/initramfs_data.S
@@ -11,11 +11,7 @@
   -T initramfs_data.scr initramfs_data.cpio.gz -o initramfs_data.o
    ld -m elf_i386  -r -o built-in.o initramfs_data.o
 
-  initramfs_data.scr looks like this:
-SECTIONS
-{
-       .init.ramfs : { *(.data) }
-}
+  For including the .init.ramfs sections, see include/asm-generic/vmlinux.lds.
 
   The above example is for i386 - the parameters vary from architectures.
   Eventually look up LDFLAGS_BLOB in an older version of the
@@ -28,4 +24,14 @@ SECTIONS
 #include <linux/stringify.h>
 
 .section .init.ramfs,"a"
+__irf_start:
 .incbin __stringify(INITRAMFS_IMAGE)
+__irf_end:
+.section .init.ramfs.info,"a"
+.globl __initramfs_size
+__initramfs_size:
+#ifdef CONFIG_32BIT
+	.long __irf_end - __irf_start
+#else
+	.quad __irf_end - __irf_start
+#endif

-- 
