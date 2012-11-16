Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752572Ab2KPRHZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 12:07:25 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:22529 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752073Ab2KPRHW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 12:07:22 -0500
Subject: [PATCH 04/14] fuse: Prepare to handle multiple pages in writeback
To: miklos@szeredi.hu
From: Maxim Patlasov <mpatlasov@parallels.com>
Cc: dev@parallels.com, fuse-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, jbottomley@parallels.com,
        viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        xemul@openvz.org
Date: Fri, 16 Nov 2012 21:07:10 +0400
Message-ID: <20121116170703.3196.77938.stgit@maximpc.sw.ru>
In-Reply-To: <20121116170123.3196.93431.stgit@maximpc.sw.ru>
References: <20121116170123.3196.93431.stgit@maximpc.sw.ru>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The .writepages callback will issue writeback requests with more than one
page aboard. Make existing end/check code be aware of this.

Original patch by: Pavel Emelyanov <xemul@openvz.org>
Signed-off-by: Maxim Patlasov <MPatlasov@parallels.com>
---
 fs/fuse/file.c |   22 +++++++++++++++-------
 1 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 51804cf..0cc62f59 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -345,7 +345,8 @@ static bool fuse_page_is_writeback(struct inode *inode, pgoff_t index)
 
 		BUG_ON(req->inode != inode);
 		curr_index = req->misc.write.in.offset >> PAGE_CACHE_SHIFT;
-		if (curr_index == index) {
+		if (curr_index <= index &&
+		    index < curr_index + req->num_pages) {
 			found = true;
 			break;
 		}
@@ -1196,7 +1197,10 @@ static ssize_t fuse_direct_write(struct file *file, const char __user *buf,
 
 static void fuse_writepage_free(struct fuse_conn *fc, struct fuse_req *req)
 {
-	__free_page(req->pages[0]);
+	int i;
+
+	for (i = 0; i < req->num_pages; i++)
+		__free_page(req->pages[i]);
 	fuse_file_put(req->ff, false);
 }
 
@@ -1205,10 +1209,13 @@ static void fuse_writepage_finish(struct fuse_conn *fc, struct fuse_req *req)
 	struct inode *inode = req->inode;
 	struct fuse_inode *fi = get_fuse_inode(inode);
 	struct backing_dev_info *bdi = inode->i_mapping->backing_dev_info;
+	int i;
 
 	list_del(&req->writepages_entry);
-	dec_bdi_stat(bdi, BDI_WRITEBACK);
-	dec_zone_page_state(req->pages[0], NR_WRITEBACK_TEMP);
+	for (i = 0; i < req->num_pages; i++) {
+		dec_bdi_stat(bdi, BDI_WRITEBACK);
+		dec_zone_page_state(req->pages[i], NR_WRITEBACK_TEMP);
+	}
 	bdi_writeout_inc(bdi);
 	wake_up(&fi->page_waitq);
 }
@@ -1221,14 +1228,15 @@ __acquires(fc->lock)
 	struct fuse_inode *fi = get_fuse_inode(req->inode);
 	loff_t size = i_size_read(req->inode);
 	struct fuse_write_in *inarg = &req->misc.write.in;
+	__u64 data_size = req->num_pages * PAGE_CACHE_SIZE;
 
 	if (!fc->connected)
 		goto out_free;
 
-	if (inarg->offset + PAGE_CACHE_SIZE <= size) {
-		inarg->size = PAGE_CACHE_SIZE;
+	if (inarg->offset + data_size <= size) {
+		inarg->size = data_size;
 	} else if (inarg->offset < size) {
-		inarg->size = size & (PAGE_CACHE_SIZE - 1);
+		inarg->size = size - inarg->offset;
 	} else {
 		/* Got truncated off completely */
 		goto out_free;

