Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757630Ab1BJXq4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 18:46:56 -0500
Received: from www.tglx.de ([62.245.132.106]:44239 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757550Ab1BJXh3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 18:37:29 -0500
Message-Id: <20110210223257.981137096@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 10 Feb 2011 23:37:17 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [patch 38/75] genirq: Move IRQ_NESTED_THREAD to core state
References: <20110210222908.661199947@linutronix.de>
Content-Disposition: inline; filename=genirq-move-nested-thread.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No users outside of core.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/irq.h    |    1 -
 kernel/irq/chip.c      |   10 +++++-----
 kernel/irq/internals.h |    3 +++
 kernel/irq/manage.c    |    4 ++--
 kernel/irq/spurious.c  |    2 +-
 5 files changed, 11 insertions(+), 9 deletions(-)

Index: linux-2.6-tip/include/linux/irq.h
===================================================================
--- linux-2.6-tip.orig/include/linux/irq.h
+++ linux-2.6-tip/include/linux/irq.h
@@ -68,7 +68,6 @@ typedef	void (*irq_flow_handler_t)(unsig
 #define IRQ_AFFINITY_SET	0x02000000	/* IRQ affinity was set from userspace*/
 #define IRQ_SUSPENDED		0x04000000	/* IRQ has gone through suspend sequence */
 #define IRQ_ONESHOT		0x08000000	/* IRQ is not unmasked after hardirq */
-#define IRQ_NESTED_THREAD	0x10000000	/* IRQ is nested into another, no own handler thread */
 #define IRQ_POLL_INPROGRESS	0x20000000	/* IRQ poll is in progress */
 
 #define IRQF_MODIFY_MASK	\
Index: linux-2.6-tip/kernel/irq/chip.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/chip.c
+++ linux-2.6-tip/kernel/irq/chip.c
@@ -163,12 +163,12 @@ struct irq_data *irq_get_irq_data(unsign
 EXPORT_SYMBOL_GPL(irq_get_irq_data);
 
 /**
- *	set_irq_nested_thread - Set/Reset the IRQ_NESTED_THREAD flag of an irq
+ *	set_irq_nested_thread - Set/Reset the IRQS_NESTED_THREAD flag of an irq
  *
  *	@irq:	Interrupt number
- *	@nest:	0 to clear / 1 to set the IRQ_NESTED_THREAD flag
+ *	@nest:	0 to clear / 1 to set the IRQS_NESTED_THREAD flag
  *
- *	The IRQ_NESTED_THREAD flag indicates that on
+ *	The IRQS_NESTED_THREAD flag indicates that on
  *	request_threaded_irq() no separate interrupt thread should be
  *	created for the irq as the handler are called nested in the
  *	context of a demultiplexing interrupt handler thread.
@@ -183,9 +183,9 @@ void set_irq_nested_thread(unsigned int 
 
 	raw_spin_lock_irqsave(&desc->lock, flags);
 	if (nest)
-		desc->status |= IRQ_NESTED_THREAD;
+		desc->istate |= IRQS_NESTED_THREAD;
 	else
-		desc->status &= ~IRQ_NESTED_THREAD;
+		desc->istate &= ~IRQS_NESTED_THREAD;
 	raw_spin_unlock_irqrestore(&desc->lock, flags);
 }
 EXPORT_SYMBOL_GPL(set_irq_nested_thread);
Index: linux-2.6-tip/kernel/irq/internals.h
===================================================================
--- linux-2.6-tip.orig/kernel/irq/internals.h
+++ linux-2.6-tip/kernel/irq/internals.h
@@ -33,10 +33,13 @@ enum {
  * IRQS_AUTODETECT		- autodetection in progress
  * IRQS_SPURIOUS_DISABLED	- was disabled due to spurious interrupt
  *				  detection
+ * IRQS_NESTED_THREAD		- nested into another threaded handler
+ *				  no own irq thread.
  */
 enum {
 	IRQS_AUTODETECT		= 0x00000001,
 	IRQS_SPURIOUS_DISABLED	= 0x00000002,
+	IRQS_NESTED_THREAD	= 0x00000004,
 };
 
 #define irq_data_to_desc(data)	container_of(data, struct irq_desc, irq_data)
Index: linux-2.6-tip/kernel/irq/manage.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/manage.c
+++ linux-2.6-tip/kernel/irq/manage.c
@@ -812,7 +812,7 @@ __setup_irq(unsigned int irq, struct irq
 	 * Check whether the interrupt nests into another interrupt
 	 * thread.
 	 */
-	nested = desc->status & IRQ_NESTED_THREAD;
+	nested = desc->istate & IRQS_NESTED_THREAD;
 	if (nested) {
 		if (!new->thread_fn)
 			return -EINVAL;
@@ -1276,7 +1276,7 @@ int request_any_context_irq(unsigned int
 	if (!desc)
 		return -EINVAL;
 
-	if (desc->status & IRQ_NESTED_THREAD) {
+	if (desc->istate & IRQS_NESTED_THREAD) {
 		ret = request_threaded_irq(irq, NULL, handler,
 					   flags, name, dev_id);
 		return !ret ? IRQC_IS_NESTED : ret;
Index: linux-2.6-tip/kernel/irq/spurious.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/spurious.c
+++ linux-2.6-tip/kernel/irq/spurious.c
@@ -68,7 +68,7 @@ static int try_one_irq(int irq, struct i
 	raw_spin_lock(&desc->lock);
 
 	/* PER_CPU and nested thread interrupts are never polled */
-	if (desc->status & (IRQ_PER_CPU | IRQ_NESTED_THREAD))
+	if ((desc->status & IRQ_PER_CPU) || (desc->istate & IRQS_NESTED_THREAD))
 		goto out;
 
 	/*


