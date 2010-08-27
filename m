Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753532Ab0H0WTP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 18:19:15 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:17038 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753317Ab0H0WTO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 18:19:14 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6087"; a="52378129"
From: Neil Leeder <nleeder@codeaurora.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Hsin.Wu@quantatw.com,
        Neil Leeder <nleeder@codeaurora.org>,
        Horace Fu <horace.fu@quantatw.com>
Subject: [PATCH 1/1] input: keyboard: add qci keyboard driver
Date: Fri, 27 Aug 2010 15:18:37 -0700
Message-Id: <1282947517-32118-1-git-send-email-nleeder@codeaurora.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <4C7838DD.1020004@codeaurora.org>
References: <4C7838DD.1020004@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver is for the QCI i2c keyboard used on Quanta smartbooks.

Signed-off-by: Horace Fu <horace.fu@quantatw.com>
[nleeder@codeaurora.org: cleanup to latest kernel standards]
Signed-off-by: Neil Leeder <nleeder@codeaurora.org>
---
 drivers/input/keyboard/Kconfig     |   12 ++
 drivers/input/keyboard/Makefile    |    1 +
 drivers/input/keyboard/qci_gkbd.c  |  258 ++++++++++++++++++++++++++++++++++++
 include/linux/input/qci_keyboard.h |   25 ++++
 4 files changed, 296 insertions(+), 0 deletions(-)
 create mode 100644 drivers/input/keyboard/qci_gkbd.c
 create mode 100644 include/linux/input/qci_keyboard.h

diff --git a/drivers/input/keyboard/Kconfig b/drivers/input/keyboard/Kconfig
index 1ba2514..e610755 100644
--- a/drivers/input/keyboard/Kconfig
+++ b/drivers/input/keyboard/Kconfig
@@ -342,6 +342,18 @@ config KEYBOARD_PXA930_ROTARY
 	  To compile this driver as a module, choose M here: the
 	  module will be called pxa930_rotary.
 
+config KEYBOARD_QCIGKBD
+	tristate "Quanta Computer Inc. keyboard"
+	depends on I2C
+	help
+	  This driver supports the i2c keyboard on Quanta smartbook devices.
+
+	  Say Y here if you have a Quanta-based smartbook or notepad
+	  device and want to use the Quanta i2c keyboard driver.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called qci_gkbd.
+
 config KEYBOARD_STOWAWAY
 	tristate "Stowaway keyboard"
 	select SERIO
diff --git a/drivers/input/keyboard/Makefile b/drivers/input/keyboard/Makefile
index 4596d0c..103adc2 100644
--- a/drivers/input/keyboard/Makefile
+++ b/drivers/input/keyboard/Makefile
@@ -31,6 +31,7 @@ obj-$(CONFIG_KEYBOARD_OMAP)		+= omap-keypad.o
 obj-$(CONFIG_KEYBOARD_OPENCORES)	+= opencores-kbd.o
 obj-$(CONFIG_KEYBOARD_PXA27x)		+= pxa27x_keypad.o
 obj-$(CONFIG_KEYBOARD_PXA930_ROTARY)	+= pxa930_rotary.o
+obj-$(CONFIG_KEYBOARD_QCIGKBD)		+= qci_gkbd.o
 obj-$(CONFIG_KEYBOARD_QT2160)		+= qt2160.o
 obj-$(CONFIG_KEYBOARD_SH_KEYSC)		+= sh_keysc.o
 obj-$(CONFIG_KEYBOARD_STOWAWAY)		+= stowaway.o
diff --git a/drivers/input/keyboard/qci_gkbd.c b/drivers/input/keyboard/qci_gkbd.c
new file mode 100644
index 0000000..7c85462
--- /dev/null
+++ b/drivers/input/keyboard/qci_gkbd.c
@@ -0,0 +1,258 @@
+/* Quanta I2C Keyboard Driver
+ *
+ * Copyright (C) 2009 Quanta Computer Inc.
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
+ *  This driver communicates via I2C to the nuvoTon WPCE775x Embedded
+ *  Controller, which has the keyboard attached to it.
+ *
+ */
+#define pr_fmt(fmt) KBUILD_BASENAME ": " fmt
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/i2c.h>
+#include <linux/interrupt.h>
+#include <linux/input.h>
+#include <linux/keyboard.h>
+#include <linux/gpio.h>
+#include <linux/input/qci_keyboard.h>
+
+#define QCI_KEYBOARD_ID_NAME          "qci-gkbd"
+#define QCI_KEYBOARD_NAME             "Quanta Keyboard"
+#define QCI_KEYBOARD_DEVICE           "/qci-gkbd/input0"
+#define QCI_KEYBOARD_CMD_ENABLE       0xF4
+#define QCI_KEYBOARD_ACK              0xFA
+#define QCI_KEYBOARD_MAX_KEY          127
+
+struct i2ckbd_drv_data {
+	struct i2c_client *ki2c_client;
+	struct input_dev *qcikbd_dev;
+	unsigned int qcikbd_gpio;
+	unsigned int qcikbd_irq;
+	unsigned int key_down;
+	unsigned int escape;
+	unsigned int pause_seq;
+};
+
+#ifdef CONFIG_PM
+static int qcikbd_suspend(struct device *_dev)
+{
+	struct i2c_client *client =
+		container_of(_dev, struct i2c_client, dev);
+	struct i2ckbd_drv_data *context = i2c_get_clientdata(client);
+
+	disable_irq(context->qcikbd_irq);
+	return 0;
+}
+
+static int qcikbd_resume(struct device *_dev)
+{
+	struct i2c_client *client =
+		container_of(_dev, struct i2c_client, dev);
+	struct i2ckbd_drv_data *context = i2c_get_clientdata(client);
+
+	enable_irq(context->qcikbd_irq);
+	return 0;
+}
+
+static const struct dev_pm_ops qcikbd_pm_ops = {
+	.suspend  = qcikbd_suspend,
+	.resume   = qcikbd_resume,
+};
+#endif
+
+static irqreturn_t qcikbd_interrupt(int irq, void *dev_id)
+{
+	struct i2ckbd_drv_data *context = dev_id;
+	unsigned char scancode;
+	unsigned int keycode;
+	struct input_dev *ikbdev = context->qcikbd_dev;
+	int rc;
+
+	rc = i2c_master_recv(context->ki2c_client, &scancode, 1);
+	if (rc != 1)
+		goto irq_exit;
+
+	if (scancode == QCI_KEYBOARD_ACK)
+		goto irq_exit;
+
+	context->key_down = 1;
+	/* MS bit of scancode indicates direction of keypress */
+	if (scancode & 0x80)
+		context->key_down = 0;
+	keycode = scancode & 0x7F;
+	if (keycode) {
+		input_event(ikbdev, EV_MSC, MSC_SCAN, scancode);
+		input_report_key(ikbdev, keycode, context->key_down);
+		input_sync(ikbdev);
+	}
+irq_exit:
+	return IRQ_HANDLED;
+}
+
+static int qcikbd_open(struct input_dev *dev)
+{
+	struct i2ckbd_drv_data *context = input_get_drvdata(dev);
+	u8 buf[1];
+
+	buf[0] = QCI_KEYBOARD_CMD_ENABLE;
+	i2c_master_send(context->ki2c_client, buf, 1);
+	return 0;
+}
+
+static int __devinit qcikbd_probe(struct i2c_client *client,
+				  const struct i2c_device_id *id)
+{
+	int err;
+	int i;
+	struct i2ckbd_drv_data *context;
+	struct qci_keyboard_platform_data *pd;
+	int irq_trigger_type;
+
+	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C)) {
+		pr_err("i2c functionality failed\n");
+		return -ENODEV;
+	}
+
+	context = kzalloc(sizeof(struct i2ckbd_drv_data), GFP_KERNEL);
+	if (!context)
+		return -ENOMEM;
+	i2c_set_clientdata(client, context);
+	context->ki2c_client = client;
+	context->qcikbd_gpio = client->irq;
+
+	pd = client->dev.platform_data;
+	if (pd)
+		irq_trigger_type = pd->irq_trigger_type;
+	else
+		irq_trigger_type = IRQF_TRIGGER_FALLING;
+
+	err = gpio_request(context->qcikbd_gpio, "qci-gkbd");
+	if (err) {
+		pr_err("gpio request failed\n");
+		goto gpio_request_fail;
+	}
+	err = gpio_direction_input(context->qcikbd_gpio);
+	if (err) {
+		pr_err("gpio direction failed\n");
+		goto request_irq_fail;
+	}
+
+	context->qcikbd_irq = gpio_to_irq(context->qcikbd_gpio);
+	err = request_threaded_irq(context->qcikbd_irq, NULL, qcikbd_interrupt,
+				   irq_trigger_type, client->name, context);
+	if (err) {
+		pr_err("unable to get IRQ\n");
+		goto request_irq_fail;
+	}
+
+	context->qcikbd_dev = input_allocate_device();
+	if (!context->qcikbd_dev) {
+		pr_err("input allocate device failed\n");
+		err = -ENOMEM;
+		goto allocate_fail;
+	}
+
+	context->qcikbd_dev->name       = QCI_KEYBOARD_NAME;
+	context->qcikbd_dev->phys       = QCI_KEYBOARD_DEVICE;
+	context->qcikbd_dev->id.bustype = BUS_I2C;
+	context->qcikbd_dev->id.vendor  = 0x1050;
+	context->qcikbd_dev->id.product = 0x0006;
+	context->qcikbd_dev->id.version = 0x0004;
+	context->qcikbd_dev->open       = qcikbd_open;
+	__set_bit(EV_KEY, context->qcikbd_dev->evbit);
+	__set_bit(EV_REP, context->qcikbd_dev->evbit);
+	__set_bit(MSC_SCAN, context->qcikbd_dev->mscbit);
+
+	/* Enable all supported keys */
+	for (i = 1; i <= QCI_KEYBOARD_MAX_KEY; i++)
+		__set_bit(i, context->qcikbd_dev->keybit);
+
+	input_set_drvdata(context->qcikbd_dev, context);
+	err = input_register_device(context->qcikbd_dev);
+	if (err) {
+		pr_err("input register device failed\n");
+		goto register_fail;
+	}
+	return 0;
+
+register_fail:
+	input_free_device(context->qcikbd_dev);
+
+allocate_fail:
+	free_irq(context->qcikbd_irq, context);
+
+request_irq_fail:
+	gpio_free(context->qcikbd_gpio);
+
+gpio_request_fail:
+	kfree(context);
+	return err;
+}
+
+static int __devexit qcikbd_remove(struct i2c_client *dev)
+{
+	struct i2ckbd_drv_data *context = i2c_get_clientdata(dev);
+
+	input_free_device(context->qcikbd_dev);
+	free_irq(context->qcikbd_irq, context);
+	gpio_free(context->qcikbd_gpio);
+	input_unregister_device(context->qcikbd_dev);
+	kfree(context);
+
+	return 0;
+}
+
+static const struct i2c_device_id qcikbd_idtable[] = {
+	{ "wpce775-keyboard", 0 },
+	{ }
+};
+
+MODULE_DEVICE_TABLE(i2c, qcikbd_idtable);
+
+static struct i2c_driver i2ckbd_driver = {
+	.driver = {
+		.owner = THIS_MODULE,
+		.name  = QCI_KEYBOARD_ID_NAME,
+#ifdef CONFIG_PM
+		.pm = &qcikbd_pm_ops,
+#endif
+	},
+	.probe    = qcikbd_probe,
+	.remove = __devexit_p(qcikbd_remove),
+	.id_table = qcikbd_idtable,
+};
+
+static int __init qcikbd_init(void)
+{
+	return i2c_add_driver(&i2ckbd_driver);
+}
+
+static void __exit qcikbd_exit(void)
+{
+	i2c_del_driver(&i2ckbd_driver);
+}
+
+module_init(qcikbd_init);
+module_exit(qcikbd_exit);
+
+MODULE_AUTHOR("Quanta Computer Inc.");
+MODULE_DESCRIPTION("Quanta Embedded Controller I2C Keyboard Driver");
+MODULE_ALIAS("platform:qci-gkbd");
+MODULE_LICENSE("GPL v2");
diff --git a/include/linux/input/qci_keyboard.h b/include/linux/input/qci_keyboard.h
new file mode 100644
index 0000000..b32b7fc
--- /dev/null
+++ b/include/linux/input/qci_keyboard.h
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
+#ifndef __QCI_KEYBOARD_H
+#define __QCI_KEYBOARD_H
+
+struct qci_keyboard_platform_data {
+	unsigned long irq_trigger_type;
+};
+
+#endif
-- 
1.7.0
--
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

