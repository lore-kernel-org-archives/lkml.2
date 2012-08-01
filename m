Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753965Ab2HAJPh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 05:15:37 -0400
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:30842
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753534Ab2HAJPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 05:15:17 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzz8275bhz2dh2a8h668h839hd24he5bhf0ah107ah)
From: <qiang.liu@freescale.com>
To: <linux-crypto@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>, <dan.j.williams@gmail.com>
CC: <kim.phillips@freescale.com>, <herbert@gondor.hengli.com.au>,
        <davem@davemloft.net>, Qiang Liu <qiang.liu@freescale.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>, Li Yang <leoli@freescale.com>,
        Timur Tabi <timur@freescale.com>
Subject: [PATCH v5 5/6] fsl-dma: use spin_lock_bh to instead of spin_lock_irqsave
Date: Wed, 1 Aug 2012 16:50:09 +0800
Message-ID: <1343811009-25466-1-git-send-email-qiang.liu@freescale.com>
X-Mailer: git-send-email 1.7.5.1
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Qiang Liu <qiang.liu@freescale.com>

- use spin_lock_bh() is the right way to use async_tx api,
dma_run_dependencies() should not be protected by spin_lock_irqsave();
- use spin_lock_bh to instead of spin_lock_irqsave for improving performance,
There is not any place to access descriptor queues in fsl-dma ISR except its
tasklet, spin_lock_bh() is more proper here. Interrupts will be turned off and
context will be save in irqsave, there is needless to use irqsave..

Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>
Cc: Li Yang <leoli@freescale.com>
Cc: Timur Tabi <timur@freescale.com>
Signed-off-by: Qiang Liu <qiang.liu@freescale.com>
---
 drivers/dma/fsldma.c |   30 ++++++++++++------------------
 1 files changed, 12 insertions(+), 18 deletions(-)

diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
index bb883c0..e3814aa 100644
--- a/drivers/dma/fsldma.c
+++ b/drivers/dma/fsldma.c
@@ -645,10 +645,9 @@ static dma_cookie_t fsl_dma_tx_submit(struct dma_async_tx_descriptor *tx)
 	struct fsldma_chan *chan = to_fsl_chan(tx->chan);
 	struct fsl_desc_sw *desc = tx_to_fsl_desc(tx);
 	struct fsl_desc_sw *child;
-	unsigned long flags;
 	dma_cookie_t cookie;

-	spin_lock_irqsave(&chan->desc_lock, flags);
+	spin_lock_bh(&chan->desc_lock);

 	/*
 	 * assign cookies to all of the software descriptors
@@ -661,7 +660,7 @@ static dma_cookie_t fsl_dma_tx_submit(struct dma_async_tx_descriptor *tx)
 	/* put this transaction onto the tail of the pending queue */
 	append_ld_queue(chan, desc);

-	spin_unlock_irqrestore(&chan->desc_lock, flags);
+	spin_unlock_bh(&chan->desc_lock);

 	return cookie;
 }
@@ -770,15 +769,14 @@ static void fsldma_free_desc_list_reverse(struct fsldma_chan *chan,
 static void fsl_dma_free_chan_resources(struct dma_chan *dchan)
 {
 	struct fsldma_chan *chan = to_fsl_chan(dchan);
-	unsigned long flags;

 	chan_dbg(chan, "free all channel resources\n");
-	spin_lock_irqsave(&chan->desc_lock, flags);
+	spin_lock_bh(&chan->desc_lock);
 	fsldma_cleanup_descriptor(chan);
 	fsldma_free_desc_list(chan, &chan->ld_pending);
 	fsldma_free_desc_list(chan, &chan->ld_running);
 	fsldma_free_desc_list(chan, &chan->ld_completed);
-	spin_unlock_irqrestore(&chan->desc_lock, flags);
+	spin_unlock_bh(&chan->desc_lock);

 	dma_pool_destroy(chan->desc_pool);
 	chan->desc_pool = NULL;
@@ -997,7 +995,6 @@ static int fsl_dma_device_control(struct dma_chan *dchan,
 {
 	struct dma_slave_config *config;
 	struct fsldma_chan *chan;
-	unsigned long flags;
 	int size;

 	if (!dchan)
@@ -1007,7 +1004,7 @@ static int fsl_dma_device_control(struct dma_chan *dchan,

 	switch (cmd) {
 	case DMA_TERMINATE_ALL:
-		spin_lock_irqsave(&chan->desc_lock, flags);
+		spin_lock_bh(&chan->desc_lock);

 		/* Halt the DMA engine */
 		dma_halt(chan);
@@ -1017,7 +1014,7 @@ static int fsl_dma_device_control(struct dma_chan *dchan,
 		fsldma_free_desc_list(chan, &chan->ld_running);
 		chan->idle = true;

-		spin_unlock_irqrestore(&chan->desc_lock, flags);
+		spin_unlock_bh(&chan->desc_lock);
 		return 0;

 	case DMA_SLAVE_CONFIG:
@@ -1059,11 +1056,10 @@ static int fsl_dma_device_control(struct dma_chan *dchan,
 static void fsl_dma_memcpy_issue_pending(struct dma_chan *dchan)
 {
 	struct fsldma_chan *chan = to_fsl_chan(dchan);
-	unsigned long flags;

-	spin_lock_irqsave(&chan->desc_lock, flags);
+	spin_lock_bh(&chan->desc_lock);
 	fsl_chan_xfer_ld_queue(chan);
-	spin_unlock_irqrestore(&chan->desc_lock, flags);
+	spin_unlock_bh(&chan->desc_lock);
 }

 /**
@@ -1076,15 +1072,14 @@ static enum dma_status fsl_tx_status(struct dma_chan *dchan,
 {
 	struct fsldma_chan *chan = to_fsl_chan(dchan);
 	enum dma_status ret;
-	unsigned long flags;

 	ret = dma_cookie_status(dchan, cookie, txstate);
 	if (ret == DMA_SUCCESS)
 		return ret;

-	spin_lock_irqsave(&chan->desc_lock, flags);
+	spin_lock_bh(&chan->desc_lock);
 	fsldma_cleanup_descriptor(chan);
-	spin_unlock_irqrestore(&chan->desc_lock, flags);
+	spin_unlock_bh(&chan->desc_lock);

 	return dma_cookie_status(dchan, cookie, txstate);
 }
@@ -1163,11 +1158,10 @@ static irqreturn_t fsldma_chan_irq(int irq, void *data)
 static void dma_do_tasklet(unsigned long data)
 {
 	struct fsldma_chan *chan = (struct fsldma_chan *)data;
-	unsigned long flags;

 	chan_dbg(chan, "tasklet entry\n");

-	spin_lock_irqsave(&chan->desc_lock, flags);
+	spin_lock_bh(&chan->desc_lock);

 	/* the hardware is now idle and ready for more */
 	chan->idle = true;
@@ -1175,7 +1169,7 @@ static void dma_do_tasklet(unsigned long data)
 	/* Run all cleanup for this descriptor */
 	fsldma_cleanup_descriptor(chan);

-	spin_unlock_irqrestore(&chan->desc_lock, flags);
+	spin_unlock_bh(&chan->desc_lock);

 	chan_dbg(chan, "tasklet exit\n");
 }
--
1.7.5.1


