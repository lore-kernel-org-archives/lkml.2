Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932504Ab0JROli (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 10:41:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14590 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932149Ab0JROhi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 10:37:38 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>, Nick Piggin <npiggin@suse.de>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH 01/22] GFS2: New truncate sequence
Date: Mon, 18 Oct 2010 15:15:25 +0100
Message-Id: <1287411346-17855-2-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1287411346-17855-1-git-send-email-swhiteho@redhat.com>
References: <1287411346-17855-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This updates GFS2's truncate code to use the new truncate
sequence correctly. This is a stepping stone to being
able to remove ip->i_disksize in favour of using i_size
everywhere now that the two sizes are always identical.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Christoph Hellwig <hch@lst.de>

diff --git a/fs/gfs2/aops.c b/fs/gfs2/aops.c
index 194fe16..f687f25 100644
--- a/fs/gfs2/aops.c
+++ b/fs/gfs2/aops.c
@@ -696,13 +696,11 @@ out:
 
 	page_cache_release(page);
 
-	/*
-	 * XXX(truncate): the call below should probably be replaced with
-	 * a call to the gfs2-specific truncate blocks helper to actually
-	 * release disk blocks..
-	 */
+	gfs2_trans_end(sdp);
 	if (pos + len > ip->i_inode.i_size)
-		truncate_setsize(&ip->i_inode, ip->i_inode.i_size);
+		gfs2_trim_blocks(&ip->i_inode);
+	goto out_trans_fail;
+
 out_endtrans:
 	gfs2_trans_end(sdp);
 out_trans_fail:
diff --git a/fs/gfs2/bmap.c b/fs/gfs2/bmap.c
index 6f48280..20b971a 100644
--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -50,7 +50,7 @@ struct strip_mine {
  * @ip: the inode
  * @dibh: the dinode buffer
  * @block: the block number that was allocated
- * @private: any locked page held by the caller process
+ * @page: The (optional) page. This is looked up if @page is NULL
  *
  * Returns: errno
  */
@@ -109,8 +109,7 @@ static int gfs2_unstuffer_page(struct gfs2_inode *ip, struct buffer_head *dibh,
 /**
  * gfs2_unstuff_dinode - Unstuff a dinode when the data has grown too big
  * @ip: The GFS2 inode to unstuff
- * @unstuffer: the routine that handles unstuffing a non-zero length file
- * @private: private data for the unstuffer
+ * @page: The (optional) page. This is looked up if the @page is NULL
  *
  * This routine unstuffs a dinode and returns it to a "normal" state such
  * that the height can be grown in the traditional way.
@@ -885,83 +884,14 @@ out:
 }
 
 /**
- * do_grow - Make a file look bigger than it is
- * @ip: the inode
- * @size: the size to set the file to
- *
- * Called with an exclusive lock on @ip.
- *
- * Returns: errno
- */
-
-static int do_grow(struct gfs2_inode *ip, u64 size)
-{
-	struct gfs2_sbd *sdp = GFS2_SB(&ip->i_inode);
-	struct gfs2_alloc *al;
-	struct buffer_head *dibh;
-	int error;
-
-	al = gfs2_alloc_get(ip);
-	if (!al)
-		return -ENOMEM;
-
-	error = gfs2_quota_lock_check(ip);
-	if (error)
-		goto out;
-
-	al->al_requested = sdp->sd_max_height + RES_DATA;
-
-	error = gfs2_inplace_reserve(ip);
-	if (error)
-		goto out_gunlock_q;
-
-	error = gfs2_trans_begin(sdp,
-			sdp->sd_max_height + al->al_rgd->rd_length +
-			RES_JDATA + RES_DINODE + RES_STATFS + RES_QUOTA, 0);
-	if (error)
-		goto out_ipres;
-
-	error = gfs2_meta_inode_buffer(ip, &dibh);
-	if (error)
-		goto out_end_trans;
-
-	if (size > sdp->sd_sb.sb_bsize - sizeof(struct gfs2_dinode)) {
-		if (gfs2_is_stuffed(ip)) {
-			error = gfs2_unstuff_dinode(ip, NULL);
-			if (error)
-				goto out_brelse;
-		}
-	}
-
-	ip->i_disksize = size;
-	ip->i_inode.i_mtime = ip->i_inode.i_ctime = CURRENT_TIME;
-	gfs2_trans_add_bh(ip->i_gl, dibh, 1);
-	gfs2_dinode_out(ip, dibh->b_data);
-
-out_brelse:
-	brelse(dibh);
-out_end_trans:
-	gfs2_trans_end(sdp);
-out_ipres:
-	gfs2_inplace_release(ip);
-out_gunlock_q:
-	gfs2_quota_unlock(ip);
-out:
-	gfs2_alloc_put(ip);
-	return error;
-}
-
-
-/**
  * gfs2_block_truncate_page - Deal with zeroing out data for truncate
  *
  * This is partly borrowed from ext3.
  */
-static int gfs2_block_truncate_page(struct address_space *mapping)
+static int gfs2_block_truncate_page(struct address_space *mapping, loff_t from)
 {
 	struct inode *inode = mapping->host;
 	struct gfs2_inode *ip = GFS2_I(inode);
-	loff_t from = inode->i_size;
 	unsigned long index = from >> PAGE_CACHE_SHIFT;
 	unsigned offset = from & (PAGE_CACHE_SIZE-1);
 	unsigned blocksize, iblock, length, pos;
@@ -1023,9 +953,11 @@ unlock:
 	return err;
 }
 
-static int trunc_start(struct gfs2_inode *ip, u64 size)
+static int trunc_start(struct inode *inode, u64 oldsize, u64 newsize)
 {
-	struct gfs2_sbd *sdp = GFS2_SB(&ip->i_inode);
+	struct gfs2_inode *ip = GFS2_I(inode);
+	struct gfs2_sbd *sdp = GFS2_SB(inode);
+	struct address_space *mapping = inode->i_mapping;
 	struct buffer_head *dibh;
 	int journaled = gfs2_is_jdata(ip);
 	int error;
@@ -1039,31 +971,27 @@ static int trunc_start(struct gfs2_inode *ip, u64 size)
 	if (error)
 		goto out;
 
+	gfs2_trans_add_bh(ip->i_gl, dibh, 1);
+
 	if (gfs2_is_stuffed(ip)) {
-		u64 dsize = size + sizeof(struct gfs2_dinode);
-		ip->i_disksize = size;
-		ip->i_inode.i_mtime = ip->i_inode.i_ctime = CURRENT_TIME;
-		gfs2_trans_add_bh(ip->i_gl, dibh, 1);
-		gfs2_dinode_out(ip, dibh->b_data);
-		if (dsize > dibh->b_size)
-			dsize = dibh->b_size;
-		gfs2_buffer_clear_tail(dibh, dsize);
-		error = 1;
+		gfs2_buffer_clear_tail(dibh, sizeof(struct gfs2_dinode) + newsize);
 	} else {
-		if (size & (u64)(sdp->sd_sb.sb_bsize - 1))
-			error = gfs2_block_truncate_page(ip->i_inode.i_mapping);
-
-		if (!error) {
-			ip->i_disksize = size;
-			ip->i_inode.i_mtime = ip->i_inode.i_ctime = CURRENT_TIME;
-			ip->i_diskflags |= GFS2_DIF_TRUNC_IN_PROG;
-			gfs2_trans_add_bh(ip->i_gl, dibh, 1);
-			gfs2_dinode_out(ip, dibh->b_data);
+		if (newsize & (u64)(sdp->sd_sb.sb_bsize - 1)) {
+			error = gfs2_block_truncate_page(mapping, newsize);
+			if (error)
+				goto out_brelse;
 		}
+		ip->i_diskflags |= GFS2_DIF_TRUNC_IN_PROG;
 	}
 
-	brelse(dibh);
+	i_size_write(inode, newsize);
+	ip->i_disksize = newsize;
+	ip->i_inode.i_mtime = ip->i_inode.i_ctime = CURRENT_TIME;
+	gfs2_dinode_out(ip, dibh->b_data);
 
+	truncate_pagecache(inode, oldsize, newsize);
+out_brelse:
+	brelse(dibh);
 out:
 	gfs2_trans_end(sdp);
 	return error;
@@ -1143,86 +1071,149 @@ out:
 
 /**
  * do_shrink - make a file smaller
- * @ip: the inode
- * @size: the size to make the file
- * @truncator: function to truncate the last partial block
+ * @inode: the inode
+ * @oldsize: the current inode size
+ * @newsize: the size to make the file
  *
- * Called with an exclusive lock on @ip.
+ * Called with an exclusive lock on @inode. The @size must
+ * be equal to or smaller than the current inode size.
  *
  * Returns: errno
  */
 
-static int do_shrink(struct gfs2_inode *ip, u64 size)
+static int do_shrink(struct inode *inode, u64 oldsize, u64 newsize)
 {
+	struct gfs2_inode *ip = GFS2_I(inode);
 	int error;
 
-	error = trunc_start(ip, size);
+	error = trunc_start(inode, oldsize, newsize);
 	if (error < 0)
 		return error;
-	if (error > 0)
+	if (gfs2_is_stuffed(ip))
 		return 0;
 
-	error = trunc_dealloc(ip, size);
-	if (!error)
+	error = trunc_dealloc(ip, newsize);
+	if (error == 0)
 		error = trunc_end(ip);
 
 	return error;
 }
 
-static int do_touch(struct gfs2_inode *ip, u64 size)
+void gfs2_trim_blocks(struct inode *inode)
 {
-	struct gfs2_sbd *sdp = GFS2_SB(&ip->i_inode);
+	u64 size = inode->i_size;
+	int ret;
+
+	ret = do_shrink(inode, size, size);
+	WARN_ON(ret != 0);
+}
+
+/**
+ * do_grow - Touch and update inode size
+ * @inode: The inode
+ * @size: The new size
+ *
+ * This function updates the timestamps on the inode and
+ * may also increase the size of the inode. This function
+ * must not be called with @size any smaller than the current
+ * inode size.
+ *
+ * Although it is not strictly required to unstuff files here,
+ * earlier versions of GFS2 have a bug in the stuffed file reading
+ * code which will result in a buffer overrun if the size is larger
+ * than the max stuffed file size. In order to prevent this from
+ * occuring, such files are unstuffed, but in other cases we can
+ * just update the inode size directly.
+ *
+ * Returns: 0 on success, or -ve on error
+ */
+
+static int do_grow(struct inode *inode, u64 size)
+{
+	struct gfs2_inode *ip = GFS2_I(inode);
+	struct gfs2_sbd *sdp = GFS2_SB(inode);
 	struct buffer_head *dibh;
+	struct gfs2_alloc *al = NULL;
 	int error;
 
-	error = gfs2_trans_begin(sdp, RES_DINODE, 0);
+	if (gfs2_is_stuffed(ip) &&
+	    (size > (sdp->sd_sb.sb_bsize - sizeof(struct gfs2_dinode)))) {
+		al = gfs2_alloc_get(ip);
+		if (al == NULL)
+			return -ENOMEM;
+
+		error = gfs2_quota_lock_check(ip);
+		if (error)
+			goto do_grow_alloc_put;
+
+		al->al_requested = 1;
+		error = gfs2_inplace_reserve(ip);
+		if (error)
+			goto do_grow_qunlock;
+	}
+
+	error = gfs2_trans_begin(sdp, RES_DINODE + 1, 0);
 	if (error)
-		return error;
+		goto do_grow_release;
 
-	down_write(&ip->i_rw_mutex);
+	if (al) {
+		error = gfs2_unstuff_dinode(ip, NULL);
+		if (error)
+			goto do_end_trans;
+	}
 
 	error = gfs2_meta_inode_buffer(ip, &dibh);
 	if (error)
-		goto do_touch_out;
+		goto do_end_trans;
 
+	i_size_write(inode, size);
+	ip->i_disksize = size;
 	ip->i_inode.i_mtime = ip->i_inode.i_ctime = CURRENT_TIME;
 	gfs2_trans_add_bh(ip->i_gl, dibh, 1);
 	gfs2_dinode_out(ip, dibh->b_data);
 	brelse(dibh);
 
-do_touch_out:
-	up_write(&ip->i_rw_mutex);
+do_end_trans:
 	gfs2_trans_end(sdp);
+do_grow_release:
+	if (al) {
+		gfs2_inplace_release(ip);
+do_grow_qunlock:
+		gfs2_quota_unlock(ip);
+do_grow_alloc_put:
+		gfs2_alloc_put(ip);
+	}
 	return error;
 }
 
 /**
- * gfs2_truncatei - make a file a given size
- * @ip: the inode
- * @size: the size to make the file
- * @truncator: function to truncate the last partial block
+ * gfs2_setattr_size - make a file a given size
+ * @inode: the inode
+ * @newsize: the size to make the file
  *
- * The file size can grow, shrink, or stay the same size.
+ * The file size can grow, shrink, or stay the same size. This
+ * is called holding i_mutex and an exclusive glock on the inode
+ * in question.
  *
  * Returns: errno
  */
 
-int gfs2_truncatei(struct gfs2_inode *ip, u64 size)
+int gfs2_setattr_size(struct inode *inode, u64 newsize)
 {
-	int error;
+	int ret;
+	u64 oldsize;
 
-	if (gfs2_assert_warn(GFS2_SB(&ip->i_inode), S_ISREG(ip->i_inode.i_mode)))
-		return -EINVAL;
+	BUG_ON(!S_ISREG(inode->i_mode));
 
-	if (size > ip->i_disksize)
-		error = do_grow(ip, size);
-	else if (size < ip->i_disksize)
-		error = do_shrink(ip, size);
-	else
-		/* update time stamps */
-		error = do_touch(ip, size);
+	ret = inode_newsize_ok(inode, newsize);
+	if (ret)
+		return ret;
 
-	return error;
+	oldsize = inode->i_size;
+	if (newsize >= oldsize)
+		return do_grow(inode, newsize);
+
+	return do_shrink(inode, oldsize, newsize);
 }
 
 int gfs2_truncatei_resume(struct gfs2_inode *ip)
diff --git a/fs/gfs2/bmap.h b/fs/gfs2/bmap.h
index a20a521..42fea03 100644
--- a/fs/gfs2/bmap.h
+++ b/fs/gfs2/bmap.h
@@ -44,14 +44,16 @@ static inline void gfs2_write_calc_reserv(const struct gfs2_inode *ip,
 	}
 }
 
-int gfs2_unstuff_dinode(struct gfs2_inode *ip, struct page *page);
-int gfs2_block_map(struct inode *inode, sector_t lblock, struct buffer_head *bh, int create);
-int gfs2_extent_map(struct inode *inode, u64 lblock, int *new, u64 *dblock, unsigned *extlen);
-
-int gfs2_truncatei(struct gfs2_inode *ip, u64 size);
-int gfs2_truncatei_resume(struct gfs2_inode *ip);
-int gfs2_file_dealloc(struct gfs2_inode *ip);
-int gfs2_write_alloc_required(struct gfs2_inode *ip, u64 offset,
-			      unsigned int len);
+extern int gfs2_unstuff_dinode(struct gfs2_inode *ip, struct page *page);
+extern int gfs2_block_map(struct inode *inode, sector_t lblock,
+			  struct buffer_head *bh, int create);
+extern int gfs2_extent_map(struct inode *inode, u64 lblock, int *new,
+			   u64 *dblock, unsigned *extlen);
+extern int gfs2_setattr_size(struct inode *inode, u64 size);
+extern void gfs2_trim_blocks(struct inode *inode);
+extern int gfs2_truncatei_resume(struct gfs2_inode *ip);
+extern int gfs2_file_dealloc(struct gfs2_inode *ip);
+extern int gfs2_write_alloc_required(struct gfs2_inode *ip, u64 offset,
+				     unsigned int len);
 
 #endif /* __BMAP_DOT_H__ */
diff --git a/fs/gfs2/ops_inode.c b/fs/gfs2/ops_inode.c
index 1009be2..1d3f2fb 100644
--- a/fs/gfs2/ops_inode.c
+++ b/fs/gfs2/ops_inode.c
@@ -1071,30 +1071,6 @@ int gfs2_permission(struct inode *inode, int mask)
 	return error;
 }
 
-/*
- * XXX(truncate): the truncate_setsize calls should be moved to the end.
- */
-static int setattr_size(struct inode *inode, struct iattr *attr)
-{
-	struct gfs2_inode *ip = GFS2_I(inode);
-	struct gfs2_sbd *sdp = GFS2_SB(inode);
-	int error;
-
-	if (attr->ia_size != ip->i_disksize) {
-		error = gfs2_trans_begin(sdp, 0, sdp->sd_jdesc->jd_blocks);
-		if (error)
-			return error;
-		truncate_setsize(inode, attr->ia_size);
-		gfs2_trans_end(sdp);
-	}
-
-	error = gfs2_truncatei(ip, attr->ia_size);
-	if (error && (inode->i_size != ip->i_disksize))
-		i_size_write(inode, ip->i_disksize);
-
-	return error;
-}
-
 static int setattr_chown(struct inode *inode, struct iattr *attr)
 {
 	struct gfs2_inode *ip = GFS2_I(inode);
@@ -1195,7 +1171,7 @@ static int gfs2_setattr(struct dentry *dentry, struct iattr *attr)
 		goto out;
 
 	if (attr->ia_valid & ATTR_SIZE)
-		error = setattr_size(inode, attr);
+		error = gfs2_setattr_size(inode, attr->ia_size);
 	else if (attr->ia_valid & (ATTR_UID | ATTR_GID))
 		error = setattr_chown(inode, attr);
 	else if ((attr->ia_valid & ATTR_MODE) && IS_POSIXACL(inode))
-- 
1.7.1.1

