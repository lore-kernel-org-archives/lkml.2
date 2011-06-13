Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754127Ab1FMQ7P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 12:59:15 -0400
Received: from eu1sys200aog106.obsmtp.com ([207.126.144.121]:48760 "EHLO
	eu1sys200aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753472Ab1FMQ7N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 12:59:13 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Cc: Grant Likely <grant.likely@secretlab.ca>, Lee Jones <lee.jones@linaro.org>,
        Martin Persson <martin.persson@stericsson.com>,
        Stephen Warren <swarren@nvidia.com>, Joe Perches <joe@perches.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linaro Dev <linaro-dev@lists.linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 2/2] pinmux: add a driver for the U300 pinmux
Date: Mon, 13 Jun 2011 18:58:31 +0200
Message-ID: <1307984311-9813-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

This adds a driver for the U300 pinmux portions of the system
controller "SYSCON". It also serves as an example of how to use
the pinmux subsystem. This driver also houses the platform data
for the only supported platform.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 arch/arm/mach-u300/core.c     |   19 ++
 drivers/pinctrl/pinmux-u300.c |  433 +++++++++++++++++++++++++++++++++++++++++
 drivers/pinctrl/pinmux-u300.h |  141 +++++++++++++
 3 files changed, 593 insertions(+), 0 deletions(-)
 create mode 100644 drivers/pinctrl/pinmux-u300.c
 create mode 100644 drivers/pinctrl/pinmux-u300.h

diff --git a/arch/arm/mach-u300/core.c b/arch/arm/mach-u300/core.c
index 513d6ab..d52e0bd 100644
--- a/arch/arm/mach-u300/core.c
+++ b/arch/arm/mach-u300/core.c
@@ -25,6 +25,7 @@
 #include <linux/err.h>
 #include <linux/mtd/nand.h>
 #include <linux/mtd/fsmc.h>
+#include <linux/pinctrl/machine.h>
 
 #include <asm/types.h>
 #include <asm/setup.h>
@@ -1630,6 +1631,20 @@ static struct platform_device dma_device = {
 	},
 };
 
+static struct platform_device pinmux_device = {
+	.name = "pinmux-u300",
+	.id = -1,
+	.num_resources = ARRAY_SIZE(pinmux_resources),
+	.resource = pinmux_resources,
+};
+
+/* Padmux settings */
+static struct pinmux_map u300_padmux_map[] = {
+	PINMUX_MAP("mmc0", "mmci"),
+	PINMUX_MAP("spi0", "pl022"),
+	PINMUX_MAP("uart0", "uart0"),
+};
+
 /*
  * Notice that AMBA devices are initialized before platform devices.
  *
@@ -1828,6 +1843,10 @@ void __init u300_init_devices(void)
 
 	u300_assign_physmem();
 
+	/* Initialize pinmuxing */
+	pinmux_register_mappings(u300_padmux_map,
+				 ARRAY_SIZE(u300_padmux_map));
+
 	/* Register subdevices on the I2C buses */
 	u300_i2c_register_board_devices();
 
diff --git a/drivers/pinctrl/pinmux-u300.c b/drivers/pinctrl/pinmux-u300.c
new file mode 100644
index 0000000..da26789
--- /dev/null
+++ b/drivers/pinctrl/pinmux-u300.c
@@ -0,0 +1,433 @@
+/*
+ * Driver for the U300 pinmux
+ *
+ * Based on the original U300 padmux functions
+ * Copyright (C) 2009-2011 ST-Ericsson AB
+ * Author: Martin Persson <martin.persson@stericsson.com>
+ * Author: Linus Walleij <linus.walleij@linaro.org>
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
+/*
+ * Usually you want the board to define the pins, but we have only one board,
+ * so let us do it all in this all-encompassing file.
+ */
+#include <linux/pinctrl/machine.h>
+#include <linux/pinctrl/pinmux.h>
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
+/* Pad names for the pinmux subsystem */
+const struct pinctrl_pin_desc __initdata u300_pads[] = {
+	PINCTRL_PIN(0, "P PAD VDD 28"),
+	PINCTRL_PIN(1, "P PAD GND 28"),
+	PINCTRL_PIN(2, "PO SIM RST N"),
+	PINCTRL_PIN(3, "VSSIO 25"),
+	PINCTRL_PIN(4, "VSSA ADDA ESDSUB"),
+	PINCTRL_PIN(5, "PWR VSSCOMMON"),
+	PINCTRL_PIN(6, "PI ADC I1 POS"),
+	PINCTRL_PIN(7, "PI ADC I1 NEG"),
+	PINCTRL_PIN(8, "PWR VSSAD0"),
+	PINCTRL_PIN(9, "PWR VCCAD0"),
+	PINCTRL_PIN(10, "PI ADC Q1 NEG"),
+	PINCTRL_PIN(11, "PI ADC Q1 POS"),
+	PINCTRL_PIN(12, "PWR VDDAD"),
+	PINCTRL_PIN(13, "PWR GNDAD"),
+	PINCTRL_PIN(14, "PI ADC I2 POS"),
+	PINCTRL_PIN(15, "PI ADC I2 NEG"),
+	PINCTRL_PIN(16, "PWR VSSAD1"),
+	PINCTRL_PIN(17, "PWR VCCAD1"),
+	PINCTRL_PIN(18, "PI ADC Q2 NEG"),
+	PINCTRL_PIN(19, "PI ADC Q2 POS"),
+	PINCTRL_PIN(20, "VSSA ADDA ESDSUB"),
+	PINCTRL_PIN(21, "PWR VCCGPAD"),
+	PINCTRL_PIN(22, "PI TX POW"),
+	PINCTRL_PIN(23, "PWR VSSGPAD"),
+	PINCTRL_PIN(24, "PO DAC I POS"),
+	PINCTRL_PIN(25, "PO DAC I NEG"),
+	PINCTRL_PIN(26, "PO DAC Q POS"),
+	PINCTRL_PIN(27, "PO DAC Q NEG"),
+	PINCTRL_PIN(28, "PWR VSSDA"),
+	PINCTRL_PIN(29, "PWR VCCDA"),
+	PINCTRL_PIN(30, "VSSA ADDA ESDSUB"),
+	PINCTRL_PIN(31, "P PAD VDDIO 11"),
+	PINCTRL_PIN(32, "PI PLL 26 FILTVDD"),
+	PINCTRL_PIN(33, "PI PLL 26 VCONT"),
+	PINCTRL_PIN(34, "PWR AGNDPLL2V5 32 13"),
+	PINCTRL_PIN(35, "PWR AVDDPLL2V5 32 13"),
+	PINCTRL_PIN(36, "VDDA PLL ESD"),
+	PINCTRL_PIN(37, "VSSA PLL ESD"),
+	PINCTRL_PIN(38, "VSS PLL"),
+	PINCTRL_PIN(39, "VDDC PLL"),
+	PINCTRL_PIN(40, "PWR AGNDPLL2V5 26 60"),
+	PINCTRL_PIN(41, "PWR AVDDPLL2V5 26 60"),
+	PINCTRL_PIN(42, "PWR AVDDPLL2V5 26 208"),
+	PINCTRL_PIN(43, "PWR AGNDPLL2V5 26 208"),
+	PINCTRL_PIN(44, "PWR AVDDPLL2V5 13 208"),
+	PINCTRL_PIN(45, "PWR AGNDPLL2V5 13 208"),
+	PINCTRL_PIN(46, "P PAD VSSIO 11"),
+	PINCTRL_PIN(47, "P PAD VSSIO 12"),
+	PINCTRL_PIN(48, "PI POW RST N"),
+	PINCTRL_PIN(49, "VDDC IO"),
+	PINCTRL_PIN(50, "P PAD VDDIO 16"),
+	PINCTRL_PIN(134, "UART0 RTS"),
+	PINCTRL_PIN(135, "UART0 CTS"),
+	PINCTRL_PIN(136, "UART0 TX"),
+	PINCTRL_PIN(137, "UART0 RX"),
+	PINCTRL_PIN(166, "MMC DATA DIR LS"),
+	PINCTRL_PIN(167, "MMC DATA 3"),
+	PINCTRL_PIN(168, "MMC DATA 2"),
+	PINCTRL_PIN(169, "MMC DATA 1"),
+	PINCTRL_PIN(170, "MMC DATA 0"),
+	PINCTRL_PIN(171, "MMC CMD DIR LS"),
+	PINCTRL_PIN(176, "MMC CMD"),
+	PINCTRL_PIN(177, "MMC CLK"),
+	PINCTRL_PIN(420, "SPI CLK"),
+	PINCTRL_PIN(421, "SPI DO"),
+	PINCTRL_PIN(422, "SPI DI"),
+	PINCTRL_PIN(423, "SPI CS0"),
+	PINCTRL_PIN(424, "SPI CS1"),
+	PINCTRL_PIN(425, "SPI CS2"),
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
+ * struct u300_pmx_func - describes a U300 pinmux function
+ * @name: the name of this specific function
+ * @pins: an array of discrete physical pins used in this mapping, taken
+ *	from the global pin enumeration space
+ * @num_pins: the number of pins in this mapping array, i.e. the number of
+ *	elements in .pins so we can iterate over that array
+ * @onmask: bits to set to enable this muxing
+ */
+struct u300_pmx_func {
+	const char *name;
+	const unsigned int *pins;
+	const unsigned num_pins;
+	const struct u300_pmx_mask *mask;
+};
+
+static const unsigned uart0_pins[] = { 134, 135, 136, 137 };
+static const unsigned mmc0_pins[] = { 166, 167, 168, 169, 170, 171, 176, 177 };
+static const unsigned spi0_pins[] = { 420, 421, 422, 423, 424, 425 };
+
+static const struct u300_pmx_mask uart0_mask[] = {
+	{0, 0},
+	{
+		U300_SYSCON_PMC1HR_APP_UART0_1_MASK |
+		U300_SYSCON_PMC1HR_APP_UART0_2_MASK,
+		U300_SYSCON_PMC1HR_APP_UART0_1_UART0 |
+		U300_SYSCON_PMC1HR_APP_UART0_2_UART0
+	},
+	{0, 0},
+	{0, 0},
+	{0, 0},
+};
+
+static const struct u300_pmx_mask mmc0_mask[] = {
+	{ U300_SYSCON_PMC1LR_MMCSD_MASK, U300_SYSCON_PMC1LR_MMCSD_MMCSD},
+	{0, 0},
+	{0, 0},
+	{0, 0},
+	{ U300_SYSCON_PMC4R_APP_MISC_12_MASK,
+	  U300_SYSCON_PMC4R_APP_MISC_12_APP_GPIO }
+};
+
+static const struct u300_pmx_mask spi0_mask[] = {
+	{0, 0},
+	{
+		U300_SYSCON_PMC1HR_APP_SPI_2_MASK |
+		U300_SYSCON_PMC1HR_APP_SPI_CS_1_MASK |
+		U300_SYSCON_PMC1HR_APP_SPI_CS_2_MASK,
+		U300_SYSCON_PMC1HR_APP_SPI_2_SPI |
+		U300_SYSCON_PMC1HR_APP_SPI_CS_1_SPI |
+		U300_SYSCON_PMC1HR_APP_SPI_CS_2_SPI
+	},
+	{0, 0},
+	{0, 0},
+	{0, 0}
+};
+
+static const struct u300_pmx_func u300_pmx_funcs[] = {
+	{
+		.name = "uart0",
+		.pins = uart0_pins,
+		.num_pins = ARRAY_SIZE(uart0_pins),
+		.mask = uart0_mask,
+	},
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
+	seq_printf(s, " " DRIVER_NAME);
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
+	/* First register all pads */
+	ret = pinctrl_register_pins_dense(u300_pads,
+					  ARRAY_SIZE(u300_pads),
+					  U300_NUM_PADS);
+	if (ret) {
+		dev_err(&pdev->dev, "could not register U300 pads\n");
+		return ret;
+	}
+
+	/* Then create state holders etc for this driver */
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
+		dev_err(&pdev->dev, "could not register U300 pinmux driver\n");
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
+	release_mem_region(upmx->phybase, upmx->physize);
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
diff --git a/drivers/pinctrl/pinmux-u300.h b/drivers/pinctrl/pinmux-u300.h
new file mode 100644
index 0000000..c2ec260
--- /dev/null
+++ b/drivers/pinctrl/pinmux-u300.h
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

