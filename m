Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757466Ab1BJXg5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 18:36:57 -0500
Received: from www.tglx.de ([62.245.132.106]:44076 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757429Ab1BJXgw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 18:36:52 -0500
Message-Id: <20110210223256.439669983@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 10 Feb 2011 23:36:40 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [patch 22/75] genirq: Implement handle_irq_event()
References: <20110210222908.661199947@linutronix.de>
Content-Disposition: inline; filename=genirq-implement-handle_irq_event.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Core code replacement for the ugly camel case. It contains all the
code which is shared in all handlers.

     clear status flags
     set INPROGRESS flag
     unlock
     call action chain
     note_interrupt
     lock
     clr INPROGRESS flag

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/irq/handle.c    |   47 +++++++++++++++++++++++++++++++++++++++--------
 kernel/irq/internals.h |    4 ++++
 2 files changed, 43 insertions(+), 8 deletions(-)

Index: linux-2.6-tip/kernel/irq/handle.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/handle.c
+++ linux-2.6-tip/kernel/irq/handle.c
@@ -51,14 +51,7 @@ static void warn_no_thread(unsigned int 
 	       "but no thread function available.", irq, action->name);
 }
 
-/**
- * handle_IRQ_event - irq action chain handler
- * @irq:	the interrupt number
- * @action:	the interrupt action chain for this irq
- *
- * Handles the action chain of an irq event
- */
-irqreturn_t handle_IRQ_event(unsigned int irq, struct irqaction *action)
+static irqreturn_t __handle_irq_event(unsigned int irq, struct irqaction *action)
 {
 	irqreturn_t ret, retval = IRQ_NONE;
 	unsigned int status = 0;
@@ -120,3 +113,41 @@ irqreturn_t handle_IRQ_event(unsigned in
 
 	return retval;
 }
+
+irqreturn_t
+handle_irq_event_percpu(struct irq_desc *desc, struct irqaction *action)
+{
+	irqreturn_t ret = __handle_irq_event(desc->irq_data.irq, action);
+
+	if (!noirqdebug)
+		note_interrupt(desc->irq_data.irq, desc, ret);
+	return ret;
+}
+
+irqreturn_t handle_irq_event(struct irq_desc *desc)
+{
+	struct irqaction *action = desc->action;
+	irqreturn_t ret;
+
+	desc->status &= ~IRQ_PENDING;
+	desc->status |= IRQ_INPROGRESS;
+	raw_spin_unlock(&desc->lock);
+
+	ret = handle_irq_event_percpu(desc, action);
+
+	raw_spin_lock(&desc->lock);
+	desc->status &= ~IRQ_INPROGRESS;
+	return ret;
+}
+
+/**
+ * handle_IRQ_event - irq action chain handler
+ * @irq:	the interrupt number
+ * @action:	the interrupt action chain for this irq
+ *
+ * Handles the action chain of an irq event
+ */
+irqreturn_t handle_IRQ_event(unsigned int irq, struct irqaction *action)
+{
+	return __handle_irq_event(irq, action);
+}
Index: linux-2.6-tip/kernel/irq/internals.h
===================================================================
--- linux-2.6-tip.orig/kernel/irq/internals.h
+++ linux-2.6-tip/kernel/irq/internals.h
@@ -39,8 +39,12 @@ extern void irq_disable(struct irq_desc 
 
 extern void init_kstat_irqs(struct irq_desc *desc, int node, int nr);
 
+irqreturn_t handle_irq_event_percpu(struct irq_desc *desc, struct irqaction *action);
+irqreturn_t handle_irq_event(struct irq_desc *desc);
+
 /* Resending of interrupts :*/
 void check_irq_resend(struct irq_desc *desc, unsigned int irq);
+
 bool irq_wait_for_poll(struct irq_desc *desc);
 
 #ifdef CONFIG_PROC_FS


