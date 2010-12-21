Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752662Ab0LUS15 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 13:27:57 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:39874 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752479Ab0LUS1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 13:27:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=qtjsYG7CKtIQoc4g74imH9f4T/Mol/UuusvVzIJhEhbMTUz1demOmFTxeY07dw0Ed7
         XCj/FW6KCMCkbqhzXLfwQ3Z4ELh730yn6hXO+9EeBHNFV/lmyX4SzRiDV7dq6zKlz49Y
         NvY6dROtS8f8Q/eRWHqBS4vCFYHB1MQ+j8FQ0=
MIME-Version: 1.0
Date: Tue, 21 Dec 2010 19:27:54 +0100
Message-ID: <AANLkTikGsK7-5mBxBHjdf9sa4vYQpV+cvGoMr1ig-8S5@mail.gmail.com>
Subject: [PATCHv3 8/11] Touch: Touch screen module of DA9052 device driver
From: dd diasemi <dd.diasemi@gmail.com>
To: dmitry.torokhov@gmail.com, dtor@mail.ru
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

TSI module for DA9052 PMIC device from Dialog Semiconductor.

Changes made since last submission:
. added chip specific parameters as platform data.

Linux Kernel Version: 2.6.34

Signed-off-by: D. Chen <dchen@diasemi.com>
diff -Naur A-source/drivers/input/touchscreen/da9052_tsi.c
B-source/drivers/input/touchscreen/da9052_tsi.c
--- A-source/drivers/input/touchscreen/da9052_tsi.c	1970-01-01
05:00:00.000000000 +0500
+++ B-source/drivers/input/touchscreen/da9052_tsi.c	2010-12-08
15:51:26.000000000 +0500
@@ -0,0 +1,1309 @@
+/*
+ * da9052_tsi.c  --  TSI driver for Dialog DA9052
+ *
+ * Copyright(c) 2009 Dialog Semiconductor Ltd.
+ *
+ * Author: Dialog Semiconductor Ltd <dchen@diasemi.com>
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
+#include <linux/uaccess.h>
+#include <linux/freezer.h>
+#include <linux/kthread.h>
+
+#include <linux/mfd/da9052/reg.h>
+#include <linux/mfd/da9052/tsi_cfg.h>
+#include <linux/mfd/da9052/tsi.h>
+#include <linux/mfd/da9052/gpio.h>
+#include <linux/mfd/da9052/adc.h>
+
+#define WAIT_FOR_PEN_DOWN	0
+#define WAIT_FOR_SAMPLING	1
+#define SAMPLING_ACTIVE	2
+
+static ssize_t __init da9052_tsi_create_input_dev(struct input_dev **ip_dev,
+					u8 n);
+static ssize_t read_da9052_reg(struct da9052 *da9052, u8 reg_addr);
+static ssize_t write_da9052_reg(struct da9052 *da9052, u8 reg_addr, u8 data);
+
+static void da9052_tsi_reg_pendwn_event(struct da9052_ts_priv *priv);
+static void da9052_tsi_reg_datardy_event(struct da9052_ts_priv *priv);
+static ssize_t da9052_tsi_config_delay(struct da9052_ts_priv *priv,
+					enum TSI_DELAY delay);
+static ssize_t da9052_tsi_config_measure_seq(struct da9052_ts_priv *priv,
+					enum TSI_MEASURE_SEQ seq);
+static ssize_t da9052_tsi_config_state(struct da9052_ts_priv *ts,
+					enum TSI_STATE state);
+static ssize_t da9052_tsi_set_sampling_mode(struct da9052_ts_priv *priv,
+					u8 interval);
+static ssize_t da9052_tsi_config_skip_slots(struct da9052_ts_priv *priv,
+					enum TSI_SLOT_SKIP skip);
+static ssize_t da9052_tsi_config_pen_detect(struct da9052_ts_priv *priv,
+					u8 flag);
+static ssize_t da9052_tsi_disable_irq(struct da9052_ts_priv *priv,
+					enum TSI_IRQ tsi_irq);
+static ssize_t da9052_tsi_enable_irq(struct da9052_ts_priv *priv,
+					enum TSI_IRQ tsi_irq);
+static ssize_t da9052_tsi_config_manual_mode(struct da9052_ts_priv *priv,
+					u8 coordinate);
+static ssize_t da9052_tsi_config_auto_mode(struct da9052_ts_priv *priv,
+					u8 state);
+static ssize_t da9052_tsi_config_gpio(struct da9052_ts_priv *priv);
+static ssize_t da9052_tsi_config_power_supply(struct da9052_ts_priv *priv,
+					u8 state);
+static struct da9052_tsi_info *get_tsi_drvdata(void);
+static void da9052_tsi_penup_event(struct da9052_ts_priv *priv);
+static s32 da9052_tsi_get_rawdata(struct da9052_tsi_reg *buf, u8 cnt);
+static ssize_t da9052_tsi_reg_proc_thread(void *ptr);
+
+struct da9052_tsi tsi_reg;
+struct da9052_tsi_info gda9052_tsi_info;
+
+static ssize_t write_da9052_reg(struct da9052 *da9052, u8 reg_addr, u8 data)
+{
+	ssize_t ret = 0;
+	struct da9052_ssc_msg ssc_msg;
+
+	ssc_msg.addr =  reg_addr;
+	ssc_msg.data =  data;
+	ret = da9052->write(da9052, &ssc_msg);
+	if (ret)
+		printk(KERN_INFO "da9052_ssc_write failed\n");
+
+	return ret;
+}
+
+static ssize_t read_da9052_reg(struct da9052 *da9052, u8 reg_addr)
+{
+	 ssize_t ret = 0;
+	 struct da9052_ssc_msg ssc_msg;
+
+	ssc_msg.addr =  reg_addr;
+	ssc_msg.data =  0;
+	ret = da9052->read(da9052, &ssc_msg);
+	if (ret) {
+		printk(KERN_INFO "da9052_ssc_read failed\n");
+		return -ret;
+	}
+	return ssc_msg.data;
+}
+
+static struct da9052_tsi_info *get_tsi_drvdata(void)
+{
+	return &gda9052_tsi_info;
+}
+
+static ssize_t da9052_tsi_config_measure_seq(struct da9052_ts_priv *priv,
+						enum TSI_MEASURE_SEQ seq)
+{
+	ssize_t ret = 0;
+	u8 data = 0;
+	struct da9052_tsi_info *ts = get_tsi_drvdata();
+
+	if (seq > 1)
+		return -EINVAL;
+
+	da9052_lock(priv->da9052);
+	ret = read_da9052_reg(priv->da9052, DA9052_TSICONTA_REG);
+	if (ret < 0) {
+		da9052_unlock(priv->da9052);
+		return ret;
+	}
+
+	data = (u8)ret;
+
+	if (seq == XYZP_MODE)
+		data = enable_xyzp_mode(data);
+	else if (seq == XP_MODE)
+		data = enable_xp_mode(data);
+	else {
+		da9052_unlock(priv->da9052);
+		return -EINVAL;
+	}
+
+	ret = write_da9052_reg(priv->da9052, DA9052_TSICONTA_REG, data);
+	if (ret) {
+		da9052_unlock(priv->da9052);
+		return ret;
+	}
+	da9052_unlock(priv->da9052);
+
+	ts->tsi_conf.auto_cont.da9052_tsi_cont_a = data;
+
+	return 0;
+}
+
+static ssize_t da9052_tsi_set_sampling_mode(struct da9052_ts_priv *priv,
+					u8 mode)
+{
+	u8 data = 0;
+	ssize_t ret = 0;
+	struct da9052_tsi_info *ts = get_tsi_drvdata();
+
+	da9052_lock(priv->da9052);
+
+	ret = read_da9052_reg(priv->da9052, DA9052_ADCCONT_REG);
+	if (ret < 0) {
+		da9052_unlock(priv->da9052);
+		return ret;
+	}
+	data = (u8)ret;
+
+	if (mode == ECONOMY_MODE)
+		data = adc_mode_economy_mode(data);
+	else if (mode == FAST_MODE)
+		data = adc_mode_fast_mode(data);
+	else {
+		da9052_unlock(priv->da9052);
+		return -EINVAL;
+	}
+
+	ret = write_da9052_reg(priv->da9052, DA9052_ADCCONT_REG, data);
+	if (ret) {
+		da9052_unlock(priv->da9052);
+		return ret;
+	}
+	da9052_unlock(priv->da9052);
+
+	switch (mode) {
+	case ECONOMY_MODE:
+		priv->tsi_reg_data_poll_interval =
+			TSI_ECO_MODE_REG_DATA_PROCESSING_INTERVAL;
+		priv->tsi_raw_data_poll_interval =
+			TSI_ECO_MODE_RAW_DATA_PROCESSING_INTERVAL;
+		break;
+	case FAST_MODE:
+		priv->tsi_reg_data_poll_interval =
+			TSI_FAST_MODE_REG_DATA_PROCESSING_INTERVAL;
+		priv->tsi_raw_data_poll_interval =
+			TSI_FAST_MODE_RAW_DATA_PROCESSING_INTERVAL;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	ts->tsi_penup_count =
+		(u32)priv->tsi_pdata->pen_up_interval /
+		priv->tsi_reg_data_poll_interval;
+
+	return 0;
+}
+
+static ssize_t da9052_tsi_config_delay(struct da9052_ts_priv *priv,
+					enum TSI_DELAY delay)
+{
+	ssize_t ret = 0;
+	u8 data = 0;
+	struct da9052_tsi_info *ts = get_tsi_drvdata();
+
+	if (delay > priv->tsi_pdata->max_tsi_delay)
+		return -EINVAL;
+
+	da9052_lock(priv->da9052);
+
+	ret = read_da9052_reg(priv->da9052, DA9052_TSICONTA_REG);
+	if (ret < 0) {
+		da9052_unlock(priv->da9052);
+		return ret;
+	}
+
+	data = clear_bits((u8)ret, DA9052_TSICONTA_TSIDELAY);
+
+	data = set_bits(data, (delay << priv->tsi_pdata->tsi_delay_bit_shift));
+
+	ret = write_da9052_reg(priv->da9052, DA9052_TSICONTA_REG, data);
+	if (ret) {
+		da9052_unlock(priv->da9052);
+		return ret;
+	}
+	da9052_unlock(priv->da9052);
+
+	ts->tsi_conf.auto_cont.da9052_tsi_cont_a = data;
+
+	return 0;
+}
+
+ssize_t da9052_tsi_config_skip_slots(struct da9052_ts_priv *priv,
+					enum TSI_SLOT_SKIP skip)
+{
+	ssize_t ret = 0;
+	u8 data = 0;
+	struct da9052_tsi_info *ts = get_tsi_drvdata();
+
+	if (skip > priv->tsi_pdata->max_tsi_skip_slot)
+		return -EINVAL;
+
+	da9052_lock(priv->da9052);
+
+	ret = read_da9052_reg(priv->da9052, DA9052_TSICONTA_REG);
+	if (ret < 0) {
+		da9052_unlock(priv->da9052);
+		return ret;
+	}
+
+	data = clear_bits((u8)ret, DA9052_TSICONTA_TSISKIP);
+	data = set_bits(data, (skip << priv->tsi_pdata->tsi_skip_bit_shift));
+
+	ret = write_da9052_reg(priv->da9052, DA9052_TSICONTA_REG, data);
+	if (ret) {
+		da9052_unlock(priv->da9052);
+		return ret;
+	}
+	da9052_unlock(priv->da9052);
+
+	ts->tsi_conf.auto_cont.da9052_tsi_cont_a = data;
+
+	return 0;
+}
+
+static ssize_t da9052_tsi_config_state(struct da9052_ts_priv *priv,
+					enum TSI_STATE state)
+{
+	s32 ret;
+	struct da9052_tsi_info *ts = get_tsi_drvdata();
+
+	if (ts->tsi_conf.state == state)
+		return 0;
+
+	switch (state) {
+	case TSI_AUTO_MODE:
+		ts->tsi_zero_data_cnt = 0;
+		priv->early_data_flag = TRUE;
+		priv->debounce_over = FALSE;
+		priv->win_reference_valid = FALSE;
+
+		clean_tsi_fifos(priv);
+
+		ret = da9052_tsi_config_auto_mode(priv, DISABLE);
+		if (ret)
+			return ret;
+
+		ret = da9052_tsi_config_manual_mode(priv, DISABLE);
+		if (ret)
+			return ret;
+
+		ret = da9052_tsi_config_power_supply(priv, DISABLE);
+		if (ret)
+			return ret;
+
+		ret = da9052_tsi_enable_irq(priv, TSI_PEN_DWN);
+		if (ret)
+			return ret;
+		ts->tsi_conf.tsi_pendown_irq_mask = RESET;
+
+		ret = da9052_tsi_disable_irq(priv, TSI_DATA_RDY);
+		if (ret)
+			return ret;
+		ts->tsi_conf.tsi_ready_irq_mask	  = SET;
+
+		da9052_tsi_reg_pendwn_event(priv);
+		da9052_tsi_reg_datardy_event(priv);
+
+		ret = da9052_tsi_config_pen_detect(priv, ENABLE);
+		if (ret)
+			return ret;
+		break;
+
+	case TSI_IDLE:
+		ts->pen_dwn_event = RESET;
+
+		ret = da9052_tsi_config_pen_detect(priv, DISABLE);
+		if (ret)
+			return ret;
+
+		ret = da9052_tsi_config_auto_mode(priv, DISABLE);
+		if (ret)
+			return ret;
+
+		ret = da9052_tsi_config_manual_mode(priv, DISABLE);
+		if (ret)
+			return ret;
+
+		ret = da9052_tsi_config_power_supply(priv, DISABLE);
+		if (ret)
+			return ret;
+
+		if (ts->pd_reg_status) {
+			priv->da9052->unregister_event_notifier(priv->da9052,
+								&priv->pd_nb);
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
+static void da9052_tsi_reg_pendwn_event(struct da9052_ts_priv *priv)
+{
+	ssize_t ret = 0;
+	struct da9052_tsi_info  *ts = get_tsi_drvdata();
+
+	if (ts->pd_reg_status)
+		return;
+
+	priv->pd_nb.eve_type = PEN_DOWN_EVE;
+	priv->pd_nb.call_back = &da9052_tsi_pen_down_handler;
+
+	ret = priv->da9052->register_event_notifier(priv->da9052, &priv->pd_nb);
+	if (ret)
+		ts->pd_reg_status = RESET;
+	else
+		ts->pd_reg_status = SET;
+
+	priv->os_data_cnt = 0;
+	priv->raw_data_cnt = 0;
+
+	return;
+}
+
+static void da9052_tsi_reg_datardy_event(struct da9052_ts_priv *priv)
+{
+	ssize_t ret = 0;
+	struct da9052_tsi_info  *ts = get_tsi_drvdata();
+
+	if (ts->datardy_reg_status)
+		return;
+
+	priv->datardy_nb.eve_type = TSI_READY_EVE;
+	priv->datardy_nb.call_back = &da9052_tsi_data_ready_handler;
+
+	ret = priv->da9052->register_event_notifier(priv->da9052,
+						&priv->datardy_nb);
+
+	if (ret)
+		ts->datardy_reg_status = RESET;
+	else
+		ts->datardy_reg_status = SET;
+
+	return;
+}
+
+static ssize_t __init da9052_tsi_create_input_dev(struct input_dev **ip_dev,
+							u8 n)
+{
+	u8 i;
+	s32 ret;
+	struct input_dev *dev = NULL;
+
+	if (!n)
+		return -EINVAL;
+
+	for (i = 0; i < n; i++) {
+		dev = input_allocate_device();
+		if (!dev)
+			return -ENOMEM;
+
+		ip_dev[i] = dev;
+		switch (i) {
+		case TSI_INPUT_DEVICE_OFF:
+			dev->name = DA9052_TSI_INPUT_DEV;
+			dev->phys = "input(tsi)";
+			break;
+		default:
+			break;
+		}
+	}
+	dev->id.vendor = DA9052_VENDOR_ID;
+	dev->id.product = DA9052_PRODUCT_ID;
+	dev->id.bustype = BUS_RS232;
+	dev->id.version = TSI_VERSION;
+	dev->keybit[BIT_WORD(BTN_TOUCH)] = BIT_MASK(BTN_TOUCH);
+	dev->evbit[0] = (BIT_MASK(EV_SYN) |
+			BIT_MASK(EV_KEY) |
+			BIT_MASK(EV_ABS));
+
+	input_set_abs_params(dev, ABS_X, 0, DA9052_DISPLAY_X_MAX, 0, 0);
+	input_set_abs_params(dev, ABS_Y, 0, DA9052_DISPLAY_Y_MAX, 0, 0);
+	input_set_abs_params(dev, ABS_PRESSURE, 0, DA9052_TOUCH_PRESSURE_MAX,
+				0, 0);
+
+	ret = input_register_device(dev);
+	if (ret) {
+		ret = -EIO;
+		goto fail;
+	}
+	return 0;
+
+fail:
+	for (; i-- != 0; )
+		input_free_device(ip_dev[i]);
+	return -EINVAL;
+}
+
+static ssize_t __init da9052_tsi_init_drv(struct da9052_ts_priv *priv)
+{
+	u8 cnt = 0;
+	ssize_t ret = 0;
+	struct da9052_tsi_info  *ts = get_tsi_drvdata();
+
+	if ((DA9052_GPIO_PIN_3 != DA9052_GPIO_CONFIG_TSI) ||
+		(DA9052_GPIO_PIN_4 != DA9052_GPIO_CONFIG_TSI) ||
+		(DA9052_GPIO_PIN_5 != DA9052_GPIO_CONFIG_TSI) ||
+		(DA9052_GPIO_PIN_6 != DA9052_GPIO_CONFIG_TSI) ||
+		(DA9052_GPIO_PIN_7 != DA9052_GPIO_CONFIG_TSI))
+		return -EINVAL;
+
+	ret = da9052_tsi_config_gpio(priv);
+
+	ret = da9052_tsi_config_state(priv, TSI_IDLE);
+	ts->tsi_conf.state = TSI_IDLE;
+
+	da9052_tsi_config_measure_seq(priv, TSI_MODE_VALUE);
+
+	da9052_tsi_config_skip_slots(priv, TSI_SLOT_SKIP_VALUE);
+
+	da9052_tsi_config_delay(priv, TSI_DELAY_VALUE);
+
+	da9052_tsi_set_sampling_mode(priv, DEFAULT_TSI_SAMPLING_MODE);
+
+	ts->tsi_calib = get_calib_config();
+
+	ret = da9052_tsi_create_input_dev(ts->input_devs, NUM_INPUT_DEVS);
+	if (ret)
+		return ret;
+
+
+	da9052_init_tsi_fifos(priv);
+
+	init_completion(&priv->tsi_reg_proc_thread.notifier);
+	priv->tsi_reg_proc_thread.state = ACTIVE;
+	priv->tsi_reg_proc_thread.pid =
+				kernel_thread(da9052_tsi_reg_proc_thread,
+					priv, CLONE_KERNEL | SIGCHLD);
+
+	init_completion(&priv->tsi_raw_proc_thread.notifier);
+	priv->tsi_raw_proc_thread.state = ACTIVE;
+	priv->tsi_raw_proc_thread.pid =
+				kernel_thread(da9052_tsi_raw_proc_thread,
+					priv, CLONE_KERNEL | SIGCHLD);
+
+	ret = da9052_tsi_config_state(priv, DEFAULT_TSI_STATE);
+	if (ret) {
+		for (cnt = 0; cnt < NUM_INPUT_DEVS; cnt++) {
+			if (ts->input_devs[cnt] != NULL)
+				input_free_device(ts->input_devs[cnt]);
+		}
+	}
+
+	return 0;
+}
+
+u32 da9052_tsi_get_input_dev(u8 off)
+{
+	struct da9052_tsi_info   *ts = get_tsi_drvdata();
+
+	if (off > NUM_INPUT_DEVS-1)
+		return -EINVAL;
+
+	return (u32)ts->input_devs[off];
+}
+
+static ssize_t da9052_tsi_config_pen_detect(struct da9052_ts_priv *priv,
+						u8 flag)
+{
+	u8 data;
+	u32 ret;
+	struct da9052_tsi_info  *ts = get_tsi_drvdata();
+
+	da9052_lock(priv->da9052);
+	ret = read_da9052_reg(priv->da9052, DA9052_TSICONTA_REG);
+	if (ret < 0) {
+		da9052_unlock(priv->da9052);
+		return ret;
+	}
+
+	if (flag == ENABLE)
+		data = set_bits((u8)ret, DA9052_TSICONTA_PENDETEN);
+	else if (flag == DISABLE)
+		data = clear_bits((u8)ret, DA9052_TSICONTA_PENDETEN);
+	else {
+		da9052_unlock(priv->da9052);
+		return -EINVAL;
+	}
+
+	ret = write_da9052_reg(priv->da9052, DA9052_TSICONTA_REG, data);
+	if (ret < 0) {
+		da9052_unlock(priv->da9052);
+		return ret;
+	}
+	da9052_unlock(priv->da9052);
+
+	ts->tsi_conf.auto_cont.da9052_tsi_cont_a = data;
+	return 0;
+}
+
+static ssize_t da9052_tsi_disable_irq(struct da9052_ts_priv *priv,
+					enum TSI_IRQ tsi_irq)
+{
+	u8 data = 0;
+	ssize_t ret = 0;
+	struct da9052_tsi_info	*ts = get_tsi_drvdata();
+
+	da9052_lock(priv->da9052);
+	ret = read_da9052_reg(priv->da9052, DA9052_IRQMASKB_REG);
+	if (ret < 0)	{
+		da9052_unlock(priv->da9052);
+		return ret;
+	}
+	data = ret;
+	switch (tsi_irq) {
+	case TSI_PEN_DWN:
+		data = mask_pendwn_irq(data);
+	break;
+	case TSI_DATA_RDY:
+		data = mask_tsi_rdy_irq(data);
+	break;
+	default:
+		da9052_unlock(priv->da9052);
+		return -EINVAL;
+	}
+	ret = write_da9052_reg(priv->da9052, DA9052_IRQMASKB_REG, data);
+	if (ret) {
+		da9052_unlock(priv->da9052);
+		return ret;
+	}
+	da9052_unlock(priv->da9052);
+	switch (tsi_irq) {
+	case TSI_PEN_DWN:
+		ts->tsi_conf.tsi_pendown_irq_mask = SET;
+	break;
+	case TSI_DATA_RDY:
+		ts->tsi_conf.tsi_ready_irq_mask = SET;
+	break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+
+}
+
+static ssize_t da9052_tsi_enable_irq(struct da9052_ts_priv *priv,
+					enum TSI_IRQ tsi_irq)
+{
+	u8 data = 0;
+	ssize_t ret = 0;
+	struct da9052_tsi_info  *ts = get_tsi_drvdata();
+
+	da9052_lock(priv->da9052);
+	ret = read_da9052_reg(priv->da9052, DA9052_IRQMASKB_REG);
+	if (ret < 0) {
+		da9052_unlock(priv->da9052);
+		return ret;
+	}
+
+	data = ret;
+	switch (tsi_irq) {
+	case TSI_PEN_DWN:
+		data = unmask_pendwn_irq(data);
+	break;
+	case TSI_DATA_RDY:
+		data = unmask_tsi_rdy_irq(data);
+	break;
+	default:
+		da9052_unlock(priv->da9052);
+		return -EINVAL;
+	}
+	ret = write_da9052_reg(priv->da9052, DA9052_IRQMASKB_REG, data);
+	if (ret) {
+		da9052_unlock(priv->da9052);
+		return ret;
+	}
+	da9052_unlock(priv->da9052);
+	switch (tsi_irq) {
+	case TSI_PEN_DWN:
+		ts->tsi_conf.tsi_pendown_irq_mask = RESET;
+	break;
+	case TSI_DATA_RDY:
+		ts->tsi_conf.tsi_ready_irq_mask = RESET;
+	break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+ }
+
+static ssize_t da9052_tsi_config_gpio(struct da9052_ts_priv *priv)
+{
+	u8 idx = 0;
+	ssize_t ret = 0;
+	struct da9052_ssc_msg ssc_msg[priv->tsi_pdata->num_gpio_tsi_register];
+
+	ssc_msg[idx++].addr  = DA9052_GPIO0203_REG;
+	ssc_msg[idx++].addr  = DA9052_GPIO0405_REG;
+	ssc_msg[idx++].addr  = DA9052_GPIO0607_REG;
+
+	da9052_lock(priv->da9052);
+	ret = priv->da9052->read_many(priv->da9052, ssc_msg, idx);
+	if (ret) {
+		da9052_unlock(priv->da9052);
+		return ret;
+	}
+
+	idx = 0;
+	ssc_msg[idx].data = clear_bits(ssc_msg[idx].data,
+						DA9052_GPIO0203_GPIO3PIN);
+	idx++;
+	ssc_msg[idx].data = clear_bits(ssc_msg[idx].data,
+		(DA9052_GPIO0405_GPIO4PIN | DA9052_GPIO0405_GPIO5PIN));
+	idx++;
+	ssc_msg[idx].data = clear_bits(ssc_msg[idx].data,
+		(DA9052_GPIO0607_GPIO6PIN | DA9052_GPIO0607_GPIO7PIN));
+	idx++;
+
+	ret = priv->da9052->write_many(priv->da9052, ssc_msg, idx);
+	if (ret) {
+		da9052_unlock(priv->da9052);
+		return ret;
+	}
+	da9052_unlock(priv->da9052);
+
+	return 0;
+}
+
+s32 da9052_pm_configure_ldo(struct da9052_ts_priv *priv,
+				struct da9052_ldo_config ldo_config)
+{
+	struct da9052_ssc_msg msg;
+	u8 reg_num;
+	u8 ldo_volt;
+	u8 ldo_volt_bit = 0;
+	u8 ldo_conf_bit = 0;
+	u8 ldo_en_bit = 0;
+	s8 ldo_pd_bit = -1;
+	s32 ret = 0;
+
+	if (validate_ldo9_mV(ldo_config.ldo_volt))
+		return INVALID_LDO9_VOLT_VALUE;
+
+	ldo_volt = ldo9_mV_to_reg(ldo_config.ldo_volt);
+
+	reg_num = DA9052_LDO9_REG;
+	ldo_volt_bit = DA9052_LDO9_VLDO9;
+	ldo_conf_bit = DA9052_LDO9_LDO9CONF;
+	ldo_en_bit = DA9052_LDO9_LDO9EN;
+
+	da9052_lock(priv->da9052);
+
+	msg.addr = reg_num;
+
+	ret = priv->da9052->read(priv->da9052, &msg);
+	if (ret) {
+		da9052_unlock(priv->da9052);
+		return -EINVAL;
+	}
+	msg.data = ldo_volt |
+		(ldo_config.ldo_conf ? ldo_conf_bit : 0) |
+		(msg.data & ldo_en_bit);
+
+	ret = priv->da9052->write(priv->da9052, &msg);
+	if (ret) {
+		da9052_unlock(priv->da9052);
+		return -EINVAL;
+	}
+
+	if (-1 != ldo_pd_bit) {
+		msg.addr = DA9052_PULLDOWN_REG;
+		ret = priv->da9052->read(priv->da9052, &msg);
+		if (ret) {
+			da9052_unlock(priv->da9052);
+			return -EINVAL;
+		}
+
+		msg.data = (ldo_config.ldo_pd ?
+				set_bits(msg.data, ldo_pd_bit) :
+				clear_bits(msg.data, ldo_pd_bit));
+
+		ret = priv->da9052->write(priv->da9052, &msg);
+		if (ret) {
+			da9052_unlock(priv->da9052);
+			return -EINVAL;
+		}
+
+	}
+	da9052_unlock(priv->da9052);
+
+	return 0;
+}
+
+s32 da9052_pm_set_ldo(struct da9052_ts_priv *priv, u8 ldo_num, u8 flag)
+{
+	struct da9052_ssc_msg msg;
+	u8 reg_num = 0;
+	u8 value = 0;
+	s32 ret = 0;
+
+	reg_num = DA9052_LDO9_REG;
+	value =	DA9052_LDO9_LDO9EN;
+	da9052_lock(priv->da9052);
+
+	msg.addr = reg_num;
+
+	ret = priv->da9052->read(priv->da9052, &msg);
+	if (ret) {
+		da9052_unlock(priv->da9052);
+		return -EINVAL;
+	}
+
+	msg.data = flag ?
+		set_bits(msg.data, value) :
+		clear_bits(msg.data, value);
+
+	ret = priv->da9052->write(priv->da9052, &msg);
+	if (ret) {
+		da9052_unlock(priv->da9052);
+		return -EINVAL;
+	}
+
+	da9052_unlock(priv->da9052);
+
+	return 0;
+}
+
+static ssize_t da9052_tsi_config_power_supply(struct da9052_ts_priv *priv,
+						u8 state)
+{
+	struct da9052_ldo_config ldo_config;
+	struct da9052_tsi_info *ts = get_tsi_drvdata();
+
+	if (state != ENABLE && state != DISABLE)
+		return -EINVAL;
+
+	ldo_config.ldo_volt = priv->tsi_pdata->tsi_supply_voltage;
+	ldo_config.ldo_num =  priv->tsi_pdata->tsi_ref_source;
+	ldo_config.ldo_conf = RESET;
+
+	if (da9052_pm_configure_ldo(priv, ldo_config))
+		return -EINVAL;
+
+	if (da9052_pm_set_ldo(priv, priv->tsi_pdata->tsi_ref_source, state))
+		return -EINVAL;
+
+	if (state == ENABLE)
+		ts->tsi_conf.ldo9_en = SET;
+	else
+		ts->tsi_conf.ldo9_en = RESET;
+
+	return 0;
+}
+
+static ssize_t da9052_tsi_config_auto_mode(struct da9052_ts_priv *priv,
+						u8 state)
+{
+	u8 data;
+	s32 ret = 0;
+	struct da9052_tsi_info *ts = get_tsi_drvdata();
+
+	if (state != ENABLE && state != DISABLE)
+		return -EINVAL;
+
+	da9052_lock(priv->da9052);
+
+	ret = read_da9052_reg(priv->da9052, DA9052_TSICONTA_REG);
+	if (ret < 0) {
+		da9052_unlock(priv->da9052);
+		return ret;
+	}
+
+	data = (u8)ret;
+
+	if (state == ENABLE)
+		data = set_auto_tsi_en(data);
+	else if (state == DISABLE)
+		data = reset_auto_tsi_en(data);
+	else {
+		da9052_unlock(priv->da9052);
+		return -EINVAL;
+	}
+
+	ret = write_da9052_reg(priv->da9052, DA9052_TSICONTA_REG, data);
+	if (ret) {
+		da9052_unlock(priv->da9052);
+		return ret;
+	}
+	da9052_unlock(priv->da9052);
+	ts->tsi_conf.auto_cont.da9052_tsi_cont_a = data;
+	return 0;
+}
+
+static ssize_t da9052_tsi_config_manual_mode(struct da9052_ts_priv *priv,
+						u8 state)
+{
+	u8 data = 0;
+	ssize_t ret = 0;
+	struct da9052_tsi_info *ts = get_tsi_drvdata();
+
+	if (state != ENABLE && state != DISABLE)
+		return -EINVAL;
+
+	da9052_lock(priv->da9052);
+
+	ret = read_da9052_reg(priv->da9052, DA9052_TSICONTB_REG);
+	if (ret < 0) {
+		da9052_unlock(priv->da9052);
+		return ret;
+	}
+
+	data = (u8)ret;
+	if (state == DISABLE)
+		data = disable_tsi_manual_mode(data);
+	else
+		data = enable_tsi_manual_mode(data);
+
+	ret = write_da9052_reg(priv->da9052, DA9052_TSICONTB_REG, data);
+	if (ret) {
+		da9052_unlock(priv->da9052);
+		return ret;
+	}
+
+	if (state == DISABLE)
+		ts->tsi_conf.man_cont.tsi_cont_b.tsi_man = RESET;
+	else
+		ts->tsi_conf.man_cont.tsi_cont_b.tsi_man = SET;
+
+	data = 0;
+	data = set_bits(data, DA9052_ADC_TSI);
+
+	ret = write_da9052_reg(priv->da9052, DA9052_ADCMAN_REG, data);
+	if (ret) {
+		da9052_unlock(priv->da9052);
+		return ret;
+	}
+	da9052_unlock(priv->da9052);
+
+	return 0;
+}
+
+static u32 da9052_tsi_get_reg_data(struct da9052_ts_priv *priv)
+{
+	u32 free_cnt, copy_cnt, cnt;
+
+	if (down_interruptible(&priv->tsi_reg_fifo.lock))
+		return 0;
+
+	copy_cnt = 0;
+
+	if ((priv->tsi_reg_fifo.head - priv->tsi_reg_fifo.tail) > 1) {
+		free_cnt = get_reg_free_space_cnt(priv);
+		if (free_cnt > TSI_POLL_SAMPLE_CNT)
+			free_cnt = TSI_POLL_SAMPLE_CNT;
+
+		cnt = da9052_tsi_get_rawdata(
+			&priv->tsi_reg_fifo.data[priv->tsi_reg_fifo.tail],
+			free_cnt);
+
+		if (cnt > free_cnt)
+			return -EINVAL;
+
+		copy_cnt = cnt;
+
+		while (cnt--)
+			incr_with_wrap_reg_fifo(priv->tsi_reg_fifo.tail);
+
+	} else if ((priv->tsi_reg_fifo.head - priv->tsi_reg_fifo.tail) <= 0) {
+
+		free_cnt = (TSI_REG_DATA_BUF_SIZE - priv->tsi_reg_fifo.tail);
+		if (free_cnt > TSI_POLL_SAMPLE_CNT) {
+			free_cnt = TSI_POLL_SAMPLE_CNT;
+
+			cnt = da9052_tsi_get_rawdata(
+			&priv->tsi_reg_fifo.data[priv->tsi_reg_fifo.tail],
+			free_cnt);
+			if (cnt > free_cnt)
+				return -EINVAL;
+			copy_cnt = cnt;
+
+			while (cnt--)
+				incr_with_wrap_reg_fifo(
+						priv->tsi_reg_fifo.tail);
+		} else {
+			if (free_cnt) {
+				cnt = da9052_tsi_get_rawdata(
+					&priv->
+					tsi_reg_fifo.data[priv->
+					tsi_reg_fifo.tail],
+					free_cnt
+					);
+				if (cnt > free_cnt)
+					return -EINVAL;
+				copy_cnt = cnt;
+				while (cnt--)
+					incr_with_wrap_reg_fifo(
+						priv->tsi_reg_fifo.tail);
+			}
+			free_cnt = priv->tsi_reg_fifo.head;
+			if (free_cnt > TSI_POLL_SAMPLE_CNT - copy_cnt)
+				free_cnt = TSI_POLL_SAMPLE_CNT - copy_cnt;
+			if (free_cnt) {
+				cnt = da9052_tsi_get_rawdata(
+					&priv->tsi_reg_fifo.data[priv->
+					tsi_reg_fifo.tail], free_cnt
+					);
+				if (cnt > free_cnt)
+					return -EINVAL;
+				copy_cnt += cnt;
+
+				while (cnt--)
+					incr_with_wrap_reg_fifo(
+						priv->tsi_reg_fifo.tail);
+			}
+		}
+	} else
+		copy_cnt = 0;
+
+	up(&priv->tsi_reg_fifo.lock);
+
+	return copy_cnt;
+}
+
+
+static ssize_t da9052_tsi_reg_proc_thread(void *ptr)
+{
+	u32 data_cnt;
+	struct da9052_tsi_info *ts;
+	struct da9052_ts_priv *priv = (struct da9052_ts_priv *)ptr;
+
+	set_freezable();
+
+	while (priv->tsi_reg_proc_thread.state == ACTIVE) {
+
+		try_to_freeze();
+
+		set_current_state(TASK_INTERRUPTIBLE);
+		schedule_timeout(msecs_to_jiffies(priv->
+					tsi_reg_data_poll_interval));
+
+		ts = get_tsi_drvdata();
+
+		if (!ts->pen_dwn_event)
+			continue;
+
+		data_cnt = da9052_tsi_get_reg_data(priv);
+
+		da9052_tsi_process_reg_data(priv);
+
+		if (data_cnt)
+			ts->tsi_zero_data_cnt = 0;
+		else {
+			if ((++(ts->tsi_zero_data_cnt)) >
+						     ts->tsi_penup_count) {
+				ts->pen_dwn_event = RESET;
+				da9052_tsi_penup_event(priv);
+			}
+		}
+	}
+
+	complete_and_exit(&priv->tsi_reg_proc_thread.notifier, 0);
+	return 0;
+}
+
+
+static void da9052_tsi_penup_event(struct da9052_ts_priv *priv)
+{
+
+	struct da9052_tsi_info *ts = get_tsi_drvdata();
+	struct input_dev *ip_dev =
+		(struct input_dev *)da9052_tsi_get_input_dev(
+		(u8)TSI_INPUT_DEVICE_OFF);
+
+	if (da9052_tsi_config_auto_mode(priv, DISABLE))
+		goto exit;
+
+	ts->tsi_conf.auto_cont.tsi_cont_a.auto_tsi_en = RESET;
+
+	if (da9052_tsi_config_power_supply(priv, ENABLE))
+		goto exit;
+
+	ts->tsi_conf.ldo9_en = RESET;
+
+	if (da9052_tsi_enable_irq(priv, TSI_PEN_DWN))
+		goto exit;
+
+	ts->tsi_conf.tsi_pendown_irq_mask = RESET;
+
+	tsi_reg.tsi_state =  WAIT_FOR_PEN_DOWN;
+
+	if (da9052_tsi_disable_irq(priv, TSI_DATA_RDY))
+		goto exit;
+
+	ts->tsi_zero_data_cnt = 0;
+	priv->early_data_flag = TRUE;
+	priv->debounce_over = FALSE;
+	priv->win_reference_valid = FALSE;
+
+	printk(KERN_INFO "PEN UP DECLARED\n");
+	input_report_abs(ip_dev, BTN_TOUCH, 0);
+	input_sync(ip_dev);
+	priv->os_data_cnt = 0;
+	priv->raw_data_cnt = 0;
+
+exit:
+	clean_tsi_fifos(priv);
+	return;
+}
+
+void da9052_tsi_pen_down_handler(struct da9052_eh_nb *eh_data, u32 event)
+{
+	ssize_t ret = 0;
+	struct da9052_ts_priv *priv =
+		container_of(eh_data, struct da9052_ts_priv, pd_nb);
+	struct da9052_tsi_info *ts = get_tsi_drvdata();
+	struct input_dev *ip_dev =
+		(struct input_dev *)da9052_tsi_get_input_dev(
+		(u8)TSI_INPUT_DEVICE_OFF);
+
+	if (tsi_reg.tsi_state !=  WAIT_FOR_PEN_DOWN)
+		return;
+
+	tsi_reg.tsi_state = WAIT_FOR_SAMPLING;
+
+	if (ts->tsi_conf.state != TSI_AUTO_MODE)
+		goto fail;
+
+	if (da9052_tsi_config_power_supply(priv, ENABLE))
+		goto fail;
+
+	if (da9052_tsi_disable_irq(priv, TSI_PEN_DWN))
+		goto fail;
+
+	if (da9052_tsi_config_auto_mode(priv, ENABLE))
+		goto fail;
+	ts->tsi_conf.auto_cont.tsi_cont_a.auto_tsi_en = SET;
+
+	if (da9052_tsi_enable_irq(priv, TSI_DATA_RDY))
+		goto fail;
+
+	input_sync(ip_dev);
+
+	ts->tsi_rdy_event = (DA9052_EVENTB_ETSIREADY & (event>>8));
+	ts->pen_dwn_event = (DA9052_EVENTB_EPENDOWN & (event>>8));
+
+	tsi_reg.tsi_state =  SAMPLING_ACTIVE;
+
+	goto success;
+
+fail:
+	if (ts->pd_reg_status) {
+		priv->da9052->unregister_event_notifier(priv->da9052,
+						&priv->pd_nb);
+		ts->pd_reg_status = RESET;
+
+		priv->da9052->register_event_notifier(priv->da9052,
+					&priv->datardy_nb);
+		da9052_tsi_reg_pendwn_event(priv);
+	}
+
+success:
+	ret = 0;
+	printk(KERN_INFO "Exiting PEN DOWN HANDLER\n");
+}
+
+void da9052_tsi_data_ready_handler(struct da9052_eh_nb *eh_data, u32 event)
+{
+	struct da9052_ssc_msg tsi_data[4];
+	s32 ret;
+	struct da9052_ts_priv *priv =
+		container_of(eh_data, struct da9052_ts_priv, datardy_nb);
+
+	if (tsi_reg.tsi_state !=  SAMPLING_ACTIVE)
+		return;
+
+	tsi_data[0].addr  = DA9052_TSIXMSB_REG;
+	tsi_data[1].addr  = DA9052_TSIYMSB_REG;
+	tsi_data[2].addr  = DA9052_TSILSB_REG;
+	tsi_data[3].addr  = DA9052_TSIZMSB_REG;
+
+	tsi_data[0].data  = 0;
+	tsi_data[1].data  = 0;
+	tsi_data[2].data  = 0;
+	tsi_data[3].data  = 0;
+
+	da9052_lock(priv->da9052);
+
+	ret = priv->da9052->read_many(priv->da9052, tsi_data, 4);
+	if (ret) {
+		da9052_unlock(priv->da9052);
+		return;
+	}
+	da9052_unlock(priv->da9052);
+
+	mutex_lock(&tsi_reg.tsi_fifo_lock);
+
+	tsi_reg.tsi_fifo[tsi_reg.tsi_fifo_end].x_msb = tsi_data[0].data;
+	tsi_reg.tsi_fifo[tsi_reg.tsi_fifo_end].y_msb = tsi_data[1].data;
+	tsi_reg.tsi_fifo[tsi_reg.tsi_fifo_end].lsb   = tsi_data[2].data;
+	tsi_reg.tsi_fifo[tsi_reg.tsi_fifo_end].z_msb = tsi_data[3].data;
+	incr_with_wrap(tsi_reg.tsi_fifo_end);
+
+	if (tsi_reg.tsi_fifo_end == tsi_reg.tsi_fifo_start)
+		tsi_reg.tsi_fifo_start++;
+
+	mutex_unlock(&tsi_reg.tsi_fifo_lock);
+
+}
+
+static s32 da9052_tsi_get_rawdata(struct da9052_tsi_reg *buf, u8 cnt)
+{
+	u32 data_cnt = 0;
+	u32 rem_data_cnt = 0;
+
+	mutex_lock(&tsi_reg.tsi_fifo_lock);
+
+	if (tsi_reg.tsi_fifo_start < tsi_reg.tsi_fifo_end) {
+		data_cnt = (tsi_reg.tsi_fifo_end - tsi_reg.tsi_fifo_start);
+
+		if (cnt < data_cnt)
+			data_cnt = cnt;
+
+		memcpy(buf, &tsi_reg.tsi_fifo[tsi_reg.tsi_fifo_start],
+				sizeof(struct da9052_tsi_reg) * data_cnt);
+
+		tsi_reg.tsi_fifo_start += data_cnt;
+
+		if (tsi_reg.tsi_fifo_start == tsi_reg.tsi_fifo_end) {
+			tsi_reg.tsi_fifo_start = 0;
+			tsi_reg.tsi_fifo_end = 0;
+		}
+	} else if (tsi_reg.tsi_fifo_start > tsi_reg.tsi_fifo_end) {
+		data_cnt = ((TSI_FIFO_SIZE - tsi_reg.tsi_fifo_start)
+		+ tsi_reg.tsi_fifo_end);
+
+		if (cnt < data_cnt)
+			data_cnt = cnt;
+
+		if (data_cnt <= (TSI_FIFO_SIZE - tsi_reg.tsi_fifo_start)) {
+			memcpy(buf, &tsi_reg.tsi_fifo[tsi_reg.tsi_fifo_start],
+				sizeof(struct da9052_tsi_reg) * data_cnt);
+
+			tsi_reg.tsi_fifo_start += data_cnt;
+			if (tsi_reg.tsi_fifo_start >= TSI_FIFO_SIZE)
+				tsi_reg.tsi_fifo_start = 0;
+		} else {
+			memcpy(buf, &tsi_reg.tsi_fifo[tsi_reg.tsi_fifo_start],
+				sizeof(struct da9052_tsi_reg)
+				* (TSI_FIFO_SIZE - tsi_reg.tsi_fifo_start));
+
+			rem_data_cnt = (data_cnt -
+				(TSI_FIFO_SIZE - tsi_reg.tsi_fifo_start));
+
+			memcpy(buf, &tsi_reg.tsi_fifo[0],
+				sizeof(struct da9052_tsi_reg) * rem_data_cnt);
+
+			tsi_reg.tsi_fifo_start = rem_data_cnt;
+		}
+
+		if (tsi_reg.tsi_fifo_start == tsi_reg.tsi_fifo_end) {
+				tsi_reg.tsi_fifo_start = 0;
+			tsi_reg.tsi_fifo_end = 0;
+		}
+	} else
+		data_cnt = 0;
+
+	mutex_unlock(&tsi_reg.tsi_fifo_lock);
+
+	return data_cnt;
+}
+
+static s32 __devinit da9052_tsi_probe(struct platform_device *pdev)
+{
+
+	struct da9052_ts_priv *priv;
+	struct da9052_tsi_platform_data *pdata = pdev->dev.platform_data;
+
+	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+	priv->da9052 = dev_get_drvdata(pdev->dev.parent);
+	platform_set_drvdata(pdev, priv);
+
+	priv->tsi_pdata = pdata;
+
+	if (da9052_tsi_init_drv(priv))
+			return -EFAULT;
+
+	mutex_init(&tsi_reg.tsi_fifo_lock);
+	tsi_reg.tsi_state = WAIT_FOR_PEN_DOWN;
+
+	return 0;
+}
+
+static int __devexit da9052_tsi_remove(struct platform_device *pdev)
+{
+	struct da9052_ts_priv *priv = platform_get_drvdata(pdev);
+	struct da9052_tsi_info *ts = get_tsi_drvdata();
+	s32 ret = 0, i = 0;
+
+	ret = da9052_tsi_config_state(priv, TSI_IDLE);
+	if (!ret)
+		return -EINVAL;
+
+	if (ts->pd_reg_status) {
+		priv->da9052->unregister_event_notifier(priv->da9052,
+							&priv->pd_nb);
+		ts->pd_reg_status = RESET;
+	}
+
+	if (ts->datardy_reg_status) {
+		priv->da9052->unregister_event_notifier(priv->da9052,
+							&priv->datardy_nb);
+		ts->datardy_reg_status = RESET;
+	}
+
+	mutex_destroy(&tsi_reg.tsi_fifo_lock);
+
+	priv->tsi_reg_proc_thread.state = INACTIVE;
+	wait_for_completion(&priv->tsi_reg_proc_thread.notifier);
+
+	priv->tsi_raw_proc_thread.state = INACTIVE;
+	wait_for_completion(&priv->tsi_raw_proc_thread.notifier);
+
+	for (i = 0; i < NUM_INPUT_DEVS; i++)
+		input_unregister_device(ts->input_devs[i]);
+
+	platform_set_drvdata(pdev, NULL);
+
+	return 0;
+}
+
+static struct platform_driver da9052_tsi_driver = {
+	.probe		= da9052_tsi_probe,
+	.remove		= __devexit_p(da9052_tsi_remove),
+	.driver		= {
+				.name	= DA9052_TSI_DEVICE_NAME,
+				.owner	= THIS_MODULE,
+			},
+};
+
+static int __init da9052_tsi_init(void)
+{
+	return platform_driver_register(&da9052_tsi_driver);
+}
+module_init(da9052_tsi_init);
+
+static void __exit da9052_tsi_exit(void)
+{
+	platform_driver_unregister(&da9052_tsi_driver);
+	return;
+
+}
+module_exit(da9052_tsi_exit);
+
+MODULE_DESCRIPTION("Touchscreen driver for Dialog Semiconductor DA9052");
+MODULE_AUTHOR("Dialog Semiconductor Ltd <dchen@diasemi.com>");
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:" DRIVER_NAME);
diff -Naur A-source/drivers/input/touchscreen/da9052_tsi_calibrate.c
B-source/drivers/input/touchscreen/da9052_tsi_calibrate.c
--- A-source/drivers/input/touchscreen/da9052_tsi_calibrate.c	1970-01-01
05:00:00.000000000 +0500
+++ B-source/drivers/input/touchscreen/da9052_tsi_calibrate.c	2010-12-08
15:46:30.000000000 +0500
@@ -0,0 +1,102 @@
+/*
+ * da9052_tsi_calibrate.c  --  TSI Calibration driver for Dialog DA9052
+ *
+ * Copyright(c) 2009 Dialog Semiconductor Ltd.
+ *
+ * Author: Dialog Semiconductor Ltd <dchen@diasemi.com>
+ *
+ *  This program is free software; you can redistribute  it and/or modify it
+ *  under  the terms of  the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the  License, or (at your
+ *  option) any later version.
+ *
+ */
+
+#include <linux/mfd/da9052/tsi.h>
+
+static struct Calib_xform_matrix_t xform = {
+		.An = DA9052_TSI_CALIB_AN,
+		.Bn = DA9052_TSI_CALIB_BN,
+		.Cn = DA9052_TSI_CALIB_CN,
+		.Dn = DA9052_TSI_CALIB_DN,
+		.En = DA9052_TSI_CALIB_EN,
+		.Fn = DA9052_TSI_CALIB_FN,
+		.Divider = DA9052_TSI_CALIB_DIVIDER
+};
+
+static struct calib_cfg_t calib = {
+	.calibrate_flag = TSI_USE_CALIBRATION,
+};
+
+struct calib_cfg_t *get_calib_config(void)
+{
+	return &calib;
+}
+
+ssize_t da9052_tsi_set_calib_matrix(struct da9052_tsi_data *displayPtr,
+				struct da9052_tsi_data *screenPtr)
+{
+
+	int  retValue = SUCCESS ;
+
+	xform.Divider = ((screenPtr[0].x - screenPtr[1].x)
+			* (screenPtr[1].y - screenPtr[2].y))
+			- ((screenPtr[1].x - screenPtr[2].x)
+			* (screenPtr[0].y - screenPtr[1].y));
+
+	if (xform.Divider == 0)
+		retValue = -FAILURE;
+	else	{
+		xform.An = ((displayPtr[0].x - displayPtr[1].x)
+			* (screenPtr[1].y - screenPtr[2].y))
+			- ((displayPtr[1].x - displayPtr[2].x)
+			* (screenPtr[0].y - screenPtr[1].y));
+
+		xform.Bn = ((displayPtr[1].x - displayPtr[2].x)
+			* (screenPtr[0].x - screenPtr[1].x))
+			- ((screenPtr[1].x - screenPtr[2].x)
+			* (displayPtr[0].x - displayPtr[1].x));
+
+		 xform.Cn = (displayPtr[0].x * xform.Divider)
+			- (screenPtr[0].x * xform.An)
+			- (screenPtr[0].y * xform.Bn);
+
+		xform.Dn = ((displayPtr[0].y - displayPtr[1].y)
+			* (screenPtr[1].y - screenPtr[2].y))
+			- ((displayPtr[1].y - displayPtr[2].y)
+			* (screenPtr[0].y - screenPtr[1].y));
+
+		xform.En = ((displayPtr[1].y - displayPtr[2].y)
+			* (screenPtr[0].x - screenPtr[1].x))
+			- ((screenPtr[1].x - screenPtr[2].x)
+			* (displayPtr[0].y - displayPtr[1].y));
+
+		xform.Fn = (displayPtr[0].y * xform.Divider)
+			- (screenPtr[0].x * xform.Dn)
+			- (screenPtr[0].y * xform.En);
+	}
+
+	return retValue;
+}
+
+ssize_t da9052_tsi_get_calib_display_point(struct da9052_tsi_data *displayPtr)
+{
+	int  retValue = TRUE;
+	struct da9052_tsi_data screen_coord;
+
+	screen_coord = *displayPtr;
+	if (xform.Divider != 0)	{
+		displayPtr->x = ((xform.An * screen_coord.x) +
+			(xform.Bn * screen_coord.y) +
+				xform.Cn
+			) / xform.Divider;
+
+	displayPtr->y = ((xform.Dn * screen_coord.x) +
+			(xform.En * screen_coord.y) +
+				xform.Fn
+			) / xform.Divider;
+	} else
+		retValue = FALSE;
+
+	return retValue;
+}
diff -Naur A-source/drivers/input/touchscreen/da9052_tsi_filter.c
B-source/drivers/input/touchscreen/da9052_tsi_filter.c
--- A-source/drivers/input/touchscreen/da9052_tsi_filter.c	1970-01-01
05:00:00.000000000 +0500
+++ B-source/drivers/input/touchscreen/da9052_tsi_filter.c	2010-12-08
15:46:30.000000000 +0500
@@ -0,0 +1,446 @@
+/*
+ * da9052_tsi_filter.c  --  TSI filter driver for Dialog DA9052
+ *
+ * Copyright(c) 2009 Dialog Semiconductor Ltd.
+ *
+ * Author: Dialog Semiconductor Ltd <dchen@diasemi.com>
+ *
+ *  This program is free software; you can redistribute  it and/or modify it
+ *  under  the terms of  the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the  License, or (at your
+ *  option) any later version.
+ *
+ */
+
+#include <linux/input.h>
+#include <linux/freezer.h>
+#include <linux/mfd/da9052/tsi.h>
+
+#define get_abs(x)	(x < 0 ? ((-1) * x) : (x))
+
+#define WITHIN_WINDOW(x, y)	((get_abs(x) <= TSI_X_WINDOW_SIZE) && \
+				(get_abs(y) <= TSI_Y_WINDOW_SIZE))
+
+#define FIRST_SAMPLE					0
+
+#define incr_with_wrap_raw_fifo(x)			\
+		if (++x >= TSI_RAW_DATA_BUF_SIZE)	\
+			x = 0
+
+#define decr_with_wrap_raw_fifo(x)			\
+		if (--x < 0)				\
+			x = (TSI_RAW_DATA_BUF_SIZE-1)
+
+static u32 get_raw_data_cnt(struct da9052_ts_priv *priv);
+static void da9052_tsi_convert_reg_to_coord(struct da9052_ts_priv *priv,
+					struct da9052_tsi_data *raw_data);
+static inline void clean_tsi_reg_fifo(struct da9052_ts_priv *priv);
+static inline void clean_tsi_raw_fifo(struct da9052_ts_priv *priv);
+
+#if (ENABLE_AVERAGE_FILTER)
+static void da9052_tsi_avrg_filter(struct da9052_ts_priv *priv,
+					struct da9052_tsi_data *tsi_avg_data);
+
+#endif
+#if (ENABLE_TSI_DEBOUNCE)
+static s32 da9052_tsi_calc_debounce_data(struct da9052_ts_priv *priv,
+					struct da9052_tsi_data *raw_data);
+
+#endif
+# if (ENABLE_WINDOW_FILTER)
+static s32 diff_within_window(struct da9052_tsi_data *prev_raw_data,
+			      struct da9052_tsi_data *cur_raw_data);
+#endif
+static s32 da9052_tsi_window_filter(struct da9052_ts_priv *ts,
+					struct da9052_tsi_data *raw_data);
+
+void clean_tsi_fifos(struct da9052_ts_priv *priv)
+{
+	clean_tsi_raw_fifo(priv);
+	clean_tsi_reg_fifo(priv);
+}
+
+void __init da9052_init_tsi_fifos(struct da9052_ts_priv *priv)
+{
+	init_MUTEX(&priv->tsi_raw_fifo.lock);
+	init_MUTEX(&priv->tsi_reg_fifo.lock);
+
+	clean_tsi_raw_fifo(priv);
+	clean_tsi_reg_fifo(priv);
+}
+
+u32 get_reg_data_cnt(struct da9052_ts_priv *priv)
+{
+	u8 reg_data_cnt;
+
+	if (priv->tsi_reg_fifo.head <= priv->tsi_reg_fifo.tail) {
+		reg_data_cnt = (priv->tsi_reg_fifo.tail -
+				priv->tsi_reg_fifo.head);
+	} else {
+		reg_data_cnt = (priv->tsi_reg_fifo.tail +
+				(TSI_REG_DATA_BUF_SIZE -
+				priv->tsi_reg_fifo.head));
+	}
+
+	return reg_data_cnt;
+}
+
+u32 get_reg_free_space_cnt(struct da9052_ts_priv *priv)
+{
+	u32 free_cnt;
+
+	if (priv->tsi_reg_fifo.head <= priv->tsi_reg_fifo.tail) {
+		free_cnt = ((TSI_REG_DATA_BUF_SIZE - 1) -
+			(priv->tsi_reg_fifo.tail - priv->tsi_reg_fifo.head));
+	} else
+		free_cnt = ((priv->tsi_reg_fifo.head - priv->tsi_reg_fifo.tail)
+				- 1);
+
+	return free_cnt;
+}
+
+void da9052_tsi_process_reg_data(struct da9052_ts_priv *priv)
+{
+	s32 ret;
+	struct da9052_tsi_data tmp_raw_data;
+	u32 reg_data_cnt;
+
+	if (down_interruptible(&priv->tsi_reg_fifo.lock))
+		return;
+
+	reg_data_cnt = get_reg_data_cnt(priv);
+
+	while (reg_data_cnt-- > 0) {
+
+		ret = 0;
+
+		if (get_raw_data_cnt(priv) >= (TSI_RAW_DATA_BUF_SIZE - 1))
+			break;
+
+		da9052_tsi_convert_reg_to_coord(priv, &tmp_raw_data);
+
+		if ((tmp_raw_data.x < TS_X_MIN) ||
+			(tmp_raw_data.x > TS_X_MAX) ||
+			(tmp_raw_data.y < TS_Y_MIN) ||
+			(tmp_raw_data.y > TS_Y_MAX)) {
+			printk(KERN_INFO "sample beyond touchscreen panel\
+					dimensions\n");
+			continue;
+		}
+
+#if (ENABLE_TSI_DEBOUNCE)
+		if (debounce_over == FALSE) {
+			ret =
+			da9052_tsi_calc_debounce_data(priv, &tmp_raw_data);
+			if (ret != SUCCESS)
+				continue;
+		}
+#endif
+
+# if (ENABLE_WINDOW_FILTER)
+		ret = da9052_tsi_window_filter(priv, &tmp_raw_data);
+		if (ret != SUCCESS)
+			continue;
+#endif
+		priv->early_data_flag = FALSE;
+
+		if (down_interruptible(&priv->tsi_raw_fifo.lock)) {
+			up(&priv->tsi_reg_fifo.lock);
+			return;
+		}
+
+		priv->tsi_raw_fifo.data[priv->tsi_raw_fifo.tail] = tmp_raw_data;
+		incr_with_wrap_raw_fifo(priv->tsi_raw_fifo.tail);
+
+		up(&priv->tsi_raw_fifo.lock);
+	}
+
+
+	up(&priv->tsi_reg_fifo.lock);
+
+	return;
+}
+
+static u32 get_raw_data_cnt(struct da9052_ts_priv *priv)
+{
+	u32 raw_data_cnt;
+
+	if (priv->tsi_raw_fifo.head <= priv->tsi_raw_fifo.tail)
+		raw_data_cnt =
+			(priv->tsi_raw_fifo.tail - priv->tsi_raw_fifo.head);
+	else
+		raw_data_cnt =
+			(priv->tsi_raw_fifo.tail + (TSI_RAW_DATA_BUF_SIZE -
+			priv->tsi_raw_fifo.head));
+
+	return raw_data_cnt;
+}
+
+static void da9052_tsi_convert_reg_to_coord(struct da9052_ts_priv *priv,
+					struct da9052_tsi_data *raw_data)
+{
+
+	struct da9052_tsi_reg *src;
+	struct da9052_tsi_data *dst = raw_data;
+
+	src = &priv->tsi_reg_fifo.data[priv->tsi_reg_fifo.head];
+
+	dst->x = (src->x_msb << X_MSB_SHIFT);
+	dst->x |= (src->lsb & X_LSB_MASK) >> X_LSB_SHIFT;
+
+	dst->y = (src->y_msb << Y_MSB_SHIFT);
+	dst->y |= (src->lsb & Y_LSB_MASK) >> Y_LSB_SHIFT;
+
+	dst->z = (src->z_msb << Z_MSB_SHIFT);
+	dst->z |= (src->lsb & Z_LSB_MASK) >> Z_LSB_SHIFT;
+
+	priv->raw_data_cnt++;
+	incr_with_wrap_reg_fifo(priv->tsi_reg_fifo.head);
+}
+
+#if (ENABLE_AVERAGE_FILTER)
+static void da9052_tsi_avrg_filter(struct da9052_ts_priv *priv,
+					struct da9052_tsi_data *tsi_avg_data)
+{
+	u8 cnt;
+
+	if (down_interruptible(&priv->tsi_raw_fifo.lock))
+		return;
+
+	(*tsi_avg_data) = priv->tsi_raw_fifo.data[priv->tsi_raw_fifo.head];
+	incr_with_wrap_raw_fifo(priv->tsi_raw_fifo.head);
+
+	for (cnt = 2; cnt <= TSI_AVERAGE_FILTER_SIZE; cnt++) {
+
+		tsi_avg_data->x +=
+			priv->tsi_raw_fifo.data[priv->tsi_raw_fifo.head].x;
+		tsi_avg_data->y +=
+			priv->tsi_raw_fifo.data[priv->tsi_raw_fifo.head].y;
+		tsi_avg_data->z +=
+			priv->tsi_raw_fifo.data[priv->tsi_raw_fifo.head].z;
+
+		incr_with_wrap_raw_fifo(priv->tsi_raw_fifo.head);
+	}
+
+	up(&priv->tsi_raw_fifo.lock);
+
+	tsi_avg_data->x /= TSI_AVERAGE_FILTER_SIZE;
+	tsi_avg_data->y /= TSI_AVERAGE_FILTER_SIZE;
+	tsi_avg_data->z /= TSI_AVERAGE_FILTER_SIZE;
+
+	return;
+}
+#endif
+
+s32 da9052_tsi_raw_proc_thread(void *ptr)
+{
+	struct da9052_tsi_data coord;
+	u8 calib_ok, range_ok;
+	struct calib_cfg_t *tsi_calib = get_calib_config();
+	struct input_dev *ip_dev = (struct input_dev *)
+				da9052_tsi_get_input_dev(
+						(u8)TSI_INPUT_DEVICE_OFF);
+	struct da9052_ts_priv *priv = (struct da9052_ts_priv *)ptr;
+
+	set_freezable();
+
+	while (priv->tsi_raw_proc_thread.state == ACTIVE) {
+
+		try_to_freeze();
+
+		set_current_state(TASK_INTERRUPTIBLE);
+		schedule_timeout(
+			msecs_to_jiffies(priv->tsi_raw_data_poll_interval));
+
+		if (priv->early_data_flag || (get_raw_data_cnt(priv) == 0))
+			continue;
+
+		calib_ok = TRUE;
+		range_ok = TRUE;
+
+#if (ENABLE_AVERAGE_FILTER)
+
+		if (get_raw_data_cnt(priv) < TSI_AVERAGE_FILTER_SIZE)
+			continue;
+
+		da9052_tsi_avrg_filter(priv, &coord);
+
+#else
+
+		if (down_interruptible(&priv->tsi_raw_fifo.lock))
+			continue;
+
+		coord = priv->tsi_raw_fifo.data[priv->tsi_raw_fifo.head];
+		incr_with_wrap_raw_fifo(priv->tsi_raw_fifo.head);
+
+		up(&priv->tsi_raw_fifo.lock);
+
+#endif
+
+		if (tsi_calib->calibrate_flag) {
+			calib_ok = da9052_tsi_get_calib_display_point(&coord);
+
+			if ((coord.x < DISPLAY_X_MIN) ||
+				(coord.x > DISPLAY_X_MAX) ||
+				(coord.y < DISPLAY_Y_MIN) ||
+						(coord.y > DISPLAY_Y_MAX))
+				range_ok = FALSE;
+		}
+
+		if (calib_ok && range_ok) {
+			input_report_abs(ip_dev, BTN_TOUCH, 1);
+			input_report_abs(ip_dev, ABS_X, coord.x);
+			input_report_abs(ip_dev, ABS_Y, coord.y);
+			input_sync(ip_dev);
+
+			priv->os_data_cnt++;
+		} else {
+			if (!calib_ok)
+				printk(KERN_INFO "%s: calibration Failed ",
+					__func__);
+			if (!range_ok)
+				printk(KERN_INFO "sample beyond display\
+					panel dimension \n");
+		}
+	}
+	priv->tsi_raw_proc_thread.thread_task = NULL;
+	complete_and_exit(&priv->tsi_raw_proc_thread.notifier, 0);
+	return 0;
+
+}
+
+#if (ENABLE_TSI_DEBOUNCE)
+static s32 da9052_tsi_calc_debounce_data(struct da9052_tsi_data *raw_data)
+{
+#if (TSI_DEBOUNCE_DATA_CNT)
+	u8 cnt;
+	struct da9052_tsi_data	temp = {.x = 0, .y = 0, .z = 0};
+
+	priv->tsi_raw_fifo.data[priv->tsi_raw_fifo.tail] = (*raw_data);
+	incr_with_wrap_raw_fifo(priv->tsi_raw_fifo.tail);
+
+	if (get_raw_data_cnt(priv) <= TSI_DEBOUNCE_DATA_CNT)
+		return -FAILURE;
+
+	for (cnt = 1; cnt <= TSI_DEBOUNCE_DATA_CNT; cnt++) {
+		temp.x += priv->tsi_raw_fifo.data[priv->tsi_raw_fifo.head].x;
+		temp.y += priv->tsi_raw_fifo.data[priv->tsi_raw_fifo.head].y;
+		temp.z += priv->tsi_raw_fifo.data[priv->tsi_raw_fifo.head].z;
+
+		incr_with_wrap_raw_fifo(priv->tsi_raw_fifo.head);
+	}
+
+	temp.x /= TSI_DEBOUNCE_DATA_CNT;
+	temp.y /= TSI_DEBOUNCE_DATA_CNT;
+	temp.z /= TSI_DEBOUNCE_DATA_CNT;
+
+	priv->tsi_raw_fifo.tail = priv->tsi_raw_fifo.head;
+	priv->tsi_raw_fifo.data[priv->tsi_raw_fifo.tail] = temp;
+	incr_with_wrap_raw_fifo(priv->tsi_raw_fifo.tail);
+
+#if DA9052_TSI_PRINT_DEBOUNCED_DATA
+	printk("D: X: %d Y: %d Z: %d\n",
+	       (u16)temp.x, (u16)temp.y, (u16)temp.z);
+#endif
+
+#endif
+	priv->debounce_over = TRUE;
+
+	return 0;
+}
+#endif
+
+# if (ENABLE_WINDOW_FILTER)
+static s32 diff_within_window(struct da9052_tsi_data *prev_raw_data,
+				struct da9052_tsi_data *cur_raw_data)
+{
+	s32 ret = -EINVAL;
+	s32 x, y;
+	x = ((cur_raw_data->x) - (prev_raw_data->x));
+	y = ((cur_raw_data->y) - (prev_raw_data->y));
+
+	if (WITHIN_WINDOW(x, y))
+		ret = 0;
+
+	return ret;
+}
+
+static s32 da9052_tsi_window_filter(struct da9052_ts_priv *priv,
+					struct da9052_tsi_data *raw_data)
+{
+	u8 ref_found;
+	u32 cur, next;
+	s32 ret = -EINVAL;
+	static struct da9052_tsi_data prev_raw_data;
+
+	if (priv->win_reference_valid == TRUE) {
+		ret = diff_within_window(&prev_raw_data, raw_data);
+		if (!ret)
+			prev_raw_data = (*raw_data);
+	} else {
+		priv->tsi_raw_fifo.data[priv->tsi_raw_fifo.tail] = (*raw_data);
+		incr_with_wrap_raw_fifo(priv->tsi_raw_fifo.tail);
+
+		if (get_raw_data_cnt(priv) == SAMPLE_CNT_FOR_WIN_REF) {
+
+			ref_found = FALSE;
+
+			next = cur = priv->tsi_raw_fifo.head;
+			incr_with_wrap_raw_fifo(next);
+
+			while (next <= priv->tsi_raw_fifo.tail) {
+				ret = diff_within_window(
+						&priv->tsi_raw_fifo.data[cur],
+						&priv->tsi_raw_fifo.data[next]
+						);
+				if (ret == SUCCESS) {
+					ref_found = TRUE;
+					break;
+				}
+				incr_with_wrap_raw_fifo(cur);
+				incr_with_wrap_raw_fifo(next);
+
+			}
+
+			if (ref_found == FALSE)
+				priv->tsi_raw_fifo.tail =
+					priv->tsi_raw_fifo.head;
+			else {
+				prev_raw_data = priv->tsi_raw_fifo.data[cur];
+
+				prev_raw_data.x +=
+					priv->tsi_raw_fifo.data[next].x;
+				prev_raw_data.y +=
+					priv->tsi_raw_fifo.data[next].y;
+				prev_raw_data.z +=
+					priv->tsi_raw_fifo.data[next].z;
+
+				prev_raw_data.x = prev_raw_data.x / 2;
+				prev_raw_data.y = prev_raw_data.y / 2;
+				prev_raw_data.z = prev_raw_data.z / 2;
+
+				(*raw_data) = prev_raw_data;
+
+				priv->tsi_raw_fifo.tail =
+						priv->tsi_raw_fifo.head;
+
+				priv->win_reference_valid = TRUE;
+				ret = SUCCESS;
+			}
+		}
+	}
+	return ret;
+}
+#endif
+static inline void clean_tsi_reg_fifo(struct da9052_ts_priv *priv)
+{
+	priv->tsi_reg_fifo.head = FIRST_SAMPLE;
+	priv->tsi_reg_fifo.tail = FIRST_SAMPLE;
+}
+
+static inline void clean_tsi_raw_fifo(struct da9052_ts_priv *priv)
+{
+	priv->tsi_raw_fifo.head = FIRST_SAMPLE;
+	priv->tsi_raw_fifo.tail = FIRST_SAMPLE;
+}
+
diff -Naur A-source/drivers/input/touchscreen/Kconfig
B-source/drivers/input/touchscreen/Kconfig
--- A-source/drivers/input/touchscreen/Kconfig	2010-05-17
02:17:36.000000000 +0500
+++ B-source/drivers/input/touchscreen/Kconfig	2010-12-08
15:46:30.000000000 +0500
@@ -123,6 +123,13 @@
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
diff -Naur A-source/drivers/input/touchscreen/Makefile
B-source/drivers/input/touchscreen/Makefile
--- A-source/drivers/input/touchscreen/Makefile	2010-05-17
02:17:36.000000000 +0500
+++ B-source/drivers/input/touchscreen/Makefile	2010-12-08
15:46:30.000000000 +0500
@@ -13,6 +13,9 @@
 obj-$(CONFIG_TOUCHSCREEN_ATMEL_TSADCC)	+= atmel_tsadcc.o
 obj-$(CONFIG_TOUCHSCREEN_BITSY)		+= h3600_ts_input.o
 obj-$(CONFIG_TOUCHSCREEN_CORGI)		+= corgi_ts.o
+da9052-tsi-objs				:= da9052_tsi.o\
+				da9052_tsi_filter.o da9052_tsi_calibrate.o
+obj-$(CONFIG_TOUCHSCREEN_DA9052)	+= da9052-tsi.o
 obj-$(CONFIG_TOUCHSCREEN_DYNAPRO)	+= dynapro.o
 obj-$(CONFIG_TOUCHSCREEN_GUNZE)		+= gunze.o
 obj-$(CONFIG_TOUCHSCREEN_EETI)		+= eeti_ts.o
diff -Naur A-source/include/linux/mfd/da9052/tsi_calibrate.h
B-source/include/linux/mfd/da9052/tsi_calibrate.h
--- A-source/include/linux/mfd/da9052/tsi_calibrate.h	1970-01-01
05:00:00.000000000 +0500
+++ B-source/include/linux/mfd/da9052/tsi_calibrate.h	2010-12-08
15:46:30.000000000 +0500
@@ -0,0 +1,47 @@
+/*
+ * da9052 TSI calibration module declarations.
+  *
+ * Copyright(c) 2009 Dialog Semiconductor Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ *
+ */
+
+#ifndef __LINUX_MFD_DA9052_TSI_CALIBRATE_H
+#define __LINUX_MFD_DA9052_TSI_CALIBRATE_H
+
+#include <linux/mfd/da9052/tsi_filter.h>
+
+struct Calib_xform_matrix_t {
+	s32	An;
+	s32	Bn;
+	s32	Cn;
+	s32	Dn;
+	s32	En;
+	s32	Fn;
+	s32	Divider;
+} ;
+
+
+struct calib_cfg_t {
+	u8 calibrate_flag;
+} ;
+
+ssize_t da9052_tsi_set_calib_matrix(struct da9052_tsi_data *displayPtr,
+				   struct da9052_tsi_data *screenPtr);
+u8 configure_tsi_calib(struct calib_cfg_t *tsi_calib);
+struct calib_cfg_t *get_calib_config(void);
+#endif /* __LINUX_MFD_DA9052_TSI_CALIBRATE_H */
+
diff -Naur A-source/include/linux/mfd/da9052/tsi_cfg.h
B-source/include/linux/mfd/da9052/tsi_cfg.h
--- A-source/include/linux/mfd/da9052/tsi_cfg.h	1970-01-01
05:00:00.000000000 +0500
+++ B-source/include/linux/mfd/da9052/tsi_cfg.h	2010-12-08
15:46:30.000000000 +0500
@@ -0,0 +1,121 @@
+/*
+ * da9052 TSI configuration module declarations.
+  *
+ * Copyright(c) 2009 Dialog Semiconductor Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ *
+ */
+
+#ifndef __LINUX_MFD_DA9052_TSI_CFG_H
+#define __LINUX_MFD_DA9052_TSI_CFG_H
+
+#define		DA9052_TSI_DEBUG	0
+
+#define AUTO_MODE			0
+#define IDLE				1
+#define DEFAULT_TSI_STATE		AUTO_MODE
+
+#define TSI_SLOT_SKIP_VALUE		0
+
+#define TSI_DELAY_VALUE			3
+
+#define TSI_MODE_VALUE			0
+
+#define ENABLE_AVERAGE_FILTER		1
+
+#define DEFAULT_AVERAGE_FILTER_SIZE	3
+
+#define ENABLE_WINDOW_FILTER		1
+
+#define TSI_X_WINDOW_SIZE		50
+#define TSI_Y_WINDOW_SIZE		50
+
+#define SAMPLE_CNT_FOR_WIN_REF		3
+
+#define TSI_ECONOMY_MODE		0
+#define TSI_FAST_MODE			1
+#define DEFAULT_TSI_SAMPLING_MODE	TSI_FAST_MODE
+
+#define TSI_USE_CALIBRATION		1
+
+#define DA9052_TSI_CALIB_AN		1
+#define DA9052_TSI_CALIB_BN		0
+#define DA9052_TSI_CALIB_CN		0
+#define DA9052_TSI_CALIB_DN		0
+#define DA9052_TSI_CALIB_EN		1
+#define DA9052_TSI_CALIB_FN		0
+#define DA9052_TSI_CALIB_DIVIDER	1
+
+#define TS_X_MIN	(0)
+#define TS_X_MAX	(1023)
+#define TS_Y_MIN	(0)
+#define TS_Y_MAX	(1023)
+
+#define DISPLAY_X_MIN	(0)
+#define DISPLAY_X_MAX	(1023)
+#define DISPLAY_Y_MIN	(0)
+#define DISPLAY_Y_MAX	(1023)
+
+#define ENABLE_TSI_DEBOUNCE		0
+
+#define TSI_DEBOUNCE_DATA_CNT		3
+
+#if ENABLE_AVERAGE_FILTER
+#define TSI_AVERAGE_FILTER_SIZE		DEFAULT_AVERAGE_FILTER_SIZE
+#else
+#define TSI_AVERAGE_FILTER_SIZE			1
+#endif
+
+#define TSI_FAST_MODE_SAMPLE_CNT		1000
+#define TSI_ECO_MODE_SAMPLE_CNT			100
+
+#define TSI_POLL_SAMPLE_CNT			10
+
+#define TSI_FAST_MODE_REG_DATA_PROCESSING_INTERVAL	\
+	((1000 / TSI_FAST_MODE_SAMPLE_CNT) * TSI_POLL_SAMPLE_CNT)
+#define TSI_ECO_MODE_REG_DATA_PROCESSING_INTERVAL	\
+	((1000 / TSI_ECO_MODE_SAMPLE_CNT) * TSI_POLL_SAMPLE_CNT)
+
+#if DEFAULT_TSI_SAMPLING_MODE
+#define DEFAULT_REG_DATA_PROCESSING_INTERVAL \
+	TSI_FAST_MODE_REG_DATA_PROCESSING_INTERVAL
+#else
+#define DEFAULT_REG_DATA_PROCESSING_INTERVAL \
+	TSI_ECO_MODE_REG_DATA_PROCESSING_INTERVAL
+#endif
+
+#define TSI_REG_DATA_BUF_SIZE	(2 * TSI_POLL_SAMPLE_CNT)
+
+#define TSI_FAST_MODE_RAW_DATA_PROCESSING_INTERVAL	\
+	((1000 / TSI_FAST_MODE_SAMPLE_CNT) * (TSI_AVERAGE_FILTER_SIZE))
+#define TSI_ECO_MODE_RAW_DATA_PROCESSING_INTERVAL	\
+	((1000 / TSI_ECO_MODE_SAMPLE_CNT) * (TSI_AVERAGE_FILTER_SIZE))
+
+
+#if DEFAULT_TSI_SAMPLING_MODE
+#define DEFAULT_RAW_DATA_PROCESSING_INTERVAL \
+	TSI_FAST_MODE_RAW_DATA_PROCESSING_INTERVAL
+#else
+#define DEFAULT_RAW_DATA_PROCESSING_INTERVAL \
+	TSI_ECO_MODE_RAW_DATA_PROCESSING_INTERVAL
+#endif
+
+
+#define TSI_RAW_DATA_BUF_SIZE  \
+	(TSI_REG_DATA_BUF_SIZE * \
+	((TSI_AVERAGE_FILTER_SIZE / TSI_POLL_SAMPLE_CNT) + 1))
+
+#endif /* __LINUX_MFD_DA9052_TSI_CFG_H */
diff -Naur A-source/include/linux/mfd/da9052/tsi_filter.h
B-source/include/linux/mfd/da9052/tsi_filter.h
--- A-source/include/linux/mfd/da9052/tsi_filter.h	1970-01-01
05:00:00.000000000 +0500
+++ B-source/include/linux/mfd/da9052/tsi_filter.h	2010-12-08
15:46:30.000000000 +0500
@@ -0,0 +1,56 @@
+/*
+ * da9052 TSI filter module declarations.
+  *
+ * Copyright(c) 2009 Dialog Semiconductor Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ *
+ */
+
+#ifndef __LINUX_MFD_DA9052_TSI_FILTER_H
+#define __LINUX_MFD_DA9052_TSI_FILTER_H
+
+#include <linux/mfd/da9052/tsi_cfg.h>
+
+struct da9052_tsi_data {
+	s16	x;
+	s16	y;
+	s16	z;
+};
+
+struct da9052_tsi_raw_fifo {
+	struct semaphore	lock;
+	s32			head;
+	s32			tail;
+	struct	da9052_tsi_data	data[TSI_RAW_DATA_BUF_SIZE];
+};
+
+struct tsi_thread_type {
+	u8			pid;
+	u8			state;
+	struct completion	notifier;
+	struct task_struct	*thread_task;
+} ;
+
+/* State for TSI thread */
+#define	ACTIVE		0
+#define	INACTIVE	1
+
+
+extern u32 da9052_tsi_get_input_dev(u8 off);
+
+ssize_t da9052_tsi_get_calib_display_point(struct da9052_tsi_data *displayPtr);
+
+#endif	/* __LINUX_MFD_DA9052_TSI_FILTER_H */
diff -Naur A-source/include/linux/mfd/da9052/tsi.h
B-source/include/linux/mfd/da9052/tsi.h
--- A-source/include/linux/mfd/da9052/tsi.h	1970-01-01 05:00:00.000000000 +0500
+++ B-source/include/linux/mfd/da9052/tsi.h	2010-12-08 15:46:30.000000000 +0500
@@ -0,0 +1,410 @@
+/*
+ * da9052 TSI module declarations.
+  *
+ * Copyright(c) 2009 Dialog Semiconductor Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ *
+ */
+
+#ifndef __LINUX_MFD_DA9052_TSI_H
+#define __LINUX_MFD_DA9052_TSI_H
+
+#include <linux/mfd/da9052/da9052.h>
+#include <linux/mfd/da9052/tsi_filter.h>
+#include <linux/mfd/da9052/tsi_calibrate.h>
+#include <linux/mfd/da9052/pm.h>
+
+#define DA9052_TSI_DEVICE_NAME		"da9052-tsi"
+#define DA9052_TSI_INPUT_DEV		DA9052_TSI_DEVICE_NAME
+
+#define TSI_VERSION			0x0101
+#define DA9052_VENDOR_ID		0x15B6
+#define DA9052_PRODUCT_ID		0x9052
+
+#define TSI_INPUT_DEVICE_OFF		0
+#define NUM_INPUT_DEVS			1
+
+#define DA9052_DISPLAY_X_MAX		0x3FF
+#define DA9052_DISPLAY_Y_MAX		0x3FF
+#define DA9052_TOUCH_PRESSURE_MAX	0x3FF
+
+#define DA9052_TCA_AUTO_TSI_ENABLE	(1<<0)
+#define DA9052_TCA_PEN_DET_ENABLE	(1<<1)
+#define DA9052_TCA_TSI_XP_MODE_ENABLE	(1<<2)
+
+#define DA9052_TCA_TSI_DELAY_0SLOTS	(0<<6)
+#define DA9052_TCA_TSI_DELAY_2SLOTS	(2<<6)
+#define DA9052_TCA_TSI_DELAY_4SLOTS	(3<<6)
+
+#define DA9052_TCA_TSI_SEL_XPLUS	(1<<0)
+#define DA9052_TCA_TSI_SEL_XMINUS	(1<<1)
+#define DA9052_TCA_TSI_SEL_YPLUS	(1<<2)
+#define DA9052_TCA_TSI_SEL_YMINUS	(1<<3)
+
+#define DA9052_TCA_TSI_MUX_XPLUS_ROUTED_ADCIN7		(0<<4)
+#define DA9052_TCA_TSI_MUX_YPLUS_ROUTED_ADCIN7		(1<<4)
+#define DA9052_TCA_TSI_MUX_XMINUS_ROUTED_ADCIN7		(2<<4)
+#define DA9052_TCA_TSI_MUX_YMINUS_ROUTED_ADCIN7		(3<<4)
+#define DA9052_TCA_TSI_MAN_ENABLE			(1<<6)
+#define DA9052_TCA_TSI_SET_TSIREF			(0<<7)
+#define DA9052_TCA_TSI_SET_XY_REF			(1<<7)
+
+#define DA9052_EVETN_B_E_PEN_DOWN			(1<<6)
+#define DA9052_EVENT_B_E_TSI_READY			(1<<7)
+
+#define DA9052_IRQMASK_B_PENDOWN_MASK			(1<<6)
+#define DA9052_IRQMASK_B_TSI_READY_MASK			(1<<7)
+
+#define X_LSB_SHIFT	(0)
+#define Y_LSB_SHIFT	(2)
+#define Z_LSB_SHIFT	(4)
+#define PEN_DET_SHIFT	(6)
+#define X_MSB_SHIFT	(2)
+#define Y_MSB_SHIFT	(2)
+#define Z_MSB_SHIFT	(2)
+#define X_LSB_MASK	(11 << X_LSB_SHIFT)
+#define Y_LSB_MASK	(11 << Y_LSB_SHIFT)
+#define Z_LSB_MASK	(11 << Z_LSB_SHIFT)
+#define PEN_DET_MASK	(11 << PEN_DET_SHIFT)
+
+#define TSI_FIFO_SIZE			16
+
+#define INVALID_LDO9_VOLT_VALUE		17
+
+#define set_bits(value, mask)		(value | mask)
+#define clear_bits(value, mask)		(value & ~(mask))
+
+#define SUCCESS		0
+#define FAILURE		1
+
+#define SET		1
+#define	RESET		0
+#define	CLEAR		0
+
+#define ENABLE		1
+#define DISABLE		0
+
+#define TRUE		1
+#define FALSE		0
+
+#define incr_with_wrap_reg_fifo(x)			\
+		if (++x >= TSI_REG_DATA_BUF_SIZE)	\
+			x = 0
+
+#define incr_with_wrap(x)	\
+		if (++x >= TSI_FIFO_SIZE)	\
+			x = 0
+
+enum ADC_MODE {
+
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
+enum TSI_MUX_SEL {
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
+	TSI_MANUAL_COORD_X,
+	TSI_MANUAL_COORD_Y,
+	TSI_MANUAL_COORD_Z,
+	TSI_MANUAL_SET,
+	TSI_IDLE
+};
+
+union da9052_tsi_cont_reg {
+	u8 da9052_tsi_cont_a;
+	struct{
+		u8 auto_tsi_en:1;
+		u8 pen_det_en:1;
+		u8 tsi_mode:1;
+		u8 tsi_skip:3;
+		u8 tsi_delay:2;
+	} tsi_cont_a;
+};
+
+union da9052_tsi_man_cont_reg {
+	u8 da9052_tsi_cont_b;
+	struct{
+		u8 tsi_sel_0:1;
+		u8 tsi_sel_1:1;
+		u8 tsi_sel_2:1;
+		u8 tsi_sel_3:1;
+		u8 tsi_mux:2;
+		u8 tsi_man:1;
+		u8 tsi_adc_ref:1;
+	} tsi_cont_b;
+};
+
+struct da9052_tsi_conf {
+	union da9052_tsi_cont_reg	auto_cont;
+	union da9052_tsi_man_cont_reg	man_cont;
+	u8				tsi_adc_sample_intervel:1;
+	enum TSI_STATE			state;
+	u8				ldo9_en:1;
+	u8				ldo9_conf:1;
+	u8				tsi_ready_irq_mask:1;
+	u8				tsi_pendown_irq_mask:1;
+};
+
+
+struct da9052_tsi_reg {
+	u8	x_msb;
+	u8	y_msb;
+	u8	z_msb;
+	u8	lsb;
+ };
+
+
+struct da9052_tsi_reg_fifo {
+	struct semaphore	lock;
+	s32			head;
+	s32			tail;
+	struct da9052_tsi_reg	data[TSI_REG_DATA_BUF_SIZE];
+};
+
+struct da9052_tsi_info {
+	struct  da9052_tsi_conf	tsi_conf;
+	struct input_dev	*input_devs[NUM_INPUT_DEVS];
+	struct calib_cfg_t	*tsi_calib;
+	u32			tsi_data_poll_interval;
+	u32			tsi_penup_count;
+	u32			tsi_zero_data_cnt;
+	u8			pen_dwn_event;
+	u8			tsi_rdy_event;
+	u8			pd_reg_status;
+	u8			datardy_reg_status;
+};
+
+struct da9052_tsi {
+	struct da9052_tsi_reg tsi_fifo[TSI_FIFO_SIZE];
+	struct mutex tsi_fifo_lock;
+	u8 tsi_sampling;
+	u8 tsi_state;
+	u32 tsi_fifo_start;
+	u32 tsi_fifo_end;
+};
+
+ struct da9052_ts_priv {
+	struct da9052	*da9052;
+	struct da9052_eh_nb pd_nb;
+	struct da9052_eh_nb datardy_nb;
+	struct tsi_thread_type	tsi_reg_proc_thread;
+	struct tsi_thread_type	tsi_raw_proc_thread;
+	struct da9052_tsi_platform_data *tsi_pdata;
+	struct da9052_tsi_reg_fifo	tsi_reg_fifo;
+	struct da9052_tsi_raw_fifo	tsi_raw_fifo;
+	u32 tsi_reg_data_poll_interval;
+	u32 tsi_raw_data_poll_interval;
+	u8 early_data_flag;
+	u8 debounce_over;
+	u8 win_reference_valid;
+	int os_data_cnt;
+	int raw_data_cnt;
+};
+
+static inline u8  mask_pendwn_irq(u8 val)
+{
+	return val |= DA9052_IRQMASKB_MPENDOWN;
+}
+
+static inline u8  unmask_pendwn_irq(u8 val)
+{
+	return val &= ~DA9052_IRQMASKB_MPENDOWN;
+}
+
+static inline u8  mask_tsi_rdy_irq(u8 val)
+{
+	return val |= DA9052_IRQMASKB_MTSIREADY;
+}
+
+static inline u8  unmask_tsi_rdy_irq(u8 val)
+{
+	return val &= ~DA9052_IRQMASKB_MTSIREADY;
+}
+
+static inline u8 enable_ldo9(u8 val)
+{
+	return val |= DA9052_LDO9_LDO9EN;
+}
+
+static inline u8  disable_ldo9(u8 val)
+{
+	return val &= ~DA9052_LDO9_LDO9EN;
+}
+
+static inline u8  set_auto_tsi_en(u8 val)
+{
+	return val |= DA9052_TSICONTA_AUTOTSIEN;
+}
+
+static inline u8  reset_auto_tsi_en(u8 val)
+{
+	return val &= ~DA9052_TSICONTA_AUTOTSIEN;
+}
+
+static inline u8  enable_pen_detect(u8 val)
+{
+	return val |= DA9052_TSICONTA_PENDETEN;
+}
+
+static inline u8  disable_pen_detect(u8 val)
+{
+	return val &= ~DA9052_TSICONTA_PENDETEN;
+}
+
+static inline u8  enable_xyzp_mode(u8 val)
+{
+	return val &= ~DA9052_TSICONTA_TSIMODE;
+}
+
+static inline u8  enable_xp_mode(u8 val)
+{
+	return val |= DA9052_TSICONTA_TSIMODE;
+}
+
+static inline u8  enable_tsi_manual_mode(u8 val)
+{
+	return val |= DA9052_TSICONTB_TSIMAN;
+}
+
+static inline u8  disable_tsi_manual_mode(u8 val)
+{
+	return val &= ~DA9052_TSICONTB_TSIMAN;
+}
+
+static inline u8 tsi_sel_xplus_close(u8 val)
+{
+	return val |= DA9052_TSICONTB_TSISEL0;
+}
+
+static inline u8 tsi_sel_xplus_open(u8 val)
+{
+	return val &= ~DA9052_TSICONTB_TSISEL0;
+}
+
+static inline u8 tsi_sel_xminus_close(u8 val)
+{
+	return val |= DA9052_TSICONTB_TSISEL1;
+}
+
+static inline u8 tsi_sel_xminus_open(u8 val)
+{
+	return val &= ~DA9052_TSICONTB_TSISEL1;
+}
+
+static inline u8 tsi_sel_yplus_close(u8 val)
+{
+	return val |= DA9052_TSICONTB_TSISEL2;
+}
+
+static inline u8 tsi_sel_yplus_open(u8 val)
+{
+	return val &= ~DA9052_TSICONTB_TSISEL2;
+}
+
+static inline u8 tsi_sel_yminus_close(u8 val)
+{
+	return val |= DA9052_TSICONTB_TSISEL3;
+}
+
+static inline u8 tsi_sel_yminus_open(u8 val)
+{
+	return val &= ~DA9052_TSICONTB_TSISEL3;
+}
+
+static inline u8 adc_mode_economy_mode(u8 val)
+{
+	return val &= ~DA9052_ADCCONT_ADCMODE;
+}
+
+static inline u8 adc_mode_fast_mode(u8 val)
+{
+	return val |= DA9052_ADCCONT_ADCMODE;
+}
+int da9052_tsi_get_calib_display_point(struct da9052_tsi_data *display);
+
+struct da9052_ldo_config {
+	u16		ldo_volt;
+	u8		ldo_num;
+	u8		ldo_conf:1;
+	u8		ldo_pd:1;
+};
+
+static inline  u8 ldo9_mV_to_reg(u16 value)
+{
+	return (value - DA9052_LDO9_VOLT_LOWER)/DA9052_LDO9_VOLT_STEP;
+}
+
+static inline  u8 validate_ldo9_mV(u16 value)
+{
+	if ((value >= DA9052_LDO9_VOLT_LOWER) && \
+					(value <= DA9052_LDO9_VOLT_UPPER))
+		return
+			(((value - DA9052_LDO9_VOLT_LOWER) %
+				DA9052_LDO9_VOLT_STEP > 0) ? -1 : 0);
+	return FAILURE;
+}
+
+s32 da9052_tsi_raw_proc_thread(void *ptr);
+void __init da9052_init_tsi_fifos(struct da9052_ts_priv *priv);
+void clean_tsi_fifos(struct da9052_ts_priv *priv);
+u32 get_reg_data_cnt(struct da9052_ts_priv *priv);
+u32 get_reg_free_space_cnt(struct da9052_ts_priv *priv);
+void da9052_tsi_process_reg_data(struct da9052_ts_priv *priv);
+void da9052_tsi_pen_down_handler(struct da9052_eh_nb *eh_data, u32 event);
+void da9052_tsi_data_ready_handler(struct da9052_eh_nb *eh_data, u32 event);
+
+#endif /* __LINUX_MFD_DA9052_TSI_H */
