Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758009Ab0GBJGW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 05:06:22 -0400
Received: from mailrelay1.diasemi.com ([82.210.246.133]:22897 "EHLO
	mailrelay1.diasemi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756878Ab0GBJGS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 05:06:18 -0400
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: [PATCHv2 8/11] TOUCHSCREEN: Reformatting of files and removal of testing framework
Date: Fri, 2 Jul 2010 10:06:13 +0100
Message-ID: <3495EC08FA53E94AAA00CC4743D5BA7E013FA8DB@pandora.diasemi.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCHv2 8/11] TOUCHSCREEN: Reformatting of files and removal of testing framework
Thread-Index: AcsZxdHqgDwDiLaNTLCb4h6h2Pm8Qw==
From: "David Dajun Chen" <Dajun.Chen@diasemi.com>
To: <dmitry.torokhov@gmail.com>, <dtor@mail.ru>
Cc: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 02 Jul 2010 09:06:15.0109 (UTC) FILETIME=[D3193F50:01CB19C5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

TSI module of the device driver for DA9052 PMIC device from Dialog
Semiconductor.

Changes made since last submission:
. collection of raw TSI samples moved from EH to TSI module as per MFD
comments
. da9052-tsi.c, da9052-tsi_calibrate.c, da9052_tsi_filter.c changed to 
. da9052-ts.c, da9052-ts-core.c and da9052-ts-process.c
. da9052-ts.c: Main tsi driver file
. da9052-ts-core.c; TSI configuration and event handling
. da9052-ts-process.c: TSI data processing
. removal of redundant printk and comments

Linux Kernel Version: 2.6.34

Signed-off-by: D. Chen <dchen@diasemi.com>
---
diff -urpN linux-2.6.34/drivers/input/touchscreen/da9052-ts.c
linux-2.6.34_test/drivers/input/touchscreen/da9052-ts.c
--- linux-2.6.34/drivers/input/touchscreen/da9052-ts.c	1970-01-01
05:00:00.000000000 +0500
+++ linux-2.6.34_test/drivers/input/touchscreen/da9052-ts.c
2010-07-01 18:20:48.000000000 +0500
@@ -0,0 +1,219 @@
+/*
+ * Copyright(c) 2009 Dialog Semiconductor Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * da9052-tsi.c: Driver for Touch Screen interface on DA9052 chip.
+ */
+
+#include <linux/mfd/da9052/reg.h>
+#include <linux/mfd/da9052/tsi.h>
+
+ssize_t da9052_config_state(struct da9052_ts_priv *ts, enum TSI_STATE
state)
+{
+	s32 ret;
+
+	if (ts->tsi_conf.state == state)
+		return 0;
+
+	switch (state) {
+	case TSI_AUTO_MODE:
+		ts->tsi_zero_data_cnt = 0;
+
+		ret = da9052_config_auto_mode(ts, DISABLE);
+		if (ret)
+			return 0;
+
+		ret = da9052_config_power_supply(ts, DISABLE);
+		if (ret)
+			return ret;
+
+		ret = da9052_tsi_enable_irq(ts, TSI_PEN_DWN);
+		if (ret)
+			return ret;
+		ts->tsi_conf.tsi_pendown_irq_mask = RESET;
+
+		ret = da9052_tsi_disable_irq(ts, TSI_DATA_RDY);
+		if (ret)
+			return ret;
+		ts->tsi_conf.tsi_ready_irq_mask	  = SET;
+
+		da9052_tsi_reg_pendwn_event(ts);
+
+		ret = da9052_config_pen_detect(ts, ENABLE);
+		if (ret)
+			return ret;
+		break;
+	case TSI_IDLE:
+		ts->pen_dwn_event = RESET;
+
+		ret = da9052_config_pen_detect(ts, DISABLE);
+		if (ret)
+			return ret;
+
+		ret = da9052_config_auto_mode(ts, DISABLE);
+		if (ret)
+			return ret;
+
+		ret = da9052_config_power_supply(ts, DISABLE);
+		if (ret)
+			return ret;
+
+		if (ts->pd_reg_status) {
+
ts->da9052->unregister_event_notifier(ts->da9052,
+
&ts->eh_data);
+			ts->pd_reg_status = RESET;
+		}
+		break;
+
+	default:
+		return -EINVAL;
+	}
+
+	ts->tsi_conf.state = state;
+
+	return 0;
+}
+
+static int da9052_ts_open(struct input_dev *dev)
+{
+	struct da9052_ts_priv *priv = input_get_drvdata(dev);
+	int ret;
+
+	ret = da9052_config_gpio(priv->da9052);
+	if (ret)
+		return ret;
+
+	ret = da9052_config_state(priv, TSI_IDLE);
+	if (ret)
+		return ret;
+	priv->tsi_conf.state = TSI_IDLE;
+
+	ret = da9052_config_measure_seq(priv, TSI_MODE_VALUE);
+	if (ret)
+		return ret;
+
+	ret = da9052_config_skip_slots(priv, TSI_SLOT_SKIP_VALUE);
+	if (ret)
+		return ret;
+
+	ret =  da9052_config_delay(priv, TSI_DELAY_VALUE);
+	if (ret)
+		return ret;
+
+	da9052_set_sampling_mode(priv, DEFAULT_TSI_SAMPLING_MODE);
+	if (ret)
+		return ret;
+
+	priv->fifo_start = 0;
+	priv->fifo_end = 0;
+
+	mutex_init(&priv->tsi_fifo_lock);
+
+	priv->tsi_state = WAIT_FOR_PEN_DOWN;
+
+	INIT_DELAYED_WORK(&priv->tsi_work, da9052_tsi_work);
+
+	ret = da9052_config_state(priv, DEFAULT_TSI_STATE);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
+static void da9052_ts_close(struct input_dev *dev)
+{
+	struct da9052_ts_priv *priv = input_get_drvdata(dev);
+	cancel_delayed_work_sync(&priv->tsi_work);
+	mutex_destroy(&priv->tsi_fifo_lock);
+	return;
+}
+static int __devinit da9052_touch_probe(struct platform_device *pdev)
+{
+	struct da9052_ts_priv *priv;
+	struct input_dev *idev;
+	int ret = -ENOMEM;
+
+	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
+	idev = input_allocate_device();
+	if (!priv || !idev)
+		goto err_free_mem;
+
+	priv->da9052 = dev_get_drvdata(pdev->dev.parent);
+	priv->idev = idev;
+
+
+	idev->name = DA9052_TSI_INPUT_DEV;
+	idev->phys = "input(tsi)";
+	idev->dev.parent = &pdev->dev;
+	idev->id.vendor = DA9052_VENDOR_ID;
+	idev->id.product = DA9052_PRODUCT_ID;
+	idev->id.bustype = BUS_RS232;
+	idev->id.version = TSI_VERSION;
+	idev->keybit[BIT_WORD(BTN_TOUCH)] = BIT_MASK(BTN_TOUCH);
+	idev->evbit[0] = (BIT_MASK(EV_SYN) |
+			BIT_MASK(EV_KEY) |
+			BIT_MASK(EV_ABS));
+
+	input_set_abs_params(idev, ABS_X, 0, 0x3FF, 0, 0);
+	input_set_abs_params(idev, ABS_Y, 0, 0x3FF, 0, 0);
+	input_set_abs_params(idev, ABS_PRESSURE, 0, 0x3FF, 0, 0);
+
+	idev->open = da9052_ts_open;
+	idev->close = da9052_ts_close;
+
+	input_set_drvdata(idev, priv);
+
+	ret = input_register_device(priv->idev);
+	if (ret)
+		goto err_free_mem;
+
+	platform_set_drvdata(pdev, priv);
+
+	return 0;
+
+err_free_mem:
+	input_free_device(idev);
+	kfree(priv);
+	return ret;
+}
+
+static int __devexit da9052_touch_remove(struct platform_device *pdev)
+{
+	struct da9052_ts_priv *priv = platform_get_drvdata(pdev);
+
+	platform_set_drvdata(pdev, NULL);
+	input_unregister_device(priv->idev);
+	kfree(priv);
+
+	return 0;
+}
+
+static struct platform_driver da9052_touch_driver = {
+	.driver	= {
+		.name	= DRIVER_NAME,
+		.owner	= THIS_MODULE,
+	},
+	.probe		= da9052_touch_probe,
+	.remove		= __devexit_p(da9052_touch_remove),
+};
+
+static int __init da9052_touch_init(void)
+{
+	return platform_driver_register(&da9052_touch_driver);
+}
+module_init(da9052_touch_init);
+
+static void __exit da9052_touch_exit(void)
+{
+	platform_driver_unregister(&da9052_touch_driver);
+}
+module_exit(da9052_touch_exit);
+
+MODULE_DESCRIPTION("Touchscreen driver for Dialog Semiconductor
DA9052");
+MODULE_AUTHOR("David Dajun Chen <dchen@diasemi.com>")
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:" DRIVER_NAME);
diff -urpN linux-2.6.34/drivers/input/touchscreen/da9052-ts-core.c
linux-2.6.34_test/drivers/input/touchscreen/da9052-ts-core.c
--- linux-2.6.34/drivers/input/touchscreen/da9052-ts-core.c
1970-01-01 05:00:00.000000000 +0500
+++ linux-2.6.34_test/drivers/input/touchscreen/da9052-ts-core.c
2010-07-01 18:20:48.000000000 +0500
@@ -0,0 +1,641 @@
+/*
+ * Copyright(c) 2009 Dialog Semiconductor Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * da9052-tsi-core.c: TSI driver configuration and raw samples
handling.
+*/
+
+#include <linux/module.h>
+#include <linux/input.h>
+#include <linux/delay.h>
+#include <linux/platform_device.h>
+#include <linux/freezer.h>
+
+#include <linux/mfd/da9052/reg.h>
+#include <linux/mfd/da9052/da9052.h>
+#include <linux/mfd/da9052/tsi.h>
+
+#define NUM_GPIO_TSI_REGISTERS			3
+#define TSI_DELAY_BIT_SHIFT			6
+#define TSI_SKIP_BIT_SHIFT			3
+
+static int process_pendwn_event(struct da9052_ts_priv *ts);
+static int da9052_tsi_start_sampling(struct da9052_ts_priv *ts);
+
+int da9052_config_gpio(struct da9052 *da9052)
+{
+	unsigned char idx = 0;
+	int ret = 0;
+	struct da9052_ssc_msg ssc_msg[NUM_GPIO_TSI_REGISTERS];
+
+	ssc_msg[idx++].addr  = DA9052_GPIO0203_REG;
+	ssc_msg[idx++].addr  = DA9052_GPIO0405_REG;
+	ssc_msg[idx++].addr  = DA9052_GPIO0607_REG;
+
+	da9052_lock(da9052);
+	ret = da9052->read_many(da9052, ssc_msg, idx);
+	if (ret) {
+		da9052_unlock(da9052);
+		return ret;
+	}
+	da9052_unlock(da9052);
+
+	idx = 0;
+	ssc_msg[idx].data = (ssc_msg[idx].data &
~(DA9052_GPIO0203_GPIO3PIN));
+
+	idx++;
+	ssc_msg[idx].data = (ssc_msg[idx].data &
+			~(DA9052_GPIO0405_GPIO4PIN |
DA9052_GPIO0405_GPIO5PIN));
+
+	idx++;
+	ssc_msg[idx].data = (ssc_msg[idx].data &
+			~(DA9052_GPIO0607_GPIO6PIN |
DA9052_GPIO0607_GPIO7PIN));
+	idx++;
+
+	da9052_lock(da9052);
+	ret = da9052->write_many(da9052, ssc_msg, idx);
+	if (ret) {
+		da9052_unlock(da9052);
+		return ret;
+	}
+	da9052_unlock(da9052);
+
+	return 0;
+}
+
+int da9052_config_pen_detect(struct da9052_ts_priv *ts, unsigned char
flag)
+{
+	u32 ret;
+	struct da9052_ssc_msg msg;
+
+	msg.addr = DA9052_TSICONTA_REG;
+	msg.data = 0;
+	da9052_lock(ts->da9052);
+	ret = ts->da9052->read(ts->da9052, &msg);
+	if (ret < 0) {
+		da9052_unlock(ts->da9052);
+		return ret;
+	}
+	da9052_unlock(ts->da9052);
+
+	if (flag == ENABLE)
+		msg.data = (msg.data | DA9052_TSICONTA_PENDETEN);
+	else if (flag == DISABLE)
+		msg.data = (msg.data  & ~(DA9052_TSICONTA_PENDETEN));
+	else
+		return -EINVAL;
+
+	da9052_lock(ts->da9052);
+	ret = ts->da9052->write(ts->da9052, &msg);
+	if (ret < 0) {
+		da9052_unlock(ts->da9052);
+		return ret;
+	}
+	da9052_unlock(ts->da9052);
+	ts->tsi_conf.auto_cont.da9052_tsi_cont_a = msg.data;
+
+	return 0;
+}
+
+int da9052_config_auto_mode(struct da9052_ts_priv *ts, unsigned char
state)
+{
+	unsigned char data;
+	int ret = 0;
+	struct da9052_ssc_msg msg;
+
+	if (state != ENABLE && state != DISABLE)
+		return -EINVAL;
+
+	msg.addr = DA9052_TSICONTA_REG;
+	msg.data = 0;
+	da9052_lock(ts->da9052);
+	ret = ts->da9052->read(ts->da9052, &msg);
+	if (ret) {
+		da9052_unlock(ts->da9052);
+		return ret;
+	}
+	da9052_unlock(ts->da9052);
+
+	data = (unsigned char)ret;
+
+	if (state == ENABLE)
+		msg.data = (msg.data |= DA9052_TSICONTA_AUTOTSIEN);
+	else if (state == DISABLE)
+		msg.data = (msg.data &= ~DA9052_TSICONTA_AUTOTSIEN);
+	else
+		return -EINVAL;
+
+	da9052_lock(ts->da9052);
+	ret = ts->da9052->write(ts->da9052, &msg);
+	if (ret) {
+		da9052_unlock(ts->da9052);
+		return ret;
+	}
+	da9052_unlock(ts->da9052);
+
+	ts->tsi_conf.auto_cont.da9052_tsi_cont_a = data;
+
+	return 0;
+}
+
+int da9052_pm_configure_set_ldo(struct da9052_ts_priv *ts, unsigned
char state)
+{
+	u8 ldo_conf_bit = 0;
+	u8 ldo_en_bit = 0;
+	struct da9052_ssc_msg msg;
+	int ret = 0;
+
+	if ((ts->ldo_config.ldo_volt >= DA9052_LDO9_VOLT_LOWER) &&
+			(ts->ldo_config.ldo_volt <=
DA9052_LDO9_VOLT_UPPER))
+		return -EINVAL;
+
+	if ((ts->ldo_config.ldo_volt -
+				DA9052_LDO9_VOLT_LOWER) %
LDO9_VOLT_STEP)
+		return -EINVAL;
+
+	ts->ldo_config.ldo_volt = (ts->ldo_config.ldo_volt -
+				DA9052_LDO9_VOLT_LOWER/LDO9_VOLT_STEP);
+	ldo_conf_bit = DA9052_LDO9_LDO9CONF;
+	ldo_en_bit = DA9052_LDO9_LDO9EN;
+	msg.addr = DA9052_LDO9_REG;
+	msg.data = 0;
+
+	da9052_lock(ts->da9052);
+	ret = ts->da9052->read(ts->da9052, &msg);
+	if (ret) {
+		da9052_unlock(ts->da9052);
+		return ret;
+	}
+	msg.data = ts->ldo_config.ldo_volt |
+		(ts->ldo_config.ldo_conf ? ldo_conf_bit : 0) |
+		(msg.data & ldo_en_bit);
+
+	msg.data = (state & ldo_en_bit) | msg.data;
+
+	ret = ts->da9052->write(ts->da9052, &msg);
+	if (ret) {
+		da9052_unlock(ts->da9052);
+		return ret;
+	}
+
+	da9052_unlock(ts->da9052);
+	return ret;
+}
+
+int da9052_config_power_supply(struct da9052_ts_priv *ts, unsigned char
state)
+{
+	if (state != ENABLE && state != DISABLE)
+		return -EINVAL;
+
+	ts->ldo_config.ldo_volt = DA9052_TSI_SUPPLY_VOLTAGE;
+	ts->ldo_config.ldo_num = DA9052_TSI_REF_SOURCE;
+	ts->ldo_config.ldo_conf = RESET;
+
+	if (da9052_pm_configure_set_ldo(ts, state))
+		return -EIO;
+
+	if (state == ENABLE)
+		ts->tsi_conf.ldo9_en = SET;
+	else
+		ts->tsi_conf.ldo9_en = RESET;
+
+	return 0;
+}
+
+int da9052_tsi_enable_irq(struct da9052_ts_priv *ts, enum TSI_IRQ
tsi_irq)
+{
+	int ret = 0;
+	struct da9052_ssc_msg msg;
+
+	msg.addr = DA9052_IRQMASKB_REG;
+	msg.data = 0;
+	da9052_lock(ts->da9052);
+	ret = ts->da9052->read(ts->da9052, &msg);
+	if (ret)
+		goto err_ssc;
+	da9052_unlock(ts->da9052);
+
+	switch (tsi_irq) {
+	case TSI_PEN_DWN:
+			msg.data = (msg.data &
~DA9052_IRQMASKB_MPENDOWN);
+		break;
+	case TSI_DATA_RDY:
+			msg.data = (msg.data &
~DA9052_IRQMASKB_MTSIREADY);
+		break;
+	default:
+			return -EINVAL;
+	}
+	da9052_lock(ts->da9052);
+	ret = ts->da9052->write(ts->da9052, &msg);
+	if (ret)
+		goto err_ssc;
+	da9052_unlock(ts->da9052);
+
+	switch (tsi_irq) {
+	case TSI_PEN_DWN:
+			ts->tsi_conf.tsi_pendown_irq_mask = RESET;
+		break;
+	case TSI_DATA_RDY:
+			ts->tsi_conf.tsi_ready_irq_mask = RESET;
+	break;
+	}
+	return 0;
+err_ssc:
+	da9052_unlock(ts->da9052);
+	return -EIO;
+}
+
+int da9052_tsi_disable_irq(struct da9052_ts_priv *ts, enum TSI_IRQ
tsi_irq)
+{
+	int ret = 0;
+	struct da9052_ssc_msg msg;
+
+	msg.addr = DA9052_IRQMASKB_REG;
+	msg.data = 0;
+	da9052_lock(ts->da9052);
+	ret = ts->da9052->read(ts->da9052, &msg);
+	if (ret)
+		goto err_ssc;
+	da9052_unlock(ts->da9052);
+
+	switch (tsi_irq) {
+	case TSI_PEN_DWN:
+		msg.data = (msg.data |= DA9052_IRQMASKB_MPENDOWN);
+		break;
+	case TSI_DATA_RDY:
+		msg.data = (msg.data |= DA9052_IRQMASKB_MTSIREADY);
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	da9052_lock(ts->da9052);
+	ret = ts->da9052->write(ts->da9052, &msg);
+	if (ret)
+		goto err_ssc;
+	da9052_unlock(ts->da9052);
+
+	switch (tsi_irq) {
+	case TSI_PEN_DWN:
+		ts->tsi_conf.tsi_pendown_irq_mask = SET;
+		break;
+	case TSI_DATA_RDY:
+		ts->tsi_conf.tsi_ready_irq_mask = SET;
+		break;
+	}
+
+	return 0;
+err_ssc:
+	da9052_unlock(ts->da9052);
+	return -EIO;
+}
+void da9052_tsi_notifier(struct da9052_eh_nb *eh_data, unsigned int
event)
+{
+	struct da9052_ts_priv *tsi = \
+		container_of(eh_data,
+			struct da9052_ts_priv, eh_data);
+
+	int ret = 0;
+	struct da9052_ssc_msg tsi_reg_data[4];
+
+	switch (tsi->tsi_state) {
+	case WAIT_FOR_PEN_DOWN:
+		if (event == PEN_DOWN_EVE) {
+			dev_info(&tsi->idev->dev, "PEN DOWN
DETECTED\n");
+
+			tsi->tsi_state = WAIT_FOR_SAMPLING;
+
+			process_pendwn_event(tsi);
+
+			tsi->tsi_rdy_event =
+				(DA9052_EVENTB_ETSIREADY & (event>>8));
+			tsi->pen_dwn_event =
+				(DA9052_EVENTB_EPENDOWN & (event>>8));
+		}
+		break;
+	case WAIT_FOR_SAMPLING:
+		break;
+	case SAMPLING_ACTIVE:
+		if (event == TSI_READY_EVE) {
+			tsi_reg_data[0].addr  = DA9052_TSIXMSB_REG;
+			tsi_reg_data[1].addr  = DA9052_TSIYMSB_REG;
+			tsi_reg_data[2].addr  = DA9052_TSILSB_REG;
+			tsi_reg_data[3].addr  = DA9052_TSIZMSB_REG;
+			tsi_reg_data[0].data  = 0;
+			tsi_reg_data[1].data  = 0;
+			tsi_reg_data[2].data  = 0;
+			tsi_reg_data[3].data  = 0;
+
+			da9052_lock(tsi->da9052);
+			ret = tsi->da9052->read_many(tsi->da9052,
+					tsi_reg_data, 4);
+			if (ret) {
+				dev_err(&tsi->idev->dev, "Error in \
+					reading TSi registers \n");
+				da9052_unlock(tsi->da9052);
+				return;
+			}
+			da9052_unlock(tsi->da9052);
+
+			if
(mutex_lock_interruptible(&tsi->tsi_fifo_lock))
+				return;
+			tsi->tsi_data[tsi->fifo_end].x_msb =
+					tsi_reg_data[0].data;
+			tsi->tsi_data[tsi->fifo_end].y_msb =
+					tsi_reg_data[1].data;
+			tsi->tsi_data[tsi->fifo_end].lsb =
+					tsi_reg_data[2].data;
+			tsi->tsi_data[tsi->fifo_end].z_msb
+					= tsi_reg_data[3].data;
+
+			incr_with_wrap(tsi->fifo_end);
+
+			if (tsi->fifo_end == tsi->fifo_start)
+				tsi->fifo_start++;
+
+			if (tsi->fifo_start >= TSI_FIFO_SIZE)
+				tsi->fifo_start %= TSI_FIFO_SIZE;
+
+			mutex_unlock(&tsi->tsi_fifo_lock);
+
+		}
+		break;
+	default:
+		break;
+	}
+}
+int da9052_tsi_reg_pendwn_event(struct da9052_ts_priv *ts)
+{
+	int ret = 0;
+
+	if (ts->pd_reg_status)
+		return 0;
+
+	ts->eh_data.eve_type = PEN_DOWN_EVE;
+	ts->eh_data.call_back = da9052_tsi_notifier;
+	ret = ts->da9052->register_event_notifier(ts->da9052,
&ts->eh_data);
+
+	if (ret) {
+		ts->pd_reg_status = RESET;
+		return -EIO;
+
+	} else {
+		ts->pd_reg_status = SET;
+	}
+
+	return 0;
+}
+
+int da9052_tsi_reg_datardy_event(struct da9052_ts_priv *ts)
+{
+	int ret = 0;
+
+	if (ts->dr_reg_status)
+		return 0;
+
+	ts->eh_data.eve_type = TSI_READY_EVE;
+	ts->eh_data.call_back = da9052_tsi_notifier;
+	ret = ts->da9052->register_event_notifier(ts->da9052,
&ts->eh_data);
+
+	if (ret) {
+		ts->dr_reg_status = RESET;
+		return -EIO;
+
+	} else {
+		ts->dr_reg_status = SET;
+	}
+
+	return 0;
+}
+
+int da9052_config_measure_seq(struct da9052_ts_priv *ts,
+				enum TSI_MEASURE_SEQ seq)
+{
+	int ret = 0;
+	struct da9052_ssc_msg msg;
+
+	if (seq > 1)
+		return -EINVAL;
+
+	msg.addr = DA9052_TSICONTA_REG;
+	msg.data = 0;
+	da9052_lock(ts->da9052);
+	ret = ts->da9052->read(ts->da9052, &msg);
+	if (ret)
+		goto err_ssc;
+	da9052_unlock(ts->da9052);
+
+	if (seq == XYZP_MODE)
+		msg.data = (msg.data &= ~DA9052_TSICONTA_TSIMODE);
+	else if (seq == XP_MODE)
+		msg.data = (msg.data |= DA9052_TSICONTA_TSIMODE);
+	else
+		return -EINVAL;
+
+	da9052_lock(ts->da9052);
+	ret = ts->da9052->write(ts->da9052, &msg);
+	if (ret)
+		goto err_ssc;
+	da9052_unlock(ts->da9052);
+
+	ts->tsi_conf.auto_cont.da9052_tsi_cont_a = msg.data;
+
+	return 0;
+err_ssc:
+	da9052_unlock(ts->da9052);
+	return -EIO;
+}
+
+int da9052_config_skip_slots(struct da9052_ts_priv *ts,
+				enum TSI_SLOT_SKIP skip)
+{
+	int ret = 0;
+	struct da9052_ssc_msg msg;
+
+	if (skip > MAX_TSI_SKIP_SLOT)
+		return -EINVAL;
+
+	msg.addr = DA9052_TSICONTA_REG;
+	msg.data = 0;
+	da9052_lock(ts->da9052);
+	ret = ts->da9052->read(ts->da9052, &msg);
+	if (ret)
+		goto err_ssc;
+	da9052_unlock(ts->da9052);
+
+	msg.data = (msg.data & ~(DA9052_TSICONTA_TSISKIP));
+	msg.data = (msg.data & ~(skip << TSI_SKIP_BIT_SHIFT));
+
+	da9052_lock(ts->da9052);
+	ret = ts->da9052->write(ts->da9052, &msg);
+	if (ret)
+		goto err_ssc;
+	da9052_unlock(ts->da9052);
+	ts->tsi_conf.auto_cont.da9052_tsi_cont_a = msg.data;
+
+	return 0;
+err_ssc:
+	da9052_unlock(ts->da9052);
+	return -EIO;
+}
+
+int da9052_config_delay(struct da9052_ts_priv *ts,
+			enum TSI_DELAY delay)
+{
+	int ret = 0;
+	struct da9052_ssc_msg msg;
+
+	if (delay > MAX_TSI_DELAY)
+		return -EINVAL;
+
+	msg.addr = DA9052_TSICONTA_REG;
+	msg.data = 0;
+	da9052_lock(ts->da9052);
+	ret = ts->da9052->read(ts->da9052, &msg);
+	if (ret)
+		goto err_ssc;
+	da9052_unlock(ts->da9052);
+
+	msg.data = (msg.data & ~(DA9052_TSICONTA_TSIDELAY));
+
+	msg.data = (msg.data | (delay << TSI_DELAY_BIT_SHIFT));
+
+	da9052_lock(ts->da9052);
+	ret = ts->da9052->write(ts->da9052, &msg);
+	if (ret)
+		goto err_ssc;
+	da9052_unlock(ts->da9052);
+
+	ts->tsi_conf.auto_cont.da9052_tsi_cont_a = msg.data;
+
+	return 0;
+err_ssc:
+	da9052_unlock(ts->da9052);
+	return -EIO;
+}
+
+int da9052_set_sampling_mode(struct da9052_ts_priv *ts, unsigned char
mode)
+{
+	int ret = 0;
+	struct da9052_ssc_msg msg;
+
+	msg.addr = DA9052_ADCCONT_REG;
+	msg.data = 0;
+	da9052_lock(ts->da9052);
+	ret = ts->da9052->read(ts->da9052, &msg);
+	if (ret)
+		goto err_ssc;
+	da9052_unlock(ts->da9052);
+
+	if (mode == ECONOMY_MODE)
+		msg.data = (msg.data &= ~DA9052_ADCCONT_ADCMODE);
+	else if (mode == FAST_MODE)
+		msg.data = (msg.data |= DA9052_ADCCONT_ADCMODE);
+	else
+		return -EINVAL;
+
+	da9052_lock(ts->da9052);
+	ret = ts->da9052->write(ts->da9052, &msg);
+	if (ret)
+		goto err_ssc;
+	da9052_unlock(ts->da9052);
+
+	switch (mode) {
+	case ECONOMY_MODE:
+		ts->tsi_state = ECONOMY_MODE;
+		break;
+	case FAST_MODE:
+		ts->tsi_state = FAST_MODE;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	ts->tsi_penup_count = (u32)TS_PENUP_DETECT_INTERVEL;
+	ts->tsi_data_poll_interval = 0;
+
+	return 0;
+err_ssc:
+	da9052_unlock(ts->da9052);
+	return -EIO;
+}
+
+static int da9052_tsi_start_sampling(struct da9052_ts_priv *ts)
+{
+	if (ts->tsi_state == WAIT_FOR_SAMPLING) {
+		ts->tsi_state =  SAMPLING_ACTIVE;
+		return 0;
+	} else
+		return -EINVAL;
+}
+
+static int process_pendwn_event(struct da9052_ts_priv *ts)
+{
+	int ret = 0;
+	struct input_dev *ip_dev = ts->idev;
+
+	if (ts->tsi_conf.state != TSI_AUTO_MODE) {
+		dev_err(&ts->idev->dev, "Configure TSI in auto mode\n");
+		goto fail;
+	}
+
+	ret = da9052_config_power_supply(ts, ENABLE);
+	if (ret)
+		goto fail;
+
+	ret = da9052_tsi_disable_irq(ts, TSI_PEN_DWN);
+	if (ret)
+		goto fail;
+
+	ret = da9052_tsi_enable_irq(ts, TSI_DATA_RDY);
+	if (ret)
+		goto fail;
+
+	ret = da9052_config_auto_mode(ts, ENABLE);
+	if (ret)
+		goto fail;
+	ts->tsi_conf.auto_cont.tsi_cont_a.auto_tsi_en = SET;
+
+	ret = da9052_tsi_reg_datardy_event(ts);
+	if (ret)
+		goto fail;
+
+	input_report_abs(ip_dev, BTN_TOUCH, 1);
+	input_sync(ip_dev);
+
+	ret = da9052_tsi_start_sampling(ts);
+	if (ret)
+		goto fail;
+
+	switch (ts->tsi_state) {
+	case ECONOMY_MODE:
+		ts->tsi_data_poll_interval =
+			TSI_ECO_MODE_DATA_PROCESSING_INTERVAL;
+		break;
+	case FAST_MODE:
+		ts->tsi_data_poll_interval =
+			TSI_FAST_MODE_DATA_PROCESSING_INTERVAL;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	schedule_delayed_work(&ts->tsi_work,
+			msecs_to_jiffies(ts->tsi_data_poll_interval));
+
+	return 0;
+
+fail:
+	if (ts->pd_reg_status) {
+		ts->da9052->unregister_event_notifier(ts->da9052,
&ts->eh_data);
+		ts->pd_reg_status = RESET;
+		da9052_tsi_reg_pendwn_event(ts);
+	}
+	return ret;
+}
+
diff -urpN linux-2.6.34/drivers/input/touchscreen/da9052-ts-process.c
linux-2.6.34_test/drivers/input/touchscreen/da9052-ts-process.c
--- linux-2.6.34/drivers/input/touchscreen/da9052-ts-process.c
1970-01-01 05:00:00.000000000 +0500
+++ linux-2.6.34_test/drivers/input/touchscreen/da9052-ts-process.c
2010-07-01 18:20:48.000000000 +0500
@@ -0,0 +1,152 @@
+ /*
+ * Copyright(c) 2009 Dialog Semiconductor Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * da9052-tsi-process.c: Converts the TSI reg co-ordinates to
+ *			raw co-ordinates and reports the sample
+ *			to the input sub-system
+ *
+ */
+#include <linux/mfd/da9052/tsi.h>
+
+/* The data from EH is copied in to this buffer. */
+struct da9052_tsi_reg tsidata[TSI_FIFO_SIZE];
+
+static void da9052_penup_event(struct da9052_ts_priv *ts);
+
+u16 da9052_get_tsi_data(struct da9052_ts_priv *ts)
+{
+	u16 data_nt = 0;
+
+	if (mutex_lock_interruptible(&ts->tsi_fifo_lock))
+		return 0;
+
+	if (ts->fifo_start  < ts->fifo_end) {
+		data_nt = (ts->fifo_end - ts->fifo_start);
+
+		memcpy(tsidata, &ts->tsi_data[ts->fifo_start],
+			sizeof(struct da9052_tsi_reg)*data_nt);
+
+	} else if (ts->fifo_start > ts->fifo_end) {
+		data_nt = TSI_FIFO_SIZE;
+
+		memcpy(tsidata, &ts->tsi_data[ts->fifo_start],
+		sizeof(struct da9052_tsi_reg)*(TSI_FIFO_SIZE -
ts->fifo_start));
+
+		memcpy(tsidata, &ts->tsi_data[0],
+		sizeof(struct da9052_tsi_reg)*(ts->fifo_end));
+		ts->fifo_start = 0;
+		ts->fifo_end = 0;
+	} else {
+		data_nt = 0;
+	}
+
+	mutex_unlock(&ts->tsi_fifo_lock);
+
+	return data_nt;
+}
+
+static void da9052_tsi_convert_reg_to_coord(struct da9052_tsi_reg
*src,
+					struct tsi_data *raw_data)
+{
+	/* Convert data from REG format to co-ordinate format */
+	raw_data->x = (src->x_msb << X_MSB_SHIFT);
+	raw_data->x |= (src->lsb & X_LSB_MASK) >> X_LSB_SHIFT;
+
+	raw_data->y = (src->y_msb << Y_MSB_SHIFT);
+	raw_data->y |= (src->lsb & Y_LSB_MASK) >> Y_LSB_SHIFT;
+
+	raw_data->z = (src->z_msb << Z_MSB_SHIFT);
+	raw_data->z |= (src->lsb & Z_LSB_MASK) >> Z_LSB_SHIFT;
+}
+
+void da9052_tsi_work(struct work_struct *work)
+{
+	struct da9052_ts_priv *ts =
+		container_of(work, struct da9052_ts_priv,
tsi_work.work);
+	u16 data_cnt;
+	struct tsi_data tsi_data;
+	u16 cnt = 0;
+
+	if (!ts->pen_dwn_event)
+		return;
+
+	memset(&tsi_data, 0, sizeof(tsi_data));
+
+	data_cnt = da9052_get_tsi_data(ts);
+
+	if (data_cnt) {
+		ts->tsi_zero_data_cnt = 0;
+	} else {
+		ts->tsi_zero_data_cnt++;
+		if (ts->tsi_zero_data_cnt > ts->tsi_penup_count) {
+			dev_info(&ts->idev->dev, "TSI PEN\
+				UP DETECTED \n");
+			ts->pen_dwn_event = RESET;
+			da9052_penup_event(ts);
+		}
+	}
+
+	while (cnt++ <= data_cnt) {
+		da9052_tsi_convert_reg_to_coord(&ts->tsi_data[cnt],
+						&tsi_data);
+
+		if ((tsi_data.x < TS_X_MIN) ||
+			(tsi_data.x > TS_X_MAX) ||
+			(tsi_data.y < TS_Y_MIN) ||
+			(tsi_data.y > TS_Y_MAX)) {
+			/* Data beyond touchscreen boundaries */
+			/* reject this sample */
+			dev_err(&ts->idev->dev, "Sample rejected as\
+			it is beyond touch screen boundaries.\n");
+			continue;
+		}
+
+		input_report_abs(ts->idev, ABS_X, tsi_data.x);
+		input_report_abs(ts->idev, ABS_Y, tsi_data.y);
+		input_report_abs(ts->idev, ABS_Z, tsi_data.z);
+		input_sync(ts->idev);
+
+		memset(&tsi_data, 0, sizeof(tsi_data));
+	}
+}
+
+static void da9052_penup_event(struct da9052_ts_priv *ts)
+{
+	s32 ret;
+
+	ret = da9052_config_auto_mode(ts, DISABLE);
+	if (ret) {
+		ts->tsi_conf.auto_cont.tsi_cont_a.auto_tsi_en = RESET;
+		return;
+	}
+
+	ret = da9052_config_power_supply(ts, DISABLE);
+	if (ret) {
+		ts->tsi_conf.ldo9_en = RESET;
+		return;
+	}
+
+	ret = da9052_tsi_enable_irq(ts, TSI_PEN_DWN);
+	if (ret) {
+		ts->tsi_conf.tsi_pendown_irq_mask = RESET;
+		return;
+	}
+
+	ts->tsi_state =  WAIT_FOR_PEN_DOWN;
+
+	ts->tsi_zero_data_cnt = 0;
+
+	input_report_key(ts->idev, BTN_TOUCH, 0);
+	input_sync(ts->idev);
+
+	ts->tsi_data_poll_interval = 0;
+	schedule_delayed_work(&ts->tsi_work,
+			msecs_to_jiffies(ts->tsi_data_poll_interval));
+	return;
+}
+
diff -urpN linux-2.6.34/drivers/input/touchscreen/Kconfig
linux-2.6.34_test/drivers/input/touchscreen/Kconfig
--- linux-2.6.34/drivers/input/touchscreen/Kconfig	2010-05-17
02:17:36.000000000 +0500
+++ linux-2.6.34_test/drivers/input/touchscreen/Kconfig	2010-07-01
18:21:04.000000000 +0500
@@ -594,4 +594,11 @@ config TOUCHSCREEN_PCAP
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called pcap_ts.
+
+config TOUCHSCREEN_DA9052
+        tristate "Support Touchscreen on Dialog Semiconductor DA9052
PMIC"
+        depends on PMIC_DA9052
+        help
+          Say y here to support the touchscreen found on
+          Dialog Semiconductor DA9052 PMIC
 endif
diff -urpN linux-2.6.34/drivers/input/touchscreen/Makefile
linux-2.6.34_test/drivers/input/touchscreen/Makefile
--- linux-2.6.34/drivers/input/touchscreen/Makefile	2010-05-17
02:17:36.000000000 +0500
+++ linux-2.6.34_test/drivers/input/touchscreen/Makefile
2010-07-01 18:20:56.000000000 +0500
@@ -46,3 +46,5 @@ obj-$(CONFIG_TOUCHSCREEN_WM97XX_ATMEL)	+
 obj-$(CONFIG_TOUCHSCREEN_WM97XX_MAINSTONE)	+= mainstone-wm97xx.o
 obj-$(CONFIG_TOUCHSCREEN_WM97XX_ZYLONITE)	+= zylonite-wm97xx.o
 obj-$(CONFIG_TOUCHSCREEN_W90X900)	+= w90p910_ts.o
+da9052-tsi-objs                   	 := da9052-ts.o da9052-ts-core.o
da9052-ts-process.o
+obj-$(CONFIG_TOUCHSCREEN_DA9052)      	 += da9052-tsi.o
diff -urpN linux-2.6.34/include/linux/mfd/da9052/tsi_cfg.h
linux-2.6.34_test/include/linux/mfd/da9052/tsi_cfg.h
--- linux-2.6.34/include/linux/mfd/da9052/tsi_cfg.h	1970-01-01
05:00:00.000000000 +0500
+++ linux-2.6.34_test/include/linux/mfd/da9052/tsi_cfg.h
2010-07-01 18:22:07.000000000 +0500
@@ -0,0 +1,72 @@
+/*
+ * Copyright(c) 2009 Dialog Semiconductor Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * da9052_tsi_cfg.h: tsi driver configuration file for DA9052
+ *
+ * This file defines configurations used for DA9052 TSI driver.
+ *
+*/
+
+#ifndef _DA9052_TSI_CFG_H
+#define _DA9052_TSI_CFG_H
+
+
+#define AUTO_MODE		0
+#define IDLE			5
+#define DEFAULT_TSI_STATE		AUTO_MODE
+
+/* da9052 TSI static configuration */
+/* TSI slot skip possible configurations are [0, 2, 5, 10, 30, 80, 130,
330]*/
+/* the TSI_SLOT_SKIP equal value [0, 1, 2, 3, 4, 5, 6, 7] */
+#define TSI_SLOT_SKIP_VALUE		0
+
+/* TSI delay possible configurations are [0, 1, 2, 4] */
+/* TSI_DELAY value is [0, 1, 2, 3] */
+#define TSI_DELAY_VALUE			3
+
+/* TSI Mode XYZP Mode = 0 and XP mode is 1 */
+#define TSI_MODE_VALUE			0
+
+/* TSI sampling mode Economy mode = 0; Fast mode =1*/
+#define TSI_ECONOMY_MODE		0
+#define TSI_FAST_MODE			1
+/* set default TSI mode from above two modes */
+#define DEFAULT_TSI_SAMPLING_MODE	TSI_FAST_MODE
+
+/* TSI penup detecting interval in msec*/
+#define TS_PENUP_DETECT_INTERVEL	50
+
+/* Calibartion  Enable(1) / Disable(0) */
+#define TSI_USE_CALIBRATION		1
+
+/* Touchscreen panel dimensions */
+#define TS_X_MIN	(0)
+#define TS_X_MAX	(1023)
+#define TS_Y_MIN	(0)
+#define TS_Y_MAX	(1023)
+
+/* Display panel dimensions */
+#define DISPLAY_X_MIN	(0)
+#define DISPLAY_X_MAX	(1023)
+#define DISPLAY_Y_MIN	(0)
+#define DISPLAY_Y_MAX	(1023)
+
+/* interval at which raw data is processed in msec */
+#define TSI_FAST_MODE_DATA_PROCESSING_INTERVAL	25
+#define TSI_ECO_MODE_DATA_PROCESSING_INTERVAL	100
+
+/* Macro holds value to be assigned for raw data processing interval */
+#if DEFAULT_TSI_SAMPLING_MODE
+#define DEFAULT_RAW_DATA_PROCESSING_INTERVAL \
+TSI_FAST_MODE_DATA_PROCESSING_INTERVAL
+#else
+#define DEFAULT_RAW_DATA_PROCESSING_INTERVAL \
+TSI_ECO_MODE_DATA_PROCESSING_INTERVAL
+#endif
+
+#endif
diff -urpN linux-2.6.34/include/linux/mfd/da9052/tsi_filter.h
linux-2.6.34_test/include/linux/mfd/da9052/tsi_filter.h
--- linux-2.6.34/include/linux/mfd/da9052/tsi_filter.h	1970-01-01
05:00:00.000000000 +0500
+++ linux-2.6.34_test/include/linux/mfd/da9052/tsi_filter.h
2010-07-01 18:22:07.000000000 +0500
@@ -0,0 +1,24 @@
+#ifndef _TSI_FILTER_H_
+#define _TSI_FILTER_H_
+
+#include <linux/mfd/da9052/tsi.h>
+
+/* State for TSI thread */
+#define	ACTIVE		0
+#define	INACTIVE	1
+
+struct tsi_data {
+	s16	x;
+	s16	y;
+	s16	z;
+};
+
+struct tsi_thread_type{
+	u8			pid;
+	u8			state;
+	struct completion	notifier;
+};
+
+void da9052_tsi_work(struct work_struct *work);
+
+#endif	/*_TS_FILTER_H_ */
diff -urpN linux-2.6.34/include/linux/mfd/da9052/tsi.h
linux-2.6.34_test/include/linux/mfd/da9052/tsi.h
--- linux-2.6.34/include/linux/mfd/da9052/tsi.h	1970-01-01
05:00:00.000000000 +0500
+++ linux-2.6.34_test/include/linux/mfd/da9052/tsi.h	2010-07-01
18:22:07.000000000 +0500
@@ -0,0 +1,214 @@
+/*
+ * Copyright(c) 2009 Dialog Semiconductor Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * da9052_tsi.h: tsi driver file for DA9052
+ *
+*/
+#ifndef _TSI_H
+#define _TSI_H
+
+#include <linux/module.h>
+#include <linux/input.h>
+#include <linux/delay.h>
+#include <linux/platform_device.h>
+#include <linux/freezer.h>
+
+#include <linux/mfd/da9052/da9052.h>
+#include <linux/mfd/da9052/tsi_cfg.h>
+#include <linux/mfd/da9052/tsi_filter.h>
+
+#define ENABLE		1
+#define DISABLE		0
+#define SET		1
+#define	RESET		0
+#define	CLEAR		0
+
+/* Following macros define TSI control regsiter bit values */
+#define DA9052_TCA_AUTO_TSI_ENABLE		(1<<0)
+#define DA9052_TCA_PEN_DET_ENABLE		(1<<1)
+#define DA9052_TCA_TSI_XP_MODE_ENABLE		(1<<2)
+
+#define DA9052_TCA_TSI_DELAY_0SLOTS		(0<<6)
+#define DA9052_TCA_TSI_DELAY_2SLOTS		(2<<6)
+#define DA9052_TCA_TSI_DELAY_4SLOTS		(3<<6)
+
+#define DA9052_EVETN_B_E_PEN_DOWN		(1<<6)
+#define DA9052_EVENT_B_E_TSI_READY		(1<<7)
+
+#define DA9052_IRQMASK_B_PENDOWN_MASK		(1<<6)
+#define DA9052_IRQMASK_B_TSI_READY_MASK		(1<<7)
+
+#define X_LSB_SHIFT	(0)
+#define Y_LSB_SHIFT	(2)
+#define Z_LSB_SHIFT	(4)
+#define X_MSB_SHIFT	(2)
+#define Y_MSB_SHIFT	(2)
+#define Z_MSB_SHIFT	(2)
+#define  X_LSB_MASK	(11 << X_LSB_SHIFT)
+#define  Y_LSB_MASK	(11 << Y_LSB_SHIFT)
+#define  Z_LSB_MASK	(11 << Z_LSB_SHIFT)
+#define  PEN_DET_MASK	(11 << PEN_DET_SHIFT)
+
+#define DRIVER_NAME			"da9052-tsi"
+#define TSI_INPUT_DEVICE_OFF		0
+#define DA9052_VENDOR_ID		0xAAAA
+#define DA9052_PRODUCT_ID		0x5555
+#define DA9052_TSI_INPUT_DEV		DRIVER_NAME
+#define TSI_VERSION			0x0101
+
+
+#define TSI_DELAY_BIT_SHIFT		6
+
+#define TSI_SKIP_BIT_SHIFT		3
+
+#define NUM_TSI_RESULT_REGISTERS	4
+
+#define DA9052_TSI_SUPPLY_VOLTAGE	2500
+
+#define MAX_TSI_DELAY			TSI_DELAY_4SLOTS
+
+#define MAX_TSI_SKIP_SLOT		TSI_SKIP_330SLOTS
+
+#define DA9052_TSI_REF_SOURCE		DA9052_LDO9
+
+#define TSI_FIFO_SIZE			128
+
+
+#define WAIT_FOR_PEN_DOWN		0
+#define WAIT_FOR_SAMPLING		1
+#define SAMPLING_ACTIVE			2
+
+#define incr_with_wrap(x)	\
+		if (++x >= TSI_FIFO_SIZE) \
+			x = 0
+
+#define DA9052_LDO9_VOLT_UPPER		3650
+#define DA9052_LDO9_VOLT_LOWER		1250
+#define LDO9_VOLT_STEP			50
+#define DA9052_LDO9			9
+
+enum ADC_MODE {
+	ECONOMY_MODE = 0,
+	FAST_MODE = 1
+};
+
+enum TSI_DELAY {
+	TSI_DELAY_0SLOTS = 0,
+	TSI_DELAY_1SLOTS = 1,
+	TSI_DELAY_2SLOTS = 2,
+	TSI_DELAY_4SLOTS = 3
+};
+
+enum TSI_SLOT_SKIP{
+	TSI_SKIP_0SLOTS = 0,
+	TSI_SKIP_2SLOTS = 1,
+	TSI_SKIP_5SLOTS = 2,
+	TSI_SKIP_10SLOTS = 3,
+	TSI_SKIP_30SLOTS = 4,
+	TSI_SKIP_80SLOTS = 5,
+	TSI_SKIP_130SLOTS = 6,
+	TSI_SKIP_330SLOTS = 7
+};
+
+enum TSI_MUX_SEL{
+	TSI_MUX_XPLUS	= 0,
+	TSI_MUX_YPLUS	= 1,
+	TSI_MUX_XMINUS	= 2,
+	TSI_MUX_YMINUS	= 3
+};
+
+enum TSI_IRQ{
+	TSI_PEN_DWN,
+	TSI_DATA_RDY
+};
+
+enum TSI_COORDINATE{
+	X_COORDINATE,
+	Y_COORDINATE,
+	Z_COORDINATE
+};
+
+enum TSI_MEASURE_SEQ{
+	XYZP_MODE,
+	XP_MODE
+};
+
+enum TSI_STATE {
+	TSI_AUTO_MODE,
+	TSI_IDLE
+};
+
+union da9052_tsi_cont_reg {
+	unsigned char da9052_tsi_cont_a;
+	struct{
+		unsigned char auto_tsi_en:1;
+		unsigned char pen_det_en:1;
+		unsigned char tsi_mode:1;
+		unsigned char tsi_skip:3;
+		unsigned char tsi_delay:2;
+	} tsi_cont_a;
+};
+
+struct da9052_tsi_conf{
+	union da9052_tsi_cont_reg	auto_cont;
+	unsigned char			tsi_adc_sample_intervel:1;
+	enum TSI_STATE			state;
+	unsigned char			ldo9_en:1;
+	unsigned char			ldo9_conf:1;
+	unsigned char			tsi_ready_irq_mask:1;
+	unsigned char			tsi_pendown_irq_mask:1;
+};
+
+struct da9052_tsi_reg {
+	unsigned char	x_msb;
+	unsigned char	y_msb;
+	unsigned char	z_msb;
+	unsigned char	lsb;
+};
+
+struct da9052_ldo_config {
+	u16	ldo_volt;
+	u8	ldo_num;
+	u8	ldo_conf:1;
+	u8	ldo_pd:1;
+};
+
+
+struct da9052_ts_priv {
+	struct input_dev		*idev;
+	struct da9052			*da9052;
+	struct da9052_tsi_conf		tsi_conf;
+	struct da9052_eh_nb		eh_data;
+	struct delayed_work		tsi_work;
+	struct mutex			tsi_fifo_lock;
+	struct da9052_ldo_config	ldo_config;
+	struct da9052_tsi_reg		tsi_data[TSI_FIFO_SIZE];
+	unsigned int			fifo_start;
+	unsigned int			fifo_end;
+	unsigned int			tsi_data_poll_interval;
+	unsigned int			tsi_penup_count;
+	unsigned int			tsi_zero_data_cnt;
+	unsigned char			tsi_state;
+	unsigned char			tsi_auto_mode;
+	unsigned char			pen_dwn_event;
+	unsigned char			tsi_rdy_event;
+	unsigned char			pd_reg_status;
+	unsigned char			dr_reg_status;
+};
+
+int da9052_config_gpio(struct da9052 *da9052);
+int da9052_config_pen_detect(struct da9052_ts_priv *ts, unsigned char
flag);
+int da9052_config_auto_mode(struct da9052_ts_priv *ts, unsigned char
state);
+int da9052_config_power_supply(struct da9052_ts_priv *ts, unsigned char
state);
+int da9052_tsi_enable_irq(struct da9052_ts_priv *ts, enum TSI_IRQ
tsi_irq);
+int da9052_tsi_disable_irq(struct da9052_ts_priv *ts, enum TSI_IRQ
tsi_irq);
+int da9052_tsi_reg_pendwn_event(struct da9052_ts_priv *ts);
+int da9052_tsi_reg_datardy_event(struct da9052_ts_priv *ts);
+int da9052_config_measure_seq(struct da9052_ts_priv *ts,
+				enum TSI_MEASURE_SEQ seq);
+int da9052_config_skip_slots(struct da9052_ts_priv *ts,
+				enum TSI_SLOT_SKIP skip);
+int da9052_config_delay(struct da9052_ts_priv *ts, enum TSI_DELAY
delay);
+int da9052_set_sampling_mode(struct da9052_ts_priv *ts, unsigned char
mode);
+
+#endif /* _TSI_H */
Legal Disclaimer: This e-mail communication (and any attachment/s) is confidential and contains proprietary information, 
some or all of which may be legally privileged. It is intended solely for the use of the individual or entity to which it
is addressed. Access to this email by anyone else is unauthorized. If you are not the intended recipient, any disclosure, 
copying, distribution or any action taken or omitted to be taken in reliance on it, is prohibited and may be unlawful.
