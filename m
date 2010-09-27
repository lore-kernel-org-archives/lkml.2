Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932692Ab0I0MpT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 08:45:19 -0400
Received: from www.tglx.de ([62.245.132.106]:34573 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759208Ab0I0MpM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 08:45:12 -0400
Message-Id: <20100927121842.437159182@linutronix.de>
User-Agent: quilt/0.48-1
Date: Mon, 27 Sep 2010 12:44:56 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-arch@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [patch 10/19] genirq; Provide compat handling for chip->enable()
References: <20100927121651.904100669@linutronix.de>
Content-Disposition: inline; filename=genirq-wrap-chip-enable.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wrap the old chip function enable() until the migration is complete and
the old chip functions are removed.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/irq/chip.c   |   25 ++++++++++++++++++++-----
 kernel/irq/resend.c |    2 +-
 2 files changed, 21 insertions(+), 6 deletions(-)
Index: linux-2.6-tip/kernel/irq/chip.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/chip.c
+++ linux-2.6-tip/kernel/irq/chip.c
@@ -290,9 +290,9 @@ EXPORT_SYMBOL_GPL(set_irq_nested_thread)
 /*
  * default enable function
  */
-static void default_enable(unsigned int irq)
+static void default_enable(struct irq_data *data)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
+	struct irq_desc *desc = irq_data_to_desc(data);
 
 	desc->chip->irq_unmask(&desc->irq_data);
 	desc->status &= ~IRQ_MASKED;
@@ -312,7 +312,7 @@ static unsigned int default_startup(unsi
 {
 	struct irq_desc *desc = irq_to_desc(irq);
 
-	desc->chip->enable(irq);
+	desc->chip->irq_enable(&desc->irq_data);
 	return 0;
 }
 
@@ -353,6 +353,11 @@ static void compat_irq_eoi(struct irq_da
 	irq_data_to_desc(data)->chip->eoi(data->irq);
 }
 
+static void compat_irq_enable(struct irq_data *data)
+{
+	irq_data_to_desc(data)->chip->enable(data->irq);
+}
+
 static void compat_bus_lock(struct irq_data *data)
 {
 	irq_data_to_desc(data)->chip->bus_lock(data->irq);
@@ -368,8 +373,18 @@ static void compat_bus_sync_unlock(struc
  */
 void irq_chip_set_defaults(struct irq_chip *chip)
 {
-	if (!chip->enable)
-		chip->enable = default_enable;
+	/*
+	 * Compat fixup functions need to be before we set the
+	 * defaults for enable/disable/startup/shutdown
+	 */
+	if (chip->enable)
+		chip->irq_enable = compat_irq_enable;
+
+	/*
+	 * The real defaults
+	 */
+	if (!chip->irq_enable)
+		chip->irq_enable = default_enable;
 	if (!chip->disable)
 		chip->disable = default_disable;
 	if (!chip->startup)
Index: linux-2.6-tip/kernel/irq/resend.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/resend.c
+++ linux-2.6-tip/kernel/irq/resend.c
@@ -60,7 +60,7 @@ void check_irq_resend(struct irq_desc *d
 	/*
 	 * Make sure the interrupt is enabled, before resending it:
 	 */
-	desc->chip->enable(irq);
+	desc->chip->irq_enable(&desc->irq_data);
 
 	/*
 	 * We do not resend level type interrupts. Level type


