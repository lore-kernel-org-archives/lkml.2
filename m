Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932480Ab0JROkm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 10:40:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55148 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932147Ab0JROhm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 10:37:42 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 10/22] GFS2: Make . and .. qstrs constant
Date: Mon, 18 Oct 2010 15:15:34 +0100
Message-Id: <1287411346-17855-11-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1287411346-17855-1-git-send-email-swhiteho@redhat.com>
References: <1287411346-17855-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rather than calculating the qstrs for . and .. each time
we need them, its better to keep a constant version of
these and just refer to them when required.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
Reviewed-by: Christoph Hellwig <hch@infradead.org>

diff --git a/fs/gfs2/dir.c b/fs/gfs2/dir.c
index c1042ae..5c356d0 100644
--- a/fs/gfs2/dir.c
+++ b/fs/gfs2/dir.c
@@ -79,6 +79,9 @@
 #define gfs2_disk_hash2offset(h) (((u64)(h)) >> 1)
 #define gfs2_dir_offset2hash(p) ((u32)(((u64)(p)) << 1))
 
+struct qstr gfs2_qdot __read_mostly;
+struct qstr gfs2_qdotdot __read_mostly;
+
 typedef int (*leaf_call_t) (struct gfs2_inode *dip, u32 index, u32 len,
 			    u64 leaf_no, void *data);
 typedef int (*gfs2_dscan_t)(const struct gfs2_dirent *dent,
diff --git a/fs/gfs2/dir.h b/fs/gfs2/dir.h
index 4f91944..a98f644 100644
--- a/fs/gfs2/dir.h
+++ b/fs/gfs2/dir.h
@@ -17,23 +17,24 @@ struct inode;
 struct gfs2_inode;
 struct gfs2_inum;
 
-struct inode *gfs2_dir_search(struct inode *dir, const struct qstr *filename);
-int gfs2_dir_check(struct inode *dir, const struct qstr *filename,
-		   const struct gfs2_inode *ip);
-int gfs2_dir_add(struct inode *inode, const struct qstr *filename,
-		 const struct gfs2_inode *ip, unsigned int type);
-int gfs2_dir_del(struct gfs2_inode *dip, const struct qstr *filename);
-int gfs2_dir_read(struct inode *inode, u64 *offset, void *opaque,
-		  filldir_t filldir);
-int gfs2_dir_mvino(struct gfs2_inode *dip, const struct qstr *filename,
-		   const struct gfs2_inode *nip, unsigned int new_type);
+extern struct inode *gfs2_dir_search(struct inode *dir,
+				     const struct qstr *filename);
+extern int gfs2_dir_check(struct inode *dir, const struct qstr *filename,
+			  const struct gfs2_inode *ip);
+extern int gfs2_dir_add(struct inode *inode, const struct qstr *filename,
+			const struct gfs2_inode *ip, unsigned int type);
+extern int gfs2_dir_del(struct gfs2_inode *dip, const struct qstr *filename);
+extern int gfs2_dir_read(struct inode *inode, u64 *offset, void *opaque,
+			 filldir_t filldir);
+extern int gfs2_dir_mvino(struct gfs2_inode *dip, const struct qstr *filename,
+			  const struct gfs2_inode *nip, unsigned int new_type);
 
-int gfs2_dir_exhash_dealloc(struct gfs2_inode *dip);
+extern int gfs2_dir_exhash_dealloc(struct gfs2_inode *dip);
 
-int gfs2_diradd_alloc_required(struct inode *dir,
-			       const struct qstr *filename);
-int gfs2_dir_get_new_buffer(struct gfs2_inode *ip, u64 block,
-			    struct buffer_head **bhp);
+extern int gfs2_diradd_alloc_required(struct inode *dir,
+				      const struct qstr *filename);
+extern int gfs2_dir_get_new_buffer(struct gfs2_inode *ip, u64 block,
+				   struct buffer_head **bhp);
 
 static inline u32 gfs2_disk_hash(const char *data, int len)
 {
@@ -61,4 +62,7 @@ static inline void gfs2_qstr2dirent(const struct qstr *name, u16 reclen, struct
 	memcpy(dent + 1, name->name, name->len);
 }
 
+extern struct qstr gfs2_qdot;
+extern struct qstr gfs2_qdotdot;
+
 #endif /* __DIR_DOT_H__ */
diff --git a/fs/gfs2/export.c b/fs/gfs2/export.c
index dfe237a..06d5827 100644
--- a/fs/gfs2/export.c
+++ b/fs/gfs2/export.c
@@ -126,16 +126,9 @@ static int gfs2_get_name(struct dentry *parent, char *name,
 
 static struct dentry *gfs2_get_parent(struct dentry *child)
 {
-	struct qstr dotdot;
 	struct dentry *dentry;
 
-	/*
-	 * XXX(hch): it would be a good idea to keep this around as a
-	 *	     static variable.
-	 */
-	gfs2_str2qstr(&dotdot, "..");
-
-	dentry = d_obtain_alias(gfs2_lookupi(child->d_inode, &dotdot, 1));
+	dentry = d_obtain_alias(gfs2_lookupi(child->d_inode, &gfs2_qdotdot, 1));
 	if (!IS_ERR(dentry))
 		dentry->d_op = &gfs2_dops;
 	return dentry;
diff --git a/fs/gfs2/main.c b/fs/gfs2/main.c
index 1c8bbf2..d7eb1e2 100644
--- a/fs/gfs2/main.c
+++ b/fs/gfs2/main.c
@@ -24,6 +24,7 @@
 #include "glock.h"
 #include "quota.h"
 #include "recovery.h"
+#include "dir.h"
 
 static struct shrinker qd_shrinker = {
 	.shrink = gfs2_shrink_qd_memory,
@@ -78,6 +79,9 @@ static int __init init_gfs2_fs(void)
 {
 	int error;
 
+	gfs2_str2qstr(&gfs2_qdot, ".");
+	gfs2_str2qstr(&gfs2_qdotdot, "..");
+
 	error = gfs2_sys_init();
 	if (error)
 		return error;
diff --git a/fs/gfs2/ops_inode.c b/fs/gfs2/ops_inode.c
index ce4f1df..98a94cf 100644
--- a/fs/gfs2/ops_inode.c
+++ b/fs/gfs2/ops_inode.c
@@ -471,18 +471,15 @@ static int gfs2_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 	if (!gfs2_assert_withdraw(sdp, !error)) {
 		struct gfs2_dinode *di = (struct gfs2_dinode *)dibh->b_data;
 		struct gfs2_dirent *dent = (struct gfs2_dirent *)(di+1);
-		struct qstr str;
 
-		gfs2_str2qstr(&str, ".");
 		gfs2_trans_add_bh(ip->i_gl, dibh, 1);
-		gfs2_qstr2dirent(&str, GFS2_DIRENT_SIZE(str.len), dent);
+		gfs2_qstr2dirent(&gfs2_qdot, GFS2_DIRENT_SIZE(gfs2_qdot.len), dent);
 		dent->de_inum = di->di_num; /* already GFS2 endian */
 		dent->de_type = cpu_to_be16(DT_DIR);
 		di->di_entries = cpu_to_be32(1);
 
-		gfs2_str2qstr(&str, "..");
 		dent = (struct gfs2_dirent *)((char*)dent + GFS2_DIRENT_SIZE(1));
-		gfs2_qstr2dirent(&str, dibh->b_size - GFS2_DIRENT_SIZE(1) - sizeof(struct gfs2_dinode), dent);
+		gfs2_qstr2dirent(&gfs2_qdotdot, dibh->b_size - GFS2_DIRENT_SIZE(1) - sizeof(struct gfs2_dinode), dent);
 
 		gfs2_inum_out(dip, dent);
 		dent->de_type = cpu_to_be16(DT_DIR);
@@ -523,7 +520,6 @@ static int gfs2_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 static int gfs2_rmdiri(struct gfs2_inode *dip, const struct qstr *name,
 		       struct gfs2_inode *ip)
 {
-	struct qstr dotname;
 	int error;
 
 	if (ip->i_entries != 2) {
@@ -540,13 +536,11 @@ static int gfs2_rmdiri(struct gfs2_inode *dip, const struct qstr *name,
 	if (error)
 		return error;
 
-	gfs2_str2qstr(&dotname, ".");
-	error = gfs2_dir_del(ip, &dotname);
+	error = gfs2_dir_del(ip, &gfs2_qdot);
 	if (error)
 		return error;
 
-	gfs2_str2qstr(&dotname, "..");
-	error = gfs2_dir_del(ip, &dotname);
+	error = gfs2_dir_del(ip, &gfs2_qdotdot);
 	if (error)
 		return error;
 
@@ -695,11 +689,8 @@ static int gfs2_ok_to_move(struct gfs2_inode *this, struct gfs2_inode *to)
 	struct inode *dir = &to->i_inode;
 	struct super_block *sb = dir->i_sb;
 	struct inode *tmp;
-	struct qstr dotdot;
 	int error = 0;
 
-	gfs2_str2qstr(&dotdot, "..");
-
 	igrab(dir);
 
 	for (;;) {
@@ -712,7 +703,7 @@ static int gfs2_ok_to_move(struct gfs2_inode *this, struct gfs2_inode *to)
 			break;
 		}
 
-		tmp = gfs2_lookupi(dir, &dotdot, 1);
+		tmp = gfs2_lookupi(dir, &gfs2_qdotdot, 1);
 		if (IS_ERR(tmp)) {
 			error = PTR_ERR(tmp);
 			break;
@@ -921,9 +912,6 @@ static int gfs2_rename(struct inode *odir, struct dentry *odentry,
 	}
 
 	if (dir_rename) {
-		struct qstr name;
-		gfs2_str2qstr(&name, "..");
-
 		error = gfs2_change_nlink(ndip, +1);
 		if (error)
 			goto out_end_trans;
@@ -931,7 +919,7 @@ static int gfs2_rename(struct inode *odir, struct dentry *odentry,
 		if (error)
 			goto out_end_trans;
 
-		error = gfs2_dir_mvino(ip, &name, ndip, DT_DIR);
+		error = gfs2_dir_mvino(ip, &gfs2_qdotdot, ndip, DT_DIR);
 		if (error)
 			goto out_end_trans;
 	} else {
-- 
1.7.1.1

