Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758036Ab1BPDUh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 22:20:37 -0500
Received: from smtp-out.google.com ([74.125.121.67]:29605 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756301Ab1BPDUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 22:20:10 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:user-agent:date:from:to:cc:subject:references:content-disposition;
	b=C3ZdpfTAR0i8DZZSlO/sZaz+IFrFPP1DvXFRPkNTLdJyS1DOb38wxxp2c0ouxAwtv
	mH/U/ITO+8B5ZcwQmlGyw==
Message-Id: <20110216031841.161743484@google.com>
User-Agent: quilt/0.48-1
Date: Tue, 15 Feb 2011 19:18:35 -0800
From: Paul Turner <pjt@google.com>
To: linux-kernel@vger.kernel.org
Cc: Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval@linux.vnet.ibm.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Gautham R Shenoy <ego@in.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Pavel Emelyanov <xemul@openvz.org>,
        Herbert Poetzl <herbert@13thfloor.at>, Avi Kivity <avi@redhat.com>,
        Chris Friesen <cfriesen@nortel.com>, Nikhil Rao <ncrao@google.com>
Subject: [CFS Bandwidth Control v4 4/7] sched: unthrottle cfs_rq(s) who ran out of quota at period refresh
References: <20110216031831.571628191@google.com>
Content-Disposition: inline; filename=sched-bwc-unthrottle_entities.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At the start of a new period there are several actions we must take:
- Refresh global bandwidth pool
- Unthrottle entities who ran out of quota as refreshed bandwidth permits

Unthrottled entities have the cfs_rq->throttled flag set and are re-enqueued
into the cfs entity hierarchy.

sched_rt_period_mask() is refactored slightly into sched_bw_period_mask()
since it is now shared by both cfs and rt bandwidth period timers.

The !CONFIG_RT_GROUP_SCHED && CONFIG_SMP case has been collapsed to use
rd->span instead of cpu_online_mask since I think that was incorrect before
(don't want to hit cpu's outside of your root_domain for RT bandwidth).

Signed-off-by: Paul Turner <pjt@google.com>
Signed-off-by: Nikhil Rao <ncrao@google.com>
Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
---
 kernel/sched.c      |   16 +++++++++++
 kernel/sched_fair.c |   74 +++++++++++++++++++++++++++++++++++++++++++++++++++-
 kernel/sched_rt.c   |   19 -------------
 3 files changed, 90 insertions(+), 19 deletions(-)

Index: tip/kernel/sched.c
===================================================================
--- tip.orig/kernel/sched.c
+++ tip/kernel/sched.c
@@ -1561,6 +1561,8 @@ static int tg_nop(struct task_group *tg,
 }
 #endif
 
+static inline const struct cpumask *sched_bw_period_mask(void);
+
 #ifdef CONFIG_SMP
 /* Used instead of source_load when we know the type == 0 */
 static unsigned long weighted_cpuload(const int cpu)
@@ -8503,6 +8505,18 @@ void set_curr_task(int cpu, struct task_
 
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
@@ -9240,6 +9254,8 @@ static int tg_set_cfs_bandwidth(struct t
 
 		raw_spin_lock_irq(&rq->lock);
 		init_cfs_rq_quota(cfs_rq);
+		if (cfs_rq_throttled(cfs_rq))
+			unthrottle_cfs_rq(cfs_rq);
 		raw_spin_unlock_irq(&rq->lock);
 	}
 	mutex_unlock(&mutex);
Index: tip/kernel/sched_fair.c
===================================================================
--- tip.orig/kernel/sched_fair.c
+++ tip/kernel/sched_fair.c
@@ -327,6 +327,13 @@ static inline u64 sched_cfs_bandwidth_sl
 	return (u64)sysctl_sched_cfs_bandwidth_slice * NSEC_PER_USEC;
 }
 
+static inline
+struct cfs_rq *cfs_bandwidth_cfs_rq(struct cfs_bandwidth *cfs_b, int cpu)
+{
+	return container_of(cfs_b, struct task_group,
+			cfs_bandwidth)->cfs_rq[cpu];
+}
+
 static inline struct cfs_bandwidth *tg_cfs_bandwidth(struct task_group *tg)
 {
 	return &tg->cfs_bandwidth;
@@ -1513,6 +1520,33 @@ out_throttled:
 	update_cfs_rq_load_contribution(cfs_rq, 1);
 }
 
+static void unthrottle_cfs_rq(struct cfs_rq *cfs_rq)
+{
+	struct rq *rq = rq_of(cfs_rq);
+	struct sched_entity *se;
+
+	se = cfs_rq->tg->se[cpu_of(rq_of(cfs_rq))];
+
+	update_rq_clock(rq);
+	/* (Try to) avoid maintaining share statistics for idle time */
+	cfs_rq->load_stamp = cfs_rq->load_last = rq->clock_task;
+
+	cfs_rq->throttled = 0;
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
+	/* determine whether we need to wake up potentally idle cpu */
+	if (rq->curr == rq->idle && rq->cfs.nr_running)
+		resched_task(rq->curr);
+}
+
 static void account_cfs_rq_quota(struct cfs_rq *cfs_rq,
 		unsigned long delta_exec)
 {
@@ -1535,8 +1569,46 @@ static void account_cfs_rq_quota(struct 
 
 static int do_sched_cfs_period_timer(struct cfs_bandwidth *cfs_b, int overrun)
 {
-	return 1;
+	int i, idle = 1;
+	u64 delta;
+	const struct cpumask *span;
+
+	if (cfs_b->quota == RUNTIME_INF)
+		return 1;
+
+	/* reset group quota */
+	raw_spin_lock(&cfs_b->lock);
+	cfs_b->runtime = cfs_b->quota;
+	raw_spin_unlock(&cfs_b->lock);
+
+	span = sched_bw_period_mask();
+	for_each_cpu(i, span) {
+		struct rq *rq = cpu_rq(i);
+		struct cfs_rq *cfs_rq = cfs_bandwidth_cfs_rq(cfs_b, i);
+
+		if (cfs_rq->nr_running)
+			idle = 0;
+
+		if (!cfs_rq_throttled(cfs_rq))
+			continue;
+
+		delta = tg_request_cfs_quota(cfs_rq->tg);
+
+		if (delta) {
+			raw_spin_lock(&rq->lock);
+			cfs_rq->quota_assigned += delta;
+
+			/* avoid race with tg_set_cfs_bandwidth */
+			if (cfs_rq_throttled(cfs_rq) &&
+			     cfs_rq->quota_used < cfs_rq->quota_assigned)
+				unthrottle_cfs_rq(cfs_rq);
+			raw_spin_unlock(&rq->lock);
+		}
+	}
+
+	return idle;
 }
+
 #endif
 
 #ifdef CONFIG_SMP
Index: tip/kernel/sched_rt.c
===================================================================
--- tip.orig/kernel/sched_rt.c
+++ tip/kernel/sched_rt.c
@@ -252,18 +252,6 @@ static int rt_se_boosted(struct sched_rt
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
@@ -321,11 +309,6 @@ static inline int rt_rq_throttled(struct
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
@@ -543,7 +526,7 @@ static int do_sched_rt_period_timer(stru
 	if (!rt_bandwidth_enabled() || rt_b->rt_runtime == RUNTIME_INF)
 		return 1;
 
-	span = sched_rt_period_mask();
+	span = sched_bw_period_mask();
 	for_each_cpu(i, span) {
 		int enqueue = 0;
 		struct rt_rq *rt_rq = sched_rt_period_rt_rq(rt_b, i);


