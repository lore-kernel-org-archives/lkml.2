Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754149Ab0KHNZt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 08:25:49 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:44662 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753128Ab0KHNZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 08:25:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Y33jZlqILcNdVBz4X7lprM0Wyip0i0ABHxGDqHXWmyTMfVGsr59SI5X7aUjgAXhqNR
         OHYQ5sfSfVohJPNiP+vwtCSG3Fp3Ytv8gqk6eF65iWfjFlxHGISzXBb2clW8wC+6F9ZA
         MN6kjPZGMNWEOoqinQGVbjS3i7W5GXp8I+S4Q=
From: Marek Belisko <marek.belisko@gmail.com>
To: Ben Dooks <ben-linux@fluff.org>
Cc: Marek Belisko <marek.belisko@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: s3c2440: mini2440: Add touchscreen support for mini2440.
Date: Mon,  8 Nov 2010 14:27:50 +0100
Message-Id: <1289222870-22580-1-git-send-email-marek.belisko@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch add support for mini2440 touchscreen.
Some code borrowed from:
git://repo.or.cz/linux-2.6/mini2440.git

Signed-off-by: Marek Belisko <marek.belisko@gmail.com>
---
 arch/arm/mach-s3c2440/mach-mini2440.c |   17 +++++++++++++++--
 1 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-s3c2440/mach-mini2440.c b/arch/arm/mach-s3c2440/mach-mini2440.c
index f62bb4c..766d9f4 100644
--- a/arch/arm/mach-s3c2440/mach-mini2440.c
+++ b/arch/arm/mach-s3c2440/mach-mini2440.c
@@ -47,6 +47,7 @@
 #include <plat/iic.h>
 #include <plat/mci.h>
 #include <plat/udc.h>
+#include <plat/ts.h>
 
 #include <linux/mtd/mtd.h>
 #include <linux/mtd/nand.h>
@@ -506,6 +507,11 @@ static struct i2c_board_info mini2440_i2c_devs[] __initdata = {
 	},
 };
 
+static struct s3c2410_ts_mach_info mini2440_ts_cfg __initdata = {
+	.delay = 10000,
+	.presc = 0xff, /* slow as we can go */
+};
+
 static struct platform_device *mini2440_devices[] __initdata = {
 	&s3c_device_ohci,
 	&s3c_device_wdt,
@@ -522,6 +528,7 @@ static struct platform_device *mini2440_devices[] __initdata = {
 	&s3c_device_sdi,
 	&s3c_device_iis,
 	&mini2440_audio,
+	&s3c_device_adc,
 };
 
 static void __init mini2440_map_io(void)
@@ -605,8 +612,13 @@ static void mini2440_parse_features(
 			features->done |= FEATURE_BACKLIGHT;
 			break;
 		case 't':
-			printk(KERN_INFO "MINI2440: '%c' ignored, "
-				"touchscreen not compiled in\n", f);
+			if (features->done & FEATURE_TOUCH)
+				printk(KERN_INFO "MINI2440: '%c' ignored, "
+					"touchscreen already set\n", f);
+			else
+				features->optional[features->count++] =
+						&s3c_device_ts;
+			features->done |= FEATURE_TOUCH;
 			break;
 		case 'c':
 			if (features->done & FEATURE_CAMERA)
@@ -677,6 +689,7 @@ static void __init mini2440_init(void)
 	s3c24xx_mci_set_platdata(&mini2440_mmc_cfg);
 	s3c_nand_set_platdata(&mini2440_nand_info);
 	s3c_i2c0_set_platdata(NULL);
+	s3c24xx_ts_set_platdata(&mini2440_ts_cfg);
 
 	i2c_register_board_info(0, mini2440_i2c_devs,
 				ARRAY_SIZE(mini2440_i2c_devs));
-- 
1.7.1

