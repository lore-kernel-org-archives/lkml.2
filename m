Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932596Ab1CWVsl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 17:48:41 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:33677 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756704Ab1CWVr7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 17:47:59 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX198SulK20x8JrUn4d41hgelwyhMIqFNvQyWsOR1he
	30Ny8bvDU/hbE1
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [PATCH 3/4] viafb: kill crt_setting_information
Date: Wed, 23 Mar 2011 22:03:11 +0000
Message-Id: <1300917792-3880-4-git-send-email-FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <1300917792-3880-1-git-send-email-FlorianSchandinat@gmx.de>
References: <1300917792-3880-1-git-send-email-FlorianSchandinat@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As the iga path is the only remaining information which is also
handled by the active devices there is no reason to keep it.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
---
 drivers/video/via/chip.h     |    4 ----
 drivers/video/via/hw.c       |   28 +++++++++++++---------------
 drivers/video/via/viafbdev.c |    7 ++-----
 drivers/video/via/viafbdev.h |    2 --
 4 files changed, 15 insertions(+), 26 deletions(-)

diff --git a/drivers/video/via/chip.h b/drivers/video/via/chip.h
index 29d7024..1aa0fb3 100644
--- a/drivers/video/via/chip.h
+++ b/drivers/video/via/chip.h
@@ -137,10 +137,6 @@ struct chip_information {
 	struct lvds_chip_information lvds_chip_info2;
 };
 
-struct crt_setting_information {
-	int iga_path;
-};
-
 struct tmds_setting_information {
 	int iga_path;
 	int h_active;
diff --git a/drivers/video/via/hw.c b/drivers/video/via/hw.c
index c4d2136..0098270 100644
--- a/drivers/video/via/hw.c
+++ b/drivers/video/via/hw.c
@@ -770,13 +770,14 @@ static u32 get_lcd_devices(int output_interface)
 /*Set IGA path for each device*/
 void viafb_set_iga_path(void)
 {
+	int crt_iga_path = 0;
 
 	if (viafb_SAMM_ON == 1) {
 		if (viafb_CRT_ON) {
 			if (viafb_primary_dev == CRT_Device)
-				viaparinfo->crt_setting_info->iga_path = IGA1;
+				crt_iga_path = IGA1;
 			else
-				viaparinfo->crt_setting_info->iga_path = IGA2;
+				crt_iga_path = IGA2;
 		}
 
 		if (viafb_DVI_ON) {
@@ -793,8 +794,7 @@ void viafb_set_iga_path(void)
 					UNICHROME_CLE266)) {
 					viaparinfo->
 					lvds_setting_info->iga_path = IGA2;
-					viaparinfo->
-					crt_setting_info->iga_path = IGA1;
+					crt_iga_path = IGA1;
 					viaparinfo->
 					tmds_setting_info->iga_path = IGA1;
 				} else
@@ -814,10 +814,10 @@ void viafb_set_iga_path(void)
 		viafb_SAMM_ON = 0;
 
 		if (viafb_CRT_ON && viafb_LCD_ON) {
-			viaparinfo->crt_setting_info->iga_path = IGA1;
+			crt_iga_path = IGA1;
 			viaparinfo->lvds_setting_info->iga_path = IGA2;
 		} else if (viafb_CRT_ON && viafb_DVI_ON) {
-			viaparinfo->crt_setting_info->iga_path = IGA1;
+			crt_iga_path = IGA1;
 			viaparinfo->tmds_setting_info->iga_path = IGA2;
 		} else if (viafb_LCD_ON && viafb_DVI_ON) {
 			viaparinfo->tmds_setting_info->iga_path = IGA1;
@@ -826,7 +826,7 @@ void viafb_set_iga_path(void)
 			viaparinfo->lvds_setting_info->iga_path = IGA2;
 			viaparinfo->lvds_setting_info2->iga_path = IGA2;
 		} else if (viafb_CRT_ON) {
-			viaparinfo->crt_setting_info->iga_path = IGA1;
+			crt_iga_path = IGA1;
 		} else if (viafb_LCD_ON) {
 			viaparinfo->lvds_setting_info->iga_path = IGA2;
 		} else if (viafb_DVI_ON) {
@@ -837,7 +837,7 @@ void viafb_set_iga_path(void)
 	viaparinfo->shared->iga1_devices = 0;
 	viaparinfo->shared->iga2_devices = 0;
 	if (viafb_CRT_ON) {
-		if (viaparinfo->crt_setting_info->iga_path == IGA1)
+		if (crt_iga_path == IGA1)
 			viaparinfo->shared->iga1_devices |= VIA_CRT;
 		else
 			viaparinfo->shared->iga2_devices |= VIA_CRT;
@@ -2072,8 +2072,6 @@ void __devinit viafb_init_chip_info(int chip_type)
 	init_tmds_chip_info();
 	init_lvds_chip_info();
 
-	viaparinfo->crt_setting_info->iga_path = IGA1;
-
 	/*Set IGA path for each device */
 	viafb_set_iga_path();
 
@@ -2450,15 +2448,15 @@ int viafb_setmode(struct VideoModeTable *vmode_tbl, int video_bpp,
 
 	/* CRT set mode */
 	if (viafb_CRT_ON) {
-		if (viafb_SAMM_ON && (viaparinfo->crt_setting_info->iga_path ==
-			IGA2)) {
+		if (viafb_SAMM_ON &&
+			viaparinfo->shared->iga2_devices & VIA_CRT) {
 			viafb_fill_crtc_timing(crt_timing1, vmode_tbl1,
-				video_bpp1 / 8,
-				viaparinfo->crt_setting_info->iga_path);
+				video_bpp1 / 8, IGA2);
 		} else {
 			viafb_fill_crtc_timing(crt_timing, vmode_tbl,
 				video_bpp / 8,
-				viaparinfo->crt_setting_info->iga_path);
+				(viaparinfo->shared->iga1_devices & VIA_CRT)
+				? IGA1 : IGA2);
 		}
 
 		/* Patch if set_hres is not 8 alignment (1366) to viafb_setmode
diff --git a/drivers/video/via/viafbdev.c b/drivers/video/via/viafbdev.c
index 9d9bb9b..ed9bd79 100644
--- a/drivers/video/via/viafbdev.c
+++ b/drivers/video/via/viafbdev.c
@@ -930,10 +930,8 @@ static int get_primary_device(void)
 	/* Rule: device on iga1 path are the primary device. */
 	if (viafb_SAMM_ON) {
 		if (viafb_CRT_ON) {
-			if (viaparinfo->crt_setting_info->iga_path == IGA1) {
-				DEBUG_MSG(KERN_INFO "CRT IGA Path:%d\n",
-					viaparinfo->
-					crt_setting_info->iga_path);
+			if (viaparinfo->shared->iga1_devices & VIA_CRT) {
+				DEBUG_MSG(KERN_INFO "CRT IGA Path:%d\n", IGA1);
 				primary_device = CRT_Device;
 			}
 		}
@@ -1746,7 +1744,6 @@ int __devinit via_fb_pci_probe(struct viafb_dev *vdev)
 	viaparinfo->lvds_setting_info = &viaparinfo->shared->lvds_setting_info;
 	viaparinfo->lvds_setting_info2 =
 		&viaparinfo->shared->lvds_setting_info2;
-	viaparinfo->crt_setting_info = &viaparinfo->shared->crt_setting_info;
 	viaparinfo->chip_info = &viaparinfo->shared->chip_info;
 
 	if (viafb_dual_fb)
diff --git a/drivers/video/via/viafbdev.h b/drivers/video/via/viafbdev.h
index d66f963..ff60e1d 100644
--- a/drivers/video/via/viafbdev.h
+++ b/drivers/video/via/viafbdev.h
@@ -50,7 +50,6 @@ struct viafb_shared {
 
 	/* All the information will be needed to set engine */
 	struct tmds_setting_information tmds_setting_info;
-	struct crt_setting_information crt_setting_info;
 	struct lvds_setting_information lvds_setting_info;
 	struct lvds_setting_information lvds_setting_info2;
 	struct chip_information chip_info;
@@ -79,7 +78,6 @@ struct viafb_par {
 	/* All the information will be needed to set engine */
 	/* depreciated, use the ones in shared directly */
 	struct tmds_setting_information *tmds_setting_info;
-	struct crt_setting_information *crt_setting_info;
 	struct lvds_setting_information *lvds_setting_info;
 	struct lvds_setting_information *lvds_setting_info2;
 	struct chip_information *chip_info;
-- 
1.6.3.2

