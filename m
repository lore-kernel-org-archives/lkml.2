Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759578Ab2BNLDx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 06:03:53 -0500
Received: from skyrme.org ([193.175.80.135]:34712 "EHLO skyrme.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756575Ab2BNLDi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 06:03:38 -0500
Date: 14 Feb 2012 10:34:30 +0000
Message-Id: <1329215672-15706-6-git-send-email-oskar@scara.com>
From: "Oskar Schirmer" <oskar@scara.com>
To: sameo@linux.intel.com
Cc: dmitry.torokhov@gmail.com, kernel@pengutronix.de,
        u.kleine-koenig@pengutronix.de, philippe.retornaz@epfl.ch,
        michael.thalmeier@hale.at, linux-kernel@vger.kernel.org,
        "Oskar Schirmer" <oskar@scara.com>
Subject: [PATCH 5/7] input/touchscreen: add support for mc13892
X-Mailer: git-send-email 1.6.0.3
In-Reply-To: <1329215672-15706-1-git-send-email-oskar@scara.com>
References: <1329215672-15706-1-git-send-email-oskar@scara.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current driver mc13xxx_ts.c does provide support for
mc13783 chip, only. Add support for similar mc13892 chip,
rename a bunch of identifiers to reflect multichip support.

Signed-off-by: Oskar Schirmer <oskar@scara.com>
---
 drivers/input/touchscreen/Kconfig      |   10 +-
 drivers/input/touchscreen/Makefile     |    2 +-
 drivers/input/touchscreen/mc13xxx_ts.c |  166 +++++++++++++++++++++++++-------
 3 files changed, 137 insertions(+), 41 deletions(-)

diff --git a/drivers/input/touchscreen/Kconfig b/drivers/input/touchscreen/Kconfig
index 4af2a18..51d19cb 100644
--- a/drivers/input/touchscreen/Kconfig
+++ b/drivers/input/touchscreen/Kconfig
@@ -584,17 +584,17 @@ config TOUCHSCREEN_USB_COMPOSITE
 	  To compile this driver as a module, choose M here: the
 	  module will be called usbtouchscreen.
 
-config TOUCHSCREEN_MC13783
-	tristate "Freescale MC13783 touchscreen input driver"
-	depends on MFD_MC13783
+config TOUCHSCREEN_MC13XXX
+	tristate "Freescale MC13XXX touchscreen input driver"
+	depends on MFD_MC13XXX
 	help
-	  Say Y here if you have an Freescale MC13783 PMIC on your
+	  Say Y here if you have an Freescale MC13XXX PMIC on your
 	  board and want to use its touchscreen
 
 	  If unsure, say N.
 
 	  To compile this driver as a module, choose M here: the
-	  module will be called mc13783_ts.
+	  module will be called mc13xxx_ts.
 
 config TOUCHSCREEN_USB_EGALAX
 	default y
diff --git a/drivers/input/touchscreen/Makefile b/drivers/input/touchscreen/Makefile
index 07c031b..2c3afda 100644
--- a/drivers/input/touchscreen/Makefile
+++ b/drivers/input/touchscreen/Makefile
@@ -30,7 +30,7 @@ obj-$(CONFIG_TOUCHSCREEN_INEXIO)	+= inexio.o
 obj-$(CONFIG_TOUCHSCREEN_INTEL_MID)	+= intel-mid-touch.o
 obj-$(CONFIG_TOUCHSCREEN_LPC32XX)	+= lpc32xx_ts.o
 obj-$(CONFIG_TOUCHSCREEN_MAX11801)	+= max11801_ts.o
-obj-$(CONFIG_TOUCHSCREEN_MC13783)	+= mc13xxx_ts.o
+obj-$(CONFIG_TOUCHSCREEN_MC13XXX)	+= mc13xxx_ts.o
 obj-$(CONFIG_TOUCHSCREEN_MCS5000)	+= mcs5000_ts.o
 obj-$(CONFIG_TOUCHSCREEN_MIGOR)		+= migor_ts.o
 obj-$(CONFIG_TOUCHSCREEN_MTOUCH)	+= mtouch.o
diff --git a/drivers/input/touchscreen/mc13xxx_ts.c b/drivers/input/touchscreen/mc13xxx_ts.c
index ede0274..802228e 100644
--- a/drivers/input/touchscreen/mc13xxx_ts.c
+++ b/drivers/input/touchscreen/mc13xxx_ts.c
@@ -1,5 +1,5 @@
 /*
- * Driver for the Freescale Semiconductor MC13783 touchscreen.
+ * Driver for the Freescale Semiconductor MC13xxx touchscreen.
  *
  * Copyright 2004-2007 Freescale Semiconductor, Inc. All Rights Reserved.
  * Copyright (C) 2009 Sascha Hauer, Pengutronix
@@ -12,7 +12,7 @@
  * the Free Software Foundation.
  */
 #include <linux/platform_device.h>
-#include <linux/mfd/mc13783.h>
+#include <linux/mfd/mc13xxx.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/input.h>
@@ -20,7 +20,7 @@
 #include <linux/slab.h>
 #include <linux/init.h>
 
-#define MC13783_TS_NAME	"mc13783-ts"
+#define DRIVER_NAME	"mc13xxx-ts"
 
 #define DEFAULT_SAMPLE_TOLERANCE 300
 
@@ -33,7 +33,16 @@ MODULE_PARM_DESC(sample_tolerance,
 		"is supposed to be wrong and is discarded.  Set to 0 to "
 		"disable this check.");
 
-struct mc13783_ts_priv {
+#define DEFAULT_PRESSURE_LIMIT 2048
+
+static unsigned int pressure_limit = DEFAULT_PRESSURE_LIMIT;
+module_param(pressure_limit, uint, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(pressure_limit,
+		"Pressure values below this value (default: "
+		__stringify(DEFAULT_PRESSURE_LIMIT) ") are taken "
+		"as release event.");
+
+struct mc13xxx_ts_priv {
 	struct input_dev *idev;
 	struct mc13xxx *mc13xxx;
 	struct delayed_work work;
@@ -41,9 +50,9 @@ struct mc13783_ts_priv {
 	unsigned int sample[4];
 };
 
-static irqreturn_t mc13783_ts_handler(int irq, void *data)
+static irqreturn_t mc13xxx_ts_handler(int irq, void *data)
 {
-	struct mc13783_ts_priv *priv = data;
+	struct mc13xxx_ts_priv *priv = data;
 
 	mc13xxx_irq_ack(priv->mc13xxx, irq);
 
@@ -67,7 +76,7 @@ static irqreturn_t mc13783_ts_handler(int irq, void *data)
 			swap(a0, a1);					\
 		})
 
-static void mc13783_ts_report_sample(struct mc13783_ts_priv *priv)
+static void mc13783_ts_report_sample(struct mc13xxx_ts_priv *priv)
 {
 	struct input_dev *idev = priv->idev;
 	int x0, x1, x2, y0, y1, y2;
@@ -117,10 +126,63 @@ static void mc13783_ts_report_sample(struct mc13783_ts_priv *priv)
 		dev_dbg(&idev->dev, "discard event\n");
 }
 
+static void mc13892_ts_report_sample(struct mc13xxx_ts_priv *priv)
+{
+	struct input_dev *idev = priv->idev;
+	int x0, x1, y0, y1;
+	int cr0, cr1;
+
+	/*
+	 * the values are 10-bit wide only, but the two least significant
+	 * bits are for future 12 bit use and reading yields 0
+	 */
+	x0 = priv->sample[0] & 0xfff;
+	x1 = priv->sample[1] & 0xfff;
+	y0 = priv->sample[3] & 0xfff;
+	y1 = (priv->sample[0] >> 12) & 0xfff;
+	cr0 = (priv->sample[2] >> 12) & 0xfff;
+	cr1 = (priv->sample[3] >> 12) & 0xfff;
+
+	dev_dbg(&idev->dev,
+		"x: (% 4d,% 4d) y: (% 4d,% 4d) cr: (% 4d, % 4d)\n",
+		x0, x1, y0, y1, cr0, cr1);
+
+	if (x0 > x1)
+		swap(x0, x1);
+	if (y0 > y1)
+		swap(y0, y1);
+
+	cr0 = 0x1000 - ((cr0 + cr1) / 2);
+	if (cr0 < pressure_limit)
+		cr0 = 0;
+
+	if (!cr0 || !sample_tolerance ||
+			(x1 - x0 < sample_tolerance &&
+			 y1 - y0 < sample_tolerance)) {
+		/* report the average coordinate and pressure */
+		if (cr0) {
+			x0 = (x0 + x1) / 2;
+			y0 = (y0 + y1) / 2;
+			input_report_abs(idev, ABS_X, x0);
+			input_report_abs(idev, ABS_Y, y0);
+
+			dev_dbg(&idev->dev, "report (%d, %d, %d)\n",
+					x0, y0, cr0);
+			queue_delayed_work(priv->workq, &priv->work, HZ / 50);
+		} else
+			dev_dbg(&idev->dev, "report release\n");
+
+		input_report_abs(idev, ABS_PRESSURE, cr0);
+		input_report_key(idev, BTN_TOUCH, cr0);
+		input_sync(idev);
+	} else
+		dev_dbg(&idev->dev, "discard event\n");
+}
+
 static void mc13783_ts_work(struct work_struct *work)
 {
-	struct mc13783_ts_priv *priv =
-		container_of(work, struct mc13783_ts_priv, work.work);
+	struct mc13xxx_ts_priv *priv =
+		container_of(work, struct mc13xxx_ts_priv, work.work);
 	unsigned int mode = MC13XXX_ADC_MODE_TS;
 	unsigned int channel = 12;
 
@@ -129,9 +191,21 @@ static void mc13783_ts_work(struct work_struct *work)
 		mc13783_ts_report_sample(priv);
 }
 
-static int mc13783_ts_open(struct input_dev *dev)
+static void mc13892_ts_work(struct work_struct *work)
+{
+	struct mc13xxx_ts_priv *priv =
+		container_of(work, struct mc13xxx_ts_priv, work.work);
+	unsigned int mode = MC13XXX_ADC_MODE_TS;
+	unsigned int channel = 12;
+
+	if (mc13xxx_adc_do_conversion(priv->mc13xxx,
+				mode, channel, priv->sample) == 0)
+		mc13892_ts_report_sample(priv);
+}
+
+static int mc13xxx_ts_open(struct input_dev *dev)
 {
-	struct mc13783_ts_priv *priv = input_get_drvdata(dev);
+	struct mc13xxx_ts_priv *priv = input_get_drvdata(dev);
 	int ret;
 
 	mc13xxx_lock(priv->mc13xxx);
@@ -139,7 +213,7 @@ static int mc13783_ts_open(struct input_dev *dev)
 	mc13xxx_irq_ack(priv->mc13xxx, MC13XXX_IRQ_TS);
 
 	ret = mc13xxx_irq_request(priv->mc13xxx, MC13XXX_IRQ_TS,
-		mc13783_ts_handler, MC13783_TS_NAME, priv);
+		mc13xxx_ts_handler, DRIVER_NAME, priv);
 	if (ret)
 		goto out;
 
@@ -152,9 +226,9 @@ out:
 	return ret;
 }
 
-static void mc13783_ts_close(struct input_dev *dev)
+static void mc13xxx_ts_close(struct input_dev *dev)
 {
-	struct mc13783_ts_priv *priv = input_get_drvdata(dev);
+	struct mc13xxx_ts_priv *priv = input_get_drvdata(dev);
 
 	mc13xxx_lock(priv->mc13xxx);
 	mc13xxx_reg_rmw(priv->mc13xxx, MC13XXX_ADC0,
@@ -165,9 +239,9 @@ static void mc13783_ts_close(struct input_dev *dev)
 	cancel_delayed_work_sync(&priv->work);
 }
 
-static int __init mc13783_ts_probe(struct platform_device *pdev)
+static int __init mc13xxx_ts_probe(struct platform_device *pdev)
 {
-	struct mc13783_ts_priv *priv;
+	struct mc13xxx_ts_priv *priv;
 	struct input_dev *idev;
 	int ret = -ENOMEM;
 
@@ -176,19 +250,29 @@ static int __init mc13783_ts_probe(struct platform_device *pdev)
 	if (!priv || !idev)
 		goto err_free_mem;
 
-	INIT_DELAYED_WORK(&priv->work, mc13783_ts_work);
+	switch (platform_get_device_id(pdev)->driver_data) {
+	case MC13XXX_ID_MC13783:
+		INIT_DELAYED_WORK(&priv->work, mc13783_ts_work);
+		break;
+	case MC13XXX_ID_MC13892:
+		INIT_DELAYED_WORK(&priv->work, mc13892_ts_work);
+		break;
+	default:
+		goto err_free_mem;
+	}
+
 	priv->mc13xxx = dev_get_drvdata(pdev->dev.parent);
 	priv->idev = idev;
 
 	/*
-	 * We need separate workqueue because mc13783_adc_do_conversion
+	 * We need separate workqueue because mc13xxx_adc_do_conversion
 	 * uses keventd and thus would deadlock.
 	 */
-	priv->workq = create_singlethread_workqueue("mc13783_ts");
+	priv->workq = create_singlethread_workqueue("mc13xxx_ts");
 	if (!priv->workq)
 		goto err_free_mem;
 
-	idev->name = MC13783_TS_NAME;
+	idev->name = DRIVER_NAME;
 	idev->dev.parent = &pdev->dev;
 
 	idev->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_ABS);
@@ -197,8 +281,8 @@ static int __init mc13783_ts_probe(struct platform_device *pdev)
 	input_set_abs_params(idev, ABS_Y, 0, 0xfff, 0, 0);
 	input_set_abs_params(idev, ABS_PRESSURE, 0, 0xfff, 0, 0);
 
-	idev->open = mc13783_ts_open;
-	idev->close = mc13783_ts_close;
+	idev->open = mc13xxx_ts_open;
+	idev->close = mc13xxx_ts_close;
 
 	input_set_drvdata(idev, priv);
 
@@ -220,9 +304,9 @@ err_free_mem:
 	return ret;
 }
 
-static int __devexit mc13783_ts_remove(struct platform_device *pdev)
+static int __devexit mc13xxx_ts_remove(struct platform_device *pdev)
 {
-	struct mc13783_ts_priv *priv = platform_get_drvdata(pdev);
+	struct mc13xxx_ts_priv *priv = platform_get_drvdata(pdev);
 
 	platform_set_drvdata(pdev, NULL);
 
@@ -233,27 +317,39 @@ static int __devexit mc13783_ts_remove(struct platform_device *pdev)
 	return 0;
 }
 
-static struct platform_driver mc13783_ts_driver = {
-	.remove		= __devexit_p(mc13783_ts_remove),
+const struct platform_device_id mc13xxx_ts_idtable[] = {
+	{
+		.name = "mc13783-ts",
+		.driver_data = MC13XXX_ID_MC13783,
+	}, {
+		.name = "mc13892-ts",
+		.driver_data = MC13XXX_ID_MC13892,
+	},
+	{ }
+};
+
+static struct platform_driver mc13xxx_ts_driver = {
+	.id_table	= mc13xxx_ts_idtable,
+	.remove		= __devexit_p(mc13xxx_ts_remove),
 	.driver		= {
+		.name	= DRIVER_NAME,
 		.owner	= THIS_MODULE,
-		.name	= MC13783_TS_NAME,
 	},
 };
 
-static int __init mc13783_ts_init(void)
+static int __init mc13xxx_ts_init(void)
 {
-	return platform_driver_probe(&mc13783_ts_driver, &mc13783_ts_probe);
+	return platform_driver_probe(&mc13xxx_ts_driver, &mc13xxx_ts_probe);
 }
-module_init(mc13783_ts_init);
+module_init(mc13xxx_ts_init);
 
-static void __exit mc13783_ts_exit(void)
+static void __exit mc13xxx_ts_exit(void)
 {
-	platform_driver_unregister(&mc13783_ts_driver);
+	platform_driver_unregister(&mc13xxx_ts_driver);
 }
-module_exit(mc13783_ts_exit);
+module_exit(mc13xxx_ts_exit);
 
-MODULE_DESCRIPTION("MC13783 input touchscreen driver");
+MODULE_DESCRIPTION("MC13xxx input touchscreen driver");
 MODULE_AUTHOR("Sascha Hauer <s.hauer@pengutronix.de>");
 MODULE_LICENSE("GPL v2");
-MODULE_ALIAS("platform:" MC13783_TS_NAME);
+MODULE_ALIAS("platform:" DRIVER_NAME MC13XXX_TS_NAME);
-- 
1.7.5.4

