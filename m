Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755703Ab1ALSUh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 13:20:37 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:50519 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755631Ab1ALSUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 13:20:32 -0500
From: Per Forlin <per.forlin@linaro.org>
To: linux-mmc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org
Cc: Chris Ball <cjb@laptop.org>, Ulf Hansson <ulf.hansson@stericsson.com>
Subject: [FYI 3/4] MMCI: Corrections for DMA
Date: Wed, 12 Jan 2011 19:19:42 +0100
Message-Id: <1294856383-14187-4-git-send-email-per.forlin@linaro.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1294856383-14187-1-git-send-email-per.forlin@linaro.org>
References: <1294856383-14187-1-git-send-email-per.forlin@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ulf Hansson <ulf.hansson@stericsson.com>

NOT to be mainlined, only sets the base for the double
buffer example implementation. The DMA implemenation for
MMCI is under development.

Make use of DMA_PREP_INTERRUPT to get a callback when DMA has
successfully completed the data transfer.

To entirely ending the transfer and request, both the DMA
callback and MCI_DATAEND must occur.
---
 drivers/mmc/host/mmci.c |  173 +++++++++++++++++++++++++++++++----------------
 1 files changed, 114 insertions(+), 59 deletions(-)

diff --git a/drivers/mmc/host/mmci.c b/drivers/mmc/host/mmci.c
index 38fcbde..ab44f5f 100644
--- a/drivers/mmc/host/mmci.c
+++ b/drivers/mmc/host/mmci.c
@@ -203,6 +203,34 @@ static void mmci_init_sg(struct mmci_host *host, struct mmc_data *data)
 	sg_miter_start(&host->sg_miter, data->sg, data->sg_len, flags);
 }
 
+static void
+mmci_start_command(struct mmci_host *host, struct mmc_command *cmd, u32 c)
+{
+	void __iomem *base = host->base;
+
+	dev_dbg(mmc_dev(host->mmc), "op %02x arg %08x flags %08x\n",
+	    cmd->opcode, cmd->arg, cmd->flags);
+
+	if (readl(base + MMCICOMMAND) & MCI_CPSM_ENABLE) {
+		writel(0, base + MMCICOMMAND);
+		udelay(1);
+	}
+
+	c |= cmd->opcode | MCI_CPSM_ENABLE;
+	if (cmd->flags & MMC_RSP_PRESENT) {
+		if (cmd->flags & MMC_RSP_136)
+			c |= MCI_CPSM_LONGRSP;
+		c |= MCI_CPSM_RESPONSE;
+	}
+	if (/*interrupt*/0)
+		c |= MCI_CPSM_INTERRUPT;
+
+	host->cmd = cmd;
+
+	writel(cmd->arg, base + MMCIARGUMENT);
+	writel(c, base + MMCICOMMAND);
+}
+
 /*
  * All the DMA operation mode stuff goes inside this ifdef.
  * This assumes that you have a generic DMA device interface,
@@ -290,6 +318,39 @@ static void mmci_dma_terminate(struct mmci_host *host)
 		     (data->flags & MMC_DATA_WRITE)
 		     ? DMA_TO_DEVICE : DMA_FROM_DEVICE);
 	chan->device->device_control(chan, DMA_TERMINATE_ALL, 0);
+	host->dma_on_current_xfer = false;
+}
+
+static void mmci_dma_callback(void *arg)
+{
+	unsigned long flags;
+	struct mmci_host *host = arg;
+	struct mmc_data *data;
+
+	dev_vdbg(mmc_dev(host->mmc), "DMA transfer done!\n");
+
+	spin_lock_irqsave(&host->lock, flags);
+
+	mmci_dma_data_end(host);
+
+	/*
+	 * Make sure MMCI has received MCI_DATAEND before
+	 * ending the transfer and request.
+	 */
+	if (host->dataend) {
+		data = host->data;
+		mmci_stop_data(host);
+
+		host->data_xfered += data->blksz * data->blocks;
+		host->dataend = false;
+
+		if (!data->stop)
+			mmci_request_end(host, data->mrq);
+		else
+			mmci_start_command(host, data->stop, 0);
+	}
+
+	spin_unlock_irqrestore(&host->lock, flags);
 }
 
 static int mmci_dma_start_data(struct mmci_host *host, unsigned int datactrl)
@@ -314,6 +375,8 @@ static int mmci_dma_start_data(struct mmci_host *host, unsigned int datactrl)
 	struct scatterlist *sg;
 	dma_cookie_t cookie;
 	int i;
+	unsigned int irqmask0;
+	int sg_len;
 
 	datactrl |= MCI_DPSM_DMAENABLE;
 	datactrl |= variant->dmareg_enable;
@@ -344,15 +407,19 @@ static int mmci_dma_start_data(struct mmci_host *host, unsigned int datactrl)
 			return -EINVAL;
 	}
 
-	dma_map_sg(mmc_dev(host->mmc), data->sg,
-		   data->sg_len, direction);
+	sg_len = dma_map_sg(mmc_dev(host->mmc), data->sg,
+				data->sg_len, direction);
+	if (!sg_len)
+		goto map_err;
 
 	desc = chan->device->device_prep_slave_sg(chan,
-					data->sg, data->sg_len, direction,
-					DMA_CTRL_ACK);
+					data->sg, sg_len, direction,
+					DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
 	if (!desc)
 		goto unmap_exit;
 
+	desc->callback = mmci_dma_callback;
+	desc->callback_param = host;
 	host->dma_desc = desc;
 	dev_vdbg(mmc_dev(host->mmc), "Submit MMCI DMA job, sglen %d "
 		 "blksz %04x blks %04x flags %08x\n",
@@ -366,20 +433,25 @@ static int mmci_dma_start_data(struct mmci_host *host, unsigned int datactrl)
 	host->dma_on_current_xfer = true;
 	chan->device->device_issue_pending(chan);
 
-	/* Trigger the DMA transfer */
-	writel(datactrl, host->base + MMCIDATACTRL);
 	/*
-	 * Let the MMCI say when the data is ended and it's time
-	 * to fire next DMA request. When that happens, MMCI will
-	 * call mmci_data_end()
+	 * MMCI monitors both MCI_DATAEND and the DMA callback.
+	 * Both events must occur before the transfer is considered
+	 * to be completed. MCI_DATABLOCKEND is not used in DMA mode.
 	 */
-	writel(readl(host->base + MMCIMASK0) | MCI_DATAENDMASK,
-	       host->base + MMCIMASK0);
+	host->last_blockend = true;
+	irqmask0 = readl(host->base + MMCIMASK0);
+	irqmask0 |= MCI_DATAENDMASK;
+	irqmask0 &= ~MCI_DATABLOCKENDMASK;
+	writel(irqmask0, host->base + MMCIMASK0);
+
+	/* Trigger the DMA transfer */
+	writel(datactrl, host->base + MMCIDATACTRL);
 	return 0;
 
 unmap_exit:
-	chan->device->device_control(chan, DMA_TERMINATE_ALL, 0);
 	dma_unmap_sg(mmc_dev(host->mmc), data->sg, data->sg_len, direction);
+map_err:
+	chan->device->device_control(chan, DMA_TERMINATE_ALL, 0);
 	return -ENOMEM;
 }
 #else
@@ -478,43 +550,20 @@ static void mmci_start_data(struct mmci_host *host, struct mmc_data *data)
 		if (mmc_card_sdio(host->mmc->card))
 			datactrl |= MCI_ST_DPSM_SDIOEN;
 
-	writel(datactrl, base + MMCIDATACTRL);
+	/* Setup IRQ */
 	irqmask0 = readl(base + MMCIMASK0);
-	if (variant->broken_blockend)
+	if (variant->broken_blockend) {
+		host->last_blockend = true;
 		irqmask0 &= ~MCI_DATABLOCKENDMASK;
-	else
+	} else {
 		irqmask0 |= MCI_DATABLOCKENDMASK;
+	}
 	irqmask0 &= ~MCI_DATAENDMASK;
 	writel(irqmask0, base + MMCIMASK0);
 	mmci_set_mask1(host, irqmask1);
-}
-
-static void
-mmci_start_command(struct mmci_host *host, struct mmc_command *cmd, u32 c)
-{
-	void __iomem *base = host->base;
-
-	dev_dbg(mmc_dev(host->mmc), "op %02x arg %08x flags %08x\n",
-	    cmd->opcode, cmd->arg, cmd->flags);
-
-	if (readl(base + MMCICOMMAND) & MCI_CPSM_ENABLE) {
-		writel(0, base + MMCICOMMAND);
-		udelay(1);
-	}
 
-	c |= cmd->opcode | MCI_CPSM_ENABLE;
-	if (cmd->flags & MMC_RSP_PRESENT) {
-		if (cmd->flags & MMC_RSP_136)
-			c |= MCI_CPSM_LONGRSP;
-		c |= MCI_CPSM_RESPONSE;
-	}
-	if (/*interrupt*/0)
-		c |= MCI_CPSM_INTERRUPT;
-
-	host->cmd = cmd;
-
-	writel(cmd->arg, base + MMCIARGUMENT);
-	writel(c, base + MMCICOMMAND);
+	/* Start the data transfer */
+	writel(datactrl, base + MMCIDATACTRL);
 }
 
 static void
@@ -601,26 +650,29 @@ mmci_data_irq(struct mmci_host *host, struct mmc_data *data,
 	 * on others we must sync with the blockend signal since they can
 	 * appear out-of-order.
 	 */
-	if (host->dataend &&
-	    (host->last_blockend || variant->broken_blockend)) {
-		mmci_dma_data_end(host);
-		mmci_stop_data(host);
-
-		/* Reset these flags */
+	if (host->dataend && host->last_blockend) {
 		host->last_blockend = false;
-		host->dataend = false;
 
 		/*
-		 * Variants with broken blockend flags need to handle the
-		 * end of the entire transfer here.
+		 * Make sure there is no dma transfer running before
+		 * ending the transfer and the request.
 		 */
-		if (variant->broken_blockend && !data->error)
+		if (!host->dma_on_current_xfer) {
 			host->data_xfered += data->blksz * data->blocks;
+			mmci_stop_data(host);
+			host->dataend = false;
 
-		if (!data->stop) {
-			mmci_request_end(host, data->mrq);
-		} else {
-			mmci_start_command(host, data->stop, 0);
+			/*
+			 * Variants with broken blockend flags need to handle
+			 * the end of the entire transfer here.
+			 */
+			if (variant->broken_blockend && !data->error)
+				host->data_xfered += data->blksz * data->blocks;
+
+			if (!data->stop)
+				mmci_request_end(host, data->mrq);
+			else
+				mmci_start_command(host, data->stop, 0);
 		}
 	}
 }
@@ -1130,10 +1182,13 @@ static int __devinit mmci_probe(struct amba_device *dev, struct amba_id *id)
 	mmc->max_req_size = (1 << variant->datalength_bits) - 1;
 
 	/*
-	 * Set the maximum segment size.  Since we aren't doing DMA
-	 * (yet) we are only limited by the data length register.
+	 * Set the maximum segment size. Right now DMA sets the
+	 * limit and not the data length register. Thus until the DMA
+	 * driver not handles this, the segment size is limited by DMA.
+	 * DMA limit: src_addr_width x (64 KB -1). src_addr_width
+	 * can be 1.
 	 */
-	mmc->max_seg_size = mmc->max_req_size;
+	mmc->max_seg_size = 65535;
 
 	/*
 	 * Block size can be up to 2048 bytes, but must be a power of two.
-- 
1.7.1

