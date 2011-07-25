Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752968Ab1GYVGI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 17:06:08 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:51489 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752481Ab1GYVGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 17:06:07 -0400
From: Rob Herring <robherring2@gmail.com>
Cc: Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Jassi Brar <jassisinghbrar@gmail.com>,
        Vinod Koul <vkoul@infradead.org>,
        Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v2] dmaengine: pl330: make platform data optional
Date: Mon, 25 Jul 2011 16:05:04 -0500
Message-Id: <1311627904-24045-1-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1310518811-379-1-git-send-email-robherring2@gmail.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

The pl330 needs platform data for describing peripheral connections, but
some platforms may only support memory to memory dma channels. In this
case, we can probe for how many channels there are and don't need the
platform data.

As memcpy requests don't need channel private data to hold peripheral
info, allow private data to be NULL in this case.

Signed-off-by: Rob Herring <rob.herring@calxeda.com>
Cc: Jassi Brar <jassisinghbrar@gmail.com>
Cc: Vinod Koul <vkoul@infradead.org>
Cc: Dan Williams <dan.j.williams@intel.com>
 
---
Vinod, Can you apply this updated version instead?

v2:
 - Added null ptr check

 drivers/dma/pl330.c |   64 ++++++++++++++++++++++++++++----------------------
 1 files changed, 36 insertions(+), 28 deletions(-)

diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
index 7181e43..5ed0465 100644
--- a/drivers/dma/pl330.c
+++ b/drivers/dma/pl330.c
@@ -82,7 +82,7 @@ struct dma_pl330_dmac {
 	spinlock_t pool_lock;
 
 	/* Peripheral channels connected to this DMAC */
-	struct dma_pl330_chan peripherals[0]; /* keep at end */
+	struct dma_pl330_chan *peripherals; /* keep at end */
 };
 
 struct dma_pl330_desc {
@@ -451,8 +451,13 @@ static struct dma_pl330_desc *pl330_get_desc(struct dma_pl330_chan *pch)
 	desc->txd.cookie = 0;
 	async_tx_ack(&desc->txd);
 
-	desc->req.rqtype = peri->rqtype;
-	desc->req.peri = peri->peri_id;
+	if (peri) {
+		desc->req.rqtype = peri->rqtype;
+		desc->req.peri = peri->peri_id;
+	} else {
+		desc->req.rqtype = MEMTOMEM;
+		desc->req.peri = 0;
+	}
 
 	dma_async_tx_descriptor_init(&desc->txd, &pch->chan);
 
@@ -529,10 +534,10 @@ pl330_prep_dma_memcpy(struct dma_chan *chan, dma_addr_t dst,
 	struct pl330_info *pi;
 	int burst;
 
-	if (unlikely(!pch || !len || !peri))
+	if (unlikely(!pch || !len))
 		return NULL;
 
-	if (peri->rqtype != MEMTOMEM)
+	if (peri && peri->rqtype != MEMTOMEM)
 		return NULL;
 
 	pi = &pch->dmac->pif;
@@ -577,7 +582,7 @@ pl330_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
 	int i, burst_size;
 	dma_addr_t addr;
 
-	if (unlikely(!pch || !sgl || !sg_len))
+	if (unlikely(!pch || !sgl || !sg_len || !peri))
 		return NULL;
 
 	/* Make sure the direction is consistent */
@@ -666,17 +671,12 @@ pl330_probe(struct amba_device *adev, const struct amba_id *id)
 	struct dma_device *pd;
 	struct resource *res;
 	int i, ret, irq;
+	int num_chan;
 
 	pdat = adev->dev.platform_data;
 
-	if (!pdat || !pdat->nr_valid_peri) {
-		dev_err(&adev->dev, "platform data missing\n");
-		return -ENODEV;
-	}
-
 	/* Allocate a new DMAC and its Channels */
-	pdmac = kzalloc(pdat->nr_valid_peri * sizeof(*pch)
-				+ sizeof(*pdmac), GFP_KERNEL);
+	pdmac = kzalloc(sizeof(*pdmac), GFP_KERNEL);
 	if (!pdmac) {
 		dev_err(&adev->dev, "unable to allocate mem\n");
 		return -ENOMEM;
@@ -685,7 +685,7 @@ pl330_probe(struct amba_device *adev, const struct amba_id *id)
 	pi = &pdmac->pif;
 	pi->dev = &adev->dev;
 	pi->pl330_data = NULL;
-	pi->mcbufsz = pdat->mcbuf_sz;
+	pi->mcbufsz = pdat ? pdat->mcbuf_sz : 0;
 
 	res = &adev->res;
 	request_mem_region(res->start, resource_size(res), "dma-pl330");
@@ -717,27 +717,35 @@ pl330_probe(struct amba_device *adev, const struct amba_id *id)
 	INIT_LIST_HEAD(&pd->channels);
 
 	/* Initialize channel parameters */
-	for (i = 0; i < pdat->nr_valid_peri; i++) {
-		struct dma_pl330_peri *peri = &pdat->peri[i];
-		pch = &pdmac->peripherals[i];
+	num_chan = max(pdat ? pdat->nr_valid_peri : 0, (u8)pi->pcfg.num_chan);
+	pdmac->peripherals = kzalloc(num_chan * sizeof(*pch), GFP_KERNEL);
 
-		switch (peri->rqtype) {
-		case MEMTOMEM:
+	for (i = 0; i < num_chan; i++) {
+		pch = &pdmac->peripherals[i];
+		if (pdat) {
+			struct dma_pl330_peri *peri = &pdat->peri[i];
+
+			switch (peri->rqtype) {
+			case MEMTOMEM:
+				dma_cap_set(DMA_MEMCPY, pd->cap_mask);
+				break;
+			case MEMTODEV:
+			case DEVTOMEM:
+				dma_cap_set(DMA_SLAVE, pd->cap_mask);
+				break;
+			default:
+				dev_err(&adev->dev, "DEVTODEV Not Supported\n");
+				continue;
+			}
+			pch->chan.private = peri;
+		} else {
 			dma_cap_set(DMA_MEMCPY, pd->cap_mask);
-			break;
-		case MEMTODEV:
-		case DEVTOMEM:
-			dma_cap_set(DMA_SLAVE, pd->cap_mask);
-			break;
-		default:
-			dev_err(&adev->dev, "DEVTODEV Not Supported\n");
-			continue;
+			pch->chan.private = NULL;
 		}
 
 		INIT_LIST_HEAD(&pch->work_list);
 		spin_lock_init(&pch->lock);
 		pch->pl330_chid = NULL;
-		pch->chan.private = peri;
 		pch->chan.device = pd;
 		pch->chan.chan_id = i;
 		pch->dmac = pdmac;
-- 
1.7.4.1

