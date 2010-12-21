Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752481Ab0LUSBA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 13:01:00 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:35321 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752042Ab0LUSA5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 13:00:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=FyWPQuPYo+Z2xiFoMzF2rD0ZwYsImiz1leosej0KGhTqMDa4jws94DfRW9Zn6FrUfA
         FMvGJ0L616X+Rkjw2wVV1xGuo/orD7Z/Bj802ovn1JHk7e5vhd1G4orTawLk9Lvf8hLC
         CfIqs20AtkQkjBnXlxYjzXBIb/cJZWSwTNNA8=
MIME-Version: 1.0
Date: Tue, 21 Dec 2010 19:00:56 +0100
Message-ID: <AANLkTinkj4uYG1sFCGRypa4z=Neyj6jOsy+OL91eunpz@mail.gmail.com>
Subject: [PATCHv4 1/11] MFD: MFD module of DA9052 device driver
From: dd diasemi <dd.diasemi@gmail.com>
To: sameo@openedhand.com
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MFD Core File for DA9052 PMIC device from Dialog Semiconductor.

Changes made since last submission:
. single kernel image for SPI and I2C connectivities.
. equal priorites for all DA9052 PMIC device events.
. semaphore protection for event notification. note usage of mutex
yields undesirable effects at run time.
. masked events are not processed.

Linux Kernel Version: 2.6.34

Signed-off-by: D. Chen <dchen@diasemi.com>
---
diff -Naur linux-2.6.34-orig/drivers/mfd/da9052-core.c
linux-2.6.34/drivers/mfd/da9052-core.c
--- linux-2.6.34-orig/drivers/mfd/da9052-core.c	1970-01-01
05:00:00.000000000 +0500
+++ linux-2.6.34/drivers/mfd/da9052-core.c	2010-10-12 12:55:23.000000000 +0500
@@ -0,0 +1,430 @@
+/*
+ * da9052-core.c  --  Device access for Dialog DA9052
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
+#include <linux/device.h>
+#include <linux/jiffies.h>
+#include <linux/delay.h>
+#include <linux/interrupt.h>
+#include <linux/workqueue.h>
+#include <linux/irq.h>
+#include <linux/list.h>
+#include <linux/mfd/core.h>
+#include <linux/spi/spi.h>
+#include <linux/i2c.h>
+
+#include <linux/mfd/da9052/da9052.h>
+#include <linux/mfd/da9052/adc.h>
+
+#define SUCCESS		0
+#define FAILURE		1
+
+struct da9052_eh_nb eve_nb_array[EVE_CNT];
+static struct da9052_ssc_ops ssc_ops;
+struct mutex manconv_lock;
+static struct semaphore eve_nb_array_lock;
+
+void da9052_lock(struct da9052 *da9052)
+{
+	mutex_lock(&da9052->ssc_lock);
+}
+EXPORT_SYMBOL(da9052_lock);
+
+void da9052_unlock(struct da9052 *da9052)
+{
+	mutex_unlock(&da9052->ssc_lock);
+}
+EXPORT_SYMBOL(da9052_unlock);
+
+int da9052_ssc_write(struct da9052 *da9052, struct da9052_ssc_msg *sscmsg)
+{
+	int ret = 0;
+
+	if ((sscmsg->addr < DA9052_PAGE0_REG_START) ||
+	(sscmsg->addr > DA9052_PAGE1_REG_END) ||
+	((sscmsg->addr > DA9052_PAGE0_REG_END) &&
+	(sscmsg->addr < DA9052_PAGE1_REG_START)))
+		return INVALID_REGISTER;
+
+	ret = ssc_ops.write(da9052, sscmsg);
+
+	if (!ret) {
+		if (da9052->ssc_cache[sscmsg->addr].type != VOLATILE) {
+			da9052->ssc_cache[sscmsg->addr].val = sscmsg->data;
+			da9052->ssc_cache[sscmsg->addr].status = VALID;
+		}
+	}
+
+	return ret;
+}
+
+int da9052_ssc_read(struct da9052 *da9052, struct da9052_ssc_msg *sscmsg)
+{
+	int ret = 0;
+
+	if ((sscmsg->addr < DA9052_PAGE0_REG_START) ||
+	(sscmsg->addr > DA9052_PAGE1_REG_END) ||
+	((sscmsg->addr > DA9052_PAGE0_REG_END) &&
+	(sscmsg->addr < DA9052_PAGE1_REG_START)))
+		return INVALID_REGISTER;
+
+	if (da9052->ssc_cache[sscmsg->addr].status == VALID) {
+		sscmsg->data = da9052->ssc_cache[sscmsg->addr].val;
+		return 0;
+	}
+
+	ret = ssc_ops.read(da9052, sscmsg);
+
+	if (!ret) {
+		if (da9052->ssc_cache[sscmsg->addr].type != VOLATILE) {
+			da9052->ssc_cache[sscmsg->addr].val = sscmsg->data;
+			da9052->ssc_cache[sscmsg->addr].status = VALID;
+		}
+	}
+
+	return ret;
+}
+
+int da9052_ssc_write_many(struct da9052 *da9052, struct da9052_ssc_msg *sscmsg,
+				int msg_no)
+{
+	int ret = 0;
+	int cnt = 0;
+
+	if (msg_no > MAX_READ_WRITE_CNT)
+		return -EIO;
+
+	ret = ssc_ops.write_many(da9052, sscmsg, msg_no);
+	for (cnt = 0; cnt < msg_no; cnt++) {
+		if (da9052->ssc_cache[sscmsg[cnt].addr].type != VOLATILE) {
+			da9052->ssc_cache[sscmsg[cnt].addr].val =
+			sscmsg[cnt].data;
+			da9052->ssc_cache[sscmsg[cnt].addr].status = VALID;
+		}
+	}
+	return ret;
+}
+
+int da9052_ssc_read_many(struct da9052 *da9052, struct da9052_ssc_msg *sscmsg,
+			int msg_no)
+{
+	int ret = 0;
+	int cnt = 0;
+
+	if (msg_no > MAX_READ_WRITE_CNT)
+		return -EIO;
+
+	ret = ssc_ops.read_many(da9052, sscmsg, msg_no);
+	for (cnt = 0; cnt < msg_no; cnt++) {
+		if (da9052->ssc_cache[sscmsg[cnt].addr].type
+			!= VOLATILE) {
+			da9052->ssc_cache[sscmsg[cnt].addr].val =
+			sscmsg[cnt].data;
+			da9052->ssc_cache[sscmsg[cnt].addr].status = VALID;
+		}
+	}
+	return ret;
+}
+
+static irqreturn_t da9052_eh_isr(int irq, void *dev_id)
+{
+	struct da9052 *da9052 = dev_id;
+	schedule_work(&da9052->eh_isr_work);
+	disable_irq_nosync(DA9052_IRQ);
+	return IRQ_HANDLED;
+}
+
+int eh_register_nb(struct da9052 *da9052, struct da9052_eh_nb *nb)
+{
+
+	if (nb == NULL)
+		return -EINVAL;
+
+	if (nb->eve_type >= EVE_CNT)
+		return -EINVAL;
+
+	INIT_LIST_HEAD(&nb->nb_list);
+
+	if (down_interruptible(&eve_nb_array_lock))
+		return -EAGAIN;
+
+	list_add_tail(&nb->nb_list, &(eve_nb_array[nb->eve_type].nb_list));
+
+	up(&eve_nb_array_lock);
+
+	return 0;
+}
+
+int eh_unregister_nb(struct da9052 *da9052, struct da9052_eh_nb *nb)
+{
+
+	if (nb == NULL)
+		return -EINVAL;
+
+	if (down_interruptible(&eve_nb_array_lock))
+		return -EAGAIN;
+
+	list_del_init(&(nb->nb_list));
+
+	up(&eve_nb_array_lock);
+
+	return 0;
+}
+
+static int process_events(struct da9052 *da9052, int events_sts)
+{
+
+	int cnt = 0;
+	int tmp_events_sts = 0;
+	unsigned char event = 0;
+
+	struct list_head *ptr;
+	struct da9052_eh_nb *nb_ptr;
+
+	for (cnt = 0; cnt < EVE_CNT; cnt++) {
+		tmp_events_sts = events_sts;
+
+		event = cnt;
+
+		if (!((tmp_events_sts >> cnt) & 0x1))
+			continue;
+
+		if (event == PEN_DOWN_EVE) {
+			if (list_empty(&(eve_nb_array[event].nb_list)))
+				continue;
+		}
+
+		if (down_interruptible(&eve_nb_array_lock))
+			return -EIO;
+
+		list_for_each(ptr, &(eve_nb_array[event].nb_list)) {
+			nb_ptr = list_entry(ptr, struct da9052_eh_nb, nb_list);
+			nb_ptr->call_back(nb_ptr, events_sts);
+		}
+		up(&eve_nb_array_lock);
+	}
+	return 0;
+}
+
+void eh_workqueue_isr(struct work_struct *work)
+{
+	struct da9052 *da9052 =
+		container_of(work, struct da9052, eh_isr_work);
+
+	struct da9052_ssc_msg eve_data[4];
+	struct da9052_ssc_msg eve_mask_data[4];
+	int events_sts, ret;
+	u32 mask;
+	unsigned char cnt = 0;
+
+	events_sts = 0;
+	mask = 0;
+
+	for (cnt = 0; cnt < DA9052_EVE_REGISTERS; cnt++) {
+		eve_data[cnt].addr = (DA9052_EVENTA_REG + cnt);
+		eve_data[cnt].data = 0;
+	}
+
+	/* Prepare ssc message to read all four event registers */
+	for (cnt = 0; cnt < DA9052_EVE_REGISTERS; cnt++) {
+		eve_mask_data[cnt].addr = (DA9052_IRQMASKA_REG + cnt);
+		eve_mask_data[cnt].data = 0;
+	}
+
+	da9052_lock(da9052);
+
+	ret = da9052_ssc_read_many(da9052, eve_data, DA9052_EVE_REGISTERS);
+	if (ret) {
+		enable_irq(DA9052_IRQ);
+		da9052_unlock(da9052);
+		return;
+	}
+
+	ret = da9052_ssc_read_many(da9052, eve_mask_data, DA9052_EVE_REGISTERS);
+	if (ret) {
+		enable_irq(DA9052_IRQ);
+		da9052_unlock(da9052);
+		return;
+	}
+	/* Collect all events */
+	for (cnt = 0; cnt < DA9052_EVE_REGISTERS; cnt++)
+		events_sts |= (eve_data[cnt].data << (DA9052_EVE_REGISTER_SIZE
+							* cnt));
+	/* Collect all mask */
+	for (cnt = 0; cnt < DA9052_EVE_REGISTERS; cnt++)
+		mask |= (eve_mask_data[cnt].data << (DA9052_EVE_REGISTER_SIZE
+						* cnt));
+	events_sts &= ~mask;
+
+	da9052_unlock(da9052);
+
+	if (events_sts == 0) {
+		enable_irq(DA9052_IRQ);
+		da9052_unlock(da9052);
+		return;
+	}
+
+	process_events(da9052, events_sts);
+
+	da9052_lock(da9052);
+	for (cnt = 0; cnt < 4; cnt++) {
+		if (eve_data[cnt].data) {
+			ret = da9052_ssc_write(da9052, &eve_data[cnt]);
+			if (ret) {
+				enable_irq(DA9052_IRQ);
+				da9052_unlock(da9052);
+				return;
+			}
+		}
+	}
+	da9052_unlock(da9052);
+
+	udelay(50);
+	enable_irq(DA9052_IRQ);
+}
+
+static void da9052_eh_restore_irq(void)
+{
+	free_irq(DA9052_IRQ, NULL);
+}
+
+static int da9052_add_subdevice_pdata(struct da9052 *da9052,
+		const char *name, void *pdata, size_t pdata_size)
+{
+	struct mfd_cell cell = {
+		.name = name,
+		.platform_data = pdata,
+		.data_size = pdata_size,
+	};
+	return mfd_add_devices(da9052->dev, -1, &cell, 1, NULL, 0);
+}
+
+static int da9052_add_subdevice(struct da9052 *da9052, const char *name)
+{
+	return da9052_add_subdevice_pdata(da9052, name, NULL, 0);
+}
+
+static int add_da9052_devices(struct da9052 *da9052)
+{
+	s32 ret = 0;
+	struct da9052_platform_data *pdata = da9052->dev->platform_data;
+	struct da9052_leds_platform_data leds_data = {
+			.num_leds = pdata->led_data->num_leds,
+			.led = pdata->led_data->led,
+	};
+	struct da9052_regulator_platform_data regulator_pdata = {
+		.regulators = pdata->regulators,
+	};
+
+	struct da9052_tsi_platform_data tsi_data = *(pdata->tsi_data);
+
+	if (pdata && pdata->init) {
+		ret = pdata->init(da9052);
+		if (ret != 0)
+			return ret;
+	}
+
+	ret = da9052_add_subdevice(da9052, "da9052-rtc");
+	if (ret)
+		return ret;
+	ret = da9052_add_subdevice(da9052, "da9052-onkey");
+	if (ret)
+		return ret;
+
+	ret = da9052_add_subdevice(da9052, "WLED-1");
+	if (ret)
+		return ret;
+
+	ret = da9052_add_subdevice(da9052, "WLED-2");
+	if (ret)
+		return ret;
+
+	ret = da9052_add_subdevice(da9052, "WLED-3");
+	if (ret)
+		return ret;
+
+	ret = da9052_add_subdevice(da9052, "da9052-adc");
+	if (ret)
+		return ret;
+
+	ret = da9052_add_subdevice(da9052, "da9052-wdt");
+	if (ret)
+		return ret;
+
+	ret = da9052_add_subdevice_pdata(da9052, "da9052-gpio",
+				pdata, sizeof(*pdata));
+	if (ret)
+		return ret;
+
+	ret = da9052_add_subdevice_pdata(da9052, "da9052-leds",
+				&leds_data, sizeof(leds_data));
+	if (ret)
+		return ret;
+
+	ret = da9052_add_subdevice_pdata(da9052, "da9052-regulator",
+		&regulator_pdata, sizeof(regulator_pdata));
+	if (ret)
+		return ret;
+
+	ret = da9052_add_subdevice_pdata(da9052, "da9052-tsi",
+				&tsi_data, sizeof(tsi_data));
+	if (ret)
+		return ret;
+
+	ret = da9052_add_subdevice(da9052, "da9052-bat");
+	if (ret)
+		return ret;
+
+	return ret;
+}
+
+int da9052_ssc_init(struct da9052 *da9052)
+{
+	int cnt;
+	struct da9052_platform_data *pdata;
+
+	for (cnt = 0; cnt < EVE_CNT; cnt++)
+		INIT_LIST_HEAD(&(eve_nb_array[cnt].nb_list));
+
+	mutex_init(&manconv_lock);
+
+	init_MUTEX(&eve_nb_array_lock);
+
+	da9052->read = da9052_ssc_read;
+	da9052->write = da9052_ssc_write;
+	da9052->read_many = da9052_ssc_read_many;
+	da9052->write_many = da9052_ssc_write_many;
+
+	if (SPI  == da9052->connecting_device && ssc_ops.write == NULL) {
+		ssc_ops.write = da9052_spi_write;
+		ssc_ops.read = da9052_spi_read;
+		ssc_ops.write_many = da9052_spi_write_many;
+		ssc_ops.read_many = da9052_spi_read_many;
+	} else if (I2C  == da9052->connecting_device && ssc_ops.write == NULL) {
+		ssc_ops.write = da9052_i2c_write;
+		ssc_ops.read = da9052_i2c_read;
+		ssc_ops.write_many = da9052_i2c_write_many;
+		ssc_ops.read_many = da9052_i2c_read_many;
+	} else
+		return -1;
+
+	da9052->register_event_notifier = eh_register_nb;
+	da9052->unregister_event_notifier = eh_unregister_nb;
+
+	mutex_init(&da9052->ssc_lock);
+
+	pdata = da9052->dev->platform_data;
+	add_da9052_devices(da9052);
+
+	INIT_WORK(&da9052->eh_isr_work, eh_workqueue_isr);
+
+	if (request_irq(DA9052_IRQ, da9052_eh_isr, IRQ_TYPE_LEVEL_LOW,
+	DA9052_EH_DEVICE_NAME, da9052))
+		return -EIO;
+
+	return 0;
+}
+
+void da9052_ssc_exit(struct da9052 *da9052)
+{
+	mutex_destroy(&manconv_lock);
+	da9052_eh_restore_irq();
+	free_irq(DA9052_IRQ, NULL);
+	mutex_destroy(&da9052->ssc_lock);
+	mutex_destroy(&da9052->eve_nb_lock);
+	return;
+}
+
+MODULE_AUTHOR("Dialog Semiconductor Ltd <dchen@diasemi.com>");
+MODULE_DESCRIPTION("DA9052 MFD Core");
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:" DA9052_SSC_DEVICE_NAME);
diff -Naur A-source/drivers/mfd/da9052-i2c.c B-source/drivers/mfd/da9052-i2c.c
--- A-source/drivers/mfd/da9052-i2c.c	1970-01-01 05:00:00.000000000 +0500
+++ B-source/drivers/mfd/da9052-i2c.c	2010-12-08 14:05:46.000000000 +0500
@@ -0,0 +1,303 @@
+/*
+ * Copyright(c) 2009 Dialog Semiconductor Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * da9052-i2c.c: I2C SSC (Synchronous Serial Communication) driver for DA9052
+ */
+
+#include <linux/device.h>
+#include <linux/mfd/core.h>
+#include <linux/i2c.h>
+#include <linux/mfd/da9052/da9052.h>
+#include <linux/mfd/da9052/reg.h>
+
+static struct da9052 *da9052_i2c;
+
+#define I2C_CONNECTED 0
+
+static int da9052_i2c_is_connected(void)
+{
+
+	struct da9052_ssc_msg msg;
+	msg.addr = DA9052_INTERFACE_REG;
+
+	if (0 != da9052_i2c_read(da9052_i2c, &msg))
+		return -1;
+	else
+		return 0;
+}
+
+static int __devinit da9052_i2c_probe(struct i2c_client *client,
+	const struct i2c_device_id *id)
+{
+	struct i2c_adapter *adapter;
+
+	da9052_i2c = kzalloc(sizeof(struct da9052), GFP_KERNEL);
+
+	if (!da9052_i2c)
+		return -ENOMEM;
+
+	adapter = to_i2c_adapter(client->dev.parent);
+
+	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_BYTE_DATA)) {
+		dev_info(&client->dev,\
+		"Error in %s:i2c_check_functionality\n", __func__);
+		return -ENODEV;;
+	}
+
+	da9052_i2c->i2c_client = client;
+
+	da9052_i2c->dev = &client->dev;
+
+	da9052_i2c->adapter = adapter;
+
+	da9052_i2c->slave_addr = DA9052_I2C_ADDR >> 1;
+
+	i2c_set_clientdata(client, da9052_i2c);
+
+	if (I2C_CONNECTED  == da9052_i2c_is_connected()) {
+		da9052_i2c->connecting_device = I2C;
+		if (0 != da9052_ssc_init(da9052_i2c))
+			return -ENODEV;
+	} else
+		return -ENODEV;
+	return 0;
+}
+
+static int da9052_i2c_remove(struct i2c_client *client)
+{
+
+	struct da9052 *da9052 = i2c_get_clientdata(client);
+
+	mfd_remove_devices(da9052->dev);
+	kfree(da9052);
+	return 0;
+}
+
+int da9052_i2c_write(struct da9052 *da9052, struct da9052_ssc_msg *msg)
+{
+	struct i2c_msg i2cmsg;
+	unsigned char buf[2] = {0};
+	int ret = 0;
+
+	buf[0] = msg->addr;
+	buf[1] = msg->data;
+
+	i2cmsg.addr  = da9052->slave_addr;
+	i2cmsg.len   = 2;
+	i2cmsg.buf   = buf;
+
+	i2cmsg.flags = 0;
+
+	ret = i2c_transfer(da9052->adapter, &i2cmsg, 1);
+
+	if (ret < 0) {
+		dev_info(&da9052->i2c_client->dev,\
+		"_%s:master_xfer Failed!!\n", __func__);
+		return ret;
+	}
+
+	return 0;
+}
+
+int da9052_i2c_read(struct da9052 *da9052, struct da9052_ssc_msg *msg)
+{
+
+	unsigned char buf[2] = {0, 0};
+	struct i2c_msg i2cmsg[2];
+	int ret = 0;
+
+	buf[0] = msg->addr;
+
+	i2cmsg[0].addr  = da9052->slave_addr ;
+	i2cmsg[0].len   = 1;
+	i2cmsg[0].buf   = &buf[0];
+
+	i2cmsg[0].flags = 0;
+
+	i2cmsg[1].addr  = da9052->slave_addr ;
+	i2cmsg[1].len   = 1;
+	i2cmsg[1].buf   = &buf[1];
+
+	i2cmsg[1].flags = I2C_M_RD;
+
+	ret = i2c_transfer(da9052->adapter, i2cmsg, 2);
+	if (ret < 0) {
+		dev_info(&da9052->i2c_client->dev,\
+		"2 - %s:master_xfer Failed!!\n", __func__);
+		return ret;
+	}
+
+	msg->data = *i2cmsg[1].buf;
+
+	return 0;
+}
+
+int da9052_i2c_write_many(struct da9052 *da9052,
+	struct da9052_ssc_msg *sscmsg, int msg_no)
+{
+
+	struct i2c_msg i2cmsg;
+	unsigned char data_buf[MAX_READ_WRITE_CNT+1];
+	struct da9052_ssc_msg ctrlb_msg;
+	struct da9052_ssc_msg *msg_queue = sscmsg;
+	int ret = 0;
+	unsigned char cont_data = 1;
+	unsigned char cnt = 0;
+
+	for (cnt = 1; cnt < msg_no; cnt++) {
+		if ((msg_queue[cnt].addr - msg_queue[cnt-1].addr) != 1) {
+			cont_data = 0;
+			break;
+		}
+	}
+
+	if (cont_data == 0) {
+		for (cnt = 0; cnt < msg_no; cnt++) {
+			ret = da9052->write(da9052, &msg_queue[cnt]);
+			if (ret != 0)
+				return ret;
+		}
+		return 0;
+	}
+	ctrlb_msg.addr = DA9052_CONTROLB_REG;
+	ctrlb_msg.data = 0x0;
+	ret = da9052->read(da9052, &ctrlb_msg);
+
+	if (ret != 0)
+		return ret;
+
+	if (ctrlb_msg.data & DA9052_CONTROLB_WRITEMODE) {
+		ctrlb_msg.data &= ~DA9052_CONTROLB_WRITEMODE;
+		ret = da9052->write(da9052, &ctrlb_msg);
+
+		if (ret != 0)
+			return ret;
+	}
+
+	data_buf[0] = msg_queue[0].addr;
+
+	for (cnt = 0; cnt < msg_no; cnt++)
+		data_buf[cnt+1] = msg_queue[cnt].data;
+
+	i2cmsg.addr  = da9052->slave_addr ;
+	i2cmsg.len   = (msg_no + 1);
+	i2cmsg.buf   = data_buf;
+
+	i2cmsg.flags = 0;
+
+	ret = i2c_transfer(da9052->adapter, &i2cmsg, 1);
+	if (ret < 0) {
+		dev_info(&da9052->i2c_client->dev,\
+		"1 - i2c_transfer function falied in [%s]!!!\n", __func__);
+		return ret;
+	}
+
+	return 0;
+}
+
+int da9052_i2c_read_many(struct da9052 *da9052,
+	struct da9052_ssc_msg *sscmsg, int msg_no)
+{
+
+	struct i2c_msg i2cmsg;
+	unsigned char data_buf[MAX_READ_WRITE_CNT];
+	struct da9052_ssc_msg *msg_queue = sscmsg;
+	int ret = 0;
+	unsigned char cont_data = 1;
+	unsigned char cnt = 0;
+
+	for (cnt = 1; cnt < msg_no; cnt++) {
+		if ((msg_queue[cnt].addr - msg_queue[cnt-1].addr) != 1) {
+			cont_data = 0;
+			break;
+		}
+	}
+
+	if (cont_data == 0) {
+		for (cnt = 0; cnt < msg_no; cnt++) {
+			ret = da9052->read(da9052, &msg_queue[cnt]);
+			if (ret != 0) {
+				dev_info(&da9052->i2c_client->dev,\
+				"Error in %s", __func__);
+				return ret;
+			}
+		}
+		return 0;
+	}
+
+
+	data_buf[0] = msg_queue[0].addr;
+
+	i2cmsg.addr  = da9052->slave_addr ;
+	i2cmsg.len   = 1;
+	i2cmsg.buf   = data_buf;
+
+	i2cmsg.flags = 0;
+
+	ret = i2c_transfer(da9052->adapter, &i2cmsg, 1);
+	if (ret < 0) {
+		dev_info(&da9052->i2c_client->dev,\
+		"1 - i2c_transfer function falied in [%s]!!!\n", __func__);
+		return ret;
+	}
+
+	i2cmsg.addr  = da9052->slave_addr ;
+	i2cmsg.len   = msg_no;
+	i2cmsg.buf   = data_buf;
+
+	i2cmsg.flags = I2C_M_RD;
+
+	ret = i2c_transfer(da9052->adapter,
+		&i2cmsg, 1);
+	if (ret < 0) {
+		dev_info(&da9052->i2c_client->dev,\
+		"2 - i2c_transfer function falied in [%s]!!!\n", __func__);
+		return ret;
+	}
+
+	for (cnt = 0; cnt < msg_no; cnt++)
+		sscmsg[cnt].data = data_buf[cnt];
+
+	return 0;
+}
+
+static struct i2c_device_id da9052_ssc_id[] = {
+	{ DA9052_SSC_I2C_DEVICE_NAME, 0},
+	{}
+};
+
+static struct i2c_driver da9052_i2c_driver =  {
+	.driver = {
+		.name	= DA9052_SSC_I2C_DEVICE_NAME,
+		.owner	= THIS_MODULE,
+	},
+	.probe	= da9052_i2c_probe,
+	.remove	= da9052_i2c_remove,
+	.id_table	= da9052_ssc_id,
+};
+
+static int __init da9052_i2c_init(void)
+{
+	int ret = 0;
+	ret = i2c_add_driver(&da9052_i2c_driver);
+	if (ret != 0)
+		return ret;
+	return 0;
+}
+module_init(da9052_i2c_init);
+
+static void  __exit da9052_i2c_exit(void)
+{
+	i2c_del_driver(&da9052_i2c_driver);
+}
+module_exit(da9052_i2c_exit);
+
+MODULE_AUTHOR("Dialog Semiconductor Ltd <dchen@diasemi.com>");
+MODULE_DESCRIPTION("I2C driver for Dialog DA9052 PMIC");
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:" DA9052_SSC_I2C_DEVICE_NAME);
diff -Naur A-source/drivers/mfd/da9052-spi.c B-source/drivers/mfd/da9052-spi.c
--- A-source/drivers/mfd/da9052-spi.c	1970-01-01 05:00:00.000000000 +0500
+++ B-source/drivers/mfd/da9052-spi.c	2010-12-08 14:05:46.000000000 +0500
@@ -0,0 +1,290 @@
+/*
+ * Copyright(c) 2009 Dialog Semiconductor Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * da9052-spi.c: SPI SSC (Synchronous Serial Communication) driver for DA9052
+ */
+
+#include <linux/device.h>
+#include <linux/mfd/core.h>
+#include <linux/spi/spi.h>
+#include <linux/mfd/da9052/da9052.h>
+#include <linux/mfd/da9052/reg.h>
+
+
+struct da9052 *da9052_spi;
+
+#define SPI_CONNECTED 0
+
+static int da9052_spi_is_connected(void)
+{
+
+	struct da9052_ssc_msg msg;
+
+	msg.addr = DA9052_INTERFACE_REG;
+
+	if (0 != da9052_spi_read(da9052_spi, &msg))
+		return -1;
+	else if (0x88 != msg.data)
+		return -1;
+
+	return 0;
+
+}
+
+static int da9052_spi_probe(struct spi_device *spi)
+{
+	da9052_spi = kzalloc(sizeof(struct da9052), GFP_KERNEL);
+
+	if (!da9052_spi)
+		return -ENOMEM;
+
+	spi->mode = SPI_MODE_0 | SPI_CPOL;
+	spi->bits_per_word = 8;
+	spi_setup(spi);
+
+	da9052_spi->dev = &spi->dev;
+
+	da9052_spi->spi_dev = spi;
+
+	da9052_spi->spi_rx_buf = kmalloc(2, GFP_KERNEL | GFP_DMA);
+	if (!da9052_spi->spi_rx_buf)
+		return -ENOMEM;
+
+	da9052_spi->spi_tx_buf = kmalloc(2, GFP_KERNEL | GFP_DMA);
+	if (!da9052_spi->spi_tx_buf)
+		return -ENOMEM;
+
+	da9052_spi->spi_active_page  = PAGECON_0;
+	da9052_spi->rw_pol = 1;
+
+	dev_set_drvdata(&spi->dev, da9052_spi);
+
+	if (SPI_CONNECTED  == da9052_spi_is_connected()) {
+		da9052_spi->connecting_device = SPI;
+		if (0 != da9052_ssc_init(da9052_spi))
+			return -ENODEV;
+	} else
+		return -ENODEV;
+
+	return 0;
+}
+
+static int da9052_spi_remove(struct spi_device *spi)
+{
+	struct da9052 *da9052 = dev_get_drvdata(&spi->dev);
+
+	if (SPI == da9052->connecting_device)
+		da9052_ssc_exit(da9052);
+	mfd_remove_devices(&spi->dev);
+	kfree(da9052->spi_rx_buf);
+	kfree(da9052->spi_tx_buf);
+	kfree(da9052);
+	return 0;
+}
+
+static struct spi_driver da9052_spi_driver = {
+	.driver = {
+		.name	 = DA9052_SSC_SPI_DEVICE_NAME,
+		.bus	= &spi_bus_type,
+		.owner	= THIS_MODULE,
+	},
+	.probe		= da9052_spi_probe,
+	.remove		= __devexit_p(da9052_spi_remove),
+};
+
+
+static int da9052_spi_set_page(struct da9052 *da9052, unsigned char page)
+{
+
+	struct da9052_ssc_msg sscmsg;
+	struct spi_message message;
+	struct spi_transfer xfer;
+	int ret = 0;
+
+	if ((page != PAGECON_0) && ((page != PAGECON_128)))
+		return INVALID_PAGE;
+
+	sscmsg.addr = DA9052_PAGECON0_REG;
+
+	sscmsg.data = page;
+
+	if (!da9052->rw_pol)
+		sscmsg.addr = ((sscmsg.addr << 1) | RW_POL);
+	else
+		sscmsg.addr = (sscmsg.addr << 1);
+
+	spi_message_init(&message);
+	memset(&xfer, 0, sizeof(xfer));
+
+	xfer.len = 2;
+	xfer.tx_buf = da9052->spi_tx_buf;
+	xfer.rx_buf = da9052->spi_rx_buf;
+
+	da9052->spi_tx_buf[0] = sscmsg.addr;
+	da9052->spi_tx_buf[1] = sscmsg.data;
+
+	spi_message_add_tail(&xfer, &message);
+
+	ret = spi_sync(da9052->spi_dev, &message);
+
+	if (ret == 0) {
+		da9052->spi_active_page = page;
+		return 0;
+	} else
+		return ret;
+
+	return 0;
+}
+
+int da9052_spi_write(struct da9052 *da9052, struct da9052_ssc_msg *msg)
+{
+
+	struct spi_message message;
+	struct spi_transfer xfer;
+	int ret;
+	struct da9052_ssc_msg sscmsg;
+
+	sscmsg.addr = msg->addr;
+	sscmsg.data = msg->data;
+
+	if ((sscmsg.addr > PAGE_0_END) &&
+		(da9052->spi_active_page == PAGECON_0)) {
+		da9052_spi_set_page(da9052, PAGECON_128);
+		sscmsg.addr = (sscmsg.addr - PAGE_1_START);
+	} else if ((sscmsg.addr < PAGE_1_START) &&
+		(da9052->spi_active_page == PAGECON_128)) {
+		da9052_spi_set_page(da9052, PAGECON_0);
+	} else if (sscmsg.addr > PAGE_0_END)
+		sscmsg.addr = (sscmsg.addr - PAGE_1_START);
+
+	if (!da9052->rw_pol)
+		sscmsg.addr = ((sscmsg.addr << 1) | RW_POL);
+	else
+		sscmsg.addr = (sscmsg.addr << 1);
+
+	spi_message_init(&message);
+	memset(&xfer, 0, sizeof(xfer));
+
+	xfer.len = 2;
+	xfer.tx_buf = da9052->spi_tx_buf;
+	xfer.rx_buf = da9052->spi_rx_buf;
+
+	da9052->spi_tx_buf[0] = sscmsg.addr;
+	da9052->spi_tx_buf[1] = sscmsg.data;
+
+	spi_message_add_tail(&xfer, &message);
+
+	ret = spi_sync(da9052->spi_dev, &message);
+
+	return ret;
+}
+
+int da9052_spi_write_many(struct da9052 *da9052, struct da9052_ssc_msg *sscmsg,
+			int msg_no)
+{
+	int cnt, ret = 0;
+
+	for (cnt = 0; cnt < msg_no; cnt++, sscmsg++) {
+		ret = da9052_ssc_write(da9052, sscmsg);
+		if (ret != 0)
+			return -EIO;
+	}
+
+	return 0;
+}
+
+int da9052_spi_read(struct da9052 *da9052, struct da9052_ssc_msg *msg)
+{
+
+	struct spi_message message;
+	struct spi_transfer xfer;
+	int ret;
+
+
+	struct da9052_ssc_msg sscmsg;
+
+	sscmsg.addr = msg->addr;
+	sscmsg.data = msg->data;
+
+	if ((sscmsg.addr > PAGE_0_END) &&
+		(da9052->spi_active_page == PAGECON_0)) {
+			da9052_spi_set_page(da9052, PAGECON_128);
+			sscmsg.addr = (sscmsg.addr - PAGE_1_START);
+	} else if ((sscmsg.addr < PAGE_1_START) &&
+		(da9052->spi_active_page == PAGECON_128)) {
+			da9052_spi_set_page(da9052, PAGECON_0);
+	} else if (sscmsg.addr > PAGE_0_END)
+		sscmsg.addr = (sscmsg.addr - PAGE_1_START);
+
+	if (da9052->rw_pol)
+		sscmsg.addr = ((sscmsg.addr << 1) | RW_POL);
+	else
+		sscmsg.addr = (sscmsg.addr << 1);
+
+	spi_message_init(&message);
+	memset(&xfer, 0, sizeof(xfer));
+
+	xfer.len = 2;
+	xfer.tx_buf = da9052->spi_tx_buf;
+	xfer.rx_buf = da9052->spi_rx_buf;
+
+	da9052->spi_tx_buf[0] = sscmsg.addr;
+	da9052->spi_tx_buf[1] = 0xff;
+
+	da9052->spi_rx_buf[0] = 0;
+	da9052->spi_rx_buf[1] = 0;
+
+	spi_message_add_tail(&xfer, &message);
+
+	ret = spi_sync(da9052->spi_dev, &message);
+
+	if (ret == 0) {
+		msg->data = da9052->spi_rx_buf[1];
+		return 0;
+	} else
+		return ret;
+
+	return 0;
+}
+
+int da9052_spi_read_many(struct da9052 *da9052, struct da9052_ssc_msg *sscmsg,
+			int msg_no)
+{
+	int cnt, ret = 0;
+
+	for (cnt = 0; cnt < msg_no; cnt++, sscmsg++) {
+		ret = da9052_ssc_read(da9052, sscmsg);
+		if (ret != 0)
+			return -EIO;
+	}
+
+	return 0;
+}
+
+static int __init da9052_spi_init(void)
+{
+	int ret = 0;
+	ret = spi_register_driver(&da9052_spi_driver);
+	if (ret != 0)
+		return ret;
+
+	return 0;
+}
+module_init(da9052_spi_init);
+
+static void __exit da9052_spi_exit(void)
+{
+	spi_unregister_driver(&da9052_spi_driver);
+}
+
+module_exit(da9052_spi_exit);
+
+MODULE_AUTHOR("Dialog Semiconductor Ltd <dchen@diasemi.com>");
+MODULE_DESCRIPTION("SPI driver for Dialog DA9052 PMIC");
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:" DA9052_SSC_SPI_DEVICE_NAME);
diff -Naur A-source/drivers/mfd/Kconfig B-source/drivers/mfd/Kconfig
--- A-source/drivers/mfd/Kconfig	2010-05-17 02:17:36.000000000 +0500
+++ B-source/drivers/mfd/Kconfig	2010-12-08 14:05:46.000000000 +0500
@@ -193,6 +193,18 @@
 	  individual components like LCD backlight, voltage regulators,
 	  LEDs and battery-charger under the corresponding menus.

+
+config PMIC_DA9052
+	tristate "Dialog DA9052 with SPI/I2C"
+	depends on SPI_MASTER=y
+	depends on I2C=y
+	select MFD_CORE
+	help
+	 SPI/I2C Support for the  Dialog semiconductor DA9052 PMIC.
+         This driver provides common support for accessing  the device,
+         additional drivers must be enabled in order to use the
+         functionality of the device.
+
 config PMIC_ADP5520
 	bool "Analog Devices ADP5520/01 MFD PMIC Core Support"
 	depends on I2C=y
diff -Naur A-source/drivers/mfd/Makefile B-source/drivers/mfd/Makefile
--- A-source/drivers/mfd/Makefile	2010-05-17 02:17:36.000000000 +0500
+++ B-source/drivers/mfd/Makefile	2010-12-08 14:05:46.000000000 +0500
@@ -52,6 +52,12 @@

 obj-$(CONFIG_PMIC_DA903X)	+= da903x.o
 max8925-objs			:= max8925-core.o max8925-i2c.o
+
+#ifeq ($(CONFIG_PMIC_DA9052),y)
+da9052-objs			:= da9052-spi.o da9052-i2c.o da9052-core.o
+obj-$(CONFIG_PMIC_DA9052)	+= da9052.o
+#endif
+
 obj-$(CONFIG_MFD_MAX8925)	+= max8925.o

 obj-$(CONFIG_MFD_PCF50633)	+= pcf50633-core.o
diff -Naur A-source/include/linux/mfd/da9052/da9052.h
B-source/include/linux/mfd/da9052/da9052.h
--- A-source/include/linux/mfd/da9052/da9052.h	1970-01-01
05:00:00.000000000 +0500
+++ B-source/include/linux/mfd/da9052/da9052.h	2010-12-08
14:23:40.000000000 +0500
@@ -0,0 +1,198 @@
+/*
+ * da9052 declarations.
+ *
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
+#ifndef __LINUX_MFD_DA9052_DA9052_H
+#define __LINUX_MFD_DA9052_DA9052_H
+
+#include <linux/slab.h>
+#include <linux/mfd/core.h>
+
+#include <linux/mfd/da9052/eh.h>
+#include <linux/mfd/da9052/reg.h>
+#include <linux/mfd/da9052/led.h>
+
+#define SPI 1
+#define I2C 2
+
+#define DA9052_SSC_DEVICE_NAME		"da9052_ssc"
+#define DA9052_EH_DEVICE_NAME		"da9052_eh"
+
+/* Configure the DA9052 IRQ as per the BSP */
+#define DA9052_IRQ	9
+
+/* Module specific error codes */
+#define INVALID_REGISTER		2
+#define INVALID_READ			3
+#define INVALID_PAGE			4
+
+/* Defines for Volatile and Non Volatile register types */
+#define VOLATILE			0
+#define NON_VOLATILE			1
+
+/* Defines for cache state */
+#define VALID				0
+#define INVALID				1
+
+/* Total number of registers in DA9057 */
+#define DA9052_REG_CNT			DA9052_PAGE1_REG_END
+
+/* Maximum number of registers that can be read/written by a singe request */
+#define	MAX_READ_WRITE_CNT		16
+
+#define DA9052_SSC_SPI_DEVICE_NAME		"da9052_ssc_spi"
+#define PAGE_0_START		1
+#define PAGE_0_END		127
+#define PAGE_1_START		128
+#define PAGE_1_END		255
+#define ACTIVE_PAGE_0		0
+#define ACTIVE_PAGE_1		1
+#define PAGECON_0		0
+#define PAGECON_128		128
+#define RW_POL			1
+
+#define DA9052_SSC_I2C_DEVICE_NAME		"da9052_ssc_i2c"
+#define	DA9052_I2C_ADDR				0x90
+#define	DA9052_SSC_I2C_PAGE_WRITE_MODE		0
+#define DA9052_SSC_I2C_REPEAT_WRITE_MODE	1
+#define DA9052_SSC_I2C_WRITE_MODE		DA9052_SSC_I2C_REPEAT_WRITE_MODE
+
+struct da9052_ssc_msg {
+	unsigned char data;
+	unsigned char addr;
+};
+
+struct ssc_cache_entry{
+	 unsigned char val;
+	 unsigned char	type:4;
+	 unsigned char	status:4;
+};
+
+struct da9052_eh_nb{
+	struct list_head nb_list;
+	unsigned char	eve_type;
+	void (*call_back)(struct da9052_eh_nb *, unsigned int);
+};
+
+struct da9052_regulator_init_data {
+	struct regulator_init_data *init_data;
+};
+
+struct da9052_regulator_platform_data {
+	struct regulator_init_data *regulators;
+};
+
+struct da9052_tsi_platform_data {
+	u32 pen_up_interval;
+	u16 tsi_delay_bit_shift;
+	u16 tsi_skip_bit_shift;
+	u16 num_gpio_tsi_register;
+	u16 tsi_supply_voltage;
+	u16 tsi_ref_source;
+	u16 max_tsi_delay;
+	u16 max_tsi_skip_slot;
+};
+
+struct da9052 {
+	struct mutex ssc_lock;
+	struct mutex eve_nb_lock;
+	struct mutex manconv_lock;
+	struct work_struct eh_isr_work;
+	struct ssc_cache_entry	ssc_cache[DA9052_REG_CNT];
+	int (*read) (struct da9052 *da9052, struct da9052_ssc_msg *sscmsg);
+	int (*write) (struct da9052 *da9052, struct da9052_ssc_msg *sscmsg);
+	int (*read_many) (struct da9052 *da9052,
+		struct da9052_ssc_msg *sscmsg, int cnt);
+	int (*write_many)(struct da9052 *da9052,
+		struct da9052_ssc_msg *sscmsg, int cnt);
+	int (*register_event_notifier)(struct da9052 *da9052,
+					struct da9052_eh_nb *nb);
+	int (*unregister_event_notifier)(struct da9052 *da9052,
+					struct da9052_eh_nb *nb);
+	int num_regulators;
+	int connecting_device;
+	struct		spi_device *spi_dev;
+	unsigned int	spi_active_page;
+	unsigned char	rw_pol;
+	unsigned char	*spi_rx_buf;
+	unsigned char	*spi_tx_buf;
+
+	struct i2c_client	*i2c_client;
+	struct device		*dev;
+	struct	i2c_adapter	*adapter;
+	unsigned char		slave_addr;
+};
+
+struct da9052_platform_data {
+	int (*init)(struct da9052 *da9052);
+	int irq_high;
+	int irq_base;
+	int gpio_base;
+	int num_regulators;
+	struct da9052 *da9052;
+	struct regulator_init_data *regulators;
+	struct da9052_leds_platform_data *led_data;
+	struct da9052_tsi_platform_data *tsi_data;
+};
+
+struct da9052_ssc_ops {
+	int (*write)(struct da9052 *da9052, struct da9052_ssc_msg *msg);
+	int (*read)(struct da9052 *da9052, struct da9052_ssc_msg *msg);
+	int (*write_many)(struct da9052 *da9052,
+		struct da9052_ssc_msg *sscmsg, int msg_no);
+	int (*read_many)(struct da9052 *da9052,
+		struct da9052_ssc_msg *sscmsg, int msg_no);
+	int (*device_register)(struct da9052 *da9052);
+	void (*device_unregister)(void);
+};
+
+int da9052_ssc_write(struct da9052 *da9052, struct da9052_ssc_msg *sscmsg);
+int da9052_ssc_read(struct da9052 *da9052, struct da9052_ssc_msg *sscmsg);
+int da9052_ssc_write_many(struct da9052 *da9052,
+			struct da9052_ssc_msg *sscmsg, int cnt);
+int da9052_ssc_read_many(struct da9052 *da9052,
+			struct da9052_ssc_msg *sscmsg, int cnt);
+
+int da9052_spi_write(struct da9052 *da9052, struct da9052_ssc_msg *msg);
+int da9052_spi_read(struct da9052 *da9052, struct da9052_ssc_msg *msg);
+
+int da9052_spi_write_many(struct da9052 *da9052, struct da9052_ssc_msg *sscmsg,
+				int msg_no);
+int da9052_spi_read_many(struct da9052 *da9052, struct da9052_ssc_msg *sscmsg,
+				int msg_no);
+
+void da9052_ssc_exit(struct da9052 *da9052);
+int da9052_ssc_init(struct da9052 *da9052);
+
+/* I2C specific Functions */
+int da9052_i2c_write(struct da9052 *da9052, struct da9052_ssc_msg *msg);
+int da9052_i2c_read(struct da9052 *da9052, struct da9052_ssc_msg *msg);
+int da9052_i2c_write_many(struct da9052 *da9052,
+	struct da9052_ssc_msg *sscmsg, int msg_no);
+int da9052_i2c_read_many(struct da9052 *da9052,
+	struct da9052_ssc_msg *sscmsg, int msg_no);
+
+void da9052_lock(struct da9052 *da9052);
+void da9052_unlock(struct da9052 *da9052);
+int eh_register_nb(struct da9052 *da9052, struct da9052_eh_nb *nb);
+int eh_unregister_nb(struct da9052 *da9052, struct da9052_eh_nb *nb);
+int da9052_manual_read(struct da9052 *da9052,
+			unsigned char channel);
+#endif /* __LINUX_MFD_DA9052_DA9052_H */
diff -Naur A-source/include/linux/mfd/da9052/eh.h
B-source/include/linux/mfd/da9052/eh.h
--- A-source/include/linux/mfd/da9052/eh.h	1970-01-01 05:00:00.000000000 +0500
+++ B-source/include/linux/mfd/da9052/eh.h	2010-12-08 14:28:27.000000000 +0500
@@ -0,0 +1,77 @@
+/*
+ * da9052 Event Handler module declarations.
+ *
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
+#ifndef __LINUX_MFD_DA9052_EH_H
+#define __LINUX_MFD_DA9052_EH_H
+
+#define DA9052_EVE_REGISTERS		4
+#define DA9052_EVE_REGISTER_SIZE	8
+
+/* Define for all possible events */
+#define DCIN_DET_EVE			0
+#define VBUS_DET_EVE			1
+#define DCIN_REM_EVE			2
+#define VBUS_REM_EVE			3
+#define VDD_LOW_EVE			4
+#define ALARM_EVE			5
+#define SEQ_RDY_EVE			6
+#define COMP_1V2			7
+#define ONKEY_EVE			8
+#define ID_FLOAT_EVE			9
+#define ID_GND_EVE			10
+#define CHG_END_EVE			11
+#define TBAT_EVE			12
+#define ADC_EOM_EVE			13
+#define PEN_DOWN_EVE			14
+#define TSI_READY_EVE			15
+#define GPI0_EVE			16
+#define GPI1_EVE			17
+#define GPI2_EVE			18
+#define GPI3_EVE			19
+#define GPI4_EVE			20
+#define GPI5_EVE			21
+#define GPI6_EVE			22
+#define GPI7_EVE			23
+#define GPI8_EVE			24
+#define GPI9_EVE			25
+#define GPI10_EVE			26
+#define GPI11_EVE			27
+#define GPI12_EVE			28
+#define GPI13_EVE			29
+#define GPI14_EVE			30
+#define GPI15_EVE			31
+
+/* Total number of events */
+#define EVE_CNT				(GPI15_EVE+1)
+
+/* Error code for register/unregister functions */
+#define INVALID_NB			2
+#define INVALID_EVE			3
+
+/* State for EH thread */
+#define ACTIVE				0
+#define INACTIVE			1
+
+/* Status of nIRQ line */
+#define IRQ_HIGH			0
+#define IRQ_LOW				1
+
+#endif /* __LINUX_MFD_DA9052_EH_H */
diff -Naur A-source/include/linux/mfd/da9052/reg.h
B-source/include/linux/mfd/da9052/reg.h
--- A-source/include/linux/mfd/da9052/reg.h	1970-01-01 05:00:00.000000000 +0500
+++ B-source/include/linux/mfd/da9052/reg.h	2010-12-08 14:05:46.000000000 +0500
@@ -0,0 +1,922 @@
+/*
+ * da9052 register declarations.
+ *
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
+#ifndef __LINUX_MFD_DA9052_REG_H
+#define __LINUX_MFD_DA9052_REG_H
+
+#define DA9052_PAGECON0_REG			0
+#define DA9052_STATUSA_REG			1
+#define DA9052_STATUSB_REG			2
+#define DA9052_STATUSC_REG			3
+#define DA9052_STATUSD_REG			4
+#define DA9052_EVENTA_REG			5
+#define DA9052_EVENTB_REG			6
+#define DA9052_EVENTC_REG			7
+#define DA9052_EVENTD_REG			8
+#define DA9052_FAULTLOG_REG			9
+#define DA9052_IRQMASKA_REG			10
+#define DA9052_IRQMASKB_REG			11
+#define DA9052_IRQMASKC_REG			12
+#define DA9052_IRQMASKD_REG			13
+#define DA9052_CONTROLA_REG			14
+#define DA9052_CONTROLB_REG			15
+#define DA9052_CONTROLC_REG			16
+#define DA9052_CONTROLD_REG			17
+#define DA9052_PDDIS_REG			18
+#define DA9052_INTERFACE_REG			19
+#define DA9052_RESET_REG			20
+#define DA9052_GPIO0001_REG			21
+#define DA9052_GPIO0203_REG			22
+#define DA9052_GPIO0405_REG			23
+#define DA9052_GPIO0607_REG			24
+#define DA9052_GPIO0809_REG			25
+#define DA9052_GPIO1011_REG			26
+#define DA9052_GPIO1213_REG			27
+#define DA9052_GPIO1415_REG			28
+#define DA9052_ID01_REG				29
+#define DA9052_ID23_REG				30
+#define DA9052_ID45_REG				31
+#define DA9052_ID67_REG				32
+#define DA9052_ID89_REG				33
+#define DA9052_ID1011_REG			34
+#define DA9052_ID1213_REG			35
+#define DA9052_ID1415_REG			36
+#define DA9052_ID1617_REG			37
+#define DA9052_ID1819_REG			38
+#define DA9052_ID2021_REG			39
+#define DA9052_SEQSTATUS_REG			40
+#define DA9052_SEQA_REG				41
+#define DA9052_SEQB_REG				42
+#define DA9052_SEQTIMER_REG			43
+#define DA9052_BUCKA_REG			44
+#define DA9052_BUCKB_REG			45
+#define DA9052_BUCKCORE_REG			46
+#define DA9052_BUCKPRO_REG			47
+#define DA9052_BUCKMEM_REG			48
+#define DA9052_BUCKPERI_REG			49
+#define DA9052_LDO1_REG				50
+#define DA9052_LDO2_REG				51
+#define DA9052_LDO3_REG				52
+#define DA9052_LDO4_REG				53
+#define DA9052_LDO5_REG				54
+#define DA9052_LDO6_REG				55
+#define DA9052_LDO7_REG				56
+#define DA9052_LDO8_REG				57
+#define DA9052_LDO9_REG				58
+#define DA9052_LDO10_REG			59
+#define DA9052_SUPPLY_REG			60
+#define DA9052_PULLDOWN_REG			61
+#define DA9052_CHGBUCK_REG			62
+#define DA9052_WAITCONT_REG			63
+#define DA9052_ISET_REG				64
+#define DA9052_BATCHG_REG			65
+#define DA9052_CHGCONT_REG			66
+#define DA9052_INPUTCONT_REG			67
+#define DA9052_CHGTIME_REG			68
+#define DA9052_BBATCONT_REG			69
+#define DA9052_BOOST_REG			70
+#define DA9052_LEDCONT_REG			71
+#define DA9052_LEDMIN123_REG			72
+#define DA9052_LED1CONF_REG			73
+#define DA9052_LED2CONF_REG			74
+#define DA9052_LED3CONF_REG			75
+#define DA9052_LED1CONT_REG			76
+#define DA9052_LED2CONT_REG			77
+#define DA9052_LED3CONT_REG			78
+#define DA9052_LED4CONT_REG			79
+#define DA9052_LED5CONT_REG			80
+#define DA9052_ADCMAN_REG			81
+#define DA9052_ADCCONT_REG			82
+#define DA9052_ADCRESL_REG			83
+#define DA9052_ADCRESH_REG			84
+#define DA9052_VDDRES_REG			85
+#define DA9052_VDDMON_REG			86
+#define DA9052_ICHGAV_REG			87
+#define DA9052_ICHGTHD_REG			88
+#define DA9052_ICHGEND_REG			89
+#define DA9052_TBATRES_REG			90
+#define DA9052_TBATHIGHP_REG			91
+#define DA9052_TBATHIGHIN_REG			92
+#define DA9052_TBATLOW_REG			93
+#define DA9052_TOFFSET_REG			94
+#define DA9052_ADCIN4RES_REG			95
+#define DA9052_AUTO4HIGH_REG			96
+#define DA9052_AUTO4LOW_REG			97
+#define DA9052_ADCIN5RES_REG			98
+#define DA9052_AUTO5HIGH_REG			99
+#define DA9052_AUTO5LOW_REG			100
+#define DA9052_ADCIN6RES_REG			101
+#define DA9052_AUTO6HIGH_REG			102
+#define DA9052_AUTO6LOW_REG			103
+#define DA9052_TJUNCRES_REG			104
+#define DA9052_TSICONTA_REG			105
+#define DA9052_TSICONTB_REG			106
+#define DA9052_TSIXMSB_REG			107
+#define DA9052_TSIYMSB_REG			108
+#define DA9052_TSILSB_REG			109
+#define DA9052_TSIZMSB_REG			110
+#define DA9052_COUNTS_REG			111
+#define DA9052_COUNTMI_REG			112
+#define DA9052_COUNTH_REG			113
+#define DA9052_COUNTD_REG			114
+#define DA9052_COUNTMO_REG			115
+#define DA9052_COUNTY_REG			116
+#define DA9052_ALARMMI_REG			117
+#define DA9052_ALARMH_REG			118
+#define DA9052_ALARMD_REG			119
+#define DA9052_ALARMMO_REG			120
+#define DA9052_ALARMY_REG			121
+#define DA9052_SECONDA_REG			122
+#define DA9052_SECONDB_REG			123
+#define DA9052_SECONDC_REG			124
+#define DA9052_SECONDD_REG			125
+#define DA9052_PAGECON128_REG			128
+#define DA9052_CHIPID_REG			129
+#define DA9052_CONFIGID_REG			130
+#define DA9052_OTPCONT_REG			131
+#define DA9052_OSCTRIM_REG			132
+#define DA9052_GPID0_REG			133
+#define DA9052_GPID1_REG			134
+#define DA9052_GPID2_REG			135
+#define DA9052_GPID3_REG			136
+#define DA9052_GPID4_REG			137
+#define DA9052_GPID5_REG			138
+#define DA9052_GPID6_REG			139
+#define DA9052_GPID7_REG			140
+#define DA9052_GPID8_REG			141
+#define DA9052_GPID9_REG			142
+
+#define DA9052_PAGE0_REG_START			(DA9052_STATUSA_REG)
+#define DA9052_PAGE0_REG_END			(DA9052_SECONDD_REG)
+
+#define DA9052_PAGE1_REG_START			(DA9052_CHIPID_REG)
+#define DA9052_PAGE1_REG_END			(DA9052_GPID9_REG)
+
+/* PAGE CONFIGURATION */
+
+/* Reg Page Configuration */
+#define DA9052_PAGECON0_REGPAGE			(1<<7)
+
+/* PAGE CONFIGURATION 128 REGISTER */
+#define DA9052_PAGECON128_REGPAGE		(1<<7)
+
+/* SYSTEM REGISTER */
+
+/* STATUS REGISTER A */
+#define DA9052_STATUSA_VDATDET			(1<<7)
+#define DA9052_STATUSA_VBUSSEL			(1<<6)
+#define DA9052_STATUSA_DCINSEL			(1<<5)
+#define DA9052_STATUSA_VBUSDET			(1<<4)
+#define DA9052_STATUSA_DCINDET			(1<<3)
+#define DA9052_STATUSA_IDGND			(1<<2)
+#define DA9052_STATUSA_IDFLOAT			(1<<1)
+#define DA9052_STATUSA_NONKEY			(1<<0)
+
+
+/* STATUS REGISTER B */
+#define DA9052_STATUSB_COMPDET			(1<<7)
+#define DA9052_STATUSB_SEQUENCING		(1<<6)
+#define DA9052_STATUSB_GPFB2			(1<<5)
+#define DA9052_STATUSB_CHGTO			(1<<4)
+#define DA9052_STATUSB_CHGEND			(1<<3)
+#define DA9052_STATUSB_CHGLIM			(1<<2)
+#define DA9052_STATUSB_CHGPRE			(1<<1)
+#define DA9052_STATUSB_CHGATT			(1<<0)
+
+
+/* STATUS REGISTER C */
+#define DA9052_STATUSC_GPI7			(1<<7)
+#define DA9052_STATUSC_GPI6			(1<<6)
+#define DA9052_STATUSC_GPI5			(1<<5)
+#define DA9052_STATUSC_GPI4			(1<<4)
+#define DA9052_STATUSC_GPI3			(1<<3)
+#define DA9052_STATUSC_GPI2			(1<<2)
+#define DA9052_STATUSC_GPI1			(1<<1)
+#define DA9052_STATUSC_GPI0			(1<<0)
+
+
+/* STATUS REGISTER D */
+#define DA9052_STATUSD_GPI15			(1<<7)
+#define DA9052_STATUSD_GPI14			(1<<6)
+#define DA9052_STATUSD_GPI13			(1<<5)
+#define DA9052_STATUSD_GPI12			(1<<4)
+#define DA9052_STATUSD_GPI11			(1<<3)
+#define DA9052_STATUSD_GPI10			(1<<2)
+#define DA9052_STATUSD_GPI9			(1<<1)
+#define DA9052_STATUSD_GPI8			(1<<0)
+
+
+/* EVENT REGISTER A */
+#define DA9052_EVENTA_ECOMP1V2			(1<<7)
+#define DA9052_EVENTA_ESEQRDY			(1<<6)
+#define DA9052_EVENTA_EALRAM			(1<<5)
+#define DA9052_EVENTA_EVDDLOW			(1<<4)
+#define DA9052_EVENTA_EVBUSREM			(1<<3)
+#define DA9052_EVENTA_EDCINREM			(1<<2)
+#define DA9052_EVENTA_EVBUSDET			(1<<1)
+#define DA9052_EVENTA_EDCINDET			(1<<0)
+
+/* EVENT REGISTER B */
+#define DA9052_EVENTB_ETSIREADY			(1<<7)
+#define DA9052_EVENTB_EPENDOWN			(1<<6)
+#define DA9052_EVENTB_EADCEOM			(1<<5)
+#define DA9052_EVENTB_ETBAT			(1<<4)
+#define DA9052_EVENTB_ECHGEND			(1<<3)
+#define DA9052_EVENTB_EIDGND			(1<<2)
+#define DA9052_EVENTB_EIDFLOAT			(1<<1)
+#define DA9052_EVENTB_ENONKEY			(1<<0)
+
+/* EVENT REGISTER C */
+#define DA9052_EVENTC_EGPI7			(1<<7)
+#define DA9052_EVENTC_EGPI6			(1<<6)
+#define DA9052_EVENTC_EGPI5			(1<<5)
+#define DA9052_EVENTC_EGPI4			(1<<4)
+#define DA9052_EVENTC_EGPI3			(1<<3)
+#define DA9052_EVENTC_EGPI2			(1<<2)
+#define DA9052_EVENTC_EGPI1			(1<<1)
+#define DA9052_EVENTC_EGPI0			(1<<0)
+
+/* EVENT REGISTER D */
+#define DA9052_EVENTC_EGPI15			(1<<7)
+#define DA9052_EVENTC_EGPI14			(1<<6)
+#define DA9052_EVENTC_EGPI13			(1<<5)
+#define DA9052_EVENTC_EGPI12			(1<<4)
+#define DA9052_EVENTC_EGPI11			(1<<3)
+#define DA9052_EVENTC_EGPI10			(1<<2)
+#define DA9052_EVENTC_EGPI9			(1<<1)
+#define DA9052_EVENTC_EGPI8			(1<<0)
+
+
+/* FAULT LOG REGISTER */
+#define DA9052_FAULTLOG_WAITSET			(1<<7)
+#define DA9052_FAULTLOG_NSDSET			(1<<6)
+#define DA9052_FAULTLOG_KEYSHUT			(1<<5)
+#define DA9052_FAULTLOG_TEMPOVER		(1<<3)
+#define DA9052_FAULTLOG_VDDSTART		(1<<2)
+#define DA9052_FAULTLOG_VDDFAULT		(1<<1)
+#define DA9052_FAULTLOG_TWDERROR		(1<<0)
+
+/* IRQ_MASK REGISTER A */
+#define DA9052_IRQMASKA_MCOMP1V2		(1<<7)
+#define DA9052_IRQMASKA_MSEQRDY			(1<<6)
+#define DA9052_IRQMASKA_MALRAM			(1<<5)
+#define DA9052_IRQMASKA_MVDDLOW			(1<<4)
+#define DA9052_IRQMASKA_MVBUSREM		(1<<3)
+#define DA9052_IRQMASKA_MDCINREM		(1<<2)
+#define DA9052_IRQMASKA_MVBUSVLD		(1<<1)
+#define DA9052_IRQMASKA_MDCINVLD		(1<<0)
+
+/* IRQ_MASK REGISTER B */
+#define DA9052_IRQMASKB_MTSIREADY		(1<<7)
+#define DA9052_IRQMASKB_MPENDOWN		(1<<6)
+#define DA9052_IRQMASKB_MADCEOM			(1<<5)
+#define DA9052_IRQMASKB_MTBAT			(1<<4)
+#define DA9052_IRQMASKB_MCHGEND			(1<<3)
+#define DA9052_IRQMASKB_MIDGND			(1<<2)
+#define DA9052_IRQMASKB_MIDFLOAT		(1<<1)
+#define DA9052_IRQMASKB_MNONKEY			(1<<0)
+
+/* IRQ_MASK REGISTER C */
+#define DA9052_IRQMASKC_MGPI7			(1<<7)
+#define DA9052_IRQMASKC_MGPI6			(1<<6)
+#define DA9052_IRQMASKC_MGPI5			(1<<5)
+#define DA9052_IRQMASKC_MGPI4			(1<<4)
+#define DA9052_IRQMASKC_MGPI3			(1<<3)
+#define DA9052_IRQMASKC_MGPI2			(1<<2)
+#define DA9052_IRQMASKC_MGPI1			(1<<1)
+#define DA9052_IRQMASKC_MGPI0			(1<<0)
+
+/* IRQ_MASK REGISTER D */
+#define DA9052_IRQMASKD_MGPI15			(1<<7)
+#define DA9052_IRQMASKD_MGPI14			(1<<6)
+#define DA9052_IRQMASKD_MGPI13			(1<<5)
+#define DA9052_IRQMASKD_MGPI12			(1<<4)
+#define DA9052_IRQMASKD_MGPI11			(1<<3)
+#define DA9052_IRQMASKD_MGPI10			(1<<2)
+#define DA9052_IRQMASKD_MGPI9			(1<<1)
+#define DA9052_IRQMASKD_MGPI8			(1<<0)
+
+/* CONTROL REGISTER A */
+#define DA9052_CONTROLA_GPIV			(1<<7)
+#define DA9052_CONTROLA_PMOTYPE			(1<<5)
+#define DA9052_CONTROLA_PMOV			(1<<4)
+#define DA9052_CONTROLA_PMIV			(1<<3)
+#define DA9052_CONTROLA_PMIFV			(1<<3)
+#define DA9052_CONTROLA_PWR1EN			(1<<2)
+#define DA9052_CONTROLA_PWREN			(1<<1)
+#define DA9052_CONTROLA_SYSEN			(1<<0)
+
+/* CONTROL REGISTER B */
+#define DA9052_CONTROLB_SHUTDOWN		(1<<7)
+#define DA9052_CONTROLB_DEEPSLEEP		(1<<6)
+#define DA9052_CONTROLB_WRITEMODE		(1<<5)
+#define DA9052_CONTROLB_BBATEN			(1<<4)
+#define DA9052_CONTROLB_OTPREADEN		(1<<3)
+#define DA9052_CONTROLB_AUTOBOOT		(1<<2)
+#define DA9052_CONTROLB_ACTDIODE		(1<<1)
+#define DA9052_CONTROLB_BUCKMERGE		(1<<0)
+
+/* CONTROL REGISTER C */
+#define DA9052_CONTROLC_BLINKDUR		(1<<7)
+#define DA9052_CONTROLC_BLINKFRQ		(3<<5)
+#define DA9052_CONTROLC_DEBOUNCING		(7<<2)
+#define DA9052_CONTROLC_PMFB2PIN		(1<<1)
+#define DA9052_CONTROLC_PMFB1PIN		(1<<0)
+
+/* CONTROL REGISTER D */
+#define DA9052_CONTROLD_WATCHDOG		(1<<7)
+#define DA9052_CONTROLD_ACCDETEN		(1<<6)
+#define DA9052_CONTROLD_GPI1415SD		(1<<5)
+#define DA9052_CONTROLD_NONKEYSD		(1<<4)
+#define DA9052_CONTROLD_KEEPACTEN		(1<<3)
+#define DA9052_CONTROLD_TWDSCALE		(7<<0)
+
+/* POWER DOWN DISABLE REGISTER */
+#define DA9052_PDDIS_PMCONTPD			(1<<7)
+#define DA9052_PDDIS_OUT32KPD			(1<<6)
+#define DA9052_PDDIS_CHGBBATPD			(1<<5)
+#define DA9052_PDDIS_CHGPD			(1<<4)
+#define DA9052_PDDIS_HS2WIREPD			(1<<3)
+#define DA9052_PDDIS_PMIFPD			(1<<2)
+#define DA9052_PDDIS_GPADCPD			(1<<1)
+#define DA9052_PDDIS_GPIOPD			(1<<0)
+
+/* CONTROL REGISTER D */
+#define DA9052_INTERFACE_IFBASEADDR		(7<<5)
+#define DA9052_INTERFACE_NCSPOL			(1<<4)
+#define DA9052_INTERFACE_RWPOL			(1<<3)
+#define DA9052_INTERFACE_CPHA			(1<<2)
+#define DA9052_INTERFACE_CPOL			(1<<1)
+#define DA9052_INTERFACE_IFTYPE			(1<<0)
+
+/* CONTROL REGISTER D */
+#define DA9052_RESET_RESETEVENT			(3<<6)
+#define DA9052_RESET_RESETTIMER			(63<<0)
+
+/* GPIO REGISTERS */
+
+/* GPIO control register for PIN 0 and 1 */
+#define DA9052_GPIO0001_GPIO1MODE		(1<<7)
+#define DA9052_GPIO0001_GPIO1TYPE		(1<<6)
+#define DA9052_GPIO0001_GPIO1PIN		(3<<4)
+#define DA9052_GPIO0001_GPIO0MODE		(1<<3)
+#define DA9052_GPIO0001_GPIO0TYPE		(1<<2)
+#define DA9052_GPIO0001_GPIO0PIN		(3<<0)
+
+/* GPIO control register for PIN 2 and 3 */
+#define DA9052_GPIO0203_GPIO3MODE		(1<<7)
+#define DA9052_GPIO0203_GPIO3TYPE		(1<<6)
+#define DA9052_GPIO0203_GPIO3PIN		(3<<4)
+#define DA9052_GPIO0203_GPIO2MODE		(1<<3)
+#define DA9052_GPIO0203_GPIO2TYPE		(1<<2)
+#define DA9052_GPIO0203_GPIO2PIN		(3<<0)
+
+/* GPIO control register for PIN 4 and 5 */
+#define DA9052_GPIO0405_GPIO5MODE		(1<<7)
+#define DA9052_GPIO0405_GPIO5TYPE		(1<<6)
+#define DA9052_GPIO0405_GPIO5PIN		(3<<4)
+#define DA9052_GPIO0405_GPIO4MODE		(1<<3)
+#define DA9052_GPIO0405_GPIO4TYPE		(1<<2)
+#define DA9052_GPIO0405_GPIO4PIN		(3<<0)
+
+/* GPIO control register for PIN 6 and 7 */
+#define DA9052_GPIO0607_GPIO7MODE		(1<<7)
+#define DA9052_GPIO0607_GPIO7TYPE		(1<<6)
+#define DA9052_GPIO0607_GPIO7PIN		(3<<4)
+#define DA9052_GPIO0607_GPIO6MODE		(1<<3)
+#define DA9052_GPIO0607_GPIO6TYPE		(1<<2)
+#define DA9052_GPIO0607_GPIO6PIN		(3<<0)
+
+/* GPIO control register for PIN 8 and 9 */
+#define DA9052_GPIO0809_GPIO9MODE		(1<<7)
+#define DA9052_GPIO0809_GPIO9TYPE		(1<<6)
+#define DA9052_GPIO0809_GPIO9PIN		(3<<4)
+#define DA9052_GPIO0809_GPIO8MODE		(1<<3)
+#define DA9052_GPIO0809_GPIO8TYPE		(1<<2)
+#define DA9052_GPIO0809_GPIO8PIN		(3<<0)
+
+/* GPIO control register for PIN 10 and 11 */
+#define DA9052_GPIO1011_GPIO11MODE		(1<<7)
+#define DA9052_GPIO1011_GPIO11TYPE		(1<<6)
+#define DA9052_GPIO1011_GPIO11PIN		(3<<4)
+#define DA9052_GPIO1011_GPIO10MODE		(1<<3)
+#define DA9052_GPIO1011_GPIO10TYPE		(1<<2)
+#define DA9052_GPIO1011_GPIO10PIN		(3<<0)
+
+/* GPIO control register for PIN 12 and 13 */
+#define DA9052_GPIO1213_GPIO13MODE		(1<<7)
+#define DA9052_GPIO1213_GPIO13TYPE		(1<<6)
+#define DA9052_GPIO1213_GPIO13PIN		(3<<4)
+#define DA9052_GPIO1213_GPIO12MODE		(1<<3)
+#define DA9052_GPIO1213_GPIO12TYPE		(1<<2)
+#define DA9052_GPIO1213_GPIO12PIN		(3<<0)
+
+/* GPIO control register for PIN 14 and 15 */
+#define DA9052_GPIO1415_GPIO15MODE		(1<<7)
+#define DA9052_GPIO1415_GPIO15TYPE		(1<<6)
+#define DA9052_GPIO1415_GPIO15PIN		(3<<4)
+#define DA9052_GPIO1415_GPIO14MODE		(1<<3)
+#define DA9052_GPIO1415_GPIO14TYPE		(1<<2)
+#define DA9052_GPIO1415_GPIO14PIN		(3<<0)
+
+/*POWER SEQUENCER REGISTER*/
+
+/* SEQ control register for ID 0 and 1 */
+#define DA9052_ID01_LDO1STEP			(15<<4)
+#define DA9052_ID01_SYSPRE			(1<<2)
+#define DA9052_ID01_DEFSUPPLY			(1<<1)
+#define DA9052_ID01_nRESMODE			(1<<0)
+
+/* SEQ control register for ID 2 and 3 */
+#define DA9052_ID23_LDO3STEP			(15<<4)
+#define DA9052_ID23_LDO2STEP			(15<<0)
+
+/* SEQ control register for ID 4 and 5 */
+#define DA9052_ID45_LDO5STEP			(15<<4)
+#define DA9052_ID45_LDO4STEP			(15<<0)
+
+/* SEQ control register for ID 6 and 7 */
+#define DA9052_ID67_LDO7STEP			(15<<4)
+#define DA9052_ID67_LDO6STEP			(15<<0)
+
+/* SEQ control register for ID 8 and 9 */
+#define DA9052_ID89_LDO9STEP			(15<<4)
+#define DA9052_ID89_LDO8STEP			(15<<0)
+
+/* SEQ control register for ID 10 and 11 */
+#define DA9052_ID1011_PDDISSTEP			(15<<4)
+#define DA9052_ID1011_LDO10STEP			(15<<0)
+
+/* SEQ control register for ID 12 and 13 */
+#define DA9052_ID1213_VMEMSWSTEP		(15<<4)
+#define DA9052_ID1213_VPERISWSTEP		(15<<0)
+
+/* SEQ control register for ID 14 and 15 */
+#define DA9052_ID1415_BUCKPROSTEP		(15<<4)
+#define DA9052_ID1415_BUCKCORESTEP		(15<<0)
+
+/* SEQ control register for ID 16 and 17 */
+#define DA9052_ID1617_BUCKPERISTEP		(15<<4)
+#define DA9052_ID1617_BUCKMEMSTEP		(15<<0)
+
+/* SEQ control register for ID 18 and 19 */
+#define DA9052_ID1819_GPRISE2STEP		(15<<4)
+#define DA9052_ID1819_GPRISE1STEP		(15<<0)
+
+/* SEQ control register for ID 20 and 21 */
+#define DA9052_ID2021_GPFALL2STEP		(15<<4)
+#define DA9052_ID2021_GPFALL1STEP		(15<<0)
+
+/* Power SEQ Status register */
+#define DA9052_SEQSTATUS_SEQPOINTER		(15<<4)
+#define DA9052_SEQSTATUS_WAITSTEP		(15<<0)
+
+/* Power SEQ A register */
+#define DA9052_SEQA_POWEREND			(15<<4)
+#define DA9052_SEQA_SYSTEMEND			(15<<0)
+
+/* Power SEQ B register */
+#define DA9052_SEQB_PARTDOWN			(15<<4)
+#define DA9052_SEQB_MAXCOUNT			(15<<0)
+
+/* Power SEQ TIMER register */
+#define DA9052_SEQTIMER_SEQDUMMY		(15<<4)
+#define DA9052_SEQTIMER_SEQTIME			(15<<0)
+
+/*POWER SUPPLY CONTROL REGISTER*/
+
+/* BUCK REGISTER A */
+#define DA9052_BUCKA_BPROILIM			(3<<6)
+#define DA9052_BUCKA_BPROMODE			(3<<4)
+#define DA9052_BUCKA_BCOREILIM			(3<<2)
+#define DA9052_BUCKA_BCOREMODE			(3<<0)
+
+/* BUCK REGISTER B */
+#define DA9052_BUCKB_BERIILIM			(3<<6)
+#define DA9052_BUCKB_BPERIMODE			(3<<4)
+#define DA9052_BUCKB_BMEMILIM			(3<<2)
+#define DA9052_BUCKB_BMEMMODE			(3<<0)
+
+/* BUCKCORE REGISTER */
+#define DA9052_BUCKCORE_BCORECONF		(1<<7)
+#define DA9052_BUCKCORE_BCOREEN			(1<<6)
+#define DA9052_BUCKCORE_VBCORE			(63<<0)
+
+/* BUCKPRO REGISTER */
+#define DA9052_BUCKPRO_BPROCONF			(1<<7)
+#define DA9052_BUCKPRO_BPROEN			(1<<6)
+#define DA9052_BUCKPRO_VBPRO			(63<<0)
+
+/* BUCKMEM REGISTER */
+#define DA9052_BUCKMEM_BMEMCONF			(1<<7)
+#define DA9052_BUCKMEM_BMEMEN			(1<<6)
+#define DA9052_BUCKMEM_VBMEM			(63<<0)
+
+/* BUCKPERI REGISTER */
+#define DA9052_BUCKPERI_BPERICONF		(1<<7)
+#define DA9052_BUCKPERI_BPERIEN			(1<<6)
+#define DA9052_BUCKPERI_BPERIHS			(1<<5)
+#define DA9052_BUCKPERI_VBPERI			(31<<0)
+
+/* LDO1 REGISTER */
+#define DA9052_LDO1_LDO1CONF			(1<<7)
+#define DA9052_LDO1_LDO1EN			(1<<6)
+#define DA9052_LDO1_VLDO1			(31<<0)
+
+/* LDO2 REGISTER */
+#define DA9052_LDO2_LDO2CONF			(1<<7)
+#define DA9052_LDO2_LDO2EN			(1<<6)
+#define DA9052_LDO2_VLDO2			(63<<0)
+
+/* LDO3 REGISTER */
+#define DA9052_LDO3_LDO3CONF			(1<<7)
+#define DA9052_LDO3_LDO3EN			(1<<6)
+#define DA9052_LDO3_VLDO3			(63<<0)
+
+/* LDO4 REGISTER */
+#define DA9052_LDO4_LDO4CONF			(1<<7)
+#define DA9052_LDO4_LDO4EN			(1<<6)
+#define DA9052_LDO4_VLDO4			(63<<0)
+
+/* LDO5 REGISTER */
+#define DA9052_LDO5_LDO5CONF			(1<<7)
+#define DA9052_LDO5_LDO5EN			(1<<6)
+#define DA9052_LDO5_VLDO5			(63<<0)
+
+/* LDO6 REGISTER */
+#define DA9052_LDO6_LDO6CONF			(1<<7)
+#define DA9052_LDO6_LDO6EN			(1<<6)
+#define DA9052_LDO6_VLDO6			(63<<0)
+
+/* LDO7 REGISTER */
+#define DA9052_LDO7_LDO7CONF			(1<<7)
+#define DA9052_LDO7_LDO7EN			(1<<6)
+#define DA9052_LDO7_VLDO7			(63<<0)
+
+/* LDO8 REGISTER */
+#define DA9052_LDO8_LDO8CONF			(1<<7)
+#define DA9052_LDO8_LDO8EN			(1<<6)
+#define DA9052_LDO8_VLDO8			(63<<0)
+
+/* LDO9 REGISTER */
+#define DA9052_LDO9_LDO9CONF			(1<<7)
+#define DA9052_LDO9_LDO9EN			(1<<6)
+#define DA9052_LDO9_VLDO9			(63<<0)
+
+/* LDO10 REGISTER */
+#define DA9052_LDO10_LDO10CONF			(1<<7)
+#define DA9052_LDO10_LDO10EN			(1<<6)
+#define DA9052_LDO10_VLDO10			(63<<0)
+
+/* SUPPLY REGISTER */
+#define DA9052_SUPPLY_VLOCK			(1<<7)
+#define DA9052_SUPPLY_VMEMSWEN			(1<<6)
+#define DA9052_SUPPLY_VPERISWEN			(1<<5)
+#define DA9052_SUPPLY_VLDO3GO			(1<<4)
+#define DA9052_SUPPLY_VLDO2GO			(1<<3)
+#define DA9052_SUPPLY_VBMEMGO			(1<<2)
+#define DA9052_SUPPLY_VBPROGO			(1<<1)
+#define DA9052_SUPPLY_VBCOREGO			(1<<0)
+
+/* PULLDOWN REGISTER */
+#define DA9052_PULLDOWN_LDO5PDDIS		(1<<5)
+#define DA9052_PULLDOWN_LDO2PDDIS		(1<<4)
+#define DA9052_PULLDOWN_LDO1PDDIS		(1<<3)
+#define DA9052_PULLDOWN_MEMPDDIS		(1<<2)
+#define DA9052_PULLDOWN_PROPDDIS		(1<<1)
+#define DA9052_PULLDOWN_COREPDDIS		(1<<0)
+
+/* BAT CHARGER REGISTER */
+
+/* CHARGER BUCK REGISTER */
+#define DA9052_CHGBUCK_CHGTEMP			(1<<7)
+#define DA9052_CHGBUCK_CHGUSBILIM		(1<<6)
+#define DA9052_CHGBUCK_CHGBUCKLP		(1<<5)
+#define DA9052_CHGBUCK_CHGBUCKEN		(1<<4)
+#define DA9052_CHGBUCK_ISETBUCK			(15<<0)
+
+/* WAIT COUNTER REGISTER */
+#define DA9052_WAITCONT_WAITDIR			(1<<7)
+#define DA9052_WAITCONT_RTCCLOCK		(1<<6)
+#define DA9052_WAITCONT_WAITMODE		(1<<5)
+#define DA9052_WAITCONT_EN32KOUT		(1<<4)
+#define DA9052_WAITCONT_DELAYTIME		(15<<0)
+
+/* ISET CONTROL REGISTER */
+#define DA9052_ISET_ISETDCIN			(15<<4)
+#define DA9052_ISET_ISETVBUS			(15<<0)
+
+/* BATTERY CHARGER CONTROL REGISTER */
+#define DA9052_BATCHG_ICHGPRE			(3<<6)
+#define DA9052_BATCHG_ICHGBAT			(63<<0)
+
+/* CHARGER COUNTER REGISTER */
+#define DA9052_CHGCONT_VCHGBAT			(31<<3)
+#define DA9052_CHGCONT_TCTR			(7<<0)
+
+/* INPUT CONTROL REGISTER */
+#define DA9052_INPUTCONT_TCTRMODE		(1<<7)
+#define DA9052_INPUTCONT_ICHGLOW		(1<<5)
+#define DA9052_INPUTCONT_VBUSSUSP		(1<<4)
+#define DA9052_INPUTCONT_DCINSUSP		(1<<3)
+#define DA9052_INPUTCONT_VCHGTHR		(7<<0)
+
+/* CHARGING TIME REGISTER */
+#define DA9052_CHGTIME_CHGTIME			(255<<0)
+
+/* BACKUP BATTERY CONTROL REGISTER */
+#define DA9052_BBATCONT_BCHARGERISET		(15<<4)
+#define DA9052_BBATCONT_BCHARGERVSET		(15<<0)
+
+/* LED REGISTERS */
+
+/* LED BOOST REGISTER */
+#define DA9052_BOOST_EBFAULT			(1<<7)
+#define DA9052_BOOST_MBFAULT			(1<<6)
+#define DA9052_BOOST_BOOSTFRQ			(1<<5)
+#define DA9052_BOOST_BOOSTILIM			(1<<4)
+#define DA9052_BOOST_LED3INEN			(1<<3)
+#define DA9052_BOOST_LED2INEN			(1<<2)
+#define DA9052_BOOST_LED1INEN			(1<<1)
+#define DA9052_BOOST_BOOSTEN			(1<<0)
+
+/* LED COUNT REGISTER */
+#define DA9052_LEDCONT_LED3ICONT		(1<<6)
+#define DA9052_LEDCONT_LED3RAMP			(1<<5)
+#define DA9052_LEDCONT_LED3EN			(1<<4)
+#define DA9052_LEDCONT_LED2RAMP			(1<<3)
+#define DA9052_LEDCONT_LED2EN			(1<<2)
+#define DA9052_LEDCONT_LED1RAMP			(1<<1)
+#define DA9052_LEDCONT_LED1EN			(1<<0)
+
+/* LEDMIN123  REGISTER */
+#define DA9052_LEDMIN123_LEDMINCURRENT		(255<<0)
+
+/* LED1CONF  REGISTER */
+#define DA9052_LED1CONF_LED1CURRENT		(255<<0)
+
+/* LED2CONF  REGISTER */
+#define DA9052_LED2CONF_LED2CURRENT		(255<<0)
+
+/* LED3CONF  REGISTER */
+#define DA9052_LED3CONF_LED3CURRENT		(255<<0)
+
+/* LED1 COUNT  REGISTER */
+#define DA9052_LED1CONT_LED1DIM			(1<<7)
+#define DA9052_LED1CONT_LED1PWM			(127<<0)
+
+/* LED2 COUNT  REGISTER */
+#define DA9052_LED2CONT_LED2DIM			(1<<7)
+#define DA9052_LED2CONT_LED2PWM			(127<<0)
+
+/* LED3 COUNT  REGISTER */
+#define DA9052_LED3CONT_LED3DIM			(1<<7)
+#define DA9052_LED3CONT_LED3PWM			(127<<0)
+
+/* LED4 COUNT  REGISTER */
+#define DA9052_LED4CONT_LED4DIM			(1<<7)
+#define DA9052_LED4CONT_LED4PWM			(127<<0)
+
+/* LED5 COUNT  REGISTER */
+#define DA9052_LED5CONT_LED5DIM			(1<<7)
+#define DA9052_LED5CONT_LED5PWM			(127<<0)
+
+/* ADC REGISTERS */
+
+/* ADC MAN registers */
+#define DA9052_ADCMAN_MANCONV			(1<<4)
+#define DA9052_ADCMAN_MUXSEL			(15<<0)
+
+/* ADC COUNT regsisters */
+#define DA9052_ADCCONT_COMP1V2EN		(1<<7)
+#define DA9052_ADCCONT_ADCMODE			(1<<6)
+#define DA9052_ADCCONT_TBATISRCEN		(1<<5)
+#define DA9052_ADCCONT_AD4ISRCEN		(1<<4)
+#define DA9052_ADCCONT_AUTOAD6EN		(1<<3)
+#define DA9052_ADCCONT_AUTOAD5EN		(1<<2)
+#define DA9052_ADCCONT_AUTOAD4EN		(1<<1)
+#define DA9052_ADCCONT_AUTOVDDEN		(1<<0)
+
+/* ADC 10 BIT MANUAL CONVERSION RESULT LOW register */
+#define DA9052_ADCRESL_ADCRESLSB		(3<<0)
+
+/* ADC 10 BIT MANUAL CONVERSION RESULT HIGH register */
+#define DA9052_ADCRESH_ADCRESMSB		(255<<0)
+
+/* VDD RES regsister*/
+#define DA9052_VDDRES_VDDOUTRES			(255<<0)
+
+/* VDD MON regsister*/
+#define DA9052_VDDMON_VDDOUTMON			(255<<0)
+
+/* ICHG_AV regsister*/
+#define DA9052_ICHGAV_ICHGAV			(255<<0)
+
+/* ICHG_THD regsister*/
+#define DA9052_ICHGTHD_ICHGTHD			(255<<0)
+
+/* ICHG_END regsister*/
+#define DA9052_ICHGEND_ICHGEND			(255<<0)
+
+/* TBAT_RES regsister*/
+#define DA9052_TBATRES_TBATRES			(255<<0)
+
+/* TBAT_HIGHP regsister*/
+#define DA9052_TBATHIGHP_TBATHIGHP		(255<<0)
+
+/* TBAT_HIGHN regsister*/
+#define DA9052_TBATHIGHN_TBATHIGHN		(255<<0)
+
+/* TBAT_LOW regsister*/
+#define DA9052_TBATLOW_TBATLOW			(255<<0)
+
+/* T_OFFSET regsister*/
+#define DA9052_TOFFSET_TOFFSET			(255<<0)
+
+/* ADCIN4_RES regsister*/
+#define DA9052_ADCIN4RES_ADCIN4RES		(255<<0)
+
+/* ADCIN4_HIGH regsister*/
+#define DA9052_AUTO4HIGH_AUTO4HIGH		(255<<0)
+
+/* ADCIN4_LOW regsister*/
+#define DA9052_AUTO4LOW_AUTO4LOW		(255<<0)
+
+/* ADCIN5_RES regsister*/
+#define DA9052_ADCIN5RES_ADCIN5RES		(255<<0)
+
+/* ADCIN5_HIGH regsister*/
+#define DA9052_AUTO5HIGH_AUTOHIGH		(255<<0)
+
+/* ADCIN5_LOW regsister*/
+#define DA9052_AUTO5LOW_AUTO5LOW		(255<<0)
+
+/* ADCIN6_RES regsister*/
+#define DA9052_ADCIN6RES_ADCIN6RES		(255<<0)
+
+/* ADCIN6_HIGH regsister*/
+#define DA9052_AUTO6HIGH_AUTO6HIGH		(255<<0)
+
+/* ADCIN6_LOW regsister*/
+#define DA9052_AUTO6LOW_AUTO6LOW		(255<<0)
+
+/* TJUNC_RES regsister*/
+#define DA9052_TJUNCRES_TJUNCRES		(255<<0)
+
+/* TSI REGISTER */
+
+/* TSI Control Register A */
+#define DA9052_TSICONTA_TSIDELAY		(3<<6)
+#define DA9052_TSICONTA_TSISKIP			(7<<3)
+#define DA9052_TSICONTA_TSIMODE			(1<<2)
+#define DA9052_TSICONTA_PENDETEN		(1<<1)
+#define DA9052_TSICONTA_AUTOTSIEN		(1<<0)
+
+/* TSI Control Register B */
+#define DA9052_TSICONTB_ADCREF			(1<<7)
+#define DA9052_TSICONTB_TSIMAN			(1<<6)
+#define DA9052_TSICONTB_TSIMUX			(3<<4)
+#define DA9052_TSICONTB_TSISEL3			(1<<3)
+#define DA9052_TSICONTB_TSISEL2			(1<<2)
+#define DA9052_TSICONTB_TSISEL1			(1<<1)
+#define DA9052_TSICONTB_TSISEL0			(1<<0)
+
+/* TSI X Co-ordinate MSB Result register */
+#define DA9052_TSIXMSB_TSIXM			(255<<0)
+
+/* TSI Y Co-ordinate MSB Result register */
+#define DA9052_TSIYMSB_TSIYM			(255<<0)
+
+/* TSI Co-ordinate LSB Result register */
+#define DA9052_TSILSB_PENDOWN			(1<<6)
+#define DA9052_TSILSB_TSIZL			(3<<4)
+#define DA9052_TSILSB_TSIYL			(3<<2)
+#define DA9052_TSILSB_TSIXL			(3<<0)
+
+/* TSI Z Measurement MSB Result register */
+#define DA9052_TSIZMSB_TSIZM			(255<<0)
+
+/* RTC REGISTER */
+
+/* RTC TIMER SECONDS REGISTER */
+#define DA9052_COUNTS_MONITOR			(1<<6)
+#define DA9052_COUNTS_COUNTSEC			(63<<0)
+
+/* RTC TIMER MINUTES REGISTER */
+#define DA9052_COUNTMI_COUNTMIN			(63<<0)
+
+/* RTC TIMER HOUR REGISTER */
+#define DA9052_COUNTH_COUNTHOUR			(31<<0)
+
+/* RTC TIMER DAYS REGISTER */
+#define DA9052_COUNTD_COUNTDAY			(31<<0)
+
+/* RTC TIMER MONTHS REGISTER */
+#define DA9052_COUNTMO_COUNTMONTH		(15<<0)
+
+/* RTC TIMER YEARS REGISTER */
+#define DA9052_COUNTY_COUNTYEAR			(63<<0)
+
+/* RTC ALARM MINUTES REGISTER */
+#define DA9052_ALARMMI_TICKTYPE			(1<<7)
+#define DA9052_ALARMMI_ALARMTYPE		(1<<6)
+#define DA9052_ALARMMI_ALARMMIN			(63<<0)
+
+/* RTC ALARM HOURS REGISTER */
+#define DA9052_ALARMH_ALARMHOUR			(31<<0)
+
+/* RTC ALARM DAYS REGISTER */
+#define DA9052_ALARMD_ALARMDAY			(31<<0)
+
+/* RTC ALARM MONTHS REGISTER */
+#define DA9052_ALARMMO_ALARMMONTH		(15<<0)
+
+/* RTC ALARM YEARS REGISTER */
+#define DA9052_ALARMY_TICKON			(1<<7)
+#define DA9052_ALARMY_ALARMON			(1<<6)
+#define DA9052_ALARMY_ALARMYEAR			(63<<0)
+
+/* RTC SECONDS REGISTER  A*/
+#define DA9052_SECONDA_SECONDSA			(255<<0)
+
+/* RTC SECONDS REGISTER  B*/
+#define DA9052_SECONDB_SECONDSB			(255<<0)
+
+/* RTC SECONDS REGISTER  C*/
+#define DA9052_SECONDC_SECONDSC			(255<<0)
+
+/* RTC SECONDS REGISTER  D*/
+#define DA9052_SECONDD_SECONDSD			(255<<0)
+
+/* OTP REGISTER */
+
+/* CHIP IDENTIFICATION REGISTER */
+#define DA9052_CHIPID_MRC			(15<<4)
+#define DA9052_CHIPID_TRC			(15<<0)
+
+/* CONFIGURATION IDENTIFICATION REGISTER */
+#define DA9052_CONFIGID_CUSTOMERID		(31<<3)
+#define DA9052_CONFIGID_CONFID			(7<<0)
+
+/* OTP CONTROL REGISTER */
+#define DA9052_OTPCONT_GPWRITEDIS		(1<<7)
+#define DA9052_OTPCONT_OTPCONFLOCK		(1<<6)
+#define DA9052_OTPCONT_OTPGPLOCK		(1<<5)
+#define DA9052_OTPCONT_OTPCONFG			(1<<3)
+#define DA9052_OTPCONT_OTPGP			(1<<2)
+#define DA9052_OTPCONT_OTPRP			(1<<1)
+#define DA9052_OTPCONT_OTPTRANSFER		(1<<0)
+
+/* RTC OSCILLATOR TRIM REGISTER */
+#define DA9052_OSCTRIM_TRIM32K			(255<<0)
+
+/* GP ID REGISTER 0 */
+#define DA9052_GPID0_GP0			(255<<0)
+
+/* GP ID REGISTER 1 */
+#define DA9052_GPID1_GP1			(255<<0)
+
+/* GP ID REGISTER 2 */
+#define DA9052_GPID2_GP2			(255<<0)
+
+/* GP ID REGISTER 3 */
+#define DA9052_GPID3_GP3			(255<<0)
+
+/* GP ID REGISTER 4 */
+#define DA9052_GPID4_GP4			(255<<0)
+
+/* GP ID REGISTER 5 */
+#define DA9052_GPID5_GP5			(255<<0)
+
+/* GP ID REGISTER 6 */
+#define DA9052_GPID6_GP6			(255<<0)
+
+/* GP ID REGISTER 7 */
+#define DA9052_GPID7_GP7			(255<<0)
+
+/* GP ID REGISTER 8 */
+#define DA9052_GPID8_GP8			(255<<0)
+
+/* GP ID REGISTER 9 */
+#define DA9052_GPID9_GP9			(255<<0)
+
+#endif
+/* __LINUX_MFD_DA9052_REG_H */
