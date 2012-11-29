Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756504Ab2K2A6f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 19:58:35 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36150 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755386Ab2K2A6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 19:58:33 -0500
Date: Wed, 28 Nov 2012 16:58:29 -0800
From: Kent Overstreet <koverstreet@google.com>
To: Zach Brown <zab@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org, bcrl@kvack.org, jmoyer@redhat.com,
        axboe@kernel.dk, viro@zeniv.linux.org.uk
Subject: Re: [PATCH 07/25] aio: kiocb_cancel()
Message-ID: <20121129005829.GA15094@google.com>
References: <1354121029-1376-1-git-send-email-koverstreet@google.com>
 <1354121029-1376-8-git-send-email-koverstreet@google.com>
 <20121129000753.GG18574@lenny.home.zabbo.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121129000753.GG18574@lenny.home.zabbo.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 28, 2012 at 04:07:53PM -0800, Zach Brown wrote:
> On Wed, Nov 28, 2012 at 08:43:31AM -0800, Kent Overstreet wrote:
> > Minor refactoring, to get rid of some duplicated code
> 
> A minor nit:
> 
> >  	spin_lock_irq(&ctx->ctx_lock);
> > -	ret = -EAGAIN;
> > +
> >  	kiocb = lookup_kiocb(ctx, iocb, key);
> > -	if (kiocb && kiocb->ki_cancel) {
> > -		cancel = kiocb->ki_cancel;
> > -		kiocb->ki_users ++;
> > -		kiocbSetCancelled(kiocb);
> > -	} else
> > -		cancel = NULL;
>  ...
> > -	if (NULL != cancel) {
> > -	} else
> > -		ret = -EINVAL;
> 
> In the old code it'd return -EINVAL for a NULL kiocb, despite that
> misleading unused EAGAIN.

Oh damn, that's evil. Hadn't noticed that before.

> 
> > +	if (kiocb)
> > +		ret = kiocb_cancel(ctx, kiocb, &res);
> > +	else
> > +		ret = -EAGAIN;
> 
> But now it returns -EAGAIN.
> 
> I bet we want to err on the side of caution and maintain behaviour, no
> matter how funky.

Agreed. Fixed patch below:


fatal: Not a git repository (or any of the parent directories): .git
commit 7ad9d0a1914e9563021c0f5f7fc55f20e41999e7
Author: Kent Overstreet <koverstreet@google.com>
Date:   Wed Nov 28 16:57:48 2012 -0800

    aio: kiocb_cancel()
    
    Minor refactoring, to get rid of some duplicated code
    
    Signed-off-by: Kent Overstreet <koverstreet@google.com>

diff --git a/fs/aio.c b/fs/aio.c
index 91879d4..786c904 100644
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
+		ret = -EINVAL;
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
 
