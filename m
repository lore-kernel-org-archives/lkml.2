Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756141Ab0KXV7o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 16:59:44 -0500
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:53301 "HELO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756070Ab0KXV7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 16:59:41 -0500
From: Ben Gardiner <bengardiner@nanometrics.ca>
To: Kevin Hilman <khilman@deeprootsystems.com>,
        davinci-linux-open-source@linux.davincidsp.com,
        linux-input@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Chris Cordahi <christophercordahi@nanometrics.ca>,
        Paul Mundt <lethal@linux-sh.org>, Sekhar Nori <nsekhar@ti.com>,
        Gabor Juhos <juhosg@openwrt.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Mike Frysinger <vapier@gentoo.org>
Subject: [PATCH v5 1/5] [WIP] input: add input driver for polled GPIO buttons
Date: Wed, 24 Nov 2010 16:59:30 -0500
Message-Id: <91c06463c8c2afb543c8a22350d2ddd8bf2ef71f.1290635422.git.bengardiner@nanometrics.ca>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <cover.1290635422.git.bengardiner@nanometrics.ca>
References: <cover.1290540916.git.bengardiner@nanometrics.ca> <cover.1290635422.git.bengardiner@nanometrics.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gabor Juhos <juhosg@openwrt.org>

The existing gpio-keys driver can be usable only for GPIO lines with
interrupt support. Several devices have buttons connected to a GPIO
line which is not capable to generate interrupts. This patch adds a
new input driver using the generic GPIO layer and the input-polldev
to support such buttons.

(WIP: this version has incorporated into it the changes I suggested in review
of the original patch by Gabor Junos. I am posting it as part of the da850-evm
series in the hopes that the final version produced by Gabor can be
substituted in its place when the time is right. I don't mean to imply that
this version of the patch should be integrated in the final series)

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Mike Frysinger <vapier@gentoo.org>
Cc: linux-input@vger.kernel.org
Signed-off-by: Ben Gardiner <bengardiner@nanometrics.ca>
---
 drivers/input/keyboard/Kconfig            |   16 ++
 drivers/input/keyboard/Makefile           |    2 +
 drivers/input/keyboard/gpio_keys_polled.c |  240 +++++++++++++++++++++++++++++
 include/linux/gpio_keys_polled.h          |   26 +++
 4 files changed, 284 insertions(+), 0 deletions(-)
 create mode 100644 drivers/input/keyboard/gpio_keys_polled.c
 create mode 100644 include/linux/gpio_keys_polled.h

diff --git a/drivers/input/keyboard/Kconfig b/drivers/input/keyboard/Kconfig
index b8c51b9..9648ff4 100644
--- a/drivers/input/keyboard/Kconfig
+++ b/drivers/input/keyboard/Kconfig
@@ -485,4 +485,20 @@ config KEYBOARD_W90P910
 	  To compile this driver as a module, choose M here: the
 	  module will be called w90p910_keypad.
 
+config KEYBOARD_GPIO_POLLED
+	tristate "Polled GPIO buttons"
+	depends on GENERIC_GPIO
+	select INPUT_POLLDEV
+	help
+	  This driver implements support for buttons connected
+	  to GPIO pins of various CPUs (and some other chips).
+
+	  Say Y here if your device has buttons connected
+	  directly to such GPIO pins.  Your board-specific
+	  setup logic must also provide a platform device,
+	  with configuration data saying which GPIOs are used.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called gpio-buttons.
+
 endif
diff --git a/drivers/input/keyboard/Makefile b/drivers/input/keyboard/Makefile
index a34452e..e6da817 100644
--- a/drivers/input/keyboard/Makefile
+++ b/drivers/input/keyboard/Makefile
@@ -44,3 +44,5 @@ obj-$(CONFIG_KEYBOARD_TNETV107X)	+= tnetv107x-keypad.o
 obj-$(CONFIG_KEYBOARD_TWL4030)		+= twl4030_keypad.o
 obj-$(CONFIG_KEYBOARD_XTKBD)		+= xtkbd.o
 obj-$(CONFIG_KEYBOARD_W90P910)		+= w90p910_keypad.o
+obj-$(CONFIG_KEYBOARD_GPIO_POLLED)	+= gpio_keys_polled.o
+
diff --git a/drivers/input/keyboard/gpio_keys_polled.c b/drivers/input/keyboard/gpio_keys_polled.c
new file mode 100644
index 0000000..390ed93
--- /dev/null
+++ b/drivers/input/keyboard/gpio_keys_polled.c
@@ -0,0 +1,240 @@
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
+ *
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
+#include <linux/gpio_keys_polled.h>
+
+#define DRV_NAME	"gpio-keys-polled"
+
+struct gpio_keys_button_data {
+	int last_state;
+	int count;
+	int can_sleep;
+};
+
+struct gpio_keys_polled_dev {
+	struct input_polled_dev *poll_dev;
+	struct gpio_keys_polled_platform_data *pdata;
+	struct gpio_keys_button_data *data;
+};
+
+static void gpio_keys_polled_check_state(struct input_dev *input,
+				      struct gpio_keys_button *button,
+				      struct gpio_keys_button_data *bdata)
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
+	struct gpio_keys_polled_platform_data *pdata = bdev->pdata;
+	struct input_dev *input = dev->input;
+	int i, threshold;
+
+	for (i = 0; i < bdev->pdata->nbuttons; i++) {
+		struct gpio_keys_button *button = &pdata->buttons[i];
+		struct gpio_keys_button_data *bdata = &bdev->data[i];
+
+		threshold = round_up(button->debounce_interval,
+				pdata->poll_interval) /
+				pdata->poll_interval;
+		if (bdata->count < threshold)
+			bdata->count++;
+		else
+			gpio_keys_polled_check_state(input, button, bdata);
+
+	}
+}
+
+static int __devinit gpio_keys_polled_probe(struct platform_device *pdev)
+{
+	struct gpio_keys_polled_platform_data *pdata = pdev->dev.platform_data;
+	struct device *dev = &pdev->dev;
+	struct gpio_keys_polled_dev *bdev;
+	struct input_polled_dev *poll_dev;
+	struct input_dev *input;
+	int error;
+	int i;
+
+	if (!pdata)
+		return -ENXIO;
+
+	bdev = kzalloc(sizeof(struct gpio_keys_polled_dev) +
+		       pdata->nbuttons * sizeof(struct gpio_keys_button_data),
+		       GFP_KERNEL);
+	if (!bdev) {
+		dev_err(dev, "no memory for private data\n");
+		return -ENOMEM;
+	}
+
+	bdev->data = (struct gpio_keys_button_data *) &bdev[1];
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
+		unsigned int gpio = button->gpio;
+		unsigned int type = button->type ?: EV_KEY;
+
+		if (button->wakeup) {
+			dev_err(dev, DRV_NAME " does not support wakeup\n");
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
+		bdev->data[i].can_sleep = gpio_cansleep(gpio);
+		bdev->data[i].last_state = -1;
+
+		input_set_capability(input, type, button->code);
+	}
+
+	bdev->poll_dev = poll_dev;
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
+	for (i = i - 1; i >= 0; i--)
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
+	struct gpio_keys_polled_platform_data *pdata = bdev->pdata;
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
diff --git a/include/linux/gpio_keys_polled.h b/include/linux/gpio_keys_polled.h
new file mode 100644
index 0000000..bf7f94a
--- /dev/null
+++ b/include/linux/gpio_keys_polled.h
@@ -0,0 +1,26 @@
+/*
+ *  Definitions for the GPIO buttons interface driver
+ *
+ *  Copyright (C) 2007-2010 Gabor Juhos <juhosg@openwrt.org>
+ *
+ *  This file was based on: /include/linux/gpio_keys.h
+ *	The original gpio_keys.h seems not to have a license.
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ *
+ */
+
+#ifndef _GPIO_BUTTONS_H_
+#define _GPIO_BUTTONS_H_
+
+#include <linux/gpio_keys.h>
+
+struct gpio_keys_polled_platform_data {
+	struct gpio_keys_button *buttons;
+	int	nbuttons;		/* number of buttons */
+	int	poll_interval;		/* polling interval in msecs*/
+};
+
+#endif /* _GPIO_BUTTONS_H_ */
-- 
1.7.0.4

