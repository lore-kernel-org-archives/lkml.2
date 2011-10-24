Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932487Ab1JXMtx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 08:49:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38114 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932410Ab1JXMrt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 08:47:49 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 16/24] GFS2: Fix AIL flush issue during fsync
Date: Mon, 24 Oct 2011 13:48:30 +0100
Message-Id: <1319460518-9046-17-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1319460518-9046-1-git-send-email-swhiteho@redhat.com>
References: <1319460518-9046-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unfortunately, it is not enough to just ignore locked buffers during
the AIL flush from fsync. We need to be able to ignore all buffers
which are locked, dirty or pinned at this stage as they might have
been added subsequent to the log flush earlier in the fsync function.

In addition, this means that we no longer need to rely on i_mutex to
keep out writes during fsync, so we can, as a side-effect, remove
that protection too.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
Tested-By: Abhijith Das <adas@redhat.com>

diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
index 3467f36..3b65f67 100644
--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -593,16 +593,12 @@ static int gfs2_fsync(struct file *file, loff_t start, loff_t end,
 		sync_state &= ~I_DIRTY_SYNC;
 
 	if (sync_state) {
-		mutex_lock(&inode->i_mutex);
 		ret = sync_inode_metadata(inode, 1);
-		if (ret) {
-			mutex_unlock(&inode->i_mutex);
+		if (ret)
 			return ret;
-		}
 		if (gfs2_is_jdata(ip))
 			filemap_write_and_wait(mapping);
-		gfs2_ail_flush(ip->i_gl);
-		mutex_unlock(&inode->i_mutex);
+		gfs2_ail_flush(ip->i_gl, 1);
 	}
 
 	if (mapping->nrpages)
diff --git a/fs/gfs2/glops.c b/fs/gfs2/glops.c
index 951541b..78418b4 100644
--- a/fs/gfs2/glops.c
+++ b/fs/gfs2/glops.c
@@ -42,41 +42,41 @@ static void gfs2_ail_error(struct gfs2_glock *gl, const struct buffer_head *bh)
 /**
  * __gfs2_ail_flush - remove all buffers for a given lock from the AIL
  * @gl: the glock
+ * @fsync: set when called from fsync (not all buffers will be clean)
  *
  * None of the buffers should be dirty, locked, or pinned.
  */
 
-static void __gfs2_ail_flush(struct gfs2_glock *gl, unsigned long b_state)
+static void __gfs2_ail_flush(struct gfs2_glock *gl, bool fsync)
 {
 	struct gfs2_sbd *sdp = gl->gl_sbd;
 	struct list_head *head = &gl->gl_ail_list;
-	struct gfs2_bufdata *bd;
+	struct gfs2_bufdata *bd, *tmp;
 	struct buffer_head *bh;
+	const unsigned long b_state = (1UL << BH_Dirty)|(1UL << BH_Pinned)|(1UL << BH_Lock);
 	sector_t blocknr;
 
+	gfs2_log_lock(sdp);
 	spin_lock(&sdp->sd_ail_lock);
-	while (!list_empty(head)) {
-		bd = list_entry(head->next, struct gfs2_bufdata,
-				bd_ail_gl_list);
+	list_for_each_entry_safe(bd, tmp, head, bd_ail_gl_list) {
 		bh = bd->bd_bh;
-		blocknr = bh->b_blocknr;
-		if (bh->b_state & b_state)
+		if (bh->b_state & b_state) {
+			if (fsync)
+				continue;
 			gfs2_ail_error(gl, bh);
+		}
+		blocknr = bh->b_blocknr;
 		bh->b_private = NULL;
 		gfs2_remove_from_ail(bd); /* drops ref on bh */
-		spin_unlock(&sdp->sd_ail_lock);
 
 		bd->bd_bh = NULL;
 		bd->bd_blkno = blocknr;
 
-		gfs2_log_lock(sdp);
 		gfs2_trans_add_revoke(sdp, bd);
-		gfs2_log_unlock(sdp);
-
-		spin_lock(&sdp->sd_ail_lock);
 	}
-	gfs2_assert_withdraw(sdp, !atomic_read(&gl->gl_ail_count));
+	BUG_ON(!fsync && atomic_read(&gl->gl_ail_count));
 	spin_unlock(&sdp->sd_ail_lock);
+	gfs2_log_unlock(sdp);
 }
 
 
@@ -99,13 +99,13 @@ static void gfs2_ail_empty_gl(struct gfs2_glock *gl)
 	BUG_ON(current->journal_info);
 	current->journal_info = &tr;
 
-	__gfs2_ail_flush(gl, (1ul << BH_Dirty)|(1ul << BH_Pinned)|(1ul << BH_Lock));
+	__gfs2_ail_flush(gl, 0);
 
 	gfs2_trans_end(sdp);
 	gfs2_log_flush(sdp, NULL);
 }
 
-void gfs2_ail_flush(struct gfs2_glock *gl)
+void gfs2_ail_flush(struct gfs2_glock *gl, bool fsync)
 {
 	struct gfs2_sbd *sdp = gl->gl_sbd;
 	unsigned int revokes = atomic_read(&gl->gl_ail_count);
@@ -117,7 +117,7 @@ void gfs2_ail_flush(struct gfs2_glock *gl)
 	ret = gfs2_trans_begin(sdp, 0, revokes);
 	if (ret)
 		return;
-	__gfs2_ail_flush(gl, (1ul << BH_Dirty)|(1ul << BH_Pinned));
+	__gfs2_ail_flush(gl, fsync);
 	gfs2_trans_end(sdp);
 	gfs2_log_flush(sdp, NULL);
 }
diff --git a/fs/gfs2/glops.h b/fs/gfs2/glops.h
index 6fce409..bf95a2d 100644
--- a/fs/gfs2/glops.h
+++ b/fs/gfs2/glops.h
@@ -23,6 +23,6 @@ extern const struct gfs2_glock_operations gfs2_quota_glops;
 extern const struct gfs2_glock_operations gfs2_journal_glops;
 extern const struct gfs2_glock_operations *gfs2_glops_list[];
 
-extern void gfs2_ail_flush(struct gfs2_glock *gl);
+extern void gfs2_ail_flush(struct gfs2_glock *gl, bool fsync);
 
 #endif /* __GLOPS_DOT_H__ */
diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index 87e9141..71e4209 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -1533,7 +1533,7 @@ static void gfs2_evict_inode(struct inode *inode)
 out_truncate:
 	gfs2_log_flush(sdp, ip->i_gl);
 	write_inode_now(inode, 1);
-	gfs2_ail_flush(ip->i_gl);
+	gfs2_ail_flush(ip->i_gl, 0);
 
 	/* Case 2 starts here */
 	error = gfs2_trans_begin(sdp, 0, sdp->sd_jdesc->jd_blocks);
-- 
1.7.4.4

