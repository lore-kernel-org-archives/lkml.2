Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756096Ab0FNKdG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 06:33:06 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:53069 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756080Ab0FNKdB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 06:33:01 -0400
From: Luotao Fu <l.fu@pengutronix.de>
To: Samuel Ortiz <sameo@linux.intel.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       Luotao Fu <l.fu@pengutronix.de>
Subject: [PATCH 3/3 V2] input: STMPE811 touch controller support
Date: Mon, 14 Jun 2010 12:32:38 +0200
Message-Id: <1276511558-27121-4-git-send-email-l.fu@pengutronix.de>
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

 drivers/input/touchscreen/Kconfig       |   10 +
 drivers/input/touchscreen/Makefile      |    1 +
 drivers/input/touchscreen/stmpe811_ts.c |  361 +++++++++++++++++++++++++++++++
 include/linux/mfd/stmpe811.h            |   35 +++
 4 files changed, 407 insertions(+), 0 deletions(-)
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
index 0000000..ee6a547
--- /dev/null
+++ b/drivers/input/touchscreen/stmpe811_ts.c
@@ -0,0 +1,361 @@
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
+#define SAMPLE_TIME(x)			((x & 0xf) << 4)
+#define MOD_12B(x)			((x & 0x1) << 3)
+#define REF_SEL(x)			((x & 0x1) << 1)
+#define ADC_FREQ(x)			(x & 0x3)
+#define AVE_CTRL(x)			((x & 0x3) << 6)
+#define DET_DELAY(x)			((x & 0x7) << 3)
+#define SETTLING(x)			((x & 0x7))
+#define FRACTION_Z(x)			((x & 0x7))
+
+#define STMPE811_TS_NAME	"stmpe811-ts"
+#define XY_MASK			0xfff
+
+struct stmpe811_touch {
+	struct stmpe811 *stm;
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
+	/* reset the FIFO before we report release event */
+	stmpe811_reg_set_bits(ts->stm, STMPE811_REG_FIFO_STA,
+			STMPE811_FIFO_STA_RESET);
+	stmpe811_reg_clear_bits(ts->stm, STMPE811_REG_FIFO_STA,
+			STMPE811_FIFO_STA_RESET);
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
+	/* Cancel polling for release if we have new value available. Wait for
+	 * canceling till io operation in the work is finished. */
+	mutex_lock(&ts->stm->io_lock);
+	cancel_delayed_work(&ts->work);
+	mutex_unlock(&ts->stm->io_lock);
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
+	int ret = 0;
+
+	ret = stmpe811_reg_set_bits(ts->stm, STMPE811_REG_FIFO_STA,
+			STMPE811_FIFO_STA_RESET);
+	if (ret)
+		goto out;
+
+	ret = stmpe811_reg_clear_bits(ts->stm, STMPE811_REG_FIFO_STA,
+			STMPE811_FIFO_STA_RESET);
+	if (ret)
+		goto out;
+
+	ret = stmpe811_reg_set_bits(ts->stm, STMPE811_REG_TSC_CTRL,
+				     STMPE811_TSC_CTRL_TSC_EN);
+	if (ret)
+		goto out;
+
+out:
+	return ret;
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
+	struct stmpe811 *stm = dev_get_drvdata(pdev->dev.parent);
+	struct stmpe811_platform_data *pdata = stm->pdata;
+	struct stmpe811_touch *ts;
+	struct input_dev *idev;
+	struct stmpe811_ts_platform_data *ts_pdata = NULL;
+
+	int ret = 0;
+	unsigned int ts_irq;
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
+	ts->stm = stm;
+	ts->idev = idev;
+
+	if (pdata)
+		ts_pdata = pdata->ts_pdata;
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
+	}
+
+	INIT_DELAYED_WORK(&ts->work, stmpe811_work);
+
+	ts_irq = stm->irq_base + STMPE811_IRQ_FIFO_TH;
+	ret = request_threaded_irq(ts_irq, NULL, stmpe811_ts_handler,
+			IRQF_ONESHOT, STMPE811_TS_NAME, ts);
+	if (ret) {
+		dev_err(&pdev->dev, "Failed to request IRQ %d\n", ts_irq);
+		goto err_free_input;
+	}
+
+	ret = stmpe811_reg_clear_bits(stm, STMPE811_REG_SYS_CTRL2,
+				      (STMPE811_SYS_CTRL2_ADC_OFF |
+				       STMPE811_SYS_CTRL2_TSC_OFF));
+	if (ret) {
+		dev_err(&pdev->dev, "Could not enable clock for ADC and TS\n");
+		goto err_free_irq;
+	}
+
+	ret = stmpe811_reg_set_bits(stm, STMPE811_REG_ADC_CTRL1,
+			SAMPLE_TIME(ts->sample_time) |
+			MOD_12B(ts->mod_12b) | REF_SEL(ts->ref_sel));
+	if (ret) {
+		dev_err(&pdev->dev, "Could not setup ADC\n");
+		goto err_free_irq;
+	}
+
+	ret = stmpe811_reg_set_bits(stm, STMPE811_REG_ADC_CTRL2,
+			ADC_FREQ(ts->adc_freq));
+	if (ret) {
+		dev_err(&pdev->dev, "Could not setup ADC\n");
+		goto err_free_irq;
+	}
+
+	ret = stmpe811_reg_set_bits(stm, STMPE811_REG_TSC_CFG,
+			AVE_CTRL(ts->ave_ctrl) |
+			DET_DELAY(ts->touch_det_delay) |
+			SETTLING(ts->settling));
+	if (ret) {
+		dev_err(&pdev->dev, "Could not config touch\n");
+		goto err_free_irq;
+	}
+
+	ret = stmpe811_reg_set_bits(stm,
+			STMPE811_REG_TSC_FRACTION_Z,
+			FRACTION_Z(ts->fraction_z));
+	if (ret) {
+		dev_err(&pdev->dev, "Could not config touch\n");
+		goto err_free_irq;
+	}
+
+	/* set FIFO to 1 for single point reading */
+	ret = stmpe811_reg_write(stm, STMPE811_REG_FIFO_TH, 1);
+	if (ret) {
+		dev_err(&pdev->dev, "Could not set FIFO\n");
+		goto err_free_irq;
+	}
+
+	ret = stmpe811_reg_set_bits(stm, STMPE811_REG_TSC_CTRL,
+				    STMPE811_TSC_CTRL_OP_MOD_XYZ);
+	if (ret) {
+		dev_err(&pdev->dev, "Could not set mode\n");
+		goto err_free_irq;
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
+		goto err_free_irq;
+	}
+
+	stm->active_flag |= STMPE811_USE_TS;
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
+static int __devexit stmpe811_ts_remove(struct platform_device *pdev)
+{
+	struct stmpe811_touch *ts = platform_get_drvdata(pdev);
+	unsigned int ts_irq = ts->stm->irq_base + STMPE811_IRQ_FIFO_TH;
+
+	cancel_delayed_work(&ts->work);
+
+	stmpe811_reg_write(ts->stm, STMPE811_REG_FIFO_TH, 0);
+
+	stmpe811_reg_set_bits(ts->stm, STMPE811_REG_SYS_CTRL2,
+			      (STMPE811_SYS_CTRL2_ADC_OFF |
+			       STMPE811_SYS_CTRL2_ADC_OFF));
+
+	free_irq(ts_irq, ts);
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
+		   .name = STMPE811_TS_NAME,
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
diff --git a/include/linux/mfd/stmpe811.h b/include/linux/mfd/stmpe811.h
index acd5aaf..b8a75d8 100644
--- a/include/linux/mfd/stmpe811.h
+++ b/include/linux/mfd/stmpe811.h
@@ -96,6 +96,40 @@ struct stmpe811 {
 	u8 active_flag;
 };
 
+struct stmpe811_ts_platform_data {
+	/* ADC converstion time in number of clock.
+	 * 0 -> 36 clocks, 1 -> 44 clocks, 2 -> 56 clocks, 3 -> 64 clocks
+	 * 4 -> 80 clocks, 5 -> 96 clocks, 6 -> 144 clocks
+	 * recommended is 4 */
+	u8 sample_time;
+	/* ADC Bit mode:
+	 * 0 -> 10bit ADC, 1 -> 12bit ADC */
+	u8 mod_12b;
+	/* ADC reference source:
+	 * 0 -> internal reference, 1 -> external reference */
+	u8 ref_sel;
+	/* ADC Clock speed:
+	 * 0 -> 1.625 MHz, 1 -> 3.25 MHz, 2 || 3 -> 6.5 MHz */
+	u8 adc_freq;
+	/* Sample average control:
+	 * 0 -> 1 sample, 1 -> 2 samples, 2 -> 4 samples, 3 -> 8 samples */
+	u8 ave_ctrl;
+	/* Touch detect interrupt delay:
+	 * 0 -> 10 us, 1 -> 50 us, 2 -> 100 us, 3 -> 500 us
+	 * 4 -> 1 ms, 5 -> 5 ms, 6 -> 10 ms, 7 -> 50 ms
+	 * recommended is 3 */
+	u8 touch_det_delay;
+	/* Panel driver settling time
+	 * 0 -> 10 us, 1 -> 100 us, 2 -> 500 us, 3 -> 1 ms,
+	 * 4 -> 5 ms, 5 -> 10 ms, 6 for 50 ms, 7 -> 100 ms
+	 * recommended is 2 */
+	u8 settling;
+	/* Length of the fractional part in z
+	 * fraction_z ([0..7]) = Count of the fractional part
+	 * recommended is 7 */
+	u8 fraction_z;
+};
+
 struct stmpe811_gpio_platform_data {
 	unsigned int gpio_base;
 	int (*setup) (struct stmpe811 *stm);
@@ -108,6 +142,7 @@ struct stmpe811_platform_data {
 	unsigned int int_conf;
 	int irq_base;
 	struct stmpe811_gpio_platform_data *gpio_pdata;
+	struct stmpe811_ts_platform_data *ts_pdata;
 };
 
 int stmpe811_block_read(struct stmpe811 *stm, u8 reg, uint len, u8 *val);
-- 
1.7.1

