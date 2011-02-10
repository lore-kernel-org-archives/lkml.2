Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932279Ab1BJXiA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 18:38:00 -0500
Received: from www.tglx.de ([62.245.132.106]:44364 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932153Ab1BJXh4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 18:37:56 -0500
Message-Id: <20110210223258.364026889@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 10 Feb 2011 23:37:27 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [patch 42/75] genirq: Move IRQ_REPLAY and IRQ_WAITING to core
References: <20110210222908.661199947@linutronix.de>
Content-Disposition: inline; filename=genirq-move-waiting-replay.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No users outside of core.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/irq.h    |    9 +++++----
 kernel/irq/autoprobe.c |   11 +++++------
 kernel/irq/chip.c      |    9 ++++-----
 kernel/irq/internals.h |    8 ++++++--
 kernel/irq/manage.c    |    4 ++--
 kernel/irq/resend.c    |    7 +++++--
 kernel/irq/settings.h  |    4 ++++
 7 files changed, 31 insertions(+), 21 deletions(-)

Index: linux-2.6-tip/include/linux/irq.h
===================================================================
--- linux-2.6-tip.orig/include/linux/irq.h
+++ linux-2.6-tip/include/linux/irq.h
@@ -53,12 +53,13 @@ typedef	void (*irq_flow_handler_t)(unsig
 
 #ifndef CONFIG_GENERIC_HARDIRQS_NO_COMPAT
 #define IRQ_INPROGRESS		0x00000100	/* DEPRECATED */
+#define IRQ_REPLAY		0x00000200	/* DEPRECATED */
+#define IRQ_WAITING		0x00000400	/* DEPRECATED */
 #endif
 
-#define IRQ_DISABLED		0x00000200	/* IRQ disabled - do not enter! */
-#define IRQ_PENDING		0x00000400	/* IRQ pending - replay on enable */
-#define IRQ_REPLAY		0x00000800	/* IRQ has been replayed but not acked yet */
-#define IRQ_WAITING		0x00002000	/* IRQ not yet seen - for autodetection */
+#define IRQ_DISABLED		0x00000800	/* IRQ disabled - do not enter! */
+#define IRQ_PENDING		0x00001000	/* IRQ pending - replay on enable */
+
 #define IRQ_LEVEL		0x00004000	/* IRQ level triggered */
 #define IRQ_MASKED		0x00008000	/* IRQ masked - shouldn't be seen again */
 #define IRQ_PER_CPU		0x00010000	/* IRQ is per CPU */
Index: linux-2.6-tip/kernel/irq/autoprobe.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/autoprobe.c
+++ linux-2.6-tip/kernel/irq/autoprobe.c
@@ -17,7 +17,7 @@
 /*
  * Autodetection depends on the fact that any interrupt that
  * comes in on to an unassigned handler will get stuck with
- * "IRQ_WAITING" cleared and the interrupt disabled.
+ * "IRQS_WAITING" cleared and the interrupt disabled.
  */
 static DEFINE_MUTEX(probing_active);
 
@@ -75,8 +75,7 @@ unsigned long probe_irq_on(void)
 	for_each_irq_desc_reverse(i, desc) {
 		raw_spin_lock_irq(&desc->lock);
 		if (!desc->action && !(desc->status & IRQ_NOPROBE)) {
-			desc->istate |= IRQS_AUTODETECT;
-			desc->status |= IRQ_WAITING;
+			desc->istate |= IRQS_AUTODETECT | IRQS_WAITING;
 			if (irq_startup(desc))
 				desc->status |= IRQ_PENDING;
 		}
@@ -96,7 +95,7 @@ unsigned long probe_irq_on(void)
 
 		if (desc->istate & IRQS_AUTODETECT) {
 			/* It triggered already - consider it spurious. */
-			if (!(desc->status & IRQ_WAITING)) {
+			if (!(desc->istate & IRQS_WAITING)) {
 				desc->istate &= ~IRQS_AUTODETECT;
 				irq_shutdown(desc);
 			} else
@@ -131,7 +130,7 @@ unsigned int probe_irq_mask(unsigned lon
 	for_each_irq_desc(i, desc) {
 		raw_spin_lock_irq(&desc->lock);
 		if (desc->istate & IRQS_AUTODETECT) {
-			if (i < 16 && !(desc->status & IRQ_WAITING))
+			if (i < 16 && !(desc->istate & IRQS_WAITING))
 				mask |= 1 << i;
 
 			desc->istate &= ~IRQS_AUTODETECT;
@@ -171,7 +170,7 @@ int probe_irq_off(unsigned long val)
 		raw_spin_lock_irq(&desc->lock);
 
 		if (desc->istate & IRQS_AUTODETECT) {
-			if (!(desc->status & IRQ_WAITING)) {
+			if (!(desc->istate & IRQS_WAITING)) {
 				if (!nr_of_irqs)
 					irq_found = i;
 				nr_of_irqs++;
Index: linux-2.6-tip/kernel/irq/chip.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/chip.c
+++ linux-2.6-tip/kernel/irq/chip.c
@@ -454,7 +454,7 @@ handle_simple_irq(unsigned int irq, stru
 		if (!irq_check_poll(desc))
 			goto out_unlock;
 
-	desc->status &= ~(IRQ_REPLAY | IRQ_WAITING);
+	desc->istate &= ~(IRQS_REPLAY | IRQS_WAITING);
 	kstat_incr_irqs_this_cpu(irq, desc);
 
 	if (unlikely(!desc->action || (desc->status & IRQ_DISABLED)))
@@ -486,7 +486,7 @@ handle_level_irq(unsigned int irq, struc
 		if (!irq_check_poll(desc))
 			goto out_unlock;
 
-	desc->status &= ~(IRQ_REPLAY | IRQ_WAITING);
+	desc->istate &= ~(IRQS_REPLAY | IRQS_WAITING);
 	kstat_incr_irqs_this_cpu(irq, desc);
 
 	/*
@@ -524,7 +524,7 @@ handle_fasteoi_irq(unsigned int irq, str
 		if (!irq_check_poll(desc))
 			goto out;
 
-	desc->status &= ~(IRQ_REPLAY | IRQ_WAITING);
+	desc->istate &= ~(IRQS_REPLAY | IRQS_WAITING);
 	kstat_incr_irqs_this_cpu(irq, desc);
 
 	/*
@@ -563,8 +563,7 @@ handle_edge_irq(unsigned int irq, struct
 {
 	raw_spin_lock(&desc->lock);
 
-	desc->status &= ~(IRQ_REPLAY | IRQ_WAITING);
-
+	desc->istate &= ~(IRQS_REPLAY | IRQS_WAITING);
 	/*
 	 * If we're currently running this IRQ, or its disabled,
 	 * we shouldn't process the IRQ. Mark it pending, handle
Index: linux-2.6-tip/kernel/irq/internals.h
===================================================================
--- linux-2.6-tip.orig/kernel/irq/internals.h
+++ linux-2.6-tip/kernel/irq/internals.h
@@ -39,6 +39,8 @@ enum {
  * IRQS_POLL_INPROGRESS		- polling in progress
  * IRQS_INPROGRESS		- Interrupt in progress
  * IRQS_ONESHOT			- irq is not unmasked in primary handler
+ * IRQS_REPLAY			- irq is replayed
+ * IRQS_WAITING			- irq is waiting
  */
 enum {
 	IRQS_AUTODETECT		= 0x00000001,
@@ -47,6 +49,8 @@ enum {
 	IRQS_POLL_INPROGRESS	= 0x00000008,
 	IRQS_INPROGRESS		= 0x00000010,
 	IRQS_ONESHOT		= 0x00000020,
+	IRQS_REPLAY		= 0x00000040,
+	IRQS_WAITING		= 0x00000080,
 };
 
 #define irq_data_to_desc(data)	container_of(data, struct irq_desc, irq_data)
@@ -133,8 +137,6 @@ static inline void print_irq_desc(unsign
 
 	P(IRQ_DISABLED);
 	P(IRQ_PENDING);
-	P(IRQ_REPLAY);
-	P(IRQ_WAITING);
 	P(IRQ_LEVEL);
 	P(IRQ_MASKED);
 #ifdef CONFIG_IRQ_PER_CPU
@@ -146,6 +148,8 @@ static inline void print_irq_desc(unsign
 
 	PS(IRQS_AUTODETECT);
 	PS(IRQS_INPROGRESS);
+	PS(IRQS_REPLAY);
+	PS(IRQS_WAITING);
 }
 
 #undef P
Index: linux-2.6-tip/kernel/irq/manage.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/manage.c
+++ linux-2.6-tip/kernel/irq/manage.c
@@ -903,9 +903,9 @@ __setup_irq(unsigned int irq, struct irq
 			desc->status |= IRQ_PER_CPU;
 #endif
 
-		desc->status &= ~IRQ_WAITING;
 		desc->istate &= ~(IRQS_AUTODETECT | IRQS_SPURIOUS_DISABLED | \
-				  IRQS_INPROGRESS | IRQS_ONESHOT);
+				  IRQS_INPROGRESS | IRQS_ONESHOT | \
+				  IRQS_WAITING);
 
 		if (new->flags & IRQF_ONESHOT)
 			desc->istate |= IRQS_ONESHOT;
Index: linux-2.6-tip/kernel/irq/resend.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/resend.c
+++ linux-2.6-tip/kernel/irq/resend.c
@@ -62,8 +62,11 @@ void check_irq_resend(struct irq_desc *d
 	 */
 	if (desc->status & IRQ_LEVEL)
 		return;
-	if ((desc->status & (IRQ_PENDING | IRQ_REPLAY)) == IRQ_PENDING) {
-		desc->status = (desc->status & ~IRQ_PENDING) | IRQ_REPLAY;
+	if (desc->istate & IRQS_REPLAY)
+		return;
+	if (desc->status & IRQ_PENDING) {
+		desc->status &= IRQ_PENDING;
+		desc->istate |= IRQS_REPLAY;
 
 		if (!desc->irq_data.chip->irq_retrigger ||
 		    !desc->irq_data.chip->irq_retrigger(&desc->irq_data)) {
Index: linux-2.6-tip/kernel/irq/settings.h
===================================================================
--- linux-2.6-tip.orig/kernel/irq/settings.h
+++ linux-2.6-tip/kernel/irq/settings.h
@@ -8,3 +8,7 @@ enum {
 
 #undef IRQ_INPROGRESS
 #define IRQ_INPROGRESS		GOT_YOU_MORON
+#undef IRQ_REPLAY
+#define IRQ_REPLAY		GOT_YOU_MORON
+#undef IRQ_WAITING
+#define IRQ_WAITING		GOT_YOU_MORON


