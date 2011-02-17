Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758174Ab1BQV31 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 16:29:27 -0500
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:36212 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757870Ab1BQV3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 16:29:16 -0500
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: arnaud.patard@rtp-net.org, gregkh@suse.de, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/7] staging: xgifb: xgifb_probe() error paths missing framebuffer_release()
Date: Thu, 17 Feb 2011 23:29:11 +0200
Message-Id: <1297978157-14927-1-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

framebuffer_release() is missing from error paths.

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
---
 drivers/staging/xgifb/XGI_main_26.c |   39 +++++++++++++++++++++++++---------
 1 files changed, 28 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/xgifb/XGI_main_26.c b/drivers/staging/xgifb/XGI_main_26.c
index ee008e5..c245de4 100644
--- a/drivers/staging/xgifb/XGI_main_26.c
+++ b/drivers/staging/xgifb/XGI_main_26.c
@@ -2935,6 +2935,8 @@ static int __devinit xgifb_probe(struct pci_dev *pdev,
 	u16 reg16;
 	u8 reg, reg1;
 	u8 CR48, CR38;
+	int ret;
+
 	if (XGIfb_off)
 		return -ENXIO;
 
@@ -2966,8 +2968,10 @@ static int __devinit xgifb_probe(struct pci_dev *pdev,
 	printk("XGIfb: Relocate IO address: %lx [%08lx]\n",
 			(unsigned long)pci_resource_start(pdev, 2), XGI_Pr.RelIO);
 
-	if (pci_enable_device(pdev))
-		return -EIO;
+	if (pci_enable_device(pdev)) {
+		ret = -EIO;
+		goto error;
+	}
 
 	XGIRegInit(&XGI_Pr, (unsigned long)XGIhw_ext.pjIOAddress);
 
@@ -2976,7 +2980,8 @@ static int __devinit xgifb_probe(struct pci_dev *pdev,
 
 	if (reg1 != 0xa1) { /*I/O error */
 		printk("\nXGIfb: I/O error!!!");
-		return -EIO;
+		ret = -EIO;
+		goto error;
 	}
 
 	switch (xgi_video_info.chip_id) {
@@ -3011,7 +3016,8 @@ static int __devinit xgifb_probe(struct pci_dev *pdev,
 		XGIfb_CRT2_write_enable = IND_XGI_CRT2_WRITE_ENABLE_315;
 		break;
 	default:
-		return -ENODEV;
+		ret = -ENODEV;
+		goto error;
 	}
 
 	printk("XGIfb:chipid = %x\n", xgi_video_info.chip);
@@ -3052,7 +3058,8 @@ static int __devinit xgifb_probe(struct pci_dev *pdev,
 	XGIhw_ext.pSR = vmalloc(sizeof(struct XGI_DSReg) * SR_BUFFER_SIZE);
 	if (XGIhw_ext.pSR == NULL) {
 		printk(KERN_ERR "XGIfb: Fatal error: Allocating SRReg space failed.\n");
-		return -ENODEV;
+		ret = -ENODEV;
+		goto error;
 	}
 	XGIhw_ext.pSR[0].jIdx = XGIhw_ext.pSR[0].jVal = 0xFF;
 
@@ -3060,7 +3067,8 @@ static int __devinit xgifb_probe(struct pci_dev *pdev,
 	if (XGIhw_ext.pCR == NULL) {
 		vfree(XGIhw_ext.pSR);
 		printk(KERN_ERR "XGIfb: Fatal error: Allocating CRReg space failed.\n");
-		return -ENODEV;
+		ret = -ENODEV;
+		goto error;
 	}
 	XGIhw_ext.pCR[0].jIdx = XGIhw_ext.pCR[0].jVal = 0xFF;
 
@@ -3100,7 +3108,8 @@ static int __devinit xgifb_probe(struct pci_dev *pdev,
 		vfree(XGIhw_ext.pSR);
 		vfree(XGIhw_ext.pCR);
 		printk(KERN_INFO "XGIfb: Fatal error: Unable to determine RAM size.\n");
-		return -ENODEV;
+		ret = -ENODEV;
+		goto error;
 	}
 
 	if ((xgifb_mode_idx < 0) || ((XGIbios_mode[xgifb_mode_idx].mode_no) != 0xFF)) {
@@ -3118,7 +3127,8 @@ static int __devinit xgifb_probe(struct pci_dev *pdev,
 		printk(KERN_ERR "XGIfb: Is there another framebuffer driver active?\n");
 		vfree(XGIhw_ext.pSR);
 		vfree(XGIhw_ext.pCR);
-		return -ENODEV;
+		ret = -ENODEV;
+		goto error;
 	}
 
 	if (!request_mem_region(xgi_video_info.mmio_base, XGIfb_mmio_size, "XGIfb MMIO")) {
@@ -3126,7 +3136,8 @@ static int __devinit xgifb_probe(struct pci_dev *pdev,
 		release_mem_region(xgi_video_info.video_base, xgi_video_info.video_size);
 		vfree(XGIhw_ext.pSR);
 		vfree(XGIhw_ext.pCR);
-		return -ENODEV;
+		ret = -ENODEV;
+		goto error;
 	}
 
 	xgi_video_info.video_vbase = XGIhw_ext.pjVideoMemoryAddress =
@@ -3413,8 +3424,10 @@ static int __devinit xgifb_probe(struct pci_dev *pdev,
 			printk(KERN_INFO "XGIfb: Added MTRRs\n");
 #endif
 
-		if (register_framebuffer(fb_info) < 0)
-			return -EINVAL;
+		if (register_framebuffer(fb_info) < 0) {
+			ret = -EINVAL;
+			goto error;
+		}
 
 		XGIfb_registered = 1;
 
@@ -3426,6 +3439,10 @@ static int __devinit xgifb_probe(struct pci_dev *pdev,
 	dumpVGAReg();
 
 	return 0;
+
+error:
+	framebuffer_release(fb_info);
+	return ret;
 }
 
 /*****************************************************/
-- 
1.5.6.5

