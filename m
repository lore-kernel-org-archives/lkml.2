Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756743Ab1F1KPk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 06:15:40 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:44460 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756392Ab1F1KLD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 06:11:03 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: vinod.koul@intel.com, dan.j.williams@intel.com,
        linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Nicolas Ferre <nicolas.ferre@atmel.com>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
Subject: [PATCH 3/3] dmaengine: at_hdmac: add slave config operation
Date: Tue, 28 Jun 2011 13:17:57 +0200
Message-Id: <1151852b20789636633095406a180335364f4afb.1309259835.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.3
In-Reply-To: <fb4657207f9eb34784c10333e11c48b5638542ed.1309259835.git.nicolas.ferre@atmel.com>
References: <fb4657207f9eb34784c10333e11c48b5638542ed.1309259835.git.nicolas.ferre@atmel.com>
In-Reply-To: <fb4657207f9eb34784c10333e11c48b5638542ed.1309259835.git.nicolas.ferre@atmel.com>
References: <fb4657207f9eb34784c10333e11c48b5638542ed.1309259835.git.nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Only change source/destination peripheral register access width.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/dma/at_hdmac.c |   29 +++++++++++++++++++++++++++++
 1 files changed, 29 insertions(+), 0 deletions(-)

diff --git a/drivers/dma/at_hdmac.c b/drivers/dma/at_hdmac.c
index 7096adb..9cb8044 100644
--- a/drivers/dma/at_hdmac.c
+++ b/drivers/dma/at_hdmac.c
@@ -954,6 +954,35 @@ static int atc_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
 		clear_bit(ATC_IS_PAUSED, &atchan->status);
 
 		spin_unlock_irqrestore(&atchan->lock, flags);
+	} else if (cmd == DMA_SLAVE_CONFIG) {
+		struct dma_slave_config *dmaengine_cfg = (void *)arg;
+		struct at_dma_slave	*atslave = chan->private;
+		enum dma_slave_buswidth sdma_width;
+		enum at_dma_slave_width	atdma_width;
+
+		/* only modify transfer size width */
+		if (!atslave)
+			return -ENXIO;
+
+		if (dmaengine_cfg->direction == DMA_FROM_DEVICE)
+			sdma_width = dmaengine_cfg->src_addr_width;
+		else
+			sdma_width = dmaengine_cfg->dst_addr_width;
+
+		switch (sdma_width) {
+		case DMA_SLAVE_BUSWIDTH_1_BYTE:
+			atdma_width = AT_DMA_SLAVE_WIDTH_8BIT;
+			break;
+		case DMA_SLAVE_BUSWIDTH_2_BYTES:
+			atdma_width = AT_DMA_SLAVE_WIDTH_16BIT;
+			break;
+		case DMA_SLAVE_BUSWIDTH_4_BYTES:
+			atdma_width = AT_DMA_SLAVE_WIDTH_32BIT;
+			break;
+		default:
+			return -EINVAL;
+		}
+		atslave->reg_width = atdma_width;
 	} else if (cmd == DMA_TERMINATE_ALL) {
 		struct at_desc	*desc, *_desc;
 		/*
-- 
1.7.3

