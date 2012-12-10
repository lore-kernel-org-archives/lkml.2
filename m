Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752653Ab2LJHld (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 02:41:33 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:36399 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752469Ab2LJHlb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 02:41:31 -0500
Subject: [PATCH 1/6] fuse: move fuse_release_user_pages() up
To: miklos@szeredi.hu
From: "Maxim V. Patlasov" <MPatlasov@parallels.com>
Cc: dev@parallels.com, xemul@parallels.com, fuse-devel@lists.sourceforge.net,
        bfoster@redhat.com, linux-kernel@vger.kernel.org, devel@openvz.org
Date: Mon, 10 Dec 2012 11:41:34 +0400
Message-ID: <20121210074126.12240.92431.stgit@maximpc.sw.ru>
In-Reply-To: <20121210073848.12240.88144.stgit@maximpc.sw.ru>
References: <20121210073848.12240.88144.stgit@maximpc.sw.ru>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fuse_release_user_pages() will be indirectly used by fuse_send_read/write
in future patches.

Signed-off-by: Maxim Patlasov <mpatlasov@parallels.com>
---
 fs/fuse/file.c |   24 ++++++++++++------------
 1 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 19b50e7..6685cb0 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -491,6 +491,18 @@ void fuse_read_fill(struct fuse_req *req, struct file *file, loff_t pos,
 	req->out.args[0].size = count;
 }
 
+static void fuse_release_user_pages(struct fuse_req *req, int write)
+{
+	unsigned i;
+
+	for (i = 0; i < req->num_pages; i++) {
+		struct page *page = req->pages[i];
+		if (write)
+			set_page_dirty_lock(page);
+		put_page(page);
+	}
+}
+
 static size_t fuse_send_read(struct fuse_req *req, struct file *file,
 			     loff_t pos, size_t count, fl_owner_t owner)
 {
@@ -1035,18 +1047,6 @@ out:
 	return written ? written : err;
 }
 
-static void fuse_release_user_pages(struct fuse_req *req, int write)
-{
-	unsigned i;
-
-	for (i = 0; i < req->num_pages; i++) {
-		struct page *page = req->pages[i];
-		if (write)
-			set_page_dirty_lock(page);
-		put_page(page);
-	}
-}
-
 static inline void fuse_page_descs_length_init(struct fuse_req *req,
 		unsigned index, unsigned nr_pages)
 {

