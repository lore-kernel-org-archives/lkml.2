Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758463Ab1BPDUw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 22:20:52 -0500
Received: from smtp-out.google.com ([216.239.44.51]:52429 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756466Ab1BPDUM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 22:20:12 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:user-agent:date:from:to:cc:subject:references:content-disposition;
	b=h7wyra5eMVBBOSumdnvn9wNuzBB1fEoApf9abnV2xFKGsGLHyQJh+G3c/xLKwYIZ3
	9CZWt1q3I66fEi31csCqg==
Message-Id: <20110216031840.878320737@google.com>
User-Agent: quilt/0.48-1
Date: Tue, 15 Feb 2011 19:18:32 -0800
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
Subject: [CFS Bandwidth Control v4 1/7] sched: introduce primitives to account for CFS bandwidth tracking
References: <20110216031831.571628191@google.com>
Content-Disposition: inline; filename=sched-bwc-add_cfs_tg_bandwidth.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In this patch we introduce the notion of CFS bandwidth, to account for the
realities of SMP this is partitioned into globally unassigned bandwidth, and
locally claimed bandwidth:
- The global bandwidth is per task_group, it represents a pool of unclaimed
  bandwidth that cfs_rq's can allocate from.  It uses the new cfs_bandwidth
  structure.
- The local bandwidth is tracked per-cfs_rq, this represents allotments from
  the global pool
  bandwidth assigned to a task_group, this is tracked using the
  new cfs_bandwidth structure.

Bandwidth is managed via cgroupfs via two new files in the cpu subsystem:
- cpu.cfs_period_us : the bandwidth period in usecs
- cpu.cfs_quota_us : the cpu bandwidth (in usecs) that this tg will be allowed
  to consume over period above.

A per-cfs_bandwidth timer is also introduced to handle future refresh at
period expiration.  There's some minor refactoring here so that
start_bandwidth_timer() functionality can be shared

Signed-off-by: Paul Turner <pjt@google.com>
Signed-off-by: Nikhil Rao <ncrao@google.com>
Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
---
 init/Kconfig        |    9 +
 kernel/sched.c      |  264 +++++++++++++++++++++++++++++++++++++++++++++++-----
 kernel/sched_fair.c |   19 +++
 3 files changed, 269 insertions(+), 23 deletions(-)

Index: tip/init/Kconfig
===================================================================
--- tip.orig/init/Kconfig
+++ tip/init/Kconfig
@@ -698,6 +698,15 @@ config FAIR_GROUP_SCHED
 	depends on CGROUP_SCHED
 	default CGROUP_SCHED
 
+config CFS_BANDWIDTH
+	bool "CPU bandwidth provisioning for FAIR_GROUP_SCHED"
+	depends on EXPERIMENTAL
+	depends on FAIR_GROUP_SCHED
+	default n
+	help
+	  This option allows users to define quota and period for cpu
+	  bandwidth provisioning on a per-cgroup basis.
+
 config RT_GROUP_SCHED
 	bool "Group scheduling for SCHED_RR/FIFO"
 	depends on EXPERIMENTAL
Index: tip/kernel/sched.c
===================================================================
--- tip.orig/kernel/sched.c
+++ tip/kernel/sched.c
@@ -194,10 +194,28 @@ static inline int rt_bandwidth_enabled(v
 	return sysctl_sched_rt_runtime >= 0;
 }
 
-static void start_rt_bandwidth(struct rt_bandwidth *rt_b)
+static void start_bandwidth_timer(struct hrtimer *period_timer, ktime_t period)
 {
-	ktime_t now;
+	unsigned long delta;
+	ktime_t soft, hard, now;
+
+	for (;;) {
+		if (hrtimer_active(period_timer))
+			break;
 
+		now = hrtimer_cb_get_time(period_timer);
+		hrtimer_forward(period_timer, now, period);
+
+		soft = hrtimer_get_softexpires(period_timer);
+		hard = hrtimer_get_expires(period_timer);
+		delta = ktime_to_ns(ktime_sub(hard, soft));
+		__hrtimer_start_range_ns(period_timer, soft, delta,
+					 HRTIMER_MODE_ABS_PINNED, 0);
+	}
+}
+
+static void start_rt_bandwidth(struct rt_bandwidth *rt_b)
+{
 	if (!rt_bandwidth_enabled() || rt_b->rt_runtime == RUNTIME_INF)
 		return;
 
@@ -205,22 +223,7 @@ static void start_rt_bandwidth(struct rt
 		return;
 
 	raw_spin_lock(&rt_b->rt_runtime_lock);
-	for (;;) {
-		unsigned long delta;
-		ktime_t soft, hard;
-
-		if (hrtimer_active(&rt_b->rt_period_timer))
-			break;
-
-		now = hrtimer_cb_get_time(&rt_b->rt_period_timer);
-		hrtimer_forward(&rt_b->rt_period_timer, now, rt_b->rt_period);
-
-		soft = hrtimer_get_softexpires(&rt_b->rt_period_timer);
-		hard = hrtimer_get_expires(&rt_b->rt_period_timer);
-		delta = ktime_to_ns(ktime_sub(hard, soft));
-		__hrtimer_start_range_ns(&rt_b->rt_period_timer, soft, delta,
-				HRTIMER_MODE_ABS_PINNED, 0);
-	}
+	start_bandwidth_timer(&rt_b->rt_period_timer, rt_b->rt_period);
 	raw_spin_unlock(&rt_b->rt_runtime_lock);
 }
 
@@ -245,6 +248,15 @@ struct cfs_rq;
 
 static LIST_HEAD(task_groups);
 
+#ifdef CONFIG_CFS_BANDWIDTH
+struct cfs_bandwidth {
+	raw_spinlock_t		lock;
+	ktime_t			period;
+	u64			runtime, quota;
+	struct hrtimer		period_timer;
+};
+#endif
+
 /* task group related information */
 struct task_group {
 	struct cgroup_subsys_state css;
@@ -276,6 +288,10 @@ struct task_group {
 #ifdef CONFIG_SCHED_AUTOGROUP
 	struct autogroup *autogroup;
 #endif
+
+#ifdef CONFIG_CFS_BANDWIDTH
+	struct cfs_bandwidth cfs_bandwidth;
+#endif
 };
 
 /* task_group_lock serializes the addition/removal of task groups */
@@ -370,9 +386,76 @@ struct cfs_rq {
 
 	unsigned long load_contribution;
 #endif
+#ifdef CONFIG_CFS_BANDWIDTH
+	u64 quota_assigned, quota_used;
+#endif
 #endif
 };
 
+#ifdef CONFIG_CFS_BANDWIDTH
+static int do_sched_cfs_period_timer(struct cfs_bandwidth *cfs_b, int overrun);
+
+static enum hrtimer_restart sched_cfs_period_timer(struct hrtimer *timer)
+{
+	struct cfs_bandwidth *cfs_b =
+		container_of(timer, struct cfs_bandwidth, period_timer);
+	ktime_t now;
+	int overrun;
+	int idle = 0;
+
+	for (;;) {
+		now = hrtimer_cb_get_time(timer);
+		overrun = hrtimer_forward(timer, now, cfs_b->period);
+
+		if (!overrun)
+			break;
+
+		idle = do_sched_cfs_period_timer(cfs_b, overrun);
+	}
+
+	return idle ? HRTIMER_NORESTART : HRTIMER_RESTART;
+}
+
+static
+void init_cfs_bandwidth(struct cfs_bandwidth *cfs_b, u64 quota, u64 period)
+{
+	raw_spin_lock_init(&cfs_b->lock);
+	cfs_b->quota = cfs_b->runtime = quota;
+	cfs_b->period = ns_to_ktime(period);
+
+	hrtimer_init(&cfs_b->period_timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+	cfs_b->period_timer.function = sched_cfs_period_timer;
+}
+
+static
+void init_cfs_rq_quota(struct cfs_rq *cfs_rq)
+{
+	cfs_rq->quota_used = 0;
+	if (cfs_rq->tg->cfs_bandwidth.quota == RUNTIME_INF)
+		cfs_rq->quota_assigned = RUNTIME_INF;
+	else
+		cfs_rq->quota_assigned = 0;
+}
+
+static void start_cfs_bandwidth(struct cfs_bandwidth *cfs_b)
+{
+	if (cfs_b->quota == RUNTIME_INF)
+		return;
+
+	if (hrtimer_active(&cfs_b->period_timer))
+		return;
+
+	raw_spin_lock(&cfs_b->lock);
+	start_bandwidth_timer(&cfs_b->period_timer, cfs_b->period);
+	raw_spin_unlock(&cfs_b->lock);
+}
+
+static void destroy_cfs_bandwidth(struct cfs_bandwidth *cfs_b)
+{
+	hrtimer_cancel(&cfs_b->period_timer);
+}
+#endif
+
 /* Real-Time classes' related field in a runqueue: */
 struct rt_rq {
 	struct rt_prio_array active;
@@ -8038,6 +8121,9 @@ static void init_tg_cfs_entry(struct tas
 	tg->cfs_rq[cpu] = cfs_rq;
 	init_cfs_rq(cfs_rq, rq);
 	cfs_rq->tg = tg;
+#ifdef CONFIG_CFS_BANDWIDTH
+	init_cfs_rq_quota(cfs_rq);
+#endif
 
 	tg->se[cpu] = se;
 	/* se could be NULL for root_task_group */
@@ -8173,6 +8259,10 @@ void __init sched_init(void)
 		 * We achieve this by letting root_task_group's tasks sit
 		 * directly in rq->cfs (i.e root_task_group->se[] = NULL).
 		 */
+#ifdef CONFIG_CFS_BANDWIDTH
+		init_cfs_bandwidth(&root_task_group.cfs_bandwidth,
+				RUNTIME_INF, sched_cfs_bandwidth_period);
+#endif
 		init_tg_cfs_entry(&root_task_group, &rq->cfs, NULL, i, NULL);
 #endif /* CONFIG_FAIR_GROUP_SCHED */
 
@@ -8415,6 +8505,10 @@ static void free_fair_sched_group(struct
 {
 	int i;
 
+#ifdef CONFIG_CFS_BANDWIDTH
+	destroy_cfs_bandwidth(&tg->cfs_bandwidth);
+#endif
+
 	for_each_possible_cpu(i) {
 		if (tg->cfs_rq)
 			kfree(tg->cfs_rq[i]);
@@ -8442,7 +8536,10 @@ int alloc_fair_sched_group(struct task_g
 		goto err;
 
 	tg->shares = NICE_0_LOAD;
-
+#ifdef CONFIG_CFS_BANDWIDTH
+	init_cfs_bandwidth(&tg->cfs_bandwidth, RUNTIME_INF,
+			sched_cfs_bandwidth_period);
+#endif
 	for_each_possible_cpu(i) {
 		rq = cpu_rq(i);
 
@@ -8822,7 +8919,7 @@ static int __rt_schedulable(struct task_
 	return walk_tg_tree(tg_schedulable, tg_nop, &data);
 }
 
-static int tg_set_bandwidth(struct task_group *tg,
+static int tg_set_rt_bandwidth(struct task_group *tg,
 		u64 rt_period, u64 rt_runtime)
 {
 	int i, err = 0;
@@ -8861,7 +8958,7 @@ int sched_group_set_rt_runtime(struct ta
 	if (rt_runtime_us < 0)
 		rt_runtime = RUNTIME_INF;
 
-	return tg_set_bandwidth(tg, rt_period, rt_runtime);
+	return tg_set_rt_bandwidth(tg, rt_period, rt_runtime);
 }
 
 long sched_group_rt_runtime(struct task_group *tg)
@@ -8886,7 +8983,7 @@ int sched_group_set_rt_period(struct tas
 	if (rt_period == 0)
 		return -EINVAL;
 
-	return tg_set_bandwidth(tg, rt_period, rt_runtime);
+	return tg_set_rt_bandwidth(tg, rt_period, rt_runtime);
 }
 
 long sched_group_rt_period(struct task_group *tg)
@@ -9107,6 +9204,116 @@ static u64 cpu_shares_read_u64(struct cg
 
 	return (u64) tg->shares;
 }
+
+#ifdef CONFIG_CFS_BANDWIDTH
+static int tg_set_cfs_bandwidth(struct task_group *tg, u64 period, u64 quota)
+{
+	int i;
+	static DEFINE_MUTEX(mutex);
+
+	if (tg == &root_task_group)
+		return -EINVAL;
+
+	if (!period)
+		return -EINVAL;
+
+	/*
+	 * Ensure we have at least one tick of bandwidth every period.  This is
+	 * to prevent reaching a state of large arrears when throttled via
+	 * entity_tick() resulting in prolonged exit starvation.
+	 */
+	if (NS_TO_JIFFIES(quota) < 1)
+		return -EINVAL;
+
+	mutex_lock(&mutex);
+	raw_spin_lock_irq(&tg->cfs_bandwidth.lock);
+	tg->cfs_bandwidth.period = ns_to_ktime(period);
+	tg->cfs_bandwidth.runtime = tg->cfs_bandwidth.quota = quota;
+	raw_spin_unlock_irq(&tg->cfs_bandwidth.lock);
+
+	for_each_possible_cpu(i) {
+		struct cfs_rq *cfs_rq = tg->cfs_rq[i];
+		struct rq *rq = rq_of(cfs_rq);
+
+		raw_spin_lock_irq(&rq->lock);
+		init_cfs_rq_quota(cfs_rq);
+		raw_spin_unlock_irq(&rq->lock);
+	}
+	mutex_unlock(&mutex);
+
+	return 0;
+}
+
+int tg_set_cfs_quota(struct task_group *tg, long cfs_runtime_us)
+{
+	u64 quota, period;
+
+	period = ktime_to_ns(tg->cfs_bandwidth.period);
+	if (cfs_runtime_us < 0)
+		quota = RUNTIME_INF;
+	else
+		quota = (u64)cfs_runtime_us * NSEC_PER_USEC;
+
+	return tg_set_cfs_bandwidth(tg, period, quota);
+}
+
+long tg_get_cfs_quota(struct task_group *tg)
+{
+	u64 quota_us;
+
+	if (tg->cfs_bandwidth.quota == RUNTIME_INF)
+		return -1;
+
+	quota_us = tg->cfs_bandwidth.quota;
+	do_div(quota_us, NSEC_PER_USEC);
+	return quota_us;
+}
+
+int tg_set_cfs_period(struct task_group *tg, long cfs_period_us)
+{
+	u64 quota, period;
+
+	period = (u64)cfs_period_us * NSEC_PER_USEC;
+	quota = tg->cfs_bandwidth.quota;
+
+	if (period <= 0)
+		return -EINVAL;
+
+	return tg_set_cfs_bandwidth(tg, period, quota);
+}
+
+long tg_get_cfs_period(struct task_group *tg)
+{
+	u64 cfs_period_us;
+
+	cfs_period_us = ktime_to_ns(tg->cfs_bandwidth.period);
+	do_div(cfs_period_us, NSEC_PER_USEC);
+	return cfs_period_us;
+}
+
+static s64 cpu_cfs_quota_read_s64(struct cgroup *cgrp, struct cftype *cft)
+{
+	return tg_get_cfs_quota(cgroup_tg(cgrp));
+}
+
+static int cpu_cfs_quota_write_s64(struct cgroup *cgrp, struct cftype *cftype,
+				s64 cfs_quota_us)
+{
+	return tg_set_cfs_quota(cgroup_tg(cgrp), cfs_quota_us);
+}
+
+static u64 cpu_cfs_period_read_u64(struct cgroup *cgrp, struct cftype *cft)
+{
+	return tg_get_cfs_period(cgroup_tg(cgrp));
+}
+
+static int cpu_cfs_period_write_u64(struct cgroup *cgrp, struct cftype *cftype,
+				u64 cfs_period_us)
+{
+	return tg_set_cfs_period(cgroup_tg(cgrp), cfs_period_us);
+}
+
+#endif /* CONFIG_CFS_BANDWIDTH */
 #endif /* CONFIG_FAIR_GROUP_SCHED */
 
 #ifdef CONFIG_RT_GROUP_SCHED
@@ -9141,6 +9348,18 @@ static struct cftype cpu_files[] = {
 		.write_u64 = cpu_shares_write_u64,
 	},
 #endif
+#ifdef CONFIG_CFS_BANDWIDTH
+	{
+		.name = "cfs_quota_us",
+		.read_s64 = cpu_cfs_quota_read_s64,
+		.write_s64 = cpu_cfs_quota_write_s64,
+	},
+	{
+		.name = "cfs_period_us",
+		.read_u64 = cpu_cfs_period_read_u64,
+		.write_u64 = cpu_cfs_period_write_u64,
+	},
+#endif
 #ifdef CONFIG_RT_GROUP_SCHED
 	{
 		.name = "rt_runtime_us",
@@ -9450,4 +9669,3 @@ struct cgroup_subsys cpuacct_subsys = {
 	.subsys_id = cpuacct_subsys_id,
 };
 #endif	/* CONFIG_CGROUP_CPUACCT */
-
Index: tip/kernel/sched_fair.c
===================================================================
--- tip.orig/kernel/sched_fair.c
+++ tip/kernel/sched_fair.c
@@ -88,6 +88,15 @@ const_debug unsigned int sysctl_sched_mi
  */
 unsigned int __read_mostly sysctl_sched_shares_window = 10000000UL;
 
+
+#ifdef CONFIG_CFS_BANDWIDTH
+/*
+ * default period for cfs group bandwidth.
+ * default: 0.5s, units: nanoseconds
+ */
+static u64 sched_cfs_bandwidth_period = 500000000ULL;
+#endif
+
 static const struct sched_class fair_sched_class;
 
 /**************************************************************
@@ -397,6 +406,9 @@ static void __enqueue_entity(struct cfs_
 
 	rb_link_node(&se->run_node, parent, link);
 	rb_insert_color(&se->run_node, &cfs_rq->tasks_timeline);
+#ifdef CONFIG_CFS_BANDWIDTH
+	start_cfs_bandwidth(&cfs_rq->tg->cfs_bandwidth);
+#endif
 }
 
 static void __dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se)
@@ -1369,6 +1381,13 @@ static void dequeue_task_fair(struct rq 
 	hrtick_update(rq);
 }
 
+#ifdef CONFIG_CFS_BANDWIDTH
+static int do_sched_cfs_period_timer(struct cfs_bandwidth *cfs_b, int overrun)
+{
+	return 1;
+}
+#endif
+
 #ifdef CONFIG_SMP
 
 static void task_waking_fair(struct rq *rq, struct task_struct *p)


