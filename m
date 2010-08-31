Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757259Ab0HaMOP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 08:14:15 -0400
Received: from eu1sys200aog111.obsmtp.com ([207.126.144.131]:42598 "EHLO
	eu1sys200aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756933Ab0HaMNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 08:13:07 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Dan Williams <dan.j.williams@intel.com>,
        <linux-arm-kernel@lists.infradead.org>, <yuanyabin1978@sina.com>
Cc: <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH 11/12] DMAENGINE: let PL08X memcpy TXDs wait
Date: Tue, 31 Aug 2010 14:12:13 +0200
Message-ID: <1283256734-3408-12-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1283256734-3408-11-git-send-email-linus.walleij@stericsson.com>
References: <1283256734-3408-1-git-send-email-linus.walleij@stericsson.com>
 <1283256734-3408-2-git-send-email-linus.walleij@stericsson.com>
 <1283256734-3408-3-git-send-email-linus.walleij@stericsson.com>
 <1283256734-3408-4-git-send-email-linus.walleij@stericsson.com>
 <1283256734-3408-5-git-send-email-linus.walleij@stericsson.com>
 <1283256734-3408-6-git-send-email-linus.walleij@stericsson.com>
 <1283256734-3408-7-git-send-email-linus.walleij@stericsson.com>
 <1283256734-3408-8-git-send-email-linus.walleij@stericsson.com>
 <1283256734-3408-9-git-send-email-linus.walleij@stericsson.com>
 <1283256734-3408-10-git-send-email-linus.walleij@stericsson.com>
 <1283256734-3408-11-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change makes the memcpy transfers wait for a physical channel
to become available if no free channel is available when the job
is submitted. When the first physical channel fires its tasklet,
it will spin over the memcpy channels to see if one of these is
waiting.

This is necessary to get the memcpy semantics right: the generic
memcpy API assume transfers never fail, and with our oversubscribed
physical channels this becomes a problem: sometimes submit would
fail. This fixes it by letting the memcpy channels pull a free
channel ASAP.

The slave channels shall however *fail* if no channel is available
since the device will then either fall back to some PIO mode or
retry.

Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
 drivers/dma/amba-pl08x.c   |  299 ++++++++++++++++++++++++--------------------
 include/linux/amba/pl08x.h |    3 +
 2 files changed, 168 insertions(+), 134 deletions(-)

diff --git a/drivers/dma/amba-pl08x.c b/drivers/dma/amba-pl08x.c
index 4573189..49fb19d 100644
--- a/drivers/dma/amba-pl08x.c
+++ b/drivers/dma/amba-pl08x.c
@@ -1018,134 +1018,6 @@ static void pl08x_free_txd_list(struct pl08x_driver_data *pl08x,
 	}
 }
 
-static void pl08x_tasklet(unsigned long data)
-{
-	struct pl08x_dma_chan *plchan = (struct pl08x_dma_chan *) data;
-	struct pl08x_phy_chan *phychan = plchan->phychan;
-	struct pl08x_driver_data *pl08x = plchan->host;
-	unsigned long flags;
-
-	if (!plchan)
-		BUG();
-
-	spin_lock_irqsave(&plchan->lock, flags);
-
-	if (plchan->at) {
-		dma_async_tx_callback callback =
-			plchan->at->tx.callback;
-		void *callback_param =
-			plchan->at->tx.callback_param;
-
-		/*
-		 * Update last completed
-		 */
-		plchan->lc =
-			(plchan->at->tx.cookie);
-
-		/*
-		 * Callback to signal completion
-		 */
-		if (callback)
-			callback(callback_param);
-
-		/*
-		 * Device callbacks should NOT clear
-		 * the current transaction on the channel
-		 * Linus: sometimes they should?
-		 */
-		if (!plchan->at)
-			BUG();
-
-		/*
-		 * Free the descriptor if it's not for a device
-		 * using a circular buffer
-		 */
-		if (!plchan->at->cd->circular_buffer) {
-			pl08x_free_txd(pl08x, plchan->at);
-			plchan->at = NULL;
-		}
-		/*
-		 * else descriptor for circular
-		 * buffers only freed when
-		 * client has disabled dma
-		 */
-	}
-	/*
-	 * If a new descriptor is queued, set it up
-	 * plchan->at is NULL here
-	 */
-	if (!list_empty(&plchan->desc_list)) {
-		struct pl08x_txd *next;
-
-		next = list_first_entry(&plchan->desc_list,
-					struct pl08x_txd,
-					node);
-		list_del(&next->node);
-		plchan->at = next;
-		/* Configure the physical channel for the next txd */
-		pl08x_config_phychan_for_txd(plchan);
-		pl08x_set_cregs(pl08x, plchan->phychan);
-		pl08x_enable_phy_chan(pl08x, plchan->phychan);
-	} else {
-		/*
-		 * No more jobs, so free up the physical channel
-		 * Free any allocated signal on slave transfers too
-		 */
-		if ((phychan->signal >= 0) && pl08x->pd->put_signal) {
-			pl08x->pd->put_signal(plchan);
-			phychan->signal = -1;
-		}
-		pl08x_put_phy_channel(pl08x, phychan);
-		plchan->phychan = NULL;
-	}
-
-	spin_unlock_irqrestore(&plchan->lock, flags);
-}
-
-static irqreturn_t pl08x_irq(int irq, void *dev)
-{
-	struct pl08x_driver_data *pl08x = dev;
-	u32 mask = 0;
-	u32 val;
-	int i;
-
-	val = readl(pl08x->base + PL080_ERR_STATUS);
-	if (val) {
-		/*
-		 * An error interrupt (on one or more channels)
-		 */
-		dev_err(&pl08x->adev->dev,
-			"%s error interrupt, register value 0x%08x\n",
-				__func__, val);
-		/*
-		 * Simply clear ALL PL08X error interrupts,
-		 * regardless of channel and cause
-		 * FIXME: should be 0x00000003 on PL081 really.
-		 */
-		writel(0x000000FF, pl08x->base + PL080_ERR_CLEAR);
-	}
-	val = readl(pl08x->base + PL080_INT_STATUS);
-	for (i = 0; i < pl08x->vd->channels; i++) {
-		if ((1 << i) & val) {
-			/* Locate physical channel */
-			struct pl08x_phy_chan *phychan = &pl08x->phy_chans[i];
-			struct pl08x_dma_chan *plchan = phychan->serving;
-
-			/* Schedule tasklet on this channel */
-			tasklet_schedule(&plchan->tasklet);
-
-			mask |= (1 << i);
-		}
-	}
-	/*
-	 * Clear only the terminal interrupts on channels we processed
-	 */
-	writel(mask, pl08x->base + PL080_TC_CLEAR);
-
-	return mask ? IRQ_HANDLED : IRQ_NONE;
-}
-
-
 /*
  * The DMA ENGINE API
  */
@@ -1265,12 +1137,20 @@ static dma_cookie_t pl08x_tx_submit(struct dma_async_tx_descriptor *tx)
 	 */
 	ret = prep_phy_channel(plchan, txd);
 	if (ret) {
-		/* No physical channel available, cope with it */
-		pl08x_free_txd_list(pl08x, plchan);
-		spin_unlock_irqrestore(&plchan->lock, flags);
-		return -EBUSY;
+		/*
+		 * No physical channel available, we will
+		 * stack up the memcpy channels until there is a channel
+		 * available to handle it whereas slave transfers cannot
+		 * wait and will simply be NACK:ed with -EBUSY.
+		 */
+		if (plchan->slave) {
+			/* No physical channel available, cope with it */
+			pl08x_free_txd_list(pl08x, plchan);
+			spin_unlock_irqrestore(&plchan->lock, flags);
+			return -EBUSY;
+		} else
+			plchan->waiting = txd;
 	}
-
 	spin_unlock_irqrestore(&plchan->lock, flags);
 
 	return tx->cookie;
@@ -1478,7 +1358,6 @@ static void pl08x_issue_pending(struct dma_chan *chan)
 	struct pl08x_driver_data *pl08x = plchan->host;
 	unsigned long flags;
 
-
 	spin_lock_irqsave(&plchan->lock, flags);
 	/* Something is already active */
 	if (plchan->at) {
@@ -1486,6 +1365,10 @@ static void pl08x_issue_pending(struct dma_chan *chan)
 			return;
 	}
 
+	/* Didn't get a physical channel so waiting for it ... */
+	if (plchan->waiting)
+		return;
+
 	/* Take the first element in the queue and execute it */
 	if (!list_empty(&plchan->desc_list)) {
 		struct pl08x_txd *next;
@@ -1713,6 +1596,154 @@ static void pl08x_ensure_on(struct pl08x_driver_data *pl08x)
 	writel(val, pl08x->base + PL080_CONFIG);
 }
 
+static void pl08x_tasklet(unsigned long data)
+{
+	struct pl08x_dma_chan *plchan = (struct pl08x_dma_chan *) data;
+	struct pl08x_phy_chan *phychan = plchan->phychan;
+	struct pl08x_driver_data *pl08x = plchan->host;
+
+	if (!plchan)
+		BUG();
+
+	spin_lock(&plchan->lock);
+
+	if (plchan->at) {
+		dma_async_tx_callback callback =
+			plchan->at->tx.callback;
+		void *callback_param =
+			plchan->at->tx.callback_param;
+
+		/*
+		 * Update last completed
+		 */
+		plchan->lc =
+			(plchan->at->tx.cookie);
+
+		/*
+		 * Callback to signal completion
+		 */
+		if (callback)
+			callback(callback_param);
+
+		/*
+		 * Device callbacks should NOT clear
+		 * the current transaction on the channel
+		 * Linus: sometimes they should?
+		 */
+		if (!plchan->at)
+			BUG();
+
+		/*
+		 * Free the descriptor if it's not for a device
+		 * using a circular buffer
+		 */
+		if (!plchan->at->cd->circular_buffer) {
+			pl08x_free_txd(pl08x, plchan->at);
+			plchan->at = NULL;
+		}
+		/*
+		 * else descriptor for circular
+		 * buffers only freed when
+		 * client has disabled dma
+		 */
+	}
+	/*
+	 * If a new descriptor is queued, set it up
+	 * plchan->at is NULL here
+	 */
+	if (!list_empty(&plchan->desc_list)) {
+		struct pl08x_txd *next;
+
+		next = list_first_entry(&plchan->desc_list,
+					struct pl08x_txd,
+					node);
+		list_del(&next->node);
+		plchan->at = next;
+		/* Configure the physical channel for the next txd */
+		pl08x_config_phychan_for_txd(plchan);
+		pl08x_set_cregs(pl08x, plchan->phychan);
+		pl08x_enable_phy_chan(pl08x, plchan->phychan);
+	} else {
+		struct pl08x_dma_chan *waiting = NULL;
+
+		/*
+		 * No more jobs, so free up the physical channel
+		 * Free any allocated signal on slave transfers too
+		 */
+		if ((phychan->signal >= 0) && pl08x->pd->put_signal) {
+			pl08x->pd->put_signal(plchan);
+			phychan->signal = -1;
+		}
+		pl08x_put_phy_channel(pl08x, phychan);
+		plchan->phychan = NULL;
+
+		/*
+		 * And NOW before anyone else can grab that free:d
+		 * up physical channel, see if there is some memcpy
+		 * pending that seriously needs to start because of
+		 * being stacked up while we were choking the
+		 * physical channels with data.
+		 */
+		list_for_each_entry(waiting, &pl08x->memcpy.channels, chan.device_node) {
+			if (waiting->waiting) {
+				int ret;
+
+				/* This should REALLY not fail now */
+				ret = prep_phy_channel(waiting, waiting->waiting);
+				BUG_ON(ret);
+				waiting->waiting = NULL;
+				pl08x_issue_pending(&waiting->chan);
+				break;
+			}
+		}
+	}
+
+	spin_unlock(&plchan->lock);
+}
+
+static irqreturn_t pl08x_irq(int irq, void *dev)
+{
+	struct pl08x_driver_data *pl08x = dev;
+	u32 mask = 0;
+	u32 val;
+	int i;
+
+	val = readl(pl08x->base + PL080_ERR_STATUS);
+	if (val) {
+		/*
+		 * An error interrupt (on one or more channels)
+		 */
+		dev_err(&pl08x->adev->dev,
+			"%s error interrupt, register value 0x%08x\n",
+				__func__, val);
+		/*
+		 * Simply clear ALL PL08X error interrupts,
+		 * regardless of channel and cause
+		 * FIXME: should be 0x00000003 on PL081 really.
+		 */
+		writel(0x000000FF, pl08x->base + PL080_ERR_CLEAR);
+	}
+	val = readl(pl08x->base + PL080_INT_STATUS);
+	for (i = 0; i < pl08x->vd->channels; i++) {
+		if ((1 << i) & val) {
+			/* Locate physical channel */
+			struct pl08x_phy_chan *phychan = &pl08x->phy_chans[i];
+			struct pl08x_dma_chan *plchan = phychan->serving;
+
+			/* Schedule tasklet on this channel */
+			tasklet_schedule(&plchan->tasklet);
+
+			mask |= (1 << i);
+		}
+	}
+	/*
+	 * Clear only the terminal interrupts on channels we processed
+	 */
+	writel(mask, pl08x->base + PL080_TC_CLEAR);
+
+	return mask ? IRQ_HANDLED : IRQ_NONE;
+}
+
 /*
  * Initialise the DMAC memcpy/slave channels.
  * Make a local wrapper to hold required data
diff --git a/include/linux/amba/pl08x.h b/include/linux/amba/pl08x.h
index 6db44f9..f461648 100644
--- a/include/linux/amba/pl08x.h
+++ b/include/linux/amba/pl08x.h
@@ -139,6 +139,8 @@ struct pl08x_txd {
  * @host: a pointer to the host (internal use)
  * @paused: whether the channel is paused
  * @slave: whether this channel is a device (slave) or for memcpy
+ * @waiting: a TX descriptor on this channel which is waiting for
+ * a physical channel to become available
  */
 struct pl08x_dma_chan {
 	struct dma_chan chan;
@@ -156,6 +158,7 @@ struct pl08x_dma_chan {
 	void *host;
 	bool paused;
 	bool slave;
+	struct pl08x_txd *waiting;
 };
 
 /**
-- 
1.6.3.3

