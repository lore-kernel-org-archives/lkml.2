Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754987Ab1DZFin (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 01:38:43 -0400
Received: from eu1sys200aog101.obsmtp.com ([207.126.144.111]:54408 "EHLO
	eu1sys200aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754291Ab1DZFig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 01:38:36 -0400
From: Viresh Kumar <viresh.kumar@st.com>
To: <vinod.koul@intel.com>, <dan.j.williams@intel.com>
Cc: <linux-kernel@vger.kernel.org>, <armando.visconti@st.com>,
        <shiraz.hashim@st.com>, Viresh Kumar <viresh.kumar@st.com>
Subject: [PATCH V2 resend 6/7] dmaengine/dw_dmac: Divide one sg to many desc, if sg len is greater than DWC_MAX_COUNT
Date: Tue, 26 Apr 2011 11:08:14 +0530
Message-ID: <0daaab4a63094e1c7b1d0f9bececfe7a3e1fbdf4.1303796005.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <cover.1303796005.git.viresh.kumar@st.com>
References: <cover.1303796005.git.viresh.kumar@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If len passed in sg for slave_sg transfers is greater than DWC_MAX_COUNT, then
driver programmes controller incorrectly.  This patch adds code to handle this
situation by allocation more than one desc for same sg.

Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
---
 drivers/dma/dw_dmac.c |   65 +++++++++++++++++++++++++++++++++----------------
 1 files changed, 44 insertions(+), 21 deletions(-)

diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index 211728c..858505b 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -697,9 +697,15 @@ dwc_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
 		reg = dws->tx_reg;
 		for_each_sg(sgl, sg, sg_len, i) {
 			struct dw_desc	*desc;
-			u32		len;
-			u32		mem;
+			u32		len, dlen, mem;
 
+			mem = sg_phys(sg);
+			len = sg_dma_len(sg);
+			mem_width = 2;
+			if (unlikely(mem & 3 || len & 3))
+				mem_width = 0;
+
+slave_sg_todev_fill_desc:
 			desc = dwc_desc_get(dwc);
 			if (!desc) {
 				dev_err(chan2dev(chan),
@@ -707,16 +713,19 @@ dwc_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
 				goto err_desc_get;
 			}
 
-			mem = sg_phys(sg);
-			len = sg_dma_len(sg);
-			mem_width = 2;
-			if (unlikely(mem & 3 || len & 3))
-				mem_width = 0;
-
 			desc->lli.sar = mem;
 			desc->lli.dar = reg;
 			desc->lli.ctllo = ctllo | DWC_CTLL_SRC_WIDTH(mem_width);
-			desc->lli.ctlhi = len >> mem_width;
+			if ((len >> mem_width) > DWC_MAX_COUNT) {
+				dlen = DWC_MAX_COUNT << mem_width;
+				mem += dlen;
+				len -= dlen;
+			} else {
+				dlen = len;
+				len = 0;
+			}
+
+			desc->lli.ctlhi = dlen >> mem_width;
 
 			if (!first) {
 				first = desc;
@@ -730,7 +739,10 @@ dwc_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
 						&first->tx_list);
 			}
 			prev = desc;
-			total_len += len;
+			total_len += dlen;
+
+			if (len)
+				goto slave_sg_todev_fill_desc;
 		}
 		break;
 	case DMA_FROM_DEVICE:
@@ -743,15 +755,7 @@ dwc_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
 		reg = dws->rx_reg;
 		for_each_sg(sgl, sg, sg_len, i) {
 			struct dw_desc	*desc;
-			u32		len;
-			u32		mem;
-
-			desc = dwc_desc_get(dwc);
-			if (!desc) {
-				dev_err(chan2dev(chan),
-					"not enough descriptors available\n");
-				goto err_desc_get;
-			}
+			u32		len, dlen, mem;
 
 			mem = sg_phys(sg);
 			len = sg_dma_len(sg);
@@ -759,10 +763,26 @@ dwc_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
 			if (unlikely(mem & 3 || len & 3))
 				mem_width = 0;
 
+slave_sg_fromdev_fill_desc:
+			desc = dwc_desc_get(dwc);
+			if (!desc) {
+				dev_err(chan2dev(chan),
+						"not enough descriptors available\n");
+				goto err_desc_get;
+			}
+
 			desc->lli.sar = reg;
 			desc->lli.dar = mem;
 			desc->lli.ctllo = ctllo | DWC_CTLL_DST_WIDTH(mem_width);
-			desc->lli.ctlhi = len >> reg_width;
+			if ((len >> reg_width) > DWC_MAX_COUNT) {
+				dlen = DWC_MAX_COUNT << reg_width;
+				mem += dlen;
+				len -= dlen;
+			} else {
+				dlen = len;
+				len = 0;
+			}
+			desc->lli.ctlhi = dlen >> reg_width;
 
 			if (!first) {
 				first = desc;
@@ -776,7 +796,10 @@ dwc_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
 						&first->tx_list);
 			}
 			prev = desc;
-			total_len += len;
+			total_len += dlen;
+
+			if (len)
+				goto slave_sg_fromdev_fill_desc;
 		}
 		break;
 	default:
-- 
1.7.2.2

