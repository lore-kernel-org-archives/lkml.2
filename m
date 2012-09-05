Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758616Ab2IEKAA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 06:00:00 -0400
Received: from eu1sys200aog103.obsmtp.com ([207.126.144.115]:32923 "EHLO
	eu1sys200aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753591Ab2IEJ7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 05:59:46 -0400
From: Loic Pallardy <loic.pallardy-ext@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Linus Walleij <linus.walleij@linaro.com>
Cc: Lee Jones <lee.jones@linaro.org>, Loic Pallardy <loic.pallardy@gmail.com>,
        LT ST-Ericsson <st-ericsson@lists.linaro.org>,
        STEricsson_nomadik_linux <STEricsson_nomadik_linux@list.st.com>,
        Loic Pallardy <loic.pallardy-ext@stericsson.com>,
        Loic Pallardy <loic.pallardy@stericsson.com>
Subject: [PATCH 01/17] arm: ux500: add u9540 pin configuration
Date: Wed, 5 Sep 2012 11:58:57 +0200
Message-ID: <1346839153-6465-2-git-send-email-loic.pallardy-ext@stericsson.com>
X-Mailer: git-send-email 1.7.11.1
In-Reply-To: <1346839153-6465-1-git-send-email-loic.pallardy-ext@stericsson.com>
References: <1346839153-6465-1-git-send-email-loic.pallardy-ext@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add dedicated pin configuration for u9540 platform

Signed-off-by: Loic Pallardy <loic.pallardy@stericsson.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
---
 arch/arm/mach-ux500/board-mop500-pins.c | 200 ++++++++++++++++++++++++++++++++
 arch/arm/mach-ux500/board-mop500.h      |   1 +
 2 files changed, 201 insertions(+)

diff --git a/arch/arm/mach-ux500/board-mop500-pins.c b/arch/arm/mach-ux500/board-mop500-pins.c
index 32fd992..cc0949d 100644
--- a/arch/arm/mach-ux500/board-mop500-pins.c
+++ b/arch/arm/mach-ux500/board-mop500-pins.c
@@ -40,11 +40,15 @@ BIAS(in_pu_slpm_out_lo, PIN_INPUT_PULLUP|PIN_SLPM_OUTPUT_LOW);
 BIAS(out_hi, PIN_OUTPUT_HIGH);
 BIAS(out_lo, PIN_OUTPUT_LOW);
 BIAS(out_lo_sleep_nowkup, PIN_OUTPUT_LOW|PIN_SLPM_WAKEUP_DISABLE);
+BIAS(in_pu_slpm_in_pu, PIN_INPUT_PULLUP|PIN_SLPM_INPUT_PULLUP);
+BIAS(out_lo_slpm_out_lo, PIN_OUTPUT_LOW|PIN_SLPM_OUTPUT_LOW);
 /* These also force them into GPIO mode */
 BIAS(gpio_in_pu, PIN_INPUT_PULLUP|PIN_GPIOMODE_ENABLED);
 BIAS(gpio_in_pd, PIN_INPUT_PULLDOWN|PIN_GPIOMODE_ENABLED);
+BIAS(gpio_in_nopull, PIN_INPUT_NOPULL|PIN_GPIOMODE_ENABLED);
 BIAS(gpio_in_pu_slpm_gpio_nopull, PIN_INPUT_PULLUP|PIN_GPIOMODE_ENABLED|PIN_SLPM_GPIO|PIN_SLPM_INPUT_NOPULL);
 BIAS(gpio_in_pd_slpm_gpio_nopull, PIN_INPUT_PULLDOWN|PIN_GPIOMODE_ENABLED|PIN_SLPM_GPIO|PIN_SLPM_INPUT_NOPULL);
+BIAS(gpio_in_nopull_slpm_gpio_nopull, PIN_INPUT_NOPULL|PIN_GPIOMODE_ENABLED|PIN_SLPM_GPIO|PIN_SLPM_INPUT_NOPULL);
 BIAS(gpio_out_hi, PIN_OUTPUT_HIGH|PIN_GPIOMODE_ENABLED);
 BIAS(gpio_out_lo, PIN_OUTPUT_LOW|PIN_GPIOMODE_ENABLED);
 /* Sleep modes */
@@ -447,6 +451,192 @@ static struct pinctrl_map __initdata snowball_pinmap[] = {
 	DB8500_PIN_HOG("GPIO216_AG12", gpio_in_pu), /* WLAN_IRQ */
 };
 
+/* Pin control settings */
+static struct pinctrl_map __initdata ccu9540_common_pinmap[] = {
+	/*
+	 * uMSP0, mux in 4 pins, regular placement of RX/TX
+	 * explicitly set the pins to no pull
+	 */
+	DB8500_MUX_HOG("msp0txrx_a_1", "msp0"),
+	DB8500_MUX_HOG("msp0tfstck_a_1", "msp0"),
+	DB8500_PIN_HOG("GPIO12_AC4", in_nopull), /* TXD */
+	DB8500_PIN_HOG("GPIO13_AF3", in_nopull), /* TFS */
+	DB8500_PIN_HOG("GPIO14_AE3", in_nopull), /* TCK */
+	DB8500_PIN_HOG("GPIO15_AC3", in_nopull), /* RXD */
+
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
+	/*
+	 * UART0, we do not mux in u0 here.
+	 * uart-0 pins gpio configuration should be kept intact to prevent
+	 * a glitch in tx line when the tty dev is opened. Later these pins
+	 * are configured to uart mop500_pins_uart0
+	*/
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
+};
+
+static struct pinctrl_map __initdata ccu9540_pinmap[] = {
+	/* MSP : HDTV INTERFACE */
+	DB8500_PIN_HOG("GPIO192_AJ27", gpio_in_pd),
+
+	/* ACCELEROMETER_INTERFACE */
+	DB8500_PIN_HOG("GPIO82_C1", gpio_in_pu), /* ACC_INT1 */
+	DB8500_PIN_HOG("GPIO83_D3", gpio_in_pu), /* ACC_INT2 */
+
+	/* PM2301 interrupt dedicated GPIO */
+	DB8500_PIN_HOG("GPIO171_D23", gpio_in_pu),
+
+	DB8500_MUX_HOG("u1rxtx_a_1", "u1"),
+	DB8500_PIN_HOG("GPIO4_AH6", in_pu), /* RXD */
+	DB8500_PIN_HOG("GPIO5_AG6", out_hi), /*TXD */
+
+	DB8500_PIN_HOG("GPIO6_AF6", gpio_in_nopull), /* LAN PME */
+	DB8500_PIN_HOG("GPIO7_AG5", gpio_in_nopull), /* LAN IRQ */
+
+	/* Display Interface */
+	DB8500_PIN_HOG("GPIO143_D12", gpio_out_hi), /* DISP1 NO RST */
+
+	/* Touch screen INTERFACE */
+	DB8500_PIN_HOG("GPIO145_C13", gpio_out_lo), /* TOUCH_RST1 */
+	DB8500_PIN_HOG("GPIO146_D13", gpio_in_pu), /* TOUCH_INT1 */
+
+	/* LAN SMSC9221i */
+	DB8500_MUX_HOG("sm_b_1", "sm"),
+	DB8500_PIN_HOG("GPIO86_C6", out_lo),
+	DB8500_PIN_HOG("GPIO87_B3", out_lo),
+	DB8500_PIN_HOG("GPIO88_C4", out_lo),
+	DB8500_PIN_HOG("GPIO89_E6", out_lo),
+	DB8500_PIN_HOG("GPIO90_A3", out_lo),
+	DB8500_PIN_HOG("GPIO91_B6", out_lo),
+	DB8500_PIN_HOG("GPIO92_D6", out_lo),
+	DB8500_PIN_HOG("GPIO93_B7", out_lo),
+	DB8500_PIN_HOG("GPIO94_D7", out_lo),
+	DB8500_PIN_HOG("GPIO96_D8", out_hi),
+	DB8500_PIN_HOG("GPIO97_D9", out_hi),
+	DB8500_PIN_HOG("GPIO128_A5", out_lo),
+	DB8500_PIN_HOG("GPIO129_B4", out_lo),
+	DB8500_PIN_HOG("GPIO130_C8", out_lo),
+	DB8500_PIN_HOG("GPIO131_A12", out_lo),
+	DB8500_PIN_HOG("GPIO132_C10", out_lo),
+	DB8500_PIN_HOG("GPIO133_B10", out_lo),
+	DB8500_PIN_HOG("GPIO134_B9", out_lo),
+	DB8500_PIN_HOG("GPIO135_A9", out_lo),
+	DB8500_PIN_HOG("GPIO136_C7", out_lo),
+	DB8500_PIN_HOG("GPIO137_A7", out_lo),
+	DB8500_PIN_HOG("GPIO138_C5", out_lo),
+	DB8500_PIN_HOG("GPIO139_C9", out_lo),
+	DB8500_MUX_HOG("smcs0_b_1", "sm"),
+	DB8500_PIN_HOG("GPIO95_E8", out_hi),
+
+	/* RESOUT */
+	DB8500_PIN_HOG("GPIO84_C2", gpio_in_nopull), /* RESOUT0 */
+	DB8500_PIN_HOG("GPIO85_D5", gpio_in_nopull), /* RESOUT2 */
+
+	/* SD card detect */
+	DB8500_PIN_HOG("GPIO230_AF7", gpio_in_pu),
+
+	/*
+	 * The following pin sets were known as "runtime pins" before being
+	 * converted to the pinctrl model. Here we model them as "default"
+	 * states.
+	 */
+	/* Mux in I2C blocks, put pins into GPIO in sleepmode no pull-up */
+	DB8500_MUX("i2c0_a_1", "i2c0", "nmk-i2c.0"),
+	DB8500_PIN("GPIO147_C15", slpm_gpio_nopull, "nmk-i2c.0"),
+	DB8500_PIN("GPIO148_B16", slpm_gpio_nopull, "nmk-i2c.0"),
+
+	/* Mux in I2C1 blocks, put pins into GPIO in sleepmode no pull-up */
+	DB8500_MUX("i2c1_b_2", "i2c1", "nmk-i2c.1"),
+	DB8500_PIN("GPIO16_AD3", slpm_gpio_nopull, "nmk-i2c.1"),
+	DB8500_PIN("GPIO17_AD4", slpm_gpio_nopull, "nmk-i2c.1"),
+
+	/* Mux in I2C2 blocks, put pins into GPIO in sleepmode no pull-up */
+	DB8500_MUX("i2c2_b_2", "i2c2", "nmk-i2c.2"),
+	DB8500_PIN("GPIO10_AF5", slpm_gpio_nopull, "nmk-i2c.2"),
+	DB8500_PIN("GPIO11_AG4", slpm_gpio_nopull, "nmk-i2c.2"),
+
+	/* Mux in LCD VSI1 and pull it up for MCDE HDMI output */
+	DB8500_MUX("lcdvsi1_a_1", "lcd", "0-0070"),
+	DB8500_PIN("GPIO69_E2", in_pu, "0-0070"),
+
+	DB8500_MUX("kp_b_1", "kp", "nmk-ske-keypad"),
+	DB8500_PIN("GPIO79_E3", in_pu_slpm_in_pu, "nmk-ske-keypad"), /* I6 */
+	DB8500_PIN("GPIO66_G3", in_pu_slpm_in_pu, "nmk-ske-keypad"), /* I1 */
+	DB8500_PIN("GPIO67_G2", in_pu_slpm_in_pu, "nmk-ske-keypad"), /* I0 */
+	DB8500_PIN("GPIO78_F4", out_lo_slpm_out_lo, "nmk-ske-keypad"), /* O6 */
+	DB8500_PIN("GPIO64_F3", out_lo_slpm_out_lo, "nmk-ske-keypad"), /* O1 */
+	DB8500_PIN("GPIO65_F1", out_lo_slpm_out_lo, "nmk-ske-keypad"), /* O0 */
+
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
+
+	/* Mux in SDI1 (here called MC1) used for SDIO for CW1200 WLAN */
+	DB8500_MUX("mc1_a_1", "mc1", "sdi1"),
+	DB8500_PIN("GPIO208_AH16", out_lo, "sdi1"), /* CLK */
+	DB8500_PIN("GPIO209_AG15", in_nopull, "sdi1"), /* FBCLK */
+	DB8500_PIN("GPIO210_AJ15", in_pu, "sdi1"), /* CMD */
+	DB8500_PIN("GPIO211_AG14", in_pu, "sdi1"), /* DAT0 */
+	DB8500_PIN("GPIO212_AF13", in_pu, "sdi1"), /* DAT1 */
+	DB8500_PIN("GPIO213_AG13", in_pu, "sdi1"), /* DAT2 */
+	DB8500_PIN("GPIO214_AH15", in_pu, "sdi1"), /* DAT3 */
+
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
+
+	/* Mux in USB pins, drive STP high */
+	DB8500_MUX("usb_a_1", "usb", "musb-ux500.0"),
+	DB8500_PIN("GPIO257_AE29", out_hi, "musb-ux500.0"), /* STP */
+
+	/* Sensor1p */
+	DB8500_PIN("GPIO229_AG7", gpio_in_nopull_slpm_gpio_nopull, "gpio-keys.0"),
+};
+
 /*
  * passing "pinsfor=" in kernel cmdline allows for custom
  * configuration of GPIOs on u8500 derived boards.
@@ -512,3 +702,13 @@ void __init hrefv60_pinmaps_init(void)
 				  ARRAY_SIZE(hrefv60_pinmap));
 	mop500_href_family_pinmaps_init();
 }
+
+void __init ccu9540_pins_init(void)
+{
+
+	pinctrl_register_mappings(ccu9540_common_pinmap,
+				  ARRAY_SIZE(ccu9540_common_pinmap));
+	pinctrl_register_mappings(ccu9540_pinmap,
+				  ARRAY_SIZE(ccu9540_pinmap));
+}
+
diff --git a/arch/arm/mach-ux500/board-mop500.h b/arch/arm/mach-ux500/board-mop500.h
index d04a8e6..b696ab0 100644
--- a/arch/arm/mach-ux500/board-mop500.h
+++ b/arch/arm/mach-ux500/board-mop500.h
@@ -92,6 +92,7 @@ void __init mop500_stuib_init(void);
 void __init mop500_pinmaps_init(void);
 void __init snowball_pinmaps_init(void);
 void __init hrefv60_pinmaps_init(void);
+void __init ccu9540_pins_init(void);
 
 int __init mop500_uib_init(void);
 void mop500_uib_i2c_add(int busnum, struct i2c_board_info *info,
-- 
1.7.11.1

