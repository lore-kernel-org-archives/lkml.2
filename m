Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162099Ab1FAIRd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 04:17:33 -0400
Received: from cantor.suse.de ([195.135.220.2]:44065 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1162069Ab1FAIRZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:17:25 -0400
X-Mailbox-Line: From linux@blue.kroah.org Wed Jun  1 17:11:04 2011
Message-Id: <20110601081104.079742034@blue.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 01 Jun 2011 17:09:56 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Shaohua Li <shaohua.li@intel.com>, Tejun Heo <tj@kernel.org>,
        Jens Axboe <jaxboe@fusionio.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [026/165] block: hold queue if flush is running for non-queueable
In-Reply-To: <20110601081349.GA10017@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------
 flush drive
Content-Length: 3920
Lines: 106

From: "shaohua.li@intel.com" <shaohua.li@intel.com>

commit 3ac0cc4508709d42ec9aa351086c7d38bfc0660c upstream.

In some drives, flush requests are non-queueable. When flush request is
running, normal read/write requests can't run. If block layer dispatches
such request, driver can't handle it and requeue it.  Tejun suggested we
can hold the queue when flush is running. This can avoid unnecessary
requeue.  Also this can improve performance. For example, we have
request flush1, write1, flush 2. flush1 is dispatched, then queue is
hold, write1 isn't inserted to queue. After flush1 is finished, flush2
will be dispatched. Since disk cache is already clean, flush2 will be
finished very soon, so looks like flush2 is folded to flush1.

In my test, the queue holding completely solves a regression introduced by
commit 53d63e6b0dfb95882ec0219ba6bbd50cde423794:

    block: make the flush insertion use the tail of the dispatch list

    It's not a preempt type request, in fact we have to insert it
    behind requests that do specify INSERT_FRONT.

which causes about 20% regression running a sysbench fileio
workload.

Stable: 2.6.39 only

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Jens Axboe <jaxboe@fusionio.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 block/blk-flush.c      |   16 +++++++++++-----
 block/blk.h            |   21 ++++++++++++++++++++-
 include/linux/blkdev.h |    1 +
 3 files changed, 32 insertions(+), 6 deletions(-)

--- a/block/blk-flush.c
+++ b/block/blk-flush.c
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
--- a/block/blk.h
+++ b/block/blk.h
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
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -365,6 +365,7 @@ struct request_queue
 	 */
 	unsigned int		flush_flags;
 	unsigned int		flush_not_queueable:1;
+	unsigned int		flush_queue_delayed:1;
 	unsigned int		flush_pending_idx:1;
 	unsigned int		flush_running_idx:1;
 	unsigned long		flush_pending_since;


