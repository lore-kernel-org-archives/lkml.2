Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932603Ab0HDMKg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 08:10:36 -0400
Received: from eu1sys200aog110.obsmtp.com ([207.126.144.129]:43880 "EHLO
	eu1sys200aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755789Ab0HDMKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 08:10:34 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH 2/3] DMAENGINE: add runtime slave config to DMA40 v3
Date: Wed, 4 Aug 2010 13:37:45 +0200
Message-ID: <1280921865-31225-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.6.3.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This extends the DMA engine driver for the DMA40 used in the
U8500 platform with the generic runtime slave configuration
interface.

Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
Changes v2->v3:
- Fixed some rebase problem agains the async_tx tree.
---
 drivers/dma/ste_dma40.c |  141 +++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 137 insertions(+), 4 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 21a7597..17e2600 100644
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
@@ -1886,9 +1889,16 @@ static int d40_prep_slave_sg_log(struct d40_desc *d40d,
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
+
 	else
 		return -EINVAL;
 
@@ -1931,9 +1941,15 @@ static int d40_prep_slave_sg_phy(struct d40_desc *d40d,
 
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
@@ -2070,6 +2086,117 @@ static void d40_issue_pending(struct dma_chan *chan)
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
@@ -2092,6 +2219,12 @@ static int d40_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
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
1.6.3.3

