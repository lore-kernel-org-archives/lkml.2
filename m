Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753893Ab1IFISs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 04:18:48 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:38824 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753294Ab1IFISH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 04:18:07 -0400
From: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
To: Grant Likely <grant.likely@secretlab.ca>,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Cc: qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, toshiharu-linux@dsn.okisemi.com,
        Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Subject: [PATCH 4/5 v2] spi-topcliff-pch: Add recovery processing in case FIFO overrun error occurs
Date: Tue,  6 Sep 2011 17:16:37 +0900
Message-Id: <1315296998-7296-4-git-send-email-tomoya-linux@dsn.okisemi.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1315296998-7296-1-git-send-email-tomoya-linux@dsn.okisemi.com>
References: <1315296998-7296-1-git-send-email-tomoya-linux@dsn.okisemi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add recovery processing in case FIFO overrun error occurs with DMA transfer mode.

Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
---
v2: v1 patch series are included invalid patch file
---
 drivers/spi/spi-topcliff-pch.c |   31 ++++++++++++++++++++++++-------
 1 files changed, 24 insertions(+), 7 deletions(-)

diff --git a/drivers/spi/spi-topcliff-pch.c b/drivers/spi/spi-topcliff-pch.c
index 6cb2fdb..c8efa75 100644
--- a/drivers/spi/spi-topcliff-pch.c
+++ b/drivers/spi/spi-topcliff-pch.c
@@ -352,16 +352,26 @@ static irqreturn_t pch_spi_handler(int irq, void *dev_id)
 			"%s returning due to suspend\n", __func__);
 		return IRQ_NONE;
 	}
-	if (data->use_dma)
-		return IRQ_NONE;
 
 	io_remap_addr = data->io_remap_addr;
 	spsr = io_remap_addr + PCH_SPSR;
 
 	reg_spsr_val = ioread32(spsr);
 
-	if (reg_spsr_val & SPSR_ORF_BIT)
-		dev_err(&board_dat->pdev->dev, "%s Over run error", __func__);
+	if (reg_spsr_val & SPSR_ORF_BIT) {
+		dev_err(&board_dat->pdev->dev, "%s Over run error\n", __func__);
+		if (data->current_msg->complete != 0) {
+			data->transfer_complete = true;
+			data->current_msg->status = -EIO;
+			data->current_msg->complete(data->current_msg->context);
+			data->bcurrent_msg_processing = false;
+			data->current_msg = NULL;
+			data->cur_trans = NULL;
+		}
+	}
+
+	if (data->use_dma)
+		return IRQ_NONE;
 
 	/* Check if the interrupt is for SPI device */
 	if (reg_spsr_val & (SPSR_FI_BIT | SPSR_RFI_BIT)) {
@@ -815,10 +825,11 @@ static void pch_spi_copy_rx_data_for_dma(struct pch_spi_data *data, int bpw)
 	}
 }
 
-static void pch_spi_start_transfer(struct pch_spi_data *data)
+static int pch_spi_start_transfer(struct pch_spi_data *data)
 {
 	struct pch_spi_dma_ctrl *dma;
 	unsigned long flags;
+	int rtn;
 
 	dma = &data->dma;
 
@@ -833,7 +844,9 @@ static void pch_spi_start_transfer(struct pch_spi_data *data)
 				 initiating the transfer. */
 	dev_dbg(&data->master->dev,
 		"%s:waiting for transfer to get over\n", __func__);
-	wait_event_interruptible(data->wait, data->transfer_complete);
+	rtn = wait_event_interruptible_timeout(data->wait,
+					       data->transfer_complete,
+					       msecs_to_jiffies(2 * HZ));
 
 	dma_sync_sg_for_cpu(&data->master->dev, dma->sg_rx_p, dma->nent,
 			    DMA_FROM_DEVICE);
@@ -860,6 +873,8 @@ static void pch_spi_start_transfer(struct pch_spi_data *data)
 	pch_spi_clear_fifo(data->master);
 
 	spin_unlock_irqrestore(&data->lock, flags);
+
+	return rtn;
 }
 
 static void pch_dma_rx_complete(void *arg)
@@ -1187,7 +1202,8 @@ static void pch_spi_process_messages(struct work_struct *pwork)
 
 		if (data->use_dma) {
 			pch_spi_handle_dma(data, &bpw);
-			pch_spi_start_transfer(data);
+			if (!pch_spi_start_transfer(data))
+				goto out;
 			pch_spi_copy_rx_data_for_dma(data, bpw);
 		} else {
 			pch_spi_set_tx(data, &bpw);
@@ -1225,6 +1241,7 @@ static void pch_spi_process_messages(struct work_struct *pwork)
 
 	} while (data->cur_trans != NULL);
 
+out:
 	pch_spi_writereg(data->master, PCH_SSNXCR, SSN_HIGH);
 	if (data->use_dma)
 		pch_spi_release_dma(data);
-- 
1.7.4.4

