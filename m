Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753251Ab2IUMGD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 08:06:03 -0400
Received: from mga02.intel.com ([134.134.136.20]:45624 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751548Ab2IUMF7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 08:05:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,462,1344236400"; 
   d="scan'208";a="195746704"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Viresh Kumar <viresh.linux@gmail.com>, Vinod Koul <vinod.koul@intel.com>,
        spear-devel@list.st.com, linux-kernel@vger.kernel.org,
        Hein Tibosch <hein_tibosch@yahoo.es>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCHv2 5/6] dw_dmac: autoconfigure data_width or get it via platform data
Date: Fri, 21 Sep 2012 15:05:48 +0300
Message-Id: <1348229149-29040-6-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1348229149-29040-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1347867577-13170-1-git-send-email-andriy.shevchenko@linux.intel.com>
 <1348229149-29040-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not all of the controllers support the 64 bit data width. Make it configurable
via platform data. The driver will try to get a value from the component
parameters, otherwise it will use the platform data.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 arch/arm/mach-spear13xx/spear13xx.c |    2 ++
 arch/avr32/mach-at32ap/at32ap700x.c |    2 ++
 drivers/dma/dw_dmac.c               |   46 ++++++++++++++++++++++++++++++-----
 drivers/dma/dw_dmac_regs.h          |    7 ++++++
 include/linux/dw_dmac.h             |    5 ++++
 5 files changed, 56 insertions(+), 6 deletions(-)

diff --git a/arch/arm/mach-spear13xx/spear13xx.c b/arch/arm/mach-spear13xx/spear13xx.c
index 9491137..5633d69 100644
--- a/arch/arm/mach-spear13xx/spear13xx.c
+++ b/arch/arm/mach-spear13xx/spear13xx.c
@@ -79,6 +79,8 @@ struct dw_dma_platform_data dmac_plat_data = {
 	.chan_allocation_order = CHAN_ALLOCATION_DESCENDING,
 	.chan_priority = CHAN_PRIORITY_DESCENDING,
 	.block_size = 4095U,
+	.nr_masters = 2,
+	.data_width = { 3, 3, 0, 0 },
 };
 
 void __init spear13xx_l2x0_init(void)
diff --git a/arch/avr32/mach-at32ap/at32ap700x.c b/arch/avr32/mach-at32ap/at32ap700x.c
index 2c4aefe..b323d8d 100644
--- a/arch/avr32/mach-at32ap/at32ap700x.c
+++ b/arch/avr32/mach-at32ap/at32ap700x.c
@@ -606,6 +606,8 @@ static void __init genclk_init_parent(struct clk *clk)
 static struct dw_dma_platform_data dw_dmac0_data = {
 	.nr_channels	= 3,
 	.block_size	= 4095U,
+	.nr_masters	= 2,
+	.data_width	= { 2, 2, 0, 0 },
 };
 
 static struct resource dw_dmac0_resource[] = {
diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index 4af9fad..d47b76a 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -38,12 +38,22 @@
  * which does not support descriptor writeback.
  */
 
+static inline unsigned int dwc_get_dms(struct dw_dma_slave *slave)
+{
+	return slave ? slave->dst_master : 0;
+}
+
+static inline unsigned int dwc_get_sms(struct dw_dma_slave *slave)
+{
+	return slave ? slave->src_master : 1;
+}
+
 #define DWC_DEFAULT_CTLLO(_chan) ({				\
 		struct dw_dma_slave *__slave = (_chan->private);	\
 		struct dw_dma_chan *_dwc = to_dw_dma_chan(_chan);	\
 		struct dma_slave_config	*_sconfig = &_dwc->dma_sconfig;	\
-		int _dms = __slave ? __slave->dst_master : 0;	\
-		int _sms = __slave ? __slave->src_master : 1;	\
+		int _dms = dwc_get_dms(__slave);		\
+		int _sms = dwc_get_sms(__slave);		\
 		u8 _smsize = __slave ? _sconfig->src_maxburst :	\
 			DW_DMA_MSIZE_16;			\
 		u8 _dmsize = __slave ? _sconfig->dst_maxburst :	\
@@ -633,6 +643,7 @@ dwc_prep_dma_memcpy(struct dma_chan *chan, dma_addr_t dest, dma_addr_t src,
 		size_t len, unsigned long flags)
 {
 	struct dw_dma_chan	*dwc = to_dw_dma_chan(chan);
+	struct dw_dma_slave	*dws = chan->private;
 	struct dw_desc		*desc;
 	struct dw_desc		*first;
 	struct dw_desc		*prev;
@@ -652,7 +663,11 @@ dwc_prep_dma_memcpy(struct dma_chan *chan, dma_addr_t dest, dma_addr_t src,
 		return NULL;
 	}
 
-	src_width = dst_width = dwc_fast_fls(src | dest | len);
+	src_width = min_t(unsigned int, dwc->dw->data_width[dwc_get_sms(dws)],
+			  dwc_fast_fls(src | len));
+
+	dst_width = min_t(unsigned int, dwc->dw->data_width[dwc_get_dms(dws)],
+			  dwc_fast_fls(dest | len));
 
 	ctllo = DWC_DEFAULT_CTLLO(chan)
 			| DWC_CTLL_DST_WIDTH(dst_width)
@@ -722,6 +737,7 @@ dwc_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
 	dma_addr_t		reg;
 	unsigned int		reg_width;
 	unsigned int		mem_width;
+	unsigned int		data_width;
 	unsigned int		i;
 	struct scatterlist	*sg;
 	size_t			total_len = 0;
@@ -745,6 +761,8 @@ dwc_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
 		ctllo |= sconfig->device_fc ? DWC_CTLL_FC(DW_DMA_FC_P_M2P) :
 			DWC_CTLL_FC(DW_DMA_FC_D_M2P);
 
+		data_width = dwc->dw->data_width[dwc_get_sms(dws)];
+
 		for_each_sg(sgl, sg, sg_len, i) {
 			struct dw_desc	*desc;
 			u32		len, dlen, mem;
@@ -752,7 +770,8 @@ dwc_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
 			mem = sg_dma_address(sg);
 			len = sg_dma_len(sg);
 
-			mem_width = dwc_fast_fls(mem | len);
+			mem_width = min_t(unsigned int,
+					  data_width, dwc_fast_fls(mem | len));
 
 slave_sg_todev_fill_desc:
 			desc = dwc_desc_get(dwc);
@@ -805,6 +824,8 @@ slave_sg_todev_fill_desc:
 		ctllo |= sconfig->device_fc ? DWC_CTLL_FC(DW_DMA_FC_P_P2M) :
 			DWC_CTLL_FC(DW_DMA_FC_D_P2M);
 
+		data_width = dwc->dw->data_width[dwc_get_dms(dws)];
+
 		for_each_sg(sgl, sg, sg_len, i) {
 			struct dw_desc	*desc;
 			u32		len, dlen, mem;
@@ -812,7 +833,8 @@ slave_sg_todev_fill_desc:
 			mem = sg_dma_address(sg);
 			len = sg_dma_len(sg);
 
-			mem_width = dwc_fast_fls(mem | len);
+			mem_width = min_t(unsigned int,
+					  data_width, dwc_fast_fls(mem | len));
 
 slave_sg_fromdev_fill_desc:
 			desc = dwc_desc_get(dwc);
@@ -1417,9 +1439,19 @@ static int __devinit dw_probe(struct platform_device *pdev)
 	dw->regs = regs;
 
 	/* get hardware configuration parameters */
-	if (autocfg)
+	if (autocfg) {
 		max_blk_size = dma_readl(dw, MAX_BLK_SIZE);
 
+		dw->nr_masters = (dw_params >> DW_PARAMS_NR_MASTER & 3) + 1;
+		for (i = 0; i < dw->nr_masters; i++) {
+			dw->data_width[i] =
+				(dw_params >> DW_PARAMS_DATA_WIDTH(i) & 3) + 2;
+		}
+	} else {
+		dw->nr_masters = pdata->nr_masters;
+		memcpy(dw->data_width, pdata->data_width, 4);
+	}
+
 	/* Calculate all channel mask before DMA setup */
 	dw->all_chan_mask = (1 << nr_channels) - 1;
 
@@ -1466,6 +1498,8 @@ static int __devinit dw_probe(struct platform_device *pdev)
 
 		channel_clear_bit(dw, CH_EN, dwc->mask);
 
+		dwc->dw = dw;
+
 		/* hardware configuration */
 		if (autocfg)
 			/* Decode maximum block size for given channel. The
diff --git a/drivers/dma/dw_dmac_regs.h b/drivers/dma/dw_dmac_regs.h
index 2a1cc53..06f0391 100644
--- a/drivers/dma/dw_dmac_regs.h
+++ b/drivers/dma/dw_dmac_regs.h
@@ -198,6 +198,9 @@ struct dw_dma_chan {
 
 	/* configuration passed via DMA_SLAVE_CONFIG */
 	struct dma_slave_config dma_sconfig;
+
+	/* backlink to dw_dma */
+	struct dw_dma		*dw;
 };
 
 static inline struct dw_dma_chan_regs __iomem *
@@ -224,6 +227,10 @@ struct dw_dma {
 
 	u8			all_chan_mask;
 
+	/* hardware configuration */
+	unsigned char		nr_masters;
+	unsigned char		data_width[4];
+
 	struct dw_dma_chan	chan[0];
 };
 
diff --git a/include/linux/dw_dmac.h b/include/linux/dw_dmac.h
index 3315ef9..e1c8c9e 100644
--- a/include/linux/dw_dmac.h
+++ b/include/linux/dw_dmac.h
@@ -20,6 +20,9 @@
  * @is_private: The device channels should be marked as private and not for
  *	by the general purpose DMA channel allocator.
  * @block_size: Maximum block size supported by the controller
+ * @nr_masters: Number of AHB masters supported by the controller
+ * @data_width: Maximum data width supported by hardware per AHB master
+ *		(0 - 8bits, 1 - 16bits, ..., 5 - 256bits)
  */
 struct dw_dma_platform_data {
 	unsigned int	nr_channels;
@@ -31,6 +34,8 @@ struct dw_dma_platform_data {
 #define CHAN_PRIORITY_DESCENDING	1	/* chan7 highest */
 	unsigned char	chan_priority;
 	unsigned short	block_size;
+	unsigned char	nr_masters;
+	unsigned char	data_width[4];
 };
 
 /* bursts size */
-- 
1.7.10.4

