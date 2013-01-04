Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755305Ab3ADRTk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 12:19:40 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34124 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755218Ab3ADRTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 12:19:22 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Cc: patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 2/4] regmap: irq: Support wake IRQ mask inversion
Date: Fri,  4 Jan 2013 17:19:15 +0000
Message-Id: <1357319957-11480-2-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1357319957-11480-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1357319957-11480-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support devices which have an enable rather than mask register for wake
sources.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/regmap-irq.c |   21 +++++++++++++++++----
 include/linux/regmap.h           |    1 +
 2 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/drivers/base/regmap/regmap-irq.c b/drivers/base/regmap/regmap-irq.c
index 7dabfc8..9bbe5ba 100644
--- a/drivers/base/regmap/regmap-irq.c
+++ b/drivers/base/regmap/regmap-irq.c
@@ -92,8 +92,14 @@ static void regmap_irq_sync_unlock(struct irq_data *data)
 		reg = d->chip->wake_base +
 			(i * map->reg_stride * d->irq_reg_stride);
 		if (d->wake_buf) {
-			ret = regmap_update_bits(d->map, reg,
-					 d->mask_buf_def[i], d->wake_buf[i]);
+			if (d->chip->wake_invert)
+				ret = regmap_update_bits(d->map, reg,
+							 d->mask_buf_def[i],
+							 ~d->wake_buf[i]);
+			else
+				ret = regmap_update_bits(d->map, reg,
+							 d->mask_buf_def[i],
+							 d->wake_buf[i]);
 			if (ret != 0)
 				dev_err(d->map->dev,
 					"Failed to sync wakes in %x: %d\n",
@@ -417,8 +423,15 @@ int regmap_add_irq_chip(struct regmap *map, int irq, int irq_flags,
 			d->wake_buf[i] = d->mask_buf_def[i];
 			reg = chip->wake_base +
 				(i * map->reg_stride * d->irq_reg_stride);
-			ret = regmap_update_bits(map, reg, d->wake_buf[i],
-						 d->wake_buf[i]);
+
+			if (chip->wake_invert)
+				ret = regmap_update_bits(map, reg,
+							 d->mask_buf_def[i],
+							 0);
+			else
+				ret = regmap_update_bits(map, reg,
+							 d->mask_buf_def[i],
+							 d->wake_buf[i]);
 			if (ret != 0) {
 				dev_err(map->dev, "Failed to set masks in 0x%x: %d\n",
 					reg, ret);
diff --git a/include/linux/regmap.h b/include/linux/regmap.h
index 390d879..5e81abf 100644
--- a/include/linux/regmap.h
+++ b/include/linux/regmap.h
@@ -382,6 +382,7 @@ struct regmap_irq_chip {
 	unsigned int wake_base;
 	unsigned int irq_reg_stride;
 	unsigned int mask_invert;
+	unsigned int wake_invert;
 	bool runtime_pm;
 
 	int num_regs;
-- 
1.7.10.4

