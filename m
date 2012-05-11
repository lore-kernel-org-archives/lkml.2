Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932966Ab2EKRsZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 13:48:25 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:27190 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932650Ab2EKRsW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 13:48:22 -0400
From: Glauber Costa <glommer@parallels.com>
To: <linux-kernel@vger.kernel.org>
Cc: <cgroups@vger.kernel.org>, <linux-mm@kvack.org>,
        <kamezawa.hiroyu@jp.fujitsu.com>, Tejun Heo <tj@kernel.org>,
        Li Zefan <lizefan@huawei.com>, Greg Thelen <gthelen@google.com>,
        Suleiman Souhlal <suleiman@google.com>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>, <devel@openvz.org>,
        Glauber Costa <glommer@parallels.com>
Subject: [PATCH v2 03/29] memcg: Always free struct memcg through schedule_work()
Date: Fri, 11 May 2012 14:44:05 -0300
Message-Id: <1336758272-24284-4-git-send-email-glommer@parallels.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1336758272-24284-1-git-send-email-glommer@parallels.com>
References: <1336758272-24284-1-git-send-email-glommer@parallels.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Right now we free struct memcg with kfree right after a
rcu grace period, but defer it if we need to use vfree() to get
rid of that memory area. We do that by need, because we need vfree
to be called in a process context.

This patch unifies this behavior, by ensuring that even kfree will
happen in a separate thread. The goal is to have a stable place to
call the upcoming jump label destruction function outside the realm
of the complicated and quite far-reaching cgroup lock (that can't be
held when calling neither the cpu_hotplug.lock nor the jump_label_mutex)

Signed-off-by: Glauber Costa <glommer@parallels.com>
CC: Tejun Heo <tj@kernel.org>
CC: Li Zefan <lizefan@huawei.com>
CC: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Johannes Weiner <hannes@cmpxchg.org>
CC: Michal Hocko <mhocko@suse.cz>
---
 mm/memcontrol.c |   24 +++++++++++++-----------
 1 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 932a734..0b4b4c8 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -245,8 +245,8 @@ struct mem_cgroup {
 		 */
 		struct rcu_head rcu_freeing;
 		/*
-		 * But when using vfree(), that cannot be done at
-		 * interrupt time, so we must then queue the work.
+		 * We also need some space for a worker in deferred freeing.
+		 * By the time we call it, rcu_freeing is not longer in use.
 		 */
 		struct work_struct work_freeing;
 	};
@@ -4826,23 +4826,28 @@ out_free:
 }
 
 /*
- * Helpers for freeing a vzalloc()ed mem_cgroup by RCU,
+ * Helpers for freeing a kmalloc()ed/vzalloc()ed mem_cgroup by RCU,
  * but in process context.  The work_freeing structure is overlaid
  * on the rcu_freeing structure, which itself is overlaid on memsw.
  */
-static void vfree_work(struct work_struct *work)
+static void free_work(struct work_struct *work)
 {
 	struct mem_cgroup *memcg;
+	int size = sizeof(struct mem_cgroup);
 
 	memcg = container_of(work, struct mem_cgroup, work_freeing);
-	vfree(memcg);
+	if (size < PAGE_SIZE)
+		kfree(memcg);
+	else
+		vfree(memcg);
 }
-static void vfree_rcu(struct rcu_head *rcu_head)
+
+static void free_rcu(struct rcu_head *rcu_head)
 {
 	struct mem_cgroup *memcg;
 
 	memcg = container_of(rcu_head, struct mem_cgroup, rcu_freeing);
-	INIT_WORK(&memcg->work_freeing, vfree_work);
+	INIT_WORK(&memcg->work_freeing, free_work);
 	schedule_work(&memcg->work_freeing);
 }
 
@@ -4868,10 +4873,7 @@ static void __mem_cgroup_free(struct mem_cgroup *memcg)
 		free_mem_cgroup_per_zone_info(memcg, node);
 
 	free_percpu(memcg->stat);
-	if (sizeof(struct mem_cgroup) < PAGE_SIZE)
-		kfree_rcu(memcg, rcu_freeing);
-	else
-		call_rcu(&memcg->rcu_freeing, vfree_rcu);
+	call_rcu(&memcg->rcu_freeing, free_rcu);
 }
 
 static void mem_cgroup_get(struct mem_cgroup *memcg)
-- 
1.7.7.6

