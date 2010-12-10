Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756217Ab0LJN1d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 08:27:33 -0500
Received: from casper.infradead.org ([85.118.1.10]:42279 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755952Ab0LJN1c convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 08:27:32 -0500
Subject: Re: [BUG] 2.6.37-rc3 massive interactivity regression on ARM
From: Peter Zijlstra <peterz@infradead.org>
To: Venkatesh Pallipadi <venki@google.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Mikael Pettersson <mikpe@it.uu.se>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        John Stultz <johnstul@us.ibm.com>
In-Reply-To: <1291987065.6803.151.camel@twins>
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
	 <1291975704.6803.59.camel@twins>  <1291987065.6803.151.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 10 Dec 2010 14:27:15 +0100
Message-ID: <1291987635.6803.161.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-12-10 at 14:17 +0100, Peter Zijlstra wrote:
> 
> OK, so I ended up doing the same you did.. Still staring at that, 32bit
> will go very funny in the head once every so often. One possible
> solution would be to ignore the occasional abs(irq_delta) > 2 * delta.
> 
> That would however result in an accounting discrepancy such that:
>    clock_task + irq_time != clock
> 
> Thoughts? 

The brute force solution is a seqcount.. something like so:

---
Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -1786,21 +1786,63 @@ static void deactivate_task(struct rq *r
 #ifdef CONFIG_IRQ_TIME_ACCOUNTING
 
 /*
- * There are no locks covering percpu hardirq/softirq time.
- * They are only modified in account_system_vtime, on corresponding CPU
- * with interrupts disabled. So, writes are safe.
+ * There are no locks covering percpu hardirq/softirq time.  They are only
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
+
+#ifndef CONFIG_64BIT
+static DEFINE_PER_CPU(seqcount_t, irq_time_seq);
+
+static inline void irq_time_write_begin(int cpu)
+{
+	write_seqcount_begin(&per_cpu(irq_time_seq, cpu));
+}
+
+static inline void irq_time_write_end(int cpu)
+{
+	write_seqcount_end(&per_cpu(irq_time_seq, cpu));
+}
+
+static inline u64 irq_time_read(int cpu)
+{
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
+
+static inline u64 irq_time_read(int cpu)
+{
+	return per_cpu(cpu_softirq_time, cpu) + per_cpu(cpu_hardirq_time, cpu);
+}
+#endif /* CONFIG_64BIT */
+
 static int sched_clock_irqtime;
 
 void enable_sched_clock_irqtime(void)
@@ -1820,6 +1862,7 @@ static void __account_system_vtime(int c
 	delta = now - per_cpu(irq_start_time, cpu);
 	per_cpu(irq_start_time, cpu) = now;
 
+	irq_time_write_begin(cpu);
 	if (hardirq_count())
 		per_cpu(cpu_hardirq_time, cpu) += delta;
 	/*
@@ -1830,6 +1873,7 @@ static void __account_system_vtime(int c
 	 */
 	else if (in_serving_softirq() && !(current->flags & PF_KSOFTIRQD))
 		per_cpu(cpu_softirq_time, cpu) += delta;
+	irq_time_write_end(cpu);
 }
 
 /*
@@ -1859,14 +1903,11 @@ EXPORT_SYMBOL_GPL(account_system_vtime);
 
 static u64 irq_time_cpu(struct rq *rq)
 {
-	int cpu = cpu_of(rq);
 	/*
 	 * See the comment in update_rq_clock_task(), ideally we'd update
 	 * the *irq_time values using rq->clock here.
-	 *
-	 * As it stands, reading this from a remote cpu is buggy on 32bit.
 	 */
-	return per_cpu(cpu_softirq_time, cpu) + per_cpu(cpu_hardirq_time, cpu);
+	return irq_time_read(cpu_of(rq));
 }
 
 static void update_rq_clock_task(struct rq *rq, s64 delta)

