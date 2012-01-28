Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751881Ab2A1HDj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jan 2012 02:03:39 -0500
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:6233 "EHLO
	mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751281Ab2A1HDi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jan 2012 02:03:38 -0500
X-IronPort-AV: E=Sophos;i="4.71,584,1320620400"; 
   d="scan'208";a="129192118"
Date: Sat, 28 Jan 2012 08:03:34 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
cc: Julia Lawall <julia.lawall@lip6.fr>, Wolfram Sang <w.sang@pengutronix.de>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        Takashi Iwai <tiwai@suse.de>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dong Aisheng-B29396 <B29396@freescale.com>, Liam Girdwood <lrg@ti.com>
Subject: Re: [alsa-devel] [PATCH 1/15] sound/soc/mxs/mxs-saif.c: add missing
 iounmap
In-Reply-To: <20120126112242.GA9401@opensource.wolfsonmicro.com>
Message-ID: <alpine.DEB.2.02.1201280801230.2045@hadrien>
References: <1326362117-29371-1-git-send-email-Julia.Lawall@lip6.fr> <7FE21149F4667147B645348EC605788508FBDB@039-SN2MPN1-013.039d.mgd.msft.net> <alpine.DEB.2.02.1201241828480.1779@localhost6.localdomain6> <20120124202203.GD1135@opensource.wolfsonmicro.com>
 <alpine.DEB.2.02.1201242144580.1998@hadrien> <20120126110506.GB2611@pengutronix.de> <alpine.DEB.2.02.1201261220460.1851@localhost6.localdomain6> <20120126112242.GA9401@opensource.wolfsonmicro.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

The various devm_ functions allocate memory that is released when a driver
detaches.  This patch uses these functions for data that is allocated in
the probe function of a platform device and is only freed in the remove
function.

By removing the need for kfree and iounmap, this also eliminates missing
resource-release problems.

This also removes a now unneeded test on iores.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---

patch against 
git://git.kernel.org/pub/scm/linux/kernel/git/broonie/sound.git

  sound/soc/mxs/mxs-saif.c |   53 ++++++++++-------------------------------------
  1 file changed, 12 insertions(+), 41 deletions(-)

diff --git a/sound/soc/mxs/mxs-saif.c b/sound/soc/mxs/mxs-saif.c
--- a/sound/soc/mxs/mxs-saif.c
+++ b/sound/soc/mxs/mxs-saif.c
@@ -632,7 +632,7 @@ static int mxs_saif_probe(struct platform_device *pdev)
  			return ret;
  	}

-	saif = kzalloc(sizeof(*saif), GFP_KERNEL);
+	saif = devm_kzalloc(&pdev->dev, sizeof(*saif), GFP_KERNEL);
  	if (!saif)
  		return -ENOMEM;

@@ -652,29 +652,16 @@ static int mxs_saif_probe(struct platform_device *pdev)
  		ret = PTR_ERR(saif->clk);
  		dev_err(&pdev->dev, "Cannot get the clock: %d\n",
  			ret);
-		goto failed_clk;
+		return ret;
  	}

  	iores = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!iores) {
-		ret = -ENODEV;
-		dev_err(&pdev->dev, "failed to get io resource: %d\n",
-			ret);
-		goto failed_get_resource;
-	}

-	if (!request_mem_region(iores->start, resource_size(iores),
-				"mxs-saif")) {
-		dev_err(&pdev->dev, "request_mem_region failed\n");
-		ret = -EBUSY;
-		goto failed_get_resource;
-	}
-
-	saif->base = ioremap(iores->start, resource_size(iores));
+	saif->base = devm_request_and_ioremap(&pdev->dev, iores);
  	if (!saif->base) {
-		dev_err(&pdev->dev, "ioremap failed\n");
+		dev_err(&pdev->dev, "devm_request_and_ioremap failed\n");
  		ret = -ENODEV;
-		goto failed_ioremap;
+		goto failed_get_resource;
  	}

  	dmares = platform_get_resource(pdev, IORESOURCE_DMA, 0);
@@ -682,7 +669,7 @@ static int mxs_saif_probe(struct platform_device *pdev)
  		ret = -ENODEV;
  		dev_err(&pdev->dev, "failed to get dma resource: %d\n",
  			ret);
-		goto failed_ioremap;
+		goto failed_get_resource;
  	}
  	saif->dma_param.chan_num = dmares->start;

@@ -691,14 +678,15 @@ static int mxs_saif_probe(struct platform_device *pdev)
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
@@ -706,7 +694,7 @@ static int mxs_saif_probe(struct platform_device *pdev)
  		ret = saif->dma_param.chan_irq;
  		dev_err(&pdev->dev, "failed to get dma irq resource: %d\n",
  			ret);
-		goto failed_get_irq2;
+		goto failed_get_resource;
  	}

  	platform_set_drvdata(pdev, saif);
@@ -714,7 +702,7 @@ static int mxs_saif_probe(struct platform_device *pdev)
  	ret = snd_soc_register_dai(&pdev->dev, &mxs_saif_dai);
  	if (ret) {
  		dev_err(&pdev->dev, "register DAI failed\n");
-		goto failed_register;
+		goto failed_get_resource;
  	}

  	saif->soc_platform_pdev = platform_device_alloc(
@@ -737,36 +725,19 @@ failed_pdev_add:
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

