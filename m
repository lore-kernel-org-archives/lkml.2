Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756481Ab1BQV33 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 16:29:29 -0500
Received: from filtteri5.pp.htv.fi ([213.243.153.188]:34387 "EHLO
	filtteri5.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758121Ab1BQV3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 16:29:17 -0500
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: arnaud.patard@rtp-net.org, gregkh@suse.de, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/7] staging: xgifb: fix some memory leaks
Date: Thu, 17 Feb 2011 23:29:12 +0200
Message-Id: <1297978157-14927-2-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1297978157-14927-1-git-send-email-aaro.koskinen@iki.fi>
References: <1297978157-14927-1-git-send-email-aaro.koskinen@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some xgifb_probe() error paths are missing proper vfree()s. Move them
all into a single place.

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
---
 drivers/staging/xgifb/XGI_main_26.c |    9 ++-------
 1 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/xgifb/XGI_main_26.c b/drivers/staging/xgifb/XGI_main_26.c
index c245de4..2328926 100644
--- a/drivers/staging/xgifb/XGI_main_26.c
+++ b/drivers/staging/xgifb/XGI_main_26.c
@@ -3065,7 +3065,6 @@ static int __devinit xgifb_probe(struct pci_dev *pdev,
 
 	XGIhw_ext.pCR = vmalloc(sizeof(struct XGI_DSReg) * CR_BUFFER_SIZE);
 	if (XGIhw_ext.pCR == NULL) {
-		vfree(XGIhw_ext.pSR);
 		printk(KERN_ERR "XGIfb: Fatal error: Allocating CRReg space failed.\n");
 		ret = -ENODEV;
 		goto error;
@@ -3105,8 +3104,6 @@ static int __devinit xgifb_probe(struct pci_dev *pdev,
 	}
 #endif
 	if (XGIfb_get_dram_size()) {
-		vfree(XGIhw_ext.pSR);
-		vfree(XGIhw_ext.pCR);
 		printk(KERN_INFO "XGIfb: Fatal error: Unable to determine RAM size.\n");
 		ret = -ENODEV;
 		goto error;
@@ -3125,8 +3122,6 @@ static int __devinit xgifb_probe(struct pci_dev *pdev,
 		printk("unable request memory size %x", xgi_video_info.video_size);
 		printk(KERN_ERR "XGIfb: Fatal error: Unable to reserve frame buffer memory\n");
 		printk(KERN_ERR "XGIfb: Is there another framebuffer driver active?\n");
-		vfree(XGIhw_ext.pSR);
-		vfree(XGIhw_ext.pCR);
 		ret = -ENODEV;
 		goto error;
 	}
@@ -3134,8 +3129,6 @@ static int __devinit xgifb_probe(struct pci_dev *pdev,
 	if (!request_mem_region(xgi_video_info.mmio_base, XGIfb_mmio_size, "XGIfb MMIO")) {
 		printk(KERN_ERR "XGIfb: Fatal error: Unable to reserve MMIO region\n");
 		release_mem_region(xgi_video_info.video_base, xgi_video_info.video_size);
-		vfree(XGIhw_ext.pSR);
-		vfree(XGIhw_ext.pCR);
 		ret = -ENODEV;
 		goto error;
 	}
@@ -3441,6 +3434,8 @@ static int __devinit xgifb_probe(struct pci_dev *pdev,
 	return 0;
 
 error:
+	vfree(XGIhw_ext.pSR);
+	vfree(XGIhw_ext.pCR);
 	framebuffer_release(fb_info);
 	return ret;
 }
-- 
1.5.6.5

