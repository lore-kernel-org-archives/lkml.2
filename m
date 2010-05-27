Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757614Ab0E0WmH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 18:42:07 -0400
Received: from forward15.mail.yandex.net ([95.108.130.119]:40042 "EHLO
	forward15.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754493Ab0E0WmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 18:42:04 -0400
From: Sergey Temerkhanov <temerkhanov@yandex.ru>
Organization: Cifronic ZAO
To: "linux-aio" <linux-aio@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCHv2 3/3] [RFC] AIO: Change dprintk() statements to pr_debug()
Date: Fri, 28 May 2010 02:35:35 +0400
User-Agent: KMail/1.12.4 (Linux/2.6.34-40-desktop; KDE/4.3.5; x86_64; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005280235.35843.temerkhanov@yandex.ru>
X-Yandex-TimeMark: 1274999740
X-Yandex-Spam: 1
X-Yandex-Front: smtp12.mail.yandex.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Sergey Temerkhanov<temerkhanov@cifronik.ru>

This patch changes dprintk() statements to pr_debug()
and adds a few more debug info

diff -r 7e2d9365813b fs/aio.c
--- a/fs/aio.c	Fri May 07 18:07:22 2010 +0400
+++ b/fs/aio.c	Fri May 07 18:15:00 2010 +0400
@@ -36,12 +36,6 @@
 #include <asm/uaccess.h>
 #include <asm/mmu_context.h>
 
-#if DEBUG > 1
-#define dprintk		printk
-#else
-#define dprintk(x...)	do { ; } while (0)
-#endif
-
 /*------ sysctl variables----*/
 static DEFINE_SPINLOCK(aio_nr_lock);
 unsigned long aio_nr;		/* current system wide number of aio requests */
@@ -130,7 +124,7 @@
 	}
 
 	info->mmap_size = nr_pages * PAGE_SIZE;
-	dprintk("attempting mmap of %lu bytes\n", info->mmap_size);
+	pr_debug("attempting mmap of %lu bytes\n", info->mmap_size);
 	down_write(&ctx->mm->mmap_sem);
 	info->mmap_base = do_mmap(NULL, 0, info->mmap_size, 
 				  PROT_READ|PROT_WRITE, MAP_ANONYMOUS|MAP_PRIVATE,
@@ -142,7 +136,7 @@
 		return -EAGAIN;
 	}
 
-	dprintk("mmap address: 0x%08lx\n", info->mmap_base);
+	pr_debug("mmap address: 0x%08lx\n", info->mmap_base);
 	info->nr_pages = get_user_pages(current, ctx->mm,
 					info->mmap_base, nr_pages, 
 					1, 0, info->ring_pages, NULL);
@@ -300,7 +294,7 @@
 	hlist_add_head_rcu(&ctx->list, &mm->ioctx_list);
 	spin_unlock(&mm->ioctx_lock);
 
-	dprintk("aio: allocated ioctx %p[%ld]: mm=%p mask=0x%x\n",
+	pr_debug("aio: allocated ioctx %p[%ld]: mm=%p mask=0x%x\n",
 		ctx, ctx->user_id, current->mm, ctx->ring_info.nr);
 	return ctx;
 
@@ -313,7 +307,7 @@
 	kmem_cache_free(kioctx_cachep, ctx);
 	ctx = ERR_PTR(-ENOMEM);
 
-	dprintk("aio: error allocating ioctx %p\n", ctx);
+	pr_debug("aio: error allocating ioctx %p\n", ctx);
 	return ctx;
 }
 
@@ -468,6 +462,8 @@
 		kfree(req->ki_iovec);
 	kmem_cache_free(kiocb_cachep, req);
 	ctx->reqs_active--;
+	pr_debug("really_put_req: req(%p)->ki_users: %d\n",
+		 req, req->ki_users);
 
 	if (unlikely(!ctx->reqs_active && ctx->dead))
 		wake_up(&ctx->wait);
@@ -503,12 +499,14 @@
  */
 static int __aio_put_req(struct kioctx *ctx, struct kiocb *req)
 {
-	dprintk(KERN_DEBUG "aio_put(%p): f_count=%ld\n",
+	pr_debug("aio_put(%p): f_count=%ld\n",
 		req, atomic_long_read(&req->ki_filp->f_count));
 
 	assert_spin_locked(&ctx->ctx_lock);
 
 	req->ki_users--;
+	pr_debug("__aio_put_req: req(%p)->ki_users: %d\n",
+		req, req->ki_users);
 	BUG_ON(req->ki_users < 0);
 	if (likely(req->ki_users))
 		return 0;
@@ -774,6 +772,8 @@
 		 * Hold an extra reference while retrying i/o.
 		 */
 		iocb->ki_users++;       /* grab extra reference */
+		pr_debug("__aio_run_iocbs: iocb(%p)->ki_users: %d\n",
+				iocb, iocb->ki_users);
 		aio_run_iocb(iocb);
 		__aio_put_req(ctx, iocb);
  	}
@@ -957,6 +957,7 @@
 	 * cancelled requests don't get events, userland was given one
 	 * when the event got cancelled.
 	 */
+	pr_debug("kiocbIsCancelled(iocb): %d\n", kiocbIsCancelled(iocb));
 	if (kiocbIsCancelled(iocb))
 		goto put_rq;
 
@@ -972,7 +973,7 @@
 	event->res = res;
 	event->res2 = res2;
 
-	dprintk("aio_complete: %p[%lu]: %p: %p %Lx %lx %lx\n",
+	pr_debug("aio_complete: %p[%lu]: %p: %p %Lx %lx %lx\n",
 		ctx, tail, iocb, iocb->ki_obj.user, iocb->ki_user_data,
 		res, res2);
 
@@ -1035,6 +1036,8 @@
 		kiocbSetCancelled(iocb);
 		if (cancel) {
 			iocb->ki_users++;
+			pr_debug("aio_cancel_all: iocb(%p)->ki_users: %d\n",
+					iocb, iocb->ki_users);
 			spin_unlock_irq(&ctx->ctx_lock);
 			cancel(iocb, &res);
 			spin_lock_irq(&ctx->ctx_lock);
@@ -1058,7 +1061,7 @@
 	int ret = 0;
 
 	ring = kmap_atomic(info->ring_pages[0], KM_USER0);
-	dprintk("in aio_read_evt h%lu t%lu m%lu\n",
+	pr_debug("in aio_read_evt h%lu t%lu m%lu\n",
 		 (unsigned long)ring->head, (unsigned long)ring->tail,
 		 (unsigned long)ring->nr);
 
@@ -1081,7 +1084,7 @@
 
 out:
 	kunmap_atomic(ring, KM_USER0);
-	dprintk("leaving aio_read_evt: %d  h%lu t%lu\n", ret,
+	pr_debug("leaving aio_read_evt: %d  h%lu t%lu\n", ret,
 		 (unsigned long)ring->head, (unsigned long)ring->tail);
 	return ret;
 }
@@ -1147,13 +1150,13 @@
 		if (unlikely(ret <= 0))
 			break;
 
-		dprintk("read event: %Lx %Lx %Lx %Lx\n",
+		pr_debug("read event: %Lx %Lx %Lx %Lx\n",
 			ent.data, ent.obj, ent.res, ent.res2);
 
 		/* Could we split the check in two? */
 		ret = -EFAULT;
 		if (unlikely(copy_to_user(event, &ent, sizeof(ent)))) {
-			dprintk("aio: lost an event due to EFAULT.\n");
+			pr_debug("aio: lost an event due to EFAULT.\n");
 			break;
 		}
 		ret = 0;
@@ -1188,6 +1191,7 @@
 	}
 
 	while (likely(i < nr)) {
+		pr_debug("aio: i: %d, nr: %ld\n", i, nr);
 		add_wait_queue_exclusive(&ctx->wait, &wait);
 		do {
 			set_task_state(tsk, TASK_INTERRUPTIBLE);
@@ -1200,6 +1204,7 @@
 				ret = -EINVAL;
 				break;
 			}
+			pr_debug("aio: to.timed_out: %d\n", to.timed_out);
 			if (to.timed_out)	/* Only check after read evt */
 				break;
 			/* Try to only show up in io wait if there are ops
@@ -1223,7 +1228,7 @@
 
 		ret = -EFAULT;
 		if (unlikely(copy_to_user(event, &ent, sizeof(ent)))) {
-			dprintk("aio: lost an event due to EFAULT.\n");
+			pr_debug("aio: lost an event due to EFAULT.\n");
 			break;
 		}
 
@@ -1254,7 +1259,7 @@
 	hlist_del_rcu(&ioctx->list);
 	spin_unlock(&mm->ioctx_lock);
 
-	dprintk("aio_release(%p)\n", ioctx);
+	pr_debug("aio_release(%p)\n", ioctx);
 	if (likely(!was_dead))
 		put_ioctx(ioctx);	/* twice for the list */
 
@@ -1543,7 +1548,7 @@
 			kiocb->ki_retry = aio_fsync;
 		break;
 	default:
-		dprintk("EINVAL: io_submit: no operation provided\n");
+		pr_debug("EINVAL: io_submit: no operation provided\n");
 		ret = -EINVAL;
 	}
 
@@ -1628,7 +1633,7 @@
 
 	ret = put_user(req->ki_key, &user_iocb->aio_key);
 	if (unlikely(ret)) {
-		dprintk("EFAULT: aio_key\n");
+		pr_debug("EFAULT: aio_key\n");
 		goto out_put_req;
 	}
 
@@ -1774,6 +1779,8 @@
 	if (kiocb && kiocb->ki_cancel) {
 		cancel = kiocb->ki_cancel;
 		kiocb->ki_users ++;
+		pr_debug("io_cancel: kiocb(%p)->ki_users: %d\n",
+				kiocb, kiocb->ki_users);
 		kiocbSetCancelled(kiocb);
 	} else
 		cancel = NULL;
