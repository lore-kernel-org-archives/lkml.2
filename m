Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755027Ab2FMWWb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 18:22:31 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:44715 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754956Ab2FMWWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 18:22:11 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1/tRbsDZMTtFdnbS40GcxY0aFbUm5RCBit0gdLabV
	HUKqOcUph1/kd9
From: Peter Huewe <peterhuewe@gmx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Arnaud Patard <arnaud.patard@rtp-net.org>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Peter Huewe <peterhuewe@gmx.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 14/14] staging/xgifb: Cleanup vb_device_info struct
Date: Thu, 14 Jun 2012 00:21:52 +0200
Message-Id: <1339626112-20671-14-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1339626112-20671-1-git-send-email-peterhuewe@gmx.de>
References: <1339626112-20671-1-git-send-email-peterhuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch cleans up the vb_device_info struct and the related
functions.
The cleanup decreases the size of the compiled module by
about 10kB.

== Remove fields in vb_device_info that are never read: ==
pOutputSelect
pRGBSenseData
pRGBSenseData2
pVideoSenseData
pVideoSenseData2
pYCSenseData
pYCSenseData2
CR49
pXGINew_I2CDefinition
pCR2E
pCR2F
pCR46
pCR47
pCRD0
pCRDE
pSR40
pSR41
pCR47

=== Remove the corresponding 'constants' ===
XGI330_RGBSenseData
XGI330_RGBSenseData2
XGI330_VideoSenseData
XGI330_VideoSenseData2
XGI330_YCSenseData
XGI330_YCSenseData2
XGI330_CR49
XG40_I2CDefinition
XG21_CR2E
XG21_CR2F
XG21_CR46
XG21_CR47
XG27_CRD0
XG27_CRDE
XGI330_OutputSelect

== Remove 'constant fields' and replace constant value with #define ==
pSR07 = XGI330_SR07 -> 0x18
pSR1F = XGI330_SR1F -> 0
pSR23 = XGI330_SR23 -> 0xf6
pSR24 = XGI330_SR24 -> 0x0d
pSR33 = XGI330_SR33 ->0
pCRT2Data_1_2 = XGI330_CRT2Data_1_2 -> 0
pCRT2Data_4_D = XGI330_CRT2Data_4_D -> 0
pCRT2Data_4_E = XGI330_CRT2Data_4_E -> 0
pCRT2Data_4_10 = XGI330_CRT2Data_4_10 -> 0x80
pSR36 = XG27_SR36 -> 0x30
pCR8F = &XG27_CR8F -> 0x0C
pSR40 = XG27_SR40 -> 0x04
pSR41 = XG27_SR41 ->0x00
pSR31 = XGI330_SR31 -> 0xc0
pSR32 = XGI330_SR32 -> 0xc0
SR25 = XGI330_sr25 -> 0 (we only use XGI330_sr25[0])

== Constant fields with 'dead' code: ==
pSoftSetting is set to XGI330_SoftSetting = 0x30
-> if (*pVBInfo->pSoftSetting & SoftDRAMType) is never true since
SoftDRAMType = 0x80
-> if (*pVBInfo->pSoftSetting & ModeSoftSetting) is never true since
ModeSoftSetting = 0x04
--> remove the code, remove pSoftSetting, remove XGI330_SoftSetting

pDVOSetting is set to XG21_DVOSetting = 0
-> if (((*pVBInfo->pDVOSetting) & 0xC0) == 0xC0) is never true
--> remove the code, remove pDVOSetting, remove XG21_DVOSetting

pXGINew_DRAMTypeDefinition is set to &XG40_DRAMTypeDefinition 0xFF
-> if (*pVBInfo->pXGINew_DRAMTypeDefinition != 0x0C) is always true
--> remove the if and remove pXGINew_DRAMTypeDefinition
remove XG40_DRAMTypeDefinition

== Replace pointer to unsigned char with unsigned char variable
and assign value of referenced pointer: ==
pSR21 -> SR21, remove XGI330_SR21
pSR22 -> SR22, remove XGI330_SR22
pXGINew_CR97 -> XGINew_CR97, remove XG20_CR97, XG27_CR97 and Z11m_CR97

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/xgifb/vb_def.h     |   19 +++++++
 drivers/staging/xgifb/vb_init.c    |   96 ++++++++++++++----------------------
 drivers/staging/xgifb/vb_setmode.c |   59 ++--------------------
 drivers/staging/xgifb/vb_struct.h  |   43 ++---------------
 drivers/staging/xgifb/vb_table.h   |   49 ------------------
 5 files changed, 67 insertions(+), 199 deletions(-)

diff --git a/drivers/staging/xgifb/vb_def.h b/drivers/staging/xgifb/vb_def.h
index c731793..5b987a6 100644
--- a/drivers/staging/xgifb/vb_def.h
+++ b/drivers/staging/xgifb/vb_def.h
@@ -264,4 +264,23 @@
 #define RES1280x960x85       0x46
 #define RES1280x960x120      0x47
 
+
+#define XG27_CR8F 0x0C
+#define XG27_SR36 0x30
+#define XG27_SR40 0x04
+#define XG27_SR41 0x00
+#define XG40_CRCF 0x13
+#define XGI330_CRT2Data_1_2 0
+#define XGI330_CRT2Data_4_D 0
+#define XGI330_CRT2Data_4_E 0
+#define XGI330_CRT2Data_4_10 0x80
+#define XGI330_SR07 0x18
+#define XGI330_SR1F 0
+#define XGI330_SR23 0xf6
+#define XGI330_SR24 0x0d
+#define XGI330_SR25 0
+#define XGI330_SR31 0xc0
+#define XGI330_SR32 0x11
+#define XGI330_SR33 0
+
 #endif
diff --git a/drivers/staging/xgifb/vb_init.c b/drivers/staging/xgifb/vb_init.c
index 944653d..a3d54b7 100644
--- a/drivers/staging/xgifb/vb_init.c
+++ b/drivers/staging/xgifb/vb_init.c
@@ -5,7 +5,6 @@
 #include "vb_def.h"
 #include "vb_util.h"
 #include "vb_setmode.h"
-
 static const unsigned short XGINew_DDRDRAM_TYPE340[4][2] = {
 	{ 16, 0x45},
 	{  8, 0x35},
@@ -35,21 +34,12 @@ XGINew_GetXG20DRAMType(struct xgi_hw_device_info *HwDeviceExtension,
 	unsigned char data, temp;
 
 	if (HwDeviceExtension->jChipType < XG20) {
-		if (*pVBInfo->pSoftSetting & SoftDRAMType) {
-			data = *pVBInfo->pSoftSetting & 0x07;
-			return data;
-		} else {
-			data = xgifb_reg_get(pVBInfo->P3c4, 0x39) & 0x02;
-			if (data == 0)
-				data = (xgifb_reg_get(pVBInfo->P3c4, 0x3A) &
-				       0x02) >> 1;
-			return data;
-		}
+		data = xgifb_reg_get(pVBInfo->P3c4, 0x39) & 0x02;
+		if (data == 0)
+			data = (xgifb_reg_get(pVBInfo->P3c4, 0x3A) &
+				   0x02) >> 1;
+		return data;
 	} else if (HwDeviceExtension->jChipType == XG27) {
-		if (*pVBInfo->pSoftSetting & SoftDRAMType) {
-			data = *pVBInfo->pSoftSetting & 0x07;
-			return data;
-		}
 		temp = xgifb_reg_get(pVBInfo->P3c4, 0x3B);
 		/* SR3B[7][3]MAA15 MAA11 (Power on Trapping) */
 		if (((temp & 0x88) == 0x80) || ((temp & 0x88) == 0x08))
@@ -92,13 +82,11 @@ static void XGINew_DDR1x_MRS_340(unsigned long P3c4,
 	xgifb_reg_set(P3c4, 0x16, 0x00);
 	xgifb_reg_set(P3c4, 0x16, 0x80);
 
-	if (*pVBInfo->pXGINew_DRAMTypeDefinition != 0x0C) { /* Samsung F Die */
-		mdelay(3);
-		xgifb_reg_set(P3c4, 0x18, 0x00);
-		xgifb_reg_set(P3c4, 0x19, 0x20);
-		xgifb_reg_set(P3c4, 0x16, 0x00);
-		xgifb_reg_set(P3c4, 0x16, 0x80);
-	}
+	mdelay(3);
+	xgifb_reg_set(P3c4, 0x18, 0x00);
+	xgifb_reg_set(P3c4, 0x19, 0x20);
+	xgifb_reg_set(P3c4, 0x16, 0x00);
+	xgifb_reg_set(P3c4, 0x16, 0x80);
 
 	udelay(60);
 	xgifb_reg_set(P3c4,
@@ -172,7 +160,7 @@ static void XGINew_DDRII_Bootup_XG27(
 
 	/* Set Double Frequency */
 	/* xgifb_reg_set(P3d4, 0x97, 0x11); *//* CR97 */
-	xgifb_reg_set(P3d4, 0x97, *pVBInfo->pXGINew_CR97); /* CR97 */
+	xgifb_reg_set(P3d4, 0x97, pVBInfo->XGINew_CR97); /* CR97 */
 
 	udelay(200);
 
@@ -532,7 +520,7 @@ static void XGINew_SetDRAMDefaultRegister340(
 		      pVBInfo->CR40[0][pVBInfo->ram_type]); /* CR41 */
 
 	if (HwDeviceExtension->jChipType == XG27)
-		xgifb_reg_set(P3d4, 0x8F, *pVBInfo->pCR8F); /* CR8F */
+		xgifb_reg_set(P3d4, 0x8F, XG27_CR8F); /* CR8F */
 
 	for (j = 0; j <= 6; j++) /* CR90 - CR96 */
 		xgifb_reg_set(P3d4, (0x90 + j),
@@ -555,7 +543,7 @@ static void XGINew_SetDRAMDefaultRegister340(
 
 	xgifb_reg_set(P3d4, 0x83, 0x09); /* CR83 */
 	xgifb_reg_set(P3d4, 0x87, 0x00); /* CR87 */
-	xgifb_reg_set(P3d4, 0xCF, *pVBInfo->pCRCF); /* CRCF */
+	xgifb_reg_set(P3d4, 0xCF, XG40_CRCF); /* CRCF */
 	if (pVBInfo->ram_type) {
 		/* xgifb_reg_set(P3c4, 0x17, 0xC0); */ /* SR17 DDRII */
 		xgifb_reg_set(P3c4, 0x17, 0x80); /* SR17 DDRII */
@@ -1075,13 +1063,9 @@ static void XGINew_ChkSenseStatus(struct xgi_hw_device_info *HwDeviceExtension,
 		CR3CData = xgifb_reg_get(pVBInfo->P3d4, 0x3c);
 		if (!(CR3CData & DisplayDeviceFromCMOS)) {
 			tempcx = 0x1FF0;
-			if (*pVBInfo->pSoftSetting & ModeSoftSetting)
-				tempbx = 0x1FF0;
 		}
 	} else {
 		tempcx = 0x1FF0;
-		if (*pVBInfo->pSoftSetting & ModeSoftSetting)
-			tempbx = 0x1FF0;
 	}
 
 	tempbx &= tempcx;
@@ -1425,7 +1409,7 @@ unsigned char XGIInitNew(struct pci_dev *pdev)
 	printk("10");
 
 	if (HwDeviceExtension->jChipType >= XG20)
-		xgifb_reg_set(pVBInfo->P3d4, 0x97, *pVBInfo->pXGINew_CR97);
+		xgifb_reg_set(pVBInfo->P3d4, 0x97, pVBInfo->XGINew_CR97);
 
 	/* 3.SetMemoryClock
 
@@ -1435,20 +1419,20 @@ unsigned char XGIInitNew(struct pci_dev *pdev)
 	printk("11");
 
 	/* 4.SetDefExt1Regs begin */
-	xgifb_reg_set(pVBInfo->P3c4, 0x07, *pVBInfo->pSR07);
+	xgifb_reg_set(pVBInfo->P3c4, 0x07, XGI330_SR07);
 	if (HwDeviceExtension->jChipType == XG27) {
-		xgifb_reg_set(pVBInfo->P3c4, 0x40, *pVBInfo->pSR40);
-		xgifb_reg_set(pVBInfo->P3c4, 0x41, *pVBInfo->pSR41);
+		xgifb_reg_set(pVBInfo->P3c4, 0x40, XG27_SR40);
+		xgifb_reg_set(pVBInfo->P3c4, 0x41, XG27_SR41);
 	}
 	xgifb_reg_set(pVBInfo->P3c4, 0x11, 0x0F);
-	xgifb_reg_set(pVBInfo->P3c4, 0x1F, *pVBInfo->pSR1F);
+	xgifb_reg_set(pVBInfo->P3c4, 0x1F, XGI330_SR1F);
 	/* xgifb_reg_set(pVBInfo->P3c4, 0x20, 0x20); */
 	/* alan, 2001/6/26 Frame buffer can read/write SR20 */
 	xgifb_reg_set(pVBInfo->P3c4, 0x20, 0xA0);
 	/* Hsuan, 2006/01/01 H/W request for slow corner chip */
 	xgifb_reg_set(pVBInfo->P3c4, 0x36, 0x70);
 	if (HwDeviceExtension->jChipType == XG27) /* Alan 12/07/2006 */
-		xgifb_reg_set(pVBInfo->P3c4, 0x36, *pVBInfo->pSR36);
+		xgifb_reg_set(pVBInfo->P3c4, 0x36, XG27_SR36);
 
 	/* SR11 = 0x0F; */
 	/* xgifb_reg_set(pVBInfo->P3c4, 0x11, SR11); */
@@ -1534,9 +1518,9 @@ unsigned char XGIInitNew(struct pci_dev *pdev)
 	} /* != XG20 */
 
 	/* Set PCI */
-	xgifb_reg_set(pVBInfo->P3c4, 0x23, *pVBInfo->pSR23);
-	xgifb_reg_set(pVBInfo->P3c4, 0x24, *pVBInfo->pSR24);
-	xgifb_reg_set(pVBInfo->P3c4, 0x25, pVBInfo->SR25[0]);
+	xgifb_reg_set(pVBInfo->P3c4, 0x23, XGI330_SR23);
+	xgifb_reg_set(pVBInfo->P3c4, 0x24, XGI330_SR24);
+	xgifb_reg_set(pVBInfo->P3c4, 0x25, XGI330_SR25);
 	printk("15");
 
 	if (HwDeviceExtension->jChipType < XG20) { /* kuku 2004/06/25 */
@@ -1550,8 +1534,7 @@ unsigned char XGIInitNew(struct pci_dev *pdev)
 		temp = (unsigned char) ((temp1 >> 4) & 0x0F);
 
 		xgifb_reg_set(pVBInfo->Part1Port,
-			      0x02,
-			      (*pVBInfo->pCRT2Data_1_2));
+			      0x02, XGI330_CRT2Data_1_2);
 
 		printk("16");
 
@@ -1565,15 +1548,15 @@ unsigned char XGIInitNew(struct pci_dev *pdev)
 		/* Not DDR */
 		xgifb_reg_set(pVBInfo->P3c4,
 			      0x31,
-			      (*pVBInfo->pSR31 & 0x3F) | 0x40);
+			      (XGI330_SR31 & 0x3F) | 0x40);
 		xgifb_reg_set(pVBInfo->P3c4,
 			      0x32,
-			      (*pVBInfo->pSR32 & 0xFC) | 0x01);
+			      (XGI330_SR32 & 0xFC) | 0x01);
 	} else {
-		xgifb_reg_set(pVBInfo->P3c4, 0x31, *pVBInfo->pSR31);
-		xgifb_reg_set(pVBInfo->P3c4, 0x32, *pVBInfo->pSR32);
+		xgifb_reg_set(pVBInfo->P3c4, 0x31, XGI330_SR31);
+		xgifb_reg_set(pVBInfo->P3c4, 0x32, XGI330_SR32);
 	}
-	xgifb_reg_set(pVBInfo->P3c4, 0x33, *pVBInfo->pSR33);
+	xgifb_reg_set(pVBInfo->P3c4, 0x33, XGI330_SR33);
 	printk("17");
 
 	/*
@@ -1584,14 +1567,11 @@ unsigned char XGIInitNew(struct pci_dev *pdev)
 			if (pVBInfo->IF_DEF_LVDS == 0) {
 				xgifb_reg_set(pVBInfo->Part2Port, 0x00, 0x1C);
 				xgifb_reg_set(pVBInfo->Part4Port,
-					      0x0D,
-					      *pVBInfo->pCRT2Data_4_D);
+					      0x0D, XGI330_CRT2Data_4_D);
 				xgifb_reg_set(pVBInfo->Part4Port,
-					      0x0E,
-					      *pVBInfo->pCRT2Data_4_E);
+					      0x0E, XGI330_CRT2Data_4_E);
 				xgifb_reg_set(pVBInfo->Part4Port,
-					      0x10,
-					      *pVBInfo->pCRT2Data_4_10);
+					      0x10, XGI330_CRT2Data_4_10);
 				xgifb_reg_set(pVBInfo->Part4Port, 0x0F, 0x3F);
 			}
 
@@ -1651,12 +1631,12 @@ unsigned char XGIInitNew(struct pci_dev *pdev)
 		AGP = 0;
 
 	if (AGP == 0)
-		*pVBInfo->pSR21 &= 0xEF;
+		pVBInfo->SR21 &= 0xEF;
 
-	xgifb_reg_set(pVBInfo->P3c4, 0x21, *pVBInfo->pSR21);
+	xgifb_reg_set(pVBInfo->P3c4, 0x21, pVBInfo->SR21);
 	if (AGP == 1)
-		*pVBInfo->pSR22 &= 0x20;
-	xgifb_reg_set(pVBInfo->P3c4, 0x22, *pVBInfo->pSR22);
+		pVBInfo->SR22 &= 0x20;
+	xgifb_reg_set(pVBInfo->P3c4, 0x22, pVBInfo->SR22);
 	*/
 	/* base = 0x80000000; */
 	/* OutPortLong(0xcf8, base); */
@@ -1664,12 +1644,12 @@ unsigned char XGIInitNew(struct pci_dev *pdev)
 	/* if (Temp == 0x1039) { */
 	xgifb_reg_set(pVBInfo->P3c4,
 		      0x22,
-		      (unsigned char) ((*pVBInfo->pSR22) & 0xFE));
+		      (unsigned char) ((pVBInfo->SR22) & 0xFE));
 	/* } else { */
-	/*	xgifb_reg_set(pVBInfo->P3c4, 0x22, *pVBInfo->pSR22); */
+	/*	xgifb_reg_set(pVBInfo->P3c4, 0x22, pVBInfo->SR22); */
 	/* } */
 
-	xgifb_reg_set(pVBInfo->P3c4, 0x21, *pVBInfo->pSR21);
+	xgifb_reg_set(pVBInfo->P3c4, 0x21, pVBInfo->SR21);
 
 	printk("23");
 
diff --git a/drivers/staging/xgifb/vb_setmode.c b/drivers/staging/xgifb/vb_setmode.c
index 183afe4..b1713d3 100644
--- a/drivers/staging/xgifb/vb_setmode.c
+++ b/drivers/staging/xgifb/vb_setmode.c
@@ -38,9 +38,6 @@ void InitTo330Pointer(unsigned char ChipType, struct vb_device_info *pVBInfo)
 	pVBInfo->ModeResInfo
 			= (struct SiS_ModeResInfo_S *) XGI330_ModeResInfo;
 
-	pVBInfo->pOutputSelect = &XGI330_OutputSelect;
-	pVBInfo->pSoftSetting = &XGI330_SoftSetting;
-	pVBInfo->pSR07 = &XGI330_SR07;
 	pVBInfo->LCDResInfo = 0;
 	pVBInfo->LCDTypeInfo = 0;
 	pVBInfo->LCDInfo = 0;
@@ -49,36 +46,15 @@ void InitTo330Pointer(unsigned char ChipType, struct vb_device_info *pVBInfo)
 
 	pVBInfo->SR15 = XGI340_SR13;
 	pVBInfo->CR40 = XGI340_cr41;
-	pVBInfo->SR25 = XGI330_sr25;
-	pVBInfo->pSR31 = &XGI330_sr31;
-	pVBInfo->pSR32 = &XGI330_sr32;
 	pVBInfo->CR6B = XGI340_CR6B;
 	pVBInfo->CR6E = XGI340_CR6E;
 	pVBInfo->CR6F = XGI340_CR6F;
 	pVBInfo->CR89 = XGI340_CR89;
 	pVBInfo->AGPReg = XGI340_AGPReg;
 	pVBInfo->SR16 = XGI340_SR16;
-	pVBInfo->pCRCF = &XG40_CRCF;
-	pVBInfo->pXGINew_DRAMTypeDefinition = &XG40_DRAMTypeDefinition;
-
-	pVBInfo->CR49 = XGI330_CR49;
-	pVBInfo->pSR1F = &XGI330_SR1F;
-	pVBInfo->pSR21 = &XGI330_SR21;
-	pVBInfo->pSR22 = &XGI330_SR22;
-	pVBInfo->pSR23 = &XGI330_SR23;
-	pVBInfo->pSR24 = &XGI330_SR24;
-	pVBInfo->pSR33 = &XGI330_SR33;
-
-	pVBInfo->pCRT2Data_1_2 = &XGI330_CRT2Data_1_2;
-	pVBInfo->pCRT2Data_4_D = &XGI330_CRT2Data_4_D;
-	pVBInfo->pCRT2Data_4_E = &XGI330_CRT2Data_4_E;
-	pVBInfo->pCRT2Data_4_10 = &XGI330_CRT2Data_4_10;
-	pVBInfo->pRGBSenseData = &XGI330_RGBSenseData;
-	pVBInfo->pVideoSenseData = &XGI330_VideoSenseData;
-	pVBInfo->pYCSenseData = &XGI330_YCSenseData;
-	pVBInfo->pRGBSenseData2 = &XGI330_RGBSenseData2;
-	pVBInfo->pVideoSenseData2 = &XGI330_VideoSenseData2;
-	pVBInfo->pYCSenseData2 = &XGI330_YCSenseData2;
+
+	pVBInfo->SR21 = 0xa3;
+	pVBInfo->SR22 = 0xfb;
 
 	pVBInfo->NTSCTiming = XGI330_NTSCTiming;
 	pVBInfo->PALTiming = XGI330_PALTiming;
@@ -105,38 +81,22 @@ void InitTo330Pointer(unsigned char ChipType, struct vb_device_info *pVBInfo)
 	else
 		pVBInfo->LCDCapList = XGI_LCDCapList;
 
-	pVBInfo->pXGINew_I2CDefinition = &XG40_I2CDefinition;
-
 	if (ChipType >= XG20)
-		pVBInfo->pXGINew_CR97 = &XG20_CR97;
+		pVBInfo->XGINew_CR97 = 0x10;
 
 	if (ChipType == XG27) {
 		unsigned char temp;
 		pVBInfo->MCLKData
 			= (struct SiS_MCLKData *) XGI27New_MCLKData;
 		pVBInfo->CR40 = XGI27_cr41;
-		pVBInfo->pXGINew_CR97 = &XG27_CR97;
-		pVBInfo->pSR36 = &XG27_SR36;
-		pVBInfo->pCR8F = &XG27_CR8F;
-		pVBInfo->pCRD0 = XG27_CRD0;
-		pVBInfo->pCRDE = XG27_CRDE;
-		pVBInfo->pSR40 = &XG27_SR40;
-		pVBInfo->pSR41 = &XG27_SR41;
+		pVBInfo->XGINew_CR97 = 0xc1;
 		pVBInfo->SR15 = XG27_SR13;
 
 		/*Z11m DDR*/
 		temp = xgifb_reg_get(pVBInfo->P3c4, 0x3B);
 		/* SR3B[7][3]MAA15 MAA11 (Power on Trapping) */
 		if (((temp & 0x88) == 0x80) || ((temp & 0x88) == 0x08))
-			pVBInfo->pXGINew_CR97 = &Z11m_CR97;
-	}
-
-	if (ChipType >= XG20) {
-		pVBInfo->pDVOSetting = &XG21_DVOSetting;
-		pVBInfo->pCR2E = &XG21_CR2E;
-		pVBInfo->pCR2F = &XG21_CR2F;
-		pVBInfo->pCR46 = &XG21_CR46;
-		pVBInfo->pCR47 = &XG21_CR47;
+			pVBInfo->XGINew_CR97 = 0x80;
 	}
 
 }
@@ -783,13 +743,6 @@ static void xgifb_set_lcd(int chip_id,
 		}
 	}
 
-	if (((*pVBInfo->pDVOSetting) & 0xC0) == 0xC0) {
-		xgifb_reg_set(pVBInfo->P3d4, 0x2E, *pVBInfo->pCR2E);
-		xgifb_reg_set(pVBInfo->P3d4, 0x2F, *pVBInfo->pCR2F);
-		xgifb_reg_set(pVBInfo->P3d4, 0x46, *pVBInfo->pCR46);
-		xgifb_reg_set(pVBInfo->P3d4, 0x47, *pVBInfo->pCR47);
-	}
-
 	if (chip_id == XG27) {
 		XGI_SetXG27FPBits(pVBInfo);
 	} else {
diff --git a/drivers/staging/xgifb/vb_struct.h b/drivers/staging/xgifb/vb_struct.h
index b54488b..aea760a 100644
--- a/drivers/staging/xgifb/vb_struct.h
+++ b/drivers/staging/xgifb/vb_struct.h
@@ -191,45 +191,11 @@ struct vb_device_info {
 	unsigned char (*SR15)[8];
 	unsigned char (*CR40)[8];
 
-	unsigned char  *pSoftSetting;
-	unsigned char  *pOutputSelect;
-
-	unsigned short *pRGBSenseData;
-	unsigned short *pRGBSenseData2; /*301b*/
-	unsigned short *pVideoSenseData;
-	unsigned short *pVideoSenseData2;
-	unsigned short *pYCSenseData;
-	unsigned short *pYCSenseData2;
-
-	unsigned char  *pSR07;
-	unsigned char  *CR49;
-	unsigned char  *pSR1F;
 	unsigned char  *AGPReg;
 	unsigned char  *SR16;
-	unsigned char  *pSR21;
-	unsigned char  *pSR22;
-	unsigned char  *pSR23;
-	unsigned char  *pSR24;
-	unsigned char  *SR25;
-	unsigned char  *pSR31;
-	unsigned char  *pSR32;
-	unsigned char  *pSR33;
-	unsigned char  *pSR36;      /* alan 12/07/2006 */
-	unsigned char  *pCRCF;
-	unsigned char  *pCRD0;      /* alan 12/07/2006 */
-	unsigned char  *pCRDE;      /* alan 12/07/2006 */
-	unsigned char  *pCR8F;      /* alan 12/07/2006 */
-	unsigned char  *pSR40;      /* alan 12/07/2006 */
-	unsigned char  *pSR41;      /* alan 12/07/2006 */
-	unsigned char  *pDVOSetting;
-	unsigned char  *pCR2E;
-	unsigned char  *pCR2F;
-	unsigned char  *pCR46;
-	unsigned char  *pCR47;
-	unsigned char  *pCRT2Data_1_2;
-	unsigned char  *pCRT2Data_4_D;
-	unsigned char  *pCRT2Data_4_E;
-	unsigned char  *pCRT2Data_4_10;
+	unsigned char  SR21;
+	unsigned char  SR22;
+	unsigned char  SR25;
 	struct SiS_MCLKData  *MCLKData;
 	struct XGI_ECLKDataStruct  *ECLKData;
 
@@ -249,8 +215,7 @@ struct vb_device_info {
 	unsigned char   *Ren750pGroup3;
 	unsigned char   *ScreenOffset;
 	unsigned char   *pXGINew_DRAMTypeDefinition;
-	unsigned char   *pXGINew_I2CDefinition ;
-	unsigned char   *pXGINew_CR97 ;
+	unsigned char   XGINew_CR97;
 
 	struct XGI330_LCDCapStruct  *LCDCapList;
 
diff --git a/drivers/staging/xgifb/vb_table.h b/drivers/staging/xgifb/vb_table.h
index 16bb831..75da7c3 100644
--- a/drivers/staging/xgifb/vb_table.h
+++ b/drivers/staging/xgifb/vb_table.h
@@ -130,13 +130,6 @@ static unsigned char XGI340_AGPReg[12] = {
 
 static unsigned char XGI340_SR16[4] = {0x03, 0x83, 0x03, 0x83};
 
-static unsigned char XGI330_sr25[2];
-static unsigned char XGI330_sr31 = 0xc0;
-static unsigned char XGI330_sr32 = 0x11;
-static unsigned char XGI330_SR33;
-static unsigned char XG40_CRCF = 0x13;
-static unsigned char XG40_DRAMTypeDefinition = 0xFF ;
-
 static struct XGI_ExtStruct XGI330_EModeIDTable[] = {
 	{0x2e, 0x0a1b, 0x0306, 0x06, 0x05, 0x06},
 	{0x2f, 0x0a1b, 0x0305, 0x05, 0x05, 0x05},
@@ -2255,48 +2248,6 @@ static struct SiS_ModeResInfo_S XGI330_ModeResInfo[] = {
 	{1152,  864, 8, 16}
 };
 
-static unsigned char XGI330_OutputSelect = 0x40;
-static unsigned char XGI330_SoftSetting = 0x30;
-static unsigned char XGI330_SR07 = 0x18;
-
-static unsigned char XGI330_CR49[] = {0xaa, 0x88};
-static unsigned char XGI330_SR1F;
-static unsigned char XGI330_SR21 = 0xa3;
-static unsigned char XGI330_SR22 = 0xfb;
-static unsigned char XGI330_SR23 = 0xf6;
-static unsigned char XGI330_SR24 = 0xd;
-
-static unsigned char XGI330_CRT2Data_1_2;
-static unsigned char XGI330_CRT2Data_4_D;
-static unsigned char XGI330_CRT2Data_4_E;
-static unsigned char XGI330_CRT2Data_4_10 = 0x80;
-static unsigned short XGI330_RGBSenseData = 0xd1;
-static unsigned short XGI330_VideoSenseData = 0xb9;
-static unsigned short XGI330_YCSenseData = 0xb3;
-static unsigned short XGI330_RGBSenseData2 = 0x0190;     /*301b*/
-static unsigned short XGI330_VideoSenseData2 = 0x0110;
-static unsigned short XGI330_YCSenseData2 = 0x016B;
-static unsigned char XG40_I2CDefinition;
-static unsigned char XG20_CR97 = 0x10 ;
-
-static unsigned char XG21_DVOSetting;
-static unsigned char XG21_CR2E;
-static unsigned char XG21_CR2F;
-static unsigned char XG21_CR46;
-static unsigned char XG21_CR47;
-
-static unsigned char XG27_CR97 = 0xC1 ;
-static unsigned char XG27_SR36 = 0x30 ;
-static unsigned char XG27_CR8F = 0x0C ;
-static unsigned char XG27_CRD0[] = {
-	0, 0, 0, 0, 0, 0, 0, 0x82, 0x00, 0x66, 0x01, 0x00
-};
-static unsigned char XG27_CRDE[2];
-static unsigned char XG27_SR40 = 0x04 ;
-static unsigned char XG27_SR41 = 0x00 ;
-
-static unsigned char Z11m_CR97 = 0x80 ;
-
 static struct SiS_VCLKData XGI_VCLKData[] = {
 	/* SR2B,SR2C,SR2D */
 	{0x1B, 0xE1,  25}, /* 00 (25.175MHz) */
-- 
1.7.3.4

