Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754209Ab1HLTIJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 15:08:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51608 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753707Ab1HLTIG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 15:08:06 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Tejun Heo <tj@kernel.org>, Jens Axboe <jaxboe@fusionio.com>
Cc: shaohua <shli@kernel.org>, Vivek Goyal <vgoyal@in.ibm.com>,
        dm-devel@redhat.com, linux-kernel@vger.kernel.org,
        Mike Snitzer <msnitzer@redhat.com>
Subject: [patch,v2] block: fix flush machinery for stacking drivers with differring flush flags
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Fri, 12 Aug 2011 15:07:51 -0400
Message-ID: <x497h6iphx4.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Commit ae1b1539622fb46e51b4d13b3f9e5f4c713f86ae, block: reimplement
FLUSH/FUA to support merge, introduced a performance regression when
running any sort of fsyncing workload using dm-multipath and certain
storage (in our case, an HP EVA).  The test I ran was fs_mark, and it
dropped from ~800 files/sec on ext4 to ~100 files/sec.  It turns out
that dm-multipath always advertised flush+fua support, and passed
commands on down the stack, where those flags used to get stripped off.
The above commit changed that behavior:

static inline struct request *__elv_next_request(struct request_queue *q)
{
        struct request *rq;

        while (1) {
-               while (!list_empty(&q->queue_head)) {
+               if (!list_empty(&q->queue_head)) {
                        rq = list_entry_rq(q->queue_head.next);
-                       if (!(rq->cmd_flags & (REQ_FLUSH | REQ_FUA)) ||
-                           (rq->cmd_flags & REQ_FLUSH_SEQ))
-                               return rq;
-                       rq = blk_do_flush(q, rq);
-                       if (rq)
-                               return rq;
+                       return rq;
                }

Note that previously, a command would come in here, have
REQ_FLUSH|REQ_FUA set, and then get handed off to blk_do_flush:

struct request *blk_do_flush(struct request_queue *q, struct request *rq)
{
        unsigned int fflags = q->flush_flags; /* may change, cache it */
        bool has_flush = fflags & REQ_FLUSH, has_fua = fflags & REQ_FUA;
        bool do_preflush = has_flush && (rq->cmd_flags & REQ_FLUSH);
        bool do_postflush = has_flush && !has_fua && (rq->cmd_flags &
        REQ_FUA);
        unsigned skip = 0;
...
        if (blk_rq_sectors(rq) && !do_preflush && !do_postflush) {
                rq->cmd_flags &= ~REQ_FLUSH;
		if (!has_fua)
			rq->cmd_flags &= ~REQ_FUA;
	        return rq;
	}

So, the flush machinery was bypassed in such cases (q->flush_flags == 0
&& rq->cmd_flags & (REQ_FLUSH|REQ_FUA)).

Now, however, we don't get into the flush machinery at all.  Instead,
__elv_next_request just hands a request with flush and fua bits set to
the scsi_request_fn, even if the underlying request_queue does not
support flush or fua.

The agreed upon approach is to fix the flush machinery to allow
stacking.  While this isn't used in practice (since there is only one
request-based dm target, and that target will now reflect the flush
flags of the underlying device), it does future-proof the solution, and
make it function as designed.

In order to make this work, I had to add a field to the struct request,
inside the flush structure (to store the original req->end_io).  Shaohua
had suggested overloading the union with rb_node and completion_data,
but the completion data is used by device mapper and can also be used by
other drivers.  So, I didn't see a way around the additional field.

I tested this patch on an HP EVA with both ext4 and xfs, and it recovers
the lost performance.  Comments and other testers, as always, are
appreciated.

Cheers,
Jeff

Signed-off-by: Jeff Moyer <jmoyer@redhat.com>

---
Changes from v1->v2:
- Moved the detection of empty flush requests into blk_insert_flush.
- Got rid of REQ_FLUSH_SEQ in the CLONE_FLAGS.

diff --git a/block/blk-core.c b/block/blk-core.c
index b850bed..7c59b0f 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1700,6 +1700,7 @@ EXPORT_SYMBOL_GPL(blk_rq_check_limits);
 int blk_insert_cloned_request(struct request_queue *q, struct request *rq)
 {
 	unsigned long flags;
+	int where = ELEVATOR_INSERT_BACK;
 
 	if (blk_rq_check_limits(q, rq))
 		return -EIO;
@@ -1716,7 +1717,10 @@ int blk_insert_cloned_request(struct request_queue *q, struct request *rq)
 	 */
 	BUG_ON(blk_queued_rq(rq));
 
-	add_acct_request(q, rq, ELEVATOR_INSERT_BACK);
+	if (rq->cmd_flags & (REQ_FLUSH|REQ_FUA))
+		where = ELEVATOR_INSERT_FLUSH;
+
+	add_acct_request(q, rq, where);
 	spin_unlock_irqrestore(q->queue_lock, flags);
 
 	return 0;
@@ -2273,7 +2277,7 @@ static bool blk_end_bidi_request(struct request *rq, int error,
  *     %false - we are done with this request
  *     %true  - still buffers pending for this request
  **/
-static bool __blk_end_bidi_request(struct request *rq, int error,
+bool __blk_end_bidi_request(struct request *rq, int error,
 				   unsigned int nr_bytes, unsigned int bidi_bytes)
 {
 	if (blk_update_bidi_request(rq, error, nr_bytes, bidi_bytes))
diff --git a/block/blk-flush.c b/block/blk-flush.c
index bb21e4c..f3ddce2 100644
--- a/block/blk-flush.c
+++ b/block/blk-flush.c
@@ -122,7 +122,7 @@ static void blk_flush_restore_request(struct request *rq)
 
 	/* make @rq a normal request */
 	rq->cmd_flags &= ~REQ_FLUSH_SEQ;
-	rq->end_io = NULL;
+	rq->end_io = rq->flush.saved_end_io;
 }
 
 /**
@@ -300,9 +300,6 @@ void blk_insert_flush(struct request *rq)
 	unsigned int fflags = q->flush_flags;	/* may change, cache */
 	unsigned int policy = blk_flush_policy(fflags, rq);
 
-	BUG_ON(rq->end_io);
-	BUG_ON(!rq->bio || rq->bio != rq->biotail);
-
 	/*
 	 * @policy now records what operations need to be done.  Adjust
 	 * REQ_FLUSH and FUA for the driver.
@@ -312,6 +309,19 @@ void blk_insert_flush(struct request *rq)
 		rq->cmd_flags &= ~REQ_FUA;
 
 	/*
+	 * An empty flush handed down from a stacking driver may
+	 * translate into nothing if the underlying device does not
+	 * advertise a write-back cache.  In this case, simply
+	 * complete the request.
+	 */
+	if (!policy && !blk_rq_bytes(rq)) {
+		__blk_end_bidi_request(rq, 0, 0, 0);
+		return;
+	}
+
+	BUG_ON(!rq->bio || rq->bio != rq->biotail);
+
+	/*
 	 * If there's data but flush is not necessary, the request can be
 	 * processed directly without going through flush machinery.  Queue
 	 * for normal execution.
@@ -319,6 +329,7 @@ void blk_insert_flush(struct request *rq)
 	if ((policy & REQ_FSEQ_DATA) &&
 	    !(policy & (REQ_FSEQ_PREFLUSH | REQ_FSEQ_POSTFLUSH))) {
 		list_add_tail(&rq->queuelist, &q->queue_head);
+		blk_run_queue_async(q);
 		return;
 	}
 
@@ -329,6 +340,7 @@ void blk_insert_flush(struct request *rq)
 	memset(&rq->flush, 0, sizeof(rq->flush));
 	INIT_LIST_HEAD(&rq->flush.list);
 	rq->cmd_flags |= REQ_FLUSH_SEQ;
+	rq->flush.saved_end_io = rq->end_io; /* Usually NULL */
 	rq->end_io = flush_data_end_io;
 
 	blk_flush_complete_seq(rq, REQ_FSEQ_ACTIONS & ~policy, 0);
diff --git a/block/blk.h b/block/blk.h
index d658628..20b900a 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -17,6 +17,8 @@ int blk_rq_append_bio(struct request_queue *q, struct request *rq,
 		      struct bio *bio);
 void blk_dequeue_request(struct request *rq);
 void __blk_queue_free_tags(struct request_queue *q);
+bool __blk_end_bidi_request(struct request *rq, int error,
+			    unsigned int nr_bytes, unsigned int bidi_bytes);
 
 void blk_rq_timed_out_timer(unsigned long data);
 void blk_delete_timer(struct request *);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 0e67c45..29efb26 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -117,6 +117,7 @@ struct request {
 		struct {
 			unsigned int		seq;
 			struct list_head	list;
+			rq_end_io_fn		*saved_end_io;
 		} flush;
 	};
 
