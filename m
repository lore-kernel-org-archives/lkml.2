Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757284Ab2AXUp3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 15:45:29 -0500
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:38248 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757181Ab2AXUp2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 15:45:28 -0500
X-IronPort-AV: E=Sophos;i="4.71,563,1320620400"; 
   d="scan'208,223";a="141285697"
Date: Tue, 24 Jan 2012 21:45:26 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
cc: Dong Aisheng-B29396 <B29396@freescale.com>, Liam Girdwood <lrg@ti.com>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/15] sound/soc/mxs/mxs-saif.c: add missing iounmap
In-Reply-To: <20120124202203.GD1135@opensource.wolfsonmicro.com>
Message-ID: <alpine.DEB.2.02.1201242144580.1998@hadrien>
References: <1326362117-29371-1-git-send-email-Julia.Lawall@lip6.fr> <7FE21149F4667147B645348EC605788508FBDB@039-SN2MPN1-013.039d.mgd.msft.net> <alpine.DEB.2.02.1201241828480.1779@localhost6.localdomain6> <20120124202203.GD1135@opensource.wolfsonmicro.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From nobody Tue Jan 24 18:26:10 CET 2012
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Liam Girdwood <lrg@ti.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,Jaroslav Kysela <perex@perex.cz>,Takashi Iwai <tiwai@suse.de>,alsa-devel@alsa-project.org,linux-kernel@vger.kernel.org
Subject: [PATCH] sound/soc/mxs/mxs-saif.c: use devm_ functions

From: Julia Lawall <Julia.Lawall@lip6.fr>

The various devm_ functions allocate memory that is released when a driver
detaches.  This patch uses these functions for data that is allocated in
the probe function of a platform device and is only freed in the remove
function.

By removing the need for iounmap, this also eliminates a missing iounmap
problem, in the the original error handling code following a successful
call to ioremap.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
  sound/soc/mxs/mxs-saif.c |   43 ++++++++++++++-----------------------------
  1 file changed, 14 insertions(+), 29 deletions(-)

diff --git a/sound/soc/mxs/mxs-saif.c b/sound/soc/mxs/mxs-saif.c
index f204dba..7d755e0 100644
--- a/sound/soc/mxs/mxs-saif.c
+++ b/sound/soc/mxs/mxs-saif.c
@@ -630,7 +630,7 @@ static int mxs_saif_probe(struct platform_device *pdev)
  	if (pdev->id >= ARRAY_SIZE(mxs_saif))
  		return -EINVAL;

-	saif = kzalloc(sizeof(*saif), GFP_KERNEL);
+	saif = devm_kzalloc(&pdev->dev, sizeof(*saif), GFP_KERNEL);
  	if (!saif)
  		return -ENOMEM;

@@ -655,7 +655,7 @@ static int mxs_saif_probe(struct platform_device *pdev)
  		ret = PTR_ERR(saif->clk);
  		dev_err(&pdev->dev, "Cannot get the clock: %d\n",
  			ret);
-		goto failed_clk;
+		return ret;
  	}

  	iores = platform_get_resource(pdev, IORESOURCE_MEM, 0);
@@ -666,18 +666,19 @@ static int mxs_saif_probe(struct platform_device *pdev)
  		goto failed_get_resource;
  	}

-	if (!request_mem_region(iores->start, resource_size(iores),
-				"mxs-saif")) {
+	if (!devm_request_mem_region(&pdev->dev, iores->start,
+				     resource_size(iores), "mxs-saif")) {
  		dev_err(&pdev->dev, "request_mem_region failed\n");
  		ret = -EBUSY;
  		goto failed_get_resource;
  	}

-	saif->base = ioremap(iores->start, resource_size(iores));
+	saif->base = devm_ioremap(&pdev->dev, iores->start,
+				  resource_size(iores));
  	if (!saif->base) {
  		dev_err(&pdev->dev, "ioremap failed\n");
  		ret = -ENODEV;
-		goto failed_ioremap;
+		goto failed_get_resource;
  	}

  	dmares = platform_get_resource(pdev, IORESOURCE_DMA, 0);
@@ -685,7 +686,7 @@ static int mxs_saif_probe(struct platform_device *pdev)
  		ret = -ENODEV;
  		dev_err(&pdev->dev, "failed to get dma resource: %d\n",
  			ret);
-		goto failed_ioremap;
+		goto failed_get_resource;
  	}
  	saif->dma_param.chan_num = dmares->start;

@@ -694,14 +695,15 @@ static int mxs_saif_probe(struct platform_device *pdev)
  		ret = saif->irq;
  		dev_err(&pdev->dev, "failed to get irq resource: %d\n",
  			ret);
-		goto failed_get_irq1;
+		goto failed_get_resource;
  	}

  	saif->dev = &pdev->dev;
-	ret = request_irq(saif->irq, mxs_saif_irq, 0, "mxs-saif", saif);
+	ret = devm_request_irq(&pdev->dev, saif->irq, mxs_saif_irq, 0,
+			       "mxs-saif", saif);
  	if (ret) {
  		dev_err(&pdev->dev, "failed to request irq\n");
-		goto failed_get_irq1;
+		goto failed_get_resource;
  	}

  	saif->dma_param.chan_irq = platform_get_irq(pdev, 1);
@@ -709,7 +711,7 @@ static int mxs_saif_probe(struct platform_device *pdev)
  		ret = saif->dma_param.chan_irq;
  		dev_err(&pdev->dev, "failed to get dma irq resource: %d\n",
  			ret);
-		goto failed_get_irq2;
+		goto failed_get_resource;
  	}

  	platform_set_drvdata(pdev, saif);
@@ -717,7 +719,7 @@ static int mxs_saif_probe(struct platform_device *pdev)
  	ret = snd_soc_register_dai(&pdev->dev, &mxs_saif_dai);
  	if (ret) {
  		dev_err(&pdev->dev, "register DAI failed\n");
-		goto failed_register;
+		goto failed_get_resource;
  	}

  	saif->soc_platform_pdev = platform_device_alloc(
@@ -740,36 +742,19 @@ failed_pdev_add:
  	platform_device_put(saif->soc_platform_pdev);
  failed_pdev_alloc:
  	snd_soc_unregister_dai(&pdev->dev);
-failed_register:
-failed_get_irq2:
-	free_irq(saif->irq, saif);
-failed_get_irq1:
-	iounmap(saif->base);
-failed_ioremap:
-	release_mem_region(iores->start, resource_size(iores));
  failed_get_resource:
  	clk_put(saif->clk);
-failed_clk:
-	kfree(saif);

  	return ret;
  }

  static int __devexit mxs_saif_remove(struct platform_device *pdev)
  {
-	struct resource *res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
  	struct mxs_saif *saif = platform_get_drvdata(pdev);

  	platform_device_unregister(saif->soc_platform_pdev);
-
  	snd_soc_unregister_dai(&pdev->dev);
-
-	iounmap(saif->base);
-	release_mem_region(res->start, resource_size(res));
-	free_irq(saif->irq, saif);
-
  	clk_put(saif->clk);
-	kfree(saif);

  	return 0;
  }
