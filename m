Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753190Ab2LCVEx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 16:04:53 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:52766 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752559Ab2LCU73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 15:59:29 -0500
From: Kent Overstreet <koverstreet@google.com>
To: linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org
Cc: zab@redhat.com, bcrl@kvack.org, jmoyer@redhat.com, axboe@kernel.dk,
        viro@zeniv.linux.org.uk, Kent Overstreet <koverstreet@google.com>
Subject: [PATCH 10/26] aio: do fget() after aio_get_req()
Date: Mon,  3 Dec 2012 12:58:26 -0800
Message-Id: <1354568322-29029-11-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1354568322-29029-1-git-send-email-koverstreet@google.com>
References: <1354568322-29029-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

aio_get_req() will fail if we have the maximum number of requests
outstanding, which depending on the application may not be uncommon. So
avoid doing an unnecessary fget().

Signed-off-by: Kent Overstreet <koverstreet@google.com>
---
 fs/aio.c | 22 +++++++++-------------
 1 file changed, 9 insertions(+), 13 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index 4cceba1..92cf34c 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -583,6 +583,8 @@ static inline void really_put_req(struct kioctx *ctx, struct kiocb *req)
 {
 	assert_spin_locked(&ctx->ctx_lock);
 
+	if (req->ki_filp)
+		fput(req->ki_filp);
 	if (req->ki_eventfd != NULL)
 		eventfd_ctx_put(req->ki_eventfd);
 	if (req->ki_dtor)
@@ -601,9 +603,6 @@ static inline void really_put_req(struct kioctx *ctx, struct kiocb *req)
  */
 static void __aio_put_req(struct kioctx *ctx, struct kiocb *req)
 {
-	pr_debug("(%p): f_count=%ld\n",
-		 req, atomic_long_read(&req->ki_filp->f_count));
-
 	assert_spin_locked(&ctx->ctx_lock);
 
 	req->ki_users--;
@@ -614,8 +613,6 @@ static void __aio_put_req(struct kioctx *ctx, struct kiocb *req)
 	req->ki_cancel = NULL;
 	req->ki_retry = NULL;
 
-	fput(req->ki_filp);
-	req->ki_filp = NULL;
 	really_put_req(ctx, req);
 }
 
@@ -1265,7 +1262,6 @@ static int io_submit_one(struct kioctx *ctx, struct iocb __user *user_iocb,
 			 bool compat)
 {
 	struct kiocb *req;
-	struct file *file;
 	ssize_t ret;
 
 	/* enforce forwards compatibility on users */
@@ -1284,16 +1280,16 @@ static int io_submit_one(struct kioctx *ctx, struct iocb __user *user_iocb,
 		return -EINVAL;
 	}
 
-	file = fget(iocb->aio_fildes);
-	if (unlikely(!file))
-		return -EBADF;
-
 	req = aio_get_req(ctx, batch);  /* returns with 2 references to req */
-	if (unlikely(!req)) {
-		fput(file);
+	if (unlikely(!req))
 		return -EAGAIN;
+
+	req->ki_filp = fget(iocb->aio_fildes);
+	if (unlikely(!req->ki_filp)) {
+		ret = -EBADF;
+		goto out_put_req;
 	}
-	req->ki_filp = file;
+
 	if (iocb->aio_flags & IOCB_FLAG_RESFD) {
 		/*
 		 * If the IOCB_FLAG_RESFD flag of aio_flags is set, get an
-- 
1.7.12

