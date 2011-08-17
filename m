Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752073Ab1HQJEU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 05:04:20 -0400
Received: from eu1sys200aog120.obsmtp.com ([207.126.144.149]:37811 "EHLO
	eu1sys200aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751419Ab1HQJES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 05:04:18 -0400
From: Per Forlin <per.forlin@stericsson.com>
To: Felipe Balbi <balbi@ti.com>,
        Mian Yousaf KAUKAB <mian.yousaf.kaukab@stericsson.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Cc: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linaro-dev@lists.linaro.org>, Per Forlin <per.forlin@linaro.org>
Subject: [PATCH v3] usb: musb: ux500: optimize DMA callback routine
Date: Wed, 17 Aug 2011 11:03:40 +0200
Message-ID: <1313571820-5777-1-git-send-email-per.forlin@stericsson.com>
X-Mailer: git-send-email 1.6.3.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Per Forlin <per.forlin@linaro.org>

Skip the use of work queue and call musb_dma_completion() directly from
DMA callback context.

Here follows measurements on a Snowball board with ondemand governor active.

Performance using work queue:
(105 MB) copied, 6.23758 s, 16.8 MB/s
(105 MB) copied, 5.7151 s, 18.3 MB/s
(105 MB) copied, 5.83583 s, 18.0 MB/s
(105 MB) copied, 5.93611 s, 17.7 MB/s

Performance without work queue
(105 MB) copied, 5.62173 s, 18.7 MB/s
(105 MB) copied, 5.61811 s, 18.7 MB/s
(105 MB) copied, 5.57817 s, 18.8 MB/s
(105 MB) copied, 5.58549 s, 18.8 MB/s

Signed-off-by: Per Forlin <per.forlin@linaro.org>
Acked-by: Mian Yousaf Kaukab <mian.yousaf.kaukab@stericsson.com>
---
Change log.
v2: remove cast for void pointer
v3: rebase patch on top of a pure 3.1-rc1

 drivers/usb/musb/ux500_dma.c |   38 +++-----------------------------------
 1 files changed, 3 insertions(+), 35 deletions(-)

diff --git a/drivers/usb/musb/ux500_dma.c b/drivers/usb/musb/ux500_dma.c
index cecace4..6f10bba 100644
--- a/drivers/usb/musb/ux500_dma.c
+++ b/drivers/usb/musb/ux500_dma.c
@@ -37,7 +37,6 @@ struct ux500_dma_channel {
 	struct dma_channel channel;
 	struct ux500_dma_controller *controller;
 	struct musb_hw_ep *hw_ep;
-	struct work_struct channel_work;
 	struct dma_chan *dma_chan;
 	unsigned int cur_len;
 	dma_cookie_t cookie;
@@ -56,30 +55,11 @@ struct ux500_dma_controller {
 	dma_addr_t phy_base;
 };
 
-/* Work function invoked from DMA callback to handle tx transfers. */
-static void ux500_tx_work(struct work_struct *data)
-{
-	struct ux500_dma_channel *ux500_channel = container_of(data,
-		struct ux500_dma_channel, channel_work);
-	struct musb_hw_ep       *hw_ep = ux500_channel->hw_ep;
-	struct musb *musb = hw_ep->musb;
-	unsigned long flags;
-
-	DBG(4, "DMA tx transfer done on hw_ep=%d\n", hw_ep->epnum);
-
-	spin_lock_irqsave(&musb->lock, flags);
-	ux500_channel->channel.actual_len = ux500_channel->cur_len;
-	ux500_channel->channel.status = MUSB_DMA_STATUS_FREE;
-	musb_dma_completion(musb, hw_ep->epnum,
-				ux500_channel->is_tx);
-	spin_unlock_irqrestore(&musb->lock, flags);
-}
-
 /* Work function invoked from DMA callback to handle rx transfers. */
-static void ux500_rx_work(struct work_struct *data)
+void ux500_dma_callback(void *private_data)
 {
-	struct ux500_dma_channel *ux500_channel = container_of(data,
-		struct ux500_dma_channel, channel_work);
+	struct dma_channel *channel = private_data;
+	struct ux500_dma_channel *ux500_channel = channel->private_data;
 	struct musb_hw_ep       *hw_ep = ux500_channel->hw_ep;
 	struct musb *musb = hw_ep->musb;
 	unsigned long flags;
@@ -92,14 +72,7 @@ static void ux500_rx_work(struct work_struct *data)
 	musb_dma_completion(musb, hw_ep->epnum,
 		ux500_channel->is_tx);
 	spin_unlock_irqrestore(&musb->lock, flags);
-}
-
-void ux500_dma_callback(void *private_data)
-{
-	struct dma_channel *channel = (struct dma_channel *)private_data;
-	struct ux500_dma_channel *ux500_channel = channel->private_data;
 
-	schedule_work(&ux500_channel->channel_work);
 }
 
 static bool ux500_configure_channel(struct dma_channel *channel,
@@ -326,7 +299,6 @@ static int ux500_dma_controller_start(struct dma_controller *c)
 	void **param_array;
 	struct ux500_dma_channel *channel_array;
 	u32 ch_count;
-	void (*musb_channel_work)(struct work_struct *);
 	dma_cap_mask_t mask;
 
 	if ((data->num_rx_channels > UX500_MUSB_DMA_NUM_RX_CHANNELS) ||
@@ -343,7 +315,6 @@ static int ux500_dma_controller_start(struct dma_controller *c)
 	channel_array = controller->rx_channel;
 	ch_count = data->num_rx_channels;
 	param_array = data->dma_rx_param_array;
-	musb_channel_work = ux500_rx_work;
 
 	for (dir = 0; dir < 2; dir++) {
 		for (ch_num = 0; ch_num < ch_count; ch_num++) {
@@ -370,15 +341,12 @@ static int ux500_dma_controller_start(struct dma_controller *c)
 				return -EBUSY;
 			}
 
-			INIT_WORK(&ux500_channel->channel_work,
-				musb_channel_work);
 		}
 
 		/* Prepare the loop for TX channels */
 		channel_array = controller->tx_channel;
 		ch_count = data->num_tx_channels;
 		param_array = data->dma_tx_param_array;
-		musb_channel_work = ux500_tx_work;
 		is_tx = 1;
 	}
 
-- 
1.7.4.1

