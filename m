Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932707Ab0FBSJ6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 14:09:58 -0400
Received: from mail.logicpd.com ([66.162.60.3]:24358 "EHLO smtp.logicpd.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932486Ab0FBSJ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 14:09:57 -0400
X-Greylist: delayed 909 seconds by postgrey-1.27 at vger.kernel.org; Wed, 02 Jun 2010 14:09:56 EDT
From: Jacob Tanenbaum <Jacob.Tanenbaum@logicpd.com>
To: linux@arm.linux.org.uk
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       Jacob Tanenbaum <Jacob.Tanenbaum@logicpd.com>
Subject: [PATCH 2/2] Adding low-level init for hsmmc controller for OMAP 3540LV SOM and OMAP 35x Torpedo
Date: Wed,  2 Jun 2010 13:54:44 -0400
Message-Id: <1275501284-17160-2-git-send-email-Jacob.Tanenbaum@logicpd.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1275501284-17160-1-git-send-email-Jacob.Tanenbaum@logicpd.com>
References: <1275501284-17160-1-git-send-email-Jacob.Tanenbaum@logicpd.com>
X-OriginalArrivalTime: 02 Jun 2010 17:54:46.0791 (UTC) FILETIME=[B0576970:01CB027C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

                ARM: OMAP3LOGIC: Adding SDMMC support

                Add low-level initialization for hsmmc controller for
                LogicPD's OMAP 3530 LV SOM and OMAP 35x Torpedo board.

                Signed-off-by: Jacob Tanenbaum <Jacob.Tanenbaum@logicpd.com>
---
 arch/arm/mach-omap2/board-omap3logic.c |   69 +++++++++++++++++++++++++++++++-
 1 files changed, 68 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-omap2/board-omap3logic.c b/arch/arm/mach-omap2/board-omap3logic.c
index fe5db85..13e0b16 100644
--- a/arch/arm/mach-omap2/board-omap3logic.c
+++ b/arch/arm/mach-omap2/board-omap3logic.c
@@ -33,13 +33,18 @@
 #include <asm/mach/map.h>
 
 #include "mux.h"
-
+#include "hsmmc.h"
 #include <plat/mux.h>
 #include <plat/board.h>
 #include <plat/common.h>
 #include <plat/gpmc.h>
 #include <plat/timer-gp.h>
 
+#define OMAP3530_LV_SOM_MMC_GPIO_CD             110
+#define OMAP3530_LV_SOM_MMC_GPIO_WP             126
+#define OMAP3_TORPEDO_MMC_GPIO_CD               127
+#define OMAP3_TORPEDO_MMC_GPIO_WP               (-EINVAL)
+
 /* Micron MT46H32M32LF-6 */
 /* FIXME: borrowed from sdram-micron-mt46h32m32lf-6.h because on LogicPD
  * boards we can't use the default values -- why? I suspect the reason
@@ -80,6 +85,28 @@ static struct omap_sdrc_params mt46h32m32lf6_sdrc_params[] = {
 	},
 };
 
+
+static struct regulator_consumer_supply omap3logic_vmmc1_supply = {
+	.supply         = "vmmc",
+};
+
+/* VMMC1 for MMC1 pins CMD, CLK, DAT0..DAT3 (20 mA, plus card == max 220 mA) */
+static struct regulator_init_data omap3logic_vmmc1 = {
+	.constraints = {
+		.name                   = "VMMC1",
+		.min_uV                 = 1850000,
+		.max_uV                 = 3150000,
+		.valid_modes_mask       = REGULATOR_MODE_NORMAL
+					| REGULATOR_MODE_STANDBY,
+		.valid_ops_mask         = REGULATOR_CHANGE_VOLTAGE
+					| REGULATOR_CHANGE_MODE
+					| REGULATOR_CHANGE_STATUS,
+	},
+	.num_consumer_supplies  = 1,
+	.consumer_supplies      = &omap3logic_vmmc1_supply,
+};
+
+
 static int omap3logic_twl_gpio_setup(struct device *dev,
 				unsigned gpio, unsigned ngpio)
 {
@@ -121,6 +148,44 @@ static int __init omap3logic_i2c_init(void)
 	return 0;
 }
 
+
+static struct omap2_hsmmc_info __initdata board_mmc_info[] = {
+	{
+		.name           = "external",
+		.mmc            = 1,
+		.wires          = 4,
+		.gpio_cd        = -EINVAL,
+		.gpio_wp        = -EINVAL,
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
 static struct omap_board_config_kernel omap3logic_config[] __initdata = {
 };
 
@@ -164,6 +229,7 @@ static void __init omap3logic_map_io(void)
 
 MACHINE_START(OMAP3_TORPEDO, "Logic OMAP3 Torpedo board")
 	/* Maintainer: Peter Barada <peterb@logicpd.com> */
+
 	.phys_io	= 0x48000000,
 	.io_pg_offst	= ((0xd8000000) >> 18) & 0xfffc,
 	.boot_params	= 0x80000100,
@@ -175,6 +241,7 @@ MACHINE_END
 
 MACHINE_START(OMAP3530_LV_SOM, "OMAP Logic 3530 LV SOM board")
 	/* Maintainer: Peter Barada <peterb@logicpd.com> */
+
 	.phys_io	= 0x48000000,
 	.io_pg_offst	= ((0xd8000000) >> 18) & 0xfffc,
 	.boot_params	= 0x80000100,
-- 
1.6.0.4

