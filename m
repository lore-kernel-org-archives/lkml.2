Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750960Ab1GUEB6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 00:01:58 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:45049 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704Ab1GUEB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 00:01:56 -0400
From: Jassi Brar <jaswinder.singh@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: vinod.koul@intel.com, dan.j.williams@intel.com,
        rmk+kernel@arm.linux.org.uk, linus.walleij@stericsson.com,
        per.friden@stericsson.com, wei.zhang@freescale.com,
        ebony.zhu@freescale.com, iws@ovro.caltech.edu, s.hauer@pengutronix.de,
        maciej.sosnowski@intel.com, saeed@marvell.com, shawn.guo@freescale.com,
        yur@emcraft.com, agust@denx.de, iwamatsu.nobuhiro@renesas.com,
        per.forlin@stericsson.com, jonas.aberg@stericsson.com,
        anemo@mba.ocn.ne.jp, Jassi Brar <jaswinder.singh@linaro.org>
Subject: [PATCHv2] DMAEngine: Let dmac drivers to set chan_id
Date: Thu, 21 Jul 2011 09:31:43 +0530
Message-Id: <1311220903-2545-1-git-send-email-jaswinder.singh@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1311185906-7813-1-git-send-email-jaswinder.singh@linaro.org>
References: <1311185906-7813-1-git-send-email-jaswinder.singh@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A DMAC driver might put chan_id to better use by directly
mapping system-wide channel numbers on them (and not DMAC
relative index).

Signed-off-by: Jassi Brar <jaswinder.singh@linaro.org>
---
 v2  Minor fix of restoring chancnt++ in dmaengine.c

 drivers/dma/amba-pl08x.c  |    1 +
 drivers/dma/coh901318.c   |    3 ++-
 drivers/dma/dmaengine.c   |    2 +-
 drivers/dma/fsldma.c      |    2 +-
 drivers/dma/imx-dma.c     |    1 +
 drivers/dma/imx-sdma.c    |    4 +++-
 drivers/dma/ioat/dma.c    |    1 +
 drivers/dma/iop-adma.c    |    1 +
 drivers/dma/mv_xor.c      |    1 +
 drivers/dma/mxs-dma.c     |    2 +-
 drivers/dma/ppc4xx/adma.c |    1 +
 drivers/dma/shdma.c       |    1 +
 drivers/dma/ste_dma40.c   |    1 +
 drivers/dma/txx9dmac.c    |    1 +
 14 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/drivers/dma/amba-pl08x.c b/drivers/dma/amba-pl08x.c
index e6d7228..40083ef 100644
--- a/drivers/dma/amba-pl08x.c
+++ b/drivers/dma/amba-pl08x.c
@@ -1738,6 +1738,7 @@ static int pl08x_dma_init_virtual_channels(struct pl08x_driver_data *pl08x,
 		tasklet_init(&chan->tasklet, pl08x_tasklet,
 			     (unsigned long) chan);
 
+		chan->chan.chan_id = i;
 		list_add_tail(&chan->chan.device_node, &dmadev->channels);
 	}
 	dev_info(&pl08x->adev->dev, "initialized %d virtual %s channels\n",
diff --git a/drivers/dma/coh901318.c b/drivers/dma/coh901318.c
index af8c0b5..3d8b67a 100644
--- a/drivers/dma/coh901318.c
+++ b/drivers/dma/coh901318.c
@@ -1414,7 +1414,7 @@ void coh901318_base_init(struct dma_device *dma, const int *pick_chans,
 			 struct coh901318_base *base)
 {
 	int chans_i;
-	int i = 0;
+	int i = 0, id = 0;
 	struct coh901318_chan *cohc;
 
 	INIT_LIST_HEAD(&dma->channels);
@@ -1442,6 +1442,7 @@ void coh901318_base_init(struct dma_device *dma, const int *pick_chans,
 			tasklet_init(&cohc->tasklet, dma_tasklet,
 				     (unsigned long) cohc);
 
+			cohc->chan.chan_id = id++;
 			list_add_tail(&cohc->chan.device_node,
 				      &dma->channels);
 		}
diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
index 8bcb15f..af52e26 100644
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -735,7 +735,7 @@ int dma_async_device_register(struct dma_device *device)
 			goto err_out;
 		}
 
-		chan->chan_id = chancnt++;
+		chancnt++;
 		chan->dev->device.class = &dma_devclass;
 		chan->dev->device.parent = device->dev;
 		chan->dev->chan = chan;
diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
index 8a78154..477a821 100644
--- a/drivers/dma/fsldma.c
+++ b/drivers/dma/fsldma.c
@@ -1309,7 +1309,7 @@ static int __devinit fsl_dma_chan_probe(struct fsldma_device *fdev,
 
 	/* Add the channel to DMA device channel list */
 	list_add_tail(&chan->common.device_node, &fdev->common.channels);
-	fdev->common.chancnt++;
+	chan->common.chan_id = fdev->common.chancnt++;
 
 	dev_info(fdev->dev, "#%d (%s), irq %d\n", chan->id, compatible,
 		 chan->irq != NO_IRQ ? chan->irq : fdev->irq);
diff --git a/drivers/dma/imx-dma.c b/drivers/dma/imx-dma.c
index e18eaab..bbf8619 100644
--- a/drivers/dma/imx-dma.c
+++ b/drivers/dma/imx-dma.c
@@ -368,6 +368,7 @@ static int __init imxdma_probe(struct platform_device *pdev)
 		imxdmac->chan.device = &imxdma->dma_device;
 		imxdmac->channel = i;
 
+		imxdmac->chan.chan_id = i;
 		/* Add the channel to the DMAC list */
 		list_add_tail(&imxdmac->chan.device_node, &imxdma->dma_device.channels);
 	}
diff --git a/drivers/dma/imx-sdma.c b/drivers/dma/imx-sdma.c
index b6d1455..be1d481 100644
--- a/drivers/dma/imx-sdma.c
+++ b/drivers/dma/imx-sdma.c
@@ -1305,9 +1305,11 @@ static int __init sdma_probe(struct platform_device *pdev)
 		 * because we need it internally in the SDMA driver. This also means
 		 * that channel 0 in dmaengine counting matches sdma channel 1.
 		 */
-		if (i)
+		if (i) {
+			sdmac->chan.chan_id = i - 1;
 			list_add_tail(&sdmac->chan.device_node,
 					&sdma->dma_device.channels);
+		}
 	}
 
 	ret = sdma_init(sdma);
diff --git a/drivers/dma/ioat/dma.c b/drivers/dma/ioat/dma.c
index a4d6cb0..7c1dbe5 100644
--- a/drivers/dma/ioat/dma.c
+++ b/drivers/dma/ioat/dma.c
@@ -107,6 +107,7 @@ void ioat_init_channel(struct ioatdma_device *device, struct ioat_chan_common *c
 	chan->reg_base = device->reg_base + (0x80 * (idx + 1));
 	spin_lock_init(&chan->cleanup_lock);
 	chan->common.device = dma;
+	chan->common.chan_id = idx;
 	list_add_tail(&chan->common.device_node, &dma->channels);
 	device->idx[idx] = chan;
 	init_timer(&chan->timer);
diff --git a/drivers/dma/iop-adma.c b/drivers/dma/iop-adma.c
index e03f811..8778e63 100644
--- a/drivers/dma/iop-adma.c
+++ b/drivers/dma/iop-adma.c
@@ -1565,6 +1565,7 @@ static int __devinit iop_adma_probe(struct platform_device *pdev)
 	INIT_LIST_HEAD(&iop_chan->chain);
 	INIT_LIST_HEAD(&iop_chan->all_slots);
 	iop_chan->common.device = dma_dev;
+	iop_chan->common.chan_id = 0;
 	list_add_tail(&iop_chan->common.device_node, &dma_dev->channels);
 
 	if (dma_has_cap(DMA_MEMCPY, dma_dev->cap_mask)) {
diff --git a/drivers/dma/mv_xor.c b/drivers/dma/mv_xor.c
index 954e334..722c668 100644
--- a/drivers/dma/mv_xor.c
+++ b/drivers/dma/mv_xor.c
@@ -1215,6 +1215,7 @@ static int __devinit mv_xor_probe(struct platform_device *pdev)
 	INIT_LIST_HEAD(&mv_chan->all_slots);
 	mv_chan->common.device = dma_dev;
 
+	mv_chan->common.chan_id = 0;
 	list_add_tail(&mv_chan->common.device_node, &dma_dev->channels);
 
 	if (dma_has_cap(DMA_MEMCPY, dma_dev->cap_mask)) {
diff --git a/drivers/dma/mxs-dma.c b/drivers/dma/mxs-dma.c
index 88aad4f..f79599e 100644
--- a/drivers/dma/mxs-dma.c
+++ b/drivers/dma/mxs-dma.c
@@ -655,7 +655,7 @@ static int __init mxs_dma_probe(struct platform_device *pdev)
 		tasklet_init(&mxs_chan->tasklet, mxs_dma_tasklet,
 			     (unsigned long) mxs_chan);
 
-
+		mxs_chan->chan.chan_id = i;
 		/* Add the channel to mxs_chan list */
 		list_add_tail(&mxs_chan->chan.device_node,
 			&mxs_dma->dma_device.channels);
diff --git a/drivers/dma/ppc4xx/adma.c b/drivers/dma/ppc4xx/adma.c
index fc457a7..bacd896 100644
--- a/drivers/dma/ppc4xx/adma.c
+++ b/drivers/dma/ppc4xx/adma.c
@@ -4529,6 +4529,7 @@ static int __devinit ppc440spe_adma_probe(struct platform_device *ofdev)
 	INIT_LIST_HEAD(&chan->all_slots);
 	chan->device = adev;
 	chan->common.device = &adev->common;
+	chan->common.chan_id = 0;
 	list_add_tail(&chan->common.device_node, &adev->common.channels);
 	tasklet_init(&chan->irq_tasklet, ppc440spe_adma_tasklet,
 		     (unsigned long)chan);
diff --git a/drivers/dma/shdma.c b/drivers/dma/shdma.c
index 0283300..469cdb8 100644
--- a/drivers/dma/shdma.c
+++ b/drivers/dma/shdma.c
@@ -1028,6 +1028,7 @@ static int __devinit sh_dmae_chan_probe(struct sh_dmae_device *shdev, int id,
 	INIT_LIST_HEAD(&new_sh_chan->ld_queue);
 	INIT_LIST_HEAD(&new_sh_chan->ld_free);
 
+	new_sh_chan->common.chan_id = id;
 	/* Add the channel to DMA device channel list */
 	list_add_tail(&new_sh_chan->common.device_node,
 			&shdev->common.channels);
diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 8f222d4..a30d37b 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -2345,6 +2345,7 @@ static void __init d40_chan_init(struct d40_base *base, struct dma_device *dma,
 		tasklet_init(&d40c->tasklet, dma_tasklet,
 			     (unsigned long) d40c);
 
+		d40c->chan.chan_id = i - offset;
 		list_add_tail(&d40c->chan.device_node,
 			      &dma->channels);
 	}
diff --git a/drivers/dma/txx9dmac.c b/drivers/dma/txx9dmac.c
index cbd83e36..271e8d3 100644
--- a/drivers/dma/txx9dmac.c
+++ b/drivers/dma/txx9dmac.c
@@ -1186,6 +1186,7 @@ static int __init txx9dmac_chan_probe(struct platform_device *pdev)
 	dc->ddev->chan[ch] = dc;
 	dc->chan.device = &dc->dma;
 	list_add_tail(&dc->chan.device_node, &dc->chan.device->channels);
+	dc->chan.chan_id = 0;
 	dc->chan.cookie = dc->completed = 1;
 
 	if (is_dmac64(dc))
-- 
1.7.4.1

