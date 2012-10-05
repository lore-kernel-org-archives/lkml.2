Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755516Ab2JEPcG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 11:32:06 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:61389 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755325Ab2JEPcC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 11:32:02 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 02/10] mfd: Provide the STMPE driver with its own IRQ domain
Date: Fri,  5 Oct 2012 16:31:38 +0100
Message-Id: <1349451107-8009-3-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1349451107-8009-1-git-send-email-lee.jones@linaro.org>
References: <1349451107-8009-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The STMPE driver is yet another IRQ controller which requires its
own IRQ domain. So, we provide it with one.

Cc: Samuel Ortiz <sameo@linux.intel.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/stmpe.c       |   82 +++++++++++++++++++++++++++------------------
 include/linux/mfd/stmpe.h |    2 ++
 2 files changed, 52 insertions(+), 32 deletions(-)

diff --git a/drivers/mfd/stmpe.c b/drivers/mfd/stmpe.c
index ad13cb0..5c8d8f2 100644
--- a/drivers/mfd/stmpe.c
+++ b/drivers/mfd/stmpe.c
@@ -12,6 +12,7 @@
 #include <linux/kernel.h>
 #include <linux/interrupt.h>
 #include <linux/irq.h>
+#include <linux/irqdomain.h>
 #include <linux/pm.h>
 #include <linux/slab.h>
 #include <linux/mfd/core.h>
@@ -757,7 +758,9 @@ static irqreturn_t stmpe_irq(int irq, void *data)
 	int i;
 
 	if (variant->id_val == STMPE801_ID) {
-		handle_nested_irq(stmpe->irq_base);
+		int base = irq_create_mapping(stmpe->domain, 0);
+
+		handle_nested_irq(base);
 		return IRQ_HANDLED;
 	}
 
@@ -778,8 +781,9 @@ static irqreturn_t stmpe_irq(int irq, void *data)
 		while (status) {
 			int bit = __ffs(status);
 			int line = bank * 8 + bit;
+			int nestedirq = irq_create_mapping(stmpe->domain, line);
 
-			handle_nested_irq(stmpe->irq_base + line);
+			handle_nested_irq(nestedirq);
 			status &= ~(1 << bit);
 		}
 
@@ -820,7 +824,7 @@ static void stmpe_irq_sync_unlock(struct irq_data *data)
 static void stmpe_irq_mask(struct irq_data *data)
 {
 	struct stmpe *stmpe = irq_data_get_irq_chip_data(data);
-	int offset = data->irq - stmpe->irq_base;
+	int offset = data->hwirq;
 	int regoffset = offset / 8;
 	int mask = 1 << (offset % 8);
 
@@ -830,7 +834,7 @@ static void stmpe_irq_mask(struct irq_data *data)
 static void stmpe_irq_unmask(struct irq_data *data)
 {
 	struct stmpe *stmpe = irq_data_get_irq_chip_data(data);
-	int offset = data->irq - stmpe->irq_base;
+	int offset = data->hwirq;
 	int regoffset = offset / 8;
 	int mask = 1 << (offset % 8);
 
@@ -845,43 +849,62 @@ static struct irq_chip stmpe_irq_chip = {
 	.irq_unmask		= stmpe_irq_unmask,
 };
 
-static int __devinit stmpe_irq_init(struct stmpe *stmpe)
+static int stmpe_irq_map(struct irq_domain *d, unsigned int virq,
+                                irq_hw_number_t hwirq)
 {
+	struct stmpe *stmpe = d->host_data;
 	struct irq_chip *chip = NULL;
-	int num_irqs = stmpe->variant->num_irqs;
-	int base = stmpe->irq_base;
-	int irq;
 
 	if (stmpe->variant->id_val != STMPE801_ID)
 		chip = &stmpe_irq_chip;
 
-	for (irq = base; irq < base + num_irqs; irq++) {
-		irq_set_chip_data(irq, stmpe);
-		irq_set_chip_and_handler(irq, chip, handle_edge_irq);
-		irq_set_nested_thread(irq, 1);
+	irq_set_chip_data(virq, stmpe);
+	irq_set_chip_and_handler(virq, chip, handle_edge_irq);
+	irq_set_nested_thread(virq, 1);
 #ifdef CONFIG_ARM
-		set_irq_flags(irq, IRQF_VALID);
+	set_irq_flags(virq, IRQF_VALID);
 #else
-		irq_set_noprobe(irq);
+	irq_set_noprobe(virq);
 #endif
-	}
 
 	return 0;
 }
 
-static void stmpe_irq_remove(struct stmpe *stmpe)
+static void stmpe_irq_unmap(struct irq_domain *d, unsigned int virq)
 {
-	int num_irqs = stmpe->variant->num_irqs;
-	int base = stmpe->irq_base;
-	int irq;
-
-	for (irq = base; irq < base + num_irqs; irq++) {
 #ifdef CONFIG_ARM
-		set_irq_flags(irq, 0);
+		set_irq_flags(virq, 0);
 #endif
-		irq_set_chip_and_handler(irq, NULL, NULL);
-		irq_set_chip_data(irq, NULL);
+		irq_set_chip_and_handler(virq, NULL, NULL);
+		irq_set_chip_data(virq, NULL);
+}
+
+static struct irq_domain_ops stmpe_irq_ops = {
+        .map    = stmpe_irq_map,
+        .unmap  = stmpe_irq_unmap,
+        .xlate  = irq_domain_xlate_twocell,
+};
+
+static int __devinit stmpe_irq_init(struct stmpe *stmpe)
+{
+	int base = stmpe->irq_base;
+	int num_irqs = stmpe->variant->num_irqs;
+
+	if (base) {
+		stmpe->domain = irq_domain_add_legacy(
+			NULL, num_irqs, base, 0, &stmpe_irq_ops, stmpe);
+	}
+	else {
+		stmpe->domain = irq_domain_add_linear(
+			NULL, num_irqs, &stmpe_irq_ops, stmpe);
+	}
+
+	if (!stmpe->domain) {
+		dev_err(stmpe->dev, "Failed to create irqdomain\n");
+		return -ENOSYS;
 	}
+
+	return 0;
 }
 
 static int __devinit stmpe_chip_init(struct stmpe *stmpe)
@@ -954,7 +977,7 @@ static int __devinit stmpe_add_device(struct stmpe *stmpe,
 				      struct mfd_cell *cell)
 {
 	return mfd_add_devices(stmpe->dev, stmpe->pdata->id, cell, 1,
-			       NULL, stmpe->irq_base, NULL);
+			       NULL, stmpe->irq_base, stmpe->domain);
 }
 
 static int __devinit stmpe_devices_init(struct stmpe *stmpe)
@@ -1067,7 +1090,7 @@ int __devinit stmpe_probe(struct stmpe_client_info *ci, int partnum)
 		if (ret) {
 			dev_err(stmpe->dev, "failed to request IRQ: %d\n",
 					ret);
-			goto out_removeirq;
+			goto free_gpio;
 		}
 	}
 
@@ -1083,9 +1106,6 @@ out_removedevs:
 	mfd_remove_devices(stmpe->dev);
 	if (stmpe->irq >= 0)
 		free_irq(stmpe->irq, stmpe);
-out_removeirq:
-	if (stmpe->irq >= 0)
-		stmpe_irq_remove(stmpe);
 free_gpio:
 	if (pdata->irq_over_gpio)
 		gpio_free(pdata->irq_gpio);
@@ -1098,10 +1118,8 @@ int stmpe_remove(struct stmpe *stmpe)
 {
 	mfd_remove_devices(stmpe->dev);
 
-	if (stmpe->irq >= 0) {
+	if (stmpe->irq >= 0)
 		free_irq(stmpe->irq, stmpe);
-		stmpe_irq_remove(stmpe);
-	}
 
 	if (stmpe->pdata->irq_over_gpio)
 		gpio_free(stmpe->pdata->irq_gpio);
diff --git a/include/linux/mfd/stmpe.h b/include/linux/mfd/stmpe.h
index f8d5b4d..15dac79 100644
--- a/include/linux/mfd/stmpe.h
+++ b/include/linux/mfd/stmpe.h
@@ -62,6 +62,7 @@ struct stmpe_client_info;
  * @lock: lock protecting I/O operations
  * @irq_lock: IRQ bus lock
  * @dev: device, mostly for dev_dbg()
+ * @irq_domain: IRQ domain
  * @client: client - i2c or spi
  * @ci: client specific information
  * @partnum: part number
@@ -79,6 +80,7 @@ struct stmpe {
 	struct mutex lock;
 	struct mutex irq_lock;
 	struct device *dev;
+	struct irq_domain *domain;
 	void *client;
 	struct stmpe_client_info *ci;
 	enum stmpe_partnum partnum;
-- 
1.7.9.5

