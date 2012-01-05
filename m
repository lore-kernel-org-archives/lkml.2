Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756614Ab2AEMQP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 07:16:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56244 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756537Ab2AEMQO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 07:16:14 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Bob Peterson <rpeterso@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 02/16] GFS2: Add readahead to sequential directory traversal
Date: Thu,  5 Jan 2012 11:51:48 +0000
Message-Id: <1325764322-10807-3-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1325764322-10807-1-git-send-email-swhiteho@redhat.com>
References: <1325764322-10807-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

This patch adds read-ahead capability to GFS2's
directory hash table management.  It greatly improves
performance for some directory operations.  For example:
In one of my file systems that has 1000 directories, each
of which has 1000 files, time to execute a recursive
ls (time ls -fR /mnt/gfs2 > /dev/null) was reduced
from 2m2.814s on a stock kernel to 0m45.938s.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/dir.c b/fs/gfs2/dir.c
index 8ccad24..9144117 100644
--- a/fs/gfs2/dir.c
+++ b/fs/gfs2/dir.c
@@ -76,6 +76,8 @@
 #define IS_LEAF     1 /* Hashed (leaf) directory */
 #define IS_DINODE   2 /* Linear (stuffed dinode block) directory */
 
+#define MAX_RA_BLOCKS 32 /* max read-ahead blocks */
+
 #define gfs2_disk_hash2offset(h) (((u64)(h)) >> 1)
 #define gfs2_dir_offset2hash(p) ((u32)(((u64)(p)) << 1))
 
@@ -1376,6 +1378,50 @@ out:
 	return error;
 }
 
+/* gfs2_dir_readahead - Issue read-ahead requests for leaf blocks.
+ *
+ * Note: we can't calculate each index like dir_e_read can because we don't
+ * have the leaf, and therefore we don't have the depth, and therefore we
+ * don't have the length. So we have to just read enough ahead to make up
+ * for the loss of information. */
+static void gfs2_dir_readahead(struct inode *inode, unsigned hsize, u32 index,
+			       struct file_ra_state *f_ra)
+{
+	struct gfs2_inode *ip = GFS2_I(inode);
+	struct gfs2_glock *gl = ip->i_gl;
+	struct buffer_head *bh;
+	u64 blocknr = 0, last;
+	unsigned count;
+
+	/* First check if we've already read-ahead for the whole range. */
+	if (!f_ra || index + MAX_RA_BLOCKS < f_ra->start)
+		return;
+
+	f_ra->start = max((pgoff_t)index, f_ra->start);
+	for (count = 0; count < MAX_RA_BLOCKS; count++) {
+		if (f_ra->start >= hsize) /* if exceeded the hash table */
+			break;
+
+		last = blocknr;
+		blocknr = be64_to_cpu(ip->i_hash_cache[f_ra->start]);
+		f_ra->start++;
+		if (blocknr == last)
+			continue;
+
+		bh = gfs2_getbuf(gl, blocknr, 1);
+		if (trylock_buffer(bh)) {
+			if (buffer_uptodate(bh)) {
+				unlock_buffer(bh);
+				brelse(bh);
+				continue;
+			}
+			bh->b_end_io = end_buffer_read_sync;
+			submit_bh(READA | REQ_META, bh);
+			continue;
+		}
+		brelse(bh);
+	}
+}
 
 /**
  * dir_e_read - Reads the entries from a directory into a filldir buffer
@@ -1388,7 +1434,7 @@ out:
  */
 
 static int dir_e_read(struct inode *inode, u64 *offset, void *opaque,
-		      filldir_t filldir)
+		      filldir_t filldir, struct file_ra_state *f_ra)
 {
 	struct gfs2_inode *dip = GFS2_I(inode);
 	u32 hsize, len = 0;
@@ -1402,10 +1448,14 @@ static int dir_e_read(struct inode *inode, u64 *offset, void *opaque,
 	hash = gfs2_dir_offset2hash(*offset);
 	index = hash >> (32 - dip->i_depth);
 
+	if (f_ra && dip->i_hash_cache == NULL)
+		f_ra->start = 0;
 	lp = gfs2_dir_get_hash_table(dip);
 	if (IS_ERR(lp))
 		return PTR_ERR(lp);
 
+	gfs2_dir_readahead(inode, hsize, index, f_ra);
+
 	while (index < hsize) {
 		error = gfs2_dir_read_leaf(inode, offset, opaque, filldir,
 					   &copied, &depth,
@@ -1423,7 +1473,7 @@ static int dir_e_read(struct inode *inode, u64 *offset, void *opaque,
 }
 
 int gfs2_dir_read(struct inode *inode, u64 *offset, void *opaque,
-		  filldir_t filldir)
+		  filldir_t filldir, struct file_ra_state *f_ra)
 {
 	struct gfs2_inode *dip = GFS2_I(inode);
 	struct gfs2_sbd *sdp = GFS2_SB(inode);
@@ -1437,7 +1487,7 @@ int gfs2_dir_read(struct inode *inode, u64 *offset, void *opaque,
 		return 0;
 
 	if (dip->i_diskflags & GFS2_DIF_EXHASH)
-		return dir_e_read(inode, offset, opaque, filldir);
+		return dir_e_read(inode, offset, opaque, filldir, f_ra);
 
 	if (!gfs2_is_stuffed(dip)) {
 		gfs2_consist_inode(dip);
diff --git a/fs/gfs2/dir.h b/fs/gfs2/dir.h
index ff5772f..98c960b 100644
--- a/fs/gfs2/dir.h
+++ b/fs/gfs2/dir.h
@@ -25,7 +25,7 @@ extern int gfs2_dir_add(struct inode *inode, const struct qstr *filename,
 			const struct gfs2_inode *ip);
 extern int gfs2_dir_del(struct gfs2_inode *dip, const struct dentry *dentry);
 extern int gfs2_dir_read(struct inode *inode, u64 *offset, void *opaque,
-			 filldir_t filldir);
+			 filldir_t filldir, struct file_ra_state *f_ra);
 extern int gfs2_dir_mvino(struct gfs2_inode *dip, const struct qstr *filename,
 			  const struct gfs2_inode *nip, unsigned int new_type);
 
diff --git a/fs/gfs2/export.c b/fs/gfs2/export.c
index fe9945f..70ba891 100644
--- a/fs/gfs2/export.c
+++ b/fs/gfs2/export.c
@@ -99,6 +99,7 @@ static int gfs2_get_name(struct dentry *parent, char *name,
 	struct gfs2_holder gh;
 	u64 offset = 0;
 	int error;
+	struct file_ra_state f_ra = { .start = 0 };
 
 	if (!dir)
 		return -EINVAL;
@@ -118,7 +119,7 @@ static int gfs2_get_name(struct dentry *parent, char *name,
 	if (error)
 		return error;
 
-	error = gfs2_dir_read(dir, &offset, &gnfd, get_name_filldir);
+	error = gfs2_dir_read(dir, &offset, &gnfd, get_name_filldir, &f_ra);
 
 	gfs2_glock_dq_uninit(&gh);
 
diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
index ce36a56..46f6f9a 100644
--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -105,7 +105,7 @@ static int gfs2_readdir(struct file *file, void *dirent, filldir_t filldir)
 		return error;
 	}
 
-	error = gfs2_dir_read(dir, &offset, dirent, filldir);
+	error = gfs2_dir_read(dir, &offset, dirent, filldir, &file->f_ra);
 
 	gfs2_glock_dq_uninit(&d_gh);
 
-- 
1.7.4

