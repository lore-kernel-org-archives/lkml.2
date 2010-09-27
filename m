Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759321Ab0I0Msb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 08:48:31 -0400
Received: from www.tglx.de ([62.245.132.106]:34630 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759212Ab0I0Mpx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 08:45:53 -0400
Message-Id: <20100927121842.635152961@linutronix.de>
User-Agent: quilt/0.48-1
Date: Mon, 27 Sep 2010 12:45:38 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-arch@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [patch 12/19] genirq; Provide compat handling for chip->startup()
References: <20100927121651.904100669@linutronix.de>
Content-Disposition: inline; filename=genirq-wrap-chip-startup.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wrap the old chip function startup() until the migration is complete and
the old chip functions are removed.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/irq/autoprobe.c |    4 ++--
 kernel/irq/chip.c      |   19 +++++++++++++------
 kernel/irq/manage.c    |    2 +-
 3 files changed, 16 insertions(+), 9 deletions(-)

Index: linux-2.6-tip/kernel/irq/autoprobe.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/autoprobe.c
+++ linux-2.6-tip/kernel/irq/autoprobe.c
@@ -59,7 +59,7 @@ unsigned long probe_irq_on(void)
 			 */
 			if (desc->chip->set_type)
 				desc->chip->set_type(i, IRQ_TYPE_PROBE);
-			desc->chip->startup(i);
+			desc->chip->irq_startup(&desc->irq_data);
 		}
 		raw_spin_unlock_irq(&desc->lock);
 	}
@@ -76,7 +76,7 @@ unsigned long probe_irq_on(void)
 		raw_spin_lock_irq(&desc->lock);
 		if (!desc->action && !(desc->status & IRQ_NOPROBE)) {
 			desc->status |= IRQ_AUTODETECT | IRQ_WAITING;
-			if (desc->chip->startup(i))
+			if (desc->chip->irq_startup(&desc->irq_data))
 				desc->status |= IRQ_PENDING;
 		}
 		raw_spin_unlock_irq(&desc->lock);
Index: linux-2.6-tip/kernel/irq/chip.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/chip.c
+++ linux-2.6-tip/kernel/irq/chip.c
@@ -308,11 +308,11 @@ static void default_disable(struct irq_d
 /*
  * default startup function
  */
-static unsigned int default_startup(unsigned int irq)
+static unsigned int default_startup(struct irq_data *data)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
+	struct irq_desc *desc = irq_data_to_desc(data);
 
-	desc->chip->irq_enable(&desc->irq_data);
+	desc->chip->irq_enable(data);
 	return 0;
 }
 
@@ -368,6 +368,11 @@ static void compat_irq_shutdown(struct i
 	irq_data_to_desc(data)->chip->shutdown(data->irq);
 }
 
+static unsigned int compat_irq_startup(struct irq_data *data)
+{
+	return irq_data_to_desc(data)->chip->startup(data->irq);
+}
+
 static void compat_bus_lock(struct irq_data *data)
 {
 	irq_data_to_desc(data)->chip->bus_lock(data->irq);
@@ -393,6 +398,8 @@ void irq_chip_set_defaults(struct irq_ch
 		chip->irq_disable = compat_irq_disable;
 	if (chip->shutdown)
 		chip->irq_shutdown = compat_irq_shutdown;
+	if (chip->startup)
+		chip->irq_startup = compat_irq_startup;
 
 	/*
 	 * The real defaults
@@ -401,8 +408,8 @@ void irq_chip_set_defaults(struct irq_ch
 		chip->irq_enable = default_enable;
 	if (!chip->irq_disable)
 		chip->irq_disable = default_disable;
-	if (!chip->startup)
-		chip->startup = default_startup;
+	if (!chip->irq_startup)
+		chip->irq_startup = default_startup;
 	/*
 	 * We use chip->irq_disable, when the user provided its own. When
 	 * we have default_disable set for chip->irq_disable, then we need
@@ -790,7 +797,7 @@ __set_irq_handler(unsigned int irq, irq_
 		desc->status &= ~IRQ_DISABLED;
 		desc->status |= IRQ_NOREQUEST | IRQ_NOPROBE;
 		desc->depth = 0;
-		desc->chip->startup(irq);
+		desc->chip->irq_startup(&desc->irq_data);
 	}
 	raw_spin_unlock_irqrestore(&desc->lock, flags);
 	chip_bus_sync_unlock(desc);
Index: linux-2.6-tip/kernel/irq/manage.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/manage.c
+++ linux-2.6-tip/kernel/irq/manage.c
@@ -779,7 +779,7 @@ __setup_irq(unsigned int irq, struct irq
 		if (!(desc->status & IRQ_NOAUTOEN)) {
 			desc->depth = 0;
 			desc->status &= ~IRQ_DISABLED;
-			desc->chip->startup(irq);
+			desc->chip->irq_startup(&desc->irq_data);
 		} else
 			/* Undo nested disables: */
 			desc->depth = 1;


