Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755188Ab0ETTeB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 15:34:01 -0400
Received: from relay.parallels.com ([195.214.232.42]:55231 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752830Ab0ETTd5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 15:33:57 -0400
Subject: [PATCH 1/2] cfq-iosched: remove dead_key from cfq_io_context
To: <linux-kernel@vger.kernel.org>, Jens Axboe <jens.axboe@oracle.com>
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
CC: Dmitry Monakhov <dmonakhov@openvz.org>
Date: Thu, 20 May 2010 23:21:34 +0400
Message-ID: <20100520192134.19366.88949.stgit@zurg>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove ->dead_key field from cfq_io_context to shrink its size to 128 bytes.
(64 bytes for 32-bit hosts)

Use lower bit in ->key as dead-mark, instead of moving key to separate field.
After this for dead cfq_io_context we got cic->key != cfqd automatically.
Thus, io_context's last-hit cache should work without changing.

Now to check ->key for non-dead state compare it with cfqd,
instead of checking ->key for non-null value as it was before.

Plus remove obsolete race protection in cfq_cic_lookup.
This race gone after v2.6.24-1728-g4ac845a

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
---
 block/cfq-iosched.c       |   41 ++++++++++++++++++++++++++++-------------
 include/linux/iocontext.h |    1 -
 2 files changed, 28 insertions(+), 14 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 5f127cf..67745e5 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -431,6 +431,23 @@ static inline void cic_set_cfqq(struct cfq_io_context *cic,
 	cic->cfqq[is_sync] = cfqq;
 }
 
+#define CIC_DEAD_KEY	1ul
+
+static inline void *cfqd_dead_key(struct cfq_data *cfqd)
+{
+	return (void *)((unsigned long) cfqd | CIC_DEAD_KEY);
+}
+
+static inline struct cfq_data *cic_to_cfqd(struct cfq_io_context *cic)
+{
+	struct cfq_data *cfqd = cic->key;
+
+	if (unlikely((unsigned long) cfqd & CIC_DEAD_KEY))
+		return NULL;
+
+	return cfqd;
+}
+
 /*
  * We regard a request as SYNC, if it's either a read or has the SYNC bit
  * set (in which case it could also be direct WRITE).
@@ -2476,11 +2493,12 @@ static void cfq_cic_free(struct cfq_io_context *cic)
 static void cic_free_func(struct io_context *ioc, struct cfq_io_context *cic)
 {
 	unsigned long flags;
+	unsigned long dead_key = (unsigned long) cic->key;
 
-	BUG_ON(!cic->dead_key);
+	BUG_ON(!(dead_key & CIC_DEAD_KEY));
 
 	spin_lock_irqsave(&ioc->lock, flags);
-	radix_tree_delete(&ioc->radix_root, cic->dead_key);
+	radix_tree_delete(&ioc->radix_root, dead_key & ~CIC_DEAD_KEY);
 	hlist_del_rcu(&cic->cic_list);
 	spin_unlock_irqrestore(&ioc->lock, flags);
 
@@ -2539,11 +2557,10 @@ static void __cfq_exit_single_io_context(struct cfq_data *cfqd,
 	list_del_init(&cic->queue_list);
 
 	/*
-	 * Make sure key == NULL is seen for dead queues
+	 * Make sure dead mark is seen for dead queues
 	 */
 	smp_wmb();
-	cic->dead_key = (unsigned long) cic->key;
-	cic->key = NULL;
+	cic->key = cfqd_dead_key(cfqd);
 
 	if (ioc->ioc_data == cic)
 		rcu_assign_pointer(ioc->ioc_data, NULL);
@@ -2562,7 +2579,7 @@ static void __cfq_exit_single_io_context(struct cfq_data *cfqd,
 static void cfq_exit_single_io_context(struct io_context *ioc,
 				       struct cfq_io_context *cic)
 {
-	struct cfq_data *cfqd = cic->key;
+	struct cfq_data *cfqd = cic_to_cfqd(cic);
 
 	if (cfqd) {
 		struct request_queue *q = cfqd->queue;
@@ -2575,7 +2592,7 @@ static void cfq_exit_single_io_context(struct io_context *ioc,
 		 * race between exiting task and queue
 		 */
 		smp_read_barrier_depends();
-		if (cic->key)
+		if (cic->key == cfqd)
 			__cfq_exit_single_io_context(cfqd, cic);
 
 		spin_unlock_irqrestore(q->queue_lock, flags);
@@ -2655,7 +2672,7 @@ static void cfq_init_prio_data(struct cfq_queue *cfqq, struct io_context *ioc)
 
 static void changed_ioprio(struct io_context *ioc, struct cfq_io_context *cic)
 {
-	struct cfq_data *cfqd = cic->key;
+	struct cfq_data *cfqd = cic_to_cfqd(cic);
 	struct cfq_queue *cfqq;
 	unsigned long flags;
 
@@ -2712,7 +2729,7 @@ static void cfq_init_cfqq(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 static void changed_cgroup(struct io_context *ioc, struct cfq_io_context *cic)
 {
 	struct cfq_queue *sync_cfqq = cic_to_cfqq(cic, 1);
-	struct cfq_data *cfqd = cic->key;
+	struct cfq_data *cfqd = cic_to_cfqd(cic);
 	unsigned long flags;
 	struct request_queue *q;
 
@@ -2849,6 +2866,7 @@ cfq_drop_dead_cic(struct cfq_data *cfqd, struct io_context *ioc,
 	unsigned long flags;
 
 	WARN_ON(!list_empty(&cic->queue_list));
+	BUG_ON(cic->key != cfqd_dead_key(cfqd));
 
 	spin_lock_irqsave(&ioc->lock, flags);
 
@@ -2866,7 +2884,6 @@ cfq_cic_lookup(struct cfq_data *cfqd, struct io_context *ioc)
 {
 	struct cfq_io_context *cic;
 	unsigned long flags;
-	void *k;
 
 	if (unlikely(!ioc))
 		return NULL;
@@ -2887,9 +2904,7 @@ cfq_cic_lookup(struct cfq_data *cfqd, struct io_context *ioc)
 		rcu_read_unlock();
 		if (!cic)
 			break;
-		/* ->key must be copied to avoid race with cfq_exit_queue() */
-		k = cic->key;
-		if (unlikely(!k)) {
+		if (unlikely(cic->key != cfqd)) {
 			cfq_drop_dead_cic(cfqd, ioc, cic);
 			rcu_read_lock();
 			continue;
diff --git a/include/linux/iocontext.h b/include/linux/iocontext.h
index a0bb301..64d5291 100644
--- a/include/linux/iocontext.h
+++ b/include/linux/iocontext.h
@@ -7,7 +7,6 @@
 struct cfq_queue;
 struct cfq_io_context {
 	void *key;
-	unsigned long dead_key;
 
 	struct cfq_queue *cfqq[2];
 

