Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756930Ab0E0WkG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 18:40:06 -0400
Received: from forward15.mail.yandex.net ([95.108.130.119]:38424 "EHLO
	forward15.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753254Ab0E0WkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 18:40:04 -0400
X-Greylist: delayed 309 seconds by postgrey-1.27 at vger.kernel.org; Thu, 27 May 2010 18:40:04 EDT
From: Sergey Temerkhanov <temerkhanov@yandex.ru>
Organization: Cifronic ZAO
Subject: [PATCHv2 1/3] [RFC] AIO: Move aio_cancel_all() after aio_complete()
Date: Fri, 28 May 2010 02:35:06 +0400
User-Agent: KMail/1.12.4 (Linux/2.6.34-40-desktop; KDE/4.3.5; x86_64; ; )
MIME-Version: 1.0
To: "linux-aio" <linux-aio@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005280235.07037.temerkhanov@yandex.ru>
X-Yandex-TimeMark: 1274999711
X-Yandex-Spam: 1
X-Yandex-Front: smtp13.mail.yandex.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Sergey Temerkhanov<temerkhanov@cifronik.ru>

This patch moves aio_cancel_all() after aio_complete()

diff -r fe2f57b1e97a fs/aio.c
--- a/fs/aio.c	Fri May 07 01:57:27 2010 +0400
+++ b/fs/aio.c	Fri May 07 01:58:53 2010 +0400
@@ -63,6 +63,8 @@
 static void aio_kick_handler(struct work_struct *);
 static void aio_queue_work(struct kioctx *);
 
+static void aio_cancel_all(struct kioctx *);
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
@@ -1041,6 +1016,33 @@
 	return ret;
 }
 
+/* aio_cancel_all
+ *	Cancels all outstanding aio requests on an aio context. Used
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
+		}
+	}
+	spin_unlock_irq(&ctx->ctx_lock);
+}
+
 /* aio_read_evt
  *	Pull an event off of the ioctx's event ring.  Returns the number of 
  *	events fetched (0 or 1 ;-)
