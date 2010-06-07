Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932308Ab0FGLVW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 07:21:22 -0400
Received: from [18.85.46.34] ([18.85.46.34]:37755 "EHLO bombadil.infradead.org"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932251Ab0FGLUj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 07:20:39 -0400
Message-Id: <20100607111407.951670997@chello.nl>
User-Agent: quilt/0.48-1
Date: Mon, 07 Jun 2010 13:07:11 +0200
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
       Jeff Dike <jdike@addtoit.com>
Subject: [PATCH 17/28] um: Preemptible mmu_gather
References: <20100607110654.606530953@chello.nl>
Content-Disposition: inline; filename=mm-preempt-tlb-gather-um.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix up the um mmu_gather code to conform to the new API.

Cc: Jeff Dike <jdike@addtoit.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 arch/um/include/asm/tlb.h |   16 ++--------------
 1 file changed, 2 insertions(+), 14 deletions(-)

Index: linux-2.6/arch/um/include/asm/tlb.h
===================================================================
--- linux-2.6.orig/arch/um/include/asm/tlb.h
+++ linux-2.6/arch/um/include/asm/tlb.h
@@ -22,9 +22,6 @@ struct mmu_gather {
 	unsigned int		fullmm; /* non-zero means full mm flush */
 };
 
-/* Users of the generic TLB shootdown code must declare this storage space. */
-DECLARE_PER_CPU(struct mmu_gather, mmu_gathers);
-
 static inline void __tlb_remove_tlb_entry(struct mmu_gather *tlb, pte_t *ptep,
 					  unsigned long address)
 {
@@ -47,20 +44,13 @@ static inline void init_tlb_gather(struc
 	}
 }
 
-/* tlb_gather_mmu
- *	Return a pointer to an initialized struct mmu_gather.
- */
-static inline struct mmu_gather *
-tlb_gather_mmu(struct mm_struct *mm, unsigned int full_mm_flush)
+static inline void
+tlb_gather_mmu(struct mmu_gather *tlb, struct mm_struct *mm, unsigned int full_mm_flush)
 {
-	struct mmu_gather *tlb = &get_cpu_var(mmu_gathers);
-
 	tlb->mm = mm;
 	tlb->fullmm = full_mm_flush;
 
 	init_tlb_gather(tlb);
-
-	return tlb;
 }
 
 extern void flush_tlb_mm_range(struct mm_struct *mm, unsigned long start,
@@ -87,8 +77,6 @@ tlb_finish_mmu(struct mmu_gather *tlb, u
 
 	/* keep the page table cache within bounds */
 	check_pgt_cache();
-
-	put_cpu_var(mmu_gathers);
 }
 
 /* tlb_remove_page


