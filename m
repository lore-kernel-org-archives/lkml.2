Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933227Ab1ESJLn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 05:11:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18987 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933178Ab1ESJKq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 05:10:46 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 30/32] GFS2: Clean up mkdir
Date: Thu, 19 May 2011 09:47:25 +0100
Message-Id: <1305794847-3291-31-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1305794847-3291-1-git-send-email-swhiteho@redhat.com>
References: <1305794847-3291-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This moves the initialisation of the directory into the inode
creation functions to avoid having to duplicate the lookup
of the inode's buffer.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index a783a7a..4aee9dd 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -413,6 +413,22 @@ out:
 	return error;
 }
 
+static void gfs2_init_dir(struct buffer_head *dibh, const struct gfs2_inode *parent)
+{
+	struct gfs2_dinode *di = (struct gfs2_dinode *)dibh->b_data;
+	struct gfs2_dirent *dent = (struct gfs2_dirent *)(di+1);
+
+	gfs2_qstr2dirent(&gfs2_qdot, GFS2_DIRENT_SIZE(gfs2_qdot.len), dent);
+	dent->de_inum = di->di_num; /* already GFS2 endian */
+	dent->de_type = cpu_to_be16(DT_DIR);
+
+	dent = (struct gfs2_dirent *)((char*)dent + GFS2_DIRENT_SIZE(1));
+	gfs2_qstr2dirent(&gfs2_qdotdot, dibh->b_size - GFS2_DIRENT_SIZE(1) - sizeof(struct gfs2_dinode), dent);
+	gfs2_inum_out(parent, dent);
+	dent->de_type = cpu_to_be16(DT_DIR);
+	
+}
+
 /**
  * init_dinode - Fill in a new dinode structure
  * @dip: the directory this inode is being created in
@@ -454,16 +470,6 @@ static void init_dinode(struct gfs2_inode *dip, struct gfs2_glock *gl,
 	di->di_goal_meta = di->di_goal_data = cpu_to_be64(inum->no_addr);
 	di->di_generation = cpu_to_be64(*generation);
 	di->di_flags = 0;
-
-	if (S_ISREG(mode)) {
-		if ((dip->i_diskflags & GFS2_DIF_INHERIT_JDATA) ||
-		    gfs2_tune_get(sdp, gt_new_files_jdata))
-			di->di_flags |= cpu_to_be32(GFS2_DIF_JDATA);
-	} else if (S_ISDIR(mode)) {
-		di->di_flags |= cpu_to_be32(dip->i_diskflags &
-					    GFS2_DIF_INHERIT_JDATA);
-	}
-
 	di->__pad1 = 0;
 	di->di_payload_format = cpu_to_be32(S_ISDIR(mode) ? GFS2_FORMAT_DE : 0);
 	di->di_height = 0;
@@ -478,6 +484,19 @@ static void init_dinode(struct gfs2_inode *dip, struct gfs2_glock *gl,
 	di->di_ctime_nsec = cpu_to_be32(tv.tv_nsec);
 	memset(&di->di_reserved, 0, sizeof(di->di_reserved));
 	
+	if (S_ISREG(mode)) {
+		if ((dip->i_diskflags & GFS2_DIF_INHERIT_JDATA) ||
+		    gfs2_tune_get(sdp, gt_new_files_jdata))
+			di->di_flags |= cpu_to_be32(GFS2_DIF_JDATA);
+	} else if (S_ISDIR(mode)) {
+		di->di_flags |= cpu_to_be32(dip->i_diskflags &
+					    GFS2_DIF_INHERIT_JDATA);
+		di->di_flags |= cpu_to_be32(GFS2_DIF_JDATA);
+		di->di_size = cpu_to_be64(sdp->sd_sb.sb_bsize - sizeof(struct gfs2_dinode));
+		di->di_entries = cpu_to_be32(2);
+		gfs2_init_dir(dibh, dip);
+	}
+
 	set_buffer_uptodate(dibh);
 
 	*bhp = dibh;
@@ -568,7 +587,9 @@ static int link_dinode(struct gfs2_inode *dip, const struct qstr *name,
 	error = gfs2_meta_inode_buffer(ip, &dibh);
 	if (error)
 		goto fail_end_trans;
-	ip->i_inode.i_nlink = 1;
+	inc_nlink(&ip->i_inode);
+	if (S_ISDIR(ip->i_inode.i_mode))
+		inc_nlink(&ip->i_inode);
 	gfs2_trans_add_bh(ip->i_gl, dibh, 1);
 	gfs2_dinode_out(ip, dibh->b_data);
 	brelse(dibh);
@@ -1178,12 +1199,10 @@ static int gfs2_symlink(struct inode *dir, struct dentry *dentry,
 
 static int gfs2_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 {
-	struct gfs2_inode *dip = GFS2_I(dir), *ip;
+	struct gfs2_inode *dip = GFS2_I(dir);
 	struct gfs2_sbd *sdp = GFS2_SB(dir);
 	struct gfs2_holder ghs[2];
 	struct inode *inode;
-	struct buffer_head *dibh;
-	int error;
 
 	gfs2_holder_init(dip->i_gl, 0, 0, ghs);
 
@@ -1193,36 +1212,6 @@ static int gfs2_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 		return PTR_ERR(inode);
 	}
 
-	ip = ghs[1].gh_gl->gl_object;
-
-	ip->i_inode.i_nlink = 2;
-	i_size_write(inode, sdp->sd_sb.sb_bsize - sizeof(struct gfs2_dinode));
-	ip->i_diskflags |= GFS2_DIF_JDATA;
-	ip->i_entries = 2;
-
-	error = gfs2_meta_inode_buffer(ip, &dibh);
-
-	if (!gfs2_assert_withdraw(sdp, !error)) {
-		struct gfs2_dinode *di = (struct gfs2_dinode *)dibh->b_data;
-		struct gfs2_dirent *dent = (struct gfs2_dirent *)(di+1);
-
-		gfs2_trans_add_bh(ip->i_gl, dibh, 1);
-		gfs2_qstr2dirent(&gfs2_qdot, GFS2_DIRENT_SIZE(gfs2_qdot.len), dent);
-		dent->de_inum = di->di_num; /* already GFS2 endian */
-		dent->de_type = cpu_to_be16(DT_DIR);
-		di->di_entries = cpu_to_be32(1);
-
-		dent = (struct gfs2_dirent *)((char*)dent + GFS2_DIRENT_SIZE(1));
-		gfs2_qstr2dirent(&gfs2_qdotdot, dibh->b_size - GFS2_DIRENT_SIZE(1) - sizeof(struct gfs2_dinode), dent);
-
-		gfs2_inum_out(dip, dent);
-		dent->de_type = cpu_to_be16(DT_DIR);
-
-		gfs2_dinode_out(ip, di);
-
-		brelse(dibh);
-	}
-
 	gfs2_trans_end(sdp);
 	if (dip->i_alloc->al_rgd)
 		gfs2_inplace_release(dip);
-- 
1.7.4

