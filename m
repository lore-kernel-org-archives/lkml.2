Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752619Ab1HJGCV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 02:02:21 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:36927 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751241Ab1HJGCU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 02:02:20 -0400
From: Julia Lawall <julia@diku.dk>
To: Jiandong Zheng <jdzheng@broadcom.com>
Cc: kernel-janitors@vger.kernel.org, Scott Branden <sbranden@broadcom.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] drivers/mtd/nand/bcm_umi_nand.c: add missing kfree/iounmap
Date: Wed, 10 Aug 2011 08:02:14 +0200
Message-Id: <1312956134-27553-1-git-send-email-julia@diku.dk>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Add kfree and iounmap systematically in all error handling code, including
under #if.

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/mtd/nand/bcm_umi_nand.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/mtd/nand/bcm_umi_nand.c b/drivers/mtd/nand/bcm_umi_nand.c
index a8ae898..8cb567b 100644
--- a/drivers/mtd/nand/bcm_umi_nand.c
+++ b/drivers/mtd/nand/bcm_umi_nand.c
@@ -374,8 +374,10 @@ static int __devinit bcm_umi_nand_probe(struct platform_device *pdev)
 
 	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 
-	if (!r)
+	if (!r) {
+		kfree(board_mtd);
 		return -ENXIO;
+	}
 
 	/* map physical address */
 	bcm_umi_io_base = ioremap(r->start, resource_size(r));
@@ -433,8 +435,11 @@ static int __devinit bcm_umi_nand_probe(struct platform_device *pdev)
 
 #if USE_DMA
 	err = nand_dma_init();
-	if (err != 0)
+	if (err != 0) {
+		iounmap(bcm_umi_io_base);
+		kfree(board_mtd);
 		return err;
+	}
 #endif
 
 	/* Figure out the size of the device that we have.
@@ -466,6 +471,8 @@ static int __devinit bcm_umi_nand_probe(struct platform_device *pdev)
 		{
 			printk(KERN_ERR "NAND - Unrecognized pagesize: %d\n",
 					 board_mtd->writesize);
+			iounmap(bcm_umi_io_base);
+			kfree(board_mtd);
 			return -EINVAL;
 		}
 	}

