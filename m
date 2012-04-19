Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755919Ab2DSRTS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 13:19:18 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:59511 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754242Ab2DSRTR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 13:19:17 -0400
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Deepak Saxena <dsaxena@plexity.net>
Cc: kernel-janitors@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] drivers/char/hw_random/omap-rng.c: use devm_request_and_ioremap
Date: Thu, 19 Apr 2012 19:19:08 +0200
Message-Id: <1334855948-31146-1-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Using devm_request_and_ioremap is more concise.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/char/hw_random/omap-rng.c |   22 ++--------------------
 1 file changed, 2 insertions(+), 20 deletions(-)

diff --git a/drivers/char/hw_random/omap-rng.c b/drivers/char/hw_random/omap-rng.c
index a07a5ca..1412565 100644
--- a/drivers/char/hw_random/omap-rng.c
+++ b/drivers/char/hw_random/omap-rng.c
@@ -115,22 +115,12 @@ static int __devinit omap_rng_probe(struct platform_device *pdev)
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 
-	if (!res) {
-		ret = -ENOENT;
-		goto err_region;
-	}
-
-	if (!request_mem_region(res->start, resource_size(res), pdev->name)) {
-		ret = -EBUSY;
-		goto err_region;
-	}
-
-	dev_set_drvdata(&pdev->dev, res);
-	rng_base = ioremap(res->start, resource_size(res));
+	rng_base = devm_request_and_ioremap(&pdev->dev, res);
 	if (!rng_base) {
 		ret = -ENOMEM;
 		goto err_ioremap;
 	}
+	dev_set_drvdata(&pdev->dev, res);
 
 	ret = hwrng_register(&omap_rng_ops);
 	if (ret)
@@ -145,11 +135,8 @@ static int __devinit omap_rng_probe(struct platform_device *pdev)
 	return 0;
 
 err_register:
-	iounmap(rng_base);
 	rng_base = NULL;
 err_ioremap:
-	release_mem_region(res->start, resource_size(res));
-err_region:
 	if (cpu_is_omap24xx()) {
 		clk_disable(rng_ick);
 		clk_put(rng_ick);
@@ -159,20 +146,15 @@ err_region:
 
 static int __exit omap_rng_remove(struct platform_device *pdev)
 {
-	struct resource *res = dev_get_drvdata(&pdev->dev);
-
 	hwrng_unregister(&omap_rng_ops);
 
 	omap_rng_write_reg(RNG_MASK_REG, 0x0);
 
-	iounmap(rng_base);
-
 	if (cpu_is_omap24xx()) {
 		clk_disable(rng_ick);
 		clk_put(rng_ick);
 	}
 
-	release_mem_region(res->start, resource_size(res));
 	rng_base = NULL;
 
 	return 0;

