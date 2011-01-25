Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753474Ab1AYKTu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 05:19:50 -0500
Received: from eu1sys200aog103.obsmtp.com ([207.126.144.115]:44988 "EHLO
	eu1sys200aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753435Ab1AYKTr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 05:19:47 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: <linux-kernel@vger.kernel.org>, Lee Jones <lee.jones@linaro.org>,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH 25/32] dma40: unify src/dst addr check
Date: Tue, 25 Jan 2011 11:18:28 +0100
Message-ID: <1295950715-22340-26-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1295950715-22340-1-git-send-email-linus.walleij@stericsson.com>
References: <1295950715-22340-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rabin Vincent <rabin.vincent@stericsson.com>

Acked-by: Per Forlin <per.forlin@stericsson.com>
Acked-by: Jonas Aaberg <jonas.aberg@stericsson.com>
Signed-off-by: Rabin Vincent <rabin.vincent@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
 drivers/dma/ste_dma40.c |   29 ++++++++++++++++-------------
 1 files changed, 16 insertions(+), 13 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 3c61c58..d9dfda2 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -1635,11 +1635,9 @@ static u32 stedma40_residue(struct dma_chan *chan)
 static int
 d40_prep_sg_log(struct d40_chan *chan, struct d40_desc *desc,
 		struct scatterlist *sg_src, struct scatterlist *sg_dst,
-		unsigned int sg_len, enum dma_data_direction direction,
-		dma_addr_t dev_addr)
+		unsigned int sg_len, dma_addr_t src_dev_addr,
+		dma_addr_t dst_dev_addr)
 {
-	dma_addr_t src_dev_addr = direction == DMA_FROM_DEVICE ? dev_addr : 0;
-	dma_addr_t dst_dev_addr = direction == DMA_TO_DEVICE ? dev_addr : 0;
 	struct stedma40_chan_cfg *cfg = &chan->dma_cfg;
 	struct stedma40_half_channel_info *src_info = &cfg->src_info;
 	struct stedma40_half_channel_info *dst_info = &cfg->dst_info;
@@ -1665,11 +1663,9 @@ d40_prep_sg_log(struct d40_chan *chan, struct d40_desc *desc,
 static int
 d40_prep_sg_phy(struct d40_chan *chan, struct d40_desc *desc,
 		struct scatterlist *sg_src, struct scatterlist *sg_dst,
-		unsigned int sg_len, enum dma_data_direction direction,
-		dma_addr_t dev_addr)
+		unsigned int sg_len, dma_addr_t src_dev_addr,
+		dma_addr_t dst_dev_addr)
 {
-	dma_addr_t src_dev_addr = direction == DMA_FROM_DEVICE ? dev_addr : 0;
-	dma_addr_t dst_dev_addr = direction == DMA_TO_DEVICE ? dev_addr : 0;
 	struct stedma40_chan_cfg *cfg = &chan->dma_cfg;
 	struct stedma40_half_channel_info *src_info = &cfg->src_info;
 	struct stedma40_half_channel_info *dst_info = &cfg->dst_info;
@@ -1757,7 +1753,8 @@ d40_prep_sg(struct dma_chan *dchan, struct scatterlist *sg_src,
 	    enum dma_data_direction direction, unsigned long dma_flags)
 {
 	struct d40_chan *chan = container_of(dchan, struct d40_chan, chan);
-	dma_addr_t dev_addr = 0;
+	dma_addr_t src_dev_addr = 0;
+	dma_addr_t dst_dev_addr = 0;
 	struct d40_desc *desc;
 	unsigned long flags;
 	int ret;
@@ -1773,15 +1770,21 @@ d40_prep_sg(struct dma_chan *dchan, struct scatterlist *sg_src,
 	if (desc == NULL)
 		goto err;
 
-	if (direction != DMA_NONE)
-		dev_addr = d40_get_dev_addr(chan, direction);
+	if (direction != DMA_NONE) {
+		dma_addr_t dev_addr = d40_get_dev_addr(chan, direction);
+
+		if (direction == DMA_FROM_DEVICE)
+			src_dev_addr = dev_addr;
+		else if (direction == DMA_TO_DEVICE)
+			dst_dev_addr = dev_addr;
+	}
 
 	if (chan_is_logical(chan))
 		ret = d40_prep_sg_log(chan, desc, sg_src, sg_dst,
-				      sg_len, direction, dev_addr);
+				      sg_len, src_dev_addr, dst_dev_addr);
 	else
 		ret = d40_prep_sg_phy(chan, desc, sg_src, sg_dst,
-				      sg_len, direction, dev_addr);
+				      sg_len, src_dev_addr, dst_dev_addr);
 
 	if (ret) {
 		chan_err(chan, "Failed to prepare %s sg job: %d\n",
-- 
1.7.3.2

