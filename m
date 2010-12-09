Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757447Ab0LIVvX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 16:51:23 -0500
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:42263 "HELO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754919Ab0LIVvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 16:51:19 -0500
From: Ben Gardiner <bengardiner@nanometrics.ca>
To: Kevin Hilman <khilman@deeprootsystems.com>,
        davinci-linux-open-source@linux.davincidsp.com,
        linux-input@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Chris Cordahi <christophercordahi@nanometrics.ca>,
        Paul Mundt <lethal@linux-sh.org>, Sekhar Nori <nsekhar@ti.com>,
        Gabor Juhos <juhosg@openwrt.org>, Dmitry Torokhov <dtor@mail.ru>
Subject: [PATCH v6 1/5] Input: add input driver for polled GPIO buttons
Date: Thu,  9 Dec 2010 16:51:03 -0500
Message-Id: <b534569073dec52718e99623858ea9dd146faf24.1291931041.git.bengardiner@nanometrics.ca>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <cover.1291931041.git.bengardiner@nanometrics.ca>
References: <cover.1290635422.git.bengardiner@nanometrics.ca> <cover.1291931041.git.bengardiner@nanometrics.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gabor Juhos <juhosg@openwrt.org>

The existing gpio-keys driver can be usable only for GPIO lines with
interrupt support. Several devices have buttons connected to a GPIO
line which is not capable to generate interrupts. This patch adds a
new input driver using the generic GPIO layer and the input-polldev
to support such buttons.

[Ben Gardiner <bengardiner@nanometrics.ca: fold code to use more
 of the original gpio_keys infrastructure; cleanups and other
 improvements.]

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
Signed-off-by: Ben Gardiner <bengardiner@nanometrics.ca>
Tested-by: Ben Gardiner <bengardiner@nanometrics.ca>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
(cherry picked from commit 0e7d0c860a0dee49dacb7bbb248d1eba637075ad)

---

This a copy of the commit -- I included in the patch series since
linux-davinci/master does not currently have it; but 2.6.37-rc5 does.

---
 drivers/input/keyboard/Kconfig            |   16 ++
 drivers/input/keyboard/Makefile           |    1 +
 drivers/input/keyboard/gpio_keys_polled.c |  261 +++++++++++++++++++++++++++++
 include/linux/gpio_keys.h                 |    2 +
 4 files changed, 280 insertions(+), 0 deletions(-)
 create mode 100644 drivers/input/keyboard/gpio_keys_polled.c

diff --git a/drivers/input/keyboard/Kconfig b/drivers/input/keyboard/Kconfig
index b8c51b9..3a87f3b 100644
--- a/drivers/input/keyboard/Kconfig
+++ b/drivers/input/keyboard/Kconfig
@@ -179,6 +179,22 @@ config KEYBOARD_GPIO
 	  To compile this driver as a module, choose M here: the
 	  module will be called gpio_keys.
 
+config KEYBOARD_GPIO_POLLED
+	tristate "Polled GPIO buttons"
+	depends on GENERIC_GPIO
+	select INPUT_POLLDEV
+	help
+	  This driver implements support for buttons connected
+	  to GPIO pins that are not capable of generating interrupts.
+
+	  Say Y here if your device has buttons connected
+	  directly to such GPIO pins.  Your board-specific
+	  setup logic must also provide a platform device,
+	  with configuration data saying which GPIOs are used.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called gpio_keys_polled.
+
 config KEYBOARD_TCA6416
 	tristate "TCA6416 Keypad Support"
 	depends on I2C
diff --git a/drivers/input/keyboard/Makefile b/drivers/input/keyboard/Makefile
index a34452e..622de73 100644
--- a/drivers/input/keyboard/Makefile
+++ b/drivers/input/keyboard/Makefile
@@ -14,6 +14,7 @@ obj-$(CONFIG_KEYBOARD_BFIN)		+= bf54x-keys.o
 obj-$(CONFIG_KEYBOARD_DAVINCI)		+= davinci_keyscan.o
 obj-$(CONFIG_KEYBOARD_EP93XX)		+= ep93xx_keypad.o
 obj-$(CONFIG_KEYBOARD_GPIO)		+= gpio_keys.o
+obj-$(CONFIG_KEYBOARD_GPIO_POLLED)	+= gpio_keys_polled.o
 obj-$(CONFIG_KEYBOARD_TCA6416)		+= tca6416-keypad.o
 obj-$(CONFIG_KEYBOARD_HIL)		+= hil_kbd.o
 obj-$(CONFIG_KEYBOARD_HIL_OLD)		+= hilkbd.o
diff --git a/drivers/input/keyboard/gpio_keys_polled.c b/drivers/input/keyboard/gpio_keys_polled.c
new file mode 100644
index 0000000..4c17aff
--- /dev/null
+++ b/drivers/input/keyboard/gpio_keys_polled.c
@@ -0,0 +1,261 @@
+/*
+ *  Driver for buttons on GPIO lines not capable of generating interrupts
+ *
+ *  Copyright (C) 2007-2010 Gabor Juhos <juhosg@openwrt.org>
+ *  Copyright (C) 2010 Nuno Goncalves <nunojpg@gmail.com>
+ *
+ *  This file was based on: /drivers/input/misc/cobalt_btns.c
+ *	Copyright (C) 2007 Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
+ *
+ *  also was based on: /drivers/input/keyboard/gpio_keys.c
+ *	Copyright 2005 Phil Blundell
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/slab.h>
+#include <linux/input.h>
+#include <linux/input-polldev.h>
+#include <linux/ioport.h>
+#include <linux/platform_device.h>
+#include <linux/gpio.h>
+#include <linux/gpio_keys.h>
+
+#define DRV_NAME	"gpio-keys-polled"
+
+struct gpio_keys_button_data {
+	int last_state;
+	int count;
+	int threshold;
+	int can_sleep;
+};
+
+struct gpio_keys_polled_dev {
+	struct input_polled_dev *poll_dev;
+	struct device *dev;
+	struct gpio_keys_platform_data *pdata;
+	struct gpio_keys_button_data data[0];
+};
+
+static void gpio_keys_polled_check_state(struct input_dev *input,
+					 struct gpio_keys_button *button,
+					 struct gpio_keys_button_data *bdata)
+{
+	int state;
+
+	if (bdata->can_sleep)
+		state = !!gpio_get_value_cansleep(button->gpio);
+	else
+		state = !!gpio_get_value(button->gpio);
+
+	if (state != bdata->last_state) {
+		unsigned int type = button->type ?: EV_KEY;
+
+		input_event(input, type, button->code,
+			    !!(state ^ button->active_low));
+		input_sync(input);
+		bdata->count = 0;
+		bdata->last_state = state;
+	}
+}
+
+static void gpio_keys_polled_poll(struct input_polled_dev *dev)
+{
+	struct gpio_keys_polled_dev *bdev = dev->private;
+	struct gpio_keys_platform_data *pdata = bdev->pdata;
+	struct input_dev *input = dev->input;
+	int i;
+
+	for (i = 0; i < bdev->pdata->nbuttons; i++) {
+		struct gpio_keys_button_data *bdata = &bdev->data[i];
+
+		if (bdata->count < bdata->threshold)
+			bdata->count++;
+		else
+			gpio_keys_polled_check_state(input, &pdata->buttons[i],
+						     bdata);
+	}
+}
+
+static void gpio_keys_polled_open(struct input_polled_dev *dev)
+{
+	struct gpio_keys_polled_dev *bdev = dev->private;
+	struct gpio_keys_platform_data *pdata = bdev->pdata;
+
+	if (pdata->enable)
+		pdata->enable(bdev->dev);
+}
+
+static void gpio_keys_polled_close(struct input_polled_dev *dev)
+{
+	struct gpio_keys_polled_dev *bdev = dev->private;
+	struct gpio_keys_platform_data *pdata = bdev->pdata;
+
+	if (pdata->disable)
+		pdata->disable(bdev->dev);
+}
+
+static int __devinit gpio_keys_polled_probe(struct platform_device *pdev)
+{
+	struct gpio_keys_platform_data *pdata = pdev->dev.platform_data;
+	struct device *dev = &pdev->dev;
+	struct gpio_keys_polled_dev *bdev;
+	struct input_polled_dev *poll_dev;
+	struct input_dev *input;
+	int error;
+	int i;
+
+	if (!pdata || !pdata->poll_interval)
+		return -EINVAL;
+
+	bdev = kzalloc(sizeof(struct gpio_keys_polled_dev) +
+		       pdata->nbuttons * sizeof(struct gpio_keys_button_data),
+		       GFP_KERNEL);
+	if (!bdev) {
+		dev_err(dev, "no memory for private data\n");
+		return -ENOMEM;
+	}
+
+	poll_dev = input_allocate_polled_device();
+	if (!poll_dev) {
+		dev_err(dev, "no memory for polled device\n");
+		error = -ENOMEM;
+		goto err_free_bdev;
+	}
+
+	poll_dev->private = bdev;
+	poll_dev->poll = gpio_keys_polled_poll;
+	poll_dev->poll_interval = pdata->poll_interval;
+	poll_dev->open = gpio_keys_polled_open;
+	poll_dev->close = gpio_keys_polled_close;
+
+	input = poll_dev->input;
+
+	input->evbit[0] = BIT(EV_KEY);
+	input->name = pdev->name;
+	input->phys = DRV_NAME"/input0";
+	input->dev.parent = &pdev->dev;
+
+	input->id.bustype = BUS_HOST;
+	input->id.vendor = 0x0001;
+	input->id.product = 0x0001;
+	input->id.version = 0x0100;
+
+	for (i = 0; i < pdata->nbuttons; i++) {
+		struct gpio_keys_button *button = &pdata->buttons[i];
+		struct gpio_keys_button_data *bdata = &bdev->data[i];
+		unsigned int gpio = button->gpio;
+		unsigned int type = button->type ?: EV_KEY;
+
+		if (button->wakeup) {
+			dev_err(dev, DRV_NAME " does not support wakeup\n");
+			error = -EINVAL;
+			goto err_free_gpio;
+		}
+
+		error = gpio_request(gpio,
+				     button->desc ? button->desc : DRV_NAME);
+		if (error) {
+			dev_err(dev, "unable to claim gpio %u, err=%d\n",
+				gpio, error);
+			goto err_free_gpio;
+		}
+
+		error = gpio_direction_input(gpio);
+		if (error) {
+			dev_err(dev,
+				"unable to set direction on gpio %u, err=%d\n",
+				gpio, error);
+			goto err_free_gpio;
+		}
+
+		bdata->can_sleep = gpio_cansleep(gpio);
+		bdata->last_state = -1;
+		bdata->threshold = DIV_ROUND_UP(button->debounce_interval,
+						pdata->poll_interval);
+
+		input_set_capability(input, type, button->code);
+	}
+
+	bdev->poll_dev = poll_dev;
+	bdev->dev = dev;
+	bdev->pdata = pdata;
+	platform_set_drvdata(pdev, bdev);
+
+	error = input_register_polled_device(poll_dev);
+	if (error) {
+		dev_err(dev, "unable to register polled device, err=%d\n",
+			error);
+		goto err_free_gpio;
+	}
+
+	/* report initial state of the buttons */
+	for (i = 0; i < pdata->nbuttons; i++)
+		gpio_keys_polled_check_state(input, &pdata->buttons[i],
+					 &bdev->data[i]);
+
+	return 0;
+
+err_free_gpio:
+	while (--i >= 0)
+		gpio_free(pdata->buttons[i].gpio);
+
+	input_free_polled_device(poll_dev);
+
+err_free_bdev:
+	kfree(bdev);
+
+	platform_set_drvdata(pdev, NULL);
+	return error;
+}
+
+static int __devexit gpio_keys_polled_remove(struct platform_device *pdev)
+{
+	struct gpio_keys_polled_dev *bdev = platform_get_drvdata(pdev);
+	struct gpio_keys_platform_data *pdata = bdev->pdata;
+	int i;
+
+	input_unregister_polled_device(bdev->poll_dev);
+
+	for (i = 0; i < pdata->nbuttons; i++)
+		gpio_free(pdata->buttons[i].gpio);
+
+	input_free_polled_device(bdev->poll_dev);
+
+	kfree(bdev);
+	platform_set_drvdata(pdev, NULL);
+
+	return 0;
+}
+
+static struct platform_driver gpio_keys_polled_driver = {
+	.probe	= gpio_keys_polled_probe,
+	.remove	= __devexit_p(gpio_keys_polled_remove),
+	.driver	= {
+		.name	= DRV_NAME,
+		.owner	= THIS_MODULE,
+	},
+};
+
+static int __init gpio_keys_polled_init(void)
+{
+	return platform_driver_register(&gpio_keys_polled_driver);
+}
+
+static void __exit gpio_keys_polled_exit(void)
+{
+	platform_driver_unregister(&gpio_keys_polled_driver);
+}
+
+module_init(gpio_keys_polled_init);
+module_exit(gpio_keys_polled_exit);
+
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR("Gabor Juhos <juhosg@openwrt.org>");
+MODULE_DESCRIPTION("Polled GPIO Buttons driver");
+MODULE_ALIAS("platform:" DRV_NAME);
diff --git a/include/linux/gpio_keys.h b/include/linux/gpio_keys.h
index ce73a30..dd1a56f 100644
--- a/include/linux/gpio_keys.h
+++ b/include/linux/gpio_keys.h
@@ -16,6 +16,8 @@ struct gpio_keys_button {
 struct gpio_keys_platform_data {
 	struct gpio_keys_button *buttons;
 	int nbuttons;
+	unsigned int poll_interval;	/* polling interval in msecs -
+					   for polling driver only */
 	unsigned int rep:1;		/* enable input subsystem auto repeat */
 	int (*enable)(struct device *dev);
 	void (*disable)(struct device *dev);
-- 
1.7.0.4

