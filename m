Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932125Ab1DXBo5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Apr 2011 21:44:57 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:36767 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757405Ab1DXBof (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Apr 2011 21:44:35 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX1/HNBBSyXvHKANB6q8pKYmLEbLc7ix7Nz5so26zFG
	8mgSpu4Is5nVSj
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [PATCH 3/3] viafb: replace custom return values
Date: Sun, 24 Apr 2011 02:00:43 +0000
Message-Id: <1303610443-8681-4-git-send-email-FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <1303610443-8681-1-git-send-email-FlorianSchandinat@gmx.de>
References: <1303610443-8681-1-git-send-email-FlorianSchandinat@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch replaces OK/FAIL by true/false which is simpler and saner.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
---
 drivers/video/via/dvi.c   |   22 +++++++++-------------
 drivers/video/via/dvi.h   |    2 +-
 drivers/video/via/lcd.c   |   16 ++++++----------
 drivers/video/via/lcd.h   |    2 +-
 drivers/video/via/share.h |    8 --------
 5 files changed, 17 insertions(+), 33 deletions(-)

diff --git a/drivers/video/via/dvi.c b/drivers/video/via/dvi.c
index 3dbcd77..b1f3647 100644
--- a/drivers/video/via/dvi.c
+++ b/drivers/video/via/dvi.c
@@ -30,12 +30,9 @@ static void __devinit dvi_get_panel_size_from_DDCv1(
 	struct tmds_setting_information *tmds_setting);
 static int viafb_dvi_query_EDID(void);
 
-static int check_tmds_chip(int device_id_subaddr, int device_id)
+static inline bool check_tmds_chip(int device_id_subaddr, int device_id)
 {
-	if (tmds_register_read(device_id_subaddr) == device_id)
-		return OK;
-	else
-		return FAIL;
+	return tmds_register_read(device_id_subaddr) == device_id;
 }
 
 void __devinit viafb_init_dvi_size(struct tmds_chip_information *tmds_chip,
@@ -50,7 +47,7 @@ void __devinit viafb_init_dvi_size(struct tmds_chip_information *tmds_chip,
 	return;
 }
 
-int __devinit viafb_tmds_trasmitter_identify(void)
+bool __devinit viafb_tmds_trasmitter_identify(void)
 {
 	unsigned char sr2a = 0, sr1e = 0, sr3e = 0;
 
@@ -89,7 +86,7 @@ int __devinit viafb_tmds_trasmitter_identify(void)
 	viaparinfo->chip_info->
 		tmds_chip_info.tmds_chip_slave_addr = VT1632_TMDS_I2C_ADDR;
 	viaparinfo->chip_info->tmds_chip_info.i2c_port = VIA_PORT_31;
-	if (check_tmds_chip(VT1632_DEVICE_ID_REG, VT1632_DEVICE_ID) != FAIL) {
+	if (check_tmds_chip(VT1632_DEVICE_ID_REG, VT1632_DEVICE_ID)) {
 		/*
 		 * Currently only support 12bits,dual edge,add 24bits mode later
 		 */
@@ -100,11 +97,10 @@ int __devinit viafb_tmds_trasmitter_identify(void)
 			  viaparinfo->chip_info->tmds_chip_info.tmds_chip_name);
 		DEBUG_MSG(KERN_INFO "\n %2d",
 			  viaparinfo->chip_info->tmds_chip_info.i2c_port);
-		return OK;
+		return true;
 	} else {
 		viaparinfo->chip_info->tmds_chip_info.i2c_port = VIA_PORT_2C;
-		if (check_tmds_chip(VT1632_DEVICE_ID_REG, VT1632_DEVICE_ID)
-		    != FAIL) {
+		if (check_tmds_chip(VT1632_DEVICE_ID_REG, VT1632_DEVICE_ID)) {
 			tmds_register_write(0x08, 0x3b);
 			DEBUG_MSG(KERN_INFO "\n VT1632 TMDS ! \n");
 			DEBUG_MSG(KERN_INFO "\n %2d",
@@ -113,7 +109,7 @@ int __devinit viafb_tmds_trasmitter_identify(void)
 			DEBUG_MSG(KERN_INFO "\n %2d",
 				  viaparinfo->chip_info->
 				  tmds_chip_info.i2c_port);
-			return OK;
+			return true;
 		}
 	}
 
@@ -123,7 +119,7 @@ int __devinit viafb_tmds_trasmitter_identify(void)
 	    ((viafb_display_hardware_layout == HW_LAYOUT_DVI_ONLY) ||
 	     (viafb_display_hardware_layout == HW_LAYOUT_LCD_DVI))) {
 		DEBUG_MSG(KERN_INFO "\n Integrated TMDS ! \n");
-		return OK;
+		return true;
 	}
 
 	switch (viaparinfo->chip_info->gfx_chip_name) {
@@ -147,7 +143,7 @@ int __devinit viafb_tmds_trasmitter_identify(void)
 		tmds_chip_info.tmds_chip_name = NON_TMDS_TRANSMITTER;
 	viaparinfo->chip_info->tmds_chip_info.
 		tmds_chip_slave_addr = VT1632_TMDS_I2C_ADDR;
-	return FAIL;
+	return false;
 }
 
 static void tmds_register_write(int index, u8 data)
diff --git a/drivers/video/via/dvi.h b/drivers/video/via/dvi.h
index 2c525c0..f473dd0 100644
--- a/drivers/video/via/dvi.h
+++ b/drivers/video/via/dvi.h
@@ -56,7 +56,7 @@
 int viafb_dvi_sense(void);
 void viafb_dvi_disable(void);
 void viafb_dvi_enable(void);
-int __devinit viafb_tmds_trasmitter_identify(void);
+bool __devinit viafb_tmds_trasmitter_identify(void);
 void __devinit viafb_init_dvi_size(struct tmds_chip_information *tmds_chip,
 	struct tmds_setting_information *tmds_setting);
 void viafb_dvi_set_mode(struct VideoModeTable *videoMode, int mode_bpp,
diff --git a/drivers/video/via/lcd.c b/drivers/video/via/lcd.c
index 64bc7e7..6984046 100644
--- a/drivers/video/via/lcd.c
+++ b/drivers/video/via/lcd.c
@@ -48,7 +48,6 @@ static struct _lcd_scaling_factor lcd_scaling_factor_CLE = {
 	{LCD_VER_SCALING_FACTOR_REG_NUM_CLE, {{CR78, 0, 7}, {CR79, 6, 7} } }
 };
 
-static int check_lvds_chip(int device_id_subaddr, int device_id);
 static bool lvds_identify_integratedlvds(void);
 static void __devinit fp_id_to_vindex(int panel_id);
 static int lvds_register_read(int index);
@@ -84,12 +83,9 @@ static struct display_timing lcd_centering_timging(struct display_timing
 					    mode_crt_reg,
 					   struct display_timing panel_crt_reg);
 
-static int check_lvds_chip(int device_id_subaddr, int device_id)
+static inline bool check_lvds_chip(int device_id_subaddr, int device_id)
 {
-	if (lvds_register_read(device_id_subaddr) == device_id)
-		return OK;
-	else
-		return FAIL;
+	return lvds_register_read(device_id_subaddr) == device_id;
 }
 
 void __devinit viafb_init_lcd_size(void)
@@ -150,7 +146,7 @@ static bool lvds_identify_integratedlvds(void)
 	return true;
 }
 
-int __devinit viafb_lvds_trasmitter_identify(void)
+bool __devinit viafb_lvds_trasmitter_identify(void)
 {
 	if (viafb_lvds_identify_vt1636(VIA_PORT_31)) {
 		viaparinfo->chip_info->lvds_chip_info.i2c_port = VIA_PORT_31;
@@ -175,20 +171,20 @@ int __devinit viafb_lvds_trasmitter_identify(void)
 	viaparinfo->chip_info->lvds_chip_info.lvds_chip_slave_addr =
 		VT1631_LVDS_I2C_ADDR;
 
-	if (check_lvds_chip(VT1631_DEVICE_ID_REG, VT1631_DEVICE_ID) != FAIL) {
+	if (check_lvds_chip(VT1631_DEVICE_ID_REG, VT1631_DEVICE_ID)) {
 		DEBUG_MSG(KERN_INFO "\n VT1631 LVDS ! \n");
 		DEBUG_MSG(KERN_INFO "\n %2d",
 			  viaparinfo->chip_info->lvds_chip_info.lvds_chip_name);
 		DEBUG_MSG(KERN_INFO "\n %2d",
 			  viaparinfo->chip_info->lvds_chip_info.lvds_chip_name);
-		return OK;
+		return true;
 	}
 
 	viaparinfo->chip_info->lvds_chip_info.lvds_chip_name =
 		NON_LVDS_TRANSMITTER;
 	viaparinfo->chip_info->lvds_chip_info.lvds_chip_slave_addr =
 		VT1631_LVDS_I2C_ADDR;
-	return FAIL;
+	return false;
 }
 
 static void __devinit fp_id_to_vindex(int panel_id)
diff --git a/drivers/video/via/lcd.h b/drivers/video/via/lcd.h
index c7909fe..75f60a6 100644
--- a/drivers/video/via/lcd.h
+++ b/drivers/video/via/lcd.h
@@ -79,7 +79,7 @@ void __devinit viafb_init_lvds_output_interface(struct lvds_chip_information
 void viafb_lcd_set_mode(struct crt_mode_table *mode_crt_table,
 		  struct lvds_setting_information *plvds_setting_info,
 		  struct lvds_chip_information *plvds_chip_info);
-int __devinit viafb_lvds_trasmitter_identify(void);
+bool __devinit viafb_lvds_trasmitter_identify(void);
 void viafb_init_lvds_output_interface(struct lvds_chip_information
 				*plvds_chip_info,
 				struct lvds_setting_information
diff --git a/drivers/video/via/share.h b/drivers/video/via/share.h
index 4b7831f..beb59bc 100644
--- a/drivers/video/via/share.h
+++ b/drivers/video/via/share.h
@@ -22,14 +22,6 @@
 #ifndef __SHARE_H__
 #define __SHARE_H__
 
-/* Define Return Value */
-#define FAIL        -1
-#define OK          1
-
-#ifndef NULL
-#define NULL 0
-#endif
-
 /* Define Bit Field */
 #define BIT0    0x01
 #define BIT1    0x02
-- 
1.6.3.2

