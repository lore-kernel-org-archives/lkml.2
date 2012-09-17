Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754253Ab2IQHjV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 03:39:21 -0400
Received: from mga01.intel.com ([192.55.52.88]:38054 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753880Ab2IQHjQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 03:39:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,433,1344236400"; 
   d="scan'208";a="222918069"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Viresh Kumar <viresh.linux@gmail.com>, Vinod Koul <vinod.koul@intel.com>,
        spear-devel@list.st.com, linux-kernel@vger.kernel.org,
        Hein Tibosch <hein_tibosch@yahoo.es>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 4/7] dw_dmac: autoconfigure block_size or use platform data
Date: Mon, 17 Sep 2012 10:39:34 +0300
Message-Id: <1347867577-13170-5-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1347867577-13170-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1347867577-13170-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The maximum block size is a configurable parameter for the chip. So, driver
will try to get it from the encoded component parameters. Otherwise it will
come from the platform data.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 arch/arm/mach-spear13xx/spear13xx.c |    1 +
 arch/avr32/mach-at32ap/at32ap700x.c |    1 +
 drivers/dma/dw_dmac.c               |   34 ++++++++++++++++++----------------
 drivers/dma/dw_dmac_regs.h          |    3 +++
 include/linux/dw_dmac.h             |    2 ++
 5 files changed, 25 insertions(+), 16 deletions(-)

diff --git a/arch/arm/mach-spear13xx/spear13xx.c b/arch/arm/mach-spear13xx/spear13xx.c
index cf936b1..c64d812 100644
--- a/arch/arm/mach-spear13xx/spear13xx.c
+++ b/arch/arm/mach-spear13xx/spear13xx.c
@@ -78,6 +78,7 @@ struct dw_dma_platform_data dmac_plat_data = {
 	.nr_channels = 8,
 	.chan_allocation_order = CHAN_ALLOCATION_DESCENDING,
 	.chan_priority = CHAN_PRIORITY_DESCENDING,
+	.block_size = 4095U,
 };
 
 void __init spear13xx_l2x0_init(void)
diff --git a/arch/avr32/mach-at32ap/at32ap700x.c b/arch/avr32/mach-at32ap/at32ap700x.c
index 0445c4f..2c4aefe 100644
--- a/arch/avr32/mach-at32ap/at32ap700x.c
+++ b/arch/avr32/mach-at32ap/at32ap700x.c
@@ -605,6 +605,7 @@ static void __init genclk_init_parent(struct clk *clk)
 
 static struct dw_dma_platform_data dw_dmac0_data = {
 	.nr_channels	= 3,
+	.block_size	= 4095U,
 };
 
 static struct resource dw_dmac0_resource[] = {
diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index 2a3b730..ab718ee 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -58,16 +58,6 @@
 	})
 
 /*
- * This is configuration-dependent and usually a funny size like 4095.
- *
- * Note that this is a transfer count, i.e. if we transfer 32-bit
- * words, we can do 16380 bytes per descriptor.
- *
- * This parameter is also system-specific.
- */
-#define DWC_MAX_COUNT	4095U
-
-/*
  * Number of descriptors to allocate for each channel. This should be
  * made configurable somehow; preferably, the clients (at least the
  * ones using slave transfers) should be able to give us a hint.
@@ -669,7 +659,7 @@ dwc_prep_dma_memcpy(struct dma_chan *chan, dma_addr_t dest, dma_addr_t src,
 
 	for (offset = 0; offset < len; offset += xfer_count << src_width) {
 		xfer_count = min_t(size_t, (len - offset) >> src_width,
-				DWC_MAX_COUNT);
+					   dwc->block_size);
 
 		desc = dwc_desc_get(dwc);
 		if (!desc)
@@ -770,8 +760,8 @@ slave_sg_todev_fill_desc:
 			desc->lli.sar = mem;
 			desc->lli.dar = reg;
 			desc->lli.ctllo = ctllo | DWC_CTLL_SRC_WIDTH(mem_width);
-			if ((len >> mem_width) > DWC_MAX_COUNT) {
-				dlen = DWC_MAX_COUNT << mem_width;
+			if ((len >> mem_width) > dwc->block_size) {
+				dlen = dwc->block_size << mem_width;
 				mem += dlen;
 				len -= dlen;
 			} else {
@@ -830,8 +820,8 @@ slave_sg_fromdev_fill_desc:
 			desc->lli.sar = reg;
 			desc->lli.dar = mem;
 			desc->lli.ctllo = ctllo | DWC_CTLL_DST_WIDTH(mem_width);
-			if ((len >> reg_width) > DWC_MAX_COUNT) {
-				dlen = DWC_MAX_COUNT << reg_width;
+			if ((len >> reg_width) > dwc->block_size) {
+				dlen = dwc->block_size << reg_width;
 				mem += dlen;
 				len -= dlen;
 			} else {
@@ -1214,7 +1204,7 @@ struct dw_cyclic_desc *dw_dma_cyclic_prep(struct dma_chan *chan,
 	periods = buf_len / period_len;
 
 	/* Check for too big/unaligned periods and unaligned DMA buffer. */
-	if (period_len > (DWC_MAX_COUNT << reg_width))
+	if (period_len > (dwc->block_size << reg_width))
 		goto out_err;
 	if (unlikely(period_len & ((1 << reg_width) - 1)))
 		goto out_err;
@@ -1380,6 +1370,7 @@ static int __devinit dw_probe(struct platform_device *pdev)
 	bool			autocfg;
 	unsigned int		dw_params;
 	unsigned int		nr_channels;
+	unsigned int		max_blk_size;
 	int			irq;
 	int			err;
 	int			i;
@@ -1420,6 +1411,9 @@ static int __devinit dw_probe(struct platform_device *pdev)
 
 	dw->regs = regs;
 
+	/* get hardware configuration parameters */
+	max_blk_size = dma_readl(dw, MAX_BLK_SIZE);
+
 	/* Calculate all channel mask before DMA setup */
 	dw->all_chan_mask = (1 << nr_channels) - 1;
 
@@ -1465,6 +1459,14 @@ static int __devinit dw_probe(struct platform_device *pdev)
 		INIT_LIST_HEAD(&dwc->free_list);
 
 		channel_clear_bit(dw, CH_EN, dwc->mask);
+
+		/* hardware configuration */
+		if (autocfg) {
+			dwc->block_size =
+				(4 << ((max_blk_size >> 4 * i) & 0xf)) - 1;
+		} else {
+			dwc->block_size = pdata->block_size;
+		}
 	}
 
 	/* Clear all interrupts on all channels. */
diff --git a/drivers/dma/dw_dmac_regs.h b/drivers/dma/dw_dmac_regs.h
index 0f96965..233f5e5 100644
--- a/drivers/dma/dw_dmac_regs.h
+++ b/drivers/dma/dw_dmac_regs.h
@@ -186,6 +186,9 @@ struct dw_dma_chan {
 
 	unsigned int		descs_allocated;
 
+	/* hardware configuration */
+	unsigned short		block_size;
+
 	/* configuration passed via DMA_SLAVE_CONFIG */
 	struct dma_slave_config dma_sconfig;
 };
diff --git a/include/linux/dw_dmac.h b/include/linux/dw_dmac.h
index 2412e02..3315ef9 100644
--- a/include/linux/dw_dmac.h
+++ b/include/linux/dw_dmac.h
@@ -19,6 +19,7 @@
  * @nr_channels: Number of channels supported by hardware (max 8)
  * @is_private: The device channels should be marked as private and not for
  *	by the general purpose DMA channel allocator.
+ * @block_size: Maximum block size supported by the controller
  */
 struct dw_dma_platform_data {
 	unsigned int	nr_channels;
@@ -29,6 +30,7 @@ struct dw_dma_platform_data {
 #define CHAN_PRIORITY_ASCENDING		0	/* chan0 highest */
 #define CHAN_PRIORITY_DESCENDING	1	/* chan7 highest */
 	unsigned char	chan_priority;
+	unsigned short	block_size;
 };
 
 /* bursts size */
-- 
1.7.10.4

