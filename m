Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756976Ab0FGLUx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 07:20:53 -0400
Received: from [18.85.46.34] ([18.85.46.34]:37756 "EHLO bombadil.infradead.org"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932253Ab0FGLUj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 07:20:39 -0400
Message-Id: <20100607111408.042749955@chello.nl>
User-Agent: quilt/0.48-1
Date: Mon, 07 Jun 2010 13:07:12 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrea Arcangeli <aarcange@redhat.com>, Avi Kivity <avi@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       David Miller <davem@davemloft.net>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, Mel Gorman <mel@csn.ul.ie>,
       Nick Piggin <npiggin@suse.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Tony Luck <tony.luck@intel.com>
Subject: [PATCH 18/28] ia64: Preemptible mmu_gather
References: <20100607110654.606530953@chello.nl>
Content-Disposition: inline; filename=mm-preempt-tlb-gather-ia64.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix up the ia64 mmu_gather code to conform to the new API.

Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 arch/ia64/include/asm/tlb.h |   38 +++++++++++++++++++++++++-------------
 1 file changed, 25 insertions(+), 13 deletions(-)

Index: linux-2.6/arch/ia64/include/asm/tlb.h
===================================================================
--- linux-2.6.orig/arch/ia64/include/asm/tlb.h
+++ linux-2.6/arch/ia64/include/asm/tlb.h
@@ -47,21 +47,21 @@
 #include <asm/machvec.h>
 
 #ifdef CONFIG_SMP
-# define FREE_PTE_NR		2048
 # define tlb_fast_mode(tlb)	((tlb)->nr == ~0U)
 #else
-# define FREE_PTE_NR		0
 # define tlb_fast_mode(tlb)	(1)
 #endif
 
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
+	struct page		*local[8];
 };
 
 struct ia64_tr_entry {
@@ -90,9 +90,6 @@ extern struct ia64_tr_entry *ia64_idtrs[
 #define RR_RID_MASK	0x00000000ffffff00L
 #define RR_TO_RID(val) 	((val >> 8) & 0xffffff)
 
-/* Users of the generic TLB shootdown code must declare this storage space. */
-DECLARE_PER_CPU(struct mmu_gather, mmu_gathers);
-
 /*
  * Flush the TLB for address range START to END and, if not in fast mode, release the
  * freed pages that where gathered up to this point.
@@ -147,15 +144,25 @@ ia64_tlb_flush_mmu (struct mmu_gather *t
 	}
 }
 
-/*
- * Return a pointer to an initialized struct mmu_gather.
- */
-static inline struct mmu_gather *
-tlb_gather_mmu (struct mm_struct *mm, unsigned int full_mm_flush)
+static inline void __tlb_alloc_pages(struct mmu_gather *tlb)
+{
+	unsigned long addr = __get_free_pages(GFP_ATOMIC, 0);
+
+	if (addr) {
+		tlb->pages = (void *)addr;
+		tlb->max = PAGE_SIZE / sizeof(void *);
+	}
+}
+
+
+static inline void
+tlb_gather_mmu (struct mmu_gather *tlb, struct mm_struct *mm, unsigned int full_mm_flush)
 {
 	struct mmu_gather *tlb = &get_cpu_var(mmu_gathers);
 
 	tlb->mm = mm;
+	tlb->max = ARRAY_SIZE(tlb->local);
+	tlb->pages = tlb->local;
 	/*
 	 * Use fast mode if only 1 CPU is online.
 	 *
@@ -191,7 +198,8 @@ tlb_finish_mmu (struct mmu_gather *tlb, 
 	/* keep the page table cache within bounds */
 	check_pgt_cache();
 
-	put_cpu_var(mmu_gathers);
+	if (tlb->pages != tlb->local)
+		free_pages((unsigned long)tlb->pages, 0);
 }
 
 /*
@@ -208,8 +216,12 @@ tlb_remove_page (struct mmu_gather *tlb,
 		free_page_and_swap_cache(page);
 		return;
 	}
+
+	if (!tlb->nr && tlb->pages == tlb->local)
+		__tlb_alloc_pages(tlb);
+
 	tlb->pages[tlb->nr++] = page;
-	if (tlb->nr >= FREE_PTE_NR)
+	if (tlb->nr >= tlb->max)
 		ia64_tlb_flush_mmu(tlb, tlb->start_addr, tlb->end_addr);
 }
 


