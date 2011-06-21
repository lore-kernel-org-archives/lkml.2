Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756846Ab1FUOnS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 10:43:18 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:37365 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751475Ab1FUOjx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 10:39:53 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Liam Girdwood <lrg@ti.com>, Tony Lindgren <tony@atomide.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: linux-input@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        Peter Ujfalusi <peter.ujfalusi@ti.com>
Subject: [PATCH v6 03/18] OMAP3: Move common twl configuration to twl-common
Date: Tue, 21 Jun 2011 16:39:01 +0300
Message-ID: <1308663556-29120-4-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.5.3
In-Reply-To: <1308663556-29120-1-git-send-email-peter.ujfalusi@ti.com>
References: <1308663556-29120-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reduce the amount of duplicated code by moving the common
configuration for twl4030/5030/tpsxx to the twl-common file.
Use the omap3_pmic_get_config function from board files to
properly configure the PMIC with the common fields.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 arch/arm/mach-omap2/board-3430sdp.c          |   42 ++------------------
 arch/arm/mach-omap2/board-cm-t35.c           |    9 +----
 arch/arm/mach-omap2/board-devkit8000.c       |   18 +--------
 arch/arm/mach-omap2/board-igep0020.c         |   20 ++--------
 arch/arm/mach-omap2/board-ldp.c              |   15 +------
 arch/arm/mach-omap2/board-omap3beagle.c      |   18 +--------
 arch/arm/mach-omap2/board-omap3evm.c         |   24 +----------
 arch/arm/mach-omap2/board-omap3pandora.c     |   17 +-------
 arch/arm/mach-omap2/board-omap3stalker.c     |   24 +----------
 arch/arm/mach-omap2/board-omap3touchbook.c   |   19 +--------
 arch/arm/mach-omap2/board-overo.c            |   17 +-------
 arch/arm/mach-omap2/board-rm680.c            |    8 +---
 arch/arm/mach-omap2/board-rx51-peripherals.c |   15 +------
 arch/arm/mach-omap2/board-zoom-peripherals.c |   51 +++++--------------------
 arch/arm/mach-omap2/twl-common.c             |   53 ++++++++++++++++++++++++++
 arch/arm/mach-omap2/twl-common.h             |    6 +++
 16 files changed, 99 insertions(+), 257 deletions(-)

diff --git a/arch/arm/mach-omap2/board-3430sdp.c b/arch/arm/mach-omap2/board-3430sdp.c
index 5dac974..4810dcc 100644
--- a/arch/arm/mach-omap2/board-3430sdp.c
+++ b/arch/arm/mach-omap2/board-3430sdp.c
@@ -231,22 +231,6 @@ static void __init omap_3430sdp_init_early(void)
 	omap2_init_common_devices(hyb18m512160af6_sdrc_params, NULL);
 }
 
-static int sdp3430_batt_table[] = {
-/* 0 C*/
-30800, 29500, 28300, 27100,
-26000, 24900, 23900, 22900, 22000, 21100, 20300, 19400, 18700, 17900,
-17200, 16500, 15900, 15300, 14700, 14100, 13600, 13100, 12600, 12100,
-11600, 11200, 10800, 10400, 10000, 9630,   9280,   8950,   8620,   8310,
-8020,   7730,   7460,   7200,   6950,   6710,   6470,   6250,   6040,   5830,
-5640,   5450,   5260,   5090,   4920,   4760,   4600,   4450,   4310,   4170,
-4040,   3910,   3790,   3670,   3550
-};
-
-static struct twl4030_bci_platform_data sdp3430_bci_data = {
-	.battery_tmp_tbl	= sdp3430_batt_table,
-	.tblsize		= ARRAY_SIZE(sdp3430_batt_table),
-};
-
 static struct omap2_hsmmc_info mmc[] = {
 	{
 		.mmc		= 1,
@@ -292,14 +276,6 @@ static struct twl4030_gpio_platform_data sdp3430_gpio_data = {
 	.setup		= sdp3430_twl_gpio_setup,
 };
 
-static struct twl4030_usb_data sdp3430_usb_data = {
-	.usb_mode	= T2_USB_MODE_ULPI,
-};
-
-static struct twl4030_madc_platform_data sdp3430_madc_data = {
-	.irq_line	= 1,
-};
-
 /* regulator consumer mappings */
 
 /* ads7846 on SPI */
@@ -463,24 +439,10 @@ static struct regulator_init_data sdp3430_vpll2 = {
 	.consumer_supplies	= sdp3430_vpll2_supplies,
 };
 
-static struct twl4030_codec_audio_data sdp3430_audio;
-
-static struct twl4030_codec_data sdp3430_codec = {
-	.audio_mclk = 26000000,
-	.audio = &sdp3430_audio,
-};
-
 static struct twl4030_platform_data sdp3430_twldata = {
-	.irq_base	= TWL4030_IRQ_BASE,
-	.irq_end	= TWL4030_IRQ_END,
-
 	/* platform_data for children goes here */
-	.bci		= &sdp3430_bci_data,
 	.gpio		= &sdp3430_gpio_data,
-	.madc		= &sdp3430_madc_data,
 	.keypad		= &sdp3430_kp_data,
-	.usb		= &sdp3430_usb_data,
-	.codec		= &sdp3430_codec,
 
 	.vaux1		= &sdp3430_vaux1,
 	.vaux2		= &sdp3430_vaux2,
@@ -496,7 +458,11 @@ static struct twl4030_platform_data sdp3430_twldata = {
 static int __init omap3430_i2c_init(void)
 {
 	/* i2c1 for PMIC only */
+	omap3_pmic_get_config(&sdp3430_twldata,
+			  TWL_COMMON_PDATA_USB | TWL_COMMON_PDATA_BCI |
+			  TWL_COMMON_PDATA_MADC | TWL_COMMON_PDATA_AUDIO, 0);
 	omap3_pmic_init("twl4030", &sdp3430_twldata);
+
 	/* i2c2 on camera connector (for sensor control) and optional isp1301 */
 	omap_register_i2c_bus(2, 400, NULL, 0);
 	/* i2c3 on display connector (for DVI, tfp410) */
diff --git a/arch/arm/mach-omap2/board-cm-t35.c b/arch/arm/mach-omap2/board-cm-t35.c
index 77456de..e867474 100644
--- a/arch/arm/mach-omap2/board-cm-t35.c
+++ b/arch/arm/mach-omap2/board-cm-t35.c
@@ -410,10 +410,6 @@ static struct regulator_init_data cm_t35_vpll2 = {
 	.consumer_supplies	= &cm_t35_vdvi_supply,
 };
 
-static struct twl4030_usb_data cm_t35_usb_data = {
-	.usb_mode	= T2_USB_MODE_ULPI,
-};
-
 static uint32_t cm_t35_keymap[] = {
 	KEY(0, 0, KEY_A),	KEY(0, 1, KEY_B),	KEY(0, 2, KEY_LEFT),
 	KEY(1, 0, KEY_UP),	KEY(1, 1, KEY_ENTER),	KEY(1, 2, KEY_DOWN),
@@ -496,12 +492,8 @@ static struct twl4030_gpio_platform_data cm_t35_gpio_data = {
 };
 
 static struct twl4030_platform_data cm_t35_twldata = {
-	.irq_base	= TWL4030_IRQ_BASE,
-	.irq_end	= TWL4030_IRQ_END,
-
 	/* platform_data for children goes here */
 	.keypad		= &cm_t35_kp_data,
-	.usb		= &cm_t35_usb_data,
 	.gpio		= &cm_t35_gpio_data,
 	.vmmc1		= &cm_t35_vmmc1,
 	.vsim		= &cm_t35_vsim,
@@ -511,6 +503,7 @@ static struct twl4030_platform_data cm_t35_twldata = {
 
 static void __init cm_t35_init_i2c(void)
 {
+	omap3_pmic_get_config(&cm_t35_twldata, TWL_COMMON_PDATA_USB, 0);
 	omap3_pmic_init("tps65930", &cm_t35_twldata);
 }
 
diff --git a/arch/arm/mach-omap2/board-devkit8000.c b/arch/arm/mach-omap2/board-devkit8000.c
index 34956ec..aa6a173 100644
--- a/arch/arm/mach-omap2/board-devkit8000.c
+++ b/arch/arm/mach-omap2/board-devkit8000.c
@@ -331,25 +331,9 @@ static struct regulator_init_data devkit8000_vio = {
 	.consumer_supplies      = &devkit8000_vio_supply,
 };
 
-static struct twl4030_usb_data devkit8000_usb_data = {
-	.usb_mode	= T2_USB_MODE_ULPI,
-};
-
-static struct twl4030_codec_audio_data devkit8000_audio_data;
-
-static struct twl4030_codec_data devkit8000_codec_data = {
-	.audio_mclk = 26000000,
-	.audio = &devkit8000_audio_data,
-};
-
 static struct twl4030_platform_data devkit8000_twldata = {
-	.irq_base	= TWL4030_IRQ_BASE,
-	.irq_end	= TWL4030_IRQ_END,
-
 	/* platform_data for children goes here */
-	.usb		= &devkit8000_usb_data,
 	.gpio		= &devkit8000_gpio_data,
-	.codec		= &devkit8000_codec_data,
 	.vmmc1		= &devkit8000_vmmc1,
 	.vdac		= &devkit8000_vdac,
 	.vpll1		= &devkit8000_vpll1,
@@ -359,6 +343,8 @@ static struct twl4030_platform_data devkit8000_twldata = {
 
 static int __init devkit8000_i2c_init(void)
 {
+	omap3_pmic_get_config(&devkit8000_twldata,
+			  TWL_COMMON_PDATA_USB | TWL_COMMON_PDATA_AUDIO, 0);
 	omap3_pmic_init("tps65930", &devkit8000_twldata);
 	/* Bus 3 is attached to the DVI port where devices like the pico DLP
 	 * projector don't work reliably with 400kHz */
diff --git a/arch/arm/mach-omap2/board-igep0020.c b/arch/arm/mach-omap2/board-igep0020.c
index 0c1bfca..bb3723a 100644
--- a/arch/arm/mach-omap2/board-igep0020.c
+++ b/arch/arm/mach-omap2/board-igep0020.c
@@ -440,10 +440,6 @@ static struct twl4030_gpio_platform_data igep_twl4030_gpio_pdata = {
 	.setup		= igep_twl_gpio_setup,
 };
 
-static struct twl4030_usb_data igep_usb_data = {
-	.usb_mode	= T2_USB_MODE_ULPI,
-};
-
 static int igep2_enable_dvi(struct omap_dss_device *dssdev)
 {
 	gpio_direction_output(IGEP2_GPIO_DVI_PUP, 1);
@@ -519,13 +515,6 @@ static void __init igep_init_early(void)
 				  m65kxxxxam_sdrc_params);
 }
 
-static struct twl4030_codec_audio_data igep2_audio_data;
-
-static struct twl4030_codec_data igep2_codec_data = {
-	.audio_mclk = 26000000,
-	.audio = &igep2_audio_data,
-};
-
 static int igep2_keymap[] = {
 	KEY(0, 0, KEY_LEFT),
 	KEY(0, 1, KEY_RIGHT),
@@ -558,11 +547,7 @@ static struct twl4030_keypad_data igep2_keypad_pdata = {
 };
 
 static struct twl4030_platform_data igep_twldata = {
-	.irq_base	= TWL4030_IRQ_BASE,
-	.irq_end	= TWL4030_IRQ_END,
-
 	/* platform_data for children goes here */
-	.usb		= &igep_usb_data,
 	.gpio		= &igep_twl4030_gpio_pdata,
 	.vmmc1          = &igep_vmmc1,
 	.vio		= &igep_vio,
@@ -578,6 +563,8 @@ static void __init igep_i2c_init(void)
 {
 	int ret;
 
+	omap3_pmic_get_config(&igep_twldata, TWL_COMMON_PDATA_USB, 0);
+
 	if (machine_is_igep0020()) {
 		/*
 		 * Bus 3 is attached to the DVI port where devices like the
@@ -588,9 +575,10 @@ static void __init igep_i2c_init(void)
 		if (ret)
 			pr_warning("IGEP2: Could not register I2C3 bus (%d)\n", ret);
 
-		igep_twldata.codec	= &igep2_codec_data;
 		igep_twldata.keypad	= &igep2_keypad_pdata;
 		igep_twldata.vpll2	= &igep2_vpll2;
+		/* Use common codec data */
+		omap3_pmic_get_config(&igep_twldata, TWL_COMMON_PDATA_AUDIO, 0);
 	}
 
 	omap3_pmic_init("twl4030", &igep_twldata);
diff --git a/arch/arm/mach-omap2/board-ldp.c b/arch/arm/mach-omap2/board-ldp.c
index f7d6038..6ff564a 100644
--- a/arch/arm/mach-omap2/board-ldp.c
+++ b/arch/arm/mach-omap2/board-ldp.c
@@ -199,20 +199,12 @@ static void __init omap_ldp_init_early(void)
 	omap2_init_common_devices(NULL, NULL);
 }
 
-static struct twl4030_usb_data ldp_usb_data = {
-	.usb_mode	= T2_USB_MODE_ULPI,
-};
-
 static struct twl4030_gpio_platform_data ldp_gpio_data = {
 	.gpio_base	= OMAP_MAX_GPIO_LINES,
 	.irq_base	= TWL4030_GPIO_IRQ_BASE,
 	.irq_end	= TWL4030_GPIO_IRQ_END,
 };
 
-static struct twl4030_madc_platform_data ldp_madc_data = {
-	.irq_line	= 1,
-};
-
 static struct regulator_consumer_supply ldp_vmmc1_supply = {
 	.supply			= "vmmc",
 };
@@ -253,12 +245,7 @@ static struct regulator_init_data ldp_vaux1 = {
 };
 
 static struct twl4030_platform_data ldp_twldata = {
-	.irq_base	= TWL4030_IRQ_BASE,
-	.irq_end	= TWL4030_IRQ_END,
-
 	/* platform_data for children goes here */
-	.madc		= &ldp_madc_data,
-	.usb		= &ldp_usb_data,
 	.vmmc1		= &ldp_vmmc1,
 	.vaux1		= &ldp_vaux1,
 	.gpio		= &ldp_gpio_data,
@@ -267,6 +254,8 @@ static struct twl4030_platform_data ldp_twldata = {
 
 static int __init omap_i2c_init(void)
 {
+	omap3_pmic_get_config(&ldp_twldata,
+			  TWL_COMMON_PDATA_USB | TWL_COMMON_PDATA_MADC, 0);
 	omap3_pmic_init("twl4030", &ldp_twldata);
 	omap_register_i2c_bus(2, 400, NULL, 0);
 	omap_register_i2c_bus(3, 400, NULL, 0);
diff --git a/arch/arm/mach-omap2/board-omap3beagle.c b/arch/arm/mach-omap2/board-omap3beagle.c
index 7f21d24..63104e8 100644
--- a/arch/arm/mach-omap2/board-omap3beagle.c
+++ b/arch/arm/mach-omap2/board-omap3beagle.c
@@ -384,25 +384,9 @@ static struct regulator_init_data beagle_vpll2 = {
 	.consumer_supplies	= beagle_vdvi_supplies,
 };
 
-static struct twl4030_usb_data beagle_usb_data = {
-	.usb_mode	= T2_USB_MODE_ULPI,
-};
-
-static struct twl4030_codec_audio_data beagle_audio_data;
-
-static struct twl4030_codec_data beagle_codec_data = {
-	.audio_mclk = 26000000,
-	.audio = &beagle_audio_data,
-};
-
 static struct twl4030_platform_data beagle_twldata = {
-	.irq_base	= TWL4030_IRQ_BASE,
-	.irq_end	= TWL4030_IRQ_END,
-
 	/* platform_data for children goes here */
-	.usb		= &beagle_usb_data,
 	.gpio		= &beagle_gpio_data,
-	.codec		= &beagle_codec_data,
 	.vmmc1		= &beagle_vmmc1,
 	.vsim		= &beagle_vsim,
 	.vdac		= &beagle_vdac,
@@ -417,6 +401,8 @@ static struct i2c_board_info __initdata beagle_i2c_eeprom[] = {
 
 static int __init omap3_beagle_i2c_init(void)
 {
+	omap3_pmic_get_config(&beagle_twldata,
+			  TWL_COMMON_PDATA_USB | TWL_COMMON_PDATA_AUDIO, 0);
 	omap3_pmic_init("twl4030", &beagle_twldata);
 	/* Bus 3 is attached to the DVI port where devices like the pico DLP
 	 * projector don't work reliably with 400kHz */
diff --git a/arch/arm/mach-omap2/board-omap3evm.c b/arch/arm/mach-omap2/board-omap3evm.c
index b4d4346..3e7e902 100644
--- a/arch/arm/mach-omap2/board-omap3evm.c
+++ b/arch/arm/mach-omap2/board-omap3evm.c
@@ -400,10 +400,6 @@ static struct twl4030_gpio_platform_data omap3evm_gpio_data = {
 	.setup		= omap3evm_twl_gpio_setup,
 };
 
-static struct twl4030_usb_data omap3evm_usb_data = {
-	.usb_mode	= T2_USB_MODE_ULPI,
-};
-
 static uint32_t board_keymap[] = {
 	KEY(0, 0, KEY_LEFT),
 	KEY(0, 1, KEY_DOWN),
@@ -438,17 +434,6 @@ static struct twl4030_keypad_data omap3evm_kp_data = {
 	.rep		= 1,
 };
 
-static struct twl4030_madc_platform_data omap3evm_madc_data = {
-	.irq_line	= 1,
-};
-
-static struct twl4030_codec_audio_data omap3evm_audio_data;
-
-static struct twl4030_codec_data omap3evm_codec_data = {
-	.audio_mclk = 26000000,
-	.audio = &omap3evm_audio_data,
-};
-
 static struct regulator_consumer_supply omap3_evm_vdda_dac_supply =
 	REGULATOR_SUPPLY("vdda_dac", "omapdss_venc");
 
@@ -548,15 +533,9 @@ struct wl12xx_platform_data omap3evm_wlan_data __initdata = {
 #endif
 
 static struct twl4030_platform_data omap3evm_twldata = {
-	.irq_base	= TWL4030_IRQ_BASE,
-	.irq_end	= TWL4030_IRQ_END,
-
 	/* platform_data for children goes here */
 	.keypad		= &omap3evm_kp_data,
-	.madc		= &omap3evm_madc_data,
-	.usb		= &omap3evm_usb_data,
 	.gpio		= &omap3evm_gpio_data,
-	.codec		= &omap3evm_codec_data,
 	.vdac		= &omap3_evm_vdac,
 	.vpll2		= &omap3_evm_vpll2,
 	.vio		= &omap3evm_vio,
@@ -566,6 +545,9 @@ static struct twl4030_platform_data omap3evm_twldata = {
 
 static int __init omap3_evm_i2c_init(void)
 {
+	omap3_pmic_get_config(&omap3evm_twldata,
+			  TWL_COMMON_PDATA_USB | TWL_COMMON_PDATA_MADC |
+			  TWL_COMMON_PDATA_AUDIO, 0);
 	omap3_pmic_init("twl4030", &omap3evm_twldata);
 	omap_register_i2c_bus(2, 400, NULL, 0);
 	omap_register_i2c_bus(3, 400, NULL, 0);
diff --git a/arch/arm/mach-omap2/board-omap3pandora.c b/arch/arm/mach-omap2/board-omap3pandora.c
index 23f71d4..7bfe109 100644
--- a/arch/arm/mach-omap2/board-omap3pandora.c
+++ b/arch/arm/mach-omap2/board-omap3pandora.c
@@ -501,25 +501,10 @@ static struct platform_device pandora_vwlan_device = {
 	},
 };
 
-static struct twl4030_usb_data omap3pandora_usb_data = {
-	.usb_mode	= T2_USB_MODE_ULPI,
-};
-
-static struct twl4030_codec_audio_data omap3pandora_audio_data;
-
-static struct twl4030_codec_data omap3pandora_codec_data = {
-	.audio_mclk = 26000000,
-	.audio = &omap3pandora_audio_data,
-};
-
 static struct twl4030_bci_platform_data pandora_bci_data;
 
 static struct twl4030_platform_data omap3pandora_twldata = {
-	.irq_base	= TWL4030_IRQ_BASE,
-	.irq_end	= TWL4030_IRQ_END,
 	.gpio		= &omap3pandora_gpio_data,
-	.usb		= &omap3pandora_usb_data,
-	.codec		= &omap3pandora_codec_data,
 	.vmmc1		= &pandora_vmmc1,
 	.vmmc2		= &pandora_vmmc2,
 	.vdac		= &pandora_vdac,
@@ -541,6 +526,8 @@ static struct i2c_board_info __initdata omap3pandora_i2c3_boardinfo[] = {
 
 static int __init omap3pandora_i2c_init(void)
 {
+	omap3_pmic_get_config(&omap3pandora_twldata,
+			      TWL_COMMON_PDATA_USB | TWL_COMMON_PDATA_AUDIO, 0);
 	omap3_pmic_init("tps65950", &omap3pandora_twldata);
 	/* i2c2 pins are not connected */
 	omap_register_i2c_bus(3, 100, omap3pandora_i2c3_boardinfo,
diff --git a/arch/arm/mach-omap2/board-omap3stalker.c b/arch/arm/mach-omap2/board-omap3stalker.c
index 0c108a2..2b52281 100644
--- a/arch/arm/mach-omap2/board-omap3stalker.c
+++ b/arch/arm/mach-omap2/board-omap3stalker.c
@@ -354,10 +354,6 @@ static struct twl4030_gpio_platform_data omap3stalker_gpio_data = {
 	.setup		= omap3stalker_twl_gpio_setup,
 };
 
-static struct twl4030_usb_data omap3stalker_usb_data = {
-	.usb_mode	= T2_USB_MODE_ULPI,
-};
-
 static uint32_t board_keymap[] = {
 	KEY(0, 0, KEY_LEFT),
 	KEY(0, 1, KEY_DOWN),
@@ -392,17 +388,6 @@ static struct twl4030_keypad_data omap3stalker_kp_data = {
 	.rep		= 1,
 };
 
-static struct twl4030_madc_platform_data omap3stalker_madc_data = {
-	.irq_line	= 1,
-};
-
-static struct twl4030_codec_audio_data omap3stalker_audio_data;
-
-static struct twl4030_codec_data omap3stalker_codec_data = {
-	.audio_mclk	= 26000000,
-	.audio		= &omap3stalker_audio_data,
-};
-
 static struct regulator_consumer_supply omap3_stalker_vdda_dac_supply =
 	REGULATOR_SUPPLY("vdda_dac", "omapdss_venc");
 
@@ -443,15 +428,9 @@ static struct regulator_init_data omap3_stalker_vpll2 = {
 };
 
 static struct twl4030_platform_data omap3stalker_twldata = {
-	.irq_base	= TWL4030_IRQ_BASE,
-	.irq_end	= TWL4030_IRQ_END,
-
 	/* platform_data for children goes here */
 	.keypad		= &omap3stalker_kp_data,
-	.madc		= &omap3stalker_madc_data,
-	.usb		= &omap3stalker_usb_data,
 	.gpio		= &omap3stalker_gpio_data,
-	.codec		= &omap3stalker_codec_data,
 	.vdac		= &omap3_stalker_vdac,
 	.vpll2		= &omap3_stalker_vpll2,
 	.vmmc1		= &omap3stalker_vmmc1,
@@ -474,6 +453,9 @@ static struct i2c_board_info __initdata omap3stalker_i2c_boardinfo3[] = {
 
 static int __init omap3_stalker_i2c_init(void)
 {
+	omap3_pmic_get_config(&omap3stalker_twldata,
+			TWL_COMMON_PDATA_USB | TWL_COMMON_PDATA_MADC |
+			TWL_COMMON_PDATA_AUDIO, 0);
 	omap3_pmic_init("twl4030", &omap3stalker_twldata);
 	omap_register_i2c_bus(2, 400, NULL, 0);
 	omap_register_i2c_bus(3, 400, omap3stalker_i2c_boardinfo3,
diff --git a/arch/arm/mach-omap2/board-omap3touchbook.c b/arch/arm/mach-omap2/board-omap3touchbook.c
index 5f649fa..094ea80 100644
--- a/arch/arm/mach-omap2/board-omap3touchbook.c
+++ b/arch/arm/mach-omap2/board-omap3touchbook.c
@@ -236,25 +236,9 @@ static struct regulator_init_data touchbook_vpll2 = {
 	.consumer_supplies	= &touchbook_vdvi_supply,
 };
 
-static struct twl4030_usb_data touchbook_usb_data = {
-	.usb_mode	= T2_USB_MODE_ULPI,
-};
-
-static struct twl4030_codec_audio_data touchbook_audio_data;
-
-static struct twl4030_codec_data touchbook_codec_data = {
-	.audio_mclk = 26000000,
-	.audio = &touchbook_audio_data,
-};
-
 static struct twl4030_platform_data touchbook_twldata = {
-	.irq_base	= TWL4030_IRQ_BASE,
-	.irq_end	= TWL4030_IRQ_END,
-
 	/* platform_data for children goes here */
-	.usb		= &touchbook_usb_data,
 	.gpio		= &touchbook_gpio_data,
-	.codec		= &touchbook_codec_data,
 	.vmmc1		= &touchbook_vmmc1,
 	.vsim		= &touchbook_vsim,
 	.vdac		= &touchbook_vdac,
@@ -270,8 +254,9 @@ static struct i2c_board_info __initdata touchBook_i2c_boardinfo[] = {
 static int __init omap3_touchbook_i2c_init(void)
 {
 	/* Standard TouchBook bus */
+	omap3_pmic_get_config(&touchbook_twldata,
+			TWL_COMMON_PDATA_USB | TWL_COMMON_PDATA_AUDIO, 0);
 	omap3_pmic_init("twl4030", &touchbook_twldata);
-
 	/* Additional TouchBook bus */
 	omap_register_i2c_bus(3, 100, touchBook_i2c_boardinfo,
 			ARRAY_SIZE(touchBook_i2c_boardinfo));
diff --git a/arch/arm/mach-omap2/board-overo.c b/arch/arm/mach-omap2/board-overo.c
index 175e1ab..f334829 100644
--- a/arch/arm/mach-omap2/board-overo.c
+++ b/arch/arm/mach-omap2/board-overo.c
@@ -433,10 +433,6 @@ static struct twl4030_gpio_platform_data overo_gpio_data = {
 	.setup		= overo_twl_gpio_setup,
 };
 
-static struct twl4030_usb_data overo_usb_data = {
-	.usb_mode	= T2_USB_MODE_ULPI,
-};
-
 static struct regulator_init_data overo_vmmc1 = {
 	.constraints = {
 		.min_uV			= 1850000,
@@ -480,19 +476,8 @@ static struct regulator_init_data overo_vpll2 = {
 	.consumer_supplies	= overo_vdds_dsi_supply,
 };
 
-static struct twl4030_codec_audio_data overo_audio_data;
-
-static struct twl4030_codec_data overo_codec_data = {
-	.audio_mclk = 26000000,
-	.audio = &overo_audio_data,
-};
-
 static struct twl4030_platform_data overo_twldata = {
-	.irq_base	= TWL4030_IRQ_BASE,
-	.irq_end	= TWL4030_IRQ_END,
 	.gpio		= &overo_gpio_data,
-	.usb		= &overo_usb_data,
-	.codec		= &overo_codec_data,
 	.vmmc1		= &overo_vmmc1,
 	.vdac		= &overo_vdac,
 	.vpll2		= &overo_vpll2,
@@ -500,6 +485,8 @@ static struct twl4030_platform_data overo_twldata = {
 
 static int __init overo_i2c_init(void)
 {
+	omap3_pmic_get_config(&overo_twldata,
+			TWL_COMMON_PDATA_USB | TWL_COMMON_PDATA_AUDIO, 0);
 	omap3_pmic_init("tps65950", &overo_twldata);
 	/* i2c2 pins are used for gpio */
 	omap_register_i2c_bus(3, 400, NULL, 0);
diff --git a/arch/arm/mach-omap2/board-rm680.c b/arch/arm/mach-omap2/board-rm680.c
index 42d10b1..62d6675 100644
--- a/arch/arm/mach-omap2/board-rm680.c
+++ b/arch/arm/mach-omap2/board-rm680.c
@@ -79,20 +79,14 @@ static struct twl4030_gpio_platform_data rm680_gpio_data = {
 	.pulldowns		= BIT(1) | BIT(2) | BIT(8) | BIT(15),
 };
 
-static struct twl4030_usb_data rm680_usb_data = {
-	.usb_mode		= T2_USB_MODE_ULPI,
-};
-
 static struct twl4030_platform_data rm680_twl_data = {
-	.irq_base		= TWL4030_IRQ_BASE,
-	.irq_end		= TWL4030_IRQ_END,
 	.gpio			= &rm680_gpio_data,
-	.usb			= &rm680_usb_data,
 	/* add rest of the children here */
 };
 
 static void __init rm680_i2c_init(void)
 {
+	omap3_pmic_get_config(&rm680_twl_data, TWL_COMMON_PDATA_USB, 0);
 	omap_pmic_init(1, 2900, "twl5031", INT_34XX_SYS_NIRQ, &rm680_twl_data);
 	omap_register_i2c_bus(2, 400, NULL, 0);
 	omap_register_i2c_bus(3, 400, NULL, 0);
diff --git a/arch/arm/mach-omap2/board-rx51-peripherals.c b/arch/arm/mach-omap2/board-rx51-peripherals.c
index 9903667..dc69a7f 100644
--- a/arch/arm/mach-omap2/board-rx51-peripherals.c
+++ b/arch/arm/mach-omap2/board-rx51-peripherals.c
@@ -288,10 +288,6 @@ static struct twl4030_keypad_data rx51_kp_data = {
 	.rep		= 1,
 };
 
-static struct twl4030_madc_platform_data rx51_madc_data = {
-	.irq_line		= 1,
-};
-
 /* Enable input logic and pull all lines up when eMMC is on. */
 static struct omap_board_mux rx51_mmc2_on_mux[] = {
 	OMAP3_MUX(SDMMC2_CMD, OMAP_PIN_INPUT_PULLUP | OMAP_MUX_MODE0),
@@ -600,10 +596,6 @@ static struct twl4030_gpio_platform_data rx51_gpio_data = {
 	.setup			= rx51_twlgpio_setup,
 };
 
-static struct twl4030_usb_data rx51_usb_data = {
-	.usb_mode		= T2_USB_MODE_ULPI,
-};
-
 static struct twl4030_ins sleep_on_seq[] __initdata = {
 /*
  * Turn off everything
@@ -775,14 +767,9 @@ struct twl4030_codec_data rx51_codec_data __initdata = {
 };
 
 static struct twl4030_platform_data rx51_twldata __initdata = {
-	.irq_base		= TWL4030_IRQ_BASE,
-	.irq_end		= TWL4030_IRQ_END,
-
 	/* platform_data for children goes here */
 	.gpio			= &rx51_gpio_data,
 	.keypad			= &rx51_kp_data,
-	.madc			= &rx51_madc_data,
-	.usb			= &rx51_usb_data,
 	.power			= &rx51_t2scripts_data,
 	.codec			= &rx51_codec_data,
 
@@ -847,6 +834,8 @@ static int __init rx51_i2c_init(void)
 		rx51_twldata.vaux3 = &rx51_vaux3_cam;
 	}
 	rx51_twldata.vmmc2 = &rx51_vmmc2;
+	omap3_pmic_get_config(&rx51_twldata,
+			TWL_COMMON_PDATA_USB | TWL_COMMON_PDATA_MADC, 0);
 	omap_pmic_init(1, 2200, "twl5030", INT_34XX_SYS_NIRQ, &rx51_twldata);
 	omap_register_i2c_bus(2, 100, rx51_peripherals_i2c_board_info_2,
 			      ARRAY_SIZE(rx51_peripherals_i2c_board_info_2));
diff --git a/arch/arm/mach-omap2/board-zoom-peripherals.c b/arch/arm/mach-omap2/board-zoom-peripherals.c
index 118c6f5..58c0c6e 100644
--- a/arch/arm/mach-omap2/board-zoom-peripherals.c
+++ b/arch/arm/mach-omap2/board-zoom-peripherals.c
@@ -292,26 +292,6 @@ static void zoom2_set_hs_extmute(int mute)
 	gpio_set_value(ZOOM2_HEADSET_EXTMUTE_GPIO, mute);
 }
 
-static int zoom_batt_table[] = {
-/* 0 C*/
-30800, 29500, 28300, 27100,
-26000, 24900, 23900, 22900, 22000, 21100, 20300, 19400, 18700, 17900,
-17200, 16500, 15900, 15300, 14700, 14100, 13600, 13100, 12600, 12100,
-11600, 11200, 10800, 10400, 10000, 9630,  9280,  8950,  8620,  8310,
-8020,  7730,  7460,  7200,  6950,  6710,  6470,  6250,  6040,  5830,
-5640,  5450,  5260,  5090,  4920,  4760,  4600,  4450,  4310,  4170,
-4040,  3910,  3790,  3670,  3550
-};
-
-static struct twl4030_bci_platform_data zoom_bci_data = {
-	.battery_tmp_tbl	= zoom_batt_table,
-	.tblsize		= ARRAY_SIZE(zoom_batt_table),
-};
-
-static struct twl4030_usb_data zoom_usb_data = {
-	.usb_mode	= T2_USB_MODE_ULPI,
-};
-
 static struct twl4030_gpio_platform_data zoom_gpio_data = {
 	.gpio_base	= OMAP_MAX_GPIO_LINES,
 	.irq_base	= TWL4030_GPIO_IRQ_BASE,
@@ -319,28 +299,10 @@ static struct twl4030_gpio_platform_data zoom_gpio_data = {
 	.setup		= zoom_twl_gpio_setup,
 };
 
-static struct twl4030_madc_platform_data zoom_madc_data = {
-	.irq_line	= 1,
-};
-
-static struct twl4030_codec_audio_data zoom_audio_data;
-
-static struct twl4030_codec_data zoom_codec_data = {
-	.audio_mclk = 26000000,
-	.audio = &zoom_audio_data,
-};
-
 static struct twl4030_platform_data zoom_twldata = {
-	.irq_base	= TWL4030_IRQ_BASE,
-	.irq_end	= TWL4030_IRQ_END,
-
 	/* platform_data for children goes here */
-	.bci		= &zoom_bci_data,
-	.madc		= &zoom_madc_data,
-	.usb		= &zoom_usb_data,
 	.gpio		= &zoom_gpio_data,
 	.keypad		= &zoom_kp_twl4030_data,
-	.codec		= &zoom_codec_data,
 	.vmmc1          = &zoom_vmmc1,
 	.vmmc2          = &zoom_vmmc2,
 	.vsim           = &zoom_vsim,
@@ -350,10 +312,17 @@ static struct twl4030_platform_data zoom_twldata = {
 
 static int __init omap_i2c_init(void)
 {
+	omap3_pmic_get_config(&zoom_twldata,
+			  TWL_COMMON_PDATA_USB | TWL_COMMON_PDATA_BCI |
+			  TWL_COMMON_PDATA_MADC | TWL_COMMON_PDATA_AUDIO, 0);
+
 	if (machine_is_omap_zoom2()) {
-		zoom_audio_data.ramp_delay_value = 3;	/* 161 ms */
-		zoom_audio_data.hs_extmute = 1;
-		zoom_audio_data.set_hs_extmute = zoom2_set_hs_extmute;
+		struct twl4030_codec_audio_data *audio_data;
+		audio_data = zoom_twldata.codec->audio;
+
+		audio_data->ramp_delay_value = 3;	/* 161 ms */
+		audio_data->hs_extmute = 1;
+		audio_data->set_hs_extmute = zoom2_set_hs_extmute;
 	}
 	omap_pmic_init(1, 2400, "twl5030", INT_34XX_SYS_NIRQ, &zoom_twldata);
 	omap_register_i2c_bus(2, 400, NULL, 0);
diff --git a/arch/arm/mach-omap2/twl-common.c b/arch/arm/mach-omap2/twl-common.c
index 5fd644e..2487e3c 100644
--- a/arch/arm/mach-omap2/twl-common.c
+++ b/arch/arm/mach-omap2/twl-common.c
@@ -56,6 +56,37 @@ static struct twl4030_usb_data omap4_usb_pdata = {
 	.phy_suspend	= omap4430_phy_suspend,
 };
 
+static struct twl4030_usb_data omap3_usb_pdata = {
+	.usb_mode	= T2_USB_MODE_ULPI,
+};
+
+static int omap3_batt_table[] = {
+/* 0 C */
+30800, 29500, 28300, 27100,
+26000, 24900, 23900, 22900, 22000, 21100, 20300, 19400, 18700, 17900,
+17200, 16500, 15900, 15300, 14700, 14100, 13600, 13100, 12600, 12100,
+11600, 11200, 10800, 10400, 10000, 9630,  9280,  8950,  8620,  8310,
+8020,  7730,  7460,  7200,  6950,  6710,  6470,  6250,  6040,  5830,
+5640,  5450,  5260,  5090,  4920,  4760,  4600,  4450,  4310,  4170,
+4040,  3910,  3790,  3670,  3550
+};
+
+static struct twl4030_bci_platform_data omap3_bci_pdata = {
+	.battery_tmp_tbl	= omap3_batt_table,
+	.tblsize		= ARRAY_SIZE(omap3_batt_table),
+};
+
+static struct twl4030_madc_platform_data omap3_madc_pdata = {
+	.irq_line	= 1,
+};
+
+static struct twl4030_codec_audio_data omap3_audio;
+
+static struct twl4030_codec_data omap3_codec_pdata = {
+	.audio_mclk = 26000000,
+	.audio = &omap3_audio,
+};
+
 static struct regulator_init_data omap4_vdac_idata = {
 	.constraints = {
 		.min_uV			= 1800000,
@@ -207,3 +238,25 @@ void __init omap4_pmic_get_config(struct twl4030_platform_data *pmic_data,
 	    !pmic_data->clk32kg)
 		pmic_data->clk32kg = &omap4_clk32kg_idata;
 }
+
+void __init omap3_pmic_get_config(struct twl4030_platform_data *pmic_data,
+				  u32 pdata_flags, u32 regulators_flags)
+{
+	if (!pmic_data->irq_base)
+		pmic_data->irq_base = TWL4030_IRQ_BASE;
+	if (!pmic_data->irq_end)
+		pmic_data->irq_end = TWL4030_IRQ_END;
+
+	/* Common platform data configurations */
+	if (pdata_flags & TWL_COMMON_PDATA_USB && !pmic_data->usb)
+		pmic_data->usb = &omap3_usb_pdata;
+
+	if (pdata_flags & TWL_COMMON_PDATA_BCI && !pmic_data->bci)
+		pmic_data->bci = &omap3_bci_pdata;
+
+	if (pdata_flags & TWL_COMMON_PDATA_MADC && !pmic_data->madc)
+		pmic_data->madc = &omap3_madc_pdata;
+
+	if (pdata_flags & TWL_COMMON_PDATA_AUDIO && !pmic_data->codec)
+		pmic_data->codec = &omap3_codec_pdata;
+}
diff --git a/arch/arm/mach-omap2/twl-common.h b/arch/arm/mach-omap2/twl-common.h
index d96c289..3b4b05d 100644
--- a/arch/arm/mach-omap2/twl-common.h
+++ b/arch/arm/mach-omap2/twl-common.h
@@ -2,6 +2,9 @@
 #define __OMAP_PMIC_COMMON__
 
 #define TWL_COMMON_PDATA_USB		(1 << 0)
+#define TWL_COMMON_PDATA_BCI		(1 << 1)
+#define TWL_COMMON_PDATA_MADC		(1 << 2)
+#define TWL_COMMON_PDATA_AUDIO		(1 << 3)
 
 /* Common LDO regulators for TWL4030/TWL6030 */
 #define TWL_COMMON_REGULATOR_VDAC	(1 << 0)
@@ -42,6 +45,9 @@ static inline void omap4_pmic_init(const char *pmic_type,
 	omap_pmic_init(1, 400, pmic_type, OMAP44XX_IRQ_SYS_1N, pmic_data);
 }
 
+void omap3_pmic_get_config(struct twl4030_platform_data *pmic_data,
+			   u32 pdata_flags, u32 regulators_flags);
+
 void omap4_pmic_get_config(struct twl4030_platform_data *pmic_data,
 			   u32 pdata_flags, u32 regulators_flags);
 
-- 
1.7.5.3

