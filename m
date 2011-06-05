Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754134Ab1FEQar (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 12:30:47 -0400
Received: from smtp-out2.tiscali.nl ([195.241.79.177]:59444 "EHLO
	smtp-out2.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753788Ab1FEQaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 12:30:46 -0400
Subject: [PATCH 3/5] CFQ: rename ioc_data to last_cic
From: Paul Bolle <pebolle@tiscali.nl>
To: Jens Axboe <axboe@kernel.dk>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Vivek Goyal <vgoyal@redhat.com>, linux-kernel@vger.kernel.org
Date: Sun, 05 Jun 2011 18:26:33 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.1.1 (3.1.1-3.fc16) 
Content-Transfer-Encoding: 7bit
Message-ID: <1307291194.8545.44.camel@t41.thuisdomein>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Set its type to struct cfq_io_context too.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
 block/blk-ioc.c           |    2 +-
 block/cfq-iosched.c       |   10 +++++-----
 include/linux/iocontext.h |    2 +-
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/block/blk-ioc.c b/block/blk-ioc.c
index 430945c..998fa67 100644
--- a/block/blk-ioc.c
+++ b/block/blk-ioc.c
@@ -95,7 +95,7 @@ struct io_context *alloc_io_context(gfp_t gfp_flags, int node)
 		ret->nr_batch_requests = 0; /* because this is 0 */
 		INIT_RADIX_TREE(&ret->radix_root, GFP_ATOMIC | __GFP_HIGH);
 		INIT_HLIST_HEAD(&ret->cic_hlist);
-		ret->ioc_data = NULL;
+		ret->last_cic = NULL;
 	}
 
 	return ret;
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 89ff2e7..39e4d01 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -2704,8 +2704,8 @@ static void __cfq_exit_single_io_context(struct cfq_data *cfqd,
 	smp_wmb();
 	cic->key = cfqd_dead_key(cfqd);
 
-	if (ioc->ioc_data == cic)
-		rcu_assign_pointer(ioc->ioc_data, NULL);
+	if (ioc->last_cic == cic)
+		rcu_assign_pointer(ioc->last_cic, NULL);
 
 	if (cic->cfqq[BLK_RW_ASYNC]) {
 		cfq_exit_cfqq(cfqd, cic->cfqq[BLK_RW_ASYNC]);
@@ -3012,7 +3012,7 @@ cfq_drop_dead_cic(struct cfq_data *cfqd, struct io_context *ioc,
 
 	spin_lock_irqsave(&ioc->lock, flags);
 
-	BUG_ON(ioc->ioc_data == cic);
+	BUG_ON(ioc->last_cic == cic);
 
 	radix_tree_delete(&ioc->radix_root, cfqd->cic_index);
 	hlist_del_rcu(&cic->cic_node);
@@ -3035,7 +3035,7 @@ cfq_cic_lookup(struct cfq_data *cfqd, struct io_context *ioc)
 	/*
 	 * we maintain a last-hit cache, to avoid browsing over the tree
 	 */
-	cic = rcu_dereference(ioc->ioc_data);
+	cic = rcu_dereference(ioc->last_cic);
 	if (cic && cic->key == cfqd) {
 		rcu_read_unlock();
 		return cic;
@@ -3053,7 +3053,7 @@ cfq_cic_lookup(struct cfq_data *cfqd, struct io_context *ioc)
 		}
 
 		spin_lock_irqsave(&ioc->lock, flags);
-		rcu_assign_pointer(ioc->ioc_data, cic);
+		rcu_assign_pointer(ioc->last_cic, cic);
 		spin_unlock_irqrestore(&ioc->lock, flags);
 		break;
 	} while (1);
diff --git a/include/linux/iocontext.h b/include/linux/iocontext.h
index f560b84..308678b 100644
--- a/include/linux/iocontext.h
+++ b/include/linux/iocontext.h
@@ -53,7 +53,7 @@ struct io_context {
 
 	struct radix_tree_root radix_root;
 	struct hlist_head cic_hlist;
-	void __rcu *ioc_data;
+	struct cfq_io_context __rcu *last_cic;
 };
 
 static inline struct io_context *ioc_task_link(struct io_context *ioc)
-- 
1.7.5.2




