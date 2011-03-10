Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754132Ab1CJVGS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 16:06:18 -0500
Received: from filtteri2.pp.htv.fi ([213.243.153.185]:53031 "EHLO
	filtteri2.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753337Ab1CJVCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 16:02:44 -0500
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        arnaud.patard@rtp-net.org
Subject: [PATCH 06/22] staging: xgifb: eliminate redudant chip type >= XG40 checks
Date: Thu, 10 Mar 2011 23:02:31 +0200
Message-Id: <1299790967-7135-7-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1299790967-7135-1-git-send-email-aaro.koskinen@iki.fi>
References: <1299790967-7135-1-git-send-email-aaro.koskinen@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since all chips supported by the driver are >= XG40, these checks are
redundant and the code can be modified accordingly.

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
---
 drivers/staging/xgifb/XGI_main_26.c |    5 +--
 drivers/staging/xgifb/vb_ext.c      |    8 +---
 drivers/staging/xgifb/vb_init.c     |   70 ++++++++++++++--------------------
 drivers/staging/xgifb/vb_setmode.c  |   32 ++-------------
 drivers/staging/xgifb/vb_table.h    |   23 -----------
 5 files changed, 36 insertions(+), 102 deletions(-)

diff --git a/drivers/staging/xgifb/XGI_main_26.c b/drivers/staging/xgifb/XGI_main_26.c
index b2cb7a3..ed0d554 100644
--- a/drivers/staging/xgifb/XGI_main_26.c
+++ b/drivers/staging/xgifb/XGI_main_26.c
@@ -1502,10 +1502,7 @@ static int XGIfb_get_fix(struct fb_fix_screeninfo *fix, int con,
 	fix->line_length = xgi_video_info.video_linelength;
 	fix->mmio_start = xgi_video_info.mmio_base;
 	fix->mmio_len = xgi_video_info.mmio_size;
-	if (xgi_video_info.chip >= XG40)
-		fix->accel = FB_ACCEL_XGI_XABRE;
-	else
-		fix->accel = FB_ACCEL_XGI_GLAMOUR_2;
+	fix->accel = FB_ACCEL_XGI_XABRE;
 
 	DEBUGPRN("end of get_fix");
 	return 0;
diff --git a/drivers/staging/xgifb/vb_ext.c b/drivers/staging/xgifb/vb_ext.c
index 6863fc2..5cf094a 100644
--- a/drivers/staging/xgifb/vb_ext.c
+++ b/drivers/staging/xgifb/vb_ext.c
@@ -383,13 +383,7 @@ unsigned short XGINew_SenseLCD(struct xgi_hw_device_info *HwDeviceExtension, str
 	/* unsigned short SoftSetting ; */
 	unsigned short temp;
 
-	if ((HwDeviceExtension->jChipType >= XG20) || (HwDeviceExtension->jChipType >= XG40))
-		temp = 0;
-	else
-		temp = XGINew_GetPanelID(pVBInfo);
-
-	if (!temp)
-		temp = XGINew_GetLCDDDCInfo(HwDeviceExtension, pVBInfo);
+	temp = XGINew_GetLCDDDCInfo(HwDeviceExtension, pVBInfo);
 
 	return temp;
 }
diff --git a/drivers/staging/xgifb/vb_init.c b/drivers/staging/xgifb/vb_init.c
index 10c0a3b..86d7333 100644
--- a/drivers/staging/xgifb/vb_init.c
+++ b/drivers/staging/xgifb/vb_init.c
@@ -1382,13 +1382,8 @@ unsigned char XGIInitNew(struct xgi_hw_device_info *HwDeviceExtension)
 
 	printk("8");
 
-	if ((HwDeviceExtension->jChipType >= XG20) || (HwDeviceExtension->jChipType >= XG40)) {
-		for (i = 0x31; i <= 0x3B; i++)
-			XGINew_SetReg1(pVBInfo->P3c4, i, 0);
-	} else {
-		for (i = 0x31; i <= 0x3D; i++)
-			XGINew_SetReg1(pVBInfo->P3c4, i, 0);
-	}
+	for (i = 0x31; i <= 0x3B; i++)
+		XGINew_SetReg1(pVBInfo->P3c4, i, 0);
 	printk("9");
 
 	if (HwDeviceExtension->jChipType == XG42) /* [Hsuan] 2004/08/20 Auto over driver for XG42 */
@@ -1407,7 +1402,6 @@ unsigned char XGIInitNew(struct xgi_hw_device_info *HwDeviceExtension)
 
 	/* 3.SetMemoryClock
 
-	 if (HwDeviceExtension->jChipType >= XG40)
 	 XGINew_RAMType = (int)XGINew_GetXG20DRAMType(HwDeviceExtension, pVBInfo);
 	*/
 
@@ -1467,30 +1461,28 @@ unsigned char XGIInitNew(struct xgi_hw_device_info *HwDeviceExtension)
 
 		printk("13");
 
-		if (HwDeviceExtension->jChipType >= XG40) {
-			/* Set AGP customize registers (in SetDefAGPRegs) Start */
-			for (i = 0x47; i <= 0x4C; i++)
-				XGINew_SetReg1(pVBInfo->P3d4, i, pVBInfo->AGPReg[i - 0x47]);
-
-			for (i = 0x70; i <= 0x71; i++)
-				XGINew_SetReg1(pVBInfo->P3d4, i, pVBInfo->AGPReg[6 + i - 0x70]);
-
-			for (i = 0x74; i <= 0x77; i++)
-				XGINew_SetReg1(pVBInfo->P3d4, i, pVBInfo->AGPReg[8 + i - 0x74]);
-			/* Set AGP customize registers (in SetDefAGPRegs) End */
-			/* [Hsuan]2004/12/14 AGP Input Delay Adjustment on 850 */
-			/*        XGINew_SetReg4(0xcf8 , 0x80000000); */
-			/*        ChipsetID = XGINew_GetReg3(0x0cfc); */
-			/*        if (ChipsetID == 0x25308086) */
-			/*            XGINew_SetReg1(pVBInfo->P3d4, 0x77, 0xF0); */
-
-			HwDeviceExtension->pQueryVGAConfigSpace(HwDeviceExtension, 0x50, 0, &Temp); /* Get */
-			Temp >>= 20;
-			Temp &= 0xF;
-
-			if (Temp == 1)
-				XGINew_SetReg1(pVBInfo->P3d4, 0x48, 0x20); /* CR48 */
-		}
+		/* Set AGP customize registers (in SetDefAGPRegs) Start */
+		for (i = 0x47; i <= 0x4C; i++)
+			XGINew_SetReg1(pVBInfo->P3d4, i, pVBInfo->AGPReg[i - 0x47]);
+
+		for (i = 0x70; i <= 0x71; i++)
+			XGINew_SetReg1(pVBInfo->P3d4, i, pVBInfo->AGPReg[6 + i - 0x70]);
+
+		for (i = 0x74; i <= 0x77; i++)
+			XGINew_SetReg1(pVBInfo->P3d4, i, pVBInfo->AGPReg[8 + i - 0x74]);
+		/* Set AGP customize registers (in SetDefAGPRegs) End */
+		/* [Hsuan]2004/12/14 AGP Input Delay Adjustment on 850 */
+		/*        XGINew_SetReg4(0xcf8 , 0x80000000); */
+		/*        ChipsetID = XGINew_GetReg3(0x0cfc); */
+		/*        if (ChipsetID == 0x25308086) */
+		/*            XGINew_SetReg1(pVBInfo->P3d4, 0x77, 0xF0); */
+
+		HwDeviceExtension->pQueryVGAConfigSpace(HwDeviceExtension, 0x50, 0, &Temp); /* Get */
+		Temp >>= 20;
+		Temp &= 0xF;
+
+		if (Temp == 1)
+			XGINew_SetReg1(pVBInfo->P3d4, 0x48, 0x20); /* CR48 */
 		printk("14");
 	} /* != XG20 */
 
@@ -1529,7 +1521,6 @@ unsigned char XGIInitNew(struct xgi_hw_device_info *HwDeviceExtension)
 	printk("17");
 
 	/*
-	 if (HwDeviceExtension->jChipType >= XG40)
 	 SetPowerConsume (HwDeviceExtension, pVBInfo->P3c4);	*/
 
 	if (HwDeviceExtension->jChipType < XG20) { /* kuku 2004/06/25 */
@@ -1578,16 +1569,13 @@ unsigned char XGIInitNew(struct xgi_hw_device_info *HwDeviceExtension)
 	}
 	printk("19");
 
-	if (HwDeviceExtension->jChipType >= XG40) {
-		if (HwDeviceExtension->jChipType >= XG40)
-			XGINew_RAMType = (int) XGINew_GetXG20DRAMType(HwDeviceExtension, pVBInfo);
+	XGINew_RAMType = (int) XGINew_GetXG20DRAMType(HwDeviceExtension, pVBInfo);
 
-		XGINew_SetDRAMDefaultRegister340(HwDeviceExtension, pVBInfo->P3d4, pVBInfo);
+	XGINew_SetDRAMDefaultRegister340(HwDeviceExtension, pVBInfo->P3d4, pVBInfo);
 
-		printk("20");
-		XGINew_SetDRAMSize_340(HwDeviceExtension, pVBInfo);
-		printk("21");
-	} /* XG40 */
+	printk("20");
+	XGINew_SetDRAMSize_340(HwDeviceExtension, pVBInfo);
+	printk("21");
 
 	printk("22");
 
diff --git a/drivers/staging/xgifb/vb_setmode.c b/drivers/staging/xgifb/vb_setmode.c
index 4d56963..c9a97e6 100644
--- a/drivers/staging/xgifb/vb_setmode.c
+++ b/drivers/staging/xgifb/vb_setmode.c
@@ -74,18 +74,8 @@ void InitTo330Pointer(unsigned char ChipType, struct vb_device_info *pVBInfo)
 	/* XGINew_UBLCDDataTable = (struct XGI_LCDDataTablStruct *) XGI_LCDDataTable; */
 	/* XGINew_UBTVDataTable = (XGI_TVDataTablStruct *) XGI_TVDataTable; */
 
-	if (ChipType >= XG40) {
-		pVBInfo->MCLKData
-			= (struct XGI_MCLKDataStruct *) XGI340New_MCLKData;
-		pVBInfo->ECLKData
-			= (struct XGI_ECLKDataStruct *) XGI340_ECLKData;
-	} else {
-		pVBInfo->MCLKData
-			= (struct XGI_MCLKDataStruct *) XGI330New_MCLKData;
-		pVBInfo->ECLKData
-			= (struct XGI_ECLKDataStruct *) XGI330_ECLKData;
-	}
-
+	pVBInfo->MCLKData = (struct XGI_MCLKDataStruct *) XGI340New_MCLKData;
+	pVBInfo->ECLKData = (struct XGI_ECLKDataStruct *) XGI340_ECLKData;
 	pVBInfo->VCLKData = (struct XGI_VCLKDataStruct *) XGI_VCLKData;
 	pVBInfo->VBVCLKData = (struct XGI_VBVCLKDataStruct *) XGI_VBVCLKData;
 	pVBInfo->ScreenOffset = XGI330_ScreenOffset;
@@ -3291,15 +3281,7 @@ static void XGI_UpdateModeInfo(struct xgi_hw_device_info *HwDeviceExtension,
 		if (!(temp & 0x20)) {
 			temp = XGINew_GetReg1(pVBInfo->P3d4, 0x17);
 			if (temp & 0x80) {
-				if ((HwDeviceExtension->jChipType >= XG20)
-						|| (HwDeviceExtension->jChipType
-								>= XG40))
-					temp = XGINew_GetReg1(pVBInfo->P3d4,
-							0x53);
-				else
-					temp = XGINew_GetReg1(pVBInfo->P3d4,
-							0x63);
-
+				temp = XGINew_GetReg1(pVBInfo->P3d4, 0x53);
 				if (!(temp & 0x40))
 					tempcl |= ActiveCRT1;
 			}
@@ -3377,7 +3359,7 @@ void XGI_GetVGAType(struct xgi_hw_device_info *HwDeviceExtension,
 	/*
 	if ( HwDeviceExtension->jChipType >= XG20 ) {
 		pVBInfo->Set_VGAType = XG20;
-	} else if (HwDeviceExtension->jChipType >= XG40) {
+	} else {
 		pVBInfo->Set_VGAType = VGA_XGI340;
 	}
 	*/
@@ -8330,14 +8312,10 @@ unsigned char XGISetModeNew(struct xgi_hw_device_info *HwDeviceExtension,
 		pVBInfo->IF_DEF_HiVision = 0;
 		pVBInfo->IF_DEF_CRT2Monitor = 0;
 		pVBInfo->VBType = 0; /*set VBType default 0*/
-	} else if (HwDeviceExtension->jChipType >= XG40) {
-		pVBInfo->IF_DEF_YPbPr = 1;
-		pVBInfo->IF_DEF_HiVision = 1;
-		pVBInfo->IF_DEF_CRT2Monitor = 1;
 	} else {
 		pVBInfo->IF_DEF_YPbPr = 1;
 		pVBInfo->IF_DEF_HiVision = 1;
-		pVBInfo->IF_DEF_CRT2Monitor = 0;
+		pVBInfo->IF_DEF_CRT2Monitor = 1;
 	}
 
 	pVBInfo->P3c4 = pVBInfo->BaseAddr + 0x14;
diff --git a/drivers/staging/xgifb/vb_table.h b/drivers/staging/xgifb/vb_table.h
index 78b1c79..d71cd55 100644
--- a/drivers/staging/xgifb/vb_table.h
+++ b/drivers/staging/xgifb/vb_table.h
@@ -1,17 +1,5 @@
 #define  Tap4
 
-
-static struct XGI_MCLKDataStruct XGI330New_MCLKData[] =
-{
- { 0x5c,0x23,0x01,166},
- { 0x5c,0x23,0x01,166},
- { 0x7C,0x08,0x80,200},
- { 0x79,0x06,0x80,250},
- { 0x29,0x01,0x81,300},
- { 0x29,0x01,0x81,300},
- { 0x29,0x01,0x81,300},
- { 0x29,0x01,0x81,300}
-};
 //yilin modify for xgi20
 static struct XGI_MCLKDataStruct XGI340New_MCLKData[] =
 {
@@ -37,17 +25,6 @@ static struct XGI_MCLKDataStruct XGI27New_MCLKData[] =
  { 0x5c,0x23,0x01,166}
 };
 
-static struct XGI_ECLKDataStruct XGI330_ECLKData[] =
-{
- { 0x7c,0x08,0x01,200},
- { 0x7c,0x08,0x01,200},
- { 0x7C,0x08,0x80,200},
- { 0x79,0x06,0x80,250},
- { 0x29,0x01,0x81,300},
- { 0x29,0x01,0x81,300},
- { 0x29,0x01,0x81,300},
- { 0x29,0x01,0x81,300}
-};
 //yilin modify for xgi20
 static struct XGI_ECLKDataStruct XGI340_ECLKData[] =
 {
-- 
1.5.6.5

