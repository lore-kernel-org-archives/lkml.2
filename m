Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756786Ab1FUOlx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 10:41:53 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:48273 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753678Ab1FUOkI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 10:40:08 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Liam Girdwood <lrg@ti.com>, Tony Lindgren <tony@atomide.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: linux-input@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        Peter Ujfalusi <peter.ujfalusi@ti.com>
Subject: [PATCH v6 12/18] OMAP4: SDP4430: Add twl6040 vibrator platform support
Date: Tue, 21 Jun 2011 16:39:10 +0300
Message-ID: <1308663556-29120-13-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.5.3
In-Reply-To: <1308663556-29120-1-git-send-email-peter.ujfalusi@ti.com>
References: <1308663556-29120-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add twl4030_vibra platform data, and the needed regulators
for twl6040 vibrator.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 arch/arm/mach-omap2/board-4430sdp.c |   48 +++++++++++++++++++++++++++++++++++
 1 files changed, 48 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-omap2/board-4430sdp.c b/arch/arm/mach-omap2/board-4430sdp.c
index 968029a..266d146 100644
--- a/arch/arm/mach-omap2/board-4430sdp.c
+++ b/arch/arm/mach-omap2/board-4430sdp.c
@@ -22,6 +22,7 @@
 #include <linux/i2c/twl.h>
 #include <linux/gpio_keys.h>
 #include <linux/regulator/machine.h>
+#include <linux/regulator/fixed.h>
 #include <linux/leds.h>
 #include <linux/leds_pwm.h>
 
@@ -276,11 +277,40 @@ static struct platform_device sdp4430_lcd_device = {
 	.id		= -1,
 };
 
+static struct regulator_consumer_supply sdp4430_vbat_supply[] = {
+	REGULATOR_SUPPLY("vddvibl", "twl6040-vibra"),
+	REGULATOR_SUPPLY("vddvibr", "twl6040-vibra"),
+};
+
+static struct regulator_init_data sdp4430_vbat_data = {
+	.constraints = {
+		.always_on	= 1,
+	},
+	.num_consumer_supplies	= ARRAY_SIZE(sdp4430_vbat_supply),
+	.consumer_supplies	= sdp4430_vbat_supply,
+};
+
+static struct fixed_voltage_config sdp4430_vbat_pdata = {
+	.supply_name	= "VBAT",
+	.microvolts	= 3750000,
+	.init_data	= &sdp4430_vbat_data,
+	.gpio		= -EINVAL,
+};
+
+static struct platform_device sdp4430_vbat = {
+	.name		= "reg-fixed-voltage",
+	.id		= -1,
+	.dev = {
+		.platform_data = &sdp4430_vbat_pdata,
+	},
+};
+
 static struct platform_device *sdp4430_devices[] __initdata = {
 	&sdp4430_lcd_device,
 	&sdp4430_gpio_keys_device,
 	&sdp4430_leds_gpio,
 	&sdp4430_leds_pwm,
+	&sdp4430_vbat,
 };
 
 static struct omap_lcd_config sdp4430_lcd_config __initdata = {
@@ -402,7 +432,25 @@ static struct regulator_init_data sdp4430_vusim = {
 	},
 };
 
+static struct twl4030_vibra_data twl6040_vibra = {
+	.vibldrv_res = 8,
+	.vibrdrv_res = 3,
+	.viblmotor_res = 10,
+	.vibrmotor_res = 10,
+	.vddvibl_uV = 0,	/* fixed volt supply - VBAT */
+	.vddvibr_uV = 0,	/* fixed volt supply - VBAT */
+};
+
+static struct twl4030_audio_data twl6040_audio = {
+	.codec		= NULL,
+	.vibra		= &twl6040_vibra,
+	.audpwron_gpio	= 127,
+	.naudint_irq	= OMAP44XX_IRQ_SYS_2N,
+	.irq_base	= TWL6040_CODEC_IRQ_BASE,
+};
+
 static struct twl4030_platform_data sdp4430_twldata = {
+	.audio		= &twl6040_audio,
 	/* Regulators */
 	.vusim		= &sdp4430_vusim,
 	.vaux1		= &sdp4430_vaux1,
-- 
1.7.5.3

