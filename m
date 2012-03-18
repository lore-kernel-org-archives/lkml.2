Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752207Ab2CREF6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2012 00:05:58 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:52398 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155Ab2CREF4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2012 00:05:56 -0400
Date: Sat, 17 Mar 2012 21:05:49 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Ashish Jangam <ashish.jangam@kpitcummins.com>
Cc: sameo@linux.intel.com, m.grzeschik@pengutronix.de, randy.dunlap@oracle.com,
        linaro-dev@lists.linaro.org, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        David Dajun Chen <dchen@diasemi.com>
Subject: Re: [Patch 07/07] Touch: DA9052/53 touch screen driver v1
Message-ID: <20120318040549.GA19118@core.coreip.homeip.net>
References: <1328532695.30549.86.camel@dhruva>
 <1331641506.7058.0.camel@dhruva>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331641506.7058.0.camel@dhruva>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ashish,

On Tue, Mar 13, 2012 at 05:55:06PM +0530, Ashish Jangam wrote:
> Any update on the below patch

I looked the patch over and I think that the disabling of the IRQs in
da9052_ts_input_close() is racy. You can't read device status and
disable one IRQ or another as pendwn IRQ may fire right after you read
the register and you will disable the wrong one.

I tried correcting this problem and also did some more cosmetic changes,
could you please try the patch below and let me know if it works for
you?

Thanks!

-- 
Dmitry


Input: add support for DA9052/53 touch screen controller

From: Ashish Jangam <ashish.jangam@kpitcummins.com>

This driver adds support for DA9052/53 4-wire resistive ADC interfaced
touchscreen controller. DA9052/53 is a multi-function device, therefore
this driver depends on DA9052/53 core.

This patch is functionally tested on Samsung SMDKV6410.

Signed-off-by: David Dajun Chen <dchen@diasemi.com>
Signed-off-by: Ashish Jangam <ashish.jangam@kpitcummins.com>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/input/touchscreen/Kconfig      |   17 ++
 drivers/input/touchscreen/Makefile     |    1 
 drivers/input/touchscreen/da9052_tsi.c |  361 ++++++++++++++++++++++++++++++++
 3 files changed, 379 insertions(+), 0 deletions(-)
 create mode 100644 drivers/input/touchscreen/da9052_tsi.c


diff --git a/drivers/input/touchscreen/Kconfig b/drivers/input/touchscreen/Kconfig
index 97b31a0..3594591 100644
--- a/drivers/input/touchscreen/Kconfig
+++ b/drivers/input/touchscreen/Kconfig
@@ -187,6 +187,23 @@ config TOUCHSCREEN_DA9034
 	  Say Y here to enable the support for the touchscreen found
 	  on Dialog Semiconductor DA9034 PMIC.
 
+	  If unsure, say N.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called da9034-ts.
+
+config TOUCHSCREEN_DA9052
+	tristate "Dialog DA9052/DA9053 TSI"
+	depends on PMIC_DA9052
+	help
+	  Say Y here to support the touchscreen found on Dialog Semiconductor
+	  DA9052-BC and DA9053-AA/Bx PMICs.
+
+	  If unsure, say N.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called da9052_tsi.
+
 config TOUCHSCREEN_DYNAPRO
 	tristate "Dynapro serial touchscreen"
 	select SERIO
diff --git a/drivers/input/touchscreen/Makefile b/drivers/input/touchscreen/Makefile
index 3d5cf8c..b6c746e0 100644
--- a/drivers/input/touchscreen/Makefile
+++ b/drivers/input/touchscreen/Makefile
@@ -22,6 +22,7 @@ obj-$(CONFIG_TOUCHSCREEN_CYTTSP_CORE)	+= cyttsp_core.o
 obj-$(CONFIG_TOUCHSCREEN_CYTTSP_I2C)	+= cyttsp_i2c.o
 obj-$(CONFIG_TOUCHSCREEN_CYTTSP_SPI)	+= cyttsp_spi.o
 obj-$(CONFIG_TOUCHSCREEN_DA9034)	+= da9034-ts.o
+obj-$(CONFIG_TOUCHSCREEN_DA9052)	+= da9052_tsi.o
 obj-$(CONFIG_TOUCHSCREEN_DYNAPRO)	+= dynapro.o
 obj-$(CONFIG_TOUCHSCREEN_HAMPSHIRE)	+= hampshire.o
 obj-$(CONFIG_TOUCHSCREEN_GUNZE)		+= gunze.o
diff --git a/drivers/input/touchscreen/da9052_tsi.c b/drivers/input/touchscreen/da9052_tsi.c
new file mode 100644
index 0000000..76fad0e
--- /dev/null
+++ b/drivers/input/touchscreen/da9052_tsi.c
@@ -0,0 +1,361 @@
+/*
+ * TSI driver for Dialog DA9052
+ *
+ * Copyright(c) 2012 Dialog Semiconductor Ltd.
+ *
+ * Author: David Dajun Chen <dchen@diasemi.com>
+ *
+ *  This program is free software; you can redistribute  it and/or modify it
+ *  under  the terms of  the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the  License, or (at your
+ *  option) any later version.
+ *
+ */
+#include <linux/module.h>
+#include <linux/input.h>
+#include <linux/delay.h>
+#include <linux/platform_device.h>
+#include <linux/interrupt.h>
+
+#include <linux/mfd/da9052/reg.h>
+#include <linux/mfd/da9052/da9052.h>
+
+#define TSI_PEN_DOWN_STATUS 0x40
+
+struct da9052_tsi {
+	struct da9052 *da9052;
+	struct input_dev *dev;
+	struct delayed_work ts_pen_work;
+	struct mutex mutex;
+	unsigned int irq_pendwn;
+	unsigned int irq_datardy;
+	bool stopped;
+	bool adc_on;
+};
+
+static void da9052_ts_adc_toggle(struct da9052_tsi *tsi, bool on)
+{
+	da9052_reg_update(tsi->da9052, DA9052_TSI_CONT_A_REG, 1 << 0, on);
+	tsi->adc_on = on;
+}
+
+static irqreturn_t da9052_ts_pendwn_irq(int irq, void *data)
+{
+	struct da9052_tsi *tsi = data;
+
+	if (!tsi->stopped) {
+		/* Mask PEN_DOWN event and unmask TSI_READY event */
+		disable_irq_nosync(tsi->irq_pendwn);
+		enable_irq(tsi->irq_datardy);
+
+		da9052_ts_adc_toggle(tsi, true);
+
+		schedule_delayed_work(&tsi->ts_pen_work, HZ / 50);
+	}
+
+	return IRQ_HANDLED;
+}
+
+static void da9052_ts_read(struct da9052_tsi *tsi)
+{
+	struct input_dev *input = tsi->dev;
+	int ret;
+	u16 x, y, z;
+	u8 v;
+
+	ret = da9052_reg_read(tsi->da9052, DA9052_TSI_X_MSB_REG);
+	if (ret < 0)
+		return;
+
+	x = (u16) ret;
+
+	ret = da9052_reg_read(tsi->da9052, DA9052_TSI_Y_MSB_REG);
+	if (ret < 0)
+		return;
+
+	y = (u16) ret;
+
+	ret = da9052_reg_read(tsi->da9052, DA9052_TSI_Z_MSB_REG);
+	if (ret < 0)
+		return;
+
+	z = (u16) ret;
+
+	ret = da9052_reg_read(tsi->da9052, DA9052_TSI_LSB_REG);
+	if (ret < 0)
+		return;
+
+	v = (u8) ret;
+
+	x = ((x << 2) & 0x3fc) | (v & 0x3);
+	y = ((y << 2) & 0x3fc) | ((v & 0xc) >> 2);
+	z = ((z << 2) & 0x3fc) | ((v & 0x30) >> 4);
+
+	input_report_key(input, BTN_TOUCH, 1);
+	input_report_abs(input, ABS_X, x);
+	input_report_abs(input, ABS_Y, y);
+	input_report_abs(input, ABS_PRESSURE, z);
+	input_sync(input);
+}
+
+static irqreturn_t da9052_ts_datardy_irq(int irq, void *data)
+{
+	struct da9052_tsi *tsi = data;
+
+	da9052_ts_read(tsi);
+
+	return IRQ_HANDLED;
+}
+
+static void da9052_ts_pen_work(struct work_struct *work)
+{
+	struct da9052_tsi *tsi = container_of(work, struct da9052_tsi,
+					      ts_pen_work.work);
+	if (!tsi->stopped) {
+		int ret = da9052_reg_read(tsi->da9052, DA9052_TSI_LSB_REG);
+		if (ret < 0 || (ret & TSI_PEN_DOWN_STATUS)) {
+			/* Pen is still DOWN (or read error) */
+			schedule_delayed_work(&tsi->ts_pen_work, HZ / 50);
+		} else {
+			struct input_dev *input = tsi->dev;
+
+			/* Pen UP */
+			da9052_ts_adc_toggle(tsi, false);
+
+			/* Report Pen UP */
+			input_report_key(input, BTN_TOUCH, 0);
+			input_report_abs(input, ABS_PRESSURE, 0);
+			input_sync(input);
+
+			/* Mask TSI_READY event and unmask PEN_DOWN event */
+			disable_irq(tsi->irq_datardy);
+			enable_irq(tsi->irq_pendwn);
+		}
+	}
+}
+
+static int __devinit da9052_ts_configure_gpio(struct da9052 *da9052)
+{
+	int error;
+
+	error = da9052_reg_update(da9052, DA9052_GPIO_2_3_REG, 0x30, 0);
+	if (error < 0)
+		return error;
+
+	error = da9052_reg_update(da9052, DA9052_GPIO_4_5_REG, 0x33, 0);
+	if (error < 0)
+		return error;
+
+	error = da9052_reg_update(da9052, DA9052_GPIO_6_7_REG, 0x33, 0);
+	if (error < 0)
+		return error;
+
+	return 0;
+}
+
+static int __devinit da9052_configure_tsi(struct da9052_tsi *tsi)
+{
+	int error;
+
+	error = da9052_ts_configure_gpio(tsi->da9052);
+	if (error)
+		return error;
+
+	/* Measure TSI sample every 1ms */
+	error = da9052_reg_update(tsi->da9052, DA9052_ADC_CONT_REG,
+				  1 << 6, 1 << 6);
+	if (error < 0)
+		return error;
+
+	/* TSI_DELAY: 3 slots, TSI_SKIP: 0 slots, TSI_MODE: XYZP */
+	error = da9052_reg_update(tsi->da9052, DA9052_TSI_CONT_A_REG, 0xFC, 0xC0);
+	if (error < 0)
+		return error;
+
+	/* Supply TSIRef through LD09 */
+	error = da9052_reg_write(tsi->da9052, DA9052_LDO9_REG, 0x59);
+	if (error < 0)
+		return error;
+
+	return 0;
+}
+
+static int da9052_ts_input_open(struct input_dev *input_dev)
+{
+	struct da9052_tsi *tsi = input_get_drvdata(input_dev);
+
+	tsi->stopped = false;
+	mb();
+
+	/* Unmask PEN_DOWN event */
+	enable_irq(tsi->irq_pendwn);
+
+	/* Enable Pen Detect Circuit */
+	return da9052_reg_update(tsi->da9052, DA9052_TSI_CONT_A_REG,
+				 1 << 1, 1 << 1);
+}
+
+static void da9052_ts_input_close(struct input_dev *input_dev)
+{
+	struct da9052_tsi *tsi = input_get_drvdata(input_dev);
+
+	tsi->stopped = true;
+	mb();
+	disable_irq(tsi->irq_pendwn);
+	cancel_delayed_work_sync(&tsi->ts_pen_work);
+
+	if (tsi->adc_on) {
+		disable_irq(tsi->irq_datardy);
+		da9052_ts_adc_toggle(tsi, false);
+
+		/*
+		 * If ADC was on that means that pendwn IRQ was disabled
+		 * twice and we need to enable it to keep enable/disable
+		 * counter balanced. IRQ is still off though.
+		 */
+		enable_irq(tsi->irq_pendwn);
+	}
+
+	/* Disable Pen Detect Circuit */
+	da9052_reg_update(tsi->da9052, DA9052_TSI_CONT_A_REG, 1 << 1, 0);
+}
+
+static int __devinit da9052_ts_probe(struct platform_device *pdev)
+{
+	struct da9052 *da9052;
+	struct da9052_tsi *tsi;
+	struct input_dev *input_dev;
+	int irq_pendwn;
+	int irq_datardy;
+	int error;
+
+	da9052 = dev_get_drvdata(pdev->dev.parent);
+	if (!da9052)
+		return -EINVAL;
+
+	irq_pendwn = platform_get_irq_byname(pdev, "PENDWN");
+	irq_datardy = platform_get_irq_byname(pdev, "TSIRDY");
+	if (irq_pendwn < 0 || irq_datardy < 0) {
+		dev_err(da9052->dev, "Unable to determine device interrupts\n");
+		return -ENXIO;
+	}
+
+	tsi = kzalloc(sizeof(struct da9052_tsi), GFP_KERNEL);
+	input_dev = input_allocate_device();
+	if (!tsi || !input_dev) {
+		error = -ENOMEM;
+		goto err_free_mem;
+	}
+
+	tsi->da9052 = da9052;
+	tsi->dev = input_dev;
+	tsi->irq_pendwn = irq_pendwn;
+	tsi->irq_datardy = irq_datardy;
+	tsi->stopped = true;
+	INIT_DELAYED_WORK(&tsi->ts_pen_work, da9052_ts_pen_work);
+
+	input_dev->id.version = 0x0101;
+	input_dev->id.vendor = 0x15B6;
+	input_dev->id.product = 0x9052;
+	input_dev->name = "Dialog DA9052 TouchScreen Driver";
+	input_dev->dev.parent = &pdev->dev;
+	input_dev->open = da9052_ts_input_open;
+	input_dev->close = da9052_ts_input_close;
+
+	__set_bit(EV_ABS, input_dev->evbit);
+	__set_bit(EV_KEY, input_dev->evbit);
+	__set_bit(BTN_TOUCH, input_dev->keybit);
+
+	input_set_abs_params(input_dev, ABS_X, 0, 1023, 0, 0);
+	input_set_abs_params(input_dev, ABS_Y, 0, 1023, 0, 0);
+	input_set_abs_params(input_dev, ABS_PRESSURE, 0, 1023, 0, 0);
+
+	input_set_drvdata(input_dev, tsi);
+
+	/* Disable Pen Detect Circuit */
+	da9052_reg_update(tsi->da9052, DA9052_TSI_CONT_A_REG, 1 << 1, 0);
+
+	/* Disable ADC */
+	da9052_ts_adc_toggle(tsi, true);
+
+	error = request_threaded_irq(tsi->irq_pendwn,
+				     NULL, da9052_ts_pendwn_irq,
+				     IRQF_TRIGGER_LOW | IRQF_ONESHOT,
+				     "PENDWN", tsi);
+	if (error) {
+		dev_err(tsi->da9052->dev,
+			"Failed to register PENDWN IRQ %d, error = %d\n",
+			tsi->irq_pendwn, error);
+		goto err_free_mem;
+	}
+
+	error = request_threaded_irq(tsi->irq_datardy,
+				     NULL, da9052_ts_datardy_irq,
+				     IRQF_TRIGGER_LOW | IRQF_ONESHOT,
+				     "TSIRDY", tsi);
+	if (error) {
+		dev_err(tsi->da9052->dev,
+			"Failed to register TSIRDY IRQ %d, error = %d\n",
+			tsi->irq_datardy, error);
+		goto err_free_pendwn_irq;
+	}
+
+	/* Mask PEN_DOWN and TSI_READY events */
+	disable_irq(tsi->irq_pendwn);
+	disable_irq(tsi->irq_datardy);
+
+	error = da9052_configure_tsi(tsi);
+	if (error)
+		goto err_free_datardy_irq;
+
+	error = input_register_device(tsi->dev);
+	if (error)
+		goto err_free_datardy_irq;
+
+	platform_set_drvdata(pdev, tsi);
+
+	return 0;
+
+err_free_datardy_irq:
+	free_irq(tsi->irq_datardy, tsi);
+err_free_pendwn_irq:
+	free_irq(tsi->irq_pendwn, tsi);
+err_free_mem:
+	kfree(tsi);
+	input_free_device(input_dev);
+
+	return error;
+}
+
+static int  __devexit da9052_ts_remove(struct platform_device *pdev)
+{
+	struct da9052_tsi *tsi = platform_get_drvdata(pdev);
+
+	da9052_reg_write(tsi->da9052, DA9052_LDO9_REG, 0x19);
+
+	free_irq(tsi->irq_pendwn, tsi);
+	free_irq(tsi->irq_datardy, tsi);
+
+	input_unregister_device(tsi->dev);
+	kfree(tsi);
+
+	platform_set_drvdata(pdev, NULL);
+
+	return 0;
+}
+
+static struct platform_driver da9052_tsi_driver = {
+	.probe	= da9052_ts_probe,
+	.remove	= __devexit_p(da9052_ts_remove),
+	.driver	= {
+		.name	= "da9052-tsi",
+		.owner	= THIS_MODULE,
+	},
+};
+
+module_platform_driver(da9052_tsi_driver);
+
+MODULE_DESCRIPTION("Touchscreen driver for Dialog Semiconductor DA9052");
+MODULE_AUTHOR("David Dajun Chen <dchen@diasemi.com>");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:da9052-tsi");
