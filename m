Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932222Ab1BJXhr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 18:37:47 -0500
Received: from www.tglx.de ([62.245.132.106]:44301 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932206Ab1BJXhn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 18:37:43 -0500
Message-Id: <20110210223258.556677117@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 10 Feb 2011 23:37:32 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [patch 44/75] genirq: Move IRQ_PENDING flag to core
References: <20110210222908.661199947@linutronix.de>
Content-Disposition: inline; filename=genirq-move-pending.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Keep status in sync until all users are fixed.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/irq.h    |    2 +-
 kernel/irq/autoprobe.c |    6 ++++--
 kernel/irq/chip.c      |   10 ++++++----
 kernel/irq/compat.h    |   12 +++++++++++-
 kernel/irq/handle.c    |    3 ++-
 kernel/irq/internals.h |    4 +++-
 kernel/irq/manage.c    |    5 +++--
 kernel/irq/pm.c        |    3 ++-
 kernel/irq/resend.c    |    5 +++--
 kernel/irq/settings.h  |    2 ++
 kernel/irq/spurious.c  |    5 +++--
 11 files changed, 40 insertions(+), 17 deletions(-)

Index: linux-2.6-tip/include/linux/irq.h
===================================================================
--- linux-2.6-tip.orig/include/linux/irq.h
+++ linux-2.6-tip/include/linux/irq.h
@@ -56,9 +56,9 @@ typedef	void (*irq_flow_handler_t)(unsig
 #define IRQ_REPLAY		0x00000200	/* DEPRECATED */
 #define IRQ_WAITING		0x00000400	/* DEPRECATED */
 #define IRQ_DISABLED		0x00000800	/* DEPRECATED */
+#define IRQ_PENDING		0x00001000	/* DEPRECATED */
 #endif
 
-#define IRQ_PENDING		0x00001000	/* IRQ pending - replay on enable */
 
 #define IRQ_LEVEL		0x00004000	/* IRQ level triggered */
 #define IRQ_MASKED		0x00008000	/* IRQ masked - shouldn't be seen again */
Index: linux-2.6-tip/kernel/irq/autoprobe.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/autoprobe.c
+++ linux-2.6-tip/kernel/irq/autoprobe.c
@@ -76,8 +76,10 @@ unsigned long probe_irq_on(void)
 		raw_spin_lock_irq(&desc->lock);
 		if (!desc->action && !(desc->status & IRQ_NOPROBE)) {
 			desc->istate |= IRQS_AUTODETECT | IRQS_WAITING;
-			if (irq_startup(desc))
-				desc->status |= IRQ_PENDING;
+			if (irq_startup(desc)) {
+				irq_compat_set_pending(desc);
+				desc->istate |= IRQS_PENDING;
+			}
 		}
 		raw_spin_unlock_irq(&desc->lock);
 	}
Index: linux-2.6-tip/kernel/irq/chip.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/chip.c
+++ linux-2.6-tip/kernel/irq/chip.c
@@ -544,7 +544,8 @@ handle_fasteoi_irq(unsigned int irq, str
 	 * then mask it and get out of here:
 	 */
 	if (unlikely(!desc->action || (desc->istate & IRQS_DISABLED))) {
-		desc->status |= IRQ_PENDING;
+		irq_compat_set_pending(desc);
+		desc->istate |= IRQS_PENDING;
 		mask_irq(desc);
 		goto out;
 	}
@@ -584,7 +585,8 @@ handle_edge_irq(unsigned int irq, struct
 	if (unlikely((desc->istate & (IRQS_DISABLED | IRQS_INPROGRESS) ||
 		      !desc->action))) {
 		if (!irq_check_poll(desc)) {
-			desc->status |= IRQ_PENDING;
+			irq_compat_set_pending(desc);
+			desc->istate |= IRQS_PENDING;
 			mask_ack_irq(desc);
 			goto out_unlock;
 		}
@@ -605,7 +607,7 @@ handle_edge_irq(unsigned int irq, struct
 		 * one, we could have masked the irq.
 		 * Renable it, if it was not disabled in meantime.
 		 */
-		if (unlikely(desc->status & IRQ_PENDING)) {
+		if (unlikely(desc->istate & IRQS_PENDING)) {
 			if (!(desc->istate & IRQS_DISABLED) &&
 			    (desc->status & IRQ_MASKED))
 				unmask_irq(desc);
@@ -613,7 +615,7 @@ handle_edge_irq(unsigned int irq, struct
 
 		handle_irq_event(desc);
 
-	} while ((desc->status & IRQ_PENDING) &&
+	} while ((desc->istate & IRQS_PENDING) &&
 		 !(desc->istate & IRQS_DISABLED));
 
 out_unlock:
Index: linux-2.6-tip/kernel/irq/compat.h
===================================================================
--- linux-2.6-tip.orig/kernel/irq/compat.h
+++ linux-2.6-tip/kernel/irq/compat.h
@@ -15,15 +15,25 @@ static inline void irq_compat_set_disabl
 {
 	desc->status |= IRQ_DISABLED;
 }
-
 static inline void irq_compat_clr_disabled(struct irq_desc *desc)
 {
 	desc->status &= ~IRQ_DISABLED;
 }
+static inline void irq_compat_set_pending(struct irq_desc *desc)
+{
+	desc->status |= IRQ_PENDING;
+}
+
+static inline void irq_compat_clr_pending(struct irq_desc *desc)
+{
+	desc->status &= ~IRQ_PENDING;
+}
 #else
 static inline void irq_compat_set_progress(struct irq_desc *desc) { }
 static inline void irq_compat_clr_progress(struct irq_desc *desc) { }
 static inline void irq_compat_set_disabled(struct irq_desc *desc) { }
 static inline void irq_compat_clr_disabled(struct irq_desc *desc) { }
+static inline void irq_compat_set_pending(struct irq_desc *desc) { }
+static inline void irq_compat_clr_pending(struct irq_desc *desc) { }
 #endif
 
Index: linux-2.6-tip/kernel/irq/handle.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/handle.c
+++ linux-2.6-tip/kernel/irq/handle.c
@@ -122,7 +122,8 @@ irqreturn_t handle_irq_event(struct irq_
 	struct irqaction *action = desc->action;
 	irqreturn_t ret;
 
-	desc->status &= ~IRQ_PENDING;
+	irq_compat_clr_pending(desc);
+	desc->istate &= ~IRQS_PENDING;
 	irq_compat_set_progress(desc);
 	desc->istate |= IRQS_INPROGRESS;
 	raw_spin_unlock(&desc->lock);
Index: linux-2.6-tip/kernel/irq/internals.h
===================================================================
--- linux-2.6-tip.orig/kernel/irq/internals.h
+++ linux-2.6-tip/kernel/irq/internals.h
@@ -42,6 +42,7 @@ enum {
  * IRQS_REPLAY			- irq is replayed
  * IRQS_WAITING			- irq is waiting
  * IRQS_DISABLED		- irq is disabled
+ * IRQS_PENDING			- irq is pending and replayed later
  */
 enum {
 	IRQS_AUTODETECT		= 0x00000001,
@@ -53,6 +54,7 @@ enum {
 	IRQS_REPLAY		= 0x00000040,
 	IRQS_WAITING		= 0x00000080,
 	IRQS_DISABLED		= 0x00000100,
+	IRQS_PENDING		= 0x00000200,
 };
 
 #define irq_data_to_desc(data)	container_of(data, struct irq_desc, irq_data)
@@ -137,7 +139,6 @@ static inline void print_irq_desc(unsign
 		print_symbol("%s\n", (unsigned long)desc->action->handler);
 	}
 
-	P(IRQ_PENDING);
 	P(IRQ_LEVEL);
 	P(IRQ_MASKED);
 #ifdef CONFIG_IRQ_PER_CPU
@@ -152,6 +153,7 @@ static inline void print_irq_desc(unsign
 	PS(IRQS_REPLAY);
 	PS(IRQS_WAITING);
 	PS(IRQS_DISABLED);
+	PS(IRQS_PENDING);
 }
 
 #undef P
Index: linux-2.6-tip/kernel/irq/manage.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/manage.c
+++ linux-2.6-tip/kernel/irq/manage.c
@@ -720,10 +720,11 @@ static int irq_thread(void *data)
 			 * CHECKME: We might need a dedicated
 			 * IRQ_THREAD_PENDING flag here, which
 			 * retriggers the thread in check_irq_resend()
-			 * but AFAICT IRQ_PENDING should be fine as it
+			 * but AFAICT IRQS_PENDING should be fine as it
 			 * retriggers the interrupt itself --- tglx
 			 */
-			desc->status |= IRQ_PENDING;
+			irq_compat_set_pending(desc);
+			desc->istate |= IRQS_PENDING;
 			raw_spin_unlock_irq(&desc->lock);
 		} else {
 			raw_spin_unlock_irq(&desc->lock);
Index: linux-2.6-tip/kernel/irq/pm.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/pm.c
+++ linux-2.6-tip/kernel/irq/pm.c
@@ -69,7 +69,8 @@ int check_wakeup_irqs(void)
 	int irq;
 
 	for_each_irq_desc(irq, desc)
-		if ((desc->status & IRQ_WAKEUP) && (desc->status & IRQ_PENDING))
+		if ((desc->status & IRQ_WAKEUP) &&
+		    (desc->istate & IRQS_PENDING))
 			return -EBUSY;
 
 	return 0;
Index: linux-2.6-tip/kernel/irq/resend.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/resend.c
+++ linux-2.6-tip/kernel/irq/resend.c
@@ -64,8 +64,9 @@ void check_irq_resend(struct irq_desc *d
 		return;
 	if (desc->istate & IRQS_REPLAY)
 		return;
-	if (desc->status & IRQ_PENDING) {
-		desc->status &= IRQ_PENDING;
+	if (desc->istate & IRQS_PENDING) {
+		irq_compat_clr_pending(desc);
+		desc->istate &= IRQS_PENDING;
 		desc->istate |= IRQS_REPLAY;
 
 		if (!desc->irq_data.chip->irq_retrigger ||
Index: linux-2.6-tip/kernel/irq/settings.h
===================================================================
--- linux-2.6-tip.orig/kernel/irq/settings.h
+++ linux-2.6-tip/kernel/irq/settings.h
@@ -14,3 +14,5 @@ enum {
 #define IRQ_WAITING		GOT_YOU_MORON
 #undef IRQ_DISABLED
 #define IRQ_DISABLED		GOT_YOU_MORON
+#undef IRQ_PENDING
+#define IRQ_PENDING		GOT_YOU_MORON
Index: linux-2.6-tip/kernel/irq/spurious.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/spurious.c
+++ linux-2.6-tip/kernel/irq/spurious.c
@@ -93,7 +93,8 @@ static int try_one_irq(int irq, struct i
 		 * Already running: If it is shared get the other
 		 * CPU to go looking for our mystery interrupt too
 		 */
-		desc->status |= IRQ_PENDING;
+		irq_compat_set_pending(desc);
+		desc->istate |= IRQS_PENDING;
 		goto out;
 	}
 
@@ -103,7 +104,7 @@ static int try_one_irq(int irq, struct i
 		if (handle_irq_event(desc) == IRQ_HANDLED)
 			ret = IRQ_HANDLED;
 		action = desc->action;
-	} while ((desc->status & IRQ_PENDING) && action);
+	} while ((desc->istate & IRQS_PENDING) && action);
 	desc->istate &= ~IRQS_POLL_INPROGRESS;
 out:
 	raw_spin_unlock(&desc->lock);


