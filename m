Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754061Ab1AYVXc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 16:23:32 -0500
Received: from mga02.intel.com ([134.134.136.20]:10613 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753850Ab1AYVXb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 16:23:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,376,1291622400"; 
   d="scan'208";a="700564170"
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
From: Tony Luck <tony.luck@intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>, Avi Kivity <avi@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-mm@kvack.org, Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        David Miller <davem@davemloft.net>,
        Hugh Dickins <hugh.dickins@tiscali.co.uk>, Mel Gorman <mel@csn.ul.ie>,
        Nick Piggin <npiggin@kernel.dk>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Yanmin Zhang <yanmin_zhang@linux.intel.com>
In-Reply-To: <1295986943.28776.1108.camel@laptop>
Subject: Re: [PATCH 09/25] ia64: Preemptible mmu_gather
Date: Tue, 25 Jan 2011 13:23:30 -0800
Message-Id: <4d3f3f522012086c15@agluck-desktop.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Yeah, pretty much a random number small enough to make struct mmu_gather
> fit on stack, the reason its not 1 is that a few more entries increase
> performance a little and freeing more pages increases the chance the
> page allocation works next time around.

Okay ... then could you swap out your part 09/25 for this version that
has a #define and a comment.  You can add

Acked-by: Tony Luck <tony.luck@intel.com>

-Tony

---

diff --git a/arch/ia64/include/asm/tlb.h b/arch/ia64/include/asm/tlb.h
index 23cce99..ec4ca06 100644
--- a/arch/ia64/include/asm/tlb.h
+++ b/arch/ia64/include/asm/tlb.h
@@ -47,21 +47,27 @@
 #include <asm/machvec.h>
 
 #ifdef CONFIG_SMP
-# define FREE_PTE_NR		2048
 # define tlb_fast_mode(tlb)	((tlb)->nr == ~0U)
 #else
-# define FREE_PTE_NR		0
 # define tlb_fast_mode(tlb)	(1)
 #endif
 
+/*
+ * If we can't allocate a page to make a big batch of page pointers
+ * to work on, then just handle a few from the on-stack structure.
+ */
+#define	IA64_GATHER_BUNDLE	8
+
 struct mmu_gather {
 	struct mm_struct	*mm;
 	unsigned int		nr;		/* == ~0U => fast mode */
+	unsigned int		max;
 	unsigned char		fullmm;		/* non-zero means full mm flush */
 	unsigned char		need_flush;	/* really unmapped some PTEs? */
 	unsigned long		start_addr;
 	unsigned long		end_addr;
-	struct page 		*pages[FREE_PTE_NR];
+	struct page		**pages;
+	struct page		*local[IA64_GATHER_BUNDLE];
 };
 
 struct ia64_tr_entry {
@@ -90,9 +96,6 @@ extern struct ia64_tr_entry *ia64_idtrs[NR_CPUS];
 #define RR_RID_MASK	0x00000000ffffff00L
 #define RR_TO_RID(val) 	((val >> 8) & 0xffffff)
 
-/* Users of the generic TLB shootdown code must declare this storage space. */
-DECLARE_PER_CPU(struct mmu_gather, mmu_gathers);
-
 /*
  * Flush the TLB for address range START to END and, if not in fast mode, release the
  * freed pages that where gathered up to this point.
@@ -147,15 +150,23 @@ ia64_tlb_flush_mmu (struct mmu_gather *tlb, unsigned long start, unsigned long e
 	}
 }
 
-/*
- * Return a pointer to an initialized struct mmu_gather.
- */
-static inline struct mmu_gather *
-tlb_gather_mmu (struct mm_struct *mm, unsigned int full_mm_flush)
+static inline void __tlb_alloc_page(struct mmu_gather *tlb)
 {
-	struct mmu_gather *tlb = &get_cpu_var(mmu_gathers);
+	unsigned long addr = __get_free_pages(GFP_NOWAIT | __GFP_NOWARN, 0);
+
+	if (addr) {
+		tlb->pages = (void *)addr;
+		tlb->max = PAGE_SIZE / sizeof(void *);
+	}
+}
 
+
+static inline void
+tlb_gather_mmu(struct mmu_gather *tlb, struct mm_struct *mm, unsigned int full_mm_flush)
+{
 	tlb->mm = mm;
+	tlb->max = ARRAY_SIZE(tlb->local);
+	tlb->pages = tlb->local;
 	/*
 	 * Use fast mode if only 1 CPU is online.
 	 *
@@ -172,7 +183,6 @@ tlb_gather_mmu (struct mm_struct *mm, unsigned int full_mm_flush)
 	tlb->nr = (num_online_cpus() == 1) ? ~0U : 0;
 	tlb->fullmm = full_mm_flush;
 	tlb->start_addr = ~0UL;
-	return tlb;
 }
 
 /*
@@ -180,7 +190,7 @@ tlb_gather_mmu (struct mm_struct *mm, unsigned int full_mm_flush)
  * collected.
  */
 static inline void
-tlb_finish_mmu (struct mmu_gather *tlb, unsigned long start, unsigned long end)
+tlb_finish_mmu(struct mmu_gather *tlb, unsigned long start, unsigned long end)
 {
 	/*
 	 * Note: tlb->nr may be 0 at this point, so we can't rely on tlb->start_addr and
@@ -191,7 +201,8 @@ tlb_finish_mmu (struct mmu_gather *tlb, unsigned long start, unsigned long end)
 	/* keep the page table cache within bounds */
 	check_pgt_cache();
 
-	put_cpu_var(mmu_gathers);
+	if (tlb->pages != tlb->local)
+		free_pages((unsigned long)tlb->pages, 0);
 }
 
 /*
@@ -208,8 +219,12 @@ tlb_remove_page (struct mmu_gather *tlb, struct page *page)
 		free_page_and_swap_cache(page);
 		return;
 	}
+
+	if (!tlb->nr && tlb->pages == tlb->local)
+		__tlb_alloc_page(tlb);
+
 	tlb->pages[tlb->nr++] = page;
-	if (tlb->nr >= FREE_PTE_NR)
+	if (tlb->nr >= tlb->max)
 		ia64_tlb_flush_mmu(tlb, tlb->start_addr, tlb->end_addr);
 }
 
