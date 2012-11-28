Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755076Ab2K1Qxa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 11:53:30 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35969 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754677Ab2K1QoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 11:44:07 -0500
From: Kent Overstreet <koverstreet@google.com>
To: linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org
Cc: zab@redhat.com, bcrl@kvack.org, jmoyer@redhat.com, axboe@kernel.dk,
        viro@zeniv.linux.org.uk, Kent Overstreet <koverstreet@google.com>
Subject: [PATCH 06/25] aio: Kill return value of aio_complete()
Date: Wed, 28 Nov 2012 08:43:30 -0800
Message-Id: <1354121029-1376-7-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1354121029-1376-1-git-send-email-koverstreet@google.com>
References: <1354121029-1376-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nothing used the return value, and it probably wasn't possible to use it
safely for the locked versions (aio_complete(), aio_put_req()). Just
kill it.

Acked-by: Zach Brown <zab@redhat.com>
Signed-off-by: Kent Overstreet <koverstreet@google.com>
---
 fs/aio.c            | 19 +++++++------------
 include/linux/aio.h |  8 ++++----
 2 files changed, 11 insertions(+), 16 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index 1de4f78..91879d4 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -528,7 +528,7 @@ static inline void really_put_req(struct kioctx *ctx, struct kiocb *req)
 /* __aio_put_req
  *	Returns true if this put was the last user of the request.
  */
-static int __aio_put_req(struct kioctx *ctx, struct kiocb *req)
+static void __aio_put_req(struct kioctx *ctx, struct kiocb *req)
 {
 	dprintk(KERN_DEBUG "aio_put(%p): f_count=%ld\n",
 		req, atomic_long_read(&req->ki_filp->f_count));
@@ -538,7 +538,7 @@ static int __aio_put_req(struct kioctx *ctx, struct kiocb *req)
 	req->ki_users--;
 	BUG_ON(req->ki_users < 0);
 	if (likely(req->ki_users))
-		return 0;
+		return;
 	list_del(&req->ki_list);		/* remove from active_reqs */
 	req->ki_cancel = NULL;
 	req->ki_retry = NULL;
@@ -546,21 +546,18 @@ static int __aio_put_req(struct kioctx *ctx, struct kiocb *req)
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
 
@@ -594,7 +591,7 @@ static struct kioctx *lookup_ioctx(unsigned long ctx_id)
  *	Returns true if this is the last user of the request.  The 
  *	only other user of the request can be the cancellation code.
  */
-int aio_complete(struct kiocb *iocb, long res, long res2)
+void aio_complete(struct kiocb *iocb, long res, long res2)
 {
 	struct kioctx	*ctx = iocb->ki_ctx;
 	struct aio_ring_info	*info;
@@ -602,7 +599,6 @@ int aio_complete(struct kiocb *iocb, long res, long res2)
 	struct io_event	*event;
 	unsigned long	flags;
 	unsigned long	tail;
-	int		ret;
 
 	/*
 	 * Special case handling for sync iocbs:
@@ -616,7 +612,7 @@ int aio_complete(struct kiocb *iocb, long res, long res2)
 		iocb->ki_user_data = res;
 		iocb->ki_users = 0;
 		wake_up_process(iocb->ki_obj.tsk);
-		return 1;
+		return;
 	}
 
 	info = &ctx->ring_info;
@@ -675,7 +671,7 @@ int aio_complete(struct kiocb *iocb, long res, long res2)
 
 put_rq:
 	/* everything turned out well, dispose of the aiocb. */
-	ret = __aio_put_req(ctx, iocb);
+	__aio_put_req(ctx, iocb);
 
 	/*
 	 * We have to order our ring_info tail store above and test
@@ -689,7 +685,6 @@ put_rq:
 		wake_up(&ctx->wait);
 
 	spin_unlock_irqrestore(&ctx->ctx_lock, flags);
-	return ret;
 }
 EXPORT_SYMBOL(aio_complete);
 
diff --git a/include/linux/aio.h b/include/linux/aio.h
index 387dad0..0ce99e8 100644
--- a/include/linux/aio.h
+++ b/include/linux/aio.h
@@ -168,16 +168,16 @@ struct kioctx {
 /* prototypes */
 #ifdef CONFIG_AIO
 extern ssize_t wait_on_sync_kiocb(struct kiocb *iocb);
-extern int aio_put_req(struct kiocb *iocb);
-extern int aio_complete(struct kiocb *iocb, long res, long res2);
+extern void aio_put_req(struct kiocb *iocb);
+extern void aio_complete(struct kiocb *iocb, long res, long res2);
 struct mm_struct;
 extern void exit_aio(struct mm_struct *mm);
 extern long do_io_submit(aio_context_t ctx_id, long nr,
 			 struct iocb __user *__user *iocbpp, bool compat);
 #else
 static inline ssize_t wait_on_sync_kiocb(struct kiocb *iocb) { return 0; }
-static inline int aio_put_req(struct kiocb *iocb) { return 0; }
-static inline int aio_complete(struct kiocb *iocb, long res, long res2) { return 0; }
+static inline void aio_put_req(struct kiocb *iocb) { }
+static inline void aio_complete(struct kiocb *iocb, long res, long res2) { }
 struct mm_struct;
 static inline void exit_aio(struct mm_struct *mm) { }
 static inline long do_io_submit(aio_context_t ctx_id, long nr,
-- 
1.7.12

