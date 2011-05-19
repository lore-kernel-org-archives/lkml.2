Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933245Ab1ESJLT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 05:11:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60307 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933213Ab1ESJKr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 05:10:47 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 31/32] GFS2: Clean up symlink creation
Date: Thu, 19 May 2011 09:47:26 +0100
Message-Id: <1305794847-3291-32-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1305794847-3291-1-git-send-email-swhiteho@redhat.com>
References: <1305794847-3291-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This moves the symlink specific parts of inode creation
into the function where we initialise the rest of the
dinode. As a result we have one less place where we need
to look up the inode's buffer.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index 4aee9dd..c2a3d9c 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -443,7 +443,8 @@ static void gfs2_init_dir(struct buffer_head *dibh, const struct gfs2_inode *par
 static void init_dinode(struct gfs2_inode *dip, struct gfs2_glock *gl,
 			const struct gfs2_inum_host *inum, unsigned int mode,
 			unsigned int uid, unsigned int gid,
-			const u64 *generation, dev_t dev, struct buffer_head **bhp)
+			const u64 *generation, dev_t dev, const char *symname,
+			unsigned size, struct buffer_head **bhp)
 {
 	struct gfs2_sbd *sdp = GFS2_SB(&dip->i_inode);
 	struct gfs2_dinode *di;
@@ -462,7 +463,7 @@ static void init_dinode(struct gfs2_inode *dip, struct gfs2_glock *gl,
 	di->di_uid = cpu_to_be32(uid);
 	di->di_gid = cpu_to_be32(gid);
 	di->di_nlink = 0;
-	di->di_size = 0;
+	di->di_size = cpu_to_be64(size);
 	di->di_blocks = cpu_to_be64(1);
 	di->di_atime = di->di_mtime = di->di_ctime = cpu_to_be64(tv.tv_sec);
 	di->di_major = cpu_to_be32(MAJOR(dev));
@@ -483,18 +484,24 @@ static void init_dinode(struct gfs2_inode *dip, struct gfs2_glock *gl,
 	di->di_mtime_nsec = cpu_to_be32(tv.tv_nsec);
 	di->di_ctime_nsec = cpu_to_be32(tv.tv_nsec);
 	memset(&di->di_reserved, 0, sizeof(di->di_reserved));
-	
-	if (S_ISREG(mode)) {
+
+	switch(mode & S_IFMT) {	
+	case S_IFREG:
 		if ((dip->i_diskflags & GFS2_DIF_INHERIT_JDATA) ||
 		    gfs2_tune_get(sdp, gt_new_files_jdata))
 			di->di_flags |= cpu_to_be32(GFS2_DIF_JDATA);
-	} else if (S_ISDIR(mode)) {
+		break;
+	case S_IFDIR:
 		di->di_flags |= cpu_to_be32(dip->i_diskflags &
 					    GFS2_DIF_INHERIT_JDATA);
 		di->di_flags |= cpu_to_be32(GFS2_DIF_JDATA);
 		di->di_size = cpu_to_be64(sdp->sd_sb.sb_bsize - sizeof(struct gfs2_dinode));
 		di->di_entries = cpu_to_be32(2);
 		gfs2_init_dir(dibh, dip);
+		break;
+	case S_IFLNK:
+		memcpy(dibh->b_data + sizeof(struct gfs2_dinode), symname, size);
+		break;
 	}
 
 	set_buffer_uptodate(dibh);
@@ -504,7 +511,8 @@ static void init_dinode(struct gfs2_inode *dip, struct gfs2_glock *gl,
 
 static int make_dinode(struct gfs2_inode *dip, struct gfs2_glock *gl,
 		       unsigned int mode, const struct gfs2_inum_host *inum,
-		       const u64 *generation, dev_t dev, struct buffer_head **bhp)
+		       const u64 *generation, dev_t dev, const char *symname,
+		       unsigned int size, struct buffer_head **bhp)
 {
 	struct gfs2_sbd *sdp = GFS2_SB(&dip->i_inode);
 	unsigned int uid, gid;
@@ -526,7 +534,7 @@ static int make_dinode(struct gfs2_inode *dip, struct gfs2_glock *gl,
 	if (error)
 		goto out_quota;
 
-	init_dinode(dip, gl, inum, mode, uid, gid, generation, dev, bhp);
+	init_dinode(dip, gl, inum, mode, uid, gid, generation, dev, symname, size, bhp);
 	gfs2_quota_change(dip, +1, uid, gid);
 	gfs2_trans_end(sdp);
 
@@ -651,8 +659,10 @@ static int gfs2_security_init(struct gfs2_inode *dip, struct gfs2_inode *ip,
  * Returns: An inode
  */
 
-struct inode *gfs2_createi(struct gfs2_holder *ghs, const struct qstr *name,
-			   unsigned int mode, dev_t dev)
+static struct inode *gfs2_createi(struct gfs2_holder *ghs,
+				  const struct qstr *name, unsigned int mode,
+				  dev_t dev, const char *symname,
+				  unsigned int size)
 {
 	struct inode *inode = NULL;
 	struct gfs2_inode *dip = ghs->gh_gl->gl_object;
@@ -685,7 +695,7 @@ struct inode *gfs2_createi(struct gfs2_holder *ghs, const struct qstr *name,
 	if (error)
 		goto fail_gunlock;
 
-	error = make_dinode(dip, ghs[1].gh_gl, mode, &inum, &generation, dev, &bh);
+	error = make_dinode(dip, ghs[1].gh_gl, mode, &inum, &generation, dev, symname, size, &bh);
 	if (error)
 		goto fail_gunlock2;
 
@@ -745,7 +755,7 @@ static int gfs2_create(struct inode *dir, struct dentry *dentry,
 	gfs2_holder_init(dip->i_gl, 0, 0, ghs);
 
 	for (;;) {
-		inode = gfs2_createi(ghs, &dentry->d_name, S_IFREG | mode, 0);
+		inode = gfs2_createi(ghs, &dentry->d_name, S_IFREG | mode, 0, NULL, 0);
 		if (!IS_ERR(inode)) {
 			gfs2_trans_end(sdp);
 			if (dip->i_alloc->al_rgd)
@@ -1140,40 +1150,24 @@ out_parent:
 static int gfs2_symlink(struct inode *dir, struct dentry *dentry,
 			const char *symname)
 {
-	struct gfs2_inode *dip = GFS2_I(dir), *ip;
+	struct gfs2_inode *dip = GFS2_I(dir);
 	struct gfs2_sbd *sdp = GFS2_SB(dir);
 	struct gfs2_holder ghs[2];
 	struct inode *inode;
-	struct buffer_head *dibh;
-	int size;
-	int error;
+	unsigned int size;
 
-	/* Must be stuffed with a null terminator for gfs2_follow_link() */
 	size = strlen(symname);
 	if (size > sdp->sd_sb.sb_bsize - sizeof(struct gfs2_dinode) - 1)
 		return -ENAMETOOLONG;
 
 	gfs2_holder_init(dip->i_gl, 0, 0, ghs);
 
-	inode = gfs2_createi(ghs, &dentry->d_name, S_IFLNK | S_IRWXUGO, 0);
+	inode = gfs2_createi(ghs, &dentry->d_name, S_IFLNK | S_IRWXUGO, 0, symname, size);
 	if (IS_ERR(inode)) {
 		gfs2_holder_uninit(ghs);
 		return PTR_ERR(inode);
 	}
 
-	ip = ghs[1].gh_gl->gl_object;
-
-	i_size_write(inode, size);
-
-	error = gfs2_meta_inode_buffer(ip, &dibh);
-
-	if (!gfs2_assert_withdraw(sdp, !error)) {
-		gfs2_dinode_out(ip, dibh->b_data);
-		memcpy(dibh->b_data + sizeof(struct gfs2_dinode), symname,
-		       size);
-		brelse(dibh);
-	}
-
 	gfs2_trans_end(sdp);
 	if (dip->i_alloc->al_rgd)
 		gfs2_inplace_release(dip);
@@ -1206,7 +1200,7 @@ static int gfs2_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 
 	gfs2_holder_init(dip->i_gl, 0, 0, ghs);
 
-	inode = gfs2_createi(ghs, &dentry->d_name, S_IFDIR | mode, 0);
+	inode = gfs2_createi(ghs, &dentry->d_name, S_IFDIR | mode, 0, NULL, 0);
 	if (IS_ERR(inode)) {
 		gfs2_holder_uninit(ghs);
 		return PTR_ERR(inode);
@@ -1245,7 +1239,7 @@ static int gfs2_mknod(struct inode *dir, struct dentry *dentry, int mode,
 
 	gfs2_holder_init(dip->i_gl, 0, 0, ghs);
 
-	inode = gfs2_createi(ghs, &dentry->d_name, mode, dev);
+	inode = gfs2_createi(ghs, &dentry->d_name, mode, dev, NULL, 0);
 	if (IS_ERR(inode)) {
 		gfs2_holder_uninit(ghs);
 		return PTR_ERR(inode);
@@ -1572,7 +1566,7 @@ static void *gfs2_follow_link(struct dentry *dentry, struct nameidata *nd)
 	struct gfs2_inode *ip = GFS2_I(dentry->d_inode);
 	struct gfs2_holder i_gh;
 	struct buffer_head *dibh;
-	unsigned int x, size;
+	unsigned int size;
 	char *buf;
 	int error;
 
@@ -1597,12 +1591,11 @@ static void *gfs2_follow_link(struct dentry *dentry, struct nameidata *nd)
 		goto out;
 	}
 
-	x = size + 1;
-	buf = kmalloc(x, GFP_NOFS);
+	buf = kzalloc(size + 1, GFP_NOFS);
 	if (!buf)
 		buf = ERR_PTR(-ENOMEM);
 	else
-		memcpy(buf, dibh->b_data + sizeof(struct gfs2_dinode), x);
+		memcpy(buf, dibh->b_data + sizeof(struct gfs2_dinode), size);
 	brelse(dibh);
 out:
 	gfs2_glock_dq_uninit(&i_gh);
diff --git a/fs/gfs2/inode.h b/fs/gfs2/inode.h
index 7ed60aa..3160607 100644
--- a/fs/gfs2/inode.h
+++ b/fs/gfs2/inode.h
@@ -108,9 +108,6 @@ extern int gfs2_inode_refresh(struct gfs2_inode *ip);
 
 extern struct inode *gfs2_lookupi(struct inode *dir, const struct qstr *name,
 				  int is_root);
-extern struct inode *gfs2_createi(struct gfs2_holder *ghs,
-				  const struct qstr *name,
-				  unsigned int mode, dev_t dev);
 extern int gfs2_permission(struct inode *inode, int mask, unsigned int flags);
 extern int gfs2_setattr_simple(struct gfs2_inode *ip, struct iattr *attr);
 extern struct inode *gfs2_lookup_simple(struct inode *dip, const char *name);
-- 
1.7.4

