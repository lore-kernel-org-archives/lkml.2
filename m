Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757479Ab1BJXoE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 18:44:04 -0500
Received: from www.tglx.de ([62.245.132.106]:44359 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757578Ab1BJXhz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 18:37:55 -0500
Message-Id: <20110210223258.267712837@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 10 Feb 2011 23:37:25 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [patch 41/75] genirq: Move IRQ_ONESHOT to core
References: <20110210222908.661199947@linutronix.de>
Content-Disposition: inline; filename=genirq-move-oneshot.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No users outside of core.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/irq.h    |    1 -
 kernel/irq/chip.c      |    2 +-
 kernel/irq/internals.h |    2 ++
 kernel/irq/manage.c    |    8 ++++----
 4 files changed, 7 insertions(+), 6 deletions(-)

Index: linux-2.6-tip/include/linux/irq.h
===================================================================
--- linux-2.6-tip.orig/include/linux/irq.h
+++ linux-2.6-tip/include/linux/irq.h
@@ -71,7 +71,6 @@ typedef	void (*irq_flow_handler_t)(unsig
 #define IRQ_MOVE_PCNTXT		0x01000000	/* IRQ migration from process context */
 #define IRQ_AFFINITY_SET	0x02000000	/* IRQ affinity was set from userspace*/
 #define IRQ_SUSPENDED		0x04000000	/* IRQ has gone through suspend sequence */
-#define IRQ_ONESHOT		0x08000000	/* IRQ is not unmasked after hardirq */
 
 #define IRQF_MODIFY_MASK	\
 	(IRQ_TYPE_SENSE_MASK | IRQ_NOPROBE | IRQ_NOREQUEST | \
Index: linux-2.6-tip/kernel/irq/chip.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/chip.c
+++ linux-2.6-tip/kernel/irq/chip.c
@@ -498,7 +498,7 @@ handle_level_irq(unsigned int irq, struc
 
 	handle_irq_event(desc);
 
-	if (!(desc->status & (IRQ_DISABLED | IRQ_ONESHOT)))
+	if (!(desc->status & IRQ_DISABLED) && !(desc->istate & IRQS_ONESHOT))
 		unmask_irq(desc);
 out_unlock:
 	raw_spin_unlock(&desc->lock);
Index: linux-2.6-tip/kernel/irq/internals.h
===================================================================
--- linux-2.6-tip.orig/kernel/irq/internals.h
+++ linux-2.6-tip/kernel/irq/internals.h
@@ -38,6 +38,7 @@ enum {
  *				  no own irq thread.
  * IRQS_POLL_INPROGRESS		- polling in progress
  * IRQS_INPROGRESS		- Interrupt in progress
+ * IRQS_ONESHOT			- irq is not unmasked in primary handler
  */
 enum {
 	IRQS_AUTODETECT		= 0x00000001,
@@ -45,6 +46,7 @@ enum {
 	IRQS_NESTED_THREAD	= 0x00000004,
 	IRQS_POLL_INPROGRESS	= 0x00000008,
 	IRQS_INPROGRESS		= 0x00000010,
+	IRQS_ONESHOT		= 0x00000020,
 };
 
 #define irq_data_to_desc(data)	container_of(data, struct irq_desc, irq_data)
Index: linux-2.6-tip/kernel/irq/manage.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/manage.c
+++ linux-2.6-tip/kernel/irq/manage.c
@@ -703,7 +703,7 @@ static int irq_thread(void *data)
 	};
 	struct irqaction *action = data;
 	struct irq_desc *desc = irq_to_desc(action->irq);
-	int wake, oneshot = desc->status & IRQ_ONESHOT;
+	int wake, oneshot = desc->istate & IRQS_ONESHOT;
 
 	sched_setscheduler(current, SCHED_FIFO, &param);
 	current->irqaction = action;
@@ -903,12 +903,12 @@ __setup_irq(unsigned int irq, struct irq
 			desc->status |= IRQ_PER_CPU;
 #endif
 
-		desc->status &= ~(IRQ_WAITING | IRQ_ONESHOT);
+		desc->status &= ~IRQ_WAITING;
 		desc->istate &= ~(IRQS_AUTODETECT | IRQS_SPURIOUS_DISABLED | \
-				  IRQS_INPROGRESS);
+				  IRQS_INPROGRESS | IRQS_ONESHOT);
 
 		if (new->flags & IRQF_ONESHOT)
-			desc->status |= IRQ_ONESHOT;
+			desc->istate |= IRQS_ONESHOT;
 
 		if (!(desc->status & IRQ_NOAUTOEN))
 			irq_startup(desc);


