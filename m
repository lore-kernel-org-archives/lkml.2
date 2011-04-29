Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760052Ab1D2RJb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 13:09:31 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:55511 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757894Ab1D2RJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 13:09:27 -0400
Date: Fri, 29 Apr 2011 19:09:21 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: linux-sh@vger.kernel.org
cc: linux-kernel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>,
        Simon Horman <horms@verge.net.au>, Magnus Damm <damm@opensource.se>
Subject: [PATCH 1/2] dmaengine: shdma: fix locking
In-Reply-To: <Pine.LNX.4.64.1104291901200.17813@axis700.grange>
Message-ID: <Pine.LNX.4.64.1104291906140.17813@axis700.grange>
References: <Pine.LNX.4.64.1104291901200.17813@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:24Zh6Q+KBofwjGti0BYpTyvSDwnO2RUl/UXe6PAsiMP
 RrKSWYJBhoX08Sdr48qolPzDEWj5MWn4Msr7w2QYYsIImxI93a
 VN0QOlGaLnZmnEGgrwTKpSZrbtYrPR9tC3sVkAehBP/FL5iewS
 Lpo0tdcy3D6pBTaSNPfFeJ/S9Wg/wUXrEz5NqApanRsfLRIUuq
 DzOlFHW0n/AIpiDP579xvgDk5JO48D8xjLZ3ytF4m8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Close multiple theoretical races, especially the one in
.device_free_chan_resources().

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/dma/shdma.c |  104 +++++++++++++++++++++++++++++++++-----------------
 1 files changed, 68 insertions(+), 36 deletions(-)

diff --git a/drivers/dma/shdma.c b/drivers/dma/shdma.c
index b7f27f5..d0f402b 100644
--- a/drivers/dma/shdma.c
+++ b/drivers/dma/shdma.c
@@ -48,7 +48,7 @@ enum sh_dmae_desc_status {
 
 /*
  * Used for write-side mutual exclusion for the global device list,
- * read-side synchronization by way of RCU.
+ * read-side synchronization by way of RCU, and per-controller data.
  */
 static DEFINE_SPINLOCK(sh_dmae_lock);
 static LIST_HEAD(sh_dmae_devices);
@@ -85,22 +85,35 @@ static void dmaor_write(struct sh_dmae_device *shdev, u16 data)
  */
 static void sh_dmae_ctl_stop(struct sh_dmae_device *shdev)
 {
-	unsigned short dmaor = dmaor_read(shdev);
+	unsigned short dmaor;
+	unsigned long flags;
+
+	spin_lock_irqsave(&sh_dmae_lock, flags);
 
+	dmaor = dmaor_read(shdev);
 	dmaor_write(shdev, dmaor & ~(DMAOR_NMIF | DMAOR_AE | DMAOR_DME));
+
+	spin_unlock_irqrestore(&sh_dmae_lock, flags);
 }
 
 static int sh_dmae_rst(struct sh_dmae_device *shdev)
 {
 	unsigned short dmaor;
+	unsigned long flags;
 
-	sh_dmae_ctl_stop(shdev);
-	dmaor = dmaor_read(shdev) | shdev->pdata->dmaor_init;
+	spin_lock_irqsave(&sh_dmae_lock, flags);
 
-	dmaor_write(shdev, dmaor);
-	if (dmaor_read(shdev) & (DMAOR_AE | DMAOR_NMIF)) {
-		pr_warning("dma-sh: Can't initialize DMAOR.\n");
-		return -EINVAL;
+	dmaor = dmaor_read(shdev) & ~(DMAOR_NMIF | DMAOR_AE | DMAOR_DME);
+
+	dmaor_write(shdev, dmaor | shdev->pdata->dmaor_init);
+
+	dmaor = dmaor_read(shdev);
+
+	spin_unlock_irqrestore(&sh_dmae_lock, flags);
+
+	if (dmaor & (DMAOR_AE | DMAOR_NMIF)) {
+		dev_warn(shdev->common.dev, "Can't initialize DMAOR.\n");
+		return -EIO;
 	}
 	return 0;
 }
@@ -184,7 +197,7 @@ static void dmae_init(struct sh_dmae_chan *sh_chan)
 
 static int dmae_set_chcr(struct sh_dmae_chan *sh_chan, u32 val)
 {
-	/* When DMA was working, can not set data to CHCR */
+	/* If DMA is active, cannot set CHCR. TODO: remove this superfluous check */
 	if (dmae_is_busy(sh_chan))
 		return -EBUSY;
 
@@ -374,7 +387,12 @@ static void sh_dmae_free_chan_resources(struct dma_chan *chan)
 	LIST_HEAD(list);
 	int descs = sh_chan->descs_allocated;
 
+	/* Protect against ISR */
+	spin_lock_irq(&sh_chan->desc_lock);
 	dmae_halt(sh_chan);
+	spin_unlock_irq(&sh_chan->desc_lock);
+
+	/* Now no new interrupts will occur */
 
 	/* Prepared and not submitted descriptors can still be on the queue */
 	if (!list_empty(&sh_chan->ld_queue))
@@ -384,6 +402,7 @@ static void sh_dmae_free_chan_resources(struct dma_chan *chan)
 		/* The caller is holding dma_list_mutex */
 		struct sh_dmae_slave *param = chan->private;
 		clear_bit(param->slave_id, sh_dmae_slave_used);
+		chan->private = NULL;
 	}
 
 	spin_lock_bh(&sh_chan->desc_lock);
@@ -563,8 +582,6 @@ static struct dma_async_tx_descriptor *sh_dmae_prep_memcpy(
 	if (!chan || !len)
 		return NULL;
 
-	chan->private = NULL;
-
 	sh_chan = to_sh_chan(chan);
 
 	sg_init_table(&sg, 1);
@@ -620,9 +637,9 @@ static int sh_dmae_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
 	if (!chan)
 		return -EINVAL;
 
+	spin_lock_bh(&sh_chan->desc_lock);
 	dmae_halt(sh_chan);
 
-	spin_lock_bh(&sh_chan->desc_lock);
 	if (!list_empty(&sh_chan->ld_queue)) {
 		/* Record partial transfer */
 		struct sh_desc *desc = list_entry(sh_chan->ld_queue.next,
@@ -716,6 +733,14 @@ static dma_async_tx_callback __ld_cleanup(struct sh_dmae_chan *sh_chan, bool all
 			list_move(&desc->node, &sh_chan->ld_free);
 		}
 	}
+
+	if (all && !callback)
+		/*
+		 * Terminating and the loop completed normally: forgive
+		 * uncompleted cookies
+		 */
+		sh_chan->completed_cookie = sh_chan->common.cookie;
+
 	spin_unlock_bh(&sh_chan->desc_lock);
 
 	if (callback)
@@ -733,10 +758,6 @@ static void sh_dmae_chan_ld_cleanup(struct sh_dmae_chan *sh_chan, bool all)
 {
 	while (__ld_cleanup(sh_chan, all))
 		;
-
-	if (all)
-		/* Terminating - forgive uncompleted cookies */
-		sh_chan->completed_cookie = sh_chan->common.cookie;
 }
 
 static void sh_chan_xfer_ld_queue(struct sh_dmae_chan *sh_chan)
@@ -782,8 +803,10 @@ static enum dma_status sh_dmae_tx_status(struct dma_chan *chan,
 
 	sh_dmae_chan_ld_cleanup(sh_chan, false);
 
-	last_used = chan->cookie;
+	/* First read completed cookie to avoid a skew */
 	last_complete = sh_chan->completed_cookie;
+	rmb();
+	last_used = chan->cookie;
 	BUG_ON(last_complete < 0);
 	dma_set_tx_state(txstate, last_complete, last_used, 0);
 
@@ -813,8 +836,12 @@ static enum dma_status sh_dmae_tx_status(struct dma_chan *chan,
 static irqreturn_t sh_dmae_interrupt(int irq, void *data)
 {
 	irqreturn_t ret = IRQ_NONE;
-	struct sh_dmae_chan *sh_chan = (struct sh_dmae_chan *)data;
-	u32 chcr = sh_dmae_readl(sh_chan, CHCR);
+	struct sh_dmae_chan *sh_chan = data;
+	u32 chcr;
+
+	spin_lock(&sh_chan->desc_lock);
+
+	chcr = sh_dmae_readl(sh_chan, CHCR);
 
 	if (chcr & CHCR_TE) {
 		/* DMA stop */
@@ -824,10 +851,13 @@ static irqreturn_t sh_dmae_interrupt(int irq, void *data)
 		tasklet_schedule(&sh_chan->tasklet);
 	}
 
+	spin_unlock(&sh_chan->desc_lock);
+
 	return ret;
 }
 
-static unsigned int sh_dmae_reset(struct sh_dmae_device *shdev)
+/* Called from error IRQ or NMI */
+static bool sh_dmae_reset(struct sh_dmae_device *shdev)
 {
 	unsigned int handled = 0;
 	int i;
@@ -839,22 +869,32 @@ static unsigned int sh_dmae_reset(struct sh_dmae_device *shdev)
 	for (i = 0; i < SH_DMAC_MAX_CHANNELS; i++) {
 		struct sh_dmae_chan *sh_chan = shdev->chan[i];
 		struct sh_desc *desc;
+		LIST_HEAD(dl);
 
 		if (!sh_chan)
 			continue;
 
+		spin_lock(&sh_chan->desc_lock);
+
 		/* Stop the channel */
 		dmae_halt(sh_chan);
 
+		list_splice_init(&sh_chan->ld_queue, &dl);
+
+		spin_unlock(&sh_chan->desc_lock);
+
 		/* Complete all  */
-		list_for_each_entry(desc, &sh_chan->ld_queue, node) {
+		list_for_each_entry(desc, &dl, node) {
 			struct dma_async_tx_descriptor *tx = &desc->async_tx;
 			desc->mark = DESC_IDLE;
 			if (tx->callback)
 				tx->callback(tx->callback_param);
 		}
 
-		list_splice_init(&sh_chan->ld_queue, &sh_chan->ld_free);
+		spin_lock(&sh_chan->desc_lock);
+		list_splice(&dl, &sh_chan->ld_free);
+		spin_unlock(&sh_chan->desc_lock);
+
 		handled++;
 	}
 
@@ -867,10 +907,11 @@ static irqreturn_t sh_dmae_err(int irq, void *data)
 {
 	struct sh_dmae_device *shdev = data;
 
-	if (dmaor_read(shdev) & DMAOR_AE)
-		return IRQ_RETVAL(sh_dmae_reset(data));
-	else
+	if (!(dmaor_read(shdev) & DMAOR_AE))
 		return IRQ_NONE;
+
+	sh_dmae_reset(data);
+	return IRQ_HANDLED;
 }
 
 static void dmae_do_tasklet(unsigned long data)
@@ -902,17 +943,11 @@ static void dmae_do_tasklet(unsigned long data)
 
 static bool sh_dmae_nmi_notify(struct sh_dmae_device *shdev)
 {
-	unsigned int handled;
-
 	/* Fast path out if NMIF is not asserted for this controller */
 	if ((dmaor_read(shdev) & DMAOR_NMIF) == 0)
 		return false;
 
-	handled = sh_dmae_reset(shdev);
-	if (handled)
-		return true;
-
-	return false;
+	return sh_dmae_reset(shdev);
 }
 
 static int sh_dmae_nmi_handler(struct notifier_block *self,
@@ -982,9 +1017,6 @@ static int __devinit sh_dmae_chan_probe(struct sh_dmae_device *shdev, int id,
 	tasklet_init(&new_sh_chan->tasklet, dmae_do_tasklet,
 			(unsigned long)new_sh_chan);
 
-	/* Init the channel */
-	dmae_init(new_sh_chan);
-
 	spin_lock_init(&new_sh_chan->desc_lock);
 
 	/* Init descripter manage list */
@@ -1114,7 +1146,7 @@ static int __init sh_dmae_probe(struct platform_device *pdev)
 	list_add_tail_rcu(&shdev->node, &sh_dmae_devices);
 	spin_unlock_irq(&sh_dmae_lock);
 
-	/* reset dma controller */
+	/* reset dma controller - only needed as a test */
 	err = sh_dmae_rst(shdev);
 	if (err)
 		goto rst_err;
-- 
1.7.2.5

