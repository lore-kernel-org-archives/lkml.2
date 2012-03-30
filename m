Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933878Ab2C3KVO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 06:21:14 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:58973 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933814Ab2C3KUi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 06:20:38 -0400
From: Shubhrajyoti D <shubhrajyoti@ti.com>
To: <spi-devel-general@lists.sourceforge.net>
CC: <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Shubhrajyoti D <shubhrajyoti@ti.com>
Subject: [PATCHv3 4/6] spi: omap2-mcspi: use devm_* functions
Date: Fri, 30 Mar 2012 15:50:20 +0530
Message-ID: <1333102822-17171-5-git-send-email-shubhrajyoti@ti.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1333102822-17171-1-git-send-email-shubhrajyoti@ti.com>
References: <1333102822-17171-1-git-send-email-shubhrajyoti@ti.com>
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

Signed-off-by: Shubhrajyoti D <shubhrajyoti@ti.com>
---
 drivers/spi/spi-omap2-mcspi.c |   24 ++++--------------------
 1 files changed, 4 insertions(+), 20 deletions(-)

diff --git a/drivers/spi/spi-omap2-mcspi.c b/drivers/spi/spi-omap2-mcspi.c
index 66cbf22..1907ed2 100644
--- a/drivers/spi/spi-omap2-mcspi.c
+++ b/drivers/spi/spi-omap2-mcspi.c
@@ -787,7 +787,7 @@ static int omap2_mcspi_setup(struct spi_device *spi)
 	mcspi_dma = &mcspi->dma_channels[spi->chip_select];
 
 	if (!cs) {
-		cs = kzalloc(sizeof *cs, GFP_KERNEL);
+		cs = devm_kzalloc(&spi->dev , sizeof *cs, GFP_KERNEL);
 		if (!cs)
 			return -ENOMEM;
 		cs->base = mcspi->base + spi->chip_select * 0x14;
@@ -828,7 +828,6 @@ static void omap2_mcspi_cleanup(struct spi_device *spi)
 		cs = spi->controller_state;
 		list_del(&cs->node);
 
-		kfree(spi->controller_state);
 	}
 
 	if (spi->chip_select < spi->master->num_chipselect) {
@@ -1160,17 +1159,12 @@ static int __devinit omap2_mcspi_probe(struct platform_device *pdev)
 	r->start += regs_offset;
 	r->end += regs_offset;
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
@@ -1185,7 +1179,7 @@ static int __devinit omap2_mcspi_probe(struct platform_device *pdev)
 			GFP_KERNEL);
 
 	if (mcspi->dma_channels == NULL)
-		goto unmap_io;
+		goto free_master;
 
 	for (i = 0; i < master->num_chipselect; i++) {
 		char dma_ch_name[14];
@@ -1235,10 +1229,6 @@ disable_pm:
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
@@ -1250,8 +1240,6 @@ static int __devexit omap2_mcspi_remove(struct platform_device *pdev)
 	struct spi_master	*master;
 	struct omap2_mcspi	*mcspi;
 	struct omap2_mcspi_dma	*dma_channels;
-	struct resource		*r;
-	void __iomem *base;
 
 	master = dev_get_drvdata(&pdev->dev);
 	mcspi = spi_master_get_devdata(master);
@@ -1259,12 +1247,8 @@ static int __devexit omap2_mcspi_remove(struct platform_device *pdev)
 
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

