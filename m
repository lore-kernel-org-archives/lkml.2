Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757202Ab2IMAO6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 20:14:58 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:37074 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932568Ab2ILXiL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 19:38:11 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>,
        =?UTF-8?q?Eric=20B=C3=A9nard?= <eric@eukrea.com>,
        Javier Martin <javier.martin@vista-silicon.com>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Vinod Koul <vinod.koul@linux.intel.com>
Subject: =?UTF-8?q?=5B=2011/85=5D=20Revert=20dma=3A=20imx-dma=3A=20Fix=20kernel=20crash=20due=20to=20missing=20clock=20conversion?=
Date: Wed, 12 Sep 2012 16:35:54 -0700
Message-Id: <20120912233542.909048450@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120912233541.747973832@linuxfoundation.org>
References: <20120912233541.747973832@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

This reverts 9ea2c02bafe276e97b592a046ac733610a6d57fd, which was commit
a2367db2ec5e7fc6fe93e221e0fcdee81b053daf upstream.

It broke the build on 3.4, and was not needed there.

Reported-by: Eric Bénard <eric@eukrea.com>
Cc: Javier Martin <javier.martin@vista-silicon.com>
Cc: Fabio Estevam <fabio.estevam@freescale.com>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Vinod Koul <vinod.koul@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/dma/imx-dma.c |   36 +++++++++++-------------------------
 1 file changed, 11 insertions(+), 25 deletions(-)

--- a/drivers/dma/imx-dma.c
+++ b/drivers/dma/imx-dma.c
@@ -172,8 +172,7 @@ struct imxdma_engine {
 	struct device_dma_parameters	dma_parms;
 	struct dma_device		dma_device;
 	void __iomem			*base;
-	struct clk			*dma_ahb;
-	struct clk			*dma_ipg;
+	struct clk			*dma_clk;
 	spinlock_t			lock;
 	struct imx_dma_2d_config	slots_2d[IMX_DMA_2D_SLOTS];
 	struct imxdma_channel		channel[IMX_DMA_CHANNELS];
@@ -977,20 +976,10 @@ static int __init imxdma_probe(struct pl
 		return 0;
 	}
 
-	imxdma->dma_ipg = devm_clk_get(&pdev->dev, "ipg");
-	if (IS_ERR(imxdma->dma_ipg)) {
-		ret = PTR_ERR(imxdma->dma_ipg);
-		goto err_clk;
-	}
-
-	imxdma->dma_ahb = devm_clk_get(&pdev->dev, "ahb");
-	if (IS_ERR(imxdma->dma_ahb)) {
-		ret = PTR_ERR(imxdma->dma_ahb);
-		goto err_clk;
-	}
-
-	clk_prepare_enable(imxdma->dma_ipg);
-	clk_prepare_enable(imxdma->dma_ahb);
+	imxdma->dma_clk = clk_get(NULL, "dma");
+	if (IS_ERR(imxdma->dma_clk))
+		return PTR_ERR(imxdma->dma_clk);
+	clk_enable(imxdma->dma_clk);
 
 	/* reset DMA module */
 	imx_dmav1_writel(imxdma, DCR_DRST, DMA_DCR);
@@ -999,14 +988,16 @@ static int __init imxdma_probe(struct pl
 		ret = request_irq(MX1_DMA_INT, dma_irq_handler, 0, "DMA", imxdma);
 		if (ret) {
 			dev_warn(imxdma->dev, "Can't register IRQ for DMA\n");
-			goto err_enable;
+			kfree(imxdma);
+			return ret;
 		}
 
 		ret = request_irq(MX1_DMA_ERR, imxdma_err_handler, 0, "DMA", imxdma);
 		if (ret) {
 			dev_warn(imxdma->dev, "Can't register ERRIRQ for DMA\n");
 			free_irq(MX1_DMA_INT, NULL);
-			goto err_enable;
+			kfree(imxdma);
+			return ret;
 		}
 	}
 
@@ -1103,10 +1094,7 @@ err_init:
 		free_irq(MX1_DMA_INT, NULL);
 		free_irq(MX1_DMA_ERR, NULL);
 	}
-err_enable:
-	clk_disable_unprepare(imxdma->dma_ipg);
-	clk_disable_unprepare(imxdma->dma_ahb);
-err_clk:
+
 	kfree(imxdma);
 	return ret;
 }
@@ -1126,9 +1114,7 @@ static int __exit imxdma_remove(struct p
 		free_irq(MX1_DMA_ERR, NULL);
 	}
 
-	clk_disable_unprepare(imxdma->dma_ipg);
-	clk_disable_unprepare(imxdma->dma_ahb);
-	kfree(imxdma);
+        kfree(imxdma);
 
         return 0;
 }


