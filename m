Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756485Ab2LNPVW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 10:21:22 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:3206 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756448Ab2LNPVT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 10:21:19 -0500
Subject: [PATCH 4/6] fuse: enable asynchronous processing direct IO
To: miklos@szeredi.hu
From: "Maxim V. Patlasov" <MPatlasov@parallels.com>
Cc: dev@parallels.com, xemul@parallels.com, fuse-devel@lists.sourceforge.net,
        bfoster@redhat.com, linux-kernel@vger.kernel.org, devel@openvz.org
Date: Fri, 14 Dec 2012 19:21:08 +0400
Message-ID: <20121214152056.27155.80931.stgit@maximpc.sw.ru>
In-Reply-To: <20121214151424.27155.45971.stgit@maximpc.sw.ru>
References: <20121214151424.27155.45971.stgit@maximpc.sw.ru>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case of synchronous DIO request (i.e. read(2) or write(2) for a file
opened with O_DIRECT), the patch submits fuse requests asynchronously, but
waits for their completions before return from fuse_direct_IO().

In case of asynchronous DIO request (i.e. libaio io_submit() or a file opened
with O_DIRECT), the patch submits fuse requests asynchronously and return
-EIOCBQUEUED immediately.

The only special case is async DIO extending file. Here the patch falls back
to old behaviour because we can't return -EIOCBQUEUED and update i_size later,
without i_mutex hold. And we have no method to wait on real async I/O
requests.

The patch also clean __fuse_direct_write() up: it's better to update i_size
in its callers. Thanks Brian for suggestion.

Signed-off-by: Maxim Patlasov <mpatlasov@parallels.com>
---
 fs/fuse/file.c |   51 ++++++++++++++++++++++++++++++++++++++++++++-------
 1 files changed, 44 insertions(+), 7 deletions(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 6c2ca8a..05eed23 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -1356,11 +1356,8 @@ static ssize_t __fuse_direct_write(struct fuse_io_priv *io, const struct iovec *
 	ssize_t res;
 
 	res = generic_write_checks(file, ppos, &count, 0);
-	if (!res) {
+	if (!res)
 		res = fuse_direct_io(io, iov, nr_segs, count, ppos, 1);
-		if (!io->async && res > 0)
-			fuse_write_update_size(inode, *ppos);
-	}
 
 	fuse_invalidate_attr(inode);
 
@@ -1381,6 +1378,8 @@ static ssize_t fuse_direct_write(struct file *file, const char __user *buf,
 	/* Don't allow parallel writes to the same file */
 	mutex_lock(&inode->i_mutex);
 	res = __fuse_direct_write(&io, &iov, 1, ppos);
+	if (res > 0)
+		fuse_write_update_size(inode, *ppos);
 	mutex_unlock(&inode->i_mutex);
 
 	return res;
@@ -2348,23 +2347,61 @@ fuse_direct_IO(int rw, struct kiocb *iocb, const struct iovec *iov,
 	ssize_t ret = 0;
 	struct file *file = NULL;
 	loff_t pos = 0;
+	struct inode *inode;
+	loff_t i_size;
+	size_t count = iov_length(iov, nr_segs);
 	struct fuse_io_priv *io;
 
 	file = iocb->ki_filp;
 	pos = offset;
+	inode = file->f_mapping->host;
+	i_size = i_size_read(inode);
 
-	io = kzalloc(sizeof(struct fuse_io_priv), GFP_KERNEL);
+	io = kmalloc(sizeof(struct fuse_io_priv), GFP_KERNEL);
 	if (!io)
 		return -ENOMEM;
-
+	spin_lock_init(&io->lock);
+	io->reqs = 1;
+	io->bytes = -1;
+	io->size = 0;
+	io->offset = offset;
+	io->write = (rw == WRITE);
+	io->err = 0;
 	io->file = file;
+	/*
+	 * By default, we want to optimize all I/Os with async request submission
+	 * to the client filesystem.
+	 */
+	io->async = 1;
+	io->iocb = iocb;
+
+	/*
+	 * We cannot asynchronously extend the size of a file. We have no method
+	 * to wait on real async I/O requests, so we must submit this request
+	 * synchronously.
+	 */
+	if (!is_sync_kiocb(iocb) && (offset + count > i_size) && rw == WRITE)
+		io->async = 0;
 
 	if (rw == WRITE)
 		ret = __fuse_direct_write(io, iov, nr_segs, &pos);
 	else
 		ret = __fuse_direct_read(io, iov, nr_segs, &pos);
 
-	kfree(io);
+	if (io->async) {
+		fuse_aio_complete(io, ret == count ? 0 : -EIO, -1);
+		
+		/* we have a non-extending, async request, so return */
+		if (!is_sync_kiocb(iocb))
+			return -EIOCBQUEUED;
+
+		ret = wait_on_sync_kiocb(iocb);
+	} else {
+		kfree(io);
+	}
+
+	if (rw == WRITE && ret > 0)
+		fuse_write_update_size(inode, pos);
 
 	return ret;
 }

