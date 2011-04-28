Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754807Ab1D1HvA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 03:51:00 -0400
Received: from mga02.intel.com ([134.134.136.20]:27736 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754614Ab1D1Hu7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 03:50:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,279,1301900400"; 
   d="scan'208";a="635201811"
Subject: Re: [PATCH 1/2]block: optimize non-queueable flush request drive
From: Shaohua Li <shaohua.li@intel.com>
To: Tejun Heo <htejun@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-ide <linux-ide@vger.kernel.org>,
        Jens Axboe <jaxboe@fusionio.com>, Jeff Garzik <jgarzik@pobox.com>,
        Christoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <djwong@us.ibm.com>
In-Reply-To: <20110426104843.GB878@htj.dyndns.org>
References: <1303202686.3981.216.camel@sli10-conroe>
	 <20110422233204.GB1576@mtj.dyndns.org>
	 <20110425013328.GA17315@sli10-conroe.sh.intel.com>
	 <20110425085827.GB17734@mtj.dyndns.org>
	 <20110425091311.GC17734@mtj.dyndns.org>
	 <1303778790.3981.283.camel@sli10-conroe>
	 <20110426104843.GB878@htj.dyndns.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 28 Apr 2011 15:50:55 +0800
Message-ID: <1303977055.3981.587.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-04-26 at 18:48 +0800, Tejun Heo wrote:
> Hey,
> 
> On Tue, Apr 26, 2011 at 08:46:30AM +0800, Shaohua Li wrote:
> > the blk-flush is part of block layer. If what you mean is the libata
> > part, block layer doesn't know if flush is queueable without knowledge
> > from driver.
> 
> It seems my communication skill towards you sucks badly.  I was
> talking about making both the issue and completion paths cooperate on
> flush sequence handling instead of depending on queuability of flush
> to make assumptions on completion order, which I still think is
> incorrect.
> 
> > > Also, another interesting thing to investigate is why the two flushes
> > > didn't get merged in the first place.  The two flushes apparently
> > > didn't have any ordering requirement between them.  Why didn't they
> > > get merged in the first place?  If the first flush were slightly
> > > delayed, the second would have been issued together from the beginning
> > > and we wouldn't have to think about merging them afterwards.  Maybe
> > > what we really need is better algorithm than C1/2/3 described in the
> > > comment?
> >
> > the sysbench fileio does a 16 threads write-fsync, so it's quite normal
> > a flush is running and another flush is added into pending list.
> 
> I think you're optimizing in the wrong place.  These back-to-back
> flushes better be merged on the issue side instead of completion.  The
> current merging rules (basically how long to delay pending flushes)
> are minimal and mechanical (timeout is the only huristic parameter).
> 
> For the initial implementation, my goal was matching the numbers of
> Darrick's original implementation at higher level and keeping things
> simple, but the code is intentionally structured to allow easy tuning
> of merging criteria, so I suggest looking there instead of mucking
> with completion path.
I got your point now. Thanks for the explain. you are right, we should
postpone the normal request to make the optimization safe. Also I merged
the back-to-back flush in issue stage. Below is the updated patch, does
it make sense to you?

Subject: block: optimize non-queueable flush request drive

In some drives, flush requests are non-queueable. This means when a flush
request is running, normal read/write requests are not. In such drive, when
running flush requests finish, we can make pending flush requests finish. Since
normal write requests are not running, pending flush requests also flush
required drive cache out. This reduces some flush requests running and improve
performance.

Tejun pointed out we should hold normal request when flush is running in this
case, otherwise low level driver might fetch next normal request and finish it
before reporting flush request completion. He is right and the patch follows
his suggestions. Holding normal request here doesn't harm performance because
low level driver will requeue normal request anyway even we don't do the
holding. And this avoids some unnecessary request requeue operation too.

This patch allows block core utilizes the optimization. Next patch will enable
it for SATA.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
---
 block/blk-core.c       |   14 ++++++++++++++
 block/blk-flush.c      |   16 ++++++++++++++++
 include/linux/blkdev.h |   17 +++++++++++++++++
 3 files changed, 47 insertions(+)

Index: linux/block/blk-flush.c
===================================================================
--- linux.orig/block/blk-flush.c	2011-04-28 10:23:12.000000000 +0800
+++ linux/block/blk-flush.c	2011-04-28 14:12:50.000000000 +0800
@@ -158,6 +158,17 @@ static bool blk_flush_complete_seq(struc
 	switch (seq) {
 	case REQ_FSEQ_PREFLUSH:
 	case REQ_FSEQ_POSTFLUSH:
+		/*
+		 * If queue doesn't support queueable flush request, we just
+		 * merge the flush with running flush. For such queue, there
+		 * are no normal requests running when flush request is
+		 * running, so this still guarantees the correctness.
+		 */
+		if (!blk_queue_flush_queueable(q)) {
+			list_move_tail(&rq->flush.list,
+				&q->flush_queue[q->flush_running_idx]);
+			break;
+		}
 		/* queue for flush */
 		if (list_empty(pending))
 			q->flush_pending_since = jiffies;
@@ -199,6 +210,10 @@ static void flush_end_io(struct request
 
 	BUG_ON(q->flush_pending_idx == q->flush_running_idx);
 
+	q->flush_exclusive_running = 0;
+	queued |= q->flush_queue_delayed;
+	q->flush_queue_delayed = 0;
+
 	/* account completion of the flush request */
 	q->flush_running_idx ^= 1;
 	elv_completed_request(q, flush_rq);
@@ -343,6 +358,7 @@ void blk_abort_flushes(struct request_qu
 	struct request *rq, *n;
 	int i;
 
+	q->flush_exclusive_running = 0;
 	/*
 	 * Requests in flight for data are already owned by the dispatch
 	 * queue or the device driver.  Just restore for normal completion.
Index: linux/include/linux/blkdev.h
===================================================================
--- linux.orig/include/linux/blkdev.h	2011-04-28 10:23:12.000000000 +0800
+++ linux/include/linux/blkdev.h	2011-04-28 10:32:54.000000000 +0800
@@ -364,6 +364,13 @@ struct request_queue
 	 * for flush operations
 	 */
 	unsigned int		flush_flags;
+	unsigned int		flush_not_queueable:1;
+	/*
+	 * flush_exclusive_running and flush_queue_delayed are only meaningful
+	 * when flush request isn't queueable
+	 */
+	unsigned int		flush_exclusive_running:1;
+	unsigned int		flush_queue_delayed:1;
 	unsigned int		flush_pending_idx:1;
 	unsigned int		flush_running_idx:1;
 	unsigned long		flush_pending_since;
@@ -549,6 +556,16 @@ static inline void blk_clear_queue_full(
 		queue_flag_clear(QUEUE_FLAG_ASYNCFULL, q);
 }
 
+static inline void blk_set_queue_flush_queueable(struct request_queue *q,
+	bool queueable)
+{
+	q->flush_not_queueable = !queueable;
+}
+
+static inline bool blk_queue_flush_queueable(struct request_queue *q)
+{
+	return !q->flush_not_queueable;
+}
 
 /*
  * mergeable request must not have _NOMERGE or _BARRIER bit set, nor may
Index: linux/block/blk-core.c
===================================================================
--- linux.orig/block/blk-core.c	2011-04-28 10:23:12.000000000 +0800
+++ linux/block/blk-core.c	2011-04-28 10:53:18.000000000 +0800
@@ -929,6 +929,8 @@ void blk_requeue_request(struct request_
 
 	BUG_ON(blk_queued_rq(rq));
 
+	if (rq == &q->flush_rq)
+		q->flush_exclusive_running = 0;
 	elv_requeue_request(q, rq);
 }
 EXPORT_SYMBOL(blk_requeue_request);
@@ -1847,6 +1849,15 @@ struct request *blk_peek_request(struct
 	int ret;
 
 	while ((rq = __elv_next_request(q)) != NULL) {
+		/*
+		 * If flush isn't queueable and is running, we delay normal
+		 * requets. Normal requests will get requeued even we don't delay
+		 * them and this gives us a chance to batch flush requests.
+		 */
+		if (q->flush_exclusive_running) {
+			q->flush_queue_delayed = 1;
+			return NULL;
+		}
 		if (!(rq->cmd_flags & REQ_STARTED)) {
 			/*
 			 * This is the first time the device driver
@@ -1961,6 +1972,7 @@ void blk_dequeue_request(struct request
  */
 void blk_start_request(struct request *req)
 {
+	struct request_queue *q = req->q;
 	blk_dequeue_request(req);
 
 	/*
@@ -1972,6 +1984,8 @@ void blk_start_request(struct request *r
 		req->next_rq->resid_len = blk_rq_bytes(req->next_rq);
 
 	blk_add_timer(req);
+	if (req == &q->flush_rq && !blk_queue_flush_queueable(q))
+		q->flush_exclusive_running = 1;
 }
 EXPORT_SYMBOL(blk_start_request);
 


