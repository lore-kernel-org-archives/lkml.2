Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754176Ab2BNFwJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 00:52:09 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:50389 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752580Ab2BNFwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 00:52:03 -0500
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX1+AwVx1yemAmWP/TQT0o4Fs/UAdZ8Uk9VvDpZSfci
	N51GmBUTI8BYJr
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [PATCH 4/4] viafb: make SAMM to also work on LCD
Date: Tue, 14 Feb 2012 06:12:05 +0000
Message-Id: <4e5527c9d1f373cb7dda6eec3af1d7b9659cdf85.1329194838.git.FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <cover.1329194838.git.FlorianSchandinat@gmx.de>
References: <cover.1329194838.git.FlorianSchandinat@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enables LCD to handle SAMM without dual fb.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
---
 drivers/video/via/chip.h |    2 --
 drivers/video/via/hw.c   |   27 +++++++++++----------------
 drivers/video/via/lcd.c  |   18 +++++++++---------
 drivers/video/via/lcd.h  |    3 ++-
 4 files changed, 22 insertions(+), 28 deletions(-)

diff --git a/drivers/video/via/chip.h b/drivers/video/via/chip.h
index 3ebf20c..c2ecdb5 100644
--- a/drivers/video/via/chip.h
+++ b/drivers/video/via/chip.h
@@ -146,8 +146,6 @@ struct tmds_setting_information {
 
 struct lvds_setting_information {
 	int iga_path;
-	int h_active;
-	int v_active;
 	int bpp;
 	int lcd_panel_hres;
 	int lcd_panel_vres;
diff --git a/drivers/video/via/hw.c b/drivers/video/via/hw.c
index e8725c5..d35ced7 100644
--- a/drivers/video/via/hw.c
+++ b/drivers/video/via/hw.c
@@ -1530,11 +1530,7 @@ void viafb_update_device_setting(int hres, int vres, int bpp, int flag)
 		viaparinfo->tmds_setting_info->h_active = hres;
 		viaparinfo->tmds_setting_info->v_active = vres;
 
-		viaparinfo->lvds_setting_info->h_active = hres;
-		viaparinfo->lvds_setting_info->v_active = vres;
 		viaparinfo->lvds_setting_info->bpp = bpp;
-		viaparinfo->lvds_setting_info2->h_active = hres;
-		viaparinfo->lvds_setting_info2->v_active = vres;
 		viaparinfo->lvds_setting_info2->bpp = bpp;
 	} else {
 
@@ -1543,16 +1539,11 @@ void viafb_update_device_setting(int hres, int vres, int bpp, int flag)
 			viaparinfo->tmds_setting_info->v_active = vres;
 		}
 
-		if (viaparinfo->lvds_setting_info->iga_path == IGA2) {
-			viaparinfo->lvds_setting_info->h_active = hres;
-			viaparinfo->lvds_setting_info->v_active = vres;
+		if (viaparinfo->lvds_setting_info->iga_path == IGA2)
 			viaparinfo->lvds_setting_info->bpp = bpp;
-		}
-		if (IGA2 == viaparinfo->lvds_setting_info2->iga_path) {
-			viaparinfo->lvds_setting_info2->h_active = hres;
-			viaparinfo->lvds_setting_info2->v_active = vres;
+
+		if (IGA2 == viaparinfo->lvds_setting_info2->iga_path)
 			viaparinfo->lvds_setting_info2->bpp = bpp;
-		}
 	}
 }
 
@@ -1933,7 +1924,8 @@ int viafb_setmode(int video_bpp, int video_bpp1)
 		if (viafb_SAMM_ON &&
 			(viaparinfo->lvds_setting_info->iga_path == IGA2)) {
 			viaparinfo->lvds_setting_info->bpp = video_bpp1;
-			viafb_lcd_set_mode(viaparinfo->lvds_setting_info,
+			viafb_lcd_set_mode(&var2, cxres, cyres,
+				viaparinfo->lvds_setting_info,
 				&viaparinfo->chip_info->lvds_chip_info);
 		} else {
 			/* IGA1 doesn't have LCD scaling, so set it center. */
@@ -1942,7 +1934,8 @@ int viafb_setmode(int video_bpp, int video_bpp1)
 				    LCD_CENTERING;
 			}
 			viaparinfo->lvds_setting_info->bpp = video_bpp;
-			viafb_lcd_set_mode(viaparinfo->lvds_setting_info,
+			viafb_lcd_set_mode(&viafbinfo->var, 0, 0,
+				viaparinfo->lvds_setting_info,
 				&viaparinfo->chip_info->lvds_chip_info);
 		}
 	}
@@ -1950,7 +1943,8 @@ int viafb_setmode(int video_bpp, int video_bpp1)
 		if (viafb_SAMM_ON &&
 			(viaparinfo->lvds_setting_info2->iga_path == IGA2)) {
 			viaparinfo->lvds_setting_info2->bpp = video_bpp1;
-			viafb_lcd_set_mode(viaparinfo->lvds_setting_info2,
+			viafb_lcd_set_mode(&var2, cxres, cyres,
+				viaparinfo->lvds_setting_info2,
 				&viaparinfo->chip_info->lvds_chip_info2);
 		} else {
 			/* IGA1 doesn't have LCD scaling, so set it center. */
@@ -1959,7 +1953,8 @@ int viafb_setmode(int video_bpp, int video_bpp1)
 				    LCD_CENTERING;
 			}
 			viaparinfo->lvds_setting_info2->bpp = video_bpp;
-			viafb_lcd_set_mode(viaparinfo->lvds_setting_info2,
+			viafb_lcd_set_mode(&viafbinfo->var, 0, 0,
+				viaparinfo->lvds_setting_info2,
 				&viaparinfo->chip_info->lvds_chip_info2);
 		}
 	}
diff --git a/drivers/video/via/lcd.c b/drivers/video/via/lcd.c
index 5f3b4e3..02cfdc8 100644
--- a/drivers/video/via/lcd.c
+++ b/drivers/video/via/lcd.c
@@ -55,8 +55,7 @@ static void load_lcd_scaling(int set_hres, int set_vres, int panel_hres,
 		      int panel_vres);
 static void via_pitch_alignment_patch_lcd(
 	struct lvds_setting_information *plvds_setting_info,
-				   struct lvds_chip_information
-				   *plvds_chip_info);
+	struct lvds_chip_information *plvds_chip_info, int hres);
 static void lcd_patch_skew_dvp0(struct lvds_setting_information
 			 *plvds_setting_info,
 			 struct lvds_chip_information *plvds_chip_info);
@@ -456,14 +455,13 @@ static void load_lcd_scaling(int set_hres, int set_vres, int panel_hres,
 
 static void via_pitch_alignment_patch_lcd(
 	struct lvds_setting_information *plvds_setting_info,
-				   struct lvds_chip_information
-				   *plvds_chip_info)
+	struct lvds_chip_information *plvds_chip_info, int hres)
 {
 	unsigned char cr13, cr35, cr65, cr66, cr67;
 	unsigned long dwScreenPitch = 0;
 	unsigned long dwPitch;
 
-	dwPitch = plvds_setting_info->h_active * (plvds_setting_info->bpp >> 3);
+	dwPitch = hres * (plvds_setting_info->bpp >> 3);
 	if (dwPitch & 0x1F) {
 		dwScreenPitch = ((dwPitch + 31) & ~31) >> 3;
 		if (plvds_setting_info->iga_path == IGA2) {
@@ -548,13 +546,14 @@ static void lcd_patch_skew(struct lvds_setting_information
 }
 
 /* LCD Set Mode */
-void viafb_lcd_set_mode(struct lvds_setting_information *plvds_setting_info,
+void viafb_lcd_set_mode(const struct fb_var_screeninfo *var, u16 cxres,
+	u16 cyres, struct lvds_setting_information *plvds_setting_info,
 	struct lvds_chip_information *plvds_chip_info)
 {
 	int set_iga = plvds_setting_info->iga_path;
 	int mode_bpp = plvds_setting_info->bpp;
-	int set_hres = plvds_setting_info->h_active;
-	int set_vres = plvds_setting_info->v_active;
+	int set_hres = cxres ? cxres : var->xres;
+	int set_vres = cyres ? cyres : var->yres;
 	int panel_hres = plvds_setting_info->lcd_panel_hres;
 	int panel_vres = plvds_setting_info->lcd_panel_vres;
 	u32 clock;
@@ -613,7 +612,8 @@ void viafb_lcd_set_mode(struct lvds_setting_information *plvds_setting_info,
 		viafb_write_reg_mask(CR6A, VIACR, 0x01, BIT0);
 
 	/* Patch for non 32bit alignment mode */
-	via_pitch_alignment_patch_lcd(plvds_setting_info, plvds_chip_info);
+	via_pitch_alignment_patch_lcd(plvds_setting_info, plvds_chip_info,
+		set_hres);
 }
 
 static void integrated_lvds_disable(struct lvds_setting_information
diff --git a/drivers/video/via/lcd.h b/drivers/video/via/lcd.h
index 77ca7b8..8f3e4e0 100644
--- a/drivers/video/via/lcd.h
+++ b/drivers/video/via/lcd.h
@@ -76,7 +76,8 @@ void __devinit viafb_init_lvds_output_interface(struct lvds_chip_information
 				*plvds_chip_info,
 				struct lvds_setting_information
 				*plvds_setting_info);
-void viafb_lcd_set_mode(struct lvds_setting_information *plvds_setting_info,
+void viafb_lcd_set_mode(const struct fb_var_screeninfo *var, u16 cxres,
+	u16 cyres, struct lvds_setting_information *plvds_setting_info,
 	struct lvds_chip_information *plvds_chip_info);
 bool __devinit viafb_lvds_trasmitter_identify(void);
 void viafb_init_lvds_output_interface(struct lvds_chip_information
-- 
1.7.9

