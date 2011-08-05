Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756742Ab1HEVrG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 17:47:06 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:53554 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752177Ab1HEVrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 17:47:03 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX1/ETeACeN7EDdtUnph68EgZ22xgzGvS7zfT5pu8Yf
	C1Xq2Gz2YB7ZWn
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [PATCH 5/6] viafb: simplify viafb_fill_crtc_timing
Date: Fri,  5 Aug 2011 22:05:42 +0000
Message-Id: <1312581943-4235-1-git-send-email-FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <cover.1312578946.git.FlorianSchandinat@gmx.de>
References: <cover.1312578946.git.FlorianSchandinat@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As the first argument is just part of the structure passed as the
second argument there is no need for it at all.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
---
 drivers/video/via/dvi.c |    6 ++----
 drivers/video/via/hw.c  |   12 ++++++------
 drivers/video/via/hw.h  |    4 ++--
 3 files changed, 10 insertions(+), 12 deletions(-)

diff --git a/drivers/video/via/dvi.c b/drivers/video/via/dvi.c
index b1f3647..c7ff5c0 100644
--- a/drivers/video/via/dvi.c
+++ b/drivers/video/via/dvi.c
@@ -190,12 +190,10 @@ void viafb_dvi_set_mode(struct VideoModeTable *mode, int mode_bpp,
 	if ((maxPixelClock != 0) && (desirePixelClock > maxPixelClock)) {
 		rb_mode = viafb_get_rb_mode(mode->crtc[0].crtc.hor_addr,
 			mode->crtc[0].crtc.ver_addr);
-		if (rb_mode) {
+		if (rb_mode)
 			mode = rb_mode;
-			pDviTiming = rb_mode->crtc;
-		}
 	}
-	viafb_fill_crtc_timing(pDviTiming, mode, mode_bpp / 8, set_iga);
+	viafb_fill_crtc_timing(mode, mode_bpp / 8, set_iga);
 }
 
 /* Sense DVI Connector */
diff --git a/drivers/video/via/hw.c b/drivers/video/via/hw.c
index 8b4bdf5..2050fb8 100644
--- a/drivers/video/via/hw.c
+++ b/drivers/video/via/hw.c
@@ -1467,9 +1467,10 @@ void viafb_set_vclock(u32 clk, int set_iga)
 	via_write_misc_reg_mask(0x0C, 0x0C); /* select external clock */
 }
 
-void viafb_fill_crtc_timing(struct crt_mode_table *crt_table,
-	struct VideoModeTable *video_mode, int bpp_byte, int set_iga)
+void viafb_fill_crtc_timing(struct VideoModeTable *video_mode, int bpp_byte,
+	int set_iga)
 {
+	struct crt_mode_table *crt_table = video_mode->crtc;
 	struct display_timing crt_reg;
 	int i;
 	int index = 0;
@@ -1911,11 +1912,10 @@ int viafb_setmode(struct VideoModeTable *vmode_tbl, int video_bpp,
 	if (viafb_CRT_ON) {
 		if (viafb_SAMM_ON &&
 			viaparinfo->shared->iga2_devices & VIA_CRT) {
-			viafb_fill_crtc_timing(crt_timing1, vmode_tbl1,
-				video_bpp1 / 8, IGA2);
+			viafb_fill_crtc_timing(vmode_tbl1, video_bpp1 / 8,
+				IGA2);
 		} else {
-			viafb_fill_crtc_timing(crt_timing, vmode_tbl,
-				video_bpp / 8,
+			viafb_fill_crtc_timing(vmode_tbl, video_bpp / 8,
 				(viaparinfo->shared->iga1_devices & VIA_CRT)
 				? IGA1 : IGA2);
 		}
diff --git a/drivers/video/via/hw.h b/drivers/video/via/hw.h
index 267c669..1fd8d98 100644
--- a/drivers/video/via/hw.h
+++ b/drivers/video/via/hw.h
@@ -637,8 +637,8 @@ extern int viafb_LCD_ON;
 extern int viafb_DVI_ON;
 extern int viafb_hotplug;
 
-void viafb_fill_crtc_timing(struct crt_mode_table *crt_table,
-	struct VideoModeTable *video_mode, int bpp_byte, int set_iga);
+void viafb_fill_crtc_timing(struct VideoModeTable *video_mode, int bpp_byte,
+	int set_iga);
 
 void viafb_set_vclock(u32 CLK, int set_iga);
 void viafb_load_reg(int timing_value, int viafb_load_reg_num,
-- 
1.6.3.2

