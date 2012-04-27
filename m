Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754902Ab2D0GI2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 02:08:28 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:35735 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751503Ab2D0GI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 02:08:26 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4F9A375D.7@jp.fujitsu.com>
Date: Fri, 27 Apr 2012 15:06:21 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:12.0) Gecko/20120420 Thunderbird/12.0
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>,
        Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Glauber Costa <glommer@parallels.com>, Tejun Heo <tj@kernel.org>,
        Han Ying <yinghan@google.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, kamezawa.hiroyuki@gmail.com
Subject: [RFC][PATCH 9/9 v2] memcg: never return error at pre_destroy()
References: <4F9A327A.6050409@jp.fujitsu.com>
In-Reply-To: <4F9A327A.6050409@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When force_empty() called by ->pre_destroy(), no memory reclaim happens
and it doesn't take very long time which requires signal_pending() check.
And if we return -EINTR from pre_destroy(), cgroup.c show warning.

This patch removes signal check in force_empty(). By this, ->pre_destroy()
returns success always.

Note: check for 'cgroup is empty' remains for force_empty interface.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 mm/hugetlb.c    |   10 +---------
 mm/memcontrol.c |   14 +++++---------
 2 files changed, 6 insertions(+), 18 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 4dd6b39..770f1642 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1922,20 +1922,12 @@ int hugetlb_force_memcg_empty(struct cgroup *cgroup)
 	int ret = 0, idx = 0;
 
 	do {
+		/* see memcontrol.c::mem_cgroup_force_empty() */
 		if (cgroup_task_count(cgroup)
 			|| !list_empty(&cgroup->children)) {
 			ret = -EBUSY;
 			goto out;
 		}
-		/*
-		 * If the task doing the cgroup_rmdir got a signal
-		 * we don't really need to loop till the hugetlb resource
-		 * usage become zero.
-		 */
-		if (signal_pending(current)) {
-			ret = -EINTR;
-			goto out;
-		}
 		for_each_hstate(h) {
 			spin_lock(&hugetlb_lock);
 			list_for_each_entry(page, &h->hugepage_activelist, lru) {
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 2715223..ee350c5 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3852,8 +3852,6 @@ static int mem_cgroup_force_empty_list(struct mem_cgroup *memcg,
 		pc = lookup_page_cgroup(page);
 
 		ret = mem_cgroup_move_parent(page, pc, memcg, GFP_KERNEL);
-		if (ret == -ENOMEM || ret == -EINTR)
-			break;
 
 		if (ret == -EBUSY || ret == -EINVAL) {
 			/* found lock contention or "pc" is obsolete. */
@@ -3863,7 +3861,7 @@ static int mem_cgroup_force_empty_list(struct mem_cgroup *memcg,
 			busy = NULL;
 	}
 
-	if (!ret && !list_empty(list))
+	if (!loop)
 		return -EBUSY;
 	return ret;
 }
@@ -3893,11 +3891,12 @@ static int mem_cgroup_force_empty(struct mem_cgroup *memcg, bool free_all)
 move_account:
 	do {
 		ret = -EBUSY;
+		/*
+		 * This never happens when this is called by ->pre_destroy().
+		 * But we need to take care of force_empty interface.
+		 */
 		if (cgroup_task_count(cgrp) || !list_empty(&cgrp->children))
 			goto out;
-		ret = -EINTR;
-		if (signal_pending(current))
-			goto out;
 		/* This is for making all *used* pages to be on LRU. */
 		lru_add_drain_all();
 		drain_all_stock_sync(memcg);
@@ -3918,9 +3917,6 @@ move_account:
 		}
 		mem_cgroup_end_move(memcg);
 		memcg_oom_recover(memcg);
-		/* it seems parent cgroup doesn't have enough mem */
-		if (ret == -ENOMEM)
-			goto try_to_free;
 		cond_resched();
 	/* "ret" should also be checked to ensure all lists are empty. */
 	} while (res_counter_read_u64(&memcg->res, RES_USAGE) > 0 || ret);
-- 
1.7.4.1


