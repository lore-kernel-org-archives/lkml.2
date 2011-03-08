Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756306Ab1CHVVp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 16:21:45 -0500
Received: from smtp-out.google.com ([216.239.44.51]:1941 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755332Ab1CHVVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 16:21:40 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=fPcnkVxHFUg1wyQiis4rgIMiOf69kDLOt7sH+YceqbjdpSJT366Pv0J6y8fun1Jwc
	OVphJ8aCEAntgupoW3Z0Q==
From: Justin TerAvest <teravest@google.com>
To: m-ikeda@ds.jp.nec.com, jaxboe@fusionio.com, vgoyal@redhat.com
Cc: linux-kernel@vger.kernel.org, ryov@valinux.co.jp, taka@valinux.co.jp,
        kamezawa.hiroyu@jp.fujitsu.com, righi.andrea@gmail.com,
        guijianfeng@cn.fujitsu.com, balbir@linux.vnet.ibm.com,
        ctalbott@google.com, nauman@google.com, mrubin@google.com,
        Justin TerAvest <teravest@google.com>
Subject: [PATCH 3/6] Modify CFQ to use IO tracking information.
Date: Tue,  8 Mar 2011 13:20:53 -0800
Message-Id: <1299619256-12661-4-git-send-email-teravest@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1299619256-12661-1-git-send-email-teravest@google.com>
References: <1299619256-12661-1-git-send-email-teravest@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IO tracking bits are used to send IOs to the right async
queue. Current task is still used to identify the cgroup of the
synchronous IO. Current task is also used if IO tracking is disabled.

Signed-off-by: Justin TerAvest <teravest@google.com>
---
 block/blk-cgroup.c       |    6 +-
 block/blk-core.c         |    7 +-
 block/cfq-iosched.c      |  169 ++++++++++++++++++++++++++++++++++++++++-----
 block/elevator.c         |    5 +-
 include/linux/elevator.h |    6 +-
 5 files changed, 165 insertions(+), 28 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 80d88ec..0f147aa 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -111,6 +111,9 @@ blkio_policy_search_node(const struct blkio_cgroup *blkcg, dev_t dev,
 
 struct blkio_cgroup *cgroup_to_blkio_cgroup(struct cgroup *cgroup)
 {
+	if (!cgroup)
+		return &blkio_root_cgroup;
+
 	return container_of(cgroup_subsys_state(cgroup, blkio_subsys_id),
 			    struct blkio_cgroup, css);
 }
@@ -1537,6 +1540,7 @@ unsigned long get_blkio_cgroup_id(struct bio *bio)
 		id = pc->blkio_cgroup_id;
 	return id;
 }
+EXPORT_SYMBOL(get_blkio_cgroup_id);
 
 /**
  * get_cgroup_from_page() - determine the cgroup from a page.
@@ -1563,8 +1567,6 @@ struct cgroup *get_cgroup_from_page(struct page *page)
 
 	return css->cgroup;
 }
-
-EXPORT_SYMBOL(get_blkio_cgroup_id);
 EXPORT_SYMBOL(get_cgroup_from_page);
 
 #endif /* CONFIG_CGROUP_BLKIOTRACK */
diff --git a/block/blk-core.c b/block/blk-core.c
index 2f4002f..48c1f00 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -671,7 +671,8 @@ static inline void blk_free_request(struct request_queue *q, struct request *rq)
 }
 
 static struct request *
-blk_alloc_request(struct request_queue *q, int flags, int priv, gfp_t gfp_mask)
+blk_alloc_request(struct request_queue *q, struct bio *bio, int flags, int priv,
+					gfp_t gfp_mask)
 {
 	struct request *rq = mempool_alloc(q->rq.rq_pool, gfp_mask);
 
@@ -683,7 +684,7 @@ blk_alloc_request(struct request_queue *q, int flags, int priv, gfp_t gfp_mask)
 	rq->cmd_flags = flags | REQ_ALLOCED;
 
 	if (priv) {
-		if (unlikely(elv_set_request(q, rq, gfp_mask))) {
+		if (unlikely(elv_set_request(q, rq, bio, gfp_mask))) {
 			mempool_free(rq, q->rq.rq_pool);
 			return NULL;
 		}
@@ -824,7 +825,7 @@ static struct request *get_request(struct request_queue *q, int rw_flags,
 		rw_flags |= REQ_IO_STAT;
 	spin_unlock_irq(q->queue_lock);
 
-	rq = blk_alloc_request(q, rw_flags, priv, gfp_mask);
+	rq = blk_alloc_request(q, bio, rw_flags, priv, gfp_mask);
 	if (unlikely(!rq)) {
 		/*
 		 * Allocation failed presumably due to memory. Undo anything
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 1ca9fac..75902b1 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -14,6 +14,7 @@
 #include <linux/rbtree.h>
 #include <linux/ioprio.h>
 #include <linux/blktrace_api.h>
+#include <linux/blkio-track.h>
 #include "cfq.h"
 
 /*
@@ -303,6 +304,10 @@ struct cfq_data {
 };
 
 static struct cfq_group *cfq_get_next_cfqg(struct cfq_data *cfqd);
+static struct cfq_group *cfq_get_cfqg_bio(struct cfq_data *cfqd,
+				   struct bio *bio, int create);
+static struct cfq_queue **
+cfq_async_queue_prio(struct cfq_group *cfqg, int ioprio_class, int ioprio);
 
 static struct cfq_rb_root *service_tree_for(struct cfq_group *cfqg,
 					    enum wl_prio_t prio,
@@ -445,7 +450,7 @@ static inline int cfqg_busy_async_queues(struct cfq_data *cfqd,
 }
 
 static void cfq_dispatch_insert(struct request_queue *, struct request *);
-static struct cfq_queue *cfq_get_queue(struct cfq_data *, bool,
+static struct cfq_queue *cfq_get_queue(struct cfq_data *, struct bio*, bool,
 				       struct io_context *, gfp_t);
 static struct cfq_io_context *cfq_cic_lookup(struct cfq_data *,
 						struct io_context *);
@@ -457,9 +462,55 @@ static inline struct cfq_queue *cic_to_cfqq(struct cfq_io_context *cic,
 	return cic->cfqq[is_sync];
 }
 
+/*
+ * Determine the cfq queue bio should go in. This is primarily used by
+ * front merge and allow merge functions.
+ *
+ * Currently this function takes the ioprio and iprio_class from task
+ * submitting async bio. Later save the task information in the page_cgroup
+ * and retrieve task's ioprio and class from there.
+ */
+static struct cfq_queue *cic_bio_to_cfqq(struct cfq_data *cfqd,
+		struct cfq_io_context *cic, struct bio *bio, int is_sync)
+{
+	struct cfq_queue *cfqq = cic_to_cfqq(cic, is_sync);
+
+#ifdef CONFIG_CGROUP_BLKIOTRACK
+	if (!cfqq && !is_sync) {
+		const int ioprio = task_ioprio(cic->ioc);
+		const int ioprio_class = task_ioprio_class(cic->ioc);
+		struct cfq_group *cfqg;
+		struct cfq_queue **async_cfqq;
+		/*
+		 * async bio tracking is enabled and we are not caching
+		 * async queue pointer in cic.
+		 */
+		cfqg = cfq_get_cfqg_bio(cfqd, bio, 0);
+		if (!cfqg) {
+			/*
+			 * May be this is first rq/bio and io group has not
+			 * been setup yet.
+			 */
+			return NULL;
+		}
+		async_cfqq = cfq_async_queue_prio(cfqg, ioprio_class, ioprio);
+		return *async_cfqq;
+	}
+#endif
+	return cfqq;
+}
+
 static inline void cic_set_cfqq(struct cfq_io_context *cic,
 				struct cfq_queue *cfqq, bool is_sync)
 {
+#ifdef CONFIG_CGROUP_BLKIOTRACK
+	/*
+	 * Don't cache async queue pointer as now one io context might
+	 * be submitting async io for various different async queues
+	 */
+	if (!is_sync)
+		return;
+#endif
 	cic->cfqq[is_sync] = cfqq;
 }
 
@@ -1028,7 +1079,9 @@ cfq_find_alloc_cfqg(struct cfq_data *cfqd, struct cgroup *cgroup, int create)
 	unsigned int major, minor;
 
 	cfqg = cfqg_of_blkg(blkiocg_lookup_group(blkcg, key));
-	if (cfqg && !cfqg->blkg.dev && bdi->dev && dev_name(bdi->dev)) {
+	if (!bdi || !bdi->dev || !dev_name(bdi->dev))
+		goto done;
+	if (cfqg && !cfqg->blkg.dev) {
 		sscanf(dev_name(bdi->dev), "%u:%u", &major, &minor);
 		cfqg->blkg.dev = MKDEV(major, minor);
 		goto done;
@@ -1079,16 +1132,28 @@ done:
  * Search for the cfq group current task belongs to. If create = 1, then also
  * create the cfq group if it does not exist. request_queue lock must be held.
  */
-static struct cfq_group *cfq_get_cfqg(struct cfq_data *cfqd, int create)
+static struct cfq_group *cfq_get_cfqg(struct cfq_data *cfqd, struct page *page,
+				      int create)
 {
 	struct cgroup *cgroup;
 	struct cfq_group *cfqg = NULL;
 
 	rcu_read_lock();
-	cgroup = task_cgroup(current, blkio_subsys_id);
+
+	if (!page)
+		cgroup = task_cgroup(current, blkio_subsys_id);
+	else
+		cgroup = get_cgroup_from_page(page);
+
+	if (!cgroup) {
+		cfqg = &cfqd->root_group;
+		goto out;
+	}
+
 	cfqg = cfq_find_alloc_cfqg(cfqd, cgroup, create);
 	if (!cfqg && create)
 		cfqg = &cfqd->root_group;
+out:
 	rcu_read_unlock();
 	return cfqg;
 }
@@ -1099,6 +1164,32 @@ static inline struct cfq_group *cfq_ref_get_cfqg(struct cfq_group *cfqg)
 	return cfqg;
 }
 
+struct cfq_group *cfq_get_cfqg_bio(struct cfq_data *cfqd,
+					struct bio *bio, int create)
+{
+	struct page *page = NULL;
+
+	/*
+	 * Determine the group from task context. Even calls from
+	 * blk_get_request() which don't have any bio info will be mapped
+	 * to the task's group
+	 */
+	if (!bio)
+		goto sync;
+
+#ifdef CONFIG_CGROUP_BLKIOTRACK
+	/* Map the sync bio to the right group using task context */
+	if (cfq_bio_sync(bio))
+		goto sync;
+
+	/* Determine the group from info stored in page */
+	page = bio_iovec_idx(bio, 0)->bv_page;
+#endif
+
+sync:
+	return cfq_get_cfqg(cfqd, page, create);
+}
+
 static void cfq_link_cfqq_cfqg(struct cfq_queue *cfqq, struct cfq_group *cfqg)
 {
 	cfqq->cfqg = cfqg;
@@ -1176,7 +1267,8 @@ void cfq_unlink_blkio_group(void *key, struct blkio_group *blkg)
 }
 
 #else /* GROUP_IOSCHED */
-static struct cfq_group *cfq_get_cfqg(struct cfq_data *cfqd, int create)
+static struct cfq_group *cfq_get_cfqg_bio(struct cfq_data *cfqd,
+					  struct bio *bio, int create)
 {
 	return &cfqd->root_group;
 }
@@ -1481,7 +1573,7 @@ cfq_find_rq_fmerge(struct cfq_data *cfqd, struct bio *bio)
 	if (!cic)
 		return NULL;
 
-	cfqq = cic_to_cfqq(cic, cfq_bio_sync(bio));
+	cfqq = cic_bio_to_cfqq(cfqd, cic, bio, cfq_bio_sync(bio));
 	if (cfqq) {
 		sector_t sector = bio->bi_sector + bio_sectors(bio);
 
@@ -1605,7 +1697,7 @@ static int cfq_allow_merge(struct request_queue *q, struct request *rq,
 	if (!cic)
 		return false;
 
-	cfqq = cic_to_cfqq(cic, cfq_bio_sync(bio));
+	cfqq = cic_bio_to_cfqq(cfqd, cic, bio, cfq_bio_sync(bio));
 	return cfqq == RQ_CFQQ(rq);
 }
 
@@ -2816,14 +2908,10 @@ static void changed_ioprio(struct io_context *ioc, struct cfq_io_context *cic)
 	spin_lock_irqsave(cfqd->queue->queue_lock, flags);
 
 	cfqq = cic->cfqq[BLK_RW_ASYNC];
+
 	if (cfqq) {
-		struct cfq_queue *new_cfqq;
-		new_cfqq = cfq_get_queue(cfqd, BLK_RW_ASYNC, cic->ioc,
-						GFP_ATOMIC);
-		if (new_cfqq) {
-			cic->cfqq[BLK_RW_ASYNC] = new_cfqq;
-			cfq_put_queue(cfqq);
-		}
+		cic_set_cfqq(cic, NULL, BLK_RW_ASYNC);
+		cfq_put_queue(cfqq);
 	}
 
 	cfqq = cic->cfqq[BLK_RW_SYNC];
@@ -2863,6 +2951,7 @@ static void cfq_init_cfqq(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 static void changed_cgroup(struct io_context *ioc, struct cfq_io_context *cic)
 {
 	struct cfq_queue *sync_cfqq = cic_to_cfqq(cic, 1);
+	struct cfq_queue *async_cfqq = cic_to_cfqq(cic, 0);
 	struct cfq_data *cfqd = cic_to_cfqd(cic);
 	unsigned long flags;
 	struct request_queue *q;
@@ -2884,6 +2973,12 @@ static void changed_cgroup(struct io_context *ioc, struct cfq_io_context *cic)
 		cfq_put_queue(sync_cfqq);
 	}
 
+	if (async_cfqq != NULL) {
+		cfq_log_cfqq(cfqd, async_cfqq, "changed cgroup");
+		cic_set_cfqq(cic, NULL, 0);
+		cfq_put_queue(async_cfqq);
+	}
+
 	spin_unlock_irqrestore(q->queue_lock, flags);
 }
 
@@ -2906,6 +3001,24 @@ retry:
 	/* cic always exists here */
 	cfqq = cic_to_cfqq(cic, is_sync);
 
+#ifdef CONFIG_CGROUP_BLKIOTRACK
+	if (!cfqq && !is_sync) {
+		const int ioprio = task_ioprio(cic->ioc);
+		const int ioprio_class = task_ioprio_class(cic->ioc);
+		struct cfq_queue **async_cfqq;
+
+		/*
+		 * We have not cached async queue pointer as bio tracking
+		 * is enabled. Look into group async queue array using ioc
+		 * class and prio to see if somebody already allocated the
+		 * queue.
+		 */
+
+		async_cfqq = cfq_async_queue_prio(cfqg, ioprio_class, ioprio);
+		cfqq = *async_cfqq;
+	}
+#endif
+
 	/*
 	 * Always try a new alloc if we fell back to the OOM cfqq
 	 * originally, since it should just be a temporary situation.
@@ -2960,14 +3073,14 @@ cfq_async_queue_prio(struct cfq_group *cfqg, int ioprio_class, int ioprio)
 }
 
 static struct cfq_queue *
-cfq_get_queue(struct cfq_data *cfqd, bool is_sync, struct io_context *ioc,
-	      gfp_t gfp_mask)
+cfq_get_queue(struct cfq_data *cfqd, struct bio *bio, bool is_sync,
+	      struct io_context *ioc, gfp_t gfp_mask)
 {
 	const int ioprio = task_ioprio(ioc);
 	const int ioprio_class = task_ioprio_class(ioc);
 	struct cfq_queue **async_cfqq = NULL;
 	struct cfq_queue *cfqq = NULL;
-	struct cfq_group *cfqg = cfq_get_cfqg(cfqd, 1);
+	struct cfq_group *cfqg = cfq_get_cfqg_bio(cfqd, bio, 1);
 
 	if (!is_sync) {
 		async_cfqq = cfq_async_queue_prio(cfqg, ioprio_class,
@@ -2986,7 +3099,24 @@ cfq_get_queue(struct cfq_data *cfqd, bool is_sync, struct io_context *ioc,
 		*async_cfqq = cfqq;
 	}
 
+#ifdef CONFIG_CGROUP_BLKIOTRACK
+	/*
+	 * ioc reference. If async request queue/group is determined from the
+	 * original task/cgroup and not from submitter task, io context can
+	 * not cache the pointer to async queue and everytime a request comes,
+	 * it will be determined by going through the async queue array.
+	 *
+	 */
+	if (is_sync)
+		cfqq->ref++;
+#else
+	/*
+	 * async requests are being attributed to task submitting
+	 * it, hence cic can cache async cfqq pointer. Take the
+	 * queue reference even for async queue.
+	 */
 	cfqq->ref++;
+#endif
 	return cfqq;
 }
 
@@ -3652,7 +3782,8 @@ split_cfqq(struct cfq_io_context *cic, struct cfq_queue *cfqq)
  * Allocate cfq data structures associated with this request.
  */
 static int
-cfq_set_request(struct request_queue *q, struct request *rq, gfp_t gfp_mask)
+cfq_set_request(struct request_queue *q, struct request *rq, struct bio *bio,
+				gfp_t gfp_mask)
 {
 	struct cfq_data *cfqd = q->elevator->elevator_data;
 	struct cfq_io_context *cic;
@@ -3673,7 +3804,7 @@ cfq_set_request(struct request_queue *q, struct request *rq, gfp_t gfp_mask)
 new_queue:
 	cfqq = cic_to_cfqq(cic, is_sync);
 	if (!cfqq || cfqq == &cfqd->oom_cfqq) {
-		cfqq = cfq_get_queue(cfqd, is_sync, cic->ioc, gfp_mask);
+		cfqq = cfq_get_queue(cfqd, bio, is_sync, cic->ioc, gfp_mask);
 		cic_set_cfqq(cic, cfqq, is_sync);
 	} else {
 		/*
diff --git a/block/elevator.c b/block/elevator.c
index 2569512..9854cf6 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -752,12 +752,13 @@ struct request *elv_former_request(struct request_queue *q, struct request *rq)
 	return NULL;
 }
 
-int elv_set_request(struct request_queue *q, struct request *rq, gfp_t gfp_mask)
+int elv_set_request(struct request_queue *q, struct request *rq,
+			struct bio *bio, gfp_t gfp_mask)
 {
 	struct elevator_queue *e = q->elevator;
 
 	if (e->ops->elevator_set_req_fn)
-		return e->ops->elevator_set_req_fn(q, rq, gfp_mask);
+		return e->ops->elevator_set_req_fn(q, rq, bio, gfp_mask);
 
 	rq->elevator_private = NULL;
 	return 0;
diff --git a/include/linux/elevator.h b/include/linux/elevator.h
index 4d85797..496c182 100644
--- a/include/linux/elevator.h
+++ b/include/linux/elevator.h
@@ -25,7 +25,8 @@ typedef struct request *(elevator_request_list_fn) (struct request_queue *, stru
 typedef void (elevator_completed_req_fn) (struct request_queue *, struct request *);
 typedef int (elevator_may_queue_fn) (struct request_queue *, int);
 
-typedef int (elevator_set_req_fn) (struct request_queue *, struct request *, gfp_t);
+typedef int (elevator_set_req_fn) (struct request_queue *, struct request *,
+					struct bio *bio, gfp_t);
 typedef void (elevator_put_req_fn) (struct request *);
 typedef void (elevator_activate_req_fn) (struct request_queue *, struct request *);
 typedef void (elevator_deactivate_req_fn) (struct request_queue *, struct request *);
@@ -119,7 +120,8 @@ extern void elv_unregister_queue(struct request_queue *q);
 extern int elv_may_queue(struct request_queue *, int);
 extern void elv_abort_queue(struct request_queue *);
 extern void elv_completed_request(struct request_queue *, struct request *);
-extern int elv_set_request(struct request_queue *, struct request *, gfp_t);
+extern int elv_set_request(struct request_queue *, struct request *,
+					struct bio *bio, gfp_t);
 extern void elv_put_request(struct request_queue *, struct request *);
 extern void elv_drain_elevator(struct request_queue *);
 
-- 
1.7.3.1

