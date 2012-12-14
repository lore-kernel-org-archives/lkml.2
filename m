Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756438Ab2LNPVM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 10:21:12 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:39245 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756393Ab2LNPVK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 10:21:10 -0500
Subject: [PATCH 3/6] fuse: make fuse_direct_io() aware about AIO
To: miklos@szeredi.hu
From: "Maxim V. Patlasov" <MPatlasov@parallels.com>
Cc: dev@parallels.com, xemul@parallels.com, fuse-devel@lists.sourceforge.net,
        bfoster@redhat.com, linux-kernel@vger.kernel.org, devel@openvz.org
Date: Fri, 14 Dec 2012 19:20:51 +0400
Message-ID: <20121214152046.27155.24512.stgit@maximpc.sw.ru>
In-Reply-To: <20121214151424.27155.45971.stgit@maximpc.sw.ru>
References: <20121214151424.27155.45971.stgit@maximpc.sw.ru>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch implements passing "struct fuse_io_priv *io" down the stack up to
fuse_send_read/write where it is used to submit request asynchronously.
io->async==0 designates synchronous processing.

Non-trivial part of the patch is changes in fuse_direct_io(): resources
like fuse requests and user pages cannot be released immediately in async
case.

Signed-off-by: Maxim Patlasov <mpatlasov@parallels.com>
---
 fs/fuse/cuse.c   |    6 +++--
 fs/fuse/file.c   |   69 +++++++++++++++++++++++++++++++++++++++---------------
 fs/fuse/fuse_i.h |    2 +-
 3 files changed, 55 insertions(+), 22 deletions(-)

diff --git a/fs/fuse/cuse.c b/fs/fuse/cuse.c
index 65ce10a..d890901 100644
--- a/fs/fuse/cuse.c
+++ b/fs/fuse/cuse.c
@@ -92,8 +92,9 @@ static ssize_t cuse_read(struct file *file, char __user *buf, size_t count,
 {
 	loff_t pos = 0;
 	struct iovec iov = { .iov_base = buf, .iov_len = count };
+	struct fuse_io_priv io = { .async = 0, .file = file };
 
-	return fuse_direct_io(file, &iov, 1, count, &pos, 0);
+	return fuse_direct_io(&io, &iov, 1, count, &pos, 0);
 }
 
 static ssize_t cuse_write(struct file *file, const char __user *buf,
@@ -101,12 +102,13 @@ static ssize_t cuse_write(struct file *file, const char __user *buf,
 {
 	loff_t pos = 0;
 	struct iovec iov = { .iov_base = (void __user *)buf, .iov_len = count };
+	struct fuse_io_priv io = { .async = 0, .file = file };
 
 	/*
 	 * No locking or generic_write_checks(), the server is
 	 * responsible for locking and sanity checks.
 	 */
-	return fuse_direct_io(file, &iov, 1, count, &pos, 1);
+	return fuse_direct_io(&io, &iov, 1, count, &pos, 1);
 }
 
 static int cuse_open(struct inode *inode, struct file *file)
diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 8dd931f..6c2ca8a 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -595,9 +595,10 @@ static size_t fuse_async_req_send(struct fuse_conn *fc, struct fuse_req *req,
 	return num_bytes;
 }
 
-static size_t fuse_send_read(struct fuse_req *req, struct file *file,
+static size_t fuse_send_read(struct fuse_req *req, struct fuse_io_priv *io,
 			     loff_t pos, size_t count, fl_owner_t owner)
 {
+	struct file *file = io->file;
 	struct fuse_file *ff = file->private_data;
 	struct fuse_conn *fc = ff->fc;
 
@@ -608,6 +609,10 @@ static size_t fuse_send_read(struct fuse_req *req, struct file *file,
 		inarg->read_flags |= FUSE_READ_LOCKOWNER;
 		inarg->lock_owner = fuse_lock_owner_id(fc, owner);
 	}
+
+	if (io->async)
+		return fuse_async_req_send(fc, req, count, io);
+
 	fuse_request_send(fc, req);
 	return req->out.args[0].size;
 }
@@ -628,6 +633,7 @@ static void fuse_read_update_size(struct inode *inode, loff_t size,
 
 static int fuse_readpage(struct file *file, struct page *page)
 {
+	struct fuse_io_priv io = { .async = 0, .file = file };
 	struct inode *inode = page->mapping->host;
 	struct fuse_conn *fc = get_fuse_conn(inode);
 	struct fuse_req *req;
@@ -660,7 +666,7 @@ static int fuse_readpage(struct file *file, struct page *page)
 	req->num_pages = 1;
 	req->pages[0] = page;
 	req->page_descs[0].length = count;
-	num_read = fuse_send_read(req, file, pos, count, NULL);
+	num_read = fuse_send_read(req, &io, pos, count, NULL);
 	err = req->out.h.error;
 	fuse_put_request(fc, req);
 
@@ -862,9 +868,10 @@ static void fuse_write_fill(struct fuse_req *req, struct fuse_file *ff,
 	req->out.args[0].value = outarg;
 }
 
-static size_t fuse_send_write(struct fuse_req *req, struct file *file,
+static size_t fuse_send_write(struct fuse_req *req, struct fuse_io_priv *io,
 			      loff_t pos, size_t count, fl_owner_t owner)
 {
+	struct file *file = io->file;
 	struct fuse_file *ff = file->private_data;
 	struct fuse_conn *fc = ff->fc;
 	struct fuse_write_in *inarg = &req->misc.write.in;
@@ -875,6 +882,10 @@ static size_t fuse_send_write(struct fuse_req *req, struct file *file,
 		inarg->write_flags |= FUSE_WRITE_LOCKOWNER;
 		inarg->lock_owner = fuse_lock_owner_id(fc, owner);
 	}
+
+	if (io->async)
+		return fuse_async_req_send(fc, req, count, io);
+
 	fuse_request_send(fc, req);
 	return req->misc.write.out.size;
 }
@@ -898,11 +909,12 @@ static size_t fuse_send_write_pages(struct fuse_req *req, struct file *file,
 	size_t res;
 	unsigned offset;
 	unsigned i;
+	struct fuse_io_priv io = { .async = 0, .file = file };
 
 	for (i = 0; i < req->num_pages; i++)
 		fuse_wait_on_page_writeback(inode, req->pages[i]->index);
 
-	res = fuse_send_write(req, file, pos, count, NULL);
+	res = fuse_send_write(req, &io, pos, count, NULL);
 
 	offset = req->page_descs[0].offset;
 	count = res;
@@ -1240,10 +1252,11 @@ static inline int fuse_iter_npages(const struct iov_iter *ii_p)
 	return min(npages, FUSE_MAX_PAGES_PER_REQ);
 }
 
-ssize_t fuse_direct_io(struct file *file, const struct iovec *iov,
+ssize_t fuse_direct_io(struct fuse_io_priv *io, const struct iovec *iov,
 		       unsigned long nr_segs, size_t count, loff_t *ppos,
 		       int write)
 {
+	struct file *file = io->file;
 	struct fuse_file *ff = file->private_data;
 	struct fuse_conn *fc = ff->fc;
 	size_t nmax = write ? fc->max_write : fc->max_read;
@@ -1264,16 +1277,20 @@ ssize_t fuse_direct_io(struct file *file, const struct iovec *iov,
 		size_t nbytes = min(count, nmax);
 		int err = fuse_get_user_pages(req, &ii, &nbytes, write);
 		if (err) {
+			if (io->async)
+				fuse_put_request(fc, req);
+
 			res = err;
 			break;
 		}
 
 		if (write)
-			nres = fuse_send_write(req, file, pos, nbytes, owner);
+			nres = fuse_send_write(req, io, pos, nbytes, owner);
 		else
-			nres = fuse_send_read(req, file, pos, nbytes, owner);
+			nres = fuse_send_read(req, io, pos, nbytes, owner);
 
-		fuse_release_user_pages(req, !write);
+		if (!io->async)
+			fuse_release_user_pages(req, !write);
 		if (req->out.h.error) {
 			if (!res)
 				res = req->out.h.error;
@@ -1288,13 +1305,14 @@ ssize_t fuse_direct_io(struct file *file, const struct iovec *iov,
 		if (nres != nbytes)
 			break;
 		if (count) {
-			fuse_put_request(fc, req);
+			if (!io->async)
+				fuse_put_request(fc, req);
 			req = fuse_get_req(fc, fuse_iter_npages(&ii));
 			if (IS_ERR(req))
 				break;
 		}
 	}
-	if (!IS_ERR(req))
+	if (!IS_ERR(req) && !io->async)
 		fuse_put_request(fc, req);
 	if (res > 0)
 		*ppos = pos;
@@ -1303,16 +1321,17 @@ ssize_t fuse_direct_io(struct file *file, const struct iovec *iov,
 }
 EXPORT_SYMBOL_GPL(fuse_direct_io);
 
-static ssize_t __fuse_direct_read(struct file *file, const struct iovec *iov,
+static ssize_t __fuse_direct_read(struct fuse_io_priv *io, const struct iovec *iov,
 				  unsigned long nr_segs, loff_t *ppos)
 {
 	ssize_t res;
+	struct file *file = io->file;
 	struct inode *inode = file->f_path.dentry->d_inode;
 
 	if (is_bad_inode(inode))
 		return -EIO;
 
-	res = fuse_direct_io(file, iov, nr_segs, iov_length(iov, nr_segs),
+	res = fuse_direct_io(io, iov, nr_segs, iov_length(iov, nr_segs),
 			     ppos, 0);
 
 	fuse_invalidate_attr(inode);
@@ -1323,21 +1342,23 @@ static ssize_t __fuse_direct_read(struct file *file, const struct iovec *iov,
 static ssize_t fuse_direct_read(struct file *file, char __user *buf,
 				     size_t count, loff_t *ppos)
 {
+	struct fuse_io_priv io = { .async = 0, .file = file };
 	struct iovec iov = { .iov_base = buf, .iov_len = count };
-	return __fuse_direct_read(file, &iov, 1, ppos);
+	return __fuse_direct_read(&io, &iov, 1, ppos);
 }
 
-static ssize_t __fuse_direct_write(struct file *file, const struct iovec *iov,
+static ssize_t __fuse_direct_write(struct fuse_io_priv *io, const struct iovec *iov,
 				   unsigned long nr_segs, loff_t *ppos)
 {
+	struct file *file = io->file;
 	struct inode *inode = file->f_path.dentry->d_inode;
 	size_t count = iov_length(iov, nr_segs);
 	ssize_t res;
 
 	res = generic_write_checks(file, ppos, &count, 0);
 	if (!res) {
-		res = fuse_direct_io(file, iov, nr_segs, count, ppos, 1);
-		if (res > 0)
+		res = fuse_direct_io(io, iov, nr_segs, count, ppos, 1);
+		if (!io->async && res > 0)
 			fuse_write_update_size(inode, *ppos);
 	}
 
@@ -1352,13 +1373,14 @@ static ssize_t fuse_direct_write(struct file *file, const char __user *buf,
 	struct iovec iov = { .iov_base = (void __user *)buf, .iov_len = count };
 	struct inode *inode = file->f_path.dentry->d_inode;
 	ssize_t res;
+	struct fuse_io_priv io = { .async = 0, .file = file };
 
 	if (is_bad_inode(inode))
 		return -EIO;
 
 	/* Don't allow parallel writes to the same file */
 	mutex_lock(&inode->i_mutex);
-	res = __fuse_direct_write(file, &iov, 1, ppos);
+	res = __fuse_direct_write(&io, &iov, 1, ppos);
 	mutex_unlock(&inode->i_mutex);
 
 	return res;
@@ -2326,14 +2348,23 @@ fuse_direct_IO(int rw, struct kiocb *iocb, const struct iovec *iov,
 	ssize_t ret = 0;
 	struct file *file = NULL;
 	loff_t pos = 0;
+	struct fuse_io_priv *io;
 
 	file = iocb->ki_filp;
 	pos = offset;
 
+	io = kzalloc(sizeof(struct fuse_io_priv), GFP_KERNEL);
+	if (!io)
+		return -ENOMEM;
+
+	io->file = file;
+
 	if (rw == WRITE)
-		ret = __fuse_direct_write(file, iov, nr_segs, &pos);
+		ret = __fuse_direct_write(io, iov, nr_segs, &pos);
 	else
-		ret = __fuse_direct_read(file, iov, nr_segs, &pos);
+		ret = __fuse_direct_read(io, iov, nr_segs, &pos);
+
+	kfree(io);
 
 	return ret;
 }
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index e0a5b65..91b5192 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -828,7 +828,7 @@ int fuse_reverse_inval_entry(struct super_block *sb, u64 parent_nodeid,
 
 int fuse_do_open(struct fuse_conn *fc, u64 nodeid, struct file *file,
 		 bool isdir);
-ssize_t fuse_direct_io(struct file *file, const struct iovec *iov,
+ssize_t fuse_direct_io(struct fuse_io_priv *io, const struct iovec *iov,
 		       unsigned long nr_segs, size_t count, loff_t *ppos,
 		       int write);
 long fuse_do_ioctl(struct file *file, unsigned int cmd, unsigned long arg,

