Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752448Ab2L0CHv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2012 21:07:51 -0500
Received: from mail-pb0-f51.google.com ([209.85.160.51]:45077 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752001Ab2L0CHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2012 21:07:46 -0500
From: Kent Overstreet <koverstreet@google.com>
To: linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org
Cc: Kent Overstreet <koverstreet@google.com>, zab@redhat.com, bcrl@kvack.org,
        jmoyer@redhat.com, axboe@kernel.dk, viro@zeniv.linux.org.uk,
        tytso@mit.edu
Subject: [PATCH 16/32] aio: Use cancellation list lazily
Date: Wed, 26 Dec 2012 17:59:55 -0800
Message-Id: <1356573611-18590-19-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1356573611-18590-1-git-send-email-koverstreet@google.com>
References: <1356573611-18590-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cancelling kiocbs requires adding them to a per kioctx linked list,
which is one of the few things we need to take the kioctx lock for in
the fast path. But most kiocbs can't be cancelled - so if we just do
this lazily, we can avoid quite a bit of locking overhead.

While we're at it, instead of using a flag bit switch to using ki_cancel
itself to indicate that a kiocb has been cancelled/completed. This lets
us get rid of ki_flags entirely.

Signed-off-by: Kent Overstreet <koverstreet@google.com>
---
 drivers/usb/gadget/inode.c |  3 +-
 fs/aio.c                   | 95 +++++++++++++++++++++++++---------------------
 include/linux/aio.h        | 16 ++++----
 3 files changed, 59 insertions(+), 55 deletions(-)

diff --git a/drivers/usb/gadget/inode.c b/drivers/usb/gadget/inode.c
index 7640e01..3bf0c35 100644
--- a/drivers/usb/gadget/inode.c
+++ b/drivers/usb/gadget/inode.c
@@ -534,7 +534,6 @@ static int ep_aio_cancel(struct kiocb *iocb, struct io_event *e)
 	local_irq_disable();
 	epdata = priv->epdata;
 	// spin_lock(&epdata->dev->lock);
-	kiocbSetCancelled(iocb);
 	if (likely(epdata && epdata->ep && priv->req))
 		value = usb_ep_dequeue (epdata->ep, priv->req);
 	else
@@ -664,7 +663,7 @@ fail:
 		goto fail;
 	}
 
-	iocb->ki_cancel = ep_aio_cancel;
+	kiocb_set_cancel_fn(iocb, ep_aio_cancel);
 	get_ep(epdata);
 	priv->epdata = epdata;
 	priv->actual = 0;
diff --git a/fs/aio.c b/fs/aio.c
index c1047c8..276c6ea 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -97,6 +97,8 @@ struct kioctx {
 
 	struct aio_ring_info	ring_info;
 
+	spinlock_t		completion_lock;
+
 	struct rcu_head		rcu_head;
 	struct work_struct	rcu_work;
 };
@@ -217,25 +219,40 @@ static int aio_setup_ring(struct kioctx *ctx)
 #define AIO_EVENTS_FIRST_PAGE	((PAGE_SIZE - sizeof(struct aio_ring)) / sizeof(struct io_event))
 #define AIO_EVENTS_OFFSET	(AIO_EVENTS_PER_PAGE - AIO_EVENTS_FIRST_PAGE)
 
+void kiocb_set_cancel_fn(struct kiocb *req, kiocb_cancel_fn *cancel)
+{
+	if (!req->ki_list.next) {
+		struct kioctx *ctx = req->ki_ctx;
+		unsigned long flags;
+
+		spin_lock_irqsave(&ctx->ctx_lock, flags);
+		list_add(&req->ki_list, &ctx->active_reqs);
+		spin_unlock_irqrestore(&ctx->ctx_lock, flags);
+	}
+
+	req->ki_cancel = cancel;
+}
+EXPORT_SYMBOL(kiocb_set_cancel_fn);
+
 static int kiocb_cancel(struct kioctx *ctx, struct kiocb *kiocb,
 			struct io_event *res)
 {
-	int (*cancel)(struct kiocb *, struct io_event *);
+	kiocb_cancel_fn *cancel;
 	int ret = -EINVAL;
 
-	cancel = kiocb->ki_cancel;
-	kiocbSetCancelled(kiocb);
-	if (cancel) {
-		atomic_inc(&kiocb->ki_users);
-		spin_unlock_irq(&ctx->ctx_lock);
+	cancel = xchg(&kiocb->ki_cancel, KIOCB_CANCELLED);
+	if (!cancel || cancel == KIOCB_CANCELLED)
+		return ret;
+
+	atomic_inc(&kiocb->ki_users);
+	spin_unlock_irq(&ctx->ctx_lock);
 
-		memset(res, 0, sizeof(*res));
-		res->obj = (u64) kiocb->ki_obj.user;
-		res->data = kiocb->ki_user_data;
-		ret = cancel(kiocb, res);
+	memset(res, 0, sizeof(*res));
+	res->obj = (u64) kiocb->ki_obj.user;
+	res->data = kiocb->ki_user_data;
+	ret = cancel(kiocb, res);
 
-		spin_lock_irq(&ctx->ctx_lock);
-	}
+	spin_lock_irq(&ctx->ctx_lock);
 
 	return ret;
 }
@@ -323,6 +340,7 @@ static struct kioctx *ioctx_alloc(unsigned nr_events)
 	atomic_set(&ctx->users, 2);
 	atomic_set(&ctx->dead, 0);
 	spin_lock_init(&ctx->ctx_lock);
+	spin_lock_init(&ctx->completion_lock);
 	mutex_init(&ctx->ring_info.ring_lock);
 	init_waitqueue_head(&ctx->wait);
 
@@ -465,20 +483,12 @@ static struct kiocb *__aio_get_req(struct kioctx *ctx)
 {
 	struct kiocb *req = NULL;
 
-	req = kmem_cache_alloc(kiocb_cachep, GFP_KERNEL);
+	req = kmem_cache_alloc(kiocb_cachep, GFP_KERNEL|__GFP_ZERO);
 	if (unlikely(!req))
 		return NULL;
 
-	req->ki_flags = 0;
 	atomic_set(&req->ki_users, 2);
-	req->ki_key = 0;
 	req->ki_ctx = ctx;
-	req->ki_cancel = NULL;
-	req->ki_retry = NULL;
-	req->ki_dtor = NULL;
-	req->private = NULL;
-	req->ki_iovec = NULL;
-	req->ki_eventfd = NULL;
 
 	return req;
 }
@@ -509,7 +519,6 @@ static void kiocb_batch_free(struct kioctx *ctx, struct kiocb_batch *batch)
 	spin_lock_irq(&ctx->ctx_lock);
 	list_for_each_entry_safe(req, n, &batch->head, ki_batch) {
 		list_del(&req->ki_batch);
-		list_del(&req->ki_list);
 		kmem_cache_free(kiocb_cachep, req);
 		atomic_dec(&ctx->reqs_active);
 	}
@@ -555,10 +564,7 @@ static int kiocb_batch_refill(struct kioctx *ctx, struct kiocb_batch *batch)
 	}
 
 	batch->count -= allocated;
-	list_for_each_entry(req, &batch->head, ki_batch) {
-		list_add(&req->ki_list, &ctx->active_reqs);
-		atomic_inc(&ctx->reqs_active);
-	}
+	atomic_add(allocated, &ctx->reqs_active);
 
 	kunmap_atomic(ring);
 	spin_unlock_irq(&ctx->ctx_lock);
@@ -649,25 +655,34 @@ void aio_complete(struct kiocb *iocb, long res, long res2)
 	info = &ctx->ring_info;
 
 	/*
-	 * Add a completion event to the ring buffer. Must be done holding
-	 * ctx->ctx_lock to prevent other code from messing with the tail
-	 * pointer since we might be called from irq context.
-	 *
 	 * Take rcu_read_lock() in case the kioctx is being destroyed, as we
 	 * need to issue a wakeup after decrementing reqs_active.
 	 */
 	rcu_read_lock();
-	spin_lock_irqsave(&ctx->ctx_lock, flags);
 
-	list_del(&iocb->ki_list); /* remove from active_reqs */
+	if (iocb->ki_list.next) {
+		unsigned long flags;
+
+		spin_lock_irqsave(&ctx->ctx_lock, flags);
+		list_del(&iocb->ki_list);
+		spin_unlock_irqrestore(&ctx->ctx_lock, flags);
+	}
 
 	/*
 	 * cancelled requests don't get events, userland was given one
 	 * when the event got cancelled.
 	 */
-	if (kiocbIsCancelled(iocb))
+	if (unlikely(xchg(&iocb->ki_cancel,
+			  KIOCB_CANCELLED) == KIOCB_CANCELLED))
 		goto put_rq;
 
+	/*
+	 * Add a completion event to the ring buffer. Must be done holding
+	 * ctx->ctx_lock to prevent other code from messing with the tail
+	 * pointer since we might be called from irq context.
+	 */
+	spin_lock_irqsave(&ctx->completion_lock, flags);
+
 	tail = info->tail;
 	pos = tail + AIO_EVENTS_OFFSET;
 
@@ -701,6 +716,8 @@ void aio_complete(struct kiocb *iocb, long res, long res2)
 	kunmap_atomic(ring);
 	flush_dcache_page(info->ring_pages[0]);
 
+	spin_unlock_irqrestore(&ctx->completion_lock, flags);
+
 	pr_debug("added to ring %p at [%u]\n", iocb, tail);
 
 	/*
@@ -727,7 +744,6 @@ put_rq:
 	if (waitqueue_active(&ctx->wait))
 		wake_up(&ctx->wait);
 
-	spin_unlock_irqrestore(&ctx->ctx_lock, flags);
 	rcu_read_unlock();
 }
 EXPORT_SYMBOL(aio_complete);
@@ -1196,15 +1212,10 @@ static int io_submit_one(struct kioctx *ctx, struct iocb __user *user_iocb,
 	req->ki_opcode = iocb->aio_lio_opcode;
 
 	ret = aio_setup_iocb(req, compat);
-
 	if (ret)
 		goto out_put_req;
 
-	if (unlikely(kiocbIsCancelled(req))) {
-		ret = -EINTR;
-	} else {
-		ret = req->ki_retry(req);
-	}
+	ret = req->ki_retry(req);
 	if (ret != -EIOCBQUEUED) {
 		/*
 		 * There's no easy way to restart the syscall since other AIO's
@@ -1220,10 +1231,6 @@ static int io_submit_one(struct kioctx *ctx, struct iocb __user *user_iocb,
 	return 0;
 
 out_put_req:
-	spin_lock_irq(&ctx->ctx_lock);
-	list_del(&req->ki_list);
-	spin_unlock_irq(&ctx->ctx_lock);
-
 	atomic_dec(&ctx->reqs_active);
 	aio_put_req(req);	/* drop extra ref to req */
 	aio_put_req(req);	/* drop i/o ref to req */
diff --git a/include/linux/aio.h b/include/linux/aio.h
index 1e728f0..fc3c467 100644
--- a/include/linux/aio.h
+++ b/include/linux/aio.h
@@ -10,17 +10,13 @@
 #include <linux/atomic.h>
 
 struct kioctx;
+struct kiocb;
 
 #define KIOCB_SYNC_KEY		(~0U)
 
-/* ki_flags bits */
-#define KIF_CANCELLED		2
+#define KIOCB_CANCELLED		((void *) (~0ULL))
 
-#define kiocbSetCancelled(iocb)	set_bit(KIF_CANCELLED, &(iocb)->ki_flags)
-
-#define kiocbClearCancelled(iocb)	clear_bit(KIF_CANCELLED, &(iocb)->ki_flags)
-
-#define kiocbIsCancelled(iocb)	test_bit(KIF_CANCELLED, &(iocb)->ki_flags)
+typedef int (kiocb_cancel_fn)(struct kiocb *, struct io_event *);
 
 /* is there a better place to document function pointer methods? */
 /**
@@ -48,13 +44,12 @@ struct kioctx;
  * calls may result in undefined behaviour.
  */
 struct kiocb {
-	unsigned long		ki_flags;
 	atomic_t		ki_users;
 	unsigned		ki_key;		/* id of this request */
 
 	struct file		*ki_filp;
 	struct kioctx		*ki_ctx;	/* may be NULL for sync ops */
-	int			(*ki_cancel)(struct kiocb *, struct io_event *);
+	kiocb_cancel_fn		*ki_cancel;
 	ssize_t			(*ki_retry)(struct kiocb *);
 	void			(*ki_dtor)(struct kiocb *);
 
@@ -112,6 +107,7 @@ struct mm_struct;
 extern void exit_aio(struct mm_struct *mm);
 extern long do_io_submit(aio_context_t ctx_id, long nr,
 			 struct iocb __user *__user *iocbpp, bool compat);
+void kiocb_set_cancel_fn(struct kiocb *req, kiocb_cancel_fn *cancel);
 #else
 static inline ssize_t wait_on_sync_kiocb(struct kiocb *iocb) { return 0; }
 static inline void aio_put_req(struct kiocb *iocb) { }
@@ -121,6 +117,8 @@ static inline void exit_aio(struct mm_struct *mm) { }
 static inline long do_io_submit(aio_context_t ctx_id, long nr,
 				struct iocb __user * __user *iocbpp,
 				bool compat) { return 0; }
+static inline void kiocb_set_cancel_fn(struct kiocb *req,
+				       kiocb_cancel_fn *cancel) { }
 #endif /* CONFIG_AIO */
 
 static inline struct kiocb *list_kiocb(struct list_head *h)
-- 
1.7.12

