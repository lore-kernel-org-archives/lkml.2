Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932267Ab0HaMNT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 08:13:19 -0400
Received: from eu1sys200aog102.obsmtp.com ([207.126.144.113]:36033 "EHLO
	eu1sys200aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754329Ab0HaMNP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 08:13:15 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Dan Williams <dan.j.williams@intel.com>,
        <linux-arm-kernel@lists.infradead.org>, <yuanyabin1978@sina.com>
Cc: <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH 12/12] DMAENGINE: define channel states for the PL08X
Date: Tue, 31 Aug 2010 14:12:14 +0200
Message-ID: <1283256734-3408-13-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1283256734-3408-12-git-send-email-linus.walleij@stericsson.com>
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
 <1283256734-3408-12-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of strange things like a bool indicating paused state for
channels, let's define a proper channel state and use that. Also
print it out in the debugfs so we get a nice overview of the
channels and states.

Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
 drivers/dma/amba-pl08x.c   |   70 ++++++++++++++++++++++++++++++++++----------
 include/linux/amba/pl08x.h |   22 ++++++++++++-
 2 files changed, 74 insertions(+), 18 deletions(-)

diff --git a/drivers/dma/amba-pl08x.c b/drivers/dma/amba-pl08x.c
index 49fb19d..1718b2e 100644
--- a/drivers/dma/amba-pl08x.c
+++ b/drivers/dma/amba-pl08x.c
@@ -1148,9 +1148,20 @@ static dma_cookie_t pl08x_tx_submit(struct dma_async_tx_descriptor *tx)
 			pl08x_free_txd_list(pl08x, plchan);
 			spin_unlock_irqrestore(&plchan->lock, flags);
 			return -EBUSY;
-		} else
+		} else {
+			plchan->state = PL08X_CHAN_WAITING;
 			plchan->waiting = txd;
-	}
+		}
+	} else
+		/*
+		 * Else we're all set, paused and ready to roll,
+		 * status will switch to PL08X_CHAN_RUNNING when
+		 * we call issue_pending(). If there is something
+		 * running on the channel already we don't change
+		 * its state.
+		 */
+		if (plchan->state == PL08X_CHAN_IDLE)
+			plchan->state = PL08X_CHAN_PAUSED;
 	spin_unlock_irqrestore(&plchan->lock, flags);
 
 	return tx->cookie;
@@ -1206,9 +1217,10 @@ pl08x_dma_tx_status(struct dma_chan *chan,
 	dma_set_tx_state(txstate, last_complete, last_used,
 			 bytesleft);
 
-	if (plchan->paused)
+	if (plchan->state == PL08X_CHAN_PAUSED)
 		return DMA_PAUSED;
 
+	/* Whether waiting or running, we're in progress */
 	return DMA_IN_PROGRESS;
 }
 
@@ -1366,7 +1378,7 @@ static void pl08x_issue_pending(struct dma_chan *chan)
 	}
 
 	/* Didn't get a physical channel so waiting for it ... */
-	if (plchan->waiting)
+	if (plchan->state == PL08X_CHAN_WAITING)
 		return;
 
 	/* Take the first element in the queue and execute it */
@@ -1378,6 +1390,7 @@ static void pl08x_issue_pending(struct dma_chan *chan)
 					node);
 		list_del(&next->node);
 		plchan->at = next;
+		plchan->state = PL08X_CHAN_RUNNING;
 
 		/* Configure the physical channel for the active txd */
 		pl08x_config_phychan_for_txd(plchan);
@@ -1520,7 +1533,7 @@ static int pl08x_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
 
 	switch (cmd) {
 	case DMA_TERMINATE_ALL:
-		plchan->paused = false;
+		plchan->state = PL08X_CHAN_IDLE;
 
 		if (plchan->phychan) {
 			pl08x_stop_phy_chan(plchan->phychan);
@@ -1549,11 +1562,11 @@ static int pl08x_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
 		break;
 	case DMA_PAUSE:
 		pl08x_pause_phy_chan(plchan->phychan);
-		plchan->paused = true;
+		plchan->state = PL08X_CHAN_PAUSED;
 		break;
 	case DMA_RESUME:
 		pl08x_resume_phy_chan(plchan->phychan);
-		plchan->paused = false;
+		plchan->state = PL08X_CHAN_RUNNING;
 		break;
 	default:
 		/* Unknown command */
@@ -1676,6 +1689,7 @@ static void pl08x_tasklet(unsigned long data)
 		}
 		pl08x_put_phy_channel(pl08x, phychan);
 		plchan->phychan = NULL;
+		plchan->state = PL08X_CHAN_IDLE;
 
 		/*
 		 * And NOW before anyone else can grab that free:d
@@ -1684,13 +1698,17 @@ static void pl08x_tasklet(unsigned long data)
 		 * being stacked up while we were choking the
 		 * physical channels with data.
 		 */
-		list_for_each_entry(waiting, &pl08x->memcpy.channels, chan.device_node) {
-			if (waiting->waiting) {
+		list_for_each_entry(waiting, &pl08x->memcpy.channels,
+				    chan.device_node) {
+		  if (waiting->state == PL08X_CHAN_WAITING &&
+			    waiting->waiting != NULL) {
 				int ret;
 
 				/* This should REALLY not fail now */
-				ret = prep_phy_channel(waiting, waiting->waiting);
+				ret = prep_phy_channel(waiting,
+						       waiting->waiting);
 				BUG_ON(ret);
+				waiting->state = PL08X_CHAN_RUNNING;
 				waiting->waiting = NULL;
 				pl08x_issue_pending(&waiting->chan);
 				break;
@@ -1771,6 +1789,7 @@ static int pl08x_dma_init_virtual_channels(struct pl08x_driver_data *pl08x,
 		}
 
 		chan->host = pl08x;
+		chan->state = PL08X_CHAN_IDLE;
 
 		if (slave) {
 			chan->slave = true;
@@ -1817,6 +1836,23 @@ static void pl08x_free_virtual_channels(struct dma_device *dmadev)
 }
 
 #ifdef CONFIG_DEBUG_FS
+static const char *pl08x_state_str(enum pl08x_dma_chan_state state)
+{
+	switch(state) {
+	case PL08X_CHAN_IDLE:
+		return "idle";
+	case PL08X_CHAN_RUNNING:
+		return "running";
+	case PL08X_CHAN_PAUSED:
+		return "paused";
+	case PL08X_CHAN_WAITING:
+		return "waiting";
+	default:
+		break;
+	}
+	return "UNKNOWN STATE";
+}
+
 static int pl08x_debugfs_show(struct seq_file *s, void *data)
 {
 	struct pl08x_driver_data *pl08x = s->private;
@@ -1843,17 +1879,19 @@ static int pl08x_debugfs_show(struct seq_file *s, void *data)
 	}
 
 	seq_printf(s, "\nPL08x virtual memcpy channels:\n");
-	seq_printf(s, "CHANNEL:\n");
-	seq_printf(s, "--------\n");
+	seq_printf(s, "CHANNEL:\tSTATE:\n");
+	seq_printf(s, "--------\t------\n");
 	list_for_each_entry(chan, &pl08x->memcpy.channels, chan.device_node) {
-		seq_printf(s, "%s\n", chan->name);
+		seq_printf(s, "%s\t\t\%s\n", chan->name,
+			   pl08x_state_str(chan->state));
 	}
 
 	seq_printf(s, "\nPL08x virtual slave channels:\n");
-	seq_printf(s, "CHANNEL:\n");
-	seq_printf(s, "--------\n");
+	seq_printf(s, "CHANNEL:\tSTATE:\n");
+	seq_printf(s, "--------\t------\n");
 	list_for_each_entry(chan, &pl08x->slave.channels, chan.device_node) {
-		seq_printf(s, "%s\n", chan->name);
+		seq_printf(s, "%s\t\t\%s\n", chan->name,
+			   pl08x_state_str(chan->state));
 	}
 
 	return 0;
diff --git a/include/linux/amba/pl08x.h b/include/linux/amba/pl08x.h
index f461648..d54fbff 100644
--- a/include/linux/amba/pl08x.h
+++ b/include/linux/amba/pl08x.h
@@ -123,6 +123,24 @@ struct pl08x_txd {
 };
 
 /**
+ * struct pl08x_dma_chan_state - holds the PL08x specific virtual
+ * channel states
+ * @PL08X_CHAN_IDLE: the channel is idle
+ * @PL08X_CHAN_RUNNING: the channel has allocated a physical transport
+ * channel and is running a transfer on it
+ * @PL08X_CHAN_PAUSED: the channel has allocated a physical transport
+ * channel, but the transfer is currently paused
+ * @PL08X_CHAN_WAITING: the channel is waiting for a physical transport
+ * channel to become available (only pertains to memcpy channels)
+ */
+enum pl08x_dma_chan_state {
+	PL08X_CHAN_IDLE,
+	PL08X_CHAN_RUNNING,
+	PL08X_CHAN_PAUSED,
+	PL08X_CHAN_WAITING,
+};
+
+/**
  * struct pl08x_dma_chan - this structure wraps a DMA ENGINE channel
  * @chan: wrappped abstract channel
  * @phychan: the physical channel utilized by this channel, if there is one
@@ -137,7 +155,7 @@ struct pl08x_txd {
  * @at: active transaction on this channel
  * @lock: a lock for this channel data
  * @host: a pointer to the host (internal use)
- * @paused: whether the channel is paused
+ * @state: whether the channel is idle, paused, running etc
  * @slave: whether this channel is a device (slave) or for memcpy
  * @waiting: a TX descriptor on this channel which is waiting for
  * a physical channel to become available
@@ -156,7 +174,7 @@ struct pl08x_dma_chan {
 	struct pl08x_txd *at;
 	spinlock_t lock;
 	void *host;
-	bool paused;
+	enum pl08x_dma_chan_state state;
 	bool slave;
 	struct pl08x_txd *waiting;
 };
-- 
1.6.3.3

