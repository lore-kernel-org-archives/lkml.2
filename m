Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030546Ab2CGTvP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 14:51:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38246 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030312Ab2CGTvI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 14:51:08 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 26/29] Disintegrate asm/system.h for Tile
To: paul.gortmaker@windriver.com, hpa@zytor.com
Cc: torvalds@linux-foundation.org, sfr@canb.auug.org.au, mingo@redhat.com,
        arnd@arndb.de, dhowells@redhat.com, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Date: Wed, 07 Mar 2012 19:50:46 +0000
Message-ID: <20120307195046.15987.91414.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120307194548.15987.36073.stgit@warthog.procyon.org.uk>
References: <20120307194548.15987.36073.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Disintegrate asm/system.h for Tile.  Not compiled.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/tile/include/asm/barrier.h    |  140 +++++++++++++++++++
 arch/tile/include/asm/cacheflush.h |   10 +
 arch/tile/include/asm/exec.h       |   20 +++
 arch/tile/include/asm/setup.h      |   21 +++
 arch/tile/include/asm/switch_to.h  |   72 ++++++++++
 arch/tile/include/asm/system.h     |  261 ------------------------------------
 arch/tile/include/asm/timex.h      |    2 
 arch/tile/include/asm/unaligned.h  |   15 ++
 8 files changed, 280 insertions(+), 261 deletions(-)
 create mode 100644 arch/tile/include/asm/barrier.h
 create mode 100644 arch/tile/include/asm/exec.h
 create mode 100644 arch/tile/include/asm/switch_to.h
 delete mode 100644 arch/tile/include/asm/system.h

diff --git a/arch/tile/include/asm/barrier.h b/arch/tile/include/asm/barrier.h
new file mode 100644
index 0000000..e1bb6ae
--- /dev/null
+++ b/arch/tile/include/asm/barrier.h
@@ -0,0 +1,140 @@
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
+#endif _ASM_TILE_BARRIER_H
diff --git a/arch/tile/include/asm/cacheflush.h b/arch/tile/include/asm/cacheflush.h
index c2e0fda..0fc63c4 100644
--- a/arch/tile/include/asm/cacheflush.h
+++ b/arch/tile/include/asm/cacheflush.h
@@ -151,4 +151,14 @@ static inline void finv_buffer_local(void *buffer, size_t size)
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
diff --git a/arch/tile/include/asm/setup.h b/arch/tile/include/asm/setup.h
index 7caf0f3..43f82dc 100644
--- a/arch/tile/include/asm/setup.h
+++ b/arch/tile/include/asm/setup.h
@@ -31,6 +31,27 @@ void early_panic(const char *fmt, ...);
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
diff --git a/arch/tile/include/asm/switch_to.h b/arch/tile/include/asm/switch_to.h
new file mode 100644
index 0000000..fd6e527
--- /dev/null
+++ b/arch/tile/include/asm/switch_to.h
@@ -0,0 +1,72 @@
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
deleted file mode 100644
index 23d1842..0000000
--- a/arch/tile/include/asm/system.h
+++ /dev/null
@@ -1,261 +0,0 @@
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

