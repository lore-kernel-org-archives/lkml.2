Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753015Ab2DRMg4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 08:36:56 -0400
Received: from relay.sigmatic.fi ([80.69.161.51]:37464 "EHLO relay.sigmatic.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751917Ab2DRMgz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 08:36:55 -0400
From: Hannu Heikkinen <hannuxx@iki.fi>
To: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Cc: grant.likely@secretlab.ca, mika.westerberg@iki.fi
Subject: [PATCH] spi/ep93xx: clean probe/remove routines
Date: Wed, 18 Apr 2012 15:36:11 +0300
Message-Id: <1334752571-24627-1-git-send-email-hannuxx@iki.fi>
X-Mailer: git-send-email 1.7.9.5
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_* functions for managing devres resources.

Also use local espi_irq and remove irq variable from
struct ep93xx_spi.

Cc: mika.westerberg@iki.fi
Cc: grant.likely@secretlab.ca
Signed-off-by: Hannu Heikkinen <hannuxx@iki.fi>
---
 drivers/spi/spi-ep93xx.c |   36 ++++++++++--------------------------
 1 file changed, 10 insertions(+), 26 deletions(-)

diff --git a/drivers/spi/spi-ep93xx.c b/drivers/spi/spi-ep93xx.c
index 6db2887..2c5fb81 100644
--- a/drivers/spi/spi-ep93xx.c
+++ b/drivers/spi/spi-ep93xx.c
@@ -114,7 +114,6 @@ struct ep93xx_spi {
 	struct clk			*clk;
 	void __iomem			*regs_base;
 	unsigned long			sspdr_phys;
-	int				irq;
 	unsigned long			min_rate;
 	unsigned long			max_rate;
 	bool				running;
@@ -1035,6 +1034,7 @@ static int __devinit ep93xx_spi_probe(struct platform_device *pdev)
 	struct ep93xx_spi_info *info;
 	struct ep93xx_spi *espi;
 	struct resource *res;
+	int espi_irq;
 	int error;
 
 	info = pdev->dev.platform_data;
@@ -1074,8 +1074,8 @@ static int __devinit ep93xx_spi_probe(struct platform_device *pdev)
 	espi->min_rate = clk_get_rate(espi->clk) / (254 * 256);
 	espi->pdev = pdev;
 
-	espi->irq = platform_get_irq(pdev, 0);
-	if (espi->irq < 0) {
+	espi_irq = platform_get_irq(pdev, 0);
+	if (espi_irq < 0) {
 		error = -EBUSY;
 		dev_err(&pdev->dev, "failed to get irq resources\n");
 		goto fail_put_clock;
@@ -1088,26 +1088,20 @@ static int __devinit ep93xx_spi_probe(struct platform_device *pdev)
 		goto fail_put_clock;
 	}
 
-	res = request_mem_region(res->start, resource_size(res), pdev->name);
-	if (!res) {
-		dev_err(&pdev->dev, "unable to request iomem resources\n");
-		error = -EBUSY;
-		goto fail_put_clock;
-	}
-
 	espi->sspdr_phys = res->start + SSPDR;
-	espi->regs_base = ioremap(res->start, resource_size(res));
+
+	espi->regs_base = devm_request_and_ioremap(&pdev->dev, res);
 	if (!espi->regs_base) {
 		dev_err(&pdev->dev, "failed to map resources\n");
 		error = -ENODEV;
-		goto fail_free_mem;
+		goto fail_put_clock;
 	}
 
-	error = request_irq(espi->irq, ep93xx_spi_interrupt, 0,
-			    "ep93xx-spi", espi);
+	error = devm_request_irq(&pdev->dev, espi_irq, ep93xx_spi_interrupt, 0,
+				"ep93xx-spi", espi);
 	if (error) {
 		dev_err(&pdev->dev, "failed to request irq\n");
-		goto fail_unmap_regs;
+		goto fail_put_clock;
 	}
 
 	if (info->use_dma && ep93xx_spi_setup_dma(espi))
@@ -1132,7 +1126,7 @@ static int __devinit ep93xx_spi_probe(struct platform_device *pdev)
 	}
 
 	dev_info(&pdev->dev, "EP93xx SPI Controller at 0x%08lx irq %d\n",
-		 (unsigned long)res->start, espi->irq);
+		 (unsigned long)res->start, espi_irq);
 
 	return 0;
 
@@ -1140,11 +1134,6 @@ fail_free_queue:
 	destroy_workqueue(espi->wq);
 fail_free_dma:
 	ep93xx_spi_release_dma(espi);
-	free_irq(espi->irq, espi);
-fail_unmap_regs:
-	iounmap(espi->regs_base);
-fail_free_mem:
-	release_mem_region(res->start, resource_size(res));
 fail_put_clock:
 	clk_put(espi->clk);
 fail_release_master:
@@ -1158,7 +1147,6 @@ static int __devexit ep93xx_spi_remove(struct platform_device *pdev)
 {
 	struct spi_master *master = platform_get_drvdata(pdev);
 	struct ep93xx_spi *espi = spi_master_get_devdata(master);
-	struct resource *res;
 
 	spin_lock_irq(&espi->lock);
 	espi->running = false;
@@ -1184,10 +1172,6 @@ static int __devexit ep93xx_spi_remove(struct platform_device *pdev)
 	spin_unlock_irq(&espi->lock);
 
 	ep93xx_spi_release_dma(espi);
-	free_irq(espi->irq, espi);
-	iounmap(espi->regs_base);
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	release_mem_region(res->start, resource_size(res));
 	clk_put(espi->clk);
 	platform_set_drvdata(pdev, NULL);
 
-- 
1.7.9.5

