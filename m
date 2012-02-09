Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752192Ab2BIFU6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 00:20:58 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:47289 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750819Ab2BIFUz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 00:20:55 -0500
From: "Manjunathappa, Prakash" <prakash.pm@ti.com>
To: <linux-fbdev@vger.kernel.org>
CC: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-kernel@vger.kernel.org>,
        "Manjunathappa, Prakash" <prakash.pm@ti.com>
Subject: [PATCH] video:da8xx-fb: calculate pixel clock period for the panel
Date: Thu, 9 Feb 2012 10:34:39 +0530
Message-ID: <1328763879-16345-2-git-send-email-prakash.pm@ti.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1328763879-16345-1-git-send-email-prakash.pm@ti.com>
References: <1328763879-16345-1-git-send-email-prakash.pm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch calculates pixel clock period in pico seconds and updates
the same in variable screen information structure. fbset utility
uses this information.

Signed-off-by: Manjunathappa, Prakash <prakash.pm@ti.com>
---
 drivers/video/da8xx-fb.c |   21 ++++++++++++++++++++-
 1 files changed, 20 insertions(+), 1 deletions(-)

diff --git a/drivers/video/da8xx-fb.c b/drivers/video/da8xx-fb.c
index f360d62..8b0a174 100644
--- a/drivers/video/da8xx-fb.c
+++ b/drivers/video/da8xx-fb.c
@@ -32,6 +32,7 @@
 #include <linux/console.h>
 #include <linux/slab.h>
 #include <video/da8xx-fb.h>
+#include <asm/div64.h>
 
 #define DRIVER_NAME "da8xx_lcdc"
 
@@ -174,7 +175,6 @@ static struct fb_var_screeninfo da8xx_fb_var __devinitdata = {
 	.activate = 0,
 	.height = -1,
 	.width = -1,
-	.pixclock = 46666,	/* 46us - AUO display */
 	.accel_flags = 0,
 	.left_margin = LEFT_MARGIN,
 	.right_margin = RIGHT_MARGIN,
@@ -1048,6 +1048,24 @@ static struct fb_ops da8xx_fb_ops = {
 	.fb_blank = cfb_blank,
 };
 
+/*
+ * Calculate and return pixel clock period in pico secods
+ */
+static unsigned int da8xxfb_pixel_clk_period(struct da8xx_fb_par *par)
+{
+	unsigned int lcd_clk, div;
+	unsigned int configured_pix_clk;
+	unsigned long long pix_clk_period_picosec = 1000000000000ULL;
+
+	lcd_clk = clk_get_rate(par->lcdc_clk);
+	div = lcd_clk / par->pxl_clk;
+	configured_pix_clk = (lcd_clk / div);
+
+	do_div(pix_clk_period_picosec, configured_pix_clk);
+
+	return pix_clk_period_picosec;
+}
+
 static int __devinit fb_probe(struct platform_device *device)
 {
 	struct da8xx_lcdc_platform_data *fb_pdata =
@@ -1209,6 +1227,7 @@ static int __devinit fb_probe(struct platform_device *device)
 
 	da8xx_fb_var.hsync_len = lcdc_info->hsw;
 	da8xx_fb_var.vsync_len = lcdc_info->vsw;
+	da8xx_fb_var.pixclock = da8xxfb_pixel_clk_period(par);
 
 	/* Initialize fbinfo */
 	da8xx_fb_info->flags = FBINFO_FLAG_DEFAULT;
-- 
1.7.1

