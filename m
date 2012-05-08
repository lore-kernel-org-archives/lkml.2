Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753072Ab2EHJpw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 05:45:52 -0400
Received: from eu1sys200aog108.obsmtp.com ([207.126.144.125]:39219 "EHLO
	eu1sys200aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752942Ab2EHJpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 05:45:49 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Cc: Stephen Warren <swarren@nvidia.com>, Shawn Guo <shawn.guo@freescale.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 10/12] ARM: ux500: switch to using pinctrl for uart0
Date: Tue, 8 May 2012 11:45:32 +0200
Message-ID: <1336470332-23816-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.9.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

UART0 had a hack that enabled its pins on init and put it to
sleep on the exit callback. Replace this with the pinctrl calls
to do the same thing and update the runtime table with the two
apropriate states for runtime/active and idle.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 arch/arm/mach-ux500/board-mop500-pins.c |   19 ++++++++++
 arch/arm/mach-ux500/board-mop500.c      |   62 ++++++++++++++++++++-----------
 2 files changed, 60 insertions(+), 21 deletions(-)

diff --git a/arch/arm/mach-ux500/board-mop500-pins.c b/arch/arm/mach-ux500/board-mop500-pins.c
index 157af7e..dccd29d 100644
--- a/arch/arm/mach-ux500/board-mop500-pins.c
+++ b/arch/arm/mach-ux500/board-mop500-pins.c
@@ -45,6 +45,10 @@ BIAS(gpio_in_pu_slpm_gpio_nopull, PIN_INPUT_PULLUP|PIN_GPIOMODE_ENABLED|PIN_SLPM
 BIAS(gpio_in_pd_slpm_gpio_nopull, PIN_INPUT_PULLDOWN|PIN_GPIOMODE_ENABLED|PIN_SLPM_GPIO|PIN_SLPM_INPUT_NOPULL);
 BIAS(gpio_out_hi, PIN_OUTPUT_HIGH|PIN_GPIOMODE_ENABLED);
 BIAS(gpio_out_lo, PIN_OUTPUT_LOW|PIN_GPIOMODE_ENABLED);
+/* Sleep modes */
+BIAS(sleep_in_wkup_pdis, PIN_SLPM_DIR_INPUT|PIN_SLPM_WAKEUP_ENABLE|PIN_SLPM_PDIS_DISABLED);
+BIAS(sleep_out_hi_wkup_pdis, PIN_SLPM_OUTPUT_HIGH|PIN_SLPM_WAKEUP_ENABLE|PIN_SLPM_PDIS_DISABLED);
+BIAS(sleep_out_wkup_pdis, PIN_SLPM_DIR_OUTPUT|PIN_SLPM_WAKEUP_ENABLE|PIN_SLPM_PDIS_DISABLED);
 
 /* We use these to define hog settings that are always done on boot */
 #define DB8500_MUX_HOG(group,func) \
@@ -58,6 +62,10 @@ BIAS(gpio_out_lo, PIN_OUTPUT_LOW|PIN_GPIOMODE_ENABLED);
 #define DB8500_PIN(pin,conf,dev) \
 	PIN_MAP_CONFIGS_PIN_DEFAULT(dev, "pinctrl-db8500", pin, conf)
 
+#define DB8500_PIN_SLEEP(pin,conf,dev) \
+	PIN_MAP_CONFIGS_PIN(dev, PINCTRL_STATE_SLEEP, "pinctrl-db8500",	\
+			    pin, conf)
+
 /* Pin control settings */
 static struct pinctrl_map __initdata mop500_family_pinmap[] = {
 	/*
@@ -115,6 +123,17 @@ static struct pinctrl_map __initdata mop500_family_pinmap[] = {
 	 * converted to the pinctrl model. Here we model them as "default"
 	 * states.
 	 */
+	/* Mux in UART0 after initialization */
+	DB8500_MUX("u0_a_1", "u0", "uart0"),
+	DB8500_PIN("GPIO0_AJ5", in_pu, "uart0"), /* CTS */
+	DB8500_PIN("GPIO1_AJ3", out_hi, "uart0"), /* RTS */
+	DB8500_PIN("GPIO2_AH4", in_pu, "uart0"), /* RXD */
+	DB8500_PIN("GPIO3_AH3", out_hi, "uart0"), /* TXD */
+	/* Sleep state for UART0 */
+	DB8500_PIN_SLEEP("GPIO0_AJ5", sleep_in_wkup_pdis, "uart0"),
+	DB8500_PIN_SLEEP("GPIO1_AJ3", sleep_out_hi_wkup_pdis, "uart0"),
+	DB8500_PIN_SLEEP("GPIO2_AH4", sleep_in_wkup_pdis, "uart0"),
+	DB8500_PIN_SLEEP("GPIO3_AH3", sleep_out_wkup_pdis, "uart0"),
 	/* Mux in LCD data lines 8 thru 11 and LCDA CLK for MCDE TVOUT */
 	DB8500_MUX("lcd_d8_d11_a_1", "lcd", "mcde-tvout"),
 	DB8500_MUX("lcdaclk_b_1", "lcda", "mcde-tvout"),
diff --git a/arch/arm/mach-ux500/board-mop500.c b/arch/arm/mach-ux500/board-mop500.c
index e5c0e6e..1dc3165 100644
--- a/arch/arm/mach-ux500/board-mop500.c
+++ b/arch/arm/mach-ux500/board-mop500.c
@@ -30,18 +30,17 @@
 #include <linux/smsc911x.h>
 #include <linux/gpio_keys.h>
 #include <linux/delay.h>
-
 #include <linux/of.h>
 #include <linux/of_platform.h>
-
 #include <linux/leds.h>
+#include <linux/pinctrl/consumer.h>
+
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
 #include <asm/hardware/gic.h>
 
 #include <plat/i2c.h>
 #include <plat/ste_dma40.h>
-#include <plat/pincfg.h>
 #include <plat/gpio-nomadik.h>
 
 #include <mach/hardware.h>
@@ -49,7 +48,6 @@
 #include <mach/devices.h>
 #include <mach/irqs.h>
 
-#include "pins-db8500.h"
 #include "ste-dma40-db8500.h"
 #include "devices-db8500.h"
 #include "board-mop500.h"
@@ -522,14 +520,6 @@ static struct stedma40_chan_cfg uart2_dma_cfg_tx = {
 };
 #endif
 
-
-static pin_cfg_t mop500_pins_uart0[] = {
-	GPIO0_U0_CTSn   | PIN_INPUT_PULLUP,
-	GPIO1_U0_RTSn   | PIN_OUTPUT_HIGH,
-	GPIO2_U0_RXD    | PIN_INPUT_PULLUP,
-	GPIO3_U0_TXD    | PIN_OUTPUT_HIGH,
-};
-
 #define PRCC_K_SOFTRST_SET      0x18
 #define PRCC_K_SOFTRST_CLEAR    0x1C
 static void ux500_uart0_reset(void)
@@ -550,24 +540,33 @@ static void ux500_uart0_reset(void)
 	udelay(1);
 }
 
+/* This needs to be referenced by callbacks */
+struct pinctrl *u0_p;
+struct pinctrl_state *u0_def;
+struct pinctrl_state *u0_sleep;
+
 static void ux500_uart0_init(void)
 {
 	int ret;
 
-	ret = nmk_config_pins(mop500_pins_uart0,
-			ARRAY_SIZE(mop500_pins_uart0));
-	if (ret < 0)
-		pr_err("pl011: uart pins_enable failed\n");
+	if (IS_ERR(u0_p) || IS_ERR(u0_def))
+		return;
+
+	ret = pinctrl_select_state(u0_p, u0_def);
+	if (ret)
+		pr_err("could not set UART0 defstate\n");
 }
 
 static void ux500_uart0_exit(void)
 {
 	int ret;
 
-	ret = nmk_config_pins_sleep(mop500_pins_uart0,
-			ARRAY_SIZE(mop500_pins_uart0));
-	if (ret < 0)
-		pr_err("pl011: uart pins_disable failed\n");
+	if (IS_ERR(u0_p) || IS_ERR(u0_sleep))
+		return;
+
+	ret = pinctrl_select_state(u0_p, u0_sleep);
+	if (ret)
+		pr_err("could not set UART0 idlestate\n");
 }
 
 static struct amba_pl011_data uart0_plat = {
@@ -599,7 +598,28 @@ static struct amba_pl011_data uart2_plat = {
 
 static void __init mop500_uart_init(struct device *parent)
 {
-	db8500_add_uart0(parent, &uart0_plat);
+	struct amba_device *uart0_device;
+
+	uart0_device = db8500_add_uart0(parent, &uart0_plat);
+	if (uart0_device) {
+		u0_p = pinctrl_get(&uart0_device->dev);
+		if (IS_ERR(u0_p))
+			dev_err(&uart0_device->dev,
+				"could not get UART0 pinctrl\n");
+		else {
+			u0_def = pinctrl_lookup_state(u0_p,
+						      PINCTRL_STATE_DEFAULT);
+			if (IS_ERR(u0_def)) {
+				dev_err(&uart0_device->dev,
+					"could not get UART0 defstate\n");
+			}
+			u0_sleep = pinctrl_lookup_state(u0_p,
+							PINCTRL_STATE_SLEEP);
+			if (IS_ERR(u0_sleep))
+				dev_err(&uart0_device->dev,
+					"could not get UART0 idlestate\n");
+		}
+	}
 	db8500_add_uart1(parent, &uart1_plat);
 	db8500_add_uart2(parent, &uart2_plat);
 }
-- 
1.7.9.2

