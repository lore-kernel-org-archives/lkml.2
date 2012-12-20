Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751537Ab2LTMcB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 07:32:01 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:30421 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750956Ab2LTMb4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 07:31:56 -0500
Subject: [PATCH 3/5] fuse: wait for end of IO on release
To: miklos@szeredi.hu
From: Maxim Patlasov <mpatlasov@parallels.com>
Cc: dev@parallels.com, xemul@parallels.com, fuse-devel@lists.sourceforge.net,
        bfoster@redhat.com, linux-kernel@vger.kernel.org, devel@openvz.org,
        anand.avati@gmail.com
Date: Thu, 20 Dec 2012 16:31:59 +0400
Message-ID: <20121220123144.4101.84499.stgit@maximpc.sw.ru>
In-Reply-To: <20121220122702.4101.80042.stgit@maximpc.sw.ru>
References: <20121220122702.4101.80042.stgit@maximpc.sw.ru>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are two types of I/O activity that can be "in progress" at the time
of fuse_release() execution: asynchronous read-ahead and write-back. The
patch ensures that they are completed before fuse_release_common sends
FUSE_RELEASE to userspace.

So far as fuse_release() waits for end of async I/O, its callbacks
(fuse_readpages_end and fuse_writepage_finish) calling fuse_file_put cannot
be the last holders of fuse file anymore. To emphasize the fact, the patch
replaces fuse_file_put with __fuse_file_put there.

Signed-off-by: Maxim Patlasov <mpatlasov@parallels.com>
---
 fs/fuse/file.c |   55 ++++++++++++++++++++++++++++++++++++++++++++++++++++---
 1 files changed, 52 insertions(+), 3 deletions(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 4f23134..aed9be2 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -137,6 +137,12 @@ static void fuse_file_put(struct fuse_file *ff, bool sync)
 	}
 }
 
+static void __fuse_file_put(struct fuse_file *ff)
+{
+	if (atomic_dec_and_test(&ff->count))
+		BUG();
+}
+
 int fuse_do_open(struct fuse_conn *fc, u64 nodeid, struct file *file,
 		 bool isdir)
 {
@@ -260,7 +266,12 @@ void fuse_release_common(struct file *file, int opcode)
 	 * Make the release synchronous if this is a fuseblk mount,
 	 * synchronous RELEASE is allowed (and desirable) in this case
 	 * because the server can be trusted not to screw up.
+	 *
+	 * We might wait for them (asynchronous READ or WRITE requests), so:
 	 */
+	if (ff->fc->close_wait)
+		BUG_ON(atomic_read(&ff->count) != 1);
+
 	fuse_file_put(ff, ff->fc->destroy_req != NULL);
 }
 
@@ -271,6 +282,31 @@ static int fuse_open(struct inode *inode, struct file *file)
 
 static int fuse_release(struct inode *inode, struct file *file)
 {
+	struct fuse_file *ff = file->private_data;
+
+	if (ff->fc->close_wait) {
+		struct fuse_inode *fi = get_fuse_inode(inode);
+
+		/*
+		 * Must remove file from write list. Otherwise it is possible
+		 * this file will get more writeback from another files
+		 * rerouted via write_files.
+		 */
+		spin_lock(&ff->fc->lock);
+		list_del_init(&ff->write_entry);
+		spin_unlock(&ff->fc->lock);
+
+		wait_event(fi->page_waitq, atomic_read(&ff->count) == 1);
+
+		/*
+		 * Wait for threads just released ff to leave their critical
+		 * sections. Taking spinlock is the first thing
+		 * fuse_release_common does, so that this is unnecessary, but
+		 * it is still good to emphasize right here, that we need this.
+		 */
+		spin_unlock_wait(&ff->fc->lock);
+	}
+
 	fuse_release_common(file, FUSE_RELEASE);
 
 	/* return value is ignored by VFS */
@@ -610,8 +646,17 @@ static void fuse_readpages_end(struct fuse_conn *fc, struct fuse_req *req)
 		unlock_page(page);
 		page_cache_release(page);
 	}
-	if (req->ff)
-		fuse_file_put(req->ff, false);
+	if (req->ff) {
+		if (fc->close_wait) {
+			struct fuse_inode *fi = get_fuse_inode(req->inode);
+
+			spin_lock(&fc->lock);
+			__fuse_file_put(req->ff);
+			wake_up(&fi->page_waitq);
+			spin_unlock(&fc->lock);
+		} else
+			fuse_file_put(req->ff, false);
+	}
 }
 
 struct fuse_fill_data {
@@ -637,6 +682,7 @@ static void fuse_send_readpages(struct fuse_fill_data *data)
 	if (fc->async_read) {
 		req->ff = fuse_file_get(ff);
 		req->end = fuse_readpages_end;
+		req->inode = data->inode;
 		fuse_request_send_background(fc, req);
 	} else {
 		fuse_request_send(fc, req);
@@ -1178,7 +1224,8 @@ static ssize_t fuse_direct_write(struct file *file, const char __user *buf,
 static void fuse_writepage_free(struct fuse_conn *fc, struct fuse_req *req)
 {
 	__free_page(req->pages[0]);
-	fuse_file_put(req->ff, false);
+	if (!fc->close_wait)
+		fuse_file_put(req->ff, false);
 }
 
 static void fuse_writepage_finish(struct fuse_conn *fc, struct fuse_req *req)
@@ -1191,6 +1238,8 @@ static void fuse_writepage_finish(struct fuse_conn *fc, struct fuse_req *req)
 	dec_bdi_stat(bdi, BDI_WRITEBACK);
 	dec_zone_page_state(req->pages[0], NR_WRITEBACK_TEMP);
 	bdi_writeout_inc(bdi);
+	if (fc->close_wait)
+		__fuse_file_put(req->ff);
 	wake_up(&fi->page_waitq);
 }
 

