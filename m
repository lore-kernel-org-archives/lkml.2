Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755389Ab0EQM6Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 08:58:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33837 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755303Ab0EQM6G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 08:58:06 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Bob Peterson <rpeterso@redhat.com>
Subject: [PATCH 04/11] GFS2: glock livelock
Date: Mon, 17 May 2010 13:40:18 +0100
Message-Id: <1274100025-26629-5-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1274100025-26629-4-git-send-email-swhiteho@redhat.com>
References: <1274100025-26629-1-git-send-email-swhiteho@redhat.com>
 <1274100025-26629-2-git-send-email-swhiteho@redhat.com>
 <1274100025-26629-3-git-send-email-swhiteho@redhat.com>
 <1274100025-26629-4-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

This patch fixes a couple gfs2 problems with the reclaiming of
unlinked dinodes.  First, there were a couple of livelocks where
everything would come to a halt waiting for a glock that was
seemingly held by a process that no longer existed.  In fact, the
process did exist, it just had the wrong pid number in the holder
information.  Second, there was a lock ordering problem between
inode locking and glock locking.  Third, glock/inode contention
could sometimes cause inodes to be improperly marked invalid by
iget_failed.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
---
 fs/gfs2/dir.c        |    2 +-
 fs/gfs2/export.c     |    2 +-
 fs/gfs2/glock.c      |    3 +
 fs/gfs2/inode.c      |  101 +++++++++++++++++++++++++++++++++++++++++++++----
 fs/gfs2/inode.h      |    5 +-
 fs/gfs2/ops_fstype.c |    2 +-
 fs/gfs2/rgrp.c       |   58 +++++++++++++++++++++-------
 7 files changed, 144 insertions(+), 29 deletions(-)

diff --git a/fs/gfs2/dir.c b/fs/gfs2/dir.c
index 25fddc1..8295c5b 100644
--- a/fs/gfs2/dir.c
+++ b/fs/gfs2/dir.c
@@ -1475,7 +1475,7 @@ struct inode *gfs2_dir_search(struct inode *dir, const struct qstr *name)
 		inode = gfs2_inode_lookup(dir->i_sb, 
 				be16_to_cpu(dent->de_type),
 				be64_to_cpu(dent->de_inum.no_addr),
-				be64_to_cpu(dent->de_inum.no_formal_ino), 0);
+				be64_to_cpu(dent->de_inum.no_formal_ino));
 		brelse(bh);
 		return inode;
 	}
diff --git a/fs/gfs2/export.c b/fs/gfs2/export.c
index d15876e..d81bc7e 100644
--- a/fs/gfs2/export.c
+++ b/fs/gfs2/export.c
@@ -169,7 +169,7 @@ static struct dentry *gfs2_get_dentry(struct super_block *sb,
 	if (error)
 		goto fail;
 
-	inode = gfs2_inode_lookup(sb, DT_UNKNOWN, inum->no_addr, 0, 0);
+	inode = gfs2_inode_lookup(sb, DT_UNKNOWN, inum->no_addr, 0);
 	if (IS_ERR(inode)) {
 		error = PTR_ERR(inode);
 		goto fail;
diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index 454d4b4..ddcdbf4 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -855,6 +855,9 @@ void gfs2_holder_reinit(unsigned int state, unsigned flags, struct gfs2_holder *
 	gh->gh_flags = flags;
 	gh->gh_iflags = 0;
 	gh->gh_ip = (unsigned long)__builtin_return_address(0);
+	if (gh->gh_owner_pid)
+		put_pid(gh->gh_owner_pid);
+	gh->gh_owner_pid = get_pid(task_pid(current));
 }
 
 /**
diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index b1bf269..51d8061 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -158,7 +158,6 @@ void gfs2_set_iop(struct inode *inode)
  * @sb: The super block
  * @no_addr: The inode number
  * @type: The type of the inode
- * @skip_freeing: set this not return an inode if it is currently being freed.
  *
  * Returns: A VFS inode, or an error
  */
@@ -166,17 +165,14 @@ void gfs2_set_iop(struct inode *inode)
 struct inode *gfs2_inode_lookup(struct super_block *sb,
 				unsigned int type,
 				u64 no_addr,
-				u64 no_formal_ino, int skip_freeing)
+				u64 no_formal_ino)
 {
 	struct inode *inode;
 	struct gfs2_inode *ip;
 	struct gfs2_glock *io_gl;
 	int error;
 
-	if (skip_freeing)
-		inode = gfs2_iget_skip(sb, no_addr);
-	else
-		inode = gfs2_iget(sb, no_addr);
+	inode = gfs2_iget(sb, no_addr);
 	ip = GFS2_I(inode);
 
 	if (!inode)
@@ -234,13 +230,100 @@ fail_glock:
 fail_iopen:
 	gfs2_glock_put(io_gl);
 fail_put:
-	ip->i_gl->gl_object = NULL;
+	if (inode->i_state & I_NEW)
+		ip->i_gl->gl_object = NULL;
 	gfs2_glock_put(ip->i_gl);
 fail:
-	iget_failed(inode);
+	if (inode->i_state & I_NEW)
+		iget_failed(inode);
+	else
+		iput(inode);
 	return ERR_PTR(error);
 }
 
+/**
+ * gfs2_unlinked_inode_lookup - Lookup an unlinked inode for reclamation
+ * @sb: The super block
+ * no_addr: The inode number
+ * @@inode: A pointer to the inode found, if any
+ *
+ * Returns: 0 and *inode if no errors occurred.  If an error occurs,
+ *          the resulting *inode may or may not be NULL.
+ */
+
+int gfs2_unlinked_inode_lookup(struct super_block *sb, u64 no_addr,
+			       struct inode **inode)
+{
+	struct gfs2_sbd *sdp;
+	struct gfs2_inode *ip;
+	struct gfs2_glock *io_gl;
+	int error;
+	struct gfs2_holder gh;
+
+	*inode = gfs2_iget_skip(sb, no_addr);
+
+	if (!(*inode))
+		return -ENOBUFS;
+
+	if (!((*inode)->i_state & I_NEW))
+		return -ENOBUFS;
+
+	ip = GFS2_I(*inode);
+	sdp = GFS2_SB(*inode);
+	ip->i_no_formal_ino = -1;
+
+	error = gfs2_glock_get(sdp, no_addr, &gfs2_inode_glops, CREATE, &ip->i_gl);
+	if (unlikely(error))
+		goto fail;
+	ip->i_gl->gl_object = ip;
+
+	error = gfs2_glock_get(sdp, no_addr, &gfs2_iopen_glops, CREATE, &io_gl);
+	if (unlikely(error))
+		goto fail_put;
+
+	set_bit(GIF_INVALID, &ip->i_flags);
+	error = gfs2_glock_nq_init(io_gl, LM_ST_SHARED, LM_FLAG_TRY | GL_EXACT,
+				   &ip->i_iopen_gh);
+	if (unlikely(error)) {
+		if (error == GLR_TRYFAILED)
+			error = 0;
+		goto fail_iopen;
+	}
+	ip->i_iopen_gh.gh_gl->gl_object = ip;
+	gfs2_glock_put(io_gl);
+
+	(*inode)->i_mode = DT2IF(DT_UNKNOWN);
+
+	/*
+	 * We must read the inode in order to work out its type in
+	 * this case. Note that this doesn't happen often as we normally
+	 * know the type beforehand. This code path only occurs during
+	 * unlinked inode recovery (where it is safe to do this glock,
+	 * which is not true in the general case).
+	 */
+	error = gfs2_glock_nq_init(ip->i_gl, LM_ST_EXCLUSIVE, LM_FLAG_TRY,
+				   &gh);
+	if (unlikely(error)) {
+		if (error == GLR_TRYFAILED)
+			error = 0;
+		goto fail_glock;
+	}
+	/* Inode is now uptodate */
+	gfs2_glock_dq_uninit(&gh);
+	gfs2_set_iop(*inode);
+
+	return 0;
+fail_glock:
+	gfs2_glock_dq(&ip->i_iopen_gh);
+fail_iopen:
+	gfs2_glock_put(io_gl);
+fail_put:
+	ip->i_gl->gl_object = NULL;
+	gfs2_glock_put(ip->i_gl);
+fail:
+	return error;
+}
+
 static int gfs2_dinode_in(struct gfs2_inode *ip, const void *buf)
 {
 	const struct gfs2_dinode *str = buf;
@@ -862,7 +945,7 @@ struct inode *gfs2_createi(struct gfs2_holder *ghs, const struct qstr *name,
 		goto fail_gunlock2;
 
 	inode = gfs2_inode_lookup(dir->i_sb, IF2DT(mode), inum.no_addr,
-				  inum.no_formal_ino, 0);
+				  inum.no_formal_ino);
 	if (IS_ERR(inode))
 		goto fail_gunlock2;
 
diff --git a/fs/gfs2/inode.h b/fs/gfs2/inode.h
index c341aaf..e161461 100644
--- a/fs/gfs2/inode.h
+++ b/fs/gfs2/inode.h
@@ -83,8 +83,9 @@ static inline void gfs2_inum_out(const struct gfs2_inode *ip,
 
 extern void gfs2_set_iop(struct inode *inode);
 extern struct inode *gfs2_inode_lookup(struct super_block *sb, unsigned type, 
-				       u64 no_addr, u64 no_formal_ino,
-				       int skip_freeing);
+				       u64 no_addr, u64 no_formal_ino);
+extern int gfs2_unlinked_inode_lookup(struct super_block *sb, u64 no_addr,
+				      struct inode **inode);
 extern struct inode *gfs2_ilookup(struct super_block *sb, u64 no_addr);
 
 extern int gfs2_inode_refresh(struct gfs2_inode *ip);
diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index c1309ed..dc35f34 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -487,7 +487,7 @@ static int gfs2_lookup_root(struct super_block *sb, struct dentry **dptr,
 	struct dentry *dentry;
 	struct inode *inode;
 
-	inode = gfs2_inode_lookup(sb, DT_DIR, no_addr, 0, 0);
+	inode = gfs2_inode_lookup(sb, DT_DIR, no_addr, 0);
 	if (IS_ERR(inode)) {
 		fs_err(sdp, "can't read in %s inode: %ld\n", name, PTR_ERR(inode));
 		return PTR_ERR(inode);
diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index 503b842..3739155 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -948,18 +948,20 @@ static int try_rgrp_fit(struct gfs2_rgrpd *rgd, struct gfs2_alloc *al)
  * try_rgrp_unlink - Look for any unlinked, allocated, but unused inodes
  * @rgd: The rgrp
  *
- * Returns: The inode, if one has been found
+ * Returns: 0 if no error
+ *          The inode, if one has been found, in inode.
  */
 
-static struct inode *try_rgrp_unlink(struct gfs2_rgrpd *rgd, u64 *last_unlinked,
-				     u64 skip)
+static int try_rgrp_unlink(struct gfs2_rgrpd *rgd, u64 *last_unlinked,
+			   u64 skip, struct inode **inode)
 {
-	struct inode *inode;
 	u32 goal = 0, block;
 	u64 no_addr;
 	struct gfs2_sbd *sdp = rgd->rd_sbd;
 	unsigned int n;
+	int error = 0;
 
+	*inode = NULL;
 	for(;;) {
 		if (goal >= rgd->rd_data)
 			break;
@@ -979,14 +981,14 @@ static struct inode *try_rgrp_unlink(struct gfs2_rgrpd *rgd, u64 *last_unlinked,
 		if (no_addr == skip)
 			continue;
 		*last_unlinked = no_addr;
-		inode = gfs2_inode_lookup(rgd->rd_sbd->sd_vfs, DT_UNKNOWN,
-					  no_addr, -1, 1);
-		if (!IS_ERR(inode))
-			return inode;
+		error = gfs2_unlinked_inode_lookup(rgd->rd_sbd->sd_vfs,
+						   no_addr, inode);
+		if (*inode || error)
+			return error;
 	}
 
 	rgd->rd_flags &= ~GFS2_RDF_CHECK;
-	return NULL;
+	return 0;
 }
 
 /**
@@ -1096,12 +1098,27 @@ static struct inode *get_local_rgrp(struct gfs2_inode *ip, u64 *last_unlinked)
 		case 0:
 			if (try_rgrp_fit(rgd, al))
 				goto out;
-			if (rgd->rd_flags & GFS2_RDF_CHECK)
-				inode = try_rgrp_unlink(rgd, last_unlinked, ip->i_no_addr);
+			/* If the rg came in already locked, there's no
+			   way we can recover from a failed try_rgrp_unlink
+			   because that would require an iput which can only
+			   happen after the rgrp is unlocked. */
+			if (!rg_locked && rgd->rd_flags & GFS2_RDF_CHECK)
+				error = try_rgrp_unlink(rgd, last_unlinked,
+							ip->i_no_addr, &inode);
 			if (!rg_locked)
 				gfs2_glock_dq_uninit(&al->al_rgd_gh);
-			if (inode)
+			if (inode) {
+				if (error) {
+					if (inode->i_state & I_NEW)
+						iget_failed(inode);
+					else
+						iput(inode);
+					return ERR_PTR(error);
+				}
 				return inode;
+			}
+			if (error)
+				return ERR_PTR(error);
 			/* fall through */
 		case GLR_TRYFAILED:
 			rgd = recent_rgrp_next(rgd);
@@ -1130,12 +1147,23 @@ static struct inode *get_local_rgrp(struct gfs2_inode *ip, u64 *last_unlinked)
 		case 0:
 			if (try_rgrp_fit(rgd, al))
 				goto out;
-			if (rgd->rd_flags & GFS2_RDF_CHECK)
-				inode = try_rgrp_unlink(rgd, last_unlinked, ip->i_no_addr);
+			if (!rg_locked && rgd->rd_flags & GFS2_RDF_CHECK)
+				error = try_rgrp_unlink(rgd, last_unlinked,
+							ip->i_no_addr, &inode);
 			if (!rg_locked)
 				gfs2_glock_dq_uninit(&al->al_rgd_gh);
-			if (inode)
+			if (inode) {
+				if (error) {
+					if (inode->i_state & I_NEW)
+						iget_failed(inode);
+					else
+						iput(inode);
+					return ERR_PTR(error);
+				}
 				return inode;
+			}
+			if (error)
+				return ERR_PTR(error);
 			break;
 
 		case GLR_TRYFAILED:
-- 
1.6.2.5

