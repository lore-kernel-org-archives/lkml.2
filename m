Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752934Ab1CJVHy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 16:07:54 -0500
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:50418 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752004Ab1CJVCf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 16:02:35 -0500
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        arnaud.patard@rtp-net.org
Subject: [PATCH 01/22] staging: xgifb: vb_ext: move functions to avoid forward declarations
Date: Thu, 10 Mar 2011 23:02:26 +0200
Message-Id: <1299790967-7135-2-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1299790967-7135-1-git-send-email-aaro.koskinen@iki.fi>
References: <1299790967-7135-1-git-send-email-aaro.koskinen@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move functions to avoid forward declarations.

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
---
 drivers/staging/xgifb/vb_ext.c |  320 +++++++++++++++++++--------------------
 1 files changed, 156 insertions(+), 164 deletions(-)

diff --git a/drivers/staging/xgifb/vb_ext.c b/drivers/staging/xgifb/vb_ext.c
index 33a0635..6863fc2 100644
--- a/drivers/staging/xgifb/vb_ext.c
+++ b/drivers/staging/xgifb/vb_ext.c
@@ -9,14 +9,6 @@
 #include "vb_util.h"
 #include "vb_setmode.h"
 #include "vb_ext.h"
-static unsigned char XGINew_GetPanelID(struct vb_device_info *pVBInfo);
-static unsigned char XGINew_GetLCDDDCInfo(
-		struct xgi_hw_device_info *HwDeviceExtension,
-		struct vb_device_info *pVBInfo);
-static unsigned char XGINew_BridgeIsEnable(struct xgi_hw_device_info *,
-		struct vb_device_info *pVBInfo);
-static unsigned char XGINew_SenseHiTV(struct xgi_hw_device_info *HwDeviceExtension,
-		struct vb_device_info *pVBInfo);
 
 /**************************************************************
  *********************** Dynamic Sense ************************
@@ -58,162 +50,6 @@ static unsigned char XGINew_Sense(unsigned short tempbx, unsigned short tempcx,
 		return 0;
 }
 
-void XGI_GetSenseStatus(struct xgi_hw_device_info *HwDeviceExtension, struct vb_device_info *pVBInfo)
-{
-	unsigned short tempax = 0, tempbx, tempcx, temp, P2reg0 = 0, SenseModeNo = 0,
-			OutputSelect = *pVBInfo->pOutputSelect, ModeIdIndex, i;
-	pVBInfo->BaseAddr = (unsigned long) HwDeviceExtension->pjIOAddress;
-
-	if (pVBInfo->IF_DEF_LVDS == 1) {
-		tempax = XGINew_GetReg1(pVBInfo->P3c4, 0x1A); /* ynlai 02/27/2002 */
-		tempbx = XGINew_GetReg1(pVBInfo->P3c4, 0x1B);
-		tempax = ((tempax & 0xFE) >> 1) | (tempbx << 8);
-		if (tempax == 0x00) { /* Get Panel id from DDC */
-			temp = XGINew_GetLCDDDCInfo(HwDeviceExtension, pVBInfo);
-			if (temp == 1) { /* LCD connect */
-				XGINew_SetRegANDOR(pVBInfo->P3d4, 0x39, 0xFF, 0x01); /* set CR39 bit0="1" */
-				XGINew_SetRegANDOR(pVBInfo->P3d4, 0x37, 0xEF, 0x00); /* clean CR37 bit4="0" */
-				temp = LCDSense;
-			} else { /* LCD don't connect */
-				temp = 0;
-			}
-		} else {
-			XGINew_GetPanelID(pVBInfo);
-			temp = LCDSense;
-		}
-
-		tempbx = ~(LCDSense | AVIDEOSense | SVIDEOSense);
-		XGINew_SetRegANDOR(pVBInfo->P3d4, 0x32, tempbx, temp);
-	} else { /* for 301 */
-		if (pVBInfo->VBInfo & SetCRT2ToHiVisionTV) { /* for HiVision */
-			tempax = XGINew_GetReg1(pVBInfo->P3c4, 0x38);
-			temp = tempax & 0x01;
-			tempax = XGINew_GetReg1(pVBInfo->P3c4, 0x3A);
-			temp = temp | (tempax & 0x02);
-			XGINew_SetRegANDOR(pVBInfo->P3d4, 0x32, 0xA0, temp);
-		} else {
-			if (XGI_BridgeIsOn(pVBInfo)) {
-				P2reg0 = XGINew_GetReg1(pVBInfo->Part2Port, 0x00);
-				if (!XGINew_BridgeIsEnable(HwDeviceExtension, pVBInfo)) {
-					SenseModeNo = 0x2e;
-					/* XGINew_SetReg1(pVBInfo->P3d4, 0x30, 0x41); */
-					/* XGISetModeNew(HwDeviceExtension, 0x2e); // ynlai InitMode */
-
-					temp = XGI_SearchModeID(SenseModeNo, &ModeIdIndex, pVBInfo);
-					XGI_GetVGAType(HwDeviceExtension, pVBInfo);
-					XGI_GetVBType(pVBInfo);
-					pVBInfo->SetFlag = 0x00;
-					pVBInfo->ModeType = ModeVGA;
-					pVBInfo->VBInfo = SetCRT2ToRAMDAC | LoadDACFlag | SetInSlaveMode;
-					XGI_GetLCDInfo(0x2e, ModeIdIndex, pVBInfo);
-					XGI_GetTVInfo(0x2e, ModeIdIndex, pVBInfo);
-					XGI_EnableBridge(HwDeviceExtension, pVBInfo);
-					XGI_SetCRT2Group301(SenseModeNo, HwDeviceExtension, pVBInfo);
-					XGI_SetCRT2ModeRegs(0x2e, HwDeviceExtension, pVBInfo);
-					/* XGI_DisableBridge( HwDeviceExtension, pVBInfo ) ; */
-					XGINew_SetRegANDOR(pVBInfo->P3c4, 0x01, 0xDF, 0x20); /* Display Off 0212 */
-					for (i = 0; i < 20; i++)
-						XGI_LongWait(pVBInfo);
-				}
-				XGINew_SetReg1(pVBInfo->Part2Port, 0x00, 0x1c);
-				tempax = 0;
-				tempbx = *pVBInfo->pRGBSenseData;
-
-				if (!(XGINew_Is301B(pVBInfo)))
-					tempbx = *pVBInfo->pRGBSenseData2;
-
-				tempcx = 0x0E08;
-				if (XGINew_Sense(tempbx, tempcx, pVBInfo)) {
-					if (XGINew_Sense(tempbx, tempcx, pVBInfo))
-						tempax |= Monitor2Sense;
-				}
-
-				if (pVBInfo->VBType & VB_XGI301C)
-					XGINew_SetRegOR(pVBInfo->Part4Port, 0x0d, 0x04);
-
-				if (XGINew_SenseHiTV(HwDeviceExtension, pVBInfo)) { /* add by kuku for Multi-adapter sense HiTV */
-					tempax |= HiTVSense;
-					if ((pVBInfo->VBType & VB_XGI301C))
-						tempax ^= (HiTVSense | YPbPrSense);
-				}
-
-				if (!(tempax & (HiTVSense | YPbPrSense))) { /* start */
-
-					tempbx = *pVBInfo->pYCSenseData;
-
-					if (!(XGINew_Is301B(pVBInfo)))
-						tempbx = *pVBInfo->pYCSenseData2;
-
-					tempcx = 0x0604;
-					if (XGINew_Sense(tempbx, tempcx, pVBInfo)) {
-						if (XGINew_Sense(tempbx, tempcx, pVBInfo))
-							tempax |= SVIDEOSense;
-					}
-
-					if (OutputSelect & BoardTVType) {
-						tempbx = *pVBInfo->pVideoSenseData;
-
-						if (!(XGINew_Is301B(pVBInfo)))
-							tempbx = *pVBInfo->pVideoSenseData2;
-
-						tempcx = 0x0804;
-						if (XGINew_Sense(tempbx, tempcx, pVBInfo)) {
-							if (XGINew_Sense(tempbx, tempcx, pVBInfo))
-								tempax |= AVIDEOSense;
-						}
-					} else {
-						if (!(tempax & SVIDEOSense)) {
-							tempbx = *pVBInfo->pVideoSenseData;
-
-							if (!(XGINew_Is301B(pVBInfo)))
-								tempbx = *pVBInfo->pVideoSenseData2;
-
-							tempcx = 0x0804;
-							if (XGINew_Sense(tempbx, tempcx, pVBInfo)) {
-								if (XGINew_Sense(tempbx, tempcx, pVBInfo))
-									tempax |= AVIDEOSense;
-							}
-						}
-					}
-				}
-			} /* end */
-			if (!(tempax & Monitor2Sense)) {
-				if (XGINew_SenseLCD(HwDeviceExtension, pVBInfo))
-					tempax |= LCDSense;
-			}
-			tempbx = 0;
-			tempcx = 0;
-			XGINew_Sense(tempbx, tempcx, pVBInfo);
-
-			XGINew_SetRegANDOR(pVBInfo->P3d4, 0x32, ~0xDF, tempax);
-			XGINew_SetReg1(pVBInfo->Part2Port, 0x00, P2reg0);
-
-			if (!(P2reg0 & 0x20)) {
-				pVBInfo->VBInfo = DisableCRT2Display;
-				/* XGI_SetCRT2Group301(SenseModeNo, HwDeviceExtension, pVBInfo); */
-			}
-		}
-	}
-	XGI_DisableBridge(HwDeviceExtension, pVBInfo); /* shampoo 0226 */
-
-}
-
-unsigned short XGINew_SenseLCD(struct xgi_hw_device_info *HwDeviceExtension, struct vb_device_info *pVBInfo)
-{
-	/* unsigned short SoftSetting ; */
-	unsigned short temp;
-
-	if ((HwDeviceExtension->jChipType >= XG20) || (HwDeviceExtension->jChipType >= XG40))
-		temp = 0;
-	else
-		temp = XGINew_GetPanelID(pVBInfo);
-
-	if (!temp)
-		temp = XGINew_GetLCDDDCInfo(HwDeviceExtension, pVBInfo);
-
-	return temp;
-}
-
 static unsigned char XGINew_GetLCDDDCInfo(struct xgi_hw_device_info *HwDeviceExtension, struct vb_device_info *pVBInfo)
 {
 	unsigned short temp;
@@ -401,3 +237,159 @@ static unsigned char XGINew_SenseHiTV(struct xgi_hw_device_info *HwDeviceExtensi
 			return 0;
 	}
 }
+
+void XGI_GetSenseStatus(struct xgi_hw_device_info *HwDeviceExtension, struct vb_device_info *pVBInfo)
+{
+	unsigned short tempax = 0, tempbx, tempcx, temp, P2reg0 = 0, SenseModeNo = 0,
+			OutputSelect = *pVBInfo->pOutputSelect, ModeIdIndex, i;
+	pVBInfo->BaseAddr = (unsigned long) HwDeviceExtension->pjIOAddress;
+
+	if (pVBInfo->IF_DEF_LVDS == 1) {
+		tempax = XGINew_GetReg1(pVBInfo->P3c4, 0x1A); /* ynlai 02/27/2002 */
+		tempbx = XGINew_GetReg1(pVBInfo->P3c4, 0x1B);
+		tempax = ((tempax & 0xFE) >> 1) | (tempbx << 8);
+		if (tempax == 0x00) { /* Get Panel id from DDC */
+			temp = XGINew_GetLCDDDCInfo(HwDeviceExtension, pVBInfo);
+			if (temp == 1) { /* LCD connect */
+				XGINew_SetRegANDOR(pVBInfo->P3d4, 0x39, 0xFF, 0x01); /* set CR39 bit0="1" */
+				XGINew_SetRegANDOR(pVBInfo->P3d4, 0x37, 0xEF, 0x00); /* clean CR37 bit4="0" */
+				temp = LCDSense;
+			} else { /* LCD don't connect */
+				temp = 0;
+			}
+		} else {
+			XGINew_GetPanelID(pVBInfo);
+			temp = LCDSense;
+		}
+
+		tempbx = ~(LCDSense | AVIDEOSense | SVIDEOSense);
+		XGINew_SetRegANDOR(pVBInfo->P3d4, 0x32, tempbx, temp);
+	} else { /* for 301 */
+		if (pVBInfo->VBInfo & SetCRT2ToHiVisionTV) { /* for HiVision */
+			tempax = XGINew_GetReg1(pVBInfo->P3c4, 0x38);
+			temp = tempax & 0x01;
+			tempax = XGINew_GetReg1(pVBInfo->P3c4, 0x3A);
+			temp = temp | (tempax & 0x02);
+			XGINew_SetRegANDOR(pVBInfo->P3d4, 0x32, 0xA0, temp);
+		} else {
+			if (XGI_BridgeIsOn(pVBInfo)) {
+				P2reg0 = XGINew_GetReg1(pVBInfo->Part2Port, 0x00);
+				if (!XGINew_BridgeIsEnable(HwDeviceExtension, pVBInfo)) {
+					SenseModeNo = 0x2e;
+					/* XGINew_SetReg1(pVBInfo->P3d4, 0x30, 0x41); */
+					/* XGISetModeNew(HwDeviceExtension, 0x2e); // ynlai InitMode */
+
+					temp = XGI_SearchModeID(SenseModeNo, &ModeIdIndex, pVBInfo);
+					XGI_GetVGAType(HwDeviceExtension, pVBInfo);
+					XGI_GetVBType(pVBInfo);
+					pVBInfo->SetFlag = 0x00;
+					pVBInfo->ModeType = ModeVGA;
+					pVBInfo->VBInfo = SetCRT2ToRAMDAC | LoadDACFlag | SetInSlaveMode;
+					XGI_GetLCDInfo(0x2e, ModeIdIndex, pVBInfo);
+					XGI_GetTVInfo(0x2e, ModeIdIndex, pVBInfo);
+					XGI_EnableBridge(HwDeviceExtension, pVBInfo);
+					XGI_SetCRT2Group301(SenseModeNo, HwDeviceExtension, pVBInfo);
+					XGI_SetCRT2ModeRegs(0x2e, HwDeviceExtension, pVBInfo);
+					/* XGI_DisableBridge( HwDeviceExtension, pVBInfo ) ; */
+					XGINew_SetRegANDOR(pVBInfo->P3c4, 0x01, 0xDF, 0x20); /* Display Off 0212 */
+					for (i = 0; i < 20; i++)
+						XGI_LongWait(pVBInfo);
+				}
+				XGINew_SetReg1(pVBInfo->Part2Port, 0x00, 0x1c);
+				tempax = 0;
+				tempbx = *pVBInfo->pRGBSenseData;
+
+				if (!(XGINew_Is301B(pVBInfo)))
+					tempbx = *pVBInfo->pRGBSenseData2;
+
+				tempcx = 0x0E08;
+				if (XGINew_Sense(tempbx, tempcx, pVBInfo)) {
+					if (XGINew_Sense(tempbx, tempcx, pVBInfo))
+						tempax |= Monitor2Sense;
+				}
+
+				if (pVBInfo->VBType & VB_XGI301C)
+					XGINew_SetRegOR(pVBInfo->Part4Port, 0x0d, 0x04);
+
+				if (XGINew_SenseHiTV(HwDeviceExtension, pVBInfo)) { /* add by kuku for Multi-adapter sense HiTV */
+					tempax |= HiTVSense;
+					if ((pVBInfo->VBType & VB_XGI301C))
+						tempax ^= (HiTVSense | YPbPrSense);
+				}
+
+				if (!(tempax & (HiTVSense | YPbPrSense))) { /* start */
+
+					tempbx = *pVBInfo->pYCSenseData;
+
+					if (!(XGINew_Is301B(pVBInfo)))
+						tempbx = *pVBInfo->pYCSenseData2;
+
+					tempcx = 0x0604;
+					if (XGINew_Sense(tempbx, tempcx, pVBInfo)) {
+						if (XGINew_Sense(tempbx, tempcx, pVBInfo))
+							tempax |= SVIDEOSense;
+					}
+
+					if (OutputSelect & BoardTVType) {
+						tempbx = *pVBInfo->pVideoSenseData;
+
+						if (!(XGINew_Is301B(pVBInfo)))
+							tempbx = *pVBInfo->pVideoSenseData2;
+
+						tempcx = 0x0804;
+						if (XGINew_Sense(tempbx, tempcx, pVBInfo)) {
+							if (XGINew_Sense(tempbx, tempcx, pVBInfo))
+								tempax |= AVIDEOSense;
+						}
+					} else {
+						if (!(tempax & SVIDEOSense)) {
+							tempbx = *pVBInfo->pVideoSenseData;
+
+							if (!(XGINew_Is301B(pVBInfo)))
+								tempbx = *pVBInfo->pVideoSenseData2;
+
+							tempcx = 0x0804;
+							if (XGINew_Sense(tempbx, tempcx, pVBInfo)) {
+								if (XGINew_Sense(tempbx, tempcx, pVBInfo))
+									tempax |= AVIDEOSense;
+							}
+						}
+					}
+				}
+			} /* end */
+			if (!(tempax & Monitor2Sense)) {
+				if (XGINew_SenseLCD(HwDeviceExtension, pVBInfo))
+					tempax |= LCDSense;
+			}
+			tempbx = 0;
+			tempcx = 0;
+			XGINew_Sense(tempbx, tempcx, pVBInfo);
+
+			XGINew_SetRegANDOR(pVBInfo->P3d4, 0x32, ~0xDF, tempax);
+			XGINew_SetReg1(pVBInfo->Part2Port, 0x00, P2reg0);
+
+			if (!(P2reg0 & 0x20)) {
+				pVBInfo->VBInfo = DisableCRT2Display;
+				/* XGI_SetCRT2Group301(SenseModeNo, HwDeviceExtension, pVBInfo); */
+			}
+		}
+	}
+	XGI_DisableBridge(HwDeviceExtension, pVBInfo); /* shampoo 0226 */
+
+}
+
+unsigned short XGINew_SenseLCD(struct xgi_hw_device_info *HwDeviceExtension, struct vb_device_info *pVBInfo)
+{
+	/* unsigned short SoftSetting ; */
+	unsigned short temp;
+
+	if ((HwDeviceExtension->jChipType >= XG20) || (HwDeviceExtension->jChipType >= XG40))
+		temp = 0;
+	else
+		temp = XGINew_GetPanelID(pVBInfo);
+
+	if (!temp)
+		temp = XGINew_GetLCDDDCInfo(HwDeviceExtension, pVBInfo);
+
+	return temp;
+}
-- 
1.5.6.5

