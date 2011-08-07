Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753865Ab1HGPbv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Aug 2011 11:31:51 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:40600 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753441Ab1HGPbt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Aug 2011 11:31:49 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX19YGKRtXjdYZKdy0LkI03OYsN1BcfOXQ5mistmLNn
	ZFn/9gLgvRfbZB
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [PATCH 2/6] viafb: eliminate viafb_get_pixclock
Date: Sun,  7 Aug 2011 15:50:24 +0000
Message-Id: <42edcb162d67e8a88c7b873941c19eab689db272.1312730860.git.FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <cover.1312730859.git.FlorianSchandinat@gmx.de>
References: <cover.1312730859.git.FlorianSchandinat@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As there is only one user we can just insert the formula where
needed. Avoids one lookup in the modetable and
viafb_fill_var_timing_info does no longer depend on the modetable.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
---
 drivers/video/via/hw.c    |   16 ++--------------
 drivers/video/via/hw.h    |    1 -
 drivers/video/via/share.h |    4 ----
 3 files changed, 2 insertions(+), 19 deletions(-)

diff --git a/drivers/video/via/hw.c b/drivers/video/via/hw.c
index 5e69c20..d7b9a9f 100644
--- a/drivers/video/via/hw.c
+++ b/drivers/video/via/hw.c
@@ -2033,18 +2033,6 @@ int viafb_setmode(struct VideoModeTable *vmode_tbl, int video_bpp,
 	return 1;
 }
 
-int viafb_get_pixclock(int hres, int vres, int vmode_refresh)
-{
-	struct crt_mode_table *best;
-
-	best = viafb_get_best_mode(hres, vres, vmode_refresh);
-	if (!best)
-		return RES_640X480_60HZ_PIXCLOCK;
-
-	return 1000000000 / (best->crtc.hor_total * best->crtc.ver_total)
-		* 1000 / best->refresh_rate;
-}
-
 int viafb_get_refresh(int hres, int vres, u32 long_refresh)
 {
 	struct crt_mode_table *best;
@@ -2160,8 +2148,8 @@ void viafb_fill_var_timing_info(struct fb_var_screeninfo *var,
 	struct display_timing crt_reg;
 
 	crt_reg = mode->crtc;
-	var->pixclock = viafb_get_pixclock(var->xres, var->yres,
-		mode->refresh_rate);
+	var->pixclock = 1000000000 / (crt_reg.hor_total * crt_reg.ver_total)
+		* 1000 / mode->refresh_rate;
 	var->left_margin =
 	    crt_reg.hor_total - (crt_reg.hor_sync_start + crt_reg.hor_sync_end);
 	var->right_margin = crt_reg.hor_sync_start - crt_reg.hor_addr;
diff --git a/drivers/video/via/hw.h b/drivers/video/via/hw.h
index 3b7e149..5516b02 100644
--- a/drivers/video/via/hw.h
+++ b/drivers/video/via/hw.h
@@ -665,7 +665,6 @@ void viafb_fill_var_timing_info(struct fb_var_screeninfo *var,
 	struct crt_mode_table *mode);
 void __devinit viafb_init_chip_info(int chip_type);
 void __devinit viafb_init_dac(int set_iga);
-int viafb_get_pixclock(int hres, int vres, int vmode_refresh);
 int viafb_get_refresh(int hres, int vres, u32 float_refresh);
 void viafb_update_device_setting(int hres, int vres, int bpp, int flag);
 
diff --git a/drivers/video/via/share.h b/drivers/video/via/share.h
index 2906b2d..69d882c 100644
--- a/drivers/video/via/share.h
+++ b/drivers/video/via/share.h
@@ -636,10 +636,6 @@
 #define V_SYNC_SATRT_SHADOW_INDEX   18
 #define V_SYNC_END_SHADOW_INDEX     19
 
-/* Definition Video Mode Pixel Clock (picoseconds)
-*/
-#define RES_640X480_60HZ_PIXCLOCK    39722
-
 /* LCD display method
 */
 #define     LCD_EXPANDSION              0x00
-- 
1.6.3.2

