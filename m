Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757261Ab2JDTry (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 15:47:54 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:45290 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757197Ab2JDTru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 15:47:50 -0400
Date: Thu, 04 Oct 2012 15:47:47 -0400 (EDT)
Message-Id: <20121004.154747.650416442352280556.davem@davemloft.net>
To: linux-mm@kvack.org
CC: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, akpm@linux-foundation.org,
        aarcange@redhat.com, hannes@cmpxchg.org
Subject: [PATCH v2 6/7] mm: thp: Use more portable PMD clearing sequenece
 in zap_huge_pmd().
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Invalidation sequences are handled in various ways on various
architectures.

One way, which sparc64 uses, is to let the set_*_at() functions
accumulate pending flushes into a per-cpu array.  Then the
flush_tlb_range() et al. calls process the pending TLB flushes.

In this regime, the __tlb_remove_*tlb_entry() implementations are
essentially NOPs.

The canonical PTE zap in mm/memory.c is:

			ptent = ptep_get_and_clear_full(mm, addr, pte,
							tlb->fullmm);
			tlb_remove_tlb_entry(tlb, pte, addr);

With a subsequent tlb_flush_mmu() if needed.

Mirror this in the THP PMD zapping using:

		orig_pmd = pmdp_get_and_clear(tlb->mm, addr, pmd);
		page = pmd_page(orig_pmd);
		tlb_remove_pmd_tlb_entry(tlb, pmd, addr);

And we properly accomodate TLB flush mechanims like the one described
above.

Signed-off-by: David S. Miller <davem@davemloft.net>
---
 mm/huge_memory.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 20eeb2b..2fa0c59 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -996,9 +996,10 @@ int zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 	if (__pmd_trans_huge_lock(pmd, vma) == 1) {
 		struct page *page;
 		pgtable_t pgtable;
+		pmd_t orig_pmd;
 		pgtable = pgtable_trans_huge_withdraw(tlb->mm);
-		page = pmd_page(*pmd);
-		pmd_clear(pmd);
+		orig_pmd = pmdp_get_and_clear(tlb->mm, addr, pmd);
+		page = pmd_page(orig_pmd);
 		tlb_remove_pmd_tlb_entry(tlb, pmd, addr);
 		page_remove_rmap(page);
 		VM_BUG_ON(page_mapcount(page) < 0);
-- 
1.7.10.4

