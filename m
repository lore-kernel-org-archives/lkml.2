Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752602Ab2G0TCJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 15:02:09 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:57334 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752125Ab2G0TCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 15:02:07 -0400
From: Stephen Warren <swarren@wwwdotorg.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Cc: linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        Stephen Warren <swarren@nvidia.com>
Subject: [PATCH 1/3] regmap: fix some error messages to take account of irq_reg_stride
Date: Fri, 27 Jul 2012 13:01:54 -0600
Message-Id: <1343415716-27134-1-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.7.0.4
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

A number of places in the code were printing error messages that included
the address of a register, but were not calculating the register address
in the same way as the access to the register. Use a temporary to solve
this.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
Note: This patch series will be a dependency for some MFD patches that I
will send shortly.

 drivers/base/regmap/regmap-irq.c |   29 +++++++++++++++--------------
 1 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/drivers/base/regmap/regmap-irq.c b/drivers/base/regmap/regmap-irq.c
index a897346..c7e5b18 100644
--- a/drivers/base/regmap/regmap-irq.c
+++ b/drivers/base/regmap/regmap-irq.c
@@ -59,6 +59,7 @@ static void regmap_irq_sync_unlock(struct irq_data *data)
 	struct regmap_irq_chip_data *d = irq_data_get_irq_chip_data(data);
 	struct regmap *map = d->map;
 	int i, ret;
+	u32 reg;
 
 	/*
 	 * If there's been a change in the mask write it back to the
@@ -66,13 +67,13 @@ static void regmap_irq_sync_unlock(struct irq_data *data)
 	 * suppress pointless writes.
 	 */
 	for (i = 0; i < d->chip->num_regs; i++) {
-		ret = regmap_update_bits(d->map, d->chip->mask_base +
-						(i * map->reg_stride *
-						d->irq_reg_stride),
+		reg = d->chip->mask_base +
+			(i * map->reg_stride * d->irq_reg_stride);
+		ret = regmap_update_bits(d->map, reg,
 					 d->mask_buf_def[i], d->mask_buf[i]);
 		if (ret != 0)
 			dev_err(d->map->dev, "Failed to sync masks in %x\n",
-				d->chip->mask_base + (i * map->reg_stride));
+				reg);
 	}
 
 	/* If we've changed our wakeup count propagate it to the parent */
@@ -144,6 +145,7 @@ static irqreturn_t regmap_irq_thread(int irq, void *d)
 	struct regmap *map = data->map;
 	int ret, i;
 	bool handled = false;
+	u32 reg;
 
 	/*
 	 * Ignore masked IRQs and ack if we need to; we ack early so
@@ -166,14 +168,12 @@ static irqreturn_t regmap_irq_thread(int irq, void *d)
 		data->status_buf[i] &= ~data->mask_buf[i];
 
 		if (data->status_buf[i] && chip->ack_base) {
-			ret = regmap_write(map, chip->ack_base +
-						(i * map->reg_stride *
-						data->irq_reg_stride),
-					   data->status_buf[i]);
+			reg = chip->ack_base +
+				(i * map->reg_stride * data->irq_reg_stride);
+			ret = regmap_write(map, reg, data->status_buf[i]);
 			if (ret != 0)
 				dev_err(map->dev, "Failed to ack 0x%x: %d\n",
-					chip->ack_base + (i * map->reg_stride),
-					ret);
+					reg, ret);
 		}
 	}
 
@@ -238,6 +238,7 @@ int regmap_add_irq_chip(struct regmap *map, int irq, int irq_flags,
 	struct regmap_irq_chip_data *d;
 	int i;
 	int ret = -ENOMEM;
+	u32 reg;
 
 	for (i = 0; i < chip->num_irqs; i++) {
 		if (chip->irqs[i].reg_offset % map->reg_stride)
@@ -303,12 +304,12 @@ int regmap_add_irq_chip(struct regmap *map, int irq, int irq_flags,
 	/* Mask all the interrupts by default */
 	for (i = 0; i < chip->num_regs; i++) {
 		d->mask_buf[i] = d->mask_buf_def[i];
-		ret = regmap_write(map, chip->mask_base + (i * map->reg_stride
-				   * d->irq_reg_stride),
-				   d->mask_buf[i]);
+		reg = chip->mask_base +
+			(i * map->reg_stride * d->irq_reg_stride);
+		ret = regmap_write(map, reg, d->mask_buf[i]);
 		if (ret != 0) {
 			dev_err(map->dev, "Failed to set masks in 0x%x: %d\n",
-				chip->mask_base + (i * map->reg_stride), ret);
+				reg, ret);
 			goto err_alloc;
 		}
 	}
-- 
1.7.0.4

