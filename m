Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755381Ab2ENNlG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 09:41:06 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:43297 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752457Ab2ENNlE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 09:41:04 -0400
From: Graeme Gregory <gg@slimlogic.co.uk>
To: linux-kernel@vger.kernel.org
Cc: broonie@opensource.wolfsonmicro.com, Graeme Gregory <gg@slimlogic.co.uk>
Subject: [PATCH] regmap-irq add support for non contiguous status
Date: Mon, 14 May 2012 22:40:43 +0900
Message-Id: <1337002843-2778-1-git-send-email-gg@slimlogic.co.uk>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In some chips the IRQ status registers are not contiguous in the register
map but spaced at even spaces. This is an easy case to handle with minor
changes. It is assume for this purpose that the stride for status is
equal to the stride for mask/ack registers as well.

Signed-off-by: Graeme Gregory <gg@slimlogic.co.uk>
---
 drivers/base/regmap/regmap-irq.c |   54 +++++++++++++++-----------------------
 include/linux/regmap.h           |    2 ++
 2 files changed, 23 insertions(+), 33 deletions(-)

diff --git a/drivers/base/regmap/regmap-irq.c b/drivers/base/regmap/regmap-irq.c
index db5305b..502cbdb 100644
--- a/drivers/base/regmap/regmap-irq.c
+++ b/drivers/base/regmap/regmap-irq.c
@@ -29,10 +29,11 @@ struct regmap_irq_chip_data {
 	int irq_base;
 	struct irq_domain *domain;
 
-	void *status_reg_buf;
 	unsigned int *status_buf;
 	unsigned int *mask_buf;
 	unsigned int *mask_buf_def;
+
+	unsigned int irq_reg_stride;
 };
 
 static inline const
@@ -62,7 +63,8 @@ static void regmap_irq_sync_unlock(struct irq_data *data)
 	 */
 	for (i = 0; i < d->chip->num_regs; i++) {
 		ret = regmap_update_bits(d->map, d->chip->mask_base +
-						(i * map->reg_stride),
+						(i * map->reg_stride *
+						d->irq_reg_stride),
 					 d->mask_buf_def[i], d->mask_buf[i]);
 		if (ret != 0)
 			dev_err(d->map->dev, "Failed to sync masks in %x\n",
@@ -104,18 +106,8 @@ static irqreturn_t regmap_irq_thread(int irq, void *d)
 	struct regmap_irq_chip *chip = data->chip;
 	struct regmap *map = data->map;
 	int ret, i;
-	u8 *buf8 = data->status_reg_buf;
-	u16 *buf16 = data->status_reg_buf;
-	u32 *buf32 = data->status_reg_buf;
 	bool handled = false;
 
-	ret = regmap_bulk_read(map, chip->status_base, data->status_reg_buf,
-			       chip->num_regs);
-	if (ret != 0) {
-		dev_err(map->dev, "Failed to read IRQ status: %d\n", ret);
-		return IRQ_NONE;
-	}
-
 	/*
 	 * Ignore masked IRQs and ack if we need to; we ack early so
 	 * there is no race between handling and acknowleding the
@@ -124,18 +116,13 @@ static irqreturn_t regmap_irq_thread(int irq, void *d)
 	 * doing a write per register.
 	 */
 	for (i = 0; i < data->chip->num_regs; i++) {
-		switch (map->format.val_bytes) {
-		case 1:
-			data->status_buf[i] = buf8[i];
-			break;
-		case 2:
-			data->status_buf[i] = buf16[i];
-			break;
-		case 4:
-			data->status_buf[i] = buf32[i];
-			break;
-		default:
-			BUG();
+		ret = regmap_read(map, chip->mask_base + (i * map->reg_stride
+				   * data->irq_reg_stride),
+				   &data->status_buf[i]);
+
+		if (ret != 0) {
+			dev_err(map->dev, "Failed to read IRQ status: %d\n",
+					ret);
 			return IRQ_NONE;
 		}
 
@@ -143,7 +130,8 @@ static irqreturn_t regmap_irq_thread(int irq, void *d)
 
 		if (data->status_buf[i] && chip->ack_base) {
 			ret = regmap_write(map, chip->ack_base +
-						(i * map->reg_stride),
+						(i * map->reg_stride *
+						data->irq_reg_stride),
 					   data->status_buf[i]);
 			if (ret != 0)
 				dev_err(map->dev, "Failed to ack 0x%x: %d\n",
@@ -242,11 +230,6 @@ int regmap_add_irq_chip(struct regmap *map, int irq, int irq_flags,
 	if (!d->status_buf)
 		goto err_alloc;
 
-	d->status_reg_buf = kzalloc(map->format.val_bytes * chip->num_regs,
-				    GFP_KERNEL);
-	if (!d->status_reg_buf)
-		goto err_alloc;
-
 	d->mask_buf = kzalloc(sizeof(unsigned int) * chip->num_regs,
 			      GFP_KERNEL);
 	if (!d->mask_buf)
@@ -260,6 +243,12 @@ int regmap_add_irq_chip(struct regmap *map, int irq, int irq_flags,
 	d->map = map;
 	d->chip = chip;
 	d->irq_base = irq_base;
+
+	if (chip->irq_reg_stride)
+		d->irq_reg_stride = chip->irq_reg_stride;
+	else
+		d->irq_reg_stride = 1;
+
 	mutex_init(&d->lock);
 
 	for (i = 0; i < chip->num_irqs; i++)
@@ -269,7 +258,8 @@ int regmap_add_irq_chip(struct regmap *map, int irq, int irq_flags,
 	/* Mask all the interrupts by default */
 	for (i = 0; i < chip->num_regs; i++) {
 		d->mask_buf[i] = d->mask_buf_def[i];
-		ret = regmap_write(map, chip->mask_base + (i * map->reg_stride),
+		ret = regmap_write(map, chip->mask_base + (i * map->reg_stride
+				   * d->irq_reg_stride),
 				   d->mask_buf[i]);
 		if (ret != 0) {
 			dev_err(map->dev, "Failed to set masks in 0x%x: %d\n",
@@ -306,7 +296,6 @@ err_domain:
 err_alloc:
 	kfree(d->mask_buf_def);
 	kfree(d->mask_buf);
-	kfree(d->status_reg_buf);
 	kfree(d->status_buf);
 	kfree(d);
 	return ret;
@@ -328,7 +317,6 @@ void regmap_del_irq_chip(int irq, struct regmap_irq_chip_data *d)
 	/* We should unmap the domain but... */
 	kfree(d->mask_buf_def);
 	kfree(d->mask_buf);
-	kfree(d->status_reg_buf);
 	kfree(d->status_buf);
 	kfree(d);
 }
diff --git a/include/linux/regmap.h b/include/linux/regmap.h
index 7208668..56af22e 100644
--- a/include/linux/regmap.h
+++ b/include/linux/regmap.h
@@ -219,6 +219,7 @@ struct regmap_irq {
  * @status_base: Base status register address.
  * @mask_base:   Base mask register address.
  * @ack_base:    Base ack address.  If zero then the chip is clear on read.
+ * @irq_reg_stride:  Stride to use for chips where registers are not contiguous.
  *
  * @num_regs:    Number of registers in each control bank.
  * @irqs:        Descriptors for individual IRQs.  Interrupt numbers are
@@ -231,6 +232,7 @@ struct regmap_irq_chip {
 	unsigned int status_base;
 	unsigned int mask_base;
 	unsigned int ack_base;
+	unsigned int irq_reg_stride;
 
 	int num_regs;
 
-- 
1.7.9.5

