Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753530Ab2JIGjj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 02:39:39 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40974 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753104Ab2JIGjg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 02:39:36 -0400
From: Kent Overstreet <koverstreet@google.com>
To: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, tytso@mit.edu
Cc: Kent Overstreet <koverstreet@google.com>
Subject: [PATCH 4/5] aio: vmap ringbuffer
Date: Mon,  8 Oct 2012 23:39:19 -0700
Message-Id: <1349764760-21093-4-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1349764760-21093-1-git-send-email-koverstreet@google.com>
References: <1349764760-21093-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It simplifies a lot of stuff if the ringbuffer is contiguously mapped
into kernel space, and we can delete a lot of code - in particular, this
is useful for converting read_events() to cmpxchg.

It'd make more sense if the ringbuffer was allocated with
__get_free_pages() and then mapped into userspace, but I couldn't figure
out how to sanely do that... so vmap works for now.

Signed-off-by: Kent Overstreet <koverstreet@google.com>
---
 fs/aio.c            |   85 +++++++++++++++++----------------------------------
 include/linux/aio.h |    7 +++--
 2 files changed, 32 insertions(+), 60 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index 3ab12f6..c3d97d1 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -82,6 +82,9 @@ static void aio_free_ring(struct kioctx *ctx)
 	struct aio_ring_info *info = &ctx->ring_info;
 	long i;
 
+	if (info->ring)
+		vunmap(info->ring);
+
 	for (i=0; i<info->nr_pages; i++)
 		put_page(info->ring_pages[i]);
 
@@ -99,7 +102,6 @@ static void aio_free_ring(struct kioctx *ctx)
 
 static int aio_setup_ring(struct kioctx *ctx)
 {
-	struct aio_ring *ring;
 	struct aio_ring_info *info = &ctx->ring_info;
 	unsigned nr_events = ctx->max_reqs;
 	unsigned long size;
@@ -149,46 +151,27 @@ static int aio_setup_ring(struct kioctx *ctx)
 		return -EAGAIN;
 	}
 
+	info->ring = vmap(info->ring_pages, nr_pages, VM_MAP, PAGE_KERNEL);
+	if (!info->ring) {
+		aio_free_ring(ctx);
+		return -ENOMEM;
+	}
+
 	ctx->user_id = info->mmap_base;
 
 	info->nr = nr_events;		/* trusted copy */
 
-	ring = kmap_atomic(info->ring_pages[0]);
-	ring->nr = nr_events;	/* user copy */
-	ring->id = ctx->user_id;
-	ring->head = ring->tail = 0;
-	ring->magic = AIO_RING_MAGIC;
-	ring->compat_features = AIO_RING_COMPAT_FEATURES;
-	ring->incompat_features = AIO_RING_INCOMPAT_FEATURES;
-	ring->header_length = sizeof(struct aio_ring);
-	kunmap_atomic(ring);
+	info->ring->nr = nr_events;	/* user copy */
+	info->ring->id = ctx->user_id;
+	info->ring->head = info->ring->tail = 0;
+	info->ring->magic = AIO_RING_MAGIC;
+	info->ring->compat_features = AIO_RING_COMPAT_FEATURES;
+	info->ring->incompat_features = AIO_RING_INCOMPAT_FEATURES;
+	info->ring->header_length = sizeof(struct aio_ring);
 
 	return 0;
 }
 
-
-/* aio_ring_event: returns a pointer to the event at the given index from
- * kmap_atomic().  Release the pointer with put_aio_ring_event();
- */
-#define AIO_EVENTS_PER_PAGE	(PAGE_SIZE / sizeof(struct io_event))
-#define AIO_EVENTS_FIRST_PAGE	((PAGE_SIZE - sizeof(struct aio_ring)) / sizeof(struct io_event))
-#define AIO_EVENTS_OFFSET	(AIO_EVENTS_PER_PAGE - AIO_EVENTS_FIRST_PAGE)
-
-#define aio_ring_event(info, nr) ({					\
-	unsigned pos = (nr) + AIO_EVENTS_OFFSET;			\
-	struct io_event *__event;					\
-	__event = kmap_atomic(						\
-			(info)->ring_pages[pos / AIO_EVENTS_PER_PAGE]); \
-	__event += pos % AIO_EVENTS_PER_PAGE;				\
-	__event;							\
-})
-
-#define put_aio_ring_event(event) do {		\
-	struct io_event *__event = (event);	\
-	(void)__event;				\
-	kunmap_atomic((void *)((unsigned long)__event & PAGE_MASK)); \
-} while(0)
-
 static void free_ioctx(struct work_struct *work)
 {
 	struct kioctx *ctx = container_of(work, struct kioctx, free_work);
@@ -465,7 +448,6 @@ static int kiocb_batch_refill(struct kioctx *ctx, struct kiocb_batch *batch)
 	unsigned short allocated, to_alloc;
 	long avail;
 	struct kiocb *req, *n;
-	struct aio_ring *ring;
 
 	to_alloc = min(batch->count, KIOCB_BATCH_SIZE);
 	for (allocated = 0; allocated < to_alloc; allocated++) {
@@ -480,9 +462,8 @@ static int kiocb_batch_refill(struct kioctx *ctx, struct kiocb_batch *batch)
 		goto out;
 
 	spin_lock_irq(&ctx->ctx_lock);
-	ring = kmap_atomic(ctx->ring_info.ring_pages[0]);
 
-	avail = aio_ring_avail(&ctx->ring_info, ring) - atomic_read(&ctx->reqs_active);
+	avail = aio_ring_avail(&ctx->ring_info) - atomic_read(&ctx->reqs_active);
 	BUG_ON(avail < 0);
 	if (avail < allocated) {
 		/* Trim back the number of requests. */
@@ -500,7 +481,6 @@ static int kiocb_batch_refill(struct kioctx *ctx, struct kiocb_batch *batch)
 		atomic_inc(&ctx->reqs_active);
 	}
 
-	kunmap_atomic(ring);
 	spin_unlock_irq(&ctx->ctx_lock);
 
 out:
@@ -870,10 +850,9 @@ void aio_complete(struct kiocb *iocb, long res, long res2)
 {
 	struct kioctx	*ctx = iocb->ki_ctx;
 	struct aio_ring_info	*info;
-	struct aio_ring	*ring;
 	struct io_event	*event;
 	unsigned long	flags;
-	unsigned long	tail;
+	unsigned tail;
 
 	/*
 	 * Special case handling for sync iocbs:
@@ -892,7 +871,8 @@ void aio_complete(struct kiocb *iocb, long res, long res2)
 
 	info = &ctx->ring_info;
 
-	/* add a completion event to the ring buffer.
+	/*
+	 * add a completion event to the ring buffer.
 	 * must be done holding ctx->ctx_lock to prevent
 	 * other code from messing with the tail
 	 * pointer since we might be called from irq
@@ -910,10 +890,8 @@ void aio_complete(struct kiocb *iocb, long res, long res2)
 	if (kiocbIsCancelled(iocb))
 		goto put_rq;
 
-	ring = kmap_atomic(info->ring_pages[0]);
-
 	tail = info->tail;
-	event = aio_ring_event(info, tail);
+	event = &info->ring->io_events[tail];
 	if (++tail >= info->nr)
 		tail = 0;
 
@@ -922,9 +900,9 @@ void aio_complete(struct kiocb *iocb, long res, long res2)
 	event->res = res;
 	event->res2 = res2;
 
-	dprintk("aio_complete: %p[%lu]: %p: %p %Lx %lx %lx\n",
-		ctx, tail, iocb, iocb->ki_obj.user, iocb->ki_user_data,
-		res, res2);
+	pr_debug("%p[%u]: %p: %p %Lx %lx %lx\n",
+		 ctx, tail, iocb, iocb->ki_obj.user, iocb->ki_user_data,
+		 res, res2);
 
 	/* after flagging the request as done, we
 	 * must never even look at it again
@@ -932,12 +910,9 @@ void aio_complete(struct kiocb *iocb, long res, long res2)
 	smp_wmb();	/* make event visible before updating tail */
 
 	info->tail = tail;
-	ring->tail = tail;
-
-	put_aio_ring_event(event);
-	kunmap_atomic(ring);
+	info->ring->tail = tail;
 
-	pr_debug("added to ring %p at [%lu]\n", iocb, tail);
+	pr_debug("added to ring %p at [%u]\n", iocb, tail);
 
 	/*
 	 * Check if the user asked us to deliver the result through an
@@ -975,11 +950,10 @@ EXPORT_SYMBOL(aio_complete);
 static int aio_read_evt(struct kioctx *ioctx, struct io_event *ent)
 {
 	struct aio_ring_info *info = &ioctx->ring_info;
-	struct aio_ring *ring;
+	struct aio_ring *ring = info->ring;
 	unsigned long head;
 	int ret = 0;
 
-	ring = kmap_atomic(info->ring_pages[0]);
 	dprintk("in aio_read_evt h%lu t%lu m%lu\n",
 		 (unsigned long)ring->head, (unsigned long)ring->tail,
 		 (unsigned long)ring->nr);
@@ -991,18 +965,15 @@ static int aio_read_evt(struct kioctx *ioctx, struct io_event *ent)
 
 	head = ring->head % info->nr;
 	if (head != ring->tail) {
-		struct io_event *evp = aio_ring_event(info, head);
-		*ent = *evp;
+		*ent = ring->io_events[head];
 		head = (head + 1) % info->nr;
 		smp_mb(); /* finish reading the event before updatng the head */
 		ring->head = head;
 		ret = 1;
-		put_aio_ring_event(evp);
 	}
 	spin_unlock(&info->ring_lock);
 
 out:
-	kunmap_atomic(ring);
 	dprintk("leaving aio_read_evt: %d  h%lu t%lu\n", ret,
 		 (unsigned long)ring->head, (unsigned long)ring->tail);
 	return ret;
diff --git a/include/linux/aio.h b/include/linux/aio.h
index eb6e5e4..150a4b7 100644
--- a/include/linux/aio.h
+++ b/include/linux/aio.h
@@ -161,6 +161,7 @@ struct aio_ring {
 
 #define AIO_RING_PAGES	8
 struct aio_ring_info {
+	struct aio_ring		*ring;
 	unsigned long		mmap_base;
 	unsigned long		mmap_size;
 
@@ -173,10 +174,10 @@ struct aio_ring_info {
 	struct page		*internal_pages[AIO_RING_PAGES];
 };
 
-static inline unsigned aio_ring_avail(struct aio_ring_info *info,
-					struct aio_ring *ring)
+static inline unsigned aio_ring_avail(struct aio_ring_info *info)
 {
-	return (ring->head + info->nr - 1 - ring->tail) % info->nr;
+	return (info->ring->head + info->nr - 1 - info->ring->tail) %
+		info->nr;
 }
 
 struct kioctx {
-- 
1.7.10.4

