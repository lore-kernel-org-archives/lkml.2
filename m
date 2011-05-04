Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752179Ab1EDIVV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 04:21:21 -0400
Received: from mga11.intel.com ([192.55.52.93]:26109 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751196Ab1EDIVR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 04:21:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,313,1301900400"; 
   d="scan'208";a="687871466"
Message-Id: <20110504082115.270298766@sli10-conroe.sh.intel.com>
User-Agent: quilt/0.48-1
Date: Wed, 04 May 2011 16:17:27 +0800
From: shaohua.li@intel.com
To: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Cc: jaxboe@fusionio.com, htejun@gmail.com, jgarzik@pobox.com,
        hch@infradead.org, djwong@us.ibm.com,
        Shaohua Li <shaohua.li@intel.com>
Subject: [patch v2 2/3] block: hold queue if flush is running for non-queueable flush drive
References: <20110504081725.946950281@sli10-conroe.sh.intel.com>
Content-Disposition: inline; filename=blk-hold-queue-for-nonqueueable-flush.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In some drives, flush requests are non-queueable. When flush request is running,
normal read/write requests can't run. If block layer dispatches such request,
driver can't handle it and requeue it.
Tejun suggested we can hold the queue when flush is running. This can avoid
unnecessary requeue.
Also this can improve performance. Say we have requests f1, w1, f2 (f is flush
request, and w is write request). When f1 is running, queue will be hold, so w1
will not be added to queue list. Just after f1 is finished, f2 will be
dispatched. Since f1 already flushs cache out, f2 can be finished very quickly.
In my test, the queue holding completely solves a regression introduced by
commit 53d63e6b0dfb9588, which is about 20% regression running a sysbench fileio
workload.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
---
 block/blk-flush.c      |    3 +++
 block/blk.h            |   12 +++++++++++-
 include/linux/blkdev.h |    1 +
 3 files changed, 15 insertions(+), 1 deletion(-)

Index: linux/block/blk-flush.c
===================================================================
--- linux.orig/block/blk-flush.c	2011-05-04 14:20:33.000000000 +0800
+++ linux/block/blk-flush.c	2011-05-04 15:23:50.000000000 +0800
@@ -199,6 +199,9 @@ static void flush_end_io(struct request
 
 	BUG_ON(q->flush_pending_idx == q->flush_running_idx);
 
+	queued |= q->flush_queue_delayed;
+	q->flush_queue_delayed = 0;
+
 	/* account completion of the flush request */
 	q->flush_running_idx ^= 1;
 	elv_completed_request(q, flush_rq);
Index: linux/include/linux/blkdev.h
===================================================================
--- linux.orig/include/linux/blkdev.h	2011-05-04 14:24:40.000000000 +0800
+++ linux/include/linux/blkdev.h	2011-05-04 14:29:29.000000000 +0800
@@ -365,6 +365,7 @@ struct request_queue
 	 */
 	unsigned int		flush_flags;
 	unsigned int		flush_not_queueable:1;
+	unsigned int		flush_queue_delayed:1;
 	unsigned int		flush_pending_idx:1;
 	unsigned int		flush_running_idx:1;
 	unsigned long		flush_pending_since;
Index: linux/block/blk.h
===================================================================
--- linux.orig/block/blk.h	2011-05-04 14:20:33.000000000 +0800
+++ linux/block/blk.h	2011-05-04 16:09:42.000000000 +0800
@@ -61,7 +61,17 @@ static inline struct request *__elv_next
 			rq = list_entry_rq(q->queue_head.next);
 			return rq;
 		}
-
+		/*
+		 *  Flush request is running and flush request isn't queeueable
+		 *  in the drive, we can hold the queue till flush request is
+		 *  finished. Even we don't do this, driver can't dispatch next
+		 *  requests and will requeue them.
+		 */
+		if (q->flush_pending_idx != q->flush_running_idx &&
+				!blk_queue_flush_queueable(q)) {
+			q->flush_queue_delayed = 1;
+			return NULL;
+		}
 		if (!q->elevator->ops->elevator_dispatch_fn(q, 0))
 			return NULL;
 	}

