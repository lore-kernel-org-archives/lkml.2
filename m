Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932136Ab1BJXgn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 18:36:43 -0500
Received: from www.tglx.de ([62.245.132.106]:44012 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757421Ab1BJXgi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 18:36:38 -0500
Message-Id: <20110210223255.861337689@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 10 Feb 2011 23:36:26 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [patch 16/75] genirq: Remove default magic
References: <20110210222908.661199947@linutronix.de>
Content-Disposition: inline; filename=genirq-remove-default-hackery.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that everything uses the wrappers, we can remove the default
functions. None of those functions is performance critical.

That makes the IRQ_MASKED flag tracking fully consistent.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/irq/chip.c   |   73 ++++++++++------------------------------------------
 kernel/irq/manage.c |    4 +-
 2 files changed, 17 insertions(+), 60 deletions(-)

Index: linux-2.6-tip/kernel/irq/chip.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/chip.c
+++ linux-2.6-tip/kernel/irq/chip.c
@@ -206,45 +206,29 @@ void irq_shutdown(struct irq_desc *desc)
 {
 	desc->status |= IRQ_MASKED | IRQ_DISABLED;
 	desc->depth = 1;
-	desc->irq_data.chip->irq_shutdown(&desc->irq_data);
+	if (desc->irq_data.chip->irq_shutdown)
+		desc->irq_data.chip->irq_shutdown(&desc->irq_data);
+	if (desc->irq_data.chip->irq_disable)
+		desc->irq_data.chip->irq_disable(&desc->irq_data);
+	else
+		desc->irq_data.chip->irq_mask(&desc->irq_data);
 }
 
 void irq_enable(struct irq_desc *desc)
 {
-	desc->irq_data.chip->irq_enable(&desc->irq_data);
-}
-
-void irq_disable(struct irq_desc *desc)
-{
-	desc->irq_data.chip->irq_disable(&desc->irq_data);
-}
-
-/*
- * default enable function
- */
-static void default_enable(struct irq_data *data)
-{
-	struct irq_desc *desc = irq_data_to_desc(data);
-
-	desc->irq_data.chip->irq_unmask(&desc->irq_data);
+	if (desc->irq_data.chip->irq_enable)
+		desc->irq_data.chip->irq_enable(&desc->irq_data);
+	else
+		desc->irq_data.chip->irq_unmask(&desc->irq_data);
 	desc->status &= ~IRQ_MASKED;
 }
 
-/*
- * default disable function
- */
-static void default_disable(struct irq_data *data)
-{
-}
-
-/*
- * default shutdown function
- */
-static void default_shutdown(struct irq_data *data)
+void irq_disable(struct irq_desc *desc)
 {
-	struct irq_desc *desc = irq_data_to_desc(data);
-
-	desc->irq_data.chip->irq_mask(&desc->irq_data);
+	if (desc->irq_data.chip->irq_disable) {
+		desc->irq_data.chip->irq_disable(&desc->irq_data);
+		desc->status |= IRQ_MASKED;
+	}
 }
 
 #ifndef CONFIG_GENERIC_HARDIRQS_NO_DEPRECATED
@@ -332,10 +316,6 @@ static void compat_bus_sync_unlock(struc
 void irq_chip_set_defaults(struct irq_chip *chip)
 {
 #ifndef CONFIG_GENERIC_HARDIRQS_NO_DEPRECATED
-	/*
-	 * Compat fixup functions need to be before we set the
-	 * defaults for enable/disable/startup/shutdown
-	 */
 	if (chip->enable)
 		chip->irq_enable = compat_irq_enable;
 	if (chip->disable)
@@ -344,31 +324,8 @@ void irq_chip_set_defaults(struct irq_ch
 		chip->irq_shutdown = compat_irq_shutdown;
 	if (chip->startup)
 		chip->irq_startup = compat_irq_startup;
-#endif
-	/*
-	 * The real defaults
-	 */
-	if (!chip->irq_enable)
-		chip->irq_enable = default_enable;
-	if (!chip->irq_disable)
-		chip->irq_disable = default_disable;
-	/*
-	 * We use chip->irq_disable, when the user provided its own. When
-	 * we have default_disable set for chip->irq_disable, then we need
-	 * to use default_shutdown, otherwise the irq line is not
-	 * disabled on free_irq():
-	 */
-	if (!chip->irq_shutdown)
-		chip->irq_shutdown = chip->irq_disable != default_disable ?
-			chip->irq_disable : default_shutdown;
-
-#ifndef CONFIG_GENERIC_HARDIRQS_NO_DEPRECATED
 	if (!chip->end)
 		chip->end = dummy_irq_chip.end;
-
-	/*
-	 * Now fix up the remaining compat handlers
-	 */
 	if (chip->bus_lock)
 		chip->irq_bus_lock = compat_bus_lock;
 	if (chip->bus_sync_unlock)
Index: linux-2.6-tip/kernel/irq/manage.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/manage.c
+++ linux-2.6-tip/kernel/irq/manage.c
@@ -448,8 +448,8 @@ void enable_irq(unsigned int irq)
 	if (!desc)
 		return;
 
-	if (WARN(!desc->irq_data.chip || !desc->irq_data.chip->irq_enable,
-	    KERN_ERR "enable_irq before setup/request_irq: irq %u\n", irq))
+	if (WARN(!desc->irq_data.chip,
+		 KERN_ERR "enable_irq before setup/request_irq: irq %u\n", irq))
 		return;
 
 	chip_bus_lock(desc);


