Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753411Ab1H2Le2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 07:34:28 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:58436 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752914Ab1H2LeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 07:34:17 -0400
From: Per Forlin <per.forlin@linaro.org>
To: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Rabin Vincent <rabin.vincent@stericsson.com>
Cc: Vinod Koul <vinod.koul@intel.com>, linaro-dev@lists.linaro.org,
        Per Forlin <per.forlin@linaro.org>
Subject: [PATCH 4/4] dmaengine/ste_dma40: fix memory leak due to prepared descriptors
Date: Mon, 29 Aug 2011 13:33:35 +0200
Message-Id: <1314617615-2394-5-git-send-email-per.forlin@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314617615-2394-1-git-send-email-per.forlin@linaro.org>
References: <1314617615-2394-1-git-send-email-per.forlin@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prepared descriptors that are not submitted will not be freed. Add
prepared descriptor to a list to be able to release them upon
dmaengine_terminate_all().

Signed-off-by: Per Forlin <per.forlin@linaro.org>
---
 drivers/dma/ste_dma40.c |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 92ec0a2..467e4dc 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -177,6 +177,7 @@ struct d40_base;
  * @pending_queue: Submitted jobs, to be issued by issue_pending()
  * @active: Active descriptor.
  * @queue: Queued jobs.
+ * @prepare_queue: Prepared jobs.
  * @dma_cfg: The client configuration of this dma channel.
  * @configured: whether the dma_cfg configuration is valid
  * @base: Pointer to the device instance struct.
@@ -204,6 +205,7 @@ struct d40_chan {
 	struct list_head		 pending_queue;
 	struct list_head		 active;
 	struct list_head		 queue;
+	struct list_head		 prepare_queue;
 	struct stedma40_chan_cfg	 dma_cfg;
 	bool				 configured;
 	struct d40_base			*base;
@@ -833,6 +835,13 @@ static void d40_term_all(struct d40_chan *d40c)
 			d40_desc_free(d40c, d40d);
 		}
 
+	/* Release descriptors in prepare queue */
+	if (!list_empty(&d40c->prepare_queue))
+		list_for_each_entry_safe(d40d, _d,
+					 &d40c->prepare_queue, node) {
+			d40_desc_remove(d40d);
+			d40_desc_free(d40c, d40d);
+		}
 
 	d40c->pending_tx = 0;
 	d40c->busy = false;
@@ -1911,6 +1920,12 @@ d40_prep_sg(struct dma_chan *dchan, struct scatterlist *sg_src,
 		goto err;
 	}
 
+	/*
+	 * add descriptor to the prepare queue in order to be able
+	 * to free them later in terminate_all
+	 */
+	list_add_tail(&desc->node, &chan->prepare_queue);
+
 	spin_unlock_irqrestore(&chan->lock, flags);
 
 	return &desc->txd;
@@ -2400,6 +2415,7 @@ static void __init d40_chan_init(struct d40_base *base, struct dma_device *dma,
 		INIT_LIST_HEAD(&d40c->queue);
 		INIT_LIST_HEAD(&d40c->pending_queue);
 		INIT_LIST_HEAD(&d40c->client);
+		INIT_LIST_HEAD(&d40c->prepare_queue);
 
 		tasklet_init(&d40c->tasklet, dma_tasklet,
 			     (unsigned long) d40c);
-- 
1.7.4.1

