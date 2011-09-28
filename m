Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753251Ab1I1FtK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 01:49:10 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:62364 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752938Ab1I1FtG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 01:49:06 -0400
X-AuditID: cbfee61a-b7cf1ae00000208e-78-4e82b5515a79
From: Alim Akhtar <alim.akhtar@samsung.com>
To: linus.walleij@linaro.org, vinod.koul@intel.com, dan.j.williams@intel.com,
        viresh.kumar@st.com
Cc: kgene.kim@samsung.com, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org
Subject: [PATCH V2 1/1] dmaengine/amba-pl08x: Add support for s3c64xx DMAC
Date: Wed, 28 Sep 2011 11:20:07 +0530
Message-id: <1317189007-23033-2-git-send-email-alim.akhtar@samsung.com>
X-Mailer: git-send-email 1.7.2.3
In-reply-to: <1317189007-23033-1-git-send-email-alim.akhtar@samsung.com>
References: <1317189007-23033-1-git-send-email-alim.akhtar@samsung.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alim Akhtar <alim.akhtar@samsung.com>
---
 drivers/dma/amba-pl08x.c |  135 ++++++++++++++++++++++++++++++++++++++--------
 1 files changed, 112 insertions(+), 23 deletions(-)

diff --git a/drivers/dma/amba-pl08x.c b/drivers/dma/amba-pl08x.c
index cd8df7f..501540f 100644
--- a/drivers/dma/amba-pl08x.c
+++ b/drivers/dma/amba-pl08x.c
@@ -66,8 +66,25 @@
  *    after the final transfer signalled by LBREQ or LSREQ.  The DMAC
  *    will then move to the next LLI entry.
  *
- * Global TODO:
- * - Break out common code from arch/arm/mach-s3c64xx and share
+ * Samsung S3C64xx SoCs uses a variant of PL080 DMAC. It contains an extra
+ * control register to hold the TransferSize. Below is the LLI structure
+ * and offsets of S3C64xx DMAC.
+ *	-----------------------------------------------------------------
+ *	|	Offset		|	Contents		        |
+ *	-----------------------------------------------------------------
+ *	| Next LLI Address	| Source Address for Next xfer	        |
+ *	-----------------------------------------------------------------
+ *	| Next LLI Address+0x04	| Destination Address for Next xfer     |
+ *	-----------------------------------------------------------------
+ *	| Next LLI Address+0x08	| Next LLI address for next xfer        |
+ *	-----------------------------------------------------------------
+ *	| Next LLI Address+0x0c	| DMACCxControl0 data for next xfer     |
+ *	-----------------------------------------------------------------
+ *	| Next LLI Address+0x10	| DMACCxControl1 xfer size for next xfer|
+ *	-----------------------------------------------------------------
+ * Also S3C64XX has a config register at offset 0x14
+ * Have a look at arch/arm/include/asm/hardware/pl080.h for complete register
+ * details.
  */
 #include <linux/amba/bus.h>
 #include <linux/amba/pl08x.h>
@@ -97,6 +114,8 @@ static struct amba_driver pl08x_amba_driver;
 struct vendor_data {
 	u8 channels;
 	bool dualmaster;
+	/* To identify samsung DMAC */
+	bool is_pl080_s3c;
 };
 
 /*
@@ -110,6 +129,11 @@ struct pl08x_lli {
 	u32 dst;
 	u32 lli;
 	u32 cctl;
+	/*
+	 * Samsung pl080 DMAC has one exrta control register
+	 * which is used to hold the transfer_size
+	 */
+	u32 cctl1;
 };
 
 /**
@@ -171,9 +195,20 @@ static inline struct pl08x_txd *to_pl08x_txd(struct dma_async_tx_descriptor *tx)
 /* Whether a certain channel is busy or not */
 static int pl08x_phy_channel_busy(struct pl08x_phy_chan *ch)
 {
+	struct pl08x_dma_chan *plchan = ch->serving;
+	struct pl08x_driver_data *pl08x;
 	unsigned int val;
 
-	val = readl(ch->base + PL080_CH_CONFIG);
+	if (plchan == NULL)
+		return false;
+
+	pl08x = plchan->host;
+
+	if (pl08x->vd->is_pl080_s3c)
+		val = readl(ch->base + PL080S_CH_CONFIG);
+	else
+		val = readl(ch->base + PL080_CH_CONFIG);
+
 	return val & PL080_CONFIG_ACTIVE;
 }
 
@@ -207,7 +242,12 @@ static void pl08x_start_txd(struct pl08x_dma_chan *plchan,
 	writel(lli->dst, phychan->base + PL080_CH_DST_ADDR);
 	writel(lli->lli, phychan->base + PL080_CH_LLI);
 	writel(lli->cctl, phychan->base + PL080_CH_CONTROL);
-	writel(txd->ccfg, phychan->base + PL080_CH_CONFIG);
+
+	if (pl08x->vd->is_pl080_s3c) {
+		writel(txd->ccfg, phychan->base + PL080S_CH_CONFIG);
+		writel(lli->cctl1, phychan->base + PL080S_CH_CONTROL2);
+	} else
+		writel(txd->ccfg, phychan->base + PL080_CH_CONFIG);
 
 	/* Enable the DMA channel */
 	/* Do not access config register until channel shows as disabled */
@@ -215,11 +255,23 @@ static void pl08x_start_txd(struct pl08x_dma_chan *plchan,
 		cpu_relax();
 
 	/* Do not access config register until channel shows as inactive */
-	val = readl(phychan->base + PL080_CH_CONFIG);
-	while ((val & PL080_CONFIG_ACTIVE) || (val & PL080_CONFIG_ENABLE))
+	if (pl08x->vd->is_pl080_s3c) {
+		val = readl(phychan->base + PL080S_CH_CONFIG);
+		while ((val & PL080_CONFIG_ACTIVE) ||
+			(val & PL080_CONFIG_ENABLE))
+			val = readl(phychan->base + PL080S_CH_CONFIG);
+
+		writel(val | PL080_CONFIG_ENABLE,
+			phychan->base + PL080S_CH_CONFIG);
+	} else {
 		val = readl(phychan->base + PL080_CH_CONFIG);
+			while ((val & PL080_CONFIG_ACTIVE) ||
+				(val & PL080_CONFIG_ENABLE))
+				val = readl(phychan->base + PL080_CH_CONFIG);
 
-	writel(val | PL080_CONFIG_ENABLE, phychan->base + PL080_CH_CONFIG);
+		writel(val | PL080_CONFIG_ENABLE,
+			phychan->base + PL080_CH_CONFIG);
+	}
 }
 
 /*
@@ -236,12 +288,19 @@ static void pl08x_pause_phy_chan(struct pl08x_phy_chan *ch)
 {
 	u32 val;
 	int timeout;
+	struct pl08x_dma_chan *plchan = ch->serving;
+	struct pl08x_driver_data *pl08x = plchan->host;
 
 	/* Set the HALT bit and wait for the FIFO to drain */
-	val = readl(ch->base + PL080_CH_CONFIG);
-	val |= PL080_CONFIG_HALT;
-	writel(val, ch->base + PL080_CH_CONFIG);
-
+	if (pl08x->vd->is_pl080_s3c) {
+		val = readl(ch->base + PL080S_CH_CONFIG);
+		val |= PL080_CONFIG_HALT;
+		writel(val, ch->base + PL080S_CH_CONFIG);
+	} else {
+		val = readl(ch->base + PL080_CH_CONFIG);
+		val |= PL080_CONFIG_HALT;
+		writel(val, ch->base + PL080_CH_CONFIG);
+	}
 	/* Wait for channel inactive */
 	for (timeout = 1000; timeout; timeout--) {
 		if (!pl08x_phy_channel_busy(ch))
@@ -255,11 +314,19 @@ static void pl08x_pause_phy_chan(struct pl08x_phy_chan *ch)
 static void pl08x_resume_phy_chan(struct pl08x_phy_chan *ch)
 {
 	u32 val;
+	struct pl08x_dma_chan *plchan = ch->serving;
+	struct pl08x_driver_data *pl08x = plchan->host;
 
 	/* Clear the HALT bit */
-	val = readl(ch->base + PL080_CH_CONFIG);
-	val &= ~PL080_CONFIG_HALT;
-	writel(val, ch->base + PL080_CH_CONFIG);
+	if (pl08x->vd->is_pl080_s3c) {
+		val = readl(ch->base + PL080S_CH_CONFIG);
+		val &= ~PL080_CONFIG_HALT;
+		writel(val, ch->base + PL080S_CH_CONFIG);
+	} else {
+		val = readl(ch->base + PL080_CH_CONFIG);
+		val &= ~PL080_CONFIG_HALT;
+		writel(val, ch->base + PL080_CH_CONFIG);
+	}
 }
 
 /*
@@ -271,12 +338,17 @@ static void pl08x_resume_phy_chan(struct pl08x_phy_chan *ch)
 static void pl08x_terminate_phy_chan(struct pl08x_driver_data *pl08x,
 	struct pl08x_phy_chan *ch)
 {
-	u32 val = readl(ch->base + PL080_CH_CONFIG);
-
-	val &= ~(PL080_CONFIG_ENABLE | PL080_CONFIG_ERR_IRQ_MASK |
-	         PL080_CONFIG_TC_IRQ_MASK);
-
-	writel(val, ch->base + PL080_CH_CONFIG);
+	if (pl08x->vd->is_pl080_s3c) {
+		u32 val = readl(ch->base + PL080S_CH_CONFIG);
+		val &= ~(PL080_CONFIG_ENABLE | PL080_CONFIG_ERR_IRQ_MASK |
+				PL080_CONFIG_TC_IRQ_MASK);
+		writel(val, ch->base + PL080S_CH_CONFIG);
+	} else {
+		u32 val = readl(ch->base + PL080_CH_CONFIG);
+		val &= ~(PL080_CONFIG_ENABLE | PL080_CONFIG_ERR_IRQ_MASK |
+				PL080_CONFIG_TC_IRQ_MASK);
+		writel(val, ch->base + PL080_CH_CONFIG);
+	}
 
 	writel(1 << ch->id, pl08x->base + PL080_ERR_CLEAR);
 	writel(1 << ch->id, pl08x->base + PL080_TC_CLEAR);
@@ -569,6 +641,7 @@ static int pl08x_fill_llis_for_desc(struct pl08x_driver_data *pl08x,
 	u32 cctl, early_bytes = 0;
 	size_t max_bytes_per_lli, total_bytes = 0;
 	struct pl08x_lli *llis_va;
+	size_t lli_len = 0, target_len, tsize, odd_bytes;
 
 	txd->llis_va = dma_pool_alloc(pl08x->pool, GFP_NOWAIT, &txd->llis_bus);
 	if (!txd->llis_va) {
@@ -700,7 +773,7 @@ static int pl08x_fill_llis_for_desc(struct pl08x_driver_data *pl08x,
 		 * width left
 		 */
 		while (bd.remainder > (mbus->buswidth - 1)) {
-			size_t lli_len, tsize, width;
+			size_t width;
 
 			/*
 			 * If enough left try to send max possible,
@@ -759,6 +832,9 @@ static int pl08x_fill_llis_for_desc(struct pl08x_driver_data *pl08x,
 	llis_va[num_llis - 1].lli = 0;
 	/* The final LLI element shall also fire an interrupt. */
 	llis_va[num_llis - 1].cctl |= PL080_CONTROL_TC_IRQ_EN;
+	/* Keep the TransferSize seperate to fill samsung specific register */
+	if (pl08x->vd->is_pl080_s3c)
+		llis_va[num_llis - 1].cctl1 |= lli_len;
 
 #ifdef VERBOSE_DEBUG
 	{
@@ -771,8 +847,8 @@ static int pl08x_fill_llis_for_desc(struct pl08x_driver_data *pl08x,
 			dev_vdbg(&pl08x->adev->dev,
 				 "%3d @%p: 0x%08x 0x%08x 0x%08x 0x%08x\n",
 				 i, &llis_va[i], llis_va[i].src,
-				 llis_va[i].dst, llis_va[i].lli, llis_va[i].cctl
-				);
+				 llis_va[i].dst, llis_va[i].lli,
+				 llis_va[i].cctl);
 		}
 	}
 #endif
@@ -1979,6 +2055,12 @@ static struct vendor_data vendor_pl081 = {
 	.dualmaster = false,
 };
 
+static struct vendor_data vendor_pl080_s3c = {
+	.channels = 8,
+	.dualmaster = true,
+	.is_pl080_s3c = true,
+};
+
 static struct amba_id pl08x_ids[] = {
 	/* PL080 */
 	{
@@ -1998,6 +2080,13 @@ static struct amba_id pl08x_ids[] = {
 		.mask	= 0x00ffffff,
 		.data	= &vendor_pl080,
 	},
+	/* Samsung DMAC is PL080 variant*/
+	{
+		.id	= 0x00041082,
+		.mask	= 0x000fffff,
+		.data	= &vendor_pl080_s3c,
+
+	},
 	{ 0, 0 },
 };
 
-- 
1.7.2.3

