Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754417Ab1JZBCZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 21:02:25 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:65206 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754321Ab1JZBCW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 21:02:22 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, vgoyal@redhat.com, jgarzik@pobox.com, davem@davemloft.net,
        hch@infradead.org
Cc: ctalbott@google.com, rni@google.com, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 4/6] block: add blk_queue_dead()
Date: Tue, 25 Oct 2011 18:02:05 -0700
Message-Id: <1319590927-15791-5-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1319590927-15791-1-git-send-email-tj@kernel.org>
References: <1319590927-15791-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are a number of QUEUE_FLAG_DEAD tests.  Add blk_queue_dead()
macro and use it.

This patch doesn't introduce any functional difference.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
---
 block/blk-core.c       |    6 +++---
 block/blk-exec.c       |    2 +-
 block/blk-sysfs.c      |    4 ++--
 block/blk-throttle.c   |    4 ++--
 block/blk.h            |    2 +-
 include/linux/blkdev.h |    1 +
 6 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 1efb943..7d39897 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -603,7 +603,7 @@ EXPORT_SYMBOL(blk_init_allocated_queue_node);
 
 int blk_get_queue(struct request_queue *q)
 {
-	if (likely(!test_bit(QUEUE_FLAG_DEAD, &q->queue_flags))) {
+	if (likely(!blk_queue_dead(q))) {
 		kobject_get(&q->kobj);
 		return 0;
 	}
@@ -750,7 +750,7 @@ static struct request *get_request(struct request_queue *q, int rw_flags,
 	const bool is_sync = rw_is_sync(rw_flags) != 0;
 	int may_queue;
 
-	if (unlikely(test_bit(QUEUE_FLAG_DEAD, &q->queue_flags)))
+	if (unlikely(blk_queue_dead(q)))
 		return NULL;
 
 	may_queue = elv_may_queue(q, rw_flags);
@@ -870,7 +870,7 @@ static struct request *get_request_wait(struct request_queue *q, int rw_flags,
 		struct io_context *ioc;
 		struct request_list *rl = &q->rq;
 
-		if (unlikely(test_bit(QUEUE_FLAG_DEAD, &q->queue_flags)))
+		if (unlikely(blk_queue_dead(q)))
 			return NULL;
 
 		prepare_to_wait_exclusive(&rl->wait[is_sync], &wait,
diff --git a/block/blk-exec.c b/block/blk-exec.c
index 951eda7..8716557 100644
--- a/block/blk-exec.c
+++ b/block/blk-exec.c
@@ -52,7 +52,7 @@ void blk_execute_rq_nowait(struct request_queue *q, struct gendisk *bd_disk,
 	bool may_sleep = !preempt_count() && !irqs_disabled();
 	unsigned long flags;
 
-	if (unlikely(test_bit(QUEUE_FLAG_DEAD, &q->queue_flags))) {
+	if (unlikely(blk_queue_dead(q))) {
 		rq->errors = -ENXIO;
 		if (rq->end_io)
 			rq->end_io(rq, rq->errors);
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index e7f9f65..f0b2ca8 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -425,7 +425,7 @@ queue_attr_show(struct kobject *kobj, struct attribute *attr, char *page)
 	if (!entry->show)
 		return -EIO;
 	mutex_lock(&q->sysfs_lock);
-	if (test_bit(QUEUE_FLAG_DEAD, &q->queue_flags)) {
+	if (blk_queue_dead(q)) {
 		mutex_unlock(&q->sysfs_lock);
 		return -ENOENT;
 	}
@@ -447,7 +447,7 @@ queue_attr_store(struct kobject *kobj, struct attribute *attr,
 
 	q = container_of(kobj, struct request_queue, kobj);
 	mutex_lock(&q->sysfs_lock);
-	if (test_bit(QUEUE_FLAG_DEAD, &q->queue_flags)) {
+	if (blk_queue_dead(q)) {
 		mutex_unlock(&q->sysfs_lock);
 		return -ENOENT;
 	}
diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 4553245..5eed6a7 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -310,7 +310,7 @@ static struct throtl_grp * throtl_get_tg(struct throtl_data *td)
 	struct request_queue *q = td->queue;
 
 	/* no throttling for dead queue */
-	if (unlikely(test_bit(QUEUE_FLAG_DEAD, &q->queue_flags)))
+	if (unlikely(blk_queue_dead(q)))
 		return NULL;
 
 	rcu_read_lock();
@@ -335,7 +335,7 @@ static struct throtl_grp * throtl_get_tg(struct throtl_data *td)
 	spin_lock_irq(q->queue_lock);
 
 	/* Make sure @q is still alive */
-	if (unlikely(test_bit(QUEUE_FLAG_DEAD, &q->queue_flags))) {
+	if (unlikely(blk_queue_dead(q))) {
 		kfree(tg);
 		return NULL;
 	}
diff --git a/block/blk.h b/block/blk.h
index 77ad885..f8c797c 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -86,7 +86,7 @@ static inline struct request *__elv_next_request(struct request_queue *q)
 			q->flush_queue_delayed = 1;
 			return NULL;
 		}
-		if (test_bit(QUEUE_FLAG_DEAD, &q->queue_flags) ||
+		if (unlikely(blk_queue_dead(q)) ||
 		    !q->elevator->ops->elevator_dispatch_fn(q, 0))
 			return NULL;
 	}
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 45563b0..6a4ab84 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -481,6 +481,7 @@ static inline void queue_flag_clear(unsigned int flag, struct request_queue *q)
 
 #define blk_queue_tagged(q)	test_bit(QUEUE_FLAG_QUEUED, &(q)->queue_flags)
 #define blk_queue_stopped(q)	test_bit(QUEUE_FLAG_STOPPED, &(q)->queue_flags)
+#define blk_queue_dead(q)	test_bit(QUEUE_FLAG_DEAD, &(q)->queue_flags)
 #define blk_queue_nomerges(q)	test_bit(QUEUE_FLAG_NOMERGES, &(q)->queue_flags)
 #define blk_queue_noxmerges(q)	\
 	test_bit(QUEUE_FLAG_NOXMERGES, &(q)->queue_flags)
-- 
1.7.3.1

