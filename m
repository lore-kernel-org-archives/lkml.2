Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758970Ab0GUTYK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 15:24:10 -0400
Received: from mail.df.lth.se ([194.47.250.12]:36674 "EHLO df.lth.se"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758793Ab0GUTYH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 15:24:07 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: linux-kernel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>, Alan Cox <alan@linux.intel.com>,
        Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH 2/3] DMAENGINE: add runtime slave config to DMA40 v2
Date: Wed, 21 Jul 2010 21:22:59 +0200
Message-Id: <1279740179-22451-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.6.2.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This extends the DMA engine driver for the DMA40 used in the
U8500 platform with the generic runtime slave configuration
interface.

Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
 drivers/dma/ste_dma40.c |  140 +++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 136 insertions(+), 4 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index c426829..bb3402c 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -205,6 +205,9 @@ struct d40_chan {
 	struct d40_def_lcsp		 log_def;
 	struct d40_lcla_elem		 lcla;
 	struct d40_log_lli_full		*lcpa;
+	/* Runtime reconfiguration */
+	dma_addr_t			runtime_addr;
+	enum dma_data_direction		runtime_direction;
 };
 
 /**
@@ -1890,7 +1893,10 @@ static int d40_prep_slave_sg_log(struct d40_desc *d40d,
 			lli_max = 1;
 
 	if (direction == DMA_FROM_DEVICE) {
-		dev_addr = d40c->base->plat_data->dev_rx[d40c->dma_cfg.src_dev_type];
+		if (d40c->runtime_addr)
+			dev_addr = d40c->runtime_addr;
+		else
+			dev_addr = d40c->base->plat_data->dev_rx[d40c->dma_cfg.src_dev_type];
 		total_size = d40_log_sg_to_dev(&d40c->lcla,
 					       sgl, sg_len,
 					       &d40d->lli_log,
@@ -1902,7 +1908,10 @@ static int d40_prep_slave_sg_log(struct d40_desc *d40d,
 					       dev_addr, lli_max,
 					       d40c->base->plat_data->llis_per_log);
 	} else if (direction == DMA_TO_DEVICE) {
-		dev_addr = d40c->base->plat_data->dev_tx[d40c->dma_cfg.dst_dev_type];
+		if (d40c->runtime_addr)
+			dev_addr = d40c->runtime_addr;
+		else
+			dev_addr = d40c->base->plat_data->dev_tx[d40c->dma_cfg.dst_dev_type];
 		total_size = d40_log_sg_to_dev(&d40c->lcla,
 					       sgl, sg_len,
 					       &d40d->lli_log,
@@ -1943,9 +1952,15 @@ static int d40_prep_slave_sg_phy(struct d40_desc *d40d,
 
 	if (direction == DMA_FROM_DEVICE) {
 		dst_dev_addr = 0;
-		src_dev_addr = d40c->base->plat_data->dev_rx[d40c->dma_cfg.src_dev_type];
+		if (d40c->runtime_addr)
+			src_dev_addr = d40c->runtime_addr;
+		else
+			src_dev_addr = d40c->base->plat_data->dev_rx[d40c->dma_cfg.src_dev_type];
 	} else if (direction == DMA_TO_DEVICE) {
-		dst_dev_addr = d40c->base->plat_data->dev_tx[d40c->dma_cfg.dst_dev_type];
+		if (d40c->runtime_addr)
+			dst_dev_addr = d40c->runtime_addr;
+		else
+			dst_dev_addr = d40c->base->plat_data->dev_tx[d40c->dma_cfg.dst_dev_type];
 		src_dev_addr = 0;
 	} else
 		return -EINVAL;
@@ -2065,6 +2080,117 @@ static void d40_issue_pending(struct dma_chan *chan)
 	spin_unlock_irqrestore(&d40c->lock, flags);
 }
 
+/* Runtime reconfiguration extension */
+static void d40_set_runtime_config(struct dma_chan *chan,
+			       struct dma_slave_config *config)
+{
+	struct d40_chan *d40c = container_of(chan, struct d40_chan, chan);
+	struct stedma40_chan_cfg *cfg = &d40c->dma_cfg;
+	enum dma_slave_buswidth config_addr_width;
+	dma_addr_t config_addr;
+	u32 config_maxburst;
+	enum stedma40_periph_data_width addr_width;
+	int psize;
+
+	if (config->direction == DMA_FROM_DEVICE) {
+		dma_addr_t dev_addr_rx =
+			d40c->base->plat_data->dev_rx[cfg->src_dev_type];
+
+		config_addr = config->src_addr;
+		if (dev_addr_rx)
+			dev_dbg(d40c->base->dev,
+				"channel has a pre-wired RX address %08x "
+				"overriding with %08x\n",
+				dev_addr_rx, config_addr);
+		if (cfg->dir != STEDMA40_PERIPH_TO_MEM)
+			dev_dbg(d40c->base->dev,
+				"channel was not configured for peripheral "
+				"to memory transfer (%d) overriding\n",
+				cfg->dir);
+		cfg->dir = STEDMA40_PERIPH_TO_MEM;
+
+		config_addr_width = config->src_addr_width;
+		config_maxburst = config->src_maxburst;
+
+	} else if (config->direction == DMA_TO_DEVICE) {
+		dma_addr_t dev_addr_tx =
+			d40c->base->plat_data->dev_tx[cfg->dst_dev_type];
+
+		config_addr = config->dst_addr;
+		if (dev_addr_tx)
+			dev_dbg(d40c->base->dev,
+				"channel has a pre-wired TX address %08x "
+				"overriding with %08x\n",
+				dev_addr_tx, config_addr);
+		if (cfg->dir != STEDMA40_MEM_TO_PERIPH)
+			dev_dbg(d40c->base->dev,
+				"channel was not configured for memory "
+				"to peripheral transfer (%d) overriding\n",
+				cfg->dir);
+		cfg->dir = STEDMA40_MEM_TO_PERIPH;
+
+		config_addr_width = config->dst_addr_width;
+		config_maxburst = config->dst_maxburst;
+
+	} else {
+		dev_err(d40c->base->dev,
+			"unrecognized channel direction %d\n",
+			config->direction);
+		return;
+	}
+
+	switch (config_addr_width) {
+	case DMA_SLAVE_BUSWIDTH_1_BYTE:
+		addr_width = STEDMA40_BYTE_WIDTH;
+		break;
+	case DMA_SLAVE_BUSWIDTH_2_BYTES:
+		addr_width = STEDMA40_HALFWORD_WIDTH;
+		break;
+	case DMA_SLAVE_BUSWIDTH_4_BYTES:
+		addr_width = STEDMA40_WORD_WIDTH;
+		break;
+	case DMA_SLAVE_BUSWIDTH_8_BYTES:
+		addr_width = STEDMA40_DOUBLEWORD_WIDTH;
+		break;
+	default:
+		dev_err(d40c->base->dev,
+			"illegal peripheral address width "
+			"requested (%d)\n",
+			config->src_addr_width);
+		return;
+	}
+
+	if (config_maxburst >= 16)
+		psize = STEDMA40_PSIZE_LOG_16;
+	else if (config_maxburst >= 8)
+		psize = STEDMA40_PSIZE_LOG_8;
+	else if (config_maxburst >= 4)
+		psize = STEDMA40_PSIZE_LOG_4;
+	else
+		psize = STEDMA40_PSIZE_LOG_1;
+
+	/* Set up all the endpoint configs */
+	cfg->src_info.data_width = addr_width;
+	cfg->src_info.psize = psize;
+	cfg->src_info.endianess = STEDMA40_LITTLE_ENDIAN;
+	cfg->src_info.flow_ctrl = STEDMA40_NO_FLOW_CTRL;
+	cfg->dst_info.data_width = addr_width;
+	cfg->dst_info.psize = psize;
+	cfg->dst_info.endianess = STEDMA40_LITTLE_ENDIAN;
+	cfg->dst_info.flow_ctrl = STEDMA40_NO_FLOW_CTRL;
+
+	/* These settings will take precedence later */
+	d40c->runtime_addr = config_addr;
+	d40c->runtime_direction = config->direction;
+	dev_dbg(d40c->base->dev,
+		"configured channel %s for %s, data width %d, "
+		"maxburst %d bytes, LE, no flow control\n",
+		dma_chan_name(chan),
+		(config->direction == DMA_FROM_DEVICE) ? "RX" : "TX",
+		config_addr_width,
+		config_maxburst);
+}
+
 static int d40_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
 		       unsigned long arg)
 {
@@ -2081,6 +2207,12 @@ static int d40_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
 		return d40_pause(chan);
 	case DMA_RESUME:
 		return d40_resume(chan);
+	case DMA_SLAVE_CONFIG:
+		d40_set_runtime_config(chan,
+			(struct dma_slave_config *) arg);
+		return 0;
+	default:
+		break;
 	}
 
 	/* Other commands are unimplemented */
-- 
1.7.1.1

