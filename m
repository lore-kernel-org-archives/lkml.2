Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932489Ab1BJXkp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 18:40:45 -0500
Received: from www.tglx.de ([62.245.132.106]:38099 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932304Ab1BJXkm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 18:40:42 -0500
Message-Id: <20110210223300.571228558@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 10 Feb 2011 23:38:23 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        David Daney <ddaney@caviumnetworks.com>,
        Paul Mundt <lethal@linux-sh.org>
Subject: [patch 65/75] genirq: Reflect IRQ_INPROGRESS/DISABLED in
	irq_data.state
References: <20110210222908.661199947@linutronix.de>
Content-Disposition: inline;
	filename=genirq-reflect-inprogress-disabled-in-irqdata-state.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some irq_chips check irq_desc->state for IRQ_DISABLED or
IRQ_INPROGRESS in their irq_eoi() function. Reflect the state in
irq_data.state so they can access it there.

Note, that this state is only valid in the irq_chip callbacks. Looking
at the state in other context has no guarantee for correctness.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: David S. Miller <davem@davemloft.net>
Cc: David Daney <ddaney@caviumnetworks.com>
Cc: Paul Mundt <lethal@linux-sh.org>
---
 include/linux/irq.h |   16 ++++++++++++++++
 kernel/irq/chip.c   |    2 ++
 kernel/irq/handle.c |    2 ++
 3 files changed, 20 insertions(+)

Index: linux-2.6-tip/include/linux/irq.h
===================================================================
--- linux-2.6-tip.orig/include/linux/irq.h
+++ linux-2.6-tip/include/linux/irq.h
@@ -167,6 +167,10 @@ struct irq_data {
  * IRQD_LEVEL			- Interrupt is level triggered
  * IRQD_WAKEUP_STATE		- Interrupt is configured for wakeup
  *				  from suspend
+ * IRDQ_DISABLED		- Interrupt is disabled, only
+ *				  valid in irq_chip.functions
+ * IRDQ_INPROGRESS		- Interrupt is in progress, only
+ *				  valid in irq_chip.functions
  */
 enum {
 	IRQD_TRIGGER_MASK		= 0xf,
@@ -176,6 +180,8 @@ enum {
 	IRQD_AFFINITY_SET		= (1 << 12),
 	IRQD_LEVEL			= (1 << 13),
 	IRQD_WAKEUP_STATE		= (1 << 14),
+	IRQD_DISABLED			= (1 << 15),
+	IRQD_INPROGRESS			= (1 << 16),
 };
 
 static inline bool irqd_is_setaffinity_pending(struct irq_data *d)
@@ -222,6 +228,16 @@ static inline bool irqd_is_wakeup_set(st
 	return d->state_use_accessors & IRQD_WAKEUP_STATE;
 }
 
+static inline bool irqd_is_inprogres(struct irq_data *d)
+{
+	return d->state_use_accessors & IRQD_INPROGRESS;
+}
+
+static inline bool irqd_is_disabled(struct irq_data *d)
+{
+	return d->state_use_accessors & IRQD_DISABLED;
+}
+
 /**
  * struct irq_chip - hardware interrupt chip descriptor
  *
Index: linux-2.6-tip/kernel/irq/chip.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/chip.c
+++ linux-2.6-tip/kernel/irq/chip.c
@@ -194,12 +194,14 @@ static void irq_state_clr_disabled(struc
 {
 	desc->istate &= ~IRQS_DISABLED;
 	irq_compat_clr_disabled(desc);
+	irqd_clear(&desc->irq_data, IRQD_DISABLED);
 }
 
 static void irq_state_set_disabled(struct irq_desc *desc)
 {
 	desc->istate |= IRQS_DISABLED;
 	irq_compat_set_disabled(desc);
+	irqd_set(&desc->irq_data, IRQD_DISABLED);
 }
 
 static void irq_state_clr_masked(struct irq_desc *desc)
Index: linux-2.6-tip/kernel/irq/handle.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/handle.c
+++ linux-2.6-tip/kernel/irq/handle.c
@@ -126,6 +126,7 @@ irqreturn_t handle_irq_event(struct irq_
 	desc->istate &= ~IRQS_PENDING;
 	irq_compat_set_progress(desc);
 	desc->istate |= IRQS_INPROGRESS;
+	irqd_set(&desc->irq_data, IRQD_INPROGRESS);
 	raw_spin_unlock(&desc->lock);
 
 	ret = handle_irq_event_percpu(desc, action);
@@ -133,6 +134,7 @@ irqreturn_t handle_irq_event(struct irq_
 	raw_spin_lock(&desc->lock);
 	desc->istate &= ~IRQS_INPROGRESS;
 	irq_compat_clr_progress(desc);
+	irqd_clear(&desc->irq_data, IRQD_INPROGRESS);
 	return ret;
 }
 


