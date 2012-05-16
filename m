Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965969Ab2EPU06 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 16:26:58 -0400
Received: from mail.work-microwave.de ([62.245.205.51]:40052 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760629Ab2EPU0n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 16:26:43 -0400
From: Roland Stigge <stigge@antcom.de>
To: dmitry.torokhov@gmail.com, axel.lin@gmail.com, riyer@nvidia.com,
        michael.hennerich@analog.com, grant.likely@secretlab.ca,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kevin.wells@nxp.com,
        srinivas.bakki@nxp.com, devicetree-discuss@lists.ozlabs.org,
        rob.herring@calxeda.com
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH RESEND v3 1/2] input: keyboard: Add keys driver for the LPC32xx SoC
Date: Wed, 16 May 2012 22:25:54 +0200
Message-Id: <1337199955-26441-1-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.9
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a driver for the key scan interface of the LPC32xx SoC

Signed-off-by: Roland Stigge <stigge@antcom.de>

---
Applies to v3.4-rc7

Please pick this patch for the input subsystem.

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

Thanks to Axel Lin and Russell King for reviewing!

 Documentation/devicetree/bindings/input/lpc32xx-key.txt |   28 +
 drivers/input/keyboard/Kconfig                          |   10 
 drivers/input/keyboard/Makefile                         |    1 
 drivers/input/keyboard/lpc32xx-keys.c                   |  382 ++++++++++++++++
 4 files changed, 421 insertions(+)

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
@@ -318,6 +318,16 @@ config KEYBOARD_LOCOMO
 	  To compile this driver as a module, choose M here: the
 	  module will be called locomokbd.
 
+config KEYBOARD_LPC32XX
+	tristate "LPC32XX matrix key scanner support"
+	depends on ARCH_LPC32XX
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
@@ -25,6 +25,7 @@ obj-$(CONFIG_KEYBOARD_HP7XX)		+= jornada
 obj-$(CONFIG_KEYBOARD_LKKBD)		+= lkkbd.o
 obj-$(CONFIG_KEYBOARD_LM8323)		+= lm8323.o
 obj-$(CONFIG_KEYBOARD_LOCOMO)		+= locomokbd.o
+obj-$(CONFIG_KEYBOARD_LPC32XX)		+= lpc32xx-keys.o
 obj-$(CONFIG_KEYBOARD_MAPLE)		+= maple_keyb.o
 obj-$(CONFIG_KEYBOARD_MATRIX)		+= matrix_keypad.o
 obj-$(CONFIG_KEYBOARD_MAX7359)		+= max7359_keypad.o
--- /dev/null
+++ linux-2.6/drivers/input/keyboard/lpc32xx-keys.c
@@ -0,0 +1,382 @@
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
+
+/*
+ * Key scanner register offsets
+ */
+#define LPC32XX_KS_DEB(x)			((x) + 0x00)
+#define LPC32XX_KS_STATE_COND(x)		((x) + 0x04)
+#define LPC32XX_KS_IRQ(x)			((x) + 0x08)
+#define LPC32XX_KS_SCAN_CTL(x)			((x) + 0x0C)
+#define LPC32XX_KS_FAST_TST(x)			((x) + 0x10)
+#define LPC32XX_KS_MATRIX_DIM(x)		((x) + 0x14)
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
+/*
+ * Key scanner platform configuration structure
+ */
+struct lpc32xx_kscan_cfg {
+	u32	matrix_sz;	/* Size of matrix in XxY, ie. 3 = 3x3 */
+	int	*keymap;	/* Pointer to key map for the scan matrix */
+	u32	deb_clks;	/* Debounce clocks (based on 32KHz clock) */
+	u32	scan_delay;	/* Scan delay (based on 32KHz clock) */
+};
+
+struct lpc32xx_kscan_drv {
+	struct input_dev *input;
+	struct lpc32xx_kscan_cfg *kscancfg;
+	struct clk *clk;
+	void __iomem *kscan_base;
+	int irq;
+	u8 lastkeystates[8];
+};
+
+static void lpc32xx_mod_states(struct lpc32xx_kscan_drv *kscandat, int off)
+{
+	u8 key;
+	int j;
+	unsigned changed, scancode, keycode;
+
+	key = readl(LPC32XX_KS_DATA(kscandat->kscan_base, off));
+	changed = key ^ kscandat->lastkeystates[off];
+	if (changed) {
+		for (j = 0; j < kscandat->kscancfg->matrix_sz; j++) {
+			if (changed & (1 << j)) {
+				/* Key state changed, signal an event */
+				scancode =
+				    (j * kscandat->kscancfg->matrix_sz) + off;
+				keycode = kscandat->kscancfg->keymap[scancode];
+				input_report_key(kscandat->input, keycode,
+						 key & (1 << j));
+			}
+		}
+
+		kscandat->lastkeystates[off] = key;
+	}
+}
+
+static irqreturn_t lpc32xx_kscan_irq(int irq, void *dev_id)
+{
+	int i;
+	struct lpc32xx_kscan_drv *kscandat = dev_id;
+
+	for (i = 0; i < kscandat->kscancfg->matrix_sz; i++)
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
+	return clk_prepare_enable(kscandat->clk);
+}
+
+static void lpc32xx_kscan_close(struct input_dev *dev)
+{
+	struct lpc32xx_kscan_drv *kscandat = input_get_drvdata(dev);
+
+	clk_disable_unprepare(kscandat->clk);
+}
+
+#ifdef CONFIG_OF
+static struct lpc32xx_kscan_cfg *lpc32xx_parse_dt(struct device *dev)
+{
+	struct lpc32xx_kscan_cfg *pdata;
+	struct device_node *np = dev->of_node;
+	int key_count;
+	int i;
+	u32 rows, columns;
+	const __be32 *prop;
+	int proplen;
+
+	pdata = devm_kzalloc(dev, sizeof(*pdata), GFP_KERNEL);
+	if (!pdata) {
+		dev_err(dev, "could not allocate memory for platform data\n");
+		return NULL;
+	}
+
+	of_property_read_u32(np, "keypad,num-rows", &rows);
+	of_property_read_u32(np, "keypad,num-columns", &columns);
+	if (!rows || rows != columns) {
+		dev_err(dev, "rows and columns must be specified and be equal!\n");
+		return NULL;
+	}
+
+	pdata->matrix_sz = rows;
+	key_count = rows * columns;
+
+	of_property_read_u32(np, "nxp,debounce-delay-ms", &pdata->deb_clks);
+	of_property_read_u32(np, "nxp,scan-delay-ms", &pdata->scan_delay);
+	if (!pdata->deb_clks || !pdata->scan_delay) {
+		dev_err(dev, "debounce or scan delay not specified\n");
+		return NULL;
+	}
+
+	pdata->keymap = devm_kzalloc(dev, sizeof(int) * key_count, GFP_KERNEL);
+	if (!pdata->keymap) {
+		dev_err(dev, "could not allocate memory for keymap\n");
+		return NULL;
+	}
+
+	prop = of_get_property(np, "linux,keymap", &proplen);
+	if (!prop) {
+		dev_err(dev, "linux,keymap not specified\n");
+		return NULL;
+	}
+
+	if (proplen % sizeof(u32)) {
+		dev_err(dev, "bad linux,keymap property size: %d\n", proplen);
+		return NULL;
+	}
+	proplen /= sizeof(u32);
+
+	for (i = 0; i < proplen; i++) {
+		u32 tmp = be32_to_cpup(prop + i);
+		u32 row, column, key_code;
+
+		row = (tmp >> 24) & 0xff;
+		column = (tmp >> 16) & 0xff;
+		key_code = tmp & 0xffff;
+		pdata->keymap[row * columns + column] = key_code;
+	}
+
+	return pdata;
+}
+#else
+static struct lpc32xx_kscan_cfg *lpc32xx_parse_dt(struct device *dev)
+{
+	return NULL;
+}
+#endif
+
+static int __devinit lpc32xx_kscan_probe(struct platform_device *pdev)
+{
+	struct lpc32xx_kscan_drv *kscandat;
+	struct resource *res;
+	int retval, i, keynum;
+
+	kscandat = kzalloc(sizeof(struct lpc32xx_kscan_drv), GFP_KERNEL);
+	if (!kscandat) {
+		dev_err(&pdev->dev, "failed to allocate memory\n");
+		return -ENOMEM;
+	}
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res) {
+		dev_err(&pdev->dev, "failed to get platform I/O memory\n");
+		retval = -EBUSY;
+		goto out1;
+	}
+
+	kscandat->kscan_base = devm_request_and_ioremap(&pdev->dev, res);
+	if (kscandat->kscan_base == NULL) {
+		dev_err(&pdev->dev, "failed to request and remap I/O memory\n");
+		retval = -EBUSY;
+		goto out1;
+	}
+
+	/* Get the key scanner clock */
+	kscandat->clk = clk_get(&pdev->dev, NULL);
+	if (IS_ERR(kscandat->clk)) {
+		dev_err(&pdev->dev, "failed to get clock\n");
+		retval = -ENODEV;
+		goto out1;
+	}
+
+	kscandat->irq = platform_get_irq(pdev, 0);
+	if ((kscandat->irq < 0) || (kscandat->irq >= NR_IRQS)) {
+		dev_err(&pdev->dev, "failed to get platform irq\n");
+		retval = -EINVAL;
+		goto out2;
+	}
+	retval = request_irq(kscandat->irq, lpc32xx_kscan_irq,
+			     0, pdev->name, kscandat);
+	if (retval) {
+		dev_err(&pdev->dev, "failed to request irq\n");
+		goto out2;
+	}
+
+	kscandat->input = input_allocate_device();
+	if (kscandat->input == NULL) {
+		dev_err(&pdev->dev, "failed to allocate device\n");
+		retval = -ENOMEM;
+		goto out3;
+	}
+
+	if (pdev->dev.of_node)
+		kscandat->kscancfg = lpc32xx_parse_dt(&pdev->dev);
+	else
+		kscandat->kscancfg = pdev->dev.platform_data;
+	if (!kscandat->kscancfg) {
+		dev_err(&pdev->dev, "failed to get platform data\n");
+		retval = -EINVAL;
+		goto out4;
+	}
+
+	platform_set_drvdata(pdev, kscandat);
+
+	/* Setup key input */
+	kscandat->input->evbit[0]	= BIT_MASK(EV_KEY);
+	kscandat->input->name		= pdev->name;
+	kscandat->input->phys		= "matrix-keys/input0";
+	kscandat->input->dev.parent	=  &pdev->dev;
+	kscandat->input->id.vendor	= 0x0001;
+	kscandat->input->id.product	= 0x0001;
+	kscandat->input->id.version	= 0x0100;
+	kscandat->input->open		= &lpc32xx_kscan_open;
+	kscandat->input->close		= &lpc32xx_kscan_close;
+	keynum = kscandat->kscancfg->matrix_sz * kscandat->kscancfg->matrix_sz;
+	for (i = 0; i < keynum; i++)
+		__set_bit(kscandat->kscancfg->keymap[i],
+			kscandat->input->keybit);
+
+	input_set_drvdata(kscandat->input, kscandat);
+	input_set_capability(kscandat->input, EV_MSC, MSC_SCAN);
+
+	retval = input_register_device(kscandat->input);
+	if (retval) {
+		dev_err(&pdev->dev, "failed to register input device\n");
+		goto out4;
+	}
+
+	/* Configure the key scanner */
+	writel(kscandat->kscancfg->deb_clks,
+		LPC32XX_KS_DEB(kscandat->kscan_base));
+	writel(kscandat->kscancfg->scan_delay,
+		LPC32XX_KS_SCAN_CTL(kscandat->kscan_base));
+	writel(LPC32XX_KSCAN_FTST_USE32K_CLK,
+		LPC32XX_KS_FAST_TST(kscandat->kscan_base));
+	writel(kscandat->kscancfg->matrix_sz,
+		LPC32XX_KS_MATRIX_DIM(kscandat->kscan_base));
+	writel(1, LPC32XX_KS_IRQ(kscandat->kscan_base));
+
+	return 0;
+
+out4:
+	input_free_device(kscandat->input);
+out3:
+	free_irq(kscandat->irq, pdev);
+out2:
+	clk_put(kscandat->clk);
+out1:
+	kfree(kscandat);
+
+	return retval;
+}
+
+static int __devexit lpc32xx_kscan_remove(struct platform_device *pdev)
+{
+	struct lpc32xx_kscan_drv *kscandat = platform_get_drvdata(pdev);
+
+	free_irq(kscandat->irq, pdev);
+	input_unregister_device(kscandat->input);
+	clk_put(kscandat->clk);
+	kfree(kscandat);
+
+	return 0;
+}
+
+#ifdef CONFIG_PM
+static int lpc32xx_kscan_suspend(struct platform_device *pdev,
+	pm_message_t state)
+{
+	struct lpc32xx_kscan_drv *kscandat = platform_get_drvdata(pdev);
+
+	/* Clear IRQ and disable clock */
+	writel(1, LPC32XX_KS_IRQ(kscandat->kscan_base));
+	clk_disable_unprepare(kscandat->clk);
+
+	return 0;
+}
+
+static int lpc32xx_kscan_resume(struct platform_device *pdev)
+{
+	struct lpc32xx_kscan_drv *kscandat = platform_get_drvdata(pdev);
+
+	/* Enable clock and clear IRQ */
+	clk_prepare_enable(kscandat->clk);
+	writel(1, LPC32XX_KS_IRQ(kscandat->kscan_base));
+
+	return 0;
+}
+#else
+#define lpc32xx_kscan_suspend	NULL
+#define lpc32xx_kscan_resume	NULL
+#endif
+
+#ifdef CONFIG_OF
+static const struct of_device_id lpc32xx_kscan_match[] = {
+	{ .compatible = "nxp,lpc3220-key" },
+	{},
+};
+MODULE_DEVICE_TABLE(of, lpc32xx_kscan_match);
+#endif
+
+static struct platform_driver lpc32xx_kscan_driver = {
+	.probe		= lpc32xx_kscan_probe,
+	.remove		= __devexit_p(lpc32xx_kscan_remove),
+	.suspend	= lpc32xx_kscan_suspend,
+	.resume		= lpc32xx_kscan_resume,
+	.driver		= {
+		.name	= "lpc32xx_keys",
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
