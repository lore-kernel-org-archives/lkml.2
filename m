Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933029Ab1ESJQU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 05:16:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4106 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932940Ab1ESJKQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 05:10:16 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 10/32] GFS2: Clean up fsync()
Date: Thu, 19 May 2011 09:47:05 +0100
Message-Id: <1305794847-3291-11-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1305794847-3291-1-git-send-email-swhiteho@redhat.com>
References: <1305794847-3291-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is designed to clean up GFS2's fsync
implementation and ensure that it really does get everything on
disk. Since ->write_inode() has been updated, we can call that
via the vfs library function sync_inode_metadata() and the only
remaining thing that has to be done is to ensure that we get
any revoke records in the log after the inode has been written back.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
index e483108..23eab47 100644
--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -545,18 +545,10 @@ static int gfs2_close(struct inode *inode, struct file *file)
 /**
  * gfs2_fsync - sync the dirty data for a file (across the cluster)
  * @file: the file that points to the dentry (we ignore this)
- * @dentry: the dentry that points to the inode to sync
+ * @datasync: set if we can ignore timestamp changes
  *
- * The VFS will flush "normal" data for us. We only need to worry
- * about metadata here. For journaled data, we just do a log flush
- * as we can't avoid it. Otherwise we can just bale out if datasync
- * is set. For stuffed inodes we must flush the log in order to
- * ensure that all data is on disk.
- *
- * The call to write_inode_now() is there to write back metadata and
- * the inode itself. It does also try and write the data, but thats
- * (hopefully) a no-op due to the VFS having already called filemap_fdatawrite()
- * for us.
+ * The VFS will flush data for us. We only need to worry
+ * about metadata here.
  *
  * Returns: errno
  */
@@ -565,22 +557,20 @@ static int gfs2_fsync(struct file *file, int datasync)
 {
 	struct inode *inode = file->f_mapping->host;
 	int sync_state = inode->i_state & (I_DIRTY_SYNC|I_DIRTY_DATASYNC);
-	int ret = 0;
-
-	if (gfs2_is_jdata(GFS2_I(inode))) {
-		gfs2_log_flush(GFS2_SB(inode), GFS2_I(inode)->i_gl);
-		return 0;
-	}
+	struct gfs2_inode *ip = GFS2_I(inode);
+	int ret;
 
-	if (sync_state != 0) {
-		if (!datasync)
-			ret = write_inode_now(inode, 0);
+	if (datasync)
+		sync_state &= ~I_DIRTY_SYNC;
 
-		if (gfs2_is_stuffed(GFS2_I(inode)))
-			gfs2_log_flush(GFS2_SB(inode), GFS2_I(inode)->i_gl);
+	if (sync_state) {
+		ret = sync_inode_metadata(inode, 1);
+		if (ret)
+			return ret;
+		gfs2_ail_flush(ip->i_gl);
 	}
 
-	return ret;
+	return 0;
 }
 
 /**
diff --git a/fs/gfs2/glops.c b/fs/gfs2/glops.c
index 25eeb2b..7c1b08f 100644
--- a/fs/gfs2/glops.c
+++ b/fs/gfs2/glops.c
@@ -28,33 +28,18 @@
 #include "trans.h"
 
 /**
- * ail_empty_gl - remove all buffers for a given lock from the AIL
+ * __gfs2_ail_flush - remove all buffers for a given lock from the AIL
  * @gl: the glock
  *
  * None of the buffers should be dirty, locked, or pinned.
  */
 
-static void gfs2_ail_empty_gl(struct gfs2_glock *gl)
+static void __gfs2_ail_flush(struct gfs2_glock *gl)
 {
 	struct gfs2_sbd *sdp = gl->gl_sbd;
 	struct list_head *head = &gl->gl_ail_list;
 	struct gfs2_bufdata *bd;
 	struct buffer_head *bh;
-	struct gfs2_trans tr;
-
-	memset(&tr, 0, sizeof(tr));
-	tr.tr_revokes = atomic_read(&gl->gl_ail_count);
-
-	if (!tr.tr_revokes)
-		return;
-
-	/* A shortened, inline version of gfs2_trans_begin() */
-	tr.tr_reserved = 1 + gfs2_struct2blk(sdp, tr.tr_revokes, sizeof(u64));
-	tr.tr_ip = (unsigned long)__builtin_return_address(0);
-	INIT_LIST_HEAD(&tr.tr_list_buf);
-	gfs2_log_reserve(sdp, tr.tr_reserved);
-	BUG_ON(current->journal_info);
-	current->journal_info = &tr;
 
 	spin_lock(&sdp->sd_ail_lock);
 	while (!list_empty(head)) {
@@ -76,7 +61,47 @@ static void gfs2_ail_empty_gl(struct gfs2_glock *gl)
 	}
 	gfs2_assert_withdraw(sdp, !atomic_read(&gl->gl_ail_count));
 	spin_unlock(&sdp->sd_ail_lock);
+}
+
+
+static void gfs2_ail_empty_gl(struct gfs2_glock *gl)
+{
+	struct gfs2_sbd *sdp = gl->gl_sbd;
+	struct gfs2_trans tr;
+
+	memset(&tr, 0, sizeof(tr));
+	tr.tr_revokes = atomic_read(&gl->gl_ail_count);
+
+	if (!tr.tr_revokes)
+		return;
+
+	/* A shortened, inline version of gfs2_trans_begin() */
+	tr.tr_reserved = 1 + gfs2_struct2blk(sdp, tr.tr_revokes, sizeof(u64));
+	tr.tr_ip = (unsigned long)__builtin_return_address(0);
+	INIT_LIST_HEAD(&tr.tr_list_buf);
+	gfs2_log_reserve(sdp, tr.tr_reserved);
+	BUG_ON(current->journal_info);
+	current->journal_info = &tr;
+
+	__gfs2_ail_flush(gl);
+
+	gfs2_trans_end(sdp);
+	gfs2_log_flush(sdp, NULL);
+}
 
+void gfs2_ail_flush(struct gfs2_glock *gl)
+{
+	struct gfs2_sbd *sdp = gl->gl_sbd;
+	unsigned int revokes = atomic_read(&gl->gl_ail_count);
+	int ret;
+
+	if (!revokes)
+		return;
+
+	ret = gfs2_trans_begin(sdp, 0, revokes);
+	if (ret)
+		return;
+	__gfs2_ail_flush(gl);
 	gfs2_trans_end(sdp);
 	gfs2_log_flush(sdp, NULL);
 }
diff --git a/fs/gfs2/glops.h b/fs/gfs2/glops.h
index b3aa2e3..6fce409 100644
--- a/fs/gfs2/glops.h
+++ b/fs/gfs2/glops.h
@@ -23,4 +23,6 @@ extern const struct gfs2_glock_operations gfs2_quota_glops;
 extern const struct gfs2_glock_operations gfs2_journal_glops;
 extern const struct gfs2_glock_operations *gfs2_glops_list[];
 
+extern void gfs2_ail_flush(struct gfs2_glock *gl);
+
 #endif /* __GLOPS_DOT_H__ */
-- 
1.7.4

