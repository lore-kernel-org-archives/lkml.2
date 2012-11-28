Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755406Ab2K1Qob (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 11:44:31 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:46348 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755338Ab2K1Qo1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 11:44:27 -0500
From: Kent Overstreet <koverstreet@google.com>
To: linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org
Cc: zab@redhat.com, bcrl@kvack.org, jmoyer@redhat.com, axboe@kernel.dk,
        viro@zeniv.linux.org.uk, Kent Overstreet <koverstreet@google.com>
Subject: [PATCH 20/25] aio: reqs_active -> reqs_available
Date: Wed, 28 Nov 2012 08:43:44 -0800
Message-Id: <1354121029-1376-21-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1354121029-1376-1-git-send-email-koverstreet@google.com>
References: <1354121029-1376-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The number of outstanding kiocbs is one of the few shared things left
that has to be touched for every kiocb - it'd be nice to make it percpu.

We can make it per cpu by treating it like an allocation problem: we
have a maximum number of kiocbs that can be outstanding (i.e. slots) -
then we just allocate and free slots, and we know how to write per cpu
allocators.

So as prep work for that, we convert reqs_active to reqs_available.

Signed-off-by: Kent Overstreet <koverstreet@google.com>
---
 fs/aio.c | 29 ++++++++++++++---------------
 1 file changed, 14 insertions(+), 15 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index 7dee3aa..e6f29dc 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -79,7 +79,7 @@ struct kioctx {
 	long			nr_pages;
 
 	struct {
-		atomic_t	reqs_active;
+		atomic_t	reqs_available;
 	} ____cacheline_aligned;
 
 	struct {
@@ -301,17 +301,17 @@ static void free_ioctx(struct kioctx *ctx)
 	head = ring->head;
 	kunmap_atomic(ring);
 
-	while (atomic_read(&ctx->reqs_active) > 0) {
+	while (atomic_read(&ctx->reqs_available) < ctx->nr) {
 		wait_event(ctx->wait, head != ctx->tail);
 
 		avail = (head < ctx->tail ? ctx->tail : ctx->nr) - head;
 
-		atomic_sub(avail, &ctx->reqs_active);
+		atomic_add(avail, &ctx->reqs_available);
 		head += avail;
 		head %= ctx->nr;
 	}
 
-	WARN_ON(atomic_read(&ctx->reqs_active) < 0);
+	WARN_ON(atomic_read(&ctx->reqs_available) > ctx->nr);
 
 	aio_free_ring(ctx);
 
@@ -368,6 +368,8 @@ static struct kioctx *ioctx_alloc(unsigned nr_events)
 	if (aio_setup_ring(ctx) < 0)
 		goto out_freectx;
 
+	atomic_set(&ctx->reqs_available, ctx->nr);
+
 	/* limit the number of system wide aios */
 	spin_lock(&aio_nr_lock);
 	if (aio_nr + nr_events > aio_max_nr ||
@@ -448,7 +450,7 @@ void exit_aio(struct mm_struct *mm)
 				"exit_aio:ioctx still alive: %d %d %d\n",
 				atomic_read(&ctx->users),
 				atomic_read(&ctx->dead),
-				atomic_read(&ctx->reqs_active));
+				atomic_read(&ctx->reqs_available));
 		/*
 		 * We don't need to bother with munmap() here -
 		 * exit_mmap(mm) is coming and it'll unmap everything.
@@ -476,12 +478,9 @@ static inline struct kiocb *aio_get_req(struct kioctx *ctx)
 {
 	struct kiocb *req;
 
-	if (atomic_read(&ctx->reqs_active) >= ctx->nr)
+	if (atomic_dec_if_positive(&ctx->reqs_available) <= 0)
 		return NULL;
 
-	if (atomic_inc_return(&ctx->reqs_active) > ctx->nr)
-		goto out_put;
-
 	req = kmem_cache_alloc(kiocb_cachep, GFP_KERNEL|__GFP_ZERO);
 	if (unlikely(!req))
 		goto out_put;
@@ -491,7 +490,7 @@ static inline struct kiocb *aio_get_req(struct kioctx *ctx)
 
 	return req;
 out_put:
-	atomic_dec(&ctx->reqs_active);
+	atomic_inc(&ctx->reqs_available);
 	return NULL;
 }
 
@@ -565,7 +564,7 @@ void aio_complete(struct kiocb *iocb, long res, long res2)
 
 	/*
 	 * Take rcu_read_lock() in case the kioctx is being destroyed, as we
-	 * need to issue a wakeup after decrementing reqs_active.
+	 * need to issue a wakeup after incrementing reqs_available.
 	 */
 	rcu_read_lock();
 
@@ -582,7 +581,7 @@ void aio_complete(struct kiocb *iocb, long res, long res2)
 	 * when the event got cancelled.
 	 */
 	if (test_and_set_bit(KIF_CANCELLED, &iocb->ki_flags)) {
-		atomic_dec(&ctx->reqs_active);
+		atomic_inc(&ctx->reqs_available);
 		/* Still need the wake_up in case free_ioctx is waiting */
 		goto put_rq;
 	}
@@ -707,7 +706,7 @@ static int aio_read_events(struct kioctx *ctx, struct io_event __user *event,
 	ring->head = head;
 	kunmap_atomic(ring);
 
-	atomic_sub(ret, &ctx->reqs_active);
+	atomic_add(ret, &ctx->reqs_available);
 
 	pr_debug("%d  h%u t%u\n", ret, head, ctx->tail);
 out:
@@ -770,7 +769,7 @@ static int read_events(struct kioctx *ctx,
 			break;
 
 		/* Try to only show up in io wait if there are ops in flight */
-		if (atomic_read(&ctx->reqs_active))
+		if (atomic_read(&ctx->reqs_available) != ctx->nr)
 			io_schedule();
 		else
 			schedule();
@@ -1161,7 +1160,7 @@ static int io_submit_one(struct kioctx *ctx, struct iocb __user *user_iocb,
 	return 0;
 
 out_put_req:
-	atomic_dec(&ctx->reqs_active);
+	atomic_inc(&ctx->reqs_available);
 	aio_put_req(req);	/* drop extra ref to req */
 	aio_put_req(req);	/* drop i/o ref to req */
 	return ret;
-- 
1.7.12

