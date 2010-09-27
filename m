Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759152Ab0I0Mo7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 08:44:59 -0400
Received: from www.tglx.de ([62.245.132.106]:34536 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759115Ab0I0Mo5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 08:44:57 -0400
Message-Id: <20100927121842.043608928@linutronix.de>
User-Agent: quilt/0.48-1
Date: Mon, 27 Sep 2010 12:44:44 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-arch@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [patch 06/19] genirq; Provide compat handling for chip->unmask()
References: <20100927121651.904100669@linutronix.de>
Content-Disposition: inline; filename=genirq-wrap-chip-unmask.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wrap the old chip function unmask() until the migration is complete
and the old chip functions are removed.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/irq/chip.c      |   20 ++++++++++++++------
 kernel/irq/manage.c    |    2 +-
 kernel/irq/migration.c |    2 +-
 3 files changed, 16 insertions(+), 8 deletions(-)
Index: linux-2.6-tip/kernel/irq/chip.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/chip.c
+++ linux-2.6-tip/kernel/irq/chip.c
@@ -294,7 +294,7 @@ static void default_enable(unsigned int 
 {
 	struct irq_desc *desc = irq_to_desc(irq);
 
-	desc->chip->unmask(irq);
+	desc->chip->irq_unmask(&desc->irq_data);
 	desc->status &= ~IRQ_MASKED;
 }
 
@@ -333,6 +333,11 @@ static void compat_irq_mask(struct irq_d
 	irq_data_to_desc(data)->chip->mask(data->irq);
 }
 
+static void compat_irq_unmask(struct irq_data *data)
+{
+	irq_data_to_desc(data)->chip->unmask(data->irq);
+}
+
 static void compat_bus_lock(struct irq_data *data)
 {
 	irq_data_to_desc(data)->chip->bus_lock(data->irq);
@@ -373,6 +378,9 @@ void irq_chip_set_defaults(struct irq_ch
 
 	if (chip->mask)
 		chip->irq_mask = compat_irq_mask;
+
+	if (chip->unmask)
+		chip->irq_unmask = compat_irq_unmask;
 }
 
 static inline void mask_ack_irq(struct irq_desc *desc, int irq)
@@ -395,10 +403,10 @@ static inline void mask_irq(struct irq_d
 	}
 }
 
-static inline void unmask_irq(struct irq_desc *desc, int irq)
+static inline void unmask_irq(struct irq_desc *desc)
 {
-	if (desc->chip->unmask) {
-		desc->chip->unmask(irq);
+	if (desc->chip->irq_unmask) {
+		desc->chip->irq_unmask(&desc->irq_data);
 		desc->status &= ~IRQ_MASKED;
 	}
 }
@@ -527,7 +535,7 @@ handle_level_irq(unsigned int irq, struc
 	desc->status &= ~IRQ_INPROGRESS;
 
 	if (!(desc->status & (IRQ_DISABLED | IRQ_ONESHOT)))
-		unmask_irq(desc, irq);
+		unmask_irq(desc);
 out_unlock:
 	raw_spin_unlock(&desc->lock);
 }
@@ -644,7 +652,7 @@ handle_edge_irq(unsigned int irq, struct
 		if (unlikely((desc->status &
 			       (IRQ_PENDING | IRQ_MASKED | IRQ_DISABLED)) ==
 			      (IRQ_PENDING | IRQ_MASKED))) {
-			unmask_irq(desc, irq);
+			unmask_irq(desc);
 		}
 
 		desc->status &= ~IRQ_PENDING;
Index: linux-2.6-tip/kernel/irq/manage.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/manage.c
+++ linux-2.6-tip/kernel/irq/manage.c
@@ -528,7 +528,7 @@ again:
 
 	if (!(desc->status & IRQ_DISABLED) && (desc->status & IRQ_MASKED)) {
 		desc->status &= ~IRQ_MASKED;
-		desc->chip->unmask(irq);
+		desc->chip->irq_unmask(&desc->irq_data);
 	}
 	raw_spin_unlock_irq(&desc->lock);
 	chip_bus_sync_unlock(desc);
Index: linux-2.6-tip/kernel/irq/migration.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/migration.c
+++ linux-2.6-tip/kernel/irq/migration.c
@@ -63,6 +63,6 @@ void move_native_irq(int irq)
 
 	desc->chip->irq_mask(&desc->irq_data);
 	move_masked_irq(irq);
-	desc->chip->unmask(irq);
+	desc->chip->irq_unmask(&desc->irq_data);
 }
 


