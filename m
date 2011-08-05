Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756684Ab1HEVpm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 17:45:42 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:51574 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754501Ab1HEVpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 17:45:40 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX19++Y9qfmx+5Qa0cKchGwLfGUQRRT7c1cQgJmHR/r
	AH5U4XIAORycmN
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [PATCH 2/6] viafb: kill viafb_load_crtc_timing
Date: Fri,  5 Aug 2011 22:04:19 +0000
Message-Id: <1312581859-4124-1-git-send-email-FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <cover.1312578946.git.FlorianSchandinat@gmx.de>
References: <cover.1312578946.git.FlorianSchandinat@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch replaces calls to viafb_load_crtc_timing with the code.
This should make it easier to fix the oddity that in the modetable
the blank and sync end entries contain the length and we need to add
the start values to get those to be written to the hardware.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
---
 drivers/video/via/hw.c  |   30 ++++++++----------------------
 drivers/video/via/lcd.c |   41 +++++++++++++++++++----------------------
 drivers/video/via/lcd.h |    2 --
 3 files changed, 27 insertions(+), 46 deletions(-)

diff --git a/drivers/video/via/hw.c b/drivers/video/via/hw.c
index 372ce4f..52d41f0 100644
--- a/drivers/video/via/hw.c
+++ b/drivers/video/via/hw.c
@@ -1467,20 +1467,6 @@ void viafb_set_vclock(u32 clk, int set_iga)
 	via_write_misc_reg_mask(0x0C, 0x0C); /* select external clock */
 }
 
-void viafb_load_crtc_timing(struct display_timing device_timing,
-	int set_iga)
-{
-	device_timing.hor_blank_end += device_timing.hor_blank_start;
-	device_timing.hor_sync_end += device_timing.hor_sync_start;
-	device_timing.ver_blank_end += device_timing.ver_blank_start;
-	device_timing.ver_sync_end += device_timing.ver_sync_start;
-
-	if (set_iga == IGA1)
-		via_set_primary_timing(&device_timing);
-	else if (set_iga == IGA2)
-		via_set_secondary_timing(&device_timing);
-}
-
 void viafb_fill_crtc_timing(struct crt_mode_table *crt_table,
 	struct VideoModeTable *video_mode, int bpp_byte, int set_iga)
 {
@@ -1515,6 +1501,10 @@ void viafb_fill_crtc_timing(struct crt_mode_table *crt_table,
 		crt_reg.hor_blank_end = crt_reg.hor_blank_end + 16;
 	}
 
+	crt_reg.hor_blank_end += crt_reg.hor_blank_start;
+	crt_reg.hor_sync_end += crt_reg.hor_sync_start;
+	crt_reg.ver_blank_end += crt_reg.ver_blank_start;
+	crt_reg.ver_sync_end += crt_reg.ver_sync_start;
 	h_addr = crt_reg.hor_addr;
 	v_addr = crt_reg.ver_addr;
 	if (set_iga == IGA1) {
@@ -1522,14 +1512,10 @@ void viafb_fill_crtc_timing(struct crt_mode_table *crt_table,
 		viafb_write_reg_mask(CR17, VIACR, 0x00, BIT7);
 	}
 
-	switch (set_iga) {
-	case IGA1:
-		viafb_load_crtc_timing(crt_reg, IGA1);
-		break;
-	case IGA2:
-		viafb_load_crtc_timing(crt_reg, IGA2);
-		break;
-	}
+	if (set_iga == IGA1)
+		via_set_primary_timing(&crt_reg);
+	else if (set_iga == IGA2)
+		via_set_secondary_timing(&crt_reg);
 
 	viafb_lock_crt();
 	viafb_write_reg_mask(CR17, VIACR, 0x80, BIT7);
diff --git a/drivers/video/via/lcd.c b/drivers/video/via/lcd.c
index 6e06981..0a38e4d 100644
--- a/drivers/video/via/lcd.c
+++ b/drivers/video/via/lcd.c
@@ -559,7 +559,7 @@ void viafb_lcd_set_mode(struct crt_mode_table *mode_crt_table,
 	int panel_hres = plvds_setting_info->lcd_panel_hres;
 	int panel_vres = plvds_setting_info->lcd_panel_vres;
 	u32 clock;
-	struct display_timing mode_crt_reg, panel_crt_reg;
+	struct display_timing mode_crt_reg, panel_crt_reg, timing;
 	struct crt_mode_table *panel_crt_table = NULL;
 	struct VideoModeTable *vmode_tbl = viafb_get_mode(panel_hres,
 		panel_vres);
@@ -576,31 +576,28 @@ void viafb_lcd_set_mode(struct crt_mode_table *mode_crt_table,
 	clock = panel_crt_reg.hor_total * panel_crt_reg.ver_total
 		* panel_crt_table->refresh_rate;
 	plvds_setting_info->vclk = clock;
-	if (set_iga == IGA1) {
-		/* IGA1 doesn't have LCD scaling, so set it as centering. */
-		viafb_load_crtc_timing(lcd_centering_timging
-				 (mode_crt_reg, panel_crt_reg), IGA1);
+
+	if (set_iga == IGA2 && (set_hres < panel_hres || set_vres < panel_vres)
+		&& plvds_setting_info->display_method == LCD_EXPANDSION) {
+		timing = panel_crt_reg;
+		load_lcd_scaling(set_hres, set_vres, panel_hres, panel_vres);
 	} else {
-		/* Expansion */
-		if (plvds_setting_info->display_method == LCD_EXPANDSION
-			&& (set_hres < panel_hres || set_vres < panel_vres)) {
-			/* expansion timing IGA2 loaded panel set timing*/
-			viafb_load_crtc_timing(panel_crt_reg, IGA2);
-			DEBUG_MSG(KERN_INFO "viafb_load_crtc_timing!!\n");
-			load_lcd_scaling(set_hres, set_vres, panel_hres,
-					 panel_vres);
-			DEBUG_MSG(KERN_INFO "load_lcd_scaling!!\n");
-		} else {	/* Centering */
-			/* centering timing IGA2 always loaded panel
-			   and mode releative timing */
-			viafb_load_crtc_timing(lcd_centering_timging
-					 (mode_crt_reg, panel_crt_reg), IGA2);
-			viafb_write_reg_mask(CR79, VIACR, 0x00,
+		timing = lcd_centering_timging(mode_crt_reg, panel_crt_reg);
+		if (set_iga == IGA2)
+			/* disable scaling */
+			via_write_reg_mask(VIACR, 0x79, 0x00,
 				BIT0 + BIT1 + BIT2);
-			/* LCD scaling disabled */
-		}
 	}
 
+	timing.hor_blank_end += timing.hor_blank_start;
+	timing.hor_sync_end += timing.hor_sync_start;
+	timing.ver_blank_end += timing.ver_blank_start;
+	timing.ver_sync_end += timing.ver_sync_start;
+	if (set_iga == IGA1)
+		via_set_primary_timing(&timing);
+	else if (set_iga == IGA2)
+		via_set_secondary_timing(&timing);
+
 	/* Fetch count for IGA2 only */
 	viafb_load_fetch_count_reg(set_hres, mode_bpp / 8, set_iga);
 
diff --git a/drivers/video/via/lcd.h b/drivers/video/via/lcd.h
index 75f60a6..3b9e539 100644
--- a/drivers/video/via/lcd.h
+++ b/drivers/video/via/lcd.h
@@ -85,7 +85,5 @@ void viafb_init_lvds_output_interface(struct lvds_chip_information
 				struct lvds_setting_information
 				*plvds_setting_info);
 bool viafb_lcd_get_mobile_state(bool *mobile);
-void viafb_load_crtc_timing(struct display_timing device_timing,
-	int set_iga);
 
 #endif /* __LCD_H__ */
-- 
1.6.3.2

