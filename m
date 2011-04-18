Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756616Ab1DRTOc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 15:14:32 -0400
Received: from filtteri5.pp.htv.fi ([213.243.153.188]:48315 "EHLO
	filtteri5.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756539Ab1DRTOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 15:14:11 -0400
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        arnaud.patard@rtp-net.org
Subject: [PATCH 11/12] staging: xgifb: main: delete unused functions
Date: Mon, 18 Apr 2011 22:14:07 +0300
Message-Id: <1303154048-21989-12-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1303154048-21989-1-git-send-email-aaro.koskinen@iki.fi>
References: <1303154048-21989-1-git-send-email-aaro.koskinen@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Delete unused/dead code.

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
---
 drivers/staging/xgifb/XGI_main_26.c |  177 -----------------------------------
 1 files changed, 0 insertions(+), 177 deletions(-)

diff --git a/drivers/staging/xgifb/XGI_main_26.c b/drivers/staging/xgifb/XGI_main_26.c
index a6e9c60..3cffc20 100644
--- a/drivers/staging/xgifb/XGI_main_26.c
+++ b/drivers/staging/xgifb/XGI_main_26.c
@@ -424,61 +424,6 @@ unsigned char XGIfb_query_VGA_config_space(
 	return 1;
 }
 
-/*
-unsigned char XGIfb_query_north_bridge_space(struct xgi_hw_device_info *pXGIhw_ext,
-	unsigned long offset, unsigned long set, unsigned long *value)
-{
-	static struct pci_dev *pdev = NULL;
-	static unsigned char init = 0, valid_pdev = 0;
-	u16 nbridge_id = 0;
-
-	if (!init) {
-		init = 1;
-		switch (xgi_video_info.chip) {
-		case XGI_540:
-			nbridge_id = PCI_DEVICE_ID_XG_540;
-			break;
-		case XGI_630:
-			nbridge_id = PCI_DEVICE_ID_XG_630;
-			break;
-		case XGI_730:
-			nbridge_id = PCI_DEVICE_ID_XG_730;
-			break;
-		case XGI_550:
-			nbridge_id = PCI_DEVICE_ID_XG_550;
-			break;
-		case XGI_650:
-			nbridge_id = PCI_DEVICE_ID_XG_650;
-			break;
-		case XGI_740:
-			nbridge_id = PCI_DEVICE_ID_XG_740;
-			break;
-		default:
-			nbridge_id = 0;
-			break;
-		}
-
-		pdev = pci_get_device(PCI_VENDOR_ID_SI, nbridge_id, pdev);
-		if (pdev) {
-			valid_pdev = 1;
-			pci_dev_put(pdev);
-		}
-	}
-
-	if (!valid_pdev) {
-		printk(KERN_DEBUG "XGIfb: Can't find XGI %d North Bridge device.\n",
-			nbridge_id);
-		return 0;
-	}
-
-	if (set == 0)
-		pci_read_config_dword(pdev, offset, (u32 *)value);
-	else
-		pci_write_config_dword(pdev, offset, (u32)(*value));
-
-	return 1;
-}
-*/
 /* ------------------ Internal helper routines ----------------- */
 
 int XGIfb_GetXG21DefaultLVDSModeIdx(void)
@@ -1933,128 +1878,6 @@ static void XGIfb_get_VB_type(void)
 	}
 }
 
-/* ------------------ Sensing routines ------------------ */
-
-/* TW: Determine and detect attached devices on XGI30x */
-int XGIDoSense(int tempbl, int tempbh, int tempcl, int tempch)
-{
-	int temp, i;
-
-	xgifb_reg_set(XGIPART4, 0x11, tempbl);
-	temp = tempbh | tempcl;
-	xgifb_reg_and_or(XGIPART4, 0x10, 0xe0, temp);
-	for (i = 0; i < 10; i++)
-		XGI_LongWait(&XGI_Pr);
-	tempch &= 0x7f;
-	temp = xgifb_reg_get(XGIPART4, 0x03);
-	temp ^= 0x0e;
-	temp &= tempch;
-	return temp;
-}
-
-void XGI_Sense30x(void)
-{
-	u8 backupP4_0d;
-	u8 testsvhs_tempbl, testsvhs_tempbh;
-	u8 testsvhs_tempcl, testsvhs_tempch;
-	u8 testcvbs_tempbl, testcvbs_tempbh;
-	u8 testcvbs_tempcl, testcvbs_tempch;
-	u8 testvga2_tempbl, testvga2_tempbh;
-	u8 testvga2_tempcl, testvga2_tempch;
-	int myflag, result;
-
-	backupP4_0d = xgifb_reg_get(XGIPART4, 0x0d);
-	xgifb_reg_set(XGIPART4, 0x0d, (backupP4_0d | 0x04));
-
-	testvga2_tempbh = 0x00;
-	testvga2_tempbl = 0xd1;
-	testsvhs_tempbh = 0x00;
-	testsvhs_tempbl = 0xb9;
-	testcvbs_tempbh = 0x00;
-	testcvbs_tempbl = 0xb3;
-	if ((XGIhw_ext.ujVBChipID != VB_CHIP_301) && (XGIhw_ext.ujVBChipID
-			!= VB_CHIP_302)) {
-		testvga2_tempbh = 0x01;
-		testvga2_tempbl = 0x90;
-		testsvhs_tempbh = 0x01;
-		testsvhs_tempbl = 0x6b;
-		testcvbs_tempbh = 0x01;
-		testcvbs_tempbl = 0x74;
-		if (XGIhw_ext.ujVBChipID == VB_CHIP_301LV
-				|| XGIhw_ext.ujVBChipID == VB_CHIP_302LV) {
-			testvga2_tempbh = 0x00;
-			testvga2_tempbl = 0x00;
-			testsvhs_tempbh = 0x02;
-			testsvhs_tempbl = 0x00;
-			testcvbs_tempbh = 0x01;
-			testcvbs_tempbl = 0x00;
-		}
-	}
-	if (XGIhw_ext.ujVBChipID != VB_CHIP_301LV && XGIhw_ext.ujVBChipID
-			!= VB_CHIP_302LV) {
-		myflag = xgifb_reg_get(XGIPART4, 0x01);
-		if (myflag & 0x04) {
-			testvga2_tempbh = 0x00;
-			testvga2_tempbl = 0xfd;
-			testsvhs_tempbh = 0x00;
-			testsvhs_tempbl = 0xdd;
-			testcvbs_tempbh = 0x00;
-			testcvbs_tempbl = 0xee;
-		}
-	}
-	if ((XGIhw_ext.ujVBChipID == VB_CHIP_301LV) || (XGIhw_ext.ujVBChipID
-			== VB_CHIP_302LV)) {
-		testvga2_tempbh = 0x00;
-		testvga2_tempbl = 0x00;
-		testvga2_tempch = 0x00;
-		testvga2_tempcl = 0x00;
-		testsvhs_tempch = 0x04;
-		testsvhs_tempcl = 0x08;
-		testcvbs_tempch = 0x08;
-		testcvbs_tempcl = 0x08;
-	} else {
-		testvga2_tempch = 0x0e;
-		testvga2_tempcl = 0x08;
-		testsvhs_tempch = 0x06;
-		testsvhs_tempcl = 0x04;
-		testcvbs_tempch = 0x08;
-		testcvbs_tempcl = 0x04;
-	}
-
-	if (testvga2_tempch || testvga2_tempcl || testvga2_tempbh
-			|| testvga2_tempbl) {
-		result = XGIDoSense(testvga2_tempbl, testvga2_tempbh,
-				testvga2_tempcl, testvga2_tempch);
-		if (result) {
-			printk(KERN_INFO "XGIfb: Detected secondary VGA connection\n");
-			xgifb_reg_or(XGICR, 0x32, 0x10);
-		}
-	}
-
-	result = XGIDoSense(testsvhs_tempbl, testsvhs_tempbh, testsvhs_tempcl,
-			testsvhs_tempch);
-	if (result) {
-		printk(KERN_INFO "XGIfb: Detected TV connected to SVHS output\n");
-		/* TW: So we can be sure that there IS a SVHS output */
-		xgi_video_info.TV_plug = TVPLUG_SVIDEO;
-		xgifb_reg_or(XGICR, 0x32, 0x02);
-	}
-
-	if (!result) {
-		result = XGIDoSense(testcvbs_tempbl, testcvbs_tempbh,
-				testcvbs_tempcl, testcvbs_tempch);
-		if (result) {
-			printk(KERN_INFO "XGIfb: Detected TV connected to CVBS output\n");
-			/* TW: So we can be sure that there IS a CVBS output */
-			xgi_video_info.TV_plug = TVPLUG_COMPOSITE;
-			xgifb_reg_or(XGICR, 0x32, 0x01);
-		}
-	}
-	XGIDoSense(0, 0, 0, 0);
-
-	xgifb_reg_set(XGIPART4, 0x0d, backupP4_0d);
-}
-
 XGIINITSTATIC int __init XGIfb_setup(char *options)
 {
 	char *this_opt;
-- 
1.5.6.5

