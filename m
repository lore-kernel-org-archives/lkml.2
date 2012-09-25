Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755190Ab2IYLDF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 07:03:05 -0400
Received: from eu1sys200aog112.obsmtp.com ([207.126.144.133]:49933 "EHLO
	eu1sys200aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752503Ab2IYLDC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 07:03:02 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <arm@kernel.org>
Cc: Anmar Oueja <anmar.oueja@linaro.org>,
        Patrice Chotard <patrice.chotard@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] ARM: ux500: 8500: update I2C sleep states pinctrl
Date: Tue, 25 Sep 2012 13:01:55 +0200
Message-ID: <1348570915-3116-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.11.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Patrice Chotard <patrice.chotard@stericsson.com>

This defines the proper sleep states for all the I2C pins of
the MOP500 DB8500 ASIC setting.

Signed-off-by: Patrice Chotard <patrice.chotard@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
Requesting ARM SoC ACKs to take this through pinctrl for
ease-of-merge going forward, as dependecies are in there.
---
 arch/arm/mach-ux500/board-mop500-pins.c | 30 ++++++++++++++++++++----------
 1 file changed, 20 insertions(+), 10 deletions(-)

diff --git a/arch/arm/mach-ux500/board-mop500-pins.c b/arch/arm/mach-ux500/board-mop500-pins.c
index 722523c..099369e 100644
--- a/arch/arm/mach-ux500/board-mop500-pins.c
+++ b/arch/arm/mach-ux500/board-mop500-pins.c
@@ -30,7 +30,6 @@ static enum custom_pin_cfg_t pinsfor;
 #define BIAS(a,b) static unsigned long a[] = { b }
 
 BIAS(pd, PIN_PULL_DOWN);
-BIAS(slpm_gpio_nopull, PIN_SLPM_GPIO|PIN_SLPM_INPUT_NOPULL);
 BIAS(in_nopull, PIN_INPUT_NOPULL);
 BIAS(in_nopull_slpm_nowkup, PIN_INPUT_NOPULL|PIN_SLPM_WAKEUP_DISABLE);
 BIAS(in_pu, PIN_INPUT_PULLUP);
@@ -55,12 +54,16 @@ BIAS(slpm_out_hi_wkup_pdis, PIN_SLEEPMODE_ENABLED|PIN_SLPM_OUTPUT_HIGH|PIN_SLPM_
 BIAS(slpm_out_wkup_pdis, PIN_SLEEPMODE_ENABLED|PIN_SLPM_WAKEUP_ENABLE|PIN_SLPM_PDIS_DISABLED);
 BIAS(slpm_out_lo_wkup, PIN_SLEEPMODE_ENABLED|PIN_SLPM_OUTPUT_LOW|PIN_SLPM_WAKEUP_ENABLE);
 BIAS(slpm_out_lo_wkup_pdis, PIN_SLEEPMODE_ENABLED|PIN_SLPM_OUTPUT_LOW|PIN_SLPM_WAKEUP_ENABLE|PIN_SLPM_PDIS_DISABLED);
+BIAS(slpm_in_nopull_wkup_pdis, PIN_SLEEPMODE_ENABLED|PIN_SLPM_INPUT_NOPULL|PIN_SLPM_WAKEUP_ENABLE|PIN_SLPM_PDIS_DISABLED);
 
 /* We use these to define hog settings that are always done on boot */
 #define DB8500_MUX_HOG(group,func) \
 	PIN_MAP_MUX_GROUP_HOG_DEFAULT("pinctrl-db8500", group, func)
 #define DB8500_PIN_HOG(pin,conf) \
 	PIN_MAP_CONFIGS_PIN_HOG_DEFAULT("pinctrl-db8500", pin, conf)
+#define DB8500_PIN_SLEEP(pin, conf, dev) \
+	PIN_MAP_CONFIGS_PIN(dev, PINCTRL_STATE_SLEEP, "pinctrl-db8500",	\
+			    pin, conf)
 
 /* These are default states associated with device and changed runtime */
 #define DB8500_MUX(group,func,dev) \
@@ -160,19 +163,26 @@ static struct pinctrl_map __initdata mop500_family_pinmap[] = {
 	DB8500_MUX("lcdaclk_b_1", "lcda", "mcde-tvout"),
 	/* Mux in LCD VSI1 and pull it up for MCDE HDMI output */
 	DB8500_MUX("lcdvsi1_a_1", "lcd", "av8100-hdmi"),
-	/* Mux in I2C blocks, put pins into GPIO in sleepmode no pull-up */
+	/* Mux in i2c0 block, default state */
 	DB8500_MUX("i2c0_a_1", "i2c0", "nmk-i2c.0"),
-	DB8500_PIN("GPIO147_C15", slpm_gpio_nopull, "nmk-i2c.0"),
-	DB8500_PIN("GPIO148_B16", slpm_gpio_nopull, "nmk-i2c.0"),
+	/* i2c0 sleep state */
+	DB8500_PIN_SLEEP("GPIO147_C15", slpm_in_nopull_wkup_pdis, "nmk-i2c.0"), /* SDA */
+	DB8500_PIN_SLEEP("GPIO148_B16", slpm_in_nopull_wkup_pdis, "nmk-i2c.0"), /* SCL */
+	/* Mux in i2c1 block, default state  */
 	DB8500_MUX("i2c1_b_2", "i2c1", "nmk-i2c.1"),
-	DB8500_PIN("GPIO16_AD3", slpm_gpio_nopull, "nmk-i2c.1"),
-	DB8500_PIN("GPIO17_AD4", slpm_gpio_nopull, "nmk-i2c.1"),
+	/* i2c1 sleep state */
+	DB8500_PIN_SLEEP("GPIO16_AD3", slpm_in_nopull_wkup_pdis, "nmk-i2c.1"), /* SDA */
+	DB8500_PIN_SLEEP("GPIO17_AD4", slpm_in_nopull_wkup_pdis, "nmk-i2c.1"), /* SCL */
+	/* Mux in i2c2 block, default state  */
 	DB8500_MUX("i2c2_b_2", "i2c2", "nmk-i2c.2"),
-	DB8500_PIN("GPIO10_AF5", slpm_gpio_nopull, "nmk-i2c.2"),
-	DB8500_PIN("GPIO11_AG4", slpm_gpio_nopull, "nmk-i2c.2"),
+	/* i2c2 sleep state */
+	DB8500_PIN_SLEEP("GPIO10_AF5", slpm_in_nopull_wkup_pdis, "nmk-i2c.2"), /* SDA */
+	DB8500_PIN_SLEEP("GPIO11_AG4", slpm_in_nopull_wkup_pdis, "nmk-i2c.2"), /* SCL */
+	/* Mux in i2c3 block, default state  */
 	DB8500_MUX("i2c3_c_2", "i2c3", "nmk-i2c.3"),
-	DB8500_PIN("GPIO229_AG7", slpm_gpio_nopull, "nmk-i2c.3"),
-	DB8500_PIN("GPIO230_AF7", slpm_gpio_nopull, "nmk-i2c.3"),
+	/* i2c3 sleep state */
+	DB8500_PIN_SLEEP("GPIO229_AG7", slpm_in_nopull_wkup_pdis, "nmk-i2c.3"), /* SDA */
+	DB8500_PIN_SLEEP("GPIO230_AF7", slpm_in_nopull_wkup_pdis, "nmk-i2c.3"), /* SCL */
 	/* Mux in SDI0 (here called MC0) used for removable MMC/SD/SDIO cards */
 	DB8500_MUX("mc0_a_1", "mc0", "sdi0"),
 	DB8500_PIN("GPIO18_AC2", out_hi, "sdi0"), /* CMDDIR */
-- 
1.7.11.3

