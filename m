Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761875Ab2EQMsy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 08:48:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21476 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761832Ab2EQMsv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 08:48:51 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Bob Peterson <rpeterso@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 17/24] GFS2: eliminate log elements and simplify
Date: Thu, 17 May 2012 13:23:24 +0100
Message-Id: <1337257411-3173-18-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1337257411-3173-1-git-send-email-swhiteho@redhat.com>
References: <1337257411-3173-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

This patch eliminates the gfs2_log_element data structure and
rolls its two components into the gfs2_bufdata. This makes the code
easier to understand and makes it easier to migrate to a rbtree
to keep the list sorted.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/aops.c b/fs/gfs2/aops.c
index 695bbe1..e80a464 100644
--- a/fs/gfs2/aops.c
+++ b/fs/gfs2/aops.c
@@ -942,8 +942,8 @@ static void gfs2_discard(struct gfs2_sbd *sdp, struct buffer_head *bh)
 	clear_buffer_dirty(bh);
 	bd = bh->b_private;
 	if (bd) {
-		if (!list_empty(&bd->bd_le.le_list) && !buffer_pinned(bh))
-			list_del_init(&bd->bd_le.le_list);
+		if (!list_empty(&bd->bd_list) && !buffer_pinned(bh))
+			list_del_init(&bd->bd_list);
 		else
 			gfs2_remove_from_journal(bh, current->journal_info, 0);
 	}
@@ -1083,9 +1083,9 @@ int gfs2_releasepage(struct page *page, gfp_t gfp_mask)
 		bd = bh->b_private;
 		if (bd) {
 			gfs2_assert_warn(sdp, bd->bd_bh == bh);
-			if (!list_empty(&bd->bd_le.le_list)) {
+			if (!list_empty(&bd->bd_list)) {
 				if (!buffer_pinned(bh))
-					list_del_init(&bd->bd_le.le_list);
+					list_del_init(&bd->bd_list);
 				else
 					bd = NULL;
 			}
diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index f1189a2..aa9949e 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -26,7 +26,7 @@
 #define DIO_METADATA	0x00000020
 
 struct gfs2_log_operations;
-struct gfs2_log_element;
+struct gfs2_bufdata;
 struct gfs2_holder;
 struct gfs2_glock;
 struct gfs2_quota_data;
@@ -52,7 +52,7 @@ struct gfs2_log_header_host {
  */
 
 struct gfs2_log_operations {
-	void (*lo_add) (struct gfs2_sbd *sdp, struct gfs2_log_element *le);
+	void (*lo_add) (struct gfs2_sbd *sdp, struct gfs2_bufdata *bd);
 	void (*lo_before_commit) (struct gfs2_sbd *sdp);
 	void (*lo_after_commit) (struct gfs2_sbd *sdp, struct gfs2_ail *ai);
 	void (*lo_before_scan) (struct gfs2_jdesc *jd,
@@ -64,11 +64,6 @@ struct gfs2_log_operations {
 	const char *lo_name;
 };
 
-struct gfs2_log_element {
-	struct list_head le_list;
-	const struct gfs2_log_operations *le_ops;
-};
-
 #define GBF_FULL 1
 
 struct gfs2_bitmap {
@@ -120,7 +115,8 @@ struct gfs2_bufdata {
 	struct gfs2_glock *bd_gl;
 	u64 bd_blkno;
 
-	struct gfs2_log_element bd_le;
+	struct list_head bd_list;
+	const struct gfs2_log_operations *bd_ops;
 
 	struct gfs2_ail *bd_ail;
 	struct list_head bd_ail_st_list;
diff --git a/fs/gfs2/log.c b/fs/gfs2/log.c
index db9cb18..f4beeb9 100644
--- a/fs/gfs2/log.c
+++ b/fs/gfs2/log.c
@@ -486,8 +486,8 @@ static int bd_cmp(void *priv, struct list_head *a, struct list_head *b)
 {
 	struct gfs2_bufdata *bda, *bdb;
 
-	bda = list_entry(a, struct gfs2_bufdata, bd_le.le_list);
-	bdb = list_entry(b, struct gfs2_bufdata, bd_le.le_list);
+	bda = list_entry(a, struct gfs2_bufdata, bd_list);
+	bdb = list_entry(b, struct gfs2_bufdata, bd_list);
 
 	if (bda->bd_bh->b_blocknr < bdb->bd_bh->b_blocknr)
 		return -1;
@@ -505,8 +505,8 @@ static void gfs2_ordered_write(struct gfs2_sbd *sdp)
 	gfs2_log_lock(sdp);
 	list_sort(NULL, &sdp->sd_log_le_ordered, &bd_cmp);
 	while (!list_empty(&sdp->sd_log_le_ordered)) {
-		bd = list_entry(sdp->sd_log_le_ordered.next, struct gfs2_bufdata, bd_le.le_list);
-		list_move(&bd->bd_le.le_list, &written);
+		bd = list_entry(sdp->sd_log_le_ordered.next, struct gfs2_bufdata, bd_list);
+		list_move(&bd->bd_list, &written);
 		bh = bd->bd_bh;
 		if (!buffer_dirty(bh))
 			continue;
@@ -533,7 +533,7 @@ static void gfs2_ordered_wait(struct gfs2_sbd *sdp)
 
 	gfs2_log_lock(sdp);
 	while (!list_empty(&sdp->sd_log_le_ordered)) {
-		bd = list_entry(sdp->sd_log_le_ordered.prev, struct gfs2_bufdata, bd_le.le_list);
+		bd = list_entry(sdp->sd_log_le_ordered.prev, struct gfs2_bufdata, bd_list);
 		bh = bd->bd_bh;
 		if (buffer_locked(bh)) {
 			get_bh(bh);
@@ -543,7 +543,7 @@ static void gfs2_ordered_wait(struct gfs2_sbd *sdp)
 			gfs2_log_lock(sdp);
 			continue;
 		}
-		list_del_init(&bd->bd_le.le_list);
+		list_del_init(&bd->bd_list);
 	}
 	gfs2_log_unlock(sdp);
 }
diff --git a/fs/gfs2/lops.c b/fs/gfs2/lops.c
index 11fedb5..852c1be 100644
--- a/fs/gfs2/lops.c
+++ b/fs/gfs2/lops.c
@@ -388,9 +388,8 @@ static struct page *gfs2_get_log_desc(struct gfs2_sbd *sdp, u32 ld_type,
 	return page;
 }
 
-static void buf_lo_add(struct gfs2_sbd *sdp, struct gfs2_log_element *le)
+static void buf_lo_add(struct gfs2_sbd *sdp, struct gfs2_bufdata *bd)
 {
-	struct gfs2_bufdata *bd = container_of(le, struct gfs2_bufdata, bd_le);
 	struct gfs2_meta_header *mh;
 	struct gfs2_trans *tr;
 
@@ -398,7 +397,7 @@ static void buf_lo_add(struct gfs2_sbd *sdp, struct gfs2_log_element *le)
 	gfs2_log_lock(sdp);
 	tr = current->journal_info;
 	tr->tr_touched = 1;
-	if (!list_empty(&le->le_list))
+	if (!list_empty(&bd->bd_list))
 		goto out;
 	set_bit(GLF_LFLUSH, &bd->bd_gl->gl_flags);
 	set_bit(GLF_DIRTY, &bd->bd_gl->gl_flags);
@@ -408,7 +407,7 @@ static void buf_lo_add(struct gfs2_sbd *sdp, struct gfs2_log_element *le)
 	mh->__pad0 = cpu_to_be64(0);
 	mh->mh_jid = cpu_to_be32(sdp->sd_jdesc->jd_jid);
 	sdp->sd_log_num_buf++;
-	list_add(&le->le_list, &sdp->sd_log_le_buf);
+	list_add(&bd->bd_list, &sdp->sd_log_le_buf);
 	tr->tr_num_buf_new++;
 out:
 	gfs2_log_unlock(sdp);
@@ -440,7 +439,7 @@ static void gfs2_before_commit(struct gfs2_sbd *sdp, unsigned int limit,
 	__be64 *ptr;
 
 	gfs2_log_lock(sdp);
-	bd1 = bd2 = list_prepare_entry(bd1, blist, bd_le.le_list);
+	bd1 = bd2 = list_prepare_entry(bd1, blist, bd_list);
 	while(total) {
 		num = total;
 		if (total > limit)
@@ -452,7 +451,7 @@ static void gfs2_before_commit(struct gfs2_sbd *sdp, unsigned int limit,
 		ptr = (__be64 *)(ld + 1);
 
 		n = 0;
-		list_for_each_entry_continue(bd1, blist, bd_le.le_list) {
+		list_for_each_entry_continue(bd1, blist, bd_list) {
 			*ptr++ = cpu_to_be64(bd1->bd_bh->b_blocknr);
 			if (is_databuf) {
 				gfs2_check_magic(bd1->bd_bh);
@@ -467,7 +466,7 @@ static void gfs2_before_commit(struct gfs2_sbd *sdp, unsigned int limit,
 		gfs2_log_lock(sdp);
 
 		n = 0;
-		list_for_each_entry_continue(bd2, blist, bd_le.le_list) {
+		list_for_each_entry_continue(bd2, blist, bd_list) {
 			get_bh(bd2->bd_bh);
 			gfs2_log_unlock(sdp);
 			lock_buffer(bd2->bd_bh);
@@ -513,8 +512,8 @@ static void buf_lo_after_commit(struct gfs2_sbd *sdp, struct gfs2_ail *ai)
 	struct gfs2_bufdata *bd;
 
 	while (!list_empty(head)) {
-		bd = list_entry(head->next, struct gfs2_bufdata, bd_le.le_list);
-		list_del_init(&bd->bd_le.le_list);
+		bd = list_entry(head->next, struct gfs2_bufdata, bd_list);
+		list_del_init(&bd->bd_list);
 		sdp->sd_log_num_buf--;
 
 		gfs2_unpin(sdp, bd->bd_bh, ai);
@@ -601,9 +600,8 @@ static void buf_lo_after_scan(struct gfs2_jdesc *jd, int error, int pass)
 	        jd->jd_jid, sdp->sd_replayed_blocks, sdp->sd_found_blocks);
 }
 
-static void revoke_lo_add(struct gfs2_sbd *sdp, struct gfs2_log_element *le)
+static void revoke_lo_add(struct gfs2_sbd *sdp, struct gfs2_bufdata *bd)
 {
-	struct gfs2_bufdata *bd = container_of(le, struct gfs2_bufdata, bd_le);
 	struct gfs2_glock *gl = bd->bd_gl;
 	struct gfs2_trans *tr;
 
@@ -613,7 +611,7 @@ static void revoke_lo_add(struct gfs2_sbd *sdp, struct gfs2_log_element *le)
 	sdp->sd_log_num_revoke++;
 	atomic_inc(&gl->gl_revokes);
 	set_bit(GLF_LFLUSH, &gl->gl_flags);
-	list_add(&le->le_list, &sdp->sd_log_le_revoke);
+	list_add(&bd->bd_list, &sdp->sd_log_le_revoke);
 }
 
 static void revoke_lo_before_commit(struct gfs2_sbd *sdp)
@@ -634,7 +632,7 @@ static void revoke_lo_before_commit(struct gfs2_sbd *sdp)
 	ld = page_address(page);
 	offset = sizeof(struct gfs2_log_descriptor);
 
-	list_for_each_entry(bd, head, bd_le.le_list) {
+	list_for_each_entry(bd, head, bd_list) {
 		sdp->sd_log_num_revoke--;
 
 		if (offset + sizeof(u64) > sdp->sd_sb.sb_bsize) {
@@ -664,8 +662,8 @@ static void revoke_lo_after_commit(struct gfs2_sbd *sdp, struct gfs2_ail *ai)
 	struct gfs2_glock *gl;
 
 	while (!list_empty(head)) {
-		bd = list_entry(head->next, struct gfs2_bufdata, bd_le.le_list);
-		list_del_init(&bd->bd_le.le_list);
+		bd = list_entry(head->next, struct gfs2_bufdata, bd_list);
+		list_del_init(&bd->bd_list);
 		gl = bd->bd_gl;
 		atomic_dec(&gl->gl_revokes);
 		clear_bit(GLF_LFLUSH, &gl->gl_flags);
@@ -768,9 +766,8 @@ static void revoke_lo_after_scan(struct gfs2_jdesc *jd, int error, int pass)
  *    blocks, which isn't an enormous overhead but twice as much as
  *    for normal metadata blocks.
  */
-static void databuf_lo_add(struct gfs2_sbd *sdp, struct gfs2_log_element *le)
+static void databuf_lo_add(struct gfs2_sbd *sdp, struct gfs2_bufdata *bd)
 {
-	struct gfs2_bufdata *bd = container_of(le, struct gfs2_bufdata, bd_le);
 	struct gfs2_trans *tr = current->journal_info;
 	struct address_space *mapping = bd->bd_bh->b_page->mapping;
 	struct gfs2_inode *ip = GFS2_I(mapping->host);
@@ -779,7 +776,7 @@ static void databuf_lo_add(struct gfs2_sbd *sdp, struct gfs2_log_element *le)
 	gfs2_log_lock(sdp);
 	if (tr)
 		tr->tr_touched = 1;
-	if (!list_empty(&le->le_list))
+	if (!list_empty(&bd->bd_list))
 		goto out;
 	set_bit(GLF_LFLUSH, &bd->bd_gl->gl_flags);
 	set_bit(GLF_DIRTY, &bd->bd_gl->gl_flags);
@@ -787,9 +784,9 @@ static void databuf_lo_add(struct gfs2_sbd *sdp, struct gfs2_log_element *le)
 		gfs2_pin(sdp, bd->bd_bh);
 		tr->tr_num_databuf_new++;
 		sdp->sd_log_num_databuf++;
-		list_add_tail(&le->le_list, &sdp->sd_log_le_databuf);
+		list_add_tail(&bd->bd_list, &sdp->sd_log_le_databuf);
 	} else {
-		list_add_tail(&le->le_list, &sdp->sd_log_le_ordered);
+		list_add_tail(&bd->bd_list, &sdp->sd_log_le_ordered);
 	}
 out:
 	gfs2_log_unlock(sdp);
@@ -885,8 +882,8 @@ static void databuf_lo_after_commit(struct gfs2_sbd *sdp, struct gfs2_ail *ai)
 	struct gfs2_bufdata *bd;
 
 	while (!list_empty(head)) {
-		bd = list_entry(head->next, struct gfs2_bufdata, bd_le.le_list);
-		list_del_init(&bd->bd_le.le_list);
+		bd = list_entry(head->next, struct gfs2_bufdata, bd_list);
+		list_del_init(&bd->bd_list);
 		sdp->sd_log_num_databuf--;
 		gfs2_unpin(sdp, bd->bd_bh, ai);
 	}
diff --git a/fs/gfs2/lops.h b/fs/gfs2/lops.h
index 825356d..954a330 100644
--- a/fs/gfs2/lops.h
+++ b/fs/gfs2/lops.h
@@ -46,17 +46,17 @@ static inline unsigned int databuf_limit(struct gfs2_sbd *sdp)
 	return limit;
 }
 
-static inline void lops_init_le(struct gfs2_log_element *le,
+static inline void lops_init_le(struct gfs2_bufdata *bd,
 				const struct gfs2_log_operations *lops)
 {
-	INIT_LIST_HEAD(&le->le_list);
-	le->le_ops = lops;
+	INIT_LIST_HEAD(&bd->bd_list);
+	bd->bd_ops = lops;
 }
 
-static inline void lops_add(struct gfs2_sbd *sdp, struct gfs2_log_element *le)
+static inline void lops_add(struct gfs2_sbd *sdp, struct gfs2_bufdata *bd)
 {
-	if (le->le_ops->lo_add)
-		le->le_ops->lo_add(sdp, le);
+	if (bd->bd_ops->lo_add)
+		bd->bd_ops->lo_add(sdp, bd);
 }
 
 static inline void lops_before_commit(struct gfs2_sbd *sdp)
diff --git a/fs/gfs2/meta_io.c b/fs/gfs2/meta_io.c
index 8a82a4d..7f69ae2 100644
--- a/fs/gfs2/meta_io.c
+++ b/fs/gfs2/meta_io.c
@@ -294,9 +294,9 @@ void gfs2_attach_bufdata(struct gfs2_glock *gl, struct buffer_head *bh,
 	bd->bd_gl = gl;
 
 	if (meta)
-		lops_init_le(&bd->bd_le, &gfs2_buf_lops);
+		lops_init_le(bd, &gfs2_buf_lops);
 	else
-		lops_init_le(&bd->bd_le, &gfs2_databuf_lops);
+		lops_init_le(bd, &gfs2_databuf_lops);
 	bh->b_private = bd;
 
 	if (meta)
@@ -312,7 +312,7 @@ void gfs2_remove_from_journal(struct buffer_head *bh, struct gfs2_trans *tr, int
 	if (test_clear_buffer_pinned(bh)) {
 		trace_gfs2_pin(bd, 0);
 		atomic_dec(&sdp->sd_log_pinned);
-		list_del_init(&bd->bd_le.le_list);
+		list_del_init(&bd->bd_list);
 		if (meta) {
 			gfs2_assert_warn(sdp, sdp->sd_log_num_buf);
 			sdp->sd_log_num_buf--;
diff --git a/fs/gfs2/trans.c b/fs/gfs2/trans.c
index 8fb6317..ad3e2fb 100644
--- a/fs/gfs2/trans.c
+++ b/fs/gfs2/trans.c
@@ -158,16 +158,16 @@ void gfs2_trans_add_bh(struct gfs2_glock *gl, struct buffer_head *bh, int meta)
 		gfs2_attach_bufdata(gl, bh, meta);
 		bd = bh->b_private;
 	}
-	lops_add(sdp, &bd->bd_le);
+	lops_add(sdp, bd);
 }
 
 void gfs2_trans_add_revoke(struct gfs2_sbd *sdp, struct gfs2_bufdata *bd)
 {
-	BUG_ON(!list_empty(&bd->bd_le.le_list));
+	BUG_ON(!list_empty(&bd->bd_list));
 	BUG_ON(!list_empty(&bd->bd_ail_st_list));
 	BUG_ON(!list_empty(&bd->bd_ail_gl_list));
-	lops_init_le(&bd->bd_le, &gfs2_revoke_lops);
-	lops_add(sdp, &bd->bd_le);
+	lops_init_le(bd, &gfs2_revoke_lops);
+	lops_add(sdp, bd);
 }
 
 void gfs2_trans_add_unrevoke(struct gfs2_sbd *sdp, u64 blkno, unsigned int len)
@@ -177,9 +177,9 @@ void gfs2_trans_add_unrevoke(struct gfs2_sbd *sdp, u64 blkno, unsigned int len)
 	unsigned int n = len;
 
 	gfs2_log_lock(sdp);
-	list_for_each_entry_safe(bd, tmp, &sdp->sd_log_le_revoke, bd_le.le_list) {
+	list_for_each_entry_safe(bd, tmp, &sdp->sd_log_le_revoke, bd_list) {
 		if ((bd->bd_blkno >= blkno) && (bd->bd_blkno < (blkno + len))) {
-			list_del_init(&bd->bd_le.le_list);
+			list_del_init(&bd->bd_list);
 			gfs2_assert_withdraw(sdp, sdp->sd_log_num_revoke);
 			sdp->sd_log_num_revoke--;
 			kmem_cache_free(gfs2_bufdata_cachep, bd);
-- 
1.7.4

