Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759454Ab0HLAAg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 20:00:36 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:59053 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1759208Ab0HLAAc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 20:00:32 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX18fWoccSqkfKqqI6Pn26V4bFj9nMfa4QGZUEqaDbc
	q1338vPwQti8YQ
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Joseph Chan <JosephChan@via.com.tw>
Subject: [[PATCH 10/11]] viafb: use new device routing
Date: Thu, 12 Aug 2010 00:11:08 +0000
Message-Id: <1281571868-9050-1-git-send-email-FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <1281570580-8253-1-git-send-email-FlorianSchandinat@gmx.de>
References: <1281570580-8253-1-git-send-email-FlorianSchandinat@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

viafb: use new device routing

This patch uses the iga{1,2}_devices variables to select which IGA
should be the source. Doing this is convinient, more powerfull
than the older scheme and easy extendable to support further output
devices. It is not yet completed as the device on/off selection needs
to be converted to the same scheme to take full advantage.
No visible changes yet as we want to complete the transition before
anouncing any unstabke interface.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Joseph Chan <JosephChan@via.com.tw>
---
 drivers/video/via/hw.c |  101 ++++++++++++++++++------------------------------
 1 files changed, 38 insertions(+), 63 deletions(-)

diff --git a/drivers/video/via/hw.c b/drivers/video/via/hw.c
index 30cc2f0..c8f2405 100644
--- a/drivers/video/via/hw.c
+++ b/drivers/video/via/hw.c
@@ -718,7 +718,6 @@ static struct rgbLUT palLUT_table[] = {
 								     0x00}
 };
 
-static void set_crt_output_path(int set_iga);
 static void dvi_patch_skew_dvp0(void);
 static void dvi_patch_skew_dvp_low(void);
 static void set_dvi_output_path(int set_iga, int output_interface);
@@ -733,6 +732,7 @@ static void set_display_channel(void);
 static void device_off(void);
 static void device_on(void);
 static void enable_second_display_channel(void);
+static void disable_second_display_channel(void);
 
 void viafb_lock_crt(void)
 {
@@ -948,7 +948,7 @@ void viafb_set_output_path(int device, int set_iga, int output_interface)
 {
 	switch (device) {
 	case DEVICE_CRT:
-		set_crt_output_path(set_iga);
+		viafb_write_reg_mask(CR36, VIACR, 0x00, BIT4 + BIT5);
 		break;
 	case DEVICE_DVI:
 		set_dvi_output_path(set_iga, output_interface);
@@ -957,9 +957,6 @@ void viafb_set_output_path(int device, int set_iga, int output_interface)
 		set_lcd_output_path(set_iga, output_interface);
 		break;
 	}
-
-	if (set_iga == IGA2)
-		enable_second_display_channel();
 }
 
 static void set_source_common(u8 index, u8 offset, u8 iga)
@@ -1030,10 +1027,22 @@ static inline void set_lvds2_source(u8 iga)
 	set_source_common(0x97, 4, iga);
 }
 
-static void set_crt_output_path(int set_iga)
+void via_set_source(u32 devices, u8 iga)
 {
-	viafb_write_reg_mask(CR36, VIACR, 0x00, BIT4 + BIT5);
-	set_crt_source(set_iga);
+	if (devices & VIA_6C)
+		set_6C_source(iga);
+	if (devices & VIA_93)
+		set_93_source(iga);
+	if (devices & VIA_96)
+		set_96_source(iga);
+	if (devices & VIA_CRT)
+		set_crt_source(iga);
+	if (devices & VIA_DVP1)
+		set_dvp1_source(iga);
+	if (devices & VIA_LVDS1)
+		set_lvds1_source(iga);
+	if (devices & VIA_LVDS2)
+		set_lvds2_source(iga);
 }
 
 static void dvi_patch_skew_dvp0(void)
@@ -1106,8 +1115,6 @@ static void set_dvi_output_path(int set_iga, int output_interface)
 {
 	switch (output_interface) {
 	case INTERFACE_DVP0:
-		set_96_source(set_iga);
-		set_6C_source(set_iga);
 		viafb_write_reg_mask(CR6B, VIACR, 0x01, BIT0);
 		viafb_write_reg_mask(CR6C, VIACR, 0x21, BIT0 + BIT5);
 		viafb_write_reg_mask(SR1E, VIASR, 0xC0, BIT7 + BIT6);
@@ -1115,21 +1122,14 @@ static void set_dvi_output_path(int set_iga, int output_interface)
 		break;
 
 	case INTERFACE_DVP1:
-		if (viaparinfo->chip_info->gfx_chip_name == UNICHROME_CLE266) {
-			set_93_source(set_iga);
+		if (viaparinfo->chip_info->gfx_chip_name == UNICHROME_CLE266)
 			viafb_write_reg_mask(CR93, VIACR, 0x21, BIT0 + BIT5);
-		} else {
-			set_dvp1_source(set_iga);
-		}
 
 		viafb_write_reg_mask(SR1E, VIASR, 0x30, BIT4 + BIT5);
 		break;
 	case INTERFACE_DFP_HIGH:
-		if (viaparinfo->chip_info->gfx_chip_name != UNICHROME_CLE266) {
+		if (viaparinfo->chip_info->gfx_chip_name != UNICHROME_CLE266)
 			via_write_reg_mask(VIACR, CR97, 0x03, 0x03);
-			set_lvds2_source(set_iga);
-			set_96_source(set_iga);
-		}
 
 		viafb_write_reg_mask(SR2A, VIASR, 0x0C, BIT2 + BIT3);
 		break;
@@ -1137,15 +1137,9 @@ static void set_dvi_output_path(int set_iga, int output_interface)
 	case INTERFACE_DFP_LOW:
 		if (viaparinfo->chip_info->gfx_chip_name == UNICHROME_CLE266)
 			break;
-		set_dvp1_source(set_iga);
-		set_lvds1_source(set_iga);
 		viafb_write_reg_mask(SR2A, VIASR, 0x03, BIT0 + BIT1);
 		dvi_patch_skew_dvp_low();
 		break;
-
-	case INTERFACE_TMDS:
-		set_lvds1_source(set_iga);
-		break;
 	}
 
 	if (set_iga == IGA2) {
@@ -1163,53 +1157,19 @@ static void set_lcd_output_path(int set_iga, int output_interface)
 	viafb_write_reg_mask(CR6B, VIACR, 0x00, BIT3);
 	viafb_write_reg_mask(CR6A, VIACR, 0x08, BIT3);
 	switch (output_interface) {
-	case INTERFACE_DVP0:
-		set_96_source(set_iga);
-		if (set_iga == IGA2)
-			viafb_write_reg(CR91, VIACR, 0x00);
-		break;
-
-	case INTERFACE_DVP1:
-		set_dvp1_source(set_iga);
-		if (set_iga == IGA2)
-			viafb_write_reg(CR91, VIACR, 0x00);
-		break;
-
-	case INTERFACE_DFP_HIGH:
-		set_lvds2_source(set_iga);
-		set_96_source(set_iga);
-		if (set_iga == IGA2)
-			viafb_write_reg(CR91, VIACR, 0x00);
-		break;
-
-	case INTERFACE_DFP_LOW:
-		set_lvds1_source(set_iga);
-		set_dvp1_source(set_iga);
-		if (set_iga == IGA2)
-			viafb_write_reg(CR91, VIACR, 0x00);
-		break;
-
 	case INTERFACE_DFP:
 		if ((UNICHROME_K8M890 == viaparinfo->chip_info->gfx_chip_name)
 		    || (UNICHROME_P4M890 ==
 		    viaparinfo->chip_info->gfx_chip_name))
 			viafb_write_reg_mask(CR97, VIACR, 0x84,
 				       BIT7 + BIT2 + BIT1 + BIT0);
-
-		set_lvds1_source(set_iga);
-		set_lvds2_source(set_iga);
+	case INTERFACE_DVP0:
+	case INTERFACE_DVP1:
+	case INTERFACE_DFP_HIGH:
+	case INTERFACE_DFP_LOW:
 		if (set_iga == IGA2)
 			viafb_write_reg(CR91, VIACR, 0x00);
 		break;
-
-	case INTERFACE_LVDS0:
-	case INTERFACE_LVDS0LVDS1:
-		set_lvds1_source(set_iga);
-		break;
-
-	case INTERFACE_LVDS1:
-		set_lvds2_source(set_iga);
-		break;
 	}
 }
 
@@ -2454,6 +2414,13 @@ int viafb_setmode(struct VideoModeTable *vmode_tbl, int video_bpp,
 	via_set_primary_color_depth(viaparinfo->depth);
 	via_set_secondary_color_depth(viafb_dual_fb ? viaparinfo1->depth
 		: viaparinfo->depth);
+	via_set_source(viaparinfo->shared->iga1_devices, IGA1);
+	via_set_source(viaparinfo->shared->iga2_devices, IGA2);
+	if (viaparinfo->shared->iga2_devices)
+		enable_second_display_channel();
+	else
+		disable_second_display_channel();
+
 	/* Update Refresh Rate Setting */
 
 	/* Clear On Screen */
@@ -2647,6 +2614,14 @@ static void enable_second_display_channel(void)
 	viafb_write_reg_mask(CR6A, VIACR, BIT6, BIT6);
 }
 
+static void disable_second_display_channel(void)
+{
+	/* to disable second display channel. */
+	viafb_write_reg_mask(CR6A, VIACR, 0x00, BIT6);
+	viafb_write_reg_mask(CR6A, VIACR, 0x00, BIT7);
+	viafb_write_reg_mask(CR6A, VIACR, BIT6, BIT6);
+}
+
 void viafb_set_dpa_gfx(int output_interface, struct GFX_DPA_SETTING\
 					*p_gfx_dpa_setting)
 {
-- 
1.6.3.2

