Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754422Ab3AGLYw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 06:24:52 -0500
Received: from mail-we0-f178.google.com ([74.125.82.178]:62369 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753953Ab3AGLYt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 06:24:49 -0500
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Dan Williams <djbw@fb.com>, Linus Walleij <linus.walleij@linaro.org>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Fabio Baltieri <fabio.baltieri@linaro.org>,
        Rabin Vincent <rabin.vincent@stericsson.com>
Subject: [PATCH 10/16] dmaengine: ste_dma40: add a done queue for completed descriptors
Date: Mon,  7 Jan 2013 12:21:52 +0100
Message-Id: <1357557718-15676-11-git-send-email-fabio.baltieri@linaro.org>
X-Mailer: git-send-email 1.7.12.1
In-Reply-To: <1357557718-15676-1-git-send-email-fabio.baltieri@linaro.org>
References: <1357557718-15676-1-git-send-email-fabio.baltieri@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is to keep the active queue for only those transfers which are
actually active in the hardware.  Descriptors will be moved to the done
queue after they are completed in the hardware (interrupt handler) but
before all the cleanup work has been completed (tasklet).

Mostly based on a previous patch by Rabin Vincent.

Cc: Rabin Vincent <rabin.vincent@stericsson.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
---
 drivers/dma/ste_dma40.c | 37 +++++++++++++++++++++++++++++++++----
 1 file changed, 33 insertions(+), 4 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 67e565b..ff21dcb 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -382,6 +382,7 @@ struct d40_base;
  * @client: Cliented owned descriptor list.
  * @pending_queue: Submitted jobs, to be issued by issue_pending()
  * @active: Active descriptor.
+ * @done: Completed jobs
  * @queue: Queued jobs.
  * @prepare_queue: Prepared jobs.
  * @dma_cfg: The client configuration of this dma channel.
@@ -407,6 +408,7 @@ struct d40_chan {
 	struct list_head		 client;
 	struct list_head		 pending_queue;
 	struct list_head		 active;
+	struct list_head		 done;
 	struct list_head		 queue;
 	struct list_head		 prepare_queue;
 	struct stedma40_chan_cfg	 dma_cfg;
@@ -754,6 +756,11 @@ static void d40_phy_lli_load(struct d40_chan *chan, struct d40_desc *desc)
 	writel(lli_dst->reg_lnk, base + D40_CHAN_REG_SDLNK);
 }
 
+static void d40_desc_done(struct d40_chan *d40c, struct d40_desc *desc)
+{
+	list_add_tail(&desc->node, &d40c->done);
+}
+
 static void d40_log_lli_to_lcxa(struct d40_chan *chan, struct d40_desc *desc)
 {
 	struct d40_lcla_pool *pool = &chan->base->lcla_pool;
@@ -914,6 +921,14 @@ static struct d40_desc *d40_first_queued(struct d40_chan *d40c)
 	return d;
 }
 
+static struct d40_desc *d40_first_done(struct d40_chan *d40c)
+{
+	if (list_empty(&d40c->done))
+		return NULL;
+
+	return list_first_entry(&d40c->done, struct d40_desc, node);
+}
+
 static int d40_psize_2_burst_size(bool is_log, int psize)
 {
 	if (is_log) {
@@ -1104,6 +1119,12 @@ static void d40_term_all(struct d40_chan *d40c)
 	struct d40_desc *d40d;
 	struct d40_desc *_d;
 
+	/* Release completed descriptors */
+	while ((d40d = d40_first_done(d40c))) {
+		d40_desc_remove(d40d);
+		d40_desc_free(d40c, d40d);
+	}
+
 	/* Release active descriptors */
 	while ((d40d = d40_first_active_get(d40c))) {
 		d40_desc_remove(d40d);
@@ -1541,6 +1562,9 @@ static void dma_tc_handle(struct d40_chan *d40c)
 		pm_runtime_put_autosuspend(d40c->base->dev);
 	}
 
+	d40_desc_remove(d40d);
+	d40_desc_done(d40c, d40d);
+
 	d40c->pending_tx++;
 	tasklet_schedule(&d40c->tasklet);
 
@@ -1556,10 +1580,14 @@ static void dma_tasklet(unsigned long data)
 
 	spin_lock_irqsave(&d40c->lock, flags);
 
-	/* Get first active entry from list */
-	d40d = d40_first_active_get(d40c);
-	if (d40d == NULL)
-		goto err;
+	/* Get first entry from the done list */
+	d40d = d40_first_done(d40c);
+	if (d40d == NULL) {
+		/* Check if we have reached here for cyclic job */
+		d40d = d40_first_active_get(d40c);
+		if (d40d == NULL || !d40d->cyclic)
+			goto err;
+	}
 
 	if (!d40d->cyclic)
 		dma_cookie_complete(&d40d->txd);
@@ -2823,6 +2851,7 @@ static void __init d40_chan_init(struct d40_base *base, struct dma_device *dma,
 
 		d40c->log_num = D40_PHY_CHAN;
 
+		INIT_LIST_HEAD(&d40c->done);
 		INIT_LIST_HEAD(&d40c->active);
 		INIT_LIST_HEAD(&d40c->queue);
 		INIT_LIST_HEAD(&d40c->pending_queue);
-- 
1.7.12.1

