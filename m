Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753166Ab2GaNJc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 09:09:32 -0400
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:50763
	"EHLO mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751914Ab2GaNJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 09:09:31 -0400
X-IronPort-AV: E=Sophos;i="4.77,686,1336341600"; 
   d="scan'208";a="152116290"
Date: Tue, 31 Jul 2012 15:09:28 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To: Lars-Peter Clausen <lars@metafoo.de>
cc: Julia Lawall <Julia.Lawall@lip6.fr>, Jonathan Cameron <jic23@cam.ac.uk>,
        kernel-janitors@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/iio/adc/at91_adc.c: use devm_ functions
In-Reply-To: <5017D148.6030006@metafoo.de>
Message-ID: <alpine.DEB.2.02.1207311509040.1894@hadrien>
References: <1343729383-30073-1-git-send-email-Julia.Lawall@lip6.fr> <5017D148.6030006@metafoo.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

The various devm_ functions allocate memory that is released when a driver
detaches.  This patch uses these functions for data that is allocated in
the probe function of a platform device and is only freed in the remove
function.

The call to platform_get_resource(pdev, IORESOURCE_MEM, 0) is moved coser
to the call to devm_request_and_ioremap, which is th first use of the
result of platform_get_resource.

This does not use devm_request_irq to ensure that free_irq is executed
before its idev argument is freed.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/iio/adc/at91_adc.c |   41 ++++++++---------------------------------
 1 file changed, 8 insertions(+), 33 deletions(-)

diff --git a/drivers/iio/adc/at91_adc.c b/drivers/iio/adc/at91_adc.c
index f61780a..3506e3d 100644
--- a/drivers/iio/adc/at91_adc.c
+++ b/drivers/iio/adc/at91_adc.c
@@ -545,13 +545,6 @@ static int __devinit at91_adc_probe(struct platform_device *pdev)
 		goto error_free_device;
 	}

-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res) {
-		dev_err(&pdev->dev, "No resource defined\n");
-		ret = -ENXIO;
-		goto error_ret;
-	}
-
 	platform_set_drvdata(pdev, idev);

 	idev->dev.parent = &pdev->dev;
@@ -566,18 +559,13 @@ static int __devinit at91_adc_probe(struct platform_device *pdev)
 		goto error_free_device;
 	}

-	if (!request_mem_region(res->start, resource_size(res),
-				"AT91 adc registers")) {
-		dev_err(&pdev->dev, "Resources are unavailable.\n");
-		ret = -EBUSY;
-		goto error_free_device;
-	}
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);

-	st->reg_base = ioremap(res->start, resource_size(res));
+	st->reg_base = devm_request_and_ioremap(&pdev->dev, res);
 	if (!st->reg_base) {
 		dev_err(&pdev->dev, "Failed to map registers.\n");
 		ret = -ENOMEM;
-		goto error_release_mem;
+		goto error_free_device;
 	}

 	/*
@@ -592,10 +580,10 @@ static int __devinit at91_adc_probe(struct platform_device *pdev)
 			  idev);
 	if (ret) {
 		dev_err(&pdev->dev, "Failed to allocate IRQ.\n");
-		goto error_unmap_reg;
+		goto error_free_device;
 	}

-	st->clk = clk_get(&pdev->dev, "adc_clk");
+	st->clk = devm_clk_get(&pdev->dev, "adc_clk");
 	if (IS_ERR(st->clk)) {
 		dev_err(&pdev->dev, "Failed to get the clock.\n");
 		ret = PTR_ERR(st->clk);
@@ -605,7 +593,7 @@ static int __devinit at91_adc_probe(struct platform_device *pdev)
 	ret = clk_prepare(st->clk);
 	if (ret) {
 		dev_err(&pdev->dev, "Could not prepare the clock.\n");
-		goto error_free_clk;
+		goto error_free_irq;
 	}

 	ret = clk_enable(st->clk);
@@ -614,7 +602,7 @@ static int __devinit at91_adc_probe(struct platform_device *pdev)
 		goto error_unprepare_clk;
 	}

-	st->adc_clk = clk_get(&pdev->dev, "adc_op_clk");
+	st->adc_clk = devm_clk_get(&pdev->dev, "adc_op_clk");
 	if (IS_ERR(st->adc_clk)) {
 		dev_err(&pdev->dev, "Failed to get the ADC clock.\n");
 		ret = PTR_ERR(st->clk);
@@ -624,7 +612,7 @@ static int __devinit at91_adc_probe(struct platform_device *pdev)
 	ret = clk_prepare(st->adc_clk);
 	if (ret) {
 		dev_err(&pdev->dev, "Could not prepare the ADC clock.\n");
-		goto error_free_adc_clk;
+		goto error_disable_clk;
 	}

 	ret = clk_enable(st->adc_clk);
@@ -697,20 +685,12 @@ error_disable_adc_clk:
 	clk_disable(st->adc_clk);
 error_unprepare_adc_clk:
 	clk_unprepare(st->adc_clk);
-error_free_adc_clk:
-	clk_put(st->adc_clk);
 error_disable_clk:
 	clk_disable(st->clk);
 error_unprepare_clk:
 	clk_unprepare(st->clk);
-error_free_clk:
-	clk_put(st->clk);
 error_free_irq:
 	free_irq(st->irq, idev);
-error_unmap_reg:
-	iounmap(st->reg_base);
-error_release_mem:
-	release_mem_region(res->start, resource_size(res));
 error_free_device:
 	iio_device_free(idev);
 error_ret:
@@ -720,20 +700,15 @@ error_ret:
 static int __devexit at91_adc_remove(struct platform_device *pdev)
 {
 	struct iio_dev *idev = platform_get_drvdata(pdev);
-	struct resource *res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	struct at91_adc_state *st = iio_priv(idev);

 	iio_device_unregister(idev);
 	at91_adc_trigger_remove(idev);
 	at91_adc_buffer_remove(idev);
 	clk_disable_unprepare(st->adc_clk);
-	clk_put(st->adc_clk);
 	clk_disable(st->clk);
 	clk_unprepare(st->clk);
-	clk_put(st->clk);
 	free_irq(st->irq, idev);
-	iounmap(st->reg_base);
-	release_mem_region(res->start, resource_size(res));
 	iio_device_free(idev);

 	return 0;

