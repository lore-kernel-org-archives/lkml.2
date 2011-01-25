Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753566Ab1AYKVD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 05:21:03 -0500
Received: from eu1sys200aog102.obsmtp.com ([207.126.144.113]:53214 "EHLO
	eu1sys200aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753187Ab1AYKUA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 05:20:00 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: <linux-kernel@vger.kernel.org>, Lee Jones <lee.jones@linaro.org>,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH 31/32] dma40: stop ongoing transfers in DMA_TERMINATE_ALL
Date: Tue, 25 Jan 2011 11:18:34 +0100
Message-ID: <1295950715-22340-32-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1295950715-22340-1-git-send-email-linus.walleij@stericsson.com>
References: <1295950715-22340-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rabin Vincent <rabin.vincent@stericsson.com>

The current implementation of DMA_TERMINATE_ALL leaves ongoing transfers
running.  Fix it.

Acked-by: Per Forlin <per.forlin@stericsson.com>
Acked-by: Jonas Aaberg <jonas.aberg@stericsson.com>
Signed-off-by: Rabin Vincent <rabin.vincent@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
 drivers/dma/ste_dma40.c |   34 +++++++++++++++++++++-------------
 1 files changed, 21 insertions(+), 13 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 929fd8f..8fd0bb9 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -918,10 +918,8 @@ static bool d40_tx_is_linked(struct d40_chan *d40c)
 	return is_link;
 }
 
-static int d40_pause(struct dma_chan *chan)
+static int d40_pause(struct d40_chan *d40c)
 {
-	struct d40_chan *d40c =
-		container_of(chan, struct d40_chan, chan);
 	int res = 0;
 	unsigned long flags;
 
@@ -945,10 +943,8 @@ static int d40_pause(struct dma_chan *chan)
 	return res;
 }
 
-static int d40_resume(struct dma_chan *chan)
+static int d40_resume(struct d40_chan *d40c)
 {
-	struct d40_chan *d40c =
-		container_of(chan, struct d40_chan, chan);
 	int res = 0;
 	unsigned long flags;
 
@@ -978,6 +974,22 @@ no_suspend:
 	return res;
 }
 
+static int d40_terminate_all(struct d40_chan *chan)
+{
+	unsigned long flags;
+	int ret = 0;
+
+	ret = d40_pause(chan);
+	if (!ret && chan_is_physical(chan))
+		ret = d40_channel_execute_command(chan, D40_DMA_STOP);
+
+	spin_lock_irqsave(&chan->lock, flags);
+	d40_term_all(chan);
+	spin_unlock_irqrestore(&chan->lock, flags);
+
+	return ret;
+}
+
 static dma_cookie_t d40_tx_submit(struct dma_async_tx_descriptor *tx)
 {
 	struct d40_chan *d40c = container_of(tx->chan,
@@ -2176,7 +2188,6 @@ static void d40_set_runtime_config(struct dma_chan *chan,
 static int d40_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
 		       unsigned long arg)
 {
-	unsigned long flags;
 	struct d40_chan *d40c = container_of(chan, struct d40_chan, chan);
 
 	if (d40c->phy_chan == NULL) {
@@ -2186,14 +2197,11 @@ static int d40_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
 
 	switch (cmd) {
 	case DMA_TERMINATE_ALL:
-		spin_lock_irqsave(&d40c->lock, flags);
-		d40_term_all(d40c);
-		spin_unlock_irqrestore(&d40c->lock, flags);
-		return 0;
+		return d40_terminate_all(d40c);
 	case DMA_PAUSE:
-		return d40_pause(chan);
+		return d40_pause(d40c);
 	case DMA_RESUME:
-		return d40_resume(chan);
+		return d40_resume(d40c);
 	case DMA_SLAVE_CONFIG:
 		d40_set_runtime_config(chan,
 			(struct dma_slave_config *) arg);
-- 
1.7.3.2

