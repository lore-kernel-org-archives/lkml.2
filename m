Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754023Ab0D1LSB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 07:18:01 -0400
Received: from smtp-out.google.com ([74.125.121.35]:12134 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089Ab0D1LR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 07:17:57 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=subject:to:from:cc:date:message-id:in-reply-to:references:
	user-agent:mime-version:content-type:
	content-transfer-encoding:x-system-of-record;
	b=rmuEWoslcRmU+q+05zdv5BdQ8aMU0HJu/fjoI7PA5Icpo/I4RJZghRvFnlTw7BipB
	4WzhhewtHUzI7LnJ252Ww==
Subject: [PATCH v2 2/6] sched: accumulate per-cfs_rq cpu usage
To: linux-kernel@vger.kernel.org
From: Paul Turner <pjt@google.com>
Cc: Paul Menage <menage@google.com>, Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       Herbert Poetzl <herbert@13thfloor.at>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Chris Friesen <cfriesen@nortel.com>, Avi Kivity <avi@redhat.com>,
       Bharata B Rao <bharata@linux.vnet.ibm.com>,
       Nikhil Rao <ncrao@google.com>, Ingo Molnar <mingo@elte.hu>,
       Pavel Emelyanov <xemul@openvz.org>, Mike Waychison <mikew@google.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Wed, 28 Apr 2010 04:16:56 -0700
Message-ID: <20100428111656.7954.19756.stgit@kitami.corp.google.com>
In-Reply-To: <20100428110720.7954.53537.stgit@kitami.corp.google.com>
References: <20100428110720.7954.53537.stgit@kitami.corp.google.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
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
---
 include/linux/sched.h |    4 ++++
 kernel/sched.c        |   13 +++++++++++++
 kernel/sched_fair.c   |   50 +++++++++++++++++++++++++++++++++++++++++++++++++
 kernel/sysctl.c       |   10 ++++++++++
 4 files changed, 77 insertions(+), 0 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index dad7f66..8603645 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1903,6 +1903,10 @@ int sched_rt_handler(struct ctl_table *table, int write,
 		void __user *buffer, size_t *lenp,
 		loff_t *ppos);
 
+#ifdef CONFIG_CFS_BANDWIDTH
+extern unsigned int sysctl_sched_cfs_bandwidth_slice;
+#endif
+
 extern unsigned int sysctl_sched_compat_yield;
 
 #ifdef CONFIG_RT_MUTEXES
diff --git a/kernel/sched.c b/kernel/sched.c
index 96db602..3b53695 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1912,6 +1912,19 @@ static const struct sched_class rt_sched_class;
  * default: 0.5s
  */
 static u64 sched_cfs_bandwidth_period = 500000000ULL;
+
+/*
+ * default slice of quota to allocate from global tg to local cfs_rq pool on
+ * each refresh
+ * default: 10ms
+ */
+unsigned int sysctl_sched_cfs_bandwidth_slice = 10000UL;
+
+static inline u64 sched_cfs_bandwidth_slice(void)
+{
+	return (u64)sysctl_sched_cfs_bandwidth_slice * NSEC_PER_USEC;
+}
+
 #endif
 
 #define sched_class_highest (&rt_sched_class)
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index a61bc24..1db1991 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -267,6 +267,16 @@ find_matching_se(struct sched_entity **se, struct sched_entity **pse)
 
 #endif	/* CONFIG_FAIR_GROUP_SCHED */
 
+#ifdef CONFIG_CFS_BANDWIDTH
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
@@ -546,6 +556,9 @@ static void update_curr(struct cfs_rq *cfs_rq)
 		cpuacct_charge(curtask, delta_exec);
 		account_group_exec_runtime(curtask, delta_exec);
 	}
+#ifdef CONFIG_CFS_BANDWIDTH
+	account_cfs_rq_quota(cfs_rq, delta_exec);
+#endif
 }
 
 static inline void
@@ -1148,6 +1161,43 @@ static void yield_task_fair(struct rq *rq)
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
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 8686b0f..d0e17ca 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -354,6 +354,16 @@ static struct ctl_table kern_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec,
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
 #ifdef CONFIG_PROVE_LOCKING
 	{
 		.procname	= "prove_locking",

