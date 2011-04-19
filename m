Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754303Ab1DSJCp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 05:02:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36705 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754261Ab1DSJCk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 05:02:40 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Bob Peterson <rpeterso@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 4/4] GFS2: filesystem hang caused by incorrect lock order
Date: Tue, 19 Apr 2011 09:40:09 +0100
Message-Id: <1303202409-3317-5-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1303202409-3317-1-git-send-email-swhiteho@redhat.com>
References: <1303202409-3317-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

This patch fixes a deadlock in GFS2 where two processes are trying
to reclaim an unlinked dinode:
One holds the inode glock and calls gfs2_lookup_by_inum trying to look
up the inode, which it can't, due to I_FREEING.  The other has set
I_FREEING from vfs and is at the beginning of gfs2_delete_inode
waiting for the glock, which is held by the first.  The solution is to
add a new non_block parameter to the gfs2_iget function that causes it
to return -ENOENT if the inode is being freed.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/dir.c b/fs/gfs2/dir.c
index 5c356d0..f789c57 100644
--- a/fs/gfs2/dir.c
+++ b/fs/gfs2/dir.c
@@ -1506,7 +1506,7 @@ struct inode *gfs2_dir_search(struct inode *dir, const struct qstr *name)
 		inode = gfs2_inode_lookup(dir->i_sb, 
 				be16_to_cpu(dent->de_type),
 				be64_to_cpu(dent->de_inum.no_addr),
-				be64_to_cpu(dent->de_inum.no_formal_ino));
+				be64_to_cpu(dent->de_inum.no_formal_ino), 0);
 		brelse(bh);
 		return inode;
 	}
diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index 97d54a2..9134dcb 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -40,37 +40,61 @@ struct gfs2_inum_range_host {
 	u64 ir_length;
 };
 
+struct gfs2_skip_data {
+	u64 no_addr;
+	int skipped;
+	int non_block;
+};
+
 static int iget_test(struct inode *inode, void *opaque)
 {
 	struct gfs2_inode *ip = GFS2_I(inode);
-	u64 *no_addr = opaque;
+	struct gfs2_skip_data *data = opaque;
 
-	if (ip->i_no_addr == *no_addr)
+	if (ip->i_no_addr == data->no_addr) {
+		if (data->non_block &&
+		    inode->i_state & (I_FREEING|I_CLEAR|I_WILL_FREE)) {
+			data->skipped = 1;
+			return 0;
+		}
 		return 1;
-
+	}
 	return 0;
 }
 
 static int iget_set(struct inode *inode, void *opaque)
 {
 	struct gfs2_inode *ip = GFS2_I(inode);
-	u64 *no_addr = opaque;
+	struct gfs2_skip_data *data = opaque;
 
-	inode->i_ino = (unsigned long)*no_addr;
-	ip->i_no_addr = *no_addr;
+	if (data->skipped)
+		return -ENOENT;
+	inode->i_ino = (unsigned long)(data->no_addr);
+	ip->i_no_addr = data->no_addr;
 	return 0;
 }
 
 struct inode *gfs2_ilookup(struct super_block *sb, u64 no_addr)
 {
 	unsigned long hash = (unsigned long)no_addr;
-	return ilookup5(sb, hash, iget_test, &no_addr);
+	struct gfs2_skip_data data;
+
+	data.no_addr = no_addr;
+	data.skipped = 0;
+	data.non_block = 0;
+	return ilookup5(sb, hash, iget_test, &data);
 }
 
-static struct inode *gfs2_iget(struct super_block *sb, u64 no_addr)
+static struct inode *gfs2_iget(struct super_block *sb, u64 no_addr,
+			       int non_block)
 {
+	struct gfs2_skip_data data;
 	unsigned long hash = (unsigned long)no_addr;
-	return iget5_locked(sb, hash, iget_test, iget_set, &no_addr);
+
+	data.no_addr = no_addr;
+	data.skipped = 0;
+	data.non_block = non_block;
+	return iget5_locked(sb, hash, iget_test, iget_set, &data);
 }
 
 /**
@@ -111,19 +135,20 @@ static void gfs2_set_iop(struct inode *inode)
  * @sb: The super block
  * @no_addr: The inode number
  * @type: The type of the inode
+ * non_block: Can we block on inodes that are being freed?
  *
  * Returns: A VFS inode, or an error
  */
 
 struct inode *gfs2_inode_lookup(struct super_block *sb, unsigned int type,
-				u64 no_addr, u64 no_formal_ino)
+				u64 no_addr, u64 no_formal_ino, int non_block)
 {
 	struct inode *inode;
 	struct gfs2_inode *ip;
 	struct gfs2_glock *io_gl = NULL;
 	int error;
 
-	inode = gfs2_iget(sb, no_addr);
+	inode = gfs2_iget(sb, no_addr, non_block);
 	ip = GFS2_I(inode);
 
 	if (!inode)
@@ -185,11 +210,12 @@ struct inode *gfs2_lookup_by_inum(struct gfs2_sbd *sdp, u64 no_addr,
 {
 	struct super_block *sb = sdp->sd_vfs;
 	struct gfs2_holder i_gh;
-	struct inode *inode;
+	struct inode *inode = NULL;
 	int error;
 
+	/* Must not read in block until block type is verified */
 	error = gfs2_glock_nq_num(sdp, no_addr, &gfs2_inode_glops,
-				  LM_ST_SHARED, LM_FLAG_ANY, &i_gh);
+				  LM_ST_EXCLUSIVE, GL_SKIP, &i_gh);
 	if (error)
 		return ERR_PTR(error);
 
@@ -197,7 +223,7 @@ struct inode *gfs2_lookup_by_inum(struct gfs2_sbd *sdp, u64 no_addr,
 	if (error)
 		goto fail;
 
-	inode = gfs2_inode_lookup(sb, DT_UNKNOWN, no_addr, 0);
+	inode = gfs2_inode_lookup(sb, DT_UNKNOWN, no_addr, 0, 1);
 	if (IS_ERR(inode))
 		goto fail;
 
@@ -843,7 +869,7 @@ struct inode *gfs2_createi(struct gfs2_holder *ghs, const struct qstr *name,
 		goto fail_gunlock2;
 
 	inode = gfs2_inode_lookup(dir->i_sb, IF2DT(mode), inum.no_addr,
-				  inum.no_formal_ino);
+				  inum.no_formal_ino, 0);
 	if (IS_ERR(inode))
 		goto fail_gunlock2;
 
diff --git a/fs/gfs2/inode.h b/fs/gfs2/inode.h
index 3e00a66..099ca30 100644
--- a/fs/gfs2/inode.h
+++ b/fs/gfs2/inode.h
@@ -97,7 +97,8 @@ err:
 }
 
 extern struct inode *gfs2_inode_lookup(struct super_block *sb, unsigned type, 
-				       u64 no_addr, u64 no_formal_ino);
+				       u64 no_addr, u64 no_formal_ino,
+				       int non_block);
 extern struct inode *gfs2_lookup_by_inum(struct gfs2_sbd *sdp, u64 no_addr,
 					 u64 *no_formal_ino,
 					 unsigned int blktype);
diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index 42ef243..d3c69eb 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -430,7 +430,7 @@ static int gfs2_lookup_root(struct super_block *sb, struct dentry **dptr,
 	struct dentry *dentry;
 	struct inode *inode;
 
-	inode = gfs2_inode_lookup(sb, DT_DIR, no_addr, 0);
+	inode = gfs2_inode_lookup(sb, DT_DIR, no_addr, 0, 0);
 	if (IS_ERR(inode)) {
 		fs_err(sdp, "can't read in %s inode: %ld\n", name, PTR_ERR(inode));
 		return PTR_ERR(inode);
diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index cf930cd..6fcae84 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -945,7 +945,7 @@ static void try_rgrp_unlink(struct gfs2_rgrpd *rgd, u64 *last_unlinked, u64 skip
 		/* rgblk_search can return a block < goal, so we need to
 		   keep it marching forward. */
 		no_addr = block + rgd->rd_data0;
-		goal++;
+		goal = max(block + 1, goal + 1);
 		if (*last_unlinked != NO_BLOCK && no_addr <= *last_unlinked)
 			continue;
 		if (no_addr == skip)
@@ -971,7 +971,7 @@ static void try_rgrp_unlink(struct gfs2_rgrpd *rgd, u64 *last_unlinked, u64 skip
 			found++;
 
 		/* Limit reclaim to sensible number of tasks */
-		if (found > 2*NR_CPUS)
+		if (found > NR_CPUS)
 			return;
 	}
 
diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index 5b2cb81..b9f28e6 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -1327,7 +1327,8 @@ static void gfs2_evict_inode(struct inode *inode)
 	if (inode->i_nlink || (sb->s_flags & MS_RDONLY))
 		goto out;
 
-	error = gfs2_glock_nq_init(ip->i_gl, LM_ST_EXCLUSIVE, 0, &gh);
+	/* Must not read inode block until block type has been verified */
+	error = gfs2_glock_nq_init(ip->i_gl, LM_ST_EXCLUSIVE, GL_SKIP, &gh);
 	if (unlikely(error)) {
 		gfs2_glock_dq_uninit(&ip->i_iopen_gh);
 		goto out;
@@ -1337,6 +1338,12 @@ static void gfs2_evict_inode(struct inode *inode)
 	if (error)
 		goto out_truncate;
 
+	if (test_bit(GIF_INVALID, &ip->i_flags)) {
+		error = gfs2_inode_refresh(ip);
+		if (error)
+			goto out_truncate;
+	}
+
 	ip->i_iopen_gh.gh_flags |= GL_NOCACHE;
 	gfs2_glock_dq_wait(&ip->i_iopen_gh);
 	gfs2_holder_reinit(LM_ST_EXCLUSIVE, LM_FLAG_TRY_1CB | GL_NOCACHE, &ip->i_iopen_gh);
-- 
1.7.4

