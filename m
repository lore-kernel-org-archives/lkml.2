Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755003Ab1D3R7c (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 13:59:32 -0400
Received: from relay.ptn-ipout01.plus.net ([212.159.7.35]:55147 "EHLO
	relay.ptn-ipout01.plus.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751029Ab1D3R73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 13:59:29 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnYZAB9NvE3Unw4U/2dsb2JhbACCNIJfkw2Nd3ezFQKGPokXDoVyBJMSg36GCw
Subject: [PATCH 1/2] mfd: Add ASIC3 LED support
From: "Paul Parsons" <lost.distance@yahoo.com>
To: <linux-kernel@vger.kernel.org>
Cc: <sameo@linux.intel.com>
Date: Sat, 30 Apr 2011 17:59:25 +0000
Content-Type: text/plain
Mime-Version: 1.0
X-Mailer: email v2.5.0 (Linux 2.6.38 x86_64 [http://email.cleancode.org])
Message-Id: <E1QGERz-0007fX-2a@outmx08.plus.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add LED support for the HTC ASIC3. Underlying support is provided by the mfd/asic3 and leds/leds-asic3 drivers. An example configuration is provided by the pxa/hx4700 platform.

Signed-off-by: Paul Parsons <lost.distance@yahoo.com>
---
diff -uprN clean-2.6.39-rc5/drivers/mfd/asic3.c linux-2.6.39-rc5/drivers/mfd/asic3.c
--- clean-2.6.39-rc5/drivers/mfd/asic3.c	2011-04-28 11:18:15.622582797 +0100
+++ linux-2.6.39-rc5/drivers/mfd/asic3.c	2011-04-30 15:44:30.288890098 +0100
@@ -88,19 +88,19 @@ struct asic3 {
 
 static int asic3_gpio_get(struct gpio_chip *chip, unsigned offset);
 
-static inline void asic3_write_register(struct asic3 *asic,
-				 unsigned int reg, u32 value)
+void asic3_write_register(struct asic3 *asic, unsigned int reg, u32 value)
 {
 	iowrite16(value, asic->mapping +
 		  (reg >> asic->bus_shift));
 }
+EXPORT_SYMBOL_GPL(asic3_write_register);
 
-static inline u32 asic3_read_register(struct asic3 *asic,
-			       unsigned int reg)
+u32 asic3_read_register(struct asic3 *asic, unsigned int reg)
 {
 	return ioread16(asic->mapping +
 			(reg >> asic->bus_shift));
 }
+EXPORT_SYMBOL_GPL(asic3_read_register);
 
 static void asic3_set_register(struct asic3 *asic, u32 reg, u32 bits, bool set)
 {
@@ -584,7 +584,7 @@ static int asic3_gpio_remove(struct plat
 	return gpiochip_remove(&asic->gpio);
 }
 
-static int asic3_clk_enable(struct asic3 *asic, struct asic3_clk *clk)
+static void asic3_clk_enable(struct asic3 *asic, struct asic3_clk *clk)
 {
 	unsigned long flags;
 	u32 cdex;
@@ -596,8 +596,6 @@ static int asic3_clk_enable(struct asic3
 		asic3_write_register(asic, ASIC3_OFFSET(CLOCK, CDEX), cdex);
 	}
 	spin_unlock_irqrestore(&asic->lock, flags);
-
-	return 0;
 }
 
 static void asic3_clk_disable(struct asic3 *asic, struct asic3_clk *clk)
@@ -782,7 +780,55 @@ static struct mfd_cell asic3_cell_mmc = 
 	.resources     = asic3_mmc_resources,
 };
 
+static const int clock_ledn[ASIC3_NUM_LEDS] = {
+	[0] = ASIC3_CLOCK_LED0,
+	[1] = ASIC3_CLOCK_LED1,
+	[2] = ASIC3_CLOCK_LED2,
+};
+
+static int asic3_leds_enable(struct platform_device *pdev)
+{
+	const struct mfd_cell *cell = mfd_get_cell(pdev);
+	struct asic3 *asic = dev_get_drvdata(pdev->dev.parent);
+
+	asic3_clk_enable(asic, &asic->clocks[clock_ledn[cell->id]]);
+
+	return 0;
+}
+
+static int asic3_leds_disable(struct platform_device *pdev)
+{
+	const struct mfd_cell *cell = mfd_get_cell(pdev);
+	struct asic3 *asic = dev_get_drvdata(pdev->dev.parent);
+
+	asic3_clk_disable(asic, &asic->clocks[clock_ledn[cell->id]]);
+
+	return 0;
+}
+
+static struct mfd_cell asic3_cell_leds[ASIC3_NUM_LEDS] = {
+	[0] = {
+		.name          = "leds-asic3",
+		.id            = 0,
+		.enable        = asic3_leds_enable,
+		.disable       = asic3_leds_disable,
+	},
+	[1] = {
+		.name          = "leds-asic3",
+		.id            = 1,
+		.enable        = asic3_leds_enable,
+		.disable       = asic3_leds_disable,
+	},
+	[2] = {
+		.name          = "leds-asic3",
+		.id            = 2,
+		.enable        = asic3_leds_enable,
+		.disable       = asic3_leds_disable,
+	},
+};
+
 static int __init asic3_mfd_probe(struct platform_device *pdev,
+				  struct asic3_platform_data *pdata,
 				  struct resource *mem)
 {
 	struct asic3 *asic = platform_get_drvdata(pdev);
@@ -820,9 +866,20 @@ static int __init asic3_mfd_probe(struct
 	if (ret < 0)
 		goto out;
 
-	if (mem_sdio && (irq >= 0))
+	if (mem_sdio && (irq >= 0)) {
 		ret = mfd_add_devices(&pdev->dev, pdev->id,
 			&asic3_cell_mmc, 1, mem_sdio, irq);
+		if (ret < 0)
+			goto out;
+	}
+
+	if (pdata->leds) {
+		asic3_cell_leds[0].mfd_data = &pdata->leds[0];
+		asic3_cell_leds[1].mfd_data = &pdata->leds[1];
+		asic3_cell_leds[2].mfd_data = &pdata->leds[2];
+		ret = mfd_add_devices(&pdev->dev, 0,
+			asic3_cell_leds, ASIC3_NUM_LEDS, NULL, 0);
+	}
 
  out:
 	return ret;
@@ -883,6 +940,7 @@ static int __init asic3_probe(struct pla
 		goto out_unmap;
 	}
 
+	asic->gpio.label = "asic3";
 	asic->gpio.base = pdata->gpio_base;
 	asic->gpio.ngpio = ASIC3_NUM_GPIOS;
 	asic->gpio.get = asic3_gpio_get;
@@ -903,7 +961,7 @@ static int __init asic3_probe(struct pla
 	 */
 	memcpy(asic->clocks, asic3_clk_init, sizeof(asic3_clk_init));
 
-	asic3_mfd_probe(pdev, mem);
+	asic3_mfd_probe(pdev, pdata, mem);
 
 	dev_info(asic->dev, "ASIC3 Core driver\n");
 
diff -uprN clean-2.6.39-rc5/include/linux/mfd/asic3.h linux-2.6.39-rc5/include/linux/mfd/asic3.h
--- clean-2.6.39-rc5/include/linux/mfd/asic3.h	2011-03-15 01:20:32.000000000 +0000
+++ linux-2.6.39-rc5/include/linux/mfd/asic3.h	2011-04-30 16:06:11.893286349 +0100
@@ -16,6 +16,13 @@
 
 #include <linux/types.h>
 
+struct led_classdev;
+struct asic3_led {
+	const char	*name;
+	const char	*default_trigger;
+	struct led_classdev *cdev;
+};
+
 struct asic3_platform_data {
 	u16 *gpio_config;
 	unsigned int gpio_config_num;
@@ -23,6 +30,8 @@ struct asic3_platform_data {
 	unsigned int irq_base;
 
 	unsigned int gpio_base;
+
+	struct asic3_led *leds;
 };
 
 #define ASIC3_NUM_GPIO_BANKS	4
@@ -111,9 +120,9 @@ struct asic3_platform_data {
 #define ASIC3_GPIOA11_PWM0		ASIC3_CONFIG_GPIO(11, 1, 1, 0)
 #define ASIC3_GPIOA12_PWM1		ASIC3_CONFIG_GPIO(12, 1, 1, 0)
 #define ASIC3_GPIOA15_CONTROL_CX	ASIC3_CONFIG_GPIO(15, 1, 1, 0)
-#define ASIC3_GPIOC0_LED0		ASIC3_CONFIG_GPIO(32, 1, 1, 0)
-#define ASIC3_GPIOC1_LED1		ASIC3_CONFIG_GPIO(33, 1, 1, 0)
-#define ASIC3_GPIOC2_LED2		ASIC3_CONFIG_GPIO(34, 1, 1, 0)
+#define ASIC3_GPIOC0_LED0		ASIC3_CONFIG_GPIO(32, 1, 0, 0)
+#define ASIC3_GPIOC1_LED1		ASIC3_CONFIG_GPIO(33, 1, 0, 0)
+#define ASIC3_GPIOC2_LED2		ASIC3_CONFIG_GPIO(34, 1, 0, 0)
 #define ASIC3_GPIOC3_SPI_RXD		ASIC3_CONFIG_GPIO(35, 1, 0, 0)
 #define ASIC3_GPIOC4_CF_nCD		ASIC3_CONFIG_GPIO(36, 1, 0, 0)
 #define ASIC3_GPIOC4_SPI_TXD		ASIC3_CONFIG_GPIO(36, 1, 1, 0)
@@ -152,6 +161,7 @@ struct asic3_platform_data {
 #define PWM_TIMEBASE_VALUE(x)    ((x)&0xf)   /* Low 4 bits sets time base */
 #define PWM_TIMEBASE_ENABLE     (1 << 4)   /* Enable clock */
 
+#define ASIC3_NUM_LEDS                  3
 #define ASIC3_LED_0_Base                0x0700
 #define ASIC3_LED_1_Base                0x0800
 #define ASIC3_LED_2_Base 		      0x0900
@@ -293,4 +303,10 @@ struct asic3_platform_data {
 #define ASIC3_MAP_SIZE_32BIT	0x2000
 #define ASIC3_MAP_SIZE_16BIT	0x1000
 
+/* Functions needed by leds-asic3 */
+
+struct asic3;
+extern void asic3_write_register(struct asic3 *asic, unsigned int reg, u32 val);
+extern u32 asic3_read_register(struct asic3 *asic, unsigned int reg);
+
 #endif /* __ASIC3_H__ */

