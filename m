Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751884Ab2FRLM5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 07:12:57 -0400
Received: from smtp3.mundo-r.com ([212.51.32.191]:56246 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751573Ab2FRLMm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 07:12:42 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Am4CADoM309bdWObgWdsb2JhbABFhVewBCIBARYmJ4IZAQUjBAsBRhAlAiYCAlcHEogPpXKSBYEgj0CBEgOVJIkkiTs
X-IronPort-AV: E=Sophos;i="4.77,430,1336341600"; 
   d="scan'208";a="1004339253"
From: =?UTF-8?q?Miguel=20G=C3=B3mez?= <magomez@igalia.com>
To: arnaud.patard@rtp-net.org, gregkh@linuxfoundation.org,
        aaro.koskinen@iki.fi, dan.carpenter@oracle.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Miguel=20G=C3=B3mez?= <magomez@igalia.com>
Subject: [PATCH 8/8] Staging: xgifb: Replace pr_* with dev_* when possible.
Date: Mon, 18 Jun 2012 13:12:06 +0200
Message-Id: <b2045eb9d73cc3fba9b880154b4532025a27393d.1340016625.git.magomez@igalia.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1340016625.git.magomez@igalia.com>
References: <cover.1340016625.git.magomez@igalia.com>
In-Reply-To: <cover.1340016625.git.magomez@igalia.com>
References: <cover.1340016625.git.magomez@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace pr_* calls with dev_* ones when the device structure is available.

Signed-off-by: Miguel Gómez <magomez@igalia.com>
---
 drivers/staging/xgifb/XGI_main_26.c |   72 +++++++++++++++++++++--------------
 drivers/staging/xgifb/vb_init.c     |    4 +-
 2 files changed, 45 insertions(+), 31 deletions(-)

diff --git a/drivers/staging/xgifb/XGI_main_26.c b/drivers/staging/xgifb/XGI_main_26.c
index df6ef46..fe9061d 100644
--- a/drivers/staging/xgifb/XGI_main_26.c
+++ b/drivers/staging/xgifb/XGI_main_26.c
@@ -1838,9 +1838,9 @@ static int __devinit xgifb_probe(struct pci_dev *pdev,
 	xgifb_info->mmio_base = pci_resource_start(pdev, 1);
 	xgifb_info->mmio_size = pci_resource_len(pdev, 1);
 	xgifb_info->vga_base = pci_resource_start(pdev, 2) + 0x30;
-	pr_info("Relocate IO address: %Lx [%08lx]\n",
-	       (u64) pci_resource_start(pdev, 2),
-	       xgifb_info->vga_base);
+	dev_info(&pdev->dev, "Relocate IO address: %Lx [%08lx]\n",
+		 (u64) pci_resource_start(pdev, 2),
+		 xgifb_info->vga_base);
 
 	if (pci_enable_device(pdev)) {
 		ret = -EIO;
@@ -1858,7 +1858,7 @@ static int __devinit xgifb_probe(struct pci_dev *pdev,
 	reg1 = xgifb_reg_get(XGISR, IND_SIS_PASSWORD);
 
 	if (reg1 != 0xa1) { /*I/O error */
-		pr_err("I/O error!!!");
+		dev_err(&pdev->dev, "I/O error!!!");
 		ret = -EIO;
 		goto error_disable;
 	}
@@ -1886,11 +1886,12 @@ static int __devinit xgifb_probe(struct pci_dev *pdev,
 		goto error_disable;
 	}
 
-	pr_info("chipid = %x\n", xgifb_info->chip);
+	dev_info(&pdev->dev, "chipid = %x\n", xgifb_info->chip);
 	hw_info->jChipType = xgifb_info->chip;
 
 	if (XGIfb_get_dram_size(xgifb_info)) {
-		pr_err("Fatal error: Unable to determine RAM size.\n");
+		dev_err(&pdev->dev,
+			"Fatal error: Unable to determine RAM size.\n");
 		ret = -ENODEV;
 		goto error_disable;
 	}
@@ -1907,10 +1908,11 @@ static int __devinit xgifb_probe(struct pci_dev *pdev,
 	if (!request_mem_region(xgifb_info->video_base,
 				xgifb_info->video_size,
 				"XGIfb FB")) {
-		pr_err("unable request memory size %x\n",
+		dev_err(&pdev->dev, "unable request memory size %x\n",
 		       xgifb_info->video_size);
-		pr_err("Fatal error: Unable to reserve frame buffer memory\n");
-		pr_err("Is there another framebuffer driver active?\n");
+		dev_err(&pdev->dev,
+			"Fatal error: Unable to reserve frame buffer memory. "
+			"Is there another framebuffer driver active?\n");
 		ret = -ENODEV;
 		goto error_disable;
 	}
@@ -1918,7 +1920,8 @@ static int __devinit xgifb_probe(struct pci_dev *pdev,
 	if (!request_mem_region(xgifb_info->mmio_base,
 				xgifb_info->mmio_size,
 				"XGIfb MMIO")) {
-		pr_err("Fatal error: Unable to reserve MMIO region\n");
+		dev_err(&pdev->dev,
+			"Fatal error: Unable to reserve MMIO region\n");
 		ret = -ENODEV;
 		goto error_0;
 	}
@@ -1928,18 +1931,20 @@ static int __devinit xgifb_probe(struct pci_dev *pdev,
 	xgifb_info->mmio_vbase = ioremap(xgifb_info->mmio_base,
 					    xgifb_info->mmio_size);
 
-	pr_info("Framebuffer at 0x%Lx, mapped to 0x%p, size %dk\n",
-	       (u64) xgifb_info->video_base,
-	       xgifb_info->video_vbase,
-	       xgifb_info->video_size / 1024);
+	dev_info(&pdev->dev,
+		 "Framebuffer at 0x%Lx, mapped to 0x%p, size %dk\n",
+		 (u64) xgifb_info->video_base,
+		 xgifb_info->video_vbase,
+		 xgifb_info->video_size / 1024);
 
-	pr_info("MMIO at 0x%Lx, mapped to 0x%p, size %ldk\n",
-	       (u64) xgifb_info->mmio_base, xgifb_info->mmio_vbase,
-	       xgifb_info->mmio_size / 1024);
+	dev_info(&pdev->dev,
+		 "MMIO at 0x%Lx, mapped to 0x%p, size %ldk\n",
+		 (u64) xgifb_info->mmio_base, xgifb_info->mmio_vbase,
+		 xgifb_info->mmio_size / 1024);
 
 	pci_set_drvdata(pdev, xgifb_info);
 	if (!XGIInitNew(pdev))
-		pr_err("XGIInitNew() failed!\n");
+		dev_err(&pdev->dev, "XGIInitNew() failed!\n");
 
 	xgifb_info->mtrr = (unsigned int) 0;
 
@@ -1968,10 +1973,14 @@ static int __devinit xgifb_probe(struct pci_dev *pdev,
 		reg = xgifb_reg_get(XGIPART4, 0x01);
 		if (reg >= 0xE0) {
 			hw_info->ujVBChipID = VB_CHIP_302LV;
-			pr_info("XGI302LV bridge detected (revision 0x%02x)\n", reg);
+			dev_info(&pdev->dev,
+				 "XGI302LV bridge detected (revision 0x%02x)\n",
+				 reg);
 		} else if (reg >= 0xD0) {
 			hw_info->ujVBChipID = VB_CHIP_301LV;
-			pr_info("XGI301LV bridge detected (revision 0x%02x)\n", reg);
+			dev_info(&pdev->dev,
+				 "XGI301LV bridge detected (revision 0x%02x)\n",
+				 reg);
 		}
 		/* else if (reg >= 0xB0) {
 			hw_info->ujVBChipID = VB_CHIP_301B;
@@ -1980,17 +1989,21 @@ static int __devinit xgifb_probe(struct pci_dev *pdev,
 		} */
 		else {
 			hw_info->ujVBChipID = VB_CHIP_301;
-			pr_info("XGI301 bridge detected\n");
+			dev_info(&pdev->dev, "XGI301 bridge detected\n");
 		}
 		break;
 	case HASVB_302:
 		reg = xgifb_reg_get(XGIPART4, 0x01);
 		if (reg >= 0xE0) {
 			hw_info->ujVBChipID = VB_CHIP_302LV;
-			pr_info("XGI302LV bridge detected (revision 0x%02x)\n", reg);
+			dev_info(&pdev->dev,
+				 "XGI302LV bridge detected (revision 0x%02x)\n",
+				 reg);
 		} else if (reg >= 0xD0) {
 			hw_info->ujVBChipID = VB_CHIP_301LV;
-			pr_info("XGI302LV bridge detected (revision 0x%02x)\n", reg);
+			dev_info(&pdev->dev,
+				 "XGI302LV bridge detected (revision 0x%02x)\n",
+				 reg);
 		} else if (reg >= 0xB0) {
 			reg1 = xgifb_reg_get(XGIPART4, 0x23);
 
@@ -1998,27 +2011,28 @@ static int __devinit xgifb_probe(struct pci_dev *pdev,
 
 		} else {
 			hw_info->ujVBChipID = VB_CHIP_302;
-			pr_info("XGI302 bridge detected\n");
+			dev_info(&pdev->dev, "XGI302 bridge detected\n");
 		}
 		break;
 	case HASVB_LVDS:
 		hw_info->ulExternalChip = 0x1;
-		pr_info("LVDS transmitter detected\n");
+		dev_info(&pdev->dev, "LVDS transmitter detected\n");
 		break;
 	case HASVB_TRUMPION:
 		hw_info->ulExternalChip = 0x2;
-		pr_info("Trumpion Zurac LVDS scaler detected\n");
+		dev_info(&pdev->dev, "Trumpion Zurac LVDS scaler detected\n");
 		break;
 	case HASVB_CHRONTEL:
 		hw_info->ulExternalChip = 0x4;
-		pr_info("Chrontel TV encoder detected\n");
+		dev_info(&pdev->dev, "Chrontel TV encoder detected\n");
 		break;
 	case HASVB_LVDS_CHRONTEL:
 		hw_info->ulExternalChip = 0x5;
-		pr_info("LVDS transmitter and Chrontel TV encoder detected\n");
+		dev_info(&pdev->dev,
+			 "LVDS transmitter and Chrontel TV encoder detected\n");
 		break;
 	default:
-		pr_info("No or unknown bridge type detected\n");
+		dev_info(&pdev->dev, "No or unknown bridge type detected\n");
 		break;
 	}
 
diff --git a/drivers/staging/xgifb/vb_init.c b/drivers/staging/xgifb/vb_init.c
index 143957f..7c555a7 100644
--- a/drivers/staging/xgifb/vb_init.c
+++ b/drivers/staging/xgifb/vb_init.c
@@ -1319,11 +1319,11 @@ unsigned char XGIInitNew(struct pci_dev *pdev)
 	/* Newdebugcode(0x99); */
 
 	if (pVBInfo->FBAddr == NULL) {
-		pr_debug("pVBInfo->FBAddr == 0\n");
+		dev_dbg(&pdev->dev, "pVBInfo->FBAddr == 0\n");
 		return 0;
 	}
 	if (pVBInfo->BaseAddr == 0) {
-		pr_debug("pVBInfo->BaseAddr == 0\n");
+		dev_dbg(&pdev->dev, "pVBInfo->BaseAddr == 0\n");
 		return 0;
 	}
 
-- 
1.7.9.5

