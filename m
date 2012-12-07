Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932668Ab2LGLol (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 06:44:41 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:42692 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932540Ab2LGLoh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 06:44:37 -0500
From: Afzal Mohammed <afzal@ti.com>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
CC: Vaibhav Hiremath <hvaibhav@ti.com>, Sekhar Nori <nsekhar@ti.com>,
        <linux-fbdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Afzal Mohammed <afzal@ti.com>
Subject: [PATCH 10/10] video: da8xx-fb: fb_set_par support
Date: Fri, 7 Dec 2012 17:14:31 +0530
Message-ID: <be3711f2c6005dc73704e6147372ea0be2466595.1354874432.git.afzal@ti.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <cover.1354874432.git.afzal@ti.com>
References: <cover.1354874432.git.afzal@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fb_set_par helps in runtime configuration of lcd controller like
changing resolution, pixel clock etc. (eg. using fbset utility)

Reconfigure lcd controller based on information passed by framework.
Enable raster back if it was already enabled.

As fb_set_par would get invoked indirectly from probe via fb_set_var,
remove existing lcdc initialization in probe and do lcdc reset in
probe so that reset happens only at the begining.

Signed-off-by: Afzal Mohammed <afzal@ti.com>
---
 drivers/video/da8xx-fb.c | 60 +++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 49 insertions(+), 11 deletions(-)

diff --git a/drivers/video/da8xx-fb.c b/drivers/video/da8xx-fb.c
index c7393f1..1293ab9 100644
--- a/drivers/video/da8xx-fb.c
+++ b/drivers/video/da8xx-fb.c
@@ -247,6 +247,11 @@ static struct fb_videomode known_lcd_panels[] = {
 	},
 };
 
+static inline bool da8xx_fb_is_raster_enabled(void)
+{
+	return !!(lcdc_read(LCD_RASTER_CTRL_REG) & LCD_RASTER_ENABLE);
+}
+
 /* Enable the Raster Engine of the LCD Controller */
 static inline void lcd_enable_raster(void)
 {
@@ -669,9 +674,6 @@ static int fb_setcolreg(unsigned regno, unsigned red, unsigned green,
 
 static void da8xx_fb_lcd_reset(void)
 {
-	/* Disable the Raster if previously Enabled */
-	lcd_disable_raster(false);
-
 	/* DMA has to be disabled */
 	lcdc_write(0, LCD_DMA_CTRL_REG);
 	lcdc_write(0, LCD_RASTER_CTRL_REG);
@@ -724,8 +726,6 @@ static int lcd_init(struct da8xx_fb_par *par, const struct lcd_ctrl_config *cfg,
 	u32 bpp;
 	int ret = 0;
 
-	da8xx_fb_lcd_reset();
-
 	da8xx_fb_calc_config_clk_divider(par, panel);
 
 	if (panel->sync & FB_SYNC_CLK_INVERT)
@@ -1205,9 +1205,52 @@ static int da8xx_pan_display(struct fb_var_screeninfo *var,
 	return ret;
 }
 
+static int da8xxfb_set_par(struct fb_info *info)
+{
+	struct da8xx_fb_par *par = info->par;
+	int ret;
+	bool raster = da8xx_fb_is_raster_enabled();
+
+	if (raster)
+		lcd_disable_raster(false);
+	else
+		lcd_disable_raster(true);
+
+	fb_var_to_videomode(&par->mode, &info->var);
+
+	par->cfg.bpp = info->var.bits_per_pixel;
+
+	info->fix.visual = (par->cfg.bpp <= 8) ?
+				FB_VISUAL_PSEUDOCOLOR : FB_VISUAL_TRUECOLOR;
+	info->fix.line_length = (par->mode.xres * par->cfg.bpp) / 8;
+
+	ret = lcd_init(par, &par->cfg, &par->mode);
+	if (ret < 0) {
+		dev_err(par->dev, "lcd init failed\n");
+		return ret;
+	}
+
+	par->dma_start = info->fix.smem_start +
+			 info->var.yoffset * info->fix.line_length +
+			 info->var.xoffset * info->var.bits_per_pixel / 8;
+	par->dma_end   = par->dma_start +
+			 info->var.yres * info->fix.line_length - 1;
+
+	lcdc_write(par->dma_start, LCD_DMA_FRM_BUF_BASE_ADDR_0_REG);
+	lcdc_write(par->dma_end, LCD_DMA_FRM_BUF_CEILING_ADDR_0_REG);
+	lcdc_write(par->dma_start, LCD_DMA_FRM_BUF_BASE_ADDR_1_REG);
+	lcdc_write(par->dma_end, LCD_DMA_FRM_BUF_CEILING_ADDR_1_REG);
+
+	if (raster)
+		lcd_enable_raster();
+
+	return 0;
+}
+
 static struct fb_ops da8xx_fb_ops = {
 	.owner = THIS_MODULE,
 	.fb_check_var = fb_check_var,
+	.fb_set_par = da8xxfb_set_par,
 	.fb_setcolreg = fb_setcolreg,
 	.fb_pan_display = da8xx_pan_display,
 	.fb_ioctl = fb_ioctl,
@@ -1316,14 +1359,9 @@ static int __devinit fb_probe(struct platform_device *device)
 	}
 
 	fb_videomode_to_var(&da8xx_fb_var, lcdc_info);
-	fb_var_to_videomode(&par->mode, &da8xx_fb_var);
 	par->cfg = *lcd_cfg;
 
-	if (lcd_init(par, lcd_cfg, lcdc_info) < 0) {
-		dev_err(&device->dev, "lcd_init failed\n");
-		ret = -EFAULT;
-		goto err_release_fb;
-	}
+	da8xx_fb_lcd_reset();
 
 	/* allocate frame buffer */
 	par->vram_size = lcdc_info->xres * lcdc_info->yres * lcd_cfg->bpp;
-- 
1.7.12

