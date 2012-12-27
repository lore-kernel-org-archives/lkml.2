Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752293Ab2L0CDM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2012 21:03:12 -0500
Received: from mail-da0-f49.google.com ([209.85.210.49]:56199 "EHLO
	mail-da0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752093Ab2L0CBA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2012 21:01:00 -0500
From: Kent Overstreet <koverstreet@google.com>
To: linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org
Cc: Kent Overstreet <koverstreet@google.com>, zab@redhat.com, bcrl@kvack.org,
        jmoyer@redhat.com, axboe@kernel.dk, viro@zeniv.linux.org.uk,
        tytso@mit.edu
Subject: [PATCH 27/32] aio: Kill ki_key
Date: Wed, 26 Dec 2012 18:00:06 -0800
Message-Id: <1356573611-18590-30-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1356573611-18590-1-git-send-email-koverstreet@google.com>
References: <1356573611-18590-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ki_key wasn't actually used for anything previously - it was always 0.
Drop it to trim struct kiocb a bit.

Signed-off-by: Kent Overstreet <koverstreet@google.com>
---
 fs/aio.c            | 7 +++++--
 include/linux/aio.h | 9 ++++-----
 2 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index fcd1f38..f6bf227 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -1193,7 +1193,7 @@ static int io_submit_one(struct kioctx *ctx, struct iocb __user *user_iocb,
 		}
 	}
 
-	ret = put_user(req->ki_key, &user_iocb->aio_key);
+	ret = put_user(KIOCB_KEY, &user_iocb->aio_key);
 	if (unlikely(ret)) {
 		pr_debug("EFAULT: aio_key\n");
 		goto out_put_req;
@@ -1314,10 +1314,13 @@ static struct kiocb *lookup_kiocb(struct kioctx *ctx, struct iocb __user *iocb,
 
 	assert_spin_locked(&ctx->ctx_lock);
 
+	if (key != KIOCB_KEY)
+		return NULL;
+
 	/* TODO: use a hash or array, this sucks. */
 	list_for_each(pos, &ctx->active_reqs) {
 		struct kiocb *kiocb = list_kiocb(pos);
-		if (kiocb->ki_obj.user == iocb && kiocb->ki_key == key)
+		if (kiocb->ki_obj.user == iocb)
 			return kiocb;
 	}
 	return NULL;
diff --git a/include/linux/aio.h b/include/linux/aio.h
index 58adc56..76a6e59 100644
--- a/include/linux/aio.h
+++ b/include/linux/aio.h
@@ -12,7 +12,7 @@
 struct kioctx;
 struct kiocb;
 
-#define KIOCB_SYNC_KEY		(~0U)
+#define KIOCB_KEY		0
 
 #define KIOCB_CANCELLED		((void *) (~0ULL))
 
@@ -45,10 +45,9 @@ typedef int (kiocb_cancel_fn)(struct kiocb *, struct io_event *);
  */
 struct kiocb {
 	atomic_t		ki_users;
-	unsigned		ki_key;		/* id of this request */
 
 	struct file		*ki_filp;
-	struct kioctx		*ki_ctx;	/* may be NULL for sync ops */
+	struct kioctx		*ki_ctx;	/* NULL for sync ops */
 	kiocb_cancel_fn		*ki_cancel;
 	ssize_t			(*ki_retry)(struct kiocb *);
 	void			(*ki_dtor)(struct kiocb *);
@@ -84,14 +83,14 @@ struct kiocb {
 
 static inline bool is_sync_kiocb(struct kiocb *kiocb)
 {
-	return kiocb->ki_key == KIOCB_SYNC_KEY;
+	return kiocb->ki_ctx == NULL;
 }
 
 static inline void init_sync_kiocb(struct kiocb *kiocb, struct file *filp)
 {
 	*kiocb = (struct kiocb) {
 			.ki_users = ATOMIC_INIT(1),
-			.ki_key = KIOCB_SYNC_KEY,
+			.ki_ctx = NULL,
 			.ki_filp = filp,
 			.ki_obj.tsk = current,
 		};
-- 
1.7.12

