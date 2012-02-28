Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965362Ab2B1Lfd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 06:35:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25268 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965302Ab2B1Lfa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 06:35:30 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 4/4] GFS2: Read resource groups on mount
Date: Tue, 28 Feb 2012 11:11:05 +0000
Message-Id: <1330427465-5417-5-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1330427465-5417-1-git-send-email-swhiteho@redhat.com>
References: <1330427465-5417-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This makes mount take slightly longer, but at the same time, the first
write to the filesystem will be faster too. It also means that if there
is a problem in the resource index, then we can refuse to mount rather
than having to try and report that when the first write occurs.

In addition, to avoid recursive locking, we hvae to take account of
instances when the rindex glock may already be held when we are
trying to update the rbtree of resource groups.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
index 7f906c8..c5fb359 100644
--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -772,11 +772,6 @@ static long gfs2_fallocate(struct file *file, int mode, loff_t offset,
 	if (bytes == 0)
 		bytes = sdp->sd_sb.sb_bsize;
 
-	error = gfs2_rindex_update(sdp);
-	if (error) {
-		fs_warn(sdp, "rindex update returns %d\n", error);
-		return error;
-	}
 	gfs2_holder_init(ip->i_gl, LM_ST_EXCLUSIVE, 0, &ip->i_gh);
 	error = gfs2_glock_nq(&ip->i_gh);
 	if (unlikely(error))
diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index c87faf4..5698746 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -391,10 +391,6 @@ static int alloc_dinode(struct gfs2_inode *dip, u64 *no_addr, u64 *generation)
 	int error;
 	int dblocks = 1;
 
-	error = gfs2_rindex_update(sdp);
-	if (error)
-		fs_warn(sdp, "rindex update returns %d\n", error);
-
 	error = gfs2_inplace_reserve(dip, RES_DINODE);
 	if (error)
 		goto out;
@@ -1035,19 +1031,15 @@ static int gfs2_unlink(struct inode *dir, struct dentry *dentry)
 	struct buffer_head *bh;
 	struct gfs2_holder ghs[3];
 	struct gfs2_rgrpd *rgd;
-	int error;
+	int error = -EROFS;
 
-	error = gfs2_rindex_update(sdp);
-	if (error)
-		return error;
 	gfs2_holder_init(dip->i_gl, LM_ST_EXCLUSIVE, 0, ghs);
 	gfs2_holder_init(ip->i_gl,  LM_ST_EXCLUSIVE, 0, ghs + 1);
 
 	rgd = gfs2_blk2rgrpd(sdp, ip->i_no_addr);
-	if (!rgd) {
-		error = -EROFS;
+	if (!rgd)
 		goto out_inodes;
-	}
+
 	gfs2_holder_init(rgd->rd_gl, LM_ST_EXCLUSIVE, 0, ghs + 2);
 
 
diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index 6aacf3f..24f609c 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -800,6 +800,11 @@ static int init_inodes(struct gfs2_sbd *sdp, int undo)
 		fs_err(sdp, "can't get quota file inode: %d\n", error);
 		goto fail_rindex;
 	}
+
+	error = gfs2_rindex_update(sdp);
+	if (error)
+		goto fail_qinode;
+
 	return 0;
 
 fail_qinode:
diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index 981bfa3..49ada95 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -683,16 +683,21 @@ int gfs2_rindex_update(struct gfs2_sbd *sdp)
 	struct gfs2_glock *gl = ip->i_gl;
 	struct gfs2_holder ri_gh;
 	int error = 0;
+	int unlock_required = 0;
 
 	/* Read new copy from disk if we don't have the latest */
 	if (!sdp->sd_rindex_uptodate) {
 		mutex_lock(&sdp->sd_rindex_mutex);
-		error = gfs2_glock_nq_init(gl, LM_ST_SHARED, 0, &ri_gh);
-		if (error)
-			return error;
+		if (!gfs2_glock_is_locked_by_me(gl)) {
+			error = gfs2_glock_nq_init(gl, LM_ST_SHARED, 0, &ri_gh);
+			if (error)
+				return error;
+			unlock_required = 1;
+		}
 		if (!sdp->sd_rindex_uptodate)
 			error = gfs2_ri_update(ip);
-		gfs2_glock_dq_uninit(&ri_gh);
+		if (unlock_required)
+			gfs2_glock_dq_uninit(&ri_gh);
 		mutex_unlock(&sdp->sd_rindex_mutex);
 	}
 
-- 
1.7.4

