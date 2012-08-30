Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753247Ab2H3JFS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 05:05:18 -0400
Received: from na3sys009aog129.obsmtp.com ([74.125.149.142]:53624 "EHLO
	na3sys009aog129.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753060Ab2H3JFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 05:05:16 -0400
From: Xiaofan Tian <tianxf@marvell.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        <linux-kernel@vger.kernel.org>
Cc: Qing Xu <qingx@marvell.com>, Xiaofan Tian <tianxf@marvell.com>
Subject: [PATCH] regmap-irq: Add mask invert flag for enable register
Date: Thu, 30 Aug 2012 17:03:35 +0800
Message-Id: <1346317415-12276-1-git-send-email-tianxf@marvell.com>
X-Mailer: git-send-email 1.7.0.4
X-OriginalArrivalTime: 30 Aug 2012 09:04:02.0958 (UTC) FILETIME=[66AB1AE0:01CD868E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, regmap will write 1 to mask_base to mask
an interrupt and write 0 to unmask it.

But some chips do not have an interrupt mask register,
and only have interrupt enable register.
Then we should write 0 to disable interrupt and 1 to enable.

So add an mask_invert flag to handle this.
If it is not set, behavior is same as previous.
If set it to 1, the mask value will be inverted
before written to mask_base

Signed-off-by: Xiaofan Tian <tianxf@marvell.com>
---
 drivers/base/regmap/regmap-irq.c |   12 ++++++++++--
 include/linux/regmap.h           |    1 +
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/base/regmap/regmap-irq.c b/drivers/base/regmap/regmap-irq.c
index bb5e103..094f998 100644
--- a/drivers/base/regmap/regmap-irq.c
+++ b/drivers/base/regmap/regmap-irq.c
@@ -78,7 +78,11 @@ static void regmap_irq_sync_unlock(struct irq_data *data)
 	for (i = 0; i < d->chip->num_regs; i++) {
 		reg = d->chip->mask_base +
 			(i * map->reg_stride * d->irq_reg_stride);
-		ret = regmap_update_bits(d->map, reg,
+		if (d->chip->mask_invert)
+			ret = regmap_update_bits(d->map, reg,
+					 d->mask_buf_def[i], ~d->mask_buf[i]);
+		else
+			ret = regmap_update_bits(d->map, reg,
 					 d->mask_buf_def[i], d->mask_buf[i]);
 		if (ret != 0)
 			dev_err(d->map->dev, "Failed to sync masks in %x\n",
@@ -338,7 +342,11 @@ int regmap_add_irq_chip(struct regmap *map, int irq, int irq_flags,
 		d->mask_buf[i] = d->mask_buf_def[i];
 		reg = chip->mask_base +
 			(i * map->reg_stride * d->irq_reg_stride);
-		ret = regmap_update_bits(map, reg,
+		if (chip->mask_invert)
+			ret = regmap_update_bits(map, reg,
+					 d->mask_buf[i], ~d->mask_buf[i]);
+		else
+			ret = regmap_update_bits(map, reg,
 					 d->mask_buf[i], d->mask_buf[i]);
 		if (ret != 0) {
 			dev_err(map->dev, "Failed to set masks in 0x%x: %d\n",
diff --git a/include/linux/regmap.h b/include/linux/regmap.h
index 9c4c9c6..e3bcc3f 100644
--- a/include/linux/regmap.h
+++ b/include/linux/regmap.h
@@ -300,6 +300,7 @@ struct regmap_irq_chip {
 	unsigned int ack_base;
 	unsigned int wake_base;
 	unsigned int irq_reg_stride;
+	unsigned int mask_invert;
 	bool runtime_pm;
 
 	int num_regs;
-- 
1.7.0.4

