Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760943Ab2EQMsq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 08:48:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2777 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761813Ab2EQMsn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 08:48:43 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 12/24] GFS2: Remove bd_list_tr
Date: Thu, 17 May 2012 13:23:19 +0100
Message-Id: <1337257411-3173-13-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1337257411-3173-1-git-send-email-swhiteho@redhat.com>
References: <1337257411-3173-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is another clean up in the logging code. This per-transaction
list was largely unused. Its main function was to ensure that the
number of buffers in a transaction was correct, however that counter
was only used to check the number of buffers in the bd_list_tr, plus
an assert at the end of each transaction. With the assert now changed
to use the calculated buffer counts, we can remove both bd_list_tr and
its associated counter.

This should make the code easier to understand as well as shrinking
a couple of structures.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/aops.c b/fs/gfs2/aops.c
index 56dc1f0..a627b3e 100644
--- a/fs/gfs2/aops.c
+++ b/fs/gfs2/aops.c
@@ -1084,7 +1084,6 @@ int gfs2_releasepage(struct page *page, gfp_t gfp_mask)
 		bd = bh->b_private;
 		if (bd) {
 			gfs2_assert_warn(sdp, bd->bd_bh == bh);
-			gfs2_assert_warn(sdp, list_empty(&bd->bd_list_tr));
 			if (!list_empty(&bd->bd_le.le_list)) {
 				if (!buffer_pinned(bh))
 					list_del_init(&bd->bd_le.le_list);
diff --git a/fs/gfs2/glops.c b/fs/gfs2/glops.c
index 1656df7..cd3e6fb 100644
--- a/fs/gfs2/glops.c
+++ b/fs/gfs2/glops.c
@@ -94,7 +94,6 @@ static void gfs2_ail_empty_gl(struct gfs2_glock *gl)
 	/* A shortened, inline version of gfs2_trans_begin() */
 	tr.tr_reserved = 1 + gfs2_struct2blk(sdp, tr.tr_revokes, sizeof(u64));
 	tr.tr_ip = (unsigned long)__builtin_return_address(0);
-	INIT_LIST_HEAD(&tr.tr_list_buf);
 	gfs2_log_reserve(sdp, tr.tr_reserved);
 	BUG_ON(current->journal_info);
 	current->journal_info = &tr;
diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index dd97f64..e773fbc 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -118,13 +118,7 @@ TAS_BUFFER_FNS(Zeronew, zeronew)
 struct gfs2_bufdata {
 	struct buffer_head *bd_bh;
 	struct gfs2_glock *bd_gl;
-
-	union {
-		struct list_head list_tr;
-		u64 blkno;
-	} u;
-#define bd_list_tr u.list_tr
-#define bd_blkno u.blkno
+	u64 bd_blkno;
 
 	struct gfs2_log_element bd_le;
 
@@ -411,13 +405,10 @@ struct gfs2_trans {
 
 	int tr_touched;
 
-	unsigned int tr_num_buf;
 	unsigned int tr_num_buf_new;
 	unsigned int tr_num_databuf_new;
 	unsigned int tr_num_buf_rm;
 	unsigned int tr_num_databuf_rm;
-	struct list_head tr_list_buf;
-
 	unsigned int tr_num_revoke;
 	unsigned int tr_num_revoke_rm;
 };
diff --git a/fs/gfs2/log.c b/fs/gfs2/log.c
index f5eacb3..2307218 100644
--- a/fs/gfs2/log.c
+++ b/fs/gfs2/log.c
@@ -696,21 +696,6 @@ static void log_refund(struct gfs2_sbd *sdp, struct gfs2_trans *tr)
 	gfs2_log_unlock(sdp);
 }
 
-static void buf_lo_incore_commit(struct gfs2_sbd *sdp, struct gfs2_trans *tr)
-{
-	struct list_head *head = &tr->tr_list_buf;
-	struct gfs2_bufdata *bd;
-
-	gfs2_log_lock(sdp);
-	while (!list_empty(head)) {
-		bd = list_entry(head->next, struct gfs2_bufdata, bd_list_tr);
-		list_del_init(&bd->bd_list_tr);
-		tr->tr_num_buf--;
-	}
-	gfs2_log_unlock(sdp);
-	gfs2_assert_warn(sdp, !tr->tr_num_buf);
-}
-
 /**
  * gfs2_log_commit - Commit a transaction to the log
  * @sdp: the filesystem
@@ -729,8 +714,6 @@ static void buf_lo_incore_commit(struct gfs2_sbd *sdp, struct gfs2_trans *tr)
 void gfs2_log_commit(struct gfs2_sbd *sdp, struct gfs2_trans *tr)
 {
 	log_refund(sdp, tr);
-	buf_lo_incore_commit(sdp, tr);
-
 	up_read(&sdp->sd_log_flush_lock);
 
 	if (atomic_read(&sdp->sd_log_pinned) > atomic_read(&sdp->sd_log_thresh1) ||
diff --git a/fs/gfs2/lops.c b/fs/gfs2/lops.c
index 7882671..e9709da 100644
--- a/fs/gfs2/lops.c
+++ b/fs/gfs2/lops.c
@@ -396,12 +396,8 @@ static void buf_lo_add(struct gfs2_sbd *sdp, struct gfs2_log_element *le)
 
 	lock_buffer(bd->bd_bh);
 	gfs2_log_lock(sdp);
-	if (!list_empty(&bd->bd_list_tr))
-		goto out;
 	tr = current->journal_info;
 	tr->tr_touched = 1;
-	tr->tr_num_buf++;
-	list_add(&bd->bd_list_tr, &tr->tr_list_buf);
 	if (!list_empty(&le->le_list))
 		goto out;
 	set_bit(GLF_LFLUSH, &bd->bd_gl->gl_flags);
@@ -781,18 +777,10 @@ static void databuf_lo_add(struct gfs2_sbd *sdp, struct gfs2_log_element *le)
 
 	lock_buffer(bd->bd_bh);
 	gfs2_log_lock(sdp);
-	if (tr) {
-		if (!list_empty(&bd->bd_list_tr))
-			goto out;
+	if (tr)
 		tr->tr_touched = 1;
-		if (gfs2_is_jdata(ip)) {
-			tr->tr_num_buf++;
-			list_add(&bd->bd_list_tr, &tr->tr_list_buf);
-		}
-	}
 	if (!list_empty(&le->le_list))
 		goto out;
-
 	set_bit(GLF_LFLUSH, &bd->bd_gl->gl_flags);
 	set_bit(GLF_DIRTY, &bd->bd_gl->gl_flags);
 	if (gfs2_is_jdata(ip)) {
diff --git a/fs/gfs2/meta_io.c b/fs/gfs2/meta_io.c
index 181586e..8a82a4d 100644
--- a/fs/gfs2/meta_io.c
+++ b/fs/gfs2/meta_io.c
@@ -293,7 +293,6 @@ void gfs2_attach_bufdata(struct gfs2_glock *gl, struct buffer_head *bh,
 	bd->bd_bh = bh;
 	bd->bd_gl = gl;
 
-	INIT_LIST_HEAD(&bd->bd_list_tr);
 	if (meta)
 		lops_init_le(&bd->bd_le, &gfs2_buf_lops);
 	else
diff --git a/fs/gfs2/trans.c b/fs/gfs2/trans.c
index 86ac75d..8fb6317 100644
--- a/fs/gfs2/trans.c
+++ b/fs/gfs2/trans.c
@@ -50,8 +50,6 @@ int gfs2_trans_begin(struct gfs2_sbd *sdp, unsigned int blocks,
 	if (revokes)
 		tr->tr_reserved += gfs2_struct2blk(sdp, revokes,
 						   sizeof(u64));
-	INIT_LIST_HEAD(&tr->tr_list_buf);
-
 	gfs2_holder_init(sdp->sd_trans_gl, LM_ST_SHARED, 0, &tr->tr_t_gh);
 
 	error = gfs2_glock_nq(&tr->tr_t_gh);
@@ -93,10 +91,21 @@ static void gfs2_log_release(struct gfs2_sbd *sdp, unsigned int blks)
 	up_read(&sdp->sd_log_flush_lock);
 }
 
+static void gfs2_print_trans(const struct gfs2_trans *tr)
+{
+	print_symbol(KERN_WARNING "GFS2: Transaction created at: %s\n", tr->tr_ip);
+	printk(KERN_WARNING "GFS2: blocks=%u revokes=%u reserved=%u touched=%d\n",
+	       tr->tr_blocks, tr->tr_revokes, tr->tr_reserved, tr->tr_touched);
+	printk(KERN_WARNING "GFS2: Buf %u/%u Databuf %u/%u Revoke %u/%u\n",
+	       tr->tr_num_buf_new, tr->tr_num_buf_rm,
+	       tr->tr_num_databuf_new, tr->tr_num_databuf_rm,
+	       tr->tr_num_revoke, tr->tr_num_revoke_rm);
+}
+
 void gfs2_trans_end(struct gfs2_sbd *sdp)
 {
 	struct gfs2_trans *tr = current->journal_info;
-
+	s64 nbuf;
 	BUG_ON(!tr);
 	current->journal_info = NULL;
 
@@ -110,16 +119,13 @@ void gfs2_trans_end(struct gfs2_sbd *sdp)
 		return;
 	}
 
-	if (gfs2_assert_withdraw(sdp, tr->tr_num_buf <= tr->tr_blocks)) {
-		fs_err(sdp, "tr_num_buf = %u, tr_blocks = %u ",
-		       tr->tr_num_buf, tr->tr_blocks);
-		print_symbol(KERN_WARNING "GFS2: Transaction created at: %s\n", tr->tr_ip);
-	}
-	if (gfs2_assert_withdraw(sdp, tr->tr_num_revoke <= tr->tr_revokes)) {
-		fs_err(sdp, "tr_num_revoke = %u, tr_revokes = %u ",
-		       tr->tr_num_revoke, tr->tr_revokes);
-		print_symbol(KERN_WARNING "GFS2: Transaction created at: %s\n", tr->tr_ip);
-	}
+	nbuf = tr->tr_num_buf_new + tr->tr_num_databuf_new;
+	nbuf -= tr->tr_num_buf_rm;
+	nbuf -= tr->tr_num_databuf_rm;
+
+	if (gfs2_assert_withdraw(sdp, (nbuf <= tr->tr_blocks) &&
+				       (tr->tr_num_revoke <= tr->tr_revokes)))
+		gfs2_print_trans(tr);
 
 	gfs2_log_commit(sdp, tr);
 	if (tr->tr_t_gh.gh_gl) {
-- 
1.7.4

