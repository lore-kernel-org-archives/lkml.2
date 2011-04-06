Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751481Ab1DFFWE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 01:22:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60735 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751027Ab1DFFWB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 01:22:01 -0400
From: Amerigo Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, David Howells <dhowells@redhat.com>,
        WANG Cong <amwang@redhat.com>, linux-cachefs@redhat.com
Subject: [RESEND Patch] fscache: remove dead code of CONFIG_WORKQUEUE_DEBUGFS
Date: Wed,  6 Apr 2011 13:21:34 +0800
Message-Id: <1302067295-14275-1-git-send-email-amwang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no CONFIG_WORKQUEUE_DEBUGFS any more, these code are dead,
remove them.

Cc: David Howells <dhowells@redhat.com>
Signed-off-by: WANG Cong <amwang@redhat.com>

---
 fs/fscache/operation.c        |   10 ----------
 fs/fscache/page.c             |   13 -------------
 include/linux/fscache-cache.h |   12 ------------
 3 files changed, 0 insertions(+), 35 deletions(-)

diff --git a/fs/fscache/operation.c b/fs/fscache/operation.c
index 48a18f1..30afdfa 100644
--- a/fs/fscache/operation.c
+++ b/fs/fscache/operation.c
@@ -33,8 +33,6 @@ void fscache_enqueue_operation(struct fscache_operation *op)
 	_enter("{OBJ%x OP%x,%u}",
 	       op->object->debug_id, op->debug_id, atomic_read(&op->usage));
 
-	fscache_set_op_state(op, "EnQ");
-
 	ASSERT(list_empty(&op->pend_link));
 	ASSERT(op->processor != NULL);
 	ASSERTCMP(op->object->state, >=, FSCACHE_OBJECT_AVAILABLE);
@@ -66,8 +64,6 @@ EXPORT_SYMBOL(fscache_enqueue_operation);
 static void fscache_run_op(struct fscache_object *object,
 			   struct fscache_operation *op)
 {
-	fscache_set_op_state(op, "Run");
-
 	object->n_in_progress++;
 	if (test_and_clear_bit(FSCACHE_OP_WAITING, &op->flags))
 		wake_up_bit(&op->flags, FSCACHE_OP_WAITING);
@@ -88,8 +84,6 @@ int fscache_submit_exclusive_op(struct fscache_object *object,
 
 	_enter("{OBJ%x OP%x},", object->debug_id, op->debug_id);
 
-	fscache_set_op_state(op, "SubmitX");
-
 	spin_lock(&object->lock);
 	ASSERTCMP(object->n_ops, >=, object->n_in_progress);
 	ASSERTCMP(object->n_ops, >=, object->n_exclusive);
@@ -194,8 +188,6 @@ int fscache_submit_op(struct fscache_object *object,
 
 	ASSERTCMP(atomic_read(&op->usage), >, 0);
 
-	fscache_set_op_state(op, "Submit");
-
 	spin_lock(&object->lock);
 	ASSERTCMP(object->n_ops, >=, object->n_in_progress);
 	ASSERTCMP(object->n_ops, >=, object->n_exclusive);
@@ -335,8 +327,6 @@ void fscache_put_operation(struct fscache_operation *op)
 	if (!atomic_dec_and_test(&op->usage))
 		return;
 
-	fscache_set_op_state(op, "Put");
-
 	_debug("PUT OP");
 	if (test_and_set_bit(FSCACHE_OP_DEAD, &op->flags))
 		BUG();
diff --git a/fs/fscache/page.c b/fs/fscache/page.c
index 41c441c..a2a5d19 100644
--- a/fs/fscache/page.c
+++ b/fs/fscache/page.c
@@ -155,11 +155,9 @@ static void fscache_attr_changed_op(struct fscache_operation *op)
 	fscache_stat(&fscache_n_attr_changed_calls);
 
 	if (fscache_object_is_active(object)) {
-		fscache_set_op_state(op, "CallFS");
 		fscache_stat(&fscache_n_cop_attr_changed);
 		ret = object->cache->ops->attr_changed(object);
 		fscache_stat_d(&fscache_n_cop_attr_changed);
-		fscache_set_op_state(op, "Done");
 		if (ret < 0)
 			fscache_abort_object(object);
 	}
@@ -190,7 +188,6 @@ int __fscache_attr_changed(struct fscache_cookie *cookie)
 
 	fscache_operation_init(op, fscache_attr_changed_op, NULL);
 	op->flags = FSCACHE_OP_ASYNC | (1 << FSCACHE_OP_EXCLUSIVE);
-	fscache_set_op_name(op, "Attr");
 
 	spin_lock(&cookie->lock);
 
@@ -257,7 +254,6 @@ static struct fscache_retrieval *fscache_alloc_retrieval(
 	op->context	= context;
 	op->start_time	= jiffies;
 	INIT_LIST_HEAD(&op->to_do);
-	fscache_set_op_name(&op->op, "Retr");
 	return op;
 }
 
@@ -368,7 +364,6 @@ int __fscache_read_or_alloc_page(struct fscache_cookie *cookie,
 		_leave(" = -ENOMEM");
 		return -ENOMEM;
 	}
-	fscache_set_op_name(&op->op, "RetrRA1");
 
 	spin_lock(&cookie->lock);
 
@@ -487,7 +482,6 @@ int __fscache_read_or_alloc_pages(struct fscache_cookie *cookie,
 	op = fscache_alloc_retrieval(mapping, end_io_func, context);
 	if (!op)
 		return -ENOMEM;
-	fscache_set_op_name(&op->op, "RetrRAN");
 
 	spin_lock(&cookie->lock);
 
@@ -589,7 +583,6 @@ int __fscache_alloc_page(struct fscache_cookie *cookie,
 	op = fscache_alloc_retrieval(page->mapping, NULL, NULL);
 	if (!op)
 		return -ENOMEM;
-	fscache_set_op_name(&op->op, "RetrAL1");
 
 	spin_lock(&cookie->lock);
 
@@ -662,8 +655,6 @@ static void fscache_write_op(struct fscache_operation *_op)
 
 	_enter("{OP%x,%d}", op->op.debug_id, atomic_read(&op->op.usage));
 
-	fscache_set_op_state(&op->op, "GetPage");
-
 	spin_lock(&object->lock);
 	cookie = object->cookie;
 
@@ -698,15 +689,12 @@ static void fscache_write_op(struct fscache_operation *_op)
 	spin_unlock(&cookie->stores_lock);
 	spin_unlock(&object->lock);
 
-	fscache_set_op_state(&op->op, "Store");
 	fscache_stat(&fscache_n_store_pages);
 	fscache_stat(&fscache_n_cop_write_page);
 	ret = object->cache->ops->write_page(op, page);
 	fscache_stat_d(&fscache_n_cop_write_page);
-	fscache_set_op_state(&op->op, "EndWrite");
 	fscache_end_page_write(object, page);
 	if (ret < 0) {
-		fscache_set_op_state(&op->op, "Abort");
 		fscache_abort_object(object);
 	} else {
 		fscache_enqueue_operation(&op->op);
@@ -778,7 +766,6 @@ int __fscache_write_page(struct fscache_cookie *cookie,
 	fscache_operation_init(&op->op, fscache_write_op,
 			       fscache_release_write_op);
 	op->op.flags = FSCACHE_OP_ASYNC | (1 << FSCACHE_OP_WAITING);
-	fscache_set_op_name(&op->op, "Write1");
 
 	ret = radix_tree_preload(gfp & ~__GFP_HIGHMEM);
 	if (ret < 0)
diff --git a/include/linux/fscache-cache.h b/include/linux/fscache-cache.h
index b8581c0..31b18a7 100644
--- a/include/linux/fscache-cache.h
+++ b/include/linux/fscache-cache.h
@@ -100,17 +100,6 @@ struct fscache_operation {
 
 	/* operation releaser */
 	fscache_operation_release_t release;
-
-#ifdef CONFIG_WORKQUEUE_DEBUGFS
-	struct work_struct put_work;	/* work to delay operation put */
-	const char *name;		/* operation name */
-	const char *state;		/* operation state */
-#define fscache_set_op_name(OP, N)	do { (OP)->name  = (N); } while(0)
-#define fscache_set_op_state(OP, S)	do { (OP)->state = (S); } while(0)
-#else
-#define fscache_set_op_name(OP, N)	do { } while(0)
-#define fscache_set_op_state(OP, S)	do { } while(0)
-#endif
 };
 
 extern atomic_t fscache_op_debug_id;
@@ -137,7 +126,6 @@ static inline void fscache_operation_init(struct fscache_operation *op,
 	op->processor = processor;
 	op->release = release;
 	INIT_LIST_HEAD(&op->pend_link);
-	fscache_set_op_state(op, "Init");
 }
 
 /*
