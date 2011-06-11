Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932223Ab1FKBLa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 21:11:30 -0400
Received: from mail.perches.com ([173.55.12.10]:2798 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758249Ab1FKBL3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 21:11:29 -0400
From: Joe Perches <joe@perches.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Jiri Kosina <jkosina@suse.cz>, spi-devel-general@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Subject: [PATCH] spi: Convert uses of struct resource * to resource_size(ptr)
Date: Fri, 10 Jun 2011 18:11:25 -0700
Message-Id: <ca4182a6b7355088c20b1ef18109039ee19d7804.1307754514.git.joe@perches.com>
X-Mailer: git-send-email 1.7.6.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Done via coccinelle scripts like:

@@
struct resource *ptr;
@@

- ptr->end - ptr->start + 1
+ resource_size(ptr)

and some grep and typing.

Mostly uncompiled, no cross-compilers.

Signed-off-by: Joe Perches <joe@perches.com>

---

This is a remainder patch for files that
have been moved around since 3.0-rc1

Jiri Kosina has picked up the majority of
these conversions via the trivial tree.
 
 drivers/spi/spi-ath79.c       |    2 +-
 drivers/spi/spi-omap2-mcspi.c |   10 +++++-----
 drivers/spi/spi-orion.c       |    6 +++---
 drivers/spi/spi-ppc4xx.c      |    2 +-
 drivers/spi/spi-tegra.c       |    8 ++++----
 5 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/spi/spi-ath79.c b/drivers/spi/spi-ath79.c
index fcff810..03019bf 100644
--- a/drivers/spi/spi-ath79.c
+++ b/drivers/spi/spi-ath79.c
@@ -232,7 +232,7 @@ static __devinit int ath79_spi_probe(struct platform_device *pdev)
 		goto err_put_master;
 	}
 
-	sp->base = ioremap(r->start, r->end - r->start + 1);
+	sp->base = ioremap(r->start, resource_size(r));
 	if (!sp->base) {
 		ret = -ENXIO;
 		goto err_put_master;
diff --git a/drivers/spi/spi-omap2-mcspi.c b/drivers/spi/spi-omap2-mcspi.c
index 969cdd2..fde3a2d 100644
--- a/drivers/spi/spi-omap2-mcspi.c
+++ b/drivers/spi/spi-omap2-mcspi.c
@@ -1116,8 +1116,8 @@ static int __init omap2_mcspi_probe(struct platform_device *pdev)
 		status = -ENODEV;
 		goto err1;
 	}
-	if (!request_mem_region(r->start, (r->end - r->start) + 1,
-			dev_name(&pdev->dev))) {
+	if (!request_mem_region(r->start, resource_size(r),
+				dev_name(&pdev->dev))) {
 		status = -EBUSY;
 		goto err1;
 	}
@@ -1125,7 +1125,7 @@ static int __init omap2_mcspi_probe(struct platform_device *pdev)
 	r->start += pdata->regs_offset;
 	r->end += pdata->regs_offset;
 	mcspi->phys = r->start;
-	mcspi->base = ioremap(r->start, r->end - r->start + 1);
+	mcspi->base = ioremap(r->start, resource_size(r));
 	if (!mcspi->base) {
 		dev_dbg(&pdev->dev, "can't ioremap MCSPI\n");
 		status = -ENOMEM;
@@ -1190,7 +1190,7 @@ err4:
 err3:
 	kfree(mcspi->dma_channels);
 err2:
-	release_mem_region(r->start, (r->end - r->start) + 1);
+	release_mem_region(r->start, resource_size(r));
 	iounmap(mcspi->base);
 err1:
 	return status;
@@ -1210,7 +1210,7 @@ static int __exit omap2_mcspi_remove(struct platform_device *pdev)
 
 	omap2_mcspi_disable_clocks(mcspi);
 	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	release_mem_region(r->start, (r->end - r->start) + 1);
+	release_mem_region(r->start, resource_size(r));
 
 	base = mcspi->base;
 	spi_unregister_master(master);
diff --git a/drivers/spi/spi-orion.c b/drivers/spi/spi-orion.c
index d482628..9421a39 100644
--- a/drivers/spi/spi-orion.c
+++ b/drivers/spi/spi-orion.c
@@ -489,7 +489,7 @@ static int __init orion_spi_probe(struct platform_device *pdev)
 		goto out;
 	}
 
-	if (!request_mem_region(r->start, (r->end - r->start) + 1,
+	if (!request_mem_region(r->start, resource_size(r),
 				dev_name(&pdev->dev))) {
 		status = -EBUSY;
 		goto out;
@@ -511,7 +511,7 @@ static int __init orion_spi_probe(struct platform_device *pdev)
 	return status;
 
 out_rel_mem:
-	release_mem_region(r->start, (r->end - r->start) + 1);
+	release_mem_region(r->start, resource_size(r));
 
 out:
 	spi_master_put(master);
@@ -531,7 +531,7 @@ static int __exit orion_spi_remove(struct platform_device *pdev)
 	cancel_work_sync(&spi->work);
 
 	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	release_mem_region(r->start, (r->end - r->start) + 1);
+	release_mem_region(r->start, resource_size(r));
 
 	spi_unregister_master(master);
 
diff --git a/drivers/spi/spi-ppc4xx.c b/drivers/spi/spi-ppc4xx.c
index 2a298c0..b267fd9 100644
--- a/drivers/spi/spi-ppc4xx.c
+++ b/drivers/spi/spi-ppc4xx.c
@@ -502,7 +502,7 @@ static int __init spi_ppc4xx_of_probe(struct platform_device *op)
 		goto free_gpios;
 	}
 	hw->mapbase = resource.start;
-	hw->mapsize = resource.end - resource.start + 1;
+	hw->mapsize = resource_size(&resource);
 
 	/* Sanity check */
 	if (hw->mapsize < sizeof(struct spi_ppc4xx_regs)) {
diff --git a/drivers/spi/spi-tegra.c b/drivers/spi/spi-tegra.c
index 6c3aa6e..8e30727 100644
--- a/drivers/spi/spi-tegra.c
+++ b/drivers/spi/spi-tegra.c
@@ -498,14 +498,14 @@ static int __init spi_tegra_probe(struct platform_device *pdev)
 		goto err0;
 	}
 
-	if (!request_mem_region(r->start, (r->end - r->start) + 1,
+	if (!request_mem_region(r->start, resource_size(r),
 				dev_name(&pdev->dev))) {
 		ret = -EBUSY;
 		goto err0;
 	}
 
 	tspi->phys = r->start;
-	tspi->base = ioremap(r->start, r->end - r->start + 1);
+	tspi->base = ioremap(r->start, resource_size(r));
 	if (!tspi->base) {
 		dev_err(&pdev->dev, "can't ioremap iomem\n");
 		ret = -ENOMEM;
@@ -563,7 +563,7 @@ err3:
 err2:
 	iounmap(tspi->base);
 err1:
-	release_mem_region(r->start, (r->end - r->start) + 1);
+	release_mem_region(r->start, resource_size(r));
 err0:
 	spi_master_put(master);
 	return ret;
@@ -588,7 +588,7 @@ static int __devexit spi_tegra_remove(struct platform_device *pdev)
 	iounmap(tspi->base);
 
 	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	release_mem_region(r->start, (r->end - r->start) + 1);
+	release_mem_region(r->start, resource_size(r));
 
 	return 0;
 }
-- 
1.7.6.rc1

