Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755417Ab2FYJfT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 05:35:19 -0400
Received: from mail.work-microwave.de ([62.245.205.51]:33677 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751677Ab2FYJfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 05:35:17 -0400
From: Roland Stigge <stigge@antcom.de>
To: dmitry.torokhov@gmail.com, axel.lin@gmail.com, riyer@nvidia.com,
        michael.hennerich@analog.com, grant.likely@secretlab.ca,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kevin.wells@nxp.com,
        srinivas.bakki@nxp.com, devicetree-discuss@lists.ozlabs.org,
        rob.herring@calxeda.com, aletes.xgr@gmail.com
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH v7] input: keyboard: Add keys driver for the LPC32xx SoC
Date: Mon, 25 Jun 2012 11:34:26 +0200
Message-Id: <1340616866-16811-1-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.10
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a driver for the key scan interface of the LPC32xx SoC

Signed-off-by: Roland Stigge <stigge@antcom.de>

---
Applies to v3.5-rc4

Changes since v6:
* Clear IRQ in LPC32XX_KS_IRQ register in lpc32xx_kscan_{open,close}
* Declare lpc32xx_parse_dt() static
* Pass kscandat to lpc32xx_parse_dt() instead of pdev
* Moved keymap allocation to probe()
* Use clk_prepare_enable() and clk_disable_unprepare() in probe(),
  around actual register access
* Do input_allocate_device() earlier, after kscandat allocation
* Do input_register_device() last in probe()
* suspend()/resume(): take mutex, and guard against (users == 0)

Changes since v5:
* Handle return code from matrix_keypad_build_keymap()
* Remove platform data structure and integrate into device struct

Changes since v4:
* Remove irq from struct lpc32xx_kscan_drv

Changes since v3:
* Make driver DT-only since LPC32xx is converted to DT anyway now.
* Use MATRIX_SCAN_CODE()
* Use matrix_keypad_build_keymap()
* Emit MSC_SCAN also
* Use PTR_ERR() on error handling
* Rename return value to error
* Removed unnecessary '&' on initializations with function pointers
* Use CONFIG_PM_SLEEP, dev_pm_ops, SIMPLE_DEV_PM_OPS instead of CONFIG_PM
* Removed devm_*() management
* Re-enabled clock for period of probe()

Changes since v2:
* Fixed case of lpc32XX_* -> lpc32xx_*
* Removed unnecessary casts
* Removed unnecessary unlikely()
* Use unsigned for key bits
* Included Russell's lpc32xx_mod_states() algorithm change suggestion
* Replaced (res == NULL) with (!res)
* clk_enable() -> clk_prepare_enable()
* Moved clk_prepare_enable() and clk_disable_unprepare() to input's
  open()/close() callbacks to save power
* Handle clk_prepare_enable() return value appropriately
* DT: Use "keypad,num-rows", "keypad,num-columns" and "linux,keymap" properties

Changes since v1:
* Removed devm_kfree(), lpc32XX_free_dt(), iounmap(), release_mem_region()
* Changed __raw_writel()+__raw_readl() to writel()+readl()

Thanks to Axel Lin, Russell King, Rob Herring, Shubhrajyoti and Dmitry Torokhov
for reviewing!

 Documentation/devicetree/bindings/input/lpc32xx-key.txt |   28 +
 drivers/input/keyboard/Kconfig                          |   10 
 drivers/input/keyboard/Makefile                         |    1 
 drivers/input/keyboard/lpc32xx-keys.c                   |  379 ++++++++++++++++
 4 files changed, 418 insertions(+)

--- /dev/null
+++ linux-2.6/Documentation/devicetree/bindings/input/lpc32xx-key.txt
@@ -0,0 +1,28 @@
+NXP LPC32xx Key Scan Interface
+
+Required Properties:
+- compatible: Should be "nxp,lpc3220-key"
+- reg: Physical base address of the controller and length of memory mapped
+  region.
+- interrupts: The interrupt number to the cpu.
+- keypad,num-rows: Number of rows and columns, e.g. 1: 1x1, 6: 6x6
+- keypad,num-columns: Must be equal to keypad,num-rows since LPC32xx only
+  supports square matrices
+- nxp,debounce-delay-ms: Debounce delay in ms
+- nxp,scan-delay-ms: Repeated scan period in ms
+- linux,keymap: the key-code to be reported when the key is pressed
+  and released, see also
+  Documentation/devicetree/bindings/input/matrix-keymap.txt
+
+Example:
+
+	key@40050000 {
+		compatible = "nxp,lpc3220-key";
+		reg = <0x40050000 0x1000>;
+		interrupts = <54 0>;
+		keypad,num-rows = <1>;
+		keypad,num-columns = <1>;
+		nxp,debounce-delay-ms = <3>;
+		nxp,scan-delay-ms = <34>;
+		linux,keymap = <0x00000002>;
+	};
--- linux-2.6.orig/drivers/input/keyboard/Kconfig
+++ linux-2.6/drivers/input/keyboard/Kconfig
@@ -332,6 +332,16 @@ config KEYBOARD_LOCOMO
 	  To compile this driver as a module, choose M here: the
 	  module will be called locomokbd.
 
+config KEYBOARD_LPC32XX
+	tristate "LPC32XX matrix key scanner support"
+	depends on ARCH_LPC32XX && OF
+	help
+	  Say Y here if you want to use NXP LPC32XX SoC key scanner interface,
+	  connected to a key matrix.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called lpc32xx-keys.
+
 config KEYBOARD_MAPLE
 	tristate "Maple bus keyboard"
 	depends on SH_DREAMCAST && MAPLE
--- linux-2.6.orig/drivers/input/keyboard/Makefile
+++ linux-2.6/drivers/input/keyboard/Makefile
@@ -26,6 +26,7 @@ obj-$(CONFIG_KEYBOARD_LKKBD)		+= lkkbd.o
 obj-$(CONFIG_KEYBOARD_LM8323)		+= lm8323.o
 obj-$(CONFIG_KEYBOARD_LM8333)		+= lm8333.o
 obj-$(CONFIG_KEYBOARD_LOCOMO)		+= locomokbd.o
+obj-$(CONFIG_KEYBOARD_LPC32XX)		+= lpc32xx-keys.o
 obj-$(CONFIG_KEYBOARD_MAPLE)		+= maple_keyb.o
 obj-$(CONFIG_KEYBOARD_MATRIX)		+= matrix_keypad.o
 obj-$(CONFIG_KEYBOARD_MAX7359)		+= max7359_keypad.o
--- /dev/null
+++ linux-2.6/drivers/input/keyboard/lpc32xx-keys.c
@@ -0,0 +1,379 @@
+/*
+ * NXP LPC32xx SoC Key Scan Interface
+ *
+ * Authors:
+ *    Kevin Wells <kevin.wells@nxp.com>
+ *    Roland Stigge <stigge@antcom.de>
+ *
+ * Copyright (C) 2010 NXP Semiconductors
+ * Copyright (C) 2012 Roland Stigge
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ *
+ * This controller supports square key matrices from 1x1 up to 8x8
+ */
+
+#include <linux/module.h>
+#include <linux/interrupt.h>
+#include <linux/slab.h>
+#include <linux/irq.h>
+#include <linux/pm.h>
+#include <linux/platform_device.h>
+#include <linux/input.h>
+#include <linux/clk.h>
+#include <linux/io.h>
+#include <linux/of.h>
+#include <linux/input/matrix_keypad.h>
+
+#define DRV_NAME				"lpc32xx_keys"
+
+/*
+ * Key scanner register offsets
+ */
+#define LPC32XX_KS_DEB(x)			((x) + 0x00)
+#define LPC32XX_KS_STATE_COND(x)		((x) + 0x04)
+#define LPC32XX_KS_IRQ(x)			((x) + 0x08)
+#define LPC32XX_KS_SCAN_CTL(x)			((x) + 0x0C)
+#define LPC32XX_KS_FAST_TST(x)			((x) + 0x10)
+#define LPC32XX_KS_MATRIX_DIM(x)		((x) + 0x14) /* 1..8 */
+#define LPC32XX_KS_DATA(x, y)			((x) + 0x40 + ((y) << 2))
+
+#define LPC32XX_KSCAN_DEB_NUM_DEB_PASS(n)	((n) & 0xFF)
+
+#define LPC32XX_KSCAN_SCOND_IN_IDLE		0x0
+#define LPC32XX_KSCAN_SCOND_IN_SCANONCE		0x1
+#define LPC32XX_KSCAN_SCOND_IN_IRQGEN		0x2
+#define LPC32XX_KSCAN_SCOND_IN_SCAN_MATRIX	0x3
+
+#define LPC32XX_KSCAN_IRQ_PENDING_CLR		0x1
+
+#define LPC32XX_KSCAN_SCTRL_SCAN_DELAY(n)	((n) & 0xFF)
+
+#define LPC32XX_KSCAN_FTST_FORCESCANONCE	0x1
+#define LPC32XX_KSCAN_FTST_USE32K_CLK		0x2
+
+#define LPC32XX_KSCAN_MSEL_SELECT(n)		((n) & 0xF)
+
+struct lpc32xx_kscan_drv {
+	struct input_dev *input;
+	struct clk *clk;
+	void __iomem *kscan_base;
+	u8 lastkeystates[8];
+	u32 io_p_start;
+	u32 io_p_size;
+	u32 matrix_sz;		/* Size of matrix in XxY, ie. 3 = 3x3 */
+	unsigned short *keymap;	/* Pointer to key map for the scan matrix */
+	u32 deb_clks;		/* Debounce clocks (based on 32KHz clock) */
+	u32 scan_delay;		/* Scan delay (based on 32KHz clock) */
+	int row_shift;
+};
+
+static void lpc32xx_mod_states(struct lpc32xx_kscan_drv *kscandat, int col)
+{
+	u8 key;
+	int row;
+	unsigned changed, scancode, keycode;
+
+	key = readl(LPC32XX_KS_DATA(kscandat->kscan_base, col));
+	changed = key ^ kscandat->lastkeystates[col];
+	if (changed) {
+		for (row = 0; row < kscandat->matrix_sz; row++) {
+			if (changed & (1 << row)) {
+				/* Key state changed, signal an event */
+				scancode = MATRIX_SCAN_CODE(
+					row, col, kscandat->row_shift);
+				keycode = kscandat->keymap[scancode];
+				input_event(kscandat->input, EV_MSC, MSC_SCAN,
+					    scancode);
+				input_report_key(kscandat->input, keycode,
+						 key & (1 << row));
+			}
+		}
+
+		kscandat->lastkeystates[col] = key;
+	}
+}
+
+static irqreturn_t lpc32xx_kscan_irq(int irq, void *dev_id)
+{
+	int i;
+	struct lpc32xx_kscan_drv *kscandat = dev_id;
+
+	for (i = 0; i < kscandat->matrix_sz; i++)
+		lpc32xx_mod_states(kscandat, i);
+
+	writel(1, LPC32XX_KS_IRQ(kscandat->kscan_base));
+
+	input_sync(kscandat->input);
+
+	return IRQ_HANDLED;
+}
+
+static int lpc32xx_kscan_open(struct input_dev *dev)
+{
+	struct lpc32xx_kscan_drv *kscandat = input_get_drvdata(dev);
+
+	writel(1, LPC32XX_KS_IRQ(kscandat->kscan_base));
+	return clk_prepare_enable(kscandat->clk);
+}
+
+static void lpc32xx_kscan_close(struct input_dev *dev)
+{
+	struct lpc32xx_kscan_drv *kscandat = input_get_drvdata(dev);
+
+	writel(1, LPC32XX_KS_IRQ(kscandat->kscan_base));
+	clk_disable_unprepare(kscandat->clk);
+}
+
+static int lpc32xx_parse_dt(struct lpc32xx_kscan_drv *kscandat)
+{
+	struct device *dev = &kscandat->input->dev;
+	struct device_node *np = dev->parent->of_node;
+	u32 rows, columns;
+
+	of_property_read_u32(np, "keypad,num-rows", &rows);
+	of_property_read_u32(np, "keypad,num-columns", &columns);
+	if (!rows || rows != columns) {
+		dev_err(dev,
+			"rows and columns must be specified and be equal!\n");
+		return -EINVAL;
+	}
+
+	kscandat->matrix_sz = rows;
+	kscandat->row_shift = get_count_order(columns);
+
+	of_property_read_u32(np, "nxp,debounce-delay-ms", &kscandat->deb_clks);
+	of_property_read_u32(np, "nxp,scan-delay-ms", &kscandat->scan_delay);
+	if (!kscandat->deb_clks || !kscandat->scan_delay) {
+		dev_err(dev, "debounce or scan delay not specified\n");
+		return -ENXIO;
+	}
+
+	return 0;
+}
+
+static int __devinit lpc32xx_kscan_probe(struct platform_device *pdev)
+{
+	struct lpc32xx_kscan_drv *kscandat;
+	struct resource *res;
+	int error;
+	int irq;
+
+	kscandat = kzalloc(sizeof(struct lpc32xx_kscan_drv), GFP_KERNEL);
+	if (!kscandat) {
+		dev_err(&pdev->dev, "failed to allocate memory\n");
+		return -ENOMEM;
+	}
+
+	kscandat->input = input_allocate_device();
+	if (kscandat->input == NULL) {
+		dev_err(&pdev->dev, "failed to allocate device\n");
+		error = -ENOMEM;
+		goto out1;
+	}
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res) {
+		dev_err(&pdev->dev, "failed to get platform I/O memory\n");
+		error = -EBUSY;
+		goto out2;
+	}
+
+	res = request_mem_region(res->start, resource_size(res), pdev->name);
+	if (!res) {
+		dev_err(&pdev->dev, "failed to request I/O memory\n");
+		error = -EBUSY;
+		goto out2;
+	}
+	kscandat->io_p_start = res->start;
+	kscandat->io_p_size = resource_size(res);
+
+	kscandat->kscan_base = ioremap(res->start, resource_size(res));
+	if (!kscandat->kscan_base) {
+		dev_err(&pdev->dev, "failed to remap I/O memory\n");
+		error = -EBUSY;
+		goto out3;
+	}
+
+	/* Get the key scanner clock */
+	kscandat->clk = clk_get(&pdev->dev, NULL);
+	if (IS_ERR(kscandat->clk)) {
+		dev_err(&pdev->dev, "failed to get clock\n");
+		error = PTR_ERR(kscandat->clk);
+		goto out4;
+	}
+
+	irq = platform_get_irq(pdev, 0);
+	if ((irq < 0) || (irq >= NR_IRQS)) {
+		dev_err(&pdev->dev, "failed to get platform irq\n");
+		error = -EINVAL;
+		goto out5;
+	}
+	error = request_irq(irq, lpc32xx_kscan_irq, 0, pdev->name, kscandat);
+	if (error) {
+		dev_err(&pdev->dev, "failed to request irq\n");
+		goto out5;
+	}
+
+	platform_set_drvdata(pdev, kscandat);
+
+	/* Setup key input */
+	kscandat->input->evbit[0]	= BIT_MASK(EV_KEY);
+	kscandat->input->name		= pdev->name;
+	kscandat->input->phys		= "matrix-keys/input0";
+	kscandat->input->id.vendor	= 0x0001;
+	kscandat->input->id.product	= 0x0001;
+	kscandat->input->id.version	= 0x0100;
+	kscandat->input->open		= lpc32xx_kscan_open;
+	kscandat->input->close		= lpc32xx_kscan_close;
+	kscandat->input->dev.parent	= &pdev->dev;
+
+	error = lpc32xx_parse_dt(kscandat);
+	if (error) {
+		dev_err(&pdev->dev, "failed to parse device tree\n");
+		goto out6;
+	}
+
+	kscandat->keymap = kzalloc(sizeof(kscandat->keymap[0]) *
+				   (kscandat->matrix_sz << kscandat->row_shift),
+				   GFP_KERNEL);
+	if (!kscandat->keymap) {
+		dev_err(&pdev->dev, "could not allocate memory for keymap\n");
+		error = -ENOMEM;
+		goto out6;
+	}
+
+	error = matrix_keypad_build_keymap(NULL, NULL, kscandat->matrix_sz,
+					   kscandat->matrix_sz,
+					   kscandat->keymap, kscandat->input);
+	if (error) {
+		dev_err(&pdev->dev, "failed to build keymap\n");
+		goto out7;
+	}
+
+	input_set_drvdata(kscandat->input, kscandat);
+	input_set_capability(kscandat->input, EV_MSC, MSC_SCAN);
+
+	/* Configure the key scanner */
+	clk_prepare_enable(kscandat->clk);
+	writel(kscandat->deb_clks, LPC32XX_KS_DEB(kscandat->kscan_base));
+	writel(kscandat->scan_delay, LPC32XX_KS_SCAN_CTL(kscandat->kscan_base));
+	writel(LPC32XX_KSCAN_FTST_USE32K_CLK,
+	       LPC32XX_KS_FAST_TST(kscandat->kscan_base));
+	writel(kscandat->matrix_sz,
+	       LPC32XX_KS_MATRIX_DIM(kscandat->kscan_base));
+	writel(1, LPC32XX_KS_IRQ(kscandat->kscan_base));
+	clk_disable_unprepare(kscandat->clk);
+
+	error = input_register_device(kscandat->input);
+	if (error) {
+		dev_err(&pdev->dev, "failed to register input device\n");
+		goto out7;
+	}
+
+	return 0;
+
+out7:
+	kfree(kscandat->keymap);
+out6:
+	free_irq(irq, pdev);
+out5:
+	clk_put(kscandat->clk);
+out4:
+	iounmap(kscandat->kscan_base);
+out3:
+	release_mem_region(kscandat->io_p_start, kscandat->io_p_size);
+out2:
+	input_free_device(kscandat->input);
+out1:
+	kfree(kscandat);
+
+	return error;
+}
+
+static int __devexit lpc32xx_kscan_remove(struct platform_device *pdev)
+{
+	struct lpc32xx_kscan_drv *kscandat = platform_get_drvdata(pdev);
+
+	kfree(kscandat->keymap);
+	free_irq(platform_get_irq(pdev, 0), pdev);
+	clk_put(kscandat->clk);
+	iounmap(kscandat->kscan_base);
+	release_mem_region(kscandat->io_p_start, kscandat->io_p_size);
+	input_unregister_device(kscandat->input);
+	kfree(kscandat);
+
+	return 0;
+}
+
+#ifdef CONFIG_PM_SLEEP
+static int lpc32xx_kscan_suspend(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct lpc32xx_kscan_drv *kscandat = platform_get_drvdata(pdev);
+
+	mutex_lock(&kscandat->input->mutex);
+
+	if (kscandat->input->users) {
+		/* Clear IRQ and disable clock */
+		writel(1, LPC32XX_KS_IRQ(kscandat->kscan_base));
+		clk_disable_unprepare(kscandat->clk);
+	}
+
+	mutex_unlock(&kscandat->input->mutex);
+	return 0;
+}
+
+static int lpc32xx_kscan_resume(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct lpc32xx_kscan_drv *kscandat = platform_get_drvdata(pdev);
+
+	mutex_lock(&kscandat->input->mutex);
+
+	if (kscandat->input->users) {
+		/* Enable clock and clear IRQ */
+		clk_prepare_enable(kscandat->clk);
+		writel(1, LPC32XX_KS_IRQ(kscandat->kscan_base));
+	}
+
+	mutex_unlock(&kscandat->input->mutex);
+	return 0;
+}
+#endif
+
+static SIMPLE_DEV_PM_OPS(lpc32xx_kscan_pm_ops, lpc32xx_kscan_suspend,
+			 lpc32xx_kscan_resume);
+
+static const struct of_device_id lpc32xx_kscan_match[] = {
+	{ .compatible = "nxp,lpc3220-key" },
+	{},
+};
+MODULE_DEVICE_TABLE(of, lpc32xx_kscan_match);
+
+static struct platform_driver lpc32xx_kscan_driver = {
+	.probe		= lpc32xx_kscan_probe,
+	.remove		= __devexit_p(lpc32xx_kscan_remove),
+	.driver		= {
+		.name	= DRV_NAME,
+		.owner	= THIS_MODULE,
+		.pm	= &lpc32xx_kscan_pm_ops,
+		.of_match_table = of_match_ptr(lpc32xx_kscan_match),
+	}
+};
+
+module_platform_driver(lpc32xx_kscan_driver);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Kevin Wells <kevin.wells@nxp.com>");
+MODULE_AUTHOR("Roland Stigge <stigge@antcom.de>");
+MODULE_DESCRIPTION("Key scanner driver for LPC32XX devices");
