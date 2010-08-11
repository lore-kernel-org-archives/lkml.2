Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754805Ab0HKQqY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 12:46:24 -0400
Received: from mail.logicpd.com ([66.162.60.3]:43783 "EHLO smtp.logicpd.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754612Ab0HKQqX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 12:46:23 -0400
X-Greylist: delayed 850 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 Aug 2010 12:46:22 EDT
From: Jacob Tanenbaum <Jacob.Tanenbaum@logicpd.com>
To: linux@arm.linux.org.uk
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        rmk@arm.linux.org.uk, tony@atomide.com,
        Jacob Tanenbaum <Jacob.Tanenbaum@logicpd.com>
Subject: [PATCH 2/4]  Low-level initialization for hsmmc controller on LogicPD's OMAP3 SOM and TORPEDO dev kits
Date: Wed, 11 Aug 2010 12:31:35 -0400
Message-Id: <1281544297-18015-2-git-send-email-Jacob.Tanenbaum@logicpd.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1281544297-18015-1-git-send-email-Jacob.Tanenbaum@logicpd.com>
References: <1281544297-18015-1-git-send-email-Jacob.Tanenbaum@logicpd.com>
X-OriginalArrivalTime: 11 Aug 2010 16:32:11.0699 (UTC) FILETIME=[BFCAE030:01CB3972]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

    	ARM: OMAP3LOGIC: Adding SDMMC support
             Add low-level initialization for hsmmc controller for
             LogicPD's OMAP 3530 LV SOM and OMAP 35x Torpedo board.

        Tested against: linux-next 81e09f50c93edff607259cbe374a3006c9c5fa74
	Signed-off-by: Jacob Tanenbaum <Jacob.Tanenbaum@logicpd.com>
---
 arch/arm/mach-omap2/board-omap3logic.c |   73 +++++++++++++++++++++++++++++--
 1 files changed, 68 insertions(+), 5 deletions(-)

diff --git a/arch/arm/mach-omap2/board-omap3logic.c b/arch/arm/mach-omap2/board-omap3logic.c
index b449f9e..3358418 100644
--- a/arch/arm/mach-omap2/board-omap3logic.c
+++ b/arch/arm/mach-omap2/board-omap3logic.c
@@ -33,6 +33,7 @@
 #include <asm/mach/map.h>
 
 #include "mux.h"
+#include "hsmmc.h"
 
 #include <plat/mux.h>
 #include <plat/board.h>
@@ -41,6 +42,11 @@
 #include <plat/timer-gp.h>
 #include <plat/sdrc.h>
 
+#define OMAP3530_LV_SOM_MMC_GPIO_CD             110
+#define OMAP3530_LV_SOM_MMC_GPIO_WP             126
+#define OMAP3_TORPEDO_MMC_GPIO_CD               127
+#define OMAP3_TORPEDO_MMC_GPIO_WP               (-EINVAL)
+
 /* Micron MT46H32M32LF-6 */
 /* FIXME: borrowed from sdram-micron-mt46h32m32lf-6.h because on LogicPD
  * boards we can't use the default values -- why? I suspect the reason
@@ -81,6 +87,28 @@ static struct omap_sdrc_params mt46h32m32lf6_sdrc_params[] = {
 	},
 };
 
+static struct regulator_consumer_supply omap3logic_vmmc1_supply = {
+		.supply			= "vmmc",
+};
+
+/* VMMC1 for MMC1 pins CMD, CLK, DAT0..DAT3 (20 mA, plus card == max 220 mA) */
+static struct regulator_init_data omap3logic_vmmc1 = {
+	.constraints = {
+		.name			= "VMMC1",
+		.min_uV			= 1850000,
+		.max_uV			= 3150000,
+		.valid_modes_mask	= REGULATOR_MODE_NORMAL
+					| REGULATOR_MODE_STANDBY,
+		.valid_ops_mask		= REGULATOR_CHANGE_VOLTAGE
+					| REGULATOR_CHANGE_MODE
+					| REGULATOR_CHANGE_STATUS,
+	},
+	.num_consumer_supplies  = 1,
+	.consumer_supplies      = &omap3logic_vmmc1_supply,
+};
+
+
+
 static int omap3logic_twl_gpio_setup(struct device *dev,
 				unsigned gpio, unsigned ngpio)
 {
@@ -104,6 +132,7 @@ static struct twl4030_platform_data omap3logic_twldata = {
 
 	/* platform_data for children goes here */
 	.gpio		= &omap3logic_gpio_data,
+	.vmmc1		= &omap3logic_vmmc1,
 };
 
 static struct i2c_board_info __initdata omap3logic_i2c_boardinfo[] = {
@@ -125,6 +154,44 @@ static int __init omap3logic_i2c_init(void)
 static struct omap_board_config_kernel omap3logic_config[] __initdata = {
 };
 
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
+
+
 static void __init omap3logic_init_irq(void)
 {
 	omap_board_config = omap3logic_config;
@@ -144,12 +211,8 @@ static void __init omap3logic_init(void)
 {
 	omap3logic_i2c_init();
 	omap_serial_init();
-
+	board_mmc_init();
 	/* Ensure SDRC pins are mux'd for self-refresh */
-/*	omap_cfg_reg(H16_34XX_SDRC_CKE0);
-	omap_cfg_reg(H17_34XX_SDRC_CKE1);
-	omap_cfg_reg(SDRC_CKE0);
-	omap_cfg_reg(SDRC_CKE1); */
 	omap_mux_init_signal("sdrc_cke0", OMAP_PIN_OUTPUT);
 	omap_mux_init_signal("sdrc_cke1", OMAP_PIN_OUTPUT);
 }
-- 
1.6.0.4

