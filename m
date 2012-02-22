Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755202Ab2BVSeI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 13:34:08 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:40374 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754088Ab2BVSeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 13:34:05 -0500
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX18hHIlI9och9E4fn0IpQH+nzrGMwQrRfcpHYSjSJy
	oGRVtp1jAFu8+P
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [PATCH 5/5] viafb: LCD bpp cleanup
Date: Wed, 22 Feb 2012 18:53:09 +0000
Message-Id: <7af2b6dae2cb46e3698a343cde9bc6c60c297b2a.1329936280.git.FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <cover.1329936280.git.FlorianSchandinat@gmx.de>
References: <cover.1329936280.git.FlorianSchandinat@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes redundant bits per pixel information by using the
one storged in var directly. Simplifies code without any functional
changes.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
---
 drivers/video/via/chip.h     |    1 -
 drivers/video/via/hw.c       |   16 ++--------------
 drivers/video/via/hw.h       |    2 +-
 drivers/video/via/lcd.c      |   21 ++++++++-------------
 drivers/video/via/viafbdev.c |    2 +-
 5 files changed, 12 insertions(+), 30 deletions(-)

diff --git a/drivers/video/via/chip.h b/drivers/video/via/chip.h
index c2ecdb5..d32a507 100644
--- a/drivers/video/via/chip.h
+++ b/drivers/video/via/chip.h
@@ -146,7 +146,6 @@ struct tmds_setting_information {
 
 struct lvds_setting_information {
 	int iga_path;
-	int bpp;
 	int lcd_panel_hres;
 	int lcd_panel_vres;
 	int display_method;
diff --git a/drivers/video/via/hw.c b/drivers/video/via/hw.c
index 376af05..411b7e9 100644
--- a/drivers/video/via/hw.c
+++ b/drivers/video/via/hw.c
@@ -1529,9 +1529,6 @@ void viafb_update_device_setting(int hres, int vres, int bpp, int flag)
 	if (flag == 0) {
 		viaparinfo->tmds_setting_info->h_active = hres;
 		viaparinfo->tmds_setting_info->v_active = vres;
-
-		viaparinfo->lvds_setting_info->bpp = bpp;
-		viaparinfo->lvds_setting_info2->bpp = bpp;
 	} else {
 
 		if (viaparinfo->tmds_setting_info->iga_path == IGA2) {
@@ -1539,11 +1536,6 @@ void viafb_update_device_setting(int hres, int vres, int bpp, int flag)
 			viaparinfo->tmds_setting_info->v_active = vres;
 		}
 
-		if (viaparinfo->lvds_setting_info->iga_path == IGA2)
-			viaparinfo->lvds_setting_info->bpp = bpp;
-
-		if (IGA2 == viaparinfo->lvds_setting_info2->iga_path)
-			viaparinfo->lvds_setting_info2->bpp = bpp;
 	}
 }
 
@@ -1838,7 +1830,7 @@ static void hw_init(void)
 	load_fix_bit_crtc_reg();
 }
 
-int viafb_setmode(int video_bpp, int video_bpp1)
+int viafb_setmode(void)
 {
 	int j, cxres = 0, cyres = 0;
 	int port;
@@ -1927,7 +1919,6 @@ int viafb_setmode(int video_bpp, int video_bpp1)
 	if (viafb_LCD_ON) {
 		if (viafb_SAMM_ON &&
 			(viaparinfo->lvds_setting_info->iga_path == IGA2)) {
-			viaparinfo->lvds_setting_info->bpp = video_bpp1;
 			viafb_lcd_set_mode(&var2, cxres, cyres,
 				viaparinfo->lvds_setting_info,
 				&viaparinfo->chip_info->lvds_chip_info);
@@ -1937,7 +1928,6 @@ int viafb_setmode(int video_bpp, int video_bpp1)
 				viaparinfo->lvds_setting_info->display_method =
 				    LCD_CENTERING;
 			}
-			viaparinfo->lvds_setting_info->bpp = video_bpp;
 			viafb_lcd_set_mode(&viafbinfo->var, 0, 0,
 				viaparinfo->lvds_setting_info,
 				&viaparinfo->chip_info->lvds_chip_info);
@@ -1946,7 +1936,6 @@ int viafb_setmode(int video_bpp, int video_bpp1)
 	if (viafb_LCD2_ON) {
 		if (viafb_SAMM_ON &&
 			(viaparinfo->lvds_setting_info2->iga_path == IGA2)) {
-			viaparinfo->lvds_setting_info2->bpp = video_bpp1;
 			viafb_lcd_set_mode(&var2, cxres, cyres,
 				viaparinfo->lvds_setting_info2,
 				&viaparinfo->chip_info->lvds_chip_info2);
@@ -1956,7 +1945,6 @@ int viafb_setmode(int video_bpp, int video_bpp1)
 				viaparinfo->lvds_setting_info2->display_method =
 				    LCD_CENTERING;
 			}
-			viaparinfo->lvds_setting_info2->bpp = video_bpp;
 			viafb_lcd_set_mode(&viafbinfo->var, 0, 0,
 				viaparinfo->lvds_setting_info2,
 				&viaparinfo->chip_info->lvds_chip_info2);
@@ -1971,7 +1959,7 @@ int viafb_setmode(int video_bpp, int video_bpp1)
 	if (!viafb_hotplug) {
 		viafb_hotplug_Xres = viafbinfo->var.xres;
 		viafb_hotplug_Yres = viafbinfo->var.yres;
-		viafb_hotplug_bpp = video_bpp;
+		viafb_hotplug_bpp = viafbinfo->var.bits_per_pixel;
 		viafb_hotplug_refresh = viafb_refresh;
 
 		if (viafb_DVI_ON)
diff --git a/drivers/video/via/hw.h b/drivers/video/via/hw.h
index f8129e4..cacedc1 100644
--- a/drivers/video/via/hw.h
+++ b/drivers/video/via/hw.h
@@ -658,7 +658,7 @@ void viafb_load_FIFO_reg(int set_iga, int hor_active, int ver_active);
 void viafb_set_dpa_gfx(int output_interface, struct GFX_DPA_SETTING\
 					*p_gfx_dpa_setting);
 
-int viafb_setmode(int video_bpp, int video_bpp1);
+int viafb_setmode(void);
 void viafb_fill_var_timing_info(struct fb_var_screeninfo *var,
 	struct crt_mode_table *mode);
 void __devinit viafb_init_chip_info(int chip_type);
diff --git a/drivers/video/via/lcd.c b/drivers/video/via/lcd.c
index 02cfdc8..6e52711 100644
--- a/drivers/video/via/lcd.c
+++ b/drivers/video/via/lcd.c
@@ -53,9 +53,6 @@ static void __devinit fp_id_to_vindex(int panel_id);
 static int lvds_register_read(int index);
 static void load_lcd_scaling(int set_hres, int set_vres, int panel_hres,
 		      int panel_vres);
-static void via_pitch_alignment_patch_lcd(
-	struct lvds_setting_information *plvds_setting_info,
-	struct lvds_chip_information *plvds_chip_info, int hres);
 static void lcd_patch_skew_dvp0(struct lvds_setting_information
 			 *plvds_setting_info,
 			 struct lvds_chip_information *plvds_chip_info);
@@ -453,19 +450,17 @@ static void load_lcd_scaling(int set_hres, int set_vres, int panel_hres,
 	}
 }
 
-static void via_pitch_alignment_patch_lcd(
-	struct lvds_setting_information *plvds_setting_info,
-	struct lvds_chip_information *plvds_chip_info, int hres)
+static void via_pitch_alignment_patch_lcd(int iga_path, int hres, int bpp)
 {
 	unsigned char cr13, cr35, cr65, cr66, cr67;
 	unsigned long dwScreenPitch = 0;
 	unsigned long dwPitch;
 
-	dwPitch = hres * (plvds_setting_info->bpp >> 3);
+	dwPitch = hres * (bpp >> 3);
 	if (dwPitch & 0x1F) {
 		dwScreenPitch = ((dwPitch + 31) & ~31) >> 3;
-		if (plvds_setting_info->iga_path == IGA2) {
-			if (plvds_setting_info->bpp > 8) {
+		if (iga_path == IGA2) {
+			if (bpp > 8) {
 				cr66 = (unsigned char)(dwScreenPitch & 0xFF);
 				viafb_write_reg(CR66, VIACR, cr66);
 				cr67 = viafb_read_reg(VIACR, CR67) & 0xFC;
@@ -483,7 +478,7 @@ static void via_pitch_alignment_patch_lcd(
 			cr65 += 2;
 			viafb_write_reg(CR65, VIACR, cr65);
 		} else {
-			if (plvds_setting_info->bpp > 8) {
+			if (bpp > 8) {
 				cr13 = (unsigned char)(dwScreenPitch & 0xFF);
 				viafb_write_reg(CR13, VIACR, cr13);
 				cr35 = viafb_read_reg(VIACR, CR35) & 0x1F;
@@ -551,7 +546,7 @@ void viafb_lcd_set_mode(const struct fb_var_screeninfo *var, u16 cxres,
 	struct lvds_chip_information *plvds_chip_info)
 {
 	int set_iga = plvds_setting_info->iga_path;
-	int mode_bpp = plvds_setting_info->bpp;
+	int mode_bpp = var->bits_per_pixel;
 	int set_hres = cxres ? cxres : var->xres;
 	int set_vres = cyres ? cyres : var->yres;
 	int panel_hres = plvds_setting_info->lcd_panel_hres;
@@ -612,8 +607,8 @@ void viafb_lcd_set_mode(const struct fb_var_screeninfo *var, u16 cxres,
 		viafb_write_reg_mask(CR6A, VIACR, 0x01, BIT0);
 
 	/* Patch for non 32bit alignment mode */
-	via_pitch_alignment_patch_lcd(plvds_setting_info, plvds_chip_info,
-		set_hres);
+	via_pitch_alignment_patch_lcd(plvds_setting_info->iga_path, set_hres,
+		var->bits_per_pixel);
 }
 
 static void integrated_lvds_disable(struct lvds_setting_information
diff --git a/drivers/video/via/viafbdev.c b/drivers/video/via/viafbdev.c
index 9cfa92e..7529340 100644
--- a/drivers/video/via/viafbdev.c
+++ b/drivers/video/via/viafbdev.c
@@ -303,7 +303,7 @@ static int viafb_set_par(struct fb_info *info)
 			info->flags &= ~FBINFO_HWACCEL_DISABLED;
 		else
 			info->flags |= FBINFO_HWACCEL_DISABLED;
-		viafb_setmode(info->var.bits_per_pixel, viafb_bpp1);
+		viafb_setmode();
 		viafb_pan_display(&info->var, info);
 	}
 
-- 
1.7.9

