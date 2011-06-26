Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754665Ab1FZVdQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jun 2011 17:33:16 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:41610 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753734Ab1FZVcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jun 2011 17:32:13 -0400
From: Per Forlin <per.forlin@linaro.org>
To: linux-kernel@vger.kernel.org, Rabin Vincent <rabin.vincent@stericsson.com>
Cc: Vinod Koul <vinod.koul@intel.com>, Per Forlin <per.forlin@linaro.org>
Subject: [PATCH 1/2] dmaengine/ste_dma40: add a separate queue for pending requests
Date: Sun, 26 Jun 2011 23:29:52 +0200
Message-Id: <1309123793-7806-2-git-send-email-per.forlin@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1309123793-7806-1-git-send-email-per.forlin@linaro.org>
References: <1309123793-7806-1-git-send-email-per.forlin@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tx_submit will add descriptors to the pending queue. Issue pending
will then move the pending descriptors to the transfer queue.

Signed-off-by: Per Forlin <per.forlin@linaro.org>
---
 drivers/dma/ste_dma40.c |   26 ++++++++++++++++++++++++--
 1 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 8f222d4..91d5ed7 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -199,6 +199,7 @@ struct d40_chan {
 	struct dma_chan			 chan;
 	struct tasklet_struct		 tasklet;
 	struct list_head		 client;
+	struct list_head		 pending_queue;
 	struct list_head		 active;
 	struct list_head		 queue;
 	struct stedma40_chan_cfg	 dma_cfg;
@@ -644,7 +645,20 @@ static struct d40_desc *d40_first_active_get(struct d40_chan *d40c)
 
 static void d40_desc_queue(struct d40_chan *d40c, struct d40_desc *desc)
 {
-	list_add_tail(&desc->node, &d40c->queue);
+	list_add_tail(&desc->node, &d40c->pending_queue);
+}
+
+static struct d40_desc *d40_first_pending(struct d40_chan *d40c)
+{
+	struct d40_desc *d;
+
+	if (list_empty(&d40c->pending_queue))
+		return NULL;
+
+	d = list_first_entry(&d40c->pending_queue,
+			     struct d40_desc,
+			     node);
+	return d;
 }
 
 static struct d40_desc *d40_first_queued(struct d40_chan *d40c)
@@ -801,6 +815,11 @@ static void d40_term_all(struct d40_chan *d40c)
 		d40_desc_free(d40c, d40d);
 	}
 
+	/* Release pending descriptors */
+	while ((d40d = d40_first_pending(d40c))) {
+		d40_desc_remove(d40d);
+		d40_desc_free(d40c, d40d);
+	}
 
 	d40c->pending_tx = 0;
 	d40c->busy = false;
@@ -2151,7 +2170,9 @@ static void d40_issue_pending(struct dma_chan *chan)
 
 	spin_lock_irqsave(&d40c->lock, flags);
 
-	/* Busy means that pending jobs are already being processed */
+	list_splice_tail_init(&d40c->pending_queue, &d40c->queue);
+
+	/* Busy means that queued jobs are already being processed */
 	if (!d40c->busy)
 		(void) d40_queue_start(d40c);
 
@@ -2340,6 +2361,7 @@ static void __init d40_chan_init(struct d40_base *base, struct dma_device *dma,
 
 		INIT_LIST_HEAD(&d40c->active);
 		INIT_LIST_HEAD(&d40c->queue);
+		INIT_LIST_HEAD(&d40c->pending_queue);
 		INIT_LIST_HEAD(&d40c->client);
 
 		tasklet_init(&d40c->tasklet, dma_tasklet,
-- 
1.7.4.1

