Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760816Ab0GWPar (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 11:30:47 -0400
Received: from mail.gmx.net ([213.165.64.20]:59666 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1760691Ab0GWP3l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 11:29:41 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX1+tbY9j3hqtyTpff1vmvV5OxDbABMFG8HnPNpiaMF
	3Ok08ISTBUrxwX
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Joseph Chan <JosephChan@via.com.tw>
Subject: [PATCH 06/11] viafb: simplify lcd size "detection"
Date: Fri, 23 Jul 2010 15:39:21 +0000
Message-Id: <1279899566-4359-7-git-send-email-FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <1279899566-4359-1-git-send-email-FlorianSchandinat@gmx.de>
References: <1279899566-4359-1-git-send-email-FlorianSchandinat@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

viafb: simplify lcd size "detection"

Remove all occurences of get_lcd_size_method as only the values
GET_LCD_SIZE_BY_VGA_BIOS and GET_LCD_SIZE_BY_USER_SETTING were used
which had the identical code so there is no need to make things look
more complicated than they actually are.
Just a bit of of cleanup, really no regressions expected.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Joseph Chan <JosephChan@via.com.tw>
---
 drivers/video/via/chip.h |    1 -
 drivers/video/via/hw.c   |    9 ---------
 drivers/video/via/lcd.c  |   27 +--------------------------
 drivers/video/via/lcd.h  |    5 -----
 4 files changed, 1 insertions(+), 41 deletions(-)

diff --git a/drivers/video/via/chip.h b/drivers/video/via/chip.h
index d9b6e06..ef1f3de 100644
--- a/drivers/video/via/chip.h
+++ b/drivers/video/via/chip.h
@@ -160,7 +160,6 @@ struct lvds_setting_information {
 	int v_active;
 	int bpp;
 	int refresh_rate;
-	int get_lcd_size_method;
 	int lcd_panel_id;
 	int lcd_panel_hres;
 	int lcd_panel_vres;
diff --git a/drivers/video/via/hw.c b/drivers/video/via/hw.c
index b996803..05be8c1 100644
--- a/drivers/video/via/hw.c
+++ b/drivers/video/via/hw.c
@@ -1791,8 +1791,6 @@ void viafb_init_chip_info(int chip_type)
 	viafb_set_iga_path();
 
 	viaparinfo->lvds_setting_info->display_method = viafb_lcd_dsp_method;
-	viaparinfo->lvds_setting_info->get_lcd_size_method =
-		GET_LCD_SIZE_BY_USER_SETTING;
 	viaparinfo->lvds_setting_info->lcd_mode = viafb_lcd_mode;
 	viaparinfo->lvds_setting_info2->display_method =
 		viaparinfo->lvds_setting_info->display_method;
@@ -1946,13 +1944,6 @@ static void init_tmds_chip_info(void)
 
 static void init_lvds_chip_info(void)
 {
-	if (viafb_lcd_panel_id > LCD_PANEL_ID_MAXIMUM)
-		viaparinfo->lvds_setting_info->get_lcd_size_method =
-		    GET_LCD_SIZE_BY_VGA_BIOS;
-	else
-		viaparinfo->lvds_setting_info->get_lcd_size_method =
-		    GET_LCD_SIZE_BY_USER_SETTING;
-
 	viafb_lvds_trasmitter_identify();
 	viafb_init_lcd_size();
 	viafb_init_lvds_output_interface(&viaparinfo->chip_info->lvds_chip_info,
diff --git a/drivers/video/via/lcd.c b/drivers/video/via/lcd.c
index 568d15b..fc25ae3 100644
--- a/drivers/video/via/lcd.c
+++ b/drivers/video/via/lcd.c
@@ -87,33 +87,8 @@ static int check_lvds_chip(int device_id_subaddr, int device_id)
 void viafb_init_lcd_size(void)
 {
 	DEBUG_MSG(KERN_INFO "viafb_init_lcd_size()\n");
-	DEBUG_MSG(KERN_INFO
-		"viaparinfo->lvds_setting_info->get_lcd_size_method %d\n",
-		viaparinfo->lvds_setting_info->get_lcd_size_method);
 
-	switch (viaparinfo->lvds_setting_info->get_lcd_size_method) {
-	case GET_LCD_SIZE_BY_SYSTEM_BIOS:
-		break;
-	case GET_LCD_SZIE_BY_HW_STRAPPING:
-		break;
-	case GET_LCD_SIZE_BY_VGA_BIOS:
-		DEBUG_MSG(KERN_INFO "Get LCD Size method by VGA BIOS !!\n");
-		fp_id_to_vindex(viafb_lcd_panel_id);
-		DEBUG_MSG(KERN_INFO "LCD Panel_ID = %d\n",
-			  viaparinfo->lvds_setting_info->lcd_panel_id);
-		break;
-	case GET_LCD_SIZE_BY_USER_SETTING:
-		DEBUG_MSG(KERN_INFO "Get LCD Size method by user setting !!\n");
-		fp_id_to_vindex(viafb_lcd_panel_id);
-		DEBUG_MSG(KERN_INFO "LCD Panel_ID = %d\n",
-			  viaparinfo->lvds_setting_info->lcd_panel_id);
-		break;
-	default:
-		DEBUG_MSG(KERN_INFO "viafb_init_lcd_size fail\n");
-		viaparinfo->lvds_setting_info->lcd_panel_id =
-			LCD_PANEL_ID1_800X600;
-		fp_id_to_vindex(LCD_PANEL_ID1_800X600);
-	}
+	fp_id_to_vindex(viafb_lcd_panel_id);
 	viaparinfo->lvds_setting_info2->lcd_panel_id =
 		viaparinfo->lvds_setting_info->lcd_panel_id;
 	viaparinfo->lvds_setting_info2->lcd_panel_hres =
diff --git a/drivers/video/via/lcd.h b/drivers/video/via/lcd.h
index 9762ec6..b348efc 100644
--- a/drivers/video/via/lcd.h
+++ b/drivers/video/via/lcd.h
@@ -28,11 +28,6 @@
 #define     VT3271_DEVICE_ID_REG        0x02
 #define     VT3271_DEVICE_ID            0x71
 
-#define     GET_LCD_SIZE_BY_SYSTEM_BIOS     0x01
-#define     GET_LCD_SIZE_BY_VGA_BIOS        0x02
-#define     GET_LCD_SZIE_BY_HW_STRAPPING    0x03
-#define     GET_LCD_SIZE_BY_USER_SETTING    0x04
-
 /* Definition DVI Panel ID*/
 /* Resolution: 640x480,   Channel: single, Dithering: Enable */
 #define     LCD_PANEL_ID0_640X480       0x00
-- 
1.6.3.2

