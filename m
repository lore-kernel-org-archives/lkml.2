Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752496Ab1LKUQb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Dec 2011 15:16:31 -0500
Received: from d1.icnet.pl ([212.160.220.21]:48542 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752312Ab1LKUQ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Dec 2011 15:16:27 -0500
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
To: Tony Lindgren <tony@atomide.com>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
        linux-mtd@lists.infradead.org
Subject: [PATCH 05/10] MTD: NAND: ams-delta: Use GPIO instead of custom I/O
Date: Sun, 11 Dec 2011 21:12:03 +0100
Message-Id: <1323634328-856-6-git-send-email-jkrzyszt@tis.icnet.pl>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1323634328-856-1-git-send-email-jkrzyszt@tis.icnet.pl>
References: <1323634328-856-1-git-send-email-jkrzyszt@tis.icnet.pl>
To: David Woodhouse <dwmw2@infradead.org>
X-SA-Exim-Scanned: No (on d1.icnet); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't use Amstrad Delta custom I/O functions for controlling the device,
use GPIO API instead.

While being at it, add missing gpio_free(AMS_DELTA_GPIO_PIN_NAND_RB).

Depends on patch 2/10 "ARM: OMAP1: Convert Amstrad E3 latches to
basic_mmio_gpio".

Signed-off-by: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
---
Hi,
I considered dropping the Amstrad Delta NAND driver and moving to either
gpio-nand or gen_nand, but finally decided to keep it for now.

The problem with the gpio-nand is that it seems to match a different
hardware interface model. Having no knowledge about the original
hardware that driver was designed in mind, I'd rather not try to
modify it, and creating another GPIO based NAND driver also seems not
a really good idea.

If I decided to use gen_nand instead, I would have to move virtually all
of the old driver callback functions somewhere under arch, either to the
board file or to a new one, and still use some hacks unless either
nand_base.c or plat_nand.c is modified.

I'm willing to take one of those two approaches in a follow up series if
I get a positive feedback.

Thanks,
Janusz


 arch/arm/mach-omap1/board-ams-delta.c             |   30 --------
 arch/arm/plat-omap/include/plat/board-ams-delta.h |    6 --
 drivers/mtd/nand/ams-delta.c                      |   74 ++++++++++++++------
 3 files changed, 52 insertions(+), 58 deletions(-)

diff --git a/arch/arm/mach-omap1/board-ams-delta.c b/arch/arm/mach-omap1/board-ams-delta.c
index bdf7399..7670374 100644
--- a/arch/arm/mach-omap1/board-ams-delta.c
+++ b/arch/arm/mach-omap1/board-ams-delta.c
@@ -242,36 +242,6 @@ static struct gpio _latch_gpios[] __initconst = {
 		.label	= "lcd_ndisp",
 	},
 	{
-		.gpio	= AMS_DELTA_GPIO_PIN_NAND_NCE,
-		.flags	= GPIOF_OUT_INIT_LOW,
-		.label	= "nand_nce",
-	},
-	{
-		.gpio	= AMS_DELTA_GPIO_PIN_NAND_NRE,
-		.flags	= GPIOF_OUT_INIT_LOW,
-		.label	= "nand_nre",
-	},
-	{
-		.gpio	= AMS_DELTA_GPIO_PIN_NAND_NWP,
-		.flags	= GPIOF_OUT_INIT_LOW,
-		.label	= "nand_nwp",
-	},
-	{
-		.gpio	= AMS_DELTA_GPIO_PIN_NAND_NWE,
-		.flags	= GPIOF_OUT_INIT_LOW,
-		.label	= "nand_nwe",
-	},
-	{
-		.gpio	= AMS_DELTA_GPIO_PIN_NAND_ALE,
-		.flags	= GPIOF_OUT_INIT_LOW,
-		.label	= "nand_ale",
-	},
-	{
-		.gpio	= AMS_DELTA_GPIO_PIN_NAND_CLE,
-		.flags	= GPIOF_OUT_INIT_LOW,
-		.label	= "nand_cle",
-	},
-	{
 		.gpio	= AMS_DELTA_GPIO_PIN_KEYBRD_PWR,
 		.flags	= GPIOF_OUT_INIT_LOW,
 		.label	= "keybrd_pwr",
diff --git a/arch/arm/plat-omap/include/plat/board-ams-delta.h b/arch/arm/plat-omap/include/plat/board-ams-delta.h
index c096e14..b586078 100644
--- a/arch/arm/plat-omap/include/plat/board-ams-delta.h
+++ b/arch/arm/plat-omap/include/plat/board-ams-delta.h
@@ -30,12 +30,6 @@
 
 #define AMS_DELTA_LATCH2_LCD_VBLEN	0x0001
 #define AMS_DELTA_LATCH2_LCD_NDISP	0x0002
-#define AMS_DELTA_LATCH2_NAND_NCE	0x0004
-#define AMS_DELTA_LATCH2_NAND_NRE	0x0008
-#define AMS_DELTA_LATCH2_NAND_NWP	0x0010
-#define AMS_DELTA_LATCH2_NAND_NWE	0x0020
-#define AMS_DELTA_LATCH2_NAND_ALE	0x0040
-#define AMS_DELTA_LATCH2_NAND_CLE	0x0080
 #define AMD_DELTA_LATCH2_KEYBRD_PWR	0x0100
 #define AMD_DELTA_LATCH2_KEYBRD_DATA	0x0200
 #define AMD_DELTA_LATCH2_SCARD_RSTIN	0x0400
diff --git a/drivers/mtd/nand/ams-delta.c b/drivers/mtd/nand/ams-delta.c
index 9e6b498..5769bd2 100644
--- a/drivers/mtd/nand/ams-delta.c
+++ b/drivers/mtd/nand/ams-delta.c
@@ -26,7 +26,7 @@
 #include <asm/io.h>
 #include <mach/hardware.h>
 #include <asm/sizes.h>
-#include <asm/gpio.h>
+#include <linux/gpio.h>
 #include <plat/board-ams-delta.h>
 
 /*
@@ -34,8 +34,6 @@
  */
 static struct mtd_info *ams_delta_mtd = NULL;
 
-#define NAND_MASK (AMS_DELTA_LATCH2_NAND_NRE | AMS_DELTA_LATCH2_NAND_NWE | AMS_DELTA_LATCH2_NAND_CLE | AMS_DELTA_LATCH2_NAND_ALE | AMS_DELTA_LATCH2_NAND_NCE | AMS_DELTA_LATCH2_NAND_NWP)
-
 /*
  * Define partitions for flash devices
  */
@@ -68,10 +66,9 @@ static void ams_delta_write_byte(struct mtd_info *mtd, u_char byte)
 
 	writew(0, io_base + OMAP_MPUIO_IO_CNTL);
 	writew(byte, this->IO_ADDR_W);
-	ams_delta_latch2_write(AMS_DELTA_LATCH2_NAND_NWE, 0);
+	gpio_set_value(AMS_DELTA_GPIO_PIN_NAND_NWE, 0);
 	ndelay(40);
-	ams_delta_latch2_write(AMS_DELTA_LATCH2_NAND_NWE,
-			       AMS_DELTA_LATCH2_NAND_NWE);
+	gpio_set_value(AMS_DELTA_GPIO_PIN_NAND_NWE, 1);
 }
 
 static u_char ams_delta_read_byte(struct mtd_info *mtd)
@@ -80,12 +77,11 @@ static u_char ams_delta_read_byte(struct mtd_info *mtd)
 	struct nand_chip *this = mtd->priv;
 	void __iomem *io_base = this->priv;
 
-	ams_delta_latch2_write(AMS_DELTA_LATCH2_NAND_NRE, 0);
+	gpio_set_value(AMS_DELTA_GPIO_PIN_NAND_NRE, 0);
 	ndelay(40);
 	writew(~0, io_base + OMAP_MPUIO_IO_CNTL);
 	res = readw(this->IO_ADDR_R);
-	ams_delta_latch2_write(AMS_DELTA_LATCH2_NAND_NRE,
-			       AMS_DELTA_LATCH2_NAND_NRE);
+	gpio_set_value(AMS_DELTA_GPIO_PIN_NAND_NRE, 1);
 
 	return res;
 }
@@ -132,15 +128,12 @@ static void ams_delta_hwcontrol(struct mtd_info *mtd, int cmd,
 {
 
 	if (ctrl & NAND_CTRL_CHANGE) {
-		unsigned long bits;
-
-		bits = (~ctrl & NAND_NCE) ? AMS_DELTA_LATCH2_NAND_NCE : 0;
-		bits |= (ctrl & NAND_CLE) ? AMS_DELTA_LATCH2_NAND_CLE : 0;
-		bits |= (ctrl & NAND_ALE) ? AMS_DELTA_LATCH2_NAND_ALE : 0;
-
-		ams_delta_latch2_write(AMS_DELTA_LATCH2_NAND_CLE |
-				AMS_DELTA_LATCH2_NAND_ALE |
-				AMS_DELTA_LATCH2_NAND_NCE, bits);
+		gpio_set_value(AMS_DELTA_GPIO_PIN_NAND_NCE,
+				(ctrl & NAND_NCE) == 0);
+		gpio_set_value(AMS_DELTA_GPIO_PIN_NAND_CLE,
+				(ctrl & NAND_CLE) != 0);
+		gpio_set_value(AMS_DELTA_GPIO_PIN_NAND_ALE,
+				(ctrl & NAND_ALE) != 0);
 	}
 
 	if (cmd != NAND_CMD_NONE)
@@ -152,6 +145,39 @@ static int ams_delta_nand_ready(struct mtd_info *mtd)
 	return gpio_get_value(AMS_DELTA_GPIO_PIN_NAND_RB);
 }
 
+static struct gpio _mandatory_gpio[] __initconst_or_module = {
+	{
+		.gpio	= AMS_DELTA_GPIO_PIN_NAND_NCE,
+		.flags	= GPIOF_OUT_INIT_HIGH,
+		.label	= "nand_nce",
+	},
+	{
+		.gpio	= AMS_DELTA_GPIO_PIN_NAND_NRE,
+		.flags	= GPIOF_OUT_INIT_HIGH,
+		.label	= "nand_nre",
+	},
+	{
+		.gpio	= AMS_DELTA_GPIO_PIN_NAND_NWP,
+		.flags	= GPIOF_OUT_INIT_HIGH,
+		.label	= "nand_nwp",
+	},
+	{
+		.gpio	= AMS_DELTA_GPIO_PIN_NAND_NWE,
+		.flags	= GPIOF_OUT_INIT_HIGH,
+		.label	= "nand_nwe",
+	},
+	{
+		.gpio	= AMS_DELTA_GPIO_PIN_NAND_ALE,
+		.flags	= GPIOF_OUT_INIT_LOW,
+		.label	= "nand_ale",
+	},
+	{
+		.gpio	= AMS_DELTA_GPIO_PIN_NAND_CLE,
+		.flags	= GPIOF_OUT_INIT_LOW,
+		.label	= "nand_cle",
+	},
+};
+
 /*
  * Main initialization routine
  */
@@ -223,10 +249,9 @@ static int __devinit ams_delta_init(struct platform_device *pdev)
 	platform_set_drvdata(pdev, io_base);
 
 	/* Set chip enabled, but  */
-	ams_delta_latch2_write(NAND_MASK, AMS_DELTA_LATCH2_NAND_NRE |
-					  AMS_DELTA_LATCH2_NAND_NWE |
-					  AMS_DELTA_LATCH2_NAND_NCE |
-					  AMS_DELTA_LATCH2_NAND_NWP);
+	err = gpio_request_array(_mandatory_gpio, ARRAY_SIZE(_mandatory_gpio));
+	if (err)
+		goto out_gpio;
 
 	/* Scan to find existence of the device */
 	if (nand_scan(ams_delta_mtd, 1)) {
@@ -241,7 +266,10 @@ static int __devinit ams_delta_init(struct platform_device *pdev)
 	goto out;
 
  out_mtd:
+	gpio_free_array(_mandatory_gpio, ARRAY_SIZE(_mandatory_gpio));
+out_gpio:
 	platform_set_drvdata(pdev, NULL);
+	gpio_free(AMS_DELTA_GPIO_PIN_NAND_RB);
 	iounmap(io_base);
 out_release_io:
 	release_mem_region(res->start, resource_size(res));
@@ -262,6 +290,8 @@ static int __devexit ams_delta_cleanup(struct platform_device *pdev)
 	/* Release resources, unregister device */
 	nand_release(ams_delta_mtd);
 
+	gpio_free_array(_mandatory_gpio, ARRAY_SIZE(_mandatory_gpio));
+	gpio_free(AMS_DELTA_GPIO_PIN_NAND_RB);
 	iounmap(io_base);
 	release_mem_region(res->start, resource_size(res));
 
-- 
1.7.3.4

