Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755539Ab1HCMWu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 08:22:50 -0400
Received: from eu1sys200aog119.obsmtp.com ([207.126.144.147]:48293 "EHLO
	eu1sys200aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755015Ab1HCMWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 08:22:43 -0400
From: Per Forlin <per.forlin@stericsson.com>
To: Felipe Balbi <balbi@ti.com>,
        Mian Yousaf KAUKAB <mian.yousaf.kaukab@stericsson.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Cc: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linaro-dev@lists.linaro.org>, Per Forlin <per.forlin@linaro.org>
Subject: [PATCH] usb: musb: ux500: replace missing DBG with dev_dbg
Date: Wed, 3 Aug 2011 14:22:17 +0200
Message-ID: <1312374137-10629-1-git-send-email-per.forlin@stericsson.com>
X-Mailer: git-send-email 1.6.3.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Per Forlin <per.forlin@linaro.org>

ux500_dma.c fail to compile becase DBG has been removed from musb_debug.
Use dev_dbg for all prints.

Signed-off-by: Per Forlin <per.forlin@linaro.org>
Acked-by: Mian Yousaf Kaukab<mian.yousaf.kaukab@stericsson.com>
---
 drivers/usb/musb/ux500_dma.c |   22 ++++++++++++++--------
 1 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/usb/musb/ux500_dma.c b/drivers/usb/musb/ux500_dma.c
index 2313475..ef4333f 100644
--- a/drivers/usb/musb/ux500_dma.c
+++ b/drivers/usb/musb/ux500_dma.c
@@ -65,7 +65,8 @@ static void ux500_tx_work(struct work_struct *data)
 	struct musb *musb = hw_ep->musb;
 	unsigned long flags;
 
-	DBG(4, "DMA tx transfer done on hw_ep=%d\n", hw_ep->epnum);
+	dev_dbg(musb->controller, "DMA tx transfer done on hw_ep=%d\n",
+		hw_ep->epnum);
 
 	spin_lock_irqsave(&musb->lock, flags);
 	ux500_channel->channel.actual_len = ux500_channel->cur_len;
@@ -84,7 +85,8 @@ static void ux500_rx_work(struct work_struct *data)
 	struct musb *musb = hw_ep->musb;
 	unsigned long flags;
 
-	DBG(4, "DMA rx transfer done on hw_ep=%d\n", hw_ep->epnum);
+	dev_dbg(musb->controller, "DMA rx transfer done on hw_ep=%d\n",
+		hw_ep->epnum);
 
 	spin_lock_irqsave(&musb->lock, flags);
 	ux500_channel->channel.actual_len = ux500_channel->cur_len;
@@ -116,9 +118,11 @@ static bool ux500_configure_channel(struct dma_channel *channel,
 	enum dma_slave_buswidth addr_width;
 	dma_addr_t usb_fifo_addr = (MUSB_FIFO_OFFSET(hw_ep->epnum) +
 					ux500_channel->controller->phy_base);
+	struct musb *musb = ux500_channel->controller->private_data;
 
-	DBG(4, "packet_sz=%d, mode=%d, dma_addr=0x%x, len=%d is_tx=%d\n",
-			packet_sz, mode, dma_addr, len, ux500_channel->is_tx);
+	dev_dbg(musb->controller,
+		"packet_sz=%d, mode=%d, dma_addr=0x%x, len=%d is_tx=%d\n",
+		packet_sz, mode, dma_addr, len, ux500_channel->is_tx);
 
 	ux500_channel->cur_len = len;
 
@@ -164,6 +168,7 @@ static struct dma_channel *ux500_dma_channel_allocate(struct dma_controller *c,
 	struct ux500_dma_controller *controller = container_of(c,
 			struct ux500_dma_controller, controller);
 	struct ux500_dma_channel *ux500_channel = NULL;
+	struct musb *musb = controller->private_data;
 	u8 ch_num = hw_ep->epnum - 1;
 	u32 max_ch;
 
@@ -190,7 +195,7 @@ static struct dma_channel *ux500_dma_channel_allocate(struct dma_controller *c,
 	ux500_channel->hw_ep = hw_ep;
 	ux500_channel->is_allocated = 1;
 
-	DBG(7, "hw_ep=%d, is_tx=0x%x, channel=%d\n",
+	dev_dbg(musb->controller, "hw_ep=%d, is_tx=0x%x, channel=%d\n",
 		hw_ep->epnum, is_tx, ch_num);
 
 	return &(ux500_channel->channel);
@@ -199,8 +204,9 @@ static struct dma_channel *ux500_dma_channel_allocate(struct dma_controller *c,
 static void ux500_dma_channel_release(struct dma_channel *channel)
 {
 	struct ux500_dma_channel *ux500_channel = channel->private_data;
+	struct musb *musb = ux500_channel->controller->private_data;
 
-	DBG(7, "channel=%d\n", ux500_channel->ch_num);
+	dev_dbg(musb->controller, "channel=%d\n", ux500_channel->ch_num);
 
 	if (ux500_channel->is_allocated) {
 		ux500_channel->is_allocated = 0;
@@ -250,8 +256,8 @@ static int ux500_dma_channel_abort(struct dma_channel *channel)
 	void __iomem *epio = musb->endpoints[ux500_channel->hw_ep->epnum].regs;
 	u16 csr;
 
-	DBG(4, "channel=%d, is_tx=%d\n", ux500_channel->ch_num,
-						ux500_channel->is_tx);
+	dev_dbg(musb->controller, "channel=%d, is_tx=%d\n",
+		ux500_channel->ch_num, ux500_channel->is_tx);
 
 	if (channel->status == MUSB_DMA_STATUS_BUSY) {
 		if (ux500_channel->is_tx) {
-- 
1.6.3.3

