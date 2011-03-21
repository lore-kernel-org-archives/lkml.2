Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754826Ab1CUWqJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 18:46:09 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:44172 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754788Ab1CUWqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 18:46:05 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX18fcYgrJz0fTQBIOAq5LAEcnizbMzcoUMs9SFwHXA
	LOFKhwGtzaaX09
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [PATCH 1/2] viafb: refresh rate bug collection
Date: Mon, 21 Mar 2011 23:01:26 +0000
Message-Id: <1300748487-9883-2-git-send-email-FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <1300748487-9883-1-git-send-email-FlorianSchandinat@gmx.de>
References: <1300748487-9883-1-git-send-email-FlorianSchandinat@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes multiple issues with the handling of refresh rates
especially for multi-display setups. If you experienced problems
with wrong refresh rates this patch might fix them.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
---
 drivers/video/via/chip.h     |    1 -
 drivers/video/via/hw.c       |   17 ++++++---------
 drivers/video/via/hw.h       |    3 +-
 drivers/video/via/viafbdev.c |   45 ++++++++++++++++++++++++++---------------
 4 files changed, 36 insertions(+), 30 deletions(-)

diff --git a/drivers/video/via/chip.h b/drivers/video/via/chip.h
index 781f3aa..29d7024 100644
--- a/drivers/video/via/chip.h
+++ b/drivers/video/via/chip.h
@@ -139,7 +139,6 @@ struct chip_information {
 
 struct crt_setting_information {
 	int iga_path;
-	int refresh_rate;
 };
 
 struct tmds_setting_information {
diff --git a/drivers/video/via/hw.c b/drivers/video/via/hw.c
index 5728fd7..dc4c778 100644
--- a/drivers/video/via/hw.c
+++ b/drivers/video/via/hw.c
@@ -2002,13 +2002,15 @@ void viafb_fill_crtc_timing(struct crt_mode_table *crt_table,
 	int i;
 	int index = 0;
 	int h_addr, v_addr;
-	u32 pll_D_N, clock;
+	u32 pll_D_N, clock, refresh = viafb_refresh;
+
+	if (viafb_SAMM_ON && set_iga == IGA2)
+		refresh = viafb_refresh1;
 
 	for (i = 0; i < video_mode->mode_array; i++) {
 		index = i;
 
-		if (crt_table[i].refresh_rate == viaparinfo->
-			crt_setting_info->refresh_rate)
+		if (crt_table[i].refresh_rate == refresh)
 			break;
 	}
 
@@ -2019,7 +2021,7 @@ void viafb_fill_crtc_timing(struct crt_mode_table *crt_table,
 	if ((viafb_LCD_ON | viafb_DVI_ON)
 	    && video_mode->crtc[0].crtc.hor_addr == 640
 	    && video_mode->crtc[0].crtc.ver_addr == 480
-	    && viaparinfo->crt_setting_info->refresh_rate == 60) {
+	    && refresh == 60) {
 		/* The border is 8 pixels. */
 		crt_reg.hor_blank_start = crt_reg.hor_blank_start - 8;
 
@@ -2070,7 +2072,6 @@ void __devinit viafb_init_chip_info(int chip_type)
 	init_lvds_chip_info();
 
 	viaparinfo->crt_setting_info->iga_path = IGA1;
-	viaparinfo->crt_setting_info->refresh_rate = viafb_refresh;
 
 	/*Set IGA path for each device */
 	viafb_set_iga_path();
@@ -2083,13 +2084,9 @@ void __devinit viafb_init_chip_info(int chip_type)
 		viaparinfo->lvds_setting_info->lcd_mode;
 }
 
-void viafb_update_device_setting(int hres, int vres,
-	int bpp, int vmode_refresh, int flag)
+void viafb_update_device_setting(int hres, int vres, int bpp, int flag)
 {
 	if (flag == 0) {
-		viaparinfo->crt_setting_info->refresh_rate =
-			vmode_refresh;
-
 		viaparinfo->tmds_setting_info->h_active = hres;
 		viaparinfo->tmds_setting_info->v_active = vres;
 
diff --git a/drivers/video/via/hw.h b/drivers/video/via/hw.h
index 7295263..8858593 100644
--- a/drivers/video/via/hw.h
+++ b/drivers/video/via/hw.h
@@ -949,8 +949,7 @@ void __devinit viafb_init_chip_info(int chip_type);
 void __devinit viafb_init_dac(int set_iga);
 int viafb_get_pixclock(int hres, int vres, int vmode_refresh);
 int viafb_get_refresh(int hres, int vres, u32 float_refresh);
-void viafb_update_device_setting(int hres, int vres, int bpp,
-			   int vmode_refresh, int flag);
+void viafb_update_device_setting(int hres, int vres, int bpp, int flag);
 
 void viafb_set_iga_path(void);
 void viafb_set_primary_color_register(u8 index, u8 red, u8 green, u8 blue);
diff --git a/drivers/video/via/viafbdev.c b/drivers/video/via/viafbdev.c
index f555b89..fd6a15f 100644
--- a/drivers/video/via/viafbdev.c
+++ b/drivers/video/via/viafbdev.c
@@ -182,13 +182,24 @@ static int viafb_release(struct fb_info *info, int user)
 	return 0;
 }
 
+static inline int get_var_refresh(struct fb_var_screeninfo *var)
+{
+	u32 htotal, vtotal;
+
+	htotal = var->left_margin + var->xres + var->right_margin
+		+ var->hsync_len;
+	vtotal = var->upper_margin + var->yres + var->lower_margin
+		+ var->vsync_len;
+	return PICOS2KHZ(var->pixclock) * 1000 / (htotal * vtotal);
+}
+
 static int viafb_check_var(struct fb_var_screeninfo *var,
 	struct fb_info *info)
 {
-	int htotal, vtotal, depth;
+	int depth, refresh;
 	struct VideoModeTable *vmode_entry;
 	struct viafb_par *ppar = info->par;
-	u32 long_refresh, line;
+	u32 line;
 
 	DEBUG_MSG(KERN_INFO "viafb_check_var!\n");
 	/* Sanity check */
@@ -231,17 +242,11 @@ static int viafb_check_var(struct fb_var_screeninfo *var,
 	/* Based on var passed in to calculate the refresh,
 	 * because our driver use some modes special.
 	 */
-	htotal = var->xres + var->left_margin +
-	var->right_margin + var->hsync_len;
-	vtotal = var->yres + var->upper_margin +
-		var->lower_margin + var->vsync_len;
-	long_refresh = 1000000000UL / var->pixclock * 1000;
-	long_refresh /= (htotal * vtotal);
-
-	viafb_refresh = viafb_get_refresh(var->xres, var->yres, long_refresh);
+	refresh = viafb_get_refresh(var->xres, var->yres,
+		get_var_refresh(var));
 
 	/* Adjust var according to our driver's own table */
-	viafb_fill_var_timing_info(var, viafb_refresh, vmode_entry);
+	viafb_fill_var_timing_info(var, refresh, vmode_entry);
 	if (var->accel_flags & FB_ACCELF_TEXT &&
 		!ppar->shared->vdev->engine_mmio)
 		var->accel_flags = 0;
@@ -253,12 +258,13 @@ static int viafb_set_par(struct fb_info *info)
 {
 	struct viafb_par *viapar = info->par;
 	struct VideoModeTable *vmode_entry, *vmode_entry1 = NULL;
+	int refresh;
 	DEBUG_MSG(KERN_INFO "viafb_set_par!\n");
 
 	viafb_update_fix(info);
 	viapar->depth = fb_get_color_depth(&info->var, &info->fix);
 	viafb_update_device_setting(viafbinfo->var.xres, viafbinfo->var.yres,
-		viafbinfo->var.bits_per_pixel, viafb_refresh, 0);
+		viafbinfo->var.bits_per_pixel, 0);
 
 	vmode_entry = viafb_get_mode(viafbinfo->var.xres, viafbinfo->var.yres);
 	if (viafb_dual_fb) {
@@ -266,7 +272,7 @@ static int viafb_set_par(struct fb_info *info)
 			viafbinfo1->var.yres);
 		viafb_update_device_setting(viafbinfo1->var.xres,
 			viafbinfo1->var.yres, viafbinfo1->var.bits_per_pixel,
-			viafb_refresh1, 1);
+			1);
 	} else if (viafb_SAMM_ON == 1) {
 		DEBUG_MSG(KERN_INFO
 		"viafb_second_xres = %d, viafb_second_yres = %d, bpp = %d\n",
@@ -275,14 +281,19 @@ static int viafb_set_par(struct fb_info *info)
 			viafb_second_yres);
 
 		viafb_update_device_setting(viafb_second_xres,
-			viafb_second_yres, viafb_bpp1, viafb_refresh1, 1);
+			viafb_second_yres, viafb_bpp1, 1);
 	}
 
+	refresh = viafb_get_refresh(info->var.xres, info->var.yres,
+		get_var_refresh(&info->var));
 	if (vmode_entry) {
-		if (viafb_dual_fb && viapar->iga_path == IGA2)
+		if (viafb_dual_fb && viapar->iga_path == IGA2) {
 			viafb_bpp1 = info->var.bits_per_pixel;
-		else
+			viafb_refresh1 = refresh;
+		} else {
 			viafb_bpp = info->var.bits_per_pixel;
+			viafb_refresh = refresh;
+		}
 
 		if (info->var.accel_flags & FB_ACCELF_TEXT)
 			info->flags &= ~FBINFO_HWACCEL_DISABLED;
@@ -1843,7 +1854,7 @@ int __devinit via_fb_pci_probe(struct viafb_dev *vdev)
 		default_var.bits_per_pixel = viafb_bpp1;
 		default_var.pixclock =
 		    viafb_get_pixclock(viafb_second_xres, viafb_second_yres,
-		    viafb_refresh);
+		    viafb_refresh1);
 		default_var.left_margin = (viafb_second_xres >> 3) & 0xf8;
 		default_var.right_margin = 32;
 		default_var.upper_margin = 16;
-- 
1.6.3.2

