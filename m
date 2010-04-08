Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933492Ab0DHTc6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 15:32:58 -0400
Received: from casper.infradead.org ([85.118.1.10]:50022 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933452Ab0DHTbE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 15:31:04 -0400
Message-Id: <20100408192722.987227219@chello.nl>
User-Agent: quilt/0.47-1
Date: Thu, 08 Apr 2010 21:17:46 +0200
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
Subject: [PATCH 09/13] mm, powerpc: Move the RCU page-table freeing into generic code
References: <20100408191737.296180458@chello.nl>
Content-Disposition: inline; filename=mm-preempt-tlb-gather-rcu.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case other architectures require RCU freed page-tables to implement
gup_fast(), provide the means to do so by moving the logic into generic
code.

Requested-by: David Miller <davem@davemloft.net>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---
 arch/powerpc/include/asm/pgalloc.h |   23 ++++++-
 arch/powerpc/include/asm/tlb.h     |   10 ---
 arch/powerpc/mm/pgtable.c          |  119 -------------------------------------
 arch/powerpc/mm/tlb_hash32.c       |    3 
 arch/powerpc/mm/tlb_hash64.c       |    3 
 arch/powerpc/mm/tlb_nohash.c       |    3 
 include/asm-generic/tlb.h          |   57 ++++++++++++++++-
 mm/memory.c                        |   81 +++++++++++++++++++++++++
 8 files changed, 153 insertions(+), 146 deletions(-)

Index: linux-2.6/arch/powerpc/include/asm/pgalloc.h
===================================================================
--- linux-2.6.orig/arch/powerpc/include/asm/pgalloc.h
+++ linux-2.6/arch/powerpc/include/asm/pgalloc.h
@@ -31,14 +31,31 @@ static inline void pte_free(struct mm_st
 #endif
 
 #ifdef CONFIG_SMP
-extern void pgtable_free_tlb(struct mmu_gather *tlb, void *table, unsigned shift);
-extern void pte_free_finish(struct mmu_gather *tlb);
+#define HAVE_ARCH_RCU_TABLE_FREE
+
+struct mmu_gather;
+extern void tlb_remove_table(struct mmu_gather *, void *);
+
+static inline void pgtable_free_tlb(struct mmu_gather *tlb, void *table, int shift)
+{
+	unsigned long pgf = (unsigned long)table;
+	BUG_ON(shift > MAX_PGTABLE_INDEX_SIZE);
+	pgf |= shift;
+	tlb_remove_table(tlb, (void *)pgf);
+}
+
+static inline void __tlb_remove_table(void *_table)
+{
+	void *table = (void *)((unsigned long)_table & ~MAX_PGTABLE_INDEX_SIZE);
+	unsigned shift = (unsigned long)_table & MAX_PGTABLE_INDEX_SIZE;
+
+	pgtable_free(table, shift);
+}
 #else /* CONFIG_SMP */
 static inline void pgtable_free_tlb(struct mmu_gather *tlb, void *table, unsigned shift)
 {
 	pgtable_free(table, shift);
 }
-static inline void pte_free_finish(struct mmu_gather *tlb) { }
 #endif /* !CONFIG_SMP */
 
 static inline void __pte_free_tlb(struct mmu_gather *tlb, struct page *ptepage,
Index: linux-2.6/arch/powerpc/include/asm/tlb.h
===================================================================
--- linux-2.6.orig/arch/powerpc/include/asm/tlb.h
+++ linux-2.6/arch/powerpc/include/asm/tlb.h
@@ -28,16 +28,6 @@
 #define tlb_start_vma(tlb, vma)	do { } while (0)
 #define tlb_end_vma(tlb, vma)	do { } while (0)
 
-#define HAVE_ARCH_MMU_GATHER 1
-
-struct pte_freelist_batch;
-
-struct arch_mmu_gather {
-	struct pte_freelist_batch *batch;
-};
-
-#define ARCH_MMU_GATHER_INIT (struct arch_mmu_gather){ .batch = NULL, }
-
 extern void tlb_flush(struct mmu_gather *tlb);
 
 /* Get the generic bits... */
Index: linux-2.6/arch/powerpc/mm/pgtable.c
===================================================================
--- linux-2.6.orig/arch/powerpc/mm/pgtable.c
+++ linux-2.6/arch/powerpc/mm/pgtable.c
@@ -33,125 +33,6 @@
 
 #include "mmu_decl.h"
 
-#ifdef CONFIG_SMP
-
-/*
- * Handle batching of page table freeing on SMP. Page tables are
- * queued up and send to be freed later by RCU in order to avoid
- * freeing a page table page that is being walked without locks
- */
-
-static unsigned long pte_freelist_forced_free;
-
-struct pte_freelist_batch
-{
-	struct rcu_head	rcu;
-	unsigned int	index;
-	unsigned long	tables[0];
-};
-
-#define PTE_FREELIST_SIZE \
-	((PAGE_SIZE - sizeof(struct pte_freelist_batch)) \
-	  / sizeof(unsigned long))
-
-static void pte_free_smp_sync(void *arg)
-{
-	/* Do nothing, just ensure we sync with all CPUs */
-}
-
-/* This is only called when we are critically out of memory
- * (and fail to get a page in pte_free_tlb).
- */
-static void pgtable_free_now(void *table, unsigned shift)
-{
-	pte_freelist_forced_free++;
-
-	smp_call_function(pte_free_smp_sync, NULL, 1);
-
-	pgtable_free(table, shift);
-}
-
-static void pte_free_rcu_callback(struct rcu_head *head)
-{
-	struct pte_freelist_batch *batch =
-		container_of(head, struct pte_freelist_batch, rcu);
-	unsigned int i;
-
-	for (i = 0; i < batch->index; i++) {
-		void *table = (void *)(batch->tables[i] & ~MAX_PGTABLE_INDEX_SIZE);
-		unsigned shift = batch->tables[i] & MAX_PGTABLE_INDEX_SIZE;
-
-		pgtable_free(table, shift);
-	}
-
-	free_page((unsigned long)batch);
-}
-
-static void pte_free_submit(struct pte_freelist_batch *batch)
-{
-	INIT_RCU_HEAD(&batch->rcu);
-	call_rcu(&batch->rcu, pte_free_rcu_callback);
-}
-
-void pgtable_free_tlb(struct mmu_gather *tlb, void *table, unsigned shift)
-{
-	struct pte_freelist_batch **batchp = &tlb->arch.batch;
-	unsigned long pgf;
-
-	/*
-	 * A comment here about on why we have RCU freed page tables might be
-	 * interesting, also explaining why we don't need any sort of grace
-	 * period for mm_users == 1, and have some home brewn smp_call_func()
-	 * for single frees.
-	 *
-	 * The only lockless page table walker I know of is gup_fast() which
-	 * relies on irq_disable(). So my guess is that mm_users == 1 means
-	 * that there cannot be another thread and so precludes gup_fast()
-	 * concurrency.
-	 *
-	 * If there are, but we fail to batch, we need to IPI (all?) CPUs so as
-	 * to serialize against the IRQ disable. In case we do batch, the RCU
-	 * grace period is at least long enough to cover IRQ disabled sections
-	 * (XXX assumption, not strictly true).
-	 *
-	 * All this results in us doing our own free batching and not using
-	 * the generic mmu_gather batches (XXX fix that somehow?).
-	 */
-
-	if (atomic_read(&tlb->mm->mm_users) < 2) {
-		pgtable_free(table, shift);
-		return;
-	}
-
-	if (*batchp == NULL) {
-		*batchp = (struct pte_freelist_batch *)__get_free_page(GFP_ATOMIC);
-		if (*batchp == NULL) {
-			pgtable_free_now(table, shift);
-			return;
-		}
-		(*batchp)->index = 0;
-	}
-	BUG_ON(shift > MAX_PGTABLE_INDEX_SIZE);
-	pgf = (unsigned long)table | shift;
-	(*batchp)->tables[(*batchp)->index++] = pgf;
-	if ((*batchp)->index == PTE_FREELIST_SIZE) {
-		pte_free_submit(*batchp);
-		*batchp = NULL;
-	}
-}
-
-void pte_free_finish(struct mmu_gather *tlb)
-{
-	struct pte_freelist_batch **batchp = &tlb->arch.batch;
-
-	if (*batchp == NULL)
-		return;
-	pte_free_submit(*batchp);
-	*batchp = NULL;
-}
-
-#endif /* CONFIG_SMP */
-
 static inline int is_exec_fault(void)
 {
 	return current->thread.regs && TRAP(current->thread.regs) == 0x400;
Index: linux-2.6/arch/powerpc/mm/tlb_hash32.c
===================================================================
--- linux-2.6.orig/arch/powerpc/mm/tlb_hash32.c
+++ linux-2.6/arch/powerpc/mm/tlb_hash32.c
@@ -71,9 +71,6 @@ void tlb_flush(struct mmu_gather *tlb)
 		 */
 		_tlbia();
 	}
-
-	/* Push out batch of freed page tables */
-	pte_free_finish(tlb);
 }
 
 /*
Index: linux-2.6/arch/powerpc/mm/tlb_hash64.c
===================================================================
--- linux-2.6.orig/arch/powerpc/mm/tlb_hash64.c
+++ linux-2.6/arch/powerpc/mm/tlb_hash64.c
@@ -165,9 +165,6 @@ void tlb_flush(struct mmu_gather *tlb)
 		__flush_tlb_pending(tlbbatch);
 
 	put_cpu_var(ppc64_tlb_batch);
-
-	/* Push out batch of freed page tables */
-	pte_free_finish(tlb);
 }
 
 /**
Index: linux-2.6/arch/powerpc/mm/tlb_nohash.c
===================================================================
--- linux-2.6.orig/arch/powerpc/mm/tlb_nohash.c
+++ linux-2.6/arch/powerpc/mm/tlb_nohash.c
@@ -296,9 +296,6 @@ EXPORT_SYMBOL(flush_tlb_range);
 void tlb_flush(struct mmu_gather *tlb)
 {
 	flush_tlb_mm(tlb->mm);
-
-	/* Push out batch of freed page tables */
-	pte_free_finish(tlb);
 }
 
 /*
Index: linux-2.6/include/asm-generic/tlb.h
===================================================================
--- linux-2.6.orig/include/asm-generic/tlb.h
+++ linux-2.6/include/asm-generic/tlb.h
@@ -27,6 +27,49 @@
   #define tlb_fast_mode(tlb) 1
 #endif
 
+#ifdef HAVE_ARCH_RCU_TABLE_FREE
+/*
+ * Semi RCU freeing of the page directories.
+ *
+ * This is needed by some architectures to implement gup_fast().
+ *
+ * gup_fast() does a lockless page-table walk and therefore needs some
+ * synchronization with the freeing of the page directories. The chosen means
+ * to accomplish that is by disabling IRQs over the walk.
+ *
+ * Architectures that use IPIs to flush TLBs will then automagically DTRT,
+ * since we unlink the page, flush TLBs, free the page. Since the disabling of
+ * IRQs delays the copmletion of the TLB flush we can never observe an already
+ * freed page.
+ *
+ * Architectures that do not have this (PPC) need to delay the freeing by some
+ * other means, this is that means.
+ *
+ * What we do is batch the freed directory pages (tables) and RCU free them.
+ * The assumption that IRQ disabled also holds off RCU grace periods is valid
+ * for the current RCU implementations (if this ever were to change these
+ * gup_fast() implementation would need to use the RCU read lock).
+ *
+ * However, in order to batch these pages we need to allocate storage, this
+ * allocation is deep inside the MM code and can thus easily fail on memory
+ * pressure. To guarantee progress we fall back to single table freeing, see
+ * the implementation of tlb_remove_table_one().
+ *
+ */
+struct mmu_table_batch {
+	struct rcu_head		rcu;
+	unsigned int		nr;
+	void			*tables[0];
+};
+
+#define MAX_TABLE_BATCH		\
+	((PAGE_SIZE - sizeof(struct mmu_table_batch)) / sizeof(unsigned long))
+
+extern void tlb_table_flush(struct mmu_gather *tlb);
+extern void tlb_remove_table(struct mmu_gather *tlb, void *table);
+
+#endif
+
 /* struct mmu_gather is an opaque type used by the mm code for passing around
  * any data needed by arch specific code for tlb_remove_page.
  */
@@ -36,11 +79,12 @@ struct mmu_gather {
 	unsigned int		max;	/* nr < max */
 	unsigned int		need_flush;/* Really unmapped some ptes? */
 	unsigned int		fullmm; /* non-zero means full mm flush */
-#ifdef HAVE_ARCH_MMU_GATHER
-	struct arch_mmu_gather	arch;
-#endif
 	struct page		**pages;
 	struct page		*local[8];
+
+#ifdef HAVE_ARCH_RCU_TABLE_FREE
+	struct mmu_table_batch	*batch;
+#endif
 };
 
 static inline void __tlb_alloc_pages(struct mmu_gather *tlb)
@@ -72,8 +116,8 @@ tlb_gather_mmu(struct mmu_gather *tlb, s
 
 	tlb->fullmm = full_mm_flush;
 
-#ifdef HAVE_ARCH_MMU_GATHER
-	tlb->arch = ARCH_MMU_GATHER_INIT;
+#ifdef HAVE_ARCH_RCU_TABLE_FREE
+	tlb->batch = NULL;
 #endif
 }
 
@@ -84,6 +128,9 @@ tlb_flush_mmu(struct mmu_gather *tlb, un
 		return;
 	tlb->need_flush = 0;
 	tlb_flush(tlb);
+#ifdef HAVE_ARCH_RCU_TABLE_FREE
+	tlb_table_flush(tlb);
+#endif
 	if (!tlb_fast_mode(tlb)) {
 		free_pages_and_swap_cache(tlb->pages, tlb->nr);
 		tlb->nr = 0;
Index: linux-2.6/mm/memory.c
===================================================================
--- linux-2.6.orig/mm/memory.c
+++ linux-2.6/mm/memory.c
@@ -193,6 +193,87 @@ static void check_sync_rss_stat(struct t
 
 #endif
 
+#ifdef HAVE_ARCH_RCU_TABLE_FREE
+
+/*
+ * See the comment near struct mmu_table_batch.
+ */
+
+static void tlb_remove_table_smp_sync(void *arg)
+{
+	/* Simply deliver the interrupt */
+}
+
+static void tlb_remove_table_one(void *table)
+{
+	/*
+	 * This isn't an RCU grace period and hence the page-tables cannot be
+	 * assumed to be actually RCU-freed.
+	 *
+	 * It is however sufficient for gup_fast() implementations that rely on
+	 * IRQ disabling. See the comment near struct mmu_table_batch.
+	 *
+	 * [ Using synchronize_rcu() instead of this smp_call_function() would
+	 *   make it proper RCU, however that is also much slower ]
+	 */
+	smp_call_function(tlb_remove_table_smp_sync, NULL, 1);
+	__tlb_remove_table(table);
+}
+
+static void tlb_remove_table_rcu(struct rcu_head *head)
+{
+	struct mmu_table_batch *batch;
+	int i;
+
+	batch = container_of(head, struct mmu_table_batch, rcu);
+
+	for (i = 0; i < batch->nr; i++)
+		__tlb_remove_table(batch->tables[i]);
+
+	free_page((unsigned long)batch);
+}
+
+void tlb_table_flush(struct mmu_gather *tlb)
+{
+	struct mmu_table_batch **batch = &tlb->batch;
+
+	if (*batch) {
+		INIT_RCU_HEAD(&(*batch)->rcu);
+		call_rcu(&(*batch)->rcu, tlb_remove_table_rcu);
+		*batch = NULL;
+	}
+}
+
+void tlb_remove_table(struct mmu_gather *tlb, void *table)
+{
+	struct mmu_table_batch **batch = &tlb->batch;
+
+	tlb->need_flush = 1;
+
+	/*
+	 * When there's less that two users of this mm there cannot be a
+	 * concurrent gup_fast() lookup.
+	 */
+	if (atomic_read(&tlb->mm->mm_users) < 2) {
+		__tlb_remove_table(table);
+		return;
+	}
+
+	if (*batch == NULL) {
+		*batch = (struct mmu_table_batch *)__get_free_page(GFP_ATOMIC);
+		if (*batch == NULL) {
+			tlb_remove_table_one(table);
+			return;
+		}
+		(*batch)->nr = 0;
+	}
+	(*batch)->tables[(*batch)->nr++] = table;
+	if ((*batch)->nr == MAX_TABLE_BATCH)
+		tlb_table_flush(tlb);
+}
+
+#endif
+
 /*
  * If a p?d_bad entry is found while walking page tables, report
  * the error, before resetting entry to p?d_none.  Usually (but


