Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751980Ab0LUSEY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 13:04:24 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:65029 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042Ab0LUSEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 13:04:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=LuvN+JWjhGHZOpHMrTbvpxhpiiQ6xtMzaeVBtyEWD0CeyUD3Ii9rwZoOLLJ6DozVb3
         2mzQR1xFtgUvUqRXa6Y9ezC7JlqTr8s85LQ76UqQ2ciXK6GxRcT/G8l8vu/JUT6zGRkr
         fMZPURMDAtwWVH9A+b8q7EmIRPqFh+X4yPuEo=
MIME-Version: 1.0
Date: Tue, 21 Dec 2010 19:04:19 +0100
Message-ID: <AANLkTikGnwuxS4-uvtMt6mJZM42049cQ4uoUveORy4NO@mail.gmail.com>
Subject: [PATCHv2 11/11] INPUT/MISC/ONKEY: OnKey module of DA9052 device driver
From: dd diasemi <dd.diasemi@gmail.com>
To: dmitry.torokhov@gmail.com, dtor@mail.ru
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Onkey module for DA9052 PMIC device from Dialog Semiconductor.

Changes made since last submission:
. sorted Kconfig entries.

Linux Kernel Version: 2.6.34

Signed-off-by: D. Chen <dchen@diasemi.com>
---
diff -Naur linux-2.6.34-orig/drivers/input/misc/da9052_onkey.c
linux-2.6.34/drivers/input/misc/da9052_onkey.c
--- linux-2.6.34-orig/drivers/input/misc/da9052_onkey.c	1970-01-01
05:00:00.000000000 +0500
+++ linux-2.6.34/drivers/input/misc/da9052_onkey.c	2010-10-12
10:53:04.000000000 +0500
@@ -0,0 +1,130 @@
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/input.h>
+#include <linux/platform_device.h>
+
+#include <linux/mfd/da9052/da9052.h>
+#include <linux/mfd/da9052/reg.h>
+
+#define DRIVER_NAME "da9052-onkey"
+
+struct da9052_onkey_data {
+	struct da9052 *da9052;
+	struct da9052_eh_nb eh_data;
+	struct input_dev *input;
+};
+
+static void da9052_onkey_report_event(struct da9052_eh_nb *eh_data,
+				unsigned int event)
+{
+	struct da9052_onkey_data *da9052_onkey =
+		container_of(eh_data, struct da9052_onkey_data, eh_data);
+	struct da9052_ssc_msg msg;
+	unsigned int ret;
+
+	msg.addr = DA9052_EVENTB_REG;
+	da9052_lock(da9052_onkey->da9052);
+	ret = da9052_onkey->da9052->read(da9052_onkey->da9052, &msg);
+	if (ret) {
+		da9052_unlock(da9052_onkey->da9052);
+		return;
+	}
+	da9052_unlock(da9052_onkey->da9052);
+	msg.data = msg.data & DA9052_EVENTB_ENONKEY;
+
+	input_report_key(da9052_onkey->input, KEY_POWER, msg.data);
+	input_sync(da9052_onkey->input);
+}
+
+static int __devinit da9052_onkey_probe(struct platform_device *pdev)
+{
+	struct da9052_onkey_data *da9052_onkey;
+	int error;
+
+	da9052_onkey = kzalloc(sizeof(*da9052_onkey), GFP_KERNEL);
+	da9052_onkey->input = input_allocate_device();
+	if (!da9052_onkey->input) {
+		dev_err(&pdev->dev, "failed to allocate data device\n");
+		error = -ENOMEM;
+		goto fail1;
+	}
+	da9052_onkey->da9052 = dev_get_drvdata(pdev->dev.parent);
+
+	if (!da9052_onkey->input) {
+		dev_err(&pdev->dev, "failed to allocate input device\n");
+		error = -ENOMEM;
+		goto fail2;
+	}
+
+	da9052_onkey->input->evbit[0] = BIT_MASK(EV_KEY);
+	da9052_onkey->input->keybit[BIT_WORD(KEY_POWER)] = BIT_MASK(KEY_POWER);
+	da9052_onkey->input->name = "da9052-onkey";
+	da9052_onkey->input->phys = "da9052-onkey/input0";
+	da9052_onkey->input->dev.parent = &pdev->dev;
+
+	da9052_onkey->eh_data.eve_type = ONKEY_EVE;
+	da9052_onkey->eh_data.call_back = &da9052_onkey_report_event;
+	error = da9052_onkey->da9052->register_event_notifier(
+				da9052_onkey->da9052,
+				&da9052_onkey->eh_data);
+	if (error)
+		goto fail2;
+
+	error = input_register_device(da9052_onkey->input);
+	if (error) {
+		dev_err(&pdev->dev, "Unable to register input\
+				device,error: %d\n", error);
+		goto fail3;
+	}
+
+	platform_set_drvdata(pdev, da9052_onkey);
+
+	return 0;
+
+fail3:
+	da9052_onkey->da9052->unregister_event_notifier(da9052_onkey->da9052,
+					&da9052_onkey->eh_data);
+fail2:
+	input_free_device(da9052_onkey->input);
+fail1:
+	kfree(da9052_onkey);
+	return error;
+}
+
+static int __devexit da9052_onkey_remove(struct platform_device *pdev)
+{
+	struct da9052_onkey_data *da9052_onkey = pdev->dev.platform_data;
+	da9052_onkey->da9052->unregister_event_notifier(da9052_onkey->da9052,
+					&da9052_onkey->eh_data);
+	input_unregister_device(da9052_onkey->input);
+	kfree(da9052_onkey);
+
+	return 0;
+}
+
+static struct platform_driver da9052_onkey_driver = {
+	.probe		= da9052_onkey_probe,
+	.remove		= __devexit_p(da9052_onkey_remove),
+	.driver		= {
+		.name	= "da9052-onkey",
+		.owner	= THIS_MODULE,
+	}
+};
+
+static int __init da9052_onkey_init(void)
+{
+	return platform_driver_register(&da9052_onkey_driver);
+}
+
+static void __exit da9052_onkey_exit(void)
+{
+	platform_driver_unregister(&da9052_onkey_driver);
+}
+
+module_init(da9052_onkey_init);
+module_exit(da9052_onkey_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("David Dajun Chen <dchen@diasemi.com>");
+MODULE_DESCRIPTION("Onkey driver for DA9052");
+MODULE_ALIAS("platform:" DRIVER_NAME);
diff -Naur linux-2.6.34-orig/drivers/input/misc/Kconfig
linux-2.6.34/drivers/input/misc/Kconfig
--- linux-2.6.34-orig/drivers/input/misc/Kconfig	2010-05-17
02:17:36.000000000 +0500
+++ linux-2.6.34/drivers/input/misc/Kconfig	2010-10-12 13:28:15.000000000 +0500
@@ -300,6 +300,16 @@
 	  To compile this driver as a module, choose M here: the
 	  module will be called rb532_button.

+config INPUT_DA9052_ONKEY
+	tristate "Dialog DA9052 Onkey"
+	depends on PMIC_DA9052
+	help
+	  Support the ONKEY of Dialog DA9052 PMICs as an input device
+	  reporting power button status.
+
+	  To compile this driver as a module, choose M here: the module
+	  will be called da9052_onkey.
+
 config INPUT_DM355EVM
 	tristate "TI DaVinci DM355 EVM Keypad and IR Remote"
 	depends on MFD_DM355EVM_MSP
diff -Naur linux-2.6.34-orig/drivers/input/misc/Makefile
linux-2.6.34/drivers/input/misc/Makefile
--- linux-2.6.34-orig/drivers/input/misc/Makefile	2010-05-17
02:17:36.000000000 +0500
+++ linux-2.6.34/drivers/input/misc/Makefile	2010-10-12 13:27:21.000000000 +0500
@@ -12,6 +12,7 @@
 obj-$(CONFIG_INPUT_BFIN_ROTARY)		+= bfin_rotary.o
 obj-$(CONFIG_INPUT_CM109)		+= cm109.o
 obj-$(CONFIG_INPUT_COBALT_BTNS)		+= cobalt_btns.o
+obj-$(CONFIG_INPUT_DA9052_ONKEY)	+= da9052_onkey.o
 obj-$(CONFIG_INPUT_DM355EVM)		+= dm355evm_keys.o
 obj-$(CONFIG_HP_SDC_RTC)		+= hp_sdc_rtc.o
 obj-$(CONFIG_INPUT_IXP4XX_BEEPER)	+= ixp4xx-beeper.o
