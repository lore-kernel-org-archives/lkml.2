Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753383Ab3ACO2F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 09:28:05 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42908 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753251Ab3ACO2C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 09:28:02 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 2/2] regmap: irq: Use a bulk read for interrupt status where possible
Date: Thu,  3 Jan 2013 14:27:55 +0000
Message-Id: <1357223275-31441-2-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1357223275-31441-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1357223275-31441-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the interrupt status registers are a single block of registers and the
chip supports bulk reads then do a single bulk read rather than pay the
extra I/O cost. This restores the original behaviour which was lost when
support for register striding was added.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/regmap-irq.c |   67 +++++++++++++++++++++++++++++++++-----
 1 file changed, 59 insertions(+), 8 deletions(-)

diff --git a/drivers/base/regmap/regmap-irq.c b/drivers/base/regmap/regmap-irq.c
index 329be98..4eab586 100644
--- a/drivers/base/regmap/regmap-irq.c
+++ b/drivers/base/regmap/regmap-irq.c
@@ -34,6 +34,7 @@ struct regmap_irq_chip_data {
 	int irq;
 	int wake_count;
 
+	void *status_reg_buf;
 	unsigned int *status_buf;
 	unsigned int *mask_buf;
 	unsigned int *mask_buf_def;
@@ -170,18 +171,58 @@ static irqreturn_t regmap_irq_thread(int irq, void *d)
 		}
 	}
 
-	for (i = 0; i < data->chip->num_regs; i++) {
-		ret = regmap_read(map, chip->status_base + (i * map->reg_stride
-				   * data->irq_reg_stride),
-				   &data->status_buf[i]);
-
+	/*
+	 * Read in the statuses, using a single bulk read if possible
+	 * in order to reduce the I/O overheads.
+	 */
+	if (!map->use_single_rw && map->reg_stride == 1 &&
+	    data->irq_reg_stride == 1) {
+		u8 *buf8 = data->status_reg_buf;
+		u16 *buf16 = data->status_reg_buf;
+		u32 *buf32 = data->status_reg_buf;
+
+		ret = regmap_bulk_read(map, chip->status_base,
+				       data->status_reg_buf,
+				       chip->num_regs);
 		if (ret != 0) {
 			dev_err(map->dev, "Failed to read IRQ status: %d\n",
-					ret);
-			if (chip->runtime_pm)
-				pm_runtime_put(map->dev);
+				ret);
 			return IRQ_NONE;
 		}
+
+		for (i = 0; i < data->chip->num_regs; i++) {
+			switch (map->format.val_bytes) {
+			case 1:
+				data->status_buf[i] = buf8[i];
+				break;
+			case 2:
+				data->status_buf[i] = buf16[i];
+				break;
+			case 4:
+				data->status_buf[i] = buf32[i];
+				break;
+			default:
+				BUG();
+				return IRQ_NONE;
+			}
+		}
+
+	} else {
+		for (i = 0; i < data->chip->num_regs; i++) {
+			ret = regmap_read(map, chip->status_base +
+					  (i * map->reg_stride
+					   * data->irq_reg_stride),
+					  &data->status_buf[i]);
+
+			if (ret != 0) {
+				dev_err(map->dev,
+					"Failed to read IRQ status: %d\n",
+					ret);
+				if (chip->runtime_pm)
+					pm_runtime_put(map->dev);
+				return IRQ_NONE;
+			}
+		}
 	}
 
 	/*
@@ -327,6 +368,14 @@ int regmap_add_irq_chip(struct regmap *map, int irq, int irq_flags,
 	else
 		d->irq_reg_stride = 1;
 
+	if (map->reg_stride == 1 && chip->irq_reg_stride == 1) {
+		d->status_reg_buf = kzalloc(sizeof(unsigned int) *
+					    chip->num_regs,
+					    GFP_KERNEL);
+		if (!d->status_reg_buf)
+			goto err_alloc;
+	}
+
 	mutex_init(&d->lock);
 
 	for (i = 0; i < chip->num_irqs; i++)
@@ -397,6 +446,7 @@ err_alloc:
 	kfree(d->mask_buf_def);
 	kfree(d->mask_buf);
 	kfree(d->status_buf);
+	kfree(d->status_reg_buf);
 	kfree(d);
 	return ret;
 }
@@ -418,6 +468,7 @@ void regmap_del_irq_chip(int irq, struct regmap_irq_chip_data *d)
 	kfree(d->wake_buf);
 	kfree(d->mask_buf_def);
 	kfree(d->mask_buf);
+	kfree(d->status_reg_buf);
 	kfree(d->status_buf);
 	kfree(d);
 }
-- 
1.7.10.4

