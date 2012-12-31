Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751650Ab2LaCwy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2012 21:52:54 -0500
Received: from mail-da0-f41.google.com ([209.85.210.41]:62608 "EHLO
	mail-da0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716Ab2LaCwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2012 21:52:50 -0500
From: Dongjin Kim <tobetter@gmail.com>
Cc: Dongjin Kim <tobetter@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        =?UTF-8?q?Ren=C3=A9=20B=C3=BCrgel?= <rene.buergel@sohard.de>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Subject: [PATCH] USB: misc: Add USB3503 High-Speed Hub Controller
Date: Mon, 31 Dec 2012 11:50:54 +0900
Message-Id: <1356922268-13098-1-git-send-email-tobetter@gmail.com>
X-Mailer: git-send-email 1.7.10.4
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds new driver of SMSC USB3503 USB 2.0 hub controller with HSIC
upstream connectivity and three USB 2.0 downstream ports. The specification
can be found from 'http://www.smsc.com/index.php?tid=295&pid=325'.

The current version have been tested very basic features switching the modes,
HUB-MODE and STANDBY-MODE.

Signed-off-by: Dongjin Kim <tobetter@gmail.com>
---
 drivers/usb/misc/Kconfig              |    6 +
 drivers/usb/misc/Makefile             |    1 +
 drivers/usb/misc/usb3503.c            |  323 +++++++++++++++++++++++++++++++++
 include/linux/platform_data/usb3503.h |   17 ++
 4 files changed, 347 insertions(+)
 create mode 100644 drivers/usb/misc/usb3503.c
 create mode 100644 include/linux/platform_data/usb3503.h

diff --git a/drivers/usb/misc/Kconfig b/drivers/usb/misc/Kconfig
index fecde69..3b1a3f4 100644
--- a/drivers/usb/misc/Kconfig
+++ b/drivers/usb/misc/Kconfig
@@ -250,3 +250,9 @@ config USB_EZUSB_FX2
 	help
 	  Say Y here if you need EZUSB device support.
 	  (Cypress FX/FX2/FX2LP microcontrollers)
+
+config USB_HSIC_USB3503
+       tristate "USB3503 HSIC to USB20 Driver"
+       depends on I2C
+       help
+         This option enables support for SMSC USB3503 HSIC to USB 2.0 Driver.
diff --git a/drivers/usb/misc/Makefile b/drivers/usb/misc/Makefile
index 3e99a64..3e1bd70 100644
--- a/drivers/usb/misc/Makefile
+++ b/drivers/usb/misc/Makefile
@@ -26,5 +26,6 @@ obj-$(CONFIG_USB_TRANCEVIBRATOR)	+= trancevibrator.o
 obj-$(CONFIG_USB_USS720)		+= uss720.o
 obj-$(CONFIG_USB_SEVSEG)		+= usbsevseg.o
 obj-$(CONFIG_USB_YUREX)			+= yurex.o
+obj-$(CONFIG_USB_HSIC_USB3503)		+= usb3503.o
 
 obj-$(CONFIG_USB_SISUSBVGA)		+= sisusbvga/
diff --git a/drivers/usb/misc/usb3503.c b/drivers/usb/misc/usb3503.c
new file mode 100644
index 0000000..f21fca9
--- /dev/null
+++ b/drivers/usb/misc/usb3503.c
@@ -0,0 +1,323 @@
+/*
+ * Driver for SMSC USB3503 USB 2.0 hub controller driver
+ *
+ * Copyright (c) 2012 Dongjin Kim (tobetter@gmail.com)
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
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+#include <linux/i2c.h>
+#include <linux/gpio.h>
+#include <linux/delay.h>
+#include <linux/slab.h>
+#include <linux/module.h>
+#include <linux/of_gpio.h>
+#include <linux/platform_device.h>
+#include <linux/platform_data/usb3503.h>
+
+#define USB3503_VIDL		0x00
+#define USB3503_VIDM		0x01
+#define USB3503_PIDL		0x02
+#define USB3503_PIDM		0x03
+#define USB3503_DIDL		0x04
+#define USB3503_DIDM		0x05
+
+#define USB3503_CFG1		0x06
+#define USB3503_SELF_BUS_PWR	(1 << 7)
+
+#define USB3503_CFG2		0x07
+#define USB3503_CFG3		0x08
+#define USB3503_NRD		0x09
+
+#define USB3503_PDS		0x0a
+#define USB3503_PORT1		(1 << 1)
+#define USB3503_PORT2		(1 << 2)
+#define USB3503_PORT3		(1 << 3)
+
+#define USB3503_SP_ILOCK	0xe7
+#define USB3503_SPILOCK_CONNECT	(1 << 1)
+#define USB3503_SPILOCK_CONFIG	(1 << 0)
+
+#define USB3503_CFGP		0xee
+#define USB3503_CLKSUSP		(1 << 7)
+
+struct usb3503 {
+	enum usb3503_mode	mode;
+	struct i2c_client	*client;
+	int	gpio_intn;
+	int	gpio_reset;
+	int	gpio_connect;
+};
+
+static int usb3503_write_register(struct i2c_client *client,
+		char reg, char data)
+{
+	return i2c_smbus_write_byte_data(client, reg, data);
+}
+
+static int usb3503_read_register(struct i2c_client *client, char reg)
+{
+	return i2c_smbus_read_byte_data(client, reg);
+}
+
+static int usb3503_set_bits(struct i2c_client *client, char reg, char req)
+{
+	int err;
+
+	err = usb3503_read_register(client, reg);
+	if (err < 0)
+		return err;
+
+	err = usb3503_write_register(client, reg, err | req);
+	if (err < 0)
+		return err;
+
+	return 0;
+}
+
+static int usb3503_clear_bits(struct i2c_client *client, char reg, char req)
+{
+	int err;
+
+	err = usb3503_read_register(client, reg);
+	if (err < 0)
+		return err;
+
+	err = usb3503_write_register(client, reg, err & ~req);
+	if (err < 0)
+		return err;
+
+	return 0;
+}
+
+static int usb3503_reset(int gpio_reset, int state)
+{
+	if (gpio_is_valid(gpio_reset))
+		gpio_set_value(gpio_reset, state);
+
+	/* Wait RefClk when RESET_N is released, otherwise Hub will
+	 * not transition to Hub Communication Stage.
+	 */
+	if (state)
+		msleep(100);
+
+	return 0;
+}
+
+static int usb3503_switch_mode(struct usb3503 *hub, enum usb3503_mode mode)
+{
+	struct i2c_client *i2c = hub->client;
+	int err = 0;
+
+	switch (mode) {
+	case USB3503_MODE_HUB:
+		usb3503_reset(hub->gpio_reset, 1);
+
+		/* SP_ILOCK: set connect_n, config_n for config */
+		err = usb3503_write_register(i2c, USB3503_SP_ILOCK,
+			(USB3503_SPILOCK_CONNECT | USB3503_SPILOCK_CONFIG));
+		if (err < 0) {
+			dev_err(&i2c->dev, "SP_ILOCK failed (%d)\n", err);
+			goto err_hubmode;
+		}
+
+		/* PDS : Port2,3 Disable For Self Powered Operation */
+		err = usb3503_set_bits(i2c, USB3503_PDS,
+				(USB3503_PORT2 | USB3503_PORT3));
+		if (err < 0) {
+			dev_err(&i2c->dev, "PDS failed (%d)\n", err);
+			goto err_hubmode;
+		}
+
+		/* CFG1 : SELF_BUS_PWR -> Self-Powerd operation */
+		err = usb3503_set_bits(i2c, USB3503_CFG1, USB3503_SELF_BUS_PWR);
+		if (err < 0) {
+			dev_err(&i2c->dev, "CFG1 failed (%d)\n", err);
+			goto err_hubmode;
+		}
+
+		/* SP_LOCK: clear connect_n, config_n for hub connect */
+		err = usb3503_clear_bits(i2c, USB3503_SP_ILOCK,
+			(USB3503_SPILOCK_CONNECT | USB3503_SPILOCK_CONFIG));
+		if (err < 0) {
+			dev_err(&i2c->dev, "SP_ILOCK failed (%d)\n", err);
+			goto err_hubmode;
+		}
+
+		hub->mode = mode;
+		dev_info(&i2c->dev, "switched to HUB mode\n");
+		break;
+
+	case USB3503_MODE_STANDBY:
+		usb3503_reset(hub->gpio_reset, 0);
+
+		hub->mode = mode;
+		dev_info(&i2c->dev, "switched to STANDBY mode\n");
+		break;
+
+	default:
+		dev_err(&i2c->dev, "unknown mode is request\n");
+		err = -EINVAL;
+		break;
+	}
+
+err_hubmode:
+	return err;
+}
+
+int usb3503_probe(struct i2c_client *i2c, const struct i2c_device_id *id)
+{
+	struct usb3503_platform_data *pdata = i2c->dev.platform_data;
+	struct device_node *np = i2c->dev.of_node;
+	struct usb3503 *hub;
+	u32 mode;
+	int err;
+
+	hub = kzalloc(sizeof(struct usb3503), GFP_KERNEL);
+	if (!hub) {
+		dev_err(&i2c->dev, "private data alloc fail\n");
+		return -ENOMEM;
+	}
+
+	i2c_set_clientdata(i2c, hub);
+	hub->client = i2c;
+
+	if (pdata) {
+		hub->gpio_intn		= pdata->gpio_intn;
+		hub->gpio_connect	= pdata->gpio_connect;
+		hub->gpio_reset		= pdata->gpio_reset;
+		hub->mode		= pdata->initial_mode;
+	} else if (np) {
+		hub->gpio_intn	= of_get_named_gpio(np, "connect-gpios", 0);
+		if (hub->gpio_intn == -EPROBE_DEFER)
+			return -EPROBE_DEFER;
+		hub->gpio_connect = of_get_named_gpio(np, "intn-gpios", 0);
+		if (hub->gpio_connect == -EPROBE_DEFER)
+			return -EPROBE_DEFER;
+		hub->gpio_reset	= of_get_named_gpio(np, "reset-gpios", 0);
+		if (hub->gpio_reset == -EPROBE_DEFER)
+			return -EPROBE_DEFER;
+		of_property_read_u32(np, "initial-mode", &mode);
+		hub->mode = mode;
+	}
+
+	if (gpio_is_valid(hub->gpio_intn)) {
+		err = gpio_request_one(hub->gpio_intn,
+				GPIOF_OUT_INIT_HIGH, "usb3503 intn");
+		if (err) {
+			dev_err(&i2c->dev,
+					"unable to request GPIO %d as connect pin (%d)\n",
+					hub->gpio_intn, err);
+			goto err_gpio_intn;
+		}
+	}
+
+	if (gpio_is_valid(hub->gpio_connect)) {
+		err = gpio_request_one(hub->gpio_connect,
+				GPIOF_OUT_INIT_HIGH, "usb3503 connect");
+		if (err) {
+			dev_err(&i2c->dev,
+					"unable to request GPIO %d as connect pin (%d)\n",
+					hub->gpio_connect, err);
+			goto err_gpio_connect;
+		}
+	}
+
+	if (gpio_is_valid(hub->gpio_reset)) {
+		err = gpio_request_one(hub->gpio_reset,
+				GPIOF_OUT_INIT_LOW, "usb3503 reset");
+		if (err) {
+			dev_err(&i2c->dev,
+					"unable to request GPIO %d as reset pin (%d)\n",
+					hub->gpio_reset, err);
+			goto err_gpio_reset;
+		}
+	}
+
+	usb3503_switch_mode(hub, hub->mode);
+
+	dev_info(&i2c->dev, "%s: probed on  %s mode\n", __func__,
+			(hub->mode == USB3503_MODE_HUB) ? "hub" : "standby");
+
+	return 0;
+
+err_gpio_reset:
+	if (gpio_is_valid(hub->gpio_connect))
+		gpio_free(hub->gpio_connect);
+err_gpio_connect:
+	if (gpio_is_valid(hub->gpio_intn))
+		gpio_free(hub->gpio_intn);
+err_gpio_intn:
+	kfree(hub);
+
+	return err;
+}
+
+static int usb3503_remove(struct i2c_client *i2c)
+{
+	struct usb3503 *hub = i2c_get_clientdata(i2c);
+
+	if (gpio_is_valid(hub->gpio_intn))
+		gpio_free(hub->gpio_intn);
+	if (gpio_is_valid(hub->gpio_connect))
+		gpio_free(hub->gpio_connect);
+	if (gpio_is_valid(hub->gpio_reset))
+		gpio_free(hub->gpio_reset);
+
+	kfree(hub);
+
+	return 0;
+}
+
+static const struct i2c_device_id usb3503_id[] = {
+	{ "usb3503", 0 },
+	{ }
+};
+MODULE_DEVICE_TABLE(i2c, usb3503_id);
+
+#ifdef CONFIG_OF
+static const struct of_device_id usb3503_of_match[] = {
+	{ .compatible = "smsc,usb3503", },
+	{},
+};
+MODULE_DEVICE_TABLE(of, usb3503_of_match);
+#endif
+
+static struct i2c_driver usb3503_driver = {
+	.driver = {
+		.name = "usb3503",
+		.of_match_table = of_match_ptr(usb3503_of_match),
+	},
+	.probe		= usb3503_probe,
+	.remove		= usb3503_remove,
+	.id_table	= usb3503_id,
+};
+
+static int __init usb3503_init(void)
+{
+	return i2c_add_driver(&usb3503_driver);
+}
+
+static void __exit usb3503_exit(void)
+{
+	i2c_del_driver(&usb3503_driver);
+}
+
+module_init(usb3503_init);
+module_exit(usb3503_exit);
+
+MODULE_AUTHOR("Dongjin Kim <tobetter@gmail.com>");
+MODULE_DESCRIPTION("USB3503 USB HUB driver");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/platform_data/usb3503.h b/include/linux/platform_data/usb3503.h
new file mode 100644
index 0000000..c0346fe
--- /dev/null
+++ b/include/linux/platform_data/usb3503.h
@@ -0,0 +1,17 @@
+#ifndef __USB3503_H__
+#define __USB3503_H__
+
+enum usb3503_mode {
+	USB3503_MODE_UNKNOWN,
+	USB3503_MODE_HUB,
+	USB3503_MODE_STANDBY,
+};
+
+struct usb3503_platform_data {
+	enum usb3503_mode	initial_mode;
+	int	gpio_intn;
+	int	gpio_connect;
+	int	gpio_reset;
+};
+
+#endif
-- 
1.7.10.4

