Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753620Ab0F2AQO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 20:16:14 -0400
Received: from mail.df.lth.se ([194.47.250.12]:63469 "EHLO df.lth.se"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753144Ab0F2AQL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 20:16:11 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH 3/3] DMAENGINE: add runtime slave config to DMA40
Date: Tue, 29 Jun 2010 02:16:59 +0200
Message-Id: <1277770619-11549-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.6.2.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This extends the DMA engine driver for the DMA40 used in the
U8500 platform with the generic runtime slave configuration
interface.

Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
This applies on top of the earlier bugfixes for DMA40.
---
 drivers/dma/ste_dma40.c |  126 +++++++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 122 insertions(+), 4 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 21a7597..3bba98f 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -208,6 +208,9 @@ struct d40_chan {
 	struct d40_def_lcsp		 log_def;
 	struct d40_lcla_elem		 lcla;
 	struct d40_log_lli_full		*lcpa;
+	/* Runtime reconfiguration */
+	dma_addr_t			runtime_addr;
+	enum dma_data_direction		runtime_direction;
 };
 
 /**
@@ -1886,9 +1889,15 @@ static int d40_prep_slave_sg_log(struct d40_desc *d40d,
 			d40d->lli_tx_len = 1;
 
 	if (direction == DMA_FROM_DEVICE)
-		dev_addr = d40c->base->plat_data->dev_rx[d40c->dma_cfg.src_dev_type];
+		if (d40c->runtime_addr)
+			dev_addr = d40c->runtime_addr;
+		else
+			dev_addr = d40c->base->plat_data->dev_rx[d40c->dma_cfg.src_dev_type];
 	else if (direction == DMA_TO_DEVICE)
-		dev_addr = d40c->base->plat_data->dev_tx[d40c->dma_cfg.dst_dev_type];
+		if (d40c->runtime_addr)
+			dev_addr = d40c->runtime_addr;
+		else
+			dev_addr = d40c->base->plat_data->dev_tx[d40c->dma_cfg.dst_dev_type];
 	else
 		return -EINVAL;
 
@@ -1931,9 +1940,15 @@ static int d40_prep_slave_sg_phy(struct d40_desc *d40d,
 
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
@@ -2070,6 +2085,103 @@ static void d40_issue_pending(struct dma_chan *chan)
 	spin_unlock_irqrestore(&d40c->lock, flags);
 }
 
+/* Runtime reconfiguration extension */
+static void d40_set_runtime_config(struct dma_chan *chan,
+			       struct dma_slave_config *config)
+{
+	struct d40_chan *d40c = container_of(chan, struct d40_chan, chan);
+	struct stedma40_chan_cfg *cfg = &d40c->dma_cfg;
+	enum stedma40_periph_data_width addr_width;
+	int psize;
+
+	switch (config->addr_width) {
+	case 1:
+		addr_width = STEDMA40_BYTE_WIDTH;
+		break;
+	case 2:
+		addr_width = STEDMA40_HALFWORD_WIDTH;
+		break;
+	case 4:
+		addr_width = STEDMA40_WORD_WIDTH;
+		break;
+	case 8:
+		addr_width = STEDMA40_DOUBLEWORD_WIDTH;
+		break;
+	default:
+		dev_err(d40c->base->dev,
+			"illegal peripheral address width requested (%d)\n",
+			config->addr_width);
+		return;
+	}
+
+	if (config->maxburst >= 16)
+		psize = STEDMA40_PSIZE_LOG_16;
+	else if (config->maxburst >= 8)
+		psize = STEDMA40_PSIZE_LOG_8;
+	else if (config->maxburst >= 4)
+		psize = STEDMA40_PSIZE_LOG_4;
+	else
+		psize = STEDMA40_PSIZE_LOG_1;
+
+	if (config->direction == DMA_FROM_DEVICE) {
+		dma_addr_t dev_addr_rx =
+			d40c->base->plat_data->dev_rx[cfg->src_dev_type];
+
+		if (dev_addr_rx)
+			dev_dbg(d40c->base->dev,
+				"channel has a pre-wired RX address %08x "
+				"overriding with %08x\n",
+				dev_addr_rx, config->addr);
+		if (cfg->dir != STEDMA40_PERIPH_TO_MEM)
+			dev_dbg(d40c->base->dev,
+				"channel was not configured for peripheral "
+				"to memory transfer (%d) overriding\n",
+				cfg->dir);
+		cfg->dir = STEDMA40_PERIPH_TO_MEM;
+	} else if (config->direction == DMA_TO_DEVICE) {
+		dma_addr_t dev_addr_tx =
+			d40c->base->plat_data->dev_tx[cfg->dst_dev_type];
+
+		if (dev_addr_tx)
+			dev_dbg(d40c->base->dev,
+				"channel has a pre-wired TX address %08x "
+				"overriding with %08x\n",
+				dev_addr_tx, config->addr);
+		if (cfg->dir != STEDMA40_MEM_TO_PERIPH)
+			dev_dbg(d40c->base->dev,
+				"channel was not configured for memory "
+				"to peripheral transfer (%d) overriding\n",
+				cfg->dir);
+		cfg->dir = STEDMA40_MEM_TO_PERIPH;
+	} else {
+		dev_err(d40c->base->dev,
+			"unrecognized channel direction %d\n",
+			config->direction);
+		return;
+	}
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
+	d40c->runtime_addr = config->addr;
+	d40c->runtime_direction = config->direction;
+	dev_dbg(d40c->base->dev,
+		"configured channel %s for %s, data width %d, "
+		"maxburst %d bytes, LE, no flow control\n",
+		dma_chan_name(chan),
+		(config->direction == DMA_FROM_DEVICE) ? "RX" : "TX",
+		config->addr_width,
+		config->maxburst);
+}
+
 static int d40_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
 		       unsigned long arg)
 {
@@ -2092,6 +2204,12 @@ static int d40_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
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
1.7.0.1

