Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933314Ab2BBVfz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 16:35:55 -0500
Received: from mxout1.idt.com ([157.165.5.25]:57335 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757450Ab2BBVdh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 16:33:37 -0500
From: Alexandre Bounine <alexandre.bounine@idt.com>
To: vinod.koul@intel.com, dan.j.williams@intel.com,
        linux-kernel@vger.kernel.org
Cc: Alexandre Bounine <alexandre.bounine@idt.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Alan Cox <alan@linux.intel.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 08/11] spi/serial: add context parameter for DMA_SLAVE and DMA_CYCLIC
Date: Thu,  2 Feb 2012 16:32:18 -0500
Message-Id: <1328218341-31436-9-git-send-email-alexandre.bounine@idt.com>
X-Mailer: git-send-email 1.7.8.4
In-Reply-To: <1328218341-31436-1-git-send-email-alexandre.bounine@idt.com>
References: <1328218341-31436-1-git-send-email-alexandre.bounine@idt.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixups for calls affected by adding the new context parameter to DMA_SLAVE
and DMA_CYCLIC interfaces.

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Alan Cox <alan@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/spi/spi-dw-mid.c        |    6 ++++--
 drivers/spi/spi-ep93xx.c        |    3 ++-
 drivers/spi/spi-pl022.c         |    6 ++++--
 drivers/spi/spi-topcliff-pch.c  |    6 ++++--
 drivers/tty/serial/amba-pl011.c |    6 ++++--
 drivers/tty/serial/pch_uart.c   |    5 +++--
 drivers/tty/serial/sh-sci.c     |    4 ++--
 7 files changed, 23 insertions(+), 13 deletions(-)

diff --git a/drivers/spi/spi-dw-mid.c b/drivers/spi/spi-dw-mid.c
index 8418eb0..bbb92d5 100644
--- a/drivers/spi/spi-dw-mid.c
+++ b/drivers/spi/spi-dw-mid.c
@@ -148,7 +148,8 @@ static int mid_spi_dma_transfer(struct dw_spi *dws, int cs_change)
 				&dws->tx_sgl,
 				1,
 				DMA_MEM_TO_DEV,
-				DMA_PREP_INTERRUPT | DMA_COMPL_SKIP_DEST_UNMAP);
+				DMA_PREP_INTERRUPT | DMA_COMPL_SKIP_DEST_UNMAP,
+				NULL);
 	txdesc->callback = dw_spi_dma_done;
 	txdesc->callback_param = dws;
 
@@ -170,7 +171,8 @@ static int mid_spi_dma_transfer(struct dw_spi *dws, int cs_change)
 				&dws->rx_sgl,
 				1,
 				DMA_DEV_TO_MEM,
-				DMA_PREP_INTERRUPT | DMA_COMPL_SKIP_DEST_UNMAP);
+				DMA_PREP_INTERRUPT | DMA_COMPL_SKIP_DEST_UNMAP,
+				NULL);
 	rxdesc->callback = dw_spi_dma_done;
 	rxdesc->callback_param = dws;
 
diff --git a/drivers/spi/spi-ep93xx.c b/drivers/spi/spi-ep93xx.c
index d46e55c..fdb622d 100644
--- a/drivers/spi/spi-ep93xx.c
+++ b/drivers/spi/spi-ep93xx.c
@@ -634,7 +634,8 @@ ep93xx_spi_dma_prepare(struct ep93xx_spi *espi, enum dma_data_direction dir)
 		return ERR_PTR(-ENOMEM);
 
 	txd = chan->device->device_prep_slave_sg(chan, sgt->sgl, nents,
-						 slave_dirn, DMA_CTRL_ACK);
+						 slave_dirn, DMA_CTRL_ACK,
+						 NULL);
 	if (!txd) {
 		dma_unmap_sg(chan->device->dev, sgt->sgl, sgt->nents, dir);
 		return ERR_PTR(-ENOMEM);
diff --git a/drivers/spi/spi-pl022.c b/drivers/spi/spi-pl022.c
index 2f9cb43..1e1e0a4 100644
--- a/drivers/spi/spi-pl022.c
+++ b/drivers/spi/spi-pl022.c
@@ -1042,7 +1042,8 @@ static int configure_dma(struct pl022 *pl022)
 				      pl022->sgt_rx.sgl,
 				      rx_sglen,
 				      DMA_DEV_TO_MEM,
-				      DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
+				      DMA_PREP_INTERRUPT | DMA_CTRL_ACK,
+				      NULL);
 	if (!rxdesc)
 		goto err_rxdesc;
 
@@ -1050,7 +1051,8 @@ static int configure_dma(struct pl022 *pl022)
 				      pl022->sgt_tx.sgl,
 				      tx_sglen,
 				      DMA_MEM_TO_DEV,
-				      DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
+				      DMA_PREP_INTERRUPT | DMA_CTRL_ACK,
+				      NULL);
 	if (!txdesc)
 		goto err_txdesc;
 
diff --git a/drivers/spi/spi-topcliff-pch.c b/drivers/spi/spi-topcliff-pch.c
index 2a6429d..cf83a8d 100644
--- a/drivers/spi/spi-topcliff-pch.c
+++ b/drivers/spi/spi-topcliff-pch.c
@@ -1080,7 +1080,8 @@ static void pch_spi_handle_dma(struct pch_spi_data *data, int *bpw)
 	sg = dma->sg_rx_p;
 	desc_rx = dma->chan_rx->device->device_prep_slave_sg(dma->chan_rx, sg,
 					num, DMA_DEV_TO_MEM,
-					DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
+					DMA_PREP_INTERRUPT | DMA_CTRL_ACK,
+					NULL);
 	if (!desc_rx) {
 		dev_err(&data->master->dev, "%s:device_prep_slave_sg Failed\n",
 			__func__);
@@ -1125,7 +1126,8 @@ static void pch_spi_handle_dma(struct pch_spi_data *data, int *bpw)
 	sg = dma->sg_tx_p;
 	desc_tx = dma->chan_tx->device->device_prep_slave_sg(dma->chan_tx,
 					sg, num, DMA_MEM_TO_DEV,
-					DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
+					DMA_PREP_INTERRUPT | DMA_CTRL_ACK,
+					NULL);
 	if (!desc_tx) {
 		dev_err(&data->master->dev, "%s:device_prep_slave_sg Failed\n",
 			__func__);
diff --git a/drivers/tty/serial/amba-pl011.c b/drivers/tty/serial/amba-pl011.c
index 6800f5f..1026f64 100644
--- a/drivers/tty/serial/amba-pl011.c
+++ b/drivers/tty/serial/amba-pl011.c
@@ -482,7 +482,8 @@ static int pl011_dma_tx_refill(struct uart_amba_port *uap)
 	}
 
 	desc = dma_dev->device_prep_slave_sg(chan, &dmatx->sg, 1, DMA_MEM_TO_DEV,
-					     DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
+					     DMA_PREP_INTERRUPT | DMA_CTRL_ACK,
+					     NULL);
 	if (!desc) {
 		dma_unmap_sg(dma_dev->dev, &dmatx->sg, 1, DMA_TO_DEVICE);
 		uap->dmatx.queued = false;
@@ -678,7 +679,8 @@ static int pl011_dma_rx_trigger_dma(struct uart_amba_port *uap)
 	dma_dev = rxchan->device;
 	desc = rxchan->device->device_prep_slave_sg(rxchan, &sgbuf->sg, 1,
 					DMA_DEV_TO_MEM,
-					DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
+					DMA_PREP_INTERRUPT | DMA_CTRL_ACK,
+					NULL);
 	/*
 	 * If the DMA engine is busy and cannot prepare a
 	 * channel, no big deal, the driver will fall back
diff --git a/drivers/tty/serial/pch_uart.c b/drivers/tty/serial/pch_uart.c
index 17ae657..7b59490 100644
--- a/drivers/tty/serial/pch_uart.c
+++ b/drivers/tty/serial/pch_uart.c
@@ -765,7 +765,7 @@ static int dma_handle_rx(struct eg20t_port *priv)
 
 	desc = priv->chan_rx->device->device_prep_slave_sg(priv->chan_rx,
 			sg, 1, DMA_DEV_TO_MEM,
-			DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
+			DMA_PREP_INTERRUPT | DMA_CTRL_ACK, NULL);
 
 	if (!desc)
 		return 0;
@@ -924,7 +924,8 @@ static unsigned int dma_handle_tx(struct eg20t_port *priv)
 
 	desc = priv->chan_tx->device->device_prep_slave_sg(priv->chan_tx,
 					priv->sg_tx_p, nent, DMA_MEM_TO_DEV,
-					DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
+					DMA_PREP_INTERRUPT | DMA_CTRL_ACK,
+					NULL);
 	if (!desc) {
 		dev_err(priv->port.dev, "%s:device_prep_slave_sg Failed\n",
 			__func__);
diff --git a/drivers/tty/serial/sh-sci.c b/drivers/tty/serial/sh-sci.c
index 7508579..dce0a9a 100644
--- a/drivers/tty/serial/sh-sci.c
+++ b/drivers/tty/serial/sh-sci.c
@@ -1339,7 +1339,7 @@ static void sci_submit_rx(struct sci_port *s)
 		struct dma_async_tx_descriptor *desc;
 
 		desc = chan->device->device_prep_slave_sg(chan,
-			sg, 1, DMA_DEV_TO_MEM, DMA_PREP_INTERRUPT);
+			sg, 1, DMA_DEV_TO_MEM, DMA_PREP_INTERRUPT, NULL);
 
 		if (desc) {
 			s->desc_rx[i] = desc;
@@ -1455,7 +1455,7 @@ static void work_fn_tx(struct work_struct *work)
 
 	desc = chan->device->device_prep_slave_sg(chan,
 			sg, s->sg_len_tx, DMA_MEM_TO_DEV,
-			DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
+			DMA_PREP_INTERRUPT | DMA_CTRL_ACK, NULL);
 	if (!desc) {
 		/* switch to PIO */
 		sci_tx_dma_release(s, true);
-- 
1.7.8.4

