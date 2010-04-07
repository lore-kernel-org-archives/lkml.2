Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757707Ab0DGXNr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 19:13:47 -0400
Received: from mail.df.lth.se ([194.47.250.12]:65478 "EHLO df.lth.se"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756144Ab0DGXNn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 19:13:43 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: akpm@linux-foundation.org,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Grant Likely <grant.likely@secretlab.ca>,
       Dan Williams <dan.j.williams@intel.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-mmc@vger.kernel.org,
       STEricsson_nomadik_linux@list.st.com, linux-kernel@vger.kernel.org,
       Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH 06/11] ARM: add generic PrimeCell interface to DMA40 v1
Date: Thu,  8 Apr 2010 01:13:05 +0200
Message-Id: <1270681985-6022-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.6.2.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This extends the DMA engine driver for the DMA40 used in the
U8500 platform with the generic PrimeCell interface,

Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
This is new in this patch set and applies on top of the
driver queued in Andrew Mortons tree.
---
 drivers/dma/ste_dma40.c |  128 +++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 125 insertions(+), 3 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index e4295a2..f86b99f 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -14,6 +14,7 @@
 #include <linux/platform_device.h>
 #include <linux/clk.h>
 #include <linux/delay.h>
+#include <linux/amba/dma.h>
 
 #include <plat/ste_dma40.h>
 
@@ -205,6 +206,9 @@ struct d40_chan {
 	struct d40_def_lcsp		 log_def;
 	struct d40_lcla_elem		 lcla;
 	struct d40_log_lli_full		*lcpa;
+	/* AMBA extensions */
+	dma_addr_t			amba_addr;
+	enum dma_data_direction		amba_direction;
 };
 
 /**
@@ -1830,7 +1834,10 @@ static int d40_prep_slave_sg_log(struct d40_desc *d40d,
 			lli_max = 1;
 
 	if (direction == DMA_FROM_DEVICE) {
-		dev_addr = d40c->base->plat_data->dev_rx[d40c->dma_cfg.src_dev_type];
+		if (d40c->amba_addr)
+			dev_addr = d40c->amba_addr;
+		else
+			dev_addr = d40c->base->plat_data->dev_rx[d40c->dma_cfg.src_dev_type];
 		total_size = d40_log_sg_to_dev(&d40c->lcla,
 					       sgl, sg_len,
 					       &d40d->lli_log,
@@ -1842,7 +1849,10 @@ static int d40_prep_slave_sg_log(struct d40_desc *d40d,
 					       dev_addr, lli_max,
 					       d40c->base->plat_data->llis_per_log);
 	} else if (direction == DMA_TO_DEVICE) {
-		dev_addr = d40c->base->plat_data->dev_tx[d40c->dma_cfg.dst_dev_type];
+		if (d40c->amba_addr)
+			dev_addr = d40c->amba_addr;
+		else
+			dev_addr = d40c->base->plat_data->dev_tx[d40c->dma_cfg.dst_dev_type];
 		total_size = d40_log_sg_to_dev(&d40c->lcla,
 					       sgl, sg_len,
 					       &d40d->lli_log,
@@ -1973,14 +1983,29 @@ static enum dma_status d40_tx_status(struct dma_chan *chan,
 				     struct dma_tx_state *txstate)
 {
 	struct d40_chan *d40c = container_of(chan, struct d40_chan, chan);
+	void __iomem *active_reg;
 	dma_cookie_t last_used;
 	dma_cookie_t last_complete;
+	u32 status;
 	int ret;
 
 	last_complete = d40c->completed;
 	last_used = chan->cookie;
 
-	ret = dma_async_is_complete(cookie, last_complete, last_used);
+	/* check for pause first */
+	if (d40c->phy_chan->num % 2 == 0)
+		active_reg = d40c->base->virtbase + D40_DREG_ACTIVE;
+	else
+		active_reg = d40c->base->virtbase + D40_DREG_ACTIVO;
+
+	status = (readl(active_reg) &
+		  D40_CHAN_POS_MASK(d40c->phy_chan->num)) >>
+		D40_CHAN_POS(d40c->phy_chan->num);
+
+	if (status == D40_DMA_SUSPENDED)
+		ret = DMA_PAUSED;
+	else
+		ret = dma_async_is_complete(cookie, last_complete, last_used);
 
 	if (txstate) {
 		txstate->last = last_complete;
@@ -2026,6 +2051,103 @@ static int d40_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd)
 	return -ENXIO;
 }
 
+/* PrimeCell DMA extension */
+void dma_set_ambaconfig(struct dma_chan *chan,
+			struct amba_dma_channel_config *config)
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
+			dev_warn(d40c->base->dev,
+				 "channel has a pre-wired RX address %08x "
+				 "overriding with %08x\n",
+				 dev_addr_rx, config->addr);
+		if (cfg->dir != STEDMA40_PERIPH_TO_MEM)
+			dev_warn(d40c->base->dev,
+				 "channel was not configured for peripheral "
+				 "to memory transfer (%d) overriding\n",
+				 cfg->dir);
+		cfg->dir = STEDMA40_PERIPH_TO_MEM;
+	} else if (config->direction == DMA_TO_DEVICE) {
+		dma_addr_t dev_addr_tx =
+			d40c->base->plat_data->dev_tx[cfg->dst_dev_type];
+
+		if (dev_addr_tx)
+			dev_warn(d40c->base->dev,
+				 "channel has a pre-wired TX address %08x "
+				 "overriding with %08x\n",
+				 dev_addr_tx, config->addr);
+		if (cfg->dir != STEDMA40_MEM_TO_PERIPH)
+			dev_warn(d40c->base->dev,
+				 "channel was not configured for memory "
+				 "to peripheral transfer (%d) overriding\n",
+				 cfg->dir);
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
+	d40c->amba_addr = config->addr;
+	d40c->amba_direction = config->direction;
+	dev_dbg(d40c->base->dev,
+		"configured channel %s for %s, data width %d, "
+		"maxburst %d bytes, LE, no flow control\n",
+		dma_chan_name(chan),
+		(config->direction == DMA_FROM_DEVICE) ? "RX" : "TX",
+		config->addr_width,
+		config->maxburst);
+}
+
 /* Initialization functions */
 
 static void __init d40_chan_init(struct d40_base *base, struct dma_device *dma,
-- 
1.6.3.3

