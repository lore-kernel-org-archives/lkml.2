Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753607Ab2HFHnm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 03:43:42 -0400
Received: from mailrelay1.diasemi.com ([82.210.246.133]:46912 "EHLO
	mailrelay1.diasemi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753024Ab2HFHnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 03:43:41 -0400
Message-Id: <201208060741.q767flhO005759@ubuntu>
From: Anthony Olech <anthony.olech.opensource@diasemi.com>
Date: Sun, 5 Aug 2012 21:43:42 +0100
Subject: [NEW DRIVER V2 2/7] DA9058 ONKEY driver
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: Ashish Jangam <ashish.jangam@kpitcummins.com>
Cc: Eric Andersson <eric.andersson@unixphere.com>
Cc: Andrew Jones <drjones@redhat.com>
Cc: Donggeun Kim <dg77.kim@samsung.com>
Cc: linux-input@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Cc: David Dajun Chen <david.chen@diasemi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the ONKEY component driver of the Dialog DA9058 PMIC.
This driver is just one component of the whole DA9058 PMIC driver.
It depends on the core DA9058 MFD driver.

Signed-off-by: Anthony Olech <anthony.olech.opensource@diasemi.com>
Signed-off-by: David Dajun Chen <david.chen@diasemi.com>
---
 drivers/input/misc/Kconfig        |   10 ++
 drivers/input/misc/Makefile       |    1 +
 drivers/input/misc/da9058_onkey.c |  171 +++++++++++++++++++++++++++++++++++++
 3 files changed, 182 insertions(+), 0 deletions(-)
 create mode 100644 drivers/input/misc/da9058_onkey.c

diff --git a/drivers/input/misc/Kconfig b/drivers/input/misc/Kconfig
index 7faf4a7..697b703 100644
--- a/drivers/input/misc/Kconfig
+++ b/drivers/input/misc/Kconfig
@@ -73,6 +73,16 @@ config INPUT_BMA150
 	  To compile this driver as a module, choose M here: the
 	  module will be called bma150.
 
+config INPUT_DA9058_ONKEY
+	tristate "DA9058 ONKEY support"
+	depends on MFD_DA9058
+	help
+	  Support the ONKEY of DA9058 PMICs as an input device
+	  reporting power button status.
+
+	  To compile this driver as a module, choose M here: the module
+	  will be called da9058_onkey.
+
 config INPUT_PCSPKR
 	tristate "PC Speaker support"
 	depends on PCSPKR_PLATFORM
diff --git a/drivers/input/misc/Makefile b/drivers/input/misc/Makefile
index f55cdf4..048d50e 100644
--- a/drivers/input/misc/Makefile
+++ b/drivers/input/misc/Makefile
@@ -41,6 +41,7 @@ obj-$(CONFIG_INPUT_PCF8574)		+= pcf8574_keypad.o
 obj-$(CONFIG_INPUT_PCSPKR)		+= pcspkr.o
 obj-$(CONFIG_INPUT_PM8XXX_VIBRATOR)	+= pm8xxx-vibrator.o
 obj-$(CONFIG_INPUT_PMIC8XXX_PWRKEY)	+= pmic8xxx-pwrkey.o
+obj-$(CONFIG_INPUT_DA9058_ONKEY)		+= da9058_onkey.o
 obj-$(CONFIG_INPUT_POWERMATE)		+= powermate.o
 obj-$(CONFIG_INPUT_PWM_BEEPER)		+= pwm-beeper.o
 obj-$(CONFIG_INPUT_RB532_BUTTON)	+= rb532_button.o
diff --git a/drivers/input/misc/da9058_onkey.c b/drivers/input/misc/da9058_onkey.c
new file mode 100644
index 0000000..fb29c14
--- /dev/null
+++ b/drivers/input/misc/da9058_onkey.c
@@ -0,0 +1,171 @@
+/*
+ *  Copyright (C) 2012 Dialog Semiconductor Ltd.
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/input.h>
+#include <linux/delay.h>
+#include <linux/slab.h>
+#include <linux/interrupt.h>
+#include <linux/mfd/core.h>
+#include <linux/regmap.h>
+
+#include <linux/mfd/da9058/version.h>
+#include <linux/mfd/da9058/registers.h>
+#include <linux/mfd/da9058/core.h>
+#include <linux/mfd/da9058/irq.h>
+#include <linux/mfd/da9058/onkey.h>
+
+struct da9058_onkey {
+	struct da9058 *da9058;
+	struct platform_device *pdev;
+	struct input_dev *input;
+	struct delayed_work work;
+	int irq;
+};
+
+static void da9058_onkey_poll(struct work_struct *work)
+{
+	struct da9058_onkey *onkey = container_of(work, struct da9058_onkey,
+							work.work);
+	struct da9058 *da9058 = onkey->da9058;
+	int poll, ret;
+	unsigned int sa;
+
+	ret = da9058_reg_read(da9058, DA9058_STATUSA_REG, &sa);
+	if (ret) {
+		dev_dbg(&onkey->pdev->dev, "Failed to read ONKEY: %d\n", ret);
+		poll = 1;
+	} else if (sa & DA9058_STATUSA_NONKEY) {
+		poll = 0;
+	} else {
+		poll = 1;
+	}
+
+	input_report_key(onkey->input, KEY_POWER, poll);
+	input_sync(onkey->input);
+
+	if (poll)
+		schedule_delayed_work(&onkey->work, msecs_to_jiffies(50));
+}
+
+static irqreturn_t da9058_onkey_event_handler(int irq, void *data)
+{
+	struct da9058_onkey *onkey = data;
+
+	schedule_delayed_work(&onkey->work, 0);
+
+	return IRQ_HANDLED;
+}
+
+static int __devinit da9058_onkey_probe(struct platform_device *pdev)
+{
+	struct da9058 *da9058 = dev_get_drvdata(pdev->dev.parent);
+	const struct mfd_cell *cell = mfd_get_cell(pdev);
+	struct da9058_onkey_pdata *onkey_pdata;
+	struct da9058_onkey *onkey;
+	int ret;
+
+	if (cell == NULL) {
+		ret = -ENODEV;
+		goto exit;
+	}
+
+	onkey_pdata = cell->platform_data;
+
+	if (onkey_pdata == NULL) {
+		ret = -EINVAL;
+		goto exit;
+	}
+
+	dev_info(&pdev->dev, "Starting ONKEY\n");
+
+	onkey = devm_kzalloc(&pdev->dev, sizeof(struct da9058_onkey),
+				GFP_KERNEL);
+	if (!onkey) {
+		ret = -ENOMEM;
+		goto exit;
+	}
+
+	platform_set_drvdata(pdev, onkey);
+
+	onkey->da9058 = da9058;
+	onkey->pdev = pdev;
+
+	INIT_DELAYED_WORK(&onkey->work, da9058_onkey_poll);
+
+	onkey->input = input_allocate_device();
+	if (!onkey->input) {
+		dev_err(&pdev->dev, "failed to allocate data device\n");
+		ret = -ENOMEM;
+		goto err1;
+	}
+
+	onkey->input->evbit[0] = BIT_MASK(EV_KEY);
+	onkey->input->keybit[BIT_WORD(KEY_POWER)] = BIT_MASK(KEY_POWER);
+	onkey->input->name = "da9058-onkey";
+	onkey->input->phys = "da9058-onkey/input0";
+	onkey->input->dev.parent = &pdev->dev;
+
+	ret = input_register_device(onkey->input);
+	if (ret) {
+		dev_err(&pdev->dev,
+			"Unable to register input ONKEY device: %d\n", ret);
+		goto err2;
+	}
+	onkey->irq = DA9058_IRQ_ENONKEY;
+
+	ret = request_threaded_irq(da9058_to_virt_irq_num(da9058, onkey->irq),
+				NULL, da9058_onkey_event_handler,
+				IRQF_TRIGGER_RISING | IRQF_ONESHOT,
+				"DA9058 keydown", onkey);
+
+	if (ret) {
+		dev_err(&pdev->dev, "Failed to get ONKEY keydown IRQ %d: %d\n",
+			onkey->irq, ret);
+		goto err3;
+	}
+	goto exit;
+
+err3:
+err2:
+	input_free_device(onkey->input);
+err1:
+	platform_set_drvdata(pdev, NULL);
+exit:
+	return ret;
+}
+
+static int __devexit da9058_onkey_remove(struct platform_device *pdev)
+{
+	struct da9058_onkey *onkey = platform_get_drvdata(pdev);
+	struct da9058 *da9058 = onkey->da9058;
+
+	free_irq(da9058_to_virt_irq_num(da9058, onkey->irq), onkey);
+	cancel_delayed_work_sync(&onkey->work);
+	input_unregister_device(onkey->input);
+
+	return 0;
+}
+
+static struct platform_driver da9058_onkey_driver = {
+	.probe = da9058_onkey_probe,
+	.remove = __devexit_p(da9058_onkey_remove),
+	.driver = {
+		.name = "da9058-onkey",
+		.owner = THIS_MODULE,
+	}
+};
+
+module_platform_driver(da9058_onkey_driver);
+
+MODULE_AUTHOR("Anthony Olech <Anthony.Olech@diasemi.com>");
+MODULE_DESCRIPTION("Dialog DA9058 PMIC Onkey Driver");
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:da9058-onkey");
-- 
end-of-patch for NEW DRIVER V2

