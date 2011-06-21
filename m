Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756831Ab1FUOnQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 10:43:16 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:37738 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752088Ab1FUOjx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 10:39:53 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Liam Girdwood <lrg@ti.com>, Tony Lindgren <tony@atomide.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: linux-input@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        Peter Ujfalusi <peter.ujfalusi@ti.com>
Subject: [PATCH v6 04/18] OMAP3: Move common regulator configuration to twl-common
Date: Tue, 21 Jun 2011 16:39:02 +0300
Message-ID: <1308663556-29120-5-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.5.3
In-Reply-To: <1308663556-29120-1-git-send-email-peter.ujfalusi@ti.com>
References: <1308663556-29120-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some regulator config can be moved out from board files,
since they are close to identical.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 arch/arm/mach-omap2/board-3430sdp.c          |   51 ++++----------------------
 arch/arm/mach-omap2/board-cm-t35.c           |   41 +++------------------
 arch/arm/mach-omap2/board-devkit8000.c       |   21 +----------
 arch/arm/mach-omap2/board-igep0020.c         |   28 +++------------
 arch/arm/mach-omap2/board-omap3beagle.c      |   44 ++--------------------
 arch/arm/mach-omap2/board-omap3evm.c         |   47 +++---------------------
 arch/arm/mach-omap2/board-omap3pandora.c     |   44 ++++------------------
 arch/arm/mach-omap2/board-omap3stalker.c     |   48 +++---------------------
 arch/arm/mach-omap2/board-omap3touchbook.c   |   40 ++++----------------
 arch/arm/mach-omap2/board-overo.c            |   44 ++--------------------
 arch/arm/mach-omap2/board-rx51-peripherals.c |   25 ++-----------
 arch/arm/mach-omap2/board-zoom-peripherals.c |   41 ++-------------------
 arch/arm/mach-omap2/twl-common.c             |   42 +++++++++++++++++++++
 arch/arm/mach-omap2/twl-common.h             |    5 +++
 14 files changed, 109 insertions(+), 412 deletions(-)

diff --git a/arch/arm/mach-omap2/board-3430sdp.c b/arch/arm/mach-omap2/board-3430sdp.c
index 4810dcc..d944a56 100644
--- a/arch/arm/mach-omap2/board-3430sdp.c
+++ b/arch/arm/mach-omap2/board-3430sdp.c
@@ -283,16 +283,6 @@ static struct regulator_consumer_supply sdp3430_vaux3_supplies[] = {
 	REGULATOR_SUPPLY("vcc", "spi1.0"),
 };
 
-static struct regulator_consumer_supply sdp3430_vdda_dac_supplies[] = {
-	REGULATOR_SUPPLY("vdda_dac", "omapdss_venc"),
-};
-
-/* VPLL2 for digital video outputs */
-static struct regulator_consumer_supply sdp3430_vpll2_supplies[] = {
-	REGULATOR_SUPPLY("vdds_dsi", "omapdss"),
-	REGULATOR_SUPPLY("vdds_dsi", "omapdss_dsi1"),
-};
-
 static struct regulator_consumer_supply sdp3430_vmmc1_supplies[] = {
 	REGULATOR_SUPPLY("vmmc", "omap_hsmmc.0"),
 };
@@ -409,36 +399,6 @@ static struct regulator_init_data sdp3430_vsim = {
 	.consumer_supplies	= sdp3430_vsim_supplies,
 };
 
-/* VDAC for DSS driving S-Video */
-static struct regulator_init_data sdp3430_vdac = {
-	.constraints = {
-		.min_uV			= 1800000,
-		.max_uV			= 1800000,
-		.apply_uV		= true,
-		.valid_modes_mask	= REGULATOR_MODE_NORMAL
-					| REGULATOR_MODE_STANDBY,
-		.valid_ops_mask		= REGULATOR_CHANGE_MODE
-					| REGULATOR_CHANGE_STATUS,
-	},
-	.num_consumer_supplies	= ARRAY_SIZE(sdp3430_vdda_dac_supplies),
-	.consumer_supplies	= sdp3430_vdda_dac_supplies,
-};
-
-static struct regulator_init_data sdp3430_vpll2 = {
-	.constraints = {
-		.name			= "VDVI",
-		.min_uV			= 1800000,
-		.max_uV			= 1800000,
-		.apply_uV		= true,
-		.valid_modes_mask	= REGULATOR_MODE_NORMAL
-					| REGULATOR_MODE_STANDBY,
-		.valid_ops_mask		= REGULATOR_CHANGE_MODE
-					| REGULATOR_CHANGE_STATUS,
-	},
-	.num_consumer_supplies	= ARRAY_SIZE(sdp3430_vpll2_supplies),
-	.consumer_supplies	= sdp3430_vpll2_supplies,
-};
-
 static struct twl4030_platform_data sdp3430_twldata = {
 	/* platform_data for children goes here */
 	.gpio		= &sdp3430_gpio_data,
@@ -451,16 +411,19 @@ static struct twl4030_platform_data sdp3430_twldata = {
 	.vmmc1		= &sdp3430_vmmc1,
 	.vmmc2		= &sdp3430_vmmc2,
 	.vsim		= &sdp3430_vsim,
-	.vdac		= &sdp3430_vdac,
-	.vpll2		= &sdp3430_vpll2,
 };
 
 static int __init omap3430_i2c_init(void)
 {
 	/* i2c1 for PMIC only */
 	omap3_pmic_get_config(&sdp3430_twldata,
-			  TWL_COMMON_PDATA_USB | TWL_COMMON_PDATA_BCI |
-			  TWL_COMMON_PDATA_MADC | TWL_COMMON_PDATA_AUDIO, 0);
+			TWL_COMMON_PDATA_USB | TWL_COMMON_PDATA_BCI |
+			TWL_COMMON_PDATA_MADC | TWL_COMMON_PDATA_AUDIO,
+			TWL_COMMON_REGULATOR_VDAC | TWL_COMMON_REGULATOR_VPLL2);
+	sdp3430_twldata.vdac->constraints.apply_uV = true;
+	sdp3430_twldata.vpll2->constraints.apply_uV = true;
+	sdp3430_twldata.vpll2->constraints.name = "VDVI";
+
 	omap3_pmic_init("twl4030", &sdp3430_twldata);
 
 	/* i2c2 on camera connector (for sensor control) and optional isp1301 */
diff --git a/arch/arm/mach-omap2/board-cm-t35.c b/arch/arm/mach-omap2/board-cm-t35.c
index e867474..2ae6afe 100644
--- a/arch/arm/mach-omap2/board-cm-t35.c
+++ b/arch/arm/mach-omap2/board-cm-t35.c
@@ -345,9 +345,6 @@ static struct regulator_consumer_supply cm_t35_vsim_supply = {
 	.supply			= "vmmc_aux",
 };
 
-static struct regulator_consumer_supply cm_t35_vdac_supply =
-	REGULATOR_SUPPLY("vdda_dac", "omapdss_venc");
-
 static struct regulator_consumer_supply cm_t35_vdvi_supply =
 	REGULATOR_SUPPLY("vdvi", "omapdss");
 
@@ -381,35 +378,6 @@ static struct regulator_init_data cm_t35_vsim = {
 	.consumer_supplies	= &cm_t35_vsim_supply,
 };
 
-/* VDAC for DSS driving S-Video (8 mA unloaded, max 65 mA) */
-static struct regulator_init_data cm_t35_vdac = {
-	.constraints = {
-		.min_uV			= 1800000,
-		.max_uV			= 1800000,
-		.valid_modes_mask	= REGULATOR_MODE_NORMAL
-					| REGULATOR_MODE_STANDBY,
-		.valid_ops_mask		= REGULATOR_CHANGE_MODE
-					| REGULATOR_CHANGE_STATUS,
-	},
-	.num_consumer_supplies	= 1,
-	.consumer_supplies	= &cm_t35_vdac_supply,
-};
-
-/* VPLL2 for digital video outputs */
-static struct regulator_init_data cm_t35_vpll2 = {
-	.constraints = {
-		.name			= "VDVI",
-		.min_uV			= 1800000,
-		.max_uV			= 1800000,
-		.valid_modes_mask	= REGULATOR_MODE_NORMAL
-					| REGULATOR_MODE_STANDBY,
-		.valid_ops_mask		= REGULATOR_CHANGE_MODE
-					| REGULATOR_CHANGE_STATUS,
-	},
-	.num_consumer_supplies	= 1,
-	.consumer_supplies	= &cm_t35_vdvi_supply,
-};
-
 static uint32_t cm_t35_keymap[] = {
 	KEY(0, 0, KEY_A),	KEY(0, 1, KEY_B),	KEY(0, 2, KEY_LEFT),
 	KEY(1, 0, KEY_UP),	KEY(1, 1, KEY_ENTER),	KEY(1, 2, KEY_DOWN),
@@ -497,13 +465,16 @@ static struct twl4030_platform_data cm_t35_twldata = {
 	.gpio		= &cm_t35_gpio_data,
 	.vmmc1		= &cm_t35_vmmc1,
 	.vsim		= &cm_t35_vsim,
-	.vdac		= &cm_t35_vdac,
-	.vpll2		= &cm_t35_vpll2,
 };
 
 static void __init cm_t35_init_i2c(void)
 {
-	omap3_pmic_get_config(&cm_t35_twldata, TWL_COMMON_PDATA_USB, 0);
+	omap3_pmic_get_config(&cm_t35_twldata, TWL_COMMON_PDATA_USB,
+			TWL_COMMON_REGULATOR_VDAC | TWL_COMMON_REGULATOR_VPLL2);
+	cm_t35_twldata.vpll2->constraints.name = "VDVI";
+	cm_t35_twldata.vpll2->num_consumer_supplies = 1;
+	cm_t35_twldata.vpll2->consumer_supplies = &cm_t35_vdvi_supply;
+
 	omap3_pmic_init("tps65930", &cm_t35_twldata);
 }
 
diff --git a/arch/arm/mach-omap2/board-devkit8000.c b/arch/arm/mach-omap2/board-devkit8000.c
index aa6a173..f7bc171 100644
--- a/arch/arm/mach-omap2/board-devkit8000.c
+++ b/arch/arm/mach-omap2/board-devkit8000.c
@@ -186,9 +186,6 @@ static struct omap_dss_board_info devkit8000_dss_data = {
 	.default_device = &devkit8000_lcd_device,
 };
 
-static struct regulator_consumer_supply devkit8000_vdda_dac_supply =
-	REGULATOR_SUPPLY("vdda_dac", "omapdss_venc");
-
 static uint32_t board_keymap[] = {
 	KEY(0, 0, KEY_1),
 	KEY(1, 0, KEY_2),
@@ -288,20 +285,6 @@ static struct regulator_init_data devkit8000_vmmc1 = {
 	.consumer_supplies	= &devkit8000_vmmc1_supply,
 };
 
-/* VDAC for DSS driving S-Video (8 mA unloaded, max 65 mA) */
-static struct regulator_init_data devkit8000_vdac = {
-	.constraints = {
-		.min_uV			= 1800000,
-		.max_uV			= 1800000,
-		.valid_modes_mask	= REGULATOR_MODE_NORMAL
-					| REGULATOR_MODE_STANDBY,
-		.valid_ops_mask		= REGULATOR_CHANGE_MODE
-					| REGULATOR_CHANGE_STATUS,
-	},
-	.num_consumer_supplies	= 1,
-	.consumer_supplies	= &devkit8000_vdda_dac_supply,
-};
-
 /* VPLL1 for digital video outputs */
 static struct regulator_init_data devkit8000_vpll1 = {
 	.constraints = {
@@ -335,7 +318,6 @@ static struct twl4030_platform_data devkit8000_twldata = {
 	/* platform_data for children goes here */
 	.gpio		= &devkit8000_gpio_data,
 	.vmmc1		= &devkit8000_vmmc1,
-	.vdac		= &devkit8000_vdac,
 	.vpll1		= &devkit8000_vpll1,
 	.vio		= &devkit8000_vio,
 	.keypad		= &devkit8000_kp_data,
@@ -344,7 +326,8 @@ static struct twl4030_platform_data devkit8000_twldata = {
 static int __init devkit8000_i2c_init(void)
 {
 	omap3_pmic_get_config(&devkit8000_twldata,
-			  TWL_COMMON_PDATA_USB | TWL_COMMON_PDATA_AUDIO, 0);
+			  TWL_COMMON_PDATA_USB | TWL_COMMON_PDATA_AUDIO,
+			  TWL_COMMON_REGULATOR_VDAC);
 	omap3_pmic_init("tps65930", &devkit8000_twldata);
 	/* Bus 3 is attached to the DVI port where devices like the pico DLP
 	 * projector don't work reliably with 400kHz */
diff --git a/arch/arm/mach-omap2/board-igep0020.c b/arch/arm/mach-omap2/board-igep0020.c
index bb3723a..48f86e1 100644
--- a/arch/arm/mach-omap2/board-igep0020.c
+++ b/arch/arm/mach-omap2/board-igep0020.c
@@ -476,26 +476,6 @@ static struct omap_dss_board_info igep2_dss_data = {
 	.default_device	= &igep2_dvi_device,
 };
 
-static struct regulator_consumer_supply igep2_vpll2_supplies[] = {
-	REGULATOR_SUPPLY("vdds_dsi", "omapdss"),
-	REGULATOR_SUPPLY("vdds_dsi", "omapdss_dsi1"),
-};
-
-static struct regulator_init_data igep2_vpll2 = {
-	.constraints = {
-		.name			= "VDVI",
-		.min_uV			= 1800000,
-		.max_uV			= 1800000,
-		.apply_uV		= true,
-		.valid_modes_mask	= REGULATOR_MODE_NORMAL
-					| REGULATOR_MODE_STANDBY,
-		.valid_ops_mask		= REGULATOR_CHANGE_MODE
-					| REGULATOR_CHANGE_STATUS,
-	},
-	.num_consumer_supplies	= ARRAY_SIZE(igep2_vpll2_supplies),
-	.consumer_supplies	= igep2_vpll2_supplies,
-};
-
 static void __init igep2_display_init(void)
 {
 	int err = gpio_request_one(IGEP2_GPIO_DVI_PUP, GPIOF_OUT_INIT_HIGH,
@@ -576,9 +556,11 @@ static void __init igep_i2c_init(void)
 			pr_warning("IGEP2: Could not register I2C3 bus (%d)\n", ret);
 
 		igep_twldata.keypad	= &igep2_keypad_pdata;
-		igep_twldata.vpll2	= &igep2_vpll2;
-		/* Use common codec data */
-		omap3_pmic_get_config(&igep_twldata, TWL_COMMON_PDATA_AUDIO, 0);
+		/* Get common pmic data */
+		omap3_pmic_get_config(&igep_twldata, TWL_COMMON_PDATA_AUDIO,
+				      TWL_COMMON_REGULATOR_VPLL2);
+		igep_twldata.vpll2->constraints.apply_uV = true;
+		igep_twldata.vpll2->constraints.name = "VDVI";
 	}
 
 	omap3_pmic_init("twl4030", &igep_twldata);
diff --git a/arch/arm/mach-omap2/board-omap3beagle.c b/arch/arm/mach-omap2/board-omap3beagle.c
index 63104e8..ff991ca 100644
--- a/arch/arm/mach-omap2/board-omap3beagle.c
+++ b/arch/arm/mach-omap2/board-omap3beagle.c
@@ -210,14 +210,6 @@ static struct omap_dss_board_info beagle_dss_data = {
 	.default_device = &beagle_dvi_device,
 };
 
-static struct regulator_consumer_supply beagle_vdac_supply =
-	REGULATOR_SUPPLY("vdda_dac", "omapdss_venc");
-
-static struct regulator_consumer_supply beagle_vdvi_supplies[] = {
-	REGULATOR_SUPPLY("vdds_dsi", "omapdss"),
-	REGULATOR_SUPPLY("vdds_dsi", "omapdss_dsi1"),
-};
-
 static void __init beagle_display_init(void)
 {
 	int r;
@@ -355,42 +347,11 @@ static struct regulator_init_data beagle_vsim = {
 	.consumer_supplies	= &beagle_vsim_supply,
 };
 
-/* VDAC for DSS driving S-Video (8 mA unloaded, max 65 mA) */
-static struct regulator_init_data beagle_vdac = {
-	.constraints = {
-		.min_uV			= 1800000,
-		.max_uV			= 1800000,
-		.valid_modes_mask	= REGULATOR_MODE_NORMAL
-					| REGULATOR_MODE_STANDBY,
-		.valid_ops_mask		= REGULATOR_CHANGE_MODE
-					| REGULATOR_CHANGE_STATUS,
-	},
-	.num_consumer_supplies	= 1,
-	.consumer_supplies	= &beagle_vdac_supply,
-};
-
-/* VPLL2 for digital video outputs */
-static struct regulator_init_data beagle_vpll2 = {
-	.constraints = {
-		.name			= "VDVI",
-		.min_uV			= 1800000,
-		.max_uV			= 1800000,
-		.valid_modes_mask	= REGULATOR_MODE_NORMAL
-					| REGULATOR_MODE_STANDBY,
-		.valid_ops_mask		= REGULATOR_CHANGE_MODE
-					| REGULATOR_CHANGE_STATUS,
-	},
-	.num_consumer_supplies	= ARRAY_SIZE(beagle_vdvi_supplies),
-	.consumer_supplies	= beagle_vdvi_supplies,
-};
-
 static struct twl4030_platform_data beagle_twldata = {
 	/* platform_data for children goes here */
 	.gpio		= &beagle_gpio_data,
 	.vmmc1		= &beagle_vmmc1,
 	.vsim		= &beagle_vsim,
-	.vdac		= &beagle_vdac,
-	.vpll2		= &beagle_vpll2,
 };
 
 static struct i2c_board_info __initdata beagle_i2c_eeprom[] = {
@@ -402,7 +363,10 @@ static struct i2c_board_info __initdata beagle_i2c_eeprom[] = {
 static int __init omap3_beagle_i2c_init(void)
 {
 	omap3_pmic_get_config(&beagle_twldata,
-			  TWL_COMMON_PDATA_USB | TWL_COMMON_PDATA_AUDIO, 0);
+			TWL_COMMON_PDATA_USB | TWL_COMMON_PDATA_AUDIO,
+			TWL_COMMON_REGULATOR_VDAC | TWL_COMMON_REGULATOR_VPLL2);
+	beagle_twldata.vpll2->constraints.name = "VDVI";
+
 	omap3_pmic_init("twl4030", &beagle_twldata);
 	/* Bus 3 is attached to the DVI port where devices like the pico DLP
 	 * projector don't work reliably with 400kHz */
diff --git a/arch/arm/mach-omap2/board-omap3evm.c b/arch/arm/mach-omap2/board-omap3evm.c
index 3e7e902..e6fa723 100644
--- a/arch/arm/mach-omap2/board-omap3evm.c
+++ b/arch/arm/mach-omap2/board-omap3evm.c
@@ -434,44 +434,6 @@ static struct twl4030_keypad_data omap3evm_kp_data = {
 	.rep		= 1,
 };
 
-static struct regulator_consumer_supply omap3_evm_vdda_dac_supply =
-	REGULATOR_SUPPLY("vdda_dac", "omapdss_venc");
-
-/* VDAC for DSS driving S-Video */
-static struct regulator_init_data omap3_evm_vdac = {
-	.constraints = {
-		.min_uV			= 1800000,
-		.max_uV			= 1800000,
-		.apply_uV		= true,
-		.valid_modes_mask	= REGULATOR_MODE_NORMAL
-					| REGULATOR_MODE_STANDBY,
-		.valid_ops_mask		= REGULATOR_CHANGE_MODE
-					| REGULATOR_CHANGE_STATUS,
-	},
-	.num_consumer_supplies	= 1,
-	.consumer_supplies	= &omap3_evm_vdda_dac_supply,
-};
-
-/* VPLL2 for digital video outputs */
-static struct regulator_consumer_supply omap3_evm_vpll2_supplies[] = {
-	REGULATOR_SUPPLY("vdds_dsi", "omapdss"),
-	REGULATOR_SUPPLY("vdds_dsi", "omapdss_dsi1"),
-};
-
-static struct regulator_init_data omap3_evm_vpll2 = {
-	.constraints = {
-		.min_uV			= 1800000,
-		.max_uV			= 1800000,
-		.apply_uV		= true,
-		.valid_modes_mask	= REGULATOR_MODE_NORMAL
-					| REGULATOR_MODE_STANDBY,
-		.valid_ops_mask		= REGULATOR_CHANGE_MODE
-					| REGULATOR_CHANGE_STATUS,
-	},
-	.num_consumer_supplies	= ARRAY_SIZE(omap3_evm_vpll2_supplies),
-	.consumer_supplies	= omap3_evm_vpll2_supplies,
-};
-
 /* ads7846 on SPI */
 static struct regulator_consumer_supply omap3evm_vio_supply =
 	REGULATOR_SUPPLY("vcc", "spi1.0");
@@ -536,8 +498,6 @@ static struct twl4030_platform_data omap3evm_twldata = {
 	/* platform_data for children goes here */
 	.keypad		= &omap3evm_kp_data,
 	.gpio		= &omap3evm_gpio_data,
-	.vdac		= &omap3_evm_vdac,
-	.vpll2		= &omap3_evm_vpll2,
 	.vio		= &omap3evm_vio,
 	.vmmc1		= &omap3evm_vmmc1,
 	.vsim		= &omap3evm_vsim,
@@ -546,8 +506,11 @@ static struct twl4030_platform_data omap3evm_twldata = {
 static int __init omap3_evm_i2c_init(void)
 {
 	omap3_pmic_get_config(&omap3evm_twldata,
-			  TWL_COMMON_PDATA_USB | TWL_COMMON_PDATA_MADC |
-			  TWL_COMMON_PDATA_AUDIO, 0);
+			TWL_COMMON_PDATA_USB | TWL_COMMON_PDATA_MADC |
+			TWL_COMMON_PDATA_AUDIO,
+			TWL_COMMON_REGULATOR_VDAC | TWL_COMMON_REGULATOR_VPLL2);
+	omap3evm_twldata.vdac->constraints.apply_uV = true;
+	omap3evm_twldata.vpll2->constraints.apply_uV = true;
 	omap3_pmic_init("twl4030", &omap3evm_twldata);
 	omap_register_i2c_bus(2, 400, NULL, 0);
 	omap_register_i2c_bus(3, 400, NULL, 0);
diff --git a/arch/arm/mach-omap2/board-omap3pandora.c b/arch/arm/mach-omap2/board-omap3pandora.c
index 7bfe109..db8b206 100644
--- a/arch/arm/mach-omap2/board-omap3pandora.c
+++ b/arch/arm/mach-omap2/board-omap3pandora.c
@@ -329,9 +329,6 @@ static struct regulator_consumer_supply pandora_vmmc2_supply =
 static struct regulator_consumer_supply pandora_vmmc3_supply =
 	REGULATOR_SUPPLY("vmmc", "omap_hsmmc.2");
 
-static struct regulator_consumer_supply pandora_vdda_dac_supply =
-	REGULATOR_SUPPLY("vdda_dac", "omapdss_venc");
-
 static struct regulator_consumer_supply pandora_vdds_supplies[] = {
 	REGULATOR_SUPPLY("vdds_sdi", "omapdss"),
 	REGULATOR_SUPPLY("vdds_dsi", "omapdss"),
@@ -384,36 +381,6 @@ static struct regulator_init_data pandora_vmmc2 = {
 	.consumer_supplies	= &pandora_vmmc2_supply,
 };
 
-/* VDAC for DSS driving S-Video */
-static struct regulator_init_data pandora_vdac = {
-	.constraints = {
-		.min_uV			= 1800000,
-		.max_uV			= 1800000,
-		.apply_uV		= true,
-		.valid_modes_mask	= REGULATOR_MODE_NORMAL
-					| REGULATOR_MODE_STANDBY,
-		.valid_ops_mask		= REGULATOR_CHANGE_MODE
-					| REGULATOR_CHANGE_STATUS,
-	},
-	.num_consumer_supplies	= 1,
-	.consumer_supplies	= &pandora_vdda_dac_supply,
-};
-
-/* VPLL2 for digital video outputs */
-static struct regulator_init_data pandora_vpll2 = {
-	.constraints = {
-		.min_uV			= 1800000,
-		.max_uV			= 1800000,
-		.apply_uV		= true,
-		.valid_modes_mask	= REGULATOR_MODE_NORMAL
-					| REGULATOR_MODE_STANDBY,
-		.valid_ops_mask		= REGULATOR_CHANGE_MODE
-					| REGULATOR_CHANGE_STATUS,
-	},
-	.num_consumer_supplies	= ARRAY_SIZE(pandora_vdds_supplies),
-	.consumer_supplies	= pandora_vdds_supplies,
-};
-
 /* VAUX1 for LCD */
 static struct regulator_init_data pandora_vaux1 = {
 	.constraints = {
@@ -507,8 +474,6 @@ static struct twl4030_platform_data omap3pandora_twldata = {
 	.gpio		= &omap3pandora_gpio_data,
 	.vmmc1		= &pandora_vmmc1,
 	.vmmc2		= &pandora_vmmc2,
-	.vdac		= &pandora_vdac,
-	.vpll2		= &pandora_vpll2,
 	.vaux1		= &pandora_vaux1,
 	.vaux2		= &pandora_vaux2,
 	.vaux4		= &pandora_vaux4,
@@ -527,7 +492,14 @@ static struct i2c_board_info __initdata omap3pandora_i2c3_boardinfo[] = {
 static int __init omap3pandora_i2c_init(void)
 {
 	omap3_pmic_get_config(&omap3pandora_twldata,
-			      TWL_COMMON_PDATA_USB | TWL_COMMON_PDATA_AUDIO, 0);
+			TWL_COMMON_PDATA_USB | TWL_COMMON_PDATA_AUDIO,
+			TWL_COMMON_REGULATOR_VDAC | TWL_COMMON_REGULATOR_VPLL2);
+	omap3pandora_twldata.vdac->constraints.apply_uV = true;
+	omap3pandora_twldata.vpll2->constraints.apply_uV = true;
+	omap3pandora_twldata.vpll2->num_consumer_supplies =
+					ARRAY_SIZE(pandora_vdds_supplies);
+	omap3pandora_twldata.vpll2->consumer_supplies = pandora_vdds_supplies;
+
 	omap3_pmic_init("tps65950", &omap3pandora_twldata);
 	/* i2c2 pins are not connected */
 	omap_register_i2c_bus(3, 100, omap3pandora_i2c3_boardinfo,
diff --git a/arch/arm/mach-omap2/board-omap3stalker.c b/arch/arm/mach-omap2/board-omap3stalker.c
index 2b52281..e40e08c 100644
--- a/arch/arm/mach-omap2/board-omap3stalker.c
+++ b/arch/arm/mach-omap2/board-omap3stalker.c
@@ -388,51 +388,10 @@ static struct twl4030_keypad_data omap3stalker_kp_data = {
 	.rep		= 1,
 };
 
-static struct regulator_consumer_supply omap3_stalker_vdda_dac_supply =
-	REGULATOR_SUPPLY("vdda_dac", "omapdss_venc");
-
-/* VDAC for DSS driving S-Video */
-static struct regulator_init_data omap3_stalker_vdac = {
-	.constraints		= {
-		.min_uV			= 1800000,
-		.max_uV			= 1800000,
-		.apply_uV		= true,
-		.valid_modes_mask	= REGULATOR_MODE_NORMAL
-		| REGULATOR_MODE_STANDBY,
-		.valid_ops_mask		= REGULATOR_CHANGE_MODE
-		| REGULATOR_CHANGE_STATUS,
-	},
-	.num_consumer_supplies	= 1,
-	.consumer_supplies	= &omap3_stalker_vdda_dac_supply,
-};
-
-/* VPLL2 for digital video outputs */
-static struct regulator_consumer_supply omap3_stalker_vpll2_supplies[] = {
-	REGULATOR_SUPPLY("vdds_dsi", "omapdss"),
-	REGULATOR_SUPPLY("vdds_dsi", "omapdss_dsi1"),
-};
-
-static struct regulator_init_data omap3_stalker_vpll2 = {
-	.constraints		= {
-		.name			= "VDVI",
-		.min_uV			= 1800000,
-		.max_uV			= 1800000,
-		.apply_uV = true,
-		.valid_modes_mask	= REGULATOR_MODE_NORMAL
-		| REGULATOR_MODE_STANDBY,
-		.valid_ops_mask		= REGULATOR_CHANGE_MODE
-		| REGULATOR_CHANGE_STATUS,
-	},
-	.num_consumer_supplies	= ARRAY_SIZE(omap3_stalker_vpll2_supplies),
-	.consumer_supplies	= omap3_stalker_vpll2_supplies,
-};
-
 static struct twl4030_platform_data omap3stalker_twldata = {
 	/* platform_data for children goes here */
 	.keypad		= &omap3stalker_kp_data,
 	.gpio		= &omap3stalker_gpio_data,
-	.vdac		= &omap3_stalker_vdac,
-	.vpll2		= &omap3_stalker_vpll2,
 	.vmmc1		= &omap3stalker_vmmc1,
 	.vsim		= &omap3stalker_vsim,
 };
@@ -455,7 +414,12 @@ static int __init omap3_stalker_i2c_init(void)
 {
 	omap3_pmic_get_config(&omap3stalker_twldata,
 			TWL_COMMON_PDATA_USB | TWL_COMMON_PDATA_MADC |
-			TWL_COMMON_PDATA_AUDIO, 0);
+			TWL_COMMON_PDATA_AUDIO,
+			TWL_COMMON_REGULATOR_VDAC | TWL_COMMON_REGULATOR_VPLL2);
+	omap3stalker_twldata.vdac->constraints.apply_uV = true;
+	omap3stalker_twldata.vpll2->constraints.apply_uV = true;
+	omap3stalker_twldata.vpll2->constraints.name = "VDVI";
+
 	omap3_pmic_init("twl4030", &omap3stalker_twldata);
 	omap_register_i2c_bus(2, 400, NULL, 0);
 	omap_register_i2c_bus(3, 400, omap3stalker_i2c_boardinfo3,
diff --git a/arch/arm/mach-omap2/board-omap3touchbook.c b/arch/arm/mach-omap2/board-omap3touchbook.c
index 094ea80..a0a3cf0 100644
--- a/arch/arm/mach-omap2/board-omap3touchbook.c
+++ b/arch/arm/mach-omap2/board-omap3touchbook.c
@@ -207,42 +207,11 @@ static struct regulator_init_data touchbook_vsim = {
 	.consumer_supplies	= &touchbook_vsim_supply,
 };
 
-/* VDAC for DSS driving S-Video (8 mA unloaded, max 65 mA) */
-static struct regulator_init_data touchbook_vdac = {
-	.constraints = {
-		.min_uV			= 1800000,
-		.max_uV			= 1800000,
-		.valid_modes_mask	= REGULATOR_MODE_NORMAL
-					| REGULATOR_MODE_STANDBY,
-		.valid_ops_mask		= REGULATOR_CHANGE_MODE
-					| REGULATOR_CHANGE_STATUS,
-	},
-	.num_consumer_supplies	= 1,
-	.consumer_supplies	= &touchbook_vdac_supply,
-};
-
-/* VPLL2 for digital video outputs */
-static struct regulator_init_data touchbook_vpll2 = {
-	.constraints = {
-		.name			= "VDVI",
-		.min_uV			= 1800000,
-		.max_uV			= 1800000,
-		.valid_modes_mask	= REGULATOR_MODE_NORMAL
-					| REGULATOR_MODE_STANDBY,
-		.valid_ops_mask		= REGULATOR_CHANGE_MODE
-					| REGULATOR_CHANGE_STATUS,
-	},
-	.num_consumer_supplies	= 1,
-	.consumer_supplies	= &touchbook_vdvi_supply,
-};
-
 static struct twl4030_platform_data touchbook_twldata = {
 	/* platform_data for children goes here */
 	.gpio		= &touchbook_gpio_data,
 	.vmmc1		= &touchbook_vmmc1,
 	.vsim		= &touchbook_vsim,
-	.vdac		= &touchbook_vdac,
-	.vpll2		= &touchbook_vpll2,
 };
 
 static struct i2c_board_info __initdata touchBook_i2c_boardinfo[] = {
@@ -255,7 +224,14 @@ static int __init omap3_touchbook_i2c_init(void)
 {
 	/* Standard TouchBook bus */
 	omap3_pmic_get_config(&touchbook_twldata,
-			TWL_COMMON_PDATA_USB | TWL_COMMON_PDATA_AUDIO, 0);
+			TWL_COMMON_PDATA_USB | TWL_COMMON_PDATA_AUDIO,
+			TWL_COMMON_REGULATOR_VDAC | TWL_COMMON_REGULATOR_VPLL2);
+	touchbook_twldata.vdac->num_consumer_supplies = 1;
+	touchbook_twldata.vdac->consumer_supplies = &touchbook_vdac_supply;
+	touchbook_twldata.vpll2->constraints.name = "VDVI";
+	touchbook_twldata.vpll2->num_consumer_supplies = 1;
+	touchbook_twldata.vpll2->consumer_supplies = &touchbook_vdvi_supply;
+
 	omap3_pmic_init("twl4030", &touchbook_twldata);
 	/* Additional TouchBook bus */
 	omap_register_i2c_bus(3, 100, touchBook_i2c_boardinfo,
diff --git a/arch/arm/mach-omap2/board-overo.c b/arch/arm/mach-omap2/board-overo.c
index f334829..e3fa177 100644
--- a/arch/arm/mach-omap2/board-overo.c
+++ b/arch/arm/mach-omap2/board-overo.c
@@ -264,14 +264,6 @@ static struct omap_dss_board_info overo_dss_data = {
 	.default_device	= &overo_dvi_device,
 };
 
-static struct regulator_consumer_supply overo_vdda_dac_supply =
-	REGULATOR_SUPPLY("vdda_dac", "omapdss_venc");
-
-static struct regulator_consumer_supply overo_vdds_dsi_supply[] = {
-	REGULATOR_SUPPLY("vdds_dsi", "omapdss"),
-	REGULATOR_SUPPLY("vdds_dsi", "omapdss_dsi1"),
-};
-
 static struct mtd_partition overo_nand_partitions[] = {
 	{
 		.name           = "xloader",
@@ -447,46 +439,18 @@ static struct regulator_init_data overo_vmmc1 = {
 	.consumer_supplies	= &overo_vmmc1_supply,
 };
 
-/* VDAC for DSS driving S-Video (8 mA unloaded, max 65 mA) */
-static struct regulator_init_data overo_vdac = {
-	.constraints = {
-		.min_uV			= 1800000,
-		.max_uV			= 1800000,
-		.valid_modes_mask	= REGULATOR_MODE_NORMAL
-					| REGULATOR_MODE_STANDBY,
-		.valid_ops_mask		= REGULATOR_CHANGE_MODE
-					| REGULATOR_CHANGE_STATUS,
-	},
-	.num_consumer_supplies	= 1,
-	.consumer_supplies	= &overo_vdda_dac_supply,
-};
-
-/* VPLL2 for digital video outputs */
-static struct regulator_init_data overo_vpll2 = {
-	.constraints = {
-		.name			= "VDVI",
-		.min_uV			= 1800000,
-		.max_uV			= 1800000,
-		.valid_modes_mask	= REGULATOR_MODE_NORMAL
-					| REGULATOR_MODE_STANDBY,
-		.valid_ops_mask		= REGULATOR_CHANGE_MODE
-					| REGULATOR_CHANGE_STATUS,
-	},
-	.num_consumer_supplies	= ARRAY_SIZE(overo_vdds_dsi_supply),
-	.consumer_supplies	= overo_vdds_dsi_supply,
-};
-
 static struct twl4030_platform_data overo_twldata = {
 	.gpio		= &overo_gpio_data,
 	.vmmc1		= &overo_vmmc1,
-	.vdac		= &overo_vdac,
-	.vpll2		= &overo_vpll2,
 };
 
 static int __init overo_i2c_init(void)
 {
 	omap3_pmic_get_config(&overo_twldata,
-			TWL_COMMON_PDATA_USB | TWL_COMMON_PDATA_AUDIO, 0);
+			TWL_COMMON_PDATA_USB | TWL_COMMON_PDATA_AUDIO,
+			TWL_COMMON_REGULATOR_VDAC | TWL_COMMON_REGULATOR_VPLL2);
+	overo_twldata.vpll2->constraints.name = "VDVI";
+
 	omap3_pmic_init("tps65950", &overo_twldata);
 	/* i2c2 pins are used for gpio */
 	omap_register_i2c_bus(3, 400, NULL, 0);
diff --git a/arch/arm/mach-omap2/board-rx51-peripherals.c b/arch/arm/mach-omap2/board-rx51-peripherals.c
index dc69a7f..dfaf874 100644
--- a/arch/arm/mach-omap2/board-rx51-peripherals.c
+++ b/arch/arm/mach-omap2/board-rx51-peripherals.c
@@ -391,10 +391,6 @@ static struct regulator_consumer_supply rx51_vaux1_consumers[] = {
 	REGULATOR_SUPPLY("vdd", "2-0063"),
 };
 
-static struct regulator_consumer_supply rx51_vdac_supply[] = {
-	REGULATOR_SUPPLY("vdda_dac", "omapdss_venc"),
-};
-
 static struct regulator_init_data rx51_vaux1 = {
 	.constraints = {
 		.name			= "V28",
@@ -511,21 +507,6 @@ static struct regulator_init_data rx51_vsim = {
 	.consumer_supplies	= &rx51_vsim_supply,
 };
 
-static struct regulator_init_data rx51_vdac = {
-	.constraints = {
-		.name			= "VDAC",
-		.min_uV			= 1800000,
-		.max_uV			= 1800000,
-		.apply_uV		= true,
-		.valid_modes_mask	= REGULATOR_MODE_NORMAL
-					| REGULATOR_MODE_STANDBY,
-		.valid_ops_mask		= REGULATOR_CHANGE_MODE
-					| REGULATOR_CHANGE_STATUS,
-	},
-	.num_consumer_supplies	= 1,
-	.consumer_supplies	= rx51_vdac_supply,
-};
-
 static struct regulator_init_data rx51_vio = {
 	.constraints = {
 		.min_uV			= 1800000,
@@ -778,7 +759,6 @@ static struct twl4030_platform_data rx51_twldata __initdata = {
 	.vaux4			= &rx51_vaux4,
 	.vmmc1			= &rx51_vmmc1,
 	.vsim			= &rx51_vsim,
-	.vdac			= &rx51_vdac,
 	.vio			= &rx51_vio,
 };
 
@@ -835,7 +815,10 @@ static int __init rx51_i2c_init(void)
 	}
 	rx51_twldata.vmmc2 = &rx51_vmmc2;
 	omap3_pmic_get_config(&rx51_twldata,
-			TWL_COMMON_PDATA_USB | TWL_COMMON_PDATA_MADC, 0);
+			TWL_COMMON_PDATA_USB | TWL_COMMON_PDATA_MADC,
+			TWL_COMMON_REGULATOR_VDAC);
+	rx51_twldata.vdac->constraints.apply_uV = true;
+	rx51_twldata.vdac->constraints.name = "VDAC";
 	omap_pmic_init(1, 2200, "twl5030", INT_34XX_SYS_NIRQ, &rx51_twldata);
 	omap_register_i2c_bus(2, 100, rx51_peripherals_i2c_board_info_2,
 			      ARRAY_SIZE(rx51_peripherals_i2c_board_info_2));
diff --git a/arch/arm/mach-omap2/board-zoom-peripherals.c b/arch/arm/mach-omap2/board-zoom-peripherals.c
index 58c0c6e..8853dc4 100644
--- a/arch/arm/mach-omap2/board-zoom-peripherals.c
+++ b/arch/arm/mach-omap2/board-zoom-peripherals.c
@@ -227,40 +227,6 @@ static struct omap2_hsmmc_info mmc[] = {
 	{}      /* Terminator */
 };
 
-static struct regulator_consumer_supply zoom_vpll2_supplies[] = {
-	REGULATOR_SUPPLY("vdds_dsi", "omapdss"),
-	REGULATOR_SUPPLY("vdds_dsi", "omapdss_dsi1"),
-};
-
-static struct regulator_consumer_supply zoom_vdda_dac_supply =
-	REGULATOR_SUPPLY("vdda_dac", "omapdss_venc");
-
-static struct regulator_init_data zoom_vpll2 = {
-	.constraints = {
-		.min_uV                 = 1800000,
-		.max_uV                 = 1800000,
-		.valid_modes_mask       = REGULATOR_MODE_NORMAL
-					| REGULATOR_MODE_STANDBY,
-		.valid_ops_mask         = REGULATOR_CHANGE_MODE
-					| REGULATOR_CHANGE_STATUS,
-	},
-	.num_consumer_supplies		= ARRAY_SIZE(zoom_vpll2_supplies),
-	.consumer_supplies		= zoom_vpll2_supplies,
-};
-
-static struct regulator_init_data zoom_vdac = {
-	.constraints = {
-		.min_uV                 = 1800000,
-		.max_uV                 = 1800000,
-		.valid_modes_mask       = REGULATOR_MODE_NORMAL
-					| REGULATOR_MODE_STANDBY,
-		.valid_ops_mask         = REGULATOR_CHANGE_MODE
-					| REGULATOR_CHANGE_STATUS,
-	},
-	.num_consumer_supplies		= 1,
-	.consumer_supplies		= &zoom_vdda_dac_supply,
-};
-
 static int zoom_twl_gpio_setup(struct device *dev,
 		unsigned gpio, unsigned ngpio)
 {
@@ -306,15 +272,14 @@ static struct twl4030_platform_data zoom_twldata = {
 	.vmmc1          = &zoom_vmmc1,
 	.vmmc2          = &zoom_vmmc2,
 	.vsim           = &zoom_vsim,
-	.vpll2		= &zoom_vpll2,
-	.vdac		= &zoom_vdac,
 };
 
 static int __init omap_i2c_init(void)
 {
 	omap3_pmic_get_config(&zoom_twldata,
-			  TWL_COMMON_PDATA_USB | TWL_COMMON_PDATA_BCI |
-			  TWL_COMMON_PDATA_MADC | TWL_COMMON_PDATA_AUDIO, 0);
+			TWL_COMMON_PDATA_USB | TWL_COMMON_PDATA_BCI |
+			TWL_COMMON_PDATA_MADC | TWL_COMMON_PDATA_AUDIO,
+			TWL_COMMON_REGULATOR_VDAC | TWL_COMMON_REGULATOR_VPLL2);
 
 	if (machine_is_omap_zoom2()) {
 		struct twl4030_codec_audio_data *audio_data;
diff --git a/arch/arm/mach-omap2/twl-common.c b/arch/arm/mach-omap2/twl-common.c
index 2487e3c..f15f880 100644
--- a/arch/arm/mach-omap2/twl-common.c
+++ b/arch/arm/mach-omap2/twl-common.c
@@ -87,6 +87,41 @@ static struct twl4030_codec_data omap3_codec_pdata = {
 	.audio = &omap3_audio,
 };
 
+static struct regulator_consumer_supply omap3_vdda_dac_supplies[] = {
+	REGULATOR_SUPPLY("vdda_dac", "omapdss_venc"),
+};
+
+static struct regulator_init_data omap3_vdac_idata = {
+	.constraints = {
+		.min_uV			= 1800000,
+		.max_uV			= 1800000,
+		.valid_modes_mask	= REGULATOR_MODE_NORMAL
+					| REGULATOR_MODE_STANDBY,
+		.valid_ops_mask		= REGULATOR_CHANGE_MODE
+					| REGULATOR_CHANGE_STATUS,
+	},
+	.num_consumer_supplies	= ARRAY_SIZE(omap3_vdda_dac_supplies),
+	.consumer_supplies	= omap3_vdda_dac_supplies,
+};
+
+static struct regulator_consumer_supply omap3_vpll2_supplies[] = {
+	REGULATOR_SUPPLY("vdds_dsi", "omapdss"),
+	REGULATOR_SUPPLY("vdds_dsi", "omapdss_dsi1"),
+};
+
+static struct regulator_init_data omap3_vpll2_idata = {
+	.constraints = {
+		.min_uV                 = 1800000,
+		.max_uV                 = 1800000,
+		.valid_modes_mask       = REGULATOR_MODE_NORMAL
+					| REGULATOR_MODE_STANDBY,
+		.valid_ops_mask         = REGULATOR_CHANGE_MODE
+					| REGULATOR_CHANGE_STATUS,
+	},
+	.num_consumer_supplies		= ARRAY_SIZE(omap3_vpll2_supplies),
+	.consumer_supplies		= omap3_vpll2_supplies,
+};
+
 static struct regulator_init_data omap4_vdac_idata = {
 	.constraints = {
 		.min_uV			= 1800000,
@@ -259,4 +294,11 @@ void __init omap3_pmic_get_config(struct twl4030_platform_data *pmic_data,
 
 	if (pdata_flags & TWL_COMMON_PDATA_AUDIO && !pmic_data->codec)
 		pmic_data->codec = &omap3_codec_pdata;
+
+	/* Common regulator configurations */
+	if (regulators_flags & TWL_COMMON_REGULATOR_VDAC && !pmic_data->vdac)
+		pmic_data->vdac = &omap3_vdac_idata;
+
+	if (regulators_flags & TWL_COMMON_REGULATOR_VPLL2 && !pmic_data->vpll2)
+		pmic_data->vpll2 = &omap3_vpll2_idata;
 }
diff --git a/arch/arm/mach-omap2/twl-common.h b/arch/arm/mach-omap2/twl-common.h
index 3b4b05d..5e83a5b 100644
--- a/arch/arm/mach-omap2/twl-common.h
+++ b/arch/arm/mach-omap2/twl-common.h
@@ -21,6 +21,11 @@
 #define TWL_COMMON_REGULATOR_VUSB	(1 << 9)
 #define TWL_COMMON_REGULATOR_CLK32KG	(1 << 10)
 
+/* TWL4030 LDO regulators */
+#define TWL_COMMON_REGULATOR_VPLL1	(1 << 4)
+#define TWL_COMMON_REGULATOR_VPLL2	(1 << 5)
+
+
 struct twl4030_platform_data;
 
 void omap_pmic_init(int bus, u32 clkrate, const char *pmic_type, int pmic_irq,
-- 
1.7.5.3

