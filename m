Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759391Ab0CPQ3q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 12:29:46 -0400
Received: from cifronik.21th.com ([62.16.86.116]:32835 "EHLO cifronik.21th.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759115Ab0CPQ3o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 12:29:44 -0400
From: =?utf-8?b?0KHQtdGA0LPQtdC5INCi0LXQvNC10YDRhdCw0L3QvtCy?= 
	<temerkhanov@cifronik.ru>
Organization: =?utf-8?b?0JfQkNCe?= "=?utf-8?b?0KbQuNGE0YDQvtC90LjQug==?="
To: LKML <linux-kernel@vger.kernel.org>, linux-aio@kvack.org
Subject: Re: [PATCH resubmit 1/3] AIO: Move aio_cancel_all()
Date: Tue, 16 Mar 2010 19:30:48 +0300
User-Agent: KMail/1.12.4 (Linux/2.6.31-gentoo-r6; KDE/4.3.5; x86_64; ; )
References: <201003161418.16959.temerkhanov@cifronik.ru> <x494okguxxp.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x494okguxxp.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Message-Id: <201003161930.48285.temerkhanov@cifronik.ru>
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_4I7nLeieabkjV0N"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_4I7nLeieabkjV0N
Content-Type: text/plain;
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

Well, I've broken the 1st patch into 2. This one just moves aio_cancel_all()

Regards, Sergey Temerkhanov, Cifronic ZAO

--Boundary-00=_4I7nLeieabkjV0N
Content-Type: text/x-patch;
  charset="utf-8";
  name="aio-move-cancel-all.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="aio-move-cancel-all.patch"

diff -r b290b47c0880 fs/aio.c
--- a/fs/aio.c	Tue Mar 16 13:51:13 2010 +0300
+++ b/fs/aio.c	Tue Mar 16 18:55:59 2010 +0300
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
@@ -1038,6 +1013,33 @@
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
+		}
+	}
+	spin_unlock_irq(&ctx->ctx_lock);
+}
+
 /* aio_read_evt
  *	Pull an event off of the ioctx's event ring.  Returns the number of 
  *	events fetched (0 or 1 ;-)

--Boundary-00=_4I7nLeieabkjV0N--
