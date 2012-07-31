Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756191Ab2GaTqs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 15:46:48 -0400
Received: from casper.infradead.org ([85.118.1.10]:58939 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754012Ab2GaToo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 15:44:44 -0400
Message-Id: <20120731192808.950441936@chello.nl>
User-Agent: quilt/0.48-1
Date: Tue, 31 Jul 2012 21:12:14 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mingo@kernel.org, riel@redhat.com, oleg@redhat.com, pjt@google.com,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        tglx@linutronix.de, Lee.Schermerhorn@hp.com
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 10/19] mm, mpol: Use special PROT_NONE to migrate pages
References: <20120731191204.540691987@chello.nl>
Content-Disposition: inline; filename=numa-prot-none-migrate.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Combine our previous PROT_NONE, mpol_misplaced and
migrate_misplaced_page() pieces into an effective migrate on fault
scheme.

Suggested-by: Rik van Riel <riel@redhat.com>
Cc: Paul Turner <pjt@google.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 mm/huge_memory.c |   41 ++++++++++++++++++++++++++++++++++++++++-
 mm/memory.c      |   42 ++++++++++++++++++++++++++++++++++++------
 2 files changed, 76 insertions(+), 7 deletions(-)
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -17,6 +17,7 @@
 #include <linux/khugepaged.h>
 #include <linux/freezer.h>
 #include <linux/mman.h>
+#include <linux/migrate.h>
 #include <asm/tlb.h>
 #include <asm/pgalloc.h>
 #include "internal.h"
@@ -755,12 +756,48 @@ void do_huge_pmd_prot_none(struct mm_str
 			   unsigned int flags, pmd_t entry)
 {
 	unsigned long haddr = address & HPAGE_PMD_MASK;
+	struct page *page = NULL;
+	int node;
 
 	spin_lock(&mm->page_table_lock);
 	if (unlikely(!pmd_same(*pmd, entry)))
 		goto out_unlock;
 
-	/* do fancy stuff */
+	if (unlikely(pmd_trans_splitting(entry))) {
+		spin_unlock(&mm->page_table_lock);
+		wait_split_huge_page(vma->anon_vma, pmd);
+		return;
+	}
+
+#ifdef CONFIG_NUMA
+	page = pmd_page(entry);
+	VM_BUG_ON(!PageCompound(page) || !PageHead(page));
+
+	get_page(page);
+	spin_unlock(&mm->page_table_lock);
+
+	/*
+	 * XXX should we serialize against split_huge_page ?
+	 */
+
+	node = mpol_misplaced(page, vma, haddr);
+	if (node == -1)
+		goto do_fixup;
+
+	/*
+	 * Due to lacking code to migrate thp pages, we'll split
+	 * (which preserves the special PROT_NONE) and re-take the
+	 * fault on the normal pages.
+	 */
+	split_huge_page(page);
+	put_page(page);
+	return;
+
+do_fixup:
+	spin_lock(&mm->page_table_lock);
+	if (unlikely(!pmd_same(*pmd, entry)))
+		goto out_unlock;
+#endif
 
 	/* change back to regular protection */
 	entry = pmd_modify(entry, vma->vm_page_prot);
@@ -769,6 +806,8 @@ void do_huge_pmd_prot_none(struct mm_str
 
 out_unlock:
 	spin_unlock(&mm->page_table_lock);
+	if (page)
+		put_page(page);
 }
 
 int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -57,6 +57,7 @@
 #include <linux/swapops.h>
 #include <linux/elf.h>
 #include <linux/gfp.h>
+#include <linux/migrate.h>
 
 #include <asm/io.h>
 #include <asm/pgalloc.h>
@@ -3449,17 +3450,42 @@ static int do_prot_none(struct mm_struct
 			unsigned long address, pte_t *ptep, pmd_t *pmd,
 			unsigned int flags, pte_t entry)
 {
+	struct page *page = NULL;
 	spinlock_t *ptl;
-	int ret = 0;
+	int node;
 
-	if (!pte_unmap_same(mm, pmd, ptep, entry))
-		goto out;
+	ptl = pte_lockptr(mm, pmd);
+	spin_lock(ptl);
+	if (unlikely(!pte_same(*ptep, entry)))
+		goto unlock;
 
+#ifdef CONFIG_NUMA
 	/*
-	 * Do fancy stuff...
+	 * For NUMA systems we use the special PROT_NONE maps to drive
+	 * lazy page migration, see MPOL_MF_LAZY and related.
 	 */
+	page = vm_normal_page(vma, address, entry);
+	if (!page)
+		goto do_fixup_locked;
+
+	get_page(page);
+	pte_unmap_unlock(ptep, ptl);
+
+	node = mpol_misplaced(page, vma, address);
+	if (node == -1)
+		goto do_fixup;
 
 	/*
+	 * Page migration will install a new pte with vma->vm_page_prot,
+	 * otherwise fall-through to the fixup. Next time,.. perhaps.
+	 */
+	if (!migrate_misplaced_page(mm, page, node)) {
+		put_page(page);
+		return 0;
+	}
+
+do_fixup:
+	/*
 	 * OK, nothing to do,.. change the protection back to what it
 	 * ought to be.
 	 */
@@ -3467,6 +3493,9 @@ static int do_prot_none(struct mm_struct
 	if (unlikely(!pte_same(*ptep, entry)))
 		goto unlock;
 
+do_fixup_locked:
+#endif /* CONFIG_NUMA */
+
 	flush_cache_page(vma, address, pte_pfn(entry));
 
 	ptep_modify_prot_start(mm, address, ptep);
@@ -3476,8 +3505,9 @@ static int do_prot_none(struct mm_struct
 	update_mmu_cache(vma, address, ptep);
 unlock:
 	pte_unmap_unlock(ptep, ptl);
-out:
-	return ret;
+	if (page)
+		put_page(page);
+	return 0;
 }
 
 /*


