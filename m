Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753591Ab2BNFvz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 00:51:55 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:49912 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753004Ab2BNFvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 00:51:53 -0500
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX18ZzAg9As4ZFHDipQbZyeUxWeDfNiwWcj/AbOPVOa
	UvSfEiTQvmXvQk
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [PATCH 3/4] viafb: make single framebuffer multiple adapter mode work
Date: Tue, 14 Feb 2012 06:12:04 +0000
Message-Id: <532f9169db21fbffd07cc44075c7ea1859c07806.1329194838.git.FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <cover.1329194838.git.FlorianSchandinat@gmx.de>
References: <cover.1329194838.git.FlorianSchandinat@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implementes this mode (viafb_SAMM_ON set and
viafb_dual_fb not set) in a useful way for CRT and DVI devices.
The same content is shown on both devices in different video modes.
The first (primary) resolution must not be bigger than the secondary
one and determines the visible region. The same content is shown
centered on the secondary output.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
---
 drivers/video/via/dvi.c |    5 +++--
 drivers/video/via/dvi.h |    3 ++-
 drivers/video/via/hw.c  |   41 +++++++++++++++++++++++------------------
 drivers/video/via/hw.h  |    3 ++-
 4 files changed, 30 insertions(+), 22 deletions(-)

diff --git a/drivers/video/via/dvi.c b/drivers/video/via/dvi.c
index 9138e51..3312c81 100644
--- a/drivers/video/via/dvi.c
+++ b/drivers/video/via/dvi.c
@@ -172,7 +172,8 @@ static int tmds_register_read_bytes(int index, u8 *buff, int buff_len)
 }
 
 /* DVI Set Mode */
-void viafb_dvi_set_mode(const struct fb_var_screeninfo *var, int iga)
+void viafb_dvi_set_mode(const struct fb_var_screeninfo *var,
+	u16 cxres, u16 cyres, int iga)
 {
 	struct fb_var_screeninfo dvi_var = *var;
 	struct crt_mode_table *rb_mode;
@@ -185,7 +186,7 @@ void viafb_dvi_set_mode(const struct fb_var_screeninfo *var, int iga)
 			viafb_fill_var_timing_info(&dvi_var, rb_mode);
 	}
 
-	viafb_fill_crtc_timing(&dvi_var, iga);
+	viafb_fill_crtc_timing(&dvi_var, cxres, cyres, iga);
 }
 
 /* Sense DVI Connector */
diff --git a/drivers/video/via/dvi.h b/drivers/video/via/dvi.h
index e2116aa..db75785 100644
--- a/drivers/video/via/dvi.h
+++ b/drivers/video/via/dvi.h
@@ -59,6 +59,7 @@ void viafb_dvi_enable(void);
 bool __devinit viafb_tmds_trasmitter_identify(void);
 void __devinit viafb_init_dvi_size(struct tmds_chip_information *tmds_chip,
 	struct tmds_setting_information *tmds_setting);
-void viafb_dvi_set_mode(const struct fb_var_screeninfo *var, int iga);
+void viafb_dvi_set_mode(const struct fb_var_screeninfo *var,
+	u16 cxres, u16 cyres, int iga);
 
 #endif /* __DVI_H__ */
diff --git a/drivers/video/via/hw.c b/drivers/video/via/hw.c
index 399d507..e8725c5 100644
--- a/drivers/video/via/hw.c
+++ b/drivers/video/via/hw.c
@@ -1467,28 +1467,31 @@ void viafb_set_vclock(u32 clk, int set_iga)
 	via_write_misc_reg_mask(0x0C, 0x0C); /* select external clock */
 }
 
-static struct display_timing var_to_timing(const struct fb_var_screeninfo *var)
+static struct display_timing var_to_timing(const struct fb_var_screeninfo *var, u16 cxres, u16 cyres)
 {
 	struct display_timing timing;
+	u16 dx = (var->xres - cxres) / 2, dy = (var->yres - cyres) / 2;
 
-	timing.hor_addr = var->xres;
-	timing.hor_sync_start = timing.hor_addr + var->right_margin;
+	timing.hor_addr = cxres;
+	timing.hor_sync_start = timing.hor_addr + var->right_margin + dx;
 	timing.hor_sync_end = timing.hor_sync_start + var->hsync_len;
-	timing.hor_total = timing.hor_sync_end + var->left_margin;
-	timing.hor_blank_start = timing.hor_addr;
-	timing.hor_blank_end = timing.hor_total;
-	timing.ver_addr = var->yres;
-	timing.ver_sync_start = timing.ver_addr + var->lower_margin;
+	timing.hor_total = timing.hor_sync_end + var->left_margin + dx;
+	timing.hor_blank_start = timing.hor_addr + dx;
+	timing.hor_blank_end = timing.hor_total - dy;
+	timing.ver_addr = cyres;
+	timing.ver_sync_start = timing.ver_addr + var->lower_margin + dy;
 	timing.ver_sync_end = timing.ver_sync_start + var->vsync_len;
-	timing.ver_total = timing.ver_sync_end + var->upper_margin;
-	timing.ver_blank_start = timing.ver_addr;
-	timing.ver_blank_end = timing.ver_total;
+	timing.ver_total = timing.ver_sync_end + var->upper_margin + dy;
+	timing.ver_blank_start = timing.ver_addr + dy;
+	timing.ver_blank_end = timing.ver_total - dy;
 	return timing;
 }
 
-void viafb_fill_crtc_timing(const struct fb_var_screeninfo *var, int iga)
+void viafb_fill_crtc_timing(const struct fb_var_screeninfo *var,
+	u16 cxres, u16 cyres, int iga)
 {
-	struct display_timing crt_reg = var_to_timing(var);
+	struct display_timing crt_reg = var_to_timing(var,
+		cxres ? cxres : var->xres, cyres ? cyres : var->yres);
 
 	if (iga == IGA1)
 		via_set_primary_timing(&crt_reg);
@@ -1842,7 +1845,7 @@ static void hw_init(void)
 
 int viafb_setmode(int video_bpp, int video_bpp1)
 {
-	int j;
+	int j, cxres = 0, cyres = 0;
 	int port;
 	u32 devices = viaparinfo->shared->iga1_devices
 		| viaparinfo->shared->iga2_devices;
@@ -1891,6 +1894,8 @@ int viafb_setmode(int video_bpp, int video_bpp1)
 	} else if (viafb_SAMM_ON) {
 		viafb_fill_var_timing_info(&var2, viafb_get_best_mode(
 			viafb_second_xres, viafb_second_yres, viafb_refresh1));
+		cxres = viafbinfo->var.xres;
+		cyres = viafbinfo->var.yres;
 		var2.bits_per_pixel = viafbinfo->var.bits_per_pixel;
 	}
 
@@ -1898,9 +1903,9 @@ int viafb_setmode(int video_bpp, int video_bpp1)
 	if (viafb_CRT_ON) {
 		if (viaparinfo->shared->iga2_devices & VIA_CRT
 			&& viafb_SAMM_ON)
-			viafb_fill_crtc_timing(&var2, IGA2);
+			viafb_fill_crtc_timing(&var2, cxres, cyres, IGA2);
 		else
-			viafb_fill_crtc_timing(&viafbinfo->var,
+			viafb_fill_crtc_timing(&viafbinfo->var, 0, 0,
 				(viaparinfo->shared->iga1_devices & VIA_CRT)
 				? IGA1 : IGA2);
 
@@ -1918,9 +1923,9 @@ int viafb_setmode(int video_bpp, int video_bpp1)
 	if (viafb_DVI_ON) {
 		if (viaparinfo->shared->tmds_setting_info.iga_path == IGA2
 			&& viafb_SAMM_ON)
-			viafb_dvi_set_mode(&var2, IGA2);
+			viafb_dvi_set_mode(&var2, cxres, cyres, IGA2);
 		else
-			viafb_dvi_set_mode(&viafbinfo->var,
+			viafb_dvi_set_mode(&viafbinfo->var, 0, 0,
 				viaparinfo->tmds_setting_info->iga_path);
 	}
 
diff --git a/drivers/video/via/hw.h b/drivers/video/via/hw.h
index 4db5b6e..f8129e4 100644
--- a/drivers/video/via/hw.h
+++ b/drivers/video/via/hw.h
@@ -637,7 +637,8 @@ extern int viafb_LCD_ON;
 extern int viafb_DVI_ON;
 extern int viafb_hotplug;
 
-void viafb_fill_crtc_timing(const struct fb_var_screeninfo *var, int iga);
+void viafb_fill_crtc_timing(const struct fb_var_screeninfo *var,
+	u16 cxres, u16 cyres, int iga);
 void viafb_set_vclock(u32 CLK, int set_iga);
 void viafb_load_reg(int timing_value, int viafb_load_reg_num,
 	struct io_register *reg,
-- 
1.7.9

