Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758690Ab1EBTRJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 15:17:09 -0400
Received: from eu1sys200aog101.obsmtp.com ([207.126.144.111]:55342 "EHLO
	eu1sys200aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755591Ab1EBTQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 15:16:49 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Cc: Grant Likely <grant.likely@secretlab.ca>, Lee Jones <lee.jones@linaro.org>,
        Martin Persson <martin.persson@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 2/4] pinmux: add a driver for the U300 pinmux
Date: Mon, 2 May 2011 21:16:38 +0200
Message-ID: <1304363798-30409-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

This adds a driver for the U300 pinmux portions of the system
controller "SYSCON". It also serves as an example of how to use
the pinmux subsystem.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/pinmux/Kconfig       |    6 +
 drivers/pinmux/Makefile      |    1 +
 drivers/pinmux/pinmux-u300.c |  361 ++++++++++++++++++++++++++++++++++++++++++
 drivers/pinmux/pinmux-u300.h |  141 ++++++++++++++++
 4 files changed, 509 insertions(+), 0 deletions(-)
 create mode 100644 drivers/pinmux/pinmux-u300.c
 create mode 100644 drivers/pinmux/pinmux-u300.h

diff --git a/drivers/pinmux/Kconfig b/drivers/pinmux/Kconfig
index 3073ccc..66cdedd 100644
--- a/drivers/pinmux/Kconfig
+++ b/drivers/pinmux/Kconfig
@@ -23,4 +23,10 @@ config DEBUG_PINMUX
 	help
 	  Say Y here to add some extra checks and diagnostics to PINMUX calls.
 
+config PINMUX_U300
+	bool "U300 pinmux driver"
+	depends on ARCH_U300
+	help
+	  Say Y here to enable the U300 pinmux driver
+
 endif
diff --git a/drivers/pinmux/Makefile b/drivers/pinmux/Makefile
index c0ea542..9c346f6 100644
--- a/drivers/pinmux/Makefile
+++ b/drivers/pinmux/Makefile
@@ -3,3 +3,4 @@
 ccflags-$(CONFIG_DEBUG_PINMUX)	+= -DDEBUG
 
 obj-$(CONFIG_PINMUX)		+= core.o
+obj-$(CONFIG_PINMUX_U300)	+= pinmux-u300.o
diff --git a/drivers/pinmux/pinmux-u300.c b/drivers/pinmux/pinmux-u300.c
new file mode 100644
index 0000000..2607ca3
--- /dev/null
+++ b/drivers/pinmux/pinmux-u300.c
@@ -0,0 +1,361 @@
+/*
+ * Driver for the U300 pinmux
+ *
+ * Based on the original U300 padmux functions
+ * Copyright (C) 2009 ST-Ericsson AB
+ * Author: Martin Persson <martin.persson@stericsson.com>
+ *
+ * The DB3350 design and control registers are oriented around pads rather than
+ * pins, so we enumerate the pads we can mux rather than actual pins. The pads
+ * are connected to different pins in different packaging types, so it would
+ * be confusing.
+ */
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/io.h>
+#include <linux/slab.h>
+#include <linux/err.h>
+#include <linux/pinmux.h>
+
+#include "pinmux-u300.h"
+
+#define DRIVER_NAME "pinmux-u300"
+
+/*
+ * The DB3350 has 467 pads, I have enumerated the pads clockwise around the
+ * edges of the silicon, finger by finger. LTCORNER upper left is pad 0.
+ * Data taken from the PadRing chart, arranged like this:
+ *
+ *   0 ..... 104
+ * 466        105
+ *   .        .
+ *   .        .
+ * 358        224
+ *  357 .... 225
+ */
+#define U300_NUM_PADS 467
+
+struct u300_pin_desc {
+	unsigned number;
+	char *name;
+};
+
+#define U300_PIN(a, b) { .number = a, .name = b }
+
+const struct u300_pin_desc u300_pins[] = {
+	U300_PIN(134, "UART0 RTS"),
+	U300_PIN(135, "UART0 CTS"),
+	U300_PIN(136, "UART0 TX"),
+	U300_PIN(137, "UART0 RX"),
+	U300_PIN(166, "MMC DATA DIR LS"),
+	U300_PIN(167, "MMC DATA 3"),
+	U300_PIN(168, "MMC DATA 2"),
+	U300_PIN(169, "MMC DATA 1"),
+	U300_PIN(170, "MMC DATA 0"),
+	U300_PIN(171, "MMC CMD DIR LS"),
+	U300_PIN(176, "MMC CMD"),
+	U300_PIN(177, "MMC CLK"),
+	U300_PIN(420, "SPI CLK"),
+	U300_PIN(421, "SPI DO"),
+	U300_PIN(422, "SPI DI"),
+	U300_PIN(423, "SPI CS0"),
+	U300_PIN(424, "SPI CS1"),
+	U300_PIN(425, "SPI CS2"),
+};
+
+/**
+ * @dev: a pointer back to containing device
+ * @virtbase: the offset to the controller in virtual memory
+ */
+struct u300_pmx {
+	struct device *dev;
+	struct pinmux_dev *pmx;
+	u32 phybase;
+	u32 physize;
+	void __iomem *virtbase;
+};
+
+/**
+ * u300_pmx_registers - the array of registers read/written for each pinmux
+ * shunt setting
+ */
+const u32 u300_pmx_registers[] = {
+	U300_SYSCON_PMC1LR,
+	U300_SYSCON_PMC1HR,
+	U300_SYSCON_PMC2R,
+	U300_SYSCON_PMC3R,
+	U300_SYSCON_PMC4R,
+};
+
+/**
+ * struct pmx_onmask - mask bits to enable/disable padmux
+ * @mask: mask bits to disable
+ * @val: mask bits to enable
+ *
+ * onmask lazy dog:
+ * onmask = {
+ *   {"PMC1LR" mask, "PMC1LR" value},
+ *   {"PMC1HR" mask, "PMC1HR" value},
+ *   {"PMC2R"  mask, "PMC2R"  value},
+ *   {"PMC3R"  mask, "PMC3R"  value},
+ *   {"PMC4R"  mask, "PMC4R"  value}
+ * }
+ */
+struct u300_pmx_mask {
+	u16 mask;
+	u16 bits;
+};
+
+/**
+ * struct u300_pmx_func - describes an U300 pinmux function
+ * @name: the name of this specific function
+ * @pins: an array of discrete physical pins used in this mapping, taken
+ *	from the global pin enumeration space
+ * @num_pins: the number of pins in this mapping array, i.e. the number of
+ *	elements in .pins so we can iterate over that array
+ * @onmask: bits to set to enable this muxing
+ */
+struct u300_pmx_func {
+	char *name;
+	const unsigned int *pins;
+	const unsigned num_pins;
+	const struct u300_pmx_mask *mask;
+};
+
+static const unsigned mmc0_pins[] = { 166, 167, 168, 169, 170, 171, 176, 177 };
+static const unsigned spi0_pins[] = { 420, 421, 422, 423, 424, 425 };
+
+static const struct u300_pmx_mask mmc0_mask[] = {
+	{U300_SYSCON_PMC1LR_MMCSD_MASK,
+	 U300_SYSCON_PMC1LR_MMCSD_MMCSD},
+	{0, 0},
+	{0, 0},
+	{0, 0},
+	{U300_SYSCON_PMC4R_APP_MISC_12_MASK,
+	 U300_SYSCON_PMC4R_APP_MISC_12_APP_GPIO}
+};
+
+static const struct u300_pmx_mask spi0_mask[] = {
+	{0, 0},
+	{U300_SYSCON_PMC1HR_APP_SPI_2_MASK |
+	 U300_SYSCON_PMC1HR_APP_SPI_CS_1_MASK |
+	 U300_SYSCON_PMC1HR_APP_SPI_CS_2_MASK,
+	 U300_SYSCON_PMC1HR_APP_SPI_2_SPI |
+	 U300_SYSCON_PMC1HR_APP_SPI_CS_1_SPI |
+	 U300_SYSCON_PMC1HR_APP_SPI_CS_2_SPI},
+	{0, 0},
+	{0, 0},
+	{0, 0}
+};
+
+static const struct u300_pmx_func u300_pmx_funcs[] = {
+	{
+		.name = "mmc0",
+		.pins = mmc0_pins,
+		.num_pins = ARRAY_SIZE(mmc0_pins),
+		.mask = mmc0_mask,
+	},
+	{
+		.name = "spi0",
+		.pins = spi0_pins,
+		.num_pins = ARRAY_SIZE(spi0_pins),
+		.mask = spi0_mask,
+	},
+};
+
+static void u300_pmx_endisable(struct u300_pmx *upmx, unsigned selector,
+			       bool enable)
+{
+	u16 regval, val, mask;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(u300_pmx_registers); i++) {
+		if (enable)
+			val = u300_pmx_funcs[selector].mask->bits;
+		else
+			val = 0;
+
+		mask = u300_pmx_funcs[selector].mask->mask;
+		if (mask != 0) {
+			regval = readw(upmx->virtbase + u300_pmx_registers[i]);
+			regval &= ~mask;
+			regval |= val;
+			writew(regval, upmx->virtbase + u300_pmx_registers[i]);
+		}
+	}
+}
+
+static int u300_pmx_enable(struct pinmux_dev *pmxdev, unsigned selector)
+{
+	struct u300_pmx *upmx;
+
+	if (selector >= ARRAY_SIZE(u300_pmx_funcs))
+		return -EINVAL;
+	upmx = pmxdev_get_drvdata(pmxdev);
+	u300_pmx_endisable(upmx, selector, true);
+
+	return 0;
+}
+
+static void u300_pmx_disable(struct pinmux_dev *pmxdev, unsigned selector)
+{
+	struct u300_pmx *upmx;
+
+	if (selector >= ARRAY_SIZE(u300_pmx_funcs))
+		return;
+	upmx = pmxdev_get_drvdata(pmxdev);
+	u300_pmx_endisable(upmx, selector, false);
+}
+
+static int u300_pmx_list(struct pinmux_dev *pmxdev, unsigned selector)
+{
+	if (selector >= ARRAY_SIZE(u300_pmx_funcs))
+		return -EINVAL;
+	return 0;
+}
+
+static const char *u300_pmx_get_fname(struct pinmux_dev *pmxdev,
+				      unsigned selector)
+{
+	if (selector >= ARRAY_SIZE(u300_pmx_funcs))
+		return NULL;
+	return u300_pmx_funcs[selector].name;
+}
+
+static int u300_pmx_get_pins(struct pinmux_dev *pmxdev, unsigned selector,
+			     unsigned ** const pins, unsigned * const num_pins)
+{
+	if (selector >= ARRAY_SIZE(u300_pmx_funcs))
+		return -EINVAL;
+	*pins = (unsigned *) u300_pmx_funcs[selector].pins;
+	*num_pins = u300_pmx_funcs[selector].num_pins;
+	return 0;
+}
+
+static void u300_dbg_show(struct pinmux_dev *pmxdev, struct seq_file *s,
+		   unsigned offset)
+{
+	int i;
+
+	seq_printf(s, " " DRIVER_NAME);
+	seq_printf(s, " :");
+	for (i = 0; i < ARRAY_SIZE(u300_pins); i++) {
+		if (u300_pins[i].number == offset) {
+			seq_printf(s, " %s", u300_pins[i].name);
+			break;
+		}
+	}
+	if (i == ARRAY_SIZE(u300_pins))
+		seq_printf(s, " (unknown function)");
+}
+
+static struct pinmux_ops u300_pmx_ops = {
+	.list_functions = u300_pmx_list,
+	.get_function_name = u300_pmx_get_fname,
+	.get_function_pins = u300_pmx_get_pins,
+	.enable = u300_pmx_enable,
+	.disable = u300_pmx_disable,
+	.dbg_show = u300_dbg_show,
+};
+
+static struct pinmux_desc u300_pmx_desc = {
+	.name = DRIVER_NAME,
+	.ops = &u300_pmx_ops,
+	.owner = THIS_MODULE,
+	.base = 0,
+	.npins = U300_NUM_PADS,
+};
+
+static int __init u300_pmx_probe(struct platform_device *pdev)
+{
+	int ret;
+	struct u300_pmx *upmx;
+	struct resource *res;
+
+	upmx = kzalloc(sizeof(struct u300_pmx), GFP_KERNEL);
+	if (!upmx)
+		return -ENOMEM;
+
+	upmx->dev = &pdev->dev;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res) {
+		ret = -ENOENT;
+		goto out_no_resource;
+	}
+	upmx->phybase = res->start;
+	upmx->physize = resource_size(res);
+
+	if (request_mem_region(upmx->phybase, upmx->physize,
+			       DRIVER_NAME) == NULL) {
+		ret = -EBUSY;
+		goto out_no_memregion;
+	}
+
+	upmx->virtbase = ioremap(upmx->phybase, upmx->physize);
+	if (!upmx->virtbase) {
+		ret = -ENOMEM;
+		goto out_no_remap;
+	}
+
+	upmx->pmx = pinmux_register(&u300_pmx_desc, &pdev->dev, upmx);
+	if (IS_ERR(upmx->pmx)) {
+		ret = PTR_ERR(upmx->pmx);
+		goto out_no_pmx;
+	}
+	platform_set_drvdata(pdev, upmx);
+
+	dev_info(&pdev->dev, "initialized U300 pinmux driver\n");
+
+	return 0;
+
+out_no_pmx:
+	iounmap(upmx->virtbase);
+out_no_remap:
+	platform_set_drvdata(pdev, NULL);
+out_no_memregion:
+	release_mem_region(upmx->phybase, SZ_4K);
+out_no_resource:
+	kfree(upmx);
+	return ret;
+}
+
+static int __exit u300_pmx_remove(struct platform_device *pdev)
+{
+	struct u300_pmx *upmx = platform_get_drvdata(pdev);
+
+	if (upmx) {
+		pinmux_unregister(upmx->pmx);
+		iounmap(upmx->virtbase);
+		release_mem_region(upmx->phybase, upmx->physize);
+		platform_set_drvdata(pdev, NULL);
+		kfree(upmx);
+	}
+
+	return 0;
+}
+
+static struct platform_driver u300_pmx_driver = {
+	.driver = {
+		.name = DRIVER_NAME,
+		.owner = THIS_MODULE,
+	},
+	.remove = __exit_p(u300_pmx_remove),
+};
+
+static int __init u300_pmx_init(void)
+{
+	return platform_driver_probe(&u300_pmx_driver, u300_pmx_probe);
+}
+arch_initcall(u300_pmx_init);
+
+static void __exit u300_pmx_exit(void)
+{
+	platform_driver_unregister(&u300_pmx_driver);
+}
+module_exit(u300_pmx_exit);
+
+MODULE_AUTHOR("Linus Walleij <linus.walleij@linaro.org>");
+MODULE_DESCRIPTION("U300 Padmux driver");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/pinmux/pinmux-u300.h b/drivers/pinmux/pinmux-u300.h
new file mode 100644
index 0000000..c2ec260
--- /dev/null
+++ b/drivers/pinmux/pinmux-u300.h
@@ -0,0 +1,141 @@
+/*
+ * Register definitions for the U300 Padmux control registers in the
+ * system controller
+ */
+
+/* PAD MUX Control register 1 (LOW) 16bit (R/W) */
+#define U300_SYSCON_PMC1LR					(0x007C)
+#define U300_SYSCON_PMC1LR_MASK					(0xFFFF)
+#define U300_SYSCON_PMC1LR_CDI_MASK				(0xC000)
+#define U300_SYSCON_PMC1LR_CDI_CDI				(0x0000)
+#define U300_SYSCON_PMC1LR_CDI_EMIF				(0x4000)
+/* For BS335 */
+#define U300_SYSCON_PMC1LR_CDI_CDI2				(0x8000)
+#define U300_SYSCON_PMC1LR_CDI_WCDMA_APP_GPIO			(0xC000)
+/* For BS365 */
+#define U300_SYSCON_PMC1LR_CDI_GPIO				(0x8000)
+#define U300_SYSCON_PMC1LR_CDI_WCDMA				(0xC000)
+/* Common defs */
+#define U300_SYSCON_PMC1LR_PDI_MASK				(0x3000)
+#define U300_SYSCON_PMC1LR_PDI_PDI				(0x0000)
+#define U300_SYSCON_PMC1LR_PDI_EGG				(0x1000)
+#define U300_SYSCON_PMC1LR_PDI_WCDMA				(0x3000)
+#define U300_SYSCON_PMC1LR_MMCSD_MASK				(0x0C00)
+#define U300_SYSCON_PMC1LR_MMCSD_MMCSD				(0x0000)
+#define U300_SYSCON_PMC1LR_MMCSD_MSPRO				(0x0400)
+#define U300_SYSCON_PMC1LR_MMCSD_DSP				(0x0800)
+#define U300_SYSCON_PMC1LR_MMCSD_WCDMA				(0x0C00)
+#define U300_SYSCON_PMC1LR_ETM_MASK				(0x0300)
+#define U300_SYSCON_PMC1LR_ETM_ACC				(0x0000)
+#define U300_SYSCON_PMC1LR_ETM_APP				(0x0100)
+#define U300_SYSCON_PMC1LR_EMIF_1_CS2_MASK			(0x00C0)
+#define U300_SYSCON_PMC1LR_EMIF_1_CS2_STATIC			(0x0000)
+#define U300_SYSCON_PMC1LR_EMIF_1_CS2_NFIF			(0x0040)
+#define U300_SYSCON_PMC1LR_EMIF_1_CS2_SDRAM			(0x0080)
+#define U300_SYSCON_PMC1LR_EMIF_1_CS2_STATIC_2GB		(0x00C0)
+#define U300_SYSCON_PMC1LR_EMIF_1_CS1_MASK			(0x0030)
+#define U300_SYSCON_PMC1LR_EMIF_1_CS1_STATIC			(0x0000)
+#define U300_SYSCON_PMC1LR_EMIF_1_CS1_NFIF			(0x0010)
+#define U300_SYSCON_PMC1LR_EMIF_1_CS1_SDRAM			(0x0020)
+#define U300_SYSCON_PMC1LR_EMIF_1_CS1_SEMI			(0x0030)
+#define U300_SYSCON_PMC1LR_EMIF_1_CS0_MASK			(0x000C)
+#define U300_SYSCON_PMC1LR_EMIF_1_CS0_STATIC			(0x0000)
+#define U300_SYSCON_PMC1LR_EMIF_1_CS0_NFIF			(0x0004)
+#define U300_SYSCON_PMC1LR_EMIF_1_CS0_SDRAM			(0x0008)
+#define U300_SYSCON_PMC1LR_EMIF_1_CS0_SEMI			(0x000C)
+#define U300_SYSCON_PMC1LR_EMIF_1_MASK				(0x0003)
+#define U300_SYSCON_PMC1LR_EMIF_1_STATIC			(0x0000)
+#define U300_SYSCON_PMC1LR_EMIF_1_SDRAM0			(0x0001)
+#define U300_SYSCON_PMC1LR_EMIF_1_SDRAM1			(0x0002)
+#define U300_SYSCON_PMC1LR_EMIF_1				(0x0003)
+/* PAD MUX Control register 2 (HIGH) 16bit (R/W) */
+#define U300_SYSCON_PMC1HR					(0x007E)
+#define U300_SYSCON_PMC1HR_MASK					(0xFFFF)
+#define U300_SYSCON_PMC1HR_MISC_2_MASK				(0xC000)
+#define U300_SYSCON_PMC1HR_MISC_2_APP_GPIO			(0x0000)
+#define U300_SYSCON_PMC1HR_MISC_2_MSPRO				(0x4000)
+#define U300_SYSCON_PMC1HR_MISC_2_DSP				(0x8000)
+#define U300_SYSCON_PMC1HR_MISC_2_AAIF				(0xC000)
+#define U300_SYSCON_PMC1HR_APP_GPIO_2_MASK			(0x3000)
+#define U300_SYSCON_PMC1HR_APP_GPIO_2_APP_GPIO			(0x0000)
+#define U300_SYSCON_PMC1HR_APP_GPIO_2_NFIF			(0x1000)
+#define U300_SYSCON_PMC1HR_APP_GPIO_2_DSP			(0x2000)
+#define U300_SYSCON_PMC1HR_APP_GPIO_2_AAIF			(0x3000)
+#define U300_SYSCON_PMC1HR_APP_GPIO_1_MASK			(0x0C00)
+#define U300_SYSCON_PMC1HR_APP_GPIO_1_APP_GPIO			(0x0000)
+#define U300_SYSCON_PMC1HR_APP_GPIO_1_MMC			(0x0400)
+#define U300_SYSCON_PMC1HR_APP_GPIO_1_DSP			(0x0800)
+#define U300_SYSCON_PMC1HR_APP_GPIO_1_AAIF			(0x0C00)
+#define U300_SYSCON_PMC1HR_APP_SPI_CS_2_MASK			(0x0300)
+#define U300_SYSCON_PMC1HR_APP_SPI_CS_2_APP_GPIO		(0x0000)
+#define U300_SYSCON_PMC1HR_APP_SPI_CS_2_SPI			(0x0100)
+#define U300_SYSCON_PMC1HR_APP_SPI_CS_2_AAIF			(0x0300)
+#define U300_SYSCON_PMC1HR_APP_SPI_CS_1_MASK			(0x00C0)
+#define U300_SYSCON_PMC1HR_APP_SPI_CS_1_APP_GPIO		(0x0000)
+#define U300_SYSCON_PMC1HR_APP_SPI_CS_1_SPI			(0x0040)
+#define U300_SYSCON_PMC1HR_APP_SPI_CS_1_AAIF			(0x00C0)
+#define U300_SYSCON_PMC1HR_APP_SPI_2_MASK			(0x0030)
+#define U300_SYSCON_PMC1HR_APP_SPI_2_APP_GPIO			(0x0000)
+#define U300_SYSCON_PMC1HR_APP_SPI_2_SPI			(0x0010)
+#define U300_SYSCON_PMC1HR_APP_SPI_2_DSP			(0x0020)
+#define U300_SYSCON_PMC1HR_APP_SPI_2_AAIF			(0x0030)
+#define U300_SYSCON_PMC1HR_APP_UART0_2_MASK			(0x000C)
+#define U300_SYSCON_PMC1HR_APP_UART0_2_APP_GPIO			(0x0000)
+#define U300_SYSCON_PMC1HR_APP_UART0_2_UART0			(0x0004)
+#define U300_SYSCON_PMC1HR_APP_UART0_2_NFIF_CS			(0x0008)
+#define U300_SYSCON_PMC1HR_APP_UART0_2_AAIF			(0x000C)
+#define U300_SYSCON_PMC1HR_APP_UART0_1_MASK			(0x0003)
+#define U300_SYSCON_PMC1HR_APP_UART0_1_APP_GPIO			(0x0000)
+#define U300_SYSCON_PMC1HR_APP_UART0_1_UART0			(0x0001)
+#define U300_SYSCON_PMC1HR_APP_UART0_1_AAIF			(0x0003)
+/* Padmux 2 control */
+#define U300_SYSCON_PMC2R					(0x100)
+#define U300_SYSCON_PMC2R_APP_MISC_0_MASK			(0x00C0)
+#define U300_SYSCON_PMC2R_APP_MISC_0_APP_GPIO			(0x0000)
+#define U300_SYSCON_PMC2R_APP_MISC_0_EMIF_SDRAM			(0x0040)
+#define U300_SYSCON_PMC2R_APP_MISC_0_MMC			(0x0080)
+#define U300_SYSCON_PMC2R_APP_MISC_0_CDI2			(0x00C0)
+#define U300_SYSCON_PMC2R_APP_MISC_1_MASK			(0x0300)
+#define U300_SYSCON_PMC2R_APP_MISC_1_APP_GPIO			(0x0000)
+#define U300_SYSCON_PMC2R_APP_MISC_1_EMIF_SDRAM			(0x0100)
+#define U300_SYSCON_PMC2R_APP_MISC_1_MMC			(0x0200)
+#define U300_SYSCON_PMC2R_APP_MISC_1_CDI2			(0x0300)
+#define U300_SYSCON_PMC2R_APP_MISC_2_MASK			(0x0C00)
+#define U300_SYSCON_PMC2R_APP_MISC_2_APP_GPIO			(0x0000)
+#define U300_SYSCON_PMC2R_APP_MISC_2_EMIF_SDRAM			(0x0400)
+#define U300_SYSCON_PMC2R_APP_MISC_2_MMC			(0x0800)
+#define U300_SYSCON_PMC2R_APP_MISC_2_CDI2			(0x0C00)
+#define U300_SYSCON_PMC2R_APP_MISC_3_MASK			(0x3000)
+#define U300_SYSCON_PMC2R_APP_MISC_3_APP_GPIO			(0x0000)
+#define U300_SYSCON_PMC2R_APP_MISC_3_EMIF_SDRAM			(0x1000)
+#define U300_SYSCON_PMC2R_APP_MISC_3_MMC			(0x2000)
+#define U300_SYSCON_PMC2R_APP_MISC_3_CDI2			(0x3000)
+#define U300_SYSCON_PMC2R_APP_MISC_4_MASK			(0xC000)
+#define U300_SYSCON_PMC2R_APP_MISC_4_APP_GPIO			(0x0000)
+#define U300_SYSCON_PMC2R_APP_MISC_4_EMIF_SDRAM			(0x4000)
+#define U300_SYSCON_PMC2R_APP_MISC_4_MMC			(0x8000)
+#define U300_SYSCON_PMC2R_APP_MISC_4_ACC_GPIO			(0xC000)
+/* TODO: More SYSCON registers missing */
+#define U300_SYSCON_PMC3R					(0x10c)
+#define U300_SYSCON_PMC3R_APP_MISC_11_MASK			(0xc000)
+#define U300_SYSCON_PMC3R_APP_MISC_11_SPI			(0x4000)
+#define U300_SYSCON_PMC3R_APP_MISC_10_MASK			(0x3000)
+#define U300_SYSCON_PMC3R_APP_MISC_10_SPI			(0x1000)
+/* TODO: Missing other configs */
+#define U300_SYSCON_PMC4R					(0x168)
+#define U300_SYSCON_PMC4R_APP_MISC_12_MASK			(0x0003)
+#define U300_SYSCON_PMC4R_APP_MISC_12_APP_GPIO			(0x0000)
+#define U300_SYSCON_PMC4R_APP_MISC_13_MASK			(0x000C)
+#define U300_SYSCON_PMC4R_APP_MISC_13_CDI			(0x0000)
+#define U300_SYSCON_PMC4R_APP_MISC_13_SMIA			(0x0004)
+#define U300_SYSCON_PMC4R_APP_MISC_13_SMIA2			(0x0008)
+#define U300_SYSCON_PMC4R_APP_MISC_13_APP_GPIO			(0x000C)
+#define U300_SYSCON_PMC4R_APP_MISC_14_MASK			(0x0030)
+#define U300_SYSCON_PMC4R_APP_MISC_14_CDI			(0x0000)
+#define U300_SYSCON_PMC4R_APP_MISC_14_SMIA			(0x0010)
+#define U300_SYSCON_PMC4R_APP_MISC_14_CDI2			(0x0020)
+#define U300_SYSCON_PMC4R_APP_MISC_14_APP_GPIO			(0x0030)
+#define U300_SYSCON_PMC4R_APP_MISC_16_MASK			(0x0300)
+#define U300_SYSCON_PMC4R_APP_MISC_16_APP_GPIO_13		(0x0000)
+#define U300_SYSCON_PMC4R_APP_MISC_16_APP_UART1_CTS		(0x0100)
+#define U300_SYSCON_PMC4R_APP_MISC_16_EMIF_1_STATIC_CS5_N	(0x0200)
-- 
1.7.3.2

