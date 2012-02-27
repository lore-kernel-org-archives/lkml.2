Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753999Ab2B0MPl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 07:15:41 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:47239 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753948Ab2B0MPg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 07:15:36 -0500
MIME-version: 1.0
Content-transfer-encoding: 8BIT
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee61b-b7c62ae000000989-66-4f4b73e43d61
From: MyungJoo Ham <myungjoo.ham@samsung.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: NeilBrown <neilb@suse.de>, Randy Dunlap <rdunlap@xenotime.net>,
        Mike Lockwood <lockwood@android.com>,
        =?UTF-8?q?Arve=20Hj=C3=B8nnevag?= <arve@android.com>,
        Kyungmin Park <kyungmin.park@samsung.com>, gregkh@linuxfoundation.org,
        Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Morten CHRISTIANSEN <morten.christiansen@stericsson.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        John Stultz <john.stultz@linaro.org>,
        Joerg Roedel <joerg.roedel@amd.com>, myungjoo.ham@gmail.com
Subject: [PATCH v6 2/5] Extcon: support generic GPIO extcon driver
Date: Mon, 27 Feb 2012 21:15:36 +0900
Message-id: <1330344939-18394-3-git-send-email-myungjoo.ham@samsung.com>
X-Mailer: git-send-email 1.7.4.1
In-reply-to: <1330344939-18394-1-git-send-email-myungjoo.ham@samsung.com>
References: <1328856038-21912-1-git-send-email-myungjoo.ham@samsung.com>
 <1330344939-18394-1-git-send-email-myungjoo.ham@samsung.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The generic GPIO extcon driver (an external connector device based on
GPIO control) and imported from Android kernel.

switch: switch class and GPIO drivers. (splitted)
Author: Mike Lockwood <lockwood@android.com>

switch: gpio: Don't call request_irq with interrupts disabled
Author: Arve Hjønnevåg <arve@android.com>

switch_gpio: Add missing #include <linux/interrupt.h>
Author: Mike Lockwood <lockwood@android.com>

Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>

--
Changed from v5:
- Splitted at v5 from the main extcon patch.
- Added debounce time for irq handlers.
- Use request_any_context_irq instead of request_irq
- User needs to specify irq flags for GPIO interrupts (was fixed to
IRQF_TRIGGER_LOW before)
- Use module_platform_driver().
---
 drivers/extcon/Kconfig             |    7 ++
 drivers/extcon/Makefile            |    1 +
 drivers/extcon/extcon_gpio.c       |  175 ++++++++++++++++++++++++++++++++++++
 include/linux/extcon/extcon_gpio.h |   52 +++++++++++
 4 files changed, 235 insertions(+), 0 deletions(-)
 create mode 100644 drivers/extcon/extcon_gpio.c
 create mode 100644 include/linux/extcon/extcon_gpio.h

diff --git a/drivers/extcon/Kconfig b/drivers/extcon/Kconfig
index 11db865..cc3f5eb 100644
--- a/drivers/extcon/Kconfig
+++ b/drivers/extcon/Kconfig
@@ -25,4 +25,11 @@ config EXTCON_ANDROID_COMPATIBLE
 
 comment "Extcon Device Drivers"
 
+config EXTCON_GPIO
+	tristate "GPIO extcon support"
+	depends on GENERIC_GPIO
+	help
+	  Say Y here to enable GPIO based extcon support. Note that GPIO
+	  extcon supports single state per extcon instance.
+
 endif # MULTISTATE_SWITCH
diff --git a/drivers/extcon/Makefile b/drivers/extcon/Makefile
index 6bc6921..2c46d41 100644
--- a/drivers/extcon/Makefile
+++ b/drivers/extcon/Makefile
@@ -3,3 +3,4 @@
 #
 
 obj-$(CONFIG_EXTCON)		+= extcon_class.o
+obj-$(CONFIG_EXTCON_GPIO)	+= extcon_gpio.o
diff --git a/drivers/extcon/extcon_gpio.c b/drivers/extcon/extcon_gpio.c
new file mode 100644
index 0000000..f24ec67
--- /dev/null
+++ b/drivers/extcon/extcon_gpio.c
@@ -0,0 +1,175 @@
+/*
+ *  drivers/extcon/extcon_gpio.c
+ *
+ *  Single-state GPIO extcon driver based on extcon class
+ *
+ * Copyright (C) 2008 Google, Inc.
+ * Author: Mike Lockwood <lockwood@android.com>
+ *
+ * Modified by MyungJoo Ham <myungjoo.ham@samsung.com> to support extcon
+ * (originally switch class is supported)
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
+*/
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+#include <linux/extcon.h>
+#include <linux/workqueue.h>
+#include <linux/gpio.h>
+#include <linux/extcon.h>
+#include <linux/extcon/extcon_gpio.h>
+
+struct gpio_extcon_data {
+	struct extcon_dev edev;
+	unsigned gpio;
+	const char *state_on;
+	const char *state_off;
+	int irq;
+	struct delayed_work work;
+	unsigned long debounce_jiffies;
+};
+
+static void gpio_extcon_work(struct work_struct *work)
+{
+	int state;
+	struct gpio_extcon_data	*data =
+		container_of(to_delayed_work(work), struct gpio_extcon_data,
+			     work);
+
+	state = gpio_get_value(data->gpio);
+	extcon_set_state(&data->edev, state);
+}
+
+static irqreturn_t gpio_irq_handler(int irq, void *dev_id)
+{
+	struct gpio_extcon_data *extcon_data =
+	    (struct gpio_extcon_data *)dev_id;
+
+	schedule_delayed_work(&extcon_data->work,
+			      extcon_data->debounce_jiffies);
+	return IRQ_HANDLED;
+}
+
+static ssize_t extcon_gpio_print_state(struct extcon_dev *edev, char *buf)
+{
+	struct gpio_extcon_data	*extcon_data =
+		container_of(edev, struct gpio_extcon_data, edev);
+	const char *state;
+	if (extcon_get_state(edev))
+		state = extcon_data->state_on;
+	else
+		state = extcon_data->state_off;
+
+	if (state)
+		return sprintf(buf, "%s\n", state);
+	return -EINVAL;
+}
+
+static int gpio_extcon_probe(struct platform_device *pdev)
+{
+	struct gpio_extcon_platform_data *pdata = pdev->dev.platform_data;
+	struct gpio_extcon_data *extcon_data;
+	int ret = 0;
+
+	if (!pdata)
+		return -EBUSY;
+	if (!pdata->irq_flags) {
+		dev_err(&pdev->dev, "IRQ flag is not specified.\n");
+		return -EINVAL;
+	}
+
+	extcon_data = devm_kzalloc(&pdev->dev, sizeof(struct gpio_extcon_data),
+				   GFP_KERNEL);
+	if (!extcon_data)
+		return -ENOMEM;
+
+	extcon_data->edev.name = pdata->name;
+	extcon_data->gpio = pdata->gpio;
+	extcon_data->state_on = pdata->state_on;
+	extcon_data->state_off = pdata->state_off;
+	if (pdata->state_on && pdata->state_off)
+		extcon_data->edev.print_state = extcon_gpio_print_state;
+	extcon_data->debounce_jiffies = msecs_to_jiffies(pdata->debounce);
+
+	ret = extcon_dev_register(&extcon_data->edev, &pdev->dev);
+	if (ret < 0)
+		goto err_extcon_dev_register;
+
+	ret = gpio_request(extcon_data->gpio, pdev->name);
+	if (ret < 0)
+		goto err_request_gpio;
+
+	ret = gpio_direction_input(extcon_data->gpio);
+	if (ret < 0)
+		goto err_set_gpio_input;
+
+	INIT_DELAYED_WORK(&extcon_data->work, gpio_extcon_work);
+
+	extcon_data->irq = gpio_to_irq(extcon_data->gpio);
+	if (extcon_data->irq < 0) {
+		ret = extcon_data->irq;
+		goto err_detect_irq_num_failed;
+	}
+
+	ret = request_any_context_irq(extcon_data->irq, gpio_irq_handler,
+				      pdata->irq_flags, pdev->name,
+				      extcon_data);
+	if (ret < 0)
+		goto err_request_irq;
+
+	/* Perform initial detection */
+	gpio_extcon_work(&extcon_data->work.work);
+
+	return 0;
+
+err_request_irq:
+err_detect_irq_num_failed:
+err_set_gpio_input:
+	gpio_free(extcon_data->gpio);
+err_request_gpio:
+	extcon_dev_unregister(&extcon_data->edev);
+err_extcon_dev_register:
+	devm_kfree(&pdev->dev, extcon_data);
+
+	return ret;
+}
+
+static int gpio_extcon_remove(struct platform_device *pdev)
+{
+	struct gpio_extcon_data *extcon_data = platform_get_drvdata(pdev);
+
+	cancel_delayed_work_sync(&extcon_data->work);
+	gpio_free(extcon_data->gpio);
+	extcon_dev_unregister(&extcon_data->edev);
+	devm_kfree(&pdev->dev, extcon_data);
+
+	return 0;
+}
+
+static struct platform_driver gpio_extcon = {
+	.probe		= gpio_extcon_probe,
+	.remove		= gpio_extcon_remove,
+	.driver		= {
+		.name	= "extcon-gpio",
+		.owner	= THIS_MODULE,
+	},
+};
+
+module_platform_driver(gpio_extcon);
+
+MODULE_AUTHOR("Mike Lockwood <lockwood@android.com>");
+MODULE_DESCRIPTION("GPIO extcon driver");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/extcon/extcon_gpio.h b/include/linux/extcon/extcon_gpio.h
new file mode 100644
index 0000000..a2129b7
--- /dev/null
+++ b/include/linux/extcon/extcon_gpio.h
@@ -0,0 +1,52 @@
+/*
+ *  External connector (extcon) class generic GPIO driver
+ *
+ * Copyright (C) 2012 Samsung Electronics
+ * Author: MyungJoo Ham <myungjoo.ham@samsung.com>
+ *
+ * based on switch class driver
+ * Copyright (C) 2008 Google, Inc.
+ * Author: Mike Lockwood <lockwood@android.com>
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
+*/
+#ifndef __EXTCON_GPIO_H__
+#define __EXTCON_GPIO_H__ __FILE__
+
+#include <linux/extcon.h>
+
+/**
+ * struct gpio_extcon_platform_data - A simple GPIO-controlled extcon device.
+ * @name	The name of this GPIO extcon device.
+ * @gpio	Corresponding GPIO.
+ * @debounce	Debounce time for GPIO IRQ in ms.
+ * @irq_flags	IRQ Flags (e.g., IRQF_TRIGGER_LOW).
+ * @state_on	print_state is overriden with state_on if attached. If Null,
+ *		default method of extcon class is used.
+ * @state_off	print_state is overriden with state_on if dettached. If Null,
+ *		default method of extcon class is used.
+ *
+ * Note that in order for state_on or state_off to be valid, both state_on
+ * and state_off should be not NULL. If at least one of them is NULL,
+ * the print_state is not overriden.
+ */
+struct gpio_extcon_platform_data {
+	const char *name;
+	unsigned gpio;
+	unsigned long debounce;
+	unsigned long irq_flags;
+
+	/* if NULL, "0" or "1" will be printed */
+	const char *state_on;
+	const char *state_off;
+};
+
+#endif /* __EXTCON_GPIO_H__ */
-- 
1.7.4.1

