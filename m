Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932325Ab0I0MpJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 08:45:09 -0400
Received: from www.tglx.de ([62.245.132.106]:34564 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759197Ab0I0MpF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 08:45:05 -0400
Message-Id: <20100927121842.142624725@linutronix.de>
User-Agent: quilt/0.48-1
Date: Mon, 27 Sep 2010 12:44:47 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-arch@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [patch 07/19] genirq; Provide compat handling for chip->ack()
References: <20100927121651.904100669@linutronix.de>
Content-Disposition: inline; filename=genirq-wrap-chip-ack.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wrap the old chip function ack() until the migration is complete and
the old chip functions are removed.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/irq/chip.c |   20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)
Index: linux-2.6-tip/kernel/irq/chip.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/chip.c
+++ linux-2.6-tip/kernel/irq/chip.c
@@ -338,6 +338,11 @@ static void compat_irq_unmask(struct irq
 	irq_data_to_desc(data)->chip->unmask(data->irq);
 }
 
+static void compat_irq_ack(struct irq_data *data)
+{
+	irq_data_to_desc(data)->chip->ack(data->irq);
+}
+
 static void compat_bus_lock(struct irq_data *data)
 {
 	irq_data_to_desc(data)->chip->bus_lock(data->irq);
@@ -375,12 +380,12 @@ void irq_chip_set_defaults(struct irq_ch
 		chip->irq_bus_lock = compat_bus_lock;
 	if (chip->bus_sync_unlock)
 		chip->irq_bus_sync_unlock = compat_bus_sync_unlock;
-
 	if (chip->mask)
 		chip->irq_mask = compat_irq_mask;
-
 	if (chip->unmask)
 		chip->irq_unmask = compat_irq_unmask;
+	if (chip->ack)
+		chip->irq_ack = compat_irq_ack;
 }
 
 static inline void mask_ack_irq(struct irq_desc *desc, int irq)
@@ -389,8 +394,8 @@ static inline void mask_ack_irq(struct i
 		desc->chip->mask_ack(irq);
 	else {
 		desc->chip->irq_mask(&desc->irq_data);
-		if (desc->chip->ack)
-			desc->chip->ack(irq);
+		if (desc->chip->irq_ack)
+			desc->chip->irq_ack(&desc->irq_data);
 	}
 	desc->status |= IRQ_MASKED;
 }
@@ -629,8 +634,7 @@ handle_edge_irq(unsigned int irq, struct
 	kstat_incr_irqs_this_cpu(irq, desc);
 
 	/* Start handling the irq */
-	if (desc->chip->ack)
-		desc->chip->ack(irq);
+	desc->chip->irq_ack(&desc->irq_data);
 
 	/* Mark the IRQ currently in progress.*/
 	desc->status |= IRQ_INPROGRESS;
@@ -683,8 +687,8 @@ handle_percpu_irq(unsigned int irq, stru
 
 	kstat_incr_irqs_this_cpu(irq, desc);
 
-	if (desc->chip->ack)
-		desc->chip->ack(irq);
+	if (desc->chip->irq_ack)
+		desc->chip->irq_ack(&desc->irq_data);
 
 	action_ret = handle_IRQ_event(irq, desc->action);
 	if (!noirqdebug)


