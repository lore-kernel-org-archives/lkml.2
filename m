Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754015Ab1GNI6F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 04:58:05 -0400
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:15528
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753328Ab1GNI6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 04:58:03 -0400
X-SpamScore: 10
X-BigFish: VPS10(zzc8kzz1202h10d2nzz8275bhz32i2a8h668h839h93fh65h)
X-Spam-TCS-SCL: 4:0
X-Forefront-Antispam-Report: CIP:59.163.77.45;KIP:(null);UIP:(null);IPVD:NLI;H:KCHJEXHC01.kpit.com;RD:59.163.77.45.static.vsnl.net.in;EFVD:NLI
Subject: [Patch v1 08/11] Touch: DA9052 touchscreen driver
From: ashishj3 <ashish.jangam@kpitcummins.com>
Reply-To: <ashish.jangam@kpitcummins.com>
To: <randy.dunlap@oracle.com>
CC: <dmitry.torokhov@gmail.com>, <dtor@mail.ru>,
        <linux-kernel@vger.kernel.org>, <linaro-dev@lists.linaro.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 14 Jul 2011 14:28:10 +0530
Message-ID: <1310633890.284.90.camel@L-0532.kpit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.10.38.42]
X-OriginatorOrg: kpitcummins.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver add support for DA9052 4-wire resistive ADC interfaced touchscreen
controller.

DA9052 is a MFD therefore this driver depends on DA9052 core driver for core
functionalities.

Signed-off-by: David Dajun Chen <dchen@diasemi.com>
Signed-off-by: Ashish Jangam <ashish.jangam@kpitcummins.com>
---
 drivers/input/touchscreen/Kconfig      |    7 +
 drivers/input/touchscreen/Makefile     |    1 +
 drivers/input/touchscreen/da9052_tsi.c |  489 ++++++++++++++++++++++++++++++++
 3 files changed, 497 insertions(+), 0 deletions(-)
 create mode 100755 drivers/input/touchscreen/da9052_tsi.c
diff --git a/drivers/input/touchscreen/Kconfig b/drivers/input/touchscreen/Kconfig
index cabd9e5..a5d2e7b 100644
--- a/drivers/input/touchscreen/Kconfig
+++ b/drivers/input/touchscreen/Kconfig
@@ -144,6 +144,13 @@ config TOUCHSCREEN_DA9034
 	  Say Y here to enable the support for the touchscreen found
 	  on Dialog Semiconductor DA9034 PMIC.
 
+config TOUCHSCREEN_DA9052
+	tristate "Dialog DA9052 TSI"
+	depends on PMIC_DA9052
+	help
+	  Say y here to support the touchscreen found on
+	  Dialog Semiconductor DA9052 PMIC
+
 config TOUCHSCREEN_DYNAPRO
 	tristate "Dynapro serial touchscreen"
 	select SERIO
diff --git a/drivers/input/touchscreen/Makefile b/drivers/input/touchscreen/Makefile
index 282d6f7..a4aeb25 100644
--- a/drivers/input/touchscreen/Makefile
+++ b/drivers/input/touchscreen/Makefile
@@ -18,6 +18,7 @@ obj-$(CONFIG_TOUCHSCREEN_BITSY)		+= h3600_ts_input.o
 obj-$(CONFIG_TOUCHSCREEN_BU21013)       += bu21013_ts.o
 obj-$(CONFIG_TOUCHSCREEN_CY8CTMG110)	+= cy8ctmg110_ts.o
 obj-$(CONFIG_TOUCHSCREEN_DA9034)	+= da9034-ts.o
+obj-$(CONFIG_TOUCHSCREEN_DA9052)	+= da9052_tsi.o
 obj-$(CONFIG_TOUCHSCREEN_DYNAPRO)	+= dynapro.o
 obj-$(CONFIG_TOUCHSCREEN_HAMPSHIRE)	+= hampshire.o
 obj-$(CONFIG_TOUCHSCREEN_GUNZE)		+= gunze.o
diff --git a/drivers/input/touchscreen/da9052_tsi.c b/drivers/input/touchscreen/da9052_tsi.c
new file mode 100755
index 0000000..dade0a9
--- /dev/null
+++ b/drivers/input/touchscreen/da9052_tsi.c
@@ -0,0 +1,489 @@
+/*
+ * TSI driver for Dialog DA9052
+ *
+ * Copyright(c) 2011 Dialog Semiconductor Ltd.
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
+#include <linux/freezer.h>
+#include <linux/kthread.h>
+#include <linux/kfifo.h>
+
+#include <linux/mfd/da9052/reg.h>
+#include <linux/mfd/da9052/da9052.h>
+
+#define DA9052_ACTIVE			1
+#define DA9052_INACTIVE		0
+
+#define DA9052_TSI_FIFOSIZE		640
+
+enum {
+	DA9052_PEN_IDLE,
+	DA9052_PEN_DOWN,
+	DA9052_PEN_UP
+};
+
+struct da9052_tsi_reg {
+	u16	x;
+	u16	y;
+};
+
+struct tsi_thread_type {
+	u8		pid;
+	u8		state;
+	struct completion	notifier;
+	struct task_struct	*thread_task;
+};
+
+struct da9052_tsi {
+	struct da9052	*da9052;
+	struct input_dev *dev;
+	struct tsi_thread_type	tsi_pen_state_thread;
+	struct tsi_thread_type  tsi_filter_thread;
+	struct kfifo fifo;
+	struct kfifo fifo_buf;
+	u8 pen_up_detect_interval;
+	u32 zero_data_cnt;
+	u32 valid_penup_count;
+	u8 pen_state;
+	int irq_pendwn;
+	int irq_datardy;
+};
+
+static inline int da9052_ts_start(struct da9052_tsi *tsi)
+{
+	return da9052_reg_update(tsi->da9052, DA9052_TSI_CONT_A_REG,
+				 1 << 0, 1 << 0);
+}
+
+static inline int da9052_ts_stop(struct da9052_tsi *tsi)
+{
+	return da9052_clear_bits(tsi->da9052, DA9052_TSI_CONT_A_REG, 1 << 0);
+}
+
+static irqreturn_t da9052_ts_pendwn_irq(int irq, void *data)
+{
+	struct da9052_tsi *tsi = (struct da9052_tsi *)data;
+	struct da9052 *da9052 = tsi->da9052;
+	int ret;
+
+	da9052->events_mask |= DA9052_E_PEN_DOWN;
+	da9052->events_mask &= ~DA9052_E_TSI_READY;
+
+	/* Mask PEN_DOWN event and unmask TSI_READY event*/
+	ret = da9052_reg_update(da9052, DA9052_IRQ_MASK_B_REG, 0x80, 0x40);
+	if (ret < 0)
+		return IRQ_NONE;
+
+	da9052_ts_start(tsi);
+	tsi->pen_state = DA9052_PEN_DOWN;
+
+	return IRQ_HANDLED;
+}
+
+static int da9052_ts_read(struct da9052_tsi *tsi)
+{
+	struct da9052_tsi_reg co_ord = {0, 0};
+	int ret;
+	uint8_t _x, _y, _v;
+
+	ret = da9052_reg_read(tsi->da9052, DA9052_TSI_X_MSB_REG);
+	if (ret < 0)
+		return ret;
+
+	_x = (uint8_t) ret;
+
+	ret = da9052_reg_read(tsi->da9052, DA9052_TSI_Y_MSB_REG);
+	if (ret < 0)
+		return ret;
+
+	_y = (uint8_t) ret;
+
+	ret = da9052_reg_read(tsi->da9052, DA9052_TSI_LSB_REG);
+	if (ret < 0)
+		return ret;
+
+	_v = (uint8_t) ret;
+
+	co_ord.x = ((_x << 2) & 0x3fc) | (_v & 0x3);
+	co_ord.y = ((_y << 2) & 0x3fc) | ((_v & 0xc) >> 2);
+
+	ret = kfifo_in(&tsi->fifo, &co_ord, sizeof(struct da9052_tsi_reg));
+
+	return 0;
+}
+
+static irqreturn_t da9052_ts_datardy_irq(int irq, void *data)
+{
+	struct da9052_tsi *tsi = (struct da9052_tsi *)data;
+	int ret;
+
+	ret = da9052_ts_read(tsi);
+	if (ret) {
+		dev_err(tsi->da9052->dev,
+			"Failed to read TSI co-ordinate, %d\n", ret);
+		return IRQ_NONE;
+	}
+
+	return IRQ_HANDLED;
+}
+
+/*
+* Two FIFO are been used. FIFO1 is used for detecting pen up and
+* FIFO2 for reporting pen down co-ordinate.
+*/
+void da9052_ts_process_reg_data(struct da9052_tsi *tsi)
+{
+	struct da9052_tsi_reg tmp_raw_data;
+	u32 reg_data_cnt;
+	int ret;
+
+	reg_data_cnt = kfifo_len(&tsi->fifo);
+
+	while (reg_data_cnt-- > 0) {
+		ret = kfifo_out(&tsi->fifo, &tmp_raw_data,
+				sizeof(struct da9052_tsi_reg));
+		if (ret < 0)
+			continue;
+		kfifo_in(&tsi->fifo_buf, &tmp_raw_data,
+			 sizeof(struct da9052_tsi_reg));
+	}
+	return;
+}
+
+static void da9052_ts_report_penup(struct da9052_tsi *tsi)
+{
+	struct input_dev *ip_dev = tsi->dev;
+	struct da9052 *da9052 = tsi->da9052;
+	ssize_t ret;
+
+	ret = da9052_ts_stop(tsi);
+	if (ret < 0)
+		return;
+
+	da9052->events_mask |= DA9052_E_TSI_READY;
+	da9052->events_mask &= ~DA9052_E_PEN_DOWN;
+
+	/* Mask TSI_READY event and unmask PEN_DOWN event*/
+	ret = da9052_reg_update(da9052, DA9052_IRQ_MASK_B_REG, 0x40, 0x80);
+	if (ret < 0)
+		return;
+
+	input_report_abs(ip_dev, BTN_TOUCH, 0);
+	input_sync(ip_dev);
+
+	tsi->zero_data_cnt = 0;
+}
+
+/*
+* This function detects the pen up state using the kfifo len.
+* If kfifo len is zero for some interval then pen up is reported.
+* Else pen co-ordinate are reported.
+*/
+static int da9052_ts_monitor_pen_state(void *data)
+{
+	struct da9052_tsi *tsi = (struct da9052_tsi *) data;
+	u32 data_cnt;
+
+	set_freezable();
+
+	while (tsi->tsi_pen_state_thread.state == DA9052_ACTIVE) {
+		try_to_freeze();
+
+		set_current_state(TASK_INTERRUPTIBLE);
+		schedule_timeout(msecs_to_jiffies(10));
+
+		if (tsi->pen_state != DA9052_PEN_DOWN)
+			continue;
+
+		data_cnt = kfifo_len(&tsi->fifo);
+		if (data_cnt < 0)
+			continue;
+
+		da9052_ts_process_reg_data(tsi);
+
+		if (data_cnt)
+			tsi->zero_data_cnt = 0;
+		else {
+			if ((++(tsi->zero_data_cnt)) >
+				tsi->valid_penup_count) {
+				tsi->pen_state = DA9052_PEN_UP;
+				da9052_ts_report_penup(tsi);
+			}
+		}
+	}
+
+	complete_and_exit(&tsi->tsi_pen_state_thread.notifier, 0);
+	return 0;
+}
+
+static int da9052_ts_process_thread(void *ptr)
+{
+	struct da9052_tsi_reg co_ord;
+	int cnt = 0, ret;
+	struct da9052_tsi *tsi = (struct da9052_tsi *)ptr;
+
+	set_freezable();
+
+	while (tsi->tsi_filter_thread.state == DA9052_ACTIVE) {
+
+		try_to_freeze();
+
+		set_current_state(TASK_INTERRUPTIBLE);
+		schedule_timeout(msecs_to_jiffies(10));
+		cnt = kfifo_len(&tsi->fifo_buf);
+		if (cnt <= 0)
+			continue;
+
+		ret = kfifo_out(&tsi->fifo_buf, &co_ord,
+				sizeof(struct da9052_tsi_reg));
+		if (ret < 0)
+			continue;
+
+		input_report_abs(tsi->dev, BTN_TOUCH, 1);
+		input_report_abs(tsi->dev, ABS_X, co_ord.x);
+		input_report_abs(tsi->dev, ABS_Y, co_ord.y);
+		input_sync(tsi->dev);
+	}
+
+	tsi->tsi_filter_thread.thread_task = NULL;
+	complete_and_exit(&tsi->tsi_filter_thread.notifier, 0);
+
+	return 0;
+}
+
+static int da9052_ts_configure_gpio(struct da9052 *da9052)
+{
+	int ret;
+
+	ret = da9052_clear_bits(da9052, DA9052_GPIO_2_3_REG, 0x30);
+	if (ret < 0)
+		return -EIO;
+
+	ret = da9052_clear_bits(da9052, DA9052_GPIO_4_5_REG, 0x33);
+	if (ret < 0)
+		return -EIO;
+
+	ret = da9052_clear_bits(da9052, DA9052_GPIO_6_7_REG, 0x33);
+	if (ret < 0)
+		return -EIO;
+
+	return ret;
+}
+
+static int __init da9052_ts_enable_device(struct da9052_tsi *tsi)
+{
+	ssize_t ret;
+	struct da9052 *da9052 = tsi->da9052;
+
+	ret = da9052_ts_configure_gpio(tsi->da9052);
+	if (ret < 0)
+		return ret;
+
+	ret = da9052_reg_update(tsi->da9052, DA9052_TSI_CONT_A_REG, 0xFC, 0xC0);
+	if (ret < 0)
+		return ret;
+
+	tsi->valid_penup_count = 5;
+
+	init_completion(&tsi->tsi_pen_state_thread.notifier);
+	tsi->tsi_pen_state_thread.state = DA9052_ACTIVE;
+	tsi->tsi_pen_state_thread.pid = kernel_thread(da9052_ts_monitor_pen_state, tsi,
+						      CLONE_KERNEL | SIGCHLD);
+
+	init_completion(&tsi->tsi_filter_thread.notifier);
+	tsi->tsi_filter_thread.state = DA9052_ACTIVE;
+	tsi->tsi_filter_thread.pid = kernel_thread(da9052_ts_process_thread, tsi,
+						   CLONE_KERNEL | SIGCHLD);
+
+	tsi->zero_data_cnt = 0;
+
+	/* Measure TSI sample every 1ms */
+	ret = da9052_reg_update(tsi->da9052, DA9052_ADC_CONT_REG,
+				1 << 6, 1 << 6);
+	if (ret < 0)
+		return ret;
+
+	/* TSI_DELAY: 4 slots, TSI_SKIP: 0 slots, TSI_MODE: XYZP */
+	ret = da9052_reg_update(tsi->da9052, DA9052_TSI_CONT_A_REG,
+				1 << 1, 1 << 1);
+	if (ret < 0)
+		return ret;
+
+	da9052->events_mask |= DA9052_E_TSI_READY;
+
+	/* Mask TSI_READY event*/
+	ret = da9052_reg_update(da9052, DA9052_IRQ_MASK_B_REG, 0, 0x80);
+	if (ret < 0)
+		return ret;
+
+	/*Supply TSIRef thru LD09 */
+	ret = da9052_reg_write(tsi->da9052, DA9052_LDO9_REG, 0x59);
+
+	return ret;
+}
+
+static s32 __devinit da9052_ts_probe(struct platform_device *pdev)
+{
+	struct da9052_tsi *tsi;
+	struct input_dev *input_dev;
+	struct da9052 *da9052;
+	int ret;
+
+	da9052 = dev_get_drvdata(pdev->dev.parent);
+
+	tsi = kzalloc(sizeof(struct da9052_tsi), GFP_KERNEL);
+	if (!tsi)
+		return -ENOMEM;
+
+	input_dev = input_allocate_device();
+	if (!input_dev) {
+		dev_err(tsi->da9052->dev,
+			"failed to allocate input device\n");
+		ret = -ENOMEM;
+		goto err_mem;
+	}
+
+	ret = kfifo_alloc(&tsi->fifo, DA9052_TSI_FIFOSIZE, GFP_KERNEL);
+	if (ret < 0)
+		goto err_input;
+
+	ret = kfifo_alloc(&tsi->fifo_buf, DA9052_TSI_FIFOSIZE, GFP_KERNEL);
+	if (ret < 0)
+		goto err_fifo;
+
+	tsi->da9052 = da9052;
+	tsi->pen_up_detect_interval = 5;
+	platform_set_drvdata(pdev, tsi);
+
+	input_dev->id.version = 0x0101;
+	input_dev->id.vendor = 0x15B6;
+	input_dev->id.product = 0x9052;
+	input_dev->id.bustype = BUS_RS232;
+	input_dev->name = "Dialog DA9052 TouchScreen Driver";
+	input_dev->dev.parent	= &pdev->dev;
+	__set_bit(EV_ABS, input_dev->evbit);
+	__set_bit(EV_KEY, input_dev->evbit);
+	__set_bit(BTN_TOUCH, input_dev->keybit);
+	__set_bit(ABS_X, input_dev->absbit);
+	__set_bit(ABS_Y, input_dev->absbit);
+
+	input_set_abs_params(input_dev, ABS_X, 0, 1023, 0, 0);
+	input_set_abs_params(input_dev, ABS_Y, 0, 1023, 0, 0);
+	input_set_abs_params(input_dev, ABS_PRESSURE, 0, 1023, 0, 0);
+
+	tsi->dev = input_dev;
+	input_set_drvdata(input_dev, tsi);
+	ret = input_register_device(tsi->dev);
+	if (ret)
+		goto err_mem;
+
+	tsi->irq_pendwn = platform_get_irq_byname(pdev, "PENDWN");
+	ret = request_threaded_irq(tsi->da9052->irq_base + tsi->irq_pendwn,
+				NULL, da9052_ts_pendwn_irq,
+				IRQF_TRIGGER_LOW | IRQF_ONESHOT,
+				"PENDWN", tsi);
+	if (ret < 0) {
+		dev_err(tsi->da9052->dev,
+			"Failed to register %s IRQ %d, error = %d\n", "PENDWN",
+			tsi->da9052->irq_base + tsi->irq_pendwn, ret);
+		goto err_fifo_buf;
+	}
+
+	tsi->irq_datardy = platform_get_irq_byname(pdev, "TSIRDY");
+	ret = request_threaded_irq(tsi->da9052->irq_base + tsi->irq_datardy,
+				NULL, da9052_ts_datardy_irq,
+				IRQF_TRIGGER_LOW | IRQF_ONESHOT,
+				"TSIRDY", tsi);
+	if (ret < 0) {
+		dev_err(tsi->da9052->dev,
+			"Failed to register %s IRQ %d, error = %d\n", "TSIRDY",
+			tsi->da9052->irq_base + tsi->irq_datardy, ret);
+		goto err_fifo_buf;
+	}
+
+	ret = da9052_ts_enable_device(tsi);
+	if (ret < 0)
+		goto err_fifo_buf;
+
+	return 0;
+
+err_fifo_buf:
+	kfifo_free(&tsi->fifo_buf);
+err_fifo:
+	kfifo_free(&tsi->fifo);
+err_input:
+	input_free_device(input_dev);
+err_mem:
+	kfree(tsi);
+	return ret;
+}
+
+static int __devexit da9052_ts_remove(struct platform_device *pdev)
+{
+	struct da9052_tsi *tsi = platform_get_drvdata(pdev);
+	s32 ret;
+
+	ret = da9052_clear_bits(tsi->da9052, DA9052_TSI_CONT_A_REG, 1 << 0);
+	if (ret < 0)
+		return ret;
+
+	ret = da9052_reg_write(tsi->da9052, DA9052_LDO9_REG, 0x19);
+	if (ret < 0)
+		return ret;
+
+	free_irq(tsi->da9052->irq_base + tsi->irq_pendwn, NULL);
+	free_irq(tsi->da9052->irq_base + tsi->irq_datardy, NULL);
+
+	tsi->tsi_pen_state_thread.state = DA9052_INACTIVE;
+	wait_for_completion(&tsi->tsi_pen_state_thread.notifier);
+
+	tsi->tsi_filter_thread.state = DA9052_INACTIVE;
+	wait_for_completion(&tsi->tsi_filter_thread.notifier);
+
+	input_unregister_device(tsi->dev);
+
+	platform_set_drvdata(pdev, NULL);
+
+	kfifo_free(&tsi->fifo);
+	kfifo_free(&tsi->fifo_buf);
+	kfree(tsi);
+
+	return 0;
+}
+
+static struct platform_driver da9052_tsi_driver = {
+	.probe = da9052_ts_probe,
+	.remove = __devexit_p(da9052_ts_remove),
+	.driver = {
+		.name = "da9052-tsi",
+		.owner = THIS_MODULE,
+	},
+};
+
+static int __init da9052_ts_init(void)
+{
+	return platform_driver_register(&da9052_tsi_driver);
+}
+module_init(da9052_ts_init);
+
+static void __exit da9052_ts_exit(void)
+{
+	platform_driver_unregister(&da9052_tsi_driver);
+}
+module_exit(da9052_ts_exit);
+
+MODULE_DESCRIPTION("Touchscreen driver for Dialog Semiconductor DA9052");
+MODULE_AUTHOR("David Dajun Chen <dchen@diasemi.com>");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:da9052-tsi");


