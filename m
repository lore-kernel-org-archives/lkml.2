Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754425Ab3AGLva (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 06:51:30 -0500
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:44956 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753853Ab3AGLv3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 06:51:29 -0500
X-IronPort-AV: E=Sophos;i="4.84,423,1355094000"; 
   d="scan'208";a="188715315"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: kernel-janitors@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] drivers/media/platform/soc_camera/pxa_camera.c: use devm_ functions
Date: Mon,  7 Jan 2013 13:51:21 +0100
Message-Id: <1357563081-5308-1-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

This patch uses various devm_ functions for data that is allocated in the
probe function of a platform driver and is only freed in the remove
function.

This also fixes a checkpatch warning, removing a space before a \n in a
string.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
Not compiled.  This assumes that it is safe to move the free of the clk and
the irq after the calls to pxa_free_dma.

 drivers/media/platform/soc_camera/pxa_camera.c |   65 +++++--------------------
 1 file changed, 15 insertions(+), 50 deletions(-)

diff --git a/drivers/media/platform/soc_camera/pxa_camera.c b/drivers/media/platform/soc_camera/pxa_camera.c
index f91f7bf..5ebb2a1 100644
--- a/drivers/media/platform/soc_camera/pxa_camera.c
+++ b/drivers/media/platform/soc_camera/pxa_camera.c
@@ -1661,23 +1661,18 @@ static int pxa_camera_probe(struct platform_device *pdev)
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	irq = platform_get_irq(pdev, 0);
-	if (!res || irq < 0) {
-		err = -ENODEV;
-		goto exit;
-	}
+	if (!res || irq < 0)
+		return -ENODEV;
 
-	pcdev = kzalloc(sizeof(*pcdev), GFP_KERNEL);
+	pcdev = devm_kzalloc(&pdev->dev, sizeof(*pcdev), GFP_KERNEL);
 	if (!pcdev) {
 		dev_err(&pdev->dev, "Could not allocate pcdev\n");
-		err = -ENOMEM;
-		goto exit;
+		return -ENOMEM;
 	}
 
-	pcdev->clk = clk_get(&pdev->dev, NULL);
-	if (IS_ERR(pcdev->clk)) {
-		err = PTR_ERR(pcdev->clk);
-		goto exit_kfree;
-	}
+	pcdev->clk = devm_clk_get(&pdev->dev, NULL);
+	if (IS_ERR(pcdev->clk))
+		return PTR_ERR(pcdev->clk);
 
 	pcdev->res = res;
 
@@ -1715,17 +1710,9 @@ static int pxa_camera_probe(struct platform_device *pdev)
 	/*
 	 * Request the regions.
 	 */
-	if (!request_mem_region(res->start, resource_size(res),
-				PXA_CAM_DRV_NAME)) {
-		err = -EBUSY;
-		goto exit_clk;
-	}
-
-	base = ioremap(res->start, resource_size(res));
-	if (!base) {
-		err = -ENOMEM;
-		goto exit_release;
-	}
+	base = devm_request_and_ioremap(&pdev->dev, res);
+	if (!base)
+		return -ENOMEM;
 	pcdev->irq = irq;
 	pcdev->base = base;
 
@@ -1734,7 +1721,7 @@ static int pxa_camera_probe(struct platform_device *pdev)
 			      pxa_camera_dma_irq_y, pcdev);
 	if (err < 0) {
 		dev_err(&pdev->dev, "Can't request DMA for Y\n");
-		goto exit_iounmap;
+		return err;
 	}
 	pcdev->dma_chans[0] = err;
 	dev_dbg(&pdev->dev, "got DMA channel %d\n", pcdev->dma_chans[0]);
@@ -1762,10 +1749,10 @@ static int pxa_camera_probe(struct platform_device *pdev)
 	DRCMR(70) = pcdev->dma_chans[2] | DRCMR_MAPVLD;
 
 	/* request irq */
-	err = request_irq(pcdev->irq, pxa_camera_irq, 0, PXA_CAM_DRV_NAME,
-			  pcdev);
+	err = devm_request_irq(&pdev->dev, pcdev->irq, pxa_camera_irq, 0,
+			       PXA_CAM_DRV_NAME, pcdev);
 	if (err) {
-		dev_err(&pdev->dev, "Camera interrupt register failed \n");
+		dev_err(&pdev->dev, "Camera interrupt register failed\n");
 		goto exit_free_dma;
 	}
 
@@ -1777,27 +1764,16 @@ static int pxa_camera_probe(struct platform_device *pdev)
 
 	err = soc_camera_host_register(&pcdev->soc_host);
 	if (err)
-		goto exit_free_irq;
+		goto exit_free_dma;
 
 	return 0;
 
-exit_free_irq:
-	free_irq(pcdev->irq, pcdev);
 exit_free_dma:
 	pxa_free_dma(pcdev->dma_chans[2]);
 exit_free_dma_u:
 	pxa_free_dma(pcdev->dma_chans[1]);
 exit_free_dma_y:
 	pxa_free_dma(pcdev->dma_chans[0]);
-exit_iounmap:
-	iounmap(base);
-exit_release:
-	release_mem_region(res->start, resource_size(res));
-exit_clk:
-	clk_put(pcdev->clk);
-exit_kfree:
-	kfree(pcdev);
-exit:
 	return err;
 }
 
@@ -1806,24 +1782,13 @@ static int pxa_camera_remove(struct platform_device *pdev)
 	struct soc_camera_host *soc_host = to_soc_camera_host(&pdev->dev);
 	struct pxa_camera_dev *pcdev = container_of(soc_host,
 					struct pxa_camera_dev, soc_host);
-	struct resource *res;
-
-	clk_put(pcdev->clk);
 
 	pxa_free_dma(pcdev->dma_chans[0]);
 	pxa_free_dma(pcdev->dma_chans[1]);
 	pxa_free_dma(pcdev->dma_chans[2]);
-	free_irq(pcdev->irq, pcdev);
 
 	soc_camera_host_unregister(soc_host);
 
-	iounmap(pcdev->base);
-
-	res = pcdev->res;
-	release_mem_region(res->start, resource_size(res));
-
-	kfree(pcdev);
-
 	dev_info(&pdev->dev, "PXA Camera driver unloaded\n");
 
 	return 0;

