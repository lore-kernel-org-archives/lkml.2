Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751960Ab1GCL0z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jul 2011 07:26:55 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:46434 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999Ab1GCL0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jul 2011 07:26:52 -0400
Date: Sun, 3 Jul 2011 15:26:47 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH -resend] ata: sata_dwc_460ex: fix error path
Message-ID: <20110703112647.GA3769@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed hsdev memleak on sata_dwc_probe() error.
As dma_dwc_exit() can be called multiple times without sata_dma_regs and
irq_dma changes, it might lead to double free on sequential
dma_dwc_exit() calls.  So, zero these fields after free calls.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
---
 drivers/ata/sata_dwc_460ex.c |   21 ++++++++++++++-------
 1 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/ata/sata_dwc_460ex.c b/drivers/ata/sata_dwc_460ex.c
index 1c4b3aa..6ca6f2c 100644
--- a/drivers/ata/sata_dwc_460ex.c
+++ b/drivers/ata/sata_dwc_460ex.c
@@ -766,11 +766,15 @@ static int dma_dwc_xfer_setup(struct scatterlist *sg, int num_elems,
 static void dma_dwc_exit(struct sata_dwc_device *hsdev)
 {
 	dev_dbg(host_pvt.dwc_dev, "%s:\n", __func__);
-	if (host_pvt.sata_dma_regs)
+	if (host_pvt.sata_dma_regs) {
 		iounmap(host_pvt.sata_dma_regs);
+		host_pvt.sata_dma_regs = NULL;
+	}
 
-	if (hsdev->irq_dma)
+	if (hsdev->irq_dma) {
 		free_irq(hsdev->irq_dma, hsdev);
+		hsdev->irq_dma = 0;
+	}
 }
 
 /*
@@ -1642,7 +1646,7 @@ static int sata_dwc_probe(struct platform_device *ofdev)
 	if (hsdev == NULL) {
 		dev_err(&ofdev->dev, "kmalloc failed for hsdev\n");
 		err = -ENOMEM;
-		goto error_out;
+		goto error;
 	}
 	memset(hsdev, 0, sizeof(*hsdev));
 
@@ -1652,7 +1656,7 @@ static int sata_dwc_probe(struct platform_device *ofdev)
 		dev_err(&ofdev->dev, "ioremap failed for SATA register"
 			" address\n");
 		err = -ENODEV;
-		goto error_out;
+		goto error_kmalloc;
 	}
 	hsdev->reg_base = base;
 	dev_dbg(&ofdev->dev, "ioremap done for SATA register address\n");
@@ -1665,7 +1669,7 @@ static int sata_dwc_probe(struct platform_device *ofdev)
 	if (!host) {
 		dev_err(&ofdev->dev, "ata_host_alloc_pinfo failed\n");
 		err = -ENOMEM;
-		goto error_out;
+		goto error_iomap;
 	}
 
 	host->private_data = hsdev;
@@ -1733,8 +1737,11 @@ error_out:
 	/* Free SATA DMA resources */
 	dma_dwc_exit(hsdev);
 
-	if (base)
-		iounmap(base);
+error_iomap:
+	iounmap(base);
+error_kmalloc:
+	kfree(hsdev);
+error:
 	return err;
 }
 
-- 
1.7.0.4
