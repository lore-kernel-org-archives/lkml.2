Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932330Ab1BJXiM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 18:38:12 -0500
Received: from www.tglx.de ([62.245.132.106]:44415 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932305Ab1BJXiH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 18:38:07 -0500
Message-Id: <20110210223259.609792276@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 10 Feb 2011 23:37:59 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [patch 55/75] genirq: Mirror IRQ_PER_CPU and IRQ_NO_BALANCING in
	irq_data.state
References: <20110210222908.661199947@linutronix.de>
Content-Disposition: inline;
	filename=genirq-mirror-percpu-in-irq-data-state.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

That's the right data structure to look at for arch code.

Accessor functions are provided.

	 irqd_is_per_cpu(irqdata);
	 irqd_can_balance(irqdata);

Coders who access them directly will be tracked down and slapped with
stinking trouts.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/irq.h    |   16 +++++++++++++++-
 kernel/irq/chip.c      |   15 +++++++++------
 kernel/irq/internals.h |   11 +++++++++++
 kernel/irq/manage.c    |   16 ++++++++++------
 kernel/irq/migration.c |    2 +-
 kernel/irq/settings.h  |   36 ++++++++++++++++++++++++++++++++++++
 kernel/irq/spurious.c  |    3 ++-
 7 files changed, 84 insertions(+), 15 deletions(-)

Index: linux-2.6-tip/include/linux/irq.h
===================================================================
--- linux-2.6-tip.orig/include/linux/irq.h
+++ linux-2.6-tip/include/linux/irq.h
@@ -130,10 +130,14 @@ struct irq_data {
  * Bit masks for irq_data.state
  *
  * IRQD_SETAFFINITY_PENDING	- Affinity setting is pending
+ * IRQD_NO_BALANCING		- Balancing disabled for this IRQ
+ * IRQD_PER_CPU			- Interrupt is per cpu
  */
 enum {
 	/* Bit 0 - 7 reserved for TYPE will use later */
-	IRQD_SETAFFINITY_PENDING = (1 << 8),
+	IRQD_SETAFFINITY_PENDING	= (1 <<  8),
+	IRQD_NO_BALANCING		= (1 << 10),
+	IRQD_PER_CPU			= (1 << 11),
 };
 
 static inline bool irqd_is_setaffinity_pending(struct irq_data *d)
@@ -141,6 +145,16 @@ static inline bool irqd_is_setaffinity_p
 	return d->state_use_accessors & IRQD_SETAFFINITY_PENDING;
 }
 
+static inline bool irqd_is_per_cpu(struct irq_data *d)
+{
+	return d->state_use_accessors & IRQD_PER_CPU;
+}
+
+static inline bool irqd_can_balance(struct irq_data *d)
+{
+	return !(d->state_use_accessors & (IRQD_PER_CPU | IRQD_NO_BALANCING));
+}
+
 /**
  * struct irq_chip - hardware interrupt chip descriptor
  *
Index: linux-2.6-tip/kernel/irq/chip.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/chip.c
+++ linux-2.6-tip/kernel/irq/chip.c
@@ -732,12 +732,15 @@ void irq_modify_status(unsigned int irq,
 	if (!desc)
 		return;
 
-	/* Sanitize flags */
-	set &= IRQF_MODIFY_MASK;
-	clr &= IRQF_MODIFY_MASK;
-
 	raw_spin_lock_irqsave(&desc->lock, flags);
-	desc->status &= ~clr;
-	desc->status |= set;
+
+	irq_settings_clr_and_set(desc, clr, set);
+
+	irqd_clear(&desc->irq_data, IRQD_NO_BALANCING | IRQD_PER_CPU);
+	if (irq_settings_has_no_balance_set(desc))
+		irqd_set(&desc->irq_data, IRQD_NO_BALANCING);
+	if (irq_settings_is_per_cpu(desc))
+		irqd_set(&desc->irq_data, IRQD_PER_CPU);
+
 	raw_spin_unlock_irqrestore(&desc->lock, flags);
 }
Index: linux-2.6-tip/kernel/irq/internals.h
===================================================================
--- linux-2.6-tip.orig/kernel/irq/internals.h
+++ linux-2.6-tip/kernel/irq/internals.h
@@ -137,3 +137,14 @@ static inline void irqd_clr_move_pending
 	d->state_use_accessors &= ~IRQD_SETAFFINITY_PENDING;
 	irq_compat_clr_move_pending(irq_data_to_desc(d));
 }
+
+static inline void irqd_clear(struct irq_data *d, unsigned int mask)
+{
+	d->state_use_accessors &= ~mask;
+}
+
+static inline void irqd_set(struct irq_data *d, unsigned int mask)
+{
+	d->state_use_accessors |= mask;
+}
+
Index: linux-2.6-tip/kernel/irq/manage.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/manage.c
+++ linux-2.6-tip/kernel/irq/manage.c
@@ -73,8 +73,8 @@ int irq_can_set_affinity(unsigned int ir
 {
 	struct irq_desc *desc = irq_to_desc(irq);
 
-	if ((desc->status & (IRQ_PER_CPU | IRQ_NO_BALANCING)) ||
-	    !desc->irq_data.chip || !desc->irq_data.chip->irq_set_affinity)
+	if (!irqd_can_balance(&desc->irq_data) || !desc->irq_data.chip ||
+	    !desc->irq_data.chip->irq_set_affinity)
 		return 0;
 
 	return 1;
@@ -903,8 +903,10 @@ __setup_irq(unsigned int irq, struct irq
 				  IRQS_INPROGRESS | IRQS_ONESHOT | \
 				  IRQS_WAITING);
 
-		if (new->flags & IRQF_PERCPU)
-			desc->status |= IRQ_PER_CPU;
+		if (new->flags & IRQF_PERCPU) {
+			irqd_set(&desc->irq_data, IRQD_PER_CPU);
+			irq_settings_set_per_cpu(desc);
+		}
 
 		if (new->flags & IRQF_ONESHOT)
 			desc->istate |= IRQS_ONESHOT;
@@ -916,8 +918,10 @@ __setup_irq(unsigned int irq, struct irq
 			desc->depth = 1;
 
 		/* Exclude IRQ from balancing if requested */
-		if (new->flags & IRQF_NOBALANCING)
-			desc->status |= IRQ_NO_BALANCING;
+		if (new->flags & IRQF_NOBALANCING) {
+			irq_settings_set_no_balancing(desc);
+			irqd_set(&desc->irq_data, IRQD_NO_BALANCING);
+		}
 
 		/* Set default affinity mask once everything is setup */
 		setup_affinity(irq, desc, mask);
Index: linux-2.6-tip/kernel/irq/migration.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/migration.c
+++ linux-2.6-tip/kernel/irq/migration.c
@@ -15,7 +15,7 @@ void move_masked_irq(int irq)
 	/*
 	 * Paranoia: cpu-local interrupts shouldn't be calling in here anyway.
 	 */
-	if (desc->status & (IRQ_PER_CPU | IRQ_NO_BALANCING)) {
+	if (!irqd_can_balance(&desc->irq_data)) {
 		WARN_ON(1);
 		return;
 	}
Index: linux-2.6-tip/kernel/irq/settings.h
===================================================================
--- linux-2.6-tip.orig/kernel/irq/settings.h
+++ linux-2.6-tip/kernel/irq/settings.h
@@ -4,6 +4,9 @@
  */
 enum {
 	_IRQ_DEFAULT_INIT_FLAGS	= IRQ_DEFAULT_INIT_FLAGS,
+	_IRQ_PER_CPU		= IRQ_PER_CPU,
+	_IRQ_NO_BALANCING	= IRQ_NO_BALANCING,
+	_IRQF_MODIFY_MASK	= IRQF_MODIFY_MASK,
 };
 
 #undef IRQ_INPROGRESS
@@ -22,3 +25,36 @@ enum {
 #define IRQ_WAKEUP		GOT_YOU_MORON
 #undef IRQ_MOVE_PENDING
 #define IRQ_MOVE_PENDING	GOT_YOU_MORON
+#undef IRQ_PER_CPU
+#define IRQ_PER_CPU		GOT_YOU_MORON
+#undef IRQ_NO_BALANCING
+#define IRQ_NO_BALANCING	GOT_YOU_MORON
+#undef IRQF_MODIFY_MASK
+#define IRQF_MODIFY_MASK	GOT_YOU_MORON
+
+static inline void
+irq_settings_clr_and_set(struct irq_desc *desc, u32 clr, u32 set)
+{
+	desc->status &= ~(clr & _IRQF_MODIFY_MASK);
+	desc->status |= (set & _IRQF_MODIFY_MASK);
+}
+
+static inline bool irq_settings_is_per_cpu(struct irq_desc *desc)
+{
+	return desc->status & _IRQ_PER_CPU;
+}
+
+static inline void irq_settings_set_per_cpu(struct irq_desc *desc)
+{
+	desc->status |= _IRQ_PER_CPU;
+}
+
+static inline void irq_settings_set_no_balancing(struct irq_desc *desc)
+{
+	desc->status |= _IRQ_NO_BALANCING;
+}
+
+static inline bool irq_settings_has_no_balance_set(struct irq_desc *desc)
+{
+	return desc->status & _IRQ_NO_BALANCING;
+}
Index: linux-2.6-tip/kernel/irq/spurious.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/spurious.c
+++ linux-2.6-tip/kernel/irq/spurious.c
@@ -68,7 +68,8 @@ static int try_one_irq(int irq, struct i
 	raw_spin_lock(&desc->lock);
 
 	/* PER_CPU and nested thread interrupts are never polled */
-	if ((desc->status & IRQ_PER_CPU) || (desc->istate & IRQS_NESTED_THREAD))
+	if (irq_settings_is_per_cpu(desc) ||
+	    (desc->istate & IRQS_NESTED_THREAD))
 		goto out;
 
 	/*


