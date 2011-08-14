Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754515Ab1HNQWK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 12:22:10 -0400
Received: from hera.kernel.org ([140.211.167.34]:44213 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754416Ab1HNQWF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 12:22:05 -0400
Date: Sun, 14 Aug 2011 16:21:42 GMT
From: tip-bot for Paul Turner <pjt@google.com>
Message-ID: <tip-ec12cb7f31e28854efae7dd6f9544e0a66379040@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, seto.hidetoshi@jp.fujitsu.com,
        ncrao@google.com, pjt@google.com, bharata@linux.vnet.ibm.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        bharata@linux.vnet.ibm.com, ncrao@google.com,
        seto.hidetoshi@jp.fujitsu.com, a.p.zijlstra@chello.nl, pjt@google.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20110721184757.179386821@google.com>
References: <20110721184757.179386821@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Accumulate per-cfs_rq cpu usage and charge against bandwidth
Git-Commit-ID: ec12cb7f31e28854efae7dd6f9544e0a66379040
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 14 Aug 2011 16:21:49 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ec12cb7f31e28854efae7dd6f9544e0a66379040
Gitweb:     http://git.kernel.org/tip/ec12cb7f31e28854efae7dd6f9544e0a66379040
Author:     Paul Turner <pjt@google.com>
AuthorDate: Thu, 21 Jul 2011 09:43:30 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 14 Aug 2011 12:03:26 +0200

sched: Accumulate per-cfs_rq cpu usage and charge against bandwidth

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
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20110721184757.179386821@google.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/sched.h |    4 ++
 kernel/sched.c        |    4 ++-
 kernel/sched_fair.c   |   79 +++++++++++++++++++++++++++++++++++++++++++++++-
 kernel/sysctl.c       |   10 ++++++
 4 files changed, 94 insertions(+), 3 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 4ac2c05..bc6f5f2 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2040,6 +2040,10 @@ static inline void sched_autogroup_fork(struct signal_struct *sig) { }
 static inline void sched_autogroup_exit(struct signal_struct *sig) { }
 #endif
 
+#ifdef CONFIG_CFS_BANDWIDTH
+extern unsigned int sysctl_sched_cfs_bandwidth_slice;
+#endif
+
 #ifdef CONFIG_RT_MUTEXES
 extern int rt_mutex_getprio(struct task_struct *p);
 extern void rt_mutex_setprio(struct task_struct *p, int prio);
diff --git a/kernel/sched.c b/kernel/sched.c
index ea6850d..35561c6 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -251,7 +251,7 @@ struct cfs_bandwidth {
 #ifdef CONFIG_CFS_BANDWIDTH
 	raw_spinlock_t lock;
 	ktime_t period;
-	u64 quota;
+	u64 quota, runtime;
 	s64 hierarchal_quota;
 #endif
 };
@@ -407,6 +407,7 @@ static inline u64 default_cfs_period(void);
 static void init_cfs_bandwidth(struct cfs_bandwidth *cfs_b)
 {
 	raw_spin_lock_init(&cfs_b->lock);
+	cfs_b->runtime = 0;
 	cfs_b->quota = RUNTIME_INF;
 	cfs_b->period = ns_to_ktime(default_cfs_period());
 }
@@ -9107,6 +9108,7 @@ static int tg_set_cfs_bandwidth(struct task_group *tg, u64 period, u64 quota)
 	raw_spin_lock_irq(&cfs_b->lock);
 	cfs_b->period = ns_to_ktime(period);
 	cfs_b->quota = quota;
+	cfs_b->runtime = quota;
 	raw_spin_unlock_irq(&cfs_b->lock);
 
 	for_each_possible_cpu(i) {
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index f24f417..9502aa8 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -89,6 +89,20 @@ const_debug unsigned int sysctl_sched_migration_cost = 500000UL;
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
@@ -292,6 +306,8 @@ find_matching_se(struct sched_entity **se, struct sched_entity **pse)
 
 #endif	/* CONFIG_FAIR_GROUP_SCHED */
 
+static void account_cfs_rq_runtime(struct cfs_rq *cfs_rq,
+				   unsigned long delta_exec);
 
 /**************************************************************
  * Scheduling class tree data structure manipulation methods:
@@ -583,6 +599,8 @@ static void update_curr(struct cfs_rq *cfs_rq)
 		cpuacct_charge(curtask, delta_exec);
 		account_group_exec_runtime(curtask, delta_exec);
 	}
+
+	account_cfs_rq_runtime(cfs_rq, delta_exec);
 }
 
 static inline void
@@ -1248,6 +1266,58 @@ static inline u64 default_cfs_period(void)
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
+static void __account_cfs_rq_runtime(struct cfs_rq *cfs_rq,
+				     unsigned long delta_exec)
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
+static __always_inline void account_cfs_rq_runtime(struct cfs_rq *cfs_rq,
+						   unsigned long delta_exec)
+{
+	if (!cfs_rq->runtime_enabled)
+		return;
+
+	__account_cfs_rq_runtime(cfs_rq, delta_exec);
+}
+
+#else
+static void account_cfs_rq_runtime(struct cfs_rq *cfs_rq,
+				     unsigned long delta_exec) {}
 #endif
 
 /**************************************************
@@ -4266,8 +4336,13 @@ static void set_curr_task_fair(struct rq *rq)
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
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 11d65b5..2d2ecdc 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
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
