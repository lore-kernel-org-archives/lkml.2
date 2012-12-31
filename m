Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751829Ab2LaVeb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2012 16:34:31 -0500
Received: from server.prisktech.co.nz ([115.188.14.127]:56720 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001Ab2LaVe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2012 16:34:29 -0500
From: Tony Prisk <linux@prisktech.co.nz>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Tony Prisk <linux@prisktech.co.nz>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        vt8500-wm8505-linux-kernel@googlegroups.com,
        linux-input@vger.kernel.org
Subject: [PATCH v3] input: vt8500: Add power button keypad driver
Date: Tue,  1 Jan 2013 10:34:07 +1300
Message-Id: <1356989647-18081-1-git-send-email-linux@prisktech.co.nz>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for the Power Button keypad found on
Wondermedia netbooks/tablets.

A keymap property is exposed to allowing defining the key
event to be generated when the power button is pressed.

Signed-off-by: Tony Prisk <linux@prisktech.co.nz>
---
CC: linux-kernel@vger.kernel.org
CC: linux-arm-kernel@lists.infradead.org
CC: vt8500-wm8505-linux-kernel@googlegroups.com
CC: linux-input@vger.kernel.org

v2:
Remove devicetree binding for keycode
Add dependency on OF in Kconfig
Move static variables in a struct
Remove redundant inline modifier from kpad_power_timeout()
Remove unneccessary checks against power_button_pressed. Drop variable.
Cleanup the fail path code and add a .remove function.
Change the button behaviour so that a key-released event is only generated once
the key is released, not after timeout.
*Changes tested on WM8650 tablet.

v3:
Remove dependency on PMC node, and change binding document accordingly.
Remove mod_timer call in kpad_power_timeout()
Unmap io memory in fail path and .remove
Update name & phys fields to be more meaningful
Use del_timer_sync rather than del_timer
Fix usage of input_unregister_device/input_free_device

 .../bindings/input/vt8500-power-keypad.txt         |   17 ++
 drivers/input/keyboard/Kconfig                     |   10 ++
 drivers/input/keyboard/Makefile                    |    1 +
 drivers/input/keyboard/wmt_power_keypad.c          |  182 ++++++++++++++++++++
 4 files changed, 210 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/input/vt8500-power-keypad.txt
 create mode 100644 drivers/input/keyboard/wmt_power_keypad.c

diff --git a/Documentation/devicetree/bindings/input/vt8500-power-keypad.txt b/Documentation/devicetree/bindings/input/vt8500-power-keypad.txt
new file mode 100644
index 0000000..f6996d5
--- /dev/null
+++ b/Documentation/devicetree/bindings/input/vt8500-power-keypad.txt
@@ -0,0 +1,17 @@
+* Wondermedia Power Keypad device tree bindings
+
+Wondermedia SoCs have a single irq-driven power button attached to
+the power management controller.
+
+Required SoC Specific Properties:
+- compatible: should be one of the following
+   - "wm,power-keypad": For all Wondermedia 8xxx-series SoCs.
+- reg : Should contain the register range of the Power Mgmt controller
+- interrupts: should be the power management controller wakeup interrupt.
+
+Example:
+	powerkey: pwrkey@0 {
+		compatible = "wm,power-keypad";
+		reg = <0xd8130000 0x1000>;
+		interrupts = <22>;
+	};
diff --git a/drivers/input/keyboard/Kconfig b/drivers/input/keyboard/Kconfig
index 5a240c6..bb1e04f 100644
--- a/drivers/input/keyboard/Kconfig
+++ b/drivers/input/keyboard/Kconfig
@@ -595,6 +595,16 @@ config KEYBOARD_TWL4030
 	  To compile this driver as a module, choose M here: the
 	  module will be called twl4030_keypad.
 
+config KEYBOARD_WMT_POWER_KEYPAD
+	tristate "Wondermedia Power keypad support"
+	depends on (OF && ARCH_VT8500)
+	help
+	  Say Y here to enable support for the power button keypad
+	  on Wondermedia 8xxx-series SoCs.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called wmt_power_keypad.
+
 config KEYBOARD_XTKBD
 	tristate "XT keyboard"
 	select SERIO
diff --git a/drivers/input/keyboard/Makefile b/drivers/input/keyboard/Makefile
index 44e7600..eea31af 100644
--- a/drivers/input/keyboard/Makefile
+++ b/drivers/input/keyboard/Makefile
@@ -52,5 +52,6 @@ obj-$(CONFIG_KEYBOARD_TC3589X)		+= tc3589x-keypad.o
 obj-$(CONFIG_KEYBOARD_TEGRA)		+= tegra-kbc.o
 obj-$(CONFIG_KEYBOARD_TNETV107X)	+= tnetv107x-keypad.o
 obj-$(CONFIG_KEYBOARD_TWL4030)		+= twl4030_keypad.o
+obj-$(CONFIG_KEYBOARD_WMT_POWER_KEYPAD)	+= wmt_power_keypad.o
 obj-$(CONFIG_KEYBOARD_XTKBD)		+= xtkbd.o
 obj-$(CONFIG_KEYBOARD_W90P910)		+= w90p910_keypad.o
diff --git a/drivers/input/keyboard/wmt_power_keypad.c b/drivers/input/keyboard/wmt_power_keypad.c
new file mode 100644
index 0000000..383b73e
--- /dev/null
+++ b/drivers/input/keyboard/wmt_power_keypad.c
@@ -0,0 +1,182 @@
+/* Wondermedia Power Keypad
+ *
+ * Copyright (C) 2012 Tony Prisk <linux@prisktech.co.nz>
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
+ */
+
+#include <linux/module.h>
+#include <linux/err.h>
+#include <linux/io.h>
+#include <linux/input.h>
+#include <linux/interrupt.h>
+#include <linux/platform_device.h>
+#include <linux/bitops.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/of_irq.h>
+#include <linux/of_device.h>
+
+struct kpad_pwr_data {
+	struct input_dev	*kpad_power;
+	void __iomem		*pmc_base;
+	int			irq;
+	struct timer_list	timer;
+	spinlock_t		lock;
+	unsigned int		keycode;
+};
+
+static void kpad_power_timeout(unsigned long fcontext)
+{
+	struct kpad_pwr_data *data = (struct kpad_pwr_data *)fcontext;
+	unsigned long flags;
+
+	spin_lock_irqsave(&data->lock, flags);
+
+	input_report_key(data->kpad_power, data->keycode, 0);
+	input_sync(data->kpad_power);
+
+	spin_unlock_irqrestore(&data->lock, flags);
+}
+
+static irqreturn_t kpad_power_isr(int irq_num, void *priv)
+{
+	struct kpad_pwr_data *data = priv;
+	u32 status;
+	unsigned long flags;
+
+	spin_lock_irqsave(&data->lock, flags);
+
+	status = readl(data->pmc_base + 0x14);
+	writel(status, data->pmc_base + 0x14);
+
+	if (status & BIT(14)) {
+		input_report_key(data->kpad_power, data->keycode, 1);
+		input_sync(data->kpad_power);
+		mod_timer(&data->timer, jiffies + msecs_to_jiffies(250));
+	}
+
+	spin_unlock_irqrestore(&data->lock, flags);
+
+	return IRQ_HANDLED;
+}
+
+static int vt8500_pwr_kpad_probe(struct platform_device *pdev)
+{
+	struct device_node *np = pdev->dev.of_node;
+	struct kpad_pwr_data *data;
+	u32 status;
+	int err;
+
+	if (!np) {
+		dev_err(&pdev->dev, "devicenode not found\n");
+		return -ENODEV;
+	}
+
+	data = devm_kzalloc(&pdev->dev, sizeof(*data), GFP_KERNEL);
+	if (!data) {
+		dev_err(&pdev->dev, "unable to allocate private data\n");
+		return -ENOMEM;
+	}
+
+	platform_set_drvdata(pdev, data);
+	data->keycode = KEY_POWER;
+	spin_lock_init(&data->lock);
+
+	data->pmc_base = of_iomap(np, 0);
+	if (!data->pmc_base) {
+		dev_err(&pdev->dev, "unable to map pmc memory\n");
+		return -ENOMEM;
+	}
+
+	/* set power button to soft-power */
+	status = readl(data->pmc_base + 0x54);
+	writel(status | 1, data->pmc_base + 0x54);
+
+	/* clear any pending interrupts */
+	status = readl(data->pmc_base + 0x14);
+	writel(status, data->pmc_base + 0x14);
+
+	data->kpad_power = input_allocate_device();
+	if (!data->kpad_power) {
+		dev_err(&pdev->dev, "failed to allocate input device\n");
+		return -ENOMEM;
+	}
+
+	input_set_capability(data->kpad_power, EV_KEY, data->keycode);
+
+	data->kpad_power->name = "Wondermedia Power Button";
+	data->kpad_power->phys = "vt8500-pmc/input0";
+	data->kpad_power->keycode = &data->keycode;
+	data->kpad_power->keycodesize = sizeof(unsigned int);
+	data->kpad_power->keycodemax = 1;
+
+	setup_timer(&data->timer, kpad_power_timeout, (unsigned long)data);
+
+	data->irq = irq_of_parse_and_map(np, 0);
+	err = request_irq(data->irq, &kpad_power_isr, 0, "pwrbtn", data);
+	if (err < 0) {
+		dev_err(&pdev->dev, "failed to request irq\n");
+		goto cleanup_irq;
+	}
+
+	err = input_register_device(data->kpad_power);
+	if (err < 0) {
+		dev_err(&pdev->dev, "failed to register input device\n");
+		goto cleanup_input;
+	}
+
+	return 0;
+
+cleanup_input:
+	free_irq(data->irq, NULL);
+cleanup_irq:
+	del_timer(&data->timer);
+	input_free_device(data->kpad_power);
+	iounmap(data->pmc_base);
+	return err;
+}
+
+static int vt8500_pwr_kpad_remove(struct platform_device *pdev)
+
+{
+	struct kpad_pwr_data *data = platform_get_drvdata(pdev);
+
+	free_irq(data->irq, data);
+	del_timer_sync(&data->timer);
+	input_unregister_device(data->kpad_power);
+	iounmap(data->pmc_base);
+
+	return 0;
+}
+
+
+static struct of_device_id vt8500_pwr_kpad_dt_ids[] = {
+	{ .compatible = "wm,power-keypad" },
+	{ /* Sentinel */ },
+};
+
+static struct platform_driver vt8500_pwr_kpad_driver = {
+	.probe		= vt8500_pwr_kpad_probe,
+	.remove		= vt8500_pwr_kpad_remove,
+	.driver		= {
+		.name	= "wmt-power-keypad",
+		.owner	= THIS_MODULE,
+		.of_match_table = vt8500_pwr_kpad_dt_ids,
+	},
+};
+
+module_platform_driver(vt8500_pwr_kpad_driver);
+
+MODULE_DESCRIPTION("Wondermedia Power Keypad Driver");
+MODULE_AUTHOR("Tony Prisk <linux@prisktech.co.nz>");
+MODULE_LICENSE("GPL v2");
+MODULE_DEVICE_TABLE(of, vt8500_pwr_kpad_dt_ids);
-- 
1.7.9.5

