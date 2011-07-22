Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753679Ab1GVJj4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 05:39:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15754 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753612Ab1GVJjq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 05:39:46 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Eric Sandeen <sandeen@redhat.com>, Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 4/4] GFS2: combine duplicated block freeing routines
Date: Fri, 22 Jul 2011 10:16:54 +0100
Message-Id: <1311326214-3325-5-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1311326214-3325-1-git-send-email-swhiteho@redhat.com>
References: <1311326214-3325-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Sandeen <sandeen@redhat.com>

__gfs2_free_data and __gfs2_free_meta are almost identical, and
can be trivially combined.

[This is as per Eric's original patch minus gfs2_free_data() which had
 no callers left and plus the conversion of the bmap.c calls to these
 functions. All in all, a nice clean up]

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/bmap.c b/fs/gfs2/bmap.c
index e65493a..42e477f 100644
--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -854,11 +854,7 @@ static int do_strip(struct gfs2_inode *ip, struct buffer_head *dibh,
 			blen++;
 		else {
 			if (bstart) {
-				if (metadata)
-					__gfs2_free_meta(ip, bstart, blen);
-				else
-					__gfs2_free_data(ip, bstart, blen);
-
+				__gfs2_free_blocks(ip, bstart, blen, metadata);
 				btotal += blen;
 			}
 
@@ -870,11 +866,7 @@ static int do_strip(struct gfs2_inode *ip, struct buffer_head *dibh,
 		gfs2_add_inode_blocks(&ip->i_inode, -1);
 	}
 	if (bstart) {
-		if (metadata)
-			__gfs2_free_meta(ip, bstart, blen);
-		else
-			__gfs2_free_data(ip, bstart, blen);
-
+		__gfs2_free_blocks(ip, bstart, blen, metadata);
 		btotal += blen;
 	}
 
diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index 9b780df..7f8af1e 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -1607,14 +1607,15 @@ rgrp_error:
 }
 
 /**
- * gfs2_free_data - free a contiguous run of data block(s)
+ * __gfs2_free_blocks - free a contiguous run of block(s)
  * @ip: the inode these blocks are being freed from
  * @bstart: first block of a run of contiguous blocks
  * @blen: the length of the block run
+ * @meta: 1 if the blocks represent metadata
  *
  */
 
-void __gfs2_free_data(struct gfs2_inode *ip, u64 bstart, u32 blen)
+void __gfs2_free_blocks(struct gfs2_inode *ip, u64 bstart, u32 blen, int meta)
 {
 	struct gfs2_sbd *sdp = GFS2_SB(&ip->i_inode);
 	struct gfs2_rgrpd *rgd;
@@ -1631,54 +1632,11 @@ void __gfs2_free_data(struct gfs2_inode *ip, u64 bstart, u32 blen)
 	gfs2_trans_add_rg(rgd);
 
 	/* Directories keep their data in the metadata address space */
-	if (ip->i_depth)
+	if (meta || ip->i_depth)
 		gfs2_meta_wipe(ip, bstart, blen);
 }
 
 /**
- * gfs2_free_data - free a contiguous run of data block(s)
- * @ip: the inode these blocks are being freed from
- * @bstart: first block of a run of contiguous blocks
- * @blen: the length of the block run
- *
- */
-
-void gfs2_free_data(struct gfs2_inode *ip, u64 bstart, u32 blen)
-{
-	struct gfs2_sbd *sdp = GFS2_SB(&ip->i_inode);
-
-	__gfs2_free_data(ip, bstart, blen);
-	gfs2_statfs_change(sdp, 0, +blen, 0);
-	gfs2_quota_change(ip, -(s64)blen, ip->i_inode.i_uid, ip->i_inode.i_gid);
-}
-
-/**
- * gfs2_free_meta - free a contiguous run of data block(s)
- * @ip: the inode these blocks are being freed from
- * @bstart: first block of a run of contiguous blocks
- * @blen: the length of the block run
- *
- */
-
-void __gfs2_free_meta(struct gfs2_inode *ip, u64 bstart, u32 blen)
-{
-	struct gfs2_sbd *sdp = GFS2_SB(&ip->i_inode);
-	struct gfs2_rgrpd *rgd;
-
-	rgd = rgblk_free(sdp, bstart, blen, GFS2_BLKST_FREE);
-	if (!rgd)
-		return;
-	trace_gfs2_block_alloc(ip, bstart, blen, GFS2_BLKST_FREE);
-	rgd->rd_free += blen;
-
-	gfs2_trans_add_bh(rgd->rd_gl, rgd->rd_bits[0].bi_bh, 1);
-	gfs2_rgrp_out(rgd, rgd->rd_bits[0].bi_bh->b_data);
-
-	gfs2_trans_add_rg(rgd);
-	gfs2_meta_wipe(ip, bstart, blen);
-}
-
-/**
  * gfs2_free_meta - free a contiguous run of data block(s)
  * @ip: the inode these blocks are being freed from
  * @bstart: first block of a run of contiguous blocks
@@ -1690,7 +1648,7 @@ void gfs2_free_meta(struct gfs2_inode *ip, u64 bstart, u32 blen)
 {
 	struct gfs2_sbd *sdp = GFS2_SB(&ip->i_inode);
 
-	__gfs2_free_meta(ip, bstart, blen);
+	__gfs2_free_blocks(ip, bstart, blen, 1);
 	gfs2_statfs_change(sdp, 0, +blen, 0);
 	gfs2_quota_change(ip, -(s64)blen, ip->i_inode.i_uid, ip->i_inode.i_gid);
 }
diff --git a/fs/gfs2/rgrp.h b/fs/gfs2/rgrp.h
index a80e303..d253f9a 100644
--- a/fs/gfs2/rgrp.h
+++ b/fs/gfs2/rgrp.h
@@ -52,9 +52,7 @@ extern int gfs2_ri_update(struct gfs2_inode *ip);
 extern int gfs2_alloc_block(struct gfs2_inode *ip, u64 *bn, unsigned int *n);
 extern int gfs2_alloc_di(struct gfs2_inode *ip, u64 *bn, u64 *generation);
 
-extern void __gfs2_free_data(struct gfs2_inode *ip, u64 bstart, u32 blen);
-extern void gfs2_free_data(struct gfs2_inode *ip, u64 bstart, u32 blen);
-extern void __gfs2_free_meta(struct gfs2_inode *ip, u64 bstart, u32 blen);
+extern void __gfs2_free_blocks(struct gfs2_inode *ip, u64 bstart, u32 blen, int meta);
 extern void gfs2_free_meta(struct gfs2_inode *ip, u64 bstart, u32 blen);
 extern void gfs2_free_di(struct gfs2_rgrpd *rgd, struct gfs2_inode *ip);
 extern void gfs2_unlink_di(struct inode *inode);
-- 
1.7.4

