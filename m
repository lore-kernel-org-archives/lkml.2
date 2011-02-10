Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757373Ab1BJXgV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 18:36:21 -0500
Received: from www.tglx.de ([62.245.132.106]:43926 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757362Ab1BJXgT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 18:36:19 -0500
Message-Id: <20110210223255.094687488@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 10 Feb 2011 23:36:08 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [patch 08/75] genirq: Fixup poll handling
References: <20110210222908.661199947@linutronix.de>
Content-Disposition: inline; filename=genirq-fixup-poll-handling.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

try_one_irq() contains redundant code and lots of useless checks for
shared interrupts. Check for shared before setting IRQ_INPROGRESS and
then call handle_IRQ_event() while pending. Shorter version with the
same functionality.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/irq/spurious.c |   50 +++++++++++++++++++-------------------------------
 1 file changed, 19 insertions(+), 31 deletions(-)

Index: linux-2.6-tip/kernel/irq/spurious.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/spurious.c
+++ linux-2.6-tip/kernel/irq/spurious.c
@@ -42,48 +42,36 @@ static int try_one_irq(int irq, struct i
 		raw_spin_unlock(&desc->lock);
 		return ok;
 	}
-	/* Honour the normal IRQ locking */
-	desc->status |= IRQ_INPROGRESS;
-	action = desc->action;
-	raw_spin_unlock(&desc->lock);
-
-	while (action) {
-		/* Only shared IRQ handlers are safe to call */
-		if (action->flags & IRQF_SHARED) {
-			if (action->handler(irq, action->dev_id) ==
-				IRQ_HANDLED)
-				ok = 1;
-		}
-		action = action->next;
-	}
-	local_irq_disable();
-	/* Now clean up the flags */
-	raw_spin_lock(&desc->lock);
-	action = desc->action;
-
 	/*
-	 * While we were looking for a fixup someone queued a real
-	 * IRQ clashing with our walk:
+	 * All handlers must agree on IRQF_SHARED, so we test just the
+	 * first. Check for action->next as well.
 	 */
-	while ((desc->status & IRQ_PENDING) && action) {
-		/*
-		 * Perform real IRQ processing for the IRQ we deferred
-		 */
-		work = 1;
+	action = desc->action;
+	if (!action || !(action->flags & IRQF_SHARED) || !action->next)
+		goto out;
+
+	/* Honour the normal IRQ locking */
+	desc->status |= IRQ_INPROGRESS;
+	do {
+		work++;
+		desc->status &= ~IRQ_PENDING;
 		raw_spin_unlock(&desc->lock);
-		handle_IRQ_event(irq, action);
+		if (handle_IRQ_event(irq, action) != IRQ_NONE)
+			ok = 1;
 		raw_spin_lock(&desc->lock);
-		desc->status &= ~IRQ_PENDING;
-	}
+		action = desc->action;
+	}  while ((desc->status & IRQ_PENDING) && action);
+
 	desc->status &= ~IRQ_INPROGRESS;
 	/*
 	 * If we did actual work for the real IRQ line we must let the
 	 * IRQ controller clean up too
 	 */
-	if (work)
+	if (work > 1)
 		irq_end(irq, desc);
-	raw_spin_unlock(&desc->lock);
 
+out:
+	raw_spin_unlock(&desc->lock);
 	return ok;
 }
 


