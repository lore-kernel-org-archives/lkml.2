Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932107Ab0JLHyc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 03:54:32 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:38019 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757039Ab0JLHyb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 03:54:31 -0400
Date: Tue, 12 Oct 2010 13:24:25 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Pavel Emelyanov <xemul@openvz.org>,
        Herbert Poetzl <herbert@13thfloor.at>, Avi Kivity <avi@redhat.com>,
        Chris Friesen <cfriesen@nortel.com>, Paul Menage <menage@google.com>,
        Mike Waychison <mikew@google.com>, Paul Turner <pjt@google.com>,
        Nikhil Rao <ncrao@google.com>
Subject: [PATCH v3 6/7] sched: hierarchical task accounting for
	FAIR_GROUP_SCHED
Message-ID: <20101012075425.GG9893@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20101012074910.GA9893@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101012074910.GA9893@in.ibm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sched: hierarchical task accounting for FAIR_GROUP_SCHED

From: Paul Turner <pjt@google.com>

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

Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
---
 kernel/sched.c      |    9 ++++++---
 kernel/sched_fair.c |   42 ++++++++++++++++++++++++++++++++++++++++++
 kernel/sched_rt.c   |    5 ++++-
 3 files changed, 52 insertions(+), 4 deletions(-)

--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -333,7 +333,7 @@ struct task_group init_task_group;
 /* CFS-related fields in a runqueue */
 struct cfs_rq {
 	struct load_weight load;
-	unsigned long nr_running;
+	unsigned long nr_running, h_nr_tasks;
 
 	u64 exec_clock;
 	u64 min_vruntime;
@@ -1984,6 +1984,11 @@ static inline u64 sched_cfs_bandwidth_sl
 
 #include "sched_stats.h"
 
+static void mod_nr_running(struct rq *rq, long delta)
+{
+	rq->nr_running += delta;
+}
+
 static void inc_nr_running(struct rq *rq)
 {
 	rq->nr_running++;
@@ -2040,7 +2045,6 @@ static void activate_task(struct rq *rq,
 		rq->nr_uninterruptible--;
 
 	enqueue_task(rq, p, flags);
-	inc_nr_running(rq);
 }
 
 /*
@@ -2052,7 +2056,6 @@ static void deactivate_task(struct rq *r
 		rq->nr_uninterruptible++;
 
 	dequeue_task(rq, p, flags);
-	dec_nr_running(rq);
 }
 
 #include "sched_idletask.c"
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -76,6 +76,8 @@ unsigned int sysctl_sched_child_runs_fir
  */
 unsigned int __read_mostly sysctl_sched_compat_yield;
 
+static void account_hier_tasks(struct sched_entity *se, int delta);
+
 /*
  * SCHED_OTHER wake-up granularity.
  * (default: 1 msec * (1 + ilog(ncpus)), units: nanoseconds)
@@ -683,6 +685,40 @@ account_entity_dequeue(struct cfs_rq *cf
 	se->on_rq = 0;
 }
 
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
@@ -1099,6 +1135,7 @@ enqueue_task_fair(struct rq *rq, struct 
 		flags = ENQUEUE_WAKEUP;
 	}
 
+	account_hier_tasks(&p->se, 1);
 	hrtick_update(rq);
 }
 
@@ -1124,6 +1161,7 @@ static void dequeue_task_fair(struct rq 
 		flags |= DEQUEUE_SLEEP;
 	}
 
+	account_hier_tasks(&p->se, -1);
 	hrtick_update(rq);
 }
 
@@ -1197,6 +1235,8 @@ static u64 tg_request_cfs_quota(struct t
 	return delta;
 }
 
+static void account_hier_tasks(struct sched_entity *se, int delta);
+
 static void throttle_cfs_rq(struct cfs_rq *cfs_rq)
 {
 	struct sched_entity *se;
@@ -1214,6 +1254,7 @@ static void throttle_cfs_rq(struct cfs_r
 	if (!se->on_rq)
 		goto out_throttled;
 
+	account_hier_tasks(se, -cfs_rq->h_nr_tasks);
 	for_each_sched_entity(se) {
 		struct cfs_rq *cfs_rq = cfs_rq_of(se);
 
@@ -1244,6 +1285,7 @@ static void unthrottle_cfs_rq(struct cfs
 	cfs_rq->throttled = 0;
 	cfs_rq->throttled_timestamp = 0;
 
+	account_hier_tasks(se, cfs_rq->h_nr_tasks);
 	for_each_sched_entity(se) {
 		if (se->on_rq)
 			break;
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -882,6 +882,8 @@ enqueue_task_rt(struct rq *rq, struct ta
 
 	if (!task_current(rq, p) && p->rt.nr_cpus_allowed > 1)
 		enqueue_pushable_task(rq, p);
+
+	inc_nr_running(rq);
 }
 
 static void dequeue_task_rt(struct rq *rq, struct task_struct *p, int flags)
@@ -892,6 +894,8 @@ static void dequeue_task_rt(struct rq *r
 	dequeue_rt_entity(rt_se);
 
 	dequeue_pushable_task(rq, p);
+
+	dec_nr_running(rq);
 }
 
 /*
@@ -1754,4 +1758,3 @@ static void print_rt_stats(struct seq_fi
 	rcu_read_unlock();
 }
 #endif /* CONFIG_SCHED_DEBUG */
-
