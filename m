Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758632Ab1EMSxK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 14:53:10 -0400
Received: from relay.ptn-ipout02.plus.net ([212.159.7.36]:15242 "EHLO
	relay.ptn-ipout02.plus.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757347Ab1EMSxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 14:53:07 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjMWAMt8zU3Unw4T/2dsb2JhbACCNIJkkj6OMne1HAKHIIkdDoYHBJQ1hByGJw
Subject: [PATCH v4 2/2] mfd: Add ASIC3 LED support
From: "Paul Parsons" <lost.distance@yahoo.com>
To: <linux-kernel@vger.kernel.org>
Cc: <sameo@linux.intel.com>, <philipp.zabel@gmail.com>
Date: Fri, 13 May 2011 18:53:03 +0000
Content-Type: text/plain
Mime-Version: 1.0
X-Mailer: email v2.5.0 (Linux 2.6.38 x86_64 [http://email.cleancode.org])
Message-Id: <E1QKxU0-0007P3-Cj@outmx04.plus.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add LED support for the HTC ASIC3. Underlying support is provided by the mfd/asic3 and leds/leds-asic3 drivers. An example configuration is provided by the pxa/hx4700 platform.

Signed-off-by: Paul Parsons <lost.distance@yahoo.com>
---
Identical to v3 but submitted as 2 separate patches as requested: one for the LED driver and the asic3.h changes and a second one for the asic3.c changes.
diff -uprN clean-2.6.39-rc7/drivers/mfd/asic3.c linux-2.6.39-rc7/drivers/mfd/asic3.c
--- clean-2.6.39-rc7/drivers/mfd/asic3.c	2011-05-11 00:54:17.415288366 +0100
+++ linux-2.6.39-rc7/drivers/mfd/asic3.c	2011-05-13 19:38:51.178956499 +0100
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
@@ -782,7 +782,55 @@ static struct mfd_cell asic3_cell_mmc =
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
@@ -820,9 +868,23 @@ static int __init asic3_mfd_probe(struct
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
+		int i;
+
+		for (i = 0; i < ASIC3_NUM_LEDS; ++i) {
+			asic3_cell_leds[i].platform_data = &pdata->leds[i];
+			asic3_cell_leds[i].pdata_size = sizeof(pdata->leds[i]);
+		}
+		ret = mfd_add_devices(&pdev->dev, 0,
+			asic3_cell_leds, ASIC3_NUM_LEDS, NULL, 0);
+	}
 
  out:
 	return ret;
@@ -903,7 +965,7 @@ static int __init asic3_probe(struct pla
 	 */
 	memcpy(asic->clocks, asic3_clk_init, sizeof(asic3_clk_init));
 
-	asic3_mfd_probe(pdev, mem);
+	asic3_mfd_probe(pdev, pdata, mem);
 
 	dev_info(asic->dev, "ASIC3 Core driver\n");
 

