Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754657Ab1BQRQN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 12:16:13 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:47642 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757137Ab1BQRLE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 12:11:04 -0500
Message-Id: <20110217163234.756898524@chello.nl>
User-Agent: quilt/0.48-1
Date: Thu, 17 Feb 2011 17:23:28 +0100
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
        Chris Metcalf <cmetcalf@tilera.com>
Subject: [PATCH 01/17] tile: Fix __pte_free_tlb
References: <20110217162327.434629380@chello.nl>
Content-Disposition: inline; filename=tile-fix-pte_free_tlb.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tile's __pte_free_tlb() implementation makes assumptions about the
generic mmu_gather implementation, cure this ;-)

Acked-by: Chris Metcalf <cmetcalf@tilera.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 arch/tile/mm/pgtable.c |   15 ++-------------
 1 file changed, 2 insertions(+), 13 deletions(-)

Index: linux-2.6/arch/tile/mm/pgtable.c
===================================================================
--- linux-2.6.orig/arch/tile/mm/pgtable.c
+++ linux-2.6/arch/tile/mm/pgtable.c
@@ -252,19 +252,8 @@ void __pte_free_tlb(struct mmu_gather *t
 	int i;
 
 	pgtable_page_dtor(pte);
-	tlb->need_flush = 1;
-	if (tlb_fast_mode(tlb)) {
-		struct page *pte_pages[L2_USER_PGTABLE_PAGES];
-		for (i = 0; i < L2_USER_PGTABLE_PAGES; ++i)
-			pte_pages[i] = pte + i;
-		free_pages_and_swap_cache(pte_pages, L2_USER_PGTABLE_PAGES);
-		return;
-	}
-	for (i = 0; i < L2_USER_PGTABLE_PAGES; ++i) {
-		tlb->pages[tlb->nr++] = pte + i;
-		if (tlb->nr >= FREE_PTE_NR)
-			tlb_flush_mmu(tlb, 0, 0);
-	}
+	for (i = 0; i < L2_USER_PGTABLE_PAGES; ++i)
+		tlb_remove_page(tlb, pte + i);
 }
 
 #ifndef __tilegx__


