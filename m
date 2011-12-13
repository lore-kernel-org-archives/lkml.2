Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753739Ab1LMIsN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 03:48:13 -0500
Received: from eu1sys200aog104.obsmtp.com ([207.126.144.117]:56355 "EHLO
	eu1sys200aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752543Ab1LMIsK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 03:48:10 -0500
From: Pratyush Anand <pratyush.anand@st.com>
To: <linus.walleij@linaro.org>
Cc: <mirko.gardi@st.com>, <Vincenzo.FRASCINO@st.com>, <bhavna.yadav@st.com>,
        <bhupesh.sharma@st.com>, <Amit.VIRDI@st.com>,
        <vipulkumar.samar@st.com>, <deepak.sikri@st.com>,
        <rajeev-dlh.kumar@st.com>, <vipin.kumar@st.com>,
        <shiraz.hashim@st.com>, <armando.visconti@st.com>,
        <vinod.koul@intel.com>, <dan.j.williams@intel.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux@arm.linux.org.uk>, Pratyush Anand <pratyush.anand@st.com>
Subject: [PATCH] dmaengine/dw_dmac: Add support for device_prep_dma_sg
Date: Tue, 13 Dec 2011 14:17:44 +0530
Message-ID: <1323766064-13425-1-git-send-email-pratyush.anand@st.com>
X-Mailer: git-send-email 1.7.2.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Memory to memory copy with scatter gather option has been implemented in
this patch. Driver can manage even if number of nodes in src and dst
list is different.

Signed-off-by: Pratyush Anand <pratyush.anand@st.com>
---
 drivers/dma/dw_dmac.c |  135 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 135 insertions(+), 0 deletions(-)

diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index 96b2750..c1c78c1 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -729,6 +729,140 @@ err_desc_get:
 }
 
 static struct dma_async_tx_descriptor *
+dwc_prep_dma_sg(struct dma_chan *chan,
+	    struct scatterlist *dsgl, unsigned int dst_nents,
+	    struct scatterlist *ssgl, unsigned int src_nents,
+	    unsigned long flags)
+{
+	struct dw_dma_chan *dwc = to_dw_dma_chan(chan);
+	struct dw_desc *desc;
+	struct dw_desc *first;
+	struct dw_desc *prev;
+	size_t xfer_count;
+	size_t offset;
+	unsigned int src_width;
+	unsigned int dst_width;
+	u32 ctllo;
+	struct scatterlist *dsg, *ssg;
+	dma_addr_t src = 0, dst = 0;
+	unsigned int slen = 0, dlen = 0, total_len = 0;
+	unsigned int i, nents, len = 0, incs, si = 0, di = 0;
+
+	if (unlikely(!src_nents))
+		return NULL;
+
+	if (unlikely(!dst_nents))
+		return NULL;
+
+	prev = first = NULL;
+
+	dsg = dsgl;
+	ssg = ssgl;
+	nents = max(src_nents, dst_nents);
+
+	if (nents == src_nents)
+		incs = true;
+	else
+		incs = false;
+
+	for (i = 0; i < nents;) {
+		if (!slen) {
+			src = sg_dma_address(ssg);
+			slen = sg_dma_len(ssg);
+			ssg = sg_next(ssg);
+			if (!ssg && si < src_nents - 1)
+				goto err_sg_len;
+			si++;
+		} else
+			src += len;
+
+		if (!dlen) {
+			dst = sg_dma_address(dsg);
+			dlen = sg_dma_len(dsg);
+			dsg = sg_next(dsg);
+			if (!dsg && di < dst_nents - 1)
+				goto err_sg_len;
+			di++;
+		} else
+			dst += len;
+
+		if (incs)
+			i = si;
+		else
+			i = di;
+		len = min(slen, dlen);
+		slen -= len;
+		dlen -= len;
+
+		if (!((src | dst | len) & 7))
+			src_width = dst_width = 3;
+		else if (!((src | dst | len) & 3))
+			src_width = dst_width = 2;
+		else if (!((src | dst | len) & 1))
+			src_width = dst_width = 1;
+		else
+			src_width = dst_width = 0;
+
+		ctllo = DWC_DEFAULT_CTLLO(chan->private)
+			| DWC_CTLL_DST_WIDTH(dst_width)
+			| DWC_CTLL_SRC_WIDTH(src_width)
+			| DWC_CTLL_DST_INC
+			| DWC_CTLL_SRC_INC
+			| DWC_CTLL_FC_M2M;
+
+		offset = 0;
+		while ((len - offset) > 0) {
+
+			xfer_count = min_t(size_t, (len - offset) >> dst_width,
+					DWC_MAX_COUNT);
+
+			desc = dwc_desc_get(dwc);
+			if (!desc)
+				goto err_desc_get;
+
+			desc->lli.sar = src + offset;
+			desc->lli.dar = dst + offset;
+			desc->lli.ctllo = ctllo;
+			desc->lli.ctlhi = xfer_count;
+
+			if (!first) {
+				first = desc;
+			} else {
+				prev->lli.llp = desc->txd.phys;
+				dma_sync_single_for_device(chan2parent(chan),
+						prev->txd.phys,
+						sizeof(prev->lli),
+						DMA_TO_DEVICE);
+				list_add_tail(&desc->desc_node,
+						&first->tx_list);
+			}
+			prev = desc;
+			offset += xfer_count << dst_width;
+		}
+		total_len += len;
+	}
+
+	if (flags & DMA_PREP_INTERRUPT)
+		/* Trigger interrupt after last block */
+		prev->lli.ctllo |= DWC_CTLL_INT_EN;
+
+	prev->lli.llp = 0;
+	dma_sync_single_for_device(chan2parent(chan),
+			prev->txd.phys, sizeof(prev->lli),
+			DMA_TO_DEVICE);
+
+	first->txd.flags = flags;
+	first->len = total_len;
+
+	return &first->txd;
+
+err_sg_len:
+err_desc_get:
+	dwc_desc_put(dwc, first);
+	return NULL;
+}
+
+static struct dma_async_tx_descriptor *
 dwc_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
 		unsigned int sg_len, enum dma_transfer_direction direction,
 		unsigned long flags)
@@ -1471,6 +1605,7 @@ static int __init dw_probe(struct platform_device *pdev)
 	dw->dma.device_free_chan_resources = dwc_free_chan_resources;
 
 	dw->dma.device_prep_dma_memcpy = dwc_prep_dma_memcpy;
+	dw->dma.device_prep_dma_sg = dwc_prep_dma_sg;
 
 	dw->dma.device_prep_slave_sg = dwc_prep_slave_sg;
 	dw->dma.device_control = dwc_control;
-- 
1.7.2.2

