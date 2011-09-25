Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752832Ab1IYOMY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Sep 2011 10:12:24 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:61305 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752793Ab1IYOMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Sep 2011 10:12:23 -0400
Date: Sun, 25 Sep 2011 16:12:18 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: linux-sh@vger.kernel.org
cc: Dan Williams <dan.j.williams@intel.com>, Vinod Koul <vinod.koul@intel.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] dmaengine: shdma: protect against the IRQ handler
Message-ID: <Pine.LNX.4.64.1109251609130.11831@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:HXpZH9h9atwuC9FKOfqxVdn0fIrx+viEAa5s1xASZKJ
 MMKv6sJ+ba4hqsh8n73DzEEaM0mDzbDWXjBaom9/wCQqiGXcTY
 mmVjCU7F+KBvLLqGjG9UHrLG9JgnJoxFeNQppcdnOnTbrAZZDN
 xcSG3CUTnuQ8MHnf9eqjoDtHRiaB4R2ltm7PtIqCDNAFv8cy9N
 SjI2TJWFl34zdeO4FVaqw+CR+D0hsiNHSY7JjI4skF9vkLmXGS
 R1CuGK8Qud1UyHFrB94rBT09Lfnqyl8DTuEKNY7sApzFnu7gjF
 hT6xOtNe9X55pnsqZlElsrcFKecoYpN0dSdwIO3aAsSpO4pTdR
 Dkvyfg/v+5eb7+1CU66DGuTXWLYQHIkEOFpCh0xZ6T421QEpdE
 3Ls8Ds43E2vQQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The IRQ handler of the shdma driver accesses common hardware registers,
that are also accessed from other contexts. Therefore access to them
has to be performed with interrupts disabled, not only with disabled
bottom halves.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/dma/shdma.c |   55 ++++++++++++++++++++++++++-------------------------
 1 files changed, 28 insertions(+), 27 deletions(-)

diff --git a/drivers/dma/shdma.c b/drivers/dma/shdma.c
index 7f49235..e7bb747 100644
--- a/drivers/dma/shdma.c
+++ b/drivers/dma/shdma.c
@@ -265,8 +265,9 @@ static dma_cookie_t sh_dmae_tx_submit(struct dma_async_tx_descriptor *tx)
 	struct sh_dmae_chan *sh_chan = to_sh_chan(tx->chan);
 	dma_async_tx_callback callback = tx->callback;
 	dma_cookie_t cookie;
+	unsigned long flags;
 
-	spin_lock_bh(&sh_chan->desc_lock);
+	spin_lock_irqsave(&sh_chan->desc_lock, flags);
 
 	cookie = sh_chan->common.cookie;
 	cookie++;
@@ -302,7 +303,7 @@ static dma_cookie_t sh_dmae_tx_submit(struct dma_async_tx_descriptor *tx)
 		tx->cookie, &last->async_tx, sh_chan->id,
 		desc->hw.sar, desc->hw.tcr, desc->hw.dar);
 
-	spin_unlock_bh(&sh_chan->desc_lock);
+	spin_unlock_irqrestore(&sh_chan->desc_lock, flags);
 
 	return cookie;
 }
@@ -374,24 +375,18 @@ static int sh_dmae_alloc_chan_resources(struct dma_chan *chan)
 		dmae_init(sh_chan);
 	}
 
-	spin_lock_bh(&sh_chan->desc_lock);
 	while (sh_chan->descs_allocated < NR_DESCS_PER_CHANNEL) {
-		spin_unlock_bh(&sh_chan->desc_lock);
 		desc = kzalloc(sizeof(struct sh_desc), GFP_KERNEL);
-		if (!desc) {
-			spin_lock_bh(&sh_chan->desc_lock);
+		if (!desc)
 			break;
-		}
 		dma_async_tx_descriptor_init(&desc->async_tx,
 					&sh_chan->common);
 		desc->async_tx.tx_submit = sh_dmae_tx_submit;
 		desc->mark = DESC_IDLE;
 
-		spin_lock_bh(&sh_chan->desc_lock);
 		list_add(&desc->node, &sh_chan->ld_free);
 		sh_chan->descs_allocated++;
 	}
-	spin_unlock_bh(&sh_chan->desc_lock);
 
 	if (!sh_chan->descs_allocated) {
 		ret = -ENOMEM;
@@ -405,6 +400,7 @@ edescalloc:
 		clear_bit(param->slave_id, sh_dmae_slave_used);
 etestused:
 efindslave:
+	chan->private = NULL;
 	pm_runtime_put(sh_chan->dev);
 	return ret;
 }
@@ -437,12 +433,12 @@ static void sh_dmae_free_chan_resources(struct dma_chan *chan)
 		chan->private = NULL;
 	}
 
-	spin_lock_bh(&sh_chan->desc_lock);
+	spin_lock_irq(&sh_chan->desc_lock);
 
 	list_splice_init(&sh_chan->ld_free, &list);
 	sh_chan->descs_allocated = 0;
 
-	spin_unlock_bh(&sh_chan->desc_lock);
+	spin_unlock_irq(&sh_chan->desc_lock);
 
 	if (descs > 0)
 		pm_runtime_put(sh_chan->dev);
@@ -534,6 +530,7 @@ static struct dma_async_tx_descriptor *sh_dmae_prep_sg(struct sh_dmae_chan *sh_c
 	struct sh_desc *first = NULL, *new = NULL /* compiler... */;
 	LIST_HEAD(tx_list);
 	int chunks = 0;
+	unsigned long irq_flags;
 	int i;
 
 	if (!sg_len)
@@ -544,7 +541,7 @@ static struct dma_async_tx_descriptor *sh_dmae_prep_sg(struct sh_dmae_chan *sh_c
 			(SH_DMA_TCR_MAX + 1);
 
 	/* Have to lock the whole loop to protect against concurrent release */
-	spin_lock_bh(&sh_chan->desc_lock);
+	spin_lock_irqsave(&sh_chan->desc_lock, irq_flags);
 
 	/*
 	 * Chaining:
@@ -590,7 +587,7 @@ static struct dma_async_tx_descriptor *sh_dmae_prep_sg(struct sh_dmae_chan *sh_c
 	/* Put them back on the free list, so, they don't get lost */
 	list_splice_tail(&tx_list, &sh_chan->ld_free);
 
-	spin_unlock_bh(&sh_chan->desc_lock);
+	spin_unlock_irqrestore(&sh_chan->desc_lock, irq_flags);
 
 	return &first->async_tx;
 
@@ -599,7 +596,7 @@ err_get_desc:
 		new->mark = DESC_IDLE;
 	list_splice(&tx_list, &sh_chan->ld_free);
 
-	spin_unlock_bh(&sh_chan->desc_lock);
+	spin_unlock_irqrestore(&sh_chan->desc_lock, irq_flags);
 
 	return NULL;
 }
@@ -661,6 +658,7 @@ static int sh_dmae_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
 			   unsigned long arg)
 {
 	struct sh_dmae_chan *sh_chan = to_sh_chan(chan);
+	unsigned long flags;
 
 	/* Only supports DMA_TERMINATE_ALL */
 	if (cmd != DMA_TERMINATE_ALL)
@@ -669,7 +667,7 @@ static int sh_dmae_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
 	if (!chan)
 		return -EINVAL;
 
-	spin_lock_bh(&sh_chan->desc_lock);
+	spin_lock_irqsave(&sh_chan->desc_lock, flags);
 	dmae_halt(sh_chan);
 
 	if (!list_empty(&sh_chan->ld_queue)) {
@@ -680,7 +678,7 @@ static int sh_dmae_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
 			sh_chan->xmit_shift;
 
 	}
-	spin_unlock_bh(&sh_chan->desc_lock);
+	spin_unlock_irqrestore(&sh_chan->desc_lock, flags);
 
 	sh_dmae_chan_ld_cleanup(sh_chan, true);
 
@@ -695,8 +693,9 @@ static dma_async_tx_callback __ld_cleanup(struct sh_dmae_chan *sh_chan, bool all
 	dma_cookie_t cookie = 0;
 	dma_async_tx_callback callback = NULL;
 	void *param = NULL;
+	unsigned long flags;
 
-	spin_lock_bh(&sh_chan->desc_lock);
+	spin_lock_irqsave(&sh_chan->desc_lock, flags);
 	list_for_each_entry_safe(desc, _desc, &sh_chan->ld_queue, node) {
 		struct dma_async_tx_descriptor *tx = &desc->async_tx;
 
@@ -773,7 +772,7 @@ static dma_async_tx_callback __ld_cleanup(struct sh_dmae_chan *sh_chan, bool all
 		 */
 		sh_chan->completed_cookie = sh_chan->common.cookie;
 
-	spin_unlock_bh(&sh_chan->desc_lock);
+	spin_unlock_irqrestore(&sh_chan->desc_lock, flags);
 
 	if (callback)
 		callback(param);
@@ -796,10 +795,12 @@ static void sh_chan_xfer_ld_queue(struct sh_dmae_chan *sh_chan)
 {
 	struct sh_desc *desc;
 
-	spin_lock_bh(&sh_chan->desc_lock);
+	spin_lock_irq(&sh_chan->desc_lock);
 	/* DMA work check */
-	if (dmae_is_busy(sh_chan))
-		goto sh_chan_xfer_ld_queue_end;
+	if (dmae_is_busy(sh_chan)) {
+		spin_unlock_irq(&sh_chan->desc_lock);
+		return;
+	}
 
 	/* Find the first not transferred descriptor */
 	list_for_each_entry(desc, &sh_chan->ld_queue, node)
@@ -813,8 +814,7 @@ static void sh_chan_xfer_ld_queue(struct sh_dmae_chan *sh_chan)
 			break;
 		}
 
-sh_chan_xfer_ld_queue_end:
-	spin_unlock_bh(&sh_chan->desc_lock);
+	spin_unlock_irq(&sh_chan->desc_lock);
 }
 
 static void sh_dmae_memcpy_issue_pending(struct dma_chan *chan)
@@ -831,6 +831,7 @@ static enum dma_status sh_dmae_tx_status(struct dma_chan *chan,
 	dma_cookie_t last_used;
 	dma_cookie_t last_complete;
 	enum dma_status status;
+	unsigned long flags;
 
 	sh_dmae_chan_ld_cleanup(sh_chan, false);
 
@@ -841,7 +842,7 @@ static enum dma_status sh_dmae_tx_status(struct dma_chan *chan,
 	BUG_ON(last_complete < 0);
 	dma_set_tx_state(txstate, last_complete, last_used, 0);
 
-	spin_lock_bh(&sh_chan->desc_lock);
+	spin_lock_irqsave(&sh_chan->desc_lock, flags);
 
 	status = dma_async_is_complete(cookie, last_complete, last_used);
 
@@ -859,7 +860,7 @@ static enum dma_status sh_dmae_tx_status(struct dma_chan *chan,
 			}
 	}
 
-	spin_unlock_bh(&sh_chan->desc_lock);
+	spin_unlock_irqrestore(&sh_chan->desc_lock, flags);
 
 	return status;
 }
@@ -952,7 +953,7 @@ static void dmae_do_tasklet(unsigned long data)
 	u32 sar_buf = sh_dmae_readl(sh_chan, SAR);
 	u32 dar_buf = sh_dmae_readl(sh_chan, DAR);
 
-	spin_lock(&sh_chan->desc_lock);
+	spin_lock_irq(&sh_chan->desc_lock);
 	list_for_each_entry(desc, &sh_chan->ld_queue, node) {
 		if (desc->mark == DESC_SUBMITTED &&
 		    ((desc->direction == DMA_FROM_DEVICE &&
@@ -965,7 +966,7 @@ static void dmae_do_tasklet(unsigned long data)
 			break;
 		}
 	}
-	spin_unlock(&sh_chan->desc_lock);
+	spin_unlock_irq(&sh_chan->desc_lock);
 
 	/* Next desc */
 	sh_chan_xfer_ld_queue(sh_chan);
-- 
1.7.2.5

