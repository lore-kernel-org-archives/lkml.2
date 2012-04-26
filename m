Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758118Ab2DZSrT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 14:47:19 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:31178 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752598Ab2DZSqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 14:46:06 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAE+XmU9bdWOb/2dsb2JhbABFsXCBB4IKAQUnUhBRPBsHEogRuniQZQSVfZBAgmo
X-IronPort-AV: E=Sophos;i="4.75,487,1330902000"; 
   d="scan'208";a="981960573"
From: "Javier M. Mellid" <jmunhoz@igalia.com>
To: gregkh@linuxfoundation.org, gewang@siliconmotion.com,
        boyod.yang@siliconmotion.com.cn, wuzhangjin@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        "Javier M. Mellid" <jmunhoz@igalia.com>
Subject: [PATCH RESEND 4/7] staging: sm7xx: use dynamic debug support to show info and errors
Date: Thu, 26 Apr 2012 20:45:52 +0200
Message-Id: <1335465955-32057-5-git-send-email-jmunhoz@igalia.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <20120425205532.GA9642@kroah.com>
References: <20120425205532.GA9642@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes happy checkpatch script. It uses dynamic debug support
to show info and errors. It unifies the way to report messages in the
same way that debug messages.

Tested with SM712

Signed-off-by: Javier M. Mellid <jmunhoz@igalia.com>
---
 drivers/staging/sm7xx/smtcfb.c |   41 ++++++++++++++++++++-------------------
 1 files changed, 21 insertions(+), 20 deletions(-)

diff --git a/drivers/staging/sm7xx/smtcfb.c b/drivers/staging/sm7xx/smtcfb.c
index 69721c2..e351e08 100644
--- a/drivers/staging/sm7xx/smtcfb.c
+++ b/drivers/staging/sm7xx/smtcfb.c
@@ -736,17 +736,17 @@ static void smtc_unmap_mmio(struct smtcfb_info *sfb)
  */
 
 static int smtc_map_smem(struct smtcfb_info *sfb,
-		struct pci_dev *dev, u_long smem_len)
+		struct pci_dev *pdev, u_long smem_len)
 {
 	if (sfb->fb.var.bits_per_pixel == 32) {
 #ifdef __BIG_ENDIAN
-		sfb->fb.fix.smem_start = pci_resource_start(dev, 0)
+		sfb->fb.fix.smem_start = pci_resource_start(pdev, 0)
 			+ 0x800000;
 #else
-		sfb->fb.fix.smem_start = pci_resource_start(dev, 0);
+		sfb->fb.fix.smem_start = pci_resource_start(pdev, 0);
 #endif
 	} else {
-		sfb->fb.fix.smem_start = pci_resource_start(dev, 0);
+		sfb->fb.fix.smem_start = pci_resource_start(pdev, 0);
 	}
 
 	sfb->fb.fix.smem_len = smem_len;
@@ -754,8 +754,8 @@ static int smtc_map_smem(struct smtcfb_info *sfb,
 	sfb->fb.screen_base = smtc_VRAMBaseAddress;
 
 	if (!sfb->fb.screen_base) {
-		printk(KERN_ERR "%s: unable to map screen memory\n",
-				sfb->fb.fix.id);
+		dev_err(&pdev->dev,
+			"%s: unable to map screen memory\n", sfb->fb.fix.id);
 		return -ENOMEM;
 	}
 
@@ -835,8 +835,8 @@ static int __devinit smtcfb_pci_probe(struct pci_dev *pdev,
 	int err;
 	unsigned long pFramebufferPhysical;
 
-	printk(KERN_INFO
-		"Silicon Motion display driver " SMTC_LINUX_FB_VERSION "\n");
+	dev_info(&pdev->dev,
+		 "Silicon Motion display driver " SMTC_LINUX_FB_VERSION);
 
 	err = pci_enable_device(pdev);	/* enable SMTC chip */
 	if (err)
@@ -895,14 +895,14 @@ static int __devinit smtcfb_pci_probe(struct pci_dev *pdev,
 		if (sfb->fb.var.bits_per_pixel == 32) {
 			smtc_VRAMBaseAddress += 0x800000;
 			hw.m_pLFB += 0x800000;
-			printk(KERN_INFO
-				"\nsmtc_VRAMBaseAddress=%p hw.m_pLFB=%p\n",
-					smtc_VRAMBaseAddress, hw.m_pLFB);
+			dev_info(&pdev->dev,
+				 "smtc_VRAMBaseAddress=%p sfb->m_pLFB=%p",
+				  smtc_VRAMBaseAddress, sfb->m_pLFB);
 		}
 #endif
 		if (!smtc_RegBaseAddress) {
-			printk(KERN_ERR
-				"%s: unable to map memory mapped IO\n",
+			dev_err(&pdev->dev,
+				"%s: unable to map memory mapped IO!",
 				sfb->fb.fix.id);
 			err = -ENOMEM;
 			goto failed_fb;
@@ -936,8 +936,8 @@ static int __devinit smtcfb_pci_probe(struct pci_dev *pdev,
 		smtc_seqw(0x6b, 0x02);
 		break;
 	default:
-		printk(KERN_ERR
-		"No valid Silicon Motion display chip was detected!\n");
+		dev_err(&pdev->dev,
+			"No valid Silicon Motion display chip was detected!");
 
 		goto failed_fb;
 	}
@@ -961,15 +961,16 @@ static int __devinit smtcfb_pci_probe(struct pci_dev *pdev,
 	if (err < 0)
 		goto failed;
 
-	printk(KERN_INFO "Silicon Motion SM%X Rev%X primary display mode"
-			"%dx%d-%d Init Complete.\n", hw.chipID, hw.chipRevID,
-			sfb->fb.var.xres, sfb->fb.var.yres,
-			sfb->fb.var.bits_per_pixel);
+	dev_info(&pdev->dev,
+		"Silicon Motion SM%X Rev%X primary display mode"
+		"%dx%d-%d Init Complete.\n", hw.chipID, hw.chipRevID,
+		sfb->fb.var.xres, sfb->fb.var.yres,
+		sfb->fb.var.bits_per_pixel);
 
 	return 0;
 
 failed:
-	printk(KERN_ERR "Silicon Motion, Inc.  primary display init fail\n");
+	dev_err(&pdev->dev, "Silicon Motion, Inc. primary display init fail.");
 
 	smtc_unmap_smem(sfb);
 	smtc_unmap_mmio(sfb);
-- 
1.7.2.5

