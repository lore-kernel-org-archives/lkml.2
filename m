Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757494Ab2CSWLN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 18:11:13 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:64547 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757010Ab2CSWLL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 18:11:11 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, vgoyal@redhat.com
Cc: linux-kernel@vger.kernel.org, ctalbott@google.com, rni@google.com,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 2/4] cfq: pass around cfq_io_cq instead of io_context
Date: Mon, 19 Mar 2012 15:10:57 -0700
Message-Id: <1332195059-2750-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1332195059-2750-1-git-send-email-tj@kernel.org>
References: <1332195059-2750-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that io_cq is managed by block core and guaranteed to exist for
any in-flight request, it is easier and carries more information to
pass around cfq_io_cq than io_context.

This patch updates cfq_init_prio_data(), cfq_find_alloc_queue() and
cfq_get_queue() to take @cic instead of @ioc.  This change removes a
duplicate cfq_cic_lookup() from cfq_find_alloc_queue().

This change enables the use of cic-cached ioprio in the next patch.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/cfq-iosched.c |   39 +++++++++++++++++----------------------
 1 files changed, 17 insertions(+), 22 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index f2387b5..9e8624e 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -468,7 +468,7 @@ static inline int cfqg_busy_async_queues(struct cfq_data *cfqd,
 
 static void cfq_dispatch_insert(struct request_queue *, struct request *);
 static struct cfq_queue *cfq_get_queue(struct cfq_data *cfqd, bool is_sync,
-				       struct io_context *ioc, struct bio *bio,
+				       struct cfq_io_cq *cic, struct bio *bio,
 				       gfp_t gfp_mask);
 
 static inline struct cfq_io_cq *icq_to_cic(struct io_cq *icq)
@@ -2560,7 +2560,7 @@ static void cfq_exit_icq(struct io_cq *icq)
 	}
 }
 
-static void cfq_init_prio_data(struct cfq_queue *cfqq, struct io_context *ioc)
+static void cfq_init_prio_data(struct cfq_queue *cfqq, struct cfq_io_cq *cic)
 {
 	struct task_struct *tsk = current;
 	int ioprio_class;
@@ -2568,7 +2568,7 @@ static void cfq_init_prio_data(struct cfq_queue *cfqq, struct io_context *ioc)
 	if (!cfq_cfqq_prio_changed(cfqq))
 		return;
 
-	ioprio_class = IOPRIO_PRIO_CLASS(ioc->ioprio);
+	ioprio_class = IOPRIO_PRIO_CLASS(cic->icq.ioc->ioprio);
 	switch (ioprio_class) {
 	default:
 		printk(KERN_ERR "cfq: bad prio %x\n", ioprio_class);
@@ -2580,11 +2580,11 @@ static void cfq_init_prio_data(struct cfq_queue *cfqq, struct io_context *ioc)
 		cfqq->ioprio_class = task_nice_ioclass(tsk);
 		break;
 	case IOPRIO_CLASS_RT:
-		cfqq->ioprio = task_ioprio(ioc);
+		cfqq->ioprio = task_ioprio(cic->icq.ioc);
 		cfqq->ioprio_class = IOPRIO_CLASS_RT;
 		break;
 	case IOPRIO_CLASS_BE:
-		cfqq->ioprio = task_ioprio(ioc);
+		cfqq->ioprio = task_ioprio(cic->icq.ioc);
 		cfqq->ioprio_class = IOPRIO_CLASS_BE;
 		break;
 	case IOPRIO_CLASS_IDLE:
@@ -2613,8 +2613,8 @@ static void changed_ioprio(struct cfq_io_cq *cic, struct bio *bio)
 	cfqq = cic->cfqq[BLK_RW_ASYNC];
 	if (cfqq) {
 		struct cfq_queue *new_cfqq;
-		new_cfqq = cfq_get_queue(cfqd, BLK_RW_ASYNC, cic->icq.ioc,
-					 bio, GFP_ATOMIC);
+		new_cfqq = cfq_get_queue(cfqd, BLK_RW_ASYNC, cic, bio,
+					 GFP_ATOMIC);
 		if (new_cfqq) {
 			cic->cfqq[BLK_RW_ASYNC] = new_cfqq;
 			cfq_put_queue(cfqq);
@@ -2671,23 +2671,18 @@ static void changed_cgroup(struct cfq_io_cq *cic)
 #endif  /* CONFIG_CFQ_GROUP_IOSCHED */
 
 static struct cfq_queue *
-cfq_find_alloc_queue(struct cfq_data *cfqd, bool is_sync,
-		     struct io_context *ioc, struct bio *bio, gfp_t gfp_mask)
+cfq_find_alloc_queue(struct cfq_data *cfqd, bool is_sync, struct cfq_io_cq *cic,
+		     struct bio *bio, gfp_t gfp_mask)
 {
 	struct blkio_cgroup *blkcg;
 	struct cfq_queue *cfqq, *new_cfqq = NULL;
-	struct cfq_io_cq *cic;
 	struct cfq_group *cfqg;
 
 retry:
 	rcu_read_lock();
 
 	blkcg = bio_blkio_cgroup(bio);
-
 	cfqg = cfq_lookup_create_cfqg(cfqd, blkcg);
-
-	cic = cfq_cic_lookup(cfqd, ioc);
-	/* cic always exists here */
 	cfqq = cic_to_cfqq(cic, is_sync);
 
 	/*
@@ -2716,7 +2711,7 @@ retry:
 
 		if (cfqq) {
 			cfq_init_cfqq(cfqd, cfqq, current->pid, is_sync);
-			cfq_init_prio_data(cfqq, ioc);
+			cfq_init_prio_data(cfqq, cic);
 			cfq_link_cfqq_cfqg(cfqq, cfqg);
 			cfq_log_cfqq(cfqd, cfqq, "alloced");
 		} else
@@ -2746,11 +2741,11 @@ cfq_async_queue_prio(struct cfq_data *cfqd, int ioprio_class, int ioprio)
 }
 
 static struct cfq_queue *
-cfq_get_queue(struct cfq_data *cfqd, bool is_sync, struct io_context *ioc,
+cfq_get_queue(struct cfq_data *cfqd, bool is_sync, struct cfq_io_cq *cic,
 	      struct bio *bio, gfp_t gfp_mask)
 {
-	const int ioprio = task_ioprio(ioc);
-	const int ioprio_class = task_ioprio_class(ioc);
+	const int ioprio = task_ioprio(cic->icq.ioc);
+	const int ioprio_class = task_ioprio_class(cic->icq.ioc);
 	struct cfq_queue **async_cfqq = NULL;
 	struct cfq_queue *cfqq = NULL;
 
@@ -2760,7 +2755,7 @@ cfq_get_queue(struct cfq_data *cfqd, bool is_sync, struct io_context *ioc,
 	}
 
 	if (!cfqq)
-		cfqq = cfq_find_alloc_queue(cfqd, is_sync, ioc, bio, gfp_mask);
+		cfqq = cfq_find_alloc_queue(cfqd, is_sync, cic, bio, gfp_mask);
 
 	/*
 	 * pin the queue now that it's allocated, scheduler exit will prune it
@@ -3030,7 +3025,7 @@ static void cfq_insert_request(struct request_queue *q, struct request *rq)
 	struct cfq_queue *cfqq = RQ_CFQQ(rq);
 
 	cfq_log_cfqq(cfqd, cfqq, "insert_request");
-	cfq_init_prio_data(cfqq, RQ_CIC(rq)->icq.ioc);
+	cfq_init_prio_data(cfqq, RQ_CIC(rq));
 
 	rq_set_fifo_time(rq, jiffies + cfqd->cfq_fifo_expire[rq_is_sync(rq)]);
 	list_add_tail(&rq->queuelist, &cfqq->fifo);
@@ -3234,7 +3229,7 @@ static int cfq_may_queue(struct request_queue *q, int rw)
 
 	cfqq = cic_to_cfqq(cic, rw_is_sync(rw));
 	if (cfqq) {
-		cfq_init_prio_data(cfqq, cic->icq.ioc);
+		cfq_init_prio_data(cfqq, cic);
 
 		return __cfq_may_queue(cfqq);
 	}
@@ -3326,7 +3321,7 @@ cfq_set_request(struct request_queue *q, struct request *rq, struct bio *bio,
 new_queue:
 	cfqq = cic_to_cfqq(cic, is_sync);
 	if (!cfqq || cfqq == &cfqd->oom_cfqq) {
-		cfqq = cfq_get_queue(cfqd, is_sync, cic->icq.ioc, bio, gfp_mask);
+		cfqq = cfq_get_queue(cfqd, is_sync, cic, bio, gfp_mask);
 		cic_set_cfqq(cic, cfqq, is_sync);
 	} else {
 		/*
-- 
1.7.7.3

