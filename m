Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756455Ab0FAMV3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 08:21:29 -0400
Received: from eu1sys200aog116.obsmtp.com ([207.126.144.141]:44178 "EHLO
	eu1sys200aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756271Ab0FAMV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 08:21:27 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: <linux-kernel@vger.kernel.org>, Jonas Aaberg <jonas.aberg@stericsson.com>,
       Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH 07/18] DMAENGINE: ste_dma40: deny ops on non-alloc channels
Date: Tue, 1 Jun 2010 14:21:18 +0200
Message-ID: <1275394878-26398-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.6.3.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonas Aaberg <jonas.aberg@stericsson.com>

Added checks to deny operating on none-allocated channels.

Signed-off-by: Jonas Aaberg <jonas.aberg@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
 drivers/dma/ste_dma40.c |   44 ++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 44 insertions(+), 0 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index c1a4077..aba86bb 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -1545,6 +1545,12 @@ struct dma_async_tx_descriptor *stedma40_memcpy_sg(struct dma_chan *chan,
 					     chan);
 	unsigned long flags;
 
+	if (d40c->phy_chan == NULL) {
+		dev_err(&d40c->chan.dev->device,
+			"[%s] Unallocated channel.\n", __func__);
+		return ERR_PTR(-EINVAL);
+	}
+
 	spin_lock_irqsave(&d40c->lock, flags);
 	d40d = d40_desc_get(d40c);
 
@@ -1716,6 +1722,13 @@ static void d40_free_chan_resources(struct dma_chan *chan)
 	int err;
 	unsigned long flags;
 
+	if (d40c->phy_chan == NULL) {
+		dev_err(&d40c->chan.dev->device,
+			"[%s] Cannot free unallocated channel\n", __func__);
+		return;
+	}
+
+
 	spin_lock_irqsave(&d40c->lock, flags);
 
 	err = d40_free_dma(d40c);
@@ -1738,6 +1751,12 @@ static struct dma_async_tx_descriptor *d40_prep_memcpy(struct dma_chan *chan,
 	unsigned long flags;
 	int err = 0;
 
+	if (d40c->phy_chan == NULL) {
+		dev_err(&d40c->chan.dev->device,
+			"[%s] Channel is not allocated.\n", __func__);
+		return ERR_PTR(-EINVAL);
+	}
+
 	spin_lock_irqsave(&d40c->lock, flags);
 	d40d = d40_desc_get(d40c);
 
@@ -1953,6 +1972,12 @@ static struct dma_async_tx_descriptor *d40_prep_slave_sg(struct dma_chan *chan,
 	unsigned long flags;
 	int err;
 
+	if (d40c->phy_chan == NULL) {
+		dev_err(&d40c->chan.dev->device,
+			"[%s] Cannot prepare unallocated channel\n", __func__);
+		return ERR_PTR(-EINVAL);
+	}
+
 	if (d40c->dma_cfg.pre_transfer)
 		d40c->dma_cfg.pre_transfer(chan,
 					   d40c->dma_cfg.pre_transfer_data,
@@ -1999,6 +2024,13 @@ static enum dma_status d40_tx_status(struct dma_chan *chan,
 	dma_cookie_t last_complete;
 	int ret;
 
+	if (d40c->phy_chan == NULL) {
+		dev_err(&d40c->chan.dev->device,
+			"[%s] Cannot read status of unallocated channel\n",
+			__func__);
+		return -EINVAL;
+	}
+
 	last_complete = d40c->completed;
 	last_used = chan->cookie;
 
@@ -2018,6 +2050,12 @@ static void d40_issue_pending(struct dma_chan *chan)
 	struct d40_chan *d40c = container_of(chan, struct d40_chan, chan);
 	unsigned long flags;
 
+	if (d40c->phy_chan == NULL) {
+		dev_err(&d40c->chan.dev->device,
+			"[%s] Channel is not allocated!\n", __func__);
+		return;
+	}
+
 	spin_lock_irqsave(&d40c->lock, flags);
 
 	/* Busy means that pending jobs are already being processed */
@@ -2033,6 +2071,12 @@ static int d40_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
 	unsigned long flags;
 	struct d40_chan *d40c = container_of(chan, struct d40_chan, chan);
 
+	if (d40c->phy_chan == NULL) {
+		dev_err(&d40c->chan.dev->device,
+			"[%s] Channel is not allocated!\n", __func__);
+		return -EINVAL;
+	}
+
 	switch (cmd) {
 	case DMA_TERMINATE_ALL:
 		spin_lock_irqsave(&d40c->lock, flags);
-- 
1.6.3.3

