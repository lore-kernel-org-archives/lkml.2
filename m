Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966217Ab2EQMtr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 08:49:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63286 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965794Ab2EQMs6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 08:48:58 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Bob Peterson <rpeterso@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 22/24] GFS2: Eliminate unused "new" parameter to gfs2_meta_indirect_buffer
Date: Thu, 17 May 2012 13:23:29 +0100
Message-Id: <1337257411-3173-23-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1337257411-3173-1-git-send-email-swhiteho@redhat.com>
References: <1337257411-3173-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

It turns out that the "new" parameter to function gfs2_meta_indirect_buffer
was always being passed in as zero. Therefore, this patch eliminates it
and simplifies the function.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/bmap.c b/fs/gfs2/bmap.c
index 420bbeb..dab5409 100644
--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -324,7 +324,7 @@ static int lookup_metapath(struct gfs2_inode *ip, struct metapath *mp)
 		if (!dblock)
 			return x + 1;
 
-		ret = gfs2_meta_indirect_buffer(ip, x+1, dblock, 0, &mp->mp_bh[x+1]);
+		ret = gfs2_meta_indirect_buffer(ip, x+1, dblock, &mp->mp_bh[x+1]);
 		if (ret)
 			return ret;
 	}
@@ -882,7 +882,7 @@ static int recursive_scan(struct gfs2_inode *ip, struct buffer_head *dibh,
 		top = (__be64 *)(bh->b_data + sizeof(struct gfs2_dinode)) + mp->mp_list[0];
 		bottom = (__be64 *)(bh->b_data + sizeof(struct gfs2_dinode)) + sdp->sd_diptrs;
 	} else {
-		error = gfs2_meta_indirect_buffer(ip, height, block, 0, &bh);
+		error = gfs2_meta_indirect_buffer(ip, height, block, &bh);
 		if (error)
 			return error;
 
diff --git a/fs/gfs2/meta_io.c b/fs/gfs2/meta_io.c
index 7f69ae2..6c1e5d1 100644
--- a/fs/gfs2/meta_io.c
+++ b/fs/gfs2/meta_io.c
@@ -374,33 +374,24 @@ void gfs2_meta_wipe(struct gfs2_inode *ip, u64 bstart, u32 blen)
  * @ip: The GFS2 inode
  * @height: The level of this buf in the metadata (indir addr) tree (if any)
  * @num: The block number (device relative) of the buffer
- * @new: Non-zero if we may create a new buffer
  * @bhp: the buffer is returned here
  *
  * Returns: errno
  */
 
 int gfs2_meta_indirect_buffer(struct gfs2_inode *ip, int height, u64 num,
-			      int new, struct buffer_head **bhp)
+			      struct buffer_head **bhp)
 {
 	struct gfs2_sbd *sdp = GFS2_SB(&ip->i_inode);
 	struct gfs2_glock *gl = ip->i_gl;
 	struct buffer_head *bh;
 	int ret = 0;
+	u32 mtype = height ? GFS2_METATYPE_IN : GFS2_METATYPE_DI;
 
-	if (new) {
-		BUG_ON(height == 0);
-		bh = gfs2_meta_new(gl, num);
-		gfs2_trans_add_bh(ip->i_gl, bh, 1);
-		gfs2_metatype_set(bh, GFS2_METATYPE_IN, GFS2_FORMAT_IN);
-		gfs2_buffer_clear_tail(bh, sizeof(struct gfs2_meta_header));
-	} else {
-		u32 mtype = height ? GFS2_METATYPE_IN : GFS2_METATYPE_DI;
-		ret = gfs2_meta_read(gl, num, DIO_WAIT, &bh);
-		if (ret == 0 && gfs2_metatype_check(sdp, bh, mtype)) {
-			brelse(bh);
-			ret = -EIO;
-		}
+	ret = gfs2_meta_read(gl, num, DIO_WAIT, &bh);
+	if (ret == 0 && gfs2_metatype_check(sdp, bh, mtype)) {
+		brelse(bh);
+		ret = -EIO;
 	}
 	*bhp = bh;
 	return ret;
diff --git a/fs/gfs2/meta_io.h b/fs/gfs2/meta_io.h
index 22c5265..c30973b 100644
--- a/fs/gfs2/meta_io.h
+++ b/fs/gfs2/meta_io.h
@@ -65,12 +65,12 @@ void gfs2_remove_from_journal(struct buffer_head *bh, struct gfs2_trans *tr,
 void gfs2_meta_wipe(struct gfs2_inode *ip, u64 bstart, u32 blen);
 
 int gfs2_meta_indirect_buffer(struct gfs2_inode *ip, int height, u64 num,
-			      int new, struct buffer_head **bhp);
+			      struct buffer_head **bhp);
 
 static inline int gfs2_meta_inode_buffer(struct gfs2_inode *ip,
 					 struct buffer_head **bhp)
 {
-	return gfs2_meta_indirect_buffer(ip, 0, ip->i_no_addr, 0, bhp);
+	return gfs2_meta_indirect_buffer(ip, 0, ip->i_no_addr, bhp);
 }
 
 struct buffer_head *gfs2_meta_ra(struct gfs2_glock *gl, u64 dblock, u32 extlen);
-- 
1.7.4

