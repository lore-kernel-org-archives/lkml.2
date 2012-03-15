Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161735Ab2COU7o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 16:59:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43745 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161663Ab2COU7f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 16:59:35 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 26/38] Disintegrate asm/system.h for Tile [ver #3]
To: paul.gortmaker@windriver.com
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, arnd@arndb.de,
        David Howells <dhowells@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>
Date: Thu, 15 Mar 2012 20:59:19 +0000
Message-ID: <20120315205919.28759.28198.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120315205514.28759.58969.stgit@warthog.procyon.org.uk>
References: <20120315205514.28759.58969.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Disintegrate asm/system.h for Tile.

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Chris Metcalf <cmetcalf@tilera.com>
---

 arch/tile/include/asm/atomic.h      |    2 
 arch/tile/include/asm/atomic_32.h   |    1 
 arch/tile/include/asm/atomic_64.h   |    1 
 arch/tile/include/asm/barrier.h     |  148 ++++++++++++++++++++
 arch/tile/include/asm/bitops_32.h   |    1 
 arch/tile/include/asm/bitops_64.h   |    1 
 arch/tile/include/asm/cacheflush.h  |   11 +
 arch/tile/include/asm/exec.h        |   20 +++
 arch/tile/include/asm/pgtable.h     |    1 
 arch/tile/include/asm/setup.h       |   22 +++
 arch/tile/include/asm/spinlock_32.h |    1 
 arch/tile/include/asm/switch_to.h   |   76 ++++++++++
 arch/tile/include/asm/system.h      |  265 +----------------------------------
 arch/tile/include/asm/timex.h       |    2 
 arch/tile/include/asm/unaligned.h   |   15 ++
 arch/tile/kernel/early_printk.c     |    1 
 arch/tile/kernel/proc.c             |    1 
 arch/tile/kernel/process.c          |    3 
 arch/tile/kernel/regs_32.S          |    2 
 arch/tile/kernel/regs_64.S          |    2 
 arch/tile/kernel/single_step.c      |    1 
 arch/tile/kernel/traps.c            |    1 
 arch/tile/mm/elf.c                  |    1 
 arch/tile/mm/fault.c                |    1 
 arch/tile/mm/init.c                 |    1 
 arch/tile/mm/pgtable.c              |    1 
 26 files changed, 309 insertions(+), 273 deletions(-)
 create mode 100644 arch/tile/include/asm/barrier.h
 create mode 100644 arch/tile/include/asm/exec.h
 create mode 100644 arch/tile/include/asm/switch_to.h

diff --git a/arch/tile/include/asm/atomic.h b/arch/tile/include/asm/atomic.h
index 921dbeb..bb696da 100644
--- a/arch/tile/include/asm/atomic.h
+++ b/arch/tile/include/asm/atomic.h
@@ -20,7 +20,7 @@
 #ifndef __ASSEMBLY__
 
 #include <linux/compiler.h>
-#include <asm/system.h>
+#include <linux/types.h>
 
 #define ATOMIC_INIT(i)	{ (i) }
 
diff --git a/arch/tile/include/asm/atomic_32.h b/arch/tile/include/asm/atomic_32.h
index c03349e..466dc4a 100644
--- a/arch/tile/include/asm/atomic_32.h
+++ b/arch/tile/include/asm/atomic_32.h
@@ -17,6 +17,7 @@
 #ifndef _ASM_TILE_ATOMIC_32_H
 #define _ASM_TILE_ATOMIC_32_H
 
+#include <asm/barrier.h>
 #include <arch/chip.h>
 
 #ifndef __ASSEMBLY__
diff --git a/arch/tile/include/asm/atomic_64.h b/arch/tile/include/asm/atomic_64.h
index 27fe667..f4500c6 100644
--- a/arch/tile/include/asm/atomic_64.h
+++ b/arch/tile/include/asm/atomic_64.h
@@ -19,6 +19,7 @@
 
 #ifndef __ASSEMBLY__
 
+#include <asm/barrier.h>
 #include <arch/spr_def.h>
 
 /* First, the 32-bit atomic ops that are "real" on our 64-bit platform. */
diff --git a/arch/tile/include/asm/barrier.h b/arch/tile/include/asm/barrier.h
new file mode 100644
index 0000000..990a217
--- /dev/null
+++ b/arch/tile/include/asm/barrier.h
@@ -0,0 +1,148 @@
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
+#ifndef _ASM_TILE_BARRIER_H
+#define _ASM_TILE_BARRIER_H
+
+#ifndef __ASSEMBLY__
+
+#include <linux/types.h>
+#include <arch/chip.h>
+#include <arch/spr_def.h>
+#include <asm/timex.h>
+
+/*
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
+ *	CPU 0				CPU 1
+ *
+ *	b = 2;
+ *	memory_barrier();
+ *	p = &b;				q = p;
+ *					read_barrier_depends();
+ *					d = *q;
+ * </programlisting>
+ *
+ * because the read of "*q" depends on the read of "p" and these
+ * two reads are separated by a read_barrier_depends().  However,
+ * the following code, with the same initial values for "a" and "b":
+ *
+ * <programlisting>
+ *	CPU 0				CPU 1
+ *
+ *	a = 2;
+ *	memory_barrier();
+ *	b = 3;				y = b;
+ *					read_barrier_depends();
+ *					x = a;
+ * </programlisting>
+ *
+ * does not enforce ordering, since there is no data dependency between
+ * the read of "a" and the read of "b".  Therefore, on some CPUs, such
+ * as Alpha, "y" could be set to 3 and "x" to 0.  Use rmb()
+ * in cases like this where there are no data dependencies.
+ */
+#define read_barrier_depends()	do { } while (0)
+
+#define __sync()	__insn_mf()
+
+#if !CHIP_HAS_MF_WAITS_FOR_VICTIMS()
+#include <hv/syscall_public.h>
+/*
+ * Issue an uncacheable load to each memory controller, then
+ * wait until those loads have completed.
+ */
+static inline void __mb_incoherent(void)
+{
+	long clobber_r10;
+	asm volatile("swint2"
+		     : "=R10" (clobber_r10)
+		     : "R10" (HV_SYS_fence_incoherent)
+		     : "r0", "r1", "r2", "r3", "r4",
+		       "r5", "r6", "r7", "r8", "r9",
+		       "r11", "r12", "r13", "r14",
+		       "r15", "r16", "r17", "r18", "r19",
+		       "r20", "r21", "r22", "r23", "r24",
+		       "r25", "r26", "r27", "r28", "r29");
+}
+#endif
+
+/* Fence to guarantee visibility of stores to incoherent memory. */
+static inline void
+mb_incoherent(void)
+{
+	__insn_mf();
+
+#if !CHIP_HAS_MF_WAITS_FOR_VICTIMS()
+	{
+#if CHIP_HAS_TILE_WRITE_PENDING()
+		const unsigned long WRITE_TIMEOUT_CYCLES = 400;
+		unsigned long start = get_cycles_low();
+		do {
+			if (__insn_mfspr(SPR_TILE_WRITE_PENDING) == 0)
+				return;
+		} while ((get_cycles_low() - start) < WRITE_TIMEOUT_CYCLES);
+#endif /* CHIP_HAS_TILE_WRITE_PENDING() */
+		(void) __mb_incoherent();
+	}
+#endif /* CHIP_HAS_MF_WAITS_FOR_VICTIMS() */
+}
+
+#define fast_wmb()	__sync()
+#define fast_rmb()	__sync()
+#define fast_mb()	__sync()
+#define fast_iob()	mb_incoherent()
+
+#define wmb()		fast_wmb()
+#define rmb()		fast_rmb()
+#define mb()		fast_mb()
+#define iob()		fast_iob()
+
+#ifdef CONFIG_SMP
+#define smp_mb()	mb()
+#define smp_rmb()	rmb()
+#define smp_wmb()	wmb()
+#define smp_read_barrier_depends()	read_barrier_depends()
+#else
+#define smp_mb()	barrier()
+#define smp_rmb()	barrier()
+#define smp_wmb()	barrier()
+#define smp_read_barrier_depends()	do { } while (0)
+#endif
+
+#define set_mb(var, value) \
+	do { var = value; mb(); } while (0)
+
+#endif /* !__ASSEMBLY__ */
+#endif /* _ASM_TILE_BARRIER_H */
diff --git a/arch/tile/include/asm/bitops_32.h b/arch/tile/include/asm/bitops_32.h
index 571b118..ddc4c1e 100644
--- a/arch/tile/include/asm/bitops_32.h
+++ b/arch/tile/include/asm/bitops_32.h
@@ -17,7 +17,6 @@
 
 #include <linux/compiler.h>
 #include <linux/atomic.h>
-#include <asm/system.h>
 
 /* Tile-specific routines to support <asm/bitops.h>. */
 unsigned long _atomic_or(volatile unsigned long *p, unsigned long mask);
diff --git a/arch/tile/include/asm/bitops_64.h b/arch/tile/include/asm/bitops_64.h
index e9c8e38..58d021a 100644
--- a/arch/tile/include/asm/bitops_64.h
+++ b/arch/tile/include/asm/bitops_64.h
@@ -17,7 +17,6 @@
 
 #include <linux/compiler.h>
 #include <linux/atomic.h>
-#include <asm/system.h>
 
 /* See <asm/bitops.h> for API comments. */
 
diff --git a/arch/tile/include/asm/cacheflush.h b/arch/tile/include/asm/cacheflush.h
index e925f4b..0fc63c4 100644
--- a/arch/tile/include/asm/cacheflush.h
+++ b/arch/tile/include/asm/cacheflush.h
@@ -20,7 +20,6 @@
 /* Keep includes the same across arches.  */
 #include <linux/mm.h>
 #include <linux/cache.h>
-#include <asm/system.h>
 #include <arch/icache.h>
 
 /* Caches are physically-indexed and so don't need special treatment */
@@ -152,4 +151,14 @@ static inline void finv_buffer_local(void *buffer, size_t size)
  */
 void finv_buffer_remote(void *buffer, size_t size, int hfh);
 
+/*
+ * On SMP systems, when the scheduler does migration-cost autodetection,
+ * it needs a way to flush as much of the CPU's caches as possible:
+ *
+ * TODO: fill this in!
+ */
+static inline void sched_cacheflush(void)
+{
+}
+
 #endif /* _ASM_TILE_CACHEFLUSH_H */
diff --git a/arch/tile/include/asm/exec.h b/arch/tile/include/asm/exec.h
new file mode 100644
index 0000000..a714e19
--- /dev/null
+++ b/arch/tile/include/asm/exec.h
@@ -0,0 +1,20 @@
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
+#ifndef _ASM_TILE_EXEC_H
+#define _ASM_TILE_EXEC_H
+
+#define arch_align_stack(x) (x)
+
+#endif /* _ASM_TILE_EXEC_H */
diff --git a/arch/tile/include/asm/pgtable.h b/arch/tile/include/asm/pgtable.h
index 1a20b7e..6749091 100644
--- a/arch/tile/include/asm/pgtable.h
+++ b/arch/tile/include/asm/pgtable.h
@@ -29,7 +29,6 @@
 #include <linux/spinlock.h>
 #include <asm/processor.h>
 #include <asm/fixmap.h>
-#include <asm/system.h>
 
 struct mm_struct;
 struct vm_area_struct;
diff --git a/arch/tile/include/asm/setup.h b/arch/tile/include/asm/setup.h
index 7caf0f3..e58613e 100644
--- a/arch/tile/include/asm/setup.h
+++ b/arch/tile/include/asm/setup.h
@@ -31,6 +31,28 @@ void early_panic(const char *fmt, ...);
 void warn_early_printk(void);
 void __init disable_early_printk(void);
 
+/* Init-time routine to do tile-specific per-cpu setup. */
+void setup_cpu(int boot);
+
+/* User-level DMA management functions */
+void grant_dma_mpls(void);
+void restrict_dma_mpls(void);
+
+#ifdef CONFIG_HARDWALL
+/* User-level network management functions */
+void reset_network_state(void);
+void grant_network_mpls(void);
+void restrict_network_mpls(void);
+struct task_struct;
+int hardwall_deactivate(struct task_struct *task);
+
+/* Hook hardwall code into changes in affinity. */
+#define arch_set_cpus_allowed(p, new_mask) do { \
+	if (p->thread.hardwall && !cpumask_equal(&p->cpus_allowed, new_mask)) \
+		hardwall_deactivate(p); \
+} while (0)
+#endif
+
 #endif /* __KERNEL__ */
 
 #endif /* _ASM_TILE_SETUP_H */
diff --git a/arch/tile/include/asm/spinlock_32.h b/arch/tile/include/asm/spinlock_32.h
index a5e4208..c0a77b3 100644
--- a/arch/tile/include/asm/spinlock_32.h
+++ b/arch/tile/include/asm/spinlock_32.h
@@ -19,7 +19,6 @@
 
 #include <linux/atomic.h>
 #include <asm/page.h>
-#include <asm/system.h>
 #include <linux/compiler.h>
 
 /*
diff --git a/arch/tile/include/asm/switch_to.h b/arch/tile/include/asm/switch_to.h
new file mode 100644
index 0000000..1d48c5f
--- /dev/null
+++ b/arch/tile/include/asm/switch_to.h
@@ -0,0 +1,76 @@
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
+#ifndef _ASM_TILE_SWITCH_TO_H
+#define _ASM_TILE_SWITCH_TO_H
+
+#include <arch/sim_def.h>
+
+/*
+ * switch_to(n) should switch tasks to task nr n, first
+ * checking that n isn't the current task, in which case it does nothing.
+ * The number of callee-saved registers saved on the kernel stack
+ * is defined here for use in copy_thread() and must agree with __switch_to().
+ */
+#define CALLEE_SAVED_FIRST_REG 30
+#define CALLEE_SAVED_REGS_COUNT 24   /* r30 to r52, plus an empty to align */
+
+#ifndef __ASSEMBLY__
+
+struct task_struct;
+
+/*
+ * Pause the DMA engine and static network before task switching.
+ */
+#define prepare_arch_switch(next) _prepare_arch_switch(next)
+void _prepare_arch_switch(struct task_struct *next);
+
+struct task_struct;
+#define switch_to(prev, next, last) ((last) = _switch_to((prev), (next)))
+extern struct task_struct *_switch_to(struct task_struct *prev,
+				      struct task_struct *next);
+
+/* Helper function for _switch_to(). */
+extern struct task_struct *__switch_to(struct task_struct *prev,
+				       struct task_struct *next,
+				       unsigned long new_system_save_k_0);
+
+/* Address that switched-away from tasks are at. */
+extern unsigned long get_switch_to_pc(void);
+
+/*
+ * Kernel threads can check to see if they need to migrate their
+ * stack whenever they return from a context switch; for user
+ * threads, we defer until they are returning to user-space.
+ */
+#define finish_arch_switch(prev) do {                                     \
+	if (unlikely((prev)->state == TASK_DEAD))                         \
+		__insn_mtspr(SPR_SIM_CONTROL, SIM_CONTROL_OS_EXIT |       \
+			((prev)->pid << _SIM_CONTROL_OPERATOR_BITS));     \
+	__insn_mtspr(SPR_SIM_CONTROL, SIM_CONTROL_OS_SWITCH |             \
+		(current->pid << _SIM_CONTROL_OPERATOR_BITS));            \
+	if (current->mm == NULL && !kstack_hash &&                        \
+	    current_thread_info()->homecache_cpu != smp_processor_id())   \
+		homecache_migrate_kthread();                              \
+} while (0)
+
+/* Support function for forking a new task. */
+void ret_from_fork(void);
+
+/* Called from ret_from_fork() when a new process starts up. */
+struct task_struct *sim_notify_fork(struct task_struct *prev);
+
+#endif /* !__ASSEMBLY__ */
+
+#endif /* _ASM_TILE_SWITCH_TO_H */
diff --git a/arch/tile/include/asm/system.h b/arch/tile/include/asm/system.h
index 23d1842..5b190b4 100644
--- a/arch/tile/include/asm/system.h
+++ b/arch/tile/include/asm/system.h
@@ -1,261 +1,4 @@
-/*
- * Copyright 2010 Tilera Corporation. All Rights Reserved.
- *
- *   This program is free software; you can redistribute it and/or
- *   modify it under the terms of the GNU General Public License
- *   as published by the Free Software Foundation, version 2.
- *
- *   This program is distributed in the hope that it will be useful, but
- *   WITHOUT ANY WARRANTY; without even the implied warranty of
- *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
- *   NON INFRINGEMENT.  See the GNU General Public License for
- *   more details.
- */
-
-#ifndef _ASM_TILE_SYSTEM_H
-#define _ASM_TILE_SYSTEM_H
-
-#ifndef __ASSEMBLY__
-
-#include <linux/types.h>
-#include <linux/irqflags.h>
-
-/* NOTE: we can't include <linux/ptrace.h> due to #include dependencies. */
-#include <asm/ptrace.h>
-
-#include <arch/chip.h>
-#include <arch/sim_def.h>
-#include <arch/spr_def.h>
-
-/*
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
- *	CPU 0				CPU 1
- *
- *	b = 2;
- *	memory_barrier();
- *	p = &b;				q = p;
- *					read_barrier_depends();
- *					d = *q;
- * </programlisting>
- *
- * because the read of "*q" depends on the read of "p" and these
- * two reads are separated by a read_barrier_depends().  However,
- * the following code, with the same initial values for "a" and "b":
- *
- * <programlisting>
- *	CPU 0				CPU 1
- *
- *	a = 2;
- *	memory_barrier();
- *	b = 3;				y = b;
- *					read_barrier_depends();
- *					x = a;
- * </programlisting>
- *
- * does not enforce ordering, since there is no data dependency between
- * the read of "a" and the read of "b".  Therefore, on some CPUs, such
- * as Alpha, "y" could be set to 3 and "x" to 0.  Use rmb()
- * in cases like this where there are no data dependencies.
- */
-
-#define read_barrier_depends()	do { } while (0)
-
-#define __sync()	__insn_mf()
-
-#if CHIP_HAS_SPLIT_CYCLE()
-#define get_cycles_low() __insn_mfspr(SPR_CYCLE_LOW)
-#else
-#define get_cycles_low() __insn_mfspr(SPR_CYCLE)   /* just get all 64 bits */
-#endif
-
-#if !CHIP_HAS_MF_WAITS_FOR_VICTIMS()
-#include <hv/syscall_public.h>
-/*
- * Issue an uncacheable load to each memory controller, then
- * wait until those loads have completed.
- */
-static inline void __mb_incoherent(void)
-{
-	long clobber_r10;
-	asm volatile("swint2"
-		     : "=R10" (clobber_r10)
-		     : "R10" (HV_SYS_fence_incoherent)
-		     : "r0", "r1", "r2", "r3", "r4",
-		       "r5", "r6", "r7", "r8", "r9",
-		       "r11", "r12", "r13", "r14",
-		       "r15", "r16", "r17", "r18", "r19",
-		       "r20", "r21", "r22", "r23", "r24",
-		       "r25", "r26", "r27", "r28", "r29");
-}
-#endif
-
-/* Fence to guarantee visibility of stores to incoherent memory. */
-static inline void
-mb_incoherent(void)
-{
-	__insn_mf();
-
-#if !CHIP_HAS_MF_WAITS_FOR_VICTIMS()
-	{
-#if CHIP_HAS_TILE_WRITE_PENDING()
-		const unsigned long WRITE_TIMEOUT_CYCLES = 400;
-		unsigned long start = get_cycles_low();
-		do {
-			if (__insn_mfspr(SPR_TILE_WRITE_PENDING) == 0)
-				return;
-		} while ((get_cycles_low() - start) < WRITE_TIMEOUT_CYCLES);
-#endif /* CHIP_HAS_TILE_WRITE_PENDING() */
-		(void) __mb_incoherent();
-	}
-#endif /* CHIP_HAS_MF_WAITS_FOR_VICTIMS() */
-}
-
-#define fast_wmb()	__sync()
-#define fast_rmb()	__sync()
-#define fast_mb()	__sync()
-#define fast_iob()	mb_incoherent()
-
-#define wmb()		fast_wmb()
-#define rmb()		fast_rmb()
-#define mb()		fast_mb()
-#define iob()		fast_iob()
-
-#ifdef CONFIG_SMP
-#define smp_mb()	mb()
-#define smp_rmb()	rmb()
-#define smp_wmb()	wmb()
-#define smp_read_barrier_depends()	read_barrier_depends()
-#else
-#define smp_mb()	barrier()
-#define smp_rmb()	barrier()
-#define smp_wmb()	barrier()
-#define smp_read_barrier_depends()	do { } while (0)
-#endif
-
-#define set_mb(var, value) \
-	do { var = value; mb(); } while (0)
-
-/*
- * Pause the DMA engine and static network before task switching.
- */
-#define prepare_arch_switch(next) _prepare_arch_switch(next)
-void _prepare_arch_switch(struct task_struct *next);
-
-
-/*
- * switch_to(n) should switch tasks to task nr n, first
- * checking that n isn't the current task, in which case it does nothing.
- * The number of callee-saved registers saved on the kernel stack
- * is defined here for use in copy_thread() and must agree with __switch_to().
- */
-#endif /* !__ASSEMBLY__ */
-#define CALLEE_SAVED_FIRST_REG 30
-#define CALLEE_SAVED_REGS_COUNT 24   /* r30 to r52, plus an empty to align */
-#ifndef __ASSEMBLY__
-struct task_struct;
-#define switch_to(prev, next, last) ((last) = _switch_to((prev), (next)))
-extern struct task_struct *_switch_to(struct task_struct *prev,
-				      struct task_struct *next);
-
-/* Helper function for _switch_to(). */
-extern struct task_struct *__switch_to(struct task_struct *prev,
-				       struct task_struct *next,
-				       unsigned long new_system_save_k_0);
-
-/* Address that switched-away from tasks are at. */
-extern unsigned long get_switch_to_pc(void);
-
-/*
- * On SMP systems, when the scheduler does migration-cost autodetection,
- * it needs a way to flush as much of the CPU's caches as possible:
- *
- * TODO: fill this in!
- */
-static inline void sched_cacheflush(void)
-{
-}
-
-#define arch_align_stack(x) (x)
-
-/*
- * Is the kernel doing fixups of unaligned accesses?  If <0, no kernel
- * intervention occurs and SIGBUS is delivered with no data address
- * info.  If 0, the kernel single-steps the instruction to discover
- * the data address to provide with the SIGBUS.  If 1, the kernel does
- * a fixup.
- */
-extern int unaligned_fixup;
-
-/* Is the kernel printing on each unaligned fixup? */
-extern int unaligned_printk;
-
-/* Number of unaligned fixups performed */
-extern unsigned int unaligned_fixup_count;
-
-/* Init-time routine to do tile-specific per-cpu setup. */
-void setup_cpu(int boot);
-
-/* User-level DMA management functions */
-void grant_dma_mpls(void);
-void restrict_dma_mpls(void);
-
-#ifdef CONFIG_HARDWALL
-/* User-level network management functions */
-void reset_network_state(void);
-void grant_network_mpls(void);
-void restrict_network_mpls(void);
-int hardwall_deactivate(struct task_struct *task);
-
-/* Hook hardwall code into changes in affinity. */
-#define arch_set_cpus_allowed(p, new_mask) do { \
-	if (p->thread.hardwall && !cpumask_equal(&p->cpus_allowed, new_mask)) \
-		hardwall_deactivate(p); \
-} while (0)
-#endif
-
-/*
- * Kernel threads can check to see if they need to migrate their
- * stack whenever they return from a context switch; for user
- * threads, we defer until they are returning to user-space.
- */
-#define finish_arch_switch(prev) do {                                     \
-	if (unlikely((prev)->state == TASK_DEAD))                         \
-		__insn_mtspr(SPR_SIM_CONTROL, SIM_CONTROL_OS_EXIT |       \
-			((prev)->pid << _SIM_CONTROL_OPERATOR_BITS));     \
-	__insn_mtspr(SPR_SIM_CONTROL, SIM_CONTROL_OS_SWITCH |             \
-		(current->pid << _SIM_CONTROL_OPERATOR_BITS));            \
-	if (current->mm == NULL && !kstack_hash &&                        \
-	    current_thread_info()->homecache_cpu != smp_processor_id())   \
-		homecache_migrate_kthread();                              \
-} while (0)
-
-/* Support function for forking a new task. */
-void ret_from_fork(void);
-
-/* Called from ret_from_fork() when a new process starts up. */
-struct task_struct *sim_notify_fork(struct task_struct *prev);
-
-#endif /* !__ASSEMBLY__ */
-
-#endif /* _ASM_TILE_SYSTEM_H */
+/* FILE TO BE DELETED. DO NOT ADD STUFF HERE! */
+#include <asm/barrier.h>
+#include <asm/exec.h>
+#include <asm/switch_to.h>
diff --git a/arch/tile/include/asm/timex.h b/arch/tile/include/asm/timex.h
index 29921f0..dc987d5 100644
--- a/arch/tile/include/asm/timex.h
+++ b/arch/tile/include/asm/timex.h
@@ -29,11 +29,13 @@ typedef unsigned long long cycles_t;
 
 #if CHIP_HAS_SPLIT_CYCLE()
 cycles_t get_cycles(void);
+#define get_cycles_low() __insn_mfspr(SPR_CYCLE_LOW)
 #else
 static inline cycles_t get_cycles(void)
 {
 	return __insn_mfspr(SPR_CYCLE);
 }
+#define get_cycles_low() __insn_mfspr(SPR_CYCLE)   /* just get all 64 bits */
 #endif
 
 cycles_t get_clock_rate(void);
diff --git a/arch/tile/include/asm/unaligned.h b/arch/tile/include/asm/unaligned.h
index 137e2de..37dfbe5 100644
--- a/arch/tile/include/asm/unaligned.h
+++ b/arch/tile/include/asm/unaligned.h
@@ -21,4 +21,19 @@
 #define get_unaligned	__get_unaligned_le
 #define put_unaligned	__put_unaligned_le
 
+/*
+ * Is the kernel doing fixups of unaligned accesses?  If <0, no kernel
+ * intervention occurs and SIGBUS is delivered with no data address
+ * info.  If 0, the kernel single-steps the instruction to discover
+ * the data address to provide with the SIGBUS.  If 1, the kernel does
+ * a fixup.
+ */
+extern int unaligned_fixup;
+
+/* Is the kernel printing on each unaligned fixup? */
+extern int unaligned_printk;
+
+/* Number of unaligned fixups performed */
+extern unsigned int unaligned_fixup_count;
+
 #endif /* _ASM_TILE_UNALIGNED_H */
diff --git a/arch/tile/kernel/early_printk.c b/arch/tile/kernel/early_printk.c
index 493a0e6..afb9c9a 100644
--- a/arch/tile/kernel/early_printk.c
+++ b/arch/tile/kernel/early_printk.c
@@ -16,6 +16,7 @@
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/string.h>
+#include <linux/irqflags.h>
 #include <asm/setup.h>
 #include <hv/hypervisor.h>
 
diff --git a/arch/tile/kernel/proc.c b/arch/tile/kernel/proc.c
index 62d8208..7a93270 100644
--- a/arch/tile/kernel/proc.c
+++ b/arch/tile/kernel/proc.c
@@ -23,6 +23,7 @@
 #include <linux/sysctl.h>
 #include <linux/hardirq.h>
 #include <linux/mman.h>
+#include <asm/unaligned.h>
 #include <asm/pgtable.h>
 #include <asm/processor.h>
 #include <asm/sections.h>
diff --git a/arch/tile/kernel/process.c b/arch/tile/kernel/process.c
index 4c1ac6e..a6a2217 100644
--- a/arch/tile/kernel/process.c
+++ b/arch/tile/kernel/process.c
@@ -27,16 +27,17 @@
 #include <linux/kernel.h>
 #include <linux/tracehook.h>
 #include <linux/signal.h>
-#include <asm/system.h>
 #include <asm/stack.h>
 #include <asm/homecache.h>
 #include <asm/syscalls.h>
 #include <asm/traps.h>
+#include <asm/setup.h>
 #ifdef CONFIG_HARDWALL
 #include <asm/hardwall.h>
 #endif
 #include <arch/chip.h>
 #include <arch/abi.h>
+#include <arch/sim_def.h>
 
 
 /*
diff --git a/arch/tile/kernel/regs_32.S b/arch/tile/kernel/regs_32.S
index caa1310..c12280c 100644
--- a/arch/tile/kernel/regs_32.S
+++ b/arch/tile/kernel/regs_32.S
@@ -13,11 +13,11 @@
  */
 
 #include <linux/linkage.h>
-#include <asm/system.h>
 #include <asm/ptrace.h>
 #include <asm/asm-offsets.h>
 #include <arch/spr_def.h>
 #include <asm/processor.h>
+#include <asm/switch_to.h>
 
 /*
  * See <asm/system.h>; called with prev and next task_struct pointers.
diff --git a/arch/tile/kernel/regs_64.S b/arch/tile/kernel/regs_64.S
index f748c1e..0829fd0 100644
--- a/arch/tile/kernel/regs_64.S
+++ b/arch/tile/kernel/regs_64.S
@@ -13,11 +13,11 @@
  */
 
 #include <linux/linkage.h>
-#include <asm/system.h>
 #include <asm/ptrace.h>
 #include <asm/asm-offsets.h>
 #include <arch/spr_def.h>
 #include <asm/processor.h>
+#include <asm/switch_to.h>
 
 /*
  * See <asm/system.h>; called with prev and next task_struct pointers.
diff --git a/arch/tile/kernel/single_step.c b/arch/tile/kernel/single_step.c
index b7a8795..bc1eb58 100644
--- a/arch/tile/kernel/single_step.c
+++ b/arch/tile/kernel/single_step.c
@@ -25,6 +25,7 @@
 #include <linux/types.h>
 #include <linux/err.h>
 #include <asm/cacheflush.h>
+#include <asm/unaligned.h>
 #include <arch/abi.h>
 #include <arch/opcode.h>
 
diff --git a/arch/tile/kernel/traps.c b/arch/tile/kernel/traps.c
index 4f47b8a..2bb6602 100644
--- a/arch/tile/kernel/traps.c
+++ b/arch/tile/kernel/traps.c
@@ -21,6 +21,7 @@
 #include <linux/ptrace.h>
 #include <asm/stack.h>
 #include <asm/traps.h>
+#include <asm/setup.h>
 
 #include <arch/interrupts.h>
 #include <arch/spr_def.h>
diff --git a/arch/tile/mm/elf.c b/arch/tile/mm/elf.c
index 55e58e9..33368d1 100644
--- a/arch/tile/mm/elf.c
+++ b/arch/tile/mm/elf.c
@@ -21,6 +21,7 @@
 #include <asm/pgtable.h>
 #include <asm/pgalloc.h>
 #include <asm/sections.h>
+#include <arch/sim_def.h>
 
 /* Notify a running simulator, if any, that an exec just occurred. */
 static void sim_notify_exec(const char *binary_name)
diff --git a/arch/tile/mm/fault.c b/arch/tile/mm/fault.c
index c1eaaa1..cba30e9 100644
--- a/arch/tile/mm/fault.c
+++ b/arch/tile/mm/fault.c
@@ -35,7 +35,6 @@
 #include <linux/syscalls.h>
 #include <linux/uaccess.h>
 
-#include <asm/system.h>
 #include <asm/pgalloc.h>
 #include <asm/sections.h>
 #include <asm/traps.h>
diff --git a/arch/tile/mm/init.c b/arch/tile/mm/init.c
index 7309988..830c490 100644
--- a/arch/tile/mm/init.c
+++ b/arch/tile/mm/init.c
@@ -38,7 +38,6 @@
 #include <linux/uaccess.h>
 #include <asm/mmu_context.h>
 #include <asm/processor.h>
-#include <asm/system.h>
 #include <asm/pgtable.h>
 #include <asm/pgalloc.h>
 #include <asm/dma.h>
diff --git a/arch/tile/mm/pgtable.c b/arch/tile/mm/pgtable.c
index de7d8e2..8730369 100644
--- a/arch/tile/mm/pgtable.c
+++ b/arch/tile/mm/pgtable.c
@@ -27,7 +27,6 @@
 #include <linux/vmalloc.h>
 #include <linux/smp.h>
 
-#include <asm/system.h>
 #include <asm/pgtable.h>
 #include <asm/pgalloc.h>
 #include <asm/fixmap.h>

