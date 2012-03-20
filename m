Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759337Ab2CTKaO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 06:30:14 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:44068 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758462Ab2CTKaL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 06:30:11 -0400
From: Shubhrajyoti D <shubhrajyoti@ti.com>
To: <spi-devel-general@lists.sourceforge.net>
CC: <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Shubhrajyoti D <shubhrajyoti@ti.com>, Felipe Balbi <balbi@ti.com>
Subject: [PATCH 3/3] spi: omap2-mcspi: use devm_* functions
Date: Tue, 20 Mar 2012 15:59:49 +0530
Message-ID: <1332239389-1897-4-git-send-email-shubhrajyoti@ti.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1332239389-1897-1-git-send-email-shubhrajyoti@ti.com>
References: <1332239389-1897-1-git-send-email-shubhrajyoti@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The various devm_* functions allocate memory that is released when a driver
detaches. This patch uses devm_request_and_ioremap
to request memory in probe function. Since the freeing is not
needed the calls are deleted from remove function.Also use
use devm_kzalloc for the cs memory allocation.

Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Shubhrajyoti D <shubhrajyoti@ti.com>
---
 drivers/spi/spi-omap2-mcspi.c |   24 ++++--------------------
 1 files changed, 4 insertions(+), 20 deletions(-)

diff --git a/drivers/spi/spi-omap2-mcspi.c b/drivers/spi/spi-omap2-mcspi.c
index 7745f91..cb2c0e3 100644
--- a/drivers/spi/spi-omap2-mcspi.c
+++ b/drivers/spi/spi-omap2-mcspi.c
@@ -789,7 +789,7 @@ static int omap2_mcspi_setup(struct spi_device *spi)
 	mcspi_dma = &mcspi->dma_channels[spi->chip_select];
 
 	if (!cs) {
-		cs = kzalloc(sizeof *cs, GFP_KERNEL);
+		cs = devm_kzalloc(&spi->dev , sizeof *cs, GFP_KERNEL);
 		if (!cs)
 			return -ENOMEM;
 		cs->base = mcspi->base + spi->chip_select * 0x14;
@@ -831,7 +831,6 @@ static void omap2_mcspi_cleanup(struct spi_device *spi)
 		cs = spi->controller_state;
 		list_del(&cs->node);
 
-		kfree(spi->controller_state);
 	}
 
 	if (spi->chip_select < spi->master->num_chipselect) {
@@ -1127,17 +1126,12 @@ static int __devinit omap2_mcspi_probe(struct platform_device *pdev)
 	r->start += pdata->regs_offset;
 	r->end += pdata->regs_offset;
 	mcspi->phys = r->start;
-	if (!request_mem_region(r->start, resource_size(r),
-				dev_name(&pdev->dev))) {
-		status = -EBUSY;
-		goto free_master;
-	}
 
-	mcspi->base = ioremap(r->start, resource_size(r));
+	mcspi->base = devm_request_and_ioremap(&pdev->dev, r);
 	if (!mcspi->base) {
 		dev_dbg(&pdev->dev, "can't ioremap MCSPI\n");
 		status = -ENOMEM;
-		goto release_region;
+		goto free_master;
 	}
 
 	mcspi->dev = &pdev->dev;
@@ -1152,7 +1146,7 @@ static int __devinit omap2_mcspi_probe(struct platform_device *pdev)
 			GFP_KERNEL);
 
 	if (mcspi->dma_channels == NULL)
-		goto unmap_io;
+		goto free_master;
 
 	for (i = 0; i < master->num_chipselect; i++) {
 		char dma_ch_name[14];
@@ -1202,10 +1196,6 @@ disable_pm:
 	pm_runtime_disable(&pdev->dev);
 dma_chnl_free:
 	kfree(mcspi->dma_channels);
-unmap_io:
-	iounmap(mcspi->base);
-release_region:
-	release_mem_region(r->start, resource_size(r));
 free_master:
 	kfree(master);
 	platform_set_drvdata(pdev, NULL);
@@ -1217,8 +1207,6 @@ static int __devexit omap2_mcspi_remove(struct platform_device *pdev)
 	struct spi_master	*master;
 	struct omap2_mcspi	*mcspi;
 	struct omap2_mcspi_dma	*dma_channels;
-	struct resource		*r;
-	void __iomem *base;
 
 	master = dev_get_drvdata(&pdev->dev);
 	mcspi = spi_master_get_devdata(master);
@@ -1226,12 +1214,8 @@ static int __devexit omap2_mcspi_remove(struct platform_device *pdev)
 
 	omap2_mcspi_disable_clocks(mcspi);
 	pm_runtime_disable(&pdev->dev);
-	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	release_mem_region(r->start, resource_size(r));
 
-	base = mcspi->base;
 	spi_unregister_master(master);
-	iounmap(base);
 	kfree(dma_channels);
 	destroy_workqueue(mcspi->wq);
 	platform_set_drvdata(pdev, NULL);
-- 
1.7.1

