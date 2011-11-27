Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755439Ab1K0FfS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 00:35:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41716 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755355Ab1K0FfN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 00:35:13 -0500
From: Cong Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Cong Wang <amwang@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>, cluster-devel@redhat.com
Subject: [PATCH 36/62] gfs2: remove the second argument of k[un]map_atomic()
Date: Sun, 27 Nov 2011 13:27:16 +0800
Message-Id: <1322371662-26166-37-git-send-email-amwang@redhat.com>
In-Reply-To: <1322371662-26166-1-git-send-email-amwang@redhat.com>
References: <1322371662-26166-1-git-send-email-amwang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Cong Wang <amwang@redhat.com>
---
 fs/gfs2/aops.c  |   12 ++++++------
 fs/gfs2/lops.c  |    8 ++++----
 fs/gfs2/quota.c |    4 ++--
 3 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/fs/gfs2/aops.c b/fs/gfs2/aops.c
index 4858e1f..6cd6761 100644
--- a/fs/gfs2/aops.c
+++ b/fs/gfs2/aops.c
@@ -434,12 +434,12 @@ static int stuffed_readpage(struct gfs2_inode *ip, struct page *page)
 	if (error)
 		return error;
 
-	kaddr = kmap_atomic(page, KM_USER0);
+	kaddr = kmap_atomic(page);
 	if (dsize > (dibh->b_size - sizeof(struct gfs2_dinode)))
 		dsize = (dibh->b_size - sizeof(struct gfs2_dinode));
 	memcpy(kaddr, dibh->b_data + sizeof(struct gfs2_dinode), dsize);
 	memset(kaddr + dsize, 0, PAGE_CACHE_SIZE - dsize);
-	kunmap_atomic(kaddr, KM_USER0);
+	kunmap_atomic(kaddr);
 	flush_dcache_page(page);
 	brelse(dibh);
 	SetPageUptodate(page);
@@ -542,9 +542,9 @@ int gfs2_internal_read(struct gfs2_inode *ip, struct file_ra_state *ra_state,
 		page = read_cache_page(mapping, index, __gfs2_readpage, NULL);
 		if (IS_ERR(page))
 			return PTR_ERR(page);
-		p = kmap_atomic(page, KM_USER0);
+		p = kmap_atomic(page);
 		memcpy(buf + copied, p + offset, amt);
-		kunmap_atomic(p, KM_USER0);
+		kunmap_atomic(p);
 		mark_page_accessed(page);
 		page_cache_release(page);
 		copied += amt;
@@ -789,11 +789,11 @@ static int gfs2_stuffed_write_end(struct inode *inode, struct buffer_head *dibh,
 	unsigned char *buf = dibh->b_data + sizeof(struct gfs2_dinode);
 
 	BUG_ON((pos + len) > (dibh->b_size - sizeof(struct gfs2_dinode)));
-	kaddr = kmap_atomic(page, KM_USER0);
+	kaddr = kmap_atomic(page);
 	memcpy(buf + pos, kaddr + pos, copied);
 	memset(kaddr + pos + copied, 0, len - copied);
 	flush_dcache_page(page);
-	kunmap_atomic(kaddr, KM_USER0);
+	kunmap_atomic(kaddr);
 
 	if (!PageUptodate(page))
 		SetPageUptodate(page);
diff --git a/fs/gfs2/lops.c b/fs/gfs2/lops.c
index 0301be6..df7c6e8 100644
--- a/fs/gfs2/lops.c
+++ b/fs/gfs2/lops.c
@@ -553,11 +553,11 @@ static void gfs2_check_magic(struct buffer_head *bh)
 	__be32 *ptr;
 
 	clear_buffer_escaped(bh);
-	kaddr = kmap_atomic(bh->b_page, KM_USER0);
+	kaddr = kmap_atomic(bh->b_page);
 	ptr = kaddr + bh_offset(bh);
 	if (*ptr == cpu_to_be32(GFS2_MAGIC))
 		set_buffer_escaped(bh);
-	kunmap_atomic(kaddr, KM_USER0);
+	kunmap_atomic(kaddr);
 }
 
 static void gfs2_write_blocks(struct gfs2_sbd *sdp, struct buffer_head *bh,
@@ -594,10 +594,10 @@ static void gfs2_write_blocks(struct gfs2_sbd *sdp, struct buffer_head *bh,
 		if (buffer_escaped(bd->bd_bh)) {
 			void *kaddr;
 			bh1 = gfs2_log_get_buf(sdp);
-			kaddr = kmap_atomic(bd->bd_bh->b_page, KM_USER0);
+			kaddr = kmap_atomic(bd->bd_bh->b_page);
 			memcpy(bh1->b_data, kaddr + bh_offset(bd->bd_bh),
 			       bh1->b_size);
-			kunmap_atomic(kaddr, KM_USER0);
+			kunmap_atomic(kaddr);
 			*(__be32 *)bh1->b_data = 0;
 			clear_buffer_escaped(bd->bd_bh);
 			unlock_buffer(bd->bd_bh);
diff --git a/fs/gfs2/quota.c b/fs/gfs2/quota.c
index 7e528dc..762c1dd 100644
--- a/fs/gfs2/quota.c
+++ b/fs/gfs2/quota.c
@@ -720,12 +720,12 @@ get_a_page:
 
 	gfs2_trans_add_bh(ip->i_gl, bh, 0);
 
-	kaddr = kmap_atomic(page, KM_USER0);
+	kaddr = kmap_atomic(page);
 	if (offset + sizeof(struct gfs2_quota) > PAGE_CACHE_SIZE)
 		nbytes = PAGE_CACHE_SIZE - offset;
 	memcpy(kaddr + offset, ptr, nbytes);
 	flush_dcache_page(page);
-	kunmap_atomic(kaddr, KM_USER0);
+	kunmap_atomic(kaddr);
 	unlock_page(page);
 	page_cache_release(page);
 
-- 
1.7.4.4

