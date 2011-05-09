Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756328Ab1EIDk6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 23:40:58 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:5648 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755810Ab1EIDk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 23:40:28 -0400
From: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
To: Dan Williams <dan.j.williams@intel.com>, Vinod Koul <vinod.koul@intel.com>,
        linux-kernel@vger.kernel.org
Cc: qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, toshiharu-linux@dsn.okisemi.com,
        Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Subject: [PATCH V2 4/5] pch_dma: Support I2S for ML7213 IOH
Date: Mon,  9 May 2011 12:40:05 +0900
Message-Id: <1304912406-6531-4-git-send-email-tomoya-linux@dsn.okisemi.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1304912406-6531-1-git-send-email-tomoya-linux@dsn.okisemi.com>
References: <1304912406-6531-1-git-send-email-tomoya-linux@dsn.okisemi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support I2S device for ML7213 IOH

Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
---
 drivers/dma/pch_dma.c |   62 +++++++++++++++++++++++++++++++++++++------------
 1 files changed, 47 insertions(+), 15 deletions(-)

diff --git a/drivers/dma/pch_dma.c b/drivers/dma/pch_dma.c
index 0ecf227..2c052bb 100644
--- a/drivers/dma/pch_dma.c
+++ b/drivers/dma/pch_dma.c
@@ -77,10 +77,10 @@ struct pch_dma_regs {
 	u32	dma_ctl0;
 	u32	dma_ctl1;
 	u32	dma_ctl2;
-	u32	reserved1;
+	u32	dma_ctl3;
 	u32	dma_sts0;
 	u32	dma_sts1;
-	u32	reserved2;
+	u32	dma_sts2;
 	u32	reserved3;
 	struct pch_dma_desc_regs desc[MAX_CHAN_NR];
 };
@@ -130,6 +130,7 @@ struct pch_dma {
 #define PCH_DMA_CTL0	0x00
 #define PCH_DMA_CTL1	0x04
 #define PCH_DMA_CTL2	0x08
+#define PCH_DMA_CTL3	0x0C
 #define PCH_DMA_STS0	0x10
 #define PCH_DMA_STS1	0x14
 
@@ -202,16 +203,30 @@ static void pdc_set_dir(struct dma_chan *chan)
 	struct pch_dma *pd = to_pd(chan->device);
 	u32 val;
 
-	val = dma_readl(pd, CTL0);
+	if (chan->chan_id < 8) {
+		val = dma_readl(pd, CTL0);
 
-	if (pd_chan->dir == DMA_TO_DEVICE)
-		val |= 0x1 << (DMA_CTL0_BITS_PER_CH * chan->chan_id +
-			       DMA_CTL0_DIR_SHIFT_BITS);
-	else
-		val &= ~(0x1 << (DMA_CTL0_BITS_PER_CH * chan->chan_id +
-				 DMA_CTL0_DIR_SHIFT_BITS));
+		if (pd_chan->dir == DMA_TO_DEVICE)
+			val |= 0x1 << (DMA_CTL0_BITS_PER_CH * chan->chan_id +
+				       DMA_CTL0_DIR_SHIFT_BITS);
+		else
+			val &= ~(0x1 << (DMA_CTL0_BITS_PER_CH * chan->chan_id +
+					 DMA_CTL0_DIR_SHIFT_BITS));
+
+		dma_writel(pd, CTL0, val);
+	} else {
+		int ch = chan->chan_id - 8; /* ch8-->0 ch9-->1 ... ch11->3 */
+		val = dma_readl(pd, CTL3);
 
-	dma_writel(pd, CTL0, val);
+		if (pd_chan->dir == DMA_TO_DEVICE)
+			val |= 0x1 << (DMA_CTL0_BITS_PER_CH * ch +
+				       DMA_CTL0_DIR_SHIFT_BITS);
+		else
+			val &= ~(0x1 << (DMA_CTL0_BITS_PER_CH * ch +
+					 DMA_CTL0_DIR_SHIFT_BITS));
+
+		dma_writel(pd, CTL3, val);
+	}
 
 	dev_dbg(chan2dev(chan), "pdc_set_dir: chan %d -> %x\n",
 		chan->chan_id, val);
@@ -222,13 +237,26 @@ static void pdc_set_mode(struct dma_chan *chan, u32 mode)
 	struct pch_dma *pd = to_pd(chan->device);
 	u32 val;
 
-	val = dma_readl(pd, CTL0);
+	if (chan->chan_id < 8) {
+		val = dma_readl(pd, CTL0);
 
-	val &= ~(DMA_CTL0_MODE_MASK_BITS <<
-		(DMA_CTL0_BITS_PER_CH * chan->chan_id));
-	val |= mode << (DMA_CTL0_BITS_PER_CH * chan->chan_id);
+		val &= ~(DMA_CTL0_MODE_MASK_BITS <<
+			(DMA_CTL0_BITS_PER_CH * chan->chan_id));
+		val |= mode << (DMA_CTL0_BITS_PER_CH * chan->chan_id);
 
-	dma_writel(pd, CTL0, val);
+		dma_writel(pd, CTL0, val);
+	} else {
+		int ch = chan->chan_id - 8; /* ch8-->0 ch9-->1 ... ch11->3 */
+
+		val = dma_readl(pd, CTL3);
+
+		val &= ~(DMA_CTL0_MODE_MASK_BITS <<
+			(DMA_CTL0_BITS_PER_CH * ch));
+		val |= mode << (DMA_CTL0_BITS_PER_CH * ch);
+
+		dma_writel(pd, CTL3, val);
+
+	}
 
 	dev_dbg(chan2dev(chan), "pdc_set_mode: chan %d -> %x\n",
 		chan->chan_id, val);
@@ -701,6 +729,7 @@ static void pch_dma_save_regs(struct pch_dma *pd)
 	pd->regs.dma_ctl0 = dma_readl(pd, CTL0);
 	pd->regs.dma_ctl1 = dma_readl(pd, CTL1);
 	pd->regs.dma_ctl2 = dma_readl(pd, CTL2);
+	pd->regs.dma_ctl3 = dma_readl(pd, CTL3);
 
 	list_for_each_entry_safe(chan, _c, &pd->dma.channels, device_node) {
 		pd_chan = to_pd_chan(chan);
@@ -723,6 +752,7 @@ static void pch_dma_restore_regs(struct pch_dma *pd)
 	dma_writel(pd, CTL0, pd->regs.dma_ctl0);
 	dma_writel(pd, CTL1, pd->regs.dma_ctl1);
 	dma_writel(pd, CTL2, pd->regs.dma_ctl2);
+	dma_writel(pd, CTL3, pd->regs.dma_ctl3);
 
 	list_for_each_entry_safe(chan, _c, &pd->dma.channels, device_node) {
 		pd_chan = to_pd_chan(chan);
@@ -925,6 +955,7 @@ static void __devexit pch_dma_remove(struct pci_dev *pdev)
 #define PCI_DEVICE_ID_ML7213_DMA1_8CH	0x8026
 #define PCI_DEVICE_ID_ML7213_DMA2_8CH	0x802B
 #define PCI_DEVICE_ID_ML7213_DMA3_4CH	0x8034
+#define PCI_DEVICE_ID_ML7213_DMA4_12CH	0x8032
 
 static const struct pci_device_id pch_dma_id_table[] = {
 	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_EG20T_PCH_DMA_8CH), 8 },
@@ -932,6 +963,7 @@ static const struct pci_device_id pch_dma_id_table[] = {
 	{ PCI_VDEVICE(ROHM, PCI_DEVICE_ID_ML7213_DMA1_8CH), 8}, /* UART Video */
 	{ PCI_VDEVICE(ROHM, PCI_DEVICE_ID_ML7213_DMA2_8CH), 8}, /* PCMIF SPI */
 	{ PCI_VDEVICE(ROHM, PCI_DEVICE_ID_ML7213_DMA3_4CH), 4}, /* FPGA */
+	{ PCI_VDEVICE(ROHM, PCI_DEVICE_ID_ML7213_DMA4_12CH), 12}, /* I2S */
 	{ 0, },
 };
 
-- 
1.7.4

