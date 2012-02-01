Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756216Ab2BAKwf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 05:52:35 -0500
Received: from eu1sys200aog112.obsmtp.com ([207.126.144.133]:58931 "EHLO
	eu1sys200aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756185Ab2BAKwb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 05:52:31 -0500
From: Viresh Kumar <viresh.kumar@st.com>
To: <vinod.koul@intel.com>, <dan.j.williams@intel.com>
Cc: <cjb@laptop.org>, <rmk+kernel@arm.linux.org.uk>,
        <linus.walleij@linaro.org>, <ulf.hansson@stericsson.com>,
        <linux-mmc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <egtvedt@samfundet.no>, <hskinnemoen@gmail.com>,
        <kernel@pengutronix.de>, <perex@perex.cz>,
        <linux-arm-kernel@lists.infradead.org>, <armando.visconti@st.com>,
        <shiraz.hashim@st.com>, <vipin.kumar@st.com>,
        <rajeev-dlh.kumar@st.com>, <deepak.sikri@st.com>,
        <vipulkumar.samar@st.com>, <amit.virdi@st.com>, <viresh.kumar@st.com>,
        <pratyush.anand@st.com>, <bhupesh.sharma@st.com>,
        <viresh.linux@gmail.com>, <bhavna.yadav@st.com>,
        <vincenzo.frascino@st.com>, <mirko.gardi@st.com>
Subject: [PATCH V3 10/12] dmaengine/dw_dmac: Add support for DMA_SLAVE_CONFIG
Date: Wed, 1 Feb 2012 16:12:26 +0530
Message-ID: <3671d82ede6627489b4eb6ebec19dd7a46ae256f.1328091915.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.8.110.g4cb5d
In-Reply-To: <cover.1328091915.git.viresh.kumar@st.com>
References: <cover.1328091915.git.viresh.kumar@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for DMA_SLAVE_CONFIG in dwc DMAC controller. Fields in
struct dw_dma_slave for passing similar data are preserved in this patch untill
all existing users are fixed.

That will be handled later in this patchset.

Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
---
 drivers/dma/dw_dmac.c      |  119 +++++++++++++++++++++++++++++++++-----------
 drivers/dma/dw_dmac_regs.h |    3 +
 2 files changed, 93 insertions(+), 29 deletions(-)

diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index 44d8069..ccfb03b 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -9,6 +9,7 @@
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
  */
+#include <linux/bitops.h>
 #include <linux/clk.h>
 #include <linux/delay.h>
 #include <linux/dmaengine.h>
@@ -33,19 +34,23 @@
  * which does not support descriptor writeback.
  */
 
-#define DWC_DEFAULT_CTLLO(private) ({				\
-		struct dw_dma_slave *__slave = (private);	\
-		int dms = __slave ? __slave->dst_master : 0;	\
-		int sms = __slave ? __slave->src_master : 1;	\
-		u8 smsize = __slave ? __slave->src_msize : DW_DMA_MSIZE_16; \
-		u8 dmsize = __slave ? __slave->dst_msize : DW_DMA_MSIZE_16; \
+#define DWC_DEFAULT_CTLLO(_chan) ({				\
+		struct dw_dma_slave *__slave = (_chan->private);	\
+		struct dw_dma_chan *_dwc = to_dw_dma_chan(_chan);	\
+		struct dma_slave_config	*_sconfig = &_dwc->dma_sconfig;	\
+		int _dms = __slave ? __slave->dst_master : 0;	\
+		int _sms = __slave ? __slave->src_master : 1;	\
+		u8 _smsize = __slave ? _sconfig->src_maxburst :	\
+			DW_DMA_MSIZE_16;			\
+		u8 _dmsize = __slave ? _sconfig->dst_maxburst :	\
+			DW_DMA_MSIZE_16;			\
 								\
-		(DWC_CTLL_DST_MSIZE(dmsize)			\
-		 | DWC_CTLL_SRC_MSIZE(smsize)			\
+		(DWC_CTLL_DST_MSIZE(_dmsize)			\
+		 | DWC_CTLL_SRC_MSIZE(_smsize)			\
 		 | DWC_CTLL_LLP_D_EN				\
 		 | DWC_CTLL_LLP_S_EN				\
-		 | DWC_CTLL_DMS(dms)				\
-		 | DWC_CTLL_SMS(sms));				\
+		 | DWC_CTLL_DMS(_dms)				\
+		 | DWC_CTLL_SMS(_sms));				\
 	})
 
 /*
@@ -664,7 +669,7 @@ dwc_prep_dma_memcpy(struct dma_chan *chan, dma_addr_t dest, dma_addr_t src,
 	else
 		src_width = dst_width = 0;
 
-	ctllo = DWC_DEFAULT_CTLLO(chan->private)
+	ctllo = DWC_DEFAULT_CTLLO(chan)
 			| DWC_CTLL_DST_WIDTH(dst_width)
 			| DWC_CTLL_SRC_WIDTH(src_width)
 			| DWC_CTLL_DST_INC
@@ -725,6 +730,7 @@ dwc_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
 {
 	struct dw_dma_chan	*dwc = to_dw_dma_chan(chan);
 	struct dw_dma_slave	*dws = chan->private;
+	struct dma_slave_config	*sconfig = &dwc->dma_sconfig;
 	struct dw_desc		*prev;
 	struct dw_desc		*first;
 	u32			ctllo;
@@ -739,17 +745,20 @@ dwc_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
 	if (unlikely(!dws || !sg_len))
 		return NULL;
 
-	reg_width = dws->reg_width;
 	prev = first = NULL;
 
 	switch (direction) {
 	case DMA_MEM_TO_DEV:
-		ctllo = (DWC_DEFAULT_CTLLO(chan->private)
+		reg_width = __fls(sconfig->dst_addr_width);
+		reg = sconfig->dst_addr;
+		ctllo = (DWC_DEFAULT_CTLLO(chan)
 				| DWC_CTLL_DST_WIDTH(reg_width)
 				| DWC_CTLL_DST_FIX
-				| DWC_CTLL_SRC_INC
-				| DWC_CTLL_FC(dws->fc));
-		reg = dws->tx_reg;
+				| DWC_CTLL_SRC_INC);
+
+		ctllo |= sconfig->device_fc ? DWC_CTLL_FC(DW_DMA_FC_P_M2P) :
+			DWC_CTLL_FC(DW_DMA_FC_D_M2P);
+
 		for_each_sg(sgl, sg, sg_len, i) {
 			struct dw_desc	*desc;
 			u32		len, dlen, mem;
@@ -807,13 +816,16 @@ slave_sg_todev_fill_desc:
 		}
 		break;
 	case DMA_DEV_TO_MEM:
-		ctllo = (DWC_DEFAULT_CTLLO(chan->private)
+		reg_width = __fls(sconfig->src_addr_width);
+		reg = sconfig->src_addr;
+		ctllo = (DWC_DEFAULT_CTLLO(chan)
 				| DWC_CTLL_SRC_WIDTH(reg_width)
 				| DWC_CTLL_DST_INC
-				| DWC_CTLL_SRC_FIX
-				| DWC_CTLL_FC(dws->fc));
+				| DWC_CTLL_SRC_FIX);
+
+		ctllo |= sconfig->device_fc ? DWC_CTLL_FC(DW_DMA_FC_P_P2M) :
+			DWC_CTLL_FC(DW_DMA_FC_D_P2M);
 
-		reg = dws->rx_reg;
 		for_each_sg(sgl, sg, sg_len, i) {
 			struct dw_desc	*desc;
 			u32		len, dlen, mem;
@@ -889,6 +901,39 @@ err_desc_get:
 	return NULL;
 }
 
+/*
+ * Fix sconfig's burst size according to dw_dmac. We need to convert them as:
+ * 1 -> 0, 4 -> 1, 8 -> 2, 16 -> 3.
+ *
+ * NOTE: burst size 2 is not supported by controller.
+ *
+ * This can be done by finding least significant bit set: n & (n - 1)
+ */
+static inline void convert_burst(u32 *maxburst)
+{
+	if (*maxburst > 1)
+		*maxburst = fls(*maxburst) - 2;
+	else
+		*maxburst = 0;
+}
+
+static int
+set_runtime_config(struct dma_chan *chan, struct dma_slave_config *sconfig)
+{
+	struct dw_dma_chan *dwc = to_dw_dma_chan(chan);
+
+	/* Check if it is chan is configured for slave transfers */
+	if (!chan->private)
+		return -EINVAL;
+
+	memcpy(&dwc->dma_sconfig, sconfig, sizeof(*sconfig));
+
+	convert_burst(&dwc->dma_sconfig.src_maxburst);
+	convert_burst(&dwc->dma_sconfig.dst_maxburst);
+
+	return 0;
+}
+
 static int dwc_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
 		       unsigned long arg)
 {
@@ -938,8 +983,11 @@ static int dwc_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
 		/* Flush all pending and queued descriptors */
 		list_for_each_entry_safe(desc, _desc, &list, desc_node)
 			dwc_descriptor_complete(dwc, desc, false);
-	} else
+	} else if (cmd == DMA_SLAVE_CONFIG) {
+		return set_runtime_config(chan, (struct dma_slave_config *)arg);
+	} else {
 		return -ENXIO;
+	}
 
 	return 0;
 }
@@ -1180,11 +1228,11 @@ struct dw_cyclic_desc *dw_dma_cyclic_prep(struct dma_chan *chan,
 		enum dma_transfer_direction direction)
 {
 	struct dw_dma_chan		*dwc = to_dw_dma_chan(chan);
+	struct dma_slave_config		*sconfig = &dwc->dma_sconfig;
 	struct dw_cyclic_desc		*cdesc;
 	struct dw_cyclic_desc		*retval = NULL;
 	struct dw_desc			*desc;
 	struct dw_desc			*last = NULL;
-	struct dw_dma_slave		*dws = chan->private;
 	unsigned long			was_cyclic;
 	unsigned int			reg_width;
 	unsigned int			periods;
@@ -1208,7 +1256,12 @@ struct dw_cyclic_desc *dw_dma_cyclic_prep(struct dma_chan *chan,
 	}
 
 	retval = ERR_PTR(-EINVAL);
-	reg_width = dws->reg_width;
+
+	if (direction == DMA_MEM_TO_DEV)
+		reg_width = __ffs(sconfig->dst_addr_width);
+	else
+		reg_width = __ffs(sconfig->src_addr_width);
+
 	periods = buf_len / period_len;
 
 	/* Check for too big/unaligned periods and unaligned DMA buffer. */
@@ -1241,26 +1294,34 @@ struct dw_cyclic_desc *dw_dma_cyclic_prep(struct dma_chan *chan,
 
 		switch (direction) {
 		case DMA_MEM_TO_DEV:
-			desc->lli.dar = dws->tx_reg;
+			desc->lli.dar = sconfig->dst_addr;
 			desc->lli.sar = buf_addr + (period_len * i);
-			desc->lli.ctllo = (DWC_DEFAULT_CTLLO(chan->private)
+			desc->lli.ctllo = (DWC_DEFAULT_CTLLO(chan)
 					| DWC_CTLL_DST_WIDTH(reg_width)
 					| DWC_CTLL_SRC_WIDTH(reg_width)
 					| DWC_CTLL_DST_FIX
 					| DWC_CTLL_SRC_INC
-					| DWC_CTLL_FC(dws->fc)
 					| DWC_CTLL_INT_EN);
+
+			desc->lli.ctllo |= sconfig->device_fc ?
+				DWC_CTLL_FC(DW_DMA_FC_P_M2P) :
+				DWC_CTLL_FC(DW_DMA_FC_D_M2P);
+
 			break;
 		case DMA_DEV_TO_MEM:
 			desc->lli.dar = buf_addr + (period_len * i);
-			desc->lli.sar = dws->rx_reg;
-			desc->lli.ctllo = (DWC_DEFAULT_CTLLO(chan->private)
+			desc->lli.sar = sconfig->src_addr;
+			desc->lli.ctllo = (DWC_DEFAULT_CTLLO(chan)
 					| DWC_CTLL_SRC_WIDTH(reg_width)
 					| DWC_CTLL_DST_WIDTH(reg_width)
 					| DWC_CTLL_DST_INC
 					| DWC_CTLL_SRC_FIX
-					| DWC_CTLL_FC(dws->fc)
 					| DWC_CTLL_INT_EN);
+
+			desc->lli.ctllo |= sconfig->device_fc ?
+				DWC_CTLL_FC(DW_DMA_FC_P_P2M) :
+				DWC_CTLL_FC(DW_DMA_FC_D_P2M);
+
 			break;
 		default:
 			break;
diff --git a/drivers/dma/dw_dmac_regs.h b/drivers/dma/dw_dmac_regs.h
index 5eef694..2005d30 100644
--- a/drivers/dma/dw_dmac_regs.h
+++ b/drivers/dma/dw_dmac_regs.h
@@ -153,6 +153,9 @@ struct dw_dma_chan {
 	struct dw_cyclic_desc	*cdesc;
 
 	unsigned int		descs_allocated;
+
+	/* configuration passed via DMA_SLAVE_CONFIG */
+	struct dma_slave_config dma_sconfig;
 };
 
 static inline struct dw_dma_chan_regs __iomem *
-- 
1.7.8.110.g4cb5d

