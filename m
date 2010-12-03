Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752821Ab0LCPcj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 10:32:39 -0500
Received: from eu1sys200aog109.obsmtp.com ([207.126.144.127]:39053 "EHLO
	eu1sys200aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751349Ab0LCPcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 10:32:17 -0500
From: Sundar Iyer <sundar.iyer@stericsson.com>
To: <linux-arm-kernel@lists.infradead.org>, <dmitry.torokhov@gmail.com>,
        <sameo@linux.intel.com>, <ben-linux@fluff.org>
Cc: <linux-input@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Sundar Iyer <sundar.iyer@stericsson.com>
Subject: [PATCH 10/20] input/tc3589x: add tc3589x keypad support
Date: Fri, 3 Dec 2010 20:35:43 +0530
Message-ID: <1291388753-14662-11-git-send-email-sundar.iyer@stericsson.com>
X-Mailer: git-send-email 1.7.2.dirty
In-Reply-To: <1291388753-14662-1-git-send-email-sundar.iyer@stericsson.com>
References: <1291388753-14662-1-git-send-email-sundar.iyer@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for the keypad controller module found on the
TC3589X devices. This driver default adds the support for
TC35893 device.

Signed-off-by: Sundar Iyer <sundar.iyer@stericsson.com>
---
 drivers/input/keyboard/Kconfig          |   10 +
 drivers/input/keyboard/Makefile         |    1 +
 drivers/input/keyboard/tc3589x-keypad.c |  440 +++++++++++++++++++++++++++++++
 drivers/mfd/tc3589x.c                   |   28 ++-
 include/linux/mfd/tc3589x.h             |   52 ++++
 5 files changed, 530 insertions(+), 1 deletions(-)
 create mode 100644 drivers/input/keyboard/tc3589x-keypad.c

diff --git a/drivers/input/keyboard/Kconfig b/drivers/input/keyboard/Kconfig
index ee85e5b..0231ad3 100644
--- a/drivers/input/keyboard/Kconfig
+++ b/drivers/input/keyboard/Kconfig
@@ -452,6 +452,16 @@ config KEYBOARD_SPEAR
 	  To compile this driver as a module, choose M here: the
 	  module will be called spear-keboard.
 
+config KEYBOARD_TC3589X
+	tristate "TC3589X Keypad support"
+	depends on MFD_TC3589X
+	help
+	  Say Y here if you want to use the keypad controller on
+	  TC35892/3 I/O expander
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called tc3589x-keypad
+
 config KEYBOARD_TNETV107X
 	tristate "TI TNETV107X keypad support"
 	depends on ARCH_DAVINCI_TNETV107X
diff --git a/drivers/input/keyboard/Makefile b/drivers/input/keyboard/Makefile
index 8449c73..8ff1455 100644
--- a/drivers/input/keyboard/Makefile
+++ b/drivers/input/keyboard/Makefile
@@ -41,6 +41,7 @@ obj-$(CONFIG_KEYBOARD_SPEAR)		+= spear-keyboard.o
 obj-$(CONFIG_KEYBOARD_STMPE)		+= stmpe-keypad.o
 obj-$(CONFIG_KEYBOARD_STOWAWAY)		+= stowaway.o
 obj-$(CONFIG_KEYBOARD_SUNKBD)		+= sunkbd.o
+obj-$(CONFIG_KEYBOARD_TC3589X)		+= tc3589x-keypad.o
 obj-$(CONFIG_KEYBOARD_TNETV107X)	+= tnetv107x-keypad.o
 obj-$(CONFIG_KEYBOARD_TWL4030)		+= twl4030_keypad.o
 obj-$(CONFIG_KEYBOARD_XTKBD)		+= xtkbd.o
diff --git a/drivers/input/keyboard/tc3589x-keypad.c b/drivers/input/keyboard/tc3589x-keypad.c
new file mode 100644
index 0000000..1bfd49a
--- /dev/null
+++ b/drivers/input/keyboard/tc3589x-keypad.c
@@ -0,0 +1,440 @@
+/*
+ * Copyright (C) ST-Ericsson SA 2010
+ *
+ * Author: Jayeeta Banerjee <jayeeta.banerjee@stericsson.com>
+ * Author: Sundar Iyer <sundar.iyer@stericsson.com>
+ *
+ * License Terms: GNU General Public License, version 2
+ *
+ * TC35893 MFD Keypad Controller driver
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/spinlock.h>
+#include <linux/input.h>
+#include <linux/platform_device.h>
+#include <linux/input/matrix_keypad.h>
+#include <linux/i2c.h>
+#include <linux/slab.h>
+#include <linux/mfd/tc3589x.h>
+
+/* Maximum supported keypad matrix row/columns size */
+#define TC3589x_MAX_KPROW               8
+#define TC3589x_MAX_KPCOL               12
+
+/* keypad related Constants */
+#define TC3589x_MAX_DEBOUNCE_SETTLE     0xFF
+#define DEDICATED_KEY_VAL		0xFF
+
+/* Pull up/down masks */
+#define TC3589x_NO_PULL_MASK		0x0
+#define TC3589x_PULL_DOWN_MASK		0x1
+#define TC3589x_PULL_UP_MASK		0x2
+#define TC3589x_PULLUP_ALL_MASK		0xAA
+#define TC3589x_IO_PULL_VAL(index, mask)	((mask)<<((index)%4)*2))
+
+/* Bit masks for IOCFG register */
+#define IOCFG_BALLCFG		0x01
+#define IOCFG_IG		0x08
+
+#define KP_EVCODE_COL_MASK	0x0F
+#define KP_EVCODE_ROW_MASK	0x70
+#define KP_RELEASE_EVT_MASK	0x80
+
+#define KP_ROW_SHIFT		4
+
+#define KP_NO_VALID_KEY_MASK	0x7F
+
+/* bit masks for RESTCTRL register */
+#define TC3589x_KBDRST		0x2
+#define TC3589x_IRQRST		0x10
+#define TC3589x_RESET_ALL	0x1B
+
+/* KBDMFS register bit mask */
+#define TC3589x_KBDMFS_EN	0x1
+
+/* CLKEN register bitmask */
+#define KPD_CLK_EN		0x1
+
+/* RSTINTCLR register bit mask */
+#define IRQ_CLEAR		0x1
+
+/* bit masks for keyboard interrupts*/
+#define TC3589x_EVT_LOSS_INT	0x8
+#define TC3589x_EVT_INT		0x4
+#define TC3589x_KBD_LOSS_INT	0x2
+#define TC3589x_KBD_INT		0x1
+
+/* bit masks for keyboard interrupt clear*/
+#define TC3589x_EVT_INT_CLR	0x2
+#define TC3589x_KBD_INT_CLR	0x1
+
+#define TC3589x_KBD_KEYMAP_SIZE     64
+
+/**
+ * struct tc_keypad - data structure used by keypad driver
+ * @input:      pointer to input device object
+ * @board:      keypad platform device
+ * @krow:	number of rows
+ * @kcol:	number of coloumns
+ * @keymap:     matrix scan code table for keycodes
+ */
+struct tc_keypad {
+	struct tc3589x *tc3589x;
+	struct input_dev *input;
+	const struct tc3589x_keypad_platform_data *board;
+	unsigned int krow;
+	unsigned int kcol;
+	unsigned short keymap[TC3589x_KBD_KEYMAP_SIZE];
+};
+
+static int __devinit tc3589x_keypad_init_key_hardware(struct tc_keypad *keypad)
+{
+	int ret;
+	struct tc3589x *tc3589x = keypad->tc3589x;
+	u8 settle_time = keypad->board->settle_time;
+	u8 dbounce_period = keypad->board->debounce_period;
+	u8 rows = keypad->board->krow & 0xf;	/* mask out the nibble */
+	u8 column = keypad->board->kcol & 0xf;	/* mask out the nibble */
+
+	/* validate platform configurations */
+	if ((keypad->board->kcol > TC3589x_MAX_KPCOL) ||
+	    (keypad->board->krow > TC3589x_MAX_KPROW) ||
+	    (keypad->board->debounce_period > TC3589x_MAX_DEBOUNCE_SETTLE) ||
+	    (keypad->board->settle_time > TC3589x_MAX_DEBOUNCE_SETTLE))
+		return -EINVAL;
+
+	/* configure KBDSIZE 4 LSbits for cols and 4 MSbits for rows */
+	ret = tc3589x_set_bits(tc3589x, TC3589x_KBDSIZE, 0x0,
+			(rows << KP_ROW_SHIFT) | column);
+	if (ret < 0)
+		return ret;
+
+	/* configure dedicated key config, no dedicated key selected */
+	ret = tc3589x_set_bits(tc3589x, TC3589x_KBCFG_LSB,
+						0x0, DEDICATED_KEY_VAL);
+	if (ret < 0)
+		return ret;
+
+	ret = tc3589x_set_bits(tc3589x, TC3589x_KBCFG_MSB,
+						0x0, DEDICATED_KEY_VAL);
+	if (ret < 0)
+		return ret;
+
+	/* Configure settle time */
+	ret = tc3589x_set_bits(tc3589x, TC3589x_KBDSETTLE_REG,
+						0x0, settle_time);
+	if (ret < 0)
+		return ret;
+
+	/* Configure debounce time */
+	ret = tc3589x_set_bits(tc3589x, TC3589x_KBDBOUNCE, 0x0, dbounce_period);
+	if (ret < 0)
+		return ret;
+
+	/* Start of initialise keypad GPIOs */
+	ret = tc3589x_set_bits(tc3589x, TC3589x_IOCFG, 0x0, IOCFG_IG);
+	if (ret < 0)
+		return ret;
+
+	/* Configure pull-up resistors for all row GPIOs */
+	ret = tc3589x_set_bits(tc3589x, TC3589x_IOPULLCFG0_LSB, 0x0,
+			TC3589x_PULLUP_ALL_MASK);
+	if (ret < 0)
+		return ret;
+
+	ret = tc3589x_set_bits(tc3589x, TC3589x_IOPULLCFG0_MSB, 0x0,
+			TC3589x_PULLUP_ALL_MASK);
+	if (ret < 0)
+		return ret;
+
+	/* Configure pull-up resistors for all column GPIOs */
+	ret = tc3589x_set_bits(tc3589x, TC3589x_IOPULLCFG1_LSB, 0x0,
+			TC3589x_PULLUP_ALL_MASK);
+	if (ret < 0)
+		return ret;
+
+	ret = tc3589x_set_bits(tc3589x, TC3589x_IOPULLCFG1_MSB, 0x0,
+			TC3589x_PULLUP_ALL_MASK);
+	if (ret < 0)
+		return ret;
+
+	ret = tc3589x_set_bits(tc3589x, TC3589x_IOPULLCFG2_LSB, 0x0,
+			TC3589x_PULLUP_ALL_MASK);
+
+	return ret;
+}
+
+#define TC35893_DATA_REGS              4
+#define TC35893_KEYCODE_FIFO_EMPTY     0x7f
+#define TC35893_KEYCODE_FIFO_CLEAR     0xff
+
+static irqreturn_t tc3589x_keypad_irq(int irq, void *dev)
+{
+	struct tc_keypad *keypad = (struct tc_keypad *)dev;
+	struct tc3589x *tc3589x = keypad->tc3589x;
+	u8 i, row_index, col_index, kbd_code, up;
+	u8 code;
+
+	for (i = 0; i < (TC35893_DATA_REGS * 2); i++) {
+		kbd_code = tc3589x_reg_read(tc3589x, TC3589x_EVTCODE_FIFO);
+
+		/* loop till fifo is empty and no more keys are pressed */
+		if ((kbd_code == TC35893_KEYCODE_FIFO_EMPTY) ||
+				(kbd_code == TC35893_KEYCODE_FIFO_CLEAR))
+			continue;
+
+		/* valid key is found */
+		col_index = kbd_code & KP_EVCODE_COL_MASK;
+		row_index = (kbd_code & KP_EVCODE_ROW_MASK) >> KP_ROW_SHIFT;
+		code = MATRIX_SCAN_CODE(row_index, col_index, 0x3);
+		up = kbd_code & KP_RELEASE_EVT_MASK;
+
+		input_event(keypad->input, EV_MSC, MSC_SCAN, code);
+		input_report_key(keypad->input, keypad->keymap[code], !up);
+		input_sync(keypad->input);
+	}
+
+	/* clear IRQ */
+	tc3589x_set_bits(tc3589x, TC3589x_KBDIC,
+			0x0, TC3589x_EVT_INT_CLR | TC3589x_KBD_INT_CLR);
+	/* enable IRQ */
+	tc3589x_set_bits(tc3589x, TC3589x_KBDMSK,
+			0x0, TC3589x_EVT_LOSS_INT | TC3589x_EVT_INT);
+
+	return IRQ_HANDLED;
+}
+
+static int tc3589x_keypad_enable(struct tc3589x *tc3589x)
+{
+	int ret;
+
+	/* pull the keypad module out of reset */
+	ret = tc3589x_set_bits(tc3589x, TC3589x_RSTCTRL, TC3589x_KBDRST, 0x0);
+	if (ret < 0)
+		return ret;
+
+	/* configure KBDMFS */
+	ret = tc3589x_set_bits(tc3589x, TC3589x_KBDMFS, 0x0, TC3589x_KBDMFS_EN);
+	if (ret < 0)
+		return ret;
+
+	/* enable the keypad clock */
+	ret = tc3589x_set_bits(tc3589x, TC3589x_CLKEN, 0x0, KPD_CLK_EN);
+	if (ret < 0)
+		return ret;
+
+	/* clear pending IRQs */
+	ret =  tc3589x_set_bits(tc3589x, TC3589x_RSTINTCLR, 0x0, 0x1);
+	if (ret < 0)
+		return ret;
+
+	/* enable the IRQs */
+	ret = tc3589x_set_bits(tc3589x, TC3589x_KBDMSK, 0x0,
+					TC3589x_EVT_LOSS_INT | TC3589x_EVT_INT);
+
+	return ret;
+}
+
+static int tc3589x_keypad_disable(struct tc3589x *tc3589x)
+{
+	int ret;
+
+	/* clear IRQ */
+	ret = tc3589x_set_bits(tc3589x, TC3589x_KBDIC,
+			0x0, TC3589x_EVT_INT_CLR | TC3589x_KBD_INT_CLR);
+	if (ret < 0)
+		return ret;
+
+	/* disable all interrupts */
+	ret = tc3589x_set_bits(tc3589x, TC3589x_KBDMSK,
+			~(TC3589x_EVT_LOSS_INT | TC3589x_EVT_INT), 0x0);
+	if (ret < 0)
+		return ret;
+
+	/* disable the keypad module */
+	ret = tc3589x_set_bits(tc3589x, TC3589x_CLKEN, 0x1, 0x0);
+	if (ret < 0)
+		return ret;
+
+	/* put the keypad module into reset */
+	ret = tc3589x_set_bits(tc3589x, TC3589x_RSTCTRL, TC3589x_KBDRST, 0x1);
+
+	return ret;
+}
+
+static int __devinit tc3589x_keypad_probe(struct platform_device *pdev)
+{
+	struct tc3589x *tc3589x = dev_get_drvdata(pdev->dev.parent);
+	struct tc_keypad *keypad;
+	struct input_dev *input;
+	const struct tc3589x_keypad_platform_data *plat;
+	int error, irq;
+
+	plat  = tc3589x->pdata->keypad;
+	if (!plat) {
+		dev_err(&pdev->dev, "invalid keypad platform data\n");
+		return -EINVAL;
+	}
+
+	irq = platform_get_irq(pdev, 0);
+	if (irq < 0)
+		return irq;
+
+	keypad = kzalloc(sizeof(struct tc_keypad), GFP_KERNEL);
+	input = input_allocate_device();
+	if (!keypad || !input) {
+		dev_err(&pdev->dev, "failed to allocate keypad memory\n");
+		error = -ENOMEM;
+		goto err_free_mem;
+	}
+
+	keypad->board = plat;
+	keypad->input = input;
+	keypad->tc3589x = tc3589x;
+
+	/* enable the keypad module */
+	error = tc3589x_keypad_enable(tc3589x);
+	if (error < 0) {
+		dev_err(&pdev->dev, "failed to enable keypad module\n");
+		goto err_free_mem;
+	}
+
+	error = tc3589x_keypad_init_key_hardware(keypad);
+	if (error < 0) {
+		dev_err(&pdev->dev, "failed to configure keypad module\n");
+		goto err_free_mem;
+	}
+
+	input->id.bustype = BUS_HOST;
+	input->name = pdev->name;
+	input->dev.parent = &pdev->dev;
+
+	input->keycode = keypad->keymap;
+	input->keycodesize = sizeof(keypad->keymap[0]);
+	input->keycodemax = ARRAY_SIZE(keypad->keymap);
+
+	input_set_capability(input, EV_MSC, MSC_SCAN);
+
+	__set_bit(EV_KEY, input->evbit);
+	if (!plat->no_autorepeat)
+		__set_bit(EV_REP, input->evbit);
+
+	matrix_keypad_build_keymap(plat->keymap_data, 0x3,
+			input->keycode, input->keybit);
+
+	error = request_threaded_irq(irq, NULL,
+			tc3589x_keypad_irq, plat->irqtype,
+			"tc3589x-keypad", keypad);
+	if (error < 0) {
+		dev_err(&pdev->dev,
+				"Could not allocate irq %d,error %d\n",
+				irq, error);
+		goto err_free_mem;
+	}
+
+	error = input_register_device(input);
+	if (error) {
+		dev_err(&pdev->dev, "Could not register input device\n");
+		goto err_free_irq;
+	}
+
+	device_init_wakeup(&pdev->dev, plat->enable_wakeup);
+	device_set_wakeup_capable(&pdev->dev, plat->enable_wakeup);
+
+	platform_set_drvdata(pdev, keypad);
+
+	return 0;
+
+err_free_irq:
+	free_irq(irq, keypad);
+err_free_mem:
+	input_free_device(input);
+	kfree(keypad);
+	return error;
+}
+
+static int __devexit tc3589x_keypad_remove(struct platform_device *pdev)
+{
+	struct tc_keypad *keypad = platform_get_drvdata(pdev);
+	struct tc3589x *tc3589x = keypad->tc3589x;
+	int irq = platform_get_irq(pdev, 0);
+
+	free_irq(irq, keypad);
+
+	input_unregister_device(keypad->input);
+
+	tc3589x_keypad_disable(tc3589x);
+
+	kfree(keypad);
+
+	return 0;
+}
+
+#ifdef CONFIG_PM
+static int tc3589x_keypad_suspend(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct tc_keypad *keypad = platform_get_drvdata(pdev);
+	struct tc3589x *tc3589x = keypad->tc3589x;
+	int irq = platform_get_irq(pdev, 0);
+
+	/* disable the IRQ */
+	if (!device_may_wakeup(&pdev->dev))
+		tc3589x_keypad_disable(tc3589x);
+	else
+		enable_irq_wake(irq);
+
+	return 0;
+}
+
+static int tc3589x_keypad_resume(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct tc_keypad *keypad = platform_get_drvdata(pdev);
+	struct tc3589x *tc3589x = keypad->tc3589x;
+	int irq = platform_get_irq(pdev, 0);
+
+	/* enable the IRQ */
+	if (!device_may_wakeup(&pdev->dev))
+		tc3589x_keypad_enable(tc3589x);
+	else
+		disable_irq_wake(irq);
+
+	return 0;
+}
+
+static const struct dev_pm_ops tc3589x_keypad_dev_pm_ops = {
+	.suspend = tc3589x_keypad_suspend,
+	.resume  = tc3589x_keypad_resume,
+};
+#endif
+
+static struct platform_driver tc3589x_keypad_driver = {
+	.driver.name  = "tc3589x-keypad",
+	.driver.owner = THIS_MODULE,
+#ifdef CONFIG_PM
+	.driver.pm = &tc3589x_keypad_dev_pm_ops,
+#endif
+	.probe = tc3589x_keypad_probe,
+	.remove = __devexit_p(tc3589x_keypad_remove),
+};
+
+static int __init tc3589x_keypad_init(void)
+{
+	return platform_driver_register(&tc3589x_keypad_driver);
+}
+
+static void __exit tc3589x_keypad_exit(void)
+{
+	return platform_driver_unregister(&tc3589x_keypad_driver);
+}
+
+module_init(tc3589x_keypad_init);
+module_exit(tc3589x_keypad_exit);
+
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR("Jayeeta Banerjee/Sundar Iyer");
+MODULE_DESCRIPTION("TC35893 Keypad Driver");
diff --git a/drivers/mfd/tc3589x.c b/drivers/mfd/tc3589x.c
index 0ed9669..5672d56 100644
--- a/drivers/mfd/tc3589x.c
+++ b/drivers/mfd/tc3589x.c
@@ -129,6 +129,14 @@ static struct resource gpio_resources[] = {
 	},
 };
 
+static struct resource keypad_resources[] = {
+	{
+		.start  = TC3589x_INT_KBDIRQ,
+		.end    = TC3589x_INT_KBDIRQ,
+		.flags  = IORESOURCE_IRQ,
+	},
+};
+
 static struct mfd_cell tc3589x_dev_gpio[] = {
 	{
 		.name		= "tc3589x-gpio",
@@ -137,6 +145,14 @@ static struct mfd_cell tc3589x_dev_gpio[] = {
 	},
 };
 
+static struct mfd_cell tc3589x_dev_keypad[] = {
+	{
+		.name           = "tc3589x-keypad",
+		.num_resources  = ARRAY_SIZE(keypad_resources),
+		.resources      = &keypad_resources[0],
+	},
+};
+
 static irqreturn_t tc3589x_irq(int irq, void *data)
 {
 	struct tc3589x *tc3589x = data;
@@ -256,8 +272,18 @@ static int __devinit tc3589x_device_init(struct tc3589x *tc3589x)
 		dev_info(tc3589x->dev, "added gpio block\n");
 	}
 
-	return ret;
+	if (blocks & TC3589x_BLOCK_KEYPAD) {
+		ret = mfd_add_devices(tc3589x->dev, -1, tc3589x_dev_keypad,
+				ARRAY_SIZE(tc3589x_dev_keypad), NULL,
+				tc3589x->irq_base);
+		if (ret) {
+			dev_err(tc3589x->dev, "failed to keypad child\n");
+			return ret;
+		}
+		dev_info(tc3589x->dev, "added keypad block\n");
+	}
 
+	return ret;
 }
 
 static int __devinit tc3589x_probe(struct i2c_client *i2c,
diff --git a/include/linux/mfd/tc3589x.h b/include/linux/mfd/tc3589x.h
index da00958..8550e00 100644
--- a/include/linux/mfd/tc3589x.h
+++ b/include/linux/mfd/tc3589x.h
@@ -20,6 +20,17 @@ enum tx3589x_block {
 #define TC3589x_RSTCTRL_KBDRST	(1 << 1)
 #define TC3589x_RSTCTRL_GPIRST	(1 << 0)
 
+/* Keyboard Configuration Registers */
+#define TC3589x_KBDSETTLE_REG   0x01
+#define TC3589x_KBDBOUNCE       0x02
+#define TC3589x_KBDSIZE         0x03
+#define TC3589x_KBCFG_LSB       0x04
+#define TC3589x_KBCFG_MSB       0x05
+#define TC3589x_KBDIC           0x08
+#define TC3589x_KBDMSK          0x09
+#define TC3589x_EVTCODE_FIFO    0x10
+#define TC3589x_KBDMFS		0x8F
+
 #define TC3589x_IRQST		0x91
 
 #define TC3589x_MANFCODE_MAGIC	0x03
@@ -35,6 +46,14 @@ enum tx3589x_block {
 #define TC3589x_EXTRSTN		0x83
 #define TC3589x_RSTINTCLR	0x84
 
+/* Pull up/down configuration registers */
+#define TC3589x_IOCFG           0xA7
+#define TC3589x_IOPULLCFG0_LSB  0xAA
+#define TC3589x_IOPULLCFG0_MSB  0xAB
+#define TC3589x_IOPULLCFG1_LSB  0xAC
+#define TC3589x_IOPULLCFG1_MSB  0xAD
+#define TC3589x_IOPULLCFG2_LSB  0xAE
+
 #define TC3589x_GPIOIS0		0xC9
 #define TC3589x_GPIOIS1		0xCA
 #define TC3589x_GPIOIS2		0xCB
@@ -112,6 +131,37 @@ extern int tc3589x_block_write(struct tc3589x *tc3589x, u8 reg, u8 length,
 			       const u8 *values);
 extern int tc3589x_set_bits(struct tc3589x *tc3589x, u8 reg, u8 mask, u8 val);
 
+/*
+ * Keypad related platform specific constants
+ * These values may be modified for fine tuning
+ */
+#define TC_KPD_ROWS             0x8
+#define TC_KPD_COLUMNS          0x8
+#define TC_KPD_DEBOUNCE_PERIOD  0xA3
+#define TC_KPD_SETTLE_TIME      0xA3
+
+/**
+ * struct tc35893_platform_data - data structure for platform specific data
+ * @keymap_data:        matrix scan code table for keycodes
+ * @krow:               mask for available rows, value is 0xFF
+ * @kcol:               mask for available columns, value is 0xFF
+ * @debounce_period:    platform specific debounce time
+ * @settle_time:        platform specific settle down time
+ * @irqtype:            type of interrupt, falling or rising edge
+ * @enable_wakeup:      specifies if keypad event can wake up system from sleep
+ * @no_autorepeat:      flag for auto repetition
+ */
+struct tc3589x_keypad_platform_data {
+	struct matrix_keymap_data *keymap_data;
+	u8                      krow;
+	u8                      kcol;
+	u8                      debounce_period;
+	u8                      settle_time;
+	unsigned long           irqtype;
+	bool                    enable_wakeup;
+	bool                    no_autorepeat;
+};
+
 /**
  * struct tc3589x_gpio_platform_data - TC3589x GPIO platform data
  * @gpio_base: first gpio number assigned to TC3589x.  A maximum of
@@ -130,11 +180,13 @@ struct tc3589x_gpio_platform_data {
  * @block: bitmask of blocks to enable (use TC3589x_BLOCK_*)
  * @irq_base: base IRQ number.  %TC3589x_NR_IRQS irqs will be used.
  * @gpio: GPIO-specific platform data
+ * @keypad: keypad-specific platform data
  */
 struct tc3589x_platform_data {
 	unsigned int block;
 	int irq_base;
 	struct tc3589x_gpio_platform_data *gpio;
+	struct tc3589x_keypad_platform_data *keypad;
 };
 
 #define TC3589x_NR_GPIOS	24
-- 
1.7.2.dirty

