Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754851Ab0IVOaP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 10:30:15 -0400
Received: from casper.infradead.org ([85.118.1.10]:57941 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754643Ab0IVOaM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 10:30:12 -0400
Subject: Re: [PATCH/RFC] timer: fix deadlock on cpu hotplug
From: Peter Zijlstra <peterz@infradead.org>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Tejun Heo <tj@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org
In-Reply-To: <1285147362.2275.896.camel@laptop>
References: <20100921142017.GA2291@osiris.boeblingen.de.ibm.com>
	 <4C98D0EB.30002@kernel.org> <1285083618.2275.884.camel@laptop>
	 <20100922083706.GA2177@osiris.boeblingen.de.ibm.com>
	 <1285147362.2275.896.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 22 Sep 2010 16:29:36 +0200
Message-ID: <1285165776.2275.1022.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-09-22 at 11:22 +0200, Peter Zijlstra wrote:

> The idea was to move it to a class of its own above SCHED_FIFO.
> 
> I'll try and get something done, but I'm heading out to LinuxCon.JP
> soon.

Something like the below, it seems to boot, build a kernel and hotplug.

Note that it also fixes a curious corner case, current mainline allows
userspace to change the scheduling priority/class of the migration
threads... something which isn't really advisable for the general health
of your system.

---
Subject: sched: Create special class for stop/migrate work
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Wed Sep 22 13:53:15 CEST 2010

In order to separate the stop/migrate work thread from the SCHED_FIFO
implementation, create a special class for it that is of higher priority
than SCHED_FIFO itself.

This currently solves a problem where cpu-hotplug consumes so much cpu-time
that the SCHED_FIFO class gets throttled, but has the bandwidth replenishment
timer pending on the now dead cpu.

It is also required for when we add the planned deadline scheduling class
above SCHED_FIFO, as the stop/migrate thread still needs to transcent those
tasks.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
---
 kernel/sched.c          |   54 ++++++++++++++++++++----
 kernel/sched_stoptask.c |  107 ++++++++++++++++++++++++++++++++++++++++++++++++
 kernel/stop_machine.c   |    6 +-
 3 files changed, 156 insertions(+), 11 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -486,7 +486,7 @@ struct rq {
 	 */
 	unsigned long nr_uninterruptible;
 
-	struct task_struct *curr, *idle;
+	struct task_struct *curr, *idle, *stop;
 	unsigned long next_balance;
 	struct mm_struct *prev_mm;
 
@@ -1837,7 +1837,7 @@ static inline void __set_task_cpu(struct
 
 static const struct sched_class rt_sched_class;
 
-#define sched_class_highest (&rt_sched_class)
+#define sched_class_highest (&stop_sched_class)
 #define for_each_class(class) \
    for (class = sched_class_highest; class; class = class->next)
 
@@ -1917,10 +1917,41 @@ static void deactivate_task(struct rq *r
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
+		 * it can die in pieces :-)
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
@@ -4659,6 +4686,15 @@ static int __sched_setscheduler(struct t
 	 */
 	rq = __task_rq_lock(p);
 
+	/*
+	 * Changing the policy of the stop threads is a very bad idea
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
Index: linux-2.6/kernel/stop_machine.c
===================================================================
--- linux-2.6.orig/kernel/stop_machine.c
+++ linux-2.6/kernel/stop_machine.c
@@ -287,11 +287,12 @@ static int cpu_stopper_thread(void *data
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
@@ -304,8 +305,8 @@ static int __cpuinit cpu_stop_cpu_callba
 				   cpu);
 		if (IS_ERR(p))
 			return NOTIFY_BAD;
-		sched_setscheduler_nocheck(p, SCHED_FIFO, &param);
 		get_task_struct(p);
+		sched_set_stop_task(cpu, p);
 		stopper->thread = p;
 		break;
 
@@ -325,6 +326,7 @@ static int __cpuinit cpu_stop_cpu_callba
 	{
 		struct cpu_stop_work *work;
 
+		sched_set_stop_task(cpu, NULL);
 		/* kill the stopper */
 		kthread_stop(stopper->thread);
 		/* drain remaining works */
Index: linux-2.6/kernel/sched_stoptask.c
===================================================================
--- /dev/null
+++ linux-2.6/kernel/sched_stoptask.c
@@ -0,0 +1,107 @@
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
+select_task_rq_stop(struct rq *rq, struct task_struct *p, int sd_flag, int flags)
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
+	BUG(); /* its impossible to change to/from this class */
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

