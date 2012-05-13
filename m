Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752308Ab2EMSEv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 14:04:51 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42537 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751100Ab2EMSEu (ORCPT
	<rfc822;linux-kernel@Vger.kernel.org>);
	Sun, 13 May 2012 14:04:50 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: David Dajun Chen <dchen@diasemi.com>, Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] mfd: da9052: Fix genirq abuse
Date: Sun, 13 May 2012 19:04:42 +0100
Message-Id: <1336932282-31898-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rather than using the pointer passed back by the regmap API (or complaining
because that wasn't actually being set) the da9052 driver was having some
fun and games peering through genirq and regmap internals. Fix the driver
to use the API as expected.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/da9052-core.c         |    8 +++-----
 include/linux/mfd/da9052/da9052.h |    1 +
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/mfd/da9052-core.c b/drivers/mfd/da9052-core.c
index 7ff313f..7776aff 100644
--- a/drivers/mfd/da9052-core.c
+++ b/drivers/mfd/da9052-core.c
@@ -659,12 +659,11 @@ int __devinit da9052_device_init(struct da9052 *da9052, u8 chip_id)
 	ret = regmap_add_irq_chip(da9052->regmap, da9052->chip_irq,
 				  IRQF_TRIGGER_LOW | IRQF_ONESHOT,
 				  da9052->irq_base, &da9052_regmap_irq_chip,
-				  NULL);
+				  &da9052->irq_data);
 	if (ret < 0)
 		goto regmap_err;
 
-	desc = irq_to_desc(da9052->chip_irq);
-	da9052->irq_base = regmap_irq_chip_get_base(desc->action->dev_id);
+	da9052->irq_base = regmap_irq_chip_get_base(da9052->irq_data);
 
 	ret = mfd_add_devices(da9052->dev, -1, da9052_subdev_info,
 			      ARRAY_SIZE(da9052_subdev_info), NULL, 0);
@@ -681,8 +680,7 @@ regmap_err:
 
 void da9052_device_exit(struct da9052 *da9052)
 {
-	regmap_del_irq_chip(da9052->chip_irq,
-			    irq_get_irq_data(da9052->irq_base)->chip_data);
+	regmap_del_irq_chip(da9052->chip_irq, da9052->irq_data);
 	mfd_remove_devices(da9052->dev);
 }
 
diff --git a/include/linux/mfd/da9052/da9052.h b/include/linux/mfd/da9052/da9052.h
index 7ffbd6e..8313cd9 100644
--- a/include/linux/mfd/da9052/da9052.h
+++ b/include/linux/mfd/da9052/da9052.h
@@ -80,6 +80,7 @@ struct da9052 {
 	struct regmap *regmap;
 
 	int irq_base;
+	struct regmap_irq_chip_data *irq_data;
 	u8 chip_id;
 
 	int chip_irq;
-- 
1.7.10

