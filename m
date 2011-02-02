Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754613Ab1BBVmv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 16:42:51 -0500
Received: from www.tglx.de ([62.245.132.106]:38856 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753739Ab1BBVlV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 16:41:21 -0500
Message-Id: <20110202212551.787481468@linutronix.de>
User-Agent: quilt/0.48-1
Date: Wed, 02 Feb 2011 21:41:14 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [patch 2/8] genirq: Consolidate startup/shutdown of interrupts
References: <20110202212258.546660886@linutronix.de>
Content-Disposition: inline;
	filename=genirq-clear-IRQ_MASKED-flag-in-startup.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Aside of duplicated code some of the startup/shutdown sites do not
handle the MASKED/DISABLED flags and the depth field at all. Move that
to a helper function and take care of it there.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/irq/autoprobe.c |   10 +++++-----
 kernel/irq/chip.c      |   18 +++++++++++++++---
 kernel/irq/internals.h |    3 +++
 kernel/irq/manage.c    |   14 +++++---------
 4 files changed, 28 insertions(+), 17 deletions(-)

Index: linux-2.6-tip/kernel/irq/autoprobe.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/autoprobe.c
+++ linux-2.6-tip/kernel/irq/autoprobe.c
@@ -60,7 +60,7 @@ unsigned long probe_irq_on(void)
 			if (desc->irq_data.chip->irq_set_type)
 				desc->irq_data.chip->irq_set_type(&desc->irq_data,
 							 IRQ_TYPE_PROBE);
-			desc->irq_data.chip->irq_startup(&desc->irq_data);
+			startup_irq(desc);
 		}
 		raw_spin_unlock_irq(&desc->lock);
 	}
@@ -77,7 +77,7 @@ unsigned long probe_irq_on(void)
 		raw_spin_lock_irq(&desc->lock);
 		if (!desc->action && !(desc->status & IRQ_NOPROBE)) {
 			desc->status |= IRQ_AUTODETECT | IRQ_WAITING;
-			if (desc->irq_data.chip->irq_startup(&desc->irq_data))
+			if (startup_irq(desc))
 				desc->status |= IRQ_PENDING;
 		}
 		raw_spin_unlock_irq(&desc->lock);
@@ -99,7 +99,7 @@ unsigned long probe_irq_on(void)
 			/* It triggered already - consider it spurious. */
 			if (!(status & IRQ_WAITING)) {
 				desc->status = status & ~IRQ_AUTODETECT;
-				desc->irq_data.chip->irq_shutdown(&desc->irq_data);
+				shutdown_irq(desc);
 			} else
 				if (i < 32)
 					mask |= 1 << i;
@@ -138,7 +138,7 @@ unsigned int probe_irq_mask(unsigned lon
 				mask |= 1 << i;
 
 			desc->status = status & ~IRQ_AUTODETECT;
-			desc->irq_data.chip->irq_shutdown(&desc->irq_data);
+			shutdown_irq(desc);
 		}
 		raw_spin_unlock_irq(&desc->lock);
 	}
@@ -182,7 +182,7 @@ int probe_irq_off(unsigned long val)
 				nr_of_irqs++;
 			}
 			desc->status = status & ~IRQ_AUTODETECT;
-			desc->irq_data.chip->irq_shutdown(&desc->irq_data);
+			shutdown_irq(desc);
 		}
 		raw_spin_unlock_irq(&desc->lock);
 	}
Index: linux-2.6-tip/kernel/irq/chip.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/chip.c
+++ linux-2.6-tip/kernel/irq/chip.c
@@ -190,6 +190,20 @@ void set_irq_nested_thread(unsigned int 
 }
 EXPORT_SYMBOL_GPL(set_irq_nested_thread);
 
+int startup_irq(struct irq_desc *desc)
+{
+	desc->status &= ~(IRQ_MASKED | IRQ_DISABLED);
+	desc->depth = 0;
+	return desc->irq_data.chip->irq_startup(&desc->irq_data);
+}
+
+void shutdown_irq(struct irq_desc *desc)
+{
+	desc->status |= IRQ_MASKED | IRQ_DISABLED;
+	desc->depth = 1;
+	desc->irq_data.chip->irq_shutdown(&desc->irq_data);
+}
+
 /*
  * default enable function
  */
@@ -731,10 +745,8 @@ __set_irq_handler(unsigned int irq, irq_
 	desc->name = name;
 
 	if (handle != handle_bad_irq && is_chained) {
-		desc->status &= ~IRQ_DISABLED;
 		desc->status |= IRQ_NOREQUEST | IRQ_NOPROBE;
-		desc->depth = 0;
-		desc->irq_data.chip->irq_startup(&desc->irq_data);
+		startup_irq(desc);
 	}
 	raw_spin_unlock_irqrestore(&desc->lock, flags);
 	chip_bus_sync_unlock(desc);
Index: linux-2.6-tip/kernel/irq/internals.h
===================================================================
--- linux-2.6-tip.orig/kernel/irq/internals.h
+++ linux-2.6-tip/kernel/irq/internals.h
@@ -18,6 +18,9 @@ extern int __irq_set_trigger(struct irq_
 extern void __disable_irq(struct irq_desc *desc, unsigned int irq, bool susp);
 extern void __enable_irq(struct irq_desc *desc, unsigned int irq, bool resume);
 
+extern int startup_irq(struct irq_desc *desc);
+extern void shutdown_irq(struct irq_desc *desc);
+
 extern void init_kstat_irqs(struct irq_desc *desc, int node, int nr);
 
 /* Resending of interrupts :*/
Index: linux-2.6-tip/kernel/irq/manage.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/manage.c
+++ linux-2.6-tip/kernel/irq/manage.c
@@ -860,11 +860,9 @@ __setup_irq(unsigned int irq, struct irq
 		if (new->flags & IRQF_ONESHOT)
 			desc->status |= IRQ_ONESHOT;
 
-		if (!(desc->status & IRQ_NOAUTOEN)) {
-			desc->depth = 0;
-			desc->status &= ~IRQ_DISABLED;
-			desc->irq_data.chip->irq_startup(&desc->irq_data);
-		} else
+		if (!(desc->status & IRQ_NOAUTOEN))
+			startup_irq(desc);
+		else
 			/* Undo nested disables: */
 			desc->depth = 1;
 
@@ -1001,10 +999,8 @@ static struct irqaction *__free_irq(unsi
 #endif
 
 	/* If this was the last handler, shut down the IRQ line: */
-	if (!desc->action) {
-		desc->status |= IRQ_DISABLED;
-		desc->irq_data.chip->irq_shutdown(&desc->irq_data);
-	}
+	if (!desc->action)
+		shutdown_irq(desc);
 
 #ifdef CONFIG_SMP
 	/* make sure affinity_hint is cleaned up */


