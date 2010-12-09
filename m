Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755895Ab0LIXQs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 18:16:48 -0500
Received: from casper.infradead.org ([85.118.1.10]:59685 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755533Ab0LIXQq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 18:16:46 -0500
Subject: Re: [BUG] 2.6.37-rc3 massive interactivity regression on ARM
From: Peter Zijlstra <peterz@infradead.org>
To: Venkatesh Pallipadi <venki@google.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Mikael Pettersson <mikpe@it.uu.se>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        John Stultz <johnstul@us.ibm.com>
In-Reply-To: <AANLkTim+v21RpWobdw6exEbazDJwm4JjemPVB2+3PuRJ@mail.gmail.com>
References: <20101208142814.GE9777@n2100.arm.linux.org.uk>
	 <1291851079-27061-1-git-send-email-venki@google.com>
	 <1291899120.29292.7.camel@twins>
	 <AANLkTikd3X4pLs5De-LO6=XD+JqUz3-Ku7YM8+0-oK8t@mail.gmail.com>
	 <1291917330.6803.7.camel@twins>
	 <AANLkTin+eO_jPceSOHL4e7vqd+tf0ZCMHJ-USoz8aZL1@mail.gmail.com>
	 <1291920939.6803.38.camel@twins>
	 <AANLkTim+v21RpWobdw6exEbazDJwm4JjemPVB2+3PuRJ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 10 Dec 2010 00:16:33 +0100
Message-ID: <1291936593.13513.3.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-12-09 at 14:21 -0800, Venkatesh Pallipadi wrote:
> This should mostly work. There would be a small window there on
> rq->clock=sched_clock_cpu() and system_vtime doing sched_clock_cpu()
> and also the overhead of doing this everytime when this going
> backwards may happen rarely. 

Right, so something like the below removes that tiny race by re-using
rq->clock as now. It also removes some overhead by removing the IRQ
fudging (we already know IRQs are disabled).

It does have a few extra branches (2 afaict) than your monotonicity path
had, but it seems to me this approach is slightly more accurate.

---
Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -1813,19 +1813,10 @@ void disable_sched_clock_irqtime(void)
 	sched_clock_irqtime = 0;
 }
 
-void account_system_vtime(struct task_struct *curr)
+static void __account_system_vtime(int cpu, u64 now)
 {
-	unsigned long flags;
-	int cpu;
-	u64 now, delta;
+	s64 delta;
 
-	if (!sched_clock_irqtime)
-		return;
-
-	local_irq_save(flags);
-
-	cpu = smp_processor_id();
-	now = sched_clock_cpu(cpu);
 	delta = now - per_cpu(irq_start_time, cpu);
 	per_cpu(irq_start_time, cpu) = now;
 	/*
@@ -1836,16 +1827,36 @@ void account_system_vtime(struct task_st
 	 */
 	if (hardirq_count())
 		per_cpu(cpu_hardirq_time, cpu) += delta;
-	else if (in_serving_softirq() && !(curr->flags & PF_KSOFTIRQD))
+	else if (in_serving_softirq() && !(current->flags & PF_KSOFTIRQD))
 		per_cpu(cpu_softirq_time, cpu) += delta;
+}
+
+void account_system_vtime(struct task_struct *curr)
+{
+	unsigned long flags;
+	u64 now;
+	int cpu;
+
+	if (!sched_clock_irqtime)
+		return;
+
+	local_irq_save(flags);
+
+	cpu = smp_processor_id();
+	now = sched_clock_cpu(cpu);
+	__account_system_vtime(cpu, now);
 
 	local_irq_restore(flags);
 }
 EXPORT_SYMBOL_GPL(account_system_vtime);
 
-static u64 irq_time_cpu(int cpu)
+static u64 irq_time_cpu(struct rq *rq)
 {
-	account_system_vtime(current);
+	int cpu = cpu_of(rq);
+
+	if (sched_clock_irqtime)
+		__account_system_vtime(cpu, rq->clock);
+
 	return per_cpu(cpu_softirq_time, cpu) + per_cpu(cpu_hardirq_time, cpu);
 }
 
@@ -1853,7 +1864,7 @@ static void update_rq_clock_task(struct
 {
 	s64 irq_delta;
 
-	irq_delta = irq_time_cpu(cpu_of(rq)) - rq->prev_irq_time;
+	irq_delta = irq_time_cpu(rq) - rq->prev_irq_time;
 	rq->prev_irq_time += irq_delta;
 
 	delta -= irq_delta;

