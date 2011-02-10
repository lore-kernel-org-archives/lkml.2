Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757436Ab1BJXgh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 18:36:37 -0500
Received: from www.tglx.de ([62.245.132.106]:43988 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757421Ab1BJXgd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 18:36:33 -0500
Message-Id: <20110210223255.673599446@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 10 Feb 2011 23:36:22 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [patch 14/75] genirq: Consolidate startup/shutdown of interrupts
References: <20110210222908.661199947@linutronix.de>
Content-Disposition: inline;
	filename=genirq-consolidate-startup-shutdown-of-interrupts.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Aside of duplicated code some of the startup/shutdown sites do not
handle the MASKED/DISABLED flags and the depth field at all. Move that
to a helper function and take care of it there.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <20110202212551.787481468@linutronix.de>
---
 kernel/irq/autoprobe.c |   10 +++++-----
 kernel/irq/chip.c      |   37 ++++++++++++++++++++-----------------
 kernel/irq/internals.h |    3 +++
 kernel/irq/manage.c    |   14 +++++---------
 4 files changed, 33 insertions(+), 31 deletions(-)

Index: linux-2.6-tip/kernel/irq/autoprobe.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/autoprobe.c
+++ linux-2.6-tip/kernel/irq/autoprobe.c
@@ -60,7 +60,7 @@ unsigned long probe_irq_on(void)
 			if (desc->irq_data.chip->irq_set_type)
 				desc->irq_data.chip->irq_set_type(&desc->irq_data,
 							 IRQ_TYPE_PROBE);
-			desc->irq_data.chip->irq_startup(&desc->irq_data);
+			irq_startup(desc);
 		}
 		raw_spin_unlock_irq(&desc->lock);
 	}
@@ -77,7 +77,7 @@ unsigned long probe_irq_on(void)
 		raw_spin_lock_irq(&desc->lock);
 		if (!desc->action && !(desc->status & IRQ_NOPROBE)) {
 			desc->status |= IRQ_AUTODETECT | IRQ_WAITING;
-			if (desc->irq_data.chip->irq_startup(&desc->irq_data))
+			if (irq_startup(desc))
 				desc->status |= IRQ_PENDING;
 		}
 		raw_spin_unlock_irq(&desc->lock);
@@ -99,7 +99,7 @@ unsigned long probe_irq_on(void)
 			/* It triggered already - consider it spurious. */
 			if (!(status & IRQ_WAITING)) {
 				desc->status = status & ~IRQ_AUTODETECT;
-				desc->irq_data.chip->irq_shutdown(&desc->irq_data);
+				irq_shutdown(desc);
 			} else
 				if (i < 32)
 					mask |= 1 << i;
@@ -138,7 +138,7 @@ unsigned int probe_irq_mask(unsigned lon
 				mask |= 1 << i;
 
 			desc->status = status & ~IRQ_AUTODETECT;
-			desc->irq_data.chip->irq_shutdown(&desc->irq_data);
+			irq_shutdown(desc);
 		}
 		raw_spin_unlock_irq(&desc->lock);
 	}
@@ -182,7 +182,7 @@ int probe_irq_off(unsigned long val)
 				nr_of_irqs++;
 			}
 			desc->status = status & ~IRQ_AUTODETECT;
-			desc->irq_data.chip->irq_shutdown(&desc->irq_data);
+			irq_shutdown(desc);
 		}
 		raw_spin_unlock_irq(&desc->lock);
 	}
Index: linux-2.6-tip/kernel/irq/chip.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/chip.c
+++ linux-2.6-tip/kernel/irq/chip.c
@@ -190,6 +190,25 @@ void set_irq_nested_thread(unsigned int 
 }
 EXPORT_SYMBOL_GPL(set_irq_nested_thread);
 
+int irq_startup(struct irq_desc *desc)
+{
+	desc->status &= ~(IRQ_MASKED | IRQ_DISABLED);
+	desc->depth = 0;
+
+	if (desc->irq_data.chip->irq_startup)
+		return desc->irq_data.chip->irq_startup(&desc->irq_data);
+
+	desc->irq_data.chip->irq_enable(&desc->irq_data);
+	return 0;
+}
+
+void irq_shutdown(struct irq_desc *desc)
+{
+	desc->status |= IRQ_MASKED | IRQ_DISABLED;
+	desc->depth = 1;
+	desc->irq_data.chip->irq_shutdown(&desc->irq_data);
+}
+
 /*
  * default enable function
  */
@@ -209,17 +228,6 @@ static void default_disable(struct irq_d
 }
 
 /*
- * default startup function
- */
-static unsigned int default_startup(struct irq_data *data)
-{
-	struct irq_desc *desc = irq_data_to_desc(data);
-
-	desc->irq_data.chip->irq_enable(data);
-	return 0;
-}
-
-/*
  * default shutdown function
  */
 static void default_shutdown(struct irq_data *data)
@@ -227,7 +235,6 @@ static void default_shutdown(struct irq_
 	struct irq_desc *desc = irq_data_to_desc(data);
 
 	desc->irq_data.chip->irq_mask(&desc->irq_data);
-	desc->status |= IRQ_MASKED;
 }
 
 #ifndef CONFIG_GENERIC_HARDIRQS_NO_DEPRECATED
@@ -335,8 +342,6 @@ void irq_chip_set_defaults(struct irq_ch
 		chip->irq_enable = default_enable;
 	if (!chip->irq_disable)
 		chip->irq_disable = default_disable;
-	if (!chip->irq_startup)
-		chip->irq_startup = default_startup;
 	/*
 	 * We use chip->irq_disable, when the user provided its own. When
 	 * we have default_disable set for chip->irq_disable, then we need
@@ -745,10 +750,8 @@ __set_irq_handler(unsigned int irq, irq_
 	desc->name = name;
 
 	if (handle != handle_bad_irq && is_chained) {
-		desc->status &= ~IRQ_DISABLED;
 		desc->status |= IRQ_NOREQUEST | IRQ_NOPROBE;
-		desc->depth = 0;
-		desc->irq_data.chip->irq_startup(&desc->irq_data);
+		irq_startup(desc);
 	}
 	raw_spin_unlock_irqrestore(&desc->lock, flags);
 	chip_bus_sync_unlock(desc);
Index: linux-2.6-tip/kernel/irq/internals.h
===================================================================
--- linux-2.6-tip.orig/kernel/irq/internals.h
+++ linux-2.6-tip/kernel/irq/internals.h
@@ -32,6 +32,9 @@ extern int __irq_set_trigger(struct irq_
 extern void __disable_irq(struct irq_desc *desc, unsigned int irq, bool susp);
 extern void __enable_irq(struct irq_desc *desc, unsigned int irq, bool resume);
 
+extern int irq_startup(struct irq_desc *desc);
+extern void irq_shutdown(struct irq_desc *desc);
+
 extern void init_kstat_irqs(struct irq_desc *desc, int node, int nr);
 
 /* Resending of interrupts :*/
Index: linux-2.6-tip/kernel/irq/manage.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/manage.c
+++ linux-2.6-tip/kernel/irq/manage.c
@@ -912,11 +912,9 @@ __setup_irq(unsigned int irq, struct irq
 		if (new->flags & IRQF_ONESHOT)
 			desc->status |= IRQ_ONESHOT;
 
-		if (!(desc->status & IRQ_NOAUTOEN)) {
-			desc->depth = 0;
-			desc->status &= ~IRQ_DISABLED;
-			desc->irq_data.chip->irq_startup(&desc->irq_data);
-		} else
+		if (!(desc->status & IRQ_NOAUTOEN))
+			irq_startup(desc);
+		else
 			/* Undo nested disables: */
 			desc->depth = 1;
 
@@ -1056,10 +1054,8 @@ static struct irqaction *__free_irq(unsi
 #endif
 
 	/* If this was the last handler, shut down the IRQ line: */
-	if (!desc->action) {
-		desc->status |= IRQ_DISABLED;
-		desc->irq_data.chip->irq_shutdown(&desc->irq_data);
-	}
+	if (!desc->action)
+		irq_shutdown(desc);
 
 #ifdef CONFIG_SMP
 	/* make sure affinity_hint is cleaned up */


