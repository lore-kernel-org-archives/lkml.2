Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754601Ab1GGFek (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 01:34:40 -0400
Received: from smtp-out.google.com ([74.125.121.67]:3643 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753363Ab1GGFdV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 01:33:21 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:user-agent:date:from:to:cc:subject:references:content-disposition;
	b=CtEYjAds/4r0bZZ88NHJhwxK8El6Ot+xOKAW1JhJJ2RFr99CJZd27XklZ9b/GxTyu
	GIk5hg+RBoMsE55oV7OvQ==
Message-Id: <20110707053059.895748346@google.com>
User-Agent: quilt/0.48-1
Date: Wed, 06 Jul 2011 22:30:38 -0700
From: Paul Turner <pjt@google.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>,
        Hu Tao <hutao@cn.fujitsu.com>
Subject: [patch 02/17] sched: hierarchical task accounting for SCHED_OTHER
References: <20110707053036.173186930@google.com>
Content-Disposition: inline; filename=sched-bwc-account_nr_running.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce hierarchical task accounting for the group scheduling case in CFS, as
well as promoting the responsibility for maintaining rq->nr_running to the
scheduling classes.

The primary motivation for this is that with scheduling classes supporting
bandwidth throttling it is possible for entities participating in throttled
sub-trees to not have root visible changes in rq->nr_running across activate
and de-activate operations.  This in turn leads to incorrect idle and 
weight-per-task load balance decisions.

This also allows us to make a small fixlet to the fastpath in pick_next_task()
under group scheduling.

Note: this issue also exists with the existing sched_rt throttling mechanism.
This patch does not address that.

Signed-off-by: Paul Turner <pjt@google.com>
Reviewed-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>

---
 kernel/sched.c          |    6 ++----
 kernel/sched_fair.c     |   10 ++++++++--
 kernel/sched_rt.c       |    5 ++++-
 kernel/sched_stoptask.c |    2 ++
 4 files changed, 16 insertions(+), 7 deletions(-)

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
@@ -1830,7 +1830,6 @@ static void activate_task(struct rq *rq,
 		rq->nr_uninterruptible--;
 
 	enqueue_task(rq, p, flags);
-	inc_nr_running(rq);
 }
 
 /*
@@ -1842,7 +1841,6 @@ static void deactivate_task(struct rq *r
 		rq->nr_uninterruptible++;
 
 	dequeue_task(rq, p, flags);
-	dec_nr_running(rq);
 }
 
 #ifdef CONFIG_IRQ_TIME_ACCOUNTING
@@ -4194,7 +4192,7 @@ pick_next_task(struct rq *rq)
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
@@ -1332,16 +1332,19 @@ enqueue_task_fair(struct rq *rq, struct 
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
 
@@ -1361,6 +1364,7 @@ static void dequeue_task_fair(struct rq 
 	for_each_sched_entity(se) {
 		cfs_rq = cfs_rq_of(se);
 		dequeue_entity(cfs_rq, se, flags);
+		cfs_rq->h_nr_running--;
 
 		/* Don't dequeue parent if it has other entities besides us */
 		if (cfs_rq->load.weight) {
@@ -1379,12 +1383,14 @@ static void dequeue_task_fair(struct rq 
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
@@ -961,6 +961,8 @@ enqueue_task_rt(struct rq *rq, struct ta
 
 	if (!task_current(rq, p) && p->rt.nr_cpus_allowed > 1)
 		enqueue_pushable_task(rq, p);
+
+	inc_nr_running(rq);
 }
 
 static void dequeue_task_rt(struct rq *rq, struct task_struct *p, int flags)
@@ -971,6 +973,8 @@ static void dequeue_task_rt(struct rq *r
 	dequeue_rt_entity(rt_se);
 
 	dequeue_pushable_task(rq, p);
+
+	dec_nr_running(rq);
 }
 
 /*
@@ -1863,4 +1867,3 @@ static void print_rt_stats(struct seq_fi
 	rcu_read_unlock();
 }
 #endif /* CONFIG_SCHED_DEBUG */
-
Index: tip/kernel/sched_stoptask.c
===================================================================
--- tip.orig/kernel/sched_stoptask.c
+++ tip/kernel/sched_stoptask.c
@@ -34,11 +34,13 @@ static struct task_struct *pick_next_tas
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


