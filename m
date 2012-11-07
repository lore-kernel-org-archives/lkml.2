Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754282Ab2KGJyW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 04:54:22 -0500
Received: from us01smtp2.synopsys.com ([198.182.44.80]:58037 "EHLO
	kiruna.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753881Ab2KGJsR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 04:48:17 -0500
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, arnd@arndb.de,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: [RFC PATCH v1 03/31] ARC: atomic/bitops/cmpxchg/barriers
Date: Wed,  7 Nov 2012 10:47:26 +0100
Message-Id: <1352281674-2186-4-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1352281674-2186-1-git-send-email-vgupta@synopsys.com>
References: <1352281674-2186-1-git-send-email-vgupta@synopsys.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This covers the UP / SMP (with no hardware assist for atomic r-m-w) as
well as ARC700 LLOCK/SCOND insns based.

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
---
 arch/arc/include/asm/atomic.h  |  232 ++++++++++++++++++
 arch/arc/include/asm/barrier.h |   42 ++++
 arch/arc/include/asm/bitops.h  |  507 ++++++++++++++++++++++++++++++++++++++++
 arch/arc/include/asm/cmpxchg.h |  143 +++++++++++
 arch/arc/include/asm/smp.h     |   34 +++
 5 files changed, 958 insertions(+), 0 deletions(-)
 create mode 100644 arch/arc/include/asm/atomic.h
 create mode 100644 arch/arc/include/asm/barrier.h
 create mode 100644 arch/arc/include/asm/bitops.h
 create mode 100644 arch/arc/include/asm/cmpxchg.h
 create mode 100644 arch/arc/include/asm/smp.h

diff --git a/arch/arc/include/asm/atomic.h b/arch/arc/include/asm/atomic.h
new file mode 100644
index 0000000..543d496
--- /dev/null
+++ b/arch/arc/include/asm/atomic.h
@@ -0,0 +1,232 @@
+/*
+ * Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef _ASM_ARC_ATOMIC_H
+#define _ASM_ARC_ATOMIC_H
+
+#if defined(__KERNEL__)
+
+#if !defined(__ASSEMBLY__)
+
+#include <linux/types.h>
+#include <linux/compiler.h>
+#include <asm/cmpxchg.h>
+#include <asm/barrier.h>
+#include <asm/smp.h>
+
+#define atomic_read(v)  ((v)->counter)
+
+#ifdef CONFIG_ARC_HAS_LLSC
+
+#define atomic_set(v, i) (((v)->counter) = (i))
+
+static inline void atomic_add(int i, atomic_t *v)
+{
+	unsigned int temp;
+
+	__asm__ __volatile__(
+	"1:	llock   %0, [%1]	\n"
+	"	add     %0, %0, %2	\n"
+	"	scond   %0, [%1]	\n"
+	"	bnz     1b		\n"
+	: "=&r"(temp)	/* Early clobber, to prevent reg reuse */
+	: "r"(&v->counter), "ir"(i)
+	: "cc");
+}
+
+static inline void atomic_sub(int i, atomic_t *v)
+{
+	unsigned int temp;
+
+	__asm__ __volatile__(
+	"1:	llock   %0, [%1]	\n"
+	"	sub     %0, %0, %2	\n"
+	"	scond   %0, [%1]	\n"
+	"	bnz     1b		\n"
+	: "=&r"(temp)
+	: "r"(&v->counter), "ir"(i)
+	: "cc");
+}
+
+/* add and also return the new value */
+static inline int atomic_add_return(int i, atomic_t *v)
+{
+	unsigned int temp;
+
+	__asm__ __volatile__(
+	"1:	llock   %0, [%1]	\n"
+	"	add     %0, %0, %2	\n"
+	"	scond   %0, [%1]	\n"
+	"	bnz     1b		\n"
+	: "=&r"(temp)
+	: "r"(&v->counter), "ir"(i)
+	: "cc");
+
+	return temp;
+}
+
+static inline int atomic_sub_return(int i, atomic_t *v)
+{
+	unsigned int temp;
+
+	__asm__ __volatile__(
+	"1:	llock   %0, [%1]	\n"
+	"	sub     %0, %0, %2	\n"
+	"	scond   %0, [%1]	\n"
+	"	bnz     1b		\n"
+	: "=&r"(temp)
+	: "r"(&v->counter), "ir"(i)
+	: "cc");
+
+	return temp;
+}
+
+static inline void atomic_clear_mask(unsigned long mask, unsigned long *addr)
+{
+	unsigned int temp;
+
+	__asm__ __volatile__(
+	"1:	llock   %0, [%1]	\n"
+	"	bic     %0, %0, %2	\n"
+	"	scond   %0, [%1]	\n"
+	"	bnz     1b		\n"
+	: "=&r"(temp)
+	: "r"(addr), "ir"(mask)
+	: "cc");
+}
+
+#else	/* !CONFIG_ARC_HAS_LLSC */
+
+#ifndef CONFIG_SMP
+
+ /* violating atomic_xxx API locking protocol in UP for optimization sake */
+#define atomic_set(v, i) (((v)->counter) = (i))
+
+#else
+
+static inline void atomic_set(atomic_t *v, int i)
+{
+	/*
+	 * Independent of hardware support, all of the atomic_xxx() APIs need
+	 * to follow the same locking rules to make sure that a "hardware"
+	 * atomic insn (e.g. LD) doesn't clobber an "emulated" atomic insn
+	 * sequence
+	 *
+	 * Thus atomic_set() despite being 1 insn (and seemingly atomic)
+	 * requires the locking.
+	 */
+	unsigned long flags;
+
+	atomic_ops_lock(flags);
+	v->counter = i;
+	atomic_ops_unlock(flags);
+}
+#endif
+
+/*
+ * Non hardware assisted Atomic-R-M-W
+ * Locking would change to irq-disabling only (UP) and spinlocks (SMP)
+ */
+
+static inline void atomic_add(int i, atomic_t *v)
+{
+	unsigned long flags;
+
+	atomic_ops_lock(flags);
+	v->counter += i;
+	atomic_ops_unlock(flags);
+}
+
+static inline void atomic_sub(int i, atomic_t *v)
+{
+	unsigned long flags;
+
+	atomic_ops_lock(flags);
+	v->counter -= i;
+	atomic_ops_unlock(flags);
+}
+
+static inline int atomic_add_return(int i, atomic_t *v)
+{
+	unsigned long flags;
+	unsigned long temp;
+
+	atomic_ops_lock(flags);
+	temp = v->counter;
+	temp += i;
+	v->counter = temp;
+	atomic_ops_unlock(flags);
+
+	return temp;
+}
+
+static inline int atomic_sub_return(int i, atomic_t *v)
+{
+	unsigned long flags;
+	unsigned long temp;
+
+	atomic_ops_lock(flags);
+	temp = v->counter;
+	temp -= i;
+	v->counter = temp;
+	atomic_ops_unlock(flags);
+
+	return temp;
+}
+
+static inline void atomic_clear_mask(unsigned long mask, unsigned long *addr)
+{
+	unsigned long flags;
+
+	atomic_ops_lock(flags);
+	*addr &= ~mask;
+	atomic_ops_unlock(flags);
+}
+
+#endif /* !CONFIG_ARC_HAS_LLSC */
+
+/**
+ * __atomic_add_unless - add unless the number is a given value
+ * @v: pointer of type atomic_t
+ * @a: the amount to add to v...
+ * @u: ...unless v is equal to u.
+ *
+ * Atomically adds @a to @v, so long as it was not @u.
+ * Returns the old value of @v
+ */
+#define __atomic_add_unless(v, a, u)					\
+({									\
+	int c, old;							\
+	c = atomic_read(v);						\
+	while (c != (u) && (old = atomic_cmpxchg((v), c, c + (a))) != c)\
+		c = old;						\
+	c;								\
+})
+
+#define atomic_inc_not_zero(v)		atomic_add_unless((v), 1, 0)
+
+#define atomic_inc(v)			atomic_add(1, v)
+#define atomic_dec(v)			atomic_sub(1, v)
+
+#define atomic_inc_and_test(v)		(atomic_add_return(1, v) == 0)
+#define atomic_dec_and_test(v)		(atomic_sub_return(1, v) == 0)
+#define atomic_inc_return(v)		atomic_add_return(1, (v))
+#define atomic_dec_return(v)		atomic_sub_return(1, (v))
+#define atomic_sub_and_test(i, v)	(atomic_sub_return(i, v) == 0)
+
+#define atomic_add_negative(i, v)	(atomic_add_return(i, v) < 0)
+
+#define ATOMIC_INIT(i)			{ (i) }
+
+#include <asm-generic/atomic64.h>
+
+#endif
+
+#endif
+
+#endif
diff --git a/arch/arc/include/asm/barrier.h b/arch/arc/include/asm/barrier.h
new file mode 100644
index 0000000..f6cb7c4
--- /dev/null
+++ b/arch/arc/include/asm/barrier.h
@@ -0,0 +1,42 @@
+/*
+ * Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef __ASM_BARRIER_H
+#define __ASM_BARRIER_H
+
+#ifndef __ASSEMBLY__
+
+/* TODO-vineetg: Need to see what this does, don't we need sync anywhere */
+#define mb() __asm__ __volatile__ ("" : : : "memory")
+#define rmb() mb()
+#define wmb() mb()
+#define set_mb(var, value)  do { var = value; mb(); } while (0)
+#define set_wmb(var, value) do { var = value; wmb(); } while (0)
+#define read_barrier_depends()  mb()
+
+/* TODO-vineetg verify the correctness of macros here */
+#ifdef CONFIG_SMP
+#define smp_mb()        mb()
+#define smp_rmb()       rmb()
+#define smp_wmb()       wmb()
+#else
+#define smp_mb()        barrier()
+#define smp_rmb()       barrier()
+#define smp_wmb()       barrier()
+#endif
+
+#define smp_mb__before_atomic_dec()	barrier()
+#define smp_mb__after_atomic_dec()	barrier()
+#define smp_mb__before_atomic_inc()	barrier()
+#define smp_mb__after_atomic_inc()	barrier()
+
+#define smp_read_barrier_depends()      do { } while (0)
+
+#endif
+
+#endif
diff --git a/arch/arc/include/asm/bitops.h b/arch/arc/include/asm/bitops.h
new file mode 100644
index 0000000..51cffcc
--- /dev/null
+++ b/arch/arc/include/asm/bitops.h
@@ -0,0 +1,507 @@
+/*
+ * Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef _ASM_BITOPS_H
+#define _ASM_BITOPS_H
+
+#ifndef _LINUX_BITOPS_H
+#error only <linux/bitops.h> can be included directly
+#endif
+
+#if defined(__KERNEL__)
+
+#if !defined(__ASSEMBLY__)
+
+#include <linux/types.h>
+#include <linux/compiler.h>
+
+/*
+ * Hardware assisted read-modify-write using ARC700 LLOCK/SCOND insns.
+ * The Kconfig glue ensures that in SMP, this is only set if the container
+ * SoC/platform has cross-core coherent LLOCK/SCOND
+ */
+#if defined(CONFIG_ARC_HAS_LLSC)
+
+static inline void set_bit(unsigned long nr, volatile unsigned long *m)
+{
+	unsigned int temp;
+
+	m += nr >> 5;
+
+	__asm__ __volatile__(
+	"1:	llock   %0, [%1]	\n"
+	"	bset    %0, %0, %2	\n"
+	"	scond   %0, [%1]	\n"
+	"	bnz     1b	\n"
+	: "=&r"(temp)
+	: "r"(m), "ir"(nr)
+	: "cc");
+}
+
+static inline void clear_bit(unsigned long nr, volatile unsigned long *m)
+{
+	unsigned int temp;
+
+	m += nr >> 5;
+
+	__asm__ __volatile__(
+	"1:	llock   %0, [%1]	\n"
+	"	bclr    %0, %0, %2	\n"
+	"	scond   %0, [%1]	\n"
+	"	bnz     1b	\n"
+	: "=&r"(temp)
+	: "r"(m), "ir"(nr)
+	: "cc");
+}
+
+static inline void change_bit(unsigned long nr, volatile unsigned long *m)
+{
+	unsigned int temp;
+
+	m += nr >> 5;
+
+	__asm__ __volatile__(
+	"1:	llock   %0, [%1]	\n"
+	"	bxor    %0, %0, %2	\n"
+	"	scond   %0, [%1]	\n"
+	"	bnz     1b		\n"
+	: "=&r"(temp)
+	: "r"(m), "ir"(nr)
+	: "cc");
+}
+
+/*
+ * Semantically:
+ *    Test the bit
+ *    if clear
+ *        set it and return 0 (old value)
+ *    else
+ *        return 1 (old value).
+ *
+ * Since ARC lacks a equivalent h/w primitive, the bit is set unconditionally
+ * and the old value of bit is returned
+ */
+static inline int test_and_set_bit(unsigned long nr, volatile unsigned long *m)
+{
+	unsigned long old, temp;
+
+	m += nr >> 5;
+
+	__asm__ __volatile__(
+	"1:	llock   %0, [%2]	\n"
+	"	bset    %1, %0, %3	\n"
+	"	scond   %1, [%2]	\n"
+	"	bnz     1b		\n"
+	: "=&r"(old), "=&r"(temp)
+	: "r"(m), "ir"(nr)
+	: "cc");
+
+	if (__builtin_constant_p(nr))
+		nr &= 0x1f;
+
+	return (old & (1 << nr)) != 0;
+}
+
+static inline int
+test_and_clear_bit(unsigned long nr, volatile unsigned long *m)
+{
+	unsigned int old, temp;
+
+	m += nr >> 5;
+
+	__asm__ __volatile__(
+	"1:	llock   %0, [%2]	\n"
+	"	bclr    %1, %0, %3	\n"
+	"	scond   %1, [%2]	\n"
+	"	bnz     1b		\n"
+	: "=&r"(old), "=&r"(temp)
+	: "r"(m), "ir"(nr)
+	: "cc");
+
+	if (__builtin_constant_p(nr))
+		nr &= 0x1f;
+
+	return (old & (1 << nr)) != 0;
+}
+
+static inline int
+test_and_change_bit(unsigned long nr, volatile unsigned long *m)
+{
+	unsigned int old, temp;
+
+	m += nr >> 5;
+
+	__asm__ __volatile__(
+	"1:	llock   %0, [%2]	\n"
+	"	bxor    %1, %0, %3	\n"
+	"	scond   %1, [%2]	\n"
+	"	bnz     1b		\n"
+	: "=&r"(old), "=&r"(temp)
+	: "r"(m), "ir"(nr)
+	: "cc");
+
+	if (__builtin_constant_p(nr))
+		nr &= 0x1f;
+
+	return (old & (1 << nr)) != 0;
+}
+
+#else	/* !CONFIG_ARC_HAS_LLSC */
+
+#include <asm/smp.h>
+
+/*
+ * Non hardware assisted Atomic-R-M-W
+ * Locking would change to irq-disabling only (UP) and spinlocks (SMP)
+ *
+ * There's "significant" micro-optimization in writing our own variants of
+ * bitops (over generic variants)
+ *
+ * (1) The generic APIs have "signed" @nr while we have it "unsigned"
+ *     This avoids extra code to be generated for pointer arithmatic, since
+ *     is "not sure" that index is NOT -ve
+ * (2) Utilize the fact that ARCompact bit fidding insn (BSET/BCLR/ASL) etc
+ *     only consider bottom 5 bits of @nr, so NO need to mask them off.
+ *     (GCC Quirk: however for constant @nr we still need to do the masking
+ *             at compile time)
+ */
+
+static inline void set_bit(unsigned long nr, volatile unsigned long *m)
+{
+	unsigned long temp, flags;
+	m += nr >> 5;
+
+	if (__builtin_constant_p(nr))
+		nr &= 0x1f;
+
+	bitops_lock(flags);
+
+	temp = *m;
+	*m = temp | (1UL << nr);
+
+	bitops_unlock(flags);
+}
+
+static inline void clear_bit(unsigned long nr, volatile unsigned long *m)
+{
+	unsigned long temp, flags;
+	m += nr >> 5;
+
+	if (__builtin_constant_p(nr))
+		nr &= 0x1f;
+
+	bitops_lock(flags);
+
+	temp = *m;
+	*m = temp & ~(1UL << nr);
+
+	bitops_unlock(flags);
+}
+
+static inline void change_bit(unsigned long nr, volatile unsigned long *m)
+{
+	unsigned long temp, flags;
+	m += nr >> 5;
+
+	if (__builtin_constant_p(nr))
+		nr &= 0x1f;
+
+	bitops_lock(flags);
+
+	temp = *m;
+	*m = temp ^ (1UL << nr);
+
+	bitops_unlock(flags);
+}
+
+static inline int test_and_set_bit(unsigned long nr, volatile unsigned long *m)
+{
+	unsigned long old, flags;
+	m += nr >> 5;
+
+	if (__builtin_constant_p(nr))
+		nr &= 0x1f;
+
+	bitops_lock(flags);
+
+	old = *m;
+	*m = old | (1 << nr);
+
+	bitops_unlock(flags);
+
+	return (old & (1 << nr)) != 0;
+}
+
+static inline int
+test_and_clear_bit(unsigned long nr, volatile unsigned long *m)
+{
+	unsigned long old, flags;
+	m += nr >> 5;
+
+	if (__builtin_constant_p(nr))
+		nr &= 0x1f;
+
+	bitops_lock(flags);
+
+	old = *m;
+	*m = old | (1 << nr);
+
+	bitops_unlock(flags);
+
+	return (old & (1 << nr)) != 0;
+}
+
+static inline int
+test_and_change_bit(unsigned long nr, volatile unsigned long *m)
+{
+	unsigned long old, flags;
+	m += nr >> 5;
+
+	if (__builtin_constant_p(nr))
+		nr &= 0x1f;
+
+	bitops_lock(flags);
+
+	old = *m;
+	*m = old ^ (1 << nr);
+
+	bitops_unlock(flags);
+
+	return (old & (1 << nr)) != 0;
+}
+
+#endif /* CONFIG_ARC_HAS_LLSC */
+
+/***************************************
+ * Non atomic variants
+ **************************************/
+
+static inline void __set_bit(unsigned long nr, volatile unsigned long *m)
+{
+	unsigned long temp;
+	m += nr >> 5;
+
+	if (__builtin_constant_p(nr))
+		nr &= 0x1f;
+
+	temp = *m;
+	*m = temp | (1UL << nr);
+}
+
+static inline void __clear_bit(unsigned long nr, volatile unsigned long *m)
+{
+	unsigned long temp;
+	m += nr >> 5;
+
+	if (__builtin_constant_p(nr))
+		nr &= 0x1f;
+
+	temp = *m;
+	*m = temp & ~(1UL << nr);
+}
+
+static inline void __change_bit(unsigned long nr, volatile unsigned long *m)
+{
+	unsigned long temp;
+	m += nr >> 5;
+
+	if (__builtin_constant_p(nr))
+		nr &= 0x1f;
+
+	temp = *m;
+	*m = temp ^ (1UL << nr);
+}
+
+static inline int
+__test_and_set_bit(unsigned long nr, volatile unsigned long *m)
+{
+	unsigned long old;
+	m += nr >> 5;
+
+	if (__builtin_constant_p(nr))
+		nr &= 0x1f;
+
+	old = *m;
+	*m = old | (1 << nr);
+
+	return (old & (1 << nr)) != 0;
+}
+
+static inline int
+__test_and_clear_bit(unsigned long nr, volatile unsigned long *m)
+{
+	unsigned long old;
+	m += nr >> 5;
+
+	if (__builtin_constant_p(nr))
+		nr &= 0x1f;
+
+	old = *m;
+	*m = old & ~(1 << nr);
+
+	return (old & (1 << nr)) != 0;
+}
+
+static inline int
+__test_and_change_bit(unsigned long nr, volatile unsigned long *m)
+{
+	unsigned long old;
+	m += nr >> 5;
+
+	if (__builtin_constant_p(nr))
+		nr &= 0x1f;
+
+	old = *m;
+	*m = old ^ (1 << nr);
+
+	return (old & (1 << nr)) != 0;
+}
+
+/*
+ * This routine doesn't need to be atomic.
+ */
+static inline int
+__constant_test_bit(unsigned int nr, const volatile unsigned long *addr)
+{
+	return ((1UL << (nr & 31)) &
+		(((const volatile unsigned int *)addr)[nr >> 5])) != 0;
+}
+
+static inline int
+__test_bit(unsigned int nr, const volatile unsigned long *addr)
+{
+	unsigned long mask;
+
+	addr += nr >> 5;
+
+	/* ARC700 only considers 5 bits in bit-fiddling insn */
+	mask = 1 << nr;
+
+	return ((mask & *addr) != 0);
+}
+
+#define test_bit(nr, addr)	(__builtin_constant_p(nr) ? \
+					__constant_test_bit((nr), (addr)) : \
+					__test_bit((nr), (addr)))
+
+/*
+ * Count the number of zeros, starting from MSB
+ * Helper for fls( ) friends
+ * This is a pure count, so (1-32) or (0-31) doesn't apply
+ * It could be 0 to 32, based on num of 0's in there
+ * clz(0x8000_0000) = 0, clz(0xFFFF_FFFF)=0, clz(0) = 32, clz(1) = 31
+ */
+static inline __attribute__ ((const)) int clz(unsigned int x)
+{
+	unsigned int res;
+
+	__asm__ __volatile__(
+	"	norm.f  %0, %1		\n"
+	"	mov.n   %0, 0		\n"
+	"	add.p   %0, %0, 1	\n"
+	: "=r"(res)
+	: "r"(x)
+	: "cc");
+
+	return res;
+}
+
+static inline int constant_fls(int x)
+{
+	int r = 32;
+
+	if (!x)
+		return 0;
+	if (!(x & 0xffff0000u)) {
+		x <<= 16;
+		r -= 16;
+	}
+	if (!(x & 0xff000000u)) {
+		x <<= 8;
+		r -= 8;
+	}
+	if (!(x & 0xf0000000u)) {
+		x <<= 4;
+		r -= 4;
+	}
+	if (!(x & 0xc0000000u)) {
+		x <<= 2;
+		r -= 2;
+	}
+	if (!(x & 0x80000000u)) {
+		x <<= 1;
+		r -= 1;
+	}
+	return r;
+}
+
+/*
+ * fls = Find Last Set in word
+ * @result: [1-32]
+ * fls(1) = 1, fls(0x80000000) = 32, fls(0) = 0
+ */
+static inline __attribute__ ((const)) int fls(unsigned long x)
+{
+	if (__builtin_constant_p(x))
+	       return constant_fls(x);
+
+	return 32 - clz(x);
+}
+
+/*
+ * __fls: Similar to fls, but zero based (0-31)
+ */
+static inline __attribute__ ((const)) int __fls(unsigned long x)
+{
+	if (!x)
+		return 0;
+	else
+		return fls(x) - 1;
+}
+
+/*
+ * ffs = Find First Set in word (LSB to MSB)
+ * @result: [1-32], 0 if all 0's
+ */
+#define ffs(x)	({ unsigned long __t = (x); fls(__t & -__t); })
+
+/*
+ * __ffs: Similar to ffs, but zero based (0-31)
+ */
+static inline __attribute__ ((const)) int __ffs(unsigned long word)
+{
+	if (!word)
+		return word;
+
+	return ffs(word) - 1;
+}
+
+/*
+ * ffz = Find First Zero in word.
+ * @return:[0-31], 32 if all 1's
+ */
+#define ffz(x)	__ffs(~(x))
+
+/* TODO does this affect uni-processor code */
+#define smp_mb__before_clear_bit()  barrier()
+#define smp_mb__after_clear_bit()   barrier()
+
+#include <asm-generic/bitops/hweight.h>
+#include <asm-generic/bitops/fls64.h>
+#include <asm-generic/bitops/sched.h>
+#include <asm-generic/bitops/lock.h>
+
+#include <asm-generic/bitops/find.h>
+#include <asm-generic/bitops/le.h>
+#include <asm-generic/bitops/ext2-atomic-setbit.h>
+
+#endif /* !__ASSEMBLY__ */
+
+#endif /* __KERNEL__ */
+
+#endif
diff --git a/arch/arc/include/asm/cmpxchg.h b/arch/arc/include/asm/cmpxchg.h
new file mode 100644
index 0000000..03cd689
--- /dev/null
+++ b/arch/arc/include/asm/cmpxchg.h
@@ -0,0 +1,143 @@
+/*
+ * Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef __ASM_ARC_CMPXCHG_H
+#define __ASM_ARC_CMPXCHG_H
+
+#include <linux/types.h>
+#include <asm/smp.h>
+
+#ifdef CONFIG_ARC_HAS_LLSC
+
+static inline unsigned long
+__cmpxchg(volatile void *ptr, unsigned long expected, unsigned long new)
+{
+	unsigned long prev;
+
+	__asm__ __volatile__(
+	"1:	llock   %0, [%1]	\n"
+	"	brne    %0, %2, 2f	\n"
+	"	scond   %3, [%1]	\n"
+	"	bnz     1b		\n"
+	"2:				\n"
+	: "=&r"(prev)
+	: "r"(ptr), "ir"(expected),
+	  "r"(new) /* can't be "ir". scond can't take limm for "b" */
+	: "cc");
+
+	return prev;
+}
+
+#else
+
+static inline unsigned long
+__cmpxchg(volatile void *ptr, unsigned long expected, unsigned long new)
+{
+	unsigned long flags;
+	int prev;
+	volatile unsigned long *p = ptr;
+
+	atomic_ops_lock(flags);
+	prev = *p;
+	if (prev == expected)
+		*p = new;
+	atomic_ops_unlock(flags);
+	return prev;
+}
+
+#endif /* CONFIG_ARC_HAS_LLSC */
+
+#define cmpxchg(ptr, o, n) ((typeof(*(ptr)))__cmpxchg((ptr), \
+				(unsigned long)(o), (unsigned long)(n)))
+
+/*
+ * Since not supported natively, ARC cmpxchg() uses atomic_ops_lock (UP/SMP)
+ * just to gaurantee semantics.
+ * atomic_cmpxchg() needs to use the same locks as it's other atomic siblings
+ * which also happens to be atomic_ops_lock.
+ *
+ * Thus despite semantically being different, implementation of atomic_cmpxchg()
+ * is same as cmpxchg().
+ */
+#define atomic_cmpxchg(v, o, n) ((int)cmpxchg(&((v)->counter), (o), (n)))
+
+
+/*
+ * xchg (reg with memory) based on "Native atomic" EX insn
+ */
+static inline unsigned long __xchg(unsigned long val, volatile void *ptr,
+				   int size)
+{
+	extern unsigned long __xchg_bad_pointer(void);
+
+	switch (size) {
+	case 4:
+		__asm__ __volatile__(
+		"	ex  %0, [%1]	\n"
+		: "+r"(val)
+		: "r"(ptr)
+		: "memory");
+
+		return val;
+	}
+	return __xchg_bad_pointer();
+}
+
+#define _xchg(ptr, with) ((typeof(*(ptr)))__xchg((unsigned long)(with), (ptr), \
+						 sizeof(*(ptr))))
+
+/*
+ * On ARC700, EX insn is inherently atomic, so by default "vanilla" xchg() need
+ * not require any locking. However there's a quirk.
+ * ARC lacks native CMPXCHG, thus emulated (see above), using external locking -
+ * incidently it "reuses" the same atomic_ops_lock used by atomic APIs.
+ * Now, llist code uses cmpxchg() and xchg() on same data, so xchg() needs to
+ * abide by same serializing rules, thus ends up using atomic_ops_lock as well.
+ *
+ * This however is only relevant if SMP and/or ARC lacks LLSC
+ *   if (UP or LLSC)
+ *      xchg doesn't need serialization
+ *   else <==> !(UP or LLSC) <==> (!UP and !LLSC) <==> (SMP and !LLSC)
+ *      xchg needs serialization
+ */
+
+#if !defined(CONFIG_ARC_HAS_LLSC) && defined(CONFIG_SMP)
+
+#define xchg(ptr, with)			\
+({					\
+	unsigned long flags;		\
+	typeof(*(ptr)) old_val;		\
+					\
+	atomic_ops_lock(flags);		\
+	old_val = _xchg(ptr, with);	\
+	atomic_ops_unlock(flags);	\
+	old_val;			\
+})
+
+#else
+
+#define xchg(ptr, with)  _xchg(ptr, with)
+
+#endif
+
+/*
+ * "atomic" variant of xchg()
+ * REQ: It needs to follow the same serialization rules as other atomic_xxx()
+ * Since xchg() doesn't always do that, it would seem that following defintion
+ * is incorrect. But here's the rationale:
+ *   SMP : Even xchg() takes the atomic_ops_lock, so OK.
+ *   LLSC: atomic_ops_lock are not relevent at all (even if SMP, since LLSC
+ *         is natively "SMP safe", no serialization required).
+ *   UP  : other atomics disable IRQ, so no way a difft ctxt atomic_xchg()
+ *         could clobber them. atomic_xchg() itself would be 1 insn, so it
+ *         can't be clobbered by others. Thus no serialization required when
+ *         atomic_xchg is involved.
+ */
+#define atomic_xchg(v, new) (xchg(&((v)->counter), new))
+
+#endif
diff --git a/arch/arc/include/asm/smp.h b/arch/arc/include/asm/smp.h
new file mode 100644
index 0000000..4341f3b
--- /dev/null
+++ b/arch/arc/include/asm/smp.h
@@ -0,0 +1,34 @@
+/*
+ * Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef __ASM_ARC_SMP_H
+#define __ASM_ARC_SMP_H
+
+/*
+ * ARC700 doesn't support atomic Read-Modify-Write ops.
+ * Originally Interrupts had to be disabled around code to gaurantee atomicity.
+ * The LLOCK/SCOND insns allow writing interrupt-hassle-free based atomic ops
+ * based on retry-if-irq-in-atomic (with hardware assist).
+ * However despite these, we provide the IRQ disabling variant
+ *
+ * (1) These insn were introduced only in 4.10 release. So for older released
+ *	support needed.
+ */
+#ifndef CONFIG_ARC_HAS_LLSC
+
+#include <linux/irqflags.h>
+
+#define atomic_ops_lock(flags)		local_irq_save(flags)
+#define atomic_ops_unlock(flags)	local_irq_restore(flags)
+
+#define bitops_lock(flags)		local_irq_save(flags)
+#define bitops_unlock(flags)		local_irq_restore(flags)
+
+#endif	/* !CONFIG_ARC_HAS_LLSC */
+
+#endif
-- 
1.7.4.1

