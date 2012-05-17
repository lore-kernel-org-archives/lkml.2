Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967009Ab2EQO6m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 10:58:42 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:64186 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966601Ab2EQO6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 10:58:37 -0400
X-AuditID: cbfee61b-b7bb6ae0000006fb-2a-4fb5120a069e
From: Thomas Abraham <thomas.abraham@linaro.org>
To: linux-mmc@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        cjb@laptop.org, grant.likely@secretlab.ca, rob.herring@calxeda.com,
        linux-samsung-soc@vger.kernel.org, kgene.kim@samsung.com,
        patches@linaro.org
Subject: [PATCH v2 1/6] mmc: dw_mmc: convert copy of struct device in struct
 dw_mci to a reference
Date: Thu, 17 May 2012 20:40:06 +0530
Message-id: <1337267411-28226-2-git-send-email-thomas.abraham@linaro.org>
X-Mailer: git-send-email 1.6.6.rc2
In-reply-to: <1337267411-28226-1-git-send-email-thomas.abraham@linaro.org>
References: <1337267411-28226-1-git-send-email-thomas.abraham@linaro.org>
X-Brightmail-Tracker: AAAAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 'struct dw_mci' maintains a copy of the pdev->dev instance instead of
maintaining a reference to that 'struct device' instance. Any resource
allocated using the device resource management kernel API with the instance
of 'struct device' in 'struct dw_mci' is then incorrect. Fix this by
converting the copy of 'struct device' in 'struct dw_mci' to a reference.

Signed-off-by: Thomas Abraham <thomas.abraham@linaro.org>
---
 drivers/mmc/host/dw_mmc-pltfm.c |    2 +-
 drivers/mmc/host/dw_mmc.c       |   54 +++++++++++++++++++-------------------
 include/linux/mmc/dw_mmc.h      |    2 +-
 3 files changed, 29 insertions(+), 29 deletions(-)

diff --git a/drivers/mmc/host/dw_mmc-pltfm.c b/drivers/mmc/host/dw_mmc-pltfm.c
index 92ec3eb..9a63299 100644
--- a/drivers/mmc/host/dw_mmc-pltfm.c
+++ b/drivers/mmc/host/dw_mmc-pltfm.c
@@ -43,7 +43,7 @@ static int dw_mci_pltfm_probe(struct platform_device *pdev)
 		goto err_free;
 	}
 
-	host->dev = pdev->dev;
+	host->dev = &pdev->dev;
 	host->irq_flags = 0;
 	host->pdata = pdev->dev.platform_data;
 	ret = -ENOMEM;
diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
index 1532357..01d870a 100644
--- a/drivers/mmc/host/dw_mmc.c
+++ b/drivers/mmc/host/dw_mmc.c
@@ -266,7 +266,7 @@ static void dw_mci_start_command(struct dw_mci *host,
 				 struct mmc_command *cmd, u32 cmd_flags)
 {
 	host->cmd = cmd;
-	dev_vdbg(&host->dev,
+	dev_vdbg(host->dev,
 		 "start command: ARGR=0x%08x CMDR=0x%08x\n",
 		 cmd->arg, cmd_flags);
 
@@ -308,7 +308,7 @@ static void dw_mci_dma_cleanup(struct dw_mci *host)
 
 	if (data)
 		if (!data->host_cookie)
-			dma_unmap_sg(&host->dev,
+			dma_unmap_sg(host->dev,
 				     data->sg,
 				     data->sg_len,
 				     dw_mci_get_dma_dir(data));
@@ -334,7 +334,7 @@ static void dw_mci_idmac_complete_dma(struct dw_mci *host)
 {
 	struct mmc_data *data = host->data;
 
-	dev_vdbg(&host->dev, "DMA complete\n");
+	dev_vdbg(host->dev, "DMA complete\n");
 
 	host->dma_ops->cleanup(host);
 
@@ -462,7 +462,7 @@ static int dw_mci_pre_dma_transfer(struct dw_mci *host,
 			return -EINVAL;
 	}
 
-	sg_len = dma_map_sg(&host->dev,
+	sg_len = dma_map_sg(host->dev,
 			    data->sg,
 			    data->sg_len,
 			    dw_mci_get_dma_dir(data));
@@ -505,7 +505,7 @@ static void dw_mci_post_req(struct mmc_host *mmc,
 		return;
 
 	if (data->host_cookie)
-		dma_unmap_sg(&slot->host->dev,
+		dma_unmap_sg(slot->host->dev,
 			     data->sg,
 			     data->sg_len,
 			     dw_mci_get_dma_dir(data));
@@ -531,7 +531,7 @@ static int dw_mci_submit_data_dma(struct dw_mci *host, struct mmc_data *data)
 
 	host->using_dma = 1;
 
-	dev_vdbg(&host->dev,
+	dev_vdbg(host->dev,
 		 "sd sg_cpu: %#lx sg_dma: %#lx sg_len: %d\n",
 		 (unsigned long)host->sg_cpu, (unsigned long)host->sg_dma,
 		 sg_len);
@@ -889,12 +889,12 @@ static void dw_mci_request_end(struct dw_mci *host, struct mmc_request *mrq)
 		slot = list_entry(host->queue.next,
 				  struct dw_mci_slot, queue_node);
 		list_del(&slot->queue_node);
-		dev_vdbg(&host->dev, "list not empty: %s is next\n",
+		dev_vdbg(host->dev, "list not empty: %s is next\n",
 			 mmc_hostname(slot->mmc));
 		host->state = STATE_SENDING_CMD;
 		dw_mci_start_request(host, slot);
 	} else {
-		dev_vdbg(&host->dev, "list empty\n");
+		dev_vdbg(host->dev, "list empty\n");
 		host->state = STATE_IDLE;
 	}
 
@@ -1033,7 +1033,7 @@ static void dw_mci_tasklet_func(unsigned long priv)
 					data->bytes_xfered = 0;
 					data->error = -ETIMEDOUT;
 				} else {
-					dev_err(&host->dev,
+					dev_err(host->dev,
 						"data FIFO error "
 						"(status=%08x)\n",
 						status);
@@ -1750,7 +1750,7 @@ static int __init dw_mci_init_slot(struct dw_mci *host, unsigned int id)
 	struct mmc_host *mmc;
 	struct dw_mci_slot *slot;
 
-	mmc = mmc_alloc_host(sizeof(struct dw_mci_slot), &host->dev);
+	mmc = mmc_alloc_host(sizeof(struct dw_mci_slot), host->dev);
 	if (!mmc)
 		return -ENOMEM;
 
@@ -1862,10 +1862,10 @@ static void dw_mci_cleanup_slot(struct dw_mci_slot *slot, unsigned int id)
 static void dw_mci_init_dma(struct dw_mci *host)
 {
 	/* Alloc memory for sg translation */
-	host->sg_cpu = dma_alloc_coherent(&host->dev, PAGE_SIZE,
+	host->sg_cpu = dma_alloc_coherent(host->dev, PAGE_SIZE,
 					  &host->sg_dma, GFP_KERNEL);
 	if (!host->sg_cpu) {
-		dev_err(&host->dev, "%s: could not alloc DMA memory\n",
+		dev_err(host->dev, "%s: could not alloc DMA memory\n",
 			__func__);
 		goto no_dma;
 	}
@@ -1873,7 +1873,7 @@ static void dw_mci_init_dma(struct dw_mci *host)
 	/* Determine which DMA interface to use */
 #ifdef CONFIG_MMC_DW_IDMAC
 	host->dma_ops = &dw_mci_idmac_ops;
-	dev_info(&host->dev, "Using internal DMA controller.\n");
+	dev_info(host->dev, "Using internal DMA controller.\n");
 #endif
 
 	if (!host->dma_ops)
@@ -1882,12 +1882,12 @@ static void dw_mci_init_dma(struct dw_mci *host)
 	if (host->dma_ops->init && host->dma_ops->start &&
 	    host->dma_ops->stop && host->dma_ops->cleanup) {
 		if (host->dma_ops->init(host)) {
-			dev_err(&host->dev, "%s: Unable to initialize "
+			dev_err(host->dev, "%s: Unable to initialize "
 				"DMA Controller.\n", __func__);
 			goto no_dma;
 		}
 	} else {
-		dev_err(&host->dev, "DMA initialization not found.\n");
+		dev_err(host->dev, "DMA initialization not found.\n");
 		goto no_dma;
 	}
 
@@ -1895,7 +1895,7 @@ static void dw_mci_init_dma(struct dw_mci *host)
 	return;
 
 no_dma:
-	dev_info(&host->dev, "Using PIO mode.\n");
+	dev_info(host->dev, "Using PIO mode.\n");
 	host->use_dma = 0;
 	return;
 }
@@ -1927,19 +1927,19 @@ int dw_mci_probe(struct dw_mci *host)
 	u32 fifo_size;
 
 	if (!host->pdata || !host->pdata->init) {
-		dev_err(&host->dev,
+		dev_err(host->dev,
 			"Platform data must supply init function\n");
 		return -ENODEV;
 	}
 
 	if (!host->pdata->select_slot && host->pdata->num_slots > 1) {
-		dev_err(&host->dev,
+		dev_err(host->dev,
 			"Platform data must supply select_slot function\n");
 		return -ENODEV;
 	}
 
 	if (!host->pdata->bus_hz) {
-		dev_err(&host->dev,
+		dev_err(host->dev,
 			"Platform data must supply bus speed\n");
 		return -ENODEV;
 	}
@@ -1981,7 +1981,7 @@ int dw_mci_probe(struct dw_mci *host)
 	}
 
 	/* Reset all blocks */
-	if (!mci_wait_reset(&host->dev, host)) {
+	if (!mci_wait_reset(host->dev, host)) {
 		ret = -ENODEV;
 		goto err_dmaunmap;
 	}
@@ -2047,7 +2047,7 @@ int dw_mci_probe(struct dw_mci *host)
 	 * Need to check the version-id and set data-offset for DATA register.
 	 */
 	host->verid = SDMMC_GET_VERID(mci_readl(host, VERID));
-	dev_info(&host->dev, "Version ID is %04x\n", host->verid);
+	dev_info(host->dev, "Version ID is %04x\n", host->verid);
 
 	if (host->verid < DW_MMC_240A)
 		host->data_offset = DATA_OFFSET;
@@ -2064,12 +2064,12 @@ int dw_mci_probe(struct dw_mci *host)
 		   DW_MCI_ERROR_FLAGS | SDMMC_INT_CD);
 	mci_writel(host, CTRL, SDMMC_CTRL_INT_ENABLE); /* Enable mci interrupt */
 
-	dev_info(&host->dev, "DW MMC controller at irq %d, "
+	dev_info(host->dev, "DW MMC controller at irq %d, "
 		 "%d bit host data width, "
 		 "%u deep fifo\n",
 		 host->irq, width, fifo_size);
 	if (host->quirks & DW_MCI_QUIRK_IDMAC_DTO)
-		dev_info(&host->dev, "Internal DMAC interrupt fix enabled.\n");
+		dev_info(host->dev, "Internal DMAC interrupt fix enabled.\n");
 
 	return 0;
 
@@ -2088,7 +2088,7 @@ err_workqueue:
 err_dmaunmap:
 	if (host->use_dma && host->dma_ops->exit)
 		host->dma_ops->exit(host);
-	dma_free_coherent(&host->dev, PAGE_SIZE,
+	dma_free_coherent(host->dev, PAGE_SIZE,
 			  host->sg_cpu, host->sg_dma);
 
 	if (host->vmmc) {
@@ -2107,7 +2107,7 @@ void dw_mci_remove(struct dw_mci *host)
 	mci_writel(host, INTMASK, 0); /* disable all mmc interrupt first */
 
 	for (i = 0; i < host->num_slots; i++) {
-		dev_dbg(&host->dev, "remove slot %d\n", i);
+		dev_dbg(host->dev, "remove slot %d\n", i);
 		if (host->slot[i])
 			dw_mci_cleanup_slot(host->slot[i], i);
 	}
@@ -2118,7 +2118,7 @@ void dw_mci_remove(struct dw_mci *host)
 
 	free_irq(host->irq, host);
 	destroy_workqueue(host->card_workqueue);
-	dma_free_coherent(&host->dev, PAGE_SIZE, host->sg_cpu, host->sg_dma);
+	dma_free_coherent(host->dev, PAGE_SIZE, host->sg_cpu, host->sg_dma);
 
 	if (host->use_dma && host->dma_ops->exit)
 		host->dma_ops->exit(host);
@@ -2173,7 +2173,7 @@ int dw_mci_resume(struct dw_mci *host)
 	if (host->dma_ops->init)
 		host->dma_ops->init(host);
 
-	if (!mci_wait_reset(&host->dev, host)) {
+	if (!mci_wait_reset(host->dev, host)) {
 		ret = -ENODEV;
 		return ret;
 	}
diff --git a/include/linux/mmc/dw_mmc.h b/include/linux/mmc/dw_mmc.h
index 7a7ebd3..a37a573 100644
--- a/include/linux/mmc/dw_mmc.h
+++ b/include/linux/mmc/dw_mmc.h
@@ -156,7 +156,7 @@ struct dw_mci {
 	u32			fifoth_val;
 	u16			verid;
 	u16			data_offset;
-	struct device		dev;
+	struct device		*dev;
 	struct dw_mci_board	*pdata;
 	struct dw_mci_slot	*slot[MAX_MCI_SLOTS];
 
-- 
1.6.6.rc2

