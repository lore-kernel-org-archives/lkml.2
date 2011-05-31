Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755457Ab1EaBa2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 21:30:28 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:41695 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753210Ab1EaBa1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 21:30:27 -0400
From: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
To: Dan Williams <dan.j.williams@intel.com>, Vinod Koul <vinod.koul@intel.com>,
        linux-kernel@vger.kernel.org
Cc: qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, toshiharu-linux@dsn.okisemi.com,
        Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Subject: [PATCH] pch_dma: fix DMA issue(ch8-ch11)
Date: Tue, 31 May 2011 10:34:45 +0900
Message-Id: <1306805685-7450-1-git-send-email-tomoya-linux@dsn.okisemi.com>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ISSUE: In case PCH_DMA with I2S communications with ch8~ch11, sometimes I2S data
is not send correctly.
CAUSE: The following patch I submitted before was not enough modification for
supporting DMA ch8~ch11. The modification for status register of ch8~11 was not
enough.

pch_dma: Support I2S for ML7213 IOH
author	Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>	
	Mon, 9 May 2011 07:09:38 +0000 (16:09 +0900)
committer	Vinod Koul <vinod.koul@intel.com>	
	Mon, 9 May 2011 11:42:23 +0000 (16:42 +0530)
commit	194f5f2706c7472f9c6bb2d17fa788993606581f
tree	c9d4903ea02b18939a4f390956a48be1a3734517
parent	60092d0bde4c8741198da4a69b693d3709385bf1

This patch fixes the issue.
We can confirm PCH_DMA with I2S communications with ch8~ch11 works well.

Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
---
 drivers/dma/pch_dma.c |   69 +++++++++++++++++++++++++++++++++++++++----------
 1 files changed, 55 insertions(+), 14 deletions(-)

diff --git a/drivers/dma/pch_dma.c b/drivers/dma/pch_dma.c
index ff5b38f..65c32f8 100644
--- a/drivers/dma/pch_dma.c
+++ b/drivers/dma/pch_dma.c
@@ -45,7 +45,8 @@
 #define DMA_STATUS_MASK_BITS		0x3
 #define DMA_STATUS_SHIFT_BITS		16
 #define DMA_STATUS_IRQ(x)		(0x1 << (x))
-#define DMA_STATUS_ERR(x)		(0x1 << ((x) + 8))
+#define DMA_STATUS0_ERR(x)		(0x1 << ((x) + 8))
+#define DMA_STATUS2_ERR(x)		(0x1 << (x))
 
 #define DMA_DESC_WIDTH_SHIFT_BITS	12
 #define DMA_DESC_WIDTH_1_BYTE		(0x3 << DMA_DESC_WIDTH_SHIFT_BITS)
@@ -133,6 +134,7 @@ struct pch_dma {
 #define PCH_DMA_CTL3	0x0C
 #define PCH_DMA_STS0	0x10
 #define PCH_DMA_STS1	0x14
+#define PCH_DMA_STS2	0x18
 
 #define dma_readl(pd, name) \
 	readl((pd)->membase + PCH_DMA_##name)
@@ -183,13 +185,19 @@ static void pdc_enable_irq(struct dma_chan *chan, int enable)
 {
 	struct pch_dma *pd = to_pd(chan->device);
 	u32 val;
+	int pos;
+
+	if (chan->chan_id < 8)
+		pos = chan->chan_id;
+	else
+		pos = chan->chan_id + 8;
 
 	val = dma_readl(pd, CTL2);
 
 	if (enable)
-		val |= 0x1 << chan->chan_id;
+		val |= 0x1 << pos;
 	else
-		val &= ~(0x1 << chan->chan_id);
+		val &= ~(0x1 << pos);
 
 	dma_writel(pd, CTL2, val);
 
@@ -262,7 +270,7 @@ static void pdc_set_mode(struct dma_chan *chan, u32 mode)
 		chan->chan_id, val);
 }
 
-static u32 pdc_get_status(struct pch_dma_chan *pd_chan)
+static u32 pdc_get_status0(struct pch_dma_chan *pd_chan)
 {
 	struct pch_dma *pd = to_pd(pd_chan->chan.device);
 	u32 val;
@@ -272,9 +280,27 @@ static u32 pdc_get_status(struct pch_dma_chan *pd_chan)
 			DMA_STATUS_BITS_PER_CH * pd_chan->chan.chan_id));
 }
 
+static u32 pdc_get_status2(struct pch_dma_chan *pd_chan)
+{
+	struct pch_dma *pd = to_pd(pd_chan->chan.device);
+	u32 val;
+
+	val = dma_readl(pd, STS2);
+	return DMA_STATUS_MASK_BITS & (val >> (DMA_STATUS_SHIFT_BITS +
+			DMA_STATUS_BITS_PER_CH * (pd_chan->chan.chan_id - 8)));
+}
+
 static bool pdc_is_idle(struct pch_dma_chan *pd_chan)
 {
-	if (pdc_get_status(pd_chan) == DMA_STATUS_IDLE)
+	u32 sts;
+
+	if (pd_chan->chan.chan_id < 8)
+		sts = pdc_get_status0(pd_chan);
+	else
+		sts = pdc_get_status2(pd_chan);
+
+
+	if (sts == DMA_STATUS_IDLE)
 		return true;
 	else
 		return false;
@@ -693,30 +719,45 @@ static irqreturn_t pd_irq(int irq, void *devid)
 	struct pch_dma *pd = (struct pch_dma *)devid;
 	struct pch_dma_chan *pd_chan;
 	u32 sts0;
+	u32 sts2;
 	int i;
-	int ret = IRQ_NONE;
+	int ret0 = IRQ_NONE;
+	int ret2 = IRQ_NONE;
 
 	sts0 = dma_readl(pd, STS0);
+	sts2 = dma_readl(pd, STS2);
 
 	dev_dbg(pd->dma.dev, "pd_irq sts0: %x\n", sts0);
 
 	for (i = 0; i < pd->dma.chancnt; i++) {
 		pd_chan = &pd->channels[i];
 
-		if (sts0 & DMA_STATUS_IRQ(i)) {
-			if (sts0 & DMA_STATUS_ERR(i))
-				set_bit(0, &pd_chan->err_status);
+		if (i < 8) {
+			if (sts0 & DMA_STATUS_IRQ(i)) {
+				if (sts0 & DMA_STATUS0_ERR(i))
+					set_bit(0, &pd_chan->err_status);
 
-			tasklet_schedule(&pd_chan->tasklet);
-			ret = IRQ_HANDLED;
-		}
+				tasklet_schedule(&pd_chan->tasklet);
+				ret0 = IRQ_HANDLED;
+			}
+		} else {
+			if (sts2 & DMA_STATUS_IRQ(i - 8)) {
+				if (sts2 & DMA_STATUS2_ERR(i))
+					set_bit(0, &pd_chan->err_status);
 
+				tasklet_schedule(&pd_chan->tasklet);
+				ret2 = IRQ_HANDLED;
+			}
+		}
 	}
 
 	/* clear interrupt bits in status register */
-	dma_writel(pd, STS0, sts0);
+	if (ret0)
+		dma_writel(pd, STS0, sts0);
+	if (ret2)
+		dma_writel(pd, STS2, sts2);
 
-	return ret;
+	return ret0 | ret2;
 }
 
 #ifdef	CONFIG_PM
-- 
1.7.4

