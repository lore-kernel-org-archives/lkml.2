Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755470Ab2K1Qt4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 11:49:56 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:34402 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754990Ab2K1QoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 11:44:14 -0500
From: Kent Overstreet <koverstreet@google.com>
To: linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org
Cc: zab@redhat.com, bcrl@kvack.org, jmoyer@redhat.com, axboe@kernel.dk,
        viro@zeniv.linux.org.uk, Kent Overstreet <koverstreet@google.com>
Subject: [PATCH 11/25] aio: Make aio_put_req() lockless
Date: Wed, 28 Nov 2012 08:43:35 -0800
Message-Id: <1354121029-1376-12-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1354121029-1376-1-git-send-email-koverstreet@google.com>
References: <1354121029-1376-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Freeing a kiocb needed to touch the kioctx for three things:

 * Pull it off the reqs_active list
 * Decrementing reqs_active
 * Issuing a wakeup, if the kioctx was in the process of being freed.

This patch moves these to aio_complete(), for a couple reasons:

 * aio_complete() already has to issue the wakeup, so if we drop the
   kioctx refcount before aio_complete does its wakeup we don't have to
   do it twice.
 * aio_complete currently has to take the kioctx lock, so it makes sense
   for it to pull the kiocb off the reqs_active list too.
 * A later patch is going to change reqs_active to include unreaped
   completions - this will mean allocating a kiocb doesn't have to look
   at the ringbuffer. So taking the decrement of reqs_active out of
   kiocb_free() is useful prep work for that patch.

This doesn't really affect cancellation, since existing (usb) code that
implements a cancel function still calls aio_complete() - we just have
to make sure that aio_complete does the necessary teardown for cancelled
kiocbs.

It does affect code paths where we free kiocbs that were never
submitted; they need to decrement reqs_active and pull the kiocb off the
reqs_active list. This occurs in two places: kiocb_batch_free(), which
is going away in a later patch, and the error path in io_submit_one.

Signed-off-by: Kent Overstreet <koverstreet@google.com>
---
 fs/aio.c            | 85 +++++++++++++++++++++--------------------------------
 include/linux/aio.h |  4 +--
 2 files changed, 35 insertions(+), 54 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index 200abff..9a60f13 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -89,7 +89,7 @@ struct kioctx {
 
 	spinlock_t		ctx_lock;
 
-	int			reqs_active;
+	atomic_t		reqs_active;
 	struct list_head	active_reqs;	/* used for cancellation */
 
 	/* sys_io_setup currently limits this to an unsigned int */
@@ -247,7 +247,7 @@ static void ctx_rcu_free(struct rcu_head *head)
 static void __put_ioctx(struct kioctx *ctx)
 {
 	unsigned nr_events = ctx->max_reqs;
-	BUG_ON(ctx->reqs_active);
+	BUG_ON(atomic_read(&ctx->reqs_active));
 
 	aio_free_ring(ctx);
 	if (nr_events) {
@@ -281,7 +281,7 @@ static int kiocb_cancel(struct kioctx *ctx, struct kiocb *kiocb,
 	cancel = kiocb->ki_cancel;
 	kiocbSetCancelled(kiocb);
 	if (cancel) {
-		kiocb->ki_users++;
+		atomic_inc(&kiocb->ki_users);
 		spin_unlock_irq(&ctx->ctx_lock);
 
 		memset(res, 0, sizeof(*res));
@@ -379,12 +379,12 @@ static void kill_ctx(struct kioctx *ctx)
 		kiocb_cancel(ctx, iocb, &res);
 	}
 
-	if (!ctx->reqs_active)
+	if (!atomic_read(&ctx->reqs_active))
 		goto out;
 
 	add_wait_queue(&ctx->wait, &wait);
 	set_task_state(tsk, TASK_UNINTERRUPTIBLE);
-	while (ctx->reqs_active) {
+	while (atomic_read(&ctx->reqs_active)) {
 		spin_unlock_irq(&ctx->ctx_lock);
 		io_schedule();
 		set_task_state(tsk, TASK_UNINTERRUPTIBLE);
@@ -402,9 +402,9 @@ out:
  */
 ssize_t wait_on_sync_kiocb(struct kiocb *iocb)
 {
-	while (iocb->ki_users) {
+	while (atomic_read(&iocb->ki_users)) {
 		set_current_state(TASK_UNINTERRUPTIBLE);
-		if (!iocb->ki_users)
+		if (!atomic_read(&iocb->ki_users))
 			break;
 		io_schedule();
 	}
@@ -434,7 +434,7 @@ void exit_aio(struct mm_struct *mm)
 			printk(KERN_DEBUG
 				"exit_aio:ioctx still alive: %d %d %d\n",
 				atomic_read(&ctx->users), ctx->dead,
-				ctx->reqs_active);
+				atomic_read(&ctx->reqs_active));
 		/*
 		 * We don't need to bother with munmap() here -
 		 * exit_mmap(mm) is coming and it'll unmap everything.
@@ -449,11 +449,11 @@ void exit_aio(struct mm_struct *mm)
 }
 
 /* aio_get_req
- *	Allocate a slot for an aio request.  Increments the users count
+ *	Allocate a slot for an aio request.  Increments the ki_users count
  * of the kioctx so that the kioctx stays around until all requests are
  * complete.  Returns NULL if no requests are free.
  *
- * Returns with kiocb->users set to 2.  The io submit code path holds
+ * Returns with kiocb->ki_users set to 2.  The io submit code path holds
  * an extra reference while submitting the i/o.
  * This prevents races between the aio code path referencing the
  * req (after submitting it) and aio_complete() freeing the req.
@@ -467,7 +467,7 @@ static struct kiocb *__aio_get_req(struct kioctx *ctx)
 		return NULL;
 
 	req->ki_flags = 0;
-	req->ki_users = 2;
+	atomic_set(&req->ki_users, 2);
 	req->ki_key = 0;
 	req->ki_ctx = ctx;
 	req->ki_cancel = NULL;
@@ -508,9 +508,9 @@ static void kiocb_batch_free(struct kioctx *ctx, struct kiocb_batch *batch)
 		list_del(&req->ki_batch);
 		list_del(&req->ki_list);
 		kmem_cache_free(kiocb_cachep, req);
-		ctx->reqs_active--;
+		atomic_dec(&ctx->reqs_active);
 	}
-	if (unlikely(!ctx->reqs_active && ctx->dead))
+	if (unlikely(!atomic_read(&ctx->reqs_active) && ctx->dead))
 		wake_up_all(&ctx->wait);
 	spin_unlock_irq(&ctx->ctx_lock);
 }
@@ -541,7 +541,7 @@ static int kiocb_batch_refill(struct kioctx *ctx, struct kiocb_batch *batch)
 	spin_lock_irq(&ctx->ctx_lock);
 	ring = kmap_atomic(ctx->ring_info.ring_pages[0]);
 
-	avail = aio_ring_avail(&ctx->ring_info, ring) - ctx->reqs_active;
+	avail = aio_ring_avail(&ctx->ring_info, ring) - atomic_read(&ctx->reqs_active);
 	BUG_ON(avail < 0);
 	if (avail < allocated) {
 		/* Trim back the number of requests. */
@@ -556,7 +556,7 @@ static int kiocb_batch_refill(struct kioctx *ctx, struct kiocb_batch *batch)
 	batch->count -= allocated;
 	list_for_each_entry(req, &batch->head, ki_batch) {
 		list_add(&req->ki_list, &ctx->active_reqs);
-		ctx->reqs_active++;
+		atomic_inc(&ctx->reqs_active);
 	}
 
 	kunmap_atomic(ring);
@@ -579,10 +579,8 @@ static inline struct kiocb *aio_get_req(struct kioctx *ctx,
 	return req;
 }
 
-static inline void really_put_req(struct kioctx *ctx, struct kiocb *req)
+static void kiocb_free(struct kiocb *req)
 {
-	assert_spin_locked(&ctx->ctx_lock);
-
 	if (req->ki_filp)
 		fput(req->ki_filp);
 	if (req->ki_eventfd != NULL)
@@ -592,40 +590,12 @@ static inline void really_put_req(struct kioctx *ctx, struct kiocb *req)
 	if (req->ki_iovec != &req->ki_inline_vec)
 		kfree(req->ki_iovec);
 	kmem_cache_free(kiocb_cachep, req);
-	ctx->reqs_active--;
-
-	if (unlikely(!ctx->reqs_active && ctx->dead))
-		wake_up_all(&ctx->wait);
 }
 
-/* __aio_put_req
- *	Returns true if this put was the last user of the request.
- */
-static void __aio_put_req(struct kioctx *ctx, struct kiocb *req)
-{
-	assert_spin_locked(&ctx->ctx_lock);
-
-	req->ki_users--;
-	BUG_ON(req->ki_users < 0);
-	if (likely(req->ki_users))
-		return;
-	list_del(&req->ki_list);		/* remove from active_reqs */
-	req->ki_cancel = NULL;
-	req->ki_retry = NULL;
-
-	really_put_req(ctx, req);
-}
-
-/* aio_put_req
- *	Returns true if this put was the last user of the kiocb,
- *	false if the request is still in use.
- */
 void aio_put_req(struct kiocb *req)
 {
-	struct kioctx *ctx = req->ki_ctx;
-	spin_lock_irq(&ctx->ctx_lock);
-	__aio_put_req(ctx, req);
-	spin_unlock_irq(&ctx->ctx_lock);
+	if (atomic_dec_and_test(&req->ki_users))
+		kiocb_free(req);
 }
 EXPORT_SYMBOL(aio_put_req);
 
@@ -676,9 +646,9 @@ void aio_complete(struct kiocb *iocb, long res, long res2)
 	 *  - the sync task helpfully left a reference to itself in the iocb
 	 */
 	if (is_sync_kiocb(iocb)) {
-		BUG_ON(iocb->ki_users != 1);
+		BUG_ON(atomic_read(&iocb->ki_users) != 1);
 		iocb->ki_user_data = res;
-		iocb->ki_users = 0;
+		atomic_set(&iocb->ki_users, 0);
 		wake_up_process(iocb->ki_obj.tsk);
 		return;
 	}
@@ -693,6 +663,8 @@ void aio_complete(struct kiocb *iocb, long res, long res2)
 	 */
 	spin_lock_irqsave(&ctx->ctx_lock, flags);
 
+	list_del(&iocb->ki_list); /* remove from active_reqs */
+
 	/*
 	 * cancelled requests don't get events, userland was given one
 	 * when the event got cancelled.
@@ -739,7 +711,8 @@ void aio_complete(struct kiocb *iocb, long res, long res2)
 
 put_rq:
 	/* everything turned out well, dispose of the aiocb. */
-	__aio_put_req(ctx, iocb);
+	aio_put_req(iocb);
+	atomic_dec(&ctx->reqs_active);
 
 	/*
 	 * We have to order our ring_info tail store above and test
@@ -904,7 +877,7 @@ static int read_events(struct kioctx *ctx,
 				break;
 			/* Try to only show up in io wait if there are ops
 			 *  in flight */
-			if (ctx->reqs_active)
+			if (atomic_read(&ctx->reqs_active))
 				io_schedule();
 			else
 				schedule();
@@ -1363,6 +1336,14 @@ static int io_submit_one(struct kioctx *ctx, struct iocb __user *user_iocb,
 	return 0;
 
 out_put_req:
+	spin_lock_irq(&ctx->ctx_lock);
+	list_del(&req->ki_list);
+	spin_unlock_irq(&ctx->ctx_lock);
+
+	atomic_dec(&ctx->reqs_active);
+	if (unlikely(!atomic_read(&ctx->reqs_active) && ctx->dead))
+		wake_up_all(&ctx->wait);
+
 	aio_put_req(req);	/* drop extra ref to req */
 	aio_put_req(req);	/* drop i/o ref to req */
 	return ret;
diff --git a/include/linux/aio.h b/include/linux/aio.h
index f29de1f..294b659 100644
--- a/include/linux/aio.h
+++ b/include/linux/aio.h
@@ -50,7 +50,7 @@ struct kioctx;
 struct kiocb {
 	struct list_head	ki_run_list;
 	unsigned long		ki_flags;
-	int			ki_users;
+	atomic_t		ki_users;
 	unsigned		ki_key;		/* id of this request */
 
 	struct file		*ki_filp;
@@ -97,7 +97,7 @@ static inline bool is_sync_kiocb(struct kiocb *kiocb)
 static inline void init_sync_kiocb(struct kiocb *kiocb, struct file *filp)
 {
 	*kiocb = (struct kiocb) {
-			.ki_users = 1,
+			.ki_users = ATOMIC_INIT(1),
 			.ki_key = KIOCB_SYNC_KEY,
 			.ki_filp = filp,
 			.ki_obj.tsk = current,
-- 
1.7.12

