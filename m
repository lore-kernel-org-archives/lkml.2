Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753357Ab1GNAwJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 20:52:09 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:20629 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751204Ab1GNAwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 20:52:07 -0400
From: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
To: Dan Williams <dan.j.williams@intel.com>, Vinod Koul <vinod.koul@intel.com>,
        linux-kernel@vger.kernel.org
Cc: qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, toshiharu-linux@dsn.okisemi.com,
        Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Subject: [PATCH] pch_dma: Fix CTL register access issue
Date: Thu, 14 Jul 2011 09:52:38 +0900
Message-Id: <1310604758-2455-1-git-send-email-tomoya-linux@dsn.okisemi.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, Mode-Control register is accessed by read-modify-write.

According to DMA hardware specifications datasheet, prohibits this method.
Because this register resets to 0 by DMA HW after DMA transfer completes.
Thus, current read-modify-write processing can cause unexpected behavior.

The datasheet says in case of writing Mode-Control register, set the value for only target channel, the others must set '11b'.
e.g. Set DMA0=01b  DMA11=10b
CTL0=33333331h
CTL2=00002333h

NOTE:
CTL0 includes DMA0~7 Mode-Control register.
CTL2 includes DMA8~11 Mode-Control register.

This patch modifies the issue.

Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
---
 drivers/dma/pch_dma.c |   42 +++++++++++++++++++++++++++++++-----------
 1 files changed, 31 insertions(+), 11 deletions(-)

diff --git a/drivers/dma/pch_dma.c b/drivers/dma/pch_dma.c
index 9dc92de..7460490 100644
--- a/drivers/dma/pch_dma.c
+++ b/drivers/dma/pch_dma.c
@@ -62,6 +62,9 @@
 
 #define MAX_CHAN_NR			8
 
+#define DMA_MASK_CTL0_MODE	0x33333333
+#define DMA_MASK_CTL2_MODE	0x00003333
+
 static unsigned int init_nr_desc_per_channel = 64;
 module_param(init_nr_desc_per_channel, uint, 0644);
 MODULE_PARM_DESC(init_nr_desc_per_channel,
@@ -210,10 +213,17 @@ static void pdc_set_dir(struct dma_chan *chan)
 	struct pch_dma_chan *pd_chan = to_pd_chan(chan);
 	struct pch_dma *pd = to_pd(chan->device);
 	u32 val;
+	u32 mask_mode;
+	u32 mask_ctl;
 
 	if (chan->chan_id < 8) {
 		val = dma_readl(pd, CTL0);
 
+		mask_mode = DMA_CTL0_MODE_MASK_BITS <<
+					(DMA_CTL0_BITS_PER_CH * chan->chan_id);
+		mask_ctl = DMA_MASK_CTL0_MODE & ~(DMA_CTL0_MODE_MASK_BITS <<
+				       (DMA_CTL0_BITS_PER_CH * chan->chan_id));
+		val &= mask_mode;
 		if (pd_chan->dir == DMA_TO_DEVICE)
 			val |= 0x1 << (DMA_CTL0_BITS_PER_CH * chan->chan_id +
 				       DMA_CTL0_DIR_SHIFT_BITS);
@@ -221,18 +231,24 @@ static void pdc_set_dir(struct dma_chan *chan)
 			val &= ~(0x1 << (DMA_CTL0_BITS_PER_CH * chan->chan_id +
 					 DMA_CTL0_DIR_SHIFT_BITS));
 
+		val |= mask_ctl;
 		dma_writel(pd, CTL0, val);
 	} else {
 		int ch = chan->chan_id - 8; /* ch8-->0 ch9-->1 ... ch11->3 */
 		val = dma_readl(pd, CTL3);
 
+		mask_mode = DMA_CTL0_MODE_MASK_BITS <<
+						(DMA_CTL0_BITS_PER_CH * ch);
+		mask_ctl = DMA_MASK_CTL2_MODE & ~(DMA_CTL0_MODE_MASK_BITS <<
+						 (DMA_CTL0_BITS_PER_CH * ch));
+		val &= mask_mode;
 		if (pd_chan->dir == DMA_TO_DEVICE)
 			val |= 0x1 << (DMA_CTL0_BITS_PER_CH * ch +
 				       DMA_CTL0_DIR_SHIFT_BITS);
 		else
 			val &= ~(0x1 << (DMA_CTL0_BITS_PER_CH * ch +
 					 DMA_CTL0_DIR_SHIFT_BITS));
-
+		val |= mask_ctl;
 		dma_writel(pd, CTL3, val);
 	}
 
@@ -244,26 +260,30 @@ static void pdc_set_mode(struct dma_chan *chan, u32 mode)
 {
 	struct pch_dma *pd = to_pd(chan->device);
 	u32 val;
+	u32 mask_ctl;
+	u32 mask_dir;
 
 	if (chan->chan_id < 8) {
+		mask_ctl = DMA_MASK_CTL0_MODE & ~(DMA_CTL0_MODE_MASK_BITS <<
+			   (DMA_CTL0_BITS_PER_CH * chan->chan_id));
+		mask_dir = 1 << (DMA_CTL0_BITS_PER_CH * chan->chan_id +\
+				 DMA_CTL0_DIR_SHIFT_BITS);
 		val = dma_readl(pd, CTL0);
-
-		val &= ~(DMA_CTL0_MODE_MASK_BITS <<
-			(DMA_CTL0_BITS_PER_CH * chan->chan_id));
+		val &= mask_dir;
 		val |= mode << (DMA_CTL0_BITS_PER_CH * chan->chan_id);
-
+		val |= mask_ctl;
 		dma_writel(pd, CTL0, val);
 	} else {
 		int ch = chan->chan_id - 8; /* ch8-->0 ch9-->1 ... ch11->3 */
-
+		mask_ctl = DMA_MASK_CTL2_MODE & ~(DMA_CTL0_MODE_MASK_BITS <<
+						 (DMA_CTL0_BITS_PER_CH * ch));
+		mask_dir = 1 << (DMA_CTL0_BITS_PER_CH * ch +\
+				 DMA_CTL0_DIR_SHIFT_BITS);
 		val = dma_readl(pd, CTL3);
-
-		val &= ~(DMA_CTL0_MODE_MASK_BITS <<
-			(DMA_CTL0_BITS_PER_CH * ch));
+		val &= mask_dir;
 		val |= mode << (DMA_CTL0_BITS_PER_CH * ch);
-
+		val |= mask_ctl;
 		dma_writel(pd, CTL3, val);
-
 	}
 
 	dev_dbg(chan2dev(chan), "pdc_set_mode: chan %d -> %x\n",
-- 
1.7.4.4

