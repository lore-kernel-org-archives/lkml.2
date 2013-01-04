Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755276Ab3ADRTY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 12:19:24 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34123 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755120Ab3ADRTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 12:19:22 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Cc: patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 1/4] regmap: irq: Fix sync of wake statuses to hardware
Date: Fri,  4 Jan 2013 17:19:14 +0000
Message-Id: <1357319957-11480-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This wasn't implemented but happened to work on test systems due to lack
of wake mask inversion support.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/regmap-irq.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/base/regmap/regmap-irq.c b/drivers/base/regmap/regmap-irq.c
index 4eab586..7dabfc8 100644
--- a/drivers/base/regmap/regmap-irq.c
+++ b/drivers/base/regmap/regmap-irq.c
@@ -88,6 +88,17 @@ static void regmap_irq_sync_unlock(struct irq_data *data)
 		if (ret != 0)
 			dev_err(d->map->dev, "Failed to sync masks in %x\n",
 				reg);
+
+		reg = d->chip->wake_base +
+			(i * map->reg_stride * d->irq_reg_stride);
+		if (d->wake_buf) {
+			ret = regmap_update_bits(d->map, reg,
+					 d->mask_buf_def[i], d->wake_buf[i]);
+			if (ret != 0)
+				dev_err(d->map->dev,
+					"Failed to sync wakes in %x: %d\n",
+					reg, ret);
+		}
 	}
 
 	if (d->chip->runtime_pm)
-- 
1.7.10.4

