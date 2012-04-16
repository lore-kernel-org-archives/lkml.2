Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753398Ab2DPKta (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 06:49:30 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:60617 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753114Ab2DPKpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 06:45:15 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: linux-mm@kvack.org, mgorman@suse.de, kamezawa.hiroyu@jp.fujitsu.com,
        dhillf@gmail.com, aarcange@redhat.com, mhocko@suse.cz,
        akpm@linux-foundation.org, hannes@cmpxchg.org
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH -V6 08/14] hugetlb: add charge/uncharge calls for HugeTLB alloc/free
Date: Mon, 16 Apr 2012 16:14:45 +0530
Message-Id: <1334573091-18602-9-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1334573091-18602-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1334573091-18602-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
x-cbid: 12041610-2674-0000-0000-0000040BF689
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>

This adds necessary charge/uncharge calls in the HugeTLB code. We do
memcg charge in page alloc and uncharge in compound page destructor.
We also need to ignore HugeTLB pages in __mem_cgroup_uncharge_common
because that get called from delete_from_page_cache

Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Hillf Danton <dhillf@gmail.com>
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 mm/hugetlb.c    |   20 +++++++++++++++++++-
 mm/memcontrol.c |    5 +++++
 2 files changed, 24 insertions(+), 1 deletion(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 8cd89b4..dd00087 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -21,6 +21,8 @@
 #include <linux/rmap.h>
 #include <linux/swap.h>
 #include <linux/swapops.h>
+#include <linux/memcontrol.h>
+#include <linux/page_cgroup.h>
 
 #include <asm/page.h>
 #include <asm/pgtable.h>
@@ -628,6 +630,8 @@ static void free_huge_page(struct page *page)
 	BUG_ON(page_mapcount(page));
 	INIT_LIST_HEAD(&page->lru);
 
+	mem_cgroup_hugetlb_uncharge_page(hstate_index(h),
+					 pages_per_huge_page(h), page);
 	spin_lock(&hugetlb_lock);
 	if (h->surplus_huge_pages_node[nid] && huge_page_order(h) < MAX_ORDER) {
 		update_and_free_page(h, page);
@@ -1113,7 +1117,10 @@ static struct page *alloc_huge_page(struct vm_area_struct *vma,
 	struct hstate *h = hstate_vma(vma);
 	struct page *page;
 	long chg;
+	int ret, idx;
+	struct mem_cgroup *memcg;
 
+	idx = hstate_index(h);
 	/*
 	 * Processes that did not create the mapping will have no
 	 * reserves and will not have accounted against subpool
@@ -1129,6 +1136,12 @@ static struct page *alloc_huge_page(struct vm_area_struct *vma,
 		if (hugepage_subpool_get_pages(spool, chg))
 			return ERR_PTR(-ENOSPC);
 
+	ret = mem_cgroup_hugetlb_charge_page(idx, pages_per_huge_page(h),
+					     &memcg);
+	if (ret) {
+		hugepage_subpool_put_pages(spool, chg);
+		return ERR_PTR(-ENOSPC);
+	}
 	spin_lock(&hugetlb_lock);
 	page = dequeue_huge_page_vma(h, vma, addr, avoid_reserve);
 	spin_unlock(&hugetlb_lock);
@@ -1136,6 +1149,9 @@ static struct page *alloc_huge_page(struct vm_area_struct *vma,
 	if (!page) {
 		page = alloc_buddy_huge_page(h, NUMA_NO_NODE);
 		if (!page) {
+			mem_cgroup_hugetlb_uncharge_memcg(idx,
+							  pages_per_huge_page(h),
+							  memcg);
 			hugepage_subpool_put_pages(spool, chg);
 			return ERR_PTR(-ENOSPC);
 		}
@@ -1144,7 +1160,9 @@ static struct page *alloc_huge_page(struct vm_area_struct *vma,
 	set_page_private(page, (unsigned long)spool);
 
 	vma_commit_reservation(h, vma, addr);
-
+	/* update page cgroup details */
+	mem_cgroup_hugetlb_commit_charge(idx, pages_per_huge_page(h),
+					 memcg, page);
 	return page;
 }
 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 884f479..e906b41 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2966,6 +2966,11 @@ __mem_cgroup_uncharge_common(struct page *page, enum charge_type ctype)
 
 	if (PageSwapCache(page))
 		return NULL;
+	/*
+	 * HugeTLB page uncharge happen in the HugeTLB compound page destructor
+	 */
+	if (PageHuge(page))
+		return NULL;
 
 	if (PageTransHuge(page)) {
 		nr_pages <<= compound_order(page);
-- 
1.7.10

