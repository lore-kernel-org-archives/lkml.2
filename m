Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932400Ab1CCRzO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 12:55:14 -0500
Received: from ovro.ovro.caltech.edu ([192.100.16.2]:38991 "EHLO
	ovro.ovro.caltech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932343Ab1CCRzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 12:55:09 -0500
From: "Ira W. Snyder" <iws@ovro.caltech.edu>
To: linuxppc-dev@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org, leoli@freescale.com,
        dan.j.williams@intel.com, "Ira W. Snyder" <iws@ovro.caltech.edu>
Subject: [PATCH v3 2/9] fsldma: move related helper functions near each other
Date: Thu,  3 Mar 2011 09:54:54 -0800
Message-Id: <1299174901-16762-3-git-send-email-iws@ovro.caltech.edu>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1299174901-16762-1-git-send-email-iws@ovro.caltech.edu>
References: <1299174901-16762-1-git-send-email-iws@ovro.caltech.edu>
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (ovro.ovro.caltech.edu); Thu, 03 Mar 2011 09:55:08 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a purely cosmetic cleanup. It is nice to have related functions
right next to each other in the code.

Signed-off-by: Ira W. Snyder <iws@ovro.caltech.edu>
---
 drivers/dma/fsldma.c |  116 +++++++++++++++++++++++++++----------------------
 1 files changed, 64 insertions(+), 52 deletions(-)

diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
index 4de947a..2e1af45 100644
--- a/drivers/dma/fsldma.c
+++ b/drivers/dma/fsldma.c
@@ -39,33 +39,9 @@
 
 static const char msg_ld_oom[] = "No free memory for link descriptor\n";
 
-static void dma_init(struct fsldma_chan *chan)
-{
-	/* Reset the channel */
-	DMA_OUT(chan, &chan->regs->mr, 0, 32);
-
-	switch (chan->feature & FSL_DMA_IP_MASK) {
-	case FSL_DMA_IP_85XX:
-		/* Set the channel to below modes:
-		 * EIE - Error interrupt enable
-		 * EOSIE - End of segments interrupt enable (basic mode)
-		 * EOLNIE - End of links interrupt enable
-		 * BWC - Bandwidth sharing among channels
-		 */
-		DMA_OUT(chan, &chan->regs->mr, FSL_DMA_MR_BWC
-				| FSL_DMA_MR_EIE | FSL_DMA_MR_EOLNIE
-				| FSL_DMA_MR_EOSIE, 32);
-		break;
-	case FSL_DMA_IP_83XX:
-		/* Set the channel to below modes:
-		 * EOTIE - End-of-transfer interrupt enable
-		 * PRC_RM - PCI read multiple
-		 */
-		DMA_OUT(chan, &chan->regs->mr, FSL_DMA_MR_EOTIE
-				| FSL_DMA_MR_PRC_RM, 32);
-		break;
-	}
-}
+/*
+ * Register Helpers
+ */
 
 static void set_sr(struct fsldma_chan *chan, u32 val)
 {
@@ -77,6 +53,30 @@ static u32 get_sr(struct fsldma_chan *chan)
 	return DMA_IN(chan, &chan->regs->sr, 32);
 }
 
+static void set_cdar(struct fsldma_chan *chan, dma_addr_t addr)
+{
+	DMA_OUT(chan, &chan->regs->cdar, addr | FSL_DMA_SNEN, 64);
+}
+
+static dma_addr_t get_cdar(struct fsldma_chan *chan)
+{
+	return DMA_IN(chan, &chan->regs->cdar, 64) & ~FSL_DMA_SNEN;
+}
+
+static dma_addr_t get_ndar(struct fsldma_chan *chan)
+{
+	return DMA_IN(chan, &chan->regs->ndar, 64);
+}
+
+static u32 get_bcr(struct fsldma_chan *chan)
+{
+	return DMA_IN(chan, &chan->regs->bcr, 32);
+}
+
+/*
+ * Descriptor Helpers
+ */
+
 static void set_desc_cnt(struct fsldma_chan *chan,
 				struct fsl_dma_ld_hw *hw, u32 count)
 {
@@ -113,24 +113,49 @@ static void set_desc_next(struct fsldma_chan *chan,
 	hw->next_ln_addr = CPU_TO_DMA(chan, snoop_bits | next, 64);
 }
 
-static void set_cdar(struct fsldma_chan *chan, dma_addr_t addr)
+static void set_ld_eol(struct fsldma_chan *chan,
+			struct fsl_desc_sw *desc)
 {
-	DMA_OUT(chan, &chan->regs->cdar, addr | FSL_DMA_SNEN, 64);
-}
+	u64 snoop_bits;
 
-static dma_addr_t get_cdar(struct fsldma_chan *chan)
-{
-	return DMA_IN(chan, &chan->regs->cdar, 64) & ~FSL_DMA_SNEN;
-}
+	snoop_bits = ((chan->feature & FSL_DMA_IP_MASK) == FSL_DMA_IP_83XX)
+		? FSL_DMA_SNEN : 0;
 
-static dma_addr_t get_ndar(struct fsldma_chan *chan)
-{
-	return DMA_IN(chan, &chan->regs->ndar, 64);
+	desc->hw.next_ln_addr = CPU_TO_DMA(chan,
+		DMA_TO_CPU(chan, desc->hw.next_ln_addr, 64) | FSL_DMA_EOL
+			| snoop_bits, 64);
 }
 
-static u32 get_bcr(struct fsldma_chan *chan)
+/*
+ * DMA Engine Hardware Control Helpers
+ */
+
+static void dma_init(struct fsldma_chan *chan)
 {
-	return DMA_IN(chan, &chan->regs->bcr, 32);
+	/* Reset the channel */
+	DMA_OUT(chan, &chan->regs->mr, 0, 32);
+
+	switch (chan->feature & FSL_DMA_IP_MASK) {
+	case FSL_DMA_IP_85XX:
+		/* Set the channel to below modes:
+		 * EIE - Error interrupt enable
+		 * EOSIE - End of segments interrupt enable (basic mode)
+		 * EOLNIE - End of links interrupt enable
+		 * BWC - Bandwidth sharing among channels
+		 */
+		DMA_OUT(chan, &chan->regs->mr, FSL_DMA_MR_BWC
+				| FSL_DMA_MR_EIE | FSL_DMA_MR_EOLNIE
+				| FSL_DMA_MR_EOSIE, 32);
+		break;
+	case FSL_DMA_IP_83XX:
+		/* Set the channel to below modes:
+		 * EOTIE - End-of-transfer interrupt enable
+		 * PRC_RM - PCI read multiple
+		 */
+		DMA_OUT(chan, &chan->regs->mr, FSL_DMA_MR_EOTIE
+				| FSL_DMA_MR_PRC_RM, 32);
+		break;
+	}
 }
 
 static int dma_is_idle(struct fsldma_chan *chan)
@@ -185,19 +210,6 @@ static void dma_halt(struct fsldma_chan *chan)
 		dev_err(chan->dev, "DMA halt timeout!\n");
 }
 
-static void set_ld_eol(struct fsldma_chan *chan,
-			struct fsl_desc_sw *desc)
-{
-	u64 snoop_bits;
-
-	snoop_bits = ((chan->feature & FSL_DMA_IP_MASK) == FSL_DMA_IP_83XX)
-		? FSL_DMA_SNEN : 0;
-
-	desc->hw.next_ln_addr = CPU_TO_DMA(chan,
-		DMA_TO_CPU(chan, desc->hw.next_ln_addr, 64) | FSL_DMA_EOL
-			| snoop_bits, 64);
-}
-
 /**
  * fsl_chan_set_src_loop_size - Set source address hold transfer size
  * @chan : Freescale DMA channel
-- 
1.7.3.4

