Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756841Ab0FKP1G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 11:27:06 -0400
Received: from eu1sys200aog109.obsmtp.com ([207.126.144.127]:57552 "EHLO
	eu1sys200aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756533Ab0FKP1C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 11:27:02 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Dan Williams <dan.j.williams@intel.com>,
       <linux-arm-kernel@lists.infradead.org>, <yuanyabin1978@sina.com>
Cc: <linux-kernel@vger.kernel.org>,
       Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH 03/13] DMAENGINE: add generic PrimeCell interface to DMA40 v2
Date: Fri, 11 Jun 2010 17:26:46 +0200
Message-ID: <1276270006-1431-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.6.3.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This extends the DMA engine driver for the DMA40 used in the
U8500 platform with the generic PrimeCell interface.

Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
 drivers/dma/ste_dma40.c |  125 +++++++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 121 insertions(+), 4 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index c426829..c1b278f 100644
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
@@ -1890,7 +1894,10 @@ static int d40_prep_slave_sg_log(struct d40_desc *d40d,
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
@@ -1902,7 +1909,10 @@ static int d40_prep_slave_sg_log(struct d40_desc *d40d,
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
@@ -1943,9 +1953,15 @@ static int d40_prep_slave_sg_phy(struct d40_desc *d40d,
 
 	if (direction == DMA_FROM_DEVICE) {
 		dst_dev_addr = 0;
-		src_dev_addr = d40c->base->plat_data->dev_rx[d40c->dma_cfg.src_dev_type];
+		if (d40c->amba_addr)
+			src_dev_addr = d40c->amba_addr;
+		else
+			src_dev_addr = d40c->base->plat_data->dev_rx[d40c->dma_cfg.src_dev_type];
 	} else if (direction == DMA_TO_DEVICE) {
-		dst_dev_addr = d40c->base->plat_data->dev_tx[d40c->dma_cfg.dst_dev_type];
+		if (d40c->amba_addr)
+			dst_dev_addr = d40c->amba_addr;
+		else
+			dst_dev_addr = d40c->base->plat_data->dev_tx[d40c->dma_cfg.dst_dev_type];
 		src_dev_addr = 0;
 	} else
 		return -EINVAL;
@@ -2065,6 +2081,103 @@ static void d40_issue_pending(struct dma_chan *chan)
 	spin_unlock_irqrestore(&d40c->lock, flags);
 }
 
+/* PrimeCell DMA extension */
+static void d40_set_ambaconfig(struct dma_chan *chan,
+			       struct amba_dma_channel_config *config)
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
 static int d40_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
 		       unsigned long arg)
 {
@@ -2081,6 +2194,10 @@ static int d40_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
 		return d40_pause(chan);
 	case DMA_RESUME:
 		return d40_resume(chan);
+	case DMA_CONFIG_AMBA:
+		d40_set_ambaconfig(chan,
+			(struct amba_dma_channel_config *) arg);
+		return 0;
 	}
 
 	/* Other commands are unimplemented */
-- 
1.6.3.3

