Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754973Ab1KVGrl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 01:47:41 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52496 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752975Ab1KVGrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 01:47:40 -0500
Date: Tue, 22 Nov 2011 08:47:27 +0200
From: Mika Westerberg <mika.westerberg@iki.fi>
To: Rafal Prylowski <prylowski@metasoft.pl>
Cc: linux-arm-kernel@lists.infradead.org, rmallon@gmail.com,
        vinod.koul@intel.com, broonie@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org, grant.likely@secretlab.ca,
        hsweeten@visionengravers.com, dan.j.williams@intel.com, lrg@ti.com
Subject: Re: [PATCH v2 1/5] dmaengine: add ep93xx DMA support
Message-ID: <20111122064727.GB15889@mwesterb-mobl.ger.corp.intel.com>
References: <cover.1306662317.git.mika.westerberg@iki.fi>
 <3ea8d56034f25cbe3fd8a4c31d7d0d1540b6ac7e.1306662317.git.mika.westerberg@iki.fi>
 <4EC27EED.4030108@metasoft.pl>
 <20111116065512.GB2703@mwesterb-mobl.ger.corp.intel.com>
 <4EC374F0.8000400@metasoft.pl>
 <20111119123837.GA2711@mwesterb-mobl.ger.corp.intel.com>
 <4ECA0147.4020806@metasoft.pl>
 <20111121080158.GA2713@mwesterb-mobl.ger.corp.intel.com>
 <4ECA11C5.802@metasoft.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ECA11C5.802@metasoft.pl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 21, 2011 at 09:54:29AM +0100, Rafal Prylowski wrote:
> 
> This patch works partially for me. Drive is detected correctly, I can do simple test with
> hdparm, mount partitions, create file with 'touch' command, but when trying to fill
> partition with data I get:
> 
> # dd if=/dev/zero of=/mnt/b/zero4 bs=4M
> Internal error: Oops - undefined instruction: 0 [#1]

Right. It still should call ep93xx_dma_advance_work(). Like the patch below.

Let me know if this works for you. Basically it's the patch from you except
that we use a flag to indicate if the channel is running or not.

I would like to keep it this way (given that it solves the crash you are
seeing, that is) to make sure that we can expect that the active list is never
empty when the channel is operating.

diff --git a/drivers/dma/ep93xx_dma.c b/drivers/dma/ep93xx_dma.c
index 6181811..2670005 100644
--- a/drivers/dma/ep93xx_dma.c
+++ b/drivers/dma/ep93xx_dma.c
@@ -155,6 +155,8 @@ struct ep93xx_dma_chan {
 	unsigned long			flags;
 /* Channel is configured for cyclic transfers */
 #define EP93XX_DMA_IS_CYCLIC		0
+/* Channel is enabled */
+#define EP93XX_DMA_IS_RUNNING		1
 
 	int				buffer;
 	dma_cookie_t			last_completed;
@@ -669,24 +671,25 @@ static void ep93xx_dma_tasklet(unsigned long data)
 {
 	struct ep93xx_dma_chan *edmac = (struct ep93xx_dma_chan *)data;
 	struct ep93xx_dma_desc *desc, *d;
-	dma_async_tx_callback callback;
-	void *callback_param;
+	dma_async_tx_callback callback = NULL;
+	void *callback_param = NULL;
 	LIST_HEAD(list);
 
 	spin_lock_irq(&edmac->lock);
-	desc = ep93xx_dma_get_active(edmac);
-	if (desc->complete) {
-		edmac->last_completed = desc->txd.cookie;
-		list_splice_init(&edmac->active, &list);
+	if (test_bit(EP93XX_DMA_IS_RUNNING, &edmac->flags)) {
+		desc = ep93xx_dma_get_active(edmac);
+		if (desc->complete) {
+			edmac->last_completed = desc->txd.cookie;
+			list_splice_init(&edmac->active, &list);
+		}
+		callback = desc->txd.callback;
+		callback_param = desc->txd.callback_param;
 	}
 	spin_unlock_irq(&edmac->lock);
 
 	/* Pick up the next descriptor from the queue */
 	ep93xx_dma_advance_work(edmac);
 
-	callback = desc->txd.callback;
-	callback_param = desc->txd.callback_param;
-
 	/* Now we can release all the chained descriptors */
 	list_for_each_entry_safe(desc, d, &list, node) {
 		/*
@@ -758,6 +761,8 @@ static dma_cookie_t ep93xx_dma_tx_submit(struct dma_async_tx_descriptor *tx)
 	edmac->chan.cookie = cookie;
 	desc->txd.cookie = cookie;
 
+	set_bit(EP93XX_DMA_IS_RUNNING, &edmac->flags);
+
 	/*
 	 * If nothing is currently prosessed, we push this descriptor
 	 * directly to the hardware. Otherwise we put the descriptor
@@ -1106,6 +1111,7 @@ static int ep93xx_dma_terminate_all(struct ep93xx_dma_chan *edmac)
 	spin_lock_irqsave(&edmac->lock, flags);
 	/* First we disable and flush the DMA channel */
 	edmac->edma->hw_shutdown(edmac);
+	clear_bit(EP93XX_DMA_IS_RUNNING, &edmac->flags);
 	clear_bit(EP93XX_DMA_IS_CYCLIC, &edmac->flags);
 	list_splice_init(&edmac->active, &list);
 	list_splice_init(&edmac->queue, &list);
