Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753662Ab3AGFFI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 00:05:08 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:38948 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751607Ab3AGFFD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 00:05:03 -0500
From: Afzal Mohammed <afzal@ti.com>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, <nsekhar@ti.com>,
        <hvaibhav@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-fbdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>
Subject: [PATCH v2 07/10] video: da8xx-fb: pix clk and clk div handling cleanup
Date: Mon, 7 Jan 2013 10:35:48 +0530
Message-ID: <b0199c685c51f36665c7e34bc64bdf0ebc705ba3.1357303978.git.afzal@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1357303978.git.afzal@ti.com>
References: <cover.1357303978.git.afzal@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the new modedb field to store pix clk. Reorganize existing clock
divider functions with names now corresponding to what they do, add
common function prefix.

Fix existing panel modedb pixclock to be in ps instead of Hz. This
needed a change in the way clock divider is calculated. As modedb
pixclock information is now in ps, override on "var" pixclock over
modedb to var conversion is removed.

Signed-off-by: Afzal Mohammed <afzal@ti.com>
---
 drivers/video/da8xx-fb.c |   48 +++++++++++++++++-----------------------------
 1 file changed, 18 insertions(+), 30 deletions(-)

diff --git a/drivers/video/da8xx-fb.c b/drivers/video/da8xx-fb.c
index e858438..19ee560 100644
--- a/drivers/video/da8xx-fb.c
+++ b/drivers/video/da8xx-fb.c
@@ -164,7 +164,6 @@ struct da8xx_fb_par {
 	struct clk *lcdc_clk;
 	int irq;
 	unsigned int palette_sz;
-	unsigned int pxl_clk;
 	int blank;
 	wait_queue_head_t	vsync_wait;
 	int			vsync_flag;
@@ -205,7 +204,7 @@ static struct fb_videomode known_lcd_panels[] = {
 		.name           = "Sharp_LCD035Q3DG01",
 		.xres           = 320,
 		.yres           = 240,
-		.pixclock       = 4608000,
+		.pixclock       = 217014,
 		.left_margin    = 6,
 		.right_margin   = 8,
 		.upper_margin   = 2,
@@ -220,7 +219,7 @@ static struct fb_videomode known_lcd_panels[] = {
 		.name           = "Sharp_LK043T1DG01",
 		.xres           = 480,
 		.yres           = 272,
-		.pixclock       = 7833600,
+		.pixclock       = 127655,
 		.left_margin    = 2,
 		.right_margin   = 2,
 		.upper_margin   = 2,
@@ -235,7 +234,7 @@ static struct fb_videomode known_lcd_panels[] = {
 		.name           = "SP10Q010",
 		.xres           = 320,
 		.yres           = 240,
-		.pixclock       = 7833600,
+		.pixclock       = 127655,
 		.left_margin    = 10,
 		.right_margin   = 10,
 		.upper_margin   = 10,
@@ -684,13 +683,14 @@ static void da8xx_fb_lcd_reset(void)
 	}
 }
 
-static void lcd_calc_clk_divider(struct da8xx_fb_par *par)
+static inline unsigned da8xx_fb_calc_clk_divider(struct da8xx_fb_par *par,
+						 unsigned pixclock)
 {
-	unsigned int lcd_clk, div;
-
-	lcd_clk = clk_get_rate(par->lcdc_clk);
-	div = lcd_clk / par->pxl_clk;
+	return par->lcd_fck_rate / (PICOS2KHZ(pixclock) * 1000);
+}
 
+static inline void da8xx_fb_config_clk_divider(unsigned div)
+{
 	/* Configure the LCD clock divisor. */
 	lcdc_write(LCD_CLK_DIVISOR(div) |
 			(LCD_RASTER_MODE & 0x1), LCD_CTRL_REG);
@@ -698,7 +698,14 @@ static void lcd_calc_clk_divider(struct da8xx_fb_par *par)
 	if (lcd_revision == LCD_VERSION_2)
 		lcdc_write(LCD_V2_DMA_CLK_EN | LCD_V2_LIDD_CLK_EN |
 				LCD_V2_CORE_CLK_EN, LCD_CLK_ENABLE_REG);
+}
+
+static inline void da8xx_fb_calc_config_clk_divider(struct da8xx_fb_par *par,
+						    struct fb_videomode *mode)
+{
+	unsigned div = da8xx_fb_calc_clk_divider(par, mode->pixclock);
 
+	da8xx_fb_config_clk_divider(div);
 }
 
 static int lcd_init(struct da8xx_fb_par *par, const struct lcd_ctrl_config *cfg,
@@ -709,8 +716,7 @@ static int lcd_init(struct da8xx_fb_par *par, const struct lcd_ctrl_config *cfg,
 
 	da8xx_fb_lcd_reset();
 
-	/* Calculate the divider */
-	lcd_calc_clk_divider(par);
+	da8xx_fb_calc_config_clk_divider(par, panel);
 
 	if (panel->sync & FB_SYNC_CLK_INVERT)
 		lcdc_write((lcdc_read(LCD_RASTER_TIMING_2_REG) |
@@ -973,7 +979,7 @@ static int lcd_da8xx_cpufreq_transition(struct notifier_block *nb,
 		if (par->lcd_fck_rate != clk_get_rate(par->lcdc_clk)) {
 			par->lcd_fck_rate = clk_get_rate(par->lcdc_clk);
 			lcd_disable_raster(true);
-			lcd_calc_clk_divider(par);
+			da8xx_fb_calc_config_clk_divider(par, &par->mode);
 			if (par->blank == FB_BLANK_UNBLANK)
 				lcd_enable_raster();
 		}
@@ -1199,22 +1205,6 @@ static struct fb_ops da8xx_fb_ops = {
 	.fb_blank = cfb_blank,
 };
 
-/* Calculate and return pixel clock period in pico seconds */
-static unsigned int da8xxfb_pixel_clk_period(struct da8xx_fb_par *par)
-{
-	unsigned int lcd_clk, div;
-	unsigned int configured_pix_clk;
-	unsigned long long pix_clk_period_picosec = 1000000000000ULL;
-
-	lcd_clk = clk_get_rate(par->lcdc_clk);
-	div = lcd_clk / par->pxl_clk;
-	configured_pix_clk = (lcd_clk / div);
-
-	do_div(pix_clk_period_picosec, configured_pix_clk);
-
-	return pix_clk_period_picosec;
-}
-
 static int __devinit fb_probe(struct platform_device *device)
 {
 	struct da8xx_lcdc_platform_data *fb_pdata =
@@ -1307,7 +1297,6 @@ static int __devinit fb_probe(struct platform_device *device)
 	par = da8xx_fb_info->par;
 	par->lcdc_clk = fb_clk;
 	par->lcd_fck_rate = clk_get_rate(fb_clk);
-	par->pxl_clk = lcdc_info->pixclock;
 	if (fb_pdata->panel_power_ctrl) {
 		par->panel_power_ctrl = fb_pdata->panel_power_ctrl;
 		par->panel_power_ctrl(1);
@@ -1372,7 +1361,6 @@ static int __devinit fb_probe(struct platform_device *device)
 	da8xx_fb_var.grayscale =
 	    lcd_cfg->panel_shade == MONOCHROME ? 1 : 0;
 	da8xx_fb_var.bits_per_pixel = lcd_cfg->bpp;
-	da8xx_fb_var.pixclock = da8xxfb_pixel_clk_period(par);
 
 	/* Initialize fbinfo */
 	da8xx_fb_info->flags = FBINFO_FLAG_DEFAULT;
-- 
1.7.9.5

