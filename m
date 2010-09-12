Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753661Ab0ILS5Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 14:57:16 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:52144 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753186Ab0ILS5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 14:57:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=qRo7Dp7IMvEpBlABrIg7v55um7kmTr4/rSU6CiQakIMZj0zKl0q/eYfr9o0OzCoH1p
         pWixUHezPjuknTrlyKG+KAaiPSm1r04EhF62VrwlOY99fipbgsBeJzjXr2jx2IjkV/Sx
         ojdcsmBid+q5sz1yNu0zJ3vVFmjSI9aDuGv30=
From: Vasiliy Kulikov <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Jeff Garzik <jgarzik@pobox.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
        Rupjyoti Sarmah <rsarmah@appliedmicro.com>,
        Prodyut Hazarika <phazarika@appliedmicro.com>,
        Grant Likely <grant.likely@secretlab.ca>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ata: sata_dwc_460ex: fix error path
Date: Sun, 12 Sep 2010 22:57:08 +0400
Message-Id: <1284317830-5022-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Free all allocated resources on error path.

Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
---
 I cannot compile this driver at all, so it is not tested.

 drivers/ata/sata_dwc_460ex.c |   21 ++++++++++++++-------
 1 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/ata/sata_dwc_460ex.c b/drivers/ata/sata_dwc_460ex.c
index 6cf57c5..ad0535f 100644
--- a/drivers/ata/sata_dwc_460ex.c
+++ b/drivers/ata/sata_dwc_460ex.c
@@ -727,11 +727,15 @@ static int dma_dwc_xfer_setup(struct scatterlist *sg, int num_elems,
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
@@ -1606,7 +1610,7 @@ static int sata_dwc_probe(struct platform_device *ofdev,
 	if (hsdev == NULL) {
 		dev_err(&ofdev->dev, "kmalloc failed for hsdev\n");
 		err = -ENOMEM;
-		goto error_out;
+		goto error;
 	}
 	memset(hsdev, 0, sizeof(*hsdev));
 
@@ -1616,7 +1620,7 @@ static int sata_dwc_probe(struct platform_device *ofdev,
 		dev_err(&ofdev->dev, "ioremap failed for SATA register"
 			" address\n");
 		err = -ENODEV;
-		goto error_out;
+		goto error_kmalloc;
 	}
 	hsdev->reg_base = base;
 	dev_dbg(&ofdev->dev, "ioremap done for SATA register address\n");
@@ -1629,7 +1633,7 @@ static int sata_dwc_probe(struct platform_device *ofdev,
 	if (!host) {
 		dev_err(&ofdev->dev, "ata_host_alloc_pinfo failed\n");
 		err = -ENOMEM;
-		goto error_out;
+		goto error_iomap;
 	}
 
 	host->private_data = hsdev;
@@ -1697,8 +1701,11 @@ error_out:
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

