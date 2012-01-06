Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751866Ab2AFGJ0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 01:09:26 -0500
Received: from eu1sys200aog117.obsmtp.com ([207.126.144.143]:48067 "EHLO
	eu1sys200aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750727Ab2AFGJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 01:09:25 -0500
From: Narayanan G <narayanan.gopalakrishnan@stericsson.com>
To: <linux-kernel@vger.kernel.org>, Vinod Koul <vinod.koul@intel.com>
Cc: <rabin.vincent@stericsson.com>, <linus.walleij@stericsson.com>,
        Narayanan G <narayanan.gopalakrishnan@stericsson.com>
Subject: [PATCH] dma40: Improve the logic of stopping logical chan
Date: Fri, 6 Jan 2012 11:39:02 +0530
Message-ID: <1325830142-16496-1-git-send-email-narayanan.gopalakrishnan@stericsson.com>
X-Mailer: git-send-email 1.7.4.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From the V2 version of the controller a logical channel
can be directly stopped by issuing a SUSPEND_REQ on the EE
bits. There is no need to suspend the physical channel and
restart it.

Also, the support for pre-V2 hw is discontinued.

EE bits for writing:

00: disable only if AS=11 or AS=00
01: enable
10: suspend_req only if AS=01 & EE=01 or EE=11
11: round / no change for writing

ST-Ericsson ID: 399374
ST-Ericsson FOSS-OUT ID: NA
ST-Ericsson Linux next: NA

Signed-off-by: Narayanan G <narayanan.gopalakrishnan@stericsson.com>
---
 drivers/dma/ste_dma40.c    |  320 +++++++++++++++++++++++++++-----------------
 drivers/dma/ste_dma40_ll.h |    2 -
 2 files changed, 199 insertions(+), 123 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index cc5ecbc..8009e8b1 100755
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -68,6 +68,22 @@ enum d40_command {
 };
 
 /*
+ * enum d40_events - The different Event Enables for the event lines.
+ *
+ * @D40_DEACTIVATE_EVENTLINE: De-activate Event line, stopping the logical chan.
+ * @D40_ACTIVATE_EVENTLINE: Activate the Event line, to start a logical chan.
+ * @D40_SUSPEND_REQ_EVENTLINE: Requesting for suspending a event line.
+ * @D40_ROUND_EVENTLINE: Status check for event line.
+ */
+
+enum d40_events {
+	D40_DEACTIVATE_EVENTLINE	= 0,
+	D40_ACTIVATE_EVENTLINE		= 1,
+	D40_SUSPEND_REQ_EVENTLINE	= 2,
+	D40_ROUND_EVENTLINE		= 3
+};
+
+/*
  * These are the registers that has to be saved and later restored
  * when the DMA hw is powered off.
  * TODO: Add save/restore of D40_DREG_GCC on dma40 v3 or later, if that works.
@@ -873,8 +889,8 @@ static void d40_save_restore_registers(struct d40_base *base, bool save)
 }
 #endif
 
-static int d40_channel_execute_command(struct d40_chan *d40c,
-				       enum d40_command command)
+static int __d40_execute_command_phy(struct d40_chan *d40c,
+				     enum d40_command command)
 {
 	u32 status;
 	int i;
@@ -883,6 +899,12 @@ static int d40_channel_execute_command(struct d40_chan *d40c,
 	unsigned long flags;
 	u32 wmask;
 
+	if (command == D40_DMA_STOP) {
+		ret = __d40_execute_command_phy(d40c, D40_DMA_SUSPEND_REQ);
+		if (ret)
+			return ret;
+	}
+
 	spin_lock_irqsave(&d40c->base->execmd_lock, flags);
 
 	if (d40c->phy_chan->num % 2 == 0)
@@ -976,67 +998,109 @@ static void d40_term_all(struct d40_chan *d40c)
 		}
 
 	d40c->pending_tx = 0;
-	d40c->busy = false;
 }
 
-static void __d40_config_set_event(struct d40_chan *d40c, bool enable,
-				   u32 event, int reg)
+static void __d40_config_set_event(struct d40_chan *d40c,
+				   enum d40_events event_type, u32 event,
+				   int reg)
 {
 	void __iomem *addr = chan_base(d40c) + reg;
 	int tries;
+	u32 status;
+
+	switch (event_type) {
+
+	case D40_DEACTIVATE_EVENTLINE:
 
-	if (!enable) {
 		writel((D40_DEACTIVATE_EVENTLINE << D40_EVENTLINE_POS(event))
 		       | ~D40_EVENTLINE_MASK(event), addr);
-		return;
-	}
+		break;
+
+	case D40_SUSPEND_REQ_EVENTLINE:
+		status = (readl(addr) & D40_EVENTLINE_MASK(event)) >>
+			  D40_EVENTLINE_POS(event);
+
+		if (status == D40_DEACTIVATE_EVENTLINE ||
+		    status == D40_SUSPEND_REQ_EVENTLINE)
+			break;
 
+		writel((D40_SUSPEND_REQ_EVENTLINE << D40_EVENTLINE_POS(event))
+		       | ~D40_EVENTLINE_MASK(event), addr);
+
+		for (tries = 0 ; tries < D40_SUSPEND_MAX_IT; tries++) {
+
+			status = (readl(addr) & D40_EVENTLINE_MASK(event)) >>
+				  D40_EVENTLINE_POS(event);
+
+			cpu_relax();
+			/*
+			 * Reduce the number of bus accesses while
+			 * waiting for the DMA to suspend.
+			 */
+			udelay(3);
+
+			if (status == D40_DEACTIVATE_EVENTLINE)
+				break;
+		}
+
+		if (tries == D40_SUSPEND_MAX_IT) {
+			chan_err(d40c,
+				"unable to stop the event_line chl %d (log: %d)"
+				"status %x\n", d40c->phy_chan->num,
+				 d40c->log_num, status);
+		}
+		break;
+
+	case D40_ACTIVATE_EVENTLINE:
 	/*
 	 * The hardware sometimes doesn't register the enable when src and dst
 	 * event lines are active on the same logical channel.  Retry to ensure
 	 * it does.  Usually only one retry is sufficient.
 	 */
-	tries = 100;
-	while (--tries) {
-		writel((D40_ACTIVATE_EVENTLINE << D40_EVENTLINE_POS(event))
-		       | ~D40_EVENTLINE_MASK(event), addr);
+		tries = 100;
+		while (--tries) {
+			writel((D40_ACTIVATE_EVENTLINE <<
+				D40_EVENTLINE_POS(event)) |
+				~D40_EVENTLINE_MASK(event), addr);
 
-		if (readl(addr) & D40_EVENTLINE_MASK(event))
-			break;
-	}
+			if (readl(addr) & D40_EVENTLINE_MASK(event))
+				break;
+		}
 
-	if (tries != 99)
-		dev_dbg(chan2dev(d40c),
-			"[%s] workaround enable S%cLNK (%d tries)\n",
-			__func__, reg == D40_CHAN_REG_SSLNK ? 'S' : 'D',
-			100 - tries);
+		if (tries != 99)
+			dev_dbg(chan2dev(d40c),
+				"[%s] workaround enable S%cLNK (%d tries)\n",
+				__func__, reg == D40_CHAN_REG_SSLNK ? 'S' : 'D',
+				100 - tries);
 
-	WARN_ON(!tries);
-}
+		WARN_ON(!tries);
+		break;
 
-static void d40_config_set_event(struct d40_chan *d40c, bool do_enable)
-{
-	unsigned long flags;
+	case D40_ROUND_EVENTLINE:
+		BUG();
+		break;
 
-	spin_lock_irqsave(&d40c->phy_chan->lock, flags);
+	}
+}
 
+static void d40_config_set_event(struct d40_chan *d40c,
+				 enum d40_events event_type)
+{
 	/* Enable event line connected to device (or memcpy) */
 	if ((d40c->dma_cfg.dir ==  STEDMA40_PERIPH_TO_MEM) ||
 	    (d40c->dma_cfg.dir == STEDMA40_PERIPH_TO_PERIPH)) {
 		u32 event = D40_TYPE_TO_EVENT(d40c->dma_cfg.src_dev_type);
 
-		__d40_config_set_event(d40c, do_enable, event,
+		__d40_config_set_event(d40c, event_type, event,
 				       D40_CHAN_REG_SSLNK);
 	}
 
 	if (d40c->dma_cfg.dir !=  STEDMA40_PERIPH_TO_MEM) {
 		u32 event = D40_TYPE_TO_EVENT(d40c->dma_cfg.dst_dev_type);
 
-		__d40_config_set_event(d40c, do_enable, event,
+		__d40_config_set_event(d40c, event_type, event,
 				       D40_CHAN_REG_SDLNK);
 	}
-
-	spin_unlock_irqrestore(&d40c->phy_chan->lock, flags);
 }
 
 static u32 d40_chan_has_events(struct d40_chan *d40c)
@@ -1050,6 +1114,64 @@ static u32 d40_chan_has_events(struct d40_chan *d40c)
 	return val;
 }
 
+static int
+__d40_execute_command_log(struct d40_chan *d40c, enum d40_command command)
+{
+	unsigned long flags;
+	int ret = 0;
+	u32 active_status;
+	void __iomem *active_reg;
+
+	if (d40c->phy_chan->num % 2 == 0)
+		active_reg = d40c->base->virtbase + D40_DREG_ACTIVE;
+	else
+		active_reg = d40c->base->virtbase + D40_DREG_ACTIVO;
+
+
+	spin_lock_irqsave(&d40c->phy_chan->lock, flags);
+
+	switch (command) {
+	case D40_DMA_STOP:
+	case D40_DMA_SUSPEND_REQ:
+
+		active_status = (readl(active_reg) &
+				 D40_CHAN_POS_MASK(d40c->phy_chan->num)) >>
+				 D40_CHAN_POS(d40c->phy_chan->num);
+
+		if (active_status == D40_DMA_RUN)
+			d40_config_set_event(d40c, D40_SUSPEND_REQ_EVENTLINE);
+		else
+			d40_config_set_event(d40c, D40_DEACTIVATE_EVENTLINE);
+
+		if (!d40_chan_has_events(d40c) && (command == D40_DMA_STOP))
+			ret = __d40_execute_command_phy(d40c, command);
+
+		break;
+
+	case D40_DMA_RUN:
+
+		d40_config_set_event(d40c, D40_ACTIVATE_EVENTLINE);
+		ret = __d40_execute_command_phy(d40c, command);
+		break;
+
+	case D40_DMA_SUSPENDED:
+		BUG();
+		break;
+	}
+
+	spin_unlock_irqrestore(&d40c->phy_chan->lock, flags);
+	return ret;
+}
+
+static int d40_channel_execute_command(struct d40_chan *d40c,
+				       enum d40_command command)
+{
+	if (chan_is_logical(d40c))
+		return __d40_execute_command_log(d40c, command);
+	else
+		return __d40_execute_command_phy(d40c, command);
+}
+
 static u32 d40_get_prmo(struct d40_chan *d40c)
 {
 	static const unsigned int phy_map[] = {
@@ -1152,15 +1274,7 @@ static int d40_pause(struct d40_chan *d40c)
 	spin_lock_irqsave(&d40c->lock, flags);
 
 	res = d40_channel_execute_command(d40c, D40_DMA_SUSPEND_REQ);
-	if (res == 0) {
-		if (chan_is_logical(d40c)) {
-			d40_config_set_event(d40c, false);
-			/* Resume the other logical channels if any */
-			if (d40_chan_has_events(d40c))
-				res = d40_channel_execute_command(d40c,
-								  D40_DMA_RUN);
-		}
-	}
+
 	pm_runtime_mark_last_busy(d40c->base->dev);
 	pm_runtime_put_autosuspend(d40c->base->dev);
 	spin_unlock_irqrestore(&d40c->lock, flags);
@@ -1177,45 +1291,17 @@ static int d40_resume(struct d40_chan *d40c)
 
 	spin_lock_irqsave(&d40c->lock, flags);
 	pm_runtime_get_sync(d40c->base->dev);
-	if (d40c->base->rev == 0)
-		if (chan_is_logical(d40c)) {
-			res = d40_channel_execute_command(d40c,
-							  D40_DMA_SUSPEND_REQ);
-			goto no_suspend;
-		}
 
 	/* If bytes left to transfer or linked tx resume job */
-	if (d40_residue(d40c) || d40_tx_is_linked(d40c)) {
-
-		if (chan_is_logical(d40c))
-			d40_config_set_event(d40c, true);
-
+	if (d40_residue(d40c) || d40_tx_is_linked(d40c))
 		res = d40_channel_execute_command(d40c, D40_DMA_RUN);
-	}
 
-no_suspend:
 	pm_runtime_mark_last_busy(d40c->base->dev);
 	pm_runtime_put_autosuspend(d40c->base->dev);
 	spin_unlock_irqrestore(&d40c->lock, flags);
 	return res;
 }
 
-static int d40_terminate_all(struct d40_chan *chan)
-{
-	unsigned long flags;
-	int ret = 0;
-
-	ret = d40_pause(chan);
-	if (!ret && chan_is_physical(chan))
-		ret = d40_channel_execute_command(chan, D40_DMA_STOP);
-
-	spin_lock_irqsave(&chan->lock, flags);
-	d40_term_all(chan);
-	spin_unlock_irqrestore(&chan->lock, flags);
-
-	return ret;
-}
-
 static dma_cookie_t d40_tx_submit(struct dma_async_tx_descriptor *tx)
 {
 	struct d40_chan *d40c = container_of(tx->chan,
@@ -1242,20 +1328,6 @@ static dma_cookie_t d40_tx_submit(struct dma_async_tx_descriptor *tx)
 
 static int d40_start(struct d40_chan *d40c)
 {
-	if (d40c->base->rev == 0) {
-		int err;
-
-		if (chan_is_logical(d40c)) {
-			err = d40_channel_execute_command(d40c,
-							  D40_DMA_SUSPEND_REQ);
-			if (err)
-				return err;
-		}
-	}
-
-	if (chan_is_logical(d40c))
-		d40_config_set_event(d40c, true);
-
 	return d40_channel_execute_command(d40c, D40_DMA_RUN);
 }
 
@@ -1268,10 +1340,10 @@ static struct d40_desc *d40_queue_start(struct d40_chan *d40c)
 	d40d = d40_first_queued(d40c);
 
 	if (d40d != NULL) {
-		if (!d40c->busy)
+		if (!d40c->busy) {
 			d40c->busy = true;
-
-		pm_runtime_get_sync(d40c->base->dev);
+			pm_runtime_get_sync(d40c->base->dev);
+		}
 
 		/* Remove from queue */
 		d40_desc_remove(d40d);
@@ -1398,8 +1470,8 @@ static void dma_tasklet(unsigned long data)
 
 	return;
 
- err:
-	/* Rescue manoeuvre if receiving double interrupts */
+err:
+	/* Rescue manouver if receiving double interrupts */
 	if (d40c->pending_tx > 0)
 		d40c->pending_tx--;
 	spin_unlock_irqrestore(&d40c->lock, flags);
@@ -1780,7 +1852,6 @@ static int d40_config_memcpy(struct d40_chan *d40c)
 	return 0;
 }
 
-
 static int d40_free_dma(struct d40_chan *d40c)
 {
 
@@ -1816,43 +1887,18 @@ static int d40_free_dma(struct d40_chan *d40c)
 	}
 
 	pm_runtime_get_sync(d40c->base->dev);
-	res = d40_channel_execute_command(d40c, D40_DMA_SUSPEND_REQ);
+	res = d40_channel_execute_command(d40c, D40_DMA_STOP);
 	if (res) {
-		chan_err(d40c, "suspend failed\n");
+		chan_err(d40c, "stop failed\n");
 		goto out;
 	}
 
-	if (chan_is_logical(d40c)) {
-		/* Release logical channel, deactivate the event line */
+	d40_alloc_mask_free(phy, is_src, chan_is_logical(d40c) ? event : 0);
 
-		d40_config_set_event(d40c, false);
+	if (chan_is_logical(d40c))
 		d40c->base->lookup_log_chans[d40c->log_num] = NULL;
-
-		/*
-		 * Check if there are more logical allocation
-		 * on this phy channel.
-		 */
-		if (!d40_alloc_mask_free(phy, is_src, event)) {
-			/* Resume the other logical channels if any */
-			if (d40_chan_has_events(d40c)) {
-				res = d40_channel_execute_command(d40c,
-								  D40_DMA_RUN);
-				if (res)
-					chan_err(d40c,
-						"Executing RUN command\n");
-			}
-			goto out;
-		}
-	} else {
-		(void) d40_alloc_mask_free(phy, is_src, 0);
-	}
-
-	/* Release physical channel */
-	res = d40_channel_execute_command(d40c, D40_DMA_STOP);
-	if (res) {
-		chan_err(d40c, "Failed to stop channel\n");
-		goto out;
-	}
+	else
+		d40c->base->lookup_phy_chans[phy->num] = NULL;
 
 	if (d40c->busy) {
 		pm_runtime_mark_last_busy(d40c->base->dev);
@@ -1862,7 +1908,6 @@ static int d40_free_dma(struct d40_chan *d40c)
 	d40c->busy = false;
 	d40c->phy_chan = NULL;
 	d40c->configured = false;
-	d40c->base->lookup_phy_chans[phy->num] = NULL;
 out:
 
 	pm_runtime_mark_last_busy(d40c->base->dev);
@@ -2386,6 +2431,31 @@ static void d40_issue_pending(struct dma_chan *chan)
 	spin_unlock_irqrestore(&d40c->lock, flags);
 }
 
+static void d40_terminate_all(struct dma_chan *chan)
+{
+	unsigned long flags;
+	struct d40_chan *d40c = container_of(chan, struct d40_chan, chan);
+	int ret;
+
+	spin_lock_irqsave(&d40c->lock, flags);
+
+	pm_runtime_get_sync(d40c->base->dev);
+	ret = d40_channel_execute_command(d40c, D40_DMA_STOP);
+	if (ret)
+		chan_err(d40c, "Failed to stop channel\n");
+
+	d40_term_all(d40c);
+	pm_runtime_mark_last_busy(d40c->base->dev);
+	pm_runtime_put_autosuspend(d40c->base->dev);
+	if (d40c->busy) {
+		pm_runtime_mark_last_busy(d40c->base->dev);
+		pm_runtime_put_autosuspend(d40c->base->dev);
+	}
+	d40c->busy = false;
+
+	spin_unlock_irqrestore(&d40c->lock, flags);
+}
+
 static int
 dma40_config_to_halfchannel(struct d40_chan *d40c,
 			    struct stedma40_half_channel_info *info,
@@ -2566,7 +2636,8 @@ static int d40_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
 
 	switch (cmd) {
 	case DMA_TERMINATE_ALL:
-		return d40_terminate_all(d40c);
+		d40_terminate_all(chan);
+		return 0;
 	case DMA_PAUSE:
 		return d40_pause(d40c);
 	case DMA_RESUME:
@@ -2923,6 +2994,12 @@ static struct d40_base * __init d40_hw_detect_init(struct platform_device *pdev)
 	dev_info(&pdev->dev, "hardware revision: %d @ 0x%x\n",
 		 rev, res->start);
 
+	if (rev < 2) {
+		d40_err(&pdev->dev, "hardware revision: %d is not supported",
+			rev);
+		goto failure;
+	}
+
 	plat_data = pdev->dev.platform_data;
 
 	/* Count the number of logical channels in use */
@@ -3013,6 +3090,7 @@ failure:
 
 	if (base) {
 		kfree(base->lcla_pool.alloc_map);
+		kfree(base->reg_val_backup_chan);
 		kfree(base->lookup_log_chans);
 		kfree(base->lookup_phy_chans);
 		kfree(base->phy_res);
diff --git a/drivers/dma/ste_dma40_ll.h b/drivers/dma/ste_dma40_ll.h
index 8d3d490..51e8e53 100644
--- a/drivers/dma/ste_dma40_ll.h
+++ b/drivers/dma/ste_dma40_ll.h
@@ -62,8 +62,6 @@
 #define D40_SREG_ELEM_LOG_LIDX_MASK	(0xFF << D40_SREG_ELEM_LOG_LIDX_POS)
 
 /* Link register */
-#define D40_DEACTIVATE_EVENTLINE	0x0
-#define D40_ACTIVATE_EVENTLINE		0x1
 #define D40_EVENTLINE_POS(i)		(2 * i)
 #define D40_EVENTLINE_MASK(i)		(0x3 << D40_EVENTLINE_POS(i))
 
-- 
1.7.4.3

