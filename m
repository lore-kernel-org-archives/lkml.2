Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757369Ab1BPHs5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 02:48:57 -0500
Received: from mprc.pku.edu.cn ([162.105.203.9]:57512 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754867Ab1BPHsy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 02:48:54 -0500
From: "Guan Xuetao" <gxt@mprc.pku.edu.cn>
To: <linux-kernel@vger.kernel.org>, <linux-arch@vger.kernel.org>
Cc: "Arnd Bergmann" <arnd@arndb.de>, "'Greg KH'" <greg@kroah.com>
Subject: [PATCH 05/12] unicore32 additional architecture files: low-level lib: uaccess
Date: Wed, 16 Feb 2011 15:48:46 +0800
Message-ID: <014b01cbcdad$f110afb0$d3320f10$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AcvNrekbExBXE9qhSjKBD/o+mG65PQ==
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Message-Id: <2153a67890e24751c94029ef42e3a17c09249c8a.1297842537.git.gxt@mprc.pku.edu.cn>
In-Reply-To: <cover.1297842537.git.gxt@mprc.pku.edu.cn>
References: <cover.1297842537.git.gxt@mprc.pku.edu.cn>
From: GuanXuetao <gxt@mprc.pku.edu.cn>
Date: Sat, 15 Jan 2011 18:22:46 +0800

This patch implements low-level uaccess libraries.

Signed-off-by: Guan Xuetao <gxt@mprc.pku.edu.cn>
Acked-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/unicore32/include/asm/uaccess.h   |   47 +++++++
 arch/unicore32/lib/clear_user.S        |   57 +++++++++
 arch/unicore32/lib/copy_from_user.S    |  108 ++++++++++++++++
 arch/unicore32/lib/copy_page.S         |   39 ++++++
 arch/unicore32/lib/copy_template.S     |  214 ++++++++++++++++++++++++++++++++
 arch/unicore32/lib/copy_to_user.S      |   96 ++++++++++++++
 arch/unicore32/lib/strncpy_from_user.S |   45 +++++++
 arch/unicore32/lib/strnlen_user.S      |   42 ++++++
 8 files changed, 648 insertions(+), 0 deletions(-)
 create mode 100644 arch/unicore32/include/asm/uaccess.h
 create mode 100644 arch/unicore32/lib/clear_user.S
 create mode 100644 arch/unicore32/lib/copy_from_user.S
 create mode 100644 arch/unicore32/lib/copy_page.S
 create mode 100644 arch/unicore32/lib/copy_template.S
 create mode 100644 arch/unicore32/lib/copy_to_user.S
 create mode 100644 arch/unicore32/lib/strncpy_from_user.S
 create mode 100644 arch/unicore32/lib/strnlen_user.S

diff --git a/arch/unicore32/include/asm/uaccess.h b/arch/unicore32/include/asm/uaccess.h
new file mode 100644
index 0000000..5ff23bc
--- /dev/null
+++ b/arch/unicore32/include/asm/uaccess.h
@@ -0,0 +1,47 @@
+/*
+ * linux/arch/unicore32/include/asm/uaccess.h
+ *
+ * Code specific to PKUnity SoC and UniCore ISA
+ *
+ * Copyright (C) 2001-2010 GUAN Xue-tao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#ifndef __UNICORE_UACCESS_H__
+#define __UNICORE_UACCESS_H__
+
+#include <linux/thread_info.h>
+#include <linux/errno.h>
+
+#include <asm/memory.h>
+#include <asm/system.h>
+
+#define __copy_from_user	__copy_from_user
+#define __copy_to_user		__copy_to_user
+#define __strncpy_from_user	__strncpy_from_user
+#define strnlen_user		strnlen_user
+#define __clear_user		__clear_user
+
+#define __kernel_ok		(segment_eq(get_fs(), KERNEL_DS))
+#define __user_ok(addr, size)	(((size) <= TASK_SIZE)			\
+				&& ((addr) <= TASK_SIZE - (size)))
+#define __access_ok(addr, size)	(__kernel_ok || __user_ok((addr), (size)))
+
+extern unsigned long __must_check
+__copy_from_user(void *to, const void __user *from, unsigned long n);
+extern unsigned long __must_check
+__copy_to_user(void __user *to, const void *from, unsigned long n);
+extern unsigned long __must_check
+__clear_user(void __user *addr, unsigned long n);
+extern unsigned long __must_check
+__strncpy_from_user(char *to, const char __user *from, unsigned long count);
+extern unsigned long
+__strnlen_user(const char __user *s, long n);
+
+#include <asm-generic/uaccess.h>
+
+extern int fixup_exception(struct pt_regs *regs);
+
+#endif /* __UNICORE_UACCESS_H__ */
diff --git a/arch/unicore32/lib/clear_user.S b/arch/unicore32/lib/clear_user.S
new file mode 100644
index 0000000..20047f7
--- /dev/null
+++ b/arch/unicore32/lib/clear_user.S
@@ -0,0 +1,57 @@
+/*
+ * linux/arch/unicore32/lib/clear_user.S
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
+#include <asm/assembler.h>
+
+		.text
+
+/* Prototype: int __clear_user(void *addr, size_t sz)
+ * Purpose  : clear some user memory
+ * Params   : addr - user memory address to clear
+ *          : sz   - number of bytes to clear
+ * Returns  : number of bytes NOT cleared
+ */
+WEAK(__clear_user)
+		stm.w	(lr), [sp-]
+		stm.w	(r1), [sp-]
+		mov	r2, #0
+		csub.a	r1, #4
+		bsl	2f
+		and.a	ip, r0, #3
+		beq	1f
+		csub.a	ip, #2
+		strusr	r2, r0, 1
+		strusr	r2, r0, 1, el
+		strusr	r2, r0, 1, sl
+		rsub	ip, ip, #4
+		sub	r1, r1, ip		@  7  6  5  4  3  2  1
+1:		sub.a	r1, r1, #8		@ -1 -2 -3 -4 -5 -6 -7
+		strusr	r2, r0, 4, ns, rept=2
+		bns	1b
+		add.a	r1, r1, #4		@  3  2  1  0 -1 -2 -3
+		strusr	r2, r0, 4, ns
+2:		cand.a	r1, #2			@ 1x 1x 0x 0x 1x 1x 0x
+		strusr	r2, r0, 1, ne, rept=2
+		cand.a	r1, #1			@ x1 x0 x1 x0 x1 x0 x1
+		beq	3f
+USER(		stb.u	r2, [r0])
+3:		mov	r0, #0
+		ldm.w	(r1), [sp]+
+		ldm.w	(pc), [sp]+
+ENDPROC(__clear_user)
+
+		.pushsection .fixup,"ax"
+		.align	0
+9001:		ldm.w	(r0), [sp]+
+		ldm.w	(pc), [sp]+
+		.popsection
+
diff --git a/arch/unicore32/lib/copy_from_user.S b/arch/unicore32/lib/copy_from_user.S
new file mode 100644
index 0000000..ab0767e
--- /dev/null
+++ b/arch/unicore32/lib/copy_from_user.S
@@ -0,0 +1,108 @@
+/*
+ * linux/arch/unicore32/lib/copy_from_user.S
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
+#include <linux/linkage.h>
+#include <asm/assembler.h>
+
+/*
+ * Prototype:
+ *
+ *	size_t __copy_from_user(void *to, const void *from, size_t n)
+ *
+ * Purpose:
+ *
+ *	copy a block to kernel memory from user memory
+ *
+ * Params:
+ *
+ *	to = kernel memory
+ *	from = user memory
+ *	n = number of bytes to copy
+ *
+ * Return value:
+ *
+ *	Number of bytes NOT copied.
+ */
+
+	.macro ldr1w ptr reg abort
+	ldrusr	\reg, \ptr, 4, abort=\abort
+	.endm
+
+	.macro ldr4w ptr reg1 reg2 reg3 reg4 abort
+100:	ldm.w	(\reg1, \reg2, \reg3, \reg4), [\ptr]+
+	.pushsection __ex_table, "a"
+	.align	3
+	.long 100b, \abort
+	.popsection
+	.endm
+
+	.macro ldr8w ptr reg1 reg2 reg3 reg4 reg5 reg6 reg7 reg8 abort
+100:	ldm.w (\reg1, \reg2, \reg3, \reg4, \reg5, \reg6, \reg7, \reg8), [\ptr]+
+	.pushsection __ex_table, "a"
+	.align	3
+	.long 100b, \abort
+	.popsection
+	.endm
+
+	.macro ldr1b ptr reg cond=al abort
+	ldrusr	\reg, \ptr, 1, \cond, abort=\abort
+	.endm
+
+	.macro str1w ptr reg abort
+	stw.w \reg, [\ptr]+, #4
+	.endm
+
+	.macro str8w ptr reg1 reg2 reg3 reg4 reg5 reg6 reg7 reg8 abort
+	stm.w (\reg1, \reg2, \reg3, \reg4, \reg5, \reg6, \reg7, \reg8), [\ptr]+
+	.endm
+
+	.macro str1b ptr reg cond=al abort
+	.ifnc	\cond, al
+	b\cond	201f
+	b	202f
+	.endif
+201:	stb.w \reg, [\ptr]+, #1
+202:
+	.endm
+
+	.macro enter
+	mov	r3, #0
+	stm.w	(r0, r2, r3), [sp-]
+	.endm
+
+	.macro exit
+	add	sp, sp, #8
+	ldm.w	(r0), [sp]+
+	mov	pc, lr
+	.endm
+
+	.text
+
+ENTRY(__copy_from_user)
+
+#include "copy_template.S"
+
+ENDPROC(__copy_from_user)
+
+	.pushsection .fixup,"ax"
+	.align 0
+	copy_abort_preamble
+	ldm.w	(r1, r2), [sp]+
+	sub	r3, r0, r1
+	rsub	r2, r3, r2
+	stw	r2, [sp]
+	mov	r1, #0
+	b.l	memset
+	ldw.w	r0, [sp]+, #4
+	copy_abort_end
+	.popsection
+
diff --git a/arch/unicore32/lib/copy_page.S b/arch/unicore32/lib/copy_page.S
new file mode 100644
index 0000000..3a448d7
--- /dev/null
+++ b/arch/unicore32/lib/copy_page.S
@@ -0,0 +1,39 @@
+/*
+ * linux/arch/unicore32/lib/copy_page.S
+ *
+ * Code specific to PKUnity SoC and UniCore ISA
+ *
+ * Copyright (C) 2001-2010 GUAN Xue-tao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ *  ASM optimised string functions
+ */
+#include <linux/linkage.h>
+#include <asm/assembler.h>
+#include <generated/asm-offsets.h>
+#include <asm/cache.h>
+
+#define COPY_COUNT (PAGE_SZ/256)
+
+		.text
+		.align	5
+/*
+ * UniCore optimised copy_page routine
+ */
+ENTRY(copy_page)
+		stm.w	(r17 - r19, lr), [sp-]
+		mov	r17, r0
+		mov	r18, r1
+		mov	r19, #COPY_COUNT
+1:
+	.rept	4
+		ldm.w	(r0 - r15), [r18]+
+		stm.w	(r0 - r15), [r17]+
+	.endr
+		sub.a	r19, r19, #1
+		bne	1b
+		ldm.w	(r17 - r19, pc), [sp]+
+ENDPROC(copy_page)
diff --git a/arch/unicore32/lib/copy_template.S b/arch/unicore32/lib/copy_template.S
new file mode 100644
index 0000000..524287f
--- /dev/null
+++ b/arch/unicore32/lib/copy_template.S
@@ -0,0 +1,214 @@
+/*
+ * linux/arch/unicore32/lib/copy_template.S
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
+/*
+ * Theory of operation
+ * -------------------
+ *
+ * This file provides the core code for a forward memory copy used in
+ * the implementation of memcopy(), copy_to_user() and copy_from_user().
+ *
+ * The including file must define the following accessor macros
+ * according to the need of the given function:
+ *
+ * ldr1w ptr reg abort
+ *
+ *	This loads one word from 'ptr', stores it in 'reg' and increments
+ *	'ptr' to the next word. The 'abort' argument is used for fixup tables.
+ *
+ * ldr4w ptr reg1 reg2 reg3 reg4 abort
+ * ldr8w ptr, reg1 reg2 reg3 reg4 reg5 reg6 reg7 reg8 abort
+ *
+ *	This loads four or eight words starting from 'ptr', stores them
+ *	in provided registers and increments 'ptr' past those words.
+ *	The'abort' argument is used for fixup tables.
+ *
+ * ldr1b ptr reg cond abort
+ *
+ *	Similar to ldr1w, but it loads a byte and increments 'ptr' one byte.
+ *	It also must apply the condition code if provided, otherwise the
+ *	"al" condition is assumed by default.
+ *
+ * str1w ptr reg abort
+ * str8w ptr reg1 reg2 reg3 reg4 reg5 reg6 reg7 reg8 abort
+ * str1b ptr reg cond abort
+ *
+ *	Same as their ldr* counterparts, but data is stored to 'ptr' location
+ *	rather than being loaded.
+ *
+ * enter
+ *
+ *	Preserve the provided registers on the stack plus any additional
+ *	data as needed by the implementation including this code. Called
+ *	upon code entry.
+ *
+ * exit
+ *
+ *	Restore registers with the values previously saved with the
+ *	'preserv' macro. Called upon code termination.
+ */
+
+
+		enter
+
+		sub.a	r2, r2, #4
+		bsl	8f
+		and.a	ip, r0, #3
+		bne	9f
+		and.a	ip, r1, #3
+		bne	10f
+
+1:		sub.a	r2, r2, #(28)
+		stm.w	(r5 - r8), [sp-]
+		bsl	5f
+
+3:
+4:		ldr8w	r1, r3, r4, r5, r6, r7, r8, r10, r11, abort=20f
+		sub.a	r2, r2, #32
+		str8w	r0, r3, r4, r5, r6, r7, r8, r10, r11, abort=20f
+		beg	3b
+
+5:		and.a	ip, r2, #28
+		rsub	ip, ip, #32
+		beq	7f
+		add	pc, pc, ip		@ C is always clear here
+		nop
+
+		ldr1w	r1, r3, abort=20f
+		ldr1w	r1, r4, abort=20f
+		ldr1w	r1, r5, abort=20f
+		ldr1w	r1, r6, abort=20f
+		ldr1w	r1, r7, abort=20f
+		ldr1w	r1, r8, abort=20f
+		ldr1w	r1, r11, abort=20f
+
+		add	pc, pc, ip
+		nop
+
+		str1w	r0, r3, abort=20f
+		str1w	r0, r4, abort=20f
+		str1w	r0, r5, abort=20f
+		str1w	r0, r6, abort=20f
+		str1w	r0, r7, abort=20f
+		str1w	r0, r8, abort=20f
+		str1w	r0, r11, abort=20f
+
+7:		ldm.w	(r5 - r8), [sp]+
+
+8:		mov.a	r2, r2 << #31
+		ldr1b	r1, r3, ne, abort=21f
+		ldr1b	r1, r4, ea, abort=21f
+		ldr1b	r1, r10, ea, abort=21f
+		str1b	r0, r3, ne, abort=21f
+		str1b	r0, r4, ea, abort=21f
+		str1b	r0, r10, ea, abort=21f
+
+		exit
+
+9:		rsub	ip, ip, #4
+		csub.a	ip, #2
+		ldr1b	r1, r3, sg, abort=21f
+		ldr1b	r1, r4, eg, abort=21f
+		ldr1b	r1, r11, abort=21f
+		str1b	r0, r3, sg, abort=21f
+		str1b	r0, r4, eg, abort=21f
+		sub.a	r2, r2, ip
+		str1b	r0, r11, abort=21f
+		bsl	8b
+		and.a	ip, r1, #3
+		beq	1b
+
+10:		andn	r1, r1, #3
+		csub.a	ip, #2
+		ldr1w	r1, r11, abort=21f
+		beq	17f
+		bsg	18f
+
+
+		.macro	forward_copy_shift a b
+
+		sub.a	r2, r2, #28
+		bsl	14f
+
+11:		stm.w	(r5 - r9), [sp-]
+
+12:
+		ldr4w	r1, r4, r5, r6, r7, abort=19f
+		mov	r3, r11 pull #\a
+		sub.a	r2, r2, #32
+		ldr4w	r1, r8, r9, r10, r11, abort=19f
+		or	r3, r3, r4 push #\b
+		mov	r4, r4 pull #\a
+		or	r4, r4, r5 push #\b
+		mov	r5, r5 pull #\a
+		or	r5, r5, r6 push #\b
+		mov	r6, r6 pull #\a
+		or	r6, r6, r7 push #\b
+		mov	r7, r7 pull #\a
+		or	r7, r7, r8 push #\b
+		mov	r8, r8 pull #\a
+		or	r8, r8, r9 push #\b
+		mov	r9, r9 pull #\a
+		or	r9, r9, r10 push #\b
+		mov	r10, r10 pull #\a
+		or	r10, r10, r11 push #\b
+		str8w	r0, r3, r4, r5, r6, r7, r8, r9, r10, , abort=19f
+		beg	12b
+
+		ldm.w	(r5 - r9), [sp]+
+
+14:		and.a	ip, r2, #28
+		beq	16f
+
+15:		mov	r3, r11 pull #\a
+		ldr1w	r1, r11, abort=21f
+		sub.a	ip, ip, #4
+		or	r3, r3, r11 push #\b
+		str1w	r0, r3, abort=21f
+		bsg	15b
+
+16:		sub	r1, r1, #(\b / 8)
+		b	8b
+
+		.endm
+
+
+		forward_copy_shift	a=8	b=24
+
+17:		forward_copy_shift	a=16	b=16
+
+18:		forward_copy_shift	a=24	b=8
+
+
+/*
+ * Abort preamble and completion macros.
+ * If a fixup handler is required then those macros must surround it.
+ * It is assumed that the fixup code will handle the private part of
+ * the exit macro.
+ */
+
+	.macro	copy_abort_preamble
+19:	ldm.w	(r5 - r9), [sp]+
+	b	21f
+299:	.word	0			@ store lr
+					@ to avoid function call in fixup
+20:	ldm.w	(r5 - r8), [sp]+
+21:
+	adr	r1, 299b
+	stw	lr, [r1]
+	.endm
+
+	.macro	copy_abort_end
+	adr	lr, 299b
+	ldw	pc, [lr]
+	.endm
+
diff --git a/arch/unicore32/lib/copy_to_user.S b/arch/unicore32/lib/copy_to_user.S
new file mode 100644
index 0000000..6e22151
--- /dev/null
+++ b/arch/unicore32/lib/copy_to_user.S
@@ -0,0 +1,96 @@
+/*
+ * linux/arch/unicore32/lib/copy_to_user.S
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
+#include <linux/linkage.h>
+#include <asm/assembler.h>
+
+/*
+ * Prototype:
+ *
+ *	size_t __copy_to_user(void *to, const void *from, size_t n)
+ *
+ * Purpose:
+ *
+ *	copy a block to user memory from kernel memory
+ *
+ * Params:
+ *
+ *	to = user memory
+ *	from = kernel memory
+ *	n = number of bytes to copy
+ *
+ * Return value:
+ *
+ *	Number of bytes NOT copied.
+ */
+
+	.macro ldr1w ptr reg abort
+	ldw.w \reg, [\ptr]+, #4
+	.endm
+
+	.macro ldr4w ptr reg1 reg2 reg3 reg4 abort
+	ldm.w	(\reg1, \reg2, \reg3, \reg4), [\ptr]+
+	.endm
+
+	.macro ldr8w ptr reg1 reg2 reg3 reg4 reg5 reg6 reg7 reg8 abort
+	ldm.w (\reg1, \reg2, \reg3, \reg4, \reg5, \reg6, \reg7, \reg8), [\ptr]+
+	.endm
+
+	.macro ldr1b ptr reg cond=al abort
+	notcond	\cond, .+8
+	ldb.w \reg, [\ptr]+, #1
+	.endm
+
+	.macro str1w ptr reg abort
+	strusr	\reg, \ptr, 4, abort=\abort
+	.endm
+
+	.macro str8w ptr reg1 reg2 reg3 reg4 reg5 reg6 reg7 reg8 abort
+100:	stm.w (\reg1, \reg2, \reg3, \reg4, \reg5, \reg6, \reg7, \reg8), [\ptr]+
+
+	.pushsection __ex_table, "a"
+	.long 100b, \abort
+	.popsection
+	.endm
+
+	.macro str1b ptr reg cond=al abort
+	strusr	\reg, \ptr, 1, \cond, abort=\abort
+	.endm
+
+	.macro enter
+	mov	r3, #0
+	stm.w	(r0, r2, r3), [sp-]
+	.endm
+
+	.macro exit
+	add	sp, sp, #8
+	ldm.w	(r0), [sp]+
+	mov	pc, lr
+	.endm
+
+	.text
+
+WEAK(__copy_to_user)
+
+#include "copy_template.S"
+
+ENDPROC(__copy_to_user)
+
+	.pushsection .fixup,"ax"
+	.align 0
+	copy_abort_preamble
+	ldm.w	(r1, r2, r3), [sp]+
+	sub	r0, r0, r1
+	rsub	r0, r0, r2
+	copy_abort_end
+	.popsection
+
diff --git a/arch/unicore32/lib/strncpy_from_user.S b/arch/unicore32/lib/strncpy_from_user.S
new file mode 100644
index 0000000..ff6c304
--- /dev/null
+++ b/arch/unicore32/lib/strncpy_from_user.S
@@ -0,0 +1,45 @@
+/*
+ * linux/arch/unicore32/lib/strncpy_from_user.S
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
+#include <asm/assembler.h>
+#include <asm/errno.h>
+
+	.text
+	.align	5
+
+/*
+ * Copy a string from user space to kernel space.
+ *  r0 = dst, r1 = src, r2 = byte length
+ * returns the number of characters copied (strlen of copied string),
+ *  -EFAULT on exception, or "len" if we fill the whole buffer
+ */
+ENTRY(__strncpy_from_user)
+	mov	ip, r1
+1:	sub.a	r2, r2, #1
+	ldrusr	r3, r1, 1, ns
+	bfs	2f
+	stb.w	r3, [r0]+, #1
+	cxor.a	r3, #0
+	bne	1b
+	sub	r1, r1, #1	@ take NUL character out of count
+2:	sub	r0, r1, ip
+	mov	pc, lr
+ENDPROC(__strncpy_from_user)
+
+	.pushsection .fixup,"ax"
+	.align	0
+9001:	mov	r3, #0
+	stb	r3, [r0+], #0	@ null terminate
+	mov	r0, #-EFAULT
+	mov	pc, lr
+	.popsection
+
diff --git a/arch/unicore32/lib/strnlen_user.S b/arch/unicore32/lib/strnlen_user.S
new file mode 100644
index 0000000..7586303
--- /dev/null
+++ b/arch/unicore32/lib/strnlen_user.S
@@ -0,0 +1,42 @@
+/*
+ * linux/arch/unicore32/lib/strnlen_user.S
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
+#include <asm/assembler.h>
+#include <asm/errno.h>
+
+	.text
+	.align	5
+
+/* Prototype: unsigned long __strnlen_user(const char *str, long n)
+ * Purpose  : get length of a string in user memory
+ * Params   : str - address of string in user memory
+ * Returns  : length of string *including terminator*
+ *	      or zero on exception, or n + 1 if too long
+ */
+ENTRY(__strnlen_user)
+	mov	r2, r0
+1:
+	ldrusr	r3, r0, 1
+	cxor.a	r3, #0
+	beq	2f
+	sub.a	r1, r1, #1
+	bne	1b
+	add	r0, r0, #1
+2:	sub	r0, r0, r2
+	mov	pc, lr
+ENDPROC(__strnlen_user)
+
+	.pushsection .fixup,"ax"
+	.align	0
+9001:	mov	r0, #0
+	mov	pc, lr
+	.popsection
-- 
1.6.2.2


