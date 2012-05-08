Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753111Ab2EHJq7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 05:46:59 -0400
Received: from eu1sys200aog107.obsmtp.com ([207.126.144.123]:44840 "EHLO
	eu1sys200aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752653Ab2EHJqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 05:46:55 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Cc: Stephen Warren <swarren@nvidia.com>, Shawn Guo <shawn.guo@freescale.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 08/12] ARM: ux500: switch over to Nomadik pinctrl driver
Date: Tue, 8 May 2012 11:45:17 +0200
Message-ID: <1336470317-23745-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.9.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

This converts the Ux500 family to use the pinctrl driver for
configuring pins.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 arch/arm/mach-ux500/board-mop500-pins.c |  819 +++++++++++++++----------------
 arch/arm/mach-ux500/board-mop500.c      |   21 +-
 arch/arm/mach-ux500/board-mop500.h      |    6 +-
 3 files changed, 411 insertions(+), 435 deletions(-)

diff --git a/arch/arm/mach-ux500/board-mop500-pins.c b/arch/arm/mach-ux500/board-mop500-pins.c
index df5b190..28c456c 100644
--- a/arch/arm/mach-ux500/board-mop500-pins.c
+++ b/arch/arm/mach-ux500/board-mop500-pins.c
@@ -8,6 +8,7 @@
 #include <linux/init.h>
 #include <linux/bug.h>
 #include <linux/string.h>
+#include <linux/pinctrl/machine.h>
 
 #include <asm/mach-types.h>
 #include <plat/pincfg.h>
@@ -26,399 +27,390 @@ enum custom_pin_cfg_t {
 
 static enum custom_pin_cfg_t pinsfor;
 
-static pin_cfg_t mop500_pins_common[] = {
-	/* uMSP0 */
-	GPIO12_MSP0_TXD,
-	GPIO13_MSP0_TFS,
-	GPIO14_MSP0_TCK,
-	GPIO15_MSP0_RXD,
-
-	/* MSP2: HDMI */
-	GPIO193_MSP2_TXD | PIN_INPUT_PULLDOWN,
-	GPIO194_MSP2_TCK | PIN_INPUT_PULLDOWN,
-	GPIO195_MSP2_TFS | PIN_INPUT_PULLDOWN,
-	GPIO196_MSP2_RXD | PIN_OUTPUT_LOW,
-
-	/* LCD TE0 */
-	GPIO68_LCD_VSI0	| PIN_INPUT_PULLUP,
-
-	/* Touch screen INTERFACE */
-	GPIO84_GPIO	| PIN_INPUT_PULLUP, /* TOUCH_INT1 */
-
-	/* STMPE1601/tc35893 keypad  IRQ */
-	GPIO218_GPIO	| PIN_INPUT_PULLUP,
-
-	/* UART */
-	/* uart-0 pins gpio configuration should be
-	 * kept intact to prevent glitch in tx line
-	 * when tty dev is opened. Later these pins
+/* These simply sets bias for pins */
+#define BIAS(a,b) static unsigned long a[] = { b }
+
+BIAS(pd, PIN_PULL_DOWN);
+BIAS(slpm_gpio_nopull, PIN_SLPM_GPIO|PIN_SLPM_INPUT_NOPULL);
+BIAS(in_nopull, PIN_INPUT_NOPULL);
+BIAS(in_pu, PIN_INPUT_PULLUP);
+BIAS(in_pd, PIN_INPUT_PULLDOWN);
+BIAS(in_pd_slpm_in_pu, PIN_INPUT_PULLDOWN|PIN_SLPM_INPUT_PULLUP);
+BIAS(in_pu_slpm_out_lo, PIN_INPUT_PULLUP|PIN_SLPM_OUTPUT_LOW);
+BIAS(out_hi, PIN_OUTPUT_HIGH);
+BIAS(out_lo, PIN_OUTPUT_LOW);
+/* These also force them into GPIO mode */
+BIAS(gpio_in_pu, PIN_INPUT_PULLUP|PIN_GPIOMODE_ENABLED);
+BIAS(gpio_in_pd, PIN_INPUT_PULLDOWN|PIN_GPIOMODE_ENABLED);
+BIAS(gpio_in_pu_slpm_gpio_nopull, PIN_INPUT_PULLUP|PIN_GPIOMODE_ENABLED|PIN_SLPM_GPIO|PIN_SLPM_INPUT_NOPULL);
+BIAS(gpio_in_pd_slpm_gpio_nopull, PIN_INPUT_PULLDOWN|PIN_GPIOMODE_ENABLED|PIN_SLPM_GPIO|PIN_SLPM_INPUT_NOPULL);
+BIAS(gpio_out_hi, PIN_OUTPUT_HIGH|PIN_GPIOMODE_ENABLED);
+BIAS(gpio_out_lo, PIN_OUTPUT_LOW|PIN_GPIOMODE_ENABLED);
+
+/* We use these to define hog settings that are always done on boot */
+#define DB8500_MUX_HOG(group,func) \
+	PIN_MAP_MUX_GROUP_HOG_DEFAULT("pinctrl-db8500", group, func)
+#define DB8500_PIN_HOG(pin,conf) \
+	PIN_MAP_CONFIGS_PIN_HOG_DEFAULT("pinctrl-db8500", pin, conf)
+
+/* These are default states associated with device and changed runtime */
+#define DB8500_MUX(group,func,dev) \
+	PIN_MAP_MUX_GROUP_DEFAULT(dev, "pinctrl-db8500", group, func)
+#define DB8500_PIN(pin,conf,dev) \
+	PIN_MAP_CONFIGS_PIN_DEFAULT(dev, "pinctrl-db8500", pin, conf)
+
+/* Pin control settings */
+static struct pinctrl_map __initdata mop500_family_pinmap[] = {
+	/*
+	 * uMSP0, mux in 4 pins, regular placement of RX/TX
+	 * explicitly set the pins to no pull
+	 */
+	DB8500_MUX_HOG("msp0txrx_a_1", "msp0"),
+	DB8500_MUX_HOG("msp0tfstck_a_1", "msp0"),
+	DB8500_PIN_HOG("GPIO12_AC4", in_nopull), /* TXD */
+	DB8500_PIN_HOG("GPIO15_AC3", in_nopull), /* RXD */
+	DB8500_PIN_HOG("GPIO13_AF3", in_nopull), /* TFS */
+	DB8500_PIN_HOG("GPIO14_AE3", in_nopull), /* TCK */
+	/* MSP2 for HDMI, pull down TXD, TCK, TFS  */
+	DB8500_MUX_HOG("msp2_a_1", "msp2"),
+	DB8500_PIN_HOG("GPIO193_AH27", in_pd), /* TXD */
+	DB8500_PIN_HOG("GPIO194_AF27", in_pd), /* TCK */
+	DB8500_PIN_HOG("GPIO195_AG28", in_pd), /* TFS */
+	DB8500_PIN_HOG("GPIO196_AG26", out_lo), /* RXD */
+	/*
+	 * LCD, set TE0 (using LCD VSI0) and D14 (touch screen interrupt) to
+	 * pull-up
+	 * TODO: is this really correct? Snowball doesn't have a LCD.
+	 */
+	DB8500_MUX_HOG("lcdvsi0_a_1", "lcd"),
+	DB8500_PIN_HOG("GPIO68_E1", in_pu),
+	DB8500_PIN_HOG("GPIO84_C2", gpio_in_pu),
+	/*
+	 * STMPE1601/tc35893 keypad IRQ GPIO 218
+	 * TODO: set for snowball and HREF really??
+	 */
+	DB8500_PIN_HOG("GPIO218_AH11", gpio_in_pu),
+	/*
+	 * UART0, we do not mux in u0 here.
+	 * uart-0 pins gpio configuration should be kept intact to prevent
+	 * a glitch in tx line when the tty dev is opened. Later these pins
 	 * are configured to uart mop500_pins_uart0
-	 *
-	 * It will be replaced with uart configuration
-	 * once the issue is solved.
 	 */
-	GPIO0_GPIO	| PIN_INPUT_PULLUP,
-	GPIO1_GPIO	| PIN_OUTPUT_HIGH,
-	GPIO2_GPIO	| PIN_INPUT_PULLUP,
-	GPIO3_GPIO	| PIN_OUTPUT_HIGH,
-
-	GPIO29_U2_RXD	| PIN_INPUT_PULLUP,
-	GPIO30_U2_TXD	| PIN_OUTPUT_HIGH,
-	GPIO31_U2_CTSn	| PIN_INPUT_PULLUP,
-	GPIO32_U2_RTSn	| PIN_OUTPUT_HIGH,
+	DB8500_PIN_HOG("GPIO0_AJ5", in_pu), /* CTS */
+	DB8500_PIN_HOG("GPIO1_AJ3", out_hi), /* RTS */
+	DB8500_PIN_HOG("GPIO2_AH4", in_pu), /* RXD */
+	DB8500_PIN_HOG("GPIO3_AH3", out_hi), /* TXD */
+	/*
+	 * Mux in UART2 on altfunction C and set pull-ups.
+	 * TODO: is this used on U8500 variants and Snowball really?
+	 * The setting on GPIO31 conflicts with magnetometer use on hrefv60
+	 */
+	DB8500_MUX_HOG("u2rxtx_c_1", "u2"),
+	DB8500_MUX_HOG("u2ctsrts_c_1", "u2"),
+	DB8500_PIN_HOG("GPIO29_W2", in_pu), /* RXD */
+	DB8500_PIN_HOG("GPIO30_W3", out_hi), /* TXD */
+	DB8500_PIN_HOG("GPIO31_V3", in_pu), /* CTS */
+	DB8500_PIN_HOG("GPIO32_V2", out_hi), /* RTS */
+	/*
+	 * The following pin sets were known as "runtime pins" before being
+	 * converted to the pinctrl model. Here we model them as "default"
+	 * states.
+	 */
+	/* Mux in LCD data lines 8 thru 11 and LCDA CLK for MCDE TVOUT */
+	DB8500_MUX("lcd_d8_d11_a_1", "lcd", "mcde-tvout"),
+	DB8500_MUX("lcdaclk_b_1", "lcda", "mcde-tvout"),
+	/* Mux in LCD VSI1 and pull it up for MCDE HDMI output */
+	DB8500_MUX("lcdvsi1_a_1", "lcd", "av8100-hdmi"),
+	/* Mux in I2C blocks, put pins into GPIO in sleepmode no pull-up */
+	DB8500_MUX("i2c0_a_1", "i2c0", "nmk-i2c.0"),
+	DB8500_PIN("GPIO147_C15", slpm_gpio_nopull, "nmk-i2c.0"),
+	DB8500_PIN("GPIO148_B16", slpm_gpio_nopull, "nmk-i2c.0"),
+	DB8500_MUX("i2c1_b_2", "i2c1", "nmk-i2c.1"),
+	DB8500_PIN("GPIO16_AD3", slpm_gpio_nopull, "nmk-i2c.1"),
+	DB8500_PIN("GPIO17_AD4", slpm_gpio_nopull, "nmk-i2c.1"),
+	DB8500_MUX("i2c2_b_2", "i2c2", "nmk-i2c.2"),
+	DB8500_PIN("GPIO10_AF5", slpm_gpio_nopull, "nmk-i2c.2"),
+	DB8500_PIN("GPIO11_AG4", slpm_gpio_nopull, "nmk-i2c.2"),
+	DB8500_MUX("i2c3_c_2", "i2c3", "nmk-i2c.3"),
+	DB8500_PIN("GPIO229_AG7", slpm_gpio_nopull, "nmk-i2c.3"),
+	DB8500_PIN("GPIO230_AF7", slpm_gpio_nopull, "nmk-i2c.3"),
+	/* Mux in SDI0 (here called MC0) used for removable MMC/SD/SDIO cards */
+	DB8500_MUX("mc0_a_1", "mc0", "sdi0"),
+	DB8500_PIN("GPIO18_AC2", out_hi, "sdi0"), /* CMDDIR */
+	DB8500_PIN("GPIO19_AC1", out_hi, "sdi0"), /* DAT0DIR */
+	DB8500_PIN("GPIO20_AB4", out_hi, "sdi0"), /* DAT2DIR */
+	DB8500_PIN("GPIO22_AA3", in_nopull, "sdi0"), /* FBCLK */
+	DB8500_PIN("GPIO23_AA4", out_lo, "sdi0"), /* CLK */
+	DB8500_PIN("GPIO24_AB2", in_pu, "sdi0"), /* CMD */
+	DB8500_PIN("GPIO25_Y4", in_pu, "sdi0"), /* DAT0 */
+	DB8500_PIN("GPIO26_Y2", in_pu, "sdi0"), /* DAT1 */
+	DB8500_PIN("GPIO27_AA2", in_pu, "sdi0"), /* DAT2 */
+	DB8500_PIN("GPIO28_AA1", in_pu, "sdi0"), /* DAT3 */
+	/* Mux in SDI1 (here called MC1) used for SDIO for CW1200 WLAN */
+	DB8500_MUX("mc1_a_1", "mc1", "sdi1"),
+	DB8500_PIN("GPIO208_AH16", out_lo, "sdi1"), /* CLK */
+	DB8500_PIN("GPIO209_AG15", in_nopull, "sdi1"), /* FBCLK */
+	DB8500_PIN("GPIO210_AJ15", in_pu, "sdi1"), /* CMD */
+	DB8500_PIN("GPIO211_AG14", in_pu, "sdi1"), /* DAT0 */
+	DB8500_PIN("GPIO212_AF13", in_pu, "sdi1"), /* DAT1 */
+	DB8500_PIN("GPIO213_AG13", in_pu, "sdi1"), /* DAT2 */
+	DB8500_PIN("GPIO214_AH15", in_pu, "sdi1"), /* DAT3 */
+	/* Mux in SDI2 (here called MC2) used for for PoP eMMC */
+	DB8500_MUX("mc2_a_1", "mc2", "sdi2"),
+	DB8500_PIN("GPIO128_A5", out_lo, "sdi2"), /* CLK */
+	DB8500_PIN("GPIO129_B4", in_pu, "sdi2"), /* CMD */
+	DB8500_PIN("GPIO130_C8", in_nopull, "sdi2"), /* FBCLK */
+	DB8500_PIN("GPIO131_A12", in_pu, "sdi2"), /* DAT0 */
+	DB8500_PIN("GPIO132_C10", in_pu, "sdi2"), /* DAT1 */
+	DB8500_PIN("GPIO133_B10", in_pu, "sdi2"), /* DAT2 */
+	DB8500_PIN("GPIO134_B9", in_pu, "sdi2"), /* DAT3 */
+	DB8500_PIN("GPIO135_A9", in_pu, "sdi2"), /* DAT4 */
+	DB8500_PIN("GPIO136_C7", in_pu, "sdi2"), /* DAT5 */
+	DB8500_PIN("GPIO137_A7", in_pu, "sdi2"), /* DAT6 */
+	DB8500_PIN("GPIO138_C5", in_pu, "sdi2"), /* DAT7 */
+	/* Mux in SDI4 (here called MC4) used for for PCB-mounted eMMC */
+	DB8500_MUX("mc4_a_1", "mc4", "sdi4"),
+	DB8500_PIN("GPIO197_AH24", in_pu, "sdi4"), /* DAT3 */
+	DB8500_PIN("GPIO198_AG25", in_pu, "sdi4"), /* DAT2 */
+	DB8500_PIN("GPIO199_AH23", in_pu, "sdi4"), /* DAT1 */
+	DB8500_PIN("GPIO200_AH26", in_pu, "sdi4"), /* DAT0 */
+	DB8500_PIN("GPIO201_AF24", in_pu, "sdi4"), /* CMD */
+	DB8500_PIN("GPIO202_AF25", in_nopull, "sdi4"), /* FBCLK */
+	DB8500_PIN("GPIO203_AE23", out_lo, "sdi4"), /* CLK */
+	DB8500_PIN("GPIO204_AF23", in_pu, "sdi4"), /* DAT7 */
+	DB8500_PIN("GPIO205_AG23", in_pu, "sdi4"), /* DAT6 */
+	DB8500_PIN("GPIO206_AG24", in_pu, "sdi4"), /* DAT5 */
+	DB8500_PIN("GPIO207_AJ23", in_pu, "sdi4"), /* DAT4 */
+	/* Mux in USB pins, drive STP high */
+	DB8500_MUX("usb_a_1", "usb", "musb-ux500.0"),
+	DB8500_PIN("GPIO257_AE29", out_hi, "musb-ux500.0"), /* STP */
+	/* Mux in SPI2 pins on the "other C1" altfunction */
+	DB8500_MUX("spi2_oc1_1", "spi2", "spi2"),
+	DB8500_PIN("GPIO216_AG12", gpio_out_hi, "spi2"), /* FRM */
+	DB8500_PIN("GPIO218_AH11", in_pd, "spi2"), /* RXD */
+	DB8500_PIN("GPIO215_AH13", out_lo, "spi2"), /* TXD */
+	DB8500_PIN("GPIO217_AH12", out_lo, "spi2"), /* CLK */
 };
 
-static pin_cfg_t mop500_pins_default[] = {
-	/* SSP0 */
-	GPIO143_SSP0_CLK,
-	GPIO144_SSP0_FRM,
-	GPIO145_SSP0_RXD | PIN_PULL_DOWN,
-	GPIO146_SSP0_TXD,
-
-	/* XENON Flashgun INTERFACE */
-	GPIO6_IP_GPIO0	| PIN_INPUT_PULLUP,/* XENON_FLASH_ID */
-	GPIO7_IP_GPIO1	| PIN_INPUT_PULLUP,/* XENON_READY */
-
-	GPIO217_GPIO	| PIN_INPUT_PULLUP, /* TC35892 IRQ */
-
-	/* sdi0 (removable MMC/SD/SDIO cards) not handled by pm_runtime */
-	GPIO21_MC0_DAT31DIR	| PIN_OUTPUT_HIGH,
-
-	/* UART */
-	GPIO4_U1_RXD	| PIN_INPUT_PULLUP,
-	GPIO5_U1_TXD	| PIN_OUTPUT_HIGH,
-	GPIO6_U1_CTSn	| PIN_INPUT_PULLUP,
-	GPIO7_U1_RTSn	| PIN_OUTPUT_HIGH,
+/*
+ * These are specifically for the MOP500 and HREFP (pre-v60) version of the
+ * board, which utilized a TC35892 GPIO expander instead of using a lot of
+ * on-chip pins as the HREFv60 and later does.
+ */
+static struct pinctrl_map __initdata mop500_pinmap[] = {
+	/* Mux in SSP0, pull down RXD pin */
+	DB8500_MUX_HOG("ssp0_a_1", "ssp0"),
+	DB8500_PIN_HOG("GPIO145_C13", pd),
+	/*
+	 * XENON Flashgun on image processor GPIO (controlled from image
+	 * processor firmware), mux in these image processor GPIO lines 0
+	 * (XENON_FLASH_ID) and 1 (XENON_READY) on altfunction C and pull up
+	 * the pins.
+	 */
+	DB8500_MUX_HOG("ipgpio0_c_1", "ipgpio"),
+	DB8500_MUX_HOG("ipgpio1_c_1", "ipgpio"),
+	DB8500_PIN_HOG("GPIO6_AF6", in_pu),
+	DB8500_PIN_HOG("GPIO7_AG5", in_pu),
+	/* TC35892 IRQ, pull up the line, let the driver mux in the pin */
+	DB8500_PIN_HOG("GPIO217_AH12", gpio_in_pu),
+	/* Mux in UART1 and set the pull-ups */
+	DB8500_MUX_HOG("u1rxtx_a_1", "u1"),
+	DB8500_MUX_HOG("u1ctsrts_a_1", "u1"),
+	DB8500_PIN_HOG("GPIO4_AH6", in_pu), /* RXD */
+	DB8500_PIN_HOG("GPIO5_AG6", out_hi), /* TXD */
+	DB8500_PIN_HOG("GPIO6_AF6", in_pu), /* CTS */
+	DB8500_PIN_HOG("GPIO7_AG5", out_hi), /* RTS */
+	/*
+	 * Runtime stuff: make it possible to mux in the SKE keypad
+	 * and bias the pins
+	 */
+	DB8500_MUX("kp_a_2", "kp", "ske"),
+	DB8500_PIN("GPIO153_B17", in_pd_slpm_in_pu, "ske"), /* I7 */
+	DB8500_PIN("GPIO154_C16", in_pd_slpm_in_pu, "ske"), /* I6 */
+	DB8500_PIN("GPIO155_C19", in_pd_slpm_in_pu, "ske"), /* I5 */
+	DB8500_PIN("GPIO156_C17", in_pd_slpm_in_pu, "ske"), /* I4 */
+	DB8500_PIN("GPIO161_D21", in_pd_slpm_in_pu, "ske"), /* I3 */
+	DB8500_PIN("GPIO162_D20", in_pd_slpm_in_pu, "ske"), /* I2 */
+	DB8500_PIN("GPIO163_C20", in_pd_slpm_in_pu, "ske"), /* I1 */
+	DB8500_PIN("GPIO164_B21", in_pd_slpm_in_pu, "ske"), /* I0 */
+	DB8500_PIN("GPIO157_A18", in_pu_slpm_out_lo, "ske"), /* O7 */
+	DB8500_PIN("GPIO158_C18", in_pu_slpm_out_lo, "ske"), /* O6 */
+	DB8500_PIN("GPIO159_B19", in_pu_slpm_out_lo, "ske"), /* O5 */
+	DB8500_PIN("GPIO160_B20", in_pu_slpm_out_lo, "ske"), /* O4 */
+	DB8500_PIN("GPIO165_C21", in_pu_slpm_out_lo, "ske"), /* O3 */
+	DB8500_PIN("GPIO166_A22", in_pu_slpm_out_lo, "ske"), /* O2 */
+	DB8500_PIN("GPIO167_B24", in_pu_slpm_out_lo, "ske"), /* O1 */
+	DB8500_PIN("GPIO168_C22", in_pu_slpm_out_lo, "ske"), /* O0 */
+	/* Mux in and drive the SDI0 DAT31DIR line high at runtime */
+	DB8500_MUX("mc0dat31dir_a_1", "mc0", "sdi0"),
+	DB8500_PIN("GPIO21_AB3", out_hi, "sdi0"),
 };
 
-static pin_cfg_t hrefv60_pins[] = {
-	/* WLAN */
-	GPIO85_GPIO		| PIN_OUTPUT_LOW,/* WLAN_ENA */
-
-	/* XENON Flashgun INTERFACE */
-	GPIO6_IP_GPIO0	| PIN_INPUT_PULLUP,/* XENON_FLASH_ID */
-	GPIO7_IP_GPIO1	| PIN_INPUT_PULLUP,/* XENON_READY */
-
-	/* Assistant LED INTERFACE */
-	GPIO21_GPIO | PIN_OUTPUT_LOW,  /* XENON_EN1 */
-	GPIO64_IP_GPIO4 | PIN_OUTPUT_LOW,  /* XENON_EN2 */
-
-	/* Magnetometer */
-	GPIO31_GPIO | PIN_INPUT_PULLUP,  /* magnetometer_INT */
-	GPIO32_GPIO | PIN_INPUT_PULLDOWN, /* Magnetometer DRDY */
-
-	/* Display Interface */
-	GPIO65_GPIO		| PIN_OUTPUT_HIGH, /* DISP1 NO RST */
-	GPIO66_GPIO		| PIN_OUTPUT_LOW, /* DISP2 RST */
-
-	/* Touch screen INTERFACE */
-	GPIO143_GPIO	| PIN_OUTPUT_LOW,/*TOUCH_RST1 */
-
-	/* Touch screen INTERFACE 2 */
-	GPIO67_GPIO	| PIN_INPUT_PULLUP, /* TOUCH_INT2 */
-	GPIO146_GPIO	| PIN_OUTPUT_LOW,/*TOUCH_RST2 */
-
-	/* ETM_PTM_TRACE INTERFACE */
-	GPIO70_GPIO	| PIN_OUTPUT_LOW,/* ETM_PTM_DATA23 */
-	GPIO71_GPIO	| PIN_OUTPUT_LOW,/* ETM_PTM_DATA22 */
-	GPIO72_GPIO	| PIN_OUTPUT_LOW,/* ETM_PTM_DATA21 */
-	GPIO73_GPIO	| PIN_OUTPUT_LOW,/* ETM_PTM_DATA20 */
-	GPIO74_GPIO	| PIN_OUTPUT_LOW,/* ETM_PTM_DATA19 */
-
-	/* NAHJ INTERFACE */
-	GPIO76_GPIO	| PIN_OUTPUT_LOW,/* NAHJ_CTRL */
-	GPIO216_GPIO	| PIN_OUTPUT_HIGH,/* NAHJ_CTRL_INV */
-
-	/* NFC INTERFACE */
-	GPIO77_GPIO	| PIN_OUTPUT_LOW, /* NFC_ENA */
-	GPIO144_GPIO	| PIN_INPUT_PULLDOWN, /* NFC_IRQ */
-	GPIO142_GPIO	| PIN_OUTPUT_LOW, /* NFC_RESET */
-
-	/* Keyboard MATRIX INTERFACE */
-	GPIO90_MC5_CMD	| PIN_OUTPUT_LOW, /* KP_O_1 */
-	GPIO87_MC5_DAT1	| PIN_OUTPUT_LOW, /* KP_O_2 */
-	GPIO86_MC5_DAT0	| PIN_OUTPUT_LOW, /* KP_O_3 */
-	GPIO96_KP_O6	| PIN_OUTPUT_LOW, /* KP_O_6 */
-	GPIO94_KP_O7	| PIN_OUTPUT_LOW, /* KP_O_7 */
-	GPIO93_MC5_DAT4	| PIN_INPUT_PULLUP, /* KP_I_0 */
-	GPIO89_MC5_DAT3	| PIN_INPUT_PULLUP, /* KP_I_2 */
-	GPIO88_MC5_DAT2	| PIN_INPUT_PULLUP, /* KP_I_3 */
-	GPIO91_GPIO	| PIN_INPUT_PULLUP, /* FORCE_SENSING_INT */
-	GPIO92_GPIO	| PIN_OUTPUT_LOW, /* FORCE_SENSING_RST */
-	GPIO97_GPIO	| PIN_OUTPUT_LOW, /* FORCE_SENSING_WU */
-
-	/* DiPro Sensor Interface */
-	GPIO139_GPIO	| PIN_INPUT_PULLUP, /* DIPRO_INT */
-
-	/* Audio Amplifier Interface */
-	GPIO149_GPIO	| PIN_OUTPUT_HIGH, /* VAUDIO_HF_EN, enable MAX8968 */
-
-	/* GBF INTERFACE */
-	GPIO171_GPIO	| PIN_OUTPUT_LOW, /* GBF_ENA_RESET */
-
-	/* MSP : HDTV INTERFACE */
-	GPIO192_GPIO	| PIN_INPUT_PULLDOWN,
-
-	/* ACCELEROMETER_INTERFACE */
-	GPIO82_GPIO		| PIN_INPUT_PULLUP, /* ACC_INT1 */
-	GPIO83_GPIO		| PIN_INPUT_PULLUP, /* ACC_INT2 */
-
-	/* SD card detect */
-	GPIO95_GPIO	| PIN_INPUT_PULLUP,
+/*
+ * The HREFv60 series of platforms is using available pins on the DB8500
+ * insteaf of the Toshiba I2C GPIO expander, reusing some pins like the SSP0
+ * and SSP1 ports (previously connected to the AB8500) as generic GPIO lines.
+ */
+static struct pinctrl_map __initdata hrefv60_pinmap[] = {
+	/* Drive WLAN_ENA low */
+	DB8500_PIN_HOG("GPIO85_D5", gpio_out_lo), /* WLAN_ENA */
+	/*
+	 * XENON Flashgun on image processor GPIO (controlled from image
+	 * processor firmware), mux in these image processor GPIO lines 0
+	 * (XENON_FLASH_ID), 1 (XENON_READY) and there is an assistant
+	 * LED on IP GPIO 4 (XENON_EN2) on altfunction C, that need bias
+	 * from GPIO21 so pull up 0, 1 and drive 4 and GPIO21 low as output.
+	 */
+	DB8500_MUX_HOG("ipgpio0_c_1", "ipgpio"),
+	DB8500_MUX_HOG("ipgpio1_c_1", "ipgpio"),
+	DB8500_MUX_HOG("ipgpio4_c_1", "ipgpio"),
+	DB8500_PIN_HOG("GPIO6_AF6", in_pu), /* XENON_FLASH_ID */
+	DB8500_PIN_HOG("GPIO7_AG5", in_pu), /* XENON_READY */
+	DB8500_PIN_HOG("GPIO21_AB3", gpio_out_lo), /* XENON_EN1 */
+	DB8500_PIN_HOG("GPIO64_F3", out_lo), /* XENON_EN2 */
+	/* Magnetometer uses GPIO 31 and 32, pull these up/down respectively */
+	DB8500_PIN_HOG("GPIO31_V3", gpio_in_pu), /* EN1 */
+	DB8500_PIN_HOG("GPIO32_V2", gpio_in_pd), /* DRDY */
+	/*
+	 * Display Interface 1 uses GPIO 65 for RST (reset).
+	 * Display Interface 2 uses GPIO 66 for RST (reset).
+	 * Drive DISP1 reset high (not reset), driver DISP2 reset low (reset)
+	 */
+	DB8500_PIN_HOG("GPIO65_F1", gpio_out_hi), /* DISP1 NO RST */
+	DB8500_PIN_HOG("GPIO66_G3", gpio_out_lo), /* DISP2 RST */
+	/*
+	 * Touch screen uses GPIO 143 for RST1, GPIO 146 for RST2 and
+	 * GPIO 67 for interrupts. Pull-up the IRQ line and drive both
+	 * reset signals low.
+	 */
+	DB8500_PIN_HOG("GPIO143_D12", gpio_out_lo), /* TOUCH_RST1 */
+	DB8500_PIN_HOG("GPIO67_G2", gpio_in_pu), /* TOUCH_INT2 */
+	DB8500_PIN_HOG("GPIO146_D13", gpio_out_lo), /* TOUCH_RST2 */
+	/*
+	 * Drive D19-D23 for the ETM PTM trace interface low,
+	 * (presumably pins are unconnected therefore grounded here,
+	 * the "other alt C1" setting enables these pins)
+	 */
+	DB8500_PIN_HOG("GPIO70_G5", gpio_out_lo),
+	DB8500_PIN_HOG("GPIO71_G4", gpio_out_lo),
+	DB8500_PIN_HOG("GPIO72_H4", gpio_out_lo),
+	DB8500_PIN_HOG("GPIO73_H3", gpio_out_lo),
+	DB8500_PIN_HOG("GPIO74_J3", gpio_out_lo),
+	/* NAHJ CTRL on GPIO 76 to low, CTRL_INV on GPIO216 to high */
+	DB8500_PIN_HOG("GPIO76_J2", gpio_out_lo), /* CTRL */
+	DB8500_PIN_HOG("GPIO216_AG12", gpio_out_hi), /* CTRL_INV */
+	/* NFC ENA and RESET to low, pulldown IRQ line */
+	DB8500_PIN_HOG("GPIO77_H1", gpio_out_lo), /* NFC_ENA */
+	DB8500_PIN_HOG("GPIO144_B13", gpio_in_pd), /* NFC_IRQ */
+	DB8500_PIN_HOG("GPIO142_C11", gpio_out_lo), /* NFC_RESET */
+	/*
+	 * SKE keyboard partly on alt A and partly on "Other alt C1"
+	 * Driver KP_O1,2,3,6,7 low and pull up KP_I 0,2,3 for three
+	 * rows of 6 keys, then pull up force sensing interrup and
+	 * drive reset and force sensing WU low.
+	 */
+	DB8500_MUX_HOG("kp_a_1", "kp"),
+	DB8500_MUX_HOG("kp_oc1_1", "kp"),
+	DB8500_PIN_HOG("GPIO90_A3", out_lo), /* KP_O1 */
+	DB8500_PIN_HOG("GPIO87_B3", out_lo), /* KP_O2 */
+	DB8500_PIN_HOG("GPIO86_C6", out_lo), /* KP_O3 */
+	DB8500_PIN_HOG("GPIO96_D8", out_lo), /* KP_O6 */
+	DB8500_PIN_HOG("GPIO94_D7", out_lo), /* KP_O7 */
+	DB8500_PIN_HOG("GPIO93_B7", in_pu), /* KP_I0 */
+	DB8500_PIN_HOG("GPIO89_E6", in_pu), /* KP_I2 */
+	DB8500_PIN_HOG("GPIO88_C4", in_pu), /* KP_I3 */
+	DB8500_PIN_HOG("GPIO91_B6", gpio_in_pu), /* FORCE_SENSING_INT */
+	DB8500_PIN_HOG("GPIO92_D6", gpio_out_lo), /* FORCE_SENSING_RST */
+	DB8500_PIN_HOG("GPIO97_D9", gpio_out_lo), /* FORCE_SENSING_WU */
+	/* DiPro Sensor interrupt */
+	DB8500_PIN_HOG("GPIO139_C9", gpio_in_pu), /* DIPRO_INT */
+	/* Audio Amplifier HF enable */
+	DB8500_PIN_HOG("GPIO149_B14", gpio_out_hi), /* VAUDIO_HF_EN, enable MAX8968 */
+	/* GBF interface, pull low to reset state */
+	DB8500_PIN_HOG("GPIO171_D23", gpio_out_lo), /* GBF_ENA_RESET */
+	/* MSP : HDTV INTERFACE GPIO line */
+	DB8500_PIN_HOG("GPIO192_AJ27", gpio_in_pd),
+	/* Accelerometer interrupt lines */
+	DB8500_PIN_HOG("GPIO82_C1", gpio_in_pu), /* ACC_INT1 */
+	DB8500_PIN_HOG("GPIO83_D3", gpio_in_pu), /* ACC_INT2 */
+	/* SD card detect GPIO pin */
+	DB8500_PIN_HOG("GPIO95_E8", gpio_in_pu),
+	/*
+	 * Runtime stuff
+	 * Pull up/down of some sensor GPIO pins, for proximity, HAL sensor
+	 * etc.
+	 */
+	DB8500_PIN("GPIO217_AH12", gpio_in_pu_slpm_gpio_nopull, "gpio-keys.0"),
+	DB8500_PIN("GPIO145_C13", gpio_in_pd_slpm_gpio_nopull, "gpio-keys.0"),
+	DB8500_PIN("GPIO139_C9", gpio_in_pu_slpm_gpio_nopull, "gpio-keys.0"),
+	/*
+	 * Make it possible to mux in the SKE keypad and bias the pins
+	 * FIXME: what's the point with this on HREFv60? KP/SKE is already
+	 * muxed in at another place! Enabling this will bork.
+	 */
+	DB8500_MUX("kp_a_2", "kp", "ske"),
+	DB8500_PIN("GPIO153_B17", in_pd_slpm_in_pu, "ske"), /* I7 */
+	DB8500_PIN("GPIO154_C16", in_pd_slpm_in_pu, "ske"), /* I6 */
+	DB8500_PIN("GPIO155_C19", in_pd_slpm_in_pu, "ske"), /* I5 */
+	DB8500_PIN("GPIO156_C17", in_pd_slpm_in_pu, "ske"), /* I4 */
+	DB8500_PIN("GPIO161_D21", in_pd_slpm_in_pu, "ske"), /* I3 */
+	DB8500_PIN("GPIO162_D20", in_pd_slpm_in_pu, "ske"), /* I2 */
+	DB8500_PIN("GPIO163_C20", in_pd_slpm_in_pu, "ske"), /* I1 */
+	DB8500_PIN("GPIO164_B21", in_pd_slpm_in_pu, "ske"), /* I0 */
+	DB8500_PIN("GPIO157_A18", in_pu_slpm_out_lo, "ske"), /* O7 */
+	DB8500_PIN("GPIO158_C18", in_pu_slpm_out_lo, "ske"), /* O6 */
+	DB8500_PIN("GPIO159_B19", in_pu_slpm_out_lo, "ske"), /* O5 */
+	DB8500_PIN("GPIO160_B20", in_pu_slpm_out_lo, "ske"), /* O4 */
+	DB8500_PIN("GPIO165_C21", in_pu_slpm_out_lo, "ske"), /* O3 */
+	DB8500_PIN("GPIO166_A22", in_pu_slpm_out_lo, "ske"), /* O2 */
+	DB8500_PIN("GPIO167_B24", in_pu_slpm_out_lo, "ske"), /* O1 */
+	DB8500_PIN("GPIO168_C22", in_pu_slpm_out_lo, "ske"), /* O0 */
 };
 
-static pin_cfg_t u9500_pins[] = {
-	GPIO4_U1_RXD    | PIN_INPUT_PULLUP,
-	GPIO5_U1_TXD    | PIN_OUTPUT_HIGH,
-	GPIO144_GPIO	| PIN_INPUT_PULLUP,/* WLAN_IRQ */
-
+static struct pinctrl_map __initdata u9500_pinmap[] = {
+	/* Mux in UART1 (just RX/TX) and set the pull-ups */
+	DB8500_MUX_HOG("u1rxtx_a_1", "u1"),
+	DB8500_PIN_HOG("GPIO4_AH6", in_pu),
+	DB8500_PIN_HOG("GPIO5_AG6", out_hi),
+	/* WLAN_IRQ line */
+	DB8500_PIN_HOG("GPIO144_B13", gpio_in_pu),
 	/* HSI */
-	GPIO219_HSIR_FLA0 | PIN_INPUT_PULLDOWN,
-	GPIO220_HSIR_DAT0 | PIN_INPUT_PULLDOWN,
-	GPIO221_HSIR_RDY0 | PIN_OUTPUT_LOW,
-	GPIO222_HSIT_FLA0 | PIN_OUTPUT_LOW,
-	GPIO223_HSIT_DAT0 | PIN_OUTPUT_LOW,
-	GPIO224_HSIT_RDY0 | PIN_INPUT_PULLDOWN,
-	GPIO225_HSIT_CAWAKE0 | PIN_INPUT_PULLDOWN, /* CA_WAKE0 */
-	GPIO226_GPIO	| PIN_OUTPUT_HIGH, /* AC_WAKE0 */
+	DB8500_MUX_HOG("hsir_a_1", "hsi"),
+	DB8500_MUX_HOG("hsit_a_1", "hsi"),
+	DB8500_PIN_HOG("GPIO219_AG10", in_pd), /* RX FLA0 */
+	DB8500_PIN_HOG("GPIO220_AH10", in_pd), /* RX DAT0 */
+	DB8500_PIN_HOG("GPIO221_AJ11", out_lo), /* RX RDY0 */
+	DB8500_PIN_HOG("GPIO222_AJ9", out_lo), /* TX FLA0 */
+	DB8500_PIN_HOG("GPIO223_AH9", out_lo), /* TX DAT0 */
+	DB8500_PIN_HOG("GPIO224_AG9", in_pd), /* TX RDY0 */
+	DB8500_PIN_HOG("GPIO225_AG8", in_pd), /* CAWAKE0 */
+	DB8500_PIN_HOG("GPIO226_AF8", out_hi), /* ACWAKE0 */
 };
 
-static pin_cfg_t u8500_pins[] = {
-	GPIO226_GPIO	| PIN_OUTPUT_LOW, /* WLAN_PMU_EN */
-	GPIO4_GPIO		| PIN_INPUT_PULLUP,/* WLAN_IRQ */
+static struct pinctrl_map __initdata u8500_pinmap[] = {
+	DB8500_PIN_HOG("GPIO226_AF8", gpio_out_lo), /* WLAN_PMU_EN */
+	DB8500_PIN_HOG("GPIO4_AH6", gpio_in_pu), /* WLAN_IRQ */
 };
 
-static pin_cfg_t snowball_pins[] = {
-	/* SSP0, to AB8500 */
-	GPIO143_SSP0_CLK,
-	GPIO144_SSP0_FRM,
-	GPIO145_SSP0_RXD	| PIN_PULL_DOWN,
-	GPIO146_SSP0_TXD,
-
-	/* MMC0: MicroSD card */
-	GPIO21_MC0_DAT31DIR     | PIN_OUTPUT_HIGH,
-
-	/* MMC2: LAN */
-	GPIO86_SM_ADQ0,
-	GPIO87_SM_ADQ1,
-	GPIO88_SM_ADQ2,
-	GPIO89_SM_ADQ3,
-	GPIO90_SM_ADQ4,
-	GPIO91_SM_ADQ5,
-	GPIO92_SM_ADQ6,
-	GPIO93_SM_ADQ7,
-
-	GPIO94_SM_ADVn,
-	GPIO95_SM_CS0n,
-	GPIO96_SM_OEn,
-	GPIO97_SM_WEn,
-
-	GPIO128_SM_CKO,
-	GPIO130_SM_FBCLK,
-	GPIO131_SM_ADQ8,
-	GPIO132_SM_ADQ9,
-	GPIO133_SM_ADQ10,
-	GPIO134_SM_ADQ11,
-	GPIO135_SM_ADQ12,
-	GPIO136_SM_ADQ13,
-	GPIO137_SM_ADQ14,
-	GPIO138_SM_ADQ15,
-
-	/* RSTn_LAN */
-	GPIO141_GPIO		| PIN_OUTPUT_HIGH,
-
+static struct pinctrl_map __initdata snowball_pinmap[] = {
+	/* Mux in SSP0 connected to AB8500, pull down RXD pin */
+	DB8500_MUX_HOG("ssp0_a_1", "ssp0"),
+	DB8500_PIN_HOG("GPIO145_C13", pd),
+	/* Always drive the MC0 DAT31DIR line high on these boards */
+	DB8500_PIN_HOG("GPIO21_AB3", out_hi),
+	/* Mux in "SM" which is used for the SMSC911x Ethernet adapter */
+	DB8500_MUX_HOG("sm_b_1", "sm"),
+	/* Drive RSTn_LAN high */
+	DB8500_PIN_HOG("GPIO141_C12", gpio_out_hi),
 	/*  Accelerometer/Magnetometer */
-	GPIO163_GPIO		| PIN_INPUT_PULLUP, /* ACCEL_IRQ1 */
-	GPIO164_GPIO		| PIN_INPUT_PULLUP, /* ACCEL_IRQ2 */
-	GPIO165_GPIO		| PIN_INPUT_PULLUP, /* MAG_DRDY */
-
+	DB8500_PIN_HOG("GPIO163_C20", gpio_in_pu), /* ACCEL_IRQ1 */
+	DB8500_PIN_HOG("GPIO164_B21", gpio_in_pu), /* ACCEL_IRQ2 */
+	DB8500_PIN_HOG("GPIO165_C21", gpio_in_pu), /* MAG_DRDY */
 	/* WLAN/GBF */
-	GPIO161_GPIO		| PIN_OUTPUT_LOW, /* WLAN_PMU_EN */
-	GPIO171_GPIO		| PIN_OUTPUT_HIGH,/* GBF_ENA */
-	GPIO215_GPIO		| PIN_OUTPUT_LOW,/* WLAN_ENA */
-	GPIO216_GPIO		| PIN_INPUT_PULLUP,/* WLAN_IRQ */
-};
-
-/*
- * I2C
- */
-
-static UX500_PINS(mop500_pins_i2c0,
-	GPIO147_I2C0_SCL |
-		PIN_SLPM_GPIO | PIN_SLPM_INPUT_NOPULL,
-	GPIO148_I2C0_SDA |
-		PIN_SLPM_GPIO | PIN_SLPM_INPUT_NOPULL,
-);
-
-static UX500_PINS(mop500_pins_i2c1,
-	GPIO16_I2C1_SCL |
-		PIN_SLPM_GPIO | PIN_SLPM_INPUT_NOPULL,
-	GPIO17_I2C1_SDA |
-		PIN_SLPM_GPIO | PIN_SLPM_INPUT_NOPULL,
-);
-
-static UX500_PINS(mop500_pins_i2c2,
-	GPIO10_I2C2_SDA |
-		PIN_SLPM_GPIO | PIN_SLPM_INPUT_NOPULL,
-	GPIO11_I2C2_SCL |
-		PIN_SLPM_GPIO | PIN_SLPM_INPUT_NOPULL,
-);
-
-static UX500_PINS(mop500_pins_i2c3,
-	GPIO229_I2C3_SDA |
-		PIN_SLPM_GPIO | PIN_SLPM_INPUT_NOPULL,
-	GPIO230_I2C3_SCL |
-		PIN_SLPM_GPIO | PIN_SLPM_INPUT_NOPULL,
-);
-
-static UX500_PINS(mop500_pins_mcde_tvout,
-	GPIO78_LCD_D8,
-	GPIO79_LCD_D9,
-	GPIO80_LCD_D10,
-	GPIO81_LCD_D11,
-	GPIO150_LCDA_CLK,
-);
-
-static UX500_PINS(mop500_pins_mcde_hdmi,
-	GPIO69_LCD_VSI1	| PIN_INPUT_PULLUP,
-);
-
-static UX500_PINS(mop500_pins_ske,
-	GPIO153_KP_I7 | PIN_INPUT_PULLDOWN | PIN_SLPM_INPUT_PULLUP,
-	GPIO154_KP_I6 | PIN_INPUT_PULLDOWN | PIN_SLPM_INPUT_PULLUP,
-	GPIO155_KP_I5 | PIN_INPUT_PULLDOWN | PIN_SLPM_INPUT_PULLUP,
-	GPIO156_KP_I4 | PIN_INPUT_PULLDOWN | PIN_SLPM_INPUT_PULLUP,
-	GPIO161_KP_I3 | PIN_INPUT_PULLDOWN | PIN_SLPM_INPUT_PULLUP,
-	GPIO162_KP_I2 | PIN_INPUT_PULLDOWN | PIN_SLPM_INPUT_PULLUP,
-	GPIO163_KP_I1 | PIN_INPUT_PULLDOWN | PIN_SLPM_INPUT_PULLUP,
-	GPIO164_KP_I0 | PIN_INPUT_PULLDOWN | PIN_SLPM_INPUT_PULLUP,
-	GPIO157_KP_O7 | PIN_INPUT_PULLUP | PIN_SLPM_OUTPUT_LOW,
-	GPIO158_KP_O6 | PIN_INPUT_PULLUP | PIN_SLPM_OUTPUT_LOW,
-	GPIO159_KP_O5 | PIN_INPUT_PULLUP | PIN_SLPM_OUTPUT_LOW,
-	GPIO160_KP_O4 | PIN_INPUT_PULLUP | PIN_SLPM_OUTPUT_LOW,
-	GPIO165_KP_O3 | PIN_INPUT_PULLUP | PIN_SLPM_OUTPUT_LOW,
-	GPIO166_KP_O2 | PIN_INPUT_PULLUP | PIN_SLPM_OUTPUT_LOW,
-	GPIO167_KP_O1 | PIN_INPUT_PULLUP | PIN_SLPM_OUTPUT_LOW,
-	GPIO168_KP_O0 | PIN_INPUT_PULLUP | PIN_SLPM_OUTPUT_LOW,
-);
-
-/* sdi0 (removable MMC/SD/SDIO cards) */
-static UX500_PINS(mop500_pins_sdi0,
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
-);
-
-/* sdi1 (WLAN CW1200) */
-static UX500_PINS(mop500_pins_sdi1,
-	GPIO208_MC1_CLK		| PIN_OUTPUT_LOW,
-	GPIO209_MC1_FBCLK	| PIN_INPUT_NOPULL,
-	GPIO210_MC1_CMD		| PIN_INPUT_PULLUP,
-	GPIO211_MC1_DAT0	| PIN_INPUT_PULLUP,
-	GPIO212_MC1_DAT1	| PIN_INPUT_PULLUP,
-	GPIO213_MC1_DAT2	| PIN_INPUT_PULLUP,
-	GPIO214_MC1_DAT3	| PIN_INPUT_PULLUP,
-);
-
-/* sdi2 (POP eMMC) */
-static UX500_PINS(mop500_pins_sdi2,
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
-);
-
-/* sdi4 (PCB eMMC) */
-static UX500_PINS(mop500_pins_sdi4,
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
-);
-
-/* USB */
-static UX500_PINS(mop500_pins_usb,
-	GPIO256_USB_NXT,
-	GPIO257_USB_STP		| PIN_OUTPUT_HIGH,
-	GPIO258_USB_XCLK,
-	GPIO259_USB_DIR,
-	GPIO260_USB_DAT7,
-	GPIO261_USB_DAT6,
-	GPIO262_USB_DAT5,
-	GPIO263_USB_DAT4,
-	GPIO264_USB_DAT3,
-	GPIO265_USB_DAT2,
-	GPIO266_USB_DAT1,
-	GPIO267_USB_DAT0,
-);
-
-/* SPI2 */
-static UX500_PINS(mop500_pins_spi2,
-	GPIO216_GPIO    | PIN_OUTPUT_HIGH,
-	GPIO218_SPI2_RXD        | PIN_INPUT_PULLDOWN,
-	GPIO215_SPI2_TXD        | PIN_OUTPUT_LOW,
-	GPIO217_SPI2_CLK        | PIN_OUTPUT_LOW,
-);
-
-static UX500_PINS(mop500_pins_sensors1p_v60,
-	GPIO217_GPIO| PIN_INPUT_PULLUP |
-		  PIN_SLPM_GPIO | PIN_SLPM_INPUT_NOPULL,
-	GPIO145_GPIO | PIN_INPUT_PULLDOWN |
-		  PIN_SLPM_GPIO | PIN_SLPM_INPUT_NOPULL,
-	GPIO139_GPIO | PIN_INPUT_PULLUP |
-		  PIN_SLPM_GPIO | PIN_SLPM_INPUT_NOPULL,
-);
-
-static UX500_PINS(mop500_pins_sensors1p,
-	PIN_CFG_INPUT(GPIO_PROX_SENSOR, GPIO, NOPULL),
-	PIN_CFG_INPUT(GPIO_HAL_SENSOR, GPIO, NOPULL),
-);
-
-static struct ux500_pin_lookup mop500_runtime_pins[] = {
-	PIN_LOOKUP("mcde-tvout", &mop500_pins_mcde_tvout),
-	PIN_LOOKUP("av8100-hdmi", &mop500_pins_mcde_hdmi),
-	PIN_LOOKUP("nmk-i2c.0", &mop500_pins_i2c0),
-	PIN_LOOKUP("nmk-i2c.1", &mop500_pins_i2c1),
-	PIN_LOOKUP("nmk-i2c.2", &mop500_pins_i2c2),
-	PIN_LOOKUP("nmk-i2c.3", &mop500_pins_i2c3),
-	PIN_LOOKUP("sdi0", &mop500_pins_sdi0),
-	PIN_LOOKUP("sdi1", &mop500_pins_sdi1),
-	PIN_LOOKUP("sdi2", &mop500_pins_sdi2),
-	PIN_LOOKUP("sdi4", &mop500_pins_sdi4),
-	PIN_LOOKUP("musb-ux500.0", &mop500_pins_usb),
-	PIN_LOOKUP("spi2", &mop500_pins_spi2),
-};
-
-static struct ux500_pin_lookup mop500_runtime_pins_v60[] = {
-	PIN_LOOKUP("ske", &mop500_pins_ske),
-	PIN_LOOKUP("gpio-keys.0", &mop500_pins_sensors1p_v60),
-};
-
-static struct ux500_pin_lookup mop500_runtime_pins_pre_v60[] = {
-	PIN_LOOKUP("ske", &mop500_pins_ske),
-	PIN_LOOKUP("gpio-keys.0", &mop500_pins_sensors1p),
+	DB8500_PIN_HOG("GPIO161_D21", gpio_out_lo), /* WLAN_PMU_EN */
+	DB8500_PIN_HOG("GPIO171_D23", gpio_out_hi), /* GBF_ENA */
+	DB8500_PIN_HOG("GPIO215_AH13", gpio_out_lo), /* WLAN_ENA */
+	DB8500_PIN_HOG("GPIO216_AG12", gpio_in_pu), /* WLAN_IRQ */
 };
 
 /*
@@ -444,64 +436,45 @@ int pins_for_u9500(void)
 	return 0;
 }
 
-void __init mop500_pins_init(void)
+static void __init mop500_href_family_pinmaps_init(void)
 {
-	nmk_config_pins(mop500_pins_common,
-			ARRAY_SIZE(mop500_pins_common));
-
-	ux500_pins_add(mop500_runtime_pins, ARRAY_SIZE(mop500_runtime_pins));
-
-	ux500_pins_add(mop500_runtime_pins_pre_v60,
-		       ARRAY_SIZE(mop500_runtime_pins_pre_v60));
-
 	switch (pinsfor) {
 	case PINS_FOR_U9500:
-		nmk_config_pins(u9500_pins, ARRAY_SIZE(u9500_pins));
+		pinctrl_register_mappings(u9500_pinmap,
+					  ARRAY_SIZE(u9500_pinmap));
 		break;
-
 	case PINS_FOR_DEFAULT:
-		nmk_config_pins(u8500_pins, ARRAY_SIZE(u8500_pins));
+		pinctrl_register_mappings(u8500_pinmap,
+					  ARRAY_SIZE(u8500_pinmap));
 	default:
 		break;
 	}
-
-	nmk_config_pins(mop500_pins_default,
-			ARRAY_SIZE(mop500_pins_default));
 }
 
-void __init snowball_pins_init(void)
+void __init mop500_pinmaps_init(void)
 {
-	nmk_config_pins(mop500_pins_common,
-			ARRAY_SIZE(mop500_pins_common));
-
-	ux500_pins_add(mop500_runtime_pins, ARRAY_SIZE(mop500_runtime_pins));
-
-	nmk_config_pins(u8500_pins, ARRAY_SIZE(u8500_pins));
-
-	nmk_config_pins(snowball_pins, ARRAY_SIZE(snowball_pins));
+	pinctrl_register_mappings(mop500_family_pinmap,
+				  ARRAY_SIZE(mop500_family_pinmap));
+	pinctrl_register_mappings(mop500_pinmap,
+				  ARRAY_SIZE(mop500_pinmap));
+	mop500_href_family_pinmaps_init();
 }
 
-void __init hrefv60_pins_init(void)
+void __init snowball_pinmaps_init(void)
 {
-	nmk_config_pins(mop500_pins_common,
-			ARRAY_SIZE(mop500_pins_common));
-
-	ux500_pins_add(mop500_runtime_pins, ARRAY_SIZE(mop500_runtime_pins));
-
-	ux500_pins_add(mop500_runtime_pins_v60,
-		       ARRAY_SIZE(mop500_runtime_pins_v60));
-
-	nmk_config_pins(hrefv60_pins,
-			ARRAY_SIZE(hrefv60_pins));
-
-	switch (pinsfor) {
-	case PINS_FOR_U9500:
-		nmk_config_pins(u9500_pins, ARRAY_SIZE(u9500_pins));
-		break;
+	pinctrl_register_mappings(mop500_family_pinmap,
+				  ARRAY_SIZE(mop500_family_pinmap));
+	pinctrl_register_mappings(snowball_pinmap,
+				  ARRAY_SIZE(snowball_pinmap));
+	pinctrl_register_mappings(u8500_pinmap,
+				  ARRAY_SIZE(u8500_pinmap));
+}
 
-	case PINS_FOR_DEFAULT:
-		nmk_config_pins(u8500_pins, ARRAY_SIZE(u8500_pins));
-	default:
-		break;
-	}
+void __init hrefv60_pinmaps_init(void)
+{
+	pinctrl_register_mappings(mop500_family_pinmap,
+				  ARRAY_SIZE(mop500_family_pinmap));
+	pinctrl_register_mappings(hrefv60_pinmap,
+				  ARRAY_SIZE(hrefv60_pinmap));
+	mop500_href_family_pinmaps_init();
 }
diff --git a/arch/arm/mach-ux500/board-mop500.c b/arch/arm/mach-ux500/board-mop500.c
index ca0d625..e5c0e6e 100644
--- a/arch/arm/mach-ux500/board-mop500.c
+++ b/arch/arm/mach-ux500/board-mop500.c
@@ -1,3 +1,4 @@
+
 /*
  * Copyright (C) 2008-2009 ST-Ericsson
  *
@@ -618,10 +619,9 @@ static void __init mop500_init_machine(void)
 
 	mop500_gpio_keys[0].gpio = GPIO_PROX_SENSOR;
 
+	mop500_pinmaps_init();
 	parent = u8500_init_devices();
 
-	mop500_pins_init();
-
 	/* FIXME: parent of ab8500 should be prcmu */
 	for (i = 0; i < ARRAY_SIZE(mop500_platform_devs); i++)
 		mop500_platform_devs[i]->dev.parent = parent;
@@ -651,10 +651,9 @@ static void __init snowball_init_machine(void)
 	int i2c0_devs;
 	int i;
 
+	snowball_pinmaps_init();
 	parent = u8500_init_devices();
 
-	snowball_pins_init();
-
 	for (i = 0; i < ARRAY_SIZE(snowball_platform_devs); i++)
 		snowball_platform_devs[i]->dev.parent = parent;
 
@@ -689,10 +688,9 @@ static void __init hrefv60_init_machine(void)
 	 */
 	mop500_gpio_keys[0].gpio = HREFV60_PROX_SENSE_GPIO;
 
+	hrefv60_pinmaps_init();
 	parent = u8500_init_devices();
 
-	hrefv60_pins_init();
-
 	for (i = 0; i < ARRAY_SIZE(mop500_platform_devs); i++)
 		mop500_platform_devs[i]->dev.parent = parent;
 
@@ -781,6 +779,14 @@ static void __init u8500_init_machine(void)
 	int i2c0_devs;
 	int i;
 
+	/* Pinmaps must be in place before devices register */
+	if (of_machine_is_compatible("st-ericsson,mop500"))
+		mop500_pinmaps_init();
+	else if (of_machine_is_compatible("calaosystems,snowball-a9500"))
+		snowball_pinmaps_init();
+	else if (of_machine_is_compatible("st-ericsson,hrefv60+"))
+		hrefv60_pinmaps_init();
+
 	parent = u8500_init_devices();
 	i2c0_devs = ARRAY_SIZE(mop500_i2c0_devices);
 
@@ -794,14 +800,12 @@ static void __init u8500_init_machine(void)
 
 	if (of_machine_is_compatible("st-ericsson,mop500")) {
 		mop500_gpio_keys[0].gpio = GPIO_PROX_SENSOR;
-		mop500_pins_init();
 
 		platform_add_devices(mop500_platform_devs,
 				ARRAY_SIZE(mop500_platform_devs));
 
 		mop500_sdi_init(parent);
 	} else if (of_machine_is_compatible("calaosystems,snowball-a9500")) {
-		snowball_pins_init();
 		platform_add_devices(snowball_platform_devs,
 				ARRAY_SIZE(snowball_platform_devs));
 
@@ -814,7 +818,6 @@ static void __init u8500_init_machine(void)
 		 */
 		mop500_gpio_keys[0].gpio = HREFV60_PROX_SENSE_GPIO;
 		i2c0_devs -= NUM_PRE_V60_I2C0_DEVICES;
-		hrefv60_pins_init();
 		platform_add_devices(mop500_platform_devs,
 				ARRAY_SIZE(mop500_platform_devs));
 
diff --git a/arch/arm/mach-ux500/board-mop500.h b/arch/arm/mach-ux500/board-mop500.h
index 91dc63f..bc44c07 100644
--- a/arch/arm/mach-ux500/board-mop500.h
+++ b/arch/arm/mach-ux500/board-mop500.h
@@ -85,9 +85,9 @@ extern void hrefv60_sdi_init(struct device *parent);
 extern void mop500_sdi_tc35892_init(struct device *parent);
 void __init mop500_u8500uib_init(void);
 void __init mop500_stuib_init(void);
-void __init mop500_pins_init(void);
-void __init hrefv60_pins_init(void);
-void __init snowball_pins_init(void);
+void __init mop500_pinmaps_init(void);
+void __init snowball_pinmaps_init(void);
+void __init hrefv60_pinmaps_init(void);
 
 void mop500_uib_i2c_add(int busnum, struct i2c_board_info *info,
 		unsigned n);
-- 
1.7.9.2

