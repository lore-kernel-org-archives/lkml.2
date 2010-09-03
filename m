Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757380Ab0ICUhZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 16:37:25 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:47986 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754039Ab0ICUhX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 16:37:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Od59xfYoXwVtHVKiSWo+yh0kZcG202oZ6hxkSVoZddRkVdvfr/suw5CAM4A8KzA4JI
         gTDS4e023VhMlpTdGhsCNKPPtyzj+91xzkLC3D/hFkqSBmh0Fdd69k9uutbueUjsVPD6
         AiqI+dLSt/RnHkWHjRrR3WRMjzwa3CnAf2RiY=
Date: Fri, 3 Sep 2010 13:37:17 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Neil Leeder <nleeder@codeaurora.org>
Cc: "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Horace Fu <horace.fu@quantatw.com>, Hsin.Wu@quantatw.com,
        mcuos.com@gmail.com
Subject: Re: [PATCH 0/1] input: keyboard: add qci keyboard driver
Message-ID: <20100903203717.GA6412@core.coreip.homeip.net>
References: <4C7838DD.1020004@codeaurora.org>
 <201008271533.01542.dmitry.torokhov@gmail.com>
 <4C7BF6D2.5080501@codeaurora.org>
 <20100830215556.GC28865@core.coreip.homeip.net>
 <4C7D6C17.1070604@codeaurora.org>
 <20100901063430.GG23585@core.coreip.homeip.net>
 <4C8148C6.2010006@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="CE+1k2dSO48ffgeK"
Content-Disposition: inline
In-Reply-To: <4C8148C6.2010006@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--CE+1k2dSO48ffgeK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Neil,

On Fri, Sep 03, 2010 at 03:13:10PM -0400, Neil Leeder wrote:
> On 9/1/2010 2:34 AM, Dmitry Torokhov wrote:
> >
> >OK, I give up on pursuit of serio solution. Again ;)
> 
> Dmitry,
> 
> Don't give up yet... I've been talking to Quanta and they are using
> a different EC in their new products, which should have better
> firmware support for serio over i2c.

This is great!

> When I get the new hardware I
> will try again to overcome the issues that showed up on the previous
> firmware, and I'll submit new patches for both touchpad and
> keyboard.
> 

Does this mean you are not interested in getting drivers for the current
generation of hardware to mainline?

Otherwise, please take a glance at these patches (I did some
renaming/reformatting) and let me know if I broke them. The main
question is whether 0xF5 works for shutting off the keyboard and the
touchpad - I rather dislike that the drivers are asymmetrical in sense
that they implement open() methods but not close().

Thanks.

-- 
Dmitry

--CE+1k2dSO48ffgeK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="input-keyboard-add-qci-keyboard-driver.patch"

Input: add qci keyboard driver

From: Neil Leeder <nleeder@codeaurora.org>

This driver is for the QCI i2c keyboard used on Quanta smartbooks.

Signed-off-by: Horace Fu <horace.fu@quantatw.com>
[nleeder@codeaurora.org: cleanup to latest kernel standards]
Signed-off-by: Neil Leeder <nleeder@codeaurora.org>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/input/keyboard/Kconfig     |   12 ++
 drivers/input/keyboard/Makefile    |    1 
 drivers/input/keyboard/qci_gkbd.c  |  259 ++++++++++++++++++++++++++++++++++++
 include/linux/input/qci_keyboard.h |   25 +++
 4 files changed, 297 insertions(+), 0 deletions(-)
 create mode 100644 drivers/input/keyboard/qci_gkbd.c
 create mode 100644 include/linux/input/qci_keyboard.h


diff --git a/drivers/input/keyboard/Kconfig b/drivers/input/keyboard/Kconfig
index d63f566..2f38feb 100644
--- a/drivers/input/keyboard/Kconfig
+++ b/drivers/input/keyboard/Kconfig
@@ -373,6 +373,18 @@ config KEYBOARD_SAMSUNG
 	  To compile this driver as a module, choose M here: the
 	  module will be called samsung-keypad.
 
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
index c13809c..82f69f7 100644
--- a/drivers/input/keyboard/Makefile
+++ b/drivers/input/keyboard/Makefile
@@ -34,6 +34,7 @@ obj-$(CONFIG_KEYBOARD_OMAP4)		+= omap4-keypad.o
 obj-$(CONFIG_KEYBOARD_OPENCORES)	+= opencores-kbd.o
 obj-$(CONFIG_KEYBOARD_PXA27x)		+= pxa27x_keypad.o
 obj-$(CONFIG_KEYBOARD_PXA930_ROTARY)	+= pxa930_rotary.o
+obj-$(CONFIG_KEYBOARD_QCIGKBD)		+= qci_gkbd.o
 obj-$(CONFIG_KEYBOARD_QT2160)		+= qt2160.o
 obj-$(CONFIG_KEYBOARD_SAMSUNG)		+= samsung-keypad.o
 obj-$(CONFIG_KEYBOARD_SH_KEYSC)		+= sh_keysc.o
diff --git a/drivers/input/keyboard/qci_gkbd.c b/drivers/input/keyboard/qci_gkbd.c
new file mode 100644
index 0000000..6cc06c4
--- /dev/null
+++ b/drivers/input/keyboard/qci_gkbd.c
@@ -0,0 +1,259 @@
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
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
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
+#define QCI_KEYBOARD_ID_NAME		"qci-gkbd"
+#define QCI_KEYBOARD_NAME		"Quanta Keyboard"
+#define QCI_KEYBOARD_DEVICE		"/qci-gkbd/input0"
+#define QCI_KEYBOARD_CMD_ENABLE		0xF4
+#define QCI_KEYBOARD_CMD_DISABLE	0xF5
+#define QCI_KEYBOARD_ACK		0xFA
+#define QCI_KEYBOARD_MAX_KEY		127
+
+struct qci_keyboard {
+	struct i2c_client *client;
+	struct input_dev *input;
+	unsigned int gpio;
+	unsigned int irq;
+};
+
+#ifdef CONFIG_PM
+static int qcikbd_suspend(struct device *dev)
+{
+	struct i2c_client *client = container_of(dev, struct i2c_client, dev);
+	struct qci_keyboard *qcikbd = i2c_get_clientdata(client);
+
+	disable_irq(qcikbd->irq);
+
+	return 0;
+}
+
+static int qcikbd_resume(struct device *dev)
+{
+	struct i2c_client *client = container_of(dev, struct i2c_client, dev);
+	struct qci_keyboard *qcikbd = i2c_get_clientdata(client);
+
+	enable_irq(qcikbd->irq);
+
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
+	struct qci_keyboard *qcikbd = dev_id;
+	struct input_dev *input = qcikbd->input;
+	int rc;
+	unsigned int scancode;
+	unsigned char data;
+	bool down;
+
+	rc = i2c_master_recv(qcikbd->client, &data, 1);
+	if (rc != 1)
+		goto irq_exit;
+
+	if (data == QCI_KEYBOARD_ACK)
+		goto irq_exit;
+
+	scancode = data & 0x7f;
+	down = !(data & 0x80);
+
+	if (scancode) {
+		input_event(input, EV_MSC, MSC_SCAN, scancode);
+		input_report_key(input, scancode, down);
+		input_sync(input);
+	}
+
+irq_exit:
+	return IRQ_HANDLED;
+}
+
+static int qcikbd_open(struct input_dev *dev)
+{
+	struct qci_keyboard *qcikbd = input_get_drvdata(dev);
+	u8 buf[1] = { QCI_KEYBOARD_CMD_ENABLE };
+
+	i2c_master_send(qcikbd->client, buf, 1);
+
+	return 0;
+}
+
+static void qcikbd_close(struct input_dev *dev)
+{
+	struct qci_keyboard *qcikbd = input_get_drvdata(dev);
+	u8 buf[1] = { QCI_KEYBOARD_CMD_DISABLE };
+
+	i2c_master_send(qcikbd->client, buf, 1);
+}
+
+static int __devinit qcikbd_probe(struct i2c_client *client,
+				  const struct i2c_device_id *id)
+{
+	const struct qci_keyboard_platform_data *pd = client->dev.platform_data;
+	struct qci_keyboard *qcikbd;
+	struct input_dev *input;
+	int irq_trigger_type;
+	int err;
+	int i;
+
+	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C)) {
+		pr_err("i2c functionality failed\n");
+		return -ENODEV;
+	}
+
+	qcikbd = kzalloc(sizeof(struct qci_keyboard), GFP_KERNEL);
+	input = input_allocate_device();
+	if (!qcikbd || input) {
+		err = -ENOMEM;
+		goto err_free_mem;
+	}
+
+	qcikbd->client = client;
+	qcikbd->input = input;
+	qcikbd->gpio = client->irq;
+
+	input->name       = QCI_KEYBOARD_NAME;
+	input->phys       = QCI_KEYBOARD_DEVICE;
+	input->id.bustype = BUS_I2C;
+	input->id.vendor  = 0x1050;
+	input->id.product = 0x0006;
+	input->id.version = 0x0004;
+	input->open       = qcikbd_open;
+	input->close      = qcikbd_close;
+
+	__set_bit(EV_KEY, input->evbit);
+	__set_bit(EV_REP, input->evbit);
+	__set_bit(MSC_SCAN, input->mscbit);
+
+	/* Enable all supported keys */
+	for (i = 1; i <= QCI_KEYBOARD_MAX_KEY; i++)
+		__set_bit(i, input->keybit);
+
+	input_set_drvdata(qcikbd->input, qcikbd);
+
+	err = gpio_request(qcikbd->gpio, "qci-gkbd");
+	if (err) {
+		pr_err("gpio request failed\n");
+		goto err_free_mem;
+	}
+
+	err = gpio_direction_input(qcikbd->gpio);
+	if (err) {
+		pr_err("gpio direction failed\n");
+		goto err_free_gpio;
+	}
+
+	qcikbd->irq = gpio_to_irq(qcikbd->gpio);
+	irq_trigger_type = pd ? pd->irq_trigger_type : IRQF_TRIGGER_FALLING;
+	err = request_threaded_irq(qcikbd->irq, NULL, qcikbd_interrupt,
+				   irq_trigger_type, client->name, qcikbd);
+	if (err) {
+		pr_err("unable to get IRQ\n");
+		goto err_free_gpio;
+	}
+
+	err = input_register_device(qcikbd->input);
+	if (err) {
+		pr_err("input register device failed\n");
+		goto err_free_irq;
+	}
+
+	i2c_set_clientdata(client, qcikbd);
+	return 0;
+
+err_free_irq:
+	free_irq(qcikbd->irq, qcikbd);
+err_free_gpio:
+	gpio_free(qcikbd->gpio);
+err_free_mem:
+	input_free_device(input);
+	kfree(qcikbd);
+
+	return err;
+}
+
+static int __devexit qcikbd_remove(struct i2c_client *dev)
+{
+	struct qci_keyboard *qcikbd = i2c_get_clientdata(dev);
+
+	free_irq(qcikbd->irq, qcikbd);
+	gpio_free(qcikbd->gpio);
+	input_unregister_device(qcikbd->input);
+	kfree(qcikbd);
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
+		.owner	= THIS_MODULE,
+		.name	= QCI_KEYBOARD_ID_NAME,
+#ifdef CONFIG_PM
+		.pm	= &qcikbd_pm_ops,
+#endif
+	},
+	.probe		= qcikbd_probe,
+	.remove		= __devexit_p(qcikbd_remove),
+	.id_table	= qcikbd_idtable,
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

--CE+1k2dSO48ffgeK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="input-mouse-add-qci-touchpad-driver.patch"

Input: add qci touchpad driver

From: Neil Leeder <nleeder@codeaurora.org>

This driver is for the QCI trackpad used on Quanta smartbooks

Signed-off-by: Horace Fu <horace.fu@quantatw.com>
Signed-off-by: Mandeep Singh Baines <msb@chromium.org>
[nleeder@codeaurora.org: cleanup i2c calls, address review comments etc]
Signed-off-by: Neil Leeder <nleeder@codeaurora.org>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/input/mouse/Kconfig        |   12 ++
 drivers/input/mouse/Makefile       |    1 
 drivers/input/mouse/qci_touchpad.c |  279 ++++++++++++++++++++++++++++++++++++
 include/linux/input/qci_touchpad.h |   25 +++
 4 files changed, 317 insertions(+), 0 deletions(-)
 create mode 100644 drivers/input/mouse/qci_touchpad.c
 create mode 100644 include/linux/input/qci_touchpad.h


diff --git a/drivers/input/mouse/Kconfig b/drivers/input/mouse/Kconfig
index c714ca2..fec262a 100644
--- a/drivers/input/mouse/Kconfig
+++ b/drivers/input/mouse/Kconfig
@@ -303,6 +303,18 @@ config MOUSE_MAPLE
 	  To compile this driver as a module choose M here: the module will be
 	  called maplemouse.
 
+config MOUSE_QCITP
+	tristate "Quanta Computer Inc. I2C Touchpad"
+	depends on I2C
+	help
+	  This driver supports the touchpad on Quanta smartbook devices.
+
+	  Say Y here if you have a Quanta-based smartbook or notepad
+	  device and want to use the Quanta i2c touchpad driver.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called qci_touchpad.
+
 config MOUSE_SYNAPTICS_I2C
 	tristate "Synaptics I2C Touchpad support"
 	depends on I2C
diff --git a/drivers/input/mouse/Makefile b/drivers/input/mouse/Makefile
index 570c84a4..6eda35d 100644
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
index 0000000..ac52403
--- /dev/null
+++ b/drivers/input/mouse/qci_touchpad.c
@@ -0,0 +1,279 @@
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
+ * which has touchpad attached through PS/2 interface. Unfortunately
+ * firmware does not seem to fully support PS/2 protocol so attempts to
+ * turn the driver into serio and use standard psmouse module to drive
+ * the touchpad failed.
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
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
+#define TOUCHPAD_ID_NAME	"qci-i2cpad"
+#define TOUCHPAD_NAME		"QCI Touchpad"
+#define TOUCHPAD_DEVICE		"/qci_touchpad/input0"
+#define TOUCHPAD_CMD_ENABLE	0xF4
+#define TOUCHPAD_CMD_DISABLE	0xF5
+#define TOUCHPAD_READ_DATA_LEN	3
+#define TOUCHPAD_INIT_DELAY_MS	100
+
+struct qci_touchpad {
+	struct i2c_client *client;
+	struct input_dev *input;
+	unsigned int gpio;
+	unsigned int irq;
+};
+
+#ifdef CONFIG_PM
+static int qcitp_suspend(struct device *dev)
+{
+	struct i2c_client *client = container_of(dev, struct i2c_client, dev);
+	struct qci_touchpad *tpad = i2c_get_clientdata(client);
+
+	disable_irq(tpad->irq);
+
+	return 0;
+}
+
+static int qcitp_resume(struct device *dev)
+{
+	struct i2c_client *client = container_of(dev, struct i2c_client, dev);
+	struct qci_touchpad *tpad = i2c_get_clientdata(client);
+
+	enable_irq(tpad->irq);
+
+	return 0;
+}
+
+static const struct dev_pm_ops qcitp_pm_ops = {
+	.suspend = qcitp_suspend,
+	.resume  = qcitp_resume,
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
+	struct qci_touchpad *tpad = dev_id;
+	char ecdata[TOUCHPAD_READ_DATA_LEN];
+	int rc;
+
+	rc = i2c_master_recv(tpad->client, ecdata, TOUCHPAD_READ_DATA_LEN);
+	if (rc == TOUCHPAD_READ_DATA_LEN)
+		qcitp_report_key(tpad->input, ecdata);
+
+	return IRQ_HANDLED;
+}
+
+static int qcitp_open(struct input_dev *input)
+{
+	struct qci_touchpad *tpad = input_get_drvdata(input);
+	u8 buf[1] = { TOUCHPAD_CMD_ENABLE };
+	int err;
+
+	buf[0] = TOUCHPAD_CMD_ENABLE;
+	err = i2c_master_send(tpad->client, buf, 1);
+	if (err < 0)
+		return err;
+
+	msleep(TOUCHPAD_INIT_DELAY_MS);
+
+	return i2c_master_recv(tpad->client, buf, 1);
+}
+
+static void qcitp_close(struct input_dev *input)
+{
+	struct qci_touchpad *tpad = input_get_drvdata(input);
+	u8 buf[1] = { TOUCHPAD_CMD_DISABLE };
+	int err;
+
+	err = i2c_master_send(tpad->client, buf, 1);
+	if (err == 0) {
+		msleep(TOUCHPAD_INIT_DELAY_MS);
+		/* read ACK */
+		i2c_master_recv(tpad->client, buf, 1);
+	}
+}
+
+
+static int __devinit qcitp_probe(struct i2c_client *client,
+				 const struct i2c_device_id *id)
+{
+	const struct qci_touchpad_platform_data *pd = client->dev.platform_data;
+	struct qci_touchpad *tpad;
+	struct input_dev *input;
+	int irq_trigger_type;
+	int err;
+
+	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C)) {
+		pr_err("i2c functionality failed\n");
+		return -ENODEV;
+	}
+
+	tpad = kzalloc(sizeof(struct qci_touchpad), GFP_KERNEL);
+	input = input_allocate_device();
+	if (!tpad || !input) {
+		err = -ENOMEM;
+		goto err_free_mem;
+	}
+
+	tpad->client = client;
+	tpad->input = input;
+	tpad->gpio = client->irq;
+
+	input->name = TOUCHPAD_NAME;
+	input->phys = TOUCHPAD_DEVICE;
+	input->id.bustype = BUS_I2C;
+	input->id.vendor  = 0x1050;
+	input->id.product = 0x1;
+	input->id.version = 0x1;
+
+	input->open = qcitp_open;
+	input->close = qcitp_close;
+
+	input->evbit[0]  = BIT_MASK(EV_KEY) | BIT_MASK(EV_REL);
+	input->relbit[0] = BIT_MASK(REL_X) | BIT_MASK(REL_Y);
+	input->keybit[BIT_WORD(BTN_LEFT)] =
+		BIT_MASK(BTN_LEFT) | BIT_MASK(BTN_MIDDLE) | BIT_MASK(BTN_RIGHT);
+
+	input_set_drvdata(input, tpad);
+
+	err = gpio_request(tpad->gpio, "qci-pad");
+	if (err) {
+		pr_err("gpio request failed\n");
+		goto err_free_mem;
+	}
+
+	err = gpio_direction_input(tpad->gpio);
+	if (err) {
+		pr_err("gpio direction input failed\n");
+		goto err_free_gpio;
+	}
+
+	tpad->irq = gpio_to_irq(tpad->gpio);
+	irq_trigger_type = pd ? pd->irq_trigger_type : IRQF_TRIGGER_FALLING;
+
+	err = request_threaded_irq(tpad->irq, NULL, qcitp_interrupt,
+				   irq_trigger_type, client->name, tpad);
+	if (err) {
+		pr_err("request threaded irq failed\n");
+		goto err_free_gpio;
+	}
+
+	err = input_register_device(tpad->input);
+	if (err) {
+		pr_err("register device failed\n");
+		goto err_free_irq;
+	}
+
+	i2c_set_clientdata(client, tpad);
+	return 0;
+
+err_free_irq:
+	free_irq(tpad->irq, tpad);
+err_free_gpio:
+	gpio_free(tpad->gpio);
+err_free_mem:
+	input_free_device(input);
+	kfree(tpad);
+	return err;
+}
+
+static int __devexit qcitp_remove(struct i2c_client *client)
+{
+	struct qci_touchpad *tpad = i2c_get_clientdata(client);
+
+	free_irq(tpad->irq, tpad);
+	gpio_free(tpad->gpio);
+	input_unregister_device(tpad->input);
+	kfree(tpad);
+
+	return 0;
+}
+
+static const struct i2c_device_id qcitp_idtable[] = {
+	{ "wpce775-touchpad", 0 },
+	{ }
+};
+
+MODULE_DEVICE_TABLE(i2c, qcitp_idtable);
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

--CE+1k2dSO48ffgeK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="qci_kbd-keymap.patch"

Input: qci_gkbd - allow changing keymap from userspace

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

Wire up input->keycode, input->keycodemax and input->keycodesize so
that EVIOGSKEYCODE ioctl works for the device and users can adjust
keymap from userspace.

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/input/keyboard/qci_gkbd.c |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)


diff --git a/drivers/input/keyboard/qci_gkbd.c b/drivers/input/keyboard/qci_gkbd.c
index 6cc06c4..905d76b 100644
--- a/drivers/input/keyboard/qci_gkbd.c
+++ b/drivers/input/keyboard/qci_gkbd.c
@@ -46,6 +46,7 @@ struct qci_keyboard {
 	struct input_dev *input;
 	unsigned int gpio;
 	unsigned int irq;
+	unsigned short keymap[QCI_KEYBOARD_MAX_KEY + 1];
 };
 
 #ifdef CONFIG_PM
@@ -96,7 +97,7 @@ static irqreturn_t qcikbd_interrupt(int irq, void *dev_id)
 
 	if (scancode) {
 		input_event(input, EV_MSC, MSC_SCAN, scancode);
-		input_report_key(input, scancode, down);
+		input_report_key(input, qcikbd->keymap[scancode], down);
 		input_sync(input);
 	}
 
@@ -161,9 +162,16 @@ static int __devinit qcikbd_probe(struct i2c_client *client,
 	__set_bit(EV_REP, input->evbit);
 	__set_bit(MSC_SCAN, input->mscbit);
 
+	input->keycode = qcikbd->keymap;
+	input->keycodesize = sizeof(qcikbd->keymap[0]);
+	input->keycodemax = ARRAY_SIZE(qcikbd->keymap);
+
 	/* Enable all supported keys */
-	for (i = 1; i <= QCI_KEYBOARD_MAX_KEY; i++)
+	for (i = 1; i <= QCI_KEYBOARD_MAX_KEY; i++) {
+		/* Initial keymap has 1:1 scancode - keycode mapping */
+		qcikbd->keymap[i] = i;
 		__set_bit(i, input->keybit);
+	}
 
 	input_set_drvdata(qcikbd->input, qcikbd);
 

--CE+1k2dSO48ffgeK--
