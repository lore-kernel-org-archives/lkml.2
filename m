Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681Ab1GGFeD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 01:34:03 -0400
Received: from smtp-out.google.com ([74.125.121.67]:3673 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754551Ab1GGFdZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 01:33:25 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:user-agent:date:from:to:cc:subject:references:content-disposition;
	b=QMW9BK4ADlCykOuXkH2XMkTlWwUoHAhMVrRiPNrAC1Kw/Bv40eafpV1+M87qvt6Yp
	y7Y6EVVi3GdLYsj1UT4/Q==
Message-Id: <20110707053100.169988098@google.com>
User-Agent: quilt/0.48-1
Date: Wed, 06 Jul 2011 22:30:41 -0700
From: Paul Turner <pjt@google.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>,
        Hu Tao <hutao@cn.fujitsu.com>, Nikhil Rao <ncrao@google.com>
Subject: [patch 05/17] sched: accumulate per-cfs_rq cpu usage and charge against bandwidth
References: <20110707053036.173186930@google.com>
Content-Disposition: inline; filename=sched-bwc-account_cfs_rq_runtime.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Account bandwidth usage on the cfs_rq level versus the task_groups to which
they belong.  Whether we are tracking bandwidth on a given cfs_rq is maintained
under cfs_rq->runtime_enabled.

cfs_rq's which belong to a bandwidth constrained task_group have their runtime
accounted via the update_curr() path, which withdraws bandwidth from the global
pool as desired.  Updates involving the global pool are currently protected
under cfs_bandwidth->lock, local runtime is protected by rq->lock.

This patch only assigns and tracks quota, no action is taken in the case that
cfs_rq->runtime_used exceeds cfs_rq->runtime_assigned.

Signed-off-by: Paul Turner <pjt@google.com>
Signed-off-by: Nikhil Rao <ncrao@google.com>
Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
Reviewed-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>


---
 include/linux/sched.h |    4 ++
 kernel/sched.c        |    4 ++
 kernel/sched_fair.c   |   69 ++++++++++++++++++++++++++++++++++++++++++++++++--
 kernel/sysctl.c       |   10 +++++++
 4 files changed, 84 insertions(+), 3 deletions(-)

Index: tip/kernel/sched_fair.c
===================================================================
--- tip.orig/kernel/sched_fair.c
+++ tip/kernel/sched_fair.c
@@ -89,6 +89,20 @@ const_debug unsigned int sysctl_sched_mi
  */
 unsigned int __read_mostly sysctl_sched_shares_window = 10000000UL;
 
+#ifdef CONFIG_CFS_BANDWIDTH
+/*
+ * Amount of runtime to allocate from global (tg) to local (per-cfs_rq) pool
+ * each time a cfs_rq requests quota.
+ *
+ * Note: in the case that the slice exceeds the runtime remaining (either due
+ * to consumption or the quota being specified to be smaller than the slice)
+ * we will always only issue the remaining available time.
+ *
+ * default: 5 msec, units: microseconds
+  */
+unsigned int sysctl_sched_cfs_bandwidth_slice = 5000UL;
+#endif
+
 static const struct sched_class fair_sched_class;
 
 /**************************************************************
@@ -305,6 +319,8 @@ find_matching_se(struct sched_entity **s
 
 #endif	/* CONFIG_FAIR_GROUP_SCHED */
 
+static void account_cfs_rq_runtime(struct cfs_rq *cfs_rq,
+				   unsigned long delta_exec);
 
 /**************************************************************
  * Scheduling class tree data structure manipulation methods:
@@ -602,6 +618,8 @@ static void update_curr(struct cfs_rq *c
 		cpuacct_charge(curtask, delta_exec);
 		account_group_exec_runtime(curtask, delta_exec);
 	}
+
+	account_cfs_rq_runtime(cfs_rq, delta_exec);
 }
 
 static inline void
@@ -1270,6 +1288,48 @@ static inline u64 default_cfs_period(voi
 {
 	return 100000000ULL;
 }
+
+static inline u64 sched_cfs_bandwidth_slice(void)
+{
+	return (u64)sysctl_sched_cfs_bandwidth_slice * NSEC_PER_USEC;
+}
+
+static void assign_cfs_rq_runtime(struct cfs_rq *cfs_rq)
+{
+	struct task_group *tg = cfs_rq->tg;
+	struct cfs_bandwidth *cfs_b = tg_cfs_bandwidth(tg);
+	u64 amount = 0, min_amount;
+
+	/* note: this is a positive sum as runtime_remaining <= 0 */
+	min_amount = sched_cfs_bandwidth_slice() - cfs_rq->runtime_remaining;
+
+	raw_spin_lock(&cfs_b->lock);
+	if (cfs_b->quota == RUNTIME_INF)
+		amount = min_amount;
+	else if (cfs_b->runtime > 0) {
+		amount = min(cfs_b->runtime, min_amount);
+		cfs_b->runtime -= amount;
+	}
+	raw_spin_unlock(&cfs_b->lock);
+
+	cfs_rq->runtime_remaining += amount;
+}
+
+static void account_cfs_rq_runtime(struct cfs_rq *cfs_rq,
+		unsigned long delta_exec)
+{
+	if (!cfs_rq->runtime_enabled)
+		return;
+
+	cfs_rq->runtime_remaining -= delta_exec;
+	if (cfs_rq->runtime_remaining > 0)
+		return;
+
+	assign_cfs_rq_runtime(cfs_rq);
+}
+#else
+static void account_cfs_rq_runtime(struct cfs_rq *cfs_rq,
+		unsigned long delta_exec) {}
 #endif
 
 /**************************************************
@@ -4262,8 +4322,13 @@ static void set_curr_task_fair(struct rq
 {
 	struct sched_entity *se = &rq->curr->se;
 
-	for_each_sched_entity(se)
-		set_next_entity(cfs_rq_of(se), se);
+	for_each_sched_entity(se) {
+		struct cfs_rq *cfs_rq = cfs_rq_of(se);
+
+		set_next_entity(cfs_rq, se);
+		/* ensure bandwidth has been allocated on our new cfs_rq */
+		account_cfs_rq_runtime(cfs_rq, 0);
+	}
 }
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
Index: tip/kernel/sysctl.c
===================================================================
--- tip.orig/kernel/sysctl.c
+++ tip/kernel/sysctl.c
@@ -379,6 +379,16 @@ static struct ctl_table kern_table[] = {
 		.extra2		= &one,
 	},
 #endif
+#ifdef CONFIG_CFS_BANDWIDTH
+	{
+		.procname	= "sched_cfs_bandwidth_slice_us",
+		.data		= &sysctl_sched_cfs_bandwidth_slice,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= &one,
+	},
+#endif
 #ifdef CONFIG_PROVE_LOCKING
 	{
 		.procname	= "prove_locking",
Index: tip/kernel/sched.c
===================================================================
--- tip.orig/kernel/sched.c
+++ tip/kernel/sched.c
@@ -248,7 +248,7 @@ struct cfs_bandwidth {
 #ifdef CONFIG_CFS_BANDWIDTH
 	raw_spinlock_t lock;
 	ktime_t period;
-	u64 quota;
+	u64 quota, runtime;
 	s64 hierarchal_quota;
 #endif
 };
@@ -403,6 +403,7 @@ static inline u64 default_cfs_period(voi
 static void init_cfs_bandwidth(struct cfs_bandwidth *cfs_b)
 {
 	raw_spin_lock_init(&cfs_b->lock);
+	cfs_b->runtime = 0;
 	cfs_b->quota = RUNTIME_INF;
 	cfs_b->period = ns_to_ktime(default_cfs_period());
 }
@@ -8920,6 +8921,7 @@ static int tg_set_cfs_bandwidth(struct t
 	raw_spin_lock_irq(&cfs_b->lock);
 	cfs_b->period = ns_to_ktime(period);
 	cfs_b->quota = quota;
+	cfs_b->runtime = quota;
 	raw_spin_unlock_irq(&cfs_b->lock);
 
 	for_each_possible_cpu(i) {
Index: tip/include/linux/sched.h
===================================================================
--- tip.orig/include/linux/sched.h
+++ tip/include/linux/sched.h
@@ -2012,6 +2012,10 @@ static inline void sched_autogroup_fork(
 static inline void sched_autogroup_exit(struct signal_struct *sig) { }
 #endif
 
+#ifdef CONFIG_CFS_BANDWIDTH
+extern unsigned int sysctl_sched_cfs_bandwidth_slice;
+#endif
+
 #ifdef CONFIG_RT_MUTEXES
 extern int rt_mutex_getprio(struct task_struct *p);
 extern void rt_mutex_setprio(struct task_struct *p, int prio);


