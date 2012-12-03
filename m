Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753117Ab2LCVAn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 16:00:43 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:52188 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752915Ab2LCU7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 15:59:50 -0500
From: Kent Overstreet <koverstreet@google.com>
To: linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org
Cc: zab@redhat.com, bcrl@kvack.org, jmoyer@redhat.com, axboe@kernel.dk,
        viro@zeniv.linux.org.uk, Kent Overstreet <koverstreet@google.com>
Subject: [PATCH 25/26] aio: use xchg() instead of completion_lock
Date: Mon,  3 Dec 2012 12:58:41 -0800
Message-Id: <1354568322-29029-26-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1354568322-29029-1-git-send-email-koverstreet@google.com>
References: <1354568322-29029-1-git-send-email-koverstreet@google.com>
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
 fs/aio.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index 931606b..f44f21d 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -101,11 +101,11 @@ struct kioctx {
 
 	struct {
 		struct mutex	ring_lock;
+		unsigned	shadow_tail;
 	} ____cacheline_aligned;
 
 	struct {
 		unsigned	tail;
-		spinlock_t	completion_lock;
 	} ____cacheline_aligned;
 
 	struct {
@@ -311,9 +311,9 @@ static void free_ioctx(struct kioctx *ctx)
 	kunmap_atomic(ring);
 
 	while (atomic_read(&ctx->reqs_available) < ctx->nr) {
-		wait_event(ctx->wait, head != ctx->tail);
+		wait_event(ctx->wait, head != ctx->shadow_tail);
 
-		avail = (head < ctx->tail ? ctx->tail : ctx->nr) - head;
+		avail = (head < ctx->shadow_tail ? ctx->shadow_tail : ctx->nr) - head;
 
 		atomic_add(avail, &ctx->reqs_available);
 		head += avail;
@@ -378,7 +378,6 @@ static struct kioctx *ioctx_alloc(unsigned nr_events)
 	rcu_read_unlock();
 
 	spin_lock_init(&ctx->ctx_lock);
-	spin_lock_init(&ctx->completion_lock);
 	mutex_init(&ctx->ring_lock);
 	init_waitqueue_head(&ctx->wait);
 
@@ -686,9 +685,10 @@ void aio_complete(struct kiocb *iocb, long res, long res2)
 	 * ctx->ctx_lock to prevent other code from messing with the tail
 	 * pointer since we might be called from irq context.
 	 */
-	spin_lock_irqsave(&ctx->completion_lock, flags);
+	local_irq_save(flags);
+	while ((tail = xchg(&ctx->tail, UINT_MAX)) == UINT_MAX)
+		cpu_relax();
 
-	tail = ctx->tail;
 	pos = tail + AIO_EVENTS_OFFSET;
 
 	if (++tail >= ctx->nr)
@@ -714,14 +714,16 @@ void aio_complete(struct kiocb *iocb, long res, long res2)
 	 */
 	smp_wmb();	/* make event visible before updating tail */
 
-	ctx->tail = tail;
+	ctx->shadow_tail = tail;
 
 	ring = kmap_atomic(ctx->ring_pages[0]);
 	ring->tail = tail;
 	kunmap_atomic(ring);
 	flush_dcache_page(ctx->ring_pages[0]);
 
-	spin_unlock_irqrestore(&ctx->completion_lock, flags);
+	smp_wmb();
+	ctx->tail = tail;
+	local_irq_restore(flags);
 
 	pr_debug("added to ring %p at [%u]\n", iocb, tail);
 
@@ -766,11 +768,11 @@ static int aio_read_events(struct kioctx *ctx, struct io_event __user *event,
 	pr_debug("h%u t%u m%u\n", *head, ctx->tail, ctx->nr);
 
 	while (ret < nr) {
-		unsigned i = (*head < ctx->tail ? ctx->tail : ctx->nr) - *head;
+		unsigned i = (*head < ctx->shadow_tail ? ctx->shadow_tail : ctx->nr) - *head;
 		struct io_event *ev;
 		struct page *page;
 
-		if (*head == ctx->tail)
+		if (*head == ctx->shadow_tail)
 			break;
 
 		i = min_t(int, i, nr - ret);
@@ -860,7 +862,7 @@ retry:
 		prepare_to_wait_exclusive(&ctx->wait, &wait,
 					  TASK_INTERRUPTIBLE);
 
-		if (head != ctx->tail) {
+		if (head != ctx->shadow_tail) {
 			__set_current_state(TASK_RUNNING);
 			goto retry;
 		}
-- 
1.7.12

