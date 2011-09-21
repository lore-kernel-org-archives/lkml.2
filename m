Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753366Ab1IURQH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 13:16:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11815 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752194Ab1IURQF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 13:16:05 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [patch, v2] aio: allocate kiocbs in batches
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Wed, 21 Sep 2011 13:16:00 -0400
Message-ID: <x49ipol3jfz.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

In testing aio on a fast storage device, I found that the context lock
takes up a fair amount of cpu time in the I/O submission path.  The
reason is that we take it for every I/O submitted (see __aio_get_req).
Since we know how many I/Os are passed to io_submit, we can preallocate
the kiocbs in batches, reducing the number of times we take and release
the lock.  In my testing, I was able to reduce the amount of time spent
in _raw_spin_lock_irq by .56% (average of 3 runs).  The command I used
to test this was:
   aio-stress -O -o 2 -o 3 -r 8 -d 128 -b 32 -i 32 -s 16384 <dev>

I also tested the patch with various numbers of events passed to
io_submit, and I ran the xfstests aio group of tests to ensure I didn't
break anything.

Signed-off-by: Jeff Moyer <jmoyer@redhat.com>

---
Changes from rfc -> v2:
- folded in akpm's incremental patch which fixes coding style and
  variable names
- tried to clarify a comment about a starvation case
- fixed up my breaking of the handling of that starvation case
- moved from an on-stack array to a list at the suggestion of akpm


diff --git a/fs/aio.c b/fs/aio.c
index e29ec48..8229329 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -440,8 +440,6 @@ void exit_aio(struct mm_struct *mm)
 static struct kiocb *__aio_get_req(struct kioctx *ctx)
 {
 	struct kiocb *req = NULL;
-	struct aio_ring *ring;
-	int okay = 0;
 
 	req = kmem_cache_alloc(kiocb_cachep, GFP_KERNEL);
 	if (unlikely(!req))
@@ -459,39 +457,116 @@ static struct kiocb *__aio_get_req(struct kioctx *ctx)
 	INIT_LIST_HEAD(&req->ki_run_list);
 	req->ki_eventfd = NULL;
 
-	/* Check if the completion queue has enough free space to
-	 * accept an event from this io.
-	 */
+	return req;
+}
+
+/*
+ * struct kiocb's are allocated in batches to reduce the number of
+ * times the ctx lock is acquired and released.
+ */
+#define KIOCB_BATCH_SIZE	32
+struct kiocb_batch {
+	struct list_head head;
+	long total;	/* number of requests passed to sys_io_submit */
+	long allocated;	/* number of requests allocated so far */
+};
+
+static void kiocb_batch_init(struct kiocb_batch *batch, long total)
+{
+	INIT_LIST_HEAD(&batch->head);
+	batch->total = total;
+	batch->allocated = 0;
+}
+
+static void kiocb_batch_free(struct kiocb_batch *batch)
+{
+	struct kiocb *req, *n;
+
+	list_for_each_entry_safe(req, n, &batch->head, ki_batch) {
+		list_del(&req->ki_batch);
+		kmem_cache_free(kiocb_cachep, req);
+	}
+}
+
+/*
+ * Allocate a batch of kiocbs.  This avoids taking and dropping the
+ * context lock a lot during setup.
+ */
+static int kiocb_batch_refill(struct kioctx *ctx, struct kiocb_batch *batch)
+{
+	int i;
+	int to_alloc, avail;
+	bool called_fput = false;
+	struct kiocb *req, *n;
+	struct aio_ring *ring;
+
+	to_alloc = min(batch->total - batch->allocated, KIOCB_BATCH_SIZE);
+	for (i = 0; i < to_alloc; i++) {
+		req = __aio_get_req(ctx);
+		if (!req)
+			/* allocation failed, go with what we've got */
+			break;
+		list_add(&req->ki_batch, &batch->head);
+	}
+
+	if (i == 0)
+		goto out;
+
+retry:
 	spin_lock_irq(&ctx->ctx_lock);
-	ring = kmap_atomic(ctx->ring_info.ring_pages[0], KM_USER0);
-	if (ctx->reqs_active < aio_ring_avail(&ctx->ring_info, ring)) {
+	ring = kmap_atomic(ctx->ring_info.ring_pages[0]);
+
+	avail = aio_ring_avail(&ctx->ring_info, ring) - ctx->reqs_active;
+	BUG_ON(avail < 0);
+	if (avail == 0 && !called_fput) {
+		/*
+		 * Handle a potential starvation case.  It is possible that
+		 * we hold the last reference on a struct file, causing us
+		 * to delay the final fput to non-irq context.  In this case,
+		 * ctx->reqs_active is artificially high.  Calling the fput
+		 * routine here may free up a slot in the event completion
+		 * ring, allowing this allocation to succeed.
+		 */
+		spin_unlock_irq(&ctx->ctx_lock);
+		kunmap_atomic(ring);
+		aio_fput_routine(NULL);
+		called_fput = true;
+		goto retry;
+	}
+
+	if (avail < i) {
+		/* Trim back the number of requests. */
+		list_for_each_entry_safe(req, n, &batch->head, ki_batch) {
+			list_del(&req->ki_batch);
+			kmem_cache_free(kiocb_cachep, req);
+			if (--i <= avail)
+				break;
+		}
+	}
+
+	batch->allocated += i;
+	list_for_each_entry(req, &batch->head, ki_batch) {
 		list_add(&req->ki_list, &ctx->active_reqs);
 		ctx->reqs_active++;
-		okay = 1;
 	}
-	kunmap_atomic(ring, KM_USER0);
-	spin_unlock_irq(&ctx->ctx_lock);
 
-	if (!okay) {
-		kmem_cache_free(kiocb_cachep, req);
-		req = NULL;
-	}
+	kunmap_atomic(ring);
+	spin_unlock_irq(&ctx->ctx_lock);
 
-	return req;
+out:
+	return i;
 }
 
-static inline struct kiocb *aio_get_req(struct kioctx *ctx)
+static inline struct kiocb *aio_get_req(struct kioctx *ctx,
+					struct kiocb_batch *batch)
 {
 	struct kiocb *req;
-	/* Handle a potential starvation case -- should be exceedingly rare as 
-	 * requests will be stuck on fput_head only if the aio_fput_routine is 
-	 * delayed and the requests were the last user of the struct file.
-	 */
-	req = __aio_get_req(ctx);
-	if (unlikely(NULL == req)) {
-		aio_fput_routine(NULL);
-		req = __aio_get_req(ctx);
-	}
+
+	if (list_empty(&batch->head))
+		if (kiocb_batch_refill(ctx, batch) == 0)
+			return NULL;
+	req = list_first_entry(&batch->head, struct kiocb, ki_batch);
+	list_del(&req->ki_batch);
 	return req;
 }
 
@@ -1515,7 +1590,8 @@ static ssize_t aio_setup_iocb(struct kiocb *kiocb, bool compat)
 }
 
 static int io_submit_one(struct kioctx *ctx, struct iocb __user *user_iocb,
-			 struct iocb *iocb, bool compat)
+			 struct iocb *iocb, struct kiocb_batch *batch,
+			 bool compat)
 {
 	struct kiocb *req;
 	struct file *file;
@@ -1541,7 +1617,7 @@ static int io_submit_one(struct kioctx *ctx, struct iocb __user *user_iocb,
 	if (unlikely(!file))
 		return -EBADF;
 
-	req = aio_get_req(ctx);		/* returns with 2 references to req */
+	req = aio_get_req(ctx, batch);  /* returns with 2 references to req */
 	if (unlikely(!req)) {
 		fput(file);
 		return -EAGAIN;
@@ -1621,8 +1697,9 @@ long do_io_submit(aio_context_t ctx_id, long nr,
 {
 	struct kioctx *ctx;
 	long ret = 0;
-	int i;
+	int i = 0;
 	struct blk_plug plug;
+	struct kiocb_batch batch;
 
 	if (unlikely(nr < 0))
 		return -EINVAL;
@@ -1639,6 +1716,8 @@ long do_io_submit(aio_context_t ctx_id, long nr,
 		return -EINVAL;
 	}
 
+	kiocb_batch_init(&batch, nr);
+
 	blk_start_plug(&plug);
 
 	/*
@@ -1659,12 +1738,13 @@ long do_io_submit(aio_context_t ctx_id, long nr,
 			break;
 		}
 
-		ret = io_submit_one(ctx, user_iocb, &tmp, compat);
+		ret = io_submit_one(ctx, user_iocb, &tmp, &batch, compat);
 		if (ret)
 			break;
 	}
 	blk_finish_plug(&plug);
 
+	kiocb_batch_free(&batch);
 	put_ioctx(ctx);
 	return i ? i : ret;
 }
diff --git a/include/linux/aio.h b/include/linux/aio.h
index 2dcb72b..2314ad8 100644
--- a/include/linux/aio.h
+++ b/include/linux/aio.h
@@ -117,6 +117,7 @@ struct kiocb {
 
 	struct list_head	ki_list;	/* the aio core uses this
 						 * for cancellation */
+	struct list_head	ki_batch;	/* batch allocation */
 
 	/*
 	 * If the aio_resfd field of the userspace iocb is not zero,
