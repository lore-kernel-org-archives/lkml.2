Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932310Ab1JZBtS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 21:49:18 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:55101 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932215Ab1JZBtM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 21:49:12 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, vgoyal@redhat.com
Cc: ctalbott@google.com, rni@google.com, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 12/13] block, cfq: kill ioc_gone
Date: Tue, 25 Oct 2011 18:48:38 -0700
Message-Id: <1319593719-19132-13-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1319593719-19132-1-git-send-email-tj@kernel.org>
References: <1319593719-19132-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that cic's are immediately unlinked under both locks, there's no
need to count and drain cic's before module unload.  RCU callback
completion is waited with rcu_barrier().

While at it, remove residual RCU operations on cic_list.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
---
 block/cfq-iosched.c      |   43 +++++--------------------------------------
 include/linux/elevator.h |   17 -----------------
 2 files changed, 5 insertions(+), 55 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index ff44435..ae7791a 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -62,10 +62,6 @@ static const int cfq_hist_divisor = 4;
 static struct kmem_cache *cfq_pool;
 static struct kmem_cache *cfq_ioc_pool;
 
-static DEFINE_PER_CPU(unsigned long, cfq_ioc_count);
-static struct completion *ioc_gone;
-static DEFINE_SPINLOCK(ioc_gone_lock);
-
 #define CFQ_PRIO_LISTS		IOPRIO_BE_NR
 #define cfq_class_idle(cfqq)	((cfqq)->ioprio_class == IOPRIO_CLASS_IDLE)
 #define cfq_class_rt(cfqq)	((cfqq)->ioprio_class == IOPRIO_CLASS_RT)
@@ -2671,26 +2667,8 @@ static void cfq_put_queue(struct cfq_queue *cfqq)
 
 static void cfq_cic_free_rcu(struct rcu_head *head)
 {
-	struct cfq_io_context *cic;
-
-	cic = container_of(head, struct cfq_io_context, rcu_head);
-
-	kmem_cache_free(cfq_ioc_pool, cic);
-	elv_ioc_count_dec(cfq_ioc_count);
-
-	if (ioc_gone) {
-		/*
-		 * CFQ scheduler is exiting, grab exit lock and check
-		 * the pending io context count. If it hits zero,
-		 * complete ioc_gone and set it back to NULL
-		 */
-		spin_lock(&ioc_gone_lock);
-		if (ioc_gone && !elv_ioc_count_read(cfq_ioc_count)) {
-			complete(ioc_gone);
-			ioc_gone = NULL;
-		}
-		spin_unlock(&ioc_gone_lock);
-	}
+	kmem_cache_free(cfq_ioc_pool,
+			container_of(head, struct cfq_io_context, rcu_head));
 }
 
 static void cfq_cic_free(struct cfq_io_context *cic)
@@ -2705,7 +2683,7 @@ static void cfq_release_cic(struct cfq_io_context *cic)
 
 	BUG_ON(!(dead_key & CIC_DEAD_KEY));
 	radix_tree_delete(&ioc->radix_root, dead_key >> CIC_DEAD_INDEX_SHIFT);
-	hlist_del_rcu(&cic->cic_list);
+	hlist_del(&cic->cic_list);
 	cfq_cic_free(cic);
 }
 
@@ -2782,7 +2760,6 @@ cfq_alloc_io_context(struct cfq_data *cfqd, gfp_t gfp_mask)
 		INIT_HLIST_NODE(&cic->cic_list);
 		cic->exit = cfq_exit_cic;
 		cic->release = cfq_release_cic;
-		elv_ioc_count_inc(cfq_ioc_count);
 	}
 
 	return cic;
@@ -3072,7 +3049,7 @@ static int cfq_create_cic(struct cfq_data *cfqd, gfp_t gfp_mask)
 
 	ret = radix_tree_insert(&ioc->radix_root, q->id, cic);
 	if (likely(!ret)) {
-		hlist_add_head_rcu(&cic->cic_list, &ioc->cic_list);
+		hlist_add_head(&cic->cic_list, &ioc->cic_list);
 		list_add(&cic->queue_list, &cfqd->cic_list);
 		cic = NULL;
 	} else if (ret == -EEXIST) {
@@ -4156,19 +4133,9 @@ static int __init cfq_init(void)
 
 static void __exit cfq_exit(void)
 {
-	DECLARE_COMPLETION_ONSTACK(all_gone);
 	blkio_policy_unregister(&blkio_policy_cfq);
 	elv_unregister(&iosched_cfq);
-	ioc_gone = &all_gone;
-	/* ioc_gone's update must be visible before reading ioc_count */
-	smp_wmb();
-
-	/*
-	 * this also protects us from entering cfq_slab_kill() with
-	 * pending RCU callbacks
-	 */
-	if (elv_ioc_count_read(cfq_ioc_count))
-		wait_for_completion(&all_gone);
+	rcu_barrier();	/* make sure all cic RCU frees are complete */
 	cfq_slab_kill();
 }
 
diff --git a/include/linux/elevator.h b/include/linux/elevator.h
index 2f6193e..a5a88f1 100644
--- a/include/linux/elevator.h
+++ b/include/linux/elevator.h
@@ -194,22 +194,5 @@ enum {
 	INIT_LIST_HEAD(&(rq)->csd.list);	\
 	} while (0)
 
-/*
- * io context count accounting
- */
-#define elv_ioc_count_mod(name, __val) this_cpu_add(name, __val)
-#define elv_ioc_count_inc(name)	this_cpu_inc(name)
-#define elv_ioc_count_dec(name)	this_cpu_dec(name)
-
-#define elv_ioc_count_read(name)				\
-({								\
-	unsigned long __val = 0;				\
-	int __cpu;						\
-	smp_wmb();						\
-	for_each_possible_cpu(__cpu)				\
-		__val += per_cpu(name, __cpu);			\
-	__val;							\
-})
-
 #endif /* CONFIG_BLOCK */
 #endif
-- 
1.7.3.1

