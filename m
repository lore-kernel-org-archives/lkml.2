Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422661Ab2JLJVU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 05:21:20 -0400
Received: from va3ehsobe010.messaging.microsoft.com ([216.32.180.30]:2612 "EHLO
	va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932181Ab2JLJVS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 05:21:18 -0400
X-Forefront-Antispam-Report: CIP:59.163.77.45;KIP:(null);UIP:(null);IPV:NLI;H:KCHJEXHC01.kpit.com;RD:59.163.77.45.static.vsnl.net.in;EFVD:NLI
X-SpamScore: 4
X-BigFish: VPS4(zzc8kzz1202h1d1ah1d2ahzz8275bhz2dh2a8h668h839h93fhd24hd2bhf0ah107ah1288h12a5h12a9h12bdh137ah139eh13b6h1441hbe9i1155h)
Subject: [Patch v4 7/7] Onkey: DA9055 Onkey driver
From: Ashish Jangam <ashish.jangam@kpitcummins.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Liam Girdwood <lrg@slimlogic.co.uk>, Samuel Ortiz <sameo@linux.intel.com>,
        <linux-input@vger.kernel.org>, David Dajun Chen <dchen@diasemi.com>,
        <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 12 Oct 2012 15:02:30 +0530
Message-ID: <1350034350.11527.22.camel@dhruva>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.10.38.47]
X-OriginatorOrg: kpitcummins.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the ONKEY driver of the Dialog DA9055 PMIC and depends on the DA9055 MFD
core driver.

This patch is functionally tested on SMDK6410 board.

Signed-off-by: David Dajun Chen <dchen@diasemi.com>
Signed-off-by: Ashish Jangam <ashish.jangam@kpitcummins.com>
---
changes since v4:
- remove of devm_*irq API
changes since v3:
- used of module_platform_driver macro
- add regmap virtual irq function
changes since v2:
- add support for handling the button release case
---
 drivers/input/misc/Kconfig        |   10 ++
 drivers/input/misc/Makefile       |    1 +
 drivers/input/misc/da9055_onkey.c |  171 +++++++++++++++++++++++++++++++++++++
 3 files changed, 182 insertions(+), 0 deletions(-)
 create mode 100644 drivers/input/misc/da9055_onkey.c

diff --git a/drivers/input/misc/Kconfig b/drivers/input/misc/Kconfig
index 7c0f1ec..6a45cb8 100644
--- a/drivers/input/misc/Kconfig
+++ b/drivers/input/misc/Kconfig
@@ -486,6 +486,16 @@ config INPUT_DA9052_ONKEY
 	  To compile this driver as a module, choose M here: the
 	  module will be called da9052_onkey.
 
+config INPUT_DA9055_ONKEY
+	tristate "Dialog Semiconductor DA9055 ONKEY"
+	depends on MFD_DA9055
+	help
+	  Support the ONKEY of DA9055 PMICs as an input device
+	  reporting power button status.
+
+	  To compile this driver as a module, choose M here: the module
+	  will be called da9055_onkey.
+
 config INPUT_DM355EVM
 	tristate "TI DaVinci DM355 EVM Keypad and IR Remote"
 	depends on MFD_DM355EVM_MSP
diff --git a/drivers/input/misc/Makefile b/drivers/input/misc/Makefile
index 83fe6f5..23347e3 100644
--- a/drivers/input/misc/Makefile
+++ b/drivers/input/misc/Makefile
@@ -23,6 +23,7 @@ obj-$(CONFIG_INPUT_CMA3000)		+= cma3000_d0x.o
 obj-$(CONFIG_INPUT_CMA3000_I2C)		+= cma3000_d0x_i2c.o
 obj-$(CONFIG_INPUT_COBALT_BTNS)		+= cobalt_btns.o
 obj-$(CONFIG_INPUT_DA9052_ONKEY)	+= da9052_onkey.o
+obj-$(CONFIG_INPUT_DA9055_ONKEY)	+= da9055_onkey.o
 obj-$(CONFIG_INPUT_DM355EVM)		+= dm355evm_keys.o
 obj-$(CONFIG_INPUT_GP2A)		+= gp2ap002a00f.o
 obj-$(CONFIG_INPUT_GPIO_TILT_POLLED)	+= gpio_tilt_polled.o
diff --git a/drivers/input/misc/da9055_onkey.c b/drivers/input/misc/da9055_onkey.c
new file mode 100644
index 0000000..217b5ee
--- /dev/null
+++ b/drivers/input/misc/da9055_onkey.c
@@ -0,0 +1,171 @@
+/*
+ * ON pin driver for Dialog DA9055 PMICs
+ *
+ * Copyright(c) 2012 Dialog Semiconductor Ltd.
+ *
+ * Author: David Dajun Chen <dchen@diasemi.com>
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ */
+
+#include <linux/init.h>
+#include <linux/input.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+
+#include <linux/mfd/da9055/core.h>
+#include <linux/mfd/da9055/reg.h>
+
+struct da9055_onkey {
+	struct da9055 *da9055;
+	struct input_dev *input;
+	struct delayed_work work;
+};
+
+static void da9055_onkey_query(struct da9055_onkey *onkey)
+{
+	int key_stat;
+
+	key_stat = da9055_reg_read(onkey->da9055, DA9055_REG_STATUS_A);
+	if (key_stat < 0) {
+		dev_err(onkey->da9055->dev,
+			"Failed to read onkey event %d\n", key_stat);
+	} else {
+		key_stat &= DA9055_NOKEY_STS;
+		/*
+		 * Onkey status bit is cleared when onkey button is relased.
+		 */
+		if (!key_stat) {
+			input_report_key(onkey->input, KEY_POWER, 0);
+			input_sync(onkey->input);
+		}
+	}
+
+	/*
+	 * Interrupt is generated only when the ONKEY pin is asserted.
+	 * Hence the deassertion of the pin is simulated through work queue.
+	 */
+	if (key_stat)
+		schedule_delayed_work(&onkey->work, msecs_to_jiffies(10));
+
+}
+
+static void da9055_onkey_work(struct work_struct *work)
+{
+	struct da9055_onkey *onkey = container_of(work, struct da9055_onkey,
+						  work.work);
+
+	da9055_onkey_query(onkey);
+}
+
+static irqreturn_t da9055_onkey_irq(int irq, void *data)
+{
+	struct da9055_onkey *onkey = data;
+
+	input_report_key(onkey->input, KEY_POWER, 1);
+	input_sync(onkey->input);
+
+	da9055_onkey_query(onkey);
+
+	return IRQ_HANDLED;
+}
+
+static int __devinit da9055_onkey_probe(struct platform_device *pdev)
+{
+	struct input_dev *input_dev;
+	struct da9055 *da9055 = dev_get_drvdata(pdev->dev.parent);
+	struct da9055_onkey *onkey;
+	int irq, err;
+
+	irq = platform_get_irq_byname(pdev, "ONKEY");
+	if (irq < 0) {
+		dev_err(&pdev->dev,
+			"Failed to get an IRQ for input device, %d\n", irq);
+		return -EINVAL;
+	}
+
+	onkey = devm_kzalloc(&pdev->dev, sizeof(*onkey), GFP_KERNEL);
+	if (!onkey) {
+		dev_err(&pdev->dev, "Failed to allocate memory\n");
+		return -ENOMEM;
+	}
+
+	input_dev = input_allocate_device();
+	if (!input_dev) {
+		dev_err(&pdev->dev, "Failed to allocate memory\n");
+		return -ENOMEM;
+	}
+
+	onkey->input = input_dev;
+	onkey->da9055 = da9055;
+	input_dev->name = "da9055-onkey";
+	input_dev->phys = "da9055-onkey/input0";
+	input_dev->dev.parent = &pdev->dev;
+
+	input_dev->evbit[0] = BIT_MASK(EV_KEY);
+	__set_bit(KEY_POWER, input_dev->keybit);
+
+	INIT_DELAYED_WORK(&onkey->work, da9055_onkey_work);
+
+	irq = regmap_irq_get_virq(da9055->irq_data, irq);
+	err = request_threaded_irq(irq, NULL, da9055_onkey_irq,
+				   IRQF_TRIGGER_HIGH | IRQF_ONESHOT,
+				   "ONKEY", onkey);
+	if (err < 0) {
+		dev_err(&pdev->dev,
+			"Failed to register ONKEY IRQ %d, error = %d\n",
+			irq, err);
+		goto free_onkey;
+	}
+
+	err = input_register_device(input_dev);
+	if (err) {
+		dev_err(&pdev->dev, "Unable to register input device, %d\n",
+			err);
+		goto free_irq;
+	}
+
+	platform_set_drvdata(pdev, onkey);
+
+	return 0;
+
+free_irq:
+	free_irq(irq, onkey);
+free_onkey:
+	cancel_delayed_work_sync(&onkey->work);
+	input_free_device(input_dev);
+
+	return err;
+}
+
+static int __devexit da9055_onkey_remove(struct platform_device *pdev)
+{
+	struct da9055_onkey *onkey = platform_get_drvdata(pdev);
+	int irq = platform_get_irq_byname(pdev, "ONKEY");
+
+	irq = regmap_irq_get_virq(onkey->da9055->irq_data, irq);
+	free_irq(irq, onkey);
+	cancel_delayed_work_sync(&onkey->work);
+	input_unregister_device(onkey->input);
+
+	return 0;
+}
+
+static struct platform_driver da9055_onkey_driver = {
+	.probe	= da9055_onkey_probe,
+	.remove	= __devexit_p(da9055_onkey_remove),
+	.driver = {
+		.name	= "da9055-onkey",
+		.owner	= THIS_MODULE,
+	},
+};
+
+module_platform_driver(da9055_onkey_driver);
+
+MODULE_AUTHOR("David Dajun Chen <dchen@diasemi.com>");
+MODULE_DESCRIPTION("Onkey driver for DA9055");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:da9055-onkey");
-- 
1.7.0.4


