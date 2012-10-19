Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757214Ab2JSCuY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 22:50:24 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:46999 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030274Ab2JSCuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 22:50:18 -0400
From: Matt Porter <mporter@ti.com>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Dan Williams <djbw@fb.com>, Chris Ball <cjb@laptop.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>
Subject: [RFC PATCH 3/3] mmc: davinci: get SG segment limits with dma_get_channel_caps()
Date: Thu, 18 Oct 2012 22:51:28 -0400
Message-Id: <1350615088-14562-4-git-send-email-mporter@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1350615088-14562-1-git-send-email-mporter@ti.com>
References: <1350615088-14562-1-git-send-email-mporter@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace the hardcoded values used to set max_segs/max_seg_size with
a dma_get_channel_caps() query to the dmaengine driver.

Signed-off-by: Matt Porter <mporter@ti.com>
---
 drivers/mmc/host/davinci_mmc.c            |   66 +++++++++--------------------
 include/linux/platform_data/mmc-davinci.h |    3 --
 2 files changed, 21 insertions(+), 48 deletions(-)

diff --git a/drivers/mmc/host/davinci_mmc.c b/drivers/mmc/host/davinci_mmc.c
index f5d46ea..d1efacc 100644
--- a/drivers/mmc/host/davinci_mmc.c
+++ b/drivers/mmc/host/davinci_mmc.c
@@ -145,18 +145,6 @@
 /* MMCSD Init clock in Hz in opendrain mode */
 #define MMCSD_INIT_CLOCK		200000
 
-/*
- * One scatterlist dma "segment" is at most MAX_CCNT rw_threshold units,
- * and we handle up to MAX_NR_SG segments.  MMC_BLOCK_BOUNCE kicks in only
- * for drivers with max_segs == 1, making the segments bigger (64KB)
- * than the page or two that's otherwise typical. nr_sg (passed from
- * platform data) == 16 gives at least the same throughput boost, using
- * EDMA transfer linkage instead of spending CPU time copying pages.
- */
-#define MAX_CCNT	((1 << 16) - 1)
-
-#define MAX_NR_SG	16
-
 static unsigned rw_threshold = 32;
 module_param(rw_threshold, uint, S_IRUGO);
 MODULE_PARM_DESC(rw_threshold,
@@ -217,8 +205,6 @@ struct mmc_davinci_host {
 	u8 version;
 	/* for ns in one cycle calculation */
 	unsigned ns_in_one_cycle;
-	/* Number of sg segments */
-	u8 nr_sg;
 #ifdef CONFIG_CPU_FREQ
 	struct notifier_block	freq_transition;
 #endif
@@ -422,16 +408,7 @@ static int mmc_davinci_send_dma_request(struct mmc_davinci_host *host,
 	int ret = 0;
 
 	if (host->data_dir == DAVINCI_MMC_DATADIR_WRITE) {
-		struct dma_slave_config dma_tx_conf = {
-			.direction = DMA_MEM_TO_DEV,
-			.dst_addr = host->mem_res->start + DAVINCI_MMCDXR,
-			.dst_addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES,
-			.dst_maxburst =
-				rw_threshold / DMA_SLAVE_BUSWIDTH_4_BYTES,
-		};
 		chan = host->dma_tx;
-		dmaengine_slave_config(host->dma_tx, &dma_tx_conf);
-
 		desc = dmaengine_prep_slave_sg(host->dma_tx,
 				data->sg,
 				host->sg_len,
@@ -444,16 +421,7 @@ static int mmc_davinci_send_dma_request(struct mmc_davinci_host *host,
 			goto out;
 		}
 	} else {
-		struct dma_slave_config dma_rx_conf = {
-			.direction = DMA_DEV_TO_MEM,
-			.src_addr = host->mem_res->start + DAVINCI_MMCDRR,
-			.src_addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES,
-			.src_maxburst =
-				rw_threshold / DMA_SLAVE_BUSWIDTH_4_BYTES,
-		};
 		chan = host->dma_rx;
-		dmaengine_slave_config(host->dma_rx, &dma_rx_conf);
-
 		desc = dmaengine_prep_slave_sg(host->dma_rx,
 				data->sg,
 				host->sg_len,
@@ -1166,6 +1134,7 @@ static int __init davinci_mmcsd_probe(struct platform_device *pdev)
 	struct resource *r, *mem = NULL;
 	int ret = 0, irq = 0;
 	size_t mem_size;
+	struct dmaengine_chan_caps *dma_chan_caps;
 
 	/* REVISIT:  when we're fully converted, fail if pdata is NULL */
 
@@ -1215,12 +1184,6 @@ static int __init davinci_mmcsd_probe(struct platform_device *pdev)
 
 	init_mmcsd_host(host);
 
-	if (pdata->nr_sg)
-		host->nr_sg = pdata->nr_sg - 1;
-
-	if (host->nr_sg > MAX_NR_SG || !host->nr_sg)
-		host->nr_sg = MAX_NR_SG;
-
 	host->use_dma = use_dma;
 	host->mmc_irq = irq;
 	host->sdio_irq = platform_get_irq(pdev, 1);
@@ -1249,14 +1212,27 @@ static int __init davinci_mmcsd_probe(struct platform_device *pdev)
 		mmc->caps |= pdata->caps;
 	mmc->ocr_avail = MMC_VDD_32_33 | MMC_VDD_33_34;
 
-	/* With no iommu coalescing pages, each phys_seg is a hw_seg.
-	 * Each hw_seg uses one EDMA parameter RAM slot, always one
-	 * channel and then usually some linked slots.
-	 */
-	mmc->max_segs		= MAX_NR_SG;
+	{
+		struct dma_slave_config dma_txrx_conf = {
+			.src_addr = host->mem_res->start + DAVINCI_MMCDRR,
+			.src_addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES,
+			.src_maxburst =
+				rw_threshold / DMA_SLAVE_BUSWIDTH_4_BYTES,
+			.dst_addr = host->mem_res->start + DAVINCI_MMCDXR,
+			.dst_addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES,
+			.dst_maxburst =
+				rw_threshold / DMA_SLAVE_BUSWIDTH_4_BYTES,
+		};
+		dmaengine_slave_config(host->dma_tx, &dma_txrx_conf);
+		dmaengine_slave_config(host->dma_rx, &dma_txrx_conf);
+	}
 
-	/* EDMA limit per hw segment (one or two MBytes) */
-	mmc->max_seg_size	= MAX_CCNT * rw_threshold;
+	/* Just check one channel for the DMA SG limits */
+	dma_chan_caps = dma_get_channel_caps(host->dma_tx, DMA_MEM_TO_DEV);
+	if (dma_chan_caps) {
+		mmc->max_segs = dma_chan_caps->seg_nr;
+		mmc->max_seg_size = dma_chan_caps->seg_len;
+	}
 
 	/* MMC/SD controller limits for multiblock requests */
 	mmc->max_blk_size	= 4095;  /* BLEN is 12 bits */
diff --git a/include/linux/platform_data/mmc-davinci.h b/include/linux/platform_data/mmc-davinci.h
index 5ba6b22..6910209 100644
--- a/include/linux/platform_data/mmc-davinci.h
+++ b/include/linux/platform_data/mmc-davinci.h
@@ -25,9 +25,6 @@ struct davinci_mmc_config {
 
 	/* Version of the MMC/SD controller */
 	u8	version;
-
-	/* Number of sg segments */
-	u8	nr_sg;
 };
 void davinci_setup_mmc(int module, struct davinci_mmc_config *config);
 
-- 
1.7.9.5

