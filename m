Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932516Ab0HJVqO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 17:46:14 -0400
Received: from mail.df.lth.se ([194.47.250.12]:34504 "EHLO df.lth.se"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754822Ab0HJVqL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 17:46:11 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org
Cc: Sascha Hauer <s.hauer@pengutronix.de>,
        Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH] DMAENGINE: add a slave buffer prep call
Date: Tue, 10 Aug 2010 23:46:06 +0200
Message-Id: <1281476766-7066-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.6.2.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This makes it possible for engines to implement slave transfers
to be done to/from a simple kmalloc():ed memory buffer and not
just from scatterlists.

Cc: Sascha Hauer <s.hauer@pengutronix.de>
Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
Sacha: this has similarities to you i.MX setup_single() operation,
if you think this suits your needs for i.MX consider ACKing this
patch pls. (Circular jobs would have a similar signature I believe.)

I will likely implement this API on COH901318 and DMA40 if it is
accepted.
---
 arch/arm/mach-at91/at91sam9g45_devices.c |    2 +-
 drivers/dma/at_hdmac.c                   |    8 ++++----
 drivers/dma/coh901318.c                  |    2 +-
 drivers/dma/dmaengine.c                  |    9 ++++++---
 drivers/dma/dw_dmac.c                    |    2 +-
 drivers/dma/fsldma.c                     |   11 ++++++-----
 drivers/dma/ipu/ipu_idmac.c              |    4 ++--
 drivers/dma/pl330.c                      |    2 +-
 drivers/dma/shdma.c                      |    4 ++--
 drivers/dma/ste_dma40.c                  |    9 +++++----
 drivers/dma/timb_dma.c                   |    2 +-
 drivers/dma/txx9dmac.c                   |    5 +++--
 drivers/media/video/mx3_camera.c         |    2 +-
 drivers/mmc/host/atmel-mci.c             |    2 +-
 drivers/mmc/host/tmio_mmc.c              |    2 +-
 drivers/serial/sh-sci.c                  |    2 +-
 drivers/video/mx3fb.c                    |    2 +-
 include/linux/dmaengine.h                |   14 +++++++++++---
 sound/atmel/abdac.c                      |    2 +-
 sound/atmel/ac97c.c                      |    4 ++--
 sound/soc/sh/siu_pcm.c                   |    2 +-
 sound/soc/txx9/txx9aclc.c                |    2 +-
 22 files changed, 54 insertions(+), 40 deletions(-)

diff --git a/arch/arm/mach-at91/at91sam9g45_devices.c b/arch/arm/mach-at91/at91sam9g45_devices.c
index 809114d..a005bc9 100644
--- a/arch/arm/mach-at91/at91sam9g45_devices.c
+++ b/arch/arm/mach-at91/at91sam9g45_devices.c
@@ -68,7 +68,7 @@ static struct platform_device at_hdmac_device = {
 void __init at91_add_device_hdmac(void)
 {
 	dma_cap_set(DMA_MEMCPY, atdma_pdata.cap_mask);
-	dma_cap_set(DMA_SLAVE, atdma_pdata.cap_mask);
+	dma_cap_set(DMA_SLAVE_SGLIST, atdma_pdata.cap_mask);
 	platform_device_register(&at_hdmac_device);
 }
 #else
diff --git a/drivers/dma/at_hdmac.c b/drivers/dma/at_hdmac.c
index a0f3e6a..0df7201 100644
--- a/drivers/dma/at_hdmac.c
+++ b/drivers/dma/at_hdmac.c
@@ -615,7 +615,7 @@ err_desc_get:
 
 
 /**
- * atc_prep_slave_sg - prepare descriptors for a DMA_SLAVE transaction
+ * atc_prep_slave_sg - prepare descriptors for a DMA_SLAVE_SGLIST transaction
  * @chan: DMA channel
  * @sgl: scatterlist to transfer to/from
  * @sg_len: number of entries in @scatterlist
@@ -1093,7 +1093,7 @@ static int __init at_dma_probe(struct platform_device *pdev)
 	if (dma_has_cap(DMA_MEMCPY, atdma->dma_common.cap_mask))
 		atdma->dma_common.device_prep_dma_memcpy = atc_prep_dma_memcpy;
 
-	if (dma_has_cap(DMA_SLAVE, atdma->dma_common.cap_mask)) {
+	if (dma_has_cap(DMA_SLAVE_SGLIST, atdma->dma_common.cap_mask)) {
 		atdma->dma_common.device_prep_slave_sg = atc_prep_slave_sg;
 		atdma->dma_common.device_control = atc_control;
 	}
@@ -1102,8 +1102,8 @@ static int __init at_dma_probe(struct platform_device *pdev)
 
 	dev_info(&pdev->dev, "Atmel AHB DMA Controller ( %s%s), %d channels\n",
 	  dma_has_cap(DMA_MEMCPY, atdma->dma_common.cap_mask) ? "cpy " : "",
-	  dma_has_cap(DMA_SLAVE, atdma->dma_common.cap_mask)  ? "slave " : "",
-	  atdma->dma_common.chancnt);
+	  dma_has_cap(DMA_SLAVE_SGLIST, atdma->dma_common.cap_mask) ?
+		"slave " : "", atdma->dma_common.chancnt);
 
 	dma_async_device_register(&atdma->dma_common);
 
diff --git a/drivers/dma/coh901318.c b/drivers/dma/coh901318.c
index 557e227..4bdd155 100644
--- a/drivers/dma/coh901318.c
+++ b/drivers/dma/coh901318.c
@@ -1518,7 +1518,7 @@ static int __init coh901318_probe(struct platform_device *pdev)
 			    base);
 
 	dma_cap_zero(base->dma_slave.cap_mask);
-	dma_cap_set(DMA_SLAVE, base->dma_slave.cap_mask);
+	dma_cap_set(DMA_SLAVE_SGLIST, base->dma_slave.cap_mask);
 
 	base->dma_slave.device_alloc_chan_resources = coh901318_alloc_chan_resources;
 	base->dma_slave.device_free_chan_resources = coh901318_free_chan_resources;
diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
index 9d31d5e..0d37c76 100644
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -300,7 +300,6 @@ static int __init dma_channel_table_init(void)
 	 */
 	clear_bit(DMA_INTERRUPT, dma_cap_mask_all.bits);
 	clear_bit(DMA_PRIVATE, dma_cap_mask_all.bits);
-	clear_bit(DMA_SLAVE, dma_cap_mask_all.bits);
 
 	for_each_dma_cap_mask(cap, dma_cap_mask_all) {
 		channel_table[cap] = alloc_percpu(struct dma_chan_tbl_ent);
@@ -690,9 +689,13 @@ int dma_async_device_register(struct dma_device *device)
 		!device->device_prep_dma_memset);
 	BUG_ON(dma_has_cap(DMA_INTERRUPT, device->cap_mask) &&
 		!device->device_prep_dma_interrupt);
-	BUG_ON(dma_has_cap(DMA_SLAVE, device->cap_mask) &&
+	BUG_ON(dma_has_cap(DMA_SLAVE_SGLIST, device->cap_mask) &&
 		!device->device_prep_slave_sg);
-	BUG_ON(dma_has_cap(DMA_SLAVE, device->cap_mask) &&
+	BUG_ON(dma_has_cap(DMA_SLAVE_SGLIST, device->cap_mask) &&
+		!device->device_control);
+	BUG_ON(dma_has_cap(DMA_SLAVE_BUFFER, device->cap_mask) &&
+		!device->device_prep_slave_buffer);
+	BUG_ON(dma_has_cap(DMA_SLAVE_BUFFER, device->cap_mask) &&
 		!device->device_control);
 
 	BUG_ON(!device->device_alloc_chan_resources);
diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index a3991ab..e38ea35 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -1334,7 +1334,7 @@ static int __init dw_probe(struct platform_device *pdev)
 	channel_clear_bit(dw, MASK.ERROR, dw->all_chan_mask);
 
 	dma_cap_set(DMA_MEMCPY, dw->dma.cap_mask);
-	dma_cap_set(DMA_SLAVE, dw->dma.cap_mask);
+	dma_cap_set(DMA_SLAVE_SGLIST, dw->dma.cap_mask);
 	dw->dma.dev = &pdev->dev;
 	dw->dma.device_alloc_chan_resources = dwc_alloc_chan_resources;
 	dw->dma.device_free_chan_resources = dwc_free_chan_resources;
diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
index cea08be..95b012a 100644
--- a/drivers/dma/fsldma.c
+++ b/drivers/dma/fsldma.c
@@ -584,16 +584,17 @@ fail:
 }
 
 /**
- * fsl_dma_prep_slave_sg - prepare descriptors for a DMA_SLAVE transaction
+ * fsl_dma_prep_slave_sg - prepare descriptors for a DMA_SLAVE_SGLIST
+ * transaction
  * @chan: DMA channel
  * @sgl: scatterlist to transfer to/from
  * @sg_len: number of entries in @scatterlist
  * @direction: DMA direction
  * @flags: DMAEngine flags
  *
- * Prepare a set of descriptors for a DMA_SLAVE transaction. Following the
- * DMA_SLAVE API, this gets the device-specific information from the
- * chan->private variable.
+ * Prepare a set of descriptors for a DMA_SLAVE_SGLIST transaction.
+ * Following the DMA_SLAVE API, this gets the device-specific information
+ * from the chan->private variable.
  */
 static struct dma_async_tx_descriptor *fsl_dma_prep_slave_sg(
 	struct dma_chan *dchan, struct scatterlist *sgl, unsigned int sg_len,
@@ -1327,7 +1328,7 @@ static int __devinit fsldma_of_probe(struct platform_device *op,
 
 	dma_cap_set(DMA_MEMCPY, fdev->common.cap_mask);
 	dma_cap_set(DMA_INTERRUPT, fdev->common.cap_mask);
-	dma_cap_set(DMA_SLAVE, fdev->common.cap_mask);
+	dma_cap_set(DMA_SLAVE_SGLIST, fdev->common.cap_mask);
 	fdev->common.device_alloc_chan_resources = fsl_dma_alloc_chan_resources;
 	fdev->common.device_free_chan_resources = fsl_dma_free_chan_resources;
 	fdev->common.device_prep_dma_interrupt = fsl_dma_prep_interrupt;
diff --git a/drivers/dma/ipu/ipu_idmac.c b/drivers/dma/ipu/ipu_idmac.c
index cb26ee9..27d8226 100644
--- a/drivers/dma/ipu/ipu_idmac.c
+++ b/drivers/dma/ipu/ipu_idmac.c
@@ -1665,7 +1665,7 @@ static int __init ipu_idmac_init(struct ipu *ipu)
 	struct dma_device *dma = &idmac->dma;
 	int i;
 
-	dma_cap_set(DMA_SLAVE, dma->cap_mask);
+	dma_cap_set(DMA_SLAVE_SGLIST, dma->cap_mask);
 	dma_cap_set(DMA_PRIVATE, dma->cap_mask);
 
 	/* Compulsory common fields */
@@ -1675,7 +1675,7 @@ static int __init ipu_idmac_init(struct ipu *ipu)
 	dma->device_tx_status			= idmac_tx_status;
 	dma->device_issue_pending		= idmac_issue_pending;
 
-	/* Compulsory for DMA_SLAVE fields */
+	/* Compulsory for DMA_SLAVE_SGLIST fields */
 	dma->device_prep_slave_sg		= idmac_prep_slave_sg;
 	dma->device_control			= idmac_control;
 
diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
index 7c50f6d..3974357 100644
--- a/drivers/dma/pl330.c
+++ b/drivers/dma/pl330.c
@@ -727,7 +727,7 @@ pl330_probe(struct amba_device *adev, struct amba_id *id)
 			break;
 		case MEMTODEV:
 		case DEVTOMEM:
-			dma_cap_set(DMA_SLAVE, pd->cap_mask);
+			dma_cap_set(DMA_SLAVE_SGLIST, pd->cap_mask);
 			break;
 		default:
 			dev_err(&adev->dev, "DEVTODEV Not Supported\n");
diff --git a/drivers/dma/shdma.c b/drivers/dma/shdma.c
index fb64cf3..5b09f81 100644
--- a/drivers/dma/shdma.c
+++ b/drivers/dma/shdma.c
@@ -1040,7 +1040,7 @@ static int __init sh_dmae_probe(struct platform_device *pdev)
 
 	dma_cap_set(DMA_MEMCPY, shdev->common.cap_mask);
 	if (dmars)
-		dma_cap_set(DMA_SLAVE, shdev->common.cap_mask);
+		dma_cap_set(DMA_SLAVE_SGLIST, shdev->common.cap_mask);
 
 	shdev->common.device_alloc_chan_resources
 		= sh_dmae_alloc_chan_resources;
@@ -1049,7 +1049,7 @@ static int __init sh_dmae_probe(struct platform_device *pdev)
 	shdev->common.device_tx_status = sh_dmae_tx_status;
 	shdev->common.device_issue_pending = sh_dmae_memcpy_issue_pending;
 
-	/* Compulsory for DMA_SLAVE fields */
+	/* Compulsory for DMA_SLAVE_SGLIST fields */
 	shdev->common.device_prep_slave_sg = sh_dmae_prep_slave_sg;
 	shdev->common.device_control = sh_dmae_control;
 
diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 17e2600..9c6cde2 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -1213,14 +1213,15 @@ static int d40_config_memcpy(struct d40_chan *d40c)
 {
 	dma_cap_mask_t cap = d40c->chan.device->cap_mask;
 
-	if (dma_has_cap(DMA_MEMCPY, cap) && !dma_has_cap(DMA_SLAVE, cap)) {
+	if (dma_has_cap(DMA_MEMCPY, cap) &&
+		!dma_has_cap(DMA_SLAVE_SGLIST, cap)) {
 		d40c->dma_cfg = *d40c->base->plat_data->memcpy_conf_log;
 		d40c->dma_cfg.src_dev_type = STEDMA40_DEV_SRC_MEMORY;
 		d40c->dma_cfg.dst_dev_type = d40c->base->plat_data->
 			memcpy[d40c->chan.chan_id];
 
 	} else if (dma_has_cap(DMA_MEMCPY, cap) &&
-		   dma_has_cap(DMA_SLAVE, cap)) {
+		   dma_has_cap(DMA_SLAVE_SGLIST, cap)) {
 		d40c->dma_cfg = *d40c->base->plat_data->memcpy_conf_phy;
 	} else {
 		dev_err(&d40c->chan.dev->device, "[%s] No memcpy\n",
@@ -2276,7 +2277,7 @@ static int __init d40_dmaengine_init(struct d40_base *base,
 		      0, base->num_log_chans);
 
 	dma_cap_zero(base->dma_slave.cap_mask);
-	dma_cap_set(DMA_SLAVE, base->dma_slave.cap_mask);
+	dma_cap_set(DMA_SLAVE_SGLIST, base->dma_slave.cap_mask);
 
 	base->dma_slave.device_alloc_chan_resources = d40_alloc_chan_resources;
 	base->dma_slave.device_free_chan_resources = d40_free_chan_resources;
@@ -2329,7 +2330,7 @@ static int __init d40_dmaengine_init(struct d40_base *base,
 		      0, num_reserved_chans);
 
 	dma_cap_zero(base->dma_both.cap_mask);
-	dma_cap_set(DMA_SLAVE, base->dma_both.cap_mask);
+	dma_cap_set(DMA_SLAVE_SGLIST, base->dma_both.cap_mask);
 	dma_cap_set(DMA_MEMCPY, base->dma_both.cap_mask);
 
 	base->dma_both.device_alloc_chan_resources = d40_alloc_chan_resources;
diff --git a/drivers/dma/timb_dma.c b/drivers/dma/timb_dma.c
index 2ec1ed5..75149883 100644
--- a/drivers/dma/timb_dma.c
+++ b/drivers/dma/timb_dma.c
@@ -744,7 +744,7 @@ static int __devinit td_probe(struct platform_device *pdev)
 	td->dma.device_tx_status		= td_tx_status;
 	td->dma.device_issue_pending		= td_issue_pending;
 
-	dma_cap_set(DMA_SLAVE, td->dma.cap_mask);
+	dma_cap_set(DMA_SLAVE_SGLIST, td->dma.cap_mask);
 	dma_cap_set(DMA_PRIVATE, td->dma.cap_mask);
 	td->dma.device_prep_slave_sg = td_prep_slave_sg;
 	td->dma.device_control = td_control;
diff --git a/drivers/dma/txx9dmac.c b/drivers/dma/txx9dmac.c
index cbd83e36..c2d1343 100644
--- a/drivers/dma/txx9dmac.c
+++ b/drivers/dma/txx9dmac.c
@@ -1164,7 +1164,7 @@ static int __init txx9dmac_chan_probe(struct platform_device *pdev)
 		dma_cap_set(DMA_MEMCPY, dc->dma.cap_mask);
 	} else {
 		dc->dma.device_prep_slave_sg = txx9dmac_prep_slave_sg;
-		dma_cap_set(DMA_SLAVE, dc->dma.cap_mask);
+		dma_cap_set(DMA_SLAVE_SGLIST, dc->dma.cap_mask);
 		dma_cap_set(DMA_PRIVATE, dc->dma.cap_mask);
 	}
 
@@ -1208,7 +1208,8 @@ static int __init txx9dmac_chan_probe(struct platform_device *pdev)
 	dev_dbg(&pdev->dev, "TXx9 DMA Channel (dma%d%s%s)\n",
 		dc->dma.dev_id,
 		dma_has_cap(DMA_MEMCPY, dc->dma.cap_mask) ? " memcpy" : "",
-		dma_has_cap(DMA_SLAVE, dc->dma.cap_mask) ? " slave" : "");
+		dma_has_cap(DMA_SLAVE_SGLIST, dc->dma.cap_mask) ?
+		" slave" : "");
 
 	return 0;
 }
diff --git a/drivers/media/video/mx3_camera.c b/drivers/media/video/mx3_camera.c
index a9be14c..fd6f735 100644
--- a/drivers/media/video/mx3_camera.c
+++ b/drivers/media/video/mx3_camera.c
@@ -780,7 +780,7 @@ static int acquire_dma_channel(struct mx3_camera_dev *mx3_cam)
 	}
 
 	dma_cap_zero(mask);
-	dma_cap_set(DMA_SLAVE, mask);
+	dma_cap_set(DMA_SLAVE_SGLIST, mask);
 	dma_cap_set(DMA_PRIVATE, mask);
 	chan = dma_request_channel(mask, chan_filter, &rq);
 	if (!chan)
diff --git a/drivers/mmc/host/atmel-mci.c b/drivers/mmc/host/atmel-mci.c
index 95ef864..fae4b39 100644
--- a/drivers/mmc/host/atmel-mci.c
+++ b/drivers/mmc/host/atmel-mci.c
@@ -1728,7 +1728,7 @@ static void atmci_configure_dma(struct atmel_mci *host)
 
 		/* Try to grab a DMA channel */
 		dma_cap_zero(mask);
-		dma_cap_set(DMA_SLAVE, mask);
+		dma_cap_set(DMA_SLAVE_SGLIST, mask);
 		host->dma.chan =
 			dma_request_channel(mask, filter, pdata->dma_slave);
 	}
diff --git a/drivers/mmc/host/tmio_mmc.c b/drivers/mmc/host/tmio_mmc.c
index ee7d0a5..905ffb2 100644
--- a/drivers/mmc/host/tmio_mmc.c
+++ b/drivers/mmc/host/tmio_mmc.c
@@ -591,7 +591,7 @@ static void tmio_mmc_request_dma(struct tmio_mmc_host *host,
 		dma_cap_mask_t mask;
 
 		dma_cap_zero(mask);
-		dma_cap_set(DMA_SLAVE, mask);
+		dma_cap_set(DMA_SLAVE_SGLIST, mask);
 
 		host->chan_tx = dma_request_channel(mask, tmio_mmc_filter,
 						    pdata->dma->chan_priv_tx);
diff --git a/drivers/serial/sh-sci.c b/drivers/serial/sh-sci.c
index c291b3a..0efab71 100644
--- a/drivers/serial/sh-sci.c
+++ b/drivers/serial/sh-sci.c
@@ -1316,7 +1316,7 @@ static void sci_request_dma(struct uart_port *port)
 		return;
 
 	dma_cap_zero(mask);
-	dma_cap_set(DMA_SLAVE, mask);
+	dma_cap_set(DMA_SLAVE_SGLIST, mask);
 
 	param = &s->param_tx;
 
diff --git a/drivers/video/mx3fb.c b/drivers/video/mx3fb.c
index 7cfc170..ced7d86 100644
--- a/drivers/video/mx3fb.c
+++ b/drivers/video/mx3fb.c
@@ -1482,7 +1482,7 @@ static int mx3fb_probe(struct platform_device *pdev)
 	rq.mx3fb = mx3fb;
 
 	dma_cap_zero(mask);
-	dma_cap_set(DMA_SLAVE, mask);
+	dma_cap_set(DMA_SLAVE_SGLIST, mask);
 	dma_cap_set(DMA_PRIVATE, mask);
 	rq.id = IDMAC_SDC_0;
 	chan = dma_request_channel(mask, chan_filter, &rq);
diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index c61d4ca..5811d2b 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -66,11 +66,12 @@ enum dma_transaction_type {
 	DMA_INTERRUPT,
 	DMA_PRIVATE,
 	DMA_ASYNC_TX,
-	DMA_SLAVE,
+	DMA_SLAVE_SGLIST,
+	DMA_SLAVE_BUFFER,
 };
 
 /* last transaction type for creation of the capabilities mask */
-#define DMA_TX_TYPE_END (DMA_SLAVE + 1)
+#define DMA_TX_TYPE_END (DMA_SLAVE_BUFFER + 1)
 
 
 /**
@@ -421,7 +422,10 @@ struct dma_tx_state {
  * @device_prep_dma_pq_val: prepares a pqzero_sum operation
  * @device_prep_dma_memset: prepares a memset operation
  * @device_prep_dma_interrupt: prepares an end of chain interrupt operation
- * @device_prep_slave_sg: prepares a slave dma operation
+ * @device_prep_slave_buffer: prepares a slave DMA operation to/from a
+ *	buffer
+ * @device_prep_slave_sg: prepares a slave dma operation to/from a
+ *	scatterlist
  * @device_control: manipulate all pending operations on a channel, returns
  *	zero or error code
  * @device_tx_status: poll for transaction completion, the optional
@@ -474,6 +478,10 @@ struct dma_device {
 	struct dma_async_tx_descriptor *(*device_prep_dma_interrupt)(
 		struct dma_chan *chan, unsigned long flags);
 
+	struct dma_async_tx_descriptor *(*device_prep_slave_buffer)(
+		struct dma_chan *chan, char *buffer,
+		enum dma_data_direction direction,
+		unsigned long flags);
 	struct dma_async_tx_descriptor *(*device_prep_slave_sg)(
 		struct dma_chan *chan, struct scatterlist *sgl,
 		unsigned int sg_len, enum dma_data_direction direction,
diff --git a/sound/atmel/abdac.c b/sound/atmel/abdac.c
index f2f41c8..642bdea 100644
--- a/sound/atmel/abdac.c
+++ b/sound/atmel/abdac.c
@@ -473,7 +473,7 @@ static int __devinit atmel_abdac_probe(struct platform_device *pdev)
 		dws->tx_reg = regs->start + DAC_DATA;
 
 		dma_cap_zero(mask);
-		dma_cap_set(DMA_SLAVE, mask);
+		dma_cap_set(DMA_SLAVE_SGLIST, mask);
 
 		dac->dma.chan = dma_request_channel(mask, filter, dws);
 	}
diff --git a/sound/atmel/ac97c.c b/sound/atmel/ac97c.c
index 10c3a87..1f0d328 100644
--- a/sound/atmel/ac97c.c
+++ b/sound/atmel/ac97c.c
@@ -1013,7 +1013,7 @@ static int __devinit atmel_ac97c_probe(struct platform_device *pdev)
 			dws->rx_reg = regs->start + AC97C_CARHR + 2;
 
 			dma_cap_zero(mask);
-			dma_cap_set(DMA_SLAVE, mask);
+			dma_cap_set(DMA_SLAVE_SGLIST, mask);
 
 			chip->dma.rx_chan = dma_request_channel(mask, filter,
 								dws);
@@ -1030,7 +1030,7 @@ static int __devinit atmel_ac97c_probe(struct platform_device *pdev)
 			dws->tx_reg = regs->start + AC97C_CATHR + 2;
 
 			dma_cap_zero(mask);
-			dma_cap_set(DMA_SLAVE, mask);
+			dma_cap_set(DMA_SLAVE_SGLIST, mask);
 
 			chip->dma.tx_chan = dma_request_channel(mask, filter,
 								dws);
diff --git a/sound/soc/sh/siu_pcm.c b/sound/soc/sh/siu_pcm.c
index b0ccd0b..510d177 100644
--- a/sound/soc/sh/siu_pcm.c
+++ b/sound/soc/sh/siu_pcm.c
@@ -352,7 +352,7 @@ static int siu_pcm_open(struct snd_pcm_substream *ss)
 	struct sh_dmae_slave *param;
 
 	dma_cap_zero(mask);
-	dma_cap_set(DMA_SLAVE, mask);
+	dma_cap_set(DMA_SLAVE_SGLIST, mask);
 
 	dev_dbg(dev, "%s, port=%d@%p\n", __func__, port, port_info);
 
diff --git a/sound/soc/txx9/txx9aclc.c b/sound/soc/txx9/txx9aclc.c
index 0e345230..11c9525 100644
--- a/sound/soc/txx9/txx9aclc.c
+++ b/sound/soc/txx9/txx9aclc.c
@@ -331,7 +331,7 @@ static int txx9aclc_dma_init(struct txx9aclc_soc_device *dev,
 
 	/* Try to grab a DMA channel */
 	dma_cap_zero(mask);
-	dma_cap_set(DMA_SLAVE, mask);
+	dma_cap_set(DMA_SLAVE_SGLIST, mask);
 	dmadata->dma_chan = dma_request_channel(mask, filter, dmadata);
 	if (!dmadata->dma_chan) {
 		dev_err(dev->soc_dev.dev,
-- 
1.7.2

