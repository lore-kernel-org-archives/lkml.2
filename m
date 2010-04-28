Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753059Ab0D1LSh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 07:18:37 -0400
Received: from smtp-out.google.com ([74.125.121.35]:12282 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089Ab0D1LSe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 07:18:34 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=subject:to:from:cc:date:message-id:in-reply-to:references:
	user-agent:mime-version:content-type:
	content-transfer-encoding:x-system-of-record;
	b=QQXEXCjN1br0krLND3uIPIBq0cEz4pU2K8oStFVareQ4z5p9NZkyE3dmIbyCu/yp+
	33ivGnYC6zRY5I9qAzt0w==
Subject: [PATCH v2 6/6] sched: hierarchical task accounting for
	FAIR_GROUP_SCHED
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
Date: Wed, 28 Apr 2010 04:17:17 -0700
Message-ID: <20100428111717.7954.30963.stgit@kitami.corp.google.com>
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
---
 kernel/sched.c      |    9 ++++++---
 kernel/sched_fair.c |   42 ++++++++++++++++++++++++++++++++++++++++++
 kernel/sched_rt.c   |    5 ++++-
 3 files changed, 52 insertions(+), 4 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index ac74d3a..87fb0c0 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -368,7 +368,7 @@ static inline struct task_group *task_group(struct task_struct *p)
 /* CFS-related fields in a runqueue */
 struct cfs_rq {
 	struct load_weight load;
-	unsigned long nr_running;
+	unsigned long nr_running, h_nr_tasks;
 
 	u64 exec_clock;
 	u64 min_vruntime;
@@ -1967,6 +1967,11 @@ static inline u64 sched_cfs_bandwidth_slice(void)
 
 #include "sched_stats.h"
 
+static void mod_nr_running(struct rq *rq, long delta)
+{
+	rq->nr_running += delta;
+}
+
 static void inc_nr_running(struct rq *rq)
 {
 	rq->nr_running++;
@@ -2042,7 +2047,6 @@ static void activate_task(struct rq *rq, struct task_struct *p, int wakeup)
 		rq->nr_uninterruptible--;
 
 	enqueue_task(rq, p, wakeup, false);
-	inc_nr_running(rq);
 }
 
 /*
@@ -2054,7 +2058,6 @@ static void deactivate_task(struct rq *rq, struct task_struct *p, int sleep)
 		rq->nr_uninterruptible++;
 
 	dequeue_task(rq, p, sleep);
-	dec_nr_running(rq);
 }
 
 #include "sched_idletask.c"
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index edea44e..eb6ed15 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -76,6 +76,8 @@ unsigned int sysctl_sched_child_runs_first __read_mostly;
  */
 unsigned int __read_mostly sysctl_sched_compat_yield;
 
+static void account_hier_tasks(struct sched_entity *se, int delta);
+
 /*
  * SCHED_OTHER wake-up granularity.
  * (default: 1 msec * (1 + ilog(ncpus)), units: nanoseconds)
@@ -682,6 +684,40 @@ account_entity_dequeue(struct cfs_rq *cfs_rq, struct sched_entity *se)
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
@@ -1117,6 +1153,7 @@ enqueue_task_fair(struct rq *rq, struct task_struct *p, int wakeup, bool head)
 		flags = ENQUEUE_WAKEUP;
 	}
 
+	account_hier_tasks(&p->se, 1);
 	hrtick_update(rq);
 }
 
@@ -1142,6 +1179,7 @@ static void dequeue_task_fair(struct rq *rq, struct task_struct *p, int sleep)
 		sleep = 1;
 	}
 
+	account_hier_tasks(&p->se, -1);
 	hrtick_update(rq);
 }
 
@@ -1215,12 +1253,15 @@ static u64 tg_request_cfs_quota(struct task_group *tg)
 	return delta;
 }
 
+static void account_hier_tasks(struct sched_entity *se, int delta);
+
 static void throttle_cfs_rq(struct cfs_rq *cfs_rq)
 {
 	struct sched_entity *se;
 
 	se = cfs_rq->tg->se[cpu_of(rq_of(cfs_rq))];
 
+	account_hier_tasks(se, -cfs_rq->h_nr_tasks);
 	for_each_sched_entity(se) {
 		struct cfs_rq *cfs_rq = cfs_rq_of(se);
 
@@ -1249,6 +1290,7 @@ static void unthrottle_cfs_rq(struct cfs_rq *cfs_rq)
 	cfs_rq->throttled = 0;
 	cfs_rq->throttled_timestamp = 0;
 
+	account_hier_tasks(se, cfs_rq->h_nr_tasks);
 	for_each_sched_entity(se) {
 		if (se->on_rq)
 			break;
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 15bbc45..c908bc0 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -882,6 +882,8 @@ enqueue_task_rt(struct rq *rq, struct task_struct *p, int wakeup, bool head)
 
 	if (!task_current(rq, p) && p->rt.nr_cpus_allowed > 1)
 		enqueue_pushable_task(rq, p);
+
+	inc_nr_running(rq);
 }
 
 static void dequeue_task_rt(struct rq *rq, struct task_struct *p, int sleep)
@@ -892,6 +894,8 @@ static void dequeue_task_rt(struct rq *rq, struct task_struct *p, int sleep)
 	dequeue_rt_entity(rt_se);
 
 	dequeue_pushable_task(rq, p);
+
+	dec_nr_running(rq);
 }
 
 /*
@@ -1758,4 +1762,3 @@ static void print_rt_stats(struct seq_file *m, int cpu)
 	rcu_read_unlock();
 }
 #endif /* CONFIG_SCHED_DEBUG */
-

