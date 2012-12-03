Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752942Ab2LCU7u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 15:59:50 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62399 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752781Ab2LCU7k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 15:59:40 -0500
From: Kent Overstreet <koverstreet@google.com>
To: linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org
Cc: zab@redhat.com, bcrl@kvack.org, jmoyer@redhat.com, axboe@kernel.dk,
        viro@zeniv.linux.org.uk, Kent Overstreet <koverstreet@google.com>
Subject: [PATCH 19/26] aio: Kill struct aio_ring_info
Date: Mon,  3 Dec 2012 12:58:35 -0800
Message-Id: <1354568322-29029-20-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1354568322-29029-1-git-send-email-koverstreet@google.com>
References: <1354568322-29029-1-git-send-email-koverstreet@google.com>
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
 fs/aio.c | 152 ++++++++++++++++++++++++++++++---------------------------------
 1 file changed, 72 insertions(+), 80 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index 71743be..cebd8f2 100644
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
@@ -86,12 +74,27 @@ struct kioctx {
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
 
-	spinlock_t		completion_lock;
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
 
 	struct rcu_head		rcu_head;
 	struct work_struct	rcu_work;
@@ -123,26 +126,21 @@ __initcall(aio_setup);
 
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
@@ -160,42 +158,42 @@ static int aio_setup_ring(struct kioctx *ctx)
 
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
@@ -204,7 +202,7 @@ static int aio_setup_ring(struct kioctx *ctx)
 	ring->incompat_features = AIO_RING_INCOMPAT_FEATURES;
 	ring->header_length = sizeof(struct aio_ring);
 	kunmap_atomic(ring);
-	flush_dcache_page(info->ring_pages[0]);
+	flush_dcache_page(ctx->ring_pages[0]);
 
 	return 0;
 }
@@ -264,7 +262,6 @@ static void free_ioctx_rcu(struct rcu_head *head)
  */
 static void free_ioctx(struct kioctx *ctx)
 {
-	struct aio_ring_info *info = &ctx->ring_info;
 	struct aio_ring *ring;
 	struct io_event res;
 	struct kiocb *iocb;
@@ -282,18 +279,18 @@ static void free_ioctx(struct kioctx *ctx)
 
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
@@ -352,7 +349,7 @@ static struct kioctx *ioctx_alloc(unsigned nr_events)
 	atomic_set(&ctx->dead, 0);
 	spin_lock_init(&ctx->ctx_lock);
 	spin_lock_init(&ctx->completion_lock);
-	mutex_init(&ctx->ring_info.ring_lock);
+	mutex_init(&ctx->ring_lock);
 	init_waitqueue_head(&ctx->wait);
 
 	INIT_LIST_HEAD(&ctx->active_reqs);
@@ -376,7 +373,7 @@ static struct kioctx *ioctx_alloc(unsigned nr_events)
 	spin_unlock(&mm->ioctx_lock);
 
 	pr_debug("allocated ioctx %p[%ld]: mm=%p mask=0x%x\n",
-		ctx, ctx->user_id, mm, ctx->ring_info.nr);
+		 ctx, ctx->user_id, mm, ctx->nr);
 	return ctx;
 
 out_cleanup:
@@ -471,7 +468,7 @@ void exit_aio(struct mm_struct *mm)
 		 * just set it to 0; aio_free_ring() is the only
 		 * place that uses ->mmap_size, so it's safe.
 		 */
-		ctx->ring_info.mmap_size = 0;
+		ctx->mmap_size = 0;
 
 		if (!atomic_xchg(&ctx->dead, 1)) {
 			hlist_del_rcu(&ctx->list);
@@ -494,10 +491,10 @@ static inline struct kiocb *aio_get_req(struct kioctx *ctx)
 {
 	struct kiocb *req;
 
-	if (atomic_read(&ctx->reqs_active) >= ctx->ring_info.nr)
+	if (atomic_read(&ctx->reqs_active) >= ctx->nr)
 		return NULL;
 
-	if (atomic_inc_return(&ctx->reqs_active) > ctx->ring_info.nr)
+	if (atomic_inc_return(&ctx->reqs_active) > ctx->nr)
 		goto out_put;
 
 	req = kmem_cache_alloc(kiocb_cachep, GFP_KERNEL|__GFP_ZERO);
@@ -560,7 +557,6 @@ static struct kioctx *lookup_ioctx(unsigned long ctx_id)
 void aio_complete(struct kiocb *iocb, long res, long res2)
 {
 	struct kioctx	*ctx = iocb->ki_ctx;
-	struct aio_ring_info	*info;
 	struct aio_ring	*ring;
 	struct io_event	*ev_page, *event;
 	unsigned long	flags;
@@ -581,8 +577,6 @@ void aio_complete(struct kiocb *iocb, long res, long res2)
 		return;
 	}
 
-	info = &ctx->ring_info;
-
 	/*
 	 * Take rcu_read_lock() in case the kioctx is being destroyed, as we
 	 * need to issue a wakeup after decrementing reqs_active.
@@ -614,13 +608,13 @@ void aio_complete(struct kiocb *iocb, long res, long res2)
 	 */
 	spin_lock_irqsave(&ctx->completion_lock, flags);
 
-	tail = info->tail;
+	tail = ctx->tail;
 	pos = tail + AIO_EVENTS_OFFSET;
 
-	if (++tail >= info->nr)
+	if (++tail >= ctx->nr)
 		tail = 0;
 
-	ev_page = kmap_atomic(info->ring_pages[pos / AIO_EVENTS_PER_PAGE]);
+	ev_page = kmap_atomic(ctx->ring_pages[pos / AIO_EVENTS_PER_PAGE]);
 	event = ev_page + pos % AIO_EVENTS_PER_PAGE;
 
 	event->obj = (u64)(unsigned long)iocb->ki_obj.user;
@@ -629,7 +623,7 @@ void aio_complete(struct kiocb *iocb, long res, long res2)
 	event->res2 = res2;
 
 	kunmap_atomic(ev_page);
-	flush_dcache_page(info->ring_pages[pos / AIO_EVENTS_PER_PAGE]);
+	flush_dcache_page(ctx->ring_pages[pos / AIO_EVENTS_PER_PAGE]);
 
 	pr_debug("%p[%u]: %p: %p %Lx %lx %lx\n",
 		 ctx, tail, iocb, iocb->ki_obj.user, iocb->ki_user_data,
@@ -640,12 +634,12 @@ void aio_complete(struct kiocb *iocb, long res, long res2)
 	 */
 	smp_wmb();	/* make event visible before updating tail */
 
-	info->tail = tail;
+	ctx->tail = tail;
 
-	ring = kmap_atomic(info->ring_pages[0]);
+	ring = kmap_atomic(ctx->ring_pages[0]);
 	ring->tail = tail;
 	kunmap_atomic(ring);
-	flush_dcache_page(info->ring_pages[0]);
+	flush_dcache_page(ctx->ring_pages[0]);
 
 	spin_unlock_irqrestore(&ctx->completion_lock, flags);
 
@@ -685,19 +679,18 @@ EXPORT_SYMBOL(aio_complete);
 static int aio_read_events(struct kioctx *ctx, struct io_event __user *event,
 			   long nr, unsigned *head)
 {
-	struct aio_ring_info *info = &ctx->ring_info;
 	struct aio_ring *ring;
 	unsigned pos;
 	int ret = 0, copy_ret;
 
-	pr_debug("h%u t%u m%u\n", *head, info->tail, info->nr);
+	pr_debug("h%u t%u m%u\n", *head, ctx->tail, ctx->nr);
 
 	while (ret < nr) {
-		unsigned i = (*head < info->tail ? info->tail : info->nr) - *head;
+		unsigned i = (*head < ctx->tail ? ctx->tail : ctx->nr) - *head;
 		struct io_event *ev;
 		struct page *page;
 
-		if (*head == info->tail)
+		if (*head == ctx->tail)
 			break;
 
 		i = min_t(int, i, nr - ret);
@@ -705,7 +698,7 @@ static int aio_read_events(struct kioctx *ctx, struct io_event __user *event,
 			  ((*head + AIO_EVENTS_OFFSET) % AIO_EVENTS_PER_PAGE));
 
 		pos = *head + AIO_EVENTS_OFFSET;
-		page = info->ring_pages[pos / AIO_EVENTS_PER_PAGE];
+		page = ctx->ring_pages[pos / AIO_EVENTS_PER_PAGE];
 		pos %= AIO_EVENTS_PER_PAGE;
 
 		ev = kmap(page);
@@ -717,19 +710,19 @@ static int aio_read_events(struct kioctx *ctx, struct io_event __user *event,
 
 		ret += i;
 		*head += i;
-		*head %= info->nr;
+		*head %= ctx->nr;
 	}
 
 	smp_mb(); /* finish reading the event before updating the head */
 
-	ring = kmap_atomic(info->ring_pages[0]);
+	ring = kmap_atomic(ctx->ring_pages[0]);
 	ring->head = *head;
 	kunmap_atomic(ring);
-	flush_dcache_page(info->ring_pages[0]);
+	flush_dcache_page(ctx->ring_pages[0]);
 
 	atomic_sub(ret, &ctx->reqs_active);
 
-	pr_debug("%d  h%u t%u\n", ret, *head, info->tail);
+	pr_debug("%d  h%u t%u\n", ret, *head, ctx->tail);
 
 	return ret;
 }
@@ -740,7 +733,6 @@ static int read_events(struct kioctx *ctx,
 		       struct timespec __user *timeout)
 {
 	DEFINE_WAIT(wait);
-	struct aio_ring_info *info = &ctx->ring_info;
 	struct aio_ring *ring;
 	struct hrtimer_sleeper t;
 	unsigned head;
@@ -750,10 +742,10 @@ static int read_events(struct kioctx *ctx,
 	hrtimer_init_on_stack(&t.timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
 	hrtimer_init_sleeper(&t, current);
 
-	mutex_lock(&info->ring_lock);
+	mutex_lock(&ctx->ring_lock);
 
 	while (i < nr) {
-		ring = kmap_atomic(info->ring_pages[0]);
+		ring = kmap_atomic(ctx->ring_pages[0]);
 		head = ring->head;
 		kunmap_atomic(ring);
 retry:
@@ -788,12 +780,12 @@ retry:
 		prepare_to_wait_exclusive(&ctx->wait, &wait,
 					  TASK_INTERRUPTIBLE);
 
-		if (head != info->tail) {
+		if (head != ctx->tail) {
 			__set_current_state(TASK_RUNNING);
 			goto retry;
 		}
 
-		mutex_unlock(&info->ring_lock);
+		mutex_unlock(&ctx->ring_lock);
 
 		/* Try to only show up in io wait if there are ops in flight */
 		if (atomic_read(&ctx->reqs_active))
@@ -807,10 +799,10 @@ retry:
 		}
 
 		__set_current_state(TASK_RUNNING);
-		mutex_lock(&info->ring_lock);
+		mutex_lock(&ctx->ring_lock);
 	}
 
-	mutex_unlock(&info->ring_lock);
+	mutex_unlock(&ctx->ring_lock);
 out:
 	finish_wait(&ctx->wait, &wait);
 	hrtimer_cancel(&t.timer);
-- 
1.7.12

