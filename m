Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932462Ab1BJXjt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 18:39:49 -0500
Received: from www.tglx.de ([62.245.132.106]:44578 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932426Ab1BJXio (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 18:38:44 -0500
Message-Id: <20110210223300.955806981@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 10 Feb 2011 23:38:32 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [patch 69/75] genirq: Implement irq_data based move_*_irq() versions
References: <20110210222908.661199947@linutronix.de>
Content-Disposition: inline; filename=genirq-implement-irq-move-irq.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No need to lookup the irq descriptor when calling from a chip callback
function which has irq_data already handy.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/irq.h    |    8 ++++++--
 kernel/irq/migration.c |   28 +++++++++++++++++++---------
 2 files changed, 25 insertions(+), 11 deletions(-)

Index: linux-2.6-tip/include/linux/irq.h
===================================================================
--- linux-2.6-tip.orig/include/linux/irq.h
+++ linux-2.6-tip/include/linux/irq.h
@@ -372,11 +372,15 @@ extern void remove_irq(unsigned int irq,
 #ifdef CONFIG_GENERIC_HARDIRQS
 
 #if defined(CONFIG_SMP) && defined(CONFIG_GENERIC_PENDING_IRQ)
-void move_native_irq(int irq);
-void move_masked_irq(int irq);
+void __deprecated move_native_irq(int irq);
+void __deprecated move_masked_irq(int irq);
+void irq_move_irq(struct irq_data *data);
+void irq_move_masked_irq(struct irq_data *data);
 #else
 static inline void move_native_irq(int irq) { }
 static inline void move_masked_irq(int irq) { }
+static inline void irq_move_irq(struct irq_data *data) { }
+static inline void irq_move_masked_irq(struct irq_data *data) { }
 #endif
 
 extern int no_irq_affinity;
Index: linux-2.6-tip/kernel/irq/migration.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/migration.c
+++ linux-2.6-tip/kernel/irq/migration.c
@@ -4,10 +4,10 @@
 
 #include "internals.h"
 
-void move_masked_irq(int irq)
+void irq_move_masked_irq(struct irq_data *idata)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
-	struct irq_chip *chip = desc->irq_data.chip;
+	struct irq_desc *desc = irq_data_to_desc(idata);
+	struct irq_chip *chip = idata->chip;
 
 	if (likely(!irqd_is_setaffinity_pending(&desc->irq_data)))
 		return;
@@ -53,12 +53,17 @@ void move_masked_irq(int irq)
 	cpumask_clear(desc->pending_mask);
 }
 
-void move_native_irq(int irq)
+void move_masked_irq(int irq)
+{
+	irq_move_masked_irq(irq_get_irq_data(irq));
+}
+
+void irq_move_irq(struct irq_data *idata)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
+	struct irq_desc *desc = irq_data_to_desc(idata);
 	bool masked;
 
-	if (likely(!irqd_is_setaffinity_pending(&desc->irq_data)))
+	if (likely(!irqd_is_setaffinity_pending(idata)))
 		return;
 
 	if (unlikely(desc->istate & IRQS_DISABLED))
@@ -71,8 +76,13 @@ void move_native_irq(int irq)
 	 */
 	masked = desc->istate & IRQS_MASKED;
 	if (!masked)
-		desc->irq_data.chip->irq_mask(&desc->irq_data);
-	move_masked_irq(irq);
+		idata->chip->irq_mask(idata);
+	irq_move_masked_irq(idata);
 	if (!masked)
-		desc->irq_data.chip->irq_unmask(&desc->irq_data);
+		idata->chip->irq_unmask(idata);
+}
+
+void move_native_irq(int irq)
+{
+	irq_move_irq(irq_get_irq_data(irq));
 }


