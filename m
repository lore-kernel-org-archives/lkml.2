Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932336Ab1BJXnO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 18:43:14 -0500
Received: from www.tglx.de ([62.245.132.106]:44423 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932302Ab1BJXiJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 18:38:09 -0500
Message-Id: <20110210223259.800373869@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 10 Feb 2011 23:38:03 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [patch 57/75] genirq: Move IRQ_AFFINITY_SET to core
References: <20110210222908.661199947@linutronix.de>
Content-Disposition: inline; filename=genirq-move-affinityset.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Keep status in sync until last abuser is gone.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/irq.h    |    9 ++++++++-
 kernel/irq/compat.h    |   11 +++++++++++
 kernel/irq/internals.h |    4 ++++
 kernel/irq/manage.c    |   11 +++++++----
 kernel/irq/settings.h  |    2 ++
 5 files changed, 32 insertions(+), 5 deletions(-)

Index: linux-2.6-tip/include/linux/irq.h
===================================================================
--- linux-2.6-tip.orig/include/linux/irq.h
+++ linux-2.6-tip/include/linux/irq.h
@@ -60,6 +60,7 @@ typedef	void (*irq_flow_handler_t)(unsig
 #define IRQ_MASKED		0x00002000	/* DEPRECATED */
 /* DEPRECATED use irq_setaffinity_pending() instead*/
 #define IRQ_MOVE_PENDING	0x00004000
+#define IRQ_AFFINITY_SET	0x02000000	/* DEPRECATED */
 #endif
 
 #define IRQ_LEVEL		0x00008000	/* IRQ level triggered */
@@ -69,7 +70,6 @@ typedef	void (*irq_flow_handler_t)(unsig
 #define IRQ_NOAUTOEN		0x00080000	/* IRQ will not be enabled on request irq */
 #define IRQ_NO_BALANCING	0x00400000	/* IRQ is excluded from balancing */
 #define IRQ_MOVE_PCNTXT		0x01000000	/* IRQ migration from process context */
-#define IRQ_AFFINITY_SET	0x02000000	/* IRQ affinity was set from userspace*/
 
 #define IRQF_MODIFY_MASK	\
 	(IRQ_TYPE_SENSE_MASK | IRQ_NOPROBE | IRQ_NOREQUEST | \
@@ -132,12 +132,14 @@ struct irq_data {
  * IRQD_SETAFFINITY_PENDING	- Affinity setting is pending
  * IRQD_NO_BALANCING		- Balancing disabled for this IRQ
  * IRQD_PER_CPU			- Interrupt is per cpu
+ * IRQD_AFFINITY_SET		- Interrupt affinity was set
  */
 enum {
 	/* Bit 0 - 7 reserved for TYPE will use later */
 	IRQD_SETAFFINITY_PENDING	= (1 <<  8),
 	IRQD_NO_BALANCING		= (1 << 10),
 	IRQD_PER_CPU			= (1 << 11),
+	IRQD_AFFINITY_SET		= (1 << 12),
 };
 
 static inline bool irqd_is_setaffinity_pending(struct irq_data *d)
@@ -155,6 +157,11 @@ static inline bool irqd_can_balance(stru
 	return !(d->state_use_accessors & (IRQD_PER_CPU | IRQD_NO_BALANCING));
 }
 
+static inline bool irqd_affinity_was_set(struct irq_data *d)
+{
+	return d->state_use_accessors & IRQD_AFFINITY_SET;
+}
+
 /**
  * struct irq_chip - hardware interrupt chip descriptor
  *
Index: linux-2.6-tip/kernel/irq/compat.h
===================================================================
--- linux-2.6-tip.orig/kernel/irq/compat.h
+++ linux-2.6-tip/kernel/irq/compat.h
@@ -46,6 +46,15 @@ static inline void irq_compat_clr_move_p
 {
 	desc->status &= ~IRQ_MOVE_PENDING;
 }
+static inline void irq_compat_set_affinity(struct irq_desc *desc)
+{
+	desc->status |= IRQ_AFFINITY_SET;
+}
+
+static inline void irq_compat_clr_affinity(struct irq_desc *desc)
+{
+	desc->status &= ~IRQ_AFFINITY_SET;
+}
 #else
 static inline void irq_compat_set_progress(struct irq_desc *desc) { }
 static inline void irq_compat_clr_progress(struct irq_desc *desc) { }
@@ -57,5 +66,7 @@ static inline void irq_compat_set_masked
 static inline void irq_compat_clr_masked(struct irq_desc *desc) { }
 static inline void irq_compat_set_move_pending(struct irq_desc *desc) { }
 static inline void irq_compat_clr_move_pending(struct irq_desc *desc) { }
+static inline void irq_compat_set_affinity(struct irq_desc *desc) { }
+static inline void irq_compat_clr_affinity(struct irq_desc *desc) { }
 #endif
 
Index: linux-2.6-tip/kernel/irq/internals.h
===================================================================
--- linux-2.6-tip.orig/kernel/irq/internals.h
+++ linux-2.6-tip/kernel/irq/internals.h
@@ -148,3 +148,7 @@ static inline void irqd_set(struct irq_d
 	d->state_use_accessors |= mask;
 }
 
+static inline bool irqd_has_set(struct irq_data *d, unsigned int mask)
+{
+	return d->state_use_accessors & mask;
+}
Index: linux-2.6-tip/kernel/irq/manage.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/manage.c
+++ linux-2.6-tip/kernel/irq/manage.c
@@ -164,7 +164,8 @@ int irq_set_affinity(unsigned int irq, c
 		kref_get(&desc->affinity_notify->kref);
 		schedule_work(&desc->affinity_notify->work);
 	}
-	desc->status |= IRQ_AFFINITY_SET;
+	irq_compat_set_affinity(desc);
+	irqd_set(&desc->irq_data, IRQD_AFFINITY_SET);
 	raw_spin_unlock_irqrestore(&desc->lock, flags);
 	return ret;
 }
@@ -272,12 +273,14 @@ setup_affinity(unsigned int irq, struct 
 	 * Preserve an userspace affinity setup, but make sure that
 	 * one of the targets is online.
 	 */
-	if (desc->status & (IRQ_AFFINITY_SET)) {
+	if (irqd_has_set(&desc->irq_data, IRQD_AFFINITY_SET)) {
 		if (cpumask_intersects(desc->irq_data.affinity,
 				       cpu_online_mask))
 			set = desc->irq_data.affinity;
-		else
-			desc->status &= ~IRQ_AFFINITY_SET;
+		else {
+			irq_compat_clr_affinity(desc);
+			irqd_clear(&desc->irq_data, IRQD_AFFINITY_SET);
+		}
 	}
 
 	cpumask_and(mask, cpu_online_mask, set);
Index: linux-2.6-tip/kernel/irq/settings.h
===================================================================
--- linux-2.6-tip.orig/kernel/irq/settings.h
+++ linux-2.6-tip/kernel/irq/settings.h
@@ -29,6 +29,8 @@ enum {
 #define IRQ_PER_CPU		GOT_YOU_MORON
 #undef IRQ_NO_BALANCING
 #define IRQ_NO_BALANCING	GOT_YOU_MORON
+#undef IRQ_AFFINITY_SET
+#define IRQ_AFFINITY_SET	GOT_YOU_MORON
 #undef IRQF_MODIFY_MASK
 #define IRQF_MODIFY_MASK	GOT_YOU_MORON
 


