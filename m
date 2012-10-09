Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753103Ab2JIGjg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 02:39:36 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:39639 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751440Ab2JIGjd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 02:39:33 -0400
From: Kent Overstreet <koverstreet@google.com>
To: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, tytso@mit.edu
Cc: Kent Overstreet <koverstreet@google.com>
Subject: [PATCH 1/5] aio: Kill return value of aio_complete()
Date: Mon,  8 Oct 2012 23:39:16 -0700
Message-Id: <1349764760-21093-1-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nothing used the return value, and it probably wasn't possible to use it
safely for the locked versions (aio_complete(), aio_put_req()). Just
kill it.

Signed-off-by: Kent Overstreet <koverstreet@google.com>
---
 fs/aio.c            |   19 +++++++------------
 include/linux/aio.h |    8 ++++----
 2 files changed, 11 insertions(+), 16 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index 71f613c..1ad2d97 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -548,7 +548,7 @@ static inline void really_put_req(struct kioctx *ctx, struct kiocb *req)
 /* __aio_put_req
  *	Returns true if this put was the last user of the request.
  */
-static int __aio_put_req(struct kioctx *ctx, struct kiocb *req)
+static void __aio_put_req(struct kioctx *ctx, struct kiocb *req)
 {
 	dprintk(KERN_DEBUG "aio_put(%p): f_count=%ld\n",
 		req, atomic_long_read(&req->ki_filp->f_count));
@@ -558,7 +558,7 @@ static int __aio_put_req(struct kioctx *ctx, struct kiocb *req)
 	req->ki_users--;
 	BUG_ON(req->ki_users < 0);
 	if (likely(req->ki_users))
-		return 0;
+		return;
 	list_del(&req->ki_list);		/* remove from active_reqs */
 	req->ki_cancel = NULL;
 	req->ki_retry = NULL;
@@ -566,21 +566,18 @@ static int __aio_put_req(struct kioctx *ctx, struct kiocb *req)
 	fput(req->ki_filp);
 	req->ki_filp = NULL;
 	really_put_req(ctx, req);
-	return 1;
 }
 
 /* aio_put_req
  *	Returns true if this put was the last user of the kiocb,
  *	false if the request is still in use.
  */
-int aio_put_req(struct kiocb *req)
+void aio_put_req(struct kiocb *req)
 {
 	struct kioctx *ctx = req->ki_ctx;
-	int ret;
 	spin_lock_irq(&ctx->ctx_lock);
-	ret = __aio_put_req(ctx, req);
+	__aio_put_req(ctx, req);
 	spin_unlock_irq(&ctx->ctx_lock);
-	return ret;
 }
 EXPORT_SYMBOL(aio_put_req);
 
@@ -889,7 +886,7 @@ EXPORT_SYMBOL(kick_iocb);
  *	Returns true if this is the last user of the request.  The 
  *	only other user of the request can be the cancellation code.
  */
-int aio_complete(struct kiocb *iocb, long res, long res2)
+void aio_complete(struct kiocb *iocb, long res, long res2)
 {
 	struct kioctx	*ctx = iocb->ki_ctx;
 	struct aio_ring_info	*info;
@@ -897,7 +894,6 @@ int aio_complete(struct kiocb *iocb, long res, long res2)
 	struct io_event	*event;
 	unsigned long	flags;
 	unsigned long	tail;
-	int		ret;
 
 	/*
 	 * Special case handling for sync iocbs:
@@ -911,7 +907,7 @@ int aio_complete(struct kiocb *iocb, long res, long res2)
 		iocb->ki_user_data = res;
 		iocb->ki_users = 0;
 		wake_up_process(iocb->ki_obj.tsk);
-		return 1;
+		return;
 	}
 
 	info = &ctx->ring_info;
@@ -973,7 +969,7 @@ int aio_complete(struct kiocb *iocb, long res, long res2)
 
 put_rq:
 	/* everything turned out well, dispose of the aiocb. */
-	ret = __aio_put_req(ctx, iocb);
+	__aio_put_req(ctx, iocb);
 
 	/*
 	 * We have to order our ring_info tail store above and test
@@ -987,7 +983,6 @@ put_rq:
 		wake_up(&ctx->wait);
 
 	spin_unlock_irqrestore(&ctx->ctx_lock, flags);
-	return ret;
 }
 EXPORT_SYMBOL(aio_complete);
 
diff --git a/include/linux/aio.h b/include/linux/aio.h
index 31ff6db..4cde86d 100644
--- a/include/linux/aio.h
+++ b/include/linux/aio.h
@@ -211,18 +211,18 @@ extern unsigned aio_max_size;
 
 #ifdef CONFIG_AIO
 extern ssize_t wait_on_sync_kiocb(struct kiocb *iocb);
-extern int aio_put_req(struct kiocb *iocb);
+extern void aio_put_req(struct kiocb *iocb);
 extern void kick_iocb(struct kiocb *iocb);
-extern int aio_complete(struct kiocb *iocb, long res, long res2);
+extern void aio_complete(struct kiocb *iocb, long res, long res2);
 struct mm_struct;
 extern void exit_aio(struct mm_struct *mm);
 extern long do_io_submit(aio_context_t ctx_id, long nr,
 			 struct iocb __user *__user *iocbpp, bool compat);
 #else
 static inline ssize_t wait_on_sync_kiocb(struct kiocb *iocb) { return 0; }
-static inline int aio_put_req(struct kiocb *iocb) { return 0; }
+static inline void aio_put_req(struct kiocb *iocb) { }
 static inline void kick_iocb(struct kiocb *iocb) { }
-static inline int aio_complete(struct kiocb *iocb, long res, long res2) { return 0; }
+static inline void aio_complete(struct kiocb *iocb, long res, long res2) { }
 struct mm_struct;
 static inline void exit_aio(struct mm_struct *mm) { }
 static inline long do_io_submit(aio_context_t ctx_id, long nr,
-- 
1.7.10.4

