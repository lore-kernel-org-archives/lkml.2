Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753489Ab0H1Whx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Aug 2010 18:37:53 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:36656 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753312Ab0H1Whn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Aug 2010 18:37:43 -0400
Message-Id: <20100828223547.016319253@chello.nl>
User-Agent: quilt/0.47-1
Date: Sun, 29 Aug 2010 00:30:27 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Paul Turner <pjt@google.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Chris Friesen <cfriesen@nortel.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Pierre Bourdon <pbourdon@excellency.fr>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC][PATCH 2/3] sched: On-demand cfs_rq list
References: <20100828223025.054328145@chello.nl>
Content-Disposition: inline; filename=sched-tg-ondemand.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make certain load-balance actions scale per number of active cgroups
instead of the number of existing cgroups.

This makes wakeup/sleep paths more expensive, but is a win for systems
where the vast majority of existing cgroups are idle.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched.c      |   86 +++++++++-------------------------------------------
 kernel/sched_fair.c |   41 ++++++++++++++++++++++--
 kernel/sched_rt.c   |   24 ++++++++++++++
 3 files changed, 76 insertions(+), 75 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -344,6 +344,7 @@ struct cfs_rq {
 	 * leaf_cfs_rq_list ties together list of leaf cfs_rq's in a cpu. This
 	 * list is used during load balance.
 	 */
+	int on_list;
 	struct list_head leaf_cfs_rq_list;
 	struct task_group *tg;	/* group that "owns" this runqueue */
 
@@ -1529,7 +1530,7 @@ static unsigned long cpu_avg_load_per_ta
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
 
-static void update_cfs_load(struct cfs_rq *cfs_rq);
+static void update_cfs_load(struct cfs_rq *cfs_rq, int lb);
 static void update_cfs_shares(struct cfs_rq *cfs_rq);
 
 /*
@@ -1552,7 +1553,7 @@ static int tg_shares_up(struct task_grou
 	raw_spin_lock_irqsave(&rq->lock, flags);
 
 	update_rq_clock(rq);
-	update_cfs_load(cfs_rq);
+	update_cfs_load(cfs_rq, 1);
 
 	load_avg = div64_u64(cfs_rq->load_avg, cfs_rq->load_period+1);
 	load_avg -= cfs_rq->load_contribution;
@@ -7553,15 +7554,13 @@ static void init_rt_rq(struct rt_rq *rt_
 
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
@@ -7581,7 +7580,7 @@ static void init_tg_cfs_entry(struct tas
 
 #ifdef CONFIG_RT_GROUP_SCHED
 static void init_tg_rt_entry(struct task_group *tg, struct rt_rq *rt_rq,
-		struct sched_rt_entity *rt_se, int cpu, int add,
+		struct sched_rt_entity *rt_se, int cpu,
 		struct sched_rt_entity *parent)
 {
 	struct rq *rq = cpu_rq(cpu);
@@ -7590,8 +7589,6 @@ static void init_tg_rt_entry(struct task
 	init_rt_rq(rt_rq, rq);
 	rt_rq->tg = tg;
 	rt_rq->rt_runtime = tg->rt_bandwidth.rt_runtime;
-	if (add)
-		list_add(&rt_rq->leaf_rt_rq_list, &rq->leaf_rt_rq_list);
 
 	tg->rt_se[cpu] = rt_se;
 	if (!rt_se)
@@ -7700,7 +7697,7 @@ void __init sched_init(void)
 		 * We achieve this by letting init_task_group's tasks sit
 		 * directly in rq->cfs (i.e init_task_group->se[] = NULL).
 		 */
-		init_tg_cfs_entry(&init_task_group, &rq->cfs, NULL, i, 1, NULL);
+		init_tg_cfs_entry(&init_task_group, &rq->cfs, NULL, i, NULL);
 #endif
 #endif /* CONFIG_FAIR_GROUP_SCHED */
 
@@ -7708,7 +7705,7 @@ void __init sched_init(void)
 #ifdef CONFIG_RT_GROUP_SCHED
 		INIT_LIST_HEAD(&rq->leaf_rt_rq_list);
 #ifdef CONFIG_CGROUP_SCHED
-		init_tg_rt_entry(&init_task_group, &rq->rt, NULL, i, 1, NULL);
+		init_tg_rt_entry(&init_task_group, &rq->rt, NULL, i, NULL);
 #endif
 #endif
 
@@ -7984,7 +7981,7 @@ int alloc_fair_sched_group(struct task_g
 		if (!se)
 			goto err_free_rq;
 
-		init_tg_cfs_entry(tg, cfs_rq, se, i, 0, parent->se[i]);
+		init_tg_cfs_entry(tg, cfs_rq, se, i, parent->se[i]);
 	}
 
 	return 1;
@@ -8015,14 +8012,6 @@ int alloc_fair_sched_group(struct task_g
 {
 	return 1;
 }
-
-static inline void register_fair_sched_group(struct task_group *tg, int cpu)
-{
-}
-
-static inline void unregister_fair_sched_group(struct task_group *tg, int cpu)
-{
-}
 #endif /* CONFIG_FAIR_GROUP_SCHED */
 
 #ifdef CONFIG_RT_GROUP_SCHED
@@ -8074,7 +8063,7 @@ int alloc_rt_sched_group(struct task_gro
 		if (!rt_se)
 			goto err_free_rq;
 
-		init_tg_rt_entry(tg, rt_rq, rt_se, i, 0, parent->rt_se[i]);
+		init_tg_rt_entry(tg, rt_rq, rt_se, i, parent->rt_se[i]);
 	}
 
 	return 1;
@@ -8084,17 +8073,6 @@ int alloc_rt_sched_group(struct task_gro
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
@@ -8105,14 +8083,6 @@ int alloc_rt_sched_group(struct task_gro
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
@@ -8128,7 +8098,6 @@ struct task_group *sched_create_group(st
 {
 	struct task_group *tg;
 	unsigned long flags;
-	int i;
 
 	tg = kzalloc(sizeof(*tg), GFP_KERNEL);
 	if (!tg)
@@ -8141,10 +8110,6 @@ struct task_group *sched_create_group(st
 		goto err;
 
 	spin_lock_irqsave(&task_group_lock, flags);
-	for_each_possible_cpu(i) {
-		register_fair_sched_group(tg, i);
-		register_rt_sched_group(tg, i);
-	}
 	list_add_rcu(&tg->list, &task_groups);
 
 	WARN_ON(!parent); /* root should already exist */
@@ -8175,10 +8140,12 @@ void sched_destroy_group(struct task_gro
 	int i;
 
 	spin_lock_irqsave(&task_group_lock, flags);
-	for_each_possible_cpu(i) {
-		unregister_fair_sched_group(tg, i);
-		unregister_rt_sched_group(tg, i);
-	}
+	/*
+	 * XXX should not be a race against enqueue, even without rq->lock
+	 * because only empty groups can be destroyed.
+	 */
+	for_each_possible_cpu(i)
+		list_del_leaf_cfs_rq(tg->cfs_rq[i]);
 	list_del_rcu(&tg->list);
 	list_del_rcu(&tg->siblings);
 	spin_unlock_irqrestore(&task_group_lock, flags);
@@ -8256,7 +8223,6 @@ static DEFINE_MUTEX(shares_mutex);
 int sched_group_set_shares(struct task_group *tg, unsigned long shares)
 {
 	int i;
-	unsigned long flags;
 
 	/*
 	 * We can't change the weight of the root cgroup.
@@ -8273,19 +8239,6 @@ int sched_group_set_shares(struct task_g
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
@@ -8294,15 +8247,6 @@ int sched_group_set_shares(struct task_g
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
Index: linux-2.6/kernel/sched_fair.c
===================================================================
--- linux-2.6.orig/kernel/sched_fair.c
+++ linux-2.6/kernel/sched_fair.c
@@ -143,6 +143,23 @@ static inline struct cfs_rq *cpu_cfs_rq(
 	return cfs_rq->tg->cfs_rq[this_cpu];
 }
 
+static inline void list_add_leaf_cfs_rq(struct cfs_rq *cfs_rq)
+{
+	if (!cfs_rq->on_list) {
+		list_add_rcu(&cfs_rq->leaf_cfs_rq_list,
+				&rq_of(cfs_rq)->leaf_cfs_rq_list);
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
@@ -246,6 +263,14 @@ static inline struct cfs_rq *cpu_cfs_rq(
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
 
@@ -648,7 +673,7 @@ account_entity_dequeue(struct cfs_rq *cf
 }
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
-static void update_cfs_load(struct cfs_rq *cfs_rq)
+static void update_cfs_load(struct cfs_rq *cfs_rq, int lb)
 {
 	u64 period = sched_avg_period();
 	u64 now = rq_of(cfs_rq)->clock;
@@ -668,6 +693,11 @@ static void update_cfs_load(struct cfs_r
 		cfs_rq->load_period /= 2;
 		cfs_rq->load_avg /= 2;
 	}
+
+	if (lb && !cfs_rq->nr_running) {
+		if (cfs_rq->load_period < (period / 8))
+			list_del_leaf_cfs_rq(cfs_rq);
+	}
 }
 
 static void reweight_entity(struct cfs_rq *cfs_rq, struct sched_entity *se,
@@ -729,7 +759,7 @@ static void update_cfs_shares(struct cfs
 	reweight_entity(cfs_rq_of(se), se, shares);
 }
 #else /* CONFIG_FAIR_GROUP_SCHED */
-static inline void update_cfs_load(struct cfs_rq *cfs_rq)
+static inline void update_cfs_load(struct cfs_rq *cfs_rq, int lb)
 {
 }
 
@@ -859,7 +889,7 @@ enqueue_entity(struct cfs_rq *cfs_rq, st
 	 * Update run-time statistics of the 'current'.
 	 */
 	update_curr(cfs_rq);
-	update_cfs_load(cfs_rq);
+	update_cfs_load(cfs_rq, 0);
 	account_entity_enqueue(cfs_rq, se);
 	update_cfs_shares(group_cfs_rq(se));
 
@@ -873,6 +903,9 @@ enqueue_entity(struct cfs_rq *cfs_rq, st
 	if (se != cfs_rq->curr)
 		__enqueue_entity(cfs_rq, se);
 	se->on_rq = 1;
+
+	if (cfs_rq->nr_running == 1)
+		list_add_leaf_cfs_rq(cfs_rq);
 }
 
 static void __clear_buddies(struct cfs_rq *cfs_rq, struct sched_entity *se)
@@ -917,7 +950,7 @@ dequeue_entity(struct cfs_rq *cfs_rq, st
 	if (se != cfs_rq->curr)
 		__dequeue_entity(cfs_rq, se);
 	se->on_rq = 0;
-	update_cfs_load(cfs_rq);
+	update_cfs_load(cfs_rq, 0);
 	account_entity_dequeue(cfs_rq, se);
 	update_min_vruntime(cfs_rq);
 	update_cfs_shares(group_cfs_rq(se));
Index: linux-2.6/kernel/sched_rt.c
===================================================================
--- linux-2.6.orig/kernel/sched_rt.c
+++ linux-2.6/kernel/sched_rt.c
@@ -183,6 +183,17 @@ static inline u64 sched_rt_period(struct
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
 
@@ -276,6 +287,14 @@ static inline u64 sched_rt_period(struct
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
 
@@ -825,6 +844,9 @@ static void __enqueue_rt_entity(struct s
 	if (group_rq && (rt_rq_throttled(group_rq) || !group_rq->rt_nr_running))
 		return;
 
+	if (!rt_rq->rt_nr_running)
+		list_add_leaf_rt_rq(rt_rq);
+
 	if (head)
 		list_add(&rt_se->run_list, queue);
 	else
@@ -844,6 +866,8 @@ static void __dequeue_rt_entity(struct s
 		__clear_bit(rt_se_prio(rt_se), array->bitmap);
 
 	dec_rt_tasks(rt_se, rt_rq);
+	if (!rt_rq->rt_nr_running)
+		list_del_leaf_rt_rq(rt_rq);
 }
 
 /*


