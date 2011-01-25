Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753527Ab1AYKXv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 05:23:51 -0500
Received: from eu1sys200aog105.obsmtp.com ([207.126.144.119]:49130 "EHLO
	eu1sys200aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753215Ab1AYKTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 05:19:34 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: <linux-kernel@vger.kernel.org>, Lee Jones <lee.jones@linaro.org>,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH 16/32] dma40: combine duplicated d40_pool_lli_alloc() calls
Date: Tue, 25 Jan 2011 11:18:19 +0100
Message-ID: <1295950715-22340-17-git-send-email-linus.walleij@stericsson.com>
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
 drivers/dma/ste_dma40.c |   38 ++++++++++++++------------------------
 1 files changed, 14 insertions(+), 24 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 5259a98..495f9eb 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -332,8 +332,9 @@ static void __iomem *chan_base(struct d40_chan *chan)
 	d40_err(chan2dev(d40c), format, ## arg)
 
 static int d40_pool_lli_alloc(struct d40_chan *d40c, struct d40_desc *d40d,
-			      int lli_len, bool is_log)
+			      int lli_len)
 {
+	bool is_log = chan_is_logical(d40c);
 	u32 align;
 	void *base;
 
@@ -1623,6 +1624,7 @@ d40_prep_desc(struct d40_chan *chan, struct scatterlist *sg,
 {
 	struct stedma40_chan_cfg *cfg = &chan->dma_cfg;
 	struct d40_desc *desc;
+	int ret;
 
 	desc = d40_desc_get(chan);
 	if (!desc)
@@ -1632,11 +1634,16 @@ d40_prep_desc(struct d40_chan *chan, struct scatterlist *sg,
 					cfg->dst_info.data_width);
 	if (desc->lli_len < 0) {
 		chan_err(chan, "Unaligned size\n");
-		d40_desc_free(chan, desc);
+		goto err;
+	}
 
-		return NULL;
+	ret = d40_pool_lli_alloc(chan, desc, desc->lli_len);
+	if (ret < 0) {
+		chan_err(chan, "Could not allocate lli\n");
+		goto err;
 	}
 
+
 	desc->lli_current = 0;
 	desc->txd.flags = dma_flags;
 	desc->txd.tx_submit = d40_tx_submit;
@@ -1644,6 +1651,10 @@ d40_prep_desc(struct d40_chan *chan, struct scatterlist *sg,
 	dma_async_tx_descriptor_init(&desc->txd, &chan->chan);
 
 	return desc;
+
+err:
+	d40_desc_free(chan, desc);
+	return NULL;
 }
 
 struct dma_async_tx_descriptor *stedma40_memcpy_sg(struct dma_chan *chan,
@@ -1670,12 +1681,6 @@ struct dma_async_tx_descriptor *stedma40_memcpy_sg(struct dma_chan *chan,
 		goto err;
 
 	if (chan_is_logical(d40c)) {
-
-		if (d40_pool_lli_alloc(d40c, d40d, d40d->lli_len, true) < 0) {
-			chan_err(d40c, "Out of memory\n");
-			goto err;
-		}
-
 		(void) d40_log_sg_to_lli(sgl_src,
 					 sgl_len,
 					 d40d->lli_log.src,
@@ -1690,11 +1695,6 @@ struct dma_async_tx_descriptor *stedma40_memcpy_sg(struct dma_chan *chan,
 					 d40c->dma_cfg.dst_info.data_width,
 					 d40c->dma_cfg.src_info.data_width);
 	} else {
-		if (d40_pool_lli_alloc(d40c, d40d, d40d->lli_len, false) < 0) {
-			chan_err(d40c, "Out of memory\n");
-			goto err;
-		}
-
 		res = d40_phy_sg_to_lli(sgl_src,
 					sgl_len,
 					0,
@@ -1914,11 +1914,6 @@ static int d40_prep_slave_sg_log(struct d40_desc *d40d,
 	dma_addr_t dev_addr = 0;
 	int total_size;
 
-	if (d40_pool_lli_alloc(d40c, d40d, d40d->lli_len, true) < 0) {
-		chan_err(d40c, "Out of memory\n");
-		return -ENOMEM;
-	}
-
 	if (direction == DMA_FROM_DEVICE)
 		if (d40c->runtime_addr)
 			dev_addr = d40c->runtime_addr;
@@ -1958,11 +1953,6 @@ static int d40_prep_slave_sg_phy(struct d40_desc *d40d,
 	dma_addr_t dst_dev_addr;
 	int res;
 
-	if (d40_pool_lli_alloc(d40c, d40d, d40d->lli_len, false) < 0) {
-		chan_err(d40c, "Out of memory\n");
-		return -ENOMEM;
-	}
-
 	if (direction == DMA_FROM_DEVICE) {
 		dst_dev_addr = 0;
 		if (d40c->runtime_addr)
-- 
1.7.3.2

