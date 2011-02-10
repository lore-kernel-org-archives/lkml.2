Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932242Ab1BJXht (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 18:37:49 -0500
Received: from www.tglx.de ([62.245.132.106]:44294 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932204Ab1BJXhm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 18:37:42 -0500
Message-Id: <20110210223258.460731726@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 10 Feb 2011 23:37:30 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [patch 43/75] genirq: Move IRQ_DISABLED to core
References: <20110210222908.661199947@linutronix.de>
Content-Disposition: inline; filename=genirq-move-disabled.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Keep status in sync until all abusers are fixed.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/irq.h    |    4 ++--
 kernel/irq/chip.c      |   48 +++++++++++++++++++++++++++++++-----------------
 kernel/irq/compat.h    |   12 ++++++++++++
 kernel/irq/internals.h |    4 +++-
 kernel/irq/irqdesc.c   |    2 ++
 kernel/irq/manage.c    |    4 ++--
 kernel/irq/migration.c |    2 +-
 kernel/irq/settings.h  |    2 ++
 kernel/irq/spurious.c  |    4 ++--
 9 files changed, 57 insertions(+), 25 deletions(-)

Index: linux-2.6-tip/include/linux/irq.h
===================================================================
--- linux-2.6-tip.orig/include/linux/irq.h
+++ linux-2.6-tip/include/linux/irq.h
@@ -55,9 +55,9 @@ typedef	void (*irq_flow_handler_t)(unsig
 #define IRQ_INPROGRESS		0x00000100	/* DEPRECATED */
 #define IRQ_REPLAY		0x00000200	/* DEPRECATED */
 #define IRQ_WAITING		0x00000400	/* DEPRECATED */
+#define IRQ_DISABLED		0x00000800	/* DEPRECATED */
 #endif
 
-#define IRQ_DISABLED		0x00000800	/* IRQ disabled - do not enter! */
 #define IRQ_PENDING		0x00001000	/* IRQ pending - replay on enable */
 
 #define IRQ_LEVEL		0x00004000	/* IRQ level triggered */
@@ -230,7 +230,7 @@ struct irq_chip {
 # define ARCH_IRQ_INIT_FLAGS	0
 #endif
 
-#define IRQ_DEFAULT_INIT_FLAGS	(IRQ_DISABLED | ARCH_IRQ_INIT_FLAGS)
+#define IRQ_DEFAULT_INIT_FLAGS	ARCH_IRQ_INIT_FLAGS
 
 struct irqaction;
 extern int setup_irq(unsigned int irq, struct irqaction *new);
Index: linux-2.6-tip/kernel/irq/chip.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/chip.c
+++ linux-2.6-tip/kernel/irq/chip.c
@@ -190,9 +190,21 @@ void set_irq_nested_thread(unsigned int 
 }
 EXPORT_SYMBOL_GPL(set_irq_nested_thread);
 
+static void irq_state_clr_disabled(struct irq_desc *desc)
+{
+	desc->istate &= ~IRQS_DISABLED;
+	irq_compat_clr_disabled(desc);
+}
+
+static void irq_state_set_disabled(struct irq_desc *desc)
+{
+	desc->istate |= IRQS_DISABLED;
+	irq_compat_set_disabled(desc);
+}
+
 int irq_startup(struct irq_desc *desc)
 {
-	desc->status &= ~IRQ_DISABLED;
+	irq_state_clr_disabled(desc);
 	desc->depth = 0;
 
 	if (desc->irq_data.chip->irq_startup) {
@@ -207,7 +219,7 @@ int irq_startup(struct irq_desc *desc)
 
 void irq_shutdown(struct irq_desc *desc)
 {
-	desc->status |= IRQ_DISABLED;
+	irq_state_set_disabled(desc);
 	desc->depth = 1;
 	if (desc->irq_data.chip->irq_shutdown)
 		desc->irq_data.chip->irq_shutdown(&desc->irq_data);
@@ -220,7 +232,7 @@ void irq_shutdown(struct irq_desc *desc)
 
 void irq_enable(struct irq_desc *desc)
 {
-	desc->status &= ~IRQ_DISABLED;
+	irq_state_clr_disabled(desc);
 	if (desc->irq_data.chip->irq_enable)
 		desc->irq_data.chip->irq_enable(&desc->irq_data);
 	else
@@ -230,7 +242,7 @@ void irq_enable(struct irq_desc *desc)
 
 void irq_disable(struct irq_desc *desc)
 {
-	desc->status |= IRQ_DISABLED;
+	irq_state_set_disabled(desc);
 	if (desc->irq_data.chip->irq_disable) {
 		desc->irq_data.chip->irq_disable(&desc->irq_data);
 		desc->status |= IRQ_MASKED;
@@ -406,7 +418,7 @@ void handle_nested_irq(unsigned int irq)
 	kstat_incr_irqs_this_cpu(irq, desc);
 
 	action = desc->action;
-	if (unlikely(!action || (desc->status & IRQ_DISABLED)))
+	if (unlikely(!action || (desc->istate & IRQS_DISABLED)))
 		goto out_unlock;
 
 	irq_compat_set_progress(desc);
@@ -457,7 +469,7 @@ handle_simple_irq(unsigned int irq, stru
 	desc->istate &= ~(IRQS_REPLAY | IRQS_WAITING);
 	kstat_incr_irqs_this_cpu(irq, desc);
 
-	if (unlikely(!desc->action || (desc->status & IRQ_DISABLED)))
+	if (unlikely(!desc->action || (desc->istate & IRQS_DISABLED)))
 		goto out_unlock;
 
 	handle_irq_event(desc);
@@ -493,12 +505,12 @@ handle_level_irq(unsigned int irq, struc
 	 * If its disabled or no action available
 	 * keep it masked and get out of here
 	 */
-	if (unlikely(!desc->action || (desc->status & IRQ_DISABLED)))
+	if (unlikely(!desc->action || (desc->istate & IRQS_DISABLED)))
 		goto out_unlock;
 
 	handle_irq_event(desc);
 
-	if (!(desc->status & IRQ_DISABLED) && !(desc->istate & IRQS_ONESHOT))
+	if (!(desc->istate & (IRQS_DISABLED | IRQS_ONESHOT)))
 		unmask_irq(desc);
 out_unlock:
 	raw_spin_unlock(&desc->lock);
@@ -531,7 +543,7 @@ handle_fasteoi_irq(unsigned int irq, str
 	 * If its disabled or no action available
 	 * then mask it and get out of here:
 	 */
-	if (unlikely(!desc->action || (desc->status & IRQ_DISABLED))) {
+	if (unlikely(!desc->action || (desc->istate & IRQS_DISABLED))) {
 		desc->status |= IRQ_PENDING;
 		mask_irq(desc);
 		goto out;
@@ -569,8 +581,8 @@ handle_edge_irq(unsigned int irq, struct
 	 * we shouldn't process the IRQ. Mark it pending, handle
 	 * the necessary masking and go out
 	 */
-	if (unlikely((desc->istate & (IRQS_INPROGRESS) ||
-		      (desc->status & IRQ_DISABLED) || !desc->action))) {
+	if (unlikely((desc->istate & (IRQS_DISABLED | IRQS_INPROGRESS) ||
+		      !desc->action))) {
 		if (!irq_check_poll(desc)) {
 			desc->status |= IRQ_PENDING;
 			mask_ack_irq(desc);
@@ -593,15 +605,16 @@ handle_edge_irq(unsigned int irq, struct
 		 * one, we could have masked the irq.
 		 * Renable it, if it was not disabled in meantime.
 		 */
-		if (unlikely((desc->status &
-			       (IRQ_PENDING | IRQ_MASKED | IRQ_DISABLED)) ==
-			      (IRQ_PENDING | IRQ_MASKED))) {
-			unmask_irq(desc);
+		if (unlikely(desc->status & IRQ_PENDING)) {
+			if (!(desc->istate & IRQS_DISABLED) &&
+			    (desc->status & IRQ_MASKED))
+				unmask_irq(desc);
 		}
 
 		handle_irq_event(desc);
 
-	} while ((desc->status & (IRQ_PENDING | IRQ_DISABLED)) == IRQ_PENDING);
+	} while ((desc->status & IRQ_PENDING) &&
+		 !(desc->istate & IRQS_DISABLED));
 
 out_unlock:
 	raw_spin_unlock(&desc->lock);
@@ -665,7 +678,8 @@ __set_irq_handler(unsigned int irq, irq_
 	if (handle == handle_bad_irq) {
 		if (desc->irq_data.chip != &no_irq_chip)
 			mask_ack_irq(desc);
-		desc->status |= IRQ_DISABLED;
+		irq_compat_set_disabled(desc);
+		desc->istate |= IRQS_DISABLED;
 		desc->depth = 1;
 	}
 	desc->handle_irq = handle;
Index: linux-2.6-tip/kernel/irq/compat.h
===================================================================
--- linux-2.6-tip.orig/kernel/irq/compat.h
+++ linux-2.6-tip/kernel/irq/compat.h
@@ -11,7 +11,19 @@ static inline void irq_compat_clr_progre
 {
 	desc->status &= ~IRQ_INPROGRESS;
 }
+static inline void irq_compat_set_disabled(struct irq_desc *desc)
+{
+	desc->status |= IRQ_DISABLED;
+}
+
+static inline void irq_compat_clr_disabled(struct irq_desc *desc)
+{
+	desc->status &= ~IRQ_DISABLED;
+}
 #else
 static inline void irq_compat_set_progress(struct irq_desc *desc) { }
 static inline void irq_compat_clr_progress(struct irq_desc *desc) { }
+static inline void irq_compat_set_disabled(struct irq_desc *desc) { }
+static inline void irq_compat_clr_disabled(struct irq_desc *desc) { }
 #endif
+
Index: linux-2.6-tip/kernel/irq/internals.h
===================================================================
--- linux-2.6-tip.orig/kernel/irq/internals.h
+++ linux-2.6-tip/kernel/irq/internals.h
@@ -41,6 +41,7 @@ enum {
  * IRQS_ONESHOT			- irq is not unmasked in primary handler
  * IRQS_REPLAY			- irq is replayed
  * IRQS_WAITING			- irq is waiting
+ * IRQS_DISABLED		- irq is disabled
  */
 enum {
 	IRQS_AUTODETECT		= 0x00000001,
@@ -51,6 +52,7 @@ enum {
 	IRQS_ONESHOT		= 0x00000020,
 	IRQS_REPLAY		= 0x00000040,
 	IRQS_WAITING		= 0x00000080,
+	IRQS_DISABLED		= 0x00000100,
 };
 
 #define irq_data_to_desc(data)	container_of(data, struct irq_desc, irq_data)
@@ -135,7 +137,6 @@ static inline void print_irq_desc(unsign
 		print_symbol("%s\n", (unsigned long)desc->action->handler);
 	}
 
-	P(IRQ_DISABLED);
 	P(IRQ_PENDING);
 	P(IRQ_LEVEL);
 	P(IRQ_MASKED);
@@ -150,6 +151,7 @@ static inline void print_irq_desc(unsign
 	PS(IRQS_INPROGRESS);
 	PS(IRQS_REPLAY);
 	PS(IRQS_WAITING);
+	PS(IRQS_DISABLED);
 }
 
 #undef P
Index: linux-2.6-tip/kernel/irq/irqdesc.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/irqdesc.c
+++ linux-2.6-tip/kernel/irq/irqdesc.c
@@ -80,6 +80,7 @@ static void desc_set_defaults(unsigned i
 	desc->irq_data.handler_data = NULL;
 	desc->irq_data.msi_desc = NULL;
 	desc->status = _IRQ_DEFAULT_INIT_FLAGS;
+	desc->istate = IRQS_DISABLED;
 	desc->handle_irq = handle_bad_irq;
 	desc->depth = 1;
 	desc->irq_count = 0;
@@ -230,6 +231,7 @@ int __init early_irq_init(void)
 struct irq_desc irq_desc[NR_IRQS] __cacheline_aligned_in_smp = {
 	[0 ... NR_IRQS-1] = {
 		.status		= _IRQ_DEFAULT_INIT_FLAGS,
+		.istate		= IRQS_DISABLED,
 		.handle_irq	= handle_bad_irq,
 		.depth		= 1,
 		.lock		= __RAW_SPIN_LOCK_UNLOCKED(irq_desc->lock),
Index: linux-2.6-tip/kernel/irq/manage.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/manage.c
+++ linux-2.6-tip/kernel/irq/manage.c
@@ -652,7 +652,7 @@ again:
 		goto again;
 	}
 
-	if (!(desc->status & IRQ_DISABLED) && (desc->status & IRQ_MASKED)) {
+	if (!(desc->istate & IRQS_DISABLED) && (desc->status & IRQ_MASKED)) {
 		desc->status &= ~IRQ_MASKED;
 		desc->irq_data.chip->irq_unmask(&desc->irq_data);
 	}
@@ -715,7 +715,7 @@ static int irq_thread(void *data)
 		atomic_inc(&desc->threads_active);
 
 		raw_spin_lock_irq(&desc->lock);
-		if (unlikely(desc->status & IRQ_DISABLED)) {
+		if (unlikely(desc->istate & IRQS_DISABLED)) {
 			/*
 			 * CHECKME: We might need a dedicated
 			 * IRQ_THREAD_PENDING flag here, which
Index: linux-2.6-tip/kernel/irq/migration.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/migration.c
+++ linux-2.6-tip/kernel/irq/migration.c
@@ -61,7 +61,7 @@ void move_native_irq(int irq)
 	if (likely(!(desc->status & IRQ_MOVE_PENDING)))
 		return;
 
-	if (unlikely(desc->status & IRQ_DISABLED))
+	if (unlikely(desc->istate & IRQS_DISABLED))
 		return;
 
 	/*
Index: linux-2.6-tip/kernel/irq/settings.h
===================================================================
--- linux-2.6-tip.orig/kernel/irq/settings.h
+++ linux-2.6-tip/kernel/irq/settings.h
@@ -12,3 +12,5 @@ enum {
 #define IRQ_REPLAY		GOT_YOU_MORON
 #undef IRQ_WAITING
 #define IRQ_WAITING		GOT_YOU_MORON
+#undef IRQ_DISABLED
+#define IRQ_DISABLED		GOT_YOU_MORON
Index: linux-2.6-tip/kernel/irq/spurious.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/spurious.c
+++ linux-2.6-tip/kernel/irq/spurious.c
@@ -50,7 +50,7 @@ bool irq_wait_for_poll(struct irq_desc *
 		raw_spin_lock(&desc->lock);
 	} while (desc->istate & IRQS_INPROGRESS);
 	/* Might have been disabled in meantime */
-	return !(desc->status & IRQ_DISABLED) && desc->action;
+	return !(desc->istate & IRQS_DISABLED) && desc->action;
 #else
 	return false;
 #endif
@@ -75,7 +75,7 @@ static int try_one_irq(int irq, struct i
 	 * Do not poll disabled interrupts unless the spurious
 	 * disabled poller asks explicitely.
 	 */
-	if ((desc->status & IRQ_DISABLED) && !force)
+	if ((desc->istate & IRQS_DISABLED) && !force)
 		goto out;
 
 	/*


