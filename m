Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757816Ab2DYSs6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 14:48:58 -0400
Received: from smtp-out-106.synserver.de ([212.40.185.106]:1116 "EHLO
	smtp-out-098.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753096Ab2DYSse (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 14:48:34 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 1421
From: Lars-Peter Clausen <lars@metafoo.de>
To: Vinod Koul <vinod.koul@intel.com>, Russell King <linux@arm.linux.org.uk>
Cc: Viresh Kumar <viresh.kumar@st.com>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Shawn Guo <shawn.guo@linaro.org>,
        Javier Martin <javier.martin@vista-silicon.com>,
        Richard Zhao <richard.zhao@linaro.org>,
        Yong Wang <yong.y.wang@intel.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 2/3] dmaengine: Use dma_sg_len(sg) instead of sg->length
Date: Wed, 25 Apr 2012 20:50:52 +0200
Message-Id: <1335379853-10122-2-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1335379853-10122-1-git-send-email-lars@metafoo.de>
References: <1335379853-10122-1-git-send-email-lars@metafoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sg->length may or may not contain the length of the dma region to transfer,
depending on the architecture - dma_sg_len(sg) always will though. For the
architectures which use the drivers modified by this patch it probably is the
case that sg->length contains the dma transfer length. But to be consistent and
future proof change them to use dma_sg_len.

To quote Russel King:
	sg->length is meaningless to something performing DMA.

	In cases where sg_dma_len(sg) and sg->length are the same storage, then
	there's no problem. But scatterlists _can_ (and one some architectures) do
	split them - especially when you have an IOMMU which can allow you to
	combine a scatterlist into fewer entries.

	So, anything using sg->length for the size of a scatterlist's DMA transfer
	_after_ a call to dma_map_sg() is almost certainly buggy.

The patch has been generated using the following coccinelle patch:
<smpl>
@@
struct scatterlist *sg;
expression X;
@@
-sg[X].length
+sg_dma_len(&sg[X])
@@
struct scatterlist *sg;
@@
-sg->length
+sg_dma_len(sg)
</smpl>

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
Compile tested only

Btw. does anybody else think that assigning the dma length like
'dma_sg_len(sg) = len' is kind of odd. It's a macro so it works, but it's not
very C-ish.
---
 drivers/dma/amba-pl08x.c    |    2 +-
 drivers/dma/coh901318.c     |    2 +-
 drivers/dma/imx-dma.c       |   12 ++++++------
 drivers/dma/imx-sdma.c      |    2 +-
 drivers/dma/intel_mid_dma.c |    6 +++---
 drivers/dma/mxs-dma.c       |    6 +++---
 drivers/dma/ste_dma40.c     |    2 +-
 7 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/dma/amba-pl08x.c b/drivers/dma/amba-pl08x.c
index 003220a..49ecbbb 100644
--- a/drivers/dma/amba-pl08x.c
+++ b/drivers/dma/amba-pl08x.c
@@ -1328,7 +1328,7 @@ static struct dma_async_tx_descriptor *pl08x_prep_slave_sg(
 	int ret, tmp;
 
 	dev_dbg(&pl08x->adev->dev, "%s prepare transaction of %d bytes from %s\n",
-			__func__, sgl->length, plchan->name);
+			__func__, sg_dma_len(sgl), plchan->name);
 
 	txd = pl08x_get_txd(plchan, flags);
 	if (!txd) {
diff --git a/drivers/dma/coh901318.c b/drivers/dma/coh901318.c
index dc89455..c0b650c 100644
--- a/drivers/dma/coh901318.c
+++ b/drivers/dma/coh901318.c
@@ -1040,7 +1040,7 @@ coh901318_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
 
 	if (!sgl)
 		goto out;
-	if (sgl->length == 0)
+	if (sg_dma_len(sgl) == 0)
 		goto out;
 
 	spin_lock_irqsave(&cohc->lock, flg);
diff --git a/drivers/dma/imx-dma.c b/drivers/dma/imx-dma.c
index bb787d8..fcfeb3c 100644
--- a/drivers/dma/imx-dma.c
+++ b/drivers/dma/imx-dma.c
@@ -227,7 +227,7 @@ static inline int imxdma_sg_next(struct imxdma_desc *d)
 	struct scatterlist *sg = d->sg;
 	unsigned long now;
 
-	now = min(d->len, sg->length);
+	now = min(d->len, sg_dma_len(sg));
 	if (d->len != IMX_DMA_LENGTH_LOOP)
 		d->len -= now;
 
@@ -763,16 +763,16 @@ static struct dma_async_tx_descriptor *imxdma_prep_slave_sg(
 	desc = list_first_entry(&imxdmac->ld_free, struct imxdma_desc, node);
 
 	for_each_sg(sgl, sg, sg_len, i) {
-		dma_length += sg->length;
+		dma_length += sg_dma_len(sg);
 	}
 
 	switch (imxdmac->word_size) {
 	case DMA_SLAVE_BUSWIDTH_4_BYTES:
-		if (sgl->length & 3 || sgl->dma_address & 3)
+		if (sg_dma_len(sgl) & 3 || sgl->dma_address & 3)
 			return NULL;
 		break;
 	case DMA_SLAVE_BUSWIDTH_2_BYTES:
-		if (sgl->length & 1 || sgl->dma_address & 1)
+		if (sg_dma_len(sgl) & 1 || sgl->dma_address & 1)
 			return NULL;
 		break;
 	case DMA_SLAVE_BUSWIDTH_1_BYTE:
@@ -831,13 +831,13 @@ static struct dma_async_tx_descriptor *imxdma_prep_dma_cyclic(
 		imxdmac->sg_list[i].page_link = 0;
 		imxdmac->sg_list[i].offset = 0;
 		imxdmac->sg_list[i].dma_address = dma_addr;
-		imxdmac->sg_list[i].length = period_len;
+		sg_dma_len(&imxdmac->sg_list[i]) = period_len;
 		dma_addr += period_len;
 	}
 
 	/* close the loop */
 	imxdmac->sg_list[periods].offset = 0;
-	imxdmac->sg_list[periods].length = 0;
+	sg_dma_len(&imxdmac->sg_list[periods]) = 0;
 	imxdmac->sg_list[periods].page_link =
 		((unsigned long)imxdmac->sg_list | 0x01) & ~0x02;
 
diff --git a/drivers/dma/imx-sdma.c b/drivers/dma/imx-sdma.c
index d3e38e2..a5452da 100644
--- a/drivers/dma/imx-sdma.c
+++ b/drivers/dma/imx-sdma.c
@@ -938,7 +938,7 @@ static struct dma_async_tx_descriptor *sdma_prep_slave_sg(
 
 		bd->buffer_addr = sg->dma_address;
 
-		count = sg->length;
+		count = sg_dma_len(sg);
 
 		if (count > 0xffff) {
 			dev_err(sdma->dev, "SDMA channel %d: maximum bytes for sg entry exceeded: %d > %d\n",
diff --git a/drivers/dma/intel_mid_dma.c b/drivers/dma/intel_mid_dma.c
index d0ef593..222e907 100644
--- a/drivers/dma/intel_mid_dma.c
+++ b/drivers/dma/intel_mid_dma.c
@@ -394,7 +394,7 @@ static int midc_lli_fill_sg(struct intel_mid_dma_chan *midc,
 			}
 		}
 		/*Populate CTL_HI values*/
-		ctl_hi.ctlx.block_ts = get_block_ts(sg->length,
+		ctl_hi.ctlx.block_ts = get_block_ts(sg_dma_len(sg),
 							desc->width,
 							midc->dma->block_size);
 		/*Populate SAR and DAR values*/
@@ -747,7 +747,7 @@ static struct dma_async_tx_descriptor *intel_mid_dma_prep_slave_sg(
 			txd = intel_mid_dma_prep_memcpy(chan,
 						mids->dma_slave.dst_addr,
 						mids->dma_slave.src_addr,
-						sgl->length,
+						sg_dma_len(sgl),
 						flags);
 			return txd;
 		} else {
@@ -759,7 +759,7 @@ static struct dma_async_tx_descriptor *intel_mid_dma_prep_slave_sg(
 	pr_debug("MDMA: SG Length = %d, direction = %d, Flags = %#lx\n",
 			sg_len, direction, flags);
 
-	txd = intel_mid_dma_prep_memcpy(chan, 0, 0, sgl->length, flags);
+	txd = intel_mid_dma_prep_memcpy(chan, 0, 0, sg_dma_len(sgl), flags);
 	if (NULL == txd) {
 		pr_err("MDMA: Prep memcpy failed\n");
 		return NULL;
diff --git a/drivers/dma/mxs-dma.c b/drivers/dma/mxs-dma.c
index 655d4ce..3db3a48 100644
--- a/drivers/dma/mxs-dma.c
+++ b/drivers/dma/mxs-dma.c
@@ -415,9 +415,9 @@ static struct dma_async_tx_descriptor *mxs_dma_prep_slave_sg(
 		ccw->bits |= BF_CCW(MXS_DMA_CMD_NO_XFER, COMMAND);
 	} else {
 		for_each_sg(sgl, sg, sg_len, i) {
-			if (sg->length > MAX_XFER_BYTES) {
+			if (sg_dma_len(sg) > MAX_XFER_BYTES) {
 				dev_err(mxs_dma->dma_device.dev, "maximum bytes for sg entry exceeded: %d > %d\n",
-						sg->length, MAX_XFER_BYTES);
+						sg_dma_len(sg), MAX_XFER_BYTES);
 				goto err_out;
 			}
 
@@ -425,7 +425,7 @@ static struct dma_async_tx_descriptor *mxs_dma_prep_slave_sg(
 
 			ccw->next = mxs_chan->ccw_phys + sizeof(*ccw) * idx;
 			ccw->bufaddr = sg->dma_address;
-			ccw->xfer_bytes = sg->length;
+			ccw->xfer_bytes = sg_dma_len(sg);
 
 			ccw->bits = 0;
 			ccw->bits |= CCW_CHAIN;
diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 2ed1ac3..000d309 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -2362,7 +2362,7 @@ dma40_prep_dma_cyclic(struct dma_chan *chan, dma_addr_t dma_addr,
 	}
 
 	sg[periods].offset = 0;
-	sg[periods].length = 0;
+	sg_dma_len(&sg[periods]) = 0;
 	sg[periods].page_link =
 		((unsigned long)sg | 0x01) & ~0x02;
 
-- 
1.7.9.5

