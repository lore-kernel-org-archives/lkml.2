Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932193Ab1DFUf4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 16:35:56 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:48292 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932151Ab1DFUfy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 16:35:54 -0400
From: Alexander Holler <holler@ahsoftware.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Nicolas Pitre <nico@fluxnic.net>,
        Eric Cooper <ecc@cmu.edu>, Alexander Holler <holler@ahsoftware.de>
Subject: [PATCH 1/2] ARM: Differentiate SheevaPlugs and DockStars on the basis of the memory size.
Date: Wed,  6 Apr 2011 22:35:20 +0200
Message-Id: <1302122121-3652-2-git-send-email-holler@ahsoftware.de>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1302122121-3652-1-git-send-email-holler@ahsoftware.de>
References: <1302122121-3652-1-git-send-email-holler@ahsoftware.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is possible to differentiate a SheevaPlugs and DockStars on the basis
of the memory size.

This makes it possible to unify both setup files.

Afterwards it is impossible for the userland to detect the exact board
through uname, but we don't care. If necessary the difference could be
still be detected by the memory size (e.g. with free), or through the
available leds in /sys/class/leds.

Signed-off-by: Alexander Holler <holler@ahsoftware.de>
---
 arch/arm/mach-kirkwood/Makefile           |    2 +-
 arch/arm/mach-kirkwood/dockstar-setup.c   |  110 -----------------------------
 arch/arm/mach-kirkwood/sheevaplug-setup.c |   39 ++++++++++
 3 files changed, 40 insertions(+), 111 deletions(-)
 delete mode 100644 arch/arm/mach-kirkwood/dockstar-setup.c

diff --git a/arch/arm/mach-kirkwood/Makefile b/arch/arm/mach-kirkwood/Makefile
index 5dcaa81..f06bc3d 100644
--- a/arch/arm/mach-kirkwood/Makefile
+++ b/arch/arm/mach-kirkwood/Makefile
@@ -7,7 +7,7 @@ obj-$(CONFIG_MACH_MV88F6281GTW_GE)	+= mv88f6281gtw_ge-setup.o
 obj-$(CONFIG_MACH_SHEEVAPLUG)		+= sheevaplug-setup.o
 obj-$(CONFIG_MACH_ESATA_SHEEVAPLUG)	+= sheevaplug-setup.o
 obj-$(CONFIG_MACH_GURUPLUG)		+= guruplug-setup.o
-obj-$(CONFIG_MACH_DOCKSTAR)		+= dockstar-setup.o
+obj-$(CONFIG_MACH_DOCKSTAR)		+= sheevaplug-setup.o
 obj-$(CONFIG_MACH_TS219)		+= ts219-setup.o tsx1x-common.o
 obj-$(CONFIG_MACH_TS41X)		+= ts41x-setup.o tsx1x-common.o
 obj-$(CONFIG_MACH_OPENRD)		+= openrd-setup.o
diff --git a/arch/arm/mach-kirkwood/dockstar-setup.c b/arch/arm/mach-kirkwood/dockstar-setup.c
deleted file mode 100644
index 433ea36..0000000
--- a/arch/arm/mach-kirkwood/dockstar-setup.c
+++ /dev/null
@@ -1,110 +0,0 @@
-/*
- * arch/arm/mach-kirkwood/dockstar-setup.c
- *
- * Seagate FreeAgent DockStar Setup
- *
- * This file is licensed under the terms of the GNU General Public
- * License version 2.  This program is licensed "as is" without any
- * warranty of any kind, whether express or implied.
- */
-
-#include <linux/kernel.h>
-#include <linux/init.h>
-#include <linux/platform_device.h>
-#include <linux/ata_platform.h>
-#include <linux/mtd/partitions.h>
-#include <linux/mv643xx_eth.h>
-#include <linux/gpio.h>
-#include <linux/leds.h>
-#include <asm/mach-types.h>
-#include <asm/mach/arch.h>
-#include <mach/kirkwood.h>
-#include <plat/mvsdio.h>
-#include "common.h"
-#include "mpp.h"
-
-static struct mtd_partition dockstar_nand_parts[] = {
-	{
-		.name = "u-boot",
-		.offset = 0,
-		.size = SZ_1M
-	}, {
-		.name = "uImage",
-		.offset = MTDPART_OFS_NXTBLK,
-		.size = SZ_4M
-	}, {
-		.name = "root",
-		.offset = MTDPART_OFS_NXTBLK,
-		.size = MTDPART_SIZ_FULL
-	},
-};
-
-static struct mv643xx_eth_platform_data dockstar_ge00_data = {
-	.phy_addr	= MV643XX_ETH_PHY_ADDR(0),
-};
-
-static struct gpio_led dockstar_led_pins[] = {
-	{
-		.name			= "dockstar:green:health",
-		.default_trigger	= "default-on",
-		.gpio			= 46,
-		.active_low		= 1,
-	},
-	{
-		.name			= "dockstar:orange:misc",
-		.default_trigger	= "none",
-		.gpio			= 47,
-		.active_low		= 1,
-	},
-};
-
-static struct gpio_led_platform_data dockstar_led_data = {
-	.leds		= dockstar_led_pins,
-	.num_leds	= ARRAY_SIZE(dockstar_led_pins),
-};
-
-static struct platform_device dockstar_leds = {
-	.name	= "leds-gpio",
-	.id	= -1,
-	.dev	= {
-		.platform_data	= &dockstar_led_data,
-	}
-};
-
-static unsigned int dockstar_mpp_config[] __initdata = {
-	MPP29_GPIO,	/* USB Power Enable */
-	MPP46_GPIO,	/* LED green */
-	MPP47_GPIO,	/* LED orange */
-	0
-};
-
-static void __init dockstar_init(void)
-{
-	/*
-	 * Basic setup. Needs to be called early.
-	 */
-	kirkwood_init();
-
-	/* setup gpio pin select */
-	kirkwood_mpp_conf(dockstar_mpp_config);
-
-	kirkwood_uart0_init();
-	kirkwood_nand_init(ARRAY_AND_SIZE(dockstar_nand_parts), 25);
-
-	if (gpio_request(29, "USB Power Enable") != 0 ||
-	    gpio_direction_output(29, 1) != 0)
-		printk(KERN_ERR "can't set up GPIO 29 (USB Power Enable)\n");
-	kirkwood_ehci_init();
-
-	kirkwood_ge00_init(&dockstar_ge00_data);
-
-	platform_device_register(&dockstar_leds);
-}
-
-MACHINE_START(DOCKSTAR, "Seagate FreeAgent DockStar")
-	.boot_params	= 0x00000100,
-	.init_machine	= dockstar_init,
-	.map_io		= kirkwood_map_io,
-	.init_irq	= kirkwood_init_irq,
-	.timer		= &kirkwood_timer,
-MACHINE_END
diff --git a/arch/arm/mach-kirkwood/sheevaplug-setup.c b/arch/arm/mach-kirkwood/sheevaplug-setup.c
index d2eec35..d1593db 100644
--- a/arch/arm/mach-kirkwood/sheevaplug-setup.c
+++ b/arch/arm/mach-kirkwood/sheevaplug-setup.c
@@ -18,6 +18,7 @@
 #include <linux/leds.h>
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
+#include <asm/setup.h>
 #include <mach/kirkwood.h>
 #include <plat/mvsdio.h>
 #include "common.h"
@@ -65,6 +66,21 @@ static struct gpio_led sheevaplug_led_pins[] = {
 	},
 };
 
+static struct gpio_led dockstar_led_pins[] = {
+	{
+		.name			= "dockstar:green:health",
+		.default_trigger	= "default-on",
+		.gpio			= 46,
+		.active_low		= 1,
+	},
+	{
+		.name			= "dockstar:orange:misc",
+		.default_trigger	= "none",
+		.gpio			= 47,
+		.active_low		= 1,
+	},
+};
+
 static struct gpio_led_platform_data sheevaplug_led_data = {
 	.leds		= sheevaplug_led_pins,
 	.num_leds	= ARRAY_SIZE(sheevaplug_led_pins),
@@ -92,6 +108,13 @@ static unsigned int sheeva_esata_mpp_config[] __initdata = {
 	0
 };
 
+static unsigned int dockstar_mpp_config[] __initdata = {
+	MPP29_GPIO,	/* USB Power Enable */
+	MPP46_GPIO,	/* LED green */
+	MPP47_GPIO,	/* LED orange */
+	0
+};
+
 static void __init sheevaplug_init(void)
 {
 	/*
@@ -102,6 +125,12 @@ static void __init sheevaplug_init(void)
 	/* setup gpio pin select */
 	if (machine_is_sheeva_esata())
 		kirkwood_mpp_conf(sheeva_esata_mpp_config);
+	else if ((meminfo.nr_banks == 1) && (meminfo.bank[0].size == SZ_128M)) {
+		pr_info("Assuming machine is a DockStar (memory size is 128MB)\n");
+		kirkwood_mpp_conf(dockstar_mpp_config);
+		sheevaplug_led_data.leds = dockstar_led_pins;
+		sheevaplug_led_data.num_leds = ARRAY_SIZE(dockstar_led_pins);
+	}
 	else
 		kirkwood_mpp_conf(sheevaplug_mpp_config);
 
@@ -148,3 +177,13 @@ MACHINE_START(ESATA_SHEEVAPLUG, "Marvell eSATA SheevaPlug Reference Board")
 	.timer		= &kirkwood_timer,
 MACHINE_END
 #endif
+
+#ifdef CONFIG_MACH_DOCKSTAR
+MACHINE_START(DOCKSTAR, "Seagate FreeAgent DockStar")
+	.boot_params	= 0x00000100,
+	.init_machine	= sheevaplug_init,
+	.map_io		= kirkwood_map_io,
+	.init_irq	= kirkwood_init_irq,
+	.timer		= &kirkwood_timer,
+MACHINE_END
+#endif
-- 
1.7.2.2

