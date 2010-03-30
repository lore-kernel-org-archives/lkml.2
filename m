Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757160Ab0C3Xg5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:36:57 -0400
Received: from kroah.org ([198.145.64.141]:46393 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756863Ab0C3XU4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:20:56 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:48:23 2010
Message-Id: <20100330224823.432191633@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:42:09 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Thomas Gleixner <tglx@linutronix.de>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [095/156] genirq: Prevent oneshot irq thread race
In-Reply-To: <20100330230630.GA28824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

commit 0b1adaa031a55e44f5dd942f234bf09d28e8a0d6 upstream.

Lars-Peter pointed out that the oneshot threaded interrupt handler
code has the following race:

 CPU0                            CPU1
 hande_level_irq(irq X)
   mask_ack_irq(irq X)
   handle_IRQ_event(irq X)
     wake_up(thread_handler)
                                 thread handler(irq X) runs
                                 finalize_oneshot(irq X)
				  does not unmask due to
				  !(desc->status & IRQ_MASKED)

 return from irq
 does not unmask due to
 (desc->status & IRQ_ONESHOT)

This leaves the interrupt line masked forever.

The reason for this is the inconsistent handling of the IRQ_MASKED
flag. Instead of setting it in the mask function the oneshot support
sets the flag after waking up the irq thread.

The solution for this is to set/clear the IRQ_MASKED status whenever
we mask/unmask an interrupt line. That's the easy part, but that
cleanup opens another race:

 CPU0                            CPU1
 hande_level_irq(irq)
   mask_ack_irq(irq)
   handle_IRQ_event(irq)
     wake_up(thread_handler)
                                 thread handler(irq) runs
                                 finalize_oneshot_irq(irq)
				  unmask(irq)
     irq triggers again
     handle_level_irq(irq)
       mask_ack_irq(irq)
     return from irq due to IRQ_INPROGRESS

 return from irq
 does not unmask due to
 (desc->status & IRQ_ONESHOT)

This requires that we synchronize finalize_oneshot_irq() with the
primary handler. If IRQ_INPROGESS is set we wait until the primary
handler on the other CPU has returned before unmasking the interrupt
line again.

We probably have never seen that problem because it does not happen on
UP and on SMP the irqbalancer protects us by pinning the primary
handler and the thread to the same CPU.

Reported-by: Lars-Peter Clausen <lars@metafoo.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -359,6 +359,23 @@ static inline void mask_ack_irq(struct irq_desc *desc, int irq)
 		if (desc->chip->ack)
 			desc->chip->ack(irq);
 	}
+	desc->status |= IRQ_MASKED;
+}
+
+static inline void mask_irq(struct irq_desc *desc, int irq)
+{
+	if (desc->chip->mask) {
+		desc->chip->mask(irq);
+		desc->status |= IRQ_MASKED;
+	}
+}
+
+static inline void unmask_irq(struct irq_desc *desc, int irq)
+{
+	if (desc->chip->unmask) {
+		desc->chip->unmask(irq);
+		desc->status &= ~IRQ_MASKED;
+	}
 }
 
 /*
@@ -484,10 +501,8 @@ handle_level_irq(unsigned int irq, struct irq_desc *desc)
 	raw_spin_lock(&desc->lock);
 	desc->status &= ~IRQ_INPROGRESS;
 
-	if (unlikely(desc->status & IRQ_ONESHOT))
-		desc->status |= IRQ_MASKED;
-	else if (!(desc->status & IRQ_DISABLED) && desc->chip->unmask)
-		desc->chip->unmask(irq);
+	if (!(desc->status & (IRQ_DISABLED | IRQ_ONESHOT)))
+		unmask_irq(desc, irq);
 out_unlock:
 	raw_spin_unlock(&desc->lock);
 }
@@ -524,8 +539,7 @@ handle_fasteoi_irq(unsigned int irq, struct irq_desc *desc)
 	action = desc->action;
 	if (unlikely(!action || (desc->status & IRQ_DISABLED))) {
 		desc->status |= IRQ_PENDING;
-		if (desc->chip->mask)
-			desc->chip->mask(irq);
+		mask_irq(desc, irq);
 		goto out;
 	}
 
@@ -593,7 +607,7 @@ handle_edge_irq(unsigned int irq, struct irq_desc *desc)
 		irqreturn_t action_ret;
 
 		if (unlikely(!action)) {
-			desc->chip->mask(irq);
+			mask_irq(desc, irq);
 			goto out_unlock;
 		}
 
@@ -605,8 +619,7 @@ handle_edge_irq(unsigned int irq, struct irq_desc *desc)
 		if (unlikely((desc->status &
 			       (IRQ_PENDING | IRQ_MASKED | IRQ_DISABLED)) ==
 			      (IRQ_PENDING | IRQ_MASKED))) {
-			desc->chip->unmask(irq);
-			desc->status &= ~IRQ_MASKED;
+			unmask_irq(desc, irq);
 		}
 
 		desc->status &= ~IRQ_PENDING;
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index eb6078c..69a3d7b 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -483,8 +483,26 @@ static int irq_wait_for_interrupt(struct irqaction *action)
  */
 static void irq_finalize_oneshot(unsigned int irq, struct irq_desc *desc)
 {
+again:
 	chip_bus_lock(irq, desc);
 	raw_spin_lock_irq(&desc->lock);
+
+	/*
+	 * Implausible though it may be we need to protect us against
+	 * the following scenario:
+	 *
+	 * The thread is faster done than the hard interrupt handler
+	 * on the other CPU. If we unmask the irq line then the
+	 * interrupt can come in again and masks the line, leaves due
+	 * to IRQ_INPROGRESS and the irq line is masked forever.
+	 */
+	if (unlikely(desc->status & IRQ_INPROGRESS)) {
+		raw_spin_unlock_irq(&desc->lock);
+		chip_bus_sync_unlock(irq, desc);
+		cpu_relax();
+		goto again;
+	}
+
 	if (!(desc->status & IRQ_DISABLED) && (desc->status & IRQ_MASKED)) {
 		desc->status &= ~IRQ_MASKED;
 		desc->chip->unmask(irq);


