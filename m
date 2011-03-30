Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755745Ab1C3KQQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 06:16:16 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:48607 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754925Ab1C3KQO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 06:16:14 -0400
Message-ID: <4D9302ED.4030807@kernel.dk>
Date: Wed, 30 Mar 2011 12:16:13 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Vivek Goyal <vgoyal@redhat.com>, Jeff Moyer <jmoyer@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        linux-kernel@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] block: eliminate ELEVATOR_INSERT_REQUEUE
References: <20110325185455.GA2969@redhat.com> <4D8CF202.9010809@kernel.dk> <20110326042156.GB28458@redhat.com> <20110328082321.GC16530@htj.dyndns.org> <20110328221547.GA1118@redhat.com> <x49y63yvwum.fsf@segfault.boston.devel.redhat.com> <20110329175458.GE24485@redhat.com> <20110330074123.GA17523@htj.dyndns.org> <20110330075752.GC17523@htj.dyndns.org> <4D92E2CD.6000909@kernel.dk> <20110330080203.GD17523@htj.dyndns.org>
In-Reply-To: <20110330080203.GD17523@htj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-03-30 10:02, Tejun Heo wrote:
> Hello, Jens.
> 
> On Wed, Mar 30, 2011 at 09:59:09AM +0200, Jens Axboe wrote:
>> Pure front insert should be used for requeue and internal commands (like
>> spin up this drive, or get error information). Flush should append to
>> the dispatch list.
> 
> Yeah, right.  The reason I used REQUEUE/FRONT was because BACK
> insertion involves draining the elevator and then appending the
> request at the end of the dispatch queue, which is unnecessary and
> inefficient.  So, front insertion was a quick work around that.  If
> we're removing elv_insert(), we can just append directly to the
> dispatch queue from flush code.

How does this look? It's really two patches, but rolled up into one for
easier posting here.

diff --git a/block/blk-flush.c b/block/blk-flush.c
index 93d5fd8..6a16fea 100644
--- a/block/blk-flush.c
+++ b/block/blk-flush.c
@@ -261,7 +261,7 @@ static bool blk_kick_flush(struct request_queue *q)
 	q->flush_rq.end_io = flush_end_io;
 
 	q->flush_pending_idx ^= 1;
-	elv_insert(q, &q->flush_rq, ELEVATOR_INSERT_REQUEUE);
+	__elv_add_request(q, &q->flush_rq, ELEVATOR_INSERT_FLUSH);
 	return true;
 }
 
@@ -281,7 +281,7 @@ static void flush_data_end_io(struct request *rq, int error)
  * blk_insert_flush - insert a new FLUSH/FUA request
  * @rq: request to insert
  *
- * To be called from elv_insert() for %ELEVATOR_INSERT_FLUSH insertions.
+ * To be called from __elv_add_request() for %ELEVATOR_INSERT_FLUSH insertions.
  * @rq is being submitted.  Analyze what needs to be done and put it on the
  * right queue.
  *
@@ -312,7 +312,7 @@ void blk_insert_flush(struct request *rq)
 	 */
 	if ((policy & REQ_FSEQ_DATA) &&
 	    !(policy & (REQ_FSEQ_PREFLUSH | REQ_FSEQ_POSTFLUSH))) {
-		list_add(&rq->queuelist, &q->queue_head);
+		list_add_tail(&rq->queuelist, &q->queue_head);
 		return;
 	}
 
diff --git a/block/elevator.c b/block/elevator.c
index c387d31..0cdb4e7 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -610,7 +610,7 @@ void elv_requeue_request(struct request_queue *q, struct request *rq)
 
 	rq->cmd_flags &= ~REQ_STARTED;
 
-	elv_insert(q, rq, ELEVATOR_INSERT_REQUEUE);
+	__elv_add_request(q, rq, ELEVATOR_INSERT_REQUEUE);
 }
 
 void elv_drain_elevator(struct request_queue *q)
@@ -655,12 +655,25 @@ void elv_quiesce_end(struct request_queue *q)
 	queue_flag_clear(QUEUE_FLAG_ELVSWITCH, q);
 }
 
-void elv_insert(struct request_queue *q, struct request *rq, int where)
+void __elv_add_request(struct request_queue *q, struct request *rq, int where)
 {
 	trace_block_rq_insert(q, rq);
 
 	rq->q = q;
 
+	BUG_ON(rq->cmd_flags & REQ_ON_PLUG);
+
+	if (rq->cmd_flags & REQ_SOFTBARRIER) {
+		/* barriers are scheduling boundary, update end_sector */
+		if (rq->cmd_type == REQ_TYPE_FS ||
+		    (rq->cmd_flags & REQ_DISCARD)) {
+			q->end_sector = rq_end_sector(rq);
+			q->boundary_rq = rq;
+		}
+	} else if (!(rq->cmd_flags & REQ_ELVPRIV) &&
+		    where == ELEVATOR_INSERT_SORT)
+		where = ELEVATOR_INSERT_BACK;
+
 	switch (where) {
 	case ELEVATOR_INSERT_REQUEUE:
 	case ELEVATOR_INSERT_FRONT:
@@ -722,24 +735,6 @@ void elv_insert(struct request_queue *q, struct request *rq, int where)
 		BUG();
 	}
 }
-
-void __elv_add_request(struct request_queue *q, struct request *rq, int where)
-{
-	BUG_ON(rq->cmd_flags & REQ_ON_PLUG);
-
-	if (rq->cmd_flags & REQ_SOFTBARRIER) {
-		/* barriers are scheduling boundary, update end_sector */
-		if (rq->cmd_type == REQ_TYPE_FS ||
-		    (rq->cmd_flags & REQ_DISCARD)) {
-			q->end_sector = rq_end_sector(rq);
-			q->boundary_rq = rq;
-		}
-	} else if (!(rq->cmd_flags & REQ_ELVPRIV) &&
-		    where == ELEVATOR_INSERT_SORT)
-		where = ELEVATOR_INSERT_BACK;
-
-	elv_insert(q, rq, where);
-}
 EXPORT_SYMBOL(__elv_add_request);
 
 void elv_add_request(struct request_queue *q, struct request *rq, int where)
diff --git a/include/linux/elevator.h b/include/linux/elevator.h
index d93efcc445..21a8ebf 100644
--- a/include/linux/elevator.h
+++ b/include/linux/elevator.h
@@ -101,7 +101,6 @@ extern void elv_dispatch_sort(struct request_queue *, struct request *);
 extern void elv_dispatch_add_tail(struct request_queue *, struct request *);
 extern void elv_add_request(struct request_queue *, struct request *, int);
 extern void __elv_add_request(struct request_queue *, struct request *, int);
-extern void elv_insert(struct request_queue *, struct request *, int);
 extern int elv_merge(struct request_queue *, struct request **, struct bio *);
 extern int elv_try_merge(struct request *, struct bio *);
 extern void elv_merge_requests(struct request_queue *, struct request *,

-- 
Jens Axboe

