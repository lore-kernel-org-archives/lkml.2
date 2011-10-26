Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932177Ab1JZBtD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 21:49:03 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:55101 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932144Ab1JZBtA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 21:49:00 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, vgoyal@redhat.com
Cc: ctalbott@google.com, rni@google.com, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 06/13] block, cfq: misc updates to cfq_io_context
Date: Tue, 25 Oct 2011 18:48:32 -0700
Message-Id: <1319593719-19132-7-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1319593719-19132-1-git-send-email-tj@kernel.org>
References: <1319593719-19132-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the following changes to prepare for ioc/cic management cleanup.

* Add cic->q so that ioc can determine the associated queue without
  querying cfq.  This will eventually replace ->key.

* Factor out cfq_release_cic() from cic_free_func().  This function
  assumes that the caller handled locking.

* Rename __cfq_exit_single_io_context() to cfq_exit_cic() and make it
  take only @cic.

* Restructure cfq_cic_link() for future updates.

This patch doesn't introduce any functional changes.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
---
 block/cfq-iosched.c       |   58 ++++++++++++++++++++++++--------------------
 include/linux/iocontext.h |    1 +
 2 files changed, 33 insertions(+), 26 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index d42d89c..a612ca6 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -2709,21 +2709,26 @@ static void cfq_cic_free(struct cfq_io_context *cic)
 	call_rcu(&cic->rcu_head, cfq_cic_free_rcu);
 }
 
-static void cic_free_func(struct io_context *ioc, struct cfq_io_context *cic)
+static void cfq_release_cic(struct cfq_io_context *cic)
 {
-	unsigned long flags;
+	struct io_context *ioc = cic->ioc;
 	unsigned long dead_key = (unsigned long) cic->key;
 
 	BUG_ON(!(dead_key & CIC_DEAD_KEY));
-
-	spin_lock_irqsave(&ioc->lock, flags);
 	radix_tree_delete(&ioc->radix_root, dead_key >> CIC_DEAD_INDEX_SHIFT);
 	hlist_del_rcu(&cic->cic_list);
-	spin_unlock_irqrestore(&ioc->lock, flags);
-
 	cfq_cic_free(cic);
 }
 
+static void cic_free_func(struct io_context *ioc, struct cfq_io_context *cic)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&ioc->lock, flags);
+	cfq_release_cic(cic);
+	spin_unlock_irqrestore(&ioc->lock, flags);
+}
+
 /*
  * Must be called with rcu_read_lock() held or preemption otherwise disabled.
  * Only two callers of this - ->dtor() which is called with the rcu_read_lock(),
@@ -2773,9 +2778,9 @@ static void cfq_exit_cfqq(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 	cfq_put_queue(cfqq);
 }
 
-static void __cfq_exit_single_io_context(struct cfq_data *cfqd,
-					 struct cfq_io_context *cic)
+static void cfq_exit_cic(struct cfq_io_context *cic)
 {
+	struct cfq_data *cfqd = cic_to_cfqd(cic);
 	struct io_context *ioc = cic->ioc;
 
 	list_del_init(&cic->queue_list);
@@ -2823,7 +2828,7 @@ static void cfq_exit_single_io_context(struct io_context *ioc,
 		 */
 		smp_read_barrier_depends();
 		if (cic->key == cfqd)
-			__cfq_exit_single_io_context(cfqd, cic);
+			cfq_exit_cic(cic);
 
 		spin_unlock_irqrestore(q->queue_lock, flags);
 	}
@@ -3161,28 +3166,29 @@ static int cfq_cic_link(struct cfq_data *cfqd, struct io_context *ioc,
 	int ret;
 
 	ret = radix_tree_preload(gfp_mask);
-	if (!ret) {
-		cic->ioc = ioc;
-		cic->key = cfqd;
+	if (ret)
+		goto out;
 
-		spin_lock_irqsave(&ioc->lock, flags);
-		ret = radix_tree_insert(&ioc->radix_root, cfqd->queue->id, cic);
-		if (!ret)
-			hlist_add_head_rcu(&cic->cic_list, &ioc->cic_list);
-		spin_unlock_irqrestore(&ioc->lock, flags);
+	cic->ioc = ioc;
+	cic->key = cfqd;
+	cic->q = cfqd->queue;
+
+	spin_lock_irqsave(&ioc->lock, flags);
+	ret = radix_tree_insert(&ioc->radix_root, cfqd->queue->id, cic);
+	if (!ret)
+		hlist_add_head_rcu(&cic->cic_list, &ioc->cic_list);
+	spin_unlock_irqrestore(&ioc->lock, flags);
 
-		radix_tree_preload_end();
+	radix_tree_preload_end();
 
-		if (!ret) {
-			spin_lock_irqsave(cfqd->queue->queue_lock, flags);
-			list_add(&cic->queue_list, &cfqd->cic_list);
-			spin_unlock_irqrestore(cfqd->queue->queue_lock, flags);
-		}
+	if (!ret) {
+		spin_lock_irqsave(cfqd->queue->queue_lock, flags);
+		list_add(&cic->queue_list, &cfqd->cic_list);
+		spin_unlock_irqrestore(cfqd->queue->queue_lock, flags);
 	}
-
+out:
 	if (ret)
 		printk(KERN_ERR "cfq: cic link failed!\n");
-
 	return ret;
 }
 
@@ -3922,7 +3928,7 @@ static void cfq_exit_queue(struct elevator_queue *e)
 							struct cfq_io_context,
 							queue_list);
 
-		__cfq_exit_single_io_context(cfqd, cic);
+		cfq_exit_cic(cic);
 	}
 
 	cfq_put_async_queues(cfqd);
diff --git a/include/linux/iocontext.h b/include/linux/iocontext.h
index 28bb621..079aea8 100644
--- a/include/linux/iocontext.h
+++ b/include/linux/iocontext.h
@@ -15,6 +15,7 @@ struct cfq_ttime {
 
 struct cfq_io_context {
 	void *key;
+	struct request_queue *q;
 
 	struct cfq_queue *cfqq[2];
 
-- 
1.7.3.1

