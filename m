Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030518Ab2K3PDH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 10:03:07 -0500
Received: from mga03.intel.com ([143.182.124.21]:10715 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758546Ab2K3PCm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 10:02:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,191,1355126400"; 
   d="scan'208";a="174451589"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>,
        David Rientjes <rientjes@google.com>, Bob Liu <lliubbo@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCH 2/2] thp: avoid race on multiple parallel page faults to the same page
Date: Fri, 30 Nov 2012 17:03:41 +0200
Message-Id: <1354287821-5925-3-git-send-email-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1354287821-5925-1-git-send-email-kirill.shutemov@linux.intel.com>
References: <50B52E17.8020205@suse.cz>
 <1354287821-5925-1-git-send-email-kirill.shutemov@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>

pmd value is stable only with mm->page_table_lock taken. After taking
the lock we need to check that nobody modified the pmd before change it.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 mm/huge_memory.c | 29 ++++++++++++++++++++++++-----
 1 file changed, 24 insertions(+), 5 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 9d6f521..51cb8fe 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -770,17 +770,20 @@ static inline struct page *alloc_hugepage(int defrag)
 }
 #endif
 
-static void set_huge_zero_page(pgtable_t pgtable, struct mm_struct *mm,
+static bool set_huge_zero_page(pgtable_t pgtable, struct mm_struct *mm,
 		struct vm_area_struct *vma, unsigned long haddr, pmd_t *pmd,
 		unsigned long zero_pfn)
 {
 	pmd_t entry;
+	if (!pmd_none(*pmd))
+		return false;
 	entry = pfn_pmd(zero_pfn, vma->vm_page_prot);
 	entry = pmd_wrprotect(entry);
 	entry = pmd_mkhuge(entry);
 	set_pmd_at(mm, haddr, pmd, entry);
 	pgtable_trans_huge_deposit(mm, pgtable);
 	mm->nr_ptes++;
+	return true;
 }
 
 int do_huge_pmd_anonymous_page(struct mm_struct *mm, struct vm_area_struct *vma,
@@ -800,6 +803,7 @@ int do_huge_pmd_anonymous_page(struct mm_struct *mm, struct vm_area_struct *vma,
 				transparent_hugepage_use_zero_page()) {
 			pgtable_t pgtable;
 			unsigned long zero_pfn;
+			bool set;
 			pgtable = pte_alloc_one(mm, haddr);
 			if (unlikely(!pgtable))
 				return VM_FAULT_OOM;
@@ -810,9 +814,13 @@ int do_huge_pmd_anonymous_page(struct mm_struct *mm, struct vm_area_struct *vma,
 				goto out;
 			}
 			spin_lock(&mm->page_table_lock);
-			set_huge_zero_page(pgtable, mm, vma, haddr, pmd,
+			set = set_huge_zero_page(pgtable, mm, vma, haddr, pmd,
 					zero_pfn);
 			spin_unlock(&mm->page_table_lock);
+			if (!set) {
+				pte_free(mm, pgtable);
+				put_huge_zero_page();
+			}
 			return 0;
 		}
 		page = alloc_hugepage_vma(transparent_hugepage_defrag(vma),
@@ -1046,14 +1054,16 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 	 */
 	if (is_huge_zero_pmd(pmd)) {
 		unsigned long zero_pfn;
+		bool set;
 		/*
 		 * get_huge_zero_page() will never allocate a new page here,
 		 * since we already have a zero page to copy. It just takes a
 		 * reference.
 		 */
 		zero_pfn = get_huge_zero_page();
-		set_huge_zero_page(pgtable, dst_mm, vma, addr, dst_pmd,
+		set = set_huge_zero_page(pgtable, dst_mm, vma, addr, dst_pmd,
 				zero_pfn);
+		BUG_ON(!set); /* unexpected !pmd_none(dst_pmd) */
 		ret = 0;
 		goto out_unlock;
 	}
@@ -1110,7 +1120,7 @@ unlock:
 
 static int do_huge_pmd_wp_zero_page_fallback(struct mm_struct *mm,
 		struct vm_area_struct *vma, unsigned long address,
-		pmd_t *pmd, unsigned long haddr)
+		pmd_t *pmd, pmd_t orig_pmd, unsigned long haddr)
 {
 	pgtable_t pgtable;
 	pmd_t _pmd;
@@ -1139,6 +1149,9 @@ static int do_huge_pmd_wp_zero_page_fallback(struct mm_struct *mm,
 	mmu_notifier_invalidate_range_start(mm, mmun_start, mmun_end);
 
 	spin_lock(&mm->page_table_lock);
+	if (unlikely(!pmd_same(*pmd, orig_pmd)))
+		goto out_free_page;
+
 	pmdp_clear_flush(vma, haddr, pmd);
 	/* leave pmd empty until pte is filled */
 
@@ -1171,6 +1184,12 @@ static int do_huge_pmd_wp_zero_page_fallback(struct mm_struct *mm,
 	ret |= VM_FAULT_WRITE;
 out:
 	return ret;
+out_free_page:
+	spin_unlock(&mm->page_table_lock);
+	mmu_notifier_invalidate_range_end(mm, mmun_start, mmun_end);
+	mem_cgroup_uncharge_page(page);
+	put_page(page);
+	goto out;
 }
 
 static int do_huge_pmd_wp_page_fallback(struct mm_struct *mm,
@@ -1317,7 +1336,7 @@ alloc:
 		count_vm_event(THP_FAULT_FALLBACK);
 		if (is_huge_zero_pmd(orig_pmd)) {
 			ret = do_huge_pmd_wp_zero_page_fallback(mm, vma,
-					address, pmd, haddr);
+					address, pmd, orig_pmd, haddr);
 		} else {
 			ret = do_huge_pmd_wp_page_fallback(mm, vma, address,
 					pmd, orig_pmd, page, haddr);
-- 
1.7.11.7

