Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757457Ab2ENRns (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 13:43:48 -0400
Received: from nbd.name ([46.4.11.11]:55576 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757398Ab2ENRnf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 13:43:35 -0400
From: John Crispin <blogic@openwrt.org>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org, John Crispin <blogic@openwrt.org>,
        Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org
Subject: [RESEND PATCH V2 08/17] GPIO: MIPS: lantiq: convert gpio-stp to OF and move it to subsystem
Date: Mon, 14 May 2012 19:42:34 +0200
Message-Id: <1337017363-14424-8-git-send-email-blogic@openwrt.org>
X-Mailer: git-send-email 1.7.9.1
In-Reply-To: <1337017363-14424-1-git-send-email-blogic@openwrt.org>
References: <1337017363-14424-1-git-send-email-blogic@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implements OF support and moves the driver from arch/mips/lantiq/xway/ to the
gpio subsystem.

The Serial To Parallel (STP) is found on MIPS based Lantiq socs. It is a
peripheral controller used to drive external shift register cascades. At most
3 groups of 8 bits can be driven. The hardware is able to allow the DSL modem
to drive the 2 LSBs of the cascade automatically. The driver currently only
supports output functionality. Patches for the input feature found on newer
generations of the soc will be provided in a later series.

Signed-off-by: John Crispin <blogic@openwrt.org>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org
---
This patch is part of a series moving the mips/lantiq target to OF and clkdev
support. The patch, once Acked, should go upstream via Ralf's MIPS tree.

 arch/mips/lantiq/xway/Makefile   |    2 +-
 arch/mips/lantiq/xway/gpio_stp.c |  152 -------------------
 drivers/gpio/Kconfig             |   10 ++
 drivers/gpio/Makefile            |    1 +
 drivers/gpio/gpio-stp-xway.c     |  300 ++++++++++++++++++++++++++++++++++++++
 5 files changed, 312 insertions(+), 153 deletions(-)
 delete mode 100644 arch/mips/lantiq/xway/gpio_stp.c
 create mode 100644 drivers/gpio/gpio-stp-xway.c

diff --git a/arch/mips/lantiq/xway/Makefile b/arch/mips/lantiq/xway/Makefile
index edef6c5..d0a0c96 100644
--- a/arch/mips/lantiq/xway/Makefile
+++ b/arch/mips/lantiq/xway/Makefile
@@ -1 +1 @@
-obj-y := prom.o sysctrl.o clk.o reset.o gpio.o gpio_stp.o gpio_ebu.o dma.o
+obj-y := prom.o sysctrl.o clk.o reset.o gpio.o gpio_ebu.o dma.o
diff --git a/arch/mips/lantiq/xway/gpio_stp.c b/arch/mips/lantiq/xway/gpio_stp.c
deleted file mode 100644
index d674f1b..0000000
--- a/arch/mips/lantiq/xway/gpio_stp.c
+++ /dev/null
@@ -1,152 +0,0 @@
-/*
- *  This program is free software; you can redistribute it and/or modify it
- *  under the terms of the GNU General Public License version 2 as published
- *  by the Free Software Foundation.
- *
- *  Copyright (C) 2007 John Crispin <blogic@openwrt.org>
- *
- */
-
-#include <linux/slab.h>
-#include <linux/init.h>
-#include <linux/export.h>
-#include <linux/types.h>
-#include <linux/platform_device.h>
-#include <linux/mutex.h>
-#include <linux/io.h>
-#include <linux/gpio.h>
-
-#include <lantiq_soc.h>
-
-#define LTQ_STP_CON0		0x00
-#define LTQ_STP_CON1		0x04
-#define LTQ_STP_CPU0		0x08
-#define LTQ_STP_CPU1		0x0C
-#define LTQ_STP_AR		0x10
-
-#define LTQ_STP_CON_SWU		(1 << 31)
-#define LTQ_STP_2HZ		0
-#define LTQ_STP_4HZ		(1 << 23)
-#define LTQ_STP_8HZ		(2 << 23)
-#define LTQ_STP_10HZ		(3 << 23)
-#define LTQ_STP_SPEED_MASK	(0xf << 23)
-#define LTQ_STP_UPD_FPI		(1 << 31)
-#define LTQ_STP_UPD_MASK	(3 << 30)
-#define LTQ_STP_ADSL_SRC	(3 << 24)
-
-#define LTQ_STP_GROUP0		(1 << 0)
-
-#define LTQ_STP_RISING		0
-#define LTQ_STP_FALLING		(1 << 26)
-#define LTQ_STP_EDGE_MASK	(1 << 26)
-
-#define ltq_stp_r32(reg)	__raw_readl(ltq_stp_membase + reg)
-#define ltq_stp_w32(val, reg)	__raw_writel(val, ltq_stp_membase + reg)
-#define ltq_stp_w32_mask(clear, set, reg) \
-		ltq_w32((ltq_r32(ltq_stp_membase + reg) & ~(clear)) | (set), \
-		ltq_stp_membase + (reg))
-
-static int ltq_stp_shadow = 0xffff;
-static void __iomem *ltq_stp_membase;
-
-static void ltq_stp_set(struct gpio_chip *chip, unsigned offset, int value)
-{
-	if (value)
-		ltq_stp_shadow |= (1 << offset);
-	else
-		ltq_stp_shadow &= ~(1 << offset);
-	ltq_stp_w32(ltq_stp_shadow, LTQ_STP_CPU0);
-}
-
-static int ltq_stp_direction_output(struct gpio_chip *chip, unsigned offset,
-	int value)
-{
-	ltq_stp_set(chip, offset, value);
-
-	return 0;
-}
-
-static struct gpio_chip ltq_stp_chip = {
-	.label = "ltq_stp",
-	.direction_output = ltq_stp_direction_output,
-	.set = ltq_stp_set,
-	.base = 48,
-	.ngpio = 24,
-	.can_sleep = 1,
-	.owner = THIS_MODULE,
-};
-
-static int ltq_stp_hw_init(void)
-{
-	/* sane defaults */
-	ltq_stp_w32(0, LTQ_STP_AR);
-	ltq_stp_w32(0, LTQ_STP_CPU0);
-	ltq_stp_w32(0, LTQ_STP_CPU1);
-	ltq_stp_w32(LTQ_STP_CON_SWU, LTQ_STP_CON0);
-	ltq_stp_w32(0, LTQ_STP_CON1);
-
-	/* rising or falling edge */
-	ltq_stp_w32_mask(LTQ_STP_EDGE_MASK, LTQ_STP_FALLING, LTQ_STP_CON0);
-
-	/* per default stp 15-0 are set */
-	ltq_stp_w32_mask(0, LTQ_STP_GROUP0, LTQ_STP_CON1);
-
-	/* stp are update periodically by the FPI bus */
-	ltq_stp_w32_mask(LTQ_STP_UPD_MASK, LTQ_STP_UPD_FPI, LTQ_STP_CON1);
-
-	/* set stp update speed */
-	ltq_stp_w32_mask(LTQ_STP_SPEED_MASK, LTQ_STP_8HZ, LTQ_STP_CON1);
-
-	/* tell the hardware that pin (led) 0 and 1 are controlled
-	 *  by the dsl arc
-	 */
-	ltq_stp_w32_mask(0, LTQ_STP_ADSL_SRC, LTQ_STP_CON0);
-
-	ltq_pmu_enable(PMU_LED);
-	return 0;
-}
-
-static int __devinit ltq_stp_probe(struct platform_device *pdev)
-{
-	struct resource *res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	int ret = 0;
-
-	if (!res)
-		return -ENOENT;
-	res = devm_request_mem_region(&pdev->dev, res->start,
-		resource_size(res), dev_name(&pdev->dev));
-	if (!res) {
-		dev_err(&pdev->dev, "failed to request STP memory\n");
-		return -EBUSY;
-	}
-	ltq_stp_membase = devm_ioremap_nocache(&pdev->dev, res->start,
-		resource_size(res));
-	if (!ltq_stp_membase) {
-		dev_err(&pdev->dev, "failed to remap STP memory\n");
-		return -ENOMEM;
-	}
-	ret = gpiochip_add(&ltq_stp_chip);
-	if (!ret)
-		ret = ltq_stp_hw_init();
-
-	return ret;
-}
-
-static struct platform_driver ltq_stp_driver = {
-	.probe = ltq_stp_probe,
-	.driver = {
-		.name = "ltq_stp",
-		.owner = THIS_MODULE,
-	},
-};
-
-int __init ltq_stp_init(void)
-{
-	int ret = platform_driver_register(&ltq_stp_driver);
-
-	if (ret)
-		pr_info("ltq_stp: error registering platfom driver");
-	return ret;
-}
-
-postcore_initcall(ltq_stp_init);
diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index e03653d..4875071 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -306,6 +306,16 @@ config GPIO_STMPE
 	  This enables support for the GPIOs found on the STMPE I/O
 	  Expanders.
 
+config GPIO_STP_XWAY
+	bool "XWAY STP GPIOs"
+	depends on SOC_XWAY
+	help
+	  This enables support for the Serial To Parallel (STP) unit found on
+	  XWAY SoC. The STP allows the SoC to drive a shift registers cascade,
+	  that can be up to 24 bit. This peripheral is aimed at driving leds.
+	  Some of the gpios/leds can be auto updated by the soc with dsl and
+	  phy status.
+
 config GPIO_TC3589X
 	bool "TC3589X GPIOs"
 	depends on MFD_TC3589X
diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
index 007f54b..6447841 100644
--- a/drivers/gpio/Makefile
+++ b/drivers/gpio/Makefile
@@ -49,6 +49,7 @@ obj-$(CONFIG_ARCH_SA1100)	+= gpio-sa1100.o
 obj-$(CONFIG_GPIO_SCH)		+= gpio-sch.o
 obj-$(CONFIG_GPIO_SODAVILLE)	+= gpio-sodaville.o
 obj-$(CONFIG_GPIO_STMPE)	+= gpio-stmpe.o
+obj-$(CONFIG_GPIO_STP_XWAY)	+= gpio-stp-xway.o
 obj-$(CONFIG_GPIO_SX150X)	+= gpio-sx150x.o
 obj-$(CONFIG_GPIO_TC3589X)	+= gpio-tc3589x.o
 obj-$(CONFIG_ARCH_TEGRA)	+= gpio-tegra.o
diff --git a/drivers/gpio/gpio-stp-xway.c b/drivers/gpio/gpio-stp-xway.c
new file mode 100644
index 0000000..9b53adf
--- /dev/null
+++ b/drivers/gpio/gpio-stp-xway.c
@@ -0,0 +1,300 @@
+/*
+ *  This program is free software; you can redistribute it and/or modify it
+ *  under the terms of the GNU General Public License version 2 as published
+ *  by the Free Software Foundation.
+ *
+ *  Copyright (C) 2012 John Crispin <blogic@openwrt.org>
+ *
+ */
+
+#include <linux/slab.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/types.h>
+#include <linux/of_platform.h>
+#include <linux/mutex.h>
+#include <linux/io.h>
+#include <linux/of_gpio.h>
+#include <linux/clk.h>
+#include <linux/err.h>
+
+#include <lantiq_soc.h>
+
+/*
+ * The Serial To Parallel (STP) is found on MIPS based Lantiq socs. It is a
+ * peripheral controller used to drive external shift register cascades. At most
+ * 3 groups of 8 bits can be driven. The hardware is able to allow the DSL modem
+ * to drive the 2 LSBs of the cascade automatically.
+ */
+
+/* control register 0 */
+#define XWAY_STP_CON0		0x00
+/* control register 1 */
+#define XWAY_STP_CON1		0x04
+/* data register 0 */
+#define XWAY_STP_CPU0		0x08
+/* data register 1 */
+#define XWAY_STP_CPU1		0x0C
+/* access register */
+#define XWAY_STP_AR		0x10
+
+/* software or hardware update select bit */
+#define XWAY_STP_CON_SWU	BIT(31)
+
+/* automatic update rates */
+#define XWAY_STP_2HZ		0
+#define XWAY_STP_4HZ		BIT(23)
+#define XWAY_STP_8HZ		BIT(24)
+#define XWAY_STP_10HZ		(BIT(24) | BIT(23))
+#define XWAY_STP_SPEED_MASK	(0xf << 23)
+
+/* clock source for automatic update */
+#define XWAY_STP_UPD_FPI	BIT(31)
+#define XWAY_STP_UPD_MASK	(BIT(31) | BIT(30))
+
+/* let the adsl core drive the 2 LSBs */
+#define XWAY_STP_ADSL_SHIFT	24
+#define XWAY_STP_ADSL_MASK	0x3
+
+/* 2 groups of 3 bits can be driven by the phys */
+#define XWAY_STP_PHY_MASK	0x3
+#define XWAY_STP_PHY1_SHIFT	27
+#define XWAY_STP_PHY2_SHIFT	15
+
+/* STP has 3 groups of 8 bits */
+#define XWAY_STP_GROUP0		BIT(0)
+#define XWAY_STP_GROUP1		BIT(1)
+#define XWAY_STP_GROUP2		BIT(2)
+#define XWAY_STP_GROUP_MASK	(0x7)
+
+/* Edge configuration bits */
+#define XWAY_STP_FALLING	BIT(26)
+#define XWAY_STP_EDGE_MASK	BIT(26)
+
+#define xway_stp_r32(m, reg)		__raw_readl(m + reg)
+#define xway_stp_w32(m, val, reg)	__raw_writel(val, m + reg)
+#define xway_stp_w32_mask(m, clear, set, reg) \
+		ltq_w32((ltq_r32(m + reg) & ~(clear)) | (set), \
+		m + reg)
+
+struct xway_stp {
+	struct gpio_chip gc;
+	void __iomem *virt;
+	u32 edge;	/* rising or falling edge triggered shift register */
+	u16 shadow;	/* shadow the shift registers state */
+	u8 groups;	/* we can drive 1-3 groups of 8bit each */
+	u8 dsl;		/* the 2 LSBs can be driven by the dsl core */
+	u8 phy1;	/* 3 bits can be driven by phy1 */
+	u8 phy2;	/* 3 bits can be driven by phy2 */
+	u8 reserved;	/* mask out the hw driven bits in gpio_request */
+};
+
+/*
+ * xway_stp_set - gpio_chip->set - set gpios.
+ * @gc:     Pointer to gpio_chip device structure.
+ * @gpio:   GPIO signal number.
+ * @val:    Value to be written to specified signal.
+ *
+ * Set the shadow value and call ltq_ebu_apply.
+ */
+static void xway_stp_set(struct gpio_chip *gc, unsigned gpio, int val)
+{
+	struct xway_stp *chip =
+		container_of(gc, struct xway_stp, gc);
+
+	if (val)
+		chip->shadow |= BIT(gpio);
+	else
+		chip->shadow &= ~BIT(gpio);
+	xway_stp_w32(chip->virt, chip->shadow, XWAY_STP_CPU0);
+	xway_stp_w32_mask(chip->virt, 0, XWAY_STP_CON_SWU, XWAY_STP_CON0);
+}
+
+/*
+ * xway_stp_dir_out - gpio_chip->dir_out - set gpio direction.
+ * @gc:     Pointer to gpio_chip device structure.
+ * @gpio:   GPIO signal number.
+ * @val:    Value to be written to specified signal.
+ *
+ * Same as xway_stp_set, always returns 0.
+ */
+static int xway_stp_dir_out(struct gpio_chip *gc, unsigned gpio, int val)
+{
+	xway_stp_set(gc, gpio, val);
+
+	return 0;
+}
+
+/*
+ * xway_stp_request - gpio_chip->request
+ * @gc:     Pointer to gpio_chip device structure.
+ * @gpio:   GPIO signal number.
+ *
+ * We mask out the HW driven pins
+ */
+static int xway_stp_request(struct gpio_chip *gc, unsigned gpio)
+{
+	struct xway_stp *chip =
+		container_of(gc, struct xway_stp, gc);
+
+	if ((gpio < 8) && (chip->reserved & BIT(gpio))) {
+		dev_err(gc->dev, "GPIO %d is driven by hardware\n", gpio);
+		return -ENODEV;
+	}
+
+	return 0;
+}
+
+/*
+ * xway_stp_hw_init - Configure the STP unit and enable the clock gate
+ * @virt: pointer to the remapped register range
+ */
+static int xway_stp_hw_init(struct xway_stp *chip)
+{
+	/* sane defaults */
+	xway_stp_w32(chip->virt, 0, XWAY_STP_AR);
+	xway_stp_w32(chip->virt, 0, XWAY_STP_CPU0);
+	xway_stp_w32(chip->virt, 0, XWAY_STP_CPU1);
+	xway_stp_w32(chip->virt, XWAY_STP_CON_SWU, XWAY_STP_CON0);
+	xway_stp_w32(chip->virt, 0, XWAY_STP_CON1);
+
+	/* apply edge trigger settings for the shift register */
+	xway_stp_w32_mask(chip->virt, XWAY_STP_EDGE_MASK,
+				chip->edge, XWAY_STP_CON0);
+
+	/* apply led group settings */
+	xway_stp_w32_mask(chip->virt, XWAY_STP_GROUP_MASK,
+				chip->groups, XWAY_STP_CON1);
+
+	/* tell the hardware which pins are controlled by the dsl modem */
+	xway_stp_w32_mask(chip->virt,
+			XWAY_STP_ADSL_MASK << XWAY_STP_ADSL_SHIFT,
+			chip->dsl << XWAY_STP_ADSL_SHIFT,
+			XWAY_STP_CON0);
+
+	/* tell the hardware which pins are controlled by the phys */
+	xway_stp_w32_mask(chip->virt,
+			XWAY_STP_PHY_MASK << XWAY_STP_PHY1_SHIFT,
+			chip->phy1 << XWAY_STP_PHY1_SHIFT,
+			XWAY_STP_CON0);
+	xway_stp_w32_mask(chip->virt,
+			XWAY_STP_PHY_MASK << XWAY_STP_PHY2_SHIFT,
+			chip->phy2 << XWAY_STP_PHY2_SHIFT,
+			XWAY_STP_CON1);
+
+	/* mask out the hw driven bits in gpio_request */
+	chip->reserved = (chip->phy2 << 5) | (chip->phy1 << 2) | chip->dsl;
+
+	/*
+	 * if we have pins that are driven by hw, we need to tell the stp what
+	 * clock to use as a timer.
+	 */
+	if (chip->reserved)
+		xway_stp_w32_mask(chip->virt, XWAY_STP_UPD_MASK,
+			XWAY_STP_UPD_FPI, XWAY_STP_CON1);
+
+	return 0;
+}
+
+static int __devinit xway_stp_probe(struct platform_device *pdev)
+{
+	struct resource *res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	const __be32 *shadow, *groups, *dsl, *phy;
+	struct xway_stp *chip;
+	struct clk *clk;
+	int ret = 0;
+
+	if (!res) {
+		dev_err(&pdev->dev, "failed to request STP resource\n");
+		return -ENOENT;
+	}
+
+	chip = devm_kzalloc(&pdev->dev, sizeof(*chip), GFP_KERNEL);
+	if (!chip)
+		return -ENOMEM;
+
+	chip->virt = devm_request_and_ioremap(&pdev->dev, res);
+	if (!chip->virt) {
+		dev_err(&pdev->dev, "failed to remap STP memory\n");
+		return -ENOMEM;
+	}
+	chip->gc.dev = &pdev->dev;
+	chip->gc.label = "stp-xway";
+	chip->gc.direction_output = xway_stp_dir_out;
+	chip->gc.set = xway_stp_set;
+	chip->gc.request = xway_stp_request;
+	chip->gc.base = -1;
+	chip->gc.owner = THIS_MODULE;
+
+	/* store the shadow value if one was passed by the devicetree */
+	shadow = of_get_property(pdev->dev.of_node, "lantiq,shadow", NULL);
+	if (shadow)
+		chip->shadow = *shadow;
+
+	/* find out which gpio groups should be enabled */
+	groups = of_get_property(pdev->dev.of_node, "lantiq,groups", NULL);
+	if (groups)
+		chip->groups = *groups & XWAY_STP_GROUP_MASK;
+	else
+		chip->groups = XWAY_STP_GROUP0;
+	chip->gc.ngpio = fls(chip->groups) * 8;
+
+	/* find out which gpios are controlled by the dsl core */
+	dsl = of_get_property(pdev->dev.of_node, "lantiq,dsl", NULL);
+	if (dsl)
+		chip->dsl = *dsl & XWAY_STP_ADSL_MASK;
+
+	/* find out which gpios are controlled by the phys */
+	if (of_machine_is_compatible("lantiq,ar9") ||
+			of_machine_is_compatible("lantiq,gr9") ||
+			of_machine_is_compatible("lantiq,vr9")) {
+		phy = of_get_property(pdev->dev.of_node, "lantiq,phy1", NULL);
+		if (phy)
+			chip->phy1 = *phy & XWAY_STP_PHY_MASK;
+		phy = of_get_property(pdev->dev.of_node, "lantiq,phy2", NULL);
+		if (phy)
+			chip->phy2 = *phy & XWAY_STP_PHY_MASK;
+	}
+
+	/* check which edge trigger we should use, default to a falling edge */
+	if (!of_find_property(pdev->dev.of_node, "lantiq,rising", NULL))
+		chip->edge = XWAY_STP_FALLING;
+
+	clk = clk_get(&pdev->dev, NULL);
+	if (IS_ERR(clk)) {
+		dev_err(&pdev->dev, "Failed to get clock\n");
+		return PTR_ERR(clk);
+	}
+	clk_enable(clk);
+
+	ret = xway_stp_hw_init(chip);
+	if (!ret)
+		ret = gpiochip_add(&chip->gc);
+
+	if (!ret)
+		dev_info(&pdev->dev, "Init done\n");
+
+	return ret;
+}
+
+static const struct of_device_id xway_stp_match[] = {
+	{ .compatible = "lantiq,gpio-stp-xway" },
+	{},
+};
+MODULE_DEVICE_TABLE(of, xway_stp_match);
+
+static struct platform_driver xway_stp_driver = {
+	.probe = xway_stp_probe,
+	.driver = {
+		.name = "gpio-stp-xway",
+		.owner = THIS_MODULE,
+		.of_match_table = xway_stp_match,
+	},
+};
+
+int __init xway_stp_init(void)
+{
+	return platform_driver_register(&xway_stp_driver);
+}
+
+subsys_initcall(xway_stp_init);
-- 
1.7.9.1

