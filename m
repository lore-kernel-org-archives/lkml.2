Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754283Ab1EGGe7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 May 2011 02:34:59 -0400
Received: from smtp-out.google.com ([74.125.121.67]:50489 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753463Ab1EGGcn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 May 2011 02:32:43 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:user-agent:date:from:to:cc:subject:references:content-disposition;
	b=bDMKArYDcqf5Djkf1ZPptpRJnSWDOIbVHm0JWUH22zzbIEtbUK5SOwa9fguvLBl9W
	kliKNZekaA0+o37OKvb5g==
Message-Id: <20110503092904.720703305@google.com>
User-Agent: quilt/0.48-1
Date: Tue, 03 May 2011 02:28:49 -0700
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
Subject: [patch 03/15] sched: introduce primitives to account for CFS bandwidth tracking
References: <20110503092846.022272244@google.com>
Content-Disposition: inline; filename=sched-bwc-add_cfs_tg_bandwidth.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In this patch we introduce the notion of CFS bandwidth, partitioned into 
globally unassigned bandwidth, and locally claimed bandwidth.

- The global bandwidth is per task_group, it represents a pool of unclaimed
  bandwidth that cfs_rqs can allocate from.  
- The local bandwidth is tracked per-cfs_rq, this represents allotments from
  the global pool bandwidth assigned to a specific cpu.

Bandwidth is managed via cgroupfs, adding two new interfaces to the cpu subsystem:
- cpu.cfs_period_us : the bandwidth period in usecs
- cpu.cfs_quota_us : the cpu bandwidth (in usecs) that this tg will be allowed
  to consume over period above.

Signed-off-by: Paul Turner <pjt@google.com>
Signed-off-by: Nikhil Rao <ncrao@google.com>
Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
---
 init/Kconfig        |   12 +++
 kernel/sched.c      |  193 ++++++++++++++++++++++++++++++++++++++++++++++++++--
 kernel/sched_fair.c |   16 ++++
 3 files changed, 217 insertions(+), 4 deletions(-)

Index: tip/init/Kconfig
===================================================================
--- tip.orig/init/Kconfig
+++ tip/init/Kconfig
@@ -715,6 +715,18 @@ config FAIR_GROUP_SCHED
 	depends on CGROUP_SCHED
 	default CGROUP_SCHED
 
+config CFS_BANDWIDTH
+	bool "CPU bandwidth provisioning for FAIR_GROUP_SCHED"
+	depends on EXPERIMENTAL
+	depends on FAIR_GROUP_SCHED
+	default n
+	help
+	  This option allows users to define CPU bandwidth rates (limits) for
+	  tasks running within the fair group scheduler.  Groups with no limit
+	  set are considered to be unconstrained and will run with no
+	  restriction.
+	  See tip/Documentation/scheduler/sched-bwc.txt for more information/
+
 config RT_GROUP_SCHED
 	bool "Group scheduling for SCHED_RR/FIFO"
 	depends on EXPERIMENTAL
Index: tip/kernel/sched.c
===================================================================
--- tip.orig/kernel/sched.c
+++ tip/kernel/sched.c
@@ -244,6 +244,14 @@ struct cfs_rq;
 
 static LIST_HEAD(task_groups);
 
+struct cfs_bandwidth {
+#ifdef CONFIG_CFS_BANDWIDTH
+	raw_spinlock_t lock;
+	ktime_t period;
+	u64 quota;
+#endif
+};
+
 /* task group related information */
 struct task_group {
 	struct cgroup_subsys_state css;
@@ -275,6 +283,8 @@ struct task_group {
 #ifdef CONFIG_SCHED_AUTOGROUP
 	struct autogroup *autogroup;
 #endif
+
+	struct cfs_bandwidth cfs_bandwidth;
 };
 
 /* task_group_lock serializes the addition/removal of task groups */
@@ -369,9 +379,45 @@ struct cfs_rq {
 
 	unsigned long load_contribution;
 #endif
+#ifdef CONFIG_CFS_BANDWIDTH
+	int runtime_enabled;
+	s64 runtime_remaining;
+#endif
 #endif
 };
 
+#ifdef CONFIG_CFS_BANDWIDTH
+static inline struct cfs_bandwidth *tg_cfs_bandwidth(struct task_group *tg)
+{
+	return &tg->cfs_bandwidth;
+}
+
+static inline u64 default_cfs_period(void);
+
+static void init_cfs_bandwidth(struct cfs_bandwidth *cfs_b)
+{
+	raw_spin_lock_init(&cfs_b->lock);
+	cfs_b->quota = RUNTIME_INF;
+	cfs_b->period = ns_to_ktime(default_cfs_period());
+}
+
+static void init_cfs_rq_runtime(struct cfs_rq *cfs_rq)
+{
+	cfs_rq->runtime_remaining = 0;
+	cfs_rq->runtime_enabled = 0;
+}
+
+static void destroy_cfs_bandwidth(struct cfs_bandwidth *cfs_b)
+{}
+#else
+#ifdef CONFIG_FAIR_GROUP_SCHED
+static void init_cfs_rq_runtime(struct cfs_rq *cfs_rq) {}
+void init_cfs_bandwidth(struct cfs_bandwidth *cfs_b) {}
+static void destroy_cfs_bandwidth(struct cfs_bandwidth *cfs_b) {}
+#endif /* CONFIG_FAIR_GROUP_SCHED */
+static void start_cfs_bandwidth(struct cfs_rq *cfs_rq) {}
+#endif /* CONFIG_CFS_BANDWIDTH */
+
 /* Real-Time classes' related field in a runqueue: */
 struct rt_rq {
 	struct rt_prio_array active;
@@ -8056,6 +8102,7 @@ static void init_tg_cfs_entry(struct tas
 	tg->cfs_rq[cpu] = cfs_rq;
 	init_cfs_rq(cfs_rq, rq);
 	cfs_rq->tg = tg;
+	init_cfs_rq_runtime(cfs_rq);
 
 	tg->se[cpu] = se;
 	/* se could be NULL for root_task_group */
@@ -8191,6 +8238,7 @@ void __init sched_init(void)
 		 * We achieve this by letting root_task_group's tasks sit
 		 * directly in rq->cfs (i.e root_task_group->se[] = NULL).
 		 */
+		init_cfs_bandwidth(&root_task_group.cfs_bandwidth);
 		init_tg_cfs_entry(&root_task_group, &rq->cfs, NULL, i, NULL);
 #endif /* CONFIG_FAIR_GROUP_SCHED */
 
@@ -8433,6 +8481,8 @@ static void free_fair_sched_group(struct
 {
 	int i;
 
+	destroy_cfs_bandwidth(tg_cfs_bandwidth(tg));
+
 	for_each_possible_cpu(i) {
 		if (tg->cfs_rq)
 			kfree(tg->cfs_rq[i]);
@@ -8460,6 +8510,8 @@ int alloc_fair_sched_group(struct task_g
 
 	tg->shares = NICE_0_LOAD;
 
+	init_cfs_bandwidth(tg_cfs_bandwidth(tg));
+
 	for_each_possible_cpu(i) {
 		cfs_rq = kzalloc_node(sizeof(struct cfs_rq),
 				      GFP_KERNEL, cpu_to_node(i));
@@ -8837,7 +8889,7 @@ static int __rt_schedulable(struct task_
 	return walk_tg_tree(tg_schedulable, tg_nop, &data);
 }
 
-static int tg_set_bandwidth(struct task_group *tg,
+static int tg_set_rt_bandwidth(struct task_group *tg,
 		u64 rt_period, u64 rt_runtime)
 {
 	int i, err = 0;
@@ -8876,7 +8928,7 @@ int sched_group_set_rt_runtime(struct ta
 	if (rt_runtime_us < 0)
 		rt_runtime = RUNTIME_INF;
 
-	return tg_set_bandwidth(tg, rt_period, rt_runtime);
+	return tg_set_rt_bandwidth(tg, rt_period, rt_runtime);
 }
 
 long sched_group_rt_runtime(struct task_group *tg)
@@ -8901,7 +8953,7 @@ int sched_group_set_rt_period(struct tas
 	if (rt_period == 0)
 		return -EINVAL;
 
-	return tg_set_bandwidth(tg, rt_period, rt_runtime);
+	return tg_set_rt_bandwidth(tg, rt_period, rt_runtime);
 }
 
 long sched_group_rt_period(struct task_group *tg)
@@ -9123,6 +9175,128 @@ static u64 cpu_shares_read_u64(struct cg
 
 	return (u64) tg->shares;
 }
+
+#ifdef CONFIG_CFS_BANDWIDTH
+const u64 max_cfs_quota_period = 1 * NSEC_PER_SEC; /* 1s */
+const u64 min_cfs_quota_period = 1 * NSEC_PER_MSEC; /* 1ms */
+
+static int tg_set_cfs_bandwidth(struct task_group *tg, u64 period, u64 quota)
+{
+	int i;
+	struct cfs_bandwidth *cfs_b = tg_cfs_bandwidth(tg);
+	static DEFINE_MUTEX(mutex);
+
+	if (tg == &root_task_group)
+		return -EINVAL;
+
+	/*
+	 * Ensure we have at some amount of bandwidth every period.  This is
+	 * to prevent reaching a state of large arrears when throttled via
+	 * entity_tick() resulting in prolonged exit starvation.
+	 */
+	if (quota < min_cfs_quota_period || period < min_cfs_quota_period)
+		return -EINVAL;
+
+	/*
+	 * Likewise, bound things on the otherside by preventing insane quota
+	 * periods.  This also allows us to normalize in computing quota
+	 * feasibility.
+	 */
+	if (period > max_cfs_quota_period)
+		return -EINVAL;
+
+	mutex_lock(&mutex);
+	raw_spin_lock_irq(&cfs_b->lock);
+	cfs_b->period = ns_to_ktime(period);
+	cfs_b->quota = quota;
+	raw_spin_unlock_irq(&cfs_b->lock);
+
+	for_each_possible_cpu(i) {
+		struct cfs_rq *cfs_rq = tg->cfs_rq[i];
+		struct rq *rq = rq_of(cfs_rq);
+
+		raw_spin_lock_irq(&rq->lock);
+		cfs_rq->runtime_enabled = quota != RUNTIME_INF;
+		cfs_rq->runtime_remaining = 0;
+		raw_spin_unlock_irq(&rq->lock);
+	}
+	mutex_unlock(&mutex);
+
+	return 0;
+}
+
+int tg_set_cfs_quota(struct task_group *tg, long cfs_quota_us)
+{
+	u64 quota, period;
+
+	period = ktime_to_ns(tg_cfs_bandwidth(tg)->period);
+	if (cfs_quota_us < 0)
+		quota = RUNTIME_INF;
+	else
+		quota = (u64)cfs_quota_us * NSEC_PER_USEC;
+
+	return tg_set_cfs_bandwidth(tg, period, quota);
+}
+
+long tg_get_cfs_quota(struct task_group *tg)
+{
+	u64 quota_us;
+
+	if (tg_cfs_bandwidth(tg)->quota == RUNTIME_INF)
+		return -1;
+
+	quota_us = tg_cfs_bandwidth(tg)->quota;
+	do_div(quota_us, NSEC_PER_USEC);
+
+	return quota_us;
+}
+
+int tg_set_cfs_period(struct task_group *tg, long cfs_period_us)
+{
+	u64 quota, period;
+
+	period = (u64)cfs_period_us * NSEC_PER_USEC;
+	quota = tg_cfs_bandwidth(tg)->quota;
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
+	cfs_period_us = ktime_to_ns(tg_cfs_bandwidth(tg)->period);
+	do_div(cfs_period_us, NSEC_PER_USEC);
+
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
@@ -9157,6 +9331,18 @@ static struct cftype cpu_files[] = {
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
@@ -9466,4 +9652,3 @@ struct cgroup_subsys cpuacct_subsys = {
 	.subsys_id = cpuacct_subsys_id,
 };
 #endif	/* CONFIG_CGROUP_CPUACCT */
-
Index: tip/kernel/sched_fair.c
===================================================================
--- tip.orig/kernel/sched_fair.c
+++ tip/kernel/sched_fair.c
@@ -1250,6 +1250,22 @@ entity_tick(struct cfs_rq *cfs_rq, struc
 		check_preempt_tick(cfs_rq, curr);
 }
 
+
+/**************************************************
+ * CFS bandwidth control machinery
+ */
+
+#ifdef CONFIG_CFS_BANDWIDTH
+/*
+ * default period for cfs group bandwidth.
+ * default: 0.5s, units: nanoseconds
+ */
+static inline u64 default_cfs_period(void)
+{
+	return 500000000ULL;
+}
+#endif
+
 /**************************************************
  * CFS operations on tasks:
  */


