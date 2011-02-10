Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757410Ab1BJXwe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 18:52:34 -0500
Received: from www.tglx.de ([62.245.132.106]:43943 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757374Ab1BJXgW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 18:36:22 -0500
Message-Id: <20110210223255.191531763@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 10 Feb 2011 23:36:10 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [patch 09/75] genirq: Do not poll disabled,
	percpu and timer interrupts
References: <20110210222908.661199947@linutronix.de>
Content-Disposition: inline; filename=genirq-spurious-dont-poll-disabled.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no point in polling disabled lines.

percpu does not make sense at all because we only poll on the cpu
we're currently running on. Also polling per_cpu interrupts is racy as
hell. The handler runs without locking so we might get a huge
surprise.

If the timer interrupt needs polling, then we wont get there anyway.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/irq/spurious.c |   40 ++++++++++++++++++++++++++--------------
 1 file changed, 26 insertions(+), 14 deletions(-)

Index: linux-2.6-tip/kernel/irq/spurious.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/spurious.c
+++ linux-2.6-tip/kernel/irq/spurious.c
@@ -25,30 +25,42 @@ static DEFINE_TIMER(poll_spurious_irq_ti
 /*
  * Recovery handler for misrouted interrupts.
  */
-static int try_one_irq(int irq, struct irq_desc *desc)
+static int try_one_irq(int irq, struct irq_desc *desc, bool force)
 {
 	struct irqaction *action;
 	int ok = 0, work = 0;
 
 	raw_spin_lock(&desc->lock);
+
+	/* PER_CPU and nested thread interrupts are never polled */
+	if (desc->status & (IRQ_PER_CPU | IRQ_NESTED_THREAD))
+		goto out;
+
+	/*
+	 * Do not poll disabled interrupts unless the spurious
+	 * disabled poller asks explicitely.
+	 */
+	if ((desc->status & IRQ_DISABLED) && !force)
+		goto out;
+
+	/*
+	 * All handlers must agree on IRQF_SHARED, so we test just the
+	 * first. Check for action->next as well.
+	 */
+	action = desc->action;
+	if (!action || !(action->flags & IRQF_SHARED) ||
+	    (action->flags & __IRQF_TIMER) || !action->next)
+		goto out;
+
 	/* Already running on another processor */
 	if (desc->status & IRQ_INPROGRESS) {
 		/*
 		 * Already running: If it is shared get the other
 		 * CPU to go looking for our mystery interrupt too
 		 */
-		if (desc->action && (desc->action->flags & IRQF_SHARED))
-			desc->status |= IRQ_PENDING;
-		raw_spin_unlock(&desc->lock);
-		return ok;
-	}
-	/*
-	 * All handlers must agree on IRQF_SHARED, so we test just the
-	 * first. Check for action->next as well.
-	 */
-	action = desc->action;
-	if (!action || !(action->flags & IRQF_SHARED) || !action->next)
+		desc->status |= IRQ_PENDING;
 		goto out;
+	}
 
 	/* Honour the normal IRQ locking */
 	desc->status |= IRQ_INPROGRESS;
@@ -87,7 +99,7 @@ static int misrouted_irq(int irq)
 		if (i == irq)	/* Already tried */
 			continue;
 
-		if (try_one_irq(i, desc))
+		if (try_one_irq(i, desc, false))
 			ok = 1;
 	}
 	/* So the caller can adjust the irq error counts */
@@ -112,7 +124,7 @@ static void poll_spurious_irqs(unsigned 
 			continue;
 
 		local_irq_disable();
-		try_one_irq(i, desc);
+		try_one_irq(i, desc, true);
 		local_irq_enable();
 	}
 


