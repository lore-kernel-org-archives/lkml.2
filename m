Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759227Ab0I0Mpy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 08:45:54 -0400
Received: from www.tglx.de ([62.245.132.106]:34559 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759188Ab0I0MpE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 08:45:04 -0400
Message-Id: <20100927121842.240806983@linutronix.de>
User-Agent: quilt/0.48-1
Date: Mon, 27 Sep 2010 12:44:50 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-arch@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [patch 08/19] genirq; Provide compat handling for chip->mask_ack()
References: <20100927121651.904100669@linutronix.de>
Content-Disposition: inline; filename=genirq-wrap-chip-mask-ack.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wrap the old chip function mask_ack() until the migration is complete
and the old chip functions are removed.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/irq/chip.c      |   20 ++++++++++++++++++--
 kernel/irq/internals.h |   17 +++++++++++------
 kernel/irq/manage.c    |   22 +++++++++++-----------
 3 files changed, 40 insertions(+), 19 deletions(-)
Index: linux-2.6-tip/kernel/irq/chip.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/chip.c
+++ linux-2.6-tip/kernel/irq/chip.c
@@ -343,6 +343,11 @@ static void compat_irq_ack(struct irq_da
 	irq_data_to_desc(data)->chip->ack(data->irq);
 }
 
+static void compat_irq_mask_ack(struct irq_data *data)
+{
+	irq_data_to_desc(data)->chip->mask_ack(data->irq);
+}
+
 static void compat_bus_lock(struct irq_data *data)
 {
 	irq_data_to_desc(data)->chip->bus_lock(data->irq);
@@ -386,12 +391,14 @@ void irq_chip_set_defaults(struct irq_ch
 		chip->irq_unmask = compat_irq_unmask;
 	if (chip->ack)
 		chip->irq_ack = compat_irq_ack;
+	if (chip->mask_ack)
+		chip->irq_mask_ack = compat_irq_mask_ack;
 }
 
-static inline void mask_ack_irq(struct irq_desc *desc, int irq)
+static inline void mask_ack_irq(struct irq_desc *desc)
 {
-	if (desc->chip->mask_ack)
-		desc->chip->mask_ack(irq);
+	if (desc->chip->irq_mask_ack)
+		desc->chip->irq_mask_ack(&desc->irq_data);
 	else {
 		desc->chip->irq_mask(&desc->irq_data);
 		if (desc->chip->irq_ack)
@@ -514,7 +521,7 @@ handle_level_irq(unsigned int irq, struc
 	irqreturn_t action_ret;
 
 	raw_spin_lock(&desc->lock);
-	mask_ack_irq(desc, irq);
+	mask_ack_irq(desc);
 
 	if (unlikely(desc->status & IRQ_INPROGRESS))
 		goto out_unlock;
@@ -628,7 +635,7 @@ handle_edge_irq(unsigned int irq, struct
 	if (unlikely((desc->status & (IRQ_INPROGRESS | IRQ_DISABLED)) ||
 		    !desc->action)) {
 		desc->status |= (IRQ_PENDING | IRQ_MASKED);
-		mask_ack_irq(desc, irq);
+		mask_ack_irq(desc);
 		goto out_unlock;
 	}
 	kstat_incr_irqs_this_cpu(irq, desc);
@@ -733,7 +740,7 @@ __set_irq_handler(unsigned int irq, irq_
 	/* Uninstall? */
 	if (handle == handle_bad_irq) {
 		if (desc->chip != &no_irq_chip)
-			mask_ack_irq(desc, irq);
+			mask_ack_irq(desc);
 		desc->status |= IRQ_DISABLED;
 		desc->depth = 1;
 	}


