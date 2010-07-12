Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754726Ab0GLKlD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 06:41:03 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:50680 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752351Ab0GLKk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 06:40:58 -0400
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Christoph Hellwig <hch@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>, Mark Wielaard <mjw@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Naren A Devaiah <naren.devaiah@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Mon, 12 Jul 2010 16:02:24 +0530
Message-Id: <20100712103224.27491.12056.sendpatchset@localhost6.localdomain6>
In-Reply-To: <20100712103214.27491.15142.sendpatchset@localhost6.localdomain6>
References: <20100712103214.27491.15142.sendpatchset@localhost6.localdomain6>
Subject: [PATCHv9 2.6.35-rc4-tip 1/13]  mm: Move replace_page() / write_protect_page() to mm/memory.c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


mm: Move replace_page() / write_protect_page() to mm/memory.c

User bkpt will use background page replacement approach to insert/delete
breakpoints. Background page replacement approach will be based on
replace_page and write_protect_page.
Now replace_page() loses its static attribute.

Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Signed-off-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
---

 include/linux/mm.h |    4 ++
 mm/ksm.c           |  112 -------------------------------------------------
 mm/memory.c        |  120 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 124 insertions(+), 112 deletions(-)


diff --git a/include/linux/mm.h b/include/linux/mm.h
index b969efb..206008e 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -858,6 +858,10 @@ void account_page_dirtied(struct page *page, struct address_space *mapping);
 int set_page_dirty(struct page *page);
 int set_page_dirty_lock(struct page *page);
 int clear_page_dirty_for_io(struct page *page);
+int replace_page(struct vm_area_struct *vma, struct page *page,
+					struct page *kpage, pte_t orig_pte);
+int write_protect_page(struct vm_area_struct *vma, struct page *page,
+						      pte_t *orig_pte);
 
 extern unsigned long move_page_tables(struct vm_area_struct *vma,
 		unsigned long old_addr, struct vm_area_struct *new_vma,
diff --git a/mm/ksm.c b/mm/ksm.c
index 6c3e99b..ce432e1 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -713,118 +713,6 @@ static inline int pages_identical(struct page *page1, struct page *page2)
 	return !memcmp_pages(page1, page2);
 }
 
-static int write_protect_page(struct vm_area_struct *vma, struct page *page,
-			      pte_t *orig_pte)
-{
-	struct mm_struct *mm = vma->vm_mm;
-	unsigned long addr;
-	pte_t *ptep;
-	spinlock_t *ptl;
-	int swapped;
-	int err = -EFAULT;
-
-	addr = page_address_in_vma(page, vma);
-	if (addr == -EFAULT)
-		goto out;
-
-	ptep = page_check_address(page, mm, addr, &ptl, 0);
-	if (!ptep)
-		goto out;
-
-	if (pte_write(*ptep)) {
-		pte_t entry;
-
-		swapped = PageSwapCache(page);
-		flush_cache_page(vma, addr, page_to_pfn(page));
-		/*
-		 * Ok this is tricky, when get_user_pages_fast() run it doesnt
-		 * take any lock, therefore the check that we are going to make
-		 * with the pagecount against the mapcount is racey and
-		 * O_DIRECT can happen right after the check.
-		 * So we clear the pte and flush the tlb before the check
-		 * this assure us that no O_DIRECT can happen after the check
-		 * or in the middle of the check.
-		 */
-		entry = ptep_clear_flush(vma, addr, ptep);
-		/*
-		 * Check that no O_DIRECT or similar I/O is in progress on the
-		 * page
-		 */
-		if (page_mapcount(page) + 1 + swapped != page_count(page)) {
-			set_pte_at(mm, addr, ptep, entry);
-			goto out_unlock;
-		}
-		entry = pte_wrprotect(entry);
-		set_pte_at_notify(mm, addr, ptep, entry);
-	}
-	*orig_pte = *ptep;
-	err = 0;
-
-out_unlock:
-	pte_unmap_unlock(ptep, ptl);
-out:
-	return err;
-}
-
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
index 119b7cc..3fb2b9d 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2582,6 +2582,126 @@ void unmap_mapping_range(struct address_space *mapping,
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
+/**
+ * write_protect_page - mark the page readonly
+ * @vma:      vma that holds the page we want to mark
+ * @page:     page that needs to be marked readonly
+ * @orig_pte: pte for the protected page.
+ *
+ * Returns 0 on success, -EFAULT on failure.
+ */
+int write_protect_page(struct vm_area_struct *vma, struct page *page,
+						      pte_t *orig_pte)
+{
+	struct mm_struct *mm = vma->vm_mm;
+	unsigned long addr;
+	pte_t *ptep;
+	spinlock_t *ptl;
+	int swapped;
+	int err = -EFAULT;
+
+	addr = page_address_in_vma(page, vma);
+	if (addr == -EFAULT)
+		goto out;
+
+	ptep = page_check_address(page, mm, addr, &ptl, 0);
+	if (!ptep)
+		goto out;
+
+	if (pte_write(*ptep)) {
+		pte_t entry;
+
+		swapped = PageSwapCache(page);
+		flush_cache_page(vma, addr, page_to_pfn(page));
+		/*
+		 * Ok this is tricky, when get_user_pages_fast() run it doesnt
+		 * take any lock, therefore the check that we are going to make
+		 * with the pagecount against the mapcount is racey and
+		 * O_DIRECT can happen right after the check.
+		 * So we clear the pte and flush the tlb before the check
+		 * this assure us that no O_DIRECT can happen after the check
+		 * or in the middle of the check.
+		 */
+		entry = ptep_clear_flush(vma, addr, ptep);
+		/*
+		 * Check that no O_DIRECT or similar I/O is in progress on the
+		 * page
+		 */
+		if (page_mapcount(page) + 1 + swapped != page_count(page)) {
+			set_pte_at(mm, addr, ptep, entry);
+			goto out_unlock;
+		}
+		entry = pte_wrprotect(entry);
+		set_pte_at_notify(mm, addr, ptep, entry);
+	}
+	*orig_pte = *ptep;
+	err = 0;
+
+out_unlock:
+	pte_unmap_unlock(ptep, ptl);
+out:
+	return err;
+}
+
 int vmtruncate_range(struct inode *inode, loff_t offset, loff_t end)
 {
 	struct address_space *mapping = inode->i_mapping;
