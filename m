Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755756Ab0LOXNR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 18:13:17 -0500
Received: from www.tglx.de ([62.245.132.106]:59035 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755716Ab0LOXNL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 18:13:11 -0500
Message-Id: <20101215230531.448656325@linutronix.de>
User-Agent: quilt/0.48-1
Date: Wed, 15 Dec 2010 23:12:44 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Tom Lyon <pugs@cisco.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Jan Kiszka <jan.kiszka@web.de>
Subject: [RFC patch 4/4] genirq: Add support for IRQF_COND_ONESHOT
References: <20101215230352.411894017@linutronix.de>
Content-Disposition: inline;
	filename=genirq-add-support-for-irqf_cond_oneshot.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kiszka <jan.kiszka@siemens.com>

Provide an adaptive version of IRQF_ONESHOT: If the line is exclusively used,
IRQF_COND_ONESHOT provides the same semantics as IRQF_ONESHOT. If it is
shared, the line will be unmasked directly after the hardirq handler, just as
if IRQF_COND_ONESHOT was not provided.

[ tglx: adapted to the dev_id based notification mechanism ]

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Tom Lyon <pugs@cisco.com>
Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/interrupt.h |    3 +++
 kernel/irq/manage.c       |   25 +++++++++++++++++--------
 2 files changed, 20 insertions(+), 8 deletions(-)

Index: linux-2.6-tip/include/linux/interrupt.h
===================================================================
--- linux-2.6-tip.orig/include/linux/interrupt.h
+++ linux-2.6-tip/include/linux/interrupt.h
@@ -57,6 +57,8 @@
  * IRQF_NO_SUSPEND - Do not disable this IRQ during suspend
  * IRQF_ADAPTIVE_SHARED - Request notification about interrupt line
  *                        sharing in the dev_id argument
+ * IRQF_COND_ONESHOT - If line is not shared, keep interrupt disabled after
+ *                     hardirq handler finshed.
  *
  */
 #define IRQF_DISABLED		0x00000020
@@ -70,6 +72,7 @@
 #define IRQF_ONESHOT		0x00002000
 #define IRQF_NO_SUSPEND		0x00004000
 #define IRQF_ADAPTIVE_SHARED	0x00008000
+#define IRQF_COND_ONESHOT	0x00010000
 
 #define IRQF_TIMER		(__IRQF_TIMER | IRQF_NO_SUSPEND)
 
Index: linux-2.6-tip/kernel/irq/manage.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/manage.c
+++ linux-2.6-tip/kernel/irq/manage.c
@@ -583,7 +583,7 @@ static int irq_thread(void *data)
 	struct sched_param param = { .sched_priority = MAX_USER_RT_PRIO/2, };
 	struct irqaction *action = data;
 	struct irq_desc *desc = irq_to_desc(action->irq);
-	int wake, oneshot = desc->status & IRQ_ONESHOT;
+	int wake, oneshot;
 
 	sched_setscheduler(current, SCHED_FIFO, &param);
 	current->irqaction = action;
@@ -606,6 +606,7 @@ static int irq_thread(void *data)
 			desc->status |= IRQ_PENDING;
 			raw_spin_unlock_irq(&desc->lock);
 		} else {
+			oneshot = desc->status & IRQ_ONESHOT;
 			raw_spin_unlock_irq(&desc->lock);
 
 			action->thread_fn(action->irq, action->dev_id);
@@ -657,8 +658,9 @@ void exit_irq_thread(void)
  * in, as new actions have the shared bit set already before they are
  * added to the action chain.
  */
-static void irq_notify_shared(unsigned int irq, struct irqaction *action)
+static void irq_notify_shared(unsigned int irq, struct irq_desc *desc)
 {
+	struct irqaction *action = desc->action;
 	unsigned long flags;
 
 	if (!(action->flags & IRQF_ADAPTIVE_SHARED) ||
@@ -667,15 +669,19 @@ static void irq_notify_shared(unsigned i
 
 	disable_irq(irq);
 	action->dev_id = irq_modify_dev_id(action->dev_id, IRQ_DEV_ID_SHARED);
+
 	local_irq_save(flags);
 	action->handler(irq, irq_modify_dev_id(action->dev_id,
 					       IRQ_DEV_ID_PREPARE_SHARED));
-	local_irq_restore(flags);
+
+	/* Clear the oneshot flag */
+	raw_spin_lock(&desc->lock);
+	desc->status &= ~IRQ_ONESHOT;
+	raw_spin_unlock_irqrestore(&desc->lock, flags);
 
 	/*
-	 * This also unmasks an eventually masked irq line. The
-	 * handler has masked the device if an interrupt was on the
-	 * fly.
+	 * Reenable the interrupt if desc->depth == 1. This is safe
+	 * now as the handler has masked at the device level.
 	 */
 	enable_irq(irq);
 }
@@ -815,7 +821,7 @@ __setup_irq(unsigned int irq, struct irq
 		desc->status &= ~(IRQ_AUTODETECT | IRQ_WAITING | IRQ_ONESHOT |
 				  IRQ_INPROGRESS | IRQ_SPURIOUS_DISABLED);
 
-		if (new->flags & IRQF_ONESHOT)
+		if (new->flags & (IRQF_ONESHOT | IRQF_COND_ONESHOT))
 			desc->status |= IRQ_ONESHOT;
 
 		if (!(desc->status & IRQ_NOAUTOEN)) {
@@ -835,7 +841,7 @@ __setup_irq(unsigned int irq, struct irq
 
 	} else {
 		/* Take care of adaptive shared interrupts */
-		irq_notify_shared(irq, desc->action);
+		irq_notify_shared(irq, desc);
 		if (new->flags & IRQF_ADAPTIVE_SHARED)
 			new->dev_id = irq_modify_dev_id(new->dev_id,
 							IRQ_DEV_ID_SHARED);
@@ -983,6 +989,9 @@ static struct irqaction *__free_irq(unsi
 			desc->irq_data.chip->irq_shutdown(&desc->irq_data);
 		else
 			desc->irq_data.chip->irq_disable(&desc->irq_data);
+	} else if (!desc->action->next) {
+		if (desc->action->flags & IRQF_COND_ONESHOT)
+			desc->status |= IRQ_ONESHOT;
 	}
 
 #ifdef CONFIG_SMP


