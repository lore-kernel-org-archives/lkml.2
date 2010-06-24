Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755225Ab0FXLO4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 07:14:56 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:52572 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754991Ab0FXLON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 07:14:13 -0400
From: Luotao Fu <l.fu@pengutronix.de>
To: Rabin VINCENT <rabin.vincent@stericsson.com>,
       Samuel Ortiz <sameo@linux.intel.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Linus WALLEIJ <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org,
       STEricsson_nomadik_linux <STEricsson_nomadik_linux@list.st.com>,
       Luotao Fu <l.fu@pengutronix.de>
Subject: [PATCH 6/6 V4] input: STMPE touch controller support
Date: Thu, 24 Jun 2010 13:13:41 +0200
Message-Id: <1277378021-16802-7-git-send-email-l.fu@pengutronix.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20100622135635.GA30720@bnru02.bnr.st.com>
References: <20100622135635.GA30720@bnru02.bnr.st.com>
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: l.fu@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This one adds a driver for STMPE touchscreen controllers. This driver depends on
stmpexxx mfd core driver.

Signed-off-by: Luotao Fu <l.fu@pengutronix.de>

---
V2 Changes:
* include subsystem headers since they are now remove from the mfd
  core header file
* use genirq to register threaded isr. The stmpe811 own irq callbacks
  are dropped in the core driver.
* use STMPE811_TS_NAME for name all over the place
* wait for completion of core IO operation before cancelling polling of
  release event.
* switch to platform data for configuration parameters.
* add FIFO reset to open callback, also reset FIFO before reporting
  release.

V3 Changes:
* reformated platform data comments to kernel-doc style

V4 Changes:
* converted to stmpexxx core by Rabin Vincent <rabin.vincent@stericsson.com>
* wait for running workqueue callback to finish while canceling the queue
* add i_drive configuration support

 drivers/input/touchscreen/Kconfig    |   10 +
 drivers/input/touchscreen/Makefile   |    1 +
 drivers/input/touchscreen/stmpe-ts.c |  380 ++++++++++++++++++++++++++++++++++
 3 files changed, 391 insertions(+), 0 deletions(-)
 create mode 100644 drivers/input/touchscreen/stmpe-ts.c

diff --git a/drivers/input/touchscreen/Kconfig b/drivers/input/touchscreen/Kconfig
index 3b9d5e2..96a9954 100644
--- a/drivers/input/touchscreen/Kconfig
+++ b/drivers/input/touchscreen/Kconfig
@@ -603,4 +603,14 @@ config TOUCHSCREEN_TPS6507X
 	  To compile this driver as a module, choose M here: the
 	  module will be called tps6507x_ts.
 
+config TOUCHSCREEN_STMPE
+	tristate "STMicroelectronics STMPE touchscreens"
+	depends on MFD_STMPE
+	help
+	  Say Y here if you want support for STMicroelectronics
+	  STMPE touchscreen controllers.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called stmpe-ts.
+
 endif
diff --git a/drivers/input/touchscreen/Makefile b/drivers/input/touchscreen/Makefile
index 497964a..2691c62 100644
--- a/drivers/input/touchscreen/Makefile
+++ b/drivers/input/touchscreen/Makefile
@@ -47,3 +47,4 @@ obj-$(CONFIG_TOUCHSCREEN_WM97XX_MAINSTONE)	+= mainstone-wm97xx.o
 obj-$(CONFIG_TOUCHSCREEN_WM97XX_ZYLONITE)	+= zylonite-wm97xx.o
 obj-$(CONFIG_TOUCHSCREEN_W90X900)	+= w90p910_ts.o
 obj-$(CONFIG_TOUCHSCREEN_TPS6507X)	+= tps6507x-ts.o
+obj-$(CONFIG_TOUCHSCREEN_STMPE)		+= stmpe-ts.o
diff --git a/drivers/input/touchscreen/stmpe-ts.c b/drivers/input/touchscreen/stmpe-ts.c
new file mode 100644
index 0000000..260b175
--- /dev/null
+++ b/drivers/input/touchscreen/stmpe-ts.c
@@ -0,0 +1,380 @@
+/* STMicroelectronics STMPE811 Touchscreen Driver
+ *
+ * (C) 2010 Luotao Fu <l.fu@pengutronix.de>
+ * All rights reserved.
+ *
+ *  This program is free software; you can redistribute  it and/or modify it
+ *  under  the terms of  the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the  License, or (at your
+ *  option) any later version.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/sched.h>
+#include <linux/interrupt.h>
+#include <linux/init.h>
+#include <linux/device.h>
+#include <linux/platform_device.h>
+#include <linux/input.h>
+#include <linux/slab.h>
+#include <linux/delay.h>
+#include <linux/i2c.h>
+#include <linux/workqueue.h>
+
+#include <linux/mfd/stmpe.h>
+
+/* Register layouts and functionalities are identical on all stmpexxx variants
+ * with touchscreen controller
+ */
+#define STMPE_REG_INT_STA		0x0B
+#define STMPE_REG_ADC_CTRL1		0x20
+#define STMPE_REG_ADC_CTRL2		0x21
+#define STMPE_REG_TSC_CTRL		0x40
+#define STMPE_REG_TSC_CFG		0x41
+#define STMPE_REG_FIFO_TH		0x4A
+#define STMPE_REG_FIFO_STA		0x4B
+#define STMPE_REG_FIFO_SIZE		0x4C
+#define STMPE_REG_TSC_DATA_XYZ		0x52
+#define STMPE_REG_TSC_FRACTION_Z	0x56
+#define STMPE_REG_TSC_I_DRIVE		0x58
+
+#define STMPE_TSC_CTRL_OP_MOD_XYZ	(0<<1)
+
+#define STMPE_TSC_CTRL_TSC_EN		(1<<0)
+
+#define STMPE_FIFO_STA_RESET		(1<<0)
+
+#define STMPE_IRQ_TOUCH_DET		0
+
+#define SAMPLE_TIME(x)			((x & 0xf) << 4)
+#define MOD_12B(x)			((x & 0x1) << 3)
+#define REF_SEL(x)			((x & 0x1) << 1)
+#define ADC_FREQ(x)			(x & 0x3)
+#define AVE_CTRL(x)			((x & 0x3) << 6)
+#define DET_DELAY(x)			((x & 0x7) << 3)
+#define SETTLING(x)			(x & 0x7)
+#define FRACTION_Z(x)			(x & 0x7)
+#define I_DRIVE(x)			(x & 0x1)
+
+#define STMPE_TS_NAME			"stmpe-ts"
+#define XY_MASK				0xfff
+
+struct stmpe_touch {
+	struct stmpe *stmpe;
+	struct input_dev *idev;
+	struct delayed_work work;
+	u8 sample_time;
+	u8 mod_12b;
+	u8 ref_sel;
+	u8 adc_freq;
+	u8 ave_ctrl;
+	u8 touch_det_delay;
+	u8 settling;
+	u8 fraction_z;
+	u8 i_drive;
+};
+
+static void stmpe_work(struct work_struct *work)
+{
+	int int_sta;
+	u32 timeout = 40;
+
+	struct stmpe_touch *ts =
+	    container_of(work, struct stmpe_touch, work.work);
+
+	int_sta = stmpe_reg_read(ts->stmpe, STMPE_REG_INT_STA);
+
+	/* touch_det sometimes get desasserted or just get stuck. This appears
+	 * to be a silicon bug, We still have to clearify this with the
+	 * manufacture. As a workaround We release the key anyway if the
+	 * touch_det keeps coming in after 4ms, while the FIFO contains no value
+	 * during the whole time. */
+	while ((int_sta & (1 << STMPE_IRQ_TOUCH_DET)) && (timeout > 0)) {
+		timeout--;
+		int_sta = stmpe_reg_read(ts->stmpe, STMPE_REG_INT_STA);
+		udelay(100);
+	}
+
+	/* reset the FIFO before we report release event */
+	stmpe_set_bits(ts->stmpe, STMPE_REG_FIFO_STA,
+			STMPE_FIFO_STA_RESET, STMPE_FIFO_STA_RESET);
+	stmpe_set_bits(ts->stmpe, STMPE_REG_FIFO_STA,
+			STMPE_FIFO_STA_RESET, 0);
+
+	input_report_abs(ts->idev, ABS_PRESSURE, 0);
+	input_sync(ts->idev);
+}
+
+static irqreturn_t stmpe_ts_handler(int irq, void *data)
+{
+	u8 data_set[4];
+	int x, y, z;
+	struct stmpe_touch *ts = data;
+
+	/* Cancel scheduled polling for release if we have new value
+	 * available. Wait if the polling is already running. */
+	cancel_delayed_work_sync(&ts->work);
+
+	/*
+	 * The FIFO sometimes just crashes and stops generating interrupts. This
+	 * appears to be a silicon bug. We still have to clearify this with
+	 * the manufacture. As a workaround we disable the TSC while we are
+	 * collecting data and flush the FIFO after reading
+	 */
+	stmpe_set_bits(ts->stmpe, STMPE_REG_TSC_CTRL,
+				STMPE_TSC_CTRL_TSC_EN, 0);
+
+	stmpe_block_read(ts->stmpe, STMPE_REG_TSC_DATA_XYZ, 4, data_set);
+
+	x = (data_set[0] << 4) | (data_set[1] >> 4);
+	y = ((data_set[1] & 0xf) << 8) | data_set[2];
+	z = data_set[3];
+
+	input_report_abs(ts->idev, ABS_X, x);
+	input_report_abs(ts->idev, ABS_Y, y);
+	input_report_abs(ts->idev, ABS_PRESSURE, z);
+	input_sync(ts->idev);
+
+       /* flush the FIFO after we have read out our values. */
+	stmpe_set_bits(ts->stmpe, STMPE_REG_FIFO_STA,
+			STMPE_FIFO_STA_RESET, STMPE_FIFO_STA_RESET);
+	stmpe_set_bits(ts->stmpe, STMPE_REG_FIFO_STA,
+			STMPE_FIFO_STA_RESET, 0);
+
+	/* reenable the tsc */
+	stmpe_set_bits(ts->stmpe, STMPE_REG_TSC_CTRL,
+			STMPE_TSC_CTRL_TSC_EN, STMPE_TSC_CTRL_TSC_EN);
+
+	/* start polling for touch_det to detect release */
+	schedule_delayed_work(&ts->work, HZ / 50);
+
+	return IRQ_HANDLED;
+}
+
+static int stmpe_ts_open(struct input_dev *dev)
+{
+	struct stmpe_touch *ts = input_get_drvdata(dev);
+	int ret = 0;
+
+	ret = stmpe_set_bits(ts->stmpe, STMPE_REG_FIFO_STA,
+			STMPE_FIFO_STA_RESET, STMPE_FIFO_STA_RESET);
+	if (ret)
+		goto out;
+
+	ret = stmpe_set_bits(ts->stmpe, STMPE_REG_FIFO_STA,
+			STMPE_FIFO_STA_RESET, 0);
+	if (ret)
+		goto out;
+
+	ret = stmpe_set_bits(ts->stmpe, STMPE_REG_TSC_CTRL,
+			STMPE_TSC_CTRL_TSC_EN, STMPE_TSC_CTRL_TSC_EN);
+	if (ret)
+		goto out;
+
+out:
+	return ret;
+}
+
+static void stmpe_ts_close(struct input_dev *dev)
+{
+	struct stmpe_touch *ts = input_get_drvdata(dev);
+
+	stmpe_set_bits(ts->stmpe, STMPE_REG_TSC_CTRL,
+			STMPE_TSC_CTRL_TSC_EN, 0);
+}
+
+static int __devinit stmpe_input_probe(struct platform_device *pdev)
+{
+	struct stmpe *stmpe = dev_get_drvdata(pdev->dev.parent);
+	struct stmpe_platform_data *pdata = stmpe->pdata;
+	struct stmpe_touch *ts;
+	struct input_dev *idev;
+	struct stmpe_ts_platform_data *ts_pdata = NULL;
+	int ret = 0;
+	unsigned int ts_irq;
+	u8 adc_ctrl1, tsc_cfg;
+
+	ts_irq = platform_get_irq(pdev, 0);
+	if (ts_irq < 0)
+		return ts_irq;
+
+	ts = kzalloc(sizeof(*ts), GFP_KERNEL);
+	if (!ts)
+		goto err_out;
+
+	idev = input_allocate_device();
+	if (!idev)
+		goto err_free_ts;
+
+	platform_set_drvdata(pdev, ts);
+	ts->stmpe = stmpe;
+	ts->idev = idev;
+
+	if (pdata)
+		ts_pdata = pdata->ts;
+
+	if (ts_pdata) {
+		ts->sample_time = ts_pdata->sample_time;
+		ts->mod_12b = ts_pdata->mod_12b;
+		ts->ref_sel = ts_pdata->ref_sel;
+		ts->adc_freq = ts_pdata->adc_freq;
+		ts->ave_ctrl = ts_pdata->ave_ctrl;
+		ts->touch_det_delay = ts_pdata->touch_det_delay;
+		ts->settling = ts_pdata->settling;
+		ts->fraction_z = ts_pdata->fraction_z;
+		ts->i_drive = ts_pdata->i_drive;
+	}
+
+	INIT_DELAYED_WORK(&ts->work, stmpe_work);
+
+	ret = request_threaded_irq(ts_irq, NULL, stmpe_ts_handler,
+			IRQF_ONESHOT, STMPE_TS_NAME, ts);
+	if (ret) {
+		dev_err(&pdev->dev, "Failed to request IRQ %d\n", ts_irq);
+		goto err_free_input;
+	}
+
+	ret = stmpe_enable(stmpe, STMPE_BLOCK_TOUCHSCREEN);
+	if (ret) {
+		dev_err(&pdev->dev, "Could not enable clock for ADC and TS\n");
+		goto err_free_irq;
+	}
+
+	adc_ctrl1 = SAMPLE_TIME(ts->sample_time) | MOD_12B(ts->mod_12b) |
+		REF_SEL(ts->ref_sel);
+	ret = stmpe_set_bits(stmpe, STMPE_REG_ADC_CTRL1,
+			adc_ctrl1, adc_ctrl1);
+	if (ret) {
+		dev_err(&pdev->dev, "Could not setup ADC\n");
+		goto err_free_irq;
+	}
+
+	ret = stmpe_set_bits(stmpe, STMPE_REG_ADC_CTRL2,
+			ADC_FREQ(ts->adc_freq), ADC_FREQ(ts->adc_freq));
+	if (ret) {
+		dev_err(&pdev->dev, "Could not setup ADC\n");
+		goto err_free_irq;
+	}
+
+	tsc_cfg = AVE_CTRL(ts->ave_ctrl) | DET_DELAY(ts->touch_det_delay) |
+			SETTLING(ts->settling);
+	ret = stmpe_set_bits(stmpe, STMPE_REG_TSC_CFG, tsc_cfg, tsc_cfg);
+	if (ret) {
+		dev_err(&pdev->dev, "Could not config touch\n");
+		goto err_free_irq;
+	}
+
+	ret = stmpe_set_bits(stmpe, STMPE_REG_TSC_FRACTION_Z,
+			FRACTION_Z(ts->fraction_z),
+			FRACTION_Z(ts->fraction_z));
+	if (ret) {
+		dev_err(&pdev->dev, "Could not config touch\n");
+		goto err_free_irq;
+	}
+
+	ret = stmpe_set_bits(stmpe, STMPE_REG_TSC_I_DRIVE,
+			I_DRIVE(ts->i_drive), I_DRIVE(ts->i_drive));
+	if (ret) {
+		dev_err(&pdev->dev, "Could not config touch\n");
+		goto err_free_irq;
+	}
+
+	/* set FIFO to 1 for single point reading */
+	ret = stmpe_reg_write(stmpe, STMPE_REG_FIFO_TH, 1);
+	if (ret) {
+		dev_err(&pdev->dev, "Could not set FIFO\n");
+		goto err_free_irq;
+	}
+
+	ret = stmpe_set_bits(stmpe, STMPE_REG_TSC_CTRL,
+			STMPE_TSC_CTRL_OP_MOD_XYZ,
+			STMPE_TSC_CTRL_OP_MOD_XYZ);
+	if (ret) {
+		dev_err(&pdev->dev, "Could not set mode\n");
+		goto err_free_irq;
+	}
+
+	idev->name = STMPE_TS_NAME;
+	idev->id.bustype = BUS_I2C;
+	idev->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_ABS);
+	idev->keybit[BIT_WORD(BTN_TOUCH)] = BIT_MASK(BTN_TOUCH);
+
+	idev->open = stmpe_ts_open;
+	idev->close = stmpe_ts_close;
+
+	input_set_drvdata(idev, ts);
+
+	ret = input_register_device(idev);
+	if (ret) {
+		dev_err(&pdev->dev, "Could not register input device\n");
+		goto err_free_irq;
+	}
+
+	input_set_abs_params(idev, ABS_X, 0, XY_MASK, 0, 0);
+	input_set_abs_params(idev, ABS_Y, 0, XY_MASK, 0, 0);
+	input_set_abs_params(idev, ABS_PRESSURE, 0x0, 0xff, 0, 0);
+
+	return ret;
+
+err_free_irq:
+	free_irq(ts_irq, ts);
+err_free_input:
+	input_free_device(idev);
+	platform_set_drvdata(pdev, NULL);
+err_free_ts:
+	kfree(ts);
+err_out:
+	return ret;
+}
+
+static int __devexit stmpe_ts_remove(struct platform_device *pdev)
+{
+	struct stmpe_touch *ts = platform_get_drvdata(pdev);
+	unsigned int ts_irq = platform_get_irq(pdev, 0);
+
+	cancel_delayed_work(&ts->work);
+
+	stmpe_reg_write(ts->stmpe, STMPE_REG_FIFO_TH, 0);
+
+	stmpe_disable(ts->stmpe, STMPE_BLOCK_TOUCHSCREEN);
+
+	free_irq(ts_irq, ts);
+
+	platform_set_drvdata(pdev, NULL);
+
+	input_unregister_device(ts->idev);
+	input_free_device(ts->idev);
+
+	kfree(ts);
+
+	return 0;
+}
+
+static struct platform_driver stmpe_ts_driver = {
+	.driver = {
+		   .name = STMPE_TS_NAME,
+		   },
+	.probe = stmpe_input_probe,
+	.remove = __devexit_p(stmpe_ts_remove),
+};
+
+static int __init stmpe_ts_init(void)
+{
+	return platform_driver_register(&stmpe_ts_driver);
+}
+
+module_init(stmpe_ts_init);
+
+static void __exit stmpe_ts_exit(void)
+{
+	platform_driver_unregister(&stmpe_ts_driver);
+}
+
+module_exit(stmpe_ts_exit);
+
+MODULE_AUTHOR("Luotao Fu <l.fu@pengutronix.de>");
+MODULE_DESCRIPTION("STMPEXXX touchscreen driver");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:" STMPE_TS_NAME);
-- 
1.7.1

