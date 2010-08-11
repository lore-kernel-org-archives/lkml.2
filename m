Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758305Ab0HKXjt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 19:39:49 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:45758 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1758109Ab0HKXjp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 19:39:45 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX1+pDDoUNfqpRK7UduzjVVRMrCDKYOF84Wb7R75Y5Y
	j4ST6DXOMjMmhc
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Joseph Chan <JosephChan@via.com.tw>
Subject: [PATCH 04/11] viafb: unify output path configuration
Date: Wed, 11 Aug 2010 23:49:33 +0000
Message-Id: <1281570580-8253-5-git-send-email-FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <1281570580-8253-1-git-send-email-FlorianSchandinat@gmx.de>
References: <1281570580-8253-1-git-send-email-FlorianSchandinat@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

viafb: unify output path configuration

Move all output path routing directly in the viafb_setmode. This
gives a better overview and allows to factor similar parts out.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Joseph Chan <JosephChan@via.com.tw>
---
 drivers/video/via/dvi.c |    2 --
 drivers/video/via/hw.c  |   19 +++++++++++++++++--
 drivers/video/via/lcd.c |    3 ---
 3 files changed, 17 insertions(+), 7 deletions(-)

diff --git a/drivers/video/via/dvi.c b/drivers/video/via/dvi.c
index 39b040b..92a2027 100644
--- a/drivers/video/via/dvi.c
+++ b/drivers/video/via/dvi.c
@@ -208,8 +208,6 @@ void viafb_dvi_set_mode(struct VideoModeTable *mode, int mode_bpp,
 		}
 	}
 	viafb_fill_crtc_timing(pDviTiming, mode, mode_bpp / 8, set_iga);
-	viafb_set_output_path(DEVICE_DVI, set_iga,
-			viaparinfo->chip_info->tmds_chip_info.output_interface);
 }
 
 /* Sense DVI Connector */
diff --git a/drivers/video/via/hw.c b/drivers/video/via/hw.c
index 63b6722..a3db804 100644
--- a/drivers/video/via/hw.c
+++ b/drivers/video/via/hw.c
@@ -2377,8 +2377,6 @@ int viafb_setmode(struct VideoModeTable *vmode_tbl, int video_bpp,
 				viaparinfo->crt_setting_info->iga_path);
 		}
 
-		set_crt_output_path(viaparinfo->crt_setting_info->iga_path);
-
 		/* Patch if set_hres is not 8 alignment (1366) to viafb_setmode
 		to 8 alignment (1368),there is several pixels (2 pixels)
 		on right side of screen. */
@@ -2388,6 +2386,9 @@ int viafb_setmode(struct VideoModeTable *vmode_tbl, int video_bpp,
 				viafb_read_reg(VIACR, CR02) - 1);
 			viafb_lock_crt();
 		}
+
+		viafb_set_output_path(DEVICE_CRT,
+			viaparinfo->crt_setting_info->iga_path, 0);
 	}
 
 	if (viafb_DVI_ON) {
@@ -2407,6 +2408,10 @@ int viafb_setmode(struct VideoModeTable *vmode_tbl, int video_bpp,
 				     video_bpp, viaparinfo->
 				     tmds_setting_info->iga_path);
 		}
+
+		viafb_set_output_path(DEVICE_DVI,
+			viaparinfo->tmds_setting_info->iga_path,
+			viaparinfo->chip_info->tmds_chip_info.output_interface);
 	}
 
 	if (viafb_LCD_ON) {
@@ -2427,6 +2432,11 @@ int viafb_setmode(struct VideoModeTable *vmode_tbl, int video_bpp,
 				lvds_setting_info,
 				     &viaparinfo->chip_info->lvds_chip_info);
 		}
+
+		viafb_set_output_path(DEVICE_LCD,
+			viaparinfo->lvds_setting_info->iga_path,
+			viaparinfo->chip_info->
+			lvds_chip_info.output_interface);
 	}
 	if (viafb_LCD2_ON) {
 		if (viafb_SAMM_ON &&
@@ -2446,6 +2456,11 @@ int viafb_setmode(struct VideoModeTable *vmode_tbl, int video_bpp,
 				lvds_setting_info2,
 				     &viaparinfo->chip_info->lvds_chip_info2);
 		}
+
+		viafb_set_output_path(DEVICE_LCD,
+			viaparinfo->lvds_setting_info2->iga_path,
+			viaparinfo->chip_info->
+			lvds_chip_info2.output_interface);
 	}
 
 	if ((viaparinfo->chip_info->gfx_chip_name == UNICHROME_CX700)
diff --git a/drivers/video/via/lcd.c b/drivers/video/via/lcd.c
index bda1246..e48117e 100644
--- a/drivers/video/via/lcd.c
+++ b/drivers/video/via/lcd.c
@@ -661,9 +661,6 @@ void viafb_lcd_set_mode(struct crt_mode_table *mode_crt_table,
 	pll_D_N = viafb_get_clk_value(panel_crt_table[0].clk);
 	DEBUG_MSG(KERN_INFO "PLL=0x%x", pll_D_N);
 	viafb_set_vclock(pll_D_N, set_iga);
-
-	viafb_set_output_path(DEVICE_LCD, set_iga,
-		plvds_chip_info->output_interface);
 	lcd_patch_skew(plvds_setting_info, plvds_chip_info);
 
 	/* If K8M800, enable LCD Prefetch Mode. */
-- 
1.6.3.2

