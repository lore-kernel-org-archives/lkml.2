Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932364Ab2EKJuR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 05:50:17 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:36922 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932109Ab2EKJuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 05:50:10 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4FACE05C.60608@jp.fujitsu.com>
Date: Fri, 11 May 2012 18:48:12 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: "linux-mm@kvack.org" <linux-mm@kvack.org>
CC: "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>,
        Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Han Ying <yinghan@google.com>, Glauber Costa <glommer@parallels.com>,
        Tejun Heo <tj@kernel.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH v3 3/6] memcg: use res_counter_uncharge_until in move_parent()
References: <4FACDED0.3020400@jp.fujitsu.com>
In-Reply-To: <4FACDED0.3020400@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By using res_counter_uncharge_until(), we can avoid race and
unnecessary charging.

Changelog since v2:
 - a coding style chanve in __mem_cgroup_cancel_local_charge()
 - fixed typos.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 mm/memcontrol.c |   63 ++++++++++++++++++++++++++++++++++++------------------
 1 files changed, 42 insertions(+), 21 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 09109be..cb90be1 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2446,6 +2446,24 @@ static void __mem_cgroup_cancel_charge(struct mem_cgroup *memcg,
 }
 
 /*
+ * Cancel chrages in this cgroup....doesn't propagate to parent cgroup.
+ * This is useful when moving usage to parent cgroup.
+ */
+static void __mem_cgroup_cancel_local_charge(struct mem_cgroup *memcg,
+					unsigned int nr_pages)
+{
+	unsigned long bytes = nr_pages * PAGE_SIZE;
+
+	if (mem_cgroup_is_root(memcg))
+		return;
+
+	res_counter_uncharge_until(&memcg->res, memcg->res.parent, bytes);
+	if (do_swap_account)
+		res_counter_uncharge_until(&memcg->memsw,
+						memcg->memsw.parent, bytes);
+}
+
+/*
  * A helper function to get mem_cgroup from ID. must be called under
  * rcu_read_lock(). The caller must check css_is_removed() or some if
  * it's concern. (dropping refcnt from swap can be called against removed
@@ -2711,16 +2729,28 @@ static int mem_cgroup_move_parent(struct page *page,
 	nr_pages = hpage_nr_pages(page);
 
 	parent = mem_cgroup_from_cont(pcg);
-	ret = __mem_cgroup_try_charge(NULL, gfp_mask, nr_pages, &parent, false);
-	if (ret)
-		goto put_back;
+	if (!parent->use_hierarchy) {
+		ret = __mem_cgroup_try_charge(NULL,
+					gfp_mask, nr_pages, &parent, false);
+		if (ret)
+			goto put_back;
+	}
 
 	if (nr_pages > 1)
 		flags = compound_lock_irqsave(page);
 
-	ret = mem_cgroup_move_account(page, nr_pages, pc, child, parent, true);
-	if (ret)
-		__mem_cgroup_cancel_charge(parent, nr_pages);
+	if (parent->use_hierarchy) {
+		ret = mem_cgroup_move_account(page, nr_pages,
+					pc, child, parent, false);
+		if (!ret)
+			__mem_cgroup_cancel_local_charge(child, nr_pages);
+	} else {
+		ret = mem_cgroup_move_account(page, nr_pages,
+					pc, child, parent, true);
+
+		if (ret)
+			__mem_cgroup_cancel_charge(parent, nr_pages);
+	}
 
 	if (nr_pages > 1)
 		compound_unlock_irqrestore(page, flags);
@@ -3324,6 +3354,7 @@ int mem_cgroup_move_hugetlb_parent(int idx, struct cgroup *cgroup,
 	struct cgroup *pcgrp = cgroup->parent;
 	struct mem_cgroup *parent = mem_cgroup_from_cont(pcgrp);
 	struct mem_cgroup *memcg  = mem_cgroup_from_cont(cgroup);
+	struct res_counter *counter;
 
 	if (!get_page_unless_zero(page))
 		goto out;
@@ -3334,28 +3365,18 @@ int mem_cgroup_move_hugetlb_parent(int idx, struct cgroup *cgroup,
 		goto err_out;
 
 	csize = PAGE_SIZE << compound_order(page);
-	/*
-	 * If we have use_hierarchy set we can never fail here. So instead of
-	 * using res_counter_uncharge use the open-coded variant which just
-	 * uncharge the child res_counter. The parent will retain the charge.
-	 */
-	if (parent->use_hierarchy) {
-		unsigned long flags;
-		struct res_counter *counter;
-
-		counter = &memcg->hugepage[idx];
-		spin_lock_irqsave(&counter->lock, flags);
-		res_counter_uncharge_locked(counter, csize);
-		spin_unlock_irqrestore(&counter->lock, flags);
-	} else {
+	/* If parent->use_hierarchy == 0, we need to charge parent */
+	if (!parent->use_hierarchy) {
 		ret = res_counter_charge(&parent->hugepage[idx],
 					 csize, &fail_res);
 		if (ret) {
 			ret = -EBUSY;
 			goto err_out;
 		}
-		res_counter_uncharge(&memcg->hugepage[idx], csize);
 	}
+	counter = &memcg->hugepage[idx];
+	res_counter_uncharge_until(counter, counter->parent, csize);
+
 	pc->mem_cgroup = parent;
 err_out:
 	unlock_page_cgroup(pc);
-- 
1.7.4.1


