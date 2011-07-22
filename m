Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753600Ab1GVJjn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 05:39:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56013 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752993Ab1GVJjl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 05:39:41 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 1/4] GFS2: Cache dir hash table in a contiguous buffer
Date: Fri, 22 Jul 2011 10:16:51 +0100
Message-Id: <1311326214-3325-2-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1311326214-3325-1-git-send-email-swhiteho@redhat.com>
References: <1311326214-3325-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a cache for the hash table to the directory code
in order to help simplify the way in which the hash table is
accessed. This is intended to be a first step towards introducing
some performance improvements in the directory code.

There are two follow ups that I'm hoping to see fairly shortly. One
is to simplify the hash table reading code now that we always read the
complete hash table, whether we want one entry or all of them. The
other is to introduce readahead on the heads of the hash chains
which are referred to from the table.

The hash table is a maximum of 128k in size, so it is not worth trying
to read it in small chunks.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/dir.c b/fs/gfs2/dir.c
index 091ee47..1cc2f8e 100644
--- a/fs/gfs2/dir.c
+++ b/fs/gfs2/dir.c
@@ -339,6 +339,67 @@ fail:
 	return (copied) ? copied : error;
 }
 
+/**
+ * gfs2_dir_get_hash_table - Get pointer to the dir hash table
+ * @ip: The inode in question
+ *
+ * Returns: The hash table or an error
+ */
+
+static __be64 *gfs2_dir_get_hash_table(struct gfs2_inode *ip)
+{
+	struct inode *inode = &ip->i_inode;
+	int ret;
+	u32 hsize;
+	__be64 *hc;
+
+	BUG_ON(!(ip->i_diskflags & GFS2_DIF_EXHASH));
+
+	hc = ip->i_hash_cache;
+	if (hc)
+		return hc;
+
+	hsize = 1 << ip->i_depth;
+	hsize *= sizeof(__be64);
+	if (hsize != i_size_read(&ip->i_inode)) {
+		gfs2_consist_inode(ip);
+		return ERR_PTR(-EIO);
+	}
+
+	hc = kmalloc(hsize, GFP_NOFS);
+	ret = -ENOMEM;
+	if (hc == NULL)
+		return ERR_PTR(-ENOMEM);
+
+	ret = gfs2_dir_read_data(ip, (char *)hc, 0, hsize, 1);
+	if (ret < 0) {
+		kfree(hc);
+		return ERR_PTR(ret);
+	}
+
+	spin_lock(&inode->i_lock);
+	if (ip->i_hash_cache)
+		kfree(hc);
+	else
+		ip->i_hash_cache = hc;
+	spin_unlock(&inode->i_lock);
+
+	return ip->i_hash_cache;
+}
+
+/**
+ * gfs2_dir_hash_inval - Invalidate dir hash
+ * @ip: The directory inode
+ *
+ * Must be called with an exclusive glock, or during glock invalidation.
+ */
+void gfs2_dir_hash_inval(struct gfs2_inode *ip)
+{
+	__be64 *hc = ip->i_hash_cache;
+	ip->i_hash_cache = NULL;
+	kfree(hc);
+}
+
 static inline int gfs2_dirent_sentinel(const struct gfs2_dirent *dent)
 {
 	return dent->de_inum.no_addr == 0 || dent->de_inum.no_formal_ino == 0;
@@ -686,17 +747,12 @@ static int get_leaf(struct gfs2_inode *dip, u64 leaf_no,
 static int get_leaf_nr(struct gfs2_inode *dip, u32 index,
 		       u64 *leaf_out)
 {
-	__be64 leaf_no;
-	int error;
-
-	error = gfs2_dir_read_data(dip, (char *)&leaf_no,
-				    index * sizeof(__be64),
-				    sizeof(__be64), 0);
-	if (error != sizeof(u64))
-		return (error < 0) ? error : -EIO;
-
-	*leaf_out = be64_to_cpu(leaf_no);
+	__be64 *hash;
 
+	hash = gfs2_dir_get_hash_table(dip);
+	if (IS_ERR(hash))
+		return PTR_ERR(hash);
+	*leaf_out = be64_to_cpu(*(hash + index));
 	return 0;
 }
 
@@ -966,6 +1022,8 @@ static int dir_split_leaf(struct inode *inode, const struct qstr *name)
 	for (x = 0; x < half_len; x++)
 		lp[x] = cpu_to_be64(bn);
 
+	gfs2_dir_hash_inval(dip);
+
 	error = gfs2_dir_write_data(dip, (char *)lp, start * sizeof(u64),
 				    half_len * sizeof(u64));
 	if (error != half_len * sizeof(u64)) {
@@ -1052,70 +1110,54 @@ fail_brelse:
 
 static int dir_double_exhash(struct gfs2_inode *dip)
 {
-	struct gfs2_sbd *sdp = GFS2_SB(&dip->i_inode);
 	struct buffer_head *dibh;
 	u32 hsize;
-	u64 *buf;
-	u64 *from, *to;
-	u64 block;
-	u64 disksize = i_size_read(&dip->i_inode);
+	u32 hsize_bytes;
+	__be64 *hc;
+	__be64 *hc2, *h;
 	int x;
 	int error = 0;
 
 	hsize = 1 << dip->i_depth;
-	if (hsize * sizeof(u64) != disksize) {
-		gfs2_consist_inode(dip);
-		return -EIO;
-	}
+	hsize_bytes = hsize * sizeof(__be64);
 
-	/*  Allocate both the "from" and "to" buffers in one big chunk  */
+	hc = gfs2_dir_get_hash_table(dip);
+	if (IS_ERR(hc))
+		return PTR_ERR(hc);
 
-	buf = kcalloc(3, sdp->sd_hash_bsize, GFP_NOFS);
-	if (!buf)
+	h = hc2 = kmalloc(hsize_bytes * 2, GFP_NOFS);
+	if (!hc2)
 		return -ENOMEM;
 
-	for (block = disksize >> sdp->sd_hash_bsize_shift; block--;) {
-		error = gfs2_dir_read_data(dip, (char *)buf,
-					    block * sdp->sd_hash_bsize,
-					    sdp->sd_hash_bsize, 1);
-		if (error != sdp->sd_hash_bsize) {
-			if (error >= 0)
-				error = -EIO;
-			goto fail;
-		}
-
-		from = buf;
-		to = (u64 *)((char *)buf + sdp->sd_hash_bsize);
-
-		for (x = sdp->sd_hash_ptrs; x--; from++) {
-			*to++ = *from;	/*  No endianess worries  */
-			*to++ = *from;
-		}
+	error = gfs2_meta_inode_buffer(dip, &dibh);
+	if (error)
+		goto out_kfree;
 
-		error = gfs2_dir_write_data(dip,
-					     (char *)buf + sdp->sd_hash_bsize,
-					     block * sdp->sd_sb.sb_bsize,
-					     sdp->sd_sb.sb_bsize);
-		if (error != sdp->sd_sb.sb_bsize) {
-			if (error >= 0)
-				error = -EIO;
-			goto fail;
-		}
+	for (x = 0; x < hsize; x++) {
+		*h++ = *hc;
+		*h++ = *hc;
+		hc++;
 	}
 
-	kfree(buf);
-
-	error = gfs2_meta_inode_buffer(dip, &dibh);
-	if (!gfs2_assert_withdraw(sdp, !error)) {
-		dip->i_depth++;
-		gfs2_dinode_out(dip, dibh->b_data);
-		brelse(dibh);
-	}
+	error = gfs2_dir_write_data(dip, (char *)hc2, 0, hsize_bytes * 2);
+	if (error != (hsize_bytes * 2))
+		goto fail;
 
-	return error;
+	gfs2_dir_hash_inval(dip);
+	dip->i_hash_cache = hc2;
+	dip->i_depth++;
+	gfs2_dinode_out(dip, dibh->b_data);
+	brelse(dibh);
+	return 0;
 
 fail:
-	kfree(buf);
+	/* Replace original hash table & size */
+	gfs2_dir_write_data(dip, (char *)hc, 0, hsize_bytes);
+	i_size_write(&dip->i_inode, hsize_bytes);
+	gfs2_dinode_out(dip, dibh->b_data);
+	brelse(dibh);
+out_kfree:
+	kfree(hc2);
 	return error;
 }
 
@@ -1348,6 +1390,7 @@ out:
 	return error;
 }
 
+
 /**
  * dir_e_read - Reads the entries from a directory into a filldir buffer
  * @dip: dinode pointer
@@ -1362,9 +1405,7 @@ static int dir_e_read(struct inode *inode, u64 *offset, void *opaque,
 		      filldir_t filldir)
 {
 	struct gfs2_inode *dip = GFS2_I(inode);
-	struct gfs2_sbd *sdp = GFS2_SB(inode);
 	u32 hsize, len = 0;
-	u32 ht_offset, lp_offset, ht_offset_cur = -1;
 	u32 hash, index;
 	__be64 *lp;
 	int copied = 0;
@@ -1372,37 +1413,17 @@ static int dir_e_read(struct inode *inode, u64 *offset, void *opaque,
 	unsigned depth = 0;
 
 	hsize = 1 << dip->i_depth;
-	if (hsize * sizeof(u64) != i_size_read(inode)) {
-		gfs2_consist_inode(dip);
-		return -EIO;
-	}
-
 	hash = gfs2_dir_offset2hash(*offset);
 	index = hash >> (32 - dip->i_depth);
 
-	lp = kmalloc(sdp->sd_hash_bsize, GFP_NOFS);
-	if (!lp)
-		return -ENOMEM;
+	lp = gfs2_dir_get_hash_table(dip);
+	if (IS_ERR(lp))
+		return PTR_ERR(lp);
 
 	while (index < hsize) {
-		lp_offset = index & (sdp->sd_hash_ptrs - 1);
-		ht_offset = index - lp_offset;
-
-		if (ht_offset_cur != ht_offset) {
-			error = gfs2_dir_read_data(dip, (char *)lp,
-						ht_offset * sizeof(__be64),
-						sdp->sd_hash_bsize, 1);
-			if (error != sdp->sd_hash_bsize) {
-				if (error >= 0)
-					error = -EIO;
-				goto out;
-			}
-			ht_offset_cur = ht_offset;
-		}
-
 		error = gfs2_dir_read_leaf(inode, offset, opaque, filldir,
 					   &copied, &depth,
-					   be64_to_cpu(lp[lp_offset]));
+					   be64_to_cpu(lp[index]));
 		if (error)
 			break;
 
@@ -1410,8 +1431,6 @@ static int dir_e_read(struct inode *inode, u64 *offset, void *opaque,
 		index = (index & ~(len - 1)) + len;
 	}
 
-out:
-	kfree(lp);
 	if (error > 0)
 		error = 0;
 	return error;
@@ -1914,43 +1933,22 @@ out:
 
 int gfs2_dir_exhash_dealloc(struct gfs2_inode *dip)
 {
-	struct gfs2_sbd *sdp = GFS2_SB(&dip->i_inode);
 	struct buffer_head *bh;
 	struct gfs2_leaf *leaf;
 	u32 hsize, len;
-	u32 ht_offset, lp_offset, ht_offset_cur = -1;
 	u32 index = 0, next_index;
 	__be64 *lp;
 	u64 leaf_no;
 	int error = 0, last;
 
 	hsize = 1 << dip->i_depth;
-	if (hsize * sizeof(u64) != i_size_read(&dip->i_inode)) {
-		gfs2_consist_inode(dip);
-		return -EIO;
-	}
 
-	lp = kmalloc(sdp->sd_hash_bsize, GFP_NOFS);
-	if (!lp)
-		return -ENOMEM;
+	lp = gfs2_dir_get_hash_table(dip);
+	if (IS_ERR(lp))
+		return PTR_ERR(lp);
 
 	while (index < hsize) {
-		lp_offset = index & (sdp->sd_hash_ptrs - 1);
-		ht_offset = index - lp_offset;
-
-		if (ht_offset_cur != ht_offset) {
-			error = gfs2_dir_read_data(dip, (char *)lp,
-						ht_offset * sizeof(__be64),
-						sdp->sd_hash_bsize, 1);
-			if (error != sdp->sd_hash_bsize) {
-				if (error >= 0)
-					error = -EIO;
-				goto out;
-			}
-			ht_offset_cur = ht_offset;
-		}
-
-		leaf_no = be64_to_cpu(lp[lp_offset]);
+		leaf_no = be64_to_cpu(lp[index]);
 		if (leaf_no) {
 			error = get_leaf(dip, leaf_no, &bh);
 			if (error)
@@ -1976,7 +1974,6 @@ int gfs2_dir_exhash_dealloc(struct gfs2_inode *dip)
 	}
 
 out:
-	kfree(lp);
 
 	return error;
 }
diff --git a/fs/gfs2/dir.h b/fs/gfs2/dir.h
index e686af1..ff5772f 100644
--- a/fs/gfs2/dir.h
+++ b/fs/gfs2/dir.h
@@ -35,6 +35,7 @@ extern int gfs2_diradd_alloc_required(struct inode *dir,
 				      const struct qstr *filename);
 extern int gfs2_dir_get_new_buffer(struct gfs2_inode *ip, u64 block,
 				   struct buffer_head **bhp);
+extern void gfs2_dir_hash_inval(struct gfs2_inode *ip);
 
 static inline u32 gfs2_disk_hash(const char *data, int len)
 {
diff --git a/fs/gfs2/glops.c b/fs/gfs2/glops.c
index 2cca293..95788ae 100644
--- a/fs/gfs2/glops.c
+++ b/fs/gfs2/glops.c
@@ -26,6 +26,7 @@
 #include "rgrp.h"
 #include "util.h"
 #include "trans.h"
+#include "dir.h"
 
 /**
  * __gfs2_ail_flush - remove all buffers for a given lock from the AIL
@@ -218,6 +219,7 @@ static void inode_go_inval(struct gfs2_glock *gl, int flags)
 		if (ip) {
 			set_bit(GIF_INVALID, &ip->i_flags);
 			forget_all_cached_acls(&ip->i_inode);
+			gfs2_dir_hash_inval(ip);
 		}
 	}
 
diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index 81206e7..24cd55f 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -285,6 +285,7 @@ struct gfs2_inode {
 	u64 i_goal;	/* goal block for allocations */
 	struct rw_semaphore i_rw_mutex;
 	struct list_head i_trunc_list;
+	__be64 *i_hash_cache;
 	u32 i_entries;
 	u32 i_diskflags;
 	u8 i_height;
diff --git a/fs/gfs2/main.c b/fs/gfs2/main.c
index c2b34cd..29e1ace 100644
--- a/fs/gfs2/main.c
+++ b/fs/gfs2/main.c
@@ -41,6 +41,7 @@ static void gfs2_init_inode_once(void *foo)
 	init_rwsem(&ip->i_rw_mutex);
 	INIT_LIST_HEAD(&ip->i_trunc_list);
 	ip->i_alloc = NULL;
+	ip->i_hash_cache = NULL;
 }
 
 static void gfs2_init_glock_once(void *foo)
diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index fb0edf7..b7beadd 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -1533,7 +1533,7 @@ out:
 	/* Case 3 starts here */
 	truncate_inode_pages(&inode->i_data, 0);
 	end_writeback(inode);
-
+	gfs2_dir_hash_inval(ip);
 	ip->i_gl->gl_object = NULL;
 	gfs2_glock_add_to_lru(ip->i_gl);
 	gfs2_glock_put(ip->i_gl);
-- 
1.7.4

