Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756061Ab1KOPJY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 10:09:24 -0500
Received: from metasoft.pl ([195.149.224.191]:55237 "EHLO smtp.metasoft.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752762Ab1KOPJX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 10:09:23 -0500
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 Nov 2011 10:09:23 EST
X-clamdmail: clamdmail 0.18a
Message-ID: <4EC27EED.4030108@metasoft.pl>
Date: Tue, 15 Nov 2011 16:02:05 +0100
From: Rafal Prylowski <prylowski@metasoft.pl>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Mika Westerberg <mika.westerberg@iki.fi>
CC: linux-arm-kernel@lists.infradead.org, rmallon@gmail.com,
        vinod.koul@intel.com, broonie@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org, grant.likely@secretlab.ca,
        hsweeten@visionengravers.com, dan.j.williams@intel.com, lrg@ti.com
Subject: Re: [PATCH v2 1/5] dmaengine: add ep93xx DMA support
References: <cover.1306662317.git.mika.westerberg@iki.fi> <3ea8d56034f25cbe3fd8a4c31d7d0d1540b6ac7e.1306662317.git.mika.westerberg@iki.fi>
In-Reply-To: <3ea8d56034f25cbe3fd8a4c31d7d0d1540b6ac7e.1306662317.git.mika.westerberg@iki.fi>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

During adaptation of my experimental ep93xx ide driver to the new dmaengine api,
I discovered two issues with ep93xx dma implementation:
1) Control register is incorrectly programmed for IDE (m2m_hw_setup),
probably copy-paste bug ;)
2) Kernel oops when trying to stop running transfers by calling
dmaengine_terminate_all(...) - caused by dereferencing empty list
in ep93xx_dma_get_active

Following is a patch, which solves these problems for me.

Regards,
Rafal Prylowski

Index: linux-2.6/drivers/dma/ep93xx_dma.c
===================================================================
--- linux-2.6.orig/drivers/dma/ep93xx_dma.c
+++ linux-2.6/drivers/dma/ep93xx_dma.c
@@ -246,6 +246,7 @@ static void ep93xx_dma_set_active(struct
 static struct ep93xx_dma_desc *
 ep93xx_dma_get_active(struct ep93xx_dma_chan *edmac)
 {
+	BUG_ON(list_empty(&edmac->active));
 	return list_first_entry(&edmac->active, struct ep93xx_dma_desc, node);
 }
 
@@ -459,9 +460,6 @@ static int m2m_hw_setup(struct ep93xx_dm
 		 * This IDE part is totally untested. Values below are taken
 		 * from the EP93xx Users's Guide and might not be correct.
 		 */
-		control |= M2M_CONTROL_NO_HDSK;
-		control |= M2M_CONTROL_RSS_IDE;
-		control |= M2M_CONTROL_PW_16;
 
 		if (data->direction == DMA_TO_DEVICE) {
 			/* Worst case from the UG */
@@ -473,6 +471,9 @@ static int m2m_hw_setup(struct ep93xx_dm
 			control |= M2M_CONTROL_SAH;
 			control |= M2M_CONTROL_TM_RX;
 		}
+		control |= M2M_CONTROL_NO_HDSK;
+		control |= M2M_CONTROL_RSS_IDE;
+		control |= M2M_CONTROL_PW_16;
 		break;
 
 	default:
@@ -668,24 +669,28 @@ static void ep93xx_dma_unmap_buffers(str
 static void ep93xx_dma_tasklet(unsigned long data)
 {
 	struct ep93xx_dma_chan *edmac = (struct ep93xx_dma_chan *)data;
-	struct ep93xx_dma_desc *desc, *d;
-	dma_async_tx_callback callback;
-	void *callback_param;
+	struct ep93xx_dma_desc *desc = NULL, *d;
+	dma_async_tx_callback callback = NULL;
+	void *callback_param = NULL;
 	LIST_HEAD(list);
 
 	spin_lock_irq(&edmac->lock);
-	desc = ep93xx_dma_get_active(edmac);
-	if (desc->complete) {
-		edmac->last_completed = desc->txd.cookie;
-		list_splice_init(&edmac->active, &list);
+	if (!list_empty(&edmac->active)) {
+		desc = ep93xx_dma_get_active(edmac);
+		if (desc->complete) {
+			edmac->last_completed = desc->txd.cookie;
+			list_splice_init(&edmac->active, &list);
+		}
 	}
 	spin_unlock_irq(&edmac->lock);
 
 	/* Pick up the next descriptor from the queue */
 	ep93xx_dma_advance_work(edmac);
 
-	callback = desc->txd.callback;
-	callback_param = desc->txd.callback_param;
+	if (desc) {
+		callback = desc->txd.callback;
+		callback_param = desc->txd.callback_param;
+	}
 
 	/* Now we can release all the chained descriptors */
 	list_for_each_entry_safe(desc, d, &list, node) {
