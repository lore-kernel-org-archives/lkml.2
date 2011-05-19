Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933207Ab1ESJMj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 05:12:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1379 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933153Ab1ESJKg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 05:10:36 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 24/32] GFS2: Move gfs2_refresh_inode() and friends into glops.c
Date: Thu, 19 May 2011 09:47:19 +0100
Message-Id: <1305794847-3291-25-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1305794847-3291-1-git-send-email-swhiteho@redhat.com>
References: <1305794847-3291-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eventually there will only be a single caller of this code, so lets
move it where it can be made static at some future date.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/glops.c b/fs/gfs2/glops.c
index 7c1b08f..8ef70f4 100644
--- a/fs/gfs2/glops.c
+++ b/fs/gfs2/glops.c
@@ -252,6 +252,119 @@ static int inode_go_demote_ok(const struct gfs2_glock *gl)
 }
 
 /**
+ * gfs2_set_nlink - Set the inode's link count based on on-disk info
+ * @inode: The inode in question
+ * @nlink: The link count
+ *
+ * If the link count has hit zero, it must never be raised, whatever the
+ * on-disk inode might say. When new struct inodes are created the link
+ * count is set to 1, so that we can safely use this test even when reading
+ * in on disk information for the first time.
+ */
+
+static void gfs2_set_nlink(struct inode *inode, u32 nlink)
+{
+	/*
+	 * We will need to review setting the nlink count here in the
+	 * light of the forthcoming ro bind mount work. This is a reminder
+	 * to do that.
+	 */
+	if ((inode->i_nlink != nlink) && (inode->i_nlink != 0)) {
+		if (nlink == 0)
+			clear_nlink(inode);
+		else
+			inode->i_nlink = nlink;
+	}
+}
+
+static int gfs2_dinode_in(struct gfs2_inode *ip, const void *buf)
+{
+	const struct gfs2_dinode *str = buf;
+	struct timespec atime;
+	u16 height, depth;
+
+	if (unlikely(ip->i_no_addr != be64_to_cpu(str->di_num.no_addr)))
+		goto corrupt;
+	ip->i_no_formal_ino = be64_to_cpu(str->di_num.no_formal_ino);
+	ip->i_inode.i_mode = be32_to_cpu(str->di_mode);
+	ip->i_inode.i_rdev = 0;
+	switch (ip->i_inode.i_mode & S_IFMT) {
+	case S_IFBLK:
+	case S_IFCHR:
+		ip->i_inode.i_rdev = MKDEV(be32_to_cpu(str->di_major),
+					   be32_to_cpu(str->di_minor));
+		break;
+	};
+
+	ip->i_inode.i_uid = be32_to_cpu(str->di_uid);
+	ip->i_inode.i_gid = be32_to_cpu(str->di_gid);
+	gfs2_set_nlink(&ip->i_inode, be32_to_cpu(str->di_nlink));
+	i_size_write(&ip->i_inode, be64_to_cpu(str->di_size));
+	gfs2_set_inode_blocks(&ip->i_inode, be64_to_cpu(str->di_blocks));
+	atime.tv_sec = be64_to_cpu(str->di_atime);
+	atime.tv_nsec = be32_to_cpu(str->di_atime_nsec);
+	if (timespec_compare(&ip->i_inode.i_atime, &atime) < 0)
+		ip->i_inode.i_atime = atime;
+	ip->i_inode.i_mtime.tv_sec = be64_to_cpu(str->di_mtime);
+	ip->i_inode.i_mtime.tv_nsec = be32_to_cpu(str->di_mtime_nsec);
+	ip->i_inode.i_ctime.tv_sec = be64_to_cpu(str->di_ctime);
+	ip->i_inode.i_ctime.tv_nsec = be32_to_cpu(str->di_ctime_nsec);
+
+	ip->i_goal = be64_to_cpu(str->di_goal_meta);
+	ip->i_generation = be64_to_cpu(str->di_generation);
+
+	ip->i_diskflags = be32_to_cpu(str->di_flags);
+	gfs2_set_inode_flags(&ip->i_inode);
+	height = be16_to_cpu(str->di_height);
+	if (unlikely(height > GFS2_MAX_META_HEIGHT))
+		goto corrupt;
+	ip->i_height = (u8)height;
+
+	depth = be16_to_cpu(str->di_depth);
+	if (unlikely(depth > GFS2_DIR_MAX_DEPTH))
+		goto corrupt;
+	ip->i_depth = (u8)depth;
+	ip->i_entries = be32_to_cpu(str->di_entries);
+
+	ip->i_eattr = be64_to_cpu(str->di_eattr);
+	if (S_ISREG(ip->i_inode.i_mode))
+		gfs2_set_aops(&ip->i_inode);
+
+	return 0;
+corrupt:
+	gfs2_consist_inode(ip);
+	return -EIO;
+}
+
+/**
+ * gfs2_inode_refresh - Refresh the incore copy of the dinode
+ * @ip: The GFS2 inode
+ *
+ * Returns: errno
+ */
+
+int gfs2_inode_refresh(struct gfs2_inode *ip)
+{
+	struct buffer_head *dibh;
+	int error;
+
+	error = gfs2_meta_inode_buffer(ip, &dibh);
+	if (error)
+		return error;
+
+	if (gfs2_metatype_check(GFS2_SB(&ip->i_inode), dibh, GFS2_METATYPE_DI)) {
+		brelse(dibh);
+		return -EIO;
+	}
+
+	error = gfs2_dinode_in(ip, dibh->b_data);
+	brelse(dibh);
+	clear_bit(GIF_INVALID, &ip->i_flags);
+
+	return error;
+}
+
+/**
  * inode_go_lock - operation done after an inode lock is locked by a process
  * @gl: the glock
  * @flags:
diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index 7c2121f..5d48baf 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -35,11 +35,6 @@
 #include "trans.h"
 #include "util.h"
 
-struct gfs2_inum_range_host {
-	u64 ir_start;
-	u64 ir_length;
-};
-
 struct gfs2_skip_data {
 	u64 no_addr;
 	int skipped;
@@ -248,118 +243,6 @@ fail_iput:
 	goto fail;
 }
 
-/**
- * gfs2_set_nlink - Set the inode's link count based on on-disk info
- * @inode: The inode in question
- * @nlink: The link count
- *
- * If the link count has hit zero, it must never be raised, whatever the
- * on-disk inode might say. When new struct inodes are created the link
- * count is set to 1, so that we can safely use this test even when reading
- * in on disk information for the first time.
- */
-
-static void gfs2_set_nlink(struct inode *inode, u32 nlink)
-{
-	/*
-	 * We will need to review setting the nlink count here in the
-	 * light of the forthcoming ro bind mount work. This is a reminder
-	 * to do that.
-	 */
-	if ((inode->i_nlink != nlink) && (inode->i_nlink != 0)) {
-		if (nlink == 0)
-			clear_nlink(inode);
-		else
-			inode->i_nlink = nlink;
-	}
-}
-
-static int gfs2_dinode_in(struct gfs2_inode *ip, const void *buf)
-{
-	const struct gfs2_dinode *str = buf;
-	struct timespec atime;
-	u16 height, depth;
-
-	if (unlikely(ip->i_no_addr != be64_to_cpu(str->di_num.no_addr)))
-		goto corrupt;
-	ip->i_no_formal_ino = be64_to_cpu(str->di_num.no_formal_ino);
-	ip->i_inode.i_mode = be32_to_cpu(str->di_mode);
-	ip->i_inode.i_rdev = 0;
-	switch (ip->i_inode.i_mode & S_IFMT) {
-	case S_IFBLK:
-	case S_IFCHR:
-		ip->i_inode.i_rdev = MKDEV(be32_to_cpu(str->di_major),
-					   be32_to_cpu(str->di_minor));
-		break;
-	};
-
-	ip->i_inode.i_uid = be32_to_cpu(str->di_uid);
-	ip->i_inode.i_gid = be32_to_cpu(str->di_gid);
-	gfs2_set_nlink(&ip->i_inode, be32_to_cpu(str->di_nlink));
-	i_size_write(&ip->i_inode, be64_to_cpu(str->di_size));
-	gfs2_set_inode_blocks(&ip->i_inode, be64_to_cpu(str->di_blocks));
-	atime.tv_sec = be64_to_cpu(str->di_atime);
-	atime.tv_nsec = be32_to_cpu(str->di_atime_nsec);
-	if (timespec_compare(&ip->i_inode.i_atime, &atime) < 0)
-		ip->i_inode.i_atime = atime;
-	ip->i_inode.i_mtime.tv_sec = be64_to_cpu(str->di_mtime);
-	ip->i_inode.i_mtime.tv_nsec = be32_to_cpu(str->di_mtime_nsec);
-	ip->i_inode.i_ctime.tv_sec = be64_to_cpu(str->di_ctime);
-	ip->i_inode.i_ctime.tv_nsec = be32_to_cpu(str->di_ctime_nsec);
-
-	ip->i_goal = be64_to_cpu(str->di_goal_meta);
-	ip->i_generation = be64_to_cpu(str->di_generation);
-
-	ip->i_diskflags = be32_to_cpu(str->di_flags);
-	gfs2_set_inode_flags(&ip->i_inode);
-	height = be16_to_cpu(str->di_height);
-	if (unlikely(height > GFS2_MAX_META_HEIGHT))
-		goto corrupt;
-	ip->i_height = (u8)height;
-
-	depth = be16_to_cpu(str->di_depth);
-	if (unlikely(depth > GFS2_DIR_MAX_DEPTH))
-		goto corrupt;
-	ip->i_depth = (u8)depth;
-	ip->i_entries = be32_to_cpu(str->di_entries);
-
-	ip->i_eattr = be64_to_cpu(str->di_eattr);
-	if (S_ISREG(ip->i_inode.i_mode))
-		gfs2_set_aops(&ip->i_inode);
-
-	return 0;
-corrupt:
-	gfs2_consist_inode(ip);
-	return -EIO;
-}
-
-/**
- * gfs2_inode_refresh - Refresh the incore copy of the dinode
- * @ip: The GFS2 inode
- *
- * Returns: errno
- */
-
-int gfs2_inode_refresh(struct gfs2_inode *ip)
-{
-	struct buffer_head *dibh;
-	int error;
-
-	error = gfs2_meta_inode_buffer(ip, &dibh);
-	if (error)
-		return error;
-
-	if (gfs2_metatype_check(GFS2_SB(&ip->i_inode), dibh, GFS2_METATYPE_DI)) {
-		brelse(dibh);
-		return -EIO;
-	}
-
-	error = gfs2_dinode_in(ip, dibh->b_data);
-	brelse(dibh);
-	clear_bit(GIF_INVALID, &ip->i_flags);
-
-	return error;
-}
 
 struct inode *gfs2_lookup_simple(struct inode *dip, const char *name)
 {
-- 
1.7.4

