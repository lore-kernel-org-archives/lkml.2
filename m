Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755755Ab2GaTpA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 15:45:00 -0400
Received: from merlin.infradead.org ([205.233.59.134]:37340 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753492Ab2GaTon (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 15:44:43 -0400
Message-Id: <20120731192808.585844380@chello.nl>
User-Agent: quilt/0.48-1
Date: Tue, 31 Jul 2012 21:12:08 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mingo@kernel.org, riel@redhat.com, oleg@redhat.com, pjt@google.com,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        tglx@linutronix.de, Lee.Schermerhorn@hp.com
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 04/19] mm, thp: Preserve pgprot across huge page split
References: <20120731191204.540691987@chello.nl>
Content-Disposition: inline; filename=thp-preserve-prot.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we marked a THP with our special PROT_NONE protections, ensure we
don't loose them over a split.

Collapse seems to always allocate a new (huge) page which should
already end up on the new target node so loosing protections there
isn't a problem.

Cc: Rik van Riel <riel@redhat.com>
Cc: Paul Turner <pjt@google.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 arch/x86/include/asm/pgtable.h |    1 
 mm/huge_memory.c               |  104 +++++++++++++++++++----------------------
 2 files changed, 50 insertions(+), 55 deletions(-)
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -350,6 +350,7 @@ static inline pgprot_t pgprot_modify(pgp
 }
 
 #define pte_pgprot(x) __pgprot(pte_flags(x) & PTE_FLAGS_MASK)
+#define pmd_pgprot(x) __pgprot(pmd_val(x) & ~_HPAGE_CHG_MASK)
 
 #define canon_pgprot(p) __pgprot(massage_pgprot(p))
 
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1353,64 +1353,60 @@ static int __split_huge_page_map(struct 
 	int ret = 0, i;
 	pgtable_t pgtable;
 	unsigned long haddr;
+	pgprot_t prot;
 
 	spin_lock(&mm->page_table_lock);
 	pmd = page_check_address_pmd(page, mm, address,
 				     PAGE_CHECK_ADDRESS_PMD_SPLITTING_FLAG);
-	if (pmd) {
-		pgtable = get_pmd_huge_pte(mm);
-		pmd_populate(mm, &_pmd, pgtable);
-
-		for (i = 0, haddr = address; i < HPAGE_PMD_NR;
-		     i++, haddr += PAGE_SIZE) {
-			pte_t *pte, entry;
-			BUG_ON(PageCompound(page+i));
-			entry = mk_pte(page + i, vma->vm_page_prot);
-			entry = maybe_mkwrite(pte_mkdirty(entry), vma);
-			if (!pmd_write(*pmd))
-				entry = pte_wrprotect(entry);
-			else
-				BUG_ON(page_mapcount(page) != 1);
-			if (!pmd_young(*pmd))
-				entry = pte_mkold(entry);
-			pte = pte_offset_map(&_pmd, haddr);
-			BUG_ON(!pte_none(*pte));
-			set_pte_at(mm, haddr, pte, entry);
-			pte_unmap(pte);
-		}
+	if (!pmd)
+		goto unlock;
 
-		smp_wmb(); /* make pte visible before pmd */
-		/*
-		 * Up to this point the pmd is present and huge and
-		 * userland has the whole access to the hugepage
-		 * during the split (which happens in place). If we
-		 * overwrite the pmd with the not-huge version
-		 * pointing to the pte here (which of course we could
-		 * if all CPUs were bug free), userland could trigger
-		 * a small page size TLB miss on the small sized TLB
-		 * while the hugepage TLB entry is still established
-		 * in the huge TLB. Some CPU doesn't like that. See
-		 * http://support.amd.com/us/Processor_TechDocs/41322.pdf,
-		 * Erratum 383 on page 93. Intel should be safe but is
-		 * also warns that it's only safe if the permission
-		 * and cache attributes of the two entries loaded in
-		 * the two TLB is identical (which should be the case
-		 * here). But it is generally safer to never allow
-		 * small and huge TLB entries for the same virtual
-		 * address to be loaded simultaneously. So instead of
-		 * doing "pmd_populate(); flush_tlb_range();" we first
-		 * mark the current pmd notpresent (atomically because
-		 * here the pmd_trans_huge and pmd_trans_splitting
-		 * must remain set at all times on the pmd until the
-		 * split is complete for this pmd), then we flush the
-		 * SMP TLB and finally we write the non-huge version
-		 * of the pmd entry with pmd_populate.
-		 */
-		set_pmd_at(mm, address, pmd, pmd_mknotpresent(*pmd));
-		flush_tlb_range(vma, address, address + HPAGE_PMD_SIZE);
-		pmd_populate(mm, pmd, pgtable);
-		ret = 1;
+	prot = pmd_pgprot(*pmd);
+	pgtable = get_pmd_huge_pte(mm);
+	pmd_populate(mm, &_pmd, pgtable);
+
+	for (i = 0, haddr = address; i < HPAGE_PMD_NR; i++, haddr += PAGE_SIZE) {
+		pte_t *pte, entry;
+
+		BUG_ON(PageCompound(page+i));
+		entry = mk_pte(page + i, prot);
+		entry = pte_mkdirty(entry);
+		if (!pmd_young(*pmd))
+			entry = pte_mkold(entry);
+		pte = pte_offset_map(&_pmd, haddr);
+		BUG_ON(!pte_none(*pte));
+		set_pte_at(mm, haddr, pte, entry);
+		pte_unmap(pte);
 	}
+
+	smp_wmb(); /* make ptes visible before pmd, see __pte_alloc */
+	/*
+	 * Up to this point the pmd is present and huge.
+	 *
+	 * If we overwrite the pmd with the not-huge version, we could trigger
+	 * a small page size TLB miss on the small sized TLB while the hugepage
+	 * TLB entry is still established in the huge TLB.
+	 *
+	 * Some CPUs don't like that. See
+	 * http://support.amd.com/us/Processor_TechDocs/41322.pdf, Erratum 383
+	 * on page 93.
+	 *
+	 * Thus it is generally safer to never allow small and huge TLB entries
+	 * for overlapping virtual addresses to be loaded. So we first mark the
+	 * current pmd not present, then we flush the TLB and finally we write
+	 * the non-huge version of the pmd entry with pmd_populate.
+	 *
+	 * The above needs to be done under the ptl because pmd_trans_huge and
+	 * pmd_trans_splitting must remain set on the pmd until the split is
+	 * complete. The ptl also protects against concurrent faults due to
+	 * making the pmd not-present.
+	 */
+	set_pmd_at(mm, address, pmd, pmd_mknotpresent(*pmd));
+	flush_tlb_range(vma, address, address + HPAGE_PMD_SIZE);
+	pmd_populate(mm, pmd, pgtable);
+	ret = 1;
+
+unlock:
 	spin_unlock(&mm->page_table_lock);
 
 	return ret;
@@ -2241,9 +2237,7 @@ static int khugepaged_wait_event(void)
 static void khugepaged_do_scan(struct page **hpage)
 {
 	unsigned int progress = 0, pass_through_head = 0;
-	unsigned int pages = khugepaged_pages_to_scan;
-
-	barrier(); /* write khugepaged_pages_to_scan to local stack */
+	unsigned int pages = ACCESS_ONCE(khugepaged_pages_to_scan);
 
 	while (progress < pages) {
 		cond_resched();


