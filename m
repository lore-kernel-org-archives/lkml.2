Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752463Ab2GRFe3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 01:34:29 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:40131 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019Ab2GRFeW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 01:34:22 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: linux-mm@kvack.org, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz,
        akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] hugetlb/cgroup: Simplify pre_destroy callback
Date: Wed, 18 Jul 2012 11:04:09 +0530
Message-Id: <1342589649-15066-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.10
x-cbid: 12071805-5564-0000-0000-000003A653B1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>

Since we cannot fail in hugetlb_cgroup_move_parent, we don't really
need to check whether cgroup have any change left after that. Also skip
those hstates for which we don't have any charge in this cgroup.

Based on an earlier patch from  Wanpeng Li <liwanp@linux.vnet.ibm.com>
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 mm/hugetlb_cgroup.c |   49 +++++++++++++++++++++----------------------------
 1 file changed, 21 insertions(+), 28 deletions(-)

diff --git a/mm/hugetlb_cgroup.c b/mm/hugetlb_cgroup.c
index b834e8d..b355fb4 100644
--- a/mm/hugetlb_cgroup.c
+++ b/mm/hugetlb_cgroup.c
@@ -65,18 +65,6 @@ static inline struct hugetlb_cgroup *parent_hugetlb_cgroup(struct cgroup *cg)
 	return hugetlb_cgroup_from_cgroup(cg->parent);
 }
 
-static inline bool hugetlb_cgroup_have_usage(struct cgroup *cg)
-{
-	int idx;
-	struct hugetlb_cgroup *h_cg = hugetlb_cgroup_from_cgroup(cg);
-
-	for (idx = 0; idx < hugetlb_max_hstate; idx++) {
-		if ((res_counter_read_u64(&h_cg->hugepage[idx], RES_USAGE)) > 0)
-			return true;
-	}
-	return false;
-}
-
 static struct cgroup_subsys_state *hugetlb_cgroup_create(struct cgroup *cgroup)
 {
 	int idx;
@@ -159,24 +147,29 @@ static int hugetlb_cgroup_pre_destroy(struct cgroup *cgroup)
 {
 	struct hstate *h;
 	struct page *page;
-	int ret = 0, idx = 0;
+	int ret = 0, idx;
+	struct hugetlb_cgroup *h_cg = hugetlb_cgroup_from_cgroup(cgroup);
 
-	do {
-		if (cgroup_task_count(cgroup) ||
-		    !list_empty(&cgroup->children)) {
-			ret = -EBUSY;
-			goto out;
-		}
-		for_each_hstate(h) {
-			spin_lock(&hugetlb_lock);
-			list_for_each_entry(page, &h->hugepage_activelist, lru)
-				hugetlb_cgroup_move_parent(idx, cgroup, page);
 
-			spin_unlock(&hugetlb_lock);
-			idx++;
-		}
-		cond_resched();
-	} while (hugetlb_cgroup_have_usage(cgroup));
+	if (cgroup_task_count(cgroup) ||
+	    !list_empty(&cgroup->children)) {
+		ret = -EBUSY;
+		goto out;
+	}
+
+	for_each_hstate(h) {
+		/*
+		 * if we don't have any charge, skip this hstate
+		 */
+		idx = hstate_index(h);
+		if (res_counter_read_u64(&h_cg->hugepage[idx], RES_USAGE) == 0)
+			continue;
+		spin_lock(&hugetlb_lock);
+		list_for_each_entry(page, &h->hugepage_activelist, lru)
+			hugetlb_cgroup_move_parent(idx, cgroup, page);
+		spin_unlock(&hugetlb_lock);
+		VM_BUG_ON(res_counter_read_u64(&h_cg->hugepage[idx], RES_USAGE));
+	}
 out:
 	return ret;
 }
-- 
1.7.10

