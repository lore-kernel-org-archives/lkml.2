Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753946Ab2K2BjJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 20:39:09 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:33164 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753190Ab2K2BjD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 20:39:03 -0500
Date: Wed, 28 Nov 2012 17:38:58 -0800
From: Kent Overstreet <koverstreet@google.com>
To: Benjamin LaHaise <bcrl@kvack.org>
Cc: linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org, zab@redhat.com, jmoyer@redhat.com,
        axboe@kernel.dk, viro@zeniv.linux.org.uk
Subject: Re: [PATCH 12/25] aio: Refcounting cleanup
Message-ID: <20121129013858.GD15094@google.com>
References: <1354121029-1376-1-git-send-email-koverstreet@google.com>
 <1354121029-1376-13-git-send-email-koverstreet@google.com>
 <20121129004631.GE19042@kvack.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121129004631.GE19042@kvack.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 28, 2012 at 07:46:31PM -0500, Benjamin LaHaise wrote:
> Hi Kent,
> 
> On Wed, Nov 28, 2012 at 08:43:36AM -0800, Kent Overstreet wrote:
> > + * now it's safe to cancel any that need to be.
> > + */
> > +static void free_ioctx(struct kioctx *ctx)
> ...
> > +	aio_nr -= ctx->max_reqs;
> > +	spin_unlock(&aio_nr_lock);
> > +
> > +	synchronize_rcu();
> > +
> > +	pr_debug("freeing %p\n", ctx);
> > +	kmem_cache_free(kioctx_cachep, ctx);
> > +}
> 
> As mentioned on irc, we probably want to avoid the synchronize_rcu() 
> overhead, since delays here will impact the time it takes for a task to 
> exit.  Cheers,

Yeah, suppose you're right. Have an updated patch below, which also
documents exactly what the rcu usage is for:

I'm not a big fan of the contortions where kill_ioctx() does one thing
and exit_aio() does a slightly different thing so the vm_munmap()
happens in the right context, but oh well.


commit 8f3f71c5e9ae0a76bcf019a8f00510076ecc052e
Author: Kent Overstreet <koverstreet@google.com>
Date:   Wed Nov 28 17:27:19 2012 -0800

    aio: Refcounting cleanup
    
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

diff --git a/fs/aio.c b/fs/aio.c
index 4c9a5bf..7b75590 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -79,7 +79,7 @@ static inline unsigned aio_ring_avail(struct aio_ring_info *info,
 
 struct kioctx {
 	atomic_t		users;
-	int			dead;
+	atomic_t		dead;
 
 	/* This needs improving */
 	unsigned long		user_id;
@@ -98,6 +98,7 @@ struct kioctx {
 	struct aio_ring_info	ring_info;
 
 	struct rcu_head		rcu_head;
+	struct work_struct	rcu_work;
 };
 
 /*------ sysctl variables----*/
@@ -234,44 +235,6 @@ static int aio_setup_ring(struct kioctx *ctx)
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
@@ -295,6 +258,61 @@ static int kiocb_cancel(struct kioctx *ctx, struct kiocb *kiocb,
 	return ret;
 }
 
+static void free_ioctx_rcu(struct rcu_head *head)
+{
+	struct kioctx *ctx = container_of(head, struct kioctx, rcu_head);
+	kmem_cache_free(kioctx_cachep, ctx);
+}
+
+/*
+ * When this function runs, the kioctx has been removed from the "hash table"
+ * and ctx->users has dropped to 0, so we know no more kiocbs can be submitted -
+ * now it's safe to cancel any that need to be.
+ */
+static void free_ioctx(struct kioctx *ctx)
+{
+	struct io_event res;
+	struct kiocb *iocb;
+
+	spin_lock_irq(&ctx->ctx_lock);
+
+	while (!list_empty(&ctx->active_reqs)) {
+		iocb = list_first_entry(&ctx->active_reqs,
+					struct kiocb, ki_list);
+
+		list_del_init(&iocb->ki_list);
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
+	pr_debug("freeing %p\n", ctx);
+
+	/*
+	 * Here the call_rcu() is between the wait_event() for reqs_active to
+	 * hit 0, and freeing the ioctx.
+	 *
+	 * aio_complete() decrements reqs_active, but it has to touch the ioctx
+	 * after to issue a wakeup so we use rcu.
+	 */
+	call_rcu(&ctx->rcu_head, free_ioctx_rcu);
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
@@ -321,6 +339,7 @@ static struct kioctx *ioctx_alloc(unsigned nr_events)
 	ctx->max_reqs = nr_events;
 
 	atomic_set(&ctx->users, 2);
+	atomic_set(&ctx->dead, 0);
 	spin_lock_init(&ctx->ctx_lock);
 	spin_lock_init(&ctx->ring_info.ring_lock);
 	init_waitqueue_head(&ctx->wait);
@@ -358,43 +377,43 @@ out_freectx:
 	return ERR_PTR(err);
 }
 
-/* kill_ctx
- *	Cancels all outstanding aio requests on an aio context.  Used 
- *	when the processes owning a context have all exited to encourage 
- *	the rapid destruction of the kioctx.
- */
-static void kill_ctx(struct kioctx *ctx)
+static void kill_ioctx_work(struct work_struct *work)
 {
-	struct task_struct *tsk = current;
-	DECLARE_WAITQUEUE(wait, tsk);
-	struct io_event res;
+	struct kioctx *ctx = container_of(work, struct kioctx, rcu_work);
 
-	spin_lock_irq(&ctx->ctx_lock);
-	ctx->dead = 1;
-	while (!list_empty(&ctx->active_reqs)) {
-		struct list_head *pos = ctx->active_reqs.next;
-		struct kiocb *iocb = list_kiocb(pos);
-		list_del_init(&iocb->ki_list);
+	wake_up_all(&ctx->wait);
+	put_ioctx(ctx);
+}
 
-		kiocb_cancel(ctx, iocb, &res);
-	}
+static void kill_ioctx_rcu(struct rcu_head *head)
+{
+	struct kioctx *ctx = container_of(head, struct kioctx, rcu_head);
 
-	if (!atomic_read(&ctx->reqs_active))
-		goto out;
+	INIT_WORK(&ctx->rcu_work, kill_ioctx_work);
+	schedule_work(&ctx->rcu_work);
+}
 
-	add_wait_queue(&ctx->wait, &wait);
-	set_task_state(tsk, TASK_UNINTERRUPTIBLE);
-	while (atomic_read(&ctx->reqs_active)) {
-		spin_unlock_irq(&ctx->ctx_lock);
-		io_schedule();
-		set_task_state(tsk, TASK_UNINTERRUPTIBLE);
-		spin_lock_irq(&ctx->ctx_lock);
-	}
-	__set_task_state(tsk, TASK_RUNNING);
-	remove_wait_queue(&ctx->wait, &wait);
+/* kill_ioctx
+ *	Cancels all outstanding aio requests on an aio context.  Used
+ *	when the processes owning a context have all exited to encourage
+ *	the rapid destruction of the kioctx.
+ */
+static void kill_ioctx(struct kioctx *ctx)
+{
+	if (!atomic_xchg(&ctx->dead, 1)) {
+		hlist_del_rcu(&ctx->list);
+		/* Between hlist_del_rcu() and dropping the initial ref */
+		synchronize_rcu();
 
-out:
-	spin_unlock_irq(&ctx->ctx_lock);
+		/*
+		 * We can't punt to workqueue here because put_ioctx() ->
+		 * free_ioctx() will unmap the ringbuffer, and that has to be
+		 * done in the original process's context. kill_ioctx_rcu/work()
+		 * exist for exit_aio(), as in that path free_ioctx() won't do
+		 * the unmap.
+		 */
+		kill_ioctx_work(&ctx->rcu_work);
+	}
 }
 
 /* wait_on_sync_kiocb:
@@ -413,27 +432,25 @@ ssize_t wait_on_sync_kiocb(struct kiocb *iocb)
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
@@ -444,7 +461,11 @@ void exit_aio(struct mm_struct *mm)
 		 * place that uses ->mmap_size, so it's safe.
 		 */
 		ctx->ring_info.mmap_size = 0;
-		put_ioctx(ctx);
+
+		if (!atomic_xchg(&ctx->dead, 1)) {
+			hlist_del_rcu(&ctx->list);
+			call_rcu(&ctx->rcu_head, kill_ioctx_rcu);
+		}
 	}
 }
 
@@ -510,8 +531,6 @@ static void kiocb_batch_free(struct kioctx *ctx, struct kiocb_batch *batch)
 		kmem_cache_free(kiocb_cachep, req);
 		atomic_dec(&ctx->reqs_active);
 	}
-	if (unlikely(!atomic_read(&ctx->reqs_active) && ctx->dead))
-		wake_up_all(&ctx->wait);
 	spin_unlock_irq(&ctx->ctx_lock);
 }
 
@@ -607,18 +626,12 @@ static struct kioctx *lookup_ioctx(unsigned long ctx_id)
 
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
+			atomic_inc(&ctx->users);
 			ret = ctx;
 			break;
 		}
-	}
 
 	rcu_read_unlock();
 	return ret;
@@ -655,12 +668,15 @@ void aio_complete(struct kiocb *iocb, long res, long res2)
 
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
@@ -726,6 +742,7 @@ put_rq:
 		wake_up(&ctx->wait);
 
 	spin_unlock_irqrestore(&ctx->ctx_lock, flags);
+	rcu_read_unlock();
 }
 EXPORT_SYMBOL(aio_complete);
 
@@ -869,7 +886,7 @@ static int read_events(struct kioctx *ctx,
 				break;
 			if (min_nr <= i)
 				break;
-			if (unlikely(ctx->dead)) {
+			if (unlikely(atomic_read(&ctx->dead))) {
 				ret = -EINVAL;
 				break;
 			}
@@ -912,35 +929,6 @@ out:
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
@@ -976,7 +964,7 @@ SYSCALL_DEFINE2(io_setup, unsigned, nr_events, aio_context_t __user *, ctxp)
 	if (!IS_ERR(ioctx)) {
 		ret = put_user(ioctx->user_id, ctxp);
 		if (ret)
-			io_destroy(ioctx);
+			kill_ioctx(ioctx);
 		put_ioctx(ioctx);
 	}
 
@@ -994,7 +982,7 @@ SYSCALL_DEFINE1(io_destroy, aio_context_t, ctx)
 {
 	struct kioctx *ioctx = lookup_ioctx(ctx);
 	if (likely(NULL != ioctx)) {
-		io_destroy(ioctx);
+		kill_ioctx(ioctx);
 		put_ioctx(ioctx);
 		return 0;
 	}
@@ -1297,25 +1285,6 @@ static int io_submit_one(struct kioctx *ctx, struct iocb __user *user_iocb,
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
@@ -1341,9 +1310,6 @@ out_put_req:
 	spin_unlock_irq(&ctx->ctx_lock);
 
 	atomic_dec(&ctx->reqs_active);
-	if (unlikely(!atomic_read(&ctx->reqs_active) && ctx->dead))
-		wake_up_all(&ctx->wait);
-
 	aio_put_req(req);	/* drop extra ref to req */
 	aio_put_req(req);	/* drop i/o ref to req */
 	return ret;
