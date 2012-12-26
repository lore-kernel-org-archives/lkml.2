Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754499Ab2LZMo7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2012 07:44:59 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:37875 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754486Ab2LZMo4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2012 07:44:56 -0500
Subject: [PATCH 1/3] fuse: make request allocations for background processing
 explicit
To: miklos@szeredi.hu
From: Maxim Patlasov <mpatlasov@parallels.com>
Cc: dev@parallels.com, xemul@parallels.com, fuse-devel@lists.sourceforge.net,
        bfoster@redhat.com, linux-kernel@vger.kernel.org, devel@openvz.org
Date: Wed, 26 Dec 2012 16:44:45 +0400
Message-ID: <20121226124431.24502.72951.stgit@maximpc.sw.ru>
In-Reply-To: <20121226124319.24502.41536.stgit@maximpc.sw.ru>
References: <20121226124319.24502.41536.stgit@maximpc.sw.ru>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are two types of processing requests in FUSE: synchronous (via
fuse_request_send()) and asynchronous (via adding to fc->bg_queue).

Fortunately, the type of processing is always known in advance, at the time
of request allocation. This preparatory patch utilizes this fact making
fuse_get_req() aware about the type. Next patches will use it.

Signed-off-by: Maxim Patlasov <mpatlasov@parallels.com>
---
 fs/fuse/cuse.c   |    2 +-
 fs/fuse/dev.c    |   22 +++++++++++++++++++---
 fs/fuse/file.c   |    5 +++--
 fs/fuse/fuse_i.h |    3 +++
 fs/fuse/inode.c  |    1 +
 5 files changed, 27 insertions(+), 6 deletions(-)

diff --git a/fs/fuse/cuse.c b/fs/fuse/cuse.c
index ee8d550..37e18dc 100644
--- a/fs/fuse/cuse.c
+++ b/fs/fuse/cuse.c
@@ -411,7 +411,7 @@ static int cuse_send_init(struct cuse_conn *cc)
 
 	BUILD_BUG_ON(CUSE_INIT_INFO_MAX > PAGE_SIZE);
 
-	req = fuse_get_req(fc);
+	req = fuse_get_req_for_background(fc);
 	if (IS_ERR(req)) {
 		rc = PTR_ERR(req);
 		goto err;
diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 8c23fa7..0b6b9d1 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -55,8 +55,10 @@ EXPORT_SYMBOL_GPL(fuse_request_alloc);
 struct fuse_req *fuse_request_alloc_nofs(void)
 {
 	struct fuse_req *req = kmem_cache_alloc(fuse_req_cachep, GFP_NOFS);
-	if (req)
+	if (req) {
 		fuse_request_init(req);
+		req->background = 1; /* writeback always goes to bg_queue */
+	}
 	return req;
 }
 
@@ -97,7 +99,8 @@ static void fuse_req_init_context(struct fuse_req *req)
 	req->in.h.pid = current->pid;
 }
 
-struct fuse_req *fuse_get_req(struct fuse_conn *fc)
+struct fuse_req *fuse_get_req_internal(struct fuse_conn *fc,
+				       bool for_background)
 {
 	struct fuse_req *req;
 	sigset_t oldset;
@@ -123,14 +126,26 @@ struct fuse_req *fuse_get_req(struct fuse_conn *fc)
 
 	fuse_req_init_context(req);
 	req->waiting = 1;
+	req->background = for_background;
 	return req;
 
  out:
 	atomic_dec(&fc->num_waiting);
 	return ERR_PTR(err);
 }
+
+struct fuse_req *fuse_get_req(struct fuse_conn *fc)
+{
+	return fuse_get_req_internal(fc, 0);
+}
 EXPORT_SYMBOL_GPL(fuse_get_req);
 
+struct fuse_req *fuse_get_req_for_background(struct fuse_conn *fc)
+{
+	return fuse_get_req_internal(fc, 1);
+}
+EXPORT_SYMBOL_GPL(fuse_get_req_for_background);
+
 /*
  * Return request in fuse_file->reserved_req.  However that may
  * currently be in use.  If that is the case, wait for it to become
@@ -408,6 +423,7 @@ __acquires(fc->lock)
 
 void fuse_request_send(struct fuse_conn *fc, struct fuse_req *req)
 {
+	BUG_ON(req->background);
 	req->isreply = 1;
 	spin_lock(&fc->lock);
 	if (!fc->connected)
@@ -430,7 +446,7 @@ EXPORT_SYMBOL_GPL(fuse_request_send);
 static void fuse_request_send_nowait_locked(struct fuse_conn *fc,
 					    struct fuse_req *req)
 {
-	req->background = 1;
+	BUG_ON(!req->background);
 	fc->num_background++;
 	if (fc->num_background == fc->max_background)
 		fc->blocked = 1;
diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 78d2837..86101ce 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -131,6 +131,7 @@ static void fuse_file_put(struct fuse_file *ff, bool sync)
 			fuse_put_request(ff->fc, req);
 		} else {
 			req->end = fuse_release_end;
+			req->background = 1;
 			fuse_request_send_background(ff->fc, req);
 		}
 		kfree(ff);
@@ -657,7 +658,7 @@ static int fuse_readpages_fill(void *_data, struct page *page)
 	     (req->num_pages + 1) * PAGE_CACHE_SIZE > fc->max_read ||
 	     req->pages[req->num_pages - 1]->index + 1 != page->index)) {
 		fuse_send_readpages(req, data->file);
-		data->req = req = fuse_get_req(fc);
+		data->req = req = fuse_get_req_internal(fc, fc->async_read);
 		if (IS_ERR(req)) {
 			unlock_page(page);
 			return PTR_ERR(req);
@@ -683,7 +684,7 @@ static int fuse_readpages(struct file *file, struct address_space *mapping,
 
 	data.file = file;
 	data.inode = inode;
-	data.req = fuse_get_req(fc);
+	data.req = fuse_get_req_internal(fc, fc->async_read);
 	err = PTR_ERR(data.req);
 	if (IS_ERR(data.req))
 		goto out;
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index e24dd74..70362e9 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -671,6 +671,9 @@ void fuse_request_free(struct fuse_req *req);
  * Get a request, may fail with -ENOMEM
  */
 struct fuse_req *fuse_get_req(struct fuse_conn *fc);
+struct fuse_req *fuse_get_req_for_background(struct fuse_conn *fc);
+struct fuse_req *fuse_get_req_internal(struct fuse_conn *fc,
+				       bool for_background);
 
 /**
  * Gets a requests for a file operation, always succeeds
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index f0eda12..c0f0eba 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -1032,6 +1032,7 @@ static int fuse_fill_super(struct super_block *sb, void *data, int silent)
 	init_req = fuse_request_alloc();
 	if (!init_req)
 		goto err_put_root;
+	init_req->background = 1;
 
 	if (is_bdev) {
 		fc->destroy_req = fuse_request_alloc();

