Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754993Ab1HNQUH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 12:20:07 -0400
Received: from hera.kernel.org ([140.211.167.34]:42202 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753618Ab1HNQUA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 12:20:00 -0400
Date: Sun, 14 Aug 2011 16:19:40 GMT
From: tip-bot for Paul Turner <pjt@google.com>
Message-ID: <tip-a790de99599a29ad3f18667530cf4b9f4b7e3234@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, pjt@google.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, pjt@google.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <20110721184757.083774572@google.com>
References: <20110721184757.083774572@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Validate CFS quota hierarchies
Git-Commit-ID: a790de99599a29ad3f18667530cf4b9f4b7e3234
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 14 Aug 2011 16:19:44 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a790de99599a29ad3f18667530cf4b9f4b7e3234
Gitweb:     http://git.kernel.org/tip/a790de99599a29ad3f18667530cf4b9f4b7e3234
Author:     Paul Turner <pjt@google.com>
AuthorDate: Thu, 21 Jul 2011 09:43:29 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 14 Aug 2011 12:03:22 +0200

sched: Validate CFS quota hierarchies

Add constraints validation for CFS bandwidth hierarchies.

Validate that:
   max(child bandwidth) <= parent_bandwidth

In a quota limited hierarchy, an unconstrained entity
(e.g. bandwidth==RUNTIME_INF) inherits the bandwidth of its parent.

This constraint is chosen over sum(child_bandwidth) as notion of over-commit is
valuable within SCHED_OTHER.  Some basic code from the RT case is re-factored
for reuse.

Signed-off-by: Paul Turner <pjt@google.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20110721184757.083774572@google.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |  112 +++++++++++++++++++++++++++++++++++++++++++++++++-------
 1 files changed, 98 insertions(+), 14 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index f08cb23..ea6850d 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -252,6 +252,7 @@ struct cfs_bandwidth {
 	raw_spinlock_t lock;
 	ktime_t period;
 	u64 quota;
+	s64 hierarchal_quota;
 #endif
 };
 
@@ -1518,7 +1519,8 @@ static inline void dec_cpu_load(struct rq *rq, unsigned long load)
 	update_load_sub(&rq->load, load);
 }
 
-#if (defined(CONFIG_SMP) && defined(CONFIG_FAIR_GROUP_SCHED)) || defined(CONFIG_RT_GROUP_SCHED)
+#if defined(CONFIG_RT_GROUP_SCHED) || (defined(CONFIG_FAIR_GROUP_SCHED) && \
+			(defined(CONFIG_SMP) || defined(CONFIG_CFS_BANDWIDTH)))
 typedef int (*tg_visitor)(struct task_group *, void *);
 
 /*
@@ -8708,12 +8710,7 @@ unsigned long sched_group_shares(struct task_group *tg)
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
@@ -8721,6 +8718,13 @@ static unsigned long to_ratio(u64 period, u64 runtime)
 
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
@@ -8741,7 +8745,7 @@ struct rt_schedulable_data {
 	u64 rt_runtime;
 };
 
-static int tg_schedulable(struct task_group *tg, void *data)
+static int tg_rt_schedulable(struct task_group *tg, void *data)
 {
 	struct rt_schedulable_data *d = data;
 	struct task_group *child;
@@ -8805,7 +8809,7 @@ static int __rt_schedulable(struct task_group *tg, u64 period, u64 runtime)
 		.rt_runtime = runtime,
 	};
 
-	return walk_tg_tree(tg_schedulable, tg_nop, &data);
+	return walk_tg_tree(tg_rt_schedulable, tg_nop, &data);
 }
 
 static int tg_set_rt_bandwidth(struct task_group *tg,
@@ -9064,14 +9068,17 @@ static u64 cpu_shares_read_u64(struct cgroup *cgrp, struct cftype *cft)
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
@@ -9092,7 +9099,11 @@ static int tg_set_cfs_bandwidth(struct task_group *tg, u64 period, u64 quota)
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
@@ -9107,9 +9118,10 @@ static int tg_set_cfs_bandwidth(struct task_group *tg, u64 period, u64 quota)
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
@@ -9183,6 +9195,78 @@ static int cpu_cfs_period_write_u64(struct cgroup *cgrp, struct cftype *cftype,
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
 
