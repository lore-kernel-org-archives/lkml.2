Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756745Ab1CWVsW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 17:48:22 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:33750 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756713Ab1CWVsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 17:48:00 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX1/60kNnkAn6pjKWa2Cv6+3EXicpdyJmMBi2/DH16T
	+eqlaJMcpOK/zL
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [PATCH 4/4] viafb: remove unused max_hres/vres
Date: Wed, 23 Mar 2011 22:03:12 +0000
Message-Id: <1300917792-3880-5-git-send-email-FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <1300917792-3880-1-git-send-email-FlorianSchandinat@gmx.de>
References: <1300917792-3880-1-git-send-email-FlorianSchandinat@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the max_hres and max_vres which are not used at
the moment. In general they could be useful but it would be better
to get them via any standard EDID implementation and not the buggy
incomplete one currently used which is also removed as far as
possible.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
---
 drivers/video/via/chip.h |    2 -
 drivers/video/via/dvi.c  |  138 +---------------------------------------------
 2 files changed, 3 insertions(+), 137 deletions(-)

diff --git a/drivers/video/via/chip.h b/drivers/video/via/chip.h
index 1aa0fb3..3ebf20c 100644
--- a/drivers/video/via/chip.h
+++ b/drivers/video/via/chip.h
@@ -142,8 +142,6 @@ struct tmds_setting_information {
 	int h_active;
 	int v_active;
 	int max_pixel_clock;
-	int max_hres;
-	int max_vres;
 };
 
 struct lvds_setting_information {
diff --git a/drivers/video/via/dvi.c b/drivers/video/via/dvi.c
index 41ca198..3dbcd77 100644
--- a/drivers/video/via/dvi.c
+++ b/drivers/video/via/dvi.c
@@ -28,9 +28,6 @@ static int tmds_register_read_bytes(int index, u8 *buff, int buff_len);
 static void __devinit dvi_get_panel_size_from_DDCv1(
 	struct tmds_chip_information *tmds_chip,
 	struct tmds_setting_information *tmds_setting);
-static void __devinit dvi_get_panel_size_from_DDCv2(
-	struct tmds_chip_information *tmds_chip,
-	struct tmds_setting_information *tmds_setting);
 static int viafb_dvi_query_EDID(void);
 
 static int check_tmds_chip(int device_id_subaddr, int device_id)
@@ -47,17 +44,8 @@ void __devinit viafb_init_dvi_size(struct tmds_chip_information *tmds_chip,
 	DEBUG_MSG(KERN_INFO "viafb_init_dvi_size()\n");
 
 	viafb_dvi_sense();
-	switch (viafb_dvi_query_EDID()) {
-	case 1:
+	if (viafb_dvi_query_EDID() == 1)
 		dvi_get_panel_size_from_DDCv1(tmds_chip, tmds_setting);
-		break;
-	case 2:
-		dvi_get_panel_size_from_DDCv2(tmds_chip, tmds_setting);
-		break;
-	default:
-		printk(KERN_WARNING "viafb_init_dvi_size: DVI panel size undetected!\n");
-		break;
-	}
 
 	return;
 }
@@ -306,12 +294,7 @@ static int viafb_dvi_query_EDID(void)
 		return EDID_VERSION_1;	/* Found EDID1 Table */
 	}
 
-	data0 = (u8) tmds_register_read(0x00);
-	viaparinfo->chip_info->tmds_chip_info.tmds_chip_slave_addr = restore;
-	if (data0 == 0x20)
-		return EDID_VERSION_2;	/* Found EDID2 Table */
-	else
-		return false;
+	return false;
 }
 
 /* Get Panel Size Using EDID1 Table */
@@ -319,50 +302,15 @@ static void __devinit dvi_get_panel_size_from_DDCv1(
 	struct tmds_chip_information *tmds_chip,
 	struct tmds_setting_information *tmds_setting)
 {
-	int i, max_h = 0, tmp, restore;
-	unsigned char rData;
+	int i, restore;
 	unsigned char EDID_DATA[18];
 
 	DEBUG_MSG(KERN_INFO "\n dvi_get_panel_size_from_DDCv1 \n");
 
 	restore = tmds_chip->tmds_chip_slave_addr;
 	tmds_chip->tmds_chip_slave_addr = 0xA0;
-
-	rData = tmds_register_read(0x23);
-	if (rData & 0x3C)
-		max_h = 640;
-	if (rData & 0xC0)
-		max_h = 720;
-	if (rData & 0x03)
-		max_h = 800;
-
-	rData = tmds_register_read(0x24);
-	if (rData & 0xC0)
-		max_h = 800;
-	if (rData & 0x1E)
-		max_h = 1024;
-	if (rData & 0x01)
-		max_h = 1280;
-
 	for (i = 0x25; i < 0x6D; i++) {
 		switch (i) {
-		case 0x26:
-		case 0x28:
-		case 0x2A:
-		case 0x2C:
-		case 0x2E:
-		case 0x30:
-		case 0x32:
-		case 0x34:
-			rData = tmds_register_read(i);
-			if (rData == 1)
-				break;
-			/* data = (data + 31) * 8 */
-			tmp = (rData + 31) << 3;
-			if (tmp > max_h)
-				max_h = tmp;
-			break;
-
 		case 0x36:
 		case 0x48:
 		case 0x5A:
@@ -383,91 +331,11 @@ static void __devinit dvi_get_panel_size_from_DDCv1(
 		}
 	}
 
-	tmds_setting->max_hres = max_h;
-	switch (max_h) {
-	case 640:
-		tmds_setting->max_vres = 480;
-		break;
-	case 800:
-		tmds_setting->max_vres = 600;
-		break;
-	case 1024:
-		tmds_setting->max_vres = 768;
-		break;
-	case 1280:
-		tmds_setting->max_vres = 1024;
-		break;
-	case 1400:
-		tmds_setting->max_vres = 1050;
-		break;
-	case 1440:
-		tmds_setting->max_vres = 1050;
-		break;
-	case 1600:
-		tmds_setting->max_vres = 1200;
-		break;
-	case 1920:
-		tmds_setting->max_vres = 1080;
-		break;
-	default:
-		DEBUG_MSG(KERN_INFO "Unknown panel size max resolution = %d ! "
-					 "set default panel size.\n", max_h);
-		break;
-	}
-
 	DEBUG_MSG(KERN_INFO "DVI max pixelclock = %d\n",
 		tmds_setting->max_pixel_clock);
 	tmds_chip->tmds_chip_slave_addr = restore;
 }
 
-/* Get Panel Size Using EDID2 Table */
-static void __devinit dvi_get_panel_size_from_DDCv2(
-	struct tmds_chip_information *tmds_chip,
-	struct tmds_setting_information *tmds_setting)
-{
-	int restore;
-	unsigned char R_Buffer[2];
-
-	DEBUG_MSG(KERN_INFO "\n dvi_get_panel_size_from_DDCv2 \n");
-
-	restore = tmds_chip->tmds_chip_slave_addr;
-	tmds_chip->tmds_chip_slave_addr = 0xA2;
-
-	/* Horizontal: 0x76, 0x77 */
-	tmds_register_read_bytes(0x76, R_Buffer, 2);
-	tmds_setting->max_hres = R_Buffer[0] + (R_Buffer[1] << 8);
-
-	switch (tmds_setting->max_hres) {
-	case 640:
-		tmds_setting->max_vres = 480;
-		break;
-	case 800:
-		tmds_setting->max_vres = 600;
-		break;
-	case 1024:
-		tmds_setting->max_vres = 768;
-		break;
-	case 1280:
-		tmds_setting->max_vres = 1024;
-		break;
-	case 1400:
-		tmds_setting->max_vres = 1050;
-		break;
-	case 1440:
-		tmds_setting->max_vres = 1050;
-		break;
-	case 1600:
-		tmds_setting->max_vres = 1200;
-		break;
-	default:
-		DEBUG_MSG(KERN_INFO "Unknown panel size max resolution = %d! "
-			"set default panel size.\n", tmds_setting->max_hres);
-		break;
-	}
-
-	tmds_chip->tmds_chip_slave_addr = restore;
-}
-
 /* If Disable DVI, turn off pad */
 void viafb_dvi_disable(void)
 {
-- 
1.6.3.2

