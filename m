Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755327Ab0EQM6J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 08:58:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52522 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755298Ab0EQM6F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 08:58:05 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 03/11] GFS2: Clean up stuffed file copying
Date: Mon, 17 May 2010 13:40:17 +0100
Message-Id: <1274100025-26629-4-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1274100025-26629-3-git-send-email-swhiteho@redhat.com>
References: <1274100025-26629-1-git-send-email-swhiteho@redhat.com>
 <1274100025-26629-2-git-send-email-swhiteho@redhat.com>
 <1274100025-26629-3-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the inode size was corrupt for stuffed files, it was possible
for the copying of data to overrun the block and/or page. This patch
checks for that condition so that this is no longer possible.

This is also preparation for the new truncate sequence patch which
requires the ability to have stuffed files with larger sizes than
(disk block size - sizeof(on disk inode)) with the restriction that
only the initial part of the file may be non-zero.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
---
 fs/gfs2/aops.c |    8 +++++---
 fs/gfs2/bmap.c |   17 ++++++++++-------
 2 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/fs/gfs2/aops.c b/fs/gfs2/aops.c
index 0c1d0b8..a739a0a 100644
--- a/fs/gfs2/aops.c
+++ b/fs/gfs2/aops.c
@@ -418,6 +418,7 @@ static int gfs2_jdata_writepages(struct address_space *mapping,
 static int stuffed_readpage(struct gfs2_inode *ip, struct page *page)
 {
 	struct buffer_head *dibh;
+	u64 dsize = i_size_read(&ip->i_inode);
 	void *kaddr;
 	int error;
 
@@ -437,9 +438,10 @@ static int stuffed_readpage(struct gfs2_inode *ip, struct page *page)
 		return error;
 
 	kaddr = kmap_atomic(page, KM_USER0);
-	memcpy(kaddr, dibh->b_data + sizeof(struct gfs2_dinode),
-	       ip->i_disksize);
-	memset(kaddr + ip->i_disksize, 0, PAGE_CACHE_SIZE - ip->i_disksize);
+	if (dsize > (dibh->b_size - sizeof(struct gfs2_dinode)))
+		dsize = (dibh->b_size - sizeof(struct gfs2_dinode));
+	memcpy(kaddr, dibh->b_data + sizeof(struct gfs2_dinode), dsize);
+	memset(kaddr + dsize, 0, PAGE_CACHE_SIZE - dsize);
 	kunmap_atomic(kaddr, KM_USER0);
 	flush_dcache_page(page);
 	brelse(dibh);
diff --git a/fs/gfs2/bmap.c b/fs/gfs2/bmap.c
index 583e823..0db0cd9 100644
--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -72,11 +72,13 @@ static int gfs2_unstuffer_page(struct gfs2_inode *ip, struct buffer_head *dibh,
 
 	if (!PageUptodate(page)) {
 		void *kaddr = kmap(page);
+		u64 dsize = i_size_read(inode);
+ 
+		if (dsize > (dibh->b_size - sizeof(struct gfs2_dinode)))
+			dsize = dibh->b_size - sizeof(struct gfs2_dinode);
 
-		memcpy(kaddr, dibh->b_data + sizeof(struct gfs2_dinode),
-		       ip->i_disksize);
-		memset(kaddr + ip->i_disksize, 0,
-		       PAGE_CACHE_SIZE - ip->i_disksize);
+		memcpy(kaddr, dibh->b_data + sizeof(struct gfs2_dinode), dsize);
+		memset(kaddr + dsize, 0, PAGE_CACHE_SIZE - dsize);
 		kunmap(page);
 
 		SetPageUptodate(page);
@@ -1039,13 +1041,14 @@ static int trunc_start(struct gfs2_inode *ip, u64 size)
 		goto out;
 
 	if (gfs2_is_stuffed(ip)) {
-		ip->i_disksize = size;
+		u64 dsize = size + sizeof(struct gfs2_inode);
 		ip->i_inode.i_mtime = ip->i_inode.i_ctime = CURRENT_TIME;
 		gfs2_trans_add_bh(ip->i_gl, dibh, 1);
 		gfs2_dinode_out(ip, dibh->b_data);
-		gfs2_buffer_clear_tail(dibh, sizeof(struct gfs2_dinode) + size);
+		if (dsize > dibh->b_size)
+			dsize = dibh->b_size;
+		gfs2_buffer_clear_tail(dibh, dsize);
 		error = 1;
-
 	} else {
 		if (size & (u64)(sdp->sd_sb.sb_bsize - 1))
 			error = gfs2_block_truncate_page(ip->i_inode.i_mapping);
-- 
1.6.2.5

