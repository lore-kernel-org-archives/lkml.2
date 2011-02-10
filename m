Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757398Ab1BJXg2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 18:36:28 -0500
Received: from www.tglx.de ([62.245.132.106]:43951 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757380Ab1BJXgX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 18:36:23 -0500
Message-Id: <20110210223255.379696160@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 10 Feb 2011 23:36:15 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [patch 11/75] genirq: Mark polled irqs and defer the real handler
References: <20110210222908.661199947@linutronix.de>
Content-Disposition: inline; filename=genirq-mark-polled-irq.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the chip.end() function gone we might run into a situation where
a poll call runs and the real interrupt comes in, sees IRQ_INPROGRESS
and disables the line. That might be a perfect working one, which will
then be masked forever.

So mark them polled while the poll runs. When the real handler sees
IRQ_INPROGRESS it checks the poll flag and waits for the polling to
complete. Add the necessary amount of sanity checks to it to avoid
deadlocks.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/irq.h    |    1 
 kernel/irq/chip.c      |   26 +++++++++++++++++++-----
 kernel/irq/internals.h |   11 ----------
 kernel/irq/spurious.c  |   51 +++++++++++++++++++++++++++++++++++++------------
 4 files changed, 61 insertions(+), 28 deletions(-)

Index: linux-2.6-tip/include/linux/irq.h
===================================================================
--- linux-2.6-tip.orig/include/linux/irq.h
+++ linux-2.6-tip/include/linux/irq.h
@@ -71,6 +71,7 @@ typedef	void (*irq_flow_handler_t)(unsig
 #define IRQ_SUSPENDED		0x04000000	/* IRQ has gone through suspend sequence */
 #define IRQ_ONESHOT		0x08000000	/* IRQ is not unmasked after hardirq */
 #define IRQ_NESTED_THREAD	0x10000000	/* IRQ is nested into another, no own handler thread */
+#define IRQ_POLL_INPROGRESS	0x20000000	/* IRQ poll is in progress */
 
 #define IRQF_MODIFY_MASK	\
 	(IRQ_TYPE_SENSE_MASK | IRQ_NOPROBE | IRQ_NOREQUEST | \
Index: linux-2.6-tip/kernel/irq/chip.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/chip.c
+++ linux-2.6-tip/kernel/irq/chip.c
@@ -446,6 +446,13 @@ out_unlock:
 }
 EXPORT_SYMBOL_GPL(handle_nested_irq);
 
+static bool irq_check_poll(struct irq_desc *desc)
+{
+	if (!(desc->status & IRQ_POLL_INPROGRESS))
+		return false;
+	return irq_wait_for_poll(desc);
+}
+
 /**
  *	handle_simple_irq - Simple and software-decoded IRQs.
  *	@irq:	the interrupt number
@@ -467,7 +474,9 @@ handle_simple_irq(unsigned int irq, stru
 	raw_spin_lock(&desc->lock);
 
 	if (unlikely(desc->status & IRQ_INPROGRESS))
-		goto out_unlock;
+		if (!irq_check_poll(desc))
+			goto out_unlock;
+
 	desc->status &= ~(IRQ_REPLAY | IRQ_WAITING);
 	kstat_incr_irqs_this_cpu(irq, desc);
 
@@ -508,7 +517,9 @@ handle_level_irq(unsigned int irq, struc
 	mask_ack_irq(desc);
 
 	if (unlikely(desc->status & IRQ_INPROGRESS))
-		goto out_unlock;
+		if (!irq_check_poll(desc))
+			goto out_unlock;
+
 	desc->status &= ~(IRQ_REPLAY | IRQ_WAITING);
 	kstat_incr_irqs_this_cpu(irq, desc);
 
@@ -556,7 +567,8 @@ handle_fasteoi_irq(unsigned int irq, str
 	raw_spin_lock(&desc->lock);
 
 	if (unlikely(desc->status & IRQ_INPROGRESS))
-		goto out;
+		if (!irq_check_poll(desc))
+			goto out;
 
 	desc->status &= ~(IRQ_REPLAY | IRQ_WAITING);
 	kstat_incr_irqs_this_cpu(irq, desc);
@@ -618,9 +630,11 @@ handle_edge_irq(unsigned int irq, struct
 	 */
 	if (unlikely((desc->status & (IRQ_INPROGRESS | IRQ_DISABLED)) ||
 		    !desc->action)) {
-		desc->status |= (IRQ_PENDING | IRQ_MASKED);
-		mask_ack_irq(desc);
-		goto out_unlock;
+		if (!irq_check_poll(desc)) {
+			desc->status |= (IRQ_PENDING | IRQ_MASKED);
+			mask_ack_irq(desc);
+			goto out_unlock;
+		}
 	}
 	kstat_incr_irqs_this_cpu(irq, desc);
 
Index: linux-2.6-tip/kernel/irq/internals.h
===================================================================
--- linux-2.6-tip.orig/kernel/irq/internals.h
+++ linux-2.6-tip/kernel/irq/internals.h
@@ -22,6 +22,7 @@ extern void init_kstat_irqs(struct irq_d
 
 /* Resending of interrupts :*/
 void check_irq_resend(struct irq_desc *desc, unsigned int irq);
+bool irq_wait_for_poll(struct irq_desc *desc);
 
 #ifdef CONFIG_PROC_FS
 extern void register_irq_proc(unsigned int irq, struct irq_desc *desc);
@@ -41,16 +42,6 @@ extern int irq_select_affinity_usr(unsig
 
 extern void irq_set_thread_affinity(struct irq_desc *desc);
 
-#ifndef CONFIG_GENERIC_HARDIRQS_NO_DEPRECATED
-static inline void irq_end(unsigned int irq, struct irq_desc *desc)
-{
-	if (desc->irq_data.chip && desc->irq_data.chip->end)
-		desc->irq_data.chip->end(irq);
-}
-#else
-static inline void irq_end(unsigned int irq, struct irq_desc *desc) { }
-#endif
-
 /* Inline functions for support of irq chips on slow busses */
 static inline void chip_bus_lock(struct irq_desc *desc)
 {
Index: linux-2.6-tip/kernel/irq/spurious.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/spurious.c
+++ linux-2.6-tip/kernel/irq/spurious.c
@@ -25,12 +25,44 @@ static int irq_poll_cpu;
 static atomic_t irq_poll_active;
 
 /*
+ * We wait here for a poller to finish.
+ *
+ * If the poll runs on this CPU, then we yell loudly and return
+ * false. That will leave the interrupt line disabled in the worst
+ * case, but it should never happen.
+ *
+ * We wait until the poller is done and then recheck disabled and
+ * action (about to be disabled). Only if it's still active, we return
+ * true and let the handler run.
+ */
+bool irq_wait_for_poll(struct irq_desc *desc)
+{
+	if (WARN_ONCE(irq_poll_cpu == smp_processor_id(),
+		      "irq poll in progress on cpu %d for irq %d\n",
+		      smp_processor_id(), desc->irq_data.irq))
+		return false;
+
+#ifdef CONFIG_SMP
+	do {
+		raw_spin_unlock(&desc->lock);
+		while (desc->status & IRQ_INPROGRESS)
+			cpu_relax();
+		raw_spin_lock(&desc->lock);
+	} while (desc->status & IRQ_INPROGRESS);
+	/* Might have been disabled in meantime */
+	return !(desc->status & IRQ_DISABLED) && desc->action;
+#else
+	return false;
+#endif
+}
+
+/*
  * Recovery handler for misrouted interrupts.
  */
 static int try_one_irq(int irq, struct irq_desc *desc, bool force)
 {
 	struct irqaction *action;
-	int ok = 0, work = 0;
+	int ok = 0;
 
 	raw_spin_lock(&desc->lock);
 
@@ -64,10 +96,9 @@ static int try_one_irq(int irq, struct i
 		goto out;
 	}
 
-	/* Honour the normal IRQ locking */
-	desc->status |= IRQ_INPROGRESS;
+	/* Honour the normal IRQ locking and mark it poll in progress */
+	desc->status |= IRQ_INPROGRESS | IRQ_POLL_INPROGRESS;
 	do {
-		work++;
 		desc->status &= ~IRQ_PENDING;
 		raw_spin_unlock(&desc->lock);
 		if (handle_IRQ_event(irq, action) != IRQ_NONE)
@@ -76,14 +107,7 @@ static int try_one_irq(int irq, struct i
 		action = desc->action;
 	}  while ((desc->status & IRQ_PENDING) && action);
 
-	desc->status &= ~IRQ_INPROGRESS;
-	/*
-	 * If we did actual work for the real IRQ line we must let the
-	 * IRQ controller clean up too
-	 */
-	if (work > 1)
-		irq_end(irq, desc);
-
+	desc->status &= ~(IRQ_INPROGRESS | IRQ_POLL_INPROGRESS);
 out:
 	raw_spin_unlock(&desc->lock);
 	return ok;
@@ -238,6 +262,9 @@ try_misrouted_irq(unsigned int irq, stru
 void note_interrupt(unsigned int irq, struct irq_desc *desc,
 		    irqreturn_t action_ret)
 {
+	if (desc->status & IRQ_POLL_INPROGRESS)
+		return;
+
 	if (unlikely(action_ret != IRQ_HANDLED)) {
 		/*
 		 * If we are seeing only the odd spurious IRQ caused by


