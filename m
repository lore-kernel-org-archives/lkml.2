Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755854Ab1DFLyl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 07:54:41 -0400
Received: from ch1outboundpool.messaging.microsoft.com ([216.32.181.184]:35718
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755827Ab1DFLyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 07:54:39 -0400
X-SpamScore: -2
X-BigFish: VPS-2(zzbb2cK936eKc8kzz1202hzz8275bh84d07hz32i2a8h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:Kcinpunhjhc01.kpit.com;RD:Kcinpunhjhc01.kpit.com;EFVD:NLI
From: Ashish Jangam <Ashish.Jangam@kpitcummins.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dajun Chen <Dajun.Chen2@diasemi.com>
Date: Wed, 6 Apr 2011 17:24:23 +0530
Subject: [PATCHv1 11/11] INPUT/MISC/ONKEY: OnKey module of DA9052 PMICs
 driver
Thread-Topic: [PATCHv1 11/11] INPUT/MISC/ONKEY: OnKey module of DA9052 PMICs
 driver
Thread-Index: Acv0UV7q9ud7tnFWThOiZes450nrPQ==
Message-ID: <E2CAE7F7B064EA49B5CE7EE9A4BB167D151B451E04@KCINPUNHJCMS01.kpit.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: kpitcummins.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p36Bt9Ad000530

Hi Dmitry,

ONKEY Driver for Dialog Semiconductor DA9052 PMICs.

Changes made since last submission:
. read and write operation moved to MFD
. added workqueue to notify onkey events

Some additional information of this patch:
. This patch is thoroughly tested with the Samsung 6410 board using I2C connectivity. 
. Workqueue is added to toggle the KEY_POWER event.

Linux Kernel Version: 2.6.37

Signed-off-by: D. Chen <dchen@diasemi.com>
---
diff -Naur orig_linux-2.6.37/drivers/input/misc/da9052_onkey.c linux-2.6.37/drivers/input/misc/da9052_onkey.c
--- orig_linux-2.6.37/drivers/input/misc/da9052_onkey.c	1970-01-01 05:00:00.000000000 +0500
+++ linux-2.6.37/drivers/input/misc/da9052_onkey.c	2011-03-31 19:28:59.000000000 +0500
@@ -0,0 +1,150 @@
+/*
+ * da9052_onkey.c  --  ON pin driver for Dialog DA9052 PMICs
+ *
+ * Copyright(c) 2009 Dialog Semiconductor Ltd.
+ *
+ * Author: Dajun Chen <dchen@diasemi.com>
+ *
+ *  This program is free software; you can redistribute  it and/or modify it
+ *  under  the terms of  the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the  License, or (at your
+ *  option) any later version.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/input.h>
+#include <linux/workqueue.h>
+#include <linux/platform_device.h>
+
+#include <linux/mfd/da9052/da9052.h>
+#include <linux/mfd/da9052/reg.h>
+
+struct da9052_onkey {
+	struct da9052 *da9052;
+	struct input_dev *input;
+	struct delayed_work work;
+	int irq;
+};
+
+static void da9052_onkey_work(struct work_struct *work)
+{
+	unsigned int ret;
+	struct da9052_onkey *onkey;
+	onkey = container_of(work, struct da9052_onkey, work.work);
+
+	ret = da9052_reg_read(onkey->da9052, DA9052_EVENT_B_REG);
+	if (ret < 0) {
+		dev_err(onkey->da9052->dev,
+			"da9052_onkey_report_event da9052_reg_read error %d\n",
+			ret);
+		ret = 1;
+	} else {
+		ret = ret & DA9052_E_nONKEY;
+		input_report_key(onkey->input, KEY_POWER, ret);
+		input_sync(onkey->input);
+	}
+
+	if (ret)
+		schedule_delayed_work(&onkey->work, 10);
+
+}
+
+
+static irqreturn_t  da9052_onkey_irq(int irq, void *data)
+{
+	struct da9052_onkey *onkey = (struct da9052_onkey *) data;
+
+	schedule_delayed_work(&onkey->work, 0);
+
+	return IRQ_HANDLED;
+}
+
+static int __devinit da9052_onkey_probe(struct platform_device *pdev)
+{
+	struct da9052_onkey *onkey;
+	unsigned int ret;
+
+	onkey = kzalloc(sizeof(*onkey), GFP_KERNEL);
+	if (!onkey) {
+		dev_err(&pdev->dev, "Failed to allocate memory \n");
+		return -ENOMEM;
+	}
+	onkey->input = input_allocate_device();
+	if (!onkey->input) {
+		ret = -ENOMEM;
+		dev_err(&pdev->dev, "Failed to allocate input device, %d\n", ret);
+		goto err_mem;
+	}
+	onkey->da9052 = dev_get_drvdata(pdev->dev.parent);
+	onkey->irq = platform_get_irq_byname(pdev, "ONKEY");
+
+	onkey->input->evbit[0] = BIT_MASK(EV_KEY);
+	onkey->input->keybit[BIT_WORD(KEY_POWER)] = BIT_MASK(KEY_POWER);
+	onkey->input->name = "da9052-onkey";
+	onkey->input->phys = "da9052-onkey/input0";
+	onkey->input->dev.parent = &pdev->dev;
+
+	ret = input_register_device(onkey->input);
+	if (ret) {
+		dev_err(&pdev->dev, "Unable to register input\
+				device, %d\n", ret);
+		goto err_input;
+	}
+
+	INIT_DELAYED_WORK(&onkey->work, da9052_onkey_work);
+
+	ret = da9052_request_irq(onkey->da9052, onkey->irq,
+					da9052_onkey_irq, "ONKEY", onkey);
+	if (ret < 0)
+		goto err_input;
+
+	platform_set_drvdata(pdev, onkey);
+
+	return 0;
+
+err_input:
+	input_unregister_device(onkey->input);
+	cancel_delayed_work_sync(&onkey->work);
+err_mem:
+	kfree(onkey);
+	return ret;
+}
+
+static int __devexit da9052_onkey_remove(struct platform_device *pdev)
+{
+	struct da9052_onkey *onkey = pdev->dev.platform_data;
+
+	cancel_delayed_work_sync(&onkey->work);
+	input_unregister_device(onkey->input);
+	da9052_free_irq(onkey->da9052, onkey->irq, NULL);
+	kfree(onkey);
+
+	return 0;
+}
+
+static struct platform_driver da9052_onkey_driver = {
+	.driver.name	= "da9052-onkey",
+	.driver.owner	= THIS_MODULE,
+	.probe		= da9052_onkey_probe,
+	.remove		= __devexit_p(da9052_onkey_remove),
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
+MODULE_ALIAS("platform:da9052-onkey");
diff -Naur orig_linux-2.6.37/drivers/input/misc/Kconfig linux-2.6.37/drivers/input/misc/Kconfig
--- orig_linux-2.6.37/drivers/input/misc/Kconfig	2011-01-05 05:50:19.000000000 +0500
+++ linux-2.6.37/drivers/input/misc/Kconfig	2011-03-31 19:29:14.000000000 +0500
@@ -32,6 +32,16 @@
 	  To compile this driver as a module, choose M here: the module
 	  will be called ab8500-ponkey.

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
 config INPUT_AD714X
 	tristate "Analog Devices AD714x Capacitance Touch Sensor"
 	help
diff -Naur orig_linux-2.6.37/drivers/input/misc/Makefile linux-2.6.37/drivers/input/misc/Makefile
--- orig_linux-2.6.37/drivers/input/misc/Makefile	2011-01-05 05:50:19.000000000 +0500
+++ linux-2.6.37/drivers/input/misc/Makefile	2011-03-31 19:29:21.000000000 +0500
@@ -5,6 +5,7 @@
 # Each configuration option enables a list of files.

 obj-$(CONFIG_INPUT_88PM860X_ONKEY)	+= 88pm860x_onkey.o
+obj-$(CONFIG_INPUT_DA9052_ONKEY)	+= da9052_onkey.o
 obj-$(CONFIG_INPUT_AB8500_PONKEY)	+= ab8500-ponkey.o
 obj-$(CONFIG_INPUT_AD714X)		+= ad714x.o
 obj-$(CONFIG_INPUT_AD714X_I2C)	+= ad714x-i2c.o



Regards,
Ashish


ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
