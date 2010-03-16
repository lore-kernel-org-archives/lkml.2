Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934237Ab0CPSwj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 14:52:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55371 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933677Ab0CPSwh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 14:52:37 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: linux-aio@kvack.org, Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: aio: compat_ioctl issue?
References: <4B956E5B.9020302@msgid.tls.msk.ru>
	<x497hpm8p69.fsf@segfault.boston.devel.redhat.com>
	<4B957122.4060007@msgid.tls.msk.ru>
	<x49mxyi78ob.fsf@segfault.boston.devel.redhat.com>
	<4B957AF3.6040801@msgid.tls.msk.ru>
	<4B957D20.4010904@msgid.tls.msk.ru>
	<x49wrxij11s.fsf@segfault.boston.devel.redhat.com>
	<4B994022.6030703@msgid.tls.msk.ru>
	<4B994888.8020007@msgid.tls.msk.ru>
	<x49eijqiqcd.fsf@segfault.boston.devel.redhat.com>
	<4B994EFE.70005@msgid.tls.msk.ru>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Tue, 16 Mar 2010 14:52:26 -0400
In-Reply-To: <4B994EFE.70005@msgid.tls.msk.ru> (Michael Tokarev's message of
	"Thu, 11 Mar 2010 23:13:50 +0300")
Message-ID: <x49d3z4t7yt.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Tokarev <mjt@tls.msk.ru> writes:

> Jeff Moyer wrote:
>> Michael Tokarev <mjt@tls.msk.ru> writes:
> []
>>> And when running real thing it crashes.   I tested it
>>> on 2.6.32 (trivial corrections to the patch required).
>> 
>> Could you just post your version of the patch so I can have a look?
>
> I think there's no need since in 2.6.33 (where your patch applies
> without any offsets) it crashes in exactly the same way:

Sorry for taking so long on this.  I only tested the case where niovs >
fast_segs, and I missed an obvious thing: I didn't assign the return
pointer to the proper iovec.

So, this patch should get you going.

Cheers,
Jeff

diff --git a/fs/aio.c b/fs/aio.c
index 1cf12b3..5a38805 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -36,6 +36,7 @@
 #include <linux/blkdev.h>
 #include <linux/mempool.h>
 #include <linux/hash.h>
+#include <linux/compat.h>
 
 #include <asm/kmap_types.h>
 #include <asm/uaccess.h>
@@ -1384,13 +1385,20 @@ static ssize_t aio_fsync(struct kiocb *iocb)
 	return ret;
 }
 
-static ssize_t aio_setup_vectored_rw(int type, struct kiocb *kiocb)
+static ssize_t aio_setup_vectored_rw(int type, struct kiocb *kiocb, bool compat)
 {
 	ssize_t ret;
 
-	ret = rw_copy_check_uvector(type, (struct iovec __user *)kiocb->ki_buf,
-				    kiocb->ki_nbytes, 1,
-				    &kiocb->ki_inline_vec, &kiocb->ki_iovec);
+	if (compat)
+		ret = compat_rw_copy_check_uvector(type,
+				(struct compat_iovec __user *)kiocb->ki_buf,
+				kiocb->ki_nbytes, 1, &kiocb->ki_inline_vec,
+				&kiocb->ki_iovec);
+	else
+		ret = rw_copy_check_uvector(type,
+				(struct iovec __user *)kiocb->ki_buf,
+				kiocb->ki_nbytes, 1, &kiocb->ki_inline_vec,
+				&kiocb->ki_iovec);
 	if (ret < 0)
 		goto out;
 
@@ -1420,7 +1428,7 @@ static ssize_t aio_setup_single_vector(struct kiocb *kiocb)
  *	Performs the initial checks and aio retry method
  *	setup for the kiocb at the time of io submission.
  */
-static ssize_t aio_setup_iocb(struct kiocb *kiocb)
+static ssize_t aio_setup_iocb(struct kiocb *kiocb, bool compat)
 {
 	struct file *file = kiocb->ki_filp;
 	ssize_t ret = 0;
@@ -1469,7 +1477,7 @@ static ssize_t aio_setup_iocb(struct kiocb *kiocb)
 		ret = security_file_permission(file, MAY_READ);
 		if (unlikely(ret))
 			break;
-		ret = aio_setup_vectored_rw(READ, kiocb);
+		ret = aio_setup_vectored_rw(READ, kiocb, compat);
 		if (ret)
 			break;
 		ret = -EINVAL;
@@ -1483,7 +1491,7 @@ static ssize_t aio_setup_iocb(struct kiocb *kiocb)
 		ret = security_file_permission(file, MAY_WRITE);
 		if (unlikely(ret))
 			break;
-		ret = aio_setup_vectored_rw(WRITE, kiocb);
+		ret = aio_setup_vectored_rw(WRITE, kiocb, compat);
 		if (ret)
 			break;
 		ret = -EINVAL;
@@ -1548,7 +1556,8 @@ static void aio_batch_free(struct hlist_head *batch_hash)
 }
 
 static int io_submit_one(struct kioctx *ctx, struct iocb __user *user_iocb,
-			 struct iocb *iocb, struct hlist_head *batch_hash)
+			 struct iocb *iocb, struct hlist_head *batch_hash,
+			 bool compat)
 {
 	struct kiocb *req;
 	struct file *file;
@@ -1609,7 +1618,7 @@ static int io_submit_one(struct kioctx *ctx, struct iocb __user *user_iocb,
 	req->ki_left = req->ki_nbytes = iocb->aio_nbytes;
 	req->ki_opcode = iocb->aio_lio_opcode;
 
-	ret = aio_setup_iocb(req);
+	ret = aio_setup_iocb(req, compat);
 
 	if (ret)
 		goto out_put_req;
@@ -1637,20 +1646,8 @@ out_put_req:
 	return ret;
 }
 
-/* sys_io_submit:
- *	Queue the nr iocbs pointed to by iocbpp for processing.  Returns
- *	the number of iocbs queued.  May return -EINVAL if the aio_context
- *	specified by ctx_id is invalid, if nr is < 0, if the iocb at
- *	*iocbpp[0] is not properly initialized, if the operation specified
- *	is invalid for the file descriptor in the iocb.  May fail with
- *	-EFAULT if any of the data structures point to invalid data.  May
- *	fail with -EBADF if the file descriptor specified in the first
- *	iocb is invalid.  May fail with -EAGAIN if insufficient resources
- *	are available to queue any iocbs.  Will return 0 if nr is 0.  Will
- *	fail with -ENOSYS if not implemented.
- */
-SYSCALL_DEFINE3(io_submit, aio_context_t, ctx_id, long, nr,
-		struct iocb __user * __user *, iocbpp)
+long do_io_submit(aio_context_t ctx_id, long nr,
+		  struct iocb __user *__user * iocbpp, bool compat)
 {
 	struct kioctx *ctx;
 	long ret = 0;
@@ -1687,7 +1684,7 @@ SYSCALL_DEFINE3(io_submit, aio_context_t, ctx_id, long, nr,
 			break;
 		}
 
-		ret = io_submit_one(ctx, user_iocb, &tmp, batch_hash);
+		ret = io_submit_one(ctx, user_iocb, &tmp, batch_hash, compat);
 		if (ret)
 			break;
 	}
@@ -1696,6 +1693,24 @@ SYSCALL_DEFINE3(io_submit, aio_context_t, ctx_id, long, nr,
 	put_ioctx(ctx);
 	return i ? i : ret;
 }
+		  
+/* sys_io_submit:
+ *	Queue the nr iocbs pointed to by iocbpp for processing.  Returns
+ *	the number of iocbs queued.  May return -EINVAL if the aio_context
+ *	specified by ctx_id is invalid, if nr is < 0, if the iocb at
+ *	*iocbpp[0] is not properly initialized, if the operation specified
+ *	is invalid for the file descriptor in the iocb.  May fail with
+ *	-EFAULT if any of the data structures point to invalid data.  May
+ *	fail with -EBADF if the file descriptor specified in the first
+ *	iocb is invalid.  May fail with -EAGAIN if insufficient resources
+ *	are available to queue any iocbs.  Will return 0 if nr is 0.  Will
+ *	fail with -ENOSYS if not implemented.
+ */
+SYSCALL_DEFINE3(io_submit, aio_context_t, ctx_id, long, nr,
+		struct iocb __user * __user *, iocbpp)
+{
+	return do_io_submit(ctx_id, nr, iocbpp, 0);
+}
 
 /* lookup_kiocb
  *	Finds a given iocb for cancellation.
diff --git a/fs/compat.c b/fs/compat.c
index 00d90c2..efbcb31 100644
--- a/fs/compat.c
+++ b/fs/compat.c
@@ -567,6 +567,61 @@ out:
 	return ret;
 }
 
+/* A write operation does a read from user space and vice versa */
+#define vrfy_dir(type) ((type) == READ ? VERIFY_WRITE : VERIFY_READ)
+
+ssize_t compat_rw_copy_check_uvector(int type,
+		const struct compat_iovec __user *uiov32, unsigned long niov,
+		unsigned long fast_segs, struct iovec *fast_pointer,
+		struct iovec **ret_pointer)
+{
+	ssize_t tot_len = 0;
+	struct iovec *kiov = fast_pointer;
+
+	if (niov == 0)
+		goto out;
+	if (niov > UIO_MAXIOV) {
+		tot_len = -EINVAL;
+		goto out;
+	}
+	if (niov > fast_segs) {
+		kiov = kmalloc(niov*sizeof(struct iovec), GFP_KERNEL);
+		if (kiov == NULL) {
+			tot_len = -ENOMEM;
+			goto out;
+		}
+	}
+	*ret_pointer = kiov;
+
+	while (niov > 0) {
+		compat_uptr_t buf;
+		compat_size_t len;
+
+		if (get_user(len, &uiov32->iov_len) ||
+		   get_user(buf, &uiov32->iov_base)) {
+			tot_len = -EFAULT;
+			goto out;
+		}
+		if (len < 0 || (tot_len + len < tot_len)) {
+			tot_len = -EINVAL;
+			goto out;
+		}
+		if (!access_ok(vrfy_dir(type), buf, len)) {
+			tot_len = -EFAULT;
+			goto out;
+		}
+		tot_len += len;
+		kiov->iov_base = compat_ptr(buf);
+		kiov->iov_len = (__kernel_size_t) len;
+		uiov32++;
+		kiov++;
+		niov--;
+	}
+
+out:
+	return tot_len;
+}
+
 static inline long
 copy_iocb(long nr, u32 __user *ptr32, struct iocb __user * __user *ptr64)
 {
@@ -599,7 +654,7 @@ compat_sys_io_submit(aio_context_t ctx_id, int nr, u32 __user *iocb)
 	iocb64 = compat_alloc_user_space(nr * sizeof(*iocb64));
 	ret = copy_iocb(nr, iocb, iocb64);
 	if (!ret)
-		ret = sys_io_submit(ctx_id, nr, iocb64);
+		ret = do_io_submit(ctx_id, nr, iocb64, 1);
 	return ret;
 }
 
diff --git a/include/linux/aio.h b/include/linux/aio.h
index 811dbb3..54b6ef8 100644
--- a/include/linux/aio.h
+++ b/include/linux/aio.h
@@ -212,6 +212,8 @@ extern void kick_iocb(struct kiocb *iocb);
 extern int aio_complete(struct kiocb *iocb, long res, long res2);
 struct mm_struct;
 extern void exit_aio(struct mm_struct *mm);
+extern long do_io_submit(aio_context_t ctx_id, long nr,
+			 struct iocb __user *__user * iocbpp, bool compat);
 #else
 static inline ssize_t wait_on_sync_kiocb(struct kiocb *iocb) { return 0; }
 static inline int aio_put_req(struct kiocb *iocb) { return 0; }
@@ -219,6 +221,9 @@ static inline void kick_iocb(struct kiocb *iocb) { }
 static inline int aio_complete(struct kiocb *iocb, long res, long res2) { return 0; }
 struct mm_struct;
 static inline void exit_aio(struct mm_struct *mm) { }
+static inline long do_io_submit(aio_context_t ctx_id, long nr,
+				struct iocb __user * __user * iocbpp,
+				bool compat) { }
 #endif /* CONFIG_AIO */
 
 static inline struct kiocb *list_kiocb(struct list_head *h)
diff --git a/include/linux/compat.h b/include/linux/compat.h
index ef68119..8251f61 100644
--- a/include/linux/compat.h
+++ b/include/linux/compat.h
@@ -353,5 +353,9 @@ asmlinkage long compat_sys_newfstatat(unsigned int dfd, char __user * filename,
 asmlinkage long compat_sys_openat(unsigned int dfd, const char __user *filename,
 				  int flags, int mode);
 
+extern ssize_t compat_rw_copy_check_uvector(int type,
+		const struct compat_iovec __user *uiov32, unsigned long niov,
+		unsigned long fast_segs, struct iovec *fast_pointer,
+		struct iovec **ret_pointer);
 #endif /* CONFIG_COMPAT */
 #endif /* _LINUX_COMPAT_H */
