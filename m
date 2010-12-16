Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752974Ab0LPMbz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 07:31:55 -0500
Received: from hera.kernel.org ([140.211.167.34]:36303 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751822Ab0LPMbu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 07:31:50 -0500
Date: Thu, 16 Dec 2010 12:31:10 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, mikpe@it.uu.se, tglx@linutronix.de,
        venki@google.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, mikpe@it.uu.se, tglx@linutronix.de,
        venki@google.com, mingo@elte.hu
In-Reply-To: <1292242433.6803.199.camel@twins>
References: <1292242433.6803.199.camel@twins>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Fix the irqtime code to deal with u64 wraps
Message-ID: <tip-fe44d62122829959e960bc699318d58966922a69@git.kernel.org>
Git-Commit-ID: fe44d62122829959e960bc699318d58966922a69
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 16 Dec 2010 12:31:12 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fe44d62122829959e960bc699318d58966922a69
Gitweb:     http://git.kernel.org/tip/fe44d62122829959e960bc699318d58966922a69
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 9 Dec 2010 14:15:34 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 16 Dec 2010 11:17:46 +0100

sched: Fix the irqtime code to deal with u64 wraps

Some ARM systems have a short sched_clock() [ which needs to be fixed
too ], but this exposed a bug in the irq_time code as well, it doesn't
deal with wraps at all.

Fix the irq_time code to deal with u64 wraps by re-writing the code to
only use delta increments, which avoids the whole issue.

Reviewed-by: Venkatesh Pallipadi <venki@google.com>
Reported-by: Mikael Pettersson <mikpe@it.uu.se>
Tested-by: Mikael Pettersson <mikpe@it.uu.se>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1292242433.6803.199.camel@twins>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |   83 +++++++++++++++++++++++++++++++++----------------------
 1 files changed, 50 insertions(+), 33 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index da14302..79b557c 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -636,23 +636,18 @@ static inline struct task_group *task_group(struct task_struct *p)
 
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
@@ -1966,9 +1962,9 @@ void account_system_vtime(struct task_struct *curr)
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
@@ -1976,33 +1972,54 @@ void account_system_vtime(struct task_struct *curr)
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
