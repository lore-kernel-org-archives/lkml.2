Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753938Ab1HGPdQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Aug 2011 11:33:16 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:49569 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753690Ab1HGPdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Aug 2011 11:33:14 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX18XEiRbd98XDiHJ8Q5sN9hIwgPC1XXNtDuXkQCiHM
	Wy7PvadyMlwPk+
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [PATCH 4/6] viafb: seperate hardware initialization
Date: Sun,  7 Aug 2011 15:51:53 +0000
Message-Id: <4fbf4bfe6fb5460bfd4a18ca7c7f21ffec941b07.1312730860.git.FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <cover.1312730859.git.FlorianSchandinat@gmx.de>
References: <cover.1312730859.git.FlorianSchandinat@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch splits the hardware initialization out of the modesetting
function which will make it easier to make it conditional and not
require starting from scratch for every mode change, which is
especially annoying in dual framebuffer mode.
This required some minor reordering but it should not influence its
functionality.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
---
 drivers/video/via/hw.c |   48 ++++++++++++++++++++++++++++--------------------
 1 files changed, 28 insertions(+), 20 deletions(-)

diff --git a/drivers/video/via/hw.c b/drivers/video/via/hw.c
index 6845c82..76fad92 100644
--- a/drivers/video/via/hw.c
+++ b/drivers/video/via/hw.c
@@ -1769,24 +1769,9 @@ static u8 get_sync(struct fb_info *info)
 	return polarity;
 }
 
-int viafb_setmode(struct VideoModeTable *vmode_tbl, int video_bpp,
-	struct VideoModeTable *vmode_tbl1, int video_bpp1)
+static void hw_init(void)
 {
-	int i, j;
-	int port;
-	u32 devices = viaparinfo->shared->iga1_devices
-		| viaparinfo->shared->iga2_devices;
-	u8 value, index, mask;
-	struct crt_mode_table *crt_timing;
-	struct crt_mode_table *crt_timing1 = NULL;
-	struct fb_var_screeninfo var2;
-
-	device_screen_off();
-	crt_timing = vmode_tbl->crtc;
-
-	if (viafb_SAMM_ON == 1) {
-		crt_timing1 = vmode_tbl1->crtc;
-	}
+	int i;
 
 	inb(VIAStatus);
 	outb(0x00, VIAAR);
@@ -1825,9 +1810,8 @@ int viafb_setmode(struct VideoModeTable *vmode_tbl, int video_bpp,
 		break;
 	}
 
+	/* probably this should go to the scaling code one day */
 	viafb_write_regx(scaling_parameters, ARRAY_SIZE(scaling_parameters));
-	device_off();
-	via_set_state(devices, VIA_STATE_OFF);
 
 	/* Fill VPIT Parameters */
 	/* Write Misc Register */
@@ -1853,6 +1837,31 @@ int viafb_setmode(struct VideoModeTable *vmode_tbl, int video_bpp,
 	inb(VIAStatus);
 	outb(0x20, VIAAR);
 
+	load_fix_bit_crtc_reg();
+}
+
+int viafb_setmode(struct VideoModeTable *vmode_tbl, int video_bpp,
+	struct VideoModeTable *vmode_tbl1, int video_bpp1)
+{
+	int j;
+	int port;
+	u32 devices = viaparinfo->shared->iga1_devices
+		| viaparinfo->shared->iga2_devices;
+	u8 value, index, mask;
+	struct crt_mode_table *crt_timing;
+	struct crt_mode_table *crt_timing1 = NULL;
+	struct fb_var_screeninfo var2;
+
+	device_screen_off();
+	crt_timing = vmode_tbl->crtc;
+	if (viafb_SAMM_ON == 1)
+		crt_timing1 = vmode_tbl1->crtc;
+
+	device_off();
+	via_set_state(devices, VIA_STATE_OFF);
+
+	hw_init();
+
 	/* Update Patch Register */
 
 	if ((viaparinfo->chip_info->gfx_chip_name == UNICHROME_CLE266
@@ -1868,7 +1877,6 @@ int viafb_setmode(struct VideoModeTable *vmode_tbl, int video_bpp,
 		}
 	}
 
-	load_fix_bit_crtc_reg();
 	via_set_primary_pitch(viafbinfo->fix.line_length);
 	via_set_secondary_pitch(viafb_dual_fb ? viafbinfo1->fix.line_length
 		: viafbinfo->fix.line_length);
-- 
1.6.3.2

