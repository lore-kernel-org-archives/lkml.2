Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754090Ab1HGPdo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Aug 2011 11:33:44 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:59346 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753683Ab1HGPdm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Aug 2011 11:33:42 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX1/YMyt2Q4PYG8lOIcOKBVGSq/vAaCCZj1oNZ4p5IR
	1+OKA9v1uKxZdK
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [PATCH 5/6] viafb: eliminate modetable dependancy of LCD modesetting
Date: Sun,  7 Aug 2011 15:52:17 +0000
Message-Id: <bfe7d5f9396d5f2607454fd9ff89397fa3ba9a32.1312730860.git.FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <cover.1312730859.git.FlorianSchandinat@gmx.de>
References: <cover.1312730859.git.FlorianSchandinat@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the need for knowing the modetable structure
within the LCD modesetting function. The magic 60Hz refresh rate was
already there as always the first entry for a resolution was choosen
based on the ascending refresh rate ordering in the modetable.
For all but one this is at least 60Hz, if only higher frequencies
available we choose those like the code before did. The exception is
OLPC but that resolution has only one frequency so we get the same
behaviour there as well.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
---
 drivers/video/via/hw.c  |   20 ++++++++------------
 drivers/video/via/lcd.c |   12 +++++-------
 drivers/video/via/lcd.h |    5 ++---
 3 files changed, 15 insertions(+), 22 deletions(-)

diff --git a/drivers/video/via/hw.c b/drivers/video/via/hw.c
index 76fad92..30668bd 100644
--- a/drivers/video/via/hw.c
+++ b/drivers/video/via/hw.c
@@ -1937,9 +1937,8 @@ int viafb_setmode(struct VideoModeTable *vmode_tbl, int video_bpp,
 		if (viafb_SAMM_ON &&
 			(viaparinfo->lvds_setting_info->iga_path == IGA2)) {
 			viaparinfo->lvds_setting_info->bpp = video_bpp1;
-			viafb_lcd_set_mode(crt_timing1, viaparinfo->
-				lvds_setting_info,
-				     &viaparinfo->chip_info->lvds_chip_info);
+			viafb_lcd_set_mode(viaparinfo->lvds_setting_info,
+				&viaparinfo->chip_info->lvds_chip_info);
 		} else {
 			/* IGA1 doesn't have LCD scaling, so set it center. */
 			if (viaparinfo->lvds_setting_info->iga_path == IGA1) {
@@ -1947,18 +1946,16 @@ int viafb_setmode(struct VideoModeTable *vmode_tbl, int video_bpp,
 				    LCD_CENTERING;
 			}
 			viaparinfo->lvds_setting_info->bpp = video_bpp;
-			viafb_lcd_set_mode(crt_timing, viaparinfo->
-				lvds_setting_info,
-				     &viaparinfo->chip_info->lvds_chip_info);
+			viafb_lcd_set_mode(viaparinfo->lvds_setting_info,
+				&viaparinfo->chip_info->lvds_chip_info);
 		}
 	}
 	if (viafb_LCD2_ON) {
 		if (viafb_SAMM_ON &&
 			(viaparinfo->lvds_setting_info2->iga_path == IGA2)) {
 			viaparinfo->lvds_setting_info2->bpp = video_bpp1;
-			viafb_lcd_set_mode(crt_timing1, viaparinfo->
-				lvds_setting_info2,
-				     &viaparinfo->chip_info->lvds_chip_info2);
+			viafb_lcd_set_mode(viaparinfo->lvds_setting_info2,
+				&viaparinfo->chip_info->lvds_chip_info2);
 		} else {
 			/* IGA1 doesn't have LCD scaling, so set it center. */
 			if (viaparinfo->lvds_setting_info2->iga_path == IGA1) {
@@ -1966,9 +1963,8 @@ int viafb_setmode(struct VideoModeTable *vmode_tbl, int video_bpp,
 				    LCD_CENTERING;
 			}
 			viaparinfo->lvds_setting_info2->bpp = video_bpp;
-			viafb_lcd_set_mode(crt_timing, viaparinfo->
-				lvds_setting_info2,
-				     &viaparinfo->chip_info->lvds_chip_info2);
+			viafb_lcd_set_mode(viaparinfo->lvds_setting_info2,
+				&viaparinfo->chip_info->lvds_chip_info2);
 		}
 	}
 
diff --git a/drivers/video/via/lcd.c b/drivers/video/via/lcd.c
index 0a38e4d..5f3b4e3 100644
--- a/drivers/video/via/lcd.c
+++ b/drivers/video/via/lcd.c
@@ -548,9 +548,8 @@ static void lcd_patch_skew(struct lvds_setting_information
 }
 
 /* LCD Set Mode */
-void viafb_lcd_set_mode(struct crt_mode_table *mode_crt_table,
-		  struct lvds_setting_information *plvds_setting_info,
-		  struct lvds_chip_information *plvds_chip_info)
+void viafb_lcd_set_mode(struct lvds_setting_information *plvds_setting_info,
+	struct lvds_chip_information *plvds_chip_info)
 {
 	int set_iga = plvds_setting_info->iga_path;
 	int mode_bpp = plvds_setting_info->bpp;
@@ -560,15 +559,14 @@ void viafb_lcd_set_mode(struct crt_mode_table *mode_crt_table,
 	int panel_vres = plvds_setting_info->lcd_panel_vres;
 	u32 clock;
 	struct display_timing mode_crt_reg, panel_crt_reg, timing;
-	struct crt_mode_table *panel_crt_table = NULL;
-	struct VideoModeTable *vmode_tbl = viafb_get_mode(panel_hres,
-		panel_vres);
+	struct crt_mode_table *mode_crt_table, *panel_crt_table;
 
 	DEBUG_MSG(KERN_INFO "viafb_lcd_set_mode!!\n");
 	/* Get mode table */
+	mode_crt_table = viafb_get_best_mode(set_hres, set_vres, 60);
 	mode_crt_reg = mode_crt_table->crtc;
 	/* Get panel table Pointer */
-	panel_crt_table = vmode_tbl->crtc;
+	panel_crt_table = viafb_get_best_mode(panel_hres, panel_vres, 60);
 	panel_crt_reg = panel_crt_table->crtc;
 	DEBUG_MSG(KERN_INFO "bellow viafb_lcd_set_mode!!\n");
 	if (VT1636_LVDS == plvds_chip_info->lvds_chip_name)
diff --git a/drivers/video/via/lcd.h b/drivers/video/via/lcd.h
index 3b9e539..77ca7b8 100644
--- a/drivers/video/via/lcd.h
+++ b/drivers/video/via/lcd.h
@@ -76,9 +76,8 @@ void __devinit viafb_init_lvds_output_interface(struct lvds_chip_information
 				*plvds_chip_info,
 				struct lvds_setting_information
 				*plvds_setting_info);
-void viafb_lcd_set_mode(struct crt_mode_table *mode_crt_table,
-		  struct lvds_setting_information *plvds_setting_info,
-		  struct lvds_chip_information *plvds_chip_info);
+void viafb_lcd_set_mode(struct lvds_setting_information *plvds_setting_info,
+	struct lvds_chip_information *plvds_chip_info);
 bool __devinit viafb_lvds_trasmitter_identify(void);
 void viafb_init_lvds_output_interface(struct lvds_chip_information
 				*plvds_chip_info,
-- 
1.6.3.2

