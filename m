Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753886Ab1HNQbO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 12:31:14 -0400
Received: from hera.kernel.org ([140.211.167.34]:49175 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753790Ab1HNQbK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 12:31:10 -0400
Date: Sun, 14 Aug 2011 16:30:49 GMT
From: tip-bot for Paul Turner <pjt@google.com>
Message-ID: <tip-64660c864f46202b932b911a69deb09805bdbaf8@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, seto.hidetoshi@jp.fujitsu.com, pjt@google.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        seto.hidetoshi@jp.fujitsu.com, a.p.zijlstra@chello.nl, pjt@google.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20110721184757.777916795@google.com>
References: <20110721184757.777916795@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Prevent interactions with throttled entities
Git-Commit-ID: 64660c864f46202b932b911a69deb09805bdbaf8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 14 Aug 2011 16:30:53 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  64660c864f46202b932b911a69deb09805bdbaf8
Gitweb:     http://git.kernel.org/tip/64660c864f46202b932b911a69deb09805bdbaf8
Author:     Paul Turner <pjt@google.com>
AuthorDate: Thu, 21 Jul 2011 09:43:36 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 14 Aug 2011 12:03:40 +0200

sched: Prevent interactions with throttled entities

>From the perspective of load-balance and shares distribution, throttled
entities should be invisible.

However, both of these operations work on 'active' lists and are not
inherently aware of what group hierarchies may be present.  In some cases this
may be side-stepped (e.g. we could sideload via tg_load_down in load balance)
while in others (e.g. update_shares()) it is more difficult to compute without
incurring some O(n^2) costs.

Instead, track hierarchicaal throttled state at time of transition.  This
allows us to easily identify whether an entity belongs to a throttled hierarchy
and avoid incorrect interactions with it.

Also, when an entity leaves a throttled hierarchy we need to advance its
time averaging for shares averaging so that the elapsed throttled time is not
considered as part of the cfs_rq's operation.

We also use this information to prevent buddy interactions in the wakeup and
yield_to() paths.

Signed-off-by: Paul Turner <pjt@google.com>
Reviewed-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20110721184757.777916795@google.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c      |    2 +-
 kernel/sched_fair.c |   99 +++++++++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 94 insertions(+), 7 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 8ec1e7a..5db05f6 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -402,7 +402,7 @@ struct cfs_rq {
 	u64 runtime_expires;
 	s64 runtime_remaining;
 
-	int throttled;
+	int throttled, throttle_count;
 	struct list_head throttled_list;
 #endif
 #endif
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 7641195..5a20894 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -706,6 +706,8 @@ account_entity_dequeue(struct cfs_rq *cfs_rq, struct sched_entity *se)
 }
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
+/* we need this in update_cfs_load and load-balance functions below */
+static inline int throttled_hierarchy(struct cfs_rq *cfs_rq);
 # ifdef CONFIG_SMP
 static void update_cfs_rq_load_contribution(struct cfs_rq *cfs_rq,
 					    int global_update)
@@ -728,7 +730,7 @@ static void update_cfs_load(struct cfs_rq *cfs_rq, int global_update)
 	u64 now, delta;
 	unsigned long load = cfs_rq->load.weight;
 
-	if (cfs_rq->tg == &root_task_group)
+	if (cfs_rq->tg == &root_task_group || throttled_hierarchy(cfs_rq))
 		return;
 
 	now = rq_of(cfs_rq)->clock_task;
@@ -837,7 +839,7 @@ static void update_cfs_shares(struct cfs_rq *cfs_rq)
 
 	tg = cfs_rq->tg;
 	se = tg->se[cpu_of(rq_of(cfs_rq))];
-	if (!se)
+	if (!se || throttled_hierarchy(cfs_rq))
 		return;
 #ifndef CONFIG_SMP
 	if (likely(se->load.weight == tg->shares))
@@ -1403,6 +1405,65 @@ static inline int cfs_rq_throttled(struct cfs_rq *cfs_rq)
 	return cfs_rq->throttled;
 }
 
+/* check whether cfs_rq, or any parent, is throttled */
+static inline int throttled_hierarchy(struct cfs_rq *cfs_rq)
+{
+	return cfs_rq->throttle_count;
+}
+
+/*
+ * Ensure that neither of the group entities corresponding to src_cpu or
+ * dest_cpu are members of a throttled hierarchy when performing group
+ * load-balance operations.
+ */
+static inline int throttled_lb_pair(struct task_group *tg,
+				    int src_cpu, int dest_cpu)
+{
+	struct cfs_rq *src_cfs_rq, *dest_cfs_rq;
+
+	src_cfs_rq = tg->cfs_rq[src_cpu];
+	dest_cfs_rq = tg->cfs_rq[dest_cpu];
+
+	return throttled_hierarchy(src_cfs_rq) ||
+	       throttled_hierarchy(dest_cfs_rq);
+}
+
+/* updated child weight may affect parent so we have to do this bottom up */
+static int tg_unthrottle_up(struct task_group *tg, void *data)
+{
+	struct rq *rq = data;
+	struct cfs_rq *cfs_rq = tg->cfs_rq[cpu_of(rq)];
+
+	cfs_rq->throttle_count--;
+#ifdef CONFIG_SMP
+	if (!cfs_rq->throttle_count) {
+		u64 delta = rq->clock_task - cfs_rq->load_stamp;
+
+		/* leaving throttled state, advance shares averaging windows */
+		cfs_rq->load_stamp += delta;
+		cfs_rq->load_last += delta;
+
+		/* update entity weight now that we are on_rq again */
+		update_cfs_shares(cfs_rq);
+	}
+#endif
+
+	return 0;
+}
+
+static int tg_throttle_down(struct task_group *tg, void *data)
+{
+	struct rq *rq = data;
+	struct cfs_rq *cfs_rq = tg->cfs_rq[cpu_of(rq)];
+
+	/* group is entering throttled state, record last load */
+	if (!cfs_rq->throttle_count)
+		update_cfs_load(cfs_rq, 0);
+	cfs_rq->throttle_count++;
+
+	return 0;
+}
+
 static __used void throttle_cfs_rq(struct cfs_rq *cfs_rq)
 {
 	struct rq *rq = rq_of(cfs_rq);
@@ -1413,7 +1474,9 @@ static __used void throttle_cfs_rq(struct cfs_rq *cfs_rq)
 	se = cfs_rq->tg->se[cpu_of(rq_of(cfs_rq))];
 
 	/* account load preceding throttle */
-	update_cfs_load(cfs_rq, 0);
+	rcu_read_lock();
+	walk_tg_tree_from(cfs_rq->tg, tg_throttle_down, tg_nop, (void *)rq);
+	rcu_read_unlock();
 
 	task_delta = cfs_rq->h_nr_running;
 	for_each_sched_entity(se) {
@@ -1454,6 +1517,10 @@ static void unthrottle_cfs_rq(struct cfs_rq *cfs_rq)
 	list_del_rcu(&cfs_rq->throttled_list);
 	raw_spin_unlock(&cfs_b->lock);
 
+	update_rq_clock(rq);
+	/* update hierarchical throttle state */
+	walk_tg_tree_from(cfs_rq->tg, tg_nop, tg_unthrottle_up, (void *)rq);
+
 	if (!cfs_rq->load.weight)
 		return;
 
@@ -1598,6 +1665,17 @@ static inline int cfs_rq_throttled(struct cfs_rq *cfs_rq)
 {
 	return 0;
 }
+
+static inline int throttled_hierarchy(struct cfs_rq *cfs_rq)
+{
+	return 0;
+}
+
+static inline int throttled_lb_pair(struct task_group *tg,
+				    int src_cpu, int dest_cpu)
+{
+	return 0;
+}
 #endif
 
 /**************************************************
@@ -2493,6 +2571,9 @@ move_one_task(struct rq *this_rq, int this_cpu, struct rq *busiest,
 
 	for_each_leaf_cfs_rq(busiest, cfs_rq) {
 		list_for_each_entry_safe(p, n, &cfs_rq->tasks, se.group_node) {
+			if (throttled_lb_pair(task_group(p),
+					      busiest->cpu, this_cpu))
+				break;
 
 			if (!can_migrate_task(p, busiest, this_cpu,
 						sd, idle, &pinned))
@@ -2608,8 +2689,13 @@ static void update_shares(int cpu)
 	 * Iterates the task_group tree in a bottom up fashion, see
 	 * list_add_leaf_cfs_rq() for details.
 	 */
-	for_each_leaf_cfs_rq(rq, cfs_rq)
+	for_each_leaf_cfs_rq(rq, cfs_rq) {
+		/* throttled entities do not contribute to load */
+		if (throttled_hierarchy(cfs_rq))
+			continue;
+
 		update_shares_cpu(cfs_rq->tg, cpu);
+	}
 	rcu_read_unlock();
 }
 
@@ -2659,9 +2745,10 @@ load_balance_fair(struct rq *this_rq, int this_cpu, struct rq *busiest,
 		u64 rem_load, moved_load;
 
 		/*
-		 * empty group
+		 * empty group or part of a throttled hierarchy
 		 */
-		if (!busiest_cfs_rq->task_weight)
+		if (!busiest_cfs_rq->task_weight ||
+		    throttled_lb_pair(busiest_cfs_rq->tg, cpu_of(busiest), this_cpu))
 			continue;
 
 		rem_load = (u64)rem_load_move * busiest_weight;
