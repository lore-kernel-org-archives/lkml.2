Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759408Ab0HLABT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 20:01:19 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:45818 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1758930Ab0HLABQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 20:01:16 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX1/ADhJF/J7APmmw98YxRAVqm22B/kCxEHImfkMjWv
	3UeVQf4TnqgaTK
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Joseph Chan <JosephChan@via.com.tw>
Subject: [[PATCH 11/11]] viafb: merge the remaining output path with enable functions
Date: Thu, 12 Aug 2010 00:11:53 +0000
Message-Id: <1281571913-9087-1-git-send-email-FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <1281570580-8253-1-git-send-email-FlorianSchandinat@gmx.de>
References: <1281570580-8253-1-git-send-email-FlorianSchandinat@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

viafb: merge the remaining output path with enable functions

This patch merges the remaining functionality of the output path
function in the associated enabling functions. This is very natural as
most of the remaining code does actually enable the device.
Just some more or less intelligent code merge. If no stupid mistakes
occured there should be no regressions.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Joseph Chan <JosephChan@via.com.tw>
---
 drivers/video/via/dvi.c |  146 +++++++++++++++++++++++++++++++-----------
 drivers/video/via/hw.c  |  164 -----------------------------------------------
 drivers/video/via/hw.h  |    3 -
 drivers/video/via/lcd.c |   28 ++++++++
 4 files changed, 136 insertions(+), 205 deletions(-)

diff --git a/drivers/video/via/dvi.c b/drivers/video/via/dvi.c
index ab6145d..7c82f6f 100644
--- a/drivers/video/via/dvi.c
+++ b/drivers/video/via/dvi.c
@@ -496,38 +496,103 @@ void viafb_dvi_disable(void)
 		viafb_read_reg(VIACR, CRD2) | 0x08);
 }
 
+static void dvi_patch_skew_dvp0(void)
+{
+	/* Reset data driving first: */
+	viafb_write_reg_mask(SR1B, VIASR, 0, BIT1);
+	viafb_write_reg_mask(SR2A, VIASR, 0, BIT4);
+
+	switch (viaparinfo->chip_info->gfx_chip_name) {
+	case UNICHROME_P4M890:
+		{
+			if ((viaparinfo->tmds_setting_info->h_active == 1600) &&
+				(viaparinfo->tmds_setting_info->v_active ==
+				1200))
+				viafb_write_reg_mask(CR96, VIACR, 0x03,
+					       BIT0 + BIT1 + BIT2);
+			else
+				viafb_write_reg_mask(CR96, VIACR, 0x07,
+					       BIT0 + BIT1 + BIT2);
+			break;
+		}
+
+	case UNICHROME_P4M900:
+		{
+			viafb_write_reg_mask(CR96, VIACR, 0x07,
+				       BIT0 + BIT1 + BIT2 + BIT3);
+			viafb_write_reg_mask(SR1B, VIASR, 0x02, BIT1);
+			viafb_write_reg_mask(SR2A, VIASR, 0x10, BIT4);
+			break;
+		}
+
+	default:
+		{
+			break;
+		}
+	}
+}
+
+static void dvi_patch_skew_dvp_low(void)
+{
+	switch (viaparinfo->chip_info->gfx_chip_name) {
+	case UNICHROME_K8M890:
+		{
+			viafb_write_reg_mask(CR99, VIACR, 0x03, BIT0 + BIT1);
+			break;
+		}
+
+	case UNICHROME_P4M900:
+		{
+			viafb_write_reg_mask(CR99, VIACR, 0x08,
+				       BIT0 + BIT1 + BIT2 + BIT3);
+			break;
+		}
+
+	case UNICHROME_P4M890:
+		{
+			viafb_write_reg_mask(CR99, VIACR, 0x0F,
+				       BIT0 + BIT1 + BIT2 + BIT3);
+			break;
+		}
+
+	default:
+		{
+			break;
+		}
+	}
+}
+
 /* If Enable DVI, turn off pad */
 void viafb_dvi_enable(void)
 {
 	u8 data;
 
-	if (viaparinfo->chip_info->
-		tmds_chip_info.output_interface == INTERFACE_DVP0) {
-		viafb_write_reg(SR1E, VIASR,
-			viafb_read_reg(VIASR, SR1E) | 0xC0);
+	switch (viaparinfo->chip_info->tmds_chip_info.output_interface) {
+	case INTERFACE_DVP0:
+		viafb_write_reg_mask(CR6B, VIACR, 0x01, BIT0);
+		viafb_write_reg_mask(CR6C, VIACR, 0x21, BIT0 + BIT5);
+		viafb_write_reg_mask(SR1E, VIASR, 0xC0, BIT7 + BIT6);
+		dvi_patch_skew_dvp0();
 		if (viaparinfo->chip_info->gfx_chip_name == UNICHROME_CLE266)
 			tmds_register_write(0x88, 0x3b);
 		else
 			/*clear CR91[5] to direct on display period
 			   in the secondary diplay path */
-			viafb_write_reg(CR91, VIACR,
-			viafb_read_reg(VIACR, CR91) & 0xDF);
-	}
+			via_write_reg_mask(VIACR, 0x91, 0x00, 0x20);
+		break;
 
-	if (viaparinfo->chip_info->
-		tmds_chip_info.output_interface == INTERFACE_DVP1) {
-		viafb_write_reg(SR1E, VIASR,
-			viafb_read_reg(VIASR, SR1E) | 0x30);
+	case INTERFACE_DVP1:
+		if (viaparinfo->chip_info->gfx_chip_name == UNICHROME_CLE266)
+			viafb_write_reg_mask(CR93, VIACR, 0x21, BIT0 + BIT5);
 
+		viafb_write_reg_mask(SR1E, VIASR, 0x30, BIT4 + BIT5);
 		/*fix dvi cann't be enabled with MB VT5718C4 - Al Zhang */
-		if (viaparinfo->chip_info->gfx_chip_name == UNICHROME_CLE266) {
+		if (viaparinfo->chip_info->gfx_chip_name == UNICHROME_CLE266)
 			tmds_register_write(0x88, 0x3b);
-		} else {
+		else
 			/*clear CR91[5] to direct on display period
 			  in the secondary diplay path */
-			viafb_write_reg(CR91, VIACR,
-			viafb_read_reg(VIACR, CR91) & 0xDF);
-		}
+			via_write_reg_mask(VIACR, 0x91, 0x00, 0x20);
 
 		/*fix DVI cannot enable on EPIA-M board */
 		if (viafb_platform_epia_dvi == 1) {
@@ -539,36 +604,41 @@ void viafb_dvi_enable(void)
 				else
 					data = 0x37;
 				viafb_i2c_writebyte(viaparinfo->chip_info->
-						       tmds_chip_info.i2c_port,
-						    viaparinfo->chip_info->
-						       tmds_chip_info.tmds_chip_slave_addr,
-						    0x08, data);
+					tmds_chip_info.i2c_port,
+					viaparinfo->chip_info->
+					tmds_chip_info.tmds_chip_slave_addr,
+					0x08, data);
 			}
 		}
-	}
+		break;
 
-	if (viaparinfo->chip_info->
-		tmds_chip_info.output_interface == INTERFACE_DFP_HIGH) {
-		viafb_write_reg(SR2A, VIASR,
-			viafb_read_reg(VIASR, SR2A) | 0x0C);
-		viafb_write_reg(CR91, VIACR,
-			viafb_read_reg(VIACR, CR91) & 0xDF);
-	}
+	case INTERFACE_DFP_HIGH:
+		if (viaparinfo->chip_info->gfx_chip_name != UNICHROME_CLE266)
+			via_write_reg_mask(VIACR, CR97, 0x03, 0x03);
 
-	if (viaparinfo->chip_info->
-		tmds_chip_info.output_interface == INTERFACE_DFP_LOW) {
-		viafb_write_reg(SR2A, VIASR,
-			viafb_read_reg(VIASR, SR2A) | 0x03);
-		viafb_write_reg(CR91, VIACR,
-			viafb_read_reg(VIACR, CR91) & 0xDF);
-	}
-	if (viaparinfo->chip_info->
-		tmds_chip_info.output_interface == INTERFACE_TMDS) {
+		viafb_write_reg_mask(SR2A, VIASR, 0x0C, BIT2 + BIT3);
+		via_write_reg_mask(VIACR, 0x91, 0x00, 0x20);
+		break;
+
+	case INTERFACE_DFP_LOW:
+		if (viaparinfo->chip_info->gfx_chip_name == UNICHROME_CLE266)
+			break;
+		viafb_write_reg_mask(SR2A, VIASR, 0x03, BIT0 + BIT1);
+		dvi_patch_skew_dvp_low();
+		via_write_reg_mask(VIACR, 0x91, 0x00, 0x20);
+		break;
+
+	case INTERFACE_TMDS:
 		/* Turn on Display period in the panel path. */
 		viafb_write_reg_mask(CR91, VIACR, 0, BIT7);
 
 		/* Turn on TMDS power. */
 		viafb_write_reg_mask(CRD2, VIACR, 0, BIT3);
+		break;
 	}
-}
 
+	if (viaparinfo->tmds_setting_info->iga_path == IGA2) {
+		/* Disable LCD Scaling */
+		viafb_write_reg_mask(CR79, VIACR, 0x00, BIT0);
+	}
+}
diff --git a/drivers/video/via/hw.c b/drivers/video/via/hw.c
index c8f2405..0330323 100644
--- a/drivers/video/via/hw.c
+++ b/drivers/video/via/hw.c
@@ -718,10 +718,6 @@ static struct rgbLUT palLUT_table[] = {
 								     0x00}
 };
 
-static void dvi_patch_skew_dvp0(void);
-static void dvi_patch_skew_dvp_low(void);
-static void set_dvi_output_path(int set_iga, int output_interface);
-static void set_lcd_output_path(int set_iga, int output_interface);
 static void load_fix_bit_crtc_reg(void);
 static void __devinit init_gfx_chip_info(int chip_type);
 static void __devinit init_tmds_chip_info(void);
@@ -944,21 +940,6 @@ void viafb_set_secondary_color_register(u8 index, u8 red, u8 green, u8 blue)
 	set_color_register(index, red, green, blue);
 }
 
-void viafb_set_output_path(int device, int set_iga, int output_interface)
-{
-	switch (device) {
-	case DEVICE_CRT:
-		viafb_write_reg_mask(CR36, VIACR, 0x00, BIT4 + BIT5);
-		break;
-	case DEVICE_DVI:
-		set_dvi_output_path(set_iga, output_interface);
-		break;
-	case DEVICE_LCD:
-		set_lcd_output_path(set_iga, output_interface);
-		break;
-	}
-}
-
 static void set_source_common(u8 index, u8 offset, u8 iga)
 {
 	u8 value, mask = 1 << offset;
@@ -1045,134 +1026,6 @@ void via_set_source(u32 devices, u8 iga)
 		set_lvds2_source(iga);
 }
 
-static void dvi_patch_skew_dvp0(void)
-{
-	/* Reset data driving first: */
-	viafb_write_reg_mask(SR1B, VIASR, 0, BIT1);
-	viafb_write_reg_mask(SR2A, VIASR, 0, BIT4);
-
-	switch (viaparinfo->chip_info->gfx_chip_name) {
-	case UNICHROME_P4M890:
-		{
-			if ((viaparinfo->tmds_setting_info->h_active == 1600) &&
-				(viaparinfo->tmds_setting_info->v_active ==
-				1200))
-				viafb_write_reg_mask(CR96, VIACR, 0x03,
-					       BIT0 + BIT1 + BIT2);
-			else
-				viafb_write_reg_mask(CR96, VIACR, 0x07,
-					       BIT0 + BIT1 + BIT2);
-			break;
-		}
-
-	case UNICHROME_P4M900:
-		{
-			viafb_write_reg_mask(CR96, VIACR, 0x07,
-				       BIT0 + BIT1 + BIT2 + BIT3);
-			viafb_write_reg_mask(SR1B, VIASR, 0x02, BIT1);
-			viafb_write_reg_mask(SR2A, VIASR, 0x10, BIT4);
-			break;
-		}
-
-	default:
-		{
-			break;
-		}
-	}
-}
-
-static void dvi_patch_skew_dvp_low(void)
-{
-	switch (viaparinfo->chip_info->gfx_chip_name) {
-	case UNICHROME_K8M890:
-		{
-			viafb_write_reg_mask(CR99, VIACR, 0x03, BIT0 + BIT1);
-			break;
-		}
-
-	case UNICHROME_P4M900:
-		{
-			viafb_write_reg_mask(CR99, VIACR, 0x08,
-				       BIT0 + BIT1 + BIT2 + BIT3);
-			break;
-		}
-
-	case UNICHROME_P4M890:
-		{
-			viafb_write_reg_mask(CR99, VIACR, 0x0F,
-				       BIT0 + BIT1 + BIT2 + BIT3);
-			break;
-		}
-
-	default:
-		{
-			break;
-		}
-	}
-}
-
-static void set_dvi_output_path(int set_iga, int output_interface)
-{
-	switch (output_interface) {
-	case INTERFACE_DVP0:
-		viafb_write_reg_mask(CR6B, VIACR, 0x01, BIT0);
-		viafb_write_reg_mask(CR6C, VIACR, 0x21, BIT0 + BIT5);
-		viafb_write_reg_mask(SR1E, VIASR, 0xC0, BIT7 + BIT6);
-		dvi_patch_skew_dvp0();
-		break;
-
-	case INTERFACE_DVP1:
-		if (viaparinfo->chip_info->gfx_chip_name == UNICHROME_CLE266)
-			viafb_write_reg_mask(CR93, VIACR, 0x21, BIT0 + BIT5);
-
-		viafb_write_reg_mask(SR1E, VIASR, 0x30, BIT4 + BIT5);
-		break;
-	case INTERFACE_DFP_HIGH:
-		if (viaparinfo->chip_info->gfx_chip_name != UNICHROME_CLE266)
-			via_write_reg_mask(VIACR, CR97, 0x03, 0x03);
-
-		viafb_write_reg_mask(SR2A, VIASR, 0x0C, BIT2 + BIT3);
-		break;
-
-	case INTERFACE_DFP_LOW:
-		if (viaparinfo->chip_info->gfx_chip_name == UNICHROME_CLE266)
-			break;
-		viafb_write_reg_mask(SR2A, VIASR, 0x03, BIT0 + BIT1);
-		dvi_patch_skew_dvp_low();
-		break;
-	}
-
-	if (set_iga == IGA2) {
-		/* Disable LCD Scaling */
-		viafb_write_reg_mask(CR79, VIACR, 0x00, BIT0);
-	}
-}
-
-static void set_lcd_output_path(int set_iga, int output_interface)
-{
-	DEBUG_MSG(KERN_INFO
-		  "set_lcd_output_path, iga:%d,out_interface:%d\n",
-		  set_iga, output_interface);
-
-	viafb_write_reg_mask(CR6B, VIACR, 0x00, BIT3);
-	viafb_write_reg_mask(CR6A, VIACR, 0x08, BIT3);
-	switch (output_interface) {
-	case INTERFACE_DFP:
-		if ((UNICHROME_K8M890 == viaparinfo->chip_info->gfx_chip_name)
-		    || (UNICHROME_P4M890 ==
-		    viaparinfo->chip_info->gfx_chip_name))
-			viafb_write_reg_mask(CR97, VIACR, 0x84,
-				       BIT7 + BIT2 + BIT1 + BIT0);
-	case INTERFACE_DVP0:
-	case INTERFACE_DVP1:
-	case INTERFACE_DFP_HIGH:
-	case INTERFACE_DFP_LOW:
-		if (set_iga == IGA2)
-			viafb_write_reg(CR91, VIACR, 0x00);
-		break;
-	}
-}
-
 static void load_fix_bit_crtc_reg(void)
 {
 	/* always set to 1 */
@@ -2447,9 +2300,6 @@ int viafb_setmode(struct VideoModeTable *vmode_tbl, int video_bpp,
 				viafb_read_reg(VIACR, CR02) - 1);
 			viafb_lock_crt();
 		}
-
-		viafb_set_output_path(DEVICE_CRT,
-			viaparinfo->crt_setting_info->iga_path, 0);
 	}
 
 	if (viafb_DVI_ON) {
@@ -2469,10 +2319,6 @@ int viafb_setmode(struct VideoModeTable *vmode_tbl, int video_bpp,
 				     video_bpp, viaparinfo->
 				     tmds_setting_info->iga_path);
 		}
-
-		viafb_set_output_path(DEVICE_DVI,
-			viaparinfo->tmds_setting_info->iga_path,
-			viaparinfo->chip_info->tmds_chip_info.output_interface);
 	}
 
 	if (viafb_LCD_ON) {
@@ -2493,11 +2339,6 @@ int viafb_setmode(struct VideoModeTable *vmode_tbl, int video_bpp,
 				lvds_setting_info,
 				     &viaparinfo->chip_info->lvds_chip_info);
 		}
-
-		viafb_set_output_path(DEVICE_LCD,
-			viaparinfo->lvds_setting_info->iga_path,
-			viaparinfo->chip_info->
-			lvds_chip_info.output_interface);
 	}
 	if (viafb_LCD2_ON) {
 		if (viafb_SAMM_ON &&
@@ -2517,11 +2358,6 @@ int viafb_setmode(struct VideoModeTable *vmode_tbl, int video_bpp,
 				lvds_setting_info2,
 				     &viaparinfo->chip_info->lvds_chip_info2);
 		}
-
-		viafb_set_output_path(DEVICE_LCD,
-			viaparinfo->lvds_setting_info2->iga_path,
-			viaparinfo->chip_info->
-			lvds_chip_info2.output_interface);
 	}
 
 	if ((viaparinfo->chip_info->gfx_chip_name == UNICHROME_CX700)
diff --git a/drivers/video/via/hw.h b/drivers/video/via/hw.h
index c52a1d5..45dee39 100644
--- a/drivers/video/via/hw.h
+++ b/drivers/video/via/hw.h
@@ -890,9 +890,6 @@ extern int viafb_LCD_ON;
 extern int viafb_DVI_ON;
 extern int viafb_hotplug;
 
-void viafb_set_output_path(int device, int set_iga,
-	int output_interface);
-
 void viafb_fill_crtc_timing(struct crt_mode_table *crt_table,
 	struct VideoModeTable *video_mode, int bpp_byte, int set_iga);
 
diff --git a/drivers/video/via/lcd.c b/drivers/video/via/lcd.c
index c7de164..e99f933 100644
--- a/drivers/video/via/lcd.c
+++ b/drivers/video/via/lcd.c
@@ -833,8 +833,36 @@ void viafb_lcd_disable(void)
 
 }
 
+static void set_lcd_output_path(int set_iga, int output_interface)
+{
+	switch (output_interface) {
+	case INTERFACE_DFP:
+		if ((UNICHROME_K8M890 == viaparinfo->chip_info->gfx_chip_name)
+		    || (UNICHROME_P4M890 ==
+		    viaparinfo->chip_info->gfx_chip_name))
+			viafb_write_reg_mask(CR97, VIACR, 0x84,
+				       BIT7 + BIT2 + BIT1 + BIT0);
+	case INTERFACE_DVP0:
+	case INTERFACE_DVP1:
+	case INTERFACE_DFP_HIGH:
+	case INTERFACE_DFP_LOW:
+		if (set_iga == IGA2)
+			viafb_write_reg(CR91, VIACR, 0x00);
+		break;
+	}
+}
+
 void viafb_lcd_enable(void)
 {
+	viafb_write_reg_mask(CR6B, VIACR, 0x00, BIT3);
+	viafb_write_reg_mask(CR6A, VIACR, 0x08, BIT3);
+	set_lcd_output_path(viaparinfo->lvds_setting_info->iga_path,
+		viaparinfo->chip_info->lvds_chip_info.output_interface);
+	if (viafb_LCD2_ON)
+		set_lcd_output_path(viaparinfo->lvds_setting_info2->iga_path,
+			viaparinfo->chip_info->
+			lvds_chip_info2.output_interface);
+
 	if (viaparinfo->chip_info->gfx_chip_name == UNICHROME_CLE266) {
 		/* DI1 pad on */
 		viafb_write_reg_mask(SR1E, VIASR, 0x30, 0x30);
-- 
1.6.3.2

