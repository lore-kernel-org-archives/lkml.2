Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757525Ab1BJXhP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 18:37:15 -0500
Received: from www.tglx.de ([62.245.132.106]:44152 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757492Ab1BJXhH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 18:37:07 -0500
Message-Id: <20110210223257.104042700@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 10 Feb 2011 23:36:56 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [patch 29/75] genirq: Simplify handle_irq_event()
References: <20110210222908.661199947@linutronix.de>
Content-Disposition: inline; filename=genirq-simplify-handle-event.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that all core users are converted one layer can go.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/irq/handle.c |   17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

Index: linux-2.6-tip/kernel/irq/handle.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/handle.c
+++ linux-2.6-tip/kernel/irq/handle.c
@@ -51,10 +51,11 @@ static void warn_no_thread(unsigned int 
 	       "but no thread function available.", irq, action->name);
 }
 
-static irqreturn_t __handle_irq_event(unsigned int irq, struct irqaction *action)
+irqreturn_t
+handle_irq_event_percpu(struct irq_desc *desc, struct irqaction *action)
 {
 	irqreturn_t ret, retval = IRQ_NONE;
-	unsigned int status = 0;
+	unsigned int status = 0, irq = desc->irq_data.irq;
 
 	do {
 		trace_irq_handler_entry(irq, action);
@@ -111,17 +112,9 @@ static irqreturn_t __handle_irq_event(un
 	if (status & IRQF_SAMPLE_RANDOM)
 		add_interrupt_randomness(irq);
 
-	return retval;
-}
-
-irqreturn_t
-handle_irq_event_percpu(struct irq_desc *desc, struct irqaction *action)
-{
-	irqreturn_t ret = __handle_irq_event(desc->irq_data.irq, action);
-
 	if (!noirqdebug)
 		note_interrupt(desc->irq_data.irq, desc, ret);
-	return ret;
+	return retval;
 }
 
 irqreturn_t handle_irq_event(struct irq_desc *desc)
@@ -149,5 +142,5 @@ irqreturn_t handle_irq_event(struct irq_
  */
 irqreturn_t handle_IRQ_event(unsigned int irq, struct irqaction *action)
 {
-	return __handle_irq_event(irq, action);
+	return handle_irq_event_percpu(irq_to_desc(irq), action);
 }


