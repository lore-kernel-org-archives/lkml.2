Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756274Ab1F0Jf6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 05:35:58 -0400
Received: from eu1sys200aog107.obsmtp.com ([207.126.144.123]:57046 "EHLO
	eu1sys200aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757482Ab1F0Jdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 05:33:54 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Vinod Koul <vinod.koul@intel.com>
Cc: <linux-kernel@vger.kernel.org>, Dan Williams <dan.j.williams@intel.com>,
        Lee Jones <lee.jones@linaro.org>,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        Robert Marklund <robert.marklund@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 3/4] dmaengine/ste_dma40: allow memory buswidth/burst to be configured
Date: Mon, 27 Jun 2011 11:33:38 +0200
Message-ID: <1309167218-23409-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rabin Vincent <rabin.vincent@stericsson.com>

Currently the runtime config implementation forces the memory side
parameters to be the same as the peripheral side. Allow these to be
different, and check for misconfiguration.

Signed-off-by: Rabin Vincent <rabin.vincent@stericsson.com>
Reviewed-by: Ulf HANSSON <ulf.hansson@stericsson.com>
Tested-by: Stefan Nilsson <stefan.xk.nilsson@stericsson.com>
Reviewed-by: Per Forlin <per.forlin@stericsson.com>
Reviewed-by: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
Cc: Robert Marklund <robert.marklund@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/dma/ste_dma40.c |  168 ++++++++++++++++++++++++++++------------------
 1 files changed, 102 insertions(+), 66 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 35b078d..096167f 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -2181,17 +2181,78 @@ static void d40_issue_pending(struct dma_chan *chan)
 	spin_unlock_irqrestore(&d40c->lock, flags);
 }
 
+static int
+dma40_config_to_halfchannel(struct d40_chan *d40c,
+			    struct stedma40_half_channel_info *info,
+			    enum dma_slave_buswidth width,
+			    u32 maxburst)
+{
+	enum stedma40_periph_data_width addr_width;
+	int psize;
+
+	switch (width) {
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
+			width);
+		return -EINVAL;
+	}
+
+	if (chan_is_logical(d40c)) {
+		if (maxburst >= 16)
+			psize = STEDMA40_PSIZE_LOG_16;
+		else if (maxburst >= 8)
+			psize = STEDMA40_PSIZE_LOG_8;
+		else if (maxburst >= 4)
+			psize = STEDMA40_PSIZE_LOG_4;
+		else
+			psize = STEDMA40_PSIZE_LOG_1;
+	} else {
+		if (maxburst >= 16)
+			psize = STEDMA40_PSIZE_PHY_16;
+		else if (maxburst >= 8)
+			psize = STEDMA40_PSIZE_PHY_8;
+		else if (maxburst >= 4)
+			psize = STEDMA40_PSIZE_PHY_4;
+		else
+			psize = STEDMA40_PSIZE_PHY_1;
+	}
+
+	info->data_width = addr_width;
+	info->psize = psize;
+	info->flow_ctrl = STEDMA40_NO_FLOW_CTRL;
+
+	return 0;
+}
+
 /* Runtime reconfiguration extension */
-static void d40_set_runtime_config(struct dma_chan *chan,
-			       struct dma_slave_config *config)
+static int d40_set_runtime_config(struct dma_chan *chan,
+				  struct dma_slave_config *config)
 {
 	struct d40_chan *d40c = container_of(chan, struct d40_chan, chan);
 	struct stedma40_chan_cfg *cfg = &d40c->dma_cfg;
-	enum dma_slave_buswidth config_addr_width;
+	enum dma_slave_buswidth src_addr_width, dst_addr_width;
 	dma_addr_t config_addr;
-	u32 config_maxburst;
-	enum stedma40_periph_data_width addr_width;
-	int psize;
+	u32 src_maxburst, dst_maxburst;
+	int ret;
+
+	src_addr_width = config->src_addr_width;
+	src_maxburst = config->src_maxburst;
+	dst_addr_width = config->dst_addr_width;
+	dst_maxburst = config->dst_maxburst;
 
 	if (config->direction == DMA_FROM_DEVICE) {
 		dma_addr_t dev_addr_rx =
@@ -2210,8 +2271,11 @@ static void d40_set_runtime_config(struct dma_chan *chan,
 				cfg->dir);
 		cfg->dir = STEDMA40_PERIPH_TO_MEM;
 
-		config_addr_width = config->src_addr_width;
-		config_maxburst = config->src_maxburst;
+		/* Configure the memory side */
+		if (dst_addr_width == DMA_SLAVE_BUSWIDTH_UNDEFINED)
+			dst_addr_width = src_addr_width;
+		if (dst_maxburst == 0)
+			dst_maxburst = src_maxburst;
 
 	} else if (config->direction == DMA_TO_DEVICE) {
 		dma_addr_t dev_addr_tx =
@@ -2230,68 +2294,39 @@ static void d40_set_runtime_config(struct dma_chan *chan,
 				cfg->dir);
 		cfg->dir = STEDMA40_MEM_TO_PERIPH;
 
-		config_addr_width = config->dst_addr_width;
-		config_maxburst = config->dst_maxburst;
-
+		/* Configure the memory side */
+		if (src_addr_width == DMA_SLAVE_BUSWIDTH_UNDEFINED)
+			src_addr_width = dst_addr_width;
+		if (src_maxburst == 0)
+			src_maxburst = dst_maxburst;
 	} else {
 		dev_err(d40c->base->dev,
 			"unrecognized channel direction %d\n",
 			config->direction);
-		return;
+		return -EINVAL;
 	}
 
-	switch (config_addr_width) {
-	case DMA_SLAVE_BUSWIDTH_1_BYTE:
-		addr_width = STEDMA40_BYTE_WIDTH;
-		break;
-	case DMA_SLAVE_BUSWIDTH_2_BYTES:
-		addr_width = STEDMA40_HALFWORD_WIDTH;
-		break;
-	case DMA_SLAVE_BUSWIDTH_4_BYTES:
-		addr_width = STEDMA40_WORD_WIDTH;
-		break;
-	case DMA_SLAVE_BUSWIDTH_8_BYTES:
-		addr_width = STEDMA40_DOUBLEWORD_WIDTH;
-		break;
-	default:
+	if (src_maxburst * src_addr_width != dst_maxburst * dst_addr_width) {
 		dev_err(d40c->base->dev,
-			"illegal peripheral address width "
-			"requested (%d)\n",
-			config->src_addr_width);
-		return;
+			"src/dst width/maxburst mismatch: %d*%d != %d*%d\n",
+			src_maxburst,
+			src_addr_width,
+			dst_maxburst,
+			dst_addr_width);
+		return -EINVAL;
 	}
 
-	if (chan_is_logical(d40c)) {
-		if (config_maxburst >= 16)
-			psize = STEDMA40_PSIZE_LOG_16;
-		else if (config_maxburst >= 8)
-			psize = STEDMA40_PSIZE_LOG_8;
-		else if (config_maxburst >= 4)
-			psize = STEDMA40_PSIZE_LOG_4;
-		else
-			psize = STEDMA40_PSIZE_LOG_1;
-	} else {
-		if (config_maxburst >= 16)
-			psize = STEDMA40_PSIZE_PHY_16;
-		else if (config_maxburst >= 8)
-			psize = STEDMA40_PSIZE_PHY_8;
-		else if (config_maxburst >= 4)
-			psize = STEDMA40_PSIZE_PHY_4;
-		else if (config_maxburst >= 2)
-			psize = STEDMA40_PSIZE_PHY_2;
-		else
-			psize = STEDMA40_PSIZE_PHY_1;
-	}
+	ret = dma40_config_to_halfchannel(d40c, &cfg->src_info,
+					  src_addr_width,
+					  src_maxburst);
+	if (ret)
+		return ret;
 
-	/* Set up all the endpoint configs */
-	cfg->src_info.data_width = addr_width;
-	cfg->src_info.psize = psize;
-	cfg->src_info.big_endian = false;
-	cfg->src_info.flow_ctrl = STEDMA40_NO_FLOW_CTRL;
-	cfg->dst_info.data_width = addr_width;
-	cfg->dst_info.psize = psize;
-	cfg->dst_info.big_endian = false;
-	cfg->dst_info.flow_ctrl = STEDMA40_NO_FLOW_CTRL;
+	ret = dma40_config_to_halfchannel(d40c, &cfg->dst_info,
+					  dst_addr_width,
+					  dst_maxburst);
+	if (ret)
+		return ret;
 
 	/* Fill in register values */
 	if (chan_is_logical(d40c))
@@ -2304,12 +2339,14 @@ static void d40_set_runtime_config(struct dma_chan *chan,
 	d40c->runtime_addr = config_addr;
 	d40c->runtime_direction = config->direction;
 	dev_dbg(d40c->base->dev,
-		"configured channel %s for %s, data width %d, "
-		"maxburst %d bytes, LE, no flow control\n",
+		"configured channel %s for %s, data width %d/%d, "
+		"maxburst %d/%d elements, LE, no flow control\n",
 		dma_chan_name(chan),
 		(config->direction == DMA_FROM_DEVICE) ? "RX" : "TX",
-		config_addr_width,
-		config_maxburst);
+		src_addr_width, dst_addr_width,
+		src_maxburst, dst_maxburst);
+
+	return 0;
 }
 
 static int d40_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
@@ -2330,9 +2367,8 @@ static int d40_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
 	case DMA_RESUME:
 		return d40_resume(d40c);
 	case DMA_SLAVE_CONFIG:
-		d40_set_runtime_config(chan,
+		return d40_set_runtime_config(chan,
 			(struct dma_slave_config *) arg);
-		return 0;
 	default:
 		break;
 	}
-- 
1.7.3.2

