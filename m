Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756519Ab0FAMVg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 08:21:36 -0400
Received: from eu1sys200aog116.obsmtp.com ([207.126.144.141]:44287 "EHLO
	eu1sys200aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756475Ab0FAMVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 08:21:34 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: <linux-kernel@vger.kernel.org>, Jonas Aaberg <jonas.aberg@stericsson.com>,
       Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH 08/18] DMAENGINE: ste_dma40: lock fix
Date: Tue, 1 Jun 2010 14:21:27 +0200
Message-ID: <1275394887-26445-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.6.3.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonas Aaberg <jonas.aberg@stericsson.com>

Fix up some locking issues found by enabling lock debugging.

Signed-off-by: Jonas Aaberg <jonas.aberg@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
 drivers/dma/ste_dma40.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index aba86bb..c4b0d37 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -441,6 +441,7 @@ static int d40_lcla_id_get(struct d40_chan *d40c,
 		pool->base + d40c->phy_chan->num * 1024;
 	int i;
 	int lli_per_log = d40c->base->plat_data->llis_per_log;
+	unsigned long flags;
 
 	if (d40c->lcla.src_id >= 0 && d40c->lcla.dst_id >= 0)
 		return 0;
@@ -448,7 +449,7 @@ static int d40_lcla_id_get(struct d40_chan *d40c,
 	if (pool->num_blocks > 32)
 		return -EINVAL;
 
-	spin_lock(&pool->lock);
+	spin_lock_irqsave(&pool->lock, flags);
 
 	for (i = 0; i < pool->num_blocks; i++) {
 		if (!(pool->alloc_map[d40c->phy_chan->num] & (0x1 << i))) {
@@ -477,10 +478,10 @@ static int d40_lcla_id_get(struct d40_chan *d40c,
 	d40c->lcla.src = lcla_lidx_base + src_id * lli_per_log + 1;
 
 
-	spin_unlock(&pool->lock);
+	spin_unlock_irqrestore(&pool->lock, flags);
 	return 0;
 err:
-	spin_unlock(&pool->lock);
+	spin_unlock_irqrestore(&pool->lock, flags);
 	return -EINVAL;
 }
 
@@ -488,15 +489,16 @@ static void d40_lcla_id_put(struct d40_chan *d40c,
 			    struct d40_lcla_pool *pool,
 			    int id)
 {
+	unsigned long flags;
 	if (id < 0)
 		return;
 
 	d40c->lcla.src_id = -1;
 	d40c->lcla.dst_id = -1;
 
-	spin_lock(&pool->lock);
+	spin_lock_irqsave(&pool->lock, flags);
 	pool->alloc_map[d40c->phy_chan->num] &= (~(0x1 << id));
-	spin_unlock(&pool->lock);
+	spin_unlock_irqrestore(&pool->lock, flags);
 }
 
 static int d40_channel_execute_command(struct d40_chan *d40c,
@@ -1990,8 +1992,6 @@ static struct dma_async_tx_descriptor *d40_prep_slave_sg(struct dma_chan *chan,
 	if (d40d == NULL)
 		return NULL;
 
-	memset(d40d, 0, sizeof(struct d40_desc));
-
 	if (d40c->log_num != D40_PHY_CHAN)
 		err = d40_prep_slave_sg_log(d40d, d40c, sgl, sg_len,
 					    direction, dma_flags);
-- 
1.6.3.3

