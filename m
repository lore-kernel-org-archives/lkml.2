Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754401Ab0ELApX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 20:45:23 -0400
Received: from blue-ld-261.synserver.de ([217.119.54.83]:46204 "EHLO
	smtp-out-072.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754093Ab0ELApP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 20:45:15 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 1517
From: Lars-Peter Clausen <lars@metafoo.de>
To: rpurdie@rpsys.net
Cc: sameo@linux.intel.com, linux-kernel@vger.kernel.org,
       Lars-Peter Clausen <lars@metafoo.de>, Ben Dooks <ben-linux@fluff.org>
Subject: [PATCH 3/3] gta02: Use pcf50633 backlight driver instead of platform backlight driver.
Date: Wed, 12 May 2010 02:44:34 +0200
Message-Id: <1273625074-15312-4-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1273625074-15312-1-git-send-email-lars@metafoo.de>
References: <1273625074-15312-1-git-send-email-lars@metafoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the pcf50633 backlight driver instead of the platform backlight driver.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Cc: Ben Dooks <ben-linux@fluff.org>
---
 arch/arm/mach-s3c2440/mach-gta02.c |   76 ++++-------------------------------
 1 files changed, 9 insertions(+), 67 deletions(-)

diff --git a/arch/arm/mach-s3c2440/mach-gta02.c b/arch/arm/mach-s3c2440/mach-gta02.c
index 45799c6..120a26f 100644
--- a/arch/arm/mach-s3c2440/mach-gta02.c
+++ b/arch/arm/mach-s3c2440/mach-gta02.c
@@ -49,7 +49,6 @@
 #include <linux/io.h>
 
 #include <linux/i2c.h>
-#include <linux/backlight.h>
 #include <linux/regulator/machine.h>
 
 #include <linux/mfd/pcf50633/core.h>
@@ -57,6 +56,7 @@
 #include <linux/mfd/pcf50633/adc.h>
 #include <linux/mfd/pcf50633/gpio.h>
 #include <linux/mfd/pcf50633/pmic.h>
+#include <linux/mfd/pcf50633/backlight.h>
 
 #include <asm/mach/arch.h>
 #include <asm/mach/map.h>
@@ -254,6 +254,12 @@ static char *gta02_batteries[] = {
 	"battery",
 };
 
+static struct pcf50633_bl_platform_data gta02_backlight_data = {
+	.default_brightness = 0x3f,
+	.default_brightness_limit = 0,
+	.ramp_time = 5,
+};
+
 struct pcf50633_platform_data gta02_pcf_pdata = {
 	.resumers = {
 		[0] =	PCF50633_INT1_USBINS |
@@ -271,6 +277,8 @@ struct pcf50633_platform_data gta02_pcf_pdata = {
 
 	.charger_reference_current_ma = 1000,
 
+	.backlight_data = &gta02_backlight_data,
+
 	.reg_init_data = {
 		[PCF50633_REGULATOR_AUTO] = {
 			.constraints = {
@@ -478,71 +486,6 @@ static struct s3c2410_udc_mach_info gta02_udc_cfg = {
 
 };
 
-
-
-static void gta02_bl_set_intensity(int intensity)
-{
-	struct pcf50633 *pcf = gta02_pcf;
-	int old_intensity = pcf50633_reg_read(pcf, PCF50633_REG_LEDOUT);
-
-	/* We map 8-bit intensity to 6-bit intensity in hardware. */
-	intensity >>= 2;
-
-	/*
-	 * This can happen during, eg, print of panic on blanked console,
-	 * but we can't service i2c without interrupts active, so abort.
-	 */
-	if (in_atomic()) {
-		printk(KERN_ERR "gta02_bl_set_intensity called while atomic\n");
-		return;
-	}
-
-	old_intensity = pcf50633_reg_read(pcf, PCF50633_REG_LEDOUT);
-	if (intensity == old_intensity)
-		return;
-
-	/* We can't do this anywhere else. */
-	pcf50633_reg_write(pcf, PCF50633_REG_LEDDIM, 5);
-
-	if (!(pcf50633_reg_read(pcf, PCF50633_REG_LEDENA) & 3))
-		old_intensity = 0;
-
-	/*
-	 * The PCF50633 cannot handle LEDOUT = 0 (datasheet p60)
-	 * if seen, you have to re-enable the LED unit.
-	 */
-	if (!intensity || !old_intensity)
-		pcf50633_reg_write(pcf, PCF50633_REG_LEDENA, 0);
-
-	/* Illegal to set LEDOUT to 0. */
-	if (!intensity)
-		pcf50633_reg_set_bit_mask(pcf, PCF50633_REG_LEDOUT, 0x3f, 2);
-	else
-		pcf50633_reg_set_bit_mask(pcf, PCF50633_REG_LEDOUT, 0x3f,
-					  intensity);
-
-	if (intensity)
-		pcf50633_reg_write(pcf, PCF50633_REG_LEDENA, 2);
-
-}
-
-static struct generic_bl_info gta02_bl_info = {
-	.name			= "gta02-bl",
-	.max_intensity		= 0xff,
-	.default_intensity	= 0xff,
-	.set_bl_intensity	= gta02_bl_set_intensity,
-};
-
-static struct platform_device gta02_bl_dev = {
-	.name			= "generic-bl",
-	.id			= 1,
-	.dev = {
-		.platform_data = &gta02_bl_info,
-	},
-};
-
-
-
 /* USB */
 static struct s3c2410_hcd_info gta02_usb_info __initdata = {
 	.port[0]	= {
@@ -579,7 +522,6 @@ static struct platform_device *gta02_devices[] __initdata = {
 /* These guys DO need to be children of PMU. */
 
 static struct platform_device *gta02_devices_pmu_children[] = {
-	&gta02_bl_dev,
 };
 
 
-- 
1.5.6.5

