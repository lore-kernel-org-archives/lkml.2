Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754296Ab2IQHjY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 03:39:24 -0400
Received: from mga03.intel.com ([143.182.124.21]:57509 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754163Ab2IQHjR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 03:39:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,434,1344236400"; 
   d="scan'208";a="193525280"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Viresh Kumar <viresh.linux@gmail.com>, Vinod Koul <vinod.koul@intel.com>,
        spear-devel@list.st.com, linux-kernel@vger.kernel.org,
        Hein Tibosch <hein_tibosch@yahoo.es>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 5/7] dw_dmac: autoconfigure data_width or get it via platform data
Date: Mon, 17 Sep 2012 10:39:35 +0300
Message-Id: <1347867577-13170-6-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1347867577-13170-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1347867577-13170-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not all of the controllers support the 64 bit data width. Make it configurable
via platform data. The driver will try to get a value from the component
parameters, otherwise it will use the platform data..

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 arch/arm/mach-spear13xx/spear13xx.c |    2 ++
 arch/avr32/mach-at32ap/at32ap700x.c |    2 ++
 drivers/dma/dw_dmac.c               |   46 +++++++++++++++++++++++++++++++----
 drivers/dma/dw_dmac_regs.h          |   13 ++++++++++
 include/linux/dw_dmac.h             |    5 ++++
 5 files changed, 63 insertions(+), 5 deletions(-)

diff --git a/arch/arm/mach-spear13xx/spear13xx.c b/arch/arm/mach-spear13xx/spear13xx.c
index c64d812..6a7dfe1 100644
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
index ab718ee..fdb7d5a 100644
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
@@ -647,7 +657,11 @@ dwc_prep_dma_memcpy(struct dma_chan *chan, dma_addr_t dest, dma_addr_t src,
 		return NULL;
 	}
 
-	src_width = dst_width = dwc_fast_fls(src | dest | len);
+	src_width = dst_width = min_t(unsigned int,
+				      /* For memory-to-memory transfers we
+				       * always use AHB master 1 */
+				      dwc->dw->data_width[0],
+				      dwc_fast_fls(src | dest | len));
 
 	ctllo = DWC_DEFAULT_CTLLO(chan)
 			| DWC_CTLL_DST_WIDTH(dst_width)
@@ -717,6 +731,7 @@ dwc_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
 	dma_addr_t		reg;
 	unsigned int		reg_width;
 	unsigned int		mem_width;
+	unsigned int		data_width;
 	unsigned int		i;
 	struct scatterlist	*sg;
 	size_t			total_len = 0;
@@ -740,6 +755,8 @@ dwc_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
 		ctllo |= sconfig->device_fc ? DWC_CTLL_FC(DW_DMA_FC_P_M2P) :
 			DWC_CTLL_FC(DW_DMA_FC_D_M2P);
 
+		data_width = dwc->dw->data_width[dwc_get_sms(dws)];
+
 		for_each_sg(sgl, sg, sg_len, i) {
 			struct dw_desc	*desc;
 			u32		len, dlen, mem;
@@ -747,7 +764,9 @@ dwc_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
 			mem = sg_dma_address(sg);
 			len = sg_dma_len(sg);
 
-			mem_width = dwc_fast_fls(mem | len);
+			mem_width = min_t(unsigned int,
+					  data_width,
+					  dwc_fast_fls(mem | len));
 
 slave_sg_todev_fill_desc:
 			desc = dwc_desc_get(dwc);
@@ -800,6 +819,8 @@ slave_sg_todev_fill_desc:
 		ctllo |= sconfig->device_fc ? DWC_CTLL_FC(DW_DMA_FC_P_P2M) :
 			DWC_CTLL_FC(DW_DMA_FC_D_P2M);
 
+		data_width = dwc->dw->data_width[dwc_get_dms(dws)];
+
 		for_each_sg(sgl, sg, sg_len, i) {
 			struct dw_desc	*desc;
 			u32		len, dlen, mem;
@@ -807,7 +828,9 @@ slave_sg_todev_fill_desc:
 			mem = sg_dma_address(sg);
 			len = sg_dma_len(sg);
 
-			mem_width = dwc_fast_fls(mem | len);
+			mem_width = min_t(unsigned int,
+					  data_width,
+					  dwc_fast_fls(mem | len));
 
 slave_sg_fromdev_fill_desc:
 			desc = dwc_desc_get(dwc);
@@ -1413,6 +1436,17 @@ static int __devinit dw_probe(struct platform_device *pdev)
 
 	/* get hardware configuration parameters */
 	max_blk_size = dma_readl(dw, MAX_BLK_SIZE);
+	if (autocfg)
+		dw->nr_masters = (dw_params >> DW_PARAMS_NR_MASTER & 3) + 1;
+	else
+		dw->nr_masters = pdata->nr_masters;
+	for (i = 0; i < dw->nr_masters; i++) {
+		if (autocfg)
+			dw->data_width[i] =
+				(dw_params >> DW_PARAMS_DATA_WIDTH(i) & 3) + 2;
+		else
+			dw->data_width[i] = pdata->data_width[i];
+	}
 
 	/* Calculate all channel mask before DMA setup */
 	dw->all_chan_mask = (1 << nr_channels) - 1;
@@ -1460,6 +1494,8 @@ static int __devinit dw_probe(struct platform_device *pdev)
 
 		channel_clear_bit(dw, CH_EN, dwc->mask);
 
+		dwc->dw = dw;
+
 		/* hardware configuration */
 		if (autocfg) {
 			dwc->block_size =
diff --git a/drivers/dma/dw_dmac_regs.h b/drivers/dma/dw_dmac_regs.h
index 233f5e5..9beaef0 100644
--- a/drivers/dma/dw_dmac_regs.h
+++ b/drivers/dma/dw_dmac_regs.h
@@ -106,6 +106,12 @@ struct dw_dma_regs {
 
 /* Bitfields in DW_PARAMS */
 #define DW_PARAMS_NR_CHAN	8		/* number of channels */
+#define DW_PARAMS_NR_MASTER	11		/* number of AHB masters */
+#define DW_PARAMS_DATA_WIDTH(n)	(15 + 2 * (n))
+#define DW_PARAMS_DATA_WIDTH1	15		/* master 1 data width */
+#define DW_PARAMS_DATA_WIDTH2	17		/* master 2 data width */
+#define DW_PARAMS_DATA_WIDTH3	19		/* master 3 data width */
+#define DW_PARAMS_DATA_WIDTH4	21		/* master 4 data width */
 #define DW_PARAMS_EN		28		/* encoded parameters */
 
 /* Bitfields in CTL_LO */
@@ -191,6 +197,9 @@ struct dw_dma_chan {
 
 	/* configuration passed via DMA_SLAVE_CONFIG */
 	struct dma_slave_config dma_sconfig;
+
+	/* backlink to dw_dma */
+	struct dw_dma		*dw;
 };
 
 static inline struct dw_dma_chan_regs __iomem *
@@ -217,6 +226,10 @@ struct dw_dma {
 
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

