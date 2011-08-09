Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752999Ab1HIPFl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 11:05:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57026 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751778Ab1HIPFk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 11:05:40 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <jaxboe@fusionio.com>,
        Mike Snitzer <msnitzer@redhat.com>, Vivek Goyal <vgoyal@redhat.com>
Subject: [patch] block: properly handle flush/fua requests in blk_insert_cloned_request
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Tue, 09 Aug 2011 11:05:34 -0400
Message-ID: <x49y5z2eibl.fsf@segfault.boston.devel.redhat.com>
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

I've attached a fix for this.  Since request-based dm operates below the
elevator, the flush sequencing is done above dm.  So, when a flush
request is cloned and handed off to blk_insert_clone_request, we need to
preserve the REQ_FLUSH_SEQ flag, and put the request directly on the
queue (no need to go through the flush machinery again).  In the case of
an empty flush where the underlying device does not advertise a
write-back cache, we can simply complete the request.

This patch regains the lost performance.  Comments, as always, are
appreciated.

Cheers,
Jeff

Signed-off-by: Jeff Moyer <jmoyer@redhat.com>

diff --git a/block/blk-core.c b/block/blk-core.c
index b850bed..c4213c1 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -39,6 +39,8 @@ EXPORT_TRACEPOINT_SYMBOL_GPL(block_rq_remap);
 EXPORT_TRACEPOINT_SYMBOL_GPL(block_bio_complete);
 
 static int __make_request(struct request_queue *q, struct bio *bio);
+static bool blk_end_bidi_request(struct request *rq, int error,
+				 unsigned int nr_bytes, unsigned int bidi_bytes);
 
 /*
  * For the allocated request tables
@@ -1708,6 +1710,21 @@ int blk_insert_cloned_request(struct request_queue *q, struct request *rq)
 	    should_fail_request(&rq->rq_disk->part0, blk_rq_bytes(rq)))
 		return -EIO;
 
+	/*
+	 * Check the cmd_flags against the flush flags of the underlying
+	 * request_queue and resolve any differences.
+	 */
+	if (rq->cmd_flags & (REQ_FLUSH|REQ_FUA)) {
+		if (!(q->flush_flags & REQ_FLUSH))
+			rq->cmd_flags &= ~REQ_FLUSH;
+		if (!(q->flush_flags & REQ_FUA))
+			rq->cmd_flags &= ~REQ_FUA;
+		if (!(rq->cmd_flags & REQ_FLUSH) && !blk_rq_sectors(rq)) {
+			blk_end_bidi_request(rq, 0, 0, 0);
+			return 0;
+		}
+	}
+
 	spin_lock_irqsave(q->queue_lock, flags);
 
 	/*
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 6395692..4fe753f 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -168,7 +168,7 @@ enum rq_flag_bits {
 #define REQ_COMMON_MASK \
 	(REQ_WRITE | REQ_FAILFAST_MASK | REQ_SYNC | REQ_META | REQ_DISCARD | \
 	 REQ_NOIDLE | REQ_FLUSH | REQ_FUA | REQ_SECURE)
-#define REQ_CLONE_MASK		REQ_COMMON_MASK
+#define REQ_CLONE_MASK		(REQ_COMMON_MASK | REQ_FLUSH_SEQ)
 
 #define REQ_RAHEAD		(1 << __REQ_RAHEAD)
 #define REQ_THROTTLED		(1 << __REQ_THROTTLED)
