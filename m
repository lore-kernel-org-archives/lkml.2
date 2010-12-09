Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754758Ab0LIJnX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 04:43:23 -0500
Received: from mprc.pku.edu.cn ([162.105.203.9]:52005 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750839Ab0LIJnU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 04:43:20 -0500
From: "Guan Xuetao" <guanxuetao@mprc.pku.edu.cn>
To: "Arnd Bergmann" <arnd@arndb.de>
Cc: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCHv1 014/211] unicore32: new file arch/unicore32/include/asm/assembler.h
Date: Thu, 9 Dec 2010 17:43:17 +0800
Message-ID: <01e601cb9785$81d0a410$8571ec30$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AcuXhYF3rpxFDdpHRm2Vhk1mkOJ+UQ==
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Guan Xuetao <guanxuetao@mprc.pku.edu.cn>

	assembler.h include many macros for generic using in unicore32

Signed-off-by: Guan Xuetao <guanxuetao@mprc.pku.edu.cn>
---
 arch/unicore32/include/asm/assembler.h |  193
++++++++++++++++++++++++++++++++
 1 files changed, 193 insertions(+), 0 deletions(-)

diff --git a/arch/unicore32/include/asm/assembler.h
b/arch/unicore32/include/asm/assembler.h
new file mode 100644
index 0000000..268a4f6
--- /dev/null
+++ b/arch/unicore32/include/asm/assembler.h
@@ -0,0 +1,193 @@
+/*
+ * linux/arch/unicore32/include/asm/assembler.h
+ *
+ * Code specific to PKUnity SoC and UniCore ISA
+ *
+ * Copyright (C) 2001-2010 GUAN Xue-tao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ *  Do not include any C declarations in this file - it is included by
+ *  assembler source.
+ */
+#ifndef __ASSEMBLY__
+#error "Only include this from assembly code"
+#endif
+
+#include <asm/ptrace.h>
+
+/*
+ * Little Endian independent macros for shifting bytes within registers.
+ */
+#define pull            >>
+#define push            <<
+#define get_byte_0      << #0
+#define get_byte_1	>> #8
+#define get_byte_2	>> #16
+#define get_byte_3	>> #24
+#define put_byte_0      << #0
+#define put_byte_1	<< #8
+#define put_byte_2	<< #16
+#define put_byte_3	<< #24
+
+#define cadd		cmpadd
+#define cand		cmpand
+#define csub		cmpsub
+#define cxor		cmpxor
+
+/*
+ * Enable and disable interrupts
+ */
+	.macro	disable_irq_notrace, temp
+	mov	\temp, asr
+	andn     \temp, \temp, #0xFF
+	or	\temp, \temp, #PSR_I_BIT | PRIV_MODE
+	mov.a	asr, \temp
+	.endm
+
+	.macro	enable_irq_notrace, temp
+	mov	\temp, asr
+	andn     \temp, \temp, #0xFF
+	or	\temp, \temp, #PRIV_MODE
+	mov.a	asr, \temp
+	.endm
+
+	.macro asm_trace_hardirqs_off
+#if defined(CONFIG_TRACE_IRQFLAGS)
+	stm.w   {ip, lr}, [sp-]
+	stm.w   {r0-r3}, [sp-]
+	b.l	trace_hardirqs_off
+	ldm.w	{r0-r3}, [sp]+
+	ldm.w	{ip, lr}, [sp]+
+#endif
+	.endm
+
+	.macro asm_trace_hardirqs_on_cond, cond
+#if defined(CONFIG_TRACE_IRQFLAGS)
+	/*
+	 * actually the registers should be pushed and pop'd conditionally,
but
+	 * after bl the flags are certainly clobbered
+	 */
+	stm.w   {ip, lr}, [sp-]
+	stm.w   {r0-r3}, [sp-]
+	bl\cond	trace_hardirqs_on
+	ldm.w	{r0-r3}, [sp]+
+	ldm.w	{ip, lr}, [sp]+
+#endif
+	.endm
+
+	.macro asm_trace_hardirqs_on
+	asm_trace_hardirqs_on_cond al
+	.endm
+
+	.macro disable_irq, temp
+	disable_irq_notrace \temp
+	asm_trace_hardirqs_off
+	.endm
+
+	.macro enable_irq, temp
+	asm_trace_hardirqs_on
+	enable_irq_notrace \temp
+	.endm
+/*
+ * Save the current IRQ state and disable IRQs.  Note that this macro
+ * assumes that the processor is in PRIV mode.
+ */
+	.macro	save_and_disable_irqs, oldcpsr, temp
+	mov	\oldcpsr, asr
+	disable_irq     \temp
+	.endm
+
+/*
+ * Restore interrupt state previously stored in a register.  We don't
+ * guarantee that this will preserve the flags.
+ */
+	.macro	restore_irqs_notrace, oldcpsr, temp
+	mov	\temp, asr
+	mov.a	asr, \oldcpsr
+	mov.f	asr, \temp
+	.endm
+
+	.macro restore_irqs, oldcpsr, temp
+	cmpand.a	\oldcpsr, #PSR_I_BIT
+	asm_trace_hardirqs_on_cond eq
+	restore_irqs_notrace \oldcpsr, \temp
+	.endm
+
+#define USER(x...)				\
+9999:	x;					\
+	.pushsection __ex_table, "a";		\
+	.align	3;				\
+	.long	9999b, 9001f;			\
+	.popsection
+
+	.macro	notcond, cond, nexti = .+8
+	.ifc	\cond, eq
+		bne	\nexti
+	.else;	.ifc	\cond, ne
+		beq	\nexti
+	.else;	.ifc	\cond, ea
+		bub	\nexti
+	.else;	.ifc	\cond, ub
+		bea	\nexti
+	.else;	.ifc	\cond, fs
+		bns	\nexti
+	.else;	.ifc	\cond, ns
+		bfs	\nexti
+	.else;	.ifc	\cond, fv
+		bnv	\nexti
+	.else;	.ifc	\cond, nv
+		bfv	\nexti
+	.else;	.ifc	\cond, ua
+		beb	\nexti
+	.else;	.ifc	\cond, eb
+		bua	\nexti
+	.else;	.ifc	\cond, eg
+		bsl	\nexti
+	.else;	.ifc	\cond, sl
+		beg	\nexti
+	.else;	.ifc	\cond, sg
+		bel	\nexti
+	.else;	.ifc	\cond, el
+		bsg	\nexti
+	.else;	.ifnc	\cond, al
+		.error  "Unknown cond in notcond macro argument"
+	.endif;	.endif;	.endif;	.endif;	.endif;	.endif;	.endif
+	.endif;	.endif;	.endif;	.endif;	.endif;	.endif;	.endif
+	.endif
+	.endm
+
+	.macro	usracc, instr, reg, ptr, inc, cond, rept, abort
+	.rept	\rept
+	notcond	\cond, .+8
+9999 :
+	.if	\inc == 1
+	\instr\()b.u \reg, [\ptr], #\inc
+	.elseif	\inc == 4
+	\instr\()w.u \reg, [\ptr], #\inc
+	.else
+	.error	"Unsupported inc macro argument"
+	.endif
+
+	.pushsection __ex_table, "a"
+	.align	3
+	.long	9999b, \abort
+	.popsection
+	.endr
+	.endm
+
+	.macro	strusr, reg, ptr, inc, cond = al, rept = 1, abort = 9001f
+	usracc	st, \reg, \ptr, \inc, \cond, \rept, \abort
+	.endm
+
+	.macro	ldrusr, reg, ptr, inc, cond = al, rept = 1, abort = 9001f
+	usracc	ld, \reg, \ptr, \inc, \cond, \rept, \abort
+	.endm
+
+	.macro	nop8
+	.rept	8
+		nop
+	.endr
+	.endm

