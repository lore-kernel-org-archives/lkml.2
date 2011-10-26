Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932262Ab1JZBtP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 21:49:15 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:42303 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932098Ab1JZBtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 21:49:11 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, vgoyal@redhat.com
Cc: ctalbott@google.com, rni@google.com, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 11/13] block, cfq: remove delayed unlink
Date: Tue, 25 Oct 2011 18:48:37 -0700
Message-Id: <1319593719-19132-12-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1319593719-19132-1-git-send-email-tj@kernel.org>
References: <1319593719-19132-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that all cic's are immediately unlinked from both ioc and queue,
lazy dropping from lookup path and trimming on elevator unregister are
unnecessary.  Kill them and remove now unused elevator_ops->trim().

This also leaves call_for_each_cic() without any user.  Removed.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
---
 block/cfq-iosched.c      |   92 +++++-----------------------------------------
 block/elevator.c         |   16 --------
 include/linux/elevator.h |    1 -
 3 files changed, 10 insertions(+), 99 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 6cc6065..ff44435 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -2669,24 +2669,6 @@ static void cfq_put_queue(struct cfq_queue *cfqq)
 	cfq_put_cfqg(cfqg);
 }
 
-/*
- * Call func for each cic attached to this ioc.
- */
-static void
-call_for_each_cic(struct io_context *ioc,
-		  void (*func)(struct io_context *, struct cfq_io_context *))
-{
-	struct cfq_io_context *cic;
-	struct hlist_node *n;
-
-	rcu_read_lock();
-
-	hlist_for_each_entry_rcu(cic, n, &ioc->cic_list, cic_list)
-		func(ioc, cic);
-
-	rcu_read_unlock();
-}
-
 static void cfq_cic_free_rcu(struct rcu_head *head)
 {
 	struct cfq_io_context *cic;
@@ -2727,31 +2709,6 @@ static void cfq_release_cic(struct cfq_io_context *cic)
 	cfq_cic_free(cic);
 }
 
-static void cic_free_func(struct io_context *ioc, struct cfq_io_context *cic)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&ioc->lock, flags);
-	cfq_release_cic(cic);
-	spin_unlock_irqrestore(&ioc->lock, flags);
-}
-
-/*
- * Must be called with rcu_read_lock() held or preemption otherwise disabled.
- * Only two callers of this - ->dtor() which is called with the rcu_read_lock(),
- * and ->trim() which is called with the task lock held
- */
-static void cfq_free_io_context(struct io_context *ioc)
-{
-	/*
-	 * ioc->refcount is zero here, or we are called from elv_unregister(),
-	 * so no more cic's are allowed to be linked into this ioc.  So it
-	 * should be ok to iterate over the known list, we will see all cic's
-	 * since no new ones are added.
-	 */
-	call_for_each_cic(ioc, cic_free_func);
-}
-
 static void cfq_put_cooperator(struct cfq_queue *cfqq)
 {
 	struct cfq_queue *__cfqq, *next;
@@ -3037,30 +2994,6 @@ cfq_get_queue(struct cfq_data *cfqd, bool is_sync, struct io_context *ioc,
 	return cfqq;
 }
 
-/*
- * We drop cfq io contexts lazily, so we may find a dead one.
- */
-static void
-cfq_drop_dead_cic(struct cfq_data *cfqd, struct io_context *ioc,
-		  struct cfq_io_context *cic)
-{
-	unsigned long flags;
-
-	WARN_ON(!list_empty(&cic->queue_list));
-	BUG_ON(cic->key != cfqd_dead_key(cfqd));
-
-	spin_lock_irqsave(&ioc->lock, flags);
-
-	BUG_ON(rcu_dereference_check(ioc->ioc_data,
-		lockdep_is_held(&ioc->lock)) == cic);
-
-	radix_tree_delete(&ioc->radix_root, cfqd->queue->id);
-	hlist_del_rcu(&cic->cic_list);
-	spin_unlock_irqrestore(&ioc->lock, flags);
-
-	cfq_cic_free(cic);
-}
-
 /**
  * cfq_cic_lookup - lookup cfq_io_context
  * @cfqd: the associated cfq_data
@@ -3078,26 +3011,22 @@ cfq_cic_lookup(struct cfq_data *cfqd, struct io_context *ioc)
 	if (unlikely(!ioc))
 		return NULL;
 
-	rcu_read_lock();
-
 	/*
-	 * we maintain a last-hit cache, to avoid browsing over the tree
+	 * cic's are indexed from @ioc using radix tree and hint pointer,
+	 * both of which are protected with RCU.  All removals are done
+	 * holding both q and ioc locks, and we're holding q lock - if we
+	 * find a cic which points to us, it's guaranteed to be valid.
 	 */
+	rcu_read_lock();
 	cic = rcu_dereference(ioc->ioc_data);
 	if (cic && cic->key == cfqd)
 		goto out;
 
-	do {
-		cic = radix_tree_lookup(&ioc->radix_root, cfqd->queue->id);
-		if (!cic)
-			break;
-		if (likely(cic->key == cfqd)) {
-			/* hint assignment itself can race safely */
-			rcu_assign_pointer(ioc->ioc_data, cic);
-			break;
-		}
-		cfq_drop_dead_cic(cfqd, ioc, cic);
-	} while (1);
+	cic = radix_tree_lookup(&ioc->radix_root, cfqd->queue->id);
+	if (cic && cic->key == cfqd)
+		rcu_assign_pointer(ioc->ioc_data, cic);	/* allowed to race */
+	else
+		cic = NULL;
 out:
 	rcu_read_unlock();
 	return cic;
@@ -4182,7 +4111,6 @@ static struct elevator_type iosched_cfq = {
 		.elevator_may_queue_fn =	cfq_may_queue,
 		.elevator_init_fn =		cfq_init_queue,
 		.elevator_exit_fn =		cfq_exit_queue,
-		.trim =				cfq_free_io_context,
 	},
 	.elevator_attrs =	cfq_attrs,
 	.elevator_name =	"cfq",
diff --git a/block/elevator.c b/block/elevator.c
index 51447dd..da18de1 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -903,22 +903,6 @@ EXPORT_SYMBOL_GPL(elv_register);
 
 void elv_unregister(struct elevator_type *e)
 {
-	struct task_struct *g, *p;
-
-	/*
-	 * Iterate every thread in the process to remove the io contexts.
-	 */
-	if (e->ops.trim) {
-		read_lock(&tasklist_lock);
-		do_each_thread(g, p) {
-			task_lock(p);
-			if (p->io_context)
-				e->ops.trim(p->io_context);
-			task_unlock(p);
-		} while_each_thread(g, p);
-		read_unlock(&tasklist_lock);
-	}
-
 	spin_lock(&elv_list_lock);
 	list_del_init(&e->list);
 	spin_unlock(&elv_list_lock);
diff --git a/include/linux/elevator.h b/include/linux/elevator.h
index 34d71f5..2f6193e 100644
--- a/include/linux/elevator.h
+++ b/include/linux/elevator.h
@@ -63,7 +63,6 @@ struct elevator_ops
 
 	elevator_init_fn *elevator_init_fn;
 	elevator_exit_fn *elevator_exit_fn;
-	void (*trim)(struct io_context *);
 };
 
 #define ELV_NAME_MAX	(16)
-- 
1.7.3.1

