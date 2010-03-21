Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753596Ab0CUUtG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 16:49:06 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:53258 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753369Ab0CUUtB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 16:49:01 -0400
Date: Sun, 21 Mar 2010 21:48:53 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: Eric Miao <eric.y.miao@gmail.com>, Russell King <linux@arm.linux.org.uk>,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH] arch/arm/mach-pxa: avoid NULL dereference in error handling
 code
Message-ID: <Pine.LNX.4.64.1003212147360.12371@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

The assignments of res to the results of the two calls to
platform_get_resource make it impossible to use res in the error handling
code in the arguments to release_mem_region.

At the same time, code of the form res->end - res->start + 1 is converted
to use resource_size.

The semantic match that finds the former problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@r exists@
expression E, E1;
identifier f;
statement S1,S3;
iterator iter;
@@

if ((E == NULL && ...) || ...)
{
  ... when != false ((E == NULL && ...) || ...)
      when != true  ((E != NULL && ...) || ...)
      when != iter(E,...) S1
      when != E = E1
(
  sizeof(E->f)
|
* E->f
)
  ... when any
  return ...;
}
else S3
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 arch/arm/mach-pxa/ssp.c             |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/arm/mach-pxa/ssp.c b/arch/arm/mach-pxa/ssp.c
index a81d6db..9fdbd38 100644
--- a/arch/arm/mach-pxa/ssp.c
+++ b/arch/arm/mach-pxa/ssp.c
@@ -349,6 +349,7 @@ static int __devinit ssp_probe(struct platform_device *pdev)
 {
 	const struct platform_device_id *id = platform_get_device_id(pdev);
 	struct resource *res;
+	struct resource *pres;
 	struct ssp_device *ssp;
 	int ret = 0;
 
@@ -372,8 +373,7 @@ static int __devinit ssp_probe(struct platform_device *pdev)
 		goto err_free_clk;
 	}
 
-	res = request_mem_region(res->start, res->end - res->start + 1,
-			pdev->name);
+	res = request_mem_region(res->start, resource_size(res), pdev->name);
 	if (res == NULL) {
 		dev_err(&pdev->dev, "failed to request memory resource\n");
 		ret = -EBUSY;
@@ -382,7 +382,7 @@ static int __devinit ssp_probe(struct platform_device *pdev)
 
 	ssp->phys_base = res->start;
 
-	ssp->mmio_base = ioremap(res->start, res->end - res->start + 1);
+	ssp->mmio_base = ioremap(res->start, resource_size(res));
 	if (ssp->mmio_base == NULL) {
 		dev_err(&pdev->dev, "failed to ioremap() registers\n");
 		ret = -ENODEV;
@@ -396,21 +396,21 @@ static int __devinit ssp_probe(struct platform_device *pdev)
 		goto err_free_io;
 	}
 
-	res = platform_get_resource(pdev, IORESOURCE_DMA, 0);
-	if (res == NULL) {
+	pres = platform_get_resource(pdev, IORESOURCE_DMA, 0);
+	if (pres == NULL) {
 		dev_err(&pdev->dev, "no SSP RX DRCMR defined\n");
 		ret = -ENODEV;
 		goto err_free_io;
 	}
-	ssp->drcmr_rx = res->start;
+	ssp->drcmr_rx = pres->start;
 
-	res = platform_get_resource(pdev, IORESOURCE_DMA, 1);
-	if (res == NULL) {
+	pres = platform_get_resource(pdev, IORESOURCE_DMA, 1);
+	if (pres == NULL) {
 		dev_err(&pdev->dev, "no SSP TX DRCMR defined\n");
 		ret = -ENODEV;
 		goto err_free_io;
 	}
-	ssp->drcmr_tx = res->start;
+	ssp->drcmr_tx = pres->start;
 
 	/* PXA2xx/3xx SSP ports starts from 1 and the internal pdev->id
 	 * starts from 0, do a translation here
@@ -429,7 +429,7 @@ static int __devinit ssp_probe(struct platform_device *pdev)
 err_free_io:
 	iounmap(ssp->mmio_base);
 err_free_mem:
-	release_mem_region(res->start, res->end - res->start + 1);
+	release_mem_region(res->start, resource_size(res));
 err_free_clk:
 	clk_put(ssp->clk);
 err_free:
