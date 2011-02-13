Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754561Ab1BMLvS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Feb 2011 06:51:18 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:58491 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754270Ab1BMLui (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Feb 2011 06:50:38 -0500
From: Julia Lawall <julia@diku.dk>
To: Deepak Saxena <dsaxena@plexity.net>
Cc: kernel-janitors@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] drivers/char/hw_random/omap-rng.c: Convert release_resource to release_region/release_mem_region
Date: Sun, 13 Feb 2011 13:12:09 +0100
Message-Id: <1297599132-7226-3-git-send-email-julia@diku.dk>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1297599132-7226-1-git-send-email-julia@diku.dk>
References: <1297599132-7226-1-git-send-email-julia@diku.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Request_region should be used with release_region, not release_resource.

The local variable mem, storing the result of request_mem_region, is
dropped and instead the pointer res is stored in the drvdata field of the
platform device.  This information is retrieved in omap_rng_remove to
release the region.  The drvdata field is not used elsewhere.

The semantic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression x,E;
@@
(
*x = request_region(...)
|
*x = request_mem_region(...)
)
... when != release_region(x)
    when != x = E
* release_resource(x);
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
Not compiled.

 drivers/char/hw_random/omap-rng.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/char/hw_random/omap-rng.c b/drivers/char/hw_random/omap-rng.c
index 06aad08..2cc755a 100644
--- a/drivers/char/hw_random/omap-rng.c
+++ b/drivers/char/hw_random/omap-rng.c
@@ -91,7 +91,7 @@ static struct hwrng omap_rng_ops = {
 
 static int __devinit omap_rng_probe(struct platform_device *pdev)
 {
-	struct resource *res, *mem;
+	struct resource *res;
 	int ret;
 
 	/*
@@ -116,14 +116,12 @@ static int __devinit omap_rng_probe(struct platform_device *pdev)
 	if (!res)
 		return -ENOENT;
 
-	mem = request_mem_region(res->start, resource_size(res),
-				 pdev->name);
-	if (mem == NULL) {
+	if (!request_mem_region(res->start, resource_size(res), pdev->name)) {
 		ret = -EBUSY;
 		goto err_region;
 	}
 
-	dev_set_drvdata(&pdev->dev, mem);
+	dev_set_drvdata(&pdev->dev, res);
 	rng_base = ioremap(res->start, resource_size(res));
 	if (!rng_base) {
 		ret = -ENOMEM;
@@ -146,7 +144,7 @@ err_register:
 	iounmap(rng_base);
 	rng_base = NULL;
 err_ioremap:
-	release_resource(mem);
+	release_mem_region(res->start, resource_size(res));
 err_region:
 	if (cpu_is_omap24xx()) {
 		clk_disable(rng_ick);
@@ -157,7 +155,7 @@ err_region:
 
 static int __exit omap_rng_remove(struct platform_device *pdev)
 {
-	struct resource *mem = dev_get_drvdata(&pdev->dev);
+	struct resource *res = dev_get_drvdata(&pdev->dev);
 
 	hwrng_unregister(&omap_rng_ops);
 
@@ -170,7 +168,7 @@ static int __exit omap_rng_remove(struct platform_device *pdev)
 		clk_put(rng_ick);
 	}
 
-	release_resource(mem);
+	release_mem_region(res->start, resource_size(res));
 	rng_base = NULL;
 
 	return 0;

