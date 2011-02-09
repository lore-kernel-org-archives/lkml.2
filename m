Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754571Ab1BIKiO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 05:38:14 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:58144 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754524Ab1BIKiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 05:38:12 -0500
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 7/8] intel_mid_ssp_spi: Bounce data through the Langwell SRAM
 when needed
To: spi-devel-general@lists.sourceforge.net, russ.gorby@intel.com,
        grant.likely@secretlab.ca, linux-kernel@vger.kernel.org
Date: Wed, 09 Feb 2011 10:09:22 +0000
Message-ID: <20110209100918.555.28252.stgit@bob.linux.org.uk>
In-Reply-To: <20110209100231.555.90520.stgit@bob.linux.org.uk>
References: <20110209100231.555.90520.stgit@bob.linux.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

This is required for Moorestown slave mode operation

Based on earlier generic driver work by Mathieu SOULARD
<mathieux.soulard@intel.com>

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/spi/intel_mid_ssp_spi.c     |  123 ++++++++++++++++++++++++++++++++++-
 drivers/spi/intel_mid_ssp_spi_def.h |    7 ++
 2 files changed, 125 insertions(+), 5 deletions(-)


diff --git a/drivers/spi/intel_mid_ssp_spi.c b/drivers/spi/intel_mid_ssp_spi.c
index 26e41c2..8d7a157 100644
--- a/drivers/spi/intel_mid_ssp_spi.c
+++ b/drivers/spi/intel_mid_ssp_spi.c
@@ -186,8 +186,11 @@ struct driver_data {
 	int rxdma_done;
 	struct callback_param tx_param;
 	struct callback_param rx_param;
-	/* PM_QOS request (for Moorestown) */
+	/* PM_QOS request (for Moorestown slave) */
 	struct pm_qos_request_list pm_qos_req;
+	/* Bounce buffers for DMA (Moorestown slave) */
+	u8 __iomem *virt_addr_sram_tx;
+	u8 __iomem *virt_addr_sram_rx;
 };
 
 struct chip_data {
@@ -414,6 +417,29 @@ static void unmap_dma_buffers(struct driver_data *drv_data,
 	drv_data->dma_mapped = 0;
 }
 
+/**
+ * unmapcopy_dma_buffers() - Unmap the DMA buffers used during the last transfer.
+ * @drv_data:		Pointer to the private driver data
+ *
+ * Handle the buffer unmap when the data is being bounced through Langwell
+ * (Moorestown in slave mode)
+ */
+static void unmapcopy_dma_buffers(struct driver_data *drv_data,
+			      struct spi_message *msg)
+{
+	struct device *dev = &drv_data->pdev->dev;
+
+	if (unlikely(!drv_data->dma_mapped)) {
+		dev_err(dev, "ERROR : DMA buffers not mapped");
+		return;
+	}
+	if (unlikely(msg->is_dma_mapped))
+		return;
+
+	memcpy_fromio(drv_data->rx, drv_data->virt_addr_sram_rx, drv_data->len);
+	drv_data->dma_mapped = 0;
+}
+
 
 static void dma_transfer_complete(void *arg)
 {
@@ -450,7 +476,10 @@ static void dma_transfer_complete(void *arg)
 						PM_QOS_DEFAULT_VALUE);
 
 	/* release DMA mappings */
-	unmap_dma_buffers(drv_data, drv_data->cur_msg);
+	if (drv_data->quirks & QUIRKS_SRAM_ADDITIONAL_CPY)
+		unmapcopy_dma_buffers(drv_data, drv_data->cur_msg);
+	else
+		unmap_dma_buffers(drv_data, drv_data->cur_msg);
 
 	/* Update total byte transfered return count actual bytes read */
 	drv_data->cur_msg->actual_length = drv_data->len;
@@ -461,6 +490,40 @@ static void dma_transfer_complete(void *arg)
 }
 
 /**
+ * intel_mid_ssp_spi_map_sram() - Map SRAM
+ * @drv_data:		Pointer to the private driver data
+ *
+ * Map the Langwell SRAM used for bouncing on the Moorestown platform in
+ * slave mode.
+ */
+static int intel_mid_ssp_spi_map_sram(struct driver_data *drv_data)
+{
+	struct device *dev = &drv_data->pdev->dev;
+
+	drv_data->virt_addr_sram_rx = ioremap_nocache(SRAM_BASE_ADDR,
+						2 * MAX_SPI_TRANSFER_SIZE);
+	if (drv_data->virt_addr_sram_rx == NULL) {
+		dev_err(dev, "Virt_addr_sram_rx is null\n");
+		return -ENOMEM;
+	}
+	drv_data->virt_addr_sram_tx =
+		drv_data->virt_addr_sram_rx + MAX_SPI_TRANSFER_SIZE;
+	return 0;
+}
+
+/**
+ * intel_mid_ssp_spi_unmap_sram() - Map SRAM
+ * @drv_data:		Pointer to the private driver data
+ *
+ * Unmap the Langwell SRAM used for bouncing on the Moorestown platform in
+ * slave mode.
+ */
+static void intel_mid_ssp_spi_unmap_sram(struct driver_data *drv_data)
+{
+	iounmap(drv_data->virt_addr_sram_rx);
+}
+
+/**
  * intel_mid_ssp_spi_dma_init() - Initialize DMA
  * @drv_data:		Pointer to the private driver data
  *
@@ -486,6 +549,10 @@ static void intel_mid_ssp_spi_dma_init(struct driver_data *drv_data)
 		return;
 	}
 
+	if (drv_data->quirks & QUIRKS_SRAM_ADDITIONAL_CPY)
+		if (intel_mid_ssp_spi_map_sram(drv_data) < 0)
+			return;
+
 	/* 1. init rx channel */
 	rxs = &drv_data->dmas_rx;
 	rxs->hs_mode = LNW_DMA_HW_HS;
@@ -534,6 +601,9 @@ static void intel_mid_ssp_spi_dma_init(struct driver_data *drv_data)
 free_rxchan:
 	dev_err(&drv_data->pdev->dev, "DMA TX Channel Not available");
 	dma_release_channel(drv_data->rxchan);
+	if (drv_data->quirks & QUIRKS_SRAM_ADDITIONAL_CPY)
+		intel_mid_ssp_spi_unmap_sram(drv_data);
+		
 err_exit:
 	dev_err(&drv_data->pdev->dev, "DMA RX Channel Not available");
 	pci_dev_put(drv_data->dmac1);
@@ -549,6 +619,8 @@ static void intel_mid_ssp_spi_dma_exit(struct driver_data *drv_data)
 		return;
 	dma_release_channel(drv_data->txchan);
 	dma_release_channel(drv_data->rxchan);
+	if (drv_data->quirks & QUIRKS_SRAM_ADDITIONAL_CPY)
+		intel_mid_ssp_spi_unmap_sram(drv_data);
 	pci_dev_put(drv_data->dmac1);
 	drv_data->dma_inited = 0;
 }
@@ -667,6 +739,42 @@ static int map_dma_buffers(struct driver_data *drv_data,
 	return 1;
 }
 
+/**
+ * mapcopy_dma_buffers() - Map DMA buffer before a transfer
+ * @drv_data:		Pointer to the private driver data
+ *
+ * Copy the data buffer into SRAM and then set that for DMA
+ */
+static int mapcopy_dma_buffers(struct driver_data *drv_data,
+			   struct spi_message *msg,
+			   struct spi_transfer *transfer)
+{
+	struct device *dev = &drv_data->pdev->dev;
+
+	if (unlikely(drv_data->dma_mapped)) {
+		dev_err(dev, "ERROR : DMA buffers already mapped");
+		return 0;
+	}
+	if (unlikely(msg->is_dma_mapped)) {
+		drv_data->rx_dma = transfer->rx_dma;
+		drv_data->tx_dma = transfer->tx_dma;
+		return 1;
+	}
+	if (drv_data->len > PCI_DMAC_MAXDI * drv_data->n_bytes) {
+		/* if length is too long we revert to programmed I/O */
+		return 0;
+	}
+
+	if (likely(drv_data->rx))
+		drv_data->rx_dma = SRAM_RX_ADDR;
+	if (likely(drv_data->tx)) {
+		memcpy_toio(drv_data->virt_addr_sram_tx, drv_data->tx,
+			drv_data->len);
+		drv_data->tx_dma = SRAM_TX_ADDR;
+	}
+	return 1;
+}
+
 static void set_dma_width(struct driver_data *drv_data, int bits)
 {
 	struct dma_slave_config *rxconf, *txconf;
@@ -1017,9 +1125,14 @@ static int transfer(struct spi_device *spi, struct spi_message *msg)
 	}
 
 	/* try to map dma buffer and do a dma transfer if successful */
-	if (likely(chip->enable_dma))
-		drv_data->dma_mapped = map_dma_buffers(drv_data, msg, transfer);
-	else {
+	if (likely(chip->enable_dma)) {
+		if (drv_data->quirks & QUIRKS_SRAM_ADDITIONAL_CPY)
+			drv_data->dma_mapped = mapcopy_dma_buffers(drv_data,
+								msg, transfer);
+		else
+			drv_data->dma_mapped = map_dma_buffers(drv_data,
+								msg, transfer);
+	} else {
 		WARN_ON(drv_data->dma_mapped != 0);
 		drv_data->dma_mapped = 0;
 	}
diff --git a/drivers/spi/intel_mid_ssp_spi_def.h b/drivers/spi/intel_mid_ssp_spi_def.h
index 88d872b..8c4d6e7 100644
--- a/drivers/spi/intel_mid_ssp_spi_def.h
+++ b/drivers/spi/intel_mid_ssp_spi_def.h
@@ -117,6 +117,13 @@
 #define SSPSP	0x2c
 #define SYSCFG	0x20bc0
 
+/* Needed for slave mode on Moorestown. There is no neat architectural way to
+   get these values but they won't change */
+#define SRAM_BASE_ADDR 0xfffdc000
+#define MAX_SPI_TRANSFER_SIZE 8192
+#define SRAM_RX_ADDR   SRAM_BASE_ADDR
+#define SRAM_TX_ADDR  (SRAM_BASE_ADDR + MAX_SPI_TRANSFER_SIZE)
+
 /* SSP assignement configuration from PCI config */
 #define SSP_CFG_GET_MODE(ssp_cfg)	((ssp_cfg) & 0x07)
 #define SSP_CFG_GET_SPI_BUS_NB(ssp_cfg)	(((ssp_cfg) >> 3) & 0x07)

