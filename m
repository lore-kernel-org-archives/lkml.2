Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753558Ab1EGGcp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 May 2011 02:32:45 -0400
Received: from smtp-out.google.com ([74.125.121.67]:50453 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753283Ab1EGGck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 May 2011 02:32:40 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:user-agent:date:from:to:cc:subject:references:content-disposition;
	b=fE8Xxvw+lwl9PculaehECdvjlRV8x0Rmc68an+WjszpCZSuMTTwc5MJtqgmMIuaPp
	iA/HL91sjbHt5M9rbGBVw==
Message-Id: <20110503092904.985285812@google.com>
User-Agent: quilt/0.48-1
Date: Tue, 03 May 2011 02:28:52 -0700
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
Subject: [patch 06/15] sched: accumulate per-cfs_rq cpu usage and charge against bandwidth
References: <20110503092846.022272244@google.com>
Content-Disposition: inline; filename=sched-bwc-account_cfs_rq_runtime.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Account bandwidth usage on the cfs_rq level versus the task_groups to which
they belong.  Whether we are tracking bandwidht on a given cfs_rq is maintained
under cfs_rq->runtime_enabled.

cfs_rq's which belong to a bandwidth constrained task_group have their runtime
accounted via the update_curr() path, which withdraws bandwidth from the global
pool as desired.  Updates involving the global pool are currently protected
under cfs_bandwidth->lock, local runtime is protected by rq->lock.

This patch only attempts to assign and track quota, no action is taken in the
case that cfs_rq->runtime_used exceeds cfs_rq->runtime_assigned.

Signed-off-by: Paul Turner <pjt@google.com>
Signed-off-by: Nikhil Rao <ncrao@google.com>
Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
---
 include/linux/sched.h |    4 ++
 kernel/sched.c        |    2 +
 kernel/sched_fair.c   |   85 ++++++++++++++++++++++++++++++++++++++++++++++++--
 kernel/sysctl.c       |    8 ++++
 4 files changed, 96 insertions(+), 3 deletions(-)

Index: tip/kernel/sched_fair.c
===================================================================
--- tip.orig/kernel/sched_fair.c
+++ tip/kernel/sched_fair.c
@@ -96,6 +96,15 @@ unsigned int __read_mostly sysctl_sched_
 unsigned int sysctl_sched_cfs_bandwidth_consistent = 1;
 #endif
 
+#ifdef CONFIG_CFS_BANDWIDTH
+/*
+ * amount of quota to allocate from global tg to local cfs_rq pool on each
+ * refresh
+ * default: 5ms, units: microseconds
+  */
+unsigned int sysctl_sched_cfs_bandwidth_slice = 5000UL;
+#endif
+
 static const struct sched_class fair_sched_class;
 
 /**************************************************************
@@ -312,6 +321,8 @@ find_matching_se(struct sched_entity **s
 
 #endif	/* CONFIG_FAIR_GROUP_SCHED */
 
+static void account_cfs_rq_runtime(struct cfs_rq *cfs_rq,
+				   unsigned long delta_exec);
 
 /**************************************************************
  * Scheduling class tree data structure manipulation methods:
@@ -605,6 +616,8 @@ static void update_curr(struct cfs_rq *c
 		cpuacct_charge(curtask, delta_exec);
 		account_group_exec_runtime(curtask, delta_exec);
 	}
+
+	account_cfs_rq_runtime(cfs_rq, delta_exec);
 }
 
 static inline void
@@ -1277,10 +1290,68 @@ static inline u64 default_cfs_period(voi
 	return 500000000ULL;
 }
 
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
+	/* note: this is a positive sum, runtime_remaining <= 0 */
+	min_amount = sched_cfs_bandwidth_slice() - cfs_rq->runtime_remaining;
+
+	raw_spin_lock(&cfs_b->lock);
+	if (cfs_b->quota == RUNTIME_INF)
+		amount = min_amount;
+	else if (cfs_b->runtime > 0) {
+		amount = min(cfs_b->runtime, min_amount);
+		cfs_b->runtime -= amount;
+	}
+	cfs_b->idle = 0;
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
+
 static int do_sched_cfs_period_timer(struct cfs_bandwidth *cfs_b, int overrun)
 {
-	return 1;
+	u64 quota, runtime = 0;
+	int idle = 0;
+
+	raw_spin_lock(&cfs_b->lock);
+	quota = cfs_b->quota;
+
+	if (quota != RUNTIME_INF) {
+		runtime = quota;
+		cfs_b->runtime = runtime;
+
+		idle = cfs_b->idle;
+		cfs_b->idle = 1;
+	}
+	raw_spin_unlock(&cfs_b->lock);
+
+	return idle;
 }
+#else
+static void account_cfs_rq_runtime(struct cfs_rq *cfs_rq,
+		unsigned long delta_exec) {}
 #endif
 
 /**************************************************
@@ -4222,8 +4293,16 @@ static void set_curr_task_fair(struct rq
 {
 	struct sched_entity *se = &rq->curr->se;
 
-	for_each_sched_entity(se)
-		set_next_entity(cfs_rq_of(se), se);
+	for_each_sched_entity(se) {
+		struct cfs_rq *cfs_rq = cfs_rq_of(se);
+
+		set_next_entity(cfs_rq, se);
+		/*
+		 * if bandwidth is enabled, make sure it is up-to-date or
+		 * reschedule for the case of a move into a throttled cpu.
+		 */
+		account_cfs_rq_runtime(cfs_rq, 0);
+	}
 }
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
Index: tip/kernel/sysctl.c
===================================================================
--- tip.orig/kernel/sysctl.c
+++ tip/kernel/sysctl.c
@@ -377,6 +377,14 @@ static struct ctl_table kern_table[] = {
 		.extra1		= &zero,
 		.extra2		= &one,
 	},
+	{
+		.procname	= "sched_cfs_bandwidth_slice_us",
+		.data		= &sysctl_sched_cfs_bandwidth_slice,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= &one,
+	},
 #endif
 #ifdef CONFIG_SCHED_AUTOGROUP
 	{
Index: tip/include/linux/sched.h
===================================================================
--- tip.orig/include/linux/sched.h
+++ tip/include/linux/sched.h
@@ -1958,6 +1958,10 @@ int sched_cfs_consistent_handler(struct 
 		loff_t *ppos);
 #endif
 
+#ifdef CONFIG_CFS_BANDWIDTH
+extern unsigned int sysctl_sched_cfs_bandwidth_slice;
+#endif
+
 #ifdef CONFIG_SCHED_AUTOGROUP
 extern unsigned int sysctl_sched_autogroup_enabled;
 
Index: tip/kernel/sched.c
===================================================================
--- tip.orig/kernel/sched.c
+++ tip/kernel/sched.c
@@ -252,6 +252,7 @@ struct cfs_bandwidth {
 	raw_spinlock_t lock;
 	ktime_t period;
 	u64 quota;
+	u64 runtime;
 	s64 hierarchal_quota;
 
 	int idle;
@@ -426,6 +427,7 @@ static enum hrtimer_restart sched_cfs_pe
 static void init_cfs_bandwidth(struct cfs_bandwidth *cfs_b)
 {
 	raw_spin_lock_init(&cfs_b->lock);
+	cfs_b->runtime = 0;
 	cfs_b->quota = RUNTIME_INF;
 	cfs_b->period = ns_to_ktime(default_cfs_period());
 


