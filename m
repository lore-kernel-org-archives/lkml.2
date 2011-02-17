Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758205Ab1BQV3h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 16:29:37 -0500
Received: from filtteri5.pp.htv.fi ([213.243.153.188]:34400 "EHLO
	filtteri5.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758138Ab1BQV3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 16:29:18 -0500
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: arnaud.patard@rtp-net.org, gregkh@suse.de, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5/7] staging: xgifb: release and unmap I/O memory
Date: Thu, 17 Feb 2011 23:29:15 +0200
Message-Id: <1297978157-14927-5-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1297978157-14927-1-git-send-email-aaro.koskinen@iki.fi>
References: <1297978157-14927-1-git-send-email-aaro.koskinen@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Release and unmap memory on probe error paths and when the module
is removed.

The patch enables unloading and reloading the xgifb module.

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
---
 drivers/staging/xgifb/XGI_main_26.c |   17 ++++++++++++++---
 1 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/xgifb/XGI_main_26.c b/drivers/staging/xgifb/XGI_main_26.c
index 90dca40..f69ff57 100644
--- a/drivers/staging/xgifb/XGI_main_26.c
+++ b/drivers/staging/xgifb/XGI_main_26.c
@@ -3103,9 +3103,8 @@ static int __devinit xgifb_probe(struct pci_dev *pdev,
 
 	if (!request_mem_region(xgi_video_info.mmio_base, XGIfb_mmio_size, "XGIfb MMIO")) {
 		printk(KERN_ERR "XGIfb: Fatal error: Unable to reserve MMIO region\n");
-		release_mem_region(xgi_video_info.video_base, xgi_video_info.video_size);
 		ret = -ENODEV;
-		goto error;
+		goto error_0;
 	}
 
 	xgi_video_info.video_vbase = XGIhw_ext.pjVideoMemoryAddress =
@@ -3394,7 +3393,7 @@ static int __devinit xgifb_probe(struct pci_dev *pdev,
 
 		if (register_framebuffer(fb_info) < 0) {
 			ret = -EINVAL;
-			goto error;
+			goto error_1;
 		}
 
 		XGIfb_registered = 1;
@@ -3408,6 +3407,13 @@ static int __devinit xgifb_probe(struct pci_dev *pdev,
 
 	return 0;
 
+error_1:
+	iounmap(xgi_video_info.mmio_vbase);
+	iounmap(xgi_video_info.video_vbase);
+	release_mem_region(xgi_video_info.mmio_base, XGIfb_mmio_size);
+error_0:
+	release_mem_region(xgi_video_info.video_base,
+			   xgi_video_info.video_size);
 error:
 	vfree(XGIhw_ext.pjVirtualRomBase);
 	vfree(XGIhw_ext.pSR);
@@ -3425,6 +3431,11 @@ static void __devexit xgifb_remove(struct pci_dev *pdev)
 	/* Unregister the framebuffer */
 	/* if (xgi_video_info.registered) { */
 	unregister_framebuffer(fb_info);
+	iounmap(xgi_video_info.mmio_vbase);
+	iounmap(xgi_video_info.video_vbase);
+	release_mem_region(xgi_video_info.mmio_base, XGIfb_mmio_size);
+	release_mem_region(xgi_video_info.video_base,
+			   xgi_video_info.video_size);
 	vfree(XGIhw_ext.pjVirtualRomBase);
 	framebuffer_release(fb_info);
 	/* } */
-- 
1.5.6.5

