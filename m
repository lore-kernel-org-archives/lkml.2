Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753045Ab2KPRJn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 12:09:43 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:38321 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752475Ab2KPRJj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 12:09:39 -0500
Subject: [PATCH 08/14] fuse: Flush files on wb close
To: miklos@szeredi.hu
From: Maxim Patlasov <mpatlasov@parallels.com>
Cc: dev@parallels.com, fuse-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, jbottomley@parallels.com,
        viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        xemul@openvz.org
Date: Fri, 16 Nov 2012 21:09:26 +0400
Message-ID: <20121116170907.3196.25447.stgit@maximpc.sw.ru>
In-Reply-To: <20121116170123.3196.93431.stgit@maximpc.sw.ru>
References: <20121116170123.3196.93431.stgit@maximpc.sw.ru>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Any write request requires a file handle to report to the userspace. Thus
when we close a file (and free the fuse_file with this info) we have to
flush all the outstanding writeback cache. Note, that simply calling the
filemap_write_and_wait() is not enough since fuse finishes page writeback
immediately and thus the -wait part of the mentioned call will be no-op.
Do real wait on per-inode writepages list.

Signed-off-by: Maxim Patlasov <MPatlasov@parallels.com>
Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
---
 fs/fuse/file.c |   26 +++++++++++++++++++++++++-
 1 files changed, 25 insertions(+), 1 deletions(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 3fee4a8..de9726a 100644
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
@@ -285,8 +291,23 @@ static int fuse_open(struct inode *inode, struct file *file)
 	return fuse_open_common(inode, file, false);
 }
 
+static void fuse_flush_writeback(struct inode *inode, struct file *file)
+{
+	struct fuse_conn *fc = get_fuse_conn(inode);
+	struct fuse_inode *fi = get_fuse_inode(inode);
+
+	filemap_write_and_wait(file->f_mapping);
+	wait_event(fi->page_waitq, list_empty_careful(&fi->writepages));
+	spin_unlock_wait(&fc->lock);
+}
+
 static int fuse_release(struct inode *inode, struct file *file)
 {
+	struct fuse_conn *fc = get_fuse_conn(inode);
+
+	if (fc->writeback_cache)
+		fuse_flush_writeback(inode, file);
+
 	fuse_release_common(file, FUSE_RELEASE);
 
 	/* return value is ignored by VFS */
@@ -1241,7 +1262,8 @@ static void fuse_writepage_free(struct fuse_conn *fc, struct fuse_req *req)
 
 	for (i = 0; i < req->num_pages; i++)
 		__free_page(req->pages[i]);
-	fuse_file_put(req->ff, false);
+	if (!fc->writeback_cache)
+		fuse_file_put(req->ff, false);
 }
 
 static void fuse_writepage_finish(struct fuse_conn *fc, struct fuse_req *req)
@@ -1258,6 +1280,8 @@ static void fuse_writepage_finish(struct fuse_conn *fc, struct fuse_req *req)
 	}
 	bdi_writeout_inc(bdi);
 	wake_up(&fi->page_waitq);
+	if (fc->writeback_cache)
+		__fuse_file_put(req->ff);
 }
 
 /* Called under fc->lock, may release and reacquire it */

