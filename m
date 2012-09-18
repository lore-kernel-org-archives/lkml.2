Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932799Ab2IRMIP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 08:08:15 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:60032 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757190Ab2IRMIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 08:08:11 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: FlorianSchandinat@gmx.de
Cc: paul.gortmaker@windriver.com, hsweeten@visionengravers.com, agust@denx.de,
        davidb@codeaurora.org, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Peter Senna Tschudin <peter.senna@gmail.com>
Subject: [PATCH 01/10] drivers/video/mb862xx/mb862xxfbdrv.c: fix error return code
Date: Tue, 18 Sep 2012 14:07:51 +0200
Message-Id: <1347970080-25175-1-git-send-email-peter.senna@gmail.com>
X-Mailer: git-send-email 1.7.11.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Senna Tschudin <peter.senna@gmail.com>

Convert a nonnegative error return code to a negative one, as returned
elsewhere in the function.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
(
if@p1 (\(ret < 0\|ret != 0\))
 { ... return ret; }
|
ret@p1 = 0
)
... when != ret = e1
    when != &ret
*if(...)
{
  ... when != ret = e2
      when forall
 return ret;
}
// </smpl>

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
---
 drivers/video/mb862xx/mb862xxfbdrv.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/video/mb862xx/mb862xxfbdrv.c b/drivers/video/mb862xx/mb862xxfbdrv.c
index 57d940b..d68e332 100644
--- a/drivers/video/mb862xx/mb862xxfbdrv.c
+++ b/drivers/video/mb862xx/mb862xxfbdrv.c
@@ -1052,12 +1052,14 @@ static int __devinit mb862xx_pci_probe(struct pci_dev *pdev,
 		break;
 	default:
 		/* should never occur */
+		ret = -EIO;
 		goto rel_reg;
 	}
 
 	par->fb_base = ioremap(par->fb_base_phys, par->mapped_vram);
 	if (par->fb_base == NULL) {
 		dev_err(dev, "Cannot map framebuffer\n");
+		ret = -EIO;
 		goto rel_reg;
 	}
 
@@ -1073,11 +1075,13 @@ static int __devinit mb862xx_pci_probe(struct pci_dev *pdev,
 	dev_dbg(dev, "mmio phys 0x%llx 0x%lx\n",
 		(unsigned long long)par->mmio_base_phys, (ulong)par->mmio_len);
 
-	if (mb862xx_pci_gdc_init(par))
+	ret = mb862xx_pci_gdc_init(par);
+	if (ret)
 		goto io_unmap;
 
-	if (request_irq(par->irq, mb862xx_intr, IRQF_SHARED,
-			DRV_NAME, (void *)par)) {
+	ret = request_irq(par->irq, mb862xx_intr, IRQF_SHARED,
+			  DRV_NAME, (void *)par);
+	if (ret) {
 		dev_err(dev, "Cannot request irq\n");
 		goto io_unmap;
 	}
-- 
1.7.11.4

