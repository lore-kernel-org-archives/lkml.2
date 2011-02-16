Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756397Ab1BPDUK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 22:20:10 -0500
Received: from smtp-out.google.com ([216.239.44.51]:52380 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755035Ab1BPDUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 22:20:07 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:user-agent:date:from:to:cc:subject:references:content-disposition;
	b=JJXMY7WDJyyg+wtLuqEhBBir044KGGLHMIX0rcsNse/yQYjWzAXfmJF8C2kwT2cmJ
	bgpitsezYZyf8dfMJwlyg==
Message-Id: <20110216031840.979831163@google.com>
User-Agent: quilt/0.48-1
Date: Tue, 15 Feb 2011 19:18:33 -0800
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
Subject: [CFS Bandwidth Control v4 2/7] sched: accumulate per-cfs_rq cpu usage
References: <20110216031831.571628191@google.com>
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
 kernel/sched_fair.c   |   62 ++++++++++++++++++++++++++++++++++++++++++++++++++
 kernel/sysctl.c       |   10 ++++++++
 3 files changed, 76 insertions(+)

Index: tip/kernel/sched_fair.c
===================================================================
--- tip.orig/kernel/sched_fair.c
+++ tip/kernel/sched_fair.c
@@ -95,6 +95,13 @@ unsigned int __read_mostly sysctl_sched_
  * default: 0.5s, units: nanoseconds
  */
 static u64 sched_cfs_bandwidth_period = 500000000ULL;
+
+/*
+ * default slice of quota to allocate from global tg to local cfs_rq pool on
+ * each refresh
+ * default: 10ms, units: microseconds
+ */
+unsigned int sysctl_sched_cfs_bandwidth_slice = 10000UL;
 #endif
 
 static const struct sched_class fair_sched_class;
@@ -313,6 +320,21 @@ find_matching_se(struct sched_entity **s
 
 #endif	/* CONFIG_FAIR_GROUP_SCHED */
 
+#ifdef CONFIG_CFS_BANDWIDTH
+static inline u64 sched_cfs_bandwidth_slice(void)
+{
+	return (u64)sysctl_sched_cfs_bandwidth_slice * NSEC_PER_USEC;
+}
+
+static inline struct cfs_bandwidth *tg_cfs_bandwidth(struct task_group *tg)
+{
+	return &tg->cfs_bandwidth;
+}
+
+static void account_cfs_rq_quota(struct cfs_rq *cfs_rq,
+		unsigned long delta_exec);
+#endif
+
 
 /**************************************************************
  * Scheduling class tree data structure manipulation methods:
@@ -609,6 +631,9 @@ static void update_curr(struct cfs_rq *c
 		cpuacct_charge(curtask, delta_exec);
 		account_group_exec_runtime(curtask, delta_exec);
 	}
+#ifdef CONFIG_CFS_BANDWIDTH
+	account_cfs_rq_quota(cfs_rq, delta_exec);
+#endif
 }
 
 static inline void
@@ -1382,6 +1407,43 @@ static void dequeue_task_fair(struct rq 
 }
 
 #ifdef CONFIG_CFS_BANDWIDTH
+static u64 tg_request_cfs_quota(struct task_group *tg)
+{
+	struct cfs_bandwidth *cfs_b = tg_cfs_bandwidth(tg);
+	u64 delta = 0;
+
+	if (cfs_b->runtime > 0 || cfs_b->quota == RUNTIME_INF) {
+		raw_spin_lock(&cfs_b->lock);
+		/*
+		 * it's possible a bandwidth update has changed the global
+		 * pool.
+		 */
+		if (cfs_b->quota == RUNTIME_INF)
+			delta = sched_cfs_bandwidth_slice();
+		else {
+			delta = min(cfs_b->runtime,
+					sched_cfs_bandwidth_slice());
+			cfs_b->runtime -= delta;
+		}
+		raw_spin_unlock(&cfs_b->lock);
+	}
+	return delta;
+}
+
+static void account_cfs_rq_quota(struct cfs_rq *cfs_rq,
+		unsigned long delta_exec)
+{
+	if (cfs_rq->quota_assigned == RUNTIME_INF)
+		return;
+
+	cfs_rq->quota_used += delta_exec;
+
+	if (cfs_rq->quota_used < cfs_rq->quota_assigned)
+		return;
+
+	cfs_rq->quota_assigned += tg_request_cfs_quota(cfs_rq->tg);
+}
+
 static int do_sched_cfs_period_timer(struct cfs_bandwidth *cfs_b, int overrun)
 {
 	return 1;
Index: tip/kernel/sysctl.c
===================================================================
--- tip.orig/kernel/sysctl.c
+++ tip/kernel/sysctl.c
@@ -361,6 +361,16 @@ static struct ctl_table kern_table[] = {
 		.mode		= 0644,
 		.proc_handler	= sched_rt_handler,
 	},
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
 #ifdef CONFIG_SCHED_AUTOGROUP
 	{
 		.procname	= "sched_autogroup_enabled",
Index: tip/include/linux/sched.h
===================================================================
--- tip.orig/include/linux/sched.h
+++ tip/include/linux/sched.h
@@ -1943,6 +1943,10 @@ int sched_rt_handler(struct ctl_table *t
 		void __user *buffer, size_t *lenp,
 		loff_t *ppos);
 
+#ifdef CONFIG_CFS_BANDWIDTH
+extern unsigned int sysctl_sched_cfs_bandwidth_slice;
+#endif
+
 #ifdef CONFIG_SCHED_AUTOGROUP
 extern unsigned int sysctl_sched_autogroup_enabled;
 


