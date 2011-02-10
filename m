Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757559Ab1BJXh3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 18:37:29 -0500
Received: from www.tglx.de ([62.245.132.106]:44210 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757472Ab1BJXhW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 18:37:22 -0500
Message-Id: <20110210223257.889859877@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 10 Feb 2011 23:37:15 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [patch 37/75] genirq: Move IRQ_SPURIOUS_DISABLED to core state
References: <20110210222908.661199947@linutronix.de>
Content-Disposition: inline; filename=genirq-move-spurious-disabled.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No users outside.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/irq.h    |    1 -
 kernel/irq/internals.h |    3 +++
 kernel/irq/manage.c    |    9 ++++-----
 kernel/irq/spurious.c  |    8 ++++----
 4 files changed, 11 insertions(+), 10 deletions(-)

Index: linux-2.6-tip/include/linux/irq.h
===================================================================
--- linux-2.6-tip.orig/include/linux/irq.h
+++ linux-2.6-tip/include/linux/irq.h
@@ -64,7 +64,6 @@ typedef	void (*irq_flow_handler_t)(unsig
 #define IRQ_WAKEUP		0x00100000	/* IRQ triggers system wakeup */
 #define IRQ_MOVE_PENDING	0x00200000	/* need to re-target IRQ destination */
 #define IRQ_NO_BALANCING	0x00400000	/* IRQ is excluded from balancing */
-#define IRQ_SPURIOUS_DISABLED	0x00800000	/* IRQ was disabled by the spurious trap */
 #define IRQ_MOVE_PCNTXT		0x01000000	/* IRQ migration from process context */
 #define IRQ_AFFINITY_SET	0x02000000	/* IRQ affinity was set from userspace*/
 #define IRQ_SUSPENDED		0x04000000	/* IRQ has gone through suspend sequence */
Index: linux-2.6-tip/kernel/irq/internals.h
===================================================================
--- linux-2.6-tip.orig/kernel/irq/internals.h
+++ linux-2.6-tip/kernel/irq/internals.h
@@ -31,9 +31,12 @@ enum {
  * Bit masks for desc->state
  *
  * IRQS_AUTODETECT		- autodetection in progress
+ * IRQS_SPURIOUS_DISABLED	- was disabled due to spurious interrupt
+ *				  detection
  */
 enum {
 	IRQS_AUTODETECT		= 0x00000001,
+	IRQS_SPURIOUS_DISABLED	= 0x00000002,
 };
 
 #define irq_data_to_desc(data)	container_of(data, struct irq_desc, irq_data)
Index: linux-2.6-tip/kernel/irq/manage.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/manage.c
+++ linux-2.6-tip/kernel/irq/manage.c
@@ -903,9 +903,8 @@ __setup_irq(unsigned int irq, struct irq
 			desc->status |= IRQ_PER_CPU;
 #endif
 
-		desc->status &= ~(IRQ_WAITING | IRQ_ONESHOT |
-				  IRQ_INPROGRESS | IRQ_SPURIOUS_DISABLED);
-		desc->istate &= ~IRQS_AUTODETECT;
+		desc->status &= ~(IRQ_WAITING | IRQ_ONESHOT | IRQ_INPROGRESS);
+		desc->istate &= ~(IRQS_AUTODETECT | IRQS_SPURIOUS_DISABLED);
 
 		if (new->flags & IRQF_ONESHOT)
 			desc->status |= IRQ_ONESHOT;
@@ -943,8 +942,8 @@ __setup_irq(unsigned int irq, struct irq
 	 * Check whether we disabled the irq via the spurious handler
 	 * before. Reenable it and give it another chance.
 	 */
-	if (shared && (desc->status & IRQ_SPURIOUS_DISABLED)) {
-		desc->status &= ~IRQ_SPURIOUS_DISABLED;
+	if (shared && (desc->istate & IRQS_SPURIOUS_DISABLED)) {
+		desc->istate &= ~IRQS_SPURIOUS_DISABLED;
 		__enable_irq(desc, irq, false);
 	}
 
Index: linux-2.6-tip/kernel/irq/spurious.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/spurious.c
+++ linux-2.6-tip/kernel/irq/spurious.c
@@ -146,15 +146,15 @@ static void poll_spurious_irqs(unsigned 
 	irq_poll_cpu = smp_processor_id();
 
 	for_each_irq_desc(i, desc) {
-		unsigned int status;
+		unsigned int state;
 
 		if (!i)
 			 continue;
 
 		/* Racy but it doesn't matter */
-		status = desc->status;
+		state = desc->istate;
 		barrier();
-		if (!(status & IRQ_SPURIOUS_DISABLED))
+		if (!(state & IRQS_SPURIOUS_DISABLED))
 			continue;
 
 		local_irq_disable();
@@ -298,7 +298,7 @@ void note_interrupt(unsigned int irq, st
 		 * Now kill the IRQ
 		 */
 		printk(KERN_EMERG "Disabling IRQ #%d\n", irq);
-		desc->status |= IRQ_SPURIOUS_DISABLED;
+		desc->istate |= IRQS_SPURIOUS_DISABLED;
 		desc->depth++;
 		irq_disable(desc);
 


