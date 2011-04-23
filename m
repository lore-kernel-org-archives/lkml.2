Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751125Ab1DWELv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Apr 2011 00:11:51 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:33364 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823Ab1DWELt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Apr 2011 00:11:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=H1h7/GYi21+bIKNVmeIPoG1PklyhUU8K4BNc+Iw63N+yHu+YOG/P39XLYapga3Q94w
         iRcyA42m/+3Toxp1LDFJ58WlSveA0qz4UkYGX1L0DQToowZ+l+VpYn6BTxeyqLCYhNi4
         ZslvjdD+NAB+QmfNVqfBL1+H6ieQdAKz8mRXc=
From: Kenji Toyama <kenji.toyama@gmail.com>
To: gregkh@suse.de, aaro.koskinen@iki.fi, wfp5p@virginia.edu,
        apatard@mandriva.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Kenji Toyama <kenji.toyama@gmail.com>
Subject: [PATCH 3/3] Staging: xgifb: Fixed lots of coding style issues.
Date: Sat, 23 Apr 2011 12:11:16 +0800
Message-Id: <1303531876-32449-1-git-send-email-kenji.toyama@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There were hundreds of warnings, but now there's only four. These are
related to the 'volatile' keyword and printk(), which I think should be
left to the maintainers to modify if deemed necessary.

Signed-off-by: Daniel Kenji Toyama <kenji.toyama@gmail.com>
---
 drivers/staging/xgifb/vb_init.c |  527 +++++++++++++++++++++++++++------------
 drivers/staging/xgifb/vb_init.h |    7 +-
 2 files changed, 369 insertions(+), 165 deletions(-)

diff --git a/drivers/staging/xgifb/vb_init.c b/drivers/staging/xgifb/vb_init.c
index 61d1370..33c6876 100644
--- a/drivers/staging/xgifb/vb_init.c
+++ b/drivers/staging/xgifb/vb_init.c
@@ -13,7 +13,7 @@
 #include "vb_ext.h"
 
 
-#include <asm/io.h>
+#include <linux/io.h>
 
 static unsigned char XGINew_ChannelAB, XGINew_DataBusWidth;
 
@@ -39,8 +39,9 @@ static unsigned short XGINew_DDRDRAM_TYPE20[12][5] = {
 
 static int XGINew_RAMType;
 
-static unsigned char XGINew_GetXG20DRAMType(struct xgi_hw_device_info *HwDeviceExtension,
-					struct vb_device_info *pVBInfo)
+static unsigned char
+XGINew_GetXG20DRAMType(struct xgi_hw_device_info *HwDeviceExtension,
+		       struct vb_device_info *pVBInfo)
 {
 	unsigned char data, temp;
 
@@ -50,10 +51,9 @@ static unsigned char XGINew_GetXG20DRAMType(struct xgi_hw_device_info *HwDeviceE
 			return data;
 		} else {
 			data = xgifb_reg_get(pVBInfo->P3c4, 0x39) & 0x02;
-
 			if (data == 0)
-				data = (xgifb_reg_get(pVBInfo->P3c4, 0x3A) & 0x02) >> 1;
-
+				data = (xgifb_reg_get(pVBInfo->P3c4, 0x3A) &
+				       0x02) >> 1;
 			return data;
 		}
 	} else if (HwDeviceExtension->jChipType == XG27) {
@@ -62,19 +62,22 @@ static unsigned char XGINew_GetXG20DRAMType(struct xgi_hw_device_info *HwDeviceE
 			return data;
 		}
 		temp = xgifb_reg_get(pVBInfo->P3c4, 0x3B);
-
-		if ((temp & 0x88) == 0x80) /* SR3B[7][3]MAA15 MAA11 (Power on Trapping) */
+		/* SR3B[7][3]MAA15 MAA11 (Power on Trapping) */
+		if ((temp & 0x88) == 0x80)
 			data = 0; /* DDR */
 		else
 			data = 1; /* DDRII */
 		return data;
 	} else if (HwDeviceExtension->jChipType == XG21) {
-		xgifb_reg_and(pVBInfo->P3d4, 0xB4, ~0x02); /* Independent GPIO control */
+		/* Independent GPIO control */
+		xgifb_reg_and(pVBInfo->P3d4, 0xB4, ~0x02);
 		udelay(800);
 		xgifb_reg_or(pVBInfo->P3d4, 0x4A, 0x80); /* Enable GPIOH read */
-		temp = xgifb_reg_get(pVBInfo->P3d4, 0x48); /* GPIOF 0:DVI 1:DVO */
+		/* GPIOF 0:DVI 1:DVO */
+		temp = xgifb_reg_get(pVBInfo->P3d4, 0x48);
 		/* HOTPLUG_SUPPORT */
-		/* for current XG20 & XG21, GPIOH is floating, driver will fix DDR temporarily */
+		/* for current XG20 & XG21, GPIOH is floating, driver will
+		 * fix DDR temporarily */
 		if (temp & 0x01) /* DVI read GPIOH */
 			data = 1; /* DDRII */
 		else
@@ -92,7 +95,8 @@ static unsigned char XGINew_GetXG20DRAMType(struct xgi_hw_device_info *HwDeviceE
 	}
 }
 
-static void XGINew_DDR1x_MRS_340(unsigned long P3c4, struct vb_device_info *pVBInfo)
+static void XGINew_DDR1x_MRS_340(unsigned long P3c4,
+				 struct vb_device_info *pVBInfo)
 {
 	xgifb_reg_set(P3c4, 0x18, 0x01);
 	xgifb_reg_set(P3c4, 0x19, 0x20);
@@ -126,24 +130,42 @@ static void XGINew_SetMemoryClock(struct xgi_hw_device_info *HwDeviceExtension,
 		struct vb_device_info *pVBInfo)
 {
 
-	xgifb_reg_set(pVBInfo->P3c4, 0x28, pVBInfo->MCLKData[XGINew_RAMType].SR28);
-	xgifb_reg_set(pVBInfo->P3c4, 0x29, pVBInfo->MCLKData[XGINew_RAMType].SR29);
-	xgifb_reg_set(pVBInfo->P3c4, 0x2A, pVBInfo->MCLKData[XGINew_RAMType].SR2A);
-
-	xgifb_reg_set(pVBInfo->P3c4, 0x2E, pVBInfo->ECLKData[XGINew_RAMType].SR2E);
-	xgifb_reg_set(pVBInfo->P3c4, 0x2F, pVBInfo->ECLKData[XGINew_RAMType].SR2F);
-	xgifb_reg_set(pVBInfo->P3c4, 0x30, pVBInfo->ECLKData[XGINew_RAMType].SR30);
-
-	/* [Vicent] 2004/07/07, When XG42 ECLK = MCLK = 207MHz, Set SR32 D[1:0] = 10b */
-	/* [Hsuan] 2004/08/20, Modify SR32 value, when MCLK=207MHZ, ELCK=250MHz, Set SR32 D[1:0] = 10b */
+	xgifb_reg_set(pVBInfo->P3c4,
+		      0x28,
+		      pVBInfo->MCLKData[XGINew_RAMType].SR28);
+	xgifb_reg_set(pVBInfo->P3c4,
+		      0x29,
+		      pVBInfo->MCLKData[XGINew_RAMType].SR29);
+	xgifb_reg_set(pVBInfo->P3c4,
+		      0x2A,
+		      pVBInfo->MCLKData[XGINew_RAMType].SR2A);
+
+	xgifb_reg_set(pVBInfo->P3c4,
+		      0x2E,
+		      pVBInfo->ECLKData[XGINew_RAMType].SR2E);
+	xgifb_reg_set(pVBInfo->P3c4,
+		      0x2F,
+		      pVBInfo->ECLKData[XGINew_RAMType].SR2F);
+	xgifb_reg_set(pVBInfo->P3c4,
+		      0x30,
+		      pVBInfo->ECLKData[XGINew_RAMType].SR30);
+
+	/* [Vicent] 2004/07/07,
+	 * When XG42 ECLK = MCLK = 207MHz, Set SR32 D[1:0] = 10b */
+	/* [Hsuan] 2004/08/20,
+	 * Modify SR32 value, when MCLK=207MHZ, ELCK=250MHz,
+	 * Set SR32 D[1:0] = 10b */
 	if (HwDeviceExtension->jChipType == XG42) {
-		if ((pVBInfo->MCLKData[XGINew_RAMType].SR28 == 0x1C)
-				&& (pVBInfo->MCLKData[XGINew_RAMType].SR29 == 0x01)
-				&& (((pVBInfo->ECLKData[XGINew_RAMType].SR2E == 0x1C)
-						&& (pVBInfo->ECLKData[XGINew_RAMType].SR2F == 0x01))
-					|| ((pVBInfo->ECLKData[XGINew_RAMType].SR2E == 0x22)
-						&& (pVBInfo->ECLKData[XGINew_RAMType].SR2F == 0x01))))
-			xgifb_reg_set(pVBInfo->P3c4, 0x32, ((unsigned char) xgifb_reg_get(pVBInfo->P3c4, 0x32) & 0xFC) | 0x02);
+		if ((pVBInfo->MCLKData[XGINew_RAMType].SR28 == 0x1C) &&
+		    (pVBInfo->MCLKData[XGINew_RAMType].SR29 == 0x01) &&
+		    (((pVBInfo->ECLKData[XGINew_RAMType].SR2E == 0x1C) &&
+		      (pVBInfo->ECLKData[XGINew_RAMType].SR2F == 0x01)) ||
+		     ((pVBInfo->ECLKData[XGINew_RAMType].SR2E == 0x22) &&
+		      (pVBInfo->ECLKData[XGINew_RAMType].SR2F == 0x01))))
+			xgifb_reg_set(pVBInfo->P3c4,
+				      0x32,
+				      ((unsigned char) xgifb_reg_get(
+					  pVBInfo->P3c4, 0x32) & 0xFC) | 0x02);
 	}
 }
 
@@ -152,7 +174,8 @@ static void XGINew_DDRII_Bootup_XG27(
 			unsigned long P3c4, struct vb_device_info *pVBInfo)
 {
 	unsigned long P3d4 = P3c4 + 0x10;
-	XGINew_RAMType = (int) XGINew_GetXG20DRAMType(HwDeviceExtension, pVBInfo);
+	XGINew_RAMType = (int) XGINew_GetXG20DRAMType(HwDeviceExtension,
+						      pVBInfo);
 	XGINew_SetMemoryClock(HwDeviceExtension, pVBInfo);
 
 	/* Set Double Frequency */
@@ -216,7 +239,8 @@ static void XGINew_DDRII_Bootup_XG27(
 	xgifb_reg_set(P3c4, 0x16, 0xA0); /* Set SR16 */
 	udelay(15);
 
-	xgifb_reg_set(P3c4, 0x1B, 0x04); /* Set SR1B refresh control 000:close; 010:open */
+	/* Set SR1B refresh control 000:close; 010:open */
+	xgifb_reg_set(P3c4, 0x1B, 0x04);
 	udelay(200);
 
 }
@@ -226,7 +250,8 @@ static void XGINew_DDR2_MRS_XG20(struct xgi_hw_device_info *HwDeviceExtension,
 {
 	unsigned long P3d4 = P3c4 + 0x10;
 
-	XGINew_RAMType = (int) XGINew_GetXG20DRAMType(HwDeviceExtension, pVBInfo);
+	XGINew_RAMType = (int) XGINew_GetXG20DRAMType(HwDeviceExtension,
+						      pVBInfo);
 	XGINew_SetMemoryClock(HwDeviceExtension, pVBInfo);
 
 	xgifb_reg_set(P3d4, 0x97, 0x11); /* CR97 */
@@ -268,9 +293,9 @@ static void XGINew_DDR2_MRS_XG20(struct xgi_hw_device_info *HwDeviceExtension,
 	udelay(200);
 }
 
-static void XGINew_DDR1x_MRS_XG20(unsigned long P3c4, struct vb_device_info *pVBInfo)
+static void XGINew_DDR1x_MRS_XG20(unsigned long P3c4,
+				  struct vb_device_info *pVBInfo)
 {
-
 	xgifb_reg_set(P3c4, 0x18, 0x01);
 	xgifb_reg_set(P3c4, 0x19, 0x40);
 	xgifb_reg_set(P3c4, 0x16, 0x00);
@@ -306,9 +331,15 @@ static void XGINew_DDR1x_DefaultRegister(
 
 	if (HwDeviceExtension->jChipType >= XG20) {
 		XGINew_SetMemoryClock(HwDeviceExtension, pVBInfo);
-		xgifb_reg_set(P3d4, 0x82, pVBInfo->CR40[11][XGINew_RAMType]); /* CR82 */
-		xgifb_reg_set(P3d4, 0x85, pVBInfo->CR40[12][XGINew_RAMType]); /* CR85 */
-		xgifb_reg_set(P3d4, 0x86, pVBInfo->CR40[13][XGINew_RAMType]); /* CR86 */
+		xgifb_reg_set(P3d4,
+			      0x82,
+			      pVBInfo->CR40[11][XGINew_RAMType]); /* CR82 */
+		xgifb_reg_set(P3d4,
+			      0x85,
+			      pVBInfo->CR40[12][XGINew_RAMType]); /* CR85 */
+		xgifb_reg_set(P3d4,
+			      0x86,
+			      pVBInfo->CR40[13][XGINew_RAMType]); /* CR86 */
 
 		xgifb_reg_set(P3d4, 0x98, 0x01);
 		xgifb_reg_set(P3d4, 0x9A, 0x02);
@@ -320,24 +351,46 @@ static void XGINew_DDR1x_DefaultRegister(
 		switch (HwDeviceExtension->jChipType) {
 		case XG41:
 		case XG42:
-			xgifb_reg_set(P3d4, 0x82, pVBInfo->CR40[11][XGINew_RAMType]); /* CR82 */
-			xgifb_reg_set(P3d4, 0x85, pVBInfo->CR40[12][XGINew_RAMType]); /* CR85 */
-			xgifb_reg_set(P3d4, 0x86, pVBInfo->CR40[13][XGINew_RAMType]); /* CR86 */
+			/* CR82 */
+			xgifb_reg_set(P3d4,
+				      0x82,
+				      pVBInfo->CR40[11][XGINew_RAMType]);
+			/* CR85 */
+			xgifb_reg_set(P3d4,
+				      0x85,
+				      pVBInfo->CR40[12][XGINew_RAMType]);
+			/* CR86 */
+			xgifb_reg_set(P3d4,
+				      0x86,
+				      pVBInfo->CR40[13][XGINew_RAMType]);
 			break;
 		default:
 			xgifb_reg_set(P3d4, 0x82, 0x88);
 			xgifb_reg_set(P3d4, 0x86, 0x00);
-			xgifb_reg_get(P3d4, 0x86); /* Insert read command for delay */
+			/* Insert read command for delay */
+			xgifb_reg_get(P3d4, 0x86);
 			xgifb_reg_set(P3d4, 0x86, 0x88);
 			xgifb_reg_get(P3d4, 0x86);
-			xgifb_reg_set(P3d4, 0x86, pVBInfo->CR40[13][XGINew_RAMType]);
+			xgifb_reg_set(P3d4,
+				      0x86,
+				      pVBInfo->CR40[13][XGINew_RAMType]);
 			xgifb_reg_set(P3d4, 0x82, 0x77);
 			xgifb_reg_set(P3d4, 0x85, 0x00);
-			xgifb_reg_get(P3d4, 0x85); /* Insert read command for delay */
+
+			/* Insert read command for delay */
+			xgifb_reg_get(P3d4, 0x85);
 			xgifb_reg_set(P3d4, 0x85, 0x88);
-			xgifb_reg_get(P3d4, 0x85); /* Insert read command for delay */
-			xgifb_reg_set(P3d4, 0x85, pVBInfo->CR40[12][XGINew_RAMType]); /* CR85 */
-			xgifb_reg_set(P3d4, 0x82, pVBInfo->CR40[11][XGINew_RAMType]); /* CR82 */
+
+			/* Insert read command for delay */
+			xgifb_reg_get(P3d4, 0x85);
+			/* CR85 */
+			xgifb_reg_set(P3d4,
+				      0x85,
+				      pVBInfo->CR40[12][XGINew_RAMType]);
+			/* CR82 */
+			xgifb_reg_set(P3d4,
+				      0x82,
+				      pVBInfo->CR40[11][XGINew_RAMType]);
 			break;
 		}
 
@@ -354,13 +407,15 @@ static void XGINew_DDR2_DefaultRegister(
 {
 	unsigned long P3d4 = Port, P3c4 = Port - 0x10;
 
-	/* keep following setting sequence, each setting in the same reg insert idle */
+	/* keep following setting sequence, each setting in
+	 * the same reg insert idle */
 	xgifb_reg_set(P3d4, 0x82, 0x77);
 	xgifb_reg_set(P3d4, 0x86, 0x00);
 	xgifb_reg_get(P3d4, 0x86); /* Insert read command for delay */
 	xgifb_reg_set(P3d4, 0x86, 0x88);
 	xgifb_reg_get(P3d4, 0x86); /* Insert read command for delay */
-	xgifb_reg_set(P3d4, 0x86, pVBInfo->CR40[13][XGINew_RAMType]); /* CR86 */
+	/* CR86 */
+	xgifb_reg_set(P3d4, 0x86, pVBInfo->CR40[13][XGINew_RAMType]);
 	xgifb_reg_set(P3d4, 0x82, 0x77);
 	xgifb_reg_set(P3d4, 0x85, 0x00);
 	xgifb_reg_get(P3d4, 0x85); /* Insert read command for delay */
@@ -368,7 +423,8 @@ static void XGINew_DDR2_DefaultRegister(
 	xgifb_reg_get(P3d4, 0x85); /* Insert read command for delay */
 	xgifb_reg_set(P3d4, 0x85, pVBInfo->CR40[12][XGINew_RAMType]); /* CR85 */
 	if (HwDeviceExtension->jChipType == XG27)
-		xgifb_reg_set(P3d4, 0x82, pVBInfo->CR40[11][XGINew_RAMType]); /* CR82 */
+		/* CR82 */
+		xgifb_reg_set(P3d4, 0x82, pVBInfo->CR40[11][XGINew_RAMType]);
 	else
 		xgifb_reg_set(P3d4, 0x82, 0xA8); /* CR82 */
 
@@ -395,12 +451,14 @@ static void XGINew_SetDRAMDefaultRegister340(
 
 	temp2 = 0;
 	for (i = 0; i < 4; i++) {
-		temp = pVBInfo->CR6B[XGINew_RAMType][i]; /* CR6B DQS fine tune delay */
+		/* CR6B DQS fine tune delay */
+		temp = pVBInfo->CR6B[XGINew_RAMType][i];
 		for (j = 0; j < 4; j++) {
 			temp1 = ((temp >> (2 * j)) & 0x03) << 2;
 			temp2 |= temp1;
 			xgifb_reg_set(P3d4, 0x6B, temp2);
-			xgifb_reg_get(P3d4, 0x6B); /* Insert read command for delay */
+			/* Insert read command for delay */
+			xgifb_reg_get(P3d4, 0x6B);
 			temp2 &= 0xF0;
 			temp2 += 0x10;
 		}
@@ -408,12 +466,14 @@ static void XGINew_SetDRAMDefaultRegister340(
 
 	temp2 = 0;
 	for (i = 0; i < 4; i++) {
-		temp = pVBInfo->CR6E[XGINew_RAMType][i]; /* CR6E DQM fine tune delay */
+		/* CR6E DQM fine tune delay */
+		temp = pVBInfo->CR6E[XGINew_RAMType][i];
 		for (j = 0; j < 4; j++) {
 			temp1 = ((temp >> (2 * j)) & 0x03) << 2;
 			temp2 |= temp1;
 			xgifb_reg_set(P3d4, 0x6E, temp2);
-			xgifb_reg_get(P3d4, 0x6E); /* Insert read command for delay */
+			/* Insert read command for delay */
+			xgifb_reg_get(P3d4, 0x6E);
 			temp2 &= 0xF0;
 			temp2 += 0x10;
 		}
@@ -421,15 +481,18 @@ static void XGINew_SetDRAMDefaultRegister340(
 
 	temp3 = 0;
 	for (k = 0; k < 4; k++) {
-		xgifb_reg_and_or(P3d4, 0x6E, 0xFC, temp3); /* CR6E_D[1:0] select channel */
+		/* CR6E_D[1:0] select channel */
+		xgifb_reg_and_or(P3d4, 0x6E, 0xFC, temp3);
 		temp2 = 0;
 		for (i = 0; i < 8; i++) {
-			temp = pVBInfo->CR6F[XGINew_RAMType][8 * k + i]; /* CR6F DQ fine tune delay */
+			/* CR6F DQ fine tune delay */
+			temp = pVBInfo->CR6F[XGINew_RAMType][8 * k + i];
 			for (j = 0; j < 4; j++) {
 				temp1 = (temp >> (2 * j)) & 0x03;
 				temp2 |= temp1;
 				xgifb_reg_set(P3d4, 0x6F, temp2);
-				xgifb_reg_get(P3d4, 0x6F); /* Insert read command for delay */
+				/* Insert read command for delay */
+				xgifb_reg_get(P3d4, 0x6F);
 				temp2 &= 0xF8;
 				temp2 += 0x08;
 			}
@@ -441,7 +504,8 @@ static void XGINew_SetDRAMDefaultRegister340(
 	xgifb_reg_set(P3d4, 0x81, pVBInfo->CR40[10][XGINew_RAMType]); /* CR81 */
 
 	temp2 = 0x80;
-	temp = pVBInfo->CR89[XGINew_RAMType][0]; /* CR89 terminator type select */
+	/* CR89 terminator type select */
+	temp = pVBInfo->CR89[XGINew_RAMType][0];
 	for (j = 0; j < 4; j++) {
 		temp1 = (temp >> (2 * j)) & 0x03;
 		temp2 |= temp1;
@@ -468,19 +532,20 @@ static void XGINew_SetDRAMDefaultRegister340(
 	if (HwDeviceExtension->jChipType == XG27)
 		xgifb_reg_set(P3d4, 0x8F, *pVBInfo->pCR8F); /* CR8F */
 
-	for (j = 0; j <= 6; j++)
+	for (j = 0; j <= 6; j++) /* CR90 - CR96 */
 		xgifb_reg_set(P3d4, (0x90 + j),
-				pVBInfo->CR40[14 + j][XGINew_RAMType]); /* CR90 - CR96 */
+				pVBInfo->CR40[14 + j][XGINew_RAMType]);
 
-	for (j = 0; j <= 2; j++)
+	for (j = 0; j <= 2; j++) /* CRC3 - CRC5 */
 		xgifb_reg_set(P3d4, (0xC3 + j),
-				pVBInfo->CR40[21 + j][XGINew_RAMType]); /* CRC3 - CRC5 */
+				pVBInfo->CR40[21 + j][XGINew_RAMType]);
 
-	for (j = 0; j < 2; j++)
+	for (j = 0; j < 2; j++) /* CR8A - CR8B */
 		xgifb_reg_set(P3d4, (0x8A + j),
-				pVBInfo->CR40[1 + j][XGINew_RAMType]); /* CR8A - CR8B */
+				pVBInfo->CR40[1 + j][XGINew_RAMType]);
 
-	if ((HwDeviceExtension->jChipType == XG41) || (HwDeviceExtension->jChipType == XG42))
+	if ((HwDeviceExtension->jChipType == XG41) ||
+	    (HwDeviceExtension->jChipType == XG42))
 		xgifb_reg_set(P3d4, 0x8C, 0x87);
 
 	xgifb_reg_set(P3d4, 0x59, pVBInfo->CR40[4][XGINew_RAMType]); /* CR59 */
@@ -550,7 +615,10 @@ static unsigned short XGINew_SetDRAMSizeReg(int index,
 		memsize = data >> 4;
 
 		/* [2004/03/25] Vicent, Fix DRAM Sizing Error */
-		xgifb_reg_set(pVBInfo->P3c4, 0x14, (xgifb_reg_get(pVBInfo->P3c4, 0x14) & 0x0F) | (data & 0xF0));
+		xgifb_reg_set(pVBInfo->P3c4,
+			      0x14,
+			      (xgifb_reg_get(pVBInfo->P3c4, 0x14) & 0x0F) |
+			       (data & 0xF0));
 
 		/* data |= XGINew_ChannelAB << 2; */
 		/* data |= (XGINew_DataBusWidth / 64) << 1; */
@@ -591,7 +659,10 @@ static unsigned short XGINew_SetDRAMSize20Reg(int index,
 		memsize = data >> 4;
 
 		/* [2004/03/25] Vicent, Fix DRAM Sizing Error */
-		xgifb_reg_set(pVBInfo->P3c4, 0x14, (xgifb_reg_get(pVBInfo->P3c4, 0x14) & 0x0F) | (data & 0xF0));
+		xgifb_reg_set(pVBInfo->P3c4,
+			      0x14,
+			      (xgifb_reg_get(pVBInfo->P3c4, 0x14) & 0x0F) |
+				(data & 0xF0));
 		udelay(15);
 
 		/* data |= XGINew_ChannelAB << 2; */
@@ -617,7 +688,8 @@ static int XGINew_ReadWriteRest(unsigned short StopAddr,
 		*((unsigned long *) (pVBInfo->FBAddr + Position)) = Position;
 	}
 
-	udelay(500); /* [Vicent] 2004/04/16. Fix #1759 Memory Size error in Multi-Adapter. */
+	udelay(500); /* [Vicent] 2004/04/16.
+			Fix #1759 Memory Size error in Multi-Adapter. */
 
 	Position = 0;
 
@@ -626,7 +698,8 @@ static int XGINew_ReadWriteRest(unsigned short StopAddr,
 
 	for (i = StartAddr; i <= StopAddr; i++) {
 		Position = 1 << i;
-		if ((*(unsigned long *) (pVBInfo->FBAddr + Position)) != Position)
+		if ((*(unsigned long *) (pVBInfo->FBAddr + Position)) !=
+		    Position)
 			return 0;
 	}
 	return 1;
@@ -665,67 +738,96 @@ static void XGINew_CheckChannel(struct xgi_hw_device_info *HwDeviceExtension,
 					> 0x1000000) {
 
 				XGINew_DataBusWidth = 32; /* 32 bits */
-				xgifb_reg_set(pVBInfo->P3c4, 0x13, 0xB1); /* 22bit + 2 rank + 32bit */
+				/* 22bit + 2 rank + 32bit */
+				xgifb_reg_set(pVBInfo->P3c4, 0x13, 0xB1);
 				xgifb_reg_set(pVBInfo->P3c4, 0x14, 0x52);
 				udelay(15);
 
 				if (XGINew_ReadWriteRest(24, 23, pVBInfo) == 1)
 					return;
 
-				if ((HwDeviceExtension->ulVideoMemorySize - 1) > 0x800000) {
-					xgifb_reg_set(pVBInfo->P3c4, 0x13, 0x31); /* 22bit + 1 rank + 32bit */
-					xgifb_reg_set(pVBInfo->P3c4, 0x14, 0x42);
+				if ((HwDeviceExtension->ulVideoMemorySize - 1) >
+				    0x800000) {
+					/* 22bit + 1 rank + 32bit */
+					xgifb_reg_set(pVBInfo->P3c4,
+						      0x13,
+						      0x31);
+					xgifb_reg_set(pVBInfo->P3c4,
+						      0x14,
+						      0x42);
 					udelay(15);
 
-					if (XGINew_ReadWriteRest(23, 23, pVBInfo) == 1)
+					if (XGINew_ReadWriteRest(23,
+								 23,
+								 pVBInfo) == 1)
 						return;
 				}
 			}
 
-			if ((HwDeviceExtension->ulVideoMemorySize - 1) > 0x800000) {
+			if ((HwDeviceExtension->ulVideoMemorySize - 1) >
+			    0x800000) {
 				XGINew_DataBusWidth = 16; /* 16 bits */
-				xgifb_reg_set(pVBInfo->P3c4, 0x13, 0xB1); /* 22bit + 2 rank + 16bit */
+				/* 22bit + 2 rank + 16bit */
+				xgifb_reg_set(pVBInfo->P3c4, 0x13, 0xB1);
 				xgifb_reg_set(pVBInfo->P3c4, 0x14, 0x41);
 				udelay(15);
 
 				if (XGINew_ReadWriteRest(23, 22, pVBInfo) == 1)
 					return;
 				else
-					xgifb_reg_set(pVBInfo->P3c4, 0x13, 0x31);
+					xgifb_reg_set(pVBInfo->P3c4,
+						      0x13,
+						      0x31);
 				udelay(15);
 			}
 
 		} else { /* Dual_16_8 */
-			if ((HwDeviceExtension->ulVideoMemorySize - 1) > 0x800000) {
-
+			if ((HwDeviceExtension->ulVideoMemorySize - 1) >
+			    0x800000) {
 				XGINew_DataBusWidth = 16; /* 16 bits */
-				xgifb_reg_set(pVBInfo->P3c4, 0x13, 0xB1); /* (0x31:12x8x2) 22bit + 2 rank */
-				xgifb_reg_set(pVBInfo->P3c4, 0x14, 0x41); /* 0x41:16Mx16 bit*/
+				/* (0x31:12x8x2) 22bit + 2 rank */
+				xgifb_reg_set(pVBInfo->P3c4, 0x13, 0xB1);
+				/* 0x41:16Mx16 bit*/
+				xgifb_reg_set(pVBInfo->P3c4, 0x14, 0x41);
 				udelay(15);
 
 				if (XGINew_ReadWriteRest(23, 22, pVBInfo) == 1)
 					return;
 
-				if ((HwDeviceExtension->ulVideoMemorySize - 1) > 0x400000) {
-					xgifb_reg_set(pVBInfo->P3c4, 0x13, 0x31); /* (0x31:12x8x2) 22bit + 1 rank */
-					xgifb_reg_set(pVBInfo->P3c4, 0x14, 0x31); /* 0x31:8Mx16 bit*/
+				if ((HwDeviceExtension->ulVideoMemorySize - 1) >
+				    0x400000) {
+					/* (0x31:12x8x2) 22bit + 1 rank */
+					xgifb_reg_set(pVBInfo->P3c4,
+						      0x13,
+						      0x31);
+					/* 0x31:8Mx16 bit*/
+					xgifb_reg_set(pVBInfo->P3c4,
+						      0x14,
+						      0x31);
 					udelay(15);
 
-					if (XGINew_ReadWriteRest(22, 22, pVBInfo) == 1)
+					if (XGINew_ReadWriteRest(22,
+								 22,
+								 pVBInfo) == 1)
 						return;
 				}
 			}
 
-			if ((HwDeviceExtension->ulVideoMemorySize - 1) > 0x400000) {
+			if ((HwDeviceExtension->ulVideoMemorySize - 1) >
+			    0x400000) {
 				XGINew_DataBusWidth = 8; /* 8 bits */
-				xgifb_reg_set(pVBInfo->P3c4, 0x13, 0xB1); /* (0x31:12x8x2) 22bit + 2 rank */
-				xgifb_reg_set(pVBInfo->P3c4, 0x14, 0x30); /* 0x30:8Mx8 bit*/
+				/* (0x31:12x8x2) 22bit + 2 rank */
+				xgifb_reg_set(pVBInfo->P3c4, 0x13, 0xB1);
+				/* 0x30:8Mx8 bit*/
+				xgifb_reg_set(pVBInfo->P3c4, 0x14, 0x30);
 				udelay(15);
 
 				if (XGINew_ReadWriteRest(22, 21, pVBInfo) == 1)
 					return;
-				else
-					xgifb_reg_set(pVBInfo->P3c4, 0x13, 0x31); /* (0x31:12x8x2) 22bit + 1 rank */
+				else /* (0x31:12x8x2) 22bit + 1 rank */
+					xgifb_reg_set(pVBInfo->P3c4,
+						      0x13,
+						      0x31);
 				udelay(15);
 			}
 		}
@@ -911,13 +1013,18 @@ static int XGINew_DDRSizing340(struct xgi_hw_device_info *HwDeviceExtension,
 
 	if (HwDeviceExtension->jChipType >= XG20) {
 		for (i = 0; i < 12; i++) {
-			XGINew_SetDRAMSizingType(i, XGINew_DDRDRAM_TYPE20, pVBInfo);
-			memsize = XGINew_SetDRAMSize20Reg(i, XGINew_DDRDRAM_TYPE20, pVBInfo);
+			XGINew_SetDRAMSizingType(i,
+						 XGINew_DDRDRAM_TYPE20,
+						 pVBInfo);
+			memsize = XGINew_SetDRAMSize20Reg(i,
+							  XGINew_DDRDRAM_TYPE20,
+							  pVBInfo);
 			if (memsize == 0)
 				continue;
 
 			addr = memsize + (XGINew_ChannelAB - 2) + 20;
-			if ((HwDeviceExtension->ulVideoMemorySize - 1) < (unsigned long) (1 << addr))
+			if ((HwDeviceExtension->ulVideoMemorySize - 1) <
+			    (unsigned long) (1 << addr))
 				continue;
 
 			if (XGINew_ReadWriteRest(addr, 5, pVBInfo) == 1)
@@ -925,14 +1032,19 @@ static int XGINew_DDRSizing340(struct xgi_hw_device_info *HwDeviceExtension,
 		}
 	} else {
 		for (i = 0; i < 4; i++) {
-			XGINew_SetDRAMSizingType(i, XGINew_DDRDRAM_TYPE340, pVBInfo);
-			memsize = XGINew_SetDRAMSizeReg(i, XGINew_DDRDRAM_TYPE340, pVBInfo);
+			XGINew_SetDRAMSizingType(i,
+						 XGINew_DDRDRAM_TYPE340,
+						 pVBInfo);
+			memsize = XGINew_SetDRAMSizeReg(i,
+							XGINew_DDRDRAM_TYPE340,
+							pVBInfo);
 
 			if (memsize == 0)
 				continue;
 
 			addr = memsize + (XGINew_ChannelAB - 2) + 20;
-			if ((HwDeviceExtension->ulVideoMemorySize - 1) < (unsigned long) (1 << addr))
+			if ((HwDeviceExtension->ulVideoMemorySize - 1) <
+			    (unsigned long) (1 << addr))
 				continue;
 
 			if (XGINew_ReadWriteRest(addr, 9, pVBInfo) == 1)
@@ -953,7 +1065,8 @@ static void XGINew_SetDRAMSize_340(struct xgi_hw_device_info *HwDeviceExtension,
 	XGISetModeNew(HwDeviceExtension, 0x2e);
 
 	data = xgifb_reg_get(pVBInfo->P3c4, 0x21);
-	xgifb_reg_set(pVBInfo->P3c4, 0x21, (unsigned short) (data & 0xDF)); /* disable read cache */
+	/* disable read cache */
+	xgifb_reg_set(pVBInfo->P3c4, 0x21, (unsigned short) (data & 0xDF));
 	XGI_DisplayOff(HwDeviceExtension, pVBInfo);
 
 	/* data = xgifb_reg_get(pVBInfo->P3c4, 0x1); */
@@ -961,12 +1074,15 @@ static void XGINew_SetDRAMSize_340(struct xgi_hw_device_info *HwDeviceExtension,
 	/* xgifb_reg_set(pVBInfo->P3c4, 0x01, data); *//* Turn OFF Display */
 	XGINew_DDRSizing340(HwDeviceExtension, pVBInfo);
 	data = xgifb_reg_get(pVBInfo->P3c4, 0x21);
-	xgifb_reg_set(pVBInfo->P3c4, 0x21, (unsigned short) (data | 0x20)); /* enable read cache */
+	/* enable read cache */
+	xgifb_reg_set(pVBInfo->P3c4, 0x21, (unsigned short) (data | 0x20));
 }
 
-static void ReadVBIOSTablData(unsigned char ChipType, struct vb_device_info *pVBInfo)
+static void ReadVBIOSTablData(unsigned char ChipType,
+			      struct vb_device_info *pVBInfo)
 {
-	volatile unsigned char *pVideoMemory = (unsigned char *) pVBInfo->ROMAddr;
+	volatile unsigned char *pVideoMemory =
+		(unsigned char *) pVBInfo->ROMAddr;
 	unsigned long i;
 	unsigned char j, k;
 	/* Volari customize data area end */
@@ -980,24 +1096,34 @@ static void ReadVBIOSTablData(unsigned char ChipType, struct vb_device_info *pVB
 			if (j != 0xff) {
 				k = 0;
 				do {
-					pVBInfo->XG21_LVDSCapList[k].LVDS_Capability
-						= pVideoMemory[i] | (pVideoMemory[i + 1] << 8);
+					pVBInfo->XG21_LVDSCapList[k].
+						 LVDS_Capability
+						= pVideoMemory[i] |
+						 (pVideoMemory[i + 1] << 8);
 					pVBInfo->XG21_LVDSCapList[k].LVDSHT
-						= pVideoMemory[i + 2] | (pVideoMemory[i + 3] << 8);
+						= pVideoMemory[i + 2] |
+						  (pVideoMemory[i + 3] << 8);
 					pVBInfo->XG21_LVDSCapList[k].LVDSVT
-						= pVideoMemory[i + 4] | (pVideoMemory[i	+ 5] << 8);
+						= pVideoMemory[i + 4] |
+						  (pVideoMemory[i + 5] << 8);
 					pVBInfo->XG21_LVDSCapList[k].LVDSHDE
-						= pVideoMemory[i + 6] | (pVideoMemory[i	+ 7] << 8);
+						= pVideoMemory[i + 6] |
+						  (pVideoMemory[i + 7] << 8);
 					pVBInfo->XG21_LVDSCapList[k].LVDSVDE
-						= pVideoMemory[i + 8] | (pVideoMemory[i + 9] << 8);
+						= pVideoMemory[i + 8] |
+						  (pVideoMemory[i + 9] << 8);
 					pVBInfo->XG21_LVDSCapList[k].LVDSHFP
-						= pVideoMemory[i + 10] | (pVideoMemory[i + 11] << 8);
+						= pVideoMemory[i + 10] |
+						  (pVideoMemory[i + 11] << 8);
 					pVBInfo->XG21_LVDSCapList[k].LVDSVFP
-						= pVideoMemory[i + 12] | (pVideoMemory[i + 13] << 8);
+						= pVideoMemory[i + 12] |
+						  (pVideoMemory[i + 13] << 8);
 					pVBInfo->XG21_LVDSCapList[k].LVDSHSYNC
-						= pVideoMemory[i + 14] | (pVideoMemory[i + 15] << 8);
+						= pVideoMemory[i + 14] |
+						  (pVideoMemory[i + 15] << 8);
 					pVBInfo->XG21_LVDSCapList[k].LVDSVSYNC
-						= pVideoMemory[i + 16] | (pVideoMemory[i + 17] << 8);
+						= pVideoMemory[i + 16] |
+						  (pVideoMemory[i + 17] << 8);
 					pVBInfo->XG21_LVDSCapList[k].VCLKData1
 						= pVideoMemory[i + 18];
 					pVBInfo->XG21_LVDSCapList[k].VCLKData2
@@ -1015,26 +1141,38 @@ static void ReadVBIOSTablData(unsigned char ChipType, struct vb_device_info *pVB
 					i += 25;
 					j--;
 					k++;
-				} while ((j > 0) && (k < (sizeof(XGI21_LCDCapList) / sizeof(struct XGI21_LVDSCapStruct))));
+				} while ((j > 0) &&
+					 (k < (sizeof(XGI21_LCDCapList) /
+					       sizeof(struct
+							XGI21_LVDSCapStruct))));
 			} else {
 				pVBInfo->XG21_LVDSCapList[0].LVDS_Capability
-						= pVideoMemory[i] | (pVideoMemory[i + 1] << 8);
+						= pVideoMemory[i] |
+						  (pVideoMemory[i + 1] << 8);
 				pVBInfo->XG21_LVDSCapList[0].LVDSHT
-						= pVideoMemory[i + 2] | (pVideoMemory[i + 3] << 8);
+						= pVideoMemory[i + 2] |
+						  (pVideoMemory[i + 3] << 8);
 				pVBInfo->XG21_LVDSCapList[0].LVDSVT
-						= pVideoMemory[i + 4] | (pVideoMemory[i + 5] << 8);
+						= pVideoMemory[i + 4] |
+						  (pVideoMemory[i + 5] << 8);
 				pVBInfo->XG21_LVDSCapList[0].LVDSHDE
-						= pVideoMemory[i + 6] | (pVideoMemory[i + 7] << 8);
+						= pVideoMemory[i + 6] |
+						  (pVideoMemory[i + 7] << 8);
 				pVBInfo->XG21_LVDSCapList[0].LVDSVDE
-						= pVideoMemory[i + 8] | (pVideoMemory[i + 9] << 8);
+						= pVideoMemory[i + 8] |
+						  (pVideoMemory[i + 9] << 8);
 				pVBInfo->XG21_LVDSCapList[0].LVDSHFP
-						= pVideoMemory[i + 10] | (pVideoMemory[i + 11] << 8);
+						= pVideoMemory[i + 10] |
+						  (pVideoMemory[i + 11] << 8);
 				pVBInfo->XG21_LVDSCapList[0].LVDSVFP
-						= pVideoMemory[i + 12] | (pVideoMemory[i + 13] << 8);
+						= pVideoMemory[i + 12] |
+						  (pVideoMemory[i + 13] << 8);
 				pVBInfo->XG21_LVDSCapList[0].LVDSHSYNC
-						= pVideoMemory[i + 14] | (pVideoMemory[i + 15] << 8);
+						= pVideoMemory[i + 14] |
+						  (pVideoMemory[i + 15] << 8);
 				pVBInfo->XG21_LVDSCapList[0].LVDSVSYNC
-						= pVideoMemory[i + 16] | (pVideoMemory[i + 17] << 8);
+						= pVideoMemory[i + 16] |
+						  (pVideoMemory[i + 17] << 8);
 				pVBInfo->XG21_LVDSCapList[0].VCLKData1
 						= pVideoMemory[i + 18];
 				pVBInfo->XG21_LVDSCapList[0].VCLKData2
@@ -1197,21 +1335,31 @@ static void XGINew_GetXG21Sense(struct xgi_hw_device_info *HwDeviceExtension,
 	if ((pVideoMemory[0x65] & 0x01)) { /* For XG21 LVDS */
 		pVBInfo->IF_DEF_LVDS = 1;
 		xgifb_reg_or(pVBInfo->P3d4, 0x32, LCDSense);
-		xgifb_reg_and_or(pVBInfo->P3d4, 0x38, ~0xE0, 0xC0); /* LVDS on chip */
+		/* LVDS on chip */
+		xgifb_reg_and_or(pVBInfo->P3d4, 0x38, ~0xE0, 0xC0);
 	} else {
 #endif
-		xgifb_reg_and_or(pVBInfo->P3d4, 0x4A, ~0x03, 0x03); /* Enable GPIOA/B read  */
+		/* Enable GPIOA/B read  */
+		xgifb_reg_and_or(pVBInfo->P3d4, 0x4A, ~0x03, 0x03);
 		Temp = xgifb_reg_get(pVBInfo->P3d4, 0x48) & 0xC0;
 		if (Temp == 0xC0) { /* DVI & DVO GPIOA/B pull high */
 			XGINew_SenseLCD(HwDeviceExtension, pVBInfo);
 			xgifb_reg_or(pVBInfo->P3d4, 0x32, LCDSense);
-			xgifb_reg_and_or(pVBInfo->P3d4, 0x4A, ~0x20, 0x20); /* Enable read GPIOF */
+			/* Enable read GPIOF */
+			xgifb_reg_and_or(pVBInfo->P3d4, 0x4A, ~0x20, 0x20);
 			Temp = xgifb_reg_get(pVBInfo->P3d4, 0x48) & 0x04;
 			if (!Temp)
-				xgifb_reg_and_or(pVBInfo->P3d4, 0x38, ~0xE0, 0x80); /* TMDS on chip */
+				xgifb_reg_and_or(pVBInfo->P3d4,
+						 0x38,
+						 ~0xE0,
+						 0x80); /* TMDS on chip */
 			else
-				xgifb_reg_and_or(pVBInfo->P3d4, 0x38, ~0xE0, 0xA0); /* Only DVO on chip */
-			xgifb_reg_and(pVBInfo->P3d4, 0x4A, ~0x20); /* Disable read GPIOF */
+				xgifb_reg_and_or(pVBInfo->P3d4,
+						 0x38,
+						 ~0xE0,
+						 0xA0); /* Only DVO on chip */
+			/* Disable read GPIOF */
+			xgifb_reg_and(pVBInfo->P3d4, 0x4A, ~0x20);
 		}
 #if 1
 	}
@@ -1225,16 +1373,19 @@ static void XGINew_GetXG27Sense(struct xgi_hw_device_info *HwDeviceExtension,
 
 	pVBInfo->IF_DEF_LVDS = 0;
 	bCR4A = xgifb_reg_get(pVBInfo->P3d4, 0x4A);
-	xgifb_reg_and_or(pVBInfo->P3d4, 0x4A, ~0x07, 0x07); /* Enable GPIOA/B/C read  */
+	/* Enable GPIOA/B/C read  */
+	xgifb_reg_and_or(pVBInfo->P3d4, 0x4A, ~0x07, 0x07);
 	Temp = xgifb_reg_get(pVBInfo->P3d4, 0x48) & 0x07;
 	xgifb_reg_set(pVBInfo->P3d4, 0x4A, bCR4A);
 
 	if (Temp <= 0x02) {
 		pVBInfo->IF_DEF_LVDS = 1;
-		xgifb_reg_and_or(pVBInfo->P3d4, 0x38, ~0xE0, 0xC0); /* LVDS setting */
+		/* LVDS setting */
+		xgifb_reg_and_or(pVBInfo->P3d4, 0x38, ~0xE0, 0xC0);
 		xgifb_reg_set(pVBInfo->P3d4, 0x30, 0x21);
 	} else {
-		xgifb_reg_and_or(pVBInfo->P3d4, 0x38, ~0xE0, 0xA0); /* TMDS/DVO setting */
+		/* TMDS/DVO setting */
+		xgifb_reg_and_or(pVBInfo->P3d4, 0x38, ~0xE0, 0xA0);
 	}
 	xgifb_reg_or(pVBInfo->P3d4, 0x32, LCDSense);
 
@@ -1245,7 +1396,8 @@ static unsigned char GetXG21FPBits(struct vb_device_info *pVBInfo)
 	unsigned char CR38, CR4A, temp;
 
 	CR4A = xgifb_reg_get(pVBInfo->P3d4, 0x4A);
-	xgifb_reg_and_or(pVBInfo->P3d4, 0x4A, ~0x10, 0x10); /* enable GPIOE read */
+	/* enable GPIOE read */
+	xgifb_reg_and_or(pVBInfo->P3d4, 0x4A, ~0x10, 0x10);
 	CR38 = xgifb_reg_get(pVBInfo->P3d4, 0x38);
 	temp = 0;
 	if ((CR38 & 0xE0) > 0x80) {
@@ -1264,7 +1416,8 @@ static unsigned char GetXG27FPBits(struct vb_device_info *pVBInfo)
 	unsigned char CR4A, temp;
 
 	CR4A = xgifb_reg_get(pVBInfo->P3d4, 0x4A);
-	xgifb_reg_and_or(pVBInfo->P3d4, 0x4A, ~0x03, 0x03); /* enable GPIOA/B/C read */
+	/* enable GPIOA/B/C read */
+	xgifb_reg_and_or(pVBInfo->P3d4, 0x4A, ~0x03, 0x03);
 	temp = xgifb_reg_get(pVBInfo->P3d4, 0x48);
 	if (temp <= 2)
 		temp &= 0x03;
@@ -1344,7 +1497,8 @@ unsigned char XGIInitNew(struct xgi_hw_device_info *HwDeviceExtension)
 	printk("5");
 
 	if (HwDeviceExtension->jChipType < XG20) /* kuku 2004/06/25 */
-		XGI_GetVBType(pVBInfo); /* Run XGI_GetVBType before InitTo330Pointer */
+		/* Run XGI_GetVBType before InitTo330Pointer */
+		XGI_GetVBType(pVBInfo);
 
 	InitTo330Pointer(HwDeviceExtension->jChipType, pVBInfo);
 
@@ -1381,7 +1535,8 @@ unsigned char XGIInitNew(struct xgi_hw_device_info *HwDeviceExtension)
 		xgifb_reg_set(pVBInfo->P3c4, i, 0);
 	printk("9");
 
-	if (HwDeviceExtension->jChipType == XG42) /* [Hsuan] 2004/08/20 Auto over driver for XG42 */
+	/* [Hsuan] 2004/08/20 Auto over driver for XG42 */
+	if (HwDeviceExtension->jChipType == XG42)
 		xgifb_reg_set(pVBInfo->P3c4, 0x3B, 0xC0);
 
 	/* for (i = 0x30; i <= 0x3F; i++) */
@@ -1397,7 +1552,8 @@ unsigned char XGIInitNew(struct xgi_hw_device_info *HwDeviceExtension)
 
 	/* 3.SetMemoryClock
 
-	 XGINew_RAMType = (int)XGINew_GetXG20DRAMType(HwDeviceExtension, pVBInfo);
+	 XGINew_RAMType = (int)XGINew_GetXG20DRAMType(HwDeviceExtension,
+						      pVBInfo);
 	*/
 
 	printk("11");
@@ -1411,8 +1567,10 @@ unsigned char XGIInitNew(struct xgi_hw_device_info *HwDeviceExtension)
 	xgifb_reg_set(pVBInfo->P3c4, 0x11, 0x0F);
 	xgifb_reg_set(pVBInfo->P3c4, 0x1F, *pVBInfo->pSR1F);
 	/* xgifb_reg_set(pVBInfo->P3c4, 0x20, 0x20); */
-	xgifb_reg_set(pVBInfo->P3c4, 0x20, 0xA0); /* alan, 2001/6/26 Frame buffer can read/write SR20 */
-	xgifb_reg_set(pVBInfo->P3c4, 0x36, 0x70); /* Hsuan, 2006/01/01 H/W request for slow corner chip */
+	/* alan, 2001/6/26 Frame buffer can read/write SR20 */
+	xgifb_reg_set(pVBInfo->P3c4, 0x20, 0xA0);
+	/* Hsuan, 2006/01/01 H/W request for slow corner chip */
+	xgifb_reg_set(pVBInfo->P3c4, 0x36, 0x70);
 	if (HwDeviceExtension->jChipType == XG27) /* Alan 12/07/2006 */
 		xgifb_reg_set(pVBInfo->P3c4, 0x36, *pVBInfo->pSR36);
 
@@ -1441,14 +1599,24 @@ unsigned char XGIInitNew(struct xgi_hw_device_info *HwDeviceExtension)
 
 			ChipsetID &= 0x0000FFFF;
 
-			if ((ChipsetID == 0x700E) || (ChipsetID == 0x1022) || (ChipsetID == 0x1106) || (ChipsetID == 0x10DE)) {
+			if ((ChipsetID == 0x700E) ||
+			    (ChipsetID == 0x1022) ||
+			    (ChipsetID == 0x1106) ||
+			    (ChipsetID == 0x10DE)) {
 				if (ChipsetID == 0x1106) {
-					if ((VendorID == 0x1019) && (GraphicVendorID == 0x1019))
-						xgifb_reg_set(pVBInfo->P3d4, 0x5F, 0x0D);
+					if ((VendorID == 0x1019) &&
+					    (GraphicVendorID == 0x1019))
+						xgifb_reg_set(pVBInfo->P3d4,
+							      0x5F,
+							      0x0D);
 					else
-						xgifb_reg_set(pVBInfo->P3d4, 0x5F, 0x0B);
+						xgifb_reg_set(pVBInfo->P3d4,
+							      0x5F,
+							      0x0B);
 				} else {
-					xgifb_reg_set(pVBInfo->P3d4, 0x5F, 0x0B);
+					xgifb_reg_set(pVBInfo->P3d4,
+						      0x5F,
+						      0x0B);
 				}
 			}
 		}
@@ -1458,13 +1626,19 @@ unsigned char XGIInitNew(struct xgi_hw_device_info *HwDeviceExtension)
 
 		/* Set AGP customize registers (in SetDefAGPRegs) Start */
 		for (i = 0x47; i <= 0x4C; i++)
-			xgifb_reg_set(pVBInfo->P3d4, i, pVBInfo->AGPReg[i - 0x47]);
+			xgifb_reg_set(pVBInfo->P3d4,
+				      i,
+				      pVBInfo->AGPReg[i - 0x47]);
 
 		for (i = 0x70; i <= 0x71; i++)
-			xgifb_reg_set(pVBInfo->P3d4, i, pVBInfo->AGPReg[6 + i - 0x70]);
+			xgifb_reg_set(pVBInfo->P3d4,
+				      i,
+				      pVBInfo->AGPReg[6 + i - 0x70]);
 
 		for (i = 0x74; i <= 0x77; i++)
-			xgifb_reg_set(pVBInfo->P3d4, i, pVBInfo->AGPReg[8 + i - 0x74]);
+			xgifb_reg_set(pVBInfo->P3d4,
+				      i,
+				      pVBInfo->AGPReg[8 + i - 0x74]);
 		/* Set AGP customize registers (in SetDefAGPRegs) End */
 		/* [Hsuan]2004/12/14 AGP Input Delay Adjustment on 850 */
 		/*        outl(0x80000000, 0xcf8); */
@@ -1472,7 +1646,10 @@ unsigned char XGIInitNew(struct xgi_hw_device_info *HwDeviceExtension)
 		/*        if (ChipsetID == 0x25308086) */
 		/*            xgifb_reg_set(pVBInfo->P3d4, 0x77, 0xF0); */
 
-		HwDeviceExtension->pQueryVGAConfigSpace(HwDeviceExtension, 0x50, 0, &Temp); /* Get */
+		HwDeviceExtension->pQueryVGAConfigSpace(HwDeviceExtension,
+							0x50,
+							0,
+							&Temp); /* Get */
 		Temp >>= 20;
 		Temp &= 0xF;
 
@@ -1490,12 +1667,16 @@ unsigned char XGIInitNew(struct xgi_hw_device_info *HwDeviceExtension)
 	if (HwDeviceExtension->jChipType < XG20) { /* kuku 2004/06/25 */
 		/* Set VB */
 		XGI_UnLockCRT2(HwDeviceExtension, pVBInfo);
-		xgifb_reg_and_or(pVBInfo->Part0Port, 0x3F, 0xEF, 0x00); /* alan, disable VideoCapture */
+		/* alan, disable VideoCapture */
+		xgifb_reg_and_or(pVBInfo->Part0Port, 0x3F, 0xEF, 0x00);
 		xgifb_reg_set(pVBInfo->Part1Port, 0x00, 0x00);
-		temp1 = (unsigned char) xgifb_reg_get(pVBInfo->P3d4, 0x7B); /* chk if BCLK>=100MHz */
+		/* chk if BCLK>=100MHz */
+		temp1 = (unsigned char) xgifb_reg_get(pVBInfo->P3d4, 0x7B);
 		temp = (unsigned char) ((temp1 >> 4) & 0x0F);
 
-		xgifb_reg_set(pVBInfo->Part1Port, 0x02, (*pVBInfo->pCRT2Data_1_2));
+		xgifb_reg_set(pVBInfo->Part1Port,
+			      0x02,
+			      (*pVBInfo->pCRT2Data_1_2));
 
 		printk("16");
 
@@ -1504,10 +1685,15 @@ unsigned char XGIInitNew(struct xgi_hw_device_info *HwDeviceExtension)
 
 	xgifb_reg_set(pVBInfo->P3c4, 0x27, 0x1F);
 
-	if ((HwDeviceExtension->jChipType == XG42)
-			&& XGINew_GetXG20DRAMType(HwDeviceExtension, pVBInfo) != 0) { /* Not DDR */
-		xgifb_reg_set(pVBInfo->P3c4, 0x31, (*pVBInfo->pSR31 & 0x3F) | 0x40);
-		xgifb_reg_set(pVBInfo->P3c4, 0x32, (*pVBInfo->pSR32 & 0xFC) | 0x01);
+	if ((HwDeviceExtension->jChipType == XG42) &&
+	    XGINew_GetXG20DRAMType(HwDeviceExtension, pVBInfo) != 0) {
+		/* Not DDR */
+		xgifb_reg_set(pVBInfo->P3c4,
+			      0x31,
+			      (*pVBInfo->pSR31 & 0x3F) | 0x40);
+		xgifb_reg_set(pVBInfo->P3c4,
+			      0x32,
+			      (*pVBInfo->pSR32 & 0xFC) | 0x01);
 	} else {
 		xgifb_reg_set(pVBInfo->P3c4, 0x31, *pVBInfo->pSR31);
 		xgifb_reg_set(pVBInfo->P3c4, 0x32, *pVBInfo->pSR32);
@@ -1522,9 +1708,15 @@ unsigned char XGIInitNew(struct xgi_hw_device_info *HwDeviceExtension)
 		if (XGI_BridgeIsOn(pVBInfo) == 1) {
 			if (pVBInfo->IF_DEF_LVDS == 0) {
 				xgifb_reg_set(pVBInfo->Part2Port, 0x00, 0x1C);
-				xgifb_reg_set(pVBInfo->Part4Port, 0x0D, *pVBInfo->pCRT2Data_4_D);
-				xgifb_reg_set(pVBInfo->Part4Port, 0x0E, *pVBInfo->pCRT2Data_4_E);
-				xgifb_reg_set(pVBInfo->Part4Port, 0x10, *pVBInfo->pCRT2Data_4_10);
+				xgifb_reg_set(pVBInfo->Part4Port,
+					      0x0D,
+					      *pVBInfo->pCRT2Data_4_D);
+				xgifb_reg_set(pVBInfo->Part4Port,
+					      0x0E,
+					      *pVBInfo->pCRT2Data_4_E);
+				xgifb_reg_set(pVBInfo->Part4Port,
+					      0x10,
+					      *pVBInfo->pCRT2Data_4_10);
 				xgifb_reg_set(pVBInfo->Part4Port, 0x0F, 0x3F);
 			}
 
@@ -1542,31 +1734,42 @@ unsigned char XGIInitNew(struct xgi_hw_device_info *HwDeviceExtension)
 	printk("183");
 	/* XGINew_DetectMonitor(HwDeviceExtension); */
 	pVBInfo->IF_DEF_CH7007 = 0;
-	if ((HwDeviceExtension->jChipType == XG21) && (pVBInfo->IF_DEF_CH7007)) {
+	if ((HwDeviceExtension->jChipType == XG21) &&
+	    (pVBInfo->IF_DEF_CH7007)) {
 		printk("184");
-		XGI_GetSenseStatus(HwDeviceExtension, pVBInfo); /* sense CRT2 */
+		/* sense CRT2 */
+		XGI_GetSenseStatus(HwDeviceExtension, pVBInfo);
 		printk("185");
 
 	}
 	if (HwDeviceExtension->jChipType == XG21) {
 		printk("186");
 
-		xgifb_reg_and_or(pVBInfo->P3d4, 0x32, ~Monitor1Sense, Monitor1Sense); /* Z9 default has CRT */
+		xgifb_reg_and_or(pVBInfo->P3d4,
+				 0x32,
+				 ~Monitor1Sense,
+				 Monitor1Sense); /* Z9 default has CRT */
 		temp = GetXG21FPBits(pVBInfo);
 		xgifb_reg_and_or(pVBInfo->P3d4, 0x37, ~0x01, temp);
 		printk("187");
 
 	}
 	if (HwDeviceExtension->jChipType == XG27) {
-		xgifb_reg_and_or(pVBInfo->P3d4, 0x32, ~Monitor1Sense, Monitor1Sense); /* Z9 default has CRT */
+		xgifb_reg_and_or(pVBInfo->P3d4,
+				 0x32,
+				 ~Monitor1Sense,
+				 Monitor1Sense); /* Z9 default has CRT */
 		temp = GetXG27FPBits(pVBInfo);
 		xgifb_reg_and_or(pVBInfo->P3d4, 0x37, ~0x03, temp);
 	}
 	printk("19");
 
-	XGINew_RAMType = (int) XGINew_GetXG20DRAMType(HwDeviceExtension, pVBInfo);
+	XGINew_RAMType = (int) XGINew_GetXG20DRAMType(HwDeviceExtension,
+						      pVBInfo);
 
-	XGINew_SetDRAMDefaultRegister340(HwDeviceExtension, pVBInfo->P3d4, pVBInfo);
+	XGINew_SetDRAMDefaultRegister340(HwDeviceExtension,
+					 pVBInfo->P3d4,
+					 pVBInfo);
 
 	printk("20");
 	XGINew_SetDRAMSize_340(HwDeviceExtension, pVBInfo);
@@ -1594,7 +1797,9 @@ unsigned char XGIInitNew(struct xgi_hw_device_info *HwDeviceExtension)
 	/* OutPortLong(0xcf8, base); */
 	/* Temp = (InPortLong(0xcfc) & 0xFFFF); */
 	/* if (Temp == 0x1039) { */
-	xgifb_reg_set(pVBInfo->P3c4, 0x22, (unsigned char) ((*pVBInfo->pSR22) & 0xFE));
+	xgifb_reg_set(pVBInfo->P3c4,
+		      0x22,
+		      (unsigned char) ((*pVBInfo->pSR22) & 0xFE));
 	/* } else { */
 	/*	xgifb_reg_set(pVBInfo->P3c4, 0x22, *pVBInfo->pSR22); */
 	/* } */
diff --git a/drivers/staging/xgifb/vb_init.h b/drivers/staging/xgifb/vb_init.h
index b47352b..6b77230 100644
--- a/drivers/staging/xgifb/vb_init.h
+++ b/drivers/staging/xgifb/vb_init.h
@@ -1,7 +1,6 @@
-#ifndef  _VBINIT_
-#define  _VBINIT_
-extern   unsigned char    XGIInitNew(struct xgi_hw_device_info *HwDeviceExtension) ;
+#ifndef _VBINIT_
+#define _VBINIT_
+extern unsigned char XGIInitNew(struct xgi_hw_device_info *HwDeviceExtension);
 extern struct XGI21_LVDSCapStruct  XGI21_LCDCapList[13];
-
 #endif
 
-- 
1.7.1

