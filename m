Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759182Ab0I0MpD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 08:45:03 -0400
Received: from www.tglx.de ([62.245.132.106]:34542 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759142Ab0I0Mo7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 08:44:59 -0400
Message-Id: <20100927121841.940355859@linutronix.de>
User-Agent: quilt/0.48-1
Date: Mon, 27 Sep 2010 12:44:42 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-arch@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [patch 05/19] genirq; Provide compat handling for chip->mask()
References: <20100927121651.904100669@linutronix.de>
Content-Disposition: inline; filename=genirq-wrap-chip-mask.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wrap the old chip function mask() until the migration is complete and
the old chip functions are removed.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/irq/chip.c      |   22 +++++++++++++++-------
 kernel/irq/migration.c |    2 +-
 2 files changed, 16 insertions(+), 8 deletions(-)
Index: linux-2.6-tip/kernel/irq/chip.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/chip.c
+++ linux-2.6-tip/kernel/irq/chip.c
@@ -323,11 +323,16 @@ static void default_shutdown(unsigned in
 {
 	struct irq_desc *desc = irq_to_desc(irq);
 
-	desc->chip->mask(irq);
+	desc->chip->irq_mask(&desc->irq_data);
 	desc->status |= IRQ_MASKED;
 }
 
 /* Temporary migration helpers */
+static void compat_irq_mask(struct irq_data *data)
+{
+	irq_data_to_desc(data)->chip->mask(data->irq);
+}
+
 static void compat_bus_lock(struct irq_data *data)
 {
 	irq_data_to_desc(data)->chip->bus_lock(data->irq);
@@ -365,6 +370,9 @@ void irq_chip_set_defaults(struct irq_ch
 		chip->irq_bus_lock = compat_bus_lock;
 	if (chip->bus_sync_unlock)
 		chip->irq_bus_sync_unlock = compat_bus_sync_unlock;
+
+	if (chip->mask)
+		chip->irq_mask = compat_irq_mask;
 }
 
 static inline void mask_ack_irq(struct irq_desc *desc, int irq)
@@ -372,17 +380,17 @@ static inline void mask_ack_irq(struct i
 	if (desc->chip->mask_ack)
 		desc->chip->mask_ack(irq);
 	else {
-		desc->chip->mask(irq);
+		desc->chip->irq_mask(&desc->irq_data);
 		if (desc->chip->ack)
 			desc->chip->ack(irq);
 	}
 	desc->status |= IRQ_MASKED;
 }
 
-static inline void mask_irq(struct irq_desc *desc, int irq)
+static inline void mask_irq(struct irq_desc *desc)
 {
-	if (desc->chip->mask) {
-		desc->chip->mask(irq);
+	if (desc->chip->irq_mask) {
+		desc->chip->irq_mask(&desc->irq_data);
 		desc->status |= IRQ_MASKED;
 	}
 }
@@ -556,7 +564,7 @@ handle_fasteoi_irq(unsigned int irq, str
 	action = desc->action;
 	if (unlikely(!action || (desc->status & IRQ_DISABLED))) {
 		desc->status |= IRQ_PENDING;
-		mask_irq(desc, irq);
+		mask_irq(desc);
 		goto out;
 	}
 
@@ -624,7 +632,7 @@ handle_edge_irq(unsigned int irq, struct
 		irqreturn_t action_ret;
 
 		if (unlikely(!action)) {
-			mask_irq(desc, irq);
+			mask_irq(desc);
 			goto out_unlock;
 		}
 
Index: linux-2.6-tip/kernel/irq/migration.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/migration.c
+++ linux-2.6-tip/kernel/irq/migration.c
@@ -61,7 +61,7 @@ void move_native_irq(int irq)
 	if (unlikely(desc->status & IRQ_DISABLED))
 		return;
 
-	desc->chip->mask(irq);
+	desc->chip->irq_mask(&desc->irq_data);
 	move_masked_irq(irq);
 	desc->chip->unmask(irq);
 }


