Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753404Ab0HYP5Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 11:57:24 -0400
Received: from mtagate6.uk.ibm.com ([194.196.100.166]:36401 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752559Ab0HYP5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 11:57:20 -0400
Subject: [PATCH] Fix initramfs size calculation
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Reply-To: holzheu@linux.vnet.ibm.com
To: sam@ravnborg.org, tabbott@ksplice.com, vda.linux@googlemail.com,
        mmarek@suse.cz, hpa@linux.intel.com, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, heiko.carstens@de.ibm.com,
        brueckner@linux.vnet.ibm.com, schwidefsky@de.ibm.com
Content-Type: text/plain; charset="us-ascii"
Organization: IBM
Date: Wed, 25 Aug 2010 17:57:12 +0200
Message-ID: <1282751832.3676.17.camel@holzheu-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
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

At least on s390 this is a problem:

Certain s390 instructions, especially instructions for loading addresses
(larl) or branch addresses must be on even addresses. 
The compiler loads the symbol addresses with the "larl". This instruction sets the
last bit to 0, therefore, for odd size files, the calculated size is one byte
less than it should be:

    0000000000540a9c <populate_rootfs>:
      540a9c:     eb cf f0 78 00 24       stmg    %r12,%r15,120(%r15),
      540aa2:     c0 10 00 01 8a af       larl    %r1,572000 <__initramfs_start>
      540aa8:     c0 c0 00 03 e1 2e       larl    %r12,5bcd04 <initramfs_end>
                                                  (Instead of  5bcd05)
      ...
      540abe:     1b c1                   sr      %r12,%r1

To fix the problem, this patch introduces the global variable
__initramfs_size, which is calculated in the "usr/initramfs_data.xxx.S" files.
The populate_rootfs() function can then use the init.ramfs section start and
the value of __initramfs_size for loading the initramfs.

The patch also restructures the "usr/initramfs_data.xxx.S" files to use a
common macro that includes the (compressed) initramfs file and calculates
the __initramfs_size.

Signed-off-by: Michael Holzheu <holzheu@linux.vnet.ibm.com>
---
 include/asm-generic/vmlinux.lds.h |    3 +-
 init/initramfs.c                  |    9 +++-----
 usr/initramfs_data.S              |   32 +---------------------------
 usr/initramfs_data.bz2.S          |   31 +---------------------------
 usr/initramfs_data.gz.S           |   31 +---------------------------
 usr/initramfs_data.h              |   42 ++++++++++++++++++++++++++++++++++++++
 usr/initramfs_data.lzma.S         |   31 +---------------------------
 7 files changed, 56 insertions(+), 123 deletions(-)

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
@@ -1,30 +1,2 @@
-/*
-  initramfs_data includes the compressed binary that is the
-  filesystem used for early user space.
-  Note: Older versions of "as" (prior to binutils 2.11.90.0.23
-  released on 2001-07-14) dit not support .incbin.
-  If you are forced to use older binutils than that then the
-  following trick can be applied to create the resulting binary:
-
-
-  ld -m elf_i386  --format binary --oformat elf32-i386 -r \
-  -T initramfs_data.scr initramfs_data.cpio.gz -o initramfs_data.o
-   ld -m elf_i386  -r -o built-in.o initramfs_data.o
-
-  initramfs_data.scr looks like this:
-SECTIONS
-{
-       .init.ramfs : { *(.data) }
-}
-
-  The above example is for i386 - the parameters vary from architectures.
-  Eventually look up LDFLAGS_BLOB in an older version of the
-  arch/$(ARCH)/Makefile to see the flags used before .incbin was introduced.
-
-  Using .incbin has the advantage over ld that the correct flags are set
-  in the ELF header, as required by certain architectures.
-*/
-
-.section .init.ramfs,"a"
-.incbin "usr/initramfs_data.cpio"
-
+#include "initramfs_data.h"
+initramfs_inc "usr/initramfs_data.cpio";
--- a/usr/initramfs_data.bz2.S
+++ b/usr/initramfs_data.bz2.S
@@ -1,29 +1,2 @@
-/*
-  initramfs_data includes the compressed binary that is the
-  filesystem used for early user space.
-  Note: Older versions of "as" (prior to binutils 2.11.90.0.23
-  released on 2001-07-14) dit not support .incbin.
-  If you are forced to use older binutils than that then the
-  following trick can be applied to create the resulting binary:
-
-
-  ld -m elf_i386  --format binary --oformat elf32-i386 -r \
-  -T initramfs_data.scr initramfs_data.cpio.gz -o initramfs_data.o
-   ld -m elf_i386  -r -o built-in.o initramfs_data.o
-
-  initramfs_data.scr looks like this:
-SECTIONS
-{
-       .init.ramfs : { *(.data) }
-}
-
-  The above example is for i386 - the parameters vary from architectures.
-  Eventually look up LDFLAGS_BLOB in an older version of the
-  arch/$(ARCH)/Makefile to see the flags used before .incbin was introduced.
-
-  Using .incbin has the advantage over ld that the correct flags are set
-  in the ELF header, as required by certain architectures.
-*/
-
-.section .init.ramfs,"a"
-.incbin "usr/initramfs_data.cpio.bz2"
+#include "initramfs_data.h"
+initramfs_inc "usr/initramfs_data.cpio.bz2";
--- a/usr/initramfs_data.gz.S
+++ b/usr/initramfs_data.gz.S
@@ -1,29 +1,2 @@
-/*
-  initramfs_data includes the compressed binary that is the
-  filesystem used for early user space.
-  Note: Older versions of "as" (prior to binutils 2.11.90.0.23
-  released on 2001-07-14) dit not support .incbin.
-  If you are forced to use older binutils than that then the
-  following trick can be applied to create the resulting binary:
-
-
-  ld -m elf_i386  --format binary --oformat elf32-i386 -r \
-  -T initramfs_data.scr initramfs_data.cpio.gz -o initramfs_data.o
-   ld -m elf_i386  -r -o built-in.o initramfs_data.o
-
-  initramfs_data.scr looks like this:
-SECTIONS
-{
-       .init.ramfs : { *(.data) }
-}
-
-  The above example is for i386 - the parameters vary from architectures.
-  Eventually look up LDFLAGS_BLOB in an older version of the
-  arch/$(ARCH)/Makefile to see the flags used before .incbin was introduced.
-
-  Using .incbin has the advantage over ld that the correct flags are set
-  in the ELF header, as required by certain architectures.
-*/
-
-.section .init.ramfs,"a"
-.incbin "usr/initramfs_data.cpio.gz"
+#include "initramfs_data.h"
+initramfs_inc "usr/initramfs_data.cpio.gz";
--- /dev/null
+++ b/usr/initramfs_data.h
@@ -0,0 +1,42 @@
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
+  For including the .init.ramfs sections, see include/asm-generic/vmlinux.lds.
+
+  The above example is for i386 - the parameters vary from architectures.
+  Eventually look up LDFLAGS_BLOB in an older version of the
+  arch/$(ARCH)/Makefile to see the flags used before .incbin was introduced.
+
+  Using .incbin has the advantage over ld that the correct flags are set
+  in the ELF header, as required by certain architectures.
+*/
+
+#ifndef __INITRAMFS_DATA_H
+#define __INITRAMFS_DATA_H
+
+.macro initramfs_inc file:req
+.section .init.ramfs,"a"
+__irf_start:
+.incbin "\file"
+__irf_end:
+.section .init.ramfs.info,"a"
+.globl __initramfs_size
+__initramfs_size:
+#ifdef CONFIG_32BIT
+        .long __irf_end - __irf_start
+#else
+        .quad __irf_end - __irf_start
+#endif
+.endm
+
+#endif /* __INITRAMFS_DATA_H */
--- a/usr/initramfs_data.lzma.S
+++ b/usr/initramfs_data.lzma.S
@@ -1,29 +1,2 @@
-/*
-  initramfs_data includes the compressed binary that is the
-  filesystem used for early user space.
-  Note: Older versions of "as" (prior to binutils 2.11.90.0.23
-  released on 2001-07-14) dit not support .incbin.
-  If you are forced to use older binutils than that then the
-  following trick can be applied to create the resulting binary:
-
-
-  ld -m elf_i386  --format binary --oformat elf32-i386 -r \
-  -T initramfs_data.scr initramfs_data.cpio.gz -o initramfs_data.o
-   ld -m elf_i386  -r -o built-in.o initramfs_data.o
-
-  initramfs_data.scr looks like this:
-SECTIONS
-{
-       .init.ramfs : { *(.data) }
-}
-
-  The above example is for i386 - the parameters vary from architectures.
-  Eventually look up LDFLAGS_BLOB in an older version of the
-  arch/$(ARCH)/Makefile to see the flags used before .incbin was introduced.
-
-  Using .incbin has the advantage over ld that the correct flags are set
-  in the ELF header, as required by certain architectures.
-*/
-
-.section .init.ramfs,"a"
-.incbin "usr/initramfs_data.cpio.lzma"
+#include "initramfs_data.h"
+initramfs_inc "usr/initramfs_data.cpio.lzma";


