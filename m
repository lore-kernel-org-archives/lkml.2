Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932202Ab1BJXhi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 18:37:38 -0500
Received: from www.tglx.de ([62.245.132.106]:44251 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932153Ab1BJXhb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 18:37:31 -0500
Message-Id: <20110210223258.171002194@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 10 Feb 2011 23:37:22 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [patch 40/75] genirq: Add IRQ_INPROGRESS to core
References: <20110210222908.661199947@linutronix.de>
Content-Disposition: inline; filename=genirq-move-inprogress.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to maintain the flag for now in both fields status and istate.
Add a CONFIG_GENERIC_HARDIRQS_NO_COMPAT switch to allow testing w/o
the status one. Wrap the access to status IRQ_INPROGRESS in a inline
which can be turned of with CONFIG_GENERIC_HARDIRQS_NO_COMPAT along
with the define.

There is no reason that anything outside of core looks at this. That
needs some modifications, but we'll get there.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/irq.h    |    6 +++++-
 kernel/irq/Kconfig     |    3 +++
 kernel/irq/chip.c      |   16 +++++++++-------
 kernel/irq/compat.h    |   17 +++++++++++++++++
 kernel/irq/handle.c    |    6 ++++--
 kernel/irq/internals.h |    5 ++++-
 kernel/irq/manage.c    |   17 +++++++++--------
 kernel/irq/settings.h  |    3 +++
 kernel/irq/spurious.c  |    6 +++---
 9 files changed, 57 insertions(+), 22 deletions(-)

Index: linux-2.6-tip/include/linux/irq.h
===================================================================
--- linux-2.6-tip.orig/include/linux/irq.h
+++ linux-2.6-tip/include/linux/irq.h
@@ -50,7 +50,11 @@ typedef	void (*irq_flow_handler_t)(unsig
 #define IRQ_TYPE_PROBE		0x00000010	/* Probing in progress */
 
 /* Internal flags */
-#define IRQ_INPROGRESS		0x00000100	/* IRQ handler active - do not enter! */
+
+#ifndef CONFIG_GENERIC_HARDIRQS_NO_COMPAT
+#define IRQ_INPROGRESS		0x00000100	/* DEPRECATED */
+#endif
+
 #define IRQ_DISABLED		0x00000200	/* IRQ disabled - do not enter! */
 #define IRQ_PENDING		0x00000400	/* IRQ pending - replay on enable */
 #define IRQ_REPLAY		0x00000800	/* IRQ has been replayed but not acked yet */
Index: linux-2.6-tip/kernel/irq/Kconfig
===================================================================
--- linux-2.6-tip.orig/kernel/irq/Kconfig
+++ linux-2.6-tip/kernel/irq/Kconfig
@@ -13,6 +13,9 @@ config GENERIC_HARDIRQS
 config GENERIC_HARDIRQS_NO_DEPRECATED
        def_bool n
 
+config GENERIC_HARDIRQS_NO_COMPAT
+       def_bool n
+
 # Options selectable by the architecture code
 config HAVE_SPARSE_IRQ
        def_bool n
Index: linux-2.6-tip/kernel/irq/chip.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/chip.c
+++ linux-2.6-tip/kernel/irq/chip.c
@@ -409,7 +409,8 @@ void handle_nested_irq(unsigned int irq)
 	if (unlikely(!action || (desc->status & IRQ_DISABLED)))
 		goto out_unlock;
 
-	desc->status |= IRQ_INPROGRESS;
+	irq_compat_set_progress(desc);
+	desc->istate |= IRQS_INPROGRESS;
 	raw_spin_unlock_irq(&desc->lock);
 
 	action_ret = action->thread_fn(action->irq, action->dev_id);
@@ -417,7 +418,8 @@ void handle_nested_irq(unsigned int irq)
 		note_interrupt(irq, desc, action_ret);
 
 	raw_spin_lock_irq(&desc->lock);
-	desc->status &= ~IRQ_INPROGRESS;
+	desc->istate &= ~IRQS_INPROGRESS;
+	irq_compat_clr_progress(desc);
 
 out_unlock:
 	raw_spin_unlock_irq(&desc->lock);
@@ -448,7 +450,7 @@ handle_simple_irq(unsigned int irq, stru
 {
 	raw_spin_lock(&desc->lock);
 
-	if (unlikely(desc->status & IRQ_INPROGRESS))
+	if (unlikely(desc->istate & IRQS_INPROGRESS))
 		if (!irq_check_poll(desc))
 			goto out_unlock;
 
@@ -480,7 +482,7 @@ handle_level_irq(unsigned int irq, struc
 	raw_spin_lock(&desc->lock);
 	mask_ack_irq(desc);
 
-	if (unlikely(desc->status & IRQ_INPROGRESS))
+	if (unlikely(desc->istate & IRQS_INPROGRESS))
 		if (!irq_check_poll(desc))
 			goto out_unlock;
 
@@ -518,7 +520,7 @@ handle_fasteoi_irq(unsigned int irq, str
 {
 	raw_spin_lock(&desc->lock);
 
-	if (unlikely(desc->status & IRQ_INPROGRESS))
+	if (unlikely(desc->istate & IRQS_INPROGRESS))
 		if (!irq_check_poll(desc))
 			goto out;
 
@@ -568,8 +570,8 @@ handle_edge_irq(unsigned int irq, struct
 	 * we shouldn't process the IRQ. Mark it pending, handle
 	 * the necessary masking and go out
 	 */
-	if (unlikely((desc->status & (IRQ_INPROGRESS | IRQ_DISABLED)) ||
-		    !desc->action)) {
+	if (unlikely((desc->istate & (IRQS_INPROGRESS) ||
+		      (desc->status & IRQ_DISABLED) || !desc->action))) {
 		if (!irq_check_poll(desc)) {
 			desc->status |= IRQ_PENDING;
 			mask_ack_irq(desc);
Index: linux-2.6-tip/kernel/irq/compat.h
===================================================================
--- /dev/null
+++ linux-2.6-tip/kernel/irq/compat.h
@@ -0,0 +1,17 @@
+/*
+ * Compat layer for transition period
+ */
+#ifndef CONFIG_GENERIC_HARDIRQS_NO_COMPAT
+static inline void irq_compat_set_progress(struct irq_desc *desc)
+{
+	desc->status |= IRQ_INPROGRESS;
+}
+
+static inline void irq_compat_clr_progress(struct irq_desc *desc)
+{
+	desc->status &= ~IRQ_INPROGRESS;
+}
+#else
+static inline void irq_compat_set_progress(struct irq_desc *desc) { }
+static inline void irq_compat_clr_progress(struct irq_desc *desc) { }
+#endif
Index: linux-2.6-tip/kernel/irq/handle.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/handle.c
+++ linux-2.6-tip/kernel/irq/handle.c
@@ -123,13 +123,15 @@ irqreturn_t handle_irq_event(struct irq_
 	irqreturn_t ret;
 
 	desc->status &= ~IRQ_PENDING;
-	desc->status |= IRQ_INPROGRESS;
+	irq_compat_set_progress(desc);
+	desc->istate |= IRQS_INPROGRESS;
 	raw_spin_unlock(&desc->lock);
 
 	ret = handle_irq_event_percpu(desc, action);
 
 	raw_spin_lock(&desc->lock);
-	desc->status &= ~IRQ_INPROGRESS;
+	desc->istate &= ~IRQS_INPROGRESS;
+	irq_compat_clr_progress(desc);
 	return ret;
 }
 
Index: linux-2.6-tip/kernel/irq/internals.h
===================================================================
--- linux-2.6-tip.orig/kernel/irq/internals.h
+++ linux-2.6-tip/kernel/irq/internals.h
@@ -7,6 +7,7 @@
  */
 #include <linux/irqdesc.h>
 
+#include "compat.h"
 #include "settings.h"
 
 #define istate core_internal_state__do_not_mess_with_it
@@ -36,12 +37,14 @@ enum {
  * IRQS_NESTED_THREAD		- nested into another threaded handler
  *				  no own irq thread.
  * IRQS_POLL_INPROGRESS		- polling in progress
+ * IRQS_INPROGRESS		- Interrupt in progress
  */
 enum {
 	IRQS_AUTODETECT		= 0x00000001,
 	IRQS_SPURIOUS_DISABLED	= 0x00000002,
 	IRQS_NESTED_THREAD	= 0x00000004,
 	IRQS_POLL_INPROGRESS	= 0x00000008,
+	IRQS_INPROGRESS		= 0x00000010,
 };
 
 #define irq_data_to_desc(data)	container_of(data, struct irq_desc, irq_data)
@@ -126,7 +129,6 @@ static inline void print_irq_desc(unsign
 		print_symbol("%s\n", (unsigned long)desc->action->handler);
 	}
 
-	P(IRQ_INPROGRESS);
 	P(IRQ_DISABLED);
 	P(IRQ_PENDING);
 	P(IRQ_REPLAY);
@@ -141,6 +143,7 @@ static inline void print_irq_desc(unsign
 	P(IRQ_NOAUTOEN);
 
 	PS(IRQS_AUTODETECT);
+	PS(IRQS_INPROGRESS);
 }
 
 #undef P
Index: linux-2.6-tip/kernel/irq/manage.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/manage.c
+++ linux-2.6-tip/kernel/irq/manage.c
@@ -30,7 +30,7 @@
 void synchronize_irq(unsigned int irq)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
-	unsigned int status;
+	unsigned int state;
 
 	if (!desc)
 		return;
@@ -42,16 +42,16 @@ void synchronize_irq(unsigned int irq)
 		 * Wait until we're out of the critical section.  This might
 		 * give the wrong answer due to the lack of memory barriers.
 		 */
-		while (desc->status & IRQ_INPROGRESS)
+		while (desc->istate & IRQS_INPROGRESS)
 			cpu_relax();
 
 		/* Ok, that indicated we're done: double-check carefully. */
 		raw_spin_lock_irqsave(&desc->lock, flags);
-		status = desc->status;
+		state = desc->istate;
 		raw_spin_unlock_irqrestore(&desc->lock, flags);
 
 		/* Oops, that failed? */
-	} while (status & IRQ_INPROGRESS);
+	} while (state & IRQS_INPROGRESS);
 
 	/*
 	 * We made sure that no hardirq handler is running. Now verify
@@ -643,9 +643,9 @@ again:
 	 * The thread is faster done than the hard interrupt handler
 	 * on the other CPU. If we unmask the irq line then the
 	 * interrupt can come in again and masks the line, leaves due
-	 * to IRQ_INPROGRESS and the irq line is masked forever.
+	 * to IRQS_INPROGRESS and the irq line is masked forever.
 	 */
-	if (unlikely(desc->status & IRQ_INPROGRESS)) {
+	if (unlikely(desc->istate & IRQS_INPROGRESS)) {
 		raw_spin_unlock_irq(&desc->lock);
 		chip_bus_sync_unlock(desc);
 		cpu_relax();
@@ -903,8 +903,9 @@ __setup_irq(unsigned int irq, struct irq
 			desc->status |= IRQ_PER_CPU;
 #endif
 
-		desc->status &= ~(IRQ_WAITING | IRQ_ONESHOT | IRQ_INPROGRESS);
-		desc->istate &= ~(IRQS_AUTODETECT | IRQS_SPURIOUS_DISABLED);
+		desc->status &= ~(IRQ_WAITING | IRQ_ONESHOT);
+		desc->istate &= ~(IRQS_AUTODETECT | IRQS_SPURIOUS_DISABLED | \
+				  IRQS_INPROGRESS);
 
 		if (new->flags & IRQF_ONESHOT)
 			desc->status |= IRQ_ONESHOT;
Index: linux-2.6-tip/kernel/irq/settings.h
===================================================================
--- linux-2.6-tip.orig/kernel/irq/settings.h
+++ linux-2.6-tip/kernel/irq/settings.h
@@ -5,3 +5,6 @@
 enum {
 	_IRQ_DEFAULT_INIT_FLAGS	= IRQ_DEFAULT_INIT_FLAGS,
 };
+
+#undef IRQ_INPROGRESS
+#define IRQ_INPROGRESS		GOT_YOU_MORON
Index: linux-2.6-tip/kernel/irq/spurious.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/spurious.c
+++ linux-2.6-tip/kernel/irq/spurious.c
@@ -45,10 +45,10 @@ bool irq_wait_for_poll(struct irq_desc *
 #ifdef CONFIG_SMP
 	do {
 		raw_spin_unlock(&desc->lock);
-		while (desc->status & IRQ_INPROGRESS)
+		while (desc->istate & IRQS_INPROGRESS)
 			cpu_relax();
 		raw_spin_lock(&desc->lock);
-	} while (desc->status & IRQ_INPROGRESS);
+	} while (desc->istate & IRQS_INPROGRESS);
 	/* Might have been disabled in meantime */
 	return !(desc->status & IRQ_DISABLED) && desc->action;
 #else
@@ -88,7 +88,7 @@ static int try_one_irq(int irq, struct i
 		goto out;
 
 	/* Already running on another processor */
-	if (desc->status & IRQ_INPROGRESS) {
+	if (desc->istate & IRQS_INPROGRESS) {
 		/*
 		 * Already running: If it is shared get the other
 		 * CPU to go looking for our mystery interrupt too


