Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761319Ab0GUTYo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 15:24:44 -0400
Received: from mail.df.lth.se ([194.47.250.12]:36702 "EHLO df.lth.se"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758793Ab0GUTYm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 15:24:42 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: linux-kernel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>, Alan Cox <alan@linux.intel.com>,
        Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH 3/3] DMAENGINE: add runtime slave control to COH 901 318 v2
Date: Wed, 21 Jul 2010 21:23:23 +0200
Message-Id: <1279740203-22723-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.6.2.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This extends the DMA engine driver for the COH 901 318 used in the
U300 platform with the generic runtime slave control command.

Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
 drivers/dma/coh901318.c |  169 +++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 169 insertions(+), 0 deletions(-)

diff --git a/drivers/dma/coh901318.c b/drivers/dma/coh901318.c
index a724e6b..557e227 100644
--- a/drivers/dma/coh901318.c
+++ b/drivers/dma/coh901318.c
@@ -72,6 +72,9 @@ struct coh901318_chan {
 	unsigned long nbr_active_done;
 	unsigned long busy;
 
+	u32 runtime_addr;
+	u32 runtime_ctrl;
+
 	struct coh901318_base *base;
 };
 
@@ -190,6 +193,9 @@ static inline struct coh901318_chan *to_coh901318_chan(struct dma_chan *chan)
 static inline dma_addr_t
 cohc_dev_addr(struct coh901318_chan *cohc)
 {
+	/* Runtime supplied address will take precedence */
+	if (cohc->runtime_addr)
+		return cohc->runtime_addr;
 	return cohc->base->platform->chan_conf[cohc->id].dev_addr;
 }
 
@@ -1055,6 +1061,14 @@ coh901318_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
 
 	params = cohc_chan_param(cohc);
 	config = params->config;
+	/*
+	 * Add runtime-specific control on top, make
+	 * sure the bits you set per peripheral channel are
+	 * cleared in the default config from the platform.
+	 */
+	ctrl_chained |= cohc->runtime_ctrl;
+	ctrl_last |= cohc->runtime_ctrl;
+	ctrl |= cohc->runtime_ctrl;
 
 	if (direction == DMA_TO_DEVICE) {
 		u32 tx_flags = COH901318_CX_CTRL_PRDD_SOURCE |
@@ -1113,6 +1127,12 @@ coh901318_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
 	if (ret)
 		goto err_lli_fill;
 
+	/*
+	 * Set the default ctrl for the channel to the one from the lli,
+	 * things may have changed due to odd buffer alignment etc.
+	 */
+	coh901318_set_ctrl(cohc, lli->control);
+
 	COH_DBG(coh901318_list_print(cohc, lli));
 
 	/* Pick a descriptor to handle this transfer */
@@ -1175,6 +1195,146 @@ coh901318_issue_pending(struct dma_chan *chan)
 	spin_unlock_irqrestore(&cohc->lock, flags);
 }
 
+/*
+ * Here we wrap in the runtime dma control interface
+ */
+struct burst_table {
+	int burst_8bit;
+	int burst_16bit;
+	int burst_32bit;
+	u32 reg;
+};
+
+static const struct burst_table burst_sizes[] = {
+	{
+		.burst_8bit = 64,
+		.burst_16bit = 32,
+		.burst_32bit = 16,
+		.reg = COH901318_CX_CTRL_BURST_COUNT_64_BYTES,
+	},
+	{
+		.burst_8bit = 48,
+		.burst_16bit = 24,
+		.burst_32bit = 12,
+		.reg = COH901318_CX_CTRL_BURST_COUNT_48_BYTES,
+	},
+	{
+		.burst_8bit = 32,
+		.burst_16bit = 16,
+		.burst_32bit = 8,
+		.reg = COH901318_CX_CTRL_BURST_COUNT_32_BYTES,
+	},
+	{
+		.burst_8bit = 16,
+		.burst_16bit = 8,
+		.burst_32bit = 4,
+		.reg = COH901318_CX_CTRL_BURST_COUNT_16_BYTES,
+	},
+	{
+		.burst_8bit = 8,
+		.burst_16bit = 4,
+		.burst_32bit = 2,
+		.reg = COH901318_CX_CTRL_BURST_COUNT_8_BYTES,
+	},
+	{
+		.burst_8bit = 4,
+		.burst_16bit = 2,
+		.burst_32bit = 1,
+		.reg = COH901318_CX_CTRL_BURST_COUNT_4_BYTES,
+	},
+	{
+		.burst_8bit = 2,
+		.burst_16bit = 1,
+		.burst_32bit = 0,
+		.reg = COH901318_CX_CTRL_BURST_COUNT_2_BYTES,
+	},
+	{
+		.burst_8bit = 1,
+		.burst_16bit = 0,
+		.burst_32bit = 0,
+		.reg = COH901318_CX_CTRL_BURST_COUNT_1_BYTE,
+	},
+};
+
+static void coh901318_dma_set_runtimeconfig(struct dma_chan *chan,
+			struct dma_slave_config *config)
+{
+	struct coh901318_chan *cohc = to_coh901318_chan(chan);
+	dma_addr_t addr;
+	enum dma_slave_buswidth addr_width;
+	u32 maxburst;
+	u32 runtime_ctrl = 0;
+	int i = 0;
+
+	/* We only support mem to per or per to mem transfers */
+	if (config->direction == DMA_FROM_DEVICE) {
+		addr = config->src_addr;
+		addr_width = config->src_addr_width;
+		maxburst = config->src_maxburst;
+	} else if (config->direction == DMA_TO_DEVICE) {
+		addr = config->dst_addr;
+		addr_width = config->dst_addr_width;
+		maxburst = config->dst_maxburst;
+	} else {
+		dev_err(COHC_2_DEV(cohc), "illegal channel mode\n");
+		return;
+	}
+
+	dev_dbg(COHC_2_DEV(cohc), "configure channel for %d byte transfers\n",
+		addr_width);
+	switch (addr_width)  {
+	case DMA_SLAVE_BUSWIDTH_1_BYTE:
+		runtime_ctrl |=
+			COH901318_CX_CTRL_SRC_BUS_SIZE_8_BITS |
+			COH901318_CX_CTRL_DST_BUS_SIZE_8_BITS;
+
+		while (i < ARRAY_SIZE(burst_sizes)) {
+			if (burst_sizes[i].burst_8bit <= maxburst)
+				break;
+			i++;
+		}
+
+		break;
+	case DMA_SLAVE_BUSWIDTH_2_BYTES:
+		runtime_ctrl |=
+			COH901318_CX_CTRL_SRC_BUS_SIZE_16_BITS |
+			COH901318_CX_CTRL_DST_BUS_SIZE_16_BITS;
+
+		while (i < ARRAY_SIZE(burst_sizes)) {
+			if (burst_sizes[i].burst_16bit <= maxburst)
+				break;
+			i++;
+		}
+
+		break;
+	case DMA_SLAVE_BUSWIDTH_4_BYTES:
+		/* Direction doesn't matter here, it's 32/32 bits */
+		runtime_ctrl |=
+			COH901318_CX_CTRL_SRC_BUS_SIZE_32_BITS |
+			COH901318_CX_CTRL_DST_BUS_SIZE_32_BITS;
+
+		while (i < ARRAY_SIZE(burst_sizes)) {
+			if (burst_sizes[i].burst_32bit <= maxburst)
+				break;
+			i++;
+		}
+
+		break;
+	default:
+		dev_err(COHC_2_DEV(cohc),
+			"bad runtimeconfig: alien address width\n");
+		return;
+	}
+
+	runtime_ctrl |= burst_sizes[i].reg;
+	dev_dbg(COHC_2_DEV(cohc),
+		"selected burst size %d bytes for address width %d bytes, maxburst %d\n",
+		burst_sizes[i].burst_8bit, addr_width, maxburst);
+
+	cohc->runtime_addr = addr;
+	cohc->runtime_ctrl = runtime_ctrl;
+}
+
 static int
 coh901318_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
 		  unsigned long arg)
@@ -1184,6 +1344,14 @@ coh901318_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
 	struct coh901318_desc *cohd;
 	void __iomem *virtbase = cohc->base->virtbase;
 
+	if (cmd == DMA_SLAVE_CONFIG) {
+		struct dma_slave_config *config =
+			(struct dma_slave_config *) arg;
+
+		coh901318_dma_set_runtimeconfig(chan, config);
+		return 0;
+	  }
+
 	if (cmd == DMA_PAUSE) {
 		coh901318_pause(chan);
 		return 0;
@@ -1240,6 +1408,7 @@ coh901318_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
 
 	return 0;
 }
+
 void coh901318_base_init(struct dma_device *dma, const int *pick_chans,
 			 struct coh901318_base *base)
 {
-- 
1.7.1.1

