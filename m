Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756920Ab0E2Dfi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 23:35:38 -0400
Received: from king.tilera.com ([72.1.168.226]:16063 "EHLO king.tilera.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755391Ab0E2Deu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 23:34:50 -0400
Message-Id: <201005290334.o4T3YMsn029979@farm-0002.internal.tilera.com>
In-Reply-To: <201005200543.o4K5hFRF006079@farm-0002.internal.tilera.com>
References: <201005200543.o4K5hFRF006079@farm-0002.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Fri, 28 May 2010 23:16:48 -0400
Subject: [PATCH 7/8] arch/tile: lib/ directory.
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, torvalds@linux-foundation.org
X-OriginalArrivalTime: 29 May 2010 03:34:22.0827 (UTC) FILETIME=[D468A3B0:01CAFEDF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/lib/Makefile              |   16 +
 arch/tile/lib/__invalidate_icache.S |  106 ++++++
 arch/tile/lib/atomic_32.c           |  347 +++++++++++++++++++
 arch/tile/lib/atomic_asm_32.S       |  197 +++++++++++
 arch/tile/lib/checksum.c            |  102 ++++++
 arch/tile/lib/cpumask.c             |   51 +++
 arch/tile/lib/delay.c               |   34 ++
 arch/tile/lib/exports.c             |   78 +++++
 arch/tile/lib/mb_incoherent.S       |   34 ++
 arch/tile/lib/memchr_32.c           |   68 ++++
 arch/tile/lib/memcpy_32.S           |  628 +++++++++++++++++++++++++++++++++++
 arch/tile/lib/memcpy_tile64.c       |  271 +++++++++++++++
 arch/tile/lib/memmove_32.c          |   63 ++++
 arch/tile/lib/memset_32.c           |  274 +++++++++++++++
 arch/tile/lib/spinlock_32.c         |  221 ++++++++++++
 arch/tile/lib/spinlock_common.h     |   64 ++++
 arch/tile/lib/strchr_32.c           |   66 ++++
 arch/tile/lib/strlen_32.c           |   36 ++
 arch/tile/lib/uaccess.c             |   31 ++
 arch/tile/lib/usercopy_32.S         |  223 +++++++++++++
 20 files changed, 2910 insertions(+), 0 deletions(-)
 create mode 100644 arch/tile/lib/Makefile
 create mode 100644 arch/tile/lib/__invalidate_icache.S
 create mode 100644 arch/tile/lib/atomic_32.c
 create mode 100644 arch/tile/lib/atomic_asm_32.S
 create mode 100644 arch/tile/lib/checksum.c
 create mode 100644 arch/tile/lib/cpumask.c
 create mode 100644 arch/tile/lib/delay.c
 create mode 100644 arch/tile/lib/exports.c
 create mode 100644 arch/tile/lib/mb_incoherent.S
 create mode 100644 arch/tile/lib/memchr_32.c
 create mode 100644 arch/tile/lib/memcpy_32.S
 create mode 100644 arch/tile/lib/memcpy_tile64.c
 create mode 100644 arch/tile/lib/memmove_32.c
 create mode 100644 arch/tile/lib/memset_32.c
 create mode 100644 arch/tile/lib/spinlock_32.c
 create mode 100644 arch/tile/lib/spinlock_common.h
 create mode 100644 arch/tile/lib/strchr_32.c
 create mode 100644 arch/tile/lib/strlen_32.c
 create mode 100644 arch/tile/lib/uaccess.c
 create mode 100644 arch/tile/lib/usercopy_32.S

diff --git a/arch/tile/lib/Makefile b/arch/tile/lib/Makefile
new file mode 100644
index 0000000..ea9c209
--- /dev/null
+++ b/arch/tile/lib/Makefile
@@ -0,0 +1,16 @@
+#
+# Makefile for TILE-specific library files..
+#
+
+lib-y = checksum.o cpumask.o delay.o __invalidate_icache.o \
+	mb_incoherent.o uaccess.o \
+	memcpy_$(BITS).o memchr_$(BITS).o memmove_$(BITS).o memset_$(BITS).o \
+	strchr_$(BITS).o strlen_$(BITS).o
+
+ifneq ($(CONFIG_TILEGX),y)
+lib-y += atomic_32.o atomic_asm_32.o memcpy_tile64.o
+endif
+
+lib-$(CONFIG_SMP) += spinlock_$(BITS).o usercopy_$(BITS).o
+
+obj-$(CONFIG_MODULES) += exports.o
diff --git a/arch/tile/lib/__invalidate_icache.S b/arch/tile/lib/__invalidate_icache.S
new file mode 100644
index 0000000..92e7050
--- /dev/null
+++ b/arch/tile/lib/__invalidate_icache.S
@@ -0,0 +1,106 @@
+/*
+ * Copyright 2010 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ * A routine for synchronizing the instruction and data caches.
+ * Useful for self-modifying code.
+ *
+ * r0 holds the buffer address
+ * r1 holds the size in bytes
+ */
+
+#include <arch/chip.h>
+#include <feedback.h>
+
+#if defined(__NEWLIB__) || defined(__BME__)
+#include <sys/page.h>
+#else
+#include <asm/page.h>
+#endif
+
+#ifdef __tilegx__
+/* Share code among Tile family chips but adjust opcodes appropriately. */
+#define slt cmpltu
+#define bbst blbst
+#define bnezt bnzt
+#endif
+
+#if defined(__tilegx__) && __SIZEOF_POINTER__ == 4
+/* Force 32-bit ops so pointers wrap around appropriately. */
+#define ADD_PTR addx
+#define ADDI_PTR addxi
+#else
+#define ADD_PTR add
+#define ADDI_PTR addi
+#endif
+
+        .section .text.__invalidate_icache, "ax"
+        .global __invalidate_icache
+        .type __invalidate_icache,@function
+        .hidden __invalidate_icache
+        .align 8
+__invalidate_icache:
+        FEEDBACK_ENTER(__invalidate_icache)
+        {
+         ADD_PTR r1, r0, r1       /* end of buffer */
+         blez r1, .Lexit      /* skip out if size <= 0 */
+        }
+        {
+         ADDI_PTR r1, r1, -1      /* point to last byte to flush */
+         andi r0, r0, -CHIP_L1I_LINE_SIZE()  /* align to cache-line size */
+        }
+        {
+         andi r1, r1, -CHIP_L1I_LINE_SIZE()  /* last cache line to flush */
+         mf
+        }
+#if CHIP_L1I_CACHE_SIZE() > PAGE_SIZE
+        {
+         moveli r4, CHIP_L1I_CACHE_SIZE() / PAGE_SIZE  /* loop counter */
+         move r2, r0          /* remember starting address */
+        }
+#endif
+        drain
+	{
+         slt r3, r0, r1       /* set up loop invariant */
+#if CHIP_L1I_CACHE_SIZE() > PAGE_SIZE
+	 moveli r6, PAGE_SIZE
+#endif
+	}
+.Lentry:
+        {
+         icoh r0
+         ADDI_PTR r0, r0, CHIP_L1I_LINE_SIZE()   /* advance buffer */
+        }
+        {
+         slt r3, r0, r1       /* check if buffer < buffer + size */
+         bbst r3, .Lentry     /* loop if buffer < buffer + size */
+        }
+#if CHIP_L1I_CACHE_SIZE() > PAGE_SIZE
+        {
+         ADD_PTR r2, r2, r6
+         ADD_PTR r1, r1, r6
+        }
+	{
+         move r0, r2
+         addi r4, r4, -1
+	}
+	{
+         slt r3, r0, r1        /* set up loop invariant */
+         bnezt r4, .Lentry
+	}
+#endif
+        drain
+.Lexit:
+        jrp lr
+
+.Lend___invalidate_icache:
+        .size __invalidate_icache, \
+		.Lend___invalidate_icache - __invalidate_icache
diff --git a/arch/tile/lib/atomic_32.c b/arch/tile/lib/atomic_32.c
new file mode 100644
index 0000000..be1e8ac
--- /dev/null
+++ b/arch/tile/lib/atomic_32.c
@@ -0,0 +1,347 @@
+/*
+ * Copyright 2010 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ */
+
+#include <linux/cache.h>
+#include <linux/delay.h>
+#include <linux/uaccess.h>
+#include <linux/module.h>
+#include <linux/mm.h>
+#include <asm/atomic.h>
+#include <arch/chip.h>
+
+/* The routines in atomic_asm.S are private, so we only declare them here. */
+extern struct __get_user __atomic_cmpxchg(volatile int *p,
+					  int *lock, int o, int n);
+extern struct __get_user __atomic_xchg(volatile int *p, int *lock, int n);
+extern struct __get_user __atomic_xchg_add(volatile int *p, int *lock, int n);
+extern struct __get_user __atomic_xchg_add_unless(volatile int *p,
+						  int *lock, int o, int n);
+extern struct __get_user __atomic_or(volatile int *p, int *lock, int n);
+extern struct __get_user __atomic_andn(volatile int *p, int *lock, int n);
+extern struct __get_user __atomic_xor(volatile int *p, int *lock, int n);
+
+extern u64 __atomic64_cmpxchg(volatile u64 *p, int *lock, u64 o, u64 n);
+extern u64 __atomic64_xchg(volatile u64 *p, int *lock, u64 n);
+extern u64 __atomic64_xchg_add(volatile u64 *p, int *lock, u64 n);
+extern u64 __atomic64_xchg_add_unless(volatile u64 *p,
+				      int *lock, u64 o, u64 n);
+
+
+/* See <asm/atomic.h> */
+#if ATOMIC_LOCKS_FOUND_VIA_TABLE()
+
+/*
+ * A block of memory containing locks for atomic ops. Each instance of this
+ * struct will be homed on a different CPU.
+ */
+struct atomic_locks_on_cpu {
+	int lock[ATOMIC_HASH_L2_SIZE];
+} __attribute__((aligned(ATOMIC_HASH_L2_SIZE * 4)));
+
+static DEFINE_PER_CPU(struct atomic_locks_on_cpu, atomic_lock_pool);
+
+/* The locks we'll use until __init_atomic_per_cpu is called. */
+static struct atomic_locks_on_cpu __initdata initial_atomic_locks;
+
+/* Hash into this vector to get a pointer to lock for the given atomic. */
+struct atomic_locks_on_cpu *atomic_lock_ptr[ATOMIC_HASH_L1_SIZE]
+	__write_once = {
+	[0 ... ATOMIC_HASH_L1_SIZE-1] (&initial_atomic_locks)
+};
+
+#else /* ATOMIC_LOCKS_FOUND_VIA_TABLE() */
+
+/* This page is remapped on startup to be hash-for-home. */
+int atomic_locks[PAGE_SIZE / sizeof(int) /* Only ATOMIC_HASH_SIZE is used */]
+  __attribute__((aligned(PAGE_SIZE), section(".bss.page_aligned")));
+
+#endif /* ATOMIC_LOCKS_FOUND_VIA_TABLE() */
+
+static inline int *__atomic_hashed_lock(volatile void *v)
+{
+	/* NOTE: this code must match "sys_cmpxchg" in kernel/intvec.S */
+#if ATOMIC_LOCKS_FOUND_VIA_TABLE()
+	unsigned long i =
+		(unsigned long) v & ((PAGE_SIZE-1) & -sizeof(long long));
+	unsigned long n = __insn_crc32_32(0, i);
+
+	/* Grab high bits for L1 index. */
+	unsigned long l1_index = n >> ((sizeof(n) * 8) - ATOMIC_HASH_L1_SHIFT);
+	/* Grab low bits for L2 index. */
+	unsigned long l2_index = n & (ATOMIC_HASH_L2_SIZE - 1);
+
+	return &atomic_lock_ptr[l1_index]->lock[l2_index];
+#else
+	/*
+	 * Use bits [3, 3 + ATOMIC_HASH_SHIFT) as the lock index.
+	 * Using mm works here because atomic_locks is page aligned.
+	 */
+	unsigned long ptr = __insn_mm((unsigned long)v >> 1,
+				      (unsigned long)atomic_locks,
+				      2, (ATOMIC_HASH_SHIFT + 2) - 1);
+	return (int *)ptr;
+#endif
+}
+
+#ifdef CONFIG_SMP
+/* Return whether the passed pointer is a valid atomic lock pointer. */
+static int is_atomic_lock(int *p)
+{
+#if ATOMIC_LOCKS_FOUND_VIA_TABLE()
+	int i;
+	for (i = 0; i < ATOMIC_HASH_L1_SIZE; ++i) {
+
+		if (p >= &atomic_lock_ptr[i]->lock[0] &&
+		    p < &atomic_lock_ptr[i]->lock[ATOMIC_HASH_L2_SIZE]) {
+			return 1;
+		}
+	}
+	return 0;
+#else
+	return p >= &atomic_locks[0] && p < &atomic_locks[ATOMIC_HASH_SIZE];
+#endif
+}
+
+void __atomic_fault_unlock(int *irqlock_word)
+{
+	BUG_ON(!is_atomic_lock(irqlock_word));
+	BUG_ON(*irqlock_word != 1);
+	*irqlock_word = 0;
+}
+
+#endif /* CONFIG_SMP */
+
+static inline int *__atomic_setup(volatile void *v)
+{
+	/* Issue a load to the target to bring it into cache. */
+	*(volatile int *)v;
+	return __atomic_hashed_lock(v);
+}
+
+int _atomic_xchg(atomic_t *v, int n)
+{
+	return __atomic_xchg(&v->counter, __atomic_setup(v), n).val;
+}
+EXPORT_SYMBOL(_atomic_xchg);
+
+int _atomic_xchg_add(atomic_t *v, int i)
+{
+	return __atomic_xchg_add(&v->counter, __atomic_setup(v), i).val;
+}
+EXPORT_SYMBOL(_atomic_xchg_add);
+
+int _atomic_xchg_add_unless(atomic_t *v, int a, int u)
+{
+	/*
+	 * Note: argument order is switched here since it is easier
+	 * to use the first argument consistently as the "old value"
+	 * in the assembly, as is done for _atomic_cmpxchg().
+	 */
+	return __atomic_xchg_add_unless(&v->counter, __atomic_setup(v), u, a)
+		.val;
+}
+EXPORT_SYMBOL(_atomic_xchg_add_unless);
+
+int _atomic_cmpxchg(atomic_t *v, int o, int n)
+{
+	return __atomic_cmpxchg(&v->counter, __atomic_setup(v), o, n).val;
+}
+EXPORT_SYMBOL(_atomic_cmpxchg);
+
+unsigned long _atomic_or(volatile unsigned long *p, unsigned long mask)
+{
+	return __atomic_or((int *)p, __atomic_setup(p), mask).val;
+}
+EXPORT_SYMBOL(_atomic_or);
+
+unsigned long _atomic_andn(volatile unsigned long *p, unsigned long mask)
+{
+	return __atomic_andn((int *)p, __atomic_setup(p), mask).val;
+}
+EXPORT_SYMBOL(_atomic_andn);
+
+unsigned long _atomic_xor(volatile unsigned long *p, unsigned long mask)
+{
+	return __atomic_xor((int *)p, __atomic_setup(p), mask).val;
+}
+EXPORT_SYMBOL(_atomic_xor);
+
+
+u64 _atomic64_xchg(atomic64_t *v, u64 n)
+{
+	return __atomic64_xchg(&v->counter, __atomic_setup(v), n);
+}
+EXPORT_SYMBOL(_atomic64_xchg);
+
+u64 _atomic64_xchg_add(atomic64_t *v, u64 i)
+{
+	return __atomic64_xchg_add(&v->counter, __atomic_setup(v), i);
+}
+EXPORT_SYMBOL(_atomic64_xchg_add);
+
+u64 _atomic64_xchg_add_unless(atomic64_t *v, u64 a, u64 u)
+{
+	/*
+	 * Note: argument order is switched here since it is easier
+	 * to use the first argument consistently as the "old value"
+	 * in the assembly, as is done for _atomic_cmpxchg().
+	 */
+	return __atomic64_xchg_add_unless(&v->counter, __atomic_setup(v),
+					  u, a);
+}
+EXPORT_SYMBOL(_atomic64_xchg_add_unless);
+
+u64 _atomic64_cmpxchg(atomic64_t *v, u64 o, u64 n)
+{
+	return __atomic64_cmpxchg(&v->counter, __atomic_setup(v), o, n);
+}
+EXPORT_SYMBOL(_atomic64_cmpxchg);
+
+
+static inline int *__futex_setup(__user int *v)
+{
+	/*
+	 * Issue a prefetch to the counter to bring it into cache.
+	 * As for __atomic_setup, but we can't do a read into the L1
+	 * since it might fault; instead we do a prefetch into the L2.
+	 */
+	__insn_prefetch(v);
+	return __atomic_hashed_lock(v);
+}
+
+struct __get_user futex_set(int *v, int i)
+{
+	return __atomic_xchg(v, __futex_setup(v), i);
+}
+
+struct __get_user futex_add(int *v, int n)
+{
+	return __atomic_xchg_add(v, __futex_setup(v), n);
+}
+
+struct __get_user futex_or(int *v, int n)
+{
+	return __atomic_or(v, __futex_setup(v), n);
+}
+
+struct __get_user futex_andn(int *v, int n)
+{
+	return __atomic_andn(v, __futex_setup(v), n);
+}
+
+struct __get_user futex_xor(int *v, int n)
+{
+	return __atomic_xor(v, __futex_setup(v), n);
+}
+
+struct __get_user futex_cmpxchg(int *v, int o, int n)
+{
+	return __atomic_cmpxchg(v, __futex_setup(v), o, n);
+}
+
+/*
+ * If any of the atomic or futex routines hit a bad address (not in
+ * the page tables at kernel PL) this routine is called.  The futex
+ * routines are never used on kernel space, and the normal atomics and
+ * bitops are never used on user space.  So a fault on kernel space
+ * must be fatal, but a fault on userspace is a futex fault and we
+ * need to return -EFAULT.  Note that the context this routine is
+ * invoked in is the context of the "_atomic_xxx()" routines called
+ * by the functions in this file.
+ */
+struct __get_user __atomic_bad_address(int *addr)
+{
+	if (unlikely(!access_ok(VERIFY_WRITE, addr, sizeof(int))))
+		panic("Bad address used for kernel atomic op: %p\n", addr);
+	return (struct __get_user) { .err = -EFAULT };
+}
+
+
+#if CHIP_HAS_CBOX_HOME_MAP()
+static int __init noatomichash(char *str)
+{
+	printk("noatomichash is deprecated.\n");
+	return 1;
+}
+__setup("noatomichash", noatomichash);
+#endif
+
+void __init __init_atomic_per_cpu(void)
+{
+#if ATOMIC_LOCKS_FOUND_VIA_TABLE()
+
+	unsigned int i;
+	int actual_cpu;
+
+	/*
+	 * Before this is called from setup, we just have one lock for
+	 * all atomic objects/operations.  Here we replace the
+	 * elements of atomic_lock_ptr so that they point at per_cpu
+	 * integers.  This seemingly over-complex approach stems from
+	 * the fact that DEFINE_PER_CPU defines an entry for each cpu
+	 * in the grid, not each cpu from 0..ATOMIC_HASH_SIZE-1.  But
+	 * for efficient hashing of atomics to their locks we want a
+	 * compile time constant power of 2 for the size of this
+	 * table, so we use ATOMIC_HASH_SIZE.
+	 *
+	 * Here we populate atomic_lock_ptr from the per cpu
+	 * atomic_lock_pool, interspersing by actual cpu so that
+	 * subsequent elements are homed on consecutive cpus.
+	 */
+
+	actual_cpu = cpumask_first(cpu_possible_mask);
+
+	for (i = 0; i < ATOMIC_HASH_L1_SIZE; ++i) {
+		/*
+		 * Preincrement to slightly bias against using cpu 0,
+		 * which has plenty of stuff homed on it already.
+		 */
+		actual_cpu = cpumask_next(actual_cpu, cpu_possible_mask);
+		if (actual_cpu >= nr_cpu_ids)
+			actual_cpu = cpumask_first(cpu_possible_mask);
+
+		atomic_lock_ptr[i] = &per_cpu(atomic_lock_pool, actual_cpu);
+	}
+
+#else /* ATOMIC_LOCKS_FOUND_VIA_TABLE() */
+
+	/* Validate power-of-two and "bigger than cpus" assumption */
+	BUG_ON(ATOMIC_HASH_SIZE & (ATOMIC_HASH_SIZE-1));
+	BUG_ON(ATOMIC_HASH_SIZE < nr_cpu_ids);
+
+	/*
+	 * On TILEPro we prefer to use a single hash-for-home
+	 * page, since this means atomic operations are less
+	 * likely to encounter a TLB fault and thus should
+	 * in general perform faster.  You may wish to disable
+	 * this in situations where few hash-for-home tiles
+	 * are configured.
+	 */
+	BUG_ON((unsigned long)atomic_locks % PAGE_SIZE != 0);
+
+	/* The locks must all fit on one page. */
+	BUG_ON(ATOMIC_HASH_SIZE * sizeof(int) > PAGE_SIZE);
+
+	/*
+	 * We use the page offset of the atomic value's address as
+	 * an index into atomic_locks, excluding the low 3 bits.
+	 * That should not produce more indices than ATOMIC_HASH_SIZE.
+	 */
+	BUG_ON((PAGE_SIZE >> 3) > ATOMIC_HASH_SIZE);
+
+#endif /* ATOMIC_LOCKS_FOUND_VIA_TABLE() */
+
+	/* The futex code makes this assumption, so we validate it here. */
+	BUG_ON(sizeof(atomic_t) != sizeof(int));
+}
diff --git a/arch/tile/lib/atomic_asm_32.S b/arch/tile/lib/atomic_asm_32.S
new file mode 100644
index 0000000..c0d0585
--- /dev/null
+++ b/arch/tile/lib/atomic_asm_32.S
@@ -0,0 +1,197 @@
+/*
+ * Copyright 2010 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ *
+ * Support routines for atomic operations.  Each function takes:
+ *
+ * r0: address to manipulate
+ * r1: pointer to atomic lock guarding this operation (for FUTEX_LOCK_REG)
+ * r2: new value to write, or for cmpxchg/add_unless, value to compare against
+ * r3: (cmpxchg/xchg_add_unless) new value to write or add;
+ *     (atomic64 ops) high word of value to write
+ * r4/r5: (cmpxchg64/add_unless64) new value to write or add
+ *
+ * The 32-bit routines return a "struct __get_user" so that the futex code
+ * has an opportunity to return -EFAULT to the user if needed.
+ * The 64-bit routines just return a "long long" with the value,
+ * since they are only used from kernel space and don't expect to fault.
+ * Support for 16-bit ops is included in the framework but we don't provide
+ * any (x86_64 has an atomic_inc_short(), so we might want to some day).
+ *
+ * Note that the caller is advised to issue a suitable L1 or L2
+ * prefetch on the address being manipulated to avoid extra stalls.
+ * In addition, the hot path is on two icache lines, and we start with
+ * a jump to the second line to make sure they are both in cache so
+ * that we never stall waiting on icache fill while holding the lock.
+ * (This doesn't work out with most 64-bit ops, since they consume
+ * too many bundles, so may take an extra i-cache stall.)
+ *
+ * These routines set the INTERRUPT_CRITICAL_SECTION bit, just
+ * like sys_cmpxchg(), so that NMIs like PERF_COUNT will not interrupt
+ * the code, just page faults.
+ *
+ * If the load or store faults in a way that can be directly fixed in
+ * the do_page_fault_ics() handler (e.g. a vmalloc reference) we fix it
+ * directly, return to the instruction that faulted, and retry it.
+ *
+ * If the load or store faults in a way that potentially requires us
+ * to release the atomic lock, then retry (e.g. a migrating PTE), we
+ * reset the PC in do_page_fault_ics() to the "tns" instruction so
+ * that on return we will reacquire the lock and restart the op.  We
+ * are somewhat overloading the exception_table_entry notion by doing
+ * this, since those entries are not normally used for migrating PTEs.
+ *
+ * If the main page fault handler discovers a bad address, it will see
+ * the PC pointing to the "tns" instruction (due to the earlier
+ * exception_table_entry processing in do_page_fault_ics), and
+ * re-reset the PC to the fault handler, atomic_bad_address(), which
+ * effectively takes over from the atomic op and can either return a
+ * bad "struct __get_user" (for user addresses) or can just panic (for
+ * bad kernel addresses).
+ *
+ * Note that if the value we would store is the same as what we
+ * loaded, we bypass the load.  Other platforms with true atomics can
+ * make the guarantee that a non-atomic __clear_bit(), for example,
+ * can safely race with an atomic test_and_set_bit(); this example is
+ * from bit_spinlock.h in slub_lock() / slub_unlock().  We can't do
+ * that on Tile since the "atomic" op is really just a
+ * read/modify/write, and can race with the non-atomic
+ * read/modify/write.  However, if we can short-circuit the write when
+ * it is not needed, in the atomic case, we avoid the race.
+ */
+
+#include <linux/linkage.h>
+#include <asm/atomic.h>
+#include <asm/page.h>
+#include <asm/processor.h>
+
+	.section .text.atomic,"ax"
+ENTRY(__start_atomic_asm_code)
+
+	.macro  atomic_op, name, bitwidth, body
+	.align  64
+STD_ENTRY_SECTION(__atomic\name, .text.atomic)
+	{
+	 movei  r24, 1
+	 j      4f		/* branch to second cache line */
+	}
+1:	{
+	 .ifc \bitwidth,16
+	 lh     r22, r0
+	 .else
+	 lw     r22, r0
+	 addi   r23, r0, 4
+	 .endif
+	}
+	.ifc \bitwidth,64
+	lw      r23, r23
+	.endif
+	\body /* set r24, and r25 if 64-bit */
+	{
+	 seq    r26, r22, r24
+	 seq    r27, r23, r25
+	}
+	.ifc \bitwidth,64
+	bbnst   r27, 2f
+	.endif
+	bbs     r26, 3f		/* skip write-back if it's the same value */
+2:	{
+	 .ifc \bitwidth,16
+	 sh     r0, r24
+	 .else
+	 sw     r0, r24
+	 addi   r23, r0, 4
+	 .endif
+	}
+	.ifc \bitwidth,64
+	sw      r23, r25
+	.endif
+	mf
+3:	{
+	 move   r0, r22
+	 .ifc \bitwidth,64
+	 move   r1, r23
+	 .else
+	 move   r1, zero
+	 .endif
+	 sw     ATOMIC_LOCK_REG_NAME, zero
+	}
+	mtspr   INTERRUPT_CRITICAL_SECTION, zero
+	jrp     lr
+4:	{
+	 move   ATOMIC_LOCK_REG_NAME, r1
+	 mtspr  INTERRUPT_CRITICAL_SECTION, r24
+	}
+#ifndef CONFIG_SMP
+	j       1b		/* no atomic locks */
+#else
+	{
+	 tns    r21, ATOMIC_LOCK_REG_NAME
+	 moveli r23, 2048       /* maximum backoff time in cycles */
+	}
+	{
+	 bzt    r21, 1b		/* branch if lock acquired */
+	 moveli r25, 32         /* starting backoff time in cycles */
+	}
+5:	mtspr   INTERRUPT_CRITICAL_SECTION, zero
+	mfspr   r26, CYCLE_LOW  /* get start point for this backoff */
+6:	mfspr   r22, CYCLE_LOW  /* test to see if we've backed off enough */
+	sub     r22, r22, r26
+	slt     r22, r22, r25
+	bbst    r22, 6b
+	{
+	 mtspr  INTERRUPT_CRITICAL_SECTION, r24
+	 shli   r25, r25, 1     /* double the backoff; retry the tns */
+	}
+	{
+	 tns    r21, ATOMIC_LOCK_REG_NAME
+	 slt    r26, r23, r25   /* is the proposed backoff too big? */
+	}
+	{
+	 bzt    r21, 1b		/* branch if lock acquired */
+	 mvnz   r25, r26, r23
+	}
+	j       5b
+#endif
+	STD_ENDPROC(__atomic\name)
+	.ifc \bitwidth,32
+	.pushsection __ex_table,"a"
+	.word   1b, __atomic\name
+	.word   2b, __atomic\name
+	.word   __atomic\name, __atomic_bad_address
+	.popsection
+	.endif
+	.endm
+
+atomic_op _cmpxchg, 32, "seq r26, r22, r2; { bbns r26, 3f; move r24, r3 }"
+atomic_op _xchg, 32, "move r24, r2"
+atomic_op _xchg_add, 32, "add r24, r22, r2"
+atomic_op _xchg_add_unless, 32, \
+	"sne r26, r22, r2; { bbns r26, 3f; add r24, r22, r3 }"
+atomic_op _or, 32, "or r24, r22, r2"
+atomic_op _andn, 32, "nor r2, r2, zero; and r24, r22, r2"
+atomic_op _xor, 32, "xor r24, r22, r2"
+
+atomic_op 64_cmpxchg, 64, "{ seq r26, r22, r2; seq r27, r23, r3 }; \
+	{ bbns r26, 3f; move r24, r4 }; { bbns r27, 3f; move r25, r5 }"
+atomic_op 64_xchg, 64, "{ move r24, r2; move r25, r3 }"
+atomic_op 64_xchg_add, 64, "{ add r24, r22, r2; add r25, r23, r3 }; \
+	slt_u r26, r24, r22; add r25, r25, r26"
+atomic_op 64_xchg_add_unless, 64, \
+	"{ sne r26, r22, r2; sne r27, r23, r3 }; \
+	{ bbns r26, 3f; add r24, r22, r4 }; \
+	{ bbns r27, 3f; add r25, r23, r5 }; \
+	slt_u r26, r24, r22; add r25, r25, r26"
+
+	jrp     lr              /* happy backtracer */
+
+ENTRY(__end_atomic_asm_code)
diff --git a/arch/tile/lib/checksum.c b/arch/tile/lib/checksum.c
new file mode 100644
index 0000000..e4bab5b
--- /dev/null
+++ b/arch/tile/lib/checksum.c
@@ -0,0 +1,102 @@
+/*
+ * Copyright 2010 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ * Support code for the main lib/checksum.c.
+ */
+
+#include <net/checksum.h>
+#include <linux/module.h>
+
+static inline unsigned int longto16(unsigned long x)
+{
+	unsigned long ret;
+#ifdef __tilegx__
+	ret = __insn_v2sadu(x, 0);
+	ret = __insn_v2sadu(ret, 0);
+#else
+	ret = __insn_sadh_u(x, 0);
+	ret = __insn_sadh_u(ret, 0);
+#endif
+	return ret;
+}
+
+__wsum do_csum(const unsigned char *buff, int len)
+{
+	int odd, count;
+	unsigned long result = 0;
+
+	if (len <= 0)
+		goto out;
+	odd = 1 & (unsigned long) buff;
+	if (odd) {
+		result = (*buff << 8);
+		len--;
+		buff++;
+	}
+	count = len >> 1;		/* nr of 16-bit words.. */
+	if (count) {
+		if (2 & (unsigned long) buff) {
+			result += *(const unsigned short *)buff;
+			count--;
+			len -= 2;
+			buff += 2;
+		}
+		count >>= 1;		/* nr of 32-bit words.. */
+		if (count) {
+#ifdef __tilegx__
+			if (4 & (unsigned long) buff) {
+				unsigned int w = *(const unsigned int *)buff;
+				result = __insn_v2sadau(result, w, 0);
+				count--;
+				len -= 4;
+				buff += 4;
+			}
+			count >>= 1;		/* nr of 64-bit words.. */
+#endif
+
+			/*
+			 * This algorithm could wrap around for very
+			 * large buffers, but those should be impossible.
+			 */
+			BUG_ON(count >= 65530);
+
+			while (count) {
+				unsigned long w = *(const unsigned long *)buff;
+				count--;
+				buff += sizeof(w);
+#ifdef __tilegx__
+				result = __insn_v2sadau(result, w, 0);
+#else
+				result = __insn_sadah_u(result, w, 0);
+#endif
+			}
+#ifdef __tilegx__
+			if (len & 4) {
+				unsigned int w = *(const unsigned int *)buff;
+				result = __insn_v2sadau(result, w, 0);
+				buff += 4;
+			}
+#endif
+		}
+		if (len & 2) {
+			result += *(const unsigned short *) buff;
+			buff += 2;
+		}
+	}
+	if (len & 1)
+		result += *buff;
+	result = longto16(result);
+	if (odd)
+		result = swab16(result);
+out:
+	return result;
+}
diff --git a/arch/tile/lib/cpumask.c b/arch/tile/lib/cpumask.c
new file mode 100644
index 0000000..af745b3
--- /dev/null
+++ b/arch/tile/lib/cpumask.c
@@ -0,0 +1,51 @@
+/*
+ * Copyright 2010 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ */
+
+#include <linux/cpumask.h>
+#include <linux/ctype.h>
+#include <linux/errno.h>
+
+/*
+ * Allow cropping out bits beyond the end of the array.
+ * Move to "lib" directory if more clients want to use this routine.
+ */
+int bitmap_parselist_crop(const char *bp, unsigned long *maskp, int nmaskbits)
+{
+	unsigned a, b;
+
+	bitmap_zero(maskp, nmaskbits);
+	do {
+		if (!isdigit(*bp))
+			return -EINVAL;
+		a = simple_strtoul(bp, (char **)&bp, 10);
+		b = a;
+		if (*bp == '-') {
+			bp++;
+			if (!isdigit(*bp))
+				return -EINVAL;
+			b = simple_strtoul(bp, (char **)&bp, 10);
+		}
+		if (!(a <= b))
+			return -EINVAL;
+		if (b >= nmaskbits)
+			b = nmaskbits-1;
+		while (a <= b) {
+			set_bit(a, maskp);
+			a++;
+		}
+		if (*bp == ',')
+			bp++;
+	} while (*bp != '\0' && *bp != '\n');
+	return 0;
+}
diff --git a/arch/tile/lib/delay.c b/arch/tile/lib/delay.c
new file mode 100644
index 0000000..5801b03
--- /dev/null
+++ b/arch/tile/lib/delay.c
@@ -0,0 +1,34 @@
+/*
+ * Copyright 2010 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ */
+
+#include <linux/module.h>
+#include <linux/delay.h>
+#include <linux/thread_info.h>
+#include <asm/fixmap.h>
+#include <hv/hypervisor.h>
+
+void __udelay(unsigned long usecs)
+{
+	hv_nanosleep(usecs * 1000);
+}
+EXPORT_SYMBOL(__udelay);
+
+void __ndelay(unsigned long nsecs)
+{
+	hv_nanosleep(nsecs);
+}
+EXPORT_SYMBOL(__ndelay);
+
+/* FIXME: should be declared in a header somewhere. */
+EXPORT_SYMBOL(__delay);
diff --git a/arch/tile/lib/exports.c b/arch/tile/lib/exports.c
new file mode 100644
index 0000000..af8e70e
--- /dev/null
+++ b/arch/tile/lib/exports.c
@@ -0,0 +1,78 @@
+/*
+ * Copyright 2010 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ *
+ * Exports from assembler code and from libtile-cc.
+ */
+
+#include <linux/module.h>
+
+/* arch/tile/lib/usercopy.S */
+#include <linux/uaccess.h>
+EXPORT_SYMBOL(__get_user_1);
+EXPORT_SYMBOL(__get_user_2);
+EXPORT_SYMBOL(__get_user_4);
+EXPORT_SYMBOL(__put_user_1);
+EXPORT_SYMBOL(__put_user_2);
+EXPORT_SYMBOL(__put_user_4);
+EXPORT_SYMBOL(__put_user_8);
+EXPORT_SYMBOL(strnlen_user_asm);
+EXPORT_SYMBOL(strncpy_from_user_asm);
+EXPORT_SYMBOL(clear_user_asm);
+
+/* arch/tile/kernel/entry.S */
+#include <linux/kernel.h>
+#include <asm/processor.h>
+EXPORT_SYMBOL(current_text_addr);
+EXPORT_SYMBOL(dump_stack);
+
+/* arch/tile/lib/__memcpy.S */
+/* NOTE: on TILE64, these symbols appear in arch/tile/lib/memcpy_tile64.c */
+EXPORT_SYMBOL(memcpy);
+EXPORT_SYMBOL(__copy_to_user_inatomic);
+EXPORT_SYMBOL(__copy_from_user_inatomic);
+EXPORT_SYMBOL(__copy_from_user_zeroing);
+
+/* hypervisor glue */
+#include <hv/hypervisor.h>
+EXPORT_SYMBOL(hv_dev_open);
+EXPORT_SYMBOL(hv_dev_pread);
+EXPORT_SYMBOL(hv_dev_pwrite);
+EXPORT_SYMBOL(hv_dev_close);
+
+/* -ltile-cc */
+uint32_t __udivsi3(uint32_t dividend, uint32_t divisor);
+EXPORT_SYMBOL(__udivsi3);
+int32_t __divsi3(int32_t dividend, int32_t divisor);
+EXPORT_SYMBOL(__divsi3);
+uint64_t __udivdi3(uint64_t dividend, uint64_t divisor);
+EXPORT_SYMBOL(__udivdi3);
+int64_t __divdi3(int64_t dividend, int64_t divisor);
+EXPORT_SYMBOL(__divdi3);
+uint32_t __umodsi3(uint32_t dividend, uint32_t divisor);
+EXPORT_SYMBOL(__umodsi3);
+int32_t __modsi3(int32_t dividend, int32_t divisor);
+EXPORT_SYMBOL(__modsi3);
+uint64_t __umoddi3(uint64_t dividend, uint64_t divisor);
+EXPORT_SYMBOL(__umoddi3);
+int64_t __moddi3(int64_t dividend, int64_t divisor);
+EXPORT_SYMBOL(__moddi3);
+#ifndef __tilegx__
+uint64_t __ll_mul(uint64_t n0, uint64_t n1);
+EXPORT_SYMBOL(__ll_mul);
+#endif
+#ifndef __tilegx__
+int64_t __muldi3(int64_t, int64_t);
+EXPORT_SYMBOL(__muldi3);
+uint64_t __lshrdi3(uint64_t, unsigned int);
+EXPORT_SYMBOL(__lshrdi3);
+#endif
diff --git a/arch/tile/lib/mb_incoherent.S b/arch/tile/lib/mb_incoherent.S
new file mode 100644
index 0000000..989ad7b
--- /dev/null
+++ b/arch/tile/lib/mb_incoherent.S
@@ -0,0 +1,34 @@
+/*
+ * Copyright 2010 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ *
+ * Assembly code for invoking the HV's fence_incoherent syscall.
+ */
+
+#include <linux/linkage.h>
+#include <hv/syscall_public.h>
+#include <arch/abi.h>
+#include <arch/chip.h>
+
+#if !CHIP_HAS_MF_WAITS_FOR_VICTIMS()
+
+/*
+ * Invoke the hypervisor's fence_incoherent syscall, which guarantees
+ * that all victims for cachelines homed on this tile have reached memory.
+ */
+STD_ENTRY(__mb_incoherent)
+	moveli TREG_SYSCALL_NR_NAME, HV_SYS_fence_incoherent
+	swint2
+	jrp lr
+	STD_ENDPROC(__mb_incoherent)
+
+#endif
diff --git a/arch/tile/lib/memchr_32.c b/arch/tile/lib/memchr_32.c
new file mode 100644
index 0000000..6235283
--- /dev/null
+++ b/arch/tile/lib/memchr_32.c
@@ -0,0 +1,68 @@
+/*
+ * Copyright 2010 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ */
+
+#include <linux/types.h>
+#include <linux/string.h>
+#include <linux/module.h>
+
+void *memchr(const void *s, int c, size_t n)
+{
+	/* Get an aligned pointer. */
+	const uintptr_t s_int = (uintptr_t) s;
+	const uint32_t *p = (const uint32_t *)(s_int & -4);
+
+	/* Create four copies of the byte for which we are looking. */
+	const uint32_t goal = 0x01010101 * (uint8_t) c;
+
+	/* Read the first word, but munge it so that bytes before the array
+	 * will not match goal.
+	 *
+	 * Note that this shift count expression works because we know
+	 * shift counts are taken mod 32.
+	 */
+	const uint32_t before_mask = (1 << (s_int << 3)) - 1;
+	uint32_t v = (*p | before_mask) ^ (goal & before_mask);
+
+	/* Compute the address of the last byte. */
+	const char *const last_byte_ptr = (const char *)s + n - 1;
+
+	/* Compute the address of the word containing the last byte. */
+	const uint32_t *const last_word_ptr =
+	    (const uint32_t *)((uintptr_t) last_byte_ptr & -4);
+
+	uint32_t bits;
+	char *ret;
+
+	if (__builtin_expect(n == 0, 0)) {
+		/* Don't dereference any memory if the array is empty. */
+		return NULL;
+	}
+
+	while ((bits = __insn_seqb(v, goal)) == 0) {
+		if (__builtin_expect(p == last_word_ptr, 0)) {
+			/* We already read the last word in the array,
+			 * so give up.
+			 */
+			return NULL;
+		}
+		v = *++p;
+	}
+
+	/* We found a match, but it might be in a byte past the end
+	 * of the array.
+	 */
+	ret = ((char *)p) + (__insn_ctz(bits) >> 3);
+	return (ret <= last_byte_ptr) ? ret : NULL;
+}
+EXPORT_SYMBOL(memchr);
diff --git a/arch/tile/lib/memcpy_32.S b/arch/tile/lib/memcpy_32.S
new file mode 100644
index 0000000..f92984b
--- /dev/null
+++ b/arch/tile/lib/memcpy_32.S
@@ -0,0 +1,628 @@
+/*
+ * Copyright 2010 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ *
+ * This file shares the implementation of the userspace memcpy and
+ * the kernel's memcpy, copy_to_user and copy_from_user.
+ */
+
+#include <arch/chip.h>
+
+#if CHIP_HAS_WH64() || defined(MEMCPY_TEST_WH64)
+#define MEMCPY_USE_WH64
+#endif
+
+
+#include <linux/linkage.h>
+
+/* On TILE64, we wrap these functions via arch/tile/lib/memcpy_tile64.c */
+#if !CHIP_HAS_COHERENT_LOCAL_CACHE()
+#define memcpy __memcpy_asm
+#define __copy_to_user_inatomic __copy_to_user_inatomic_asm
+#define __copy_from_user_inatomic __copy_from_user_inatomic_asm
+#define __copy_from_user_zeroing __copy_from_user_zeroing_asm
+#endif
+
+#define IS_MEMCPY	  0
+#define IS_COPY_FROM_USER  1
+#define IS_COPY_FROM_USER_ZEROING  2
+#define IS_COPY_TO_USER   -1
+
+	.section .text.memcpy_common, "ax"
+	.align 64
+
+/* Use this to preface each bundle that can cause an exception so
+ * the kernel can clean up properly. The special cleanup code should
+ * not use these, since it knows what it is doing.
+ */
+#define EX \
+	.pushsection __ex_table, "a"; \
+	.word 9f, memcpy_common_fixup; \
+	.popsection; \
+	9
+
+
+/* __copy_from_user_inatomic takes the kernel target address in r0,
+ * the user source in r1, and the bytes to copy in r2.
+ * It returns the number of uncopiable bytes (hopefully zero) in r0.
+ */
+ENTRY(__copy_from_user_inatomic)
+.type __copy_from_user_inatomic, @function
+        FEEDBACK_ENTER_EXPLICIT(__copy_from_user_inatomic, \
+	  .text.memcpy_common, \
+          .Lend_memcpy_common - __copy_from_user_inatomic)
+	{ movei r29, IS_COPY_FROM_USER; j memcpy_common }
+	.size __copy_from_user_inatomic, . - __copy_from_user_inatomic
+
+/* __copy_from_user_zeroing is like __copy_from_user_inatomic, but
+ * any uncopiable bytes are zeroed in the target.
+ */
+ENTRY(__copy_from_user_zeroing)
+.type __copy_from_user_zeroing, @function
+        FEEDBACK_REENTER(__copy_from_user_inatomic)
+	{ movei r29, IS_COPY_FROM_USER_ZEROING; j memcpy_common }
+	.size __copy_from_user_zeroing, . - __copy_from_user_zeroing
+
+/* __copy_to_user_inatomic takes the user target address in r0,
+ * the kernel source in r1, and the bytes to copy in r2.
+ * It returns the number of uncopiable bytes (hopefully zero) in r0.
+ */
+ENTRY(__copy_to_user_inatomic)
+.type __copy_to_user_inatomic, @function
+        FEEDBACK_REENTER(__copy_from_user_inatomic)
+	{ movei r29, IS_COPY_TO_USER; j memcpy_common }
+	.size __copy_to_user_inatomic, . - __copy_to_user_inatomic
+
+ENTRY(memcpy)
+.type memcpy, @function
+        FEEDBACK_REENTER(__copy_from_user_inatomic)
+	{ movei r29, IS_MEMCPY }
+	.size memcpy, . - memcpy
+	/* Fall through */
+
+	.type memcpy_common, @function
+memcpy_common:
+	/* On entry, r29 holds one of the IS_* macro values from above. */
+
+
+	/* r0 is the dest, r1 is the source, r2 is the size. */
+
+	/* Save aside original dest so we can return it at the end. */
+	{ sw sp, lr; move r23, r0; or r4, r0, r1 }
+
+	/* Check for an empty size. */
+	{ bz r2, .Ldone; andi r4, r4, 3 }
+
+	/* Save aside original values in case of a fault. */
+	{ move r24, r1; move r25, r2 }
+	move r27, lr
+
+	/* Check for an unaligned source or dest. */
+	{ bnz r4, .Lcopy_unaligned_maybe_many; addli r4, r2, -256 }
+
+.Lcheck_aligned_copy_size:
+	/* If we are copying < 256 bytes, branch to simple case. */
+	{ blzt r4, .Lcopy_8_check; slti_u r8, r2, 8 }
+
+	/* Copying >= 256 bytes, so jump to complex prefetching loop. */
+	{ andi r6, r1, 63; j .Lcopy_many }
+
+/*
+ *
+ * Aligned 4 byte at a time copy loop
+ *
+ */
+
+.Lcopy_8_loop:
+	/* Copy two words at a time to hide load latency. */
+EX:	{ lw r3, r1; addi r1, r1, 4; slti_u r8, r2, 16 }
+EX:	{ lw r4, r1; addi r1, r1, 4 }
+EX:	{ sw r0, r3; addi r0, r0, 4; addi r2, r2, -4 }
+EX:	{ sw r0, r4; addi r0, r0, 4; addi r2, r2, -4 }
+.Lcopy_8_check:
+	{ bzt r8, .Lcopy_8_loop; slti_u r4, r2, 4 }
+
+	/* Copy odd leftover word, if any. */
+	{ bnzt r4, .Lcheck_odd_stragglers }
+EX:	{ lw r3, r1; addi r1, r1, 4 }
+EX:	{ sw r0, r3; addi r0, r0, 4; addi r2, r2, -4 }
+
+.Lcheck_odd_stragglers:
+	{ bnz r2, .Lcopy_unaligned_few }
+
+.Ldone:
+	/* For memcpy return original dest address, else zero. */
+	{ mz r0, r29, r23; jrp lr }
+
+
+/*
+ *
+ * Prefetching multiple cache line copy handler (for large transfers).
+ *
+ */
+
+	/* Copy words until r1 is cache-line-aligned. */
+.Lalign_loop:
+EX:	{ lw r3, r1; addi r1, r1, 4 }
+	{ andi r6, r1, 63 }
+EX:	{ sw r0, r3; addi r0, r0, 4; addi r2, r2, -4 }
+.Lcopy_many:
+	{ bnzt r6, .Lalign_loop; addi r9, r0, 63 }
+
+	{ addi r3, r1, 60; andi r9, r9, -64 }
+
+#ifdef MEMCPY_USE_WH64
+        /* No need to prefetch dst, we'll just do the wh64
+         * right before we copy a line.
+	 */
+#endif
+
+EX:	{ lw r5, r3; addi r3, r3, 64; movei r4, 1 }
+        /* Intentionally stall for a few cycles to leave L2 cache alone. */
+        { bnzt zero, .; move r27, lr }
+EX:	{ lw r6, r3; addi r3, r3, 64 }
+        /* Intentionally stall for a few cycles to leave L2 cache alone. */
+        { bnzt zero, . }
+EX:	{ lw r7, r3; addi r3, r3, 64 }
+#ifndef MEMCPY_USE_WH64
+        /* Prefetch the dest */
+        /* Intentionally stall for a few cycles to leave L2 cache alone. */
+        { bnzt zero, . }
+        /* Use a real load to cause a TLB miss if necessary.  We aren't using
+         * r28, so this should be fine.
+         */
+EX:	{ lw r28, r9; addi r9, r9, 64 }
+        /* Intentionally stall for a few cycles to leave L2 cache alone. */
+        { bnzt zero, . }
+        { prefetch r9; addi r9, r9, 64 }
+        /* Intentionally stall for a few cycles to leave L2 cache alone. */
+        { bnzt zero, . }
+        { prefetch r9; addi r9, r9, 64 }
+#endif
+        /* Intentionally stall for a few cycles to leave L2 cache alone. */
+        { bz zero, .Lbig_loop2 }
+
+	/* On entry to this loop:
+	 * - r0 points to the start of dst line 0
+	 * - r1 points to start of src line 0
+	 * - r2 >= (256 - 60), only the first time the loop trips.
+	 * - r3 contains r1 + 128 + 60    [pointer to end of source line 2]
+	 *   This is our prefetch address. When we get near the end
+	 *   rather than prefetching off the end this is changed to point
+	 *   to some "safe" recently loaded address.
+	 * - r5 contains *(r1 + 60)       [i.e. last word of source line 0]
+	 * - r6 contains *(r1 + 64 + 60)  [i.e. last word of source line 1]
+         * - r9 contains ((r0 + 63) & -64)
+	 *     [start of next dst cache line.]
+	 */
+
+.Lbig_loop:
+	{ jal .Lcopy_line2; add r15, r1, r2 }
+
+.Lbig_loop2:
+	/* Copy line 0, first stalling until r5 is ready. */
+EX:	{ move r12, r5; lw r16, r1 }
+	{ bz r4, .Lcopy_8_check; slti_u r8, r2, 8 }
+        /* Prefetch several lines ahead. */
+EX:	{ lw r5, r3; addi r3, r3, 64 }
+        { jal .Lcopy_line }
+
+	/* Copy line 1, first stalling until r6 is ready. */
+EX:	{ move r12, r6; lw r16, r1 }
+	{ bz r4, .Lcopy_8_check; slti_u r8, r2, 8 }
+        /* Prefetch several lines ahead. */
+EX:	{ lw r6, r3; addi r3, r3, 64 }
+	{ jal .Lcopy_line }
+
+	/* Copy line 2, first stalling until r7 is ready. */
+EX:	{ move r12, r7; lw r16, r1 }
+	{ bz r4, .Lcopy_8_check; slti_u r8, r2, 8 }
+        /* Prefetch several lines ahead. */
+EX:	{ lw r7, r3; addi r3, r3, 64 }
+        /* Use up a caches-busy cycle by jumping back to the top of the
+         * loop. Might as well get it out of the way now.
+         */
+        { j .Lbig_loop }
+
+
+	/* On entry:
+	 * - r0 points to the destination line.
+	 * - r1 points to the source line.
+         * - r3 is the next prefetch address.
+	 * - r9 holds the last address used for wh64.
+	 * - r12 = WORD_15
+         * - r16 = WORD_0.
+         * - r17 == r1 + 16.
+         * - r27 holds saved lr to restore.
+	 *
+	 * On exit:
+	 * - r0 is incremented by 64.
+	 * - r1 is incremented by 64, unless that would point to a word
+         *   beyond the end of the source array, in which case it is redirected
+         *   to point to an arbitrary word already in the cache.
+	 * - r2 is decremented by 64.
+         * - r3 is unchanged, unless it points to a word beyond the
+         *   end of the source array, in which case it is redirected
+         *   to point to an arbitrary word already in the cache.
+         *   Redirecting is OK since if we are that close to the end
+         *   of the array we will not come back to this subroutine
+         *   and use the contents of the prefetched address.
+	 * - r4 is nonzero iff r2 >= 64.
+         * - r9 is incremented by 64, unless it points beyond the
+         *   end of the last full destination cache line, in which
+         *   case it is redirected to a "safe address" that can be
+         *   clobbered (sp - 64)
+	 * - lr contains the value in r27.
+	 */
+
+/* r26 unused */
+
+.Lcopy_line:
+        /* TODO: when r3 goes past the end, we would like to redirect it
+         * to prefetch the last partial cache line (if any) just once, for the
+         * benefit of the final cleanup loop. But we don't want to
+         * prefetch that line more than once, or subsequent prefetches
+         * will go into the RTF. But then .Lbig_loop should unconditionally
+         * branch to top of loop to execute final prefetch, and its
+         * nop should become a conditional branch.
+         */
+
+        /* We need two non-memory cycles here to cover the resources
+         * used by the loads initiated by the caller.
+         */
+        { add r15, r1, r2 }
+.Lcopy_line2:
+        { slt_u r13, r3, r15; addi r17, r1, 16 }
+
+        /* NOTE: this will stall for one cycle as L1 is busy. */
+
+        /* Fill second L1D line. */
+EX:	{ lw r17, r17; addi r1, r1, 48; mvz r3, r13, r1 } /* r17 = WORD_4 */
+
+#ifdef MEMCPY_TEST_WH64
+        /* Issue a fake wh64 that clobbers the destination words
+         * with random garbage, for testing.
+         */
+	{ movei r19, 64; crc32_32 r10, r2, r9 }
+.Lwh64_test_loop:
+EX:	{ sw r9, r10; addi r9, r9, 4; addi r19, r19, -4 }
+        { bnzt r19, .Lwh64_test_loop; crc32_32 r10, r10, r19 }
+#elif CHIP_HAS_WH64()
+        /* Prepare destination line for writing. */
+EX:	{ wh64 r9; addi r9, r9, 64 }
+#else
+        /* Prefetch dest line */
+	{ prefetch r9; addi r9, r9, 64 }
+#endif
+        /* Load seven words that are L1D hits to cover wh64 L2 usage. */
+
+        /* Load the three remaining words from the last L1D line, which
+         * we know has already filled the L1D.
+         */
+EX:	{ lw r4, r1;  addi r1, r1, 4;   addi r20, r1, 16 }   /* r4 = WORD_12 */
+EX:	{ lw r8, r1;  addi r1, r1, 4;   slt_u r13, r20, r15 }/* r8 = WORD_13 */
+EX:	{ lw r11, r1; addi r1, r1, -52; mvz r20, r13, r1 }  /* r11 = WORD_14 */
+
+        /* Load the three remaining words from the first L1D line, first
+         * stalling until it has filled by "looking at" r16.
+         */
+EX:	{ lw r13, r1; addi r1, r1, 4; move zero, r16 }   /* r13 = WORD_1 */
+EX:	{ lw r14, r1; addi r1, r1, 4 }                   /* r14 = WORD_2 */
+EX:	{ lw r15, r1; addi r1, r1, 8; addi r10, r0, 60 } /* r15 = WORD_3 */
+
+        /* Load second word from the second L1D line, first
+         * stalling until it has filled by "looking at" r17.
+         */
+EX:	{ lw r19, r1; addi r1, r1, 4; move zero, r17 }  /* r19 = WORD_5 */
+
+        /* Store last word to the destination line, potentially dirtying it
+         * for the first time, which keeps the L2 busy for two cycles.
+         */
+EX:	{ sw r10, r12 }                                 /* store(WORD_15) */
+
+        /* Use two L1D hits to cover the sw L2 access above. */
+EX:	{ lw r10, r1; addi r1, r1, 4 }                  /* r10 = WORD_6 */
+EX:	{ lw r12, r1; addi r1, r1, 4 }                  /* r12 = WORD_7 */
+
+        /* Fill third L1D line. */
+EX:	{ lw r18, r1; addi r1, r1, 4 }                  /* r18 = WORD_8 */
+
+        /* Store first L1D line. */
+EX:	{ sw r0, r16; addi r0, r0, 4; add r16, r0, r2 } /* store(WORD_0) */
+EX:	{ sw r0, r13; addi r0, r0, 4; andi r16, r16, -64 } /* store(WORD_1) */
+EX:	{ sw r0, r14; addi r0, r0, 4; slt_u r16, r9, r16 } /* store(WORD_2) */
+#ifdef MEMCPY_USE_WH64
+EX:	{ sw r0, r15; addi r0, r0, 4; addi r13, sp, -64 } /* store(WORD_3) */
+#else
+        /* Back up the r9 to a cache line we are already storing to
+	 * if it gets past the end of the dest vector.  Strictly speaking,
+	 * we don't need to back up to the start of a cache line, but it's free
+	 * and tidy, so why not?
+         */
+EX:	{ sw r0, r15; addi r0, r0, 4; andi r13, r0, -64 } /* store(WORD_3) */
+#endif
+        /* Store second L1D line. */
+EX:	{ sw r0, r17; addi r0, r0, 4; mvz r9, r16, r13 }/* store(WORD_4) */
+EX:	{ sw r0, r19; addi r0, r0, 4 }                  /* store(WORD_5) */
+EX:	{ sw r0, r10; addi r0, r0, 4 }                  /* store(WORD_6) */
+EX:	{ sw r0, r12; addi r0, r0, 4 }                  /* store(WORD_7) */
+
+EX:	{ lw r13, r1; addi r1, r1, 4; move zero, r18 }  /* r13 = WORD_9 */
+EX:	{ lw r14, r1; addi r1, r1, 4 }                  /* r14 = WORD_10 */
+EX:	{ lw r15, r1; move r1, r20   }                  /* r15 = WORD_11 */
+
+        /* Store third L1D line. */
+EX:	{ sw r0, r18; addi r0, r0, 4 }                  /* store(WORD_8) */
+EX:	{ sw r0, r13; addi r0, r0, 4 }                  /* store(WORD_9) */
+EX:	{ sw r0, r14; addi r0, r0, 4 }                  /* store(WORD_10) */
+EX:	{ sw r0, r15; addi r0, r0, 4 }                  /* store(WORD_11) */
+
+        /* Store rest of fourth L1D line. */
+EX:	{ sw r0, r4;  addi r0, r0, 4 }                  /* store(WORD_12) */
+        {
+EX:	sw r0, r8                                       /* store(WORD_13) */
+        addi r0, r0, 4
+	/* Will r2 be > 64 after we subtract 64 below? */
+        shri r4, r2, 7
+        }
+        {
+EX:	sw r0, r11                                      /* store(WORD_14) */
+        addi r0, r0, 8
+        /* Record 64 bytes successfully copied. */
+        addi r2, r2, -64
+        }
+
+	{ jrp lr; move lr, r27 }
+
+        /* Convey to the backtrace library that the stack frame is size
+	 * zero, and the real return address is on the stack rather than
+	 * in 'lr'.
+	 */
+	{ info 8 }
+
+	.align 64
+.Lcopy_unaligned_maybe_many:
+	/* Skip the setup overhead if we aren't copying many bytes. */
+	{ slti_u r8, r2, 20; sub r4, zero, r0 }
+	{ bnzt r8, .Lcopy_unaligned_few; andi r4, r4, 3 }
+	{ bz r4, .Ldest_is_word_aligned; add r18, r1, r2 }
+
+/*
+ *
+ * unaligned 4 byte at a time copy handler.
+ *
+ */
+
+	/* Copy single bytes until r0 == 0 mod 4, so we can store words. */
+.Lalign_dest_loop:
+EX:	{ lb_u r3, r1; addi r1, r1, 1; addi r4, r4, -1 }
+EX:	{ sb r0, r3;   addi r0, r0, 1; addi r2, r2, -1 }
+	{ bnzt r4, .Lalign_dest_loop; andi r3, r1, 3 }
+
+	/* If source and dest are now *both* aligned, do an aligned copy. */
+	{ bz r3, .Lcheck_aligned_copy_size; addli r4, r2, -256 }
+
+.Ldest_is_word_aligned:
+
+#if CHIP_HAS_DWORD_ALIGN()
+EX:	{ andi r8, r0, 63; lwadd_na r6, r1, 4}
+	{ slti_u r9, r2, 64; bz r8, .Ldest_is_L2_line_aligned }
+
+	/* This copies unaligned words until either there are fewer
+	 * than 4 bytes left to copy, or until the destination pointer
+	 * is cache-aligned, whichever comes first.
+	 *
+	 * On entry:
+	 * - r0 is the next store address.
+	 * - r1 points 4 bytes past the load address corresponding to r0.
+	 * - r2 >= 4
+	 * - r6 is the next aligned word loaded.
+	 */
+.Lcopy_unaligned_src_words:
+EX:	{ lwadd_na r7, r1, 4; slti_u r8, r2, 4 + 4 }
+	/* stall */
+	{ dword_align r6, r7, r1; slti_u r9, r2, 64 + 4 }
+EX:	{ swadd r0, r6, 4; addi r2, r2, -4 }
+	{ bnz r8, .Lcleanup_unaligned_words; andi r8, r0, 63 }
+	{ bnzt r8, .Lcopy_unaligned_src_words; move r6, r7 }
+
+	/* On entry:
+	 * - r0 is the next store address.
+	 * - r1 points 4 bytes past the load address corresponding to r0.
+	 * - r2 >= 4 (# of bytes left to store).
+	 * - r6 is the next aligned src word value.
+	 * - r9 = (r2 < 64U).
+	 * - r18 points one byte past the end of source memory.
+	 */
+.Ldest_is_L2_line_aligned:
+
+	{
+	/* Not a full cache line remains. */
+	bnz r9, .Lcleanup_unaligned_words
+	move r7, r6
+	}
+
+	/* r2 >= 64 */
+
+	/* Kick off two prefetches, but don't go past the end. */
+	{ addi r3, r1, 63 - 4; addi r8, r1, 64 + 63 - 4 }
+	{ prefetch r3; move r3, r8; slt_u r8, r8, r18 }
+	{ mvz r3, r8, r1; addi r8, r3, 64 }
+	{ prefetch r3; move r3, r8; slt_u r8, r8, r18 }
+	{ mvz r3, r8, r1; movei r17, 0 }
+
+.Lcopy_unaligned_line:
+	/* Prefetch another line. */
+	{ prefetch r3; addi r15, r1, 60; addi r3, r3, 64 }
+	/* Fire off a load of the last word we are about to copy. */
+EX:	{ lw_na r15, r15; slt_u r8, r3, r18 }
+
+EX:	{ mvz r3, r8, r1; wh64 r0 }
+
+	/* This loop runs twice.
+	 *
+	 * On entry:
+	 * - r17 is even before the first iteration, and odd before
+	 *   the second.  It is incremented inside the loop.  Encountering
+	 *   an even value at the end of the loop makes it stop.
+	 */
+.Lcopy_half_an_unaligned_line:
+EX:	{
+	/* Stall until the last byte is ready. In the steady state this
+	 * guarantees all words to load below will be in the L2 cache, which
+	 * avoids shunting the loads to the RTF.
+	 */
+	move zero, r15
+	lwadd_na r7, r1, 16
+	}
+EX:	{ lwadd_na r11, r1, 12 }
+EX:	{ lwadd_na r14, r1, -24 }
+EX:	{ lwadd_na r8, r1, 4 }
+EX:	{ lwadd_na r9, r1, 4 }
+EX:	{
+	lwadd_na r10, r1, 8
+	/* r16 = (r2 < 64), after we subtract 32 from r2 below. */
+	slti_u r16, r2, 64 + 32
+	}
+EX:	{ lwadd_na r12, r1, 4; addi r17, r17, 1 }
+EX:	{ lwadd_na r13, r1, 8; dword_align r6, r7, r1 }
+EX:	{ swadd r0, r6,  4; dword_align r7,  r8,  r1 }
+EX:	{ swadd r0, r7,  4; dword_align r8,  r9,  r1 }
+EX:	{ swadd r0, r8,  4; dword_align r9,  r10, r1 }
+EX:	{ swadd r0, r9,  4; dword_align r10, r11, r1 }
+EX:	{ swadd r0, r10, 4; dword_align r11, r12, r1 }
+EX:	{ swadd r0, r11, 4; dword_align r12, r13, r1 }
+EX:	{ swadd r0, r12, 4; dword_align r13, r14, r1 }
+EX:	{ swadd r0, r13, 4; addi r2, r2, -32 }
+	{ move r6, r14; bbst r17, .Lcopy_half_an_unaligned_line }
+
+	{ bzt r16, .Lcopy_unaligned_line; move r7, r6 }
+
+	/* On entry:
+	 * - r0 is the next store address.
+	 * - r1 points 4 bytes past the load address corresponding to r0.
+	 * - r2 >= 0 (# of bytes left to store).
+	 * - r7 is the next aligned src word value.
+	 */
+.Lcleanup_unaligned_words:
+	/* Handle any trailing bytes. */
+	{ bz r2, .Lcopy_unaligned_done; slti_u r8, r2, 4 }
+	{ bzt r8, .Lcopy_unaligned_src_words; move r6, r7 }
+
+	/* Move r1 back to the point where it corresponds to r0. */
+	{ addi r1, r1, -4 }
+
+#else /* !CHIP_HAS_DWORD_ALIGN() */
+
+	/* Compute right/left shift counts and load initial source words. */
+	{ andi r5, r1, -4; andi r3, r1, 3 }
+EX:	{ lw r6, r5; addi r5, r5, 4; shli r3, r3, 3 }
+EX:	{ lw r7, r5; addi r5, r5, 4; sub r4, zero, r3 }
+
+	/* Load and store one word at a time, using shifts and ORs
+	 * to correct for the misaligned src.
+	 */
+.Lcopy_unaligned_src_loop:
+	{ shr r6, r6, r3; shl r8, r7, r4 }
+EX:	{ lw r7, r5; or r8, r8, r6; move r6, r7 }
+EX:	{ sw r0, r8; addi r0, r0, 4; addi r2, r2, -4 }
+	{ addi r5, r5, 4; slti_u r8, r2, 8 }
+	{ bzt r8, .Lcopy_unaligned_src_loop; addi r1, r1, 4 }
+
+	{ bz r2, .Lcopy_unaligned_done }
+#endif /* !CHIP_HAS_DWORD_ALIGN() */
+
+	/* Fall through */
+
+/*
+ *
+ * 1 byte at a time copy handler.
+ *
+ */
+
+.Lcopy_unaligned_few:
+EX:	{ lb_u r3, r1; addi r1, r1, 1 }
+EX:	{ sb r0, r3;   addi r0, r0, 1; addi r2, r2, -1 }
+	{ bnzt r2, .Lcopy_unaligned_few }
+
+.Lcopy_unaligned_done:
+
+	/* For memcpy return original dest address, else zero. */
+	{ mz r0, r29, r23; jrp lr }
+
+.Lend_memcpy_common:
+	.size memcpy_common, .Lend_memcpy_common - memcpy_common
+
+	.section .fixup,"ax"
+memcpy_common_fixup:
+	.type memcpy_common_fixup, @function
+
+	/* Skip any bytes we already successfully copied.
+	 * r2 (num remaining) is correct, but r0 (dst) and r1 (src)
+	 * may not be quite right because of unrolling and prefetching.
+	 * So we need to recompute their values as the address just
+	 * after the last byte we are sure was successfully loaded and
+	 * then stored.
+	 */
+
+	/* Determine how many bytes we successfully copied. */
+	{ sub r3, r25, r2 }
+
+	/* Add this to the original r0 and r1 to get their new values. */
+	{ add r0, r23, r3; add r1, r24, r3 }
+
+	{ bzt r29, memcpy_fixup_loop }
+	{ blzt r29, copy_to_user_fixup_loop }
+
+copy_from_user_fixup_loop:
+	/* Try copying the rest one byte at a time, expecting a load fault. */
+.Lcfu:	{ lb_u r3, r1; addi r1, r1, 1 }
+	{ sb r0, r3; addi r0, r0, 1; addi r2, r2, -1 }
+	{ bnzt r2, copy_from_user_fixup_loop }
+
+.Lcopy_from_user_fixup_zero_remainder:
+	{ bbs r29, 2f }  /* low bit set means IS_COPY_FROM_USER */
+	/* byte-at-a-time loop faulted, so zero the rest. */
+	{ move r3, r2; bz r2, 2f /* should be impossible, but handle it. */ }
+1:      { sb r0, zero; addi r0, r0, 1; addi r3, r3, -1 }
+	{ bnzt r3, 1b }
+2:	move lr, r27
+	{ move r0, r2; jrp lr }
+
+copy_to_user_fixup_loop:
+	/* Try copying the rest one byte at a time, expecting a store fault. */
+	{ lb_u r3, r1; addi r1, r1, 1 }
+.Lctu:	{ sb r0, r3; addi r0, r0, 1; addi r2, r2, -1 }
+	{ bnzt r2, copy_to_user_fixup_loop }
+.Lcopy_to_user_fixup_done:
+	move lr, r27
+	{ move r0, r2; jrp lr }
+
+memcpy_fixup_loop:
+	/* Try copying the rest one byte at a time. We expect a disastrous
+	 * fault to happen since we are in fixup code, but let it happen.
+	 */
+	{ lb_u r3, r1; addi r1, r1, 1 }
+	{ sb r0, r3; addi r0, r0, 1; addi r2, r2, -1 }
+	{ bnzt r2, memcpy_fixup_loop }
+	/* This should be unreachable, we should have faulted again.
+	 * But be paranoid and handle it in case some interrupt changed
+	 * the TLB or something.
+	 */
+	move lr, r27
+	{ move r0, r23; jrp lr }
+
+	.size memcpy_common_fixup, . - memcpy_common_fixup
+
+	.section __ex_table,"a"
+	.word .Lcfu, .Lcopy_from_user_fixup_zero_remainder
+	.word .Lctu, .Lcopy_to_user_fixup_done
diff --git a/arch/tile/lib/memcpy_tile64.c b/arch/tile/lib/memcpy_tile64.c
new file mode 100644
index 0000000..4f00473
--- /dev/null
+++ b/arch/tile/lib/memcpy_tile64.c
@@ -0,0 +1,271 @@
+/*
+ * Copyright 2010 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ */
+
+#include <linux/string.h>
+#include <linux/smp.h>
+#include <linux/module.h>
+#include <linux/uaccess.h>
+#include <asm/fixmap.h>
+#include <asm/kmap_types.h>
+#include <asm/tlbflush.h>
+#include <hv/hypervisor.h>
+#include <arch/chip.h>
+
+
+#if !CHIP_HAS_COHERENT_LOCAL_CACHE()
+
+/* Defined in memcpy.S */
+extern unsigned long __memcpy_asm(void *to, const void *from, unsigned long n);
+extern unsigned long __copy_to_user_inatomic_asm(
+	void __user *to, const void *from, unsigned long n);
+extern unsigned long __copy_from_user_inatomic_asm(
+	void *to, const void __user *from, unsigned long n);
+extern unsigned long __copy_from_user_zeroing_asm(
+	void *to, const void __user *from, unsigned long n);
+
+typedef unsigned long (*memcpy_t)(void *, const void *, unsigned long);
+
+/* Size above which to consider TLB games for performance */
+#define LARGE_COPY_CUTOFF 2048
+
+/* Communicate to the simulator what we are trying to do. */
+#define sim_allow_multiple_caching(b) \
+  __insn_mtspr(SPR_SIM_CONTROL, \
+   SIM_CONTROL_ALLOW_MULTIPLE_CACHING | ((b) << _SIM_CONTROL_OPERATOR_BITS))
+
+/*
+ * Copy memory by briefly enabling incoherent cacheline-at-a-time mode.
+ *
+ * We set up our own source and destination PTEs that we fully control.
+ * This is the only way to guarantee that we don't race with another
+ * thread that is modifying the PTE; we can't afford to try the
+ * copy_{to,from}_user() technique of catching the interrupt, since
+ * we must run with interrupts disabled to avoid the risk of some
+ * other code seeing the incoherent data in our cache.  (Recall that
+ * our cache is indexed by PA, so even if the other code doesn't use
+ * our KM_MEMCPY virtual addresses, they'll still hit in cache using
+ * the normal VAs that aren't supposed to hit in cache.)
+ */
+static void memcpy_multicache(void *dest, const void *source,
+			      pte_t dst_pte, pte_t src_pte, int len)
+{
+	int idx, i;
+	unsigned long flags, newsrc, newdst, endsrc;
+	pmd_t *pmdp;
+	pte_t *ptep;
+	int cpu = get_cpu();
+
+	/*
+	 * Disable interrupts so that we don't recurse into memcpy()
+	 * in an interrupt handler, nor accidentally reference
+	 * the PA of the source from an interrupt routine.  Also
+	 * notify the simulator that we're playing games so we don't
+	 * generate spurious coherency warnings.
+	 */
+	local_irq_save(flags);
+	sim_allow_multiple_caching(1);
+
+	/* Set up the new dest mapping */
+	idx = FIX_KMAP_BEGIN + (KM_TYPE_NR * cpu) + KM_MEMCPY0;
+	newdst = __fix_to_virt(idx) + ((unsigned long)dest & (PAGE_SIZE-1));
+	pmdp = pmd_offset(pud_offset(pgd_offset_k(newdst), newdst), newdst);
+	ptep = pte_offset_kernel(pmdp, newdst);
+	if (pte_val(*ptep) != pte_val(dst_pte)) {
+		set_pte(ptep, dst_pte);
+		local_flush_tlb_page(NULL, newdst, PAGE_SIZE);
+	}
+
+	/* Set up the new source mapping */
+	idx += (KM_MEMCPY0 - KM_MEMCPY1);
+	src_pte = hv_pte_set_nc(src_pte);
+	src_pte = hv_pte_clear_writable(src_pte);  /* be paranoid */
+	newsrc = __fix_to_virt(idx) + ((unsigned long)source & (PAGE_SIZE-1));
+	pmdp = pmd_offset(pud_offset(pgd_offset_k(newsrc), newsrc), newsrc);
+	ptep = pte_offset_kernel(pmdp, newsrc);
+	*ptep = src_pte;   /* set_pte() would be confused by this */
+	local_flush_tlb_page(NULL, newsrc, PAGE_SIZE);
+
+	/* Actually move the data. */
+	__memcpy_asm((void *)newdst, (const void *)newsrc, len);
+
+	/*
+	 * Remap the source as locally-cached and not OLOC'ed so that
+	 * we can inval without also invaling the remote cpu's cache.
+	 * This also avoids known errata with inv'ing cacheable oloc data.
+	 */
+	src_pte = hv_pte_set_mode(src_pte, HV_PTE_MODE_CACHE_NO_L3);
+	src_pte = hv_pte_set_writable(src_pte); /* need write access for inv */
+	*ptep = src_pte;   /* set_pte() would be confused by this */
+	local_flush_tlb_page(NULL, newsrc, PAGE_SIZE);
+
+	/*
+	 * Do the actual invalidation, covering the full L2 cache line
+	 * at the end since __memcpy_asm() is somewhat aggressive.
+	 */
+	__inv_buffer((void *)newsrc, len);
+
+	/*
+	 * We're done: notify the simulator that all is back to normal,
+	 * and re-enable interrupts and pre-emption.
+	 */
+	sim_allow_multiple_caching(0);
+	local_irq_restore(flags);
+	put_cpu_no_resched();
+}
+
+/*
+ * Identify large copies from remotely-cached memory, and copy them
+ * via memcpy_multicache() if they look good, otherwise fall back
+ * to the particular kind of copying passed as the memcpy_t function.
+ */
+static unsigned long fast_copy(void *dest, const void *source, int len,
+			       memcpy_t func)
+{
+	/*
+	 * Check if it's big enough to bother with.  We may end up doing a
+	 * small copy via TLB manipulation if we're near a page boundary,
+	 * but presumably we'll make it up when we hit the second page.
+	 */
+	while (len >= LARGE_COPY_CUTOFF) {
+		int copy_size, bytes_left_on_page;
+		pte_t *src_ptep, *dst_ptep;
+		pte_t src_pte, dst_pte;
+		struct page *src_page, *dst_page;
+
+		/* Is the source page oloc'ed to a remote cpu? */
+retry_source:
+		src_ptep = virt_to_pte(current->mm, (unsigned long)source);
+		if (src_ptep == NULL)
+			break;
+		src_pte = *src_ptep;
+		if (!hv_pte_get_present(src_pte) ||
+		    !hv_pte_get_readable(src_pte) ||
+		    hv_pte_get_mode(src_pte) != HV_PTE_MODE_CACHE_TILE_L3)
+			break;
+		if (get_remote_cache_cpu(src_pte) == smp_processor_id())
+			break;
+		src_page = pfn_to_page(hv_pte_get_pfn(src_pte));
+		get_page(src_page);
+		if (pte_val(src_pte) != pte_val(*src_ptep)) {
+			put_page(src_page);
+			goto retry_source;
+		}
+		if (pte_huge(src_pte)) {
+			/* Adjust the PTE to correspond to a small page */
+			int pfn = hv_pte_get_pfn(src_pte);
+			pfn += (((unsigned long)source & (HPAGE_SIZE-1))
+				>> PAGE_SHIFT);
+			src_pte = pfn_pte(pfn, src_pte);
+			src_pte = pte_mksmall(src_pte);
+		}
+
+		/* Is the destination page writable? */
+retry_dest:
+		dst_ptep = virt_to_pte(current->mm, (unsigned long)dest);
+		if (dst_ptep == NULL) {
+			put_page(src_page);
+			break;
+		}
+		dst_pte = *dst_ptep;
+		if (!hv_pte_get_present(dst_pte) ||
+		    !hv_pte_get_writable(dst_pte)) {
+			put_page(src_page);
+			break;
+		}
+		dst_page = pfn_to_page(hv_pte_get_pfn(dst_pte));
+		if (dst_page == src_page) {
+			/*
+			 * Source and dest are on the same page; this
+			 * potentially exposes us to incoherence if any
+			 * part of src and dest overlap on a cache line.
+			 * Just give up rather than trying to be precise.
+			 */
+			put_page(src_page);
+			break;
+		}
+		get_page(dst_page);
+		if (pte_val(dst_pte) != pte_val(*dst_ptep)) {
+			put_page(dst_page);
+			goto retry_dest;
+		}
+		if (pte_huge(dst_pte)) {
+			/* Adjust the PTE to correspond to a small page */
+			int pfn = hv_pte_get_pfn(dst_pte);
+			pfn += (((unsigned long)dest & (HPAGE_SIZE-1))
+				>> PAGE_SHIFT);
+			dst_pte = pfn_pte(pfn, dst_pte);
+			dst_pte = pte_mksmall(dst_pte);
+		}
+
+		/* All looks good: create a cachable PTE and copy from it */
+		copy_size = len;
+		bytes_left_on_page =
+			PAGE_SIZE - (((int)source) & (PAGE_SIZE-1));
+		if (copy_size > bytes_left_on_page)
+			copy_size = bytes_left_on_page;
+		bytes_left_on_page =
+			PAGE_SIZE - (((int)dest) & (PAGE_SIZE-1));
+		if (copy_size > bytes_left_on_page)
+			copy_size = bytes_left_on_page;
+		memcpy_multicache(dest, source, dst_pte, src_pte, copy_size);
+
+		/* Release the pages */
+		put_page(dst_page);
+		put_page(src_page);
+
+		/* Continue on the next page */
+		dest += copy_size;
+		source += copy_size;
+		len -= copy_size;
+	}
+
+	return func(dest, source, len);
+}
+
+void *memcpy(void *to, const void *from, __kernel_size_t n)
+{
+	if (n < LARGE_COPY_CUTOFF)
+		return (void *)__memcpy_asm(to, from, n);
+	else
+		return (void *)fast_copy(to, from, n, __memcpy_asm);
+}
+
+unsigned long __copy_to_user_inatomic(void __user *to, const void *from,
+				      unsigned long n)
+{
+	if (n < LARGE_COPY_CUTOFF)
+		return __copy_to_user_inatomic_asm(to, from, n);
+	else
+		return fast_copy(to, from, n, __copy_to_user_inatomic_asm);
+}
+
+unsigned long __copy_from_user_inatomic(void *to, const void __user *from,
+					unsigned long n)
+{
+	if (n < LARGE_COPY_CUTOFF)
+		return __copy_from_user_inatomic_asm(to, from, n);
+	else
+		return fast_copy(to, from, n, __copy_from_user_inatomic_asm);
+}
+
+unsigned long __copy_from_user_zeroing(void *to, const void __user *from,
+				       unsigned long n)
+{
+	if (n < LARGE_COPY_CUTOFF)
+		return __copy_from_user_zeroing_asm(to, from, n);
+	else
+		return fast_copy(to, from, n, __copy_from_user_zeroing_asm);
+}
+
+#endif /* !CHIP_HAS_COHERENT_LOCAL_CACHE() */
diff --git a/arch/tile/lib/memmove_32.c b/arch/tile/lib/memmove_32.c
new file mode 100644
index 0000000..f09d8c4
--- /dev/null
+++ b/arch/tile/lib/memmove_32.c
@@ -0,0 +1,63 @@
+/*
+ * Copyright 2010 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ */
+
+#include <linux/types.h>
+#include <linux/string.h>
+#include <linux/module.h>
+
+void *memmove(void *dest, const void *src, size_t n)
+{
+	if ((const char *)src >= (char *)dest + n
+	    || (char *)dest >= (const char *)src + n) {
+		/* We found no overlap, so let memcpy do all the heavy
+		 * lifting (prefetching, etc.)
+		 */
+		return memcpy(dest, src, n);
+	}
+
+	if (n != 0) {
+		const uint8_t *in;
+		uint8_t x;
+		uint8_t *out;
+		int stride;
+
+		if (src < dest) {
+			/* copy backwards */
+			in = (const uint8_t *)src + n - 1;
+			out = (uint8_t *)dest + n - 1;
+			stride = -1;
+		} else {
+			/* copy forwards */
+			in = (const uint8_t *)src;
+			out = (uint8_t *)dest;
+			stride = 1;
+                }
+
+		/* Manually software-pipeline this loop. */
+		x = *in;
+		in += stride;
+
+		while (--n != 0) {
+			*out = x;
+			out += stride;
+			x = *in;
+			in += stride;
+		}
+
+		*out = x;
+	}
+
+	return dest;
+}
+EXPORT_SYMBOL(memmove);
diff --git a/arch/tile/lib/memset_32.c b/arch/tile/lib/memset_32.c
new file mode 100644
index 0000000..8593bc8
--- /dev/null
+++ b/arch/tile/lib/memset_32.c
@@ -0,0 +1,274 @@
+/*
+ * Copyright 2010 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ */
+
+#include <arch/chip.h>
+
+#include <linux/types.h>
+#include <linux/string.h>
+#include <linux/module.h>
+
+
+void *memset(void *s, int c, size_t n)
+{
+	uint32_t *out32;
+	int n32;
+	uint32_t v16, v32;
+	uint8_t *out8 = s;
+#if !CHIP_HAS_WH64()
+	int ahead32;
+#else
+	int to_align32;
+#endif
+
+	/* Experimentation shows that a trivial tight loop is a win up until
+	 * around a size of 20, where writing a word at a time starts to win.
+	 */
+#define BYTE_CUTOFF 20
+
+#if BYTE_CUTOFF < 3
+	/* This must be at least at least this big, or some code later
+	 * on doesn't work.
+	 */
+#error "BYTE_CUTOFF is too small"
+#endif
+
+	if (n < BYTE_CUTOFF) {
+		/* Strangely, this turns out to be the tightest way to
+		 * write this loop.
+		 */
+		if (n != 0) {
+			do {
+				/* Strangely, combining these into one line
+				 * performs worse.
+				 */
+				*out8 = c;
+				out8++;
+			} while (--n != 0);
+		}
+
+		return s;
+	}
+
+#if !CHIP_HAS_WH64()
+	/* Use a spare issue slot to start prefetching the first cache
+	 * line early. This instruction is free as the store can be buried
+	 * in otherwise idle issue slots doing ALU ops.
+	 */
+	__insn_prefetch(out8);
+
+	/* We prefetch the end so that a short memset that spans two cache
+	 * lines gets some prefetching benefit. Again we believe this is free
+	 * to issue.
+	 */
+	__insn_prefetch(&out8[n - 1]);
+#endif /* !CHIP_HAS_WH64() */
+
+
+	/* Align 'out8'. We know n >= 3 so this won't write past the end. */
+	while (((uintptr_t) out8 & 3) != 0) {
+		*out8++ = c;
+		--n;
+	}
+
+	/* Align 'n'. */
+	while (n & 3)
+		out8[--n] = c;
+
+	out32 = (uint32_t *) out8;
+	n32 = n >> 2;
+
+	/* Tile input byte out to 32 bits. */
+	v16 = __insn_intlb(c, c);
+	v32 = __insn_intlh(v16, v16);
+
+	/* This must be at least 8 or the following loop doesn't work. */
+#define CACHE_LINE_SIZE_IN_WORDS (CHIP_L2_LINE_SIZE() / 4)
+
+#if !CHIP_HAS_WH64()
+
+	ahead32 = CACHE_LINE_SIZE_IN_WORDS;
+
+	/* We already prefetched the first and last cache lines, so
+	 * we only need to do more prefetching if we are storing
+	 * to more than two cache lines.
+	 */
+	if (n32 > CACHE_LINE_SIZE_IN_WORDS * 2) {
+		int i;
+
+		/* Prefetch the next several cache lines.
+		 * This is the setup code for the software-pipelined
+		 * loop below.
+		 */
+#define MAX_PREFETCH 5
+		ahead32 = n32 & -CACHE_LINE_SIZE_IN_WORDS;
+		if (ahead32 > MAX_PREFETCH * CACHE_LINE_SIZE_IN_WORDS)
+			ahead32 = MAX_PREFETCH * CACHE_LINE_SIZE_IN_WORDS;
+
+		for (i = CACHE_LINE_SIZE_IN_WORDS;
+		     i < ahead32; i += CACHE_LINE_SIZE_IN_WORDS)
+			__insn_prefetch(&out32[i]);
+	}
+
+	if (n32 > ahead32) {
+		while (1) {
+			int j;
+
+			/* Prefetch by reading one word several cache lines
+			 * ahead.  Since loads are non-blocking this will
+			 * cause the full cache line to be read while we are
+			 * finishing earlier cache lines.  Using a store
+			 * here causes microarchitectural performance
+			 * problems where a victimizing store miss goes to
+			 * the head of the retry FIFO and locks the pipe for
+			 * a few cycles.  So a few subsequent stores in this
+			 * loop go into the retry FIFO, and then later
+			 * stores see other stores to the same cache line
+			 * are already in the retry FIFO and themselves go
+			 * into the retry FIFO, filling it up and grinding
+			 * to a halt waiting for the original miss to be
+			 * satisfied.
+			 */
+			__insn_prefetch(&out32[ahead32]);
+
+#if 1
+#if CACHE_LINE_SIZE_IN_WORDS % 4 != 0
+#error "Unhandled CACHE_LINE_SIZE_IN_WORDS"
+#endif
+
+			n32 -= CACHE_LINE_SIZE_IN_WORDS;
+
+			/* Save icache space by only partially unrolling
+			 * this loop.
+			 */
+			for (j = CACHE_LINE_SIZE_IN_WORDS / 4; j > 0; j--) {
+				*out32++ = v32;
+				*out32++ = v32;
+				*out32++ = v32;
+				*out32++ = v32;
+			}
+#else
+			/* Unfortunately, due to a code generator flaw this
+			 * allocates a separate register for each of these
+			 * stores, which requires a large number of spills,
+			 * which makes this procedure enormously bigger
+			 * (something like 70%)
+			 */
+			*out32++ = v32;
+			*out32++ = v32;
+			*out32++ = v32;
+			*out32++ = v32;
+			*out32++ = v32;
+			*out32++ = v32;
+			*out32++ = v32;
+			*out32++ = v32;
+			*out32++ = v32;
+			*out32++ = v32;
+			*out32++ = v32;
+			*out32++ = v32;
+			*out32++ = v32;
+			*out32++ = v32;
+			*out32++ = v32;
+			n32 -= 16;
+#endif
+
+			/* To save compiled code size, reuse this loop even
+			 * when we run out of prefetching to do by dropping
+			 * ahead32 down.
+			 */
+			if (n32 <= ahead32) {
+				/* Not even a full cache line left,
+				 * so stop now.
+				 */
+				if (n32 < CACHE_LINE_SIZE_IN_WORDS)
+					break;
+
+				/* Choose a small enough value that we don't
+				 * prefetch past the end.  There's no sense
+				 * in touching cache lines we don't have to.
+				 */
+				ahead32 = CACHE_LINE_SIZE_IN_WORDS - 1;
+			}
+		}
+	}
+
+#else /* CHIP_HAS_WH64() */
+
+	/* Determine how many words we need to emit before the 'out32'
+	 * pointer becomes aligned modulo the cache line size.
+	 */
+	to_align32 =
+		(-((uintptr_t)out32 >> 2)) & (CACHE_LINE_SIZE_IN_WORDS - 1);
+
+	/* Only bother aligning and using wh64 if there is at least
+	 * one full cache line to process.  This check also prevents
+	 * overrunning the end of the buffer with alignment words.
+	 */
+	if (to_align32 <= n32 - CACHE_LINE_SIZE_IN_WORDS) {
+		int lines_left;
+
+		/* Align out32 mod the cache line size so we can use wh64. */
+		n32 -= to_align32;
+		for (; to_align32 != 0; to_align32--) {
+			*out32 = v32;
+			out32++;
+		}
+
+		/* Use unsigned divide to turn this into a right shift. */
+		lines_left = (unsigned)n32 / CACHE_LINE_SIZE_IN_WORDS;
+
+		do {
+			/* Only wh64 a few lines at a time, so we don't
+			 * exceed the maximum number of victim lines.
+			 */
+			int x = ((lines_left < CHIP_MAX_OUTSTANDING_VICTIMS())
+				  ? lines_left
+				  : CHIP_MAX_OUTSTANDING_VICTIMS());
+			uint32_t *wh = out32;
+			int i = x;
+			int j;
+
+			lines_left -= x;
+
+			do {
+				__insn_wh64(wh);
+				wh += CACHE_LINE_SIZE_IN_WORDS;
+			} while (--i);
+
+			for (j = x * (CACHE_LINE_SIZE_IN_WORDS / 4); j != 0; j--) {
+				*out32++ = v32;
+				*out32++ = v32;
+				*out32++ = v32;
+				*out32++ = v32;
+			}
+		} while (lines_left != 0);
+
+		/* We processed all full lines above, so only this many
+		 * words remain to be processed.
+		 */
+		n32 &= CACHE_LINE_SIZE_IN_WORDS - 1;
+	}
+
+#endif /* CHIP_HAS_WH64() */
+
+	/* Now handle any leftover values. */
+	if (n32 != 0) {
+		do {
+			*out32 = v32;
+			out32++;
+		} while (--n32 != 0);
+	}
+
+	return s;
+}
+EXPORT_SYMBOL(memset);
diff --git a/arch/tile/lib/spinlock_32.c b/arch/tile/lib/spinlock_32.c
new file mode 100644
index 0000000..485e24d
--- /dev/null
+++ b/arch/tile/lib/spinlock_32.c
@@ -0,0 +1,221 @@
+/*
+ * Copyright 2010 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ */
+
+#include <linux/spinlock.h>
+#include <linux/module.h>
+#include <asm/processor.h>
+
+#include "spinlock_common.h"
+
+void arch_spin_lock(arch_spinlock_t *lock)
+{
+	int my_ticket;
+	int iterations = 0;
+	int delta;
+
+	while ((my_ticket = __insn_tns((void *)&lock->next_ticket)) & 1)
+		delay_backoff(iterations++);
+
+	/* Increment the next ticket number, implicitly releasing tns lock. */
+	lock->next_ticket = my_ticket + TICKET_QUANTUM;
+
+	/* Wait until it's our turn. */
+	while ((delta = my_ticket - lock->current_ticket) != 0)
+		relax((128 / CYCLES_PER_RELAX_LOOP) * delta);
+}
+EXPORT_SYMBOL(arch_spin_lock);
+
+int arch_spin_trylock(arch_spinlock_t *lock)
+{
+	/*
+	 * Grab a ticket; no need to retry if it's busy, we'll just
+	 * treat that the same as "locked", since someone else
+	 * will lock it momentarily anyway.
+	 */
+	int my_ticket = __insn_tns((void *)&lock->next_ticket);
+
+	if (my_ticket == lock->current_ticket) {
+		/* Not currently locked, so lock it by keeping this ticket. */
+		lock->next_ticket = my_ticket + TICKET_QUANTUM;
+		/* Success! */
+		return 1;
+	}
+
+	if (!(my_ticket & 1)) {
+		/* Release next_ticket. */
+		lock->next_ticket = my_ticket;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(arch_spin_trylock);
+
+void arch_spin_unlock_wait(arch_spinlock_t *lock)
+{
+	u32 iterations = 0;
+	while (arch_spin_is_locked(lock))
+		delay_backoff(iterations++);
+}
+EXPORT_SYMBOL(arch_spin_unlock_wait);
+
+/*
+ * The low byte is always reserved to be the marker for a "tns" operation
+ * since the low bit is set to "1" by a tns.  The next seven bits are
+ * zeroes.  The next byte holds the "next" writer value, i.e. the ticket
+ * available for the next task that wants to write.  The third byte holds
+ * the current writer value, i.e. the writer who holds the current ticket.
+ * If current == next == 0, there are no interested writers.
+ */
+#define WR_NEXT_SHIFT   _WR_NEXT_SHIFT
+#define WR_CURR_SHIFT   _WR_CURR_SHIFT
+#define WR_WIDTH        _WR_WIDTH
+#define WR_MASK         ((1 << WR_WIDTH) - 1)
+
+/*
+ * The last eight bits hold the active reader count.  This has to be
+ * zero before a writer can start to write.
+ */
+#define RD_COUNT_SHIFT  _RD_COUNT_SHIFT
+#define RD_COUNT_WIDTH  _RD_COUNT_WIDTH
+#define RD_COUNT_MASK   ((1 << RD_COUNT_WIDTH) - 1)
+
+
+/* Lock the word, spinning until there are no tns-ers. */
+static inline u32 get_rwlock(arch_rwlock_t *rwlock)
+{
+	u32 iterations = 0;
+	for (;;) {
+		u32 val = __insn_tns((int *)&rwlock->lock);
+		if (unlikely(val & 1)) {
+			delay_backoff(iterations++);
+			continue;
+		}
+		return val;
+	}
+}
+
+int arch_read_trylock_slow(arch_rwlock_t *rwlock)
+{
+	u32 val = get_rwlock(rwlock);
+	int locked = (val << RD_COUNT_WIDTH) == 0;
+	rwlock->lock = val + (locked << RD_COUNT_SHIFT);
+	return locked;
+}
+EXPORT_SYMBOL(arch_read_trylock_slow);
+
+void arch_read_unlock_slow(arch_rwlock_t *rwlock)
+{
+	u32 val = get_rwlock(rwlock);
+	rwlock->lock = val - (1 << RD_COUNT_SHIFT);
+}
+EXPORT_SYMBOL(arch_read_unlock_slow);
+
+void arch_write_unlock_slow(arch_rwlock_t *rwlock, u32 val)
+{
+	u32 eq, mask = 1 << WR_CURR_SHIFT;
+	while (unlikely(val & 1)) {
+		/* Limited backoff since we are the highest-priority task. */
+		relax(4);
+		val = __insn_tns((int *)&rwlock->lock);
+	}
+	val = __insn_addb(val, mask);
+	eq = __insn_seqb(val, val << (WR_CURR_SHIFT - WR_NEXT_SHIFT));
+	val = __insn_mz(eq & mask, val);
+	rwlock->lock = val;
+}
+EXPORT_SYMBOL(arch_write_unlock_slow);
+
+/*
+ * We spin until everything but the reader bits (which are in the high
+ * part of the word) are zero, i.e. no active or waiting writers, no tns.
+ *
+ * ISSUE: This approach can permanently starve readers.  A reader who sees
+ * a writer could instead take a ticket lock (just like a writer would),
+ * and atomically enter read mode (with 1 reader) when it gets the ticket.
+ * This way both readers and writers will always make forward progress
+ * in a finite time.
+ */
+void arch_read_lock_slow(arch_rwlock_t *rwlock, u32 val)
+{
+	u32 iterations = 0;
+	do {
+		if (!(val & 1))
+			rwlock->lock = val;
+		delay_backoff(iterations++);
+		val = __insn_tns((int *)&rwlock->lock);
+	} while ((val << RD_COUNT_WIDTH) != 0);
+	rwlock->lock = val + (1 << RD_COUNT_SHIFT);
+}
+EXPORT_SYMBOL(arch_read_lock_slow);
+
+void arch_write_lock_slow(arch_rwlock_t *rwlock, u32 val)
+{
+	/*
+	 * The trailing underscore on this variable (and curr_ below)
+	 * reminds us that the high bits are garbage; we mask them out
+	 * when we compare them.
+	 */
+	u32 my_ticket_;
+
+	/* Take out the next ticket; this will also stop would-be readers. */
+	if (val & 1)
+		val = get_rwlock(rwlock);
+	rwlock->lock = __insn_addb(val, 1 << WR_NEXT_SHIFT);
+
+	/* Extract my ticket value from the original word. */
+	my_ticket_ = val >> WR_NEXT_SHIFT;
+
+	/*
+	 * Wait until the "current" field matches our ticket, and
+	 * there are no remaining readers.
+	 */
+	for (;;) {
+		u32 curr_ = val >> WR_CURR_SHIFT;
+		u32 readers = val >> RD_COUNT_SHIFT;
+		u32 delta = ((my_ticket_ - curr_) & WR_MASK) + !!readers;
+		if (likely(delta == 0))
+			break;
+
+		/* Delay based on how many lock-holders are still out there. */
+		relax((256 / CYCLES_PER_RELAX_LOOP) * delta);
+
+		/*
+		 * Get a non-tns value to check; we don't need to tns
+		 * it ourselves.  Since we're not tns'ing, we retry
+		 * more rapidly to get a valid value.
+		 */
+		while ((val = rwlock->lock) & 1)
+			relax(4);
+	}
+}
+EXPORT_SYMBOL(arch_write_lock_slow);
+
+int __tns_atomic_acquire(atomic_t *lock)
+{
+	int ret;
+	u32 iterations = 0;
+
+	BUG_ON(__insn_mfspr(SPR_INTERRUPT_CRITICAL_SECTION));
+	__insn_mtspr(SPR_INTERRUPT_CRITICAL_SECTION, 1);
+
+	while ((ret = __insn_tns((void *)&lock->counter)) == 1)
+		delay_backoff(iterations++);
+	return ret;
+}
+
+void __tns_atomic_release(atomic_t *p, int v)
+{
+	p->counter = v;
+	__insn_mtspr(SPR_INTERRUPT_CRITICAL_SECTION, 0);
+}
diff --git a/arch/tile/lib/spinlock_common.h b/arch/tile/lib/spinlock_common.h
new file mode 100644
index 0000000..8dffebd
--- /dev/null
+++ b/arch/tile/lib/spinlock_common.h
@@ -0,0 +1,64 @@
+/*
+ * Copyright 2010 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ * This file is included into spinlock_32.c or _64.c.
+ */
+
+/*
+ * The mfspr in __spinlock_relax() is 5 or 6 cycles plus 2 for loop
+ * overhead.
+ */
+#ifdef __tilegx__
+#define CYCLES_PER_RELAX_LOOP 7
+#else
+#define CYCLES_PER_RELAX_LOOP 8
+#endif
+
+/*
+ * Idle the core for CYCLES_PER_RELAX_LOOP * iterations cycles.
+ */
+static inline void
+relax(int iterations)
+{
+	for (/*above*/; iterations > 0; iterations--)
+		__insn_mfspr(SPR_PASS);
+	barrier();
+}
+
+/* Perform bounded exponential backoff.*/
+void delay_backoff(int iterations)
+{
+	u32 exponent, loops;
+
+	/*
+	 * 2^exponent is how many times we go around the loop,
+	 * which takes 8 cycles.  We want to start with a 16- to 31-cycle
+	 * loop, so we need to go around minimum 2 = 2^1 times, so we
+	 * bias the original value up by 1.
+	 */
+	exponent = iterations + 1;
+
+	/*
+	 * Don't allow exponent to exceed 7, so we have 128 loops,
+	 * or 1,024 (to 2,047) cycles, as our maximum.
+	 */
+	if (exponent > 8)
+		exponent = 8;
+
+	loops = 1 << exponent;
+
+	/* Add a randomness factor so two cpus never get in lock step. */
+	loops += __insn_crc32_32(stack_pointer, get_cycles_low()) &
+		(loops - 1);
+
+	relax(1 << exponent);
+}
diff --git a/arch/tile/lib/strchr_32.c b/arch/tile/lib/strchr_32.c
new file mode 100644
index 0000000..c94e6f7
--- /dev/null
+++ b/arch/tile/lib/strchr_32.c
@@ -0,0 +1,66 @@
+/*
+ * Copyright 2010 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ */
+
+#include <linux/types.h>
+#include <linux/string.h>
+#include <linux/module.h>
+
+#undef strchr
+
+char *strchr(const char *s, int c)
+{
+	int z, g;
+
+	/* Get an aligned pointer. */
+	const uintptr_t s_int = (uintptr_t) s;
+	const uint32_t *p = (const uint32_t *)(s_int & -4);
+
+	/* Create four copies of the byte for which we are looking. */
+	const uint32_t goal = 0x01010101 * (uint8_t) c;
+
+	/* Read the first aligned word, but force bytes before the string to
+	 * match neither zero nor goal (we make sure the high bit of each
+	 * byte is 1, and the low 7 bits are all the opposite of the goal
+	 * byte).
+	 *
+	 * Note that this shift count expression works because we know shift
+	 * counts are taken mod 32.
+	 */
+	const uint32_t before_mask = (1 << (s_int << 3)) - 1;
+	uint32_t v = (*p | before_mask) ^ (goal & __insn_shrib(before_mask, 1));
+
+	uint32_t zero_matches, goal_matches;
+	while (1) {
+		/* Look for a terminating '\0'. */
+		zero_matches = __insn_seqb(v, 0);
+
+		/* Look for the goal byte. */
+		goal_matches = __insn_seqb(v, goal);
+
+		if (__builtin_expect(zero_matches | goal_matches, 0))
+			break;
+
+		v = *++p;
+	}
+
+	z = __insn_ctz(zero_matches);
+	g = __insn_ctz(goal_matches);
+
+	/* If we found c before '\0' we got a match. Note that if c == '\0'
+	 * then g == z, and we correctly return the address of the '\0'
+	 * rather than NULL.
+	 */
+	return (g <= z) ? ((char *)p) + (g >> 3) : NULL;
+}
+EXPORT_SYMBOL(strchr);
diff --git a/arch/tile/lib/strlen_32.c b/arch/tile/lib/strlen_32.c
new file mode 100644
index 0000000..f26f88e
--- /dev/null
+++ b/arch/tile/lib/strlen_32.c
@@ -0,0 +1,36 @@
+/*
+ * Copyright 2010 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ */
+
+#include <linux/types.h>
+#include <linux/string.h>
+#include <linux/module.h>
+
+size_t strlen(const char *s)
+{
+	/* Get an aligned pointer. */
+	const uintptr_t s_int = (uintptr_t) s;
+	const uint32_t *p = (const uint32_t *)(s_int & -4);
+
+	/* Read the first word, but force bytes before the string to be nonzero.
+	 * This expression works because we know shift counts are taken mod 32.
+	 */
+	uint32_t v = *p | ((1 << (s_int << 3)) - 1);
+
+	uint32_t bits;
+	while ((bits = __insn_seqb(v, 0)) == 0)
+		v = *++p;
+
+	return ((const char *)p) + (__insn_ctz(bits) >> 3) - s;
+}
+EXPORT_SYMBOL(strlen);
diff --git a/arch/tile/lib/uaccess.c b/arch/tile/lib/uaccess.c
new file mode 100644
index 0000000..9ae1825
--- /dev/null
+++ b/arch/tile/lib/uaccess.c
@@ -0,0 +1,31 @@
+/*
+ * Copyright 2010 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ */
+
+#include <linux/uaccess.h>
+#include <linux/module.h>
+
+int __range_ok(unsigned long addr, unsigned long size)
+{
+	unsigned long limit = current_thread_info()->addr_limit.seg;
+	__chk_user_ptr(addr);
+	return !((addr < limit && size <= limit - addr) ||
+		 is_arch_mappable_range(addr, size));
+}
+EXPORT_SYMBOL(__range_ok);
+
+void copy_from_user_overflow(void)
+{
+       WARN(1, "Buffer overflow detected!\n");
+}
+EXPORT_SYMBOL(copy_from_user_overflow);
diff --git a/arch/tile/lib/usercopy_32.S b/arch/tile/lib/usercopy_32.S
new file mode 100644
index 0000000..979f76d
--- /dev/null
+++ b/arch/tile/lib/usercopy_32.S
@@ -0,0 +1,223 @@
+/*
+ * Copyright 2010 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ */
+
+#include <linux/linkage.h>
+#include <asm/errno.h>
+#include <asm/cache.h>
+#include <arch/chip.h>
+
+/* Access user memory, but use MMU to avoid propagating kernel exceptions. */
+
+	.pushsection .fixup,"ax"
+
+get_user_fault:
+	{ move r0, zero; move r1, zero }
+	{ movei r2, -EFAULT; jrp lr }
+	ENDPROC(get_user_fault)
+
+put_user_fault:
+	{ movei r0, -EFAULT; jrp lr }
+	ENDPROC(put_user_fault)
+
+	.popsection
+
+/*
+ * __get_user_N functions take a pointer in r0, and return 0 in r2
+ * on success, with the value in r0; or else -EFAULT in r2.
+ */
+#define __get_user_N(bytes, LOAD) \
+	STD_ENTRY(__get_user_##bytes); \
+1:	{ LOAD r0, r0; move r1, zero; move r2, zero }; \
+	jrp lr; \
+	STD_ENDPROC(__get_user_##bytes); \
+	.pushsection __ex_table,"a"; \
+	.word 1b, get_user_fault; \
+	.popsection
+
+__get_user_N(1, lb_u)
+__get_user_N(2, lh_u)
+__get_user_N(4, lw)
+
+/*
+ * __get_user_8 takes a pointer in r0, and returns 0 in r2
+ * on success, with the value in r0/r1; or else -EFAULT in r2.
+ */
+	STD_ENTRY(__get_user_8);
+1:	{ lw r0, r0; addi r1, r0, 4 };
+2:	{ lw r1, r1; move r2, zero };
+	jrp lr;
+	STD_ENDPROC(__get_user_8);
+	.pushsection __ex_table,"a";
+	.word 1b, get_user_fault;
+	.word 2b, get_user_fault;
+	.popsection
+
+/*
+ * __put_user_N functions take a value in r0 and a pointer in r1,
+ * and return 0 in r0 on success or -EFAULT on failure.
+ */
+#define __put_user_N(bytes, STORE) \
+	STD_ENTRY(__put_user_##bytes); \
+1:	{ STORE r1, r0; move r0, zero }; \
+	jrp lr; \
+	STD_ENDPROC(__put_user_##bytes); \
+	.pushsection __ex_table,"a"; \
+	.word 1b, put_user_fault; \
+	.popsection
+
+__put_user_N(1, sb)
+__put_user_N(2, sh)
+__put_user_N(4, sw)
+
+/*
+ * __put_user_8 takes a value in r0/r1 and a pointer in r2,
+ * and returns 0 in r0 on success or -EFAULT on failure.
+ */
+STD_ENTRY(__put_user_8)
+1:      { sw r2, r0; addi r2, r2, 4 }
+2:      { sw r2, r1; move r0, zero }
+	jrp lr
+	STD_ENDPROC(__put_user_8)
+	.pushsection __ex_table,"a"
+	.word 1b, put_user_fault
+	.word 2b, put_user_fault
+	.popsection
+
+
+/*
+ * strnlen_user_asm takes the pointer in r0, and the length bound in r1.
+ * It returns the length, including the terminating NUL, or zero on exception.
+ * If length is greater than the bound, returns one plus the bound.
+ */
+STD_ENTRY(strnlen_user_asm)
+	{ bz r1, 2f; addi r3, r0, -1 }  /* bias down to include NUL */
+1:      { lb_u r4, r0; addi r1, r1, -1 }
+	bz r4, 2f
+	{ bnzt r1, 1b; addi r0, r0, 1 }
+2:      { sub r0, r0, r3; jrp lr }
+	STD_ENDPROC(strnlen_user_asm)
+	.pushsection .fixup,"ax"
+strnlen_user_fault:
+	{ move r0, zero; jrp lr }
+	ENDPROC(strnlen_user_fault)
+	.section __ex_table,"a"
+	.word 1b, strnlen_user_fault
+	.popsection
+
+/*
+ * strncpy_from_user_asm takes the kernel target pointer in r0,
+ * the userspace source pointer in r1, and the length bound (including
+ * the trailing NUL) in r2.  On success, it returns the string length
+ * (not including the trailing NUL), or -EFAULT on failure.
+ */
+STD_ENTRY(strncpy_from_user_asm)
+	{ bz r2, 2f; move r3, r0 }
+1:      { lb_u r4, r1; addi r1, r1, 1; addi r2, r2, -1 }
+	{ sb r0, r4; addi r0, r0, 1 }
+	bz r2, 2f
+	bnzt r4, 1b
+	addi r0, r0, -1   /* don't count the trailing NUL */
+2:      { sub r0, r0, r3; jrp lr }
+	STD_ENDPROC(strncpy_from_user_asm)
+	.pushsection .fixup,"ax"
+strncpy_from_user_fault:
+	{ movei r0, -EFAULT; jrp lr }
+	ENDPROC(strncpy_from_user_fault)
+	.section __ex_table,"a"
+	.word 1b, strncpy_from_user_fault
+	.popsection
+
+/*
+ * clear_user_asm takes the user target address in r0 and the
+ * number of bytes to zero in r1.
+ * It returns the number of uncopiable bytes (hopefully zero) in r0.
+ * Note that we don't use a separate .fixup section here since we fall
+ * through into the "fixup" code as the last straight-line bundle anyway.
+ */
+STD_ENTRY(clear_user_asm)
+	{ bz r1, 2f; or r2, r0, r1 }
+	andi r2, r2, 3
+	bzt r2, .Lclear_aligned_user_asm
+1:      { sb r0, zero; addi r0, r0, 1; addi r1, r1, -1 }
+	bnzt r1, 1b
+2:      { move r0, r1; jrp lr }
+	.pushsection __ex_table,"a"
+	.word 1b, 2b
+	.popsection
+
+.Lclear_aligned_user_asm:
+1:      { sw r0, zero; addi r0, r0, 4; addi r1, r1, -4 }
+	bnzt r1, 1b
+2:      { move r0, r1; jrp lr }
+	STD_ENDPROC(clear_user_asm)
+	.pushsection __ex_table,"a"
+	.word 1b, 2b
+	.popsection
+
+/*
+ * flush_user_asm takes the user target address in r0 and the
+ * number of bytes to flush in r1.
+ * It returns the number of unflushable bytes (hopefully zero) in r0.
+ */
+STD_ENTRY(flush_user_asm)
+	bz r1, 2f
+	{ movei r2, L2_CACHE_BYTES; add r1, r0, r1 }
+	{ sub r2, zero, r2; addi r1, r1, L2_CACHE_BYTES-1 }
+	{ and r0, r0, r2; and r1, r1, r2 }
+	{ sub r1, r1, r0 }
+1:      { flush r0; addi r1, r1, -CHIP_FLUSH_STRIDE() }
+	{ addi r0, r0, CHIP_FLUSH_STRIDE(); bnzt r1, 1b }
+2:      { move r0, r1; jrp lr }
+	STD_ENDPROC(flush_user_asm)
+	.pushsection __ex_table,"a"
+	.word 1b, 2b
+	.popsection
+
+/*
+ * inv_user_asm takes the user target address in r0 and the
+ * number of bytes to invalidate in r1.
+ * It returns the number of not inv'able bytes (hopefully zero) in r0.
+ */
+STD_ENTRY(inv_user_asm)
+	bz r1, 2f
+	{ movei r2, L2_CACHE_BYTES; add r1, r0, r1 }
+	{ sub r2, zero, r2; addi r1, r1, L2_CACHE_BYTES-1 }
+	{ and r0, r0, r2; and r1, r1, r2 }
+	{ sub r1, r1, r0 }
+1:      { inv r0; addi r1, r1, -CHIP_INV_STRIDE() }
+	{ addi r0, r0, CHIP_INV_STRIDE(); bnzt r1, 1b }
+2:      { move r0, r1; jrp lr }
+	STD_ENDPROC(inv_user_asm)
+	.pushsection __ex_table,"a"
+	.word 1b, 2b
+	.popsection
+
+/*
+ * finv_user_asm takes the user target address in r0 and the
+ * number of bytes to flush-invalidate in r1.
+ * It returns the number of not finv'able bytes (hopefully zero) in r0.
+ */
+STD_ENTRY(finv_user_asm)
+	bz r1, 2f
+	{ movei r2, L2_CACHE_BYTES; add r1, r0, r1 }
+	{ sub r2, zero, r2; addi r1, r1, L2_CACHE_BYTES-1 }
+	{ and r0, r0, r2; and r1, r1, r2 }
+	{ sub r1, r1, r0 }
+1:      { finv r0; addi r1, r1, -CHIP_FINV_STRIDE() }
+	{ addi r0, r0, CHIP_FINV_STRIDE(); bnzt r1, 1b }
+2:      { move r0, r1; jrp lr }
+	STD_ENDPROC(finv_user_asm)
+	.pushsection __ex_table,"a"
+	.word 1b, 2b
+	.popsection
-- 
1.6.5.2

