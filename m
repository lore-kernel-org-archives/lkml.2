Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759436Ab0KPXKq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 18:10:46 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:47024 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758447Ab0KPXKo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 18:10:44 -0500
Date: Wed, 17 Nov 2010 00:10:37 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] scheduler fixes
Message-ID: <20101116231037.GA18656@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest sched-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git sched-fixes-for-linus

 Thanks,

	Ingo

------------------>
Peter Zijlstra (2):
      sched: Fix runnable condition for stoptask
      sched: Fix cross-sched-class wakeup preemption

Suresh Siddha (1):
      sched: Use group weight, idle cpu metrics to fix imbalances during idle


 include/linux/sched.h   |    1 +
 kernel/sched.c          |   39 ++++++++++++++++++++++++++++-----------
 kernel/sched_fair.c     |   40 +++++++++++++++++++++++++++++++---------
 kernel/sched_stoptask.c |    4 ++--
 4 files changed, 62 insertions(+), 22 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index d0036e5..2c79e92 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -862,6 +862,7 @@ struct sched_group {
 	 * single CPU.
 	 */
 	unsigned int cpu_power, cpu_power_orig;
+	unsigned int group_weight;
 
 	/*
 	 * The CPUs this group covers.
diff --git a/kernel/sched.c b/kernel/sched.c
index aa14a56..dc91a4d 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -560,18 +560,8 @@ struct rq {
 
 static DEFINE_PER_CPU_SHARED_ALIGNED(struct rq, runqueues);
 
-static inline
-void check_preempt_curr(struct rq *rq, struct task_struct *p, int flags)
-{
-	rq->curr->sched_class->check_preempt_curr(rq, p, flags);
 
-	/*
-	 * A queue event has occurred, and we're going to schedule.  In
-	 * this case, we can save a useless back to back clock update.
-	 */
-	if (test_tsk_need_resched(p))
-		rq->skip_clock_update = 1;
-}
+static void check_preempt_curr(struct rq *rq, struct task_struct *p, int flags);
 
 static inline int cpu_of(struct rq *rq)
 {
@@ -2118,6 +2108,31 @@ static inline void check_class_changed(struct rq *rq, struct task_struct *p,
 		p->sched_class->prio_changed(rq, p, oldprio, running);
 }
 
+static void check_preempt_curr(struct rq *rq, struct task_struct *p, int flags)
+{
+	const struct sched_class *class;
+
+	if (p->sched_class == rq->curr->sched_class) {
+		rq->curr->sched_class->check_preempt_curr(rq, p, flags);
+	} else {
+		for_each_class(class) {
+			if (class == rq->curr->sched_class)
+				break;
+			if (class == p->sched_class) {
+				resched_task(rq->curr);
+				break;
+			}
+		}
+	}
+
+	/*
+	 * A queue event has occurred, and we're going to schedule.  In
+	 * this case, we can save a useless back to back clock update.
+	 */
+	if (test_tsk_need_resched(rq->curr))
+		rq->skip_clock_update = 1;
+}
+
 #ifdef CONFIG_SMP
 /*
  * Is this task likely cache-hot:
@@ -6960,6 +6975,8 @@ static void init_sched_groups_power(int cpu, struct sched_domain *sd)
 	if (cpu != group_first_cpu(sd->groups))
 		return;
 
+	sd->groups->group_weight = cpumask_weight(sched_group_cpus(sd->groups));
+
 	child = sd->child;
 
 	sd->groups->cpu_power = 0;
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index f4f6a83..52ab113 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1654,12 +1654,6 @@ static void check_preempt_wakeup(struct rq *rq, struct task_struct *p, int wake_
 	struct cfs_rq *cfs_rq = task_cfs_rq(curr);
 	int scale = cfs_rq->nr_running >= sched_nr_latency;
 
-	if (unlikely(rt_prio(p->prio)))
-		goto preempt;
-
-	if (unlikely(p->sched_class != &fair_sched_class))
-		return;
-
 	if (unlikely(se == pse))
 		return;
 
@@ -2035,13 +2029,16 @@ struct sd_lb_stats {
 	unsigned long this_load_per_task;
 	unsigned long this_nr_running;
 	unsigned long this_has_capacity;
+	unsigned int  this_idle_cpus;
 
 	/* Statistics of the busiest group */
+	unsigned int  busiest_idle_cpus;
 	unsigned long max_load;
 	unsigned long busiest_load_per_task;
 	unsigned long busiest_nr_running;
 	unsigned long busiest_group_capacity;
 	unsigned long busiest_has_capacity;
+	unsigned int  busiest_group_weight;
 
 	int group_imb; /* Is there imbalance in this sd */
 #if defined(CONFIG_SCHED_MC) || defined(CONFIG_SCHED_SMT)
@@ -2063,6 +2060,8 @@ struct sg_lb_stats {
 	unsigned long sum_nr_running; /* Nr tasks running in the group */
 	unsigned long sum_weighted_load; /* Weighted load of group's tasks */
 	unsigned long group_capacity;
+	unsigned long idle_cpus;
+	unsigned long group_weight;
 	int group_imb; /* Is there an imbalance in the group ? */
 	int group_has_capacity; /* Is there extra capacity in the group? */
 };
@@ -2431,7 +2430,8 @@ static inline void update_sg_lb_stats(struct sched_domain *sd,
 		sgs->group_load += load;
 		sgs->sum_nr_running += rq->nr_running;
 		sgs->sum_weighted_load += weighted_cpuload(i);
-
+		if (idle_cpu(i))
+			sgs->idle_cpus++;
 	}
 
 	/*
@@ -2469,6 +2469,7 @@ static inline void update_sg_lb_stats(struct sched_domain *sd,
 	sgs->group_capacity = DIV_ROUND_CLOSEST(group->cpu_power, SCHED_LOAD_SCALE);
 	if (!sgs->group_capacity)
 		sgs->group_capacity = fix_small_capacity(sd, group);
+	sgs->group_weight = group->group_weight;
 
 	if (sgs->group_capacity > sgs->sum_nr_running)
 		sgs->group_has_capacity = 1;
@@ -2576,13 +2577,16 @@ static inline void update_sd_lb_stats(struct sched_domain *sd, int this_cpu,
 			sds->this_nr_running = sgs.sum_nr_running;
 			sds->this_load_per_task = sgs.sum_weighted_load;
 			sds->this_has_capacity = sgs.group_has_capacity;
+			sds->this_idle_cpus = sgs.idle_cpus;
 		} else if (update_sd_pick_busiest(sd, sds, sg, &sgs, this_cpu)) {
 			sds->max_load = sgs.avg_load;
 			sds->busiest = sg;
 			sds->busiest_nr_running = sgs.sum_nr_running;
+			sds->busiest_idle_cpus = sgs.idle_cpus;
 			sds->busiest_group_capacity = sgs.group_capacity;
 			sds->busiest_load_per_task = sgs.sum_weighted_load;
 			sds->busiest_has_capacity = sgs.group_has_capacity;
+			sds->busiest_group_weight = sgs.group_weight;
 			sds->group_imb = sgs.group_imb;
 		}
 
@@ -2860,8 +2864,26 @@ find_busiest_group(struct sched_domain *sd, int this_cpu,
 	if (sds.this_load >= sds.avg_load)
 		goto out_balanced;
 
-	if (100 * sds.max_load <= sd->imbalance_pct * sds.this_load)
-		goto out_balanced;
+	/*
+	 * In the CPU_NEWLY_IDLE, use imbalance_pct to be conservative.
+	 * And to check for busy balance use !idle_cpu instead of
+	 * CPU_NOT_IDLE. This is because HT siblings will use CPU_NOT_IDLE
+	 * even when they are idle.
+	 */
+	if (idle == CPU_NEWLY_IDLE || !idle_cpu(this_cpu)) {
+		if (100 * sds.max_load <= sd->imbalance_pct * sds.this_load)
+			goto out_balanced;
+	} else {
+		/*
+		 * This cpu is idle. If the busiest group load doesn't
+		 * have more tasks than the number of available cpu's and
+		 * there is no imbalance between this and busiest group
+		 * wrt to idle cpu's, it is balanced.
+		 */
+		if ((sds.this_idle_cpus  <= sds.busiest_idle_cpus + 1) &&
+		    sds.busiest_nr_running <= sds.busiest_group_weight)
+			goto out_balanced;
+	}
 
 force_balance:
 	/* Looks like there is an imbalance. Compute it */
diff --git a/kernel/sched_stoptask.c b/kernel/sched_stoptask.c
index 45bddc0..2bf6b47 100644
--- a/kernel/sched_stoptask.c
+++ b/kernel/sched_stoptask.c
@@ -19,14 +19,14 @@ select_task_rq_stop(struct rq *rq, struct task_struct *p,
 static void
 check_preempt_curr_stop(struct rq *rq, struct task_struct *p, int flags)
 {
-	resched_task(rq->curr); /* we preempt everything */
+	/* we're never preempted */
 }
 
 static struct task_struct *pick_next_task_stop(struct rq *rq)
 {
 	struct task_struct *stop = rq->stop;
 
-	if (stop && stop->state == TASK_RUNNING)
+	if (stop && stop->se.on_rq)
 		return stop;
 
 	return NULL;
