Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751415Ab1IZPJu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 11:09:50 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:33133 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750846Ab1IZPJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 11:09:48 -0400
X-Authority-Analysis: v=1.1 cv=lfM0d0QHaVz67dfwwr9cyIw6NbaGR/pZhMD6XWNi0kk= c=1 sm=0 a=vhdKIqpQuCYA:10 a=KVdqOjnuRcEA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=17wjrS5wAhQaEczCPkpxpQ==:17 a=meVymXHHAAAA:8 a=f35HL-E7mFgW2ByphDkA:9 a=muqe5dOS21q9BWbm8-sA:7 a=jeBq3FmKZ4MA:10 a=17wjrS5wAhQaEczCPkpxpQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.83.30
Message-Id: <20110926150946.555808977@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 26 Sep 2011 11:08:36 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Clark Williams <williams@redhat.com>
Subject: [PATCH 1/3][RT] sched: Postpone actual migration disalbe to schedule
References: <20110926150835.107371360@goodmis.org>
Content-Disposition: inline; filename=migrate-disable-delay.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The migrate_disable() can cause a bit of a overhead to the RT kernel,
as changing the affinity is expensive to do at every lock encountered.
As a running task can not migrate, the actual disabling of migration
does not need to occur until the task is about to schedule out.

In most cases, a task that disables migration will enable it before
it schedules making this change improve performance tremendously.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Index: linux-rt.git/kernel/sched.c
===================================================================
--- linux-rt.git.orig/kernel/sched.c
+++ linux-rt.git/kernel/sched.c
@@ -4207,6 +4207,130 @@ static inline void schedule_debug(struct
 	schedstat_inc(this_rq(), sched_count);
 }
 
+#ifdef CONFIG_PREEMPT_RT_FULL
+#define MIGRATE_DISABLE_SET_AFFIN	(1<<30) /* Can't make a negative */
+#define migrate_disabled_updated(p)	((p)->migrate_disable & MIGRATE_DISABLE_SET_AFFIN)
+#define migrate_disable_count(p)	((p)->migrate_disable & ~MIGRATE_DISABLE_SET_AFFIN)
+
+static inline void update_migrate_disable(struct task_struct *p)
+{
+	const struct cpumask *mask;
+
+	if (likely(!p->migrate_disable))
+		return;
+
+	/* Did we already update affinity? */
+	if (unlikely(migrate_disabled_updated(p)))
+		return;
+
+	/*
+	 * Since this is always current we can get away with only locking
+	 * rq->lock, the ->cpus_allowed value can normally only be changed
+	 * while holding both p->pi_lock and rq->lock, but seeing that this
+	 * is current, we cannot actually be waking up, so all code that
+	 * relies on serialization against p->pi_lock is out of scope.
+	 *
+	 * Having rq->lock serializes us against things like
+	 * set_cpus_allowed_ptr() that can still happen concurrently.
+	 */
+	mask = tsk_cpus_allowed(p);
+
+	WARN_ON(!cpumask_test_cpu(smp_processor_id(), mask));
+
+	if (!cpumask_equal(&p->cpus_allowed, mask)) {
+		if (p->sched_class->set_cpus_allowed)
+			p->sched_class->set_cpus_allowed(p, mask);
+		p->rt.nr_cpus_allowed = cpumask_weight(mask);
+
+		/* Let migrate_enable know to fix things back up */
+		p->migrate_disable |= MIGRATE_DISABLE_SET_AFFIN;
+	}
+}
+
+void migrate_disable(void)
+{
+	struct task_struct *p = current;
+
+	if (in_atomic()) {
+#ifdef CONFIG_SCHED_DEBUG
+		p->migrate_disable_atomic++;
+#endif
+		return;
+	}
+
+#ifdef CONFIG_SCHED_DEBUG
+	WARN_ON_ONCE(p->migrate_disable_atomic);
+#endif
+
+	preempt_disable();
+	if (p->migrate_disable) {
+		p->migrate_disable++;
+		preempt_enable();
+		return;
+	}
+
+	pin_current_cpu();
+	p->migrate_disable = 1;
+	preempt_enable();
+}
+EXPORT_SYMBOL_GPL(migrate_disable);
+
+void migrate_enable(void)
+{
+	struct task_struct *p = current;
+	const struct cpumask *mask;
+	unsigned long flags;
+	struct rq *rq;
+
+	if (in_atomic()) {
+#ifdef CONFIG_SCHED_DEBUG
+		p->migrate_disable_atomic--;
+#endif
+		return;
+	}
+
+#ifdef CONFIG_SCHED_DEBUG
+	WARN_ON_ONCE(p->migrate_disable_atomic);
+#endif
+	WARN_ON_ONCE(p->migrate_disable <= 0);
+
+	preempt_disable();
+	if (migrate_disable_count(p) > 1) {
+		p->migrate_disable--;
+		preempt_enable();
+		return;
+	}
+
+	if (unlikely(migrate_disabled_updated(p))) {
+		/*
+		 * See comment in update_migrate_disable() about locking.
+		 */
+		rq = this_rq();
+		raw_spin_lock_irqsave(&rq->lock, flags);
+		mask = tsk_cpus_allowed(p);
+
+		WARN_ON(!cpumask_test_cpu(smp_processor_id(), mask));
+
+		if (unlikely(!cpumask_equal(&p->cpus_allowed, mask))) {
+			/* Get the mask now that migration is enabled */
+			mask = tsk_cpus_allowed(p);
+			if (p->sched_class->set_cpus_allowed)
+				p->sched_class->set_cpus_allowed(p, mask);
+			p->rt.nr_cpus_allowed = cpumask_weight(mask);
+		}
+		raw_spin_unlock_irqrestore(&rq->lock, flags);
+	}
+
+	p->migrate_disable = 0;
+	unpin_current_cpu();
+	preempt_enable();
+}
+EXPORT_SYMBOL_GPL(migrate_enable);
+#else
+static inline void update_migrate_disable(struct task_struct *p) { }
+#define migrate_disabled_updated(p)		0
+#endif
+
 static void put_prev_task(struct rq *rq, struct task_struct *prev)
 {
 	if (prev->on_rq || rq->skip_clock_update < 0)
@@ -4266,6 +4390,8 @@ need_resched:
 
 	raw_spin_lock_irq(&rq->lock);
 
+	update_migrate_disable(prev);
+
 	switch_count = &prev->nivcsw;
 	if (prev->state && !(preempt_count() & PREEMPT_ACTIVE)) {
 		if (unlikely(signal_pending_state(prev->state, prev))) {
@@ -6058,7 +6184,7 @@ static inline void sched_init_granularit
 #ifdef CONFIG_SMP
 void do_set_cpus_allowed(struct task_struct *p, const struct cpumask *new_mask)
 {
-	if (!__migrate_disabled(p)) {
+	if (!migrate_disabled_updated(p)) {
 		if (p->sched_class && p->sched_class->set_cpus_allowed)
 			p->sched_class->set_cpus_allowed(p, new_mask);
 		p->rt.nr_cpus_allowed = cpumask_weight(new_mask);
@@ -6133,124 +6259,6 @@ out:
 }
 EXPORT_SYMBOL_GPL(set_cpus_allowed_ptr);
 
-#ifdef CONFIG_PREEMPT_RT_FULL
-void migrate_disable(void)
-{
-	struct task_struct *p = current;
-	const struct cpumask *mask;
-	unsigned long flags;
-	struct rq *rq;
-
-	if (in_atomic()) {
-#ifdef CONFIG_SCHED_DEBUG
-		p->migrate_disable_atomic++;
-#endif
-		return;
-	}
-
-#ifdef CONFIG_SCHED_DEBUG
-	WARN_ON_ONCE(p->migrate_disable_atomic);
-#endif
-
-	preempt_disable();
-	if (p->migrate_disable) {
-		p->migrate_disable++;
-		preempt_enable();
-		return;
-	}
-
-	pin_current_cpu();
-	if (unlikely(!scheduler_running)) {
-		p->migrate_disable = 1;
-		preempt_enable();
-		return;
-	}
-
-	/*
-	 * Since this is always current we can get away with only locking
-	 * rq->lock, the ->cpus_allowed value can normally only be changed
-	 * while holding both p->pi_lock and rq->lock, but seeing that this
-	 * it current, we cannot actually be waking up, so all code that
-	 * relies on serialization against p->pi_lock is out of scope.
-	 *
-	 * Taking rq->lock serializes us against things like
-	 * set_cpus_allowed_ptr() that can still happen concurrently.
-	 */
-	rq = this_rq();
-	raw_spin_lock_irqsave(&rq->lock, flags);
-	p->migrate_disable = 1;
-	mask = tsk_cpus_allowed(p);
-
-	WARN_ON(!cpumask_test_cpu(smp_processor_id(), mask));
-
-	if (!cpumask_equal(&p->cpus_allowed, mask)) {
-		if (p->sched_class->set_cpus_allowed)
-			p->sched_class->set_cpus_allowed(p, mask);
-		p->rt.nr_cpus_allowed = cpumask_weight(mask);
-	}
-	raw_spin_unlock_irqrestore(&rq->lock, flags);
-	preempt_enable();
-}
-EXPORT_SYMBOL_GPL(migrate_disable);
-
-void migrate_enable(void)
-{
-	struct task_struct *p = current;
-	const struct cpumask *mask;
-	unsigned long flags;
-	struct rq *rq;
-
-	if (in_atomic()) {
-#ifdef CONFIG_SCHED_DEBUG
-		p->migrate_disable_atomic--;
-#endif
-		return;
-	}
-
-#ifdef CONFIG_SCHED_DEBUG
-	WARN_ON_ONCE(p->migrate_disable_atomic);
-#endif
-	WARN_ON_ONCE(p->migrate_disable <= 0);
-
-	preempt_disable();
-	if (p->migrate_disable > 1) {
-		p->migrate_disable--;
-		preempt_enable();
-		return;
-	}
-
-	if (unlikely(!scheduler_running)) {
-		p->migrate_disable = 0;
-		unpin_current_cpu();
-		preempt_enable();
-		return;
-	}
-
-	/*
-	 * See comment in migrate_disable().
-	 */
-	rq = this_rq();
-	raw_spin_lock_irqsave(&rq->lock, flags);
-	mask = tsk_cpus_allowed(p);
-	p->migrate_disable = 0;
-
-	WARN_ON(!cpumask_test_cpu(smp_processor_id(), mask));
-
-	if (!cpumask_equal(&p->cpus_allowed, mask)) {
-		/* Get the mask now that migration is enabled */
-		mask = tsk_cpus_allowed(p);
-		if (p->sched_class->set_cpus_allowed)
-			p->sched_class->set_cpus_allowed(p, mask);
-		p->rt.nr_cpus_allowed = cpumask_weight(mask);
-	}
-
-	raw_spin_unlock_irqrestore(&rq->lock, flags);
-	unpin_current_cpu();
-	preempt_enable();
-}
-EXPORT_SYMBOL_GPL(migrate_enable);
-#endif /* CONFIG_PREEMPT_RT_FULL */
-
 /*
  * Move (not current) task off this cpu, onto dest cpu. We're doing
  * this because either it can't run here any more (set_cpus_allowed()

