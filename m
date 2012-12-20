Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752069Ab2LTMbm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 07:31:42 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:24684 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751114Ab2LTMbf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 07:31:35 -0500
Subject: [PATCH 2/5] fuse: cosmetic rework of fuse_send_readpages
To: miklos@szeredi.hu
From: Maxim Patlasov <mpatlasov@parallels.com>
Cc: dev@parallels.com, xemul@parallels.com, fuse-devel@lists.sourceforge.net,
        bfoster@redhat.com, linux-kernel@vger.kernel.org, devel@openvz.org,
        anand.avati@gmail.com
Date: Thu, 20 Dec 2012 16:31:39 +0400
Message-ID: <20121220123118.4101.43322.stgit@maximpc.sw.ru>
In-Reply-To: <20121220122702.4101.80042.stgit@maximpc.sw.ru>
References: <20121220122702.4101.80042.stgit@maximpc.sw.ru>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch change arguments of fuse_send_readpages to give it access to inode
(will be used in the next patch of patch-set). The change is cosmetic,
no logic changed.

Signed-off-by: Maxim Patlasov <mpatlasov@parallels.com>
---
 fs/fuse/file.c |   20 +++++++++++---------
 1 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 78d2837..4f23134 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -614,8 +614,16 @@ static void fuse_readpages_end(struct fuse_conn *fc, struct fuse_req *req)
 		fuse_file_put(req->ff, false);
 }
 
-static void fuse_send_readpages(struct fuse_req *req, struct file *file)
+struct fuse_fill_data {
+	struct fuse_req *req;
+	struct file *file;
+	struct inode *inode;
+};
+
+static void fuse_send_readpages(struct fuse_fill_data *data)
 {
+	struct fuse_req *req = data->req;
+	struct file *file = data->file;
 	struct fuse_file *ff = file->private_data;
 	struct fuse_conn *fc = ff->fc;
 	loff_t pos = page_offset(req->pages[0]);
@@ -637,12 +645,6 @@ static void fuse_send_readpages(struct fuse_req *req, struct file *file)
 	}
 }
 
-struct fuse_fill_data {
-	struct fuse_req *req;
-	struct file *file;
-	struct inode *inode;
-};
-
 static int fuse_readpages_fill(void *_data, struct page *page)
 {
 	struct fuse_fill_data *data = _data;
@@ -656,7 +658,7 @@ static int fuse_readpages_fill(void *_data, struct page *page)
 	    (req->num_pages == FUSE_MAX_PAGES_PER_REQ ||
 	     (req->num_pages + 1) * PAGE_CACHE_SIZE > fc->max_read ||
 	     req->pages[req->num_pages - 1]->index + 1 != page->index)) {
-		fuse_send_readpages(req, data->file);
+		fuse_send_readpages(data);
 		data->req = req = fuse_get_req(fc);
 		if (IS_ERR(req)) {
 			unlock_page(page);
@@ -691,7 +693,7 @@ static int fuse_readpages(struct file *file, struct address_space *mapping,
 	err = read_cache_pages(mapping, pages, fuse_readpages_fill, &data);
 	if (!err) {
 		if (data.req->num_pages)
-			fuse_send_readpages(data.req, file);
+			fuse_send_readpages(&data);
 		else
 			fuse_put_request(fc, data.req);
 	}

