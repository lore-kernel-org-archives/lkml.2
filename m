Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753098Ab1IFGwi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 02:52:38 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33729 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752743Ab1IFGwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 02:52:32 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] mfd: Support software initiated shutdown of WM831x PMICs
Date: Mon,  5 Sep 2011 23:52:28 -0700
Message-Id: <1315291948-3188-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In systems where there is no hardware signal from the processor to the
PMIC to initiate the final power off sequence we must initiate the
shutdown with a register write to the PMIC. Support such systems in the
driver. Since this may prevent a full shutdown of the system platform
data is used to enable the feature.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm831x-core.c        |   11 +++++++++++
 drivers/mfd/wm831x-i2c.c         |    8 ++++++++
 drivers/mfd/wm831x-spi.c         |    8 ++++++++
 include/linux/mfd/wm831x/core.h  |    3 +++
 include/linux/mfd/wm831x/pdata.h |    3 +++
 5 files changed, 33 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/wm831x-core.c b/drivers/mfd/wm831x-core.c
index 9338f8d..e758c89 100644
--- a/drivers/mfd/wm831x-core.c
+++ b/drivers/mfd/wm831x-core.c
@@ -25,6 +25,7 @@
 #include <linux/mfd/wm831x/irq.h>
 #include <linux/mfd/wm831x/auxadc.h>
 #include <linux/mfd/wm831x/otp.h>
+#include <linux/mfd/wm831x/pmu.h>
 #include <linux/mfd/wm831x/regulator.h>
 
 /* Current settings - values are 2*2^(reg_val/4) microamps.  These are
@@ -1621,6 +1622,7 @@ int wm831x_device_init(struct wm831x *wm831x, unsigned long id, int irq)
 	mutex_init(&wm831x->io_lock);
 	mutex_init(&wm831x->key_lock);
 	dev_set_drvdata(wm831x->dev, wm831x);
+	wm831x->soft_shutdown = pdata->soft_shutdown;
 
 	ret = wm831x_reg_read(wm831x, WM831X_PARENT_ID);
 	if (ret < 0) {
@@ -1922,6 +1924,15 @@ int wm831x_device_suspend(struct wm831x *wm831x)
 	return 0;
 }
 
+void wm831x_device_shutdown(struct wm831x *wm831x)
+{
+	if (wm831x->soft_shutdown) {
+		dev_info(wm831x->dev, "Initiating shutdown...\n");
+		wm831x_set_bits(wm831x, WM831X_POWER_STATE, WM831X_CHIP_ON, 0);
+	}
+}
+EXPORT_SYMBOL_GPL(wm831x_device_shutdown);
+
 MODULE_DESCRIPTION("Core support for the WM831X AudioPlus PMIC");
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Mark Brown");
diff --git a/drivers/mfd/wm831x-i2c.c b/drivers/mfd/wm831x-i2c.c
index 3ec6085..ac8da1d 100644
--- a/drivers/mfd/wm831x-i2c.c
+++ b/drivers/mfd/wm831x-i2c.c
@@ -65,6 +65,13 @@ static int wm831x_i2c_suspend(struct device *dev)
 	return wm831x_device_suspend(wm831x);
 }
 
+static void wm831x_i2c_shutdown(struct i2c_client *i2c)
+{
+	struct wm831x *wm831x = i2c_get_clientdata(i2c);
+
+	wm831x_device_shutdown(wm831x);
+}
+
 static const struct i2c_device_id wm831x_i2c_id[] = {
 	{ "wm8310", WM8310 },
 	{ "wm8311", WM8311 },
@@ -89,6 +96,7 @@ static struct i2c_driver wm831x_i2c_driver = {
 	},
 	.probe = wm831x_i2c_probe,
 	.remove = wm831x_i2c_remove,
+	.shutdown = wm831x_i2c_shutdown,
 	.id_table = wm831x_i2c_id,
 };
 
diff --git a/drivers/mfd/wm831x-spi.c b/drivers/mfd/wm831x-spi.c
index 5ea60cd..8d6a9a9 100644
--- a/drivers/mfd/wm831x-spi.c
+++ b/drivers/mfd/wm831x-spi.c
@@ -68,6 +68,13 @@ static int wm831x_spi_suspend(struct device *dev)
 	return wm831x_device_suspend(wm831x);
 }
 
+static void wm831x_spi_shutdown(struct spi_device *spi)
+{
+	struct wm831x *wm831x = dev_get_drvdata(&spi->dev);
+
+	wm831x_device_shutdown(wm831x);
+}
+
 static const struct dev_pm_ops wm831x_spi_pm = {
 	.freeze = wm831x_spi_suspend,
 	.suspend = wm831x_spi_suspend,
@@ -95,6 +102,7 @@ static struct spi_driver wm831x_spi_driver = {
 	.id_table	= wm831x_spi_ids,
 	.probe		= wm831x_spi_probe,
 	.remove		= __devexit_p(wm831x_spi_remove),
+	.shutdown	= wm831x_spi_shutdown,
 };
 
 static int __init wm831x_spi_init(void)
diff --git a/include/linux/mfd/wm831x/core.h b/include/linux/mfd/wm831x/core.h
index 44acdb2..ed8fe0d 100644
--- a/include/linux/mfd/wm831x/core.h
+++ b/include/linux/mfd/wm831x/core.h
@@ -371,6 +371,8 @@ struct wm831x {
 	int irq_masks_cur[WM831X_NUM_IRQ_REGS];   /* Currently active value */
 	int irq_masks_cache[WM831X_NUM_IRQ_REGS]; /* Cached hardware value */
 
+	bool soft_shutdown;
+
 	/* Chip revision based flags */
 	unsigned has_gpio_ena:1;         /* Has GPIO enable bit */
 	unsigned has_cs_sts:1;           /* Has current sink status bit */
@@ -409,6 +411,7 @@ int wm831x_bulk_read(struct wm831x *wm831x, unsigned short reg,
 int wm831x_device_init(struct wm831x *wm831x, unsigned long id, int irq);
 void wm831x_device_exit(struct wm831x *wm831x);
 int wm831x_device_suspend(struct wm831x *wm831x);
+void wm831x_device_shutdown(struct wm831x *wm831x);
 int wm831x_irq_init(struct wm831x *wm831x, int irq);
 void wm831x_irq_exit(struct wm831x *wm831x);
 void wm831x_auxadc_init(struct wm831x *wm831x);
diff --git a/include/linux/mfd/wm831x/pdata.h b/include/linux/mfd/wm831x/pdata.h
index 0ba2459..1d7a3f7 100644
--- a/include/linux/mfd/wm831x/pdata.h
+++ b/include/linux/mfd/wm831x/pdata.h
@@ -123,6 +123,9 @@ struct wm831x_pdata {
 	/** Disable the touchscreen */
 	bool disable_touch;
 
+	/** The driver should initiate a power off sequence during shutdown */
+	bool soft_shutdown;
+
 	int irq_base;
 	int gpio_base;
 	int gpio_defaults[WM831X_GPIO_NUM];
-- 
1.7.5.4

