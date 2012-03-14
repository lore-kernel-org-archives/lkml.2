Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760126Ab2CNI4Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 04:56:25 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:7752 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759332Ab2CNI4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 04:56:20 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 14 Mar 2012 01:56:19 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: dmitry.torokhov@gmail.com, grant.likely@secretlab.ca,
        linus.walleij@stericsson.com, david@protonic.nl, tklauser@distanz.ch,
        alexander.stein@informatik.tu-chemnitz.de
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        ldewangan@nvidia.com
Subject: [PATCH V1] input: keyboard: gpio: Support for interrupt only key
Date: Wed, 14 Mar 2012 14:22:03 +0530
Message-Id: <1331715123-15099-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some of key in system generates interrupt only when it
pressed like power-on key or onkey. These keys do not
actually mapped as gpio in system.
Supporting the key pressed event on such keys which are
not actually gpio keys but generates interrupt only.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
When I pushed the new driver for interrupt key, the suggestion came
to include this functionality in the gpio-key driver. I added require
changed in gpio-keys.c to support interrupt key only.

 drivers/input/keyboard/gpio_keys.c |  117 +++++++++++++++++++++++++++++++++--
 include/linux/gpio_keys.h          |    3 +-
 2 files changed, 112 insertions(+), 8 deletions(-)

diff --git a/drivers/input/keyboard/gpio_keys.c b/drivers/input/keyboard/gpio_keys.c
index ed1ed46..d38ddfd 100644
--- a/drivers/input/keyboard/gpio_keys.c
+++ b/drivers/input/keyboard/gpio_keys.c
@@ -28,6 +28,7 @@
 #include <linux/gpio.h>
 #include <linux/of_platform.h>
 #include <linux/of_gpio.h>
+#include <linux/spinlock.h>
 
 struct gpio_button_data {
 	struct gpio_keys_button *button;
@@ -36,6 +37,8 @@ struct gpio_button_data {
 	struct work_struct work;
 	int timer_debounce;	/* in msecs */
 	bool disabled;
+	spinlock_t lock;
+	bool key_pressed;
 };
 
 struct gpio_keys_drvdata {
@@ -95,6 +98,13 @@ static inline int get_n_events_by_type(int type)
 	return (type == EV_KEY) ? KEY_CNT : SW_CNT;
 }
 
+static int button_irq(struct gpio_keys_button *button)
+{
+	if (gpio_is_valid(button->gpio))
+		return gpio_to_irq(button->gpio);
+	return button->irq;
+}
+
 /**
  * gpio_keys_disable_button() - disables given GPIO button
  * @bdata: button data for button to be disabled
@@ -111,10 +121,11 @@ static inline int get_n_events_by_type(int type)
 static void gpio_keys_disable_button(struct gpio_button_data *bdata)
 {
 	if (!bdata->disabled) {
+		int irq = button_irq(bdata->button);
 		/*
 		 * Disable IRQ and possible debouncing timer.
 		 */
-		disable_irq(gpio_to_irq(bdata->button->gpio));
+		disable_irq(irq);
 		if (bdata->timer_debounce)
 			del_timer_sync(&bdata->timer);
 
@@ -135,7 +146,8 @@ static void gpio_keys_disable_button(struct gpio_button_data *bdata)
 static void gpio_keys_enable_button(struct gpio_button_data *bdata)
 {
 	if (bdata->disabled) {
-		enable_irq(gpio_to_irq(bdata->button->gpio));
+		int irq = button_irq(bdata->button);
+		enable_irq(irq);
 		bdata->disabled = false;
 	}
 }
@@ -325,8 +337,12 @@ static void gpio_keys_report_event(struct gpio_button_data *bdata)
 	struct gpio_keys_button *button = bdata->button;
 	struct input_dev *input = bdata->input;
 	unsigned int type = button->type ?: EV_KEY;
-	int state = (gpio_get_value_cansleep(button->gpio) ? 1 : 0) ^ button->active_low;
+	int state;
 
+	if (!gpio_is_valid(button->gpio))
+		return;
+
+	state = (gpio_get_value_cansleep(button->gpio) ? 1 : 0) ^ button->active_low;
 	if (type == EV_ABS) {
 		if (state)
 			input_event(input, type, button->code, button->value);
@@ -367,6 +383,85 @@ static irqreturn_t gpio_keys_isr(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
+static void interrupt_keys_timer(unsigned long _data)
+{
+	struct gpio_button_data *bdata = (struct gpio_button_data *)_data;
+	struct gpio_keys_button *button = bdata->button;
+	struct input_dev *input = bdata->input;
+	unsigned int type = button->type ?: EV_KEY;
+	unsigned long iflags;
+
+	spin_lock_irqsave(&bdata->lock, iflags);
+	if (bdata->key_pressed) {
+		input_event(input, type, button->code, 0);
+		input_sync(input);
+		bdata->key_pressed = false;
+	}
+	spin_unlock_irqrestore(&bdata->lock, iflags);
+}
+
+static irqreturn_t interrupt_keys_isr(int irq, void *dev_id)
+{
+	struct gpio_button_data *bdata = dev_id;
+	struct gpio_keys_button *button = bdata->button;
+	struct input_dev *input = bdata->input;
+	int type = button->type ?: EV_KEY;
+	unsigned long iflags;
+
+	BUG_ON(irq != button->irq);
+
+	spin_lock_irqsave(&bdata->lock, iflags);
+	if (!bdata->key_pressed) {
+		input_event(input, type, button->code, 1);
+		input_sync(input);
+		if (!bdata->timer_debounce) {
+			input_event(input, type, button->code, 0);
+			input_sync(input);
+			spin_unlock_irqrestore(&bdata->lock, iflags);
+			return IRQ_HANDLED;
+		}
+		bdata->key_pressed = true;
+	}
+
+	spin_unlock_irqrestore(&bdata->lock, iflags);
+	if (bdata->timer_debounce)
+		mod_timer(&bdata->timer,
+			jiffies + msecs_to_jiffies(bdata->timer_debounce));
+	return IRQ_HANDLED;
+}
+
+static int __devinit interrupt_keys_setup_key(struct platform_device *pdev,
+					 struct gpio_button_data *bdata,
+					 struct gpio_keys_button *button)
+{
+	const char *desc = button->desc ? button->desc : "gpio_keys";
+	struct device *dev = &pdev->dev;
+	unsigned long irqflags = 0;
+	int irq, error;
+
+	if (button->debounce_interval) {
+		setup_timer(&bdata->timer, interrupt_keys_timer,
+						(unsigned long)bdata);
+		bdata->timer_debounce = button->debounce_interval;
+	}
+	spin_lock_init(&bdata->lock);
+	irq = button->irq;
+	if (irq <= 0) {
+		dev_err(dev, "%s(): Invalid irq number %d\n", __func__, irq);
+		return -EINVAL;
+	}
+	bdata->key_pressed = false;
+	if (!button->can_disable)
+		irqflags |= IRQF_SHARED;
+
+	error = request_threaded_irq(irq, NULL, interrupt_keys_isr,
+					irqflags, desc, bdata);
+	if (error < 0)
+		dev_err(dev, "Unable to claim irq %d; error %d\n",
+				irq, error);
+	return error;
+}
+
 static int __devinit gpio_keys_setup_key(struct platform_device *pdev,
 					 struct gpio_button_data *bdata,
 					 struct gpio_keys_button *button)
@@ -376,6 +471,9 @@ static int __devinit gpio_keys_setup_key(struct platform_device *pdev,
 	unsigned long irqflags;
 	int irq, error;
 
+	if (!gpio_is_valid(button->gpio))
+		return interrupt_keys_setup_key(pdev, bdata, button);
+
 	setup_timer(&bdata->timer, gpio_keys_timer, (unsigned long)bdata);
 	INIT_WORK(&bdata->work, gpio_keys_work_func);
 
@@ -643,9 +741,12 @@ static int __devinit gpio_keys_probe(struct platform_device *pdev)
 	sysfs_remove_group(&pdev->dev.kobj, &gpio_keys_attr_group);
  fail2:
 	while (--i >= 0) {
-		free_irq(gpio_to_irq(pdata->buttons[i].gpio), &ddata->data[i]);
+		int irq = button_irq(&pdata->buttons[i]);
+		free_irq(irq, &ddata->data[i]);
 		if (ddata->data[i].timer_debounce)
 			del_timer_sync(&ddata->data[i].timer);
+		if (!gpio_is_valid(pdata->buttons[i].gpio))
+			continue;
 		cancel_work_sync(&ddata->data[i].work);
 		gpio_free(pdata->buttons[i].gpio);
 	}
@@ -672,10 +773,12 @@ static int __devexit gpio_keys_remove(struct platform_device *pdev)
 	device_init_wakeup(&pdev->dev, 0);
 
 	for (i = 0; i < ddata->n_buttons; i++) {
-		int irq = gpio_to_irq(ddata->data[i].button->gpio);
+		int irq = button_irq(ddata->data[i].button);
 		free_irq(irq, &ddata->data[i]);
 		if (ddata->data[i].timer_debounce)
 			del_timer_sync(&ddata->data[i].timer);
+		if (!gpio_is_valid(ddata->data[i].button->gpio))
+			continue;
 		cancel_work_sync(&ddata->data[i].work);
 		gpio_free(ddata->data[i].button->gpio);
 	}
@@ -705,7 +808,7 @@ static int gpio_keys_suspend(struct device *dev)
 		for (i = 0; i < ddata->n_buttons; i++) {
 			struct gpio_keys_button *button = ddata->data[i].button;
 			if (button->wakeup) {
-				int irq = gpio_to_irq(button->gpio);
+				int irq = button_irq(button);
 				enable_irq_wake(irq);
 			}
 		}
@@ -723,7 +826,7 @@ static int gpio_keys_resume(struct device *dev)
 
 		struct gpio_keys_button *button = ddata->data[i].button;
 		if (button->wakeup && device_may_wakeup(dev)) {
-			int irq = gpio_to_irq(button->gpio);
+			int irq = button_irq(button);
 			disable_irq_wake(irq);
 		}
 
diff --git a/include/linux/gpio_keys.h b/include/linux/gpio_keys.h
index 004ff33..dddcc95 100644
--- a/include/linux/gpio_keys.h
+++ b/include/linux/gpio_keys.h
@@ -6,7 +6,8 @@ struct device;
 struct gpio_keys_button {
 	/* Configuration parameters */
 	unsigned int code;	/* input event code (KEY_*, SW_*) */
-	int gpio;
+	int gpio;		/* -1 if this key does not support gpio */
+	int irq;		/* Irq number in case of interrupt keys */
 	int active_low;
 	const char *desc;
 	unsigned int type;	/* input event type (EV_KEY, EV_SW, EV_ABS) */
-- 
1.7.1.1

