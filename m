Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758015Ab1FVN6J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 09:58:09 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:34815 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757976Ab1FVN6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 09:58:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=qMpXYeaMj3pR8O1H5YcrUjcNYIr7dNNt6uL5H3MLtCzxDylviPNGiHUXtonZEcsF/4
         gsRqsqh99gopPhwS7t4T91wjvrBn9nhnXPeGcD+Iu6JjirS6VM83IQcQXLfWvTx7ovQ3
         PeiLK4LUaY6e90KhjCjPXZbYzvq/gyjPw7KF4=
Subject: [PATCH] spi: omap2-mcspi: fix omap2_mcspi_probe error handling
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Samuel Ortiz <sameo@linux.intel.com>, Juha Yrjola <juha.yrjola@nokia.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        spi-devel-general@lists.sourceforge.net
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 22 Jun 2011 21:57:57 +0800
Message-ID: <1308751077.4846.1.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch includes below fixes for error handling:
1. return proper error if kcalloc for mcspi->dma_channels fails
2. return proper error if omap2_mcspi_master_setup fails
3. properly release allocated resources in error paths and
   improve the naming of goto labels.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/spi/spi-omap2-mcspi.c |   39 +++++++++++++++++++++------------------
 1 files changed, 21 insertions(+), 18 deletions(-)

diff --git a/drivers/spi/spi-omap2-mcspi.c b/drivers/spi/spi-omap2-mcspi.c
index fde3a2d..74f444d 100644
--- a/drivers/spi/spi-omap2-mcspi.c
+++ b/drivers/spi/spi-omap2-mcspi.c
@@ -1087,7 +1087,7 @@ static int __init omap2_mcspi_probe(struct platform_device *pdev)
 	struct omap2_mcspi_platform_config *pdata = pdev->dev.platform_data;
 	struct omap2_mcspi	*mcspi;
 	struct resource		*r;
-	int			status = 0, i;
+	int			status, i;
 
 	master = spi_alloc_master(&pdev->dev, sizeof *mcspi);
 	if (master == NULL) {
@@ -1114,12 +1114,12 @@ static int __init omap2_mcspi_probe(struct platform_device *pdev)
 	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (r == NULL) {
 		status = -ENODEV;
-		goto err1;
+		goto err_put_master;
 	}
 	if (!request_mem_region(r->start, resource_size(r),
 				dev_name(&pdev->dev))) {
 		status = -EBUSY;
-		goto err1;
+		goto err_put_master;
 	}
 
 	r->start += pdata->regs_offset;
@@ -1129,7 +1129,7 @@ static int __init omap2_mcspi_probe(struct platform_device *pdev)
 	if (!mcspi->base) {
 		dev_dbg(&pdev->dev, "can't ioremap MCSPI\n");
 		status = -ENOMEM;
-		goto err2;
+		goto err_release_mem_region;
 	}
 
 	mcspi->dev = &pdev->dev;
@@ -1143,8 +1143,10 @@ static int __init omap2_mcspi_probe(struct platform_device *pdev)
 			sizeof(struct omap2_mcspi_dma),
 			GFP_KERNEL);
 
-	if (mcspi->dma_channels == NULL)
-		goto err2;
+	if (mcspi->dma_channels == NULL) {
+		status = -ENOMEM;
+		goto err_iounmap;
+	}
 
 	for (i = 0; i < master->num_chipselect; i++) {
 		char dma_ch_name[14];
@@ -1156,7 +1158,7 @@ static int __init omap2_mcspi_probe(struct platform_device *pdev)
 		if (!dma_res) {
 			dev_dbg(&pdev->dev, "cannot get DMA RX channel\n");
 			status = -ENODEV;
-			break;
+			goto err_free_dma_channels;
 		}
 
 		mcspi->dma_channels[i].dma_rx_channel = -1;
@@ -1167,7 +1169,7 @@ static int __init omap2_mcspi_probe(struct platform_device *pdev)
 		if (!dma_res) {
 			dev_dbg(&pdev->dev, "cannot get DMA TX channel\n");
 			status = -ENODEV;
-			break;
+			goto err_free_dma_channels;
 		}
 
 		mcspi->dma_channels[i].dma_tx_channel = -1;
@@ -1176,23 +1178,24 @@ static int __init omap2_mcspi_probe(struct platform_device *pdev)
 
 	pm_runtime_enable(&pdev->dev);
 
-	if (status || omap2_mcspi_master_setup(mcspi) < 0)
-		goto err3;
+	status = omap2_mcspi_master_setup(mcspi);
+	if (status)
+		goto err_free_dma_channels;
 
 	status = spi_register_master(master);
 	if (status < 0)
-		goto err4;
+		goto err_free_dma_channels;
 
-	return status;
+	return 0;
 
-err4:
-	spi_master_put(master);
-err3:
+err_free_dma_channels:
 	kfree(mcspi->dma_channels);
-err2:
-	release_mem_region(r->start, resource_size(r));
+err_iounmap:
 	iounmap(mcspi->base);
-err1:
+err_release_mem_region:
+	release_mem_region(r->start, resource_size(r));
+err_put_master:
+	spi_master_put(master);
 	return status;
 }
 
-- 
1.7.4.1



