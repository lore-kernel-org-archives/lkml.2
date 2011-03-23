Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932140Ab1CWDKf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 23:10:35 -0400
Received: from smtp-out.google.com ([216.239.44.51]:7700 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753232Ab1CWDKG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 23:10:06 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:user-agent:date:from:to:cc:subject:references:content-disposition;
	b=idIQ/gx9bEOBtErrJv2TzmU+W3dzIn7w60K8nG7QB7gAAgOdNc3IpjUCEvf6zUvgz
	yFOPchBc7k5wddKBsiwyQ==
Message-Id: <20110323030448.853861319@google.com>
User-Agent: quilt/0.48-1
Date: Tue, 22 Mar 2011 20:03:28 -0700
From: Paul Turner <pjt@google.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>
Subject: [patch 02/15] sched: validate CFS quota hierarchies
References: <20110323030326.789836913@google.com>
Content-Disposition: inline; filename=sched-bwc-consistent_quota.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add constraints validation for CFS bandwidth hierachies.

It is checked that:
   sum(child bandwidth) <= parent_bandwidth

In a quota limited hierarchy, an unconstrainted entity
(e.g. bandwidth==RUNTIME_INF) inherits the bandwidth of its parent.

Since bandwidth periods may be non-uniform we normalize to the maximum allowed
period, 5 seconds.

This behavior may be disabled (allowing child bandwidth to exceed parent) via
kernel.sched_cfs_bandwidth_consistent=0

Signed-off-by: Paul Turner <pjt@google.com>

---
 include/linux/sched.h |    8 +++
 kernel/sched.c        |  127 +++++++++++++++++++++++++++++++++++++++++++++++---
 kernel/sched_fair.c   |    8 +++
 kernel/sysctl.c       |   11 ++++
 4 files changed, 147 insertions(+), 7 deletions(-)

Index: tip/kernel/sched.c
===================================================================
--- tip.orig/kernel/sched.c
+++ tip/kernel/sched.c
@@ -253,6 +253,7 @@ struct cfs_bandwidth {
 	raw_spinlock_t lock;
 	ktime_t period;
 	u64 runtime, quota;
+	s64 hierarchal_quota; /* used for validating consistency */
 	struct hrtimer period_timer;
 #endif
 };
@@ -8868,7 +8869,7 @@ struct rt_schedulable_data {
 	u64 rt_runtime;
 };
 
-static int tg_schedulable(struct task_group *tg, void *data)
+static int tg_rt_schedulable(struct task_group *tg, void *data)
 {
 	struct rt_schedulable_data *d = data;
 	struct task_group *child;
@@ -8932,7 +8933,7 @@ static int __rt_schedulable(struct task_
 		.rt_runtime = runtime,
 	};
 
-	return walk_tg_tree(tg_schedulable, tg_nop, &data);
+	return walk_tg_tree(tg_rt_schedulable, tg_nop, &data);
 }
 
 static int tg_set_rt_bandwidth(struct task_group *tg,
@@ -9223,14 +9224,17 @@ static u64 cpu_shares_read_u64(struct cg
 }
 
 #ifdef CONFIG_CFS_BANDWIDTH
+static DEFINE_MUTEX(cfs_constraints_mutex);
+
 const u64 max_cfs_quota_period = 5 * NSEC_PER_SEC; /* 5s */
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
@@ -9251,7 +9255,13 @@ static int tg_set_cfs_bandwidth(struct t
 	if (period > max_cfs_quota_period)
 		return -EINVAL;
 
-	mutex_lock(&mutex);
+	mutex_lock(&cfs_constraints_mutex);
+	if (sysctl_sched_cfs_bandwidth_consistent) {
+		ret = __cfs_schedulable(tg, period, quota);
+		if (ret)
+			goto out_unlock;
+	}
+
 	raw_spin_lock_irq(&cfs_b->lock);
 	cfs_b->period = ns_to_ktime(period);
 	cfs_b->runtime = cfs_b->quota = quota;
@@ -9265,9 +9275,10 @@ static int tg_set_cfs_bandwidth(struct t
 		init_cfs_rq_quota(cfs_rq);
 		raw_spin_unlock_irq(&rq->lock);
 	}
-	mutex_unlock(&mutex);
+out_unlock:
+	mutex_unlock(&cfs_constraints_mutex);
 
-	return 0;
+	return ret;
 }
 
 int tg_set_cfs_quota(struct task_group *tg, long cfs_quota_us)
@@ -9339,6 +9350,108 @@ static int cpu_cfs_period_write_u64(stru
 	return tg_set_cfs_period(cgroup_tg(cgrp), cfs_period_us);
 }
 
+
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
+		               struct cfs_schedulable_data *d)
+{
+	u64 quota, period;
+	struct load_weight lw;
+
+	if (tg == d->tg) {
+		period = d->period;
+		quota = d->quota;
+	} else {
+		period = tg_get_cfs_period(tg);
+		quota = tg_get_cfs_quota(tg);
+	}
+
+	if (quota == RUNTIME_INF)
+		return RUNTIME_INF;
+
+	lw.weight = period;
+	lw.inv_weight = 0;
+
+	return calc_delta_mine(quota, max_cfs_quota_period, &lw) - 1;
+}
+
+static int tg_cfs_schedulable_down(struct task_group *tg, void *data)
+{
+	struct cfs_schedulable_data *d = data;
+	struct cfs_bandwidth *cfs_b = tg_cfs_bandwidth(tg);
+	s64 quota = 0, parent_quota = -1;
+
+	quota = normalize_cfs_quota(tg, d);
+	if (!tg->parent) {
+		quota = RUNTIME_INF;
+	} else {
+		struct cfs_bandwidth *parent_b = tg_cfs_bandwidth(tg->parent);
+
+		parent_quota = parent_b->hierarchal_quota;
+		if (parent_quota != RUNTIME_INF) {
+			parent_quota -= quota;
+			/* invalid hierarchy, child bandwidth exceeds parent */
+			if (parent_quota < 0)
+				return -EINVAL;
+		}
+
+		/* if no inherent limit then inherit parent quota */
+		if (quota == RUNTIME_INF)
+			quota = parent_quota;
+		parent_b->hierarchal_quota = parent_quota;
+	}
+	cfs_b->hierarchal_quota = quota;
+
+	return 0;
+}
+
+static int __cfs_schedulable(struct task_group *tg, u64 period, u64 quota)
+{
+	int ret;
+	struct cfs_schedulable_data data = {
+		.tg = tg,
+		.period = period / NSEC_PER_USEC,
+		.quota = quota / NSEC_PER_USEC,
+	};
+
+	if (!sysctl_sched_cfs_bandwidth_consistent)
+		return 0;
+
+	rcu_read_lock();
+	ret = walk_tg_tree(tg_cfs_schedulable_down, tg_nop,
+			    &data);
+	rcu_read_unlock();
+
+	return ret;
+}
+
+int sched_cfs_consistent_handler(struct ctl_table *table, int write,
+		void __user *buffer, size_t *lenp,
+		loff_t *ppos)
+{
+	int ret;
+
+	mutex_lock(&cfs_constraints_mutex);
+	ret = proc_dointvec_minmax(table, write, buffer, lenp, ppos);
+
+	if (!ret && write && sysctl_sched_cfs_bandwidth_consistent) {
+		ret = __cfs_schedulable(NULL, 0, 0);
+
+		/* must be consistent to enable */
+		if (ret)
+			sysctl_sched_cfs_bandwidth_consistent = 0;
+	}
+	mutex_unlock(&cfs_constraints_mutex);
+	return ret;
+}
 #endif /* CONFIG_CFS_BANDWIDTH */
 #endif /* CONFIG_FAIR_GROUP_SCHED */
 
Index: tip/kernel/sysctl.c
===================================================================
--- tip.orig/kernel/sysctl.c
+++ tip/kernel/sysctl.c
@@ -361,6 +361,17 @@ static struct ctl_table kern_table[] = {
 		.mode		= 0644,
 		.proc_handler	= sched_rt_handler,
 	},
+#ifdef CONFIG_CFS_BANDWIDTH
+	{
+		.procname	= "sched_cfs_bandwidth_consistent",
+		.data		= &sysctl_sched_cfs_bandwidth_consistent,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= sched_cfs_consistent_handler,
+		.extra1		= &zero,
+		.extra2		= &one,
+	},
+#endif
 #ifdef CONFIG_SCHED_AUTOGROUP
 	{
 		.procname	= "sched_autogroup_enabled",
Index: tip/include/linux/sched.h
===================================================================
--- tip.orig/include/linux/sched.h
+++ tip/include/linux/sched.h
@@ -1943,6 +1943,14 @@ int sched_rt_handler(struct ctl_table *t
 		void __user *buffer, size_t *lenp,
 		loff_t *ppos);
 
+#ifdef CONFIG_CFS_BANDWIDTH
+extern unsigned int sysctl_sched_cfs_bandwidth_consistent;
+
+int sched_cfs_consistent_handler(struct ctl_table *table, int write,
+		void __user *buffer, size_t *lenp,
+		loff_t *ppos);
+#endif
+
 #ifdef CONFIG_SCHED_AUTOGROUP
 extern unsigned int sysctl_sched_autogroup_enabled;
 
Index: tip/kernel/sched_fair.c
===================================================================
--- tip.orig/kernel/sched_fair.c
+++ tip/kernel/sched_fair.c
@@ -88,6 +88,14 @@ const_debug unsigned int sysctl_sched_mi
  */
 unsigned int __read_mostly sysctl_sched_shares_window = 10000000UL;
 
+#ifdef CONFIG_CFS_BANDWIDTH
+/*
+ * Whether a CFS bandwidth hierarchy is required to be consistent, that is:
+ *   sum(child_bandwidth) <= parent_bandwidth
+ */
+unsigned int sysctl_sched_cfs_bandwidth_consistent = 1;
+#endif
+
 static const struct sched_class fair_sched_class;
 
 /**************************************************************


