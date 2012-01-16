Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754061Ab2APJvv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 04:51:51 -0500
Received: from eu1sys200aog109.obsmtp.com ([207.126.144.127]:57962 "EHLO
	eu1sys200aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753958Ab2APJvs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 04:51:48 -0500
From: Viresh Kumar <viresh.kumar@st.com>
To: <vinod.koul@intel.com>, <dan.j.williams@intel.com>
Cc: <linux@arm.linux.org.uk>, <linus.walleij@linaro.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <armando.visconti@st.com>, <shiraz.hashim@st.com>,
        <vipin.kumar@st.com>, <rajeev-dlh.kumar@st.com>, <deepak.sikri@st.com>,
        <vipulkumar.samar@st.com>, <amit.virdi@st.com>, <viresh.kumar@st.com>,
        <pratyush.anand@st.com>, <bhupesh.sharma@st.com>,
        <viresh.linux@gmail.com>, <bhavna.yadav@st.com>,
        <vincenzo.frascino@st.com>, <mirko.gardi@st.com>
Subject: [PATCH 8/8] dmaengine/dw_dmac: Add support for DMA_SLAVE_CONFIG
Date: Mon, 16 Jan 2012 15:20:36 +0530
Message-ID: <7c1e6fd573d5cd348b22f8363c9960fe5efcd658.1326707233.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.8.110.g4cb5d
In-Reply-To: <cover.1326707233.git.viresh.kumar@st.com>
References: <cover.1326707233.git.viresh.kumar@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for DMA_SLAVE_CONFIG in dwc DMAC controller.

Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
---
 drivers/dma/dw_dmac.c      |   78 ++++++++++++++++++++++++++++++++------------
 drivers/dma/dw_dmac_regs.h |    3 ++
 include/linux/dw_dmac.h    |    6 ---
 3 files changed, 60 insertions(+), 27 deletions(-)

diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index c33c06b..6252dce 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -33,12 +33,14 @@
  * which does not support descriptor writeback.
  */
 
-#define DWC_DEFAULT_CTLLO(private) ({				\
-		struct dw_dma_slave *__slave = (private);	\
+#define DWC_DEFAULT_CTLLO(chan) ({				\
+		struct dw_dma_slave *__slave = (chan->private);	\
+		struct dw_dma_chan *dwc = to_dw_dma_chan(chan);	\
+		struct dma_slave_config	*sconfig = &dwc->dma_sconfig;	\
 		int dms = __slave ? __slave->dst_master : 0;	\
 		int sms = __slave ? __slave->src_master : 1;	\
-		u8 smsize = __slave ? __slave->src_msize : DW_DMA_MSIZE_16; \
-		u8 dmsize = __slave ? __slave->dst_msize : DW_DMA_MSIZE_16; \
+		u8 smsize = __slave ? sconfig->src_maxburst : DW_DMA_MSIZE_16; \
+		u8 dmsize = __slave ? sconfig->dst_maxburst : DW_DMA_MSIZE_16; \
 								\
 		(DWC_CTLL_DST_MSIZE(dmsize)			\
 		 | DWC_CTLL_SRC_MSIZE(smsize)			\
@@ -664,7 +666,7 @@ dwc_prep_dma_memcpy(struct dma_chan *chan, dma_addr_t dest, dma_addr_t src,
 	else
 		src_width = dst_width = 0;
 
-	ctllo = DWC_DEFAULT_CTLLO(chan->private)
+	ctllo = DWC_DEFAULT_CTLLO(chan)
 			| DWC_CTLL_DST_WIDTH(dst_width)
 			| DWC_CTLL_SRC_WIDTH(src_width)
 			| DWC_CTLL_DST_INC
@@ -725,6 +727,7 @@ dwc_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
 {
 	struct dw_dma_chan	*dwc = to_dw_dma_chan(chan);
 	struct dw_dma_slave	*dws = chan->private;
+	struct dma_slave_config	*sconfig = &dwc->dma_sconfig;
 	struct dw_desc		*prev;
 	struct dw_desc		*first;
 	u32			ctllo;
@@ -739,17 +742,18 @@ dwc_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
 	if (unlikely(!dws || !sg_len))
 		return NULL;
 
-	reg_width = dws->reg_width;
 	prev = first = NULL;
 
 	switch (direction) {
 	case DMA_MEM_TO_DEV:
-		ctllo = (DWC_DEFAULT_CTLLO(chan->private)
+		reg_width = sconfig->dst_addr_width;
+		reg = sconfig->dst_addr;
+		ctllo = (DWC_DEFAULT_CTLLO(chan)
 				| DWC_CTLL_DST_WIDTH(reg_width)
 				| DWC_CTLL_DST_FIX
 				| DWC_CTLL_SRC_INC
-				| DWC_CTLL_FC(dws->fc));
-		reg = dws->tx_reg;
+				| DWC_CTLL_FC(sconfig->device_fc));
+
 		for_each_sg(sgl, sg, sg_len, i) {
 			struct dw_desc	*desc;
 			u32		len, dlen, mem;
@@ -801,13 +805,14 @@ slave_sg_todev_fill_desc:
 		}
 		break;
 	case DMA_DEV_TO_MEM:
-		ctllo = (DWC_DEFAULT_CTLLO(chan->private)
+		reg_width = sconfig->src_addr_width;
+		reg = sconfig->src_addr;
+		ctllo = (DWC_DEFAULT_CTLLO(chan)
 				| DWC_CTLL_SRC_WIDTH(reg_width)
 				| DWC_CTLL_DST_INC
 				| DWC_CTLL_SRC_FIX
-				| DWC_CTLL_FC(dws->fc));
+				| DWC_CTLL_FC(sconfig->device_fc));
 
-		reg = dws->rx_reg;
 		for_each_sg(sgl, sg, sg_len, i) {
 			struct dw_desc	*desc;
 			u32		len, dlen, mem;
@@ -877,6 +882,29 @@ err_desc_get:
 	return NULL;
 }
 
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
+	/*
+	 * Fix sconfig's burst size according to dw_dmac. We need to convert
+	 * them as: 1 -> 0, 2 -> 1, 4 -> 2, 8 -> 3, 16 -> 4.
+	 *
+	 * This can be done by findiding least significant bit set: n & (n - 1)
+	 */
+	sconfig->src_maxburst &= sconfig->src_maxburst - 1;
+	sconfig->dst_maxburst &= sconfig->dst_maxburst - 1;
+
+	return 0;
+}
+
 static int dwc_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
 		       unsigned long arg)
 {
@@ -926,8 +954,11 @@ static int dwc_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
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
@@ -1168,11 +1199,11 @@ struct dw_cyclic_desc *dw_dma_cyclic_prep(struct dma_chan *chan,
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
@@ -1196,7 +1227,12 @@ struct dw_cyclic_desc *dw_dma_cyclic_prep(struct dma_chan *chan,
 	}
 
 	retval = ERR_PTR(-EINVAL);
-	reg_width = dws->reg_width;
+
+	if (direction == DMA_MEM_TO_DEV)
+		reg_width = sconfig->dst_addr_width;
+	else
+		reg_width = sconfig->src_addr_width;
+
 	periods = buf_len / period_len;
 
 	/* Check for too big/unaligned periods and unaligned DMA buffer. */
@@ -1229,25 +1265,25 @@ struct dw_cyclic_desc *dw_dma_cyclic_prep(struct dma_chan *chan,
 
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
+					| DWC_CTLL_FC(sconfig->device_fc)
 					| DWC_CTLL_INT_EN);
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
+					| DWC_CTLL_FC(sconfig->device_fc)
 					| DWC_CTLL_INT_EN);
 			break;
 		default:
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
diff --git a/include/linux/dw_dmac.h b/include/linux/dw_dmac.h
index f2c64f9..67271d8 100644
--- a/include/linux/dw_dmac.h
+++ b/include/linux/dw_dmac.h
@@ -86,16 +86,10 @@ enum dw_dma_fc {
  */
 struct dw_dma_slave {
 	struct device		*dma_dev;
-	dma_addr_t		tx_reg;
-	dma_addr_t		rx_reg;
-	enum dw_dma_slave_width	reg_width;
 	u32			cfg_hi;
 	u32			cfg_lo;
 	u8			src_master;
 	u8			dst_master;
-	u8			src_msize;
-	u8			dst_msize;
-	u8			fc;
 };
 
 /* Platform-configurable bits in CFG_HI */
-- 
1.7.8.110.g4cb5d

