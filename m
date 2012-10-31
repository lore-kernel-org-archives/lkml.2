Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945997Ab2JaSRj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 14:17:39 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33705 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935862Ab2JaSQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 14:16:50 -0400
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com, hannes@cmpxchg.org, mhocko@suse.cz,
        bsingharora@gmail.com, kamezawa.hiroyu@jp.fujitsu.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 6/8] memcg: make mem_cgroup_reparent_charges non failing
Date: Wed, 31 Oct 2012 11:16:29 -0700
Message-Id: <1351707391-22287-7-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1351707391-22287-1-git-send-email-tj@kernel.org>
References: <1351707391-22287-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Hocko <mhocko@suse.cz>

Now that pre_destroy callbacks are called from the context where neither
any task can attach the group nor any children group can be added there
is no other way to fail from mem_cgroup_pre_destroy.
mem_cgroup_pre_destroy doesn't have to take a reference to memcg's css
because all css' are marked dead already.

tj: Remove now unused local variable @cgrp from
    mem_cgroup_reparent_charges().

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Reviewed-by: Glauber Costa <glommer@parallels.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
 mm/memcontrol.c | 19 ++++++-------------
 1 file changed, 6 insertions(+), 13 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 1033b2b..47c4680 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3740,14 +3740,11 @@ static void mem_cgroup_force_empty_list(struct mem_cgroup *memcg,
  *
  * Caller is responsible for holding css reference on the memcg.
  */
-static int mem_cgroup_reparent_charges(struct mem_cgroup *memcg)
+static void mem_cgroup_reparent_charges(struct mem_cgroup *memcg)
 {
-	struct cgroup *cgrp = memcg->css.cgroup;
 	int node, zid;
 
 	do {
-		if (cgroup_task_count(cgrp) || !list_empty(&cgrp->children))
-			return -EBUSY;
 		/* This is for making all *used* pages to be on LRU. */
 		lru_add_drain_all();
 		drain_all_stock_sync(memcg);
@@ -3773,8 +3770,6 @@ static int mem_cgroup_reparent_charges(struct mem_cgroup *memcg)
 		 * charge before adding to the LRU.
 		 */
 	} while (res_counter_read_u64(&memcg->res, RES_USAGE) > 0);
-
-	return 0;
 }
 
 /*
@@ -3811,7 +3806,9 @@ static int mem_cgroup_force_empty(struct mem_cgroup *memcg)
 
 	}
 	lru_add_drain();
-	return mem_cgroup_reparent_charges(memcg);
+	mem_cgroup_reparent_charges(memcg);
+
+	return 0;
 }
 
 static int mem_cgroup_force_empty_write(struct cgroup *cont, unsigned int event)
@@ -5008,13 +5005,9 @@ free_out:
 static int mem_cgroup_pre_destroy(struct cgroup *cont)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_cont(cont);
-	int ret;
 
-	css_get(&memcg->css);
-	ret = mem_cgroup_reparent_charges(memcg);
-	css_put(&memcg->css);
-
-	return ret;
+	mem_cgroup_reparent_charges(memcg);
+	return 0;
 }
 
 static void mem_cgroup_destroy(struct cgroup *cont)
-- 
1.7.11.7

