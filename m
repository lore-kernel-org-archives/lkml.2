Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757161Ab0D3UtZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 16:49:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1029 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754654Ab0D3UtI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 16:49:08 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: linux-aio@kvack.org
Cc: linux-kernel@vger.kernel.org, mjt@tls.msk.ru,
       Jeff Moyer <jmoyer@redhat.com>
Subject: [PATCH 1/2] compat: factor out compat_rw_copy_check_uvector from compat_do_readv_writev
Date: Fri, 30 Apr 2010 16:48:59 -0400
Message-Id: <1272660540-6567-2-git-send-email-jmoyer@redhat.com>
In-Reply-To: <1272660540-6567-1-git-send-email-jmoyer@redhat.com>
References: <1272660540-6567-1-git-send-email-jmoyer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch factors out code that will be used by both compat_do_readv_writev
and the compat aio submission code paths.

Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
---
 fs/compat.c            |  130 ++++++++++++++++++++++++++++-------------------
 include/linux/compat.h |    4 ++
 2 files changed, 81 insertions(+), 53 deletions(-)

diff --git a/fs/compat.c b/fs/compat.c
index 4b6ed03..ae0066d 100644
--- a/fs/compat.c
+++ b/fs/compat.c
@@ -568,6 +568,79 @@ out:
 	return ret;
 }
 
+/* A write operation does a read from user space and vice versa */
+#define vrfy_dir(type) ((type) == READ ? VERIFY_WRITE : VERIFY_READ)
+
+ssize_t compat_rw_copy_check_uvector(int type,
+		const struct compat_iovec __user *uvector, unsigned long nr_segs,
+		unsigned long fast_segs, struct iovec *fast_pointer,
+		struct iovec **ret_pointer)
+{
+	compat_ssize_t tot_len;
+	struct iovec *iov = *ret_pointer = fast_pointer;
+	ssize_t ret = 0;
+	int seg;
+
+	/*
+	 * SuS says "The readv() function *may* fail if the iovcnt argument
+	 * was less than or equal to 0, or greater than {IOV_MAX}.  Linux has
+	 * traditionally returned zero for zero segments, so...
+	 */
+	if (nr_segs == 0)
+		goto out;
+
+	ret = -EINVAL;
+	if (nr_segs > UIO_MAXIOV || nr_segs < 0)
+		goto out;
+	if (nr_segs > fast_segs) {
+		ret = -ENOMEM;
+		iov = kmalloc(nr_segs*sizeof(struct iovec), GFP_KERNEL);
+		if (iov == NULL) {
+			*ret_pointer = fast_pointer;
+			goto out;
+		}
+	}
+	*ret_pointer = iov;
+
+	/*
+	 * Single unix specification:
+	 * We should -EINVAL if an element length is not >= 0 and fitting an
+	 * ssize_t.  The total length is fitting an ssize_t
+	 *
+	 * Be careful here because iov_len is a size_t not an ssize_t
+	 */
+	tot_len = 0;
+	ret = -EINVAL;
+	for (seg = 0; seg < nr_segs; seg++) {
+		compat_ssize_t tmp = tot_len;
+		compat_uptr_t buf;
+		compat_ssize_t len;
+
+		if (__get_user(len, &uvector->iov_len) ||
+		   __get_user(buf, &uvector->iov_base)) {
+			ret = -EFAULT;
+			goto out;
+		}
+		if (len < 0)	/* size_t not fitting in compat_ssize_t .. */
+			goto out;
+		tot_len += len;
+		if (tot_len < tmp) /* maths overflow on the compat_ssize_t */
+			goto out;
+		if (!access_ok(vrfy_dir(type), buf, len)) {
+			ret = -EFAULT;
+			goto out;
+		}
+		iov->iov_base = compat_ptr(buf);
+		iov->iov_len = (compat_size_t) len;
+		uvector++;
+		iov++;
+	}
+	ret = tot_len;
+
+out:
+	return ret;
+}
+
 static inline long
 copy_iocb(long nr, u32 __user *ptr32, struct iocb __user * __user *ptr64)
 {
@@ -1077,70 +1150,21 @@ static ssize_t compat_do_readv_writev(int type, struct file *file,
 {
 	compat_ssize_t tot_len;
 	struct iovec iovstack[UIO_FASTIOV];
-	struct iovec *iov=iovstack, *vector;
+	struct iovec *iov;
 	ssize_t ret;
-	int seg;
 	io_fn_t fn;
 	iov_fn_t fnv;
 
-	/*
-	 * SuS says "The readv() function *may* fail if the iovcnt argument
-	 * was less than or equal to 0, or greater than {IOV_MAX}.  Linux has
-	 * traditionally returned zero for zero segments, so...
-	 */
-	ret = 0;
-	if (nr_segs == 0)
-		goto out;
-
-	/*
-	 * First get the "struct iovec" from user memory and
-	 * verify all the pointers
-	 */
 	ret = -EINVAL;
-	if ((nr_segs > UIO_MAXIOV) || (nr_segs <= 0))
-		goto out;
 	if (!file->f_op)
 		goto out;
-	if (nr_segs > UIO_FASTIOV) {
-		ret = -ENOMEM;
-		iov = kmalloc(nr_segs*sizeof(struct iovec), GFP_KERNEL);
-		if (!iov)
-			goto out;
-	}
+
 	ret = -EFAULT;
 	if (!access_ok(VERIFY_READ, uvector, nr_segs*sizeof(*uvector)))
 		goto out;
 
-	/*
-	 * Single unix specification:
-	 * We should -EINVAL if an element length is not >= 0 and fitting an
-	 * ssize_t.  The total length is fitting an ssize_t
-	 *
-	 * Be careful here because iov_len is a size_t not an ssize_t
-	 */
-	tot_len = 0;
-	vector = iov;
-	ret = -EINVAL;
-	for (seg = 0 ; seg < nr_segs; seg++) {
-		compat_ssize_t tmp = tot_len;
-		compat_ssize_t len;
-		compat_uptr_t buf;
-
-		if (__get_user(len, &uvector->iov_len) ||
-		    __get_user(buf, &uvector->iov_base)) {
-			ret = -EFAULT;
-			goto out;
-		}
-		if (len < 0)	/* size_t not fitting an compat_ssize_t .. */
-			goto out;
-		tot_len += len;
-		if (tot_len < tmp) /* maths overflow on the compat_ssize_t */
-			goto out;
-		vector->iov_base = compat_ptr(buf);
-		vector->iov_len = (compat_size_t) len;
-		uvector++;
-		vector++;
-	}
+	tot_len = compat_rw_copy_check_uvector(type, uvector, nr_segs,
+					       UIO_FASTIOV, iovstack, &iov);
 	if (tot_len == 0) {
 		ret = 0;
 		goto out;
diff --git a/include/linux/compat.h b/include/linux/compat.h
index 717c691..168f7da 100644
--- a/include/linux/compat.h
+++ b/include/linux/compat.h
@@ -356,5 +356,9 @@ asmlinkage long compat_sys_newfstatat(unsigned int dfd, char __user * filename,
 asmlinkage long compat_sys_openat(unsigned int dfd, const char __user *filename,
 				  int flags, int mode);
 
+extern ssize_t compat_rw_copy_check_uvector(int type,
+		const struct compat_iovec __user *uvector, unsigned long nr_segs,
+		unsigned long fast_segs, struct iovec *fast_pointer,
+		struct iovec **ret_pointer);
 #endif /* CONFIG_COMPAT */
 #endif /* _LINUX_COMPAT_H */
-- 
1.6.2.5

