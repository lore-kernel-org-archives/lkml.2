Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934060Ab2GLPfR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 11:35:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63597 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933947Ab2GLPfN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 11:35:13 -0400
From: Asias He <asias@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        Benjamin LaHaise <bcrl@kvack.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Michael S. Tsirkin" <mst@redhat.com>, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org, Asias He <asias@redhat.com>
Subject: [PATCH 1/5] aio: Export symbols and struct kiocb_batch for in kernel aio usage
Date: Thu, 12 Jul 2012 23:35:02 +0800
Message-Id: <1342107302-28116-2-git-send-email-asias@redhat.com>
In-Reply-To: <1342107302-28116-1-git-send-email-asias@redhat.com>
References: <1342107302-28116-1-git-send-email-asias@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is useful for people who want to use aio in kernel, e.g. vhost-blk.

Signed-off-by: Asias He <asias@redhat.com>
---
 fs/aio.c            |   37 ++++++++++++++++++-------------------
 include/linux/aio.h |   21 +++++++++++++++++++++
 2 files changed, 39 insertions(+), 19 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index 55c4c76..93dfbdd 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -224,22 +224,24 @@ static void __put_ioctx(struct kioctx *ctx)
 	call_rcu(&ctx->rcu_head, ctx_rcu_free);
 }
 
-static inline int try_get_ioctx(struct kioctx *kioctx)
+inline int try_get_ioctx(struct kioctx *kioctx)
 {
 	return atomic_inc_not_zero(&kioctx->users);
 }
+EXPORT_SYMBOL(try_get_ioctx);
 
-static inline void put_ioctx(struct kioctx *kioctx)
+inline void put_ioctx(struct kioctx *kioctx)
 {
 	BUG_ON(atomic_read(&kioctx->users) <= 0);
 	if (unlikely(atomic_dec_and_test(&kioctx->users)))
 		__put_ioctx(kioctx);
 }
+EXPORT_SYMBOL(put_ioctx);
 
 /* ioctx_alloc
  *	Allocates and initializes an ioctx.  Returns an ERR_PTR if it failed.
  */
-static struct kioctx *ioctx_alloc(unsigned nr_events)
+struct kioctx *ioctx_alloc(unsigned nr_events)
 {
 	struct mm_struct *mm;
 	struct kioctx *ctx;
@@ -303,6 +305,7 @@ out_freectx:
 	dprintk("aio: error allocating ioctx %d\n", err);
 	return ERR_PTR(err);
 }
+EXPORT_SYMBOL(ioctx_alloc);
 
 /* kill_ctx
  *	Cancels all outstanding aio requests on an aio context.  Used 
@@ -436,23 +439,14 @@ static struct kiocb *__aio_get_req(struct kioctx *ctx)
 	return req;
 }
 
-/*
- * struct kiocb's are allocated in batches to reduce the number of
- * times the ctx lock is acquired and released.
- */
-#define KIOCB_BATCH_SIZE	32L
-struct kiocb_batch {
-	struct list_head head;
-	long count; /* number of requests left to allocate */
-};
-
-static void kiocb_batch_init(struct kiocb_batch *batch, long total)
+void kiocb_batch_init(struct kiocb_batch *batch, long total)
 {
 	INIT_LIST_HEAD(&batch->head);
 	batch->count = total;
 }
+EXPORT_SYMBOL(kiocb_batch_init);
 
-static void kiocb_batch_free(struct kioctx *ctx, struct kiocb_batch *batch)
+void kiocb_batch_free(struct kioctx *ctx, struct kiocb_batch *batch)
 {
 	struct kiocb *req, *n;
 
@@ -470,6 +464,7 @@ static void kiocb_batch_free(struct kioctx *ctx, struct kiocb_batch *batch)
 		wake_up_all(&ctx->wait);
 	spin_unlock_irq(&ctx->ctx_lock);
 }
+EXPORT_SYMBOL(kiocb_batch_free);
 
 /*
  * Allocate a batch of kiocbs.  This avoids taking and dropping the
@@ -540,7 +535,7 @@ out:
 	return allocated;
 }
 
-static inline struct kiocb *aio_get_req(struct kioctx *ctx,
+inline struct kiocb *aio_get_req(struct kioctx *ctx,
 					struct kiocb_batch *batch)
 {
 	struct kiocb *req;
@@ -552,6 +547,7 @@ static inline struct kiocb *aio_get_req(struct kioctx *ctx,
 	list_del(&req->ki_batch);
 	return req;
 }
+EXPORT_SYMBOL(aio_get_req);
 
 static inline void really_put_req(struct kioctx *ctx, struct kiocb *req)
 {
@@ -721,7 +717,7 @@ static inline int __queue_kicked_iocb(struct kiocb *iocb)
  * simplifies the coding of individual aio operations as
  * it avoids various potential races.
  */
-static ssize_t aio_run_iocb(struct kiocb *iocb)
+ssize_t aio_run_iocb(struct kiocb *iocb)
 {
 	struct kioctx	*ctx = iocb->ki_ctx;
 	ssize_t (*retry)(struct kiocb *);
@@ -815,6 +811,7 @@ out:
 	}
 	return ret;
 }
+EXPORT_SYMBOL(aio_run_iocb);
 
 /*
  * __aio_run_iocbs:
@@ -1136,7 +1133,7 @@ static inline void clear_timeout(struct aio_timeout *to)
 	del_singleshot_timer_sync(&to->timer);
 }
 
-static int read_events(struct kioctx *ctx,
+int read_events(struct kioctx *ctx,
 			long min_nr, long nr,
 			struct io_event __user *event,
 			struct timespec __user *timeout)
@@ -1252,6 +1249,7 @@ out:
 	destroy_timer_on_stack(&to.timer);
 	return i ? i : ret;
 }
+EXPORT_SYMBOL(read_events);
 
 /* Take an ioctx and remove it from the list of ioctx's.  Protects 
  * against races with itself via ->dead.
@@ -1492,7 +1490,7 @@ static ssize_t aio_setup_single_vector(int type, struct file * file, struct kioc
  *	Performs the initial checks and aio retry method
  *	setup for the kiocb at the time of io submission.
  */
-static ssize_t aio_setup_iocb(struct kiocb *kiocb, bool compat)
+ssize_t aio_setup_iocb(struct kiocb *kiocb, bool compat)
 {
 	struct file *file = kiocb->ki_filp;
 	ssize_t ret = 0;
@@ -1570,6 +1568,7 @@ static ssize_t aio_setup_iocb(struct kiocb *kiocb, bool compat)
 
 	return 0;
 }
+EXPORT_SYMBOL(aio_setup_iocb);
 
 static int io_submit_one(struct kioctx *ctx, struct iocb __user *user_iocb,
 			 struct iocb *iocb, struct kiocb_batch *batch,
diff --git a/include/linux/aio.h b/include/linux/aio.h
index b1a520e..4731da5 100644
--- a/include/linux/aio.h
+++ b/include/linux/aio.h
@@ -126,6 +126,16 @@ struct kiocb {
 	struct eventfd_ctx	*ki_eventfd;
 };
 
+/*
+ * struct kiocb's are allocated in batches to reduce the number of
+ * times the ctx lock is acquired and released.
+ */
+#define KIOCB_BATCH_SIZE	32L
+struct kiocb_batch {
+	struct list_head head;
+	long count; /* number of requests left to allocate */
+};
+
 #define is_sync_kiocb(iocb)	((iocb)->ki_key == KIOCB_SYNC_KEY)
 #define init_sync_kiocb(x, filp)			\
 	do {						\
@@ -216,6 +226,17 @@ struct mm_struct;
 extern void exit_aio(struct mm_struct *mm);
 extern long do_io_submit(aio_context_t ctx_id, long nr,
 			 struct iocb __user *__user *iocbpp, bool compat);
+extern struct kioctx *ioctx_alloc(unsigned nr_events);
+extern ssize_t aio_run_iocb(struct kiocb *iocb);
+extern int read_events(struct kioctx *ctx, long min_nr, long nr,
+		       struct io_event __user *event,
+		       struct timespec __user *timeout);
+extern ssize_t aio_setup_iocb(struct kiocb *kiocb, bool compat);
+extern void kiocb_batch_init(struct kiocb_batch *batch, long total);
+extern void kiocb_batch_free(struct kioctx *ctx, struct kiocb_batch *batch);
+extern struct kiocb *aio_get_req(struct kioctx *ctx, struct kiocb_batch *batch);
+extern int try_get_ioctx(struct kioctx *kioctx);
+extern void put_ioctx(struct kioctx *kioctx);
 #else
 static inline ssize_t wait_on_sync_kiocb(struct kiocb *iocb) { return 0; }
 static inline int aio_put_req(struct kiocb *iocb) { return 0; }
-- 
1.7.10.4

