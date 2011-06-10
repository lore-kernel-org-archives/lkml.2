Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754353Ab1FJIBF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 04:01:05 -0400
Received: from eu1sys200aog108.obsmtp.com ([207.126.144.125]:38937 "EHLO
	eu1sys200aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753939Ab1FJIBC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 04:01:02 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Richard Purdie <rpurdie@rpsys.net>, <linux-kernel@vger.kernel.org>
Cc: Lee Jones <lee.jones@linaro.org>,
        Shreshtha Kumar Sahu <shreshthakumar.sahu@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 2/2] mach-ux500: add lm3530 ALS platform data for U5500
Date: Fri, 10 Jun 2011 10:00:32 +0200
Message-ID: <1307692832-15643-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shreshtha Kumar Sahu <shreshthakumar.sahu@stericsson.com>

platform data for simple backlight driver for LM3530
in the u5500 platform

Signed-off-by: Shreshtha Kumar Sahu <shreshthakumar.sahu@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 arch/arm/mach-ux500/board-u5500.c |   84 ++++++++++++++++++++++++++++++++++++-
 1 files changed, 83 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-ux500/board-u5500.c b/arch/arm/mach-ux500/board-u5500.c
index 44fd3b5..e58f0f5 100644
--- a/arch/arm/mach-ux500/board-u5500.c
+++ b/arch/arm/mach-ux500/board-u5500.c
@@ -10,16 +10,97 @@
 #include <linux/amba/bus.h>
 #include <linux/gpio.h>
 #include <linux/irq.h>
+#include <linux/i2c.h>
 
 #include <asm/mach/arch.h>
 #include <asm/mach-types.h>
 
+#include <plat/pincfg.h>
+#include <plat/i2c.h>
+
 #include <mach/hardware.h>
 #include <mach/devices.h>
 #include <mach/setup.h>
 
+#include "pins-db5500.h"
 #include "devices-db5500.h"
+#include <linux/led-lm3530.h>
+
+/*
+ * GPIO
+ */
+
+static pin_cfg_t u5500_pins[] = {
+	/* I2C */
+	GPIO218_I2C2_SCL        | PIN_INPUT_PULLUP,
+	GPIO219_I2C2_SDA        | PIN_INPUT_PULLUP,
+
+	/* DISPLAY_ENABLE */
+	GPIO226_GPIO        | PIN_OUTPUT_LOW,
+
+	/* Backlight Enbale */
+	GPIO224_GPIO        | PIN_OUTPUT_HIGH,
+};
+/*
+ * I2C
+ */
+
+#define U5500_I2C_CONTROLLER(id, _slsu, _tft, _rft, clk, _sm) \
+static struct nmk_i2c_controller u5500_i2c##id##_data = { \
+	/*				\
+	 * slave data setup time, which is	\
+	 * 250 ns,100ns,10ns which is 14,6,2	\
+	 * respectively for a 48 Mhz	\
+	 * i2c clock			\
+	 */				\
+	.slsu		= _slsu,	\
+	/* Tx FIFO threshold */		\
+	.tft		= _tft,		\
+	/* Rx FIFO threshold */		\
+	.rft		= _rft,		\
+	/* std. mode operation */	\
+	.clk_freq	= clk,		\
+	.sm		= _sm,		\
+}
+/*
+ * The board uses TODO <3> i2c controllers, initialize all of
+ * them with slave data setup time of 250 ns,
+ * Tx & Rx FIFO threshold values as 1 and standard
+ * mode of operation
+ */
+
+U5500_I2C_CONTROLLER(2,	0xe, 1, 1, 400000, I2C_FREQ_MODE_FAST);
+
+static struct lm3530_platform_data u5500_als_platform_data = {
+	.mode = LM3530_BL_MODE_MANUAL,
+	.als_input_mode = LM3530_INPUT_ALS1,
+	.max_current = LM3530_FS_CURR_26mA,
+	.pwm_pol_hi = true,
+	.als_avrg_time = LM3530_ALS_AVRG_TIME_512ms,
+	.brt_ramp_law = 1,      /* Linear */
+	.brt_ramp_fall = LM3530_RAMP_TIME_8s,
+	.brt_ramp_rise = LM3530_RAMP_TIME_8s,
+	.als1_resistor_sel = LM3530_ALS_IMPD_13_53kOhm,
+	.als2_resistor_sel = LM3530_ALS_IMPD_Z,
+	.als_vmin = 730,	/* mV */
+	.als_vmax = 1020,	/* mV */
+	.brt_val = 0x7F,	/* Max brightness */
+};
 
+
+static struct i2c_board_info __initdata u5500_i2c2_devices[] = {
+	{
+		/* Backlight */
+		I2C_BOARD_INFO("lm3530-led", 0x36),
+		.platform_data = &u5500_als_platform_data,
+	},
+};
+
+static void __init u5500_i2c_init(void)
+{
+	db5500_add_i2c2(&u5500_i2c2_data);
+	i2c_register_board_info(2, ARRAY_AND_SIZE(u5500_i2c2_devices));
+}
 static void __init u5500_uart_init(void)
 {
 	db5500_add_uart0(NULL);
@@ -30,7 +111,8 @@ static void __init u5500_uart_init(void)
 static void __init u5500_init_machine(void)
 {
 	u5500_init_devices();
-
+	nmk_config_pins(u5500_pins, ARRAY_SIZE(u5500_pins));
+	u5500_i2c_init();
 	u5500_sdi_init();
 	u5500_uart_init();
 }
-- 
1.7.3.2

