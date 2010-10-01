Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932284Ab0JAL7D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 07:59:03 -0400
Received: from eu1sys200aog105.obsmtp.com ([207.126.144.119]:51191 "EHLO
	eu1sys200aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932197Ab0JAL6e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 07:58:34 -0400
From: Viresh KUMAR <viresh.kumar@st.com>
To: linux-arm-kernel@lists.infradead.org, rtc-linux@googlegroups.com,
        a.zummo@towertech.it, dbrownell@users.sourceforge.net,
        linux-usb@vger.kernel.org, linux-input@vger.kernel.org,
        dmitry.torokhov@gmail.com, linux-mtd@lists.infradead.org,
        dwmw2@infradead.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org
Cc: Vipin Kumar <vipin.kumar@st.com>, shiraz.hashim@st.com,
        deepak.sikri@st.com, armando.visconti@st.com, vipulkumar.samar@st.com,
        rajeev-dlh.kumar@st.com, pratyush.anand@st.com, bhupesh.sharma@st.com,
        Viresh Kumar <viresh.kumar@st.com>
Subject: [PATCH V2 52/69] SPEAr : Pad multiplexing handling modified
Date: Fri,  1 Oct 2010 17:26:12 +0530
Message-Id: <010fe2ef7c21169330673f980543ae15d9a8149e.1285933332.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <cover.1285933331.git.viresh.kumar@st.com>
References: <cover.1285933331.git.viresh.kumar@st.com>
In-Reply-To: <cover.1285933331.git.viresh.kumar@st.com>
References: <cover.1285933331.git.viresh.kumar@st.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vipin Kumar <vipin.kumar@st.com>

Until now, the platform code assumed 1 32 bit register to be used for pad
multiplexing. This assumption is not true for SPEAr13xx devices, so the generic
implementation of pad multiplexing adopts a new concepts of multiple
multiplexing registers.

Signed-off-by: Vipin Kumar <vipin.kumar@st.com>
Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
---
 arch/arm/mach-spear3xx/include/mach/generic.h |    3 +
 arch/arm/mach-spear3xx/spear300.c             |  314 ++++++++++++++----
 arch/arm/mach-spear3xx/spear310.c             |  118 +++++--
 arch/arm/mach-spear3xx/spear320.c             |  387 +++++++++++++++++-----
 arch/arm/mach-spear3xx/spear3xx.c             |  451 ++++++++++++++++++++-----
 arch/arm/plat-spear/include/plat/padmux.h     |   28 ++-
 arch/arm/plat-spear/padmux.c                  |   28 +-
 7 files changed, 1040 insertions(+), 289 deletions(-)

diff --git a/arch/arm/mach-spear3xx/include/mach/generic.h b/arch/arm/mach-spear3xx/include/mach/generic.h
index 1462944..1acb93d 100644
--- a/arch/arm/mach-spear3xx/include/mach/generic.h
+++ b/arch/arm/mach-spear3xx/include/mach/generic.h
@@ -148,6 +148,7 @@ extern struct pmx_dev pmx_telecom_boot_pins;
 extern struct pmx_dev pmx_telecom_sdhci_4bit;
 extern struct pmx_dev pmx_telecom_sdhci_8bit;
 extern struct pmx_dev pmx_gpio1;
+#define PAD_MUX_CONFIG_REG	0x00
 
 /* Add spear300 machine function declarations here */
 void __init spear300_init(void);
@@ -179,6 +180,7 @@ extern struct pmx_dev pmx_uart3_4_5;
 extern struct pmx_dev pmx_fsmc;
 extern struct pmx_dev pmx_rs485_0_1;
 extern struct pmx_dev pmx_tdm0;
+#define PAD_MUX_CONFIG_REG	0x08
 
 /* Add spear310 machine function declarations here */
 void __init spear310_init(void);
@@ -228,6 +230,7 @@ extern struct pmx_dev pmx_mii1;
 extern struct pmx_dev pmx_smii0;
 extern struct pmx_dev pmx_smii1;
 extern struct pmx_dev pmx_i2c1;
+#define PAD_MUX_CONFIG_REG	0x0C
 
 /* Add spear320 machine function declarations here */
 void __init spear320_init(void);
diff --git a/arch/arm/mach-spear3xx/spear300.c b/arch/arm/mach-spear3xx/spear300.c
index 03e050b..0a0485d 100644
--- a/arch/arm/mach-spear3xx/spear300.c
+++ b/arch/arm/mach-spear3xx/spear300.c
@@ -21,8 +21,6 @@
 #include <plat/shirq.h>
 
 /* pad multiplexing support */
-/* muxing registers */
-#define PAD_MUX_CONFIG_REG	0x00
 #define MODE_CONFIG_REG		0x04
 
 /* modes */
@@ -44,87 +42,97 @@
 struct pmx_mode nand_mode = {
 	.id = NAND_MODE,
 	.name = "nand mode",
-	.mask = 0x00,
+	.value = 0x00,
 };
 
 struct pmx_mode nor_mode = {
 	.id = NOR_MODE,
 	.name = "nor mode",
-	.mask = 0x01,
+	.value = 0x01,
 };
 
 struct pmx_mode photo_frame_mode = {
 	.id = PHOTO_FRAME_MODE,
 	.name = "photo frame mode",
-	.mask = 0x02,
+	.value = 0x02,
 };
 
 struct pmx_mode lend_ip_phone_mode = {
 	.id = LEND_IP_PHONE_MODE,
 	.name = "lend ip phone mode",
-	.mask = 0x03,
+	.value = 0x03,
 };
 
 struct pmx_mode hend_ip_phone_mode = {
 	.id = HEND_IP_PHONE_MODE,
 	.name = "hend ip phone mode",
-	.mask = 0x04,
+	.value = 0x04,
 };
 
 struct pmx_mode lend_wifi_phone_mode = {
 	.id = LEND_WIFI_PHONE_MODE,
 	.name = "lend wifi phone mode",
-	.mask = 0x05,
+	.value = 0x05,
 };
 
 struct pmx_mode hend_wifi_phone_mode = {
 	.id = HEND_WIFI_PHONE_MODE,
 	.name = "hend wifi phone mode",
-	.mask = 0x06,
+	.value = 0x06,
 };
 
 struct pmx_mode ata_pabx_wi2s_mode = {
 	.id = ATA_PABX_WI2S_MODE,
 	.name = "ata pabx wi2s mode",
-	.mask = 0x07,
+	.value = 0x07,
 };
 
 struct pmx_mode ata_pabx_i2s_mode = {
 	.id = ATA_PABX_I2S_MODE,
 	.name = "ata pabx i2s mode",
-	.mask = 0x08,
+	.value = 0x08,
 };
 
 struct pmx_mode caml_lcdw_mode = {
 	.id = CAML_LCDW_MODE,
 	.name = "caml lcdw mode",
-	.mask = 0x0C,
+	.value = 0x0C,
 };
 
 struct pmx_mode camu_lcd_mode = {
 	.id = CAMU_LCD_MODE,
 	.name = "camu lcd mode",
-	.mask = 0x0D,
+	.value = 0x0D,
 };
 
 struct pmx_mode camu_wlcd_mode = {
 	.id = CAMU_WLCD_MODE,
 	.name = "camu wlcd mode",
-	.mask = 0x0E,
+	.value = 0x0E,
 };
 
 struct pmx_mode caml_lcd_mode = {
 	.id = CAML_LCD_MODE,
 	.name = "caml lcd mode",
-	.mask = 0x0F,
+	.value = 0x0F,
 };
 
 /* devices */
-struct pmx_dev_mode pmx_fsmc_2_chips_modes[] = {
+/* Pad multiplexing for FSMC 2 NAND devices */
+static struct pmx_mux_reg pmx_fsmc_2_mux[] = {
+	{
+		.offset = PAD_MUX_CONFIG_REG,
+		.mask = PMX_FIRDA_MASK,
+		.value = 0,
+	},
+};
+
+static struct pmx_dev_mode pmx_fsmc_2_chips_modes[] = {
 	{
 		.ids = NAND_MODE | NOR_MODE | PHOTO_FRAME_MODE |
 			ATA_PABX_WI2S_MODE | ATA_PABX_I2S_MODE,
-		.mask = PMX_FIRDA_MASK,
+		.mux_regs = pmx_fsmc_2_mux,
+		.mux_reg_cnt = ARRAY_SIZE(pmx_fsmc_2_mux),
 	},
 };
 
@@ -132,14 +140,23 @@ struct pmx_dev pmx_fsmc_2_chips = {
 	.name = "fsmc_2_chips",
 	.modes = pmx_fsmc_2_chips_modes,
 	.mode_count = ARRAY_SIZE(pmx_fsmc_2_chips_modes),
-	.enb_on_reset = 1,
 };
 
-struct pmx_dev_mode pmx_fsmc_4_chips_modes[] = {
+/* Pad multiplexing for FSMC 4 NAND devices */
+static struct pmx_mux_reg pmx_fsmc_4_mux[] = {
+	{
+		.offset = PAD_MUX_CONFIG_REG,
+		.mask = PMX_FIRDA_MASK | PMX_UART0_MASK,
+		.value = 0,
+	},
+};
+
+static struct pmx_dev_mode pmx_fsmc_4_chips_modes[] = {
 	{
 		.ids = NAND_MODE | NOR_MODE | PHOTO_FRAME_MODE |
 			ATA_PABX_WI2S_MODE | ATA_PABX_I2S_MODE,
-		.mask = PMX_FIRDA_MASK | PMX_UART0_MASK,
+		.mux_regs = pmx_fsmc_4_mux,
+		.mux_reg_cnt = ARRAY_SIZE(pmx_fsmc_4_mux),
 	},
 };
 
@@ -147,16 +164,25 @@ struct pmx_dev pmx_fsmc_4_chips = {
 	.name = "fsmc_4_chips",
 	.modes = pmx_fsmc_4_chips_modes,
 	.mode_count = ARRAY_SIZE(pmx_fsmc_4_chips_modes),
-	.enb_on_reset = 1,
 };
 
-struct pmx_dev_mode pmx_keyboard_modes[] = {
+/* Pad multiplexing for Keyboard device */
+static struct pmx_mux_reg pmx_kbd_mux[] = {
+	{
+		.offset = PAD_MUX_CONFIG_REG,
+		.mask = 0x0,
+		.value = 0,
+	},
+};
+
+static struct pmx_dev_mode pmx_keyboard_modes[] = {
 	{
 		.ids = LEND_IP_PHONE_MODE | HEND_IP_PHONE_MODE |
 			LEND_WIFI_PHONE_MODE | HEND_WIFI_PHONE_MODE |
 			CAML_LCDW_MODE | CAMU_LCD_MODE | CAMU_WLCD_MODE |
 			CAML_LCD_MODE,
-		.mask = 0x0,
+		.mux_regs = pmx_kbd_mux,
+		.mux_reg_cnt = ARRAY_SIZE(pmx_kbd_mux),
 	},
 };
 
@@ -164,17 +190,35 @@ struct pmx_dev pmx_keyboard = {
 	.name = "keyboard",
 	.modes = pmx_keyboard_modes,
 	.mode_count = ARRAY_SIZE(pmx_keyboard_modes),
-	.enb_on_reset = 1,
 };
 
-struct pmx_dev_mode pmx_clcd_modes[] = {
+/* Pad multiplexing for CLCD device */
+static struct pmx_mux_reg pmx_clcd_pfmode_mux[] = {
+	{
+		.offset = PAD_MUX_CONFIG_REG,
+		.mask = PMX_TIMER_1_2_MASK | PMX_TIMER_3_4_MASK,
+		.value = 0,
+	},
+};
+
+static struct pmx_mux_reg pmx_clcd_lcdmode_mux[] = {
+	{
+		.offset = PAD_MUX_CONFIG_REG,
+		.mask = PMX_TIMER_3_4_MASK,
+		.value = 0,
+	},
+};
+
+static struct pmx_dev_mode pmx_clcd_modes[] = {
 	{
 		.ids = PHOTO_FRAME_MODE,
-		.mask = PMX_TIMER_1_2_MASK | PMX_TIMER_3_4_MASK ,
+		.mux_regs = pmx_clcd_pfmode_mux,
+		.mux_reg_cnt = ARRAY_SIZE(pmx_clcd_pfmode_mux),
 	}, {
 		.ids = HEND_IP_PHONE_MODE | HEND_WIFI_PHONE_MODE |
 			CAMU_LCD_MODE | CAML_LCD_MODE,
-		.mask = PMX_TIMER_3_4_MASK,
+		.mux_regs = pmx_clcd_lcdmode_mux,
+		.mux_reg_cnt = ARRAY_SIZE(pmx_clcd_lcdmode_mux),
 	},
 };
 
@@ -182,26 +226,71 @@ struct pmx_dev pmx_clcd = {
 	.name = "clcd",
 	.modes = pmx_clcd_modes,
 	.mode_count = ARRAY_SIZE(pmx_clcd_modes),
-	.enb_on_reset = 1,
 };
 
-struct pmx_dev_mode pmx_telecom_gpio_modes[] = {
+/* Pad multiplexing for Telecom GPIO device */
+static struct pmx_mux_reg pmx_gpio_lcdmode_mux[] = {
 	{
-		.ids = PHOTO_FRAME_MODE | CAMU_LCD_MODE | CAML_LCD_MODE,
+		.offset = PAD_MUX_CONFIG_REG,
 		.mask = PMX_MII_MASK,
+		.value = 0,
+	},
+};
+
+static struct pmx_mux_reg pmx_gpio_fonemode_mux[] = {
+	{
+		.offset = PAD_MUX_CONFIG_REG,
+		.mask = PMX_MII_MASK | PMX_TIMER_1_2_MASK | PMX_TIMER_3_4_MASK,
+		.value = 0,
+	},
+};
+
+static struct pmx_mux_reg pmx_gpio_atai2smode_mux[] = {
+	{
+		.offset = PAD_MUX_CONFIG_REG,
+		.mask = PMX_MII_MASK | PMX_TIMER_3_4_MASK,
+		.value = 0,
+	},
+};
+
+static struct pmx_mux_reg pmx_gpio_lendfonemode_mux[] = {
+	{
+		.offset = PAD_MUX_CONFIG_REG,
+		.mask = PMX_MII_MASK | PMX_TIMER_1_2_MASK,
+		.value = 0,
+	},
+};
+
+static struct pmx_mux_reg pmx_gpio_atawi2smode_mux[] = {
+	{
+		.offset = PAD_MUX_CONFIG_REG,
+		.mask = PMX_MII_MASK | PMX_TIMER_1_2_MASK | PMX_TIMER_3_4_MASK
+			| PMX_UART0_MODEM_MASK,
+		.value = 0,
+	},
+};
+
+static struct pmx_dev_mode pmx_telecom_gpio_modes[] = {
+	{
+		.ids = PHOTO_FRAME_MODE | CAMU_LCD_MODE | CAML_LCD_MODE,
+		.mux_regs = pmx_gpio_lcdmode_mux,
+		.mux_reg_cnt = ARRAY_SIZE(pmx_gpio_lcdmode_mux),
 	}, {
 		.ids = LEND_IP_PHONE_MODE | LEND_WIFI_PHONE_MODE,
-		.mask = PMX_MII_MASK | PMX_TIMER_1_2_MASK | PMX_TIMER_3_4_MASK,
+		.mux_regs = pmx_gpio_fonemode_mux,
+		.mux_reg_cnt = ARRAY_SIZE(pmx_gpio_fonemode_mux),
 	}, {
 		.ids = ATA_PABX_I2S_MODE | CAML_LCDW_MODE | CAMU_WLCD_MODE,
-		.mask = PMX_MII_MASK | PMX_TIMER_3_4_MASK,
+		.mux_regs = pmx_gpio_atai2smode_mux,
+		.mux_reg_cnt = ARRAY_SIZE(pmx_gpio_atai2smode_mux),
 	}, {
 		.ids = HEND_IP_PHONE_MODE | HEND_WIFI_PHONE_MODE,
-		.mask = PMX_MII_MASK | PMX_TIMER_1_2_MASK,
+		.mux_regs = pmx_gpio_lendfonemode_mux,
+		.mux_reg_cnt = ARRAY_SIZE(pmx_gpio_lendfonemode_mux),
 	}, {
 		.ids = ATA_PABX_WI2S_MODE,
-		.mask = PMX_MII_MASK | PMX_TIMER_1_2_MASK | PMX_TIMER_3_4_MASK
-			| PMX_UART0_MODEM_MASK,
+		.mux_regs = pmx_gpio_atawi2smode_mux,
+		.mux_reg_cnt = ARRAY_SIZE(pmx_gpio_atawi2smode_mux),
 	},
 };
 
@@ -209,17 +298,26 @@ struct pmx_dev pmx_telecom_gpio = {
 	.name = "telecom_gpio",
 	.modes = pmx_telecom_gpio_modes,
 	.mode_count = ARRAY_SIZE(pmx_telecom_gpio_modes),
-	.enb_on_reset = 1,
 };
 
-struct pmx_dev_mode pmx_telecom_tdm_modes[] = {
+/* Pad multiplexing for TDM device */
+static struct pmx_mux_reg pmx_tdm_mux[] = {
+	{
+		.offset = PAD_MUX_CONFIG_REG,
+		.mask = PMX_UART0_MODEM_MASK | PMX_SSP_CS_MASK,
+		.value = 0,
+	},
+};
+
+static struct pmx_dev_mode pmx_telecom_tdm_modes[] = {
 	{
 		.ids = PHOTO_FRAME_MODE | LEND_IP_PHONE_MODE |
 			HEND_IP_PHONE_MODE | LEND_WIFI_PHONE_MODE
 			| HEND_WIFI_PHONE_MODE | ATA_PABX_WI2S_MODE
 			| ATA_PABX_I2S_MODE | CAML_LCDW_MODE | CAMU_LCD_MODE
 			| CAMU_WLCD_MODE | CAML_LCD_MODE,
-		.mask = PMX_UART0_MODEM_MASK | PMX_SSP_CS_MASK,
+		.mux_regs = pmx_tdm_mux,
+		.mux_reg_cnt = ARRAY_SIZE(pmx_tdm_mux),
 	},
 };
 
@@ -227,16 +325,25 @@ struct pmx_dev pmx_telecom_tdm = {
 	.name = "telecom_tdm",
 	.modes = pmx_telecom_tdm_modes,
 	.mode_count = ARRAY_SIZE(pmx_telecom_tdm_modes),
-	.enb_on_reset = 1,
 };
 
-struct pmx_dev_mode pmx_telecom_spi_cs_i2c_clk_modes[] = {
+/* Pad multiplexing for spi cs i2c device */
+static struct pmx_mux_reg pmx_spi_cs_i2c_mux[] = {
+	{
+		.offset = PAD_MUX_CONFIG_REG,
+		.mask = PMX_TIMER_1_2_MASK | PMX_TIMER_3_4_MASK,
+		.value = 0,
+	},
+};
+
+static struct pmx_dev_mode pmx_telecom_spi_cs_i2c_clk_modes[] = {
 	{
 		.ids = LEND_IP_PHONE_MODE | HEND_IP_PHONE_MODE |
 			LEND_WIFI_PHONE_MODE | HEND_WIFI_PHONE_MODE
 			| ATA_PABX_WI2S_MODE | ATA_PABX_I2S_MODE |
 			CAML_LCDW_MODE | CAML_LCD_MODE,
-		.mask = PMX_TIMER_1_2_MASK | PMX_TIMER_3_4_MASK,
+		.mux_regs = pmx_spi_cs_i2c_mux,
+		.mux_reg_cnt = ARRAY_SIZE(pmx_spi_cs_i2c_mux),
 	},
 };
 
@@ -244,16 +351,33 @@ struct pmx_dev pmx_telecom_spi_cs_i2c_clk = {
 	.name = "telecom_spi_cs_i2c_clk",
 	.modes = pmx_telecom_spi_cs_i2c_clk_modes,
 	.mode_count = ARRAY_SIZE(pmx_telecom_spi_cs_i2c_clk_modes),
-	.enb_on_reset = 1,
 };
 
-struct pmx_dev_mode pmx_telecom_camera_modes[] = {
+static struct pmx_mux_reg pmx_caml_mux[] = {
 	{
-		.ids = CAML_LCDW_MODE | CAML_LCD_MODE,
+		.offset = PAD_MUX_CONFIG_REG,
 		.mask = PMX_MII_MASK,
+		.value = 0,
+	},
+};
+
+static struct pmx_mux_reg pmx_camu_mux[] = {
+	{
+		.offset = PAD_MUX_CONFIG_REG,
+		.mask = PMX_TIMER_1_2_MASK | PMX_TIMER_3_4_MASK | PMX_MII_MASK,
+		.value = 0,
+	},
+};
+
+static struct pmx_dev_mode pmx_telecom_camera_modes[] = {
+	{
+		.ids = CAML_LCDW_MODE | CAML_LCD_MODE,
+		.mux_regs = pmx_caml_mux,
+		.mux_reg_cnt = ARRAY_SIZE(pmx_caml_mux),
 	}, {
 		.ids = CAMU_LCD_MODE | CAMU_WLCD_MODE,
-		.mask = PMX_TIMER_1_2_MASK | PMX_TIMER_3_4_MASK | PMX_MII_MASK,
+		.mux_regs = pmx_camu_mux,
+		.mux_reg_cnt = ARRAY_SIZE(pmx_camu_mux),
 	},
 };
 
@@ -261,14 +385,23 @@ struct pmx_dev pmx_telecom_camera = {
 	.name = "telecom_camera",
 	.modes = pmx_telecom_camera_modes,
 	.mode_count = ARRAY_SIZE(pmx_telecom_camera_modes),
-	.enb_on_reset = 1,
 };
 
-struct pmx_dev_mode pmx_telecom_dac_modes[] = {
+/* Pad multiplexing for dac device */
+static struct pmx_mux_reg pmx_dac_mux[] = {
+	{
+		.offset = PAD_MUX_CONFIG_REG,
+		.mask = PMX_TIMER_1_2_MASK,
+		.value = 0,
+	},
+};
+
+static struct pmx_dev_mode pmx_telecom_dac_modes[] = {
 	{
 		.ids = ATA_PABX_I2S_MODE | CAML_LCDW_MODE | CAMU_LCD_MODE
 			| CAMU_WLCD_MODE | CAML_LCD_MODE,
-		.mask = PMX_TIMER_1_2_MASK,
+		.mux_regs = pmx_dac_mux,
+		.mux_reg_cnt = ARRAY_SIZE(pmx_dac_mux),
 	},
 };
 
@@ -276,16 +409,25 @@ struct pmx_dev pmx_telecom_dac = {
 	.name = "telecom_dac",
 	.modes = pmx_telecom_dac_modes,
 	.mode_count = ARRAY_SIZE(pmx_telecom_dac_modes),
-	.enb_on_reset = 1,
 };
 
-struct pmx_dev_mode pmx_telecom_i2s_modes[] = {
+/* Pad multiplexing for spi cs i2c device */
+static struct pmx_mux_reg pmx_i2s_mux[] = {
+	{
+		.offset = PAD_MUX_CONFIG_REG,
+		.mask = PMX_UART0_MODEM_MASK,
+		.value = 0,
+	},
+};
+
+static struct pmx_dev_mode pmx_telecom_i2s_modes[] = {
 	{
 		.ids = LEND_IP_PHONE_MODE | HEND_IP_PHONE_MODE
 			| LEND_WIFI_PHONE_MODE | HEND_WIFI_PHONE_MODE |
 			ATA_PABX_I2S_MODE | CAML_LCDW_MODE | CAMU_LCD_MODE
 			| CAMU_WLCD_MODE | CAML_LCD_MODE,
-		.mask = PMX_UART0_MODEM_MASK,
+		.mux_regs = pmx_i2s_mux,
+		.mux_reg_cnt = ARRAY_SIZE(pmx_i2s_mux),
 	},
 };
 
@@ -293,14 +435,23 @@ struct pmx_dev pmx_telecom_i2s = {
 	.name = "telecom_i2s",
 	.modes = pmx_telecom_i2s_modes,
 	.mode_count = ARRAY_SIZE(pmx_telecom_i2s_modes),
-	.enb_on_reset = 1,
 };
 
-struct pmx_dev_mode pmx_telecom_boot_pins_modes[] = {
+/* Pad multiplexing for bootpins device */
+static struct pmx_mux_reg pmx_bootpins_mux[] = {
 	{
-		.ids = NAND_MODE | NOR_MODE,
+		.offset = PAD_MUX_CONFIG_REG,
 		.mask = PMX_UART0_MODEM_MASK | PMX_TIMER_1_2_MASK |
 			PMX_TIMER_3_4_MASK,
+		.value = 0,
+	},
+};
+
+static struct pmx_dev_mode pmx_telecom_boot_pins_modes[] = {
+	{
+		.ids = NAND_MODE | NOR_MODE,
+		.mux_regs = pmx_bootpins_mux,
+		.mux_reg_cnt = ARRAY_SIZE(pmx_bootpins_mux),
 	},
 };
 
@@ -308,19 +459,28 @@ struct pmx_dev pmx_telecom_boot_pins = {
 	.name = "telecom_boot_pins",
 	.modes = pmx_telecom_boot_pins_modes,
 	.mode_count = ARRAY_SIZE(pmx_telecom_boot_pins_modes),
-	.enb_on_reset = 1,
 };
 
-struct pmx_dev_mode pmx_telecom_sdhci_4bit_modes[] = {
+/* Pad multiplexing for sdhci 4bit device */
+static struct pmx_mux_reg pmx_sdhci_4bit_mux[] = {
+	{
+		.offset = PAD_MUX_CONFIG_REG,
+		.mask = PMX_GPIO_PIN0_MASK | PMX_GPIO_PIN1_MASK |
+			PMX_GPIO_PIN2_MASK | PMX_GPIO_PIN3_MASK |
+			PMX_GPIO_PIN4_MASK | PMX_GPIO_PIN5_MASK,
+		.value = 0,
+	},
+};
+
+static struct pmx_dev_mode pmx_telecom_sdhci_4bit_modes[] = {
 	{
 		.ids = PHOTO_FRAME_MODE | LEND_IP_PHONE_MODE |
 			HEND_IP_PHONE_MODE | LEND_WIFI_PHONE_MODE |
 			HEND_WIFI_PHONE_MODE | CAML_LCDW_MODE | CAMU_LCD_MODE |
 			CAMU_WLCD_MODE | CAML_LCD_MODE | ATA_PABX_WI2S_MODE |
 			ATA_PABX_I2S_MODE,
-		.mask = PMX_GPIO_PIN0_MASK | PMX_GPIO_PIN1_MASK |
-			PMX_GPIO_PIN2_MASK | PMX_GPIO_PIN3_MASK |
-			PMX_GPIO_PIN4_MASK | PMX_GPIO_PIN5_MASK,
+		.mux_regs = pmx_sdhci_4bit_mux,
+		.mux_reg_cnt = ARRAY_SIZE(pmx_sdhci_4bit_mux),
 	},
 };
 
@@ -328,18 +488,27 @@ struct pmx_dev pmx_telecom_sdhci_4bit = {
 	.name = "telecom_sdhci_4bit",
 	.modes = pmx_telecom_sdhci_4bit_modes,
 	.mode_count = ARRAY_SIZE(pmx_telecom_sdhci_4bit_modes),
-	.enb_on_reset = 1,
 };
 
-struct pmx_dev_mode pmx_telecom_sdhci_8bit_modes[] = {
+/* Pad multiplexing for spi cs i2c device */
+static struct pmx_mux_reg pmx_sdhci_8bit_mux[] = {
+	{
+		.offset = PAD_MUX_CONFIG_REG,
+		.mask = PMX_GPIO_PIN0_MASK | PMX_GPIO_PIN1_MASK |
+			PMX_GPIO_PIN2_MASK | PMX_GPIO_PIN3_MASK |
+			PMX_GPIO_PIN4_MASK | PMX_GPIO_PIN5_MASK | PMX_MII_MASK,
+		.value = 0,
+	},
+};
+
+static struct pmx_dev_mode pmx_telecom_sdhci_8bit_modes[] = {
 	{
 		.ids = PHOTO_FRAME_MODE | LEND_IP_PHONE_MODE |
 			HEND_IP_PHONE_MODE | LEND_WIFI_PHONE_MODE |
 			HEND_WIFI_PHONE_MODE | CAML_LCDW_MODE | CAMU_LCD_MODE |
 			CAMU_WLCD_MODE | CAML_LCD_MODE,
-		.mask = PMX_GPIO_PIN0_MASK | PMX_GPIO_PIN1_MASK |
-			PMX_GPIO_PIN2_MASK | PMX_GPIO_PIN3_MASK |
-			PMX_GPIO_PIN4_MASK | PMX_GPIO_PIN5_MASK | PMX_MII_MASK,
+		.mux_regs = pmx_sdhci_8bit_mux,
+		.mux_reg_cnt = ARRAY_SIZE(pmx_sdhci_8bit_mux),
 	},
 };
 
@@ -347,14 +516,23 @@ struct pmx_dev pmx_telecom_sdhci_8bit = {
 	.name = "telecom_sdhci_8bit",
 	.modes = pmx_telecom_sdhci_8bit_modes,
 	.mode_count = ARRAY_SIZE(pmx_telecom_sdhci_8bit_modes),
-	.enb_on_reset = 1,
 };
 
-struct pmx_dev_mode pmx_gpio1_modes[] = {
+/* Pad multiplexing for spi cs i2c device */
+static struct pmx_mux_reg pmx_gpio1_mux[] = {
 	{
-		.ids = PHOTO_FRAME_MODE,
+		.offset = PAD_MUX_CONFIG_REG,
 		.mask = PMX_UART0_MODEM_MASK | PMX_TIMER_1_2_MASK |
 			PMX_TIMER_3_4_MASK,
+		.value = 0,
+	},
+};
+
+static struct pmx_dev_mode pmx_gpio1_modes[] = {
+	{
+		.ids = PHOTO_FRAME_MODE,
+		.mux_regs = pmx_gpio1_mux,
+		.mux_reg_cnt = ARRAY_SIZE(pmx_gpio1_mux),
 	},
 };
 
@@ -362,13 +540,11 @@ struct pmx_dev pmx_gpio1 = {
 	.name = "arm gpio1",
 	.modes = pmx_gpio1_modes,
 	.mode_count = ARRAY_SIZE(pmx_gpio1_modes),
-	.enb_on_reset = 1,
 };
 
 /* pmx driver structure */
 struct pmx_driver pmx_driver = {
 	.mode_reg = {.offset = MODE_CONFIG_REG, .mask = 0x0000000f},
-	.mux_reg = {.offset = PAD_MUX_CONFIG_REG, .mask = 0x00007fff},
 };
 
 /* Add spear300 specific devices here */
diff --git a/arch/arm/mach-spear3xx/spear310.c b/arch/arm/mach-spear3xx/spear310.c
index 0d12ee3..548ad56 100644
--- a/arch/arm/mach-spear3xx/spear310.c
+++ b/arch/arm/mach-spear3xx/spear310.c
@@ -21,14 +21,21 @@
 #include <plat/shirq.h>
 
 /* pad multiplexing support */
-/* muxing registers */
-#define PAD_MUX_CONFIG_REG	0x08
 
 /* devices */
-struct pmx_dev_mode pmx_emi_cs_0_1_4_5_modes[] = {
+/* Pad multiplexing for emi_cs_0_1_4_5 devices */
+static struct pmx_mux_reg pmx_emi_cs_0_1_4_5_mux[] = {
 	{
-		.ids = 0x00,
+		.offset = PAD_MUX_CONFIG_REG,
 		.mask = PMX_TIMER_3_4_MASK,
+		.value = 0,
+	},
+};
+
+static struct pmx_dev_mode pmx_emi_cs_0_1_4_5_modes[] = {
+	{
+		.mux_regs = pmx_emi_cs_0_1_4_5_mux,
+		.mux_reg_cnt = ARRAY_SIZE(pmx_emi_cs_0_1_4_5_mux),
 	},
 };
 
@@ -36,13 +43,21 @@ struct pmx_dev pmx_emi_cs_0_1_4_5 = {
 	.name = "emi_cs_0_1_4_5",
 	.modes = pmx_emi_cs_0_1_4_5_modes,
 	.mode_count = ARRAY_SIZE(pmx_emi_cs_0_1_4_5_modes),
-	.enb_on_reset = 1,
 };
 
-struct pmx_dev_mode pmx_emi_cs_2_3_modes[] = {
+/* Pad multiplexing for emi_cs_2_3 devices */
+static struct pmx_mux_reg pmx_emi_cs_2_3_mux[] = {
 	{
-		.ids = 0x00,
+		.offset = PAD_MUX_CONFIG_REG,
 		.mask = PMX_TIMER_1_2_MASK,
+		.value = 0,
+	},
+};
+
+static struct pmx_dev_mode pmx_emi_cs_2_3_modes[] = {
+	{
+		.mux_regs = pmx_emi_cs_2_3_mux,
+		.mux_reg_cnt = ARRAY_SIZE(pmx_emi_cs_2_3_mux),
 	},
 };
 
@@ -50,13 +65,21 @@ struct pmx_dev pmx_emi_cs_2_3 = {
 	.name = "emi_cs_2_3",
 	.modes = pmx_emi_cs_2_3_modes,
 	.mode_count = ARRAY_SIZE(pmx_emi_cs_2_3_modes),
-	.enb_on_reset = 1,
 };
 
-struct pmx_dev_mode pmx_uart1_modes[] = {
+/* Pad multiplexing for uart1 device */
+static struct pmx_mux_reg pmx_uart1_mux[] = {
 	{
-		.ids = 0x00,
+		.offset = PAD_MUX_CONFIG_REG,
 		.mask = PMX_FIRDA_MASK,
+		.value = 0,
+	},
+};
+
+static struct pmx_dev_mode pmx_uart1_modes[] = {
+	{
+		.mux_regs = pmx_uart1_mux,
+		.mux_reg_cnt = ARRAY_SIZE(pmx_uart1_mux),
 	},
 };
 
@@ -64,13 +87,21 @@ struct pmx_dev pmx_uart1 = {
 	.name = "uart1",
 	.modes = pmx_uart1_modes,
 	.mode_count = ARRAY_SIZE(pmx_uart1_modes),
-	.enb_on_reset = 1,
 };
 
-struct pmx_dev_mode pmx_uart2_modes[] = {
+/* Pad multiplexing for uart2 device */
+static struct pmx_mux_reg pmx_uart2_mux[] = {
 	{
-		.ids = 0x00,
+		.offset = PAD_MUX_CONFIG_REG,
 		.mask = PMX_TIMER_1_2_MASK,
+		.value = 0,
+	},
+};
+
+static struct pmx_dev_mode pmx_uart2_modes[] = {
+	{
+		.mux_regs = pmx_uart2_mux,
+		.mux_reg_cnt = ARRAY_SIZE(pmx_uart2_mux),
 	},
 };
 
@@ -78,13 +109,21 @@ struct pmx_dev pmx_uart2 = {
 	.name = "uart2",
 	.modes = pmx_uart2_modes,
 	.mode_count = ARRAY_SIZE(pmx_uart2_modes),
-	.enb_on_reset = 1,
 };
 
-struct pmx_dev_mode pmx_uart3_4_5_modes[] = {
+/* Pad multiplexing for uart3_4_5 devices */
+static struct pmx_mux_reg pmx_uart3_4_5_mux[] = {
 	{
-		.ids = 0x00,
+		.offset = PAD_MUX_CONFIG_REG,
 		.mask = PMX_UART0_MODEM_MASK,
+		.value = 0,
+	},
+};
+
+static struct pmx_dev_mode pmx_uart3_4_5_modes[] = {
+	{
+		.mux_regs = pmx_uart3_4_5_mux,
+		.mux_reg_cnt = ARRAY_SIZE(pmx_uart3_4_5_mux),
 	},
 };
 
@@ -92,13 +131,21 @@ struct pmx_dev pmx_uart3_4_5 = {
 	.name = "uart3_4_5",
 	.modes = pmx_uart3_4_5_modes,
 	.mode_count = ARRAY_SIZE(pmx_uart3_4_5_modes),
-	.enb_on_reset = 1,
 };
 
-struct pmx_dev_mode pmx_fsmc_modes[] = {
+/* Pad multiplexing for fsmc device */
+static struct pmx_mux_reg pmx_fsmc_mux[] = {
 	{
-		.ids = 0x00,
+		.offset = PAD_MUX_CONFIG_REG,
 		.mask = PMX_SSP_CS_MASK,
+		.value = 0,
+	},
+};
+
+static struct pmx_dev_mode pmx_fsmc_modes[] = {
+	{
+		.mux_regs = pmx_fsmc_mux,
+		.mux_reg_cnt = ARRAY_SIZE(pmx_fsmc_mux),
 	},
 };
 
@@ -106,13 +153,21 @@ struct pmx_dev pmx_fsmc = {
 	.name = "fsmc",
 	.modes = pmx_fsmc_modes,
 	.mode_count = ARRAY_SIZE(pmx_fsmc_modes),
-	.enb_on_reset = 1,
 };
 
-struct pmx_dev_mode pmx_rs485_0_1_modes[] = {
+/* Pad multiplexing for rs485_0_1 devices */
+static struct pmx_mux_reg pmx_rs485_0_1_mux[] = {
 	{
-		.ids = 0x00,
+		.offset = PAD_MUX_CONFIG_REG,
 		.mask = PMX_MII_MASK,
+		.value = 0,
+	},
+};
+
+static struct pmx_dev_mode pmx_rs485_0_1_modes[] = {
+	{
+		.mux_regs = pmx_rs485_0_1_mux,
+		.mux_reg_cnt = ARRAY_SIZE(pmx_rs485_0_1_mux),
 	},
 };
 
@@ -120,13 +175,21 @@ struct pmx_dev pmx_rs485_0_1 = {
 	.name = "rs485_0_1",
 	.modes = pmx_rs485_0_1_modes,
 	.mode_count = ARRAY_SIZE(pmx_rs485_0_1_modes),
-	.enb_on_reset = 1,
 };
 
-struct pmx_dev_mode pmx_tdm0_modes[] = {
+/* Pad multiplexing for tdm0 device */
+static struct pmx_mux_reg pmx_tdm0_mux[] = {
 	{
-		.ids = 0x00,
+		.offset = PAD_MUX_CONFIG_REG,
 		.mask = PMX_MII_MASK,
+		.value = 0,
+	},
+};
+
+static struct pmx_dev_mode pmx_tdm0_modes[] = {
+	{
+		.mux_regs = pmx_tdm0_mux,
+		.mux_reg_cnt = ARRAY_SIZE(pmx_tdm0_mux),
 	},
 };
 
@@ -134,13 +197,10 @@ struct pmx_dev pmx_tdm0 = {
 	.name = "tdm0",
 	.modes = pmx_tdm0_modes,
 	.mode_count = ARRAY_SIZE(pmx_tdm0_modes),
-	.enb_on_reset = 1,
 };
 
 /* pmx driver structure */
-struct pmx_driver pmx_driver = {
-	.mux_reg = {.offset = PAD_MUX_CONFIG_REG, .mask = 0x00007fff},
-};
+struct pmx_driver pmx_driver;
 
 /* Add spear310 specific devices here */
 /* uart1 device registeration */
diff --git a/arch/arm/mach-spear3xx/spear320.c b/arch/arm/mach-spear3xx/spear320.c
index ae09245..c9f5737c 100644
--- a/arch/arm/mach-spear3xx/spear320.c
+++ b/arch/arm/mach-spear3xx/spear320.c
@@ -24,8 +24,6 @@
 #include <plat/shirq.h>
 
 /* pad multiplexing support */
-/* muxing registers */
-#define PAD_MUX_CONFIG_REG	0x0C
 #define MODE_CONFIG_REG		0x10
 
 /* modes */
@@ -38,32 +36,42 @@
 struct pmx_mode auto_net_smii_mode = {
 	.id = AUTO_NET_SMII_MODE,
 	.name = "Automation Networking SMII Mode",
-	.mask = 0x00,
+	.value = 0x00,
 };
 
 struct pmx_mode auto_net_mii_mode = {
 	.id = AUTO_NET_MII_MODE,
 	.name = "Automation Networking MII Mode",
-	.mask = 0x01,
+	.value = 0x01,
 };
 
 struct pmx_mode auto_exp_mode = {
 	.id = AUTO_EXP_MODE,
 	.name = "Automation Expanded Mode",
-	.mask = 0x02,
+	.value = 0x02,
 };
 
 struct pmx_mode small_printers_mode = {
 	.id = SMALL_PRINTERS_MODE,
 	.name = "Small Printers Mode",
-	.mask = 0x03,
+	.value = 0x03,
 };
 
 /* devices */
-struct pmx_dev_mode pmx_clcd_modes[] = {
+/* Pad multiplexing for CLCD device */
+static struct pmx_mux_reg pmx_clcd_mux[] = {
 	{
-		.ids = AUTO_NET_SMII_MODE,
+		.offset = PAD_MUX_CONFIG_REG,
 		.mask = 0x0,
+		.value = 0,
+	},
+};
+
+static struct pmx_dev_mode pmx_clcd_modes[] = {
+	{
+		.ids = AUTO_NET_SMII_MODE,
+		.mux_regs = pmx_clcd_mux,
+		.mux_reg_cnt = ARRAY_SIZE(pmx_clcd_mux),
 	},
 };
 
@@ -71,13 +79,22 @@ struct pmx_dev pmx_clcd = {
 	.name = "clcd",
 	.modes = pmx_clcd_modes,
 	.mode_count = ARRAY_SIZE(pmx_clcd_modes),
-	.enb_on_reset = 1,
 };
 
-struct pmx_dev_mode pmx_emi_modes[] = {
+/* Pad multiplexing for EMI (Parallel NOR flash) device */
+static struct pmx_mux_reg pmx_emi_mux[] = {
 	{
-		.ids = AUTO_EXP_MODE,
+		.offset = PAD_MUX_CONFIG_REG,
 		.mask = PMX_TIMER_1_2_MASK | PMX_TIMER_3_4_MASK,
+		.value = 0,
+	},
+};
+
+static struct pmx_dev_mode pmx_emi_modes[] = {
+	{
+		.ids = AUTO_EXP_MODE,
+		.mux_regs = pmx_emi_mux,
+		.mux_reg_cnt = ARRAY_SIZE(pmx_emi_mux),
 	},
 };
 
@@ -85,13 +102,22 @@ struct pmx_dev pmx_emi = {
 	.name = "emi",
 	.modes = pmx_emi_modes,
 	.mode_count = ARRAY_SIZE(pmx_emi_modes),
-	.enb_on_reset = 1,
 };
 
-struct pmx_dev_mode pmx_fsmc_modes[] = {
+/* Pad multiplexing for FSMC (NAND flash) device */
+static struct pmx_mux_reg pmx_fsmc_mux[] = {
 	{
-		.ids = ALL_MODES,
+		.offset = PAD_MUX_CONFIG_REG,
 		.mask = 0x0,
+		.value = 0,
+	},
+};
+
+static struct pmx_dev_mode pmx_fsmc_modes[] = {
+	{
+		.ids = ALL_MODES,
+		.mux_regs = pmx_fsmc_mux,
+		.mux_reg_cnt = ARRAY_SIZE(pmx_fsmc_mux),
 	},
 };
 
@@ -99,13 +125,22 @@ struct pmx_dev pmx_fsmc = {
 	.name = "fsmc",
 	.modes = pmx_fsmc_modes,
 	.mode_count = ARRAY_SIZE(pmx_fsmc_modes),
-	.enb_on_reset = 1,
 };
 
-struct pmx_dev_mode pmx_spp_modes[] = {
+/* Pad multiplexing for SPP device */
+static struct pmx_mux_reg pmx_spp_mux[] = {
 	{
-		.ids = SMALL_PRINTERS_MODE,
+		.offset = PAD_MUX_CONFIG_REG,
 		.mask = 0x0,
+		.value = 0,
+	},
+};
+
+static struct pmx_dev_mode pmx_spp_modes[] = {
+	{
+		.ids = SMALL_PRINTERS_MODE,
+		.mux_regs = pmx_spp_mux,
+		.mux_reg_cnt = ARRAY_SIZE(pmx_spp_mux),
 	},
 };
 
@@ -113,14 +148,23 @@ struct pmx_dev pmx_spp = {
 	.name = "spp",
 	.modes = pmx_spp_modes,
 	.mode_count = ARRAY_SIZE(pmx_spp_modes),
-	.enb_on_reset = 1,
 };
 
-struct pmx_dev_mode pmx_sdhci_modes[] = {
+/* Pad multiplexing for SDHCI device */
+static struct pmx_mux_reg pmx_sdhci_mux[] = {
+	{
+		.offset = PAD_MUX_CONFIG_REG,
+		.mask = PMX_TIMER_1_2_MASK | PMX_TIMER_3_4_MASK,
+		.value = 0,
+	},
+};
+
+static struct pmx_dev_mode pmx_sdhci_modes[] = {
 	{
 		.ids = AUTO_NET_SMII_MODE | AUTO_NET_MII_MODE |
 			SMALL_PRINTERS_MODE,
-		.mask = PMX_TIMER_1_2_MASK | PMX_TIMER_3_4_MASK,
+		.mux_regs = pmx_sdhci_mux,
+		.mux_reg_cnt = ARRAY_SIZE(pmx_sdhci_mux),
 	},
 };
 
@@ -128,13 +172,22 @@ struct pmx_dev pmx_sdhci = {
 	.name = "sdhci",
 	.modes = pmx_sdhci_modes,
 	.mode_count = ARRAY_SIZE(pmx_sdhci_modes),
-	.enb_on_reset = 1,
 };
 
-struct pmx_dev_mode pmx_i2s_modes[] = {
+/* Pad multiplexing for I2S device */
+static struct pmx_mux_reg pmx_i2s_mux[] = {
 	{
-		.ids = AUTO_NET_SMII_MODE | AUTO_NET_MII_MODE,
+		.offset = PAD_MUX_CONFIG_REG,
 		.mask = PMX_UART0_MODEM_MASK,
+		.value = 0,
+	},
+};
+
+static struct pmx_dev_mode pmx_i2s_modes[] = {
+	{
+		.ids = AUTO_NET_SMII_MODE | AUTO_NET_MII_MODE,
+		.mux_regs = pmx_i2s_mux,
+		.mux_reg_cnt = ARRAY_SIZE(pmx_i2s_mux),
 	},
 };
 
@@ -142,13 +195,22 @@ struct pmx_dev pmx_i2s = {
 	.name = "i2s",
 	.modes = pmx_i2s_modes,
 	.mode_count = ARRAY_SIZE(pmx_i2s_modes),
-	.enb_on_reset = 1,
 };
 
-struct pmx_dev_mode pmx_uart1_modes[] = {
+/* Pad multiplexing for UART1 device */
+static struct pmx_mux_reg pmx_uart1_mux[] = {
 	{
-		.ids = ALL_MODES,
+		.offset = PAD_MUX_CONFIG_REG,
 		.mask = PMX_GPIO_PIN0_MASK | PMX_GPIO_PIN1_MASK,
+		.value = 0,
+	},
+};
+
+static struct pmx_dev_mode pmx_uart1_modes[] = {
+	{
+		.ids = ALL_MODES,
+		.mux_regs = pmx_uart1_mux,
+		.mux_reg_cnt = ARRAY_SIZE(pmx_uart1_mux),
 	},
 };
 
@@ -156,18 +218,36 @@ struct pmx_dev pmx_uart1 = {
 	.name = "uart1",
 	.modes = pmx_uart1_modes,
 	.mode_count = ARRAY_SIZE(pmx_uart1_modes),
-	.enb_on_reset = 1,
 };
 
-struct pmx_dev_mode pmx_uart1_modem_modes[] = {
+/* Pad multiplexing for UART1 Modem device */
+static struct pmx_mux_reg pmx_uart1_modem_autoexp_mux[] = {
 	{
-		.ids = AUTO_EXP_MODE,
+		.offset = PAD_MUX_CONFIG_REG,
 		.mask = PMX_TIMER_1_2_MASK | PMX_TIMER_3_4_MASK |
 			PMX_SSP_CS_MASK,
-	}, {
-		.ids = SMALL_PRINTERS_MODE,
+		.value = 0,
+	},
+};
+
+static struct pmx_mux_reg pmx_uart1_modem_smallpri_mux[] = {
+	{
+		.offset = PAD_MUX_CONFIG_REG,
 		.mask = PMX_GPIO_PIN3_MASK | PMX_GPIO_PIN4_MASK |
 			PMX_GPIO_PIN5_MASK | PMX_SSP_CS_MASK,
+		.value = 0,
+	},
+};
+
+static struct pmx_dev_mode pmx_uart1_modem_modes[] = {
+	{
+		.ids = AUTO_EXP_MODE,
+		.mux_regs = pmx_uart1_modem_autoexp_mux,
+		.mux_reg_cnt = ARRAY_SIZE(pmx_uart1_modem_autoexp_mux),
+	}, {
+		.ids = SMALL_PRINTERS_MODE,
+		.mux_regs = pmx_uart1_modem_smallpri_mux,
+		.mux_reg_cnt = ARRAY_SIZE(pmx_uart1_modem_smallpri_mux),
 	},
 };
 
@@ -175,13 +255,22 @@ struct pmx_dev pmx_uart1_modem = {
 	.name = "uart1_modem",
 	.modes = pmx_uart1_modem_modes,
 	.mode_count = ARRAY_SIZE(pmx_uart1_modem_modes),
-	.enb_on_reset = 1,
 };
 
-struct pmx_dev_mode pmx_uart2_modes[] = {
+/* Pad multiplexing for UART2 device */
+static struct pmx_mux_reg pmx_uart2_mux[] = {
 	{
-		.ids = ALL_MODES,
+		.offset = PAD_MUX_CONFIG_REG,
 		.mask = PMX_FIRDA_MASK,
+		.value = 0,
+	},
+};
+
+static struct pmx_dev_mode pmx_uart2_modes[] = {
+	{
+		.ids = ALL_MODES,
+		.mux_regs = pmx_uart2_mux,
+		.mux_reg_cnt = ARRAY_SIZE(pmx_uart2_mux),
 	},
 };
 
@@ -189,13 +278,22 @@ struct pmx_dev pmx_uart2 = {
 	.name = "uart2",
 	.modes = pmx_uart2_modes,
 	.mode_count = ARRAY_SIZE(pmx_uart2_modes),
-	.enb_on_reset = 1,
 };
 
-struct pmx_dev_mode pmx_touchscreen_modes[] = {
+/* Pad multiplexing for Touchscreen device */
+static struct pmx_mux_reg pmx_touchscreen_mux[] = {
 	{
-		.ids = AUTO_NET_SMII_MODE,
+		.offset = PAD_MUX_CONFIG_REG,
 		.mask = PMX_SSP_CS_MASK,
+		.value = 0,
+	},
+};
+
+static struct pmx_dev_mode pmx_touchscreen_modes[] = {
+	{
+		.ids = AUTO_NET_SMII_MODE,
+		.mux_regs = pmx_touchscreen_mux,
+		.mux_reg_cnt = ARRAY_SIZE(pmx_touchscreen_mux),
 	},
 };
 
@@ -203,14 +301,23 @@ struct pmx_dev pmx_touchscreen = {
 	.name = "touchscreen",
 	.modes = pmx_touchscreen_modes,
 	.mode_count = ARRAY_SIZE(pmx_touchscreen_modes),
-	.enb_on_reset = 1,
 };
 
-struct pmx_dev_mode pmx_can_modes[] = {
+/* Pad multiplexing for CAN device */
+static struct pmx_mux_reg pmx_can_mux[] = {
 	{
-		.ids = AUTO_NET_SMII_MODE | AUTO_NET_MII_MODE | AUTO_EXP_MODE,
+		.offset = PAD_MUX_CONFIG_REG,
 		.mask = PMX_GPIO_PIN2_MASK | PMX_GPIO_PIN3_MASK |
 			PMX_GPIO_PIN4_MASK | PMX_GPIO_PIN5_MASK,
+		.value = 0,
+	},
+};
+
+static struct pmx_dev_mode pmx_can_modes[] = {
+	{
+		.ids = AUTO_NET_SMII_MODE | AUTO_NET_MII_MODE | AUTO_EXP_MODE,
+		.mux_regs = pmx_can_mux,
+		.mux_reg_cnt = ARRAY_SIZE(pmx_can_mux),
 	},
 };
 
@@ -218,13 +325,22 @@ struct pmx_dev pmx_can = {
 	.name = "can",
 	.modes = pmx_can_modes,
 	.mode_count = ARRAY_SIZE(pmx_can_modes),
-	.enb_on_reset = 1,
 };
 
-struct pmx_dev_mode pmx_sdhci_led_modes[] = {
+/* Pad multiplexing for SDHCI LED device */
+static struct pmx_mux_reg pmx_sdhci_led_mux[] = {
 	{
-		.ids = AUTO_NET_SMII_MODE | AUTO_NET_MII_MODE,
+		.offset = PAD_MUX_CONFIG_REG,
 		.mask = PMX_SSP_CS_MASK,
+		.value = 0,
+	},
+};
+
+static struct pmx_dev_mode pmx_sdhci_led_modes[] = {
+	{
+		.ids = AUTO_NET_SMII_MODE | AUTO_NET_MII_MODE,
+		.mux_regs = pmx_sdhci_led_mux,
+		.mux_reg_cnt = ARRAY_SIZE(pmx_sdhci_led_mux),
 	},
 };
 
@@ -232,16 +348,34 @@ struct pmx_dev pmx_sdhci_led = {
 	.name = "sdhci_led",
 	.modes = pmx_sdhci_led_modes,
 	.mode_count = ARRAY_SIZE(pmx_sdhci_led_modes),
-	.enb_on_reset = 1,
 };
 
-struct pmx_dev_mode pmx_pwm0_modes[] = {
+/* Pad multiplexing for PWM0 device */
+static struct pmx_mux_reg pmx_pwm0_net_mux[] = {
 	{
-		.ids = AUTO_NET_SMII_MODE | AUTO_NET_MII_MODE,
+		.offset = PAD_MUX_CONFIG_REG,
 		.mask = PMX_UART0_MODEM_MASK,
+		.value = 0,
+	},
+};
+
+static struct pmx_mux_reg pmx_pwm0_autoexpsmallpri_mux[] = {
+	{
+		.offset = PAD_MUX_CONFIG_REG,
+		.mask = PMX_MII_MASK,
+		.value = 0,
+	},
+};
+
+static struct pmx_dev_mode pmx_pwm0_modes[] = {
+	{
+		.ids = AUTO_NET_SMII_MODE | AUTO_NET_MII_MODE,
+		.mux_regs = pmx_pwm0_net_mux,
+		.mux_reg_cnt = ARRAY_SIZE(pmx_pwm0_net_mux),
 	}, {
 		.ids = AUTO_EXP_MODE | SMALL_PRINTERS_MODE,
-		.mask = PMX_MII_MASK,
+		.mux_regs = pmx_pwm0_autoexpsmallpri_mux,
+		.mux_reg_cnt = ARRAY_SIZE(pmx_pwm0_autoexpsmallpri_mux),
 	},
 };
 
@@ -249,16 +383,34 @@ struct pmx_dev pmx_pwm0 = {
 	.name = "pwm0",
 	.modes = pmx_pwm0_modes,
 	.mode_count = ARRAY_SIZE(pmx_pwm0_modes),
-	.enb_on_reset = 1,
 };
 
-struct pmx_dev_mode pmx_pwm1_modes[] = {
+/* Pad multiplexing for PWM1 device */
+static struct pmx_mux_reg pmx_pwm1_net_mux[] = {
 	{
-		.ids = AUTO_NET_SMII_MODE | AUTO_NET_MII_MODE,
+		.offset = PAD_MUX_CONFIG_REG,
 		.mask = PMX_UART0_MODEM_MASK,
+		.value = 0,
+	},
+};
+
+static struct pmx_mux_reg pmx_pwm1_autoexpsmallpri_mux[] = {
+	{
+		.offset = PAD_MUX_CONFIG_REG,
+		.mask = PMX_MII_MASK,
+		.value = 0,
+	},
+};
+
+static struct pmx_dev_mode pmx_pwm1_modes[] = {
+	{
+		.ids = AUTO_NET_SMII_MODE | AUTO_NET_MII_MODE,
+		.mux_regs = pmx_pwm1_net_mux,
+		.mux_reg_cnt = ARRAY_SIZE(pmx_pwm1_net_mux),
 	}, {
 		.ids = AUTO_EXP_MODE | SMALL_PRINTERS_MODE,
-		.mask = PMX_MII_MASK,
+		.mux_regs = pmx_pwm1_autoexpsmallpri_mux,
+		.mux_reg_cnt = ARRAY_SIZE(pmx_pwm1_autoexpsmallpri_mux),
 	},
 };
 
@@ -266,16 +418,34 @@ struct pmx_dev pmx_pwm1 = {
 	.name = "pwm1",
 	.modes = pmx_pwm1_modes,
 	.mode_count = ARRAY_SIZE(pmx_pwm1_modes),
-	.enb_on_reset = 1,
 };
 
-struct pmx_dev_mode pmx_pwm2_modes[] = {
+/* Pad multiplexing for PWM2 device */
+static struct pmx_mux_reg pmx_pwm2_net_mux[] = {
 	{
-		.ids = AUTO_NET_SMII_MODE | AUTO_NET_MII_MODE,
+		.offset = PAD_MUX_CONFIG_REG,
 		.mask = PMX_SSP_CS_MASK,
+		.value = 0,
+	},
+};
+
+static struct pmx_mux_reg pmx_pwm2_autoexpsmallpri_mux[] = {
+	{
+		.offset = PAD_MUX_CONFIG_REG,
+		.mask = PMX_MII_MASK,
+		.value = 0,
+	},
+};
+
+static struct pmx_dev_mode pmx_pwm2_modes[] = {
+	{
+		.ids = AUTO_NET_SMII_MODE | AUTO_NET_MII_MODE,
+		.mux_regs = pmx_pwm2_net_mux,
+		.mux_reg_cnt = ARRAY_SIZE(pmx_pwm2_net_mux),
 	}, {
 		.ids = AUTO_EXP_MODE | SMALL_PRINTERS_MODE,
-		.mask = PMX_MII_MASK,
+		.mux_regs = pmx_pwm2_autoexpsmallpri_mux,
+		.mux_reg_cnt = ARRAY_SIZE(pmx_pwm2_autoexpsmallpri_mux),
 	},
 };
 
@@ -283,13 +453,22 @@ struct pmx_dev pmx_pwm2 = {
 	.name = "pwm2",
 	.modes = pmx_pwm2_modes,
 	.mode_count = ARRAY_SIZE(pmx_pwm2_modes),
-	.enb_on_reset = 1,
 };
 
-struct pmx_dev_mode pmx_pwm3_modes[] = {
+/* Pad multiplexing for PWM3 device */
+static struct pmx_mux_reg pmx_pwm3_mux[] = {
 	{
-		.ids = AUTO_EXP_MODE | SMALL_PRINTERS_MODE | AUTO_NET_SMII_MODE,
+		.offset = PAD_MUX_CONFIG_REG,
 		.mask = PMX_MII_MASK,
+		.value = 0,
+	},
+};
+
+static struct pmx_dev_mode pmx_pwm3_modes[] = {
+	{
+		.ids = AUTO_EXP_MODE | SMALL_PRINTERS_MODE | AUTO_NET_SMII_MODE,
+		.mux_regs = pmx_pwm3_mux,
+		.mux_reg_cnt = ARRAY_SIZE(pmx_pwm3_mux),
 	},
 };
 
@@ -297,13 +476,22 @@ struct pmx_dev pmx_pwm3 = {
 	.name = "pwm3",
 	.modes = pmx_pwm3_modes,
 	.mode_count = ARRAY_SIZE(pmx_pwm3_modes),
-	.enb_on_reset = 1,
 };
 
-struct pmx_dev_mode pmx_ssp1_modes[] = {
+/* Pad multiplexing for SSP1 device */
+static struct pmx_mux_reg pmx_ssp1_mux[] = {
 	{
-		.ids = SMALL_PRINTERS_MODE | AUTO_NET_SMII_MODE,
+		.offset = PAD_MUX_CONFIG_REG,
 		.mask = PMX_MII_MASK,
+		.value = 0,
+	},
+};
+
+static struct pmx_dev_mode pmx_ssp1_modes[] = {
+	{
+		.ids = SMALL_PRINTERS_MODE | AUTO_NET_SMII_MODE,
+		.mux_regs = pmx_ssp1_mux,
+		.mux_reg_cnt = ARRAY_SIZE(pmx_ssp1_mux),
 	},
 };
 
@@ -311,13 +499,22 @@ struct pmx_dev pmx_ssp1 = {
 	.name = "ssp1",
 	.modes = pmx_ssp1_modes,
 	.mode_count = ARRAY_SIZE(pmx_ssp1_modes),
-	.enb_on_reset = 1,
 };
 
-struct pmx_dev_mode pmx_ssp2_modes[] = {
+/* Pad multiplexing for SSP2 device */
+static struct pmx_mux_reg pmx_ssp2_mux[] = {
 	{
-		.ids = AUTO_NET_SMII_MODE,
+		.offset = PAD_MUX_CONFIG_REG,
 		.mask = PMX_MII_MASK,
+		.value = 0,
+	},
+};
+
+static struct pmx_dev_mode pmx_ssp2_modes[] = {
+	{
+		.ids = AUTO_NET_SMII_MODE,
+		.mux_regs = pmx_ssp2_mux,
+		.mux_reg_cnt = ARRAY_SIZE(pmx_ssp2_mux),
 	},
 };
 
@@ -325,13 +522,22 @@ struct pmx_dev pmx_ssp2 = {
 	.name = "ssp2",
 	.modes = pmx_ssp2_modes,
 	.mode_count = ARRAY_SIZE(pmx_ssp2_modes),
-	.enb_on_reset = 1,
 };
 
-struct pmx_dev_mode pmx_mii1_modes[] = {
+/* Pad multiplexing for mii1 device */
+static struct pmx_mux_reg pmx_mii1_mux[] = {
 	{
-		.ids = AUTO_NET_MII_MODE,
+		.offset = PAD_MUX_CONFIG_REG,
 		.mask = 0x0,
+		.value = 0,
+	},
+};
+
+static struct pmx_dev_mode pmx_mii1_modes[] = {
+	{
+		.ids = AUTO_NET_MII_MODE,
+		.mux_regs = pmx_mii1_mux,
+		.mux_reg_cnt = ARRAY_SIZE(pmx_mii1_mux),
 	},
 };
 
@@ -339,13 +545,22 @@ struct pmx_dev pmx_mii1 = {
 	.name = "mii1",
 	.modes = pmx_mii1_modes,
 	.mode_count = ARRAY_SIZE(pmx_mii1_modes),
-	.enb_on_reset = 1,
 };
 
-struct pmx_dev_mode pmx_smii0_modes[] = {
+/* Pad multiplexing for smii0 device */
+static struct pmx_mux_reg pmx_smii0_mux[] = {
 	{
-		.ids = AUTO_NET_SMII_MODE | AUTO_EXP_MODE | SMALL_PRINTERS_MODE,
+		.offset = PAD_MUX_CONFIG_REG,
 		.mask = PMX_MII_MASK,
+		.value = 0,
+	},
+};
+
+static struct pmx_dev_mode pmx_smii0_modes[] = {
+	{
+		.ids = AUTO_NET_SMII_MODE | AUTO_EXP_MODE | SMALL_PRINTERS_MODE,
+		.mux_regs = pmx_smii0_mux,
+		.mux_reg_cnt = ARRAY_SIZE(pmx_smii0_mux),
 	},
 };
 
@@ -353,13 +568,22 @@ struct pmx_dev pmx_smii0 = {
 	.name = "smii0",
 	.modes = pmx_smii0_modes,
 	.mode_count = ARRAY_SIZE(pmx_smii0_modes),
-	.enb_on_reset = 1,
 };
 
-struct pmx_dev_mode pmx_smii1_modes[] = {
+/* Pad multiplexing for smii1 device */
+static struct pmx_mux_reg pmx_smii1_mux[] = {
 	{
-		.ids = AUTO_NET_SMII_MODE | SMALL_PRINTERS_MODE,
+		.offset = PAD_MUX_CONFIG_REG,
 		.mask = PMX_MII_MASK,
+		.value = 0,
+	},
+};
+
+static struct pmx_dev_mode pmx_smii1_modes[] = {
+	{
+		.ids = AUTO_NET_SMII_MODE | SMALL_PRINTERS_MODE,
+		.mux_regs = pmx_smii1_mux,
+		.mux_reg_cnt = ARRAY_SIZE(pmx_smii1_mux),
 	},
 };
 
@@ -367,13 +591,22 @@ struct pmx_dev pmx_smii1 = {
 	.name = "smii1",
 	.modes = pmx_smii1_modes,
 	.mode_count = ARRAY_SIZE(pmx_smii1_modes),
-	.enb_on_reset = 1,
 };
 
-struct pmx_dev_mode pmx_i2c1_modes[] = {
+/* Pad multiplexing for i2c1 device */
+static struct pmx_mux_reg pmx_i2c1_mux[] = {
 	{
-		.ids = AUTO_EXP_MODE,
+		.offset = PAD_MUX_CONFIG_REG,
 		.mask = 0x0,
+		.value = 0,
+	},
+};
+
+static struct pmx_dev_mode pmx_i2c1_modes[] = {
+	{
+		.ids = AUTO_EXP_MODE,
+		.mux_regs = pmx_i2c1_mux,
+		.mux_reg_cnt = ARRAY_SIZE(pmx_i2c1_mux),
 	},
 };
 
@@ -381,13 +614,11 @@ struct pmx_dev pmx_i2c1 = {
 	.name = "i2c1",
 	.modes = pmx_i2c1_modes,
 	.mode_count = ARRAY_SIZE(pmx_i2c1_modes),
-	.enb_on_reset = 1,
 };
 
 /* pmx driver structure */
 struct pmx_driver pmx_driver = {
 	.mode_reg = {.offset = MODE_CONFIG_REG, .mask = 0x00000007},
-	.mux_reg = {.offset = PAD_MUX_CONFIG_REG, .mask = 0x00007fff},
 };
 
 /* Add spear320 specific devices here */
diff --git a/arch/arm/mach-spear3xx/spear3xx.c b/arch/arm/mach-spear3xx/spear3xx.c
index 2dfa9d5..30e3ab8 100644
--- a/arch/arm/mach-spear3xx/spear3xx.c
+++ b/arch/arm/mach-spear3xx/spear3xx.c
@@ -293,10 +293,21 @@ void __init spear3xx_map_io(void)
 
 /* pad multiplexing support */
 /* devices */
-struct pmx_dev_mode pmx_firda_modes[] = {
+
+/* Pad multiplexing for firda device */
+static struct pmx_mux_reg pmx_firda_mux[] = {
 	{
-		.ids = 0xffffffff,
+		.offset = PAD_MUX_CONFIG_REG,
 		.mask = PMX_FIRDA_MASK,
+		.value = PMX_FIRDA_MASK,
+	},
+};
+
+static struct pmx_dev_mode pmx_firda_modes[] = {
+	{
+		.ids = 0xffffffff,
+		.mux_regs = pmx_firda_mux,
+		.mux_reg_cnt = ARRAY_SIZE(pmx_firda_mux),
 	},
 };
 
@@ -304,13 +315,22 @@ struct pmx_dev pmx_firda = {
 	.name = "firda",
 	.modes = pmx_firda_modes,
 	.mode_count = ARRAY_SIZE(pmx_firda_modes),
-	.enb_on_reset = 0,
 };
 
-struct pmx_dev_mode pmx_i2c_modes[] = {
+/* Pad multiplexing for i2c device */
+static struct pmx_mux_reg pmx_i2c_mux[] = {
 	{
-		.ids = 0xffffffff,
+		.offset = PAD_MUX_CONFIG_REG,
 		.mask = PMX_I2C_MASK,
+		.value = PMX_I2C_MASK,
+	},
+};
+
+static struct pmx_dev_mode pmx_i2c_modes[] = {
+	{
+		.ids = 0xffffffff,
+		.mux_regs = pmx_i2c_mux,
+		.mux_reg_cnt = ARRAY_SIZE(pmx_i2c_mux),
 	},
 };
 
@@ -318,13 +338,22 @@ struct pmx_dev pmx_i2c = {
 	.name = "i2c",
 	.modes = pmx_i2c_modes,
 	.mode_count = ARRAY_SIZE(pmx_i2c_modes),
-	.enb_on_reset = 0,
 };
 
-struct pmx_dev_mode pmx_ssp_cs_modes[] = {
+/* Pad multiplexing for firda device */
+static struct pmx_mux_reg pmx_ssp_cs_mux[] = {
 	{
-		.ids = 0xffffffff,
+		.offset = PAD_MUX_CONFIG_REG,
 		.mask = PMX_SSP_CS_MASK,
+		.value = PMX_SSP_CS_MASK,
+	},
+};
+
+static struct pmx_dev_mode pmx_ssp_cs_modes[] = {
+	{
+		.ids = 0xffffffff,
+		.mux_regs = pmx_ssp_cs_mux,
+		.mux_reg_cnt = ARRAY_SIZE(pmx_ssp_cs_mux),
 	},
 };
 
@@ -332,13 +361,22 @@ struct pmx_dev pmx_ssp_cs = {
 	.name = "ssp_chip_selects",
 	.modes = pmx_ssp_cs_modes,
 	.mode_count = ARRAY_SIZE(pmx_ssp_cs_modes),
-	.enb_on_reset = 0,
 };
 
-struct pmx_dev_mode pmx_ssp_modes[] = {
+/* Pad multiplexing for ssp device */
+static struct pmx_mux_reg pmx_ssp_mux[] = {
 	{
-		.ids = 0xffffffff,
+		.offset = PAD_MUX_CONFIG_REG,
 		.mask = PMX_SSP_MASK,
+		.value = PMX_SSP_MASK,
+	},
+};
+
+static struct pmx_dev_mode pmx_ssp_modes[] = {
+	{
+		.ids = 0xffffffff,
+		.mux_regs = pmx_ssp_mux,
+		.mux_reg_cnt = ARRAY_SIZE(pmx_ssp_mux),
 	},
 };
 
@@ -346,13 +384,22 @@ struct pmx_dev pmx_ssp = {
 	.name = "ssp",
 	.modes = pmx_ssp_modes,
 	.mode_count = ARRAY_SIZE(pmx_ssp_modes),
-	.enb_on_reset = 0,
 };
 
-struct pmx_dev_mode pmx_mii_modes[] = {
+/* Pad multiplexing for mii device */
+static struct pmx_mux_reg pmx_mii_mux[] = {
 	{
-		.ids = 0xffffffff,
+		.offset = PAD_MUX_CONFIG_REG,
 		.mask = PMX_MII_MASK,
+		.value = PMX_MII_MASK,
+	},
+};
+
+static struct pmx_dev_mode pmx_mii_modes[] = {
+	{
+		.ids = 0xffffffff,
+		.mux_regs = pmx_mii_mux,
+		.mux_reg_cnt = ARRAY_SIZE(pmx_mii_mux),
 	},
 };
 
@@ -360,13 +407,22 @@ struct pmx_dev pmx_mii = {
 	.name = "mii",
 	.modes = pmx_mii_modes,
 	.mode_count = ARRAY_SIZE(pmx_mii_modes),
-	.enb_on_reset = 0,
 };
 
-struct pmx_dev_mode pmx_gpio_pin0_modes[] = {
+/* Pad multiplexing for gpio pin0 device */
+static struct pmx_mux_reg pmx_gpio_pin0_mux[] = {
 	{
-		.ids = 0xffffffff,
+		.offset = PAD_MUX_CONFIG_REG,
 		.mask = PMX_GPIO_PIN0_MASK,
+		.value = PMX_GPIO_PIN0_MASK,
+	},
+};
+
+static struct pmx_dev_mode pmx_gpio_pin0_modes[] = {
+	{
+		.ids = 0xffffffff,
+		.mux_regs = pmx_gpio_pin0_mux,
+		.mux_reg_cnt = ARRAY_SIZE(pmx_gpio_pin0_mux),
 	},
 };
 
@@ -374,13 +430,22 @@ struct pmx_dev pmx_gpio_pin0 = {
 	.name = "gpio_pin0",
 	.modes = pmx_gpio_pin0_modes,
 	.mode_count = ARRAY_SIZE(pmx_gpio_pin0_modes),
-	.enb_on_reset = 0,
 };
 
-struct pmx_dev_mode pmx_gpio_pin1_modes[] = {
+/* Pad multiplexing for gpio pin1 device */
+static struct pmx_mux_reg pmx_gpio_pin1_mux[] = {
 	{
-		.ids = 0xffffffff,
+		.offset = PAD_MUX_CONFIG_REG,
 		.mask = PMX_GPIO_PIN1_MASK,
+		.value = PMX_GPIO_PIN1_MASK,
+	},
+};
+
+static struct pmx_dev_mode pmx_gpio_pin1_modes[] = {
+	{
+		.ids = 0xffffffff,
+		.mux_regs = pmx_gpio_pin1_mux,
+		.mux_reg_cnt = ARRAY_SIZE(pmx_gpio_pin1_mux),
 	},
 };
 
@@ -388,13 +453,22 @@ struct pmx_dev pmx_gpio_pin1 = {
 	.name = "gpio_pin1",
 	.modes = pmx_gpio_pin1_modes,
 	.mode_count = ARRAY_SIZE(pmx_gpio_pin1_modes),
-	.enb_on_reset = 0,
 };
 
-struct pmx_dev_mode pmx_gpio_pin2_modes[] = {
+/* Pad multiplexing for gpio pin2 device */
+static struct pmx_mux_reg pmx_gpio_pin2_mux[] = {
 	{
-		.ids = 0xffffffff,
+		.offset = PAD_MUX_CONFIG_REG,
 		.mask = PMX_GPIO_PIN2_MASK,
+		.value = PMX_GPIO_PIN2_MASK,
+	},
+};
+
+static struct pmx_dev_mode pmx_gpio_pin2_modes[] = {
+	{
+		.ids = 0xffffffff,
+		.mux_regs = pmx_gpio_pin2_mux,
+		.mux_reg_cnt = ARRAY_SIZE(pmx_gpio_pin2_mux),
 	},
 };
 
@@ -402,13 +476,22 @@ struct pmx_dev pmx_gpio_pin2 = {
 	.name = "gpio_pin2",
 	.modes = pmx_gpio_pin2_modes,
 	.mode_count = ARRAY_SIZE(pmx_gpio_pin2_modes),
-	.enb_on_reset = 0,
 };
 
-struct pmx_dev_mode pmx_gpio_pin3_modes[] = {
+/* Pad multiplexing for gpio pin3 device */
+static struct pmx_mux_reg pmx_gpio_pin3_mux[] = {
 	{
-		.ids = 0xffffffff,
+		.offset = PAD_MUX_CONFIG_REG,
 		.mask = PMX_GPIO_PIN3_MASK,
+		.value = PMX_GPIO_PIN3_MASK,
+	},
+};
+
+static struct pmx_dev_mode pmx_gpio_pin3_modes[] = {
+	{
+		.ids = 0xffffffff,
+		.mux_regs = pmx_gpio_pin3_mux,
+		.mux_reg_cnt = ARRAY_SIZE(pmx_gpio_pin3_mux),
 	},
 };
 
@@ -416,13 +499,22 @@ struct pmx_dev pmx_gpio_pin3 = {
 	.name = "gpio_pin3",
 	.modes = pmx_gpio_pin3_modes,
 	.mode_count = ARRAY_SIZE(pmx_gpio_pin3_modes),
-	.enb_on_reset = 0,
 };
 
-struct pmx_dev_mode pmx_gpio_pin4_modes[] = {
+/* Pad multiplexing for gpio pin4 device */
+static struct pmx_mux_reg pmx_gpio_pin4_mux[] = {
 	{
-		.ids = 0xffffffff,
+		.offset = PAD_MUX_CONFIG_REG,
 		.mask = PMX_GPIO_PIN4_MASK,
+		.value = PMX_GPIO_PIN4_MASK,
+	},
+};
+
+static struct pmx_dev_mode pmx_gpio_pin4_modes[] = {
+	{
+		.ids = 0xffffffff,
+		.mux_regs = pmx_gpio_pin4_mux,
+		.mux_reg_cnt = ARRAY_SIZE(pmx_gpio_pin4_mux),
 	},
 };
 
@@ -430,13 +522,22 @@ struct pmx_dev pmx_gpio_pin4 = {
 	.name = "gpio_pin4",
 	.modes = pmx_gpio_pin4_modes,
 	.mode_count = ARRAY_SIZE(pmx_gpio_pin4_modes),
-	.enb_on_reset = 0,
 };
 
-struct pmx_dev_mode pmx_gpio_pin5_modes[] = {
+/* Pad multiplexing for gpio pin5 device */
+static struct pmx_mux_reg pmx_gpio_pin5_mux[] = {
 	{
-		.ids = 0xffffffff,
+		.offset = PAD_MUX_CONFIG_REG,
 		.mask = PMX_GPIO_PIN5_MASK,
+		.value = PMX_GPIO_PIN5_MASK,
+	},
+};
+
+static struct pmx_dev_mode pmx_gpio_pin5_modes[] = {
+	{
+		.ids = 0xffffffff,
+		.mux_regs = pmx_gpio_pin5_mux,
+		.mux_reg_cnt = ARRAY_SIZE(pmx_gpio_pin5_mux),
 	},
 };
 
@@ -444,13 +545,22 @@ struct pmx_dev pmx_gpio_pin5 = {
 	.name = "gpio_pin5",
 	.modes = pmx_gpio_pin5_modes,
 	.mode_count = ARRAY_SIZE(pmx_gpio_pin5_modes),
-	.enb_on_reset = 0,
 };
 
-struct pmx_dev_mode pmx_uart0_modem_modes[] = {
+/* Pad multiplexing for uart0 modem device */
+static struct pmx_mux_reg pmx_uart0_modem_mux[] = {
 	{
-		.ids = 0xffffffff,
+		.offset = PAD_MUX_CONFIG_REG,
 		.mask = PMX_UART0_MODEM_MASK,
+		.value = PMX_UART0_MODEM_MASK,
+	},
+};
+
+static struct pmx_dev_mode pmx_uart0_modem_modes[] = {
+	{
+		.ids = 0xffffffff,
+		.mux_regs = pmx_uart0_modem_mux,
+		.mux_reg_cnt = ARRAY_SIZE(pmx_uart0_modem_mux),
 	},
 };
 
@@ -458,13 +568,22 @@ struct pmx_dev pmx_uart0_modem = {
 	.name = "uart0_modem",
 	.modes = pmx_uart0_modem_modes,
 	.mode_count = ARRAY_SIZE(pmx_uart0_modem_modes),
-	.enb_on_reset = 0,
 };
 
-struct pmx_dev_mode pmx_uart0_modes[] = {
+/* Pad multiplexing for uart0 device */
+static struct pmx_mux_reg pmx_uart0_mux[] = {
 	{
-		.ids = 0xffffffff,
+		.offset = PAD_MUX_CONFIG_REG,
 		.mask = PMX_UART0_MASK,
+		.value = PMX_UART0_MASK,
+	},
+};
+
+static struct pmx_dev_mode pmx_uart0_modes[] = {
+	{
+		.ids = 0xffffffff,
+		.mux_regs = pmx_uart0_mux,
+		.mux_reg_cnt = ARRAY_SIZE(pmx_uart0_mux),
 	},
 };
 
@@ -472,13 +591,22 @@ struct pmx_dev pmx_uart0 = {
 	.name = "uart0",
 	.modes = pmx_uart0_modes,
 	.mode_count = ARRAY_SIZE(pmx_uart0_modes),
-	.enb_on_reset = 0,
 };
 
-struct pmx_dev_mode pmx_timer_3_4_modes[] = {
+/* Pad multiplexing for timer 3, 4 device */
+static struct pmx_mux_reg pmx_timer_3_4_mux[] = {
 	{
-		.ids = 0xffffffff,
+		.offset = PAD_MUX_CONFIG_REG,
 		.mask = PMX_TIMER_3_4_MASK,
+		.value = PMX_TIMER_3_4_MASK,
+	},
+};
+
+static struct pmx_dev_mode pmx_timer_3_4_modes[] = {
+	{
+		.ids = 0xffffffff,
+		.mux_regs = pmx_timer_3_4_mux,
+		.mux_reg_cnt = ARRAY_SIZE(pmx_timer_3_4_mux),
 	},
 };
 
@@ -486,13 +614,22 @@ struct pmx_dev pmx_timer_3_4 = {
 	.name = "timer_3_4",
 	.modes = pmx_timer_3_4_modes,
 	.mode_count = ARRAY_SIZE(pmx_timer_3_4_modes),
-	.enb_on_reset = 0,
 };
 
-struct pmx_dev_mode pmx_timer_1_2_modes[] = {
+/* Pad multiplexing for gpio pin0 device */
+static struct pmx_mux_reg pmx_timer_1_2_mux[] = {
 	{
-		.ids = 0xffffffff,
+		.offset = PAD_MUX_CONFIG_REG,
 		.mask = PMX_TIMER_1_2_MASK,
+		.value = PMX_TIMER_1_2_MASK,
+	},
+};
+
+static struct pmx_dev_mode pmx_timer_1_2_modes[] = {
+	{
+		.ids = 0xffffffff,
+		.mux_regs = pmx_timer_1_2_mux,
+		.mux_reg_cnt = ARRAY_SIZE(pmx_timer_1_2_mux),
 	},
 };
 
@@ -500,15 +637,24 @@ struct pmx_dev pmx_timer_1_2 = {
 	.name = "timer_1_2",
 	.modes = pmx_timer_1_2_modes,
 	.mode_count = ARRAY_SIZE(pmx_timer_1_2_modes),
-	.enb_on_reset = 0,
 };
 
 #if defined(CONFIG_MACH_SPEAR310) || defined(CONFIG_MACH_SPEAR320)
 /* plgpios devices */
-struct pmx_dev_mode pmx_plgpio_0_1_modes[] = {
+/* Pad multiplexing for plgpio_0_1 devices */
+static struct pmx_mux_reg pmx_plgpio_0_1_mux[] = {
 	{
-		.ids = 0x00,
+		.offset = PAD_MUX_CONFIG_REG,
 		.mask = PMX_FIRDA_MASK,
+		.value = 0,
+	},
+};
+
+static struct pmx_dev_mode pmx_plgpio_0_1_modes[] = {
+	{
+		.ids = 0xffffffff,
+		.mux_regs = pmx_plgpio_0_1_mux,
+		.mux_reg_cnt = ARRAY_SIZE(pmx_plgpio_0_1_mux),
 	},
 };
 
@@ -516,13 +662,22 @@ struct pmx_dev pmx_plgpio_0_1 = {
 	.name = "plgpio 0 and 1",
 	.modes = pmx_plgpio_0_1_modes,
 	.mode_count = ARRAY_SIZE(pmx_plgpio_0_1_modes),
-	.enb_on_reset = 1,
 };
 
-struct pmx_dev_mode pmx_plgpio_2_3_modes[] = {
+/* Pad multiplexing for plgpio_2_3 devices */
+static struct pmx_mux_reg pmx_plgpio_2_3_mux[] = {
 	{
-		.ids = 0x00,
+		.offset = PAD_MUX_CONFIG_REG,
 		.mask = PMX_UART0_MASK,
+		.value = 0,
+	},
+};
+
+static struct pmx_dev_mode pmx_plgpio_2_3_modes[] = {
+	{
+		.ids = 0xffffffff,
+		.mux_regs = pmx_plgpio_2_3_mux,
+		.mux_reg_cnt = ARRAY_SIZE(pmx_plgpio_2_3_mux),
 	},
 };
 
@@ -530,13 +685,22 @@ struct pmx_dev pmx_plgpio_2_3 = {
 	.name = "plgpio 2 and 3",
 	.modes = pmx_plgpio_2_3_modes,
 	.mode_count = ARRAY_SIZE(pmx_plgpio_2_3_modes),
-	.enb_on_reset = 1,
 };
 
-struct pmx_dev_mode pmx_plgpio_4_5_modes[] = {
+/* Pad multiplexing for plgpio_4_5 devices */
+static struct pmx_mux_reg pmx_plgpio_4_5_mux[] = {
 	{
-		.ids = 0x00,
+		.offset = PAD_MUX_CONFIG_REG,
 		.mask = PMX_I2C_MASK,
+		.value = 0,
+	},
+};
+
+static struct pmx_dev_mode pmx_plgpio_4_5_modes[] = {
+	{
+		.ids = 0xffffffff,
+		.mux_regs = pmx_plgpio_4_5_mux,
+		.mux_reg_cnt = ARRAY_SIZE(pmx_plgpio_4_5_mux),
 	},
 };
 
@@ -544,13 +708,22 @@ struct pmx_dev pmx_plgpio_4_5 = {
 	.name = "plgpio 4 and 5",
 	.modes = pmx_plgpio_4_5_modes,
 	.mode_count = ARRAY_SIZE(pmx_plgpio_4_5_modes),
-	.enb_on_reset = 1,
 };
 
-struct pmx_dev_mode pmx_plgpio_6_9_modes[] = {
+/* Pad multiplexing for plgpio_6_9 devices */
+static struct pmx_mux_reg pmx_plgpio_6_9_mux[] = {
 	{
-		.ids = 0x00,
+		.offset = PAD_MUX_CONFIG_REG,
 		.mask = PMX_SSP_MASK,
+		.value = 0,
+	},
+};
+
+static struct pmx_dev_mode pmx_plgpio_6_9_modes[] = {
+	{
+		.ids = 0xffffffff,
+		.mux_regs = pmx_plgpio_6_9_mux,
+		.mux_reg_cnt = ARRAY_SIZE(pmx_plgpio_6_9_mux),
 	},
 };
 
@@ -558,13 +731,22 @@ struct pmx_dev pmx_plgpio_6_9 = {
 	.name = "plgpio 6 to 9",
 	.modes = pmx_plgpio_6_9_modes,
 	.mode_count = ARRAY_SIZE(pmx_plgpio_6_9_modes),
-	.enb_on_reset = 1,
 };
 
-struct pmx_dev_mode pmx_plgpio_10_27_modes[] = {
+/* Pad multiplexing for plgpio_10_27 devices */
+static struct pmx_mux_reg pmx_plgpio_10_27_mux[] = {
 	{
-		.ids = 0x00,
+		.offset = PAD_MUX_CONFIG_REG,
 		.mask = PMX_MII_MASK,
+		.value = 0,
+	},
+};
+
+static struct pmx_dev_mode pmx_plgpio_10_27_modes[] = {
+	{
+		.ids = 0xffffffff,
+		.mux_regs = pmx_plgpio_10_27_mux,
+		.mux_reg_cnt = ARRAY_SIZE(pmx_plgpio_10_27_mux),
 	},
 };
 
@@ -572,13 +754,22 @@ struct pmx_dev pmx_plgpio_10_27 = {
 	.name = "plgpio 10 to 27",
 	.modes = pmx_plgpio_10_27_modes,
 	.mode_count = ARRAY_SIZE(pmx_plgpio_10_27_modes),
-	.enb_on_reset = 1,
 };
 
-struct pmx_dev_mode pmx_plgpio_28_modes[] = {
+/* Pad multiplexing for plgpio_28 devices */
+static struct pmx_mux_reg pmx_plgpio_28_mux[] = {
 	{
-		.ids = 0x00,
+		.offset = PAD_MUX_CONFIG_REG,
 		.mask = PMX_GPIO_PIN0_MASK,
+		.value = 0,
+	},
+};
+
+static struct pmx_dev_mode pmx_plgpio_28_modes[] = {
+	{
+		.ids = 0xffffffff,
+		.mux_regs = pmx_plgpio_28_mux,
+		.mux_reg_cnt = ARRAY_SIZE(pmx_plgpio_28_mux),
 	},
 };
 
@@ -586,13 +777,22 @@ struct pmx_dev pmx_plgpio_28 = {
 	.name = "plgpio 28",
 	.modes = pmx_plgpio_28_modes,
 	.mode_count = ARRAY_SIZE(pmx_plgpio_28_modes),
-	.enb_on_reset = 1,
 };
 
-struct pmx_dev_mode pmx_plgpio_29_modes[] = {
+/* Pad multiplexing for plgpio_29 devices */
+static struct pmx_mux_reg pmx_plgpio_29_mux[] = {
 	{
-		.ids = 0x00,
+		.offset = PAD_MUX_CONFIG_REG,
 		.mask = PMX_GPIO_PIN1_MASK,
+		.value = 0,
+	},
+};
+
+static struct pmx_dev_mode pmx_plgpio_29_modes[] = {
+	{
+		.ids = 0xffffffff,
+		.mux_regs = pmx_plgpio_29_mux,
+		.mux_reg_cnt = ARRAY_SIZE(pmx_plgpio_29_mux),
 	},
 };
 
@@ -600,13 +800,22 @@ struct pmx_dev pmx_plgpio_29 = {
 	.name = "plgpio 29",
 	.modes = pmx_plgpio_29_modes,
 	.mode_count = ARRAY_SIZE(pmx_plgpio_29_modes),
-	.enb_on_reset = 1,
 };
 
-struct pmx_dev_mode pmx_plgpio_30_modes[] = {
+/* Pad multiplexing for plgpio_30 device */
+static struct pmx_mux_reg pmx_plgpio_30_mux[] = {
 	{
-		.ids = 0x00,
+		.offset = PAD_MUX_CONFIG_REG,
 		.mask = PMX_GPIO_PIN2_MASK,
+		.value = 0,
+	},
+};
+
+static struct pmx_dev_mode pmx_plgpio_30_modes[] = {
+	{
+		.ids = 0xffffffff,
+		.mux_regs = pmx_plgpio_30_mux,
+		.mux_reg_cnt = ARRAY_SIZE(pmx_plgpio_30_mux),
 	},
 };
 
@@ -614,13 +823,22 @@ struct pmx_dev pmx_plgpio_30 = {
 	.name = "plgpio 30",
 	.modes = pmx_plgpio_30_modes,
 	.mode_count = ARRAY_SIZE(pmx_plgpio_30_modes),
-	.enb_on_reset = 1,
 };
 
-struct pmx_dev_mode pmx_plgpio_31_modes[] = {
+/* Pad multiplexing for plgpio_31 device */
+static struct pmx_mux_reg pmx_plgpio_31_mux[] = {
 	{
-		.ids = 0x00,
+		.offset = PAD_MUX_CONFIG_REG,
 		.mask = PMX_GPIO_PIN3_MASK,
+		.value = 0,
+	},
+};
+
+static struct pmx_dev_mode pmx_plgpio_31_modes[] = {
+	{
+		.ids = 0xffffffff,
+		.mux_regs = pmx_plgpio_31_mux,
+		.mux_reg_cnt = ARRAY_SIZE(pmx_plgpio_31_mux),
 	},
 };
 
@@ -628,13 +846,22 @@ struct pmx_dev pmx_plgpio_31 = {
 	.name = "plgpio 31",
 	.modes = pmx_plgpio_31_modes,
 	.mode_count = ARRAY_SIZE(pmx_plgpio_31_modes),
-	.enb_on_reset = 1,
 };
 
-struct pmx_dev_mode pmx_plgpio_32_modes[] = {
+/* Pad multiplexing for plgpio_32 device */
+static struct pmx_mux_reg pmx_plgpio_32_mux[] = {
 	{
-		.ids = 0x00,
+		.offset = PAD_MUX_CONFIG_REG,
 		.mask = PMX_GPIO_PIN4_MASK,
+		.value = 0,
+	},
+};
+
+static struct pmx_dev_mode pmx_plgpio_32_modes[] = {
+	{
+		.ids = 0xffffffff,
+		.mux_regs = pmx_plgpio_32_mux,
+		.mux_reg_cnt = ARRAY_SIZE(pmx_plgpio_32_mux),
 	},
 };
 
@@ -642,13 +869,22 @@ struct pmx_dev pmx_plgpio_32 = {
 	.name = "plgpio 32",
 	.modes = pmx_plgpio_32_modes,
 	.mode_count = ARRAY_SIZE(pmx_plgpio_32_modes),
-	.enb_on_reset = 1,
 };
 
-struct pmx_dev_mode pmx_plgpio_33_modes[] = {
+/* Pad multiplexing for plgpio_33 device */
+static struct pmx_mux_reg pmx_plgpio_33_mux[] = {
 	{
-		.ids = 0x00,
+		.offset = PAD_MUX_CONFIG_REG,
 		.mask = PMX_GPIO_PIN5_MASK,
+		.value = 0,
+	},
+};
+
+static struct pmx_dev_mode pmx_plgpio_33_modes[] = {
+	{
+		.ids = 0xffffffff,
+		.mux_regs = pmx_plgpio_33_mux,
+		.mux_reg_cnt = ARRAY_SIZE(pmx_plgpio_33_mux),
 	},
 };
 
@@ -656,13 +892,22 @@ struct pmx_dev pmx_plgpio_33 = {
 	.name = "plgpio 33",
 	.modes = pmx_plgpio_33_modes,
 	.mode_count = ARRAY_SIZE(pmx_plgpio_33_modes),
-	.enb_on_reset = 1,
 };
 
-struct pmx_dev_mode pmx_plgpio_34_36_modes[] = {
+/* Pad multiplexing for plgpio_34_36 device */
+static struct pmx_mux_reg pmx_plgpio_34_36_mux[] = {
 	{
-		.ids = 0x00,
+		.offset = PAD_MUX_CONFIG_REG,
 		.mask = PMX_SSP_CS_MASK,
+		.value = 0,
+	},
+};
+
+static struct pmx_dev_mode pmx_plgpio_34_36_modes[] = {
+	{
+		.ids = 0xffffffff,
+		.mux_regs = pmx_plgpio_34_36_mux,
+		.mux_reg_cnt = ARRAY_SIZE(pmx_plgpio_34_36_mux),
 	},
 };
 
@@ -670,13 +915,22 @@ struct pmx_dev pmx_plgpio_34_36 = {
 	.name = "plgpio 34 to 36",
 	.modes = pmx_plgpio_34_36_modes,
 	.mode_count = ARRAY_SIZE(pmx_plgpio_34_36_modes),
-	.enb_on_reset = 1,
 };
 
-struct pmx_dev_mode pmx_plgpio_37_42_modes[] = {
+/* Pad multiplexing for plgpio_37_42 device */
+static struct pmx_mux_reg pmx_plgpio_37_42_mux[] = {
 	{
-		.ids = 0x00,
+		.offset = PAD_MUX_CONFIG_REG,
 		.mask = PMX_UART0_MODEM_MASK,
+		.value = 0,
+	},
+};
+
+static struct pmx_dev_mode pmx_plgpio_37_42_modes[] = {
+	{
+		.ids = 0xffffffff,
+		.mux_regs = pmx_plgpio_37_42_mux,
+		.mux_reg_cnt = ARRAY_SIZE(pmx_plgpio_37_42_mux),
 	},
 };
 
@@ -684,13 +938,22 @@ struct pmx_dev pmx_plgpio_37_42 = {
 	.name = "plgpio 37 to 42",
 	.modes = pmx_plgpio_37_42_modes,
 	.mode_count = ARRAY_SIZE(pmx_plgpio_37_42_modes),
-	.enb_on_reset = 1,
 };
 
-struct pmx_dev_mode pmx_plgpio_43_44_47_48_modes[] = {
+/* Pad multiplexing for plgpio_43_44_47_48 device */
+static struct pmx_mux_reg pmx_plgpio_43_44_47_48_mux[] = {
 	{
-		.ids = 0x00,
+		.offset = PAD_MUX_CONFIG_REG,
 		.mask = PMX_TIMER_1_2_MASK,
+		.value = 0,
+	},
+};
+
+static struct pmx_dev_mode pmx_plgpio_43_44_47_48_modes[] = {
+	{
+		.ids = 0xffffffff,
+		.mux_regs = pmx_plgpio_43_44_47_48_mux,
+		.mux_reg_cnt = ARRAY_SIZE(pmx_plgpio_43_44_47_48_mux),
 	},
 };
 
@@ -698,13 +961,22 @@ struct pmx_dev pmx_plgpio_43_44_47_48 = {
 	.name = "plgpio 43, 44, 47 and 48",
 	.modes = pmx_plgpio_43_44_47_48_modes,
 	.mode_count = ARRAY_SIZE(pmx_plgpio_43_44_47_48_modes),
-	.enb_on_reset = 1,
 };
 
-struct pmx_dev_mode pmx_plgpio_45_46_49_50_modes[] = {
+/* Pad multiplexing for plgpio_45_46_49_50 device */
+static struct pmx_mux_reg pmx_plgpio_45_46_49_50_mux[] = {
 	{
-		.ids = 0x00,
+		.offset = PAD_MUX_CONFIG_REG,
 		.mask = PMX_TIMER_3_4_MASK,
+		.value = 0,
+	},
+};
+
+static struct pmx_dev_mode pmx_plgpio_45_46_49_50_modes[] = {
+	{
+		.ids = 0xffffffff,
+		.mux_regs = pmx_plgpio_45_46_49_50_mux,
+		.mux_reg_cnt = ARRAY_SIZE(pmx_plgpio_45_46_49_50_mux),
 	},
 };
 
@@ -712,7 +984,6 @@ struct pmx_dev pmx_plgpio_45_46_49_50 = {
 	.name = "plgpio 45, 46, 49 and 50",
 	.modes = pmx_plgpio_45_46_49_50_modes,
 	.mode_count = ARRAY_SIZE(pmx_plgpio_45_46_49_50_modes),
-	.enb_on_reset = 1,
 };
 #endif /* CONFIG_MACH_SPEAR310 || CONFIG_MACH_SPEAR320 */
 
diff --git a/arch/arm/plat-spear/include/plat/padmux.h b/arch/arm/plat-spear/include/plat/padmux.h
index 877f3ad..1b69ca5 100644
--- a/arch/arm/plat-spear/include/plat/padmux.h
+++ b/arch/arm/plat-spear/include/plat/padmux.h
@@ -28,26 +28,42 @@ struct pmx_reg {
 };
 
 /*
+ * struct pmx_mux_reg: configuration structure every group of modes of a device
+ *
+ * offset: multiplexing register offset
+ * mask: mask for supported mode
+ * value: value to be written
+ */
+struct pmx_mux_reg {
+	u32 offset;
+	u32 mask;
+	u32 value;
+};
+
+/*
  * struct pmx_dev_mode: configuration structure every group of modes of a device
  *
  * ids: all modes for this configuration
- * mask: mask for supported mode
+ * mux_regs: array of mux registers, masks and values to enable the device in
+ *		this group of modes
+ * mux_reg_cnt: count of mux_regs elements
  */
 struct pmx_dev_mode {
 	u32 ids;
-	u32 mask;
+	struct pmx_mux_reg *mux_regs;
+	u8 mux_reg_cnt;
 };
 
 /*
  * struct pmx_mode: mode definition structure
  *
  * name: mode name
- * mask: mode mask
+ * value: mode value
  */
 struct pmx_mode {
 	char *name;
 	u32 id;
-	u32 mask;
+	u32 value;
 };
 
 /*
@@ -57,14 +73,12 @@ struct pmx_mode {
  * modes: device configuration array for different modes supported
  * mode_count: size of modes array
  * is_active: is peripheral active/enabled
- * enb_on_reset: if 1, mask bits to be cleared in reg otherwise to be set in reg
  */
 struct pmx_dev {
 	char *name;
 	struct pmx_dev_mode *modes;
 	u8 mode_count;
 	bool is_active;
-	bool enb_on_reset;
 };
 
 /*
@@ -75,7 +89,6 @@ struct pmx_dev {
  * devs_count: ARRAY_SIZE of devs
  * base: base address of soc config registers
  * mode_reg: structure of mode config register
- * mux_reg: structure of device mux config register
  */
 struct pmx_driver {
 	struct pmx_mode *mode;
@@ -83,7 +96,6 @@ struct pmx_driver {
 	u8 devs_count;
 	u32 *base;
 	struct pmx_reg mode_reg;
-	struct pmx_reg mux_reg;
 };
 
 /* pmx functions */
diff --git a/arch/arm/plat-spear/padmux.c b/arch/arm/plat-spear/padmux.c
index 555eec6..f30f94b 100644
--- a/arch/arm/plat-spear/padmux.c
+++ b/arch/arm/plat-spear/padmux.c
@@ -21,13 +21,11 @@
  *
  * base: base address of configuration registers
  * mode_reg: mode configurations
- * mux_reg: muxing configurations
  * active_mode: pointer to current active mode
  */
 struct pmx {
 	u32 base;
 	struct pmx_reg mode_reg;
-	struct pmx_reg mux_reg;
 	struct pmx_mode *active_mode;
 };
 
@@ -51,7 +49,7 @@ static int pmx_mode_set(struct pmx_mode *mode)
 
 	val = readl(pmx->base + pmx->mode_reg.offset);
 	val &= ~pmx->mode_reg.mask;
-	val |= mode->mask & pmx->mode_reg.mask;
+	val |= mode->value & pmx->mode_reg.mask;
 	writel(val, pmx->base + pmx->mode_reg.offset);
 
 	return 0;
@@ -66,19 +64,18 @@ static int pmx_mode_set(struct pmx_mode *mode)
  * If peripheral is not supported by current mode then request is rejected.
  * Conflicts between peripherals are not handled and peripherals will be
  * enabled in the order they are present in pmx_dev array.
- * In case of conflicts last peripheral enabled will be present.
+ * In case of conflicts last peripheral enabled will remain present.
  * Returns -ve on Err otherwise 0
  */
 static int pmx_devs_enable(struct pmx_dev **devs, u8 count)
 {
-	u32 val, i, mask;
+	u32 val, i;
 
 	if (!count)
 		return -EINVAL;
 
-	val = readl(pmx->base + pmx->mux_reg.offset);
 	for (i = 0; i < count; i++) {
-		u8 j = 0;
+		u8 k, j = 0;
 
 		if (!devs[i]->name || !devs[i]->modes) {
 			printk(KERN_ERR "padmux: dev name or modes is null\n");
@@ -103,15 +100,18 @@ static int pmx_devs_enable(struct pmx_dev **devs, u8 count)
 		}
 
 		/* enable peripheral */
-		mask = devs[i]->modes[j].mask & pmx->mux_reg.mask;
-		if (devs[i]->enb_on_reset)
-			val &= ~mask;
-		else
-			val |= mask;
+		for (k = 0; k < devs[i]->modes[j].mux_reg_cnt; k++) {
+			struct pmx_mux_reg *mux_reg =
+				&devs[i]->modes[j].mux_regs[k];
+
+			val = readl(pmx->base + mux_reg->offset);
+			val &= ~mux_reg->mask;
+			val |= mux_reg->value & mux_reg->mask;
+			writel(val, pmx->base + mux_reg->offset);
+		}
 
 		devs[i]->is_active = true;
 	}
-	writel(val, pmx->base + pmx->mux_reg.offset);
 	kfree(pmx);
 
 	/* this will ensure that multiplexing can't be changed now */
@@ -144,8 +144,6 @@ int pmx_register(struct pmx_driver *driver)
 	pmx->base = (u32)driver->base;
 	pmx->mode_reg.offset = driver->mode_reg.offset;
 	pmx->mode_reg.mask = driver->mode_reg.mask;
-	pmx->mux_reg.offset = driver->mux_reg.offset;
-	pmx->mux_reg.mask = driver->mux_reg.mask;
 
 	/* choose mode to enable */
 	if (driver->mode) {
-- 
1.7.2.2

