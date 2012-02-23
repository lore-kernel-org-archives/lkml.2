Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754347Ab2BWAgL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 19:36:11 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:63088 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754139Ab2BWAgJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 19:36:09 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of chris.diamand@gmail.com designates 10.180.106.67 as permitted sender) smtp.mail=chris.diamand@gmail.com; dkim=pass header.i=chris.diamand@gmail.com
From: Chris Diamand <chris.diamand@gmail.com>
To: kristoffer.ericson@gmail.com
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        Chris Diamand <chris.diamand@gmail.com>
Subject: [PATCH] Jornada 720: Fixes "Invalid argument" when changing backlight brightness.
Date: Thu, 23 Feb 2012 00:36:01 +0000
Message-Id: <1329957361-8010-1-git-send-email-chris.diamand@gmail.com>
X-Mailer: git-send-email 1.7.9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On jornada 720. Running:
echo n > /sys/class/backlight/s1d13806fb/brightness
would give a "write error: Invalid argument" as the max_brightness
was not set, so any value other that 0 exceeds it. Now sets
max_brightness to 255 when the module is loaded.

Backlight can also be turned on and off using
echo 0-4 > /sys/class/backlight/s1d13806fb/bl_power

Also added some extra braces so jornada720_ssp.c.

Signed-off-by: Chris Diamand <chris.diamand@gmail.com>
---
 arch/arm/mach-sa1100/jornada720_ssp.c      |    3 ++-
 drivers/video/backlight/jornada720_bllcd.c |   12 +++++-------
 2 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/arch/arm/mach-sa1100/jornada720_ssp.c b/arch/arm/mach-sa1100/jornada720_ssp.c
index 7ab256a..289ae0f 100644
--- a/arch/arm/mach-sa1100/jornada720_ssp.c
+++ b/arch/arm/mach-sa1100/jornada720_ssp.c
@@ -95,9 +95,10 @@ int jornada_ssp_inout(u8 byte)
 		ret = jornada_ssp_byte(byte);
 		/* Proper return to commands is TxDummy */
 		if (ret != TXDUMMY) {
-			for (i = 0; i < 256; i++)/* flushing bus */
+			for (i = 0; i < 256; i++) { /* flushing bus */
 				if (jornada_ssp_byte(TXDUMMY) == -1)
 					break;
+			}
 			return -ETIMEDOUT;
 		}
 	} else /* Exchange TxDummy for data */
diff --git a/drivers/video/backlight/jornada720_bllcd.c b/drivers/video/backlight/jornada720_bllcd.c
index 645f9ba..bc30faa 100644
--- a/drivers/video/backlight/jornada720_bllcd.c
+++ b/drivers/video/backlight/jornada720_bllcd.c
@@ -71,12 +71,11 @@ static int jornada_bl_update_status(struct backlight_device *dev)
 	if (dev->props.power != FB_BLANK_UNBLANK ||
 	dev->props.fb_blank != FB_BLANK_UNBLANK) {
 		ret = jornada_ssp_inout(BRIGHTNESSOFF);
-		if (ret == -ETIMEDOUT) {
-			printk(KERN_ERR "bl : brightness off timeout\n");
+		if (ret == -ETIMEDOUT)
+			printk(KERN_ERR "bl :brightness off timeout\n");
 			/* backlight off */
-			PPSR &= ~PPC_LDD1;
-			PPDR |= PPC_LDD1;
-		}
+		PPSR &= ~PPC_LDD1;
+		PPDR |= PPC_LDD1;
 	} else { /* backlight on */
 		PPSR |= PPC_LDD1;
 		/* send setbrightness cmd */
@@ -233,6 +232,7 @@ static int jornada_bl_probe(struct platform_device *pdev)
 
 	bllcd->bl_device->props.power = FB_BLANK_UNBLANK;
 	bllcd->bl_device->props.brightness = BL_DEF_BRIGHT;
+	bllcd->bl_device->props.max_brightness = BL_MAX_BRIGHT;
 	jornada_bl_update_status(bllcd->bl_device);
 
 	platform_set_drvdata(pdev, bllcd);
@@ -261,7 +261,6 @@ static int jornada_bl_suspend(struct platform_device *pdev, pm_message_t state)
 
 	bllcd->bl_device->props.power = FB_BLANK_POWERDOWN;
 	bllcd->bl_device->props.brightness = 0;
-	bllcd->bl_device->props.max_brightness = 0;
 	jornada_bl_update_status(bllcd->bl_device);
 
 	jornada_lcd_set_power(bllcd->lcd_device, FB_BLANK_POWERDOWN);
@@ -275,7 +274,6 @@ static int jornada_bl_resume(struct platform_device *pdev)
 
 	bllcd->bl_device->props.power = FB_BLANK_UNBLANK;
 	bllcd->bl_device->props.brightness = BL_DEF_BRIGHT;
-	bllcd->bl_device->props.max_brightness = BL_MAX_BRIGHT;
 	jornada_bl_update_status(bllcd->bl_device);
 
 	jornada_lcd_set_power(bllcd->lcd_device, FB_BLANK_UNBLANK);
-- 
1.7.9

