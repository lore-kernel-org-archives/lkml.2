Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752756Ab2LJHl6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 02:41:58 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:5505 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752719Ab2LJHlz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 02:41:55 -0500
Subject: [PATCH 3/6] fuse: make fuse_direct_io() aware about AIO
To: miklos@szeredi.hu
From: "Maxim V. Patlasov" <MPatlasov@parallels.com>
Cc: dev@parallels.com, xemul@parallels.com, fuse-devel@lists.sourceforge.net,
        bfoster@redhat.com, linux-kernel@vger.kernel.org, devel@openvz.org
Date: Mon, 10 Dec 2012 11:41:57 +0400
Message-ID: <20121210074152.12240.54385.stgit@maximpc.sw.ru>
In-Reply-To: <20121210073848.12240.88144.stgit@maximpc.sw.ru>
References: <20121210073848.12240.88144.stgit@maximpc.sw.ru>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch implements passing "struct kiocb *async" down the stack up to
fuse_send_read/write where it is used to submit request asynchronously.
async==NULL designates synchronous processing.

Non-trivial part of the patch is changes in fuse_direct_io(): resources
like fuse requests and user pages cannot be released immediately in async
case.

Signed-off-by: Maxim Patlasov <mpatlasov@parallels.com>
---
 fs/fuse/cuse.c   |    4 ++--
 fs/fuse/file.c   |   58 ++++++++++++++++++++++++++++++++++++------------------
 fs/fuse/fuse_i.h |    2 +-
 3 files changed, 42 insertions(+), 22 deletions(-)

diff --git a/fs/fuse/cuse.c b/fs/fuse/cuse.c
index 65ce10a..beb99e9 100644
--- a/fs/fuse/cuse.c
+++ b/fs/fuse/cuse.c
@@ -93,7 +93,7 @@ static ssize_t cuse_read(struct file *file, char __user *buf, size_t count,
 	loff_t pos = 0;
 	struct iovec iov = { .iov_base = buf, .iov_len = count };
 
-	return fuse_direct_io(file, &iov, 1, count, &pos, 0);
+	return fuse_direct_io(file, &iov, 1, count, &pos, 0, NULL);
 }
 
 static ssize_t cuse_write(struct file *file, const char __user *buf,
@@ -106,7 +106,7 @@ static ssize_t cuse_write(struct file *file, const char __user *buf,
 	 * No locking or generic_write_checks(), the server is
 	 * responsible for locking and sanity checks.
 	 */
-	return fuse_direct_io(file, &iov, 1, count, &pos, 1);
+	return fuse_direct_io(file, &iov, 1, count, &pos, 1, NULL);
 }
 
 static int cuse_open(struct inode *inode, struct file *file)
diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 634f54a..c585158 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -598,7 +598,8 @@ static size_t fuse_async_req_send(struct fuse_conn *fc, struct fuse_req *req,
 }
 
 static size_t fuse_send_read(struct fuse_req *req, struct file *file,
-			     loff_t pos, size_t count, fl_owner_t owner)
+			     loff_t pos, size_t count, fl_owner_t owner,
+			     struct kiocb *async)
 {
 	struct fuse_file *ff = file->private_data;
 	struct fuse_conn *fc = ff->fc;
@@ -610,6 +611,10 @@ static size_t fuse_send_read(struct fuse_req *req, struct file *file,
 		inarg->read_flags |= FUSE_READ_LOCKOWNER;
 		inarg->lock_owner = fuse_lock_owner_id(fc, owner);
 	}
+
+	if (async)
+		return fuse_async_req_send(fc, req, count, async);
+
 	fuse_request_send(fc, req);
 	return req->out.args[0].size;
 }
@@ -662,7 +667,7 @@ static int fuse_readpage(struct file *file, struct page *page)
 	req->num_pages = 1;
 	req->pages[0] = page;
 	req->page_descs[0].length = count;
-	num_read = fuse_send_read(req, file, pos, count, NULL);
+	num_read = fuse_send_read(req, file, pos, count, NULL, NULL);
 	err = req->out.h.error;
 	fuse_put_request(fc, req);
 
@@ -865,7 +870,8 @@ static void fuse_write_fill(struct fuse_req *req, struct fuse_file *ff,
 }
 
 static size_t fuse_send_write(struct fuse_req *req, struct file *file,
-			      loff_t pos, size_t count, fl_owner_t owner)
+			      loff_t pos, size_t count, fl_owner_t owner,
+			      struct kiocb *async)
 {
 	struct fuse_file *ff = file->private_data;
 	struct fuse_conn *fc = ff->fc;
@@ -877,6 +883,10 @@ static size_t fuse_send_write(struct fuse_req *req, struct file *file,
 		inarg->write_flags |= FUSE_WRITE_LOCKOWNER;
 		inarg->lock_owner = fuse_lock_owner_id(fc, owner);
 	}
+
+	if (async)
+		return fuse_async_req_send(fc, req, count, async);
+
 	fuse_request_send(fc, req);
 	return req->misc.write.out.size;
 }
@@ -904,7 +914,7 @@ static size_t fuse_send_write_pages(struct fuse_req *req, struct file *file,
 	for (i = 0; i < req->num_pages; i++)
 		fuse_wait_on_page_writeback(inode, req->pages[i]->index);
 
-	res = fuse_send_write(req, file, pos, count, NULL);
+	res = fuse_send_write(req, file, pos, count, NULL, NULL);
 
 	offset = req->page_descs[0].offset;
 	count = res;
@@ -1244,7 +1254,7 @@ static inline int fuse_iter_npages(const struct iov_iter *ii_p)
 
 ssize_t fuse_direct_io(struct file *file, const struct iovec *iov,
 		       unsigned long nr_segs, size_t count, loff_t *ppos,
-		       int write)
+		       int write, struct kiocb *async)
 {
 	struct fuse_file *ff = file->private_data;
 	struct fuse_conn *fc = ff->fc;
@@ -1266,16 +1276,22 @@ ssize_t fuse_direct_io(struct file *file, const struct iovec *iov,
 		size_t nbytes = min(count, nmax);
 		int err = fuse_get_user_pages(req, &ii, &nbytes, write);
 		if (err) {
+			if (async)
+				fuse_put_request(fc, req);
+
 			res = err;
 			break;
 		}
 
 		if (write)
-			nres = fuse_send_write(req, file, pos, nbytes, owner);
+			nres = fuse_send_write(req, file, pos, nbytes, owner,
+					       async);
 		else
-			nres = fuse_send_read(req, file, pos, nbytes, owner);
+			nres = fuse_send_read(req, file, pos, nbytes, owner,
+					      async);
 
-		fuse_release_user_pages(req, !write);
+		if (!async)
+			fuse_release_user_pages(req, !write);
 		if (req->out.h.error) {
 			if (!res)
 				res = req->out.h.error;
@@ -1290,13 +1306,14 @@ ssize_t fuse_direct_io(struct file *file, const struct iovec *iov,
 		if (nres != nbytes)
 			break;
 		if (count) {
-			fuse_put_request(fc, req);
+			if (!async)
+				fuse_put_request(fc, req);
 			req = fuse_get_req(fc, fuse_iter_npages(&ii));
 			if (IS_ERR(req))
 				break;
 		}
 	}
-	if (!IS_ERR(req))
+	if (!IS_ERR(req) && !async)
 		fuse_put_request(fc, req);
 	if (res > 0)
 		*ppos = pos;
@@ -1306,7 +1323,8 @@ ssize_t fuse_direct_io(struct file *file, const struct iovec *iov,
 EXPORT_SYMBOL_GPL(fuse_direct_io);
 
 static ssize_t __fuse_direct_read(struct file *file, const struct iovec *iov,
-				  unsigned long nr_segs, loff_t *ppos)
+				  unsigned long nr_segs, loff_t *ppos,
+				  struct kiocb *async)
 {
 	ssize_t res;
 	struct inode *inode = file->f_path.dentry->d_inode;
@@ -1315,7 +1333,7 @@ static ssize_t __fuse_direct_read(struct file *file, const struct iovec *iov,
 		return -EIO;
 
 	res = fuse_direct_io(file, iov, nr_segs, iov_length(iov, nr_segs),
-			     ppos, 0);
+			     ppos, 0, async);
 
 	fuse_invalidate_attr(inode);
 
@@ -1326,11 +1344,12 @@ static ssize_t fuse_direct_read(struct file *file, char __user *buf,
 				     size_t count, loff_t *ppos)
 {
 	struct iovec iov = { .iov_base = buf, .iov_len = count };
-	return __fuse_direct_read(file, &iov, 1, ppos);
+	return __fuse_direct_read(file, &iov, 1, ppos, NULL);
 }
 
 static ssize_t __fuse_direct_write(struct file *file, const struct iovec *iov,
-				   unsigned long nr_segs, loff_t *ppos)
+				   unsigned long nr_segs, loff_t *ppos,
+				   struct kiocb *async)
 {
 	struct inode *inode = file->f_path.dentry->d_inode;
 	size_t count = iov_length(iov, nr_segs);
@@ -1338,8 +1357,9 @@ static ssize_t __fuse_direct_write(struct file *file, const struct iovec *iov,
 
 	res = generic_write_checks(file, ppos, &count, 0);
 	if (!res) {
-		res = fuse_direct_io(file, iov, nr_segs, count, ppos, 1);
-		if (res > 0)
+		res = fuse_direct_io(file, iov, nr_segs, count, ppos, 1,
+				     async);
+		if (!async && res > 0)
 			fuse_write_update_size(inode, *ppos);
 	}
 
@@ -1360,7 +1380,7 @@ static ssize_t fuse_direct_write(struct file *file, const char __user *buf,
 
 	/* Don't allow parallel writes to the same file */
 	mutex_lock(&inode->i_mutex);
-	res = __fuse_direct_write(file, &iov, 1, ppos);
+	res = __fuse_direct_write(file, &iov, 1, ppos, NULL);
 	mutex_unlock(&inode->i_mutex);
 
 	return res;
@@ -2333,9 +2353,9 @@ fuse_direct_IO(int rw, struct kiocb *iocb, const struct iovec *iov,
 	pos = offset;
 
 	if (rw == WRITE)
-		ret = __fuse_direct_write(file, iov, nr_segs, &pos);
+		ret = __fuse_direct_write(file, iov, nr_segs, &pos, NULL);
 	else
-		ret = __fuse_direct_read(file, iov, nr_segs, &pos);
+		ret = __fuse_direct_read(file, iov, nr_segs, &pos, NULL);
 
 	return ret;
 }
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index 618d48a..173c959 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -828,7 +828,7 @@ int fuse_do_open(struct fuse_conn *fc, u64 nodeid, struct file *file,
 		 bool isdir);
 ssize_t fuse_direct_io(struct file *file, const struct iovec *iov,
 		       unsigned long nr_segs, size_t count, loff_t *ppos,
-		       int write);
+		       int write, struct kiocb *async);
 long fuse_do_ioctl(struct file *file, unsigned int cmd, unsigned long arg,
 		   unsigned int flags);
 long fuse_ioctl_common(struct file *file, unsigned int cmd,

