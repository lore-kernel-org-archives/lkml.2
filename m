Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762056Ab0HFUdQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 16:33:16 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:40022 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762015Ab0HFUdN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 16:33:13 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6066"; a="50028009"
From: Neil Leeder <nleeder@codeaurora.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Neil Leeder <nleeder@codeaurora.org>,
        Horace Fu <horace.fu@quantatw.com>,
        Mandeep Singh Baines <msb@chromium.org>
Subject: [PATCH 1/1] mouse: add qci touchpad driver
Date: Fri,  6 Aug 2010 13:32:56 -0700
Message-Id: <1281126776-20014-1-git-send-email-nleeder@codeaurora.org>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver is for the QCI trackpad used on Quanta smartbooks

Review URL: http://codereview.chromium.org/724001

Signed-off-by: Horace Fu <horace.fu@quantatw.com>
Signed-off-by: Mandeep Singh Baines <msb@chromium.org>
[nleeder@codeaurora.org: cleanup i2c calls, address review comments etc]
Signed-off-by: Neil Leeder <nleeder@codeaurora.org>
---
 drivers/input/mouse/Kconfig        |   12 ++
 drivers/input/mouse/Makefile       |    1 +
 drivers/input/mouse/qci_touchpad.c |  313 ++++++++++++++++++++++++++++++++++++
 include/linux/input/qci_touchpad.h |   25 +++
 4 files changed, 351 insertions(+), 0 deletions(-)
 create mode 100644 drivers/input/mouse/qci_touchpad.c
 create mode 100644 include/linux/input/qci_touchpad.h

diff --git a/drivers/input/mouse/Kconfig b/drivers/input/mouse/Kconfig
index 3feeb3a..320db55 100644
--- a/drivers/input/mouse/Kconfig
+++ b/drivers/input/mouse/Kconfig
@@ -303,6 +303,18 @@ config MOUSE_MAPLE
 	  To compile this driver as a module choose M here: the module will be
 	  called maplemouse.
 
+config MOUSE_QCITP
+	tristate "Quanta Computer Inc. Touchpad"
+	depends on I2C
+	help
+	  This driver supports the touchpad on Quanta smartbook devices.
+
+	  Say Y here if you have a Quanta-based smartboot or notepad
+	  device and want to use the Quanta touchpad driver.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called qci_touchpad.
+
 config MOUSE_SYNAPTICS_I2C
 	tristate "Synaptics I2C Touchpad support"
 	depends on I2C
diff --git a/drivers/input/mouse/Makefile b/drivers/input/mouse/Makefile
index 570c84a..6eda35d 100644
--- a/drivers/input/mouse/Makefile
+++ b/drivers/input/mouse/Makefile
@@ -15,6 +15,7 @@ obj-$(CONFIG_MOUSE_MAPLE)		+= maplemouse.o
 obj-$(CONFIG_MOUSE_PC110PAD)		+= pc110pad.o
 obj-$(CONFIG_MOUSE_PS2)			+= psmouse.o
 obj-$(CONFIG_MOUSE_PXA930_TRKBALL)	+= pxa930_trkball.o
+obj-$(CONFIG_MOUSE_QCITP)		+= qci_touchpad.o
 obj-$(CONFIG_MOUSE_RISCPC)		+= rpcmouse.o
 obj-$(CONFIG_MOUSE_SERIAL)		+= sermouse.o
 obj-$(CONFIG_MOUSE_SYNAPTICS_I2C)	+= synaptics_i2c.o
diff --git a/drivers/input/mouse/qci_touchpad.c b/drivers/input/mouse/qci_touchpad.c
new file mode 100644
index 0000000..6865950
--- /dev/null
+++ b/drivers/input/mouse/qci_touchpad.c
@@ -0,0 +1,313 @@
+/* Quanta I2C Touchpad Driver
+ *
+ * Copyright (C) 2009 Quanta Computer Inc.
+ * Copyright (c) 2010, Code Aurora Forum. All rights reserved.
+ * Author: Hsin Wu <hsin.wu@quantatw.com>
+ * Author: Austin Lai <austin.lai@quantatw.com>
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+/*
+ * Driver communicates over i2c to nuvoTon WPCE775x Embedded Controller,
+ * which has touchpad attached through PS/2 interface.
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/i2c.h>
+#include <linux/interrupt.h>
+#include <linux/input.h>
+#include <linux/gpio.h>
+#include <linux/delay.h>
+#include <linux/input/qci_touchpad.h>
+
+#define TOUCHPAD_ID_NAME          "qci-i2cpad"
+#define TOUCHPAD_NAME             "QCI Touchpad"
+#define TOUCHPAD_DEVICE           "/qci_touchpad/input0"
+#define TOUCHPAD_CMD_ENABLE       0xF4
+#define TOUCHPAD_READ_DATA_LEN    3
+
+struct i2ctpad_drv_data {
+	struct i2c_client *ti2c_client;
+	struct input_dev *qcitp_dev;
+	unsigned int qcitp_gpio;
+	unsigned int qcitp_irq;
+	char ecdata[8];
+	bool opened;
+};
+
+static int tp_sense_val = 10;
+
+static ssize_t tp_sensitive_show(struct kobject *kobj,
+	struct kobj_attribute *attr, char * buf)
+{
+	return sprintf(buf, "%d\n", tp_sense_val);
+}
+
+static ssize_t tp_sensitive_store(struct kobject *kobj,
+	struct kobj_attribute *attr, const char* buf, size_t n)
+{
+	unsigned int val = 0;
+	sscanf(buf, "%d", &val);
+
+	if (val >= 1 && val <= 10)
+		tp_sense_val = val;
+	else
+		return  -ENOSYS;
+
+	return n;
+}
+
+static struct kobj_attribute tp_sensitivity = __ATTR(tp_sensitivity,
+						     0644,
+						     tp_sensitive_show,
+						     tp_sensitive_store);
+
+static struct attribute *g_tp[] = {
+	&tp_sensitivity.attr,
+	NULL,
+};
+
+static struct attribute_group attr_group = {
+	.attrs = g_tp,
+};
+
+#ifdef CONFIG_PM
+static int qcitp_suspend(struct device *_dev)
+{
+	struct i2c_client *client =
+		container_of(_dev, struct i2c_client, dev);
+	struct i2ctpad_drv_data *context = i2c_get_clientdata(client);
+
+	disable_irq(context->qcitp_irq);
+	return 0;
+}
+
+static int qcitp_resume(struct device *_dev)
+{
+	struct i2c_client *client =
+		container_of(_dev, struct i2c_client, dev);
+	struct i2ctpad_drv_data *context = i2c_get_clientdata(client);
+
+	enable_irq(context->qcitp_irq);
+	return 0;
+}
+#endif
+
+static const struct i2c_device_id qcitp_idtable[] = {
+	{ TOUCHPAD_ID_NAME, 0 },
+	{ }
+};
+
+MODULE_DEVICE_TABLE(i2c, qcitp_idtable);
+
+#ifdef CONFIG_PM
+static const struct dev_pm_ops qcitp_pm_ops = {
+	.suspend  = qcitp_suspend,
+	.resume   = qcitp_resume,
+};
+#endif
+
+static void qcitp_report_key(struct input_dev *tpad_dev, char *ec_data)
+{
+	int dx = 0;
+	int dy = 0;
+
+	if (ec_data[1])
+		dx = (int) ec_data[1] -
+		     (int) ((ec_data[0] << 4) & 0x100);
+
+	if (ec_data[2])
+		dy = (int) ((ec_data[0] << 3) & 0x100) -
+		     (int) ec_data[2];
+
+	dx = (dx * tp_sense_val)/10;
+	dy = (dy * tp_sense_val)/10;
+
+	input_report_key(tpad_dev, BTN_LEFT, ec_data[0] & 0x01);
+	input_report_key(tpad_dev, BTN_RIGHT, ec_data[0] & 0x02);
+	input_report_key(tpad_dev, BTN_MIDDLE, ec_data[0] & 0x04);
+	input_report_rel(tpad_dev, REL_X, dx);
+	input_report_rel(tpad_dev, REL_Y, dy);
+	input_sync(tpad_dev);
+}
+
+static irqreturn_t qcitp_interrupt(int irq, void *dev_id)
+{
+	struct i2ctpad_drv_data *context = dev_id;
+	int rc;
+
+	rc = i2c_master_recv(context->ti2c_client, context->ecdata,
+			     TOUCHPAD_READ_DATA_LEN);
+	if (rc == TOUCHPAD_READ_DATA_LEN)
+		qcitp_report_key(context->qcitp_dev, context->ecdata);
+
+	return IRQ_HANDLED;
+}
+
+static int qcitp_open(struct input_dev *input)
+{
+	struct i2ctpad_drv_data *context = input_get_drvdata(input);
+	u8 buf[1];
+	int err = 0;
+
+	if (context->opened)
+		return 0;
+	context->opened = 1;
+
+	buf[0] = TOUCHPAD_CMD_ENABLE;
+	err = i2c_master_send(context->ti2c_client, buf, 1);
+	if (err < 0)
+		goto i2c_fail;
+	msleep(100);
+	err = i2c_master_recv(context->ti2c_client, buf, 1);
+
+i2c_fail:
+	return err;
+}
+
+static int __devinit qcitp_probe(struct i2c_client *client,
+				    const struct i2c_device_id *id)
+{
+	int err;
+	struct i2ctpad_drv_data *context;
+	struct qci_touchpad_platform_data *pd;
+	int irq_trigger_type;
+
+	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C)) {
+		pr_err("[QCI TouchPad] i2c functionality failed\n");
+		return -ENODEV;
+	}
+
+	context = kzalloc(sizeof(struct i2ctpad_drv_data), GFP_KERNEL);
+	if (!context)
+		return -ENOMEM;
+	i2c_set_clientdata(client, context);
+	context->ti2c_client = client;
+	context->qcitp_gpio = client->irq;
+
+	pd = client->dev.platform_data;
+	if (pd)
+		irq_trigger_type = pd->irq_trigger_type;
+	else
+		irq_trigger_type = IRQF_TRIGGER_FALLING;
+
+	context->qcitp_dev = input_allocate_device();
+	if (!context->qcitp_dev) {
+		pr_err("[QCI TouchPad] allocating memory failed\n");
+		err = -ENOMEM;
+		goto allocate_fail;
+	}
+	context->qcitp_dev->name       = TOUCHPAD_NAME;
+	context->qcitp_dev->phys       = TOUCHPAD_DEVICE;
+	context->qcitp_dev->id.bustype = BUS_I2C;
+	context->qcitp_dev->id.vendor  = 0x1050;
+	context->qcitp_dev->id.product = 0x1;
+	context->qcitp_dev->id.version = 0x1;
+	context->qcitp_dev->evbit[0]  = BIT_MASK(EV_KEY) |
+					BIT_MASK(EV_REL);
+	context->qcitp_dev->relbit[0] = BIT_MASK(REL_X) |
+					BIT_MASK(REL_Y);
+	context->qcitp_dev->keybit[BIT_WORD(BTN_LEFT)] = BIT_MASK(BTN_LEFT) |
+							 BIT_MASK(BTN_MIDDLE) |
+							 BIT_MASK(BTN_RIGHT);
+
+	input_set_drvdata(context->qcitp_dev, context);
+	context->qcitp_dev->open = qcitp_open;
+	err = input_register_device(context->qcitp_dev);
+	if (err) {
+		pr_err("[QCI TouchPad] register device failed\n");
+		goto register_fail;
+	}
+
+	err = gpio_request(context->qcitp_gpio, "qci-pad");
+	if (err) {
+		pr_err("[QCI TouchPad] gpio request failed\n");
+		goto gpio_request_fail;
+	}
+
+	context->qcitp_irq = gpio_to_irq(context->qcitp_gpio);
+	err = request_threaded_irq(context->qcitp_irq, NULL, qcitp_interrupt,
+				   irq_trigger_type, client->name, context);
+	if (err) {
+		pr_err("[QCI TouchPad] request irq failed\n");
+		goto request_irq_fail;
+	}
+
+	err = sysfs_create_group(&client->dev.kobj, &attr_group);
+	if (err)
+		pr_warning("[QCI TouchPad] sysfs create failed\n");
+
+	return 0;
+
+request_irq_fail:
+	gpio_free(context->qcitp_gpio);
+
+gpio_request_fail:
+	input_unregister_device(context->qcitp_dev);
+	context->qcitp_dev = NULL;
+
+register_fail:
+	input_free_device(context->qcitp_dev);
+
+allocate_fail:
+	i2c_set_clientdata(client, NULL);
+	kfree(context);
+	return err;
+}
+
+static int __devexit qcitp_remove(struct i2c_client *client)
+{
+	struct i2ctpad_drv_data *context = i2c_get_clientdata(client);
+
+	free_irq(context->qcitp_irq, context);
+	gpio_free(context->qcitp_gpio);
+	input_unregister_device(context->qcitp_dev);
+	i2c_set_clientdata(client, NULL);
+	kfree(context);
+
+	return 0;
+}
+
+static struct i2c_driver i2ctp_driver = {
+	.driver = {
+		.owner = THIS_MODULE,
+		.name  = TOUCHPAD_ID_NAME,
+#ifdef CONFIG_PM
+		.pm = &qcitp_pm_ops,
+#endif
+	},
+	.probe	  = qcitp_probe,
+	.remove	  = __devexit_p(qcitp_remove),
+	.id_table = qcitp_idtable,
+};
+
+static int __init qcitp_init(void)
+{
+	return i2c_add_driver(&i2ctp_driver);
+}
+
+
+static void __exit qcitp_exit(void)
+{
+	i2c_del_driver(&i2ctp_driver);
+}
+
+module_init(qcitp_init);
+module_exit(qcitp_exit);
+
+MODULE_AUTHOR("Quanta Computer Inc.");
+MODULE_DESCRIPTION("Quanta Embedded Controller I2C Touchpad Driver");
+MODULE_ALIAS("platform:qci-touchpad");
+MODULE_LICENSE("GPL v2");
diff --git a/include/linux/input/qci_touchpad.h b/include/linux/input/qci_touchpad.h
new file mode 100644
index 0000000..8e266e4
--- /dev/null
+++ b/include/linux/input/qci_touchpad.h
@@ -0,0 +1,25 @@
+/* Copyright (c) 2010, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ */
+
+#ifndef __QCI_TOUCHPAD_H
+#define __QCI_TOUCHPAD_H
+
+struct qci_touchpad_platform_data {
+	unsigned long irq_trigger_type;
+};
+
+#endif
-- 
1.7.1
--
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

