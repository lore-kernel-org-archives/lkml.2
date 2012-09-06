Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754841Ab2IFNL0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 09:11:26 -0400
Received: from e06smtp15.uk.ibm.com ([195.75.94.111]:43748 "EHLO
	e06smtp15.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754484Ab2IFNLY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 09:11:24 -0400
From: Gerald Schaefer <gerald.schaefer@de.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andi Kleen <ak@linux.intel.com>, Hugh Dickins <hughd@google.com>,
        Hillf Danton <dhillf@gmail.com>
Cc: linux-kernel@vger.kernel.org, Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Gerald Schaefer <gerald.schaefer@de.ibm.com>
Subject: [PATCH 2/8] thp: remove assumptions on pgtable_t type
Date: Thu,  6 Sep 2012 15:10:37 +0200
Message-Id: <1346937043-28208-3-git-send-email-gerald.schaefer@de.ibm.com>
X-Mailer: git-send-email 1.7.11.5
In-Reply-To: <1346937043-28208-1-git-send-email-gerald.schaefer@de.ibm.com>
References: <1346937043-28208-1-git-send-email-gerald.schaefer@de.ibm.com>
x-cbid: 12090613-0342-0000-0000-000002C50F19
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
 include/asm-generic/pgtable.h |  8 ++++++++
 include/linux/huge_mm.h       |  1 -
 mm/huge_memory.c              | 46 ++++++-------------------------------------
 mm/pgtable-generic.c          | 39 ++++++++++++++++++++++++++++++++++++
 4 files changed, 53 insertions(+), 41 deletions(-)

diff --git a/include/asm-generic/pgtable.h b/include/asm-generic/pgtable.h
index ff4947b..548a12e 100644
--- a/include/asm-generic/pgtable.h
+++ b/include/asm-generic/pgtable.h
@@ -162,6 +162,14 @@ extern void pmdp_splitting_flush(struct vm_area_struct *vma,
 				 unsigned long address, pmd_t *pmdp);
 #endif
 
+#ifndef __HAVE_ARCH_PGTABLE_DEPOSIT
+extern void pgtable_trans_huge_deposit(struct mm_struct *mm, pgtable_t pgtable);
+#endif
+
+#ifndef __HAVE_ARCH_PGTABLE_WITHDRAW
+extern pgtable_t pgtable_trans_huge_withdraw(struct mm_struct *mm);
+#endif
+
 #ifndef __HAVE_ARCH_PTE_SAME
 static inline int pte_same(pte_t pte_a, pte_t pte_b)
 {
diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index 4c59b11..6ab47af 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -11,7 +11,6 @@ extern int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 extern int do_huge_pmd_wp_page(struct mm_struct *mm, struct vm_area_struct *vma,
 			       unsigned long address, pmd_t *pmd,
 			       pmd_t orig_pmd);
-extern pgtable_t get_pmd_huge_pte(struct mm_struct *mm);
 extern struct page *follow_trans_huge_pmd(struct mm_struct *mm,
 					  unsigned long addr,
 					  pmd_t *pmd,
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 57c4b93..5fce078 100644
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
@@ -665,7 +652,7 @@ static int __do_huge_pmd_anonymous_page(struct mm_struct *mm,
 		 */
 		page_add_new_anon_rmap(page, vma, haddr);
 		set_pmd_at(mm, haddr, pmd, entry);
-		prepare_pmd_huge_pte(pgtable, mm);
+		pgtable_trans_huge_deposit(mm, pgtable);
 		add_mm_counter(mm, MM_ANONPAGES, HPAGE_PMD_NR);
 		mm->nr_ptes++;
 		spin_unlock(&mm->page_table_lock);
@@ -791,7 +778,7 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 	pmdp_set_wrprotect(src_mm, addr, src_pmd);
 	pmd = pmd_mkold(pmd_wrprotect(pmd));
 	set_pmd_at(dst_mm, addr, dst_pmd, pmd);
-	prepare_pmd_huge_pte(pgtable, dst_mm);
+	pgtable_trans_huge_deposit(dst_mm, pgtable);
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
@@ -876,7 +844,7 @@ static int do_huge_pmd_wp_page_fallback(struct mm_struct *mm,
 	pmdp_clear_flush_notify(vma, haddr, pmd);
 	/* leave pmd empty until pte is filled */
 
-	pgtable = get_pmd_huge_pte(mm);
+	pgtable = pgtable_trans_huge_withdraw(mm);
 	pmd_populate(mm, &_pmd, pgtable);
 
 	for (i = 0; i < HPAGE_PMD_NR; i++, haddr += PAGE_SIZE) {
@@ -1041,7 +1009,7 @@ int zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 	if (__pmd_trans_huge_lock(pmd, vma) == 1) {
 		struct page *page;
 		pgtable_t pgtable;
-		pgtable = get_pmd_huge_pte(tlb->mm);
+		pgtable = pgtable_trans_huge_withdraw(tlb->mm);
 		page = pmd_page(*pmd);
 		pmd_clear(pmd);
 		tlb_remove_pmd_tlb_entry(tlb, pmd, addr);
@@ -1358,7 +1326,7 @@ static int __split_huge_page_map(struct page *page,
 	pmd = page_check_address_pmd(page, mm, address,
 				     PAGE_CHECK_ADDRESS_PMD_SPLITTING_FLAG);
 	if (pmd) {
-		pgtable = get_pmd_huge_pte(mm);
+		pgtable = pgtable_trans_huge_withdraw(mm);
 		pmd_populate(mm, &_pmd, pgtable);
 
 		for (i = 0, haddr = address; i < HPAGE_PMD_NR;
@@ -1971,8 +1939,6 @@ static void collapse_huge_page(struct mm_struct *mm,
 	pte_unmap(pte);
 	__SetPageUptodate(new_page);
 	pgtable = pmd_pgtable(_pmd);
-	VM_BUG_ON(page_count(pgtable) != 1);
-	VM_BUG_ON(page_mapcount(pgtable) != 0);
 
 	_pmd = mk_pmd(new_page, vma->vm_page_prot);
 	_pmd = maybe_pmd_mkwrite(pmd_mkdirty(_pmd), vma);
@@ -1990,7 +1956,7 @@ static void collapse_huge_page(struct mm_struct *mm,
 	page_add_new_anon_rmap(new_page, vma, address);
 	set_pmd_at(mm, address, pmd, _pmd);
 	update_mmu_cache(vma, address, _pmd);
-	prepare_pmd_huge_pte(pgtable, mm);
+	pgtable_trans_huge_deposit(mm, pgtable);
 	spin_unlock(&mm->page_table_lock);
 
 #ifndef CONFIG_NUMA
diff --git a/mm/pgtable-generic.c b/mm/pgtable-generic.c
index 74c0dda..29867e0 100644
--- a/mm/pgtable-generic.c
+++ b/mm/pgtable-generic.c
@@ -120,3 +120,42 @@ void pmdp_splitting_flush(struct vm_area_struct *vma, unsigned long address,
 }
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 #endif
+
+#ifndef __HAVE_ARCH_PGTABLE_DEPOSIT
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+void pgtable_trans_huge_deposit(struct mm_struct *mm, pgtable_t pgtable)
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
+pgtable_t pgtable_trans_huge_withdraw(struct mm_struct *mm)
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
-- 
1.7.11.5

