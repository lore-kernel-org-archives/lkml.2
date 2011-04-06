Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932167Ab1DFTIk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 15:08:40 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:57692 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932099Ab1DFTIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 15:08:37 -0400
From: Per Forlin <per.forlin@linaro.org>
To: linux-mmc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org
Cc: Chris Ball <cjb@laptop.org>, Per Forlin <per.forlin@linaro.org>
Subject: [PATCH v2 12/12] mmci: implement pre_req() and post_req()
Date: Wed,  6 Apr 2011 21:07:13 +0200
Message-Id: <1302116833-24540-13-git-send-email-per.forlin@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1302116833-24540-1-git-send-email-per.forlin@linaro.org>
References: <1302116833-24540-1-git-send-email-per.forlin@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pre_req() runs dma_map_sg() and prepares the dma descriptor
for the next mmc data transfer. post_req() runs dma_unmap_sg.
If not calling pre_req() before mmci_request(), mmci_request()
will prepare the cache and dma just like it did it before.
It is optional to use pre_req() and post_req() for mmci.

Signed-off-by: Per Forlin <per.forlin@linaro.org>
---
 drivers/mmc/host/mmci.c |  146 ++++++++++++++++++++++++++++++++++++++++++----
 drivers/mmc/host/mmci.h |    8 +++
 2 files changed, 141 insertions(+), 13 deletions(-)

diff --git a/drivers/mmc/host/mmci.c b/drivers/mmc/host/mmci.c
index b4a7e4f..985c77d 100644
--- a/drivers/mmc/host/mmci.c
+++ b/drivers/mmc/host/mmci.c
@@ -320,7 +320,8 @@ static void mmci_dma_unmap(struct mmci_host *host, struct mmc_data *data)
 		dir = DMA_FROM_DEVICE;
 	}
 
-	dma_unmap_sg(chan->device->dev, data->sg, data->sg_len, dir);
+	if (!data->host_cookie)
+		dma_unmap_sg(chan->device->dev, data->sg, data->sg_len, dir);
 
 	/*
 	 * Use of DMA with scatter-gather is impossible.
@@ -338,7 +339,8 @@ static void mmci_dma_data_error(struct mmci_host *host)
 	dmaengine_terminate_all(host->dma_current);
 }
 
-static int mmci_dma_start_data(struct mmci_host *host, unsigned int datactrl)
+static int mmci_dma_prep_data(struct mmci_host *host, struct mmc_data *data,
+			      struct mmci_host_next *next)
 {
 	struct variant_data *variant = host->variant;
 	struct dma_slave_config conf = {
@@ -349,13 +351,20 @@ static int mmci_dma_start_data(struct mmci_host *host, unsigned int datactrl)
 		.src_maxburst = variant->fifohalfsize >> 2, /* # of words */
 		.dst_maxburst = variant->fifohalfsize >> 2, /* # of words */
 	};
-	struct mmc_data *data = host->data;
 	struct dma_chan *chan;
 	struct dma_device *device;
 	struct dma_async_tx_descriptor *desc;
 	int nr_sg;
 
-	host->dma_current = NULL;
+	/* Check if next job is already prepared */
+	if (data->host_cookie && !next &&
+	    host->dma_current && host->dma_desc_current)
+		return 0;
+
+	if (!next) {
+		host->dma_current = NULL;
+		host->dma_desc_current = NULL;
+	}
 
 	if (data->flags & MMC_DATA_READ) {
 		conf.direction = DMA_FROM_DEVICE;
@@ -370,7 +379,7 @@ static int mmci_dma_start_data(struct mmci_host *host, unsigned int datactrl)
 		return -EINVAL;
 
 	/* If less than or equal to the fifo size, don't bother with DMA */
-	if (host->size <= variant->fifosize)
+	if (data->blksz * data->blocks <= variant->fifosize)
 		return -EINVAL;
 
 	device = chan->device;
@@ -384,14 +393,38 @@ static int mmci_dma_start_data(struct mmci_host *host, unsigned int datactrl)
 	if (!desc)
 		goto unmap_exit;
 
-	/* Okay, go for it. */
-	host->dma_current = chan;
+	if (next) {
+		next->dma_chan = chan;
+		next->dma_desc = desc;
+	} else {
+		host->dma_current = chan;
+		host->dma_desc_current = desc;
+	}
+
+	return 0;
 
+ unmap_exit:
+	if (!next)
+		dmaengine_terminate_all(chan);
+	dma_unmap_sg(device->dev, data->sg, data->sg_len, conf.direction);
+	return -ENOMEM;
+}
+
+static int mmci_dma_start_data(struct mmci_host *host, unsigned int datactrl)
+{
+	int ret;
+	struct mmc_data *data = host->data;
+
+	ret = mmci_dma_prep_data(host, host->data, NULL);
+	if (ret)
+		return ret;
+
+	/* Okay, go for it. */
 	dev_vdbg(mmc_dev(host->mmc),
 		 "Submit MMCI DMA job, sglen %d blksz %04x blks %04x flags %08x\n",
 		 data->sg_len, data->blksz, data->blocks, data->flags);
-	dmaengine_submit(desc);
-	dma_async_issue_pending(chan);
+	dmaengine_submit(host->dma_desc_current);
+	dma_async_issue_pending(host->dma_current);
 
 	datactrl |= MCI_DPSM_DMAENABLE;
 
@@ -406,14 +439,90 @@ static int mmci_dma_start_data(struct mmci_host *host, unsigned int datactrl)
 	writel(readl(host->base + MMCIMASK0) | MCI_DATAENDMASK,
 	       host->base + MMCIMASK0);
 	return 0;
+}
 
-unmap_exit:
-	dmaengine_terminate_all(chan);
-	dma_unmap_sg(device->dev, data->sg, data->sg_len, conf.direction);
-	return -ENOMEM;
+static void mmci_get_next_data(struct mmci_host *host, struct mmc_data *data)
+{
+	struct mmci_host_next *next = &host->next_data;
+
+	if (data->host_cookie && data->host_cookie != next->cookie) {
+		printk(KERN_WARNING "[%s] invalid cookie: data->host_cookie %d"
+		       " host->next_data.cookie %d\n",
+		       __func__, data->host_cookie, host->next_data.cookie);
+		data->host_cookie = 0;
+	}
+
+	if (!data->host_cookie)
+		return;
+
+	host->dma_desc_current = next->dma_desc;
+	host->dma_current = next->dma_chan;
+
+	next->dma_desc = NULL;
+	next->dma_chan = NULL;
 }
+
+static void mmci_pre_request(struct mmc_host *mmc, struct mmc_request *mrq,
+			     bool is_first_req)
+{
+	struct mmci_host *host = mmc_priv(mmc);
+	struct mmc_data *data = mrq->data;
+	struct mmci_host_next *nd = &host->next_data;
+
+	if (!data)
+		return;
+
+	if (data->host_cookie) {
+		data->host_cookie = 0;
+		return;
+	}
+
+	/* if config for dma */
+	if (((data->flags & MMC_DATA_WRITE) && host->dma_tx_channel) ||
+	    ((data->flags & MMC_DATA_READ) && host->dma_rx_channel)) {
+		if (mmci_dma_prep_data(host, data, nd))
+			data->host_cookie = 0;
+		else
+			data->host_cookie = ++nd->cookie < 0 ? 1 : nd->cookie;
+	}
+}
+
+static void mmci_post_request(struct mmc_host *mmc, struct mmc_request *mrq,
+			      int err)
+{
+	struct mmci_host *host = mmc_priv(mmc);
+	struct mmc_data *data = mrq->data;
+	struct dma_chan *chan;
+	enum dma_data_direction dir;
+
+	if (!data)
+		return;
+
+	if (data->flags & MMC_DATA_READ) {
+		dir = DMA_FROM_DEVICE;
+		chan = host->dma_rx_channel;
+	} else {
+		dir = DMA_TO_DEVICE;
+		chan = host->dma_tx_channel;
+	}
+
+
+	/* if config for dma */
+	if (chan) {
+		if (err)
+			dmaengine_terminate_all(chan);
+		if (err || data->host_cookie)
+			dma_unmap_sg(mmc_dev(host->mmc), data->sg,
+				     data->sg_len, dir);
+		mrq->data->host_cookie = 0;
+	}
+}
+
 #else
 /* Blank functions if the DMA engine is not available */
+static void mmci_get_next_data(struct mmci_host *host, struct mmc_data *data)
+{
+}
 static inline void mmci_dma_setup(struct mmci_host *host)
 {
 }
@@ -434,6 +543,10 @@ static inline int mmci_dma_start_data(struct mmci_host *host, unsigned int datac
 {
 	return -ENOSYS;
 }
+
+#define mmci_pre_request NULL
+#define mmci_post_request NULL
+
 #endif
 
 static void mmci_start_data(struct mmci_host *host, struct mmc_data *data)
@@ -852,6 +965,9 @@ static void mmci_request(struct mmc_host *mmc, struct mmc_request *mrq)
 
 	host->mrq = mrq;
 
+	if (mrq->data)
+		mmci_get_next_data(host, mrq->data);
+
 	if (mrq->data && mrq->data->flags & MMC_DATA_READ)
 		mmci_start_data(host, mrq->data);
 
@@ -966,6 +1082,8 @@ static irqreturn_t mmci_cd_irq(int irq, void *dev_id)
 
 static const struct mmc_host_ops mmci_ops = {
 	.request	= mmci_request,
+	.pre_req	= mmci_pre_request,
+	.post_req	= mmci_post_request,
 	.set_ios	= mmci_set_ios,
 	.get_ro		= mmci_get_ro,
 	.get_cd		= mmci_get_cd,
@@ -1003,6 +1121,8 @@ static int __devinit mmci_probe(struct amba_device *dev,
 	host->gpio_cd = -ENOSYS;
 	host->gpio_cd_irq = -1;
 
+	host->next_data.cookie = 1;
+
 	host->hw_designer = amba_manf(dev);
 	host->hw_revision = amba_rev(dev);
 	dev_dbg(mmc_dev(mmc), "designer ID = 0x%02x\n", host->hw_designer);
diff --git a/drivers/mmc/host/mmci.h b/drivers/mmc/host/mmci.h
index ec9a7bc6..e21d850 100644
--- a/drivers/mmc/host/mmci.h
+++ b/drivers/mmc/host/mmci.h
@@ -150,6 +150,12 @@ struct clk;
 struct variant_data;
 struct dma_chan;
 
+struct mmci_host_next {
+	struct dma_async_tx_descriptor	*dma_desc;
+	struct dma_chan			*dma_chan;
+	s32				cookie;
+};
+
 struct mmci_host {
 	phys_addr_t		phybase;
 	void __iomem		*base;
@@ -187,6 +193,8 @@ struct mmci_host {
 	struct dma_chan		*dma_current;
 	struct dma_chan		*dma_rx_channel;
 	struct dma_chan		*dma_tx_channel;
+	struct dma_async_tx_descriptor	*dma_desc_current;
+	struct mmci_host_next	next_data;
 
 #define dma_inprogress(host)	((host)->dma_current)
 #else
-- 
1.7.4.1

