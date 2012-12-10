Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752710Ab2LJHlo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 02:41:44 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:33160 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752464Ab2LJHln (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 02:41:43 -0500
Subject: [PATCH 2/6] fuse: add support of async IO
To: miklos@szeredi.hu
From: "Maxim V. Patlasov" <MPatlasov@parallels.com>
Cc: dev@parallels.com, xemul@parallels.com, fuse-devel@lists.sourceforge.net,
        bfoster@redhat.com, linux-kernel@vger.kernel.org, devel@openvz.org
Date: Mon, 10 Dec 2012 11:41:47 +0400
Message-ID: <20121210074139.12240.62832.stgit@maximpc.sw.ru>
In-Reply-To: <20121210073848.12240.88144.stgit@maximpc.sw.ru>
References: <20121210073848.12240.88144.stgit@maximpc.sw.ru>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch implements a framework to process an IO request asynchronously. The
idea is to associate several fuse requests with a single kiocb by means of
fuse_io_priv structure. The structure plays the same role for FUSE as 'struct
dio' for direct-io.c.

The framework is supposed to be used like this:
 - someone (who wants to process an IO asynchronously) allocates fuse_io_priv,
   initializes and saves it in kiocb->private.
 - as soon as fuse request is filled, it can be submitted (in non-blocking way)
   by fuse_async_req_send()
 - when all submitted requests are ACKed by userspace, io->reqs drops to zero
   triggering aio_complete()

In case of IO initiated by libaio, aio_complete() will finish processing the
same way as in case of dio_complete() calling aio_complete(). But the
framework may be also used for internal FUSE use when initial IO request
was synchronous (from user perspective), but it's beneficial to process it
asynchronously. Then the caller should wait on kiocb explicitly and
aio_complete() will wake the caller up.

Signed-off-by: Maxim Patlasov <mpatlasov@parallels.com>
---
 fs/fuse/file.c   |   94 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/fuse/fuse_i.h |   15 +++++++++
 2 files changed, 109 insertions(+), 0 deletions(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 6685cb0..634f54a 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -503,6 +503,100 @@ static void fuse_release_user_pages(struct fuse_req *req, int write)
 	}
 }
 
+/**
+ * In case of short read, the caller sets 'pos' to the position of
+ * actual end of fuse request in IO request. Otherwise, if bytes_requested
+ * == bytes_transferred or rw == WRITE, the caller sets 'pos' to -1.
+ *
+ * An example:
+ * User requested DIO read of 64K. It was splitted into two 32K fuse requests,
+ * both submitted asynchronously. The first of them was ACKed by userspace as
+ * fully completed (req->out.args[0].size == 32K) resulting in pos == -1. The
+ * second request was ACKed as short, e.g. only 1K was read, resulting in
+ * pos == 33K.
+ *
+ * Thus, when all fuse requests are completed, the minimal non-negative 'pos'
+ * will be equal to the length of the longest contiguous fragment of
+ * transferred data starting from the beginning of IO request.
+ */
+static void fuse_aio_complete(struct fuse_io_priv *io, int err, ssize_t pos)
+{
+	int left;
+
+	spin_lock(&io->lock);
+	if (err)
+		io->err = io->err ? : err;
+	else if (pos >= 0 && (io->bytes < 0 || pos < io->bytes))
+		io->bytes = pos;
+
+	left = --io->reqs;
+	spin_unlock(&io->lock);
+
+	if (!left) {
+		long res;
+
+		if (io->err)
+			res = io->err;
+		else if (io->bytes >= 0 && io->write)
+			res = -EIO;
+		else {
+			res = io->bytes < 0 ? io->size : io->bytes;
+
+			if (!is_sync_kiocb(io->iocb)) {
+				struct path *path = &io->iocb->ki_filp->f_path;
+				struct inode *inode = path->dentry->d_inode;
+				struct fuse_conn *fc = get_fuse_conn(inode);
+				struct fuse_inode *fi = get_fuse_inode(inode);
+
+				spin_lock(&fc->lock);
+				fi->attr_version = ++fc->attr_version;
+				spin_unlock(&fc->lock);
+			}
+		}
+
+		aio_complete(io->iocb, res, 0);
+		kfree(io);
+	}
+}
+
+static void fuse_aio_complete_req(struct fuse_conn *fc, struct fuse_req *req)
+{
+	struct fuse_io_priv *io = req->io;
+	ssize_t pos = -1;
+
+	fuse_release_user_pages(req, !io->write);
+
+	if (io->write) {
+		if (req->misc.write.in.size != req->misc.write.out.size)
+			pos = req->misc.write.in.offset - io->offset +
+				req->misc.write.out.size;
+	} else {
+		if (req->misc.read.in.size != req->out.args[0].size)
+			pos = req->misc.read.in.offset - io->offset +
+				req->out.args[0].size;
+	}
+
+	fuse_aio_complete(io, req->out.h.error, pos);
+}
+
+static size_t fuse_async_req_send(struct fuse_conn *fc, struct fuse_req *req,
+		size_t num_bytes, struct kiocb *iocb)
+{
+	struct fuse_io_priv *io = iocb->private;
+
+	spin_lock(&io->lock);
+	io->size += num_bytes;
+	io->reqs++;
+	spin_unlock(&io->lock);
+
+	req->io = io;
+	req->end = fuse_aio_complete_req;
+
+	fuse_request_send_background(fc, req);
+
+	return num_bytes;
+}
+
 static size_t fuse_send_read(struct fuse_req *req, struct file *file,
 			     loff_t pos, size_t count, fl_owner_t owner)
 {
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index e4f70ea..618d48a 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -219,6 +219,18 @@ enum fuse_req_state {
 	FUSE_REQ_FINISHED
 };
 
+/** The request IO state (for asynchronous processing) */
+struct fuse_io_priv {
+	spinlock_t lock;
+	unsigned reqs;
+	ssize_t bytes;
+	size_t size;
+	__u64 offset;
+	bool write;
+	int err;
+	struct kiocb *iocb;
+};
+
 /**
  * A request to the client
  */
@@ -323,6 +335,9 @@ struct fuse_req {
 	/** Inode used in the request or NULL */
 	struct inode *inode;
 
+	/** AIO control block */
+	struct fuse_io_priv *io;
+
 	/** Link on fi->writepages */
 	struct list_head writepages_entry;
 

