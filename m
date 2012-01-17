Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751182Ab2AQFqE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 00:46:04 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:13181 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748Ab2AQFqB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 00:46:01 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Mon, 16 Jan 2012 21:46:00 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: dmitry.torokhov@gmail.com, tsoni@codeaurora.org, kyle.manna@fuel7.com,
        aghayal@codeaurora.org, vapier@gentoo.org
Cc: ldewangan@nvidia.com, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH V1] input: keyboard: Add interrupt keyboard driver.
Date: Tue, 17 Jan 2012 11:11:55 +0530
Message-Id: <1326778915-2678-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver enables the key detection of the keys which
are connected to interrupt lines.
Each key is capable of generating an interrupt, and the
statesi (pressed or released) cannot be found by any
mechanism.
A key press event generated when interrupt occurs, and
based on the debounce time setting, a key release event
is generated. There is no need to read the state of the
keys.

This driver is useful on systems with an "on" or "power"
which can wake the system from suspend.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>

---
This is generic driver to support oneky/pwrbutton which
are connected to the PMIC devices.

 drivers/input/keyboard/Kconfig          |   13 ++
 drivers/input/keyboard/Makefile         |    1 +
 drivers/input/keyboard/interrupt_keys.c |  303 +++++++++++++++++++++++++++++++
 include/linux/interrupt_keys.h          |   64 +++++++
 4 files changed, 381 insertions(+), 0 deletions(-)
 create mode 100644 drivers/input/keyboard/interrupt_keys.c
 create mode 100644 include/linux/interrupt_keys.h

diff --git a/drivers/input/keyboard/Kconfig b/drivers/input/keyboard/Kconfig
index cdc385b..3d0db54 100644
--- a/drivers/input/keyboard/Kconfig
+++ b/drivers/input/keyboard/Kconfig
@@ -203,6 +203,19 @@ config KEYBOARD_GPIO_POLLED
 	  To compile this driver as a module, choose M here: the
 	  module will be called gpio_keys_polled.
 
+config KEYBOARD_INTERRUPT
+	tristate "Interrupt Buttons"
+	help
+	  This driver implements support for buttons connected
+	  directly to interrupt lines. The state of button cannot
+	  be detected and hence based on interrupt, the key event
+	  generated.
+
+	  Say Y here if your device has buttons connected
+	  directly to such interrupt lines like ONKEY. Your board-
+	  specific setup logic must also provide a platform device,
+	  with configuration data saying which interrupts are used.
+
 config KEYBOARD_TCA6416
 	tristate "TCA6416/TCA6408A Keypad Support"
 	depends on I2C
diff --git a/drivers/input/keyboard/Makefile b/drivers/input/keyboard/Makefile
index df7061f..4277e35 100644
--- a/drivers/input/keyboard/Makefile
+++ b/drivers/input/keyboard/Makefile
@@ -15,6 +15,7 @@ obj-$(CONFIG_KEYBOARD_DAVINCI)		+= davinci_keyscan.o
 obj-$(CONFIG_KEYBOARD_EP93XX)		+= ep93xx_keypad.o
 obj-$(CONFIG_KEYBOARD_GPIO)		+= gpio_keys.o
 obj-$(CONFIG_KEYBOARD_GPIO_POLLED)	+= gpio_keys_polled.o
+obj-$(CONFIG_KEYBOARD_INTERRUPT)	+= interrupt_keys.o
 obj-$(CONFIG_KEYBOARD_TCA6416)		+= tca6416-keypad.o
 obj-$(CONFIG_KEYBOARD_TCA8418)		+= tca8418_keypad.o
 obj-$(CONFIG_KEYBOARD_HIL)		+= hil_kbd.o
diff --git a/drivers/input/keyboard/interrupt_keys.c b/drivers/input/keyboard/interrupt_keys.c
new file mode 100644
index 0000000..5a6c271
--- /dev/null
+++ b/drivers/input/keyboard/interrupt_keys.c
@@ -0,0 +1,303 @@
+/*
+ * Input key driver for keys directly connected to interrupt lines.
+ * The states of keys can not be detected.
+ *
+ * Author: Laxman Dewangan <ldewangan@nvidia.com>
+ *
+ * This file is based on: /drivers/input/keyboard/gpio_keys.c
+ *      Copyright 2005 Phil Blundell
+ *
+ * Copyright (c) 2011, NVIDIA CORPORATION.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/fs.h>
+#include <linux/interrupt.h>
+#include <linux/irq.h>
+#include <linux/pm.h>
+#include <linux/delay.h>
+#include <linux/input.h>
+#include <linux/platform_device.h>
+#include <linux/interrupt_keys.h>
+#include <linux/spinlock.h>
+
+#define DRV_NAME "interrupt-keys"
+
+enum key_state {KEY_RELEASED, KEY_PRESSED};
+
+struct interrupt_button_data {
+	struct interrupt_keys_button *button;
+	struct input_dev *input;
+	struct timer_list timer;
+	int timer_debounce;	/* in msecs */
+	enum key_state key_state;
+	spinlock_t lock;
+};
+
+struct interrupt_keys_drvdata {
+	struct input_dev *input;
+	struct mutex disable_lock;
+	unsigned int n_int_buttons;
+	int (*enable)(struct device *dev);
+	void (*disable)(struct device *dev);
+	struct interrupt_button_data data[0];
+};
+
+static void interrupt_keys_timer(unsigned long _data)
+{
+	struct interrupt_button_data *bdata =
+			(struct interrupt_button_data *)_data;
+	struct interrupt_keys_button *button = bdata->button;
+	struct input_dev *input = bdata->input;
+	int type = button->key_ev_type ?: EV_KEY;
+	unsigned long iflags;
+
+	spin_lock_irqsave(&bdata->lock, iflags);
+	if (bdata->key_state == KEY_PRESSED) {
+		if (button->is_auto_release) {
+			input_event(input, type, button->key_code,
+					!button->key_value);
+			input_sync(input);
+		}
+		bdata->key_state = KEY_RELEASED;
+	} else
+		dev_info(&input->dev, "Key released, not sending any event\n");
+	spin_unlock_irqrestore(&bdata->lock, iflags);
+	return;
+}
+
+static irqreturn_t interrupt_keys_isr(int irq, void *dev_id)
+{
+	struct interrupt_button_data *bdata = dev_id;
+	struct interrupt_keys_button *button = bdata->button;
+	struct input_dev *input = bdata->input;
+	int type = button->key_ev_type ?: EV_KEY;
+	unsigned long iflags;
+
+	BUG_ON(irq != button->irq_nr);
+
+	spin_lock_irqsave(&bdata->lock, iflags);
+	if (bdata->key_state == KEY_RELEASED) {
+		input_event(input, type, button->key_code, button->key_value);
+		input_sync(input);
+		if (button->is_auto_release && !bdata->timer_debounce) {
+			input_event(input, type, button->key_code,
+						!button->key_value);
+			input_sync(input);
+			spin_unlock_irqrestore(&bdata->lock, iflags);
+			return IRQ_HANDLED;
+		}
+		bdata->key_state = KEY_PRESSED;
+	}
+
+	if ((bdata->key_state == KEY_PRESSED) && (bdata->timer_debounce)) {
+		spin_unlock_irqrestore(&bdata->lock, iflags);
+		mod_timer(&bdata->timer,
+			jiffies + msecs_to_jiffies(bdata->timer_debounce));
+		return IRQ_HANDLED;
+	}
+
+	bdata->key_state = KEY_RELEASED;
+	spin_unlock_irqrestore(&bdata->lock, iflags);
+	return IRQ_HANDLED;
+}
+
+static int __devinit interrupt_keys_setup_key(struct platform_device *pdev,
+				 struct interrupt_button_data *bdata,
+				 struct interrupt_keys_button *button)
+{
+	char *desc = button->desc ? button->desc : "interrupt_keys";
+	struct device *dev = &pdev->dev;
+	unsigned long irqflags;
+	int irq, error;
+
+	setup_timer(&bdata->timer, interrupt_keys_timer, (unsigned long)bdata);
+	spin_lock_init(&bdata->lock);
+
+	irq = button->irq_nr;
+	if (irq <= 0) {
+		error = irq;
+		dev_err(dev, "Invalid irq number %d\n", button->irq_nr);
+		goto fail;
+	}
+
+	irqflags = button->irq_flags;
+	error = request_threaded_irq(irq, NULL, interrupt_keys_isr,
+						irqflags, desc, bdata);
+	if (error)
+		dev_err(dev, "Unable to register irq %d; error %d\n",
+						irq, error);
+fail:
+	return error;
+}
+
+static int __devinit interrupt_keys_probe(struct platform_device *pdev)
+{
+	struct interrupt_keys_platform_data *pdata = pdev->dev.platform_data;
+	struct interrupt_keys_drvdata *ddata;
+	struct device *dev = &pdev->dev;
+	struct input_dev *input;
+	int i, error;
+	int wakeup = 0;
+
+	ddata = devm_kzalloc(dev, sizeof(struct interrupt_keys_drvdata) +
+			pdata->nbuttons * sizeof(struct interrupt_button_data),
+			GFP_KERNEL);
+	if (!ddata) {
+		dev_err(dev, "Failed to allocate memory\n");
+		return -ENOMEM;
+	}
+
+	input = input_allocate_device();
+	if (!input) {
+		dev_err(dev, "Failed to allocate input device\n");
+		return -ENODEV;
+	}
+
+	ddata->input = input;
+	ddata->n_int_buttons = pdata->nbuttons;
+	mutex_init(&ddata->disable_lock);
+
+	platform_set_drvdata(pdev, ddata);
+	input_set_drvdata(input, ddata);
+
+	input->name = pdev->name;
+	input->phys = "interrupt-keys/input0";
+	input->dev.parent = &pdev->dev;
+
+	input->id.bustype = BUS_HOST;
+	input->id.vendor = 0x0001;
+	input->id.product = 0x0001;
+	input->id.version = 0x0100;
+
+	for (i = 0; i < pdata->nbuttons; i++) {
+		struct interrupt_keys_button *button = &pdata->int_buttons[i];
+		struct interrupt_button_data *bdata = &ddata->data[i];
+		int type = button->key_ev_type ?: EV_KEY;
+
+		bdata->input = input;
+		bdata->button = button;
+		bdata->timer_debounce = button->debounce_interval;
+
+		error = interrupt_keys_setup_key(pdev, bdata, button);
+		if (error)
+			goto fail2;
+
+		if (button->wakeup)
+			wakeup = 1;
+
+		input_set_capability(input, type, button->key_code);
+	}
+
+	error = input_register_device(input);
+	if (error) {
+		dev_err(dev, "Unable to register input device, error: %d\n",
+						error);
+		goto fail2;
+	}
+
+	device_init_wakeup(&pdev->dev, wakeup);
+	return 0;
+
+fail2:
+	while (--i >= 0) {
+		free_irq(pdata->int_buttons[i].irq_nr, &ddata->data[i]);
+		if (ddata->data[i].timer_debounce)
+			del_timer_sync(&ddata->data[i].timer);
+	}
+
+	platform_set_drvdata(pdev, NULL);
+	input_free_device(input);
+	return error;
+}
+
+static int __devexit interrupt_keys_remove(struct platform_device *pdev)
+{
+	struct interrupt_keys_platform_data *pdata = pdev->dev.platform_data;
+	struct interrupt_keys_drvdata *ddata = platform_get_drvdata(pdev);
+	struct input_dev *input = ddata->input;
+	int i;
+
+	device_init_wakeup(&pdev->dev, 0);
+
+	for (i = 0; i < pdata->nbuttons; i++) {
+		free_irq(pdata->int_buttons[i].irq_nr, &ddata->data[i]);
+		if (ddata->data[i].timer_debounce)
+			del_timer_sync(&ddata->data[i].timer);
+	}
+	input_unregister_device(input);
+	platform_set_drvdata(pdev, NULL);
+	input_free_device(input);
+	return 0;
+}
+
+#ifdef CONFIG_PM
+static int interrupt_keys_suspend(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct interrupt_keys_platform_data *pdata = pdev->dev.platform_data;
+	struct interrupt_keys_button *button;
+	int i;
+
+	if (device_may_wakeup(&pdev->dev)) {
+		for (i = 0; i < pdata->nbuttons; i++) {
+			button = &pdata->int_buttons[i];
+			if (button->wakeup)
+				enable_irq_wake(button->irq_nr);
+		}
+	}
+	return 0;
+}
+
+static int interrupt_keys_resume(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct interrupt_keys_platform_data *pdata = pdev->dev.platform_data;
+	struct interrupt_keys_button *button;
+	int i;
+
+	for (i = 0; i < pdata->nbuttons; i++) {
+		button = &pdata->int_buttons[i];
+		if (button->wakeup && device_may_wakeup(&pdev->dev))
+			disable_irq_wake(button->irq_nr);
+	}
+	return 0;
+}
+
+static const struct dev_pm_ops interrupt_keys_pm_ops = {
+	.suspend	= interrupt_keys_suspend,
+	.resume		= interrupt_keys_resume,
+};
+#endif
+
+static struct platform_driver interrupt_keys_driver = {
+	.probe		= interrupt_keys_probe,
+	.remove		= __devexit_p(interrupt_keys_remove),
+	.driver		= {
+		.name	= DRV_NAME,
+		.owner	= THIS_MODULE,
+#ifdef CONFIG_PM
+		.pm	= &interrupt_keys_pm_ops,
+#endif
+	}
+};
+
+module_platform_driver(interrupt_keys_driver);
+
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR("Laxman Dewangan <ldewangan@nvidia.com>");
+MODULE_DESCRIPTION("Keyboard driver for keys connected to interrupts");
+MODULE_ALIAS("platform:" DRV_NAME);
diff --git a/include/linux/interrupt_keys.h b/include/linux/interrupt_keys.h
new file mode 100644
index 0000000..26f4136
--- /dev/null
+++ b/include/linux/interrupt_keys.h
@@ -0,0 +1,64 @@
+/*
+ * Input driver for keys directly connected to interrupt lines.
+ *
+ *
+ * Copyright (c) 2011, NVIDIA CORPORATION.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#ifndef _LINUX_INTERRUPT_KEYS_H
+#define _LINUX_INTERRUPT_KEYS_H
+
+/*
+ * interrupt_keys_button: The details of button for key configuration.
+ *
+ * @desc:		Button description.
+ * @irq_nr:		Interrupt number of button on which it is connected.
+ * @irq_flags:		Irq flags to request for irq.
+ * @wakeup:		configure the interrupt source as a wake-up source.
+ * @key_ev_type:	Key event type i.e. EV_KEY, EV_SW
+ * @key_code:		Key code i.e. KEY_*, SW_*
+ * @key_value:		value for the key code event i.e. 1 or 0 when this
+ *			interrupt occurs.
+ * @is_auto_release:	Send key release event after debounce_interval timer.
+			expires.
+ * @debounce_interval:	debounce ticks interval in msecs for sending
+ *			another event. A interrupt from this key will
+ *			not send any event until timer expires. The timer
+ *			restart again if interrupt occurs during this time.
+ */
+struct interrupt_keys_button {
+	char *desc;
+	int irq_nr;
+	int irq_flags;
+	int wakeup;
+	int key_ev_type;
+	int key_code;
+	int key_value;
+	bool is_auto_release;
+	int debounce_interval;
+};
+
+/*
+ * interrupt_keys_platform_data: Platform data for interrupt keys.
+ *
+ * @interrupt_keys_button: Configuration detail of buttons.
+ * @nbuttons: Number of buttons.
+ */
+struct interrupt_keys_platform_data {
+	struct interrupt_keys_button *int_buttons;
+	int nbuttons;
+};
+
+#endif /* _LINUX_INTERRUPT_KEYS_H */
-- 
1.7.1.1

