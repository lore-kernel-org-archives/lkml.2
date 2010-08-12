Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758406Ab0HKX4G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 19:56:06 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:59262 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1758114Ab0HKX4E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 19:56:04 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX1+CXRkqZKKCpWNi6io2AfG+C43PmvzRFalTDjoVP9
	0O5TCe2NJIOUWh
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Joseph Chan <JosephChan@via.com.tw>
Subject: [[PATCH 06/11]] viafb: rework output device routing
Date: Thu, 12 Aug 2010 00:06:30 +0000
Message-Id: <1281571590-8866-1-git-send-email-FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <1281570580-8253-1-git-send-email-FlorianSchandinat@gmx.de>
References: <1281570580-8253-1-git-send-email-FlorianSchandinat@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

viafb: rework output device routing

This patch rips the device routing out of the 3 main functions to
separate functions to make them available for transition to a better
controlling scheme.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Joseph Chan <JosephChan@via.com.tw>
---
 drivers/video/via/hw.c |  183 +++++++++++++++++++++++++-----------------------
 1 files changed, 94 insertions(+), 89 deletions(-)

diff --git a/drivers/video/via/hw.c b/drivers/video/via/hw.c
index 1ce2c21..2f7f640 100644
--- a/drivers/video/via/hw.c
+++ b/drivers/video/via/hw.c
@@ -860,18 +860,78 @@ void viafb_set_output_path(int device, int set_iga, int output_interface)
 		enable_second_display_channel();
 }
 
-static void set_crt_output_path(int set_iga)
+static void set_source_common(u8 index, u8 offset, u8 iga)
 {
-	viafb_write_reg_mask(CR36, VIACR, 0x00, BIT4 + BIT5);
+	u8 value, mask = 1 << offset;
 
-	switch (set_iga) {
+	switch (iga) {
+	case IGA1:
+		value = 0x00;
+		break;
+	case IGA2:
+		value = mask;
+		break;
+	default:
+		printk(KERN_WARNING "viafb: Unsupported source: %d\n", iga);
+		return;
+	}
+
+	via_write_reg_mask(VIACR, index, value, mask);
+}
+
+static void set_crt_source(u8 iga)
+{
+	u8 value;
+
+	switch (iga) {
 	case IGA1:
-		viafb_write_reg_mask(SR16, VIASR, 0x00, BIT6);
+		value = 0x00;
 		break;
 	case IGA2:
-		viafb_write_reg_mask(SR16, VIASR, 0x40, BIT6);
+		value = 0x40;
 		break;
+	default:
+		printk(KERN_WARNING "viafb: Unsupported source: %d\n", iga);
+		return;
 	}
+
+	via_write_reg_mask(VIASR, 0x16, value, 0x40);
+}
+
+static inline void set_6C_source(u8 iga)
+{
+	set_source_common(0x6C, 7, iga);
+}
+
+static inline void set_93_source(u8 iga)
+{
+	set_source_common(0x93, 7, iga);
+}
+
+static inline void set_96_source(u8 iga)
+{
+	set_source_common(0x96, 4, iga);
+}
+
+static inline void set_dvp1_source(u8 iga)
+{
+	set_source_common(0x9B, 4, iga);
+}
+
+static inline void set_lvds1_source(u8 iga)
+{
+	set_source_common(0x99, 4, iga);
+}
+
+static inline void set_lvds2_source(u8 iga)
+{
+	set_source_common(0x97, 4, iga);
+}
+
+static void set_crt_output_path(int set_iga)
+{
+	viafb_write_reg_mask(CR36, VIACR, 0x00, BIT4 + BIT5);
+	set_crt_source(set_iga);
 }
 
 static void dvi_patch_skew_dvp0(void)
@@ -944,76 +1004,45 @@ static void set_dvi_output_path(int set_iga, int output_interface)
 {
 	switch (output_interface) {
 	case INTERFACE_DVP0:
+		set_96_source(set_iga);
+		set_6C_source(set_iga);
 		viafb_write_reg_mask(CR6B, VIACR, 0x01, BIT0);
-
-		if (set_iga == IGA1) {
-			viafb_write_reg_mask(CR96, VIACR, 0x00, BIT4);
-			viafb_write_reg_mask(CR6C, VIACR, 0x21, BIT0 +
-				BIT5 + BIT7);
-		} else {
-			viafb_write_reg_mask(CR96, VIACR, 0x10, BIT4);
-			viafb_write_reg_mask(CR6C, VIACR, 0xA1, BIT0 +
-				BIT5 + BIT7);
-		}
-
+		viafb_write_reg_mask(CR6C, VIACR, 0x21, BIT0 + BIT5);
 		viafb_write_reg_mask(SR1E, VIASR, 0xC0, BIT7 + BIT6);
-
 		dvi_patch_skew_dvp0();
 		break;
 
 	case INTERFACE_DVP1:
 		if (viaparinfo->chip_info->gfx_chip_name == UNICHROME_CLE266) {
-			if (set_iga == IGA1)
-				viafb_write_reg_mask(CR93, VIACR, 0x21,
-					       BIT0 + BIT5 + BIT7);
-			else
-				viafb_write_reg_mask(CR93, VIACR, 0xA1,
-					       BIT0 + BIT5 + BIT7);
+			set_93_source(set_iga);
+			viafb_write_reg_mask(CR93, VIACR, 0x21, BIT0 + BIT5);
 		} else {
-			if (set_iga == IGA1)
-				viafb_write_reg_mask(CR9B, VIACR, 0x00, BIT4);
-			else
-				viafb_write_reg_mask(CR9B, VIACR, 0x10, BIT4);
+			set_dvp1_source(set_iga);
 		}
 
 		viafb_write_reg_mask(SR1E, VIASR, 0x30, BIT4 + BIT5);
 		break;
 	case INTERFACE_DFP_HIGH:
 		if (viaparinfo->chip_info->gfx_chip_name != UNICHROME_CLE266) {
-			if (set_iga == IGA1) {
-				viafb_write_reg_mask(CR96, VIACR, 0x00, BIT4);
-				viafb_write_reg_mask(CR97, VIACR, 0x03,
-					       BIT0 + BIT1 + BIT4);
-			} else {
-				viafb_write_reg_mask(CR96, VIACR, 0x10, BIT4);
-				viafb_write_reg_mask(CR97, VIACR, 0x13,
-					       BIT0 + BIT1 + BIT4);
-			}
+			via_write_reg_mask(VIACR, CR97, 0x03, 0x03);
+			set_lvds2_source(set_iga);
+			set_96_source(set_iga);
 		}
+
 		viafb_write_reg_mask(SR2A, VIASR, 0x0C, BIT2 + BIT3);
 		break;
 
 	case INTERFACE_DFP_LOW:
 		if (viaparinfo->chip_info->gfx_chip_name == UNICHROME_CLE266)
 			break;
-
-		if (set_iga == IGA1) {
-			viafb_write_reg_mask(CR99, VIACR, 0x00, BIT4);
-			viafb_write_reg_mask(CR9B, VIACR, 0x00, BIT4);
-		} else {
-			viafb_write_reg_mask(CR99, VIACR, 0x10, BIT4);
-			viafb_write_reg_mask(CR9B, VIACR, 0x10, BIT4);
-		}
-
+		set_dvp1_source(set_iga);
+		set_lvds1_source(set_iga);
 		viafb_write_reg_mask(SR2A, VIASR, 0x03, BIT0 + BIT1);
 		dvi_patch_skew_dvp_low();
 		break;
 
 	case INTERFACE_TMDS:
-		if (set_iga == IGA1)
-			viafb_write_reg_mask(CR99, VIACR, 0x00, BIT4);
-		else
-			viafb_write_reg_mask(CR99, VIACR, 0x10, BIT4);
+		set_lvds1_source(set_iga);
 		break;
 	}
 
@@ -1031,45 +1060,31 @@ static void set_lcd_output_path(int set_iga, int output_interface)
 
 	viafb_write_reg_mask(CR6B, VIACR, 0x00, BIT3);
 	viafb_write_reg_mask(CR6A, VIACR, 0x08, BIT3);
-
 	switch (output_interface) {
 	case INTERFACE_DVP0:
-		if (set_iga == IGA1) {
-			viafb_write_reg_mask(CR96, VIACR, 0x00, BIT4);
-		} else {
+		set_96_source(set_iga);
+		if (set_iga == IGA2)
 			viafb_write_reg(CR91, VIACR, 0x00);
-			viafb_write_reg_mask(CR96, VIACR, 0x10, BIT4);
-		}
 		break;
 
 	case INTERFACE_DVP1:
-		if (set_iga == IGA1)
-			viafb_write_reg_mask(CR9B, VIACR, 0x00, BIT4);
-		else {
+		set_dvp1_source(set_iga);
+		if (set_iga == IGA2)
 			viafb_write_reg(CR91, VIACR, 0x00);
-			viafb_write_reg_mask(CR9B, VIACR, 0x10, BIT4);
-		}
 		break;
 
 	case INTERFACE_DFP_HIGH:
-		if (set_iga == IGA1)
-			viafb_write_reg_mask(CR97, VIACR, 0x00, BIT4);
-		else {
+		set_lvds2_source(set_iga);
+		set_96_source(set_iga);
+		if (set_iga == IGA2)
 			viafb_write_reg(CR91, VIACR, 0x00);
-			viafb_write_reg_mask(CR97, VIACR, 0x10, BIT4);
-			viafb_write_reg_mask(CR96, VIACR, 0x10, BIT4);
-		}
 		break;
 
 	case INTERFACE_DFP_LOW:
-		if (set_iga == IGA1)
-			viafb_write_reg_mask(CR99, VIACR, 0x00, BIT4);
-		else {
+		set_lvds1_source(set_iga);
+		set_dvp1_source(set_iga);
+		if (set_iga == IGA2)
 			viafb_write_reg(CR91, VIACR, 0x00);
-			viafb_write_reg_mask(CR99, VIACR, 0x10, BIT4);
-			viafb_write_reg_mask(CR9B, VIACR, 0x10, BIT4);
-		}
-
 		break;
 
 	case INTERFACE_DFP:
@@ -1078,30 +1093,20 @@ static void set_lcd_output_path(int set_iga, int output_interface)
 		    viaparinfo->chip_info->gfx_chip_name))
 			viafb_write_reg_mask(CR97, VIACR, 0x84,
 				       BIT7 + BIT2 + BIT1 + BIT0);
-		if (set_iga == IGA1) {
-			viafb_write_reg_mask(CR97, VIACR, 0x00, BIT4);
-			viafb_write_reg_mask(CR99, VIACR, 0x00, BIT4);
-		} else {
+
+		set_lvds1_source(set_iga);
+		set_lvds2_source(set_iga);
+		if (set_iga == IGA2)
 			viafb_write_reg(CR91, VIACR, 0x00);
-			viafb_write_reg_mask(CR97, VIACR, 0x10, BIT4);
-			viafb_write_reg_mask(CR99, VIACR, 0x10, BIT4);
-		}
 		break;
 
 	case INTERFACE_LVDS0:
 	case INTERFACE_LVDS0LVDS1:
-		if (set_iga == IGA1)
-			viafb_write_reg_mask(CR99, VIACR, 0x00, BIT4);
-		else
-			viafb_write_reg_mask(CR99, VIACR, 0x10, BIT4);
-
+		set_lvds1_source(set_iga);
 		break;
 
 	case INTERFACE_LVDS1:
-		if (set_iga == IGA1)
-			viafb_write_reg_mask(CR97, VIACR, 0x00, BIT4);
-		else
-			viafb_write_reg_mask(CR97, VIACR, 0x10, BIT4);
+		set_lvds2_source(set_iga);
 		break;
 	}
 }
-- 
1.6.3.2

