Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758191Ab2EaOA0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 10:00:26 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:36981 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757496Ab2EaOAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 10:00:25 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/dpkFjTbDd2itzc1A2vDuWP0sfcn7/KujLhAux2M
	2Ou6+7YKMMujoD
Message-ID: <1338472815.7460.70.camel@marge.simpson.net>
Subject: [PATCH] [2.6.32-longterm] ioat2: kill pending flag
From: Mike Galbraith <efault@gmx.de>
To: stable <stable@vger.kernel.org>
Cc: Willy Tarreau <w@1wt.eu>, LKML <linux-kernel@vger.kernel.org>,
        Dan Williams <dan.j.williams@intel.com>
Date: Thu, 31 May 2012 16:00:15 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings,

While testing tbench 40 throughput on a 40 core (+SMT) Intel SDV S3E37,
I found spin_lock_bh() consuming _90%_ of the box, driving throughput
straight through the floor.  The commit below fixed it up.

This looks horrific enough to me to qualify for 2.6.32-longterm.



>From 281befa5592b0c5f9a3856b5666c62ac66d3d9ee Mon Sep 17 00:00:00 2001
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 3 Mar 2010 11:47:43 -0700
Subject: [PATCH] ioat2: kill pending flag

The pending == 2 case no longer exists in the driver so, we can use
ioat2_ring_pending() outside the lock to determine if there might be any
descriptors in the ring that the hardware has not seen.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>

---
 drivers/dma/ioat/dma_v2.c |   34 ++++++++++++----------------------
 drivers/dma/ioat/dma_v2.h |    2 --
 2 files changed, 12 insertions(+), 24 deletions(-)

--- a/drivers/dma/ioat/dma_v2.c
+++ b/drivers/dma/ioat/dma_v2.c
@@ -51,48 +51,40 @@ MODULE_PARM_DESC(ioat_ring_max_alloc_ord
 
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
@@ -546,7 +538,6 @@ int ioat2_alloc_chan_resources(struct dm
 	ioat->head = 0;
 	ioat->issued = 0;
 	ioat->tail = 0;
-	ioat->pending = 0;
 	ioat->alloc_order = order;
 	spin_unlock_bh(&ioat->ring_lock);
 
@@ -815,7 +806,6 @@ void ioat2_free_chan_resources(struct dm
 
 	chan->last_completion = 0;
 	chan->completion_dma = 0;
-	ioat->pending = 0;
 	ioat->dmacount = 0;
 }
 
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


