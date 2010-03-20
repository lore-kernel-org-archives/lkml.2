Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752792Ab0CTOZZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 10:25:25 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:37224 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752152Ab0CTOZW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 10:25:22 -0400
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Masami Hiramatsu <mhiramat@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@linux.vnet.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Date: Sat, 20 Mar 2010 19:55:15 +0530
Message-Id: <20100320142515.11427.73030.sendpatchset@localhost6.localdomain6>
In-Reply-To: <20100320142455.11427.76925.sendpatchset@localhost6.localdomain6>
References: <20100320142455.11427.76925.sendpatchset@localhost6.localdomain6>
Subject: [PATCH v1 2/10] Move replace_page() to mm/memory.c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move replace_page() to mm/memory.c

Move replace_page from mm/ksm.c to mm/memory.c.
User bkpt will use background page replacement approach to insert/delete
breakpoints. Background page replacement approach will be based on
replace_page.  Now replace_page() loses its static attribute.

Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Signed-off-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
---

 include/linux/mm.h |    2 ++
 mm/ksm.c           |   59 ----------------------------------------------------
 mm/memory.c        |   59 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 61 insertions(+), 59 deletions(-)


diff --git a/include/linux/mm.h b/include/linux/mm.h
index e70f21b..0f43355 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -854,6 +854,8 @@ void account_page_dirtied(struct page *page, struct address_space *mapping);
 int set_page_dirty(struct page *page);
 int set_page_dirty_lock(struct page *page);
 int clear_page_dirty_for_io(struct page *page);
+int replace_page(struct vm_area_struct *vma, struct page *page,
+		struct page *kpage, pte_t orig_pte);
 
 extern unsigned long move_page_tables(struct vm_area_struct *vma,
 		unsigned long old_addr, struct vm_area_struct *new_vma,
diff --git a/mm/ksm.c b/mm/ksm.c
index a93f1b7..fd123de 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -766,65 +766,6 @@ out:
 	return err;
 }
 
-/**
- * replace_page - replace page in vma by new ksm page
- * @vma:      vma that holds the pte pointing to page
- * @page:     the page we are replacing by kpage
- * @kpage:    the ksm page we replace page by
- * @orig_pte: the original value of the pte
- *
- * Returns 0 on success, -EFAULT on failure.
- */
-static int replace_page(struct vm_area_struct *vma, struct page *page,
-			struct page *kpage, pte_t orig_pte)
-{
-	struct mm_struct *mm = vma->vm_mm;
-	pgd_t *pgd;
-	pud_t *pud;
-	pmd_t *pmd;
-	pte_t *ptep;
-	spinlock_t *ptl;
-	unsigned long addr;
-	int err = -EFAULT;
-
-	addr = page_address_in_vma(page, vma);
-	if (addr == -EFAULT)
-		goto out;
-
-	pgd = pgd_offset(mm, addr);
-	if (!pgd_present(*pgd))
-		goto out;
-
-	pud = pud_offset(pgd, addr);
-	if (!pud_present(*pud))
-		goto out;
-
-	pmd = pmd_offset(pud, addr);
-	if (!pmd_present(*pmd))
-		goto out;
-
-	ptep = pte_offset_map_lock(mm, pmd, addr, &ptl);
-	if (!pte_same(*ptep, orig_pte)) {
-		pte_unmap_unlock(ptep, ptl);
-		goto out;
-	}
-
-	get_page(kpage);
-	page_add_anon_rmap(kpage, vma, addr);
-
-	flush_cache_page(vma, addr, pte_pfn(*ptep));
-	ptep_clear_flush(vma, addr, ptep);
-	set_pte_at_notify(mm, addr, ptep, mk_pte(kpage, vma->vm_page_prot));
-
-	page_remove_rmap(page);
-	put_page(page);
-
-	pte_unmap_unlock(ptep, ptl);
-	err = 0;
-out:
-	return err;
-}
-
 /*
  * try_to_merge_one_page - take two pages and merge them into one
  * @vma: the vma that holds the pte pointing to page
diff --git a/mm/memory.c b/mm/memory.c
index 5b7f200..8b3ca1b 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2572,6 +2572,65 @@ void unmap_mapping_range(struct address_space *mapping,
 }
 EXPORT_SYMBOL(unmap_mapping_range);
 
+/**
+ * replace_page - replace page in vma by new ksm page
+ * @vma:      vma that holds the pte pointing to page
+ * @page:     the page we are replacing by kpage
+ * @kpage:    the ksm page we replace page by
+ * @orig_pte: the original value of the pte
+ *
+ * Returns 0 on success, -EFAULT on failure.
+ */
+int replace_page(struct vm_area_struct *vma, struct page *page,
+			struct page *kpage, pte_t orig_pte)
+{
+	struct mm_struct *mm = vma->vm_mm;
+	pgd_t *pgd;
+	pud_t *pud;
+	pmd_t *pmd;
+	pte_t *ptep;
+	spinlock_t *ptl;
+	unsigned long addr;
+	int err = -EFAULT;
+
+	addr = page_address_in_vma(page, vma);
+	if (addr == -EFAULT)
+		goto out;
+
+	pgd = pgd_offset(mm, addr);
+	if (!pgd_present(*pgd))
+		goto out;
+
+	pud = pud_offset(pgd, addr);
+	if (!pud_present(*pud))
+		goto out;
+
+	pmd = pmd_offset(pud, addr);
+	if (!pmd_present(*pmd))
+		goto out;
+
+	ptep = pte_offset_map_lock(mm, pmd, addr, &ptl);
+	if (!pte_same(*ptep, orig_pte)) {
+		pte_unmap_unlock(ptep, ptl);
+		goto out;
+	}
+
+	get_page(kpage);
+	page_add_anon_rmap(kpage, vma, addr);
+
+	flush_cache_page(vma, addr, pte_pfn(*ptep));
+	ptep_clear_flush(vma, addr, ptep);
+	set_pte_at_notify(mm, addr, ptep, mk_pte(kpage, vma->vm_page_prot));
+
+	page_remove_rmap(page);
+	put_page(page);
+
+	pte_unmap_unlock(ptep, ptl);
+	err = 0;
+out:
+	return err;
+}
+
 int vmtruncate_range(struct inode *inode, loff_t offset, loff_t end)
 {
 	struct address_space *mapping = inode->i_mapping;
