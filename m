Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755271Ab2K1QoY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 11:44:24 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:34402 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755019Ab2K1QoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 11:44:16 -0500
From: Kent Overstreet <koverstreet@google.com>
To: linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org
Cc: zab@redhat.com, bcrl@kvack.org, jmoyer@redhat.com, axboe@kernel.dk,
        viro@zeniv.linux.org.uk, Kent Overstreet <koverstreet@google.com>
Subject: [PATCH 12/25] aio: Refcounting cleanup
Date: Wed, 28 Nov 2012 08:43:36 -0800
Message-Id: <1354121029-1376-13-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1354121029-1376-1-git-send-email-koverstreet@google.com>
References: <1354121029-1376-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The usage of ctx->dead was fubar - it makes no sense to explicitly
check it all over the place, especially when we're already using RCU.

Now, ctx->dead only indicates whether we've dropped the initial
refcount. The new teardown sequence is:
set ctx->dead
hlist_del_rcu();
synchronize_rcu();

Now we know no system calls can take a new ref, and it's safe to drop
the initial ref:
put_ioctx();

We also need to ensure there are no more outstanding kiocbs. This was
done incorrectly - it was being done in kill_ctx(), and before dropping
the initial refcount. At this point, other syscalls may still be
submitting kiocbs!

Now, we cancel and wait for outstanding kiocbs in free_ioctx(), after
kioctx->users has dropped to 0 and we know no more iocbs could be
submitted.

Signed-off-by: Kent Overstreet <koverstreet@google.com>
---
 fs/aio.c | 236 ++++++++++++++++++++++-----------------------------------------
 1 file changed, 80 insertions(+), 156 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index 9a60f13..9d27508 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -79,7 +79,7 @@ static inline unsigned aio_ring_avail(struct aio_ring_info *info,
 
 struct kioctx {
 	atomic_t		users;
-	int			dead;
+	atomic_t		dead;
 
 	/* This needs improving */
 	unsigned long		user_id;
@@ -96,8 +96,6 @@ struct kioctx {
 	unsigned		max_reqs;
 
 	struct aio_ring_info	ring_info;
-
-	struct rcu_head		rcu_head;
 };
 
 /*------ sysctl variables----*/
@@ -234,44 +232,6 @@ static int aio_setup_ring(struct kioctx *ctx)
 	kunmap_atomic((void *)((unsigned long)__event & PAGE_MASK)); \
 } while(0)
 
-static void ctx_rcu_free(struct rcu_head *head)
-{
-	struct kioctx *ctx = container_of(head, struct kioctx, rcu_head);
-	kmem_cache_free(kioctx_cachep, ctx);
-}
-
-/* __put_ioctx
- *	Called when the last user of an aio context has gone away,
- *	and the struct needs to be freed.
- */
-static void __put_ioctx(struct kioctx *ctx)
-{
-	unsigned nr_events = ctx->max_reqs;
-	BUG_ON(atomic_read(&ctx->reqs_active));
-
-	aio_free_ring(ctx);
-	if (nr_events) {
-		spin_lock(&aio_nr_lock);
-		BUG_ON(aio_nr - nr_events > aio_nr);
-		aio_nr -= nr_events;
-		spin_unlock(&aio_nr_lock);
-	}
-	pr_debug("freeing %p\n", ctx);
-	call_rcu(&ctx->rcu_head, ctx_rcu_free);
-}
-
-static inline int try_get_ioctx(struct kioctx *kioctx)
-{
-	return atomic_inc_not_zero(&kioctx->users);
-}
-
-static inline void put_ioctx(struct kioctx *kioctx)
-{
-	BUG_ON(atomic_read(&kioctx->users) <= 0);
-	if (unlikely(atomic_dec_and_test(&kioctx->users)))
-		__put_ioctx(kioctx);
-}
-
 static int kiocb_cancel(struct kioctx *ctx, struct kiocb *kiocb,
 			struct io_event *res)
 {
@@ -295,6 +255,48 @@ static int kiocb_cancel(struct kioctx *ctx, struct kiocb *kiocb,
 	return ret;
 }
 
+/*
+ * When this function runs, the kioctx has been removed from the "hash table"
+ * and ctx->users has dropped to 0, so we know no more kiocbs can be submitted -
+ * now it's safe to cancel any that need to be.
+ */
+static void free_ioctx(struct kioctx *ctx)
+{
+	struct io_event res;
+
+	spin_lock_irq(&ctx->ctx_lock);
+
+	while (!list_empty(&ctx->active_reqs)) {
+		struct list_head *pos = ctx->active_reqs.next;
+		struct kiocb *iocb = list_kiocb(pos);
+		list_del_init(&iocb->ki_list);
+
+		kiocb_cancel(ctx, iocb, &res);
+	}
+
+	spin_unlock_irq(&ctx->ctx_lock);
+
+	wait_event(ctx->wait, !atomic_read(&ctx->reqs_active));
+
+	aio_free_ring(ctx);
+
+	spin_lock(&aio_nr_lock);
+	BUG_ON(aio_nr - ctx->max_reqs > aio_nr);
+	aio_nr -= ctx->max_reqs;
+	spin_unlock(&aio_nr_lock);
+
+	synchronize_rcu();
+
+	pr_debug("freeing %p\n", ctx);
+	kmem_cache_free(kioctx_cachep, ctx);
+}
+
+static void put_ioctx(struct kioctx *ctx)
+{
+	if (unlikely(atomic_dec_and_test(&ctx->users)))
+		free_ioctx(ctx);
+}
+
 /* ioctx_alloc
  *	Allocates and initializes an ioctx.  Returns an ERR_PTR if it failed.
  */
@@ -358,43 +360,21 @@ out_freectx:
 	return ERR_PTR(err);
 }
 
-/* kill_ctx
- *	Cancels all outstanding aio requests on an aio context.  Used 
- *	when the processes owning a context have all exited to encourage 
+/* kill_ioctx
+ *	Cancels all outstanding aio requests on an aio context.  Used
+ *	when the processes owning a context have all exited to encourage
  *	the rapid destruction of the kioctx.
  */
-static void kill_ctx(struct kioctx *ctx)
+static void kill_ioctx(struct kioctx *ctx)
 {
-	struct task_struct *tsk = current;
-	DECLARE_WAITQUEUE(wait, tsk);
-	struct io_event res;
-
-	spin_lock_irq(&ctx->ctx_lock);
-	ctx->dead = 1;
-	while (!list_empty(&ctx->active_reqs)) {
-		struct list_head *pos = ctx->active_reqs.next;
-		struct kiocb *iocb = list_kiocb(pos);
-		list_del_init(&iocb->ki_list);
-
-		kiocb_cancel(ctx, iocb, &res);
-	}
+	if (!atomic_xchg(&ctx->dead, 1)) {
+		hlist_del_rcu(&ctx->list);
+		synchronize_rcu();
 
-	if (!atomic_read(&ctx->reqs_active))
-		goto out;
+		wake_up_all(&ctx->wait);
 
-	add_wait_queue(&ctx->wait, &wait);
-	set_task_state(tsk, TASK_UNINTERRUPTIBLE);
-	while (atomic_read(&ctx->reqs_active)) {
-		spin_unlock_irq(&ctx->ctx_lock);
-		io_schedule();
-		set_task_state(tsk, TASK_UNINTERRUPTIBLE);
-		spin_lock_irq(&ctx->ctx_lock);
+		put_ioctx(ctx);
 	}
-	__set_task_state(tsk, TASK_RUNNING);
-	remove_wait_queue(&ctx->wait, &wait);
-
-out:
-	spin_unlock_irq(&ctx->ctx_lock);
 }
 
 /* wait_on_sync_kiocb:
@@ -413,27 +393,25 @@ ssize_t wait_on_sync_kiocb(struct kiocb *iocb)
 }
 EXPORT_SYMBOL(wait_on_sync_kiocb);
 
-/* exit_aio: called when the last user of mm goes away.  At this point, 
- * there is no way for any new requests to be submited or any of the 
- * io_* syscalls to be called on the context.  However, there may be 
- * outstanding requests which hold references to the context; as they 
- * go away, they will call put_ioctx and release any pinned memory
- * associated with the request (held via struct page * references).
+/*
+ * exit_aio: called when the last user of mm goes away.  At this point, there is
+ * no way for any new requests to be submited or any of the io_* syscalls to be
+ * called on the context.
+ *
+ * There may be outstanding kiocbs, but free_ioctx() will explicitly wait on
+ * them.
  */
 void exit_aio(struct mm_struct *mm)
 {
 	struct kioctx *ctx;
+	struct hlist_node *p, *n;
 
-	while (!hlist_empty(&mm->ioctx_list)) {
-		ctx = hlist_entry(mm->ioctx_list.first, struct kioctx, list);
-		hlist_del_rcu(&ctx->list);
-
-		kill_ctx(ctx);
-
+	hlist_for_each_entry_safe(ctx, p, n, &mm->ioctx_list, list) {
 		if (1 != atomic_read(&ctx->users))
 			printk(KERN_DEBUG
 				"exit_aio:ioctx still alive: %d %d %d\n",
-				atomic_read(&ctx->users), ctx->dead,
+				atomic_read(&ctx->users),
+				atomic_read(&ctx->dead),
 				atomic_read(&ctx->reqs_active));
 		/*
 		 * We don't need to bother with munmap() here -
@@ -444,7 +422,7 @@ void exit_aio(struct mm_struct *mm)
 		 * place that uses ->mmap_size, so it's safe.
 		 */
 		ctx->ring_info.mmap_size = 0;
-		put_ioctx(ctx);
+		kill_ioctx(ctx);
 	}
 }
 
@@ -510,8 +488,6 @@ static void kiocb_batch_free(struct kioctx *ctx, struct kiocb_batch *batch)
 		kmem_cache_free(kiocb_cachep, req);
 		atomic_dec(&ctx->reqs_active);
 	}
-	if (unlikely(!atomic_read(&ctx->reqs_active) && ctx->dead))
-		wake_up_all(&ctx->wait);
 	spin_unlock_irq(&ctx->ctx_lock);
 }
 
@@ -607,18 +583,13 @@ static struct kioctx *lookup_ioctx(unsigned long ctx_id)
 
 	rcu_read_lock();
 
-	hlist_for_each_entry_rcu(ctx, n, &mm->ioctx_list, list) {
-		/*
-		 * RCU protects us against accessing freed memory but
-		 * we have to be careful not to get a reference when the
-		 * reference count already dropped to 0 (ctx->dead test
-		 * is unreliable because of races).
-		 */
-		if (ctx->user_id == ctx_id && !ctx->dead && try_get_ioctx(ctx)){
+	hlist_for_each_entry_rcu(ctx, n, &mm->ioctx_list, list)
+		if (ctx->user_id == ctx_id){
+			BUG_ON(atomic_read(&ctx->dead));
+			atomic_inc(&ctx->users);
 			ret = ctx;
 			break;
 		}
-	}
 
 	rcu_read_unlock();
 	return ret;
@@ -655,12 +626,15 @@ void aio_complete(struct kiocb *iocb, long res, long res2)
 
 	info = &ctx->ring_info;
 
-	/* add a completion event to the ring buffer.
-	 * must be done holding ctx->ctx_lock to prevent
-	 * other code from messing with the tail
-	 * pointer since we might be called from irq
-	 * context.
+	/*
+	 * Add a completion event to the ring buffer. Must be done holding
+	 * ctx->ctx_lock to prevent other code from messing with the tail
+	 * pointer since we might be called from irq context.
+	 *
+	 * Take rcu_read_lock() in case the kioctx is being destroyed, as we
+	 * need to issue a wakeup after decrementing reqs_active.
 	 */
+	rcu_read_lock();
 	spin_lock_irqsave(&ctx->ctx_lock, flags);
 
 	list_del(&iocb->ki_list); /* remove from active_reqs */
@@ -726,6 +700,7 @@ put_rq:
 		wake_up(&ctx->wait);
 
 	spin_unlock_irqrestore(&ctx->ctx_lock, flags);
+	rcu_read_unlock();
 }
 EXPORT_SYMBOL(aio_complete);
 
@@ -869,7 +844,7 @@ static int read_events(struct kioctx *ctx,
 				break;
 			if (min_nr <= i)
 				break;
-			if (unlikely(ctx->dead)) {
+			if (unlikely(atomic_read(&ctx->dead))) {
 				ret = -EINVAL;
 				break;
 			}
@@ -912,35 +887,6 @@ out:
 	return i ? i : ret;
 }
 
-/* Take an ioctx and remove it from the list of ioctx's.  Protects 
- * against races with itself via ->dead.
- */
-static void io_destroy(struct kioctx *ioctx)
-{
-	struct mm_struct *mm = current->mm;
-	int was_dead;
-
-	/* delete the entry from the list is someone else hasn't already */
-	spin_lock(&mm->ioctx_lock);
-	was_dead = ioctx->dead;
-	ioctx->dead = 1;
-	hlist_del_rcu(&ioctx->list);
-	spin_unlock(&mm->ioctx_lock);
-
-	pr_debug("(%p)\n", ioctx);
-	if (likely(!was_dead))
-		put_ioctx(ioctx);	/* twice for the list */
-
-	kill_ctx(ioctx);
-
-	/*
-	 * Wake up any waiters.  The setting of ctx->dead must be seen
-	 * by other CPUs at this point.  Right now, we rely on the
-	 * locking done by the above calls to ensure this consistency.
-	 */
-	wake_up_all(&ioctx->wait);
-}
-
 /* sys_io_setup:
  *	Create an aio_context capable of receiving at least nr_events.
  *	ctxp must not point to an aio_context that already exists, and
@@ -976,7 +922,7 @@ SYSCALL_DEFINE2(io_setup, unsigned, nr_events, aio_context_t __user *, ctxp)
 	if (!IS_ERR(ioctx)) {
 		ret = put_user(ioctx->user_id, ctxp);
 		if (ret)
-			io_destroy(ioctx);
+			kill_ioctx(ioctx);
 		put_ioctx(ioctx);
 	}
 
@@ -994,7 +940,7 @@ SYSCALL_DEFINE1(io_destroy, aio_context_t, ctx)
 {
 	struct kioctx *ioctx = lookup_ioctx(ctx);
 	if (likely(NULL != ioctx)) {
-		io_destroy(ioctx);
+		kill_ioctx(ioctx);
 		put_ioctx(ioctx);
 		return 0;
 	}
@@ -1297,25 +1243,6 @@ static int io_submit_one(struct kioctx *ctx, struct iocb __user *user_iocb,
 	if (ret)
 		goto out_put_req;
 
-	spin_lock_irq(&ctx->ctx_lock);
-	/*
-	 * We could have raced with io_destroy() and are currently holding a
-	 * reference to ctx which should be destroyed. We cannot submit IO
-	 * since ctx gets freed as soon as io_submit() puts its reference.  The
-	 * check here is reliable: io_destroy() sets ctx->dead before waiting
-	 * for outstanding IO and the barrier between these two is realized by
-	 * unlock of mm->ioctx_lock and lock of ctx->ctx_lock.  Analogously we
-	 * increment ctx->reqs_active before checking for ctx->dead and the
-	 * barrier is realized by unlock and lock of ctx->ctx_lock. Thus if we
-	 * don't see ctx->dead set here, io_destroy() waits for our IO to
-	 * finish.
-	 */
-	if (ctx->dead)
-		ret = -EINVAL;
-	spin_unlock_irq(&ctx->ctx_lock);
-	if (ret)
-		goto out_put_req;
-
 	if (unlikely(kiocbIsCancelled(req))) {
 		ret = -EINTR;
 	} else {
@@ -1341,9 +1268,6 @@ out_put_req:
 	spin_unlock_irq(&ctx->ctx_lock);
 
 	atomic_dec(&ctx->reqs_active);
-	if (unlikely(!atomic_read(&ctx->reqs_active) && ctx->dead))
-		wake_up_all(&ctx->wait);
-
 	aio_put_req(req);	/* drop extra ref to req */
 	aio_put_req(req);	/* drop i/o ref to req */
 	return ret;
-- 
1.7.12

