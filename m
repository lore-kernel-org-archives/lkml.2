Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753110Ab2BRUNt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Feb 2012 15:13:49 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:37140 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752798Ab2BRUNq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Feb 2012 15:13:46 -0500
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Ben Dooks <ben-linux@fluff.org>
Cc: kernel-janitors@vger.kernel.org, Chris Ball <cjb@laptop.org>,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] drivers/mmc/host/sdhci-s3c.c: use devm_ functions
Date: Sat, 18 Feb 2012 21:13:39 +0100
Message-Id: <1329596019-19822-1-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

The various devm_ functions allocate memory that is released when a driver
detaches.  This patch uses these functions for data that is allocated in
the probe function of a platform device and is only freed in the remove
function.

By using devm_ioremap, it also removes a potential memory leak, because
there was no call to iounmap in the probe function.

The call to platform_get_resource was moved just to make it closer to the
place where its result it used.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/mmc/host/sdhci-s3c.c |   26 +++-----------------------
 1 file changed, 3 insertions(+), 23 deletions(-)

diff --git a/drivers/mmc/host/sdhci-s3c.c b/drivers/mmc/host/sdhci-s3c.c
index b19e7d4..10ec7c6 100644
--- a/drivers/mmc/host/sdhci-s3c.c
+++ b/drivers/mmc/host/sdhci-s3c.c
@@ -402,12 +402,6 @@ static int __devinit sdhci_s3c_probe(struct platform_device *pdev)
 		return irq;
 	}
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res) {
-		dev_err(dev, "no memory specified\n");
-		return -ENOENT;
-	}
-
 	host = sdhci_alloc_host(dev, sizeof(struct sdhci_s3c));
 	if (IS_ERR(host)) {
 		dev_err(dev, "sdhci_alloc_host() failed\n");
@@ -464,15 +458,9 @@ static int __devinit sdhci_s3c_probe(struct platform_device *pdev)
 		goto err_no_busclks;
 	}
 
-	sc->ioarea = request_mem_region(res->start, resource_size(res),
-					mmc_hostname(host->mmc));
-	if (!sc->ioarea) {
-		dev_err(dev, "failed to reserve register area\n");
-		ret = -ENXIO;
-		goto err_req_regs;
-	}
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 
-	host->ioaddr = ioremap_nocache(res->start, resource_size(res));
+	host->ioaddr = devm_request_and_ioremap(&pdev->dev, res);
 	if (!host->ioaddr) {
 		dev_err(dev, "failed to map registers\n");
 		ret = -ENXIO;
@@ -547,7 +535,7 @@ static int __devinit sdhci_s3c_probe(struct platform_device *pdev)
 	ret = sdhci_add_host(host);
 	if (ret) {
 		dev_err(dev, "sdhci_add_host() failed\n");
-		goto err_add_host;
+		goto err_req_regs;
 	}
 
 	/* The following two methods of card detection might call
@@ -561,10 +549,6 @@ static int __devinit sdhci_s3c_probe(struct platform_device *pdev)
 
 	return 0;
 
- err_add_host:
-	release_resource(sc->ioarea);
-	kfree(sc->ioarea);
-
  err_req_regs:
 	for (ptr = 0; ptr < MAX_BUS_CLK; ptr++) {
 		if (sc->clk_bus[ptr]) {
@@ -610,10 +594,6 @@ static int __devexit sdhci_s3c_remove(struct platform_device *pdev)
 	clk_disable(sc->clk_io);
 	clk_put(sc->clk_io);
 
-	iounmap(host->ioaddr);
-	release_resource(sc->ioarea);
-	kfree(sc->ioarea);
-
 	sdhci_free_host(host);
 	platform_set_drvdata(pdev, NULL);
 

