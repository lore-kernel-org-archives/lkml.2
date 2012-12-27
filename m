Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752265Ab2L0CDs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2012 21:03:48 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:51137 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752070Ab2L0CA6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2012 21:00:58 -0500
From: Kent Overstreet <koverstreet@google.com>
To: linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org
Cc: Kent Overstreet <koverstreet@google.com>, zab@redhat.com, bcrl@kvack.org,
        jmoyer@redhat.com, axboe@kernel.dk, viro@zeniv.linux.org.uk,
        tytso@mit.edu
Subject: [PATCH 25/32] aio: use xchg() instead of completion_lock
Date: Wed, 26 Dec 2012 18:00:04 -0800
Message-Id: <1356573611-18590-28-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1356573611-18590-1-git-send-email-koverstreet@google.com>
References: <1356573611-18590-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So, for sticking kiocb completions on the kioctx ringbuffer, we need a
lock - it unfortunately can't be lockless.

When the kioctx is shared between threads on different cpus and the rate
of completions is high, this lock sees quite a bit of contention - in
terms of cacheline contention it's the hottest thing in the aio
subsystem.

That means, with a regular spinlock, we're going to take a cache miss
to grab the lock, then another cache miss when we touch the data the
lock protects - if it's on the same cacheline as the lock, other cpus
spinning on the lock are going to be pulling it out from under us as
we're using it.

So, we use an old trick to get rid of this second forced cache miss -
make the data the lock protects be the lock itself, so we grab them both
at once.

Signed-off-by: Kent Overstreet <koverstreet@google.com>
---
 fs/aio.c | 44 ++++++++++++++++++++------------------------
 1 file changed, 20 insertions(+), 24 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index b26ad5c..fcd1f38 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -102,11 +102,11 @@ struct kioctx {
 	struct {
 		struct mutex	ring_lock;
 		wait_queue_head_t wait;
+		unsigned	shadow_tail;
 	} ____cacheline_aligned_in_smp;
 
 	struct {
 		unsigned	tail;
-		spinlock_t	completion_lock;
 	} ____cacheline_aligned_in_smp;
 
 	struct page		*internal_pages[AIO_RING_PAGES];
@@ -308,9 +308,9 @@ static void free_ioctx(struct kioctx *ctx)
 	kunmap_atomic(ring);
 
 	while (atomic_read(&ctx->reqs_available) < ctx->nr) {
-		wait_event(ctx->wait, head != ctx->tail);
+		wait_event(ctx->wait, head != ctx->shadow_tail);
 
-		avail = (head < ctx->tail ? ctx->tail : ctx->nr) - head;
+		avail = (head < ctx->shadow_tail ? ctx->shadow_tail : ctx->nr) - head;
 
 		atomic_add(avail, &ctx->reqs_available);
 		head += avail;
@@ -375,7 +375,6 @@ static struct kioctx *ioctx_alloc(unsigned nr_events)
 	rcu_read_unlock();
 
 	spin_lock_init(&ctx->ctx_lock);
-	spin_lock_init(&ctx->completion_lock);
 	mutex_init(&ctx->ring_lock);
 	init_waitqueue_head(&ctx->wait);
 
@@ -673,18 +672,19 @@ void aio_complete(struct kiocb *iocb, long res, long res2)
 		 * free_ioctx()
 		 */
 		atomic_inc(&ctx->reqs_available);
+		smp_mb__after_atomic_inc();
 		/* Still need the wake_up in case free_ioctx is waiting */
 		goto put_rq;
 	}
 
 	/*
-	 * Add a completion event to the ring buffer. Must be done holding
-	 * ctx->ctx_lock to prevent other code from messing with the tail
-	 * pointer since we might be called from irq context.
+	 * Add a completion event to the ring buffer; ctx->tail is both our lock
+	 * and the canonical version of the tail pointer.
 	 */
-	spin_lock_irqsave(&ctx->completion_lock, flags);
+	local_irq_save(flags);
+	while ((tail = xchg(&ctx->tail, UINT_MAX)) == UINT_MAX)
+		cpu_relax();
 
-	tail = ctx->tail;
 	pos = tail + AIO_EVENTS_OFFSET;
 
 	if (++tail >= ctx->nr)
@@ -710,14 +710,18 @@ void aio_complete(struct kiocb *iocb, long res, long res2)
 	 */
 	smp_wmb();	/* make event visible before updating tail */
 
-	ctx->tail = tail;
+	ctx->shadow_tail = tail;
 
 	ring = kmap_atomic(ctx->ring_pages[0]);
 	ring->tail = tail;
 	kunmap_atomic(ring);
 	flush_dcache_page(ctx->ring_pages[0]);
 
-	spin_unlock_irqrestore(&ctx->completion_lock, flags);
+	/* unlock, make new tail visible before checking waitlist */
+	smp_mb();
+
+	ctx->tail = tail;
+	local_irq_restore(flags);
 
 	pr_debug("added to ring %p at [%u]\n", iocb, tail);
 
@@ -733,14 +737,6 @@ put_rq:
 	/* everything turned out well, dispose of the aiocb. */
 	aio_put_req(iocb);
 
-	/*
-	 * We have to order our ring_info tail store above and test
-	 * of the wait list below outside the wait lock.  This is
-	 * like in wake_up_bit() where clearing a bit has to be
-	 * ordered with the unlocked test.
-	 */
-	smp_mb();
-
 	if (waitqueue_active(&ctx->wait))
 		wake_up(&ctx->wait);
 
@@ -768,19 +764,19 @@ static int aio_read_events_ring(struct kioctx *ctx,
 	head = ring->head;
 	kunmap_atomic(ring);
 
-	pr_debug("h%u t%u m%u\n", head, ctx->tail, ctx->nr);
+	pr_debug("h%u t%u m%u\n", head, ctx->shadow_tail, ctx->nr);
 
-	if (head == ctx->tail)
+	if (head == ctx->shadow_tail)
 		goto out;
 
 	__set_current_state(TASK_RUNNING);
 
 	while (ret < nr) {
-		unsigned i = (head < ctx->tail ? ctx->tail : ctx->nr) - head;
+		unsigned i = (head < ctx->shadow_tail ? ctx->shadow_tail : ctx->nr) - head;
 		struct io_event *ev;
 		struct page *page;
 
-		if (head == ctx->tail)
+		if (head == ctx->shadow_tail)
 			break;
 
 		i = min_t(int, i, nr - ret);
@@ -810,7 +806,7 @@ static int aio_read_events_ring(struct kioctx *ctx,
 	kunmap_atomic(ring);
 	flush_dcache_page(ctx->ring_pages[0]);
 
-	pr_debug("%d  h%u t%u\n", ret, head, ctx->tail);
+	pr_debug("%d  h%u t%u\n", ret, head, ctx->shadow_tail);
 
 	put_reqs_available(ctx, ret);
 out:
-- 
1.7.12

