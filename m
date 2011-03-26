Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753184Ab1CZQxW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Mar 2011 12:53:22 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:41595 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752575Ab1CZQxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Mar 2011 12:53:20 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6296"; a="82257170"
From: Anirudh Ghayal <aghayal@codeaurora.org>
To: linux-input@vger.kernel.org, rtc-linux@googlegroups.com
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Trilok Soni <tsoni@codeaurora.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 2/3] input: pmic8xxx_pwrkey: Add support for power key
Date: Sat, 26 Mar 2011 22:22:24 +0530
Message-Id: <1301158345-22206-3-git-send-email-aghayal@codeaurora.org>
X-Mailer: git-send-email 1.7.3.5
In-Reply-To: <1301158345-22206-1-git-send-email-aghayal@codeaurora.org>
References: <1301158345-22206-1-git-send-email-aghayal@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Trilok Soni <tsoni@codeaurora.org>

Add support for PMIC8XXX power key driven over dedicated
KYPD_PWR_N pin. It allows the user to specify the amount
of time by which the power key reporting can be delayed.

Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Trilok Soni <tsoni@codeaurora.org>
---
 drivers/input/misc/Kconfig            |   11 ++
 drivers/input/misc/Makefile           |    1 +
 drivers/input/misc/pmic8xxx-pwrkey.c  |  304 +++++++++++++++++++++++++++++++++
 include/linux/input/pmic8xxx-pwrkey.h |   35 ++++
 4 files changed, 351 insertions(+), 0 deletions(-)
 create mode 100644 drivers/input/misc/pmic8xxx-pwrkey.c
 create mode 100644 include/linux/input/pmic8xxx-pwrkey.h

diff --git a/drivers/input/misc/Kconfig b/drivers/input/misc/Kconfig
index f9cf088..45dc6aa 100644
--- a/drivers/input/misc/Kconfig
+++ b/drivers/input/misc/Kconfig
@@ -330,6 +330,17 @@ config INPUT_PWM_BEEPER
 	  To compile this driver as a module, choose M here: the module will be
 	  called pwm-beeper.
 
+config INPUT_PMIC8XXX_PWRKEY
+	tristate "PMIC8XXX power key support"
+	depends on MFD_PM8XXX
+	help
+	  Say Y here if you want support for the PMIC8XXX power key.
+
+	  If unsure, say N.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called pmic8xxx-pwrkey.
+
 config INPUT_GPIO_ROTARY_ENCODER
 	tristate "Rotary encoders connected to GPIO pins"
 	depends on GPIOLIB && GENERIC_GPIO
diff --git a/drivers/input/misc/Makefile b/drivers/input/misc/Makefile
index e3f7984..38efb2c 100644
--- a/drivers/input/misc/Makefile
+++ b/drivers/input/misc/Makefile
@@ -33,6 +33,7 @@ obj-$(CONFIG_INPUT_PCF8574)		+= pcf8574_keypad.o
 obj-$(CONFIG_INPUT_PCSPKR)		+= pcspkr.o
 obj-$(CONFIG_INPUT_POWERMATE)		+= powermate.o
 obj-$(CONFIG_INPUT_PWM_BEEPER)		+= pwm-beeper.o
+obj-$(CONFIG_INPUT_PMIC8XXX_PWRKEY)	+= pmic8xxx-pwrkey.o
 obj-$(CONFIG_INPUT_RB532_BUTTON)	+= rb532_button.o
 obj-$(CONFIG_INPUT_GPIO_ROTARY_ENCODER)	+= rotary_encoder.o
 obj-$(CONFIG_INPUT_SGI_BTNS)		+= sgi_btns.o
diff --git a/drivers/input/misc/pmic8xxx-pwrkey.c b/drivers/input/misc/pmic8xxx-pwrkey.c
new file mode 100644
index 0000000..7e4a491
--- /dev/null
+++ b/drivers/input/misc/pmic8xxx-pwrkey.c
@@ -0,0 +1,304 @@
+/* Copyright (c) 2010-2011, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/slab.h>
+#include <linux/input.h>
+#include <linux/interrupt.h>
+#include <linux/platform_device.h>
+#include <linux/log2.h>
+#include <linux/spinlock.h>
+#include <linux/timer.h>
+
+#include <linux/mfd/pm8xxx/core.h>
+#include <linux/input/pmic8xxx-pwrkey.h>
+
+#define PON_CNTL_1	0x1C
+#define PON_CNTL_PULL_UP BIT(7)
+#define PON_CNTL_TRIG_DELAY_MASK (0x7)
+
+/**
+ * struct pmic8xxx_pwrkey - pmic8xxx pwrkey information
+ * @key_press_irq: key press irq number
+ * @timer: timer for end key simulation
+ * @key_pressed: flag to keep track for power key reporting
+ * @pdata: platform data
+ * @lock:  protect key press update and end key simulation
+ */
+struct pmic8xxx_pwrkey {
+	struct input_dev *pwr;
+	int key_press_irq;
+	struct timer_list timer;
+	bool key_pressed;
+	const struct pm8xxx_pwrkey_platform_data *pdata;
+	spinlock_t lock;
+};
+
+static void pmic8xxx_pwrkey_timer(unsigned long handle)
+{
+	unsigned long flags;
+	struct pmic8xxx_pwrkey *pwrkey = (struct pmic8xxx_pwrkey *)handle;
+
+	spin_lock_irqsave(&pwrkey->lock, flags);
+	pwrkey->key_pressed = true;
+
+	input_report_key(pwrkey->pwr, KEY_POWER, 1);
+	input_sync(pwrkey->pwr);
+	spin_unlock_irqrestore(&pwrkey->lock, flags);
+}
+
+static irqreturn_t pwrkey_press_irq(int irq, void *_pwrkey)
+{
+	struct pmic8xxx_pwrkey *pwrkey = _pwrkey;
+	const struct pm8xxx_pwrkey_platform_data *pdata = pwrkey->pdata;
+	unsigned long flags;
+
+	/* no pwrkey time duration, means no screen lock key simulation */
+	if (!pwrkey->pdata->pwrkey_time_ms) {
+		input_report_key(pwrkey->pwr, KEY_POWER, 1);
+		input_sync(pwrkey->pwr);
+		return IRQ_HANDLED;
+	}
+
+	spin_lock_irqsave(&pwrkey->lock, flags);
+
+	input_report_key(pwrkey->pwr, KEY_SCREENLOCK, 1);
+	input_sync(pwrkey->pwr);
+
+	mod_timer(&pwrkey->timer, jiffies +
+			 msecs_to_jiffies(pdata->pwrkey_time_ms));
+	spin_unlock_irqrestore(&pwrkey->lock, flags);
+
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t pwrkey_release_irq(int irq, void *_pwrkey)
+{
+	struct pmic8xxx_pwrkey *pwrkey = _pwrkey;
+	unsigned long flags;
+
+	/* no pwrkey time, means no delay in pwr key reporting */
+	if (!pwrkey->pdata->pwrkey_time_ms) {
+		input_report_key(pwrkey->pwr, KEY_POWER, 0);
+		input_sync(pwrkey->pwr);
+		return IRQ_HANDLED;
+	}
+
+	spin_lock_irqsave(&pwrkey->lock, flags);
+	del_timer_sync(&pwrkey->timer);
+
+	if (pwrkey->key_pressed) {
+		pwrkey->key_pressed = false;
+		input_report_key(pwrkey->pwr, KEY_POWER, 0);
+		input_sync(pwrkey->pwr);
+	}
+
+	input_report_key(pwrkey->pwr, KEY_SCREENLOCK, 0);
+	input_sync(pwrkey->pwr);
+
+	spin_unlock_irqrestore(&pwrkey->lock, flags);
+
+	return IRQ_HANDLED;
+}
+
+#ifdef CONFIG_PM
+static int pmic8xxx_pwrkey_suspend(struct device *dev)
+{
+	struct pmic8xxx_pwrkey *pwrkey = dev_get_drvdata(dev);
+
+	if (device_may_wakeup(dev))
+		enable_irq_wake(pwrkey->key_press_irq);
+
+	return 0;
+}
+
+static int pmic8xxx_pwrkey_resume(struct device *dev)
+{
+	struct pmic8xxx_pwrkey *pwrkey = dev_get_drvdata(dev);
+
+	if (device_may_wakeup(dev))
+		disable_irq_wake(pwrkey->key_press_irq);
+
+	return 0;
+}
+
+static const struct dev_pm_ops pm8xxx_pwr_key_pm_ops = {
+	.suspend	= pmic8xxx_pwrkey_suspend,
+	.resume		= pmic8xxx_pwrkey_resume,
+};
+#endif
+
+static int __devinit pmic8xxx_pwrkey_probe(struct platform_device *pdev)
+{
+	struct input_dev *pwr;
+	int key_release_irq = platform_get_irq(pdev, 0);
+	int key_press_irq = platform_get_irq(pdev, 1);
+	int err;
+	unsigned int delay;
+	u8 pon_cntl;
+	struct pmic8xxx_pwrkey *pwrkey;
+	const struct pm8xxx_pwrkey_platform_data *pdata =
+						pdev->dev.platform_data;
+
+	if (!pdata) {
+		dev_err(&pdev->dev, "power key platform data not supplied\n");
+		return -EINVAL;
+	}
+
+	if (pdata->kpd_trigger_delay_us > 62500) {
+		dev_err(&pdev->dev, "invalid pwr key trigger delay\n");
+		return -EINVAL;
+	}
+
+	if (pdata->pwrkey_time_ms &&
+	     (pdata->pwrkey_time_ms < 500 || pdata->pwrkey_time_ms > 1000)) {
+		dev_err(&pdev->dev, "invalid pwr key time supplied\n");
+		return -EINVAL;
+	}
+
+	pwrkey = kzalloc(sizeof(*pwrkey), GFP_KERNEL);
+	if (!pwrkey)
+		return -ENOMEM;
+
+	pwrkey->pdata = pdata;
+
+	pwr = input_allocate_device();
+	if (!pwr) {
+		dev_dbg(&pdev->dev, "Can't allocate power button\n");
+		err = -ENOMEM;
+		goto free_pwrkey;
+	}
+
+	input_set_capability(pwr, EV_KEY, KEY_POWER);
+	input_set_capability(pwr, EV_KEY, KEY_SCREENLOCK);
+
+	pwr->name = "pmic8xxx_pwrkey";
+	pwr->phys = "pmic8xxx_pwrkey/input0";
+	pwr->dev.parent = &pdev->dev;
+
+	delay = (pdata->kpd_trigger_delay_us << 10) / USEC_PER_SEC;
+	delay = 1 + ilog2(delay);
+
+	err = pm8xxx_readb(pdev->dev.parent, PON_CNTL_1, &pon_cntl);
+	if (err < 0) {
+		dev_err(&pdev->dev, "failed reading PON_CNTL_1 err=%d\n", err);
+		goto free_input_dev;
+	}
+
+	pon_cntl &= ~PON_CNTL_TRIG_DELAY_MASK;
+	pon_cntl |= (delay & PON_CNTL_TRIG_DELAY_MASK);
+	pon_cntl |= (pdata->pull_up ? PON_CNTL_PULL_UP : ~PON_CNTL_PULL_UP);
+	err = pm8xxx_writeb(pdev->dev.parent, PON_CNTL_1, pon_cntl);
+	if (err < 0) {
+		dev_err(&pdev->dev, "failed writing PON_CNTL_1 err=%d\n", err);
+		goto free_input_dev;
+	}
+
+	setup_timer(&pwrkey->timer, pmic8xxx_pwrkey_timer,
+				 (unsigned long) pwrkey);
+
+	spin_lock_init(&pwrkey->lock);
+
+	err = input_register_device(pwr);
+	if (err) {
+		dev_dbg(&pdev->dev, "Can't register power key: %d\n", err);
+		goto free_input_dev;
+	}
+
+	pwrkey->key_press_irq = key_press_irq;
+	pwrkey->pwr = pwr;
+
+	platform_set_drvdata(pdev, pwrkey);
+
+	err = request_threaded_irq(key_press_irq, NULL, pwrkey_press_irq,
+		IRQF_TRIGGER_RISING, "pmic8xxx_pwrkey_press", pwrkey);
+	if (err < 0) {
+		dev_dbg(&pdev->dev, "Can't get %d IRQ for pwrkey: %d\n",
+				 key_press_irq, err);
+		goto unreg_input_dev;
+	}
+
+	err = request_threaded_irq(key_release_irq, NULL, pwrkey_release_irq,
+		 IRQF_TRIGGER_RISING, "pmic8xxx_pwrkey_release", pwrkey);
+	if (err < 0) {
+		dev_dbg(&pdev->dev, "Can't get %d IRQ for pwrkey: %d\n",
+				 key_release_irq, err);
+
+		goto free_press_irq;
+	}
+
+	device_init_wakeup(&pdev->dev, pdata->wakeup);
+
+	return 0;
+
+free_press_irq:
+	free_irq(key_press_irq, NULL);
+unreg_input_dev:
+	platform_set_drvdata(pdev, NULL);
+	input_unregister_device(pwr);
+	pwr = NULL;
+free_input_dev:
+	input_free_device(pwr);
+free_pwrkey:
+	kfree(pwrkey);
+	return err;
+}
+
+static int __devexit pmic8xxx_pwrkey_remove(struct platform_device *pdev)
+{
+	struct pmic8xxx_pwrkey *pwrkey = platform_get_drvdata(pdev);
+	int key_release_irq = platform_get_irq(pdev, 0);
+	int key_press_irq = platform_get_irq(pdev, 1);
+
+	device_init_wakeup(&pdev->dev, 0);
+
+	free_irq(key_press_irq, pwrkey);
+	free_irq(key_release_irq, pwrkey);
+	del_timer_sync(&pwrkey->timer);
+	input_unregister_device(pwrkey->pwr);
+	platform_set_drvdata(pdev, NULL);
+	kfree(pwrkey);
+
+	return 0;
+}
+
+static struct platform_driver pmic8xxx_pwrkey_driver = {
+	.probe		= pmic8xxx_pwrkey_probe,
+	.remove		= __devexit_p(pmic8xxx_pwrkey_remove),
+	.driver		= {
+		.name	= PM8XXX_PWRKEY_DEV_NAME,
+		.owner	= THIS_MODULE,
+#ifdef CONFIG_PM
+		.pm	= &pm8xxx_pwr_key_pm_ops,
+#endif
+	},
+};
+
+static int __init pmic8xxx_pwrkey_init(void)
+{
+	return platform_driver_register(&pmic8xxx_pwrkey_driver);
+}
+module_init(pmic8xxx_pwrkey_init);
+
+static void __exit pmic8xxx_pwrkey_exit(void)
+{
+	platform_driver_unregister(&pmic8xxx_pwrkey_driver);
+}
+module_exit(pmic8xxx_pwrkey_exit);
+
+MODULE_ALIAS("platform:pmic8xxx_pwrkey");
+MODULE_DESCRIPTION("PMIC8XXX Power Key driver");
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR("Trilok Soni <tsoni@codeaurora.org>");
diff --git a/include/linux/input/pmic8xxx-pwrkey.h b/include/linux/input/pmic8xxx-pwrkey.h
new file mode 100644
index 0000000..4926fc7
--- /dev/null
+++ b/include/linux/input/pmic8xxx-pwrkey.h
@@ -0,0 +1,35 @@
+/* Copyright (c) 2010-2011, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef __PMIC8XXX_PWRKEY_H__
+#define __PMIC8XXX_PWRKEY_H__
+
+#define PM8XXX_PWRKEY_DEV_NAME "pm8xxx-pwrkey"
+
+/**
+ * struct pm8xxx_pwrkey_platform_data - platform data for pwrkey driver
+ * @pull up:  power on register control for pull up/down configuration
+ * @pwrkey_time_ms: time after which power key event should be generated, if
+ *                  key is released before then end key is reported.
+ *                  Supply zero for only power key reporting.
+ * @kpd_trigger_delay_us: time delay for power key state change interrupt
+ *                  trigger.
+ * @wakeup: configure power key as wakeup source
+ */
+struct pm8xxx_pwrkey_platform_data  {
+	bool pull_up;
+	u16  pwrkey_time_ms;
+	u32  kpd_trigger_delay_us;
+	u32  wakeup;
+};
+
+#endif /* __PMIC8XXX_PWRKEY_H__ */
-- 
1.7.3.5

