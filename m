Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754814Ab2IGRl3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 13:41:29 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:46123 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753833Ab2IGRl0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 13:41:26 -0400
Subject: [PATCH 3/6] fuse: rework fuse_retrieve()
To: miklos@szeredi.hu
From: Maxim Patlasov <mpatlasov@parallels.com>
Cc: fuse-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        devel@openvz.org
Date: Fri, 07 Sep 2012 21:41:32 +0400
Message-ID: <20120907174124.1343.29510.stgit@maximpc.sw.ru>
In-Reply-To: <20120907172536.1343.80497.stgit@maximpc.sw.ru>
References: <20120907172536.1343.80497.stgit@maximpc.sw.ru>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch reworks fuse_retrieve() to allocate only so many page pointers
as needed. The core part of the patch is the following calculation:

	num_pages = (num + offset + PAGE_SIZE - 1) >> PAGE_SHIFT;

(thanks Miklos for formula). All other changes are moslty shuffling lines.

The patch also contains one-line fix suggested by Miklos: the loop iterating
over pages from inode mapping should interpret 'offset' as offset in the very
first page only.
---
 fs/fuse/dev.c |   26 ++++++++++++++++----------
 1 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 6e38af5..cf69df3 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -1562,13 +1562,24 @@ static int fuse_retrieve(struct fuse_conn *fc, struct inode *inode,
 	unsigned int num;
 	unsigned int offset;
 	size_t total_len = 0;
+	int num_pages;
 
-	req = fuse_get_req_multipage(fc, FUSE_MAX_PAGES_PER_REQ);
+	offset = outarg->offset & ~PAGE_CACHE_MASK;
+	file_size = i_size_read(inode);
+
+	num = outarg->size;
+	if (outarg->offset > file_size)
+		num = 0;
+	else if (outarg->offset + num > file_size)
+		num = file_size - outarg->offset;
+
+	num_pages = (num + offset + PAGE_SIZE - 1) >> PAGE_SHIFT;
+	num_pages = min(num_pages, FUSE_MAX_PAGES_PER_REQ);
+
+	req = fuse_get_req_multipage(fc, num_pages);
 	if (IS_ERR(req))
 		return PTR_ERR(req);
 
-	offset = outarg->offset & ~PAGE_CACHE_MASK;
-
 	req->in.h.opcode = FUSE_NOTIFY_REPLY;
 	req->in.h.nodeid = outarg->nodeid;
 	req->in.numargs = 2;
@@ -1577,14 +1588,8 @@ static int fuse_retrieve(struct fuse_conn *fc, struct inode *inode,
 	req->end = fuse_retrieve_end;
 
 	index = outarg->offset >> PAGE_CACHE_SHIFT;
-	file_size = i_size_read(inode);
-	num = outarg->size;
-	if (outarg->offset > file_size)
-		num = 0;
-	else if (outarg->offset + num > file_size)
-		num = file_size - outarg->offset;
 
-	while (num && req->num_pages < FUSE_MAX_PAGES_PER_REQ) {
+	while (num && req->num_pages < num_pages) {
 		struct page *page;
 		unsigned int this_num;
 
@@ -1596,6 +1601,7 @@ static int fuse_retrieve(struct fuse_conn *fc, struct inode *inode,
 		req->pages[req->num_pages] = page;
 		req->num_pages++;
 
+		offset = 0;
 		num -= this_num;
 		total_len += this_num;
 		index++;

