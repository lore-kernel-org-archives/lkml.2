Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753048Ab2EHJsM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 05:48:12 -0400
Received: from eu1sys200aog101.obsmtp.com ([207.126.144.111]:42990 "EHLO
	eu1sys200aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752851Ab2EHJsK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 05:48:10 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Cc: Stephen Warren <swarren@nvidia.com>, Shawn Guo <shawn.guo@freescale.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Ola Lilja <ola.o.lilja@stericsson.com>
Subject: [PATCH 12/12] ARM: ux500: switch MSP to using pinctrl for pins
Date: Tue, 8 May 2012 11:45:47 +0200
Message-ID: <1336470347-23886-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.9.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

The MSP platform data callbacks use the old custom callbacks to
set the state of the pins, switch over to using pinctrl.

Cc: Ola Lilja <ola.o.lilja@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 arch/arm/mach-ux500/board-mop500-msp.c  |   62 ++++++++++++++++++++-----------
 arch/arm/mach-ux500/board-mop500-pins.c |   18 ++++++++-
 2 files changed, 57 insertions(+), 23 deletions(-)

diff --git a/arch/arm/mach-ux500/board-mop500-msp.c b/arch/arm/mach-ux500/board-mop500-msp.c
index aacaf80..9960480 100644
--- a/arch/arm/mach-ux500/board-mop500-msp.c
+++ b/arch/arm/mach-ux500/board-mop500-msp.c
@@ -7,17 +7,18 @@
 #include <linux/platform_device.h>
 #include <linux/init.h>
 #include <linux/gpio.h>
-#include <plat/gpio-nomadik.h>
+#include <linux/pinctrl/consumer.h>
 
+#include <plat/gpio-nomadik.h>
 #include <plat/pincfg.h>
 #include <plat/ste_dma40.h>
 
 #include <mach/devices.h>
-#include <ste-dma40-db8500.h>
 #include <mach/hardware.h>
 #include <mach/irqs.h>
 #include <mach/msp.h>
 
+#include "ste-dma40-db8500.h"
 #include "board-mop500.h"
 #include "devices-db8500.h"
 #include "pins-db8500.h"
@@ -28,19 +29,10 @@ static DEFINE_SPINLOCK(msp_rxtx_lock);
 /* Reference Count */
 static int msp_rxtx_ref;
 
-static pin_cfg_t mop500_msp1_pins_init[] = {
-		GPIO33_MSP1_TXD | PIN_OUTPUT_LOW   | PIN_SLPM_WAKEUP_DISABLE,
-		GPIO34_MSP1_TFS | PIN_INPUT_NOPULL | PIN_SLPM_WAKEUP_DISABLE,
-		GPIO35_MSP1_TCK | PIN_INPUT_NOPULL | PIN_SLPM_WAKEUP_DISABLE,
-		GPIO36_MSP1_RXD | PIN_INPUT_NOPULL | PIN_SLPM_WAKEUP_DISABLE,
-};
-
-static pin_cfg_t mop500_msp1_pins_exit[] = {
-		GPIO33_MSP1_TXD | PIN_OUTPUT_LOW   | PIN_SLPM_WAKEUP_ENABLE,
-		GPIO34_MSP1_TFS | PIN_INPUT_NOPULL | PIN_SLPM_WAKEUP_ENABLE,
-		GPIO35_MSP1_TCK | PIN_INPUT_NOPULL | PIN_SLPM_WAKEUP_ENABLE,
-		GPIO36_MSP1_RXD | PIN_INPUT_NOPULL | PIN_SLPM_WAKEUP_ENABLE,
-};
+/* Pin modes */
+struct pinctrl *msp1_p;
+struct pinctrl_state *msp1_def;
+struct pinctrl_state *msp1_sleep;
 
 int msp13_i2s_init(void)
 {
@@ -48,9 +40,11 @@ int msp13_i2s_init(void)
 	unsigned long flags;
 
 	spin_lock_irqsave(&msp_rxtx_lock, flags);
-	if (msp_rxtx_ref == 0)
-		retval = nmk_config_pins(
-				ARRAY_AND_SIZE(mop500_msp1_pins_init));
+	if (msp_rxtx_ref == 0 && !(IS_ERR(msp1_p) || IS_ERR(msp1_def))) {
+		retval = pinctrl_select_state(msp1_p, msp1_def);
+		if (retval)
+			pr_err("could not set MSP1 defstate\n");
+	}
 	if (!retval)
 		msp_rxtx_ref++;
 	spin_unlock_irqrestore(&msp_rxtx_lock, flags);
@@ -66,9 +60,11 @@ int msp13_i2s_exit(void)
 	spin_lock_irqsave(&msp_rxtx_lock, flags);
 	WARN_ON(!msp_rxtx_ref);
 	msp_rxtx_ref--;
-	if (msp_rxtx_ref == 0)
-		retval = nmk_config_pins_sleep(
-				ARRAY_AND_SIZE(mop500_msp1_pins_exit));
+	if (msp_rxtx_ref == 0 && !(IS_ERR(msp1_p) || IS_ERR(msp1_sleep))) {
+		retval = pinctrl_select_state(msp1_p, msp1_sleep);
+		if (retval)
+			pr_err("could not set MSP1 sleepstate\n");
+	}
 	spin_unlock_irqrestore(&msp_rxtx_lock, flags);
 
 	return retval;
@@ -229,19 +225,41 @@ static struct msp_i2s_platform_data msp3_platform_data = {
 
 int mop500_msp_init(struct device *parent)
 {
+	struct platform_device *msp1;
+
 	pr_info("%s: Register platform-device 'snd-soc-u8500'.\n", __func__);
 	platform_device_register(&snd_soc_u8500);
 
 	pr_info("Initialize MSP I2S-devices.\n");
 	db8500_add_msp_i2s(parent, 0, U8500_MSP0_BASE, IRQ_DB8500_MSP0,
 			   &msp0_platform_data);
-	db8500_add_msp_i2s(parent, 1, U8500_MSP1_BASE, IRQ_DB8500_MSP1,
+	msp1 = db8500_add_msp_i2s(parent, 1, U8500_MSP1_BASE, IRQ_DB8500_MSP1,
 			   &msp1_platform_data);
 	db8500_add_msp_i2s(parent, 2, U8500_MSP2_BASE, IRQ_DB8500_MSP2,
 			   &msp2_platform_data);
 	db8500_add_msp_i2s(parent, 3, U8500_MSP3_BASE, IRQ_DB8500_MSP1,
 			   &msp3_platform_data);
 
+	/* Get the pinctrl handle for MSP1 */
+	if (msp1) {
+		msp1_p = pinctrl_get(&msp1->dev);
+		if (IS_ERR(msp1_p))
+			dev_err(&msp1->dev, "could not get MSP1 pinctrl\n");
+		else {
+			msp1_def = pinctrl_lookup_state(msp1_p,
+							PINCTRL_STATE_DEFAULT);
+			if (IS_ERR(msp1_def)) {
+				dev_err(&msp1->dev,
+					"could not get MSP1 defstate\n");
+			}
+			msp1_sleep = pinctrl_lookup_state(msp1_p,
+							  PINCTRL_STATE_SLEEP);
+			if (IS_ERR(msp1_sleep))
+				dev_err(&msp1->dev,
+					"could not get MSP1 idlestate\n");
+		}
+	}
+
 	pr_info("%s: Register platform-device 'ux500-pcm'\n", __func__);
 	platform_device_register(&ux500_pcm);
 
diff --git a/arch/arm/mach-ux500/board-mop500-pins.c b/arch/arm/mach-ux500/board-mop500-pins.c
index dccd29d..32fd992 100644
--- a/arch/arm/mach-ux500/board-mop500-pins.c
+++ b/arch/arm/mach-ux500/board-mop500-pins.c
@@ -32,12 +32,14 @@ static enum custom_pin_cfg_t pinsfor;
 BIAS(pd, PIN_PULL_DOWN);
 BIAS(slpm_gpio_nopull, PIN_SLPM_GPIO|PIN_SLPM_INPUT_NOPULL);
 BIAS(in_nopull, PIN_INPUT_NOPULL);
+BIAS(in_nopull_sleep_nowkup, PIN_INPUT_NOPULL|PIN_SLPM_WAKEUP_DISABLE);
 BIAS(in_pu, PIN_INPUT_PULLUP);
 BIAS(in_pd, PIN_INPUT_PULLDOWN);
 BIAS(in_pd_slpm_in_pu, PIN_INPUT_PULLDOWN|PIN_SLPM_INPUT_PULLUP);
 BIAS(in_pu_slpm_out_lo, PIN_INPUT_PULLUP|PIN_SLPM_OUTPUT_LOW);
 BIAS(out_hi, PIN_OUTPUT_HIGH);
 BIAS(out_lo, PIN_OUTPUT_LOW);
+BIAS(out_lo_sleep_nowkup, PIN_OUTPUT_LOW|PIN_SLPM_WAKEUP_DISABLE);
 /* These also force them into GPIO mode */
 BIAS(gpio_in_pu, PIN_INPUT_PULLUP|PIN_GPIOMODE_ENABLED);
 BIAS(gpio_in_pd, PIN_INPUT_PULLDOWN|PIN_GPIOMODE_ENABLED);
@@ -47,7 +49,9 @@ BIAS(gpio_out_hi, PIN_OUTPUT_HIGH|PIN_GPIOMODE_ENABLED);
 BIAS(gpio_out_lo, PIN_OUTPUT_LOW|PIN_GPIOMODE_ENABLED);
 /* Sleep modes */
 BIAS(sleep_in_wkup_pdis, PIN_SLPM_DIR_INPUT|PIN_SLPM_WAKEUP_ENABLE|PIN_SLPM_PDIS_DISABLED);
+BIAS(sleep_in_nopull_wkup, PIN_INPUT_NOPULL|PIN_SLPM_WAKEUP_ENABLE);
 BIAS(sleep_out_hi_wkup_pdis, PIN_SLPM_OUTPUT_HIGH|PIN_SLPM_WAKEUP_ENABLE|PIN_SLPM_PDIS_DISABLED);
+BIAS(sleep_out_lo_wkup, PIN_OUTPUT_LOW|PIN_SLPM_WAKEUP_ENABLE);
 BIAS(sleep_out_wkup_pdis, PIN_SLPM_DIR_OUTPUT|PIN_SLPM_WAKEUP_ENABLE|PIN_SLPM_PDIS_DISABLED);
 
 /* We use these to define hog settings that are always done on boot */
@@ -129,11 +133,23 @@ static struct pinctrl_map __initdata mop500_family_pinmap[] = {
 	DB8500_PIN("GPIO1_AJ3", out_hi, "uart0"), /* RTS */
 	DB8500_PIN("GPIO2_AH4", in_pu, "uart0"), /* RXD */
 	DB8500_PIN("GPIO3_AH3", out_hi, "uart0"), /* TXD */
-	/* Sleep state for UART0 */
+	/* UART0 sleep state */
 	DB8500_PIN_SLEEP("GPIO0_AJ5", sleep_in_wkup_pdis, "uart0"),
 	DB8500_PIN_SLEEP("GPIO1_AJ3", sleep_out_hi_wkup_pdis, "uart0"),
 	DB8500_PIN_SLEEP("GPIO2_AH4", sleep_in_wkup_pdis, "uart0"),
 	DB8500_PIN_SLEEP("GPIO3_AH3", sleep_out_wkup_pdis, "uart0"),
+	/* MSP1 for ALSA codec */
+	DB8500_MUX("msp1txrx_a_1", "msp1", "ux500-msp-i2s.1"),
+	DB8500_MUX("msp1_a_1", "msp1", "ux500-msp-i2s.1"),
+	DB8500_PIN("GPIO33_AF2", out_lo_sleep_nowkup, "ux500-msp-i2s.1"),
+	DB8500_PIN("GPIO34_AE1", in_nopull_sleep_nowkup, "ux500-msp-i2s.1"),
+	DB8500_PIN("GPIO35_AE2", in_nopull_sleep_nowkup, "ux500-msp-i2s.1"),
+	DB8500_PIN("GPIO36_AG2", in_nopull_sleep_nowkup, "ux500-msp-i2s.1"),
+	/* MSP1 sleep state */
+	DB8500_PIN_SLEEP("GPIO33_AF2", sleep_out_lo_wkup, "ux500-msp-i2s.1"),
+	DB8500_PIN_SLEEP("GPIO34_AE1", sleep_in_nopull_wkup, "ux500-msp-i2s.1"),
+	DB8500_PIN_SLEEP("GPIO35_AE2", sleep_in_nopull_wkup, "ux500-msp-i2s.1"),
+	DB8500_PIN_SLEEP("GPIO36_AG2", sleep_in_nopull_wkup, "ux500-msp-i2s.1"),
 	/* Mux in LCD data lines 8 thru 11 and LCDA CLK for MCDE TVOUT */
 	DB8500_MUX("lcd_d8_d11_a_1", "lcd", "mcde-tvout"),
 	DB8500_MUX("lcdaclk_b_1", "lcda", "mcde-tvout"),
-- 
1.7.9.2

