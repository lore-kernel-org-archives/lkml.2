Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757490Ab1BJXhH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 18:37:07 -0500
Received: from www.tglx.de ([62.245.132.106]:44131 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757479Ab1BJXhE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 18:37:04 -0500
Message-Id: <20110210223257.011349671@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 10 Feb 2011 23:36:54 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [patch 28/75] genirq: Use handle_irq_event() in the spurious poll code
References: <20110210222908.661199947@linutronix.de>
Content-Disposition: inline; filename=genirq-convert-spurious.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/irq/spurious.c |   21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

Index: linux-2.6-tip/kernel/irq/spurious.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/spurious.c
+++ linux-2.6-tip/kernel/irq/spurious.c
@@ -56,13 +56,14 @@ bool irq_wait_for_poll(struct irq_desc *
 #endif
 }
 
+
 /*
  * Recovery handler for misrouted interrupts.
  */
 static int try_one_irq(int irq, struct irq_desc *desc, bool force)
 {
+	irqreturn_t ret = IRQ_NONE;
 	struct irqaction *action;
-	int ok = 0;
 
 	raw_spin_lock(&desc->lock);
 
@@ -96,21 +97,17 @@ static int try_one_irq(int irq, struct i
 		goto out;
 	}
 
-	/* Honour the normal IRQ locking and mark it poll in progress */
-	desc->status |= IRQ_INPROGRESS | IRQ_POLL_INPROGRESS;
+	/* Mark it poll in progress */
+	desc->status |= IRQ_POLL_INPROGRESS;
 	do {
-		desc->status &= ~IRQ_PENDING;
-		raw_spin_unlock(&desc->lock);
-		if (handle_IRQ_event(irq, action) != IRQ_NONE)
-			ok = 1;
-		raw_spin_lock(&desc->lock);
+		if (handle_irq_event(desc) == IRQ_HANDLED)
+			ret = IRQ_HANDLED;
 		action = desc->action;
-	}  while ((desc->status & IRQ_PENDING) && action);
-
-	desc->status &= ~(IRQ_INPROGRESS | IRQ_POLL_INPROGRESS);
+	} while ((desc->status & IRQ_PENDING) && action);
+	desc->status &= ~IRQ_POLL_INPROGRESS;
 out:
 	raw_spin_unlock(&desc->lock);
-	return ok;
+	return ret == IRQ_HANDLED;
 }
 
 static int misrouted_irq(int irq)


