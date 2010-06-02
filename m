Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932465Ab0FBMVb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 08:21:31 -0400
Received: from fallback.mail.elte.hu ([157.181.151.13]:58316 "EHLO
	fallback.mail.elte.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757847Ab0FBMVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 08:21:24 -0400
Date: Wed, 2 Jun 2010 14:21:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] scheduler fixes
Message-ID: <20100602122111.GA22004@elte.hu>
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
Amit K. Arora (1):
      sched: Make sure timers have migrated before killing the migration_thread

Peter Zijlstra (2):
      sched: Fix wake_affine() vs RT tasks
      sched, trace: Fix sched_switch() prev_state argument


 include/trace/events/sched.h |   19 ++++++++++++++++++-
 kernel/sched.c               |   24 ++++++------------------
 kernel/sched_fair.c          |   22 ++++++++++++++++------
 kernel/stop_machine.c        |    2 +-
 4 files changed, 41 insertions(+), 26 deletions(-)

diff --git a/include/trace/events/sched.h b/include/trace/events/sched.h
index 4f733ec..b9e1dd6 100644
--- a/include/trace/events/sched.h
+++ b/include/trace/events/sched.h
@@ -115,6 +115,23 @@ DEFINE_EVENT(sched_wakeup_template, sched_wakeup_new,
 	     TP_PROTO(struct task_struct *p, int success),
 	     TP_ARGS(p, success));
 
+#ifdef CREATE_TRACE_POINTS
+static inline long __trace_sched_switch_state(struct task_struct *p)
+{
+	long state = p->state;
+
+#ifdef CONFIG_PREEMPT
+	/*
+	 * For all intents and purposes a preempted task is a running task.
+	 */
+	if (task_thread_info(p)->preempt_count & PREEMPT_ACTIVE)
+		state = TASK_RUNNING;
+#endif
+
+	return state;
+}
+#endif
+
 /*
  * Tracepoint for task switches, performed by the scheduler:
  */
@@ -139,7 +156,7 @@ TRACE_EVENT(sched_switch,
 		memcpy(__entry->next_comm, next->comm, TASK_COMM_LEN);
 		__entry->prev_pid	= prev->pid;
 		__entry->prev_prio	= prev->prio;
-		__entry->prev_state	= prev->state;
+		__entry->prev_state	= __trace_sched_switch_state(prev);
 		memcpy(__entry->prev_comm, prev->comm, TASK_COMM_LEN);
 		__entry->next_pid	= next->pid;
 		__entry->next_prio	= next->prio;
diff --git a/kernel/sched.c b/kernel/sched.c
index d484081..f8b8996 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -544,6 +544,8 @@ struct rq {
 	struct root_domain *rd;
 	struct sched_domain *sd;
 
+	unsigned long cpu_power;
+
 	unsigned char idle_at_tick;
 	/* For active balancing */
 	int post_schedule;
@@ -1499,24 +1501,9 @@ static unsigned long target_load(int cpu, int type)
 	return max(rq->cpu_load[type-1], total);
 }
 
-static struct sched_group *group_of(int cpu)
-{
-	struct sched_domain *sd = rcu_dereference_sched(cpu_rq(cpu)->sd);
-
-	if (!sd)
-		return NULL;
-
-	return sd->groups;
-}
-
 static unsigned long power_of(int cpu)
 {
-	struct sched_group *group = group_of(cpu);
-
-	if (!group)
-		return SCHED_LOAD_SCALE;
-
-	return group->cpu_power;
+	return cpu_rq(cpu)->cpu_power;
 }
 
 static int task_hot(struct task_struct *p, u64 now, struct sched_domain *sd);
@@ -1854,8 +1841,8 @@ static void dec_nr_running(struct rq *rq)
 static void set_load_weight(struct task_struct *p)
 {
 	if (task_has_rt_policy(p)) {
-		p->se.load.weight = prio_to_weight[0] * 2;
-		p->se.load.inv_weight = prio_to_wmult[0] >> 1;
+		p->se.load.weight = 0;
+		p->se.load.inv_weight = WMULT_CONST;
 		return;
 	}
 
@@ -7605,6 +7592,7 @@ void __init sched_init(void)
 #ifdef CONFIG_SMP
 		rq->sd = NULL;
 		rq->rd = NULL;
+		rq->cpu_power = SCHED_LOAD_SCALE;
 		rq->post_schedule = 0;
 		rq->active_balance = 0;
 		rq->next_balance = jiffies;
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 217e4a9..eed35ed 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1225,7 +1225,6 @@ static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
 	unsigned long this_load, load;
 	int idx, this_cpu, prev_cpu;
 	unsigned long tl_per_task;
-	unsigned int imbalance;
 	struct task_group *tg;
 	unsigned long weight;
 	int balanced;
@@ -1252,8 +1251,6 @@ static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
 	tg = task_group(p);
 	weight = p->se.load.weight;
 
-	imbalance = 100 + (sd->imbalance_pct - 100) / 2;
-
 	/*
 	 * In low-load situations, where prev_cpu is idle and this_cpu is idle
 	 * due to the sync cause above having dropped this_load to 0, we'll
@@ -1263,9 +1260,21 @@ static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
 	 * Otherwise check if either cpus are near enough in load to allow this
 	 * task to be woken on this_cpu.
 	 */
-	balanced = !this_load ||
-		100*(this_load + effective_load(tg, this_cpu, weight, weight)) <=
-		imbalance*(load + effective_load(tg, prev_cpu, 0, weight));
+	if (this_load) {
+		unsigned long this_eff_load, prev_eff_load;
+
+		this_eff_load = 100;
+		this_eff_load *= power_of(prev_cpu);
+		this_eff_load *= this_load +
+			effective_load(tg, this_cpu, weight, weight);
+
+		prev_eff_load = 100 + (sd->imbalance_pct - 100) / 2;
+		prev_eff_load *= power_of(this_cpu);
+		prev_eff_load *= load + effective_load(tg, prev_cpu, 0, weight);
+
+		balanced = this_eff_load <= prev_eff_load;
+	} else
+		balanced = true;
 
 	/*
 	 * If the currently running task will sleep within
@@ -2298,6 +2307,7 @@ static void update_cpu_power(struct sched_domain *sd, int cpu)
 	if (!power)
 		power = 1;
 
+	cpu_rq(cpu)->cpu_power = power;
 	sdg->cpu_power = power;
 }
 
diff --git a/kernel/stop_machine.c b/kernel/stop_machine.c
index b4e7431..70f8d90 100644
--- a/kernel/stop_machine.c
+++ b/kernel/stop_machine.c
@@ -321,7 +321,7 @@ static int __cpuinit cpu_stop_cpu_callback(struct notifier_block *nfb,
 
 #ifdef CONFIG_HOTPLUG_CPU
 	case CPU_UP_CANCELED:
-	case CPU_DEAD:
+	case CPU_POST_DEAD:
 	{
 		struct cpu_stop_work *work;
 
