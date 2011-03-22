Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755961Ab1CVXKc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 19:10:32 -0400
Received: from smtp-out.google.com ([216.239.44.51]:6668 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755603Ab1CVXJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 19:09:21 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=i27pdorsM1Em6VJUh723CQY/+MmALquT56/R30KOLsUR+FIDXtFCufjVm5Hf7vZVI
	VA1qFN9rlTPk2kfCfCBQA==
From: Justin TerAvest <teravest@google.com>
To: vgoyal@redhat.com, jaxboe@fusionio.com
Cc: m-ikeda@ds.jp.nec.com, ryov@valinux.co.jp, taka@valinux.co.jp,
        kamezawa.hiroyu@jp.fujitsu.com, righi.andrea@gmail.com,
        guijianfeng@cn.fujitsu.com, balbir@linux.vnet.ibm.com,
        ctalbott@google.com, linux-kernel@vger.kernel.org,
        Justin TerAvest <teravest@google.com>
Subject: [PATCH v2 7/8] block: Per cgroup request descriptor counts
Date: Tue, 22 Mar 2011 16:08:54 -0700
Message-Id: <1300835335-2777-8-git-send-email-teravest@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1300835335-2777-1-git-send-email-teravest@google.com>
References: <1300835335-2777-1-git-send-email-teravest@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a cgroup gets starved, it keeps allocating request
descriptors until it hits the limit. Other cgroups could be
starved of request descriptors, which is a problem.
This patch implements per-cgroup request descriptor limits.

There has been discussion to remove limits entirely, but they are
introduced here to enable tracking for buffered writes without causing
problems for the per request-queue limit.

There are some interesting corner cases that are also covered.
During elevator switch, we start counting the request descriptors
towards the request list of the root group. We drain all the requests
that were started before the switch. If new requests arrive after
the switch is progressing, they are counted towards the common, shared
request list of the root group. As these requests complete, the counter
in the common request list is decremented properly.

Signed-off-by: Justin TerAvest <teravest@google.com>
---
 Documentation/block/biodoc.txt |   10 ++
 block/blk-core.c               |  211 +++++++++++++++++++++++++++-------------
 block/blk-settings.c           |    2 +-
 block/blk-sysfs.c              |   59 ++++++-----
 block/cfq-iosched.c            |   61 +++++++++++-
 block/elevator.c               |    2 +-
 include/linux/blkdev.h         |   81 +++++++++++++++-
 include/linux/elevator.h       |    8 ++
 8 files changed, 337 insertions(+), 97 deletions(-)

diff --git a/Documentation/block/biodoc.txt b/Documentation/block/biodoc.txt
index 2a7b38c..856d706 100644
--- a/Documentation/block/biodoc.txt
+++ b/Documentation/block/biodoc.txt
@@ -970,6 +970,16 @@ elevator_latter_req_fn		These return the request before or after the
 
 elevator_completed_req_fn	called when a request is completed.
 
+elevator_req_list_fn		called to obtain the active request list for
+				either a bio or a request. This function can
+				be called with either a valid bio or request.
+				This function must be defined only if the
+				scheduler supports per cgroup request lists.
+				When defined, it becomes the responsibility
+				of the scheduler to call blk_alloced_request
+				after the request and queue are allocated and
+				the cgroup is declared.
+
 elevator_may_queue_fn		returns true if the scheduler wants to allow the
 				current context to queue a new request even if
 				it is over the queue limit. This must be used
diff --git a/block/blk-core.c b/block/blk-core.c
index 1b7936bf..465df36 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -381,23 +381,28 @@ void blk_cleanup_queue(struct request_queue *q)
 }
 EXPORT_SYMBOL(blk_cleanup_queue);
 
-static int blk_init_free_list(struct request_queue *q)
+void blk_init_request_list(struct request_list *rl)
 {
-	struct request_list *rl = &q->rq;
-
-	if (unlikely(rl->rq_pool))
-		return 0;
-
 	rl->count[BLK_RW_SYNC] = rl->count[BLK_RW_ASYNC] = 0;
 	rl->starved[BLK_RW_SYNC] = rl->starved[BLK_RW_ASYNC] = 0;
-	rl->elvpriv = 0;
 	init_waitqueue_head(&rl->wait[BLK_RW_SYNC]);
 	init_waitqueue_head(&rl->wait[BLK_RW_ASYNC]);
+}
 
-	rl->rq_pool = mempool_create_node(BLKDEV_MIN_RQ, mempool_alloc_slab,
-				mempool_free_slab, request_cachep, q->node);
+static int blk_init_free_list(struct request_queue *q)
+{
+	if (unlikely(q->rq_pool.rq_pool))
+		return 0;
+
+	blk_init_request_list(&q->rq);
 
-	if (!rl->rq_pool)
+	q->rq_pool.count[BLK_RW_SYNC] = 0;
+	q->rq_pool.count[BLK_RW_ASYNC] = 0;
+	q->rq_pool.elvpriv = 0;
+	q->rq_pool.rq_pool = mempool_create_node(BLKDEV_MIN_RQ,
+					mempool_alloc_slab, mempool_free_slab,
+					request_cachep, q->node);
+	if (!q->rq_pool.rq_pool)
 		return -ENOMEM;
 
 	return 0;
@@ -579,14 +584,14 @@ static inline void blk_free_request(struct request_queue *q, struct request *rq)
 
 	if (rq->cmd_flags & REQ_ELVPRIV)
 		elv_put_request(q, rq);
-	mempool_free(rq, q->rq.rq_pool);
+	mempool_free(rq, q->rq_pool.rq_pool);
 }
 
 static struct request *
 blk_alloc_request(struct request_queue *q, struct bio *bio, int flags, int priv,
 					gfp_t gfp_mask)
 {
-	struct request *rq = mempool_alloc(q->rq.rq_pool, gfp_mask);
+	struct request *rq = mempool_alloc(q->rq_pool.rq_pool, gfp_mask);
 
 	if (!rq)
 		return NULL;
@@ -596,11 +601,11 @@ blk_alloc_request(struct request_queue *q, struct bio *bio, int flags, int priv,
 	rq->cmd_flags = flags | REQ_ALLOCED;
 
 	if (priv) {
+		rq->cmd_flags |= REQ_ELVPRIV;
 		if (unlikely(elv_set_request(q, rq, bio, gfp_mask))) {
-			mempool_free(rq, q->rq.rq_pool);
+			mempool_free(rq, q->rq_pool.rq_pool);
 			return NULL;
 		}
-		rq->cmd_flags |= REQ_ELVPRIV;
 	}
 
 	return rq;
@@ -640,38 +645,67 @@ static void ioc_set_batching(struct request_queue *q, struct io_context *ioc)
 	ioc->last_waited = jiffies;
 }
 
-static void __freed_request(struct request_queue *q, int sync)
+static void __freed_request(struct request_queue *q, int sync,
+			    struct request_list *rl)
 {
-	struct request_list *rl = &q->rq;
-
-	if (rl->count[sync] < queue_congestion_off_threshold(q))
+	if (q->rq_pool.count[sync] < queue_congestion_off_threshold(q))
 		blk_clear_queue_congested(q, sync);
 
-	if (rl->count[sync] + 1 <= q->nr_requests) {
+	if (q->rq_pool.count[sync] + 1 <= q->nr_requests)
+		blk_clear_queue_full(q, sync);
+
+	if (rl->count[sync] + 1 <= q->nr_group_requests) {
 		if (waitqueue_active(&rl->wait[sync]))
 			wake_up(&rl->wait[sync]);
-
-		blk_clear_queue_full(q, sync);
 	}
 }
 
 /*
  * A request has just been released.  Account for it, update the full and
- * congestion status, wake up any waiters.   Called under q->queue_lock.
+ * congestion status, wake up any waiters.  Called under q->queue_lock.
  */
-static void freed_request(struct request_queue *q, int sync, int priv)
+static void freed_request(struct request_queue *q, int sync, int priv,
+			  struct request_list *rl)
 {
-	struct request_list *rl = &q->rq;
+	if (priv) {
+		q->rq_pool.elvpriv--;
+		BUG_ON(!rl->count[sync]);
+		rl->count[sync]--;
+	}
 
-	rl->count[sync]--;
-	if (priv)
-		rl->elvpriv--;
+	BUG_ON(!q->rq_pool.count[sync]);
+	q->rq_pool.count[sync]--;
 
-	__freed_request(q, sync);
+	__freed_request(q, sync, rl);
 
 	if (unlikely(rl->starved[sync ^ 1]))
-		__freed_request(q, sync ^ 1);
+		__freed_request(q, sync ^ 1, rl);
+}
+
+void blk_alloced_request(struct request_queue *q, struct request_list *rl,
+			 int sync)
+{
+	int priv;
+
+	q->rq_pool.count[sync]++;
+	rl->starved[sync] = 0;
+
+	priv = !test_bit(QUEUE_FLAG_ELVSWITCH, &q->queue_flags);
+	if (priv) {
+		q->rq_pool.elvpriv++;
+		/*
+		 * Account the request to request list only if request is
+		 * going to elevator. During elevator switch, there will
+		 * be small window where group is going away and new group
+		 * will not be allocated till elevator switch is complete.
+		 * So till then instead of slowing down the application,
+		 * we will continue to allocate request from total common
+		 * pool instead of per group limit
+		 */
+		rl->count[sync]++;
+	}
 }
+EXPORT_SYMBOL(blk_alloced_request);
 
 /*
  * Determine if elevator data should be initialized when allocating the
@@ -698,10 +732,10 @@ static bool blk_rq_should_init_elevator(struct bio *bio)
  * Returns !NULL on success, with queue_lock *not held*.
  */
 static struct request *get_request(struct request_queue *q, int rw_flags,
-				   struct bio *bio, gfp_t gfp_mask)
+				   struct bio *bio, gfp_t gfp_mask,
+				   struct request_list *rl)
 {
 	struct request *rq = NULL;
-	struct request_list *rl = &q->rq;
 	struct io_context *ioc = NULL;
 	const bool is_sync = rw_is_sync(rw_flags) != 0;
 	int may_queue, priv = 0;
@@ -710,31 +744,41 @@ static struct request *get_request(struct request_queue *q, int rw_flags,
 	if (may_queue == ELV_MQUEUE_NO)
 		goto rq_starved;
 
-	if (rl->count[is_sync]+1 >= queue_congestion_on_threshold(q)) {
-		if (rl->count[is_sync]+1 >= q->nr_requests) {
-			ioc = current_io_context(GFP_ATOMIC, q->node);
+	if (q->rq_pool.count[is_sync]+1 >= queue_congestion_on_threshold(q)) {
+		blk_add_trace_msg(q, "Queue congested: setting congested flag");
+		blk_set_queue_congested(q, is_sync);
+	}
+
+	/*
+	 * Looks like there is no user of queue full now.
+	 * Keeping it for time being.
+	 */
+	if (q->rq_pool.count[is_sync]+1 >= q->nr_requests) {
+		blk_add_trace_msg(q, "Queue congested: setting full flag");
+		blk_set_queue_full(q, is_sync);
+	}
+
+	if (rl->count[is_sync]+1 >= q->nr_group_requests) {
+		ioc = current_io_context(GFP_ATOMIC, q->node);
+		/*
+		 * The queue request descriptor group will fill after this
+		 * allocation, so mark this process as "batching".
+		 * This process will be allowed to complete a batch of
+		 * requests, others will be blocked.
+		 */
+		if (rl->count[is_sync] <= q->nr_group_requests)
+			ioc_set_batching(q, ioc);
+		else if (may_queue != ELV_MQUEUE_MUST
+				&& !ioc_batching(q, ioc)) {
 			/*
-			 * The queue will fill after this allocation, so set
-			 * it as full, and mark this process as "batching".
-			 * This process will be allowed to complete a batch of
-			 * requests, others will be blocked.
+			 * The queue is full and the allocating
+			 * process is not a "batcher", and not
+			 * exempted by the IO scheduler
 			 */
-			if (!blk_queue_full(q, is_sync)) {
-				ioc_set_batching(q, ioc);
-				blk_set_queue_full(q, is_sync);
-			} else {
-				if (may_queue != ELV_MQUEUE_MUST
-						&& !ioc_batching(q, ioc)) {
-					/*
-					 * The queue is full and the allocating
-					 * process is not a "batcher", and not
-					 * exempted by the IO scheduler
-					 */
-					goto out;
-				}
-			}
+			blk_add_trace_msg(q, "Queue congested: "
+						"not allocating request");
+			goto out;
 		}
-		blk_set_queue_congested(q, is_sync);
 	}
 
 	/*
@@ -742,18 +786,26 @@ static struct request *get_request(struct request_queue *q, int rw_flags,
 	 * limit of requests, otherwise we could have thousands of requests
 	 * allocated with any setting of ->nr_requests
 	 */
-	if (rl->count[is_sync] >= (3 * q->nr_requests / 2))
+	if (rl->count[is_sync] >= (3 * q->nr_group_requests / 2)) {
+		blk_add_trace_msg(q, "50 percent over limit, not allocating");
 		goto out;
+	}
 
-	rl->count[is_sync]++;
-	rl->starved[is_sync] = 0;
 
+	priv = !test_bit(QUEUE_FLAG_ELVSWITCH, &q->queue_flags);
 	if (blk_rq_should_init_elevator(bio)) {
-		priv = !test_bit(QUEUE_FLAG_ELVSWITCH, &q->queue_flags);
 		if (priv)
-			rl->elvpriv++;
+			q->rq_pool.elvpriv++;
 	}
 
+	/*
+	 * If the scheduler supports per cgroup request lists it will call
+	 * blk_alloced_request after the request and queue is allocated and
+	 * the cgroup has been decided.
+	 */
+	if (!blk_supports_cgroups(q) || !priv)
+		blk_alloced_request(q, rl, is_sync);
+
 	if (blk_queue_io_stat(q))
 		rw_flags |= REQ_IO_STAT;
 	spin_unlock_irq(q->queue_lock);
@@ -768,7 +820,8 @@ static struct request *get_request(struct request_queue *q, int rw_flags,
 		 * wait queue, but this is pretty rare.
 		 */
 		spin_lock_irq(q->queue_lock);
-		freed_request(q, is_sync, priv);
+		if (!blk_supports_cgroups(q) || !priv)
+			freed_request(q, is_sync, priv, rl);
 
 		/*
 		 * in the very unlikely event that allocation failed and no
@@ -778,9 +831,11 @@ static struct request *get_request(struct request_queue *q, int rw_flags,
 		 * rq mempool into READ and WRITE
 		 */
 rq_starved:
-		if (unlikely(rl->count[is_sync] == 0))
+		if (unlikely(rl->count[is_sync] == 0)) {
+			blk_add_trace_msg(q, "Queue congested: "
+				"marking %d starved", is_sync);
 			rl->starved[is_sync] = 1;
-
+		}
 		goto out;
 	}
 
@@ -809,16 +864,23 @@ static struct request *get_request_wait(struct request_queue *q, int rw_flags,
 {
 	const bool is_sync = rw_is_sync(rw_flags) != 0;
 	struct request *rq;
+	struct request_list *rl = blk_get_request_list(q, bio);
 
-	rq = get_request(q, rw_flags, bio, GFP_NOIO);
+	rq = get_request(q, rw_flags, bio, GFP_NOIO, rl);
 	while (!rq) {
 		DEFINE_WAIT(wait);
 		struct io_context *ioc;
-		struct request_list *rl = &q->rq;
 
+		/*
+		 * We are about to sleep on a request list and we
+		 * drop queue lock. After waking up, we will do
+		 * finish_wait() on request list and in the mean
+		 * time group might be gone. Take a reference to
+		 * the group now.
+		 */
 		prepare_to_wait_exclusive(&rl->wait[is_sync], &wait,
 				TASK_UNINTERRUPTIBLE);
-
+		blk_get_rl_group(q, rl);
 		trace_block_sleeprq(q, bio, rw_flags & 1);
 
 		spin_unlock_irq(q->queue_lock);
@@ -836,7 +898,18 @@ static struct request *get_request_wait(struct request_queue *q, int rw_flags,
 		spin_lock_irq(q->queue_lock);
 		finish_wait(&rl->wait[is_sync], &wait);
 
-		rq = get_request(q, rw_flags, bio, GFP_NOIO);
+		/*
+		 * We had taken a reference to the request list goup.
+		 * Put that now
+		 */
+		blk_put_rl_group(q, rl);
+
+		/*
+		 * After the sleep check the rl again in case the group the bio
+		 * belonged to is gone and it is mapped to root group now
+		 */
+		rl = blk_get_request_list(q, bio);
+		rq = get_request(q, rw_flags, bio, GFP_NOIO, rl);
 	};
 
 	return rq;
@@ -845,6 +918,7 @@ static struct request *get_request_wait(struct request_queue *q, int rw_flags,
 struct request *blk_get_request(struct request_queue *q, int rw, gfp_t gfp_mask)
 {
 	struct request *rq;
+	struct request_list *rl;
 
 	BUG_ON(rw != READ && rw != WRITE);
 
@@ -852,7 +926,8 @@ struct request *blk_get_request(struct request_queue *q, int rw, gfp_t gfp_mask)
 	if (gfp_mask & __GFP_WAIT) {
 		rq = get_request_wait(q, rw, NULL);
 	} else {
-		rq = get_request(q, rw, NULL, gfp_mask);
+		rl = blk_get_request_list(q, NULL);
+		rq = get_request(q, rw, NULL, gfp_mask, rl);
 		if (!rq)
 			spin_unlock_irq(q->queue_lock);
 	}
@@ -1059,12 +1134,14 @@ void __blk_put_request(struct request_queue *q, struct request *req)
 	if (req->cmd_flags & REQ_ALLOCED) {
 		int is_sync = rq_is_sync(req) != 0;
 		int priv = req->cmd_flags & REQ_ELVPRIV;
+		struct request_list *rl = rq_rl(q, req);
 
 		BUG_ON(!list_empty(&req->queuelist));
 		BUG_ON(!hlist_unhashed(&req->hash));
+		BUG_ON(!rl);
 
+		freed_request(q, is_sync, priv, rl);
 		blk_free_request(q, req);
-		freed_request(q, is_sync, priv);
 	}
 }
 EXPORT_SYMBOL_GPL(__blk_put_request);
diff --git a/block/blk-settings.c b/block/blk-settings.c
index 1fa7692..a3039dd 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -158,7 +158,7 @@ void blk_queue_make_request(struct request_queue *q, make_request_fn *mfn)
 	 * set defaults
 	 */
 	q->nr_requests = BLKDEV_MAX_RQ;
-
+	q->nr_group_requests = BLKDEV_MAX_GROUP_RQ;
 	q->make_request_fn = mfn;
 	blk_queue_dma_alignment(q, 511);
 	blk_queue_congestion_threshold(q);
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 261c75c..88116df 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -39,7 +39,6 @@ static ssize_t queue_requests_show(struct request_queue *q, char *page)
 static ssize_t
 queue_requests_store(struct request_queue *q, const char *page, size_t count)
 {
-	struct request_list *rl = &q->rq;
 	unsigned long nr;
 	int ret;
 
@@ -53,33 +52,31 @@ queue_requests_store(struct request_queue *q, const char *page, size_t count)
 	spin_lock_irq(q->queue_lock);
 	q->nr_requests = nr;
 	blk_queue_congestion_threshold(q);
+	spin_unlock_irq(q->queue_lock);
+	return ret;
+}
 
-	if (rl->count[BLK_RW_SYNC] >= queue_congestion_on_threshold(q))
-		blk_set_queue_congested(q, BLK_RW_SYNC);
-	else if (rl->count[BLK_RW_SYNC] < queue_congestion_off_threshold(q))
-		blk_clear_queue_congested(q, BLK_RW_SYNC);
-
-	if (rl->count[BLK_RW_ASYNC] >= queue_congestion_on_threshold(q))
-		blk_set_queue_congested(q, BLK_RW_ASYNC);
-	else if (rl->count[BLK_RW_ASYNC] < queue_congestion_off_threshold(q))
-		blk_clear_queue_congested(q, BLK_RW_ASYNC);
-
-	if (rl->count[BLK_RW_SYNC] >= q->nr_requests) {
-		blk_set_queue_full(q, BLK_RW_SYNC);
-	} else if (rl->count[BLK_RW_SYNC]+1 <= q->nr_requests) {
-		blk_clear_queue_full(q, BLK_RW_SYNC);
-		wake_up(&rl->wait[BLK_RW_SYNC]);
-	}
+#ifdef CONFIG_CFQ_GROUP_IOSCHED
+static ssize_t queue_group_requests_show(struct request_queue *q, char *page)
+{
+	return queue_var_show(q->nr_group_requests, page);
+}
 
-	if (rl->count[BLK_RW_ASYNC] >= q->nr_requests) {
-		blk_set_queue_full(q, BLK_RW_ASYNC);
-	} else if (rl->count[BLK_RW_ASYNC]+1 <= q->nr_requests) {
-		blk_clear_queue_full(q, BLK_RW_ASYNC);
-		wake_up(&rl->wait[BLK_RW_ASYNC]);
-	}
+static ssize_t
+queue_group_requests_store(struct request_queue *q, const char *page,
+				size_t count)
+{
+	unsigned long nr;
+	int ret = queue_var_store(&nr, page, count);
+	if (nr < BLKDEV_MIN_RQ)
+		nr = BLKDEV_MIN_RQ;
+
+	spin_lock_irq(q->queue_lock);
+	q->nr_group_requests = nr;
 	spin_unlock_irq(q->queue_lock);
 	return ret;
 }
+#endif
 
 static ssize_t queue_ra_show(struct request_queue *q, char *page)
 {
@@ -271,6 +268,14 @@ static struct queue_sysfs_entry queue_requests_entry = {
 	.store = queue_requests_store,
 };
 
+#ifdef CONFIG_CFQ_GROUP_IOSCHED
+static struct queue_sysfs_entry queue_group_requests_entry = {
+	.attr = {.name = "nr_group_requests", .mode = S_IRUGO | S_IWUSR },
+	.show = queue_group_requests_show,
+	.store = queue_group_requests_store,
+};
+#endif
+
 static struct queue_sysfs_entry queue_ra_entry = {
 	.attr = {.name = "read_ahead_kb", .mode = S_IRUGO | S_IWUSR },
 	.show = queue_ra_show,
@@ -381,6 +386,9 @@ static struct queue_sysfs_entry queue_random_entry = {
 
 static struct attribute *default_attrs[] = {
 	&queue_requests_entry.attr,
+#ifdef CONFIG_CFQ_GROUP_IOSCHED
+	&queue_group_requests_entry.attr,
+#endif
 	&queue_ra_entry.attr,
 	&queue_max_hw_sectors_entry.attr,
 	&queue_max_sectors_entry.attr,
@@ -467,12 +475,11 @@ static void blk_release_queue(struct kobject *kobj)
 {
 	struct request_queue *q =
 		container_of(kobj, struct request_queue, kobj);
-	struct request_list *rl = &q->rq;
 
 	blk_sync_queue(q);
 
-	if (rl->rq_pool)
-		mempool_destroy(rl->rq_pool);
+	if (q->rq_pool.rq_pool)
+		mempool_destroy(q->rq_pool.rq_pool);
 
 	if (q->queue_tags)
 		__blk_queue_free_tags(q);
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index c885493..23caa79 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -214,6 +214,9 @@ struct cfq_group {
 	enum wl_prio_t saved_serving_prio;
 	struct blkio_group blkg;
 #ifdef CONFIG_CFQ_GROUP_IOSCHED
+	/* Request list associated with the group */
+	struct request_list rl;
+
 	struct hlist_node cfqd_node;
 	int ref;
 #endif
@@ -1137,6 +1140,7 @@ cfq_find_alloc_cfqg(struct cfq_data *cfqd, struct cgroup *cgroup, int create)
 					0);
 
 	cfqg->weight = blkcg_get_weight(blkcg, cfqg->blkg.dev);
+	blk_init_request_list(&cfqg->rl);
 
 	/* Add group on cfqd list */
 	hlist_add_head(&cfqg->cfqd_node, &cfqd->cfqg_list);
@@ -1224,6 +1228,7 @@ static void cfq_put_group_ref(struct cfq_group *cfqg)
 		return;
 	for_each_cfqg_st(cfqg, i, j, st)
 		BUG_ON(!RB_EMPTY_ROOT(&st->rb));
+	BUG_ON(cfqg->rl.count[0] | cfqg->rl.count[1]);
 	kfree(cfqg);
 }
 
@@ -3145,7 +3150,13 @@ cfq_get_queue(struct cfq_data *cfqd, struct bio *bio, int *is_oo_ctx,
 	const int ioprio_class = task_ioprio_class(ioc);
 	struct cfq_queue **async_cfqq = NULL;
 	struct cfq_queue *cfqq = NULL;
-	struct cfq_group *cfqg = cfq_get_cfqg_bio(cfqd, bio, is_oo_ctx, 1);
+	/* If cfqg has not been allocated during request list allocation,
+	   do not create it now. Otherwise, request list counter could get
+	   off-by one errors.
+	 */
+	struct cfq_group *cfqg = cfq_get_cfqg_bio(cfqd, bio, is_oo_ctx, 0);
+	if (!cfqg)
+		cfqg = &cfqd->root_group;
 
 	if (!is_sync) {
 		async_cfqq = cfq_async_queue_prio(cfqg, ioprio_class,
@@ -3581,6 +3592,46 @@ static void cfq_insert_request(struct request_queue *q, struct request *rq)
 	cfq_rq_enqueued(cfqd, cfqq, rq);
 }
 
+#ifdef CONFIG_CFQ_GROUP_IOSCHED
+/*
+ * This function is essentially overloaded to return a request list
+ * given either a bio or a request. Only one of these is expected to
+ * be provided on any given invocation. The other must be NULL.
+ */
+static struct request_list *cfq_request_list(struct request_queue *q,
+					     struct bio *bio,
+					     struct request *rq)
+{
+	if (rq) {
+		struct cfq_queue *cfqq = RQ_CFQQ(rq);
+		return &cfqq->cfqg->rl;
+	} else {
+		struct cfq_data *cfqd = q->elevator->elevator_data;
+		struct cfq_group *cfqg = cfq_get_cfqg_bio(cfqd, bio, NULL, 1);
+
+		if (!cfqg)
+			cfqg = &cfqd->root_group;
+		return &cfqg->rl;
+	}
+}
+
+#define RL_CFQG(rl) container_of((rl), struct cfq_group, rl)
+
+static void cfq_get_rl_group(struct request_list *rl)
+{
+	struct cfq_group *cfqg = RL_CFQG(rl);
+
+	cfqg->ref++;
+}
+
+static void cfq_put_rl_group(struct request_list *rl)
+{
+	struct cfq_group *cfqg = RL_CFQG(rl);
+
+	cfq_put_group_ref(cfqg);
+}
+#endif
+
 /*
  * Update hw_tag based on peak queue depth over 50 samples under
  * sufficient load.
@@ -3908,6 +3959,8 @@ new_queue:
 
 	cfq_get_group_ref(cfqq->cfqg);
 	rq->elevator_private[2] = cfqq->cfqg;
+
+	blk_alloced_request(q, rq_rl(q, rq), is_sync != 0);
 	spin_unlock_irqrestore(q->queue_lock, flags);
 	return 0;
 
@@ -4110,6 +4163,7 @@ static void *cfq_init_queue(struct request_queue *q)
 	 */
 	cfq_get_group_ref(cfqg);
 	rcu_read_lock();
+	blk_init_request_list(&cfqg->rl);
 	cfq_blkiocg_add_blkio_group(&blkio_root_cgroup, &cfqg->blkg,
 					(void *)cfqd, 0);
 	rcu_read_unlock();
@@ -4294,6 +4348,11 @@ static struct elevator_type iosched_cfq = {
 		.elevator_completed_req_fn =	cfq_completed_request,
 		.elevator_former_req_fn =	elv_rb_former_request,
 		.elevator_latter_req_fn =	elv_rb_latter_request,
+#ifdef CONFIG_CFQ_GROUP_IOSCHED
+		.elevator_req_list_fn =		cfq_request_list,
+		.elevator_get_rl_group_fn =	cfq_get_rl_group,
+		.elevator_put_rl_group_fn =	cfq_put_rl_group,
+#endif
 		.elevator_set_req_fn =		cfq_set_request,
 		.elevator_put_req_fn =		cfq_put_request,
 		.elevator_may_queue_fn =	cfq_may_queue,
diff --git a/block/elevator.c b/block/elevator.c
index 9edaeb5..f427fad 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -641,7 +641,7 @@ void elv_quiesce_start(struct request_queue *q)
 	 * make sure we don't have any requests in flight
 	 */
 	elv_drain_elevator(q);
-	while (q->rq.elvpriv) {
+	while (q->rq_pool.elvpriv) {
 		__blk_run_queue(q, false);
 		spin_unlock_irq(q->queue_lock);
 		msleep(10);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 16a902f..a8802ce 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -32,7 +32,18 @@ struct request;
 struct sg_io_hdr;
 
 #define BLKDEV_MIN_RQ	4
+
+#ifdef CONFIG_CFQ_GROUP_IOSCHED
+#define BLKDEV_MAX_RQ	128	/* Default maximum */
+#define BLKDEV_MAX_GROUP_RQ	128	/* Default per group maximum */
+#else
 #define BLKDEV_MAX_RQ	128	/* Default maximum */
+/*
+ * This is eqivalent to case of only one group present (root group). Let
+ * it consume all the request descriptors available on the queue.
+ */
+#define BLKDEV_MAX_GROUP_RQ    BLKDEV_MAX_RQ
+#endif
 
 struct request;
 typedef void (rq_end_io_fn)(struct request *, int);
@@ -44,9 +55,21 @@ struct request_list {
 	 */
 	int count[2];
 	int starved[2];
+	wait_queue_head_t wait[2];
+};
+
+/*
+ * This data structure keeps track of mempool of requests for the queue
+ * and some overall statistics.
+ */
+struct request_pool {
+	/*
+	 * Per queue request descriptor count. This is in addition to per
+	 * cgroup count.
+	 */
+	int count[2];
 	int elvpriv;
 	mempool_t *rq_pool;
-	wait_queue_head_t wait[2];
 };
 
 /*
@@ -274,6 +297,11 @@ struct request_queue
 	 */
 	struct request_list	rq;
 
+	/*
+	 * Contains request pool and other data like overall request count
+	 */
+	struct request_pool	rq_pool;
+
 	request_fn_proc		*request_fn;
 	make_request_fn		*make_request_fn;
 	prep_rq_fn		*prep_rq_fn;
@@ -330,6 +358,7 @@ struct request_queue
 	 * queue settings
 	 */
 	unsigned long		nr_requests;	/* Max # of requests */
+	unsigned long		nr_group_requests;
 	unsigned int		nr_congestion_on;
 	unsigned int		nr_congestion_off;
 	unsigned int		nr_batching;
@@ -606,6 +635,53 @@ static inline void blk_queue_bounce(struct request_queue *q, struct bio **bio)
 }
 #endif /* CONFIG_MMU */
 
+static inline struct request_list *blk_get_request_list(struct request_queue *q,
+							struct bio *bio)
+{
+	struct elevator_queue *e = q->elevator;
+	int priv = !test_bit(QUEUE_FLAG_ELVSWITCH, &q->queue_flags);
+
+	if (priv && e->ops->elevator_req_list_fn)
+		return e->ops->elevator_req_list_fn(q, bio, NULL);
+	return &q->rq;
+}
+
+static inline struct request_list *rq_rl(struct request_queue *q,
+					 struct request *rq)
+{
+	struct elevator_queue *e = q->elevator;
+	int priv = rq->cmd_flags & REQ_ELVPRIV;
+
+	if (priv && e->ops->elevator_req_list_fn)
+		return e->ops->elevator_req_list_fn(q, NULL, rq);
+	return &q->rq;
+}
+
+static inline void blk_get_rl_group(struct request_queue *q,
+				    struct request_list *rl)
+{
+	struct elevator_queue *e = q->elevator;
+
+	if (e->ops->elevator_get_rl_group_fn)
+		e->ops->elevator_get_rl_group_fn(rl);
+}
+
+static inline void blk_put_rl_group(struct request_queue *q,
+				    struct request_list *rl)
+{
+	struct elevator_queue *e = q->elevator;
+
+	if (e->ops->elevator_put_rl_group_fn)
+		e->ops->elevator_put_rl_group_fn(rl);
+}
+
+static inline int blk_supports_cgroups(struct request_queue *q)
+{
+	struct elevator_queue *e = q->elevator;
+
+	return (e->ops->elevator_req_list_fn) ? 1 : 0;
+}
+
 struct rq_map_data {
 	struct page **pages;
 	int page_order;
@@ -802,6 +878,7 @@ extern struct request_queue *blk_init_allocated_queue_node(struct request_queue
 extern struct request_queue *blk_init_queue(request_fn_proc *, spinlock_t *);
 extern struct request_queue *blk_init_allocated_queue(struct request_queue *,
 						      request_fn_proc *, spinlock_t *);
+extern void blk_init_request_list(struct request_list *rl);
 extern void blk_cleanup_queue(struct request_queue *);
 extern void blk_queue_make_request(struct request_queue *, make_request_fn *);
 extern void blk_queue_bounce_limit(struct request_queue *, u64);
@@ -853,6 +930,8 @@ int blk_get_queue(struct request_queue *);
 struct request_queue *blk_alloc_queue(gfp_t);
 struct request_queue *blk_alloc_queue_node(gfp_t, int);
 extern void blk_put_queue(struct request_queue *);
+extern void blk_alloced_request(struct request_queue *q,
+				struct request_list *rl, int sync);
 
 struct blk_plug {
 	unsigned long magic;
diff --git a/include/linux/elevator.h b/include/linux/elevator.h
index c3a884c..767bade 100644
--- a/include/linux/elevator.h
+++ b/include/linux/elevator.h
@@ -21,6 +21,10 @@ typedef int (elevator_dispatch_fn) (struct request_queue *, int);
 
 typedef void (elevator_add_req_fn) (struct request_queue *, struct request *);
 typedef struct request *(elevator_request_list_fn) (struct request_queue *, struct request *);
+typedef struct request_list *(elevator_req_list_fn)
+		(struct request_queue *, struct bio *, struct request *);
+typedef void (elevator_get_rl_group_fn)(struct request_list *);
+typedef void (elevator_put_rl_group_fn)(struct request_list *);
 typedef void (elevator_completed_req_fn) (struct request_queue *, struct request *);
 typedef int (elevator_may_queue_fn) (struct request_queue *, int);
 
@@ -50,10 +54,14 @@ struct elevator_ops
 
 	elevator_request_list_fn *elevator_former_req_fn;
 	elevator_request_list_fn *elevator_latter_req_fn;
+	elevator_req_list_fn *elevator_req_list_fn;
 
 	elevator_set_req_fn *elevator_set_req_fn;
 	elevator_put_req_fn *elevator_put_req_fn;
 
+	elevator_get_rl_group_fn *elevator_get_rl_group_fn;
+	elevator_put_rl_group_fn *elevator_put_rl_group_fn;
+
 	elevator_may_queue_fn *elevator_may_queue_fn;
 
 	elevator_init_fn *elevator_init_fn;
-- 
1.7.3.1

