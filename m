Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966303Ab2EQMwL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 08:52:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58561 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761804Ab2EQMsl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 08:48:41 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 11/24] GFS2: Remove duplicate log code
Date: Thu, 17 May 2012 13:23:18 +0100
Message-Id: <1337257411-3173-12-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1337257411-3173-1-git-send-email-swhiteho@redhat.com>
References: <1337257411-3173-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The main part of this patch merges the two functions used to
write metadata and data buffers to the log. Most of the code
is common between the two functions, so this provides a nice
clean up, and makes the code more readable.

The gfs2_get_log_desc() function is also extended to take two more
arguments, and thus avoid having to set the length and data1
fields of this strucuture as a separate operation.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/lops.c b/fs/gfs2/lops.c
index 872d3e6..7882671 100644
--- a/fs/gfs2/lops.c
+++ b/fs/gfs2/lops.c
@@ -372,7 +372,8 @@ void gfs2_log_write_page(struct gfs2_sbd *sdp, struct page *page)
 	gfs2_log_write(sdp, page, sb->s_blocksize, 0);
 }
 
-static struct page *gfs2_get_log_desc(struct gfs2_sbd *sdp, u32 ld_type)
+static struct page *gfs2_get_log_desc(struct gfs2_sbd *sdp, u32 ld_type,
+				      u32 ld_length, u32 ld_data1)
 {
 	void *page = mempool_alloc(gfs2_page_pool, GFP_NOIO);
 	struct gfs2_log_descriptor *ld = page_address(page);
@@ -381,8 +382,8 @@ static struct page *gfs2_get_log_desc(struct gfs2_sbd *sdp, u32 ld_type)
 	ld->ld_header.mh_type = cpu_to_be32(GFS2_METATYPE_LD);
 	ld->ld_header.mh_format = cpu_to_be32(GFS2_FORMAT_LD);
 	ld->ld_type = cpu_to_be32(ld_type);
-	ld->ld_length = 0;
-	ld->ld_data1 = 0;
+	ld->ld_length = cpu_to_be32(ld_length);
+	ld->ld_data1 = cpu_to_be32(ld_data1);
 	ld->ld_data2 = 0;
 	return page;
 }
@@ -418,39 +419,49 @@ out:
 	unlock_buffer(bd->bd_bh);
 }
 
-static void buf_lo_before_commit(struct gfs2_sbd *sdp)
+static void gfs2_check_magic(struct buffer_head *bh)
+{
+	void *kaddr;
+	__be32 *ptr;
+
+	clear_buffer_escaped(bh);
+	kaddr = kmap_atomic(bh->b_page);
+	ptr = kaddr + bh_offset(bh);
+	if (*ptr == cpu_to_be32(GFS2_MAGIC))
+		set_buffer_escaped(bh);
+	kunmap_atomic(kaddr);
+}
+
+static void gfs2_before_commit(struct gfs2_sbd *sdp, unsigned int limit,
+				unsigned int total, struct list_head *blist,
+				bool is_databuf)
 {
 	struct gfs2_log_descriptor *ld;
 	struct gfs2_bufdata *bd1 = NULL, *bd2;
 	struct page *page;
-	unsigned int total;
-	unsigned int limit;
 	unsigned int num;
 	unsigned n;
 	__be64 *ptr;
 
-	limit = buf_limit(sdp);
-	/* for 4k blocks, limit = 503 */
-
 	gfs2_log_lock(sdp);
-	total = sdp->sd_log_num_buf;
-	bd1 = bd2 = list_prepare_entry(bd1, &sdp->sd_log_le_buf, bd_le.le_list);
+	bd1 = bd2 = list_prepare_entry(bd1, blist, bd_le.le_list);
 	while(total) {
 		num = total;
 		if (total > limit)
 			num = limit;
 		gfs2_log_unlock(sdp);
-		page = gfs2_get_log_desc(sdp, GFS2_LOG_DESC_METADATA);
+		page = gfs2_get_log_desc(sdp, GFS2_LOG_DESC_METADATA, num + 1, num);
 		ld = page_address(page);
 		gfs2_log_lock(sdp);
 		ptr = (__be64 *)(ld + 1);
-		ld->ld_length = cpu_to_be32(num + 1);
-		ld->ld_data1 = cpu_to_be32(num);
 
 		n = 0;
-		list_for_each_entry_continue(bd1, &sdp->sd_log_le_buf,
-					     bd_le.le_list) {
+		list_for_each_entry_continue(bd1, blist, bd_le.le_list) {
 			*ptr++ = cpu_to_be64(bd1->bd_bh->b_blocknr);
+			if (is_databuf) {
+				gfs2_check_magic(bd1->bd_bh);
+				*ptr++ = cpu_to_be64(buffer_escaped(bd1->bd_bh) ? 1 : 0);
+			}
 			if (++n >= num)
 				break;
 		}
@@ -460,12 +471,27 @@ static void buf_lo_before_commit(struct gfs2_sbd *sdp)
 		gfs2_log_lock(sdp);
 
 		n = 0;
-		list_for_each_entry_continue(bd2, &sdp->sd_log_le_buf,
-					     bd_le.le_list) {
+		list_for_each_entry_continue(bd2, blist, bd_le.le_list) {
 			get_bh(bd2->bd_bh);
 			gfs2_log_unlock(sdp);
 			lock_buffer(bd2->bd_bh);
-			gfs2_log_write_bh(sdp, bd2->bd_bh);
+
+			if (buffer_escaped(bd2->bd_bh)) {
+				void *kaddr;
+				page = mempool_alloc(gfs2_page_pool, GFP_NOIO);
+				ptr = page_address(page);
+				kaddr = kmap_atomic(bd2->bd_bh->b_page);
+				memcpy(ptr, kaddr + bh_offset(bd2->bd_bh),
+				       bd2->bd_bh->b_size);
+				kunmap_atomic(kaddr);
+				*(__be32 *)ptr = 0;
+				clear_buffer_escaped(bd2->bd_bh);
+				unlock_buffer(bd2->bd_bh);
+				brelse(bd2->bd_bh);
+				gfs2_log_write_page(sdp, page);
+			} else {
+				gfs2_log_write_bh(sdp, bd2->bd_bh);
+			}
 			gfs2_log_lock(sdp);
 			if (++n >= num)
 				break;
@@ -477,6 +503,14 @@ static void buf_lo_before_commit(struct gfs2_sbd *sdp)
 	gfs2_log_unlock(sdp);
 }
 
+static void buf_lo_before_commit(struct gfs2_sbd *sdp)
+{
+	unsigned int limit = buf_limit(sdp); /* 503 for 4k blocks */
+
+	gfs2_before_commit(sdp, limit, sdp->sd_log_num_buf,
+			   &sdp->sd_log_le_buf, 0);
+}
+
 static void buf_lo_after_commit(struct gfs2_sbd *sdp, struct gfs2_ail *ai)
 {
 	struct list_head *head = &sdp->sd_log_le_buf;
@@ -594,15 +628,14 @@ static void revoke_lo_before_commit(struct gfs2_sbd *sdp)
 	struct list_head *head = &sdp->sd_log_le_revoke;
 	struct gfs2_bufdata *bd;
 	struct page *page;
+	unsigned int length;
 
 	if (!sdp->sd_log_num_revoke)
 		return;
 
-	page = gfs2_get_log_desc(sdp, GFS2_LOG_DESC_REVOKE);
+	length = gfs2_struct2blk(sdp, sdp->sd_log_num_revoke, sizeof(u64));
+	page = gfs2_get_log_desc(sdp, GFS2_LOG_DESC_REVOKE, length, sdp->sd_log_num_revoke);
 	ld = page_address(page);
-	ld->ld_length = cpu_to_be32(gfs2_struct2blk(sdp, sdp->sd_log_num_revoke,
-						    sizeof(u64)));
-	ld->ld_data1 = cpu_to_be32(sdp->sd_log_num_revoke);
 	offset = sizeof(struct gfs2_log_descriptor);
 
 	list_for_each_entry(bd, head, bd_le.le_list) {
@@ -775,66 +808,6 @@ out:
 	unlock_buffer(bd->bd_bh);
 }
 
-static void gfs2_check_magic(struct buffer_head *bh)
-{
-	void *kaddr;
-	__be32 *ptr;
-
-	clear_buffer_escaped(bh);
-	kaddr = kmap_atomic(bh->b_page);
-	ptr = kaddr + bh_offset(bh);
-	if (*ptr == cpu_to_be32(GFS2_MAGIC))
-		set_buffer_escaped(bh);
-	kunmap_atomic(kaddr);
-}
-
-static void gfs2_write_blocks(struct gfs2_sbd *sdp,
-			      struct gfs2_log_descriptor *ld,
-			      struct page *page,
-			      struct list_head *list, struct list_head *done,
-			      unsigned int n)
-{
-	struct gfs2_bufdata *bd;
-	__be64 *ptr;
-
-	if (!ld)
-		return;
-
-	ld->ld_length = cpu_to_be32(n + 1);
-	ld->ld_data1 = cpu_to_be32(n);
-	ptr = (__force __be64 *)(ld + 1);
-	
-	gfs2_log_write_page(sdp, page);
-	gfs2_log_lock(sdp);
-	while (!list_empty(list)) {
-		bd = list_entry(list->next, struct gfs2_bufdata, bd_le.le_list);
-		list_move_tail(&bd->bd_le.le_list, done);
-		get_bh(bd->bd_bh);
-		gfs2_log_unlock(sdp);
-		lock_buffer(bd->bd_bh);
-		if (buffer_escaped(bd->bd_bh)) {
-			void *kaddr;
-			page = mempool_alloc(gfs2_page_pool, GFP_NOIO);
-			ptr = page_address(page);
-			kaddr = kmap_atomic(bd->bd_bh->b_page);
-			memcpy(ptr, kaddr + bh_offset(bd->bd_bh),
-			       bd->bd_bh->b_size);
-			kunmap_atomic(kaddr);
-			*(__be32 *)ptr = 0;
-			clear_buffer_escaped(bd->bd_bh);
-			unlock_buffer(bd->bd_bh);
-			brelse(bd->bd_bh);
-			gfs2_log_write_page(sdp, page);
-		} else {
-			gfs2_log_write_bh(sdp, bd->bd_bh);
-		}
-		n--;
-		gfs2_log_lock(sdp);
-	}
-	gfs2_log_unlock(sdp);
-	BUG_ON(n != 0);
-}
-
 /**
  * databuf_lo_before_commit - Scan the data buffers, writing as we go
  *
@@ -842,40 +815,10 @@ static void gfs2_write_blocks(struct gfs2_sbd *sdp,
 
 static void databuf_lo_before_commit(struct gfs2_sbd *sdp)
 {
-	struct gfs2_bufdata *bd = NULL;
-	struct gfs2_log_descriptor *ld = NULL;
-	struct page *page = NULL;
-	unsigned int n = 0;
-	__be64 *ptr = NULL, *end = NULL;
-	LIST_HEAD(processed);
-	LIST_HEAD(in_progress);
+	unsigned int limit = buf_limit(sdp) / 2;
 
-	gfs2_log_lock(sdp);
-	while (!list_empty(&sdp->sd_log_le_databuf)) {
-		if (ptr == end) {
-			gfs2_log_unlock(sdp);
-			gfs2_write_blocks(sdp, ld, page, &in_progress, &processed, n);
-			n = 0;
-			page = gfs2_get_log_desc(sdp, GFS2_LOG_DESC_JDATA);
-			ld = page_address(page);
-			ptr = (__force __be64 *)(ld + 1);
-			end = (__force __be64 *)(page_address(page) + sdp->sd_vfs->s_blocksize);
-			end--;
-			gfs2_log_lock(sdp);
-			continue;
-		}
-		bd = list_entry(sdp->sd_log_le_databuf.next, struct gfs2_bufdata, bd_le.le_list);
-		list_move_tail(&bd->bd_le.le_list, &in_progress);
-		gfs2_check_magic(bd->bd_bh);
-		*ptr++ = cpu_to_be64(bd->bd_bh->b_blocknr);
-		*ptr++ = cpu_to_be64(buffer_escaped(bd->bd_bh) ? 1 : 0);
-		n++;
-	}
-	gfs2_log_unlock(sdp);
-	gfs2_write_blocks(sdp, ld, page, &in_progress, &processed, n);
-	gfs2_log_lock(sdp);
-	list_splice(&processed, &sdp->sd_log_le_databuf);
-	gfs2_log_unlock(sdp);
+	gfs2_before_commit(sdp, limit, sdp->sd_log_num_databuf,
+			   &sdp->sd_log_le_databuf, 1);
 }
 
 static int databuf_lo_scan_elements(struct gfs2_jdesc *jd, unsigned int start,
-- 
1.7.4

