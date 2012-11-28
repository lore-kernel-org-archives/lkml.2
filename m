Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755352Ab2K1Qsv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 11:48:51 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:34402 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755169Ab2K1QoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 11:44:21 -0500
From: Kent Overstreet <koverstreet@google.com>
To: linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org
Cc: zab@redhat.com, bcrl@kvack.org, jmoyer@redhat.com, axboe@kernel.dk,
        viro@zeniv.linux.org.uk, Kent Overstreet <koverstreet@google.com>
Subject: [PATCH 16/25] aio: Change reqs_active to include unreaped completions
Date: Wed, 28 Nov 2012 08:43:40 -0800
Message-Id: <1354121029-1376-17-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1354121029-1376-1-git-send-email-koverstreet@google.com>
References: <1354121029-1376-1-git-send-email-koverstreet@google.com>
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
index f1f2345..0d5062d 100644
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
@@ -282,7 +276,10 @@ static int kiocb_cancel(struct kioctx *ctx, struct kiocb *kiocb,
  */
 static void free_ioctx(struct kioctx *ctx)
 {
+	struct aio_ring_info *info = &ctx->ring_info;
+	struct aio_ring *ring;
 	struct io_event res;
+	unsigned head, avail;
 
 	spin_lock_irq(&ctx->ctx_lock);
 
@@ -296,7 +293,21 @@ static void free_ioctx(struct kioctx *ctx)
 
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
 
@@ -513,7 +524,6 @@ static int kiocb_batch_refill(struct kioctx *ctx, struct kiocb_batch *batch)
 	unsigned short allocated, to_alloc;
 	long avail;
 	struct kiocb *req, *n;
-	struct aio_ring *ring;
 
 	to_alloc = min(batch->count, KIOCB_BATCH_SIZE);
 	for (allocated = 0; allocated < to_alloc; allocated++) {
@@ -528,9 +538,8 @@ static int kiocb_batch_refill(struct kioctx *ctx, struct kiocb_batch *batch)
 		goto out;
 
 	spin_lock_irq(&ctx->ctx_lock);
-	ring = kmap_atomic(ctx->ring_info.ring_pages[0]);
 
-	avail = aio_ring_avail(&ctx->ring_info, ring) - atomic_read(&ctx->reqs_active);
+	avail = ctx->ring_info.nr - atomic_read(&ctx->reqs_active);
 	BUG_ON(avail < 0);
 	if (avail < allocated) {
 		/* Trim back the number of requests. */
@@ -545,7 +554,6 @@ static int kiocb_batch_refill(struct kioctx *ctx, struct kiocb_batch *batch)
 	batch->count -= allocated;
 	atomic_add(allocated, &ctx->reqs_active);
 
-	kunmap_atomic(ring);
 	spin_unlock_irq(&ctx->ctx_lock);
 
 out:
@@ -654,8 +662,11 @@ void aio_complete(struct kiocb *iocb, long res, long res2)
 	 * cancelled requests don't get events, userland was given one
 	 * when the event got cancelled.
 	 */
-	if (test_and_set_bit(KIF_CANCELLED, &iocb->ki_flags))
+	if (test_and_set_bit(KIF_CANCELLED, &iocb->ki_flags)) {
+		atomic_dec(&ctx->reqs_active);
+		/* Still need the wake_up in case free_ioctx is waiting */
 		goto put_rq;
+	}
 
 	/*
 	 * Add a completion event to the ring buffer. Must be done holding
@@ -706,7 +717,6 @@ void aio_complete(struct kiocb *iocb, long res, long res2)
 put_rq:
 	/* everything turned out well, dispose of the aiocb. */
 	aio_put_req(iocb);
-	atomic_dec(&ctx->reqs_active);
 
 	/*
 	 * We have to order our ring_info tail store above and test
@@ -779,6 +789,8 @@ static int aio_read_events(struct kioctx *ctx, struct io_event __user *event,
 	ring->head = head;
 	kunmap_atomic(ring);
 
+	atomic_sub(ret, &ctx->reqs_active);
+
 	pr_debug("%d  h%u t%u\n", ret, head, info->tail);
 out:
 	mutex_unlock(&info->ring_lock);
-- 
1.7.12

