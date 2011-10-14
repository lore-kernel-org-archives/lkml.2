Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755577Ab1JNFra (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 01:47:30 -0400
Received: from mga14.intel.com ([143.182.124.37]:25401 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932429Ab1JNFrX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 01:47:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,344,1315206000"; 
   d="scan'208";a="62487030"
From: Vinod Koul <vinod.koul@intel.com>
To: dan.j.williams@intel.com
Cc: linux-kernel@vger.kernel.org, jaswinder.singh@linaro.org,
        21cnbao@gmail.com, rmk@arm.linux.org.uk,
        Vinod Koul <vinod.koul@linux.intel.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>, Chris Ball <cjb@laptop.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: [PATCH 06/10] mmc-host: move to dma_transfer_direction
Date: Fri, 14 Oct 2011 11:08:21 +0530
Message-Id: <1318570705-17595-7-git-send-email-vinod.koul@intel.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1318570705-17595-1-git-send-email-vinod.koul@intel.com>
References: <1318570705-17595-1-git-send-email-vinod.koul@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vinod Koul <vinod.koul@linux.intel.com>

Signed-off-by: Vinod Koul <vinod.koul@linux.intel.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Chris Ball <cjb@laptop.org>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/mmc/host/atmel-mci.c    |    9 ++++++---
 drivers/mmc/host/mmci.c         |   11 +++++++----
 drivers/mmc/host/mxcmmc.c       |   10 +++++++---
 drivers/mmc/host/mxs-mmc.c      |    7 ++++++-
 drivers/mmc/host/sh_mmcif.c     |    4 ++--
 drivers/mmc/host/tmio_mmc_dma.c |    4 ++--
 6 files changed, 30 insertions(+), 15 deletions(-)

diff --git a/drivers/mmc/host/atmel-mci.c b/drivers/mmc/host/atmel-mci.c
index fa8cae1..7c9d28a 100644
--- a/drivers/mmc/host/atmel-mci.c
+++ b/drivers/mmc/host/atmel-mci.c
@@ -681,16 +681,19 @@ atmci_prepare_data_dma(struct atmel_mci *host, struct mmc_data *data)
 	if (atmci_is_mci2())
 		mci_writel(host, DMA, MCI_DMA_CHKSIZE(3) | MCI_DMAEN);
 
-	if (data->flags & MMC_DATA_READ)
+	if (data->flags & MMC_DATA_READ) {
 		direction = DMA_FROM_DEVICE;
-	else
+		slave_dirn = DEV_TO_MEM;
+	} else {
 		direction = DMA_TO_DEVICE;
+		slave_dirn = MEM_TO_DEV;
+	}
 
 	sglen = dma_map_sg(chan->device->dev, data->sg,
 			   data->sg_len, direction);
 
 	desc = chan->device->device_prep_slave_sg(chan,
-			data->sg, sglen, direction,
+			data->sg, sglen, slave_dirn,
 			DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
 	if (!desc)
 		goto unmap_exit;
diff --git a/drivers/mmc/host/mmci.c b/drivers/mmc/host/mmci.c
index 56e9a41..efbc743 100644
--- a/drivers/mmc/host/mmci.c
+++ b/drivers/mmc/host/mmci.c
@@ -372,6 +372,7 @@ static int mmci_dma_prep_data(struct mmci_host *host, struct mmc_data *data,
 	struct dma_chan *chan;
 	struct dma_device *device;
 	struct dma_async_tx_descriptor *desc;
+	enum dma_data_direction buffer_dirn;
 	int nr_sg;
 
 	/* Check if next job is already prepared */
@@ -385,10 +386,12 @@ static int mmci_dma_prep_data(struct mmci_host *host, struct mmc_data *data,
 	}
 
 	if (data->flags & MMC_DATA_READ) {
-		conf.direction = DMA_FROM_DEVICE;
+		conf.direction = DEV_TO_MEM;
+		buffer_dirn = DMA_FROM_DEVICE;
 		chan = host->dma_rx_channel;
 	} else {
-		conf.direction = DMA_TO_DEVICE;
+		conf.direction = MEM_TO_DEV;
+		buffer_dirn = DMA_TO_DEVICE;
 		chan = host->dma_tx_channel;
 	}
 
@@ -401,7 +404,7 @@ static int mmci_dma_prep_data(struct mmci_host *host, struct mmc_data *data,
 		return -EINVAL;
 
 	device = chan->device;
-	nr_sg = dma_map_sg(device->dev, data->sg, data->sg_len, conf.direction);
+	nr_sg = dma_map_sg(device->dev, data->sg, data->sg_len, buffer_dirn);
 	if (nr_sg == 0)
 		return -EINVAL;
 
@@ -424,7 +427,7 @@ static int mmci_dma_prep_data(struct mmci_host *host, struct mmc_data *data,
  unmap_exit:
 	if (!next)
 		dmaengine_terminate_all(chan);
-	dma_unmap_sg(device->dev, data->sg, data->sg_len, conf.direction);
+	dma_unmap_sg(device->dev, data->sg, data->sg_len, buffer_dirn);
 	return -ENOMEM;
 }
 
diff --git a/drivers/mmc/host/mxcmmc.c b/drivers/mmc/host/mxcmmc.c
index 14aa213..4115108 100644
--- a/drivers/mmc/host/mxcmmc.c
+++ b/drivers/mmc/host/mxcmmc.c
@@ -217,6 +217,7 @@ static int mxcmci_setup_data(struct mxcmci_host *host, struct mmc_data *data)
 	unsigned int blksz = data->blksz;
 	unsigned int datasize = nob * blksz;
 	struct scatterlist *sg;
+	enum dma_transfer_direction slave_dirn;
 	int i, nents;
 
 	if (data->flags & MMC_DATA_STREAM)
@@ -239,10 +240,13 @@ static int mxcmci_setup_data(struct mxcmci_host *host, struct mmc_data *data)
 		}
 	}
 
-	if (data->flags & MMC_DATA_READ)
+	if (data->flags & MMC_DATA_READ) {
 		host->dma_dir = DMA_FROM_DEVICE;
-	else
+		slave_dirn = DEV_TO_MEM;
+	} else {
 		host->dma_dir = DMA_TO_DEVICE;
+		slave_dirn = MEM_TO_DEV;
+	}
 
 	nents = dma_map_sg(host->dma->device->dev, data->sg,
 				     data->sg_len,  host->dma_dir);
@@ -250,7 +254,7 @@ static int mxcmci_setup_data(struct mxcmci_host *host, struct mmc_data *data)
 		return -EINVAL;
 
 	host->desc = host->dma->device->device_prep_slave_sg(host->dma,
-		data->sg, data->sg_len, host->dma_dir,
+		data->sg, data->sg_len, slave_dirn,
 		DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
 
 	if (!host->desc) {
diff --git a/drivers/mmc/host/mxs-mmc.c b/drivers/mmc/host/mxs-mmc.c
index d513d47..c0a3def 100644
--- a/drivers/mmc/host/mxs-mmc.c
+++ b/drivers/mmc/host/mxs-mmc.c
@@ -153,6 +153,7 @@ struct mxs_mmc_host {
 	struct dma_chan         	*dmach;
 	struct mxs_dma_data		dma_data;
 	unsigned int			dma_dir;
+	enum dma_transfer_direction	slave_dirn;
 	u32				ssp_pio_words[SSP_PIO_NUM];
 
 	unsigned int			version;
@@ -323,7 +324,7 @@ static struct dma_async_tx_descriptor *mxs_mmc_prep_dma(
 	}
 
 	desc = host->dmach->device->device_prep_slave_sg(host->dmach,
-				sgl, sg_len, host->dma_dir, append);
+				sgl, sg_len, host->slave_dirn, append);
 	if (desc) {
 		desc->callback = mxs_mmc_dma_irq_callback;
 		desc->callback_param = host;
@@ -432,6 +433,7 @@ static void mxs_mmc_adtc(struct mxs_mmc_host *host)
 	int i;
 
 	unsigned short dma_data_dir, timeout;
+	enum dma_transfer_direction slave_dirn;
 	unsigned int data_size = 0, log2_blksz;
 	unsigned int blocks = data->blocks;
 
@@ -447,9 +449,11 @@ static void mxs_mmc_adtc(struct mxs_mmc_host *host)
 
 	if (data->flags & MMC_DATA_WRITE) {
 		dma_data_dir = DMA_TO_DEVICE;
+		slave_dirn = MEM_TO_DEV;
 		read = 0;
 	} else {
 		dma_data_dir = DMA_FROM_DEVICE;
+		slave_dirn = DEV_TO_MEM;
 		read = BM_SSP_CTRL0_READ;
 	}
 
@@ -517,6 +521,7 @@ static void mxs_mmc_adtc(struct mxs_mmc_host *host)
 	WARN_ON(host->data != NULL);
 	host->data = data;
 	host->dma_dir = dma_data_dir;
+	host->slave_dirn = slave_dirn;
 	desc = mxs_mmc_prep_dma(host, 1);
 	if (!desc)
 		goto out;
diff --git a/drivers/mmc/host/sh_mmcif.c b/drivers/mmc/host/sh_mmcif.c
index 557886b..7a374c9 100644
--- a/drivers/mmc/host/sh_mmcif.c
+++ b/drivers/mmc/host/sh_mmcif.c
@@ -230,7 +230,7 @@ static void sh_mmcif_start_dma_rx(struct sh_mmcif_host *host)
 	if (ret > 0) {
 		host->dma_active = true;
 		desc = chan->device->device_prep_slave_sg(chan, sg, ret,
-			DMA_FROM_DEVICE, DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
+			DEV_TO_MEM, DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
 	}
 
 	if (desc) {
@@ -278,7 +278,7 @@ static void sh_mmcif_start_dma_tx(struct sh_mmcif_host *host)
 	if (ret > 0) {
 		host->dma_active = true;
 		desc = chan->device->device_prep_slave_sg(chan, sg, ret,
-			DMA_TO_DEVICE, DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
+			MEM_TO_DEV, DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
 	}
 
 	if (desc) {
diff --git a/drivers/mmc/host/tmio_mmc_dma.c b/drivers/mmc/host/tmio_mmc_dma.c
index 86f259c..663624c 100644
--- a/drivers/mmc/host/tmio_mmc_dma.c
+++ b/drivers/mmc/host/tmio_mmc_dma.c
@@ -77,7 +77,7 @@ static void tmio_mmc_start_dma_rx(struct tmio_mmc_host *host)
 	ret = dma_map_sg(chan->device->dev, sg, host->sg_len, DMA_FROM_DEVICE);
 	if (ret > 0)
 		desc = chan->device->device_prep_slave_sg(chan, sg, ret,
-			DMA_FROM_DEVICE, DMA_CTRL_ACK);
+			DEV_TO_MEM, DMA_CTRL_ACK);
 
 	if (desc) {
 		cookie = dmaengine_submit(desc);
@@ -158,7 +158,7 @@ static void tmio_mmc_start_dma_tx(struct tmio_mmc_host *host)
 	ret = dma_map_sg(chan->device->dev, sg, host->sg_len, DMA_TO_DEVICE);
 	if (ret > 0)
 		desc = chan->device->device_prep_slave_sg(chan, sg, ret,
-			DMA_TO_DEVICE, DMA_CTRL_ACK);
+			MEM_TO_DEV, DMA_CTRL_ACK);
 
 	if (desc) {
 		cookie = dmaengine_submit(desc);
-- 
1.7.0.4

