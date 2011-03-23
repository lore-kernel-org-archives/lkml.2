Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754384Ab1CWDKW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 23:10:22 -0400
Received: from smtp-out.google.com ([74.125.121.67]:56674 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753156Ab1CWDKG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 23:10:06 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:user-agent:date:from:to:cc:subject:references:content-disposition;
	b=QXGTwBtD1xgh9haPnxIrQA2cWHvdkglhBsKQKa9HErp9LrR2+nGumEIrfzOOZC2SC
	fmA21CHO/Ta0VV5wgvG3Q==
Message-Id: <20110323030448.950261975@google.com>
User-Agent: quilt/0.48-1
Date: Tue, 22 Mar 2011 20:03:29 -0700
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
Subject: [patch 03/15] sched: accumulate per-cfs_rq cpu usage
References: <20110323030326.789836913@google.com>
Content-Disposition: inline; filename=sched-bwc-accumulate_cfs_rq_usage.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce account_cfs_rq_quota() to account bandwidth usage on the cfs_rq
level versus task_groups for which bandwidth has been assigned.  This is
tracked by whether the local cfs_rq->quota_assigned is finite or infinite
(RUNTIME_INF).

For cfs_rq's that belong to a bandwidth constrained task_group we introduce
tg_request_cfs_quota() which attempts to allocate quota from the global pool
for use locally.  Updates involving the global pool are currently protected
under cfs_bandwidth->lock, local pools are protected by rq->lock.

This patch only attempts to assign and track quota, no action is taken in the
case that cfs_rq->quota_used exceeds cfs_rq->quota_assigned.

Signed-off-by: Paul Turner <pjt@google.com>
Signed-off-by: Nikhil Rao <ncrao@google.com>
Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
---
 include/linux/sched.h |    4 +++
 kernel/sched_fair.c   |   57 ++++++++++++++++++++++++++++++++++++++++++++++++++
 kernel/sysctl.c       |    8 +++++++
 3 files changed, 69 insertions(+)

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
 
+static void account_cfs_rq_quota(struct cfs_rq *cfs_rq,
+		                 unsigned long delta_exec);
 
 /**************************************************************
  * Scheduling class tree data structure manipulation methods:
@@ -605,6 +616,8 @@ static void update_curr(struct cfs_rq *c
 		cpuacct_charge(curtask, delta_exec);
 		account_group_exec_runtime(curtask, delta_exec);
 	}
+
+	account_cfs_rq_quota(cfs_rq, delta_exec);
 }
 
 static inline void
@@ -1276,6 +1289,47 @@ static inline u64 default_cfs_period(voi
 	return 500000000ULL;
 }
 
+static inline u64 sched_cfs_bandwidth_slice(void)
+{
+       return (u64)sysctl_sched_cfs_bandwidth_slice * NSEC_PER_USEC;
+}
+
+static void request_cfs_rq_quota(struct cfs_rq *cfs_rq)
+{
+	struct task_group *tg = cfs_rq->tg;
+	struct cfs_bandwidth *cfs_b = tg_cfs_bandwidth(tg);
+	u64 amount = 0, min_amount;
+
+	min_amount = sched_cfs_bandwidth_slice() + (-cfs_rq->quota_remaining);
+
+	if (cfs_b->runtime > 0 || cfs_b->quota == RUNTIME_INF) {
+		raw_spin_lock(&cfs_b->lock);
+		if (cfs_b->quota != RUNTIME_INF) {
+			amount = min(cfs_b->runtime, min_amount);
+			cfs_b->runtime -= amount;
+		} else {
+			amount = min_amount;
+		}
+		raw_spin_unlock(&cfs_b->lock);
+	}
+
+	cfs_rq->quota_remaining += amount;
+}
+
+static void account_cfs_rq_quota(struct cfs_rq *cfs_rq,
+		unsigned long delta_exec)
+{
+	if (!cfs_rq->quota_enabled)
+		return;
+
+	cfs_rq->quota_remaining -= delta_exec;
+
+	if (cfs_rq->quota_remaining > 0)
+		return;
+
+	request_cfs_rq_quota(cfs_rq);
+}
+
 static int do_sched_cfs_period_timer(struct cfs_bandwidth *cfs_b, int overrun)
 {
 	return 1;
@@ -1285,6 +1339,9 @@ static inline u64 default_cfs_period(voi
 {
 	return 0;
 }
+
+static void account_cfs_rq_quota(struct cfs_rq *cfs_rq,
+		unsigned long delta_exec) {}
 #endif
 
 
Index: tip/kernel/sysctl.c
===================================================================
--- tip.orig/kernel/sysctl.c
+++ tip/kernel/sysctl.c
@@ -371,6 +371,14 @@ static struct ctl_table kern_table[] = {
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
@@ -1951,6 +1951,10 @@ int sched_cfs_consistent_handler(struct 
 		loff_t *ppos);
 #endif
 
+#ifdef CONFIG_CFS_BANDWIDTH
+extern unsigned int sysctl_sched_cfs_bandwidth_slice;
+#endif
+
 #ifdef CONFIG_SCHED_AUTOGROUP
 extern unsigned int sysctl_sched_autogroup_enabled;
 


