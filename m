Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755376Ab1BJGpr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 01:45:47 -0500
Received: from smtp-out.google.com ([74.125.121.67]:20116 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752710Ab1BJGoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 01:44:09 -0500
From: Colin Cross <ccross@android.com>
To: linux-tegra@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, olof@lixom.net, konkers@android.com,
        Colin Cross <ccross@android.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: [PATCH v4 13/15] ARM: tegra: dma: Fix critical data corruption bugs
Date: Wed,  9 Feb 2011 22:43:22 -0800
Message-Id: <1297320204-31882-14-git-send-email-ccross@android.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1297320204-31882-1-git-send-email-ccross@android.com>
References: <1297320204-31882-1-git-send-email-ccross@android.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sometimes, due to high interrupt latency in the continuous mode
of DMA transfer, the half buffer complete interrupt is handled
after DMA has transferred the full buffer.  When this is detected,
stop DMA immediately and restart with the next buffer if the next
buffer is ready.

originally fixed by Victor(Weiguo) Pan <wpan@nvidia.com>

In place of using the simple spin_lock()/spi_unlock() in the
interrupt thread, using the spin_lock_irqsave() and
spin_unlock_irqrestore(). The lock is shared between the normal
process context and interrupt context.

originally fixed by Laxman Dewangan (ldewangan@nvidia.com)

The use of shadow registers caused memory corruption at physical
address 0 because the enable bit was not shadowed, and assuming it
needed to be set would enable an unconfigured dma block.  Most of the
register accesses don't need to know the previous state of the
registers, and the few places that do need to modify only a few bits
in the registers are the same ones that were sometimes incorrectly
setting the enable bit.  This patch convert tegra_dma_update_hardware
to set the entire register, and the other users to read-modify-write,
and drops the shadow registers completely.

Also fixes missing locking in tegra_dma_allocate_channel

Signed-off-by: Colin Cross <ccross@android.com>
---
 arch/arm/mach-tegra/dma.c |  197 +++++++++++++++++++++++++--------------------
 1 files changed, 108 insertions(+), 89 deletions(-)

diff --git a/arch/arm/mach-tegra/dma.c b/arch/arm/mach-tegra/dma.c
index a2a252d..250bc7b 100644
--- a/arch/arm/mach-tegra/dma.c
+++ b/arch/arm/mach-tegra/dma.c
@@ -121,17 +121,13 @@ struct tegra_dma_channel {
 	void  __iomem		*addr;
 	int			mode;
 	int			irq;
-
-	/* Register shadow */
-	u32			csr;
-	u32			ahb_seq;
-	u32			ahb_ptr;
-	u32			apb_seq;
-	u32			apb_ptr;
+	int			req_transfer_count;
 };
 
 #define  NV_DMA_MAX_CHANNELS  32
 
+static DEFINE_MUTEX(tegra_dma_lock);
+
 static DECLARE_BITMAP(channel_usage, NV_DMA_MAX_CHANNELS);
 static struct tegra_dma_channel dma_channels[NV_DMA_MAX_CHANNELS];
 
@@ -139,7 +135,6 @@ static void tegra_dma_update_hw(struct tegra_dma_channel *ch,
 	struct tegra_dma_req *req);
 static void tegra_dma_update_hw_partial(struct tegra_dma_channel *ch,
 	struct tegra_dma_req *req);
-static void tegra_dma_init_hw(struct tegra_dma_channel *ch);
 static void tegra_dma_stop(struct tegra_dma_channel *ch);
 
 void tegra_dma_flush(struct tegra_dma_channel *ch)
@@ -151,6 +146,9 @@ void tegra_dma_dequeue(struct tegra_dma_channel *ch)
 {
 	struct tegra_dma_req *req;
 
+	if (tegra_dma_is_empty(ch))
+		return;
+
 	req = list_entry(ch->list.next, typeof(*req), node);
 
 	tegra_dma_dequeue_req(ch, req);
@@ -159,10 +157,10 @@ void tegra_dma_dequeue(struct tegra_dma_channel *ch)
 
 void tegra_dma_stop(struct tegra_dma_channel *ch)
 {
-	unsigned int csr;
-	unsigned int status;
+	u32 csr;
+	u32 status;
 
-	csr = ch->csr;
+	csr = readl(ch->addr + APB_DMA_CHAN_CSR);
 	csr &= ~CSR_IE_EOC;
 	writel(csr, ch->addr + APB_DMA_CHAN_CSR);
 
@@ -176,19 +174,16 @@ void tegra_dma_stop(struct tegra_dma_channel *ch)
 
 int tegra_dma_cancel(struct tegra_dma_channel *ch)
 {
-	unsigned int csr;
+	u32 csr;
 	unsigned long irq_flags;
 
 	spin_lock_irqsave(&ch->lock, irq_flags);
 	while (!list_empty(&ch->list))
 		list_del(ch->list.next);
 
-	csr = ch->csr;
+	csr = readl(ch->addr + APB_DMA_CHAN_CSR);
 	csr &= ~CSR_REQ_SEL_MASK;
 	csr |= CSR_REQ_SEL_INVALID;
-
-	/* Set the enable as that is not shadowed */
-	csr |= CSR_ENB;
 	writel(csr, ch->addr + APB_DMA_CHAN_CSR);
 
 	tegra_dma_stop(ch);
@@ -230,18 +225,15 @@ int tegra_dma_dequeue_req(struct tegra_dma_channel *ch,
 	 *  - Finally stop or program the DMA to the next buffer in the
 	 *    list.
 	 */
-	csr = ch->csr;
+	csr = readl(ch->addr + APB_DMA_CHAN_CSR);
 	csr &= ~CSR_REQ_SEL_MASK;
 	csr |= CSR_REQ_SEL_INVALID;
-
-	/* Set the enable as that is not shadowed */
-	csr |= CSR_ENB;
 	writel(csr, ch->addr + APB_DMA_CHAN_CSR);
 
 	/* Get the transfer count */
 	status = readl(ch->addr + APB_DMA_CHAN_STA);
 	to_transfer = (status & STA_COUNT_MASK) >> STA_COUNT_SHIFT;
-	req_transfer_count = (ch->csr & CSR_WCOUNT_MASK) >> CSR_WCOUNT_SHIFT;
+	req_transfer_count = ch->req_transfer_count;
 	req_transfer_count += 1;
 	to_transfer += 1;
 
@@ -349,7 +341,9 @@ EXPORT_SYMBOL(tegra_dma_enqueue_req);
 struct tegra_dma_channel *tegra_dma_allocate_channel(int mode)
 {
 	int channel;
-	struct tegra_dma_channel *ch;
+	struct tegra_dma_channel *ch = NULL;
+
+	mutex_lock(&tegra_dma_lock);
 
 	/* first channel is the shared channel */
 	if (mode & TEGRA_DMA_SHARED) {
@@ -358,11 +352,14 @@ struct tegra_dma_channel *tegra_dma_allocate_channel(int mode)
 		channel = find_first_zero_bit(channel_usage,
 			ARRAY_SIZE(dma_channels));
 		if (channel >= ARRAY_SIZE(dma_channels))
-			return NULL;
+			goto out;
 	}
 	__set_bit(channel, channel_usage);
 	ch = &dma_channels[channel];
 	ch->mode = mode;
+
+out:
+	mutex_unlock(&tegra_dma_lock);
 	return ch;
 }
 EXPORT_SYMBOL(tegra_dma_allocate_channel);
@@ -372,22 +369,27 @@ void tegra_dma_free_channel(struct tegra_dma_channel *ch)
 	if (ch->mode & TEGRA_DMA_SHARED)
 		return;
 	tegra_dma_cancel(ch);
+	mutex_lock(&tegra_dma_lock);
 	__clear_bit(ch->id, channel_usage);
+	mutex_unlock(&tegra_dma_lock);
 }
 EXPORT_SYMBOL(tegra_dma_free_channel);
 
 static void tegra_dma_update_hw_partial(struct tegra_dma_channel *ch,
 	struct tegra_dma_req *req)
 {
+	u32 apb_ptr;
+	u32 ahb_ptr;
+
 	if (req->to_memory) {
-		ch->apb_ptr = req->source_addr;
-		ch->ahb_ptr = req->dest_addr;
+		apb_ptr = req->source_addr;
+		ahb_ptr = req->dest_addr;
 	} else {
-		ch->apb_ptr = req->dest_addr;
-		ch->ahb_ptr = req->source_addr;
+		apb_ptr = req->dest_addr;
+		ahb_ptr = req->source_addr;
 	}
-	writel(ch->apb_ptr, ch->addr + APB_DMA_CHAN_APB_PTR);
-	writel(ch->ahb_ptr, ch->addr + APB_DMA_CHAN_AHB_PTR);
+	writel(apb_ptr, ch->addr + APB_DMA_CHAN_APB_PTR);
+	writel(ahb_ptr, ch->addr + APB_DMA_CHAN_AHB_PTR);
 
 	req->status = TEGRA_DMA_REQ_INFLIGHT;
 	return;
@@ -401,38 +403,39 @@ static void tegra_dma_update_hw(struct tegra_dma_channel *ch,
 	int ahb_bus_width;
 	int apb_bus_width;
 	int index;
-	unsigned long csr;
 
+	u32 ahb_seq;
+	u32 apb_seq;
+	u32 ahb_ptr;
+	u32 apb_ptr;
+	u32 csr;
+
+	csr = CSR_IE_EOC | CSR_FLOW;
+	ahb_seq = AHB_SEQ_INTR_ENB | AHB_SEQ_BURST_1;
+	apb_seq = 0;
 
-	ch->csr |= CSR_FLOW;
-	ch->csr &= ~CSR_REQ_SEL_MASK;
-	ch->csr |= req->req_sel << CSR_REQ_SEL_SHIFT;
-	ch->ahb_seq &= ~AHB_SEQ_BURST_MASK;
-	ch->ahb_seq |= AHB_SEQ_BURST_1;
+	csr |= req->req_sel << CSR_REQ_SEL_SHIFT;
 
 	/* One shot mode is always single buffered,
 	 * continuous mode is always double buffered
 	 * */
 	if (ch->mode & TEGRA_DMA_MODE_ONESHOT) {
-		ch->csr |= CSR_ONCE;
-		ch->ahb_seq &= ~AHB_SEQ_DBL_BUF;
-		ch->csr &= ~CSR_WCOUNT_MASK;
-		ch->csr |= ((req->size>>2) - 1) << CSR_WCOUNT_SHIFT;
+		csr |= CSR_ONCE;
+		ch->req_transfer_count = (req->size >> 2) - 1;
 	} else {
-		ch->csr &= ~CSR_ONCE;
-		ch->ahb_seq |= AHB_SEQ_DBL_BUF;
+		ahb_seq |= AHB_SEQ_DBL_BUF;
 
 		/* In double buffered mode, we set the size to half the
 		 * requested size and interrupt when half the buffer
 		 * is full */
-		ch->csr &= ~CSR_WCOUNT_MASK;
-		ch->csr |= ((req->size>>3) - 1) << CSR_WCOUNT_SHIFT;
+		ch->req_transfer_count = (req->size >> 3) - 1;
 	}
 
+	csr |= ch->req_transfer_count << CSR_WCOUNT_SHIFT;
+
 	if (req->to_memory) {
-		ch->csr &= ~CSR_DIR;
-		ch->apb_ptr = req->source_addr;
-		ch->ahb_ptr = req->dest_addr;
+		apb_ptr = req->source_addr;
+		ahb_ptr = req->dest_addr;
 
 		apb_addr_wrap = req->source_wrap;
 		ahb_addr_wrap = req->dest_wrap;
@@ -440,9 +443,9 @@ static void tegra_dma_update_hw(struct tegra_dma_channel *ch,
 		ahb_bus_width = req->dest_bus_width;
 
 	} else {
-		ch->csr |= CSR_DIR;
-		ch->apb_ptr = req->dest_addr;
-		ch->ahb_ptr = req->source_addr;
+		csr |= CSR_DIR;
+		apb_ptr = req->dest_addr;
+		ahb_ptr = req->source_addr;
 
 		apb_addr_wrap = req->dest_wrap;
 		ahb_addr_wrap = req->source_wrap;
@@ -461,8 +464,7 @@ static void tegra_dma_update_hw(struct tegra_dma_channel *ch,
 		index++;
 	} while (index < ARRAY_SIZE(apb_addr_wrap_table));
 	BUG_ON(index == ARRAY_SIZE(apb_addr_wrap_table));
-	ch->apb_seq &= ~APB_SEQ_WRAP_MASK;
-	ch->apb_seq |= index << APB_SEQ_WRAP_SHIFT;
+	apb_seq |= index << APB_SEQ_WRAP_SHIFT;
 
 	/* set address wrap for AHB size */
 	index = 0;
@@ -472,55 +474,42 @@ static void tegra_dma_update_hw(struct tegra_dma_channel *ch,
 		index++;
 	} while (index < ARRAY_SIZE(ahb_addr_wrap_table));
 	BUG_ON(index == ARRAY_SIZE(ahb_addr_wrap_table));
-	ch->ahb_seq &= ~AHB_SEQ_WRAP_MASK;
-	ch->ahb_seq |= index << AHB_SEQ_WRAP_SHIFT;
+	ahb_seq |= index << AHB_SEQ_WRAP_SHIFT;
 
 	for (index = 0; index < ARRAY_SIZE(bus_width_table); index++) {
 		if (bus_width_table[index] == ahb_bus_width)
 			break;
 	}
 	BUG_ON(index == ARRAY_SIZE(bus_width_table));
-	ch->ahb_seq &= ~AHB_SEQ_BUS_WIDTH_MASK;
-	ch->ahb_seq |= index << AHB_SEQ_BUS_WIDTH_SHIFT;
+	ahb_seq |= index << AHB_SEQ_BUS_WIDTH_SHIFT;
 
 	for (index = 0; index < ARRAY_SIZE(bus_width_table); index++) {
 		if (bus_width_table[index] == apb_bus_width)
 			break;
 	}
 	BUG_ON(index == ARRAY_SIZE(bus_width_table));
-	ch->apb_seq &= ~APB_SEQ_BUS_WIDTH_MASK;
-	ch->apb_seq |= index << APB_SEQ_BUS_WIDTH_SHIFT;
-
-	ch->csr |= CSR_IE_EOC;
+	apb_seq |= index << APB_SEQ_BUS_WIDTH_SHIFT;
 
-	/* update hw registers with the shadow */
-	writel(ch->csr, ch->addr + APB_DMA_CHAN_CSR);
-	writel(ch->apb_seq, ch->addr + APB_DMA_CHAN_APB_SEQ);
-	writel(ch->apb_ptr, ch->addr + APB_DMA_CHAN_APB_PTR);
-	writel(ch->ahb_seq, ch->addr + APB_DMA_CHAN_AHB_SEQ);
-	writel(ch->ahb_ptr, ch->addr + APB_DMA_CHAN_AHB_PTR);
+	writel(csr, ch->addr + APB_DMA_CHAN_CSR);
+	writel(apb_seq, ch->addr + APB_DMA_CHAN_APB_SEQ);
+	writel(apb_ptr, ch->addr + APB_DMA_CHAN_APB_PTR);
+	writel(ahb_seq, ch->addr + APB_DMA_CHAN_AHB_SEQ);
+	writel(ahb_ptr, ch->addr + APB_DMA_CHAN_AHB_PTR);
 
-	csr = ch->csr | CSR_ENB;
+	csr |= CSR_ENB;
 	writel(csr, ch->addr + APB_DMA_CHAN_CSR);
 
 	req->status = TEGRA_DMA_REQ_INFLIGHT;
 }
 
-static void tegra_dma_init_hw(struct tegra_dma_channel *ch)
-{
-	/* One shot with an interrupt to CPU after transfer */
-	ch->csr = CSR_ONCE | CSR_IE_EOC;
-	ch->ahb_seq = AHB_SEQ_BUS_WIDTH_32 | AHB_SEQ_INTR_ENB;
-	ch->apb_seq = APB_SEQ_BUS_WIDTH_32 | 1 << APB_SEQ_WRAP_SHIFT;
-}
-
 static void handle_oneshot_dma(struct tegra_dma_channel *ch)
 {
 	struct tegra_dma_req *req;
+	unsigned long irq_flags;
 
-	spin_lock(&ch->lock);
+	spin_lock_irqsave(&ch->lock, irq_flags);
 	if (list_empty(&ch->list)) {
-		spin_unlock(&ch->lock);
+		spin_unlock_irqrestore(&ch->lock, irq_flags);
 		return;
 	}
 
@@ -528,8 +517,7 @@ static void handle_oneshot_dma(struct tegra_dma_channel *ch)
 	if (req) {
 		int bytes_transferred;
 
-		bytes_transferred =
-			(ch->csr & CSR_WCOUNT_MASK) >> CSR_WCOUNT_SHIFT;
+		bytes_transferred = ch->req_transfer_count;
 		bytes_transferred += 1;
 		bytes_transferred <<= 2;
 
@@ -537,12 +525,12 @@ static void handle_oneshot_dma(struct tegra_dma_channel *ch)
 		req->bytes_transferred = bytes_transferred;
 		req->status = TEGRA_DMA_REQ_SUCCESS;
 
-		spin_unlock(&ch->lock);
+		spin_unlock_irqrestore(&ch->lock, irq_flags);
 		/* Callback should be called without any lock */
 		pr_debug("%s: transferred %d bytes\n", __func__,
 			req->bytes_transferred);
 		req->complete(req);
-		spin_lock(&ch->lock);
+		spin_lock_irqsave(&ch->lock, irq_flags);
 	}
 
 	if (!list_empty(&ch->list)) {
@@ -552,22 +540,55 @@ static void handle_oneshot_dma(struct tegra_dma_channel *ch)
 		if (req->status != TEGRA_DMA_REQ_INFLIGHT)
 			tegra_dma_update_hw(ch, req);
 	}
-	spin_unlock(&ch->lock);
+	spin_unlock_irqrestore(&ch->lock, irq_flags);
 }
 
 static void handle_continuous_dma(struct tegra_dma_channel *ch)
 {
 	struct tegra_dma_req *req;
+	unsigned long irq_flags;
 
-	spin_lock(&ch->lock);
+	spin_lock_irqsave(&ch->lock, irq_flags);
 	if (list_empty(&ch->list)) {
-		spin_unlock(&ch->lock);
+		spin_unlock_irqrestore(&ch->lock, irq_flags);
 		return;
 	}
 
 	req = list_entry(ch->list.next, typeof(*req), node);
 	if (req) {
 		if (req->buffer_status == TEGRA_DMA_REQ_BUF_STATUS_EMPTY) {
+			bool is_dma_ping_complete;
+			is_dma_ping_complete = (readl(ch->addr + APB_DMA_CHAN_STA)
+						& STA_PING_PONG) ? true : false;
+			if (req->to_memory)
+				is_dma_ping_complete = !is_dma_ping_complete;
+			/* Out of sync - Release current buffer */
+			if (!is_dma_ping_complete) {
+				int bytes_transferred;
+
+				bytes_transferred = ch->req_transfer_count;
+				bytes_transferred += 1;
+				bytes_transferred <<= 3;
+				req->buffer_status = TEGRA_DMA_REQ_BUF_STATUS_FULL;
+				req->bytes_transferred = bytes_transferred;
+				req->status = TEGRA_DMA_REQ_SUCCESS;
+				tegra_dma_stop(ch);
+
+				if (!list_is_last(&req->node, &ch->list)) {
+					struct tegra_dma_req *next_req;
+
+					next_req = list_entry(req->node.next,
+						typeof(*next_req), node);
+					tegra_dma_update_hw(ch, next_req);
+				}
+
+				list_del(&req->node);
+
+				/* DMA lock is NOT held when callbak is called */
+				spin_unlock_irqrestore(&ch->lock, irq_flags);
+				req->complete(req);
+				return;
+			}
 			/* Load the next request into the hardware, if available
 			 * */
 			if (!list_is_last(&req->node, &ch->list)) {
@@ -580,7 +601,7 @@ static void handle_continuous_dma(struct tegra_dma_channel *ch)
 			req->buffer_status = TEGRA_DMA_REQ_BUF_STATUS_HALF_FULL;
 			req->status = TEGRA_DMA_REQ_SUCCESS;
 			/* DMA lock is NOT held when callback is called */
-			spin_unlock(&ch->lock);
+			spin_unlock_irqrestore(&ch->lock, irq_flags);
 			if (likely(req->threshold))
 				req->threshold(req);
 			return;
@@ -591,8 +612,7 @@ static void handle_continuous_dma(struct tegra_dma_channel *ch)
 			 * the second  interrupt */
 			int bytes_transferred;
 
-			bytes_transferred =
-				(ch->csr & CSR_WCOUNT_MASK) >> CSR_WCOUNT_SHIFT;
+			bytes_transferred = ch->req_transfer_count;
 			bytes_transferred += 1;
 			bytes_transferred <<= 3;
 
@@ -602,7 +622,7 @@ static void handle_continuous_dma(struct tegra_dma_channel *ch)
 			list_del(&req->node);
 
 			/* DMA lock is NOT held when callbak is called */
-			spin_unlock(&ch->lock);
+			spin_unlock_irqrestore(&ch->lock, irq_flags);
 			req->complete(req);
 			return;
 
@@ -610,7 +630,7 @@ static void handle_continuous_dma(struct tegra_dma_channel *ch)
 			BUG();
 		}
 	}
-	spin_unlock(&ch->lock);
+	spin_unlock_irqrestore(&ch->lock, irq_flags);
 }
 
 static irqreturn_t dma_isr(int irq, void *data)
@@ -674,7 +694,6 @@ int __init tegra_dma_init(void)
 
 		spin_lock_init(&ch->lock);
 		INIT_LIST_HEAD(&ch->list);
-		tegra_dma_init_hw(ch);
 
 		irq = INT_APB_DMA_CH0 + i;
 		ret = request_threaded_irq(irq, dma_isr, dma_thread_fn, 0,
-- 
1.7.3.1

