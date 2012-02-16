Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756000Ab2BPWiU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 17:38:20 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:57140 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755857Ab2BPWiR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 17:38:17 -0500
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, vgoyal@redhat.com
Cc: ctalbott@google.com, rni@google.com, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Kent Overstreet <koverstreet@google.com>
Subject: [PATCH 7/9] block: implement bio_associate_current()
Date: Thu, 16 Feb 2012 14:37:56 -0800
Message-Id: <1329431878-28300-8-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1329431878-28300-1-git-send-email-tj@kernel.org>
References: <1329431878-28300-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IO scheduling and cgroup are tied to the issuing task via io_context
and cgroup of %current.  Unfortunately, there are cases where IOs need
to be routed via a different task which makes scheduling and cgroup
limit enforcement applied completely incorrectly.

For example, all bios delayed by blk-throttle end up being issued by a
delayed work item and get assigned the io_context of the worker task
which happens to serve the work item and dumped to the default block
cgroup.  This is double confusing as bios which aren't delayed end up
in the correct cgroup and makes using blk-throttle and cfq propio
together impossible.

Any code which punts IO issuing to another task is affected which is
getting more and more common (e.g. btrfs).  As both io_context and
cgroup are firmly tied to task including userland visible APIs to
manipulate them, it makes a lot of sense to match up tasks to bios.

This patch implements bio_associate_current() which associates the
specified bio with %current.  The bio will record the associated ioc
and blkcg at that point and block layer will use the recorded ones
regardless of which task actually ends up issuing the bio.  bio
release puts the associated ioc and blkcg.

It grabs and remembers ioc and blkcg instead of the task itself
because task may already be dead by the time the bio is issued making
ioc and blkcg inaccessible and those are all block layer cares about.

elevator_set_req_fn() is updated such that the bio elvdata is being
allocated for is available to the elevator.

This doesn't update block cgroup policies yet.  Further patches will
implement the support.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Kent Overstreet <koverstreet@google.com>
---
 block/blk-core.c          |   30 +++++++++++++++++-----
 block/cfq-iosched.c       |    3 +-
 block/elevator.c          |    5 ++-
 fs/bio.c                  |   61 +++++++++++++++++++++++++++++++++++++++++++++
 include/linux/bio.h       |    8 ++++++
 include/linux/blk_types.h |   10 +++++++
 include/linux/elevator.h  |    6 +++-
 7 files changed, 111 insertions(+), 12 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 195c5f7..e6a4f90 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -695,7 +695,7 @@ static inline void blk_free_request(struct request_queue *q, struct request *rq)
 }
 
 static struct request *
-blk_alloc_request(struct request_queue *q, struct io_cq *icq,
+blk_alloc_request(struct request_queue *q, struct bio *bio, struct io_cq *icq,
 		  unsigned int flags, gfp_t gfp_mask)
 {
 	struct request *rq = mempool_alloc(q->rq.rq_pool, gfp_mask);
@@ -709,7 +709,7 @@ blk_alloc_request(struct request_queue *q, struct io_cq *icq,
 
 	if (flags & REQ_ELVPRIV) {
 		rq->elv.icq = icq;
-		if (unlikely(elv_set_request(q, rq, gfp_mask))) {
+		if (unlikely(elv_set_request(q, rq, bio, gfp_mask))) {
 			mempool_free(rq, q->rq.rq_pool);
 			return NULL;
 		}
@@ -809,6 +809,20 @@ static bool blk_rq_should_init_elevator(struct bio *bio)
 }
 
 /**
+ * rq_ioc - determine io_context for request allocation
+ * @bio: request being allocated is for this bio (can be %NULL)
+ *
+ * Determine io_context to use for request allocation for @bio.  May return
+ * %NULL if %current->io_context doesn't exist.
+ */
+static struct io_context *rq_ioc(struct bio *bio)
+{
+	if (bio && bio->bi_ioc)
+		return bio->bi_ioc;
+	return current->io_context;
+}
+
+/**
  * get_request - get a free request
  * @q: request_queue to allocate request from
  * @rw_flags: RW and SYNC flags
@@ -835,7 +849,7 @@ static struct request *get_request(struct request_queue *q, int rw_flags,
 	int may_queue;
 retry:
 	et = q->elevator->type;
-	ioc = current->io_context;
+	ioc = rq_ioc(bio);
 
 	if (unlikely(blk_queue_dead(q)))
 		return NULL;
@@ -918,14 +932,16 @@ retry:
 
 	/* create icq if missing */
 	if ((rw_flags & REQ_ELVPRIV) && unlikely(et->icq_cache && !icq)) {
-		ioc = create_io_context(gfp_mask, q->node);
-		if (ioc)
-			icq = ioc_create_icq(ioc, q, gfp_mask);
+		create_io_context(gfp_mask, q->node);
+		ioc = rq_ioc(bio);
+		if (!ioc)
+			goto fail_alloc;
+		icq = ioc_create_icq(ioc, q, gfp_mask);
 		if (!icq)
 			goto fail_alloc;
 	}
 
-	rq = blk_alloc_request(q, icq, rw_flags, gfp_mask);
+	rq = blk_alloc_request(q, bio, icq, rw_flags, gfp_mask);
 	if (unlikely(!rq))
 		goto fail_alloc;
 
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 00e28a3..b2aabe8 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -3299,7 +3299,8 @@ split_cfqq(struct cfq_io_cq *cic, struct cfq_queue *cfqq)
  * Allocate cfq data structures associated with this request.
  */
 static int
-cfq_set_request(struct request_queue *q, struct request *rq, gfp_t gfp_mask)
+cfq_set_request(struct request_queue *q, struct request *rq, struct bio *bio,
+		gfp_t gfp_mask)
 {
 	struct cfq_data *cfqd = q->elevator->elevator_data;
 	struct cfq_io_cq *cic = icq_to_cic(rq->elv.icq);
diff --git a/block/elevator.c b/block/elevator.c
index 06d9869..6315a27 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -663,12 +663,13 @@ struct request *elv_former_request(struct request_queue *q, struct request *rq)
 	return NULL;
 }
 
-int elv_set_request(struct request_queue *q, struct request *rq, gfp_t gfp_mask)
+int elv_set_request(struct request_queue *q, struct request *rq,
+		    struct bio *bio, gfp_t gfp_mask)
 {
 	struct elevator_queue *e = q->elevator;
 
 	if (e->type->ops.elevator_set_req_fn)
-		return e->type->ops.elevator_set_req_fn(q, rq, gfp_mask);
+		return e->type->ops.elevator_set_req_fn(q, rq, bio, gfp_mask);
 	return 0;
 }
 
diff --git a/fs/bio.c b/fs/bio.c
index b980ecd..142214b 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -19,12 +19,14 @@
 #include <linux/swap.h>
 #include <linux/bio.h>
 #include <linux/blkdev.h>
+#include <linux/iocontext.h>
 #include <linux/slab.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/mempool.h>
 #include <linux/workqueue.h>
+#include <linux/cgroup.h>
 #include <scsi/sg.h>		/* for struct sg_iovec */
 
 #include <trace/events/block.h>
@@ -418,6 +420,7 @@ void bio_put(struct bio *bio)
 	 * last put frees it
 	 */
 	if (atomic_dec_and_test(&bio->bi_cnt)) {
+		bio_disassociate_task(bio);
 		bio->bi_next = NULL;
 		bio->bi_destructor(bio);
 	}
@@ -1641,6 +1644,64 @@ bad:
 }
 EXPORT_SYMBOL(bioset_create);
 
+#ifdef CONFIG_BLK_CGROUP
+/**
+ * bio_associate_current - associate a bio with %current
+ * @bio: target bio
+ *
+ * Associate @bio with %current if it hasn't been associated yet.  Block
+ * layer will treat @bio as if it were issued by %current no matter which
+ * task actually issues it.
+ *
+ * This function takes an extra reference of @task's io_context and blkcg
+ * which will be put when @bio is released.  The caller must own @bio,
+ * ensure %current->io_context exists, and is responsible for synchronizing
+ * calls to this function.
+ */
+int bio_associate_current(struct bio *bio)
+{
+	struct io_context *ioc;
+	struct cgroup_subsys_state *css;
+
+	if (bio->bi_ioc)
+		return -EBUSY;
+
+	ioc = current->io_context;
+	if (!ioc)
+		return -ENOENT;
+
+	/* acquire active ref on @ioc and associate */
+	get_io_context_active(ioc);
+	bio->bi_ioc = ioc;
+
+	/* associate blkcg if exists */
+	rcu_read_lock();
+	css = task_subsys_state(current, blkio_subsys_id);
+	if (css && css_tryget(css))
+		bio->bi_css = css;
+	rcu_read_unlock();
+
+	return 0;
+}
+
+/**
+ * bio_disassociate_task - undo bio_associate_current()
+ * @bio: target bio
+ */
+void bio_disassociate_task(struct bio *bio)
+{
+	if (bio->bi_ioc) {
+		put_io_context(bio->bi_ioc);
+		bio->bi_ioc = NULL;
+	}
+	if (bio->bi_css) {
+		css_put(bio->bi_css);
+		bio->bi_css = NULL;
+	}
+}
+
+#endif /* CONFIG_BLK_CGROUP */
+
 static void __init biovec_init_slabs(void)
 {
 	int i;
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 129a9c0..692d3d5 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -268,6 +268,14 @@ extern struct bio_vec *bvec_alloc_bs(gfp_t, int, unsigned long *, struct bio_set
 extern void bvec_free_bs(struct bio_set *, struct bio_vec *, unsigned int);
 extern unsigned int bvec_nr_vecs(unsigned short idx);
 
+#ifdef CONFIG_BLK_CGROUP
+int bio_associate_current(struct bio *bio);
+void bio_disassociate_task(struct bio *bio);
+#else	/* CONFIG_BLK_CGROUP */
+static inline int bio_associate_current(struct bio *bio) { return -ENOENT; }
+static inline void bio_disassociate_task(struct bio *bio) { }
+#endif	/* CONFIG_BLK_CGROUP */
+
 /*
  * bio_set is used to allow other portions of the IO system to
  * allocate their own private memory pools for bio and iovec structures.
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 4053cbd..0edb65d 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -14,6 +14,8 @@ struct bio;
 struct bio_integrity_payload;
 struct page;
 struct block_device;
+struct io_context;
+struct cgroup_subsys_state;
 typedef void (bio_end_io_t) (struct bio *, int);
 typedef void (bio_destructor_t) (struct bio *);
 
@@ -66,6 +68,14 @@ struct bio {
 	bio_end_io_t		*bi_end_io;
 
 	void			*bi_private;
+#ifdef CONFIG_BLK_CGROUP
+	/*
+	 * Optional ioc and css associated with this bio.  Put on bio
+	 * release.  Read comment on top of bio_associate_current().
+	 */
+	struct io_context	*bi_ioc;
+	struct cgroup_subsys_state *bi_css;
+#endif
 #if defined(CONFIG_BLK_DEV_INTEGRITY)
 	struct bio_integrity_payload *bi_integrity;  /* data integrity */
 #endif
diff --git a/include/linux/elevator.h b/include/linux/elevator.h
index 97fb255..c03af76 100644
--- a/include/linux/elevator.h
+++ b/include/linux/elevator.h
@@ -28,7 +28,8 @@ typedef int (elevator_may_queue_fn) (struct request_queue *, int);
 
 typedef void (elevator_init_icq_fn) (struct io_cq *);
 typedef void (elevator_exit_icq_fn) (struct io_cq *);
-typedef int (elevator_set_req_fn) (struct request_queue *, struct request *, gfp_t);
+typedef int (elevator_set_req_fn) (struct request_queue *, struct request *,
+				   struct bio *, gfp_t);
 typedef void (elevator_put_req_fn) (struct request *);
 typedef void (elevator_activate_req_fn) (struct request_queue *, struct request *);
 typedef void (elevator_deactivate_req_fn) (struct request_queue *, struct request *);
@@ -129,7 +130,8 @@ extern void elv_unregister_queue(struct request_queue *q);
 extern int elv_may_queue(struct request_queue *, int);
 extern void elv_abort_queue(struct request_queue *);
 extern void elv_completed_request(struct request_queue *, struct request *);
-extern int elv_set_request(struct request_queue *, struct request *, gfp_t);
+extern int elv_set_request(struct request_queue *q, struct request *rq,
+			   struct bio *bio, gfp_t gfp_mask);
 extern void elv_put_request(struct request_queue *, struct request *);
 extern void elv_drain_elevator(struct request_queue *);
 
-- 
1.7.7.3

