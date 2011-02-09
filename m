Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754351Ab1BIKqa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 05:46:30 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:58581 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754320Ab1BIKq2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 05:46:28 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Balbir Singh <balbir@linux.vnet.ibm.com>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>
Subject: [patch] memcg: remove memcg->reclaim_param_lock
Date: Wed,  9 Feb 2011 11:46:02 +0100
Message-Id: <1297248362-23579-1-git-send-email-hannes@cmpxchg.org>
X-Mailer: git-send-email 1.7.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The reclaim_param_lock is only taken around single reads and writes to
integer variables and is thus superfluous.  Drop it.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/memcontrol.c |   18 +-----------------
 1 files changed, 1 insertions(+), 17 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 6d007d6..236f627 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -218,12 +218,6 @@ struct mem_cgroup {
 	 * per zone LRU lists.
 	 */
 	struct mem_cgroup_lru_info info;
-
-	/*
-	  protect against reclaim related member.
-	*/
-	spinlock_t reclaim_param_lock;
-
 	/*
 	 * While reclaiming in a hierarchy, we cache the last child we
 	 * reclaimed from.
@@ -1104,17 +1098,12 @@ static unsigned long long mem_cgroup_margin(struct mem_cgroup *mem)
 static unsigned int get_swappiness(struct mem_cgroup *memcg)
 {
 	struct cgroup *cgrp = memcg->css.cgroup;
-	unsigned int swappiness;
 
 	/* root ? */
 	if (cgrp->parent == NULL)
 		return vm_swappiness;
 
-	spin_lock(&memcg->reclaim_param_lock);
-	swappiness = memcg->swappiness;
-	spin_unlock(&memcg->reclaim_param_lock);
-
-	return swappiness;
+	return memcg->swappiness;
 }
 
 static void mem_cgroup_start_move(struct mem_cgroup *mem)
@@ -1330,13 +1319,11 @@ mem_cgroup_select_victim(struct mem_cgroup *root_mem)
 
 		rcu_read_unlock();
 		/* Updates scanning parameter */
-		spin_lock(&root_mem->reclaim_param_lock);
 		if (!css) {
 			/* this means start scan from ID:1 */
 			root_mem->last_scanned_child = 0;
 		} else
 			root_mem->last_scanned_child = found;
-		spin_unlock(&root_mem->reclaim_param_lock);
 	}
 
 	return ret;
@@ -3842,9 +3829,7 @@ static int mem_cgroup_swappiness_write(struct cgroup *cgrp, struct cftype *cft,
 		return -EINVAL;
 	}
 
-	spin_lock(&memcg->reclaim_param_lock);
 	memcg->swappiness = val;
-	spin_unlock(&memcg->reclaim_param_lock);
 
 	cgroup_unlock();
 
@@ -4500,7 +4485,6 @@ mem_cgroup_create(struct cgroup_subsys *ss, struct cgroup *cont)
 		res_counter_init(&mem->memsw, NULL);
 	}
 	mem->last_scanned_child = 0;
-	spin_lock_init(&mem->reclaim_param_lock);
 	INIT_LIST_HEAD(&mem->oom_notify);
 
 	if (parent)
-- 
1.7.4

