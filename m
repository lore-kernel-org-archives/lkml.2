Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756366Ab1HEVow (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 17:44:52 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:35410 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755944Ab1HEVot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 17:44:49 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX192U6EJBVt2S60FY/qDe8uSlbMb4lTEfy3YdIEeo6
	L/cTlZTVrn2lMW
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [PATCH 1/6] viafb: use more compact modesetting functions
Date: Fri,  5 Aug 2011 22:03:17 +0000
Message-Id: <1312581799-4084-1-git-send-email-FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <cover.1312578946.git.FlorianSchandinat@gmx.de>
References: <cover.1312578946.git.FlorianSchandinat@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch replaces the old timing setup code with a redesigned one.
The new code might be slightly faster as it has no conditinals and
does not write the same register multiple times. Also it makes the
comparison to the documentation easier.
Regressions are unlikely but could happen as a lot of hardware is
undocumented.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
---
 drivers/video/via/hw.c              |  296 +----------------------------------
 drivers/video/via/hw.h              |  273 --------------------------------
 drivers/video/via/share.h           |   19 +--
 drivers/video/via/via_modesetting.c |  100 ++++++++++++
 drivers/video/via/via_modesetting.h |   18 ++
 5 files changed, 128 insertions(+), 578 deletions(-)

diff --git a/drivers/video/via/hw.c b/drivers/video/via/hw.c
index 47b1353..372ce4f 100644
--- a/drivers/video/via/hw.c
+++ b/drivers/video/via/hw.c
@@ -191,67 +191,6 @@ static struct fetch_count fetch_count_reg = {
 	{IGA2_FETCH_COUNT_REG_NUM, {{CR65, 0, 7}, {CR67, 2, 3} } }
 };
 
-static struct iga1_crtc_timing iga1_crtc_reg = {
-	/* IGA1 Horizontal Total */
-	{IGA1_HOR_TOTAL_REG_NUM, {{CR00, 0, 7}, {CR36, 3, 3} } },
-	/* IGA1 Horizontal Addressable Video */
-	{IGA1_HOR_ADDR_REG_NUM, {{CR01, 0, 7} } },
-	/* IGA1 Horizontal Blank Start */
-	{IGA1_HOR_BLANK_START_REG_NUM, {{CR02, 0, 7} } },
-	/* IGA1 Horizontal Blank End */
-	{IGA1_HOR_BLANK_END_REG_NUM,
-	 {{CR03, 0, 4}, {CR05, 7, 7}, {CR33, 5, 5} } },
-	/* IGA1 Horizontal Sync Start */
-	{IGA1_HOR_SYNC_START_REG_NUM, {{CR04, 0, 7}, {CR33, 4, 4} } },
-	/* IGA1 Horizontal Sync End */
-	{IGA1_HOR_SYNC_END_REG_NUM, {{CR05, 0, 4} } },
-	/* IGA1 Vertical Total */
-	{IGA1_VER_TOTAL_REG_NUM,
-	 {{CR06, 0, 7}, {CR07, 0, 0}, {CR07, 5, 5}, {CR35, 0, 0} } },
-	/* IGA1 Vertical Addressable Video */
-	{IGA1_VER_ADDR_REG_NUM,
-	 {{CR12, 0, 7}, {CR07, 1, 1}, {CR07, 6, 6}, {CR35, 2, 2} } },
-	/* IGA1 Vertical Blank Start */
-	{IGA1_VER_BLANK_START_REG_NUM,
-	 {{CR15, 0, 7}, {CR07, 3, 3}, {CR09, 5, 5}, {CR35, 3, 3} } },
-	/* IGA1 Vertical Blank End */
-	{IGA1_VER_BLANK_END_REG_NUM, {{CR16, 0, 7} } },
-	/* IGA1 Vertical Sync Start */
-	{IGA1_VER_SYNC_START_REG_NUM,
-	 {{CR10, 0, 7}, {CR07, 2, 2}, {CR07, 7, 7}, {CR35, 1, 1} } },
-	/* IGA1 Vertical Sync End */
-	{IGA1_VER_SYNC_END_REG_NUM, {{CR11, 0, 3} } }
-};
-
-static struct iga2_crtc_timing iga2_crtc_reg = {
-	/* IGA2 Horizontal Total */
-	{IGA2_HOR_TOTAL_REG_NUM, {{CR50, 0, 7}, {CR55, 0, 3} } },
-	/* IGA2 Horizontal Addressable Video */
-	{IGA2_HOR_ADDR_REG_NUM, {{CR51, 0, 7}, {CR55, 4, 6} } },
-	/* IGA2 Horizontal Blank Start */
-	{IGA2_HOR_BLANK_START_REG_NUM, {{CR52, 0, 7}, {CR54, 0, 2} } },
-	/* IGA2 Horizontal Blank End */
-	{IGA2_HOR_BLANK_END_REG_NUM,
-	 {{CR53, 0, 7}, {CR54, 3, 5}, {CR5D, 6, 6} } },
-	/* IGA2 Horizontal Sync Start */
-	{IGA2_HOR_SYNC_START_REG_NUM,
-	 {{CR56, 0, 7}, {CR54, 6, 7}, {CR5C, 7, 7}, {CR5D, 7, 7} } },
-	/* IGA2 Horizontal Sync End */
-	{IGA2_HOR_SYNC_END_REG_NUM, {{CR57, 0, 7}, {CR5C, 6, 6} } },
-	/* IGA2 Vertical Total */
-	{IGA2_VER_TOTAL_REG_NUM, {{CR58, 0, 7}, {CR5D, 0, 2} } },
-	/* IGA2 Vertical Addressable Video */
-	{IGA2_VER_ADDR_REG_NUM, {{CR59, 0, 7}, {CR5D, 3, 5} } },
-	/* IGA2 Vertical Blank Start */
-	{IGA2_VER_BLANK_START_REG_NUM, {{CR5A, 0, 7}, {CR5C, 0, 2} } },
-	/* IGA2 Vertical Blank End */
-	{IGA2_VER_BLANK_END_REG_NUM, {{CR5B, 0, 7}, {CR5C, 3, 5} } },
-	/* IGA2 Vertical Sync Start */
-	{IGA2_VER_SYNC_START_REG_NUM, {{CR5E, 0, 7}, {CR5F, 5, 7} } },
-	/* IGA2 Vertical Sync End */
-	{IGA2_VER_SYNC_END_REG_NUM, {{CR5F, 0, 4} } }
-};
-
 static struct rgbLUT palLUT_table[] = {
 	/* {R,G,B} */
 	/* Index 0x00~0x03 */
@@ -1531,234 +1470,15 @@ void viafb_set_vclock(u32 clk, int set_iga)
 void viafb_load_crtc_timing(struct display_timing device_timing,
 	int set_iga)
 {
-	int i;
-	int viafb_load_reg_num = 0;
-	int reg_value = 0;
-	struct io_register *reg = NULL;
-
-	viafb_unlock_crt();
-
-	for (i = 0; i < 12; i++) {
-		if (set_iga == IGA1) {
-			switch (i) {
-			case H_TOTAL_INDEX:
-				reg_value =
-				    IGA1_HOR_TOTAL_FORMULA(device_timing.
-							   hor_total);
-				viafb_load_reg_num =
-					iga1_crtc_reg.hor_total.reg_num;
-				reg = iga1_crtc_reg.hor_total.reg;
-				break;
-			case H_ADDR_INDEX:
-				reg_value =
-				    IGA1_HOR_ADDR_FORMULA(device_timing.
-							  hor_addr);
-				viafb_load_reg_num =
-					iga1_crtc_reg.hor_addr.reg_num;
-				reg = iga1_crtc_reg.hor_addr.reg;
-				break;
-			case H_BLANK_START_INDEX:
-				reg_value =
-				    IGA1_HOR_BLANK_START_FORMULA
-				    (device_timing.hor_blank_start);
-				viafb_load_reg_num =
-				    iga1_crtc_reg.hor_blank_start.reg_num;
-				reg = iga1_crtc_reg.hor_blank_start.reg;
-				break;
-			case H_BLANK_END_INDEX:
-				reg_value =
-				    IGA1_HOR_BLANK_END_FORMULA
-				    (device_timing.hor_blank_start,
-				     device_timing.hor_blank_end);
-				viafb_load_reg_num =
-				    iga1_crtc_reg.hor_blank_end.reg_num;
-				reg = iga1_crtc_reg.hor_blank_end.reg;
-				break;
-			case H_SYNC_START_INDEX:
-				reg_value =
-				    IGA1_HOR_SYNC_START_FORMULA
-				    (device_timing.hor_sync_start);
-				viafb_load_reg_num =
-				    iga1_crtc_reg.hor_sync_start.reg_num;
-				reg = iga1_crtc_reg.hor_sync_start.reg;
-				break;
-			case H_SYNC_END_INDEX:
-				reg_value =
-				    IGA1_HOR_SYNC_END_FORMULA
-				    (device_timing.hor_sync_start,
-				     device_timing.hor_sync_end);
-				viafb_load_reg_num =
-				    iga1_crtc_reg.hor_sync_end.reg_num;
-				reg = iga1_crtc_reg.hor_sync_end.reg;
-				break;
-			case V_TOTAL_INDEX:
-				reg_value =
-				    IGA1_VER_TOTAL_FORMULA(device_timing.
-							   ver_total);
-				viafb_load_reg_num =
-					iga1_crtc_reg.ver_total.reg_num;
-				reg = iga1_crtc_reg.ver_total.reg;
-				break;
-			case V_ADDR_INDEX:
-				reg_value =
-				    IGA1_VER_ADDR_FORMULA(device_timing.
-							  ver_addr);
-				viafb_load_reg_num =
-					iga1_crtc_reg.ver_addr.reg_num;
-				reg = iga1_crtc_reg.ver_addr.reg;
-				break;
-			case V_BLANK_START_INDEX:
-				reg_value =
-				    IGA1_VER_BLANK_START_FORMULA
-				    (device_timing.ver_blank_start);
-				viafb_load_reg_num =
-				    iga1_crtc_reg.ver_blank_start.reg_num;
-				reg = iga1_crtc_reg.ver_blank_start.reg;
-				break;
-			case V_BLANK_END_INDEX:
-				reg_value =
-				    IGA1_VER_BLANK_END_FORMULA
-				    (device_timing.ver_blank_start,
-				     device_timing.ver_blank_end);
-				viafb_load_reg_num =
-				    iga1_crtc_reg.ver_blank_end.reg_num;
-				reg = iga1_crtc_reg.ver_blank_end.reg;
-				break;
-			case V_SYNC_START_INDEX:
-				reg_value =
-				    IGA1_VER_SYNC_START_FORMULA
-				    (device_timing.ver_sync_start);
-				viafb_load_reg_num =
-				    iga1_crtc_reg.ver_sync_start.reg_num;
-				reg = iga1_crtc_reg.ver_sync_start.reg;
-				break;
-			case V_SYNC_END_INDEX:
-				reg_value =
-				    IGA1_VER_SYNC_END_FORMULA
-				    (device_timing.ver_sync_start,
-				     device_timing.ver_sync_end);
-				viafb_load_reg_num =
-				    iga1_crtc_reg.ver_sync_end.reg_num;
-				reg = iga1_crtc_reg.ver_sync_end.reg;
-				break;
-
-			}
-		}
-
-		if (set_iga == IGA2) {
-			switch (i) {
-			case H_TOTAL_INDEX:
-				reg_value =
-				    IGA2_HOR_TOTAL_FORMULA(device_timing.
-							   hor_total);
-				viafb_load_reg_num =
-					iga2_crtc_reg.hor_total.reg_num;
-				reg = iga2_crtc_reg.hor_total.reg;
-				break;
-			case H_ADDR_INDEX:
-				reg_value =
-				    IGA2_HOR_ADDR_FORMULA(device_timing.
-							  hor_addr);
-				viafb_load_reg_num =
-					iga2_crtc_reg.hor_addr.reg_num;
-				reg = iga2_crtc_reg.hor_addr.reg;
-				break;
-			case H_BLANK_START_INDEX:
-				reg_value =
-				    IGA2_HOR_BLANK_START_FORMULA
-				    (device_timing.hor_blank_start);
-				viafb_load_reg_num =
-				    iga2_crtc_reg.hor_blank_start.reg_num;
-				reg = iga2_crtc_reg.hor_blank_start.reg;
-				break;
-			case H_BLANK_END_INDEX:
-				reg_value =
-				    IGA2_HOR_BLANK_END_FORMULA
-				    (device_timing.hor_blank_start,
-				     device_timing.hor_blank_end);
-				viafb_load_reg_num =
-				    iga2_crtc_reg.hor_blank_end.reg_num;
-				reg = iga2_crtc_reg.hor_blank_end.reg;
-				break;
-			case H_SYNC_START_INDEX:
-				reg_value =
-				    IGA2_HOR_SYNC_START_FORMULA
-				    (device_timing.hor_sync_start);
-				if (UNICHROME_CN700 <=
-					viaparinfo->chip_info->gfx_chip_name)
-					viafb_load_reg_num =
-					    iga2_crtc_reg.hor_sync_start.
-					    reg_num;
-				else
-					viafb_load_reg_num = 3;
-				reg = iga2_crtc_reg.hor_sync_start.reg;
-				break;
-			case H_SYNC_END_INDEX:
-				reg_value =
-				    IGA2_HOR_SYNC_END_FORMULA
-				    (device_timing.hor_sync_start,
-				     device_timing.hor_sync_end);
-				viafb_load_reg_num =
-				    iga2_crtc_reg.hor_sync_end.reg_num;
-				reg = iga2_crtc_reg.hor_sync_end.reg;
-				break;
-			case V_TOTAL_INDEX:
-				reg_value =
-				    IGA2_VER_TOTAL_FORMULA(device_timing.
-							   ver_total);
-				viafb_load_reg_num =
-					iga2_crtc_reg.ver_total.reg_num;
-				reg = iga2_crtc_reg.ver_total.reg;
-				break;
-			case V_ADDR_INDEX:
-				reg_value =
-				    IGA2_VER_ADDR_FORMULA(device_timing.
-							  ver_addr);
-				viafb_load_reg_num =
-					iga2_crtc_reg.ver_addr.reg_num;
-				reg = iga2_crtc_reg.ver_addr.reg;
-				break;
-			case V_BLANK_START_INDEX:
-				reg_value =
-				    IGA2_VER_BLANK_START_FORMULA
-				    (device_timing.ver_blank_start);
-				viafb_load_reg_num =
-				    iga2_crtc_reg.ver_blank_start.reg_num;
-				reg = iga2_crtc_reg.ver_blank_start.reg;
-				break;
-			case V_BLANK_END_INDEX:
-				reg_value =
-				    IGA2_VER_BLANK_END_FORMULA
-				    (device_timing.ver_blank_start,
-				     device_timing.ver_blank_end);
-				viafb_load_reg_num =
-				    iga2_crtc_reg.ver_blank_end.reg_num;
-				reg = iga2_crtc_reg.ver_blank_end.reg;
-				break;
-			case V_SYNC_START_INDEX:
-				reg_value =
-				    IGA2_VER_SYNC_START_FORMULA
-				    (device_timing.ver_sync_start);
-				viafb_load_reg_num =
-				    iga2_crtc_reg.ver_sync_start.reg_num;
-				reg = iga2_crtc_reg.ver_sync_start.reg;
-				break;
-			case V_SYNC_END_INDEX:
-				reg_value =
-				    IGA2_VER_SYNC_END_FORMULA
-				    (device_timing.ver_sync_start,
-				     device_timing.ver_sync_end);
-				viafb_load_reg_num =
-				    iga2_crtc_reg.ver_sync_end.reg_num;
-				reg = iga2_crtc_reg.ver_sync_end.reg;
-				break;
+	device_timing.hor_blank_end += device_timing.hor_blank_start;
+	device_timing.hor_sync_end += device_timing.hor_sync_start;
+	device_timing.ver_blank_end += device_timing.ver_blank_start;
+	device_timing.ver_sync_end += device_timing.ver_sync_start;
 
-			}
-		}
-		viafb_load_reg(reg_value, viafb_load_reg_num, reg, VIACR);
-	}
-
-	viafb_lock_crt();
+	if (set_iga == IGA1)
+		via_set_primary_timing(&device_timing);
+	else if (set_iga == IGA2)
+		via_set_secondary_timing(&device_timing);
 }
 
 void viafb_fill_crtc_timing(struct crt_mode_table *crt_table,
diff --git a/drivers/video/via/hw.h b/drivers/video/via/hw.h
index c7239eb..267c669 100644
--- a/drivers/video/via/hw.h
+++ b/drivers/video/via/hw.h
@@ -51,40 +51,6 @@
 #define VIA_HSYNC_NEGATIVE	0x01
 #define VIA_VSYNC_NEGATIVE	0x02
 
-/***************************************************
-* Definition IGA1 Design Method of CRTC Registers *
-****************************************************/
-#define IGA1_HOR_TOTAL_FORMULA(x)           (((x)/8)-5)
-#define IGA1_HOR_ADDR_FORMULA(x)            (((x)/8)-1)
-#define IGA1_HOR_BLANK_START_FORMULA(x)     (((x)/8)-1)
-#define IGA1_HOR_BLANK_END_FORMULA(x, y)     (((x+y)/8)-1)
-#define IGA1_HOR_SYNC_START_FORMULA(x)      ((x)/8)
-#define IGA1_HOR_SYNC_END_FORMULA(x, y)      ((x+y)/8)
-
-#define IGA1_VER_TOTAL_FORMULA(x)           ((x)-2)
-#define IGA1_VER_ADDR_FORMULA(x)            ((x)-1)
-#define IGA1_VER_BLANK_START_FORMULA(x)     ((x)-1)
-#define IGA1_VER_BLANK_END_FORMULA(x, y)     ((x+y)-1)
-#define IGA1_VER_SYNC_START_FORMULA(x)      ((x)-1)
-#define IGA1_VER_SYNC_END_FORMULA(x, y)      ((x+y)-1)
-
-/***************************************************
-** Definition IGA2 Design Method of CRTC Registers *
-****************************************************/
-#define IGA2_HOR_TOTAL_FORMULA(x)           ((x)-1)
-#define IGA2_HOR_ADDR_FORMULA(x)            ((x)-1)
-#define IGA2_HOR_BLANK_START_FORMULA(x)     ((x)-1)
-#define IGA2_HOR_BLANK_END_FORMULA(x, y)     ((x+y)-1)
-#define IGA2_HOR_SYNC_START_FORMULA(x)      ((x)-1)
-#define IGA2_HOR_SYNC_END_FORMULA(x, y)      ((x+y)-1)
-
-#define IGA2_VER_TOTAL_FORMULA(x)           ((x)-1)
-#define IGA2_VER_ADDR_FORMULA(x)            ((x)-1)
-#define IGA2_VER_BLANK_START_FORMULA(x)     ((x)-1)
-#define IGA2_VER_BLANK_END_FORMULA(x, y)     ((x+y)-1)
-#define IGA2_VER_SYNC_START_FORMULA(x)      ((x)-1)
-#define IGA2_VER_SYNC_END_FORMULA(x, y)      ((x+y)-1)
-
 /**********************************************************/
 /* Definition IGA2 Design Method of CRTC Shadow Registers */
 /**********************************************************/
@@ -97,33 +63,6 @@
 #define IGA2_VER_SYNC_START_SHADOW_FORMULA(x)      (x)
 #define IGA2_VER_SYNC_END_SHADOW_FORMULA(x, y)      (x+y)
 
-/* Define Register Number for IGA1 CRTC Timing */
-
-/* location: {CR00,0,7},{CR36,3,3} */
-#define IGA1_HOR_TOTAL_REG_NUM		2
-/* location: {CR01,0,7} */
-#define IGA1_HOR_ADDR_REG_NUM		1
-/* location: {CR02,0,7} */
-#define IGA1_HOR_BLANK_START_REG_NUM    1
-/* location: {CR03,0,4},{CR05,7,7},{CR33,5,5} */
-#define IGA1_HOR_BLANK_END_REG_NUM	3
-/* location: {CR04,0,7},{CR33,4,4} */
-#define IGA1_HOR_SYNC_START_REG_NUM	2
-/* location: {CR05,0,4} */
-#define IGA1_HOR_SYNC_END_REG_NUM       1
-/* location: {CR06,0,7},{CR07,0,0},{CR07,5,5},{CR35,0,0} */
-#define IGA1_VER_TOTAL_REG_NUM          4
-/* location: {CR12,0,7},{CR07,1,1},{CR07,6,6},{CR35,2,2} */
-#define IGA1_VER_ADDR_REG_NUM           4
-/* location: {CR15,0,7},{CR07,3,3},{CR09,5,5},{CR35,3,3} */
-#define IGA1_VER_BLANK_START_REG_NUM    4
-/* location: {CR16,0,7} */
-#define IGA1_VER_BLANK_END_REG_NUM      1
-/* location: {CR10,0,7},{CR07,2,2},{CR07,7,7},{CR35,1,1} */
-#define IGA1_VER_SYNC_START_REG_NUM     4
-/* location: {CR11,0,3} */
-#define IGA1_VER_SYNC_END_REG_NUM       1
-
 /* Define Register Number for IGA2 Shadow CRTC Timing */
 
 /* location: {CR6D,0,7},{CR71,3,3} */
@@ -143,37 +82,6 @@
 /* location: {CR76,0,3} */
 #define IGA2_SHADOW_VER_SYNC_END_REG_NUM    1
 
-/* Define Register Number for IGA2 CRTC Timing */
-
-/* location: {CR50,0,7},{CR55,0,3} */
-#define IGA2_HOR_TOTAL_REG_NUM          2
-/* location: {CR51,0,7},{CR55,4,6} */
-#define IGA2_HOR_ADDR_REG_NUM           2
-/* location: {CR52,0,7},{CR54,0,2} */
-#define IGA2_HOR_BLANK_START_REG_NUM    2
-/* location: CLE266: {CR53,0,7},{CR54,3,5} => CLE266's CR5D[6]
-is reserved, so it may have problem to set 1600x1200 on IGA2. */
-/*         	Others: {CR53,0,7},{CR54,3,5},{CR5D,6,6} */
-#define IGA2_HOR_BLANK_END_REG_NUM      3
-/* location: {CR56,0,7},{CR54,6,7},{CR5C,7,7} */
-/* VT3314 and Later: {CR56,0,7},{CR54,6,7},{CR5C,7,7}, {CR5D,7,7} */
-#define IGA2_HOR_SYNC_START_REG_NUM     4
-
-/* location: {CR57,0,7},{CR5C,6,6} */
-#define IGA2_HOR_SYNC_END_REG_NUM       2
-/* location: {CR58,0,7},{CR5D,0,2} */
-#define IGA2_VER_TOTAL_REG_NUM          2
-/* location: {CR59,0,7},{CR5D,3,5} */
-#define IGA2_VER_ADDR_REG_NUM           2
-/* location: {CR5A,0,7},{CR5C,0,2} */
-#define IGA2_VER_BLANK_START_REG_NUM    2
-/* location: {CR5E,0,7},{CR5C,3,5} */
-#define IGA2_VER_BLANK_END_REG_NUM      2
-/* location: {CR5E,0,7},{CR5F,5,7} */
-#define IGA2_VER_SYNC_START_REG_NUM     2
-/* location: {CR5F,0,4} */
-#define IGA2_VER_SYNC_END_REG_NUM       1
-
 /* Define Fetch Count Register*/
 
 /* location: {SR1C,0,7},{SR1D,0,1} */
@@ -446,87 +354,12 @@ is reserved, so it may have problem to set 1600x1200 on IGA2. */
 /* location: {CR78,0,7},{CR79,6,7} */
 #define LCD_VER_SCALING_FACTOR_REG_NUM_CLE  2
 
-/************************************************
- *****     Define IGA1 Display Timing       *****
- ************************************************/
 struct io_register {
 	u8 io_addr;
 	u8 start_bit;
 	u8 end_bit;
 };
 
-/* IGA1 Horizontal Total */
-struct iga1_hor_total {
-	int reg_num;
-	struct io_register reg[IGA1_HOR_TOTAL_REG_NUM];
-};
-
-/* IGA1 Horizontal Addressable Video */
-struct iga1_hor_addr {
-	int reg_num;
-	struct io_register reg[IGA1_HOR_ADDR_REG_NUM];
-};
-
-/* IGA1 Horizontal Blank Start */
-struct iga1_hor_blank_start {
-	int reg_num;
-	struct io_register reg[IGA1_HOR_BLANK_START_REG_NUM];
-};
-
-/* IGA1 Horizontal Blank End */
-struct iga1_hor_blank_end {
-	int reg_num;
-	struct io_register reg[IGA1_HOR_BLANK_END_REG_NUM];
-};
-
-/* IGA1 Horizontal Sync Start */
-struct iga1_hor_sync_start {
-	int reg_num;
-	struct io_register reg[IGA1_HOR_SYNC_START_REG_NUM];
-};
-
-/* IGA1 Horizontal Sync End */
-struct iga1_hor_sync_end {
-	int reg_num;
-	struct io_register reg[IGA1_HOR_SYNC_END_REG_NUM];
-};
-
-/* IGA1 Vertical Total */
-struct iga1_ver_total {
-	int reg_num;
-	struct io_register reg[IGA1_VER_TOTAL_REG_NUM];
-};
-
-/* IGA1 Vertical Addressable Video */
-struct iga1_ver_addr {
-	int reg_num;
-	struct io_register reg[IGA1_VER_ADDR_REG_NUM];
-};
-
-/* IGA1 Vertical Blank Start */
-struct iga1_ver_blank_start {
-	int reg_num;
-	struct io_register reg[IGA1_VER_BLANK_START_REG_NUM];
-};
-
-/* IGA1 Vertical Blank End */
-struct iga1_ver_blank_end {
-	int reg_num;
-	struct io_register reg[IGA1_VER_BLANK_END_REG_NUM];
-};
-
-/* IGA1 Vertical Sync Start */
-struct iga1_ver_sync_start {
-	int reg_num;
-	struct io_register reg[IGA1_VER_SYNC_START_REG_NUM];
-};
-
-/* IGA1 Vertical Sync End */
-struct iga1_ver_sync_end {
-	int reg_num;
-	struct io_register reg[IGA1_VER_SYNC_END_REG_NUM];
-};
-
 /*****************************************************
 **      Define IGA2 Shadow Display Timing         ****
 *****************************************************/
@@ -579,82 +412,6 @@ struct iga2_shadow_ver_sync_end {
 	struct io_register reg[IGA2_SHADOW_VER_SYNC_END_REG_NUM];
 };
 
-/*****************************************************
-**      Define IGA2 Display Timing                ****
-******************************************************/
-
-/* IGA2 Horizontal Total */
-struct iga2_hor_total {
-	int reg_num;
-	struct io_register reg[IGA2_HOR_TOTAL_REG_NUM];
-};
-
-/* IGA2 Horizontal Addressable Video */
-struct iga2_hor_addr {
-	int reg_num;
-	struct io_register reg[IGA2_HOR_ADDR_REG_NUM];
-};
-
-/* IGA2 Horizontal Blank Start */
-struct iga2_hor_blank_start {
-	int reg_num;
-	struct io_register reg[IGA2_HOR_BLANK_START_REG_NUM];
-};
-
-/* IGA2 Horizontal Blank End */
-struct iga2_hor_blank_end {
-	int reg_num;
-	struct io_register reg[IGA2_HOR_BLANK_END_REG_NUM];
-};
-
-/* IGA2 Horizontal Sync Start */
-struct iga2_hor_sync_start {
-	int reg_num;
-	struct io_register reg[IGA2_HOR_SYNC_START_REG_NUM];
-};
-
-/* IGA2 Horizontal Sync End */
-struct iga2_hor_sync_end {
-	int reg_num;
-	struct io_register reg[IGA2_HOR_SYNC_END_REG_NUM];
-};
-
-/* IGA2 Vertical Total */
-struct iga2_ver_total {
-	int reg_num;
-	struct io_register reg[IGA2_VER_TOTAL_REG_NUM];
-};
-
-/* IGA2 Vertical Addressable Video */
-struct iga2_ver_addr {
-	int reg_num;
-	struct io_register reg[IGA2_VER_ADDR_REG_NUM];
-};
-
-/* IGA2 Vertical Blank Start */
-struct iga2_ver_blank_start {
-	int reg_num;
-	struct io_register reg[IGA2_VER_BLANK_START_REG_NUM];
-};
-
-/* IGA2 Vertical Blank End */
-struct iga2_ver_blank_end {
-	int reg_num;
-	struct io_register reg[IGA2_VER_BLANK_END_REG_NUM];
-};
-
-/* IGA2 Vertical Sync Start */
-struct iga2_ver_sync_start {
-	int reg_num;
-	struct io_register reg[IGA2_VER_SYNC_START_REG_NUM];
-};
-
-/* IGA2 Vertical Sync End */
-struct iga2_ver_sync_end {
-	int reg_num;
-	struct io_register reg[IGA2_VER_SYNC_END_REG_NUM];
-};
-
 /* IGA1 Fetch Count Register */
 struct iga1_fetch_count {
 	int reg_num;
@@ -817,21 +574,6 @@ struct display_queue_expire_num {
 	 iga2_display_queue_expire_num_reg;
 };
 
-struct iga1_crtc_timing {
-	struct iga1_hor_total hor_total;
-	struct iga1_hor_addr hor_addr;
-	struct iga1_hor_blank_start hor_blank_start;
-	struct iga1_hor_blank_end hor_blank_end;
-	struct iga1_hor_sync_start hor_sync_start;
-	struct iga1_hor_sync_end hor_sync_end;
-	struct iga1_ver_total ver_total;
-	struct iga1_ver_addr ver_addr;
-	struct iga1_ver_blank_start ver_blank_start;
-	struct iga1_ver_blank_end ver_blank_end;
-	struct iga1_ver_sync_start ver_sync_start;
-	struct iga1_ver_sync_end ver_sync_end;
-};
-
 struct iga2_shadow_crtc_timing {
 	struct iga2_shadow_hor_total hor_total_shadow;
 	struct iga2_shadow_hor_blank_end hor_blank_end_shadow;
@@ -843,21 +585,6 @@ struct iga2_shadow_crtc_timing {
 	struct iga2_shadow_ver_sync_end ver_sync_end_shadow;
 };
 
-struct iga2_crtc_timing {
-	struct iga2_hor_total hor_total;
-	struct iga2_hor_addr hor_addr;
-	struct iga2_hor_blank_start hor_blank_start;
-	struct iga2_hor_blank_end hor_blank_end;
-	struct iga2_hor_sync_start hor_sync_start;
-	struct iga2_hor_sync_end hor_sync_end;
-	struct iga2_ver_total ver_total;
-	struct iga2_ver_addr ver_addr;
-	struct iga2_ver_blank_start ver_blank_start;
-	struct iga2_ver_blank_end ver_blank_end;
-	struct iga2_ver_sync_start ver_sync_start;
-	struct iga2_ver_sync_end ver_sync_end;
-};
-
 /* device ID */
 #define CLE266_FUNCTION3    0x3123
 #define KM400_FUNCTION3     0x3205
diff --git a/drivers/video/via/share.h b/drivers/video/via/share.h
index 61b0bd5..2906b2d 100644
--- a/drivers/video/via/share.h
+++ b/drivers/video/via/share.h
@@ -22,6 +22,8 @@
 #ifndef __SHARE_H__
 #define __SHARE_H__
 
+#include "via_modesetting.h"
+
 /* Define Bit Field */
 #define BIT0    0x01
 #define BIT1    0x02
@@ -648,23 +650,6 @@
 #define     LCD_OPENLDI               0x00
 #define     LCD_SPWG                  0x01
 
-/* Define display timing
-*/
-struct display_timing {
-	u16 hor_total;
-	u16 hor_addr;
-	u16 hor_blank_start;
-	u16 hor_blank_end;
-	u16 hor_sync_start;
-	u16 hor_sync_end;
-	u16 ver_total;
-	u16 ver_addr;
-	u16 ver_blank_start;
-	u16 ver_blank_end;
-	u16 ver_sync_start;
-	u16 ver_sync_end;
-};
-
 struct crt_mode_table {
 	int refresh_rate;
 	int h_sync_polarity;
diff --git a/drivers/video/via/via_modesetting.c b/drivers/video/via/via_modesetting.c
index 3cddcff..016d457 100644
--- a/drivers/video/via/via_modesetting.c
+++ b/drivers/video/via/via_modesetting.c
@@ -29,6 +29,106 @@
 #include "share.h"
 #include "debug.h"
 
+
+void via_set_primary_timing(const struct display_timing *timing)
+{
+	struct display_timing raw;
+
+	raw.hor_total = timing->hor_total / 8 - 5;
+	raw.hor_addr = timing->hor_addr / 8 - 1;
+	raw.hor_blank_start = timing->hor_blank_start / 8 - 1;
+	raw.hor_blank_end = timing->hor_blank_end / 8 - 1;
+	raw.hor_sync_start = timing->hor_sync_start / 8;
+	raw.hor_sync_end = timing->hor_sync_end / 8;
+	raw.ver_total = timing->ver_total - 2;
+	raw.ver_addr = timing->ver_addr - 1;
+	raw.ver_blank_start = timing->ver_blank_start - 1;
+	raw.ver_blank_end = timing->ver_blank_end - 1;
+	raw.ver_sync_start = timing->ver_sync_start - 1;
+	raw.ver_sync_end = timing->ver_sync_end - 1;
+
+	/* unlock timing registers */
+	via_write_reg_mask(VIACR, 0x11, 0x00, 0x80);
+
+	via_write_reg(VIACR, 0x00, raw.hor_total & 0xFF);
+	via_write_reg(VIACR, 0x01, raw.hor_addr & 0xFF);
+	via_write_reg(VIACR, 0x02, raw.hor_blank_start & 0xFF);
+	via_write_reg_mask(VIACR, 0x03, raw.hor_blank_end & 0x1F, 0x1F);
+	via_write_reg(VIACR, 0x04, raw.hor_sync_start & 0xFF);
+	via_write_reg_mask(VIACR, 0x05, (raw.hor_sync_end & 0x1F)
+		| (raw.hor_blank_end << (7 - 5) & 0x80), 0x9F);
+	via_write_reg(VIACR, 0x06, raw.ver_total & 0xFF);
+	via_write_reg_mask(VIACR, 0x07, (raw.ver_total >> 8 & 0x01)
+		| (raw.ver_addr >> (8 - 1) & 0x02)
+		| (raw.ver_sync_start >> (8 - 2) & 0x04)
+		| (raw.ver_blank_start >> (8 - 3) & 0x08)
+		| (raw.ver_total >> (9 - 5) & 0x20)
+		| (raw.ver_addr >> (9 - 6) & 0x40)
+		| (raw.ver_sync_start >> (9 - 7) & 0x80), 0xEF);
+	via_write_reg_mask(VIACR, 0x09, raw.ver_blank_start >> (9 - 5) & 0x20,
+		0x20);
+	via_write_reg(VIACR, 0x10, raw.ver_sync_start & 0xFF);
+	via_write_reg_mask(VIACR, 0x11, raw.ver_sync_end & 0x0F, 0x0F);
+	via_write_reg(VIACR, 0x12, raw.ver_addr & 0xFF);
+	via_write_reg(VIACR, 0x15, raw.ver_blank_start & 0xFF);
+	via_write_reg(VIACR, 0x16, raw.ver_blank_end & 0xFF);
+	via_write_reg_mask(VIACR, 0x33, (raw.hor_sync_start >> (8 - 4) & 0x10)
+		| (raw.hor_blank_end >> (6 - 5) & 0x20), 0x30);
+	via_write_reg_mask(VIACR, 0x35, (raw.ver_total >> 10 & 0x01)
+		| (raw.ver_sync_start >> (10 - 1) & 0x02)
+		| (raw.ver_addr >> (10 - 2) & 0x04)
+		| (raw.ver_blank_start >> (10 - 3) & 0x08), 0x0F);
+	via_write_reg_mask(VIACR, 0x36, raw.hor_total >> (8 - 3) & 0x08, 0x08);
+
+	/* lock timing registers */
+	via_write_reg_mask(VIACR, 0x11, 0x80, 0x80);
+}
+
+void via_set_secondary_timing(const struct display_timing *timing)
+{
+	struct display_timing raw;
+
+	raw.hor_total = timing->hor_total - 1;
+	raw.hor_addr = timing->hor_addr - 1;
+	raw.hor_blank_start = timing->hor_blank_start - 1;
+	raw.hor_blank_end = timing->hor_blank_end - 1;
+	raw.hor_sync_start = timing->hor_sync_start - 1;
+	raw.hor_sync_end = timing->hor_sync_end - 1;
+	raw.ver_total = timing->ver_total - 1;
+	raw.ver_addr = timing->ver_addr - 1;
+	raw.ver_blank_start = timing->ver_blank_start - 1;
+	raw.ver_blank_end = timing->ver_blank_end - 1;
+	raw.ver_sync_start = timing->ver_sync_start - 1;
+	raw.ver_sync_end = timing->ver_sync_end - 1;
+
+	via_write_reg(VIACR, 0x50, raw.hor_total & 0xFF);
+	via_write_reg(VIACR, 0x51, raw.hor_addr & 0xFF);
+	via_write_reg(VIACR, 0x52, raw.hor_blank_start & 0xFF);
+	via_write_reg(VIACR, 0x53, raw.hor_blank_end & 0xFF);
+	via_write_reg(VIACR, 0x54, (raw.hor_blank_start >> 8 & 0x07)
+		| (raw.hor_blank_end >> (8 - 3) & 0x38)
+		| (raw.hor_sync_start >> (8 - 6) & 0xC0));
+	via_write_reg_mask(VIACR, 0x55, (raw.hor_total >> 8 & 0x0F)
+		| (raw.hor_addr >> (8 - 4) & 0x70), 0x7F);
+	via_write_reg(VIACR, 0x56, raw.hor_sync_start & 0xFF);
+	via_write_reg(VIACR, 0x57, raw.hor_sync_end & 0xFF);
+	via_write_reg(VIACR, 0x58, raw.ver_total & 0xFF);
+	via_write_reg(VIACR, 0x59, raw.ver_addr & 0xFF);
+	via_write_reg(VIACR, 0x5A, raw.ver_blank_start & 0xFF);
+	via_write_reg(VIACR, 0x5B, raw.ver_blank_end & 0xFF);
+	via_write_reg(VIACR, 0x5C, (raw.ver_blank_start >> 8 & 0x07)
+		| (raw.ver_blank_end >> (8 - 3) & 0x38)
+		| (raw.hor_sync_end >> (8 - 6) & 0x40)
+		| (raw.hor_sync_start >> (10 - 7) & 0x80));
+	via_write_reg(VIACR, 0x5D, (raw.ver_total >> 8 & 0x07)
+		| (raw.ver_addr >> (8 - 3) & 0x38)
+		| (raw.hor_blank_end >> (11 - 6) & 0x40)
+		| (raw.hor_sync_start >> (11 - 7) & 0x80));
+	via_write_reg(VIACR, 0x5E, raw.ver_sync_start & 0xFF);
+	via_write_reg(VIACR, 0x5F, (raw.ver_sync_end & 0x1F)
+		| (raw.ver_sync_start >> (8 - 5) & 0xE0));
+}
+
 void via_set_primary_address(u32 addr)
 {
 	DEBUG_MSG(KERN_DEBUG "via_set_primary_address(0x%08X)\n", addr);
diff --git a/drivers/video/via/via_modesetting.h b/drivers/video/via/via_modesetting.h
index 0138845..06e09fe 100644
--- a/drivers/video/via/via_modesetting.h
+++ b/drivers/video/via/via_modesetting.h
@@ -33,6 +33,24 @@
 #define VIA_PITCH_MAX	0x3FF8
 
 
+struct display_timing {
+	u16 hor_total;
+	u16 hor_addr;
+	u16 hor_blank_start;
+	u16 hor_blank_end;
+	u16 hor_sync_start;
+	u16 hor_sync_end;
+	u16 ver_total;
+	u16 ver_addr;
+	u16 ver_blank_start;
+	u16 ver_blank_end;
+	u16 ver_sync_start;
+	u16 ver_sync_end;
+};
+
+
+void via_set_primary_timing(const struct display_timing *timing);
+void via_set_secondary_timing(const struct display_timing *timing);
 void via_set_primary_address(u32 addr);
 void via_set_secondary_address(u32 addr);
 void via_set_primary_pitch(u32 pitch);
-- 
1.6.3.2

