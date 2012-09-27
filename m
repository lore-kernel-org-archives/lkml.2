Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754626Ab2I0Dzq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 23:55:46 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:39979 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753744Ab2I0Dzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 23:55:45 -0400
From: Fabio Estevam <festevam@gmail.com>
To: sameo@linux.intel.com
Cc: broonie@opensource.wolfsonmicro.com, marex@denx.de,
        ashish.jangam@kpitcummins.com, dchen@diasemi.com,
        linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH] mfd: da9052-core: Fix request_threaded_irq() parameter
Date: Thu, 27 Sep 2012 00:55:35 -0300
Message-Id: <1348718135-10300-1-git-send-email-festevam@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabio Estevam <fabio.estevam@freescale.com>

On a mx53qsb dt-kernel the da9052-core driver fails to probe:

da9052 1-0048: DA9052 ADC IRQ failed ret=-22

In request_threaded_irq() the first parameter is missing the da9052->irq_base.

Fix it and avoid the error.

Also define 'DA9052_IRQF' for improving readability.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/mfd/da9052-core.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/mfd/da9052-core.c b/drivers/mfd/da9052-core.c
index a0a62b2..a3450d2 100644
--- a/drivers/mfd/da9052-core.c
+++ b/drivers/mfd/da9052-core.c
@@ -33,6 +33,7 @@
 #define DA9052_IRQ_MASK_POS_6		0x20
 #define DA9052_IRQ_MASK_POS_7		0x40
 #define DA9052_IRQ_MASK_POS_8		0x80
+#define DA9052_IRQF			(IRQF_TRIGGER_LOW | IRQF_ONESHOT)
 
 static bool da9052_reg_readable(struct device *dev, unsigned int reg)
 {
@@ -788,16 +789,15 @@ int __devinit da9052_device_init(struct da9052 *da9052, u8 chip_id)
 		da9052->irq_base = pdata->irq_base;
 
 	ret = regmap_add_irq_chip(da9052->regmap, da9052->chip_irq,
-				  IRQF_TRIGGER_LOW | IRQF_ONESHOT,
-				  da9052->irq_base, &da9052_regmap_irq_chip,
-				  &da9052->irq_data);
+				  DA9052_IRQF, da9052->irq_base,
+				  &da9052_regmap_irq_chip, &da9052->irq_data);
 	if (ret < 0)
 		goto regmap_err;
 
 	da9052->irq_base = regmap_irq_chip_get_base(da9052->irq_data);
 
-	ret = request_threaded_irq(DA9052_IRQ_ADC_EOM, NULL, da9052_auxadc_irq,
-				   IRQF_TRIGGER_LOW | IRQF_ONESHOT,
+	ret = request_threaded_irq(da9052->irq_base + DA9052_IRQ_ADC_EOM, NULL,
+				   da9052_auxadc_irq, DA9052_IRQF,
 				   "adc irq", da9052);
 	if (ret != 0)
 		dev_err(da9052->dev, "DA9052 ADC IRQ failed ret=%d\n", ret);
-- 
1.7.9.5

