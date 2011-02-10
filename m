Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757617Ab1BJXqh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 18:46:37 -0500
Received: from www.tglx.de ([62.245.132.106]:44249 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932132Ab1BJXhb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 18:37:31 -0500
Message-Id: <20110210223258.075423726@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 10 Feb 2011 23:37:20 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [patch 39/75] genirq: Move IRQ_POLL_INPROGRESS to core
References: <20110210222908.661199947@linutronix.de>
Content-Disposition: inline; filename=genirq-poll-in-progress.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No users outside of core.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/irq.h    |    1 -
 kernel/irq/chip.c      |    2 +-
 kernel/irq/internals.h |    2 ++
 kernel/irq/spurious.c  |    6 +++---
 4 files changed, 6 insertions(+), 5 deletions(-)

Index: linux-2.6-tip/include/linux/irq.h
===================================================================
--- linux-2.6-tip.orig/include/linux/irq.h
+++ linux-2.6-tip/include/linux/irq.h
@@ -68,7 +68,6 @@ typedef	void (*irq_flow_handler_t)(unsig
 #define IRQ_AFFINITY_SET	0x02000000	/* IRQ affinity was set from userspace*/
 #define IRQ_SUSPENDED		0x04000000	/* IRQ has gone through suspend sequence */
 #define IRQ_ONESHOT		0x08000000	/* IRQ is not unmasked after hardirq */
-#define IRQ_POLL_INPROGRESS	0x20000000	/* IRQ poll is in progress */
 
 #define IRQF_MODIFY_MASK	\
 	(IRQ_TYPE_SENSE_MASK | IRQ_NOPROBE | IRQ_NOREQUEST | \
Index: linux-2.6-tip/kernel/irq/chip.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/chip.c
+++ linux-2.6-tip/kernel/irq/chip.c
@@ -426,7 +426,7 @@ EXPORT_SYMBOL_GPL(handle_nested_irq);
 
 static bool irq_check_poll(struct irq_desc *desc)
 {
-	if (!(desc->status & IRQ_POLL_INPROGRESS))
+	if (!(desc->istate & IRQS_POLL_INPROGRESS))
 		return false;
 	return irq_wait_for_poll(desc);
 }
Index: linux-2.6-tip/kernel/irq/internals.h
===================================================================
--- linux-2.6-tip.orig/kernel/irq/internals.h
+++ linux-2.6-tip/kernel/irq/internals.h
@@ -35,11 +35,13 @@ enum {
  *				  detection
  * IRQS_NESTED_THREAD		- nested into another threaded handler
  *				  no own irq thread.
+ * IRQS_POLL_INPROGRESS		- polling in progress
  */
 enum {
 	IRQS_AUTODETECT		= 0x00000001,
 	IRQS_SPURIOUS_DISABLED	= 0x00000002,
 	IRQS_NESTED_THREAD	= 0x00000004,
+	IRQS_POLL_INPROGRESS	= 0x00000008,
 };
 
 #define irq_data_to_desc(data)	container_of(data, struct irq_desc, irq_data)
Index: linux-2.6-tip/kernel/irq/spurious.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/spurious.c
+++ linux-2.6-tip/kernel/irq/spurious.c
@@ -98,13 +98,13 @@ static int try_one_irq(int irq, struct i
 	}
 
 	/* Mark it poll in progress */
-	desc->status |= IRQ_POLL_INPROGRESS;
+	desc->istate |= IRQS_POLL_INPROGRESS;
 	do {
 		if (handle_irq_event(desc) == IRQ_HANDLED)
 			ret = IRQ_HANDLED;
 		action = desc->action;
 	} while ((desc->status & IRQ_PENDING) && action);
-	desc->status &= ~IRQ_POLL_INPROGRESS;
+	desc->istate &= ~IRQS_POLL_INPROGRESS;
 out:
 	raw_spin_unlock(&desc->lock);
 	return ret == IRQ_HANDLED;
@@ -259,7 +259,7 @@ try_misrouted_irq(unsigned int irq, stru
 void note_interrupt(unsigned int irq, struct irq_desc *desc,
 		    irqreturn_t action_ret)
 {
-	if (desc->status & IRQ_POLL_INPROGRESS)
+	if (desc->istate & IRQS_POLL_INPROGRESS)
 		return;
 
 	if (unlikely(action_ret != IRQ_HANDLED)) {


