Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756245Ab1DVQfP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 12:35:15 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:3741 "EHLO sjogate2.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756180Ab1DVQfI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 12:35:08 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: vinod.koul@intel.com, dan.j.williams@intel.com,
        linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH v2 5/5] dmaengine: at_hdmac: specialize AHB interfaces to optimize transfers
Date: Fri, 22 Apr 2011 19:42:01 +0200
Message-Id: <9cbba05f53a75eab5576f4a9d0383d6f3d4ada66.1303493836.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.3
In-Reply-To: <3ee5a0e314a22339ad7a15a5425045f5ed244eab.1301678094.git.nicolas.ferre@atmel.com>
References: <3ee5a0e314a22339ad7a15a5425045f5ed244eab.1301678094.git.nicolas.ferre@atmel.com>
In-Reply-To: <3ee5a0e314a22339ad7a15a5425045f5ed244eab.1303493836.git.nicolas.ferre@atmel.com>
References: <3ee5a0e314a22339ad7a15a5425045f5ed244eab.1303493836.git.nicolas.ferre@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DMA controller has two AHB interfaces on the SOC internal
matrix.
It is more efficient to specialize each interface as the
access to memory can introduce latencies that are not compatible
with peripheral accesses requirements.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 drivers/dma/at_hdmac.c      |   21 ++++++++++-----------
 drivers/dma/at_hdmac_regs.h |    2 ++
 2 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/dma/at_hdmac.c b/drivers/dma/at_hdmac.c
index 65bd52a..73c2e99 100644
--- a/drivers/dma/at_hdmac.c
+++ b/drivers/dma/at_hdmac.c
@@ -37,8 +37,7 @@
 
 #define	ATC_DEFAULT_CFG		(ATC_FIFOCFG_HALFFIFO)
 #define	ATC_DEFAULT_CTRLA	(0)
-#define	ATC_DEFAULT_CTRLB	(ATC_SIF(0)	\
-				|ATC_DIF(1))
+#define	ATC_DEFAULT_CTRLB	(ATC_SIF(MEM_IF) | ATC_DIF(MEM_IF))
 
 /*
  * Initial number of descriptors to allocate for each channel. This could
@@ -693,14 +692,14 @@ atc_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
 	reg_width = atslave->reg_width;
 
 	ctrla = ATC_DEFAULT_CTRLA | atslave->ctrla;
-	ctrlb = ATC_DEFAULT_CTRLB | ATC_IEN;
+	ctrlb = ATC_IEN;
 
 	switch (direction) {
 	case DMA_TO_DEVICE:
 		ctrla |=  ATC_DST_WIDTH(reg_width);
 		ctrlb |=  ATC_DST_ADDR_MODE_FIXED
 			| ATC_SRC_ADDR_MODE_INCR
-			| ATC_FC_MEM2PER;
+			| ATC_FC_MEM2PER | ATC_SIF(MEM_IF) | ATC_DIF(PER_IF);
 		reg = atslave->tx_reg;
 		for_each_sg(sgl, sg, sg_len, i) {
 			struct at_desc	*desc;
@@ -741,7 +740,7 @@ atc_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
 		ctrla |=  ATC_SRC_WIDTH(reg_width);
 		ctrlb |=  ATC_DST_ADDR_MODE_INCR
 			| ATC_SRC_ADDR_MODE_FIXED
-			| ATC_FC_PER2MEM;
+			| ATC_FC_PER2MEM | ATC_SIF(PER_IF) | ATC_DIF(MEM_IF);
 
 		reg = atslave->rx_reg;
 		for_each_sg(sgl, sg, sg_len, i) {
@@ -846,20 +845,20 @@ atc_dma_cyclic_fill_desc(struct at_dma_slave *atslave, struct at_desc *desc,
 		desc->lli.saddr = buf_addr + (period_len * period_index);
 		desc->lli.daddr = atslave->tx_reg;
 		desc->lli.ctrla = ctrla;
-		desc->lli.ctrlb = ATC_DEFAULT_CTRLB
-				| ATC_DST_ADDR_MODE_FIXED
+		desc->lli.ctrlb = ATC_DST_ADDR_MODE_FIXED
 				| ATC_SRC_ADDR_MODE_INCR
-				| ATC_FC_MEM2PER;
+				| ATC_FC_MEM2PER
+				| ATC_SIF(MEM_IF) | ATC_DIF(PER_IF);
 		break;
 
 	case DMA_FROM_DEVICE:
 		desc->lli.saddr = atslave->rx_reg;
 		desc->lli.daddr = buf_addr + (period_len * period_index);
 		desc->lli.ctrla = ctrla;
-		desc->lli.ctrlb = ATC_DEFAULT_CTRLB
-				| ATC_DST_ADDR_MODE_INCR
+		desc->lli.ctrlb = ATC_DST_ADDR_MODE_INCR
 				| ATC_SRC_ADDR_MODE_FIXED
-				| ATC_FC_PER2MEM;
+				| ATC_FC_PER2MEM
+				| ATC_SIF(PER_IF) | ATC_DIF(MEM_IF);
 		break;
 
 	default:
diff --git a/drivers/dma/at_hdmac_regs.h b/drivers/dma/at_hdmac_regs.h
index c79a9e0..9afcb8d 100644
--- a/drivers/dma/at_hdmac_regs.h
+++ b/drivers/dma/at_hdmac_regs.h
@@ -103,6 +103,8 @@
 /* Bitfields in CTRLB */
 #define	ATC_SIF(i)		(0x3 & (i))	/* Src tx done via AHB-Lite Interface i */
 #define	ATC_DIF(i)		((0x3 & (i)) <<  4)	/* Dst tx done via AHB-Lite Interface i */
+#define MEM_IF			0		/* specify AHB interface 0 as memory interface */
+#define PER_IF			1		/* specify AHB interface 1 as peripheral interface */
 #define	ATC_SRC_PIP		(0x1 <<  8)	/* Source Picture-in-Picture enabled */
 #define	ATC_DST_PIP		(0x1 << 12)	/* Destination Picture-in-Picture enabled */
 #define	ATC_SRC_DSCR_DIS	(0x1 << 16)	/* Src Descriptor fetch disable */
-- 
1.7.3

