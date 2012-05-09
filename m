Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759594Ab2EIO0d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 10:26:33 -0400
Received: from relay.sigmatic.fi ([80.69.161.51]:45812 "EHLO relay.sigmatic.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757995Ab2EIO0a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 10:26:30 -0400
From: Hannu Heikkinen <hannuxx@iki.fi>
To: linux-kernel@vger.kernel.org, spi-devel-general@lists.sourceforge.net
Cc: mika.westerberg@iki.fi, hsweeten@visionengravers.com
Subject: [PATCH v3 RESEND] spi/ep93xx: clean probe/remove routines
Date: Wed,  9 May 2012 17:26:26 +0300
Message-Id: <1336573586-9504-1-git-send-email-hannuxx@iki.fi>
X-Mailer: git-send-email 1.7.10
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_* functions for managing devres resources.

Also use local variable irq and remove irq variable from
struct ep93xx_spi, as it is needed only in probe routine.

Acked-by: Mika Westerberg <mika.westerberg@iki.fi>
Acked-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Signed-off-by: Hannu Heikkinen <hannuxx@iki.fi>
---
 drivers/spi/spi-ep93xx.c |   37 ++++++++++---------------------------
 1 file changed, 10 insertions(+), 27 deletions(-)

diff --git a/drivers/spi/spi-ep93xx.c b/drivers/spi/spi-ep93xx.c
index e805507..f97f1d2 100644
--- a/drivers/spi/spi-ep93xx.c
+++ b/drivers/spi/spi-ep93xx.c
@@ -76,7 +76,6 @@
  * @clk: clock for the controller
  * @regs_base: pointer to ioremap()'d registers
  * @sspdr_phys: physical address of the SSPDR register
- * @irq: IRQ number used by the driver
  * @min_rate: minimum clock rate (in Hz) supported by the controller
  * @max_rate: maximum clock rate (in Hz) supported by the controller
  * @running: is the queue running
@@ -114,7 +113,6 @@ struct ep93xx_spi {
 	struct clk			*clk;
 	void __iomem			*regs_base;
 	unsigned long			sspdr_phys;
-	int				irq;
 	unsigned long			min_rate;
 	unsigned long			max_rate;
 	bool				running;
@@ -1031,6 +1029,7 @@ static int __devinit ep93xx_spi_probe(struct platform_device *pdev)
 	struct ep93xx_spi_info *info;
 	struct ep93xx_spi *espi;
 	struct resource *res;
+	int irq;
 	int error;
 
 	info = pdev->dev.platform_data;
@@ -1070,8 +1069,8 @@ static int __devinit ep93xx_spi_probe(struct platform_device *pdev)
 	espi->min_rate = clk_get_rate(espi->clk) / (254 * 256);
 	espi->pdev = pdev;
 
-	espi->irq = platform_get_irq(pdev, 0);
-	if (espi->irq < 0) {
+	irq = platform_get_irq(pdev, 0);
+	if (irq < 0) {
 		error = -EBUSY;
 		dev_err(&pdev->dev, "failed to get irq resources\n");
 		goto fail_put_clock;
@@ -1084,26 +1083,20 @@ static int __devinit ep93xx_spi_probe(struct platform_device *pdev)
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
+	error = devm_request_irq(&pdev->dev, irq, ep93xx_spi_interrupt,
+				0, "ep93xx-spi", espi);
 	if (error) {
 		dev_err(&pdev->dev, "failed to request irq\n");
-		goto fail_unmap_regs;
+		goto fail_put_clock;
 	}
 
 	if (info->use_dma && ep93xx_spi_setup_dma(espi))
@@ -1128,7 +1121,7 @@ static int __devinit ep93xx_spi_probe(struct platform_device *pdev)
 	}
 
 	dev_info(&pdev->dev, "EP93xx SPI Controller at 0x%08lx irq %d\n",
-		 (unsigned long)res->start, espi->irq);
+		 (unsigned long)res->start, irq);
 
 	return 0;
 
@@ -1136,11 +1129,6 @@ fail_free_queue:
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
@@ -1154,7 +1142,6 @@ static int __devexit ep93xx_spi_remove(struct platform_device *pdev)
 {
 	struct spi_master *master = platform_get_drvdata(pdev);
 	struct ep93xx_spi *espi = spi_master_get_devdata(master);
-	struct resource *res;
 
 	spin_lock_irq(&espi->lock);
 	espi->running = false;
@@ -1180,10 +1167,6 @@ static int __devexit ep93xx_spi_remove(struct platform_device *pdev)
 	spin_unlock_irq(&espi->lock);
 
 	ep93xx_spi_release_dma(espi);
-	free_irq(espi->irq, espi);
-	iounmap(espi->regs_base);
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	release_mem_region(res->start, resource_size(res));
 	clk_put(espi->clk);
 	platform_set_drvdata(pdev, NULL);
 
-- 
1.7.10

