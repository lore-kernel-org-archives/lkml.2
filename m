Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964899Ab2CLXir (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 19:38:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52561 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758145Ab2CLXim (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 19:38:42 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 12/35] Disintegrate asm/system.h for M32R [ver #2]
To: paul.gortmaker@windriver.com, hpa@zytor.com
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, arnd@arndb.de,
        David Howells <dhowells@redhat.com>, linux-m32r@ml.linux-m32r.org
Date: Mon, 12 Mar 2012 23:38:06 +0000
Message-ID: <20120312233806.13888.25985.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120312233602.13888.27659.stgit@warthog.procyon.org.uk>
References: <20120312233602.13888.27659.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Disintegrate asm/system.h for M32R.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: linux-m32r@ml.linux-m32r.org
---

 arch/m32r/include/asm/atomic.h       |    3 
 arch/m32r/include/asm/barrier.h      |   94 +++++++++
 arch/m32r/include/asm/bitops.h       |    3 
 arch/m32r/include/asm/cmpxchg.h      |  221 ++++++++++++++++++++
 arch/m32r/include/asm/dcache_clear.h |   29 +++
 arch/m32r/include/asm/exec.h         |   14 +
 arch/m32r/include/asm/local.h        |    1 
 arch/m32r/include/asm/spinlock.h     |    1 
 arch/m32r/include/asm/switch_to.h    |   51 +++++
 arch/m32r/include/asm/system.h       |  373 +---------------------------------
 arch/m32r/kernel/ptrace.c            |    1 
 arch/m32r/kernel/traps.c             |    1 
 arch/m32r/mm/fault-nommu.c           |    1 
 arch/m32r/mm/fault.c                 |    1 
 arch/m32r/platforms/m32104ut/setup.c |    1 
 arch/m32r/platforms/m32700ut/setup.c |    1 
 arch/m32r/platforms/mappi/setup.c    |    1 
 arch/m32r/platforms/mappi2/setup.c   |    1 
 arch/m32r/platforms/mappi3/setup.c   |    1 
 arch/m32r/platforms/oaks32r/setup.c  |    1 
 arch/m32r/platforms/opsput/setup.c   |    1 
 arch/m32r/platforms/usrv/setup.c     |    1 
 22 files changed, 420 insertions(+), 382 deletions(-)
 create mode 100644 arch/m32r/include/asm/barrier.h
 create mode 100644 arch/m32r/include/asm/cmpxchg.h
 create mode 100644 arch/m32r/include/asm/dcache_clear.h
 create mode 100644 arch/m32r/include/asm/exec.h
 create mode 100644 arch/m32r/include/asm/switch_to.h

diff --git a/arch/m32r/include/asm/atomic.h b/arch/m32r/include/asm/atomic.h
index 1e7f29f..0d81697 100644
--- a/arch/m32r/include/asm/atomic.h
+++ b/arch/m32r/include/asm/atomic.h
@@ -11,7 +11,8 @@
 
 #include <linux/types.h>
 #include <asm/assembler.h>
-#include <asm/system.h>
+#include <asm/cmpxchg.h>
+#include <asm/dcache_clear.h>
 
 /*
  * Atomic operations that C can't guarantee us.  Useful for
diff --git a/arch/m32r/include/asm/barrier.h b/arch/m32r/include/asm/barrier.h
new file mode 100644
index 0000000..6976621
--- /dev/null
+++ b/arch/m32r/include/asm/barrier.h
@@ -0,0 +1,94 @@
+/*
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2001  Hiroyuki Kondo, Hirokazu Takata, and Hitoshi Yamamoto
+ * Copyright (C) 2004, 2006  Hirokazu Takata <takata at linux-m32r.org>
+ */
+#ifndef _ASM_M32R_BARRIER_H
+#define _ASM_M32R_BARRIER_H
+
+#define nop()  __asm__ __volatile__ ("nop" : : )
+
+/*
+ * Memory barrier.
+ *
+ * mb() prevents loads and stores being reordered across this point.
+ * rmb() prevents loads being reordered across this point.
+ * wmb() prevents stores being reordered across this point.
+ */
+#define mb()   barrier()
+#define rmb()  mb()
+#define wmb()  mb()
+
+/**
+ * read_barrier_depends - Flush all pending reads that subsequents reads
+ * depend on.
+ *
+ * No data-dependent reads from memory-like regions are ever reordered
+ * over this barrier.  All reads preceding this primitive are guaranteed
+ * to access memory (but not necessarily other CPUs' caches) before any
+ * reads following this primitive that depend on the data return by
+ * any of the preceding reads.  This primitive is much lighter weight than
+ * rmb() on most CPUs, and is never heavier weight than is
+ * rmb().
+ *
+ * These ordering constraints are respected by both the local CPU
+ * and the compiler.
+ *
+ * Ordering is not guaranteed by anything other than these primitives,
+ * not even by data dependencies.  See the documentation for
+ * memory_barrier() for examples and URLs to more information.
+ *
+ * For example, the following code would force ordering (the initial
+ * value of "a" is zero, "b" is one, and "p" is "&a"):
+ *
+ * <programlisting>
+ *      CPU 0                           CPU 1
+ *
+ *      b = 2;
+ *      memory_barrier();
+ *      p = &b;                         q = p;
+ *                                      read_barrier_depends();
+ *                                      d = *q;
+ * </programlisting>
+ *
+ *
+ * because the read of "*q" depends on the read of "p" and these
+ * two reads are separated by a read_barrier_depends().  However,
+ * the following code, with the same initial values for "a" and "b":
+ *
+ * <programlisting>
+ *      CPU 0                           CPU 1
+ *
+ *      a = 2;
+ *      memory_barrier();
+ *      b = 3;                          y = b;
+ *                                      read_barrier_depends();
+ *                                      x = a;
+ * </programlisting>
+ *
+ * does not enforce ordering, since there is no data dependency between
+ * the read of "a" and the read of "b".  Therefore, on some CPUs, such
+ * as Alpha, "y" could be set to 3 and "x" to 0.  Use rmb()
+ * in cases like this where there are no data dependencies.
+ **/
+
+#define read_barrier_depends()	do { } while (0)
+
+#ifdef CONFIG_SMP
+#define smp_mb()	mb()
+#define smp_rmb()	rmb()
+#define smp_wmb()	wmb()
+#define smp_read_barrier_depends()	read_barrier_depends()
+#define set_mb(var, value) do { (void) xchg(&var, value); } while (0)
+#else
+#define smp_mb()	barrier()
+#define smp_rmb()	barrier()
+#define smp_wmb()	barrier()
+#define smp_read_barrier_depends()	do { } while (0)
+#define set_mb(var, value) do { var = value; barrier(); } while (0)
+#endif
+
+#endif /* _ASM_M32R_BARRIER_H */
diff --git a/arch/m32r/include/asm/bitops.h b/arch/m32r/include/asm/bitops.h
index 6300f22..d3dea9a 100644
--- a/arch/m32r/include/asm/bitops.h
+++ b/arch/m32r/include/asm/bitops.h
@@ -16,9 +16,10 @@
 #endif
 
 #include <linux/compiler.h>
+#include <linux/irqflags.h>
 #include <asm/assembler.h>
-#include <asm/system.h>
 #include <asm/byteorder.h>
+#include <asm/dcache_clear.h>
 #include <asm/types.h>
 
 /*
diff --git a/arch/m32r/include/asm/cmpxchg.h b/arch/m32r/include/asm/cmpxchg.h
new file mode 100644
index 0000000..de651db
--- /dev/null
+++ b/arch/m32r/include/asm/cmpxchg.h
@@ -0,0 +1,221 @@
+#ifndef _ASM_M32R_CMPXCHG_H
+#define _ASM_M32R_CMPXCHG_H
+
+/*
+ *  M32R version:
+ *    Copyright (C) 2001, 2002  Hitoshi Yamamoto
+ *    Copyright (C) 2004  Hirokazu Takata <takata at linux-m32r.org>
+ */
+
+#include <linux/irqflags.h>
+#include <asm/assembler.h>
+#include <asm/dcache_clear.h>
+
+extern void  __xchg_called_with_bad_pointer(void);
+
+static __always_inline unsigned long
+__xchg(unsigned long x, volatile void *ptr, int size)
+{
+	unsigned long flags;
+	unsigned long tmp = 0;
+
+	local_irq_save(flags);
+
+	switch (size) {
+#ifndef CONFIG_SMP
+	case 1:
+		__asm__ __volatile__ (
+			"ldb	%0, @%2 \n\t"
+			"stb	%1, @%2 \n\t"
+			: "=&r" (tmp) : "r" (x), "r" (ptr) : "memory");
+		break;
+	case 2:
+		__asm__ __volatile__ (
+			"ldh	%0, @%2 \n\t"
+			"sth	%1, @%2 \n\t"
+			: "=&r" (tmp) : "r" (x), "r" (ptr) : "memory");
+		break;
+	case 4:
+		__asm__ __volatile__ (
+			"ld	%0, @%2 \n\t"
+			"st	%1, @%2 \n\t"
+			: "=&r" (tmp) : "r" (x), "r" (ptr) : "memory");
+		break;
+#else  /* CONFIG_SMP */
+	case 4:
+		__asm__ __volatile__ (
+			DCACHE_CLEAR("%0", "r4", "%2")
+			"lock	%0, @%2;	\n\t"
+			"unlock	%1, @%2;	\n\t"
+			: "=&r" (tmp) : "r" (x), "r" (ptr)
+			: "memory"
+#ifdef CONFIG_CHIP_M32700_TS1
+			, "r4"
+#endif	/* CONFIG_CHIP_M32700_TS1 */
+		);
+		break;
+#endif  /* CONFIG_SMP */
+	default:
+		__xchg_called_with_bad_pointer();
+	}
+
+	local_irq_restore(flags);
+
+	return (tmp);
+}
+
+#define xchg(ptr, x)							\
+	((__typeof__(*(ptr)))__xchg((unsigned long)(x), (ptr), sizeof(*(ptr))))
+
+static __always_inline unsigned long
+__xchg_local(unsigned long x, volatile void *ptr, int size)
+{
+	unsigned long flags;
+	unsigned long tmp = 0;
+
+	local_irq_save(flags);
+
+	switch (size) {
+	case 1:
+		__asm__ __volatile__ (
+			"ldb	%0, @%2 \n\t"
+			"stb	%1, @%2 \n\t"
+			: "=&r" (tmp) : "r" (x), "r" (ptr) : "memory");
+		break;
+	case 2:
+		__asm__ __volatile__ (
+			"ldh	%0, @%2 \n\t"
+			"sth	%1, @%2 \n\t"
+			: "=&r" (tmp) : "r" (x), "r" (ptr) : "memory");
+		break;
+	case 4:
+		__asm__ __volatile__ (
+			"ld	%0, @%2 \n\t"
+			"st	%1, @%2 \n\t"
+			: "=&r" (tmp) : "r" (x), "r" (ptr) : "memory");
+		break;
+	default:
+		__xchg_called_with_bad_pointer();
+	}
+
+	local_irq_restore(flags);
+
+	return (tmp);
+}
+
+#define xchg_local(ptr, x)						\
+	((__typeof__(*(ptr)))__xchg_local((unsigned long)(x), (ptr),	\
+			sizeof(*(ptr))))
+
+#define __HAVE_ARCH_CMPXCHG	1
+
+static inline unsigned long
+__cmpxchg_u32(volatile unsigned int *p, unsigned int old, unsigned int new)
+{
+	unsigned long flags;
+	unsigned int retval;
+
+	local_irq_save(flags);
+	__asm__ __volatile__ (
+			DCACHE_CLEAR("%0", "r4", "%1")
+			M32R_LOCK" %0, @%1;	\n"
+		"	bne	%0, %2, 1f;	\n"
+			M32R_UNLOCK" %3, @%1;	\n"
+		"	bra	2f;		\n"
+                "       .fillinsn		\n"
+		"1:"
+			M32R_UNLOCK" %0, @%1;	\n"
+                "       .fillinsn		\n"
+		"2:"
+			: "=&r" (retval)
+			: "r" (p), "r" (old), "r" (new)
+			: "cbit", "memory"
+#ifdef CONFIG_CHIP_M32700_TS1
+			, "r4"
+#endif  /* CONFIG_CHIP_M32700_TS1 */
+		);
+	local_irq_restore(flags);
+
+	return retval;
+}
+
+static inline unsigned long
+__cmpxchg_local_u32(volatile unsigned int *p, unsigned int old,
+			unsigned int new)
+{
+	unsigned long flags;
+	unsigned int retval;
+
+	local_irq_save(flags);
+	__asm__ __volatile__ (
+			DCACHE_CLEAR("%0", "r4", "%1")
+			"ld %0, @%1;		\n"
+		"	bne	%0, %2, 1f;	\n"
+			"st %3, @%1;		\n"
+		"	bra	2f;		\n"
+		"       .fillinsn		\n"
+		"1:"
+			"st %0, @%1;		\n"
+		"       .fillinsn		\n"
+		"2:"
+			: "=&r" (retval)
+			: "r" (p), "r" (old), "r" (new)
+			: "cbit", "memory"
+#ifdef CONFIG_CHIP_M32700_TS1
+			, "r4"
+#endif  /* CONFIG_CHIP_M32700_TS1 */
+		);
+	local_irq_restore(flags);
+
+	return retval;
+}
+
+/* This function doesn't exist, so you'll get a linker error
+   if something tries to do an invalid cmpxchg().  */
+extern void __cmpxchg_called_with_bad_pointer(void);
+
+static inline unsigned long
+__cmpxchg(volatile void *ptr, unsigned long old, unsigned long new, int size)
+{
+	switch (size) {
+	case 4:
+		return __cmpxchg_u32(ptr, old, new);
+#if 0	/* we don't have __cmpxchg_u64 */
+	case 8:
+		return __cmpxchg_u64(ptr, old, new);
+#endif /* 0 */
+	}
+	__cmpxchg_called_with_bad_pointer();
+	return old;
+}
+
+#define cmpxchg(ptr, o, n)						 \
+	((__typeof__(*(ptr))) __cmpxchg((ptr), (unsigned long)(o),	 \
+			(unsigned long)(n), sizeof(*(ptr))))
+
+#include <asm-generic/cmpxchg-local.h>
+
+static inline unsigned long __cmpxchg_local(volatile void *ptr,
+				      unsigned long old,
+				      unsigned long new, int size)
+{
+	switch (size) {
+	case 4:
+		return __cmpxchg_local_u32(ptr, old, new);
+	default:
+		return __cmpxchg_local_generic(ptr, old, new, size);
+	}
+
+	return old;
+}
+
+/*
+ * cmpxchg_local and cmpxchg64_local are atomic wrt current CPU. Always make
+ * them available.
+ */
+#define cmpxchg_local(ptr, o, n)				  	    \
+	((__typeof__(*(ptr)))__cmpxchg_local((ptr), (unsigned long)(o),	    \
+			(unsigned long)(n), sizeof(*(ptr))))
+#define cmpxchg64_local(ptr, o, n) __cmpxchg64_local_generic((ptr), (o), (n))
+
+#endif /* _ASM_M32R_CMPXCHG_H */
diff --git a/arch/m32r/include/asm/dcache_clear.h b/arch/m32r/include/asm/dcache_clear.h
new file mode 100644
index 0000000..a0ae06c
--- /dev/null
+++ b/arch/m32r/include/asm/dcache_clear.h
@@ -0,0 +1,29 @@
+/*
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2001  Hiroyuki Kondo, Hirokazu Takata, and Hitoshi Yamamoto
+ * Copyright (C) 2004, 2006  Hirokazu Takata <takata at linux-m32r.org>
+ */
+#ifndef _ASM_M32R_DCACHE_CLEAR_H
+#define _ASM_M32R_DCACHE_CLEAR_H
+
+#ifdef CONFIG_CHIP_M32700_TS1
+#define DCACHE_CLEAR(reg0, reg1, addr)				\
+	"seth	"reg1", #high(dcache_dummy);		\n\t"	\
+	"or3	"reg1", "reg1", #low(dcache_dummy);	\n\t"	\
+	"lock	"reg0", @"reg1";			\n\t"	\
+	"add3	"reg0", "addr", #0x1000;		\n\t"	\
+	"ld	"reg0", @"reg0";			\n\t"	\
+	"add3	"reg0", "addr", #0x2000;		\n\t"	\
+	"ld	"reg0", @"reg0";			\n\t"	\
+	"unlock	"reg0", @"reg1";			\n\t"
+	/* FIXME: This workaround code cannot handle kernel modules
+	 * correctly under SMP environment.
+	 */
+#else	/* CONFIG_CHIP_M32700_TS1 */
+#define DCACHE_CLEAR(reg0, reg1, addr)
+#endif	/* CONFIG_CHIP_M32700_TS1 */
+
+#endif /* _ASM_M32R_DCACHE_CLEAR_H */
diff --git a/arch/m32r/include/asm/exec.h b/arch/m32r/include/asm/exec.h
new file mode 100644
index 0000000..c805dbd
--- /dev/null
+++ b/arch/m32r/include/asm/exec.h
@@ -0,0 +1,14 @@
+/*
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2001  Hiroyuki Kondo, Hirokazu Takata, and Hitoshi Yamamoto
+ * Copyright (C) 2004, 2006  Hirokazu Takata <takata at linux-m32r.org>
+ */
+#ifndef _ASM_M32R_EXEC_H
+#define _ASM_M32R_EXEC_H
+
+#define arch_align_stack(x) (x)
+
+#endif /* _ASM_M32R_EXEC_H */
diff --git a/arch/m32r/include/asm/local.h b/arch/m32r/include/asm/local.h
index 734bca8..4045db3 100644
--- a/arch/m32r/include/asm/local.h
+++ b/arch/m32r/include/asm/local.h
@@ -12,7 +12,6 @@
 
 #include <linux/percpu.h>
 #include <asm/assembler.h>
-#include <asm/system.h>
 #include <asm/local.h>
 
 /*
diff --git a/arch/m32r/include/asm/spinlock.h b/arch/m32r/include/asm/spinlock.h
index b0ea2f2..fa13694 100644
--- a/arch/m32r/include/asm/spinlock.h
+++ b/arch/m32r/include/asm/spinlock.h
@@ -11,6 +11,7 @@
 
 #include <linux/compiler.h>
 #include <linux/atomic.h>
+#include <asm/dcache_clear.h>
 #include <asm/page.h>
 
 /*
diff --git a/arch/m32r/include/asm/switch_to.h b/arch/m32r/include/asm/switch_to.h
new file mode 100644
index 0000000..4b262f7
--- /dev/null
+++ b/arch/m32r/include/asm/switch_to.h
@@ -0,0 +1,51 @@
+/*
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2001  Hiroyuki Kondo, Hirokazu Takata, and Hitoshi Yamamoto
+ * Copyright (C) 2004, 2006  Hirokazu Takata <takata at linux-m32r.org>
+ */
+#ifndef _ASM_M32R_SWITCH_TO_H
+#define _ASM_M32R_SWITCH_TO_H
+
+/*
+ * switch_to(prev, next) should switch from task `prev' to `next'
+ * `prev' will never be the same as `next'.
+ *
+ * `next' and `prev' should be struct task_struct, but it isn't always defined
+ */
+
+#if defined(CONFIG_FRAME_POINTER) || \
+	!defined(CONFIG_SCHED_OMIT_FRAME_POINTER)
+#define M32R_PUSH_FP "	push fp\n"
+#define M32R_POP_FP  "	pop  fp\n"
+#else
+#define M32R_PUSH_FP ""
+#define M32R_POP_FP  ""
+#endif
+
+#define switch_to(prev, next, last)  do { \
+	__asm__ __volatile__ ( \
+		"	seth	lr, #high(1f)				\n" \
+		"	or3	lr, lr, #low(1f)			\n" \
+		"	st	lr, @%4  ; store old LR			\n" \
+		"	ld	lr, @%5  ; load new LR			\n" \
+			M32R_PUSH_FP \
+		"	st	sp, @%2  ; store old SP			\n" \
+		"	ld	sp, @%3  ; load new SP			\n" \
+		"	push	%1  ; store `prev' on new stack		\n" \
+		"	jmp	lr					\n" \
+		"	.fillinsn					\n" \
+		"1:							\n" \
+		"	pop	%0  ; restore `__last' from new stack	\n" \
+			M32R_POP_FP \
+		: "=r" (last) \
+		: "0" (prev), \
+		  "r" (&(prev->thread.sp)), "r" (&(next->thread.sp)), \
+		  "r" (&(prev->thread.lr)), "r" (&(next->thread.lr)) \
+		: "memory", "lr" \
+	); \
+} while(0)
+
+#endif /* _ASM_M32R_SWITCH_TO_H */
diff --git a/arch/m32r/include/asm/system.h b/arch/m32r/include/asm/system.h
index 13c4679..a55c384 100644
--- a/arch/m32r/include/asm/system.h
+++ b/arch/m32r/include/asm/system.h
@@ -1,367 +1,6 @@
-#ifndef _ASM_M32R_SYSTEM_H
-#define _ASM_M32R_SYSTEM_H
-
-/*
- * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file "COPYING" in the main directory of this archive
- * for more details.
- *
- * Copyright (C) 2001  Hiroyuki Kondo, Hirokazu Takata, and Hitoshi Yamamoto
- * Copyright (C) 2004, 2006  Hirokazu Takata <takata at linux-m32r.org>
- */
-
-#include <linux/compiler.h>
-#include <linux/irqflags.h>
-#include <asm/assembler.h>
-
-#ifdef __KERNEL__
-
-/*
- * switch_to(prev, next) should switch from task `prev' to `next'
- * `prev' will never be the same as `next'.
- *
- * `next' and `prev' should be struct task_struct, but it isn't always defined
- */
-
-#if defined(CONFIG_FRAME_POINTER) || \
-	!defined(CONFIG_SCHED_OMIT_FRAME_POINTER)
-#define M32R_PUSH_FP "	push fp\n"
-#define M32R_POP_FP  "	pop  fp\n"
-#else
-#define M32R_PUSH_FP ""
-#define M32R_POP_FP  ""
-#endif
-
-#define switch_to(prev, next, last)  do { \
-	__asm__ __volatile__ ( \
-		"	seth	lr, #high(1f)				\n" \
-		"	or3	lr, lr, #low(1f)			\n" \
-		"	st	lr, @%4  ; store old LR			\n" \
-		"	ld	lr, @%5  ; load new LR			\n" \
-			M32R_PUSH_FP \
-		"	st	sp, @%2  ; store old SP			\n" \
-		"	ld	sp, @%3  ; load new SP			\n" \
-		"	push	%1  ; store `prev' on new stack		\n" \
-		"	jmp	lr					\n" \
-		"	.fillinsn					\n" \
-		"1:							\n" \
-		"	pop	%0  ; restore `__last' from new stack	\n" \
-			M32R_POP_FP \
-		: "=r" (last) \
-		: "0" (prev), \
-		  "r" (&(prev->thread.sp)), "r" (&(next->thread.sp)), \
-		  "r" (&(prev->thread.lr)), "r" (&(next->thread.lr)) \
-		: "memory", "lr" \
-	); \
-} while(0)
-
-#define nop()	__asm__ __volatile__ ("nop" : : )
-
-#define xchg(ptr, x)							\
-	((__typeof__(*(ptr)))__xchg((unsigned long)(x), (ptr), sizeof(*(ptr))))
-#define xchg_local(ptr, x)						\
-	((__typeof__(*(ptr)))__xchg_local((unsigned long)(x), (ptr),	\
-			sizeof(*(ptr))))
-
-extern void  __xchg_called_with_bad_pointer(void);
-
-#ifdef CONFIG_CHIP_M32700_TS1
-#define DCACHE_CLEAR(reg0, reg1, addr)				\
-	"seth	"reg1", #high(dcache_dummy);		\n\t"	\
-	"or3	"reg1", "reg1", #low(dcache_dummy);	\n\t"	\
-	"lock	"reg0", @"reg1";			\n\t"	\
-	"add3	"reg0", "addr", #0x1000;		\n\t"	\
-	"ld	"reg0", @"reg0";			\n\t"	\
-	"add3	"reg0", "addr", #0x2000;		\n\t"	\
-	"ld	"reg0", @"reg0";			\n\t"	\
-	"unlock	"reg0", @"reg1";			\n\t"
-	/* FIXME: This workaround code cannot handle kernel modules
-	 * correctly under SMP environment.
-	 */
-#else	/* CONFIG_CHIP_M32700_TS1 */
-#define DCACHE_CLEAR(reg0, reg1, addr)
-#endif	/* CONFIG_CHIP_M32700_TS1 */
-
-static __always_inline unsigned long
-__xchg(unsigned long x, volatile void *ptr, int size)
-{
-	unsigned long flags;
-	unsigned long tmp = 0;
-
-	local_irq_save(flags);
-
-	switch (size) {
-#ifndef CONFIG_SMP
-	case 1:
-		__asm__ __volatile__ (
-			"ldb	%0, @%2 \n\t"
-			"stb	%1, @%2 \n\t"
-			: "=&r" (tmp) : "r" (x), "r" (ptr) : "memory");
-		break;
-	case 2:
-		__asm__ __volatile__ (
-			"ldh	%0, @%2 \n\t"
-			"sth	%1, @%2 \n\t"
-			: "=&r" (tmp) : "r" (x), "r" (ptr) : "memory");
-		break;
-	case 4:
-		__asm__ __volatile__ (
-			"ld	%0, @%2 \n\t"
-			"st	%1, @%2 \n\t"
-			: "=&r" (tmp) : "r" (x), "r" (ptr) : "memory");
-		break;
-#else  /* CONFIG_SMP */
-	case 4:
-		__asm__ __volatile__ (
-			DCACHE_CLEAR("%0", "r4", "%2")
-			"lock	%0, @%2;	\n\t"
-			"unlock	%1, @%2;	\n\t"
-			: "=&r" (tmp) : "r" (x), "r" (ptr)
-			: "memory"
-#ifdef CONFIG_CHIP_M32700_TS1
-			, "r4"
-#endif	/* CONFIG_CHIP_M32700_TS1 */
-		);
-		break;
-#endif  /* CONFIG_SMP */
-	default:
-		__xchg_called_with_bad_pointer();
-	}
-
-	local_irq_restore(flags);
-
-	return (tmp);
-}
-
-static __always_inline unsigned long
-__xchg_local(unsigned long x, volatile void *ptr, int size)
-{
-	unsigned long flags;
-	unsigned long tmp = 0;
-
-	local_irq_save(flags);
-
-	switch (size) {
-	case 1:
-		__asm__ __volatile__ (
-			"ldb	%0, @%2 \n\t"
-			"stb	%1, @%2 \n\t"
-			: "=&r" (tmp) : "r" (x), "r" (ptr) : "memory");
-		break;
-	case 2:
-		__asm__ __volatile__ (
-			"ldh	%0, @%2 \n\t"
-			"sth	%1, @%2 \n\t"
-			: "=&r" (tmp) : "r" (x), "r" (ptr) : "memory");
-		break;
-	case 4:
-		__asm__ __volatile__ (
-			"ld	%0, @%2 \n\t"
-			"st	%1, @%2 \n\t"
-			: "=&r" (tmp) : "r" (x), "r" (ptr) : "memory");
-		break;
-	default:
-		__xchg_called_with_bad_pointer();
-	}
-
-	local_irq_restore(flags);
-
-	return (tmp);
-}
-
-#define __HAVE_ARCH_CMPXCHG	1
-
-static inline unsigned long
-__cmpxchg_u32(volatile unsigned int *p, unsigned int old, unsigned int new)
-{
-	unsigned long flags;
-	unsigned int retval;
-
-	local_irq_save(flags);
-	__asm__ __volatile__ (
-			DCACHE_CLEAR("%0", "r4", "%1")
-			M32R_LOCK" %0, @%1;	\n"
-		"	bne	%0, %2, 1f;	\n"
-			M32R_UNLOCK" %3, @%1;	\n"
-		"	bra	2f;		\n"
-                "       .fillinsn		\n"
-		"1:"
-			M32R_UNLOCK" %0, @%1;	\n"
-                "       .fillinsn		\n"
-		"2:"
-			: "=&r" (retval)
-			: "r" (p), "r" (old), "r" (new)
-			: "cbit", "memory"
-#ifdef CONFIG_CHIP_M32700_TS1
-			, "r4"
-#endif  /* CONFIG_CHIP_M32700_TS1 */
-		);
-	local_irq_restore(flags);
-
-	return retval;
-}
-
-static inline unsigned long
-__cmpxchg_local_u32(volatile unsigned int *p, unsigned int old,
-			unsigned int new)
-{
-	unsigned long flags;
-	unsigned int retval;
-
-	local_irq_save(flags);
-	__asm__ __volatile__ (
-			DCACHE_CLEAR("%0", "r4", "%1")
-			"ld %0, @%1;		\n"
-		"	bne	%0, %2, 1f;	\n"
-			"st %3, @%1;		\n"
-		"	bra	2f;		\n"
-		"       .fillinsn		\n"
-		"1:"
-			"st %0, @%1;		\n"
-		"       .fillinsn		\n"
-		"2:"
-			: "=&r" (retval)
-			: "r" (p), "r" (old), "r" (new)
-			: "cbit", "memory"
-#ifdef CONFIG_CHIP_M32700_TS1
-			, "r4"
-#endif  /* CONFIG_CHIP_M32700_TS1 */
-		);
-	local_irq_restore(flags);
-
-	return retval;
-}
-
-/* This function doesn't exist, so you'll get a linker error
-   if something tries to do an invalid cmpxchg().  */
-extern void __cmpxchg_called_with_bad_pointer(void);
-
-static inline unsigned long
-__cmpxchg(volatile void *ptr, unsigned long old, unsigned long new, int size)
-{
-	switch (size) {
-	case 4:
-		return __cmpxchg_u32(ptr, old, new);
-#if 0	/* we don't have __cmpxchg_u64 */
-	case 8:
-		return __cmpxchg_u64(ptr, old, new);
-#endif /* 0 */
-	}
-	__cmpxchg_called_with_bad_pointer();
-	return old;
-}
-
-#define cmpxchg(ptr, o, n)						 \
-	((__typeof__(*(ptr))) __cmpxchg((ptr), (unsigned long)(o),	 \
-			(unsigned long)(n), sizeof(*(ptr))))
-
-#include <asm-generic/cmpxchg-local.h>
-
-static inline unsigned long __cmpxchg_local(volatile void *ptr,
-				      unsigned long old,
-				      unsigned long new, int size)
-{
-	switch (size) {
-	case 4:
-		return __cmpxchg_local_u32(ptr, old, new);
-	default:
-		return __cmpxchg_local_generic(ptr, old, new, size);
-	}
-
-	return old;
-}
-
-/*
- * cmpxchg_local and cmpxchg64_local are atomic wrt current CPU. Always make
- * them available.
- */
-#define cmpxchg_local(ptr, o, n)				  	    \
-	((__typeof__(*(ptr)))__cmpxchg_local((ptr), (unsigned long)(o),	    \
-			(unsigned long)(n), sizeof(*(ptr))))
-#define cmpxchg64_local(ptr, o, n) __cmpxchg64_local_generic((ptr), (o), (n))
-
-#endif  /* __KERNEL__ */
-
-/*
- * Memory barrier.
- *
- * mb() prevents loads and stores being reordered across this point.
- * rmb() prevents loads being reordered across this point.
- * wmb() prevents stores being reordered across this point.
- */
-#define mb()   barrier()
-#define rmb()  mb()
-#define wmb()  mb()
-
-/**
- * read_barrier_depends - Flush all pending reads that subsequents reads
- * depend on.
- *
- * No data-dependent reads from memory-like regions are ever reordered
- * over this barrier.  All reads preceding this primitive are guaranteed
- * to access memory (but not necessarily other CPUs' caches) before any
- * reads following this primitive that depend on the data return by
- * any of the preceding reads.  This primitive is much lighter weight than
- * rmb() on most CPUs, and is never heavier weight than is
- * rmb().
- *
- * These ordering constraints are respected by both the local CPU
- * and the compiler.
- *
- * Ordering is not guaranteed by anything other than these primitives,
- * not even by data dependencies.  See the documentation for
- * memory_barrier() for examples and URLs to more information.
- *
- * For example, the following code would force ordering (the initial
- * value of "a" is zero, "b" is one, and "p" is "&a"):
- *
- * <programlisting>
- *      CPU 0                           CPU 1
- *
- *      b = 2;
- *      memory_barrier();
- *      p = &b;                         q = p;
- *                                      read_barrier_depends();
- *                                      d = *q;
- * </programlisting>
- *
- *
- * because the read of "*q" depends on the read of "p" and these
- * two reads are separated by a read_barrier_depends().  However,
- * the following code, with the same initial values for "a" and "b":
- *
- * <programlisting>
- *      CPU 0                           CPU 1
- *
- *      a = 2;
- *      memory_barrier();
- *      b = 3;                          y = b;
- *                                      read_barrier_depends();
- *                                      x = a;
- * </programlisting>
- *
- * does not enforce ordering, since there is no data dependency between
- * the read of "a" and the read of "b".  Therefore, on some CPUs, such
- * as Alpha, "y" could be set to 3 and "x" to 0.  Use rmb()
- * in cases like this where there are no data dependencies.
- **/
-
-#define read_barrier_depends()	do { } while (0)
-
-#ifdef CONFIG_SMP
-#define smp_mb()	mb()
-#define smp_rmb()	rmb()
-#define smp_wmb()	wmb()
-#define smp_read_barrier_depends()	read_barrier_depends()
-#define set_mb(var, value) do { (void) xchg(&var, value); } while (0)
-#else
-#define smp_mb()	barrier()
-#define smp_rmb()	barrier()
-#define smp_wmb()	barrier()
-#define smp_read_barrier_depends()	do { } while (0)
-#define set_mb(var, value) do { var = value; barrier(); } while (0)
-#endif
-
-#define arch_align_stack(x) (x)
-
-#endif /* _ASM_M32R_SYSTEM_H */
+/* FILE TO BE DELETED. DO NOT ADD STUFF HERE! */
+#include <asm/barrier.h>
+#include <asm/cmpxchg.h>
+#include <asm/dcache_clear.h>
+#include <asm/exec.h>
+#include <asm/switch_to.h>
diff --git a/arch/m32r/kernel/ptrace.c b/arch/m32r/kernel/ptrace.c
index 2074375..4c03361 100644
--- a/arch/m32r/kernel/ptrace.c
+++ b/arch/m32r/kernel/ptrace.c
@@ -29,7 +29,6 @@
 #include <asm/io.h>
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
-#include <asm/system.h>
 #include <asm/processor.h>
 #include <asm/mmu_context.h>
 
diff --git a/arch/m32r/kernel/traps.c b/arch/m32r/kernel/traps.c
index ee6a919..3bcb207 100644
--- a/arch/m32r/kernel/traps.c
+++ b/arch/m32r/kernel/traps.c
@@ -18,7 +18,6 @@
 #include <asm/page.h>
 #include <asm/processor.h>
 
-#include <asm/system.h>
 #include <asm/uaccess.h>
 #include <asm/io.h>
 #include <linux/atomic.h>
diff --git a/arch/m32r/mm/fault-nommu.c b/arch/m32r/mm/fault-nommu.c
index 888aab1..80f18cc 100644
--- a/arch/m32r/mm/fault-nommu.c
+++ b/arch/m32r/mm/fault-nommu.c
@@ -22,7 +22,6 @@
 #include <linux/vt_kern.h>              /* For unblank_screen() */
 
 #include <asm/m32r.h>
-#include <asm/system.h>
 #include <asm/uaccess.h>
 #include <asm/pgalloc.h>
 #include <asm/pgtable.h>
diff --git a/arch/m32r/mm/fault.c b/arch/m32r/mm/fault.c
index 2c9aeb4..3cdfa9c 100644
--- a/arch/m32r/mm/fault.c
+++ b/arch/m32r/mm/fault.c
@@ -26,7 +26,6 @@
 #include <linux/module.h>
 
 #include <asm/m32r.h>
-#include <asm/system.h>
 #include <asm/uaccess.h>
 #include <asm/hardirq.h>
 #include <asm/mmu_context.h>
diff --git a/arch/m32r/platforms/m32104ut/setup.c b/arch/m32r/platforms/m32104ut/setup.c
index 34671d3..e2dd778 100644
--- a/arch/m32r/platforms/m32104ut/setup.c
+++ b/arch/m32r/platforms/m32104ut/setup.c
@@ -13,7 +13,6 @@
 #include <linux/init.h>
 #include <linux/device.h>
 
-#include <asm/system.h>
 #include <asm/m32r.h>
 #include <asm/io.h>
 
diff --git a/arch/m32r/platforms/m32700ut/setup.c b/arch/m32r/platforms/m32700ut/setup.c
index 1053e1c..9a4ba8a 100644
--- a/arch/m32r/platforms/m32700ut/setup.c
+++ b/arch/m32r/platforms/m32700ut/setup.c
@@ -16,7 +16,6 @@
 #include <linux/init.h>
 #include <linux/platform_device.h>
 
-#include <asm/system.h>
 #include <asm/m32r.h>
 #include <asm/io.h>
 
diff --git a/arch/m32r/platforms/mappi/setup.c b/arch/m32r/platforms/mappi/setup.c
index 35130ac..767d2f4 100644
--- a/arch/m32r/platforms/mappi/setup.c
+++ b/arch/m32r/platforms/mappi/setup.c
@@ -12,7 +12,6 @@
 #include <linux/init.h>
 #include <linux/platform_device.h>
 
-#include <asm/system.h>
 #include <asm/m32r.h>
 #include <asm/io.h>
 
diff --git a/arch/m32r/platforms/mappi2/setup.c b/arch/m32r/platforms/mappi2/setup.c
index f3ed6b6..76d665a 100644
--- a/arch/m32r/platforms/mappi2/setup.c
+++ b/arch/m32r/platforms/mappi2/setup.c
@@ -12,7 +12,6 @@
 #include <linux/init.h>
 #include <linux/platform_device.h>
 
-#include <asm/system.h>
 #include <asm/m32r.h>
 #include <asm/io.h>
 
diff --git a/arch/m32r/platforms/mappi3/setup.c b/arch/m32r/platforms/mappi3/setup.c
index 2408e35..a3646d4 100644
--- a/arch/m32r/platforms/mappi3/setup.c
+++ b/arch/m32r/platforms/mappi3/setup.c
@@ -12,7 +12,6 @@
 #include <linux/init.h>
 #include <linux/platform_device.h>
 
-#include <asm/system.h>
 #include <asm/m32r.h>
 #include <asm/io.h>
 
diff --git a/arch/m32r/platforms/oaks32r/setup.c b/arch/m32r/platforms/oaks32r/setup.c
index 83b46b0..f8373c0 100644
--- a/arch/m32r/platforms/oaks32r/setup.c
+++ b/arch/m32r/platforms/oaks32r/setup.c
@@ -11,7 +11,6 @@
 #include <linux/kernel.h>
 #include <linux/init.h>
 
-#include <asm/system.h>
 #include <asm/m32r.h>
 #include <asm/io.h>
 
diff --git a/arch/m32r/platforms/opsput/setup.c b/arch/m32r/platforms/opsput/setup.c
index 3266070..cd01704 100644
--- a/arch/m32r/platforms/opsput/setup.c
+++ b/arch/m32r/platforms/opsput/setup.c
@@ -17,7 +17,6 @@
 #include <linux/init.h>
 #include <linux/platform_device.h>
 
-#include <asm/system.h>
 #include <asm/m32r.h>
 #include <asm/io.h>
 
diff --git a/arch/m32r/platforms/usrv/setup.c b/arch/m32r/platforms/usrv/setup.c
index 0c7a1e8..dcde0ec 100644
--- a/arch/m32r/platforms/usrv/setup.c
+++ b/arch/m32r/platforms/usrv/setup.c
@@ -11,7 +11,6 @@
 #include <linux/kernel.h>
 #include <linux/init.h>
 
-#include <asm/system.h>
 #include <asm/m32r.h>
 #include <asm/io.h>
 

