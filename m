Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755923Ab0KZPIk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 10:08:40 -0500
Received: from canuck.infradead.org ([134.117.69.58]:50061 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754921Ab0KZPBb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 10:01:31 -0500
Message-Id: <20101126145411.051511519@chello.nl>
User-Agent: quilt/0.47-1
Date: Fri, 26 Nov 2010 15:38:57 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrea Arcangeli <aarcange@redhat.com>, Avi Kivity <avi@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-mm@kvack.org, Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        David Miller <davem@davemloft.net>,
        Hugh Dickins <hugh.dickins@tiscali.co.uk>, Mel Gorman <mel@csn.ul.ie>,
        Nick Piggin <npiggin@kernel.dk>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Yanmin Zhang <yanmin_zhang@linux.intel.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, Jeff Dike <jdike@addtoit.com>
Subject: [PATCH 14/21] um: Preemptible mmu_gather
References: <20101126143843.801484792@chello.nl>
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


