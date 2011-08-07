Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753804Ab1HGPc7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Aug 2011 11:32:59 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:50928 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753260Ab1HGPc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Aug 2011 11:32:56 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX19AVQZcvZpABWX0iBPG1uq30CkfGCDixp/10IrGTg
	HF7StCLGzyVAF4
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [PATCH 3/6] viafb: use information in var for modesetting
Date: Sun,  7 Aug 2011 15:51:25 +0000
Message-Id: <ebb29fb47e198787b8b47a74cb10334cd9647a9d.1312730860.git.FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <cover.1312730859.git.FlorianSchandinat@gmx.de>
References: <cover.1312730859.git.FlorianSchandinat@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch starts to use the information in var for modesetting for
CRT and DVI devices. This is the right thing as it allows us to use
more generic modes than the ones predefined by VIA. We do not yet
allow more generic modes as check_var still limits them to the
predefined ones but with this patch applied it would be really easy
to do so. A problem was VIAs SAMM mode as it has 2 different modes
but just one frame buffer device. This is solved by creating a
pseudo var which contains enough information to use it for
modesetting. Hopefully one day we can use information in var for all
modes that do not involve hardware scaling.
Well I'd like to say that the chance of regressions is low but it is
quite likely that the behaviour in some cases changed especially
when SAMM is involved. I hope we made it better than before in
particular the DVI frequency check was probably broken before and
hopefully works better now.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
---
 drivers/video/via/dvi.c |   30 +++++--------
 drivers/video/via/dvi.h |    3 +-
 drivers/video/via/hw.c  |  107 +++++++++++++++++++++--------------------------
 drivers/video/via/hw.h  |    4 +-
 4 files changed, 61 insertions(+), 83 deletions(-)

diff --git a/drivers/video/via/dvi.c b/drivers/video/via/dvi.c
index c7ff5c0..9138e51 100644
--- a/drivers/video/via/dvi.c
+++ b/drivers/video/via/dvi.c
@@ -172,28 +172,20 @@ static int tmds_register_read_bytes(int index, u8 *buff, int buff_len)
 }
 
 /* DVI Set Mode */
-void viafb_dvi_set_mode(struct VideoModeTable *mode, int mode_bpp,
-	int set_iga)
+void viafb_dvi_set_mode(const struct fb_var_screeninfo *var, int iga)
 {
-	struct VideoModeTable *rb_mode;
-	struct crt_mode_table *pDviTiming;
-	unsigned long desirePixelClock, maxPixelClock;
-	pDviTiming = mode->crtc;
-	desirePixelClock = pDviTiming->refresh_rate
-		* pDviTiming->crtc.hor_total * pDviTiming->crtc.ver_total
-		/ 1000000;
-	maxPixelClock = (unsigned long)viaparinfo->
-		tmds_setting_info->max_pixel_clock;
-
-	DEBUG_MSG(KERN_INFO "\nDVI_set_mode!!\n");
-
-	if ((maxPixelClock != 0) && (desirePixelClock > maxPixelClock)) {
-		rb_mode = viafb_get_rb_mode(mode->crtc[0].crtc.hor_addr,
-			mode->crtc[0].crtc.ver_addr);
+	struct fb_var_screeninfo dvi_var = *var;
+	struct crt_mode_table *rb_mode;
+	int maxPixelClock;
+
+	maxPixelClock = viaparinfo->shared->tmds_setting_info.max_pixel_clock;
+	if (maxPixelClock && PICOS2KHZ(var->pixclock) / 1000 > maxPixelClock) {
+		rb_mode = viafb_get_best_rb_mode(var->xres, var->yres, 60);
 		if (rb_mode)
-			mode = rb_mode;
+			viafb_fill_var_timing_info(&dvi_var, rb_mode);
 	}
-	viafb_fill_crtc_timing(mode, mode_bpp / 8, set_iga);
+
+	viafb_fill_crtc_timing(&dvi_var, iga);
 }
 
 /* Sense DVI Connector */
diff --git a/drivers/video/via/dvi.h b/drivers/video/via/dvi.h
index f473dd0..e2116aa 100644
--- a/drivers/video/via/dvi.h
+++ b/drivers/video/via/dvi.h
@@ -59,7 +59,6 @@ void viafb_dvi_enable(void);
 bool __devinit viafb_tmds_trasmitter_identify(void);
 void __devinit viafb_init_dvi_size(struct tmds_chip_information *tmds_chip,
 	struct tmds_setting_information *tmds_setting);
-void viafb_dvi_set_mode(struct VideoModeTable *videoMode, int mode_bpp,
-	int set_iga);
+void viafb_dvi_set_mode(const struct fb_var_screeninfo *var, int iga);
 
 #endif /* __DVI_H__ */
diff --git a/drivers/video/via/hw.c b/drivers/video/via/hw.c
index d7b9a9f..6845c82 100644
--- a/drivers/video/via/hw.c
+++ b/drivers/video/via/hw.c
@@ -1467,49 +1467,40 @@ void viafb_set_vclock(u32 clk, int set_iga)
 	via_write_misc_reg_mask(0x0C, 0x0C); /* select external clock */
 }
 
-void viafb_fill_crtc_timing(struct VideoModeTable *video_mode, int bpp_byte,
-	int set_iga)
+static struct display_timing var_to_timing(const struct fb_var_screeninfo *var)
 {
-	struct crt_mode_table *crt_table = video_mode->crtc;
-	struct display_timing crt_reg;
-	int i;
-	int index = 0;
-	int h_addr, v_addr;
-	u32 clock, refresh = viafb_refresh;
-
-	if (viafb_SAMM_ON && set_iga == IGA2)
-		refresh = viafb_refresh1;
-
-	for (i = 0; i < video_mode->mode_array; i++) {
-		index = i;
+	struct display_timing timing;
+
+	timing.hor_addr = var->xres;
+	timing.hor_sync_start = timing.hor_addr + var->right_margin;
+	timing.hor_sync_end = timing.hor_sync_start + var->hsync_len;
+	timing.hor_total = timing.hor_sync_end + var->left_margin;
+	timing.hor_blank_start = timing.hor_addr;
+	timing.hor_blank_end = timing.hor_total;
+	timing.ver_addr = var->yres;
+	timing.ver_sync_start = timing.ver_addr + var->lower_margin;
+	timing.ver_sync_end = timing.ver_sync_start + var->vsync_len;
+	timing.ver_total = timing.ver_sync_end + var->upper_margin;
+	timing.ver_blank_start = timing.ver_addr;
+	timing.ver_blank_end = timing.ver_total;
+	return timing;
+}
 
-		if (crt_table[i].refresh_rate == refresh)
-			break;
-	}
+void viafb_fill_crtc_timing(const struct fb_var_screeninfo *var, int iga)
+{
+	struct display_timing crt_reg = var_to_timing(var);
 
-	crt_reg = crt_table[index].crtc;
-	crt_reg.hor_blank_end += crt_reg.hor_blank_start;
-	crt_reg.hor_sync_end += crt_reg.hor_sync_start;
-	crt_reg.ver_blank_end += crt_reg.ver_blank_start;
-	crt_reg.ver_sync_end += crt_reg.ver_sync_start;
-	h_addr = crt_reg.hor_addr;
-	v_addr = crt_reg.ver_addr;
-	if (set_iga == IGA1)
+	if (iga == IGA1)
 		via_set_primary_timing(&crt_reg);
-	else if (set_iga == IGA2)
+	else if (iga == IGA2)
 		via_set_secondary_timing(&crt_reg);
 
-	viafb_load_fetch_count_reg(h_addr, bpp_byte, set_iga);
-
-	/* load FIFO */
-	if ((viaparinfo->chip_info->gfx_chip_name != UNICHROME_CLE266)
-	    && (viaparinfo->chip_info->gfx_chip_name != UNICHROME_K400))
-		viafb_load_FIFO_reg(set_iga, h_addr, v_addr);
-
-	clock = crt_reg.hor_total * crt_reg.ver_total
-		* crt_table[index].refresh_rate;
-	viafb_set_vclock(clock, set_iga);
+	viafb_load_fetch_count_reg(var->xres, var->bits_per_pixel / 8, iga);
+	if (viaparinfo->chip_info->gfx_chip_name != UNICHROME_CLE266
+		&& viaparinfo->chip_info->gfx_chip_name != UNICHROME_K400)
+		viafb_load_FIFO_reg(iga, var->xres, var->yres);
 
+	viafb_set_vclock(PICOS2KHZ(var->pixclock) * 1000, iga);
 }
 
 void __devinit viafb_init_chip_info(int chip_type)
@@ -1788,6 +1779,7 @@ int viafb_setmode(struct VideoModeTable *vmode_tbl, int video_bpp,
 	u8 value, index, mask;
 	struct crt_mode_table *crt_timing;
 	struct crt_mode_table *crt_timing1 = NULL;
+	struct fb_var_screeninfo var2;
 
 	device_screen_off();
 	crt_timing = vmode_tbl->crtc;
@@ -1894,17 +1886,24 @@ int viafb_setmode(struct VideoModeTable *vmode_tbl, int video_bpp,
 
 	/* Clear On Screen */
 
+	if (viafb_dual_fb) {
+		var2 = viafbinfo1->var;
+	} else if (viafb_SAMM_ON) {
+		viafb_fill_var_timing_info(&var2, viafb_get_best_mode(
+			vmode_tbl1->crtc->crtc.hor_addr,
+			vmode_tbl1->crtc->crtc.ver_addr, viafb_refresh1));
+		var2.bits_per_pixel = viafbinfo->var.bits_per_pixel;
+	}
+
 	/* CRT set mode */
 	if (viafb_CRT_ON) {
-		if (viafb_SAMM_ON &&
-			viaparinfo->shared->iga2_devices & VIA_CRT) {
-			viafb_fill_crtc_timing(vmode_tbl1, video_bpp1 / 8,
-				IGA2);
-		} else {
-			viafb_fill_crtc_timing(vmode_tbl, video_bpp / 8,
+		if (viaparinfo->shared->iga2_devices & VIA_CRT
+			&& viafb_SAMM_ON)
+			viafb_fill_crtc_timing(&var2, IGA2);
+		else
+			viafb_fill_crtc_timing(&viafbinfo->var,
 				(viaparinfo->shared->iga1_devices & VIA_CRT)
 				? IGA1 : IGA2);
-		}
 
 		/* Patch if set_hres is not 8 alignment (1366) to viafb_setmode
 		to 8 alignment (1368),there is several pixels (2 pixels)
@@ -1918,22 +1917,12 @@ int viafb_setmode(struct VideoModeTable *vmode_tbl, int video_bpp,
 	}
 
 	if (viafb_DVI_ON) {
-		if (viafb_SAMM_ON &&
-			(viaparinfo->tmds_setting_info->iga_path == IGA2)) {
-			viafb_dvi_set_mode(viafb_get_mode
-				     (viaparinfo->tmds_setting_info->h_active,
-				      viaparinfo->tmds_setting_info->
-				      v_active),
-				     video_bpp1, viaparinfo->
-				     tmds_setting_info->iga_path);
-		} else {
-			viafb_dvi_set_mode(viafb_get_mode
-				     (viaparinfo->tmds_setting_info->h_active,
-				      viaparinfo->
-				      tmds_setting_info->v_active),
-				     video_bpp, viaparinfo->
-				     tmds_setting_info->iga_path);
-		}
+		if (viaparinfo->shared->tmds_setting_info.iga_path == IGA2
+			&& viafb_SAMM_ON)
+			viafb_dvi_set_mode(&var2, IGA2);
+		else
+			viafb_dvi_set_mode(&viafbinfo->var,
+				viaparinfo->tmds_setting_info->iga_path);
 	}
 
 	if (viafb_LCD_ON) {
diff --git a/drivers/video/via/hw.h b/drivers/video/via/hw.h
index 5516b02..46f65da 100644
--- a/drivers/video/via/hw.h
+++ b/drivers/video/via/hw.h
@@ -637,9 +637,7 @@ extern int viafb_LCD_ON;
 extern int viafb_DVI_ON;
 extern int viafb_hotplug;
 
-void viafb_fill_crtc_timing(struct VideoModeTable *video_mode, int bpp_byte,
-	int set_iga);
-
+void viafb_fill_crtc_timing(const struct fb_var_screeninfo *var, int iga);
 void viafb_set_vclock(u32 CLK, int set_iga);
 void viafb_load_reg(int timing_value, int viafb_load_reg_num,
 	struct io_register *reg,
-- 
1.6.3.2

