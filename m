Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753413Ab2KEJwL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 04:52:11 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:57634 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753864Ab2KEJwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 04:52:07 -0500
From: Alban Bedel <alban.bedel@avionic-design.de>
To: linux-kernel@vger.kernel.org
Cc: Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
        Alban Bedel <alban.bedel@avionic-design.de>
Subject: [PATCH 3/3] dmaengine: PL08x: Make the transfer status reliable
Date: Mon,  5 Nov 2012 10:51:44 +0100
Message-Id: <1352109104-2969-4-git-send-email-alban.bedel@avionic-design.de>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1352109104-2969-1-git-send-email-alban.bedel@avionic-design.de>
References: <1352109104-2969-1-git-send-email-alban.bedel@avionic-design.de>
X-Provags-ID: V02:K0:P2IJKXWxtnj+lmtXgkqQk6zrLQVHU+rIXhKI6rdr/YG
 +oLqkL64nsrMit0QJc3J24yjYPc2UeVm2aWm/8QssnvfB3xEbe
 5Wi3mYhsbhIbLpRsw629FpcoGyF9RhC/2ZmF4wpcqgdppTW/9F
 eYuNDZ3Hi9bZ35gVjy7/bdmrdIgtLuBOk3cxoKVZCEHXfJgeNo
 00P2xR5koaEI0bw2eU7fzd6KBlq4P8wTC4jk4MtJxuZbRzhsBu
 qhhxqiKC+grOpxt7hBxWMQuY8KxCO1xRhNRKtDVS1l7AGEoFCu
 7fyUyzSS4Y5f42m9cnD8wCgw32UV93gJUpOuuz0m65MhygwORh
 9v38qtnWFnQATVXjOAlib9qViOLA3uJRYtu2gZAN6z9DM9FbS4
 2lhFIYqIOgAOnW7oTgpXVpF141ip4bh1Wdsfo/89xppfCXjkR1
 etazj
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To reliably get the current DMA position it is not possible to
just read the PL08x registers. As several reads are needed the values
are not consistent. To overcome this keep track of the position as
each LLI finish, this give a coarse but reliable value.

Signed-off-by: Alban Bedel <alban.bedel@avionic-design.de>
---
 drivers/dma/amba-pl08x.c |   79 +++++++++++++--------------------------------
 1 files changed, 23 insertions(+), 56 deletions(-)

diff --git a/drivers/dma/amba-pl08x.c b/drivers/dma/amba-pl08x.c
index b097788..57a4d80 100644
--- a/drivers/dma/amba-pl08x.c
+++ b/drivers/dma/amba-pl08x.c
@@ -175,6 +175,10 @@ struct pl08x_sg {
  * @done: this marks completed descriptors, which should not have their
  *   mux released.
  * @cyclic: indicate cyclic transfers
+ * @llis_pos: current position in the linked list
+ * @llis_count: number of transfer in the linked list
+ * @bytes_transferred: number of bytes tranfered up to now
+ * @bytes_requested: number of bytes in the whole transfer
  */
 struct pl08x_txd {
 	struct virt_dma_desc vd;
@@ -191,6 +195,10 @@ struct pl08x_txd {
 	bool done;
 
 	bool cyclic;
+	unsigned llis_pos;
+	unsigned llis_count;
+	unsigned bytes_transferred;
+	unsigned bytes_requested;
 };
 
 /**
@@ -470,56 +478,6 @@ static inline u32 get_bytes_in_cctl(u32 cctl)
 	return bytes;
 }
 
-/* The channel should be paused when calling this */
-static u32 pl08x_getbytes_chan(struct pl08x_dma_chan *plchan)
-{
-	struct pl08x_phy_chan *ch;
-	struct pl08x_txd *txd;
-	size_t bytes = 0;
-
-	ch = plchan->phychan;
-	txd = plchan->at;
-
-	/*
-	 * Follow the LLIs to get the number of remaining
-	 * bytes in the currently active transaction.
-	 */
-	if (ch && txd) {
-		u32 clli = readl(ch->base + PL080_CH_LLI) & ~PL080_LLI_LM_AHB2;
-
-		/* First get the remaining bytes in the active transfer */
-		bytes = get_bytes_in_cctl(readl(ch->base + PL080_CH_CONTROL));
-
-		if (clli) {
-			struct pl08x_lli *llis_va = txd->llis_va;
-			dma_addr_t llis_bus = txd->llis_bus;
-			int index;
-
-			BUG_ON(clli < llis_bus || clli >= llis_bus +
-				sizeof(struct pl08x_lli) * MAX_NUM_TSFR_LLIS);
-
-			/*
-			 * Locate the next LLI - as this is an array,
-			 * it's simple maths to find.
-			 */
-			index = (clli - llis_bus) / sizeof(struct pl08x_lli);
-
-			for (; index < MAX_NUM_TSFR_LLIS; index++) {
-				bytes += get_bytes_in_cctl(llis_va[index].cctl);
-
-				/*
-				 * A LLI pointer going backward terminates
-				 * the LLI list
-				 */
-				if (llis_va[index].lli <= clli)
-					break;
-			}
-		}
-	}
-
-	return bytes;
-}
-
 /*
  * Allocate a physical channel for a virtual channel
  *
@@ -777,7 +735,8 @@ static void pl08x_fill_lli_for_desc(struct pl08x_lli_build_data *bd,
 
 	BUG_ON(num_llis >= MAX_NUM_TSFR_LLIS);
 
-	llis_va[num_llis].cctl = cctl;
+	/* Always enable TC IRQ to keep track of the position in the LLIs */
+	llis_va[num_llis].cctl = cctl | PL080_CONTROL_TC_IRQ_EN;
 	llis_va[num_llis].src = bd->srcbus.addr;
 	llis_va[num_llis].dst = bd->dstbus.addr;
 	llis_va[num_llis].lli = llis_bus + (num_llis + 1) *
@@ -1011,8 +970,10 @@ static int pl08x_fill_llis_for_desc(struct pl08x_driver_data *pl08x,
 				__func__, (u32) MAX_NUM_TSFR_LLIS);
 			return 0;
 		}
+		txd->bytes_requested += total_bytes;
 	}
 
+	txd->llis_count = num_llis;
 	llis_va = txd->llis_va;
 	if (txd->cyclic) {
 		/* Link back to the first LLI. */
@@ -1020,7 +981,6 @@ static int pl08x_fill_llis_for_desc(struct pl08x_driver_data *pl08x,
 	} else {
 		/* The final LLI terminates the LLI. */
 		llis_va[num_llis - 1].lli = 0;
-		llis_va[num_llis - 1].cctl |= PL080_CONTROL_TC_IRQ_EN;
 	}
 
 #ifdef VERBOSE_DEBUG
@@ -1177,8 +1137,9 @@ static enum dma_status pl08x_dma_tx_status(struct dma_chan *chan,
 
 			list_for_each_entry(dsg, &txd->dsg_list, node)
 				bytes += dsg->len;
-		} else {
-			bytes = pl08x_getbytes_chan(plchan);
+		} else if (plchan->at) {
+			bytes = plchan->at->bytes_requested -
+				plchan->at->bytes_transferred;
 		}
 	}
 	spin_unlock_irqrestore(&plchan->vc.lock, flags);
@@ -1594,7 +1555,6 @@ static struct dma_async_tx_descriptor *pl08x_prep_dma_cyclic(
 		return NULL;
 
 	txd->cyclic = true;
-	txd->cctl |= PL080_CONTROL_TC_IRQ_EN;
 	for (tmp = 0 ; tmp < buf_len ; tmp += period_len) {
 		ret = pl08x_tx_add_sg(txd, direction, slave_addr,
 				      buf_addr + tmp, period_len);
@@ -1745,9 +1705,16 @@ static irqreturn_t pl08x_irq(int irq, void *dev)
 			spin_lock(&plchan->vc.lock);
 			tx = plchan->at;
 			if (tx) {
+				tx->bytes_transferred += get_bytes_in_cctl(
+					tx->llis_va[tx->llis_pos].cctl);
+				tx->llis_pos += 1;
 				if (tx->cyclic) {
+					tx->llis_pos %=
+						tx->llis_count;
+					tx->bytes_transferred %=
+						tx->bytes_requested;
 					vchan_cyclic_callback(&tx->vd);
-				} else {
+				} else if (tx->llis_pos >= tx->llis_count) {
 					plchan->at = NULL;
 					/*
 					 * This descriptor is done, release
-- 
1.7.0.4

