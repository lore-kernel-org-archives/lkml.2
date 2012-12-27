Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751795Ab2L0AZx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2012 19:25:53 -0500
Received: from server.prisktech.co.nz ([115.188.14.127]:63529 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648Ab2L0AZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2012 19:25:50 -0500
From: Tony Prisk <linux@prisktech.co.nz>
To: Florian Schandinat <FlorianSchandinat@gmx.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-fbdev@vger.kernel.org, Tony Prisk <linux@prisktech.co.nz>
Subject: [PATCH fix-3.8] video: vt8500: Fix X crash when initializing framebuffer.
Date: Thu, 27 Dec 2012 13:25:43 +1300
Message-Id: <1356567943-3836-1-git-send-email-linux@prisktech.co.nz>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for .fb_check_var which is required when
X attempts to initialize the framebuffer. The only supported
resolution is the native resolution of the LCD panel, so we test
against the resolution supplied from the DT panel definition.

Signed-off-by: Tony Prisk <linux@prisktech.co.nz>
---
 drivers/video/wm8505fb.c |   25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/drivers/video/wm8505fb.c b/drivers/video/wm8505fb.c
index 77539c1..c84e376 100644
--- a/drivers/video/wm8505fb.c
+++ b/drivers/video/wm8505fb.c
@@ -41,10 +41,18 @@
 
 #define to_wm8505fb_info(__info) container_of(__info, \
 						struct wm8505fb_info, fb)
+
+struct lcd_params {
+	u32 pixel_width;
+	u32 pixel_height;
+	u32 color_depth;
+};
+
 struct wm8505fb_info {
 	struct fb_info		fb;
 	void __iomem		*regbase;
 	unsigned int		contrast;
+	struct lcd_params	lcd_params;
 };
 
 
@@ -248,8 +256,21 @@ static int wm8505fb_blank(int blank, struct fb_info *info)
 	return 0;
 }
 
+static int wm8505fb_check_var(struct fb_var_screeninfo *var,
+			      struct fb_info *info)
+{
+	struct wm8505fb_info *fbi = to_wm8505fb_info(info);
+        if (!fbi) return -EINVAL;
+
+	if (info->var.bits_per_pixel != fbi->lcd_params.color_depth) return -EINVAL;
+	if (info->var.xres != fbi->lcd_params.pixel_width) return -EINVAL;
+	if (info->var.yres != fbi->lcd_params.pixel_height) return -EINVAL;
+	return 0;
+}
+
 static struct fb_ops wm8505fb_ops = {
 	.owner		= THIS_MODULE,
+	.fb_check_var	= wm8505fb_check_var,
 	.fb_set_par	= wm8505fb_set_par,
 	.fb_setcolreg	= wm8505fb_setcolreg,
 	.fb_fillrect	= wmt_ge_fillrect,
@@ -354,6 +375,10 @@ static int __devinit wm8505fb_probe(struct platform_device *pdev)
 		goto failed_free_res;
 	}
 
+	fbi->lcd_params.pixel_width = of_mode.xres;
+	fbi->lcd_params.pixel_height = of_mode.yres;
+	fbi->lcd_params.color_depth = bpp;
+
 	of_mode.vmode = FB_VMODE_NONINTERLACED;
 	fb_videomode_to_var(&fbi->fb.var, &of_mode);
 
-- 
1.7.9.5

