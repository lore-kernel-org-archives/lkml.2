Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755740Ab1JNFrc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 01:47:32 -0400
Received: from mga14.intel.com ([143.182.124.37]:37982 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932552Ab1JNFr0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 01:47:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,344,1315206000"; 
   d="scan'208";a="62487039"
From: Vinod Koul <vinod.koul@intel.com>
To: dan.j.williams@intel.com
Cc: linux-kernel@vger.kernel.org, jaswinder.singh@linaro.org,
        21cnbao@gmail.com, rmk@arm.linux.org.uk,
        Vinod Koul <vinod.koul@linux.intel.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Alan Cox <alan@linux.intel.com>
Subject: [PATCH 07/10] spi, serial: move to dma_transfer_direction
Date: Fri, 14 Oct 2011 11:08:22 +0530
Message-Id: <1318570705-17595-8-git-send-email-vinod.koul@intel.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1318570705-17595-1-git-send-email-vinod.koul@intel.com>
References: <1318570705-17595-1-git-send-email-vinod.koul@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vinod Koul <vinod.koul@linux.intel.com>

Signed-off-by: Vinod Koul <vinod.koul@linux.intel.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Alan Cox <alan@linux.intel.com>
---
 drivers/spi/spi-dw-mid.c        |    8 ++++----
 drivers/spi/spi-ep93xx.c        |    5 ++++-
 drivers/spi/spi-pl022.c         |    8 ++++----
 drivers/spi/spi-topcliff-pch.c  |    4 ++--
 drivers/tty/serial/amba-pl011.c |    8 ++++----
 drivers/tty/serial/pch_uart.c   |    4 ++--
 drivers/tty/serial/sh-sci.c     |    4 ++--
 7 files changed, 22 insertions(+), 19 deletions(-)

diff --git a/drivers/spi/spi-dw-mid.c b/drivers/spi/spi-dw-mid.c
index 130e555..0e88d91 100644
--- a/drivers/spi/spi-dw-mid.c
+++ b/drivers/spi/spi-dw-mid.c
@@ -131,7 +131,7 @@ static int mid_spi_dma_transfer(struct dw_spi *dws, int cs_change)
 	rxchan = dws->rxchan;
 
 	/* 2. Prepare the TX dma transfer */
-	txconf.direction = DMA_TO_DEVICE;
+	txconf.direction = MEM_TO_DEV;
 	txconf.dst_addr = dws->dma_addr;
 	txconf.dst_maxburst = LNW_DMA_MSIZE_16;
 	txconf.src_addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES;
@@ -147,13 +147,13 @@ static int mid_spi_dma_transfer(struct dw_spi *dws, int cs_change)
 	txdesc = txchan->device->device_prep_slave_sg(txchan,
 				&dws->tx_sgl,
 				1,
-				DMA_TO_DEVICE,
+				MEM_TO_DEV,
 				DMA_PREP_INTERRUPT | DMA_COMPL_SKIP_DEST_UNMAP);
 	txdesc->callback = dw_spi_dma_done;
 	txdesc->callback_param = dws;
 
 	/* 3. Prepare the RX dma transfer */
-	rxconf.direction = DMA_FROM_DEVICE;
+	rxconf.direction = DEV_TO_MEM;
 	rxconf.src_addr = dws->dma_addr;
 	rxconf.src_maxburst = LNW_DMA_MSIZE_16;
 	rxconf.dst_addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES;
@@ -169,7 +169,7 @@ static int mid_spi_dma_transfer(struct dw_spi *dws, int cs_change)
 	rxdesc = rxchan->device->device_prep_slave_sg(rxchan,
 				&dws->rx_sgl,
 				1,
-				DMA_FROM_DEVICE,
+				DEV_TO_MEM,
 				DMA_PREP_INTERRUPT | DMA_COMPL_SKIP_DEST_UNMAP);
 	rxdesc->callback = dw_spi_dma_done;
 	rxdesc->callback_param = dws;
diff --git a/drivers/spi/spi-ep93xx.c b/drivers/spi/spi-ep93xx.c
index 1cf6454..8754a39 100644
--- a/drivers/spi/spi-ep93xx.c
+++ b/drivers/spi/spi-ep93xx.c
@@ -550,6 +550,7 @@ ep93xx_spi_dma_prepare(struct ep93xx_spi *espi, enum dma_data_direction dir)
 	struct dma_async_tx_descriptor *txd;
 	enum dma_slave_buswidth buswidth;
 	struct dma_slave_config conf;
+	enum dma_transfer_direction slave_dirn;
 	struct scatterlist *sg;
 	struct sg_table *sgt;
 	struct dma_chan *chan;
@@ -572,6 +573,7 @@ ep93xx_spi_dma_prepare(struct ep93xx_spi *espi, enum dma_data_direction dir)
 
 		conf.src_addr = espi->sspdr_phys;
 		conf.src_addr_width = buswidth;
+		slave_dirn = DEV_TO_MEM;
 	} else {
 		chan = espi->dma_tx;
 		buf = t->tx_buf;
@@ -579,6 +581,7 @@ ep93xx_spi_dma_prepare(struct ep93xx_spi *espi, enum dma_data_direction dir)
 
 		conf.dst_addr = espi->sspdr_phys;
 		conf.dst_addr_width = buswidth;
+		slave_dirn = MEM_TO_DEV;
 	}
 
 	ret = dmaengine_slave_config(chan, &conf);
@@ -630,7 +633,7 @@ ep93xx_spi_dma_prepare(struct ep93xx_spi *espi, enum dma_data_direction dir)
 		return ERR_PTR(-ENOMEM);
 
 	txd = chan->device->device_prep_slave_sg(chan, sgt->sgl, nents,
-						 dir, DMA_CTRL_ACK);
+						 slave_dirn, DMA_CTRL_ACK);
 	if (!txd) {
 		dma_unmap_sg(chan->device->dev, sgt->sgl, sgt->nents, dir);
 		return ERR_PTR(-ENOMEM);
diff --git a/drivers/spi/spi-pl022.c b/drivers/spi/spi-pl022.c
index 730b4a3..33bcca6 100644
--- a/drivers/spi/spi-pl022.c
+++ b/drivers/spi/spi-pl022.c
@@ -910,11 +910,11 @@ static int configure_dma(struct pl022 *pl022)
 {
 	struct dma_slave_config rx_conf = {
 		.src_addr = SSP_DR(pl022->phybase),
-		.direction = DMA_FROM_DEVICE,
+		.direction = DEV_TO_MEM,
 	};
 	struct dma_slave_config tx_conf = {
 		.dst_addr = SSP_DR(pl022->phybase),
-		.direction = DMA_TO_DEVICE,
+		.direction = MEM_TO_DEV,
 	};
 	unsigned int pages;
 	int ret;
@@ -1051,7 +1051,7 @@ static int configure_dma(struct pl022 *pl022)
 	rxdesc = rxchan->device->device_prep_slave_sg(rxchan,
 				      pl022->sgt_rx.sgl,
 				      rx_sglen,
-				      DMA_FROM_DEVICE,
+				      DEV_TO_MEM,
 				      DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
 	if (!rxdesc)
 		goto err_rxdesc;
@@ -1059,7 +1059,7 @@ static int configure_dma(struct pl022 *pl022)
 	txdesc = txchan->device->device_prep_slave_sg(txchan,
 				      pl022->sgt_tx.sgl,
 				      tx_sglen,
-				      DMA_TO_DEVICE,
+				      MEM_TO_DEV,
 				      DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
 	if (!txdesc)
 		goto err_txdesc;
diff --git a/drivers/spi/spi-topcliff-pch.c b/drivers/spi/spi-topcliff-pch.c
index 1d23f38..11232a0 100644
--- a/drivers/spi/spi-topcliff-pch.c
+++ b/drivers/spi/spi-topcliff-pch.c
@@ -1051,7 +1051,7 @@ static void pch_spi_handle_dma(struct pch_spi_data *data, int *bpw)
 	}
 	sg = dma->sg_rx_p;
 	desc_rx = dma->chan_rx->device->device_prep_slave_sg(dma->chan_rx, sg,
-					num, DMA_FROM_DEVICE,
+					num, DEV_TO_MEM,
 					DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
 	if (!desc_rx) {
 		dev_err(&data->master->dev, "%s:device_prep_slave_sg Failed\n",
@@ -1086,7 +1086,7 @@ static void pch_spi_handle_dma(struct pch_spi_data *data, int *bpw)
 	}
 	sg = dma->sg_tx_p;
 	desc_tx = dma->chan_tx->device->device_prep_slave_sg(dma->chan_tx,
-					sg, num, DMA_TO_DEVICE,
+					sg, num, MEM_TO_DEV,
 					DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
 	if (!desc_tx) {
 		dev_err(&data->master->dev, "%s:device_prep_slave_sg Failed\n",
diff --git a/drivers/tty/serial/amba-pl011.c b/drivers/tty/serial/amba-pl011.c
index f5f6831..d5305af 100644
--- a/drivers/tty/serial/amba-pl011.c
+++ b/drivers/tty/serial/amba-pl011.c
@@ -268,7 +268,7 @@ static void pl011_dma_probe_initcall(struct uart_amba_port *uap)
 	struct dma_slave_config tx_conf = {
 		.dst_addr = uap->port.mapbase + UART01x_DR,
 		.dst_addr_width = DMA_SLAVE_BUSWIDTH_1_BYTE,
-		.direction = DMA_TO_DEVICE,
+		.direction = MEM_TO_DEV,
 		.dst_maxburst = uap->fifosize >> 1,
 	};
 	struct dma_chan *chan;
@@ -301,7 +301,7 @@ static void pl011_dma_probe_initcall(struct uart_amba_port *uap)
 		struct dma_slave_config rx_conf = {
 			.src_addr = uap->port.mapbase + UART01x_DR,
 			.src_addr_width = DMA_SLAVE_BUSWIDTH_1_BYTE,
-			.direction = DMA_FROM_DEVICE,
+			.direction = DEV_TO_MEM,
 			.src_maxburst = uap->fifosize >> 1,
 		};
 
@@ -480,7 +480,7 @@ static int pl011_dma_tx_refill(struct uart_amba_port *uap)
 		return -EBUSY;
 	}
 
-	desc = dma_dev->device_prep_slave_sg(chan, &dmatx->sg, 1, DMA_TO_DEVICE,
+	desc = dma_dev->device_prep_slave_sg(chan, &dmatx->sg, 1, MEM_TO_DEV,
 					     DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
 	if (!desc) {
 		dma_unmap_sg(dma_dev->dev, &dmatx->sg, 1, DMA_TO_DEVICE);
@@ -676,7 +676,7 @@ static int pl011_dma_rx_trigger_dma(struct uart_amba_port *uap)
 		&uap->dmarx.sgbuf_b : &uap->dmarx.sgbuf_a;
 	dma_dev = rxchan->device;
 	desc = rxchan->device->device_prep_slave_sg(rxchan, &sgbuf->sg, 1,
-					DMA_FROM_DEVICE,
+					DEV_TO_MEM,
 					DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
 	/*
 	 * If the DMA engine is busy and cannot prepare a
diff --git a/drivers/tty/serial/pch_uart.c b/drivers/tty/serial/pch_uart.c
index b46218d..162189e 100644
--- a/drivers/tty/serial/pch_uart.c
+++ b/drivers/tty/serial/pch_uart.c
@@ -747,7 +747,7 @@ static int dma_handle_rx(struct eg20t_port *priv)
 	sg_dma_address(sg) = priv->rx_buf_dma;
 
 	desc = priv->chan_rx->device->device_prep_slave_sg(priv->chan_rx,
-			sg, 1, DMA_FROM_DEVICE,
+			sg, 1, DEV_TO_MEM,
 			DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
 
 	if (!desc)
@@ -906,7 +906,7 @@ static unsigned int dma_handle_tx(struct eg20t_port *priv)
 	}
 
 	desc = priv->chan_tx->device->device_prep_slave_sg(priv->chan_tx,
-					priv->sg_tx_p, nent, DMA_TO_DEVICE,
+					priv->sg_tx_p, nent, MEM_TO_DEV,
 					DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
 	if (!desc) {
 		dev_err(priv->port.dev, "%s:device_prep_slave_sg Failed\n",
diff --git a/drivers/tty/serial/sh-sci.c b/drivers/tty/serial/sh-sci.c
index dbd32a1..e147e65 100644
--- a/drivers/tty/serial/sh-sci.c
+++ b/drivers/tty/serial/sh-sci.c
@@ -1207,7 +1207,7 @@ static void sci_submit_rx(struct sci_port *s)
 		struct dma_async_tx_descriptor *desc;
 
 		desc = chan->device->device_prep_slave_sg(chan,
-			sg, 1, DMA_FROM_DEVICE, DMA_PREP_INTERRUPT);
+			sg, 1, DEV_TO_MEM, DMA_PREP_INTERRUPT);
 
 		if (desc) {
 			s->desc_rx[i] = desc;
@@ -1322,7 +1322,7 @@ static void work_fn_tx(struct work_struct *work)
 	BUG_ON(!sg_dma_len(sg));
 
 	desc = chan->device->device_prep_slave_sg(chan,
-			sg, s->sg_len_tx, DMA_TO_DEVICE,
+			sg, s->sg_len_tx, MEM_TO_DEV,
 			DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
 	if (!desc) {
 		/* switch to PIO */
-- 
1.7.0.4

