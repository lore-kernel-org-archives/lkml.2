Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759512Ab0CPQ3w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 12:29:52 -0400
Received: from cifronik.21th.com ([62.16.86.116]:32840 "EHLO cifronik.21th.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759354Ab0CPQ3r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 12:29:47 -0400
From: =?utf-8?b?0KHQtdGA0LPQtdC5INCi0LXQvNC10YDRhdCw0L3QvtCy?= 
	<temerkhanov@cifronik.ru>
Organization: =?utf-8?b?0JfQkNCe?= "=?utf-8?b?0KbQuNGE0YDQvtC90LjQug==?="
To: LKML <linux-kernel@vger.kernel.org>, linux-aio@kvack.org
Subject: Re: [PATCH resubmit 3/3] AIO: Change dprintk statements to pr_debug
Date: Tue, 16 Mar 2010 19:30:28 +0300
User-Agent: KMail/1.12.4 (Linux/2.6.31-gentoo-r6; KDE/4.3.5; x86_64; ; )
References: <201003161418.16959.temerkhanov@cifronik.ru> <x494okguxxp.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x494okguxxp.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Message-Id: <201003161930.28652.temerkhanov@cifronik.ru>
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_kI7nLbZY9BcOA/P"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_kI7nLbZY9BcOA/P
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit

On Tuesday 16 March 2010 17:46:10 Jeff Moyer wrote:
> Sergey Temerkhanov <temerkhanov@cifronik.ru> writes:
> > io_cancel() and aio_cancel_all() have inconsistent reference counting
> > (ki_users field of struct kiocb) which leads to unkillable processes upon
> > io_cancel() or io_destroy() syscalls. This patch fixes the undesired
> > behavior.
> 
> Hi, Sergey,
> 
> Thanks for the patch.  Would you mind resubmitting it to make it a bit
> easier to review?  The way you've done things, it is difficult to tell
> if you just moved the aio_cancel_all function or if you moved it and
> made changes.  Please have the patch that moves it separated out from
> other changes, or at least mention in the changelog that the function
> was unchanged.  Next, if you could tell what sorts of testing you've
> performed, that would be great.  Finally, it would be a good idea to CC
> linux-aio@kvack.org on aio patches.
> 
> Thanks!
> Jeff

And the last one changes dprintk statements to pr_debug

Regards, Sergey Temerkhanov, Cifronic ZAO

--Boundary-00=_kI7nLbZY9BcOA/P
Content-Type: text/x-patch;
  charset="UTF-8";
  name="aio-debug.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="aio-debug.patch"

diff -r b33005cb6b8d fs/aio.c
--- a/fs/aio.c	Tue Mar 16 19:08:49 2010 +0300
+++ b/fs/aio.c	Tue Mar 16 19:15:56 2010 +0300
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
 
@@ -468,6 +462,7 @@
 		kfree(req->ki_iovec);
 	kmem_cache_free(kiocb_cachep, req);
 	ctx->reqs_active--;
+	pr_debug("really_put_req: req->ki_users: %d\n", req->ki_users);
 
 	if (unlikely(!ctx->reqs_active && ctx->dead))
 		wake_up(&ctx->wait);
@@ -503,12 +498,14 @@
  */
 static int __aio_put_req(struct kioctx *ctx, struct kiocb *req)
 {
-	dprintk(KERN_DEBUG "aio_put(%p): f_count=%ld\n",
+	pr_debug("aio_put(%p): f_count=%ld\n",
 		req, atomic_long_read(&req->ki_filp->f_count));
 
 	assert_spin_locked(&ctx->ctx_lock);
 
 	req->ki_users--;
+	pr_debug("__aio_put_req: req: %p, req->ki_users: %d\n",
+		req, req->ki_users);
 	BUG_ON(req->ki_users < 0);
 	if (likely(req->ki_users))
 		return 0;
@@ -954,6 +951,7 @@
 	 * cancelled requests don't get events, userland was given one
 	 * when the event got cancelled.
 	 */
+	pr_debug("kiocbIsCancelled(iocb): %d\n", kiocbIsCancelled(iocb));
 	if (kiocbIsCancelled(iocb))
 		goto put_rq;
 
@@ -969,7 +967,7 @@
 	event->res = res;
 	event->res2 = res2;
 
-	dprintk("aio_complete: %p[%lu]: %p: %p %Lx %lx %lx\n",
+	pr_debug("aio_complete: %p[%lu]: %p: %p %Lx %lx %lx\n",
 		ctx, tail, iocb, iocb->ki_obj.user, iocb->ki_user_data,
 		res, res2);
 
@@ -1056,7 +1054,7 @@
 	int ret = 0;
 
 	ring = kmap_atomic(info->ring_pages[0], KM_USER0);
-	dprintk("in aio_read_evt h%lu t%lu m%lu\n",
+	pr_debug("in aio_read_evt h%lu t%lu m%lu\n",
 		 (unsigned long)ring->head, (unsigned long)ring->tail,
 		 (unsigned long)ring->nr);
 
@@ -1079,7 +1077,7 @@
 
 out:
 	kunmap_atomic(ring, KM_USER0);
-	dprintk("leaving aio_read_evt: %d  h%lu t%lu\n", ret,
+	pr_debug("leaving aio_read_evt: %d  h%lu t%lu\n", ret,
 		 (unsigned long)ring->head, (unsigned long)ring->tail);
 	return ret;
 }
@@ -1145,13 +1143,13 @@
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
@@ -1186,6 +1184,7 @@
 	}
 
 	while (likely(i < nr)) {
+		pr_debug("aio: i: %d, nr: %ld\n", i, nr);
 		add_wait_queue_exclusive(&ctx->wait, &wait);
 		do {
 			set_task_state(tsk, TASK_INTERRUPTIBLE);
@@ -1198,6 +1197,7 @@
 				ret = -EINVAL;
 				break;
 			}
+			pr_debug("aio: to.timed_out: %d\n", to.timed_out);
 			if (to.timed_out)	/* Only check after read evt */
 				break;
 			/* Try to only show up in io wait if there are ops
@@ -1221,7 +1221,7 @@
 
 		ret = -EFAULT;
 		if (unlikely(copy_to_user(event, &ent, sizeof(ent)))) {
-			dprintk("aio: lost an event due to EFAULT.\n");
+			pr_debug("aio: lost an event due to EFAULT.\n");
 			break;
 		}
 
@@ -1252,7 +1252,7 @@
 	hlist_del_rcu(&ioctx->list);
 	spin_unlock(&mm->ioctx_lock);
 
-	dprintk("aio_release(%p)\n", ioctx);
+	pr_debug("aio_release(%p)\n", ioctx);
 	if (likely(!was_dead))
 		put_ioctx(ioctx);	/* twice for the list */
 
@@ -1541,7 +1541,7 @@
 			kiocb->ki_retry = aio_fsync;
 		break;
 	default:
-		dprintk("EINVAL: io_submit: no operation provided\n");
+		pr_debug("EINVAL: io_submit: no operation provided\n");
 		ret = -EINVAL;
 	}
 
@@ -1626,7 +1626,7 @@
 
 	ret = put_user(req->ki_key, &user_iocb->aio_key);
 	if (unlikely(ret)) {
-		dprintk("EFAULT: aio_key\n");
+		pr_debug("EFAULT: aio_key\n");
 		goto out_put_req;
 	}
 

--Boundary-00=_kI7nLbZY9BcOA/P--
