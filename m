Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752377Ab1GUXBJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 19:01:09 -0400
Received: from smtp-out.google.com ([74.125.121.67]:53551 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752153Ab1GUXBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 19:01:03 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:user-agent:date:from:to:cc:subject:references:content-disposition;
	b=FuD/lYt++P4Vm6xHH2U++fEwxzuluEKzF7i7wL3ERlNImBJmUMUyuJ8rI4eYDm4Wl
	WMM2UzpQCxBmCy6M7NbJw==
Message-Id: <20110721184757.083774572@google.com>
User-Agent: quilt/0.48-1
Date: Thu, 21 Jul 2011 09:43:29 -0700
From: Paul Turner <pjt@google.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <bsingharora@gmail.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>,
        Jason Baron <jbaron@redhat.com>
Subject: [patch 04/18] sched: validate CFS quota hierarchies
References: <20110721164325.231521704@google.com>
Content-Disposition: inline; filename=sched-bwc-consistent_quota.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add constraints validation for CFS bandwidth hierarchies.

Validate that:
   max(child bandwidth) <= parent_bandwidth

In a quota limited hierarchy, an unconstrained entity
(e.g. bandwidth==RUNTIME_INF) inherits the bandwidth of its parent.

This constraint is chosen over sum(child_bandwidth) as notion of over-commit is
valuable within SCHED_OTHER.  Some basic code from the RT case is re-factored
for reuse.

Signed-off-by: Paul Turner <pjt@google.com>

---
 kernel/sched.c |  112 +++++++++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 98 insertions(+), 14 deletions(-)

Index: tip/kernel/sched.c
===================================================================
--- tip.orig/kernel/sched.c
+++ tip/kernel/sched.c
@@ -249,6 +249,7 @@ struct cfs_bandwidth {
 	raw_spinlock_t lock;
 	ktime_t period;
 	u64 quota;
+	s64 hierarchal_quota;
 #endif
 };
 
@@ -1510,7 +1511,8 @@ static inline void dec_cpu_load(struct r
 	update_load_sub(&rq->load, load);
 }
 
-#if (defined(CONFIG_SMP) && defined(CONFIG_FAIR_GROUP_SCHED)) || defined(CONFIG_RT_GROUP_SCHED)
+#if defined(CONFIG_RT_GROUP_SCHED) || (defined(CONFIG_FAIR_GROUP_SCHED) && \
+			(defined(CONFIG_SMP) || defined(CONFIG_CFS_BANDWIDTH)))
 typedef int (*tg_visitor)(struct task_group *, void *);
 
 /*
@@ -8522,12 +8524,7 @@ unsigned long sched_group_shares(struct 
 }
 #endif
 
-#ifdef CONFIG_RT_GROUP_SCHED
-/*
- * Ensure that the real time constraints are schedulable.
- */
-static DEFINE_MUTEX(rt_constraints_mutex);
-
+#if defined(CONFIG_RT_GROUP_SCHED) || defined(CONFIG_CFS_BANDWIDTH)
 static unsigned long to_ratio(u64 period, u64 runtime)
 {
 	if (runtime == RUNTIME_INF)
@@ -8535,6 +8532,13 @@ static unsigned long to_ratio(u64 period
 
 	return div64_u64(runtime << 20, period);
 }
+#endif
+
+#ifdef CONFIG_RT_GROUP_SCHED
+/*
+ * Ensure that the real time constraints are schedulable.
+ */
+static DEFINE_MUTEX(rt_constraints_mutex);
 
 /* Must be called with tasklist_lock held */
 static inline int tg_has_rt_tasks(struct task_group *tg)
@@ -8555,7 +8559,7 @@ struct rt_schedulable_data {
 	u64 rt_runtime;
 };
 
-static int tg_schedulable(struct task_group *tg, void *data)
+static int tg_rt_schedulable(struct task_group *tg, void *data)
 {
 	struct rt_schedulable_data *d = data;
 	struct task_group *child;
@@ -8619,7 +8623,7 @@ static int __rt_schedulable(struct task_
 		.rt_runtime = runtime,
 	};
 
-	return walk_tg_tree(tg_schedulable, tg_nop, &data);
+	return walk_tg_tree(tg_rt_schedulable, tg_nop, &data);
 }
 
 static int tg_set_rt_bandwidth(struct task_group *tg,
@@ -8878,14 +8882,17 @@ static u64 cpu_shares_read_u64(struct cg
 }
 
 #ifdef CONFIG_CFS_BANDWIDTH
+static DEFINE_MUTEX(cfs_constraints_mutex);
+
 const u64 max_cfs_quota_period = 1 * NSEC_PER_SEC; /* 1s */
 const u64 min_cfs_quota_period = 1 * NSEC_PER_MSEC; /* 1ms */
 
+static int __cfs_schedulable(struct task_group *tg, u64 period, u64 runtime);
+
 static int tg_set_cfs_bandwidth(struct task_group *tg, u64 period, u64 quota)
 {
-	int i;
+	int i, ret = 0;
 	struct cfs_bandwidth *cfs_b = tg_cfs_bandwidth(tg);
-	static DEFINE_MUTEX(mutex);
 
 	if (tg == &root_task_group)
 		return -EINVAL;
@@ -8906,7 +8913,11 @@ static int tg_set_cfs_bandwidth(struct t
 	if (period > max_cfs_quota_period)
 		return -EINVAL;
 
-	mutex_lock(&mutex);
+	mutex_lock(&cfs_constraints_mutex);
+	ret = __cfs_schedulable(tg, period, quota);
+	if (ret)
+		goto out_unlock;
+
 	raw_spin_lock_irq(&cfs_b->lock);
 	cfs_b->period = ns_to_ktime(period);
 	cfs_b->quota = quota;
@@ -8921,9 +8932,10 @@ static int tg_set_cfs_bandwidth(struct t
 		cfs_rq->runtime_remaining = 0;
 		raw_spin_unlock_irq(&rq->lock);
 	}
-	mutex_unlock(&mutex);
+out_unlock:
+	mutex_unlock(&cfs_constraints_mutex);
 
-	return 0;
+	return ret;
 }
 
 int tg_set_cfs_quota(struct task_group *tg, long cfs_quota_us)
@@ -8997,6 +9009,78 @@ static int cpu_cfs_period_write_u64(stru
 	return tg_set_cfs_period(cgroup_tg(cgrp), cfs_period_us);
 }
 
+struct cfs_schedulable_data {
+	struct task_group *tg;
+	u64 period, quota;
+};
+
+/*
+ * normalize group quota/period to be quota/max_period
+ * note: units are usecs
+ */
+static u64 normalize_cfs_quota(struct task_group *tg,
+			       struct cfs_schedulable_data *d)
+{
+	u64 quota, period;
+
+	if (tg == d->tg) {
+		period = d->period;
+		quota = d->quota;
+	} else {
+		period = tg_get_cfs_period(tg);
+		quota = tg_get_cfs_quota(tg);
+	}
+
+	/* note: these should typically be equivalent */
+	if (quota == RUNTIME_INF || quota == -1)
+		return RUNTIME_INF;
+
+	return to_ratio(period, quota);
+}
+
+static int tg_cfs_schedulable_down(struct task_group *tg, void *data)
+{
+	struct cfs_schedulable_data *d = data;
+	struct cfs_bandwidth *cfs_b = tg_cfs_bandwidth(tg);
+	s64 quota = 0, parent_quota = -1;
+
+	if (!tg->parent) {
+		quota = RUNTIME_INF;
+	} else {
+		struct cfs_bandwidth *parent_b = tg_cfs_bandwidth(tg->parent);
+
+		quota = normalize_cfs_quota(tg, d);
+		parent_quota = parent_b->hierarchal_quota;
+
+		/*
+		 * ensure max(child_quota) <= parent_quota, inherit when no
+		 * limit is set
+		 */
+		if (quota == RUNTIME_INF)
+			quota = parent_quota;
+		else if (parent_quota != RUNTIME_INF && quota > parent_quota)
+			return -EINVAL;
+	}
+	cfs_b->hierarchal_quota = quota;
+
+	return 0;
+}
+
+static int __cfs_schedulable(struct task_group *tg, u64 period, u64 quota)
+{
+	struct cfs_schedulable_data data = {
+		.tg = tg,
+		.period = period,
+		.quota = quota,
+	};
+
+	if (quota != RUNTIME_INF) {
+		do_div(data.period, NSEC_PER_USEC);
+		do_div(data.quota, NSEC_PER_USEC);
+	}
+
+	return walk_tg_tree(tg_cfs_schedulable_down, tg_nop, &data);
+}
 #endif /* CONFIG_CFS_BANDWIDTH */
 #endif /* CONFIG_FAIR_GROUP_SCHED */
 


