Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759591Ab2CNLmL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 07:42:11 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:1266 "EHLO sjogate2.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754862Ab2CNLmG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 07:42:06 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: vinod.koul@intel.com, linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, viresh.kumar@st.com, plagnioj@jcrosoft.com,
        ludovic.desroches@atmel.com, Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH] dmaengine: at_hdmac: add slave config operation
Date: Wed, 14 Mar 2012 12:41:43 +0100
Message-Id: <1331725303-26298-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces DMA_SLAVE_CONFIG to at_hdmac Atmel DMA driver.

It is needed to fix a regression in the use of atmel-mci.c driver on Atmel
AT91 platforms brouth by e2b35f3:
"dmaengine/dw_dmac: Fix dw_dmac user drivers to adapt to slave_config changes"

We remove some parts of the private structure "at_dma_slave" and use the
information provided by "struct dma_slave_config": source/destination
peripheral registers and access width.

AT_DMA_SLAVE_WIDTH_* values used previously are not needed anymore as we
now use the standard ones. Although some conversion functions are needed to
match register expected values.

Some AT91 sub-architecture specific files are slightly touched by this patch
but it cannot be split because it can break compilation.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 arch/arm/mach-at91/at91sam9g45_devices.c   |    1 -
 arch/arm/mach-at91/include/mach/at_hdmac.h |   15 -------
 drivers/dma/at_hdmac.c                     |   56 +++++++++++++++++++++------
 drivers/dma/at_hdmac_regs.h                |   32 ++++++++++++++++
 4 files changed, 75 insertions(+), 29 deletions(-)

diff --git a/arch/arm/mach-at91/at91sam9g45_devices.c b/arch/arm/mach-at91/at91sam9g45_devices.c
index 96e2adc..28d3401 100644
--- a/arch/arm/mach-at91/at91sam9g45_devices.c
+++ b/arch/arm/mach-at91/at91sam9g45_devices.c
@@ -432,7 +432,6 @@ void __init at91_add_device_mci(short mmc_id, struct mci_platform_data *data)
 
 	/* DMA slave channel configuration */
 	atslave->dma_dev = &at_hdmac_device.dev;
-	atslave->reg_width = AT_DMA_SLAVE_WIDTH_32BIT;
 	atslave->cfg = ATC_FIFOCFG_HALFFIFO
 			| ATC_SRC_H2SEL_HW | ATC_DST_H2SEL_HW;
 	atslave->ctrla = ATC_SCSIZE_16 | ATC_DCSIZE_16;
diff --git a/arch/arm/mach-at91/include/mach/at_hdmac.h b/arch/arm/mach-at91/include/mach/at_hdmac.h
index 187cb58..fff48d1 100644
--- a/arch/arm/mach-at91/include/mach/at_hdmac.h
+++ b/arch/arm/mach-at91/include/mach/at_hdmac.h
@@ -24,18 +24,6 @@ struct at_dma_platform_data {
 };
 
 /**
- * enum at_dma_slave_width - DMA slave register access width.
- * @AT_DMA_SLAVE_WIDTH_8BIT: Do 8-bit slave register accesses
- * @AT_DMA_SLAVE_WIDTH_16BIT: Do 16-bit slave register accesses
- * @AT_DMA_SLAVE_WIDTH_32BIT: Do 32-bit slave register accesses
- */
-enum at_dma_slave_width {
-	AT_DMA_SLAVE_WIDTH_8BIT = 0,
-	AT_DMA_SLAVE_WIDTH_16BIT,
-	AT_DMA_SLAVE_WIDTH_32BIT,
-};
-
-/**
  * struct at_dma_slave - Controller-specific information about a slave
  * @dma_dev: required DMA master device
  * @tx_reg: physical address of data register used for
@@ -48,9 +36,6 @@ enum at_dma_slave_width {
  */
 struct at_dma_slave {
 	struct device		*dma_dev;
-	dma_addr_t		tx_reg;
-	dma_addr_t		rx_reg;
-	enum at_dma_slave_width	reg_width;
 	u32			cfg;
 	u32			ctrla;
 };
diff --git a/drivers/dma/at_hdmac.c b/drivers/dma/at_hdmac.c
index 5d225dd..b015a5c 100644
--- a/drivers/dma/at_hdmac.c
+++ b/drivers/dma/at_hdmac.c
@@ -647,6 +647,7 @@ atc_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
 {
 	struct at_dma_chan	*atchan = to_at_dma_chan(chan);
 	struct at_dma_slave	*atslave = chan->private;
+	struct dma_slave_config	*sconfig = &atchan->dma_sconfig;
 	struct at_desc		*first = NULL;
 	struct at_desc		*prev = NULL;
 	u32			ctrla;
@@ -668,19 +669,18 @@ atc_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
 		return NULL;
 	}
 
-	reg_width = atslave->reg_width;
-
 	ctrla = ATC_DEFAULT_CTRLA | atslave->ctrla;
 	ctrlb = ATC_IEN;
 
 	switch (direction) {
 	case DMA_MEM_TO_DEV:
+		reg_width = convert_buswidth(sconfig->dst_addr_width);
 		ctrla |=  ATC_DST_WIDTH(reg_width);
 		ctrlb |=  ATC_DST_ADDR_MODE_FIXED
 			| ATC_SRC_ADDR_MODE_INCR
 			| ATC_FC_MEM2PER
 			| ATC_SIF(AT_DMA_MEM_IF) | ATC_DIF(AT_DMA_PER_IF);
-		reg = atslave->tx_reg;
+		reg = sconfig->dst_addr;
 		for_each_sg(sgl, sg, sg_len, i) {
 			struct at_desc	*desc;
 			u32		len;
@@ -708,13 +708,14 @@ atc_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
 		}
 		break;
 	case DMA_DEV_TO_MEM:
+		reg_width = convert_buswidth(sconfig->src_addr_width);
 		ctrla |=  ATC_SRC_WIDTH(reg_width);
 		ctrlb |=  ATC_DST_ADDR_MODE_INCR
 			| ATC_SRC_ADDR_MODE_FIXED
 			| ATC_FC_PER2MEM
 			| ATC_SIF(AT_DMA_PER_IF) | ATC_DIF(AT_DMA_MEM_IF);
 
-		reg = atslave->rx_reg;
+		reg = sconfig->src_addr;
 		for_each_sg(sgl, sg, sg_len, i) {
 			struct at_desc	*desc;
 			u32		len;
@@ -790,12 +791,15 @@ err_out:
  * atc_dma_cyclic_fill_desc - Fill one period decriptor
  */
 static int
-atc_dma_cyclic_fill_desc(struct at_dma_slave *atslave, struct at_desc *desc,
+atc_dma_cyclic_fill_desc(struct dma_chan *chan, struct at_desc *desc,
 		unsigned int period_index, dma_addr_t buf_addr,
-		size_t period_len, enum dma_transfer_direction direction)
+		unsigned int reg_width, size_t period_len,
+		enum dma_transfer_direction direction)
 {
-	u32		ctrla;
-	unsigned int	reg_width = atslave->reg_width;
+	struct at_dma_chan	*atchan = to_at_dma_chan(chan);
+	struct at_dma_slave	*atslave = chan->private;
+	struct dma_slave_config	*sconfig = &atchan->dma_sconfig;
+	u32			ctrla;
 
 	/* prepare common CRTLA value */
 	ctrla =   ATC_DEFAULT_CTRLA | atslave->ctrla
@@ -806,7 +810,7 @@ atc_dma_cyclic_fill_desc(struct at_dma_slave *atslave, struct at_desc *desc,
 	switch (direction) {
 	case DMA_MEM_TO_DEV:
 		desc->lli.saddr = buf_addr + (period_len * period_index);
-		desc->lli.daddr = atslave->tx_reg;
+		desc->lli.daddr = sconfig->dst_addr;
 		desc->lli.ctrla = ctrla;
 		desc->lli.ctrlb = ATC_DST_ADDR_MODE_FIXED
 				| ATC_SRC_ADDR_MODE_INCR
@@ -816,7 +820,7 @@ atc_dma_cyclic_fill_desc(struct at_dma_slave *atslave, struct at_desc *desc,
 		break;
 
 	case DMA_DEV_TO_MEM:
-		desc->lli.saddr = atslave->rx_reg;
+		desc->lli.saddr = sconfig->src_addr;
 		desc->lli.daddr = buf_addr + (period_len * period_index);
 		desc->lli.ctrla = ctrla;
 		desc->lli.ctrlb = ATC_DST_ADDR_MODE_INCR
@@ -847,9 +851,11 @@ atc_prep_dma_cyclic(struct dma_chan *chan, dma_addr_t buf_addr, size_t buf_len,
 {
 	struct at_dma_chan	*atchan = to_at_dma_chan(chan);
 	struct at_dma_slave	*atslave = chan->private;
+	struct dma_slave_config	*sconfig = &atchan->dma_sconfig;
 	struct at_desc		*first = NULL;
 	struct at_desc		*prev = NULL;
 	unsigned long		was_cyclic;
+	unsigned int		reg_width;
 	unsigned int		periods = buf_len / period_len;
 	unsigned int		i;
 
@@ -869,8 +875,13 @@ atc_prep_dma_cyclic(struct dma_chan *chan, dma_addr_t buf_addr, size_t buf_len,
 		return NULL;
 	}
 
+	if (sconfig->direction == DMA_MEM_TO_DEV)
+		reg_width = convert_buswidth(sconfig->dst_addr_width);
+	else
+		reg_width = convert_buswidth(sconfig->src_addr_width);
+
 	/* Check for too big/unaligned periods and unaligned DMA buffer */
-	if (atc_dma_cyclic_check_values(atslave->reg_width, buf_addr,
+	if (atc_dma_cyclic_check_values(reg_width, buf_addr,
 					period_len, direction))
 		goto err_out;
 
@@ -882,8 +893,8 @@ atc_prep_dma_cyclic(struct dma_chan *chan, dma_addr_t buf_addr, size_t buf_len,
 		if (!desc)
 			goto err_desc_get;
 
-		if (atc_dma_cyclic_fill_desc(atslave, desc, i, buf_addr,
-						period_len, direction))
+		if (atc_dma_cyclic_fill_desc(chan, desc, i, buf_addr,
+					     reg_width, period_len, direction))
 			goto err_desc_get;
 
 		atc_desc_chain(&first, &prev, desc);
@@ -906,6 +917,23 @@ err_out:
 	return NULL;
 }
 
+static int set_runtime_config(struct dma_chan *chan,
+			      struct dma_slave_config *sconfig)
+{
+	struct at_dma_chan	*atchan = to_at_dma_chan(chan);
+
+	/* Check if it is chan is configured for slave transfers */
+	if (!chan->private)
+		return -EINVAL;
+
+	memcpy(&atchan->dma_sconfig, sconfig, sizeof(*sconfig));
+
+	convert_burst(&atchan->dma_sconfig.src_maxburst);
+	convert_burst(&atchan->dma_sconfig.dst_maxburst);
+
+	return 0;
+}
+
 
 static int atc_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
 		       unsigned long arg)
@@ -966,6 +994,8 @@ static int atc_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
 		clear_bit(ATC_IS_CYCLIC, &atchan->status);
 
 		spin_unlock_irqrestore(&atchan->lock, flags);
+	} else if (cmd == DMA_SLAVE_CONFIG) {
+		return set_runtime_config(chan, (struct dma_slave_config *)arg);
 	} else {
 		return -ENXIO;
 	}
diff --git a/drivers/dma/at_hdmac_regs.h b/drivers/dma/at_hdmac_regs.h
index 08fd8a0..897a8bc 100644
--- a/drivers/dma/at_hdmac_regs.h
+++ b/drivers/dma/at_hdmac_regs.h
@@ -207,6 +207,7 @@ enum atc_status {
  * @save_cfg: configuration register that is saved on suspend/resume cycle
  * @save_dscr: for cyclic operations, preserve next descriptor address in
  *             the cyclic list on suspend/resume cycle
+ * @dma_sconfig: configuration for slave transfers, passed via DMA_SLAVE_CONFIG
  * @lock: serializes enqueue/dequeue operations to descriptors lists
  * @active_list: list of descriptors dmaengine is being running on
  * @queue: list of descriptors ready to be submitted to engine
@@ -222,6 +223,7 @@ struct at_dma_chan {
 	struct tasklet_struct	tasklet;
 	u32			save_cfg;
 	u32			save_dscr;
+	struct dma_slave_config dma_sconfig;
 
 	spinlock_t		lock;
 
@@ -243,6 +245,36 @@ static inline struct at_dma_chan *to_at_dma_chan(struct dma_chan *dchan)
 	return container_of(dchan, struct at_dma_chan, chan_common);
 }
 
+/*
+ * Fix sconfig's burst size according to at_hdmac. We need to convert them as:
+ * 1 -> 0, 4 -> 1, 8 -> 2, 16 -> 3, 32 -> 4, 64 -> 5, 128 -> 6, 256 -> 7.
+ *
+ * This can be done by finding most significant bit set.
+ */
+static inline void convert_burst(u32 *maxburst)
+{
+	if (*maxburst > 1)
+		*maxburst = fls(*maxburst) - 2;
+	else
+		*maxburst = 0;
+}
+
+/*
+ * Fix sconfig's bus width according to at_hdmac.
+ * 1 byte -> 0, 2 bytes -> 1, 4 bytes -> 2.
+ */
+static inline u8 convert_buswidth(enum dma_slave_buswidth addr_width)
+{
+	switch (addr_width) {
+	case DMA_SLAVE_BUSWIDTH_2_BYTES:
+		return 1;
+	case DMA_SLAVE_BUSWIDTH_4_BYTES:
+		return 2;
+	default:
+		/* For 1 byte width or fallback */
+		return 0;
+	}
+}
 
 /*--  Controller  ------------------------------------------------------*/
 
-- 
1.7.9

