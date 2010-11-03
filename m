Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753369Ab0KCD0k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 23:26:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34259 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751961Ab0KCD0i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 23:26:38 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Richard Kralovic <Richard.Kralovic@dcs.fmph.uniba.sk>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk
Subject: Re: CFQ and dm-crypt
References: <4CC439ED.8090400@dcs.fmph.uniba.sk>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Tue, 02 Nov 2010 23:23:05 -0400
In-Reply-To: <4CC439ED.8090400@dcs.fmph.uniba.sk> (Richard Kralovic's message
	of "Sun, 24 Oct 2010 15:51:41 +0200")
Message-ID: <x49y69b6qg6.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Richard Kralovic <Richard.Kralovic@dcs.fmph.uniba.sk> writes:

> CFQ io scheduler relies on using task_struct current to determine which
> process makes the io request. On the other hand, some dm modules (such
> as dm-crypt) use separate threads for doing io. As CFQ sees only these
> threads, it provides a very poor performance in such a case.
>
> IMHO the correct solution for this would be to store, for every io
> request, the process that initiated it (and preserve this information
> while the request is processed by device mapper). Would that be feasible?

Sure.  Try the attached patch (still an rfc) and let us know how it
goes.  In my environment, it speed up multiple concurrent buffered
readers.  I wasn't able to do a full analysis via blktrace as 2.6.37-rc1
seems to have broken blktrace support on my system.

Cheers,
Jeff

Signed-off-by: Jeff Moyer <jmoyer@redhat.com>

diff --git a/block/blk-core.c b/block/blk-core.c
index f0834e2..c830480 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -656,7 +656,8 @@ static inline void blk_free_request(struct request_queue *q, struct request *rq)
 }
 
 static struct request *
-blk_alloc_request(struct request_queue *q, int flags, int priv, gfp_t gfp_mask)
+blk_alloc_request(struct request_queue *q, int flags, int priv,
+		  struct io_context *ioc, gfp_t gfp_mask)
 {
 	struct request *rq = mempool_alloc(q->rq.rq_pool, gfp_mask);
 
@@ -668,7 +669,7 @@ blk_alloc_request(struct request_queue *q, int flags, int priv, gfp_t gfp_mask)
 	rq->cmd_flags = flags | REQ_ALLOCED;
 
 	if (priv) {
-		if (unlikely(elv_set_request(q, rq, gfp_mask))) {
+		if (unlikely(elv_set_request(q, rq, ioc, gfp_mask))) {
 			mempool_free(rq, q->rq.rq_pool);
 			return NULL;
 		}
@@ -755,17 +756,23 @@ static struct request *get_request(struct request_queue *q, int rw_flags,
 {
 	struct request *rq = NULL;
 	struct request_list *rl = &q->rq;
-	struct io_context *ioc = NULL;
+	struct io_context *ioc;
 	const bool is_sync = rw_is_sync(rw_flags) != 0;
+	bool congested;
 	int may_queue, priv;
 
 	may_queue = elv_may_queue(q, rw_flags);
 	if (may_queue == ELV_MQUEUE_NO)
 		goto rq_starved;
 
-	if (rl->count[is_sync]+1 >= queue_congestion_on_threshold(q)) {
+	if (bio && bio->bi_io_context)
+		ioc = bio->bi_io_context;
+	else
+		ioc = current_io_context(GFP_ATOMIC, q->node);
+
+	congested = !!(rl->count[is_sync]+1 >= queue_congestion_on_threshold(q));
+	if (congested) {
 		if (rl->count[is_sync]+1 >= q->nr_requests) {
-			ioc = current_io_context(GFP_ATOMIC, q->node);
 			/*
 			 * The queue will fill after this allocation, so set
 			 * it as full, and mark this process as "batching".
@@ -809,7 +816,7 @@ static struct request *get_request(struct request_queue *q, int rw_flags,
 		rw_flags |= REQ_IO_STAT;
 	spin_unlock_irq(q->queue_lock);
 
-	rq = blk_alloc_request(q, rw_flags, priv, gfp_mask);
+	rq = blk_alloc_request(q, rw_flags, priv, ioc, gfp_mask);
 	if (unlikely(!rq)) {
 		/*
 		 * Allocation failed presumably due to memory. Undo anything
@@ -836,12 +843,12 @@ rq_starved:
 	}
 
 	/*
-	 * ioc may be NULL here, and ioc_batching will be false. That's
-	 * OK, if the queue is under the request limit then requests need
-	 * not count toward the nr_batch_requests limit. There will always
-	 * be some limit enforced by BLK_BATCH_TIME.
+	 * If the queue is under the request limit (!congested) then
+	 * requests need not count toward the nr_batch_requests
+	 * limit. There will always be some limit enforced by
+	 * BLK_BATCH_TIME.
 	 */
-	if (ioc_batching(q, ioc))
+	if (congested && ioc_batching(q, ioc))
 		ioc->nr_batch_requests--;
 
 	trace_block_getrq(q, bio, rw_flags & 1);
@@ -882,7 +889,10 @@ static struct request *get_request_wait(struct request_queue *q, int rw_flags,
 		 * up to a big batch of them for a small period time.
 		 * See ioc_batching, ioc_set_batching
 		 */
-		ioc = current_io_context(GFP_NOIO, q->node);
+		if (bio && bio->bi_io_context)
+			ioc = bio->bi_io_context;
+		else
+			ioc = current_io_context(GFP_NOIO, q->node);
 		ioc_set_batching(q, ioc);
 
 		spin_lock_irq(q->queue_lock);
@@ -1621,6 +1631,11 @@ void submit_bio(int rw, struct bio *bio)
 
 	bio->bi_rw |= rw;
 
+	if (!bio->bi_io_context) {
+		might_sleep(); // XXX removeme
+		bio->bi_io_context = get_io_context(GFP_NOIO, -1);
+	}
+
 	/*
 	 * If it's a regular read/write or a barrier with data attached,
 	 * go through the normal accounting stuff before submission.
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 4cd59b0..0846962 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -3094,14 +3094,16 @@ static int cfq_cic_link(struct cfq_data *cfqd, struct io_context *ioc,
  * than one device managed by cfq.
  */
 static struct cfq_io_context *
-cfq_get_io_context(struct cfq_data *cfqd, gfp_t gfp_mask)
+cfq_get_io_context(struct cfq_data *cfqd, struct io_context *ioc, gfp_t gfp_mask)
 {
-	struct io_context *ioc = NULL;
 	struct cfq_io_context *cic;
 
 	might_sleep_if(gfp_mask & __GFP_WAIT);
 
-	ioc = get_io_context(gfp_mask, cfqd->queue->node);
+	if (ioc)
+		atomic_long_inc(&ioc->refcount);
+	else
+		ioc = get_io_context(gfp_mask, cfqd->queue->node);
 	if (!ioc)
 		return NULL;
 
@@ -3636,7 +3638,8 @@ split_cfqq(struct cfq_io_context *cic, struct cfq_queue *cfqq)
  * Allocate cfq data structures associated with this request.
  */
 static int
-cfq_set_request(struct request_queue *q, struct request *rq, gfp_t gfp_mask)
+cfq_set_request(struct request_queue *q, struct request *rq,
+		struct io_context *ioc, gfp_t gfp_mask)
 {
 	struct cfq_data *cfqd = q->elevator->elevator_data;
 	struct cfq_io_context *cic;
@@ -3647,7 +3650,7 @@ cfq_set_request(struct request_queue *q, struct request *rq, gfp_t gfp_mask)
 
 	might_sleep_if(gfp_mask & __GFP_WAIT);
 
-	cic = cfq_get_io_context(cfqd, gfp_mask);
+	cic = cfq_get_io_context(cfqd, ioc, gfp_mask);
 
 	spin_lock_irqsave(q->queue_lock, flags);
 
diff --git a/block/elevator.c b/block/elevator.c
index 282e830..872978f 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -752,12 +752,13 @@ struct request *elv_former_request(struct request_queue *q, struct request *rq)
 	return NULL;
 }
 
-int elv_set_request(struct request_queue *q, struct request *rq, gfp_t gfp_mask)
+int elv_set_request(struct request_queue *q, struct request *rq,
+		    struct io_context *ioc, gfp_t gfp_mask)
 {
 	struct elevator_queue *e = q->elevator;
 
 	if (e->ops->elevator_set_req_fn)
-		return e->ops->elevator_set_req_fn(q, rq, gfp_mask);
+		return e->ops->elevator_set_req_fn(q, rq, ioc, gfp_mask);
 
 	rq->elevator_private = NULL;
 	return 0;
diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index 19b3568..f00ffcb 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -1077,6 +1077,7 @@ static void pkt_gather_data(struct pktcdvd_device *pd, struct packet_data *pkt)
 {
 	int frames_read = 0;
 	struct bio *bio;
+	struct io_context *orig_ioc = NULL;
 	int f;
 	char written[PACKET_MAX_SIZE];
 
@@ -1098,6 +1099,7 @@ static void pkt_gather_data(struct pktcdvd_device *pd, struct packet_data *pkt)
 		BUG_ON(first_frame + num_frames > pkt->frames);
 		for (f = first_frame; f < first_frame + num_frames; f++)
 			written[f] = 1;
+		orig_ioc = bio->bi_io_context;
 	}
 	spin_unlock(&pkt->lock);
 
@@ -1126,6 +1128,7 @@ static void pkt_gather_data(struct pktcdvd_device *pd, struct packet_data *pkt)
 		bio->bi_private = pkt;
 		bio->bi_io_vec = vec;
 		bio->bi_destructor = pkt_bio_destructor;
+		bio->bi_io_context = ioc_object_link(orig_ioc);
 
 		p = (f * CD_FRAMESIZE) / PAGE_SIZE;
 		offset = (f * CD_FRAMESIZE) % PAGE_SIZE;
diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index d5b0e4c..757dd30 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -689,6 +689,7 @@ static void clone_init(struct dm_crypt_io *io, struct bio *clone)
 	clone->bi_bdev    = cc->dev->bdev;
 	clone->bi_rw      = io->base_bio->bi_rw;
 	clone->bi_destructor = dm_crypt_bio_destructor;
+	clone->bi_io_context = ioc_object_link(io->base_bio->bi_io_context);
 }
 
 static void kcryptd_io_read(struct dm_crypt_io *io)
diff --git a/fs/bio.c b/fs/bio.c
index 8abb2df..0863530 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -456,6 +456,7 @@ void __bio_clone(struct bio *bio, struct bio *bio_src)
 	bio->bi_vcnt = bio_src->bi_vcnt;
 	bio->bi_size = bio_src->bi_size;
 	bio->bi_idx = bio_src->bi_idx;
+	bio->bi_io_context = ioc_object_link(bio_src->bi_io_context);
 }
 EXPORT_SYMBOL(__bio_clone);
 
@@ -1428,6 +1429,9 @@ void bio_endio(struct bio *bio, int error)
 	else if (!test_bit(BIO_UPTODATE, &bio->bi_flags))
 		error = -EIO;
 
+	put_io_context(bio->bi_io_context);
+	bio->bi_io_context = NULL;
+
 	if (bio->bi_end_io)
 		bio->bi_end_io(bio, error);
 }
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 0437ab6..46c20d8 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -74,6 +74,8 @@ struct bio {
 
 	bio_destructor_t	*bi_destructor;	/* destructor */
 
+	struct io_context	*bi_io_context;
+
 	/*
 	 * We can inline a number of vecs at the end of the bio, to avoid
 	 * double allocations for a small number of bio_vecs. This member
diff --git a/include/linux/elevator.h b/include/linux/elevator.h
index 4fd978e..c07cb02 100644
--- a/include/linux/elevator.h
+++ b/include/linux/elevator.h
@@ -25,7 +25,8 @@ typedef struct request *(elevator_request_list_fn) (struct request_queue *, stru
 typedef void (elevator_completed_req_fn) (struct request_queue *, struct request *);
 typedef int (elevator_may_queue_fn) (struct request_queue *, int);
 
-typedef int (elevator_set_req_fn) (struct request_queue *, struct request *, gfp_t);
+typedef int (elevator_set_req_fn) (struct request_queue *, struct request *,
+				   struct io_context *, gfp_t);
 typedef void (elevator_put_req_fn) (struct request *);
 typedef void (elevator_activate_req_fn) (struct request_queue *, struct request *);
 typedef void (elevator_deactivate_req_fn) (struct request_queue *, struct request *);
@@ -119,7 +120,8 @@ extern void elv_unregister_queue(struct request_queue *q);
 extern int elv_may_queue(struct request_queue *, int);
 extern void elv_abort_queue(struct request_queue *);
 extern void elv_completed_request(struct request_queue *, struct request *);
-extern int elv_set_request(struct request_queue *, struct request *, gfp_t);
+extern int elv_set_request(struct request_queue *, struct request *,
+			   struct io_context *, gfp_t);
 extern void elv_put_request(struct request_queue *, struct request *);
 extern void elv_drain_elevator(struct request_queue *);
 
diff --git a/include/linux/iocontext.h b/include/linux/iocontext.h
index 3e70b21..0ac2acc 100644
--- a/include/linux/iocontext.h
+++ b/include/linux/iocontext.h
@@ -70,6 +70,20 @@ static inline struct io_context *ioc_task_link(struct io_context *ioc)
 	return NULL;
 }
 
+/*
+ * Helper function to increment the reference count on an io_context and
+ * return a pointer to said io_context.  This is used in places where a
+ * reference to the io_context is needed, but only if the io_context exists.
+ * It's different from ioc_task_link in that it does not increment the
+ * nr_tasks.
+ */
+static inline struct io_context *ioc_object_link(struct io_context *ioc)
+{
+	if (ioc)
+		atomic_long_inc(&ioc->refcount);
+	return ioc;
+}
+
 struct task_struct;
 #ifdef CONFIG_BLOCK
 int put_io_context(struct io_context *ioc);
diff --git a/mm/bounce.c b/mm/bounce.c
index 1481de6..e99e6e8 100644
--- a/mm/bounce.c
+++ b/mm/bounce.c
@@ -202,6 +202,8 @@ static void __blk_queue_bounce(struct request_queue *q, struct bio **bio_orig,
 
 			bio = bio_alloc(GFP_NOIO, cnt);
 			memset(bio->bi_io_vec, 0, cnt * sizeof(struct bio_vec));
+			bio->bi_io_context =
+				ioc_object_link((*bio_orig)->bi_io_context);
 		}
 			
 
