Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752260Ab2IQEUd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 00:20:33 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59558 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370Ab2IQEU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 00:20:29 -0400
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: sameo@linux.intel.com, lrg@ti.com, broonie@opensource.wolfsonmicro.com,
        rpurdie@rpsys.net, dmitry.torokhov@gmail.com,
        linux-kernel@vger.kernel.org
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>
Subject: [PATCH 6/9] mfd: 88pm860x: use irqdomain
Date: Mon, 17 Sep 2012 12:19:09 +0800
Message-Id: <1347855552-26213-7-git-send-email-haojian.zhuang@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1347855552-26213-1-git-send-email-haojian.zhuang@gmail.com>
References: <1347855552-26213-1-git-send-email-haojian.zhuang@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use irqdomain and allocating interrupts. It's necessary for supporting
DT mode.

Signed-off-by: Haojian Zhuang <haojian.zhuang@gmail.com>
---
 drivers/mfd/88pm860x-core.c |   65 +++++++++++++++++++++++++------------------
 1 file changed, 38 insertions(+), 27 deletions(-)

diff --git a/drivers/mfd/88pm860x-core.c b/drivers/mfd/88pm860x-core.c
index 797bdb3..a09d790 100644
--- a/drivers/mfd/88pm860x-core.c
+++ b/drivers/mfd/88pm860x-core.c
@@ -15,6 +15,7 @@
 #include <linux/i2c.h>
 #include <linux/irq.h>
 #include <linux/interrupt.h>
+#include <linux/irqdomain.h>
 #include <linux/platform_device.h>
 #include <linux/regmap.h>
 #include <linux/slab.h>
@@ -520,15 +521,12 @@ static void pm860x_irq_sync_unlock(struct irq_data *data)
 
 static void pm860x_irq_enable(struct irq_data *data)
 {
-	struct pm860x_chip *chip = irq_data_get_irq_chip_data(data);
-	pm860x_irqs[data->irq - chip->irq_base].enable
-		= pm860x_irqs[data->irq - chip->irq_base].offs;
+	pm860x_irqs[data->hwirq].enable = pm860x_irqs[data->hwirq].offs;
 }
 
 static void pm860x_irq_disable(struct irq_data *data)
 {
-	struct pm860x_chip *chip = irq_data_get_irq_chip_data(data);
-	pm860x_irqs[data->irq - chip->irq_base].enable = 0;
+	pm860x_irqs[data->hwirq].enable = 0;
 }
 
 static struct irq_chip pm860x_irq_chip = {
@@ -539,6 +537,25 @@ static struct irq_chip pm860x_irq_chip = {
 	.irq_disable	= pm860x_irq_disable,
 };
 
+static int pm860x_irq_domain_map(struct irq_domain *d, unsigned int virq,
+				 irq_hw_number_t hw)
+{
+	irq_set_chip_data(virq, d->host_data);
+	irq_set_chip_and_handler(virq, &pm860x_irq_chip, handle_edge_irq);
+	irq_set_nested_thread(virq, 1);
+#ifdef CONFIG_ARM
+	set_irq_flags(virq, IRQF_VALID);
+#else
+	irq_set_noprobe(virq);
+#endif
+	return 0;
+}
+
+static struct irq_domain_ops pm860x_irq_domain_ops = {
+	.map	= pm860x_irq_domain_map,
+	.xlate	= irq_domain_xlate_onetwocell,
+};
+
 static int __devinit device_gpadc_init(struct pm860x_chip *chip,
 				       struct pm860x_platform_data *pdata)
 {
@@ -593,13 +610,9 @@ static int __devinit device_irq_init(struct pm860x_chip *chip,
 				: chip->companion;
 	unsigned char status_buf[INT_STATUS_NUM];
 	unsigned long flags = IRQF_TRIGGER_FALLING | IRQF_ONESHOT;
-	int i, data, mask, ret = -EINVAL;
-	int __irq;
-
-	if (!pdata || !pdata->irq_base) {
-		dev_warn(chip->dev, "No interrupt support on IRQ base\n");
-		return -EINVAL;
-	}
+	int data, mask, ret = -EINVAL;
+	int nr_irqs, irq_base = -1;
+	struct device_node *node = i2c->dev.of_node;
 
 	mask = PM8607_B0_MISC1_INV_INT | PM8607_B0_MISC1_INT_CLEAR
 		| PM8607_B0_MISC1_INT_MASK;
@@ -639,25 +652,23 @@ static int __devinit device_irq_init(struct pm860x_chip *chip,
 		goto out;
 
 	mutex_init(&chip->irq_lock);
-	chip->irq_base = pdata->irq_base;
+
+	if (pdata && pdata->irq_base)
+		irq_base = pdata->irq_base;
+	nr_irqs = ARRAY_SIZE(pm860x_irqs);
+	chip->irq_base = irq_alloc_descs(irq_base, 0, nr_irqs, 0);
+	if (chip->irq_base < 0) {
+		dev_err(&i2c->dev, "Failed to allocate interrupts, ret:%d\n",
+			chip->irq_base);
+		ret = -EBUSY;
+		goto out;
+	}
+	irq_domain_add_legacy(node, nr_irqs, chip->irq_base, 0,
+			      &pm860x_irq_domain_ops, chip);
 	chip->core_irq = i2c->irq;
 	if (!chip->core_irq)
 		goto out;
 
-	/* register IRQ by genirq */
-	for (i = 0; i < ARRAY_SIZE(pm860x_irqs); i++) {
-		__irq = i + chip->irq_base;
-		irq_set_chip_data(__irq, chip);
-		irq_set_chip_and_handler(__irq, &pm860x_irq_chip,
-					 handle_edge_irq);
-		irq_set_nested_thread(__irq, 1);
-#ifdef CONFIG_ARM
-		set_irq_flags(__irq, IRQF_VALID);
-#else
-		irq_set_noprobe(__irq);
-#endif
-	}
-
 	ret = request_threaded_irq(chip->core_irq, NULL, pm860x_irq, flags,
 				   "88pm860x", chip);
 	if (ret) {
-- 
1.7.9.5

