Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754462Ab0ETTd5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 15:33:57 -0400
Received: from relay.parallels.com ([195.214.232.42]:55230 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752830Ab0ETTdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 15:33:55 -0400
X-Greylist: delayed 736 seconds by postgrey-1.27 at vger.kernel.org; Thu, 20 May 2010 15:33:55 EDT
Subject: [PATCH 2/2] cfq-iosched: compact io_context radix_tree
To: <linux-kernel@vger.kernel.org>, Jens Axboe <jens.axboe@oracle.com>
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
CC: Dmitry Monakhov <dmonakhov@openvz.org>
Date: Thu, 20 May 2010 23:21:41 +0400
Message-ID: <20100520192141.19366.78425.stgit@zurg>
In-Reply-To: <20100520192134.19366.88949.stgit@zurg>
References: <20100520192134.19366.88949.stgit@zurg>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use small consequent indexes as radix tree keys instead of sparse cfqd address.

This change will reduce radix tree depth from 11 (6 for 32-bit hosts)
to 1 if host have <=64 disks under cfq control, or to 0 if there only one disk.
So, this patch save 10*560 bytes for each process (5*296 for 32-bit hosts)

For each cfqd allocate cic index from ida.
To unlink dead cic from tree without cfqd access store index into ->key.
(bit 0 -- dead mark, bits 1..30 -- index: ida produce id in range 0..2^31-1)

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
---
 block/cfq-iosched.c |   44 +++++++++++++++++++++++++++++++++++++++-----
 1 files changed, 39 insertions(+), 5 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 67745e5..6c44abb 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -63,6 +63,9 @@ static DEFINE_PER_CPU(unsigned long, cfq_ioc_count);
 static struct completion *ioc_gone;
 static DEFINE_SPINLOCK(ioc_gone_lock);
 
+static DEFINE_SPINLOCK(cic_index_lock);
+static DEFINE_IDA(cic_index_ida);
+
 #define CFQ_PRIO_LISTS		IOPRIO_BE_NR
 #define cfq_class_idle(cfqq)	((cfqq)->ioprio_class == IOPRIO_CLASS_IDLE)
 #define cfq_class_rt(cfqq)	((cfqq)->ioprio_class == IOPRIO_CLASS_RT)
@@ -272,6 +275,7 @@ struct cfq_data {
 	unsigned int cfq_latency;
 	unsigned int cfq_group_isolation;
 
+	unsigned int cic_index;
 	struct list_head cic_list;
 
 	/*
@@ -432,10 +436,11 @@ static inline void cic_set_cfqq(struct cfq_io_context *cic,
 }
 
 #define CIC_DEAD_KEY	1ul
+#define CIC_DEAD_INDEX_SHIFT	1
 
 static inline void *cfqd_dead_key(struct cfq_data *cfqd)
 {
-	return (void *)((unsigned long) cfqd | CIC_DEAD_KEY);
+	return (void *)(cfqd->cic_index << CIC_DEAD_INDEX_SHIFT | CIC_DEAD_KEY);
 }
 
 static inline struct cfq_data *cic_to_cfqd(struct cfq_io_context *cic)
@@ -2498,7 +2503,7 @@ static void cic_free_func(struct io_context *ioc, struct cfq_io_context *cic)
 	BUG_ON(!(dead_key & CIC_DEAD_KEY));
 
 	spin_lock_irqsave(&ioc->lock, flags);
-	radix_tree_delete(&ioc->radix_root, dead_key & ~CIC_DEAD_KEY);
+	radix_tree_delete(&ioc->radix_root, dead_key >> CIC_DEAD_INDEX_SHIFT);
 	hlist_del_rcu(&cic->cic_list);
 	spin_unlock_irqrestore(&ioc->lock, flags);
 
@@ -2872,7 +2877,7 @@ cfq_drop_dead_cic(struct cfq_data *cfqd, struct io_context *ioc,
 
 	BUG_ON(ioc->ioc_data == cic);
 
-	radix_tree_delete(&ioc->radix_root, (unsigned long) cfqd);
+	radix_tree_delete(&ioc->radix_root, cfqd->cic_index);
 	hlist_del_rcu(&cic->cic_list);
 	spin_unlock_irqrestore(&ioc->lock, flags);
 
@@ -2900,7 +2905,7 @@ cfq_cic_lookup(struct cfq_data *cfqd, struct io_context *ioc)
 	}
 
 	do {
-		cic = radix_tree_lookup(&ioc->radix_root, (unsigned long) cfqd);
+		cic = radix_tree_lookup(&ioc->radix_root, cfqd->cic_index);
 		rcu_read_unlock();
 		if (!cic)
 			break;
@@ -2937,7 +2942,7 @@ static int cfq_cic_link(struct cfq_data *cfqd, struct io_context *ioc,
 
 		spin_lock_irqsave(&ioc->lock, flags);
 		ret = radix_tree_insert(&ioc->radix_root,
-						(unsigned long) cfqd, cic);
+						cfqd->cic_index, cic);
 		if (!ret)
 			hlist_add_head_rcu(&cic->cic_list, &ioc->cic_list);
 		spin_unlock_irqrestore(&ioc->lock, flags);
@@ -3676,10 +3681,32 @@ static void cfq_exit_queue(struct elevator_queue *e)
 
 	cfq_shutdown_timer_wq(cfqd);
 
+	spin_lock(&cic_index_lock);
+	ida_remove(&cic_index_ida, cfqd->cic_index);
+	spin_unlock(&cic_index_lock);
+
 	/* Wait for cfqg->blkg->key accessors to exit their grace periods. */
 	call_rcu(&cfqd->rcu, cfq_cfqd_free);
 }
 
+static int cfq_alloc_cic_index(void)
+{
+	int index, error;
+
+	do {
+		if (!ida_pre_get(&cic_index_ida, GFP_KERNEL))
+			return -ENOMEM;
+
+		spin_lock(&cic_index_lock);
+		error = ida_get_new(&cic_index_ida, &index);
+		spin_unlock(&cic_index_lock);
+		if (error && error != -EAGAIN)
+			return error;
+	} while (error);
+
+	return index;
+}
+
 static void *cfq_init_queue(struct request_queue *q)
 {
 	struct cfq_data *cfqd;
@@ -3687,10 +3714,16 @@ static void *cfq_init_queue(struct request_queue *q)
 	struct cfq_group *cfqg;
 	struct cfq_rb_root *st;
 
+	i = cfq_alloc_cic_index();
+	if (i < 0)
+		return NULL;
+
 	cfqd = kmalloc_node(sizeof(*cfqd), GFP_KERNEL | __GFP_ZERO, q->node);
 	if (!cfqd)
 		return NULL;
 
+	cfqd->cic_index = i;
+
 	/* Init root service tree */
 	cfqd->grp_service_tree = CFQ_RB_ROOT;
 
@@ -3952,6 +3985,7 @@ static void __exit cfq_exit(void)
 	 */
 	if (elv_ioc_count_read(cfq_ioc_count))
 		wait_for_completion(&all_gone);
+	ida_destroy(&cic_index_ida);
 	cfq_slab_kill();
 }
 

