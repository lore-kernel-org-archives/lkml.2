Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755074Ab0KPQsh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 11:48:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49451 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751575Ab0KPQsf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 11:48:35 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Richard Kralovic <Richard.Kralovic@dcs.fmph.uniba.sk>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk
Subject: Re: CFQ and dm-crypt
References: <4CC439ED.8090400@dcs.fmph.uniba.sk>
	<x49y69b6qg6.fsf@segfault.boston.devel.redhat.com>
	<4CD185C2.8000006@dcs.fmph.uniba.sk>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Tue, 16 Nov 2010 11:44:08 -0500
In-Reply-To: <4CD185C2.8000006@dcs.fmph.uniba.sk> (Richard Kralovic's message
	of "Wed, 03 Nov 2010 16:54:42 +0100")
Message-ID: <x497hgdqkvb.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Richard Kralovic <Richard.Kralovic@dcs.fmph.uniba.sk> writes:

> On 11/03/10 04:23, Jeff Moyer wrote:
>>> > CFQ io scheduler relies on using task_struct current to determine which
>>> > process makes the io request. On the other hand, some dm modules (such
>>> > as dm-crypt) use separate threads for doing io. As CFQ sees only these
>>> > threads, it provides a very poor performance in such a case.
>>> >
>>> > IMHO the correct solution for this would be to store, for every io
>>> > request, the process that initiated it (and preserve this information
>>> > while the request is processed by device mapper). Would that be feasible?
>> Sure.  Try the attached patch (still an rfc) and let us know how it
>> goes.  In my environment, it speed up multiple concurrent buffered
>> readers.  I wasn't able to do a full analysis via blktrace as 2.6.37-rc1
>> seems to have broken blktrace support on my system.
>
> Thanks for the patch. Unfortunately, I got a kernel panic quite soon
> after booting the patched kernel. I was not able to reproduce the
> panic in a virtual machine, so I had to manually note the backtrace,
> thus I apologize that it's incomplete:

Hi, Richard,

I have another patch for you to try.  This one holds up pretty well in
my testing using a dm-crypt target.  Without the patch, I see no
priority separation:

total data transferred: 882080
class	prio	ideal	xferred	%diff
be	0	180425	110068	-39
be	1	160378	110580	-32
be	2	140330	110068	-22
be	3	120283	110580	-9
be	4	100236	110068	9
be	5	80189	110580	37
be	6	60141	110068	83
be	7	40094	110068	174

After the patch, there is definitely differentiated service:

total data transferred: 899716
class	prio	ideal	xferred	%diff
be	0	184032	388084	110
be	1	163584	191476	17
be	2	143136	125428	-13
be	3	122688	70644	-43
be	4	102240	53976	-48
be	5	81792	36212	-56
be	6	61344	20852	-67
be	7	40896	13044	-69

I've yet to make changes to the cfq_get_cfqg function to take advantage
of the io_context passing, but it should be simple enough, and can be
added as a follow-on patch.

So, give it a try and let me know how you fare.

Cheers,
Jeff

Signed-off-by: Jeff Moyer <jmoyer@redhat.com>

---
 block/blk-core.c          |   39 ++++++++++++++++++++++++++-------------
 block/blk-ioc.c           |    3 ++-
 block/cfq-iosched.c       |   36 ++++++++++++++++++++++--------------
 block/elevator.c          |    9 +++++----
 drivers/block/pktcdvd.c   |    3 +++
 drivers/md/dm-crypt.c     |    1 +
 drivers/md/multipath.c    |    3 +++
 fs/bio.c                  |    7 +++++++
 include/linux/blk_types.h |    2 ++
 include/linux/elevator.h  |   10 ++++++----
 include/linux/iocontext.h |   15 +++++++++++++++
 mm/bounce.c               |    2 ++
 12 files changed, 94 insertions(+), 36 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index f0834e2..1108a9b 100644
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
 
-	may_queue = elv_may_queue(q, rw_flags);
+	if (bio && bio->bi_io_context)
+		ioc = bio->bi_io_context;
+	else
+		ioc = current_io_context(GFP_ATOMIC, q->node);
+
+	may_queue = elv_may_queue(q, ioc, rw_flags);
 	if (may_queue == ELV_MQUEUE_NO)
 		goto rq_starved;
 
-	if (rl->count[is_sync]+1 >= queue_congestion_on_threshold(q)) {
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
@@ -1621,6 +1631,9 @@ void submit_bio(int rw, struct bio *bio)
 
 	bio->bi_rw |= rw;
 
+	if (!bio->bi_io_context)
+		bio->bi_io_context = get_io_context(GFP_NOIO, -1);
+
 	/*
 	 * If it's a regular read/write or a barrier with data attached,
 	 * go through the normal accounting stuff before submission.
diff --git a/block/blk-ioc.c b/block/blk-ioc.c
index d22c4c5..3580d63 100644
--- a/block/blk-ioc.c
+++ b/block/blk-ioc.c
@@ -91,7 +91,8 @@ struct io_context *alloc_io_context(gfp_t gfp_flags, int node)
 		atomic_set(&ret->nr_tasks, 1);
 		spin_lock_init(&ret->lock);
 		ret->ioprio_changed = 0;
-		ret->ioprio = 0;
+		ret->ioprio = task_nice_ioprio(current);
+		ret->ioprio_class = task_nice_ioclass(current);
 		ret->last_waited = 0; /* doesn't matter... */
 		ret->nr_batch_requests = 0; /* because this is 0 */
 		INIT_RADIX_TREE(&ret->radix_root, GFP_ATOMIC | __GFP_HIGH);
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 4cd59b0..faa5e1f 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -1477,11 +1477,14 @@ static void cfq_reposition_rq_rb(struct cfq_queue *cfqq, struct request *rq)
 static struct request *
 cfq_find_rq_fmerge(struct cfq_data *cfqd, struct bio *bio)
 {
-	struct task_struct *tsk = current;
+	struct io_context *ioc = bio->bi_io_context;
 	struct cfq_io_context *cic;
 	struct cfq_queue *cfqq;
 
-	cic = cfq_cic_lookup(cfqd, tsk->io_context);
+	if (!ioc)
+		ioc = current->io_context;
+
+	cic = cfq_cic_lookup(cfqd, ioc);
 	if (!cic)
 		return NULL;
 
@@ -1594,6 +1597,10 @@ static int cfq_allow_merge(struct request_queue *q, struct request *rq,
 	struct cfq_data *cfqd = q->elevator->elevator_data;
 	struct cfq_io_context *cic;
 	struct cfq_queue *cfqq;
+	struct io_context *ioc = bio->bi_io_context;
+
+	if (!ioc)
+		ioc = current->io_context;
 
 	/*
 	 * Disallow merge of a sync bio into an async request.
@@ -1605,7 +1612,7 @@ static int cfq_allow_merge(struct request_queue *q, struct request *rq,
 	 * Lookup the cfqq that this bio will be queued with. Allow
 	 * merge only if rq is queued there.
 	 */
-	cic = cfq_cic_lookup(cfqd, current->io_context);
+	cic = cfq_cic_lookup(cfqd, ioc);
 	if (!cic)
 		return false;
 
@@ -2760,7 +2767,6 @@ cfq_alloc_io_context(struct cfq_data *cfqd, gfp_t gfp_mask)
 
 static void cfq_init_prio_data(struct cfq_queue *cfqq, struct io_context *ioc)
 {
-	struct task_struct *tsk = current;
 	int ioprio_class;
 
 	if (!cfq_cfqq_prio_changed(cfqq))
@@ -2774,8 +2780,8 @@ static void cfq_init_prio_data(struct cfq_queue *cfqq, struct io_context *ioc)
 		/*
 		 * no prio set, inherit CPU scheduling settings
 		 */
-		cfqq->ioprio = task_nice_ioprio(tsk);
-		cfqq->ioprio_class = task_nice_ioclass(tsk);
+		cfqq->ioprio = task_ioprio(ioc);
+		cfqq->ioprio_class = ioc->ioprio_class;
 		break;
 	case IOPRIO_CLASS_RT:
 		cfqq->ioprio = task_ioprio(ioc);
@@ -3094,14 +3100,16 @@ static int cfq_cic_link(struct cfq_data *cfqd, struct io_context *ioc,
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
 
@@ -3546,10 +3554,9 @@ static inline int __cfq_may_queue(struct cfq_queue *cfqq)
 	return ELV_MQUEUE_MAY;
 }
 
-static int cfq_may_queue(struct request_queue *q, int rw)
+static int cfq_may_queue(struct request_queue *q, struct io_context *ioc, int rw)
 {
 	struct cfq_data *cfqd = q->elevator->elevator_data;
-	struct task_struct *tsk = current;
 	struct cfq_io_context *cic;
 	struct cfq_queue *cfqq;
 
@@ -3559,7 +3566,7 @@ static int cfq_may_queue(struct request_queue *q, int rw)
 	 * so just lookup a possibly existing queue, or return 'may queue'
 	 * if that fails
 	 */
-	cic = cfq_cic_lookup(cfqd, tsk->io_context);
+	cic = cfq_cic_lookup(cfqd, ioc);
 	if (!cic)
 		return ELV_MQUEUE_MAY;
 
@@ -3636,7 +3643,8 @@ split_cfqq(struct cfq_io_context *cic, struct cfq_queue *cfqq)
  * Allocate cfq data structures associated with this request.
  */
 static int
-cfq_set_request(struct request_queue *q, struct request *rq, gfp_t gfp_mask)
+cfq_set_request(struct request_queue *q, struct request *rq,
+		struct io_context *ioc, gfp_t gfp_mask)
 {
 	struct cfq_data *cfqd = q->elevator->elevator_data;
 	struct cfq_io_context *cic;
@@ -3647,7 +3655,7 @@ cfq_set_request(struct request_queue *q, struct request *rq, gfp_t gfp_mask)
 
 	might_sleep_if(gfp_mask & __GFP_WAIT);
 
-	cic = cfq_get_io_context(cfqd, gfp_mask);
+	cic = cfq_get_io_context(cfqd, ioc, gfp_mask);
 
 	spin_lock_irqsave(q->queue_lock, flags);
 
diff --git a/block/elevator.c b/block/elevator.c
index 282e830..5344556 100644
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
@@ -771,12 +772,12 @@ void elv_put_request(struct request_queue *q, struct request *rq)
 		e->ops->elevator_put_req_fn(rq);
 }
 
-int elv_may_queue(struct request_queue *q, int rw)
+int elv_may_queue(struct request_queue *q, struct io_context *ioc, int rw)
 {
 	struct elevator_queue *e = q->elevator;
 
 	if (e->ops->elevator_may_queue_fn)
-		return e->ops->elevator_may_queue_fn(q, rw);
+		return e->ops->elevator_may_queue_fn(q, ioc, rw);
 
 	return ELV_MQUEUE_MAY;
 }
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
diff --git a/drivers/md/multipath.c b/drivers/md/multipath.c
index 6d7ddf3..19b106e 100644
--- a/drivers/md/multipath.c
+++ b/drivers/md/multipath.c
@@ -166,6 +166,7 @@ static int multipath_make_request(mddev_t *mddev, struct bio * bio)
 	mp_bh->bio.bi_rw |= REQ_FAILFAST_TRANSPORT;
 	mp_bh->bio.bi_end_io = multipath_end_request;
 	mp_bh->bio.bi_private = mp_bh;
+	mp_bh->bio.bi_io_context = ioc_object_link(bio->bi_io_context);
 	generic_make_request(&mp_bh->bio);
 	return 0;
 }
@@ -401,6 +402,8 @@ static void multipathd (mddev_t *mddev)
 			bio->bi_rw |= REQ_FAILFAST_TRANSPORT;
 			bio->bi_end_io = multipath_end_request;
 			bio->bi_private = mp_bh;
+			bio->bi_io_context =
+				ioc_object_link(mp_bh->bio->bi_io_context);
 			generic_make_request(bio);
 		}
 	}
diff --git a/fs/bio.c b/fs/bio.c
index 8abb2df..1e5beeb 100644
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
@@ -1505,6 +1509,9 @@ struct bio_pair *bio_split(struct bio *bi, int first_sectors)
 	bp->bio1.bi_private = bi;
 	bp->bio2.bi_private = bio_split_pool;
 
+	bp->bio1.bi_io_context = ioc_object_link(bi->bi_io_context);
+	bp->bio2.bi_io_context = ioc_object_link(bi->bi_io_context);
+
 	if (bio_integrity(bi))
 		bio_integrity_split(bi, bp, first_sectors);
 
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
index 4fd978e..ffe8ab1 100644
--- a/include/linux/elevator.h
+++ b/include/linux/elevator.h
@@ -23,9 +23,10 @@ typedef void (elevator_add_req_fn) (struct request_queue *, struct request *);
 typedef int (elevator_queue_empty_fn) (struct request_queue *);
 typedef struct request *(elevator_request_list_fn) (struct request_queue *, struct request *);
 typedef void (elevator_completed_req_fn) (struct request_queue *, struct request *);
-typedef int (elevator_may_queue_fn) (struct request_queue *, int);
+typedef int (elevator_may_queue_fn) (struct request_queue *, struct io_context *, int);
 
-typedef int (elevator_set_req_fn) (struct request_queue *, struct request *, gfp_t);
+typedef int (elevator_set_req_fn) (struct request_queue *, struct request *,
+				   struct io_context *, gfp_t);
 typedef void (elevator_put_req_fn) (struct request *);
 typedef void (elevator_activate_req_fn) (struct request_queue *, struct request *);
 typedef void (elevator_deactivate_req_fn) (struct request_queue *, struct request *);
@@ -116,10 +117,11 @@ extern struct request *elv_former_request(struct request_queue *, struct request
 extern struct request *elv_latter_request(struct request_queue *, struct request *);
 extern int elv_register_queue(struct request_queue *q);
 extern void elv_unregister_queue(struct request_queue *q);
-extern int elv_may_queue(struct request_queue *, int);
+extern int elv_may_queue(struct request_queue *, struct io_context *, int);
 extern void elv_abort_queue(struct request_queue *);
 extern void elv_completed_request(struct request_queue *, struct request *);
-extern int elv_set_request(struct request_queue *, struct request *, gfp_t);
+extern int elv_set_request(struct request_queue *, struct request *,
+			   struct io_context *, gfp_t);
 extern void elv_put_request(struct request_queue *, struct request *);
 extern void elv_drain_elevator(struct request_queue *);
 
diff --git a/include/linux/iocontext.h b/include/linux/iocontext.h
index 3e70b21..a4a3201 100644
--- a/include/linux/iocontext.h
+++ b/include/linux/iocontext.h
@@ -40,6 +40,7 @@ struct io_context {
 
 	unsigned short ioprio;
 	unsigned short ioprio_changed;
+	unsigned short ioprio_class;
 
 #if defined(CONFIG_BLK_CGROUP) || defined(CONFIG_BLK_CGROUP_MODULE)
 	unsigned short cgroup_changed;
@@ -70,6 +71,20 @@ static inline struct io_context *ioc_task_link(struct io_context *ioc)
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
 			
 
