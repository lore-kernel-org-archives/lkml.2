Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932239Ab0KSViL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 16:38:11 -0500
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:40772 "HELO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756741Ab0KSVh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 16:37:29 -0500
From: Ben Gardiner <bengardiner@nanometrics.ca>
To: Kevin Hilman <khilman@deeprootsystems.com>,
        davinci-linux-open-source@linux.davincidsp.com,
        linux-input@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Chris Cordahi <christophercordahi@nanometrics.ca>,
        Paul Mundt <lethal@linux-sh.org>, Sekhar Nori <nsekhar@ti.com>,
        Alexander Clouter <alex@digriz.org.uk>
Subject: [PATCH v3 1/4] input: gpio_keys: polling mode support
Date: Fri, 19 Nov 2010 16:37:20 -0500
Message-Id: <860d58a7de235648ec637c1fec8c817307af549a.1290201713.git.bengardiner@nanometrics.ca>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <cover.1290201713.git.bengardiner@nanometrics.ca>
References: <cover.1289935504.git.bengardiner@nanometrics.ca> <cover.1290201713.git.bengardiner@nanometrics.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Clouter <alex@digriz.org.uk>

This implements an optional polling mode for the gpio_keys driver,
necessary for GPIOs that are not able to generate IRQs.

gpio_keys_platform_data has been extended with poll_interval
which specifies the polling interval in ms, this is passed onto
input-polldev.

This work is a rebase of the patch by Alex Clouter [1] which was
based on the patch [2] originally conceived by Paul Mundt.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Alexander Clouter <alex@digriz.org.uk>
Signed-off-by: Ben Gardiner <bengardiner@nanometrics.ca>
Reviewed-by: Chris Cordahi <christophercordahi@nanometrics.ca>
CC: Paul Mundt <lethal@linux-sh.org>

[1] http://article.gmane.org/gmane.linux.kernel.input/13919
[2] http://article.gmane.org/gmane.linux.kernel.input/5814

---

Changes since v2:
 * rebased to 083eae3e28643e0eefc5243719f8b1572cf98299 of
  git://git.kernel.org/pub/scm/linux/kernel/git/khilman/linux-davinci.git

Changes since v1:
 * use locally defined functions that are no-ops/error checkers when
  INPUT_POLLDEV is not defined.
 * disable polling mode support when input-polldev is a module and gpio_keys
  is builtin

Changes since [1]:
 * rebased to 0b1c3ef1072f2b97c86351d3736d2b2d00293a11 of
  git://git.kernel.org/pub/scm/linux/kernel/git/khilman/linux-davinci.git
 * use _cansleep variant of gpio_get_value in the polling task
  to avoid WARN_ON when using I2C GPIO expanders
 * prevent unitialized access to 'input' in gpio_keys_close()

Changes since [2]:
 * absolute dependency on INPUT_POLLDEV removed

Tested with CONFIG_INPUT_POLLDEV={n,m,y} (gpio_keys as module for 'm').

---
 drivers/input/keyboard/gpio_keys.c |  120 ++++++++++++++++++++++++++++++------
 include/linux/gpio_keys.h          |    1 +
 2 files changed, 103 insertions(+), 18 deletions(-)

diff --git a/drivers/input/keyboard/gpio_keys.c b/drivers/input/keyboard/gpio_keys.c
index 6069abe..d2f23d9 100644
--- a/drivers/input/keyboard/gpio_keys.c
+++ b/drivers/input/keyboard/gpio_keys.c
@@ -1,7 +1,9 @@
 /*
- * Driver for keys on GPIO lines capable of generating interrupts.
+ * Driver for keys on GPIO lines, either IRQ-driven or polled.
  *
  * Copyright 2005 Phil Blundell
+ * Copyright 2008 Paul Mundt
+ * Copyright 2010 Alexander Clouter <alex@digriz.org.uk>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -25,6 +27,7 @@
 #include <linux/gpio_keys.h>
 #include <linux/workqueue.h>
 #include <linux/gpio.h>
+#include <linux/input-polldev.h>
 
 struct gpio_button_data {
 	struct gpio_keys_button *button;
@@ -37,6 +40,7 @@ struct gpio_button_data {
 
 struct gpio_keys_drvdata {
 	struct input_dev *input;
+	struct input_polled_dev *poll_dev;
 	struct mutex disable_lock;
 	unsigned int n_buttons;
 	int (*enable)(struct device *dev);
@@ -44,6 +48,30 @@ struct gpio_keys_drvdata {
 	struct gpio_button_data data[0];
 };
 
+#if (!defined(CONFIG_INPUT_POLLDEV) && !defined(CONFIG_INPUT_POLLDEV_MODULE)) \
+	|| (defined(CONFIG_INPUT_POLLDEV_MODULE) \
+		&& !defined(CONFIG_KEYBOARD_GPIO_MODULE))
+
+static inline struct input_polled_dev *allocate_polled_device(
+					const struct device *dev)
+{
+	dev_err(dev, "device needs polling (enable INPUT_POLLDEV)\n");
+	return NULL;
+}
+
+#define free_polled_device(x)		do { } while (0)
+#define register_polled_device(x)	(-ENXIO)
+#define unregister_polled_device(x)	do { } while (0)
+
+#else
+
+#define allocate_polled_device(x)	input_allocate_polled_device()
+#define free_polled_device(x)		input_free_polled_device(x)
+#define register_polled_device(x)	input_register_polled_device(x)
+#define unregister_polled_device(x)	input_unregister_polled_device(x)
+
+#endif
+
 /*
  * SYSFS interface for enabling/disabling keys and switches:
  *
@@ -322,7 +350,8 @@ static void gpio_keys_report_event(struct gpio_button_data *bdata)
 	struct gpio_keys_button *button = bdata->button;
 	struct input_dev *input = bdata->input;
 	unsigned int type = button->type ?: EV_KEY;
-	int state = (gpio_get_value(button->gpio) ? 1 : 0) ^ button->active_low;
+	int state = (gpio_get_value_cansleep(button->gpio) ? 1 : 0)
+			^ button->active_low;
 
 	input_event(input, type, button->code, !!state);
 	input_sync(input);
@@ -343,6 +372,16 @@ static void gpio_keys_timer(unsigned long _data)
 	schedule_work(&data->work);
 }
 
+static void gpio_handle_button_event(struct gpio_keys_button *button,
+				     struct gpio_button_data *bdata)
+{
+	if (bdata->timer_debounce)
+		mod_timer(&bdata->timer,
+			jiffies + msecs_to_jiffies(bdata->timer_debounce));
+	else
+		gpio_keys_report_event(bdata);
+}
+
 static irqreturn_t gpio_keys_isr(int irq, void *dev_id)
 {
 	struct gpio_button_data *bdata = dev_id;
@@ -350,15 +389,24 @@ static irqreturn_t gpio_keys_isr(int irq, void *dev_id)
 
 	BUG_ON(irq != gpio_to_irq(button->gpio));
 
-	if (bdata->timer_debounce)
-		mod_timer(&bdata->timer,
-			jiffies + msecs_to_jiffies(bdata->timer_debounce));
-	else
-		schedule_work(&bdata->work);
+	gpio_handle_button_event(button, bdata);
 
 	return IRQ_HANDLED;
 }
 
+static void gpio_keys_poll(struct input_polled_dev *dev)
+{
+	struct gpio_keys_drvdata *ddata = dev->private;
+	int i;
+
+	for (i = 0; i < ddata->n_buttons; i++) {
+		struct gpio_button_data *bdata = &ddata->data[i];
+		struct gpio_keys_button *button = bdata->button;
+
+		gpio_handle_button_event(button, bdata);
+	}
+}
+
 static int __devinit gpio_keys_setup_key(struct platform_device *pdev,
 					 struct gpio_button_data *bdata,
 					 struct gpio_keys_button *button)
@@ -446,20 +494,28 @@ static int __devinit gpio_keys_probe(struct platform_device *pdev)
 	struct gpio_keys_drvdata *ddata;
 	struct device *dev = &pdev->dev;
 	struct input_dev *input;
+	struct input_polled_dev *poll_dev;
 	int i, error;
 	int wakeup = 0;
 
 	ddata = kzalloc(sizeof(struct gpio_keys_drvdata) +
 			pdata->nbuttons * sizeof(struct gpio_button_data),
 			GFP_KERNEL);
-	input = input_allocate_device();
+	if (pdata->poll_interval) {
+		poll_dev = allocate_polled_device(dev);
+		input = poll_dev ? poll_dev->input : 0;
+	} else
+		input = input_allocate_device();
 	if (!ddata || !input) {
 		dev_err(dev, "failed to allocate state\n");
 		error = -ENOMEM;
 		goto fail1;
 	}
 
-	ddata->input = input;
+	if (pdata->poll_interval)
+		ddata->poll_dev = poll_dev;
+	else
+		ddata->input = input;
 	ddata->n_buttons = pdata->nbuttons;
 	ddata->enable = pdata->enable;
 	ddata->disable = pdata->disable;
@@ -468,6 +524,12 @@ static int __devinit gpio_keys_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, ddata);
 	input_set_drvdata(input, ddata);
 
+	if (pdata->poll_interval) {
+		poll_dev->private = ddata;
+		poll_dev->poll = gpio_keys_poll;
+		poll_dev->poll_interval = pdata->poll_interval;
+	}
+
 	input->name = pdev->name;
 	input->phys = "gpio-keys/input0";
 	input->dev.parent = &pdev->dev;
@@ -491,14 +553,17 @@ static int __devinit gpio_keys_probe(struct platform_device *pdev)
 		bdata->input = input;
 		bdata->button = button;
 
+		input_set_capability(input, type, button->code);
+
+		if (pdata->poll_interval)
+			continue;
+
 		error = gpio_keys_setup_key(pdev, bdata, button);
 		if (error)
 			goto fail2;
 
 		if (button->wakeup)
 			wakeup = 1;
-
-		input_set_capability(input, type, button->code);
 	}
 
 	error = sysfs_create_group(&pdev->dev.kobj, &gpio_keys_attr_group);
@@ -508,7 +573,10 @@ static int __devinit gpio_keys_probe(struct platform_device *pdev)
 		goto fail2;
 	}
 
-	error = input_register_device(input);
+	if (pdata->poll_interval)
+		error = register_polled_device(poll_dev);
+	else
+		error = input_register_device(input);
 	if (error) {
 		dev_err(dev, "Unable to register input device, error: %d\n",
 			error);
@@ -528,7 +596,9 @@ static int __devinit gpio_keys_probe(struct platform_device *pdev)
 	sysfs_remove_group(&pdev->dev.kobj, &gpio_keys_attr_group);
  fail2:
 	while (--i >= 0) {
-		free_irq(gpio_to_irq(pdata->buttons[i].gpio), &ddata->data[i]);
+		if (!pdata->poll_interval)
+			free_irq(gpio_to_irq(pdata->buttons[i].gpio),
+				&ddata->data[i]);
 		if (ddata->data[i].timer_debounce)
 			del_timer_sync(&ddata->data[i].timer);
 		cancel_work_sync(&ddata->data[i].work);
@@ -537,7 +607,10 @@ static int __devinit gpio_keys_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, NULL);
  fail1:
-	input_free_device(input);
+	if (pdata->poll_interval)
+		free_polled_device(poll_dev);
+	else
+		input_free_device(input);
 	kfree(ddata);
 
 	return error;
@@ -547,7 +620,8 @@ static int __devexit gpio_keys_remove(struct platform_device *pdev)
 {
 	struct gpio_keys_platform_data *pdata = pdev->dev.platform_data;
 	struct gpio_keys_drvdata *ddata = platform_get_drvdata(pdev);
-	struct input_dev *input = ddata->input;
+	struct input_dev *input;
+	struct input_polled_dev *poll_dev;
 	int i;
 
 	sysfs_remove_group(&pdev->dev.kobj, &gpio_keys_attr_group);
@@ -555,15 +629,25 @@ static int __devexit gpio_keys_remove(struct platform_device *pdev)
 	device_init_wakeup(&pdev->dev, 0);
 
 	for (i = 0; i < pdata->nbuttons; i++) {
-		int irq = gpio_to_irq(pdata->buttons[i].gpio);
-		free_irq(irq, &ddata->data[i]);
+		if (!pdata->poll_interval) {
+			int irq = gpio_to_irq(pdata->buttons[i].gpio);
+			free_irq(irq, &ddata->data[i]);
+		}
 		if (ddata->data[i].timer_debounce)
 			del_timer_sync(&ddata->data[i].timer);
 		cancel_work_sync(&ddata->data[i].work);
 		gpio_free(pdata->buttons[i].gpio);
 	}
 
-	input_unregister_device(input);
+	if (pdata->poll_interval) {
+		poll_dev = ddata->poll_dev;
+		unregister_polled_device(poll_dev);
+		free_polled_device(poll_dev);
+	} else {
+		input = ddata->input;
+		input_unregister_device(input);
+		input_free_device(input);
+	}
 
 	return 0;
 }
diff --git a/include/linux/gpio_keys.h b/include/linux/gpio_keys.h
index ce73a30..5fdd495 100644
--- a/include/linux/gpio_keys.h
+++ b/include/linux/gpio_keys.h
@@ -19,6 +19,7 @@ struct gpio_keys_platform_data {
 	unsigned int rep:1;		/* enable input subsystem auto repeat */
 	int (*enable)(struct device *dev);
 	void (*disable)(struct device *dev);
+	unsigned int poll_interval;	/* polling interval in ms */
 };
 
 #endif
-- 
1.7.0.4

