Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966157Ab0CPLWu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 07:22:50 -0400
Received: from cifronik.21th.com ([62.16.86.116]:46436 "EHLO cifronik.21th.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966079Ab0CPLWt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 07:22:49 -0400
X-Greylist: delayed 336 seconds by postgrey-1.27 at vger.kernel.org; Tue, 16 Mar 2010 07:22:48 EDT
From: Sergey Temerkhanov <temerkhanov@cifronik.ru>
Organization: =?utf-8?b?0JfQkNCe?= "=?utf-8?b?0KbQuNGE0YDQvtC90LjQug==?="
To: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] AIO: Fix reference counting in io_cancel and aio_cancel_all
Date: Tue, 16 Mar 2010 14:18:16 +0300
User-Agent: KMail/1.12.4 (Linux/2.6.31-gentoo-r6; KDE/4.3.5; x86_64; ; )
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_4j2nLcg+3yVgKAJ"
Message-Id: <201003161418.16959.temerkhanov@cifronik.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_4j2nLcg+3yVgKAJ
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit

io_cancel() and aio_cancel_all() have inconsistent reference counting 
(ki_users field of struct kiocb) which leads to unkillable processes upon  
io_cancel() or io_destroy() syscalls. This patch fixes the undesired behavior.

Regards, Sergey Temerkhanov, Cifronic ZAO

--Boundary-00=_4j2nLcg+3yVgKAJ
Content-Type: text/x-patch;
  charset="UTF-8";
  name="aio-fix.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="aio-fix.patch"

diff -r b290b47c0880 fs/aio.c
--- a/fs/aio.c	Tue Mar 16 13:51:13 2010 +0300
+++ b/fs/aio.c	Tue Mar 16 14:11:36 2010 +0300
@@ -63,6 +63,8 @@
 static void aio_kick_handler(struct work_struct *);
 static void aio_queue_work(struct kioctx *);
 
+static void aio_cancel_all(struct kioctx *ctx);
+
 /* aio_setup
  *	Creates the slab caches used by the aio routines, panic on
  *	failure as this is done early during the boot sequence.
@@ -315,33 +317,6 @@
 	return ctx;
 }
 
-/* aio_cancel_all
- *	Cancels all outstanding aio requests on an aio context.  Used 
- *	when the processes owning a context have all exited to encourage 
- *	the rapid destruction of the kioctx.
- */
-static void aio_cancel_all(struct kioctx *ctx)
-{
-	int (*cancel)(struct kiocb *, struct io_event *);
-	struct io_event res;
-	spin_lock_irq(&ctx->ctx_lock);
-	ctx->dead = 1;
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
-		}
-	}
-	spin_unlock_irq(&ctx->ctx_lock);
-}
-
 static void wait_for_all_aios(struct kioctx *ctx)
 {
 	struct task_struct *tsk = current;
@@ -1038,6 +1013,36 @@
 	return ret;
 }
 
+/* aio_cancel_all
+ *	Cancels all outstanding aio requests on an aio context.  Used 
+ *	when the processes owning a context have all exited to encourage 
+ *	the rapid destruction of the kioctx.
+ */
+static void aio_cancel_all(struct kioctx *ctx)
+{
+	int (*cancel)(struct kiocb *, struct io_event *);
+	struct io_event res;
+	spin_lock_irq(&ctx->ctx_lock);
+	ctx->dead = 1;
+	while (!list_empty(&ctx->active_reqs)) {
+		struct list_head *pos = ctx->active_reqs.next;
+		struct kiocb *iocb = list_kiocb(pos);
+		list_del_init(&iocb->ki_list);
+		cancel = iocb->ki_cancel;
+		kiocbSetCancelled(iocb);
+		if (cancel) {
+			iocb->ki_users++;
+			spin_unlock_irq(&ctx->ctx_lock);
+			cancel(iocb, &res);
+			spin_lock_irq(&ctx->ctx_lock);
+			dprintk("aio_cancel_all: iocb->ki_users: %d\n", iocb->ki_users);
+			__aio_put_req(ctx, iocb);
+		}
+		__aio_put_req(ctx, iocb);
+	}
+	spin_unlock_irq(&ctx->ctx_lock);
+}
+
 /* aio_read_evt
  *	Pull an event off of the ioctx's event ring.  Returns the number of 
  *	events fetched (0 or 1 ;-)
@@ -1787,9 +1792,11 @@
 			if (copy_to_user(result, &tmp, sizeof(tmp)))
 				ret = -EFAULT;
 		}
+		aio_put_req(kiocb);
 	} else
 		ret = -EINVAL;
 
+	aio_put_req(kiocb);
 	put_ioctx(ctx);
 
 	return ret;

--Boundary-00=_4j2nLcg+3yVgKAJ--
