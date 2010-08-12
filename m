Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758396Ab0HKXy5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 19:54:57 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:40452 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1758247Ab0HKXyz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 19:54:55 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX18cmEwfUIIchGPUHSRbPNPOHG+u4QQBNoOTTQvyHO
	HF5916/0siGy/X
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Joseph Chan <JosephChan@via.com.tw>
Subject: [[PATCH 05/11]] viafb: enable second display channel at central place
Date: Thu, 12 Aug 2010 00:05:09 +0000
Message-Id: <1281571509-8829-1-git-send-email-FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <1281570580-8253-1-git-send-email-FlorianSchandinat@gmx.de>
References: <1281570580-8253-1-git-send-email-FlorianSchandinat@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

viafb: enable second display channel at central place

Move the enabling of the second display channel to the generic
output routing function and do it exactly if something is using it.
This unifies a zoo of variants how to do it and does no longer
disable it if LCD is not on the second display which is much saner
as there can be other users who need it. Probably this did not cause
any problems so far as we only recently started dual fb support and
otherwise there won't be other users and LCD is preferred assigned to
second display channel.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Joseph Chan <JosephChan@via.com.tw>
---
 drivers/video/via/hw.c |   35 +++++------------------------------
 1 files changed, 5 insertions(+), 30 deletions(-)

diff --git a/drivers/video/via/hw.c b/drivers/video/via/hw.c
index a3db804..1ce2c21 100644
--- a/drivers/video/via/hw.c
+++ b/drivers/video/via/hw.c
@@ -733,7 +733,6 @@ static void set_display_channel(void);
 static void device_off(void);
 static void device_on(void);
 static void enable_second_display_channel(void);
-static void disable_second_display_channel(void);
 
 void viafb_lock_crt(void)
 {
@@ -856,6 +855,9 @@ void viafb_set_output_path(int device, int set_iga, int output_interface)
 		set_lcd_output_path(set_iga, output_interface);
 		break;
 	}
+
+	if (set_iga == IGA2)
+		enable_second_display_channel();
 }
 
 static void set_crt_output_path(int set_iga)
@@ -867,7 +869,6 @@ static void set_crt_output_path(int set_iga)
 		viafb_write_reg_mask(SR16, VIASR, 0x00, BIT6);
 		break;
 	case IGA2:
-		viafb_write_reg_mask(CR6A, VIACR, 0xC0, BIT6 + BIT7);
 		viafb_write_reg_mask(SR16, VIASR, 0x40, BIT6);
 		break;
 	}
@@ -1017,7 +1018,6 @@ static void set_dvi_output_path(int set_iga, int output_interface)
 	}
 
 	if (set_iga == IGA2) {
-		enable_second_display_channel();
 		/* Disable LCD Scaling */
 		viafb_write_reg_mask(CR79, VIACR, 0x00, BIT0);
 	}
@@ -1028,21 +1028,9 @@ static void set_lcd_output_path(int set_iga, int output_interface)
 	DEBUG_MSG(KERN_INFO
 		  "set_lcd_output_path, iga:%d,out_interface:%d\n",
 		  set_iga, output_interface);
-	switch (set_iga) {
-	case IGA1:
-		viafb_write_reg_mask(CR6B, VIACR, 0x00, BIT3);
-		viafb_write_reg_mask(CR6A, VIACR, 0x08, BIT3);
 
-		disable_second_display_channel();
-		break;
-
-	case IGA2:
-		viafb_write_reg_mask(CR6B, VIACR, 0x00, BIT3);
-		viafb_write_reg_mask(CR6A, VIACR, 0x08, BIT3);
-
-		enable_second_display_channel();
-		break;
-	}
+	viafb_write_reg_mask(CR6B, VIACR, 0x00, BIT3);
+	viafb_write_reg_mask(CR6A, VIACR, 0x08, BIT3);
 
 	switch (output_interface) {
 	case INTERFACE_DVP0:
@@ -2480,10 +2468,6 @@ int viafb_setmode(struct VideoModeTable *vmode_tbl, int video_bpp,
 			viafb_DeviceStatus = CRT_Device;
 	}
 	device_on();
-
-	if (viafb_SAMM_ON == 1)
-		viafb_write_reg_mask(CR6A, VIACR, 0xC0, BIT6 + BIT7);
-
 	device_screen_on();
 	return 1;
 }
@@ -2557,15 +2541,6 @@ static void enable_second_display_channel(void)
 	viafb_write_reg_mask(CR6A, VIACR, BIT6, BIT6);
 }
 
-static void disable_second_display_channel(void)
-{
-	/* to disable second display channel. */
-	viafb_write_reg_mask(CR6A, VIACR, 0x00, BIT6);
-	viafb_write_reg_mask(CR6A, VIACR, 0x00, BIT7);
-	viafb_write_reg_mask(CR6A, VIACR, BIT6, BIT6);
-}
-
-
 void viafb_set_dpa_gfx(int output_interface, struct GFX_DPA_SETTING\
 					*p_gfx_dpa_setting)
 {
-- 
1.6.3.2

