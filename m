Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754606Ab2DWJPi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 05:15:38 -0400
Received: from eu1sys200aog113.obsmtp.com ([207.126.144.135]:34651 "EHLO
	eu1sys200aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754415Ab2DWJPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 05:15:33 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Philippe LANGLAIS <philippe.langlais@stericsson.com>,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        Jonas Aberg <jonas.aberg@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 9/9] ARM: ux500: update pin handling
Date: Mon, 23 Apr 2012 11:15:12 +0200
Message-ID: <1335172512-27790-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.9.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

This updates the Ux500 pin handling to take much more care when
applying pin settings for different platforms and peripherals.
This is an accumulation of a longer history of updates to the
MOP500 family pin file.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 arch/arm/mach-ux500/board-mop500-pins.c |  393 +++++++++++++++++++++++--------
 arch/arm/mach-ux500/board-mop500.h      |    4 +
 2 files changed, 301 insertions(+), 96 deletions(-)

diff --git a/arch/arm/mach-ux500/board-mop500-pins.c b/arch/arm/mach-ux500/board-mop500-pins.c
index e2a2e50..df5b190 100644
--- a/arch/arm/mach-ux500/board-mop500-pins.c
+++ b/arch/arm/mach-ux500/board-mop500-pins.c
@@ -7,110 +7,47 @@
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/bug.h>
+#include <linux/string.h>
 
 #include <asm/mach-types.h>
 #include <plat/pincfg.h>
 #include <plat/gpio-nomadik.h>
+
 #include <mach/hardware.h>
 
 #include "pins-db8500.h"
 #include "pins.h"
+#include "board-mop500.h"
+
+enum custom_pin_cfg_t {
+	PINS_FOR_DEFAULT,
+	PINS_FOR_U9500,
+};
+
+static enum custom_pin_cfg_t pinsfor;
 
 static pin_cfg_t mop500_pins_common[] = {
-	/* I2C */
-	GPIO147_I2C0_SCL,
-	GPIO148_I2C0_SDA,
-	GPIO16_I2C1_SCL,
-	GPIO17_I2C1_SDA,
-	GPIO10_I2C2_SDA,
-	GPIO11_I2C2_SCL,
-	GPIO229_I2C3_SDA,
-	GPIO230_I2C3_SCL,
-
-	/* MSP0 */
+	/* uMSP0 */
 	GPIO12_MSP0_TXD,
 	GPIO13_MSP0_TFS,
 	GPIO14_MSP0_TCK,
 	GPIO15_MSP0_RXD,
 
 	/* MSP2: HDMI */
-	GPIO193_MSP2_TXD,
-	GPIO194_MSP2_TCK,
-	GPIO195_MSP2_TFS,
+	GPIO193_MSP2_TXD | PIN_INPUT_PULLDOWN,
+	GPIO194_MSP2_TCK | PIN_INPUT_PULLDOWN,
+	GPIO195_MSP2_TFS | PIN_INPUT_PULLDOWN,
 	GPIO196_MSP2_RXD | PIN_OUTPUT_LOW,
 
+	/* LCD TE0 */
+	GPIO68_LCD_VSI0	| PIN_INPUT_PULLUP,
+
 	/* Touch screen INTERFACE */
 	GPIO84_GPIO	| PIN_INPUT_PULLUP, /* TOUCH_INT1 */
 
 	/* STMPE1601/tc35893 keypad  IRQ */
 	GPIO218_GPIO	| PIN_INPUT_PULLUP,
 
-	/* MMC0 (MicroSD card) */
-	GPIO18_MC0_CMDDIR	| PIN_OUTPUT_HIGH,
-	GPIO19_MC0_DAT0DIR	| PIN_OUTPUT_HIGH,
-	GPIO20_MC0_DAT2DIR	| PIN_OUTPUT_HIGH,
-
-	GPIO22_MC0_FBCLK	| PIN_INPUT_NOPULL,
-	GPIO23_MC0_CLK		| PIN_OUTPUT_LOW,
-	GPIO24_MC0_CMD		| PIN_INPUT_PULLUP,
-	GPIO25_MC0_DAT0		| PIN_INPUT_PULLUP,
-	GPIO26_MC0_DAT1		| PIN_INPUT_PULLUP,
-	GPIO27_MC0_DAT2		| PIN_INPUT_PULLUP,
-	GPIO28_MC0_DAT3		| PIN_INPUT_PULLUP,
-
-	/* SDI1 (SDIO) */
-	GPIO208_MC1_CLK		| PIN_OUTPUT_LOW,
-	GPIO209_MC1_FBCLK	| PIN_INPUT_NOPULL,
-	GPIO210_MC1_CMD		| PIN_INPUT_PULLUP,
-	GPIO211_MC1_DAT0	| PIN_INPUT_PULLUP,
-	GPIO212_MC1_DAT1	| PIN_INPUT_PULLUP,
-	GPIO213_MC1_DAT2	| PIN_INPUT_PULLUP,
-	GPIO214_MC1_DAT3	| PIN_INPUT_PULLUP,
-
-	/* MMC2 (On-board DATA INTERFACE eMMC) */
-	GPIO128_MC2_CLK		| PIN_OUTPUT_LOW,
-	GPIO129_MC2_CMD		| PIN_INPUT_PULLUP,
-	GPIO130_MC2_FBCLK	| PIN_INPUT_NOPULL,
-	GPIO131_MC2_DAT0	| PIN_INPUT_PULLUP,
-	GPIO132_MC2_DAT1	| PIN_INPUT_PULLUP,
-	GPIO133_MC2_DAT2	| PIN_INPUT_PULLUP,
-	GPIO134_MC2_DAT3	| PIN_INPUT_PULLUP,
-	GPIO135_MC2_DAT4	| PIN_INPUT_PULLUP,
-	GPIO136_MC2_DAT5	| PIN_INPUT_PULLUP,
-	GPIO137_MC2_DAT6	| PIN_INPUT_PULLUP,
-	GPIO138_MC2_DAT7	| PIN_INPUT_PULLUP,
-
-	/* MMC4 (On-board STORAGE INTERFACE eMMC) */
-	GPIO197_MC4_DAT3	| PIN_INPUT_PULLUP,
-	GPIO198_MC4_DAT2	| PIN_INPUT_PULLUP,
-	GPIO199_MC4_DAT1	| PIN_INPUT_PULLUP,
-	GPIO200_MC4_DAT0	| PIN_INPUT_PULLUP,
-	GPIO201_MC4_CMD		| PIN_INPUT_PULLUP,
-	GPIO202_MC4_FBCLK	| PIN_INPUT_NOPULL,
-	GPIO203_MC4_CLK		| PIN_OUTPUT_LOW,
-	GPIO204_MC4_DAT7	| PIN_INPUT_PULLUP,
-	GPIO205_MC4_DAT6	| PIN_INPUT_PULLUP,
-	GPIO206_MC4_DAT5	| PIN_INPUT_PULLUP,
-	GPIO207_MC4_DAT4	| PIN_INPUT_PULLUP,
-
-	/* SKE keypad */
-	GPIO153_KP_I7,
-	GPIO154_KP_I6,
-	GPIO155_KP_I5,
-	GPIO156_KP_I4,
-	GPIO157_KP_O7,
-	GPIO158_KP_O6,
-	GPIO159_KP_O5,
-	GPIO160_KP_O4,
-	GPIO161_KP_I3,
-	GPIO162_KP_I2,
-	GPIO163_KP_I1,
-	GPIO164_KP_I0,
-	GPIO165_KP_O3,
-	GPIO166_KP_O2,
-	GPIO167_KP_O1,
-	GPIO168_KP_O0,
-
 	/* UART */
 	/* uart-0 pins gpio configuration should be
 	 * kept intact to prevent glitch in tx line
@@ -129,10 +66,6 @@ static pin_cfg_t mop500_pins_common[] = {
 	GPIO30_U2_TXD	| PIN_OUTPUT_HIGH,
 	GPIO31_U2_CTSn	| PIN_INPUT_PULLUP,
 	GPIO32_U2_RTSn	| PIN_OUTPUT_HIGH,
-
-	/* Display & HDMI HW sync */
-	GPIO68_LCD_VSI0	| PIN_INPUT_PULLUP,
-	GPIO69_LCD_VSI1	| PIN_INPUT_PULLUP,
 };
 
 static pin_cfg_t mop500_pins_default[] = {
@@ -142,10 +75,13 @@ static pin_cfg_t mop500_pins_default[] = {
 	GPIO145_SSP0_RXD | PIN_PULL_DOWN,
 	GPIO146_SSP0_TXD,
 
+	/* XENON Flashgun INTERFACE */
+	GPIO6_IP_GPIO0	| PIN_INPUT_PULLUP,/* XENON_FLASH_ID */
+	GPIO7_IP_GPIO1	| PIN_INPUT_PULLUP,/* XENON_READY */
 
 	GPIO217_GPIO	| PIN_INPUT_PULLUP, /* TC35892 IRQ */
 
-	/* SDI0 (MicroSD card) */
+	/* sdi0 (removable MMC/SD/SDIO cards) not handled by pm_runtime */
 	GPIO21_MC0_DAT31DIR	| PIN_OUTPUT_HIGH,
 
 	/* UART */
@@ -157,13 +93,11 @@ static pin_cfg_t mop500_pins_default[] = {
 
 static pin_cfg_t hrefv60_pins[] = {
 	/* WLAN */
-	GPIO4_GPIO		| PIN_INPUT_PULLUP,/* WLAN_IRQ */
 	GPIO85_GPIO		| PIN_OUTPUT_LOW,/* WLAN_ENA */
 
 	/* XENON Flashgun INTERFACE */
 	GPIO6_IP_GPIO0	| PIN_INPUT_PULLUP,/* XENON_FLASH_ID */
 	GPIO7_IP_GPIO1	| PIN_INPUT_PULLUP,/* XENON_READY */
-	GPIO170_GPIO	| PIN_OUTPUT_LOW, /* XENON_CHARGE */
 
 	/* Assistant LED INTERFACE */
 	GPIO21_GPIO | PIN_OUTPUT_LOW,  /* XENON_EN1 */
@@ -174,7 +108,7 @@ static pin_cfg_t hrefv60_pins[] = {
 	GPIO32_GPIO | PIN_INPUT_PULLDOWN, /* Magnetometer DRDY */
 
 	/* Display Interface */
-	GPIO65_GPIO		| PIN_OUTPUT_LOW, /* DISP1 RST */
+	GPIO65_GPIO		| PIN_OUTPUT_HIGH, /* DISP1 NO RST */
 	GPIO66_GPIO		| PIN_OUTPUT_LOW, /* DISP2 RST */
 
 	/* Touch screen INTERFACE */
@@ -216,11 +150,8 @@ static pin_cfg_t hrefv60_pins[] = {
 	/* DiPro Sensor Interface */
 	GPIO139_GPIO	| PIN_INPUT_PULLUP, /* DIPRO_INT */
 
-	/* HAL SWITCH INTERFACE */
-	GPIO145_GPIO	| PIN_INPUT_PULLDOWN,/* HAL_SW */
-
 	/* Audio Amplifier Interface */
-	GPIO149_GPIO	| PIN_OUTPUT_LOW, /* VAUDIO_HF_EN */
+	GPIO149_GPIO	| PIN_OUTPUT_HIGH, /* VAUDIO_HF_EN, enable MAX8968 */
 
 	/* GBF INTERFACE */
 	GPIO171_GPIO	| PIN_OUTPUT_LOW, /* GBF_ENA_RESET */
@@ -232,10 +163,29 @@ static pin_cfg_t hrefv60_pins[] = {
 	GPIO82_GPIO		| PIN_INPUT_PULLUP, /* ACC_INT1 */
 	GPIO83_GPIO		| PIN_INPUT_PULLUP, /* ACC_INT2 */
 
-	/* Proximity Sensor */
-	GPIO217_GPIO		| PIN_INPUT_PULLUP,
+	/* SD card detect */
+	GPIO95_GPIO	| PIN_INPUT_PULLUP,
+};
 
+static pin_cfg_t u9500_pins[] = {
+	GPIO4_U1_RXD    | PIN_INPUT_PULLUP,
+	GPIO5_U1_TXD    | PIN_OUTPUT_HIGH,
+	GPIO144_GPIO	| PIN_INPUT_PULLUP,/* WLAN_IRQ */
+
+	/* HSI */
+	GPIO219_HSIR_FLA0 | PIN_INPUT_PULLDOWN,
+	GPIO220_HSIR_DAT0 | PIN_INPUT_PULLDOWN,
+	GPIO221_HSIR_RDY0 | PIN_OUTPUT_LOW,
+	GPIO222_HSIT_FLA0 | PIN_OUTPUT_LOW,
+	GPIO223_HSIT_DAT0 | PIN_OUTPUT_LOW,
+	GPIO224_HSIT_RDY0 | PIN_INPUT_PULLDOWN,
+	GPIO225_HSIT_CAWAKE0 | PIN_INPUT_PULLDOWN, /* CA_WAKE0 */
+	GPIO226_GPIO	| PIN_OUTPUT_HIGH, /* AC_WAKE0 */
+};
 
+static pin_cfg_t u8500_pins[] = {
+	GPIO226_GPIO	| PIN_OUTPUT_LOW, /* WLAN_PMU_EN */
+	GPIO4_GPIO		| PIN_INPUT_PULLUP,/* WLAN_IRQ */
 };
 
 static pin_cfg_t snowball_pins[] = {
@@ -276,13 +226,245 @@ static pin_cfg_t snowball_pins[] = {
 
 	/* RSTn_LAN */
 	GPIO141_GPIO		| PIN_OUTPUT_HIGH,
+
+	/*  Accelerometer/Magnetometer */
+	GPIO163_GPIO		| PIN_INPUT_PULLUP, /* ACCEL_IRQ1 */
+	GPIO164_GPIO		| PIN_INPUT_PULLUP, /* ACCEL_IRQ2 */
+	GPIO165_GPIO		| PIN_INPUT_PULLUP, /* MAG_DRDY */
+
+	/* WLAN/GBF */
+	GPIO161_GPIO		| PIN_OUTPUT_LOW, /* WLAN_PMU_EN */
+	GPIO171_GPIO		| PIN_OUTPUT_HIGH,/* GBF_ENA */
+	GPIO215_GPIO		| PIN_OUTPUT_LOW,/* WLAN_ENA */
+	GPIO216_GPIO		| PIN_INPUT_PULLUP,/* WLAN_IRQ */
+};
+
+/*
+ * I2C
+ */
+
+static UX500_PINS(mop500_pins_i2c0,
+	GPIO147_I2C0_SCL |
+		PIN_SLPM_GPIO | PIN_SLPM_INPUT_NOPULL,
+	GPIO148_I2C0_SDA |
+		PIN_SLPM_GPIO | PIN_SLPM_INPUT_NOPULL,
+);
+
+static UX500_PINS(mop500_pins_i2c1,
+	GPIO16_I2C1_SCL |
+		PIN_SLPM_GPIO | PIN_SLPM_INPUT_NOPULL,
+	GPIO17_I2C1_SDA |
+		PIN_SLPM_GPIO | PIN_SLPM_INPUT_NOPULL,
+);
+
+static UX500_PINS(mop500_pins_i2c2,
+	GPIO10_I2C2_SDA |
+		PIN_SLPM_GPIO | PIN_SLPM_INPUT_NOPULL,
+	GPIO11_I2C2_SCL |
+		PIN_SLPM_GPIO | PIN_SLPM_INPUT_NOPULL,
+);
+
+static UX500_PINS(mop500_pins_i2c3,
+	GPIO229_I2C3_SDA |
+		PIN_SLPM_GPIO | PIN_SLPM_INPUT_NOPULL,
+	GPIO230_I2C3_SCL |
+		PIN_SLPM_GPIO | PIN_SLPM_INPUT_NOPULL,
+);
+
+static UX500_PINS(mop500_pins_mcde_tvout,
+	GPIO78_LCD_D8,
+	GPIO79_LCD_D9,
+	GPIO80_LCD_D10,
+	GPIO81_LCD_D11,
+	GPIO150_LCDA_CLK,
+);
+
+static UX500_PINS(mop500_pins_mcde_hdmi,
+	GPIO69_LCD_VSI1	| PIN_INPUT_PULLUP,
+);
+
+static UX500_PINS(mop500_pins_ske,
+	GPIO153_KP_I7 | PIN_INPUT_PULLDOWN | PIN_SLPM_INPUT_PULLUP,
+	GPIO154_KP_I6 | PIN_INPUT_PULLDOWN | PIN_SLPM_INPUT_PULLUP,
+	GPIO155_KP_I5 | PIN_INPUT_PULLDOWN | PIN_SLPM_INPUT_PULLUP,
+	GPIO156_KP_I4 | PIN_INPUT_PULLDOWN | PIN_SLPM_INPUT_PULLUP,
+	GPIO161_KP_I3 | PIN_INPUT_PULLDOWN | PIN_SLPM_INPUT_PULLUP,
+	GPIO162_KP_I2 | PIN_INPUT_PULLDOWN | PIN_SLPM_INPUT_PULLUP,
+	GPIO163_KP_I1 | PIN_INPUT_PULLDOWN | PIN_SLPM_INPUT_PULLUP,
+	GPIO164_KP_I0 | PIN_INPUT_PULLDOWN | PIN_SLPM_INPUT_PULLUP,
+	GPIO157_KP_O7 | PIN_INPUT_PULLUP | PIN_SLPM_OUTPUT_LOW,
+	GPIO158_KP_O6 | PIN_INPUT_PULLUP | PIN_SLPM_OUTPUT_LOW,
+	GPIO159_KP_O5 | PIN_INPUT_PULLUP | PIN_SLPM_OUTPUT_LOW,
+	GPIO160_KP_O4 | PIN_INPUT_PULLUP | PIN_SLPM_OUTPUT_LOW,
+	GPIO165_KP_O3 | PIN_INPUT_PULLUP | PIN_SLPM_OUTPUT_LOW,
+	GPIO166_KP_O2 | PIN_INPUT_PULLUP | PIN_SLPM_OUTPUT_LOW,
+	GPIO167_KP_O1 | PIN_INPUT_PULLUP | PIN_SLPM_OUTPUT_LOW,
+	GPIO168_KP_O0 | PIN_INPUT_PULLUP | PIN_SLPM_OUTPUT_LOW,
+);
+
+/* sdi0 (removable MMC/SD/SDIO cards) */
+static UX500_PINS(mop500_pins_sdi0,
+	GPIO18_MC0_CMDDIR	| PIN_OUTPUT_HIGH,
+	GPIO19_MC0_DAT0DIR	| PIN_OUTPUT_HIGH,
+	GPIO20_MC0_DAT2DIR	| PIN_OUTPUT_HIGH,
+
+	GPIO22_MC0_FBCLK	| PIN_INPUT_NOPULL,
+	GPIO23_MC0_CLK		| PIN_OUTPUT_LOW,
+	GPIO24_MC0_CMD		| PIN_INPUT_PULLUP,
+	GPIO25_MC0_DAT0		| PIN_INPUT_PULLUP,
+	GPIO26_MC0_DAT1		| PIN_INPUT_PULLUP,
+	GPIO27_MC0_DAT2		| PIN_INPUT_PULLUP,
+	GPIO28_MC0_DAT3		| PIN_INPUT_PULLUP,
+);
+
+/* sdi1 (WLAN CW1200) */
+static UX500_PINS(mop500_pins_sdi1,
+	GPIO208_MC1_CLK		| PIN_OUTPUT_LOW,
+	GPIO209_MC1_FBCLK	| PIN_INPUT_NOPULL,
+	GPIO210_MC1_CMD		| PIN_INPUT_PULLUP,
+	GPIO211_MC1_DAT0	| PIN_INPUT_PULLUP,
+	GPIO212_MC1_DAT1	| PIN_INPUT_PULLUP,
+	GPIO213_MC1_DAT2	| PIN_INPUT_PULLUP,
+	GPIO214_MC1_DAT3	| PIN_INPUT_PULLUP,
+);
+
+/* sdi2 (POP eMMC) */
+static UX500_PINS(mop500_pins_sdi2,
+	GPIO128_MC2_CLK		| PIN_OUTPUT_LOW,
+	GPIO129_MC2_CMD		| PIN_INPUT_PULLUP,
+	GPIO130_MC2_FBCLK	| PIN_INPUT_NOPULL,
+	GPIO131_MC2_DAT0	| PIN_INPUT_PULLUP,
+	GPIO132_MC2_DAT1	| PIN_INPUT_PULLUP,
+	GPIO133_MC2_DAT2	| PIN_INPUT_PULLUP,
+	GPIO134_MC2_DAT3	| PIN_INPUT_PULLUP,
+	GPIO135_MC2_DAT4	| PIN_INPUT_PULLUP,
+	GPIO136_MC2_DAT5	| PIN_INPUT_PULLUP,
+	GPIO137_MC2_DAT6	| PIN_INPUT_PULLUP,
+	GPIO138_MC2_DAT7	| PIN_INPUT_PULLUP,
+);
+
+/* sdi4 (PCB eMMC) */
+static UX500_PINS(mop500_pins_sdi4,
+	GPIO197_MC4_DAT3	| PIN_INPUT_PULLUP,
+	GPIO198_MC4_DAT2	| PIN_INPUT_PULLUP,
+	GPIO199_MC4_DAT1	| PIN_INPUT_PULLUP,
+	GPIO200_MC4_DAT0	| PIN_INPUT_PULLUP,
+	GPIO201_MC4_CMD		| PIN_INPUT_PULLUP,
+	GPIO202_MC4_FBCLK	| PIN_INPUT_NOPULL,
+	GPIO203_MC4_CLK		| PIN_OUTPUT_LOW,
+	GPIO204_MC4_DAT7	| PIN_INPUT_PULLUP,
+	GPIO205_MC4_DAT6	| PIN_INPUT_PULLUP,
+	GPIO206_MC4_DAT5	| PIN_INPUT_PULLUP,
+	GPIO207_MC4_DAT4	| PIN_INPUT_PULLUP,
+);
+
+/* USB */
+static UX500_PINS(mop500_pins_usb,
+	GPIO256_USB_NXT,
+	GPIO257_USB_STP		| PIN_OUTPUT_HIGH,
+	GPIO258_USB_XCLK,
+	GPIO259_USB_DIR,
+	GPIO260_USB_DAT7,
+	GPIO261_USB_DAT6,
+	GPIO262_USB_DAT5,
+	GPIO263_USB_DAT4,
+	GPIO264_USB_DAT3,
+	GPIO265_USB_DAT2,
+	GPIO266_USB_DAT1,
+	GPIO267_USB_DAT0,
+);
+
+/* SPI2 */
+static UX500_PINS(mop500_pins_spi2,
+	GPIO216_GPIO    | PIN_OUTPUT_HIGH,
+	GPIO218_SPI2_RXD        | PIN_INPUT_PULLDOWN,
+	GPIO215_SPI2_TXD        | PIN_OUTPUT_LOW,
+	GPIO217_SPI2_CLK        | PIN_OUTPUT_LOW,
+);
+
+static UX500_PINS(mop500_pins_sensors1p_v60,
+	GPIO217_GPIO| PIN_INPUT_PULLUP |
+		  PIN_SLPM_GPIO | PIN_SLPM_INPUT_NOPULL,
+	GPIO145_GPIO | PIN_INPUT_PULLDOWN |
+		  PIN_SLPM_GPIO | PIN_SLPM_INPUT_NOPULL,
+	GPIO139_GPIO | PIN_INPUT_PULLUP |
+		  PIN_SLPM_GPIO | PIN_SLPM_INPUT_NOPULL,
+);
+
+static UX500_PINS(mop500_pins_sensors1p,
+	PIN_CFG_INPUT(GPIO_PROX_SENSOR, GPIO, NOPULL),
+	PIN_CFG_INPUT(GPIO_HAL_SENSOR, GPIO, NOPULL),
+);
+
+static struct ux500_pin_lookup mop500_runtime_pins[] = {
+	PIN_LOOKUP("mcde-tvout", &mop500_pins_mcde_tvout),
+	PIN_LOOKUP("av8100-hdmi", &mop500_pins_mcde_hdmi),
+	PIN_LOOKUP("nmk-i2c.0", &mop500_pins_i2c0),
+	PIN_LOOKUP("nmk-i2c.1", &mop500_pins_i2c1),
+	PIN_LOOKUP("nmk-i2c.2", &mop500_pins_i2c2),
+	PIN_LOOKUP("nmk-i2c.3", &mop500_pins_i2c3),
+	PIN_LOOKUP("sdi0", &mop500_pins_sdi0),
+	PIN_LOOKUP("sdi1", &mop500_pins_sdi1),
+	PIN_LOOKUP("sdi2", &mop500_pins_sdi2),
+	PIN_LOOKUP("sdi4", &mop500_pins_sdi4),
+	PIN_LOOKUP("musb-ux500.0", &mop500_pins_usb),
+	PIN_LOOKUP("spi2", &mop500_pins_spi2),
 };
 
+static struct ux500_pin_lookup mop500_runtime_pins_v60[] = {
+	PIN_LOOKUP("ske", &mop500_pins_ske),
+	PIN_LOOKUP("gpio-keys.0", &mop500_pins_sensors1p_v60),
+};
+
+static struct ux500_pin_lookup mop500_runtime_pins_pre_v60[] = {
+	PIN_LOOKUP("ske", &mop500_pins_ske),
+	PIN_LOOKUP("gpio-keys.0", &mop500_pins_sensors1p),
+};
+
+/*
+ * passing "pinsfor=" in kernel cmdline allows for custom
+ * configuration of GPIOs on u8500 derived boards.
+ */
+static int __init early_pinsfor(char *p)
+{
+	pinsfor = PINS_FOR_DEFAULT;
+
+	if (strcmp(p, "u9500-21") == 0)
+		pinsfor = PINS_FOR_U9500;
+
+	return 0;
+}
+early_param("pinsfor", early_pinsfor);
+
+int pins_for_u9500(void)
+{
+	if (pinsfor == PINS_FOR_U9500)
+		return 1;
+
+	return 0;
+}
+
 void __init mop500_pins_init(void)
 {
 	nmk_config_pins(mop500_pins_common,
 			ARRAY_SIZE(mop500_pins_common));
 
+	ux500_pins_add(mop500_runtime_pins, ARRAY_SIZE(mop500_runtime_pins));
+
+	ux500_pins_add(mop500_runtime_pins_pre_v60,
+		       ARRAY_SIZE(mop500_runtime_pins_pre_v60));
+
+	switch (pinsfor) {
+	case PINS_FOR_U9500:
+		nmk_config_pins(u9500_pins, ARRAY_SIZE(u9500_pins));
+		break;
+
+	case PINS_FOR_DEFAULT:
+		nmk_config_pins(u8500_pins, ARRAY_SIZE(u8500_pins));
+	default:
+		break;
+	}
+
 	nmk_config_pins(mop500_pins_default,
 			ARRAY_SIZE(mop500_pins_default));
 }
@@ -292,8 +474,11 @@ void __init snowball_pins_init(void)
 	nmk_config_pins(mop500_pins_common,
 			ARRAY_SIZE(mop500_pins_common));
 
-	nmk_config_pins(snowball_pins,
-			ARRAY_SIZE(snowball_pins));
+	ux500_pins_add(mop500_runtime_pins, ARRAY_SIZE(mop500_runtime_pins));
+
+	nmk_config_pins(u8500_pins, ARRAY_SIZE(u8500_pins));
+
+	nmk_config_pins(snowball_pins, ARRAY_SIZE(snowball_pins));
 }
 
 void __init hrefv60_pins_init(void)
@@ -301,6 +486,22 @@ void __init hrefv60_pins_init(void)
 	nmk_config_pins(mop500_pins_common,
 			ARRAY_SIZE(mop500_pins_common));
 
+	ux500_pins_add(mop500_runtime_pins, ARRAY_SIZE(mop500_runtime_pins));
+
+	ux500_pins_add(mop500_runtime_pins_v60,
+		       ARRAY_SIZE(mop500_runtime_pins_v60));
+
 	nmk_config_pins(hrefv60_pins,
 			ARRAY_SIZE(hrefv60_pins));
+
+	switch (pinsfor) {
+	case PINS_FOR_U9500:
+		nmk_config_pins(u9500_pins, ARRAY_SIZE(u9500_pins));
+		break;
+
+	case PINS_FOR_DEFAULT:
+		nmk_config_pins(u8500_pins, ARRAY_SIZE(u8500_pins));
+	default:
+		break;
+	}
 }
diff --git a/arch/arm/mach-ux500/board-mop500.h b/arch/arm/mach-ux500/board-mop500.h
index fdcfa87..91dc63f 100644
--- a/arch/arm/mach-ux500/board-mop500.h
+++ b/arch/arm/mach-ux500/board-mop500.h
@@ -7,6 +7,9 @@
 #ifndef __BOARD_MOP500_H
 #define __BOARD_MOP500_H
 
+/* For NOMADIK_NR_GPIO */
+#include <mach/irqs.h>
+
 /* Snowball specific GPIO assignments, this board has no GPIO expander */
 #define SNOWBALL_ACCEL_INT1_GPIO	163
 #define SNOWBALL_ACCEL_INT2_GPIO	164
@@ -73,6 +76,7 @@
 #define SNOWBALL_PME_ETH_GPIO		MOP500_AB8500_PIN_GPIO(24)	/* SYSCLKREQ7/GPIO24 */
 #define SNOWBALL_EN_3V3_ETH_GPIO	MOP500_AB8500_PIN_GPIO(26)	/* GPIO26 */
 
+struct device;
 struct i2c_board_info;
 
 extern void mop500_sdi_init(struct device *parent);
-- 
1.7.9.2

