Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756679Ab1COJeW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 05:34:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2312 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756297Ab1COJeT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 05:34:19 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Cc: Benjamin Marzinski <bmarzins@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 11/15] GFS2: fix block allocation check for fallocate
Date: Tue, 15 Mar 2011 09:11:41 +0000
Message-Id: <1300180305-5993-12-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1300180305-5993-1-git-send-email-swhiteho@redhat.com>
References: <1300180305-5993-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Marzinski <bmarzins@redhat.com>

GFS2 fallocate wasn't properly checking if a blocks were already allocated.
In write_empty_blocks(), if a page didn't have buffer_heads attached, GFS2
was always treating it as if there were no blocks allocated for that page.
GFS2 now calls gfs2_block_map() to check if the blocks are allocated before
writing them out.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
index 2878481..4074b95 100644
--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -622,8 +622,7 @@ static void empty_write_end(struct page *page, unsigned from,
 {
 	struct gfs2_inode *ip = GFS2_I(page->mapping->host);
 
-	page_zero_new_buffers(page, from, to);
-	flush_dcache_page(page);
+	zero_user(page, from, to-from);
 	mark_page_accessed(page);
 
 	if (!gfs2_is_writeback(ip))
@@ -632,36 +631,43 @@ static void empty_write_end(struct page *page, unsigned from,
 	block_commit_write(page, from, to);
 }
 
-static int write_empty_blocks(struct page *page, unsigned from, unsigned to)
+static int needs_empty_write(sector_t block, struct inode *inode)
 {
-	unsigned start, end, next;
-	struct buffer_head *bh, *head;
 	int error;
+	struct buffer_head bh_map = { .b_state = 0, .b_blocknr = 0 };
 
-	if (!page_has_buffers(page)) {
-		error = __block_write_begin(page, from, to - from, gfs2_block_map);
-		if (unlikely(error))
-			return error;
+	bh_map.b_size = 1 << inode->i_blkbits;
+	error = gfs2_block_map(inode, block, &bh_map, 0);
+	if (unlikely(error))
+		return error;
+	return !buffer_mapped(&bh_map);
+}
 
-		empty_write_end(page, from, to);
-		return 0;
-	}
+static int write_empty_blocks(struct page *page, unsigned from, unsigned to)
+{
+	struct inode *inode = page->mapping->host;
+	unsigned start, end, next, blksize;
+	sector_t block = page->index << (PAGE_CACHE_SHIFT - inode->i_blkbits);
+	int ret;
 
-	bh = head = page_buffers(page);
+	blksize = 1 << inode->i_blkbits;
 	next = end = 0;
 	while (next < from) {
-		next += bh->b_size;
-		bh = bh->b_this_page;
+		next += blksize;
+		block++;
 	}
 	start = next;
 	do {
-		next += bh->b_size;
-		if (buffer_mapped(bh)) {
+		next += blksize;
+		ret = needs_empty_write(block, inode);
+		if (unlikely(ret < 0))
+			return ret;
+		if (ret == 0) {
 			if (end) {
-				error = __block_write_begin(page, start, end - start,
-							    gfs2_block_map);
-				if (unlikely(error))
-					return error;
+				ret = __block_write_begin(page, start, end - start,
+							  gfs2_block_map);
+				if (unlikely(ret))
+					return ret;
 				empty_write_end(page, start, end);
 				end = 0;
 			}
@@ -669,13 +675,13 @@ static int write_empty_blocks(struct page *page, unsigned from, unsigned to)
 		}
 		else
 			end = next;
-		bh = bh->b_this_page;
+		block++;
 	} while (next < to);
 
 	if (end) {
-		error = __block_write_begin(page, start, end - start, gfs2_block_map);
-		if (unlikely(error))
-			return error;
+		ret = __block_write_begin(page, start, end - start, gfs2_block_map);
+		if (unlikely(ret))
+			return ret;
 		empty_write_end(page, start, end);
 	}
 
-- 
1.7.4

