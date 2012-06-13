Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755089Ab2FMWXP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 18:23:15 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:44562 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754948Ab2FMWWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 18:22:09 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1/yMOZK+kryFOIchU77O83kD1laISj9gIeVqRmxqW
	FiUte5ws19oCV6
From: Peter Huewe <peterhuewe@gmx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Arnaud Patard <arnaud.patard@rtp-net.org>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Peter Huewe <peterhuewe@gmx.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 12/14] staging/xgifb: Replace delay lookup tables with constant values
Date: Thu, 14 Jun 2012 00:21:50 +0200
Message-Id: <1339626112-20671-12-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1339626112-20671-1-git-send-email-peterhuewe@gmx.de>
References: <1339626112-20671-1-git-send-email-peterhuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For TV Devices:
The values taken from XGI_TVDelayList are always overwritten with the
values from XGI_TVDelayList2 since the if condition for using the values
from XGI_TVDelayList2 is identical with the check to enter this scope and
thus always true.
The delay values in XGI_TVDelayList2 is always 0x22 so we
can simply replace it with this constant value.

For LCD Devices:
The LCD_DelayCompensation field is always set to 0x12 so we can simply
replace this field with a constant value.

This saves about 500 bytes in compiled size.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/xgifb/vb_setmode.c |   25 ++-------------
 drivers/staging/xgifb/vb_struct.h  |    3 --
 drivers/staging/xgifb/vb_table.h   |   60 +++++++++--------------------------
 3 files changed, 19 insertions(+), 69 deletions(-)

diff --git a/drivers/staging/xgifb/vb_setmode.c b/drivers/staging/xgifb/vb_setmode.c
index 2ffab45..c6c6843 100644
--- a/drivers/staging/xgifb/vb_setmode.c
+++ b/drivers/staging/xgifb/vb_setmode.c
@@ -105,9 +105,6 @@ void InitTo330Pointer(unsigned char ChipType, struct vb_device_info *pVBInfo)
 	else
 		pVBInfo->LCDCapList = XGI_LCDCapList;
 
-	pVBInfo->XGI_TVDelayList = XGI301TVDelayList;
-	pVBInfo->XGI_TVDelayList2 = XGI301TVDelayList2;
-
 	pVBInfo->pXGINew_I2CDefinition = &XG40_I2CDefinition;
 
 	if (ChipType >= XG20)
@@ -5712,32 +5709,19 @@ static void XGI_GetTVPtrIndex2(unsigned short *tempbx, unsigned char *tempcl,
 
 static void XGI_SetDelayComp(struct vb_device_info *pVBInfo)
 {
-	unsigned short index;
-
 	unsigned char tempah, tempbl, tempbh;
 
 	if (pVBInfo->VBType & (VB_SIS301B | VB_SIS302B | VB_SIS301LV
 			| VB_SIS302LV | VB_XGI301C)) {
 		if (pVBInfo->VBInfo & (SetCRT2ToLCD | XGI_SetCRT2ToLCDA
 				| SetCRT2ToTV | SetCRT2ToRAMDAC)) {
-			tempbl = 0;
 			tempbh = 0;
-
-			index = XGI_GetTVPtrIndex(pVBInfo); /* Get TV Delay */
-			tempbl = pVBInfo->XGI_TVDelayList[index];
-
-			if (pVBInfo->VBType & (VB_SIS301B | VB_SIS302B
-					| VB_SIS301LV | VB_SIS302LV
-					| VB_XGI301C))
-				tempbl = pVBInfo->XGI_TVDelayList2[index];
+			tempbl = XGI301TVDelay;
 
 			if (pVBInfo->VBInfo & SetCRT2ToDualEdge)
 				tempbl = tempbl >> 4;
 			if (pVBInfo->VBInfo & (SetCRT2ToLCD | XGI_SetCRT2ToLCDA)) {
-				/* Get LCD Delay */
-				index = XGI_GetLCDCapPtr(pVBInfo);
-				tempbh = pVBInfo->LCDCapList[index].
-						LCD_DelayCompensation;
+				tempbh = XGI301LCDDelay;
 
 				if (!(pVBInfo->VBInfo & XGI_SetCRT2ToLCDA))
 					tempbl = tempbh;
@@ -5763,10 +5747,7 @@ static void XGI_SetDelayComp(struct vb_device_info *pVBInfo)
 		tempbl = 0;
 		tempbh = 0;
 		if (pVBInfo->VBInfo & SetCRT2ToLCD) {
-			/* / Get LCD Delay */
-			tempah = pVBInfo->LCDCapList[
-					XGI_GetLCDCapPtr(pVBInfo)].
-						LCD_DelayCompensation;
+			tempah = XGI301LCDDelay;
 			tempah &= 0x0f;
 			tempah = tempah << 4;
 			xgifb_reg_and_or(pVBInfo->Part1Port, 0x2D, 0x0f,
diff --git a/drivers/staging/xgifb/vb_struct.h b/drivers/staging/xgifb/vb_struct.h
index 38f47ff..b954971 100644
--- a/drivers/staging/xgifb/vb_struct.h
+++ b/drivers/staging/xgifb/vb_struct.h
@@ -126,7 +126,6 @@ struct XGI330_LCDCapStruct {
 	unsigned char	LCD_ID;
 	unsigned short	LCD_Capability;
 	unsigned char	LCD_SetFlag;
-	unsigned char	LCD_DelayCompensation;
 	unsigned char	LCD_HSyncWidth;
 	unsigned char	LCD_VSyncWidth;
 	unsigned char	LCD_VCLK;
@@ -262,8 +261,6 @@ struct vb_device_info {
 	struct SiS_MCLKData  *MCLKData;
 	struct XGI_ECLKDataStruct  *ECLKData;
 
-	unsigned char   *XGI_TVDelayList;
-	unsigned char   *XGI_TVDelayList2;
 	unsigned char   *NTSCTiming;
 	unsigned char   *PALTiming;
 	unsigned char   *HiTVExtTiming;
diff --git a/drivers/staging/xgifb/vb_table.h b/drivers/staging/xgifb/vb_table.h
index 9a17113..50ef885 100644
--- a/drivers/staging/xgifb/vb_table.h
+++ b/drivers/staging/xgifb/vb_table.h
@@ -1993,70 +1993,70 @@ static unsigned short LCDLenList[] = {
 /* Dual link only */
 static struct XGI330_LCDCapStruct  XGI_LCDDLCapList[] = {
 /* LCDCap1024x768 */
-	{Panel_1024x768, DefaultLCDCap, 0, 0x012, 0x88, 0x06, VCLK65_315,
+	{Panel_1024x768, DefaultLCDCap, 0, 0x88, 0x06, VCLK65_315,
 	0x6C, 0xC3, 0x35, 0x62, 0x02, 0x14, 0x0A, 0x02, 0x00,
 	0x30, 0x10, 0x5A, 0x10, 0x10, 0x0A, 0xC0, 0x28, 0x10},
 /* LCDCap1280x1024 */
 	{Panel_1280x1024, XGI_LCDDualLink+DefaultLCDCap, StLCDBToA,
-	0x012, 0x70, 0x03, VCLK108_2_315,
+	0x70, 0x03, VCLK108_2_315,
 	0x70, 0x44, 0xF8, 0x2F, 0x02, 0x14, 0x0A, 0x02, 0x00,
 	0x30, 0x10, 0x5A, 0x10, 0x10, 0x0A, 0xC0, 0x30, 0x10},
 /* LCDCap1400x1050 */
 	{Panel_1400x1050, XGI_LCDDualLink+DefaultLCDCap, StLCDBToA,
-	0x012, 0x70, 0x03, VCLK108_2_315,
+	0x70, 0x03, VCLK108_2_315,
 	 0x70, 0x44, 0xF8, 0x2F, 0x02, 0x14, 0x0A, 0x02, 0x00,
 	 0x30, 0x10, 0x5A, 0x10, 0x10, 0x0A, 0xC0, 0x30, 0x10},
 /* LCDCap1600x1200 */
 	{Panel_1600x1200, XGI_LCDDualLink+DefaultLCDCap, LCDToFull,
-	0x012, 0xC0, 0x03, VCLK162,
+	0xC0, 0x03, VCLK162,
 	 0x43, 0x22, 0x70, 0x24, 0x02, 0x14, 0x0A, 0x02, 0x00,
 	 0x30, 0x10, 0x5A, 0x10, 0x10, 0x0A, 0xC0, 0x30, 0x10},
 /* LCDCap1024x768x75 */
-	{Panel_1024x768x75, DefaultLCDCap, 0, 0x012, 0x60, 0, VCLK78_75,
+	{Panel_1024x768x75, DefaultLCDCap, 0, 0x60, 0, VCLK78_75,
 	 0x2B, 0x61, 0x2B, 0x61, 0x02, 0x14, 0x0A, 0x02, 0x00,
 	 0x30, 0x10, 0x5A, 0x10, 0x10, 0x0A, 0xC0, 0x28, 0x10},
 /* LCDCap1280x1024x75 */
 	{Panel_1280x1024x75, XGI_LCDDualLink+DefaultLCDCap, StLCDBToA,
-	0x012, 0x90, 0x03, VCLK135_5,
+	 0x90, 0x03, VCLK135_5,
 	 0x54, 0x42, 0x4A, 0x61, 0x02, 0x14, 0x0A, 0x02, 0x00,
 	 0x30, 0x10, 0x5A, 0x10, 0x10, 0x0A, 0xC0, 0x30, 0x10},
 /* LCDCapDefault */
-	{0xFF, DefaultLCDCap, 0, 0x012, 0x88, 0x06, VCLK65_315,
+	{0xFF, DefaultLCDCap, 0, 0x88, 0x06, VCLK65_315,
 	0x6C, 0xC3, 0x35, 0x62, 0x02, 0x14, 0x0A, 0x02, 0x00,
 	0x30, 0x10, 0x5A, 0x10, 0x10, 0x0A, 0xC0, 0x28, 0x10}
 };
 
 static struct XGI330_LCDCapStruct  XGI_LCDCapList[] = {
 /* LCDCap1024x768 */
-	{Panel_1024x768, DefaultLCDCap, 0, 0x012, 0x88, 0x06, VCLK65_315,
+	{Panel_1024x768, DefaultLCDCap, 0, 0x88, 0x06, VCLK65_315,
 	0x6C, 0xC3, 0x35, 0x62, 0x02, 0x14, 0x0A, 0x02, 0x00,
 	0x30, 0x10, 0x5A, 0x10, 0x10, 0x0A, 0xC0, 0x28, 0x10},
 /* LCDCap1280x1024 */
 	{Panel_1280x1024, DefaultLCDCap, StLCDBToA,
-	0x012, 0x70, 0x03, VCLK108_2_315,
+	0x70, 0x03, VCLK108_2_315,
 	0x70, 0x44, 0xF8, 0x2F, 0x02, 0x14, 0x0A, 0x02, 0x00,
 	0x30, 0x10, 0x5A, 0x10, 0x10, 0x0A, 0xC0, 0x30, 0x10},
 /* LCDCap1400x1050 */
 	{Panel_1400x1050, DefaultLCDCap, StLCDBToA,
-	0x012, 0x70, 0x03, VCLK108_2_315,
+	 0x70, 0x03, VCLK108_2_315,
 	 0x70, 0x44, 0xF8, 0x2F, 0x02, 0x14, 0x0A, 0x02, 0x00,
 	 0x30, 0x10, 0x5A, 0x10, 0x10, 0x0A, 0xC0, 0x30, 0x10},
 /* LCDCap1600x1200 */
 	{Panel_1600x1200, DefaultLCDCap, LCDToFull,
-	0x012, 0xC0, 0x03, VCLK162,
+	 0xC0, 0x03, VCLK162,
 	 0x5A, 0x23, 0x5A, 0x23, 0x02, 0x14, 0x0A, 0x02, 0x00,
 	 0x30, 0x10, 0x5A, 0x10, 0x10, 0x0A, 0xC0, 0x30, 0x10},
 /* LCDCap1024x768x75 */
-	{Panel_1024x768x75, DefaultLCDCap, 0, 0x012, 0x60, 0, VCLK78_75,
+	{Panel_1024x768x75, DefaultLCDCap, 0, 0x60, 0, VCLK78_75,
 	 0x2B, 0x61, 0x2B, 0x61, 0x02, 0x14, 0x0A, 0x02, 0x00,
 	 0x30, 0x10, 0x5A, 0x10, 0x10, 0x0A, 0xC0, 0x28, 0x10},
 /* LCDCap1280x1024x75 */
 	{Panel_1280x1024x75, DefaultLCDCap, StLCDBToA,
-	0x012, 0x90, 0x03, VCLK135_5,
+	 0x90, 0x03, VCLK135_5,
 	 0x54, 0x42, 0x4A, 0x61, 0x02, 0x14, 0x0A, 0x02, 0x00,
 	 0x30, 0x10, 0x5A, 0x10, 0x10, 0x0A, 0xC0, 0x30, 0x10},
 /* LCDCapDefault */
-	{0xFF, DefaultLCDCap, 0, 0x012, 0x88, 0x06, VCLK65_315,
+	{0xFF, DefaultLCDCap, 0, 0x88, 0x06, VCLK65_315,
 	0x6C, 0xC3, 0x35, 0x62, 0x02, 0x14, 0x0A, 0x02, 0x00,
 	0x30, 0x10, 0x5A, 0x10, 0x10, 0x0A, 0xC0, 0x28, 0x10}
 };
@@ -2482,36 +2482,8 @@ static struct XGI330_VCLKDataStruct XGI_VBVCLKData[] = {
 	{0xFF, 0x00,   0}  /* End mark */
 };
 
-static unsigned char XGI301TVDelayList[] = {
-	0x22, /* ; 0 ExtNTSCDelay */
-	0x22, /* ; 1 StNTSCDelay */
-	0x22, /* ; 2 ExtPALDelay */
-	0x22, /* ; 3 StPALDelay */
-	0x88, /* ; 4 ExtHiTVDelay(1080i) */
-	0xBB, /* ; 5 StHiTVDelay(1080i) */
-	0x22, /* ; 6 ExtYPbPrDelay(525i) */
-	0x22, /* ; 7 StYPbPrDealy(525i) */
-	0x22, /* ; 8 ExtYPbPrDelay(525p) */
-	0x22, /* ; 9 StYPbPrDealy(525p) */
-	0x22, /* ; A ExtYPbPrDelay(750p) */
-	0x22  /* B StYPbPrDealy(750p) */
-};
-
-static unsigned char XGI301TVDelayList2[] = {
-	0x22, /* ; 0 ExtNTSCDelay */
-	0x22, /* ; 1 StNTSCDelay */
-	0x22, /* ; 2 ExtPALDelay */
-	0x22, /* ; 3 StPALDelay */
-	0x22, /* ; 4 ExtHiTVDelay */
-	0x22, /* ; 5 StHiTVDelay */
-	0x22, /* ; 6 ExtYPbPrDelay(525i) */
-	0x22, /* ; 7 StYPbPrDealy(525i) */
-	0x22, /* ; 8 ExtYPbPrDelay(525p) */
-	0x22, /* ; 9 StYPbPrDealy(525p) */
-	0x22, /* ; A ExtYPbPrDelay(750p) */
-	0x22  /* ; B StYPbPrDealy(750p) */
-};
-
+#define XGI301TVDelay 0x22
+#define XGI301LCDDelay 0x12
 
 static unsigned char TVAntiFlickList[] = {/* NTSCAntiFlicker */
 	0x04, /* ; 0 Adaptive */
-- 
1.7.3.4

