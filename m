Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932601Ab0JZCzv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 22:55:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32758 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932577Ab0JZCzr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 22:55:47 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 29/43] MN10300: SMP TLB flushing
To: linux-am33-list@redhat.com
From: David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        Akira Takeuchi <takeuchi.akr@jp.panasonic.com>,
        Kiyoshi Owada <owada.kiyoshi@jp.panasonic.com>
Date: Tue, 26 Oct 2010 03:55:36 +0100
Message-ID: <20101026025536.23512.19652.stgit@warthog.procyon.org.uk>
In-Reply-To: <20101026025301.23512.24525.stgit@warthog.procyon.org.uk>
References: <20101026025301.23512.24525.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.15-97-g9680-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Akira Takeuchi <takeuchi.akr@jp.panasonic.com>

Implement global TLB flushing for MN10300.  This will be used by the AM34 which
is SMP capable.

Signed-off-by: Akira Takeuchi <takeuchi.akr@jp.panasonic.com>
Signed-off-by: Kiyoshi Owada <owada.kiyoshi@jp.panasonic.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/mn10300/include/asm/mmu_context.h |   22 +++
 arch/mn10300/include/asm/tlbflush.h    |   81 ++++++++----
 arch/mn10300/mm/Makefile               |    2 
 arch/mn10300/mm/tlb-smp.c              |  214 ++++++++++++++++++++++++++++++++
 4 files changed, 290 insertions(+), 29 deletions(-)
 create mode 100644 arch/mn10300/mm/tlb-smp.c


diff --git a/arch/mn10300/include/asm/mmu_context.h b/arch/mn10300/include/asm/mmu_context.h
index 5fb3648..c8f6c82 100644
--- a/arch/mn10300/include/asm/mmu_context.h
+++ b/arch/mn10300/include/asm/mmu_context.h
@@ -36,6 +36,22 @@
 
 #define enter_lazy_tlb(mm, tsk)	do {} while (0)
 
+static inline void cpu_ran_vm(int cpu, struct mm_struct *mm)
+{
+#ifdef CONFIG_SMP
+	cpumask_set_cpu(cpu, mm_cpumask(mm));
+#endif
+}
+
+static inline bool cpu_maybe_ran_vm(int cpu, struct mm_struct *mm)
+{
+#ifdef CONFIG_SMP
+	return cpumask_test_and_set_cpu(cpu, mm_cpumask(mm));
+#else
+	return true;
+#endif
+}
+
 #ifdef CONFIG_MN10300_TLB_USE_PIDR
 extern unsigned long mmu_context_cache[NR_CPUS];
 #define mm_context(mm)	(mm->context.tlbpid[smp_processor_id()])
@@ -127,7 +143,13 @@ static inline void activate_context(struct mm_struct *mm)
 static inline void switch_mm(struct mm_struct *prev, struct mm_struct *next,
 			     struct task_struct *tsk)
 {
+	int cpu = smp_processor_id();
+
 	if (prev != next) {
+#ifdef CONFIG_SMP
+		per_cpu(cpu_tlbstate, cpu).active_mm = next;
+#endif
+		cpu_ran_vm(cpu, next);
 		PTBR = (unsigned long) next->pgd;
 		activate_context(next);
 	}
diff --git a/arch/mn10300/include/asm/tlbflush.h b/arch/mn10300/include/asm/tlbflush.h
index c3c194d..efddd6e 100644
--- a/arch/mn10300/include/asm/tlbflush.h
+++ b/arch/mn10300/include/asm/tlbflush.h
@@ -11,6 +11,7 @@
 #ifndef _ASM_TLBFLUSH_H
 #define _ASM_TLBFLUSH_H
 
+#include <linux/mm.h>
 #include <asm/processor.h>
 
 struct tlb_state {
@@ -93,39 +94,61 @@ void local_flush_tlb_page(struct mm_struct *mm, unsigned long addr)
  *  - flush_tlb_range(mm, start, end) flushes a range of pages
  *  - flush_tlb_pgtables(mm, start, end) flushes a range of page tables
  */
-#define flush_tlb_all()				\
-do {						\
-	preempt_disable();			\
-	local_flush_tlb_all();			\
-	preempt_enable();			\
-} while (0)
-
-#define flush_tlb_mm(mm)			\
-do {						\
-	preempt_disable();			\
-	local_flush_tlb_all();			\
-	preempt_enable();			\
-} while (0)
-
-#define flush_tlb_range(vma, start, end)			\
-do {								\
-	unsigned long __s __attribute__((unused)) = (start);	\
-	unsigned long __e __attribute__((unused)) = (end);	\
-	preempt_disable();					\
-	local_flush_tlb_all();					\
-	preempt_enable();					\
-} while (0)
+#ifdef CONFIG_SMP
+
+#include <asm/smp.h>
+
+extern void flush_tlb_all(void);
+extern void flush_tlb_current_task(void);
+extern void flush_tlb_mm(struct mm_struct *);
+extern void flush_tlb_page(struct vm_area_struct *, unsigned long);
+
+#define flush_tlb()		flush_tlb_current_task()
+
+static inline void flush_tlb_range(struct vm_area_struct *vma,
+				   unsigned long start, unsigned long end)
+{
+	flush_tlb_mm(vma->vm_mm);
+}
+
+#else   /* CONFIG_SMP */
+
+static inline void flush_tlb_all(void)
+{
+	preempt_disable();
+	local_flush_tlb_all();
+	preempt_enable();
+}
+
+static inline void flush_tlb_mm(struct mm_struct *mm)
+{
+	preempt_disable();
+	local_flush_tlb_all();
+	preempt_enable();
+}
+
+static inline void flush_tlb_range(struct vm_area_struct *vma,
+				   unsigned long start, unsigned long end)
+{
+	preempt_disable();
+	local_flush_tlb_all();
+	preempt_enable();
+}
 
 #define flush_tlb_page(vma, addr)	local_flush_tlb_page((vma)->vm_mm, addr)
 #define flush_tlb()			flush_tlb_all()
 
-#define flush_tlb_kernel_range(start, end)			\
-do {								\
-	unsigned long __s __attribute__((unused)) = (start);	\
-	unsigned long __e __attribute__((unused)) = (end);	\
-	flush_tlb_all();					\
-} while (0)
+#endif /* CONFIG_SMP */
 
-#define flush_tlb_pgtables(mm, start, end)	do {} while (0)
+static inline void flush_tlb_kernel_range(unsigned long start,
+					  unsigned long end)
+{
+	flush_tlb_all();
+}
+
+static inline void flush_tlb_pgtables(struct mm_struct *mm,
+				      unsigned long start, unsigned long end)
+{
+}
 
 #endif /* _ASM_TLBFLUSH_H */
diff --git a/arch/mn10300/mm/Makefile b/arch/mn10300/mm/Makefile
index 184745f..203fee2 100644
--- a/arch/mn10300/mm/Makefile
+++ b/arch/mn10300/mm/Makefile
@@ -18,3 +18,5 @@ cacheflush-$(CONFIG_MN10300_CACHE_DISABLED) := cache-disabled.o
 obj-y := \
 	init.o fault.o pgtable.o extable.o tlb-mn10300.o mmu-context.o \
 	misalignment.o dma-alloc.o $(cacheflush-y)
+
+obj-$(CONFIG_SMP) += tlb-smp.o
diff --git a/arch/mn10300/mm/tlb-smp.c b/arch/mn10300/mm/tlb-smp.c
new file mode 100644
index 0000000..0b6a5ad
--- /dev/null
+++ b/arch/mn10300/mm/tlb-smp.c
@@ -0,0 +1,214 @@
+/* SMP TLB support routines.
+ *
+ * Copyright (C) 2006-2008 Panasonic Corporation
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ */
+#include <linux/interrupt.h>
+#include <linux/spinlock.h>
+#include <linux/init.h>
+#include <linux/jiffies.h>
+#include <linux/cpumask.h>
+#include <linux/err.h>
+#include <linux/kernel.h>
+#include <linux/delay.h>
+#include <linux/sched.h>
+#include <linux/profile.h>
+#include <linux/smp.h>
+#include <asm/tlbflush.h>
+#include <asm/system.h>
+#include <asm/bitops.h>
+#include <asm/processor.h>
+#include <asm/bug.h>
+#include <asm/exceptions.h>
+#include <asm/hardirq.h>
+#include <asm/fpu.h>
+#include <asm/mmu_context.h>
+#include <asm/thread_info.h>
+#include <asm/cpu-regs.h>
+#include <asm/intctl-regs.h>
+
+/*
+ * For flush TLB
+ */
+#define FLUSH_ALL	0xffffffff
+
+static cpumask_t flush_cpumask;
+static struct mm_struct *flush_mm;
+static unsigned long flush_va;
+static DEFINE_SPINLOCK(tlbstate_lock);
+
+DEFINE_PER_CPU_SHARED_ALIGNED(struct tlb_state, cpu_tlbstate) = {
+	&init_mm, 0
+};
+
+static void flush_tlb_others(cpumask_t cpumask, struct mm_struct *mm,
+			     unsigned long va);
+static void do_flush_tlb_all(void *info);
+
+/**
+ * smp_flush_tlb - Callback to invalidate the TLB.
+ * @unused: Callback context (ignored).
+ */
+void smp_flush_tlb(void *unused)
+{
+	unsigned long cpu_id;
+
+	cpu_id = get_cpu();
+
+	if (!cpu_isset(cpu_id, flush_cpumask))
+		/* This was a BUG() but until someone can quote me the line
+		 * from the intel manual that guarantees an IPI to multiple
+		 * CPUs is retried _only_ on the erroring CPUs its staying as a
+		 * return
+		 *
+		 * BUG();
+		 */
+		goto out;
+
+	if (flush_va == FLUSH_ALL)
+		local_flush_tlb();
+	else
+		local_flush_tlb_page(flush_mm, flush_va);
+
+	smp_mb__before_clear_bit();
+	cpu_clear(cpu_id, flush_cpumask);
+	smp_mb__after_clear_bit();
+out:
+	put_cpu();
+}
+
+/**
+ * flush_tlb_others - Tell the specified CPUs to invalidate their TLBs
+ * @cpumask: The list of CPUs to target.
+ * @mm: The VM context to flush from (if va!=FLUSH_ALL).
+ * @va: Virtual address to flush or FLUSH_ALL to flush everything.
+ */
+static void flush_tlb_others(cpumask_t cpumask, struct mm_struct *mm,
+			     unsigned long va)
+{
+	cpumask_t tmp;
+
+	/* A couple of sanity checks (to be removed):
+	 * - mask must not be empty
+	 * - current CPU must not be in mask
+	 * - we do not send IPIs to as-yet unbooted CPUs.
+	 */
+	BUG_ON(!mm);
+	BUG_ON(cpus_empty(cpumask));
+	BUG_ON(cpu_isset(smp_processor_id(), cpumask));
+
+	cpus_and(tmp, cpumask, cpu_online_map);
+	BUG_ON(!cpus_equal(cpumask, tmp));
+
+	/* I'm not happy about this global shared spinlock in the MM hot path,
+	 * but we'll see how contended it is.
+	 *
+	 * Temporarily this turns IRQs off, so that lockups are detected by the
+	 * NMI watchdog.
+	 */
+	spin_lock(&tlbstate_lock);
+
+	flush_mm = mm;
+	flush_va = va;
+#if NR_CPUS <= BITS_PER_LONG
+	atomic_set_mask(cpumask.bits[0], &flush_cpumask.bits[0]);
+#else
+#error Not supported.
+#endif
+
+	/* FIXME: if NR_CPUS>=3, change send_IPI_mask */
+	smp_call_function(smp_flush_tlb, NULL, 1);
+
+	while (!cpus_empty(flush_cpumask))
+		/* Lockup detection does not belong here */
+		smp_mb();
+
+	flush_mm = NULL;
+	flush_va = 0;
+	spin_unlock(&tlbstate_lock);
+}
+
+/**
+ * flush_tlb_mm - Invalidate TLB of specified VM context
+ * @mm: The VM context to invalidate.
+ */
+void flush_tlb_mm(struct mm_struct *mm)
+{
+	cpumask_t cpu_mask;
+
+	preempt_disable();
+	cpu_mask = mm->cpu_vm_mask;
+	cpu_clear(smp_processor_id(), cpu_mask);
+
+	local_flush_tlb();
+	if (!cpus_empty(cpu_mask))
+		flush_tlb_others(cpu_mask, mm, FLUSH_ALL);
+
+	preempt_enable();
+}
+
+/**
+ * flush_tlb_current_task - Invalidate TLB of current task
+ */
+void flush_tlb_current_task(void)
+{
+	struct mm_struct *mm = current->mm;
+	cpumask_t cpu_mask;
+
+	preempt_disable();
+	cpu_mask = mm->cpu_vm_mask;
+	cpu_clear(smp_processor_id(), cpu_mask);
+
+	local_flush_tlb();
+	if (!cpus_empty(cpu_mask))
+		flush_tlb_others(cpu_mask, mm, FLUSH_ALL);
+
+	preempt_enable();
+}
+
+/**
+ * flush_tlb_page - Invalidate TLB of page
+ * @vma: The VM context to invalidate the page for.
+ * @va: The virtual address of the page to invalidate.
+ */
+void flush_tlb_page(struct vm_area_struct *vma, unsigned long va)
+{
+	struct mm_struct *mm = vma->vm_mm;
+	cpumask_t cpu_mask;
+
+	preempt_disable();
+	cpu_mask = mm->cpu_vm_mask;
+	cpu_clear(smp_processor_id(), cpu_mask);
+
+	local_flush_tlb_page(mm, va);
+	if (!cpus_empty(cpu_mask))
+		flush_tlb_others(cpu_mask, mm, va);
+
+	preempt_enable();
+}
+
+/**
+ * do_flush_tlb_all - Callback to completely invalidate a TLB
+ * @unused: Callback context (ignored).
+ */
+static void do_flush_tlb_all(void *unused)
+{
+	local_flush_tlb_all();
+}
+
+/**
+ * flush_tlb_all - Completely invalidate TLBs on all CPUs
+ */
+void flush_tlb_all(void)
+{
+	on_each_cpu(do_flush_tlb_all, 0, 1);
+}

