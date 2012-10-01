Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964888Ab2JAXUL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 19:20:11 -0400
Received: from 1wt.eu ([62.212.114.60]:35402 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932973Ab2JAXBk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 19:01:40 -0400
Message-Id: <20121001225158.550410866@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 02 Oct 2012 00:52:19 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Dan Williams <dan.j.williams@intel.com>, Willy Tarreau <w@1wt.eu>
Subject: [ 022/180] ioat2: kill pending flag
In-Reply-To: <6a854f579a99b4fe2efaca1057e8ae22@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Williams <dan.j.williams@intel.com>

commit 281befa5592b0c5f9a3856b5666c62ac66d3d9ee upstream.

The pending == 2 case no longer exists in the driver so, we can use
ioat2_ring_pending() outside the lock to determine if there might be any
descriptors in the ring that the hardware has not seen.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Backported-by: Mike Galbraith <efault@gmx.de>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/dma/ioat/dma_v2.c |   34 ++++++++++++----------------------
 drivers/dma/ioat/dma_v2.h |    2 --
 2 files changed, 12 insertions(+), 24 deletions(-)

diff --git a/drivers/dma/ioat/dma_v2.c b/drivers/dma/ioat/dma_v2.c
index 5cc37af..d1be371 100644
--- a/drivers/dma/ioat/dma_v2.c
+++ b/drivers/dma/ioat/dma_v2.c
@@ -51,48 +51,40 @@ MODULE_PARM_DESC(ioat_ring_max_alloc_order,
 
 void __ioat2_issue_pending(struct ioat2_dma_chan *ioat)
 {
-	void * __iomem reg_base = ioat->base.reg_base;
+	struct ioat_chan_common *chan = &ioat->base;
 
-	ioat->pending = 0;
 	ioat->dmacount += ioat2_ring_pending(ioat);
 	ioat->issued = ioat->head;
 	/* make descriptor updates globally visible before notifying channel */
 	wmb();
-	writew(ioat->dmacount, reg_base + IOAT_CHAN_DMACOUNT_OFFSET);
-	dev_dbg(to_dev(&ioat->base),
+	writew(ioat->dmacount, chan->reg_base + IOAT_CHAN_DMACOUNT_OFFSET);
+	dev_dbg(to_dev(chan),
 		"%s: head: %#x tail: %#x issued: %#x count: %#x\n",
 		__func__, ioat->head, ioat->tail, ioat->issued, ioat->dmacount);
 }
 
-void ioat2_issue_pending(struct dma_chan *chan)
+void ioat2_issue_pending(struct dma_chan *c)
 {
-	struct ioat2_dma_chan *ioat = to_ioat2_chan(chan);
+	struct ioat2_dma_chan *ioat = to_ioat2_chan(c);
 
-	spin_lock_bh(&ioat->ring_lock);
-	if (ioat->pending == 1)
+	if (ioat2_ring_pending(ioat)) {
+		spin_lock_bh(&ioat->ring_lock);
 		__ioat2_issue_pending(ioat);
-	spin_unlock_bh(&ioat->ring_lock);
+		spin_unlock_bh(&ioat->ring_lock);
+	}
 }
 
 /**
  * ioat2_update_pending - log pending descriptors
  * @ioat: ioat2+ channel
  *
- * set pending to '1' unless pending is already set to '2', pending == 2
- * indicates that submission is temporarily blocked due to an in-flight
- * reset.  If we are already above the ioat_pending_level threshold then
- * just issue pending.
- *
- * called with ring_lock held
+ * Check if the number of unsubmitted descriptors has exceeded the
+ * watermark.  Called with ring_lock held
  */
 static void ioat2_update_pending(struct ioat2_dma_chan *ioat)
 {
-	if (unlikely(ioat->pending == 2))
-		return;
-	else if (ioat2_ring_pending(ioat) > ioat_pending_level)
+	if (ioat2_ring_pending(ioat) > ioat_pending_level)
 		__ioat2_issue_pending(ioat);
-	else
-		ioat->pending = 1;
 }
 
 static void __ioat2_start_null_desc(struct ioat2_dma_chan *ioat)
@@ -546,7 +538,6 @@ int ioat2_alloc_chan_resources(struct dma_chan *c)
 	ioat->head = 0;
 	ioat->issued = 0;
 	ioat->tail = 0;
-	ioat->pending = 0;
 	ioat->alloc_order = order;
 	spin_unlock_bh(&ioat->ring_lock);
 
@@ -815,7 +806,6 @@ void ioat2_free_chan_resources(struct dma_chan *c)
 
 	chan->last_completion = 0;
 	chan->completion_dma = 0;
-	ioat->pending = 0;
 	ioat->dmacount = 0;
 }
 
diff --git a/drivers/dma/ioat/dma_v2.h b/drivers/dma/ioat/dma_v2.h
index 3afad8d..d211335 100644
--- a/drivers/dma/ioat/dma_v2.h
+++ b/drivers/dma/ioat/dma_v2.h
@@ -47,7 +47,6 @@ extern int ioat_ring_alloc_order;
  * @head: allocated index
  * @issued: hardware notification point
  * @tail: cleanup index
- * @pending: lock free indicator for issued != head
  * @dmacount: identical to 'head' except for occasionally resetting to zero
  * @alloc_order: log2 of the number of allocated descriptors
  * @ring: software ring buffer implementation of hardware ring
@@ -61,7 +60,6 @@ struct ioat2_dma_chan {
 	u16 tail;
 	u16 dmacount;
 	u16 alloc_order;
-	int pending;
 	struct ioat_ring_ent **ring;
 	spinlock_t ring_lock;
 };
-- 
1.7.2.1.45.g54fbc



