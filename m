Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756894Ab1CBR4w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 12:56:52 -0500
Received: from casper.infradead.org ([85.118.1.10]:33264 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755869Ab1CBRyq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 12:54:46 -0500
Message-Id: <20110302175200.883953013@chello.nl>
User-Agent: quilt/0.48-1
Date: Wed, 02 Mar 2011 18:50:13 +0100
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
        Guan Xuetao <gxt@mprc.pku.edu.cn>
Subject: [PATCH 09/13] unicore: mmu_gather rework
References: <20110302175004.222724818@chello.nl>
Content-Disposition: inline; filename=peter_zijlstra-unicore-mmu_gather.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix up the unicore mmu_gather code to conform to the new API.

Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 arch/unicore32/include/asm/tlb.h |   32 ++++++++++++++++++++------------
 1 file changed, 20 insertions(+), 12 deletions(-)

Index: linux-2.6/arch/unicore32/include/asm/tlb.h
===================================================================
--- linux-2.6.orig/arch/unicore32/include/asm/tlb.h
+++ linux-2.6/arch/unicore32/include/asm/tlb.h
@@ -27,17 +27,11 @@ struct mmu_gather {
 	unsigned long		range_end;
 };
 
-DECLARE_PER_CPU(struct mmu_gather, mmu_gathers);
-
-static inline struct mmu_gather *
-tlb_gather_mmu(struct mm_struct *mm, unsigned int full_mm_flush)
+static inline void
+tlb_gather_mmu(struct mmu_gather *tlb, struct mm_struct *mm, unsigned int fullmm)
 {
-	struct mmu_gather *tlb = &get_cpu_var(mmu_gathers);
-
 	tlb->mm = mm;
-	tlb->fullmm = full_mm_flush;
-
-	return tlb;
+	tlb->fullmm = fullmm;
 }
 
 static inline void
@@ -48,8 +42,6 @@ tlb_finish_mmu(struct mmu_gather *tlb, u
 
 	/* keep the page table cache within bounds */
 	check_pgt_cache();
-
-	put_cpu_var(mmu_gathers);
 }
 
 /*
@@ -88,7 +80,23 @@ tlb_end_vma(struct mmu_gather *tlb, stru
 		flush_tlb_range(vma, tlb->range_start, tlb->range_end);
 }
 
-#define tlb_remove_page(tlb, page)	free_page_and_swap_cache(page)
+static inline void tlb_flush_mmu(struct mmu_gather *tlb)
+{
+}
+
+static inline int __tlb_remove_page(struct mmu_gather *tlb, struct page *page)
+{
+	free_page_and_swap_cache(page);
+	return 0;
+}
+
+static inline void tlb_remove_page(struct mmu_gather *tlb, struct page *page)
+{
+	if (__tlb_remove_page(tlb, page))
+		tlb_flush_mmu(tlb);
+}
+
+
 #define pte_free_tlb(tlb, ptep, addr)	pte_free((tlb)->mm, ptep)
 #define pmd_free_tlb(tlb, pmdp, addr)	pmd_free((tlb)->mm, pmdp)
 #define pud_free_tlb(tlb, x, addr)      do { } while (0)


