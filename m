Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965204Ab2JCRHX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 13:07:23 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:63045 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965185Ab2JCRHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 13:07:20 -0400
From: Fabio Estevam <festevam@gmail.com>
To: sameo@linux.intel.com
Cc: broonie@opensource.wolfsonmicro.com, ashish.jangam@kpitcummins.com,
        dchen@diasemi.com, arnd@arndb.de, kernel@pengutronix.de,
        dmitry.torokhov@gmail.com, linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: [RFC 1/3] mfd: da9052-core: Use regmap_irq_get_virq() and fix the probe
Date: Wed,  3 Oct 2012 14:06:57 -0300
Message-Id: <1349284019-31571-1-git-send-email-festevam@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabio Estevam <fabio.estevam@freescale.com>

On a mx53qsb dt-kernel the da9052-core driver fails to probe as follows:

da9052 1-0048: DA9052 ADC IRQ failed ret=-22

The reason for the error was due to passing only the offset as the interrupt
number in request_threaded_irq().

The recommended approach though is to use regmap_get_virq() to acquire the
interrupt number.

Fix it and allow the driver to probe successfully.

Also provide a few more error logs and change the irq string to "adc-irq", so
that it appears as a single word in 'cat /proc/inte

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/mfd/da9052-core.c         |   89 ++++++++++++++++++++++++++++++-------
 include/linux/mfd/da9052/da9052.h |    1 +
 2 files changed, 74 insertions(+), 16 deletions(-)

diff --git a/drivers/mfd/da9052-core.c b/drivers/mfd/da9052-core.c
index a0a62b2..6574242 100644
--- a/drivers/mfd/da9052-core.c
+++ b/drivers/mfd/da9052-core.c
@@ -16,6 +16,7 @@
 #include <linux/input.h>
 #include <linux/interrupt.h>
 #include <linux/irq.h>
+#include <linux/irqdomain.h>
 #include <linux/mfd/core.h>
 #include <linux/slab.h>
 #include <linux/module.h>
@@ -364,6 +365,52 @@ static const int32_t tbat_lookup[255] = {
 	-11823, -11903, -11982
 };
 
+static void da9052_irq_enable(struct irq_data *data)
+{
+}
+
+static void da9052_irq_disable(struct irq_data *data)
+{
+}
+
+static struct irq_chip da9052_irq_chip = {
+	.name			= "da9052",
+	.irq_disable		= da9052_irq_disable,
+	.irq_enable		= da9052_irq_enable,
+};
+
+static int da9052_irq_map(struct irq_domain *h, unsigned int virq,
+			      irq_hw_number_t hw)
+{
+	struct regmap_irq_chip_data *data = h->host_data;
+
+	irq_set_chip_data(virq, data);
+	irq_set_chip_and_handler(virq, &da9052_irq_chip, handle_edge_irq);
+	irq_set_nested_thread(virq, 1);
+
+	/*
+	 * ARM needs us to explicitly flag the IRQ as valid
+	 * and will set them noprobe when we do so.
+	 */
+#ifdef CONFIG_ARM
+	set_irq_flags(virq, IRQF_VALID);
+#else
+	irq_set_noprobe(virq);
+#endif
+
+	return 0;
+}
+
+static struct irq_domain_ops da9052_domain_ops = {
+	.map	= da9052_irq_map,
+	.xlate	= irq_domain_xlate_twocell,
+};
+
+static int da9052_map_irq(struct da9052 *da9052, int irq)
+{
+	return regmap_irq_get_virq(da9052->irq_data, irq);
+}
+
 static const u8 chan_mux[DA9052_ADC_VBBAT + 1] = {
 	[DA9052_ADC_VDDOUT]	= DA9052_ADC_MAN_MUXSEL_VDDOUT,
 	[DA9052_ADC_ICH]	= DA9052_ADC_MAN_MUXSEL_ICH,
@@ -772,7 +819,7 @@ EXPORT_SYMBOL_GPL(da9052_regmap_config);
 int __devinit da9052_device_init(struct da9052 *da9052, u8 chip_id)
 {
 	struct da9052_pdata *pdata = da9052->dev->platform_data;
-	int ret;
+	int ret, i;
 
 	mutex_init(&da9052->auxadc_lock);
 	init_completion(&da9052->done);
@@ -782,35 +829,44 @@ int __devinit da9052_device_init(struct da9052 *da9052, u8 chip_id)
 
 	da9052->chip_id = chip_id;
 
-	if (!pdata || !pdata->irq_base)
-		da9052->irq_base = -1;
-	else
-		da9052->irq_base = pdata->irq_base;
+	/* Allocate a virtual IRQ domain to distribute to the regmap domains */
+	da9052->virq = irq_domain_add_linear(NULL, ARRAY_SIZE(da9052_irqs),
+						&da9052_domain_ops, da9052);
+	if (!da9052->virq) {
+		ret = -EINVAL;
+		goto regmap_err;
+	}
 
-	ret = regmap_add_irq_chip(da9052->regmap, da9052->chip_irq,
+	ret = regmap_add_irq_chip(da9052->regmap,
+				  irq_create_mapping(da9052->virq, 0),
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
+	regmap_del_irq_chip(irq_create_mapping(da9052->virq, 0),
+			    da9052->irq_data);
 	mfd_remove_devices(da9052->dev);
 regmap_err:
 	return ret;
@@ -818,8 +874,9 @@ regmap_err:
 
 void da9052_device_exit(struct da9052 *da9052)
 {
-	free_irq(DA9052_IRQ_ADC_EOM, da9052);
-	regmap_del_irq_chip(da9052->chip_irq, da9052->irq_data);
+	free_irq(da9052_map_irq(da9052, DA9052_IRQ_ADC_EOM), da9052);
+	regmap_del_irq_chip(irq_create_mapping(da9052->virq, 0),
+			    da9052->irq_data);
 	mfd_remove_devices(da9052->dev);
 }
 
diff --git a/include/linux/mfd/da9052/da9052.h b/include/linux/mfd/da9052/da9052.h
index 0507c4c..7fbcb6d 100644
--- a/include/linux/mfd/da9052/da9052.h
+++ b/include/linux/mfd/da9052/da9052.h
@@ -99,6 +99,7 @@ struct da9052 {
 	u8 chip_id;
 
 	int chip_irq;
+	struct irq_domain *virq;
 };
 
 /* ADC API */
-- 
1.7.9.5

