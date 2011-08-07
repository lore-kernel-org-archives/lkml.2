Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753521Ab1HGPbK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Aug 2011 11:31:10 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:51257 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751917Ab1HGPbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Aug 2011 11:31:08 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX1808HNhYf400Je1W38vc8EoT4/t33YvFs0qhHa1Sd
	iumDLyy1h/rslp
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [PATCH 1/6] viafb: add new funcions to select a single mode
Date: Sun,  7 Aug 2011 15:49:36 +0000
Message-Id: <94715ba97508dd42919a7525e362efb00dde1271.1312730860.git.FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <cover.1312730859.git.FlorianSchandinat@gmx.de>
References: <cover.1312730859.git.FlorianSchandinat@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces 2 new functions for selecting a single mode
based on hres, vres and refresh rate and changes some uses to use
those. The advantage is that it is less error prone than doing the
selection based on refresh rate everywhere and allows replacing the
modetable structure. This includes a little change that users may
notice: If a refresh rate was given as module parameters but does
not exist in the modetable prior to this patch a refresh rate of 60
was assumed and after this patch the closest supported refresh rate
to the one provided by the user is used.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
---
 drivers/video/via/hw.c       |   45 ++++++++-------------------------
 drivers/video/via/hw.h       |    4 +-
 drivers/video/via/viafbdev.c |   24 +++++++++---------
 drivers/video/via/viamode.c  |   56 ++++++++++++++++++++++++++++++++---------
 drivers/video/via/viamode.h  |    2 +
 5 files changed, 70 insertions(+), 61 deletions(-)

diff --git a/drivers/video/via/hw.c b/drivers/video/via/hw.c
index c5e7833..5e69c20 100644
--- a/drivers/video/via/hw.c
+++ b/drivers/video/via/hw.c
@@ -2035,40 +2035,24 @@ int viafb_setmode(struct VideoModeTable *vmode_tbl, int video_bpp,
 
 int viafb_get_pixclock(int hres, int vres, int vmode_refresh)
 {
-	int i;
 	struct crt_mode_table *best;
-	struct VideoModeTable *vmode = viafb_get_mode(hres, vres);
 
-	if (!vmode)
+	best = viafb_get_best_mode(hres, vres, vmode_refresh);
+	if (!best)
 		return RES_640X480_60HZ_PIXCLOCK;
 
-	best = &vmode->crtc[0];
-	for (i = 1; i < vmode->mode_array; i++) {
-		if (abs(vmode->crtc[i].refresh_rate - vmode_refresh)
-			< abs(best->refresh_rate - vmode_refresh))
-			best = &vmode->crtc[i];
-	}
-
 	return 1000000000 / (best->crtc.hor_total * best->crtc.ver_total)
 		* 1000 / best->refresh_rate;
 }
 
 int viafb_get_refresh(int hres, int vres, u32 long_refresh)
 {
-	int i;
 	struct crt_mode_table *best;
-	struct VideoModeTable *vmode = viafb_get_mode(hres, vres);
 
-	if (!vmode)
+	best = viafb_get_best_mode(hres, vres, long_refresh);
+	if (!best)
 		return 60;
 
-	best = &vmode->crtc[0];
-	for (i = 1; i < vmode->mode_array; i++) {
-		if (abs(vmode->crtc[i].refresh_rate - long_refresh)
-			< abs(best->refresh_rate - long_refresh))
-			best = &vmode->crtc[i];
-	}
-
 	if (abs(best->refresh_rate - long_refresh) > 3) {
 		if (hres == 1200 && vres == 900)
 			return 49; /* OLPC DCON only supports 50 Hz */
@@ -2170,21 +2154,14 @@ void viafb_set_dpa_gfx(int output_interface, struct GFX_DPA_SETTING\
 }
 
 /*According var's xres, yres fill var's other timing information*/
-void viafb_fill_var_timing_info(struct fb_var_screeninfo *var, int refresh,
-	struct VideoModeTable *vmode_tbl)
+void viafb_fill_var_timing_info(struct fb_var_screeninfo *var,
+	struct crt_mode_table *mode)
 {
-	struct crt_mode_table *crt_timing = NULL;
 	struct display_timing crt_reg;
-	int i = 0, index = 0;
-	crt_timing = vmode_tbl->crtc;
-	for (i = 0; i < vmode_tbl->mode_array; i++) {
-		index = i;
-		if (crt_timing[i].refresh_rate == refresh)
-			break;
-	}
 
-	crt_reg = crt_timing[index].crtc;
-	var->pixclock = viafb_get_pixclock(var->xres, var->yres, refresh);
+	crt_reg = mode->crtc;
+	var->pixclock = viafb_get_pixclock(var->xres, var->yres,
+		mode->refresh_rate);
 	var->left_margin =
 	    crt_reg.hor_total - (crt_reg.hor_sync_start + crt_reg.hor_sync_end);
 	var->right_margin = crt_reg.hor_sync_start - crt_reg.hor_addr;
@@ -2194,8 +2171,8 @@ void viafb_fill_var_timing_info(struct fb_var_screeninfo *var, int refresh,
 	var->lower_margin = crt_reg.ver_sync_start - crt_reg.ver_addr;
 	var->vsync_len = crt_reg.ver_sync_end;
 	var->sync = 0;
-	if (crt_timing[index].h_sync_polarity == POSITIVE)
+	if (mode->h_sync_polarity == POSITIVE)
 		var->sync |= FB_SYNC_HOR_HIGH_ACT;
-	if (crt_timing[index].v_sync_polarity == POSITIVE)
+	if (mode->v_sync_polarity == POSITIVE)
 		var->sync |= FB_SYNC_VERT_HIGH_ACT;
 }
diff --git a/drivers/video/via/hw.h b/drivers/video/via/hw.h
index 1fd8d98..3b7e149 100644
--- a/drivers/video/via/hw.h
+++ b/drivers/video/via/hw.h
@@ -661,8 +661,8 @@ void viafb_set_dpa_gfx(int output_interface, struct GFX_DPA_SETTING\
 
 int viafb_setmode(struct VideoModeTable *vmode_tbl, int video_bpp,
 	struct VideoModeTable *vmode_tbl1, int video_bpp1);
-void viafb_fill_var_timing_info(struct fb_var_screeninfo *var, int refresh,
-	struct VideoModeTable *vmode_tbl);
+void viafb_fill_var_timing_info(struct fb_var_screeninfo *var,
+	struct crt_mode_table *mode);
 void __devinit viafb_init_chip_info(int chip_type);
 void __devinit viafb_init_dac(int set_iga);
 int viafb_get_pixclock(int hres, int vres, int vmode_refresh);
diff --git a/drivers/video/via/viafbdev.c b/drivers/video/via/viafbdev.c
index 3eaf607..0c0ef95 100644
--- a/drivers/video/via/viafbdev.c
+++ b/drivers/video/via/viafbdev.c
@@ -201,7 +201,6 @@ static int viafb_check_var(struct fb_var_screeninfo *var,
 	struct fb_info *info)
 {
 	int depth, refresh;
-	struct VideoModeTable *vmode_entry;
 	struct viafb_par *ppar = info->par;
 	u32 line;
 
@@ -211,8 +210,10 @@ static int viafb_check_var(struct fb_var_screeninfo *var,
 	if (var->vmode & FB_VMODE_INTERLACED || var->vmode & FB_VMODE_DOUBLE)
 		return -EINVAL;
 
-	vmode_entry = viafb_get_mode(var->xres, var->yres);
-	if (!vmode_entry) {
+	/* the refresh rate is not important here, as we only want to know
+	 * whether the resolution exists
+	 */
+	if (!viafb_get_best_mode(var->xres, var->yres, 60)) {
 		DEBUG_MSG(KERN_INFO
 			  "viafb: Mode %dx%dx%d not supported!!\n",
 			  var->xres, var->yres, var->bits_per_pixel);
@@ -254,7 +255,8 @@ static int viafb_check_var(struct fb_var_screeninfo *var,
 		get_var_refresh(var));
 
 	/* Adjust var according to our driver's own table */
-	viafb_fill_var_timing_info(var, refresh, vmode_entry);
+	viafb_fill_var_timing_info(var,
+		viafb_get_best_mode(var->xres, var->yres, refresh));
 	if (var->accel_flags & FB_ACCELF_TEXT &&
 		!ppar->shared->vdev->engine_mmio)
 		var->accel_flags = 0;
@@ -1816,9 +1818,8 @@ int __devinit via_fb_pci_probe(struct viafb_dev *vdev)
 	default_var.xres_virtual = default_xres;
 	default_var.yres_virtual = default_yres;
 	default_var.bits_per_pixel = viafb_bpp;
-	viafb_fill_var_timing_info(&default_var, viafb_get_refresh(
-		default_var.xres, default_var.yres, viafb_refresh),
-		viafb_get_mode(default_var.xres, default_var.yres));
+	viafb_fill_var_timing_info(&default_var, viafb_get_best_mode(
+		default_var.xres, default_var.yres, viafb_refresh));
 	viafb_setup_fixinfo(&viafbinfo->fix, viaparinfo);
 	viafbinfo->var = default_var;
 
@@ -1857,9 +1858,8 @@ int __devinit via_fb_pci_probe(struct viafb_dev *vdev)
 		default_var.xres_virtual = viafb_second_xres;
 		default_var.yres_virtual = viafb_second_yres;
 		default_var.bits_per_pixel = viafb_bpp1;
-		viafb_fill_var_timing_info(&default_var, viafb_get_refresh(
-			default_var.xres, default_var.yres, viafb_refresh1),
-			viafb_get_mode(default_var.xres, default_var.yres));
+		viafb_fill_var_timing_info(&default_var, viafb_get_best_mode(
+			default_var.xres, default_var.yres, viafb_refresh1));
 
 		viafb_setup_fixinfo(&viafbinfo1->fix, viaparinfo1);
 		viafb_check_var(&default_var, viafbinfo1);
@@ -2032,9 +2032,9 @@ int __init viafb_init(void)
 		return r;
 #endif
 	if (parse_mode(viafb_mode, &dummy_x, &dummy_y)
-		|| !viafb_get_mode(dummy_x, dummy_y)
+		|| !viafb_get_best_mode(dummy_x, dummy_y, viafb_refresh)
 		|| parse_mode(viafb_mode1, &dummy_x, &dummy_y)
-		|| !viafb_get_mode(dummy_x, dummy_y)
+		|| !viafb_get_best_mode(dummy_x, dummy_y, viafb_refresh1)
 		|| viafb_bpp < 0 || viafb_bpp > 32
 		|| viafb_bpp1 < 0 || viafb_bpp1 > 32
 		|| parse_active_dev())
diff --git a/drivers/video/via/viamode.c b/drivers/video/via/viamode.c
index 8a9f4fc..88096e5 100644
--- a/drivers/video/via/viamode.c
+++ b/drivers/video/via/viamode.c
@@ -863,26 +863,56 @@ int NUM_TOTAL_CLE266_ModeXregs = ARRAY_SIZE(CLE266_ModeXregs);
 int NUM_TOTAL_PATCH_MODE = ARRAY_SIZE(res_patch_table);
 
 
-struct VideoModeTable *viafb_get_mode(int hres, int vres)
+static struct VideoModeTable *get_modes(struct VideoModeTable *vmt, int n,
+	int hres, int vres)
 {
-	u32 i;
-	for (i = 0; i < ARRAY_SIZE(viafb_modes); i++)
-		if (viafb_modes[i].mode_array &&
-			viafb_modes[i].crtc[0].crtc.hor_addr == hres &&
-			viafb_modes[i].crtc[0].crtc.ver_addr == vres)
+	int i;
+
+	for (i = 0; i < n; i++)
+		if (vmt[i].mode_array &&
+			vmt[i].crtc[0].crtc.hor_addr == hres &&
+			vmt[i].crtc[0].crtc.ver_addr == vres)
 			return &viafb_modes[i];
 
 	return NULL;
 }
 
+static struct crt_mode_table *get_best_mode(struct VideoModeTable *vmt,
+	int refresh)
+{
+	struct crt_mode_table *best;
+	int i;
+
+	if (!vmt)
+		return NULL;
+
+	best = &vmt->crtc[0];
+	for (i = 1; i < vmt->mode_array; i++) {
+		if (abs(vmt->crtc[i].refresh_rate - refresh)
+			< abs(best->refresh_rate - refresh))
+			best = &vmt->crtc[i];
+	}
+
+	return best;
+}
+
+struct VideoModeTable *viafb_get_mode(int hres, int vres)
+{
+	return get_modes(viafb_modes, ARRAY_SIZE(viafb_modes), hres, vres);
+}
+
+struct crt_mode_table *viafb_get_best_mode(int hres, int vres, int refresh)
+{
+	return get_best_mode(viafb_get_mode(hres, vres), refresh);
+}
+
 struct VideoModeTable *viafb_get_rb_mode(int hres, int vres)
 {
-	u32 i;
-	for (i = 0; i < ARRAY_SIZE(viafb_rb_modes); i++)
-		if (viafb_rb_modes[i].mode_array &&
-			viafb_rb_modes[i].crtc[0].crtc.hor_addr == hres &&
-			viafb_rb_modes[i].crtc[0].crtc.ver_addr == vres)
-			return &viafb_rb_modes[i];
+	return get_modes(viafb_rb_modes, ARRAY_SIZE(viafb_rb_modes), hres,
+		vres);
+}
 
-	return NULL;
+struct crt_mode_table *viafb_get_best_rb_mode(int hres, int vres, int refresh)
+{
+	return get_best_mode(viafb_get_rb_mode(hres, vres), refresh);
 }
diff --git a/drivers/video/via/viamode.h b/drivers/video/via/viamode.h
index 3751289..0396581 100644
--- a/drivers/video/via/viamode.h
+++ b/drivers/video/via/viamode.h
@@ -61,6 +61,8 @@ extern struct patch_table res_patch_table[];
 extern struct VPITTable VPIT;
 
 struct VideoModeTable *viafb_get_mode(int hres, int vres);
+struct crt_mode_table *viafb_get_best_mode(int hres, int vres, int refresh);
 struct VideoModeTable *viafb_get_rb_mode(int hres, int vres);
+struct crt_mode_table *viafb_get_best_rb_mode(int hres, int vres, int refresh);
 
 #endif /* __VIAMODE_H__ */
-- 
1.6.3.2

