Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757432Ab1DXBoz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Apr 2011 21:44:55 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:36728 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757402Ab1DXBof (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Apr 2011 21:44:35 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX19JrLU1FL9JqCpfj9wa3GLSafP8zU1utKCHtb2Eyd
	ua9LLYMSfBD5CB
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [PATCH 2/3] viafb: some small cleanup for global variables
Date: Sun, 24 Apr 2011 02:00:42 +0000
Message-Id: <1303610443-8681-3-git-send-email-FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <1303610443-8681-1-git-send-email-FlorianSchandinat@gmx.de>
References: <1303610443-8681-1-git-send-email-FlorianSchandinat@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We do not need viafb_second{,_virtual}_{xres,yres} outside of
viafbdev.c so move them there and eliminate the virtual ones where
the only sane usage is done during initalization.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
---
 drivers/video/via/global.c   |    4 ----
 drivers/video/via/global.h   |    2 --
 drivers/video/via/hw.h       |    1 -
 drivers/video/via/viafbdev.c |   16 +++++++---------
 drivers/video/via/viafbdev.h |    2 --
 5 files changed, 7 insertions(+), 18 deletions(-)

diff --git a/drivers/video/via/global.c b/drivers/video/via/global.c
index 1ee511b..e10d824 100644
--- a/drivers/video/via/global.c
+++ b/drivers/video/via/global.c
@@ -40,10 +40,6 @@ int viafb_hotplug_Yres = 480;
 int viafb_hotplug_bpp = 32;
 int viafb_hotplug_refresh = 60;
 int viafb_primary_dev = None_Device;
-unsigned int viafb_second_xres = 640;
-unsigned int viafb_second_yres = 480;
-unsigned int viafb_second_virtual_xres;
-unsigned int viafb_second_virtual_yres;
 int viafb_lcd_panel_id = LCD_PANEL_ID_MAXIMUM + 1;
 struct fb_info *viafbinfo;
 struct fb_info *viafbinfo1;
diff --git a/drivers/video/via/global.h b/drivers/video/via/global.h
index 38ef5ac..ff969dc 100644
--- a/drivers/video/via/global.h
+++ b/drivers/video/via/global.h
@@ -73,8 +73,6 @@ extern int viafb_hotplug_bpp;
 extern int viafb_hotplug_refresh;
 extern int viafb_primary_dev;
 
-extern unsigned int viafb_second_xres;
-extern unsigned int viafb_second_yres;
 extern int viafb_lcd_panel_id;
 
 #endif /* __GLOBAL_H__ */
diff --git a/drivers/video/via/hw.h b/drivers/video/via/hw.h
index 8858593..090d167 100644
--- a/drivers/video/via/hw.h
+++ b/drivers/video/via/hw.h
@@ -910,7 +910,6 @@ struct via_device_mapping {
 	const char *name;
 };
 
-extern unsigned int viafb_second_virtual_xres;
 extern int viafb_SAMM_ON;
 extern int viafb_dual_fb;
 extern int viafb_LCD2_ON;
diff --git a/drivers/video/via/viafbdev.c b/drivers/video/via/viafbdev.c
index ed9bd79..eace9a4 100644
--- a/drivers/video/via/viafbdev.c
+++ b/drivers/video/via/viafbdev.c
@@ -37,6 +37,8 @@ static char *viafb_mode1;
 static int viafb_bpp = 32;
 static int viafb_bpp1 = 32;
 
+static unsigned int viafb_second_xres = 640;
+static unsigned int viafb_second_yres = 480;
 static unsigned int viafb_second_offset;
 static int viafb_second_size;
 
@@ -440,8 +442,8 @@ static int viafb_ioctl(struct fb_info *info, u_int cmd, u_long arg)
 		if (viafb_SAMM_ON == 1) {
 			u.viamode.xres_sec = viafb_second_xres;
 			u.viamode.yres_sec = viafb_second_yres;
-			u.viamode.virtual_xres_sec = viafb_second_virtual_xres;
-			u.viamode.virtual_yres_sec = viafb_second_virtual_yres;
+			u.viamode.virtual_xres_sec = viafb_dual_fb ? viafbinfo1->var.xres_virtual : viafbinfo->var.xres_virtual;
+			u.viamode.virtual_yres_sec = viafb_dual_fb ? viafbinfo1->var.yres_virtual : viafbinfo->var.yres_virtual;
 			u.viamode.refresh_sec = viafb_refresh1;
 			u.viamode.bpp_sec = viafb_bpp1;
 		} else {
@@ -1790,14 +1792,10 @@ int __devinit via_fb_pci_probe(struct viafb_dev *vdev)
 
 	parse_mode(viafb_mode, &default_xres, &default_yres);
 	vmode_entry = viafb_get_mode(default_xres, default_yres);
-	if (viafb_SAMM_ON == 1) {
+	if (viafb_SAMM_ON == 1)
 		parse_mode(viafb_mode1, &viafb_second_xres,
 			&viafb_second_yres);
 
-		viafb_second_virtual_xres = viafb_second_xres;
-		viafb_second_virtual_yres = viafb_second_yres;
-	}
-
 	default_var.xres = default_xres;
 	default_var.yres = default_yres;
 	default_var.xres_virtual = default_xres;
@@ -1841,8 +1839,8 @@ int __devinit via_fb_pci_probe(struct viafb_dev *vdev)
 
 		default_var.xres = viafb_second_xres;
 		default_var.yres = viafb_second_yres;
-		default_var.xres_virtual = viafb_second_virtual_xres;
-		default_var.yres_virtual = viafb_second_virtual_yres;
+		default_var.xres_virtual = viafb_second_xres;
+		default_var.yres_virtual = viafb_second_yres;
 		default_var.bits_per_pixel = viafb_bpp1;
 		viafb_fill_var_timing_info(&default_var, viafb_get_refresh(
 			default_var.xres, default_var.yres, viafb_refresh1),
diff --git a/drivers/video/via/viafbdev.h b/drivers/video/via/viafbdev.h
index ff60e1d..59e40d1 100644
--- a/drivers/video/via/viafbdev.h
+++ b/drivers/video/via/viafbdev.h
@@ -83,8 +83,6 @@ struct viafb_par {
 	struct chip_information *chip_info;
 };
 
-extern unsigned int viafb_second_virtual_yres;
-extern unsigned int viafb_second_virtual_xres;
 extern int viafb_SAMM_ON;
 extern int viafb_dual_fb;
 extern int viafb_LCD2_ON;
-- 
1.6.3.2

