Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754512Ab1DSJDQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 05:03:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25139 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754146Ab1DSJCh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 05:02:37 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Benjamin Marzinski <bmarzins@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 2/4] GFS2: directly write blocks past i_size
Date: Tue, 19 Apr 2011 09:40:07 +0100
Message-Id: <1303202409-3317-3-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1303202409-3317-1-git-send-email-swhiteho@redhat.com>
References: <1303202409-3317-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Marzinski <bmarzins@redhat.com>

GFS2 was relying on the writepage code to write out the zeroed data for
fallocate.  However, with FALLOC_FL_KEEP_SIZE set, this may be past i_size.
If it is, it will be ignored.  To work around this, gfs2 now calls
write_dirty_buffer directly on the buffer_heads when FALLOC_FL_KEEP_SIZE
is set, and it's writing past i_size.

This version is just a cleanup of my last version

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
index b2682e0..e483108 100644
--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -617,18 +617,51 @@ static ssize_t gfs2_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
 	return generic_file_aio_write(iocb, iov, nr_segs, pos);
 }
 
-static void empty_write_end(struct page *page, unsigned from,
-			   unsigned to)
+static int empty_write_end(struct page *page, unsigned from,
+			   unsigned to, int mode)
 {
-	struct gfs2_inode *ip = GFS2_I(page->mapping->host);
+	struct inode *inode = page->mapping->host;
+	struct gfs2_inode *ip = GFS2_I(inode);
+	struct buffer_head *bh;
+	unsigned offset, blksize = 1 << inode->i_blkbits;
+	pgoff_t end_index = i_size_read(inode) >> PAGE_CACHE_SHIFT;
 
 	zero_user(page, from, to-from);
 	mark_page_accessed(page);
 
-	if (!gfs2_is_writeback(ip))
-		gfs2_page_add_databufs(ip, page, from, to);
+	if (page->index < end_index || !(mode & FALLOC_FL_KEEP_SIZE)) {
+		if (!gfs2_is_writeback(ip))
+			gfs2_page_add_databufs(ip, page, from, to);
+
+		block_commit_write(page, from, to);
+		return 0;
+	}
+
+	offset = 0;
+	bh = page_buffers(page);
+	while (offset < to) {
+		if (offset >= from) {
+			set_buffer_uptodate(bh);
+			mark_buffer_dirty(bh);
+			clear_buffer_new(bh);
+			write_dirty_buffer(bh, WRITE);
+		}
+		offset += blksize;
+		bh = bh->b_this_page;
+	}
 
-	block_commit_write(page, from, to);
+	offset = 0;
+	bh = page_buffers(page);
+	while (offset < to) {
+		if (offset >= from) {
+			wait_on_buffer(bh);
+			if (!buffer_uptodate(bh))
+				return -EIO;
+		}
+		offset += blksize;
+		bh = bh->b_this_page;
+	}
+	return 0;
 }
 
 static int needs_empty_write(sector_t block, struct inode *inode)
@@ -643,7 +676,8 @@ static int needs_empty_write(sector_t block, struct inode *inode)
 	return !buffer_mapped(&bh_map);
 }
 
-static int write_empty_blocks(struct page *page, unsigned from, unsigned to)
+static int write_empty_blocks(struct page *page, unsigned from, unsigned to,
+			      int mode)
 {
 	struct inode *inode = page->mapping->host;
 	unsigned start, end, next, blksize;
@@ -668,7 +702,9 @@ static int write_empty_blocks(struct page *page, unsigned from, unsigned to)
 							  gfs2_block_map);
 				if (unlikely(ret))
 					return ret;
-				empty_write_end(page, start, end);
+				ret = empty_write_end(page, start, end, mode);
+				if (unlikely(ret))
+					return ret;
 				end = 0;
 			}
 			start = next;
@@ -682,7 +718,9 @@ static int write_empty_blocks(struct page *page, unsigned from, unsigned to)
 		ret = __block_write_begin(page, start, end - start, gfs2_block_map);
 		if (unlikely(ret))
 			return ret;
-		empty_write_end(page, start, end);
+		ret = empty_write_end(page, start, end, mode);
+		if (unlikely(ret))
+			return ret;
 	}
 
 	return 0;
@@ -731,7 +769,7 @@ static int fallocate_chunk(struct inode *inode, loff_t offset, loff_t len,
 
 		if (curr == end)
 			to = end_offset;
-		error = write_empty_blocks(page, from, to);
+		error = write_empty_blocks(page, from, to, mode);
 		if (!error && offset + to > inode->i_size &&
 		    !(mode & FALLOC_FL_KEEP_SIZE)) {
 			i_size_write(inode, offset + to);
-- 
1.7.4

