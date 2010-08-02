Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753119Ab0HBKUy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 06:20:54 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:41022 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752342Ab0HBKUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 06:20:53 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 2 Aug 2010 19:15:59 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-mm@kvack.org,
        "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        vgoyal@redhat.com, m-ikeda@ds.jp.nec.com, gthelen@google.com,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH -mm 3/5] memcg scalable file stat accounting method
Message-Id: <20100802191559.6af0cded.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100802191113.05c982e4.kamezawa.hiroyu@jp.fujitsu.com>
References: <20100802191113.05c982e4.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

At accounting file events per memory cgroup, we need to find memory cgroup
via page_cgroup->mem_cgroup. Now, we use lock_page_cgroup().

But, considering the context which page-cgroup for files are accessed,
we can use alternative light-weight mutual execusion in the most case.
At handling file-caches, the only race we have to take care of is "moving"
account, IOW, overwriting page_cgroup->mem_cgroup. Because file status
update is done while the page-cache is in stable state, we don't have to
take care of race with charge/uncharge.

Unlike charge/uncharge, "move" happens not so frequently. It happens only when
rmdir() and task-moving (with a special settings.)
This patch adds a race-checker for file-cache-status accounting v.s. account
moving. The new per-cpu-per-memcg counter MEM_CGROUP_ON_MOVE is added.
The routine for account move 
  1. Increment it before start moving
  2. Call synchronize_rcu()
  3. Decrement it after the end of moving.
By this, file-status-counting routine can check it needs to call
lock_page_cgroup(). In most case, I doesn't need to call it.


Changelog: 20100730
 - some cleanup.
Changelog: 20100729
 - replaced __this_cpu_xxx() with this_cpu_xxx
   (because we don't call spinlock)
 - added VM_BUG_ON().

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 mm/memcontrol.c |   78 +++++++++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 66 insertions(+), 12 deletions(-)

Index: mmotm-0727/mm/memcontrol.c
===================================================================
--- mmotm-0727.orig/mm/memcontrol.c
+++ mmotm-0727/mm/memcontrol.c
@@ -88,6 +88,7 @@ enum mem_cgroup_stat_index {
 	MEM_CGROUP_STAT_PGPGOUT_COUNT,	/* # of pages paged out */
 	MEM_CGROUP_STAT_SWAPOUT, /* # of pages, swapped out */
 	MEM_CGROUP_EVENTS,	/* incremented at every  pagein/pageout */
+	MEM_CGROUP_ON_MOVE,   /* A check for locking move account/status */
 
 	MEM_CGROUP_STAT_NSTATS,
 };
@@ -1074,7 +1075,49 @@ static unsigned int get_swappiness(struc
 	return swappiness;
 }
 
-/* A routine for testing mem is not under move_account */
+static void mem_cgroup_start_move(struct mem_cgroup *mem)
+{
+	int cpu;
+	/* for fast checking in mem_cgroup_update_file_stat() etc..*/
+	spin_lock(&mc.lock);
+	for_each_possible_cpu(cpu)
+		per_cpu(mem->stat->count[MEM_CGROUP_ON_MOVE], cpu) += 1;
+	spin_unlock(&mc.lock);
+
+	synchronize_rcu();
+}
+
+static void mem_cgroup_end_move(struct mem_cgroup *mem)
+{
+	int cpu;
+
+	if (!mem)
+		return;
+	/* for fast checking in mem_cgroup_update_file_stat() etc..*/
+	spin_lock(&mc.lock);
+	for_each_possible_cpu(cpu)
+		per_cpu(mem->stat->count[MEM_CGROUP_ON_MOVE], cpu) -= 1;
+	spin_unlock(&mc.lock);
+}
+
+/*
+ * mem_cgroup_is_moved -- checking a cgroup is mc.from target or not.
+ *                          used for avoiding race.
+ * mem_cgroup_under_move -- checking a cgroup is mc.from or mc.to or
+ *			    under hierarchy of them. used for waiting at
+ *			    memory pressure.
+ * Result of is_moved can be trusted until the end of rcu_read_unlock().
+ * The caller must do
+ *	rcu_read_lock();
+ *	result = mem_cgroup_is_moved();
+ *	.....make use of result here....
+ *	rcu_read_unlock();
+ */
+static bool mem_cgroup_is_moved(struct mem_cgroup *mem)
+{
+	VM_BUG_ON(!rcu_read_lock_held());
+	return this_cpu_read(mem->stat->count[MEM_CGROUP_ON_MOVE]) > 0;
+}
 
 static bool mem_cgroup_under_move(struct mem_cgroup *mem)
 {
@@ -1473,29 +1516,36 @@ void mem_cgroup_update_file_mapped(struc
 {
 	struct mem_cgroup *mem;
 	struct page_cgroup *pc;
+	bool need_lock = false;
 
 	pc = lookup_page_cgroup(page);
 	if (unlikely(!pc))
 		return;
-
-	lock_page_cgroup(pc);
+	rcu_read_lock();
 	mem = id_to_memcg(pc->mem_cgroup);
-	if (!mem || !PageCgroupUsed(pc))
+	if (likely(mem)) {
+		if (mem_cgroup_is_moved(mem)) {
+			/* need to serialize with move_account */
+			lock_page_cgroup(pc);
+			need_lock = true;
+			mem = id_to_memcg(pc->mem_cgroup);
+			if (unlikely(!mem))
+				goto done;
+		}
+	}
+	if (unlikely(!PageCgroupUsed(pc)))
 		goto done;
-
-	/*
-	 * Preemption is already disabled. We can use __this_cpu_xxx
-	 */
 	if (val > 0) {
-		__this_cpu_inc(mem->stat->count[MEM_CGROUP_STAT_FILE_MAPPED]);
+		this_cpu_inc(mem->stat->count[MEM_CGROUP_STAT_FILE_MAPPED]);
 		SetPageCgroupFileMapped(pc);
 	} else {
-		__this_cpu_dec(mem->stat->count[MEM_CGROUP_STAT_FILE_MAPPED]);
+		this_cpu_dec(mem->stat->count[MEM_CGROUP_STAT_FILE_MAPPED]);
 		ClearPageCgroupFileMapped(pc);
 	}
-
 done:
-	unlock_page_cgroup(pc);
+	if (need_lock)
+		unlock_page_cgroup(pc);
+	rcu_read_unlock();
 }
 
 /*
@@ -3034,6 +3084,7 @@ move_account:
 		lru_add_drain_all();
 		drain_all_stock_sync();
 		ret = 0;
+		mem_cgroup_start_move(mem);
 		for_each_node_state(node, N_HIGH_MEMORY) {
 			for (zid = 0; !ret && zid < MAX_NR_ZONES; zid++) {
 				enum lru_list l;
@@ -3047,6 +3098,7 @@ move_account:
 			if (ret)
 				break;
 		}
+		mem_cgroup_end_move(mem);
 		memcg_oom_recover(mem);
 		/* it seems parent cgroup doesn't have enough mem */
 		if (ret == -ENOMEM)
@@ -4513,6 +4565,7 @@ static void mem_cgroup_clear_mc(void)
 	mc.to = NULL;
 	mc.moving_task = NULL;
 	spin_unlock(&mc.lock);
+	mem_cgroup_end_move(from);
 	memcg_oom_recover(from);
 	memcg_oom_recover(to);
 	wake_up_all(&mc.waitq);
@@ -4543,6 +4596,7 @@ static int mem_cgroup_can_attach(struct 
 			VM_BUG_ON(mc.moved_charge);
 			VM_BUG_ON(mc.moved_swap);
 			VM_BUG_ON(mc.moving_task);
+			mem_cgroup_start_move(from);
 			spin_lock(&mc.lock);
 			mc.from = from;
 			mc.to = mem;

