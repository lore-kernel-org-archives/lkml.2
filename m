Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755532Ab2K1QsD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 11:48:03 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35969 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755198Ab2K1QoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 11:44:23 -0500
From: Kent Overstreet <koverstreet@google.com>
To: linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org
Cc: zab@redhat.com, bcrl@kvack.org, jmoyer@redhat.com, axboe@kernel.dk,
        viro@zeniv.linux.org.uk, Kent Overstreet <koverstreet@google.com>
Subject: [PATCH 17/25] aio: Kill batch allocation
Date: Wed, 28 Nov 2012 08:43:41 -0800
Message-Id: <1354121029-1376-18-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1354121029-1376-1-git-send-email-koverstreet@google.com>
References: <1354121029-1376-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previously, allocating a kiocb required touching quite a few global
(well, per kioctx) cachelines... so batching up allocation to amortize
those was worthwhile. But we've gotten rid of some of those, and in
another couple of patches kiocb allocation won't require writing to any
shared cachelines, so that means we can just rip this code out.

Signed-off-by: Kent Overstreet <koverstreet@google.com>
---
 fs/aio.c            | 117 +++++++---------------------------------------------
 include/linux/aio.h |   1 -
 2 files changed, 15 insertions(+), 103 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index 0d5062d..f2d616e 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -468,109 +468,27 @@ void exit_aio(struct mm_struct *mm)
  * This prevents races between the aio code path referencing the
  * req (after submitting it) and aio_complete() freeing the req.
  */
-static struct kiocb *__aio_get_req(struct kioctx *ctx)
+static inline struct kiocb *aio_get_req(struct kioctx *ctx)
 {
-	struct kiocb *req = NULL;
+	struct kiocb *req;
+
+	if (atomic_read(&ctx->reqs_active) >= ctx->ring_info.nr)
+		return NULL;
+
+	if (atomic_inc_return(&ctx->reqs_active) > ctx->ring_info.nr)
+		goto out_put;
 
 	req = kmem_cache_alloc(kiocb_cachep, GFP_KERNEL|__GFP_ZERO);
 	if (unlikely(!req))
-		return NULL;
+		goto out_put;
 
 	atomic_set(&req->ki_users, 2);
 	req->ki_ctx = ctx;
 
 	return req;
-}
-
-/*
- * struct kiocb's are allocated in batches to reduce the number of
- * times the ctx lock is acquired and released.
- */
-#define KIOCB_BATCH_SIZE	32L
-struct kiocb_batch {
-	struct list_head head;
-	long count; /* number of requests left to allocate */
-};
-
-static void kiocb_batch_init(struct kiocb_batch *batch, long total)
-{
-	INIT_LIST_HEAD(&batch->head);
-	batch->count = total;
-}
-
-static void kiocb_batch_free(struct kioctx *ctx, struct kiocb_batch *batch)
-{
-	struct kiocb *req, *n;
-
-	if (list_empty(&batch->head))
-		return;
-
-	spin_lock_irq(&ctx->ctx_lock);
-	list_for_each_entry_safe(req, n, &batch->head, ki_batch) {
-		list_del(&req->ki_batch);
-		list_del(&req->ki_list);
-		kmem_cache_free(kiocb_cachep, req);
-		atomic_dec(&ctx->reqs_active);
-	}
-	spin_unlock_irq(&ctx->ctx_lock);
-}
-
-/*
- * Allocate a batch of kiocbs.  This avoids taking and dropping the
- * context lock a lot during setup.
- */
-static int kiocb_batch_refill(struct kioctx *ctx, struct kiocb_batch *batch)
-{
-	unsigned short allocated, to_alloc;
-	long avail;
-	struct kiocb *req, *n;
-
-	to_alloc = min(batch->count, KIOCB_BATCH_SIZE);
-	for (allocated = 0; allocated < to_alloc; allocated++) {
-		req = __aio_get_req(ctx);
-		if (!req)
-			/* allocation failed, go with what we've got */
-			break;
-		list_add(&req->ki_batch, &batch->head);
-	}
-
-	if (allocated == 0)
-		goto out;
-
-	spin_lock_irq(&ctx->ctx_lock);
-
-	avail = ctx->ring_info.nr - atomic_read(&ctx->reqs_active);
-	BUG_ON(avail < 0);
-	if (avail < allocated) {
-		/* Trim back the number of requests. */
-		list_for_each_entry_safe(req, n, &batch->head, ki_batch) {
-			list_del(&req->ki_batch);
-			kmem_cache_free(kiocb_cachep, req);
-			if (--allocated <= avail)
-				break;
-		}
-	}
-
-	batch->count -= allocated;
-	atomic_add(allocated, &ctx->reqs_active);
-
-	spin_unlock_irq(&ctx->ctx_lock);
-
-out:
-	return allocated;
-}
-
-static inline struct kiocb *aio_get_req(struct kioctx *ctx,
-					struct kiocb_batch *batch)
-{
-	struct kiocb *req;
-
-	if (list_empty(&batch->head))
-		if (kiocb_batch_refill(ctx, batch) == 0)
-			return NULL;
-	req = list_first_entry(&batch->head, struct kiocb, ki_batch);
-	list_del(&req->ki_batch);
-	return req;
+out_put:
+	atomic_dec(&ctx->reqs_active);
+	return NULL;
 }
 
 static void kiocb_free(struct kiocb *req)
@@ -1159,8 +1077,7 @@ static ssize_t aio_setup_iocb(struct kiocb *kiocb, bool compat)
 }
 
 static int io_submit_one(struct kioctx *ctx, struct iocb __user *user_iocb,
-			 struct iocb *iocb, struct kiocb_batch *batch,
-			 bool compat)
+			 struct iocb *iocb, bool compat)
 {
 	struct kiocb *req;
 	ssize_t ret;
@@ -1181,7 +1098,7 @@ static int io_submit_one(struct kioctx *ctx, struct iocb __user *user_iocb,
 		return -EINVAL;
 	}
 
-	req = aio_get_req(ctx, batch);  /* returns with 2 references to req */
+	req = aio_get_req(ctx);  /* returns with 2 references to req */
 	if (unlikely(!req))
 		return -EAGAIN;
 
@@ -1257,7 +1174,6 @@ long do_io_submit(aio_context_t ctx_id, long nr,
 	long ret = 0;
 	int i = 0;
 	struct blk_plug plug;
-	struct kiocb_batch batch;
 
 	if (unlikely(nr < 0))
 		return -EINVAL;
@@ -1274,8 +1190,6 @@ long do_io_submit(aio_context_t ctx_id, long nr,
 		return -EINVAL;
 	}
 
-	kiocb_batch_init(&batch, nr);
-
 	blk_start_plug(&plug);
 
 	/*
@@ -1296,13 +1210,12 @@ long do_io_submit(aio_context_t ctx_id, long nr,
 			break;
 		}
 
-		ret = io_submit_one(ctx, user_iocb, &tmp, &batch, compat);
+		ret = io_submit_one(ctx, user_iocb, &tmp, compat);
 		if (ret)
 			break;
 	}
 	blk_finish_plug(&plug);
 
-	kiocb_batch_free(ctx, &batch);
 	put_ioctx(ctx);
 	return i ? i : ret;
 }
diff --git a/include/linux/aio.h b/include/linux/aio.h
index ea048ee..7701a41 100644
--- a/include/linux/aio.h
+++ b/include/linux/aio.h
@@ -81,7 +81,6 @@ struct kiocb {
 
 	struct list_head	ki_list;	/* the aio core uses this
 						 * for cancellation */
-	struct list_head	ki_batch;	/* batch allocation */
 
 	/*
 	 * If the aio_resfd field of the userspace iocb is not zero,
-- 
1.7.12

