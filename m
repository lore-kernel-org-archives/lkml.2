Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757091Ab2E3OkV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 10:40:21 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:43417 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756542Ab2E3OkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 10:40:06 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: linux-mm@kvack.org, kamezawa.hiroyu@jp.fujitsu.com, dhillf@gmail.com,
        rientjes@google.com, mhocko@suse.cz, akpm@linux-foundation.org,
        hannes@cmpxchg.org
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: [PATCH -V7 12/14] hugetlb: add charge/uncharge calls for HugeTLB alloc/free
Date: Wed, 30 May 2012 20:08:57 +0530
Message-Id: <1338388739-22919-13-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1338388739-22919-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1338388739-22919-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
x-cbid: 12053014-9574-0000-0000-000002FB993A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>

This adds necessary charge/uncharge calls in the HugeTLB code.  We do
hugetlb cgroup charge in page alloc and uncharge in compound page destructor.  We
also need to ignore HugeTLB pages in __mem_cgroup_uncharge_common because
that get called from delete_from_page_cache

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Hillf Danton <dhillf@gmail.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/hugetlb.c    |   16 +++++++++++++++-
 mm/memcontrol.c |    5 +++++
 2 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 6330de2..cad7a4d 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -625,6 +625,8 @@ static void free_huge_page(struct page *page)
 	BUG_ON(page_count(page));
 	BUG_ON(page_mapcount(page));
 
+	hugetlb_cgroup_uncharge_page(hstate_index(h),
+				     pages_per_huge_page(h), page);
 	spin_lock(&hugetlb_lock);
 	if (h->surplus_huge_pages_node[nid] && huge_page_order(h) < MAX_ORDER) {
 		/* remove the page from active list */
@@ -1112,7 +1114,10 @@ static struct page *alloc_huge_page(struct vm_area_struct *vma,
 	struct hstate *h = hstate_vma(vma);
 	struct page *page;
 	long chg;
+	int ret, idx;
+	struct hugetlb_cgroup *h_cg;
 
+	idx = hstate_index(h);
 	/*
 	 * Processes that did not create the mapping will have no
 	 * reserves and will not have accounted against subpool
@@ -1128,6 +1133,11 @@ static struct page *alloc_huge_page(struct vm_area_struct *vma,
 		if (hugepage_subpool_get_pages(spool, chg))
 			return ERR_PTR(-ENOSPC);
 
+	ret = hugetlb_cgroup_charge_page(idx, pages_per_huge_page(h), &h_cg);
+	if (ret) {
+		hugepage_subpool_put_pages(spool, chg);
+		return ERR_PTR(-ENOSPC);
+	}
 	spin_lock(&hugetlb_lock);
 	page = dequeue_huge_page_vma(h, vma, addr, avoid_reserve);
 	spin_unlock(&hugetlb_lock);
@@ -1135,6 +1145,9 @@ static struct page *alloc_huge_page(struct vm_area_struct *vma,
 	if (!page) {
 		page = alloc_buddy_huge_page(h, NUMA_NO_NODE);
 		if (!page) {
+			hugetlb_cgroup_uncharge_cgroup(idx,
+						       pages_per_huge_page(h),
+						       h_cg);
 			hugepage_subpool_put_pages(spool, chg);
 			return ERR_PTR(-ENOSPC);
 		}
@@ -1143,7 +1156,8 @@ static struct page *alloc_huge_page(struct vm_area_struct *vma,
 	set_page_private(page, (unsigned long)spool);
 
 	vma_commit_reservation(h, vma, addr);
-
+	/* update page cgroup details */
+	hugetlb_cgroup_commit_charge(idx, pages_per_huge_page(h), h_cg, page);
 	return page;
 }
 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 6df019b..a52780b 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2931,6 +2931,11 @@ __mem_cgroup_uncharge_common(struct page *page, enum charge_type ctype)
 
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

