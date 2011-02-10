Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932515Ab1BJXlo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 18:41:44 -0500
Received: from www.tglx.de ([62.245.132.106]:44493 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932391Ab1BJXi0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 18:38:26 -0500
Message-Id: <20110210223300.474949122@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 10 Feb 2011 23:38:20 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [patch 64/75] genirq: Move wakeup state to irq_data
References: <20110210222908.661199947@linutronix.de>
Content-Disposition: inline;
	filename=genirq-move-wakeup-state-to-irq-data.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some irq_chips need to know the state of wakeup mode for
setting the trigger type etc. Reflect it in irq_data state.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/irq.h    |    8 ++++++++
 kernel/irq/internals.h |    2 --
 kernel/irq/manage.c    |    4 ++--
 kernel/irq/pm.c        |    2 +-
 4 files changed, 11 insertions(+), 5 deletions(-)

Index: linux-2.6-tip/include/linux/irq.h
===================================================================
--- linux-2.6-tip.orig/include/linux/irq.h
+++ linux-2.6-tip/include/linux/irq.h
@@ -165,6 +165,8 @@ struct irq_data {
  * IRQD_PER_CPU			- Interrupt is per cpu
  * IRQD_AFFINITY_SET		- Interrupt affinity was set
  * IRQD_LEVEL			- Interrupt is level triggered
+ * IRQD_WAKEUP_STATE		- Interrupt is configured for wakeup
+ *				  from suspend
  */
 enum {
 	IRQD_TRIGGER_MASK		= 0xf,
@@ -173,6 +175,7 @@ enum {
 	IRQD_PER_CPU			= (1 << 11),
 	IRQD_AFFINITY_SET		= (1 << 12),
 	IRQD_LEVEL			= (1 << 13),
+	IRQD_WAKEUP_STATE		= (1 << 14),
 };
 
 static inline bool irqd_is_setaffinity_pending(struct irq_data *d)
@@ -214,6 +217,11 @@ static inline bool irqd_is_level_type(st
 	return d->state_use_accessors & IRQD_LEVEL;
 }
 
+static inline bool irqd_is_wakeup_set(struct irq_data *d)
+{
+	return d->state_use_accessors & IRQD_WAKEUP_STATE;
+}
+
 /**
  * struct irq_chip - hardware interrupt chip descriptor
  *
Index: linux-2.6-tip/kernel/irq/internals.h
===================================================================
--- linux-2.6-tip.orig/kernel/irq/internals.h
+++ linux-2.6-tip/kernel/irq/internals.h
@@ -42,7 +42,6 @@ enum {
  * IRQS_PENDING			- irq is pending and replayed later
  * IRQS_MASKED			- irq is masked
  * IRQS_SUSPENDED		- irq is suspended
- * IRQS_WAKEUP			- irq triggers system wakeup from suspend
  */
 enum {
 	IRQS_AUTODETECT		= 0x00000001,
@@ -57,7 +56,6 @@ enum {
 	IRQS_PENDING		= 0x00000200,
 	IRQS_MASKED		= 0x00000400,
 	IRQS_SUSPENDED		= 0x00000800,
-	IRQS_WAKEUP		= 0x00001000,
 };
 
 #include "compat.h"
Index: linux-2.6-tip/kernel/irq/manage.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/manage.c
+++ linux-2.6-tip/kernel/irq/manage.c
@@ -499,7 +499,7 @@ int set_irq_wake(unsigned int irq, unsig
 			if (ret)
 				desc->wake_depth = 0;
 			else
-				desc->istate |= IRQS_WAKEUP;
+				irqd_set(&desc->irq_data, IRQD_WAKEUP_STATE);
 		}
 	} else {
 		if (desc->wake_depth == 0) {
@@ -509,7 +509,7 @@ int set_irq_wake(unsigned int irq, unsig
 			if (ret)
 				desc->wake_depth = 1;
 			else
-				desc->istate &= ~IRQS_WAKEUP;
+				irqd_clear(&desc->irq_data, IRQD_WAKEUP_STATE);
 		}
 	}
 
Index: linux-2.6-tip/kernel/irq/pm.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/pm.c
+++ linux-2.6-tip/kernel/irq/pm.c
@@ -69,7 +69,7 @@ int check_wakeup_irqs(void)
 	int irq;
 
 	for_each_irq_desc(irq, desc)
-		if ((desc->istate & IRQS_WAKEUP) &&
+		if (irqd_is_wakeup_set(&desc->irq_data) &&
 		    (desc->istate & IRQS_PENDING))
 			return -EBUSY;
 


