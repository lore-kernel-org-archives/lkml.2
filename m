Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757790Ab0E1AeK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 20:34:10 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:58655 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755428Ab0E1AdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 20:33:00 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>, Mel Gorman <mel@csn.ul.ie>
Subject: [PATCH 6/8] HWPOISON, hugetlb: isolate corrupted hugepage
Date: Fri, 28 May 2010 09:29:20 +0900
Message-Id: <1275006562-18946-7-git-send-email-n-horiguchi@ah.jp.nec.com>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1275006562-18946-1-git-send-email-n-horiguchi@ah.jp.nec.com>
References: <1275006562-18946-1-git-send-email-n-horiguchi@ah.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If error hugepage is not in-use, we can fully recovery from error
by dequeuing it from freelist, so return RECOVERY.
Otherwise whether or not we can recovery depends on user processes,
so return DELAYED.

Dependency:
  "HWPOISON, hugetlb: enable error handling path for hugepage"

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>
---
 include/linux/hugetlb.h |    2 ++
 mm/hugetlb.c            |   16 ++++++++++++++++
 mm/memory-failure.c     |   28 ++++++++++++++++++++--------
 3 files changed, 38 insertions(+), 8 deletions(-)

diff --git v2.6.34/include/linux/hugetlb.h v2.6.34/include/linux/hugetlb.h
index e688fd8..f479700 100644
--- v2.6.34/include/linux/hugetlb.h
+++ v2.6.34/include/linux/hugetlb.h
@@ -43,6 +43,7 @@ int hugetlb_reserve_pages(struct inode *inode, long from, long to,
 						struct vm_area_struct *vma,
 						int acctflags);
 void hugetlb_unreserve_pages(struct inode *inode, long offset, long freed);
+void __isolate_hwpoisoned_huge_page(struct page *page);
 
 extern unsigned long hugepages_treat_as_movable;
 extern const unsigned long hugetlb_zero, hugetlb_infinity;
@@ -100,6 +101,7 @@ static inline void hugetlb_report_meminfo(struct seq_file *m)
 #define hugetlb_free_pgd_range(tlb, addr, end, floor, ceiling) ({BUG(); 0; })
 #define hugetlb_fault(mm, vma, addr, flags)	({ BUG(); 0; })
 #define huge_pte_offset(mm, address)	0
+#define __isolate_hwpoisoned_huge_page(page)	0
 
 #define hugetlb_change_protection(vma, address, end, newprot)
 
diff --git v2.6.34/mm/hugetlb.c v2.6.34/mm/hugetlb.c
index b1aa0d8..aaba3cc 100644
--- v2.6.34/mm/hugetlb.c
+++ v2.6.34/mm/hugetlb.c
@@ -2821,3 +2821,19 @@ void hugetlb_unreserve_pages(struct inode *inode, long offset, long freed)
 	hugetlb_put_quota(inode->i_mapping, (chg - freed));
 	hugetlb_acct_memory(h, -(chg - freed));
 }
+
+/*
+ * This function is called from memory failure code.
+ * Assume the caller holds page lock of the head page.
+ */
+void __isolate_hwpoisoned_huge_page(struct page *hpage)
+{
+	struct hstate *h = page_hstate(hpage);
+	int nid = page_to_nid(hpage);
+
+	spin_lock(&hugetlb_lock);
+	list_del(&hpage->lru);
+	h->free_huge_pages--;
+	h->free_huge_pages_node[nid]--;
+	spin_unlock(&hugetlb_lock);
+}
diff --git v2.6.34/mm/memory-failure.c v2.6.34/mm/memory-failure.c
index 473f15a..d0b420a 100644
--- v2.6.34/mm/memory-failure.c
+++ v2.6.34/mm/memory-failure.c
@@ -690,17 +690,29 @@ static int me_swapcache_clean(struct page *p, unsigned long pfn)
 /*
  * Huge pages. Needs work.
  * Issues:
- * No rmap support so we cannot find the original mapper. In theory could walk
- * all MMs and look for the mappings, but that would be non atomic and racy.
- * Need rmap for hugepages for this. Alternatively we could employ a heuristic,
- * like just walking the current process and hoping it has it mapped (that
- * should be usually true for the common "shared database cache" case)
- * Should handle free huge pages and dequeue them too, but this needs to
- * handle huge page accounting correctly.
+ * - Error on hugepage is contained in hugepage unit (not in raw page unit.)
+ *   To narrow down kill region to one page, we need to break up pmd.
+ * - To support soft-offlining for hugepage, we need to support hugepage
+ *   migration.
  */
 static int me_huge_page(struct page *p, unsigned long pfn)
 {
-	return FAILED;
+	struct page *hpage = compound_head(p);
+	/*
+	 * We can safely recover from error on free or reserved (i.e.
+	 * not in-use) hugepage by dequeuing it from freelist.
+	 * To check whether a hugepage is in-use or not, we can't use
+	 * page->lru because it can be used in other hugepage operations,
+	 * such as __unmap_hugepage_range() and gather_surplus_pages().
+	 * So instead we use page_mapping() and PageAnon().
+	 * We assume that this function is called with page lock held,
+	 * so there is no race between isolation and mapping/unmapping.
+	 */
+	if (!(page_mapping(hpage) || PageAnon(hpage))) {
+		__isolate_hwpoisoned_huge_page(hpage);
+		return RECOVERED;
+	}
+	return DELAYED;
 }
 
 /*
-- 
1.7.0

