Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934575Ab1CYLNY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 07:13:24 -0400
Received: from www.linutronix.de ([62.245.132.108]:38585 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934497Ab1CYLMc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 07:12:32 -0400
Message-Id: <20110325111218.249659750@linutronix.de>
User-Agent: quilt/0.48-1
Date: Fri, 25 Mar 2011 11:12:31 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: [patch 07/10] mfd: twl4030: Cleanup interrupt handling
References: <20110325110939.701487744@linutronix.de>
Content-Disposition: inline; filename=mfd-twl4.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

irq_desc checking in a function which is called with that irq
descriptor locked, is pointless. Equally pointless as the irq desc
check in the interrupt service routine. The driver sets those lines
up, so that cant go away magically.

Remove the open coded handler magic and use the proper accessor.

No need to fiddle with irq_desc in the type setting function. The
original value is in irq_data and the core code stores the new setting
when the return value is 0.

This driver needs to be converted to threaded interrupts and buslock.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/mfd/twl4030-irq.c |   46 ++++++++--------------------------------------
 1 file changed, 8 insertions(+), 38 deletions(-)

Index: linux-2.6-tip/drivers/mfd/twl4030-irq.c
===================================================================
--- linux-2.6-tip.orig/drivers/mfd/twl4030-irq.c
+++ linux-2.6-tip/drivers/mfd/twl4030-irq.c
@@ -320,24 +320,8 @@ static int twl4030_irq_thread(void *data
 		for (module_irq = twl4030_irq_base;
 				pih_isr;
 				pih_isr >>= 1, module_irq++) {
-			if (pih_isr & 0x1) {
-				struct irq_desc *d = irq_to_desc(module_irq);
-
-				if (!d) {
-					pr_err("twl4030: Invalid SIH IRQ: %d\n",
-					       module_irq);
-					return -EINVAL;
-				}
-
-				/* These can't be masked ... always warn
-				 * if we get any surprises.
-				 */
-				if (d->status & IRQ_DISABLED)
-					note_interrupt(module_irq, d,
-							IRQ_NONE);
-				else
-					d->handle_irq(module_irq, d);
-			}
+			if (pih_isr & 0x1)
+				generic_handle_irq(module_irq);
 		}
 		local_irq_enable();
 
@@ -560,24 +544,18 @@ static void twl4030_sih_do_edge(struct w
 	/* Modify only the bits we know must change */
 	while (edge_change) {
 		int		i = fls(edge_change) - 1;
-		struct irq_desc	*d = irq_to_desc(i + agent->irq_base);
+		struct irq_data	*idata = irq_get_irq_data(i + agent->irq_base);
 		int		byte = 1 + (i >> 2);
 		int		off = (i & 0x3) * 2;
-
-		if (!d) {
-			pr_err("twl4030: Invalid IRQ: %d\n",
-			       i + agent->irq_base);
-			return;
-		}
+		unsigned int	type;
 
 		bytes[byte] &= ~(0x03 << off);
 
-		raw_spin_lock_irq(&d->lock);
-		if (d->status & IRQ_TYPE_EDGE_RISING)
+		type = irqd_get_trigger_type(idata);
+		if (type & IRQ_TYPE_EDGE_RISING)
 			bytes[byte] |= BIT(off + 1);
-		if (d->status & IRQ_TYPE_EDGE_FALLING)
+		if (type & IRQ_TYPE_EDGE_FALLING)
 			bytes[byte] |= BIT(off + 0);
-		raw_spin_unlock_irq(&d->lock);
 
 		edge_change &= ~BIT(i);
 	}
@@ -626,21 +604,13 @@ static void twl4030_sih_unmask(struct ir
 static int twl4030_sih_set_type(struct irq_data *data, unsigned trigger)
 {
 	struct sih_agent *sih = irq_data_get_irq_chip_data(data);
-	struct irq_desc *desc = irq_to_desc(data->irq);
 	unsigned long flags;
 
-	if (!desc) {
-		pr_err("twl4030: Invalid IRQ: %d\n", data->irq);
-		return -EINVAL;
-	}
-
 	if (trigger & ~(IRQ_TYPE_EDGE_FALLING | IRQ_TYPE_EDGE_RISING))
 		return -EINVAL;
 
 	spin_lock_irqsave(&sih_agent_lock, flags);
-	if ((desc->status & IRQ_TYPE_SENSE_MASK) != trigger) {
-		desc->status &= ~IRQ_TYPE_SENSE_MASK;
-		desc->status |= trigger;
+	if (irqd_get_trigger_type(data) != trigger) {
 		sih->edge_change |= BIT(data->irq - sih->irq_base);
 		queue_work(wq, &sih->edge_work);
 	}


