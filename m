Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754652Ab1JZBtK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 21:49:10 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:42843 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932098Ab1JZBtH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 21:49:07 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, vgoyal@redhat.com
Cc: ctalbott@google.com, rni@google.com, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 09/13] block, cfq: fix cic lookup locking
Date: Tue, 25 Oct 2011 18:48:35 -0700
Message-Id: <1319593719-19132-10-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1319593719-19132-1-git-send-email-tj@kernel.org>
References: <1319593719-19132-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* cfq_cic_lookup() may be called without queue_lock and multiple tasks
  can execute it simultaneously for the same shared ioc.  Nothing
  prevents them racing each other and trying to drop the same dead cic
  entry multiple times.

* smp_wmb() in cfq_exit_cic() doesn't really do anything and nothing
  prevents cfq_cic_lookup() seeing stale cic->key.  This usually
  doesn't blow up because by the time cic is exited, all requests have
  been drained and new requests are terminated before going through
  elevator.  However, it can still be triggered by plug merge path
  which doesn't grab queue_lock and thus can't check DEAD state
  reliably.

This patch updates lookup locking such that,

* Lookup is always performed under queue_lock.  This doesn't add any
  more locking.  The only issue is cfq_allow_merge() which can be
  called from plug merge path without holding any lock.  For now, this
  is worked around by using cic of the request to merge into, which is
  guaranteed to have the same ioc.  For longer term, I think it would
  be best to separate out plug merge method from regular one.

* Spurious ioc->lock locking around cic lookup hint assignment
  dropped.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
---
 block/cfq-iosched.c |   69 ++++++++++++++++++++++++++------------------------
 1 files changed, 36 insertions(+), 33 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 181a63d..e617b08 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -1682,12 +1682,19 @@ static int cfq_allow_merge(struct request_queue *q, struct request *rq,
 		return false;
 
 	/*
-	 * Lookup the cfqq that this bio will be queued with. Allow
-	 * merge only if rq is queued there.
+	 * Lookup the cfqq that this bio will be queued with and allow
+	 * merge only if rq is queued there.  This function can be called
+	 * from plug merge without queue_lock.  In such cases, ioc of @rq
+	 * and %current are guaranteed to be equal.  Avoid lookup which
+	 * requires queue_lock by using @rq's cic.
 	 */
-	cic = cfq_cic_lookup(cfqd, current->io_context);
-	if (!cic)
-		return false;
+	if (current->io_context == RQ_CIC(rq)->ioc) {
+		cic = RQ_CIC(rq);
+	} else {
+		cic = cfq_cic_lookup(cfqd, current->io_context);
+		if (!cic)
+			return false;
+	}
 
 	cfqq = cic_to_cfqq(cic, cfq_bio_sync(bio));
 	return cfqq == RQ_CFQQ(rq);
@@ -2784,21 +2791,15 @@ static void cfq_exit_cic(struct cfq_io_context *cic)
 	struct io_context *ioc = cic->ioc;
 
 	list_del_init(&cic->queue_list);
+	cic->key = cfqd_dead_key(cfqd);
 
 	/*
-	 * Make sure dead mark is seen for dead queues
+	 * Both setting lookup hint to and clearing it from @cic are done
+	 * under queue_lock.  If it's not pointing to @cic now, it never
+	 * will.  Hint assignment itself can race safely.
 	 */
-	smp_wmb();
-	cic->key = cfqd_dead_key(cfqd);
-
-	rcu_read_lock();
-	if (rcu_dereference(ioc->ioc_data) == cic) {
-		rcu_read_unlock();
-		spin_lock(&ioc->lock);
+	if (rcu_dereference_raw(ioc->ioc_data) == cic)
 		rcu_assign_pointer(ioc->ioc_data, NULL);
-		spin_unlock(&ioc->lock);
-	} else
-		rcu_read_unlock();
 
 	if (cic->cfqq[BLK_RW_ASYNC]) {
 		cfq_exit_cfqq(cfqd, cic->cfqq[BLK_RW_ASYNC]);
@@ -3092,12 +3093,20 @@ cfq_drop_dead_cic(struct cfq_data *cfqd, struct io_context *ioc,
 	cfq_cic_free(cic);
 }
 
+/**
+ * cfq_cic_lookup - lookup cfq_io_context
+ * @cfqd: the associated cfq_data
+ * @ioc: the associated io_context
+ *
+ * Look up cfq_io_context associated with @cfqd - @ioc pair.  Must be
+ * called with queue_lock held.
+ */
 static struct cfq_io_context *
 cfq_cic_lookup(struct cfq_data *cfqd, struct io_context *ioc)
 {
 	struct cfq_io_context *cic;
-	unsigned long flags;
 
+	lockdep_assert_held(cfqd->queue->queue_lock);
 	if (unlikely(!ioc))
 		return NULL;
 
@@ -3107,28 +3116,22 @@ cfq_cic_lookup(struct cfq_data *cfqd, struct io_context *ioc)
 	 * we maintain a last-hit cache, to avoid browsing over the tree
 	 */
 	cic = rcu_dereference(ioc->ioc_data);
-	if (cic && cic->key == cfqd) {
-		rcu_read_unlock();
-		return cic;
-	}
+	if (cic && cic->key == cfqd)
+		goto out;
 
 	do {
 		cic = radix_tree_lookup(&ioc->radix_root, cfqd->queue->id);
-		rcu_read_unlock();
 		if (!cic)
 			break;
-		if (unlikely(cic->key != cfqd)) {
-			cfq_drop_dead_cic(cfqd, ioc, cic);
-			rcu_read_lock();
-			continue;
+		if (likely(cic->key == cfqd)) {
+			/* hint assignment itself can race safely */
+			rcu_assign_pointer(ioc->ioc_data, cic);
+			break;
 		}
-
-		spin_lock_irqsave(&ioc->lock, flags);
-		rcu_assign_pointer(ioc->ioc_data, cic);
-		spin_unlock_irqrestore(&ioc->lock, flags);
-		break;
+		cfq_drop_dead_cic(cfqd, ioc, cic);
 	} while (1);
-
+out:
+	rcu_read_unlock();
 	return cic;
 }
 
-- 
1.7.3.1

