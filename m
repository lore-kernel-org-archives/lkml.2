Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752050Ab2JDDPs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 23:15:48 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:54509 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751126Ab2JDDPq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 23:15:46 -0400
From: Fabio Estevam <festevam@gmail.com>
To: sameo@linux.intel.com
Cc: broonie@opensource.wolfsonmicro.com, ashish.jangam@kpitcummins.com,
        dchen@diasemi.com, arnd@arndb.de, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH 1/6] mfd: da9052-core: Use regmap_irq_get_virq() and fix the probe
Date: Thu,  4 Oct 2012 00:15:04 -0300
Message-Id: <1349320509-26930-1-git-send-email-festevam@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabio Estevam <fabio.estevam@freescale.com>

On a mx53qsb dt-kernel the da9052-core driver fails to probe as follows:

da9052 1-0048: DA9052 ADC IRQ failed ret=-22

The reason for the error was due to passing only the offset as the interrupt
number in request_threaded_irq() without da9052->irq_base.

The recommended approach though is to use regmap_get_virq() to acquire the
interrupt number and this allows to get rid of da9052->irq_base.

Fix it and allow the driver to probe successfully.

Also provide a few more error logs and change the irq string to "adc-irq", so
that it appears as a single word in 'cat /proc/interrupts'

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/mfd/da9052-core.c |   34 +++++++++++++++++++---------------
 1 file changed, 19 insertions(+), 15 deletions(-)

diff --git a/drivers/mfd/da9052-core.c b/drivers/mfd/da9052-core.c
index a0a62b2..c96cdbc 100644
--- a/drivers/mfd/da9052-core.c
+++ b/drivers/mfd/da9052-core.c
@@ -769,10 +769,15 @@ struct regmap_config da9052_regmap_config = {
 };
 EXPORT_SYMBOL_GPL(da9052_regmap_config);
 
+static int da9052_map_irq(struct da9052 *da9052, int irq)
+{
+	return regmap_irq_get_virq(da9052->irq_data, irq);
+}
+
 int __devinit da9052_device_init(struct da9052 *da9052, u8 chip_id)
 {
 	struct da9052_pdata *pdata = da9052->dev->platform_data;
-	int ret;
+	int ret, i;
 
 	mutex_init(&da9052->auxadc_lock);
 	init_completion(&da9052->done);
@@ -782,35 +787,34 @@ int __devinit da9052_device_init(struct da9052 *da9052, u8 chip_id)
 
 	da9052->chip_id = chip_id;
 
-	if (!pdata || !pdata->irq_base)
-		da9052->irq_base = -1;
-	else
-		da9052->irq_base = pdata->irq_base;
-
 	ret = regmap_add_irq_chip(da9052->regmap, da9052->chip_irq,
 				  IRQF_TRIGGER_LOW | IRQF_ONESHOT,
-				  da9052->irq_base, &da9052_regmap_irq_chip,
+				  -1, &da9052_regmap_irq_chip,
 				  &da9052->irq_data);
-	if (ret < 0)
+	if (ret < 0) {
+		dev_err(da9052->dev, "regmap_add_irq_chip failed: %d\n", ret);
 		goto regmap_err;
+	}
 
-	da9052->irq_base = regmap_irq_chip_get_base(da9052->irq_data);
-
-	ret = request_threaded_irq(DA9052_IRQ_ADC_EOM, NULL, da9052_auxadc_irq,
+	i = da9052_map_irq(da9052, DA9052_IRQ_ADC_EOM);
+	ret = request_threaded_irq(i, NULL, da9052_auxadc_irq,
 				   IRQF_TRIGGER_LOW | IRQF_ONESHOT,
-				   "adc irq", da9052);
+				   "adc-irq", da9052);
 	if (ret != 0)
 		dev_err(da9052->dev, "DA9052 ADC IRQ failed ret=%d\n", ret);
 
 	ret = mfd_add_devices(da9052->dev, -1, da9052_subdev_info,
 			      ARRAY_SIZE(da9052_subdev_info), NULL, 0, NULL);
-	if (ret)
+	if (ret) {
+		dev_err(da9052->dev, "mfd_add_devices failed: %d\n", ret);
 		goto err;
+	}
 
 	return 0;
 
 err:
-	free_irq(DA9052_IRQ_ADC_EOM, da9052);
+	free_irq(da9052_map_irq(da9052, DA9052_IRQ_ADC_EOM), da9052);
+	regmap_del_irq_chip(da9052->chip_irq, da9052->irq_data);
 	mfd_remove_devices(da9052->dev);
 regmap_err:
 	return ret;
@@ -818,7 +822,7 @@ regmap_err:
 
 void da9052_device_exit(struct da9052 *da9052)
 {
-	free_irq(DA9052_IRQ_ADC_EOM, da9052);
+	free_irq(da9052_map_irq(da9052, DA9052_IRQ_ADC_EOM), da9052);
 	regmap_del_irq_chip(da9052->chip_irq, da9052->irq_data);
 	mfd_remove_devices(da9052->dev);
 }
-- 
1.7.9.5

