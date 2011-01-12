Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755925Ab1ALSVE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 13:21:04 -0500
Received: from mail-yi0-f46.google.com ([209.85.218.46]:40145 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755645Ab1ALSUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 13:20:33 -0500
From: Per Forlin <per.forlin@linaro.org>
To: linux-mmc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org
Cc: Chris Ball <cjb@laptop.org>, Per Forlin <per.forlin@linaro.org>
Subject: [FYI 4/4] ARM: mmci: add support for double buffering
Date: Wed, 12 Jan 2011 19:19:43 +0100
Message-Id: <1294856383-14187-5-git-send-email-per.forlin@linaro.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1294856383-14187-1-git-send-email-per.forlin@linaro.org>
References: <1294856383-14187-1-git-send-email-per.forlin@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an example of how to utilize the double buffer
support in the mmc framework. This patch is not intended
nor ready for mainline.

Implement pre_req() and post_reg() hooks. pre_req()
runs dma_map_sg and prepares the dma descriptor and
post_req calls dma_unmap_sg.

Signed-off-by: Per Forlin <per.forlin@linaro.org>
---
 drivers/mmc/host/mmci.c |  164 ++++++++++++++++++++++++++++++++++++-----------
 drivers/mmc/host/mmci.h |    4 +
 2 files changed, 130 insertions(+), 38 deletions(-)

diff --git a/drivers/mmc/host/mmci.c b/drivers/mmc/host/mmci.c
index ab44f5f..7f0b12a 100644
--- a/drivers/mmc/host/mmci.c
+++ b/drivers/mmc/host/mmci.c
@@ -276,6 +276,7 @@ static void __devinit mmci_setup_dma(struct mmci_host *host)
 		host->dma_tx_channel = host->dma_rx_channel;
 	}
 	host->dma_enable = true;
+
 	dev_info(mmc_dev(host->mmc), "use DMA channels DMA RX %s, DMA TX %s\n",
 		 dma_chan_name(host->dma_rx_channel),
 		 dma_chan_name(host->dma_tx_channel));
@@ -296,11 +297,6 @@ static inline void mmci_disable_dma(struct mmci_host *host)
 
 static void mmci_dma_data_end(struct mmci_host *host)
 {
-	struct mmc_data *data = host->data;
-
-	dma_unmap_sg(mmc_dev(host->mmc), data->sg, data->sg_len,
-		     (data->flags & MMC_DATA_WRITE)
-		     ? DMA_TO_DEVICE : DMA_FROM_DEVICE);
 	host->dma_on_current_xfer = false;
 }
 
@@ -353,7 +349,9 @@ static void mmci_dma_callback(void *arg)
 	spin_unlock_irqrestore(&host->lock, flags);
 }
 
-static int mmci_dma_start_data(struct mmci_host *host, unsigned int datactrl)
+static struct dma_async_tx_descriptor *mmci_dma_cfg(struct mmc_data *data,
+						    struct mmci_host *host,
+						    struct dma_chan **chan_dma)
 {
 	struct variant_data *variant = host->variant;
 	struct dma_slave_config rx_conf = {
@@ -368,19 +366,13 @@ static int mmci_dma_start_data(struct mmci_host *host, unsigned int datactrl)
 		.direction = DMA_TO_DEVICE,
 		.dst_maxburst = variant->fifohalfsize >> 2, /* # of words */
 	};
-	struct mmc_data *data = host->data;
 	enum dma_data_direction direction;
 	struct dma_chan *chan;
 	struct dma_async_tx_descriptor *desc;
 	struct scatterlist *sg;
-	dma_cookie_t cookie;
 	int i;
-	unsigned int irqmask0;
 	int sg_len;
 
-	datactrl |= MCI_DPSM_DMAENABLE;
-	datactrl |= variant->dmareg_enable;
-
 	if (data->flags & MMC_DATA_READ) {
 		if (host->size <= variant->txsize_threshold)
 			rx_conf.src_maxburst = 1;
@@ -404,11 +396,12 @@ static int mmci_dma_start_data(struct mmci_host *host, unsigned int datactrl)
 		dev_vdbg(mmc_dev(host->mmc), "MMCI SGlist %d dir %d: length: %08x\n",
 			 i, direction, sg->length);
 		if (sg->offset & 3 || sg->length & 3)
-			return -EINVAL;
+			return NULL;
 	}
 
 	sg_len = dma_map_sg(mmc_dev(host->mmc), data->sg,
-				data->sg_len, direction);
+			    data->sg_len, direction);
+
 	if (!sg_len)
 		goto map_err;
 
@@ -420,7 +413,42 @@ static int mmci_dma_start_data(struct mmci_host *host, unsigned int datactrl)
 
 	desc->callback = mmci_dma_callback;
 	desc->callback_param = host;
-	host->dma_desc = desc;
+
+	*chan_dma = chan;
+	return desc;
+unmap_exit:
+	dma_unmap_sg(mmc_dev(host->mmc), data->sg, data->sg_len, direction);
+map_err:
+	*chan_dma = NULL;
+	return NULL;
+}
+
+static void mmci_dma_prepare(struct mmc_data *data, struct mmci_host *host)
+{
+
+	if (data != host->data_next)
+		host->dma_desc = mmci_dma_cfg(data, host, &host->cur_chan);
+	else {
+		host->dma_desc = host->dma_desc_next;
+		host->cur_chan = host->next_chan;
+
+		host->dma_desc_next = NULL;
+		host->data_next = NULL;
+		host->next_chan = NULL;
+	}
+
+	BUG_ON(!host->dma_desc);
+	BUG_ON(!host->cur_chan);
+}
+
+static int mmci_dma_start_data(struct mmci_host *host)
+{
+	struct mmc_data *data = host->data;
+	struct dma_async_tx_descriptor *desc = host->dma_desc;
+	struct dma_chan *chan = host->cur_chan;
+	dma_cookie_t cookie;
+	enum dma_data_direction direction;
+
 	dev_vdbg(mmc_dev(host->mmc), "Submit MMCI DMA job, sglen %d "
 		 "blksz %04x blks %04x flags %08x\n",
 		 data->sg_len, data->blksz, data->blocks, data->flags);
@@ -433,6 +461,24 @@ static int mmci_dma_start_data(struct mmci_host *host, unsigned int datactrl)
 	host->dma_on_current_xfer = true;
 	chan->device->device_issue_pending(chan);
 
+	return 0;
+unmap_exit:
+	if (data->flags & MMC_DATA_READ)
+		direction = DMA_FROM_DEVICE;
+
+	dma_unmap_sg(mmc_dev(host->mmc), data->sg, data->sg_len, direction);
+	chan->device->device_control(chan, DMA_TERMINATE_ALL, 0);
+
+	return -ENOMEM;
+}
+
+static int mmci_dma_start_fifo(struct mmci_host *host, unsigned int datactrl)
+{
+	unsigned int irqmask0;
+
+	datactrl |= MCI_DPSM_DMAENABLE;
+	datactrl |= host->variant->dmareg_enable;
+
 	/*
 	 * MMCI monitors both MCI_DATAEND and the DMA callback.
 	 * Both events must occur before the transfer is considered
@@ -447,12 +493,45 @@ static int mmci_dma_start_data(struct mmci_host *host, unsigned int datactrl)
 	/* Trigger the DMA transfer */
 	writel(datactrl, host->base + MMCIDATACTRL);
 	return 0;
+}
+
+static void mmci_post_request(struct mmc_host *mmc, struct mmc_request *mrq)
+{
+	struct mmci_host *host = mmc_priv(mmc);
+	struct mmc_data *data = mrq->data;
+
+	if (host->dma_enable)
+		dma_unmap_sg(mmc_dev(host->mmc), data->sg, data->sg_len,
+			     (data->flags & MMC_DATA_WRITE)
+			     ? DMA_TO_DEVICE : DMA_FROM_DEVICE);
+}
+
+static void mmci_pre_request(struct mmc_host *mmc, struct mmc_request *mrq,
+			     bool host_is_idle)
+{
+	struct mmci_host *host = mmc_priv(mmc);
+	struct mmc_data *data = mrq->data;
+
+	if (host->dma_enable && !host_is_idle) {
+		struct dma_async_tx_descriptor *desc;
+		struct dma_chan *chan;
+
+		desc = mmci_dma_cfg(data, host, &chan);
+		if (desc == NULL)
+			goto no_next;
+
+		host->dma_desc_next = desc;
+		host->data_next = data;
+		host->next_chan = chan;
+	}
+
+	return;
+
+ no_next:
+	host->dma_desc_next = NULL;
+	host->data_next = NULL;
+	host->next_chan = NULL;
 
-unmap_exit:
-	dma_unmap_sg(mmc_dev(host->mmc), data->sg, data->sg_len, direction);
-map_err:
-	chan->device->device_control(chan, DMA_TERMINATE_ALL, 0);
-	return -ENOMEM;
 }
 #else
 /* Blank functions if the DMA engine is not available */
@@ -472,10 +551,23 @@ static inline void mmci_dma_terminate(struct mmci_host *host)
 {
 }
 
-static inline int mmci_dma_start_data(struct mmci_host *host, unsigned int datactrl)
+static inline int mmci_dma_start_data(struct mmci_host *host)
 {
 	return -ENOSYS;
 }
+
+static inline int mmci_dma_start_fifo(struct mmci_host *host,
+				      unsigned int datactrl)
+{
+	return -ENOSYS;
+}
+
+static void mmci_dma_prepare(struct mmc_data *data, struct mmci_host *host)
+{
+}
+
+#define mmci_post_request NULL
+#define mmci_pre_request NULL
 #endif
 
 static void mmci_start_data(struct mmci_host *host, struct mmc_data *data)
@@ -519,7 +611,7 @@ static void mmci_start_data(struct mmci_host *host, struct mmc_data *data)
 		 * Attempt to use DMA operation mode, if this
 		 * should fail, fall back to PIO mode
 		 */
-		ret = mmci_dma_start_data(host, datactrl);
+		ret = mmci_dma_start_fifo(host, datactrl);
 		if (!ret)
 			return;
 	}
@@ -662,13 +754,6 @@ mmci_data_irq(struct mmci_host *host, struct mmc_data *data,
 			mmci_stop_data(host);
 			host->dataend = false;
 
-			/*
-			 * Variants with broken blockend flags need to handle
-			 * the end of the entire transfer here.
-			 */
-			if (variant->broken_blockend && !data->error)
-				host->data_xfered += data->blksz * data->blocks;
-
 			if (!data->stop)
 				mmci_request_end(host, data->mrq);
 			else
@@ -705,6 +790,8 @@ mmci_cmd_irq(struct mmci_host *host, struct mmc_command *cmd,
 		mmci_request_end(host, cmd->mrq);
 	} else if (!(cmd->data->flags & MMC_DATA_READ)) {
 		mmci_start_data(host, cmd->data);
+		if (host->dma_enable)
+			mmci_dma_start_data(host);
 	}
 }
 
@@ -944,6 +1031,13 @@ static void mmci_request(struct mmc_host *mmc, struct mmc_request *mrq)
 
 	mmci_start_command(host, mrq->cmd, 0);
 
+	if (host->dma_enable && mrq->data) {
+		mmci_dma_prepare(mrq->data, host);
+
+		if (mrq->data->flags & MMC_DATA_READ)
+			mmci_dma_start_data(host);
+	}
+
 	spin_unlock_irqrestore(&host->lock, flags);
 }
 
@@ -1053,6 +1147,8 @@ static irqreturn_t mmci_cd_irq(int irq, void *dev_id)
 
 static const struct mmc_host_ops mmci_ops = {
 	.request	= mmci_request,
+	.pre_req	= mmci_pre_request,
+	.post_req	= mmci_post_request,
 	.set_ios	= mmci_set_ios,
 	.get_ro		= mmci_get_ro,
 	.get_cd		= mmci_get_cd,
@@ -1180,15 +1276,7 @@ static int __devinit mmci_probe(struct amba_device *dev, struct amba_id *id)
 	 * single request.
 	 */
 	mmc->max_req_size = (1 << variant->datalength_bits) - 1;
-
-	/*
-	 * Set the maximum segment size. Right now DMA sets the
-	 * limit and not the data length register. Thus until the DMA
-	 * driver not handles this, the segment size is limited by DMA.
-	 * DMA limit: src_addr_width x (64 KB -1). src_addr_width
-	 * can be 1.
-	 */
-	mmc->max_seg_size = 65535;
+	mmc->max_seg_size = mmc->max_req_size;
 
 	/*
 	 * Block size can be up to 2048 bytes, but must be a power of two.
diff --git a/drivers/mmc/host/mmci.h b/drivers/mmc/host/mmci.h
index 39b7ac7..828ab5a 100644
--- a/drivers/mmc/host/mmci.h
+++ b/drivers/mmc/host/mmci.h
@@ -196,6 +196,10 @@ struct mmci_host {
 	struct dma_chan		*dma_rx_channel;
 	struct dma_chan		*dma_tx_channel;
 	struct dma_async_tx_descriptor *dma_desc;
+	struct dma_async_tx_descriptor *dma_desc_next;
+	struct mmc_data		*data_next;
+	struct dma_chan		*cur_chan;
+	struct dma_chan		*next_chan;
 #endif
 };
 
-- 
1.7.1

