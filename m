Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753406Ab1AYKYf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 05:24:35 -0500
Received: from eu1sys200aog102.obsmtp.com ([207.126.144.113]:52751 "EHLO
	eu1sys200aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753278Ab1AYKTb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 05:19:31 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: <linux-kernel@vger.kernel.org>, Lee Jones <lee.jones@linaro.org>,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH 03/32] dma40: remove "hardware link with previous jobs" code
Date: Tue, 25 Jan 2011 11:18:06 +0100
Message-ID: <1295950715-22340-4-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1295950715-22340-1-git-send-email-linus.walleij@stericsson.com>
References: <1295950715-22340-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rabin Vincent <rabin.vincent@stericsson.com>

This link in hardware with previous jobs code is:

  - unused, no clients using or requiring this feature
  - incomplete, being implemented only for physical channels
  - broken, only working to perform one link

Remove it.  This also allows us to get rid of the channel pause in the
submit_tx() routine.

Acked-by: Per Forlin <per.forlin@stericsson.com>
Acked-by: Jonas Aaberg <jonas.aberg@stericsson.com>
Signed-off-by: Rabin Vincent <rabin.vincent@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
 drivers/dma/ste_dma40.c |  113 +++--------------------------------------------
 1 files changed, 6 insertions(+), 107 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 42c88fc..ed2a3eb 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -94,7 +94,6 @@ struct d40_lli_pool {
  * during a transfer.
  * @node: List entry.
  * @is_in_client_list: true if the client owns this descriptor.
- * @is_hw_linked: true if this job will automatically be continued for
  * the previous one.
  *
  * This descriptor is used for both logical and physical transfers.
@@ -114,7 +113,6 @@ struct d40_desc {
 	struct list_head		 node;
 
 	bool				 is_in_client_list;
-	bool				 is_hw_linked;
 };
 
 /**
@@ -548,18 +546,6 @@ static struct d40_desc *d40_first_queued(struct d40_chan *d40c)
 	return d;
 }
 
-static struct d40_desc *d40_last_queued(struct d40_chan *d40c)
-{
-	struct d40_desc *d;
-
-	if (list_empty(&d40c->queue))
-		return NULL;
-	list_for_each_entry(d, &d40c->queue, node)
-		if (list_is_last(&d->node, &d40c->queue))
-			break;
-	return d;
-}
-
 static int d40_psize_2_burst_size(bool is_log, int psize)
 {
 	if (is_log) {
@@ -940,77 +926,6 @@ no_suspend:
 	return res;
 }
 
-static void d40_tx_submit_log(struct d40_chan *d40c, struct d40_desc *d40d)
-{
-	/* TODO: Write */
-}
-
-static void d40_tx_submit_phy(struct d40_chan *d40c, struct d40_desc *d40d)
-{
-	struct d40_desc *d40d_prev = NULL;
-	int i;
-	u32 val;
-
-	if (!list_empty(&d40c->queue))
-		d40d_prev = d40_last_queued(d40c);
-	else if (!list_empty(&d40c->active))
-		d40d_prev = d40_first_active_get(d40c);
-
-	if (!d40d_prev)
-		return;
-
-	/* Here we try to join this job with previous jobs */
-	val = readl(d40c->base->virtbase + D40_DREG_PCBASE +
-		    d40c->phy_chan->num * D40_DREG_PCDELTA +
-		    D40_CHAN_REG_SSLNK);
-
-	/* Figure out which link we're currently transmitting */
-	for (i = 0; i < d40d_prev->lli_len; i++)
-		if (val == d40d_prev->lli_phy.src[i].reg_lnk)
-			break;
-
-	val = readl(d40c->base->virtbase + D40_DREG_PCBASE +
-		    d40c->phy_chan->num * D40_DREG_PCDELTA +
-		    D40_CHAN_REG_SSELT) >> D40_SREG_ELEM_LOG_ECNT_POS;
-
-	if (i == (d40d_prev->lli_len - 1) && val > 0) {
-		/* Change the current one */
-		writel(virt_to_phys(d40d->lli_phy.src),
-		       d40c->base->virtbase + D40_DREG_PCBASE +
-		       d40c->phy_chan->num * D40_DREG_PCDELTA +
-		       D40_CHAN_REG_SSLNK);
-		writel(virt_to_phys(d40d->lli_phy.dst),
-		       d40c->base->virtbase + D40_DREG_PCBASE +
-		       d40c->phy_chan->num * D40_DREG_PCDELTA +
-		       D40_CHAN_REG_SDLNK);
-
-		d40d->is_hw_linked = true;
-
-	} else if (i < d40d_prev->lli_len) {
-		(void) dma_unmap_single(d40c->base->dev,
-					virt_to_phys(d40d_prev->lli_phy.src),
-					d40d_prev->lli_pool.size,
-					DMA_TO_DEVICE);
-
-		/* Keep the settings */
-		val = d40d_prev->lli_phy.src[d40d_prev->lli_len - 1].reg_lnk &
-			~D40_SREG_LNK_PHYS_LNK_MASK;
-		d40d_prev->lli_phy.src[d40d_prev->lli_len - 1].reg_lnk =
-			val | virt_to_phys(d40d->lli_phy.src);
-
-		val = d40d_prev->lli_phy.dst[d40d_prev->lli_len - 1].reg_lnk &
-			~D40_SREG_LNK_PHYS_LNK_MASK;
-		d40d_prev->lli_phy.dst[d40d_prev->lli_len - 1].reg_lnk =
-			val | virt_to_phys(d40d->lli_phy.dst);
-
-		(void) dma_map_single(d40c->base->dev,
-				      d40d_prev->lli_phy.src,
-				      d40d_prev->lli_pool.size,
-				      DMA_TO_DEVICE);
-		d40d->is_hw_linked = true;
-	}
-}
-
 static dma_cookie_t d40_tx_submit(struct dma_async_tx_descriptor *tx)
 {
 	struct d40_chan *d40c = container_of(tx->chan,
@@ -1019,8 +934,6 @@ static dma_cookie_t d40_tx_submit(struct dma_async_tx_descriptor *tx)
 	struct d40_desc *d40d = container_of(tx, struct d40_desc, txd);
 	unsigned long flags;
 
-	(void) d40_pause(&d40c->chan);
-
 	spin_lock_irqsave(&d40c->lock, flags);
 
 	d40c->chan.cookie++;
@@ -1030,17 +943,10 @@ static dma_cookie_t d40_tx_submit(struct dma_async_tx_descriptor *tx)
 
 	d40d->txd.cookie = d40c->chan.cookie;
 
-	if (d40c->log_num == D40_PHY_CHAN)
-		d40_tx_submit_phy(d40c, d40d);
-	else
-		d40_tx_submit_log(d40c, d40d);
-
 	d40_desc_queue(d40c, d40d);
 
 	spin_unlock_irqrestore(&d40c->lock, flags);
 
-	(void) d40_resume(&d40c->chan);
-
 	return tx->cookie;
 }
 
@@ -1080,21 +986,14 @@ static struct d40_desc *d40_queue_start(struct d40_chan *d40c)
 		/* Add to active queue */
 		d40_desc_submit(d40c, d40d);
 
-		/*
-		 * If this job is already linked in hw,
-		 * do not submit it.
-		 */
-
-		if (!d40d->is_hw_linked) {
-			/* Initiate DMA job */
-			d40_desc_load(d40c, d40d);
+		/* Initiate DMA job */
+		d40_desc_load(d40c, d40d);
 
-			/* Start dma job */
-			err = d40_start(d40c);
+		/* Start dma job */
+		err = d40_start(d40c);
 
-			if (err)
-				return NULL;
-		}
+		if (err)
+			return NULL;
 	}
 
 	return d40d;
-- 
1.7.3.2

