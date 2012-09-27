Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755344Ab2I0GBC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 02:01:02 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54607 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754874Ab2I0GBA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 02:01:00 -0400
Date: Wed, 26 Sep 2012 23:00:43 -0700
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-eyi25t4eh3l4cd2zp4k3bj6c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl, pjt@google.com,
        riel@redhat.com, akpm@linux-foundation.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org, pjt@google.com,
        riel@redhat.com, akpm@linux-foundation.org, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/numa] mm/thp: Preserve pgprot across huge page split
Git-Commit-ID: 93c9d633bd9e183f105bc59d798d61c216a514f0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 26 Sep 2012 23:00:49 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  93c9d633bd9e183f105bc59d798d61c216a514f0
Gitweb:     http://git.kernel.org/tip/93c9d633bd9e183f105bc59d798d61c216a514f0
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Tue, 17 Jul 2012 18:25:14 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 26 Sep 2012 11:48:31 +0200

mm/thp: Preserve pgprot across huge page split

If we marked a THP with our special PROT_NONE protections, ensure we
don't loose them over a split.

Collapse seems to always allocate a new (huge) page which should
already end up on the new target node so loosing protections there
isn't a problem.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: Paul Turner <pjt@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/n/tip-eyi25t4eh3l4cd2zp4k3bj6c@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/include/asm/pgtable.h |    1 +
 mm/huge_memory.c               |  104 +++++++++++++++++++---------------------
 2 files changed, 50 insertions(+), 55 deletions(-)

diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index 49afb3f..402704f 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -350,6 +350,7 @@ static inline pgprot_t pgprot_modify(pgprot_t oldprot, pgprot_t newprot)
 }
 
 #define pte_pgprot(x) __pgprot(pte_flags(x) & PTE_FLAGS_MASK)
+#define pmd_pgprot(x) __pgprot(pmd_val(x) & ~_HPAGE_CHG_MASK)
 
 #define canon_pgprot(p) __pgprot(massage_pgprot(p))
 
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 57c4b93..4a74e34 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1353,64 +1353,60 @@ static int __split_huge_page_map(struct page *page,
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
