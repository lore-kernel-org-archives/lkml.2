Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755645Ab1CWDKl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 23:10:41 -0400
Received: from smtp-out.google.com ([216.239.44.51]:7748 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753732Ab1CWDKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 23:10:14 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:user-agent:date:from:to:cc:subject:references:content-disposition;
	b=l92tsvd88kf83yADrjdKy/ijG2EHAW00s/sPsGC7wVyeCqb8ZiJQsw8K8OYgiNnUj
	/D0AiPL/5FKr7Q7e2gGxQ==
Message-Id: <20110323030449.142198821@google.com>
User-Agent: quilt/0.48-1
Date: Tue, 22 Mar 2011 20:03:31 -0700
From: Paul Turner <pjt@google.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>,
        Nikhil Rao <ncrao@google.com>
Subject: [patch 05/15] sched: unthrottle cfs_rq(s) who ran out of quota at period refresh
References: <20110323030326.789836913@google.com>
Content-Disposition: inline; filename=sched-bwc-unthrottle_entities.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At the start of a new period there are several actions we must refresh the
global bandwidth pool as well as unthrottle any cfs_rq entities who previously
ran out of bandwidth (as quota permits).

Unthrottled entities have the cfs_rq->throttled flag cleared and are re-enqueued
into the cfs entity hierarchy.

sched_rt_period_mask() is refactored slightly into sched_bw_period_mask()
since it is now shared by both cfs and rt bandwidth period timers.

The !CONFIG_RT_GROUP_SCHED && CONFIG_SMP case has been collapsed to use
rd->span instead of cpu_online_mask since I think that was incorrect before
[don't actually want to hit cpu's outside of your root_domain for RT bandwidth.]

Signed-off-by: Paul Turner <pjt@google.com>
Signed-off-by: Nikhil Rao <ncrao@google.com>
Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
---
 kernel/sched.c      |   18 +++++++++-
 kernel/sched_fair.c |   92 +++++++++++++++++++++++++++++++++++++++++++++++++++-
 kernel/sched_rt.c   |   19 ----------
 3 files changed, 109 insertions(+), 20 deletions(-)

Index: tip/kernel/sched.c
===================================================================
--- tip.orig/kernel/sched.c
+++ tip/kernel/sched.c
@@ -252,7 +252,7 @@ struct cfs_bandwidth {
 #ifdef CONFIG_CFS_BANDWIDTH
 	raw_spinlock_t lock;
 	ktime_t period;
-	u64 runtime, quota;
+	u64 runtime, runtime_assigned, quota;
 	s64 hierarchal_quota; /* used for validating consistency */
 	struct hrtimer period_timer;
 #endif
@@ -1564,6 +1564,8 @@ static int tg_nop(struct task_group *tg,
 }
 #endif
 
+static inline const struct cpumask *sched_bw_period_mask(void);
+
 #ifdef CONFIG_SMP
 /* Used instead of source_load when we know the type == 0 */
 static unsigned long weighted_cpuload(const int cpu)
@@ -8514,6 +8516,18 @@ void set_curr_task(int cpu, struct task_
 
 #endif
 
+#ifdef CONFIG_SMP
+static inline const struct cpumask *sched_bw_period_mask(void)
+{
+	return cpu_rq(smp_processor_id())->rd->span;
+}
+#else
+static inline const struct cpumask *sched_bw_period_mask(void)
+{
+	return cpu_online_mask;
+}
+#endif
+
 #ifdef CONFIG_FAIR_GROUP_SCHED
 static void free_fair_sched_group(struct task_group *tg)
 {
@@ -9268,6 +9282,8 @@ static int tg_set_cfs_bandwidth(struct t
 
 		raw_spin_lock_irq(&rq->lock);
 		init_cfs_rq_quota(cfs_rq);
+		if (cfs_rq_throttled(cfs_rq))
+			unthrottle_cfs_rq(cfs_rq);
 		raw_spin_unlock_irq(&rq->lock);
 	}
 out_unlock:
Index: tip/kernel/sched_fair.c
===================================================================
--- tip.orig/kernel/sched_fair.c
+++ tip/kernel/sched_fair.c
@@ -1394,9 +1394,99 @@ static void throttle_cfs_rq(struct cfs_r
 	cfs_rq->throttled = 1;
 }
 
+static void unthrottle_cfs_rq(struct cfs_rq *cfs_rq)
+{
+	struct rq *rq = rq_of(cfs_rq);
+	struct sched_entity *se;
+
+	se = cfs_rq->tg->se[cpu_of(rq_of(cfs_rq))];
+
+	update_rq_clock(rq);
+
+	cfs_rq->throttled = 0;
+	if (!cfs_rq->load.weight)
+		return;
+
+	for_each_sched_entity(se) {
+		if (se->on_rq)
+			break;
+
+		cfs_rq = cfs_rq_of(se);
+		enqueue_entity(cfs_rq, se, ENQUEUE_WAKEUP);
+		if (cfs_rq_throttled(cfs_rq))
+			break;
+	}
+
+	/* determine whether we need to wake up potentially idle cpu */
+	if (rq->curr == rq->idle && rq->cfs.nr_running)
+		resched_task(rq->curr);
+}
+
+static inline struct task_group *cfs_bandwidth_tg(struct cfs_bandwidth *cfs_b)
+{
+	return container_of(cfs_b, struct task_group, cfs_bandwidth);
+}
+
+static u64 distribute_cfs_bandwidth(struct cfs_bandwidth *cfs_b, u64 runtime)
+{
+	int i;
+	u64 quota, remaining = runtime;
+	const struct cpumask *span;
+
+	rcu_read_lock();
+	span = sched_bw_period_mask();
+	for_each_cpu(i, span) {
+		struct rq *rq = cpu_rq(i);
+		struct cfs_rq *cfs_rq = cfs_bandwidth_tg(cfs_b)->cfs_rq[i];
+
+		raw_spin_lock(&rq->lock);
+		if (within_bandwidth(cfs_rq))
+			goto next;
+
+		quota = -cfs_rq->quota_remaining;
+		quota += sched_cfs_bandwidth_slice();
+		quota = min(quota, remaining);
+		remaining -= quota;
+
+		cfs_rq->quota_remaining += quota;
+		if (cfs_rq_throttled(cfs_rq) && cfs_rq->quota_remaining > 0)
+			unthrottle_cfs_rq(cfs_rq);
+
+next:
+		raw_spin_unlock(&rq->lock);
+
+		if (!remaining)
+			break;
+	}
+	rcu_read_unlock();
+
+	return remaining;
+}
+
 static int do_sched_cfs_period_timer(struct cfs_bandwidth *cfs_b, int overrun)
 {
-	return 1;
+	u64 runtime, runtime_assigned;
+	int idle;
+
+	raw_spin_lock(&cfs_b->lock);
+	runtime = cfs_b->quota;
+	idle = cfs_b->runtime == cfs_b->runtime_assigned;
+	raw_spin_unlock(&cfs_b->lock);
+
+	if (runtime == RUNTIME_INF)
+		return 1;
+
+	runtime *= overrun;
+	runtime_assigned = runtime;
+
+	runtime = distribute_cfs_bandwidth(cfs_b, runtime);
+
+	raw_spin_lock(&cfs_b->lock);
+	cfs_b->runtime = runtime;
+	cfs_b->runtime_assigned = runtime_assigned;
+	raw_spin_unlock(&cfs_b->lock);
+
+	return idle;
 }
 #else
 static inline u64 default_cfs_period(void)
Index: tip/kernel/sched_rt.c
===================================================================
--- tip.orig/kernel/sched_rt.c
+++ tip/kernel/sched_rt.c
@@ -253,18 +253,6 @@ static int rt_se_boosted(struct sched_rt
 	return p->prio != p->normal_prio;
 }
 
-#ifdef CONFIG_SMP
-static inline const struct cpumask *sched_rt_period_mask(void)
-{
-	return cpu_rq(smp_processor_id())->rd->span;
-}
-#else
-static inline const struct cpumask *sched_rt_period_mask(void)
-{
-	return cpu_online_mask;
-}
-#endif
-
 static inline
 struct rt_rq *sched_rt_period_rt_rq(struct rt_bandwidth *rt_b, int cpu)
 {
@@ -322,11 +310,6 @@ static inline int rt_rq_throttled(struct
 	return rt_rq->rt_throttled;
 }
 
-static inline const struct cpumask *sched_rt_period_mask(void)
-{
-	return cpu_online_mask;
-}
-
 static inline
 struct rt_rq *sched_rt_period_rt_rq(struct rt_bandwidth *rt_b, int cpu)
 {
@@ -544,7 +527,7 @@ static int do_sched_rt_period_timer(stru
 	if (!rt_bandwidth_enabled() || rt_b->rt_runtime == RUNTIME_INF)
 		return 1;
 
-	span = sched_rt_period_mask();
+	span = sched_bw_period_mask();
 	for_each_cpu(i, span) {
 		int enqueue = 0;
 		struct rt_rq *rt_rq = sched_rt_period_rt_rq(rt_b, i);


