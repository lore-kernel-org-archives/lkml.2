Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755510Ab2B0VXR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 16:23:17 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:33642 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755305Ab2B0VU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 16:20:26 -0500
From: Dave Kleikamp <dave.kleikamp@oracle.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Zach Brown <zab@zabbo.net>,
        Dave Kleikamp <dave.kleikamp@oracle.com>
Subject: [RFC PATCH 15/22] aio: add aio_kernel_() interface
Date: Mon, 27 Feb 2012 15:19:29 -0600
Message-Id: <1330377576-3659-16-git-send-email-dave.kleikamp@oracle.com>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1330377576-3659-1-git-send-email-dave.kleikamp@oracle.com>
References: <1330377576-3659-1-git-send-email-dave.kleikamp@oracle.com>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090205.4F4BF39A.002E,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zach Brown <zab@zabbo.net>

This adds an interface that lets kernel callers submit aio iocbs without
going through the user space syscalls.  This lets kernel callers avoid
the management limits and overhead of the context.  It will also let us
integrate aio operations with other kernel apis that the user space
interface doesn't have access to.

Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: Zach Brown <zab@zabbo.net>
---
 fs/aio.c            |   92 +++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/aio.h |   11 ++++++
 2 files changed, 103 insertions(+)

diff --git a/fs/aio.c b/fs/aio.c
index 969beb0..2e2d358 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -997,6 +997,10 @@ int aio_complete(struct kiocb *iocb, long res, long res2)
 		iocb->ki_users = 0;
 		wake_up_process(iocb->ki_obj.tsk);
 		return 1;
+	} else if (is_kernel_kiocb(iocb)) {
+		iocb->ki_obj.complete(iocb->ki_user_data, res);
+		aio_kernel_free(iocb);
+		return 0;
 	}
 
 	info = &ctx->ring_info;
@@ -1594,6 +1598,94 @@ static ssize_t aio_setup_iocb(struct kiocb *kiocb, bool compat)
 	return 0;
 }
 
+ /*
+ * This allocates an iocb that will be used to submit and track completion of
+ * an IO that is issued from kernel space.
+ *
+ * The caller is expected to call the appropriate aio_kernel_init_() functions
+ * and then call aio_kernel_submit().  From that point forward progress is
+ * guaranteed by the file system aio method.  Eventually the caller's
+ * completion callback will be called.
+ *
+ * These iocbs are special.  They don't have a context, we don't limit the
+ * number pending, they can't be canceled, and can't be retried.  In the short
+ * term callers need to be careful not to call operations which might retry by
+ * only calling new ops which never add retry support.  In the long term
+ * retry-based AIO should be removed.
+ */
+struct kiocb *aio_kernel_alloc(gfp_t gfp)
+{
+	struct kiocb *iocb = kzalloc(sizeof(struct kiocb), gfp);
+	if (iocb)
+		iocb->ki_key = KIOCB_KERNEL_KEY;
+	return iocb;
+}
+EXPORT_SYMBOL_GPL(aio_kernel_alloc);
+
+void aio_kernel_free(struct kiocb *iocb)
+{
+	kfree(iocb);
+}
+EXPORT_SYMBOL_GPL(aio_kernel_free);
+
+/*
+ * ptr and count can be a buff and bytes or an iov and segs.
+ */
+void aio_kernel_init_rw(struct kiocb *iocb, struct file *filp,
+			unsigned short op, void *ptr, size_t nr, loff_t off)
+{
+	iocb->ki_filp = filp;
+	iocb->ki_opcode = op;
+	iocb->ki_buf = (char __user *)(unsigned long)ptr;
+	iocb->ki_left = nr;
+	iocb->ki_nbytes = nr;
+	iocb->ki_pos = off;
+}
+EXPORT_SYMBOL_GPL(aio_kernel_init_rw);
+
+void aio_kernel_init_callback(struct kiocb *iocb,
+			      void (*complete)(u64 user_data, long res),
+			      u64 user_data)
+{
+	iocb->ki_obj.complete = complete;
+	iocb->ki_user_data = user_data;
+}
+EXPORT_SYMBOL_GPL(aio_kernel_init_callback);
+
+/*
+ * The iocb is our responsibility once this is called.  The caller must not
+ * reference it.  This comes from aio_setup_iocb() modifying the iocb.
+ *
+ * Callers must be prepared for their iocb completion callback to be called the
+ * moment they enter this function.  The completion callback may be called from
+ * any context.
+ *
+ * Returns: 0: the iocb completion callback will be called with the op result
+ * negative errno: the operation was not submitted and the iocb was freed
+ */
+int aio_kernel_submit(struct kiocb *iocb)
+{
+	int ret;
+
+	BUG_ON(!is_kernel_kiocb(iocb));
+	BUG_ON(!iocb->ki_obj.complete);
+	BUG_ON(!iocb->ki_filp);
+
+	ret = aio_setup_iocb(iocb, 0);
+	if (ret) {
+		aio_kernel_free(iocb);
+		return ret;
+	}
+
+	ret = iocb->ki_retry(iocb);
+	BUG_ON(ret == -EIOCBRETRY);
+	if (ret != -EIOCBQUEUED)
+		aio_complete(iocb, ret, 0);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(aio_kernel_submit);
+
 static int io_submit_one(struct kioctx *ctx, struct iocb __user *user_iocb,
 			 struct iocb *iocb, struct kiocb_batch *batch,
 			 bool compat)
diff --git a/include/linux/aio.h b/include/linux/aio.h
index 2314ad8..96e8e69 100644
--- a/include/linux/aio.h
+++ b/include/linux/aio.h
@@ -24,6 +24,7 @@ struct kioctx;
 #define KIOCB_C_COMPLETE	0x02
 
 #define KIOCB_SYNC_KEY		(~0U)
+#define KIOCB_KERNEL_KEY		(~1U)
 
 /* ki_flags bits */
 /*
@@ -99,6 +100,7 @@ struct kiocb {
 	union {
 		void __user		*user;
 		struct task_struct	*tsk;
+		void			(*complete)(u64 user_data, long res);
 	} ki_obj;
 
 	__u64			ki_user_data;	/* user's data for completion */
@@ -127,6 +129,7 @@ struct kiocb {
 };
 
 #define is_sync_kiocb(iocb)	((iocb)->ki_key == KIOCB_SYNC_KEY)
+#define is_kernel_kiocb(iocb)	((iocb)->ki_key == KIOCB_KERNEL_KEY)
 #define init_sync_kiocb(x, filp)			\
 	do {						\
 		struct task_struct *tsk = current;	\
@@ -215,6 +218,14 @@ struct mm_struct;
 extern void exit_aio(struct mm_struct *mm);
 extern long do_io_submit(aio_context_t ctx_id, long nr,
 			 struct iocb __user *__user *iocbpp, bool compat);
+struct kiocb *aio_kernel_alloc(gfp_t gfp);
+void aio_kernel_free(struct kiocb *iocb);
+void aio_kernel_init_rw(struct kiocb *iocb, struct file *filp,
+			unsigned short op, void *ptr, size_t nr, loff_t off);
+void aio_kernel_init_callback(struct kiocb *iocb,
+			      void (*complete)(u64 user_data, long res),
+			      u64 user_data);
+int aio_kernel_submit(struct kiocb *iocb);
 #else
 static inline ssize_t wait_on_sync_kiocb(struct kiocb *iocb) { return 0; }
 static inline int aio_put_req(struct kiocb *iocb) { return 0; }
-- 
1.7.9.2

