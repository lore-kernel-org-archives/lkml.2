Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754137Ab0LMMSs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 07:18:48 -0500
Received: from canuck.infradead.org ([134.117.69.58]:47049 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751477Ab0LMMSr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 07:18:47 -0500
Subject: [PATCH 1/2] sched: Fix the irqtime code to deal with u64 wraps
From: Peter Zijlstra <peterz@infradead.org>
To: Venkatesh Pallipadi <venki@google.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Mikael Pettersson <mikpe@it.uu.se>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        John Stultz <johnstul@us.ibm.com>,
        Christoph Lameter <cl@linux-foundation.org>
In-Reply-To: <AANLkTi=vUvNET2peva7uzWbzk5eK5EsKUrEQQSwLkNwM@mail.gmail.com>
References: <1292013506.13513.78.camel@laptop>
	 <AANLkTi=vUvNET2peva7uzWbzk5eK5EsKUrEQQSwLkNwM@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 13 Dec 2010 13:13:53 +0100
Message-ID: <1292242433.6803.199.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: sched: Fix the irqtime code to deal with u64 wraps
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Thu Dec 09 14:15:34 CET 2010

Some ARM systems have a short sched_clock() [ which needs to be fixed
too ], but this exposed a bug in the irq_time code as well, it doesn't
deal with wraps at all.

Fix the irq_time code to deal with u64 wraps by re-writing the code to
only use delta increments, which avoids the whole issue.

Reviewed-by: Venkatesh Pallipadi <venki@google.com>
Reported-by: Mikael Pettersson <mikpe@it.uu.se>
Tested-by: Mikael Pettersson <mikpe@it.uu.se>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
---
 kernel/sched.c |   83 ++++++++++++++++++++++++++++++++++-----------------------
 1 file changed, 50 insertions(+), 33 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -636,23 +636,18 @@ static inline struct task_group *task_gr
 
 #endif /* CONFIG_CGROUP_SCHED */
 
-static u64 irq_time_cpu(int cpu);
-static void sched_irq_time_avg_update(struct rq *rq, u64 irq_time);
+static void update_rq_clock_task(struct rq *rq, s64 delta);
 
-inline void update_rq_clock(struct rq *rq)
+static void update_rq_clock(struct rq *rq)
 {
-	int cpu = cpu_of(rq);
-	u64 irq_time;
+	s64 delta;
 
 	if (rq->skip_clock_update)
 		return;
 
-	rq->clock = sched_clock_cpu(cpu);
-	irq_time = irq_time_cpu(cpu);
-	if (rq->clock - irq_time > rq->clock_task)
-		rq->clock_task = rq->clock - irq_time;
-
-	sched_irq_time_avg_update(rq, irq_time);
+	delta = sched_clock_cpu(cpu_of(rq)) - rq->clock;
+	rq->clock += delta;
+	update_rq_clock_task(rq, delta);
 }
 
 /*
@@ -1946,19 +1941,20 @@ void disable_sched_clock_irqtime(void)
 	sched_clock_irqtime = 0;
 }
 
-static u64 irq_time_cpu(int cpu)
+static inline u64 irq_time_cpu(int cpu)
 {
-	if (!sched_clock_irqtime)
-		return 0;
-
 	return per_cpu(cpu_softirq_time, cpu) + per_cpu(cpu_hardirq_time, cpu);
 }
 
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
@@ -1966,9 +1962,9 @@ void account_system_vtime(struct task_st
 	local_irq_save(flags);
 
 	cpu = smp_processor_id();
-	now = sched_clock_cpu(cpu);
-	delta = now - per_cpu(irq_start_time, cpu);
-	per_cpu(irq_start_time, cpu) = now;
+	delta = sched_clock_cpu(cpu) - __this_cpu_read(irq_start_time);
+	__this_cpu_add(irq_start_time, delta);
+
 	/*
 	 * We do not account for softirq time from ksoftirqd here.
 	 * We want to continue accounting softirq time to ksoftirqd thread
@@ -1976,33 +1972,54 @@ void account_system_vtime(struct task_st
 	 * that do not consume any time, but still wants to run.
 	 */
 	if (hardirq_count())
-		per_cpu(cpu_hardirq_time, cpu) += delta;
+		__this_cpu_add(cpu_hardirq_time, delta);
 	else if (in_serving_softirq() && !(curr->flags & PF_KSOFTIRQD))
-		per_cpu(cpu_softirq_time, cpu) += delta;
+		__this_cpu_add(cpu_softirq_time, delta);
 
 	local_irq_restore(flags);
 }
 EXPORT_SYMBOL_GPL(account_system_vtime);
 
-static void sched_irq_time_avg_update(struct rq *rq, u64 curr_irq_time)
+static void update_rq_clock_task(struct rq *rq, s64 delta)
 {
-	if (sched_clock_irqtime && sched_feat(NONIRQ_POWER)) {
-		u64 delta_irq = curr_irq_time - rq->prev_irq_time;
-		rq->prev_irq_time = curr_irq_time;
-		sched_rt_avg_update(rq, delta_irq);
-	}
+	s64 irq_delta;
+
+	irq_delta = irq_time_cpu(cpu_of(rq)) - rq->prev_irq_time;
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
 
-#else
+#else /* CONFIG_IRQ_TIME_ACCOUNTING */
 
-static u64 irq_time_cpu(int cpu)
+static void update_rq_clock_task(struct rq *rq, s64 delta)
 {
-	return 0;
+	rq->clock_task += delta;
 }
 
-static void sched_irq_time_avg_update(struct rq *rq, u64 curr_irq_time) { }
-
-#endif
+#endif /* CONFIG_IRQ_TIME_ACCOUNTING */
 
 #include "sched_idletask.c"
 #include "sched_fair.c"

