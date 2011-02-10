Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932343Ab1BJXiO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 18:38:14 -0500
Received: from www.tglx.de ([62.245.132.106]:44397 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932294Ab1BJXiF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 18:38:05 -0500
Message-Id: <20110210223258.750843019@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 10 Feb 2011 23:37:37 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [patch 46/75] genirq: Move IRQ_SUSPENDED to core
References: <20110210222908.661199947@linutronix.de>
Content-Disposition: inline; filename=genirq-move-suspended.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No users outside of core.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/irq.h    |    2 --
 kernel/irq/internals.h |    2 ++
 kernel/irq/manage.c    |    8 ++++----
 kernel/irq/pm.c        |    6 +++---
 4 files changed, 9 insertions(+), 9 deletions(-)

Index: linux-2.6-tip/include/linux/irq.h
===================================================================
--- linux-2.6-tip.orig/include/linux/irq.h
+++ linux-2.6-tip/include/linux/irq.h
@@ -60,7 +60,6 @@ typedef	void (*irq_flow_handler_t)(unsig
 #define IRQ_MASKED		0x00002000	/* DEPRECATED */
 #endif
 
-
 #define IRQ_LEVEL		0x00004000	/* IRQ level triggered */
 #define IRQ_PER_CPU		0x00010000	/* IRQ is per CPU */
 #define IRQ_NOPROBE		0x00020000	/* IRQ is not valid for probing */
@@ -71,7 +70,6 @@ typedef	void (*irq_flow_handler_t)(unsig
 #define IRQ_NO_BALANCING	0x00400000	/* IRQ is excluded from balancing */
 #define IRQ_MOVE_PCNTXT		0x01000000	/* IRQ migration from process context */
 #define IRQ_AFFINITY_SET	0x02000000	/* IRQ affinity was set from userspace*/
-#define IRQ_SUSPENDED		0x04000000	/* IRQ has gone through suspend sequence */
 
 #define IRQF_MODIFY_MASK	\
 	(IRQ_TYPE_SENSE_MASK | IRQ_NOPROBE | IRQ_NOREQUEST | \
Index: linux-2.6-tip/kernel/irq/internals.h
===================================================================
--- linux-2.6-tip.orig/kernel/irq/internals.h
+++ linux-2.6-tip/kernel/irq/internals.h
@@ -44,6 +44,7 @@ enum {
  * IRQS_DISABLED		- irq is disabled
  * IRQS_PENDING			- irq is pending and replayed later
  * IRQS_MASKED			- irq is masked
+ * IRQS_SUSPENDED		- irq is suspended
  */
 enum {
 	IRQS_AUTODETECT		= 0x00000001,
@@ -57,6 +58,7 @@ enum {
 	IRQS_DISABLED		= 0x00000100,
 	IRQS_PENDING		= 0x00000200,
 	IRQS_MASKED		= 0x00000400,
+	IRQS_SUSPENDED		= 0x00000800,
 };
 
 #define irq_data_to_desc(data)	container_of(data, struct irq_desc, irq_data)
Index: linux-2.6-tip/kernel/irq/manage.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/manage.c
+++ linux-2.6-tip/kernel/irq/manage.c
@@ -334,7 +334,7 @@ void __disable_irq(struct irq_desc *desc
 	if (suspend) {
 		if (!desc->action || (desc->action->flags & IRQF_NO_SUSPEND))
 			return;
-		desc->status |= IRQ_SUSPENDED;
+		desc->istate |= IRQS_SUSPENDED;
 	}
 
 	if (!desc->depth++)
@@ -396,7 +396,7 @@ EXPORT_SYMBOL(disable_irq);
 void __enable_irq(struct irq_desc *desc, unsigned int irq, bool resume)
 {
 	if (resume) {
-		if (!(desc->status & IRQ_SUSPENDED)) {
+		if (!(desc->istate & IRQS_SUSPENDED)) {
 			if (!desc->action)
 				return;
 			if (!(desc->action->flags & IRQF_FORCE_RESUME))
@@ -404,7 +404,7 @@ void __enable_irq(struct irq_desc *desc,
 			/* Pretend that it got disabled ! */
 			desc->depth++;
 		}
-		desc->status &= ~IRQ_SUSPENDED;
+		desc->istate &= ~IRQS_SUSPENDED;
 	}
 
 	switch (desc->depth) {
@@ -413,7 +413,7 @@ void __enable_irq(struct irq_desc *desc,
 		WARN(1, KERN_WARNING "Unbalanced enable for IRQ %d\n", irq);
 		break;
 	case 1: {
-		if (desc->status & IRQ_SUSPENDED)
+		if (desc->istate & IRQS_SUSPENDED)
 			goto err_out;
 		/* Prevent probing on this irq: */
 		desc->status |= IRQ_NOPROBE;
Index: linux-2.6-tip/kernel/irq/pm.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/pm.c
+++ linux-2.6-tip/kernel/irq/pm.c
@@ -18,7 +18,7 @@
  * During system-wide suspend or hibernation device drivers need to be prevented
  * from receiving interrupts and this function is provided for this purpose.
  * It marks all interrupt lines in use, except for the timer ones, as disabled
- * and sets the IRQ_SUSPENDED flag for each of them.
+ * and sets the IRQS_SUSPENDED flag for each of them.
  */
 void suspend_device_irqs(void)
 {
@@ -34,7 +34,7 @@ void suspend_device_irqs(void)
 	}
 
 	for_each_irq_desc(irq, desc)
-		if (desc->status & IRQ_SUSPENDED)
+		if (desc->istate & IRQS_SUSPENDED)
 			synchronize_irq(irq);
 }
 EXPORT_SYMBOL_GPL(suspend_device_irqs);
@@ -43,7 +43,7 @@ EXPORT_SYMBOL_GPL(suspend_device_irqs);
  * resume_device_irqs - enable interrupt lines disabled by suspend_device_irqs()
  *
  * Enable all interrupt lines previously disabled by suspend_device_irqs() that
- * have the IRQ_SUSPENDED flag set.
+ * have the IRQS_SUSPENDED flag set.
  */
 void resume_device_irqs(void)
 {


