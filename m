Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932359Ab1BJXiT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 18:38:19 -0500
Received: from www.tglx.de ([62.245.132.106]:44451 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932294Ab1BJXiR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 18:38:17 -0500
Message-Id: <20110210223259.893998722@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 10 Feb 2011 23:38:06 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [patch 58/75] genirq: Mirror irq trigger type bits in irq_data.state
References: <20110210222908.661199947@linutronix.de>
Content-Disposition: inline; filename=genirq-mirror-type-mask.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

That's the data structure chip functions get provided. Also allow them
to signal the core code that they updated the flags in irq_data.state
by returning IRQ_SET_MASK_OK_NOCOPY. The default is unchanged.

The type bits should be accessed via:

val = irqd_get_trigger_type(irqdata);
and
irqd_set_trigger_type(irqdata, val);

Coders who access them directly will be tracked down and slapped with
stinking trouts.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---

---
 include/linux/irq.h   |   26 +++++++++++++++++++++++++-
 kernel/irq/chip.c     |    5 ++++-
 kernel/irq/manage.c   |   44 +++++++++++++++++++++++++++-----------------
 kernel/irq/resend.c   |    2 +-
 kernel/irq/settings.h |   30 ++++++++++++++++++++++++++++++
 5 files changed, 87 insertions(+), 20 deletions(-)

Index: linux-2.6-tip/include/linux/irq.h
===================================================================
--- linux-2.6-tip.orig/include/linux/irq.h
+++ linux-2.6-tip/include/linux/irq.h
@@ -46,7 +46,9 @@ typedef	void (*irq_flow_handler_t)(unsig
 #define IRQ_TYPE_EDGE_BOTH (IRQ_TYPE_EDGE_FALLING | IRQ_TYPE_EDGE_RISING)
 #define IRQ_TYPE_LEVEL_HIGH	0x00000004	/* Level high type */
 #define IRQ_TYPE_LEVEL_LOW	0x00000008	/* Level low type */
+#define IRQ_TYPE_LEVEL_MASK	(IRQ_TYPE_LEVEL_LOW | IRQ_TYPE_LEVEL_HIGH)
 #define IRQ_TYPE_SENSE_MASK	0x0000000f	/* Mask of the above */
+
 #define IRQ_TYPE_PROBE		0x00000010	/* Probing in progress */
 
 /* Internal flags */
@@ -129,17 +131,20 @@ struct irq_data {
 /*
  * Bit masks for irq_data.state
  *
+ * IRQD_TRIGGER_MASK		- Mask for the trigger type bits
  * IRQD_SETAFFINITY_PENDING	- Affinity setting is pending
  * IRQD_NO_BALANCING		- Balancing disabled for this IRQ
  * IRQD_PER_CPU			- Interrupt is per cpu
  * IRQD_AFFINITY_SET		- Interrupt affinity was set
+ * IRQD_LEVEL			- Interrupt is level triggered
  */
 enum {
-	/* Bit 0 - 7 reserved for TYPE will use later */
+	IRQD_TRIGGER_MASK		= 0xf,
 	IRQD_SETAFFINITY_PENDING	= (1 <<  8),
 	IRQD_NO_BALANCING		= (1 << 10),
 	IRQD_PER_CPU			= (1 << 11),
 	IRQD_AFFINITY_SET		= (1 << 12),
+	IRQD_LEVEL			= (1 << 13),
 };
 
 static inline bool irqd_is_setaffinity_pending(struct irq_data *d)
@@ -162,6 +167,25 @@ static inline bool irqd_affinity_was_set
 	return d->state_use_accessors & IRQD_AFFINITY_SET;
 }
 
+static inline u32 irqd_get_trigger_type(struct irq_data *d)
+{
+	return d->state_use_accessors & IRQD_TRIGGER_MASK;
+}
+
+/*
+ * Must only be called inside irq_chip.irq_set_type() functions.
+ */
+static inline void irqd_set_trigger_type(struct irq_data *d, u32 type)
+{
+	d->state_use_accessors &= ~IRQD_TRIGGER_MASK;
+	d->state_use_accessors |= type & IRQD_TRIGGER_MASK;
+}
+
+static inline bool irqd_is_level_type(struct irq_data *d)
+{
+	return d->state_use_accessors & IRQD_LEVEL;
+}
+
 /**
  * struct irq_chip - hardware interrupt chip descriptor
  *
Index: linux-2.6-tip/kernel/irq/chip.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/chip.c
+++ linux-2.6-tip/kernel/irq/chip.c
@@ -736,11 +736,14 @@ void irq_modify_status(unsigned int irq,
 
 	irq_settings_clr_and_set(desc, clr, set);
 
-	irqd_clear(&desc->irq_data, IRQD_NO_BALANCING | IRQD_PER_CPU);
+	irqd_clear(&desc->irq_data, IRQD_NO_BALANCING | IRQD_PER_CPU |
+		   IRQD_TRIGGER_MASK | IRQD_LEVEL);
 	if (irq_settings_has_no_balance_set(desc))
 		irqd_set(&desc->irq_data, IRQD_NO_BALANCING);
 	if (irq_settings_is_per_cpu(desc))
 		irqd_set(&desc->irq_data, IRQD_PER_CPU);
 
+	irqd_set(&desc->irq_data, irq_settings_get_trigger_mask(desc));
+
 	raw_spin_unlock_irqrestore(&desc->lock, flags);
 }
Index: linux-2.6-tip/kernel/irq/manage.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/manage.c
+++ linux-2.6-tip/kernel/irq/manage.c
@@ -573,23 +573,32 @@ int __irq_set_trigger(struct irq_desc *d
 		return 0;
 	}
 
+	flags &= IRQ_TYPE_SENSE_MASK;
 	/* caller masked out all except trigger mode flags */
 	ret = chip->irq_set_type(&desc->irq_data, flags);
 
-	if (ret)
-		pr_err("setting trigger mode %lu for irq %u failed (%pF)\n",
-		       flags, irq, chip->irq_set_type);
-	else {
-		if (flags & (IRQ_TYPE_LEVEL_LOW | IRQ_TYPE_LEVEL_HIGH))
-			flags |= IRQ_LEVEL;
-		/* note that IRQF_TRIGGER_MASK == IRQ_TYPE_SENSE_MASK */
-		desc->status &= ~(IRQ_LEVEL | IRQ_TYPE_SENSE_MASK);
-		desc->status |= flags;
+	switch (ret) {
+	case IRQ_SET_MASK_OK:
+		irqd_clear(&desc->irq_data, IRQD_TRIGGER_MASK);
+		irqd_set(&desc->irq_data, flags);
+
+	case IRQ_SET_MASK_OK_NOCOPY:
+		flags = irqd_get_trigger_type(&desc->irq_data);
+		irq_settings_set_trigger_mask(desc, flags);
+		irqd_clear(&desc->irq_data, IRQD_LEVEL);
+		irq_settings_clr_level(desc);
+		if (flags & IRQ_TYPE_LEVEL_MASK) {
+			irq_settings_set_level(desc);
+			irqd_set(&desc->irq_data, IRQD_LEVEL);
+		}
 
 		if (chip != desc->irq_data.chip)
 			irq_chip_set_defaults(desc->irq_data.chip);
+		return 0;
+	default:
+		pr_err("setting trigger mode %lu for irq %u failed (%pF)\n",
+		       flags, irq, chip->irq_set_type);
 	}
-
 	return ret;
 }
 
@@ -929,13 +938,14 @@ __setup_irq(unsigned int irq, struct irq
 		/* Set default affinity mask once everything is setup */
 		setup_affinity(irq, desc, mask);
 
-	} else if ((new->flags & IRQF_TRIGGER_MASK)
-			&& (new->flags & IRQF_TRIGGER_MASK)
-				!= (desc->status & IRQ_TYPE_SENSE_MASK)) {
-		/* hope the handler works with the actual trigger mode... */
-		pr_warning("IRQ %d uses trigger mode %d; requested %d\n",
-				irq, (int)(desc->status & IRQ_TYPE_SENSE_MASK),
-				(int)(new->flags & IRQF_TRIGGER_MASK));
+	} else if (new->flags & IRQF_TRIGGER_MASK) {
+		unsigned int nmsk = new->flags & IRQF_TRIGGER_MASK;
+		unsigned int omsk = irq_settings_get_trigger_mask(desc);
+
+		if (nmsk != omsk)
+			/* hope the handler works with current  trigger mode */
+			pr_warning("IRQ %d uses trigger mode %u; requested %u\n",
+				   irq, nmsk, omsk);
 	}
 
 	new->irq = irq;
Index: linux-2.6-tip/kernel/irq/resend.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/resend.c
+++ linux-2.6-tip/kernel/irq/resend.c
@@ -60,7 +60,7 @@ void check_irq_resend(struct irq_desc *d
 	 * interrupts are resent by hardware when they are still
 	 * active.
 	 */
-	if (desc->status & IRQ_LEVEL)
+	if (irq_settings_is_level(desc))
 		return;
 	if (desc->istate & IRQS_REPLAY)
 		return;
Index: linux-2.6-tip/kernel/irq/settings.h
===================================================================
--- linux-2.6-tip.orig/kernel/irq/settings.h
+++ linux-2.6-tip/kernel/irq/settings.h
@@ -5,6 +5,7 @@
 enum {
 	_IRQ_DEFAULT_INIT_FLAGS	= IRQ_DEFAULT_INIT_FLAGS,
 	_IRQ_PER_CPU		= IRQ_PER_CPU,
+	_IRQ_LEVEL		= IRQ_LEVEL,
 	_IRQ_NO_BALANCING	= IRQ_NO_BALANCING,
 	_IRQF_MODIFY_MASK	= IRQF_MODIFY_MASK,
 };
@@ -31,6 +32,8 @@ enum {
 #define IRQ_NO_BALANCING	GOT_YOU_MORON
 #undef IRQ_AFFINITY_SET
 #define IRQ_AFFINITY_SET	GOT_YOU_MORON
+#undef IRQ_LEVEL
+#define IRQ_LEVEL		GOT_YOU_MORON
 #undef IRQF_MODIFY_MASK
 #define IRQF_MODIFY_MASK	GOT_YOU_MORON
 
@@ -60,3 +63,30 @@ static inline bool irq_settings_has_no_b
 {
 	return desc->status & _IRQ_NO_BALANCING;
 }
+
+static inline u32 irq_settings_get_trigger_mask(struct irq_desc *desc)
+{
+	return desc->status & IRQ_TYPE_SENSE_MASK;
+}
+
+static inline void
+irq_settings_set_trigger_mask(struct irq_desc *desc, u32 mask)
+{
+	desc->status &= ~IRQ_TYPE_SENSE_MASK;
+	desc->status |= mask & IRQ_TYPE_SENSE_MASK;
+}
+
+static inline bool irq_settings_is_level(struct irq_desc *desc)
+{
+	return desc->status & _IRQ_LEVEL;
+}
+
+static inline void irq_settings_clr_level(struct irq_desc *desc)
+{
+	desc->status &= ~_IRQ_LEVEL;
+}
+
+static inline void irq_settings_set_level(struct irq_desc *desc)
+{
+	desc->status |= _IRQ_LEVEL;
+}


