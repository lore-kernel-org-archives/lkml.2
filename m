Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932310Ab1BJXoD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 18:44:03 -0500
Received: from www.tglx.de ([62.245.132.106]:44362 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757582Ab1BJXh4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 18:37:56 -0500
Message-Id: <20110210223259.134177029@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 10 Feb 2011 23:37:47 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [patch 50/75] genirq: Add IRQ_MOVE_PENDING to irq_data.state
References: <20110210222908.661199947@linutronix.de>
Content-Disposition: inline;
	filename=genirq-move-balancing-and-affinity-set.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

chip implementations need to know about it. Keep status in sync until
all users are fixed. 

Accessor function: irqd_is_setaffinity_pending(irqdata)

Coders who access them directly will be tracked down and slapped with
stinking trouts.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/irq.h    |   20 ++++++++++++++++++--
 kernel/irq/compat.h    |   11 +++++++++++
 kernel/irq/internals.h |   15 +++++++++++++++
 kernel/irq/manage.c    |    4 ++--
 kernel/irq/migration.c |    6 +++---
 kernel/irq/proc.c      |    2 +-
 kernel/irq/settings.h  |    2 ++
 7 files changed, 52 insertions(+), 8 deletions(-)

Index: linux-2.6-tip/include/linux/irq.h
===================================================================
--- linux-2.6-tip.orig/include/linux/irq.h
+++ linux-2.6-tip/include/linux/irq.h
@@ -58,14 +58,15 @@ typedef	void (*irq_flow_handler_t)(unsig
 #define IRQ_DISABLED		0x00000800	/* DEPRECATED */
 #define IRQ_PENDING		0x00001000	/* DEPRECATED */
 #define IRQ_MASKED		0x00002000	/* DEPRECATED */
+/* DEPRECATED use irq_setaffinity_pending() instead*/
+#define IRQ_MOVE_PENDING	0x00004000
 #endif
 
-#define IRQ_LEVEL		0x00004000	/* IRQ level triggered */
+#define IRQ_LEVEL		0x00008000	/* IRQ level triggered */
 #define IRQ_PER_CPU		0x00010000	/* IRQ is per CPU */
 #define IRQ_NOPROBE		0x00020000	/* IRQ is not valid for probing */
 #define IRQ_NOREQUEST		0x00040000	/* IRQ cannot be requested */
 #define IRQ_NOAUTOEN		0x00080000	/* IRQ will not be enabled on request irq */
-#define IRQ_MOVE_PENDING	0x00200000	/* need to re-target IRQ destination */
 #define IRQ_NO_BALANCING	0x00400000	/* IRQ is excluded from balancing */
 #define IRQ_MOVE_PCNTXT		0x01000000	/* IRQ migration from process context */
 #define IRQ_AFFINITY_SET	0x02000000	/* IRQ affinity was set from userspace*/
@@ -126,6 +127,21 @@ struct irq_data {
 #endif
 };
 
+/*
+ * Bit masks for irq_data.state
+ *
+ * IRQD_SETAFFINITY_PENDING	- Affinity setting is pending
+ */
+enum {
+	/* Bit 0 - 7 reserved for TYPE will use later */
+	IRQD_SETAFFINITY_PENDING = (1 << 8),
+};
+
+static inline bool irqd_is_setaffinity_pending(struct irq_data *d)
+{
+	return d->state_use_accessors & IRQD_SETAFFINITY_PENDING;
+}
+
 /**
  * struct irq_chip - hardware interrupt chip descriptor
  *
Index: linux-2.6-tip/kernel/irq/compat.h
===================================================================
--- linux-2.6-tip.orig/kernel/irq/compat.h
+++ linux-2.6-tip/kernel/irq/compat.h
@@ -37,6 +37,15 @@ static inline void irq_compat_clr_masked
 {
 	desc->status &= ~IRQ_MASKED;
 }
+static inline void irq_compat_set_move_pending(struct irq_desc *desc)
+{
+	desc->status |= IRQ_MOVE_PENDING;
+}
+
+static inline void irq_compat_clr_move_pending(struct irq_desc *desc)
+{
+	desc->status &= ~IRQ_MOVE_PENDING;
+}
 #else
 static inline void irq_compat_set_progress(struct irq_desc *desc) { }
 static inline void irq_compat_clr_progress(struct irq_desc *desc) { }
@@ -46,5 +55,7 @@ static inline void irq_compat_set_pendin
 static inline void irq_compat_clr_pending(struct irq_desc *desc) { }
 static inline void irq_compat_set_masked(struct irq_desc *desc) { }
 static inline void irq_compat_clr_masked(struct irq_desc *desc) { }
+static inline void irq_compat_set_move_pending(struct irq_desc *desc) { }
+static inline void irq_compat_clr_move_pending(struct irq_desc *desc) { }
 #endif
 
Index: linux-2.6-tip/kernel/irq/internals.h
===================================================================
--- linux-2.6-tip.orig/kernel/irq/internals.h
+++ linux-2.6-tip/kernel/irq/internals.h
@@ -123,6 +123,21 @@ static inline void chip_bus_sync_unlock(
 }
 
 /*
+ * Manipulation functions for irq_data.state
+ */
+static inline void irqd_set_move_pending(struct irq_data *d)
+{
+	d->state_use_accessors |= IRQD_SETAFFINITY_PENDING;
+	irq_compat_set_move_pending(irq_data_to_desc(d));
+}
+
+static inline void irqd_clr_move_pending(struct irq_data *d)
+{
+	d->state_use_accessors &= ~IRQD_SETAFFINITY_PENDING;
+	irq_compat_clr_move_pending(irq_data_to_desc(d));
+}
+
+/*
  * Debugging printout:
  */
 
Index: linux-2.6-tip/kernel/irq/manage.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/manage.c
+++ linux-2.6-tip/kernel/irq/manage.c
@@ -107,7 +107,7 @@ static inline bool irq_can_move_pcntxt(s
 }
 static inline bool irq_move_pending(struct irq_desc *desc)
 {
-	return desc->status & IRQ_MOVE_PENDING;
+	return irqd_is_setaffinity_pending(&desc->irq_data);
 }
 static inline void
 irq_copy_pending(struct irq_desc *desc, const struct cpumask *mask)
@@ -156,7 +156,7 @@ int irq_set_affinity(unsigned int irq, c
 			ret = 0;
 		}
 	} else {
-		desc->status |= IRQ_MOVE_PENDING;
+		irqd_set_move_pending(&desc->irq_data);
 		irq_copy_pending(desc, mask);
 	}
 
Index: linux-2.6-tip/kernel/irq/migration.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/migration.c
+++ linux-2.6-tip/kernel/irq/migration.c
@@ -9,7 +9,7 @@ void move_masked_irq(int irq)
 	struct irq_desc *desc = irq_to_desc(irq);
 	struct irq_chip *chip = desc->irq_data.chip;
 
-	if (likely(!(desc->status & IRQ_MOVE_PENDING)))
+	if (likely(!irqd_is_setaffinity_pending(&desc->irq_data)))
 		return;
 
 	/*
@@ -20,7 +20,7 @@ void move_masked_irq(int irq)
 		return;
 	}
 
-	desc->status &= ~IRQ_MOVE_PENDING;
+	irqd_clr_move_pending(&desc->irq_data);
 
 	if (unlikely(cpumask_empty(desc->pending_mask)))
 		return;
@@ -58,7 +58,7 @@ void move_native_irq(int irq)
 	struct irq_desc *desc = irq_to_desc(irq);
 	bool masked;
 
-	if (likely(!(desc->status & IRQ_MOVE_PENDING)))
+	if (likely(!irqd_is_setaffinity_pending(&desc->irq_data)))
 		return;
 
 	if (unlikely(desc->istate & IRQS_DISABLED))
Index: linux-2.6-tip/kernel/irq/proc.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/proc.c
+++ linux-2.6-tip/kernel/irq/proc.c
@@ -25,7 +25,7 @@ static int irq_affinity_proc_show(struct
 	const struct cpumask *mask = desc->irq_data.affinity;
 
 #ifdef CONFIG_GENERIC_PENDING_IRQ
-	if (desc->status & IRQ_MOVE_PENDING)
+	if (irqd_is_setaffinity_pending(&desc->irq_data))
 		mask = desc->pending_mask;
 #endif
 	seq_cpumask(m, mask);
Index: linux-2.6-tip/kernel/irq/settings.h
===================================================================
--- linux-2.6-tip.orig/kernel/irq/settings.h
+++ linux-2.6-tip/kernel/irq/settings.h
@@ -20,3 +20,5 @@ enum {
 #define IRQ_MASKED		GOT_YOU_MORON
 #undef IRQ_WAKEUP
 #define IRQ_WAKEUP		GOT_YOU_MORON
+#undef IRQ_MOVE_PENDING
+#define IRQ_MOVE_PENDING	GOT_YOU_MORON


