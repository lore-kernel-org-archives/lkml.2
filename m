Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753271Ab1BERrH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 12:47:07 -0500
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:39865 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752925Ab1BERrF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 12:47:05 -0500
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: v9fs-developer@lists.sourceforge.net
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [RFC PATCH -V2 05/17] fs/9p: Add read write helper function
Date: Sat,  5 Feb 2011 23:16:33 +0530
Message-Id: <1296928005-9529-6-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1296928005-9529-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1296928005-9529-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We add read write helper function here which will
be used later by the mmap patch

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/9p/v9fs_vfs.h |    4 ++-
 fs/9p/vfs_file.c |  100 ++++++++++++++++++++++++++++++++---------------------
 2 files changed, 63 insertions(+), 41 deletions(-)

diff --git a/fs/9p/v9fs_vfs.h b/fs/9p/v9fs_vfs.h
index e4d5540..276ad44 100644
--- a/fs/9p/v9fs_vfs.h
+++ b/fs/9p/v9fs_vfs.h
@@ -64,8 +64,10 @@ void v9fs_inode2stat(struct inode *inode, struct p9_wstat *stat);
 int v9fs_uflags2omode(int uflags, int extended);
 
 ssize_t v9fs_file_readn(struct file *, char *, char __user *, u32, u64);
+ssize_t v9fs_fid_readn(struct p9_fid *, char *, char __user *, u32, u64);
 void v9fs_blank_wstat(struct p9_wstat *wstat);
 int v9fs_vfs_setattr_dotl(struct dentry *, struct iattr *);
 int v9fs_file_fsync_dotl(struct file *filp, int datasync);
-
+ssize_t v9fs_file_write_internal(struct inode *, struct p9_fid *, char *,
+				 size_t, loff_t *, int);
 #define P9_LOCK_TIMEOUT (30*HZ)
diff --git a/fs/9p/vfs_file.c b/fs/9p/vfs_file.c
index ce1eae4..ecdd512 100644
--- a/fs/9p/vfs_file.c
+++ b/fs/9p/vfs_file.c
@@ -323,25 +323,22 @@ out_err:
 }
 
 /**
- * v9fs_file_readn - read from a file
- * @filp: file pointer to read
+ * v9fs_fid_readn - read from a fid
+ * @fid: fid to read
  * @data: data buffer to read data into
  * @udata: user data buffer to read data into
  * @count: size of buffer
  * @offset: offset at which to read data
  *
  */
-
 ssize_t
-v9fs_file_readn(struct file *filp, char *data, char __user *udata, u32 count,
+v9fs_fid_readn(struct p9_fid *fid, char *data, char __user *udata, u32 count,
 	       u64 offset)
 {
 	int n, total, size;
-	struct p9_fid *fid = filp->private_data;
 
 	P9_DPRINTK(P9_DEBUG_VFS, "fid %d offset %llu count %d\n", fid->fid,
-					(long long unsigned) offset, count);
-
+		   (long long unsigned) offset, count);
 	n = 0;
 	total = 0;
 	size = fid->iounit ? fid->iounit : fid->clnt->msize - P9_IOHDRSZ;
@@ -367,6 +364,22 @@ v9fs_file_readn(struct file *filp, char *data, char __user *udata, u32 count,
 }
 
 /**
+ * v9fs_file_readn - read from a file
+ * @filp: file pointer to read
+ * @data: data buffer to read data into
+ * @udata: user data buffer to read data into
+ * @count: size of buffer
+ * @offset: offset at which to read data
+ *
+ */
+ssize_t
+v9fs_file_readn(struct file *filp, char *data, char __user *udata, u32 count,
+	       u64 offset)
+{
+	return v9fs_fid_readn(filp->private_data, data, udata, count, offset);
+}
+
+/**
  * v9fs_file_read - read from a file
  * @filp: file pointer to read
  * @udata: user data buffer to read data into
@@ -398,45 +411,20 @@ v9fs_file_read(struct file *filp, char __user *udata, size_t count,
 	return ret;
 }
 
-/**
- * v9fs_file_write - write to a file
- * @filp: file pointer to write
- * @data: data buffer to write data from
- * @count: size of buffer
- * @offset: offset at which to write data
- *
- */
-
-static ssize_t
-v9fs_file_write(struct file *filp, const char __user * data,
-		size_t count, loff_t * offset)
+ssize_t
+v9fs_file_write_internal(struct inode *inode, struct p9_fid *fid, char *data,
+			 size_t count, loff_t *offset, int invalidate)
 {
-	ssize_t retval;
-	size_t total = 0;
 	int n;
-	struct p9_fid *fid;
+	size_t total = 0;
 	struct p9_client *clnt;
-	struct inode *inode = filp->f_path.dentry->d_inode;
 	loff_t origin = *offset;
 	unsigned long pg_start, pg_end;
 
 	P9_DPRINTK(P9_DEBUG_VFS, "data %p count %d offset %x\n", data,
 		(int)count, (int)*offset);
 
-	fid = filp->private_data;
 	clnt = fid->clnt;
-
-	retval = generic_write_checks(filp, &origin, &count, 0);
-	if (retval)
-		goto out;
-
-	retval = -EINVAL;
-	if ((ssize_t) count < 0)
-		goto out;
-	retval = 0;
-	if (!count)
-		goto out;
-
 	do {
 		n = p9_client_write(fid, NULL, data+total, origin+total, count);
 		if (n <= 0)
@@ -445,7 +433,7 @@ v9fs_file_write(struct file *filp, const char __user * data,
 		total += n;
 	} while (count > 0);
 
-	if (total > 0) {
+	if (invalidate && total > 0) {
 		pg_start = origin >> PAGE_CACHE_SHIFT;
 		pg_end = (origin + total - 1) >> PAGE_CACHE_SHIFT;
 		if (inode->i_mapping && inode->i_mapping->nrpages)
@@ -457,9 +445,41 @@ v9fs_file_write(struct file *filp, const char __user * data,
 	}
 
 	if (n < 0)
-		retval = n;
-	else
-		retval = total;
+		return n;
+
+	return total;
+}
+
+/**
+ * v9fs_file_write - write to a file
+ * @filp: file pointer to write
+ * @data: data buffer to write data from
+ * @count: size of buffer
+ * @offset: offset at which to write data
+ *
+ */
+static ssize_t
+v9fs_file_write(struct file *filp, const char __user * data,
+		size_t count, loff_t *offset)
+{
+	ssize_t retval = 0;
+	loff_t origin = *offset;
+
+
+	retval = generic_write_checks(filp, &origin, &count, 0);
+	if (retval)
+		goto out;
+
+	retval = -EINVAL;
+	if ((ssize_t) count < 0)
+		goto out;
+	retval = 0;
+	if (!count)
+		goto out;
+
+	return v9fs_file_write_internal(filp->f_path.dentry->d_inode,
+					filp->private_data,
+					(char *)data, count, offset, 1);
 out:
 	return retval;
 }
-- 
1.7.1

