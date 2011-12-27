Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754544Ab1L0ORK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 09:17:10 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53686 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754381Ab1L0OQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 09:16:19 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jingoo Han <jg1.han@samsung.com>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 5/6] video: s3c-fb: Hold runtime PM references when touching registers
Date: Tue, 27 Dec 2011 14:16:11 +0000
Message-Id: <1324995372-3410-5-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1324995372-3410-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <20111227141550.GA3331@opensource.wolfsonmicro.com>
 <1324995372-3410-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Take a runtime PM reference whenever updating registers in preparation
for suspending the device when the framebuffer is blanked.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/video/s3c-fb.c |   22 ++++++++++++++++++++++
 1 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/drivers/video/s3c-fb.c b/drivers/video/s3c-fb.c
index 688b9d8..84cf631 100644
--- a/drivers/video/s3c-fb.c
+++ b/drivers/video/s3c-fb.c
@@ -496,6 +496,8 @@ static int s3c_fb_set_par(struct fb_info *info)
 
 	dev_dbg(sfb->dev, "setting framebuffer parameters\n");
 
+	pm_runtime_get_sync(sfb->dev);
+
 	shadow_protect_win(win, 1);
 
 	switch (var->bits_per_pixel) {
@@ -692,6 +694,8 @@ static int s3c_fb_set_par(struct fb_info *info)
 
 	shadow_protect_win(win, 0);
 
+	pm_runtime_put_sync(sfb->dev);
+
 	return 0;
 }
 
@@ -763,6 +767,8 @@ static int s3c_fb_setcolreg(unsigned regno,
 	dev_dbg(sfb->dev, "%s: win %d: %d => rgb=%d/%d/%d\n",
 		__func__, win->index, regno, red, green, blue);
 
+	pm_runtime_get_sync(sfb->dev);
+
 	switch (info->fix.visual) {
 	case FB_VISUAL_TRUECOLOR:
 		/* true-colour, use pseudo-palette */
@@ -790,9 +796,11 @@ static int s3c_fb_setcolreg(unsigned regno,
 		break;
 
 	default:
+		pm_runtime_put_sync(sfb->dev);
 		return 1;	/* unknown type */
 	}
 
+	pm_runtime_put_sync(sfb->dev);
 	return 0;
 }
 
@@ -812,6 +820,8 @@ static int s3c_fb_blank(int blank_mode, struct fb_info *info)
 
 	dev_dbg(sfb->dev, "blank mode %d\n", blank_mode);
 
+	pm_runtime_get_sync(sfb->dev);
+
 	wincon = readl(sfb->regs + sfb->variant.wincon + (index * 4));
 
 	switch (blank_mode) {
@@ -839,6 +849,7 @@ static int s3c_fb_blank(int blank_mode, struct fb_info *info)
 	case FB_BLANK_VSYNC_SUSPEND:
 	case FB_BLANK_HSYNC_SUSPEND:
 	default:
+		pm_runtime_put_sync(sfb->dev);
 		return 1;
 	}
 
@@ -869,6 +880,8 @@ static int s3c_fb_blank(int blank_mode, struct fb_info *info)
 		shadow_protect_win(win, 0);
 	}
 
+	pm_runtime_put_sync(sfb->dev);
+
 	return 0;
 }
 
@@ -891,6 +904,8 @@ static int s3c_fb_pan_display(struct fb_var_screeninfo *var,
 	void __iomem *buf	= sfb->regs + win->index * 8;
 	unsigned int start_boff, end_boff;
 
+	pm_runtime_get_sync(sfb->dev);
+
 	/* Offset in bytes to the start of the displayed area */
 	start_boff = var->yoffset * info->fix.line_length;
 	/* X offset depends on the current bpp */
@@ -909,6 +924,7 @@ static int s3c_fb_pan_display(struct fb_var_screeninfo *var,
 			break;
 		default:
 			dev_err(sfb->dev, "invalid bpp\n");
+			pm_runtime_put_sync(sfb->dev);
 			return -EINVAL;
 		}
 	}
@@ -924,6 +940,7 @@ static int s3c_fb_pan_display(struct fb_var_screeninfo *var,
 
 	shadow_protect_win(win, 0);
 
+	pm_runtime_put_sync(sfb->dev);
 	return 0;
 }
 
@@ -1013,11 +1030,16 @@ static int s3c_fb_wait_for_vsync(struct s3c_fb *sfb, u32 crtc)
 	if (crtc != 0)
 		return -ENODEV;
 
+	pm_runtime_get_sync(sfb->dev);
+
 	count = sfb->vsync_info.count;
 	s3c_fb_enable_irq(sfb);
 	ret = wait_event_interruptible_timeout(sfb->vsync_info.wait,
 				       count != sfb->vsync_info.count,
 				       msecs_to_jiffies(VSYNC_TIMEOUT_MSEC));
+
+	pm_runtime_put_sync(sfb->dev);
+
 	if (ret == 0)
 		return -ETIMEDOUT;
 
-- 
1.7.7.3

