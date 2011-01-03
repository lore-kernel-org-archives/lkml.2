Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754729Ab1ACLyn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 06:54:43 -0500
Received: from mprc.pku.edu.cn ([162.105.203.9]:48699 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753430Ab1ACLym (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 06:54:42 -0500
From: "Guan Xuetao" <guanxuetao@mprc.pku.edu.cn>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCHv1 8/8] unicore32 additional architecture files: low-level lib: misc
Date: Mon, 3 Jan 2011 19:54:41 +0800
Message-ID: <013301cbab3d$01698b40$043ca1c0$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AcurPPnj3DF5K3uoR4mFb1yccI/sJQ==
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Guan Xuetao <guanxuetao@mprc.pku.edu.cn>

Patch 8 implements the rest low-level libraries.

Signed-off-by: Guan Xuetao <guanxuetao@mprc.pku.edu.cn>
---
 arch/unicore32/include/asm/assembler.h |  131 +++++++++++++++++++++
 arch/unicore32/include/asm/bitops.h    |   47 ++++++++
 arch/unicore32/include/asm/delay.h     |   52 ++++++++
 arch/unicore32/include/asm/futex.h     |  143 +++++++++++++++++++++++
 arch/unicore32/include/asm/mutex.h     |   20 +++
 arch/unicore32/include/asm/swab.h      |   28 +++++
 arch/unicore32/lib/Makefile            |   16 +++
 arch/unicore32/lib/delay.S             |   51 ++++++++
 arch/unicore32/lib/findbit.S           |   98 ++++++++++++++++
 arch/unicore32/lib/sha1.S              |  200 ++++++++++++++++++++++++++++++++
 10 files changed, 786 insertions(+), 0 deletions(-)

diff --git a/arch/unicore32/include/asm/assembler.h b/arch/unicore32/include/asm/assembler.h
new file mode 100644
index 0000000..8e87ed7
--- /dev/null
+++ b/arch/unicore32/include/asm/assembler.h
@@ -0,0 +1,131 @@
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
+	.macro disable_irq, temp
+	mov	\temp, asr
+	andn     \temp, \temp, #0xFF
+	or	\temp, \temp, #PSR_I_BIT | PRIV_MODE
+	mov.a	asr, \temp
+	.endm
+
+	.macro enable_irq, temp
+	mov	\temp, asr
+	andn     \temp, \temp, #0xFF
+	or	\temp, \temp, #PRIV_MODE
+	mov.a	asr, \temp
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
diff --git a/arch/unicore32/include/asm/bitops.h b/arch/unicore32/include/asm/bitops.h
new file mode 100644
index 0000000..1628a63
--- /dev/null
+++ b/arch/unicore32/include/asm/bitops.h
@@ -0,0 +1,47 @@
+/*
+ * linux/arch/unicore32/include/asm/bitops.h
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
+#ifndef __UNICORE_BITOPS_H__
+#define __UNICORE_BITOPS_H__
+
+#define find_next_bit		__uc32_find_next_bit
+#define find_next_zero_bit	__uc32_find_next_zero_bit
+
+#define find_first_bit		__uc32_find_first_bit
+#define find_first_zero_bit	__uc32_find_first_zero_bit
+
+#define _ASM_GENERIC_BITOPS_FLS_H_
+#define _ASM_GENERIC_BITOPS___FLS_H_
+#define _ASM_GENERIC_BITOPS_FFS_H_
+#define _ASM_GENERIC_BITOPS___FFS_H_
+/*
+ * On UNICORE, those functions can be implemented around
+ * the cntlz instruction for much better code efficiency.
+ */
+
+static inline int fls(int x)
+{
+	int ret;
+
+	asm("cntlz\t%0, %1" : "=r" (ret) : "r" (x) : "cc");
+	ret = 32 - ret;
+
+	return ret;
+}
+
+#define __fls(x) (fls(x) - 1)
+#define ffs(x) ({ unsigned long __t = (x); fls(__t & -__t); })
+#define __ffs(x) (ffs(x) - 1)
+
+#include <asm-generic/bitops.h>
+
+#endif /* __UNICORE_BITOPS_H__ */
diff --git a/arch/unicore32/include/asm/delay.h b/arch/unicore32/include/asm/delay.h
new file mode 100644
index 0000000..164ae61
--- /dev/null
+++ b/arch/unicore32/include/asm/delay.h
@@ -0,0 +1,52 @@
+/*
+ * linux/arch/unicore32/include/asm/delay.h
+ *
+ * Code specific to PKUnity SoC and UniCore ISA
+ *
+ * Copyright (C) 2001-2010 GUAN Xue-tao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Delay routines, using a pre-computed "loops_per_second" value.
+ */
+#ifndef __UNICORE_DELAY_H__
+#define __UNICORE_DELAY_H__
+
+#include <asm/param.h>	/* HZ */
+
+extern void __delay(int loops);
+
+/*
+ * This function intentionally does not exist; if you see references to
+ * it, it means that you're calling udelay() with an out of range value.
+ *
+ * With currently imposed limits, this means that we support a max delay
+ * of 2000us. Further limits: HZ<=1000 and bogomips<=3355
+ */
+extern void __bad_udelay(void);
+
+/*
+ * division by multiplication: you don't have to worry about
+ * loss of precision.
+ *
+ * Use only for very small delays ( < 1 msec).  Should probably use a
+ * lookup table, really, as the multiplications take much too long with
+ * short delays.  This is a "reasonable" implementation, though (and the
+ * first constant multiplications gets optimized away if the delay is
+ * a constant)
+ */
+extern void __udelay(unsigned long usecs);
+extern void __const_udelay(unsigned long);
+
+#define MAX_UDELAY_MS 2
+
+#define udelay(n)							\
+	(__builtin_constant_p(n) ?					\
+	  ((n) > (MAX_UDELAY_MS * 1000) ? __bad_udelay() :		\
+			__const_udelay((n) * ((2199023U*HZ)>>11))) :	\
+	  __udelay(n))
+
+#endif /* __UNICORE_DELAY_H__ */
+
diff --git a/arch/unicore32/include/asm/futex.h b/arch/unicore32/include/asm/futex.h
new file mode 100644
index 0000000..07dea61
--- /dev/null
+++ b/arch/unicore32/include/asm/futex.h
@@ -0,0 +1,143 @@
+/*
+ * linux/arch/unicore32/include/asm/futex.h
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
+#ifndef __UNICORE_FUTEX_H__
+#define __UNICORE_FUTEX_H__
+
+#ifdef __KERNEL__
+
+#include <linux/futex.h>
+#include <linux/preempt.h>
+#include <linux/uaccess.h>
+#include <linux/errno.h>
+
+#define __futex_atomic_op(insn, ret, oldval, uaddr, oparg)	\
+	__asm__ __volatile__(					\
+	"1:	ldw.u	%1, [%2]\n"				\
+	"	" insn "\n"					\
+	"2:	stw.u	%0, [%2]\n"				\
+	"	mov	%0, #0\n"				\
+	"3:\n"							\
+	"	.pushsection __ex_table,\"a\"\n"		\
+	"	.align	3\n"					\
+	"	.long	1b, 4f, 2b, 4f\n"			\
+	"	.popsection\n"					\
+	"	.pushsection .fixup,\"ax\"\n"			\
+	"4:	mov	%0, %4\n"				\
+	"	b	3b\n"					\
+	"	.popsection"					\
+	: "=&r" (ret), "=&r" (oldval)				\
+	: "r" (uaddr), "r" (oparg), "Ir" (-EFAULT)		\
+	: "cc", "memory")
+
+static inline int
+futex_atomic_op_inuser(int encoded_op, int __user *uaddr)
+{
+	int op = (encoded_op >> 28) & 7;
+	int cmp = (encoded_op >> 24) & 15;
+	int oparg = (encoded_op << 8) >> 20;
+	int cmparg = (encoded_op << 20) >> 20;
+	int oldval = 0, ret;
+
+	if (encoded_op & (FUTEX_OP_OPARG_SHIFT << 28))
+		oparg = 1 << oparg;
+
+	if (!access_ok(VERIFY_WRITE, uaddr, sizeof(int)))
+		return -EFAULT;
+
+	pagefault_disable();	/* implies preempt_disable() */
+
+	switch (op) {
+	case FUTEX_OP_SET:
+		__futex_atomic_op("mov	%0, %3", ret, oldval, uaddr, oparg);
+		break;
+	case FUTEX_OP_ADD:
+		__futex_atomic_op("add	%0, %1, %3", ret, oldval, uaddr, oparg);
+		break;
+	case FUTEX_OP_OR:
+		__futex_atomic_op("or	%0, %1, %3", ret, oldval, uaddr, oparg);
+		break;
+	case FUTEX_OP_ANDN:
+		__futex_atomic_op("and	%0, %1, %3",
+				ret, oldval, uaddr, ~oparg);
+		break;
+	case FUTEX_OP_XOR:
+		__futex_atomic_op("xor	%0, %1, %3", ret, oldval, uaddr, oparg);
+		break;
+	default:
+		ret = -ENOSYS;
+	}
+
+	pagefault_enable();	/* subsumes preempt_enable() */
+
+	if (!ret) {
+		switch (cmp) {
+		case FUTEX_OP_CMP_EQ:
+			ret = (oldval == cmparg);
+			break;
+		case FUTEX_OP_CMP_NE:
+			ret = (oldval != cmparg);
+			break;
+		case FUTEX_OP_CMP_LT:
+			ret = (oldval <  cmparg);
+			break;
+		case FUTEX_OP_CMP_GE:
+			ret = (oldval >= cmparg);
+			break;
+		case FUTEX_OP_CMP_LE:
+			ret = (oldval <= cmparg);
+			break;
+		case FUTEX_OP_CMP_GT:
+			ret = (oldval >  cmparg);
+			break;
+		default:
+			ret = -ENOSYS;
+		}
+	}
+	return ret;
+}
+
+static inline int
+futex_atomic_cmpxchg_inatomic(int __user *uaddr, int oldval, int newval)
+{
+	int val;
+
+	if (!access_ok(VERIFY_WRITE, uaddr, sizeof(int)))
+		return -EFAULT;
+
+	pagefault_disable();	/* implies preempt_disable() */
+
+	__asm__ __volatile__("@futex_atomic_cmpxchg_inatomic\n"
+	"1:	ldw.u	%0, [%3]\n"
+	"	cmpxor.a	%0, %1\n"
+	"	bne	3f\n"
+	"2:	stw.u	%2, [%3]\n"
+	"3:\n"
+	"	.pushsection __ex_table,\"a\"\n"
+	"	.align	3\n"
+	"	.long	1b, 4f, 2b, 4f\n"
+	"	.popsection\n"
+	"	.pushsection .fixup,\"ax\"\n"
+	"4:	mov	%0, %4\n"
+	"	b	3b\n"
+	"	.popsection"
+	: "=&r" (val)
+	: "r" (oldval), "r" (newval), "r" (uaddr), "Ir" (-EFAULT)
+	: "cc", "memory");
+
+	pagefault_enable();	/* subsumes preempt_enable() */
+
+	return val;
+}
+
+#endif /* __KERNEL__ */
+#endif /* __UNICORE_FUTEX_H__ */
diff --git a/arch/unicore32/include/asm/mutex.h b/arch/unicore32/include/asm/mutex.h
new file mode 100644
index 0000000..fab7d0e
--- /dev/null
+++ b/arch/unicore32/include/asm/mutex.h
@@ -0,0 +1,20 @@
+/*
+ * linux/arch/unicore32/include/asm/mutex.h
+ *
+ * Code specific to PKUnity SoC and UniCore ISA
+ *
+ * Copyright (C) 2001-2010 GUAN Xue-tao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * UniCore optimized mutex locking primitives
+ *
+ * Please look into asm-generic/mutex-xchg.h for a formal definition.
+ */
+#ifndef __UNICORE_MUTEX_H__
+#define __UNICORE_MUTEX_H__
+
+# include <asm-generic/mutex-xchg.h>
+#endif
diff --git a/arch/unicore32/include/asm/swab.h b/arch/unicore32/include/asm/swab.h
new file mode 100644
index 0000000..8f0521f
--- /dev/null
+++ b/arch/unicore32/include/asm/swab.h
@@ -0,0 +1,28 @@
+/*
+ * linux/arch/unicore32/include/asm/swab.h
+ *
+ * Code specific to PKUnity SoC and UniCore ISA
+ *
+ * Copyright (C) 2001-2010 GUAN Xue-tao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * In little endian mode, the data bus is connected such
+ * that byte accesses appear as:
+ *  0 = d0...d7, 1 = d8...d15, 2 = d16...d23, 3 = d24...d31
+ * and word accesses (data or instruction) appear as:
+ *  d0...d31
+ */
+#ifndef __UNICORE_SWAB_H__
+#define __UNICORE_SWAB_H__
+
+#include <linux/compiler.h>
+#include <linux/types.h>
+#include <asm-generic/swab.h>
+
+#define __arch_swab32(x) __builtin_bswap32(x)
+
+#endif
+
diff --git a/arch/unicore32/lib/Makefile b/arch/unicore32/lib/Makefile
new file mode 100644
index 0000000..f96b55c
--- /dev/null
+++ b/arch/unicore32/lib/Makefile
@@ -0,0 +1,16 @@
+#
+# linux/arch/unicore32/lib/Makefile
+#
+# Copyright (C) 2001-2010 GUAN Xue-tao
+#
+
+lib-y	:= backtrace.o delay.o findbit.o sha1.o	\
+	csumipv6.o csumpartial.o csumpartialcopy.o csumpartialcopyuser.o \
+	strncpy_from_user.o strnlen_user.o 				\
+	io-readsb.o io-writesb.o io-readsl.o				\
+	io-writesl.o io-readsw.o io-writesw.o				\
+	clear_user.o copy_page.o getuser.o putuser.o			\
+	copy_from_user.o copy_to_user.o
+
+$(obj)/csumpartialcopy.o:	$(obj)/csumpartialcopygeneric.S
+$(obj)/csumpartialcopyuser.o:	$(obj)/csumpartialcopygeneric.S
diff --git a/arch/unicore32/lib/delay.S b/arch/unicore32/lib/delay.S
new file mode 100644
index 0000000..24664c0
--- /dev/null
+++ b/arch/unicore32/lib/delay.S
@@ -0,0 +1,51 @@
+/*
+ * linux/arch/unicore32/lib/delay.S
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
+#include <asm/param.h>
+		.text
+
+.LC0:		.word	loops_per_jiffy
+.LC1:		.word	(2199023*HZ)>>11
+
+/*
+ * r0  <= 2000
+ * lpj <= 0x01ffffff (max. 3355 bogomips)
+ * HZ  <= 1000
+ */
+
+ENTRY(__udelay)
+		ldw	r2, .LC1
+		mul	r0, r2, r0
+ENTRY(__const_udelay)				@ 0 <= r0 <= 0x7fffff06
+		ldw	r2, .LC0
+		ldw	r2, [r2]		@ max = 0x01ffffff
+		mov	r0, r0 >> #14		@ max = 0x0001ffff
+		mov	r2, r2 >> #10		@ max = 0x00007fff
+		mul	r0, r2, r0		@ max = 2^32-1
+		mov.a	r0, r0 >> #6
+		cmoveq	pc, lr
+
+/*
+ * loops = r0 * HZ * loops_per_jiffy / 1000000
+ *
+ * Oh, if only we had a cycle counter...
+ */
+
+@ Delay routine
+ENTRY(__delay)
+		sub.a	r0, r0, #2
+		bua	__delay
+		mov	pc, lr
+ENDPROC(__udelay)
+ENDPROC(__const_udelay)
+ENDPROC(__delay)
diff --git a/arch/unicore32/lib/findbit.S b/arch/unicore32/lib/findbit.S
new file mode 100644
index 0000000..c360ce9
--- /dev/null
+++ b/arch/unicore32/lib/findbit.S
@@ -0,0 +1,98 @@
+/*
+ * linux/arch/unicore32/lib/findbit.S
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
+                .text
+
+/*
+ * Purpose  : Find a 'zero' bit
+ * Prototype: int find_first_zero_bit(void *addr, unsigned int maxbit);
+ */
+__uc32_find_first_zero_bit:
+		cxor.a	r1, #0
+		beq	3f
+		mov	r2, #0
+1:		ldb	r3, [r0+], r2 >> #3
+		xor.a	r3, r3, #0xff		@ invert bits
+		bne	.L_found		@ any now set - found zero bit
+		add	r2, r2, #8		@ next bit pointer
+2:		csub.a	r2, r1			@ any more?
+		bub	1b
+3:		mov	r0, r1			@ no free bits
+		mov	pc, lr
+
+/*
+ * Purpose  : Find next 'zero' bit
+ * Prototype: int find_next_zero_bit
+ *		(void *addr, unsigned int maxbit, int offset)
+ */
+ENTRY(__uc32_find_next_zero_bit)
+		cxor.a	r1, #0
+		beq	3b
+		and.a	ip, r2, #7
+		beq	1b			@ If new byte, goto old routine
+		ldb	r3, [r0+], r2 >> #3
+		xor	r3, r3, #0xff		@ now looking for a 1 bit
+		mov.a	r3, r3 >> ip		@ shift off unused bits
+		bne	.L_found
+		or	r2, r2, #7		@ if zero, then no bits here
+		add	r2, r2, #1		@ align bit pointer
+		b	2b			@ loop for next bit
+ENDPROC(__uc32_find_next_zero_bit)
+
+/*
+ * Purpose  : Find a 'one' bit
+ * Prototype: int find_first_bit
+ *		(const unsigned long *addr, unsigned int maxbit);
+ */
+__uc32_find_first_bit:
+		cxor.a	r1, #0
+		beq	3f
+		mov	r2, #0
+1:		ldb	r3, [r0+], r2 >> #3
+		mov.a	r3, r3
+		bne	.L_found		@ any now set - found zero bit
+		add	r2, r2, #8		@ next bit pointer
+2:		csub.a	r2, r1			@ any more?
+		bub	1b
+3:		mov	r0, r1			@ no free bits
+		mov	pc, lr
+
+/*
+ * Purpose  : Find next 'one' bit
+ * Prototype: int find_next_zero_bit
+ *		(void *addr, unsigned int maxbit, int offset)
+ */
+ENTRY(__uc32_find_next_bit)
+		cxor.a	r1, #0
+		beq	3b
+		and.a	ip, r2, #7
+		beq	1b			@ If new byte, goto old routine
+		ldb	r3, [r0+], r2 >> #3
+		mov.a	r3, r3 >> ip		@ shift off unused bits
+		bne	.L_found
+		or	r2, r2, #7		@ if zero, then no bits here
+		add	r2, r2, #1		@ align bit pointer
+		b	2b			@ loop for next bit
+ENDPROC(__uc32_find_next_bit)
+
+/*
+ * One or more bits in the LSB of r3 are assumed to be set.
+ */
+.L_found:
+		rsub	r1, r3, #0
+		and	r3, r3, r1
+		cntlz	r3, r3
+		rsub	r3, r3, #31
+		add	r0, r2, r3
+		mov	pc, lr
+
diff --git a/arch/unicore32/lib/sha1.S b/arch/unicore32/lib/sha1.S
new file mode 100644
index 0000000..0c50895
--- /dev/null
+++ b/arch/unicore32/lib/sha1.S
@@ -0,0 +1,200 @@
+/*
+ * linux/arch/unicore32/lib/sha1.S
+ *
+ * Code specific to PKUnity SoC and UniCore ISA
+ *
+ * Copyright (C) 2001-2010 GUAN Xue-tao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ *  The reference implementation for this code is linux/lib/sha1.c
+ */
+
+#include <linux/linkage.h>
+
+	.text
+
+
+/*
+ * void sha_transform(__u32 *digest, const char *in, __u32 *W)
+ *
+ * Note: the "in" ptr may be unaligned.
+ */
+
+ENTRY(sha_transform)
+
+	stm.w	(lr), [sp-]
+
+	@ for (i = 0; i < 16; i++)
+	@         W[i] = be32_to_cpu(in[i]);
+
+	mov	r3, r2
+	mov	lr, #16
+1:	ldb.w	r4, [r1]+, #1
+	ldb.w	r5, [r1]+, #1
+	ldb.w	r6, [r1]+, #1
+	ldb.w	r7, [r1]+, #1
+	sub.a	lr, lr, #1
+	or	r5, r5, r4 << #8
+	or	r6, r6, r5 << #8
+	or	r7, r7, r6 << #8
+	stw.w	r7, [r3]+, #4
+	bne	1b
+
+	@ for (i = 0; i < 64; i++)
+	@         W[i+16] = ror(W[i+13] ^ W[i+8] ^ W[i+2] ^ W[i], 31);
+
+	sub	r3, r2, #4
+	mov	lr, #64
+2:	ldw.w	r4, [r3+], #4
+	sub.a	lr, lr, #1
+	ldw	r5, [r3+], #8
+	ldw	r6, [r3+], #32
+	ldw	r7, [r3+], #52
+	xor	r4, r4, r5
+	xor	r4, r4, r6
+	xor	r4, r4, r7
+	mov	r4, r4 <> #31
+	stw	r4, [r3+], #64
+	bne	2b
+
+	/*
+	 * The SHA functions are:
+	 *
+	 * f1(B,C,D) = (D ^ (B & (C ^ D)))
+	 * f2(B,C,D) = (B ^ C ^ D)
+	 * f3(B,C,D) = ((B & C) | (D & (B | C)))
+	 *
+	 * Then the sub-blocks are processed as follows:
+	 *
+	 * A' = ror(A, 27) + f(B,C,D) + E + K + *W++
+	 * B' = A
+	 * C' = ror(B, 2)
+	 * D' = C
+	 * E' = D
+	 *
+	 * We therefore unroll each loop 5 times to avoid register shuffling.
+	 * Also the ror for C (and also D and E which are successivelyderived
+	 * from it) is applied in place to cut on an additional mov insn for
+	 * each round.
+	 */
+
+	.macro	sha_f1, A, B, C, D, E
+	ldw.w	r3, [r2]+, #4
+	xor	ip, \C, \D
+	add	\E, r1, \E <> #2
+	and	ip, \B, ip <> #2
+	add	\E, \E, \A <> #27
+	xor	ip, ip, \D <> #2
+	add	\E, \E, r3
+	add	\E, \E, ip
+	.endm
+
+	.macro	sha_f2, A, B, C, D, E
+	ldw.w	r3, [r2]+, #4
+	add	\E, r1, \E <> #2
+	xor	ip, \B, \C <> #2
+	add	\E, \E, \A <> #27
+	xor	ip, ip, \D <> #2
+	add	\E, \E, r3
+	add	\E, \E, ip
+	.endm
+
+	.macro	sha_f3, A, B, C, D, E
+	ldw.w	r3, [r2]+, #4
+	add	\E, r1, \E <> #2
+	or	ip, \B, \C <> #2
+	add	\E, \E, \A <> #27
+	and	ip, ip, \D <> #2
+	add	\E, \E, r3
+	and	r3, \B, \C <> #2
+	or	ip, ip, r3
+	add	\E, \E, ip
+	.endm
+
+	ldm	(r4 - r8), [r0]+
+
+	mov	lr, #4
+	ldw	r1, .L_sha_K + 0
+
+	/* adjust initial values */
+	mov	r6, r6 <> #30
+	mov	r7, r7 <> #30
+	mov	r8, r8 <> #30
+
+3:	sub.a	lr, lr, #1
+	sha_f1	r4, r5, r6, r7, r8
+	sha_f1	r8, r4, r5, r6, r7
+	sha_f1	r7, r8, r4, r5, r6
+	sha_f1	r6, r7, r8, r4, r5
+	sha_f1	r5, r6, r7, r8, r4
+	bne	3b
+
+	ldw	r1, .L_sha_K + 4
+	mov	lr, #4
+
+4:	sub.a	lr, lr, #1
+	sha_f2	r4, r5, r6, r7, r8
+	sha_f2	r8, r4, r5, r6, r7
+	sha_f2	r7, r8, r4, r5, r6
+	sha_f2	r6, r7, r8, r4, r5
+	sha_f2	r5, r6, r7, r8, r4
+	bne	4b
+
+	ldw	r1, .L_sha_K + 8
+	mov	lr, #4
+
+5:	sub.a	lr, lr, #1
+	sha_f3	r4, r5, r6, r7, r8
+	sha_f3	r8, r4, r5, r6, r7
+	sha_f3	r7, r8, r4, r5, r6
+	sha_f3	r6, r7, r8, r4, r5
+	sha_f3	r5, r6, r7, r8, r4
+	bne	5b
+
+	ldw	r1, .L_sha_K + 12
+	mov	lr, #4
+
+6:	sub.a	lr, lr, #1
+	sha_f2	r4, r5, r6, r7, r8
+	sha_f2	r8, r4, r5, r6, r7
+	sha_f2	r7, r8, r4, r5, r6
+	sha_f2	r6, r7, r8, r4, r5
+	sha_f2	r5, r6, r7, r8, r4
+	bne	6b
+
+	ldm	(r1, r2, r3, r9, r10), [r0]+
+	add	r4, r1, r4
+	add	r5, r2, r5
+	add	r6, r3, r6 <> #2
+	add	r7, r9, r7 <> #2
+	add	r8, r10, r8 <> #2
+	stm	(r4 - r8), [r0]+
+
+	ldm.w	(pc), [sp]+
+
+ENDPROC(sha_transform)
+
+	.align	2
+.L_sha_K:
+	.word	0x5a827999, 0x6ed9eba1, 0x8f1bbcdc, 0xca62c1d6
+
+
+/*
+ * void sha_init(__u32 *buf)
+ */
+
+	.align	2
+.L_sha_initial_digest:
+	.word	0x67452301, 0xefcdab89, 0x98badcfe, 0x10325476, 0xc3d2e1f0
+
+ENTRY(sha_init)
+
+	adr	r1, .L_sha_initial_digest
+	ldm	(r1 - r5), [r1]+
+	stm	(r1 - r5), [r0]+
+	mov	pc, lr
+
+ENDPROC(sha_init)

