Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753131Ab2LCVCG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 16:02:06 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59390 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752801Ab2LCU7n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 15:59:43 -0500
From: Kent Overstreet <koverstreet@google.com>
To: linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org
Cc: zab@redhat.com, bcrl@kvack.org, jmoyer@redhat.com, axboe@kernel.dk,
        viro@zeniv.linux.org.uk, Kent Overstreet <koverstreet@google.com>
Subject: [PATCH 22/26] aio: percpu reqs_available
Date: Mon,  3 Dec 2012 12:58:38 -0800
Message-Id: <1354568322-29029-23-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1354568322-29029-1-git-send-email-koverstreet@google.com>
References: <1354568322-29029-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

See the previous patch for why we want to do this - this basically
implements a per cpu allocator for reqs_available that doesn't actually
allocate anything.

Note that we need to increase the size of the ringbuffer we allocate,
since a single thread won't necessarily be able to use all the
reqs_available slots - some (up to about half) might be on other per cpu
lists, unavailable for the current thread.

We size the ringbuffer based on the nr_events userspace passed to
io_setup(), so this is a slight behaviour change - but nr_events wasn't
being used as a hard limit before, it was being rounded up to the next
page before so this doesn't change the actual semantics.

Signed-off-by: Kent Overstreet <koverstreet@google.com>
---
 fs/aio.c | 99 +++++++++++++++++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 86 insertions(+), 13 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index 182aa21..bde360d 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -26,6 +26,7 @@
 #include <linux/mm.h>
 #include <linux/mman.h>
 #include <linux/mmu_context.h>
+#include <linux/percpu.h>
 #include <linux/slab.h>
 #include <linux/timer.h>
 #include <linux/aio.h>
@@ -59,6 +60,10 @@ struct aio_ring {
 
 #define AIO_RING_PAGES	8
 
+struct kioctx_cpu {
+	unsigned		reqs_available;
+};
+
 struct kioctx {
 	atomic_t		users;
 	atomic_t		dead;
@@ -67,6 +72,10 @@ struct kioctx {
 	unsigned long		user_id;
 	struct hlist_node	list;
 
+	struct __percpu kioctx_cpu *cpu;
+
+	unsigned		req_batch;
+
 	unsigned		nr;
 
 	/* sys_io_setup currently limits this to an unsigned int */
@@ -152,6 +161,9 @@ static int aio_setup_ring(struct kioctx *ctx)
 	unsigned long size;
 	int nr_pages;
 
+	nr_events = max(nr_events, num_possible_cpus() * 4);
+	nr_events *= 2;
+
 	/* Compensate for the ring buffer's head/tail overlap entry */
 	nr_events += 2;	/* 1 is required, 2 for good luck */
 
@@ -258,6 +270,8 @@ static int kiocb_cancel(struct kioctx *ctx, struct kiocb *kiocb,
 static void free_ioctx_rcu(struct rcu_head *head)
 {
 	struct kioctx *ctx = container_of(head, struct kioctx, rcu_head);
+
+	free_percpu(ctx->cpu);
 	kmem_cache_free(kioctx_cachep, ctx);
 }
 
@@ -271,7 +285,7 @@ static void free_ioctx(struct kioctx *ctx)
 	struct aio_ring *ring;
 	struct io_event res;
 	struct kiocb *iocb;
-	unsigned head, avail;
+	unsigned cpu, head, avail;
 
 	spin_lock_irq(&ctx->ctx_lock);
 
@@ -285,6 +299,13 @@ static void free_ioctx(struct kioctx *ctx)
 
 	spin_unlock_irq(&ctx->ctx_lock);
 
+	for_each_possible_cpu(cpu) {
+		struct kioctx_cpu *kcpu = per_cpu_ptr(ctx->cpu, cpu);
+
+		atomic_add(kcpu->reqs_available, &ctx->reqs_available);
+		kcpu->reqs_available = 0;
+	}
+
 	ring = kmap_atomic(ctx->ring_pages[0]);
 	head = ring->head;
 	kunmap_atomic(ring);
@@ -360,10 +381,16 @@ static struct kioctx *ioctx_alloc(unsigned nr_events)
 
 	INIT_LIST_HEAD(&ctx->active_reqs);
 
-	if (aio_setup_ring(ctx) < 0)
+	ctx->cpu = alloc_percpu(struct kioctx_cpu);
+	if (!ctx->cpu)
 		goto out_freectx;
 
+	if (aio_setup_ring(ctx) < 0)
+		goto out_freepcpu;
+
 	atomic_set(&ctx->reqs_available, ctx->nr);
+	ctx->req_batch = ctx->nr / (num_possible_cpus() * 4);
+	BUG_ON(!ctx->req_batch);
 
 	/* limit the number of system wide aios */
 	spin_lock(&aio_nr_lock);
@@ -387,6 +414,8 @@ static struct kioctx *ioctx_alloc(unsigned nr_events)
 out_cleanup:
 	err = -EAGAIN;
 	aio_free_ring(ctx);
+out_freepcpu:
+	free_percpu(ctx->cpu);
 out_freectx:
 	kmem_cache_free(kioctx_cachep, ctx);
 	pr_debug("error allocating ioctx %d\n", err);
@@ -485,6 +514,52 @@ void exit_aio(struct mm_struct *mm)
 	}
 }
 
+static void put_reqs_available(struct kioctx *ctx, unsigned nr)
+{
+	struct kioctx_cpu *kcpu;
+
+	preempt_disable();
+	kcpu = this_cpu_ptr(ctx->cpu);
+
+	kcpu->reqs_available += nr;
+	while (kcpu->reqs_available >= ctx->req_batch * 2) {
+		kcpu->reqs_available -= ctx->req_batch;
+		atomic_add(ctx->req_batch, &ctx->reqs_available);
+	}
+
+	preempt_enable();
+}
+
+static bool get_reqs_available(struct kioctx *ctx)
+{
+	struct kioctx_cpu *kcpu;
+	bool ret = false;
+
+	preempt_disable();
+	kcpu = this_cpu_ptr(ctx->cpu);
+
+	if (!kcpu->reqs_available) {
+		int old, avail = atomic_read(&ctx->reqs_available);
+
+		do {
+			if (avail < ctx->req_batch)
+				goto out;
+
+			old = avail;
+			avail = atomic_cmpxchg(&ctx->reqs_available,
+					       avail, avail - ctx->req_batch);
+		} while (avail != old);
+
+		kcpu->reqs_available += ctx->req_batch;
+	}
+
+	ret = true;
+	kcpu->reqs_available--;
+out:
+	preempt_enable();
+	return ret;
+}
+
 /* aio_get_req
  *	Allocate a slot for an aio request.  Increments the ki_users count
  * of the kioctx so that the kioctx stays around until all requests are
@@ -499,7 +574,7 @@ static inline struct kiocb *aio_get_req(struct kioctx *ctx)
 {
 	struct kiocb *req;
 
-	if (atomic_dec_if_positive(&ctx->reqs_available) <= 0)
+	if (!get_reqs_available(ctx))
 		return NULL;
 
 	req = kmem_cache_alloc(kiocb_cachep, GFP_KERNEL|__GFP_ZERO);
@@ -508,10 +583,9 @@ static inline struct kiocb *aio_get_req(struct kioctx *ctx)
 
 	atomic_set(&req->ki_users, 2);
 	req->ki_ctx = ctx;
-
 	return req;
 out_put:
-	atomic_inc(&ctx->reqs_available);
+	put_reqs_available(ctx, 1);
 	return NULL;
 }
 
@@ -601,6 +675,10 @@ void aio_complete(struct kiocb *iocb, long res, long res2)
 	 * when the event got cancelled.
 	 */
 	if (xchg(&iocb->ki_cancel, KIOCB_CANCELLED) == KIOCB_CANCELLED) {
+		/*
+		 * Can't use the percpu reqs_available here - could race with
+		 * free_ioctx()
+		 */
 		atomic_inc(&ctx->reqs_available);
 		/* Still need the wake_up in case free_ioctx is waiting */
 		goto put_rq;
@@ -725,7 +803,7 @@ static int aio_read_events(struct kioctx *ctx, struct io_event __user *event,
 	kunmap_atomic(ring);
 	flush_dcache_page(ctx->ring_pages[0]);
 
-	atomic_add(ret, &ctx->reqs_available);
+	put_reqs_available(ctx, ret);
 
 	pr_debug("%d  h%u t%u\n", ret, *head, ctx->tail);
 
@@ -791,12 +869,7 @@ retry:
 		}
 
 		mutex_unlock(&ctx->ring_lock);
-
-		/* Try to only show up in io wait if there are ops in flight */
-		if (atomic_read(&ctx->reqs_available) != ctx->nr)
-			io_schedule();
-		else
-			schedule();
+		io_schedule();
 
 		if (signal_pending(current)) {
 			ret = -EINTR;
@@ -1185,7 +1258,7 @@ static int io_submit_one(struct kioctx *ctx, struct iocb __user *user_iocb,
 	return 0;
 
 out_put_req:
-	atomic_inc(&ctx->reqs_available);
+	put_reqs_available(ctx, 1);
 	aio_put_req(req);	/* drop extra ref to req */
 	aio_put_req(req);	/* drop i/o ref to req */
 	return ret;
-- 
1.7.12

