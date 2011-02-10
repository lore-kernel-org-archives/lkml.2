Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932435Ab1BJXio (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 18:38:44 -0500
Received: from www.tglx.de ([62.245.132.106]:44561 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932392Ab1BJXik (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 18:38:40 -0500
Message-Id: <20110210223300.859647066@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 10 Feb 2011 23:38:30 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [patch 68/75] genirq: Add preflow handler support
References: <20110210222908.661199947@linutronix.de>
Content-Disposition: inline; filename=genirq-add-preflow-handler-support.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sparc64 needs to call a preflow handler on certain interrupts befor
calling the action chain. Integrate it into handle_fasteoi_irq. Must
be enabled via CONFIG_IRQ_FASTEOI_PREFLOW. No impact when disabled.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: David S. Miller <davem@davemloft.net>
---
 include/linux/irq.h     |    3 ++-
 include/linux/irqdesc.h |   14 ++++++++++++++
 kernel/irq/Kconfig      |    3 +++
 kernel/irq/chip.c       |   11 +++++++++++
 4 files changed, 30 insertions(+), 1 deletion(-)

Index: linux-2.6-tip/include/linux/irq.h
===================================================================
--- linux-2.6-tip.orig/include/linux/irq.h
+++ linux-2.6-tip/include/linux/irq.h
@@ -29,9 +29,10 @@
 #include <asm/irq_regs.h>
 
 struct irq_desc;
+struct irq_data;
 typedef	void (*irq_flow_handler_t)(unsigned int irq,
 					    struct irq_desc *desc);
-
+typedef	void (*irq_preflow_handler_t)(struct irq_data *data);
 
 /*
  * IRQ line status.
Index: linux-2.6-tip/include/linux/irqdesc.h
===================================================================
--- linux-2.6-tip.orig/include/linux/irqdesc.h
+++ linux-2.6-tip/include/linux/irqdesc.h
@@ -63,6 +63,9 @@ struct irq_desc {
 	struct timer_rand_state *timer_rand_state;
 	unsigned int __percpu	*kstat_irqs;
 	irq_flow_handler_t	handle_irq;
+#ifdef CONFIG_IRQ_PREFLOW_FASTEOI
+	irq_preflow_handler_t	preflow_handler;
+#endif
 	struct irqaction	*action;	/* IRQ action list */
 #ifdef CONFIG_GENERIC_HARDIRQS_NO_COMPAT
 	unsigned int		settings_use_the_proper_accessors;
@@ -187,6 +190,17 @@ static inline void __set_irq_handler_unl
 	desc = irq_to_desc(irq);
 	desc->handle_irq = handler;
 }
+
+#ifdef CONFIG_IRQ_PREFLOW_FASTEOI
+static inline void
+__irq_set_preflow_handler(unsigned int irq, irq_preflow_handler_t handler)
+{
+	struct irq_desc *desc;
+
+	desc = irq_to_desc(irq);
+	desc->preflow_handler = handler;
+}
+#endif
 #endif
 
 #endif
Index: linux-2.6-tip/kernel/irq/Kconfig
===================================================================
--- linux-2.6-tip.orig/kernel/irq/Kconfig
+++ linux-2.6-tip/kernel/irq/Kconfig
@@ -35,6 +35,9 @@ config AUTO_IRQ_AFFINITY
 config HARDIRQS_SW_RESEND
        def_bool n
 
+config IRQ_PREFLOW_FASTEOI
+       def_bool n
+
 config SPARSE_IRQ
 	bool "Support sparse irq numbering"
 	depends on HAVE_SPARSE_IRQ
Index: linux-2.6-tip/kernel/irq/chip.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/chip.c
+++ linux-2.6-tip/kernel/irq/chip.c
@@ -531,6 +531,16 @@ out_unlock:
 }
 EXPORT_SYMBOL_GPL(handle_level_irq);
 
+#ifdef CONFIG_IRQ_PREFLOW_FASTEOI
+static inline void preflow_handler(struct irq_desc *desc)
+{
+	if (desc->preflow_handler)
+		desc->preflow_handler(&desc->irq_data);
+}
+#else
+static inline void preflow_handler(struct irq_desc *desc) { }
+#endif
+
 /**
  *	handle_fasteoi_irq - irq handler for transparent controllers
  *	@irq:	the interrupt number
@@ -563,6 +573,7 @@ handle_fasteoi_irq(unsigned int irq, str
 		mask_irq(desc);
 		goto out;
 	}
+	preflow_handler(desc);
 	handle_irq_event(desc);
 out:
 	desc->irq_data.chip->irq_eoi(&desc->irq_data);


