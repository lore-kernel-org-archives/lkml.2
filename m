Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753159Ab2KPRKS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 12:10:18 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:7946 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753006Ab2KPRKP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 12:10:15 -0500
Subject: [PATCH 10/14] fuse: fuse_writepage_locked() should wait on writeback
To: miklos@szeredi.hu
From: Maxim Patlasov <mpatlasov@parallels.com>
Cc: dev@parallels.com, fuse-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, jbottomley@parallels.com,
        viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        xemul@openvz.org
Date: Fri, 16 Nov 2012 21:09:55 +0400
Message-ID: <20121116170944.3196.66478.stgit@maximpc.sw.ru>
In-Reply-To: <20121116170123.3196.93431.stgit@maximpc.sw.ru>
References: <20121116170123.3196.93431.stgit@maximpc.sw.ru>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fuse_writepage_locked() should never submit new i/o for given page->index
if there is another one 'in progress' already. In most cases it's safe to
wait on page writeback. But if it was called due to memory shortage
(WB_SYNC_NONE), we should redirty page rather than blocking caller.

Signed-off-by: Maxim Patlasov <MPatlasov@parallels.com>
---
 fs/fuse/file.c |   18 +++++++++++++++---
 1 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 3274708..4e4f6fd 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -1370,7 +1370,8 @@ static struct fuse_file *fuse_write_file(struct fuse_conn *fc,
 	return ff;
 }
 
-static int fuse_writepage_locked(struct page *page)
+static int fuse_writepage_locked(struct page *page,
+				 struct writeback_control *wbc)
 {
 	struct address_space *mapping = page->mapping;
 	struct inode *inode = mapping->host;
@@ -1379,6 +1380,14 @@ static int fuse_writepage_locked(struct page *page)
 	struct fuse_req *req;
 	struct page *tmp_page;
 
+	if (fuse_page_is_writeback(inode, page->index)) {
+		if (wbc->sync_mode != WB_SYNC_ALL) {
+			redirty_page_for_writepage(wbc, page);
+			return 0;
+		}
+		fuse_wait_on_page_writeback(inode, page->index);
+	}
+
 	set_page_writeback(page);
 
 	req = fuse_request_alloc_nofs();
@@ -1424,7 +1433,7 @@ static int fuse_writepage(struct page *page, struct writeback_control *wbc)
 {
 	int err;
 
-	err = fuse_writepage_locked(page);
+	err = fuse_writepage_locked(page, wbc);
 	unlock_page(page);
 
 	return err;
@@ -1678,7 +1687,10 @@ static int fuse_launder_page(struct page *page)
 	int err = 0;
 	if (clear_page_dirty_for_io(page)) {
 		struct inode *inode = page->mapping->host;
-		err = fuse_writepage_locked(page);
+		struct writeback_control wbc = {
+			.sync_mode = WB_SYNC_ALL,
+		};
+		err = fuse_writepage_locked(page, &wbc);
 		if (!err)
 			fuse_wait_on_page_writeback(inode, page->index);
 	}

