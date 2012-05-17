Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966186Ab2EQMt1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 08:49:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52784 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965864Ab2EQMs7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 08:48:59 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Bob Peterson <rpeterso@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 23/24] GFS2: Add rgrp information to block_alloc trace point
Date: Thu, 17 May 2012 13:23:30 +0100
Message-Id: <1337257411-3173-24-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1337257411-3173-1-git-send-email-swhiteho@redhat.com>
References: <1337257411-3173-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

This is a second attempt at a patch that adds rgrp information to the
block allocation trace point for GFS2. As suggested, the patch was
modified to list the rgrp information _after_ the fields that exist today.

Again, the reason for this patch is to allow us to trace and debug
problems with the block reservations patch, which is still in the works.
We can debug problems with reservations if we can see what block allocations
result from the block reservations. It may also be handy in figuring out
if there are problems in rgrp free space accounting. In other words,
we can use it to track the rgrp and its free space along side the allocations
that are taking place.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index 645c16f..f74fb9b 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -1556,7 +1556,7 @@ int gfs2_alloc_blocks(struct gfs2_inode *ip, u64 *bn, unsigned int *nblocks,
 				  ip->i_inode.i_gid);
 
 	rgd->rd_free_clone -= *nblocks;
-	trace_gfs2_block_alloc(ip, block, *nblocks,
+	trace_gfs2_block_alloc(ip, rgd, block, *nblocks,
 			       dinode ? GFS2_BLKST_DINODE : GFS2_BLKST_USED);
 	*bn = block;
 	return 0;
@@ -1583,7 +1583,7 @@ void __gfs2_free_blocks(struct gfs2_inode *ip, u64 bstart, u32 blen, int meta)
 	rgd = rgblk_free(sdp, bstart, blen, GFS2_BLKST_FREE);
 	if (!rgd)
 		return;
-	trace_gfs2_block_alloc(ip, bstart, blen, GFS2_BLKST_FREE);
+	trace_gfs2_block_alloc(ip, rgd, bstart, blen, GFS2_BLKST_FREE);
 	rgd->rd_free += blen;
 	rgd->rd_flags &= ~GFS2_RGF_TRIMMED;
 	gfs2_trans_add_bh(rgd->rd_gl, rgd->rd_bits[0].bi_bh, 1);
@@ -1621,7 +1621,7 @@ void gfs2_unlink_di(struct inode *inode)
 	rgd = rgblk_free(sdp, blkno, 1, GFS2_BLKST_UNLINKED);
 	if (!rgd)
 		return;
-	trace_gfs2_block_alloc(ip, blkno, 1, GFS2_BLKST_UNLINKED);
+	trace_gfs2_block_alloc(ip, rgd, blkno, 1, GFS2_BLKST_UNLINKED);
 	gfs2_trans_add_bh(rgd->rd_gl, rgd->rd_bits[0].bi_bh, 1);
 	gfs2_rgrp_out(rgd, rgd->rd_bits[0].bi_bh->b_data);
 }
@@ -1651,7 +1651,7 @@ static void gfs2_free_uninit_di(struct gfs2_rgrpd *rgd, u64 blkno)
 void gfs2_free_di(struct gfs2_rgrpd *rgd, struct gfs2_inode *ip)
 {
 	gfs2_free_uninit_di(rgd, ip->i_no_addr);
-	trace_gfs2_block_alloc(ip, ip->i_no_addr, 1, GFS2_BLKST_FREE);
+	trace_gfs2_block_alloc(ip, rgd, ip->i_no_addr, 1, GFS2_BLKST_FREE);
 	gfs2_quota_change(ip, -1, ip->i_inode.i_uid, ip->i_inode.i_gid);
 	gfs2_meta_wipe(ip, ip->i_no_addr, 1);
 }
diff --git a/fs/gfs2/trace_gfs2.h b/fs/gfs2/trace_gfs2.h
index dfa89cd..1b8b815 100644
--- a/fs/gfs2/trace_gfs2.h
+++ b/fs/gfs2/trace_gfs2.h
@@ -457,10 +457,10 @@ TRACE_EVENT(gfs2_bmap,
 /* Keep track of blocks as they are allocated/freed */
 TRACE_EVENT(gfs2_block_alloc,
 
-	TP_PROTO(const struct gfs2_inode *ip, u64 block, unsigned len,
-		u8 block_state),
+	TP_PROTO(const struct gfs2_inode *ip, struct gfs2_rgrpd *rgd,
+		 u64 block, unsigned len, u8 block_state),
 
-	TP_ARGS(ip, block, len, block_state),
+	TP_ARGS(ip, rgd, block, len, block_state),
 
 	TP_STRUCT__entry(
 		__field(        dev_t,  dev                     )
@@ -468,6 +468,8 @@ TRACE_EVENT(gfs2_block_alloc,
 		__field(	u64,	inum			)
 		__field(	u32,	len			)
 		__field(	u8,	block_state		)
+		__field(        u64,	rd_addr			)
+		__field(        u32,	rd_free_clone		)
 	),
 
 	TP_fast_assign(
@@ -476,14 +478,18 @@ TRACE_EVENT(gfs2_block_alloc,
 		__entry->inum		= ip->i_no_addr;
 		__entry->len		= len;
 		__entry->block_state	= block_state;
+		__entry->rd_addr	= rgd->rd_addr;
+		__entry->rd_free_clone	= rgd->rd_free_clone;
 	),
 
-	TP_printk("%u,%u bmap %llu alloc %llu/%lu %s",
+	TP_printk("%u,%u bmap %llu alloc %llu/%lu %s rg:%llu rf:%u",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  (unsigned long long)__entry->inum,
 		  (unsigned long long)__entry->start,
 		  (unsigned long)__entry->len,
-		  block_state_name(__entry->block_state))
+		  block_state_name(__entry->block_state),
+		  (unsigned long long)__entry->rd_addr,
+		  __entry->rd_free_clone)
 );
 
 #endif /* _TRACE_GFS2_H */
-- 
1.7.4

