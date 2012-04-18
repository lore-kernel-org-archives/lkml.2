Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752570Ab2DRBqo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 21:46:44 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:2701 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751708Ab2DRBqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 21:46:43 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-7.tower-209.messagelabs.com!1334713601!3458348!2
X-Originating-IP: [216.166.12.97]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] spi/spi-ep93xx.c: use dma_transfer_direction instead of dma_data_direction
Date: Tue, 17 Apr 2012 18:46:36 -0700
User-Agent: KMail/1.9.9
CC: <spi-devel-general@lists.sourceforge.net>, <grant.likely@secretlab.ca>,
        <vinod.koul@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201204171846.37245.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A new enum indicating the dma channel direction was introduced by:

commit 49920bc66984a512f4bcc7735a61642cd0e4d6f2
    dmaengine: add new enum dma_transfer_direction

The following commit changed spi-ep93xx to use the new enum:

commit a485df4b4404379786c4bdd258bc528b2617449d
    spi, serial: move to dma_transfer_direction

In doing so a sparse warning was introduced: 

warning: mixing different enum types
   int enum dma_data_direction  versus
   int enum dma_transfer_direction

This is produced because the 'dir' passed in ep93xx_spi_dma_prepare
is an enum dma_data_direction and is being used to set the
dma_slave_config 'direction' which is now an enum dma_transfer_direction.

Fix this by converting spi-ep93xx to use the new enum type in all
places.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Vinod Koul <vinod.koul@linux.intel.com>

---

diff --git a/drivers/spi/spi-ep93xx.c b/drivers/spi/spi-ep93xx.c
index 6db2887..e805507 100644
--- a/drivers/spi/spi-ep93xx.c
+++ b/drivers/spi/spi-ep93xx.c
@@ -545,13 +545,12 @@ static void ep93xx_spi_pio_transfer(struct ep93xx_spi *espi)
  * in case of failure.
  */
 static struct dma_async_tx_descriptor *
-ep93xx_spi_dma_prepare(struct ep93xx_spi *espi, enum dma_data_direction dir)
+ep93xx_spi_dma_prepare(struct ep93xx_spi *espi, enum dma_transfer_direction dir)
 {
 	struct spi_transfer *t = espi->current_msg->state;
 	struct dma_async_tx_descriptor *txd;
 	enum dma_slave_buswidth buswidth;
 	struct dma_slave_config conf;
-	enum dma_transfer_direction slave_dirn;
 	struct scatterlist *sg;
 	struct sg_table *sgt;
 	struct dma_chan *chan;
@@ -567,14 +566,13 @@ ep93xx_spi_dma_prepare(struct ep93xx_spi *espi, enum dma_data_direction dir)
 	memset(&conf, 0, sizeof(conf));
 	conf.direction = dir;
 
-	if (dir == DMA_FROM_DEVICE) {
+	if (dir == DMA_DEV_TO_MEM) {
 		chan = espi->dma_rx;
 		buf = t->rx_buf;
 		sgt = &espi->rx_sgt;
 
 		conf.src_addr = espi->sspdr_phys;
 		conf.src_addr_width = buswidth;
-		slave_dirn = DMA_DEV_TO_MEM;
 	} else {
 		chan = espi->dma_tx;
 		buf = t->tx_buf;
@@ -582,7 +580,6 @@ ep93xx_spi_dma_prepare(struct ep93xx_spi *espi, enum dma_data_direction dir)
 
 		conf.dst_addr = espi->sspdr_phys;
 		conf.dst_addr_width = buswidth;
-		slave_dirn = DMA_MEM_TO_DEV;
 	}
 
 	ret = dmaengine_slave_config(chan, &conf);
@@ -633,8 +630,7 @@ ep93xx_spi_dma_prepare(struct ep93xx_spi *espi, enum dma_data_direction dir)
 	if (!nents)
 		return ERR_PTR(-ENOMEM);
 
-	txd = dmaengine_prep_slave_sg(chan, sgt->sgl, nents,
-					slave_dirn, DMA_CTRL_ACK);
+	txd = dmaengine_prep_slave_sg(chan, sgt->sgl, nents, dir, DMA_CTRL_ACK);
 	if (!txd) {
 		dma_unmap_sg(chan->device->dev, sgt->sgl, sgt->nents, dir);
 		return ERR_PTR(-ENOMEM);
@@ -651,12 +647,12 @@ ep93xx_spi_dma_prepare(struct ep93xx_spi *espi, enum dma_data_direction dir)
  * unmapped.
  */
 static void ep93xx_spi_dma_finish(struct ep93xx_spi *espi,
-				  enum dma_data_direction dir)
+				  enum dma_transfer_direction dir)
 {
 	struct dma_chan *chan;
 	struct sg_table *sgt;
 
-	if (dir == DMA_FROM_DEVICE) {
+	if (dir == DMA_DEV_TO_MEM) {
 		chan = espi->dma_rx;
 		sgt = &espi->rx_sgt;
 	} else {
@@ -677,16 +673,16 @@ static void ep93xx_spi_dma_transfer(struct ep93xx_spi *espi)
 	struct spi_message *msg = espi->current_msg;
 	struct dma_async_tx_descriptor *rxd, *txd;
 
-	rxd = ep93xx_spi_dma_prepare(espi, DMA_FROM_DEVICE);
+	rxd = ep93xx_spi_dma_prepare(espi, DMA_DEV_TO_MEM);
 	if (IS_ERR(rxd)) {
 		dev_err(&espi->pdev->dev, "DMA RX failed: %ld\n", PTR_ERR(rxd));
 		msg->status = PTR_ERR(rxd);
 		return;
 	}
 
-	txd = ep93xx_spi_dma_prepare(espi, DMA_TO_DEVICE);
+	txd = ep93xx_spi_dma_prepare(espi, DMA_MEM_TO_DEV);
 	if (IS_ERR(txd)) {
-		ep93xx_spi_dma_finish(espi, DMA_FROM_DEVICE);
+		ep93xx_spi_dma_finish(espi, DMA_DEV_TO_MEM);
 		dev_err(&espi->pdev->dev, "DMA TX failed: %ld\n", PTR_ERR(rxd));
 		msg->status = PTR_ERR(txd);
 		return;
@@ -705,8 +701,8 @@ static void ep93xx_spi_dma_transfer(struct ep93xx_spi *espi)
 
 	wait_for_completion(&espi->wait);
 
-	ep93xx_spi_dma_finish(espi, DMA_TO_DEVICE);
-	ep93xx_spi_dma_finish(espi, DMA_FROM_DEVICE);
+	ep93xx_spi_dma_finish(espi, DMA_MEM_TO_DEV);
+	ep93xx_spi_dma_finish(espi, DMA_DEV_TO_MEM);
 }
 
 /**
