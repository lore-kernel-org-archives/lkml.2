Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932152Ab2LNPVl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 10:21:41 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:19242 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932130Ab2LNPVi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 10:21:38 -0500
Subject: [PATCH 6/6] fuse: optimize short direct reads
To: miklos@szeredi.hu
From: "Maxim V. Patlasov" <MPatlasov@parallels.com>
Cc: dev@parallels.com, xemul@parallels.com, fuse-devel@lists.sourceforge.net,
        bfoster@redhat.com, linux-kernel@vger.kernel.org, devel@openvz.org
Date: Fri, 14 Dec 2012 19:21:26 +0400
Message-ID: <20121214152123.27155.87062.stgit@maximpc.sw.ru>
In-Reply-To: <20121214151424.27155.45971.stgit@maximpc.sw.ru>
References: <20121214151424.27155.45971.stgit@maximpc.sw.ru>
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
index b6e9b8d..ceacd20 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -1322,7 +1322,8 @@ ssize_t fuse_direct_io(struct fuse_io_priv *io, const struct iovec *iov,
 EXPORT_SYMBOL_GPL(fuse_direct_io);
 
 static ssize_t __fuse_direct_read(struct fuse_io_priv *io, const struct iovec *iov,
-				  unsigned long nr_segs, loff_t *ppos)
+				  unsigned long nr_segs, loff_t *ppos,
+				  size_t count)
 {
 	ssize_t res;
 	struct file *file = io->file;
@@ -1331,8 +1332,7 @@ static ssize_t __fuse_direct_read(struct fuse_io_priv *io, const struct iovec *i
 	if (is_bad_inode(inode))
 		return -EIO;
 
-	res = fuse_direct_io(io, iov, nr_segs, iov_length(iov, nr_segs),
-			     ppos, 0);
+	res = fuse_direct_io(io, iov, nr_segs, count, ppos, 0);
 
 	fuse_invalidate_attr(inode);
 
@@ -1344,7 +1344,7 @@ static ssize_t fuse_direct_read(struct file *file, char __user *buf,
 {
 	struct fuse_io_priv io = { .async = 0, .file = file };
 	struct iovec iov = { .iov_base = buf, .iov_len = count };
-	return __fuse_direct_read(&io, &iov, 1, ppos);
+	return __fuse_direct_read(&io, &iov, 1, ppos, count);
 }
 
 static ssize_t __fuse_direct_write(struct fuse_io_priv *io, const struct iovec *iov,
@@ -2404,6 +2404,13 @@ fuse_direct_IO(int rw, struct kiocb *iocb, const struct iovec *iov,
 	inode = file->f_mapping->host;
 	i_size = i_size_read(inode);
 
+	/* optimization for short read */
+	if (rw != WRITE && offset + count > i_size) {
+		if (offset >= i_size)
+			return 0;
+		count = i_size - offset;
+	}
+
 	io = kmalloc(sizeof(struct fuse_io_priv), GFP_KERNEL);
 	if (!io)
 		return -ENOMEM;
@@ -2427,13 +2434,13 @@ fuse_direct_IO(int rw, struct kiocb *iocb, const struct iovec *iov,
 	 * to wait on real async I/O requests, so we must submit this request
 	 * synchronously.
 	 */
-	if (!is_sync_kiocb(iocb) && (offset + count > i_size) && rw == WRITE)
+	if (!is_sync_kiocb(iocb) && (offset + count > i_size))
 		io->async = 0;
 
 	if (rw == WRITE)
 		ret = __fuse_direct_write(io, iov, nr_segs, &pos);
 	else
-		ret = __fuse_direct_read(io, iov, nr_segs, &pos);
+		ret = __fuse_direct_read(io, iov, nr_segs, &pos, count);
 
 	if (io->async) {
 		fuse_aio_complete(io, ret == count ? 0 : -EIO, -1);

