Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755274Ab2JCNXM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 09:23:12 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:19361 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755236Ab2JCNXK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 09:23:10 -0400
X-Forefront-Antispam-Report: CIP:59.163.77.45;KIP:(null);UIP:(null);IPV:NLI;H:KCHJEXHC01.kpit.com;RD:59.163.77.45.static.vsnl.net.in;EFVD:NLI
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202h1d1ah1d2ahzz8275bhz2dh2a8h668h839h93fhd24hd2bhf0ah107ah1288h12a5h12a9h12bdh137ah139eh13b6h1441hbe9i1155h)
Subject: [PATCH] [PATCH v3] mfd: da9052-core:  Use regmap_irq_get_virq()
 and fix the probe
From: Ashish Jangam <ashish.jangam@kpitcummins.com>
To: <sameo@linux.intel.com>
CC: <broonie@opensource.wolfsonmicro.com>, <marex@denx.de>,
        <dchen@diasemi.com>, <arnd@arndb.de>, <kernel@pengutronix.de>,
        <linux-kernel@vger.kernel.org>, <fabio.estevam@freescale.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 3 Oct 2012 19:03:13 +0530
Message-ID: <1349271193.9129.2.camel@dhruva>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.10.38.47]
X-OriginatorOrg: kpitcummins.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix for da9052-core driver probe fail on a mx53qsb dt-kernel
da9052 1-0048: DA9052 ADC IRQ failed ret=-22

Signed-off-by: Ashish Jangam <ashish.jangam@kpitcummins.com>
---
changes since v3:
- remove element "irq" from struct da9052
- add inline da9052_map_irq() that calls regmap_irq_get_virq()
Changes since v2:
- Use regmap_irq_get_virq() instead of relying on irq_base
---
 drivers/mfd/da9052-core.c         |   31 ++++++++++++++++---------------
 include/linux/mfd/da9052/da9052.h |    5 +++++
 2 files changed, 21 insertions(+), 15 deletions(-)

diff --git a/drivers/mfd/da9052-core.c b/drivers/mfd/da9052-core.c
index 2544910..e38c2e0 100644
--- a/drivers/mfd/da9052-core.c
+++ b/drivers/mfd/da9052-core.c
@@ -772,7 +772,7 @@ EXPORT_SYMBOL_GPL(da9052_regmap_config);
 int __devinit da9052_device_init(struct da9052 *da9052, u8 chip_id)
 {
 	struct da9052_pdata *pdata = da9052->dev->platform_data;
-	int ret;
+	int ret, adc_irq;
 
 	mutex_init(&da9052->auxadc_lock);
 	init_completion(&da9052->done);
@@ -782,25 +782,26 @@ int __devinit da9052_device_init(struct da9052 *da9052, u8 chip_id)
 
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
 
 	da9052->irq_base = regmap_irq_chip_get_base(da9052->irq_data);
 
-	ret = request_threaded_irq(DA9052_IRQ_ADC_EOM, NULL, da9052_auxadc_irq,
-				   IRQF_TRIGGER_LOW | IRQF_ONESHOT,
-				   "adc irq", da9052);
-	if (ret != 0)
-		dev_err(da9052->dev, "DA9052 ADC IRQ failed ret=%d\n", ret);
+	adc_irq = da9052_map_irq(da9052, DA9052_IRQ_ADC_EOM);
+	if (adc_irq >= 0) {
+		ret = request_threaded_irq(adc_irq, NULL, da9052_auxadc_irq,
+					   IRQF_TRIGGER_LOW | IRQF_ONESHOT,
+					   "adc-irq", da9052);
+		if (ret != 0)
+			dev_err(da9052->dev, "DA9052 ADC IRQ failed ret=%d\n",
+				ret);
+	}
 
 	ret = mfd_add_devices(da9052->dev, -1, da9052_subdev_info,
 			      ARRAY_SIZE(da9052_subdev_info), NULL, 0);
@@ -810,7 +811,7 @@ int __devinit da9052_device_init(struct da9052 *da9052, u8 chip_id)
 	return 0;
 
 err:
-	free_irq(DA9052_IRQ_ADC_EOM, da9052);
+	free_irq(adc_irq, da9052);
 	mfd_remove_devices(da9052->dev);
 regmap_err:
 	return ret;
@@ -818,7 +819,7 @@ regmap_err:
 
 void da9052_device_exit(struct da9052 *da9052)
 {
-	free_irq(DA9052_IRQ_ADC_EOM, da9052);
+	free_irq(da9052_map_irq(da9052, DA9052_IRQ_ADC_EOM), da9052);
 	regmap_del_irq_chip(da9052->chip_irq, da9052->irq_data);
 	mfd_remove_devices(da9052->dev);
 }
diff --git a/include/linux/mfd/da9052/da9052.h b/include/linux/mfd/da9052/da9052.h
index 0507c4c..1abce88 100644
--- a/include/linux/mfd/da9052/da9052.h
+++ b/include/linux/mfd/da9052/da9052.h
@@ -141,6 +141,11 @@ static inline int da9052_reg_update(struct da9052 *da9052, unsigned char reg,
 	return regmap_update_bits(da9052->regmap, reg, bit_mask, reg_val);
 }
 
+static inline int da9052_map_irq(struct da9052 *da9052, int irq)
+{
+	return regmap_irq_get_virq(da9052->irq_data, irq);
+}
+
 int da9052_device_init(struct da9052 *da9052, u8 chip_id);
 void da9052_device_exit(struct da9052 *da9052);
 
-- 
1.7.0.4


