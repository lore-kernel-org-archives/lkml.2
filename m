Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934280Ab2FENe1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 09:34:27 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51786 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934115Ab2FENe0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 09:34:26 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regmap: Implement support for wake IRQs
Date: Tue,  5 Jun 2012 14:34:24 +0100
Message-Id: <1338903264-25753-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow chips to provide a bank of registers for controlling the wake state
in a similar fashion to the masks and propagate the wake count to the
parent interrupt controller.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/regmap-irq.c |   47 ++++++++++++++++++++++++++++++++++++++
 include/linux/regmap.h           |    2 ++
 2 files changed, 49 insertions(+)

diff --git a/drivers/base/regmap/regmap-irq.c b/drivers/base/regmap/regmap-irq.c
index 8e94e0e..a897346 100644
--- a/drivers/base/regmap/regmap-irq.c
+++ b/drivers/base/regmap/regmap-irq.c
@@ -29,9 +29,13 @@ struct regmap_irq_chip_data {
 	int irq_base;
 	struct irq_domain *domain;
 
+	int irq;
+	int wake_count;
+
 	unsigned int *status_buf;
 	unsigned int *mask_buf;
 	unsigned int *mask_buf_def;
+	unsigned int *wake_buf;
 
 	unsigned int irq_reg_stride;
 };
@@ -71,6 +75,16 @@ static void regmap_irq_sync_unlock(struct irq_data *data)
 				d->chip->mask_base + (i * map->reg_stride));
 	}
 
+	/* If we've changed our wakeup count propagate it to the parent */
+	if (d->wake_count < 0)
+		for (i = d->wake_count; i < 0; i++)
+			irq_set_irq_wake(d->irq, 0);
+	else if (d->wake_count > 0)
+		for (i = 0; i < d->wake_count; i++)
+			irq_set_irq_wake(d->irq, 1);
+
+	d->wake_count = 0;
+
 	mutex_unlock(&d->lock);
 }
 
@@ -92,12 +106,35 @@ static void regmap_irq_disable(struct irq_data *data)
 	d->mask_buf[irq_data->reg_offset / map->reg_stride] |= irq_data->mask;
 }
 
+static int regmap_irq_set_wake(struct irq_data *data, unsigned int on)
+{
+	struct regmap_irq_chip_data *d = irq_data_get_irq_chip_data(data);
+	struct regmap *map = d->map;
+	const struct regmap_irq *irq_data = irq_to_regmap_irq(d, data->hwirq);
+
+	if (!d->chip->wake_base)
+		return -EINVAL;
+
+	if (on) {
+		d->wake_buf[irq_data->reg_offset / map->reg_stride]
+			&= ~irq_data->mask;
+		d->wake_count++;
+	} else {
+		d->wake_buf[irq_data->reg_offset / map->reg_stride]
+			|= irq_data->mask;
+		d->wake_count--;
+	}
+
+	return 0;
+}
+
 static struct irq_chip regmap_irq_chip = {
 	.name			= "regmap",
 	.irq_bus_lock		= regmap_irq_lock,
 	.irq_bus_sync_unlock	= regmap_irq_sync_unlock,
 	.irq_disable		= regmap_irq_disable,
 	.irq_enable		= regmap_irq_enable,
+	.irq_set_wake		= regmap_irq_set_wake,
 };
 
 static irqreturn_t regmap_irq_thread(int irq, void *d)
@@ -240,6 +277,14 @@ int regmap_add_irq_chip(struct regmap *map, int irq, int irq_flags,
 	if (!d->mask_buf_def)
 		goto err_alloc;
 
+	if (chip->wake_base) {
+		d->wake_buf = kzalloc(sizeof(unsigned int) * chip->num_regs,
+				      GFP_KERNEL);
+		if (!d->wake_buf)
+			goto err_alloc;
+	}
+
+	d->irq = irq;
 	d->map = map;
 	d->chip = chip;
 	d->irq_base = irq_base;
@@ -294,6 +339,7 @@ int regmap_add_irq_chip(struct regmap *map, int irq, int irq_flags,
 err_domain:
 	/* Should really dispose of the domain but... */
 err_alloc:
+	kfree(d->wake_buf);
 	kfree(d->mask_buf_def);
 	kfree(d->mask_buf);
 	kfree(d->status_buf);
@@ -315,6 +361,7 @@ void regmap_del_irq_chip(int irq, struct regmap_irq_chip_data *d)
 
 	free_irq(irq, d);
 	/* We should unmap the domain but... */
+	kfree(d->wake_buf);
 	kfree(d->mask_buf_def);
 	kfree(d->mask_buf);
 	kfree(d->status_buf);
diff --git a/include/linux/regmap.h b/include/linux/regmap.h
index f9b624c..4c9e642 100644
--- a/include/linux/regmap.h
+++ b/include/linux/regmap.h
@@ -244,6 +244,7 @@ struct regmap_irq {
  * @status_base: Base status register address.
  * @mask_base:   Base mask register address.
  * @ack_base:    Base ack address.  If zero then the chip is clear on read.
+ * @wake_base:   Base address for wake enables.  If zero unsupported.
  * @irq_reg_stride:  Stride to use for chips where registers are not contiguous.
  *
  * @num_regs:    Number of registers in each control bank.
@@ -257,6 +258,7 @@ struct regmap_irq_chip {
 	unsigned int status_base;
 	unsigned int mask_base;
 	unsigned int ack_base;
+	unsigned int wake_base;
 	unsigned int irq_reg_stride;
 
 	int num_regs;
-- 
1.7.10

