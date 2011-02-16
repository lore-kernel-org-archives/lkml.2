Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757607Ab1BPHti (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 02:49:38 -0500
Received: from mprc.pku.edu.cn ([162.105.203.9]:57517 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754710Ab1BPHte (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 02:49:34 -0500
From: "Guan Xuetao" <gxt@mprc.pku.edu.cn>
To: <linux-kernel@vger.kernel.org>, <linux-arch@vger.kernel.org>
Cc: "Arnd Bergmann" <arnd@arndb.de>, "'Greg KH'" <greg@kroah.com>
Subject: [PATCH 06/12] unicore32 additional architecture files: low-level lib: misc
Date: Wed, 16 Feb 2011 15:49:26 +0800
Message-ID: <014d01cbcdae$091bc6d0$1b535470$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AcvNrgJi0fVByNgqQOWXdZcsKtXtbA==
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Message-Id: <2fafabb6d6509fdb21e5a144a7045149372426db.1297842537.git.gxt@mprc.pku.edu.cn>
In-Reply-To: <cover.1297842537.git.gxt@mprc.pku.edu.cn>
References: <cover.1297842537.git.gxt@mprc.pku.edu.cn>
From: GuanXuetao <gxt@mprc.pku.edu.cn>
Date: Sat, 15 Jan 2011 18:23:09 +0800

This patch implements the rest low-level libraries.

Signed-off-by: Guan Xuetao <gxt@mprc.pku.edu.cn>
Acked-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/unicore32/include/asm/assembler.h |  131 +++++++++++++++++++++++++++++
 arch/unicore32/include/asm/bitops.h    |   47 +++++++++++
 arch/unicore32/include/asm/checksum.h  |   41 +++++++++
 arch/unicore32/include/asm/delay.h     |   52 ++++++++++++
 arch/unicore32/include/asm/futex.h     |  143 ++++++++++++++++++++++++++++++++
 arch/unicore32/include/asm/io.h        |   52 ++++++++++++
 arch/unicore32/include/asm/mutex.h     |   20 +++++
 arch/unicore32/lib/Makefile            |   27 ++++++
 arch/unicore32/lib/delay.S             |   51 +++++++++++
 arch/unicore32/lib/findbit.S           |   98 ++++++++++++++++++++++
 10 files changed, 662 insertions(+), 0 deletions(-)
 create mode 100644 arch/unicore32/include/asm/assembler.h
 create mode 100644 arch/unicore32/include/asm/bitops.h
 create mode 100644 arch/unicore32/include/asm/checksum.h
 create mode 100644 arch/unicore32/include/asm/delay.h
 create mode 100644 arch/unicore32/include/asm/futex.h
 create mode 100644 arch/unicore32/include/asm/io.h
 create mode 100644 arch/unicore32/include/asm/mutex.h
 create mode 100644 arch/unicore32/lib/Makefile
 create mode 100644 arch/unicore32/lib/delay.S
 create mode 100644 arch/unicore32/lib/findbit.S

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
diff --git a/arch/unicore32/include/asm/checksum.h b/arch/unicore32/include/asm/checksum.h
new file mode 100644
index 0000000..f55c3f9
--- /dev/null
+++ b/arch/unicore32/include/asm/checksum.h
@@ -0,0 +1,41 @@
+/*
+ * linux/arch/unicore32/include/asm/checksum.h
+ *
+ * Code specific to PKUnity SoC and UniCore ISA
+ *
+ * Copyright (C) 2001-2010 GUAN Xue-tao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * IP checksum routines
+ */
+#ifndef __UNICORE_CHECKSUM_H__
+#define __UNICORE_CHECKSUM_H__
+
+/*
+ * computes the checksum of the TCP/UDP pseudo-header
+ * returns a 16-bit checksum, already complemented
+ */
+
+static inline __wsum
+csum_tcpudp_nofold(__be32 saddr, __be32 daddr, unsigned short len,
+		   unsigned short proto, __wsum sum)
+{
+	__asm__(
+	"add.a	%0, %1, %2\n"
+	"addc.a	%0, %0, %3\n"
+	"addc.a	%0, %0, %4 << #8\n"
+	"addc.a	%0, %0, %5\n"
+	"addc	%0, %0, #0\n"
+	: "=&r"(sum)
+	: "r" (sum), "r" (daddr), "r" (saddr), "r" (len), "Ir" (htons(proto))
+	: "cc");
+	return sum;
+}
+#define csum_tcpudp_nofold	csum_tcpudp_nofold
+
+#include <asm-generic/checksum.h>
+
+#endif
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
diff --git a/arch/unicore32/include/asm/io.h b/arch/unicore32/include/asm/io.h
new file mode 100644
index 0000000..d73457c
--- /dev/null
+++ b/arch/unicore32/include/asm/io.h
@@ -0,0 +1,52 @@
+/*
+ * linux/arch/unicore32/include/asm/io.h
+ *
+ * Code specific to PKUnity SoC and UniCore ISA
+ *
+ * Copyright (C) 2001-2010 GUAN Xue-tao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#ifndef __UNICORE_IO_H__
+#define __UNICORE_IO_H__
+
+#ifdef __KERNEL__
+
+#include <asm/byteorder.h>
+#include <asm/memory.h>
+#include <asm/system.h>
+
+#include <asm-generic/io.h>
+
+/*
+ * __uc32_ioremap and __uc32_ioremap_cached takes CPU physical address.
+ */
+extern void __iomem *__uc32_ioremap(unsigned long, size_t);
+extern void __iomem *__uc32_ioremap_cached(unsigned long, size_t);
+extern void __uc32_iounmap(volatile void __iomem *addr);
+
+/*
+ * ioremap and friends.
+ *
+ * ioremap takes a PCI memory address, as specified in
+ * Documentation/IO-mapping.txt.
+ *
+ */
+#define ioremap(cookie, size)		__uc32_ioremap(cookie, size)
+#define ioremap_cached(cookie, size)	__uc32_ioremap_cached(cookie, size)
+#define iounmap(cookie)			__uc32_iounmap(cookie)
+
+extern void __iomem *ioport_map(unsigned long port, unsigned int nr);
+extern void ioport_unmap(void __iomem *addr);
+
+/*
+ * Convert a physical pointer to a virtual kernel pointer for /dev/mem
+ * access
+ */
+#undef xlate_dev_mem_ptr
+#define xlate_dev_mem_ptr(p)	__va(p)
+
+#endif	/* __KERNEL__ */
+#endif	/* __UNICORE_IO_H__ */
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
diff --git a/arch/unicore32/lib/Makefile b/arch/unicore32/lib/Makefile
new file mode 100644
index 0000000..87229a5
--- /dev/null
+++ b/arch/unicore32/lib/Makefile
@@ -0,0 +1,27 @@
+#
+# linux/arch/unicore32/lib/Makefile
+#
+# Copyright (C) 2001-2010 GUAN Xue-tao
+#
+
+lib-y	:= backtrace.o delay.o findbit.o
+lib-y	+= strncpy_from_user.o strnlen_user.o
+lib-y	+= clear_user.o copy_page.o
+lib-y	+= copy_from_user.o copy_to_user.o
+
+GNU_LIBC_A		:= $(shell $(CC) $(KBUILD_CFLAGS) -print-file-name=libc.a)
+GNU_LIBC_A_OBJS		:= memchr.o memcpy.o memmove.o memset.o
+GNU_LIBC_A_OBJS		+= strchr.o strrchr.o
+GNU_LIBC_A_OBJS		+= rawmemchr.o			# needed by strrchr.o
+
+GNU_LIBGCC_A		:= $(shell $(CC) $(KBUILD_CFLAGS) -print-file-name=libgcc.a)
+GNU_LIBGCC_A_OBJS	:= _ashldi3.o _ashrdi3.o _lshrdi3.o
+GNU_LIBGCC_A_OBJS	+= _divsi3.o _modsi3.o _ucmpdi2.o _umodsi3.o _udivsi3.o
+
+lib-y	+= $(GNU_LIBC_A_OBJS) $(GNU_LIBGCC_A_OBJS)
+
+$(addprefix $(obj)/, $(GNU_LIBC_A_OBJS)):
+	$(Q)$(AR) p $(GNU_LIBC_A) $(notdir $@) > $@
+
+$(addprefix $(obj)/, $(GNU_LIBGCC_A_OBJS)):
+	$(Q)$(AR) p $(GNU_LIBGCC_A) $(notdir $@) > $@
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
-- 
1.6.2.2


