Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752823Ab2GTLuw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 07:50:52 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:34771 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752602Ab2GTLus (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 07:50:48 -0400
Subject: [PATCH 1/4] fuse: add basic support of iovec[] to fuse_req
To: miklos@szeredi.hu
From: Maxim Patlasov <mpatlasov@parallels.com>
Cc: fuse-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        devel@openvz.org
Date: Fri, 20 Jul 2012 15:50:23 +0400
Message-ID: <20120720115015.15517.5557.stgit@maximpc.sw.ru>
In-Reply-To: <20120720114653.15517.74290.stgit@maximpc.sw.ru>
References: <20120720114653.15517.74290.stgit@maximpc.sw.ru>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch allows fuse_req to refer to array of iovec-s describing
layout of user-data over req->pages. fuse_copy_pages() is re-worked to
support both cased: former layout where pages[] corresponded to <buf, len>
and newer one where pages[] corresponds to iovec[].

Signed-off-by: Maxim Patlasov <mpatlasov@parallels.com>
---
 fs/fuse/dev.c    |   52 +++++++++++++++++++++++++++++++++++++++++++++++++---
 fs/fuse/fuse_i.h |   12 ++++++++++--
 2 files changed, 59 insertions(+), 5 deletions(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 7df2b5e..cdae525 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -850,9 +850,9 @@ static int fuse_copy_page(struct fuse_copy_state *cs, struct page **pagep,
 	return 0;
 }
 
-/* Copy pages in the request to/from userspace buffer */
-static int fuse_copy_pages(struct fuse_copy_state *cs, unsigned nbytes,
-			   int zeroing)
+/* Start from addr(pages[0]) + page_offset. No holes in the middle. */
+static int fuse_copy_pages_for_buf(struct fuse_copy_state *cs, unsigned nbytes,
+				   int zeroing)
 {
 	unsigned i;
 	struct fuse_req *req = cs->req;
@@ -874,6 +874,52 @@ static int fuse_copy_pages(struct fuse_copy_state *cs, unsigned nbytes,
 	return 0;
 }
 
+/* Take iov_offset as offset in iovec[0]. Iterate based on iovec[].iov_len */
+static int fuse_copy_pages_for_iovec(struct fuse_copy_state *cs,
+				     unsigned nbytes, int zeroing)
+{
+	unsigned i;
+	struct fuse_req *req = cs->req;
+	const struct iovec *iov = req->iovec;
+	unsigned iov_offset = req->iov_offset;
+
+	for (i = 0; i < req->num_pages && (nbytes || zeroing); i++) {
+		int err;
+		unsigned long user_addr = (unsigned long)iov->iov_base +
+					  iov_offset;
+		unsigned offset = user_addr & ~PAGE_MASK;
+		unsigned count = min_t(size_t, PAGE_SIZE - offset,
+				       iov->iov_len - iov_offset);
+		count = min(nbytes, count);
+
+		err = fuse_copy_page(cs, &req->pages[i], offset, count,
+				     zeroing);
+		if (err)
+			return err;
+
+		nbytes -= count;
+
+		if (count < iov->iov_len - iov_offset) {
+			iov_offset += count;
+		} else {
+			iov++;
+			iov_offset = 0;
+		}
+	}
+
+	return 0;
+}
+
+/* Copy pages in the request to/from userspace buffer */
+static int fuse_copy_pages(struct fuse_copy_state *cs, unsigned nbytes,
+			   int zeroing)
+{
+	if (cs->req->iovec)
+		return fuse_copy_pages_for_iovec(cs, nbytes, zeroing);
+	else
+		return fuse_copy_pages_for_buf(cs, nbytes, zeroing);
+}
+
 /* Copy a single argument in the request to/from userspace buffer */
 static int fuse_copy_one(struct fuse_copy_state *cs, void *val, unsigned size)
 {
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index 771fb63..255b7cd 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -296,8 +296,16 @@ struct fuse_req {
 	/** number of pages in vector */
 	unsigned num_pages;
 
-	/** offset of data on first page */
-	unsigned page_offset;
+	/** If set, it describes layout of user-data in pages[] */
+	const struct iovec *iovec;
+
+	union {
+		/** offset of data on first page */
+		unsigned page_offset;
+
+		/** or in first iovec */
+		unsigned iov_offset;
+	};
 
 	/** File used in the request (or NULL) */
 	struct fuse_file *ff;

