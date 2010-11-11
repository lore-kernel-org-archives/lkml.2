Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932349Ab0KKDzI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 22:55:08 -0500
Received: from smtp-out.google.com ([216.239.44.51]:11432 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932322Ab0KKDzB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 22:55:01 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:references:user-agent:date:from:to:cc:subject:content-disposition;
	b=s1SCnxmD/GMkLvLXtVC7Vg56d1SdOR0mt0KY7Z3Sq6SfXtv40Ig/mMlzJtAVj5JsN
	mP8DWptPKdj4fKVLViVpA==
Message-Id: <20101111035050.539960770@google.com>
References: <20101111035005.443640006@google.com>
User-Agent: quilt/0.46-1
Date: Wed, 10 Nov 2010 19:50:07 -0800
From: Paul Turner <pjt@google.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Chris Friesen <cfriesen@nortel.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Pierre Bourdon <pbourdon@excellency.fr>, Paul Turner <pjt@google.com>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Karl Rister <kmr@us.ibm.com>, Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: [tg_shares_up rewrite v2 02/11] sched: on-demand (active) cfs_rq list
Content-Disposition: inline; filename=sched-tg-ondemand.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <a.p.zijlstra@chello.nl>

Make certain load-balance actions scale per number of active cgroups
instead of the number of existing cgroups.

This makes wakeup/sleep paths more expensive, but is a win for systems
where the vast majority of existing cgroups are idle.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Paul Turner <pjt@google.com>

---
 kernel/sched.c      |   86 +++++++++-------------------------------------------
 kernel/sched_fair.c |   46 ++++++++++++++++++++++++---
 kernel/sched_rt.c   |   24 ++++++++++++++
 3 files changed, 79 insertions(+), 77 deletions(-)

Index: kernel/sched.c
===================================================================
--- kernel/sched.c.orig
+++ kernel/sched.c
@@ -344,6 +344,7 @@ struct cfs_rq {
 	 * leaf_cfs_rq_list ties together list of leaf cfs_rq's in a cpu. This
 	 * list is used during load balance.
 	 */
+	int on_list;
 	struct list_head leaf_cfs_rq_list;
 	struct task_group *tg;	/* group that "owns" this runqueue */
 
@@ -1530,7 +1531,7 @@ static unsigned long cpu_avg_load_per_ta
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
 
-static void update_cfs_load(struct cfs_rq *cfs_rq);
+static void update_cfs_load(struct cfs_rq *cfs_rq, int lb);
 static void update_cfs_shares(struct cfs_rq *cfs_rq);
 
 /*
@@ -1553,7 +1554,7 @@ static int tg_shares_up(struct task_grou
 	raw_spin_lock_irqsave(&rq->lock, flags);
 
 	update_rq_clock(rq);
-	update_cfs_load(cfs_rq);
+	update_cfs_load(cfs_rq, 1);
 
 	load_avg = div64_u64(cfs_rq->load_avg, cfs_rq->load_period+1);
 	load_avg -= cfs_rq->load_contribution;
@@ -7622,15 +7623,13 @@ static void init_rt_rq(struct rt_rq *rt_
 
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
@@ -7650,7 +7649,7 @@ static void init_tg_cfs_entry(struct tas
 
 #ifdef CONFIG_RT_GROUP_SCHED
 static void init_tg_rt_entry(struct task_group *tg, struct rt_rq *rt_rq,
-		struct sched_rt_entity *rt_se, int cpu, int add,
+		struct sched_rt_entity *rt_se, int cpu,
 		struct sched_rt_entity *parent)
 {
 	struct rq *rq = cpu_rq(cpu);
@@ -7659,8 +7658,6 @@ static void init_tg_rt_entry(struct task
 	init_rt_rq(rt_rq, rq);
 	rt_rq->tg = tg;
 	rt_rq->rt_runtime = tg->rt_bandwidth.rt_runtime;
-	if (add)
-		list_add(&rt_rq->leaf_rt_rq_list, &rq->leaf_rt_rq_list);
 
 	tg->rt_se[cpu] = rt_se;
 	if (!rt_se)
@@ -7769,7 +7766,7 @@ void __init sched_init(void)
 		 * We achieve this by letting init_task_group's tasks sit
 		 * directly in rq->cfs (i.e init_task_group->se[] = NULL).
 		 */
-		init_tg_cfs_entry(&init_task_group, &rq->cfs, NULL, i, 1, NULL);
+		init_tg_cfs_entry(&init_task_group, &rq->cfs, NULL, i, NULL);
 #endif
 #endif /* CONFIG_FAIR_GROUP_SCHED */
 
@@ -7777,7 +7774,7 @@ void __init sched_init(void)
 #ifdef CONFIG_RT_GROUP_SCHED
 		INIT_LIST_HEAD(&rq->leaf_rt_rq_list);
 #ifdef CONFIG_CGROUP_SCHED
-		init_tg_rt_entry(&init_task_group, &rq->rt, NULL, i, 1, NULL);
+		init_tg_rt_entry(&init_task_group, &rq->rt, NULL, i, NULL);
 #endif
 #endif
 
@@ -8053,7 +8050,7 @@ int alloc_fair_sched_group(struct task_g
 		if (!se)
 			goto err_free_rq;
 
-		init_tg_cfs_entry(tg, cfs_rq, se, i, 0, parent->se[i]);
+		init_tg_cfs_entry(tg, cfs_rq, se, i, parent->se[i]);
 	}
 
 	return 1;
@@ -8084,14 +8081,6 @@ int alloc_fair_sched_group(struct task_g
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
@@ -8143,7 +8132,7 @@ int alloc_rt_sched_group(struct task_gro
 		if (!rt_se)
 			goto err_free_rq;
 
-		init_tg_rt_entry(tg, rt_rq, rt_se, i, 0, parent->rt_se[i]);
+		init_tg_rt_entry(tg, rt_rq, rt_se, i, parent->rt_se[i]);
 	}
 
 	return 1;
@@ -8153,17 +8142,6 @@ int alloc_rt_sched_group(struct task_gro
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
@@ -8174,14 +8152,6 @@ int alloc_rt_sched_group(struct task_gro
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
@@ -8197,7 +8167,6 @@ struct task_group *sched_create_group(st
 {
 	struct task_group *tg;
 	unsigned long flags;
-	int i;
 
 	tg = kzalloc(sizeof(*tg), GFP_KERNEL);
 	if (!tg)
@@ -8210,10 +8179,6 @@ struct task_group *sched_create_group(st
 		goto err;
 
 	spin_lock_irqsave(&task_group_lock, flags);
-	for_each_possible_cpu(i) {
-		register_fair_sched_group(tg, i);
-		register_rt_sched_group(tg, i);
-	}
 	list_add_rcu(&tg->list, &task_groups);
 
 	WARN_ON(!parent); /* root should already exist */
@@ -8244,10 +8209,12 @@ void sched_destroy_group(struct task_gro
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
@@ -8325,7 +8292,6 @@ static DEFINE_MUTEX(shares_mutex);
 int sched_group_set_shares(struct task_group *tg, unsigned long shares)
 {
 	int i;
-	unsigned long flags;
 
 	/*
 	 * We can't change the weight of the root cgroup.
@@ -8342,19 +8308,6 @@ int sched_group_set_shares(struct task_g
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
@@ -8363,15 +8316,6 @@ int sched_group_set_shares(struct task_g
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
Index: kernel/sched_fair.c
===================================================================
--- kernel/sched_fair.c.orig
+++ kernel/sched_fair.c
@@ -143,6 +143,24 @@ static inline struct cfs_rq *cpu_cfs_rq(
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
@@ -246,6 +264,14 @@ static inline struct cfs_rq *cpu_cfs_rq(
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
 
@@ -648,7 +674,7 @@ account_entity_dequeue(struct cfs_rq *cf
 }
 
 #if defined CONFIG_SMP && defined CONFIG_FAIR_GROUP_SCHED
-static void update_cfs_load(struct cfs_rq *cfs_rq)
+static void update_cfs_load(struct cfs_rq *cfs_rq, int lb)
 {
 	u64 period = sched_avg_period();
 	u64 now, delta;
@@ -673,6 +699,11 @@ static void update_cfs_load(struct cfs_r
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
@@ -719,7 +750,7 @@ static void update_cfs_shares(struct cfs
 	reweight_entity(cfs_rq_of(se), se, shares);
 }
 #else /* CONFIG_FAIR_GROUP_SCHED */
-static inline void update_cfs_load(struct cfs_rq *cfs_rq)
+static inline void update_cfs_load(struct cfs_rq *cfs_rq, int lb)
 {
 }
 
@@ -849,7 +880,7 @@ enqueue_entity(struct cfs_rq *cfs_rq, st
 	 * Update run-time statistics of the 'current'.
 	 */
 	update_curr(cfs_rq);
-	update_cfs_load(cfs_rq);
+	update_cfs_load(cfs_rq, 0);
 	account_entity_enqueue(cfs_rq, se);
 	update_cfs_shares(group_cfs_rq(se));
 
@@ -863,6 +894,9 @@ enqueue_entity(struct cfs_rq *cfs_rq, st
 	if (se != cfs_rq->curr)
 		__enqueue_entity(cfs_rq, se);
 	se->on_rq = 1;
+
+	if (cfs_rq->nr_running == 1)
+		list_add_leaf_cfs_rq(cfs_rq);
 }
 
 static void __clear_buddies(struct cfs_rq *cfs_rq, struct sched_entity *se)
@@ -907,7 +941,7 @@ dequeue_entity(struct cfs_rq *cfs_rq, st
 	if (se != cfs_rq->curr)
 		__dequeue_entity(cfs_rq, se);
 	se->on_rq = 0;
-	update_cfs_load(cfs_rq);
+	update_cfs_load(cfs_rq, 0);
 	account_entity_dequeue(cfs_rq, se);
 	update_min_vruntime(cfs_rq);
 	update_cfs_shares(group_cfs_rq(se));
@@ -1142,7 +1176,7 @@ enqueue_task_fair(struct rq *rq, struct 
 	for_each_sched_entity(se) {
 		struct cfs_rq *cfs_rq = group_cfs_rq(se);
 
-		update_cfs_load(cfs_rq);
+		update_cfs_load(cfs_rq, 0);
 		update_cfs_shares(cfs_rq);
 	}
 
@@ -1172,7 +1206,7 @@ static void dequeue_task_fair(struct rq 
 	for_each_sched_entity(se) {
 		struct cfs_rq *cfs_rq = group_cfs_rq(se);
 
-		update_cfs_load(cfs_rq);
+		update_cfs_load(cfs_rq, 0);
 		update_cfs_shares(cfs_rq);
 	}
 
Index: kernel/sched_rt.c
===================================================================
--- kernel/sched_rt.c.orig
+++ kernel/sched_rt.c
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

-- 

