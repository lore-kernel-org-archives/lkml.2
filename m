Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756869Ab0LJThs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 14:37:48 -0500
Received: from canuck.infradead.org ([134.117.69.58]:55009 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751175Ab0LJThq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 14:37:46 -0500
Subject: Re: [BUG] 2.6.37-rc3 massive interactivity regression on ARM
From: Peter Zijlstra <peterz@infradead.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Venkatesh Pallipadi <venki@google.com>, Mikael Pettersson <mikpe@it.uu.se>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        John Stultz <johnstul@us.ibm.com>
In-Reply-To: <20101210191720.GC28263@n2100.arm.linux.org.uk>
References: <1291920939.6803.38.camel@twins>
	 <AANLkTim+v21RpWobdw6exEbazDJwm4JjemPVB2+3PuRJ@mail.gmail.com>
	 <1291936593.13513.3.camel@laptop>
	 <AANLkTi=_qf8NAgj2HHMP0qG-ibnH-726NzoXbxd-bS1N@mail.gmail.com>
	 <1291975704.6803.59.camel@twins> <1291987065.6803.151.camel@twins>
	 <1291987635.6803.161.camel@twins> <1291988866.6803.171.camel@twins>
	 <20101210175645.GB28263@n2100.arm.linux.org.uk>
	 <1292004654.13513.38.camel@laptop>
	 <20101210191720.GC28263@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 10 Dec 2010 20:37:32 +0100
Message-ID: <1292009852.13513.48.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-12-10 at 19:17 +0000, Russell King - ARM Linux wrote:
> 
> 
> Well, I can't tell you what kind of code this produces on ARM, as it
> doesn't appear to apply to any kernel I've tried.  So, I assume it's
> against some scheduler development tree rather than Linus' tree? 

Ah yes, my bad, there's some change that got in the way.



---
Subject: sched: Fix the irqtime code to deal with u64 wraps
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Thu Dec 09 14:15:34 CET 2010

ARM systems have a 32bit sched_clock() [ which needs to be fixed ],
but this exposed a bug in the irq_time code as well, it doesn't deal
with wraps at all.

Fix the irq_time code to deal with u64 wraps by re-writing the code to
only use delta increments, which avoids the whole issue.

Furthermore, solve the problem of 32bit arches reading partial updates
of the u64 time values.

Cc: Venkatesh Pallipadi <venki@google.com>
Reported-by: Mikael Pettersson <mikpe@it.uu.se>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
---
 kernel/sched.c |  172 +++++++++++++++++++++++++++++++++++++++------------------
 1 file changed, 119 insertions(+), 53 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -636,22 +636,18 @@ static inline struct task_group *task_gr
 
 #endif /* CONFIG_CGROUP_SCHED */
 
-static u64 irq_time_cpu(int cpu);
-static void sched_irq_time_avg_update(struct rq *rq, u64 irq_time);
+static void update_rq_clock_task(struct rq *rq, s64 delta);
 
-inline void update_rq_clock(struct rq *rq)
+static void update_rq_clock(struct rq *rq)
 {
-	if (!rq->skip_clock_update) {
-		int cpu = cpu_of(rq);
-		u64 irq_time;
+	s64 delta;
 
-		rq->clock = sched_clock_cpu(cpu);
-		irq_time = irq_time_cpu(cpu);
-		if (rq->clock - irq_time > rq->clock_task)
-			rq->clock_task = rq->clock - irq_time;
+	if (rq->skip_clock_update)
+		return;
 
-		sched_irq_time_avg_update(rq, irq_time);
-	}
+	delta = sched_clock_cpu(cpu_of(rq)) - rq->clock;
+	rq->clock += delta;
+	update_rq_clock_task(rq, delta);
 }
 
 /*
@@ -1918,90 +1914,160 @@ static void deactivate_task(struct rq *r
 #ifdef CONFIG_IRQ_TIME_ACCOUNTING
 
 /*
- * There are no locks covering percpu hardirq/softirq time.
- * They are only modified in account_system_vtime, on corresponding CPU
- * with interrupts disabled. So, writes are safe.
+ * There are no locks covering percpu hardirq/softirq time. They are only
+ * modified in account_system_vtime, on corresponding CPU with interrupts
+ * disabled. So, writes are safe.
+ *
  * They are read and saved off onto struct rq in update_rq_clock().
- * This may result in other CPU reading this CPU's irq time and can
- * race with irq/account_system_vtime on this CPU. We would either get old
- * or new value (or semi updated value on 32 bit) with a side effect of
- * accounting a slice of irq time to wrong task when irq is in progress
- * while we read rq->clock. That is a worthy compromise in place of having
- * locks on each irq in account_system_time.
+ *
+ * This may result in other CPU reading this CPU's irq time and can race with
+ * irq/account_system_vtime on this CPU. We would either get old or new value
+ * with a side effect of accounting a slice of irq time to wrong task when irq
+ * is in progress while we read rq->clock. That is a worthy compromise in place
+ * of having locks on each irq in account_system_time.
  */
 static DEFINE_PER_CPU(u64, cpu_hardirq_time);
 static DEFINE_PER_CPU(u64, cpu_softirq_time);
-
 static DEFINE_PER_CPU(u64, irq_start_time);
-static int sched_clock_irqtime;
 
-void enable_sched_clock_irqtime(void)
+#ifndef CONFIG_64BIT
+static DEFINE_PER_CPU(seqcount_t, irq_time_seq);
+
+static inline void irq_time_write_begin(int cpu)
 {
-	sched_clock_irqtime = 1;
+	write_seqcount_begin(&per_cpu(irq_time_seq, cpu));
 }
 
-void disable_sched_clock_irqtime(void)
+static inline void irq_time_write_end(int cpu)
 {
-	sched_clock_irqtime = 0;
+	write_seqcount_end(&per_cpu(irq_time_seq, cpu));
 }
 
-static u64 irq_time_cpu(int cpu)
+static inline u64 irq_time_read(int cpu)
 {
-	if (!sched_clock_irqtime)
-		return 0;
+	u64 irq_time;
+	unsigned seq;
+
+	do {
+		seq = read_seqcount_begin(&per_cpu(irq_time_seq, cpu));
+		irq_time = per_cpu(cpu_softirq_time, cpu) +
+			   per_cpu(cpu_hardirq_time, cpu);
+	} while (read_seqcount_retry(&per_cpu(irq_time_seq, cpu), seq));
+
+	return irq_time;
+}
+#else /* CONFIG_64BIT */
+static inline void irq_time_write_begin(int cpu)
+{
+}
+
+static inline void irq_time_write_end(int cpu)
+{
+}
 
+static inline u64 irq_time_read(int cpu)
+{
 	return per_cpu(cpu_softirq_time, cpu) + per_cpu(cpu_hardirq_time, cpu);
 }
+#endif /* CONFIG_64BIT */
 
+static int sched_clock_irqtime;
+
+void enable_sched_clock_irqtime(void)
+{
+	sched_clock_irqtime = 1;
+}
+
+void disable_sched_clock_irqtime(void)
+{
+	sched_clock_irqtime = 0;
+}
+
+/*
+ * Called before incrementing preempt_count on {soft,}irq_enter
+ * and before decrementing preempt_count on {soft,}irq_exit.
+ */
 void account_system_vtime(struct task_struct *curr)
 {
 	unsigned long flags;
+	s64 delta;
 	int cpu;
-	u64 now, delta;
 
 	if (!sched_clock_irqtime)
 		return;
 
 	local_irq_save(flags);
-
 	cpu = smp_processor_id();
-	now = sched_clock_cpu(cpu);
-	delta = now - per_cpu(irq_start_time, cpu);
-	per_cpu(irq_start_time, cpu) = now;
-	/*
-	 * We do not account for softirq time from ksoftirqd here.
-	 * We want to continue accounting softirq time to ksoftirqd thread
-	 * in that case, so as not to confuse scheduler with a special task
-	 * that do not consume any time, but still wants to run.
-	 */
+	delta = sched_clock_cpu(cpu) - per_cpu(irq_start_time, cpu);
+	per_cpu(irq_start_time, cpu) += delta;
+
+	irq_time_write_begin(cpu);
+
 	if (hardirq_count())
 		per_cpu(cpu_hardirq_time, cpu) += delta;
+	/*
+	 * We do not account for softirq time from ksoftirqd here. We want to
+	 * continue accounting softirq time to ksoftirqd thread in that case,
+	 * so as not to confuse scheduler with a special task that do not
+	 * consume any time, but still wants to run.
+	 */
 	else if (in_serving_softirq() && !(curr->flags & PF_KSOFTIRQD))
 		per_cpu(cpu_softirq_time, cpu) += delta;
 
+	irq_time_write_end(cpu);
 	local_irq_restore(flags);
 }
 EXPORT_SYMBOL_GPL(account_system_vtime);
 
-static void sched_irq_time_avg_update(struct rq *rq, u64 curr_irq_time)
+static u64 irq_time_cpu(struct rq *rq)
 {
-	if (sched_clock_irqtime && sched_feat(NONIRQ_POWER)) {
-		u64 delta_irq = curr_irq_time - rq->prev_irq_time;
-		rq->prev_irq_time = curr_irq_time;
-		sched_rt_avg_update(rq, delta_irq);
-	}
+	/*
+	 * See the comment in update_rq_clock_task(), ideally we'd update
+	 * the *irq_time values using rq->clock here.
+	 */
+	return irq_time_read(cpu_of(rq));
 }
 
-#else
-
-static u64 irq_time_cpu(int cpu)
+static void update_rq_clock_task(struct rq *rq, s64 delta)
 {
-	return 0;
+	s64 irq_delta;
+
+	irq_delta = irq_time_cpu(rq) - rq->prev_irq_time;
+
+	/*
+	 * Since irq_time is only updated on {soft,}irq_exit, we might run into
+	 * this case when a previous update_rq_clock() happened inside a
+	 * {soft,}irq region.
+	 *
+	 * When this happens, we stop ->clock_task and only update the
+	 * prev_irq_time stamp to account for the part that fit, so that a next
+	 * update will consume the rest. This ensures ->clock_task is
+	 * monotonic.
+	 *
+	 * It does however cause some slight miss-attribution of {soft,}irq
+	 * time, a more accurate solution would be to update the irq_time using
+	 * the current rq->clock timestamp, except that would require using
+	 * atomic ops.
+	 */
+	if (irq_delta > delta)
+		irq_delta = delta;
+
+	rq->prev_irq_time += irq_delta;
+	delta -= irq_delta;
+	rq->clock_task += delta;
+
+	if (irq_delta && sched_feat(NONIRQ_POWER))
+		sched_rt_avg_update(rq, irq_delta);
 }
 
-static void sched_irq_time_avg_update(struct rq *rq, u64 curr_irq_time) { }
+#else /* CONFIG_IRQ_TIME_ACCOUNTING */
 
-#endif
+static inline void update_rq_clock_task(struct rq *rq, s64 delta)
+{
+	rq->clock_task += delta;
+}
+
+#endif /* CONFIG_IRQ_TIME_ACCOUNTING */
 
 #include "sched_idletask.c"
 #include "sched_fair.c"

