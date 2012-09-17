Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756594Ab2IQOXm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 10:23:42 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:29453 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756458Ab2IQOXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 10:23:39 -0400
X-Greylist: delayed 566 seconds by postgrey-1.27 at vger.kernel.org; Mon, 17 Sep 2012 10:23:32 EDT
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhkCABEvV1BbdWObgWdsb2JhbABEvBUiAQEWJieCIAEBBSdSECAxPBsHEogEulqSCQOVYok1iVQ
X-IronPort-AV: E=Sophos;i="4.80,437,1344204000"; 
   d="scan'208";a="969870770"
From: "Javier M. Mellid" <jmunhoz@igalia.com>
To: gregkh@linuxfoundation.org, gewang@siliconmotion.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        "Javier M. Mellid" <jmunhoz@igalia.com>
Subject: [PATCH 7/7] staging: sm7xxfb: remove smtc_VRAMBaseAddress
Date: Mon, 17 Sep 2012 16:12:53 +0200
Message-Id: <1347891173-13916-8-git-send-email-jmunhoz@igalia.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1347891173-13916-1-git-send-email-jmunhoz@igalia.com>
References: <1347891173-13916-1-git-send-email-jmunhoz@igalia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Javier M. Mellid" <jmunhoz@igalia.com>

This patch erases smtc_VRAMBaseAddress variable.

Signed-off-by: Javier M. Mellid <jmunhoz@igalia.com>
---
 drivers/staging/sm7xxfb/sm7xxfb.c |   21 +++++++--------------
 1 file changed, 7 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/sm7xxfb/sm7xxfb.c b/drivers/staging/sm7xxfb/sm7xxfb.c
index 11fb9f5..f27182d 100644
--- a/drivers/staging/sm7xxfb/sm7xxfb.c
+++ b/drivers/staging/sm7xxfb/sm7xxfb.c
@@ -57,7 +57,6 @@ struct smtcfb_info {
 };
 
 void __iomem *smtc_RegBaseAddress;	/* Memory Map IO starting address */
-void __iomem *smtc_VRAMBaseAddress;	/* video memory starting address */
 
 static struct fb_var_screeninfo smtcfb_var = {
 	.xres           = 1024,
@@ -737,7 +736,7 @@ static int smtc_map_smem(struct smtcfb_info *sfb,
 
 	sfb->fb.fix.smem_len = smem_len;
 
-	sfb->fb.screen_base = smtc_VRAMBaseAddress;
+	sfb->fb.screen_base = sfb->lfb;
 
 	if (!sfb->fb.screen_base) {
 		dev_err(&pdev->dev,
@@ -825,23 +824,18 @@ static int __devinit smtcfb_pci_probe(struct pci_dev *pdev,
 		sfb->fb.fix.mmio_len = 0x00400000;
 		smem_size = SM712_VIDEOMEMORYSIZE;
 #ifdef __BIG_ENDIAN
-		sfb->lfb = (smtc_VRAMBaseAddress =
-		    ioremap(mmio_base, 0x00c00000));
+		sfb->lfb = ioremap(mmio_base, 0x00c00000);
 #else
-		sfb->lfb = (smtc_VRAMBaseAddress =
-		    ioremap(mmio_base, 0x00800000));
+		sfb->lfb = ioremap(mmio_base, 0x00800000);
 #endif
 		sfb->mmio = (smtc_RegBaseAddress =
-		    smtc_VRAMBaseAddress + 0x00700000);
-		sfb->dp_regs = smtc_VRAMBaseAddress + 0x00408000;
+		    sfb->lfb + 0x00700000);
+		sfb->dp_regs = sfb->lfb + 0x00408000;
 		sfb->vp_regs = sfb->lfb + 0x0040c000;
 #ifdef __BIG_ENDIAN
 		if (sfb->fb.var.bits_per_pixel == 32) {
-			smtc_VRAMBaseAddress += 0x800000;
 			sfb->lfb += 0x800000;
-			dev_info(&pdev->dev,
-				 "smtc_VRAMBaseAddress=%p sfb->lfb=%p",
-				  smtc_VRAMBaseAddress, sfb->lfb);
+			dev_info(&pdev->dev, "sfb->lfb=%p", sfb->lfb);
 		}
 #endif
 		if (!smtc_RegBaseAddress) {
@@ -869,8 +863,7 @@ static int __devinit smtcfb_pci_probe(struct pci_dev *pdev,
 		sfb->fb.fix.mmio_len = 0x00200000;
 		smem_size = SM722_VIDEOMEMORYSIZE;
 		sfb->dp_regs = ioremap(mmio_base, 0x00a00000);
-		sfb->lfb = (smtc_VRAMBaseAddress =
-		    sfb->dp_regs + 0x00200000);
+		sfb->lfb = sfb->dp_regs + 0x00200000;
 		sfb->mmio = (smtc_RegBaseAddress =
 		    sfb->dp_regs + 0x000c0000);
 		sfb->vp_regs = sfb->dp_regs + 0x800;
-- 
1.7.10.4

