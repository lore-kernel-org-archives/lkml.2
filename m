Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754998Ab1HNQSv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 12:18:51 -0400
Received: from hera.kernel.org ([140.211.167.34]:41876 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754936Ab1HNQSY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 12:18:24 -0400
Date: Sun, 14 Aug 2011 16:17:38 GMT
From: tip-bot for Paul Turner <pjt@google.com>
Message-ID: <tip-ab84d31e15502fb626169ba2663381e34bf965b2@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, seto.hidetoshi@jp.fujitsu.com,
        ncrao@google.com, pjt@google.com, bharata@linux.vnet.ibm.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        bharata@linux.vnet.ibm.com, ncrao@google.com,
        seto.hidetoshi@jp.fujitsu.com, a.p.zijlstra@chello.nl, pjt@google.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20110721184756.972636699@google.com>
References: <20110721184756.972636699@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Introduce primitives to account for CFS bandwidth tracking
Git-Commit-ID: ab84d31e15502fb626169ba2663381e34bf965b2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 14 Aug 2011 16:17:43 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ab84d31e15502fb626169ba2663381e34bf965b2
Gitweb:     http://git.kernel.org/tip/ab84d31e15502fb626169ba2663381e34bf965b2
Author:     Paul Turner <pjt@google.com>
AuthorDate: Thu, 21 Jul 2011 09:43:28 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 14 Aug 2011 12:03:20 +0200

sched: Introduce primitives to account for CFS bandwidth tracking

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
Reviewed-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20110721184756.972636699@google.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 init/Kconfig        |   12 +++
 kernel/sched.c      |  196 +++++++++++++++++++++++++++++++++++++++++++++++++-
 kernel/sched_fair.c |   16 ++++
 3 files changed, 220 insertions(+), 4 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index d627783..d19b3a7 100644
--- a/init/Kconfig
+++ b/init/Kconfig
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
+	  See tip/Documentation/scheduler/sched-bwc.txt for more information.
+
 config RT_GROUP_SCHED
 	bool "Group scheduling for SCHED_RR/FIFO"
 	depends on EXPERIMENTAL
diff --git a/kernel/sched.c b/kernel/sched.c
index cd1a531..f08cb23 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -247,6 +247,14 @@ struct cfs_rq;
 
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
@@ -278,6 +286,8 @@ struct task_group {
 #ifdef CONFIG_SCHED_AUTOGROUP
 	struct autogroup *autogroup;
 #endif
+
+	struct cfs_bandwidth cfs_bandwidth;
 };
 
 /* task_group_lock serializes the addition/removal of task groups */
@@ -377,9 +387,48 @@ struct cfs_rq {
 
 	unsigned long load_contribution;
 #endif
+#ifdef CONFIG_CFS_BANDWIDTH
+	int runtime_enabled;
+	s64 runtime_remaining;
+#endif
 #endif
 };
 
+#ifdef CONFIG_FAIR_GROUP_SCHED
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
+	cfs_rq->runtime_enabled = 0;
+}
+
+static void destroy_cfs_bandwidth(struct cfs_bandwidth *cfs_b)
+{}
+#else
+static void init_cfs_rq_runtime(struct cfs_rq *cfs_rq) {}
+static void init_cfs_bandwidth(struct cfs_bandwidth *cfs_b) {}
+static void destroy_cfs_bandwidth(struct cfs_bandwidth *cfs_b) {}
+
+static inline struct cfs_bandwidth *tg_cfs_bandwidth(struct task_group *tg)
+{
+	return NULL;
+}
+#endif /* CONFIG_CFS_BANDWIDTH */
+#endif /* CONFIG_FAIR_GROUP_SCHED */
+
 /* Real-Time classes' related field in a runqueue: */
 struct rt_rq {
 	struct rt_prio_array active;
@@ -7971,6 +8020,7 @@ static void init_tg_cfs_entry(struct task_group *tg, struct cfs_rq *cfs_rq,
 	/* allow initial update_cfs_load() to truncate */
 	cfs_rq->load_stamp = 1;
 #endif
+	init_cfs_rq_runtime(cfs_rq);
 
 	tg->cfs_rq[cpu] = cfs_rq;
 	tg->se[cpu] = se;
@@ -8110,6 +8160,7 @@ void __init sched_init(void)
 		 * We achieve this by letting root_task_group's tasks sit
 		 * directly in rq->cfs (i.e root_task_group->se[] = NULL).
 		 */
+		init_cfs_bandwidth(&root_task_group.cfs_bandwidth);
 		init_tg_cfs_entry(&root_task_group, &rq->cfs, NULL, i, NULL);
 #endif /* CONFIG_FAIR_GROUP_SCHED */
 
@@ -8351,6 +8402,8 @@ static void free_fair_sched_group(struct task_group *tg)
 {
 	int i;
 
+	destroy_cfs_bandwidth(tg_cfs_bandwidth(tg));
+
 	for_each_possible_cpu(i) {
 		if (tg->cfs_rq)
 			kfree(tg->cfs_rq[i]);
@@ -8378,6 +8431,8 @@ int alloc_fair_sched_group(struct task_group *tg, struct task_group *parent)
 
 	tg->shares = NICE_0_LOAD;
 
+	init_cfs_bandwidth(tg_cfs_bandwidth(tg));
+
 	for_each_possible_cpu(i) {
 		cfs_rq = kzalloc_node(sizeof(struct cfs_rq),
 				      GFP_KERNEL, cpu_to_node(i));
@@ -8753,7 +8808,7 @@ static int __rt_schedulable(struct task_group *tg, u64 period, u64 runtime)
 	return walk_tg_tree(tg_schedulable, tg_nop, &data);
 }
 
-static int tg_set_bandwidth(struct task_group *tg,
+static int tg_set_rt_bandwidth(struct task_group *tg,
 		u64 rt_period, u64 rt_runtime)
 {
 	int i, err = 0;
@@ -8792,7 +8847,7 @@ int sched_group_set_rt_runtime(struct task_group *tg, long rt_runtime_us)
 	if (rt_runtime_us < 0)
 		rt_runtime = RUNTIME_INF;
 
-	return tg_set_bandwidth(tg, rt_period, rt_runtime);
+	return tg_set_rt_bandwidth(tg, rt_period, rt_runtime);
 }
 
 long sched_group_rt_runtime(struct task_group *tg)
@@ -8817,7 +8872,7 @@ int sched_group_set_rt_period(struct task_group *tg, long rt_period_us)
 	if (rt_period == 0)
 		return -EINVAL;
 
-	return tg_set_bandwidth(tg, rt_period, rt_runtime);
+	return tg_set_rt_bandwidth(tg, rt_period, rt_runtime);
 }
 
 long sched_group_rt_period(struct task_group *tg)
@@ -9007,6 +9062,128 @@ static u64 cpu_shares_read_u64(struct cgroup *cgrp, struct cftype *cft)
 
 	return (u64) scale_load_down(tg->shares);
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
@@ -9041,6 +9218,18 @@ static struct cftype cpu_files[] = {
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
@@ -9350,4 +9539,3 @@ struct cgroup_subsys cpuacct_subsys = {
 	.subsys_id = cpuacct_subsys_id,
 };
 #endif	/* CONFIG_CGROUP_CPUACCT */
-
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index f86b0cb..f24f417 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1234,6 +1234,22 @@ entity_tick(struct cfs_rq *cfs_rq, struct sched_entity *curr, int queued)
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
+ * default: 0.1s, units: nanoseconds
+ */
+static inline u64 default_cfs_period(void)
+{
+	return 100000000ULL;
+}
+#endif
+
 /**************************************************
  * CFS operations on tasks:
  */
