Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030608Ab2HWRVZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 13:21:25 -0400
Received: from e06smtp15.uk.ibm.com ([195.75.94.111]:40939 "EHLO
	e06smtp15.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758810Ab2HWRTC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 13:19:02 -0400
Message-Id: <20120823171854.367197379@de.ibm.com>
User-Agent: quilt/0.47-1
Date: Thu, 23 Aug 2012 19:17:34 +0200
From: Gerald Schaefer <gerald.schaefer@de.ibm.com>
To: akpm@linux-foundation.org, aarcange@redhat.com, linux-mm@kvack.org,
        ak@linux.intel.com, hughd@google.com
Cc: linux-kernel@vger.kernel.org, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, gerald.schaefer@de.ibm.com
Subject: [RFC patch 1/7] thp: remove assumptions on pgtable_t type
References: <20120823171733.595087166@de.ibm.com>
Content-Disposition: inline; filename=linux-3.5-thp-pgtable-prealloc.patch
x-cbid: 12082317-0342-0000-0000-000002A4E878
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The thp page table pre-allocation code currently assumes that pgtable_t
is of type "struct page *". This may not be true for all architectures,
so this patch removes that assumption by replacing the functions
prepare_pmd_huge_pte() and get_pmd_huge_pte() with two new functions
that can be defined architecture-specific.

It also removes two VM_BUG_ON checks for page_count() and page_mapcount()
operating on a pgtable_t. Apart from the VM_BUG_ON removal, there will
be no functional change introduced by this patch.

Signed-off-by: Gerald Schaefer <gerald.schaefer@de.ibm.com>
---
 include/asm-generic/pgtable.h |    6 +++++
 include/linux/huge_mm.h       |    1 
 mm/huge_memory.c              |   46 +++++-------------------------------------
 mm/pgtable-generic.c          |   39 +++++++++++++++++++++++++++++++++++
 4 files changed, 51 insertions(+), 41 deletions(-)

--- a/include/asm-generic/pgtable.h
+++ b/include/asm-generic/pgtable.h
@@ -443,6 +443,12 @@ static inline int pmd_write(pmd_t pmd)
 	return 0;
 }
 #endif /* __HAVE_ARCH_PMD_WRITE */
+#ifndef __HAVE_ARCH_PGTABLE_DEPOSIT
+extern void pgtable_deposit(struct mm_struct *mm, pgtable_t pgtable);
+#endif
+#ifndef __HAVE_ARCH_PGTABLE_WITHDRAW
+extern pgtable_t pgtable_withdraw(struct mm_struct *mm);
+#endif
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
 #ifndef pmd_read_atomic
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -11,7 +11,6 @@ extern int copy_huge_pmd(struct mm_struc
 extern int do_huge_pmd_wp_page(struct mm_struct *mm, struct vm_area_struct *vma,
 			       unsigned long address, pmd_t *pmd,
 			       pmd_t orig_pmd);
-extern pgtable_t get_pmd_huge_pte(struct mm_struct *mm);
 extern struct page *follow_trans_huge_pmd(struct mm_struct *mm,
 					  unsigned long addr,
 					  pmd_t *pmd,
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -611,19 +611,6 @@ out:
 }
 __setup("transparent_hugepage=", setup_transparent_hugepage);
 
-static void prepare_pmd_huge_pte(pgtable_t pgtable,
-				 struct mm_struct *mm)
-{
-	assert_spin_locked(&mm->page_table_lock);
-
-	/* FIFO */
-	if (!mm->pmd_huge_pte)
-		INIT_LIST_HEAD(&pgtable->lru);
-	else
-		list_add(&pgtable->lru, &mm->pmd_huge_pte->lru);
-	mm->pmd_huge_pte = pgtable;
-}
-
 static inline pmd_t maybe_pmd_mkwrite(pmd_t pmd, struct vm_area_struct *vma)
 {
 	if (likely(vma->vm_flags & VM_WRITE))
@@ -665,7 +652,7 @@ static int __do_huge_pmd_anonymous_page(
 		 */
 		page_add_new_anon_rmap(page, vma, haddr);
 		set_pmd_at(mm, haddr, pmd, entry);
-		prepare_pmd_huge_pte(pgtable, mm);
+		pgtable_deposit(mm, pgtable);
 		add_mm_counter(mm, MM_ANONPAGES, HPAGE_PMD_NR);
 		mm->nr_ptes++;
 		spin_unlock(&mm->page_table_lock);
@@ -791,7 +778,7 @@ int copy_huge_pmd(struct mm_struct *dst_
 	pmdp_set_wrprotect(src_mm, addr, src_pmd);
 	pmd = pmd_mkold(pmd_wrprotect(pmd));
 	set_pmd_at(dst_mm, addr, dst_pmd, pmd);
-	prepare_pmd_huge_pte(pgtable, dst_mm);
+	pgtable_deposit(dst_mm, pgtable);
 	dst_mm->nr_ptes++;
 
 	ret = 0;
@@ -802,25 +789,6 @@ out:
 	return ret;
 }
 
-/* no "address" argument so destroys page coloring of some arch */
-pgtable_t get_pmd_huge_pte(struct mm_struct *mm)
-{
-	pgtable_t pgtable;
-
-	assert_spin_locked(&mm->page_table_lock);
-
-	/* FIFO */
-	pgtable = mm->pmd_huge_pte;
-	if (list_empty(&pgtable->lru))
-		mm->pmd_huge_pte = NULL;
-	else {
-		mm->pmd_huge_pte = list_entry(pgtable->lru.next,
-					      struct page, lru);
-		list_del(&pgtable->lru);
-	}
-	return pgtable;
-}
-
 static int do_huge_pmd_wp_page_fallback(struct mm_struct *mm,
 					struct vm_area_struct *vma,
 					unsigned long address,
@@ -876,7 +844,7 @@ static int do_huge_pmd_wp_page_fallback(
 	pmdp_clear_flush_notify(vma, haddr, pmd);
 	/* leave pmd empty until pte is filled */
 
-	pgtable = get_pmd_huge_pte(mm);
+	pgtable = pgtable_withdraw(mm);
 	pmd_populate(mm, &_pmd, pgtable);
 
 	for (i = 0; i < HPAGE_PMD_NR; i++, haddr += PAGE_SIZE) {
@@ -1041,7 +1009,7 @@ int zap_huge_pmd(struct mmu_gather *tlb,
 	if (__pmd_trans_huge_lock(pmd, vma) == 1) {
 		struct page *page;
 		pgtable_t pgtable;
-		pgtable = get_pmd_huge_pte(tlb->mm);
+		pgtable = pgtable_withdraw(tlb->mm);
 		page = pmd_page(*pmd);
 		pmd_clear(pmd);
 		tlb_remove_pmd_tlb_entry(tlb, pmd, addr);
@@ -1358,7 +1326,7 @@ static int __split_huge_page_map(struct
 	pmd = page_check_address_pmd(page, mm, address,
 				     PAGE_CHECK_ADDRESS_PMD_SPLITTING_FLAG);
 	if (pmd) {
-		pgtable = get_pmd_huge_pte(mm);
+		pgtable = pgtable_withdraw(mm);
 		pmd_populate(mm, &_pmd, pgtable);
 
 		for (i = 0, haddr = address; i < HPAGE_PMD_NR;
@@ -1971,8 +1939,6 @@ static void collapse_huge_page(struct mm
 	pte_unmap(pte);
 	__SetPageUptodate(new_page);
 	pgtable = pmd_pgtable(_pmd);
-	VM_BUG_ON(page_count(pgtable) != 1);
-	VM_BUG_ON(page_mapcount(pgtable) != 0);
 
 	_pmd = mk_pmd(new_page, vma->vm_page_prot);
 	_pmd = maybe_pmd_mkwrite(pmd_mkdirty(_pmd), vma);
@@ -1990,7 +1956,7 @@ static void collapse_huge_page(struct mm
 	page_add_new_anon_rmap(new_page, vma, address);
 	set_pmd_at(mm, address, pmd, _pmd);
 	update_mmu_cache(vma, address, _pmd);
-	prepare_pmd_huge_pte(pgtable, mm);
+	pgtable_deposit(mm, pgtable);
 	spin_unlock(&mm->page_table_lock);
 
 #ifndef CONFIG_NUMA
--- a/mm/pgtable-generic.c
+++ b/mm/pgtable-generic.c
@@ -120,3 +120,42 @@ void pmdp_splitting_flush(struct vm_area
 }
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 #endif
+
+#ifndef __HAVE_ARCH_PGTABLE_DEPOSIT
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+void pgtable_deposit(struct mm_struct *mm, pgtable_t pgtable)
+{
+	assert_spin_locked(&mm->page_table_lock);
+
+	/* FIFO */
+	if (!mm->pmd_huge_pte)
+		INIT_LIST_HEAD(&pgtable->lru);
+	else
+		list_add(&pgtable->lru, &mm->pmd_huge_pte->lru);
+	mm->pmd_huge_pte = pgtable;
+}
+#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
+#endif
+
+#ifndef __HAVE_ARCH_PGTABLE_WITHDRAW
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+/* no "address" argument so destroys page coloring of some arch */
+pgtable_t pgtable_withdraw(struct mm_struct *mm)
+{
+	pgtable_t pgtable;
+
+	assert_spin_locked(&mm->page_table_lock);
+
+	/* FIFO */
+	pgtable = mm->pmd_huge_pte;
+	if (list_empty(&pgtable->lru))
+		mm->pmd_huge_pte = NULL;
+	else {
+		mm->pmd_huge_pte = list_entry(pgtable->lru.next,
+					      struct page, lru);
+		list_del(&pgtable->lru);
+	}
+	return pgtable;
+}
+#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
+#endif

