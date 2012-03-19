Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757589Ab2CSWLX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 18:11:23 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:64547 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757459Ab2CSWLN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 18:11:13 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, vgoyal@redhat.com
Cc: linux-kernel@vger.kernel.org, ctalbott@google.com, rni@google.com,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 3/4] cfq: don't use icq_get_changed()
Date: Mon, 19 Mar 2012 15:10:58 -0700
Message-Id: <1332195059-2750-4-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1332195059-2750-1-git-send-email-tj@kernel.org>
References: <1332195059-2750-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cfq caches the associated cfqq's for a given cic.  The cache needs to
be flushed if the cic's ioprio or blkcg has changed.  It is currently
done by requiring the changing action to set the respective
ICQ_*_CHANGED bit in the icq and testing it from cfq_set_request(),
which involves iterating through all the affected icqs.

All cfq wants to know is whether ioprio and/or blkcg have changed
since the last flush and can be easily achieved by just remembering
the current ioprio and blkcg ID in cic.

This patch adds cic->{ioprio|blkcg_id}, updates all ioprio users to
use the remembered value instead, and updates cfq_set_request() path
such that, instead of using icq_get_changed(), the current values are
compared against the remembered ones and trigger appropriate flush
action if not.  Condition tests are moved inside both _changed
functions which are now named check_ioprio_changed() and
check_blkcg_changed().

ioprio.h::task_ioprio*() can't be used anymore and replaced with
open-coded IOPRIO_CLASS_NONE case in cfq_async_queue_prio().

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Vivek Goyal <vgoyal@redhat.com>
---
 block/cfq-iosched.c    |   63 ++++++++++++++++++++++++++++++-----------------
 include/linux/ioprio.h |   22 ++++-------------
 2 files changed, 45 insertions(+), 40 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 9e8624e..7c3893d 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -218,6 +218,10 @@ struct cfq_io_cq {
 	struct io_cq		icq;		/* must be the first member */
 	struct cfq_queue	*cfqq[2];
 	struct cfq_ttime	ttime;
+	int			ioprio;		/* the current ioprio */
+#ifdef CONFIG_CFQ_GROUP_IOSCHED
+	uint64_t		blkcg_id;	/* the current blkcg ID */
+#endif
 };
 
 /*
@@ -2568,7 +2572,7 @@ static void cfq_init_prio_data(struct cfq_queue *cfqq, struct cfq_io_cq *cic)
 	if (!cfq_cfqq_prio_changed(cfqq))
 		return;
 
-	ioprio_class = IOPRIO_PRIO_CLASS(cic->icq.ioc->ioprio);
+	ioprio_class = IOPRIO_PRIO_CLASS(cic->ioprio);
 	switch (ioprio_class) {
 	default:
 		printk(KERN_ERR "cfq: bad prio %x\n", ioprio_class);
@@ -2580,11 +2584,11 @@ static void cfq_init_prio_data(struct cfq_queue *cfqq, struct cfq_io_cq *cic)
 		cfqq->ioprio_class = task_nice_ioclass(tsk);
 		break;
 	case IOPRIO_CLASS_RT:
-		cfqq->ioprio = task_ioprio(cic->icq.ioc);
+		cfqq->ioprio = IOPRIO_PRIO_DATA(cic->ioprio);
 		cfqq->ioprio_class = IOPRIO_CLASS_RT;
 		break;
 	case IOPRIO_CLASS_BE:
-		cfqq->ioprio = task_ioprio(cic->icq.ioc);
+		cfqq->ioprio = IOPRIO_PRIO_DATA(cic->ioprio);
 		cfqq->ioprio_class = IOPRIO_CLASS_BE;
 		break;
 	case IOPRIO_CLASS_IDLE:
@@ -2602,12 +2606,17 @@ static void cfq_init_prio_data(struct cfq_queue *cfqq, struct cfq_io_cq *cic)
 	cfq_clear_cfqq_prio_changed(cfqq);
 }
 
-static void changed_ioprio(struct cfq_io_cq *cic, struct bio *bio)
+static void check_ioprio_changed(struct cfq_io_cq *cic, struct bio *bio)
 {
+	int ioprio = cic->icq.ioc->ioprio;
 	struct cfq_data *cfqd = cic_to_cfqd(cic);
 	struct cfq_queue *cfqq;
 
-	if (unlikely(!cfqd))
+	/*
+	 * Check whether ioprio has changed.  The condition may trigger
+	 * spuriously on a newly created cic but there's no harm.
+	 */
+	if (unlikely(!cfqd) || likely(cic->ioprio == ioprio))
 		return;
 
 	cfqq = cic->cfqq[BLK_RW_ASYNC];
@@ -2624,6 +2633,8 @@ static void changed_ioprio(struct cfq_io_cq *cic, struct bio *bio)
 	cfqq = cic->cfqq[BLK_RW_SYNC];
 	if (cfqq)
 		cfq_mark_cfqq_prio_changed(cfqq);
+
+	cic->ioprio = ioprio;
 }
 
 static void cfq_init_cfqq(struct cfq_data *cfqd, struct cfq_queue *cfqq,
@@ -2647,17 +2658,24 @@ static void cfq_init_cfqq(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 }
 
 #ifdef CONFIG_CFQ_GROUP_IOSCHED
-static void changed_cgroup(struct cfq_io_cq *cic)
+static void check_blkcg_changed(struct cfq_io_cq *cic, struct bio *bio)
 {
-	struct cfq_queue *sync_cfqq = cic_to_cfqq(cic, 1);
 	struct cfq_data *cfqd = cic_to_cfqd(cic);
-	struct request_queue *q;
+	struct cfq_queue *sync_cfqq;
+	uint64_t id;
 
-	if (unlikely(!cfqd))
-		return;
+	rcu_read_lock();
+	id = bio_blkio_cgroup(bio)->id;
+	rcu_read_unlock();
 
-	q = cfqd->queue;
+	/*
+	 * Check whether blkcg has changed.  The condition may trigger
+	 * spuriously on a newly created cic but there's no harm.
+	 */
+	if (unlikely(!cfqd) || likely(cic->blkcg_id == id))
+		return;
 
+	sync_cfqq = cic_to_cfqq(cic, 1);
 	if (sync_cfqq) {
 		/*
 		 * Drop reference to sync queue. A new sync queue will be
@@ -2667,7 +2685,11 @@ static void changed_cgroup(struct cfq_io_cq *cic)
 		cic_set_cfqq(cic, NULL, 1);
 		cfq_put_queue(sync_cfqq);
 	}
+
+	cic->blkcg_id = id;
 }
+#else
+static inline void check_blkcg_changed(struct cfq_io_cq *cic, struct bio *bio) { }
 #endif  /* CONFIG_CFQ_GROUP_IOSCHED */
 
 static struct cfq_queue *
@@ -2731,6 +2753,9 @@ cfq_async_queue_prio(struct cfq_data *cfqd, int ioprio_class, int ioprio)
 	switch (ioprio_class) {
 	case IOPRIO_CLASS_RT:
 		return &cfqd->async_cfqq[0][ioprio];
+	case IOPRIO_CLASS_NONE:
+		ioprio = IOPRIO_NORM;
+		/* fall through */
 	case IOPRIO_CLASS_BE:
 		return &cfqd->async_cfqq[1][ioprio];
 	case IOPRIO_CLASS_IDLE:
@@ -2744,8 +2769,8 @@ static struct cfq_queue *
 cfq_get_queue(struct cfq_data *cfqd, bool is_sync, struct cfq_io_cq *cic,
 	      struct bio *bio, gfp_t gfp_mask)
 {
-	const int ioprio = task_ioprio(cic->icq.ioc);
-	const int ioprio_class = task_ioprio_class(cic->icq.ioc);
+	const int ioprio_class = IOPRIO_PRIO_CLASS(cic->ioprio);
+	const int ioprio = IOPRIO_PRIO_DATA(cic->ioprio);
 	struct cfq_queue **async_cfqq = NULL;
 	struct cfq_queue *cfqq = NULL;
 
@@ -3303,21 +3328,13 @@ cfq_set_request(struct request_queue *q, struct request *rq, struct bio *bio,
 	const int rw = rq_data_dir(rq);
 	const bool is_sync = rq_is_sync(rq);
 	struct cfq_queue *cfqq;
-	unsigned int changed;
 
 	might_sleep_if(gfp_mask & __GFP_WAIT);
 
 	spin_lock_irq(q->queue_lock);
 
-	/* handle changed notifications */
-	changed = icq_get_changed(&cic->icq);
-	if (unlikely(changed & ICQ_IOPRIO_CHANGED))
-		changed_ioprio(cic, bio);
-#ifdef CONFIG_CFQ_GROUP_IOSCHED
-	if (unlikely(changed & ICQ_CGROUP_CHANGED))
-		changed_cgroup(cic);
-#endif
-
+	check_ioprio_changed(cic, bio);
+	check_blkcg_changed(cic, bio);
 new_queue:
 	cfqq = cic_to_cfqq(cic, is_sync);
 	if (!cfqq || cfqq == &cfqd->oom_cfqq) {
diff --git a/include/linux/ioprio.h b/include/linux/ioprio.h
index 76dad48..beb9ce1 100644
--- a/include/linux/ioprio.h
+++ b/include/linux/ioprio.h
@@ -42,26 +42,14 @@ enum {
 };
 
 /*
- * if process has set io priority explicitly, use that. if not, convert
- * the cpu scheduler nice value to an io priority
+ * Fallback BE priority
  */
 #define IOPRIO_NORM	(4)
-static inline int task_ioprio(struct io_context *ioc)
-{
-	if (ioprio_valid(ioc->ioprio))
-		return IOPRIO_PRIO_DATA(ioc->ioprio);
-
-	return IOPRIO_NORM;
-}
-
-static inline int task_ioprio_class(struct io_context *ioc)
-{
-	if (ioprio_valid(ioc->ioprio))
-		return IOPRIO_PRIO_CLASS(ioc->ioprio);
-
-	return IOPRIO_CLASS_BE;
-}
 
+/*
+ * if process has set io priority explicitly, use that. if not, convert
+ * the cpu scheduler nice value to an io priority
+ */
 static inline int task_nice_ioprio(struct task_struct *task)
 {
 	return (task_nice(task) + 20) / 5;
-- 
1.7.7.3

