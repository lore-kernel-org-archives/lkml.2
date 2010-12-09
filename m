Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756224Ab0LIMwT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 07:52:19 -0500
Received: from casper.infradead.org ([85.118.1.10]:44462 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754944Ab0LIMwS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 07:52:18 -0500
Subject: Re: [BUG] 2.6.37-rc3 massive interactivity regression on ARM
From: Peter Zijlstra <peterz@infradead.org>
To: Venkatesh Pallipadi <venki@google.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mikael Pettersson <mikpe@it.uu.se>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        John Stultz <johnstul@us.ibm.com>
In-Reply-To: <1291851079-27061-1-git-send-email-venki@google.com>
References: <20101208142814.GE9777@n2100.arm.linux.org.uk>
	 <1291851079-27061-1-git-send-email-venki@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 09 Dec 2010 13:52:00 +0100
Message-ID: <1291899120.29292.7.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-12-08 at 15:31 -0800, Venkatesh Pallipadi wrote:

> [PATCH] update_rq_clock() with irq_time should handle 64 bit wraparound
> 
> update_rq_clock with IRQ_TIME_ACCOUNTING assumed 64 bit sched_clock that
> practically will not wraparound. Change to code to handle wraparounds,
> still preventing rq->clock_task from going backwards.

All we should do is deal with the 64wrap, not filter backward motion, I
came up with something like the below.

I think for now the best solution to the early wrap problem for ARM is
for them to select HAVE_UNSTABLE_SCHED_CLOCK, it will mostly deal with
the short wrap by filtering out the occasional negative value.

Then later we can look at cleaning/breaking-up the kernel/sched_clock.c
code to provide smaller bits of functionality and possibly merging it
with some of the clocksource code.

---
 kernel/sched.c |   54 +++++++++++++++++++++++++-----------------------------
 1 files changed, 25 insertions(+), 29 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 8e885c1..0fb7de8 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -642,23 +642,19 @@ static inline struct task_group *task_group(struct task_struct *p)
 
 #endif /* CONFIG_CGROUP_SCHED */
 
-static u64 irq_time_cpu(int cpu);
-static void sched_irq_time_avg_update(struct rq *rq, u64 irq_time);
+static void update_rq_clock_task(struct rq *rq, s64 delta);
 
 inline void update_rq_clock(struct rq *rq)
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
+	delta = sched_clock_cpu(cpu_of(rq)) - rq->clock;
+	rq->clock += delta;
+	update_rq_clock_task(rq, delta);
 
-	sched_irq_time_avg_update(rq, irq_time);
 }
 
 /*
@@ -1817,14 +1813,6 @@ void disable_sched_clock_irqtime(void)
 	sched_clock_irqtime = 0;
 }
 
-static u64 irq_time_cpu(int cpu)
-{
-	if (!sched_clock_irqtime)
-		return 0;
-
-	return per_cpu(cpu_softirq_time, cpu) + per_cpu(cpu_hardirq_time, cpu);
-}
-
 void account_system_vtime(struct task_struct *curr)
 {
 	unsigned long flags;
@@ -1855,25 +1843,33 @@ void account_system_vtime(struct task_struct *curr)
 }
 EXPORT_SYMBOL_GPL(account_system_vtime);
 
-static void sched_irq_time_avg_update(struct rq *rq, u64 curr_irq_time)
+static inline u64 irq_time_cpu(int cpu)
 {
-	if (sched_clock_irqtime && sched_feat(NONIRQ_POWER)) {
-		u64 delta_irq = curr_irq_time - rq->prev_irq_time;
-		rq->prev_irq_time = curr_irq_time;
-		sched_rt_avg_update(rq, delta_irq);
-	}
+	return per_cpu(cpu_softirq_time, cpu) + per_cpu(cpu_hardirq_time, cpu);
 }
 
-#else
-
-static u64 irq_time_cpu(int cpu)
+static void update_rq_clock_task(struct rq *rq, s64 delta)
 {
-	return 0;
+	s64 irq_delta;
+
+	irq_delta = irq_time_cpu(cpu_of(rq)) - rq->prev_irq_time;
+	rq->prev_irq_time += irq_delta;
+
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

