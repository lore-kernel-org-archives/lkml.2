Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754493Ab1FPD6l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 23:58:41 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:33818 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752924Ab1FPD6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 23:58:40 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 16 Jun 2011 12:51:41 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "bsingharora@gmail.com" <bsingharora@gmail.com>,
        Ying Han <yinghan@google.com>, Michal Hocko <mhocko@suse.cz>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>
Subject: [PATCH 1/7] Fix mem_cgroup_hierarchical_reclaim() to do stable
 hierarchy walk.
Message-Id: <20110616125141.5fbd230f.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110616124730.d6960b8b.kamezawa.hiroyu@jp.fujitsu.com>
References: <20110616124730.d6960b8b.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

patch is onto mmotm-06-15.
==
>From e58c243f3a5e5ace225a366b4f9d4dfdb0254e28 Mon Sep 17 00:00:00 2001
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Date: Wed, 15 Jun 2011 11:27:04 +0900
Subject: [PATCH 1/7] Fix mem_cgroup_hierarchical_reclaim() to do stable hierarchy walk.

Now, mem_cgroup_hierarchical_reclaim() walks memory cgroups under a tree
from a saved point (root_mem->last_scanned_child) until it visits
root_mem (a top of hierarchy tree) twice.

This means an unstable walk. Assume a tree consists of 6 nodes as

    Root-A-B-C-D-E.

When you start a scan from Root.
    Root->A->B-C-D-E->Root ==> end with scanning 6 groups.

When you start a scan from "A"
    A->B->C->D->E->Root->A->B->C->D->E->Root ==> end with scanning 11 groups.

This is unstable. This patch fixes to visit stable number of nodes at
every scan...visit all nodes only once. In above case,
    A->B->C->D->E->Root ==> end.

By this, the core loop can be much cleaner.

And this patch moves drain_all_stock_async() out of loop. Then,
it will be called once if a memcg hit limits.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 mm/memcontrol.c |   85 +++++++++++++++++++++++++++-----------------------------
 1 file changed, 42 insertions(+), 43 deletions(-)

Index: mmotm-0615/mm/memcontrol.c
===================================================================
--- mmotm-0615.orig/mm/memcontrol.c
+++ mmotm-0615/mm/memcontrol.c
@@ -1641,8 +1641,8 @@ int mem_cgroup_select_victim_node(struct
  *
  * root_mem is the original ancestor that we've been reclaim from.
  *
- * We give up and return to the caller when we visit root_mem twice.
- * (other groups can be removed while we're walking....)
+ * We give up and return to the caller when we visit enough memcgs.
+ * (Typically, we visit the whole memcg tree)
  *
  * If shrink==true, for avoiding to free too much, this returns immedieately.
  */
@@ -1660,6 +1660,7 @@ static int mem_cgroup_hierarchical_recla
 	bool check_soft = reclaim_options & MEM_CGROUP_RECLAIM_SOFT;
 	unsigned long excess;
 	unsigned long nr_scanned;
+	int visit;
 
 	excess = res_counter_soft_limit_excess(&root_mem->res) >> PAGE_SHIFT;
 
@@ -1667,41 +1668,28 @@ static int mem_cgroup_hierarchical_recla
 	if (!check_soft && root_mem->memsw_is_minimum)
 		noswap = true;
 
-	while (1) {
+again:
+	if (!shrink) {
+		visit = 0;
+		for_each_mem_cgroup_tree(victim, root_mem)
+			visit++;
+	} else {
+		/*
+		 * At shrinking, we check the usage again in caller side.
+		 * so, visit children one by one.
+		 */
+		visit = 1;
+	}
+	/*
+	 * We are not draining per cpu cached charges during soft limit reclaim
+	 * because global reclaim doesn't care about charges. It tries to free
+	 * some memory and  charges will not give any.
+	 */
+	if (!check_soft)
+		drain_all_stock_async(root_mem);
+
+	while (visit--) {
 		victim = mem_cgroup_select_victim(root_mem);
-		if (victim == root_mem) {
-			loop++;
-			/*
-			 * We are not draining per cpu cached charges during
-			 * soft limit reclaim  because global reclaim doesn't
-			 * care about charges. It tries to free some memory and
-			 * charges will not give any.
-			 */
-			if (!check_soft && loop >= 1)
-				drain_all_stock_async(root_mem);
-			if (loop >= 2) {
-				/*
-				 * If we have not been able to reclaim
-				 * anything, it might because there are
-				 * no reclaimable pages under this hierarchy
-				 */
-				if (!check_soft || !total) {
-					css_put(&victim->css);
-					break;
-				}
-				/*
-				 * We want to do more targeted reclaim.
-				 * excess >> 2 is not to excessive so as to
-				 * reclaim too much, nor too less that we keep
-				 * coming back to reclaim from this cgroup
-				 */
-				if (total >= (excess >> 2) ||
-					(loop > MEM_CGROUP_MAX_RECLAIM_LOOPS)) {
-					css_put(&victim->css);
-					break;
-				}
-			}
-		}
 		if (!mem_cgroup_local_usage(victim)) {
 			/* this cgroup's local usage == 0 */
 			css_put(&victim->css);
@@ -1717,13 +1705,7 @@ static int mem_cgroup_hierarchical_recla
 			ret = try_to_free_mem_cgroup_pages(victim, gfp_mask,
 						noswap, get_swappiness(victim));
 		css_put(&victim->css);
-		/*
-		 * At shrinking usage, we can't check we should stop here or
-		 * reclaim more. It's depends on callers. last_scanned_child
-		 * will work enough for keeping fairness under tree.
-		 */
-		if (shrink)
-			return ret;
+
 		total += ret;
 		if (check_soft) {
 			if (!res_counter_soft_limit_excess(&root_mem->res))
@@ -1731,6 +1713,23 @@ static int mem_cgroup_hierarchical_recla
 		} else if (mem_cgroup_margin(root_mem))
 			return total;
 	}
+	/*
+	 * Basically, softlimit reclaim does deep scan for targeted reclaim. But
+	 * if we have not been able to reclaim anything, it might because
+	 * there are no reclaimable pages under this hierarchy. So, we don't
+	 * retry if total == 0.
+	 */
+	if (check_soft && total) {
+		/*
+		 * We want to do more targeted reclaim. excess >> 2 is not to
+		 * excessive so as to reclaim too much, nor too less that we
+		 * keep coming back to reclaim from this cgroup
+		 */
+		if (total < (excess >> 2) &&
+		   (loop <= MEM_CGROUP_MAX_RECLAIM_LOOPS))
+			goto again;
+	}
+
 	return total;
 }
 

