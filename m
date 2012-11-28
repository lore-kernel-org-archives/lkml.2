Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755575Ab2K1QrJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 11:47:09 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:37932 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755277Ab2K1QoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 11:44:24 -0500
From: Kent Overstreet <koverstreet@google.com>
To: linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org
Cc: zab@redhat.com, bcrl@kvack.org, jmoyer@redhat.com, axboe@kernel.dk,
        viro@zeniv.linux.org.uk, Kent Overstreet <koverstreet@google.com>
Subject: [PATCH 18/25] aio: Kill struct aio_ring_info
Date: Wed, 28 Nov 2012 08:43:42 -0800
Message-Id: <1354121029-1376-19-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1354121029-1376-1-git-send-email-koverstreet@google.com>
References: <1354121029-1376-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

struct aio_ring_info was kind of odd, the only place it's used is where
it's embedded in struct kioctx - there's no real need for it.

The next patch rearranges struct kioctx and puts various things on their
own cachelines - getting rid of struct aio_ring_info now makes that
reordering a bit clearer.

Signed-off-by: Kent Overstreet <koverstreet@google.com>
---
 fs/aio.c | 142 ++++++++++++++++++++++++++++++---------------------------------
 1 file changed, 68 insertions(+), 74 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index f2d616e..1ff4d3b 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -58,18 +58,6 @@ struct aio_ring {
 }; /* 128 bytes + ring size */
 
 #define AIO_RING_PAGES	8
-struct aio_ring_info {
-	unsigned long		mmap_base;
-	unsigned long		mmap_size;
-
-	struct page		**ring_pages;
-	struct mutex		ring_lock;
-	long			nr_pages;
-
-	unsigned		nr, tail;
-
-	struct page		*internal_pages[AIO_RING_PAGES];
-};
 
 struct kioctx {
 	atomic_t		users;
@@ -86,12 +74,28 @@ struct kioctx {
 	atomic_t		reqs_active;
 	struct list_head	active_reqs;	/* used for cancellation */
 
+	unsigned		nr;
+
 	/* sys_io_setup currently limits this to an unsigned int */
 	unsigned		max_reqs;
 
-	struct aio_ring_info	ring_info;
+	unsigned long		mmap_base;
+	unsigned long		mmap_size;
+
+	struct page		**ring_pages;
+	long			nr_pages;
+
+	struct {
+		struct mutex	ring_lock;
+	} ____cacheline_aligned;
+
+	struct {
+		unsigned	tail;
+		spinlock_t	completion_lock;
+	} ____cacheline_aligned;
+
+	struct page		*internal_pages[AIO_RING_PAGES];
 
-	spinlock_t		completion_lock;
 };
 
 /*------ sysctl variables----*/
@@ -120,26 +124,21 @@ __initcall(aio_setup);
 
 static void aio_free_ring(struct kioctx *ctx)
 {
-	struct aio_ring_info *info = &ctx->ring_info;
 	long i;
 
-	for (i=0; i<info->nr_pages; i++)
-		put_page(info->ring_pages[i]);
+	for (i = 0; i < ctx->nr_pages; i++)
+		put_page(ctx->ring_pages[i]);
 
-	if (info->mmap_size) {
-		vm_munmap(info->mmap_base, info->mmap_size);
-	}
+	if (ctx->mmap_size)
+		vm_munmap(ctx->mmap_base, ctx->mmap_size);
 
-	if (info->ring_pages && info->ring_pages != info->internal_pages)
-		kfree(info->ring_pages);
-	info->ring_pages = NULL;
-	info->nr = 0;
+	if (ctx->ring_pages && ctx->ring_pages != ctx->internal_pages)
+		kfree(ctx->ring_pages);
 }
 
 static int aio_setup_ring(struct kioctx *ctx)
 {
 	struct aio_ring *ring;
-	struct aio_ring_info *info = &ctx->ring_info;
 	unsigned nr_events = ctx->max_reqs;
 	struct mm_struct *mm = current->mm;
 	unsigned long size;
@@ -157,42 +156,42 @@ static int aio_setup_ring(struct kioctx *ctx)
 
 	nr_events = (PAGE_SIZE * nr_pages - sizeof(struct aio_ring)) / sizeof(struct io_event);
 
-	info->nr = 0;
-	info->ring_pages = info->internal_pages;
+	ctx->nr = 0;
+	ctx->ring_pages = ctx->internal_pages;
 	if (nr_pages > AIO_RING_PAGES) {
-		info->ring_pages = kcalloc(nr_pages, sizeof(struct page *), GFP_KERNEL);
-		if (!info->ring_pages)
+		ctx->ring_pages = kcalloc(nr_pages, sizeof(struct page *), GFP_KERNEL);
+		if (!ctx->ring_pages)
 			return -ENOMEM;
 	}
 
-	info->mmap_size = nr_pages * PAGE_SIZE;
-	pr_debug("attempting mmap of %lu bytes\n", info->mmap_size);
+	ctx->mmap_size = nr_pages * PAGE_SIZE;
+	pr_debug("attempting mmap of %lu bytes\n", ctx->mmap_size);
 	down_write(&mm->mmap_sem);
-	info->mmap_base = do_mmap_pgoff(NULL, 0, info->mmap_size, 
-					PROT_READ|PROT_WRITE,
-					MAP_ANONYMOUS|MAP_PRIVATE, 0);
-	if (IS_ERR((void *)info->mmap_base)) {
+	ctx->mmap_base = do_mmap_pgoff(NULL, 0, ctx->mmap_size,
+				       PROT_READ|PROT_WRITE,
+				       MAP_ANONYMOUS|MAP_PRIVATE, 0);
+	if (IS_ERR((void *)ctx->mmap_base)) {
 		up_write(&mm->mmap_sem);
-		info->mmap_size = 0;
+		ctx->mmap_size = 0;
 		aio_free_ring(ctx);
 		return -EAGAIN;
 	}
 
-	pr_debug("mmap address: 0x%08lx\n", info->mmap_base);
-	info->nr_pages = get_user_pages(current, mm, info->mmap_base, nr_pages, 
-					1, 0, info->ring_pages, NULL);
+	pr_debug("mmap address: 0x%08lx\n", ctx->mmap_base);
+	ctx->nr_pages = get_user_pages(current, mm, ctx->mmap_base, nr_pages,
+				       1, 0, ctx->ring_pages, NULL);
 	up_write(&mm->mmap_sem);
 
-	if (unlikely(info->nr_pages != nr_pages)) {
+	if (unlikely(ctx->nr_pages != nr_pages)) {
 		aio_free_ring(ctx);
 		return -EAGAIN;
 	}
 
-	ctx->user_id = info->mmap_base;
+	ctx->user_id = ctx->mmap_base;
 
-	info->nr = nr_events;		/* trusted copy */
+	ctx->nr = nr_events;		/* trusted copy */
 
-	ring = kmap_atomic(info->ring_pages[0]);
+	ring = kmap_atomic(ctx->ring_pages[0]);
 	ring->nr = nr_events;	/* user copy */
 	ring->id = ctx->user_id;
 	ring->head = ring->tail = 0;
@@ -213,11 +212,11 @@ static int aio_setup_ring(struct kioctx *ctx)
 #define AIO_EVENTS_FIRST_PAGE	((PAGE_SIZE - sizeof(struct aio_ring)) / sizeof(struct io_event))
 #define AIO_EVENTS_OFFSET	(AIO_EVENTS_PER_PAGE - AIO_EVENTS_FIRST_PAGE)
 
-#define aio_ring_event(info, nr) ({					\
+#define aio_ring_event(ctx, nr) ({					\
 	unsigned pos = (nr) + AIO_EVENTS_OFFSET;			\
 	struct io_event *__event;					\
 	__event = kmap_atomic(						\
-			(info)->ring_pages[pos / AIO_EVENTS_PER_PAGE]); \
+			(ctx)->ring_pages[pos / AIO_EVENTS_PER_PAGE]); \
 	__event += pos % AIO_EVENTS_PER_PAGE;				\
 	__event;							\
 })
@@ -276,7 +275,6 @@ static int kiocb_cancel(struct kioctx *ctx, struct kiocb *kiocb,
  */
 static void free_ioctx(struct kioctx *ctx)
 {
-	struct aio_ring_info *info = &ctx->ring_info;
 	struct aio_ring *ring;
 	struct io_event res;
 	unsigned head, avail;
@@ -293,18 +291,18 @@ static void free_ioctx(struct kioctx *ctx)
 
 	spin_unlock_irq(&ctx->ctx_lock);
 
-	ring = kmap_atomic(info->ring_pages[0]);
+	ring = kmap_atomic(ctx->ring_pages[0]);
 	head = ring->head;
 	kunmap_atomic(ring);
 
 	while (atomic_read(&ctx->reqs_active) > 0) {
-		wait_event(ctx->wait, head != info->tail);
+		wait_event(ctx->wait, head != ctx->tail);
 
-		avail = (head < info->tail ? info->tail : info->nr) - head;
+		avail = (head < ctx->tail ? ctx->tail : ctx->nr) - head;
 
 		atomic_sub(avail, &ctx->reqs_active);
 		head += avail;
-		head %= info->nr;
+		head %= ctx->nr;
 	}
 
 	WARN_ON(atomic_read(&ctx->reqs_active) < 0);
@@ -356,7 +354,7 @@ static struct kioctx *ioctx_alloc(unsigned nr_events)
 	atomic_set(&ctx->users, 2);
 	spin_lock_init(&ctx->ctx_lock);
 	spin_lock_init(&ctx->completion_lock);
-	mutex_init(&ctx->ring_info.ring_lock);
+	mutex_init(&ctx->ring_lock);
 	init_waitqueue_head(&ctx->wait);
 
 	INIT_LIST_HEAD(&ctx->active_reqs);
@@ -380,7 +378,7 @@ static struct kioctx *ioctx_alloc(unsigned nr_events)
 	spin_unlock(&mm->ioctx_lock);
 
 	pr_debug("allocated ioctx %p[%ld]: mm=%p mask=0x%x\n",
-		ctx, ctx->user_id, mm, ctx->ring_info.nr);
+		 ctx, ctx->user_id, mm, ctx->nr);
 	return ctx;
 
 out_cleanup:
@@ -453,7 +451,7 @@ void exit_aio(struct mm_struct *mm)
 		 * just set it to 0; aio_free_ring() is the only
 		 * place that uses ->mmap_size, so it's safe.
 		 */
-		ctx->ring_info.mmap_size = 0;
+		ctx->mmap_size = 0;
 		kill_ioctx(ctx);
 	}
 }
@@ -472,10 +470,10 @@ static inline struct kiocb *aio_get_req(struct kioctx *ctx)
 {
 	struct kiocb *req;
 
-	if (atomic_read(&ctx->reqs_active) >= ctx->ring_info.nr)
+	if (atomic_read(&ctx->reqs_active) >= ctx->nr)
 		return NULL;
 
-	if (atomic_inc_return(&ctx->reqs_active) > ctx->ring_info.nr)
+	if (atomic_inc_return(&ctx->reqs_active) > ctx->nr)
 		goto out_put;
 
 	req = kmem_cache_alloc(kiocb_cachep, GFP_KERNEL|__GFP_ZERO);
@@ -539,7 +537,6 @@ static struct kioctx *lookup_ioctx(unsigned long ctx_id)
 void aio_complete(struct kiocb *iocb, long res, long res2)
 {
 	struct kioctx	*ctx = iocb->ki_ctx;
-	struct aio_ring_info	*info;
 	struct aio_ring	*ring;
 	struct io_event	*event;
 	unsigned long	flags;
@@ -560,8 +557,6 @@ void aio_complete(struct kiocb *iocb, long res, long res2)
 		return;
 	}
 
-	info = &ctx->ring_info;
-
 	/*
 	 * Take rcu_read_lock() in case the kioctx is being destroyed, as we
 	 * need to issue a wakeup after decrementing reqs_active.
@@ -593,11 +588,11 @@ void aio_complete(struct kiocb *iocb, long res, long res2)
 	 */
 	spin_lock_irqsave(&ctx->completion_lock, flags);
 
-	ring = kmap_atomic(info->ring_pages[0]);
+	ring = kmap_atomic(ctx->ring_pages[0]);
 
-	tail = info->tail;
-	event = aio_ring_event(info, tail);
-	if (++tail >= info->nr)
+	tail = ctx->tail;
+	event = aio_ring_event(ctx, tail);
+	if (++tail >= ctx->nr)
 		tail = 0;
 
 	event->obj = (u64)(unsigned long)iocb->ki_obj.user;
@@ -614,7 +609,7 @@ void aio_complete(struct kiocb *iocb, long res, long res2)
 	 */
 	smp_wmb();	/* make event visible before updating tail */
 
-	info->tail = tail;
+	ctx->tail = tail;
 	ring->tail = tail;
 
 	put_aio_ring_event(event);
@@ -658,25 +653,24 @@ EXPORT_SYMBOL(aio_complete);
 static int aio_read_events(struct kioctx *ctx, struct io_event __user *event,
 			   long nr)
 {
-	struct aio_ring_info *info = &ctx->ring_info;
 	struct aio_ring *ring;
 	unsigned head, pos;
 	int ret = 0, copy_ret;
 
-	mutex_lock(&info->ring_lock);
+	mutex_lock(&ctx->ring_lock);
 
-	ring = kmap_atomic(info->ring_pages[0]);
+	ring = kmap_atomic(ctx->ring_pages[0]);
 	head = ring->head;
 	kunmap_atomic(ring);
 
-	pr_debug("h%u t%u m%u\n", head, info->tail, info->nr);
+	pr_debug("h%u t%u m%u\n", head, ctx->tail, ctx->nr);
 
 	while (ret < nr) {
-		unsigned i = (head < info->tail ? info->tail : info->nr) - head;
+		unsigned i = (head < ctx->tail ? ctx->tail : ctx->nr) - head;
 		struct io_event *ev;
 		struct page *page;
 
-		if (head == info->tail)
+		if (head == ctx->tail)
 			break;
 
 		i = min_t(int, i, nr - ret);
@@ -684,7 +678,7 @@ static int aio_read_events(struct kioctx *ctx, struct io_event __user *event,
 			  ((head + AIO_EVENTS_OFFSET) % AIO_EVENTS_PER_PAGE));
 
 		pos = head + AIO_EVENTS_OFFSET;
-		page = info->ring_pages[pos / AIO_EVENTS_PER_PAGE];
+		page = ctx->ring_pages[pos / AIO_EVENTS_PER_PAGE];
 		pos %= AIO_EVENTS_PER_PAGE;
 
 		ev = kmap(page);
@@ -698,20 +692,20 @@ static int aio_read_events(struct kioctx *ctx, struct io_event __user *event,
 
 		ret += i;
 		head += i;
-		head %= info->nr;
+		head %= ctx->nr;
 	}
 
 	smp_mb(); /* finish reading the event before updatng the head */
 
-	ring = kmap_atomic(info->ring_pages[0]);
+	ring = kmap_atomic(ctx->ring_pages[0]);
 	ring->head = head;
 	kunmap_atomic(ring);
 
 	atomic_sub(ret, &ctx->reqs_active);
 
-	pr_debug("%d  h%u t%u\n", ret, head, info->tail);
+	pr_debug("%d  h%u t%u\n", ret, head, ctx->tail);
 out:
-	mutex_unlock(&info->ring_lock);
+	mutex_unlock(&ctx->ring_lock);
 
 	return ret;
 }
-- 
1.7.12

