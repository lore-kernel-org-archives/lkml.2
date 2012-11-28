Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754904Ab2K1QoM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 11:44:12 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48400 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754652Ab2K1QoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 11:44:04 -0500
From: Kent Overstreet <koverstreet@google.com>
To: linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org
Cc: zab@redhat.com, bcrl@kvack.org, jmoyer@redhat.com, axboe@kernel.dk,
        viro@zeniv.linux.org.uk, Kent Overstreet <koverstreet@google.com>
Subject: [PATCH 04/25] aio: remove retry-based AIO
Date: Wed, 28 Nov 2012 08:43:28 -0800
Message-Id: <1354121029-1376-5-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1354121029-1376-1-git-send-email-koverstreet@google.com>
References: <1354121029-1376-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zach Brown <zab@redhat.com>

This removes the retry-based AIO infrastructure now that nothing in tree
is using it.

We want to remove retry-based AIO because it is fundemantally unsafe.
It retries IO submission from a kernel thread that has only assumed the
mm of the submitting task.  All other task_struct references in the IO
submission path will see the kernel thread, not the submitting task.
This design flaw means that nothing of any meaningful complexity can use
retry-based AIO.

This removes all the code and data associated with the retry machinery.
The most significant benefit of this is the removal of the locking
around the unused run list in the submission path.

This has only been compiled.

Signed-off-by: Kent Overstreet <koverstreet@google.com>
---
 fs/aio.c              | 348 ++++----------------------------------------------
 fs/ocfs2/dlmglue.c    |   2 +-
 fs/read_write.c       |  34 +----
 include/linux/aio.h   |  21 ---
 include/linux/errno.h |   1 -
 5 files changed, 29 insertions(+), 377 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index 71f613c..1de4f78 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -54,11 +54,6 @@ unsigned long aio_max_nr = 0x10000; /* system wide maximum number of aio request
 static struct kmem_cache	*kiocb_cachep;
 static struct kmem_cache	*kioctx_cachep;
 
-static struct workqueue_struct *aio_wq;
-
-static void aio_kick_handler(struct work_struct *);
-static void aio_queue_work(struct kioctx *);
-
 /* aio_setup
  *	Creates the slab caches used by the aio routines, panic on
  *	failure as this is done early during the boot sequence.
@@ -68,9 +63,6 @@ static int __init aio_setup(void)
 	kiocb_cachep = KMEM_CACHE(kiocb, SLAB_HWCACHE_ALIGN|SLAB_PANIC);
 	kioctx_cachep = KMEM_CACHE(kioctx,SLAB_HWCACHE_ALIGN|SLAB_PANIC);
 
-	aio_wq = alloc_workqueue("aio", 0, 1);	/* used to limit concurrency */
-	BUG_ON(!aio_wq);
-
 	pr_debug("aio_setup: sizeof(struct page) = %d\n", (int)sizeof(struct page));
 
 	return 0;
@@ -86,7 +78,6 @@ static void aio_free_ring(struct kioctx *ctx)
 		put_page(info->ring_pages[i]);
 
 	if (info->mmap_size) {
-		BUG_ON(ctx->mm != current->mm);
 		vm_munmap(info->mmap_base, info->mmap_size);
 	}
 
@@ -101,6 +92,7 @@ static int aio_setup_ring(struct kioctx *ctx)
 	struct aio_ring *ring;
 	struct aio_ring_info *info = &ctx->ring_info;
 	unsigned nr_events = ctx->max_reqs;
+	struct mm_struct *mm = current->mm;
 	unsigned long size;
 	int nr_pages;
 
@@ -126,22 +118,21 @@ static int aio_setup_ring(struct kioctx *ctx)
 
 	info->mmap_size = nr_pages * PAGE_SIZE;
 	dprintk("attempting mmap of %lu bytes\n", info->mmap_size);
-	down_write(&ctx->mm->mmap_sem);
+	down_write(&mm->mmap_sem);
 	info->mmap_base = do_mmap_pgoff(NULL, 0, info->mmap_size, 
 					PROT_READ|PROT_WRITE,
 					MAP_ANONYMOUS|MAP_PRIVATE, 0);
 	if (IS_ERR((void *)info->mmap_base)) {
-		up_write(&ctx->mm->mmap_sem);
+		up_write(&mm->mmap_sem);
 		info->mmap_size = 0;
 		aio_free_ring(ctx);
 		return -EAGAIN;
 	}
 
 	dprintk("mmap address: 0x%08lx\n", info->mmap_base);
-	info->nr_pages = get_user_pages(current, ctx->mm,
-					info->mmap_base, nr_pages, 
+	info->nr_pages = get_user_pages(current, mm, info->mmap_base, nr_pages, 
 					1, 0, info->ring_pages, NULL);
-	up_write(&ctx->mm->mmap_sem);
+	up_write(&mm->mmap_sem);
 
 	if (unlikely(info->nr_pages != nr_pages)) {
 		aio_free_ring(ctx);
@@ -203,10 +194,7 @@ static void __put_ioctx(struct kioctx *ctx)
 	unsigned nr_events = ctx->max_reqs;
 	BUG_ON(ctx->reqs_active);
 
-	cancel_delayed_work_sync(&ctx->wq);
 	aio_free_ring(ctx);
-	mmdrop(ctx->mm);
-	ctx->mm = NULL;
 	if (nr_events) {
 		spin_lock(&aio_nr_lock);
 		BUG_ON(aio_nr - nr_events > aio_nr);
@@ -234,7 +222,7 @@ static inline void put_ioctx(struct kioctx *kioctx)
  */
 static struct kioctx *ioctx_alloc(unsigned nr_events)
 {
-	struct mm_struct *mm;
+	struct mm_struct *mm = current->mm;
 	struct kioctx *ctx;
 	int err = -ENOMEM;
 
@@ -253,8 +241,6 @@ static struct kioctx *ioctx_alloc(unsigned nr_events)
 		return ERR_PTR(-ENOMEM);
 
 	ctx->max_reqs = nr_events;
-	mm = ctx->mm = current->mm;
-	atomic_inc(&mm->mm_count);
 
 	atomic_set(&ctx->users, 2);
 	spin_lock_init(&ctx->ctx_lock);
@@ -262,8 +248,6 @@ static struct kioctx *ioctx_alloc(unsigned nr_events)
 	init_waitqueue_head(&ctx->wait);
 
 	INIT_LIST_HEAD(&ctx->active_reqs);
-	INIT_LIST_HEAD(&ctx->run_list);
-	INIT_DELAYED_WORK(&ctx->wq, aio_kick_handler);
 
 	if (aio_setup_ring(ctx) < 0)
 		goto out_freectx;
@@ -284,14 +268,13 @@ static struct kioctx *ioctx_alloc(unsigned nr_events)
 	spin_unlock(&mm->ioctx_lock);
 
 	dprintk("aio: allocated ioctx %p[%ld]: mm=%p mask=0x%x\n",
-		ctx, ctx->user_id, current->mm, ctx->ring_info.nr);
+		ctx, ctx->user_id, mm, ctx->ring_info.nr);
 	return ctx;
 
 out_cleanup:
 	err = -EAGAIN;
 	aio_free_ring(ctx);
 out_freectx:
-	mmdrop(mm);
 	kmem_cache_free(kioctx_cachep, ctx);
 	dprintk("aio: error allocating ioctx %d\n", err);
 	return ERR_PTR(err);
@@ -388,8 +371,6 @@ void exit_aio(struct mm_struct *mm)
 		 * as indicator that it needs to unmap the area,
 		 * just set it to 0; aio_free_ring() is the only
 		 * place that uses ->mmap_size, so it's safe.
-		 * That way we get all munmap done to current->mm -
-		 * all other callers have ctx->mm == current->mm.
 		 */
 		ctx->ring_info.mmap_size = 0;
 		put_ioctx(ctx);
@@ -423,7 +404,6 @@ static struct kiocb *__aio_get_req(struct kioctx *ctx)
 	req->ki_dtor = NULL;
 	req->private = NULL;
 	req->ki_iovec = NULL;
-	INIT_LIST_HEAD(&req->ki_run_list);
 	req->ki_eventfd = NULL;
 
 	return req;
@@ -609,281 +589,6 @@ static struct kioctx *lookup_ioctx(unsigned long ctx_id)
 	return ret;
 }
 
-/*
- * Queue up a kiocb to be retried. Assumes that the kiocb
- * has already been marked as kicked, and places it on
- * the retry run list for the corresponding ioctx, if it
- * isn't already queued. Returns 1 if it actually queued
- * the kiocb (to tell the caller to activate the work
- * queue to process it), or 0, if it found that it was
- * already queued.
- */
-static inline int __queue_kicked_iocb(struct kiocb *iocb)
-{
-	struct kioctx *ctx = iocb->ki_ctx;
-
-	assert_spin_locked(&ctx->ctx_lock);
-
-	if (list_empty(&iocb->ki_run_list)) {
-		list_add_tail(&iocb->ki_run_list,
-			&ctx->run_list);
-		return 1;
-	}
-	return 0;
-}
-
-/* aio_run_iocb
- *	This is the core aio execution routine. It is
- *	invoked both for initial i/o submission and
- *	subsequent retries via the aio_kick_handler.
- *	Expects to be invoked with iocb->ki_ctx->lock
- *	already held. The lock is released and reacquired
- *	as needed during processing.
- *
- * Calls the iocb retry method (already setup for the
- * iocb on initial submission) for operation specific
- * handling, but takes care of most of common retry
- * execution details for a given iocb. The retry method
- * needs to be non-blocking as far as possible, to avoid
- * holding up other iocbs waiting to be serviced by the
- * retry kernel thread.
- *
- * The trickier parts in this code have to do with
- * ensuring that only one retry instance is in progress
- * for a given iocb at any time. Providing that guarantee
- * simplifies the coding of individual aio operations as
- * it avoids various potential races.
- */
-static ssize_t aio_run_iocb(struct kiocb *iocb)
-{
-	struct kioctx	*ctx = iocb->ki_ctx;
-	ssize_t (*retry)(struct kiocb *);
-	ssize_t ret;
-
-	if (!(retry = iocb->ki_retry)) {
-		printk("aio_run_iocb: iocb->ki_retry = NULL\n");
-		return 0;
-	}
-
-	/*
-	 * We don't want the next retry iteration for this
-	 * operation to start until this one has returned and
-	 * updated the iocb state. However, wait_queue functions
-	 * can trigger a kick_iocb from interrupt context in the
-	 * meantime, indicating that data is available for the next
-	 * iteration. We want to remember that and enable the
-	 * next retry iteration _after_ we are through with
-	 * this one.
-	 *
-	 * So, in order to be able to register a "kick", but
-	 * prevent it from being queued now, we clear the kick
-	 * flag, but make the kick code *think* that the iocb is
-	 * still on the run list until we are actually done.
-	 * When we are done with this iteration, we check if
-	 * the iocb was kicked in the meantime and if so, queue
-	 * it up afresh.
-	 */
-
-	kiocbClearKicked(iocb);
-
-	/*
-	 * This is so that aio_complete knows it doesn't need to
-	 * pull the iocb off the run list (We can't just call
-	 * INIT_LIST_HEAD because we don't want a kick_iocb to
-	 * queue this on the run list yet)
-	 */
-	iocb->ki_run_list.next = iocb->ki_run_list.prev = NULL;
-	spin_unlock_irq(&ctx->ctx_lock);
-
-	/* Quit retrying if the i/o has been cancelled */
-	if (kiocbIsCancelled(iocb)) {
-		ret = -EINTR;
-		aio_complete(iocb, ret, 0);
-		/* must not access the iocb after this */
-		goto out;
-	}
-
-	/*
-	 * Now we are all set to call the retry method in async
-	 * context.
-	 */
-	ret = retry(iocb);
-
-	if (ret != -EIOCBRETRY && ret != -EIOCBQUEUED) {
-		/*
-		 * There's no easy way to restart the syscall since other AIO's
-		 * may be already running. Just fail this IO with EINTR.
-		 */
-		if (unlikely(ret == -ERESTARTSYS || ret == -ERESTARTNOINTR ||
-			     ret == -ERESTARTNOHAND || ret == -ERESTART_RESTARTBLOCK))
-			ret = -EINTR;
-		aio_complete(iocb, ret, 0);
-	}
-out:
-	spin_lock_irq(&ctx->ctx_lock);
-
-	if (-EIOCBRETRY == ret) {
-		/*
-		 * OK, now that we are done with this iteration
-		 * and know that there is more left to go,
-		 * this is where we let go so that a subsequent
-		 * "kick" can start the next iteration
-		 */
-
-		/* will make __queue_kicked_iocb succeed from here on */
-		INIT_LIST_HEAD(&iocb->ki_run_list);
-		/* we must queue the next iteration ourselves, if it
-		 * has already been kicked */
-		if (kiocbIsKicked(iocb)) {
-			__queue_kicked_iocb(iocb);
-
-			/*
-			 * __queue_kicked_iocb will always return 1 here, because
-			 * iocb->ki_run_list is empty at this point so it should
-			 * be safe to unconditionally queue the context into the
-			 * work queue.
-			 */
-			aio_queue_work(ctx);
-		}
-	}
-	return ret;
-}
-
-/*
- * __aio_run_iocbs:
- * 	Process all pending retries queued on the ioctx
- * 	run list.
- * Assumes it is operating within the aio issuer's mm
- * context.
- */
-static int __aio_run_iocbs(struct kioctx *ctx)
-{
-	struct kiocb *iocb;
-	struct list_head run_list;
-
-	assert_spin_locked(&ctx->ctx_lock);
-
-	list_replace_init(&ctx->run_list, &run_list);
-	while (!list_empty(&run_list)) {
-		iocb = list_entry(run_list.next, struct kiocb,
-			ki_run_list);
-		list_del(&iocb->ki_run_list);
-		/*
-		 * Hold an extra reference while retrying i/o.
-		 */
-		iocb->ki_users++;       /* grab extra reference */
-		aio_run_iocb(iocb);
-		__aio_put_req(ctx, iocb);
- 	}
-	if (!list_empty(&ctx->run_list))
-		return 1;
-	return 0;
-}
-
-static void aio_queue_work(struct kioctx * ctx)
-{
-	unsigned long timeout;
-	/*
-	 * if someone is waiting, get the work started right
-	 * away, otherwise, use a longer delay
-	 */
-	smp_mb();
-	if (waitqueue_active(&ctx->wait))
-		timeout = 1;
-	else
-		timeout = HZ/10;
-	queue_delayed_work(aio_wq, &ctx->wq, timeout);
-}
-
-/*
- * aio_run_all_iocbs:
- *	Process all pending retries queued on the ioctx
- *	run list, and keep running them until the list
- *	stays empty.
- * Assumes it is operating within the aio issuer's mm context.
- */
-static inline void aio_run_all_iocbs(struct kioctx *ctx)
-{
-	spin_lock_irq(&ctx->ctx_lock);
-	while (__aio_run_iocbs(ctx))
-		;
-	spin_unlock_irq(&ctx->ctx_lock);
-}
-
-/*
- * aio_kick_handler:
- * 	Work queue handler triggered to process pending
- * 	retries on an ioctx. Takes on the aio issuer's
- *	mm context before running the iocbs, so that
- *	copy_xxx_user operates on the issuer's address
- *      space.
- * Run on aiod's context.
- */
-static void aio_kick_handler(struct work_struct *work)
-{
-	struct kioctx *ctx = container_of(work, struct kioctx, wq.work);
-	mm_segment_t oldfs = get_fs();
-	struct mm_struct *mm;
-	int requeue;
-
-	set_fs(USER_DS);
-	use_mm(ctx->mm);
-	spin_lock_irq(&ctx->ctx_lock);
-	requeue =__aio_run_iocbs(ctx);
-	mm = ctx->mm;
-	spin_unlock_irq(&ctx->ctx_lock);
- 	unuse_mm(mm);
-	set_fs(oldfs);
-	/*
-	 * we're in a worker thread already; no point using non-zero delay
-	 */
-	if (requeue)
-		queue_delayed_work(aio_wq, &ctx->wq, 0);
-}
-
-
-/*
- * Called by kick_iocb to queue the kiocb for retry
- * and if required activate the aio work queue to process
- * it
- */
-static void try_queue_kicked_iocb(struct kiocb *iocb)
-{
- 	struct kioctx	*ctx = iocb->ki_ctx;
-	unsigned long flags;
-	int run = 0;
-
-	spin_lock_irqsave(&ctx->ctx_lock, flags);
-	/* set this inside the lock so that we can't race with aio_run_iocb()
-	 * testing it and putting the iocb on the run list under the lock */
-	if (!kiocbTryKick(iocb))
-		run = __queue_kicked_iocb(iocb);
-	spin_unlock_irqrestore(&ctx->ctx_lock, flags);
-	if (run)
-		aio_queue_work(ctx);
-}
-
-/*
- * kick_iocb:
- *      Called typically from a wait queue callback context
- *      to trigger a retry of the iocb.
- *      The retry is usually executed by aio workqueue
- *      threads (See aio_kick_handler).
- */
-void kick_iocb(struct kiocb *iocb)
-{
-	/* sync iocbs are easy: they can only ever be executing from a 
-	 * single context. */
-	if (is_sync_kiocb(iocb)) {
-		kiocbSetKicked(iocb);
-	        wake_up_process(iocb->ki_obj.tsk);
-		return;
-	}
-
-	try_queue_kicked_iocb(iocb);
-}
-EXPORT_SYMBOL(kick_iocb);
-
 /* aio_complete
  *	Called when the io request on the given iocb is complete.
  *	Returns true if this is the last user of the request.  The 
@@ -924,9 +629,6 @@ int aio_complete(struct kiocb *iocb, long res, long res2)
 	 */
 	spin_lock_irqsave(&ctx->ctx_lock, flags);
 
-	if (iocb->ki_run_list.prev && !list_empty(&iocb->ki_run_list))
-		list_del_init(&iocb->ki_run_list);
-
 	/*
 	 * cancelled requests don't get events, userland was given one
 	 * when the event got cancelled.
@@ -1081,13 +783,11 @@ static int read_events(struct kioctx *ctx,
 	int			i = 0;
 	struct io_event		ent;
 	struct aio_timeout	to;
-	int			retry = 0;
 
 	/* needed to zero any padding within an entry (there shouldn't be 
 	 * any, but C is fun!
 	 */
 	memset(&ent, 0, sizeof(ent));
-retry:
 	ret = 0;
 	while (likely(i < nr)) {
 		ret = aio_read_evt(ctx, &ent);
@@ -1117,13 +817,6 @@ retry:
 
 	/* End fast path */
 
-	/* racey check, but it gets redone */
-	if (!retry && unlikely(!list_empty(&ctx->run_list))) {
-		retry = 1;
-		aio_run_all_iocbs(ctx);
-		goto retry;
-	}
-
 	init_timeout(&to);
 	if (timeout) {
 		struct timespec	ts;
@@ -1343,7 +1036,7 @@ static ssize_t aio_rw_vect_retry(struct kiocb *iocb)
 	/* If we managed to write some out we return that, rather than
 	 * the eventual error. */
 	if (opcode == IOCB_CMD_PWRITEV
-	    && ret < 0 && ret != -EIOCBQUEUED && ret != -EIOCBRETRY
+	    && ret < 0 && ret != -EIOCBQUEUED
 	    && iocb->ki_nbytes - iocb->ki_left)
 		ret = iocb->ki_nbytes - iocb->ki_left;
 
@@ -1585,18 +1278,27 @@ static int io_submit_one(struct kioctx *ctx, struct iocb __user *user_iocb,
 	 * don't see ctx->dead set here, io_destroy() waits for our IO to
 	 * finish.
 	 */
-	if (ctx->dead) {
-		spin_unlock_irq(&ctx->ctx_lock);
+	if (ctx->dead)
 		ret = -EINVAL;
+	spin_unlock_irq(&ctx->ctx_lock);
+	if (ret)
 		goto out_put_req;
+
+	if (unlikely(kiocbIsCancelled(req))) {
+		ret = -EINTR;
+	} else {
+		ret = req->ki_retry(req);
 	}
-	aio_run_iocb(req);
-	if (!list_empty(&ctx->run_list)) {
-		/* drain the run list */
-		while (__aio_run_iocbs(ctx))
-			;
+	if (ret != -EIOCBQUEUED) {
+		/*
+		 * There's no easy way to restart the syscall since other AIO's
+		 * may be already running. Just fail this IO with EINTR.
+		 */
+		if (unlikely(ret == -ERESTARTSYS || ret == -ERESTARTNOINTR ||
+			     ret == -ERESTARTNOHAND || ret == -ERESTART_RESTARTBLOCK))
+			ret = -EINTR;
+		aio_complete(req, ret, 0);
 	}
-	spin_unlock_irq(&ctx->ctx_lock);
 
 	aio_put_req(req);	/* drop extra ref to req */
 	return 0;
diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index 4f7795f..bad2583 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -2322,7 +2322,7 @@ int ocfs2_inode_lock_full_nested(struct inode *inode,
 	status = __ocfs2_cluster_lock(osb, lockres, level, dlm_flags,
 				      arg_flags, subclass, _RET_IP_);
 	if (status < 0) {
-		if (status != -EAGAIN && status != -EIOCBRETRY)
+		if (status != -EAGAIN)
 			mlog_errno(status);
 		goto bail;
 	}
diff --git a/fs/read_write.c b/fs/read_write.c
index d065348..7347732 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -318,16 +318,6 @@ int rw_verify_area(int read_write, struct file *file, loff_t *ppos, size_t count
 	return count > MAX_RW_COUNT ? MAX_RW_COUNT : count;
 }
 
-static void wait_on_retry_sync_kiocb(struct kiocb *iocb)
-{
-	set_current_state(TASK_UNINTERRUPTIBLE);
-	if (!kiocbIsKicked(iocb))
-		schedule();
-	else
-		kiocbClearKicked(iocb);
-	__set_current_state(TASK_RUNNING);
-}
-
 ssize_t do_sync_read(struct file *filp, char __user *buf, size_t len, loff_t *ppos)
 {
 	struct iovec iov = { .iov_base = buf, .iov_len = len };
@@ -339,13 +329,7 @@ ssize_t do_sync_read(struct file *filp, char __user *buf, size_t len, loff_t *pp
 	kiocb.ki_left = len;
 	kiocb.ki_nbytes = len;
 
-	for (;;) {
-		ret = filp->f_op->aio_read(&kiocb, &iov, 1, kiocb.ki_pos);
-		if (ret != -EIOCBRETRY)
-			break;
-		wait_on_retry_sync_kiocb(&kiocb);
-	}
-
+	ret = filp->f_op->aio_read(&kiocb, &iov, 1, kiocb.ki_pos);
 	if (-EIOCBQUEUED == ret)
 		ret = wait_on_sync_kiocb(&kiocb);
 	*ppos = kiocb.ki_pos;
@@ -395,13 +379,7 @@ ssize_t do_sync_write(struct file *filp, const char __user *buf, size_t len, lof
 	kiocb.ki_left = len;
 	kiocb.ki_nbytes = len;
 
-	for (;;) {
-		ret = filp->f_op->aio_write(&kiocb, &iov, 1, kiocb.ki_pos);
-		if (ret != -EIOCBRETRY)
-			break;
-		wait_on_retry_sync_kiocb(&kiocb);
-	}
-
+	ret = filp->f_op->aio_write(&kiocb, &iov, 1, kiocb.ki_pos);
 	if (-EIOCBQUEUED == ret)
 		ret = wait_on_sync_kiocb(&kiocb);
 	*ppos = kiocb.ki_pos;
@@ -568,13 +546,7 @@ ssize_t do_sync_readv_writev(struct file *filp, const struct iovec *iov,
 	kiocb.ki_left = len;
 	kiocb.ki_nbytes = len;
 
-	for (;;) {
-		ret = fn(&kiocb, iov, nr_segs, kiocb.ki_pos);
-		if (ret != -EIOCBRETRY)
-			break;
-		wait_on_retry_sync_kiocb(&kiocb);
-	}
-
+	ret = fn(&kiocb, iov, nr_segs, kiocb.ki_pos);
 	if (ret == -EIOCBQUEUED)
 		ret = wait_on_sync_kiocb(&kiocb);
 	*ppos = kiocb.ki_pos;
diff --git a/include/linux/aio.h b/include/linux/aio.h
index b46a09f..387dad0 100644
--- a/include/linux/aio.h
+++ b/include/linux/aio.h
@@ -14,18 +14,12 @@ struct kioctx;
 #define KIOCB_SYNC_KEY		(~0U)
 
 /* ki_flags bits */
-#define KIF_KICKED		1
 #define KIF_CANCELLED		2
 
-#define kiocbTryKick(iocb)	test_and_set_bit(KIF_KICKED, &(iocb)->ki_flags)
-
-#define kiocbSetKicked(iocb)	set_bit(KIF_KICKED, &(iocb)->ki_flags)
 #define kiocbSetCancelled(iocb)	set_bit(KIF_CANCELLED, &(iocb)->ki_flags)
 
-#define kiocbClearKicked(iocb)	clear_bit(KIF_KICKED, &(iocb)->ki_flags)
 #define kiocbClearCancelled(iocb)	clear_bit(KIF_CANCELLED, &(iocb)->ki_flags)
 
-#define kiocbIsKicked(iocb)	test_bit(KIF_KICKED, &(iocb)->ki_flags)
 #define kiocbIsCancelled(iocb)	test_bit(KIF_CANCELLED, &(iocb)->ki_flags)
 
 /* is there a better place to document function pointer methods? */
@@ -52,15 +46,6 @@ struct kioctx;
  * not ask the method again -- ki_retry must ensure forward progress.
  * aio_complete() must be called once and only once in the future, multiple
  * calls may result in undefined behaviour.
- *
- * If ki_retry returns -EIOCBRETRY it has made a promise that kick_iocb()
- * will be called on the kiocb pointer in the future.  This may happen
- * through generic helpers that associate kiocb->ki_wait with a wait
- * queue head that ki_retry uses via current->io_wait.  It can also happen
- * with custom tracking and manual calls to kick_iocb(), though that is
- * discouraged.  In either case, kick_iocb() must be called once and only
- * once.  ki_retry must ensure forward progress, the AIO core will wait
- * indefinitely for kick_iocb() to be called.
  */
 struct kiocb {
 	struct list_head	ki_run_list;
@@ -160,7 +145,6 @@ static inline unsigned aio_ring_avail(struct aio_ring_info *info,
 struct kioctx {
 	atomic_t		users;
 	int			dead;
-	struct mm_struct	*mm;
 
 	/* This needs improving */
 	unsigned long		user_id;
@@ -172,15 +156,12 @@ struct kioctx {
 
 	int			reqs_active;
 	struct list_head	active_reqs;	/* used for cancellation */
-	struct list_head	run_list;	/* used for kicked reqs */
 
 	/* sys_io_setup currently limits this to an unsigned int */
 	unsigned		max_reqs;
 
 	struct aio_ring_info	ring_info;
 
-	struct delayed_work	wq;
-
 	struct rcu_head		rcu_head;
 };
 
@@ -188,7 +169,6 @@ struct kioctx {
 #ifdef CONFIG_AIO
 extern ssize_t wait_on_sync_kiocb(struct kiocb *iocb);
 extern int aio_put_req(struct kiocb *iocb);
-extern void kick_iocb(struct kiocb *iocb);
 extern int aio_complete(struct kiocb *iocb, long res, long res2);
 struct mm_struct;
 extern void exit_aio(struct mm_struct *mm);
@@ -197,7 +177,6 @@ extern long do_io_submit(aio_context_t ctx_id, long nr,
 #else
 static inline ssize_t wait_on_sync_kiocb(struct kiocb *iocb) { return 0; }
 static inline int aio_put_req(struct kiocb *iocb) { return 0; }
-static inline void kick_iocb(struct kiocb *iocb) { }
 static inline int aio_complete(struct kiocb *iocb, long res, long res2) { return 0; }
 struct mm_struct;
 static inline void exit_aio(struct mm_struct *mm) { }
diff --git a/include/linux/errno.h b/include/linux/errno.h
index f6bf082..89627b9 100644
--- a/include/linux/errno.h
+++ b/include/linux/errno.h
@@ -28,6 +28,5 @@
 #define EBADTYPE	527	/* Type not supported by server */
 #define EJUKEBOX	528	/* Request initiated, but will not complete before timeout */
 #define EIOCBQUEUED	529	/* iocb queued, will get completion event */
-#define EIOCBRETRY	530	/* iocb queued, will trigger a retry */
 
 #endif
-- 
1.7.12

