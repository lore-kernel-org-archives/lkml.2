Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757025Ab0FKP1P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 11:27:15 -0400
Received: from eu1sys200aog120.obsmtp.com ([207.126.144.149]:58485 "EHLO
	eu1sys200aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756533Ab0FKP1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 11:27:12 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Dan Williams <dan.j.williams@intel.com>,
       <linux-arm-kernel@lists.infradead.org>, <yuanyabin1978@sina.com>
Cc: <linux-kernel@vger.kernel.org>,
       Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH 02/13] DMAENGINE: add generic PrimeCell interface to COH 901 318 v7
Date: Fri, 11 Jun 2010 17:26:37 +0200
Message-ID: <1276269997-1375-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.6.3.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This extends the DMA engine driver for the COH 901 318 used in the
U300 platform with the generic PrimeCell interface.

Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
 drivers/dma/coh901318.c |  154 +++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 154 insertions(+), 0 deletions(-)

diff --git a/drivers/dma/coh901318.c b/drivers/dma/coh901318.c
index a724e6b..6b21069 100644
--- a/drivers/dma/coh901318.c
+++ b/drivers/dma/coh901318.c
@@ -21,6 +21,7 @@
 #include <linux/uaccess.h>
 #include <linux/debugfs.h>
 #include <mach/coh901318.h>
+#include <linux/amba/dma.h>
 
 #include "coh901318_lli.h"
 
@@ -72,6 +73,9 @@ struct coh901318_chan {
 	unsigned long nbr_active_done;
 	unsigned long busy;
 
+	u32 amba_addr;
+	u32 amba_ctrl;
+
 	struct coh901318_base *base;
 };
 
@@ -190,6 +194,9 @@ static inline struct coh901318_chan *to_coh901318_chan(struct dma_chan *chan)
 static inline dma_addr_t
 cohc_dev_addr(struct coh901318_chan *cohc)
 {
+	/* PrimeCell supplied address will take precedence */
+	if (cohc->amba_addr)
+		return cohc->amba_addr;
 	return cohc->base->platform->chan_conf[cohc->id].dev_addr;
 }
 
@@ -1055,6 +1062,14 @@ coh901318_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
 
 	params = cohc_chan_param(cohc);
 	config = params->config;
+	/*
+	 * Add primecell-specific control on top, make
+	 * sure the bits you set per peripheral channel are
+	 * cleared in the default config from the platform.
+	 */
+	ctrl_chained |= cohc->amba_ctrl;
+	ctrl_last |= cohc->amba_ctrl;
+	ctrl |= cohc->amba_ctrl;
 
 	if (direction == DMA_TO_DEVICE) {
 		u32 tx_flags = COH901318_CX_CTRL_PRDD_SOURCE |
@@ -1113,6 +1128,12 @@ coh901318_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
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
@@ -1175,6 +1196,130 @@ coh901318_issue_pending(struct dma_chan *chan)
 	spin_unlock_irqrestore(&cohc->lock, flags);
 }
 
+/*
+ * Here we wrap in the PrimeCell dma interface
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
+static void coh901318_dma_set_ambaconfig(struct dma_chan *chan,
+			struct amba_dma_channel_config *config)
+{
+	struct coh901318_chan *cohc = to_coh901318_chan(chan);
+	int maxburst = config->maxburst;
+	u32 amba_ctrl = 0;
+	int i = 0;
+
+	dev_dbg(COHC_2_DEV(cohc), "configure channel for %d byte transfers\n",
+		config->addr_width);
+	switch (config->addr_width)  {
+	case 1:
+		amba_ctrl |=
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
+	case 2:
+		amba_ctrl |=
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
+	case 4:
+		/* Direction doesn't matter here, it's 32/32 bits */
+		amba_ctrl |=
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
+			"bad ambaconfig: alien address width\n");
+		return;
+	}
+
+	amba_ctrl |= burst_sizes[i].reg;
+	dev_dbg(COHC_2_DEV(cohc),
+		"selected burst size %d bytes for address width %d bytes, maxburst %d\n",
+		burst_sizes[i].burst_8bit, config->addr_width, maxburst);
+
+	cohc->amba_addr = config->addr;
+	cohc->amba_ctrl = amba_ctrl;
+}
+
 static int
 coh901318_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
 		  unsigned long arg)
@@ -1184,6 +1329,14 @@ coh901318_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
 	struct coh901318_desc *cohd;
 	void __iomem *virtbase = cohc->base->virtbase;
 
+	if (cmd == DMA_CONFIG_AMBA) {
+		struct amba_dma_channel_config *config =
+			(struct amba_dma_channel_config *) arg;
+
+		coh901318_dma_set_ambaconfig(chan, config);
+		return 0;
+	  }
+
 	if (cmd == DMA_PAUSE) {
 		coh901318_pause(chan);
 		return 0;
@@ -1240,6 +1393,7 @@ coh901318_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
 
 	return 0;
 }
+
 void coh901318_base_init(struct dma_device *dma, const int *pick_chans,
 			 struct coh901318_base *base)
 {
-- 
1.6.3.3

