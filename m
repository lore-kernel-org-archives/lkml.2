Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932207Ab1CWDKp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 23:10:45 -0400
Received: from smtp-out.google.com ([216.239.44.51]:7756 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753860Ab1CWDKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 23:10:15 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:user-agent:date:from:to:cc:subject:references:content-disposition;
	b=Qd3Oxcf67XjEtEVULDtqckxkQjOP8K57lKdnUmyW9GqAIHOaMAX/M2a+2lWftDYDj
	rxKV9p8mcMk9d/GhUEntQ==
Message-Id: <20110323030449.732563642@google.com>
User-Agent: quilt/0.48-1
Date: Tue, 22 Mar 2011 20:03:37 -0700
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
Subject: [patch 11/15] sched: hierarchical task accounting for SCHED_OTHER
References: <20110323030326.789836913@google.com>
Content-Disposition: inline; filename=sched-bwc-account_nr_running.patch
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

This also allows us to fix a small buglet in pick_next_task() when group
scheduling is enabled.

Note: technically this issue also exists with the existing sched_rt
throttling; however due to the nearly complete provisioning of system
resources for rt scheduling this is much less common by default.

Signed-off-by: Paul Turner <pjt@google.com>

---
 kernel/sched.c          |    6 +----
 kernel/sched_fair.c     |   51 ++++++++++++++++++++++++++++++++++++++----------
 kernel/sched_rt.c       |    5 +++-
 kernel/sched_stoptask.c |    2 +
 4 files changed, 49 insertions(+), 15 deletions(-)

Index: tip/kernel/sched.c
===================================================================
--- tip.orig/kernel/sched.c
+++ tip/kernel/sched.c
@@ -329,7 +329,7 @@ struct task_group root_task_group;
 /* CFS-related fields in a runqueue */
 struct cfs_rq {
 	struct load_weight load;
-	unsigned long nr_running;
+	unsigned long nr_running, h_nr_running;
 
 	u64 exec_clock;
 	u64 min_vruntime;
@@ -1914,7 +1914,6 @@ static void activate_task(struct rq *rq,
 		rq->nr_uninterruptible--;
 
 	enqueue_task(rq, p, flags);
-	inc_nr_running(rq);
 }
 
 /*
@@ -1926,7 +1925,6 @@ static void deactivate_task(struct rq *r
 		rq->nr_uninterruptible++;
 
 	dequeue_task(rq, p, flags);
-	dec_nr_running(rq);
 }
 
 #ifdef CONFIG_IRQ_TIME_ACCOUNTING
@@ -4174,7 +4172,7 @@ pick_next_task(struct rq *rq)
 	 * Optimization: we know that if all tasks are in
 	 * the fair class we can call that function directly:
 	 */
-	if (likely(rq->nr_running == rq->cfs.nr_running)) {
+	if (likely(rq->nr_running == rq->cfs.h_nr_running)) {
 		p = fair_sched_class.pick_next_task(rq);
 		if (likely(p))
 			return p;
Index: tip/kernel/sched_fair.c
===================================================================
--- tip.orig/kernel/sched_fair.c
+++ tip/kernel/sched_fair.c
@@ -1404,9 +1404,11 @@ static int tg_throttle_down(struct task_
 
 static void throttle_cfs_rq(struct cfs_rq *cfs_rq)
 {
+	struct rq *rq = rq_of(cfs_rq);
 	struct sched_entity *se;
+	long task_delta, dequeue = 1;
 
-	se = cfs_rq->tg->se[cpu_of(rq_of(cfs_rq))];
+	se = cfs_rq->tg->se[cpu_of(rq)];
 
 	/* account load preceding throttle */
 	rcu_read_lock();
@@ -1414,17 +1416,24 @@ static void throttle_cfs_rq(struct cfs_r
 			(void*)(long)rq_of(cfs_rq)->cpu);
 	rcu_read_unlock();
 
+	task_delta = -cfs_rq->h_nr_running;
 	for_each_sched_entity(se) {
 		struct cfs_rq *qcfs_rq = cfs_rq_of(se);
 		/* throttled entity or throttle-on-deactivate */
 		if (!se->on_rq)
 			break;
 
-		dequeue_entity(qcfs_rq, se, DEQUEUE_SLEEP);
+		if (dequeue)
+			dequeue_entity(qcfs_rq, se, DEQUEUE_SLEEP);
+		qcfs_rq->h_nr_running += task_delta;
+
 		if (qcfs_rq->load.weight)
-			break;
+			dequeue = 0;
 	}
 
+	if (!se)
+		rq->nr_running += task_delta;
+
 	cfs_rq->throttled = 1;
 	cfs_rq->throttled_timestamp = rq_of(cfs_rq)->clock;
 }
@@ -1435,7 +1444,7 @@ static void unthrottle_cfs_rq(struct cfs
 	struct sched_entity *se;
 	struct tg_unthrottle_down_data udd;
 	struct cfs_bandwidth *cfs_b = tg_cfs_bandwidth(cfs_rq->tg);
-
+	int task_delta, enqueue = 1;
 	se = cfs_rq->tg->se[cpu_of(rq_of(cfs_rq))];
 
 	update_rq_clock(rq);
@@ -1454,16 +1463,22 @@ static void unthrottle_cfs_rq(struct cfs
 	if (!cfs_rq->load.weight)
 		return;
 
+	task_delta = cfs_rq->h_nr_running;
 	for_each_sched_entity(se) {
 		if (se->on_rq)
-			break;
+			enqueue = 0;
 
 		cfs_rq = cfs_rq_of(se);
-		enqueue_entity(cfs_rq, se, ENQUEUE_WAKEUP);
+		if (enqueue)
+			enqueue_entity(cfs_rq, se, ENQUEUE_WAKEUP);
+		cfs_rq->h_nr_running += task_delta;
 		if (cfs_rq_throttled(cfs_rq))
 			break;
 	}
 
+	if (!se)
+		rq->nr_running += task_delta;
+
 	/* determine whether we need to wake up potentially idle cpu */
 	if (rq->curr == rq->idle && rq->cfs.nr_running)
 		resched_task(rq->curr);
@@ -1637,7 +1652,7 @@ static inline void hrtick_update(struct 
 static void
 enqueue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 {
-	struct cfs_rq *cfs_rq;
+	struct cfs_rq *cfs_rq = NULL;
 	struct sched_entity *se = &p->se;
 
 	for_each_sched_entity(se) {
@@ -1645,6 +1660,7 @@ enqueue_task_fair(struct rq *rq, struct 
 			break;
 		cfs_rq = cfs_rq_of(se);
 		enqueue_entity(cfs_rq, se, flags);
+		cfs_rq->h_nr_running++;
 		/* end evaluation on throttled cfs_rq */
 		if (cfs_rq_throttled(cfs_rq)) {
 			se = NULL;
@@ -1655,12 +1671,19 @@ enqueue_task_fair(struct rq *rq, struct 
 	}
 
 	for_each_sched_entity(se) {
-		struct cfs_rq *cfs_rq = cfs_rq_of(se);
+		cfs_rq = cfs_rq_of(se);
+		cfs_rq->h_nr_running++;
+
+		if (cfs_rq_throttled(cfs_rq))
+			break;
 
 		update_cfs_load(cfs_rq, 0);
 		update_cfs_shares(cfs_rq);
 	}
 
+	if (!cfs_rq_throttled(cfs_rq))
+		inc_nr_running(rq);
+
 	hrtick_update(rq);
 }
 
@@ -1671,12 +1694,13 @@ enqueue_task_fair(struct rq *rq, struct 
  */
 static void dequeue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 {
-	struct cfs_rq *cfs_rq;
+	struct cfs_rq *cfs_rq = NULL;
 	struct sched_entity *se = &p->se;
 
 	for_each_sched_entity(se) {
 		cfs_rq = cfs_rq_of(se);
 		dequeue_entity(cfs_rq, se, flags);
+		cfs_rq->h_nr_running--;
 		/* end evaluation on throttled cfs_rq */
 		if (cfs_rq_throttled(cfs_rq)) {
 			se = NULL;
@@ -1692,12 +1716,19 @@ static void dequeue_task_fair(struct rq 
 	}
 
 	for_each_sched_entity(se) {
-		struct cfs_rq *cfs_rq = cfs_rq_of(se);
+		cfs_rq = cfs_rq_of(se);
+		cfs_rq->h_nr_running--;
+
+		if (cfs_rq_throttled(cfs_rq))
+			break;
 
 		update_cfs_load(cfs_rq, 0);
 		update_cfs_shares(cfs_rq);
 	}
 
+	if (!cfs_rq_throttled(cfs_rq))
+		dec_nr_running(rq);
+
 	hrtick_update(rq);
 }
 
Index: tip/kernel/sched_rt.c
===================================================================
--- tip.orig/kernel/sched_rt.c
+++ tip/kernel/sched_rt.c
@@ -910,6 +910,8 @@ enqueue_task_rt(struct rq *rq, struct ta
 
 	if (!task_current(rq, p) && p->rt.nr_cpus_allowed > 1)
 		enqueue_pushable_task(rq, p);
+
+	inc_nr_running(rq);
 }
 
 static void dequeue_task_rt(struct rq *rq, struct task_struct *p, int flags)
@@ -920,6 +922,8 @@ static void dequeue_task_rt(struct rq *r
 	dequeue_rt_entity(rt_se);
 
 	dequeue_pushable_task(rq, p);
+
+	dec_nr_running(rq);
 }
 
 /*
@@ -1787,4 +1791,3 @@ static void print_rt_stats(struct seq_fi
 	rcu_read_unlock();
 }
 #endif /* CONFIG_SCHED_DEBUG */
-
Index: tip/kernel/sched_stoptask.c
===================================================================
--- tip.orig/kernel/sched_stoptask.c
+++ tip/kernel/sched_stoptask.c
@@ -35,11 +35,13 @@ static struct task_struct *pick_next_tas
 static void
 enqueue_task_stop(struct rq *rq, struct task_struct *p, int flags)
 {
+	inc_nr_running(rq);
 }
 
 static void
 dequeue_task_stop(struct rq *rq, struct task_struct *p, int flags)
 {
+	dec_nr_running(rq);
 }
 
 static void yield_task_stop(struct rq *rq)


