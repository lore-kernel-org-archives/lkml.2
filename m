Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754511Ab1FEQbH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 12:31:07 -0400
Received: from smtp-out2.tiscali.nl ([195.241.79.177]:59480 "EHLO
	smtp-out2.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753428Ab1FEQbE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 12:31:04 -0400
Subject: [PATCH 2/5] Rename two struct members called "cic_list"
From: Paul Bolle <pebolle@tiscali.nl>
To: Jens Axboe <axboe@kernel.dk>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, Vivek Goyal <vgoyal@redhat.com>
Date: Sun, 05 Jun 2011 18:26:26 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.1.1 (3.1.1-3.fc16) 
Content-Transfer-Encoding: 7bit
Message-ID: <1307291188.8545.43.camel@t41.thuisdomein>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let's call them io_context.cic_hlist and cfq_io_context.cic_node. That
should be much less confusing.

There's also cfq_data.cic_list. It is allowed to keep its name (as it's
the struct member that's most entitled to that name).

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
 block/blk-ioc.c           |   14 +++++++-------
 block/cfq-iosched.c       |   10 +++++-----
 include/linux/iocontext.h |    4 ++--
 3 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/block/blk-ioc.c b/block/blk-ioc.c
index 812fba4..430945c 100644
--- a/block/blk-ioc.c
+++ b/block/blk-ioc.c
@@ -18,11 +18,11 @@ static struct kmem_cache *iocontext_cachep;
 
 static void cfq_dtor(struct io_context *ioc)
 {
-	if (!hlist_empty(&ioc->cic_list)) {
+	if (!hlist_empty(&ioc->cic_hlist)) {
 		struct cfq_io_context *cic;
 
-		cic = hlist_entry(ioc->cic_list.first, struct cfq_io_context,
-								cic_list);
+		cic = hlist_entry(ioc->cic_hlist.first, struct cfq_io_context,
+								cic_node);
 		cic->dtor(ioc);
 	}
 }
@@ -54,11 +54,11 @@ static void cfq_exit(struct io_context *ioc)
 {
 	rcu_read_lock();
 
-	if (!hlist_empty(&ioc->cic_list)) {
+	if (!hlist_empty(&ioc->cic_hlist)) {
 		struct cfq_io_context *cic;
 
-		cic = hlist_entry(ioc->cic_list.first, struct cfq_io_context,
-								cic_list);
+		cic = hlist_entry(ioc->cic_hlist.first, struct cfq_io_context,
+								cic_node);
 		cic->exit(ioc);
 	}
 	rcu_read_unlock();
@@ -94,7 +94,7 @@ struct io_context *alloc_io_context(gfp_t gfp_flags, int node)
 		ret->last_waited = 0; /* doesn't matter... */
 		ret->nr_batch_requests = 0; /* because this is 0 */
 		INIT_RADIX_TREE(&ret->radix_root, GFP_ATOMIC | __GFP_HIGH);
-		INIT_HLIST_HEAD(&ret->cic_list);
+		INIT_HLIST_HEAD(&ret->cic_hlist);
 		ret->ioc_data = NULL;
 	}
 
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 79606f9..89ff2e7 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -2592,7 +2592,7 @@ call_for_each_cic(struct io_context *ioc,
 
 	rcu_read_lock();
 
-	hlist_for_each_entry_rcu(cic, n, &ioc->cic_list, cic_list)
+	hlist_for_each_entry_rcu(cic, n, &ioc->cic_hlist, cic_node)
 		func(ioc, cic);
 
 	rcu_read_unlock();
@@ -2636,7 +2636,7 @@ static void cic_free_func(struct io_context *ioc, struct cfq_io_context *cic)
 
 	spin_lock_irqsave(&ioc->lock, flags);
 	radix_tree_delete(&ioc->radix_root, dead_key >> CIC_DEAD_INDEX_SHIFT);
-	hlist_del_rcu(&cic->cic_list);
+	hlist_del_rcu(&cic->cic_node);
 	spin_unlock_irqrestore(&ioc->lock, flags);
 
 	cfq_cic_free(cic);
@@ -2760,7 +2760,7 @@ cfq_alloc_io_context(struct cfq_data *cfqd, gfp_t gfp_mask)
 	if (cic) {
 		cic->last_end_request = jiffies;
 		INIT_LIST_HEAD(&cic->queue_list);
-		INIT_HLIST_NODE(&cic->cic_list);
+		INIT_HLIST_NODE(&cic->cic_node);
 		cic->dtor = cfq_free_io_context;
 		cic->exit = cfq_exit_io_context;
 		elv_ioc_count_inc(cfq_ioc_count);
@@ -3015,7 +3015,7 @@ cfq_drop_dead_cic(struct cfq_data *cfqd, struct io_context *ioc,
 	BUG_ON(ioc->ioc_data == cic);
 
 	radix_tree_delete(&ioc->radix_root, cfqd->cic_index);
-	hlist_del_rcu(&cic->cic_list);
+	hlist_del_rcu(&cic->cic_node);
 	spin_unlock_irqrestore(&ioc->lock, flags);
 
 	cfq_cic_free(cic);
@@ -3081,7 +3081,7 @@ static int cfq_cic_link(struct cfq_data *cfqd, struct io_context *ioc,
 		ret = radix_tree_insert(&ioc->radix_root,
 						cfqd->cic_index, cic);
 		if (!ret)
-			hlist_add_head_rcu(&cic->cic_list, &ioc->cic_list);
+			hlist_add_head_rcu(&cic->cic_node, &ioc->cic_hlist);
 		spin_unlock_irqrestore(&ioc->lock, flags);
 
 		radix_tree_preload_end();
diff --git a/include/linux/iocontext.h b/include/linux/iocontext.h
index b2eee89..f560b84 100644
--- a/include/linux/iocontext.h
+++ b/include/linux/iocontext.h
@@ -19,7 +19,7 @@ struct cfq_io_context {
 	unsigned long ttime_mean;
 
 	struct list_head queue_list;
-	struct hlist_node cic_list;
+	struct hlist_node cic_node;
 
 	void (*dtor)(struct io_context *); /* destructor */
 	void (*exit)(struct io_context *); /* called on task exit */
@@ -52,7 +52,7 @@ struct io_context {
 	unsigned long last_waited; /* Time last woken after wait for request */
 
 	struct radix_tree_root radix_root;
-	struct hlist_head cic_list;
+	struct hlist_head cic_hlist;
 	void __rcu *ioc_data;
 };
 
-- 
1.7.5.2




