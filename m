Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754178Ab2JBW1Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 18:27:25 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:51814 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753436Ab2JBW1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 18:27:20 -0400
Date: Tue, 02 Oct 2012 18:27:18 -0400 (EDT)
Message-Id: <20121002.182718.250164928532772411.davem@davemloft.net>
To: linux-mm@kvack.org
CC: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, akpm@linux-foundation.org,
        aarcange@redhat.com, hannes@cmpxchg.org
Subject: [PATCH 6/8] mm: Make transparent huge code not depend upon the
 details of pgtable_t
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The code currently assumes that pgtable_t is a struct page pointer.

Fix this by pushing pgtable management behind arch helper functions.

Signed-off-by: David S. Miller <davem@davemloft.net>
---
 arch/x86/include/asm/pgalloc.h |   26 ++++++++++++++++++++++++++
 mm/huge_memory.c               |   22 ++--------------------
 2 files changed, 28 insertions(+), 20 deletions(-)

diff --git a/arch/x86/include/asm/pgalloc.h b/arch/x86/include/asm/pgalloc.h
index b4389a4..f2a12e9 100644
--- a/arch/x86/include/asm/pgalloc.h
+++ b/arch/x86/include/asm/pgalloc.h
@@ -136,4 +136,30 @@ static inline void __pud_free_tlb(struct mmu_gather *tlb, pud_t *pud,
 #endif	/* PAGETABLE_LEVELS > 3 */
 #endif	/* PAGETABLE_LEVELS > 2 */
 
+static inline void pmd_huge_pte_insert(struct mm_struct *mm, pgtable_t pgtable)
+{
+	/* FIFO */
+	if (!mm->pmd_huge_pte)
+		INIT_LIST_HEAD(&pgtable->lru);
+	else
+		list_add(&pgtable->lru, &mm->pmd_huge_pte->lru);
+	mm->pmd_huge_pte = pgtable;
+}
+
+static inline pgtable_t pmd_huge_pte_remove(struct mm_struct *mm)
+{
+	pgtable_t pgtable;
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
+
 #endif /* _ASM_X86_PGALLOC_H */
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 29414c1..5d44785 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -616,12 +616,7 @@ static void prepare_pmd_huge_pte(pgtable_t pgtable,
 {
 	assert_spin_locked(&mm->page_table_lock);
 
-	/* FIFO */
-	if (!mm->pmd_huge_pte)
-		INIT_LIST_HEAD(&pgtable->lru);
-	else
-		list_add(&pgtable->lru, &mm->pmd_huge_pte->lru);
-	mm->pmd_huge_pte = pgtable;
+	pmd_huge_pte_insert(mm, pgtable);
 }
 
 static inline pmd_t maybe_pmd_mkwrite(pmd_t pmd, struct vm_area_struct *vma)
@@ -805,20 +800,9 @@ out:
 /* no "address" argument so destroys page coloring of some arch */
 pgtable_t get_pmd_huge_pte(struct mm_struct *mm)
 {
-	pgtable_t pgtable;
-
 	assert_spin_locked(&mm->page_table_lock);
 
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
+	return pmd_huge_pte_remove(mm);
 }
 
 static int do_huge_pmd_wp_page_fallback(struct mm_struct *mm,
@@ -1971,8 +1955,6 @@ static void collapse_huge_page(struct mm_struct *mm,
 	pte_unmap(pte);
 	__SetPageUptodate(new_page);
 	pgtable = pmd_pgtable(_pmd);
-	VM_BUG_ON(page_count(pgtable) != 1);
-	VM_BUG_ON(page_mapcount(pgtable) != 0);
 
 	_pmd = mk_pmd(new_page, vma->vm_page_prot);
 	_pmd = maybe_pmd_mkwrite(pmd_mkdirty(_pmd), vma);
-- 
1.7.10.4

