Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753118Ab0HZLsG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 07:48:06 -0400
Received: from mtagate3.uk.ibm.com ([194.196.100.163]:53951 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752692Ab0HZLsC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 07:48:02 -0400
Message-Id: <20100826114756.968317703@linux.vnet.ibm.com>
References: <20100826114122.292120483@linux.vnet.ibm.com>
User-Agent: quilt/0.46-1
Date: Thu, 26 Aug 2010 13:41:23 +0200
From: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Michael Holzheu <holzheu@linux.vnet.ibm.com>, tabbott@ksplice.com,
        vda.linux@googlemail.com, mmarek@suse.cz, hpa@linux.intel.com,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        heiko.carstens@de.ibm.com, brueckner@linux.vnet.ibm.com,
        schwidefsky@de.ibm.com
In-Reply-To: <20100825180601.GA2116@merkur.ravnborg.org>
Subject: [PATCH v2 1/2] initramfs: Generalize initramfs_data.xxx.S variants
Content-Disposition: inline; filename=irfs1.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove initramfs_data.{lzo,lzma,gz,bz2}.S variants and use a common
implementation in initramfs_data.S.  The common implementation expects
the file name of the initramfs to be defined in INITRAMFS_IMAGE.

Change the Makefile to set the INITRAMFS_IMAGE define symbol according
to the selected compression method.

Signed-off-by: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
---
 usr/Makefile              |    6 ++++--
 usr/initramfs_data.S      |    5 +++--
 usr/initramfs_data.bz2.S  |   29 -----------------------------
 usr/initramfs_data.gz.S   |   29 -----------------------------
 usr/initramfs_data.lzma.S |   29 -----------------------------
 usr/initramfs_data.lzo.S  |   29 -----------------------------
 6 files changed, 7 insertions(+), 120 deletions(-)

--- a/usr/Makefile
+++ b/usr/Makefile
@@ -18,13 +18,15 @@ suffix_$(CONFIG_INITRAMFS_COMPRESSION_LZ
 # Lzo
 suffix_$(CONFIG_INITRAMFS_COMPRESSION_LZO)   = .lzo
 
+AFLAGS_initramfs_data.o += -DINITRAMFS_IMAGE="usr/initramfs_data.cpio$(suffix_y)"
+
 # Generate builtin.o based on initramfs_data.o
-obj-$(CONFIG_BLK_DEV_INITRD) := initramfs_data$(suffix_y).o
+obj-$(CONFIG_BLK_DEV_INITRD) := initramfs_data.o
 
 # initramfs_data.o contains the compressed initramfs_data.cpio image.
 # The image is included using .incbin, a dependency which is not
 # tracked automatically.
-$(obj)/initramfs_data$(suffix_y).o: $(obj)/initramfs_data.cpio$(suffix_y) FORCE
+$(obj)/initramfs_data.o: $(obj)/initramfs_data.cpio$(suffix_y) FORCE
 
 #####
 # Generate the initramfs cpio archive
--- a/usr/initramfs_data.S
+++ b/usr/initramfs_data.S
@@ -25,6 +25,7 @@ SECTIONS
   in the ELF header, as required by certain architectures.
 */
 
-.section .init.ramfs,"a"
-.incbin "usr/initramfs_data.cpio"
+#include <linux/stringify.h>
 
+.section .init.ramfs,"a"
+.incbin __stringify(INITRAMFS_IMAGE)
--- a/usr/initramfs_data.bz2.S
+++ /dev/null
@@ -1,29 +0,0 @@
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
--- a/usr/initramfs_data.gz.S
+++ /dev/null
@@ -1,29 +0,0 @@
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
--- a/usr/initramfs_data.lzma.S
+++ /dev/null
@@ -1,29 +0,0 @@
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
--- a/usr/initramfs_data.lzo.S
+++ /dev/null
@@ -1,29 +0,0 @@
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
-.incbin "usr/initramfs_data.cpio.lzo"

-- 
