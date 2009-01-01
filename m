Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752547Ab1FGFOO (ORCPT <rfc822;list-kernel77@spinics.net>);
	Tue, 7 Jun 2011 01:14:14 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:8661 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750885Ab1FGFOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 01:14:09 -0400
From: y@vger.kernel.org
To: David Brownell <dbrownell@users.sourceforge.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Cc: qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, toshiharu-linux@dsn.okisemi.com,
        Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Subject: [PATCH/RESEND 2/2] spi_topcliff_pch: DMA support
Date: Fri,  2 Jan 2009 08:29:06 +0900
Message-Id: <1230852546-4561-2-git-send-email-y>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <y>
References: <y>
X-Hosting-Pf: 0
X-NAI-Spam-Score: 5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>

This patch enables this SPI driver works with DMA mode.

Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
---
 drivers/spi/spi_topcliff_pch.c |  612 ++++++++++++++++++++++++++++++++--------
 1 files changed, 492 insertions(+), 120 deletions(-)

diff --git a/drivers/spi/spi_topcliff_pch.c b/drivers/spi/spi_topcliff_pch.c
index 88bd472..f543ff6 100644
--- a/drivers/spi/spi_topcliff_pch.c
+++ b/drivers/spi/spi_topcliff_pch.c
@@ -28,6 +28,9 @@
 #include <linux/device.h>
 #include <linux/platform_device.h>
 
+#include <linux/dmaengine.h>
+#include <linux/pch_dma.h>
+
 /* Register offsets */
 #define PCH_SPCR		0x00	/* SPI control register */
 #define PCH_SPBRR		0x04	/* SPI baud rate register */
@@ -36,7 +39,7 @@
 #define PCH_SPDRR		0x10	/* SPI read data register */
 #define PCH_SSNXCR		0x18	/* SSN Expand Control Register */
 #define PCH_SRST		0x1C	/* SPI reset register */
-#define PCH_SPI_ADDRESS_SIZE	0x20
+#define PCH_ADDRESS_SIZE	0x20
 
 #define PCH_SPSR_TFD		0x000007C0
 #define PCH_SPSR_RFD		0x0000F800
@@ -54,8 +57,6 @@
 #define STATUS_EXITING		2
 #define PCH_SLEEP_TIME		10
 
-#define PCH_ADDRESS_SIZE	0x20
-
 #define SSN_LOW			0x02U
 #define SSN_NO_CONTROL		0x00U
 #define PCH_MAX_CS		0xFF
@@ -75,6 +76,7 @@
 #define SPSR_TFI_BIT		(1 << 0)
 #define SPSR_RFI_BIT		(1 << 1)
 #define SPSR_FI_BIT		(1 << 2)
+#define SPSR_ORF_BIT		(1 << 3)
 #define SPBRR_SIZE_BIT		(1 << 10)
 
 #define PCH_ALL			(SPCR_TFIE_BIT|SPCR_RFIE_BIT|SPCR_FIE_BIT|\
@@ -83,10 +85,9 @@
 #define SPCR_RFIC_FIELD		20
 #define SPCR_TFIC_FIELD		16
 
-#define SPSR_INT_BITS		0x1F
-#define MASK_SPBRR_SPBR_BITS	(~((1 << 10) - 1))
-#define MASK_RFIC_SPCR_BITS	(~(0xf << 20))
-#define MASK_TFIC_SPCR_BITS	(~(0xf000f << 12))
+#define MASK_SPBRR_SPBR_BITS	((1 << 10) - 1)
+#define MASK_RFIC_SPCR_BITS	(0xf << SPCR_RFIC_FIELD)
+#define MASK_TFIC_SPCR_BITS	(0xf << SPCR_TFIC_FIELD)
 
 #define PCH_CLOCK_HZ		50000000
 #define PCH_MAX_SPBR		1023
@@ -102,6 +103,28 @@
 */
 #define PCH_SPI_MAX_DEV			2
 
+#define PCH_BUF_SIZE		4096
+#define PCH_DMA_TRANS_SIZE	12
+
+static int use_dma = 1;
+
+struct pch_spi_dma_ctrl {
+	struct dma_async_tx_descriptor	*desc_tx;
+	struct dma_async_tx_descriptor	*desc_rx;
+	struct pch_dma_slave		param_tx;
+	struct pch_dma_slave		param_rx;
+	struct dma_chan		*chan_tx;
+	struct dma_chan		*chan_rx;
+	struct scatterlist		*sg_tx_p;
+	struct scatterlist		*sg_rx_p;
+	struct scatterlist		sg_tx;
+	struct scatterlist		sg_rx;
+	int				nent;
+	void				*tx_buf_virt;
+	void				*rx_buf_virt;
+	dma_addr_t			tx_buf_dma;
+	dma_addr_t			rx_buf_dma;
+};
 /**
  * struct pch_spi_data - Holds the SPI channel specific details
  * @io_remap_addr:		The remapped PCI base address
@@ -140,6 +163,7 @@
  */
 struct pch_spi_data {
 	void __iomem *io_remap_addr;
+	unsigned long io_base_addr;
 	struct spi_master *master;
 	struct work_struct work;
 	struct workqueue_struct *wk;
@@ -162,6 +186,8 @@ struct pch_spi_data {
 	struct pch_spi_board_data *board_dat;
 	struct platform_device	*plat_dev;
 	int ch;
+	struct pch_spi_dma_ctrl dma;
+	int use_dma;
 	u8 irq_reg_sts;
 };
 
@@ -273,10 +299,10 @@ static void pch_spi_handler_sub(struct pch_spi_data *data, u32 reg_spsr_val,
 			reg_spcr_val &= ~SPCR_RFIE_BIT; /* disable RFI */
 
 			/* reset rx threshold */
-			reg_spcr_val &= MASK_RFIC_SPCR_BITS;
+			reg_spcr_val &= ~MASK_RFIC_SPCR_BITS;
 			reg_spcr_val |= (PCH_RX_THOLD_MAX << SPCR_RFIC_FIELD);
-			iowrite32(((reg_spcr_val) &= (~(SPCR_RFIE_BIT))),
-				 (io_remap_addr + PCH_SPCR));
+
+			iowrite32(reg_spcr_val, (io_remap_addr + PCH_SPCR));
 		}
 
 		/* update counts */
@@ -287,12 +313,15 @@ static void pch_spi_handler_sub(struct pch_spi_data *data, u32 reg_spsr_val,
 
 	/* if transfer complete interrupt */
 	if (reg_spsr_val & SPSR_FI_BIT) {
-		/* disable FI & RFI interrupts */
-		pch_spi_setclr_reg(data->master, PCH_SPCR, 0,
-				   SPCR_FIE_BIT | SPCR_RFIE_BIT);
+		if (tx_index < bpw_len)
+			dev_err(&data->master->dev,
+				"%s : Transfer is not completed", __func__);
+		/* disable interrupts */
+		pch_spi_setclr_reg(data->master, PCH_SPCR, 0, PCH_ALL);
 
 		/* transfer is completed;inform pch_spi_process_messages */
 		data->transfer_complete = true;
+		data->transfer_active = false;
 		wake_up(&data->wait);
 	}
 }
@@ -316,11 +345,16 @@ static irqreturn_t pch_spi_handler(int irq, void *dev_id)
 			"%s returning due to suspend\n", __func__);
 		return IRQ_NONE;
 	}
+	if (data->use_dma)
+		return IRQ_NONE;
 
 	io_remap_addr = data->io_remap_addr;
 	spsr = io_remap_addr + PCH_SPSR;
 	reg_spsr_val = ioread32(spsr);
 
+	if (reg_spsr_val & SPSR_ORF_BIT)
+		dev_err(&board_dat->pdev->dev, "%s Over run error", __func__);
+
 	/* Check if the interrupt is for SPI device */
 	if (reg_spsr_val & (SPSR_FI_BIT | SPSR_RFI_BIT)) {
 		pch_spi_handler_sub(data, reg_spsr_val, io_remap_addr);
@@ -346,7 +380,7 @@ static void pch_spi_set_baud_rate(struct spi_master *master, u32 speed_hz)
 	if (n_spbr > PCH_MAX_SPBR)
 		n_spbr = PCH_MAX_SPBR;
 
-	pch_spi_setclr_reg(master, PCH_SPBRR, n_spbr, ~MASK_SPBRR_SPBR_BITS);
+	pch_spi_setclr_reg(master, PCH_SPBRR, n_spbr, MASK_SPBRR_SPBR_BITS);
 }
 
 /**
@@ -454,26 +488,27 @@ static int pch_spi_transfer(struct spi_device *pspi, struct spi_message *pmsg)
 	dev_dbg(&pspi->dev, "%s Transfer List not empty. "
 		"Transfer Speed is set.\n", __func__);
 
+	spin_lock_irqsave(&data->lock, flags);
 	/* validate Tx/Rx buffers and Transfer length */
 	list_for_each_entry(transfer, &pmsg->transfers, transfer_list) {
 		if (!transfer->tx_buf && !transfer->rx_buf) {
 			dev_err(&pspi->dev,
 				"%s Tx and Rx buffer NULL\n", __func__);
 			retval = -EINVAL;
-			goto err_out;
+			goto err_return_spinlock;
 		}
 
 		if (!transfer->len) {
 			dev_err(&pspi->dev, "%s Transfer length invalid\n",
 				__func__);
 			retval = -EINVAL;
-			goto err_out;
+			goto err_return_spinlock;
 		}
 
 		dev_dbg(&pspi->dev, "%s Tx/Rx buffer valid. Transfer length"
 			" valid\n", __func__);
 
-		/* if baud rate hs been specified validate the same */
+		/* if baud rate has been specified validate the same */
 		if (transfer->speed_hz > PCH_MAX_BAUDRATE)
 			transfer->speed_hz = PCH_MAX_BAUDRATE;
 
@@ -484,25 +519,24 @@ static int pch_spi_transfer(struct spi_device *pspi, struct spi_message *pmsg)
 				retval = -EINVAL;
 				dev_err(&pspi->dev,
 					"%s Invalid bits per word\n", __func__);
-				goto err_out;
+				goto err_return_spinlock;
 			}
 		}
 	}
-
-	spin_lock_irqsave(&data->lock, flags);
+	spin_unlock_irqrestore(&data->lock, flags);
 
 	/* We won't process any messages if we have been asked to terminate */
 	if (data->status == STATUS_EXITING) {
 		dev_err(&pspi->dev, "%s status = STATUS_EXITING.\n", __func__);
 		retval = -ESHUTDOWN;
-		goto err_return_spinlock;
+		goto err_out;
 	}
 
 	/* If suspended ,return -EINVAL */
 	if (data->board_dat->suspend_sts) {
 		dev_err(&pspi->dev, "%s suspend; returning EINVAL\n", __func__);
 		retval = -EINVAL;
-		goto err_return_spinlock;
+		goto err_out;
 	}
 
 	/* set status of message */
@@ -510,9 +544,11 @@ static int pch_spi_transfer(struct spi_device *pspi, struct spi_message *pmsg)
 	dev_dbg(&pspi->dev, "%s - pmsg->status =%d\n", __func__, pmsg->status);
 
 	pmsg->status = -EINPROGRESS;
-
+	spin_lock_irqsave(&data->lock, flags);
 	/* add message to queue */
 	list_add_tail(&pmsg->queue, &data->queue);
+	spin_unlock_irqrestore(&data->lock, flags);
+
 	dev_dbg(&pspi->dev, "%s - Invoked list_add_tail\n", __func__);
 
 	/* schedule work queue to run */
@@ -521,11 +557,13 @@ static int pch_spi_transfer(struct spi_device *pspi, struct spi_message *pmsg)
 
 	retval = 0;
 
-err_return_spinlock:
-	spin_unlock_irqrestore(&data->lock, flags);
 err_out:
 	dev_dbg(&pspi->dev, "%s RETURN=%d\n", __func__, retval);
 	return retval;
+err_return_spinlock:
+	dev_dbg(&pspi->dev, "%s RETURN=%d\n", __func__, retval);
+	spin_unlock_irqrestore(&data->lock, flags);
+	return retval;
 }
 
 static inline void pch_spi_select_chip(struct pch_spi_data *data,
@@ -546,8 +584,7 @@ static inline void pch_spi_select_chip(struct pch_spi_data *data,
 	pch_spi_setup_transfer(pspi);
 }
 
-static void pch_spi_set_tx(struct pch_spi_data *data, int *bpw,
-			   struct spi_message **ppmsg)
+static void pch_spi_set_tx(struct pch_spi_data *data, int *bpw)
 {
 	int size;
 	u32 n_writes;
@@ -556,8 +593,6 @@ static void pch_spi_set_tx(struct pch_spi_data *data, int *bpw,
 	const u8 *tx_buf;
 	const u16 *tx_sbuf;
 
-	pmsg = *ppmsg;
-
 	/* set baud rate if needed */
 	if (data->cur_trans->speed_hz) {
 		dev_dbg(&data->master->dev, "%s:setting baud rate\n", __func__);
@@ -566,8 +601,8 @@ static void pch_spi_set_tx(struct pch_spi_data *data, int *bpw,
 
 	/* set bits per word if needed */
 	if (data->cur_trans->bits_per_word &&
-	   (data->current_msg->spi->bits_per_word !=\
-	   data->cur_trans->bits_per_word)) {
+	    (data->current_msg->spi->bits_per_word !=\
+	     data->cur_trans->bits_per_word)) {
 		dev_dbg(&data->master->dev, "%s:set bits per word\n", __func__);
 		pch_spi_set_bits_per_word(data->master,
 					  data->cur_trans->bits_per_word);
@@ -641,9 +676,9 @@ static void pch_spi_set_tx(struct pch_spi_data *data, int *bpw,
 	data->transfer_active = true;
 }
 
-static void pch_spi_nomore_transfer(struct pch_spi_data *data,
-						struct spi_message *pmsg)
+static void pch_spi_nomore_transfer(struct pch_spi_data *data)
 {
+	struct spi_message *pmsg;
 	dev_dbg(&data->master->dev, "%s called\n", __func__);
 	/* Invoke complete callback
 	 * [To the spi core..indicating end of transfer] */
@@ -694,30 +729,21 @@ static void pch_spi_nomore_transfer(struct pch_spi_data *data,
 
 static void pch_spi_set_ir(struct pch_spi_data *data)
 {
-	/* enable interrupts */
-	if ((data->bpw_len) > PCH_MAX_FIFO_DEPTH) {
+	/* enable interrupts, set threshold, enable SPI */
+	if ((data->bpw_len) > PCH_MAX_FIFO_DEPTH)
 		/* set receive threshold to PCH_RX_THOLD */
 		pch_spi_setclr_reg(data->master, PCH_SPCR,
-				   PCH_RX_THOLD << SPCR_RFIC_FIELD,
-				   ~MASK_RFIC_SPCR_BITS);
-		/* enable FI and RFI interrupts */
-		pch_spi_setclr_reg(data->master, PCH_SPCR,
-				   SPCR_RFIE_BIT | SPCR_FIE_BIT, 0);
-	} else {
+				   PCH_RX_THOLD << SPCR_RFIC_FIELD |
+				   SPCR_FIE_BIT | SPCR_RFIE_BIT |
+				   SPCR_ORIE_BIT | SPCR_SPE_BIT,
+				   MASK_RFIC_SPCR_BITS | PCH_ALL);
+	else
 		/* set receive threshold to maximum */
 		pch_spi_setclr_reg(data->master, PCH_SPCR,
-				   PCH_RX_THOLD_MAX << SPCR_TFIC_FIELD,
-				   ~MASK_TFIC_SPCR_BITS);
-		/* enable FI interrupt */
-		pch_spi_setclr_reg(data->master, PCH_SPCR, SPCR_FIE_BIT, 0);
-	}
-
-	dev_dbg(&data->master->dev,
-		"%s:invoking pch_spi_set_enable to enable SPI\n", __func__);
-
-	/* SPI set enable */
-	pch_spi_setclr_reg(data->current_chip->master, PCH_SPCR, SPCR_SPE_BIT,
-			   0);
+				   PCH_RX_THOLD_MAX << SPCR_RFIC_FIELD |
+				   SPCR_FIE_BIT | SPCR_ORIE_BIT |
+				   SPCR_SPE_BIT,
+				   MASK_RFIC_SPCR_BITS | PCH_ALL);
 
 	/* Wait until the transfer completes; go to sleep after
 				 initiating the transfer. */
@@ -730,15 +756,13 @@ static void pch_spi_set_ir(struct pch_spi_data *data)
 	dev_dbg(&data->master->dev,
 		"%s:no more control over SSN-writing 0 to SSNXCR.", __func__);
 
-	data->transfer_active = false;
-	dev_dbg(&data->master->dev,
-		"%s set data->transfer_active = false\n", __func__);
-
 	/* clear all interrupts */
 	pch_spi_writereg(data->master, PCH_SPSR,
 			 pch_spi_readreg(data->master, PCH_SPSR));
-	/* disable interrupts */
-	pch_spi_setclr_reg(data->master, PCH_SPCR, 0, PCH_ALL);
+	/* Disable interrupts and SPI transfer */
+	pch_spi_setclr_reg(data->master, PCH_SPCR, 0, PCH_ALL | SPCR_SPE_BIT);
+	/* clear FIFO */
+	pch_spi_clear_fifo(data->master);
 }
 
 static void pch_spi_copy_rx_data(struct pch_spi_data *data, int bpw)
@@ -762,6 +786,328 @@ static void pch_spi_copy_rx_data(struct pch_spi_data *data, int bpw)
 	}
 }
 
+static void pch_spi_copy_rx_data_for_dma(struct pch_spi_data *data, int bpw)
+{
+	int j;
+	u8 *rx_buf;
+	u16 *rx_sbuf;
+	const u8 *rx_dma_buf;
+	const u16 *rx_dma_sbuf;
+
+	/* copy Rx Data */
+	if (!data->cur_trans->rx_buf)
+		return;
+
+	if (bpw == 8) {
+		rx_buf = data->cur_trans->rx_buf;
+		rx_dma_buf = data->dma.rx_buf_virt;
+		for (j = 0; j < data->bpw_len; j++)
+			*rx_buf++ = *rx_dma_buf++ & 0xFF;
+	} else {
+		rx_sbuf = data->cur_trans->rx_buf;
+		rx_dma_sbuf = data->dma.rx_buf_virt;
+		for (j = 0; j < data->bpw_len; j++)
+			*rx_sbuf++ = *rx_dma_sbuf++;
+	}
+}
+
+static void pch_spi_start_transfer(struct pch_spi_data *data)
+{
+	struct pch_spi_dma_ctrl *dma;
+	unsigned long flags;
+
+	dma = &data->dma;
+
+	spin_lock_irqsave(&data->lock, flags);
+
+	/* disable interrupts, SPI set enable */
+	pch_spi_setclr_reg(data->master, PCH_SPCR, SPCR_SPE_BIT, PCH_ALL);
+
+	spin_unlock_irqrestore(&data->lock, flags);
+
+	/* Wait until the transfer completes; go to sleep after
+				 initiating the transfer. */
+	dev_dbg(&data->master->dev,
+		"%s:waiting for transfer to get over\n", __func__);
+	wait_event_interruptible(data->wait, data->transfer_complete);
+
+	dma_sync_sg_for_cpu(&data->master->dev, dma->sg_rx_p, dma->nent,
+			    DMA_FROM_DEVICE);
+	async_tx_ack(dma->desc_rx);
+	async_tx_ack(dma->desc_tx);
+	kfree(dma->sg_tx_p);
+	kfree(dma->sg_rx_p);
+
+	spin_lock_irqsave(&data->lock, flags);
+	pch_spi_writereg(data->master, PCH_SSNXCR, SSN_NO_CONTROL);
+	dev_dbg(&data->master->dev,
+		"%s:no more control over SSN-writing 0 to SSNXCR.", __func__);
+
+	/* clear fifo threshold, disable interrupts, disable SPI transfer */
+	pch_spi_setclr_reg(data->master, PCH_SPCR, 0,
+			   MASK_RFIC_SPCR_BITS | MASK_TFIC_SPCR_BITS | PCH_ALL |
+			   SPCR_SPE_BIT);
+	/* clear all interrupts */
+	pch_spi_writereg(data->master, PCH_SPSR,
+			 pch_spi_readreg(data->master, PCH_SPSR));
+	/* clear FIFO */
+	pch_spi_clear_fifo(data->master);
+
+	spin_unlock_irqrestore(&data->lock, flags);
+}
+
+static void pch_dma_rx_complete(void *arg)
+{
+	struct pch_spi_data *data = arg;
+
+	/* transfer is completed;inform pch_spi_process_messages_dma */
+	data->transfer_complete = true;
+	wake_up_interruptible(&data->wait);
+}
+
+static bool pch_spi_filter(struct dma_chan *chan, void *slave)
+{
+	struct pch_dma_slave *param = slave;
+
+	if ((chan->chan_id == param->chan_id) &&
+	    (param->dma_dev == chan->device->dev)) {
+		chan->private = param;
+		return true;
+	} else {
+		return false;
+	}
+}
+
+static void pch_spi_request_dma(struct pch_spi_data *data, int bpw)
+{
+	dma_cap_mask_t mask;
+	struct dma_chan *chan;
+	struct pci_dev *dma_dev;
+	struct pch_dma_slave *param;
+	struct pch_spi_dma_ctrl *dma;
+	unsigned int width;
+
+	if (bpw == 8)
+		width = PCH_DMA_WIDTH_1_BYTE;
+	else
+		width = PCH_DMA_WIDTH_2_BYTES;
+
+	dma = &data->dma;
+	dma_cap_zero(mask);
+	dma_cap_set(DMA_SLAVE, mask);
+
+	/* Get DMA's dev information */
+	dma_dev = pci_get_bus_and_slot(2, PCI_DEVFN(12, 0));
+
+	/* Set Tx DMA */
+	param = &dma->param_tx;
+	param->dma_dev = &dma_dev->dev;
+	param->chan_id = data->master->bus_num * 2; /* Tx = 0, 2 */
+	param->tx_reg = data->io_base_addr + PCH_SPDWR;
+	param->width = width;
+	chan = dma_request_channel(mask, pch_spi_filter, param);
+	if (!chan) {
+		dev_err(&data->master->dev,
+			"ERROR: dma_request_channel FAILS(Tx)\n");
+		data->use_dma = 0;
+		return;
+	}
+	dma->chan_tx = chan;
+
+	/* Set Rx DMA */
+	param = &dma->param_rx;
+	param->dma_dev = &dma_dev->dev;
+	param->chan_id = data->master->bus_num * 2 + 1; /* Rx = Tx + 1 */
+	param->rx_reg = data->io_base_addr + PCH_SPDRR;
+	param->width = width;
+	chan = dma_request_channel(mask, pch_spi_filter, param);
+	if (!chan) {
+		dev_err(&data->master->dev,
+			"ERROR: dma_request_channel FAILS(Rx)\n");
+		dma_release_channel(dma->chan_tx);
+		dma->chan_tx = NULL;
+		data->use_dma = 0;
+		return;
+	}
+	dma->chan_rx = chan;
+}
+
+static void pch_spi_release_dma(struct pch_spi_data *data)
+{
+	struct pch_spi_dma_ctrl *dma;
+
+	dma = &data->dma;
+	if (dma->chan_tx) {
+		dma_release_channel(dma->chan_tx);
+		dma->chan_tx = NULL;
+	}
+	if (dma->chan_rx) {
+		dma_release_channel(dma->chan_rx);
+		dma->chan_rx = NULL;
+	}
+	return;
+}
+
+static void pch_spi_handle_dma(struct pch_spi_data *data, int *bpw)
+{
+	const u8 *tx_buf;
+	const u16 *tx_sbuf;
+	u8 *tx_dma_buf;
+	u16 *tx_dma_sbuf;
+	struct scatterlist *sg;
+	struct dma_async_tx_descriptor *desc_tx;
+	struct dma_async_tx_descriptor *desc_rx;
+	int num;
+	int i;
+	int size;
+	int rem;
+	unsigned long flags;
+	struct pch_spi_dma_ctrl *dma;
+
+	dma = &data->dma;
+
+	/* set baud rate if needed */
+	if (data->cur_trans->speed_hz) {
+		dev_dbg(&data->master->dev, "%s:setting baud rate\n", __func__);
+		spin_lock_irqsave(&data->lock, flags);
+		pch_spi_set_baud_rate(data->master, data->cur_trans->speed_hz);
+		spin_unlock_irqrestore(&data->lock, flags);
+	}
+
+	/* set bits per word if needed */
+	if (data->cur_trans->bits_per_word &&
+	    (data->current_msg->spi->bits_per_word !=
+	     data->cur_trans->bits_per_word)) {
+		dev_dbg(&data->master->dev, "%s:set bits per word\n", __func__);
+		spin_lock_irqsave(&data->lock, flags);
+		pch_spi_set_bits_per_word(data->master,
+					  data->cur_trans->bits_per_word);
+		spin_unlock_irqrestore(&data->lock, flags);
+		*bpw = data->cur_trans->bits_per_word;
+	} else {
+		*bpw = data->current_msg->spi->bits_per_word;
+	}
+	data->bpw_len = data->cur_trans->len / (*bpw / 8);
+
+	/* copy Tx Data */
+	if (data->cur_trans->tx_buf != NULL) {
+		if (*bpw == 8) {
+			tx_buf = data->cur_trans->tx_buf;
+			tx_dma_buf = dma->tx_buf_virt;
+			for (i = 0; i < data->bpw_len; i++)
+				*tx_dma_buf++ = *tx_buf++;
+		} else {
+			tx_sbuf = data->cur_trans->tx_buf;
+			tx_dma_sbuf = dma->tx_buf_virt;
+			for (i = 0; i < data->bpw_len; i++)
+				*tx_dma_sbuf++ = *tx_sbuf++;
+		}
+	}
+	if (data->bpw_len > PCH_DMA_TRANS_SIZE) {
+		num = data->bpw_len / PCH_DMA_TRANS_SIZE + 1;
+		size = PCH_DMA_TRANS_SIZE;
+		rem = data->bpw_len % PCH_DMA_TRANS_SIZE;
+	} else {
+		num = 1;
+		size = data->bpw_len;
+		rem = data->bpw_len;
+	}
+	dev_dbg(&data->master->dev, "%s num=%d size=%d rem=%d\n",
+		__func__, num, size, rem);
+	spin_lock_irqsave(&data->lock, flags);
+
+	/* set receive fifo threshold and transmit fifo threshold */
+	pch_spi_setclr_reg(data->master, PCH_SPCR,
+			   ((size - 1) << SPCR_RFIC_FIELD) |
+			   ((PCH_MAX_FIFO_DEPTH - PCH_DMA_TRANS_SIZE) <<
+			    SPCR_TFIC_FIELD),
+			   MASK_RFIC_SPCR_BITS | MASK_TFIC_SPCR_BITS);
+
+	spin_unlock_irqrestore(&data->lock, flags);
+
+	/* RX */
+	dma->sg_rx_p = kzalloc(sizeof(struct scatterlist)*num, GFP_ATOMIC);
+	sg_init_table(dma->sg_rx_p, num); /* Initialize SG table */
+	/* offset, length setting */
+	sg = dma->sg_rx_p;
+	for (i = 0; i < num; i++, sg++) {
+		if (i == 0) {
+			sg->offset = 0;
+			sg_set_page(sg, virt_to_page(dma->rx_buf_virt), rem,
+				    sg->offset);
+			sg_dma_len(sg) = rem;
+		} else {
+			sg->offset = rem + size * (i - 1);
+			sg->offset = sg->offset * (*bpw / 8);
+			sg_set_page(sg, virt_to_page(dma->rx_buf_virt), size,
+				    sg->offset);
+			sg_dma_len(sg) = size;
+		}
+		sg_dma_address(sg) = dma->rx_buf_dma + sg->offset;
+	}
+	sg = dma->sg_rx_p;
+	desc_rx = dma->chan_rx->device->device_prep_slave_sg(dma->chan_rx, sg,
+					num, DMA_FROM_DEVICE,
+					DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
+	if (!desc_rx) {
+		dev_err(&data->master->dev, "%s:device_prep_slave_sg Failed\n",
+			__func__);
+		return;
+	}
+	dma_sync_sg_for_device(&data->master->dev, sg, num, DMA_FROM_DEVICE);
+	desc_rx->callback = pch_dma_rx_complete;
+	desc_rx->callback_param = data;
+	dma->nent = num;
+	dma->desc_rx = desc_rx;
+
+	/* TX */
+	dma->sg_tx_p = kzalloc(sizeof(struct scatterlist)*num, GFP_ATOMIC);
+	sg_init_table(dma->sg_tx_p, num); /* Initialize SG table */
+	/* offset, length setting */
+	sg = dma->sg_tx_p;
+	for (i = 0; i < num; i++, sg++) {
+		if (i == 0) {
+			sg->offset = 0;
+			sg_set_page(sg, virt_to_page(dma->tx_buf_virt), rem,
+				    sg->offset);
+			sg_dma_len(sg) = rem;
+		} else {
+			sg->offset = rem + size * (i - 1);
+			sg->offset = sg->offset * (*bpw / 8);
+			sg_set_page(sg, virt_to_page(dma->tx_buf_virt), size,
+				    sg->offset);
+			sg_dma_len(sg) = size;
+		}
+		sg_dma_address(sg) = dma->tx_buf_dma + sg->offset;
+	}
+	sg = dma->sg_tx_p;
+	desc_tx = dma->chan_tx->device->device_prep_slave_sg(dma->chan_tx,
+					sg, num, DMA_TO_DEVICE,
+					DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
+	if (!desc_tx) {
+		dev_err(&data->master->dev, "%s:device_prep_slave_sg Failed\n",
+			__func__);
+		return;
+	}
+	dma_sync_sg_for_device(&data->master->dev, sg, num, DMA_TO_DEVICE);
+	desc_tx->callback = NULL;
+	desc_tx->callback_param = data;
+	dma->nent = num;
+	dma->desc_tx = desc_tx;
+
+	dev_dbg(&data->master->dev, "\n%s:Pulling down SSN low - writing "
+		"0x2 to SSNXCR\n", __func__);
+
+	spin_lock_irqsave(&data->lock, flags);
+	pch_spi_writereg(data->master, PCH_SSNXCR, SSN_LOW);
+	desc_rx->tx_submit(desc_rx);
+	desc_tx->tx_submit(desc_tx);
+	spin_unlock_irqrestore(&data->lock, flags);
+
+	/* reset transfer complete flag */
+	data->transfer_complete = false;
+}
+
 static void pch_spi_process_messages(struct work_struct *pwork)
 {
 	struct spi_message *pmsg;
@@ -772,30 +1118,23 @@ static void pch_spi_process_messages(struct work_struct *pwork)
 	dev_dbg(&data->master->dev, "%s data initialized\n", __func__);
 
 	spin_lock(&data->lock);
-
 	/* check if suspend has been initiated;if yes flush queue */
 	if (data->board_dat->suspend_sts || (data->status == STATUS_EXITING)) {
-		dev_dbg(&data->master->dev,
-			"%s suspend/remove initiated,flushing queue\n",
-			__func__);
-
+		dev_dbg(&data->master->dev, "%s suspend/remove initiated,"
+			"flushing queue\n", __func__);
 		list_for_each_entry(pmsg, data->queue.next, queue) {
 			pmsg->status = -EIO;
-
 			if (pmsg->complete != 0) {
 				spin_unlock(&data->lock);
 				pmsg->complete(pmsg->context);
 				spin_lock(&data->lock);
 			}
-
 			/* delete from queue */
 			list_del_init(&pmsg->queue);
 		}
-
 		spin_unlock(&data->lock);
 		return;
 	}
-
 	data->bcurrent_msg_processing = true;
 	dev_dbg(&data->master->dev,
 		"%s Set data->bcurrent_msg_processing= true\n", __func__);
@@ -803,62 +1142,47 @@ static void pch_spi_process_messages(struct work_struct *pwork)
 	/* Get the message from the queue and delete it from there. */
 	data->current_msg = list_entry(data->queue.next, struct spi_message,
 					queue);
-
 	list_del_init(&data->current_msg->queue);
-
 	data->current_msg->status = 0;
-
 	pch_spi_select_chip(data, data->current_msg->spi);
-
 	spin_unlock(&data->lock);
 
+	if (data->use_dma)
+		pch_spi_request_dma(data,
+				    data->current_msg->spi->bits_per_word);
 	do {
 		/* If we are already processing a message get the next
 		transfer structure from the message otherwise retrieve
 		the 1st transfer request from the message. */
 		spin_lock(&data->lock);
-
 		if (data->cur_trans == NULL) {
 			data->cur_trans =
-			    list_entry(data->current_msg->transfers.
-				       next, struct spi_transfer,
-				       transfer_list);
-			dev_dbg(&data->master->dev,
-				"%s :Getting 1st transfer message\n", __func__);
+				list_entry(data->current_msg->transfers.next,
+					   struct spi_transfer, transfer_list);
+			dev_dbg(&data->master->dev, "%s "
+				":Getting 1st transfer message\n", __func__);
 		} else {
 			data->cur_trans =
-			    list_entry(data->cur_trans->transfer_list.next,
-				       struct spi_transfer,
-				       transfer_list);
-			dev_dbg(&data->master->dev,
-				"%s :Getting next transfer message\n",
-				__func__);
+				list_entry(data->cur_trans->transfer_list.next,
+					   struct spi_transfer, transfer_list);
+			dev_dbg(&data->master->dev, "%s "
+				":Getting next transfer message\n", __func__);
 		}
-
 		spin_unlock(&data->lock);
 
-		pch_spi_set_tx(data, &bpw, &pmsg);
-
-		/* Control interrupt*/
-		pch_spi_set_ir(data);
-
-		/* Disable SPI transfer */
-		pch_spi_setclr_reg(data->current_chip->master, PCH_SPCR, 0,
-				   SPCR_SPE_BIT);
-
-		/* clear FIFO */
-		pch_spi_clear_fifo(data->master);
-
-		/* copy Rx Data */
-		pch_spi_copy_rx_data(data, bpw);
-
-		/* free memory */
-		kfree(data->pkt_rx_buff);
-		data->pkt_rx_buff = NULL;
-
-		kfree(data->pkt_tx_buff);
-		data->pkt_tx_buff = NULL;
-
+		if (data->use_dma) {
+			pch_spi_handle_dma(data, &bpw);
+			pch_spi_start_transfer(data);
+			pch_spi_copy_rx_data_for_dma(data, bpw);
+		} else {
+			pch_spi_set_tx(data, &bpw);
+			pch_spi_set_ir(data);
+			pch_spi_copy_rx_data(data, bpw);
+			kfree(data->pkt_rx_buff);
+			data->pkt_rx_buff = NULL;
+			kfree(data->pkt_tx_buff);
+			data->pkt_tx_buff = NULL;
+		}
 		/* increment message count */
 		data->current_msg->actual_length += data->cur_trans->len;
 
@@ -875,16 +1199,17 @@ static void pch_spi_process_messages(struct work_struct *pwork)
 		}
 
 		spin_lock(&data->lock);
-
 		/* No more transfer in this message. */
 		if ((data->cur_trans->transfer_list.next) ==
 		    &(data->current_msg->transfers)) {
-			pch_spi_nomore_transfer(data, pmsg);
+			pch_spi_nomore_transfer(data);
 		}
-
 		spin_unlock(&data->lock);
 
 	} while (data->cur_trans != NULL);
+
+	if (data->use_dma)
+		pch_spi_release_dma(data);
 }
 
 static void pch_spi_free_resources(struct pch_spi_board_data *board_dat,
@@ -911,6 +1236,7 @@ static int pch_spi_get_resources(struct pch_spi_board_data *board_dat,
 
 	/* create workqueue */
 	data->wk = create_singlethread_workqueue(KBUILD_MODNAME);
+
 	if (!data->wk) {
 		dev_err(&board_dat->pdev->dev,
 			"%s create_singlet hread_workqueue failed\n", __func__);
@@ -937,6 +1263,35 @@ err_return:
 	return retval;
 }
 
+static void pch_free_dma_buf(struct pch_spi_board_data *board_dat,
+			     struct pch_spi_data *data)
+{
+	struct pch_spi_dma_ctrl *dma;
+
+	dma = &data->dma;
+	if (dma->tx_buf_dma)
+		dma_free_coherent(&board_dat->pdev->dev, PCH_BUF_SIZE,
+				  dma->tx_buf_virt, dma->tx_buf_dma);
+	if (dma->rx_buf_dma)
+		dma_free_coherent(&board_dat->pdev->dev, PCH_BUF_SIZE,
+				  dma->rx_buf_virt, dma->rx_buf_dma);
+	return;
+}
+
+static void pch_alloc_dma_buf(struct pch_spi_board_data *board_dat,
+			      struct pch_spi_data *data)
+{
+	struct pch_spi_dma_ctrl *dma;
+
+	dma = &data->dma;
+	/* Get Consistent memory for Tx DMA */
+	dma->tx_buf_virt = dma_alloc_coherent(&board_dat->pdev->dev,
+				PCH_BUF_SIZE, &dma->tx_buf_dma, GFP_KERNEL);
+	/* Get Consistent memory for Rx DMA */
+	dma->rx_buf_virt = dma_alloc_coherent(&board_dat->pdev->dev,
+				PCH_BUF_SIZE, &dma->rx_buf_dma, GFP_KERNEL);
+}
+
 static int __devinit pch_spi_pd_probe(struct platform_device *plat_dev)
 {
 	int ret;
@@ -944,6 +1299,8 @@ static int __devinit pch_spi_pd_probe(struct platform_device *plat_dev)
 	struct pch_spi_board_data *board_dat = dev_get_platdata(&plat_dev->dev);
 	struct pch_spi_data *data;
 
+	dev_dbg(&plat_dev->dev, "%s:debug\n", __func__);
+
 	master = spi_alloc_master(&board_dat->pdev->dev,
 				  sizeof(struct pch_spi_data));
 	if (!master) {
@@ -957,9 +1314,11 @@ static int __devinit pch_spi_pd_probe(struct platform_device *plat_dev)
 
 	platform_set_drvdata(plat_dev, data);
 
-	/* baseaddress + 0x20(offset) */
+	/* baseaddress + address offset) */
+	data->io_base_addr = pci_resource_start(board_dat->pdev, 1) +
+					 PCH_ADDRESS_SIZE * plat_dev->id;
 	data->io_remap_addr = pci_iomap(board_dat->pdev, 1, 0) +
-						   0x20 * plat_dev->id;
+					 PCH_ADDRESS_SIZE * plat_dev->id;
 	if (!data->io_remap_addr) {
 		dev_err(&plat_dev->dev, "%s pci_iomap failed\n", __func__);
 		ret = -ENOMEM;
@@ -980,6 +1339,7 @@ static int __devinit pch_spi_pd_probe(struct platform_device *plat_dev)
 	data->n_curnt_chip = 255;
 	data->status = STATUS_RUNNING;
 	data->ch = plat_dev->id;
+	data->use_dma = use_dma;
 
 	INIT_LIST_HEAD(&data->queue);
 	spin_lock_init(&data->lock);
@@ -1010,6 +1370,11 @@ static int __devinit pch_spi_pd_probe(struct platform_device *plat_dev)
 		goto err_spi_register_master;
 	}
 
+	if (use_dma) {
+		dev_info(&plat_dev->dev, "Use DMA for data transfers\n");
+		pch_alloc_dma_buf(board_dat, data);
+	}
+
 	return 0;
 
 err_spi_register_master:
@@ -1029,22 +1394,27 @@ static int __devexit pch_spi_pd_remove(struct platform_device *plat_dev)
 	struct pch_spi_board_data *board_dat = dev_get_platdata(&plat_dev->dev);
 	struct pch_spi_data *data = platform_get_drvdata(plat_dev);
 	int count;
+	unsigned long flags;
 
 	dev_dbg(&plat_dev->dev, "%s:[ch%d] irq=%d\n",
 		__func__, plat_dev->id, board_dat->pdev->irq);
+
+	if (use_dma)
+		pch_free_dma_buf(board_dat, data);
+
 	/* check for any pending messages; no action is taken if the queue
 	 * is still full; but at least we tried.  Unload anyway */
 	count = 500;
-	spin_lock(&data->lock);
+	spin_lock_irqsave(&data->lock, flags);
 	data->status = STATUS_EXITING;
 	while ((list_empty(&data->queue) == 0) && --count) {
 		dev_dbg(&board_dat->pdev->dev, "%s :queue not empty\n",
 			__func__);
-		spin_unlock(&data->lock);
+		spin_unlock_irqrestore(&data->lock, flags);
 		msleep(PCH_SLEEP_TIME);
-		spin_lock(&data->lock);
+		spin_lock_irqsave(&data->lock, flags);
 	}
-	spin_unlock(&data->lock);
+	spin_unlock_irqrestore(&data->lock, flags);
 
 	pch_spi_free_resources(board_dat, data);
 	/* disable interrupts & free IRQ */
@@ -1081,8 +1451,8 @@ static int pch_spi_pd_suspend(struct platform_device *pd_dev,
 	/* check if the current message is processed:
 	   Only after thats done the transfer will be suspended */
 	count = 255;
-	while ((--count) > 0)
-		if (!(data->bcurrent_msg_processing)) {
+	while ((--count) > 0) {
+		if (!(data->bcurrent_msg_processing))
 			break;
 		msleep(PCH_SLEEP_TIME);
 	}
@@ -1123,7 +1493,6 @@ static int pch_spi_pd_resume(struct platform_device *pd_dev)
 				"%s request_irq failed\n", __func__);
 			return retval;
 		}
-
 		/* reset PCH SPI h/w */
 		pch_spi_reset(data->master);
 		pch_spi_set_master_mode(data->master);
@@ -1213,7 +1582,6 @@ static int __devinit pch_spi_probe(struct pci_dev *pdev,
 	}
 
 	pci_set_drvdata(pdev, pd_dev_save);
-
 	return 0;
 
 err_platform_device:
@@ -1326,5 +1694,9 @@ static void __exit pch_spi_exit(void)
 }
 module_exit(pch_spi_exit);
 
+module_param(use_dma, int, 0644);
+MODULE_PARM_DESC(use_dma,
+		 "to use DMA for data transfers pass 1 else 0; default 1");
+
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Intel EG20T PCH/OKI SEMICONDUCTOR ML7213 IOH SPI Driver");
-- 
1.7.4

