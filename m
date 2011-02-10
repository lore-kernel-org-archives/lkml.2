Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932418Ab1BJXie (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 18:38:34 -0500
Received: from www.tglx.de ([62.245.132.106]:44523 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932366Ab1BJXib (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 18:38:31 -0500
Message-Id: <20110210223300.376194902@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 10 Feb 2011 23:38:18 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [patch 63/75] genirq: Add IRQCHIP_SET_TYPE_MASKED flag and
	IRQD_WAKE_SET
References: <20110210222908.661199947@linutronix.de>
Content-Disposition: inline; filename=genirq-add-set-type-masked-flag.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

irq_chips, which require to mask the chip before changing the trigger
type should set this flag. So the core takes care of it and the
requirement for looking into desc->status in the chip goes away.

Add also a flag which reflects the WAKEUP state of the interrupt line,
which is also required by some of those chips.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Walleij <linus.walleij@stericsson.com>
Cc: Lars-Peter Clausen <lars@metafoo.de>
---
 include/linux/irq.h    |    9 +++++++++
 kernel/irq/chip.c      |    4 ++--
 kernel/irq/internals.h |    2 ++
 kernel/irq/manage.c    |   14 ++++++++++++--
 4 files changed, 25 insertions(+), 4 deletions(-)

Index: linux-2.6-tip/include/linux/irq.h
===================================================================
--- linux-2.6-tip.orig/include/linux/irq.h
+++ linux-2.6-tip/include/linux/irq.h
@@ -305,6 +305,15 @@ struct irq_chip {
 #endif
 };
 
+/*
+ * irq_chip specific flags
+ *
+ * IRQCHIP_SET_TYPE_MASKED:		Mask before calling chip.irq_set_type()
+ */
+enum {
+	IRQCHIP_SET_TYPE_MASKED		= (1 <<  0),
+};
+
 /* This include will go away once we isolated irq_desc usage to core code */
 #include <linux/irqdesc.h>
 
Index: linux-2.6-tip/kernel/irq/chip.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/chip.c
+++ linux-2.6-tip/kernel/irq/chip.c
@@ -393,7 +393,7 @@ static inline void mask_ack_irq(struct i
 	irq_state_set_masked(desc);
 }
 
-static inline void mask_irq(struct irq_desc *desc)
+void mask_irq(struct irq_desc *desc)
 {
 	if (desc->irq_data.chip->irq_mask) {
 		desc->irq_data.chip->irq_mask(&desc->irq_data);
@@ -401,7 +401,7 @@ static inline void mask_irq(struct irq_d
 	}
 }
 
-static inline void unmask_irq(struct irq_desc *desc)
+void unmask_irq(struct irq_desc *desc)
 {
 	if (desc->irq_data.chip->irq_unmask) {
 		desc->irq_data.chip->irq_unmask(&desc->irq_data);
Index: linux-2.6-tip/kernel/irq/internals.h
===================================================================
--- linux-2.6-tip.orig/kernel/irq/internals.h
+++ linux-2.6-tip/kernel/irq/internals.h
@@ -81,6 +81,8 @@ extern int irq_startup(struct irq_desc *
 extern void irq_shutdown(struct irq_desc *desc);
 extern void irq_enable(struct irq_desc *desc);
 extern void irq_disable(struct irq_desc *desc);
+extern void mask_irq(struct irq_desc *desc);
+extern void unmask_irq(struct irq_desc *desc);
 
 extern void init_kstat_irqs(struct irq_desc *desc, int node, int nr);
 
Index: linux-2.6-tip/kernel/irq/manage.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/manage.c
+++ linux-2.6-tip/kernel/irq/manage.c
@@ -560,8 +560,8 @@ void compat_irq_chip_set_default_handler
 int __irq_set_trigger(struct irq_desc *desc, unsigned int irq,
 		      unsigned long flags)
 {
-	int ret;
 	struct irq_chip *chip = desc->irq_data.chip;
+	int ret, unmask = 0;
 
 	if (!chip || !chip->irq_set_type) {
 		/*
@@ -574,6 +574,14 @@ int __irq_set_trigger(struct irq_desc *d
 	}
 
 	flags &= IRQ_TYPE_SENSE_MASK;
+
+	if (chip->flags & IRQCHIP_SET_TYPE_MASKED) {
+		if (!(desc->istate & IRQS_MASKED))
+			mask_irq(desc);
+		if (!(desc->istate & IRQS_DISABLED))
+			unmask = 1;
+	}
+
 	/* caller masked out all except trigger mode flags */
 	ret = chip->irq_set_type(&desc->irq_data, flags);
 
@@ -599,6 +607,8 @@ int __irq_set_trigger(struct irq_desc *d
 		pr_err("setting trigger mode %lu for irq %u failed (%pF)\n",
 		       flags, irq, chip->irq_set_type);
 	}
+	if (unmask)
+		unmask_irq(desc);
 	return ret;
 }
 
@@ -675,7 +685,7 @@ again:
 
 #ifdef CONFIG_SMP
 /*
- * Check whether we need to change the affinity of the interrupt thread.
+ * Check whether we need to chasnge the affinity of the interrupt thread.
  */
 static void
 irq_thread_check_affinity(struct irq_desc *desc, struct irqaction *action)


