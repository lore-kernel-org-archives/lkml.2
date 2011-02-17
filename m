Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758165Ab1BQVat (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 16:30:49 -0500
Received: from filtteri5.pp.htv.fi ([213.243.153.188]:34400 "EHLO
	filtteri5.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758143Ab1BQV3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 16:29:19 -0500
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: arnaud.patard@rtp-net.org, gregkh@suse.de, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 7/7] staging: xgifb: eliminate a global variable
Date: Thu, 17 Feb 2011 23:29:17 +0200
Message-Id: <1297978157-14927-7-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1297978157-14927-1-git-send-email-aaro.koskinen@iki.fi>
References: <1297978157-14927-1-git-send-email-aaro.koskinen@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the XGIfb_mmio_size global variable into the video_info struct.

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
---
 drivers/staging/xgifb/XGI_main.h    |    1 -
 drivers/staging/xgifb/XGI_main_26.c |   18 +++++++++++-------
 drivers/staging/xgifb/XGIfb.h       |    1 +
 3 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/xgifb/XGI_main.h b/drivers/staging/xgifb/XGI_main.h
index 72448e8..e8e2bfe 100644
--- a/drivers/staging/xgifb/XGI_main.h
+++ b/drivers/staging/xgifb/XGI_main.h
@@ -375,7 +375,6 @@ static struct xgi_hw_device_info XGIhw_ext;
 static struct vb_device_info  XGI_Pr;
 
 /* card parameters */
-static unsigned long XGIfb_mmio_size = 0;
 static u8            XGIfb_caps = 0;
 
 typedef enum _XGI_CMDTYPE {
diff --git a/drivers/staging/xgifb/XGI_main_26.c b/drivers/staging/xgifb/XGI_main_26.c
index 6e86830..7f821ae 100644
--- a/drivers/staging/xgifb/XGI_main_26.c
+++ b/drivers/staging/xgifb/XGI_main_26.c
@@ -1723,7 +1723,7 @@ static int XGIfb_get_fix(struct fb_fix_screeninfo *fix, int con,
 	fix->ywrapstep = 0;
 	fix->line_length = xgi_video_info.video_linelength;
 	fix->mmio_start = xgi_video_info.mmio_base;
-	fix->mmio_len = XGIfb_mmio_size;
+	fix->mmio_len = xgi_video_info.mmio_size;
 	if (xgi_video_info.chip >= XG40)
 		fix->accel = FB_ACCEL_XGI_XABRE;
 	else
@@ -2937,7 +2937,7 @@ static int __devinit xgifb_probe(struct pci_dev *pdev,
 
 	xgi_video_info.video_base = pci_resource_start(pdev, 0);
 	xgi_video_info.mmio_base = pci_resource_start(pdev, 1);
-	XGIfb_mmio_size = pci_resource_len(pdev, 1);
+	xgi_video_info.mmio_size = pci_resource_len(pdev, 1);
 	xgi_video_info.vga_base = pci_resource_start(pdev, 2) + 0x30;
 	XGIhw_ext.pjIOAddress = (unsigned char *)xgi_video_info.vga_base;
 	/* XGI_Pr.RelIO  = ioremap(pci_resource_start(pdev, 2), 128) + 0x30; */
@@ -3101,7 +3101,9 @@ static int __devinit xgifb_probe(struct pci_dev *pdev,
 		goto error;
 	}
 
-	if (!request_mem_region(xgi_video_info.mmio_base, XGIfb_mmio_size, "XGIfb MMIO")) {
+	if (!request_mem_region(xgi_video_info.mmio_base,
+				xgi_video_info.mmio_size,
+				"XGIfb MMIO")) {
 		printk(KERN_ERR "XGIfb: Fatal error: Unable to reserve MMIO region\n");
 		ret = -ENODEV;
 		goto error_0;
@@ -3109,13 +3111,15 @@ static int __devinit xgifb_probe(struct pci_dev *pdev,
 
 	xgi_video_info.video_vbase = XGIhw_ext.pjVideoMemoryAddress =
 	ioremap(xgi_video_info.video_base, xgi_video_info.video_size);
-	xgi_video_info.mmio_vbase = ioremap(xgi_video_info.mmio_base, XGIfb_mmio_size);
+	xgi_video_info.mmio_vbase = ioremap(xgi_video_info.mmio_base,
+					    xgi_video_info.mmio_size);
 
 	printk(KERN_INFO "XGIfb: Framebuffer at 0x%lx, mapped to 0x%p, size %dk\n",
 			xgi_video_info.video_base, xgi_video_info.video_vbase, xgi_video_info.video_size / 1024);
 
 	printk(KERN_INFO "XGIfb: MMIO at 0x%lx, mapped to 0x%p, size %ldk\n",
-			xgi_video_info.mmio_base, xgi_video_info.mmio_vbase, XGIfb_mmio_size / 1024);
+	       xgi_video_info.mmio_base, xgi_video_info.mmio_vbase,
+	       xgi_video_info.mmio_size / 1024);
 	printk("XGIfb: XGIInitNew() ...");
 	if (XGIInitNew(&XGIhw_ext))
 		printk("OK\n");
@@ -3410,7 +3414,7 @@ static int __devinit xgifb_probe(struct pci_dev *pdev,
 error_1:
 	iounmap(xgi_video_info.mmio_vbase);
 	iounmap(xgi_video_info.video_vbase);
-	release_mem_region(xgi_video_info.mmio_base, XGIfb_mmio_size);
+	release_mem_region(xgi_video_info.mmio_base, xgi_video_info.mmio_size);
 error_0:
 	release_mem_region(xgi_video_info.video_base,
 			   xgi_video_info.video_size);
@@ -3431,7 +3435,7 @@ static void __devexit xgifb_remove(struct pci_dev *pdev)
 	unregister_framebuffer(fb_info);
 	iounmap(xgi_video_info.mmio_vbase);
 	iounmap(xgi_video_info.video_vbase);
-	release_mem_region(xgi_video_info.mmio_base, XGIfb_mmio_size);
+	release_mem_region(xgi_video_info.mmio_base, xgi_video_info.mmio_size);
 	release_mem_region(xgi_video_info.video_base,
 			   xgi_video_info.video_size);
 	vfree(XGIhw_ext.pjVirtualRomBase);
diff --git a/drivers/staging/xgifb/XGIfb.h b/drivers/staging/xgifb/XGIfb.h
index ef86a64..bb4640a 100644
--- a/drivers/staging/xgifb/XGIfb.h
+++ b/drivers/staging/xgifb/XGIfb.h
@@ -161,6 +161,7 @@ struct video_info{
         unsigned long video_base;
         char  *       video_vbase;
         unsigned long mmio_base;
+	unsigned long mmio_size;
         char  *       mmio_vbase;
         unsigned long vga_base;
         unsigned long mtrr;
-- 
1.5.6.5

