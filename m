Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753882Ab2JIGkM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 02:40:12 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40974 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751792Ab2JIGjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 02:39:35 -0400
From: Kent Overstreet <koverstreet@google.com>
To: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, tytso@mit.edu
Cc: Kent Overstreet <koverstreet@google.com>
Subject: [PATCH 3/5] aio: Rewrite refcounting
Date: Mon,  8 Oct 2012 23:39:18 -0700
Message-Id: <1349764760-21093-3-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1349764760-21093-1-git-send-email-koverstreet@google.com>
References: <1349764760-21093-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The refcounting before wasn't very clear; there are two refcounts in
struct kioctx, with an unclear relationship between them (or between
them and ctx->dead).

Now, reqs_active holds a refcount on users (when reqs_active is
nonzero), and the initial refcount is taken on reqs_active - when
ctx->dead goes to 1, we drop that initial refcount.

Some other semi related cleanup too.

Signed-off-by: Kent Overstreet <koverstreet@google.com>
---
 fs/aio.c            |  187 +++++++++++++++++----------------------------------
 include/linux/aio.h |    5 +-
 2 files changed, 63 insertions(+), 129 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index 95419c4..3ab12f6 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -86,8 +86,9 @@ static void aio_free_ring(struct kioctx *ctx)
 		put_page(info->ring_pages[i]);
 
 	if (info->mmap_size) {
-		BUG_ON(ctx->mm != current->mm);
-		vm_munmap(info->mmap_base, info->mmap_size);
+		down_write(&ctx->mm->mmap_sem);
+		do_munmap(ctx->mm, info->mmap_base, info->mmap_size);
+		up_write(&ctx->mm->mmap_sem);
 	}
 
 	if (info->ring_pages && info->ring_pages != info->internal_pages)
@@ -188,45 +189,37 @@ static int aio_setup_ring(struct kioctx *ctx)
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
+static void free_ioctx(struct work_struct *work)
 {
-	unsigned nr_events = ctx->max_reqs;
-	BUG_ON(ctx->reqs_active);
+	struct kioctx *ctx = container_of(work, struct kioctx, free_work);
 
 	cancel_delayed_work_sync(&ctx->wq);
 	aio_free_ring(ctx);
 	mmdrop(ctx->mm);
-	ctx->mm = NULL;
-	if (nr_events) {
-		spin_lock(&aio_nr_lock);
-		BUG_ON(aio_nr - nr_events > aio_nr);
-		aio_nr -= nr_events;
-		spin_unlock(&aio_nr_lock);
-	}
-	pr_debug("__put_ioctx: freeing %p\n", ctx);
-	call_rcu(&ctx->rcu_head, ctx_rcu_free);
-}
 
-static inline int try_get_ioctx(struct kioctx *kioctx)
-{
-	return atomic_inc_not_zero(&kioctx->users);
+	spin_lock(&aio_nr_lock);
+	BUG_ON(aio_nr - ctx->max_reqs > aio_nr);
+	aio_nr -= ctx->max_reqs;
+	spin_unlock(&aio_nr_lock);
+
+	synchronize_rcu();
+
+	pr_debug("__put_ioctx: freeing %p\n", ctx);
+	kmem_cache_free(kioctx_cachep, ctx);
 }
 
 static inline void put_ioctx(struct kioctx *kioctx)
 {
 	BUG_ON(atomic_read(&kioctx->users) <= 0);
 	if (unlikely(atomic_dec_and_test(&kioctx->users)))
-		__put_ioctx(kioctx);
+		schedule_work(&kioctx->free_work);
+}
+
+static inline void req_put_ioctx(struct kioctx *kioctx)
+{
+	BUG_ON(atomic_read(&kioctx->reqs_active) <= 0);
+	if (unlikely(atomic_dec_and_test(&kioctx->reqs_active)))
+		put_ioctx(kioctx);
 }
 
 static int kiocb_cancel(struct kioctx *ctx, struct kiocb *kiocb,
@@ -280,12 +273,15 @@ static struct kioctx *ioctx_alloc(unsigned nr_events)
 	atomic_inc(&mm->mm_count);
 
 	atomic_set(&ctx->users, 2);
+	atomic_set(&ctx->reqs_active, 1);
+
 	spin_lock_init(&ctx->ctx_lock);
 	spin_lock_init(&ctx->ring_info.ring_lock);
 	init_waitqueue_head(&ctx->wait);
 
 	INIT_LIST_HEAD(&ctx->active_reqs);
 	INIT_LIST_HEAD(&ctx->run_list);
+	INIT_WORK(&ctx->free_work, free_ioctx);
 	INIT_DELAYED_WORK(&ctx->wq, aio_kick_handler);
 
 	if (aio_setup_ring(ctx) < 0)
@@ -327,36 +323,25 @@ out_freectx:
  */
 static void kill_ctx(struct kioctx *ctx)
 {
-	struct task_struct *tsk = current;
-	DECLARE_WAITQUEUE(wait, tsk);
+	struct kiocb *iocb, *t;
 	struct io_event res;
+	int put = 0;
 
 	spin_lock_irq(&ctx->ctx_lock);
-	ctx->dead = 1;
-	while (!list_empty(&ctx->active_reqs)) {
-		struct list_head *pos = ctx->active_reqs.next;
-		struct kiocb *iocb = list_kiocb(pos);
-		list_del_init(&iocb->ki_list);
 
-		kiocb_cancel(ctx, iocb, &res);
+	if (!ctx->dead) {
+		put = 1;
+		ctx->dead = 1;
+		hlist_del_rcu(&ctx->list);
 	}
 
-	if (!ctx->reqs_active)
-		goto out;
-
-	add_wait_queue(&ctx->wait, &wait);
-	set_task_state(tsk, TASK_UNINTERRUPTIBLE);
-	while (ctx->reqs_active) {
-		spin_unlock_irq(&ctx->ctx_lock);
-		io_schedule();
-		set_task_state(tsk, TASK_UNINTERRUPTIBLE);
-		spin_lock_irq(&ctx->ctx_lock);
-	}
-	__set_task_state(tsk, TASK_RUNNING);
-	remove_wait_queue(&ctx->wait, &wait);
+	list_for_each_entry_safe(iocb, t, &ctx->active_reqs, ki_list)
+		kiocb_cancel(ctx, iocb, &res);
 
-out:
 	spin_unlock_irq(&ctx->ctx_lock);
+
+	if (put)
+		req_put_ioctx(ctx);
 }
 
 /* wait_on_sync_kiocb:
@@ -385,18 +370,16 @@ EXPORT_SYMBOL(wait_on_sync_kiocb);
 void exit_aio(struct mm_struct *mm)
 {
 	struct kioctx *ctx;
+	struct hlist_node *p;
 
-	while (!hlist_empty(&mm->ioctx_list)) {
-		ctx = hlist_entry(mm->ioctx_list.first, struct kioctx, list);
-		hlist_del_rcu(&ctx->list);
-
-		kill_ctx(ctx);
+	spin_lock(&mm->ioctx_lock);
 
+	hlist_for_each_entry(ctx, p, &mm->ioctx_list, list) {
 		if (1 != atomic_read(&ctx->users))
 			printk(KERN_DEBUG
 				"exit_aio:ioctx still alive: %d %d %d\n",
 				atomic_read(&ctx->users), ctx->dead,
-				ctx->reqs_active);
+				atomic_read(&ctx->reqs_active));
 		/*
 		 * We don't need to bother with munmap() here -
 		 * exit_mmap(mm) is coming and it'll unmap everything.
@@ -408,39 +391,34 @@ void exit_aio(struct mm_struct *mm)
 		 * all other callers have ctx->mm == current->mm.
 		 */
 		ctx->ring_info.mmap_size = 0;
-		put_ioctx(ctx);
+		kill_ctx(ctx);
 	}
+
+	spin_unlock(&mm->ioctx_lock);
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
  */
 static struct kiocb *__aio_get_req(struct kioctx *ctx)
 {
-	struct kiocb *req = NULL;
+	struct kiocb *req;
 
 	req = kmem_cache_alloc(kiocb_cachep, GFP_KERNEL);
 	if (unlikely(!req))
 		return NULL;
 
-	req->ki_flags = 0;
+	memset(req, 0, sizeof(*req));
 	req->ki_users = 2;
-	req->ki_key = 0;
 	req->ki_ctx = ctx;
-	req->ki_cancel = NULL;
-	req->ki_retry = NULL;
-	req->ki_dtor = NULL;
-	req->private = NULL;
-	req->ki_iovec = NULL;
 	INIT_LIST_HEAD(&req->ki_run_list);
-	req->ki_eventfd = NULL;
 
 	return req;
 }
@@ -473,10 +451,8 @@ static void kiocb_batch_free(struct kioctx *ctx, struct kiocb_batch *batch)
 		list_del(&req->ki_batch);
 		list_del(&req->ki_list);
 		kmem_cache_free(kiocb_cachep, req);
-		ctx->reqs_active--;
+		req_put_ioctx(ctx);
 	}
-	if (unlikely(!ctx->reqs_active && ctx->dead))
-		wake_up_all(&ctx->wait);
 	spin_unlock_irq(&ctx->ctx_lock);
 }
 
@@ -506,7 +482,7 @@ static int kiocb_batch_refill(struct kioctx *ctx, struct kiocb_batch *batch)
 	spin_lock_irq(&ctx->ctx_lock);
 	ring = kmap_atomic(ctx->ring_info.ring_pages[0]);
 
-	avail = aio_ring_avail(&ctx->ring_info, ring) - ctx->reqs_active;
+	avail = aio_ring_avail(&ctx->ring_info, ring) - atomic_read(&ctx->reqs_active);
 	BUG_ON(avail < 0);
 	if (avail < allocated) {
 		/* Trim back the number of requests. */
@@ -521,7 +497,7 @@ static int kiocb_batch_refill(struct kioctx *ctx, struct kiocb_batch *batch)
 	batch->count -= allocated;
 	list_for_each_entry(req, &batch->head, ki_batch) {
 		list_add(&req->ki_list, &ctx->active_reqs);
-		ctx->reqs_active++;
+		atomic_inc(&ctx->reqs_active);
 	}
 
 	kunmap_atomic(ring);
@@ -546,8 +522,7 @@ static inline struct kiocb *aio_get_req(struct kioctx *ctx,
 
 static inline void really_put_req(struct kioctx *ctx, struct kiocb *req)
 {
-	assert_spin_locked(&ctx->ctx_lock);
-
+	fput(req->ki_filp);
 	if (req->ki_eventfd != NULL)
 		eventfd_ctx_put(req->ki_eventfd);
 	if (req->ki_dtor)
@@ -555,10 +530,8 @@ static inline void really_put_req(struct kioctx *ctx, struct kiocb *req)
 	if (req->ki_iovec != &req->ki_inline_vec)
 		kfree(req->ki_iovec);
 	kmem_cache_free(kiocb_cachep, req);
-	ctx->reqs_active--;
 
-	if (unlikely(!ctx->reqs_active && ctx->dead))
-		wake_up_all(&ctx->wait);
+	req_put_ioctx(ctx);
 }
 
 /* __aio_put_req
@@ -566,8 +539,8 @@ static inline void really_put_req(struct kioctx *ctx, struct kiocb *req)
  */
 static void __aio_put_req(struct kioctx *ctx, struct kiocb *req)
 {
-	dprintk(KERN_DEBUG "aio_put(%p): f_count=%ld\n",
-		req, atomic_long_read(&req->ki_filp->f_count));
+	pr_debug("req=%p f_count=%ld\n",
+		 req, atomic_long_read(&req->ki_filp->f_count));
 
 	assert_spin_locked(&ctx->ctx_lock);
 
@@ -576,11 +549,7 @@ static void __aio_put_req(struct kioctx *ctx, struct kiocb *req)
 	if (likely(req->ki_users))
 		return;
 	list_del(&req->ki_list);		/* remove from active_reqs */
-	req->ki_cancel = NULL;
-	req->ki_retry = NULL;
 
-	fput(req->ki_filp);
-	req->ki_filp = NULL;
 	really_put_req(ctx, req);
 }
 
@@ -605,18 +574,13 @@ static struct kioctx *lookup_ioctx(unsigned long ctx_id)
 
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
+			BUG_ON(ctx->dead);
+			atomic_inc(&ctx->users);
 			ret = ctx;
 			break;
 		}
-	}
 
 	rcu_read_unlock();
 	return ret;
@@ -1162,7 +1126,7 @@ retry:
 				break;
 			/* Try to only show up in io wait if there are ops
 			 *  in flight */
-			if (ctx->reqs_active)
+			if (atomic_read(&ctx->reqs_active) > 1)
 				io_schedule();
 			else
 				schedule();
@@ -1197,35 +1161,6 @@ out:
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
-	dprintk("aio_release(%p)\n", ioctx);
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
@@ -1261,7 +1196,7 @@ SYSCALL_DEFINE2(io_setup, unsigned, nr_events, aio_context_t __user *, ctxp)
 	if (!IS_ERR(ioctx)) {
 		ret = put_user(ioctx->user_id, ctxp);
 		if (ret)
-			io_destroy(ioctx);
+			kill_ctx(ioctx);
 		put_ioctx(ioctx);
 	}
 
@@ -1279,7 +1214,7 @@ SYSCALL_DEFINE1(io_destroy, aio_context_t, ctx)
 {
 	struct kioctx *ioctx = lookup_ioctx(ctx);
 	if (likely(NULL != ioctx)) {
-		io_destroy(ioctx);
+		kill_ctx(ioctx);
 		put_ioctx(ioctx);
 		return 0;
 	}
diff --git a/include/linux/aio.h b/include/linux/aio.h
index 4cde86d..eb6e5e4 100644
--- a/include/linux/aio.h
+++ b/include/linux/aio.h
@@ -192,7 +192,7 @@ struct kioctx {
 
 	spinlock_t		ctx_lock;
 
-	int			reqs_active;
+	atomic_t		reqs_active;
 	struct list_head	active_reqs;	/* used for cancellation */
 	struct list_head	run_list;	/* used for kicked reqs */
 
@@ -202,8 +202,7 @@ struct kioctx {
 	struct aio_ring_info	ring_info;
 
 	struct delayed_work	wq;
-
-	struct rcu_head		rcu_head;
+	struct work_struct	free_work;
 };
 
 /* prototypes */
-- 
1.7.10.4

