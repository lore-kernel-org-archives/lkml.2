Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755266Ab2BUNfH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 08:35:07 -0500
Received: from eu1sys200aog117.obsmtp.com ([207.126.144.143]:42494 "EHLO
	eu1sys200aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753804Ab2BUNfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 08:35:05 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Cc: Stephen Warren <swarren@nvidia.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Barry Song <21cnbao@gmail.com>, Shawn Guo <shawn.guo@freescale.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] pinctrl: spawn U300 pinctrl from the COH901 GPIO
Date: Tue, 21 Feb 2012 14:34:35 +0100
Message-ID: <1329831275-21769-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.8
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

This solves the riddle on how the U300 pin controller shall be
able to reference the struct gpio_chip even though these are
two separate drivers: spawn the pinctrl child from the GPIO
driver and pass in the struct gpio_chip as platform data.
In the process we rename the U300 "pinmux-u300" to
"pinctrl-u300" so as not to confuse.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 arch/arm/mach-u300/core.c                   |   30 +++++++++++++-------------
 arch/arm/mach-u300/include/mach/gpio-u300.h |    2 +
 drivers/pinctrl/pinctrl-coh901.c            |   10 +++++++-
 drivers/pinctrl/pinctrl-u300.c              |   20 +++++++++++------
 4 files changed, 38 insertions(+), 24 deletions(-)

diff --git a/arch/arm/mach-u300/core.c b/arch/arm/mach-u300/core.c
index bb1034f..030b2c0 100644
--- a/arch/arm/mach-u300/core.c
+++ b/arch/arm/mach-u300/core.c
@@ -1477,7 +1477,7 @@ static struct coh901318_platform coh901318_platform = {
 	.max_channels = U300_DMA_CHANNELS,
 };
 
-static struct resource pinmux_resources[] = {
+static struct resource pinctrl_resources[] = {
 	{
 		.start = U300_SYSCON_BASE,
 		.end   = U300_SYSCON_BASE + SZ_4K - 1,
@@ -1506,6 +1506,13 @@ static struct platform_device i2c1_device = {
 	.resource = i2c1_resources,
 };
 
+static struct platform_device pinctrl_device = {
+	.name = "pinctrl-u300",
+	.id = -1,
+	.num_resources = ARRAY_SIZE(pinctrl_resources),
+	.resource = pinctrl_resources,
+};
+
 /*
  * The different variants have a few different versions of the
  * GPIO block, with different number of ports.
@@ -1525,6 +1532,7 @@ static struct u300_gpio_platform u300_gpio_plat = {
 #endif
 	.gpio_base = 0,
 	.gpio_irq_base = IRQ_U300_GPIO_BASE,
+	.pinctrl_device = &pinctrl_device,
 };
 
 static struct platform_device gpio_device = {
@@ -1597,23 +1605,16 @@ static struct platform_device dma_device = {
 	},
 };
 
-static struct platform_device pinmux_device = {
-	.name = "pinmux-u300",
-	.id = -1,
-	.num_resources = ARRAY_SIZE(pinmux_resources),
-	.resource = pinmux_resources,
-};
-
 /* Pinmux settings */
 static struct pinctrl_map __initdata u300_pinmux_map[] = {
 	/* anonymous maps for chip power and EMIFs */
-	PIN_MAP_SYS_HOG("POWER", "pinmux-u300", "power"),
-	PIN_MAP_SYS_HOG("EMIF0", "pinmux-u300", "emif0"),
-	PIN_MAP_SYS_HOG("EMIF1", "pinmux-u300", "emif1"),
+	PIN_MAP_SYS_HOG("POWER", "pinctrl-u300", "power"),
+	PIN_MAP_SYS_HOG("EMIF0", "pinctrl-u300", "emif0"),
+	PIN_MAP_SYS_HOG("EMIF1", "pinctrl-u300", "emif1"),
 	/* per-device maps for MMC/SD, SPI and UART */
-	PIN_MAP("MMCSD", "pinmux-u300", "mmc0", "mmci"),
-	PIN_MAP("SPI", "pinmux-u300", "spi0", "pl022"),
-	PIN_MAP("UART0", "pinmux-u300", "uart0", "uart0"),
+	PIN_MAP("MMCSD", "pinctrl-u300", "mmc0", "mmci"),
+	PIN_MAP("SPI", "pinctrl-u300", "spi0", "pl022"),
+	PIN_MAP("UART0", "pinctrl-u300", "uart0", "uart0"),
 };
 
 struct u300_mux_hog {
@@ -1676,7 +1677,6 @@ static struct platform_device *platform_devs[] __initdata = {
 	&gpio_device,
 	&nand_device,
 	&wdog_device,
-	&pinmux_device,
 };
 
 /*
diff --git a/arch/arm/mach-u300/include/mach/gpio-u300.h b/arch/arm/mach-u300/include/mach/gpio-u300.h
index bf4c793..e81400c 100644
--- a/arch/arm/mach-u300/include/mach/gpio-u300.h
+++ b/arch/arm/mach-u300/include/mach/gpio-u300.h
@@ -24,12 +24,14 @@ enum u300_gpio_variant {
  * @ports: number of GPIO block ports
  * @gpio_base: first GPIO number for this block (use a free range)
  * @gpio_irq_base: first GPIO IRQ number for this block (use a free range)
+ * @pinctrl_device: pin control device to spawn as child
  */
 struct u300_gpio_platform {
 	enum u300_gpio_variant variant;
 	u8 ports;
 	int gpio_base;
 	int gpio_irq_base;
+	struct platform_device *pinctrl_device;
 };
 
 #endif /* __MACH_U300_GPIO_U300_H */
diff --git a/drivers/pinctrl/pinctrl-coh901.c b/drivers/pinctrl/pinctrl-coh901.c
index eba232a..b90c011 100644
--- a/drivers/pinctrl/pinctrl-coh901.c
+++ b/drivers/pinctrl/pinctrl-coh901.c
@@ -705,7 +705,6 @@ static inline void u300_gpio_free_ports(struct u300_gpio *gpio)
 	list_for_each_safe(p, n, &gpio->port_list) {
 		port = list_entry(p, struct u300_gpio_port, node);
 		list_del(&port->node);
-		free_irq(port->irq, port);
 		kfree(port);
 	}
 }
@@ -861,10 +860,18 @@ static int __init u300_gpio_probe(struct platform_device *pdev)
 		goto err_no_chip;
 	}
 
+	/* Spawn pin controller device as child of the GPIO, pass gpio chip */
+	plat->pinctrl_device->dev.platform_data = &gpio->chip;
+	err = platform_device_register(plat->pinctrl_device);
+	if (err)
+		goto err_no_pinctrl;
+
 	platform_set_drvdata(pdev, gpio);
 
 	return 0;
 
+err_no_pinctrl:
+	err = gpiochip_remove(&gpio->chip);
 err_no_chip:
 err_no_port:
 	u300_gpio_free_ports(gpio);
@@ -919,7 +926,6 @@ static struct platform_driver u300_gpio_driver = {
 	.remove		= __exit_p(u300_gpio_remove),
 };
 
-
 static int __init u300_gpio_init(void)
 {
 	return platform_driver_probe(&u300_gpio_driver, u300_gpio_probe);
diff --git a/drivers/pinctrl/pinctrl-u300.c b/drivers/pinctrl/pinctrl-u300.c
index c8d02f1..fc4a281 100644
--- a/drivers/pinctrl/pinctrl-u300.c
+++ b/drivers/pinctrl/pinctrl-u300.c
@@ -162,7 +162,7 @@
 #define U300_SYSCON_PMC4R_APP_MISC_16_APP_UART1_CTS		0x0100
 #define U300_SYSCON_PMC4R_APP_MISC_16_EMIF_1_STATIC_CS5_N	0x0200
 
-#define DRIVER_NAME "pinmux-u300"
+#define DRIVER_NAME "pinctrl-u300"
 
 /*
  * The DB3350 has 467 pads, I have enumerated the pads clockwise around the
@@ -1053,13 +1053,16 @@ static struct pinctrl_desc u300_pmx_desc = {
 	.owner = THIS_MODULE,
 };
 
-static int __init u300_pmx_probe(struct platform_device *pdev)
+static int __devinit u300_pmx_probe(struct platform_device *pdev)
 {
 	struct u300_pmx *upmx;
 	struct resource *res;
+	struct gpio_chip *gpio_chip = dev_get_platdata(&pdev->dev);
 	int ret;
 	int i;
 
+	pr_err("U300 PMX PROBE\n");
+
 	/* Create state holders etc for this driver */
 	upmx = devm_kzalloc(&pdev->dev, sizeof(*upmx), GFP_KERNEL);
 	if (!upmx)
@@ -1095,12 +1098,14 @@ static int __init u300_pmx_probe(struct platform_device *pdev)
 	}
 
 	/* We will handle a range of GPIO pins */
-	for (i = 0; i < ARRAY_SIZE(u300_gpio_ranges); i++)
+	for (i = 0; i < ARRAY_SIZE(u300_gpio_ranges); i++) {
+		u300_gpio_ranges[i].gc = gpio_chip;
 		pinctrl_add_gpio_range(upmx->pctl, &u300_gpio_ranges[i]);
+	}
 
 	platform_set_drvdata(pdev, upmx);
 
-	dev_info(&pdev->dev, "initialized U300 pinmux driver\n");
+	dev_info(&pdev->dev, "initialized U300 pin control driver\n");
 
 	return 0;
 
@@ -1115,7 +1120,7 @@ out_no_resource:
 	return ret;
 }
 
-static int __exit u300_pmx_remove(struct platform_device *pdev)
+static int __devexit u300_pmx_remove(struct platform_device *pdev)
 {
 	struct u300_pmx *upmx = platform_get_drvdata(pdev);
 	int i;
@@ -1136,12 +1141,13 @@ static struct platform_driver u300_pmx_driver = {
 		.name = DRIVER_NAME,
 		.owner = THIS_MODULE,
 	},
-	.remove = __exit_p(u300_pmx_remove),
+	.probe = u300_pmx_probe,
+	.remove = __devexit_p(u300_pmx_remove),
 };
 
 static int __init u300_pmx_init(void)
 {
-	return platform_driver_probe(&u300_pmx_driver, u300_pmx_probe);
+	return platform_driver_register(&u300_pmx_driver);
 }
 arch_initcall(u300_pmx_init);
 
-- 
1.7.8

