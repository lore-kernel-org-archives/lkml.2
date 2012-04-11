Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758139Ab2DKLgm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 07:36:42 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:48866 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754856Ab2DKLgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 07:36:39 -0400
Date: Wed, 11 Apr 2012 21:06:04 +0930
From: Christopher Yeoh <cyeoh@au1.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [RESEND][PATCH] Cleanup of rw_copy_check_uvector and
 compat_rw_copy_check_uvector
Message-ID: <20120411210604.26d04483@Gantu>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
x-cbid: 12041102-3568-0000-0000-00000184BF9F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

Resending this patch which I first sent a couple of months ago and
didn't notice it didn't go in at the time.

This is the cleanup of rw_copy_check_uvector and
compat_rw_copy_check_uvector after changes made to support CMA in an
earlier patch. Rather than having an additional check_access parameter
to these functions, the first paramater type is overloaded to allow the
caller to specify CHECK_IOVEC_ONLY which means check that the contents
of the iovec are valid, but do not check the memory that they point to.
This is used by process_vm_readv/writev where we need to validate that a
iovec passed to the syscall is valid but do not want to check the
memory that it points to at this point because it refers to an address
space in another process.

Regards,

Chris
-- 
cyeoh@au.ibm.com

Signed-off-by: Chris Yeoh <yeohc@au1.ibm.com>
 fs/aio.c               |    4 ++--
 fs/compat.c            |    6 +++---
 fs/read_write.c        |    7 +++----
 include/linux/compat.h |    3 +--
 include/linux/fs.h     |   12 ++++++++++--
 mm/process_vm_access.c |   16 ++++++++--------
 security/keys/compat.c |    2 +-
 security/keys/keyctl.c |    2 +-
 8 files changed, 29 insertions(+), 23 deletions(-)
diff --git a/fs/aio.c b/fs/aio.c
index da88760..f8103ad 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -1436,13 +1436,13 @@ static ssize_t aio_setup_vectored_rw(int type, struct kiocb *kiocb, bool compat)
 		ret = compat_rw_copy_check_uvector(type,
 				(struct compat_iovec __user *)kiocb->ki_buf,
 				kiocb->ki_nbytes, 1, &kiocb->ki_inline_vec,
-				&kiocb->ki_iovec, 1);
+				&kiocb->ki_iovec);
 	else
 #endif
 		ret = rw_copy_check_uvector(type,
 				(struct iovec __user *)kiocb->ki_buf,
 				kiocb->ki_nbytes, 1, &kiocb->ki_inline_vec,
-				&kiocb->ki_iovec, 1);
+				&kiocb->ki_iovec);
 	if (ret < 0)
 		goto out;
 
diff --git a/fs/compat.c b/fs/compat.c
index f2944ac..f161cfe 100644
--- a/fs/compat.c
+++ b/fs/compat.c
@@ -532,7 +532,7 @@ out:
 ssize_t compat_rw_copy_check_uvector(int type,
 		const struct compat_iovec __user *uvector, unsigned long nr_segs,
 		unsigned long fast_segs, struct iovec *fast_pointer,
-		struct iovec **ret_pointer, int check_access)
+		struct iovec **ret_pointer)
 {
 	compat_ssize_t tot_len;
 	struct iovec *iov = *ret_pointer = fast_pointer;
@@ -579,7 +579,7 @@ ssize_t compat_rw_copy_check_uvector(int type,
 		}
 		if (len < 0)	/* size_t not fitting in compat_ssize_t .. */
 			goto out;
-		if (check_access &&
+		if (type >= 0 &&
 		    !access_ok(vrfy_dir(type), compat_ptr(buf), len)) {
 			ret = -EFAULT;
 			goto out;
@@ -1094,7 +1094,7 @@ static ssize_t compat_do_readv_writev(int type, struct file *file,
 		goto out;
 
 	tot_len = compat_rw_copy_check_uvector(type, uvector, nr_segs,
-					       UIO_FASTIOV, iovstack, &iov, 1);
+					       UIO_FASTIOV, iovstack, &iov);
 	if (tot_len == 0) {
 		ret = 0;
 		goto out;
diff --git a/fs/read_write.c b/fs/read_write.c
index ffc99d2..c20614f 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -633,8 +633,7 @@ ssize_t do_loop_readv_writev(struct file *filp, struct iovec *iov,
 ssize_t rw_copy_check_uvector(int type, const struct iovec __user * uvector,
 			      unsigned long nr_segs, unsigned long fast_segs,
 			      struct iovec *fast_pointer,
-			      struct iovec **ret_pointer,
-			      int check_access)
+			      struct iovec **ret_pointer)
 {
 	unsigned long seg;
 	ssize_t ret;
@@ -690,7 +689,7 @@ ssize_t rw_copy_check_uvector(int type, const struct iovec __user * uvector,
 			ret = -EINVAL;
 			goto out;
 		}
-		if (check_access
+		if (type >= 0
 		    && unlikely(!access_ok(vrfy_dir(type), buf, len))) {
 			ret = -EFAULT;
 			goto out;
@@ -723,7 +722,7 @@ static ssize_t do_readv_writev(int type, struct file *file,
 	}
 
 	ret = rw_copy_check_uvector(type, uvector, nr_segs,
-				    ARRAY_SIZE(iovstack), iovstack, &iov, 1);
+				    ARRAY_SIZE(iovstack), iovstack, &iov);
 	if (ret <= 0)
 		goto out;
 
diff --git a/include/linux/compat.h b/include/linux/compat.h
index 5d46217..4e89039 100644
--- a/include/linux/compat.h
+++ b/include/linux/compat.h
@@ -577,8 +577,7 @@ extern ssize_t compat_rw_copy_check_uvector(int type,
 		const struct compat_iovec __user *uvector,
 		unsigned long nr_segs,
 		unsigned long fast_segs, struct iovec *fast_pointer,
-		struct iovec **ret_pointer,
-		int check_access);
+		struct iovec **ret_pointer);
 
 extern void __user *compat_alloc_user_space(unsigned long len);
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 8de6755..1e53d5a 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -173,6 +173,15 @@ struct inodes_stat_t {
 #define WRITE_FUA		(WRITE | REQ_SYNC | REQ_NOIDLE | REQ_FUA)
 #define WRITE_FLUSH_FUA		(WRITE | REQ_SYNC | REQ_NOIDLE | REQ_FLUSH | REQ_FUA)
 
+
+/*
+ * Flag for rw_copy_check_uvector and compat_rw_copy_check_uvector
+ * that indicates that they should check the contents of the iovec are
+ * valid, but not check the memory that the iovec elements
+ * points too.
+ */
+#define CHECK_IOVEC_ONLY -1
+
 #define SEL_IN		1
 #define SEL_OUT		2
 #define SEL_EX		4
@@ -1671,8 +1680,7 @@ struct seq_file;
 ssize_t rw_copy_check_uvector(int type, const struct iovec __user * uvector,
 			      unsigned long nr_segs, unsigned long fast_segs,
 			      struct iovec *fast_pointer,
-			      struct iovec **ret_pointer,
-			      int check_access);
+			      struct iovec **ret_pointer);
 
 extern ssize_t vfs_read(struct file *, char __user *, size_t, loff_t *);
 extern ssize_t vfs_write(struct file *, const char __user *, size_t, loff_t *);
diff --git a/mm/process_vm_access.c b/mm/process_vm_access.c
index c20ff48..926b466 100644
--- a/mm/process_vm_access.c
+++ b/mm/process_vm_access.c
@@ -371,15 +371,15 @@ static ssize_t process_vm_rw(pid_t pid,
 	/* Check iovecs */
 	if (vm_write)
 		rc = rw_copy_check_uvector(WRITE, lvec, liovcnt, UIO_FASTIOV,
-					   iovstack_l, &iov_l, 1);
+					   iovstack_l, &iov_l);
 	else
 		rc = rw_copy_check_uvector(READ, lvec, liovcnt, UIO_FASTIOV,
-					   iovstack_l, &iov_l, 1);
+					   iovstack_l, &iov_l);
 	if (rc <= 0)
 		goto free_iovecs;
 
-	rc = rw_copy_check_uvector(READ, rvec, riovcnt, UIO_FASTIOV,
-				   iovstack_r, &iov_r, 0);
+	rc = rw_copy_check_uvector(CHECK_IOVEC_ONLY, rvec, riovcnt, UIO_FASTIOV,
+				   iovstack_r, &iov_r);
 	if (rc <= 0)
 		goto free_iovecs;
 
@@ -438,16 +438,16 @@ compat_process_vm_rw(compat_pid_t pid,
 	if (vm_write)
 		rc = compat_rw_copy_check_uvector(WRITE, lvec, liovcnt,
 						  UIO_FASTIOV, iovstack_l,
-						  &iov_l, 1);
+						  &iov_l);
 	else
 		rc = compat_rw_copy_check_uvector(READ, lvec, liovcnt,
 						  UIO_FASTIOV, iovstack_l,
-						  &iov_l, 1);
+						  &iov_l);
 	if (rc <= 0)
 		goto free_iovecs;
-	rc = compat_rw_copy_check_uvector(READ, rvec, riovcnt,
+	rc = compat_rw_copy_check_uvector(CHECK_IOVEC_ONLY, rvec, riovcnt,
 					  UIO_FASTIOV, iovstack_r,
-					  &iov_r, 0);
+					  &iov_r);
 	if (rc <= 0)
 		goto free_iovecs;
 
diff --git a/security/keys/compat.c b/security/keys/compat.c
index 4c48e13..338b510 100644
--- a/security/keys/compat.c
+++ b/security/keys/compat.c
@@ -38,7 +38,7 @@ long compat_keyctl_instantiate_key_iov(
 
 	ret = compat_rw_copy_check_uvector(WRITE, _payload_iov, ioc,
 					   ARRAY_SIZE(iovstack),
-					   iovstack, &iov, 1);
+					   iovstack, &iov);
 	if (ret < 0)
 		return ret;
 	if (ret == 0)
diff --git a/security/keys/keyctl.c b/security/keys/keyctl.c
index fb767c6..36746d8 100644
--- a/security/keys/keyctl.c
+++ b/security/keys/keyctl.c
@@ -1079,7 +1079,7 @@ long keyctl_instantiate_key_iov(key_serial_t id,
 		goto no_payload;
 
 	ret = rw_copy_check_uvector(WRITE, _payload_iov, ioc,
-				    ARRAY_SIZE(iovstack), iovstack, &iov, 1);
+				    ARRAY_SIZE(iovstack), iovstack, &iov);
 	if (ret < 0)
 		return ret;
 	if (ret == 0)

