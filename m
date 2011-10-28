Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932437Ab1J1Log (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 07:44:36 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:60601 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755491Ab1J1Loe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 07:44:34 -0400
From: Shubhrajyoti D <shubhrajyoti@ti.com>
To: <spi-devel-general@lists.sourceforge.net>
CC: <linux-kernel@vger.kernel.org>, Shubhrajyoti D <shubhrajyoti@ti.com>,
        "Hebbar, Gururaja" <gururaja.hebbar@ti.com>
Subject: [PATCH 3/3] OMAP: SPI: Correct the error path
Date: Fri, 28 Oct 2011 17:14:19 +0530
Message-ID: <1319802259-16565-4-git-send-email-shubhrajyoti@ti.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1319802259-16565-1-git-send-email-shubhrajyoti@ti.com>
References: <1319802259-16565-1-git-send-email-shubhrajyoti@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently McSPI driver doesnt follow correct failure fallback steps
attempting to correct the same.
Also
-  label names changed  to give meaningful names.
- Setting the driver data to NULL in remove

Signed-off-by: Hebbar, Gururaja <gururaja.hebbar@ti.com>
Signed-off-by: Shubhrajyoti D <shubhrajyoti@ti.com>
---
 drivers/spi/spi-omap2-mcspi.c |   32 ++++++++++++++++++++------------
 1 files changed, 20 insertions(+), 12 deletions(-)

diff --git a/drivers/spi/spi-omap2-mcspi.c b/drivers/spi/spi-omap2-mcspi.c
index 6875a0b..abe2fee 100644
--- a/drivers/spi/spi-omap2-mcspi.c
+++ b/drivers/spi/spi-omap2-mcspi.c
@@ -1115,13 +1115,13 @@ static int __init omap2_mcspi_probe(struct platform_device *pdev)
 	mcspi->wq = alloc_workqueue(wq_name, WQ_MEM_RECLAIM, 1);
 	if (mcspi->wq == NULL) {
 		status = -ENOMEM;
-		goto err1;
+		goto free_master;
 	}
 
 	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (r == NULL) {
 		status = -ENODEV;
-		goto err1;
+		goto free_master;
 	}
 	r->start += pdata->regs_offset;
 	r->end += pdata->regs_offset;
@@ -1129,14 +1129,14 @@ static int __init omap2_mcspi_probe(struct platform_device *pdev)
 	if (!request_mem_region(r->start, resource_size(r),
 				dev_name(&pdev->dev))) {
 		status = -EBUSY;
-		goto err1;
+		goto free_master;
 	}
 
 	mcspi->base = ioremap(r->start, resource_size(r));
 	if (!mcspi->base) {
 		dev_dbg(&pdev->dev, "can't ioremap MCSPI\n");
 		status = -ENOMEM;
-		goto err2;
+		goto release_region;
 	}
 
 	mcspi->dev = &pdev->dev;
@@ -1151,7 +1151,7 @@ static int __init omap2_mcspi_probe(struct platform_device *pdev)
 			GFP_KERNEL);
 
 	if (mcspi->dma_channels == NULL)
-		goto err2;
+		goto unmap_io;
 
 	for (i = 0; i < master->num_chipselect; i++) {
 		char dma_ch_name[14];
@@ -1181,26 +1181,33 @@ static int __init omap2_mcspi_probe(struct platform_device *pdev)
 		mcspi->dma_channels[i].dma_tx_sync_dev = dma_res->start;
 	}
 
+	if (status < 0)
+		goto dma_chnl_free;
+
 	pm_runtime_enable(&pdev->dev);
 
 	if (status || omap2_mcspi_master_setup(mcspi) < 0)
-		goto err3;
+		goto disable_pm;
 
 	status = spi_register_master(master);
 	if (status < 0)
-		goto err4;
+		goto err_spi_register;
 
 	return status;
 
-err4:
+err_spi_register:
 	spi_master_put(master);
-err3:
+disable_pm:
 	pm_runtime_disable(&pdev->dev);
+dma_chnl_free:
 	kfree(mcspi->dma_channels);
-err2:
-	release_mem_region(r->start, resource_size(r));
+unmap_io:
 	iounmap(mcspi->base);
-err1:
+release_region:
+	release_mem_region(r->start, resource_size(r));
+free_master:
+	kfree(master);
+	platform_set_drvdata(pdev, NULL);
 	return status;
 }
 
@@ -1226,6 +1233,7 @@ static int __exit omap2_mcspi_remove(struct platform_device *pdev)
 	iounmap(base);
 	kfree(dma_channels);
 	destroy_workqueue(mcspi->wq);
+	platform_set_drvdata(pdev, NULL);
 
 	return 0;
 }
-- 
1.7.1

