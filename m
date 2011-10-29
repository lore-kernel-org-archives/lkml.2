Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932913Ab1J2XuD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Oct 2011 19:50:03 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:60795 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932713Ab1J2XuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Oct 2011 19:50:00 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, vgoyal@redhat.com
Cc: ctalbott@google.com, rni@google.com, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 06/10] block, cfq: move io_cq lookup to blk-ioc.c
Date: Sat, 29 Oct 2011 16:49:43 -0700
Message-Id: <1319932187-7631-7-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1319932187-7631-1-git-send-email-tj@kernel.org>
References: <1319932187-7631-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that all io_cq related data structures are in block core layer,
io_cq lookup can be moved from cfq-iosched.c to blk-ioc.c.

Lookup logic from cfq_cic_lookup() is moved to ioc_lookup_icq() with
parameter return type changes (cfqd -> request_queue, cfq_io_cq ->
io_cq) and cfq_cic_lookup() becomes thin wrapper around
cfq_cic_lookup().

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
---
 block/blk-ioc.c     |   36 ++++++++++++++++++++++++++++++++++++
 block/blk.h         |    1 +
 block/cfq-iosched.c |   48 ++++++++----------------------------------------
 3 files changed, 45 insertions(+), 40 deletions(-)

diff --git a/block/blk-ioc.c b/block/blk-ioc.c
index dc5e69d..87ecc98 100644
--- a/block/blk-ioc.c
+++ b/block/blk-ioc.c
@@ -266,6 +266,42 @@ struct io_context *get_task_io_context(struct task_struct *task,
 }
 EXPORT_SYMBOL(get_task_io_context);
 
+/**
+ * ioc_lookup_icq - lookup io_cq from ioc
+ * @ioc: the associated io_context
+ * @q: the associated request_queue
+ *
+ * Look up io_cq associated with @ioc - @q pair from @ioc.  Must be called
+ * with @q->queue_lock held.
+ */
+struct io_cq *ioc_lookup_icq(struct io_context *ioc, struct request_queue *q)
+{
+	struct io_cq *icq;
+
+	lockdep_assert_held(q->queue_lock);
+
+	/*
+	 * icq's are indexed from @ioc using radix tree and hint pointer,
+	 * both of which are protected with RCU.  All removals are done
+	 * holding both q and ioc locks, and we're holding q lock - if we
+	 * find a icq which points to us, it's guaranteed to be valid.
+	 */
+	rcu_read_lock();
+	icq = rcu_dereference(ioc->icq_hint);
+	if (icq && icq->q == q)
+		goto out;
+
+	icq = radix_tree_lookup(&ioc->icq_tree, q->id);
+	if (icq && icq->q == q)
+		rcu_assign_pointer(ioc->icq_hint, icq);	/* allowed to race */
+	else
+		icq = NULL;
+out:
+	rcu_read_unlock();
+	return icq;
+}
+EXPORT_SYMBOL(ioc_lookup_icq);
+
 void ioc_set_changed(struct io_context *ioc, int which)
 {
 	struct io_cq *icq;
diff --git a/block/blk.h b/block/blk.h
index 4943770..3c510a4 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -199,6 +199,7 @@ static inline int blk_do_io_stat(struct request *rq)
  * Internal io_context interface
  */
 void get_io_context(struct io_context *ioc);
+struct io_cq *ioc_lookup_icq(struct io_context *ioc, struct request_queue *q);
 
 void create_io_context_slowpath(struct task_struct *task, gfp_t gfp_mask,
 				int node);
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 9bc5ecc..048fa69 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -468,7 +468,6 @@ static inline int cfqg_busy_async_queues(struct cfq_data *cfqd,
 static void cfq_dispatch_insert(struct request_queue *, struct request *);
 static struct cfq_queue *cfq_get_queue(struct cfq_data *, bool,
 				       struct io_context *, gfp_t);
-static struct cfq_io_cq *cfq_cic_lookup(struct cfq_data *, struct io_context *);
 
 static inline struct cfq_io_cq *icq_to_cic(struct io_cq *icq)
 {
@@ -476,6 +475,14 @@ static inline struct cfq_io_cq *icq_to_cic(struct io_cq *icq)
 	return container_of(icq, struct cfq_io_cq, icq);
 }
 
+static inline struct cfq_io_cq *cfq_cic_lookup(struct cfq_data *cfqd,
+					       struct io_context *ioc)
+{
+	if (ioc)
+		return icq_to_cic(ioc_lookup_icq(ioc, cfqd->queue));
+	return NULL;
+}
+
 static inline struct cfq_queue *cic_to_cfqq(struct cfq_io_cq *cic, bool is_sync)
 {
 	return cic->cfqq[is_sync];
@@ -2971,45 +2978,6 @@ cfq_get_queue(struct cfq_data *cfqd, bool is_sync, struct io_context *ioc,
 }
 
 /**
- * cfq_cic_lookup - lookup cfq_io_cq
- * @cfqd: the associated cfq_data
- * @ioc: the associated io_context
- *
- * Look up cfq_io_cq associated with @cfqd - @ioc pair.  Must be called
- * with queue_lock held.
- */
-static struct cfq_io_cq *
-cfq_cic_lookup(struct cfq_data *cfqd, struct io_context *ioc)
-{
-	struct request_queue *q = cfqd->queue;
-	struct io_cq *icq;
-
-	lockdep_assert_held(cfqd->queue->queue_lock);
-	if (unlikely(!ioc))
-		return NULL;
-
-	/*
-	 * icq's are indexed from @ioc using radix tree and hint pointer,
-	 * both of which are protected with RCU.  All removals are done
-	 * holding both q and ioc locks, and we're holding q lock - if we
-	 * find a icq which points to us, it's guaranteed to be valid.
-	 */
-	rcu_read_lock();
-	icq = rcu_dereference(ioc->icq_hint);
-	if (icq && icq->q == q)
-		goto out;
-
-	icq = radix_tree_lookup(&ioc->icq_tree, cfqd->queue->id);
-	if (icq && icq->q == q)
-		rcu_assign_pointer(ioc->icq_hint, icq);	/* allowed to race */
-	else
-		icq = NULL;
-out:
-	rcu_read_unlock();
-	return icq_to_cic(icq);
-}
-
-/**
  * cfq_create_cic - create and link a cfq_io_cq
  * @cfqd: cfqd of interest
  * @gfp_mask: allocation mask
-- 
1.7.3.1

