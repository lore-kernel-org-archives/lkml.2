Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753696Ab1HNQQN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 12:16:13 -0400
Received: from hera.kernel.org ([140.211.167.34]:43414 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751858Ab1HNQQJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 12:16:09 -0400
Date: Sun, 14 Aug 2011 16:15:44 GMT
From: tip-bot for Paul Turner <pjt@google.com>
Message-ID: <tip-953bfcd10e6f3697233e8e5128c611d275da39c1@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, seto.hidetoshi@jp.fujitsu.com, pjt@google.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        seto.hidetoshi@jp.fujitsu.com, a.p.zijlstra@chello.nl, pjt@google.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20110721184756.878333391@google.com>
References: <20110721184756.878333391@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Implement hierarchical task accounting for SCHED_OTHER
Git-Commit-ID: 953bfcd10e6f3697233e8e5128c611d275da39c1
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 14 Aug 2011 16:15:47 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  953bfcd10e6f3697233e8e5128c611d275da39c1
Gitweb:     http://git.kernel.org/tip/953bfcd10e6f3697233e8e5128c611d275da39c1
Author:     Paul Turner <pjt@google.com>
AuthorDate: Thu, 21 Jul 2011 09:43:27 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 14 Aug 2011 12:01:13 +0200

sched: Implement hierarchical task accounting for SCHED_OTHER

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
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20110721184756.878333391@google.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c          |    6 ++----
 kernel/sched_fair.c     |    6 ++++++
 kernel/sched_rt.c       |    5 ++++-
 kernel/sched_stoptask.c |    2 ++
 4 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index cf427bb..cd1a531 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -311,7 +311,7 @@ struct task_group root_task_group;
 /* CFS-related fields in a runqueue */
 struct cfs_rq {
 	struct load_weight load;
-	unsigned long nr_running;
+	unsigned long nr_running, h_nr_running;
 
 	u64 exec_clock;
 	u64 min_vruntime;
@@ -1802,7 +1802,6 @@ static void activate_task(struct rq *rq, struct task_struct *p, int flags)
 		rq->nr_uninterruptible--;
 
 	enqueue_task(rq, p, flags);
-	inc_nr_running(rq);
 }
 
 /*
@@ -1814,7 +1813,6 @@ static void deactivate_task(struct rq *rq, struct task_struct *p, int flags)
 		rq->nr_uninterruptible++;
 
 	dequeue_task(rq, p, flags);
-	dec_nr_running(rq);
 }
 
 #ifdef CONFIG_IRQ_TIME_ACCOUNTING
@@ -4258,7 +4256,7 @@ pick_next_task(struct rq *rq)
 	 * Optimization: we know that if all tasks are in
 	 * the fair class we can call that function directly:
 	 */
-	if (likely(rq->nr_running == rq->cfs.nr_running)) {
+	if (likely(rq->nr_running == rq->cfs.h_nr_running)) {
 		p = fair_sched_class.pick_next_task(rq);
 		if (likely(p))
 			return p;
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index f4b732a..f86b0cb 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1310,16 +1310,19 @@ enqueue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 			break;
 		cfs_rq = cfs_rq_of(se);
 		enqueue_entity(cfs_rq, se, flags);
+		cfs_rq->h_nr_running++;
 		flags = ENQUEUE_WAKEUP;
 	}
 
 	for_each_sched_entity(se) {
 		cfs_rq = cfs_rq_of(se);
+		cfs_rq->h_nr_running++;
 
 		update_cfs_load(cfs_rq, 0);
 		update_cfs_shares(cfs_rq);
 	}
 
+	inc_nr_running(rq);
 	hrtick_update(rq);
 }
 
@@ -1339,6 +1342,7 @@ static void dequeue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 	for_each_sched_entity(se) {
 		cfs_rq = cfs_rq_of(se);
 		dequeue_entity(cfs_rq, se, flags);
+		cfs_rq->h_nr_running--;
 
 		/* Don't dequeue parent if it has other entities besides us */
 		if (cfs_rq->load.weight) {
@@ -1358,11 +1362,13 @@ static void dequeue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 
 	for_each_sched_entity(se) {
 		cfs_rq = cfs_rq_of(se);
+		cfs_rq->h_nr_running--;
 
 		update_cfs_load(cfs_rq, 0);
 		update_cfs_shares(cfs_rq);
 	}
 
+	dec_nr_running(rq);
 	hrtick_update(rq);
 }
 
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index a8c207f..a9d3c6b 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -936,6 +936,8 @@ enqueue_task_rt(struct rq *rq, struct task_struct *p, int flags)
 
 	if (!task_current(rq, p) && p->rt.nr_cpus_allowed > 1)
 		enqueue_pushable_task(rq, p);
+
+	inc_nr_running(rq);
 }
 
 static void dequeue_task_rt(struct rq *rq, struct task_struct *p, int flags)
@@ -946,6 +948,8 @@ static void dequeue_task_rt(struct rq *rq, struct task_struct *p, int flags)
 	dequeue_rt_entity(rt_se);
 
 	dequeue_pushable_task(rq, p);
+
+	dec_nr_running(rq);
 }
 
 /*
@@ -1841,4 +1845,3 @@ static void print_rt_stats(struct seq_file *m, int cpu)
 	rcu_read_unlock();
 }
 #endif /* CONFIG_SCHED_DEBUG */
-
diff --git a/kernel/sched_stoptask.c b/kernel/sched_stoptask.c
index 6f43763..8b44e7f 100644
--- a/kernel/sched_stoptask.c
+++ b/kernel/sched_stoptask.c
@@ -34,11 +34,13 @@ static struct task_struct *pick_next_task_stop(struct rq *rq)
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
