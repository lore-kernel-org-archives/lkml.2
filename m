Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757500Ab1BJXti (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 18:49:38 -0500
Received: from www.tglx.de ([62.245.132.106]:44100 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757460Ab1BJXg5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 18:36:57 -0500
Message-Id: <20110210223256.534113815@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 10 Feb 2011 23:36:43 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [patch 23/75] genirq: Use handle_irq_event() in handle_simple_irq()
References: <20110210222908.661199947@linutronix.de>
Content-Disposition: inline; filename=genirq-convert-simple-irq.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/irq/chip.c |   15 ++-------------
 1 file changed, 2 insertions(+), 13 deletions(-)

Index: linux-2.6-tip/kernel/irq/chip.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/chip.c
+++ linux-2.6-tip/kernel/irq/chip.c
@@ -446,9 +446,6 @@ static bool irq_check_poll(struct irq_de
 void
 handle_simple_irq(unsigned int irq, struct irq_desc *desc)
 {
-	struct irqaction *action;
-	irqreturn_t action_ret;
-
 	raw_spin_lock(&desc->lock);
 
 	if (unlikely(desc->status & IRQ_INPROGRESS))
@@ -458,19 +455,11 @@ handle_simple_irq(unsigned int irq, stru
 	desc->status &= ~(IRQ_REPLAY | IRQ_WAITING);
 	kstat_incr_irqs_this_cpu(irq, desc);
 
-	action = desc->action;
-	if (unlikely(!action || (desc->status & IRQ_DISABLED)))
+	if (unlikely(!desc->action || (desc->status & IRQ_DISABLED)))
 		goto out_unlock;
 
-	desc->status |= IRQ_INPROGRESS;
-	raw_spin_unlock(&desc->lock);
+	handle_irq_event(desc);
 
-	action_ret = handle_IRQ_event(irq, action);
-	if (!noirqdebug)
-		note_interrupt(irq, desc, action_ret);
-
-	raw_spin_lock(&desc->lock);
-	desc->status &= ~IRQ_INPROGRESS;
 out_unlock:
 	raw_spin_unlock(&desc->lock);
 }


