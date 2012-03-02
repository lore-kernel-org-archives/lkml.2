Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758068Ab2CBOi6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 09:38:58 -0500
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:37332
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754669Ab2CBOi5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 09:38:57 -0500
X-SpamScore: 3
X-BigFish: VPS3(zzc8kzz1202hzz8275bhz2dh2a8h668h839h93fh)
X-Forefront-Antispam-Report: CIP:59.163.77.45;KIP:(null);UIP:(null);IPV:NLI;H:Outbound.kpitcummins.com;RD:59.163.77.45.static.vsnl.net.in;EFVD:NLI
Subject: [PATCH 03/03] ONKEY: OnKey module for DA9052/53 PMIC
From: Ashish Jangam <ashish.jangam@kpitcummins.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dajun Chen <dchen@diasemi.com>, <sameo@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 2 Mar 2012 19:59:54 +0530
Message-ID: <1330698594.21817.32.camel@dhruva>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.10.38.47]
X-OriginatorOrg: kpitcummins.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On-key Driver for Dialog Semiconductor DA9052/53 PMICs.

Signed-off-by: David Dajun Chen <dchen@diasemi.com>
Signed-off-by: Ashish Jangam <ashish.jangam@kpitcummins.com>
--- 
drivers/input/misc/Kconfig        |   10 ++
 drivers/input/misc/Makefile       |    1 +
 drivers/input/misc/da9052_onkey.c |  174 +++++++++++++++++++++++++++++++++++++
 3 files changed, 185 insertions(+), 0 deletions(-)
 create mode 100644 drivers/input/misc/da9052_onkey.c

diff --git a/drivers/input/misc/Kconfig b/drivers/input/misc/Kconfig
index 532754f..835fb8f 100644
--- a/drivers/input/misc/Kconfig
+++ b/drivers/input/misc/Kconfig
@@ -454,6 +454,16 @@ config INPUT_RB532_BUTTON
 	  To compile this driver as a module, choose M here: the
 	  module will be called rb532_button.
 
+config INPUT_DA9052_ONKEY
+	tristate "Dialog DA9052/DA9053 Onkey"
+	depends on PMIC_DA9052
+	help
+	  Support the ONKEY of Dialog DA9052 PMICs as an input device
+	  reporting power button status.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called da9052_onkey.
+
 config INPUT_DM355EVM
 	tristate "TI DaVinci DM355 EVM Keypad and IR Remote"
 	depends on MFD_DM355EVM_MSP
diff --git a/drivers/input/misc/Makefile b/drivers/input/misc/Makefile
index 46671a8..a6d8de0 100644
--- a/drivers/input/misc/Makefile
+++ b/drivers/input/misc/Makefile
@@ -21,6 +21,7 @@ obj-$(CONFIG_INPUT_CM109)		+= cm109.o
 obj-$(CONFIG_INPUT_CMA3000)		+= cma3000_d0x.o
 obj-$(CONFIG_INPUT_CMA3000_I2C)		+= cma3000_d0x_i2c.o
 obj-$(CONFIG_INPUT_COBALT_BTNS)		+= cobalt_btns.o
+obj-$(CONFIG_INPUT_DA9052_ONKEY)	+= da9052_onkey.o
 obj-$(CONFIG_INPUT_DM355EVM)		+= dm355evm_keys.o
 obj-$(CONFIG_INPUT_GP2A)		+= gp2ap002a00f.o
 obj-$(CONFIG_INPUT_GPIO_TILT_POLLED)	+= gpio_tilt_polled.o
diff --git a/drivers/input/misc/da9052_onkey.c b/drivers/input/misc/da9052_onkey.c
new file mode 100644
index 0000000..c153a28
--- /dev/null
+++ b/drivers/input/misc/da9052_onkey.c
@@ -0,0 +1,174 @@
+/*
+ * ON pin driver for Dialog DA9052 PMICs
+ *
+ * Copyright(c) 2012 Dialog Semiconductor Ltd.
+ *
+ * Author: David Dajun Chen <dchen@diasemi.com>
+ *
+ *  This program is free software; you can redistribute  it and/or modify it
+ *  under  the terms of  the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the  License, or (at your
+ *  option) any later version.
+ */
+
+#include <linux/init.h>
+#include <linux/input.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/workqueue.h>
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
+static void da9052_onkey_query(struct da9052_onkey *onkey)
+{
+	int key_stat;
+
+	key_stat = da9052_reg_read(onkey->da9052, DA9052_EVENT_B_REG);
+	if (key_stat < 0) {
+		dev_err(onkey->da9052->dev,
+			"Failed to read onkey event %d\n", key_stat);
+		key_stat = 1;
+	} else {
+		/*
+		 * Since interrupt for deassertion of ONKEY pin is not
+		 * generated, onkey event state determines the onkey
+		 * button state.
+		 */
+		key_stat &= DA9052_EVENTB_ENONKEY;
+		input_report_key(onkey->input, KEY_POWER, key_stat);
+		input_sync(onkey->input);
+	}
+	/*
+	 * Interrupt is generated only when the ONKEY pin is asserted.
+	 * Hence the deassertion of the pin is simulated through work queue.
+	 */
+	if (key_stat)
+		schedule_delayed_work(&onkey->work, msecs_to_jiffies(50));
+}
+
+static void da9052_onkey_work(struct work_struct *work)
+{
+	struct da9052_onkey *onkey = container_of(work, struct da9052_onkey,
+						  work.work);
+
+	da9052_onkey_query(onkey);
+}
+
+static irqreturn_t da9052_onkey_irq(int irq, void *data)
+{
+	struct da9052_onkey *onkey = data;
+
+	da9052_onkey_work(&onkey->work.work);
+
+	return IRQ_HANDLED;
+}
+
+static int __devinit da9052_onkey_probe(struct platform_device *pdev)
+{
+	struct da9052_onkey *onkey;
+	int error;
+
+	onkey = devm_kzalloc(&pdev->dev, sizeof(*onkey), GFP_KERNEL);
+	if (!onkey) {
+		dev_err(&pdev->dev, "Failed to allocate memory\n");
+		return -ENOMEM;
+	}
+
+	onkey->input = input_allocate_device();
+	if (!onkey->input) {
+		error = -ENOMEM;
+		dev_err(&pdev->dev, "Failed to allocate input device, %d\n",
+			error);
+		goto err_mem;
+	}
+
+	onkey->da9052 = dev_get_drvdata(pdev->dev.parent);
+	if (!onkey->da9052) {
+		error = -ENOMEM;
+		dev_err(&pdev->dev, "Failed to get the driver's data, %d\n",
+			error);
+		goto err_input;
+	}
+
+	onkey->irq = platform_get_irq_byname(pdev, "ONKEY");
+	if (onkey->irq < 0) {
+		error = onkey->irq;
+		dev_err(&pdev->dev,
+			"Failed to get an IRQ for input device, %d\n",
+			onkey->irq);
+		goto err_input;
+	}
+
+	onkey->input->evbit[0] = BIT_MASK(EV_KEY);
+	onkey->input->keybit[BIT_WORD(KEY_POWER)] = BIT_MASK(KEY_POWER);
+	onkey->input->name = "da9052-onkey";
+	onkey->input->phys = "da9052-onkey/input0";
+	onkey->input->dev.parent = &pdev->dev;
+
+	INIT_DELAYED_WORK(&onkey->work, da9052_onkey_work);
+
+	error = request_threaded_irq(onkey->irq, NULL, da9052_onkey_irq,
+				     IRQF_TRIGGER_LOW | IRQF_ONESHOT,
+				     "ONKEY", onkey);
+	if (error < 0) {
+		dev_err(onkey->da9052->dev,
+			"Failed to register ONKEY IRQ %d, error = %d\n",
+			onkey->irq, error);
+		goto err_req_irq;
+	}
+
+	error = input_register_device(onkey->input);
+	if (error) {
+		dev_err(&pdev->dev, "Unable to register input device, %d\n",
+			error);
+		goto err_irq;
+	}
+
+	platform_set_drvdata(pdev, onkey);
+
+	return 0;
+
+err_irq:
+	free_irq(onkey->irq, onkey);
+err_req_irq:
+	cancel_delayed_work_sync(&onkey->work);
+err_input:
+	input_free_device(onkey->input);
+err_mem:
+	return error;
+}
+
+static int __devexit da9052_onkey_remove(struct platform_device *pdev)
+{
+	struct da9052_onkey *onkey = platform_get_drvdata(pdev);
+
+	free_irq(onkey->irq, onkey);
+	cancel_delayed_work_sync(&onkey->work);
+	input_unregister_device(onkey->input);
+
+	return 0;
+}
+
+static struct platform_driver da9052_onkey_driver = {
+	.probe	= da9052_onkey_probe,
+	.remove	= __devexit_p(da9052_onkey_remove),
+	.driver = {
+		.name	= "da9052-onkey",
+		.owner	= THIS_MODULE,
+	},
+};
+
+module_platform_driver(da9052_onkey_driver);
+
+MODULE_AUTHOR("David Dajun Chen <dchen@diasemi.com>");
+MODULE_DESCRIPTION("Onkey driver for DA9052");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:da9052-onkey");




This message contains information that may be privileged or confidential and is the property of the KPIT Cummins Infosystems Ltd. It is intended only for the person to whom it is addressed. If you are not the intended recipient, you are not authorized to read, print, retain copy, disseminate, distribute, or use this message or any part thereof. If you receive this message in error, please notify the sender immediately and delete all copies of this message. KPIT Cummins Infosystems Ltd. does not accept any liability for virus infected mails.


