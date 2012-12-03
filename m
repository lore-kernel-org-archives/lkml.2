Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753148Ab2LCVCq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 16:02:46 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:45637 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752700Ab2LCU7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 15:59:37 -0500
From: Kent Overstreet <koverstreet@google.com>
To: linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org
Cc: zab@redhat.com, bcrl@kvack.org, jmoyer@redhat.com, axboe@kernel.dk,
        viro@zeniv.linux.org.uk, Kent Overstreet <koverstreet@google.com>
Subject: [PATCH 17/26] aio: Change reqs_active to include unreaped completions
Date: Mon,  3 Dec 2012 12:58:33 -0800
Message-Id: <1354568322-29029-18-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1354568322-29029-1-git-send-email-koverstreet@google.com>
References: <1354568322-29029-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The aio code tries really hard to avoid having to deal with the
completion ringbuffer overflowing. To do that, it has to keep track of
the number of outstanding kiocbs, and the number of completions
currently in the ringbuffer - and it's got to check that every time we
allocate a kiocb. Ouch.

But - we can improve this quite a bit if we just change reqs_active to
mean "number of outstanding requests and unreaped completions" - that
means kiocb allocation doesn't have to look at the ringbuffer, which is
a fairly significant win.

Signed-off-by: Kent Overstreet <koverstreet@google.com>
---
 fs/aio.c | 38 +++++++++++++++++++++++++-------------
 1 file changed, 25 insertions(+), 13 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index bd9d6cc..b505d3d 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -71,12 +71,6 @@ struct aio_ring_info {
 	struct page		*internal_pages[AIO_RING_PAGES];
 };
 
-static inline unsigned aio_ring_avail(struct aio_ring_info *info,
-					struct aio_ring *ring)
-{
-	return (ring->head + info->nr - 1 - ring->tail) % info->nr;
-}
-
 struct kioctx {
 	atomic_t		users;
 	atomic_t		dead;
@@ -270,8 +264,11 @@ static void free_ioctx_rcu(struct rcu_head *head)
  */
 static void free_ioctx(struct kioctx *ctx)
 {
+	struct aio_ring_info *info = &ctx->ring_info;
+	struct aio_ring *ring;
 	struct io_event res;
 	struct kiocb *iocb;
+	unsigned head, avail;
 
 	spin_lock_irq(&ctx->ctx_lock);
 
@@ -285,7 +282,21 @@ static void free_ioctx(struct kioctx *ctx)
 
 	spin_unlock_irq(&ctx->ctx_lock);
 
-	wait_event(ctx->wait, !atomic_read(&ctx->reqs_active));
+	ring = kmap_atomic(info->ring_pages[0]);
+	head = ring->head;
+	kunmap_atomic(ring);
+
+	while (atomic_read(&ctx->reqs_active) > 0) {
+		wait_event(ctx->wait, head != info->tail);
+
+		avail = (head < info->tail ? info->tail : info->nr) - head;
+
+		atomic_sub(avail, &ctx->reqs_active);
+		head += avail;
+		head %= info->nr;
+	}
+
+	WARN_ON(atomic_read(&ctx->reqs_active) < 0);
 
 	aio_free_ring(ctx);
 
@@ -535,7 +546,6 @@ static int kiocb_batch_refill(struct kioctx *ctx, struct kiocb_batch *batch)
 	unsigned short allocated, to_alloc;
 	long avail;
 	struct kiocb *req, *n;
-	struct aio_ring *ring;
 
 	to_alloc = min(batch->count, KIOCB_BATCH_SIZE);
 	for (allocated = 0; allocated < to_alloc; allocated++) {
@@ -550,9 +560,8 @@ static int kiocb_batch_refill(struct kioctx *ctx, struct kiocb_batch *batch)
 		goto out;
 
 	spin_lock_irq(&ctx->ctx_lock);
-	ring = kmap_atomic(ctx->ring_info.ring_pages[0]);
 
-	avail = aio_ring_avail(&ctx->ring_info, ring) - atomic_read(&ctx->reqs_active);
+	avail = ctx->ring_info.nr - atomic_read(&ctx->reqs_active);
 	BUG_ON(avail < 0);
 	if (avail < allocated) {
 		/* Trim back the number of requests. */
@@ -567,7 +576,6 @@ static int kiocb_batch_refill(struct kioctx *ctx, struct kiocb_batch *batch)
 	batch->count -= allocated;
 	atomic_add(allocated, &ctx->reqs_active);
 
-	kunmap_atomic(ring);
 	spin_unlock_irq(&ctx->ctx_lock);
 
 out:
@@ -675,8 +683,11 @@ void aio_complete(struct kiocb *iocb, long res, long res2)
 	 * cancelled requests don't get events, userland was given one
 	 * when the event got cancelled.
 	 */
-	if (xchg(&iocb->ki_cancel, KIOCB_CANCELLED) == KIOCB_CANCELLED)
+	if (xchg(&iocb->ki_cancel, KIOCB_CANCELLED) == KIOCB_CANCELLED) {
+		atomic_dec(&ctx->reqs_active);
+		/* Still need the wake_up in case free_ioctx is waiting */
 		goto put_rq;
+	}
 
 	/*
 	 * Add a completion event to the ring buffer. Must be done holding
@@ -733,7 +744,6 @@ void aio_complete(struct kiocb *iocb, long res, long res2)
 put_rq:
 	/* everything turned out well, dispose of the aiocb. */
 	aio_put_req(iocb);
-	atomic_dec(&ctx->reqs_active);
 
 	/*
 	 * We have to order our ring_info tail store above and test
@@ -799,6 +809,8 @@ static int aio_read_events(struct kioctx *ctx, struct io_event __user *event,
 	kunmap_atomic(ring);
 	flush_dcache_page(info->ring_pages[0]);
 
+	atomic_sub(ret, &ctx->reqs_active);
+
 	pr_debug("%d  h%u t%u\n", ret, *head, info->tail);
 
 	return ret;
-- 
1.7.12

