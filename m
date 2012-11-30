Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757157Ab2K3KS1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 05:18:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32314 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757137Ab2K3KSX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 05:18:23 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 05/16] GFS2: Use proper allocation context for new inodes
Date: Fri, 30 Nov 2012 09:52:10 +0000
Message-Id: <1354269141-3311-6-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1354269141-3311-1-git-send-email-swhiteho@redhat.com>
References: <1354269141-3311-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rather than using the parent directory's allocation context, this
patch allocated the new inode earlier in the process and then uses
it to contain all the information required. As a result, we can now
use the new inode's own allocation context to allocate it rather
than having to use the parent directory's context. This give us a
lot more flexibility in where the inode is placed on disk.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index 381893c..749b05a 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -364,34 +364,34 @@ static int create_ok(struct gfs2_inode *dip, const struct qstr *name,
 	return 0;
 }
 
-static void munge_mode_uid_gid(struct gfs2_inode *dip, umode_t *mode,
-			       unsigned int *uid, unsigned int *gid)
+static void munge_mode_uid_gid(const struct gfs2_inode *dip,
+			       struct inode *inode)
 {
 	if (GFS2_SB(&dip->i_inode)->sd_args.ar_suiddir &&
 	    (dip->i_inode.i_mode & S_ISUID) && dip->i_inode.i_uid) {
-		if (S_ISDIR(*mode))
-			*mode |= S_ISUID;
+		if (S_ISDIR(inode->i_mode))
+			inode->i_mode |= S_ISUID;
 		else if (dip->i_inode.i_uid != current_fsuid())
-			*mode &= ~07111;
-		*uid = dip->i_inode.i_uid;
+			inode->i_mode &= ~07111;
+		inode->i_uid = dip->i_inode.i_uid;
 	} else
-		*uid = current_fsuid();
+		inode->i_uid = current_fsuid();
 
 	if (dip->i_inode.i_mode & S_ISGID) {
-		if (S_ISDIR(*mode))
-			*mode |= S_ISGID;
-		*gid = dip->i_inode.i_gid;
+		if (S_ISDIR(inode->i_mode))
+			inode->i_mode |= S_ISGID;
+		inode->i_gid = dip->i_inode.i_gid;
 	} else
-		*gid = current_fsgid();
+		inode->i_gid = current_fsgid();
 }
 
-static int alloc_dinode(struct gfs2_inode *dip, u64 *no_addr, u64 *generation)
+static int alloc_dinode(struct gfs2_inode *ip)
 {
-	struct gfs2_sbd *sdp = GFS2_SB(&dip->i_inode);
+	struct gfs2_sbd *sdp = GFS2_SB(&ip->i_inode);
 	int error;
 	int dblocks = 1;
 
-	error = gfs2_inplace_reserve(dip, RES_DINODE);
+	error = gfs2_inplace_reserve(ip, RES_DINODE);
 	if (error)
 		goto out;
 
@@ -399,12 +399,15 @@ static int alloc_dinode(struct gfs2_inode *dip, u64 *no_addr, u64 *generation)
 	if (error)
 		goto out_ipreserv;
 
-	error = gfs2_alloc_blocks(dip, no_addr, &dblocks, 1, generation);
+	error = gfs2_alloc_blocks(ip, &ip->i_no_addr, &dblocks, 1, &ip->i_generation);
+	ip->i_no_formal_ino = ip->i_generation;
+	ip->i_inode.i_ino = ip->i_no_addr;
+	ip->i_goal = ip->i_no_addr;
 
 	gfs2_trans_end(sdp);
 
 out_ipreserv:
-	gfs2_inplace_release(dip);
+	gfs2_inplace_release(ip);
 out:
 	return error;
 }
@@ -429,52 +432,42 @@ static void gfs2_init_dir(struct buffer_head *dibh,
 /**
  * init_dinode - Fill in a new dinode structure
  * @dip: The directory this inode is being created in
- * @gl: The glock covering the new inode
- * @inum: The inode number
- * @mode: The file permissions
- * @uid: The uid of the new inode
- * @gid: The gid of the new inode
- * @generation: The generation number of the new inode
- * @dev: The device number (if a device node)
+ * @ip: The inode
  * @symname: The symlink destination (if a symlink)
- * @size: The inode size (ignored for directories)
  * @bhp: The buffer head (returned to caller)
  *
  */
 
-static void init_dinode(struct gfs2_inode *dip, struct gfs2_glock *gl,
-			const struct gfs2_inum_host *inum, umode_t mode,
-			unsigned int uid, unsigned int gid,
-			const u64 *generation, dev_t dev, const char *symname,
-			unsigned size, struct buffer_head **bhp)
+static void init_dinode(struct gfs2_inode *dip, struct gfs2_inode *ip,
+			const char *symname, struct buffer_head **bhp)
 {
 	struct gfs2_sbd *sdp = GFS2_SB(&dip->i_inode);
 	struct gfs2_dinode *di;
 	struct buffer_head *dibh;
 	struct timespec tv = CURRENT_TIME;
 
-	dibh = gfs2_meta_new(gl, inum->no_addr);
-	gfs2_trans_add_bh(gl, dibh, 1);
+	dibh = gfs2_meta_new(ip->i_gl, ip->i_no_addr);
+	gfs2_trans_add_bh(ip->i_gl, dibh, 1);
 	gfs2_metatype_set(dibh, GFS2_METATYPE_DI, GFS2_FORMAT_DI);
 	gfs2_buffer_clear_tail(dibh, sizeof(struct gfs2_dinode));
 	di = (struct gfs2_dinode *)dibh->b_data;
 
-	di->di_num.no_formal_ino = cpu_to_be64(inum->no_formal_ino);
-	di->di_num.no_addr = cpu_to_be64(inum->no_addr);
-	di->di_mode = cpu_to_be32(mode);
-	di->di_uid = cpu_to_be32(uid);
-	di->di_gid = cpu_to_be32(gid);
+	di->di_num.no_formal_ino = cpu_to_be64(ip->i_no_formal_ino);
+	di->di_num.no_addr = cpu_to_be64(ip->i_no_addr);
+	di->di_mode = cpu_to_be32(ip->i_inode.i_mode);
+	di->di_uid = cpu_to_be32(ip->i_inode.i_uid);
+	di->di_gid = cpu_to_be32(ip->i_inode.i_gid);
 	di->di_nlink = 0;
-	di->di_size = cpu_to_be64(size);
+	di->di_size = cpu_to_be64(ip->i_inode.i_size);
 	di->di_blocks = cpu_to_be64(1);
 	di->di_atime = di->di_mtime = di->di_ctime = cpu_to_be64(tv.tv_sec);
-	di->di_major = cpu_to_be32(MAJOR(dev));
-	di->di_minor = cpu_to_be32(MINOR(dev));
-	di->di_goal_meta = di->di_goal_data = cpu_to_be64(inum->no_addr);
-	di->di_generation = cpu_to_be64(*generation);
+	di->di_major = cpu_to_be32(MAJOR(ip->i_inode.i_rdev));
+	di->di_minor = cpu_to_be32(MINOR(ip->i_inode.i_rdev));
+	di->di_goal_meta = di->di_goal_data = cpu_to_be64(ip->i_no_addr);
+	di->di_generation = cpu_to_be64(ip->i_generation);
 	di->di_flags = 0;
 	di->__pad1 = 0;
-	di->di_payload_format = cpu_to_be32(S_ISDIR(mode) ? GFS2_FORMAT_DE : 0);
+	di->di_payload_format = cpu_to_be32(S_ISDIR(ip->i_inode.i_mode) ? GFS2_FORMAT_DE : 0);
 	di->di_height = 0;
 	di->__pad2 = 0;
 	di->__pad3 = 0;
@@ -487,7 +480,7 @@ static void init_dinode(struct gfs2_inode *dip, struct gfs2_glock *gl,
 	di->di_ctime_nsec = cpu_to_be32(tv.tv_nsec);
 	memset(&di->di_reserved, 0, sizeof(di->di_reserved));
 
-	switch(mode & S_IFMT) {	
+	switch(ip->i_inode.i_mode & S_IFMT) {
 	case S_IFREG:
 		if ((dip->i_diskflags & GFS2_DIF_INHERIT_JDATA) ||
 		    gfs2_tune_get(sdp, gt_new_files_jdata))
@@ -502,7 +495,7 @@ static void init_dinode(struct gfs2_inode *dip, struct gfs2_glock *gl,
 		gfs2_init_dir(dibh, dip);
 		break;
 	case S_IFLNK:
-		memcpy(dibh->b_data + sizeof(struct gfs2_dinode), symname, size);
+		memcpy(dibh->b_data + sizeof(struct gfs2_dinode), symname, ip->i_inode.i_size);
 		break;
 	}
 
@@ -511,25 +504,22 @@ static void init_dinode(struct gfs2_inode *dip, struct gfs2_glock *gl,
 	*bhp = dibh;
 }
 
-static int make_dinode(struct gfs2_inode *dip, struct gfs2_glock *gl,
-		       umode_t mode, const struct gfs2_inum_host *inum,
-		       const u64 *generation, dev_t dev, const char *symname,
-		       unsigned int size, struct buffer_head **bhp)
+static int make_dinode(struct gfs2_inode *dip, struct gfs2_inode *ip,
+		       const char *symname, struct buffer_head **bhp)
 {
+	struct inode *inode = &ip->i_inode;
 	struct gfs2_sbd *sdp = GFS2_SB(&dip->i_inode);
-	unsigned int uid, gid;
 	int error;
 
-	munge_mode_uid_gid(dip, &mode, &uid, &gid);
 	error = gfs2_rindex_update(sdp);
 	if (error)
 		return error;
 
-	error = gfs2_quota_lock(dip, uid, gid);
+	error = gfs2_quota_lock(dip, inode->i_uid, inode->i_gid);
 	if (error)
 		return error;
 
-	error = gfs2_quota_check(dip, uid, gid);
+	error = gfs2_quota_check(dip, inode->i_uid, inode->i_gid);
 	if (error)
 		goto out_quota;
 
@@ -537,8 +527,8 @@ static int make_dinode(struct gfs2_inode *dip, struct gfs2_glock *gl,
 	if (error)
 		goto out_quota;
 
-	init_dinode(dip, gl, inum, mode, uid, gid, generation, dev, symname, size, bhp);
-	gfs2_quota_change(dip, +1, uid, gid);
+	init_dinode(dip, ip, symname, bhp);
+	gfs2_quota_change(dip, +1, inode->i_uid, inode->i_gid);
 	gfs2_trans_end(sdp);
 
 out_quota:
@@ -657,19 +647,13 @@ static int gfs2_create_inode(struct inode *dir, struct dentry *dentry,
 	struct inode *inode = NULL;
 	struct gfs2_inode *dip = GFS2_I(dir), *ip;
 	struct gfs2_sbd *sdp = GFS2_SB(&dip->i_inode);
-	struct gfs2_inum_host inum = { .no_addr = 0, .no_formal_ino = 0 };
+	struct gfs2_glock *io_gl;
 	int error;
-	u64 generation;
 	struct buffer_head *bh = NULL;
 
 	if (!name->len || name->len > GFS2_FNAMESIZE)
 		return -ENAMETOOLONG;
 
-	/* We need a reservation to allocate the new dinode block. The
-	   directory ip temporarily points to the reservation, but this is
-	   being done to get a set of contiguous blocks for the new dinode.
-	   Since this is a create, we don't have a sizehint yet, so it will
-	   have to use the minimum reservation size. */
 	error = gfs2_rs_alloc(dip);
 	if (error)
 		return error;
@@ -688,45 +672,63 @@ static int gfs2_create_inode(struct inode *dir, struct dentry *dentry,
 	if (error)
 		goto fail_gunlock;
 
-	error = alloc_dinode(dip, &inum.no_addr, &generation);
+	inode = new_inode(sdp->sd_vfs);
+	ip = GFS2_I(inode);
+	error = gfs2_rs_alloc(ip);
 	if (error)
-		goto fail_gunlock;
-	inum.no_formal_ino = generation;
+		goto fail_free_inode;
+
+	set_bit(GIF_INVALID, &ip->i_flags);
+	inode->i_mode = mode;
+	inode->i_rdev = dev;
+	inode->i_size = size;
+	munge_mode_uid_gid(dip, inode);
+	ip->i_goal = dip->i_goal;
 
-	error = gfs2_glock_nq_num(sdp, inum.no_addr, &gfs2_inode_glops,
-				  LM_ST_EXCLUSIVE, GL_SKIP, ghs + 1);
+	error = alloc_dinode(ip);
 	if (error)
-		goto fail_gunlock;
+		goto fail_free_inode;
 
-	error = make_dinode(dip, ghs[1].gh_gl, mode, &inum, &generation, dev, symname, size, &bh);
+	error = gfs2_glock_get(sdp, ip->i_no_addr, &gfs2_inode_glops, CREATE, &ip->i_gl);
 	if (error)
-		goto fail_gunlock2;
+		goto fail_free_inode;
 
-	inode = gfs2_inode_lookup(dir->i_sb, IF2DT(mode), inum.no_addr,
-				  inum.no_formal_ino, 0);
-	if (IS_ERR(inode))
+	error = gfs2_glock_nq_init(ip->i_gl, LM_ST_EXCLUSIVE, GL_SKIP, ghs + 1);
+	if (error)
+		goto fail_free_inode;
+
+	error = make_dinode(dip, ip, symname, &bh);
+	if (error)
 		goto fail_gunlock2;
 
-	ip = GFS2_I(inode);
-	error = gfs2_inode_refresh(ip);
+	error = gfs2_glock_get(sdp, ip->i_no_addr, &gfs2_iopen_glops, CREATE, &io_gl);
 	if (error)
 		goto fail_gunlock2;
 
-	error = gfs2_rs_alloc(ip);
+	error = gfs2_glock_nq_init(io_gl, LM_ST_SHARED, GL_EXACT, &ip->i_iopen_gh);
 	if (error)
 		goto fail_gunlock2;
 
+	ip->i_iopen_gh.gh_gl->gl_object = ip;
+	gfs2_glock_put(io_gl);
+	gfs2_set_iop(inode);
+	insert_inode_hash(inode);
+
+	error = gfs2_inode_refresh(ip);
+	if (error)
+		goto fail_gunlock3;
+
 	error = gfs2_acl_create(dip, inode);
 	if (error)
-		goto fail_gunlock2;
+		goto fail_gunlock3;
 
 	error = gfs2_security_init(dip, ip, name);
 	if (error)
-		goto fail_gunlock2;
+		goto fail_gunlock3;
 
 	error = link_dinode(dip, name, ip);
 	if (error)
-		goto fail_gunlock2;
+		goto fail_gunlock3;
 
 	if (bh)
 		brelse(bh);
@@ -739,8 +741,20 @@ static int gfs2_create_inode(struct inode *dir, struct dentry *dentry,
 	d_instantiate(dentry, inode);
 	return 0;
 
+fail_gunlock3:
+	gfs2_glock_dq_uninit(ghs + 1);
+	if (ip->i_gl)
+		gfs2_glock_put(ip->i_gl);
+	goto fail_gunlock;
+
 fail_gunlock2:
 	gfs2_glock_dq_uninit(ghs + 1);
+fail_free_inode:
+	if (ip->i_gl)
+		gfs2_glock_put(ip->i_gl);
+	gfs2_rs_delete(ip);
+	free_inode_nonrcu(inode);
+	inode = NULL;
 fail_gunlock:
 	gfs2_glock_dq_uninit(ghs);
 	if (inode && !IS_ERR(inode)) {
@@ -748,7 +762,6 @@ fail_gunlock:
 		iput(inode);
 	}
 fail:
-	gfs2_rs_delete(dip);
 	if (bh)
 		brelse(bh);
 	return error;
-- 
1.7.4

