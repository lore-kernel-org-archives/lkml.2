Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752547Ab2KPRGD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 12:06:03 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:32541 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752267Ab2KPRF6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 12:05:58 -0500
Subject: [PATCH 02/14] fuse: Getting file for writeback helper
To: miklos@szeredi.hu
From: Maxim Patlasov <mpatlasov@parallels.com>
Cc: dev@parallels.com, fuse-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, jbottomley@parallels.com,
        viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        xemul@openvz.org
Date: Fri, 16 Nov 2012 21:05:43 +0400
Message-ID: <20121116170527.3196.13010.stgit@maximpc.sw.ru>
In-Reply-To: <20121116170123.3196.93431.stgit@maximpc.sw.ru>
References: <20121116170123.3196.93431.stgit@maximpc.sw.ru>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There will be a .writepageS callback implementation which will need to
get a fuse_file out of a fuse_inode, thus make a helper for this.

Signed-off-by: Maxim Patlasov <MPatlasov@parallels.com>
Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
---
 fs/fuse/file.c |   24 ++++++++++++++++--------
 1 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 9e85ef0..cd41b56 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -1276,6 +1276,20 @@ static void fuse_writepage_end(struct fuse_conn *fc, struct fuse_req *req)
 	fuse_writepage_free(fc, req);
 }
 
+static struct fuse_file *fuse_write_file(struct fuse_conn *fc,
+					 struct fuse_inode *fi)
+{
+	struct fuse_file *ff;
+
+	spin_lock(&fc->lock);
+	BUG_ON(list_empty(&fi->write_files));
+	ff = list_entry(fi->write_files.next, struct fuse_file, write_entry);
+	fuse_file_get(ff);
+	spin_unlock(&fc->lock);
+
+	return ff;
+}
+
 static int fuse_writepage_locked(struct page *page)
 {
 	struct address_space *mapping = page->mapping;
@@ -1283,7 +1297,6 @@ static int fuse_writepage_locked(struct page *page)
 	struct fuse_conn *fc = get_fuse_conn(inode);
 	struct fuse_inode *fi = get_fuse_inode(inode);
 	struct fuse_req *req;
-	struct fuse_file *ff;
 	struct page *tmp_page;
 
 	set_page_writeback(page);
@@ -1296,13 +1309,8 @@ static int fuse_writepage_locked(struct page *page)
 	if (!tmp_page)
 		goto err_free;
 
-	spin_lock(&fc->lock);
-	BUG_ON(list_empty(&fi->write_files));
-	ff = list_entry(fi->write_files.next, struct fuse_file, write_entry);
-	req->ff = fuse_file_get(ff);
-	spin_unlock(&fc->lock);
-
-	fuse_write_fill(req, ff, page_offset(page), 0);
+	req->ff = fuse_write_file(fc, fi);
+	fuse_write_fill(req, req->ff, page_offset(page), 0);
 
 	copy_highpage(tmp_page, page);
 	req->misc.write.in.write_flags |= FUSE_WRITE_CACHE;

