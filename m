Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752817Ab2LJHmQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 02:42:16 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:5693 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752062Ab2LJHmP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 02:42:15 -0500
Subject: [PATCH 4/6] fuse: enable asynchronous processing direct IO
To: miklos@szeredi.hu
From: "Maxim V. Patlasov" <MPatlasov@parallels.com>
Cc: dev@parallels.com, xemul@parallels.com, fuse-devel@lists.sourceforge.net,
        bfoster@redhat.com, linux-kernel@vger.kernel.org, devel@openvz.org
Date: Mon, 10 Dec 2012 11:42:08 +0400
Message-ID: <20121210074202.12240.18639.stgit@maximpc.sw.ru>
In-Reply-To: <20121210073848.12240.88144.stgit@maximpc.sw.ru>
References: <20121210073848.12240.88144.stgit@maximpc.sw.ru>
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
without i_mutex hold.

Signed-off-by: Maxim Patlasov <mpatlasov@parallels.com>
---
 fs/fuse/file.c |   44 ++++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 42 insertions(+), 2 deletions(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index c585158..ef6d3de 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -2348,14 +2348,54 @@ fuse_direct_IO(int rw, struct kiocb *iocb, const struct iovec *iov,
 	ssize_t ret = 0;
 	struct file *file = NULL;
 	loff_t pos = 0;
+	struct inode *inode;
+	loff_t i_size;
+	size_t count = iov_length(iov, nr_segs);
+	struct kiocb *async_cb = NULL;
 
 	file = iocb->ki_filp;
 	pos = offset;
+	inode = file->f_mapping->host;
+	i_size = i_size_read(inode);
+
+	/* cannot write beyond eof asynchronously */
+	if (is_sync_kiocb(iocb) || (offset + count <= i_size) || rw != WRITE) {
+		struct fuse_io_priv *io;
+
+		io = kmalloc(sizeof(struct fuse_io_priv), GFP_KERNEL);
+		if (!io)
+			return -ENOMEM;
+
+		spin_lock_init(&io->lock);
+		io->reqs = 1;
+		io->bytes = -1;
+		io->size = 0;
+		io->offset = offset;
+		io->write = (rw == WRITE);
+		io->err = 0;
+		io->iocb = iocb;
+		iocb->private = io;
+
+		async_cb = iocb;
+	}
 
 	if (rw == WRITE)
-		ret = __fuse_direct_write(file, iov, nr_segs, &pos, NULL);
+		ret = __fuse_direct_write(file, iov, nr_segs, &pos, async_cb);
 	else
-		ret = __fuse_direct_read(file, iov, nr_segs, &pos, NULL);
+		ret = __fuse_direct_read(file, iov, nr_segs, &pos, async_cb);
+
+	if (async_cb) {
+		fuse_aio_complete(async_cb->private, ret == count ? 0 : -EIO,
+				  -1);
+
+		if (!is_sync_kiocb(iocb))
+			return -EIOCBQUEUED;
+
+		ret = wait_on_sync_kiocb(iocb);
+
+		if (rw == WRITE && ret > 0)
+			fuse_write_update_size(inode, pos);
+	}
 
 	return ret;
 }

