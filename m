Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757396Ab1K3Bz1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 20:55:27 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:47847 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757133Ab1K3BzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 20:55:24 -0500
X-Authority-Analysis: v=2.0 cv=Xd0LPfF5 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=6AuU5v3x7YAA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=pgwE-pyy-5bDZaAI-LAA:9 a=WZjA7hvAob9UQLfOI_oA:7 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Subject: [PATCH RT] tasklet/rt: Prevent tasklets from going into infinite
 spin in RT
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
        Clark Williams <williams@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 29 Nov 2011 20:55:20 -0500
Message-ID: <1322618120.17003.104.camel@frodo>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

I forward ported this code from 2.6.33.9-rt31, but I think you were the
original author, as I found most of this code in the
"tasklet-redesign.patch" from my broken out 2.6.24-rt patches. I
committed it into my git tree (stable-rt) under your name, and added the
Signed-off-by that you had in that patch, if you have and objections,
please let me know. This patch should never see mainline, but it will
probably be going into the -rt branch. I wrote up this change log, if
there's something you don't like in it, let me know and I'll fix it.

Luis and Clark (I love saying that),

I booted this patch against 3.0-rt stable, and it didn't crash ;)
Could you apply it and see if it fixes the hang that you've been seeing.

Thanks,

-- Steve

commit 8a69de1b881e32b2a23452e6f25c39587c6f5e0e
Author: Ingo Molnar <mingo@elte.hu>
Date:   Tue Nov 29 20:18:22 2011 -0500

    tasklet/rt: Prevent tasklets from going into infinite spin in RT
    
    When CONFIG_PREEMPT_RT_FULL is enabled, tasklets run as threads,
    and spinlocks turn are mutexes. But this can cause issues with
    tasks disabling tasklets. A tasklet runs under ksoftirqd, and
    if a tasklets are disabled with tasklet_disable(), the tasklet
    count is increased. When a tasklet runs, it checks this counter
    and if it is set, it adds itself back on the softirq queue and
    returns.
    
    The problem arises in RT because ksoftirq will see that a softirq
    is ready to run (the tasklet softirq just re-armed itself), and will
    not sleep, but instead run the softirqs again. The tasklet softirq
    will still see that the count is non-zero and will not execute
    the tasklet and requeue itself on the softirq again, which will
    cause ksoftirqd to run it again and again and again.
    
    It gets worse because ksoftirqd runs as a real-time thread.
    If it preempted the task that disabled tasklets, and that task
    has migration disabled, or can't run for other reasons, the tasklet
    softirq will never run because the count will never be zero, and
    ksoftirqd will go into an infinite loop. As an RT task, it this
    becomes a big problem.
    
    This is a hack solution to have tasklet_disable stop tasklets, and
    when a tasklet runs, instead of requeueing the tasklet softirqd
    it delays it. When tasklet_enable() is called, and tasklets are
    waiting, then the tasklet_enable() will kick the tasklets to continue.
    This prevents the lock up from ksoftirq going into an infinite loop.
    
    Signed-off-by: Ingo Molnar <mingo@elte.hu>
    [ ported to 3.0-rt ]
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index a62158f..3142442 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -501,8 +501,9 @@ extern void __send_remote_softirq(struct call_single_data *cp, int cpu,
      to be executed on some cpu at least once after this.
    * If the tasklet is already scheduled, but its execution is still not
      started, it will be executed only once.
-   * If this tasklet is already running on another CPU (or schedule is called
-     from tasklet itself), it is rescheduled for later.
+   * If this tasklet is already running on another CPU, it is rescheduled
+     for later.
+   * Schedule must not be called from the tasklet itself (a lockup occurs)
    * Tasklet is strictly serialized wrt itself, but not
      wrt another tasklets. If client needs some intertask synchronization,
      he makes it with spinlocks.
@@ -527,27 +528,36 @@ struct tasklet_struct name = { NULL, 0, ATOMIC_INIT(1), func, data }
 enum
 {
 	TASKLET_STATE_SCHED,	/* Tasklet is scheduled for execution */
-	TASKLET_STATE_RUN	/* Tasklet is running (SMP only) */
+	TASKLET_STATE_RUN,	/* Tasklet is running (SMP only) */
+	TASKLET_STATE_PENDING	/* Tasklet is pending */
 };
 
-#ifdef CONFIG_SMP
+#define TASKLET_STATEF_SCHED	(1 << TASKLET_STATE_SCHED)
+#define TASKLET_STATEF_RUN	(1 << TASKLET_STATE_RUN)
+#define TASKLET_STATEF_PENDING	(1 << TASKLET_STATE_PENDING)
+
+#if defined(CONFIG_SMP) || defined(CONFIG_PREEMPT_RT_FULL)
 static inline int tasklet_trylock(struct tasklet_struct *t)
 {
 	return !test_and_set_bit(TASKLET_STATE_RUN, &(t)->state);
 }
 
+static inline int tasklet_tryunlock(struct tasklet_struct *t)
+{
+	return cmpxchg(&t->state, TASKLET_STATEF_RUN, 0) == TASKLET_STATEF_RUN;
+}
+
 static inline void tasklet_unlock(struct tasklet_struct *t)
 {
 	smp_mb__before_clear_bit(); 
 	clear_bit(TASKLET_STATE_RUN, &(t)->state);
 }
 
-static inline void tasklet_unlock_wait(struct tasklet_struct *t)
-{
-	while (test_bit(TASKLET_STATE_RUN, &(t)->state)) { barrier(); }
-}
+extern void tasklet_unlock_wait(struct tasklet_struct *t);
+
 #else
 #define tasklet_trylock(t) 1
+#define tasklet_tryunlock(t)	1
 #define tasklet_unlock_wait(t) do { } while (0)
 #define tasklet_unlock(t) do { } while (0)
 #endif
@@ -596,17 +606,8 @@ static inline void tasklet_disable(struct tasklet_struct *t)
 	smp_mb();
 }
 
-static inline void tasklet_enable(struct tasklet_struct *t)
-{
-	smp_mb__before_atomic_dec();
-	atomic_dec(&t->count);
-}
-
-static inline void tasklet_hi_enable(struct tasklet_struct *t)
-{
-	smp_mb__before_atomic_dec();
-	atomic_dec(&t->count);
-}
+extern  void tasklet_enable(struct tasklet_struct *t);
+extern  void tasklet_hi_enable(struct tasklet_struct *t);
 
 extern void tasklet_kill(struct tasklet_struct *t);
 extern void tasklet_kill_immediate(struct tasklet_struct *t, unsigned int cpu);
diff --git a/kernel/softirq.c b/kernel/softirq.c
index 026a283..3489d06 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -21,6 +21,7 @@
 #include <linux/freezer.h>
 #include <linux/kthread.h>
 #include <linux/rcupdate.h>
+#include <linux/delay.h>
 #include <linux/ftrace.h>
 #include <linux/smp.h>
 #include <linux/tick.h>
@@ -670,15 +671,45 @@ struct tasklet_head
 static DEFINE_PER_CPU(struct tasklet_head, tasklet_vec);
 static DEFINE_PER_CPU(struct tasklet_head, tasklet_hi_vec);
 
+static void inline
+__tasklet_common_schedule(struct tasklet_struct *t, struct tasklet_head *head, unsigned int nr)
+{
+	if (tasklet_trylock(t)) {
+again:
+		/* We may have been preempted before tasklet_trylock
+		 * and __tasklet_action may have already run.
+		 * So double check the sched bit while the takslet
+		 * is locked before adding it to the list.
+		 */
+		if (test_bit(TASKLET_STATE_SCHED, &t->state)) {
+			t->next = NULL;
+			*head->tail = t;
+			head->tail = &(t->next);
+			raise_softirq_irqoff(nr);
+			tasklet_unlock(t);
+		} else {
+			/* This is subtle. If we hit the corner case above
+			 * It is possible that we get preempted right here,
+			 * and another task has successfully called
+			 * tasklet_schedule(), then this function, and
+			 * failed on the trylock. Thus we must be sure
+			 * before releasing the tasklet lock, that the
+			 * SCHED_BIT is clear. Otherwise the tasklet
+			 * may get its SCHED_BIT set, but not added to the
+			 * list
+			 */
+			if (!tasklet_tryunlock(t))
+				goto again;
+		}
+	}
+}
+
 void __tasklet_schedule(struct tasklet_struct *t)
 {
 	unsigned long flags;
 
 	local_irq_save(flags);
-	t->next = NULL;
-	*__this_cpu_read(tasklet_vec.tail) = t;
-	__this_cpu_write(tasklet_vec.tail, &(t->next));
-	raise_softirq_irqoff(TASKLET_SOFTIRQ);
+	__tasklet_common_schedule(t, &__get_cpu_var(tasklet_vec), TASKLET_SOFTIRQ);
 	local_irq_restore(flags);
 }
 
@@ -689,10 +720,7 @@ void __tasklet_hi_schedule(struct tasklet_struct *t)
 	unsigned long flags;
 
 	local_irq_save(flags);
-	t->next = NULL;
-	*__this_cpu_read(tasklet_hi_vec.tail) = t;
-	__this_cpu_write(tasklet_hi_vec.tail,  &(t->next));
-	raise_softirq_irqoff(HI_SOFTIRQ);
+	__tasklet_common_schedule(t, &__get_cpu_var(tasklet_hi_vec), HI_SOFTIRQ);
 	local_irq_restore(flags);
 }
 
@@ -700,50 +728,119 @@ EXPORT_SYMBOL(__tasklet_hi_schedule);
 
 void __tasklet_hi_schedule_first(struct tasklet_struct *t)
 {
-	BUG_ON(!irqs_disabled());
-
-	t->next = __this_cpu_read(tasklet_hi_vec.head);
-	__this_cpu_write(tasklet_hi_vec.head, t);
-	__raise_softirq_irqoff(HI_SOFTIRQ);
+	__tasklet_hi_schedule(t);
 }
 
 EXPORT_SYMBOL(__tasklet_hi_schedule_first);
+ 
+void  tasklet_enable(struct tasklet_struct *t)
+{
+	if (!atomic_dec_and_test(&t->count))
+		return;
+	if (test_and_clear_bit(TASKLET_STATE_PENDING, &t->state))
+		tasklet_schedule(t);
+}
+ 
+EXPORT_SYMBOL(tasklet_enable);
 
-static void tasklet_action(struct softirq_action *a)
+void  tasklet_hi_enable(struct tasklet_struct *t)
 {
-	struct tasklet_struct *list;
+	if (!atomic_dec_and_test(&t->count))
+		return;
+	if (test_and_clear_bit(TASKLET_STATE_PENDING, &t->state))
+		tasklet_hi_schedule(t);
+}
 
-	local_irq_disable();
-	list = __this_cpu_read(tasklet_vec.head);
-	__this_cpu_write(tasklet_vec.head, NULL);
-	__this_cpu_write(tasklet_vec.tail, &__get_cpu_var(tasklet_vec).head);
-	local_irq_enable();
+EXPORT_SYMBOL(tasklet_hi_enable);
+
+static void
+__tasklet_action(struct softirq_action *a, struct tasklet_struct *list)
+{
+	int loops = 1000000;
 
 	while (list) {
 		struct tasklet_struct *t = list;
 
 		list = list->next;
 
-		if (tasklet_trylock(t)) {
-			if (!atomic_read(&t->count)) {
-				if (!test_and_clear_bit(TASKLET_STATE_SCHED, &t->state))
-					BUG();
-				t->func(t->data);
-				tasklet_unlock(t);
-				continue;
-			}
-			tasklet_unlock(t);
+		/*
+		 * Should always succeed - after a tasklist got on the
+		 * list (after getting the SCHED bit set from 0 to 1),
+		 * nothing but the tasklet softirq it got queued to can
+		 * lock it:
+		 */
+		if (!tasklet_trylock(t)) {
+			WARN_ON(1);
+			continue;
 		}
 
-		local_irq_disable();
 		t->next = NULL;
-		*__this_cpu_read(tasklet_vec.tail) = t;
-		__this_cpu_write(tasklet_vec.tail, &(t->next));
-		__raise_softirq_irqoff(TASKLET_SOFTIRQ);
-		local_irq_enable();
+
+		/*
+		 * If we cannot handle the tasklet because it's disabled,
+		 * mark it as pending. tasklet_enable() will later
+		 * re-schedule the tasklet.
+		 */
+		if (unlikely(atomic_read(&t->count))) {
+out_disabled:
+			/* implicit unlock: */
+			wmb();
+			t->state = TASKLET_STATEF_PENDING;
+			continue;
+		}
+
+		/*
+		 * After this point on the tasklet might be rescheduled
+		 * on another CPU, but it can only be added to another
+		 * CPU's tasklet list if we unlock the tasklet (which we
+		 * dont do yet).
+		 */
+		if (!test_and_clear_bit(TASKLET_STATE_SCHED, &t->state))
+			WARN_ON(1);
+
+again:
+		t->func(t->data);
+
+		/*
+		 * Try to unlock the tasklet. We must use cmpxchg, because
+		 * another CPU might have scheduled or disabled the tasklet.
+		 * We only allow the STATE_RUN -> 0 transition here.
+		 */
+		while (!tasklet_tryunlock(t)) {
+			/*
+			 * If it got disabled meanwhile, bail out:
+			 */
+			if (atomic_read(&t->count))
+				goto out_disabled;
+			/*
+			 * If it got scheduled meanwhile, re-execute
+			 * the tasklet function:
+			 */
+			if (test_and_clear_bit(TASKLET_STATE_SCHED, &t->state))
+				goto again;
+			if (!--loops) {
+				printk("hm, tasklet state: %08lx\n", t->state);
+				WARN_ON(1);
+				tasklet_unlock(t);
+				break;
+			}
+		}
 	}
 }
 
+static void tasklet_action(struct softirq_action *a)
+{
+	struct tasklet_struct *list;
+
+	local_irq_disable();
+	list = __get_cpu_var(tasklet_vec).head;
+	__get_cpu_var(tasklet_vec).head = NULL;
+	__get_cpu_var(tasklet_vec).tail = &__get_cpu_var(tasklet_vec).head;
+	local_irq_enable();
+
+	__tasklet_action(a, list);
+}
+
 static void tasklet_hi_action(struct softirq_action *a)
 {
 	struct tasklet_struct *list;
@@ -754,29 +851,7 @@ static void tasklet_hi_action(struct softirq_action *a)
 	__this_cpu_write(tasklet_hi_vec.tail, &__get_cpu_var(tasklet_hi_vec).head);
 	local_irq_enable();
 
-	while (list) {
-		struct tasklet_struct *t = list;
-
-		list = list->next;
-
-		if (tasklet_trylock(t)) {
-			if (!atomic_read(&t->count)) {
-				if (!test_and_clear_bit(TASKLET_STATE_SCHED, &t->state))
-					BUG();
-				t->func(t->data);
-				tasklet_unlock(t);
-				continue;
-			}
-			tasklet_unlock(t);
-		}
-
-		local_irq_disable();
-		t->next = NULL;
-		*__this_cpu_read(tasklet_hi_vec.tail) = t;
-		__this_cpu_write(tasklet_hi_vec.tail, &(t->next));
-		__raise_softirq_irqoff(HI_SOFTIRQ);
-		local_irq_enable();
-	}
+	__tasklet_action(a, list);
 }
 
 
@@ -799,7 +874,7 @@ void tasklet_kill(struct tasklet_struct *t)
 
 	while (test_and_set_bit(TASKLET_STATE_SCHED, &t->state)) {
 		do {
-			yield();
+			msleep(1);
 		} while (test_bit(TASKLET_STATE_SCHED, &t->state));
 	}
 	tasklet_unlock_wait(t);
@@ -1005,6 +1080,23 @@ void __init softirq_init(void)
 	open_softirq(HI_SOFTIRQ, tasklet_hi_action);
 }
 
+#if defined(CONFIG_SMP) || defined(CONFIG_PREEMPT_RT_FULL)
+void tasklet_unlock_wait(struct tasklet_struct *t)
+{
+	while (test_bit(TASKLET_STATE_RUN, &(t)->state)) {
+		/*
+		 * Hack for now to avoid this busy-loop:
+		 */
+#ifdef CONFIG_PREEMPT_RT_FULL
+		msleep(1);
+#else
+		barrier();
+#endif
+	}
+}
+EXPORT_SYMBOL(tasklet_unlock_wait);
+#endif
+
 static int run_ksoftirqd(void * __bind_cpu)
 {
 	ksoftirqd_set_sched_params();


