Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933164Ab2GCOrd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 10:47:33 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50702 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756552Ab2GCOpy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 10:45:54 -0400
From: Jan Kara <jack@suse.cz>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: <linux-fsdevel@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Curt Wohlgemuth <curtw@google.com>,
        Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>
Subject: [PATCH 2/8] quota: Split dquot_quota_sync() to writeback and cache flushing part
Date: Tue,  3 Jul 2012 16:45:28 +0200
Message-Id: <1341326734-29881-3-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1341326734-29881-1-git-send-email-jack@suse.cz>
References: <1341326734-29881-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Split off part of dquot_quota_sync() which writes dquots into a quota file
to a separate function. In the next patch we will use the function from
filesystems and we do not want to abuse ->quota_sync quotactl callback more
than necessary.

Acked-by: Steven Whitehouse <swhiteho@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/gfs2/quota.c          |    4 ++--
 fs/gfs2/quota.h          |    2 +-
 fs/gfs2/super.c          |    2 +-
 fs/gfs2/sys.c            |    2 +-
 fs/quota/dquot.c         |   24 +++++++++++++++++++++---
 fs/quota/quota.c         |    4 ++--
 fs/sync.c                |    2 +-
 include/linux/quota.h    |    2 +-
 include/linux/quotaops.h |    3 ++-
 9 files changed, 32 insertions(+), 13 deletions(-)

diff --git a/fs/gfs2/quota.c b/fs/gfs2/quota.c
index b97178e..27b5cc7 100644
--- a/fs/gfs2/quota.c
+++ b/fs/gfs2/quota.c
@@ -1108,7 +1108,7 @@ void gfs2_quota_change(struct gfs2_inode *ip, s64 change,
 	}
 }
 
-int gfs2_quota_sync(struct super_block *sb, int type, int wait)
+int gfs2_quota_sync(struct super_block *sb, int type)
 {
 	struct gfs2_sbd *sdp = sb->s_fs_info;
 	struct gfs2_quota_data **qda;
@@ -1154,7 +1154,7 @@ int gfs2_quota_sync(struct super_block *sb, int type, int wait)
 
 static int gfs2_quota_sync_timeo(struct super_block *sb, int type)
 {
-	return gfs2_quota_sync(sb, type, 0);
+	return gfs2_quota_sync(sb, type);
 }
 
 int gfs2_quota_refresh(struct gfs2_sbd *sdp, int user, u32 id)
diff --git a/fs/gfs2/quota.h b/fs/gfs2/quota.h
index 90bf1c3..f25d98b 100644
--- a/fs/gfs2/quota.h
+++ b/fs/gfs2/quota.h
@@ -26,7 +26,7 @@ extern int gfs2_quota_check(struct gfs2_inode *ip, u32 uid, u32 gid);
 extern void gfs2_quota_change(struct gfs2_inode *ip, s64 change,
 			      u32 uid, u32 gid);
 
-extern int gfs2_quota_sync(struct super_block *sb, int type, int wait);
+extern int gfs2_quota_sync(struct super_block *sb, int type);
 extern int gfs2_quota_refresh(struct gfs2_sbd *sdp, int user, u32 id);
 
 extern int gfs2_quota_init(struct gfs2_sbd *sdp);
diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index 713e621..313c329 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -838,7 +838,7 @@ static int gfs2_make_fs_ro(struct gfs2_sbd *sdp)
 	int error;
 
 	flush_workqueue(gfs2_delete_workqueue);
-	gfs2_quota_sync(sdp->sd_vfs, 0, 1);
+	gfs2_quota_sync(sdp->sd_vfs, 0);
 	gfs2_statfs_sync(sdp->sd_vfs, 0);
 
 	error = gfs2_glock_nq_init(sdp->sd_trans_gl, LM_ST_SHARED, GL_NOCACHE,
diff --git a/fs/gfs2/sys.c b/fs/gfs2/sys.c
index 9c2592b..73ecc34 100644
--- a/fs/gfs2/sys.c
+++ b/fs/gfs2/sys.c
@@ -168,7 +168,7 @@ static ssize_t quota_sync_store(struct gfs2_sbd *sdp, const char *buf,
 	if (simple_strtol(buf, NULL, 0) != 1)
 		return -EINVAL;
 
-	gfs2_quota_sync(sdp->sd_vfs, 0, 1);
+	gfs2_quota_sync(sdp->sd_vfs, 0);
 	return len;
 }
 
diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index 10cbe84..d679fc4 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -595,12 +595,14 @@ out:
 }
 EXPORT_SYMBOL(dquot_scan_active);
 
-int dquot_quota_sync(struct super_block *sb, int type, int wait)
+/* Write all dquot structures to quota files */
+int dquot_writeback_dquots(struct super_block *sb, int type)
 {
 	struct list_head *dirty;
 	struct dquot *dquot;
 	struct quota_info *dqopt = sb_dqopt(sb);
 	int cnt;
+	int err, ret = 0;
 
 	mutex_lock(&dqopt->dqonoff_mutex);
 	for (cnt = 0; cnt < MAXQUOTAS; cnt++) {
@@ -624,7 +626,9 @@ int dquot_quota_sync(struct super_block *sb, int type, int wait)
 			atomic_inc(&dquot->dq_count);
 			spin_unlock(&dq_list_lock);
 			dqstats_inc(DQST_LOOKUPS);
-			sb->dq_op->write_dquot(dquot);
+			err = sb->dq_op->write_dquot(dquot);
+			if (!ret && err)
+				err = ret;
 			dqput(dquot);
 			spin_lock(&dq_list_lock);
 		}
@@ -638,7 +642,21 @@ int dquot_quota_sync(struct super_block *sb, int type, int wait)
 	dqstats_inc(DQST_SYNCS);
 	mutex_unlock(&dqopt->dqonoff_mutex);
 
-	if (!wait || (dqopt->flags & DQUOT_QUOTA_SYS_FILE))
+	return ret;
+}
+EXPORT_SYMBOL(dquot_writeback_dquots);
+
+/* Write all dquot structures to disk and make them visible from userspace */
+int dquot_quota_sync(struct super_block *sb, int type)
+{
+	struct quota_info *dqopt = sb_dqopt(sb);
+	int cnt;
+	int ret;
+
+	ret = dquot_writeback_dquots(sb, type);
+	if (ret)
+		return ret;
+	if (dqopt->flags & DQUOT_QUOTA_SYS_FILE)
 		return 0;
 
 	/* This is not very clever (and fast) but currently I don't know about
diff --git a/fs/quota/quota.c b/fs/quota/quota.c
index 9a39120..c659f92 100644
--- a/fs/quota/quota.c
+++ b/fs/quota/quota.c
@@ -47,7 +47,7 @@ static int check_quotactl_permission(struct super_block *sb, int type, int cmd,
 static void quota_sync_one(struct super_block *sb, void *arg)
 {
 	if (sb->s_qcop && sb->s_qcop->quota_sync)
-		sb->s_qcop->quota_sync(sb, *(int *)arg, 1);
+		sb->s_qcop->quota_sync(sb, *(int *)arg);
 }
 
 static int quota_sync_all(int type)
@@ -270,7 +270,7 @@ static int do_quotactl(struct super_block *sb, int type, int cmd, qid_t id,
 	case Q_SYNC:
 		if (!sb->s_qcop->quota_sync)
 			return -ENOSYS;
-		return sb->s_qcop->quota_sync(sb, type, 1);
+		return sb->s_qcop->quota_sync(sb, type);
 	case Q_XQUOTAON:
 	case Q_XQUOTAOFF:
 	case Q_XQUOTARM:
diff --git a/fs/sync.c b/fs/sync.c
index b3d2a00..cae145d 100644
--- a/fs/sync.c
+++ b/fs/sync.c
@@ -30,7 +30,7 @@
 static int __sync_filesystem(struct super_block *sb, int wait)
 {
 	if (sb->s_qcop && sb->s_qcop->quota_sync)
-		sb->s_qcop->quota_sync(sb, -1, wait);
+		sb->s_qcop->quota_sync(sb, -1);
 
 	if (wait)
 		sync_inodes_sb(sb);
diff --git a/include/linux/quota.h b/include/linux/quota.h
index c09fa04..524ede8 100644
--- a/include/linux/quota.h
+++ b/include/linux/quota.h
@@ -333,7 +333,7 @@ struct quotactl_ops {
 	int (*quota_on)(struct super_block *, int, int, struct path *);
 	int (*quota_on_meta)(struct super_block *, int, int);
 	int (*quota_off)(struct super_block *, int);
-	int (*quota_sync)(struct super_block *, int, int);
+	int (*quota_sync)(struct super_block *, int);
 	int (*get_info)(struct super_block *, int, struct if_dqinfo *);
 	int (*set_info)(struct super_block *, int, struct if_dqinfo *);
 	int (*get_dqblk)(struct super_block *, int, qid_t, struct fs_disk_quota *);
diff --git a/include/linux/quotaops.h b/include/linux/quotaops.h
index 17b9773..778ba5b 100644
--- a/include/linux/quotaops.h
+++ b/include/linux/quotaops.h
@@ -83,7 +83,8 @@ int dquot_quota_on(struct super_block *sb, int type, int format_id,
 int dquot_quota_on_mount(struct super_block *sb, char *qf_name,
  	int format_id, int type);
 int dquot_quota_off(struct super_block *sb, int type);
-int dquot_quota_sync(struct super_block *sb, int type, int wait);
+int dquot_writeback_dquots(struct super_block *sb, int type);
+int dquot_quota_sync(struct super_block *sb, int type);
 int dquot_get_dqinfo(struct super_block *sb, int type, struct if_dqinfo *ii);
 int dquot_set_dqinfo(struct super_block *sb, int type, struct if_dqinfo *ii);
 int dquot_get_dqblk(struct super_block *sb, int type, qid_t id,
-- 
1.7.1

