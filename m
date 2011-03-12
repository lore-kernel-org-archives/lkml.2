Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756039Ab1CLVbc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Mar 2011 16:31:32 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:52875 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753659Ab1CLVbK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Mar 2011 16:31:10 -0500
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX19GSFc4q2lGyK69niTEsVYrLD2W3N9z9912zrpEeu
	Jfn9gJm8c/6yJL
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [PATCH 1/4] viafb: remove duplicated clock information
Date: Sat, 12 Mar 2011 21:46:23 +0000
Message-Id: <1299966386-3439-2-git-send-email-FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <1299966386-3439-1-git-send-email-FlorianSchandinat@gmx.de>
References: <1299966386-3439-1-git-send-email-FlorianSchandinat@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the direct lookup table for resolution+refresh and
pixclock by calculating this information from the mode table. Removes a
lot of dupllication and error potential by just doing a little more
calculations on each mode change.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
---
 drivers/video/via/hw.c      |   50 ++++++++++++++++++-------------
 drivers/video/via/share.h   |   69 -------------------------------------------
 drivers/video/via/viamode.c |   67 -----------------------------------------
 drivers/video/via/viamode.h |    9 -----
 4 files changed, 29 insertions(+), 166 deletions(-)

diff --git a/drivers/video/via/hw.c b/drivers/video/via/hw.c
index 9ecf486..8c1393e 100644
--- a/drivers/video/via/hw.c
+++ b/drivers/video/via/hw.c
@@ -2608,35 +2608,43 @@ int viafb_setmode(struct VideoModeTable *vmode_tbl, int video_bpp,
 int viafb_get_pixclock(int hres, int vres, int vmode_refresh)
 {
 	int i;
+	struct crt_mode_table *best;
+	struct VideoModeTable *vmode = viafb_get_mode(hres, vres);
 
-	for (i = 0; i < NUM_TOTAL_RES_MAP_REFRESH; i++) {
-		if ((hres == res_map_refresh_tbl[i].hres)
-		    && (vres == res_map_refresh_tbl[i].vres)
-		    && (vmode_refresh == res_map_refresh_tbl[i].vmode_refresh))
-			return res_map_refresh_tbl[i].pixclock;
+	if (!vmode)
+		return RES_640X480_60HZ_PIXCLOCK;
+
+	best = &vmode->crtc[0];
+	for (i = 1; i < vmode->mode_array; i++) {
+		if (abs(vmode->crtc[i].refresh_rate - vmode_refresh)
+			< abs(best->refresh_rate - vmode_refresh))
+			best = &vmode->crtc[i];
 	}
-	return RES_640X480_60HZ_PIXCLOCK;
 
+	return 1000000000 / (best->crtc.hor_total * best->crtc.ver_total)
+		* 1000 / best->refresh_rate;
 }
 
 int viafb_get_refresh(int hres, int vres, u32 long_refresh)
 {
-#define REFRESH_TOLERANCE 3
-	int i, nearest = -1, diff = REFRESH_TOLERANCE;
-	for (i = 0; i < NUM_TOTAL_RES_MAP_REFRESH; i++) {
-		if ((hres == res_map_refresh_tbl[i].hres)
-		    && (vres == res_map_refresh_tbl[i].vres)
-		    && (diff > (abs(long_refresh -
-		    res_map_refresh_tbl[i].vmode_refresh)))) {
-			diff = abs(long_refresh - res_map_refresh_tbl[i].
-				vmode_refresh);
-			nearest = i;
-		}
+	int i;
+	struct crt_mode_table *best;
+	struct VideoModeTable *vmode = viafb_get_mode(hres, vres);
+
+	if (!vmode)
+		return 60;
+
+	best = &vmode->crtc[0];
+	for (i = 1; i < vmode->mode_array; i++) {
+		if (abs(vmode->crtc[i].refresh_rate - long_refresh)
+			< abs(best->refresh_rate - long_refresh))
+			best = &vmode->crtc[i];
 	}
-#undef REFRESH_TOLERANCE
-	if (nearest > 0)
-		return res_map_refresh_tbl[nearest].vmode_refresh;
-	return 60;
+
+	if (abs(best->refresh_rate - long_refresh) > 3)
+		return 60;
+
+	return best->refresh_rate;
 }
 
 static void device_off(void)
diff --git a/drivers/video/via/share.h b/drivers/video/via/share.h
index 2cbe103..b04c047 100644
--- a/drivers/video/via/share.h
+++ b/drivers/video/via/share.h
@@ -722,76 +722,7 @@
 
 /* Definition Video Mode Pixel Clock (picoseconds)
 */
-#define RES_480X640_60HZ_PIXCLOCK    39722
 #define RES_640X480_60HZ_PIXCLOCK    39722
-#define RES_640X480_75HZ_PIXCLOCK    31747
-#define RES_640X480_85HZ_PIXCLOCK    27777
-#define RES_640X480_100HZ_PIXCLOCK   23168
-#define RES_640X480_120HZ_PIXCLOCK   19081
-#define RES_720X480_60HZ_PIXCLOCK    37020
-#define RES_720X576_60HZ_PIXCLOCK    30611
-#define RES_800X600_60HZ_PIXCLOCK    25000
-#define RES_800X600_75HZ_PIXCLOCK    20203
-#define RES_800X600_85HZ_PIXCLOCK    17777
-#define RES_800X600_100HZ_PIXCLOCK   14667
-#define RES_800X600_120HZ_PIXCLOCK   11912
-#define RES_800X480_60HZ_PIXCLOCK    33805
-#define RES_848X480_60HZ_PIXCLOCK    31756
-#define RES_856X480_60HZ_PIXCLOCK    31518
-#define RES_1024X512_60HZ_PIXCLOCK   24218
-#define RES_1024X600_60HZ_PIXCLOCK   20460
-#define RES_1024X768_60HZ_PIXCLOCK   15385
-#define RES_1024X768_75HZ_PIXCLOCK   12699
-#define RES_1024X768_85HZ_PIXCLOCK   10582
-#define RES_1024X768_100HZ_PIXCLOCK  8825
-#define RES_1152X864_75HZ_PIXCLOCK   9259
-#define RES_1280X768_60HZ_PIXCLOCK   12480
-#define RES_1280X800_60HZ_PIXCLOCK   11994
-#define RES_1280X960_60HZ_PIXCLOCK   9259
-#define RES_1280X1024_60HZ_PIXCLOCK  9260
-#define RES_1280X1024_75HZ_PIXCLOCK  7408
-#define RES_1280X768_85HZ_PIXCLOCK   6349
-#define RES_1440X1050_60HZ_PIXCLOCK  7993
-#define RES_1600X1200_60HZ_PIXCLOCK  6172
-#define RES_1600X1200_75HZ_PIXCLOCK  4938
-#define RES_1280X720_60HZ_PIXCLOCK   13426
-#define RES_1200X900_60HZ_PIXCLOCK   17459
-#define RES_1920X1080_60HZ_PIXCLOCK  5787
-#define RES_1400X1050_60HZ_PIXCLOCK  8214
-#define RES_1400X1050_75HZ_PIXCLOCK  6410
-#define RES_1368X768_60HZ_PIXCLOCK   11647
-#define RES_960X600_60HZ_PIXCLOCK      22099
-#define RES_1000X600_60HZ_PIXCLOCK    20834
-#define RES_1024X576_60HZ_PIXCLOCK    21278
-#define RES_1088X612_60HZ_PIXCLOCK    18877
-#define RES_1152X720_60HZ_PIXCLOCK    14981
-#define RES_1200X720_60HZ_PIXCLOCK    14253
-#define RES_1280X600_60HZ_PIXCLOCK    16260
-#define RES_1280X720_50HZ_PIXCLOCK    16538
-#define RES_1280X768_50HZ_PIXCLOCK    15342
-#define RES_1366X768_50HZ_PIXCLOCK    14301
-#define RES_1366X768_60HZ_PIXCLOCK    11646
-#define RES_1360X768_60HZ_PIXCLOCK    11799
-#define RES_1440X900_60HZ_PIXCLOCK    9390
-#define RES_1440X900_75HZ_PIXCLOCK    7315
-#define RES_1600X900_60HZ_PIXCLOCK    8415
-#define RES_1600X1024_60HZ_PIXCLOCK   7315
-#define RES_1680X1050_60HZ_PIXCLOCK   6814
-#define RES_1680X1050_75HZ_PIXCLOCK   5348
-#define RES_1792X1344_60HZ_PIXCLOCK   4902
-#define RES_1856X1392_60HZ_PIXCLOCK   4577
-#define RES_1920X1200_60HZ_PIXCLOCK   5173
-#define RES_1920X1440_60HZ_PIXCLOCK   4274
-#define RES_1920X1440_75HZ_PIXCLOCK   3367
-#define RES_2048X1536_60HZ_PIXCLOCK   3742
-
-#define RES_1360X768_RB_60HZ_PIXCLOCK 13889
-#define RES_1400X1050_RB_60HZ_PIXCLOCK 9901
-#define RES_1440X900_RB_60HZ_PIXCLOCK   11268
-#define RES_1600X900_RB_60HZ_PIXCLOCK   10230
-#define RES_1680X1050_RB_60HZ_PIXCLOCK 8403
-#define RES_1920X1080_RB_60HZ_PIXCLOCK 7225
-#define RES_1920X1200_RB_60HZ_PIXCLOCK 6497
 
 /* LCD display method
 */
diff --git a/drivers/video/via/viamode.c b/drivers/video/via/viamode.c
index 4b06dd7..ea0bc7a 100644
--- a/drivers/video/via/viamode.c
+++ b/drivers/video/via/viamode.c
@@ -21,72 +21,6 @@
 
 #include <linux/via-core.h>
 #include "global.h"
-struct res_map_refresh res_map_refresh_tbl[] = {
-/*hres, vres, vclock, vmode_refresh*/
-	{480, 640, RES_480X640_60HZ_PIXCLOCK, 60},
-	{640, 480, RES_640X480_60HZ_PIXCLOCK, 60},
-	{640, 480, RES_640X480_75HZ_PIXCLOCK, 75},
-	{640, 480, RES_640X480_85HZ_PIXCLOCK, 85},
-	{640, 480, RES_640X480_100HZ_PIXCLOCK, 100},
-	{640, 480, RES_640X480_120HZ_PIXCLOCK, 120},
-	{720, 480, RES_720X480_60HZ_PIXCLOCK, 60},
-	{720, 576, RES_720X576_60HZ_PIXCLOCK, 60},
-	{800, 480, RES_800X480_60HZ_PIXCLOCK, 60},
-	{800, 600, RES_800X600_60HZ_PIXCLOCK, 60},
-	{800, 600, RES_800X600_75HZ_PIXCLOCK, 75},
-	{800, 600, RES_800X600_85HZ_PIXCLOCK, 85},
-	{800, 600, RES_800X600_100HZ_PIXCLOCK, 100},
-	{800, 600, RES_800X600_120HZ_PIXCLOCK, 120},
-	{848, 480, RES_848X480_60HZ_PIXCLOCK, 60},
-	{856, 480, RES_856X480_60HZ_PIXCLOCK, 60},
-	{1024, 512, RES_1024X512_60HZ_PIXCLOCK, 60},
-	{1024, 600, RES_1024X600_60HZ_PIXCLOCK, 60},
-	{1024, 768, RES_1024X768_60HZ_PIXCLOCK, 60},
-	{1024, 768, RES_1024X768_75HZ_PIXCLOCK, 75},
-	{1024, 768, RES_1024X768_85HZ_PIXCLOCK, 85},
-	{1024, 768, RES_1024X768_100HZ_PIXCLOCK, 100},
-/*  {1152,864, RES_1152X864_70HZ_PIXCLOCK,  70},*/
-	{1152, 864, RES_1152X864_75HZ_PIXCLOCK, 75},
-	{1280, 768, RES_1280X768_60HZ_PIXCLOCK, 60},
-	{1280, 800, RES_1280X800_60HZ_PIXCLOCK, 60},
-	{1280, 960, RES_1280X960_60HZ_PIXCLOCK, 60},
-	{1280, 1024, RES_1280X1024_60HZ_PIXCLOCK, 60},
-	{1280, 1024, RES_1280X1024_75HZ_PIXCLOCK, 75},
-	{1280, 1024, RES_1280X768_85HZ_PIXCLOCK, 85},
-	{1440, 1050, RES_1440X1050_60HZ_PIXCLOCK, 60},
-	{1600, 1200, RES_1600X1200_60HZ_PIXCLOCK, 60},
-	{1600, 1200, RES_1600X1200_75HZ_PIXCLOCK, 75},
-	{1280, 720, RES_1280X720_60HZ_PIXCLOCK, 60},
-	{1920, 1080, RES_1920X1080_60HZ_PIXCLOCK, 60},
-	{1400, 1050, RES_1400X1050_60HZ_PIXCLOCK, 60},
-	{1400, 1050, RES_1400X1050_75HZ_PIXCLOCK, 75},
-	{1368, 768, RES_1368X768_60HZ_PIXCLOCK, 60},
-	{960, 600, RES_960X600_60HZ_PIXCLOCK, 60},
-	{1000, 600, RES_1000X600_60HZ_PIXCLOCK, 60},
-	{1024, 576, RES_1024X576_60HZ_PIXCLOCK, 60},
-	{1088, 612, RES_1088X612_60HZ_PIXCLOCK, 60},
-	{1152, 720, RES_1152X720_60HZ_PIXCLOCK, 60},
-	{1200, 720, RES_1200X720_60HZ_PIXCLOCK, 60},
-	{1200, 900, RES_1200X900_60HZ_PIXCLOCK, 60},
-	{1280, 600, RES_1280X600_60HZ_PIXCLOCK, 60},
-	{1280, 720, RES_1280X720_50HZ_PIXCLOCK, 50},
-	{1280, 768, RES_1280X768_50HZ_PIXCLOCK, 50},
-	{1360, 768, RES_1360X768_60HZ_PIXCLOCK, 60},
-	{1366, 768, RES_1366X768_50HZ_PIXCLOCK, 50},
-	{1366, 768, RES_1366X768_60HZ_PIXCLOCK, 60},
-	{1440, 900, RES_1440X900_60HZ_PIXCLOCK, 60},
-	{1440, 900, RES_1440X900_75HZ_PIXCLOCK, 75},
-	{1600, 900, RES_1600X900_60HZ_PIXCLOCK, 60},
-	{1600, 1024, RES_1600X1024_60HZ_PIXCLOCK, 60},
-	{1680, 1050, RES_1680X1050_60HZ_PIXCLOCK, 60},
-	{1680, 1050, RES_1680X1050_75HZ_PIXCLOCK, 75},
-	{1792, 1344, RES_1792X1344_60HZ_PIXCLOCK, 60},
-	{1856, 1392, RES_1856X1392_60HZ_PIXCLOCK, 60},
-	{1920, 1200, RES_1920X1200_60HZ_PIXCLOCK, 60},
-	{1920, 1440, RES_1920X1440_60HZ_PIXCLOCK, 60},
-	{1920, 1440, RES_1920X1440_75HZ_PIXCLOCK, 75},
-	{2048, 1536, RES_2048X1536_60HZ_PIXCLOCK, 60}
-};
 
 struct io_reg CN400_ModeXregs[] = { {VIASR, SR10, 0xFF, 0x01},
 {VIASR, SR15, 0x02, 0x02},
@@ -1057,7 +991,6 @@ struct VideoModeTable CEA_HDMI_Modes[] = {
 	{CEAM1920x1080, ARRAY_SIZE(CEAM1920x1080)}
 };
 
-int NUM_TOTAL_RES_MAP_REFRESH = ARRAY_SIZE(res_map_refresh_tbl);
 int NUM_TOTAL_CEA_MODES = ARRAY_SIZE(CEA_HDMI_Modes);
 int NUM_TOTAL_CN400_ModeXregs = ARRAY_SIZE(CN400_ModeXregs);
 int NUM_TOTAL_CN700_ModeXregs = ARRAY_SIZE(CN700_ModeXregs);
diff --git a/drivers/video/via/viamode.h b/drivers/video/via/viamode.h
index 5b1ced8..8a67ea1 100644
--- a/drivers/video/via/viamode.h
+++ b/drivers/video/via/viamode.h
@@ -41,14 +41,6 @@ struct patch_table {
 	struct io_reg *io_reg_table;
 };
 
-struct res_map_refresh {
-	int hres;
-	int vres;
-	int pixclock;
-	int vmode_refresh;
-};
-
-extern int NUM_TOTAL_RES_MAP_REFRESH;
 extern int NUM_TOTAL_CEA_MODES;
 extern int NUM_TOTAL_CN400_ModeXregs;
 extern int NUM_TOTAL_CN700_ModeXregs;
@@ -66,7 +58,6 @@ extern struct crt_mode_table CEAM1280x720[];
 extern struct crt_mode_table CEAM1920x1080[];
 extern struct VideoModeTable CEA_HDMI_Modes[];
 
-extern struct res_map_refresh res_map_refresh_tbl[];
 extern struct io_reg CN400_ModeXregs[];
 extern struct io_reg CN700_ModeXregs[];
 extern struct io_reg KM400_ModeXregs[];
-- 
1.6.3.2

