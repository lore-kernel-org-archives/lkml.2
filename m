Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753275Ab1GUS3F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 14:29:05 -0400
Received: from hera.kernel.org ([140.211.167.34]:49863 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752515Ab1GUS3D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 14:29:03 -0400
Date: Thu, 21 Jul 2011 18:28:52 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-9763b67fb9f3050c6da739105888327587c30c4d@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, pjt@google.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, pjt@google.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <1310557009.2586.28.camel@twins>
References: <1310557009.2586.28.camel@twins>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched, cgroup: Optimize load_balance_fair()
Git-Commit-ID: 9763b67fb9f3050c6da739105888327587c30c4d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 21 Jul 2011 18:28:53 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9763b67fb9f3050c6da739105888327587c30c4d
Gitweb:     http://git.kernel.org/tip/9763b67fb9f3050c6da739105888327587c30c4d
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Wed, 13 Jul 2011 13:09:25 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 21 Jul 2011 18:01:46 +0200

sched, cgroup: Optimize load_balance_fair()

Use for_each_leaf_cfs_rq() instead of list_for_each_entry_rcu(), this
achieves that load_balance_fair() only iterates those task_groups that
actually have tasks on busiest, and that we iterate bottom-up, trying to
move light groups before the heavier ones.

No idea if it will actually work out to be beneficial in practice, does
anybody have a cgroup workload that might show a difference one way or
the other?

[ Also move update_h_load to sched_fair.c, loosing #ifdef-ery ]

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Reviewed-by: Paul Turner <pjt@google.com>
Link: http://lkml.kernel.org/r/1310557009.2586.28.camel@twins
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c      |   32 --------------------------------
 kernel/sched_fair.c |   40 +++++++++++++++++++++++++++++++++++-----
 2 files changed, 35 insertions(+), 37 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index b0e7ad7..474f341 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1568,38 +1568,6 @@ static unsigned long cpu_avg_load_per_task(int cpu)
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
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 6cdff84..180bcf1 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
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
@@ -2244,14 +2276,12 @@ load_balance_fair(struct rq *this_rq, int this_cpu, struct rq *busiest,
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
