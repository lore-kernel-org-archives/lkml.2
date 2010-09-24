Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758112Ab0IXUPQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 16:15:16 -0400
Received: from mail.logicpd.com ([66.162.60.3]:11017 "EHLO smtp.logicpd.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757165Ab0IXUOK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 16:14:10 -0400
X-Greylist: delayed 911 seconds by postgrey-1.27 at vger.kernel.org; Fri, 24 Sep 2010 16:14:09 EDT
From: Tim Nordell <tim.nordell@logicpd.com>
To: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Tim Nordell <tim.nordell@logicpd.com>
Subject: [PATCH v3 2/5] ARM: OMAP3LOGIC: Adding SDMMC support
Date: Fri, 24 Sep 2010 14:58:55 -0500
Message-Id: <1285358338-3403-3-git-send-email-tim.nordell@logicpd.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1285358338-3403-1-git-send-email-tim.nordell@logicpd.com>
References: <1285358338-3403-1-git-send-email-tim.nordell@logicpd.com>
X-OriginalArrivalTime: 24 Sep 2010 19:58:57.0354 (UTC) FILETIME=[EC509AA0:01CB5C22]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add low-level initialization for hsmmc controller for
LogicPD's OMAP 3530 LV SOM and OMAP 35x Torpedo board.

Signed-off-by: Tim Nordell <tim.nordell@logicpd.com>
---
 arch/arm/mach-omap2/board-omap3logic.c |   38 +++++++++++++++++++++++++++++++-
 1 files changed, 37 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-omap2/board-omap3logic.c b/arch/arm/mach-omap2/board-omap3logic.c
index 72769f7..ec6d6f1 100644
--- a/arch/arm/mach-omap2/board-omap3logic.c
+++ b/arch/arm/mach-omap2/board-omap3logic.c
@@ -33,6 +33,7 @@
 #include <asm/mach/map.h>
 
 #include "mux.h"
+#include "hsmmc.h"
 
 #include <plat/mux.h>
 #include <plat/board.h>
@@ -87,6 +88,7 @@ static struct twl4030_platform_data omap3logic_twldata = {
 
 	/* platform_data for children goes here */
 	.gpio		= &omap3logic_gpio_data,
+	.vmmc1		= &omap3logic_vmmc1,
 };
 
 static struct i2c_board_info __initdata omap3logic_i2c_boardinfo[] = {
@@ -105,6 +107,40 @@ static int __init omap3logic_i2c_init(void)
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
+	if (machine_is_omap3530_lv_som()) {
+		/* OMAP3530 LV SOM board */
+		board_mmc_info[0].gpio_cd = OMAP3530_LV_SOM_MMC_GPIO_CD;
+		board_mmc_info[0].gpio_wp = OMAP3530_LV_SOM_MMC_GPIO_WP;
+		omap_mux_init_signal("gpio_110", OMAP_PIN_OUTPUT);
+		omap_mux_init_signal("gpio_126", OMAP_PIN_OUTPUT);
+	} else if (machine_is_omap3_torpedo()) {
+		/* OMAP3 Torpedo board */
+		board_mmc_info[0].gpio_cd = OMAP3_TORPEDO_MMC_GPIO_CD;
+		omap_mux_init_signal("gpio_127", OMAP_PIN_OUTPUT);
+	} else {
+		/* unsupported board */
+		printk(KERN_ERR "%s(): unknown machine type\n", __func__);
+		return;
+	}
+
+	omap2_hsmmc_init(board_mmc_info);
+	/* link regulators to MMC adapters */
+	omap3logic_vmmc1_supply.dev = board_mmc_info[0].dev;
+}
+
 static void __init omap3logic_init_irq(void)
 {
 	omap2_init_common_hw(NULL, NULL);
@@ -116,7 +152,7 @@ static void __init omap3logic_init(void)
 {
 	omap3logic_i2c_init();
 	omap_serial_init();
-
+	board_mmc_init();
 	/* Ensure SDRC pins are mux'd for self-refresh */
 	omap_mux_init_signal("sdrc_cke0", OMAP_PIN_OUTPUT);
 	omap_mux_init_signal("sdrc_cke1", OMAP_PIN_OUTPUT);
-- 
1.7.1

