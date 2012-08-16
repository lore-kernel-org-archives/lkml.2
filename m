Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964796Ab2HPObj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 10:31:39 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:1111 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932672Ab2HPObe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 10:31:34 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 16 Aug 2012 07:31:21 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <swarren@wwwdotorg.org>, <olof@lixom.net>, <grant.likely@secretlab.ca>,
        <lrg@ti.com>, <broonie@opensource.wolfsonmicro.com>
CC: <vinod.koul@linux.intel.com>, <linux@arm.linux.org.uk>,
        <linux-kernel@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        <spi-devel-general@lists.sourceforge.net>,
        <alsa-devel@alsa-project.org>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 4/5] spi: tegra: remove support of legacy DMA driver based access
Date: Thu, 16 Aug 2012 19:43:16 +0530
Message-ID: <1345126397-28864-5-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1345126397-28864-1-git-send-email-ldewangan@nvidia.com>
References: <1345126397-28864-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the support code which uses the legacy APB DMA driver
for accessing the SPI FIFO.
The driver will use the dmaengine based APB DMA driver for
accessing reqding/writing to SPI FIFO.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 drivers/spi/Kconfig     |    2 +-
 drivers/spi/spi-tegra.c |   55 +----------------------------------------------
 2 files changed, 2 insertions(+), 55 deletions(-)

diff --git a/drivers/spi/Kconfig b/drivers/spi/Kconfig
index 5f84b55..2d198a0 100644
--- a/drivers/spi/Kconfig
+++ b/drivers/spi/Kconfig
@@ -366,7 +366,7 @@ config SPI_STMP3XXX
 
 config SPI_TEGRA
 	tristate "Nvidia Tegra SPI controller"
-	depends on ARCH_TEGRA && (TEGRA_SYSTEM_DMA || TEGRA20_APB_DMA)
+	depends on ARCH_TEGRA && TEGRA20_APB_DMA
 	help
 	  SPI driver for NVidia Tegra SoCs
 
diff --git a/drivers/spi/spi-tegra.c b/drivers/spi/spi-tegra.c
index ef52c1c..488d9b6 100644
--- a/drivers/spi/spi-tegra.c
+++ b/drivers/spi/spi-tegra.c
@@ -164,23 +164,15 @@ struct spi_tegra_data {
 	 * for the generic case.
 	 */
 	int			dma_req_len;
-#if defined(CONFIG_TEGRA_SYSTEM_DMA)
-	struct tegra_dma_req	rx_dma_req;
-	struct tegra_dma_channel *rx_dma;
-#else
 	struct dma_chan		*rx_dma;
 	struct dma_slave_config	sconfig;
 	struct dma_async_tx_descriptor	*rx_dma_desc;
 	dma_cookie_t		rx_cookie;
-#endif
 	u32			*rx_bb;
 	dma_addr_t		rx_bb_phys;
 };
 
-#if !defined(CONFIG_TEGRA_SYSTEM_DMA)
 static void tegra_spi_rx_dma_complete(void *args);
-#endif
-
 static inline unsigned long spi_tegra_readl(struct spi_tegra_data *tspi,
 					    unsigned long reg)
 {
@@ -204,10 +196,6 @@ static void spi_tegra_go(struct spi_tegra_data *tspi)
 	val &= ~SLINK_DMA_BLOCK_SIZE(~0) & ~SLINK_DMA_EN;
 	val |= SLINK_DMA_BLOCK_SIZE(tspi->dma_req_len / 4 - 1);
 	spi_tegra_writel(tspi, val, SLINK_DMA_CTL);
-#if defined(CONFIG_TEGRA_SYSTEM_DMA)
-	tspi->rx_dma_req.size = tspi->dma_req_len;
-	tegra_dma_enqueue_req(tspi->rx_dma, &tspi->rx_dma_req);
-#else
 	tspi->rx_dma_desc = dmaengine_prep_slave_single(tspi->rx_dma,
 				tspi->rx_bb_phys, tspi->dma_req_len,
 				DMA_DEV_TO_MEM, DMA_PREP_INTERRUPT);
@@ -219,7 +207,6 @@ static void spi_tegra_go(struct spi_tegra_data *tspi)
 	tspi->rx_dma_desc->callback_param = tspi;
 	tspi->rx_cookie = dmaengine_submit(tspi->rx_dma_desc);
 	dma_async_issue_pending(tspi->rx_dma);
-#endif
 
 	val |= SLINK_DMA_EN;
 	spi_tegra_writel(tspi, val, SLINK_DMA_CTL);
@@ -405,19 +392,12 @@ static void handle_spi_rx_dma_complete(struct spi_tegra_data *tspi)
 
 	spin_unlock_irqrestore(&tspi->lock, flags);
 }
-#if defined(CONFIG_TEGRA_SYSTEM_DMA)
-static void tegra_spi_rx_dma_complete(struct tegra_dma_req *req)
-{
-	struct spi_tegra_data *tspi = req->dev;
-	handle_spi_rx_dma_complete(tspi);
-}
-#else
+
 static void tegra_spi_rx_dma_complete(void *args)
 {
 	struct spi_tegra_data *tspi = args;
 	handle_spi_rx_dma_complete(tspi);
 }
-#endif
 
 static int spi_tegra_setup(struct spi_device *spi)
 {
@@ -509,9 +489,7 @@ static int __devinit spi_tegra_probe(struct platform_device *pdev)
 	struct spi_tegra_data	*tspi;
 	struct resource		*r;
 	int ret;
-#if !defined(CONFIG_TEGRA_SYSTEM_DMA)
 	dma_cap_mask_t mask;
-#endif
 
 	master = spi_alloc_master(&pdev->dev, sizeof *tspi);
 	if (master == NULL) {
@@ -563,14 +541,6 @@ static int __devinit spi_tegra_probe(struct platform_device *pdev)
 
 	INIT_LIST_HEAD(&tspi->queue);
 
-#if defined(CONFIG_TEGRA_SYSTEM_DMA)
-	tspi->rx_dma = tegra_dma_allocate_channel(TEGRA_DMA_MODE_ONESHOT);
-	if (!tspi->rx_dma) {
-		dev_err(&pdev->dev, "can not allocate rx dma channel\n");
-		ret = -ENODEV;
-		goto err3;
-	}
-#else
 	dma_cap_zero(mask);
 	dma_cap_set(DMA_SLAVE, mask);
 	tspi->rx_dma = dma_request_channel(mask, NULL, NULL);
@@ -580,8 +550,6 @@ static int __devinit spi_tegra_probe(struct platform_device *pdev)
 		goto err3;
 	}
 
-#endif
-
 	tspi->rx_bb = dma_alloc_coherent(&pdev->dev, sizeof(u32) * BB_LEN,
 					 &tspi->rx_bb_phys, GFP_KERNEL);
 	if (!tspi->rx_bb) {
@@ -590,17 +558,6 @@ static int __devinit spi_tegra_probe(struct platform_device *pdev)
 		goto err4;
 	}
 
-#if defined(CONFIG_TEGRA_SYSTEM_DMA)
-	tspi->rx_dma_req.complete = tegra_spi_rx_dma_complete;
-	tspi->rx_dma_req.to_memory = 1;
-	tspi->rx_dma_req.dest_addr = tspi->rx_bb_phys;
-	tspi->rx_dma_req.dest_bus_width = 32;
-	tspi->rx_dma_req.source_addr = tspi->phys + SLINK_RX_FIFO;
-	tspi->rx_dma_req.source_bus_width = 32;
-	tspi->rx_dma_req.source_wrap = 4;
-	tspi->rx_dma_req.req_sel = spi_tegra_req_sels[pdev->id];
-	tspi->rx_dma_req.dev = tspi;
-#else
 	/* Dmaengine Dma slave config */
 	tspi->sconfig.src_addr = tspi->phys + SLINK_RX_FIFO;
 	tspi->sconfig.dst_addr = tspi->phys + SLINK_RX_FIFO;
@@ -616,7 +573,6 @@ static int __devinit spi_tegra_probe(struct platform_device *pdev)
 			ret);
 		goto err4;
 	}
-#endif
 
 	master->dev.of_node = pdev->dev.of_node;
 	ret = spi_register_master(master);
@@ -630,11 +586,7 @@ err5:
 	dma_free_coherent(&pdev->dev, sizeof(u32) * BB_LEN,
 			  tspi->rx_bb, tspi->rx_bb_phys);
 err4:
-#if defined(CONFIG_TEGRA_SYSTEM_DMA)
-	tegra_dma_free_channel(tspi->rx_dma);
-#else
 	dma_release_channel(tspi->rx_dma);
-#endif
 err3:
 	clk_put(tspi->clk);
 err2:
@@ -656,12 +608,7 @@ static int __devexit spi_tegra_remove(struct platform_device *pdev)
 	tspi = spi_master_get_devdata(master);
 
 	spi_unregister_master(master);
-#if defined(CONFIG_TEGRA_SYSTEM_DMA)
-	tegra_dma_free_channel(tspi->rx_dma);
-#else
 	dma_release_channel(tspi->rx_dma);
-#endif
-
 	dma_free_coherent(&pdev->dev, sizeof(u32) * BB_LEN,
 			  tspi->rx_bb, tspi->rx_bb_phys);
 
-- 
1.7.1.1

