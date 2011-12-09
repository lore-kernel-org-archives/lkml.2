Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753082Ab1LIEN4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 23:13:56 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:51544 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751426Ab1LIENz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 23:13:55 -0500
From: Tomoya MORINAGA <tomoya.rohm@gmail.com>
To: Grant Likely <grant.likely@secretlab.ca>,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Cc: qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, Wolfram Sang <w.sang@pengutronix.de>,
        Tomoya MORINAGA <tomoya.rohm@gmail.com>
Subject: [PATCH 2/4] spi-topcliff-pch: Fix issue for transmitting over 4KByte
Date: Fri,  9 Dec 2011 13:13:27 +0900
Message-Id: <1323404009-3476-1-git-send-email-tomoya.rohm@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, when spi-topcliff-pch receives transmit request over 4KByte,
this driver can't process correctly. This driver needs to divide the data
into 4Kbyte unit.
This patch fixes the issue.

Signed-off-by: Tomoya MORINAGA <tomoya.rohm@gmail.com>
---
 drivers/spi/spi-topcliff-pch.c |   66 +++++++++++++++++++++++++++++++++-------
 1 files changed, 55 insertions(+), 11 deletions(-)

diff --git a/drivers/spi/spi-topcliff-pch.c b/drivers/spi/spi-topcliff-pch.c
index fcd9462..7339765 100644
--- a/drivers/spi/spi-topcliff-pch.c
+++ b/drivers/spi/spi-topcliff-pch.c
@@ -194,6 +194,7 @@ struct pch_spi_data {
 	struct pch_spi_dma_ctrl dma;
 	int use_dma;
 	u8 irq_reg_sts;
+	int save_total_len;
 };
 
 /**
@@ -819,11 +820,13 @@ static void pch_spi_copy_rx_data_for_dma(struct pch_spi_data *data, int bpw)
 		rx_dma_buf = data->dma.rx_buf_virt;
 		for (j = 0; j < data->bpw_len; j++)
 			*rx_buf++ = *rx_dma_buf++ & 0xFF;
+		data->cur_trans->rx_buf = rx_buf;
 	} else {
 		rx_sbuf = data->cur_trans->rx_buf;
 		rx_dma_sbuf = data->dma.rx_buf_virt;
 		for (j = 0; j < data->bpw_len; j++)
 			*rx_sbuf++ = *rx_dma_sbuf++;
+		data->cur_trans->rx_buf = rx_sbuf;
 	}
 }
 
@@ -849,6 +852,9 @@ static int pch_spi_start_transfer(struct pch_spi_data *data)
 	rtn = wait_event_interruptible_timeout(data->wait,
 					       data->transfer_complete,
 					       msecs_to_jiffies(2 * HZ));
+	if (!rtn)
+		dev_err(&data->master->dev,
+			"%s wait-event timeout\n", __func__);
 
 	dma_sync_sg_for_cpu(&data->master->dev, dma->sg_rx_p, dma->nent,
 			    DMA_FROM_DEVICE);
@@ -985,6 +991,7 @@ static void pch_spi_handle_dma(struct pch_spi_data *data, int *bpw)
 	int i;
 	int size;
 	int rem;
+	int head;
 	unsigned long flags;
 	struct pch_spi_dma_ctrl *dma;
 
@@ -1013,6 +1020,11 @@ static void pch_spi_handle_dma(struct pch_spi_data *data, int *bpw)
 	}
 	data->bpw_len = data->cur_trans->len / (*bpw / 8);
 
+	if (data->bpw_len > PCH_BUF_SIZE) {
+		data->bpw_len = PCH_BUF_SIZE;
+		data->cur_trans->len -= PCH_BUF_SIZE;
+	}
+
 	/* copy Tx Data */
 	if (data->cur_trans->tx_buf != NULL) {
 		if (*bpw == 8) {
@@ -1027,10 +1039,17 @@ static void pch_spi_handle_dma(struct pch_spi_data *data, int *bpw)
 				*tx_dma_sbuf++ = *tx_sbuf++;
 		}
 	}
+
+	/* Calculate Rx parameter for DMA transmitting */
 	if (data->bpw_len > PCH_DMA_TRANS_SIZE) {
-		num = data->bpw_len / PCH_DMA_TRANS_SIZE + 1;
+		if (data->bpw_len % PCH_DMA_TRANS_SIZE) {
+			num = data->bpw_len / PCH_DMA_TRANS_SIZE + 1;
+			rem = data->bpw_len % PCH_DMA_TRANS_SIZE;
+		} else {
+			num = data->bpw_len / PCH_DMA_TRANS_SIZE;
+			rem = PCH_DMA_TRANS_SIZE;
+		}
 		size = PCH_DMA_TRANS_SIZE;
-		rem = data->bpw_len % PCH_DMA_TRANS_SIZE;
 	} else {
 		num = 1;
 		size = data->bpw_len;
@@ -1090,15 +1109,23 @@ static void pch_spi_handle_dma(struct pch_spi_data *data, int *bpw)
 	dma->nent = num;
 	dma->desc_rx = desc_rx;
 
-	/* TX */
-	if (data->bpw_len > PCH_DMA_TRANS_SIZE) {
-		num = data->bpw_len / PCH_DMA_TRANS_SIZE;
+	/* Calculate Tx parameter for DMA transmitting */
+	if (data->bpw_len > PCH_MAX_FIFO_DEPTH) {
+		head = PCH_MAX_FIFO_DEPTH - PCH_DMA_TRANS_SIZE;
+		if (data->bpw_len % PCH_DMA_TRANS_SIZE > 4) {
+			num = data->bpw_len / PCH_DMA_TRANS_SIZE + 1;
+			rem = data->bpw_len % PCH_DMA_TRANS_SIZE - head;
+		} else {
+			num = data->bpw_len / PCH_DMA_TRANS_SIZE;
+			rem = data->bpw_len % PCH_DMA_TRANS_SIZE +
+			      PCH_DMA_TRANS_SIZE - head;
+		}
 		size = PCH_DMA_TRANS_SIZE;
-		rem = 16;
 	} else {
 		num = 1;
 		size = data->bpw_len;
 		rem = data->bpw_len;
+		head = 0;
 	}
 
 	dma->sg_tx_p = kzalloc(sizeof(struct scatterlist)*num, GFP_ATOMIC);
@@ -1108,11 +1135,17 @@ static void pch_spi_handle_dma(struct pch_spi_data *data, int *bpw)
 	for (i = 0; i < num; i++, sg++) {
 		if (i == 0) {
 			sg->offset = 0;
+			sg_set_page(sg, virt_to_page(dma->tx_buf_virt), size + head,
+				    sg->offset);
+			sg_dma_len(sg) = size + head;
+		} else if (i == (num - 1)) {
+			sg->offset = head + size * i;
+			sg->offset = sg->offset * (*bpw / 8);
 			sg_set_page(sg, virt_to_page(dma->tx_buf_virt), rem,
 				    sg->offset);
 			sg_dma_len(sg) = rem;
 		} else {
-			sg->offset = rem + size * (i - 1);
+			sg->offset = head + size * i;
 			sg->offset = sg->offset * (*bpw / 8);
 			sg_set_page(sg, virt_to_page(dma->tx_buf_virt), size,
 				    sg->offset);
@@ -1200,6 +1233,7 @@ static void pch_spi_process_messages(struct work_struct *pwork)
 				    data->current_msg->spi->bits_per_word);
 	pch_spi_writereg(data->master, PCH_SSNXCR, SSN_NO_CONTROL);
 	do {
+		int cnt;
 		/* If we are already processing a message get the next
 		transfer structure from the message otherwise retrieve
 		the 1st transfer request from the message. */
@@ -1219,11 +1253,20 @@ static void pch_spi_process_messages(struct work_struct *pwork)
 		}
 		spin_unlock(&data->lock);
 
+		if (!data->cur_trans->len)
+			goto out;
+		cnt = (data->cur_trans->len - 1) / PCH_BUF_SIZE + 1;
+		data->save_total_len = data->cur_trans->len;
 		if (data->use_dma) {
-			pch_spi_handle_dma(data, &bpw);
-			if (!pch_spi_start_transfer(data))
-				goto out;
-			pch_spi_copy_rx_data_for_dma(data, bpw);
+			int i;
+			char *save_rx_buf = data->cur_trans->rx_buf;
+			for (i = 0; i < cnt; i ++) {
+				pch_spi_handle_dma(data, &bpw);
+				if (!pch_spi_start_transfer(data))
+					goto out;
+				pch_spi_copy_rx_data_for_dma(data, bpw);
+			}
+			data->cur_trans->rx_buf = save_rx_buf;
 		} else {
 			pch_spi_set_tx(data, &bpw);
 			pch_spi_set_ir(data);
@@ -1234,6 +1277,7 @@ static void pch_spi_process_messages(struct work_struct *pwork)
 			data->pkt_tx_buff = NULL;
 		}
 		/* increment message count */
+		data->cur_trans->len = data->save_total_len;
 		data->current_msg->actual_length += data->cur_trans->len;
 
 		dev_dbg(&data->master->dev,
-- 
1.7.4.4

