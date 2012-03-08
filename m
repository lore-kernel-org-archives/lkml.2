Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753936Ab2CHRzg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 12:55:36 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:39972 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753790Ab2CHRzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 12:55:31 -0500
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX1/XE9x+ZCTXA4CjmIC4AFjIbsMN2+artMmnBnd1ZW
	5RQnW0qCeGDuj8
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [PATCH 1/2] viafb: modetable conversion
Date: Thu,  8 Mar 2012 18:15:28 +0000
Message-Id: <c402f1cfbb344954ffe52f5b0ffd540fc8fbbec0.1331229163.git.FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <cover.1331229163.git.FlorianSchandinat@gmx.de>
References: <cover.1331229163.git.FlorianSchandinat@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts the modetables used in viafb to
- remove the strange thing that sync_end and blanking_end contained
  the length and not the absolute value
- remove hundreds of useless defines
- use fb_videomode and not our own definition so modes defined in
  the subsystem and received via EDID are compatible with ours

As the modes are now stored in a flat structure and no longer in a
tree like thing the lookup time was increased but as it is a rare
event anyway it shouldn't matter. Otherwise the behaviour should be
the same as before.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
---
 drivers/video/via/dvi.c     |    2 +-
 drivers/video/via/hw.c      |   41 +--
 drivers/video/via/hw.h      |    4 +-
 drivers/video/via/lcd.c     |   53 +---
 drivers/video/via/share.h   |  331 --------------------
 drivers/video/via/viamode.c |  713 ++++++-------------------------------------
 drivers/video/via/viamode.h |   11 +-
 7 files changed, 120 insertions(+), 1035 deletions(-)

diff --git a/drivers/video/via/dvi.c b/drivers/video/via/dvi.c
index 3312c81..6be72f0 100644
--- a/drivers/video/via/dvi.c
+++ b/drivers/video/via/dvi.c
@@ -176,7 +176,7 @@ void viafb_dvi_set_mode(const struct fb_var_screeninfo *var,
 	u16 cxres, u16 cyres, int iga)
 {
 	struct fb_var_screeninfo dvi_var = *var;
-	struct crt_mode_table *rb_mode;
+	const struct fb_videomode *rb_mode;
 	int maxPixelClock;
 
 	maxPixelClock = viaparinfo->shared->tmds_setting_info.max_pixel_clock;
diff --git a/drivers/video/via/hw.c b/drivers/video/via/hw.c
index 411b7e9..898590d 100644
--- a/drivers/video/via/hw.c
+++ b/drivers/video/via/hw.c
@@ -1467,7 +1467,8 @@ void viafb_set_vclock(u32 clk, int set_iga)
 	via_write_misc_reg_mask(0x0C, 0x0C); /* select external clock */
 }
 
-static struct display_timing var_to_timing(const struct fb_var_screeninfo *var, u16 cxres, u16 cyres)
+struct display_timing var_to_timing(const struct fb_var_screeninfo *var,
+	u16 cxres, u16 cyres)
 {
 	struct display_timing timing;
 	u16 dx = (var->xres - cxres) / 2, dy = (var->yres - cyres) / 2;
@@ -2011,20 +2012,20 @@ int viafb_setmode(void)
 
 int viafb_get_refresh(int hres, int vres, u32 long_refresh)
 {
-	struct crt_mode_table *best;
+	const struct fb_videomode *best;
 
 	best = viafb_get_best_mode(hres, vres, long_refresh);
 	if (!best)
 		return 60;
 
-	if (abs(best->refresh_rate - long_refresh) > 3) {
+	if (abs(best->refresh - long_refresh) > 3) {
 		if (hres == 1200 && vres == 900)
 			return 49; /* OLPC DCON only supports 50 Hz */
 		else
 			return 60;
 	}
 
-	return best->refresh_rate;
+	return best->refresh;
 }
 
 static void device_off(void)
@@ -2118,26 +2119,16 @@ void viafb_set_dpa_gfx(int output_interface, struct GFX_DPA_SETTING\
 }
 
 void viafb_fill_var_timing_info(struct fb_var_screeninfo *var,
-	struct crt_mode_table *mode)
+	const struct fb_videomode *mode)
 {
-	struct display_timing crt_reg;
-
-	crt_reg = mode->crtc;
-	var->pixclock = 1000000000 / (crt_reg.hor_total * crt_reg.ver_total)
-		* 1000 / mode->refresh_rate;
-	var->xres = crt_reg.hor_addr;
-	var->yres = crt_reg.ver_addr;
-	var->left_margin =
-	    crt_reg.hor_total - (crt_reg.hor_sync_start + crt_reg.hor_sync_end);
-	var->right_margin = crt_reg.hor_sync_start - crt_reg.hor_addr;
-	var->hsync_len = crt_reg.hor_sync_end;
-	var->upper_margin =
-	    crt_reg.ver_total - (crt_reg.ver_sync_start + crt_reg.ver_sync_end);
-	var->lower_margin = crt_reg.ver_sync_start - crt_reg.ver_addr;
-	var->vsync_len = crt_reg.ver_sync_end;
-	var->sync = 0;
-	if (mode->h_sync_polarity == POSITIVE)
-		var->sync |= FB_SYNC_HOR_HIGH_ACT;
-	if (mode->v_sync_polarity == POSITIVE)
-		var->sync |= FB_SYNC_VERT_HIGH_ACT;
+	var->pixclock = mode->pixclock;
+	var->xres = mode->xres;
+	var->yres = mode->yres;
+	var->left_margin = mode->left_margin;
+	var->right_margin = mode->right_margin;
+	var->hsync_len = mode->hsync_len;
+	var->upper_margin = mode->upper_margin;
+	var->lower_margin = mode->lower_margin;
+	var->vsync_len = mode->vsync_len;
+	var->sync = mode->sync;
 }
diff --git a/drivers/video/via/hw.h b/drivers/video/via/hw.h
index cacedc1..6be243c 100644
--- a/drivers/video/via/hw.h
+++ b/drivers/video/via/hw.h
@@ -637,6 +637,8 @@ extern int viafb_LCD_ON;
 extern int viafb_DVI_ON;
 extern int viafb_hotplug;
 
+struct display_timing var_to_timing(const struct fb_var_screeninfo *var,
+	u16 cxres, u16 cyres);
 void viafb_fill_crtc_timing(const struct fb_var_screeninfo *var,
 	u16 cxres, u16 cyres, int iga);
 void viafb_set_vclock(u32 CLK, int set_iga);
@@ -660,7 +662,7 @@ void viafb_set_dpa_gfx(int output_interface, struct GFX_DPA_SETTING\
 
 int viafb_setmode(void);
 void viafb_fill_var_timing_info(struct fb_var_screeninfo *var,
-	struct crt_mode_table *mode);
+	const struct fb_videomode *mode);
 void __devinit viafb_init_chip_info(int chip_type);
 void __devinit viafb_init_dac(int set_iga);
 int viafb_get_refresh(int hres, int vres, u32 float_refresh);
diff --git a/drivers/video/via/lcd.c b/drivers/video/via/lcd.c
index 6e52711..1650379 100644
--- a/drivers/video/via/lcd.c
+++ b/drivers/video/via/lcd.c
@@ -75,9 +75,6 @@ static void check_diport_of_integrated_lvds(
 	struct lvds_chip_information *plvds_chip_info,
 				     struct lvds_setting_information
 				     *plvds_setting_info);
-static struct display_timing lcd_centering_timging(struct display_timing
-					    mode_crt_reg,
-					   struct display_timing panel_crt_reg);
 
 static inline bool check_lvds_chip(int device_id_subaddr, int device_id)
 {
@@ -552,39 +549,34 @@ void viafb_lcd_set_mode(const struct fb_var_screeninfo *var, u16 cxres,
 	int panel_hres = plvds_setting_info->lcd_panel_hres;
 	int panel_vres = plvds_setting_info->lcd_panel_vres;
 	u32 clock;
-	struct display_timing mode_crt_reg, panel_crt_reg, timing;
-	struct crt_mode_table *mode_crt_table, *panel_crt_table;
+	struct display_timing timing;
+	struct fb_var_screeninfo panel_var;
+	const struct fb_videomode *mode_crt_table, *panel_crt_table;
 
 	DEBUG_MSG(KERN_INFO "viafb_lcd_set_mode!!\n");
 	/* Get mode table */
 	mode_crt_table = viafb_get_best_mode(set_hres, set_vres, 60);
-	mode_crt_reg = mode_crt_table->crtc;
 	/* Get panel table Pointer */
 	panel_crt_table = viafb_get_best_mode(panel_hres, panel_vres, 60);
-	panel_crt_reg = panel_crt_table->crtc;
+	viafb_fill_var_timing_info(&panel_var, panel_crt_table);
 	DEBUG_MSG(KERN_INFO "bellow viafb_lcd_set_mode!!\n");
 	if (VT1636_LVDS == plvds_chip_info->lvds_chip_name)
 		viafb_init_lvds_vt1636(plvds_setting_info, plvds_chip_info);
-	clock = panel_crt_reg.hor_total * panel_crt_reg.ver_total
-		* panel_crt_table->refresh_rate;
+	clock = PICOS2KHZ(panel_crt_table->pixclock) * 1000;
 	plvds_setting_info->vclk = clock;
 
 	if (set_iga == IGA2 && (set_hres < panel_hres || set_vres < panel_vres)
 		&& plvds_setting_info->display_method == LCD_EXPANDSION) {
-		timing = panel_crt_reg;
+		timing = var_to_timing(&panel_var, panel_hres, panel_vres);
 		load_lcd_scaling(set_hres, set_vres, panel_hres, panel_vres);
 	} else {
-		timing = lcd_centering_timging(mode_crt_reg, panel_crt_reg);
+		timing = var_to_timing(&panel_var, set_hres, set_vres);
 		if (set_iga == IGA2)
 			/* disable scaling */
 			via_write_reg_mask(VIACR, 0x79, 0x00,
 				BIT0 + BIT1 + BIT2);
 	}
 
-	timing.hor_blank_end += timing.hor_blank_start;
-	timing.hor_sync_end += timing.hor_sync_start;
-	timing.ver_blank_end += timing.ver_blank_start;
-	timing.ver_sync_end += timing.ver_sync_start;
 	if (set_iga == IGA1)
 		via_set_primary_timing(&timing);
 	else if (set_iga == IGA2)
@@ -968,37 +960,6 @@ void __devinit viafb_init_lvds_output_interface(struct lvds_chip_information
 	}
 }
 
-static struct display_timing lcd_centering_timging(struct display_timing
-					    mode_crt_reg,
-					    struct display_timing panel_crt_reg)
-{
-	struct display_timing crt_reg;
-
-	crt_reg.hor_total = panel_crt_reg.hor_total;
-	crt_reg.hor_addr = mode_crt_reg.hor_addr;
-	crt_reg.hor_blank_start =
-	    (panel_crt_reg.hor_addr - mode_crt_reg.hor_addr) / 2 +
-	    crt_reg.hor_addr;
-	crt_reg.hor_blank_end = panel_crt_reg.hor_blank_end;
-	crt_reg.hor_sync_start =
-	    (panel_crt_reg.hor_sync_start -
-	     panel_crt_reg.hor_blank_start) + crt_reg.hor_blank_start;
-	crt_reg.hor_sync_end = panel_crt_reg.hor_sync_end;
-
-	crt_reg.ver_total = panel_crt_reg.ver_total;
-	crt_reg.ver_addr = mode_crt_reg.ver_addr;
-	crt_reg.ver_blank_start =
-	    (panel_crt_reg.ver_addr - mode_crt_reg.ver_addr) / 2 +
-	    crt_reg.ver_addr;
-	crt_reg.ver_blank_end = panel_crt_reg.ver_blank_end;
-	crt_reg.ver_sync_start =
-	    (panel_crt_reg.ver_sync_start -
-	     panel_crt_reg.ver_blank_start) + crt_reg.ver_blank_start;
-	crt_reg.ver_sync_end = panel_crt_reg.ver_sync_end;
-
-	return crt_reg;
-}
-
 bool viafb_lcd_get_mobile_state(bool *mobile)
 {
 	unsigned char __iomem *romptr, *tableptr, *biosptr;
diff --git a/drivers/video/via/share.h b/drivers/video/via/share.h
index c01c1c1..3158dfc 100644
--- a/drivers/video/via/share.h
+++ b/drivers/video/via/share.h
@@ -283,337 +283,6 @@
 #define HW_LAYOUT_LCD1_LCD2     0x04
 #define HW_LAYOUT_LCD_EXTERNAL_LCD2 0x10
 
-/* Definition Refresh Rate */
-#define REFRESH_49      49
-#define REFRESH_50      50
-#define REFRESH_60      60
-#define REFRESH_75      75
-#define REFRESH_85      85
-#define REFRESH_100     100
-#define REFRESH_120     120
-
-/* Definition Sync Polarity*/
-#define NEGATIVE        1
-#define POSITIVE        0
-
-/*480x640@60 Sync Polarity (GTF)
-*/
-#define M480X640_R60_HSP        NEGATIVE
-#define M480X640_R60_VSP        POSITIVE
-
-/*640x480@60 Sync Polarity (VESA Mode)
-*/
-#define M640X480_R60_HSP        NEGATIVE
-#define M640X480_R60_VSP        NEGATIVE
-
-/*640x480@75 Sync Polarity (VESA Mode)
-*/
-#define M640X480_R75_HSP        NEGATIVE
-#define M640X480_R75_VSP        NEGATIVE
-
-/*640x480@85 Sync Polarity (VESA Mode)
-*/
-#define M640X480_R85_HSP        NEGATIVE
-#define M640X480_R85_VSP        NEGATIVE
-
-/*640x480@100 Sync Polarity (GTF Mode)
-*/
-#define M640X480_R100_HSP       NEGATIVE
-#define M640X480_R100_VSP       POSITIVE
-
-/*640x480@120 Sync Polarity (GTF Mode)
-*/
-#define M640X480_R120_HSP       NEGATIVE
-#define M640X480_R120_VSP       POSITIVE
-
-/*720x480@60 Sync Polarity  (GTF Mode)
-*/
-#define M720X480_R60_HSP        NEGATIVE
-#define M720X480_R60_VSP        POSITIVE
-
-/*720x576@60 Sync Polarity  (GTF Mode)
-*/
-#define M720X576_R60_HSP        NEGATIVE
-#define M720X576_R60_VSP        POSITIVE
-
-/*800x600@60 Sync Polarity (VESA Mode)
-*/
-#define M800X600_R60_HSP        POSITIVE
-#define M800X600_R60_VSP        POSITIVE
-
-/*800x600@75 Sync Polarity (VESA Mode)
-*/
-#define M800X600_R75_HSP        POSITIVE
-#define M800X600_R75_VSP        POSITIVE
-
-/*800x600@85 Sync Polarity (VESA Mode)
-*/
-#define M800X600_R85_HSP        POSITIVE
-#define M800X600_R85_VSP        POSITIVE
-
-/*800x600@100 Sync Polarity (GTF Mode)
-*/
-#define M800X600_R100_HSP       NEGATIVE
-#define M800X600_R100_VSP       POSITIVE
-
-/*800x600@120 Sync Polarity (GTF Mode)
-*/
-#define M800X600_R120_HSP       NEGATIVE
-#define M800X600_R120_VSP       POSITIVE
-
-/*800x480@60 Sync Polarity  (CVT Mode)
-*/
-#define M800X480_R60_HSP        NEGATIVE
-#define M800X480_R60_VSP        POSITIVE
-
-/*848x480@60 Sync Polarity  (CVT Mode)
-*/
-#define M848X480_R60_HSP        NEGATIVE
-#define M848X480_R60_VSP        POSITIVE
-
-/*852x480@60 Sync Polarity  (GTF Mode)
-*/
-#define M852X480_R60_HSP        NEGATIVE
-#define M852X480_R60_VSP        POSITIVE
-
-/*1024x512@60 Sync Polarity (GTF Mode)
-*/
-#define M1024X512_R60_HSP       NEGATIVE
-#define M1024X512_R60_VSP       POSITIVE
-
-/*1024x600@60 Sync Polarity (GTF Mode)
-*/
-#define M1024X600_R60_HSP       NEGATIVE
-#define M1024X600_R60_VSP       POSITIVE
-
-/*1024x768@60 Sync Polarity (VESA Mode)
-*/
-#define M1024X768_R60_HSP       NEGATIVE
-#define M1024X768_R60_VSP       NEGATIVE
-
-/*1024x768@75 Sync Polarity (VESA Mode)
-*/
-#define M1024X768_R75_HSP       POSITIVE
-#define M1024X768_R75_VSP       POSITIVE
-
-/*1024x768@85 Sync Polarity (VESA Mode)
-*/
-#define M1024X768_R85_HSP       POSITIVE
-#define M1024X768_R85_VSP       POSITIVE
-
-/*1024x768@100 Sync Polarity (GTF Mode)
-*/
-#define M1024X768_R100_HSP      NEGATIVE
-#define M1024X768_R100_VSP      POSITIVE
-
-/*1152x864@75 Sync Polarity (VESA Mode)
-*/
-#define M1152X864_R75_HSP       POSITIVE
-#define M1152X864_R75_VSP       POSITIVE
-
-/*1280x720@60 Sync Polarity  (GTF Mode)
-*/
-#define M1280X720_R60_HSP       NEGATIVE
-#define M1280X720_R60_VSP       POSITIVE
-
-/* 1280x768@50 Sync Polarity  (GTF Mode) */
-#define M1280X768_R50_HSP       NEGATIVE
-#define M1280X768_R50_VSP       POSITIVE
-
-/*1280x768@60 Sync Polarity  (GTF Mode)
-*/
-#define M1280X768_R60_HSP       NEGATIVE
-#define M1280X768_R60_VSP       POSITIVE
-
-/*1280x800@60 Sync Polarity  (CVT Mode)
-*/
-#define M1280X800_R60_HSP       NEGATIVE
-#define M1280X800_R60_VSP       POSITIVE
-
-/*1280x960@60 Sync Polarity (VESA Mode)
-*/
-#define M1280X960_R60_HSP       POSITIVE
-#define M1280X960_R60_VSP       POSITIVE
-
-/*1280x1024@60 Sync Polarity (VESA Mode)
-*/
-#define M1280X1024_R60_HSP      POSITIVE
-#define M1280X1024_R60_VSP      POSITIVE
-
-/* 1360x768@60 Sync Polarity (CVT Mode) */
-#define M1360X768_R60_HSP       POSITIVE
-#define M1360X768_R60_VSP       POSITIVE
-
-/* 1360x768@60 Sync Polarity (CVT Reduce Blanking Mode) */
-#define M1360X768_RB_R60_HSP       POSITIVE
-#define M1360X768_RB_R60_VSP       NEGATIVE
-
-/* 1368x768@50 Sync Polarity (GTF Mode) */
-#define M1368X768_R50_HSP       NEGATIVE
-#define M1368X768_R50_VSP       POSITIVE
-
-/* 1368x768@60 Sync Polarity (VESA Mode) */
-#define M1368X768_R60_HSP       NEGATIVE
-#define M1368X768_R60_VSP       POSITIVE
-
-/*1280x1024@75 Sync Polarity (VESA Mode)
-*/
-#define M1280X1024_R75_HSP      POSITIVE
-#define M1280X1024_R75_VSP      POSITIVE
-
-/*1280x1024@85 Sync Polarity (VESA Mode)
-*/
-#define M1280X1024_R85_HSP      POSITIVE
-#define M1280X1024_R85_VSP      POSITIVE
-
-/*1440x1050@60 Sync Polarity (GTF Mode)
-*/
-#define M1440X1050_R60_HSP      NEGATIVE
-#define M1440X1050_R60_VSP      POSITIVE
-
-/*1600x1200@60 Sync Polarity (VESA Mode)
-*/
-#define M1600X1200_R60_HSP      POSITIVE
-#define M1600X1200_R60_VSP      POSITIVE
-
-/*1600x1200@75 Sync Polarity (VESA Mode)
-*/
-#define M1600X1200_R75_HSP      POSITIVE
-#define M1600X1200_R75_VSP      POSITIVE
-
-/* 1680x1050@60 Sync Polarity (CVT Mode) */
-#define M1680x1050_R60_HSP      NEGATIVE
-#define M1680x1050_R60_VSP      NEGATIVE
-
-/* 1680x1050@60 Sync Polarity (CVT Reduce Blanking Mode) */
-#define M1680x1050_RB_R60_HSP      POSITIVE
-#define M1680x1050_RB_R60_VSP      NEGATIVE
-
-/* 1680x1050@75 Sync Polarity (CVT Mode) */
-#define M1680x1050_R75_HSP      NEGATIVE
-#define M1680x1050_R75_VSP      POSITIVE
-
-/*1920x1080@60 Sync Polarity (CVT Mode)
-*/
-#define M1920X1080_R60_HSP      NEGATIVE
-#define M1920X1080_R60_VSP      POSITIVE
-
-/* 1920x1080@60 Sync Polarity (CVT Reduce Blanking Mode) */
-#define M1920X1080_RB_R60_HSP  POSITIVE
-#define M1920X1080_RB_R60_VSP  NEGATIVE
-
-/*1920x1440@60 Sync Polarity (VESA Mode)
-*/
-#define M1920X1440_R60_HSP      NEGATIVE
-#define M1920X1440_R60_VSP      POSITIVE
-
-/*1920x1440@75 Sync Polarity (VESA Mode)
-*/
-#define M1920X1440_R75_HSP      NEGATIVE
-#define M1920X1440_R75_VSP      POSITIVE
-
-#if 0
-/* 1400x1050@60 Sync Polarity (VESA Mode) */
-#define M1400X1050_R60_HSP      NEGATIVE
-#define M1400X1050_R60_VSP      NEGATIVE
-#endif
-
-/* 1400x1050@60 Sync Polarity (CVT Mode) */
-#define M1400X1050_R60_HSP      NEGATIVE
-#define M1400X1050_R60_VSP      POSITIVE
-
-/* 1400x1050@60 Sync Polarity (CVT Reduce Blanking Mode) */
-#define M1400X1050_RB_R60_HSP      POSITIVE
-#define M1400X1050_RB_R60_VSP      NEGATIVE
-
-/* 1400x1050@75 Sync Polarity (CVT Mode) */
-#define M1400X1050_R75_HSP      NEGATIVE
-#define M1400X1050_R75_VSP      POSITIVE
-
-/* 960x600@60 Sync Polarity (CVT Mode) */
-#define M960X600_R60_HSP        NEGATIVE
-#define M960X600_R60_VSP        POSITIVE
-
-/* 1000x600@60 Sync Polarity (GTF Mode) */
-#define M1000X600_R60_HSP       NEGATIVE
-#define M1000X600_R60_VSP       POSITIVE
-
-/* 1024x576@60 Sync Polarity (GTF Mode) */
-#define M1024X576_R60_HSP       NEGATIVE
-#define M1024X576_R60_VSP       POSITIVE
-
-/*1024x600@60 Sync Polarity (GTF Mode)*/
-#define M1024X600_R60_HSP       NEGATIVE
-#define M1024X600_R60_VSP       POSITIVE
-
-/* 1088x612@60 Sync Polarity (CVT Mode) */
-#define M1088X612_R60_HSP       NEGATIVE
-#define M1088X612_R60_VSP       POSITIVE
-
-/* 1152x720@60 Sync Polarity (CVT Mode) */
-#define M1152X720_R60_HSP       NEGATIVE
-#define M1152X720_R60_VSP       POSITIVE
-
-/* 1200x720@60 Sync Polarity (GTF Mode) */
-#define M1200X720_R60_HSP       NEGATIVE
-#define M1200X720_R60_VSP       POSITIVE
-
-/* 1200x900@60 Sync Polarity (DCON) */
-#define M1200X900_R60_HSP       POSITIVE
-#define M1200X900_R60_VSP       POSITIVE
-
-/* 1280x600@60 Sync Polarity (GTF Mode) */
-#define M1280x600_R60_HSP       NEGATIVE
-#define M1280x600_R60_VSP       POSITIVE
-
-/* 1280x720@50 Sync Polarity  (GTF Mode) */
-#define M1280X720_R50_HSP       NEGATIVE
-#define M1280X720_R50_VSP       POSITIVE
-
-/* 1440x900@60 Sync Polarity (CVT Mode) */
-#define M1440X900_R60_HSP       NEGATIVE
-#define M1440X900_R60_VSP       POSITIVE
-
-/* 1440x900@75 Sync Polarity (CVT Mode) */
-#define M1440X900_R75_HSP       NEGATIVE
-#define M1440X900_R75_VSP       POSITIVE
-
-/* 1440x900@60 Sync Polarity (CVT Reduce Blanking Mode) */
-#define M1440X900_RB_R60_HSP       POSITIVE
-#define M1440X900_RB_R60_VSP       NEGATIVE
-
-/* 1600x900@60 Sync Polarity (CVT Mode) */
-#define M1600X900_R60_HSP       NEGATIVE
-#define M1600X900_R60_VSP       POSITIVE
-
-/* 1600x900@60 Sync Polarity (CVT Reduce Blanking Mode) */
-#define M1600X900_RB_R60_HSP       POSITIVE
-#define M1600X900_RB_R60_VSP       NEGATIVE
-
-/* 1600x1024@60 Sync Polarity (GTF Mode) */
-#define M1600X1024_R60_HSP      NEGATIVE
-#define M1600X1024_R60_VSP      POSITIVE
-
-/* 1792x1344@60 Sync Polarity (DMT Mode) */
-#define M1792x1344_R60_HSP      NEGATIVE
-#define M1792x1344_R60_VSP      POSITIVE
-
-/* 1856x1392@60 Sync Polarity (DMT Mode) */
-#define M1856x1392_R60_HSP      NEGATIVE
-#define M1856x1392_R60_VSP      POSITIVE
-
-/* 1920x1200@60 Sync Polarity (CVT Mode) */
-#define M1920X1200_R60_HSP      NEGATIVE
-#define M1920X1200_R60_VSP      POSITIVE
-
-/* 1920x1200@60 Sync Polarity (CVT Reduce Blanking Mode) */
-#define M1920X1200_RB_R60_HSP  POSITIVE
-#define M1920X1200_RB_R60_VSP  NEGATIVE
-
-/* 2048x1536@60 Sync Polarity (CVT Mode) */
-#define M2048x1536_R60_HSP      NEGATIVE
-#define M2048x1536_R60_VSP      POSITIVE
-
 /* Definition CRTC Timing Index */
 #define H_TOTAL_INDEX               0
 #define H_ADDR_INDEX                1
diff --git a/drivers/video/via/viamode.c b/drivers/video/via/viamode.c
index 0911cac..0666ab0 100644
--- a/drivers/video/via/viamode.c
+++ b/drivers/video/via/viamode.c
@@ -268,591 +268,78 @@ struct VPITTable VPIT = {
 /* Mode Table       */
 /********************/
 
-/* 480x640 */
-static struct crt_mode_table CRTM480x640[] = {
-	/* r_rate,              hsp,             vsp   */
-	/* HT,  HA,  HBS, HBE, HSS, HSE, VT,  VA,  VBS, VBE, VSS, VSE */
-	{REFRESH_60, M480X640_R60_HSP, M480X640_R60_VSP,
-	 {624, 480, 480, 144, 504, 48, 663, 640, 640, 23, 641, 3} }	/* GTF*/
-};
-
-/* 640x480*/
-static struct crt_mode_table CRTM640x480[] = {
-	/*r_rate,hsp,vsp */
-	/*HT,  HA,  HBS, HBE, HSS, HSE, VT,  VA,  VBS, VBE, VSS, VSE */
-	{REFRESH_60, M640X480_R60_HSP, M640X480_R60_VSP,
-	 {800, 640, 640, 160, 656, 96, 525, 480, 480, 45, 490, 2} },
-	{REFRESH_75, M640X480_R75_HSP, M640X480_R75_VSP,
-	 {840, 640, 640, 200, 656, 64, 500, 480, 480, 20, 481, 3} },
-	{REFRESH_85, M640X480_R85_HSP, M640X480_R85_VSP,
-	 {832, 640, 640, 192, 696, 56, 509, 480, 480, 29, 481, 3} },
-	{REFRESH_100, M640X480_R100_HSP, M640X480_R100_VSP,
-	 {848, 640, 640, 208, 680, 64, 509, 480, 480, 29, 481, 3} }, /*GTF*/
-	{REFRESH_120, M640X480_R120_HSP, M640X480_R120_VSP,
-	 {848, 640, 640, 208, 680, 64, 515, 480, 480, 35, 481, 3} } /*GTF*/
-};
-
-/*720x480 (GTF)*/
-static struct crt_mode_table CRTM720x480[] = {
-	/*r_rate,hsp,vsp      */
-	/*HT, HA,  HBS, HBE, HSS, HSE, VT,  VA,  VBS, VBE, VSS, VSE */
-	{REFRESH_60, M720X480_R60_HSP, M720X480_R60_VSP,
-	 {896, 720, 720, 176, 736, 72, 497, 480, 480, 17, 481, 3} }
-
-};
-
-/*720x576 (GTF)*/
-static struct crt_mode_table CRTM720x576[] = {
-	/*r_rate,hsp,vsp */
-	/*HT,  HA,  HBS, HBE, HSS, HSE, VT,  VA,  VBS, VBE, VSS, VSE */
-	{REFRESH_60, M720X576_R60_HSP, M720X576_R60_VSP,
-	 {912, 720, 720, 192, 744, 72, 597, 576, 576, 21, 577, 3} }
-};
-
-/* 800x480 (CVT) */
-static struct crt_mode_table CRTM800x480[] = {
-	/* r_rate,              hsp,             vsp   */
-	/* HT,  HA,  HBS, HBE, HSS, HSE, VT,  VA,  VBS, VBE, VSS, VSE */
-	{REFRESH_60, M800X480_R60_HSP, M800X480_R60_VSP,
-	 {992, 800, 800, 192, 824, 72, 500, 480, 480, 20, 483, 7} }
-};
-
-/* 800x600*/
-static struct crt_mode_table CRTM800x600[] = {
-	/*r_rate,hsp,vsp     */
-	/*HT,   HA,  HBS, HBE, HSS, HSE, VT,  VA,  VBS, VBE, VSS, VSE */
-	{REFRESH_60, M800X600_R60_HSP, M800X600_R60_VSP,
-	 {1056, 800, 800, 256, 840, 128, 628, 600, 600, 28, 601, 4} },
-	{REFRESH_75, M800X600_R75_HSP, M800X600_R75_VSP,
-	 {1056, 800, 800, 256, 816, 80, 625, 600, 600, 25, 601, 3} },
-	{REFRESH_85, M800X600_R85_HSP, M800X600_R85_VSP,
-	 {1048, 800, 800, 248, 832, 64, 631, 600, 600, 31, 601, 3} },
-	{REFRESH_100, M800X600_R100_HSP, M800X600_R100_VSP,
-	 {1072, 800, 800, 272, 848, 88, 636, 600, 600, 36, 601, 3} },
-	{REFRESH_120, M800X600_R120_HSP, M800X600_R120_VSP,
-	 {1088, 800, 800, 288, 856, 88, 643, 600, 600, 43, 601, 3} }
-};
-
-/* 848x480 (CVT) */
-static struct crt_mode_table CRTM848x480[] = {
-	/* r_rate,              hsp,             vsp   */
-	/* HT,  HA,  HBS, HBE, HSS, HSE, VT,  VA,  VBS, VBE, VSS, VSE */
-	{REFRESH_60, M848X480_R60_HSP, M848X480_R60_VSP,
-	 {1056, 848, 848, 208, 872, 80, 500, 480, 480, 20, 483, 5} }
-};
-
-/*856x480 (GTF) convert to 852x480*/
-static struct crt_mode_table CRTM852x480[] = {
-	/*r_rate,hsp,vsp     */
-	/*HT,   HA,  HBS, HBE, HSS, HSE, VT,  VA,  VBS, VBE, VSS, VSE */
-	{REFRESH_60, M852X480_R60_HSP, M852X480_R60_VSP,
-	{1064, 856, 856, 208, 872, 88, 497, 480, 480, 17, 481, 3} }
-};
-
-/*1024x512 (GTF)*/
-static struct crt_mode_table CRTM1024x512[] = {
-	/*r_rate,hsp,vsp     */
-	/*HT,   HA,  HBS, HBE, HSS, HSE, VT,  VA,  VBS, VBE, VSS, VSE */
-	{REFRESH_60, M1024X512_R60_HSP, M1024X512_R60_VSP,
-	 {1296, 1024, 1024, 272, 1056, 104, 531, 512, 512, 19, 513, 3} }
-
-};
-
-/* 1024x600*/
-static struct crt_mode_table CRTM1024x600[] = {
-	/*r_rate,hsp,vsp */
-	/*HT,  HA,   HBS,  HBE, HSS,  HSE, VT,  VA,  VBS, VBE, VSS, VSE */
-	{REFRESH_60, M1024X600_R60_HSP, M1024X600_R60_VSP,
-	 {1312, 1024, 1024, 288, 1064, 104, 622, 600, 600, 22, 601, 3} },
-};
-
-/* 1024x768*/
-static struct crt_mode_table CRTM1024x768[] = {
-	/*r_rate,hsp,vsp */
-	/*HT,  HA,   HBS,  HBE, HSS,  HSE, VT,  VA,  VBS, VBE, VSS, VSE */
-	{REFRESH_60, M1024X768_R60_HSP, M1024X768_R60_VSP,
-	{1344, 1024, 1024, 320, 1048, 136, 806, 768, 768, 38, 771, 6} },
-	{REFRESH_75, M1024X768_R75_HSP, M1024X768_R75_VSP,
-	{1312, 1024, 1024, 288, 1040, 96, 800, 768, 768, 32, 769, 3} },
-	{REFRESH_85, M1024X768_R85_HSP, M1024X768_R85_VSP,
-	{1376, 1024, 1024, 352, 1072, 96, 808, 768, 768, 40, 769, 3} },
-	{REFRESH_100, M1024X768_R100_HSP, M1024X768_R100_VSP,
-	{1392, 1024, 1024, 368, 1096, 112, 814, 768, 768, 46, 769, 3} }
-};
-
-/* 1152x864*/
-static struct crt_mode_table CRTM1152x864[] = {
-	/*r_rate,hsp,vsp      */
-	/*HT,  HA,   HBS,  HBE, HSS,  HSE, VT,  VA,  VBS, VBE, VSS, VSE */
-	{REFRESH_75, M1152X864_R75_HSP, M1152X864_R75_VSP,
-	 {1600, 1152, 1152, 448, 1216, 128, 900, 864, 864, 36, 865, 3} }
-
-};
-
-/* 1280x720 (HDMI 720P)*/
-static struct crt_mode_table CRTM1280x720[] = {
-	/*r_rate,hsp,vsp */
-	/*HT,  HA,   HBS,  HBE, HSS,  HSE, VT,  VA,  VBS, VBE, VSS, VSE      */
-	{REFRESH_60, M1280X720_R60_HSP, M1280X720_R60_VSP,
-	 {1648, 1280, 1280, 368, 1392, 40, 750, 720, 720, 30, 725, 5} },
-	{REFRESH_50, M1280X720_R50_HSP, M1280X720_R50_VSP,
-	 {1632, 1280, 1280, 352, 1328, 128, 741, 720, 720, 21, 721, 3} }
-};
-
-/*1280x768 (GTF)*/
-static struct crt_mode_table CRTM1280x768[] = {
-	/*r_rate,hsp,vsp     */
-	/*HT,  HA,   HBS,  HBE, HSS,  HSE, VT,  VA,  VBS, VBE, VSS, VSE */
-	{REFRESH_60, M1280X768_R60_HSP, M1280X768_R60_VSP,
-	 {1680, 1280, 1280, 400, 1344, 136, 795, 768, 768, 27, 769, 3} },
-	{REFRESH_50, M1280X768_R50_HSP, M1280X768_R50_VSP,
-	 {1648, 1280, 1280, 368, 1336, 128, 791, 768, 768, 23, 769, 3} }
-};
-
-/* 1280x800 (CVT) */
-static struct crt_mode_table CRTM1280x800[] = {
-	/* r_rate,              hsp,             vsp   */
-	/* HT,  HA,  HBS, HBE, HSS, HSE, VT,  VA,  VBS, VBE, VSS, VSE */
-	{REFRESH_60, M1280X800_R60_HSP, M1280X800_R60_VSP,
-	 {1680, 1280, 1280, 400, 1352, 128, 831, 800, 800, 31, 803, 6} }
-};
-
-/*1280x960*/
-static struct crt_mode_table CRTM1280x960[] = {
-	/*r_rate,hsp,vsp */
-	/*HT,  HA,   HBS,  HBE, HSS,  HSE, VT,  VA,  VBS, VBE, VSS, VSE */
-	{REFRESH_60, M1280X960_R60_HSP, M1280X960_R60_VSP,
-	 {1800, 1280, 1280, 520, 1376, 112, 1000, 960, 960, 40, 961, 3} }
-};
-
-/* 1280x1024*/
-static struct crt_mode_table CRTM1280x1024[] = {
-	/*r_rate,hsp,vsp */
-	/*HT,  HA,   HBS,  HBE, HSS,  HSE, VT,  VA,  VBS, VBE, VSS, VSE */
-	{REFRESH_60, M1280X1024_R60_HSP, M1280X1024_R60_VSP,
-	 {1688, 1280, 1280, 408, 1328, 112, 1066, 1024, 1024, 42, 1025,
-	  3} },
-	{REFRESH_75, M1280X1024_R75_HSP, M1280X1024_R75_VSP,
-	 {1688, 1280, 1280, 408, 1296, 144, 1066, 1024, 1024, 42, 1025,
-	  3} },
-	{REFRESH_85, M1280X1024_R85_HSP, M1280X1024_R85_VSP,
-	 {1728, 1280, 1280, 448, 1344, 160, 1072, 1024, 1024, 48, 1025, 3} }
-};
-
-/* 1368x768 (GTF) */
-static struct crt_mode_table CRTM1368x768[] = {
-	/* r_rate,  hsp, vsp */
-	/* HT,  HA,  HBS, HBE, HSS, HSE, VT,  VA,  VBS, VBE, VSS, VSE */
-	{REFRESH_60, M1368X768_R60_HSP, M1368X768_R60_VSP,
-	 {1800, 1368, 1368, 432, 1440, 144, 795, 768, 768, 27, 769, 3} }
-};
-
-/*1440x1050 (GTF)*/
-static struct crt_mode_table CRTM1440x1050[] = {
-	/*r_rate,hsp,vsp      */
-	/*HT,  HA,   HBS,  HBE, HSS,  HSE, VT,  VA,  VBS, VBE, VSS, VSE */
-	{REFRESH_60, M1440X1050_R60_HSP, M1440X1050_R60_VSP,
-	 {1936, 1440, 1440, 496, 1536, 152, 1077, 1040, 1040, 37, 1041, 3} }
-};
-
-/* 1600x1200*/
-static struct crt_mode_table CRTM1600x1200[] = {
-	/*r_rate,hsp,vsp */
-	/*HT,  HA,   HBS,  HBE, HSS,  HSE, VT,  VA,  VBS, VBE, VSS, VSE */
-	{REFRESH_60, M1600X1200_R60_HSP, M1600X1200_R60_VSP,
-	 {2160, 1600, 1600, 560, 1664, 192, 1250, 1200, 1200, 50, 1201,
-	  3} },
-	{REFRESH_75, M1600X1200_R75_HSP, M1600X1200_R75_VSP,
-	 {2160, 1600, 1600, 560, 1664, 192, 1250, 1200, 1200, 50, 1201, 3} }
-
-};
-
-/* 1680x1050 (CVT) */
-static struct crt_mode_table CRTM1680x1050[] = {
-	/* r_rate,              hsp,             vsp  */
-	/* HT,  HA,  HBS, HBE, HSS, HSE,    VT,  VA,  VBS, VBE,  VSS, VSE */
-	{REFRESH_60, M1680x1050_R60_HSP, M1680x1050_R60_VSP,
-	 {2240, 1680, 1680, 560, 1784, 176, 1089, 1050, 1050, 39, 1053,
-	  6} },
-	{REFRESH_75, M1680x1050_R75_HSP, M1680x1050_R75_VSP,
-	 {2272, 1680, 1680, 592, 1800, 176, 1099, 1050, 1050, 49, 1053, 6} }
-};
-
-/* 1680x1050 (CVT Reduce Blanking) */
-static struct crt_mode_table CRTM1680x1050_RB[] = {
-	/* r_rate,              hsp,             vsp   */
-	/* HT,  HA,  HBS, HBE, HSS, HSE,    VT,  VA,  VBS, VBE,  VSS, VSE */
-	{REFRESH_60, M1680x1050_RB_R60_HSP, M1680x1050_RB_R60_VSP,
-	 {1840, 1680, 1680, 160, 1728, 32, 1080, 1050, 1050, 30, 1053, 6} }
-};
-
-/* 1920x1080 (CVT)*/
-static struct crt_mode_table CRTM1920x1080[] = {
-	/*r_rate,hsp,vsp */
-	/*HT,  HA,   HBS,  HBE, HSS,  HSE, VT,  VA,  VBS, VBE, VSS, VSE */
-	{REFRESH_60, M1920X1080_R60_HSP, M1920X1080_R60_VSP,
-	 {2576, 1920, 1920, 656, 2048, 200, 1120, 1080, 1080, 40, 1083, 5} }
-};
-
-/* 1920x1080 (CVT with Reduce Blanking) */
-static struct crt_mode_table CRTM1920x1080_RB[] = {
-	/* r_rate,              hsp,             vsp   */
-	/* HT,  HA,  HBS, HBE, HSS, HSE, VT,  VA,  VBS, VBE, VSS, VSE */
-	{REFRESH_60, M1920X1080_RB_R60_HSP, M1920X1080_RB_R60_VSP,
-	 {2080, 1920, 1920, 160, 1968, 32, 1111, 1080, 1080, 31, 1083, 5} }
-};
-
-/* 1920x1440*/
-static struct crt_mode_table CRTM1920x1440[] = {
-	/*r_rate,hsp,vsp */
-	/*HT,  HA,   HBS,  HBE, HSS,  HSE, VT,  VA,  VBS, VBE, VSS, VSE */
-	{REFRESH_60, M1920X1440_R60_HSP, M1920X1440_R60_VSP,
-	 {2600, 1920, 1920, 680, 2048, 208, 1500, 1440, 1440, 60, 1441,
-	  3} },
-	{REFRESH_75, M1920X1440_R75_HSP, M1920X1440_R75_VSP,
-	 {2640, 1920, 1920, 720, 2064, 224, 1500, 1440, 1440, 60, 1441, 3} }
-};
-
-/* 1400x1050 (CVT) */
-static struct crt_mode_table CRTM1400x1050[] = {
-	/* r_rate,              hsp,             vsp   */
-	/* HT,  HA,  HBS, HBE,  HSS, HSE,   VT,  VA,  VBS, VBE,  VSS, VSE */
-	{REFRESH_60, M1400X1050_R60_HSP, M1400X1050_R60_VSP,
-	 {1864, 1400, 1400, 464, 1488, 144, 1089, 1050, 1050, 39, 1053,
-	  4} },
-	{REFRESH_75, M1400X1050_R75_HSP, M1400X1050_R75_VSP,
-	 {1896, 1400, 1400, 496, 1504, 144, 1099, 1050, 1050, 49, 1053, 4} }
-};
-
-/* 1400x1050 (CVT Reduce Blanking) */
-static struct crt_mode_table CRTM1400x1050_RB[] = {
-	/* r_rate,              hsp,             vsp   */
-	/* HT,  HA,  HBS, HBE,  HSS, HSE,   VT,  VA,  VBS, VBE,  VSS, VSE */
-	{REFRESH_60, M1400X1050_RB_R60_HSP, M1400X1050_RB_R60_VSP,
-	 {1560, 1400, 1400, 160, 1448, 32, 1080, 1050, 1050, 30, 1053, 4} }
-};
-
-/* 960x600 (CVT) */
-static struct crt_mode_table CRTM960x600[] = {
-	/* r_rate,          hsp,             vsp   */
-	/* HT,  HA,  HBS, HBE, HSS, HSE, VT,  VA,  VBS, VBE, VSS, VSE */
-	{REFRESH_60, M960X600_R60_HSP, M960X600_R60_VSP,
-	 {1216, 960, 960, 256, 992, 96, 624, 600, 600, 24, 603, 6} }
-};
-
-/* 1000x600 (GTF) */
-static struct crt_mode_table CRTM1000x600[] = {
-	/* r_rate,              hsp,             vsp   */
-	/* HT,  HA,  HBS, HBE, HSS, HSE, VT,  VA,  VBS, VBE, VSS, VSE */
-	{REFRESH_60, M1000X600_R60_HSP, M1000X600_R60_VSP,
-	 {1288, 1000, 1000, 288, 1040, 104, 622, 600, 600, 22, 601, 3} }
-};
-
-/* 1024x576 (GTF) */
-static struct crt_mode_table CRTM1024x576[] = {
-	/* r_rate,              hsp,             vsp   */
-	/* HT,  HA,  HBS, HBE, HSS, HSE, VT,  VA,  VBS, VBE, VSS, VSE */
-	{REFRESH_60, M1024X576_R60_HSP, M1024X576_R60_VSP,
-	 {1312, 1024, 1024, 288, 1064, 104, 597, 576, 576, 21, 577, 3} }
-};
-
-/* 1088x612 (CVT) */
-static struct crt_mode_table CRTM1088x612[] = {
-	/* r_rate,              hsp,             vsp   */
-	/* HT,  HA,  HBS, HBE, HSS, HSE, VT,  VA,  VBS, VBE, VSS, VSE */
-	{REFRESH_60, M1088X612_R60_HSP, M1088X612_R60_VSP,
-	 {1392, 1088, 1088, 304, 1136, 104, 636, 612, 612, 24, 615, 5} }
-};
-
-/* 1152x720 (CVT) */
-static struct crt_mode_table CRTM1152x720[] = {
-	/* r_rate,              hsp,             vsp   */
-	/* HT,  HA,  HBS, HBE, HSS, HSE, VT,  VA,  VBS, VBE, VSS, VSE */
-	{REFRESH_60, M1152X720_R60_HSP, M1152X720_R60_VSP,
-	 {1488, 1152, 1152, 336, 1208, 112, 748, 720, 720, 28, 723, 6} }
-};
-
-/* 1200x720 (GTF) */
-static struct crt_mode_table CRTM1200x720[] = {
-	/* r_rate,              hsp,             vsp   */
-	/* HT,  HA,  HBS, HBE, HSS, HSE, VT,  VA,  VBS, VBE, VSS, VSE */
-	{REFRESH_60, M1200X720_R60_HSP, M1200X720_R60_VSP,
-	 {1568, 1200, 1200, 368, 1256, 128, 746, 720, 720, 26, 721, 3} }
-};
-
-/* 1200x900 (DCON) */
-static struct crt_mode_table DCON1200x900[] = {
-	/* r_rate,               hsp,               vsp   */
-	{REFRESH_49, M1200X900_R60_HSP, M1200X900_R60_VSP,
-	/* The correct htotal is 1240, but this doesn't raster on VX855. */
-	/* Via suggested changing to a multiple of 16, hence 1264.       */
-	/*  HT,   HA,  HBS, HBE,  HSS, HSE,  VT,  VA, VBS, VBE, VSS, VSE */
-	 {1264, 1200, 1200,  64, 1211,  32, 912, 900, 900,  12, 901, 10} }
-};
-
-/* 1280x600 (GTF) */
-static struct crt_mode_table CRTM1280x600[] = {
-	/* r_rate,              hsp,             vsp   */
-	/* HT,  HA,  HBS, HBE,  HSS, HSE, VT,  VA,  VBS, VBE,  VSS, VSE */
-	{REFRESH_60, M1280x600_R60_HSP, M1280x600_R60_VSP,
-	 {1648, 1280, 1280, 368, 1336, 128, 622, 600, 600, 22, 601, 3} }
-};
-
-/* 1360x768 (CVT) */
-static struct crt_mode_table CRTM1360x768[] = {
-	/* r_rate,              hsp,             vsp   */
-	/* HT,  HA,  HBS, HBE, HSS, HSE, VT,  VA,  VBS, VBE, VSS, VSE */
-	{REFRESH_60, M1360X768_R60_HSP, M1360X768_R60_VSP,
-	 {1776, 1360, 1360, 416, 1432, 136, 798, 768, 768, 30, 771, 5} }
-};
-
-/* 1360x768 (CVT Reduce Blanking) */
-static struct crt_mode_table CRTM1360x768_RB[] = {
-	/* r_rate,              hsp,             vsp   */
-	/* HT,  HA,  HBS, HBE, HSS, HSE, VT,  VA,  VBS, VBE, VSS, VSE */
-	{REFRESH_60, M1360X768_RB_R60_HSP, M1360X768_RB_R60_VSP,
-	 {1520, 1360, 1360, 160, 1408, 32, 790, 768, 768, 22, 771, 5} }
-};
-
-/* 1366x768 (GTF) */
-static struct crt_mode_table CRTM1366x768[] = {
-	/* r_rate,          hsp,             vsp   */
-	/* HT,  HA,  HBS, HBE, HSS, HSE, VT,  VA,  VBS, VBE, VSS, VSE */
-	{REFRESH_60, M1368X768_R60_HSP, M1368X768_R60_VSP,
-	 {1800, 1368, 1368, 432, 1440, 144, 795, 768, 768, 27, 769, 3} },
-	{REFRESH_50, M1368X768_R50_HSP, M1368X768_R50_VSP,
-	 {1768, 1368, 1368, 400, 1424, 144, 791, 768, 768, 23, 769, 3} }
-};
-
-/* 1440x900 (CVT) */
-static struct crt_mode_table CRTM1440x900[] = {
-	/* r_rate,              hsp,             vsp   */
-	/* HT,  HA,  HBS, HBE, HSS, HSE, VT,  VA,  VBS, VBE, VSS, VSE */
-	{REFRESH_60, M1440X900_R60_HSP, M1440X900_R60_VSP,
-	 {1904, 1440, 1440, 464, 1520, 152, 934, 900, 900, 34, 903, 6} },
-	{REFRESH_75, M1440X900_R75_HSP, M1440X900_R75_VSP,
-	 {1936, 1440, 1440, 496, 1536, 152, 942, 900, 900, 42, 903, 6} }
-};
-
-/* 1440x900 (CVT Reduce Blanking) */
-static struct crt_mode_table CRTM1440x900_RB[] = {
-	/* r_rate,              hsp,             vsp   */
-	/* HT,  HA,  HBS, HBE, HSS, HSE, VT,  VA,  VBS, VBE, VSS, VSE */
-	{REFRESH_60, M1440X900_RB_R60_HSP, M1440X900_RB_R60_VSP,
-	 {1600, 1440, 1440, 160, 1488, 32, 926, 900, 900, 26, 903, 6} }
-};
-
-/* 1600x900 (CVT) */
-static struct crt_mode_table CRTM1600x900[] = {
-	/* r_rate,          hsp,             vsp   */
-	/* HT,  HA,  HBS, HBE, HSS, HSE, VT,  VA,  VBS, VBE, VSS, VSE */
-	{REFRESH_60, M1600X900_R60_HSP, M1600X900_R60_VSP,
-	 {2112, 1600, 1600, 512, 1688, 168, 934, 900, 900, 34, 903, 5} }
-};
-
-/* 1600x900 (CVT Reduce Blanking) */
-static struct crt_mode_table CRTM1600x900_RB[] = {
-	/* r_rate,           hsp,        vsp   */
-	/* HT,  HA,  HBS, HBE, HSS, HSE, VT,  VA,  VBS, VBE, VSS, VSE */
-	{REFRESH_60, M1600X900_RB_R60_HSP, M1600X900_RB_R60_VSP,
-	 {1760, 1600, 1600, 160, 1648, 32, 926, 900, 900, 26, 903, 5} }
-};
-
-/* 1600x1024 (GTF) */
-static struct crt_mode_table CRTM1600x1024[] = {
-	/* r_rate,          hsp,             vsp   */
-	/* HT,  HA,  HBS, HBE,  HSS, HSE,   VT,  VA,  VBS, VBE,  VSS, VSE */
-	{REFRESH_60, M1600X1024_R60_HSP, M1600X1024_R60_VSP,
-	 {2144, 1600, 1600, 544, 1704, 168, 1060, 1024, 1024, 36, 1025, 3} }
-};
-
-/* 1792x1344 (DMT) */
-static struct crt_mode_table CRTM1792x1344[] = {
-	/* r_rate,              hsp,             vsp   */
-	/* HT,  HA,  HBS, HBE,  HSS, HSE,   VT,  VA,  VBS, VBE,  VSS, VSE */
-	{REFRESH_60, M1792x1344_R60_HSP, M1792x1344_R60_VSP,
-	 {2448, 1792, 1792, 656, 1920, 200, 1394, 1344, 1344, 50, 1345, 3} }
-};
-
-/* 1856x1392 (DMT) */
-static struct crt_mode_table CRTM1856x1392[] = {
-	/* r_rate,              hsp,             vsp   */
-	/* HT,  HA,  HBS, HBE,  HSS, HSE,   VT,  VA,  VBS, VBE,  VSS, VSE */
-	{REFRESH_60, M1856x1392_R60_HSP, M1856x1392_R60_VSP,
-	 {2528, 1856, 1856, 672, 1952, 224, 1439, 1392, 1392, 47, 1393, 3} }
-};
-
-/* 1920x1200 (CVT) */
-static struct crt_mode_table CRTM1920x1200[] = {
-	/* r_rate,              hsp,             vsp   */
-	/* HT,  HA,  HBS, HBE, HSS, HSE, VT,  VA,  VBS, VBE, VSS, VSE */
-	{REFRESH_60, M1920X1200_R60_HSP, M1920X1200_R60_VSP,
-	 {2592, 1920, 1920, 672, 2056, 200, 1245, 1200, 1200, 45, 1203, 6} }
-};
-
-/* 1920x1200 (CVT with Reduce Blanking) */
-static struct crt_mode_table CRTM1920x1200_RB[] = {
-	/* r_rate,              hsp,             vsp   */
-	/* HT,  HA,  HBS, HBE, HSS, HSE, VT,  VA,  VBS, VBE, VSS, VSE */
-	{REFRESH_60, M1920X1200_RB_R60_HSP, M1920X1200_RB_R60_VSP,
-	 {2080, 1920, 1920, 160, 1968, 32, 1235, 1200, 1200, 35, 1203, 6} }
-};
-
-/* 2048x1536 (CVT) */
-static struct crt_mode_table CRTM2048x1536[] = {
-	/* r_rate,              hsp,             vsp   */
-	/* HT,  HA,  HBS, HBE,  HSS, HSE,   VT,  VA,  VBS, VBE,  VSS, VSE */
-	{REFRESH_60, M2048x1536_R60_HSP, M2048x1536_R60_VSP,
-	 {2800, 2048, 2048, 752, 2200, 224, 1592, 1536, 1536, 56, 1539, 4} }
-};
-
-static struct VideoModeTable viafb_modes[] = {
-	/* Display : 480x640 (GTF) */
-	{CRTM480x640, ARRAY_SIZE(CRTM480x640)},
-
-	/* Display : 640x480 */
-	{CRTM640x480, ARRAY_SIZE(CRTM640x480)},
-
-	/* Display : 720x480 (GTF) */
-	{CRTM720x480, ARRAY_SIZE(CRTM720x480)},
-
-	/* Display : 720x576 (GTF) */
-	{CRTM720x576, ARRAY_SIZE(CRTM720x576)},
-
-	/* Display : 800x600 */
-	{CRTM800x600, ARRAY_SIZE(CRTM800x600)},
-
-	/* Display : 800x480 (CVT) */
-	{CRTM800x480, ARRAY_SIZE(CRTM800x480)},
-
-	/* Display : 848x480 (CVT) */
-	{CRTM848x480, ARRAY_SIZE(CRTM848x480)},
-
-	/* Display : 852x480 (GTF) */
-	{CRTM852x480, ARRAY_SIZE(CRTM852x480)},
-
-	/* Display : 1024x512 (GTF) */
-	{CRTM1024x512, ARRAY_SIZE(CRTM1024x512)},
-
-	/* Display : 1024x600 */
-	{CRTM1024x600, ARRAY_SIZE(CRTM1024x600)},
-
-	/* Display : 1024x768 */
-	{CRTM1024x768, ARRAY_SIZE(CRTM1024x768)},
-
-	/* Display : 1152x864 */
-	{CRTM1152x864, ARRAY_SIZE(CRTM1152x864)},
-
-	/* Display : 1280x768 (GTF) */
-	{CRTM1280x768, ARRAY_SIZE(CRTM1280x768)},
-
-	/* Display : 960x600 (CVT) */
-	{CRTM960x600, ARRAY_SIZE(CRTM960x600)},
-
-	/* Display : 1000x600 (GTF) */
-	{CRTM1000x600, ARRAY_SIZE(CRTM1000x600)},
-
-	/* Display : 1024x576 (GTF) */
-	{CRTM1024x576, ARRAY_SIZE(CRTM1024x576)},
-
-	/* Display : 1088x612 (GTF) */
-	{CRTM1088x612, ARRAY_SIZE(CRTM1088x612)},
-
-	/* Display : 1152x720 (CVT) */
-	{CRTM1152x720, ARRAY_SIZE(CRTM1152x720)},
-
-	/* Display : 1200x720 (GTF) */
-	{CRTM1200x720, ARRAY_SIZE(CRTM1200x720)},
-
-	/* Display : 1200x900 (DCON) */
-	{DCON1200x900, ARRAY_SIZE(DCON1200x900)},
-
-	/* Display : 1280x600 (GTF) */
-	{CRTM1280x600, ARRAY_SIZE(CRTM1280x600)},
-
-	/* Display : 1280x800 (CVT) */
-	{CRTM1280x800, ARRAY_SIZE(CRTM1280x800)},
-
-	/* Display : 1280x960 */
-	{CRTM1280x960, ARRAY_SIZE(CRTM1280x960)},
-
-	/* Display : 1280x1024 */
-	{CRTM1280x1024, ARRAY_SIZE(CRTM1280x1024)},
-
-	/* Display : 1360x768 (CVT) */
-	{CRTM1360x768, ARRAY_SIZE(CRTM1360x768)},
-
-	/* Display : 1366x768 */
-	{CRTM1366x768, ARRAY_SIZE(CRTM1366x768)},
-
-	/* Display : 1368x768 (GTF) */
-	{CRTM1368x768, ARRAY_SIZE(CRTM1368x768)},
-
-	/* Display : 1440x900 (CVT) */
-	{CRTM1440x900, ARRAY_SIZE(CRTM1440x900)},
-
-	/* Display : 1440x1050 (GTF) */
-	{CRTM1440x1050, ARRAY_SIZE(CRTM1440x1050)},
-
-	/* Display : 1600x900 (CVT) */
-	{CRTM1600x900, ARRAY_SIZE(CRTM1600x900)},
-
-	/* Display : 1600x1024 (GTF) */
-	{CRTM1600x1024, ARRAY_SIZE(CRTM1600x1024)},
-
-	/* Display : 1600x1200 */
-	{CRTM1600x1200, ARRAY_SIZE(CRTM1600x1200)},
-
-	/* Display : 1680x1050 (CVT) */
-	{CRTM1680x1050, ARRAY_SIZE(CRTM1680x1050)},
-
-	/* Display : 1792x1344 (DMT) */
-	{CRTM1792x1344, ARRAY_SIZE(CRTM1792x1344)},
-
-	/* Display : 1856x1392 (DMT) */
-	{CRTM1856x1392, ARRAY_SIZE(CRTM1856x1392)},
-
-	/* Display : 1920x1440 */
-	{CRTM1920x1440, ARRAY_SIZE(CRTM1920x1440)},
-
-	/* Display : 2048x1536 */
-	{CRTM2048x1536, ARRAY_SIZE(CRTM2048x1536)},
-
-	/* Display : 1280x720 */
-	{CRTM1280x720, ARRAY_SIZE(CRTM1280x720)},
-
-	/* Display : 1920x1080 (CVT) */
-	{CRTM1920x1080, ARRAY_SIZE(CRTM1920x1080)},
-
-	/* Display : 1920x1200 (CVT) */
-	{CRTM1920x1200, ARRAY_SIZE(CRTM1920x1200)},
-
-	/* Display : 1400x1050 (CVT) */
-	{CRTM1400x1050, ARRAY_SIZE(CRTM1400x1050)}
-};
-
-static struct VideoModeTable viafb_rb_modes[] = {
-	/* Display : 1360x768 (CVT Reduce Blanking) */
-	{CRTM1360x768_RB, ARRAY_SIZE(CRTM1360x768_RB)},
-
-	/* Display : 1440x900 (CVT Reduce Blanking) */
-	{CRTM1440x900_RB, ARRAY_SIZE(CRTM1440x900_RB)},
-
-	/* Display : 1400x1050 (CVT Reduce Blanking) */
-	{CRTM1400x1050_RB, ARRAY_SIZE(CRTM1400x1050_RB)},
-
-	/* Display : 1600x900 (CVT Reduce Blanking) */
-	{CRTM1600x900_RB, ARRAY_SIZE(CRTM1600x900_RB)},
-
-	/* Display : 1680x1050 (CVT Reduce Blanking) */
-	{CRTM1680x1050_RB, ARRAY_SIZE(CRTM1680x1050_RB)},
-
-	/* Display : 1920x1080 (CVT Reduce Blanking) */
-	{CRTM1920x1080_RB, ARRAY_SIZE(CRTM1920x1080_RB)},
-
-	/* Display : 1920x1200 (CVT Reduce Blanking) */
-	{CRTM1920x1200_RB, ARRAY_SIZE(CRTM1920x1200_RB)}
-};
+static const struct fb_videomode viafb_modes[] = {
+	{NULL, 60, 480, 640, 40285, 72, 24, 19, 1, 48, 3, FB_SYNC_VERT_HIGH_ACT, 0, 0},
+	{NULL, 60, 640, 480, 39682, 48, 16, 33, 10, 96, 2, 0, 0, 0},
+	{NULL, 75, 640, 480, 31746, 120, 16, 16, 1, 64, 3, 0, 0, 0},
+	{NULL, 85, 640, 480, 27780, 80, 56, 25, 1, 56, 3, 0, 0, 0},
+	{NULL, 100, 640, 480, 23167, 104, 40, 25, 1, 64, 3, FB_SYNC_VERT_HIGH_ACT, 0, 0},
+	{NULL, 120, 640, 480, 19081, 104, 40, 31, 1, 64, 3, FB_SYNC_VERT_HIGH_ACT, 0, 0},
+	{NULL, 60, 720, 480, 37426, 88, 16, 13, 1, 72, 3, FB_SYNC_VERT_HIGH_ACT, 0, 0},
+	{NULL, 60, 720, 576, 30611, 96, 24, 17, 1, 72, 3, FB_SYNC_VERT_HIGH_ACT, 0, 0},
+	{NULL, 60, 800, 600, 25131, 88, 40, 23, 1, 128, 4, FB_SYNC_HOR_HIGH_ACT | FB_SYNC_VERT_HIGH_ACT, 0, 0},
+	{NULL, 75, 800, 600, 20202, 160, 16, 21, 1, 80, 3, FB_SYNC_HOR_HIGH_ACT | FB_SYNC_VERT_HIGH_ACT, 0, 0},
+	{NULL, 85, 800, 600, 17790, 152, 32, 27, 1, 64, 3, FB_SYNC_HOR_HIGH_ACT | FB_SYNC_VERT_HIGH_ACT, 0, 0},
+	{NULL, 100, 800, 600, 14667, 136, 48, 32, 1, 88, 3, FB_SYNC_VERT_HIGH_ACT, 0, 0},
+	{NULL, 120, 800, 600, 11911, 144, 56, 39, 1, 88, 3, FB_SYNC_VERT_HIGH_ACT, 0, 0},
+	{NULL, 60, 800, 480, 33602, 96, 24, 10, 3, 72, 7, FB_SYNC_VERT_HIGH_ACT, 0, 0},
+	{NULL, 60, 848, 480, 31565, 104, 24, 12, 3, 80, 5, FB_SYNC_VERT_HIGH_ACT, 0, 0},
+	{NULL, 60, 856, 480, 31517, 104, 16, 13, 1, 88, 3, FB_SYNC_VERT_HIGH_ACT, 0, 0},
+	{NULL, 60, 1024, 512, 24218, 136, 32, 15, 1, 104, 3, FB_SYNC_VERT_HIGH_ACT, 0, 0},
+	{NULL, 60, 1024, 600, 20423, 144, 40, 18, 1, 104, 3, FB_SYNC_VERT_HIGH_ACT, 0, 0},
+	{NULL, 60, 1024, 768, 15385, 160, 24, 29, 3, 136, 6, 0, 0, 0},
+	{NULL, 75, 1024, 768, 12703, 176, 16, 28, 1, 96, 3, FB_SYNC_HOR_HIGH_ACT | FB_SYNC_VERT_HIGH_ACT, 0, 0},
+	{NULL, 85, 1024, 768, 10581, 208, 48, 36, 1, 96, 3, FB_SYNC_HOR_HIGH_ACT | FB_SYNC_VERT_HIGH_ACT, 0, 0},
+	{NULL, 100, 1024, 768, 8825, 184, 72, 42, 1, 112, 3, FB_SYNC_VERT_HIGH_ACT, 0, 0},
+	{NULL, 75, 1152, 864, 9259, 256, 64, 32, 1, 128, 3, FB_SYNC_HOR_HIGH_ACT | FB_SYNC_VERT_HIGH_ACT, 0, 0},
+	{NULL, 60, 1280, 768, 12478, 200, 64, 23, 1, 136, 3, FB_SYNC_VERT_HIGH_ACT, 0, 0},
+	{NULL, 50, 1280, 768, 15342, 184, 56, 19, 1, 128, 3, FB_SYNC_VERT_HIGH_ACT, 0, 0},
+	{NULL, 60, 960, 600, 21964, 128, 32, 15, 3, 96, 6, FB_SYNC_VERT_HIGH_ACT, 0, 0},
+	{NULL, 60, 1000, 600, 20803, 144, 40, 18, 1, 104, 3, FB_SYNC_VERT_HIGH_ACT, 0, 0},
+	{NULL, 60, 1024, 576, 21278, 144, 40, 17, 1, 104, 3, FB_SYNC_VERT_HIGH_ACT, 0, 0},
+	{NULL, 60, 1088, 612, 18825, 152, 48, 16, 3, 104, 5, FB_SYNC_VERT_HIGH_ACT, 0, 0},
+	{NULL, 60, 1152, 720, 14974, 168, 56, 19, 3, 112, 6, FB_SYNC_VERT_HIGH_ACT, 0, 0},
+	{NULL, 60, 1200, 720, 14248, 184, 56, 22, 1, 128, 3, FB_SYNC_VERT_HIGH_ACT, 0, 0},
+	{NULL, 49, 1200, 900, 17703, 21, 11, 1, 1, 32, 10, FB_SYNC_HOR_HIGH_ACT | FB_SYNC_VERT_HIGH_ACT, 0, 0},
+	{NULL, 60, 1280, 600, 16259, 184, 56, 18, 1, 128, 3, FB_SYNC_VERT_HIGH_ACT, 0, 0},
+	{NULL, 60, 1280, 800, 11938, 200, 72, 22, 3, 128, 6, FB_SYNC_VERT_HIGH_ACT, 0, 0},
+	{NULL, 60, 1280, 960, 9259, 312, 96, 36, 1, 112, 3, FB_SYNC_HOR_HIGH_ACT | FB_SYNC_VERT_HIGH_ACT, 0, 0},
+	{NULL, 60, 1280, 1024, 9262, 248, 48, 38, 1, 112, 3, FB_SYNC_HOR_HIGH_ACT | FB_SYNC_VERT_HIGH_ACT, 0, 0},
+	{NULL, 75, 1280, 1024, 7409, 248, 16, 38, 1, 144, 3, FB_SYNC_HOR_HIGH_ACT | FB_SYNC_VERT_HIGH_ACT, 0, 0},
+	{NULL, 85, 1280, 1024, 6351, 224, 64, 44, 1, 160, 3, FB_SYNC_HOR_HIGH_ACT | FB_SYNC_VERT_HIGH_ACT, 0, 0},
+	{NULL, 60, 1360, 768, 11759, 208, 72, 22, 3, 136, 5, FB_SYNC_HOR_HIGH_ACT | FB_SYNC_VERT_HIGH_ACT, 0, 0},
+	{NULL, 60, 1368, 768, 11646, 216, 72, 23, 1, 144, 3, FB_SYNC_VERT_HIGH_ACT, 0, 0},
+	{NULL, 50, 1368, 768, 14301, 200, 56, 19, 1, 144, 3, FB_SYNC_VERT_HIGH_ACT, 0, 0},
+	{NULL, 60, 1368, 768, 11646, 216, 72, 23, 1, 144, 3, FB_SYNC_VERT_HIGH_ACT, 0, 0},
+	{NULL, 60, 1440, 900, 9372, 232, 80, 25, 3, 152, 6, FB_SYNC_VERT_HIGH_ACT, 0, 0},
+	{NULL, 75, 1440, 900, 7311, 248, 96, 33, 3, 152, 6, FB_SYNC_VERT_HIGH_ACT, 0, 0},
+	{NULL, 60, 1440, 1040, 7993, 248, 96, 33, 1, 152, 3, FB_SYNC_VERT_HIGH_ACT, 0, 0},
+	{NULL, 60, 1600, 900, 8449, 256, 88, 26, 3, 168, 5, FB_SYNC_VERT_HIGH_ACT, 0, 0},
+	{NULL, 60, 1600, 1024, 7333, 272, 104, 32, 1, 168, 3, FB_SYNC_VERT_HIGH_ACT, 0, 0},
+	{NULL, 60, 1600, 1200, 6172, 304, 64, 46, 1, 192, 3, FB_SYNC_HOR_HIGH_ACT | FB_SYNC_VERT_HIGH_ACT, 0, 0},
+	{NULL, 75, 1600, 1200, 4938, 304, 64, 46, 1, 192, 3, FB_SYNC_HOR_HIGH_ACT | FB_SYNC_VERT_HIGH_ACT, 0, 0},
+	{NULL, 60, 1680, 1050, 6832, 280, 104, 30, 3, 176, 6, 0, 0, 0},
+	{NULL, 75, 1680, 1050, 5339, 296, 120, 40, 3, 176, 6, FB_SYNC_VERT_HIGH_ACT, 0, 0},
+	{NULL, 60, 1792, 1344, 4883, 328, 128, 46, 1, 200, 3, FB_SYNC_VERT_HIGH_ACT, 0, 0},
+	{NULL, 60, 1856, 1392, 4581, 352, 96, 43, 1, 224, 3, FB_SYNC_VERT_HIGH_ACT, 0, 0},
+	{NULL, 60, 1920, 1440, 4273, 344, 128, 56, 1, 208, 3, FB_SYNC_VERT_HIGH_ACT, 0, 0},
+	{NULL, 75, 1920, 1440, 3367, 352, 144, 56, 1, 224, 3, FB_SYNC_VERT_HIGH_ACT, 0, 0},
+	{NULL, 60, 2048, 1536, 3738, 376, 152, 49, 3, 224, 4, FB_SYNC_VERT_HIGH_ACT, 0, 0},
+	{NULL, 60, 1280, 720, 13484, 216, 112, 20, 5, 40, 5, FB_SYNC_VERT_HIGH_ACT, 0, 0},
+	{NULL, 50, 1280, 720, 16538, 176, 48, 17, 1, 128, 3, FB_SYNC_VERT_HIGH_ACT, 0, 0},
+	{NULL, 60, 1920, 1080, 5776, 328, 128, 32, 3, 200, 5, FB_SYNC_VERT_HIGH_ACT, 0, 0},
+	{NULL, 60, 1920, 1200, 5164, 336, 136, 36, 3, 200, 6, FB_SYNC_VERT_HIGH_ACT, 0, 0},
+	{NULL, 60, 1400, 1050, 8210, 232, 88, 32, 3, 144, 4, FB_SYNC_VERT_HIGH_ACT, 0, 0},
+	{NULL, 75, 1400, 1050, 6398, 248, 104, 42, 3, 144, 4, FB_SYNC_VERT_HIGH_ACT, 0, 0} };
+
+static const struct fb_videomode viafb_rb_modes[] = {
+	{NULL, 60, 1360, 768, 13879, 80, 48, 14, 3, 32, 5, FB_SYNC_HOR_HIGH_ACT, 0, 0},
+	{NULL, 60, 1440, 900, 11249, 80, 48, 17, 3, 32, 6, FB_SYNC_HOR_HIGH_ACT, 0, 0},
+	{NULL, 60, 1400, 1050, 9892, 80, 48, 23, 3, 32, 4, FB_SYNC_HOR_HIGH_ACT, 0, 0},
+	{NULL, 60, 1600, 900, 10226, 80, 48, 18, 3, 32, 5, FB_SYNC_HOR_HIGH_ACT, 0, 0},
+	{NULL, 60, 1680, 1050, 8387, 80, 48, 21, 3, 32, 6, FB_SYNC_HOR_HIGH_ACT, 0, 0},
+	{NULL, 60, 1920, 1080, 7212, 80, 48, 23, 3, 32, 5, FB_SYNC_HOR_HIGH_ACT, 0, 0},
+	{NULL, 60, 1920, 1200, 6488, 80, 48, 26, 3, 32, 6, FB_SYNC_HOR_HIGH_ACT, 0, 0} };
 
 int NUM_TOTAL_CN400_ModeXregs = ARRAY_SIZE(CN400_ModeXregs);
 int NUM_TOTAL_CN700_ModeXregs = ARRAY_SIZE(CN700_ModeXregs);
@@ -863,56 +350,34 @@ int NUM_TOTAL_CLE266_ModeXregs = ARRAY_SIZE(CLE266_ModeXregs);
 int NUM_TOTAL_PATCH_MODE = ARRAY_SIZE(res_patch_table);
 
 
-static struct VideoModeTable *get_modes(struct VideoModeTable *vmt, int n,
-	int hres, int vres)
-{
-	int i;
-
-	for (i = 0; i < n; i++)
-		if (vmt[i].mode_array &&
-			vmt[i].crtc[0].crtc.hor_addr == hres &&
-			vmt[i].crtc[0].crtc.ver_addr == vres)
-			return &viafb_modes[i];
-
-	return NULL;
-}
-
-static struct crt_mode_table *get_best_mode(struct VideoModeTable *vmt,
-	int refresh)
+static const struct fb_videomode *get_best_mode(
+	const struct fb_videomode *modes, int n,
+	int hres, int vres, int refresh)
 {
-	struct crt_mode_table *best;
+	const struct fb_videomode *best = NULL;
 	int i;
 
-	if (!vmt)
-		return NULL;
+	for (i = 0; i < n; i++) {
+		if (modes[i].xres != hres || modes[i].yres != vres)
+			continue;
 
-	best = &vmt->crtc[0];
-	for (i = 1; i < vmt->mode_array; i++) {
-		if (abs(vmt->crtc[i].refresh_rate - refresh)
-			< abs(best->refresh_rate - refresh))
-			best = &vmt->crtc[i];
+		if (!best || abs(modes[i].refresh - refresh) <
+			abs(best->refresh - refresh))
+			best = &modes[i];
 	}
 
 	return best;
 }
 
-static struct VideoModeTable *viafb_get_mode(int hres, int vres)
-{
-	return get_modes(viafb_modes, ARRAY_SIZE(viafb_modes), hres, vres);
-}
-
-struct crt_mode_table *viafb_get_best_mode(int hres, int vres, int refresh)
+const struct fb_videomode *viafb_get_best_mode(int hres, int vres, int refresh)
 {
-	return get_best_mode(viafb_get_mode(hres, vres), refresh);
+	return get_best_mode(viafb_modes, ARRAY_SIZE(viafb_modes),
+		hres, vres, refresh);
 }
 
-static struct VideoModeTable *viafb_get_rb_mode(int hres, int vres)
-{
-	return get_modes(viafb_rb_modes, ARRAY_SIZE(viafb_rb_modes), hres,
-		vres);
-}
-
-struct crt_mode_table *viafb_get_best_rb_mode(int hres, int vres, int refresh)
+const struct fb_videomode *viafb_get_best_rb_mode(int hres, int vres,
+	int refresh)
 {
-	return get_best_mode(viafb_get_rb_mode(hres, vres), refresh);
+	return get_best_mode(viafb_rb_modes, ARRAY_SIZE(viafb_rb_modes),
+		hres, vres, refresh);
 }
diff --git a/drivers/video/via/viamode.h b/drivers/video/via/viamode.h
index 5917a2b..dd19106 100644
--- a/drivers/video/via/viamode.h
+++ b/drivers/video/via/viamode.h
@@ -31,11 +31,6 @@ struct VPITTable {
 	unsigned char AR[StdAR];
 };
 
-struct VideoModeTable {
-	struct crt_mode_table *crtc;
-	int mode_array;
-};
-
 struct patch_table {
 	int table_length;
 	struct io_reg *io_reg_table;
@@ -60,7 +55,9 @@ extern struct io_reg PM1024x768[];
 extern struct patch_table res_patch_table[];
 extern struct VPITTable VPIT;
 
-struct crt_mode_table *viafb_get_best_mode(int hres, int vres, int refresh);
-struct crt_mode_table *viafb_get_best_rb_mode(int hres, int vres, int refresh);
+const struct fb_videomode *viafb_get_best_mode(int hres, int vres,
+	int refresh);
+const struct fb_videomode *viafb_get_best_rb_mode(int hres, int vres,
+	int refresh);
 
 #endif /* __VIAMODE_H__ */
-- 
1.7.9

