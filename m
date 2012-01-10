Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753980Ab2AJGIM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 01:08:12 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:8969 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752834Ab2AJGIK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 01:08:10 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Mon, 09 Jan 2012 22:08:10 -0800
From: Laxman Dewangan <ldewangan.com@nvidia.com>
To: ccross@android.com, olof@lixom.net, swarren@nvidia.com,
        linux@arm.linux.org.uk
Cc: linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, ldewangan@nvidia.com
Subject: [PATCH V1] ARM: tegra: Pause DMA when reading transfer count
Date: Tue, 10 Jan 2012 11:35:11 +0530
Message-Id: <1326175511-28642-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Laxman Dewangan <ldewangan@nvidia.com>

In order to read an accurate channel transfer count
from the APB DMA engine, the DMA controller must be
paused first.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>

---
 arch/arm/mach-tegra/dma.c |  116 ++++++++++++++++++++++++++++----------------
 1 files changed, 74 insertions(+), 42 deletions(-)

diff --git a/arch/arm/mach-tegra/dma.c b/arch/arm/mach-tegra/dma.c
index c0cf967..c3529cf 100644
--- a/arch/arm/mach-tegra/dma.c
+++ b/arch/arm/mach-tegra/dma.c
@@ -133,6 +133,7 @@ struct tegra_dma_channel {
 
 static bool tegra_dma_initialized;
 static DEFINE_MUTEX(tegra_dma_lock);
+static DEFINE_SPINLOCK(enable_lock);
 
 static DECLARE_BITMAP(channel_usage, NV_DMA_MAX_CHANNELS);
 static struct tegra_dma_channel dma_channels[NV_DMA_MAX_CHANNELS];
@@ -198,18 +199,82 @@ static int tegra_dma_cancel(struct tegra_dma_channel *ch)
 	return 0;
 }
 
+static unsigned int get_channel_status(struct tegra_dma_channel *ch,
+			struct tegra_dma_req *req, bool is_stop_dma)
+{
+	void __iomem *addr = IO_ADDRESS(TEGRA_APB_DMA_BASE);
+	unsigned int status;
+
+	if (is_stop_dma) {
+		/*
+		 * STOP the DMA and get the transfer count.
+		 * Getting the transfer count is tricky.
+		 *  - Globally disable DMA on all channels
+		 *  - Read the channel's status register to know the number
+		 *    of pending bytes to be transfered.
+		 *  - Stop the dma channel
+		 *  - Globally re-enable DMA to resume other transfers
+		 */
+		spin_lock(&enable_lock);
+		writel(0, addr + APB_DMA_GEN);
+		udelay(20);
+		status = readl(ch->addr + APB_DMA_CHAN_STA);
+		tegra_dma_stop(ch);
+		writel(GEN_ENABLE, addr + APB_DMA_GEN);
+		spin_unlock(&enable_lock);
+		if (status & STA_ISE_EOC) {
+			pr_err("Got Dma Int here clearing");
+			writel(status, ch->addr + APB_DMA_CHAN_STA);
+		}
+		req->status = TEGRA_DMA_REQ_ERROR_ABORTED;
+	} else {
+		status = readl(ch->addr + APB_DMA_CHAN_STA);
+	}
+	return status;
+}
+
+/* should be called with the channel lock held */
+static unsigned int dma_active_count(struct tegra_dma_channel *ch,
+	struct tegra_dma_req *req, unsigned int status)
+{
+	unsigned int to_transfer;
+	unsigned int req_transfer_count;
+	unsigned int bytes_transferred;
+
+	to_transfer = ((status & STA_COUNT_MASK) >> STA_COUNT_SHIFT) + 1;
+	req_transfer_count = ch->req_transfer_count + 1;
+	bytes_transferred = req_transfer_count;
+	if (status & STA_BUSY)
+		bytes_transferred -= to_transfer;
+	/*
+	 * In continuous transfer mode, DMA only tracks the count of the
+	 * half DMA buffer. So, if the DMA already finished half the DMA
+	 * then add the half buffer to the completed count.
+	 */
+	if (ch->mode & TEGRA_DMA_MODE_CONTINOUS) {
+		if (req->buffer_status == TEGRA_DMA_REQ_BUF_STATUS_HALF_FULL)
+			bytes_transferred += req_transfer_count;
+		if (status & STA_ISE_EOC)
+			bytes_transferred += req_transfer_count;
+	}
+	bytes_transferred *= 4;
+	return bytes_transferred;
+}
+
 int tegra_dma_dequeue_req(struct tegra_dma_channel *ch,
 	struct tegra_dma_req *_req)
 {
-	unsigned int csr;
 	unsigned int status;
 	struct tegra_dma_req *req = NULL;
 	int found = 0;
 	unsigned long irq_flags;
-	int to_transfer;
-	int req_transfer_count;
+	int stop = 0;
 
 	spin_lock_irqsave(&ch->lock, irq_flags);
+
+	if (list_entry(ch->list.next, struct tegra_dma_req, node) == _req)
+		stop = 1;
+
 	list_for_each_entry(req, &ch->list, node) {
 		if (req == _req) {
 			list_del(&req->node);
@@ -222,47 +287,12 @@ int tegra_dma_dequeue_req(struct tegra_dma_channel *ch,
 		return 0;
 	}
 
-	/* STOP the DMA and get the transfer count.
-	 * Getting the transfer count is tricky.
-	 *  - Change the source selector to invalid to stop the DMA from
-	 *    FIFO to memory.
-	 *  - Read the status register to know the number of pending
-	 *    bytes to be transferred.
-	 *  - Finally stop or program the DMA to the next buffer in the
-	 *    list.
-	 */
-	csr = readl(ch->addr + APB_DMA_CHAN_CSR);
-	csr &= ~CSR_REQ_SEL_MASK;
-	csr |= CSR_REQ_SEL_INVALID;
-	writel(csr, ch->addr + APB_DMA_CHAN_CSR);
-
-	/* Get the transfer count */
-	status = readl(ch->addr + APB_DMA_CHAN_STA);
-	to_transfer = (status & STA_COUNT_MASK) >> STA_COUNT_SHIFT;
-	req_transfer_count = ch->req_transfer_count;
-	req_transfer_count += 1;
-	to_transfer += 1;
+	if (!stop)
+		goto skip_stop_dma;
 
-	req->bytes_transferred = req_transfer_count;
+	status = get_channel_status(ch, req, true);
+	req->bytes_transferred = dma_active_count(ch, req, status);
 
-	if (status & STA_BUSY)
-		req->bytes_transferred -= to_transfer;
-
-	/* In continuous transfer mode, DMA only tracks the count of the
-	 * half DMA buffer. So, if the DMA already finished half the DMA
-	 * then add the half buffer to the completed count.
-	 *
-	 *	FIXME: There can be a race here. What if the req to
-	 *	dequue happens at the same time as the DMA just moved to
-	 *	the new buffer and SW didn't yet received the interrupt?
-	 */
-	if (ch->mode & TEGRA_DMA_MODE_CONTINOUS)
-		if (req->buffer_status == TEGRA_DMA_REQ_BUF_STATUS_HALF_FULL)
-			req->bytes_transferred += req_transfer_count;
-
-	req->bytes_transferred *= 4;
-
-	tegra_dma_stop(ch);
 	if (!list_empty(&ch->list)) {
 		/* if the list is not empty, queue the next request */
 		struct tegra_dma_req *next_req;
@@ -270,6 +300,8 @@ int tegra_dma_dequeue_req(struct tegra_dma_channel *ch,
 			typeof(*next_req), node);
 		tegra_dma_update_hw(ch, next_req);
 	}
+
+skip_stop_dma:
 	req->status = -TEGRA_DMA_REQ_ERROR_ABORTED;
 
 	spin_unlock_irqrestore(&ch->lock, irq_flags);
-- 
1.7.1.1

