Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757419Ab1BJXgb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 18:36:31 -0500
Received: from www.tglx.de ([62.245.132.106]:43964 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757390Ab1BJXg0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 18:36:26 -0500
Message-Id: <20110210223255.283320059@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 10 Feb 2011 23:36:12 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [patch 10/75] genirq: spurious: Run only one poller at a time
References: <20110210222908.661199947@linutronix.de>
Content-Disposition: inline; filename=genirq-spurious-run-only-one-poller.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No point in running concurrent pollers which confuse each other by
setting PENDING.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/irq/spurious.c |   16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

Index: linux-2.6-tip/kernel/irq/spurious.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/spurious.c
+++ linux-2.6-tip/kernel/irq/spurious.c
@@ -21,6 +21,8 @@ static int irqfixup __read_mostly;
 #define POLL_SPURIOUS_IRQ_INTERVAL (HZ/10)
 static void poll_spurious_irqs(unsigned long dummy);
 static DEFINE_TIMER(poll_spurious_irq_timer, poll_spurious_irqs, 0, 0);
+static int irq_poll_cpu;
+static atomic_t irq_poll_active;
 
 /*
  * Recovery handler for misrouted interrupts.
@@ -92,6 +94,11 @@ static int misrouted_irq(int irq)
 	struct irq_desc *desc;
 	int i, ok = 0;
 
+	if (atomic_inc_return(&irq_poll_active) == 1)
+		goto out;
+
+	irq_poll_cpu = smp_processor_id();
+
 	for_each_irq_desc(i, desc) {
 		if (!i)
 			 continue;
@@ -102,6 +109,8 @@ static int misrouted_irq(int irq)
 		if (try_one_irq(i, desc, false))
 			ok = 1;
 	}
+out:
+	atomic_dec(&irq_poll_active);
 	/* So the caller can adjust the irq error counts */
 	return ok;
 }
@@ -111,6 +120,10 @@ static void poll_spurious_irqs(unsigned 
 	struct irq_desc *desc;
 	int i;
 
+	if (atomic_inc_return(&irq_poll_active) != 1)
+		goto out;
+	irq_poll_cpu = smp_processor_id();
+
 	for_each_irq_desc(i, desc) {
 		unsigned int status;
 
@@ -127,7 +140,8 @@ static void poll_spurious_irqs(unsigned 
 		try_one_irq(i, desc, true);
 		local_irq_enable();
 	}
-
+out:
+	atomic_dec(&irq_poll_active);
 	mod_timer(&poll_spurious_irq_timer,
 		  jiffies + POLL_SPURIOUS_IRQ_INTERVAL);
 }


