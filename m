Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756430Ab0LJNSL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 08:18:11 -0500
Received: from casper.infradead.org ([85.118.1.10]:47808 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756340Ab0LJNSI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 08:18:08 -0500
Subject: Re: [BUG] 2.6.37-rc3 massive interactivity regression on ARM
From: Peter Zijlstra <peterz@infradead.org>
To: Venkatesh Pallipadi <venki@google.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Mikael Pettersson <mikpe@it.uu.se>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        John Stultz <johnstul@us.ibm.com>
In-Reply-To: <1291975704.6803.59.camel@twins>
References: <20101208142814.GE9777@n2100.arm.linux.org.uk>
	 <1291851079-27061-1-git-send-email-venki@google.com>
	 <1291899120.29292.7.camel@twins>
	 <AANLkTikd3X4pLs5De-LO6=XD+JqUz3-Ku7YM8+0-oK8t@mail.gmail.com>
	 <1291917330.6803.7.camel@twins>
	 <AANLkTin+eO_jPceSOHL4e7vqd+tf0ZCMHJ-USoz8aZL1@mail.gmail.com>
	 <1291920939.6803.38.camel@twins>
	 <AANLkTim+v21RpWobdw6exEbazDJwm4JjemPVB2+3PuRJ@mail.gmail.com>
	 <1291936593.13513.3.camel@laptop>
	 <AANLkTi=_qf8NAgj2HHMP0qG-ibnH-726NzoXbxd-bS1N@mail.gmail.com>
	 <1291975704.6803.59.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 10 Dec 2010 14:17:45 +0100
Message-ID: <1291987065.6803.151.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-12-10 at 11:08 +0100, Peter Zijlstra wrote:
> > Just to make sure, update_rq_clock() always gets called on current
> > CPU. Right? 
> 
> No, specifically not. If that were the case we wouldn't need the
> cross-cpu synced timestamp. Things like load-balancing and
> remote-wakeups need to update a remote CPUs clock.
> 
> > The pending patches I have optimizes
> > account_system_vtime() to use this_cpu_write and friends. Want to make
> > sure this change will still keep that optimization relevant.
> 
> Ah, good point, remote CPUs updating that will mess with the consistency
> of the per-cpu timestamps due to non atomic updates :/
> 
> Bugger.. making them atomics will make it even more expensive. /me goes
> ponder. 

OK, so I ended up doing the same you did.. Still staring at that, 32bit
will go very funny in the head once every so often. One possible
solution would be to ignore the occasional abs(irq_delta) > 2 * delta.

That would however result in an accounting discrepancy such that:
   clock_task + irq_time != clock

Thoughts?

---
Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -1813,11 +1813,36 @@ void disable_sched_clock_irqtime(void)
 	sched_clock_irqtime = 0;
 }
 
+static void __account_system_vtime(int cpu, u64 now)
+{
+	s64 delta;
+
+	delta = now - per_cpu(irq_start_time, cpu);
+	per_cpu(irq_start_time, cpu) = now;
+
+	if (hardirq_count())
+		per_cpu(cpu_hardirq_time, cpu) += delta;
+	/*
+	 * We do not account for softirq time from ksoftirqd here. We want to
+	 * continue accounting softirq time to ksoftirqd thread in that case,
+	 * so as not to confuse scheduler with a special task that do not
+	 * consume any time, but still wants to run.
+	 */
+	else if (in_serving_softirq() && !(current->flags & PF_KSOFTIRQD))
+		per_cpu(cpu_softirq_time, cpu) += delta;
+}
+
+/*
+ * Called before incrementing preempt_count on {soft,}irq_enter
+ * and before decrementing preempt_count on {soft,}irq_exit.
+ *
+ * @curr should at all times be current.
+ */
 void account_system_vtime(struct task_struct *curr)
 {
 	unsigned long flags;
+	u64 now;
 	int cpu;
-	u64 now, delta;
 
 	if (!sched_clock_irqtime)
 		return;
@@ -1826,26 +1851,21 @@ void account_system_vtime(struct task_st
 
 	cpu = smp_processor_id();
 	now = sched_clock_cpu(cpu);
-	delta = now - per_cpu(irq_start_time, cpu);
-	per_cpu(irq_start_time, cpu) = now;
-	/*
-	 * We do not account for softirq time from ksoftirqd here.
-	 * We want to continue accounting softirq time to ksoftirqd thread
-	 * in that case, so as not to confuse scheduler with a special task
-	 * that do not consume any time, but still wants to run.
-	 */
-	if (hardirq_count())
-		per_cpu(cpu_hardirq_time, cpu) += delta;
-	else if (in_serving_softirq() && !(curr->flags & PF_KSOFTIRQD))
-		per_cpu(cpu_softirq_time, cpu) += delta;
+	__account_system_vtime(cpu, now);
 
 	local_irq_restore(flags);
 }
 EXPORT_SYMBOL_GPL(account_system_vtime);
 
-static u64 irq_time_cpu(int cpu)
+static u64 irq_time_cpu(struct rq *rq)
 {
-	account_system_vtime(current);
+	int cpu = cpu_of(rq);
+	/*
+	 * See the comment in update_rq_clock_task(), ideally we'd update
+	 * the *irq_time values using rq->clock here.
+	 *
+	 * As it stands, reading this from a remote cpu is buggy on 32bit.
+	 */
 	return per_cpu(cpu_softirq_time, cpu) + per_cpu(cpu_hardirq_time, cpu);
 }
 
@@ -1853,9 +1873,27 @@ static void update_rq_clock_task(struct
 {
 	s64 irq_delta;
 
-	irq_delta = irq_time_cpu(cpu_of(rq)) - rq->prev_irq_time;
-	rq->prev_irq_time += irq_delta;
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
 
+	rq->prev_irq_time += irq_delta;
 	delta -= irq_delta;
 	rq->clock_task += delta;
 

