Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759306Ab0I0MsS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 08:48:18 -0400
Received: from www.tglx.de ([62.245.132.106]:34631 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759214Ab0I0Mpx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 08:45:53 -0400
Message-Id: <20100927121842.532070631@linutronix.de>
User-Agent: quilt/0.48-1
Date: Mon, 27 Sep 2010 12:45:02 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-arch@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [patch 11/19] genirq;
	Provide compat handling for chip->disable()/shutdown()
References: <20100927121651.904100669@linutronix.de>
Content-Disposition: inline; filename=genirq-wrap-chip-disable.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wrap the old chip functions disable() and shutdown() until the
migration is complete and the old chip functions are removed.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/irq/autoprobe.c |    6 +++---
 kernel/irq/chip.c      |   37 +++++++++++++++++++++++++++----------
 kernel/irq/manage.c    |    8 ++++----
 kernel/irq/spurious.c  |    2 +-
 4 files changed, 35 insertions(+), 18 deletions(-)

Index: linux-2.6-tip/kernel/irq/autoprobe.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/autoprobe.c
+++ linux-2.6-tip/kernel/irq/autoprobe.c
@@ -98,7 +98,7 @@ unsigned long probe_irq_on(void)
 			/* It triggered already - consider it spurious. */
 			if (!(status & IRQ_WAITING)) {
 				desc->status = status & ~IRQ_AUTODETECT;
-				desc->chip->shutdown(i);
+				desc->chip->irq_shutdown(&desc->irq_data);
 			} else
 				if (i < 32)
 					mask |= 1 << i;
@@ -137,7 +137,7 @@ unsigned int probe_irq_mask(unsigned lon
 				mask |= 1 << i;
 
 			desc->status = status & ~IRQ_AUTODETECT;
-			desc->chip->shutdown(i);
+			desc->chip->irq_shutdown(&desc->irq_data);
 		}
 		raw_spin_unlock_irq(&desc->lock);
 	}
@@ -181,7 +181,7 @@ int probe_irq_off(unsigned long val)
 				nr_of_irqs++;
 			}
 			desc->status = status & ~IRQ_AUTODETECT;
-			desc->chip->shutdown(i);
+			desc->chip->irq_shutdown(&desc->irq_data);
 		}
 		raw_spin_unlock_irq(&desc->lock);
 	}
Index: linux-2.6-tip/kernel/irq/chip.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/chip.c
+++ linux-2.6-tip/kernel/irq/chip.c
@@ -301,7 +301,7 @@ static void default_enable(struct irq_da
 /*
  * default disable function
  */
-static void default_disable(unsigned int irq)
+static void default_disable(struct irq_data *data)
 {
 }
 
@@ -319,9 +319,9 @@ static unsigned int default_startup(unsi
 /*
  * default shutdown function
  */
-static void default_shutdown(unsigned int irq)
+static void default_shutdown(struct irq_data *data)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
+	struct irq_desc *desc = irq_data_to_desc(data);
 
 	desc->chip->irq_mask(&desc->irq_data);
 	desc->status |= IRQ_MASKED;
@@ -358,6 +358,16 @@ static void compat_irq_enable(struct irq
 	irq_data_to_desc(data)->chip->enable(data->irq);
 }
 
+static void compat_irq_disable(struct irq_data *data)
+{
+	irq_data_to_desc(data)->chip->disable(data->irq);
+}
+
+static void compat_irq_shutdown(struct irq_data *data)
+{
+	irq_data_to_desc(data)->chip->shutdown(data->irq);
+}
+
 static void compat_bus_lock(struct irq_data *data)
 {
 	irq_data_to_desc(data)->chip->bus_lock(data->irq);
@@ -379,28 +389,35 @@ void irq_chip_set_defaults(struct irq_ch
 	 */
 	if (chip->enable)
 		chip->irq_enable = compat_irq_enable;
+	if (chip->disable)
+		chip->irq_disable = compat_irq_disable;
+	if (chip->shutdown)
+		chip->irq_shutdown = compat_irq_shutdown;
 
 	/*
 	 * The real defaults
 	 */
 	if (!chip->irq_enable)
 		chip->irq_enable = default_enable;
-	if (!chip->disable)
-		chip->disable = default_disable;
+	if (!chip->irq_disable)
+		chip->irq_disable = default_disable;
 	if (!chip->startup)
 		chip->startup = default_startup;
 	/*
-	 * We use chip->disable, when the user provided its own. When
-	 * we have default_disable set for chip->disable, then we need
+	 * We use chip->irq_disable, when the user provided its own. When
+	 * we have default_disable set for chip->irq_disable, then we need
 	 * to use default_shutdown, otherwise the irq line is not
 	 * disabled on free_irq():
 	 */
-	if (!chip->shutdown)
-		chip->shutdown = chip->disable != default_disable ?
-			chip->disable : default_shutdown;
+	if (!chip->irq_shutdown)
+		chip->irq_shutdown = chip->irq_disable != default_disable ?
+			chip->irq_disable : default_shutdown;
 	if (!chip->end)
 		chip->end = dummy_irq_chip.end;
 
+	/*
+	 * Now fix up the remaining compat handlers
+	 */
 	if (chip->bus_lock)
 		chip->irq_bus_lock = compat_bus_lock;
 	if (chip->bus_sync_unlock)
Index: linux-2.6-tip/kernel/irq/manage.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/manage.c
+++ linux-2.6-tip/kernel/irq/manage.c
@@ -223,7 +223,7 @@ void __disable_irq(struct irq_desc *desc
 
 	if (!desc->depth++) {
 		desc->status |= IRQ_DISABLED;
-		desc->chip->disable(irq);
+		desc->chip->irq_disable(&desc->irq_data);
 	}
 }
 
@@ -919,10 +919,10 @@ static struct irqaction *__free_irq(unsi
 	/* If this was the last handler, shut down the IRQ line: */
 	if (!desc->action) {
 		desc->status |= IRQ_DISABLED;
-		if (desc->chip->shutdown)
-			desc->chip->shutdown(irq);
+		if (desc->chip->irq_shutdown)
+			desc->chip->irq_shutdown(&desc->irq_data);
 		else
-			desc->chip->disable(irq);
+			desc->chip->irq_disable(&desc->irq_data);
 	}
 
 #ifdef CONFIG_SMP
Index: linux-2.6-tip/kernel/irq/spurious.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/spurious.c
+++ linux-2.6-tip/kernel/irq/spurious.c
@@ -254,7 +254,7 @@ void note_interrupt(unsigned int irq, st
 		printk(KERN_EMERG "Disabling IRQ #%d\n", irq);
 		desc->status |= IRQ_DISABLED | IRQ_SPURIOUS_DISABLED;
 		desc->depth++;
-		desc->chip->disable(irq);
+		desc->chip->irq_disable(&desc->irq_data);
 
 		mod_timer(&poll_spurious_irq_timer,
 			  jiffies + POLL_SPURIOUS_IRQ_INTERVAL);


