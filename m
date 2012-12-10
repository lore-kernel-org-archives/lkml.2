Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752867Ab2LJHmV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 02:42:21 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:34617 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752174Ab2LJHmS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 02:42:18 -0500
Subject: [PATCH 5/6] fuse: truncate file if async dio failed
To: miklos@szeredi.hu
From: "Maxim V. Patlasov" <MPatlasov@parallels.com>
Cc: dev@parallels.com, xemul@parallels.com, fuse-devel@lists.sourceforge.net,
        bfoster@redhat.com, linux-kernel@vger.kernel.org, devel@openvz.org
Date: Mon, 10 Dec 2012 11:42:18 +0400
Message-ID: <20121210074213.12240.13408.stgit@maximpc.sw.ru>
In-Reply-To: <20121210073848.12240.88144.stgit@maximpc.sw.ru>
References: <20121210073848.12240.88144.stgit@maximpc.sw.ru>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch improves error handling in fuse_direct_IO(): if we successfully
submitted several fuse requests on behalf of synchronous direct write
extending file and some of them failed, let's try to do our best to clean-up.

Signed-off-by: Maxim Patlasov <mpatlasov@parallels.com>
---
 fs/fuse/file.c |   55 +++++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 53 insertions(+), 2 deletions(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index ef6d3de..3e0fdb7 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -2341,6 +2341,53 @@ int fuse_notify_poll_wakeup(struct fuse_conn *fc,
 	return 0;
 }
 
+static void fuse_do_truncate(struct file *file)
+{
+	struct fuse_file *ff = file->private_data;
+	struct inode *inode = file->f_mapping->host;
+	struct fuse_conn *fc = get_fuse_conn(inode);
+	struct fuse_req *req;
+	struct fuse_setattr_in inarg;
+	struct fuse_attr_out outarg;
+	int err;
+
+	req = fuse_get_req_nopages(fc);
+	if (IS_ERR(req)) {
+		printk(KERN_WARNING "failed to allocate req for truncate "
+		       "(%ld)\n", PTR_ERR(req));
+		return;
+	}
+
+	memset(&inarg, 0, sizeof(inarg));
+	memset(&outarg, 0, sizeof(outarg));
+
+	inarg.valid |= FATTR_SIZE;
+	inarg.size = i_size_read(inode);
+
+	inarg.valid |= FATTR_FH;
+	inarg.fh = ff->fh;
+
+	req->in.h.opcode = FUSE_SETATTR;
+	req->in.h.nodeid = get_node_id(inode);
+	req->in.numargs = 1;
+	req->in.args[0].size = sizeof(inarg);
+	req->in.args[0].value = &inarg;
+	req->out.numargs = 1;
+	if (fc->minor < 9)
+		req->out.args[0].size = FUSE_COMPAT_ATTR_OUT_SIZE;
+	else
+		req->out.args[0].size = sizeof(outarg);
+	req->out.args[0].value = &outarg;
+
+	fuse_request_send(fc, req);
+	err = req->out.h.error;
+	fuse_put_request(fc, req);
+
+	if (err)
+		printk(KERN_WARNING "failed to truncate to %lld with error "
+		       "%d\n", i_size_read(inode), err);
+}
+
 static ssize_t
 fuse_direct_IO(int rw, struct kiocb *iocb, const struct iovec *iov,
 			loff_t offset, unsigned long nr_segs)
@@ -2393,8 +2440,12 @@ fuse_direct_IO(int rw, struct kiocb *iocb, const struct iovec *iov,
 
 		ret = wait_on_sync_kiocb(iocb);
 
-		if (rw == WRITE && ret > 0)
-			fuse_write_update_size(inode, pos);
+		if (rw == WRITE) {
+			if (ret > 0)
+				fuse_write_update_size(inode, pos);
+			else if (ret < 0 && offset + count > i_size)
+				fuse_do_truncate(file);
+		}
 	}
 
 	return ret;

