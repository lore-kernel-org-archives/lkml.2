Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935722Ab0GPHAW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 03:00:22 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:50751 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935668Ab0GPHAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 03:00:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=Izdq2NklgTdXXbUjIkhwUULByY3i3k05Z3dSguCMPdcnwLhaSLL/Cppspf8pNsgOEf
         T+p9HZLDLm3IcmPTrNYPeZmPfTB9+gyaBs6djKTzAtD9ftEjyEmGjn1xkwhxNGP7wBSJ
         wDcs+eWyGET8xN4sBdFNzqkrVPEXs/6zTEs0U=
Message-ID: <4C400377.3020408@gmail.com>
Date: Fri, 16 Jul 2010 15:00:07 +0800
From: Wan ZongShun <mcuos.com@gmail.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>
Subject: [PATCH] ARM/nuc900: re-organize the nuc900 lcd arch platform data
 setting
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch re-organizes the nuc900 lcd arch platform data,
remove the lcd platform data setting from nuc950.c to dev.c

It can maximize the share codes between nuc900 series MCUs.

Signed-off-by: Wan ZongShun <mcuos.com@gmail.com>
---
 arch/arm/mach-w90x900/dev.c            |   55 +++++++++++++++++++++++---------
 arch/arm/mach-w90x900/mach-nuc950evb.c |   44 -------------------------
 arch/arm/mach-w90x900/nuc910.c         |    1 +
 arch/arm/mach-w90x900/nuc950.c         |    2 -
 4 files changed, 41 insertions(+), 61 deletions(-)

diff --git a/arch/arm/mach-w90x900/dev.c b/arch/arm/mach-w90x900/dev.c
index b2eda4d..73b3eca 100644
--- a/arch/arm/mach-w90x900/dev.c
+++ b/arch/arm/mach-w90x900/dev.c
@@ -36,6 +36,7 @@
 #include <mach/nuc900_spi.h>
 #include <mach/map.h>
 #include <mach/fb.h>
+#include <mach/regs-ldm.h>

 #include "cpu.h"

@@ -382,7 +383,44 @@ struct platform_device nuc900_device_kpi = {
 	.resource	= nuc900_kpi_resource,
 };

-#ifdef CONFIG_FB_NUC900
+/* LCD controller*/
+
+static struct nuc900fb_display __initdata nuc900_lcd_info[] = {
+	/* Giantplus Technology GPM1040A0 320x240 Color TFT LCD */
+	[0] = {
+		.type		= LCM_DCCS_VA_SRC_RGB565,
+		.width		= 320,
+		.height		= 240,
+		.xres		= 320,
+		.yres		= 240,
+		.bpp		= 16,
+		.pixclock	= 200000,
+		.left_margin	= 34,
+		.right_margin   = 54,
+		.hsync_len	= 10,
+		.upper_margin	= 18,
+		.lower_margin	= 4,
+		.vsync_len	= 1,
+		.dccs		= 0x8e00041a,
+		.devctl		= 0x060800c0,
+		.fbctrl		= 0x00a000a0,
+		.scale		= 0x04000400,
+	},
+};
+
+static struct nuc900fb_mach_info nuc900_fb_info __initdata = {
+#if defined(CONFIG_GPM1040A0_320X240)
+	.displays		= &nuc900_lcd_info[0],
+#else
+	.displays		= nuc900_lcd_info,
+#endif
+	.num_displays		= ARRAY_SIZE(nuc900_lcd_info),
+	.default_display	= 0,
+	.gpio_dir		= 0x00000004,
+	.gpio_dir_mask		= 0xFFFFFFFD,
+	.gpio_data		= 0x00000004,
+	.gpio_data_mask		= 0xFFFFFFFD,
+};

 static struct resource nuc900_lcd_resource[] = {
 	[0] = {
@@ -406,23 +444,10 @@ struct platform_device nuc900_device_lcd = {
 	.dev              = {
 		.dma_mask               = &nuc900_device_lcd_dmamask,
 		.coherent_dma_mask      = -1,
+		.platform_data = &nuc900_fb_info,
 	}
 };

-void  nuc900_fb_set_platdata(struct nuc900fb_mach_info *pd)
-{
-	struct nuc900fb_mach_info *npd;
-
-	npd = kmalloc(sizeof(*npd), GFP_KERNEL);
-	if (npd) {
-		memcpy(npd, pd, sizeof(*npd));
-		nuc900_device_lcd.dev.platform_data = npd;
-	} else {
-		printk(KERN_ERR "no memory for LCD platform data\n");
-	}
-}
-#endif
-
 /* AUDIO controller*/
 static u64 nuc900_device_audio_dmamask = -1;
 static struct resource nuc900_ac97_resource[] = {
diff --git a/arch/arm/mach-w90x900/mach-nuc950evb.c b/arch/arm/mach-w90x900/mach-nuc950evb.c
index b3edc3c..04d295f 100644
--- a/arch/arm/mach-w90x900/mach-nuc950evb.c
+++ b/arch/arm/mach-w90x900/mach-nuc950evb.c
@@ -20,51 +20,10 @@
 #include <asm/mach/map.h>
 #include <asm/mach-types.h>
 #include <mach/map.h>
-#include <mach/regs-ldm.h>
 #include <mach/fb.h>

 #include "nuc950.h"

-#ifdef CONFIG_FB_NUC900
-/* LCD Controller */
-static struct nuc900fb_display __initdata nuc950_lcd_info[] = {
-	/* Giantplus Technology GPM1040A0 320x240 Color TFT LCD */
-	[0] = {
-		.type		= LCM_DCCS_VA_SRC_RGB565,
-		.width 		= 320,
-		.height		= 240,
-		.xres		= 320,
-		.yres		= 240,
-		.bpp		= 16,
-		.pixclock	= 200000,
-		.left_margin	= 34,
-		.right_margin   = 54,
-		.hsync_len	= 10,
-		.upper_margin	= 18,
-		.lower_margin	= 4,
-		.vsync_len	= 1,
-		.dccs		= 0x8e00041a,
-		.devctl		= 0x060800c0,
-		.fbctrl		= 0x00a000a0,
-		.scale		= 0x04000400,
-	},
-};
-
-static struct nuc900fb_mach_info nuc950_fb_info __initdata = {
-#if defined(CONFIG_GPM1040A0_320X240)
-	.displays		= &nuc950_lcd_info[0],
-#else
-	.displays		= nuc950_lcd_info,
-#endif
-	.num_displays 		= ARRAY_SIZE(nuc950_lcd_info),
-	.default_display	= 0,
-	.gpio_dir		= 0x00000004,
-	.gpio_dir_mask		= 0xFFFFFFFD,
-	.gpio_data		= 0x00000004,
-	.gpio_data_mask		= 0xFFFFFFFD,
-};
-#endif
-
 static void __init nuc950evb_map_io(void)
 {
 	nuc950_map_io();
@@ -74,9 +33,6 @@ static void __init nuc950evb_map_io(void)
 static void __init nuc950evb_init(void)
 {
 	nuc950_board_init();
-#ifdef CONFIG_FB_NUC900
-	nuc900_fb_set_platdata(&nuc950_fb_info);
-#endif
 }

 MACHINE_START(W90P950EVB, "W90P950EVB")
diff --git a/arch/arm/mach-w90x900/nuc910.c b/arch/arm/mach-w90x900/nuc910.c
index 656f03b..cd49776 100644
--- a/arch/arm/mach-w90x900/nuc910.c
+++ b/arch/arm/mach-w90x900/nuc910.c
@@ -26,6 +26,7 @@
 static struct platform_device *nuc910_dev[] __initdata = {
 	&nuc900_device_ts,
 	&nuc900_device_rtc,
+	&nuc900_device_lcd,
 };

 /* define specific CPU platform io map */
diff --git a/arch/arm/mach-w90x900/nuc950.c b/arch/arm/mach-w90x900/nuc950.c
index 4d1f1ab..5704f74 100644
--- a/arch/arm/mach-w90x900/nuc950.c
+++ b/arch/arm/mach-w90x900/nuc950.c
@@ -26,9 +26,7 @@
 static struct platform_device *nuc950_dev[] __initdata = {
 	&nuc900_device_kpi,
 	&nuc900_device_fmi,
-#ifdef CONFIG_FB_NUC900
 	&nuc900_device_lcd,
-#endif
 };

 /* define specific CPU platform io map */
-- 
1.6.3.3
