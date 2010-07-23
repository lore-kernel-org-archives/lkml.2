Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760919Ab0GWPb7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 11:31:59 -0400
Received: from mail.gmx.net ([213.165.64.20]:59117 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1760208Ab0GWP3e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 11:29:34 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX188osUc6/E8RpoZTDbHLealmWjyi8NOaIlKbmsPJ7
	y9EXjfxrLaAGdE
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Joseph Chan <JosephChan@via.com.tw>
Subject: [PATCH 02/11] viafb: remove duplicated scaling code
Date: Fri, 23 Jul 2010 15:39:17 +0000
Message-Id: <1279899566-4359-3-git-send-email-FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <1279899566-4359-1-git-send-email-FlorianSchandinat@gmx.de>
References: <1279899566-4359-1-git-send-email-FlorianSchandinat@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

viafb: remove duplicated scaling code

The code for P4M900 does the same as for all newer IGPs so there is no
reason to duplicate it. Just reducing the code to maintain.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Joseph Chan <JosephChan@via.com.tw>
---
 drivers/video/via/lcd.c |   75 +---------------------------------------------
 1 files changed, 2 insertions(+), 73 deletions(-)

diff --git a/drivers/video/via/lcd.c b/drivers/video/via/lcd.c
index 2ab0f15..438a106 100644
--- a/drivers/video/via/lcd.c
+++ b/drivers/video/via/lcd.c
@@ -75,8 +75,6 @@ static void check_diport_of_integrated_lvds(
 static struct display_timing lcd_centering_timging(struct display_timing
 					    mode_crt_reg,
 					   struct display_timing panel_crt_reg);
-static void viafb_load_scaling_factor_for_p4m900(int set_hres,
-	int set_vres, int panel_hres, int panel_vres);
 
 static int check_lvds_chip(int device_id_subaddr, int device_id)
 {
@@ -437,11 +435,6 @@ static void load_lcd_scaling(int set_hres, int set_vres, int panel_hres,
 
 	/* LCD Scaling Enable */
 	viafb_write_reg_mask(CR79, VIACR, 0x07, BIT0 + BIT1 + BIT2);
-	if (UNICHROME_P4M900 == viaparinfo->chip_info->gfx_chip_name) {
-		viafb_load_scaling_factor_for_p4m900(set_hres, set_vres,
-					       panel_hres, panel_vres);
-		return;
-	}
 
 	/* Check if expansion for horizontal */
 	if (set_hres != panel_hres) {
@@ -464,6 +457,7 @@ static void load_lcd_scaling(int set_hres, int set_vres, int panel_hres,
 		case UNICHROME_CX700:
 		case UNICHROME_K8M890:
 		case UNICHROME_P4M890:
+		case UNICHROME_P4M900:
 			reg_value =
 			    K800_LCD_HOR_SCF_FORMULA(set_hres, panel_hres);
 			/* Horizontal scaling enabled */
@@ -503,6 +497,7 @@ static void load_lcd_scaling(int set_hres, int set_vres, int panel_hres,
 		case UNICHROME_CX700:
 		case UNICHROME_K8M890:
 		case UNICHROME_P4M890:
+		case UNICHROME_P4M900:
 			reg_value =
 			    K800_LCD_VER_SCF_FORMULA(set_vres, panel_vres);
 			/* Vertical scaling enabled */
@@ -1139,69 +1134,3 @@ bool viafb_lcd_get_mobile_state(bool *mobile)
 		return false;
 	}
 }
-
-static void viafb_load_scaling_factor_for_p4m900(int set_hres,
-	int set_vres, int panel_hres, int panel_vres)
-{
-	int h_scaling_factor;
-	int v_scaling_factor;
-	u8 cra2 = 0;
-	u8 cr77 = 0;
-	u8 cr78 = 0;
-	u8 cr79 = 0;
-	u8 cr9f = 0;
-	/* Check if expansion for horizontal */
-	if (set_hres < panel_hres) {
-		/* Load Horizontal Scaling Factor */
-
-		/* For VIA_K8M800 or later chipsets. */
-		h_scaling_factor =
-		    K800_LCD_HOR_SCF_FORMULA(set_hres, panel_hres);
-		/* HSCaleFactor[1:0] at CR9F[1:0] */
-		cr9f = h_scaling_factor & 0x0003;
-		/* HSCaleFactor[9:2] at CR77[7:0] */
-		cr77 = (h_scaling_factor & 0x03FC) >> 2;
-		/* HSCaleFactor[11:10] at CR79[5:4] */
-		cr79 = (h_scaling_factor & 0x0C00) >> 10;
-		cr79 <<= 4;
-
-		/* Horizontal scaling enabled */
-		cra2 = 0xC0;
-
-		DEBUG_MSG(KERN_INFO "Horizontal Scaling value = %d\n",
-			  h_scaling_factor);
-	} else {
-		/* Horizontal scaling disabled */
-		cra2 = 0x00;
-	}
-
-	/* Check if expansion for vertical */
-	if (set_vres < panel_vres) {
-		/* Load Vertical Scaling Factor */
-
-		/* For VIA_K8M800 or later chipsets. */
-		v_scaling_factor =
-		    K800_LCD_VER_SCF_FORMULA(set_vres, panel_vres);
-
-		/* Vertical scaling enabled */
-		cra2 |= 0x08;
-		/* VSCaleFactor[0] at CR79[3] */
-		cr79 |= ((v_scaling_factor & 0x0001) << 3);
-		/* VSCaleFactor[8:1] at CR78[7:0] */
-		cr78 |= (v_scaling_factor & 0x01FE) >> 1;
-		/* VSCaleFactor[10:9] at CR79[7:6] */
-		cr79 |= ((v_scaling_factor & 0x0600) >> 9) << 6;
-
-		DEBUG_MSG(KERN_INFO "Vertical Scaling value = %d\n",
-			  v_scaling_factor);
-	} else {
-		/* Vertical scaling disabled */
-		cra2 |= 0x00;
-	}
-
-	viafb_write_reg_mask(CRA2, VIACR, cra2, BIT3 + BIT6 + BIT7);
-	viafb_write_reg_mask(CR77, VIACR, cr77, 0xFF);
-	viafb_write_reg_mask(CR78, VIACR, cr78, 0xFF);
-	viafb_write_reg_mask(CR79, VIACR, cr79, 0xF8);
-	viafb_write_reg_mask(CR9F, VIACR, cr9f, BIT0 + BIT1);
-}
-- 
1.6.3.2

