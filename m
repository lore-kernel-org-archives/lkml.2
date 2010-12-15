Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759284Ab0LODIm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 22:08:42 -0500
Received: from mail-vw0-f52.google.com ([209.85.212.52]:35920 "EHLO
	mail-vw0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753610Ab0LODIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 22:08:40 -0500
X-Greylist: delayed 317 seconds by postgrey-1.27 at vger.kernel.org; Tue, 14 Dec 2010 22:08:40 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=cH8/NUhlsERt6k/1o1rYx3m7+3T/9rscXMNsayf8LAd4UVeuPA564MausGBBb1HIJb
         3uo2AxGpUpj9HB8fPIm7K4RidqpucQCmATsoF2e+mletgk9/8+iOd5BSK0qm+bMzOaB6
         uFk6AUaI81VyS+KZfvTZ8/QIdmZ+yEhH206hs=
Message-ID: <4D082FE9.7080407@gmail.com>
Date: Wed, 15 Dec 2010 11:03:05 +0800
From: Li Yu <raise.sail@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); zh-CN; rv:1.9.2.13) Gecko/20101207 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: bcrl@kvack.org
CC: viro@zeniv.linux.org.uk, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] aio: using hash table for active requests
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch remove a TODO in fs/aio.c, that is to use hash table for active requests.

I prefer add an iocb at tail of collision chain, so I do not use hlist here.

Signed-off-by: Li Yu <raise.sail@gmail.com>
---

 fs/aio.c            |   90 ++++++++++++++++++++++++++++++++++++++--------------
 include/linux/aio.h |    2 -
 2 files changed, 68 insertions(+), 24 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index 8c8f6c5..fee2aa3 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -65,6 +65,15 @@ static DECLARE_WORK(fput_work, aio_fput_routine);
 static DEFINE_SPINLOCK(fput_lock);
 static LIST_HEAD(fput_head);
 
+#if BITS_PER_LONG == 64
+#define AIO_ACTREQ_BUCKETS_SHIFT	36
+#elif BITS_PER_LONG == 32
+#define AIO_ACTREQ_BUCKETS_SHIFT        24
+#endif
+
+/* AIO_ACTREQ_BUCKETS must be power of 2 */
+#define AIO_ACTREQ_BUCKETS	(2*PAGE_SIZE/sizeof(struct list_head))
+
 #define AIO_BATCH_HASH_BITS	3 /* allocated on-stack, so don't go crazy */
 #define AIO_BATCH_HASH_SIZE	(1 << AIO_BATCH_HASH_BITS)
 struct aio_batch_entry {
@@ -212,6 +221,9 @@ static void ctx_rcu_free(struct rcu_head *head)
 	struct kioctx *ctx = container_of(head, struct kioctx, rcu_head);
 	unsigned nr_events = ctx->max_reqs;
 
+	kfree(ctx->active_reqs_table);
+	ctx->active_reqs_table = NULL;
+
 	kmem_cache_free(kioctx_cachep, ctx);
 
 	if (nr_events) {
@@ -249,6 +261,19 @@ static void __put_ioctx(struct kioctx *ctx)
 		__put_ioctx(kioctx);					\
 } while (0)
 
+static int ioctx_active_reqs_init(struct kioctx *ctx)
+{
+	int i;
+
+	ctx->active_reqs_table = kmalloc(AIO_ACTREQ_BUCKETS*sizeof(struct list_head), GFP_KERNEL);
+	if (!ctx->active_reqs_table)
+		return 1;
+	/* we want to use list_add_tail(), hlist does not provide this API so far ... */
+	for (i = 0; i < AIO_ACTREQ_BUCKETS; ++i)
+		INIT_LIST_HEAD(ctx->active_reqs_table+i);
+	return 0;
+}
+
 /* ioctx_alloc
  *	Allocates and initializes an ioctx.  Returns an ERR_PTR if it failed.
  */
@@ -281,7 +306,8 @@ static struct kioctx *ioctx_alloc(unsigned nr_events)
 	spin_lock_init(&ctx->ring_info.ring_lock);
 	init_waitqueue_head(&ctx->wait);
 
-	INIT_LIST_HEAD(&ctx->active_reqs);
+	if (ioctx_active_reqs_init(ctx))
+		goto out_freectx;
 	INIT_LIST_HEAD(&ctx->run_list);
 	INIT_DELAYED_WORK(&ctx->wq, aio_kick_handler);
 
@@ -331,6 +357,21 @@ out_freectx:
 	return ctx;
 }
 
+static inline void aio_cancel_one(struct kioctx *ctx, struct kiocb *iocb)
+{
+	int (*cancel)(struct kiocb *, struct io_event *);
+	struct io_event res;
+
+	cancel = iocb->ki_cancel;
+	kiocbSetCancelled(iocb);
+	if (cancel) {
+		iocb->ki_users++;
+		spin_unlock_irq(&ctx->ctx_lock);
+		cancel(iocb, &res);
+		spin_lock_irq(&ctx->ctx_lock);
+	}
+}
+
 /* aio_cancel_all
  *	Cancels all outstanding aio requests on an aio context.  Used 
  *	when the processes owning a context have all exited to encourage 
@@ -338,22 +379,21 @@ out_freectx:
  */
 static void aio_cancel_all(struct kioctx *ctx)
 {
-	int (*cancel)(struct kiocb *, struct io_event *);
-	struct io_event res;
+	int i, cleaned;
+	i = cleaned = 0;
+
 	spin_lock_irq(&ctx->ctx_lock);
 	ctx->dead = 1;
-	while (!list_empty(&ctx->active_reqs)) {
-		struct list_head *pos = ctx->active_reqs.next;
-		struct kiocb *iocb = list_kiocb(pos);
-		list_del_init(&iocb->ki_list);
-		cancel = iocb->ki_cancel;
-		kiocbSetCancelled(iocb);
-		if (cancel) {
-			iocb->ki_users++;
-			spin_unlock_irq(&ctx->ctx_lock);
-			cancel(iocb, &res);
-			spin_lock_irq(&ctx->ctx_lock);
+	for (; i < AIO_ACTREQ_BUCKETS; i++) {
+		while (!list_empty(&ctx->active_reqs_table[i])) {
+			struct list_head *pos = ctx->active_reqs_table[i].next;
+			struct kiocb *iocb = list_kiocb(pos);
+			list_del_init(pos);
+			aio_cancel_one(ctx, iocb);
+			++cleaned;
 		}
+		if (cleaned >= ctx->reqs_active)
+			break;
 	}
 	spin_unlock_irq(&ctx->ctx_lock);
 }
@@ -440,8 +480,9 @@ void exit_aio(struct mm_struct *mm)
  * This prevents races between the aio code path referencing the
  * req (after submitting it) and aio_complete() freeing the req.
  */
-static struct kiocb *__aio_get_req(struct kioctx *ctx)
+static struct kiocb *__aio_get_req(struct kioctx *ctx, void* tohash)
 {
+	unsigned long bucket;
 	struct kiocb *req = NULL;
 	struct aio_ring *ring;
 	int okay = 0;
@@ -465,10 +506,12 @@ static struct kiocb *__aio_get_req(struct kioctx *ctx)
 	/* Check if the completion queue has enough free space to
 	 * accept an event from this io.
 	 */
+	bucket = hash_long((unsigned long)tohash, AIO_ACTREQ_BUCKETS_SHIFT);
+	bucket &= (AIO_ACTREQ_BUCKETS - 1);
 	spin_lock_irq(&ctx->ctx_lock);
 	ring = kmap_atomic(ctx->ring_info.ring_pages[0], KM_USER0);
 	if (ctx->reqs_active < aio_ring_avail(&ctx->ring_info, ring)) {
-		list_add(&req->ki_list, &ctx->active_reqs);
+		list_add_tail(&req->ki_list, &ctx->active_reqs_table[bucket]);
 		ctx->reqs_active++;
 		okay = 1;
 	}
@@ -483,17 +526,17 @@ static struct kiocb *__aio_get_req(struct kioctx *ctx)
 	return req;
 }
 
-static inline struct kiocb *aio_get_req(struct kioctx *ctx)
+static inline struct kiocb *aio_get_req(struct kioctx *ctx, void *iocb)
 {
 	struct kiocb *req;
 	/* Handle a potential starvation case -- should be exceedingly rare as 
 	 * requests will be stuck on fput_head only if the aio_fput_routine is 
 	 * delayed and the requests were the last user of the struct file.
 	 */
-	req = __aio_get_req(ctx);
+	req = __aio_get_req(ctx, iocb);
 	if (unlikely(NULL == req)) {
 		aio_fput_routine(NULL);
-		req = __aio_get_req(ctx);
+		req = __aio_get_req(ctx, iocb);
 	}
 	return req;
 }
@@ -1605,7 +1648,7 @@ static int io_submit_one(struct kioctx *ctx, struct iocb __user *user_iocb,
 	if (unlikely(!file))
 		return -EBADF;
 
-	req = aio_get_req(ctx);		/* returns with 2 references to req */
+	req = aio_get_req(ctx, user_iocb);		/* returns with 2 references to req */
 	if (unlikely(!req)) {
 		fput(file);
 		return -EAGAIN;
@@ -1744,11 +1787,12 @@ static struct kiocb *lookup_kiocb(struct kioctx *ctx, struct iocb __user *iocb,
 				  u32 key)
 {
 	struct list_head *pos;
+	unsigned long bucket;
 
 	assert_spin_locked(&ctx->ctx_lock);
-
-	/* TODO: use a hash or array, this sucks. */
-	list_for_each(pos, &ctx->active_reqs) {
+	bucket = hash_long((unsigned long)iocb, AIO_ACTREQ_BUCKETS_SHIFT);
+	bucket &= (AIO_ACTREQ_BUCKETS - 1);
+	list_for_each(pos, &ctx->active_reqs_table[bucket]) {
 		struct kiocb *kiocb = list_kiocb(pos);
 		if (kiocb->ki_obj.user == iocb && kiocb->ki_key == key)
 			return kiocb;
diff --git a/include/linux/aio.h b/include/linux/aio.h
index 7a8db41..1cf394b 100644
--- a/include/linux/aio.h
+++ b/include/linux/aio.h
@@ -189,7 +189,7 @@ struct kioctx {
 	spinlock_t		ctx_lock;
 
 	int			reqs_active;
-	struct list_head	active_reqs;	/* used for cancellation */
+	struct list_head*	active_reqs_table;	/* used for cancellation */
 	struct list_head	run_list;	/* used for kicked reqs */
 
 	/* sys_io_setup currently limits this to an unsigned int */
