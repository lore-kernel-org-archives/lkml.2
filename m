Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758709Ab1BPHu2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 02:50:28 -0500
Received: from mprc.pku.edu.cn ([162.105.203.9]:42697 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755489Ab1BPHuP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 02:50:15 -0500
From: "Guan Xuetao" <gxt@mprc.pku.edu.cn>
To: <linux-kernel@vger.kernel.org>, <linux-arch@vger.kernel.org>
Cc: "Arnd Bergmann" <arnd@arndb.de>, "'Greg KH'" <greg@kroah.com>
Subject: [PATCH 07/12] unicore32 additional architecture files: boot process
Date: Wed, 16 Feb 2011 15:50:09 +0800
Message-ID: <014f01cbcdae$22412790$66c376b0$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AcvNrhjq1/3LAOthT/ePJURGXlrsTQ==
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Message-Id: <a62b51cab5f387297db1cade6ccc835711cee4f6.1297842537.git.gxt@mprc.pku.edu.cn>
In-Reply-To: <cover.1297842537.git.gxt@mprc.pku.edu.cn>
References: <cover.1297842537.git.gxt@mprc.pku.edu.cn>
From: GuanXuetao <gxt@mprc.pku.edu.cn>
Date: Sat, 15 Jan 2011 18:23:31 +0800

This patch implements booting process, including uncompression process.

Signed-off-by: Guan Xuetao <gxt@mprc.pku.edu.cn>
---
 arch/unicore32/boot/Makefile                  |   47 ++++++
 arch/unicore32/boot/compressed/Makefile       |   68 ++++++++
 arch/unicore32/boot/compressed/head.S         |  204 +++++++++++++++++++++++++
 arch/unicore32/boot/compressed/misc.c         |  126 +++++++++++++++
 arch/unicore32/boot/compressed/piggy.S.in     |    6 +
 arch/unicore32/boot/compressed/vmlinux.lds.in |   61 ++++++++
 arch/unicore32/include/mach/uncompress.h      |   34 ++++
 7 files changed, 546 insertions(+), 0 deletions(-)
 create mode 100644 arch/unicore32/boot/Makefile
 create mode 100644 arch/unicore32/boot/compressed/Makefile
 create mode 100644 arch/unicore32/boot/compressed/head.S
 create mode 100644 arch/unicore32/boot/compressed/misc.c
 create mode 100644 arch/unicore32/boot/compressed/piggy.S.in
 create mode 100644 arch/unicore32/boot/compressed/vmlinux.lds.in
 create mode 100644 arch/unicore32/include/mach/uncompress.h

diff --git a/arch/unicore32/boot/Makefile b/arch/unicore32/boot/Makefile
new file mode 100644
index 0000000..79e5f88
--- /dev/null
+++ b/arch/unicore32/boot/Makefile
@@ -0,0 +1,47 @@
+#
+# arch/unicore32/boot/Makefile
+#
+# This file is included by the global makefile so that you can add your own
+# architecture-specific flags and dependencies.
+#
+# This file is subject to the terms and conditions of the GNU General Public
+# License.  See the file "COPYING" in the main directory of this archive
+# for more details.
+#
+# Copyright (C) 2001~2010 GUAN Xue-tao
+#
+
+MKIMAGE := $(srctree)/scripts/mkuboot.sh
+
+targets := Image zImage uImage
+
+$(obj)/Image: vmlinux FORCE
+	$(call if_changed,objcopy)
+	@echo '  Kernel: $@ is ready'
+
+$(obj)/compressed/vmlinux: $(obj)/Image FORCE
+	$(Q)$(MAKE) $(build)=$(obj)/compressed $@
+
+$(obj)/zImage: $(obj)/compressed/vmlinux FORCE
+	$(call if_changed,objcopy)
+	@echo '  Kernel: $@ is ready'
+
+quiet_cmd_uimage = UIMAGE  $@
+      cmd_uimage = $(CONFIG_SHELL) $(MKIMAGE) -A unicore -O linux -T kernel \
+		   -C none -a $(LOADADDR) -e $(STARTADDR) \
+		   -n 'Linux-$(KERNELRELEASE)' -d $< $@
+
+$(obj)/uImage: LOADADDR=0x0
+
+$(obj)/uImage: STARTADDR=$(LOADADDR)
+
+$(obj)/uImage: $(obj)/zImage FORCE
+	$(call if_changed,uimage)
+	@echo '  Image $@ is ready'
+
+PHONY += initrd FORCE
+initrd:
+	@test "$(INITRD)" != "" || \
+	(echo You must specify INITRD; exit -1)
+
+subdir- := compressed
diff --git a/arch/unicore32/boot/compressed/Makefile b/arch/unicore32/boot/compressed/Makefile
new file mode 100644
index 0000000..9537342
--- /dev/null
+++ b/arch/unicore32/boot/compressed/Makefile
@@ -0,0 +1,68 @@
+#
+# linux/arch/unicore32/boot/compressed/Makefile
+#
+# create a compressed vmlinuz image from the original vmlinux
+#
+# This file is subject to the terms and conditions of the GNU General Public
+# License.  See the file "COPYING" in the main directory of this archive
+# for more details.
+#
+# Copyright (C) 2001~2010 GUAN Xue-tao
+#
+
+EXTRA_CFLAGS	:= -fpic -fno-builtin
+EXTRA_AFLAGS	:= -Wa,-march=all
+
+OBJS		:= misc.o
+
+# font.c and font.o
+CFLAGS_font.o	:= -Dstatic=
+$(obj)/font.c: $(srctree)/drivers/video/console/font_8x8.c
+	$(call cmd,shipped)
+
+# piggy.S and piggy.o
+suffix_$(CONFIG_KERNEL_GZIP)	:= gzip
+suffix_$(CONFIG_KERNEL_BZIP2)	:= bz2
+suffix_$(CONFIG_KERNEL_LZO)	:= lzo
+suffix_$(CONFIG_KERNEL_LZMA)	:= lzma
+
+$(obj)/piggy.$(suffix_y): $(obj)/../Image FORCE
+	$(call if_changed,$(suffix_y))
+
+SEDFLAGS_piggy	= s/DECOMP_SUFFIX/$(suffix_y)/
+$(obj)/piggy.S: $(obj)/piggy.S.in
+	@sed "$(SEDFLAGS_piggy)" < $< > $@
+
+$(obj)/piggy.o:  $(obj)/piggy.$(suffix_y) $(obj)/piggy.S FORCE
+
+targets		:= vmlinux vmlinux.lds font.o font.c head.o misc.o \
+			piggy.$(suffix_y) piggy.o piggy.S \
+
+# Make sure files are removed during clean
+extra-y		+= piggy.gzip piggy.bz2 piggy.lzo piggy.lzma
+
+# ?
+LDFLAGS_vmlinux += -p
+# Report unresolved symbol references
+LDFLAGS_vmlinux += --no-undefined
+# Delete all temporary local symbols
+LDFLAGS_vmlinux += -X
+# Next argument is a linker script
+LDFLAGS_vmlinux += -T
+
+# For uidivmod
+$(obj)/vmlinux: $(obj)/vmlinux.lds $(obj)/head.o $(obj)/piggy.o \
+		$(obj)/misc.o FORCE
+	$(call if_changed,ld)
+	@:
+
+# We now have a PIC decompressor implementation.  Decompressors running
+# from RAM should not define ZTEXTADDR.  Decompressors running directly
+# from ROM or Flash must define ZTEXTADDR (preferably via the config)
+ZTEXTADDR	:= 0
+ZBSSADDR	:= ALIGN(4)
+
+SEDFLAGS_lds	= s/TEXT_START/$(ZTEXTADDR)/;s/BSS_START/$(ZBSSADDR)/
+$(obj)/vmlinux.lds: $(obj)/vmlinux.lds.in arch/unicore32/boot/Makefile $(KCONFIG_CONFIG)
+	@sed "$(SEDFLAGS_lds)" < $< > $@
+
diff --git a/arch/unicore32/boot/compressed/head.S b/arch/unicore32/boot/compressed/head.S
new file mode 100644
index 0000000..fbd1e37
--- /dev/null
+++ b/arch/unicore32/boot/compressed/head.S
@@ -0,0 +1,204 @@
+/*
+ * linux/arch/unicore32/boot/compressed/head.S
+ *
+ * Code specific to PKUnity SoC and UniCore ISA
+ *
+ * Copyright (C) 2001-2010 GUAN Xue-tao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#include <linux/linkage.h>
+#include <mach/memory.h>
+
+#define csub	cmpsub
+#define cand	cmpand
+#define nop8	nop; nop; nop; nop; nop; nop; nop; nop
+
+		.section ".start", #alloc, #execinstr
+		.text
+start:
+		.type	start,#function
+
+		/* Initialize ASR, PRIV mode and INTR off */
+		mov	r0, #0xD3
+		mov.a	asr, r0
+
+		adr	r0, LC0
+		ldm	(r1, r2, r3, r5, r6, r7, r8), [r0]+
+		ldw	sp, [r0+], #28
+		sub.a	r0, r0, r1		@ calculate the delta offset
+
+		/*
+		 * if delta is zero, we are running at the address
+		 * we were linked at.
+		 */
+		beq	not_relocated
+
+		/*
+		 * We're running at a different address.  We need to fix
+		 * up various pointers:
+		 *   r5 - zImage base address (_start)
+		 *   r7 - GOT start
+		 *   r8 - GOT end
+		 */
+		add	r5, r5, r0
+		add	r7, r7, r0
+		add	r8, r8, r0
+
+		/*
+		 * we need to fix up pointers into the BSS region.
+		 *   r2 - BSS start
+		 *   r3 - BSS end
+		 *   sp - stack pointer
+		 */
+		add	r2, r2, r0
+		add	r3, r3, r0
+		add	sp, sp, r0
+
+		/*
+		 * Relocate all entries in the GOT table.
+		 * This fixes up the C references.
+		 *   r7 - GOT start
+		 *   r8 - GOT end
+		 */
+1001:		ldw	r1, [r7+], #0
+		add	r1, r1, r0
+		stw.w	r1, [r7]+, #4
+		csub.a	r7, r8
+		bub	1001b
+
+not_relocated:
+		/*
+		 * Clear BSS region.
+		 *   r2 - BSS start
+		 *   r3 - BSS end
+		 */
+		mov	r0, #0
+1002:		stw.w	r0, [r2]+, #4
+		csub.a	r2, r3
+		bub	1002b
+
+		/*
+		 * Turn on the cache.
+		 */
+                mov     r0, #0
+                movc    p0.c5, r0, #28		@ cache invalidate all
+                nop8
+                movc    p0.c6, r0, #6		@ tlb invalidate all
+                nop8
+
+                mov     r0, #0x1c		@ en icache and wb dcache
+                movc    p0.c1, r0, #0
+                nop8
+
+		/*
+		 * Set up some pointers, for starting decompressing.
+		 */
+
+		mov	r1, sp			@ malloc space above stack
+		add	r2, sp, #0x10000	@ 64k max
+
+		/*
+		 * Check to see if we will overwrite ourselves.
+		 *   r4 = final kernel address
+		 *   r5 = start of this image
+		 *   r6 = size of decompressed image
+		 *   r2 = end of malloc space (and therefore this image)
+		 * We basically want:
+		 *   r4 >= r2 -> OK
+		 *   r4 + image length <= r5 -> OK
+		 */
+		ldw	r4, =KERNEL_IMAGE_START
+		csub.a	r4, r2
+		bea	wont_overwrite
+		add	r0, r4, r6
+		csub.a	r0, r5
+		beb	wont_overwrite
+
+		/*
+		 * If overwrite, just print error message
+		 */
+		b	__error_overwrite
+
+		/*
+		 * We're not in danger of overwriting ourselves.
+		 * Do this the simple way.
+		 */
+wont_overwrite:
+		/*
+		 * decompress_kernel:
+		 *   r0: output_start
+		 *   r1: free_mem_ptr_p
+		 *   r2: free_mem_ptr_end_p
+		 */
+		mov	r0, r4
+		b.l	decompress_kernel	@ C functions
+
+		/*
+		 * Clean and flush the cache to maintain consistency.
+		 */
+		mov	r0, #0
+                movc    p0.c5, r0, #14		@ flush dcache
+		nop8
+                movc    p0.c5, r0, #20		@ icache invalidate all
+                nop8
+
+		/*
+		 * Turn off the Cache and MMU.
+		 */
+		mov	r0, #0			@ disable i/d cache and MMU
+		movc	p0.c1, r0, #0
+                nop8
+
+		mov	r0, #0			@ must be zero
+		ldw	r4, =KERNEL_IMAGE_START
+		mov	pc, r4			@ call kernel
+
+
+		.align	2
+		.type	LC0, #object
+LC0:		.word	LC0			@ r1
+		.word	__bss_start		@ r2
+		.word	_end			@ r3
+		.word	_start			@ r5
+		.word	_image_size		@ r6
+		.word	_got_start		@ r7
+		.word	_got_end		@ r8
+		.word	decompress_stack_end	@ sp
+		.size	LC0, . - LC0
+
+print_string:
+#ifdef CONFIG_DEBUG_OCD
+2001:		ldb.w	r1, [r0]+, #1
+		csub.a	r1, #0
+		bne	2002f
+		mov	pc, lr
+2002:
+		movc	r2, p1.c0, #0
+		cand.a	r2, #2
+		bne	2002b
+		movc	p1.c1, r1, #1
+		csub.a	r1, #'\n'
+		cmoveq	r1, #'\r'
+		beq	2002b
+		b	2001b
+#else
+		mov	pc, lr
+#endif
+
+__error_overwrite:
+		adr	r0, str_error
+		b.l	print_string
+2001:		nop8
+		b	2001b
+str_error:	.asciz	"\nError: Kernel address OVERWRITE\n"
+		.align
+
+		.ltorg
+
+		.align	4
+		.section ".stack", "aw", %nobits
+decompress_stack:	.space	4096
+decompress_stack_end:
diff --git a/arch/unicore32/boot/compressed/misc.c b/arch/unicore32/boot/compressed/misc.c
new file mode 100644
index 0000000..176d5bd
--- /dev/null
+++ b/arch/unicore32/boot/compressed/misc.c
@@ -0,0 +1,126 @@
+/*
+ * linux/arch/unicore32/boot/compressed/misc.c
+ *
+ * Code specific to PKUnity SoC and UniCore ISA
+ *
+ * Copyright (C) 2001-2010 GUAN Xue-tao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <asm/unaligned.h>
+#include <mach/uncompress.h>
+
+/*
+ * gzip delarations
+ */
+unsigned char *output_data;
+unsigned long output_ptr;
+
+unsigned int free_mem_ptr;
+unsigned int free_mem_end_ptr;
+
+#define STATIC static
+#define STATIC_RW_DATA	/* non-static please */
+
+/*
+ * arch-dependent implementations
+ */
+#ifndef ARCH_HAVE_DECOMP_ERROR
+#define arch_decomp_error(x)
+#endif
+
+#ifndef ARCH_HAVE_DECOMP_SETUP
+#define arch_decomp_setup()
+#endif
+
+#ifndef ARCH_HAVE_DECOMP_PUTS
+#define arch_decomp_puts(p)
+#endif
+
+void *memcpy(void *dest, const void *src, size_t n)
+{
+	int i = 0;
+	unsigned char *d = (unsigned char *)dest, *s = (unsigned char *)src;
+
+	for (i = n >> 3; i > 0; i--) {
+		*d++ = *s++;
+		*d++ = *s++;
+		*d++ = *s++;
+		*d++ = *s++;
+		*d++ = *s++;
+		*d++ = *s++;
+		*d++ = *s++;
+		*d++ = *s++;
+	}
+
+	if (n & 1 << 2) {
+		*d++ = *s++;
+		*d++ = *s++;
+		*d++ = *s++;
+		*d++ = *s++;
+	}
+
+	if (n & 1 << 1) {
+		*d++ = *s++;
+		*d++ = *s++;
+	}
+
+	if (n & 1)
+		*d++ = *s++;
+
+	return dest;
+}
+
+void error(char *x)
+{
+	arch_decomp_puts("\n\n");
+	arch_decomp_puts(x);
+	arch_decomp_puts("\n\n -- System halted");
+
+	arch_decomp_error(x);
+
+	for (;;)
+		; /* Halt */
+}
+
+/* Heap size should be adjusted for different decompress method */
+#ifdef CONFIG_KERNEL_GZIP
+#include "../../../../lib/decompress_inflate.c"
+#endif
+
+#ifdef CONFIG_KERNEL_BZIP2
+#include "../../../../lib/decompress_bunzip2.c"
+#endif
+
+#ifdef CONFIG_KERNEL_LZO
+#include "../../../../lib/decompress_unlzo.c"
+#endif
+
+#ifdef CONFIG_KERNEL_LZMA
+#include "../../../../lib/decompress_unlzma.c"
+#endif
+
+unsigned long decompress_kernel(unsigned long output_start,
+		unsigned long free_mem_ptr_p,
+		unsigned long free_mem_ptr_end_p)
+{
+	unsigned char *tmp;
+
+	output_data		= (unsigned char *)output_start;
+	free_mem_ptr		= free_mem_ptr_p;
+	free_mem_end_ptr	= free_mem_ptr_end_p;
+
+	arch_decomp_setup();
+
+	tmp = (unsigned char *) (((unsigned long)input_data_end) - 4);
+	output_ptr = get_unaligned_le32(tmp);
+
+	arch_decomp_puts("Uncompressing Linux...");
+	decompress(input_data, input_data_end - input_data, NULL, NULL,
+			output_data, NULL, error);
+	arch_decomp_puts(" done, booting the kernel.\n");
+	return output_ptr;
+}
diff --git a/arch/unicore32/boot/compressed/piggy.S.in b/arch/unicore32/boot/compressed/piggy.S.in
new file mode 100644
index 0000000..b79704d
--- /dev/null
+++ b/arch/unicore32/boot/compressed/piggy.S.in
@@ -0,0 +1,6 @@
+	.section .piggydata,#alloc
+	.globl	input_data
+input_data:
+	.incbin	"arch/unicore32/boot/compressed/piggy.DECOMP_SUFFIX"
+	.globl	input_data_end
+input_data_end:
diff --git a/arch/unicore32/boot/compressed/vmlinux.lds.in b/arch/unicore32/boot/compressed/vmlinux.lds.in
new file mode 100644
index 0000000..d5a3ce2
--- /dev/null
+++ b/arch/unicore32/boot/compressed/vmlinux.lds.in
@@ -0,0 +1,61 @@
+/*
+ * linux/arch/unicore/boot/compressed/vmlinux.lds.in
+ *
+ * Code specific to PKUnity SoC and UniCore ISA
+ *
+ * Copyright (C) 2001-2010 GUAN Xue-tao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+OUTPUT_ARCH(unicore32)
+ENTRY(_start)
+SECTIONS
+{
+  /DISCARD/ : {
+    /*
+     * Discard any r/w data - this produces a link error if we have any,
+     * which is required for PIC decompression.  Local data generates
+     * GOTOFF relocations, which prevents it being relocated independently
+     * of the text/got segments.
+     */
+    *(.data)
+  }
+
+  . = TEXT_START;
+  _text = .;
+
+  .text : {
+    _start = .;
+    *(.start)
+    *(.text)
+    *(.text.*)
+    *(.fixup)
+    *(.gnu.warning)
+    *(.rodata)
+    *(.rodata.*)
+    *(.piggydata)
+    . = ALIGN(4);
+  }
+
+  _etext = .;
+
+  /* Assume size of decompressed image is 4x the compressed image */
+  _image_size = (_etext - _text) * 4;
+
+  _got_start = .;
+  .got			: { *(.got) }
+  _got_end = .;
+  .got.plt		: { *(.got.plt) }
+  _edata = .;
+
+  . = BSS_START;
+  __bss_start = .;
+  .bss			: { *(.bss) }
+  _end = .;
+
+  .stack		: { *(.stack) }
+  .comment 0		: { *(.comment) }
+}
+
diff --git a/arch/unicore32/include/mach/uncompress.h b/arch/unicore32/include/mach/uncompress.h
new file mode 100644
index 0000000..142d3e7
--- /dev/null
+++ b/arch/unicore32/include/mach/uncompress.h
@@ -0,0 +1,34 @@
+/*
+ * linux/arch/unicore32/include/mach/uncompress.h
+ *
+ * Code specific to PKUnity SoC and UniCore ISA
+ *
+ * Copyright (C) 2001-2010 GUAN Xue-tao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef __MACH_PUV3_UNCOMPRESS_H__
+#define __MACH_PUV3_UNCOMPRESS_H__
+
+#include "hardware.h"
+#include "ocd.h"
+
+extern char input_data[];
+extern char input_data_end[];
+
+static void arch_decomp_puts(const char *ptr)
+{
+	char c;
+
+	while ((c = *ptr++) != '\0') {
+		if (c == '\n')
+			putc('\r');
+		putc(c);
+	}
+}
+#define ARCH_HAVE_DECOMP_PUTS
+
+#endif /* __MACH_PUV3_UNCOMPRESS_H__ */
-- 
1.6.2.2


