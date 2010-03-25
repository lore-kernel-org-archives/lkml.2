Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753251Ab0CYPGN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 11:06:13 -0400
Received: from mail.df.lth.se ([194.47.250.12]:41430 "EHLO df.lth.se"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751604Ab0CYPGK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 11:06:10 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Dan Williams <dan.j.williams@intel.com>,
       Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
       linux-kernel@vger.kernel.org
Cc: Linus Walleij <linus.walleij@stericsson.com>,
       Maciej Sosnowski <maciej.sosnowski@intel.com>,
       Nicolas Ferre <nicolas.ferre@atmel.com>, Pavel Machek <pavel@ucw.cz>,
       Li Yang <leoli@freescale.com>,
       Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
       Paul Mundt <lethal@linux-sh.org>, Ralf Baechle <ralf@linux-mips.org>,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>,
       Magnus Damm <damm@opensource.se>, Liam Girdwood <lrg@slimlogic.co.uk>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 1/2] DMAENGINE: generic slave control
Date: Thu, 25 Mar 2010 16:02:48 +0100
Message-Id: <1269529368-16645-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.6.2.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert the device_terminate_all() operation on the
DMA engine to a generic device_control() operation
which can now optionally support also pausing and
resuming DMA on a certain channel. Implemented for the
COH 901 318 DMAC as an example.

Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
Cc: Maciej Sosnowski <maciej.sosnowski@intel.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Li Yang <leoli@freescale.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Cc: Magnus Damm <damm@opensource.se>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 arch/arm/mach-u300/include/mach/coh901318.h |   14 ---------
 drivers/dma/at_hdmac.c                      |   10 +++++-
 drivers/dma/coh901318.c                     |   42 ++++++++++++++++++---------
 drivers/dma/dmaengine.c                     |    2 +-
 drivers/dma/dw_dmac.c                       |   10 +++++-
 drivers/dma/fsldma.c                        |   11 ++++++-
 drivers/dma/ipu/ipu_idmac.c                 |   19 ++++++++----
 drivers/dma/shdma.c                         |   10 +++++-
 drivers/dma/txx9dmac.c                      |   10 +++++-
 drivers/mmc/host/atmel-mci.c                |    2 +-
 drivers/serial/sh-sci.c                     |    2 +-
 drivers/video/mx3fb.c                       |    3 +-
 include/linux/dmaengine.h                   |   18 ++++++++++-
 sound/soc/txx9/txx9aclc.c                   |    6 ++--
 14 files changed, 106 insertions(+), 53 deletions(-)

diff --git a/arch/arm/mach-u300/include/mach/coh901318.h b/arch/arm/mach-u300/include/mach/coh901318.h
index b8155b4..43ec040 100644
--- a/arch/arm/mach-u300/include/mach/coh901318.h
+++ b/arch/arm/mach-u300/include/mach/coh901318.h
@@ -110,20 +110,6 @@ struct coh901318_platform {
 u32 coh901318_get_bytes_left(struct dma_chan *chan);
 
 /**
- * coh901318_stop() - Stops dma transfer
- * @chan: dma channel handle
- * return 0 on success otherwise negative value
- */
-void coh901318_stop(struct dma_chan *chan);
-
-/**
- * coh901318_continue() - Resumes a stopped dma transfer
- * @chan: dma channel handle
- * return 0 on success otherwise negative value
- */
-void coh901318_continue(struct dma_chan *chan);
-
-/**
  * coh901318_filter_id() - DMA channel filter function
  * @chan: dma channel handle
  * @chan_id: id of dma channel to be filter out
diff --git a/drivers/dma/at_hdmac.c b/drivers/dma/at_hdmac.c
index efc1a61..3fa3658 100644
--- a/drivers/dma/at_hdmac.c
+++ b/drivers/dma/at_hdmac.c
@@ -759,13 +759,17 @@ err_desc_get:
 	return NULL;
 }
 
-static void atc_terminate_all(struct dma_chan *chan)
+static int atc_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd)
 {
 	struct at_dma_chan	*atchan = to_at_dma_chan(chan);
 	struct at_dma		*atdma = to_at_dma(chan->device);
 	struct at_desc		*desc, *_desc;
 	LIST_HEAD(list);
 
+	/* Only supports DMA_TERMINATE_ALL */
+	if (cmd != DMA_TERMINATE_ALL)
+		return -EINVAL;
+
 	/*
 	 * This is only called when something went wrong elsewhere, so
 	 * we don't really care about the data. Just disable the
@@ -789,6 +793,8 @@ static void atc_terminate_all(struct dma_chan *chan)
 	/* Flush all pending and queued descriptors */
 	list_for_each_entry_safe(desc, _desc, &list, desc_node)
 		atc_chain_complete(atchan, desc);
+
+	return 0;
 }
 
 /**
@@ -1091,7 +1097,7 @@ static int __init at_dma_probe(struct platform_device *pdev)
 
 	if (dma_has_cap(DMA_SLAVE, atdma->dma_common.cap_mask)) {
 		atdma->dma_common.device_prep_slave_sg = atc_prep_slave_sg;
-		atdma->dma_common.device_terminate_all = atc_terminate_all;
+		atdma->dma_common.device_control = atc_control;
 	}
 
 	dma_writel(atdma, EN, AT_DMA_ENABLE);
diff --git a/drivers/dma/coh901318.c b/drivers/dma/coh901318.c
index f636c4a..2c65cff 100644
--- a/drivers/dma/coh901318.c
+++ b/drivers/dma/coh901318.c
@@ -506,10 +506,11 @@ u32 coh901318_get_bytes_left(struct dma_chan *chan)
 EXPORT_SYMBOL(coh901318_get_bytes_left);
 
 
-/* Stops a transfer without losing data. Enables power save.
-   Use this function in conjunction with coh901318_continue(..)
-*/
-void coh901318_stop(struct dma_chan *chan)
+/*
+ * Pauses a transfer without losing data. Enables power save.
+ * Use this function in conjunction with coh901318_resume.
+ */
+static void coh901318_pause(struct dma_chan *chan)
 {
 	u32 val;
 	unsigned long flags;
@@ -550,12 +551,11 @@ void coh901318_stop(struct dma_chan *chan)
 
 	spin_unlock_irqrestore(&cohc->lock, flags);
 }
-EXPORT_SYMBOL(coh901318_stop);
 
-/* Continues a transfer that has been stopped via 300_dma_stop(..).
+/* Resumes a transfer that has been stopped via 300_dma_stop(..).
    Power save is handled.
 */
-void coh901318_continue(struct dma_chan *chan)
+static void coh901318_resume(struct dma_chan *chan)
 {
 	u32 val;
 	unsigned long flags;
@@ -581,7 +581,6 @@ void coh901318_continue(struct dma_chan *chan)
 
 	spin_unlock_irqrestore(&cohc->lock, flags);
 }
-EXPORT_SYMBOL(coh901318_continue);
 
 bool coh901318_filter_id(struct dma_chan *chan, void *chan_id)
 {
@@ -945,7 +944,7 @@ coh901318_free_chan_resources(struct dma_chan *chan)
 
 	spin_unlock_irqrestore(&cohc->lock, flags);
 
-	chan->device->device_terminate_all(chan);
+	chan->device->device_control(chan, DMA_TERMINATE_ALL);
 }
 
 
@@ -1179,16 +1178,29 @@ coh901318_issue_pending(struct dma_chan *chan)
 	spin_unlock_irqrestore(&cohc->lock, flags);
 }
 
-static void
-coh901318_terminate_all(struct dma_chan *chan)
+static int
+coh901318_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd)
 {
 	unsigned long flags;
 	struct coh901318_chan *cohc = to_coh901318_chan(chan);
 	struct coh901318_desc *cohd;
 	void __iomem *virtbase = cohc->base->virtbase;
 
-	coh901318_stop(chan);
+	if (cmd == DMA_PAUSE) {
+		coh901318_pause(chan);
+		return 0;
+	}
+
+	if (cmd == DMA_RESUME) {
+		coh901318_resume(chan);
+		return 0;
+	}
+
+	if (cmd != DMA_TERMINATE_ALL)
+		return -EINVAL;
 
+	/* The remainder of this function terminates the transfer */
+	coh901318_pause(chan);
 	spin_lock_irqsave(&cohc->lock, flags);
 
 	/* Clear any pending BE or TC interrupt */
@@ -1227,6 +1239,8 @@ coh901318_terminate_all(struct dma_chan *chan)
 	cohc->busy = 0;
 
 	spin_unlock_irqrestore(&cohc->lock, flags);
+
+	return 0;
 }
 void coh901318_base_init(struct dma_device *dma, const int *pick_chans,
 			 struct coh901318_base *base)
@@ -1344,7 +1358,7 @@ static int __init coh901318_probe(struct platform_device *pdev)
 	base->dma_slave.device_prep_slave_sg = coh901318_prep_slave_sg;
 	base->dma_slave.device_is_tx_complete = coh901318_is_tx_complete;
 	base->dma_slave.device_issue_pending = coh901318_issue_pending;
-	base->dma_slave.device_terminate_all = coh901318_terminate_all;
+	base->dma_slave.device_control = coh901318_control;
 	base->dma_slave.dev = &pdev->dev;
 
 	err = dma_async_device_register(&base->dma_slave);
@@ -1364,7 +1378,7 @@ static int __init coh901318_probe(struct platform_device *pdev)
 	base->dma_memcpy.device_prep_dma_memcpy = coh901318_prep_memcpy;
 	base->dma_memcpy.device_is_tx_complete = coh901318_is_tx_complete;
 	base->dma_memcpy.device_issue_pending = coh901318_issue_pending;
-	base->dma_memcpy.device_terminate_all = coh901318_terminate_all;
+	base->dma_memcpy.device_control = coh901318_control;
 	base->dma_memcpy.dev = &pdev->dev;
 	/*
 	 * This controller can only access address at even 32bit boundaries,
diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
index 87399ca..ffc4ee9 100644
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -694,7 +694,7 @@ int dma_async_device_register(struct dma_device *device)
 	BUG_ON(dma_has_cap(DMA_SLAVE, device->cap_mask) &&
 		!device->device_prep_slave_sg);
 	BUG_ON(dma_has_cap(DMA_SLAVE, device->cap_mask) &&
-		!device->device_terminate_all);
+		!device->device_control);
 
 	BUG_ON(!device->device_alloc_chan_resources);
 	BUG_ON(!device->device_free_chan_resources);
diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index d28369f..80ef61f 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -781,13 +781,17 @@ err_desc_get:
 	return NULL;
 }
 
-static void dwc_terminate_all(struct dma_chan *chan)
+static int dwc_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd)
 {
 	struct dw_dma_chan	*dwc = to_dw_dma_chan(chan);
 	struct dw_dma		*dw = to_dw_dma(chan->device);
 	struct dw_desc		*desc, *_desc;
 	LIST_HEAD(list);
 
+	/* Only supports DMA_TERMINATE_ALL */
+	if (cmd != DMA_TERMINATE_ALL)
+		return -EINVAL;
+
 	/*
 	 * This is only called when something went wrong elsewhere, so
 	 * we don't really care about the data. Just disable the
@@ -810,6 +814,8 @@ static void dwc_terminate_all(struct dma_chan *chan)
 	/* Flush all pending and queued descriptors */
 	list_for_each_entry_safe(desc, _desc, &list, desc_node)
 		dwc_descriptor_complete(dwc, desc);
+
+	return 0;
 }
 
 static enum dma_status
@@ -1338,7 +1344,7 @@ static int __init dw_probe(struct platform_device *pdev)
 	dw->dma.device_prep_dma_memcpy = dwc_prep_dma_memcpy;
 
 	dw->dma.device_prep_slave_sg = dwc_prep_slave_sg;
-	dw->dma.device_terminate_all = dwc_terminate_all;
+	dw->dma.device_control = dwc_control;
 
 	dw->dma.device_is_tx_complete = dwc_is_tx_complete;
 	dw->dma.device_issue_pending = dwc_issue_pending;
diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
index bbb4be5..5de0983 100644
--- a/drivers/dma/fsldma.c
+++ b/drivers/dma/fsldma.c
@@ -774,11 +774,16 @@ fail:
 	return NULL;
 }
 
-static void fsl_dma_device_terminate_all(struct dma_chan *dchan)
+static int fsl_dma_device_control(struct dma_chan *dchan,
+				  enum dma_ctrl_cmd cmd)
 {
 	struct fsldma_chan *chan;
 	unsigned long flags;
 
+	/* Only supports DMA_TERMINATE_ALL */
+	if (cmd != DMA_TERMINATE_ALL)
+		return -EINVAL;
+
 	if (!dchan)
 		return;
 
@@ -794,6 +799,8 @@ static void fsl_dma_device_terminate_all(struct dma_chan *dchan)
 	fsldma_free_desc_list(chan, &chan->ld_running);
 
 	spin_unlock_irqrestore(&chan->desc_lock, flags);
+
+	return 0;
 }
 
 /**
@@ -1332,7 +1339,7 @@ static int __devinit fsldma_of_probe(struct of_device *op,
 	fdev->common.device_is_tx_complete = fsl_dma_is_complete;
 	fdev->common.device_issue_pending = fsl_dma_memcpy_issue_pending;
 	fdev->common.device_prep_slave_sg = fsl_dma_prep_slave_sg;
-	fdev->common.device_terminate_all = fsl_dma_device_terminate_all;
+	fdev->common.device_control = fsl_dma_device_control;
 	fdev->common.dev = &op->dev;
 
 	dev_set_drvdata(&op->dev, fdev);
diff --git a/drivers/dma/ipu/ipu_idmac.c b/drivers/dma/ipu/ipu_idmac.c
index 2a44639..6b32878 100644
--- a/drivers/dma/ipu/ipu_idmac.c
+++ b/drivers/dma/ipu/ipu_idmac.c
@@ -1472,13 +1472,17 @@ static void idmac_issue_pending(struct dma_chan *chan)
 	 */
 }
 
-static void __idmac_terminate_all(struct dma_chan *chan)
+static int __idmac_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd)
 {
 	struct idmac_channel *ichan = to_idmac_chan(chan);
 	struct idmac *idmac = to_idmac(chan->device);
 	unsigned long flags;
 	int i;
 
+	/* Only supports DMA_TERMINATE_ALL */
+	if (cmd != DMA_TERMINATE_ALL)
+		return -EINVAL;
+
 	ipu_disable_channel(idmac, ichan,
 			    ichan->status >= IPU_CHANNEL_ENABLED);
 
@@ -1507,15 +1511,18 @@ static void __idmac_terminate_all(struct dma_chan *chan)
 	ichan->status = IPU_CHANNEL_INITIALIZED;
 }
 
-static void idmac_terminate_all(struct dma_chan *chan)
+static int idmac_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd)
 {
 	struct idmac_channel *ichan = to_idmac_chan(chan);
+	int ret;
 
 	mutex_lock(&ichan->chan_mutex);
 
-	__idmac_terminate_all(chan);
+	ret = __idmac_control(chan, cmd);
 
 	mutex_unlock(&ichan->chan_mutex);
+
+	return ret;
 }
 
 #ifdef DEBUG
@@ -1607,7 +1614,7 @@ static void idmac_free_chan_resources(struct dma_chan *chan)
 
 	mutex_lock(&ichan->chan_mutex);
 
-	__idmac_terminate_all(chan);
+	__idmac_control(chan, DMA_TERMINATE_ALL);
 
 	if (ichan->status > IPU_CHANNEL_FREE) {
 #ifdef DEBUG
@@ -1669,7 +1676,7 @@ static int __init ipu_idmac_init(struct ipu *ipu)
 
 	/* Compulsory for DMA_SLAVE fields */
 	dma->device_prep_slave_sg		= idmac_prep_slave_sg;
-	dma->device_terminate_all		= idmac_terminate_all;
+	dma->device_control			= idmac_control;
 
 	INIT_LIST_HEAD(&dma->channels);
 	for (i = 0; i < IPU_CHANNELS_NUM; i++) {
@@ -1703,7 +1710,7 @@ static void __exit ipu_idmac_exit(struct ipu *ipu)
 	for (i = 0; i < IPU_CHANNELS_NUM; i++) {
 		struct idmac_channel *ichan = ipu->channel + i;
 
-		idmac_terminate_all(&ichan->dma_chan);
+		idmac_control(&ichan->dma_chan, DMA_TERMINATE_ALL);
 		idmac_prep_slave_sg(&ichan->dma_chan, NULL, 0, DMA_NONE, 0);
 	}
 
diff --git a/drivers/dma/shdma.c b/drivers/dma/shdma.c
index 5d17e09..ce88131 100644
--- a/drivers/dma/shdma.c
+++ b/drivers/dma/shdma.c
@@ -580,10 +580,14 @@ static struct dma_async_tx_descriptor *sh_dmae_prep_slave_sg(
 			       direction, flags);
 }
 
-static void sh_dmae_terminate_all(struct dma_chan *chan)
+static int sh_dmae_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd)
 {
 	struct sh_dmae_chan *sh_chan = to_sh_chan(chan);
 
+	/* Only supports DMA_TERMINATE_ALL */
+	if (cmd != DMA_TERMINATE_ALL)
+		return -EINVAL;
+
 	if (!chan)
 		return;
 
@@ -601,6 +605,8 @@ static void sh_dmae_terminate_all(struct dma_chan *chan)
 	spin_unlock_bh(&sh_chan->desc_lock);
 
 	sh_dmae_chan_ld_cleanup(sh_chan, true);
+
+	return 0;
 }
 
 static dma_async_tx_callback __ld_cleanup(struct sh_dmae_chan *sh_chan, bool all)
@@ -1029,7 +1035,7 @@ static int __init sh_dmae_probe(struct platform_device *pdev)
 
 	/* Compulsory for DMA_SLAVE fields */
 	shdev->common.device_prep_slave_sg = sh_dmae_prep_slave_sg;
-	shdev->common.device_terminate_all = sh_dmae_terminate_all;
+	shdev->common.device_control = sh_dmae_control;
 
 	shdev->common.dev = &pdev->dev;
 	/* Default transfer size of 32 bytes requires 32-byte alignment */
diff --git a/drivers/dma/txx9dmac.c b/drivers/dma/txx9dmac.c
index 3ebc610..e528e15 100644
--- a/drivers/dma/txx9dmac.c
+++ b/drivers/dma/txx9dmac.c
@@ -938,12 +938,16 @@ txx9dmac_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
 	return &first->txd;
 }
 
-static void txx9dmac_terminate_all(struct dma_chan *chan)
+static int txx9dmac_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd)
 {
 	struct txx9dmac_chan *dc = to_txx9dmac_chan(chan);
 	struct txx9dmac_desc *desc, *_desc;
 	LIST_HEAD(list);
 
+	/* Only supports DMA_TERMINATE_ALL */
+	if (cmd != DMA_TERMINATE_ALL)
+		return -EINVAL;
+
 	dev_vdbg(chan2dev(chan), "terminate_all\n");
 	spin_lock_bh(&dc->lock);
 
@@ -958,6 +962,8 @@ static void txx9dmac_terminate_all(struct dma_chan *chan)
 	/* Flush all pending and queued descriptors */
 	list_for_each_entry_safe(desc, _desc, &list, desc_node)
 		txx9dmac_descriptor_complete(dc, desc);
+
+	return 0;
 }
 
 static enum dma_status
@@ -1153,7 +1159,7 @@ static int __init txx9dmac_chan_probe(struct platform_device *pdev)
 	dc->dma.dev = &pdev->dev;
 	dc->dma.device_alloc_chan_resources = txx9dmac_alloc_chan_resources;
 	dc->dma.device_free_chan_resources = txx9dmac_free_chan_resources;
-	dc->dma.device_terminate_all = txx9dmac_terminate_all;
+	dc->dma.device_control = txx9dmac_control;
 	dc->dma.device_is_tx_complete = txx9dmac_is_tx_complete;
 	dc->dma.device_issue_pending = txx9dmac_issue_pending;
 	if (pdata && pdata->memcpy_chan == ch) {
diff --git a/drivers/mmc/host/atmel-mci.c b/drivers/mmc/host/atmel-mci.c
index 8072128..ae6d24b 100644
--- a/drivers/mmc/host/atmel-mci.c
+++ b/drivers/mmc/host/atmel-mci.c
@@ -578,7 +578,7 @@ static void atmci_stop_dma(struct atmel_mci *host)
 	struct dma_chan *chan = host->data_chan;
 
 	if (chan) {
-		chan->device->device_terminate_all(chan);
+		chan->device->device_control(chan, DMA_TERMINATE_ALL);
 		atmci_dma_cleanup(host);
 	} else {
 		/* Data transfer was stopped by the interrupt handler */
diff --git a/drivers/serial/sh-sci.c b/drivers/serial/sh-sci.c
index 85dc236..84c68ed 100644
--- a/drivers/serial/sh-sci.c
+++ b/drivers/serial/sh-sci.c
@@ -1087,7 +1087,7 @@ static void work_fn_rx(struct work_struct *work)
 		unsigned long flags;
 		int count;
 
-		chan->device->device_terminate_all(chan);
+		chan->device->device_control(chan, DMA_TERMINATE_ALL);
 		dev_dbg(port->dev, "Read %u bytes with cookie %d\n",
 			sh_desc->partial, sh_desc->cookie);
 
diff --git a/drivers/video/mx3fb.c b/drivers/video/mx3fb.c
index 772ba3f..3aa50bc 100644
--- a/drivers/video/mx3fb.c
+++ b/drivers/video/mx3fb.c
@@ -387,7 +387,8 @@ static void sdc_disable_channel(struct mx3fb_info *mx3_fbi)
 
 	spin_unlock_irqrestore(&mx3fb->lock, flags);
 
-	mx3_fbi->txd->chan->device->device_terminate_all(mx3_fbi->txd->chan);
+	mx3_fbi->txd->chan->device->device_control(mx3_fbi->txd->chan,
+						   DMA_TERMINATE_ALL);
 	mx3_fbi->txd = NULL;
 	mx3_fbi->cookie = -EINVAL;
 }
diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index 20ea12c..0731802 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -107,6 +107,19 @@ enum dma_ctrl_flags {
 };
 
 /**
+ * enum dma_ctrl_cmd - DMA operations that can optionally be exercised
+ * on a running channel.
+ * @DMA_TERMINATE_ALL: terminate all ongoing transfers
+ * @DMA_PAUSE: pause ongoing transfers
+ * @DMA_RESUME: resume paused transfer
+ */
+enum dma_ctrl_cmd {
+	DMA_TERMINATE_ALL,
+	DMA_PAUSE,
+	DMA_RESUME,
+};
+
+/**
  * enum sum_check_bits - bit position of pq_check_flags
  */
 enum sum_check_bits {
@@ -261,7 +274,8 @@ struct dma_async_tx_descriptor {
  * @device_prep_dma_memset: prepares a memset operation
  * @device_prep_dma_interrupt: prepares an end of chain interrupt operation
  * @device_prep_slave_sg: prepares a slave dma operation
- * @device_terminate_all: terminate all pending operations
+ * @device_control: manipulate all pending operations on a channel, returns
+ *	zero or error code
  * @device_is_tx_complete: poll for transaction completion
  * @device_issue_pending: push pending transactions to hardware
  */
@@ -313,7 +327,7 @@ struct dma_device {
 		struct dma_chan *chan, struct scatterlist *sgl,
 		unsigned int sg_len, enum dma_data_direction direction,
 		unsigned long flags);
-	void (*device_terminate_all)(struct dma_chan *chan);
+	int (*device_control)(struct dma_chan *chan, enum dma_ctrl_cmd cmd);
 
 	enum dma_status (*device_is_tx_complete)(struct dma_chan *chan,
 			dma_cookie_t cookie, dma_cookie_t *last,
diff --git a/sound/soc/txx9/txx9aclc.c b/sound/soc/txx9/txx9aclc.c
index efed64b..b35d007 100644
--- a/sound/soc/txx9/txx9aclc.c
+++ b/sound/soc/txx9/txx9aclc.c
@@ -159,7 +159,7 @@ static void txx9aclc_dma_tasklet(unsigned long data)
 		void __iomem *base = drvdata->base;
 
 		spin_unlock_irqrestore(&dmadata->dma_lock, flags);
-		chan->device->device_terminate_all(chan);
+		chan->device->device_control(chan, DMA_TERMINATE_ALL);
 		/* first time */
 		for (i = 0; i < NR_DMA_CHAIN; i++) {
 			desc = txx9aclc_dma_submit(dmadata,
@@ -267,7 +267,7 @@ static int txx9aclc_pcm_close(struct snd_pcm_substream *substream)
 	struct dma_chan *chan = dmadata->dma_chan;
 
 	dmadata->frag_count = -1;
-	chan->device->device_terminate_all(chan);
+	chan->device->device_control(chan, DMA_TERMINATE_ALL);
 	return 0;
 }
 
@@ -396,7 +396,7 @@ static int txx9aclc_pcm_remove(struct platform_device *pdev)
 		struct dma_chan *chan = dmadata->dma_chan;
 		if (chan) {
 			dmadata->frag_count = -1;
-			chan->device->device_terminate_all(chan);
+			chan->device->device_control(chan, DMA_TERMINATE_ALL);
 			dma_release_channel(chan);
 		}
 		dev->dmadata[i].dma_chan = NULL;
-- 
1.6.3.3

