Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755054Ab2DFHSq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 03:18:46 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:57950 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754578Ab2DFHPT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 03:15:19 -0400
From: Juri Lelli <juri.lelli@gmail.com>
To: peterz@infradead.org, tglx@linutronix.de
Cc: mingo@redhat.com, rostedt@goodmis.org, cfriesen@nortel.com,
        oleg@redhat.com, fweisbec@gmail.com, darren@dvhart.com,
        johan.eker@ericsson.com, p.faure@akatech.ch,
        linux-kernel@vger.kernel.org, claudio@evidence.eu.com,
        michael@amarulasolutions.com, fchecconi@gmail.com,
        tommaso.cucinotta@sssup.it, juri.lelli@gmail.com,
        nicola.manica@disi.unitn.it, luca.abeni@unitn.it,
        dhaval.giani@gmail.com, hgu1972@gmail.com, paulmck@linux.vnet.ibm.com,
        raistlin@linux.it, insop.song@ericsson.com, liming.wang@windriver.com
Subject: [PATCH 04/16] sched: SCHED_DEADLINE SMP-related data structures.
Date: Fri,  6 Apr 2012 09:14:29 +0200
Message-Id: <1333696481-3433-5-git-send-email-juri.lelli@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1333696481-3433-1-git-send-email-juri.lelli@gmail.com>
References: <1333696481-3433-1-git-send-email-juri.lelli@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce data structures relevant for implementing dynamic
migration of -deadline tasks.

Mainly, this is the logic for checking if runqueues are
overloaded with -deadline tasks and for choosing where
a task should migrate, when it is the case.

Signed-off-by: Juri Lelli <juri.lelli@gmail.com>
Signed-off-by: Dario Faggioli <raistlin@linux.it>
---
 include/linux/sched.h |    1 +
 kernel/sched.c        |   50 ++++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 50 insertions(+), 1 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index a7a4276..6eb72b6 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1384,6 +1384,7 @@ struct task_struct {
 	struct list_head tasks;
 #ifdef CONFIG_SMP
 	struct plist_node pushable_tasks;
+	struct rb_node pushable_dl_tasks;
 #endif
 
 	struct mm_struct *mm, *active_mm;
diff --git a/kernel/sched.c b/kernel/sched.c
index ea67240..fd23c67 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -568,6 +568,31 @@ struct dl_rq {
 	struct rb_node *rb_leftmost;
 
 	unsigned long dl_nr_running;
+
+#ifdef CONFIG_SMP
+	/*
+	 * Deadline values of the currently executing and the
+	 * earliest ready task on this rq. Caching these facilitates
+	 * the decision wether or not a ready but not running task
+	 * should migrate somewhere else.
+	 */
+	struct {
+		u64 curr;
+		u64 next;
+	} earliest_dl;
+
+	unsigned long dl_nr_migratory;
+	unsigned long dl_nr_total;
+	int overloaded;
+
+	/*
+	 * Tasks on this rq that can be pushed away. They are kept in
+	 * an rb-tree, ordered by tasks' deadlines, with caching
+	 * of the leftmost (earliest deadline) element.
+	 */
+	struct rb_root pushable_dl_tasks_root;
+	struct rb_node *pushable_dl_tasks_leftmost;
+#endif
 };
 
 #ifdef CONFIG_SMP
@@ -588,6 +613,13 @@ struct root_domain {
 	cpumask_var_t online;
 
 	/*
+	 * The bit corresponding to a CPU gets set here if such CPU has more
+	 * than one runnable -deadline task (as it is below for RT tasks).
+	 */
+	cpumask_var_t dlo_mask;
+	atomic_t dlo_count;
+
+	/*
 	 * The "RT overload" flag: it gets set if a CPU has more than
 	 * one runnable RT task.
 	 */
@@ -3075,6 +3107,7 @@ void sched_fork(struct task_struct *p)
 #endif
 #ifdef CONFIG_SMP
 	plist_node_init(&p->pushable_tasks, MAX_PRIO);
+	RB_CLEAR_NODE(&p->pushable_dl_tasks);
 #endif
 
 	put_cpu();
@@ -6513,6 +6546,7 @@ void do_set_cpus_allowed(struct task_struct *p, const struct cpumask *new_mask)
 		if (p->sched_class && p->sched_class->set_cpus_allowed)
 			p->sched_class->set_cpus_allowed(p, new_mask);
 		p->rt.nr_cpus_allowed = cpumask_weight(new_mask);
+		p->dl.nr_cpus_allowed = cpumask_weight(new_mask);
 	}
 	cpumask_copy(&p->cpus_allowed, new_mask);
 }
@@ -7267,6 +7301,7 @@ static void free_rootdomain(struct rcu_head *rcu)
 	struct root_domain *rd = container_of(rcu, struct root_domain, rcu);
 
 	cpupri_cleanup(&rd->cpupri);
+	free_cpumask_var(rd->dlo_mask);
 	free_cpumask_var(rd->rto_mask);
 	free_cpumask_var(rd->online);
 	free_cpumask_var(rd->span);
@@ -7318,8 +7353,10 @@ static int init_rootdomain(struct root_domain *rd)
 		goto out;
 	if (!alloc_cpumask_var(&rd->online, GFP_KERNEL))
 		goto free_span;
-	if (!alloc_cpumask_var(&rd->rto_mask, GFP_KERNEL))
+	if (!alloc_cpumask_var(&rd->dlo_mask, GFP_KERNEL))
 		goto free_online;
+	if (!alloc_cpumask_var(&rd->rto_mask, GFP_KERNEL))
+		goto free_dlo_mask;
 
 	if (cpupri_init(&rd->cpupri) != 0)
 		goto free_rto_mask;
@@ -7327,6 +7364,8 @@ static int init_rootdomain(struct root_domain *rd)
 
 free_rto_mask:
 	free_cpumask_var(rd->rto_mask);
+free_dlo_mask:
+	free_cpumask_var(rd->dlo_mask);
 free_online:
 	free_cpumask_var(rd->online);
 free_span:
@@ -8489,6 +8528,15 @@ static void init_rt_rq(struct rt_rq *rt_rq, struct rq *rq)
 static void init_dl_rq(struct dl_rq *dl_rq, struct rq *rq)
 {
 	dl_rq->rb_root = RB_ROOT;
+
+#ifdef CONFIG_SMP
+	/* zero means no -deadline tasks */
+	dl_rq->earliest_dl.curr = dl_rq->earliest_dl.next = 0;
+
+	dl_rq->dl_nr_migratory = 0;
+	dl_rq->overloaded = 0;
+	dl_rq->pushable_dl_tasks_root = RB_ROOT;
+#endif
 }
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
-- 
1.7.5.4

