Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932346Ab1BQRPL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 12:15:11 -0500
Received: from casper.infradead.org ([85.118.1.10]:36111 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757145Ab1BQRLF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 12:11:05 -0500
Message-Id: <20110217163235.106239192@chello.nl>
User-Agent: quilt/0.48-1
Date: Thu, 17 Feb 2011 17:23:33 +0100
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
        Russell King <rmk@arm.linux.org.uk>
Subject: [PATCH 06/17] arm: mmu_gather rework
References: <20110217162327.434629380@chello.nl>
Content-Disposition: inline; filename=peter_zijlstra-arm-preemptible_mmu_gather.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix up the arm mmu_gather code to conform to the new API.

Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 arch/arm/include/asm/tlb.h |   29 ++++++++++++++++++-----------
 1 file changed, 18 insertions(+), 11 deletions(-)

Index: linux-2.6/arch/arm/include/asm/tlb.h
===================================================================
--- linux-2.6.orig/arch/arm/include/asm/tlb.h
+++ linux-2.6/arch/arm/include/asm/tlb.h
@@ -40,17 +40,11 @@ struct mmu_gather {
 	unsigned long		range_end;
 };
 
-DECLARE_PER_CPU(struct mmu_gather, mmu_gathers);
-
-static inline struct mmu_gather *
-tlb_gather_mmu(struct mm_struct *mm, unsigned int full_mm_flush)
+static inline void
+tlb_gather_mmu(struct mmu_gather *tlb, struct mm_struct *mm, unsigned int full_mm_flush)
 {
-	struct mmu_gather *tlb = &get_cpu_var(mmu_gathers);
-
 	tlb->mm = mm;
 	tlb->fullmm = full_mm_flush;
-
-	return tlb;
 }
 
 static inline void
@@ -61,8 +55,6 @@ tlb_finish_mmu(struct mmu_gather *tlb, u
 
 	/* keep the page table cache within bounds */
 	check_pgt_cache();
-
-	put_cpu_var(mmu_gathers);
 }
 
 /*
@@ -101,7 +93,22 @@ tlb_end_vma(struct mmu_gather *tlb, stru
 		flush_tlb_range(vma, tlb->range_start, tlb->range_end);
 }
 
-#define tlb_remove_page(tlb,page)	free_page_and_swap_cache(page)
+static inline int __tlb_remove_page(struct mmu_gather *tlb, struct page *page)
+{
+	free_page_and_swap_cache(page);
+	return 0;
+}
+
+static inline void tlb_remove_page(struct mmu_gather *tlb, struct page *page)
+{
+	might_sleep();
+	__tlb_remove_page(tlb, page);
+}
+
+static inline void tlb_flush_mmu(struct mmu_gather *tlb)
+{
+}
+
 #define pte_free_tlb(tlb, ptep, addr)	pte_free((tlb)->mm, ptep)
 #define pmd_free_tlb(tlb, pmdp, addr)	pmd_free((tlb)->mm, pmdp)
 


