Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753958Ab2GSJEz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 05:04:55 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:40654 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751939Ab2GSJEu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 05:04:50 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] regmap-irq: support different type of irq register
Thread-Topic: [PATCH 2/2] regmap-irq: support different type of irq register
Thread-Index: Ac1ljYmzQ45lYnOMTsqrXBrDrCPWeQ==
Date: Thu, 19 Jul 2012 09:04:44 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998FD9A7@DQHE02.ent.ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.87.177.86]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Interrupt-masked vs Interrupt-enabled
Commonly the interrupt register is masked when the bit of IRQ register is set.
But in some device like TI LP8788, the interrupt is enabled when the bit is 1.

This patch supports the interrupt-enabled type.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/base/regmap/regmap-irq.c |   42 ++++++++++++++++++++++++++++++++++---
 include/linux/regmap.h           |    9 ++++++++
 2 files changed, 47 insertions(+), 4 deletions(-)

diff --git a/drivers/base/regmap/regmap-irq.c b/drivers/base/regmap/regmap-irq.c
index ed36ea2..cb44918 100644
--- a/drivers/base/regmap/regmap-irq.c
+++ b/drivers/base/regmap/regmap-irq.c
@@ -94,7 +94,16 @@ static void regmap_irq_enable(struct irq_data *data)
 	struct regmap *map = d->map;
 	const struct regmap_irq *irq_data = irq_to_regmap_irq(d, data->hwirq);
 
-	d->val_buf[irq_data->reg_offset / map->reg_stride] &= ~irq_data->mask;
+	switch (d->chip->irq_type) {
+	case REGIRQ_MASKED:
+		d->val_buf[irq_data->reg_offset / map->reg_stride] &= ~irq_data->mask;
+		break;
+	case REGIRQ_ENABLED:
+		d->val_buf[irq_data->reg_offset / map->reg_stride] |= irq_data->mask;
+		break;
+	default:
+		break;
+	}
 }
 
 static void regmap_irq_disable(struct irq_data *data)
@@ -103,7 +112,16 @@ static void regmap_irq_disable(struct irq_data *data)
 	struct regmap *map = d->map;
 	const struct regmap_irq *irq_data = irq_to_regmap_irq(d, data->hwirq);
 
-	d->val_buf[irq_data->reg_offset / map->reg_stride] |= irq_data->mask;
+	switch (d->chip->irq_type) {
+	case REGIRQ_MASKED:
+		d->val_buf[irq_data->reg_offset / map->reg_stride] |= irq_data->mask;
+		break;
+	case REGIRQ_ENABLED:
+		d->val_buf[irq_data->reg_offset / map->reg_stride] &= ~irq_data->mask;
+		break;
+	default:
+		break;
+	}
 }
 
 static int regmap_irq_set_wake(struct irq_data *data, unsigned int on)
@@ -163,7 +181,18 @@ static irqreturn_t regmap_irq_thread(int irq, void *d)
 			return IRQ_NONE;
 		}
 
-		data->status_buf[i] &= ~data->mask_buf[i];
+		switch (data->chip->irq_type) {
+		case REGIRQ_MASKED:
+			data->status_buf[i] &= ~data->mask_buf[i];
+			break;
+		case REGIRQ_ENABLED:
+			data->status_buf[i] &= data->mask_buf[i];
+			break;
+		default:
+			dev_err(map->dev, "Invalid irq register type: %d\n",
+					data->chip->irq_type);
+			return IRQ_NONE;
+		}
 
 		if (data->status_buf[i] && chip->ack_base) {
 			ret = regmap_write(map, chip->ack_base +
@@ -238,6 +267,7 @@ int regmap_add_irq_chip(struct regmap *map, int irq, int irq_flags,
 	struct regmap_irq_chip_data *d;
 	int i;
 	int ret = -ENOMEM;
+	unsigned int val;
 
 	for (i = 0; i < chip->num_irqs; i++) {
 		if (chip->irqs[i].reg_offset % map->reg_stride)
@@ -302,9 +332,13 @@ int regmap_add_irq_chip(struct regmap *map, int irq, int irq_flags,
 
 	/* Mask all the interrupts by default */
 	for (i = 0; i < chip->num_regs; i++) {
+		val = d->mask_buf[i];
+		if (chip->irq_type == REGIRQ_ENABLED)
+			val = ~d->mask_buf[i];
+
 		ret = regmap_write(map, chip->mask_base + (i * map->reg_stride
 				   * d->irq_reg_stride),
-				   d->mask_buf[i]);
+				   val);
 		if (ret != 0) {
 			dev_err(map->dev, "Failed to set masks in 0x%x: %d\n",
 				chip->mask_base + (i * map->reg_stride), ret);
diff --git a/include/linux/regmap.h b/include/linux/regmap.h
index 7f7e00d..e0094db 100644
--- a/include/linux/regmap.h
+++ b/include/linux/regmap.h
@@ -30,6 +30,12 @@ enum regcache_type {
 	REGCACHE_COMPRESSED
 };
 
+/* Interrupt register type : masked or enabled */
+enum regirq_type {
+	REGIRQ_MASKED,	/* interrupt is masked when the bit is set */
+	REGIRQ_ENABLED,	/* interrupt is enabled when the bit is set */
+};
+
 /**
  * Default value for a register.  We use an array of structs rather
  * than a simple array as many modern devices have very sparse
@@ -290,6 +296,7 @@ struct regmap_irq {
  * @irqs:        Descriptors for individual IRQs.  Interrupt numbers are
  *               assigned based on the index in the array of the interrupt.
  * @num_irqs:    Number of descriptors.
+ * @irq_type:    Interrupt register type. masked or enabled
  */
 struct regmap_irq_chip {
 	const char *name;
@@ -304,6 +311,8 @@ struct regmap_irq_chip {
 
 	const struct regmap_irq *irqs;
 	int num_irqs;
+
+	enum regirq_type irq_type;
 };
 
 struct regmap_irq_chip_data;
-- 
1.7.2.5


Best Regards,
Milo


