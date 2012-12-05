Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753578Ab2LEQPq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 11:15:46 -0500
Received: from multi.imgtec.com ([194.200.65.239]:51616 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753322Ab2LEQJj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 11:09:39 -0500
From: James Hogan <james.hogan@imgtec.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Arnd Bergmann <arnd@arndb.de>, James Hogan <james.hogan@imgtec.com>
Subject: [PATCH v2 28/44] metag: Atomics, locks and bitops
Date: Wed, 5 Dec 2012 16:08:46 +0000
Message-ID: <1354723742-6195-29-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1354723742-6195-1-git-send-email-james.hogan@imgtec.com>
References: <1354723742-6195-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01181__2012_12_05_16_09_30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add header files to implement Meta hardware thread locks (used by some
other atomic operations), atomics, spinlocks, and bitops.

There are 2 main types of atomic primitives for metag (in addition to
IRQs off on UP):
 - LOCK instructions provide locking between hardware threads.
 - LNKGET/LNKSET instructions provide load-linked/store-conditional
   operations allowing for lighter weight atomics on Meta2)

LOCK instructions allow for hardware threads to acquire voluntary or
exclusive hardware thread locks:
 - LOCK0 releases exclusive and voluntary lock from the running hardware
   thread.
 - LOCK1 acquires the voluntary hardware lock, blocking until it becomes
   available.
 - LOCK2 implies LOCK1, and additionally acquires the exclusive hardware
   lock, blocking all other hardware threads from executing.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
---
 arch/metag/include/asm/atomic.h          |   53 ++++++
 arch/metag/include/asm/atomic_lnkget.h   |  245 ++++++++++++++++++++++++++++
 arch/metag/include/asm/atomic_lock1.h    |  160 ++++++++++++++++++
 arch/metag/include/asm/bitops.h          |  132 +++++++++++++++
 arch/metag/include/asm/cmpxchg.h         |   65 ++++++++
 arch/metag/include/asm/cmpxchg_irq.h     |   42 +++++
 arch/metag/include/asm/cmpxchg_lnkget.h  |   86 ++++++++++
 arch/metag/include/asm/cmpxchg_lock1.h   |   48 ++++++
 arch/metag/include/asm/lock.h            |   14 ++
 arch/metag/include/asm/spinlock.h        |   22 +++
 arch/metag/include/asm/spinlock_lnkget.h |  261 ++++++++++++++++++++++++++++++
 arch/metag/include/asm/spinlock_lock1.h  |  184 +++++++++++++++++++++
 arch/metag/include/asm/spinlock_types.h  |   20 +++
 13 files changed, 1332 insertions(+), 0 deletions(-)
 create mode 100644 arch/metag/include/asm/atomic.h
 create mode 100644 arch/metag/include/asm/atomic_lnkget.h
 create mode 100644 arch/metag/include/asm/atomic_lock1.h
 create mode 100644 arch/metag/include/asm/bitops.h
 create mode 100644 arch/metag/include/asm/cmpxchg.h
 create mode 100644 arch/metag/include/asm/cmpxchg_irq.h
 create mode 100644 arch/metag/include/asm/cmpxchg_lnkget.h
 create mode 100644 arch/metag/include/asm/cmpxchg_lock1.h
 create mode 100644 arch/metag/include/asm/lock.h
 create mode 100644 arch/metag/include/asm/spinlock.h
 create mode 100644 arch/metag/include/asm/spinlock_lnkget.h
 create mode 100644 arch/metag/include/asm/spinlock_lock1.h
 create mode 100644 arch/metag/include/asm/spinlock_types.h

diff --git a/arch/metag/include/asm/atomic.h b/arch/metag/include/asm/atomic.h
new file mode 100644
index 0000000..307ecd2
--- /dev/null
+++ b/arch/metag/include/asm/atomic.h
@@ -0,0 +1,53 @@
+#ifndef __ASM_METAG_ATOMIC_H
+#define __ASM_METAG_ATOMIC_H
+
+#include <linux/compiler.h>
+#include <linux/types.h>
+#include <asm/cmpxchg.h>
+
+#if defined(CONFIG_METAG_ATOMICITY_IRQSOFF)
+/* The simple UP case. */
+#include <asm-generic/atomic.h>
+#else
+
+#if defined(CONFIG_METAG_ATOMICITY_LOCK1)
+#include <asm/atomic_lock1.h>
+#else
+#include <asm/atomic_lnkget.h>
+#endif
+
+#define atomic_add_negative(a, v)       (atomic_add_return((a), (v)) < 0)
+
+#define atomic_dec_return(v) atomic_sub_return(1, (v))
+#define atomic_inc_return(v) atomic_add_return(1, (v))
+
+/*
+ * atomic_inc_and_test - increment and test
+ * @v: pointer of type atomic_t
+ *
+ * Atomically increments @v by 1
+ * and returns true if the result is zero, or false for all
+ * other cases.
+ */
+#define atomic_inc_and_test(v) (atomic_inc_return(v) == 0)
+
+#define atomic_sub_and_test(i, v) (atomic_sub_return((i), (v)) == 0)
+#define atomic_dec_and_test(v) (atomic_sub_return(1, (v)) == 0)
+
+#define atomic_inc(v) atomic_add(1, (v))
+#define atomic_dec(v) atomic_sub(1, (v))
+
+#define atomic_inc_not_zero(v) atomic_add_unless((v), 1, 0)
+
+#define smp_mb__before_atomic_dec()	barrier()
+#define smp_mb__after_atomic_dec()	barrier()
+#define smp_mb__before_atomic_inc()	barrier()
+#define smp_mb__after_atomic_inc()	barrier()
+
+#endif
+
+#define atomic_dec_if_positive(v)       atomic_sub_if_positive(1, v)
+
+#include <asm-generic/atomic64.h>
+
+#endif /* __ASM_METAG_ATOMIC_H */
diff --git a/arch/metag/include/asm/atomic_lnkget.h b/arch/metag/include/asm/atomic_lnkget.h
new file mode 100644
index 0000000..b05be05
--- /dev/null
+++ b/arch/metag/include/asm/atomic_lnkget.h
@@ -0,0 +1,245 @@
+#ifndef __ASM_METAG_ATOMIC_LNKGET_H
+#define __ASM_METAG_ATOMIC_LNKGET_H
+
+#define ATOMIC_INIT(i)	{ (i) }
+
+#define atomic_set(v, i)		((v)->counter = (i))
+
+#include <linux/compiler.h>
+
+#include <asm/barrier.h>
+
+/*
+ * None of these asm statements clobber memory as LNKSET writes around
+ * the cache so the memory it modifies cannot safely be read by any means
+ * other than these accessors.
+ */
+
+static inline int atomic_read(const atomic_t *v)
+{
+	int temp;
+
+	__asm__ __volatile__(
+		"LNKGETD %0, [%1]\n"
+		: "=da" (temp)
+		: "da" (&v->counter)
+	);
+
+	return temp;
+}
+
+static inline void atomic_add(int i, atomic_t *v)
+{
+	int temp;
+
+	__asm__ __volatile__(
+		"1:	LNKGETD %0, [%1]\n"
+		"	ADD	%0, %0, %2\n"
+		"	LNKSETD [%1], %0\n"
+		"	DEFR	%0, TXSTAT\n"
+		"	ANDT	%0, %0, #HI(0x3f000000)\n"
+		"	CMPT	%0, #HI(0x02000000)\n"
+		"	BNZ	1b\n"
+		: "=&d" (temp)
+		: "da" (&v->counter), "bd" (i)
+		: "cc"
+	);
+}
+
+static inline void atomic_sub(int i, atomic_t *v)
+{
+	int temp;
+
+	__asm__ __volatile__(
+		"1:	LNKGETD %0, [%1]\n"
+		"	SUB	%0, %0, %2\n"
+		"	LNKSETD [%1], %0\n"
+		"	DEFR	%0, TXSTAT\n"
+		"	ANDT	%0, %0, #HI(0x3f000000)\n"
+		"	CMPT	%0, #HI(0x02000000)\n"
+		"	BNZ 1b\n"
+		: "=&d" (temp)
+		: "da" (&v->counter), "bd" (i)
+		: "cc"
+	);
+}
+
+static inline int atomic_add_return(int i, atomic_t *v)
+{
+	int result, temp;
+
+	smp_mb();
+
+	__asm__ __volatile__(
+		"1:	LNKGETD %1, [%2]\n"
+		"	ADD	%1, %1, %3\n"
+		"	LNKSETD [%2], %1\n"
+		"	DEFR	%0, TXSTAT\n"
+		"	ANDT	%0, %0, #HI(0x3f000000)\n"
+		"	CMPT	%0, #HI(0x02000000)\n"
+		"	BNZ 1b\n"
+		: "=&d" (temp), "=&da" (result)
+		: "da" (&v->counter), "bd" (i)
+		: "cc"
+	);
+
+	smp_mb();
+
+	return result;
+}
+
+static inline int atomic_sub_return(int i, atomic_t *v)
+{
+	int result, temp;
+
+	smp_mb();
+
+	__asm__ __volatile__(
+		"1:	LNKGETD %1, [%2]\n"
+		"	SUB	%1, %1, %3\n"
+		"	LNKSETD [%2], %1\n"
+		"	DEFR	%0, TXSTAT\n"
+		"	ANDT	%0, %0, #HI(0x3f000000)\n"
+		"	CMPT	%0, #HI(0x02000000)\n"
+		"	BNZ	1b\n"
+		: "=&d" (temp), "=&da" (result)
+		: "da" (&v->counter), "bd" (i)
+		: "cc"
+	);
+
+	smp_mb();
+
+	return result;
+}
+
+static inline void atomic_clear_mask(unsigned int mask, atomic_t *v)
+{
+	int temp;
+
+	__asm__ __volatile__(
+		"1:	LNKGETD %0, [%1]\n"
+		"	AND	%0, %0, %2\n"
+		"	LNKSETD	[%1] %0\n"
+		"	DEFR	%0, TXSTAT\n"
+		"	ANDT	%0, %0, #HI(0x3f000000)\n"
+		"	CMPT	%0, #HI(0x02000000)\n"
+		"	BNZ	1b\n"
+		: "=&d" (temp)
+		: "da" (&v->counter), "bd" (~mask)
+		: "cc"
+	);
+}
+
+static inline void atomic_set_mask(unsigned int mask, atomic_t *v)
+{
+	int temp;
+
+	__asm__ __volatile__(
+		"1:	LNKGETD %0, [%1]\n"
+		"	OR	%0, %0, %2\n"
+		"	LNKSETD	[%1], %0\n"
+		"	DEFR	%0, TXSTAT\n"
+		"	ANDT	%0, %0, #HI(0x3f000000)\n"
+		"	CMPT	%0, #HI(0x02000000)\n"
+		"	BNZ	1b\n"
+		: "=&d" (temp)
+		: "da" (&v->counter), "bd" (mask)
+		: "cc"
+	);
+}
+
+static inline int atomic_cmpxchg(atomic_t *v, int old, int new)
+{
+	int result, temp;
+
+	smp_mb();
+
+	__asm__ __volatile__(
+		"1:	LNKGETD	%1, [%2]\n"
+		"	CMP	%1, %3\n"
+		"	LNKSETDEQ [%2], %4\n"
+		"	BNE	2f\n"
+		"	DEFR	%0, TXSTAT\n"
+		"	ANDT	%0, %0, #HI(0x3f000000)\n"
+		"	CMPT	%0, #HI(0x02000000)\n"
+		"	BNZ	1b\n"
+		"2:\n"
+		: "=&d" (temp), "=&d" (result)
+		: "da" (&v->counter), "bd" (old), "da" (new)
+		: "cc"
+	);
+
+	smp_mb();
+
+	return result;
+}
+
+static inline int atomic_xchg(atomic_t *v, int new)
+{
+	int temp, old;
+
+	__asm__ __volatile__(
+			"1:	LNKGETD %1, [%2]\n"
+			"	LNKSETD	[%2], %3\n"
+			"	DEFR	%0, TXSTAT\n"
+			"	ANDT	%0, %0, #HI(0x3f000000)\n"
+			"	CMPT	%0, #HI(0x02000000)\n"
+			"	BNZ	1b\n"
+			: "=&d" (temp), "=&d" (old)
+			: "da" (&v->counter), "da" (new)
+			: "cc"
+	);
+
+	return old;
+}
+
+static inline int __atomic_add_unless(atomic_t *v, int a, int u)
+{
+	int result, temp;
+
+	smp_mb();
+
+	__asm__ __volatile__(
+			"1:	LNKGETD %1, [%2]\n"
+			"	CMP	%1, %3\n"
+			"	ADD	%0, %1, %4\n"
+			"	LNKSETDNE [%2], %0\n"
+			"	BEQ	2f\n"
+			"	DEFR	%0, TXSTAT\n"
+			"	ANDT	%0, %0, #HI(0x3f000000)\n"
+			"	CMPT	%0, #HI(0x02000000)\n"
+			"	BNZ	1b\n"
+			"2:\n"
+			: "=&d" (temp), "=&d" (result)
+			: "da" (&v->counter), "bd" (u), "bd" (a)
+			: "cc"
+	);
+
+	smp_mb();
+
+	return result;
+}
+
+static inline int atomic_sub_if_positive(int i, atomic_t *v)
+{
+	int result, temp;
+
+	__asm__ __volatile__(
+			"1:	LNKGETD %1, [%2]\n"
+			"	SUBS	%1, %1, %3\n"
+			"	LNKSETDGE [%2], %1\n"
+			"	BLT	2f\n"
+			"	DEFR	%0, TXSTAT\n"
+			"	ANDT	%0, %0, #HI(0x3f000000)\n"
+			"	CMPT	%0, #HI(0x02000000)\n"
+			"	BNZ	1b\n"
+			"2:\n"
+			: "=&d" (temp), "=&da" (result)
+			: "da" (&v->counter), "bd" (i)
+			: "cc"
+	);
+
+	return result;
+}
+
+#endif /* __ASM_METAG_ATOMIC_LNKGET_H */
diff --git a/arch/metag/include/asm/atomic_lock1.h b/arch/metag/include/asm/atomic_lock1.h
new file mode 100644
index 0000000..0ce2a9d
--- /dev/null
+++ b/arch/metag/include/asm/atomic_lock1.h
@@ -0,0 +1,160 @@
+#ifndef __ASM_METAG_ATOMIC_LOCK1_H
+#define __ASM_METAG_ATOMIC_LOCK1_H
+
+#define ATOMIC_INIT(i)	{ (i) }
+
+#include <linux/compiler.h>
+
+#include <asm/barrier.h>
+#include <asm/lock.h>
+
+static inline int atomic_read(const atomic_t *v)
+{
+	return (v)->counter;
+}
+
+/*
+ * atomic_set needs to be take the lock to protect atomic_add_unless from a
+ * possible race, as it reads the counter twice:
+ *
+ *  CPU0                               CPU1
+ *  atomic_add_unless(1, 0)
+ *    ret = v->counter (non-zero)
+ *    if (ret != u)                    v->counter = 0
+ *      v->counter += 1 (counter set to 1)
+ *
+ * Making atomic_set take the lock ensures that ordering and logical
+ * consistency is preserved.
+ */
+static inline int atomic_set(atomic_t *v, int i)
+{
+	unsigned long flags;
+
+	__global_lock1(flags);
+	fence();
+	v->counter = i;
+	__global_unlock1(flags);
+	return i;
+}
+
+static inline void atomic_add(int i, atomic_t *v)
+{
+	unsigned long flags;
+
+	__global_lock1(flags);
+	fence();
+	v->counter += i;
+	__global_unlock1(flags);
+}
+
+static inline void atomic_sub(int i, atomic_t *v)
+{
+	unsigned long flags;
+
+	__global_lock1(flags);
+	fence();
+	v->counter -= i;
+	__global_unlock1(flags);
+}
+
+static inline int atomic_add_return(int i, atomic_t *v)
+{
+	unsigned long result;
+	unsigned long flags;
+
+	__global_lock1(flags);
+	result = v->counter;
+	result += i;
+	fence();
+	v->counter = result;
+	__global_unlock1(flags);
+
+	return result;
+}
+
+static inline int atomic_sub_return(int i, atomic_t *v)
+{
+	unsigned long result;
+	unsigned long flags;
+
+	__global_lock1(flags);
+	result = v->counter;
+	result -= i;
+	fence();
+	v->counter = result;
+	__global_unlock1(flags);
+
+	return result;
+}
+
+static inline void atomic_clear_mask(unsigned int mask, atomic_t *v)
+{
+	unsigned long flags;
+
+	__global_lock1(flags);
+	fence();
+	v->counter &= ~mask;
+	__global_unlock1(flags);
+}
+
+static inline void atomic_set_mask(unsigned int mask, atomic_t *v)
+{
+	unsigned long flags;
+
+	__global_lock1(flags);
+	fence();
+	v->counter |= mask;
+	__global_unlock1(flags);
+}
+
+static inline int atomic_cmpxchg(atomic_t *v, int old, int new)
+{
+	int ret;
+	unsigned long flags;
+
+	__global_lock1(flags);
+	ret = v->counter;
+	if (ret == old) {
+		fence();
+		v->counter = new;
+	}
+	__global_unlock1(flags);
+
+	return ret;
+}
+
+#define atomic_xchg(v, new) (xchg(&((v)->counter), new))
+
+static inline int __atomic_add_unless(atomic_t *v, int a, int u)
+{
+	int ret;
+	unsigned long flags;
+
+	__global_lock1(flags);
+	ret = v->counter;
+	if (ret != u) {
+		fence();
+		v->counter += a;
+	}
+	__global_unlock1(flags);
+
+	return ret;
+}
+
+static inline int atomic_sub_if_positive(int i, atomic_t *v)
+{
+	int ret;
+	unsigned long flags;
+
+	__global_lock1(flags);
+	ret = v->counter - 1;
+	if (ret >= 0) {
+		fence();
+		v->counter = ret;
+	}
+	__global_unlock1(flags);
+
+	return ret;
+}
+
+#endif /* __ASM_METAG_ATOMIC_LOCK1_H */
diff --git a/arch/metag/include/asm/bitops.h b/arch/metag/include/asm/bitops.h
new file mode 100644
index 0000000..638a364
--- /dev/null
+++ b/arch/metag/include/asm/bitops.h
@@ -0,0 +1,132 @@
+#ifndef __ASM_METAG_BITOPS_H
+#define __ASM_METAG_BITOPS_H
+
+#include <linux/compiler.h>
+#include <asm/barrier.h>
+#include <asm/lock.h>
+
+/*
+ * clear_bit() doesn't provide any barrier for the compiler.
+ */
+#define smp_mb__before_clear_bit()	barrier()
+#define smp_mb__after_clear_bit()	barrier()
+
+#ifdef CONFIG_SMP
+/*
+ * These functions are the basis of our bit ops.
+ */
+static inline void set_bit(unsigned int bit, volatile unsigned long *p)
+{
+	unsigned long flags;
+	unsigned long mask = 1UL << (bit & 31);
+
+	p += bit >> 5;
+
+	__global_lock1(flags);
+	fence();
+	*p |= mask;
+	__global_unlock1(flags);
+}
+
+static inline void clear_bit(unsigned int bit, volatile unsigned long *p)
+{
+	unsigned long flags;
+	unsigned long mask = 1UL << (bit & 31);
+
+	p += bit >> 5;
+
+	__global_lock1(flags);
+	fence();
+	*p &= ~mask;
+	__global_unlock1(flags);
+}
+
+static inline void change_bit(unsigned int bit, volatile unsigned long *p)
+{
+	unsigned long flags;
+	unsigned long mask = 1UL << (bit & 31);
+
+	p += bit >> 5;
+
+	__global_lock1(flags);
+	fence();
+	*p ^= mask;
+	__global_unlock1(flags);
+}
+
+static inline int test_and_set_bit(unsigned int bit, volatile unsigned long *p)
+{
+	unsigned long flags;
+	unsigned long old;
+	unsigned long mask = 1UL << (bit & 31);
+
+	p += bit >> 5;
+
+	__global_lock1(flags);
+	old = *p;
+	if (!(old & mask)) {
+		fence();
+		*p = old | mask;
+	}
+	__global_unlock1(flags);
+
+	return (old & mask) != 0;
+}
+
+static inline int test_and_clear_bit(unsigned int bit,
+				     volatile unsigned long *p)
+{
+	unsigned long flags;
+	unsigned long old;
+	unsigned long mask = 1UL << (bit & 31);
+
+	p += bit >> 5;
+
+	__global_lock1(flags);
+	old = *p;
+	if (old & mask) {
+		fence();
+		*p = old & ~mask;
+	}
+	__global_unlock1(flags);
+
+	return (old & mask) != 0;
+}
+
+static inline int test_and_change_bit(unsigned int bit,
+				      volatile unsigned long *p)
+{
+	unsigned long flags;
+	unsigned long old;
+	unsigned long mask = 1UL << (bit & 31);
+
+	p += bit >> 5;
+
+	__global_lock1(flags);
+	fence();
+	old = *p;
+	*p = old ^ mask;
+	__global_unlock1(flags);
+
+	return (old & mask) != 0;
+}
+
+#else
+#include <asm-generic/bitops/atomic.h>
+#endif /* CONFIG_SMP */
+
+#include <asm-generic/bitops/non-atomic.h>
+#include <asm-generic/bitops/find.h>
+#include <asm-generic/bitops/ffs.h>
+#include <asm-generic/bitops/__ffs.h>
+#include <asm-generic/bitops/ffz.h>
+#include <asm-generic/bitops/fls.h>
+#include <asm-generic/bitops/__fls.h>
+#include <asm-generic/bitops/fls64.h>
+#include <asm-generic/bitops/hweight.h>
+#include <asm-generic/bitops/lock.h>
+#include <asm-generic/bitops/sched.h>
+#include <asm-generic/bitops/le.h>
+#include <asm-generic/bitops/ext2-atomic.h>
+
+#endif /* __ASM_METAG_BITOPS_H */
diff --git a/arch/metag/include/asm/cmpxchg.h b/arch/metag/include/asm/cmpxchg.h
new file mode 100644
index 0000000..b1bc1be
--- /dev/null
+++ b/arch/metag/include/asm/cmpxchg.h
@@ -0,0 +1,65 @@
+#ifndef __ASM_METAG_CMPXCHG_H
+#define __ASM_METAG_CMPXCHG_H
+
+#include <asm/barrier.h>
+
+#if defined(CONFIG_METAG_ATOMICITY_IRQSOFF)
+#include <asm/cmpxchg_irq.h>
+#elif defined(CONFIG_METAG_ATOMICITY_LOCK1)
+#include <asm/cmpxchg_lock1.h>
+#elif defined(CONFIG_METAG_ATOMICITY_LNKGET)
+#include <asm/cmpxchg_lnkget.h>
+#endif
+
+extern void __xchg_called_with_bad_pointer(void);
+
+#define __xchg(ptr, x, size)				\
+({							\
+	unsigned long __xchg__res;			\
+	volatile void *__xchg_ptr = (ptr);		\
+	switch (size) {					\
+	case 4:						\
+		__xchg__res = xchg_u32(__xchg_ptr, x);	\
+		break;					\
+	case 1:						\
+		__xchg__res = xchg_u8(__xchg_ptr, x);	\
+		break;					\
+	default:					\
+		__xchg_called_with_bad_pointer();	\
+		__xchg__res = x;			\
+		break;					\
+	}						\
+							\
+	__xchg__res;					\
+})
+
+#define xchg(ptr, x)	\
+	((__typeof__(*(ptr)))__xchg((ptr), (unsigned long)(x), sizeof(*(ptr))))
+
+/* This function doesn't exist, so you'll get a linker error
+ * if something tries to do an invalid cmpxchg(). */
+extern void __cmpxchg_called_with_bad_pointer(void);
+
+static inline unsigned long __cmpxchg(volatile void *ptr, unsigned long old,
+				      unsigned long new, int size)
+{
+	switch (size) {
+	case 4:
+		return __cmpxchg_u32(ptr, old, new);
+	}
+	__cmpxchg_called_with_bad_pointer();
+	return old;
+}
+
+#define __HAVE_ARCH_CMPXCHG 1
+
+#define cmpxchg(ptr, o, n)						\
+	({								\
+		__typeof__(*(ptr)) _o_ = (o);				\
+		__typeof__(*(ptr)) _n_ = (n);				\
+		(__typeof__(*(ptr))) __cmpxchg((ptr), (unsigned long)_o_, \
+					       (unsigned long)_n_,	\
+					       sizeof(*(ptr)));		\
+	})
+
+#endif /* __ASM_METAG_CMPXCHG_H */
diff --git a/arch/metag/include/asm/cmpxchg_irq.h b/arch/metag/include/asm/cmpxchg_irq.h
new file mode 100644
index 0000000..6495731
--- /dev/null
+++ b/arch/metag/include/asm/cmpxchg_irq.h
@@ -0,0 +1,42 @@
+#ifndef __ASM_METAG_CMPXCHG_IRQ_H
+#define __ASM_METAG_CMPXCHG_IRQ_H
+
+#include <linux/irqflags.h>
+
+static inline unsigned long xchg_u32(volatile u32 *m, unsigned long val)
+{
+	unsigned long flags, retval;
+
+	local_irq_save(flags);
+	retval = *m;
+	*m = val;
+	local_irq_restore(flags);
+	return retval;
+}
+
+static inline unsigned long xchg_u8(volatile u8 *m, unsigned long val)
+{
+	unsigned long flags, retval;
+
+	local_irq_save(flags);
+	retval = *m;
+	*m = val & 0xff;
+	local_irq_restore(flags);
+	return retval;
+}
+
+static inline unsigned long __cmpxchg_u32(volatile int *m, unsigned long old,
+					  unsigned long new)
+{
+	__u32 retval;
+	unsigned long flags;
+
+	local_irq_save(flags);
+	retval = *m;
+	if (retval == old)
+		*m = new;
+	local_irq_restore(flags);       /* implies memory barrier  */
+	return retval;
+}
+
+#endif /* __ASM_METAG_CMPXCHG_IRQ_H */
diff --git a/arch/metag/include/asm/cmpxchg_lnkget.h b/arch/metag/include/asm/cmpxchg_lnkget.h
new file mode 100644
index 0000000..3a44b28
--- /dev/null
+++ b/arch/metag/include/asm/cmpxchg_lnkget.h
@@ -0,0 +1,86 @@
+#ifndef __ASM_METAG_CMPXCHG_LNKGET_H
+#define __ASM_METAG_CMPXCHG_LNKGET_H
+
+static inline unsigned long xchg_u32(volatile u32 *m, unsigned long val)
+{
+	int temp, old;
+
+	smp_mb();
+
+	__asm__ __volatile__(
+			"1:	LNKGETD %1, [%2]\n"
+			"	LNKSETD	[%2], %3\n"
+			"	DEFR	%0, TXSTAT\n"
+			"	ANDT	%0, %0, #HI(0x3f000000)\n"
+			"	CMPT	%0, #HI(0x02000000)\n"
+			"	BNZ	1b\n"
+#ifdef CONFIG_METAG_LNKGET_AROUND_CACHE
+			"	DCACHE	[%2], %0\n"
+#endif
+			: "=&d" (temp), "=&d" (old)
+			: "da" (m), "da" (val)
+			: "cc"
+	);
+
+	smp_mb();
+
+	return old;
+}
+
+static inline unsigned long xchg_u8(volatile u8 *m, unsigned long val)
+{
+	int temp, old;
+
+	smp_mb();
+
+	__asm__ __volatile__(
+			"1:	LNKGETD %1, [%2]\n"
+			"	LNKSETD	[%2], %3\n"
+			"	DEFR	%0, TXSTAT\n"
+			"	ANDT	%0, %0, #HI(0x3f000000)\n"
+			"	CMPT	%0, #HI(0x02000000)\n"
+			"	BNZ	1b\n"
+#ifdef CONFIG_METAG_LNKGET_AROUND_CACHE
+			"	DCACHE	[%2], %0\n"
+#endif
+			: "=&d" (temp), "=&d" (old)
+			: "da" (m), "da" (val & 0xff)
+			: "cc"
+	);
+
+	smp_mb();
+
+	return old;
+}
+
+static inline unsigned long __cmpxchg_u32(volatile int *m, unsigned long old,
+					  unsigned long new)
+{
+	__u32 retval, temp;
+
+	smp_mb();
+
+	__asm__ __volatile__(
+		"1:	LNKGETD	%1, [%2]\n"
+		"	CMP	%1, %3\n"
+		"	LNKSETDEQ [%2], %4\n"
+		"	BNE	2f\n"
+		"	DEFR	%0, TXSTAT\n"
+		"	ANDT	%0, %0, #HI(0x3f000000)\n"
+		"	CMPT	%0, #HI(0x02000000)\n"
+		"	BNZ	1b\n"
+#ifdef CONFIG_METAG_LNKGET_AROUND_CACHE
+		"	DCACHE	[%2], %0\n"
+#endif
+		"2:\n"
+		: "=&d" (temp), "=&da" (retval)
+		: "da" (m), "bd" (old), "da" (new)
+		: "cc"
+	);
+
+	smp_mb();
+
+	return retval;
+}
+
+#endif /* __ASM_METAG_CMPXCHG_LNKGET_H */
diff --git a/arch/metag/include/asm/cmpxchg_lock1.h b/arch/metag/include/asm/cmpxchg_lock1.h
new file mode 100644
index 0000000..7fb4e1c
--- /dev/null
+++ b/arch/metag/include/asm/cmpxchg_lock1.h
@@ -0,0 +1,48 @@
+#ifndef __ASM_METAG_CMPXCHG_LOCK1_H
+#define __ASM_METAG_CMPXCHG_LOCK1_H
+
+#include <asm/lock.h>
+
+/* Use LOCK2 as these have to be atomic w.r.t. ordinary accesses. */
+
+static inline unsigned long xchg_u32(volatile u32 *m, unsigned long val)
+{
+	unsigned long flags, retval;
+
+	__global_lock2(flags);
+	fence();
+	retval = *m;
+	*m = val;
+	__global_unlock2(flags);
+	return retval;
+}
+
+static inline unsigned long xchg_u8(volatile u8 *m, unsigned long val)
+{
+	unsigned long flags, retval;
+
+	__global_lock2(flags);
+	fence();
+	retval = *m;
+	*m = val & 0xff;
+	__global_unlock2(flags);
+	return retval;
+}
+
+static inline unsigned long __cmpxchg_u32(volatile int *m, unsigned long old,
+					  unsigned long new)
+{
+	__u32 retval;
+	unsigned long flags;
+
+	__global_lock2(flags);
+	retval = *m;
+	if (retval == old) {
+		fence();
+		*m = new;
+	}
+	__global_unlock2(flags);
+	return retval;
+}
+
+#endif /* __ASM_METAG_CMPXCHG_LOCK1_H */
diff --git a/arch/metag/include/asm/lock.h b/arch/metag/include/asm/lock.h
new file mode 100644
index 0000000..360ca21
--- /dev/null
+++ b/arch/metag/include/asm/lock.h
@@ -0,0 +1,14 @@
+#ifndef __ASM_METAG_LOCK_H
+#define __ASM_METAG_LOCK_H
+
+#include <linux/compiler.h>
+
+#include <asm/tbx.h>
+
+#define __global_lock1(flags) { TBI_CRITON(flags); barrier(); }
+#define __global_unlock1(flags) { barrier(); TBI_CRITOFF(flags); }
+
+#define __global_lock2(flags) { TBI_LOCK(flags); barrier(); }
+#define __global_unlock2(flags) { barrier(); TBI_UNLOCK(flags); }
+
+#endif /* __ASM_METAG_LOCK_H */
diff --git a/arch/metag/include/asm/spinlock.h b/arch/metag/include/asm/spinlock.h
new file mode 100644
index 0000000..86a7cf3
--- /dev/null
+++ b/arch/metag/include/asm/spinlock.h
@@ -0,0 +1,22 @@
+#ifndef __ASM_SPINLOCK_H
+#define __ASM_SPINLOCK_H
+
+#ifdef CONFIG_METAG_ATOMICITY_LOCK1
+#include <asm/spinlock_lock1.h>
+#else
+#include <asm/spinlock_lnkget.h>
+#endif
+
+#define arch_spin_unlock_wait(lock) \
+	do { while (arch_spin_is_locked(lock)) cpu_relax(); } while (0)
+
+#define arch_spin_lock_flags(lock, flags) arch_spin_lock(lock)
+
+#define	arch_read_lock_flags(lock, flags) arch_read_lock(lock)
+#define	arch_write_lock_flags(lock, flags) arch_write_lock(lock)
+
+#define arch_spin_relax(lock)	cpu_relax()
+#define arch_read_relax(lock)	cpu_relax()
+#define arch_write_relax(lock)	cpu_relax()
+
+#endif /* __ASM_SPINLOCK_H */
diff --git a/arch/metag/include/asm/spinlock_lnkget.h b/arch/metag/include/asm/spinlock_lnkget.h
new file mode 100644
index 0000000..0990e39
--- /dev/null
+++ b/arch/metag/include/asm/spinlock_lnkget.h
@@ -0,0 +1,261 @@
+#ifndef __ASM_SPINLOCK_LNKGET_H
+#define __ASM_SPINLOCK_LNKGET_H
+
+/*
+ * None of these asm statements clobber memory as LNKSET writes around
+ * the cache so the memory it modifies cannot safely be read by any means
+ * other than these accessors.
+ */
+
+static inline int arch_spin_is_locked(arch_spinlock_t *lock)
+{
+	int ret;
+
+	__asm__ __volatile__(
+			     "LNKGETD	%0, [%1]\n"
+			     "TST	%0, #1\n"
+			     "MOV	%0, #1\n"
+			     "XORZ      %0, %0, %0\n"
+			     : "=&d" (ret)
+			     : "da" (&lock->lock)
+			     : "cc");
+	return ret;
+}
+
+static inline void arch_spin_lock(arch_spinlock_t *lock)
+{
+	int tmp;
+
+	__asm__ __volatile__(
+			     "1:     LNKGETD %0,[%1]\n"
+			     "       TST     %0, #1\n"
+			     "       ADD     %0, %0, #1\n"
+			     "       LNKSETDZ [%1], %0\n"
+			     "       BNZ     1b\n"
+			     "       DEFR    %0, TXSTAT\n"
+			     "       ANDT    %0, %0, #HI(0x3f000000)\n"
+			     "       CMPT    %0, #HI(0x02000000)\n"
+			     "       BNZ     1b\n"
+			     : "=&d" (tmp)
+			     : "da" (&lock->lock)
+			     : "cc");
+
+	smp_mb();
+}
+
+/* Returns 0 if failed to acquire lock */
+static inline int arch_spin_trylock(arch_spinlock_t *lock)
+{
+	int tmp;
+
+	__asm__ __volatile__(
+			     "       LNKGETD %0,[%1]\n"
+			     "       TST     %0, #1\n"
+			     "       ADD     %0, %0, #1\n"
+			     "       LNKSETDZ [%1], %0\n"
+			     "       BNZ     1f\n"
+			     "       DEFR    %0, TXSTAT\n"
+			     "       ANDT    %0, %0, #HI(0x3f000000)\n"
+			     "       CMPT    %0, #HI(0x02000000)\n"
+			     "       MOV     %0, #1\n"
+			     "1:     XORNZ   %0, %0, %0\n"
+			     : "=&d" (tmp)
+			     : "da" (&lock->lock)
+			     : "cc");
+
+	smp_mb();
+
+	return tmp;
+}
+
+static inline void arch_spin_unlock(arch_spinlock_t *lock)
+{
+	smp_mb();
+
+	__asm__ __volatile__(
+			     "       SETD    [%0], %1\n"
+			     :
+			     : "da" (&lock->lock), "da" (0)
+			     : "memory");
+}
+
+/*
+ * RWLOCKS
+ *
+ *
+ * Write locks are easy - we just set bit 31.  When unlocking, we can
+ * just write zero since the lock is exclusively held.
+ */
+
+static inline void arch_write_lock(arch_rwlock_t *rw)
+{
+	int tmp;
+
+	__asm__ __volatile__(
+			     "1:     LNKGETD %0,[%1]\n"
+			     "       CMP     %0, #0\n"
+			     "       ADD     %0, %0, %2\n"
+			     "       LNKSETDZ [%1], %0\n"
+			     "       BNZ     1b\n"
+			     "       DEFR    %0, TXSTAT\n"
+			     "       ANDT    %0, %0, #HI(0x3f000000)\n"
+			     "       CMPT    %0, #HI(0x02000000)\n"
+			     "       BNZ     1b\n"
+			     : "=&d" (tmp)
+			     : "da" (&rw->lock), "bd" (0x80000000)
+			     : "cc");
+
+	smp_mb();
+}
+
+static inline int arch_write_trylock(arch_rwlock_t *rw)
+{
+	int tmp;
+
+	__asm__ __volatile__(
+			     "       LNKGETD %0,[%1]\n"
+			     "       CMP     %0, #0\n"
+			     "       ADD     %0, %0, %2\n"
+			     "       LNKSETDZ [%1], %0\n"
+			     "       BNZ     1f\n"
+			     "       DEFR    %0, TXSTAT\n"
+			     "       ANDT    %0, %0, #HI(0x3f000000)\n"
+			     "       CMPT    %0, #HI(0x02000000)\n"
+			     "       MOV     %0,#1\n"
+			     "1:     XORNZ   %0, %0, %0\n"
+			     : "=&d" (tmp)
+			     : "da" (&rw->lock), "bd" (0x80000000)
+			     : "cc");
+
+	smp_mb();
+
+	return tmp;
+}
+
+static inline void arch_write_unlock(arch_rwlock_t *rw)
+{
+	smp_mb();
+
+	__asm__ __volatile__(
+			     "       SETD    [%0], %1\n"
+			     :
+			     : "da" (&rw->lock), "da" (0)
+			     : "memory");
+}
+
+/* write_can_lock - would write_trylock() succeed? */
+static inline int arch_write_can_lock(arch_rwlock_t *rw)
+{
+	int ret;
+
+	__asm__ __volatile__(
+			     "LNKGETD	%0, [%1]\n"
+			     "CMP	%0, #0\n"
+			     "MOV	%0, #1\n"
+			     "XORNZ     %0, %0, %0\n"
+			     : "=&d" (ret)
+			     : "da" (&rw->lock)
+			     : "cc");
+	return ret;
+}
+
+/*
+ * Read locks are a bit more hairy:
+ *  - Exclusively load the lock value.
+ *  - Increment it.
+ *  - Store new lock value if positive, and we still own this location.
+ *    If the value is negative, we've already failed.
+ *  - If we failed to store the value, we want a negative result.
+ *  - If we failed, try again.
+ * Unlocking is similarly hairy.  We may have multiple read locks
+ * currently active.  However, we know we won't have any write
+ * locks.
+ */
+static inline void arch_read_lock(arch_rwlock_t *rw)
+{
+	int tmp;
+
+	__asm__ __volatile__(
+			     "1:     LNKGETD %0,[%1]\n"
+			     "       ADDS    %0, %0, #1\n"
+			     "       LNKSETDPL [%1], %0\n"
+			     "       BMI     1b\n"
+			     "       DEFR    %0, TXSTAT\n"
+			     "       ANDT    %0, %0, #HI(0x3f000000)\n"
+			     "       CMPT    %0, #HI(0x02000000)\n"
+			     "       BNZ     1b\n"
+			     : "=&d" (tmp)
+			     : "da" (&rw->lock)
+			     : "cc");
+
+	smp_mb();
+}
+
+static inline void arch_read_unlock(arch_rwlock_t *rw)
+{
+	int tmp;
+
+	smp_mb();
+
+	__asm__ __volatile__(
+			     "1:     LNKGETD %0,[%1]\n"
+			     "       SUB     %0, %0, #1\n"
+			     "       LNKSETD [%1], %0\n"
+			     "       DEFR    %0, TXSTAT\n"
+			     "       ANDT    %0, %0, #HI(0x3f000000)\n"
+			     "       CMPT    %0, #HI(0x02000000)\n"
+			     "       BNZ     1b\n"
+			     : "=&d" (tmp)
+			     : "da" (&rw->lock)
+			     : "cc", "memory");
+}
+
+static inline int arch_read_trylock(arch_rwlock_t *rw)
+{
+	int tmp;
+
+	__asm__ __volatile__(
+			     "       LNKGETD %0,[%1]\n"
+			     "       ADDS    %0, %0, #1\n"
+			     "       LNKSETDPL [%1], %0\n"
+			     "       BMI     1f\n"
+			     "       DEFR    %0, TXSTAT\n"
+			     "       ANDT    %0, %0, #HI(0x3f000000)\n"
+			     "       CMPT    %0, #HI(0x02000000)\n"
+			     "       MOV     %0,#1\n"
+			     "       BZ      2f\n"
+			     "1:     MOV     %0,#0\n"
+			     "2:\n"
+			     : "=&d" (tmp)
+			     : "da" (&rw->lock)
+			     : "cc");
+
+	smp_mb();
+
+	return tmp;
+}
+
+/* read_can_lock - would read_trylock() succeed? */
+static inline int arch_read_can_lock(arch_rwlock_t *rw)
+{
+	int tmp;
+
+	__asm__ __volatile__(
+			     "LNKGETD	%0, [%1]\n"
+			     "CMP	%0, %2\n"
+			     "MOV	%0, #1\n"
+			     "XORZ	%0, %0, %0\n"
+			     : "=&d" (tmp)
+			     : "da" (&rw->lock), "bd" (0x80000000)
+			     : "cc");
+	return tmp;
+}
+
+#define	arch_read_lock_flags(lock, flags) arch_read_lock(lock)
+#define	arch_write_lock_flags(lock, flags) arch_write_lock(lock)
+
+#define arch_spin_relax(lock)	cpu_relax()
+#define arch_read_relax(lock)	cpu_relax()
+#define arch_write_relax(lock)	cpu_relax()
+
+#endif /* __ASM_SPINLOCK_LNKGET_H */
diff --git a/arch/metag/include/asm/spinlock_lock1.h b/arch/metag/include/asm/spinlock_lock1.h
new file mode 100644
index 0000000..e9f27df
--- /dev/null
+++ b/arch/metag/include/asm/spinlock_lock1.h
@@ -0,0 +1,184 @@
+#ifndef __ASM_SPINLOCK_LOCK1_H
+#define __ASM_SPINLOCK_LOCK1_H
+
+#include <asm/bug.h>
+#include <asm/lock.h>
+
+static inline int arch_spin_is_locked(arch_spinlock_t *lock)
+{
+	int ret;
+
+	barrier();
+	ret = lock->lock;
+	WARN_ON(ret != 0 && ret != 1);
+	return ret;
+}
+
+static inline void arch_spin_lock(arch_spinlock_t *lock)
+{
+	unsigned int we_won = 0;
+	unsigned long flags;
+
+again:
+	__global_lock1(flags);
+	if (lock->lock == 0) {
+		fence();
+		lock->lock = 1;
+		we_won = 1;
+	}
+	__global_unlock1(flags);
+	if (we_won == 0)
+		goto again;
+	WARN_ON(lock->lock != 1);
+}
+
+/* Returns 0 if failed to acquire lock */
+static inline int arch_spin_trylock(arch_spinlock_t *lock)
+{
+	unsigned long flags;
+	unsigned int ret;
+
+	__global_lock1(flags);
+	ret = lock->lock;
+	if (ret == 0) {
+		fence();
+		lock->lock = 1;
+	}
+	__global_unlock1(flags);
+	return (ret == 0);
+}
+
+static inline void arch_spin_unlock(arch_spinlock_t *lock)
+{
+	barrier();
+	WARN_ON(!lock->lock);
+	lock->lock = 0;
+}
+
+/*
+ * RWLOCKS
+ *
+ *
+ * Write locks are easy - we just set bit 31.  When unlocking, we can
+ * just write zero since the lock is exclusively held.
+ */
+
+static inline void arch_write_lock(arch_rwlock_t *rw)
+{
+	unsigned long flags;
+	unsigned int we_won = 0;
+
+again:
+	__global_lock1(flags);
+	if (rw->lock == 0) {
+		fence();
+		rw->lock = 0x80000000;
+		we_won = 1;
+	}
+	__global_unlock1(flags);
+	if (we_won == 0)
+		goto again;
+	WARN_ON(rw->lock != 0x80000000);
+}
+
+static inline int arch_write_trylock(arch_rwlock_t *rw)
+{
+	unsigned long flags;
+	unsigned int ret;
+
+	__global_lock1(flags);
+	ret = rw->lock;
+	if (ret == 0) {
+		fence();
+		rw->lock = 0x80000000;
+	}
+	__global_unlock1(flags);
+
+	return (ret == 0);
+}
+
+static inline void arch_write_unlock(arch_rwlock_t *rw)
+{
+	barrier();
+	WARN_ON(rw->lock != 0x80000000);
+	rw->lock = 0;
+}
+
+/* write_can_lock - would write_trylock() succeed? */
+static inline int arch_write_can_lock(arch_rwlock_t *rw)
+{
+	unsigned int ret;
+
+	barrier();
+	ret = rw->lock;
+	return (ret == 0);
+}
+
+/*
+ * Read locks are a bit more hairy:
+ *  - Exclusively load the lock value.
+ *  - Increment it.
+ *  - Store new lock value if positive, and we still own this location.
+ *    If the value is negative, we've already failed.
+ *  - If we failed to store the value, we want a negative result.
+ *  - If we failed, try again.
+ * Unlocking is similarly hairy.  We may have multiple read locks
+ * currently active.  However, we know we won't have any write
+ * locks.
+ */
+static inline void arch_read_lock(arch_rwlock_t *rw)
+{
+	unsigned long flags;
+	unsigned int we_won = 0, ret;
+
+again:
+	__global_lock1(flags);
+	ret = rw->lock;
+	if (ret < 0x80000000) {
+		fence();
+		rw->lock = ret + 1;
+		we_won = 1;
+	}
+	__global_unlock1(flags);
+	if (!we_won)
+		goto again;
+}
+
+static inline void arch_read_unlock(arch_rwlock_t *rw)
+{
+	unsigned long flags;
+	unsigned int ret;
+
+	__global_lock1(flags);
+	fence();
+	ret = rw->lock--;
+	__global_unlock1(flags);
+	WARN_ON(ret == 0);
+}
+
+static inline int arch_read_trylock(arch_rwlock_t *rw)
+{
+	unsigned long flags;
+	unsigned int ret;
+
+	__global_lock1(flags);
+	ret = rw->lock;
+	if (ret < 0x80000000) {
+		fence();
+		rw->lock = ret + 1;
+	}
+	__global_unlock1(flags);
+	return (ret < 0x80000000);
+}
+
+/* read_can_lock - would read_trylock() succeed? */
+static inline int arch_read_can_lock(arch_rwlock_t *rw)
+{
+	unsigned int ret;
+
+	barrier();
+	ret = rw->lock;
+	return (ret < 0x80000000);
+}
+
+#endif /* __ASM_SPINLOCK_LOCK1_H */
diff --git a/arch/metag/include/asm/spinlock_types.h b/arch/metag/include/asm/spinlock_types.h
new file mode 100644
index 0000000..b763914
--- /dev/null
+++ b/arch/metag/include/asm/spinlock_types.h
@@ -0,0 +1,20 @@
+#ifndef _ASM_METAG_SPINLOCK_TYPES_H
+#define _ASM_METAG_SPINLOCK_TYPES_H
+
+#ifndef __LINUX_SPINLOCK_TYPES_H
+# error "please don't include this file directly"
+#endif
+
+typedef struct {
+	volatile unsigned int lock;
+} arch_spinlock_t;
+
+#define __ARCH_SPIN_LOCK_UNLOCKED	{ 0 }
+
+typedef struct {
+	volatile unsigned int lock;
+} arch_rwlock_t;
+
+#define __ARCH_RW_LOCK_UNLOCKED		{ 0 }
+
+#endif /* _ASM_METAG_SPINLOCK_TYPES_H */
-- 
1.7.7.6


