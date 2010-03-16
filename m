Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966171Ab0CPL2N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 07:28:13 -0400
Received: from cifronik.21th.com ([62.16.86.116]:41606 "EHLO cifronik.21th.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966133Ab0CPL2L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 07:28:11 -0400
From: Sergey Temerkhanov <temerkhanov@cifronik.ru>
Organization: =?utf-8?b?0JfQkNCe?= "=?utf-8?b?0KbQuNGE0YDQvtC90LjQug==?="
To: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] AIO: Change pr_debug statements to dprintk in fs/aio.c
Date: Tue, 16 Mar 2010 14:29:15 +0300
User-Agent: KMail/1.12.4 (Linux/2.6.31-gentoo-r6; KDE/4.3.5; x86_64; ; )
References: <201003161418.16959.temerkhanov@cifronik.ru>
In-Reply-To: <201003161418.16959.temerkhanov@cifronik.ru>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_Lu2nLuQiqxg1UO2"
Message-Id: <201003161429.15926.temerkhanov@cifronik.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_Lu2nLuQiqxg1UO2
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit

Some functions in fs/aio.c use pr_debug and another use dprintk statements. 
This patch makes it uniform.


Regards, Sergey Temerkhanov, Cifronic ZAO

--Boundary-00=_Lu2nLuQiqxg1UO2
Content-Type: text/x-patch;
  charset="UTF-8";
  name="aio-debug.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="aio-debug.patch"

diff -r 5bbe95a762e1 fs/aio.c
--- a/fs/aio.c	Tue Mar 16 14:11:37 2010 +0300
+++ b/fs/aio.c	Tue Mar 16 14:11:44 2010 +0300
@@ -76,7 +76,7 @@
 
 	aio_wq = create_workqueue("aio");
 
-	pr_debug("aio_setup: sizeof(struct page) = %d\n", (int)sizeof(struct page));
+	dprintk("aio_setup: sizeof(struct page) = %d\n", (int)sizeof(struct page));
 
 	return 0;
 }
@@ -221,7 +221,7 @@
 	aio_free_ring(ctx);
 	mmdrop(ctx->mm);
 	ctx->mm = NULL;
-	pr_debug("__put_ioctx: freeing %p\n", ctx);
+	dprintk("__put_ioctx: freeing %p\n", ctx);
 	call_rcu(&ctx->rcu_head, ctx_rcu_free);
 }
 
@@ -247,7 +247,7 @@
 	/* Prevent overflows */
 	if ((nr_events > (0x10000000U / sizeof(struct io_event))) ||
 	    (nr_events > (0x10000000U / sizeof(struct kiocb)))) {
-		pr_debug("ENOMEM: nr_events too high\n");
+		dprintk("ENOMEM: nr_events too high\n");
 		return ERR_PTR(-EINVAL);
 	}
 
@@ -468,6 +468,7 @@
 		kfree(req->ki_iovec);
 	kmem_cache_free(kiocb_cachep, req);
 	ctx->reqs_active--;
+	dprintk("really_put_req: req->ki_users: %d\n", req->ki_users);
 
 	if (unlikely(!ctx->reqs_active && ctx->dead))
 		wake_up(&ctx->wait);
@@ -503,12 +504,14 @@
  */
 static int __aio_put_req(struct kioctx *ctx, struct kiocb *req)
 {
-	dprintk(KERN_DEBUG "aio_put(%p): f_count=%ld\n",
+	dprintk("aio_put(%p): f_count=%ld\n",
 		req, atomic_long_read(&req->ki_filp->f_count));
 
 	assert_spin_locked(&ctx->ctx_lock);
 
 	req->ki_users--;
+	dprintk("__aio_put_req: req: %p, req->ki_users: %d\n",
+		req, req->ki_users);
 	BUG_ON(req->ki_users < 0);
 	if (likely(req->ki_users))
 		return 0;
@@ -954,6 +957,7 @@
 	 * cancelled requests don't get events, userland was given one
 	 * when the event got cancelled.
 	 */
+	dprintk("kiocbIsCancelled(iocb): %d\n", kiocbIsCancelled(iocb));
 	if (kiocbIsCancelled(iocb))
 		goto put_rq;
 
@@ -984,7 +988,7 @@
 	put_aio_ring_event(event, KM_IRQ0);
 	kunmap_atomic(ring, KM_IRQ1);
 
-	pr_debug("added to ring %p at [%lu]\n", iocb, tail);
+	dprintk("added to ring %p at [%lu]\n", iocb, tail);
 
 	/*
 	 * Check if the user asked us to deliver the result through an
@@ -1187,6 +1191,7 @@
 	}
 
 	while (likely(i < nr)) {
+		dprintk("aio: i: %d, nr: %ld\n", i, nr);
 		add_wait_queue_exclusive(&ctx->wait, &wait);
 		do {
 			set_task_state(tsk, TASK_INTERRUPTIBLE);
@@ -1199,6 +1204,7 @@
 				ret = -EINVAL;
 				break;
 			}
+			dprintk("aio: to.timed_out: %d\n", to.timed_out);
 			if (to.timed_out)	/* Only check after read evt */
 				break;
 			/* Try to only show up in io wait if there are ops
@@ -1294,7 +1300,7 @@
 
 	ret = -EINVAL;
 	if (unlikely(ctx || nr_events == 0)) {
-		pr_debug("EINVAL: io_setup: ctx %lu nr_events %u\n",
+		dprintk("EINVAL: io_setup: ctx %lu nr_events %u\n",
 		         ctx, nr_events);
 		goto out;
 	}
@@ -1327,7 +1333,7 @@
 		io_destroy(ioctx);
 		return 0;
 	}
-	pr_debug("EINVAL: io_destroy: invalid context id\n");
+	dprintk("EINVAL: io_destroy: invalid context id\n");
 	return -EINVAL;
 }
 
@@ -1586,7 +1592,7 @@
 
 	/* enforce forwards compatibility on users */
 	if (unlikely(iocb->aio_reserved1 || iocb->aio_reserved2)) {
-		pr_debug("EINVAL: io_submit: reserve field set\n");
+		dprintk("EINVAL: io_submit: reserve field set\n");
 		return -EINVAL;
 	}
 
@@ -1596,7 +1602,7 @@
 	    (iocb->aio_nbytes != (size_t)iocb->aio_nbytes) ||
 	    ((ssize_t)iocb->aio_nbytes < 0)
 	   )) {
-		pr_debug("EINVAL: io_submit: overflow check\n");
+		dprintk("EINVAL: io_submit: overflow check\n");
 		return -EINVAL;
 	}
 
@@ -1690,7 +1696,7 @@
 
 	ctx = lookup_ioctx(ctx_id);
 	if (unlikely(!ctx)) {
-		pr_debug("EINVAL: io_submit: invalid context id\n");
+		dprintk("EINVAL: io_submit: invalid context id\n");
 		return -EINVAL;
 	}
 
@@ -1780,7 +1786,7 @@
 
 	if (NULL != cancel) {
 		struct io_event tmp;
-		pr_debug("calling cancel\n");
+		dprintk("calling cancel\n");
 		memset(&tmp, 0, sizeof(tmp));
 		tmp.obj = (u64)(unsigned long)kiocb->ki_obj.user;
 		tmp.data = kiocb->ki_user_data;

--Boundary-00=_Lu2nLuQiqxg1UO2--
