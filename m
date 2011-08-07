Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753832Ab1HGPeI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Aug 2011 11:34:08 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:60246 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753301Ab1HGPeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Aug 2011 11:34:05 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX18koz0Dhnckp2iXRjtwxAJu8S4IK77uLlMxRxG1/c
	xn9IsdEOLQe/Hl
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [PATCH 6/6] viafb: get rid of the remaining modetable structure assumptions
Date: Sun,  7 Aug 2011 15:52:40 +0000
Message-Id: <5dd72f12df00cbabc16de770b79b17ced63138be.1312730860.git.FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <cover.1312730859.git.FlorianSchandinat@gmx.de>
References: <cover.1312730859.git.FlorianSchandinat@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the remaining places where assumptions about the
structure of the modetable were made. Aside from some places where
assumptions are made that certain modes are in the modetable the
only code dealing with the modetable and not just a single mode is
in viamode. This will allow chaniging the modetable and use other
sources for videomodes like the subsystem or EDID.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
---
 drivers/video/via/global.c   |    2 ++
 drivers/video/via/global.h   |    2 ++
 drivers/video/via/hw.c       |   23 +++++++----------------
 drivers/video/via/hw.h       |    3 +--
 drivers/video/via/viafbdev.c |   14 +++-----------
 drivers/video/via/viamode.c  |    4 ++--
 drivers/video/via/viamode.h  |    2 --
 7 files changed, 17 insertions(+), 33 deletions(-)

diff --git a/drivers/video/via/global.c b/drivers/video/via/global.c
index e10d824..3102171 100644
--- a/drivers/video/via/global.c
+++ b/drivers/video/via/global.c
@@ -35,6 +35,8 @@ int viafb_LCD_ON ;
 int viafb_LCD2_ON;
 int viafb_SAMM_ON;
 int viafb_dual_fb;
+unsigned int viafb_second_xres = 640;
+unsigned int viafb_second_yres = 480;
 int viafb_hotplug_Xres = 640;
 int viafb_hotplug_Yres = 480;
 int viafb_hotplug_bpp = 32;
diff --git a/drivers/video/via/global.h b/drivers/video/via/global.h
index ff969dc..275dbbb 100644
--- a/drivers/video/via/global.h
+++ b/drivers/video/via/global.h
@@ -67,6 +67,8 @@ extern int viafb_lcd_dsp_method;
 extern int viafb_lcd_mode;
 
 extern int viafb_CRT_ON;
+extern unsigned int viafb_second_xres;
+extern unsigned int viafb_second_yres;
 extern int viafb_hotplug_Xres;
 extern int viafb_hotplug_Yres;
 extern int viafb_hotplug_bpp;
diff --git a/drivers/video/via/hw.c b/drivers/video/via/hw.c
index 30668bd..d5aaca9 100644
--- a/drivers/video/via/hw.c
+++ b/drivers/video/via/hw.c
@@ -1840,23 +1840,16 @@ static void hw_init(void)
 	load_fix_bit_crtc_reg();
 }
 
-int viafb_setmode(struct VideoModeTable *vmode_tbl, int video_bpp,
-	struct VideoModeTable *vmode_tbl1, int video_bpp1)
+int viafb_setmode(int video_bpp, int video_bpp1)
 {
 	int j;
 	int port;
 	u32 devices = viaparinfo->shared->iga1_devices
 		| viaparinfo->shared->iga2_devices;
 	u8 value, index, mask;
-	struct crt_mode_table *crt_timing;
-	struct crt_mode_table *crt_timing1 = NULL;
 	struct fb_var_screeninfo var2;
 
 	device_screen_off();
-	crt_timing = vmode_tbl->crtc;
-	if (viafb_SAMM_ON == 1)
-		crt_timing1 = vmode_tbl1->crtc;
-
 	device_off();
 	via_set_state(devices, VIA_STATE_OFF);
 
@@ -1865,9 +1858,8 @@ int viafb_setmode(struct VideoModeTable *vmode_tbl, int video_bpp,
 	/* Update Patch Register */
 
 	if ((viaparinfo->chip_info->gfx_chip_name == UNICHROME_CLE266
-	    || viaparinfo->chip_info->gfx_chip_name == UNICHROME_K400)
-	    && vmode_tbl->crtc[0].crtc.hor_addr == 1024
-	    && vmode_tbl->crtc[0].crtc.ver_addr == 768) {
+		|| viaparinfo->chip_info->gfx_chip_name == UNICHROME_K400)
+		&& viafbinfo->var.xres == 1024 && viafbinfo->var.yres == 768) {
 		for (j = 0; j < res_patch_table[0].table_length; j++) {
 			index = res_patch_table[0].io_reg_table[j].index;
 			port = res_patch_table[0].io_reg_table[j].port;
@@ -1898,8 +1890,7 @@ int viafb_setmode(struct VideoModeTable *vmode_tbl, int video_bpp,
 		var2 = viafbinfo1->var;
 	} else if (viafb_SAMM_ON) {
 		viafb_fill_var_timing_info(&var2, viafb_get_best_mode(
-			vmode_tbl1->crtc->crtc.hor_addr,
-			vmode_tbl1->crtc->crtc.ver_addr, viafb_refresh1));
+			viafb_second_xres, viafb_second_yres, viafb_refresh1));
 		var2.bits_per_pixel = viafbinfo->var.bits_per_pixel;
 	}
 
@@ -1916,7 +1907,7 @@ int viafb_setmode(struct VideoModeTable *vmode_tbl, int video_bpp,
 		/* Patch if set_hres is not 8 alignment (1366) to viafb_setmode
 		to 8 alignment (1368),there is several pixels (2 pixels)
 		on right side of screen. */
-		if (vmode_tbl->crtc[0].crtc.hor_addr % 8) {
+		if (viafbinfo->var.xres % 8) {
 			viafb_unlock_crt();
 			viafb_write_reg(CR02, VIACR,
 				viafb_read_reg(VIACR, CR02) - 1);
@@ -1974,8 +1965,8 @@ int viafb_setmode(struct VideoModeTable *vmode_tbl, int video_bpp,
 
 	/* If set mode normally, save resolution information for hot-plug . */
 	if (!viafb_hotplug) {
-		viafb_hotplug_Xres = vmode_tbl->crtc[0].crtc.hor_addr;
-		viafb_hotplug_Yres = vmode_tbl->crtc[0].crtc.ver_addr;
+		viafb_hotplug_Xres = viafbinfo->var.xres;
+		viafb_hotplug_Yres = viafbinfo->var.yres;
 		viafb_hotplug_bpp = video_bpp;
 		viafb_hotplug_refresh = viafb_refresh;
 
diff --git a/drivers/video/via/hw.h b/drivers/video/via/hw.h
index 46f65da..4db5b6e 100644
--- a/drivers/video/via/hw.h
+++ b/drivers/video/via/hw.h
@@ -657,8 +657,7 @@ void viafb_load_FIFO_reg(int set_iga, int hor_active, int ver_active);
 void viafb_set_dpa_gfx(int output_interface, struct GFX_DPA_SETTING\
 					*p_gfx_dpa_setting);
 
-int viafb_setmode(struct VideoModeTable *vmode_tbl, int video_bpp,
-	struct VideoModeTable *vmode_tbl1, int video_bpp1);
+int viafb_setmode(int video_bpp, int video_bpp1);
 void viafb_fill_var_timing_info(struct fb_var_screeninfo *var,
 	struct crt_mode_table *mode);
 void __devinit viafb_init_chip_info(int chip_type);
diff --git a/drivers/video/via/viafbdev.c b/drivers/video/via/viafbdev.c
index 0c0ef95..3856784 100644
--- a/drivers/video/via/viafbdev.c
+++ b/drivers/video/via/viafbdev.c
@@ -38,8 +38,6 @@ static char *viafb_mode1;
 static int viafb_bpp = 32;
 static int viafb_bpp1 = 32;
 
-static unsigned int viafb_second_xres = 640;
-static unsigned int viafb_second_yres = 480;
 static unsigned int viafb_second_offset;
 static int viafb_second_size;
 
@@ -267,7 +265,6 @@ static int viafb_check_var(struct fb_var_screeninfo *var,
 static int viafb_set_par(struct fb_info *info)
 {
 	struct viafb_par *viapar = info->par;
-	struct VideoModeTable *vmode_entry, *vmode_entry1 = NULL;
 	int refresh;
 	DEBUG_MSG(KERN_INFO "viafb_set_par!\n");
 
@@ -276,10 +273,7 @@ static int viafb_set_par(struct fb_info *info)
 	viafb_update_device_setting(viafbinfo->var.xres, viafbinfo->var.yres,
 		viafbinfo->var.bits_per_pixel, 0);
 
-	vmode_entry = viafb_get_mode(viafbinfo->var.xres, viafbinfo->var.yres);
 	if (viafb_dual_fb) {
-		vmode_entry1 = viafb_get_mode(viafbinfo1->var.xres,
-			viafbinfo1->var.yres);
 		viafb_update_device_setting(viafbinfo1->var.xres,
 			viafbinfo1->var.yres, viafbinfo1->var.bits_per_pixel,
 			1);
@@ -287,8 +281,6 @@ static int viafb_set_par(struct fb_info *info)
 		DEBUG_MSG(KERN_INFO
 		"viafb_second_xres = %d, viafb_second_yres = %d, bpp = %d\n",
 			  viafb_second_xres, viafb_second_yres, viafb_bpp1);
-		vmode_entry1 = viafb_get_mode(viafb_second_xres,
-			viafb_second_yres);
 
 		viafb_update_device_setting(viafb_second_xres,
 			viafb_second_yres, viafb_bpp1, 1);
@@ -296,7 +288,8 @@ static int viafb_set_par(struct fb_info *info)
 
 	refresh = viafb_get_refresh(info->var.xres, info->var.yres,
 		get_var_refresh(&info->var));
-	if (vmode_entry) {
+	if (viafb_get_best_mode(viafbinfo->var.xres, viafbinfo->var.yres,
+		refresh)) {
 		if (viafb_dual_fb && viapar->iga_path == IGA2) {
 			viafb_bpp1 = info->var.bits_per_pixel;
 			viafb_refresh1 = refresh;
@@ -309,8 +302,7 @@ static int viafb_set_par(struct fb_info *info)
 			info->flags &= ~FBINFO_HWACCEL_DISABLED;
 		else
 			info->flags |= FBINFO_HWACCEL_DISABLED;
-		viafb_setmode(vmode_entry, info->var.bits_per_pixel,
-			vmode_entry1, viafb_bpp1);
+		viafb_setmode(info->var.bits_per_pixel, viafb_bpp1);
 		viafb_pan_display(&info->var, info);
 	}
 
diff --git a/drivers/video/via/viamode.c b/drivers/video/via/viamode.c
index 88096e5..0911cac 100644
--- a/drivers/video/via/viamode.c
+++ b/drivers/video/via/viamode.c
@@ -896,7 +896,7 @@ static struct crt_mode_table *get_best_mode(struct VideoModeTable *vmt,
 	return best;
 }
 
-struct VideoModeTable *viafb_get_mode(int hres, int vres)
+static struct VideoModeTable *viafb_get_mode(int hres, int vres)
 {
 	return get_modes(viafb_modes, ARRAY_SIZE(viafb_modes), hres, vres);
 }
@@ -906,7 +906,7 @@ struct crt_mode_table *viafb_get_best_mode(int hres, int vres, int refresh)
 	return get_best_mode(viafb_get_mode(hres, vres), refresh);
 }
 
-struct VideoModeTable *viafb_get_rb_mode(int hres, int vres)
+static struct VideoModeTable *viafb_get_rb_mode(int hres, int vres)
 {
 	return get_modes(viafb_rb_modes, ARRAY_SIZE(viafb_rb_modes), hres,
 		vres);
diff --git a/drivers/video/via/viamode.h b/drivers/video/via/viamode.h
index 0396581..5917a2b 100644
--- a/drivers/video/via/viamode.h
+++ b/drivers/video/via/viamode.h
@@ -60,9 +60,7 @@ extern struct io_reg PM1024x768[];
 extern struct patch_table res_patch_table[];
 extern struct VPITTable VPIT;
 
-struct VideoModeTable *viafb_get_mode(int hres, int vres);
 struct crt_mode_table *viafb_get_best_mode(int hres, int vres, int refresh);
-struct VideoModeTable *viafb_get_rb_mode(int hres, int vres);
 struct crt_mode_table *viafb_get_best_rb_mode(int hres, int vres, int refresh);
 
 #endif /* __VIAMODE_H__ */
-- 
1.6.3.2

