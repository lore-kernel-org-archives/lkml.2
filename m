Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932205Ab1BJXh4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 18:37:56 -0500
Received: from www.tglx.de ([62.245.132.106]:44353 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757573Ab1BJXhy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 18:37:54 -0500
Message-Id: <20110210223258.941628673@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 10 Feb 2011 23:37:42 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [patch 48/75] genirq: Move IRQ_WAKEUP to core
References: <20110210222908.661199947@linutronix.de>
Content-Disposition: inline; filename=genirq-move-wakeup.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No users outside of core.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/irq.h    |    1 -
 kernel/irq/internals.h |    2 ++
 kernel/irq/manage.c    |    4 ++--
 kernel/irq/pm.c        |    2 +-
 kernel/irq/settings.h  |    2 ++
 5 files changed, 7 insertions(+), 4 deletions(-)

Index: linux-2.6-tip/include/linux/irq.h
===================================================================
--- linux-2.6-tip.orig/include/linux/irq.h
+++ linux-2.6-tip/include/linux/irq.h
@@ -65,7 +65,6 @@ typedef	void (*irq_flow_handler_t)(unsig
 #define IRQ_NOPROBE		0x00020000	/* IRQ is not valid for probing */
 #define IRQ_NOREQUEST		0x00040000	/* IRQ cannot be requested */
 #define IRQ_NOAUTOEN		0x00080000	/* IRQ will not be enabled on request irq */
-#define IRQ_WAKEUP		0x00100000	/* IRQ triggers system wakeup */
 #define IRQ_MOVE_PENDING	0x00200000	/* need to re-target IRQ destination */
 #define IRQ_NO_BALANCING	0x00400000	/* IRQ is excluded from balancing */
 #define IRQ_MOVE_PCNTXT		0x01000000	/* IRQ migration from process context */
Index: linux-2.6-tip/kernel/irq/internals.h
===================================================================
--- linux-2.6-tip.orig/kernel/irq/internals.h
+++ linux-2.6-tip/kernel/irq/internals.h
@@ -45,6 +45,7 @@ enum {
  * IRQS_PENDING			- irq is pending and replayed later
  * IRQS_MASKED			- irq is masked
  * IRQS_SUSPENDED		- irq is suspended
+ * IRQS_WAKEUP			- irq triggers system wakeup from suspend
  */
 enum {
 	IRQS_AUTODETECT		= 0x00000001,
@@ -59,6 +60,7 @@ enum {
 	IRQS_PENDING		= 0x00000200,
 	IRQS_MASKED		= 0x00000400,
 	IRQS_SUSPENDED		= 0x00000800,
+	IRQS_WAKEUP		= 0x00001000,
 };
 
 #define irq_data_to_desc(data)	container_of(data, struct irq_desc, irq_data)
Index: linux-2.6-tip/kernel/irq/manage.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/manage.c
+++ linux-2.6-tip/kernel/irq/manage.c
@@ -496,7 +496,7 @@ int set_irq_wake(unsigned int irq, unsig
 			if (ret)
 				desc->wake_depth = 0;
 			else
-				desc->status |= IRQ_WAKEUP;
+				desc->istate |= IRQS_WAKEUP;
 		}
 	} else {
 		if (desc->wake_depth == 0) {
@@ -506,7 +506,7 @@ int set_irq_wake(unsigned int irq, unsig
 			if (ret)
 				desc->wake_depth = 1;
 			else
-				desc->status &= ~IRQ_WAKEUP;
+				desc->istate &= ~IRQS_WAKEUP;
 		}
 	}
 
Index: linux-2.6-tip/kernel/irq/pm.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/pm.c
+++ linux-2.6-tip/kernel/irq/pm.c
@@ -69,7 +69,7 @@ int check_wakeup_irqs(void)
 	int irq;
 
 	for_each_irq_desc(irq, desc)
-		if ((desc->status & IRQ_WAKEUP) &&
+		if ((desc->istate & IRQS_WAKEUP) &&
 		    (desc->istate & IRQS_PENDING))
 			return -EBUSY;
 
Index: linux-2.6-tip/kernel/irq/settings.h
===================================================================
--- linux-2.6-tip.orig/kernel/irq/settings.h
+++ linux-2.6-tip/kernel/irq/settings.h
@@ -18,3 +18,5 @@ enum {
 #define IRQ_PENDING		GOT_YOU_MORON
 #undef IRQ_MASKED
 #define IRQ_MASKED		GOT_YOU_MORON
+#undef IRQ_WAKEUP
+#define IRQ_WAKEUP		GOT_YOU_MORON


