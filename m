Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757341Ab1BJXgI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 18:36:08 -0500
Received: from www.tglx.de ([62.245.132.106]:43875 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757240Ab1BJXgG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 18:36:06 -0500
Message-Id: <20110210223254.515030932@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 10 Feb 2011 23:35:54 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [patch 02/75] genirq: Simplify affinity related code
References: <20110210222908.661199947@linutronix.de>
Content-Disposition: inline; filename=genirq-simplify-set-aff.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is lot of #ifdef CONFIG_GENERIC_PENDING_IRQ along with
duplicated code in the irq core. Move the #ifdeffery into one place
and cleanup the code so it's readable. No functional change.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/irq/manage.c |   64 +++++++++++++++++++++++++++++++++-------------------
 1 file changed, 41 insertions(+), 23 deletions(-)

Index: linux-2.6-tip/kernel/irq/manage.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/manage.c
+++ linux-2.6-tip/kernel/irq/manage.c
@@ -100,47 +100,70 @@ void irq_set_thread_affinity(struct irq_
 	}
 }
 
+#ifdef CONFIG_GENERIC_PENDING_IRQ
+static inline bool irq_can_move_pcntxt(struct irq_desc *desc)
+{
+	return desc->status & IRQ_MOVE_PCNTXT;
+}
+static inline bool irq_move_pending(struct irq_desc *desc)
+{
+	return desc->status & IRQ_MOVE_PENDING;
+}
+static inline void
+irq_copy_pending(struct irq_desc *desc, const struct cpumask *mask)
+{
+	cpumask_copy(desc->pending_mask, mask);
+}
+static inline void
+irq_get_pending(struct cpumask *mask, struct irq_desc *desc)
+{
+	cpumask_copy(mask, desc->pending_mask);
+}
+#else
+static inline bool irq_can_move_pcntxt(struct irq_desc *desc) { return true; }
+static inline bool irq_move_pending(struct irq_desc *desc) { return false; }
+static inline void
+irq_copy_pending(struct irq_desc *desc, const struct cpumask *mask) { }
+static inline void
+irq_get_pending(struct cpumask *mask, struct irq_desc *desc) { }
+#endif
+
 /**
  *	irq_set_affinity - Set the irq affinity of a given irq
  *	@irq:		Interrupt to set affinity
  *	@cpumask:	cpumask
  *
  */
-int irq_set_affinity(unsigned int irq, const struct cpumask *cpumask)
+int irq_set_affinity(unsigned int irq, const struct cpumask *mask)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
 	struct irq_chip *chip = desc->irq_data.chip;
 	unsigned long flags;
+	int ret = 0;
 
 	if (!chip->irq_set_affinity)
 		return -EINVAL;
 
 	raw_spin_lock_irqsave(&desc->lock, flags);
 
-#ifdef CONFIG_GENERIC_PENDING_IRQ
-	if (desc->status & IRQ_MOVE_PCNTXT) {
-		if (!chip->irq_set_affinity(&desc->irq_data, cpumask, false)) {
-			cpumask_copy(desc->irq_data.affinity, cpumask);
+	if (irq_can_move_pcntxt(desc)) {
+		ret = chip->irq_set_affinity(&desc->irq_data, mask, false);
+		if (!ret) {
+			cpumask_copy(desc->irq_data.affinity, mask);
 			irq_set_thread_affinity(desc);
 		}
-	}
-	else {
+	} else {
 		desc->status |= IRQ_MOVE_PENDING;
-		cpumask_copy(desc->pending_mask, cpumask);
+		irq_copy_pending(desc, mask);
 	}
-#else
-	if (!chip->irq_set_affinity(&desc->irq_data, cpumask, false)) {
-		cpumask_copy(desc->irq_data.affinity, cpumask);
-		irq_set_thread_affinity(desc);
-	}
-#endif
+
 	if (desc->affinity_notify) {
 		kref_get(&desc->affinity_notify->kref);
 		schedule_work(&desc->affinity_notify->work);
 	}
 	desc->status |= IRQ_AFFINITY_SET;
 	raw_spin_unlock_irqrestore(&desc->lock, flags);
-	return 0;
+	return ret;
 }
 
 int irq_set_affinity_hint(unsigned int irq, const struct cpumask *m)
@@ -167,18 +190,13 @@ static void irq_affinity_notify(struct w
 	cpumask_var_t cpumask;
 	unsigned long flags;
 
-	if (!desc)
-		goto out;
-
-	if (!alloc_cpumask_var(&cpumask, GFP_KERNEL))
+	if (!desc || !alloc_cpumask_var(&cpumask, GFP_KERNEL))
 		goto out;
 
 	raw_spin_lock_irqsave(&desc->lock, flags);
-#ifdef CONFIG_GENERIC_PENDING_IRQ
-	if (desc->status & IRQ_MOVE_PENDING)
-		cpumask_copy(cpumask, desc->pending_mask);
+	if (irq_move_pending(desc))
+		irq_get_pending(cpumask, desc);
 	else
-#endif
 		cpumask_copy(cpumask, desc->irq_data.affinity);
 	raw_spin_unlock_irqrestore(&desc->lock, flags);
 


