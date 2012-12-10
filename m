Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752513Ab2LJHmf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 02:42:35 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:18972 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752905Ab2LJHma (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 02:42:30 -0500
Subject: [PATCH 6/6] fuse: optimize short direct reads
To: miklos@szeredi.hu
From: "Maxim V. Patlasov" <MPatlasov@parallels.com>
Cc: dev@parallels.com, xemul@parallels.com, fuse-devel@lists.sourceforge.net,
        bfoster@redhat.com, linux-kernel@vger.kernel.org, devel@openvz.org
Date: Mon, 10 Dec 2012 11:42:28 +0400
Message-ID: <20121210074223.12240.85026.stgit@maximpc.sw.ru>
In-Reply-To: <20121210073848.12240.88144.stgit@maximpc.sw.ru>
References: <20121210073848.12240.88144.stgit@maximpc.sw.ru>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If user requested direct read beyond EOF, we can skip sending fuse requests
for positions beyond EOF because userspace would ACK them with zero bytes read
anyway. We can trust to i_size in fuse_direct_IO for such cases because it's
called from fuse_file_aio_read() and the latter updates fuse attributes
including i_size.

Signed-off-by: Maxim Patlasov <mpatlasov@parallels.com>
---
 fs/fuse/file.c |   19 +++++++++++++------
 1 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 3e0fdb7..d2094e1 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -1324,7 +1324,7 @@ EXPORT_SYMBOL_GPL(fuse_direct_io);
 
 static ssize_t __fuse_direct_read(struct file *file, const struct iovec *iov,
 				  unsigned long nr_segs, loff_t *ppos,
-				  struct kiocb *async)
+				  struct kiocb *async, size_t count)
 {
 	ssize_t res;
 	struct inode *inode = file->f_path.dentry->d_inode;
@@ -1332,8 +1332,7 @@ static ssize_t __fuse_direct_read(struct file *file, const struct iovec *iov,
 	if (is_bad_inode(inode))
 		return -EIO;
 
-	res = fuse_direct_io(file, iov, nr_segs, iov_length(iov, nr_segs),
-			     ppos, 0, async);
+	res = fuse_direct_io(file, iov, nr_segs, count, ppos, 0, async);
 
 	fuse_invalidate_attr(inode);
 
@@ -1344,7 +1343,7 @@ static ssize_t fuse_direct_read(struct file *file, char __user *buf,
 				     size_t count, loff_t *ppos)
 {
 	struct iovec iov = { .iov_base = buf, .iov_len = count };
-	return __fuse_direct_read(file, &iov, 1, ppos, NULL);
+	return __fuse_direct_read(file, &iov, 1, ppos, NULL, count);
 }
 
 static ssize_t __fuse_direct_write(struct file *file, const struct iovec *iov,
@@ -2405,8 +2404,15 @@ fuse_direct_IO(int rw, struct kiocb *iocb, const struct iovec *iov,
 	inode = file->f_mapping->host;
 	i_size = i_size_read(inode);
 
+	/* optimization for short read */
+	if (rw != WRITE && offset + count > i_size) {
+		if (offset >= i_size)
+			return 0;
+		count = i_size - offset;
+	}
+
 	/* cannot write beyond eof asynchronously */
-	if (is_sync_kiocb(iocb) || (offset + count <= i_size) || rw != WRITE) {
+	if (is_sync_kiocb(iocb) || (offset + count <= i_size)) {
 		struct fuse_io_priv *io;
 
 		io = kmalloc(sizeof(struct fuse_io_priv), GFP_KERNEL);
@@ -2429,7 +2435,8 @@ fuse_direct_IO(int rw, struct kiocb *iocb, const struct iovec *iov,
 	if (rw == WRITE)
 		ret = __fuse_direct_write(file, iov, nr_segs, &pos, async_cb);
 	else
-		ret = __fuse_direct_read(file, iov, nr_segs, &pos, async_cb);
+		ret = __fuse_direct_read(file, iov, nr_segs, &pos, async_cb,
+					 count);
 
 	if (async_cb) {
 		fuse_aio_complete(async_cb->private, ret == count ? 0 : -EIO,

