Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932509Ab1BJXla (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 18:41:30 -0500
Received: from www.tglx.de ([62.245.132.106]:44533 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932231Ab1BJXic (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 18:38:32 -0500
Message-Id: <20110210223300.667533822@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 10 Feb 2011 23:38:25 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [patch 66/75] genirq: Reflect IRQ_MOVE_PCNTXT in irq_data state
References: <20110210222908.661199947@linutronix.de>
Content-Disposition: inline;
	filename=genirq-reflect-movpcntxt-in-irqdata-state.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Required by x86.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/irq.h |    8 ++++++++
 kernel/irq/chip.c   |    4 +++-
 2 files changed, 11 insertions(+), 1 deletion(-)

Index: linux-2.6-tip/include/linux/irq.h
===================================================================
--- linux-2.6-tip.orig/include/linux/irq.h
+++ linux-2.6-tip/include/linux/irq.h
@@ -171,6 +171,8 @@ struct irq_data {
  *				  valid in irq_chip.functions
  * IRDQ_INPROGRESS		- Interrupt is in progress, only
  *				  valid in irq_chip.functions
+ * IRDQ_MOVE_PCNTXT		- Interrupt can be moved in process
+ *				  context
  */
 enum {
 	IRQD_TRIGGER_MASK		= 0xf,
@@ -182,6 +184,7 @@ enum {
 	IRQD_WAKEUP_STATE		= (1 << 14),
 	IRQD_DISABLED			= (1 << 15),
 	IRQD_INPROGRESS			= (1 << 16),
+	IRQD_MOVE_PCNTXT		= (1 << 17),
 };
 
 static inline bool irqd_is_setaffinity_pending(struct irq_data *d)
@@ -238,6 +241,11 @@ static inline bool irqd_is_disabled(stru
 	return d->state_use_accessors & IRQD_DISABLED;
 }
 
+static inline bool irqd_can_move_in_process_context(struct irq_data *d)
+{
+	return d->state_use_accessors & IRQD_MOVE_PCNTXT;
+}
+
 /**
  * struct irq_chip - hardware interrupt chip descriptor
  *
Index: linux-2.6-tip/kernel/irq/chip.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/chip.c
+++ linux-2.6-tip/kernel/irq/chip.c
@@ -740,11 +740,13 @@ void irq_modify_status(unsigned int irq,
 	irq_settings_clr_and_set(desc, clr, set);
 
 	irqd_clear(&desc->irq_data, IRQD_NO_BALANCING | IRQD_PER_CPU |
-		   IRQD_TRIGGER_MASK | IRQD_LEVEL);
+		   IRQD_TRIGGER_MASK | IRQD_LEVEL | IRQD_MOVE_PCNTXT);
 	if (irq_settings_has_no_balance_set(desc))
 		irqd_set(&desc->irq_data, IRQD_NO_BALANCING);
 	if (irq_settings_is_per_cpu(desc))
 		irqd_set(&desc->irq_data, IRQD_PER_CPU);
+	if (irq_settings_can_move_pcntxt(desc))
+		irqd_set(&desc->irq_data, IRQD_MOVE_PCNTXT);
 
 	irqd_set(&desc->irq_data, irq_settings_get_trigger_mask(desc));
 


