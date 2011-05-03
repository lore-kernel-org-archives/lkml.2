Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754343Ab1EGGfu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 May 2011 02:35:50 -0400
Received: from smtp-out.google.com ([74.125.121.67]:50362 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752644Ab1EGGcd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 May 2011 02:32:33 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:user-agent:date:from:to:cc:subject:references:content-disposition;
	b=m87ZMGD/dA0OUI34yBcontHu7TVDO8vKxJBX4PTqGpZXFV4lpDU+H+aDty57NREyH
	e6jMOwvRtB1US1HuF6fOg==
Message-Id: <20110503092904.629158172@google.com>
User-Agent: quilt/0.48-1
Date: Tue, 03 May 2011 02:28:48 -0700
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
Subject: [patch 02/15] sched: hierarchical task accounting for SCHED_OTHER
References: <20110503092846.022272244@google.com>
Content-Disposition: inline; filename=sched-bwc-account_nr_running.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce hierarchal task accounting for the group scheduling case in CFS, as
well as promoting the responsibility for maintaining rq->nr_running to the
scheduling classes.

The primary motivation for this is that with scheduling classes supporting
bandwidht throttling it is possible for entities participating in trottled
sub-trees to not have root visible changes in rq->nr_running across activate
and de-activate operations.  This in turn leads to incorrect idle and 
weight-per-task load balance decisions.

This also allows us to make a small fixlet to the fastpath in pick_next_task()
under group scheduling.

Note: this issue also exists with the existing sched_rt throttling mechanism.
This patch does not address that.

Signed-off-by: Paul Turner <pjt@google.com>

---
 kernel/sched.c          |    6 ++----
 kernel/sched_fair.c     |   14 ++++++++++----
 kernel/sched_rt.c       |    5 ++++-
 kernel/sched_stoptask.c |    2 ++
 4 files changed, 18 insertions(+), 9 deletions(-)

Index: tip/kernel/sched.c
===================================================================
--- tip.orig/kernel/sched.c
+++ tip/kernel/sched.c
@@ -308,7 +308,7 @@ struct task_group root_task_group;
 /* CFS-related fields in a runqueue */
 struct cfs_rq {
 	struct load_weight load;
-	unsigned long nr_running;
+	unsigned long nr_running, h_nr_running;
 
 	u64 exec_clock;
 	u64 min_vruntime;
@@ -1793,7 +1793,6 @@ static void activate_task(struct rq *rq,
 		rq->nr_uninterruptible--;
 
 	enqueue_task(rq, p, flags);
-	inc_nr_running(rq);
 }
 
 /*
@@ -1805,7 +1804,6 @@ static void deactivate_task(struct rq *r
 		rq->nr_uninterruptible++;
 
 	dequeue_task(rq, p, flags);
-	dec_nr_running(rq);
 }
 
 #ifdef CONFIG_IRQ_TIME_ACCOUNTING
@@ -4053,7 +4051,7 @@ pick_next_task(struct rq *rq)
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
@@ -1318,7 +1318,7 @@ static inline void hrtick_update(struct 
 static void
 enqueue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 {
-	struct cfs_rq *cfs_rq;
+	struct cfs_rq *cfs_rq = NULL;
 	struct sched_entity *se = &p->se;
 
 	for_each_sched_entity(se) {
@@ -1326,16 +1326,19 @@ enqueue_task_fair(struct rq *rq, struct 
 			break;
 		cfs_rq = cfs_rq_of(se);
 		enqueue_entity(cfs_rq, se, flags);
+		cfs_rq->h_nr_running++;
 		flags = ENQUEUE_WAKEUP;
 	}
 
 	for_each_sched_entity(se) {
-		struct cfs_rq *cfs_rq = cfs_rq_of(se);
+		cfs_rq = cfs_rq_of(se);
+		cfs_rq->h_nr_running++;
 
 		update_cfs_load(cfs_rq, 0);
 		update_cfs_shares(cfs_rq);
 	}
 
+	inc_nr_running(rq);
 	hrtick_update(rq);
 }
 
@@ -1346,12 +1349,13 @@ enqueue_task_fair(struct rq *rq, struct 
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
 
 		/* Don't dequeue parent if it has other entities besides us */
 		if (cfs_rq->load.weight) {
@@ -1362,12 +1366,14 @@ static void dequeue_task_fair(struct rq 
 	}
 
 	for_each_sched_entity(se) {
-		struct cfs_rq *cfs_rq = cfs_rq_of(se);
+		cfs_rq = cfs_rq_of(se);
+		cfs_rq->h_nr_running--;
 
 		update_cfs_load(cfs_rq, 0);
 		update_cfs_shares(cfs_rq);
 	}
 
+	dec_nr_running(rq);
 	hrtick_update(rq);
 }
 
Index: tip/kernel/sched_rt.c
===================================================================
--- tip.orig/kernel/sched_rt.c
+++ tip/kernel/sched_rt.c
@@ -927,6 +927,8 @@ enqueue_task_rt(struct rq *rq, struct ta
 
 	if (!task_current(rq, p) && p->rt.nr_cpus_allowed > 1)
 		enqueue_pushable_task(rq, p);
+
+	inc_nr_running(rq);
 }
 
 static void dequeue_task_rt(struct rq *rq, struct task_struct *p, int flags)
@@ -937,6 +939,8 @@ static void dequeue_task_rt(struct rq *r
 	dequeue_rt_entity(rt_se);
 
 	dequeue_pushable_task(rq, p);
+
+	dec_nr_running(rq);
 }
 
 /*
@@ -1804,4 +1808,3 @@ static void print_rt_stats(struct seq_fi
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


