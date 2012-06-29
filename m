Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753171Ab2F2Lec (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 07:34:32 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:19320 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991Ab2F2Leb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 07:34:31 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Fri, 29 Jun 2012 04:34:14 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <swarren@wwwdotorg.org>, <grant.likely@secretlab.ca>
CC: <spi-devel-general@lists.sourceforge.net>, <linux-kernel@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH] spi: tegra: use dmaengine based dma driver
Date: Fri, 29 Jun 2012 17:01:20 +0530
Message-ID: <1340969480-7702-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the dmaengine based Tegra APB DMA driver for
data transfer between SPI FIFO and memory in
place of legacy Tegra APB DMA.

The new driver is selected if legacy driver is not
selected and new DMA driver is enabled through config
file.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 drivers/spi/Kconfig     |    2 +-
 drivers/spi/spi-tegra.c |   89 ++++++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 85 insertions(+), 6 deletions(-)

diff --git a/drivers/spi/Kconfig b/drivers/spi/Kconfig
index 8c8c680..b7b99e7 100644
--- a/drivers/spi/Kconfig
+++ b/drivers/spi/Kconfig
@@ -366,7 +366,7 @@ config SPI_STMP3XXX
 
 config SPI_TEGRA
 	tristate "Nvidia Tegra SPI controller"
-	depends on ARCH_TEGRA && TEGRA_SYSTEM_DMA
+	depends on ARCH_TEGRA && (TEGRA_SYSTEM_DMA || TEGRA20_APB_DMA)
 	help
 	  SPI driver for NVidia Tegra SoCs
 
diff --git a/drivers/spi/spi-tegra.c b/drivers/spi/spi-tegra.c
index 7f99ff3..ef52c1c 100644
--- a/drivers/spi/spi-tegra.c
+++ b/drivers/spi/spi-tegra.c
@@ -30,6 +30,7 @@
 #include <linux/delay.h>
 
 #include <linux/spi/spi.h>
+#include <linux/dmaengine.h>
 
 #include <mach/dma.h>
 
@@ -162,12 +163,23 @@ struct spi_tegra_data {
 	 * require transfers to be 4 byte aligned we need a bounce buffer
 	 * for the generic case.
 	 */
+	int			dma_req_len;
+#if defined(CONFIG_TEGRA_SYSTEM_DMA)
 	struct tegra_dma_req	rx_dma_req;
 	struct tegra_dma_channel *rx_dma;
+#else
+	struct dma_chan		*rx_dma;
+	struct dma_slave_config	sconfig;
+	struct dma_async_tx_descriptor	*rx_dma_desc;
+	dma_cookie_t		rx_cookie;
+#endif
 	u32			*rx_bb;
 	dma_addr_t		rx_bb_phys;
 };
 
+#if !defined(CONFIG_TEGRA_SYSTEM_DMA)
+static void tegra_spi_rx_dma_complete(void *args);
+#endif
 
 static inline unsigned long spi_tegra_readl(struct spi_tegra_data *tspi,
 					    unsigned long reg)
@@ -190,10 +202,24 @@ static void spi_tegra_go(struct spi_tegra_data *tspi)
 
 	val = spi_tegra_readl(tspi, SLINK_DMA_CTL);
 	val &= ~SLINK_DMA_BLOCK_SIZE(~0) & ~SLINK_DMA_EN;
-	val |= SLINK_DMA_BLOCK_SIZE(tspi->rx_dma_req.size / 4 - 1);
+	val |= SLINK_DMA_BLOCK_SIZE(tspi->dma_req_len / 4 - 1);
 	spi_tegra_writel(tspi, val, SLINK_DMA_CTL);
-
+#if defined(CONFIG_TEGRA_SYSTEM_DMA)
+	tspi->rx_dma_req.size = tspi->dma_req_len;
 	tegra_dma_enqueue_req(tspi->rx_dma, &tspi->rx_dma_req);
+#else
+	tspi->rx_dma_desc = dmaengine_prep_slave_single(tspi->rx_dma,
+				tspi->rx_bb_phys, tspi->dma_req_len,
+				DMA_DEV_TO_MEM, DMA_PREP_INTERRUPT);
+	if (!tspi->rx_dma_desc) {
+		dev_err(&tspi->pdev->dev, "dmaengine slave prep failed\n");
+		return;
+	}
+	tspi->rx_dma_desc->callback = tegra_spi_rx_dma_complete;
+	tspi->rx_dma_desc->callback_param = tspi;
+	tspi->rx_cookie = dmaengine_submit(tspi->rx_dma_desc);
+	dma_async_issue_pending(tspi->rx_dma);
+#endif
 
 	val |= SLINK_DMA_EN;
 	spi_tegra_writel(tspi, val, SLINK_DMA_CTL);
@@ -221,7 +247,7 @@ static unsigned spi_tegra_fill_tx_fifo(struct spi_tegra_data *tspi,
 		spi_tegra_writel(tspi, val, SLINK_TX_FIFO);
 	}
 
-	tspi->rx_dma_req.size = len / tspi->cur_bytes_per_word * 4;
+	tspi->dma_req_len = len / tspi->cur_bytes_per_word * 4;
 
 	return len;
 }
@@ -318,9 +344,8 @@ static void spi_tegra_start_message(struct spi_device *spi,
 	spi_tegra_start_transfer(spi, t);
 }
 
-static void tegra_spi_rx_dma_complete(struct tegra_dma_req *req)
+static void handle_spi_rx_dma_complete(struct spi_tegra_data *tspi)
 {
-	struct spi_tegra_data *tspi = req->dev;
 	unsigned long flags;
 	struct spi_message *m;
 	struct spi_device *spi;
@@ -380,6 +405,19 @@ static void tegra_spi_rx_dma_complete(struct tegra_dma_req *req)
 
 	spin_unlock_irqrestore(&tspi->lock, flags);
 }
+#if defined(CONFIG_TEGRA_SYSTEM_DMA)
+static void tegra_spi_rx_dma_complete(struct tegra_dma_req *req)
+{
+	struct spi_tegra_data *tspi = req->dev;
+	handle_spi_rx_dma_complete(tspi);
+}
+#else
+static void tegra_spi_rx_dma_complete(void *args)
+{
+	struct spi_tegra_data *tspi = args;
+	handle_spi_rx_dma_complete(tspi);
+}
+#endif
 
 static int spi_tegra_setup(struct spi_device *spi)
 {
@@ -471,6 +509,9 @@ static int __devinit spi_tegra_probe(struct platform_device *pdev)
 	struct spi_tegra_data	*tspi;
 	struct resource		*r;
 	int ret;
+#if !defined(CONFIG_TEGRA_SYSTEM_DMA)
+	dma_cap_mask_t mask;
+#endif
 
 	master = spi_alloc_master(&pdev->dev, sizeof *tspi);
 	if (master == NULL) {
@@ -522,12 +563,24 @@ static int __devinit spi_tegra_probe(struct platform_device *pdev)
 
 	INIT_LIST_HEAD(&tspi->queue);
 
+#if defined(CONFIG_TEGRA_SYSTEM_DMA)
 	tspi->rx_dma = tegra_dma_allocate_channel(TEGRA_DMA_MODE_ONESHOT);
 	if (!tspi->rx_dma) {
 		dev_err(&pdev->dev, "can not allocate rx dma channel\n");
 		ret = -ENODEV;
 		goto err3;
 	}
+#else
+	dma_cap_zero(mask);
+	dma_cap_set(DMA_SLAVE, mask);
+	tspi->rx_dma = dma_request_channel(mask, NULL, NULL);
+	if (!tspi->rx_dma) {
+		dev_err(&pdev->dev, "can not allocate rx dma channel\n");
+		ret = -ENODEV;
+		goto err3;
+	}
+
+#endif
 
 	tspi->rx_bb = dma_alloc_coherent(&pdev->dev, sizeof(u32) * BB_LEN,
 					 &tspi->rx_bb_phys, GFP_KERNEL);
@@ -537,6 +590,7 @@ static int __devinit spi_tegra_probe(struct platform_device *pdev)
 		goto err4;
 	}
 
+#if defined(CONFIG_TEGRA_SYSTEM_DMA)
 	tspi->rx_dma_req.complete = tegra_spi_rx_dma_complete;
 	tspi->rx_dma_req.to_memory = 1;
 	tspi->rx_dma_req.dest_addr = tspi->rx_bb_phys;
@@ -546,6 +600,23 @@ static int __devinit spi_tegra_probe(struct platform_device *pdev)
 	tspi->rx_dma_req.source_wrap = 4;
 	tspi->rx_dma_req.req_sel = spi_tegra_req_sels[pdev->id];
 	tspi->rx_dma_req.dev = tspi;
+#else
+	/* Dmaengine Dma slave config */
+	tspi->sconfig.src_addr = tspi->phys + SLINK_RX_FIFO;
+	tspi->sconfig.dst_addr = tspi->phys + SLINK_RX_FIFO;
+	tspi->sconfig.src_addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES;
+	tspi->sconfig.dst_addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES;
+	tspi->sconfig.slave_id = spi_tegra_req_sels[pdev->id];
+	tspi->sconfig.src_maxburst = 1;
+	tspi->sconfig.dst_maxburst = 1;
+	ret = dmaengine_device_control(tspi->rx_dma,
+			DMA_SLAVE_CONFIG, (unsigned long) &tspi->sconfig);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "can not do slave configure for dma %d\n",
+			ret);
+		goto err4;
+	}
+#endif
 
 	master->dev.of_node = pdev->dev.of_node;
 	ret = spi_register_master(master);
@@ -559,7 +630,11 @@ err5:
 	dma_free_coherent(&pdev->dev, sizeof(u32) * BB_LEN,
 			  tspi->rx_bb, tspi->rx_bb_phys);
 err4:
+#if defined(CONFIG_TEGRA_SYSTEM_DMA)
 	tegra_dma_free_channel(tspi->rx_dma);
+#else
+	dma_release_channel(tspi->rx_dma);
+#endif
 err3:
 	clk_put(tspi->clk);
 err2:
@@ -581,7 +656,11 @@ static int __devexit spi_tegra_remove(struct platform_device *pdev)
 	tspi = spi_master_get_devdata(master);
 
 	spi_unregister_master(master);
+#if defined(CONFIG_TEGRA_SYSTEM_DMA)
 	tegra_dma_free_channel(tspi->rx_dma);
+#else
+	dma_release_channel(tspi->rx_dma);
+#endif
 
 	dma_free_coherent(&pdev->dev, sizeof(u32) * BB_LEN,
 			  tspi->rx_bb, tspi->rx_bb_phys);
-- 
1.7.1.1

