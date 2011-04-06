Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756106Ab1DFNCe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 09:02:34 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:52038 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756037Ab1DFNB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 09:01:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=g+/CLbYEgGQXMP9wcxXf10roGdWoc5NDR/JGHFidBBDa60Zqg3l7a3JosXi6Zss1MI
         8GQDEYRr0v+AROcJPQbQ+2t9jE6Dcox6DRq7Vd8K8AsfFZBEuhZv1on6CO4kLrWvn9gN
         Tvcly4aCIUdeaugJCnAgwM6i6RovS2uHKJlwE=
From: Marek Belisko <marek.belisko@open-nandra.com>
To: ben-linux@fluff.org
Cc: linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, esta1ien@gmail.com, buserror@gmail.com,
        Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH v2 2/4] s3c2440: mini2440: Add touchscreen support for mini2440.
Date: Wed,  6 Apr 2011 15:01:35 +0200
Message-Id: <1302094897-18446-3-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1302094897-18446-1-git-send-email-marek.belisko@open-nandra.com>
References: <1302094897-18446-1-git-send-email-marek.belisko@open-nandra.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch add support for mini2440 touchscreen.
Some code borrowed from:
git://repo.or.cz/linux-2.6/mini2440.git

Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
---
 arch/arm/mach-s3c2440/mach-mini2440.c |   17 +++++++++++++++--
 1 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-s3c2440/mach-mini2440.c b/arch/arm/mach-s3c2440/mach-mini2440.c
index ce152b4..163d318 100644
--- a/arch/arm/mach-s3c2440/mach-mini2440.c
+++ b/arch/arm/mach-s3c2440/mach-mini2440.c
@@ -47,6 +47,7 @@
 #include <plat/iic.h>
 #include <plat/mci.h>
 #include <plat/udc.h>
+#include <plat/ts.h>
 
 #include <linux/mtd/mtd.h>
 #include <linux/mtd/nand.h>
@@ -530,6 +531,11 @@ static struct platform_device uda1340_codec = {
 		.id = -1,
 };
 
+static struct s3c2410_ts_mach_info mini2440_ts_cfg __initdata = {
+	.delay = 10000,
+	.presc = 0xff, /* slow as we can go */
+};
+
 static struct platform_device *mini2440_devices[] __initdata = {
 	&s3c_device_ohci,
 	&s3c_device_wdt,
@@ -548,6 +554,7 @@ static struct platform_device *mini2440_devices[] __initdata = {
 	&uda1340_codec,
 	&mini2440_audio,
 	&samsung_asoc_dma,
+	&s3c_device_adc,
 };
 
 static void __init mini2440_map_io(void)
@@ -631,8 +638,13 @@ static void mini2440_parse_features(
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
@@ -699,6 +711,7 @@ static void __init mini2440_init(void)
 	s3c24xx_mci_set_platdata(&mini2440_mmc_cfg);
 	s3c_nand_set_platdata(&mini2440_nand_info);
 	s3c_i2c0_set_platdata(NULL);
+	s3c24xx_ts_set_platdata(&mini2440_ts_cfg);
 
 	i2c_register_board_info(0, mini2440_i2c_devs,
 				ARRAY_SIZE(mini2440_i2c_devs));
-- 
1.7.1

