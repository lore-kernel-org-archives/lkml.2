Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965357Ab1GMLhE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 07:37:04 -0400
Received: from merlin.infradead.org ([205.233.59.134]:34516 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964915Ab1GMLhC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 07:37:02 -0400
Subject: [RFT][PATCH] sched, cgroup: Optimize load_balance_fair()
From: Peter Zijlstra <peterz@infradead.org>
To: Paul Turner <pjt@google.com>, Nikhil Rao <ncrao@google.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 13 Jul 2011 13:36:49 +0200
Message-ID: <1310557009.2586.28.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: sched, cgroup: Optimize load_balance_fair()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Wed Jul 13 13:09:25 CEST 2011

Use for_each_leaf_cfs_rq() instead of list_for_each_entry_rcu(), this
achieves that load_balance_fair() only iterates those task_groups that
actually have tasks on busiest, and that we iterate bottom-up, trying to
move light groups before the heavier ones.

No idea if it will actually work out to be beneficial in practice, does
anybody have a cgroup workload that might show a difference one way or
the other?

[ Also move update_h_load to sched_fair.c, loosing #ifdef-ery ]

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched.c      |   32 --------------------------------
 kernel/sched_fair.c |   40 +++++++++++++++++++++++++++++++++++-----
 2 files changed, 35 insertions(+), 37 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -1568,38 +1568,6 @@ static unsigned long cpu_avg_load_per_ta
 	return rq->avg_load_per_task;
 }
 
-#ifdef CONFIG_FAIR_GROUP_SCHED
-
-/*
- * Compute the cpu's hierarchical load factor for each task group.
- * This needs to be done in a top-down fashion because the load of a child
- * group is a fraction of its parents load.
- */
-static int tg_load_down(struct task_group *tg, void *data)
-{
-	unsigned long load;
-	long cpu = (long)data;
-
-	if (!tg->parent) {
-		load = cpu_rq(cpu)->load.weight;
-	} else {
-		load = tg->parent->cfs_rq[cpu]->h_load;
-		load *= tg->se[cpu]->load.weight;
-		load /= tg->parent->cfs_rq[cpu]->load.weight + 1;
-	}
-
-	tg->cfs_rq[cpu]->h_load = load;
-
-	return 0;
-}
-
-static void update_h_load(long cpu)
-{
-	walk_tg_tree(tg_load_down, tg_nop, (void *)cpu);
-}
-
-#endif
-
 #ifdef CONFIG_PREEMPT
 
 static void double_rq_lock(struct rq *rq1, struct rq *rq2);
Index: linux-2.6/kernel/sched_fair.c
===================================================================
--- linux-2.6.orig/kernel/sched_fair.c
+++ linux-2.6/kernel/sched_fair.c
@@ -2232,11 +2232,43 @@ static void update_shares(int cpu)
 	struct rq *rq = cpu_rq(cpu);
 
 	rcu_read_lock();
+	/*
+	 * Iterates the task_group tree in a bottom up fashion, see
+	 * list_add_leaf_cfs_rq() for details.
+	 */
 	for_each_leaf_cfs_rq(rq, cfs_rq)
 		update_shares_cpu(cfs_rq->tg, cpu);
 	rcu_read_unlock();
 }
 
+/*
+ * Compute the cpu's hierarchical load factor for each task group.
+ * This needs to be done in a top-down fashion because the load of a child
+ * group is a fraction of its parents load.
+ */
+static int tg_load_down(struct task_group *tg, void *data)
+{
+	unsigned long load;
+	long cpu = (long)data;
+
+	if (!tg->parent) {
+		load = cpu_rq(cpu)->load.weight;
+	} else {
+		load = tg->parent->cfs_rq[cpu]->h_load;
+		load *= tg->se[cpu]->load.weight;
+		load /= tg->parent->cfs_rq[cpu]->load.weight + 1;
+	}
+
+	tg->cfs_rq[cpu]->h_load = load;
+
+	return 0;
+}
+
+static void update_h_load(long cpu)
+{
+	walk_tg_tree(tg_load_down, tg_nop, (void *)cpu);
+}
+
 static unsigned long
 load_balance_fair(struct rq *this_rq, int this_cpu, struct rq *busiest,
 		  unsigned long max_load_move,
@@ -2244,14 +2276,12 @@ load_balance_fair(struct rq *this_rq, in
 		  int *all_pinned)
 {
 	long rem_load_move = max_load_move;
-	int busiest_cpu = cpu_of(busiest);
-	struct task_group *tg;
+	struct cfs_rq *busiest_cfs_rq;
 
 	rcu_read_lock();
-	update_h_load(busiest_cpu);
+	update_h_load(cpu_of(busiest));
 
-	list_for_each_entry_rcu(tg, &task_groups, list) {
-		struct cfs_rq *busiest_cfs_rq = tg->cfs_rq[busiest_cpu];
+	for_each_leaf_cfs_rq(busiest, busiest_cfs_rq) {
 		unsigned long busiest_h_load = busiest_cfs_rq->h_load;
 		unsigned long busiest_weight = busiest_cfs_rq->load.weight;
 		u64 rem_load, moved_load;

