Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758410Ab0KROLO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 09:11:14 -0500
Received: from hera.kernel.org ([140.211.167.34]:41548 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758146Ab0KROLL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 09:11:11 -0500
Date: Thu, 18 Nov 2010 14:10:37 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, pjt@google.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, pjt@google.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <20101115234937.666535048@google.com>
References: <20101115234937.666535048@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Implement on-demand (active) cfs_rq list
Message-ID: <tip-3d4b47b4b040c9d77dd68104cfc1055d89a55afd@git.kernel.org>
Git-Commit-ID: 3d4b47b4b040c9d77dd68104cfc1055d89a55afd
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 18 Nov 2010 14:10:38 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3d4b47b4b040c9d77dd68104cfc1055d89a55afd
Gitweb:     http://git.kernel.org/tip/3d4b47b4b040c9d77dd68104cfc1055d89a55afd
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Mon, 15 Nov 2010 15:47:01 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 18 Nov 2010 13:27:47 +0100

sched: Implement on-demand (active) cfs_rq list

Make certain load-balance actions scale per number of active cgroups
instead of the number of existing cgroups.

This makes wakeup/sleep paths more expensive, but is a win for systems
where the vast majority of existing cgroups are idle.

Signed-off-by: Paul Turner <pjt@google.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <20101115234937.666535048@google.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c      |  105 +++++++++++++-------------------------------------
 kernel/sched_fair.c |   46 +++++++++++++++++++---
 kernel/sched_rt.c   |   24 ++++++++++++
 3 files changed, 92 insertions(+), 83 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index e2f1a30..22436dd 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -274,9 +274,7 @@ struct task_group {
 
 #define root_task_group init_task_group
 
-/* task_group_lock serializes add/remove of task groups and also changes to
- * a task group's cpu shares.
- */
+/* task_group_lock serializes the addition/removal of task groups */
 static DEFINE_SPINLOCK(task_group_lock);
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
@@ -344,6 +342,7 @@ struct cfs_rq {
 	 * leaf_cfs_rq_list ties together list of leaf cfs_rq's in a cpu. This
 	 * list is used during load balance.
 	 */
+	int on_list;
 	struct list_head leaf_cfs_rq_list;
 	struct task_group *tg;	/* group that "owns" this runqueue */
 
@@ -1547,7 +1546,7 @@ static unsigned long cpu_avg_load_per_task(int cpu)
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
 
-static void update_cfs_load(struct cfs_rq *cfs_rq);
+static void update_cfs_load(struct cfs_rq *cfs_rq, int lb);
 static void update_cfs_shares(struct cfs_rq *cfs_rq);
 
 /*
@@ -1570,7 +1569,7 @@ static int tg_shares_up(struct task_group *tg, void *data)
 	raw_spin_lock_irqsave(&rq->lock, flags);
 
 	update_rq_clock(rq);
-	update_cfs_load(cfs_rq);
+	update_cfs_load(cfs_rq, 1);
 
 	load_avg = div64_u64(cfs_rq->load_avg, cfs_rq->load_period+1);
 	load_avg -= cfs_rq->load_contribution;
@@ -7688,15 +7687,13 @@ static void init_rt_rq(struct rt_rq *rt_rq, struct rq *rq)
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
 static void init_tg_cfs_entry(struct task_group *tg, struct cfs_rq *cfs_rq,
-				struct sched_entity *se, int cpu, int add,
+				struct sched_entity *se, int cpu,
 				struct sched_entity *parent)
 {
 	struct rq *rq = cpu_rq(cpu);
 	tg->cfs_rq[cpu] = cfs_rq;
 	init_cfs_rq(cfs_rq, rq);
 	cfs_rq->tg = tg;
-	if (add)
-		list_add(&cfs_rq->leaf_cfs_rq_list, &rq->leaf_cfs_rq_list);
 
 	tg->se[cpu] = se;
 	/* se could be NULL for init_task_group */
@@ -7716,7 +7713,7 @@ static void init_tg_cfs_entry(struct task_group *tg, struct cfs_rq *cfs_rq,
 
 #ifdef CONFIG_RT_GROUP_SCHED
 static void init_tg_rt_entry(struct task_group *tg, struct rt_rq *rt_rq,
-		struct sched_rt_entity *rt_se, int cpu, int add,
+		struct sched_rt_entity *rt_se, int cpu,
 		struct sched_rt_entity *parent)
 {
 	struct rq *rq = cpu_rq(cpu);
@@ -7725,8 +7722,6 @@ static void init_tg_rt_entry(struct task_group *tg, struct rt_rq *rt_rq,
 	init_rt_rq(rt_rq, rq);
 	rt_rq->tg = tg;
 	rt_rq->rt_runtime = tg->rt_bandwidth.rt_runtime;
-	if (add)
-		list_add(&rt_rq->leaf_rt_rq_list, &rq->leaf_rt_rq_list);
 
 	tg->rt_se[cpu] = rt_se;
 	if (!rt_se)
@@ -7835,7 +7830,7 @@ void __init sched_init(void)
 		 * We achieve this by letting init_task_group's tasks sit
 		 * directly in rq->cfs (i.e init_task_group->se[] = NULL).
 		 */
-		init_tg_cfs_entry(&init_task_group, &rq->cfs, NULL, i, 1, NULL);
+		init_tg_cfs_entry(&init_task_group, &rq->cfs, NULL, i, NULL);
 #endif
 #endif /* CONFIG_FAIR_GROUP_SCHED */
 
@@ -7843,7 +7838,7 @@ void __init sched_init(void)
 #ifdef CONFIG_RT_GROUP_SCHED
 		INIT_LIST_HEAD(&rq->leaf_rt_rq_list);
 #ifdef CONFIG_CGROUP_SCHED
-		init_tg_rt_entry(&init_task_group, &rq->rt, NULL, i, 1, NULL);
+		init_tg_rt_entry(&init_task_group, &rq->rt, NULL, i, NULL);
 #endif
 #endif
 
@@ -8119,7 +8114,7 @@ int alloc_fair_sched_group(struct task_group *tg, struct task_group *parent)
 		if (!se)
 			goto err_free_rq;
 
-		init_tg_cfs_entry(tg, cfs_rq, se, i, 0, parent->se[i]);
+		init_tg_cfs_entry(tg, cfs_rq, se, i, parent->se[i]);
 	}
 
 	return 1;
@@ -8130,15 +8125,22 @@ err:
 	return 0;
 }
 
-static inline void register_fair_sched_group(struct task_group *tg, int cpu)
-{
-	list_add_rcu(&tg->cfs_rq[cpu]->leaf_cfs_rq_list,
-			&cpu_rq(cpu)->leaf_cfs_rq_list);
-}
-
 static inline void unregister_fair_sched_group(struct task_group *tg, int cpu)
 {
-	list_del_rcu(&tg->cfs_rq[cpu]->leaf_cfs_rq_list);
+	struct rq *rq = cpu_rq(cpu);
+	unsigned long flags;
+	int i;
+
+	/*
+	* Only empty task groups can be destroyed; so we can speculatively
+	* check on_list without danger of it being re-added.
+	*/
+	if (!tg->cfs_rq[cpu]->on_list)
+		return;
+
+	raw_spin_lock_irqsave(&rq->lock, flags);
+	list_del_leaf_cfs_rq(tg->cfs_rq[i]);
+	raw_spin_unlock_irqrestore(&rq->lock, flags);
 }
 #else /* !CONFG_FAIR_GROUP_SCHED */
 static inline void free_fair_sched_group(struct task_group *tg)
@@ -8151,10 +8153,6 @@ int alloc_fair_sched_group(struct task_group *tg, struct task_group *parent)
 	return 1;
 }
 
-static inline void register_fair_sched_group(struct task_group *tg, int cpu)
-{
-}
-
 static inline void unregister_fair_sched_group(struct task_group *tg, int cpu)
 {
 }
@@ -8209,7 +8207,7 @@ int alloc_rt_sched_group(struct task_group *tg, struct task_group *parent)
 		if (!rt_se)
 			goto err_free_rq;
 
-		init_tg_rt_entry(tg, rt_rq, rt_se, i, 0, parent->rt_se[i]);
+		init_tg_rt_entry(tg, rt_rq, rt_se, i, parent->rt_se[i]);
 	}
 
 	return 1;
@@ -8219,17 +8217,6 @@ err_free_rq:
 err:
 	return 0;
 }
-
-static inline void register_rt_sched_group(struct task_group *tg, int cpu)
-{
-	list_add_rcu(&tg->rt_rq[cpu]->leaf_rt_rq_list,
-			&cpu_rq(cpu)->leaf_rt_rq_list);
-}
-
-static inline void unregister_rt_sched_group(struct task_group *tg, int cpu)
-{
-	list_del_rcu(&tg->rt_rq[cpu]->leaf_rt_rq_list);
-}
 #else /* !CONFIG_RT_GROUP_SCHED */
 static inline void free_rt_sched_group(struct task_group *tg)
 {
@@ -8240,14 +8227,6 @@ int alloc_rt_sched_group(struct task_group *tg, struct task_group *parent)
 {
 	return 1;
 }
-
-static inline void register_rt_sched_group(struct task_group *tg, int cpu)
-{
-}
-
-static inline void unregister_rt_sched_group(struct task_group *tg, int cpu)
-{
-}
 #endif /* CONFIG_RT_GROUP_SCHED */
 
 #ifdef CONFIG_CGROUP_SCHED
@@ -8263,7 +8242,6 @@ struct task_group *sched_create_group(struct task_group *parent)
 {
 	struct task_group *tg;
 	unsigned long flags;
-	int i;
 
 	tg = kzalloc(sizeof(*tg), GFP_KERNEL);
 	if (!tg)
@@ -8276,10 +8254,6 @@ struct task_group *sched_create_group(struct task_group *parent)
 		goto err;
 
 	spin_lock_irqsave(&task_group_lock, flags);
-	for_each_possible_cpu(i) {
-		register_fair_sched_group(tg, i);
-		register_rt_sched_group(tg, i);
-	}
 	list_add_rcu(&tg->list, &task_groups);
 
 	WARN_ON(!parent); /* root should already exist */
@@ -8309,11 +8283,11 @@ void sched_destroy_group(struct task_group *tg)
 	unsigned long flags;
 	int i;
 
-	spin_lock_irqsave(&task_group_lock, flags);
-	for_each_possible_cpu(i) {
+	/* end participation in shares distribution */
+	for_each_possible_cpu(i)
 		unregister_fair_sched_group(tg, i);
-		unregister_rt_sched_group(tg, i);
-	}
+
+	spin_lock_irqsave(&task_group_lock, flags);
 	list_del_rcu(&tg->list);
 	list_del_rcu(&tg->siblings);
 	spin_unlock_irqrestore(&task_group_lock, flags);
@@ -8391,7 +8365,6 @@ static DEFINE_MUTEX(shares_mutex);
 int sched_group_set_shares(struct task_group *tg, unsigned long shares)
 {
 	int i;
-	unsigned long flags;
 
 	/*
 	 * We can't change the weight of the root cgroup.
@@ -8408,19 +8381,6 @@ int sched_group_set_shares(struct task_group *tg, unsigned long shares)
 	if (tg->shares == shares)
 		goto done;
 
-	spin_lock_irqsave(&task_group_lock, flags);
-	for_each_possible_cpu(i)
-		unregister_fair_sched_group(tg, i);
-	list_del_rcu(&tg->siblings);
-	spin_unlock_irqrestore(&task_group_lock, flags);
-
-	/* wait for any ongoing reference to this group to finish */
-	synchronize_sched();
-
-	/*
-	 * Now we are free to modify the group's share on each cpu
-	 * w/o tripping rebalance_share or load_balance_fair.
-	 */
 	tg->shares = shares;
 	for_each_possible_cpu(i) {
 		/*
@@ -8429,15 +8389,6 @@ int sched_group_set_shares(struct task_group *tg, unsigned long shares)
 		set_se_shares(tg->se[i], shares);
 	}
 
-	/*
-	 * Enable load balance activity on this group, by inserting it back on
-	 * each cpu's rq->leaf_cfs_rq_list.
-	 */
-	spin_lock_irqsave(&task_group_lock, flags);
-	for_each_possible_cpu(i)
-		register_fair_sched_group(tg, i);
-	list_add_rcu(&tg->siblings, &tg->parent->children);
-	spin_unlock_irqrestore(&task_group_lock, flags);
 done:
 	mutex_unlock(&shares_mutex);
 	return 0;
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index d86544b..0560e72 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -143,6 +143,24 @@ static inline struct cfs_rq *cpu_cfs_rq(struct cfs_rq *cfs_rq, int this_cpu)
 	return cfs_rq->tg->cfs_rq[this_cpu];
 }
 
+static inline void list_add_leaf_cfs_rq(struct cfs_rq *cfs_rq)
+{
+	if (!cfs_rq->on_list) {
+		list_add_rcu(&cfs_rq->leaf_cfs_rq_list,
+				&rq_of(cfs_rq)->leaf_cfs_rq_list);
+
+		cfs_rq->on_list = 1;
+	}
+}
+
+static inline void list_del_leaf_cfs_rq(struct cfs_rq *cfs_rq)
+{
+	if (cfs_rq->on_list) {
+		list_del_rcu(&cfs_rq->leaf_cfs_rq_list);
+		cfs_rq->on_list = 0;
+	}
+}
+
 /* Iterate thr' all leaf cfs_rq's on a runqueue */
 #define for_each_leaf_cfs_rq(rq, cfs_rq) \
 	list_for_each_entry_rcu(cfs_rq, &rq->leaf_cfs_rq_list, leaf_cfs_rq_list)
@@ -246,6 +264,14 @@ static inline struct cfs_rq *cpu_cfs_rq(struct cfs_rq *cfs_rq, int this_cpu)
 	return &cpu_rq(this_cpu)->cfs;
 }
 
+static inline void list_add_leaf_cfs_rq(struct cfs_rq *cfs_rq)
+{
+}
+
+static inline void list_del_leaf_cfs_rq(struct cfs_rq *cfs_rq)
+{
+}
+
 #define for_each_leaf_cfs_rq(rq, cfs_rq) \
 		for (cfs_rq = &rq->cfs; cfs_rq; cfs_rq = NULL)
 
@@ -648,7 +674,7 @@ account_entity_dequeue(struct cfs_rq *cfs_rq, struct sched_entity *se)
 }
 
 #if defined CONFIG_SMP && defined CONFIG_FAIR_GROUP_SCHED
-static void update_cfs_load(struct cfs_rq *cfs_rq)
+static void update_cfs_load(struct cfs_rq *cfs_rq, int lb)
 {
 	u64 period = sched_avg_period();
 	u64 now, delta;
@@ -673,6 +699,11 @@ static void update_cfs_load(struct cfs_rq *cfs_rq)
 		cfs_rq->load_period /= 2;
 		cfs_rq->load_avg /= 2;
 	}
+
+	if (lb && !cfs_rq->nr_running) {
+		if (cfs_rq->load_avg < (period / 8))
+			list_del_leaf_cfs_rq(cfs_rq);
+	}
 }
 
 static void reweight_entity(struct cfs_rq *cfs_rq, struct sched_entity *se,
@@ -719,7 +750,7 @@ static void update_cfs_shares(struct cfs_rq *cfs_rq)
 	reweight_entity(cfs_rq_of(se), se, shares);
 }
 #else /* CONFIG_FAIR_GROUP_SCHED */
-static inline void update_cfs_load(struct cfs_rq *cfs_rq)
+static inline void update_cfs_load(struct cfs_rq *cfs_rq, int lb)
 {
 }
 
@@ -849,7 +880,7 @@ enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
 	 * Update run-time statistics of the 'current'.
 	 */
 	update_curr(cfs_rq);
-	update_cfs_load(cfs_rq);
+	update_cfs_load(cfs_rq, 0);
 	account_entity_enqueue(cfs_rq, se);
 	update_cfs_shares(cfs_rq);
 
@@ -863,6 +894,9 @@ enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
 	if (se != cfs_rq->curr)
 		__enqueue_entity(cfs_rq, se);
 	se->on_rq = 1;
+
+	if (cfs_rq->nr_running == 1)
+		list_add_leaf_cfs_rq(cfs_rq);
 }
 
 static void __clear_buddies(struct cfs_rq *cfs_rq, struct sched_entity *se)
@@ -907,7 +941,7 @@ dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
 	if (se != cfs_rq->curr)
 		__dequeue_entity(cfs_rq, se);
 	se->on_rq = 0;
-	update_cfs_load(cfs_rq);
+	update_cfs_load(cfs_rq, 0);
 	account_entity_dequeue(cfs_rq, se);
 	update_min_vruntime(cfs_rq);
 	update_cfs_shares(cfs_rq);
@@ -1142,7 +1176,7 @@ enqueue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 	for_each_sched_entity(se) {
 		struct cfs_rq *cfs_rq = cfs_rq_of(se);
 
-		update_cfs_load(cfs_rq);
+		update_cfs_load(cfs_rq, 0);
 		update_cfs_shares(cfs_rq);
 	}
 
@@ -1172,7 +1206,7 @@ static void dequeue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 	for_each_sched_entity(se) {
 		struct cfs_rq *cfs_rq = cfs_rq_of(se);
 
-		update_cfs_load(cfs_rq);
+		update_cfs_load(cfs_rq, 0);
 		update_cfs_shares(cfs_rq);
 	}
 
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index bea7d79..c914ec7 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -183,6 +183,17 @@ static inline u64 sched_rt_period(struct rt_rq *rt_rq)
 	return ktime_to_ns(rt_rq->tg->rt_bandwidth.rt_period);
 }
 
+static inline void list_add_leaf_rt_rq(struct rt_rq *rt_rq)
+{
+	list_add_rcu(&rt_rq->leaf_rt_rq_list,
+			&rq_of_rt_rq(rt_rq)->leaf_rt_rq_list);
+}
+
+static inline void list_del_leaf_rt_rq(struct rt_rq *rt_rq)
+{
+	list_del_rcu(&rt_rq->leaf_rt_rq_list);
+}
+
 #define for_each_leaf_rt_rq(rt_rq, rq) \
 	list_for_each_entry_rcu(rt_rq, &rq->leaf_rt_rq_list, leaf_rt_rq_list)
 
@@ -276,6 +287,14 @@ static inline u64 sched_rt_period(struct rt_rq *rt_rq)
 	return ktime_to_ns(def_rt_bandwidth.rt_period);
 }
 
+static inline void list_add_leaf_rt_rq(struct rt_rq *rt_rq)
+{
+}
+
+static inline void list_del_leaf_rt_rq(struct rt_rq *rt_rq)
+{
+}
+
 #define for_each_leaf_rt_rq(rt_rq, rq) \
 	for (rt_rq = &rq->rt; rt_rq; rt_rq = NULL)
 
@@ -825,6 +844,9 @@ static void __enqueue_rt_entity(struct sched_rt_entity *rt_se, bool head)
 	if (group_rq && (rt_rq_throttled(group_rq) || !group_rq->rt_nr_running))
 		return;
 
+	if (!rt_rq->rt_nr_running)
+		list_add_leaf_rt_rq(rt_rq);
+
 	if (head)
 		list_add(&rt_se->run_list, queue);
 	else
@@ -844,6 +866,8 @@ static void __dequeue_rt_entity(struct sched_rt_entity *rt_se)
 		__clear_bit(rt_se_prio(rt_se), array->bitmap);
 
 	dec_rt_tasks(rt_se, rt_rq);
+	if (!rt_rq->rt_nr_running)
+		list_del_leaf_rt_rq(rt_rq);
 }
 
 /*
