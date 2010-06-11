Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932417Ab0FKKOF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 06:14:05 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:45065 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760114Ab0FKKNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 06:13:49 -0400
From: Luotao Fu <l.fu@pengutronix.de>
To: Samuel Ortiz <sameo@linux.intel.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       l.fu@pengutronix.de
Subject: [PATCH 3/3] input: STMPE811 touch controller support
Date: Fri, 11 Jun 2010 12:13:15 +0200
Message-Id: <1276251195-22981-4-git-send-email-l.fu@pengutronix.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1276251195-22981-1-git-send-email-l.fu@pengutronix.de>
References: <1276251195-22981-1-git-send-email-l.fu@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: l.fu@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This one adds a driver for STMPE811 4-wire resistive touchscreen
controller. STMPE811 is a multifunction device. Hence this driver
depends on stmpe811_core driver for core functionalities.

Signed-off-by: Luotao Fu <l.fu@pengutronix.de>
---
 drivers/input/touchscreen/Kconfig       |   10 +
 drivers/input/touchscreen/Makefile      |    1 +
 drivers/input/touchscreen/stmpe811_ts.c |  403 +++++++++++++++++++++++++++++++
 3 files changed, 414 insertions(+), 0 deletions(-)
 create mode 100644 drivers/input/touchscreen/stmpe811_ts.c

diff --git a/drivers/input/touchscreen/Kconfig b/drivers/input/touchscreen/Kconfig
index 3b9d5e2..059b82b 100644
--- a/drivers/input/touchscreen/Kconfig
+++ b/drivers/input/touchscreen/Kconfig
@@ -603,4 +603,14 @@ config TOUCHSCREEN_TPS6507X
 	  To compile this driver as a module, choose M here: the
 	  module will be called tps6507x_ts.
 
+config TOUCHSCREEN_STMPE811
+	tristate "STMicroelectronics STMPE811 touchscreen"
+	depends on MFD_STMPE811
+	help
+	  Say Y here if you want support for STMicroelectronics
+	  STMPE811 based touchscreen controller.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called stmpe811_ts.
+
 endif
diff --git a/drivers/input/touchscreen/Makefile b/drivers/input/touchscreen/Makefile
index 497964a..9da8948 100644
--- a/drivers/input/touchscreen/Makefile
+++ b/drivers/input/touchscreen/Makefile
@@ -47,3 +47,4 @@ obj-$(CONFIG_TOUCHSCREEN_WM97XX_MAINSTONE)	+= mainstone-wm97xx.o
 obj-$(CONFIG_TOUCHSCREEN_WM97XX_ZYLONITE)	+= zylonite-wm97xx.o
 obj-$(CONFIG_TOUCHSCREEN_W90X900)	+= w90p910_ts.o
 obj-$(CONFIG_TOUCHSCREEN_TPS6507X)	+= tps6507x-ts.o
+obj-$(CONFIG_TOUCHSCREEN_STMPE811)	+= stmpe811_ts.o
diff --git a/drivers/input/touchscreen/stmpe811_ts.c b/drivers/input/touchscreen/stmpe811_ts.c
new file mode 100644
index 0000000..3fed0ba
--- /dev/null
+++ b/drivers/input/touchscreen/stmpe811_ts.c
@@ -0,0 +1,403 @@
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
+
+#include <linux/mfd/stmpe811.h>
+
+#define STMPE811_TSC_CTRL_OP_MOD_XYZ	(0<<1)
+#define STMPE811_TSC_CTRL_OP_MOD_XY	(1<<1)
+#define STMPE811_TSC_CTRL_OP_MOD_X	(2<<1)
+#define STMPE811_TSC_CTRL_OP_MOD_Y	(3<<1)
+#define STMPE811_TSC_CTRL_OP_MOD_Z	(4<<1)
+
+#define STMPE811_TSC_CTRL_TSC_STA	(1<<7)
+#define STMPE811_TSC_CTRL_TSC_EN	(1<<0)
+
+#define STMPE811_TS_NAME	"stmpe811-ts"
+#define XY_MASK			0xfff
+
+/*
+ * Module parameters
+ */
+
+/*
+ * Sample time:
+ *
+ * Set sample_time = 0 for 36 clocks
+ *     sample_time = 1 for 44 clocks
+ *     sample_time = 2 for 56 clocks
+ *     sample_time = 3 for 64 clocks
+ *     sample_time = 4 for 80 clocks
+ *     sample_time = 5 for 96 clocks
+ *     sample_time = 6 for 144 clocks
+ * This one defines ADC converstion time in number of clock.
+ */
+static int sample_time = 4;
+module_param(sample_time, int, 0444);
+MODULE_PARM_DESC(sample_time,
+	"Set ADC conversion time. Default is 4 (80 clocks)");
+
+/*
+ * ADC Bit mode:
+ *
+ * Set mod_12b = 0 for 10bit ADC
+ *     mod_12b = 1 for 12bit ADC
+ */
+static int mod_12b = 1;
+module_param(mod_12b, int, 0444);
+MODULE_PARM_DESC(mod_12b, "Set ADC Bit mode. Default is 1 (12bit)");
+
+/*
+ * reference source:
+ *
+ * Set ref_sel = 0 for internal reference
+ *     ref_sel = 1 for external reference
+ */
+static int ref_sel;
+module_param(ref_sel, int, 0444);
+MODULE_PARM_DESC(ref_sel,
+	"Set ADC reference source. Default is 0 (internal reference)");
+
+/*
+ * ADC Clock speed:
+ *
+ * Set adc_freq = 0 for 1.625 MHz
+ *     adc_freq = 1 for 3.25 MHz
+ *     adc_freq = 2 | adc_freq = 3 for 6.5 MHz
+ */
+static int adc_freq = 1;
+module_param(adc_freq, int, 0444);
+MODULE_PARM_DESC(adc_freq, "Set ADC clock speed. Default is 1 (3.25MHz)");
+
+/*
+ * Sample average control:
+ *
+ * Set ave_ctrl = 0 for 1 sample
+ *     ave_ctrl = 1 for 2 samples
+ *     ave_ctrl = 2 for 4 samples
+ *     ave_ctrl = 3 for 8 samples
+ */
+static int ave_ctrl = 3;
+module_param(ave_ctrl, int, 0444);
+MODULE_PARM_DESC(adc_freq,
+	"Set average sample counts. Default is 3 (8 samples)");
+
+/*
+ * Touch detect interrupt delay:
+ *
+ * Set touch_det_delay = 0 for 10 us
+ *     touch_det_delay = 1 for 50 us
+ *     touch_det_delay = 2 for 100 us
+ *     touch_det_delay = 3 for 500 us
+ *     touch_det_delay = 4 for 1 ms
+ *     touch_det_delay = 5 for 5 ms
+ *     touch_det_delay = 6 for 10 ms
+ *     touch_det_delay = 7 for 50 ms
+ * This one defines the delay for signaling a touch detection interrupt after
+ * the actual event
+ */
+static int touch_det_delay = 3;
+module_param(touch_det_delay, int, 0444);
+MODULE_PARM_DESC(touch_det_delay,
+	"Set touch detect delay. Default is 3 (500 us)");
+
+/*
+ * Panel driver settling time
+ *
+ * Set settling = 0 for 10 us
+ *     settling = 1 for 100 us
+ *     settling = 2 for 500 us
+ *     settling = 3 for 1 ms
+ *     settling = 4 for 5 ms
+ *     settling = 5 for 10 ms
+ *     settling = 6 for 50 ms
+ *     settling = 7 for 100 ms
+ *
+ * This one defines the delay time the ADC shall give the pannel to settle its
+ * voltage for stable measurement.
+ */
+static int settling = 2;
+module_param(settling, int, 0444);
+MODULE_PARM_DESC(settling,
+	"Set panel driver settling time. Default is 2 (500 us)");
+
+/*
+ * Length of the fractional part in z
+ *
+ * value coding is quite identical with touch_det_delay above, only
+ *     fraction_z ([0..7]) = Count of the fractional part
+ *
+ * This one allows to select range and accuracy of the pressure measurement
+ */
+static int fraction_z = 7;
+module_param(fraction_z, int, 0444);
+MODULE_PARM_DESC(fraction_z,
+	"Set fractional part of z. Default is 7 (7 fractional, 1 whole)");
+
+struct stmpe811_touch {
+	struct stmpe811 *stm;
+	struct input_dev *idev;
+	struct delayed_work work;
+};
+
+static void stmpe811_work(struct work_struct *work)
+{
+	u8 int_sta;
+	u32 timeout = 40;
+
+	struct stmpe811_touch *ts =
+	    container_of(work, struct stmpe811_touch, work.work);
+
+	stmpe811_reg_read(ts->stm, STMPE811_REG_INT_STA, &int_sta);
+
+	/* touch_det sometimes get desasserted or just get stuck. This appears
+	 * to be a silicon bug, We still have to clearify this with the
+	 * manufacture. As a workaround We release the key anyway if the
+	 * touch_det keeps coming in after 4ms, while the FIFO contains no value
+	 * during the whole time. */
+	while ((int_sta & (1 << STMPE811_IRQ_TOUCH_DET)) && (timeout > 0)) {
+		timeout--;
+		stmpe811_reg_read(ts->stm, STMPE811_REG_INT_STA, &int_sta);
+		udelay(100);
+	}
+
+	input_report_abs(ts->idev, ABS_PRESSURE, 0);
+	input_sync(ts->idev);
+}
+
+static irqreturn_t stmpe811_ts_handler(int irq, void *data)
+{
+	u8 data_set[4];
+	int x, y, z;
+	struct stmpe811_touch *ts = data;
+
+	/* Cancel polling for release if we have new value available. */
+	cancel_delayed_work(&ts->work);
+
+	/*
+	 * The FIFO sometimes just crashes and stops generating interrupts. This
+	 * appears to be a silicon bug. We still have to clearify this with
+	 * the manufacture. As a workaround we disable the TSC while we are
+	 * collecting data and flush the FIFO after reading
+	 */
+	stmpe811_reg_clear_bits(ts->stm, STMPE811_REG_TSC_CTRL,
+				STMPE811_TSC_CTRL_TSC_EN);
+
+	stmpe811_block_read(ts->stm, STMPE811_REG_TSC_DATA_XYZ, 4, data_set);
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
+	stmpe811_reg_set_bits(ts->stm, STMPE811_REG_FIFO_STA,
+			      STMPE811_FIFO_STA_RESET);
+	stmpe811_reg_clear_bits(ts->stm, STMPE811_REG_FIFO_STA,
+				STMPE811_FIFO_STA_RESET);
+
+	/* reenable the tsc */
+	stmpe811_reg_set_bits(ts->stm, STMPE811_REG_TSC_CTRL,
+			      STMPE811_TSC_CTRL_TSC_EN);
+
+	/* start polling for touch_det to detect release */
+	schedule_delayed_work(&ts->work, HZ / 50);
+
+	return IRQ_HANDLED;
+}
+
+static int stmpe811_ts_open(struct input_dev *dev)
+{
+	struct stmpe811_touch *ts = input_get_drvdata(dev);
+
+	return stmpe811_reg_set_bits(ts->stm, STMPE811_REG_TSC_CTRL,
+				     STMPE811_TSC_CTRL_TSC_EN);
+}
+
+static void stmpe811_ts_close(struct input_dev *dev)
+{
+	struct stmpe811_touch *ts = input_get_drvdata(dev);
+
+	stmpe811_reg_clear_bits(ts->stm, STMPE811_REG_TSC_CTRL,
+				STMPE811_TSC_CTRL_TSC_EN);
+}
+
+static int __devinit stmpe811_input_probe(struct platform_device *pdev)
+{
+	struct stmpe811_touch *ts;
+	struct input_dev *idev;
+	int ret = 0;
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
+	ts->stm = dev_get_drvdata(pdev->dev.parent);
+	ts->idev = idev;
+
+	INIT_DELAYED_WORK(&ts->work, stmpe811_work);
+
+	stmpe811_register_irq(ts->stm, STMPE811_IRQ_FIFO_TH,
+			      stmpe811_ts_handler, ts);
+
+	ret = stmpe811_reg_clear_bits(ts->stm, STMPE811_REG_SYS_CTRL2,
+				      (STMPE811_SYS_CTRL2_ADC_OFF |
+				       STMPE811_SYS_CTRL2_TSC_OFF));
+	if (ret) {
+		dev_err(&pdev->dev, "Could not enable clock for ADC and TS\n");
+		goto err_free_plat;
+	}
+
+	ret = stmpe811_reg_set_bits(ts->stm, STMPE811_REG_ADC_CTRL1,
+			(sample_time << 4) | (mod_12b << 3) | (ref_sel << 1));
+	if (ret) {
+		dev_err(&pdev->dev, "Could not setup ADC\n");
+		goto err_free_plat;
+	}
+
+	ret = stmpe811_reg_set_bits(ts->stm, STMPE811_REG_ADC_CTRL2, adc_freq);
+	if (ret) {
+		dev_err(&pdev->dev, "Could not setup ADC\n");
+		goto err_free_plat;
+	}
+
+	ret = stmpe811_reg_set_bits(ts->stm, STMPE811_REG_TSC_CFG,
+			(ave_ctrl << 6) | (touch_det_delay << 3) | settling);
+	if (ret) {
+		dev_err(&pdev->dev, "Could not config touch\n");
+		goto err_free_plat;
+	}
+
+	ret = stmpe811_reg_set_bits(ts->stm,
+			STMPE811_REG_TSC_FRACTION_Z, fraction_z);
+	if (ret) {
+		dev_err(&pdev->dev, "Could not config touch\n");
+		goto err_free_plat;
+	}
+
+	/* set FIFO to 1 for single point reading */
+	ret = stmpe811_reg_write(ts->stm, STMPE811_REG_FIFO_TH, 1);
+	if (ret) {
+		dev_err(&pdev->dev, "Could not set FIFO\n");
+		goto err_free_plat;
+	}
+
+	ret = stmpe811_reg_set_bits(ts->stm, STMPE811_REG_TSC_CTRL,
+				    STMPE811_TSC_CTRL_OP_MOD_XYZ);
+	if (ret) {
+		dev_err(&pdev->dev, "Could not set mode\n");
+		goto err_free_plat;
+	}
+
+	idev->name = STMPE811_TS_NAME;
+	idev->id.bustype = BUS_I2C;
+	idev->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_ABS);
+	idev->keybit[BIT_WORD(BTN_TOUCH)] = BIT_MASK(BTN_TOUCH);
+
+	idev->open = stmpe811_ts_open;
+	idev->close = stmpe811_ts_close;
+
+	input_set_drvdata(idev, ts);
+
+	ret = input_register_device(idev);
+	if (ret) {
+		dev_err(&pdev->dev, "Could not register input device\n");
+		goto err_free_plat;
+	}
+
+	ts->stm->active_flag |= STMPE811_USE_TS;
+
+	input_set_abs_params(idev, ABS_X, 0, XY_MASK, 0, 0);
+	input_set_abs_params(idev, ABS_Y, 0, XY_MASK, 0, 0);
+	input_set_abs_params(idev, ABS_PRESSURE, 0x0, 0xff, 0, 0);
+
+	return ret;
+
+err_free_plat:
+	platform_set_drvdata(pdev, NULL);
+	input_free_device(idev);
+err_free_ts:
+	kfree(ts);
+err_out:
+	return ret;
+}
+
+static int __devexit stmpe811_ts_remove(struct platform_device *pdev)
+{
+	struct stmpe811_touch *ts = platform_get_drvdata(pdev);
+
+	cancel_delayed_work(&ts->work);
+
+	stmpe811_free_irq(ts->stm, STMPE811_IRQ_FIFO_TH);
+	/*disable FIFO TH */
+	stmpe811_reg_write(ts->stm, STMPE811_REG_FIFO_TH, 0);
+
+	stmpe811_reg_set_bits(ts->stm, STMPE811_REG_SYS_CTRL2,
+			      (STMPE811_SYS_CTRL2_ADC_OFF |
+			       STMPE811_SYS_CTRL2_ADC_OFF));
+
+	ts->stm->active_flag &= ~STMPE811_USE_TS;
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
+static struct platform_driver stmpe811_input_driver = {
+	.driver = {
+		   .name = "stmpe811-ts",
+		   },
+	.probe = stmpe811_input_probe,
+	.remove = __devexit_p(stmpe811_ts_remove),
+};
+
+static int __init stmpe811_input_init(void)
+{
+	return platform_driver_register(&stmpe811_input_driver);
+}
+
+module_init(stmpe811_input_init);
+
+static void __exit stmpe811_input_exit(void)
+{
+	platform_driver_unregister(&stmpe811_input_driver);
+}
+
+module_exit(stmpe811_input_exit);
+
+MODULE_AUTHOR("Luotao Fu <l.fu@pengutronix.de>");
+MODULE_DESCRIPTION("STMPE811 touchscreen driver");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:" STMPE811_TS_NAME);
-- 
1.7.1

