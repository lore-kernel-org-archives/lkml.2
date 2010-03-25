Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753051Ab0CYPER (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 11:04:17 -0400
Received: from mail.df.lth.se ([194.47.250.12]:41392 "EHLO df.lth.se"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750939Ab0CYPEP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 11:04:15 -0400
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
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Joe Perches <joe@perches.com>, Roland Dreier <rdreier@cisco.com>
Subject: [PATCH 2/2] DMAENGINE: generic channel status
Date: Thu, 25 Mar 2010 16:03:01 +0100
Message-Id: <1269529381-16914-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.6.2.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert the device_is_tx_complete() operation on the
DMA engine to a generic device_tx_status()operation which
can return three states, DMA_TX_RUNNING, DMA_TX_COMPLETE,
DMA_TX_PAUSED.

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
Cc: Joe Perches <joe@perches.com>
Cc: Roland Dreier <rdreier@cisco.com>
---
 arch/arm/mach-u300/include/mach/coh901318.h |    7 ----
 drivers/dma/at_hdmac.c                      |   28 +++++++++---------
 drivers/dma/coh901318.c                     |   25 ++++++++-------
 drivers/dma/dmaengine.c                     |    2 +-
 drivers/dma/dw_dmac.c                       |   16 +++++-----
 drivers/dma/fsldma.c                        |   18 +++++------
 drivers/dma/ioat/dma.c                      |   12 ++++----
 drivers/dma/ioat/dma.h                      |   21 ++++++-------
 drivers/dma/ioat/dma_v2.c                   |    2 +-
 drivers/dma/ioat/dma_v3.c                   |   20 ++++++------
 drivers/dma/iop-adma.c                      |   42 +++++++++++++-------------
 drivers/dma/ipu/ipu_idmac.c                 |   14 ++++----
 drivers/dma/mpc512x_dma.c                   |   15 ++++-----
 drivers/dma/mv_xor.c                        |   30 +++++++++---------
 drivers/dma/ppc4xx/adma.c                   |   25 ++++++++-------
 drivers/dma/shdma.c                         |   16 ++++------
 drivers/dma/txx9dmac.c                      |   15 ++++-----
 include/linux/dmaengine.h                   |   36 ++++++++++++++++++++---
 18 files changed, 179 insertions(+), 165 deletions(-)

diff --git a/arch/arm/mach-u300/include/mach/coh901318.h b/arch/arm/mach-u300/include/mach/coh901318.h
index 43ec040..193da2d 100644
--- a/arch/arm/mach-u300/include/mach/coh901318.h
+++ b/arch/arm/mach-u300/include/mach/coh901318.h
@@ -103,13 +103,6 @@ struct coh901318_platform {
 };
 
 /**
- * coh901318_get_bytes_left() - Get number of bytes left on a current transfer
- * @chan: dma channel handle
- * return number of bytes left, or negative on error
- */
-u32 coh901318_get_bytes_left(struct dma_chan *chan);
-
-/**
  * coh901318_filter_id() - DMA channel filter function
  * @chan: dma channel handle
  * @chan_id: id of dma channel to be filter out
diff --git a/drivers/dma/at_hdmac.c b/drivers/dma/at_hdmac.c
index 3fa3658..83d8eec 100644
--- a/drivers/dma/at_hdmac.c
+++ b/drivers/dma/at_hdmac.c
@@ -798,29 +798,25 @@ static int atc_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd)
 }
 
 /**
- * atc_is_tx_complete - poll for transaction completion
+ * atc_tx_status - poll for transaction completion
  * @chan: DMA channel
  * @cookie: transaction identifier to check status of
- * @done: if not %NULL, updated with last completed transaction
- * @used: if not %NULL, updated with last used transaction
+ * @txstate: if not %NULL updated with transaction state
  *
- * If @done and @used are passed in, upon return they reflect the driver
+ * If @txstate is passed in, upon return it reflect the driver
  * internal state and can be used with dma_async_is_complete() to check
  * the status of multiple cookies without re-checking hardware state.
  */
 static enum dma_status
-atc_is_tx_complete(struct dma_chan *chan,
+atc_tx_status(struct dma_chan *chan,
 		dma_cookie_t cookie,
-		dma_cookie_t *done, dma_cookie_t *used)
+		struct dma_tx_state *txstate)
 {
 	struct at_dma_chan	*atchan = to_at_dma_chan(chan);
 	dma_cookie_t		last_used;
 	dma_cookie_t		last_complete;
 	enum dma_status		ret;
 
-	dev_vdbg(chan2dev(chan), "is_tx_complete: %d (d%d, u%d)\n",
-			cookie, done ? *done : 0, used ? *used : 0);
-
 	spin_lock_bh(&atchan->lock);
 
 	last_complete = atchan->completed_cookie;
@@ -838,10 +834,14 @@ atc_is_tx_complete(struct dma_chan *chan,
 
 	spin_unlock_bh(&atchan->lock);
 
-	if (done)
-		*done = last_complete;
-	if (used)
-		*used = last_used;
+	if (txstate) {
+		txstate->last = last_complete;
+		txstate->used = last_used;
+	}
+
+	dev_vdbg(chan2dev(chan), "tx_status: %d (d%d, u%d)\n",
+		 cookie, last_complete ? last_complete : 0,
+		 last_used ? last_used : 0);
 
 	return ret;
 }
@@ -1087,7 +1087,7 @@ static int __init at_dma_probe(struct platform_device *pdev)
 	/* set base routines */
 	atdma->dma_common.device_alloc_chan_resources = atc_alloc_chan_resources;
 	atdma->dma_common.device_free_chan_resources = atc_free_chan_resources;
-	atdma->dma_common.device_is_tx_complete = atc_is_tx_complete;
+	atdma->dma_common.device_tx_status = atc_tx_status;
 	atdma->dma_common.device_issue_pending = atc_issue_pending;
 	atdma->dma_common.dev = &pdev->dev;
 
diff --git a/drivers/dma/coh901318.c b/drivers/dma/coh901318.c
index 2c65cff..44c87f0 100644
--- a/drivers/dma/coh901318.c
+++ b/drivers/dma/coh901318.c
@@ -426,7 +426,7 @@ static inline u32 coh901318_get_bytes_in_lli(struct coh901318_lli *in_lli)
  * absolute measures, but for a rough guess you can still call
  * it.
  */
-u32 coh901318_get_bytes_left(struct dma_chan *chan)
+static u32 coh901318_get_bytes_left(struct dma_chan *chan)
 {
 	struct coh901318_chan *cohc = to_coh901318_chan(chan);
 	struct coh901318_desc *cohd;
@@ -503,8 +503,6 @@ u32 coh901318_get_bytes_left(struct dma_chan *chan)
 
 	return left;
 }
-EXPORT_SYMBOL(coh901318_get_bytes_left);
-
 
 /*
  * Pauses a transfer without losing data. Enables power save.
@@ -1136,9 +1134,8 @@ coh901318_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
 }
 
 static enum dma_status
-coh901318_is_tx_complete(struct dma_chan *chan,
-			 dma_cookie_t cookie, dma_cookie_t *done,
-			 dma_cookie_t *used)
+coh901318_tx_status(struct dma_chan *chan, dma_cookie_t cookie,
+		 struct dma_tx_state *txstate)
 {
 	struct coh901318_chan *cohc = to_coh901318_chan(chan);
 	dma_cookie_t last_used;
@@ -1150,10 +1147,14 @@ coh901318_is_tx_complete(struct dma_chan *chan,
 
 	ret = dma_async_is_complete(cookie, last_complete, last_used);
 
-	if (done)
-		*done = last_complete;
-	if (used)
-		*used = last_used;
+	if (txstate) {
+		txstate->last = last_complete;
+		txstate->used = last_used;
+		txstate->residue = coh901318_get_bytes_left(chan);
+	}
+
+	if (ret == DMA_IN_PROGRESS && cohc->stopped)
+		ret = DMA_PAUSED;
 
 	return ret;
 }
@@ -1356,7 +1357,7 @@ static int __init coh901318_probe(struct platform_device *pdev)
 	base->dma_slave.device_alloc_chan_resources = coh901318_alloc_chan_resources;
 	base->dma_slave.device_free_chan_resources = coh901318_free_chan_resources;
 	base->dma_slave.device_prep_slave_sg = coh901318_prep_slave_sg;
-	base->dma_slave.device_is_tx_complete = coh901318_is_tx_complete;
+	base->dma_slave.device_tx_status = coh901318_tx_status;
 	base->dma_slave.device_issue_pending = coh901318_issue_pending;
 	base->dma_slave.device_control = coh901318_control;
 	base->dma_slave.dev = &pdev->dev;
@@ -1376,7 +1377,7 @@ static int __init coh901318_probe(struct platform_device *pdev)
 	base->dma_memcpy.device_alloc_chan_resources = coh901318_alloc_chan_resources;
 	base->dma_memcpy.device_free_chan_resources = coh901318_free_chan_resources;
 	base->dma_memcpy.device_prep_dma_memcpy = coh901318_prep_memcpy;
-	base->dma_memcpy.device_is_tx_complete = coh901318_is_tx_complete;
+	base->dma_memcpy.device_tx_status = coh901318_tx_status;
 	base->dma_memcpy.device_issue_pending = coh901318_issue_pending;
 	base->dma_memcpy.device_control = coh901318_control;
 	base->dma_memcpy.dev = &pdev->dev;
diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
index ffc4ee9..790caee 100644
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -698,7 +698,7 @@ int dma_async_device_register(struct dma_device *device)
 
 	BUG_ON(!device->device_alloc_chan_resources);
 	BUG_ON(!device->device_free_chan_resources);
-	BUG_ON(!device->device_is_tx_complete);
+	BUG_ON(!device->device_tx_status);
 	BUG_ON(!device->device_issue_pending);
 	BUG_ON(!device->dev);
 
diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index 80ef61f..a6dc2b2 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -819,9 +819,9 @@ static int dwc_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd)
 }
 
 static enum dma_status
-dwc_is_tx_complete(struct dma_chan *chan,
-		dma_cookie_t cookie,
-		dma_cookie_t *done, dma_cookie_t *used)
+dwc_tx_status(struct dma_chan *chan,
+	      dma_cookie_t cookie,
+	      struct dma_tx_state *txstate)
 {
 	struct dw_dma_chan	*dwc = to_dw_dma_chan(chan);
 	dma_cookie_t		last_used;
@@ -841,10 +841,10 @@ dwc_is_tx_complete(struct dma_chan *chan,
 		ret = dma_async_is_complete(cookie, last_complete, last_used);
 	}
 
-	if (done)
-		*done = last_complete;
-	if (used)
-		*used = last_used;
+	if (txstate) {
+		txstate->last = last_complete;
+		txstate->used = last_used;
+	}
 
 	return ret;
 }
@@ -1346,7 +1346,7 @@ static int __init dw_probe(struct platform_device *pdev)
 	dw->dma.device_prep_slave_sg = dwc_prep_slave_sg;
 	dw->dma.device_control = dwc_control;
 
-	dw->dma.device_is_tx_complete = dwc_is_tx_complete;
+	dw->dma.device_tx_status = dwc_tx_status;
 	dw->dma.device_issue_pending = dwc_issue_pending;
 
 	dma_writel(dw, CFG, DW_CFG_DMA_EN);
diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
index 5de0983..161b417 100644
--- a/drivers/dma/fsldma.c
+++ b/drivers/dma/fsldma.c
@@ -971,13 +971,12 @@ static void fsl_dma_memcpy_issue_pending(struct dma_chan *dchan)
 }
 
 /**
- * fsl_dma_is_complete - Determine the DMA status
+ * fsl_tx_status - Determine the DMA status
  * @chan : Freescale DMA channel
  */
-static enum dma_status fsl_dma_is_complete(struct dma_chan *dchan,
+static enum dma_status fsl_tx_status(struct dma_chan *dchan,
 					dma_cookie_t cookie,
-					dma_cookie_t *done,
-					dma_cookie_t *used)
+					struct dma_tx_state *txstate)
 {
 	struct fsldma_chan *chan = to_fsl_chan(dchan);
 	dma_cookie_t last_used;
@@ -988,11 +987,10 @@ static enum dma_status fsl_dma_is_complete(struct dma_chan *dchan,
 	last_used = dchan->cookie;
 	last_complete = chan->completed_cookie;
 
-	if (done)
-		*done = last_complete;
-
-	if (used)
-		*used = last_used;
+	if (txstate) {
+		txstate->last = last_complete;
+		txstate->used = last_used;
+	}
 
 	return dma_async_is_complete(cookie, last_complete, last_used);
 }
@@ -1336,7 +1334,7 @@ static int __devinit fsldma_of_probe(struct of_device *op,
 	fdev->common.device_free_chan_resources = fsl_dma_free_chan_resources;
 	fdev->common.device_prep_dma_interrupt = fsl_dma_prep_interrupt;
 	fdev->common.device_prep_dma_memcpy = fsl_dma_prep_memcpy;
-	fdev->common.device_is_tx_complete = fsl_dma_is_complete;
+	fdev->common.device_tx_status = fsl_tx_status;
 	fdev->common.device_issue_pending = fsl_dma_memcpy_issue_pending;
 	fdev->common.device_prep_slave_sg = fsl_dma_prep_slave_sg;
 	fdev->common.device_control = fsl_dma_device_control;
diff --git a/drivers/dma/ioat/dma.c b/drivers/dma/ioat/dma.c
index 0099340..59cebbf 100644
--- a/drivers/dma/ioat/dma.c
+++ b/drivers/dma/ioat/dma.c
@@ -726,18 +726,18 @@ static void ioat1_timer_event(unsigned long data)
 }
 
 enum dma_status
-ioat_is_dma_complete(struct dma_chan *c, dma_cookie_t cookie,
-		      dma_cookie_t *done, dma_cookie_t *used)
+ioat_dma_tx_status(struct dma_chan *c, dma_cookie_t cookie,
+		   struct dma_tx_state *txstate)
 {
 	struct ioat_chan_common *chan = to_chan_common(c);
 	struct ioatdma_device *device = chan->device;
 
-	if (ioat_is_complete(c, cookie, done, used) == DMA_SUCCESS)
+	if (ioat_tx_status(c, cookie, txstate) == DMA_SUCCESS)
 		return DMA_SUCCESS;
 
 	device->cleanup_fn((unsigned long) c);
 
-	return ioat_is_complete(c, cookie, done, used);
+	return ioat_tx_status(c, cookie, txstate);
 }
 
 static void ioat1_dma_start_null_desc(struct ioat_dma_chan *ioat)
@@ -857,7 +857,7 @@ int __devinit ioat_dma_self_test(struct ioatdma_device *device)
 	tmo = wait_for_completion_timeout(&cmp, msecs_to_jiffies(3000));
 
 	if (tmo == 0 ||
-	    dma->device_is_tx_complete(dma_chan, cookie, NULL, NULL)
+	    dma->device_tx_status(dma_chan, cookie, NULL)
 					!= DMA_SUCCESS) {
 		dev_err(dev, "Self-test copy timed out, disabling\n");
 		err = -ENODEV;
@@ -1198,7 +1198,7 @@ int __devinit ioat1_dma_probe(struct ioatdma_device *device, int dca)
 	dma->device_issue_pending = ioat1_dma_memcpy_issue_pending;
 	dma->device_alloc_chan_resources = ioat1_dma_alloc_chan_resources;
 	dma->device_free_chan_resources = ioat1_dma_free_chan_resources;
-	dma->device_is_tx_complete = ioat_is_dma_complete;
+	dma->device_tx_status = ioat_dma_tx_status;
 
 	err = ioat_probe(device);
 	if (err)
diff --git a/drivers/dma/ioat/dma.h b/drivers/dma/ioat/dma.h
index 86b97ac..3a1f226 100644
--- a/drivers/dma/ioat/dma.h
+++ b/drivers/dma/ioat/dma.h
@@ -142,15 +142,14 @@ static inline struct ioat_dma_chan *to_ioat_chan(struct dma_chan *c)
 }
 
 /**
- * ioat_is_complete - poll the status of an ioat transaction
+ * ioat_tx_status - poll the status of an ioat transaction
  * @c: channel handle
  * @cookie: transaction identifier
- * @done: if set, updated with last completed transaction
- * @used: if set, updated with last used transaction
+ * @txstate: if set, updated with the transaction state
  */
 static inline enum dma_status
-ioat_is_complete(struct dma_chan *c, dma_cookie_t cookie,
-		 dma_cookie_t *done, dma_cookie_t *used)
+ioat_tx_status(struct dma_chan *c, dma_cookie_t cookie,
+		 struct dma_tx_state *txstate)
 {
 	struct ioat_chan_common *chan = to_chan_common(c);
 	dma_cookie_t last_used;
@@ -159,10 +158,10 @@ ioat_is_complete(struct dma_chan *c, dma_cookie_t cookie,
 	last_used = c->cookie;
 	last_complete = chan->completed_cookie;
 
-	if (done)
-		*done = last_complete;
-	if (used)
-		*used = last_used;
+	if (txstate) {
+		txstate->last = last_complete;
+		txstate->used = last_used;
+	}
 
 	return dma_async_is_complete(cookie, last_complete, last_used);
 }
@@ -338,8 +337,8 @@ struct dca_provider * __devinit ioat_dca_init(struct pci_dev *pdev,
 unsigned long ioat_get_current_completion(struct ioat_chan_common *chan);
 void ioat_init_channel(struct ioatdma_device *device,
 		       struct ioat_chan_common *chan, int idx);
-enum dma_status ioat_is_dma_complete(struct dma_chan *c, dma_cookie_t cookie,
-				     dma_cookie_t *done, dma_cookie_t *used);
+enum dma_status ioat_dma_tx_status(struct dma_chan *c, dma_cookie_t cookie,
+				   struct dma_tx_state *txstate);
 void ioat_dma_unmap(struct ioat_chan_common *chan, enum dma_ctrl_flags flags,
 		    size_t len, struct ioat_dma_descriptor *hw);
 bool ioat_cleanup_preamble(struct ioat_chan_common *chan,
diff --git a/drivers/dma/ioat/dma_v2.c b/drivers/dma/ioat/dma_v2.c
index 1ed5d66..f540e0b 100644
--- a/drivers/dma/ioat/dma_v2.c
+++ b/drivers/dma/ioat/dma_v2.c
@@ -854,7 +854,7 @@ int __devinit ioat2_dma_probe(struct ioatdma_device *device, int dca)
 	dma->device_issue_pending = ioat2_issue_pending;
 	dma->device_alloc_chan_resources = ioat2_alloc_chan_resources;
 	dma->device_free_chan_resources = ioat2_free_chan_resources;
-	dma->device_is_tx_complete = ioat_is_dma_complete;
+	dma->device_tx_status = ioat_tx_status;
 
 	err = ioat_probe(device);
 	if (err)
diff --git a/drivers/dma/ioat/dma_v3.c b/drivers/dma/ioat/dma_v3.c
index 26febc5..d1adbf3 100644
--- a/drivers/dma/ioat/dma_v3.c
+++ b/drivers/dma/ioat/dma_v3.c
@@ -438,17 +438,17 @@ static void ioat3_timer_event(unsigned long data)
 }
 
 static enum dma_status
-ioat3_is_complete(struct dma_chan *c, dma_cookie_t cookie,
-		  dma_cookie_t *done, dma_cookie_t *used)
+ioat3_tx_status(struct dma_chan *c, dma_cookie_t cookie,
+		struct dma_tx_state *txstate)
 {
 	struct ioat2_dma_chan *ioat = to_ioat2_chan(c);
 
-	if (ioat_is_complete(c, cookie, done, used) == DMA_SUCCESS)
+	if (ioat_tx_status(c, cookie, txstate) == DMA_SUCCESS)
 		return DMA_SUCCESS;
 
 	ioat3_cleanup_poll(ioat);
 
-	return ioat_is_complete(c, cookie, done, used);
+	return ioat_tx_status(c, cookie, txstate);
 }
 
 static struct dma_async_tx_descriptor *
@@ -976,7 +976,7 @@ static int __devinit ioat_xor_val_self_test(struct ioatdma_device *device)
 
 	tmo = wait_for_completion_timeout(&cmp, msecs_to_jiffies(3000));
 
-	if (dma->device_is_tx_complete(dma_chan, cookie, NULL, NULL) != DMA_SUCCESS) {
+	if (dma->device_tx_status(dma_chan, cookie, NULL) != DMA_SUCCESS) {
 		dev_err(dev, "Self-test xor timed out\n");
 		err = -ENODEV;
 		goto free_resources;
@@ -1030,7 +1030,7 @@ static int __devinit ioat_xor_val_self_test(struct ioatdma_device *device)
 
 	tmo = wait_for_completion_timeout(&cmp, msecs_to_jiffies(3000));
 
-	if (dma->device_is_tx_complete(dma_chan, cookie, NULL, NULL) != DMA_SUCCESS) {
+	if (dma->device_tx_status(dma_chan, cookie, NULL) != DMA_SUCCESS) {
 		dev_err(dev, "Self-test validate timed out\n");
 		err = -ENODEV;
 		goto free_resources;
@@ -1071,7 +1071,7 @@ static int __devinit ioat_xor_val_self_test(struct ioatdma_device *device)
 
 	tmo = wait_for_completion_timeout(&cmp, msecs_to_jiffies(3000));
 
-	if (dma->device_is_tx_complete(dma_chan, cookie, NULL, NULL) != DMA_SUCCESS) {
+	if (dma->device_tx_status(dma_chan, cookie, NULL) != DMA_SUCCESS) {
 		dev_err(dev, "Self-test memset timed out\n");
 		err = -ENODEV;
 		goto free_resources;
@@ -1114,7 +1114,7 @@ static int __devinit ioat_xor_val_self_test(struct ioatdma_device *device)
 
 	tmo = wait_for_completion_timeout(&cmp, msecs_to_jiffies(3000));
 
-	if (dma->device_is_tx_complete(dma_chan, cookie, NULL, NULL) != DMA_SUCCESS) {
+	if (dma->device_tx_status(dma_chan, cookie, NULL) != DMA_SUCCESS) {
 		dev_err(dev, "Self-test 2nd validate timed out\n");
 		err = -ENODEV;
 		goto free_resources;
@@ -1258,11 +1258,11 @@ int __devinit ioat3_dma_probe(struct ioatdma_device *device, int dca)
 
 
 	if (is_raid_device) {
-		dma->device_is_tx_complete = ioat3_is_complete;
+		dma->device_tx_status = ioat3_tx_status;
 		device->cleanup_fn = ioat3_cleanup_event;
 		device->timer_fn = ioat3_timer_event;
 	} else {
-		dma->device_is_tx_complete = ioat_is_dma_complete;
+		dma->device_tx_status = ioat_dma_tx_status;
 		device->cleanup_fn = ioat2_cleanup_event;
 		device->timer_fn = ioat2_timer_event;
 	}
diff --git a/drivers/dma/iop-adma.c b/drivers/dma/iop-adma.c
index ca6e6a0..e537b13 100644
--- a/drivers/dma/iop-adma.c
+++ b/drivers/dma/iop-adma.c
@@ -893,14 +893,14 @@ static void iop_adma_free_chan_resources(struct dma_chan *chan)
 }
 
 /**
- * iop_adma_is_complete - poll the status of an ADMA transaction
+ * iop_adma_status - poll the status of an ADMA transaction
  * @chan: ADMA channel handle
  * @cookie: ADMA transaction identifier
+ * @txstate: a holder for the current state of the channel or NULL
  */
-static enum dma_status iop_adma_is_complete(struct dma_chan *chan,
+static enum dma_status iop_adma_status(struct dma_chan *chan,
 					dma_cookie_t cookie,
-					dma_cookie_t *done,
-					dma_cookie_t *used)
+					struct dma_tx_state *txstate)
 {
 	struct iop_adma_chan *iop_chan = to_iop_adma_chan(chan);
 	dma_cookie_t last_used;
@@ -910,10 +910,10 @@ static enum dma_status iop_adma_is_complete(struct dma_chan *chan,
 	last_used = chan->cookie;
 	last_complete = iop_chan->completed_cookie;
 
-	if (done)
-		*done = last_complete;
-	if (used)
-		*used = last_used;
+	if (txstate) {
+		txstate->last = last_complete;
+		txstate->used = last_used;
+	}
 
 	ret = dma_async_is_complete(cookie, last_complete, last_used);
 	if (ret == DMA_SUCCESS)
@@ -924,10 +924,10 @@ static enum dma_status iop_adma_is_complete(struct dma_chan *chan,
 	last_used = chan->cookie;
 	last_complete = iop_chan->completed_cookie;
 
-	if (done)
-		*done = last_complete;
-	if (used)
-		*used = last_used;
+	if (txstate) {
+		txstate->last = last_complete;
+		txstate->used = last_used;
+	}
 
 	return dma_async_is_complete(cookie, last_complete, last_used);
 }
@@ -1042,7 +1042,7 @@ static int __devinit iop_adma_memcpy_self_test(struct iop_adma_device *device)
 	iop_adma_issue_pending(dma_chan);
 	msleep(1);
 
-	if (iop_adma_is_complete(dma_chan, cookie, NULL, NULL) !=
+	if (iop_adma_status(dma_chan, cookie, NULL) !=
 			DMA_SUCCESS) {
 		dev_printk(KERN_ERR, dma_chan->device->dev,
 			"Self-test copy timed out, disabling\n");
@@ -1142,7 +1142,7 @@ iop_adma_xor_val_self_test(struct iop_adma_device *device)
 	iop_adma_issue_pending(dma_chan);
 	msleep(8);
 
-	if (iop_adma_is_complete(dma_chan, cookie, NULL, NULL) !=
+	if (iop_adma_status(dma_chan, cookie, NULL) !=
 		DMA_SUCCESS) {
 		dev_printk(KERN_ERR, dma_chan->device->dev,
 			"Self-test xor timed out, disabling\n");
@@ -1189,7 +1189,7 @@ iop_adma_xor_val_self_test(struct iop_adma_device *device)
 	iop_adma_issue_pending(dma_chan);
 	msleep(8);
 
-	if (iop_adma_is_complete(dma_chan, cookie, NULL, NULL) != DMA_SUCCESS) {
+	if (iop_adma_status(dma_chan, cookie, NULL) != DMA_SUCCESS) {
 		dev_printk(KERN_ERR, dma_chan->device->dev,
 			"Self-test zero sum timed out, disabling\n");
 		err = -ENODEV;
@@ -1213,7 +1213,7 @@ iop_adma_xor_val_self_test(struct iop_adma_device *device)
 	iop_adma_issue_pending(dma_chan);
 	msleep(8);
 
-	if (iop_adma_is_complete(dma_chan, cookie, NULL, NULL) != DMA_SUCCESS) {
+	if (iop_adma_status(dma_chan, cookie, NULL) != DMA_SUCCESS) {
 		dev_printk(KERN_ERR, dma_chan->device->dev,
 			"Self-test memset timed out, disabling\n");
 		err = -ENODEV;
@@ -1245,7 +1245,7 @@ iop_adma_xor_val_self_test(struct iop_adma_device *device)
 	iop_adma_issue_pending(dma_chan);
 	msleep(8);
 
-	if (iop_adma_is_complete(dma_chan, cookie, NULL, NULL) != DMA_SUCCESS) {
+	if (iop_adma_status(dma_chan, cookie, NULL) != DMA_SUCCESS) {
 		dev_printk(KERN_ERR, dma_chan->device->dev,
 			"Self-test non-zero sum timed out, disabling\n");
 		err = -ENODEV;
@@ -1340,7 +1340,7 @@ iop_adma_pq_zero_sum_self_test(struct iop_adma_device *device)
 	iop_adma_issue_pending(dma_chan);
 	msleep(8);
 
-	if (iop_adma_is_complete(dma_chan, cookie, NULL, NULL) !=
+	if (iop_adma_status(dma_chan, cookie, NULL) !=
 		DMA_SUCCESS) {
 		dev_err(dev, "Self-test pq timed out, disabling\n");
 		err = -ENODEV;
@@ -1377,7 +1377,7 @@ iop_adma_pq_zero_sum_self_test(struct iop_adma_device *device)
 	iop_adma_issue_pending(dma_chan);
 	msleep(8);
 
-	if (iop_adma_is_complete(dma_chan, cookie, NULL, NULL) !=
+	if (iop_adma_status(dma_chan, cookie, NULL) !=
 		DMA_SUCCESS) {
 		dev_err(dev, "Self-test pq-zero-sum timed out, disabling\n");
 		err = -ENODEV;
@@ -1409,7 +1409,7 @@ iop_adma_pq_zero_sum_self_test(struct iop_adma_device *device)
 	iop_adma_issue_pending(dma_chan);
 	msleep(8);
 
-	if (iop_adma_is_complete(dma_chan, cookie, NULL, NULL) !=
+	if (iop_adma_status(dma_chan, cookie, NULL) !=
 		DMA_SUCCESS) {
 		dev_err(dev, "Self-test !pq-zero-sum timed out, disabling\n");
 		err = -ENODEV;
@@ -1507,7 +1507,7 @@ static int __devinit iop_adma_probe(struct platform_device *pdev)
 	/* set base routines */
 	dma_dev->device_alloc_chan_resources = iop_adma_alloc_chan_resources;
 	dma_dev->device_free_chan_resources = iop_adma_free_chan_resources;
-	dma_dev->device_is_tx_complete = iop_adma_is_complete;
+	dma_dev->device_tx_status = iop_adma_status;
 	dma_dev->device_issue_pending = iop_adma_issue_pending;
 	dma_dev->dev = &pdev->dev;
 
diff --git a/drivers/dma/ipu/ipu_idmac.c b/drivers/dma/ipu/ipu_idmac.c
index 6b32878..cb8ba64 100644
--- a/drivers/dma/ipu/ipu_idmac.c
+++ b/drivers/dma/ipu/ipu_idmac.c
@@ -1644,15 +1644,15 @@ static void idmac_free_chan_resources(struct dma_chan *chan)
 	tasklet_schedule(&to_ipu(idmac)->tasklet);
 }
 
-static enum dma_status idmac_is_tx_complete(struct dma_chan *chan,
-		dma_cookie_t cookie, dma_cookie_t *done, dma_cookie_t *used)
+static enum dma_status idmac_tx_status(struct dma_chan *chan,
+		       dma_cookie_t cookie, struct dma_tx_state *txstate)
 {
 	struct idmac_channel *ichan = to_idmac_chan(chan);
 
-	if (done)
-		*done = ichan->completed;
-	if (used)
-		*used = chan->cookie;
+	if (txstate) {
+		txstate->last = ichan->completed;
+		txstate->used = chan->cookie;
+	}
 	if (cookie != chan->cookie)
 		return DMA_ERROR;
 	return DMA_SUCCESS;
@@ -1671,7 +1671,7 @@ static int __init ipu_idmac_init(struct ipu *ipu)
 	dma->dev				= ipu->dev;
 	dma->device_alloc_chan_resources	= idmac_alloc_chan_resources;
 	dma->device_free_chan_resources		= idmac_free_chan_resources;
-	dma->device_is_tx_complete		= idmac_is_tx_complete;
+	dma->device_tx_status			= idmac_tx_status;
 	dma->device_issue_pending		= idmac_issue_pending;
 
 	/* Compulsory for DMA_SLAVE fields */
diff --git a/drivers/dma/mpc512x_dma.c b/drivers/dma/mpc512x_dma.c
index 3fdf1f4..20b36a6 100644
--- a/drivers/dma/mpc512x_dma.c
+++ b/drivers/dma/mpc512x_dma.c
@@ -540,8 +540,8 @@ static void mpc_dma_issue_pending(struct dma_chan *chan)
 
 /* Check request completion status */
 static enum dma_status
-mpc_dma_is_tx_complete(struct dma_chan *chan, dma_cookie_t cookie,
-					dma_cookie_t *done, dma_cookie_t *used)
+mpc_dma_tx_status(struct dma_chan *chan, dma_cookie_t cookie,
+	       struct dma_tx_state *txstate)
 {
 	struct mpc_dma_chan *mchan = dma_chan_to_mpc_dma_chan(chan);
 	unsigned long flags;
@@ -553,11 +553,10 @@ mpc_dma_is_tx_complete(struct dma_chan *chan, dma_cookie_t cookie,
 	last_complete = mchan->completed_cookie;
 	spin_unlock_irqrestore(&mchan->lock, flags);
 
-	if (done)
-		*done = last_complete;
-
-	if (used)
-		*used = last_used;
+	if (txstate) {
+		txstate->last = last_complete;
+		txstate->used = last_used;
+	}
 
 	return dma_async_is_complete(cookie, last_complete, last_used);
 }
@@ -693,7 +692,7 @@ static int __devinit mpc_dma_probe(struct of_device *op,
 	dma->device_alloc_chan_resources = mpc_dma_alloc_chan_resources;
 	dma->device_free_chan_resources = mpc_dma_free_chan_resources;
 	dma->device_issue_pending = mpc_dma_issue_pending;
-	dma->device_is_tx_complete = mpc_dma_is_tx_complete;
+	dma->device_tx_status = mpc_dma_tx_status;
 	dma->device_prep_dma_memcpy = mpc_dma_prep_memcpy;
 
 	INIT_LIST_HEAD(&dma->channels);
diff --git a/drivers/dma/mv_xor.c b/drivers/dma/mv_xor.c
index 466ab10..504947a 100644
--- a/drivers/dma/mv_xor.c
+++ b/drivers/dma/mv_xor.c
@@ -809,14 +809,14 @@ static void mv_xor_free_chan_resources(struct dma_chan *chan)
 }
 
 /**
- * mv_xor_is_complete - poll the status of an XOR transaction
+ * mv_xor_status - poll the status of an XOR transaction
  * @chan: XOR channel handle
  * @cookie: XOR transaction identifier
+ * @txstate: XOR transactions state holder (or NULL)
  */
-static enum dma_status mv_xor_is_complete(struct dma_chan *chan,
+static enum dma_status mv_xor_status(struct dma_chan *chan,
 					  dma_cookie_t cookie,
-					  dma_cookie_t *done,
-					  dma_cookie_t *used)
+					  struct dma_tx_state *txstate)
 {
 	struct mv_xor_chan *mv_chan = to_mv_xor_chan(chan);
 	dma_cookie_t last_used;
@@ -826,10 +826,10 @@ static enum dma_status mv_xor_is_complete(struct dma_chan *chan,
 	last_used = chan->cookie;
 	last_complete = mv_chan->completed_cookie;
 	mv_chan->is_complete_cookie = cookie;
-	if (done)
-		*done = last_complete;
-	if (used)
-		*used = last_used;
+	if (txstate) {
+		txstate->last = last_complete;
+		txstate->used = last_used;
+	}
 
 	ret = dma_async_is_complete(cookie, last_complete, last_used);
 	if (ret == DMA_SUCCESS) {
@@ -841,10 +841,10 @@ static enum dma_status mv_xor_is_complete(struct dma_chan *chan,
 	last_used = chan->cookie;
 	last_complete = mv_chan->completed_cookie;
 
-	if (done)
-		*done = last_complete;
-	if (used)
-		*used = last_used;
+	if (txstate) {
+		txstate->last = last_complete;
+		txstate->used = last_used;
+	}
 
 	return dma_async_is_complete(cookie, last_complete, last_used);
 }
@@ -974,7 +974,7 @@ static int __devinit mv_xor_memcpy_self_test(struct mv_xor_device *device)
 	async_tx_ack(tx);
 	msleep(1);
 
-	if (mv_xor_is_complete(dma_chan, cookie, NULL, NULL) !=
+	if (mv_xor_status(dma_chan, cookie, NULL) !=
 	    DMA_SUCCESS) {
 		dev_printk(KERN_ERR, dma_chan->device->dev,
 			   "Self-test copy timed out, disabling\n");
@@ -1072,7 +1072,7 @@ mv_xor_xor_self_test(struct mv_xor_device *device)
 	async_tx_ack(tx);
 	msleep(8);
 
-	if (mv_xor_is_complete(dma_chan, cookie, NULL, NULL) !=
+	if (mv_xor_status(dma_chan, cookie, NULL) !=
 	    DMA_SUCCESS) {
 		dev_printk(KERN_ERR, dma_chan->device->dev,
 			   "Self-test xor timed out, disabling\n");
@@ -1167,7 +1167,7 @@ static int __devinit mv_xor_probe(struct platform_device *pdev)
 	/* set base routines */
 	dma_dev->device_alloc_chan_resources = mv_xor_alloc_chan_resources;
 	dma_dev->device_free_chan_resources = mv_xor_free_chan_resources;
-	dma_dev->device_is_tx_complete = mv_xor_is_complete;
+	dma_dev->device_tx_status = mv_xor_status;
 	dma_dev->device_issue_pending = mv_xor_issue_pending;
 	dma_dev->dev = &pdev->dev;
 
diff --git a/drivers/dma/ppc4xx/adma.c b/drivers/dma/ppc4xx/adma.c
index e69d87f..eb45c79 100644
--- a/drivers/dma/ppc4xx/adma.c
+++ b/drivers/dma/ppc4xx/adma.c
@@ -3934,12 +3934,13 @@ static void ppc440spe_adma_free_chan_resources(struct dma_chan *chan)
 }
 
 /**
- * ppc440spe_adma_is_complete - poll the status of an ADMA transaction
+ * ppc440spe_adma_tx_status - poll the status of an ADMA transaction
  * @chan: ADMA channel handle
  * @cookie: ADMA transaction identifier
+ * @txstate: a holder for the current state of the channel
  */
-static enum dma_status ppc440spe_adma_is_complete(struct dma_chan *chan,
-	dma_cookie_t cookie, dma_cookie_t *done, dma_cookie_t *used)
+static enum dma_status ppc440spe_adma_tx_status(struct dma_chan *chan,
+			dma_cookie_t cookie, struct dma_tx_state *txstate);
 {
 	struct ppc440spe_adma_chan *ppc440spe_chan;
 	dma_cookie_t last_used;
@@ -3950,10 +3951,10 @@ static enum dma_status ppc440spe_adma_is_complete(struct dma_chan *chan,
 	last_used = chan->cookie;
 	last_complete = ppc440spe_chan->completed_cookie;
 
-	if (done)
-		*done = last_complete;
-	if (used)
-		*used = last_used;
+	if (txstate) {
+		txstate->last = last_complete;
+		txstate->used = last_used;
+	}
 
 	ret = dma_async_is_complete(cookie, last_complete, last_used);
 	if (ret == DMA_SUCCESS)
@@ -3964,10 +3965,10 @@ static enum dma_status ppc440spe_adma_is_complete(struct dma_chan *chan,
 	last_used = chan->cookie;
 	last_complete = ppc440spe_chan->completed_cookie;
 
-	if (done)
-		*done = last_complete;
-	if (used)
-		*used = last_used;
+	if (txstate) {
+		txstate->last = last_complete;
+		txstate->used = last_used;
+	}
 
 	return dma_async_is_complete(cookie, last_complete, last_used);
 }
@@ -4179,7 +4180,7 @@ static void ppc440spe_adma_init_capabilities(struct ppc440spe_adma_device *adev)
 				ppc440spe_adma_alloc_chan_resources;
 	adev->common.device_free_chan_resources =
 				ppc440spe_adma_free_chan_resources;
-	adev->common.device_is_tx_complete = ppc440spe_adma_is_complete;
+	adev->common.device_tx_status = ppc440spe_adma_tx_status;
 	adev->common.device_issue_pending = ppc440spe_adma_issue_pending;
 
 	/* Set prep routines based on capability */
diff --git a/drivers/dma/shdma.c b/drivers/dma/shdma.c
index ce88131..0b2542b 100644
--- a/drivers/dma/shdma.c
+++ b/drivers/dma/shdma.c
@@ -738,10 +738,9 @@ static void sh_dmae_memcpy_issue_pending(struct dma_chan *chan)
 	sh_chan_xfer_ld_queue(sh_chan);
 }
 
-static enum dma_status sh_dmae_is_complete(struct dma_chan *chan,
+static enum dma_status sh_dmae_tx_status(struct dma_chan *chan,
 					dma_cookie_t cookie,
-					dma_cookie_t *done,
-					dma_cookie_t *used)
+					struct dma_tx_state *txstate)
 {
 	struct sh_dmae_chan *sh_chan = to_sh_chan(chan);
 	dma_cookie_t last_used;
@@ -754,11 +753,10 @@ static enum dma_status sh_dmae_is_complete(struct dma_chan *chan,
 	last_complete = sh_chan->completed_cookie;
 	BUG_ON(last_complete < 0);
 
-	if (done)
-		*done = last_complete;
-
-	if (used)
-		*used = last_used;
+	if (txstate) {
+		txstate->last = last_complete;
+		txstate->used = last_used;
+	}
 
 	spin_lock_bh(&sh_chan->desc_lock);
 
@@ -1030,7 +1028,7 @@ static int __init sh_dmae_probe(struct platform_device *pdev)
 		= sh_dmae_alloc_chan_resources;
 	shdev->common.device_free_chan_resources = sh_dmae_free_chan_resources;
 	shdev->common.device_prep_dma_memcpy = sh_dmae_prep_memcpy;
-	shdev->common.device_is_tx_complete = sh_dmae_is_complete;
+	shdev->common.device_tx_status = sh_dmae_tx_status;
 	shdev->common.device_issue_pending = sh_dmae_memcpy_issue_pending;
 
 	/* Compulsory for DMA_SLAVE fields */
diff --git a/drivers/dma/txx9dmac.c b/drivers/dma/txx9dmac.c
index e528e15..aebb8d3 100644
--- a/drivers/dma/txx9dmac.c
+++ b/drivers/dma/txx9dmac.c
@@ -967,9 +967,8 @@ static int txx9dmac_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd)
 }
 
 static enum dma_status
-txx9dmac_is_tx_complete(struct dma_chan *chan,
-			dma_cookie_t cookie,
-		dma_cookie_t *done, dma_cookie_t *used)
+txx9dmac_tx_status(struct dma_chan *chan, dma_cookie_t cookie,
+		   struct dma_tx_state *txstate)
 {
 	struct txx9dmac_chan *dc = to_txx9dmac_chan(chan);
 	dma_cookie_t last_used;
@@ -991,10 +990,10 @@ txx9dmac_is_tx_complete(struct dma_chan *chan,
 		ret = dma_async_is_complete(cookie, last_complete, last_used);
 	}
 
-	if (done)
-		*done = last_complete;
-	if (used)
-		*used = last_used;
+	if (txstate) {
+		txstate->last = last_complete;
+		txstate->used = last_used;
+	}
 
 	return ret;
 }
@@ -1160,7 +1159,7 @@ static int __init txx9dmac_chan_probe(struct platform_device *pdev)
 	dc->dma.device_alloc_chan_resources = txx9dmac_alloc_chan_resources;
 	dc->dma.device_free_chan_resources = txx9dmac_free_chan_resources;
 	dc->dma.device_control = txx9dmac_control;
-	dc->dma.device_is_tx_complete = txx9dmac_is_tx_complete;
+	dc->dma.device_tx_status = txx9dmac_tx_status;
 	dc->dma.device_issue_pending = txx9dmac_issue_pending;
 	if (pdata && pdata->memcpy_chan == ch) {
 		dc->dma.device_prep_dma_memcpy = txx9dmac_prep_dma_memcpy;
diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index 0731802..c9f2c67 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -40,11 +40,13 @@ typedef s32 dma_cookie_t;
  * enum dma_status - DMA transaction status
  * @DMA_SUCCESS: transaction completed successfully
  * @DMA_IN_PROGRESS: transaction not yet processed
+ * @DMA_PAUSED: transaction is paused
  * @DMA_ERROR: transaction failed
  */
 enum dma_status {
 	DMA_SUCCESS,
 	DMA_IN_PROGRESS,
+	DMA_PAUSED,
 	DMA_ERROR,
 };
 
@@ -249,6 +251,21 @@ struct dma_async_tx_descriptor {
 };
 
 /**
+ * struct dma_tx_state - filled in to report the status of
+ * a transfer.
+ * @last: last completed DMA cookie
+ * @used: last issued DMA cookie (i.e. the one in progress)
+ * @residue: the remaining number of bytes left to transmit
+ *	on the selected transfer for states DMA_IN_PROGRESS and
+ *	DMA_PAUSED if this is implemented in the driver, else 0
+ */
+struct dma_tx_state {
+	dma_cookie_t last;
+	dma_cookie_t used;
+	u32 residue;
+};
+
+/**
  * struct dma_device - info on the entity supplying DMA services
  * @chancnt: how many DMA channels are supported
  * @privatecnt: how many DMA channels are requested by dma_request_channel
@@ -276,7 +293,10 @@ struct dma_async_tx_descriptor {
  * @device_prep_slave_sg: prepares a slave dma operation
  * @device_control: manipulate all pending operations on a channel, returns
  *	zero or error code
- * @device_is_tx_complete: poll for transaction completion
+ * @device_tx_status: poll for transaction completion, the optional
+ *	txstate parameter can be supplied with a pointer to get a
+ *	struct with some transfer information, else the call will just
+ *	return a simple status code
  * @device_issue_pending: push pending transactions to hardware
  */
 struct dma_device {
@@ -329,9 +349,9 @@ struct dma_device {
 		unsigned long flags);
 	int (*device_control)(struct dma_chan *chan, enum dma_ctrl_cmd cmd);
 
-	enum dma_status (*device_is_tx_complete)(struct dma_chan *chan,
-			dma_cookie_t cookie, dma_cookie_t *last,
-			dma_cookie_t *used);
+	enum dma_status (*device_tx_status)(struct dma_chan *chan,
+					    dma_cookie_t cookie,
+					    struct dma_tx_state *txstate);
 	void (*device_issue_pending)(struct dma_chan *chan);
 };
 
@@ -572,7 +592,13 @@ static inline void dma_async_issue_pending(struct dma_chan *chan)
 static inline enum dma_status dma_async_is_tx_complete(struct dma_chan *chan,
 	dma_cookie_t cookie, dma_cookie_t *last, dma_cookie_t *used)
 {
-	return chan->device->device_is_tx_complete(chan, cookie, last, used);
+	struct dma_tx_state state;
+	enum dma_status status;
+
+	status = chan->device->device_tx_status(chan, cookie, &state);
+	*last = state.last;
+	*used = state.used;
+	return status;
 }
 
 #define dma_async_memcpy_complete(chan, cookie, last, used)\
-- 
1.6.3.3

