Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752704Ab1EECEW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 22:04:22 -0400
Received: from mga01.intel.com ([192.55.52.88]:27672 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752271Ab1EECEU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 22:04:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,318,1301900400"; 
   d="scan'208";a="918189726"
Message-Id: <20110505020417.817084678@sli10-conroe.sh.intel.com>
User-Agent: quilt/0.48-1
Date: Thu, 05 May 2011 09:59:34 +0800
From: shaohua.li@intel.com
To: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Cc: jaxboe@fusionio.com, htejun@gmail.com, hch@infradead.org,
        jgarzik@pobox.com, djwong@us.ibm.com, sshtylyov@mvista.com,
        Shaohua Li <shaohua.li@intel.com>
Subject: [patch v3 2/3] block: hold queue if flush is running for non-queueable flush drive
References: <20110505015932.306763905@sli10-conroe.sh.intel.com>
Content-Disposition: inline; filename=blk-hold-queue-for-nonqueueable-flush.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In some drives, flush requests are non-queueable. When flush request is running,
normal read/write requests can't run. If block layer dispatches such request,
driver can't handle it and requeue it.
Tejun suggested we can hold the queue when flush is running. This can avoid
unnecessary requeue.
Also this can improve performance. For example, we have request flush1, write1,
flush 2. flush1 is dispatched, then queue is hold, write1 isn't inserted to
queue. After flush1 is finished, flush2 will be dispatched. Since disk cache
is already clean, flush2 will be finished very soon, so looks like flush2 is
folded to flush1.
In my test, the queue holding completely solves a regression introduced by
commit 53d63e6b0dfb95882ec0219ba6bbd50cde423794:
    block: make the flush insertion use the tail of the dispatch list

    It's not a preempt type request, in fact we have to insert it
    behind requests that do specify INSERT_FRONT.
which causes about 20% regression running a sysbench fileio
workload.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
---
 block/blk-flush.c      |   16 +++++++++++-----
 block/blk.h            |   21 ++++++++++++++++++++-
 include/linux/blkdev.h |    1 +
 3 files changed, 32 insertions(+), 6 deletions(-)

Index: linux/block/blk-flush.c
===================================================================
--- linux.orig/block/blk-flush.c	2011-05-05 08:36:51.000000000 +0800
+++ linux/block/blk-flush.c	2011-05-05 09:28:37.000000000 +0800
@@ -212,13 +212,19 @@ static void flush_end_io(struct request
 	}
 
 	/*
-	 * Moving a request silently to empty queue_head may stall the
-	 * queue.  Kick the queue in those cases.  This function is called
-	 * from request completion path and calling directly into
-	 * request_fn may confuse the driver.  Always use kblockd.
+	 * Kick the queue to avoid stall for two cases:
+	 * 1. Moving a request silently to empty queue_head may stall the
+	 * queue.
+	 * 2. When flush request is running in non-queueable queue, the
+	 * queue is hold. Restart the queue after flush request is finished
+	 * to avoid stall.
+	 * This function is called from request completion path and calling
+	 * directly into request_fn may confuse the driver.  Always use
+	 * kblockd.
 	 */
-	if (queued)
+	if (queued || q->flush_queue_delayed)
 		blk_run_queue_async(q);
+	q->flush_queue_delayed = 0;
 }
 
 /**
Index: linux/include/linux/blkdev.h
===================================================================
--- linux.orig/include/linux/blkdev.h	2011-05-05 09:05:18.000000000 +0800
+++ linux/include/linux/blkdev.h	2011-05-05 09:06:08.000000000 +0800
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
--- linux.orig/block/blk.h	2011-05-05 08:36:51.000000000 +0800
+++ linux/block/blk.h	2011-05-05 09:49:34.000000000 +0800
@@ -61,7 +61,26 @@ static inline struct request *__elv_next
 			rq = list_entry_rq(q->queue_head.next);
 			return rq;
 		}
-
+		/*
+		 * Flush request is running and flush request isn't queueable
+		 * in the drive, we can hold the queue till flush request is
+		 * finished. Even we don't do this, driver can't dispatch next
+		 * requests and will requeue them. And this can improve
+		 * throughput too. For example, we have request flush1, write1,
+		 * flush 2. flush1 is dispatched, then queue is hold, write1
+		 * isn't inserted to queue. After flush1 is finished, flush2
+		 * will be dispatched. Since disk cache is already clean,
+		 * flush2 will be finished very soon, so looks like flush2 is
+		 * folded to flush1.
+		 * Since the queue is hold, a flag is set to indicate the queue
+		 * should be restarted later. Please see flush_end_io() for
+		 * details.
+		 */
+		if (q->flush_pending_idx != q->flush_running_idx &&
+				!queue_flush_queueable(q)) {
+			q->flush_queue_delayed = 1;
+			return NULL;
+		}
 		if (!q->elevator->ops->elevator_dispatch_fn(q, 0))
 			return NULL;
 	}

