Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933521Ab0DHTd2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 15:33:28 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:47350 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933262Ab0DHTav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 15:30:51 -0400
Message-Id: <20100408192722.901224587@chello.nl>
User-Agent: quilt/0.47-1
Date: Thu, 08 Apr 2010 21:17:44 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrea Arcangeli <aarcange@redhat.com>, Avi Kivity <avi@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       David Miller <davem@davemloft.net>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, Mel Gorman <mel@csn.ul.ie>,
       Nick Piggin <npiggin@suse.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 07/13] powerpc: Preemptible mmu_gather
References: <20100408191737.296180458@chello.nl>
Content-Disposition: inline; filename=mm-preempt-tlb-gather-power.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix up powerpc to the new mmu_gather stuffs.

PPC has an extra batching queue to RCU free the actual pagetable
allocations, use the ARCH extentions for that for now.

For the ppc64_tlb_batch, which tracks the vaddrs to unhash from the
hardware hash-table, keep using per-cpu arrays but flush on context
switch and use a TIF bit to track the laxy_mmu state.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---
 arch/powerpc/include/asm/pgalloc.h     |    4 +--
 arch/powerpc/include/asm/thread_info.h |    2 +
 arch/powerpc/include/asm/tlb.h         |   10 +++++++++
 arch/powerpc/include/asm/tlbflush.h    |   16 ++++++++++-----
 arch/powerpc/kernel/process.c          |   18 +++++++++++++++++
 arch/powerpc/mm/pgtable.c              |   34 +++++++++++++++++++++++----------
 arch/powerpc/mm/tlb_hash32.c           |    2 -
 arch/powerpc/mm/tlb_hash64.c           |   12 ++++++-----
 arch/powerpc/mm/tlb_nohash.c           |    2 -
 9 files changed, 76 insertions(+), 24 deletions(-)

Index: linux-2.6/arch/powerpc/include/asm/tlb.h
===================================================================
--- linux-2.6.orig/arch/powerpc/include/asm/tlb.h
+++ linux-2.6/arch/powerpc/include/asm/tlb.h
@@ -28,6 +28,16 @@
 #define tlb_start_vma(tlb, vma)	do { } while (0)
 #define tlb_end_vma(tlb, vma)	do { } while (0)
 
+#define HAVE_ARCH_MMU_GATHER 1
+
+struct pte_freelist_batch;
+
+struct arch_mmu_gather {
+	struct pte_freelist_batch *batch;
+};
+
+#define ARCH_MMU_GATHER_INIT (struct arch_mmu_gather){ .batch = NULL, }
+
 extern void tlb_flush(struct mmu_gather *tlb);
 
 /* Get the generic bits... */
Index: linux-2.6/arch/powerpc/include/asm/tlbflush.h
===================================================================
--- linux-2.6.orig/arch/powerpc/include/asm/tlbflush.h
+++ linux-2.6/arch/powerpc/include/asm/tlbflush.h
@@ -108,18 +108,24 @@ extern void hpte_need_flush(struct mm_st
 
 static inline void arch_enter_lazy_mmu_mode(void)
 {
-	struct ppc64_tlb_batch *batch = &__get_cpu_var(ppc64_tlb_batch);
+	struct ppc64_tlb_batch *batch = &get_cpu_var(ppc64_tlb_batch);
 
 	batch->active = 1;
+
+	put_cpu_var(ppc64_tlb_batch);
 }
 
 static inline void arch_leave_lazy_mmu_mode(void)
 {
-	struct ppc64_tlb_batch *batch = &__get_cpu_var(ppc64_tlb_batch);
+	struct ppc64_tlb_batch *batch = &get_cpu_var(ppc64_tlb_batch);
+
+	if (batch->active) {
+		if (batch->index)
+			__flush_tlb_pending(batch);
+		batch->active = 0;
+	}
 
-	if (batch->index)
-		__flush_tlb_pending(batch);
-	batch->active = 0;
+	put_cpu_var(ppc64_tlb_batch);
 }
 
 #define arch_flush_lazy_mmu_mode()      do {} while (0)
Index: linux-2.6/arch/powerpc/kernel/process.c
===================================================================
--- linux-2.6.orig/arch/powerpc/kernel/process.c
+++ linux-2.6/arch/powerpc/kernel/process.c
@@ -389,6 +389,9 @@ struct task_struct *__switch_to(struct t
 	struct thread_struct *new_thread, *old_thread;
 	unsigned long flags;
 	struct task_struct *last;
+#ifdef CONFIG_PPC64
+	struct ppc64_tlb_batch *batch;
+#endif
 
 #ifdef CONFIG_SMP
 	/* avoid complexity of lazy save/restore of fpu
@@ -479,6 +482,14 @@ struct task_struct *__switch_to(struct t
 		old_thread->accum_tb += (current_tb - start_tb);
 		new_thread->start_tb = current_tb;
 	}
+
+	batch = &__get_cpu_var(ppc64_tlb_batch);
+	if (batch->active) {
+		set_ti_thread_flag(task_thread_info(prev), TIF_LAZY_MMU);
+		if (batch->index)
+			__flush_tlb_pending(batch);
+		batch->active = 0;
+	}
 #endif
 
 	local_irq_save(flags);
@@ -495,6 +506,13 @@ struct task_struct *__switch_to(struct t
 	hard_irq_disable();
 	last = _switch(old_thread, new_thread);
 
+#ifdef CONFIG_PPC64
+	if (test_and_clear_ti_thread_flag(task_thread_info(new), TIF_LAZY_MMU)) {
+		batch = &__get_cpu_var(ppc64_tlb_batch);
+		batch->active = 1;
+	}
+#endif
+
 	local_irq_restore(flags);
 
 	return last;
Index: linux-2.6/arch/powerpc/mm/pgtable.c
===================================================================
--- linux-2.6.orig/arch/powerpc/mm/pgtable.c
+++ linux-2.6/arch/powerpc/mm/pgtable.c
@@ -33,8 +33,6 @@
 
 #include "mmu_decl.h"
 
-DEFINE_PER_CPU(struct mmu_gather, mmu_gathers);
-
 #ifdef CONFIG_SMP
 
 /*
@@ -43,7 +41,6 @@ DEFINE_PER_CPU(struct mmu_gather, mmu_ga
  * freeing a page table page that is being walked without locks
  */
 
-static DEFINE_PER_CPU(struct pte_freelist_batch *, pte_freelist_cur);
 static unsigned long pte_freelist_forced_free;
 
 struct pte_freelist_batch
@@ -98,12 +95,30 @@ static void pte_free_submit(struct pte_f
 
 void pgtable_free_tlb(struct mmu_gather *tlb, void *table, unsigned shift)
 {
-	/* This is safe since tlb_gather_mmu has disabled preemption */
-	struct pte_freelist_batch **batchp = &__get_cpu_var(pte_freelist_cur);
+	struct pte_freelist_batch **batchp = &tlb->arch.batch;
 	unsigned long pgf;
 
-	if (atomic_read(&tlb->mm->mm_users) < 2 ||
-	    cpumask_equal(mm_cpumask(tlb->mm), cpumask_of(smp_processor_id()))){
+	/*
+	 * A comment here about on why we have RCU freed page tables might be
+	 * interesting, also explaining why we don't need any sort of grace
+	 * period for mm_users == 1, and have some home brewn smp_call_func()
+	 * for single frees.
+	 *
+	 * The only lockless page table walker I know of is gup_fast() which
+	 * relies on irq_disable(). So my guess is that mm_users == 1 means
+	 * that there cannot be another thread and so precludes gup_fast()
+	 * concurrency.
+	 *
+	 * If there are, but we fail to batch, we need to IPI (all?) CPUs so as
+	 * to serialize against the IRQ disable. In case we do batch, the RCU
+	 * grace period is at least long enough to cover IRQ disabled sections
+	 * (XXX assumption, not strictly true).
+	 *
+	 * All this results in us doing our own free batching and not using
+	 * the generic mmu_gather batches (XXX fix that somehow?).
+	 */
+
+	if (atomic_read(&tlb->mm->mm_users) < 2) {
 		pgtable_free(table, shift);
 		return;
 	}
@@ -125,10 +140,9 @@ void pgtable_free_tlb(struct mmu_gather 
 	}
 }
 
-void pte_free_finish(void)
+void pte_free_finish(struct mmu_gather *tlb)
 {
-	/* This is safe since tlb_gather_mmu has disabled preemption */
-	struct pte_freelist_batch **batchp = &__get_cpu_var(pte_freelist_cur);
+	struct pte_freelist_batch **batchp = &tlb->arch.batch;
 
 	if (*batchp == NULL)
 		return;
Index: linux-2.6/arch/powerpc/mm/tlb_hash64.c
===================================================================
--- linux-2.6.orig/arch/powerpc/mm/tlb_hash64.c
+++ linux-2.6/arch/powerpc/mm/tlb_hash64.c
@@ -38,13 +38,11 @@ DEFINE_PER_CPU(struct ppc64_tlb_batch, p
  * neesd to be flushed. This function will either perform the flush
  * immediately or will batch it up if the current CPU has an active
  * batch on it.
- *
- * Must be called from within some kind of spinlock/non-preempt region...
  */
 void hpte_need_flush(struct mm_struct *mm, unsigned long addr,
 		     pte_t *ptep, unsigned long pte, int huge)
 {
-	struct ppc64_tlb_batch *batch = &__get_cpu_var(ppc64_tlb_batch);
+	struct ppc64_tlb_batch *batch = &get_cpu_var(ppc64_tlb_batch);
 	unsigned long vsid, vaddr;
 	unsigned int psize;
 	int ssize;
@@ -99,6 +97,7 @@ void hpte_need_flush(struct mm_struct *m
 	 */
 	if (!batch->active) {
 		flush_hash_page(vaddr, rpte, psize, ssize, 0);
+		put_cpu_var(ppc64_tlb_batch);
 		return;
 	}
 
@@ -127,6 +126,7 @@ void hpte_need_flush(struct mm_struct *m
 	batch->index = ++i;
 	if (i >= PPC64_TLB_BATCH_NR)
 		__flush_tlb_pending(batch);
+	put_cpu_var(ppc64_tlb_batch);
 }
 
 /*
@@ -155,7 +155,7 @@ void __flush_tlb_pending(struct ppc64_tl
 
 void tlb_flush(struct mmu_gather *tlb)
 {
-	struct ppc64_tlb_batch *tlbbatch = &__get_cpu_var(ppc64_tlb_batch);
+	struct ppc64_tlb_batch *tlbbatch = &get_cpu_var(ppc64_tlb_batch);
 
 	/* If there's a TLB batch pending, then we must flush it because the
 	 * pages are going to be freed and we really don't want to have a CPU
@@ -164,8 +164,10 @@ void tlb_flush(struct mmu_gather *tlb)
 	if (tlbbatch->index)
 		__flush_tlb_pending(tlbbatch);
 
+	put_cpu_var(ppc64_tlb_batch);
+
 	/* Push out batch of freed page tables */
-	pte_free_finish();
+	pte_free_finish(tlb);
 }
 
 /**
Index: linux-2.6/arch/powerpc/include/asm/thread_info.h
===================================================================
--- linux-2.6.orig/arch/powerpc/include/asm/thread_info.h
+++ linux-2.6/arch/powerpc/include/asm/thread_info.h
@@ -111,6 +111,7 @@ static inline struct thread_info *curren
 #define TIF_NOTIFY_RESUME	13	/* callback before returning to user */
 #define TIF_FREEZE		14	/* Freezing for suspend */
 #define TIF_RUNLATCH		15	/* Is the runlatch enabled? */
+#define TIF_LAZY_MMU		16	/* tlb_batch is active */
 
 /* as above, but as bit values */
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
@@ -128,6 +129,7 @@ static inline struct thread_info *curren
 #define _TIF_NOTIFY_RESUME	(1<<TIF_NOTIFY_RESUME)
 #define _TIF_FREEZE		(1<<TIF_FREEZE)
 #define _TIF_RUNLATCH		(1<<TIF_RUNLATCH)
+#define _TIF_LAZY_MMU		(1<<TIF_LAZY_MMU)
 #define _TIF_SYSCALL_T_OR_A	(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT|_TIF_SECCOMP)
 
 #define _TIF_USER_WORK_MASK	(_TIF_SIGPENDING | _TIF_NEED_RESCHED | \
Index: linux-2.6/arch/powerpc/include/asm/pgalloc.h
===================================================================
--- linux-2.6.orig/arch/powerpc/include/asm/pgalloc.h
+++ linux-2.6/arch/powerpc/include/asm/pgalloc.h
@@ -32,13 +32,13 @@ static inline void pte_free(struct mm_st
 
 #ifdef CONFIG_SMP
 extern void pgtable_free_tlb(struct mmu_gather *tlb, void *table, unsigned shift);
-extern void pte_free_finish(void);
+extern void pte_free_finish(struct mmu_gather *tlb);
 #else /* CONFIG_SMP */
 static inline void pgtable_free_tlb(struct mmu_gather *tlb, void *table, unsigned shift)
 {
 	pgtable_free(table, shift);
 }
-static inline void pte_free_finish(void) { }
+static inline void pte_free_finish(struct mmu_gather *tlb) { }
 #endif /* !CONFIG_SMP */
 
 static inline void __pte_free_tlb(struct mmu_gather *tlb, struct page *ptepage,
Index: linux-2.6/arch/powerpc/mm/tlb_hash32.c
===================================================================
--- linux-2.6.orig/arch/powerpc/mm/tlb_hash32.c
+++ linux-2.6/arch/powerpc/mm/tlb_hash32.c
@@ -73,7 +73,7 @@ void tlb_flush(struct mmu_gather *tlb)
 	}
 
 	/* Push out batch of freed page tables */
-	pte_free_finish();
+	pte_free_finish(tlb);
 }
 
 /*
Index: linux-2.6/arch/powerpc/mm/tlb_nohash.c
===================================================================
--- linux-2.6.orig/arch/powerpc/mm/tlb_nohash.c
+++ linux-2.6/arch/powerpc/mm/tlb_nohash.c
@@ -298,7 +298,7 @@ void tlb_flush(struct mmu_gather *tlb)
 	flush_tlb_mm(tlb->mm);
 
 	/* Push out batch of freed page tables */
-	pte_free_finish();
+	pte_free_finish(tlb);
 }
 
 /*


