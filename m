Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932337Ab1JZBth (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 21:49:37 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:45787 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932234Ab1JZBtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 21:49:15 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, vgoyal@redhat.com
Cc: ctalbott@google.com, rni@google.com, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 13/13] block, cfq: kill cic->key
Date: Tue, 25 Oct 2011 18:48:39 -0700
Message-Id: <1319593719-19132-14-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1319593719-19132-1-git-send-email-tj@kernel.org>
References: <1319593719-19132-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that lazy paths are removed, cfqd_dead_key() is meaningless and
cic->q can be used whereever cic->key is used.  Kill cic->key.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
---
 block/cfq-iosched.c       |   26 +++++---------------------
 include/linux/iocontext.h |    1 -
 2 files changed, 5 insertions(+), 22 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index ae7791a..3b07ce1 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -472,22 +472,9 @@ static inline void cic_set_cfqq(struct cfq_io_context *cic,
 	cic->cfqq[is_sync] = cfqq;
 }
 
-#define CIC_DEAD_KEY	1ul
-#define CIC_DEAD_INDEX_SHIFT	1
-
-static inline void *cfqd_dead_key(struct cfq_data *cfqd)
-{
-	return (void *)(cfqd->queue->id << CIC_DEAD_INDEX_SHIFT | CIC_DEAD_KEY);
-}
-
 static inline struct cfq_data *cic_to_cfqd(struct cfq_io_context *cic)
 {
-	struct cfq_data *cfqd = cic->key;
-
-	if (unlikely((unsigned long) cfqd & CIC_DEAD_KEY))
-		return NULL;
-
-	return cfqd;
+	return cic->q->elevator->elevator_data;
 }
 
 /*
@@ -2679,10 +2666,8 @@ static void cfq_cic_free(struct cfq_io_context *cic)
 static void cfq_release_cic(struct cfq_io_context *cic)
 {
 	struct io_context *ioc = cic->ioc;
-	unsigned long dead_key = (unsigned long) cic->key;
 
-	BUG_ON(!(dead_key & CIC_DEAD_KEY));
-	radix_tree_delete(&ioc->radix_root, dead_key >> CIC_DEAD_INDEX_SHIFT);
+	radix_tree_delete(&ioc->radix_root, cic->q->id);
 	hlist_del(&cic->cic_list);
 	cfq_cic_free(cic);
 }
@@ -2726,7 +2711,6 @@ static void cfq_exit_cic(struct cfq_io_context *cic)
 	struct io_context *ioc = cic->ioc;
 
 	list_del_init(&cic->queue_list);
-	cic->key = cfqd_dead_key(cfqd);
 
 	/*
 	 * Both setting lookup hint to and clearing it from @cic are done
@@ -2982,6 +2966,7 @@ cfq_get_queue(struct cfq_data *cfqd, bool is_sync, struct io_context *ioc,
 static struct cfq_io_context *
 cfq_cic_lookup(struct cfq_data *cfqd, struct io_context *ioc)
 {
+	struct request_queue *q = cfqd->queue;
 	struct cfq_io_context *cic;
 
 	lockdep_assert_held(cfqd->queue->queue_lock);
@@ -2996,11 +2981,11 @@ cfq_cic_lookup(struct cfq_data *cfqd, struct io_context *ioc)
 	 */
 	rcu_read_lock();
 	cic = rcu_dereference(ioc->ioc_data);
-	if (cic && cic->key == cfqd)
+	if (cic && cic->q == q)
 		goto out;
 
 	cic = radix_tree_lookup(&ioc->radix_root, cfqd->queue->id);
-	if (cic && cic->key == cfqd)
+	if (cic && cic->q == q)
 		rcu_assign_pointer(ioc->ioc_data, cic);	/* allowed to race */
 	else
 		cic = NULL;
@@ -3040,7 +3025,6 @@ static int cfq_create_cic(struct cfq_data *cfqd, gfp_t gfp_mask)
 		goto out;
 
 	cic->ioc = ioc;
-	cic->key = cfqd;
 	cic->q = cfqd->queue;
 
 	/* lock both q and ioc and try to link @cic */
diff --git a/include/linux/iocontext.h b/include/linux/iocontext.h
index 01e8631..b2b75a5 100644
--- a/include/linux/iocontext.h
+++ b/include/linux/iocontext.h
@@ -20,7 +20,6 @@ enum {
 };
 
 struct cfq_io_context {
-	void *key;
 	struct request_queue *q;
 
 	struct cfq_queue *cfqq[2];
-- 
1.7.3.1

