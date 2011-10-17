Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753511Ab1JQTYO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 15:24:14 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:60492 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751737Ab1JQTYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 15:24:13 -0400
Message-ID: <1318879445.2571.20.camel@edumazet-laptop>
Subject: RE: Regression in reading /proc/stat in the newer kernels with
 large SMP and NUMA configurations
From: Eric Dumazet <eric.dumazet@gmail.com>
To: "Seger, Mark" <mark.seger@hp.com>
Cc: "Oberman, Laurence (HAS GSE)" <Laurence.Oberman@hp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Cabaniols, Sebastien" <Sebastien.Cabaniols@hp.com>
Date: Mon, 17 Oct 2011 21:24:05 +0200
In-Reply-To: <9FCE3A46FE7C8045A6207AE4B42E9F9A4EC2E2A848@GVW1119EXC.americas.hpqcorp.net>
References: <8DC664164FA4D1449479E7B36CDCFB1F221E724322@GVW0676EXC.americas.hpqcorp.net>
	 <1318595915.2223.7.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <9FCE3A46FE7C8045A6207AE4B42E9F9A4EC2E29DD4@GVW1119EXC.americas.hpqcorp.net>
	 <1318600023.2223.18.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <8DC664164FA4D1449479E7B36CDCFB1F221F060A48@GVW0676EXC.americas.hpqcorp.net>
	 <1318610416.2223.45.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <8DC664164FA4D1449479E7B36CDCFB1F221F060A92@GVW0676EXC.americas.hpqcorp.net>
	 <1318611542.2223.47.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <8DC664164FA4D1449479E7B36CDCFB1F221F060AC2@GVW0676EXC.americas.hpqcorp.net>
	 <9FCE3A46FE7C8045A6207AE4B42E9F9A4EC2E2A848@GVW1119EXC.americas.hpqcorp.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 17 octobre 2011 à 19:05 +0100, Seger, Mark a écrit :
> >Just FYI, the same behavior is seen on multiple hardware platforms so it
> >is definitely kernel changes. The earlier kernel on the DL785 platform
> >was returning reads within 60 microseconds.
> >I have measured it on multiple platforms.
> >
> >In this case we have a DL980 with HT enabled so you will see 128 CPUS.
> >If I shut off HT, it does not make a difference.
> 
> Given that there have only been a couple of responses to this I can't
> help but wonder if this hasn't really gotten anyone's attention yet or
> if perhaps I'm just overreacting.  I'd claim this breaks key Linux
> utilities by making them have a significantly heavier footprint than
> they used to have.  Historically people would always run top whenever
> they wanted to knowing it had minimal impact on the system and now I'm
> not so sure that will be the case anymore, at least not on big numa
> boxes.
> 
> I can assure you if someone wants to report cpu stats every tenth of a
> second it will more definitely have an impact.

Maybe, but adding an increment of a sum field adds one instruction in
interrupt path. If you have one reader of /proc/stat every second, but
ten million interrupts per second, it might be better as is.

reading /proc/stat is slow path on most workloads, while handling an
interrupt is definitely fast path on all workloads.

The percpu variable makes sure no cache line bouncing occurs in the
kstat_irqs management.

kstat_irqs is needed to provide /proc/interrupts : per cpu counts per
IRQ.

It should be OK to add another field in struct irq_desc
and increment it in kstat_incr_irqs_this_cpu(), because we dirty at
least desc->lock cache line.

This field can be a plain integer, changed under desc->lock protection.

 include/linux/irqdesc.h     |    2 ++
 include/linux/kernel_stat.h |    2 ++
 kernel/irq/irqdesc.c        |   10 +++-------
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/include/linux/irqdesc.h b/include/linux/irqdesc.h
index 150134a..5b250d0 100644
--- a/include/linux/irqdesc.h
+++ b/include/linux/irqdesc.h
@@ -24,6 +24,7 @@ struct timer_rand_state;
  * @depth:		disable-depth, for nested irq_disable() calls
  * @wake_depth:		enable depth, for multiple irq_set_irq_wake() callers
  * @irq_count:		stats field to detect stalled irqs
+ * @stat_irq:		irq stats (sum for all cpus)
  * @last_unhandled:	aging timer for unhandled count
  * @irqs_unhandled:	stats field for spurious unhandled interrupts
  * @lock:		locking for SMP
@@ -50,6 +51,7 @@ struct irq_desc {
 	unsigned int		depth;		/* nested irq disables */
 	unsigned int		wake_depth;	/* nested wake enables */
 	unsigned int		irq_count;	/* For detecting broken IRQs */
+	unsigned int		stat_irq;
 	unsigned long		last_unhandled;	/* Aging timer for unhandled count */
 	unsigned int		irqs_unhandled;
 	raw_spinlock_t		lock;
diff --git a/include/linux/kernel_stat.h b/include/linux/kernel_stat.h
index 0cce2db..56af674 100644
--- a/include/linux/kernel_stat.h
+++ b/include/linux/kernel_stat.h
@@ -54,6 +54,7 @@ static inline void kstat_incr_irqs_this_cpu(unsigned int irq,
 {
 	__this_cpu_inc(kstat.irqs[irq]);
 	__this_cpu_inc(kstat.irqs_sum);
+	desc->stat_irq++;
 }
 
 static inline unsigned int kstat_irqs_cpu(unsigned int irq, int cpu)
@@ -68,6 +69,7 @@ extern unsigned int kstat_irqs_cpu(unsigned int irq, int cpu);
 do {							\
 	__this_cpu_inc(*(DESC)->kstat_irqs);		\
 	__this_cpu_inc(kstat.irqs_sum);			\
+	(DESC)->stat_irq++;				\
 } while (0)
 
 #endif
diff --git a/kernel/irq/irqdesc.c b/kernel/irq/irqdesc.c
index 039b889..938159b 100644
--- a/kernel/irq/irqdesc.c
+++ b/kernel/irq/irqdesc.c
@@ -467,13 +467,9 @@ unsigned int kstat_irqs_cpu(unsigned int irq, int cpu)
 
 unsigned int kstat_irqs(unsigned int irq)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
-	int cpu;
-	int sum = 0;
+	const struct irq_desc *desc = irq_to_desc(irq);
 
-	if (!desc || !desc->kstat_irqs)
+	if (!desc)
 		return 0;
-	for_each_possible_cpu(cpu)
-		sum += *per_cpu_ptr(desc->kstat_irqs, cpu);
-	return sum;
+	return desc->stat_irq;
 }


