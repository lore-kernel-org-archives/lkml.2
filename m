Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755644Ab2K1Qww (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 11:52:52 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:45503 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754698Ab2K1QoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 11:44:09 -0500
From: Kent Overstreet <koverstreet@google.com>
To: linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org
Cc: zab@redhat.com, bcrl@kvack.org, jmoyer@redhat.com, axboe@kernel.dk,
        viro@zeniv.linux.org.uk, Kent Overstreet <koverstreet@google.com>
Subject: [PATCH 07/25] aio: kiocb_cancel()
Date: Wed, 28 Nov 2012 08:43:31 -0800
Message-Id: <1354121029-1376-8-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1354121029-1376-1-git-send-email-koverstreet@google.com>
References: <1354121029-1376-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Minor refactoring, to get rid of some duplicated code

Signed-off-by: Kent Overstreet <koverstreet@google.com>
---
 fs/aio.c | 72 +++++++++++++++++++++++++++++++++++-----------------------------
 1 file changed, 39 insertions(+), 33 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index 91879d4..a993234 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -217,6 +217,29 @@ static inline void put_ioctx(struct kioctx *kioctx)
 		__put_ioctx(kioctx);
 }
 
+static int kiocb_cancel(struct kioctx *ctx, struct kiocb *kiocb,
+			struct io_event *res)
+{
+	int (*cancel)(struct kiocb *, struct io_event *);
+	int ret = -EINVAL;
+
+	cancel = kiocb->ki_cancel;
+	kiocbSetCancelled(kiocb);
+	if (cancel) {
+		kiocb->ki_users++;
+		spin_unlock_irq(&ctx->ctx_lock);
+
+		memset(res, 0, sizeof(*res));
+		res->obj = (u64) kiocb->ki_obj.user;
+		res->data = kiocb->ki_user_data;
+		ret = cancel(kiocb, res);
+
+		spin_lock_irq(&ctx->ctx_lock);
+	}
+
+	return ret;
+}
+
 /* ioctx_alloc
  *	Allocates and initializes an ioctx.  Returns an ERR_PTR if it failed.
  */
@@ -287,7 +310,6 @@ out_freectx:
  */
 static void kill_ctx(struct kioctx *ctx)
 {
-	int (*cancel)(struct kiocb *, struct io_event *);
 	struct task_struct *tsk = current;
 	DECLARE_WAITQUEUE(wait, tsk);
 	struct io_event res;
@@ -298,14 +320,8 @@ static void kill_ctx(struct kioctx *ctx)
 		struct list_head *pos = ctx->active_reqs.next;
 		struct kiocb *iocb = list_kiocb(pos);
 		list_del_init(&iocb->ki_list);
-		cancel = iocb->ki_cancel;
-		kiocbSetCancelled(iocb);
-		if (cancel) {
-			iocb->ki_users++;
-			spin_unlock_irq(&ctx->ctx_lock);
-			cancel(iocb, &res);
-			spin_lock_irq(&ctx->ctx_lock);
-		}
+
+		kiocb_cancel(ctx, iocb, &res);
 	}
 
 	if (!ctx->reqs_active)
@@ -1411,7 +1427,7 @@ static struct kiocb *lookup_kiocb(struct kioctx *ctx, struct iocb __user *iocb,
 SYSCALL_DEFINE3(io_cancel, aio_context_t, ctx_id, struct iocb __user *, iocb,
 		struct io_event __user *, result)
 {
-	int (*cancel)(struct kiocb *iocb, struct io_event *res);
+	struct io_event res;
 	struct kioctx *ctx;
 	struct kiocb *kiocb;
 	u32 key;
@@ -1426,32 +1442,22 @@ SYSCALL_DEFINE3(io_cancel, aio_context_t, ctx_id, struct iocb __user *, iocb,
 		return -EINVAL;
 
 	spin_lock_irq(&ctx->ctx_lock);
-	ret = -EAGAIN;
+
 	kiocb = lookup_kiocb(ctx, iocb, key);
-	if (kiocb && kiocb->ki_cancel) {
-		cancel = kiocb->ki_cancel;
-		kiocb->ki_users ++;
-		kiocbSetCancelled(kiocb);
-	} else
-		cancel = NULL;
+	if (kiocb)
+		ret = kiocb_cancel(ctx, kiocb, &res);
+	else
+		ret = -EAGAIN;
+
 	spin_unlock_irq(&ctx->ctx_lock);
 
-	if (NULL != cancel) {
-		struct io_event tmp;
-		pr_debug("calling cancel\n");
-		memset(&tmp, 0, sizeof(tmp));
-		tmp.obj = (u64)(unsigned long)kiocb->ki_obj.user;
-		tmp.data = kiocb->ki_user_data;
-		ret = cancel(kiocb, &tmp);
-		if (!ret) {
-			/* Cancellation succeeded -- copy the result
-			 * into the user's buffer.
-			 */
-			if (copy_to_user(result, &tmp, sizeof(tmp)))
-				ret = -EFAULT;
-		}
-	} else
-		ret = -EINVAL;
+	if (!ret) {
+		/* Cancellation succeeded -- copy the result
+		 * into the user's buffer.
+		 */
+		if (copy_to_user(result, &res, sizeof(res)))
+			ret = -EFAULT;
+	}
 
 	put_ioctx(ctx);
 
-- 
1.7.12

