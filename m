Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758513Ab1BPDU4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 22:20:56 -0500
Received: from smtp-out.google.com ([74.125.121.67]:29641 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756546Ab1BPDUR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 22:20:17 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:user-agent:date:from:to:cc:subject:references:content-disposition;
	b=fUiCju/zdan36lNkuvAJa8siiD36xM4NNQZuWyvLLHkFcCqB4jJS6XRc8Luj0B89U
	nsTR8YaPrX50c8MZ8KhkA==
Message-Id: <20110216031841.352204682@google.com>
User-Agent: quilt/0.48-1
Date: Tue, 15 Feb 2011 19:18:37 -0800
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
        Chris Friesen <cfriesen@nortel.com>
Subject: [CFS Bandwidth Control v4 6/7] sched: hierarchical task accounting for SCHED_OTHER
References: <20110216031831.571628191@google.com>
Content-Disposition: inline; filename=sched-bwc-account_cfs_tasks.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With task entities participating in throttled sub-trees it is possible for
task activation/de-activation to not lead to root visible changes to
rq->nr_running.  This in turn leads to incorrect idle and weight-per-task load
balance decisions.

To allow correct accounting we move responsibility for updating rq->nr_running
to the respective sched::classes.  In the fair-group case this update is
hierarchical, tracking the number of active tasks rooted at each group entity.

Note: technically this issue also exists with the existing sched_rt
throttling; however due to the nearly complete provisioning of system
resources for rt scheduling this is much less common by default.

Signed-off-by: Paul Turner <pjt@google.com>
Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
---
 kernel/sched.c      |    9 ++++++---
 kernel/sched_fair.c |   42 ++++++++++++++++++++++++++++++++++++++++++
 kernel/sched_rt.c   |    5 ++++-
 3 files changed, 52 insertions(+), 4 deletions(-)

Index: tip/kernel/sched.c
===================================================================
--- tip.orig/kernel/sched.c
+++ tip/kernel/sched.c
@@ -330,7 +330,7 @@ struct task_group root_task_group;
 /* CFS-related fields in a runqueue */
 struct cfs_rq {
 	struct load_weight load;
-	unsigned long nr_running;
+	unsigned long nr_running, h_nr_tasks;
 
 	u64 exec_clock;
 	u64 min_vruntime;
@@ -1846,6 +1846,11 @@ static const struct sched_class rt_sched
 
 #include "sched_stats.h"
 
+static void mod_nr_running(struct rq *rq, long delta)
+{
+	rq->nr_running += delta;
+}
+
 static void inc_nr_running(struct rq *rq)
 {
 	rq->nr_running++;
@@ -1896,7 +1901,6 @@ static void activate_task(struct rq *rq,
 		rq->nr_uninterruptible--;
 
 	enqueue_task(rq, p, flags);
-	inc_nr_running(rq);
 }
 
 /*
@@ -1908,7 +1912,6 @@ static void deactivate_task(struct rq *r
 		rq->nr_uninterruptible++;
 
 	dequeue_task(rq, p, flags);
-	dec_nr_running(rq);
 }
 
 #ifdef CONFIG_IRQ_TIME_ACCOUNTING
Index: tip/kernel/sched_fair.c
===================================================================
--- tip.orig/kernel/sched_fair.c
+++ tip/kernel/sched_fair.c
@@ -81,6 +81,8 @@ unsigned int normalized_sysctl_sched_wak
 
 const_debug unsigned int sysctl_sched_migration_cost = 500000UL;
 
+static void account_hier_tasks(struct sched_entity *se, int delta);
+
 /*
  * The exponential sliding  window over which load is averaged for shares
  * distribution.
@@ -933,6 +935,40 @@ static inline void update_entity_shares_
 }
 #endif /* CONFIG_FAIR_GROUP_SCHED */
 
+#ifdef CONFIG_CFS_BANDWIDTH
+/* maintain hierarchal task counts on group entities */
+static void account_hier_tasks(struct sched_entity *se, int delta)
+{
+	struct rq *rq = rq_of(cfs_rq_of(se));
+	struct cfs_rq *cfs_rq;
+
+	for_each_sched_entity(se) {
+		/* a throttled entity cannot affect its parent hierarchy */
+		if (group_cfs_rq(se) && cfs_rq_throttled(group_cfs_rq(se)))
+			break;
+
+		/* we affect our queuing entity */
+		cfs_rq = cfs_rq_of(se);
+		cfs_rq->h_nr_tasks += delta;
+	}
+
+	/* account for global nr_running delta to hierarchy change */
+	if (!se)
+		mod_nr_running(rq, delta);
+}
+#else
+/*
+ * In the absence of group throttling, all operations are guaranteed to be
+ * globally visible at the root rq level.
+ */
+static void account_hier_tasks(struct sched_entity *se, int delta)
+{
+	struct rq *rq = rq_of(cfs_rq_of(se));
+
+	mod_nr_running(rq, delta);
+}
+#endif
+
 static void enqueue_sleeper(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
 #ifdef CONFIG_SCHEDSTATS
@@ -1428,6 +1464,7 @@ enqueue_task_fair(struct rq *rq, struct 
 		update_cfs_shares(cfs_rq);
 	}
 
+	account_hier_tasks(&p->se, 1);
 	hrtick_update(rq);
 }
 
@@ -1461,6 +1498,7 @@ static void dequeue_task_fair(struct rq 
 		update_cfs_shares(cfs_rq);
 	}
 
+	account_hier_tasks(&p->se, -1);
 	hrtick_update(rq);
 }
 
@@ -1488,6 +1526,8 @@ static u64 tg_request_cfs_quota(struct t
 	return delta;
 }
 
+static void account_hier_tasks(struct sched_entity *se, int delta);
+
 static void throttle_cfs_rq(struct cfs_rq *cfs_rq)
 {
 	struct sched_entity *se;
@@ -1507,6 +1547,7 @@ static void throttle_cfs_rq(struct cfs_r
 	if (!se->on_rq)
 		goto out_throttled;
 
+	account_hier_tasks(se, -cfs_rq->h_nr_tasks);
 	for_each_sched_entity(se) {
 		struct cfs_rq *cfs_rq = cfs_rq_of(se);
 
@@ -1541,6 +1582,7 @@ static void unthrottle_cfs_rq(struct cfs
 	cfs_rq->load_stamp = cfs_rq->load_last = rq->clock_task;
 
 	cfs_rq->throttled = 0;
+	account_hier_tasks(se, cfs_rq->h_nr_tasks);
 	for_each_sched_entity(se) {
 		if (se->on_rq)
 			break;
Index: tip/kernel/sched_rt.c
===================================================================
--- tip.orig/kernel/sched_rt.c
+++ tip/kernel/sched_rt.c
@@ -906,6 +906,8 @@ enqueue_task_rt(struct rq *rq, struct ta
 
 	if (!task_current(rq, p) && p->rt.nr_cpus_allowed > 1)
 		enqueue_pushable_task(rq, p);
+
+	inc_nr_running(rq);
 }
 
 static void dequeue_task_rt(struct rq *rq, struct task_struct *p, int flags)
@@ -916,6 +918,8 @@ static void dequeue_task_rt(struct rq *r
 	dequeue_rt_entity(rt_se);
 
 	dequeue_pushable_task(rq, p);
+
+	dec_nr_running(rq);
 }
 
 /*
@@ -1783,4 +1787,3 @@ static void print_rt_stats(struct seq_fi
 	rcu_read_unlock();
 }
 #endif /* CONFIG_SCHED_DEBUG */
-


