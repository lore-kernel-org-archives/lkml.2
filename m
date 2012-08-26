Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755238Ab2HZQEX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2012 12:04:23 -0400
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:56799
	"EHLO mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752300Ab2HZQBO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2012 12:01:14 -0400
X-IronPort-AV: E=Sophos;i="4.80,315,1344204000"; 
   d="scan'208";a="153852288"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: kernel-janitors@vger.kernel.org, spi-devel-general@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/13] drivers/spi/spi-{orion,pl022}.c: use clk_prepare_enable and clk_disable_unprepare
Date: Sun, 26 Aug 2012 18:00:54 +0200
Message-Id: <1345996865-32082-3-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1345996865-32082-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1345996865-32082-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Clk_prepare_enable and clk_disable_unprepare combine clk_prepare and
clk_enable, and clk_disable and clk_unprepare.  They make the code more
concise, and ensure that clk_unprepare is called when clk_enable fails.

A simplified version of the semantic patch that introduces calls to these
functions is as follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
expression e;
@@

- clk_prepare(e);
- clk_enable(e);
+ clk_prepare_enable(e);

@@
expression e;
@@

- clk_disable(e);
- clk_unprepare(e);
+ clk_disable_unprepare(e);
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/spi/spi-orion.c |    3 +--
 drivers/spi/spi-pl022.c |   17 ++++-------------
 2 files changed, 5 insertions(+), 15 deletions(-)

diff --git a/drivers/spi/spi-orion.c b/drivers/spi/spi-orion.c
index b17c09c..b2a7199 100644
--- a/drivers/spi/spi-orion.c
+++ b/drivers/spi/spi-orion.c
@@ -416,8 +416,7 @@ static int __init orion_spi_probe(struct platform_device *pdev)
 		goto out;
 	}
 
-	clk_prepare(spi->clk);
-	clk_enable(spi->clk);
+	clk_prepare_enable(spi->clk);
 	tclk_hz = clk_get_rate(spi->clk);
 	spi->max_speed = DIV_ROUND_UP(tclk_hz, 4);
 	spi->min_speed = DIV_ROUND_UP(tclk_hz, 30);
diff --git a/drivers/spi/spi-pl022.c b/drivers/spi/spi-pl022.c
index b0fec03..0d235d4 100644
--- a/drivers/spi/spi-pl022.c
+++ b/drivers/spi/spi-pl022.c
@@ -2142,16 +2142,10 @@ pl022_probe(struct amba_device *adev, const struct amba_id *id)
 		goto err_no_clk;
 	}
 
-	status = clk_prepare(pl022->clk);
-	if (status) {
-		dev_err(&adev->dev, "could not prepare SSP/SPI bus clock\n");
-		goto  err_clk_prep;
-	}
-
-	status = clk_enable(pl022->clk);
+	status = clk_prepare_enable(pl022->clk);
 	if (status) {
 		dev_err(&adev->dev, "could not enable SSP/SPI bus clock\n");
-		goto err_no_clk_en;
+		goto err_clk_prep;
 	}
 
 	/* Initialize transfer pump */
@@ -2207,9 +2201,7 @@ pl022_probe(struct amba_device *adev, const struct amba_id *id)
 
 	free_irq(adev->irq[0], pl022);
  err_no_irq:
-	clk_disable(pl022->clk);
- err_no_clk_en:
-	clk_unprepare(pl022->clk);
+	clk_disable_unprepare(pl022->clk);
  err_clk_prep:
 	clk_put(pl022->clk);
  err_no_clk:
@@ -2243,8 +2235,7 @@ pl022_remove(struct amba_device *adev)
 		pl022_dma_remove(pl022);
 
 	free_irq(adev->irq[0], pl022);
-	clk_disable(pl022->clk);
-	clk_unprepare(pl022->clk);
+	clk_disable_unprepare(pl022->clk);
 	clk_put(pl022->clk);
 	pm_runtime_disable(&adev->dev);
 	iounmap(pl022->virtbase);

