Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753529Ab0HBJtN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 05:49:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45740 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753316Ab0HBJtK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 05:49:10 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Bob Peterson <rpeterso@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 3/8] GFS2: Simplify gfs2_write_alloc_required
Date: Mon,  2 Aug 2010 10:27:54 +0100
Message-Id: <1280741279-6782-4-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1280741279-6782-1-git-send-email-swhiteho@redhat.com>
References: <1280741279-6782-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

Function gfs2_write_alloc_required always returned zero as its
return code.  Therefore, it doesn't need to return a return code
at all.  Given that, we can use the return value to return whether
or not the dinode needs block allocations rather than passing
that value in, which in turn simplifies a bunch of error checking.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/aops.c b/fs/gfs2/aops.c
index 9485a88..5e96cbd 100644
--- a/fs/gfs2/aops.c
+++ b/fs/gfs2/aops.c
@@ -634,9 +634,7 @@ static int gfs2_write_begin(struct file *file, struct address_space *mapping,
 		}
 	}
 
-	error = gfs2_write_alloc_required(ip, pos, len, &alloc_required);
-	if (error)
-		goto out_unlock;
+	alloc_required = gfs2_write_alloc_required(ip, pos, len);
 
 	if (alloc_required || gfs2_is_jdata(ip))
 		gfs2_write_calc_reserv(ip, len, &data_blocks, &ind_blocks);
diff --git a/fs/gfs2/bmap.c b/fs/gfs2/bmap.c
index 84da64b..744c29e 100644
--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -1244,13 +1244,12 @@ int gfs2_file_dealloc(struct gfs2_inode *ip)
  * @ip: the file being written to
  * @offset: the offset to write to
  * @len: the number of bytes being written
- * @alloc_required: set to 1 if an alloc is required, 0 otherwise
  *
- * Returns: errno
+ * Returns: 1 if an alloc is required, 0 otherwise
  */
 
 int gfs2_write_alloc_required(struct gfs2_inode *ip, u64 offset,
-			      unsigned int len, int *alloc_required)
+			      unsigned int len)
 {
 	struct gfs2_sbd *sdp = GFS2_SB(&ip->i_inode);
 	struct buffer_head bh;
@@ -1258,26 +1257,23 @@ int gfs2_write_alloc_required(struct gfs2_inode *ip, u64 offset,
 	u64 lblock, lblock_stop, size;
 	u64 end_of_file;
 
-	*alloc_required = 0;
-
 	if (!len)
 		return 0;
 
 	if (gfs2_is_stuffed(ip)) {
 		if (offset + len >
 		    sdp->sd_sb.sb_bsize - sizeof(struct gfs2_dinode))
-			*alloc_required = 1;
+			return 1;
 		return 0;
 	}
 
-	*alloc_required = 1;
 	shift = sdp->sd_sb.sb_bsize_shift;
 	BUG_ON(gfs2_is_dir(ip));
 	end_of_file = (ip->i_disksize + sdp->sd_sb.sb_bsize - 1) >> shift;
 	lblock = offset >> shift;
 	lblock_stop = (offset + len + sdp->sd_sb.sb_bsize - 1) >> shift;
 	if (lblock_stop > end_of_file)
-		return 0;
+		return 1;
 
 	size = (lblock_stop - lblock) << shift;
 	do {
@@ -1285,12 +1281,11 @@ int gfs2_write_alloc_required(struct gfs2_inode *ip, u64 offset,
 		bh.b_size = size;
 		gfs2_block_map(&ip->i_inode, lblock, &bh, 0);
 		if (!buffer_mapped(&bh))
-			return 0;
+			return 1;
 		size -= bh.b_size;
 		lblock += (bh.b_size >> ip->i_inode.i_blkbits);
 	} while(size > 0);
 
-	*alloc_required = 0;
 	return 0;
 }
 
diff --git a/fs/gfs2/bmap.h b/fs/gfs2/bmap.h
index c983177..a20a521 100644
--- a/fs/gfs2/bmap.h
+++ b/fs/gfs2/bmap.h
@@ -52,6 +52,6 @@ int gfs2_truncatei(struct gfs2_inode *ip, u64 size);
 int gfs2_truncatei_resume(struct gfs2_inode *ip);
 int gfs2_file_dealloc(struct gfs2_inode *ip);
 int gfs2_write_alloc_required(struct gfs2_inode *ip, u64 offset,
-			      unsigned int len, int *alloc_required);
+			      unsigned int len);
 
 #endif /* __BMAP_DOT_H__ */
diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
index ed9a94f..4edd662 100644
--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -351,7 +351,6 @@ static int gfs2_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 	unsigned long last_index;
 	u64 pos = page->index << PAGE_CACHE_SHIFT;
 	unsigned int data_blocks, ind_blocks, rblocks;
-	int alloc_required = 0;
 	struct gfs2_holder gh;
 	struct gfs2_alloc *al;
 	int ret;
@@ -364,8 +363,7 @@ static int gfs2_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 	set_bit(GLF_DIRTY, &ip->i_gl->gl_flags);
 	set_bit(GIF_SW_PAGED, &ip->i_flags);
 
-	ret = gfs2_write_alloc_required(ip, pos, PAGE_CACHE_SIZE, &alloc_required);
-	if (ret || !alloc_required)
+	if (!gfs2_write_alloc_required(ip, pos, PAGE_CACHE_SIZE))
 		goto out_unlock;
 	ret = -ENOMEM;
 	al = gfs2_alloc_get(ip);
diff --git a/fs/gfs2/quota.c b/fs/gfs2/quota.c
index 8f02d3d..8bb643c 100644
--- a/fs/gfs2/quota.c
+++ b/fs/gfs2/quota.c
@@ -787,15 +787,9 @@ static int do_sync(unsigned int num_qd, struct gfs2_quota_data **qda)
 		goto out;
 
 	for (x = 0; x < num_qd; x++) {
-		int alloc_required;
-
 		offset = qd2offset(qda[x]);
-		error = gfs2_write_alloc_required(ip, offset,
-						  sizeof(struct gfs2_quota),
-						  &alloc_required);
-		if (error)
-			goto out_gunlock;
-		if (alloc_required)
+		if (gfs2_write_alloc_required(ip, offset,
+					      sizeof(struct gfs2_quota)))
 			nalloc++;
 	}
 
@@ -1584,10 +1578,7 @@ static int gfs2_set_dqblk(struct super_block *sb, int type, qid_t id,
 		goto out_i;
 
 	offset = qd2offset(qd);
-	error = gfs2_write_alloc_required(ip, offset, sizeof(struct gfs2_quota),
-					  &alloc_required);
-	if (error)
-		goto out_i;
+	alloc_required = gfs2_write_alloc_required(ip, offset, sizeof(struct gfs2_quota));
 	if (alloc_required) {
 		al = gfs2_alloc_get(ip);
 		if (al == NULL)
diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index 4d1aad3..4140811 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -342,8 +342,6 @@ int gfs2_jdesc_check(struct gfs2_jdesc *jd)
 {
 	struct gfs2_inode *ip = GFS2_I(jd->jd_inode);
 	struct gfs2_sbd *sdp = GFS2_SB(jd->jd_inode);
-	int ar;
-	int error;
 
 	if (ip->i_disksize < (8 << 20) || ip->i_disksize > (1 << 30) ||
 	    (ip->i_disksize & (sdp->sd_sb.sb_bsize - 1))) {
@@ -352,13 +350,12 @@ int gfs2_jdesc_check(struct gfs2_jdesc *jd)
 	}
 	jd->jd_blocks = ip->i_disksize >> sdp->sd_sb.sb_bsize_shift;
 
-	error = gfs2_write_alloc_required(ip, 0, ip->i_disksize, &ar);
-	if (!error && ar) {
+	if (gfs2_write_alloc_required(ip, 0, ip->i_disksize)) {
 		gfs2_consist_inode(ip);
-		error = -EIO;
+		return -EIO;
 	}
 
-	return error;
+	return 0;
 }
 
 /**
-- 
1.7.1.1

