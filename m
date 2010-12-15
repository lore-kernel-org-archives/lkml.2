Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753562Ab0LOXNA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 18:13:00 -0500
Received: from www.tglx.de ([62.245.132.106]:59009 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752261Ab0LOXM5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 18:12:57 -0500
Message-Id: <20101215230531.344900495@linutronix.de>
User-Agent: quilt/0.48-1
Date: Wed, 15 Dec 2010 23:12:41 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Tom Lyon <pugs@cisco.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Jan Kiszka <jan.kiszka@web.de>
Subject: [RFC patch 3/4] genirq: Add notification mechanism for adaptive
	shared irqs
References: <20101215230352.411894017@linutronix.de>
Content-Disposition: inline;
	filename=genirq-add-adaptive-shared-notification.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The final goal of these modifications is to allow an adaptive oneshot
mode for possibly shared interrupts. If the interrupt is not shared
then oneshot mode should be used as it is more efficient than
masking/unmasking at the device level. When the interrupt becomes
shared then the oneshot mode needs to be disabled and device level
masking must be done.

That requires transitioning from one state to the other which needs
the help of the interrupt handler of the device which asked for this
feature.

First of all the interrupt handler needs to know whether it needs to
mask at the device level or if it can avoid that and rely on the line
level masking. To avoid a lookup of irq_data/desc in every interrupt
we use the lower 2 bits of the device id pointer to encode the shared
state and a transitional state. This reduces the runtime overhead to
almost zero. The encoding of the lower two bits of dev_id depends on
IRQF_ADAPTIVE_SHARED set, so there is no conflict with existing
drivers. Driver which use the IRQF_ADAPTIVE_SHARED flag need to decode
dev_id to gain this functionality.

The two bits which are encoded are:
    IRQ_DEV_ID_SHARED and IRQ_DEV_ID_PREPARE_SHARED

IRQ_DEV_ID_SHARED indicates that the irq line is shared.

IRQ_DEV_ID_PREPARE_SHARED indicates the transition from unshared to
shared. Handler must mask at the device level, when an interrupt is on
the fly. This requires local state tracking in the device handler.

The transition from shared to non shared requires just the correct
order of removing the IRQ_DEV_ID_SHARED bit from the dev_id
vs. removing the last shared action handler from the action chain. In
the worst case (if an interrupt is on the fly) the device mask is kept
until the on the fly interrupt is finished. After that the line based
masking takes place.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Tom Lyon <pugs@cisco.com>
Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Jan Kiszka <jan.kiszka@web.de>
---
 include/linux/interrupt.h |   34 +++++++++++++++++++++++
 kernel/irq/manage.c       |   66 +++++++++++++++++++++++++++++++++++++++++-----
 2 files changed, 94 insertions(+), 6 deletions(-)

Index: linux-2.6-tip/include/linux/interrupt.h
===================================================================
--- linux-2.6-tip.orig/include/linux/interrupt.h
+++ linux-2.6-tip/include/linux/interrupt.h
@@ -55,6 +55,8 @@
  *                Used by threaded interrupts which need to keep the
  *                irq line disabled until the threaded handler has been run.
  * IRQF_NO_SUSPEND - Do not disable this IRQ during suspend
+ * IRQF_ADAPTIVE_SHARED - Request notification about interrupt line
+ *                        sharing in the dev_id argument
  *
  */
 #define IRQF_DISABLED		0x00000020
@@ -67,6 +69,7 @@
 #define IRQF_IRQPOLL		0x00001000
 #define IRQF_ONESHOT		0x00002000
 #define IRQF_NO_SUSPEND		0x00004000
+#define IRQF_ADAPTIVE_SHARED	0x00008000
 
 #define IRQF_TIMER		(__IRQF_TIMER | IRQF_NO_SUSPEND)
 
@@ -126,6 +129,37 @@ struct irqaction {
 
 extern irqreturn_t no_action(int cpl, void *dev_id);
 
+/*
+ * Macros and functions for interrupt handlers which need to know
+ * about the sharing status of the interrupt line
+ * (IRQF_SHARED_ADAPTIVE)
+ */
+#define IRQ_DEV_ID_SHARED		0x01UL
+#define IRQ_DEV_ID_PREPARE_SHARED	0x02UL
+#define IRQ_DEV_ID_MASK			0x03UL
+
+static inline void *irq_real_dev_id(void *dev_id)
+{
+	unsigned long id = ((unsigned long) dev_id) & ~IRQ_DEV_ID_MASK;
+	return (void *)id;
+}
+
+static inline void *irq_modify_dev_id(void *dev_id, unsigned long mask)
+{
+	unsigned long id = ((unsigned long) dev_id) | mask;
+	return (void *)id;
+}
+
+static inline bool irq_dev_id_is_shared(void *dev_id)
+{
+	return ((unsigned long) dev_id) & IRQ_DEV_ID_SHARED;
+}
+
+static inline bool irq_dev_id_prepare_shared(void *dev_id)
+{
+	return ((unsigned long) dev_id) & IRQ_DEV_ID_PREPARE_SHARED;
+}
+
 #ifdef CONFIG_GENERIC_HARDIRQS
 extern int __must_check
 request_threaded_irq(unsigned int irq, irq_handler_t handler,
Index: linux-2.6-tip/kernel/irq/manage.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/manage.c
+++ linux-2.6-tip/kernel/irq/manage.c
@@ -650,6 +650,37 @@ void exit_irq_thread(void)
 }
 
 /*
+ * Adaptive shared interrupts might need to mask the device when an
+ * interrupt is on the fly already.
+ *
+ * We only do that for the first action when a shared handler comes
+ * in, as new actions have the shared bit set already before they are
+ * added to the action chain.
+ */
+static void irq_notify_shared(unsigned int irq, struct irqaction *action)
+{
+	unsigned long flags;
+
+	if (!(action->flags & IRQF_ADAPTIVE_SHARED) ||
+	    irq_dev_id_is_shared(action->dev_id))
+		return;
+
+	disable_irq(irq);
+	action->dev_id = irq_modify_dev_id(action->dev_id, IRQ_DEV_ID_SHARED);
+	local_irq_save(flags);
+	action->handler(irq, irq_modify_dev_id(action->dev_id,
+					       IRQ_DEV_ID_PREPARE_SHARED));
+	local_irq_restore(flags);
+
+	/*
+	 * This also unmasks an eventually masked irq line. The
+	 * handler has masked the device if an interrupt was on the
+	 * fly.
+	 */
+	enable_irq(irq);
+}
+
+/*
  * Internal function to register an irqaction - typically used to
  * allocate special interrupts that are part of the architecture.
  */
@@ -803,15 +834,20 @@ __setup_irq(unsigned int irq, struct irq
 		setup_affinity(irq, desc);
 
 	} else {
+		/* Take care of adaptive shared interrupts */
+		irq_notify_shared(irq, desc->action);
+		if (new->flags & IRQF_ADAPTIVE_SHARED)
+			new->dev_id = irq_modify_dev_id(new->dev_id,
+							IRQ_DEV_ID_SHARED);
 		raw_spin_lock_irqsave(&desc->lock, flags);
 
 		if ((new->flags & IRQF_TRIGGER_MASK)
 		    && (new->flags & IRQF_TRIGGER_MASK)
 		    != (desc->status & IRQ_TYPE_SENSE_MASK)) {
-		/* hope the handler works with the actual trigger mode... */
-		pr_warning("IRQ %d uses trigger mode %d; requested %d\n",
-				irq, (int)(desc->status & IRQ_TYPE_SENSE_MASK),
-				(int)(new->flags & IRQF_TRIGGER_MASK));
+			/* hope the handler works with the actual trigger mode */
+			pr_warning("IRQ %d uses trigger mode %u; requested %lu\n",
+				   irq, desc->status & IRQ_TYPE_SENSE_MASK,
+				   new->flags & IRQF_TRIGGER_MASK);
 		}
 	}
 
@@ -910,6 +946,8 @@ static struct irqaction *__free_irq(unsi
 	 */
 	action_ptr = &desc->action;
 	for (;;) {
+		void *id;
+
 		action = *action_ptr;
 
 		if (!action) {
@@ -917,7 +955,12 @@ static struct irqaction *__free_irq(unsi
 			return NULL;
 		}
 
-		if (action->dev_id == dev_id)
+		if (action->flags & IRQF_ADAPTIVE_SHARED)
+			id = irq_real_dev_id(action->dev_id);
+		else
+			id = action->dev_id;
+
+		if (id == dev_id)
 			break;
 		action_ptr = &action->next;
 	}
@@ -955,6 +998,17 @@ static struct irqaction *__free_irq(unsi
 	/* Make sure it's not being used on another CPU: */
 	synchronize_irq(irq);
 
+	/*
+	 * Remove the shared flag on adaptive shared handlers if this
+	 * is the last action remaining for this line. This is safe
+	 * outside of desc->lock as the action chain is still
+	 * protected by register_lock.
+	 */
+	if (desc->action && !desc->action->next) {
+		if (desc->action->flags & IRQF_ADAPTIVE_SHARED)
+			desc->action->dev_id = irq_real_dev_id(action->dev_id);
+	}
+
 #ifdef CONFIG_DEBUG_SHIRQ
 	/*
 	 * It's a shared IRQ -- the driver ought to be prepared for an IRQ
@@ -966,7 +1020,7 @@ static struct irqaction *__free_irq(unsi
 	 */
 	if (action->flags & IRQF_SHARED) {
 		local_irq_save(flags);
-		action->handler(irq, dev_id);
+		action->handler(irq, action->dev_id);
 		local_irq_restore(flags);
 	}
 #endif


