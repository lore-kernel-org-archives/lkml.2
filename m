Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757212Ab0JRTQy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 15:16:54 -0400
Received: from hera.kernel.org ([140.211.167.34]:59266 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754605Ab0JRTQx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 15:16:53 -0400
Date: Mon, 18 Oct 2010 19:16:27 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, heiko.carstens@de.ibm.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, heiko.carstens@de.ibm.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <1285165776.2275.1022.camel@laptop>
References: <1285165776.2275.1022.camel@laptop>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Create special class for stop/migrate work
Message-ID: <tip-34f971f6f7988be4d014eec3e3526bee6d007ffa@git.kernel.org>
Git-Commit-ID: 34f971f6f7988be4d014eec3e3526bee6d007ffa
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 18 Oct 2010 19:16:28 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  34f971f6f7988be4d014eec3e3526bee6d007ffa
Gitweb:     http://git.kernel.org/tip/34f971f6f7988be4d014eec3e3526bee6d007ffa
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Wed, 22 Sep 2010 13:53:15 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 18 Oct 2010 18:41:58 +0200

sched: Create special class for stop/migrate work

In order to separate the stop/migrate work thread from the SCHED_FIFO
implementation, create a special class for it that is of higher priority than
SCHED_FIFO itself.

This currently solves a problem where cpu-hotplug consumes so much cpu-time
that the SCHED_FIFO class gets throttled, but has the bandwidth replenishment
timer pending on the now dead cpu.

It is also required for when we add the planned deadline scheduling class above
SCHED_FIFO, as the stop/migrate thread still needs to transcent those tasks.

Tested-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1285165776.2275.1022.camel@laptop>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c          |   54 +++++++++++++++++++----
 kernel/sched_stoptask.c |  108 +++++++++++++++++++++++++++++++++++++++++++++++
 kernel/stop_machine.c   |    8 ++-
 3 files changed, 158 insertions(+), 12 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 7f52283..5f64fed 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -486,7 +486,7 @@ struct rq {
 	 */
 	unsigned long nr_uninterruptible;
 
-	struct task_struct *curr, *idle;
+	struct task_struct *curr, *idle, *stop;
 	unsigned long next_balance;
 	struct mm_struct *prev_mm;
 
@@ -1837,7 +1837,7 @@ static inline void __set_task_cpu(struct task_struct *p, unsigned int cpu)
 
 static const struct sched_class rt_sched_class;
 
-#define sched_class_highest (&rt_sched_class)
+#define sched_class_highest (&stop_sched_class)
 #define for_each_class(class) \
    for (class = sched_class_highest; class; class = class->next)
 
@@ -1917,10 +1917,41 @@ static void deactivate_task(struct rq *rq, struct task_struct *p, int flags)
 #include "sched_idletask.c"
 #include "sched_fair.c"
 #include "sched_rt.c"
+#include "sched_stoptask.c"
 #ifdef CONFIG_SCHED_DEBUG
 # include "sched_debug.c"
 #endif
 
+void sched_set_stop_task(int cpu, struct task_struct *stop)
+{
+	struct sched_param param = { .sched_priority = MAX_RT_PRIO - 1 };
+	struct task_struct *old_stop = cpu_rq(cpu)->stop;
+
+	if (stop) {
+		/*
+		 * Make it appear like a SCHED_FIFO task, its something
+		 * userspace knows about and won't get confused about.
+		 *
+		 * Also, it will make PI more or less work without too
+		 * much confusion -- but then, stop work should not
+		 * rely on PI working anyway.
+		 */
+		sched_setscheduler_nocheck(stop, SCHED_FIFO, &param);
+
+		stop->sched_class = &stop_sched_class;
+	}
+
+	cpu_rq(cpu)->stop = stop;
+
+	if (old_stop) {
+		/*
+		 * Reset it back to a normal scheduling class so that
+		 * it can die in pieces.
+		 */
+		old_stop->sched_class = &rt_sched_class;
+	}
+}
+
 /*
  * __normal_prio - return the priority that is based on the static prio
  */
@@ -3720,17 +3751,13 @@ pick_next_task(struct rq *rq)
 			return p;
 	}
 
-	class = sched_class_highest;
-	for ( ; ; ) {
+	for_each_class(class) {
 		p = class->pick_next_task(rq);
 		if (p)
 			return p;
-		/*
-		 * Will never be NULL as the idle class always
-		 * returns a non-NULL p:
-		 */
-		class = class->next;
 	}
+
+	BUG(); /* the idle class will always have a runnable task */
 }
 
 /*
@@ -4659,6 +4686,15 @@ recheck:
 	 */
 	rq = __task_rq_lock(p);
 
+	/*
+	 * Changing the policy of the stop threads its a very bad idea
+	 */
+	if (p == rq->stop) {
+		__task_rq_unlock(rq);
+		raw_spin_unlock_irqrestore(&p->pi_lock, flags);
+		return -EINVAL;
+	}
+
 #ifdef CONFIG_RT_GROUP_SCHED
 	if (user) {
 		/*
diff --git a/kernel/sched_stoptask.c b/kernel/sched_stoptask.c
new file mode 100644
index 0000000..45bddc0
--- /dev/null
+++ b/kernel/sched_stoptask.c
@@ -0,0 +1,108 @@
+/*
+ * stop-task scheduling class.
+ *
+ * The stop task is the highest priority task in the system, it preempts
+ * everything and will be preempted by nothing.
+ *
+ * See kernel/stop_machine.c
+ */
+
+#ifdef CONFIG_SMP
+static int
+select_task_rq_stop(struct rq *rq, struct task_struct *p,
+		    int sd_flag, int flags)
+{
+	return task_cpu(p); /* stop tasks as never migrate */
+}
+#endif /* CONFIG_SMP */
+
+static void
+check_preempt_curr_stop(struct rq *rq, struct task_struct *p, int flags)
+{
+	resched_task(rq->curr); /* we preempt everything */
+}
+
+static struct task_struct *pick_next_task_stop(struct rq *rq)
+{
+	struct task_struct *stop = rq->stop;
+
+	if (stop && stop->state == TASK_RUNNING)
+		return stop;
+
+	return NULL;
+}
+
+static void
+enqueue_task_stop(struct rq *rq, struct task_struct *p, int flags)
+{
+}
+
+static void
+dequeue_task_stop(struct rq *rq, struct task_struct *p, int flags)
+{
+}
+
+static void yield_task_stop(struct rq *rq)
+{
+	BUG(); /* the stop task should never yield, its pointless. */
+}
+
+static void put_prev_task_stop(struct rq *rq, struct task_struct *prev)
+{
+}
+
+static void task_tick_stop(struct rq *rq, struct task_struct *curr, int queued)
+{
+}
+
+static void set_curr_task_stop(struct rq *rq)
+{
+}
+
+static void switched_to_stop(struct rq *rq, struct task_struct *p,
+			     int running)
+{
+	BUG(); /* its impossible to change to this class */
+}
+
+static void prio_changed_stop(struct rq *rq, struct task_struct *p,
+			      int oldprio, int running)
+{
+	BUG(); /* how!?, what priority? */
+}
+
+static unsigned int
+get_rr_interval_stop(struct rq *rq, struct task_struct *task)
+{
+	return 0;
+}
+
+/*
+ * Simple, special scheduling class for the per-CPU stop tasks:
+ */
+static const struct sched_class stop_sched_class = {
+	.next			= &rt_sched_class,
+
+	.enqueue_task		= enqueue_task_stop,
+	.dequeue_task		= dequeue_task_stop,
+	.yield_task		= yield_task_stop,
+
+	.check_preempt_curr	= check_preempt_curr_stop,
+
+	.pick_next_task		= pick_next_task_stop,
+	.put_prev_task		= put_prev_task_stop,
+
+#ifdef CONFIG_SMP
+	.select_task_rq		= select_task_rq_stop,
+#endif
+
+	.set_curr_task          = set_curr_task_stop,
+	.task_tick		= task_tick_stop,
+
+	.get_rr_interval	= get_rr_interval_stop,
+
+	.prio_changed		= prio_changed_stop,
+	.switched_to		= switched_to_stop,
+
+	/* no .task_new for stop tasks */
+};
diff --git a/kernel/stop_machine.c b/kernel/stop_machine.c
index 4372ccb..090c288 100644
--- a/kernel/stop_machine.c
+++ b/kernel/stop_machine.c
@@ -287,11 +287,12 @@ repeat:
 	goto repeat;
 }
 
+extern void sched_set_stop_task(int cpu, struct task_struct *stop);
+
 /* manage stopper for a cpu, mostly lifted from sched migration thread mgmt */
 static int __cpuinit cpu_stop_cpu_callback(struct notifier_block *nfb,
 					   unsigned long action, void *hcpu)
 {
-	struct sched_param param = { .sched_priority = MAX_RT_PRIO - 1 };
 	unsigned int cpu = (unsigned long)hcpu;
 	struct cpu_stopper *stopper = &per_cpu(cpu_stopper, cpu);
 	struct task_struct *p;
@@ -304,13 +305,13 @@ static int __cpuinit cpu_stop_cpu_callback(struct notifier_block *nfb,
 				   cpu);
 		if (IS_ERR(p))
 			return NOTIFY_BAD;
-		sched_setscheduler_nocheck(p, SCHED_FIFO, &param);
 		get_task_struct(p);
+		kthread_bind(p, cpu);
+		sched_set_stop_task(cpu, p);
 		stopper->thread = p;
 		break;
 
 	case CPU_ONLINE:
-		kthread_bind(stopper->thread, cpu);
 		/* strictly unnecessary, as first user will wake it */
 		wake_up_process(stopper->thread);
 		/* mark enabled */
@@ -325,6 +326,7 @@ static int __cpuinit cpu_stop_cpu_callback(struct notifier_block *nfb,
 	{
 		struct cpu_stop_work *work;
 
+		sched_set_stop_task(cpu, NULL);
 		/* kill the stopper */
 		kthread_stop(stopper->thread);
 		/* drain remaining works */
