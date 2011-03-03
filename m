Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758085Ab1CCKSv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 05:18:51 -0500
Received: from eu1sys200aog115.obsmtp.com ([207.126.144.139]:47177 "EHLO
	eu1sys200aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758052Ab1CCKSs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 05:18:48 -0500
From: Viresh Kumar <viresh.kumar@st.com>
To: <vinod.koul@intel.com>, <dan.j.williams@intel.com>
Cc: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <viresh.linux@gmail.com>, Viresh KUMAR <viresh.kumar@st.com>,
        <jamie@jamieiles.com>, <armando.visconti@st.com>,
        <shiraz.hashim@st.com>, <amit.goel@st.com>,
        <hans-christian.egtvedt@atmel.com>
Subject: [PATCH V2 11/13] dw_dmac: Allow src/dst msize & flow controller to be configured at runtime
Date: Thu, 3 Mar 2011 15:47:24 +0530
Message-ID: <426996869f6231ebff1cbfab5c7ee4c89ccc8745.1299146382.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <cover.1299146382.git.viresh.kumar@st.com>
References: <cover.1299146382.git.viresh.kumar@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Viresh KUMAR <viresh.kumar@st.com>

Msize or Burst Size is peripheral dependent in case of slave_sg transfers, and
in case of memcpy transfers it is platform dependent. So msize configuration
must come from platform data.

Also some peripherals (ex: JPEG), need to be flow controller for dma transfers,
so this information in case of slave_sg transfers must come from platform data.

Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
---
 drivers/dma/dw_dmac.c      |   10 ++++++----
 drivers/dma/dw_dmac_regs.h |    1 +
 include/linux/dw_dmac.h    |   30 ++++++++++++++++++++++++++++++
 3 files changed, 37 insertions(+), 4 deletions(-)

diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index b1e099e..5f5b28b 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -36,9 +36,11 @@
 		struct dw_dma_slave *__slave = (private);	\
 		int dms = __slave ? __slave->dst_master : 0;	\
 		int sms = __slave ? __slave->src_master : 1;	\
+		u8 smsize = __slave ? __slave->src_msize : 0;	\
+		u8 dmsize = __slave ? __slave->dst_msize : 0;	\
 								\
-		(DWC_CTLL_DST_MSIZE(0)				\
-		 | DWC_CTLL_SRC_MSIZE(0)			\
+		(DWC_CTLL_DST_MSIZE(dmsize)			\
+		 | DWC_CTLL_SRC_MSIZE(smsize)			\
 		 | DWC_CTLL_LLP_D_EN				\
 		 | DWC_CTLL_LLP_S_EN				\
 		 | DWC_CTLL_DMS(dms)				\
@@ -683,7 +685,7 @@ dwc_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
 				| DWC_CTLL_DST_WIDTH(reg_width)
 				| DWC_CTLL_DST_FIX
 				| DWC_CTLL_SRC_INC
-				| DWC_CTLL_FC_M2P);
+				| DWC_CTLL_FC(dws->fc));
 		reg = dws->tx_reg;
 		for_each_sg(sgl, sg, sg_len, i) {
 			struct dw_desc	*desc;
@@ -728,7 +730,7 @@ dwc_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
 				| DWC_CTLL_SRC_WIDTH(reg_width)
 				| DWC_CTLL_DST_INC
 				| DWC_CTLL_SRC_FIX
-				| DWC_CTLL_FC_P2M);
+				| DWC_CTLL_FC(dws->fc));
 
 		reg = dws->rx_reg;
 		for_each_sg(sgl, sg, sg_len, i) {
diff --git a/drivers/dma/dw_dmac_regs.h b/drivers/dma/dw_dmac_regs.h
index 6a8e6d3..9a32964 100644
--- a/drivers/dma/dw_dmac_regs.h
+++ b/drivers/dma/dw_dmac_regs.h
@@ -86,6 +86,7 @@ struct dw_dma_regs {
 #define DWC_CTLL_SRC_MSIZE(n)	((n)<<14)
 #define DWC_CTLL_S_GATH_EN	(1 << 17)	/* src gather, !FIX */
 #define DWC_CTLL_D_SCAT_EN	(1 << 18)	/* dst scatter, !FIX */
+#define DWC_CTLL_FC(n)		((n) << 20)
 #define DWC_CTLL_FC_M2M		(0 << 20)	/* mem-to-mem */
 #define DWC_CTLL_FC_M2P		(1 << 20)	/* mem-to-periph */
 #define DWC_CTLL_FC_P2M		(2 << 20)	/* periph-to-mem */
diff --git a/include/linux/dw_dmac.h b/include/linux/dw_dmac.h
index 3ba2f06..6998d93 100644
--- a/include/linux/dw_dmac.h
+++ b/include/linux/dw_dmac.h
@@ -42,6 +42,30 @@ enum dw_dma_slave_width {
 	DW_DMA_SLAVE_WIDTH_32BIT,
 };
 
+/* bursts size */
+enum dw_dma_msize {
+	DW_DMA_MSIZE_1,
+	DW_DMA_MSIZE_4,
+	DW_DMA_MSIZE_8,
+	DW_DMA_MSIZE_16,
+	DW_DMA_MSIZE_32,
+	DW_DMA_MSIZE_64,
+	DW_DMA_MSIZE_128,
+	DW_DMA_MSIZE_256,
+};
+
+/* flow controller */
+enum dw_dma_fc {
+	DW_DMA_FC_D_M2M,
+	DW_DMA_FC_D_M2P,
+	DW_DMA_FC_D_P2M,
+	DW_DMA_FC_D_P2P,
+	DW_DMA_FC_P_P2M,
+	DW_DMA_FC_SP_P2P,
+	DW_DMA_FC_P_M2P,
+	DW_DMA_FC_DP_P2P,
+};
+
 /**
  * struct dw_dma_slave - Controller-specific information about a slave
  *
@@ -55,6 +79,9 @@ enum dw_dma_slave_width {
  * @cfg_lo: Platform-specific initializer for the CFG_LO register
  * @src_master: src master for transfers on allocated channel.
  * @dst_master: dest master for transfers on allocated channel.
+ * @src_msize: src burst size.
+ * @dst_msize: dest burst size.
+ * @fc: flow controller for DMA transfer
  */
 struct dw_dma_slave {
 	struct device		*dma_dev;
@@ -65,6 +92,9 @@ struct dw_dma_slave {
 	u32			cfg_lo;
 	u8			src_master;
 	u8			dst_master;
+	u8			src_msize;
+	u8			dst_msize;
+	u8			fc;
 };
 
 /* Platform-configurable bits in CFG_HI */
-- 
1.7.2.2

