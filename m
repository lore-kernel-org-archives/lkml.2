Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932278Ab0HYDy7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 23:54:59 -0400
Received: from mail.logicpd.com ([66.162.60.3]:27928 "EHLO smtp.logicpd.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752803Ab0HYDyz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 23:54:55 -0400
From: Jacob Tanenbaum <Jacob.Tanenbaum@logicpd.com>
To: linux@arm.linux.org.uk
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/4]  Low-level init of hsmmc controller for LogicPD's OMAP3530LV SOM and OMAP 35x Torpedo dev boards  
Date: Tue, 24 Aug 2010 23:53:38 -0400
Message-Id: <1282708420-26418-2-git-send-email-Jacob.Tanenbaum@logicpd.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1282708420-26418-1-git-send-email-Jacob.Tanenbaum@logicpd.com>
References: <1282708420-26418-1-git-send-email-Jacob.Tanenbaum@logicpd.com>
X-OriginalArrivalTime: 25 Aug 2010 03:54:52.0842 (UTC) FILETIME=[45E808A0:01CB4409]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: jake <jake@Glados.(none)>

    	ARM: OMAP3LOGIC: Adding SDMMC support
             Add low-level initialization for hsmmc controller for
             LogicPD's OMAP 3530 LV SOM and OMAP 35x Torpedo board.

	Tested against: 81e09f50c93edff607259cbe374a3006c9c5fa74
	Signed-off-by: Jacob Tanenbaum <Jacob.Tanenbaum@logicpd.com>
---
 arch/arm/mach-omap2/board-omap3logic.c |   40 +++++++++++++++++++++++++++++++-
 1 files changed, 39 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-omap2/board-omap3logic.c b/arch/arm/mach-omap2/board-omap3logic.c
index 30af7da..bd83a83 100644
--- a/arch/arm/mach-omap2/board-omap3logic.c
+++ b/arch/arm/mach-omap2/board-omap3logic.c
@@ -33,6 +33,7 @@
 #include <asm/mach/map.h>
 
 #include "mux.h"
+#include "hsmmc.h"
 
 #include <plat/mux.h>
 #include <plat/board.h>
@@ -110,6 +111,7 @@ static struct twl4030_platform_data omap3logic_twldata = {
 
 	/* platform_data for children goes here */
 	.gpio		= &omap3logic_gpio_data,
+	.vmmc1		= &omap3logic_vmmc1,
 };
 
 static struct i2c_board_info __initdata omap3logic_i2c_boardinfo[] = {
@@ -128,6 +130,42 @@ static int __init omap3logic_i2c_init(void)
 	return 0;
 }
 
+static struct omap2_hsmmc_info __initdata board_mmc_info[] = {
+	{
+		.name		= "external",
+		.mmc		= 1,
+		.wires		= 4,
+		.gpio_cd	= -EINVAL,
+		.gpio_wp	= -EINVAL,
+	},
+	{}      /* Terminator */
+};
+
+static void __init board_mmc_init(void)
+{
+	/* OMAP3530 LV SOM board */
+	if (machine_is_omap3530_lv_som()) {
+		board_mmc_info[0].gpio_cd = OMAP3530_LV_SOM_MMC_GPIO_CD;
+		board_mmc_info[0].gpio_wp = OMAP3530_LV_SOM_MMC_GPIO_WP;
+		omap_mux_init_signal("gpio_110", OMAP_PIN_OUTPUT);
+		omap_mux_init_signal("gpio_126", OMAP_PIN_OUTPUT);
+
+
+	/* OMAP3 Torpedo board */
+	} else if (machine_is_omap3_torpedo()) {
+		board_mmc_info[0].gpio_cd = OMAP3_TORPEDO_MMC_GPIO_CD;
+		omap_mux_init_signal("gpio_127", OMAP_PIN_OUTPUT);
+	/* unsupported board */
+	} else {
+		printk(KERN_ERR "%s(): unknown machine type\n", __func__);
+	return;
+	}
+
+	omap2_hsmmc_init(board_mmc_info);
+	/* link regulators to MMC adapters */
+	omap3logic_vmmc1_supply.dev = board_mmc_info[0].dev;
+}
+
 static void __init omap3logic_init_irq(void)
 {
 	init_sdram(mt46h32m32lf6_sdrc_params);
@@ -141,7 +179,7 @@ static void __init omap3logic_init(void)
 {
 	omap3logic_i2c_init();
 	omap_serial_init();
-
+	board_mmc_init();
 	/* Ensure SDRC pins are mux'd for self-refresh */
 	omap_mux_init_signal("sdrc_cke0", OMAP_PIN_OUTPUT);
 	omap_mux_init_signal("sdrc_cke1", OMAP_PIN_OUTPUT);
-- 
1.7.2.1

