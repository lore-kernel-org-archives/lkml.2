Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755348Ab2K1QvL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 11:51:11 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:46348 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754867Ab2K1QoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 11:44:11 -0500
From: Kent Overstreet <koverstreet@google.com>
To: linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org
Cc: zab@redhat.com, bcrl@kvack.org, jmoyer@redhat.com, axboe@kernel.dk,
        viro@zeniv.linux.org.uk, Kent Overstreet <koverstreet@google.com>
Subject: [PATCH 09/25] aio: dprintk() -> pr_debug()
Date: Wed, 28 Nov 2012 08:43:33 -0800
Message-Id: <1354121029-1376-10-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1354121029-1376-1-git-send-email-koverstreet@google.com>
References: <1354121029-1376-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Kent Overstreet <koverstreet@google.com>
---
 fs/aio.c | 57 ++++++++++++++++++++++++---------------------------------
 1 file changed, 24 insertions(+), 33 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index 4dcc02f..0ed14e8 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -8,6 +8,8 @@
  *
  *	See ../COPYING for licensing terms.
  */
+#define pr_fmt(fmt) "%s: " fmt, __func__
+
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/errno.h>
@@ -18,8 +20,6 @@
 #include <linux/backing-dev.h>
 #include <linux/uio.h>
 
-#define DEBUG 0
-
 #include <linux/sched.h>
 #include <linux/fs.h>
 #include <linux/file.h>
@@ -39,12 +39,6 @@
 #include <asm/kmap_types.h>
 #include <asm/uaccess.h>
 
-#if DEBUG > 1
-#define dprintk		printk
-#else
-#define dprintk(x...)	do { ; } while (0)
-#endif
-
 #define AIO_RING_MAGIC			0xa10a10a1
 #define AIO_RING_COMPAT_FEATURES	1
 #define AIO_RING_INCOMPAT_FEATURES	0
@@ -124,7 +118,7 @@ static int __init aio_setup(void)
 	kiocb_cachep = KMEM_CACHE(kiocb, SLAB_HWCACHE_ALIGN|SLAB_PANIC);
 	kioctx_cachep = KMEM_CACHE(kioctx,SLAB_HWCACHE_ALIGN|SLAB_PANIC);
 
-	pr_debug("aio_setup: sizeof(struct page) = %d\n", (int)sizeof(struct page));
+	pr_debug("sizeof(struct page) = %zu\n", sizeof(struct page));
 
 	return 0;
 }
@@ -178,7 +172,7 @@ static int aio_setup_ring(struct kioctx *ctx)
 	}
 
 	info->mmap_size = nr_pages * PAGE_SIZE;
-	dprintk("attempting mmap of %lu bytes\n", info->mmap_size);
+	pr_debug("attempting mmap of %lu bytes\n", info->mmap_size);
 	down_write(&mm->mmap_sem);
 	info->mmap_base = do_mmap_pgoff(NULL, 0, info->mmap_size, 
 					PROT_READ|PROT_WRITE,
@@ -190,7 +184,7 @@ static int aio_setup_ring(struct kioctx *ctx)
 		return -EAGAIN;
 	}
 
-	dprintk("mmap address: 0x%08lx\n", info->mmap_base);
+	pr_debug("mmap address: 0x%08lx\n", info->mmap_base);
 	info->nr_pages = get_user_pages(current, mm, info->mmap_base, nr_pages, 
 					1, 0, info->ring_pages, NULL);
 	up_write(&mm->mmap_sem);
@@ -262,7 +256,7 @@ static void __put_ioctx(struct kioctx *ctx)
 		aio_nr -= nr_events;
 		spin_unlock(&aio_nr_lock);
 	}
-	pr_debug("__put_ioctx: freeing %p\n", ctx);
+	pr_debug("freeing %p\n", ctx);
 	call_rcu(&ctx->rcu_head, ctx_rcu_free);
 }
 
@@ -351,7 +345,7 @@ static struct kioctx *ioctx_alloc(unsigned nr_events)
 	hlist_add_head_rcu(&ctx->list, &mm->ioctx_list);
 	spin_unlock(&mm->ioctx_lock);
 
-	dprintk("aio: allocated ioctx %p[%ld]: mm=%p mask=0x%x\n",
+	pr_debug("allocated ioctx %p[%ld]: mm=%p mask=0x%x\n",
 		ctx, ctx->user_id, mm, ctx->ring_info.nr);
 	return ctx;
 
@@ -360,7 +354,7 @@ out_cleanup:
 	aio_free_ring(ctx);
 out_freectx:
 	kmem_cache_free(kioctx_cachep, ctx);
-	dprintk("aio: error allocating ioctx %d\n", err);
+	pr_debug("error allocating ioctx %d\n", err);
 	return ERR_PTR(err);
 }
 
@@ -607,8 +601,8 @@ static inline void really_put_req(struct kioctx *ctx, struct kiocb *req)
  */
 static void __aio_put_req(struct kioctx *ctx, struct kiocb *req)
 {
-	dprintk(KERN_DEBUG "aio_put(%p): f_count=%ld\n",
-		req, atomic_long_read(&req->ki_filp->f_count));
+	pr_debug("(%p): f_count=%ld\n",
+		 req, atomic_long_read(&req->ki_filp->f_count));
 
 	assert_spin_locked(&ctx->ctx_lock);
 
@@ -721,9 +715,9 @@ void aio_complete(struct kiocb *iocb, long res, long res2)
 	event->res = res;
 	event->res2 = res2;
 
-	dprintk("aio_complete: %p[%lu]: %p: %p %Lx %lx %lx\n",
-		ctx, tail, iocb, iocb->ki_obj.user, iocb->ki_user_data,
-		res, res2);
+	pr_debug("%p[%lu]: %p: %p %Lx %lx %lx\n",
+		 ctx, tail, iocb, iocb->ki_obj.user, iocb->ki_user_data,
+		 res, res2);
 
 	/* after flagging the request as done, we
 	 * must never even look at it again
@@ -779,9 +773,7 @@ static int aio_read_evt(struct kioctx *ioctx, struct io_event *ent)
 	int ret = 0;
 
 	ring = kmap_atomic(info->ring_pages[0]);
-	dprintk("in aio_read_evt h%lu t%lu m%lu\n",
-		 (unsigned long)ring->head, (unsigned long)ring->tail,
-		 (unsigned long)ring->nr);
+	pr_debug("h%u t%u m%u\n", ring->head, ring->tail, ring->nr);
 
 	if (ring->head == ring->tail)
 		goto out;
@@ -802,8 +794,7 @@ static int aio_read_evt(struct kioctx *ioctx, struct io_event *ent)
 
 out:
 	kunmap_atomic(ring);
-	dprintk("leaving aio_read_evt: %d  h%lu t%lu\n", ret,
-		 (unsigned long)ring->head, (unsigned long)ring->tail);
+	pr_debug("%d  h%u t%u\n", ret, ring->head, ring->tail);
 	return ret;
 }
 
@@ -866,13 +857,13 @@ static int read_events(struct kioctx *ctx,
 		if (unlikely(ret <= 0))
 			break;
 
-		dprintk("read event: %Lx %Lx %Lx %Lx\n",
-			ent.data, ent.obj, ent.res, ent.res2);
+		pr_debug("%Lx %Lx %Lx %Lx\n",
+			 ent.data, ent.obj, ent.res, ent.res2);
 
 		/* Could we split the check in two? */
 		ret = -EFAULT;
 		if (unlikely(copy_to_user(event, &ent, sizeof(ent)))) {
-			dprintk("aio: lost an event due to EFAULT.\n");
+			pr_debug("lost an event due to EFAULT.\n");
 			break;
 		}
 		ret = 0;
@@ -935,7 +926,7 @@ static int read_events(struct kioctx *ctx,
 
 		ret = -EFAULT;
 		if (unlikely(copy_to_user(event, &ent, sizeof(ent)))) {
-			dprintk("aio: lost an event due to EFAULT.\n");
+			pr_debug("lost an event due to EFAULT.\n");
 			break;
 		}
 
@@ -966,7 +957,7 @@ static void io_destroy(struct kioctx *ioctx)
 	hlist_del_rcu(&ioctx->list);
 	spin_unlock(&mm->ioctx_lock);
 
-	dprintk("aio_release(%p)\n", ioctx);
+	pr_debug("(%p)\n", ioctx);
 	if (likely(!was_dead))
 		put_ioctx(ioctx);	/* twice for the list */
 
@@ -1259,7 +1250,7 @@ static ssize_t aio_setup_iocb(struct kiocb *kiocb, bool compat)
 			kiocb->ki_retry = aio_fsync;
 		break;
 	default:
-		dprintk("EINVAL: io_submit: no operation provided\n");
+		pr_debug("EINVAL: no operation provided\n");
 		ret = -EINVAL;
 	}
 
@@ -1279,7 +1270,7 @@ static int io_submit_one(struct kioctx *ctx, struct iocb __user *user_iocb,
 
 	/* enforce forwards compatibility on users */
 	if (unlikely(iocb->aio_reserved1 || iocb->aio_reserved2)) {
-		pr_debug("EINVAL: io_submit: reserve field set\n");
+		pr_debug("EINVAL: reserve field set\n");
 		return -EINVAL;
 	}
 
@@ -1320,7 +1311,7 @@ static int io_submit_one(struct kioctx *ctx, struct iocb __user *user_iocb,
 
 	ret = put_user(req->ki_key, &user_iocb->aio_key);
 	if (unlikely(ret)) {
-		dprintk("EFAULT: aio_key\n");
+		pr_debug("EFAULT: aio_key\n");
 		goto out_put_req;
 	}
 
@@ -1401,7 +1392,7 @@ long do_io_submit(aio_context_t ctx_id, long nr,
 
 	ctx = lookup_ioctx(ctx_id);
 	if (unlikely(!ctx)) {
-		pr_debug("EINVAL: io_submit: invalid context id\n");
+		pr_debug("EINVAL: invalid context id\n");
 		return -EINVAL;
 	}
 
-- 
1.7.12

