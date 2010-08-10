Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756641Ab0HJJdU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 05:33:20 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:41922 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755313Ab0HJJdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 05:33:07 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        Mel Gorman <mel@csn.ul.ie>, Wu Fengguang <fengguang.wu@intel.com>,
        "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/9] hugetlb: add allocate function for hugepage migration
Date: Tue, 10 Aug 2010 18:27:37 +0900
Message-Id: <1281432464-14833-3-git-send-email-n-horiguchi@ah.jp.nec.com>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1281432464-14833-1-git-send-email-n-horiguchi@ah.jp.nec.com>
References: <1281432464-14833-1-git-send-email-n-horiguchi@ah.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can't use existing hugepage allocation functions to allocate hugepage
for page migration, because page migration can happen asynchronously with
the running processes and page migration users should call the allocation
function with physical addresses (not virtual addresses) as arguments.

ChangeLog:
- add comment on top of alloc_huge_page_no_vma()

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 include/linux/hugetlb.h |    3 ++
 mm/hugetlb.c            |   90 +++++++++++++++++++++++++++++++++++++----------
 2 files changed, 74 insertions(+), 19 deletions(-)

diff --git linux-mce-hwpoison/include/linux/hugetlb.h linux-mce-hwpoison/include/linux/hugetlb.h
index f479700..142bd4f 100644
--- linux-mce-hwpoison/include/linux/hugetlb.h
+++ linux-mce-hwpoison/include/linux/hugetlb.h
@@ -228,6 +228,8 @@ struct huge_bootmem_page {
 	struct hstate *hstate;
 };
 
+struct page *alloc_huge_page_no_vma_node(struct hstate *h, int nid);
+
 /* arch callback */
 int __init alloc_bootmem_huge_page(struct hstate *h);
 
@@ -303,6 +305,7 @@ static inline struct hstate *page_hstate(struct page *page)
 
 #else
 struct hstate {};
+#define alloc_huge_page_no_vma_node(h, nid) NULL
 #define alloc_bootmem_huge_page(h) NULL
 #define hstate_file(f) NULL
 #define hstate_vma(v) NULL
diff --git linux-mce-hwpoison/mm/hugetlb.c linux-mce-hwpoison/mm/hugetlb.c
index 5c77a73..2815b83 100644
--- linux-mce-hwpoison/mm/hugetlb.c
+++ linux-mce-hwpoison/mm/hugetlb.c
@@ -466,11 +466,22 @@ static void enqueue_huge_page(struct hstate *h, struct page *page)
 	h->free_huge_pages_node[nid]++;
 }
 
+static struct page *dequeue_huge_page_node(struct hstate *h, int nid)
+{
+	struct page *page;
+	if (list_empty(&h->hugepage_freelists[nid]))
+		return NULL;
+	page = list_entry(h->hugepage_freelists[nid].next, struct page, lru);
+	list_del(&page->lru);
+	h->free_huge_pages--;
+	h->free_huge_pages_node[nid]--;
+	return page;
+}
+
 static struct page *dequeue_huge_page_vma(struct hstate *h,
 				struct vm_area_struct *vma,
 				unsigned long address, int avoid_reserve)
 {
-	int nid;
 	struct page *page = NULL;
 	struct mempolicy *mpol;
 	nodemask_t *nodemask;
@@ -496,19 +507,13 @@ static struct page *dequeue_huge_page_vma(struct hstate *h,
 
 	for_each_zone_zonelist_nodemask(zone, z, zonelist,
 						MAX_NR_ZONES - 1, nodemask) {
-		nid = zone_to_nid(zone);
-		if (cpuset_zone_allowed_softwall(zone, htlb_alloc_mask) &&
-		    !list_empty(&h->hugepage_freelists[nid])) {
-			page = list_entry(h->hugepage_freelists[nid].next,
-					  struct page, lru);
-			list_del(&page->lru);
-			h->free_huge_pages--;
-			h->free_huge_pages_node[nid]--;
-
-			if (!avoid_reserve)
-				decrement_hugepage_resv_vma(h, vma);
-
-			break;
+		if (cpuset_zone_allowed_softwall(zone, htlb_alloc_mask)) {
+			page = dequeue_huge_page_node(h, zone_to_nid(zone));
+			if (page) {
+				if (!avoid_reserve)
+					decrement_hugepage_resv_vma(h, vma);
+				break;
+			}
 		}
 	}
 err:
@@ -616,7 +621,7 @@ int PageHuge(struct page *page)
 }
 EXPORT_SYMBOL_GPL(PageHuge);
 
-static struct page *alloc_fresh_huge_page_node(struct hstate *h, int nid)
+static struct page *__alloc_huge_page_node(struct hstate *h, int nid)
 {
 	struct page *page;
 
@@ -627,14 +632,61 @@ static struct page *alloc_fresh_huge_page_node(struct hstate *h, int nid)
 		htlb_alloc_mask|__GFP_COMP|__GFP_THISNODE|
 						__GFP_REPEAT|__GFP_NOWARN,
 		huge_page_order(h));
+	if (page && arch_prepare_hugepage(page)) {
+		__free_pages(page, huge_page_order(h));
+		return NULL;
+	}
+
+	return page;
+}
+
+static struct page *alloc_fresh_huge_page_node(struct hstate *h, int nid)
+{
+	struct page *page = __alloc_huge_page_node(h, nid);
+	if (page)
+		prep_new_huge_page(h, page, nid);
+	return page;
+}
+
+static struct page *alloc_buddy_huge_page_node(struct hstate *h, int nid)
+{
+	struct page *page = __alloc_huge_page_node(h, nid);
 	if (page) {
-		if (arch_prepare_hugepage(page)) {
-			__free_pages(page, huge_page_order(h));
+		set_compound_page_dtor(page, free_huge_page);
+		spin_lock(&hugetlb_lock);
+		h->nr_huge_pages++;
+		h->nr_huge_pages_node[nid]++;
+		spin_unlock(&hugetlb_lock);
+		put_page_testzero(page);
+	}
+	return page;
+}
+
+/*
+ * This allocation function is useful in the context where vma is irrelevant.
+ * E.g. soft-offlining uses this function because it only cares physical
+ * address of error page.
+ */
+struct page *alloc_huge_page_no_vma_node(struct hstate *h, int nid)
+{
+	struct page *page;
+
+	spin_lock(&hugetlb_lock);
+	get_mems_allowed();
+	page = dequeue_huge_page_node(h, nid);
+	put_mems_allowed();
+	spin_unlock(&hugetlb_lock);
+
+	if (!page) {
+		page = alloc_buddy_huge_page_node(h, nid);
+		if (!page) {
+			__count_vm_event(HTLB_BUDDY_PGALLOC_FAIL);
 			return NULL;
-		}
-		prep_new_huge_page(h, page, nid);
+		} else
+			__count_vm_event(HTLB_BUDDY_PGALLOC);
 	}
 
+	set_page_refcounted(page);
 	return page;
 }
 
-- 
1.7.2.1

