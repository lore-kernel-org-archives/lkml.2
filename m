Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932437Ab1JXMuW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 08:50:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23474 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932399Ab1JXMrr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 08:47:47 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 15/24] GFS2: Use cached rgrp in gfs2_rlist_add()
Date: Mon, 24 Oct 2011 13:48:29 +0100
Message-Id: <1319460518-9046-16-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1319460518-9046-1-git-send-email-swhiteho@redhat.com>
References: <1319460518-9046-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Each block which is deallocated, requires a call to gfs2_rlist_add()
and each of those calls was calling gfs2_blk2rgrpd() in order to
figure out which rgrp the block belonged in. This can be speeded up
by making use of the rgrp cached in the inode. We also reset this
cached rgrp in case the block has changed rgrp. This should provide
a big reduction in gfs2_blk2rgrpd() calls during deallocation.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/bmap.c b/fs/gfs2/bmap.c
index 9d3a0c2..22ad413 100644
--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -724,7 +724,7 @@ static int do_strip(struct gfs2_inode *ip, struct buffer_head *dibh,
 			blen++;
 		else {
 			if (bstart)
-				gfs2_rlist_add(sdp, &rlist, bstart);
+				gfs2_rlist_add(ip, &rlist, bstart);
 
 			bstart = bn;
 			blen = 1;
@@ -732,7 +732,7 @@ static int do_strip(struct gfs2_inode *ip, struct buffer_head *dibh,
 	}
 
 	if (bstart)
-		gfs2_rlist_add(sdp, &rlist, bstart);
+		gfs2_rlist_add(ip, &rlist, bstart);
 	else
 		goto out; /* Nothing to do */
 
diff --git a/fs/gfs2/dir.c b/fs/gfs2/dir.c
index 90b877b..8ccad24 100644
--- a/fs/gfs2/dir.c
+++ b/fs/gfs2/dir.c
@@ -1821,7 +1821,7 @@ static int leaf_dealloc(struct gfs2_inode *dip, u32 index, u32 len,
 		if (blk != leaf_no)
 			brelse(bh);
 
-		gfs2_rlist_add(sdp, &rlist, blk);
+		gfs2_rlist_add(dip, &rlist, blk);
 		l_blocks++;
 	}
 
diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index 08b3a80..3088fb2 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -1560,7 +1560,7 @@ fail:
 
 /**
  * gfs2_rlist_add - add a RG to a list of RGs
- * @sdp: the filesystem
+ * @ip: the inode
  * @rlist: the list of resource groups
  * @block: the block
  *
@@ -1570,9 +1570,10 @@ fail:
  *
  */
 
-void gfs2_rlist_add(struct gfs2_sbd *sdp, struct gfs2_rgrp_list *rlist,
+void gfs2_rlist_add(struct gfs2_inode *ip, struct gfs2_rgrp_list *rlist,
 		    u64 block)
 {
+	struct gfs2_sbd *sdp = GFS2_SB(&ip->i_inode);
 	struct gfs2_rgrpd *rgd;
 	struct gfs2_rgrpd **tmp;
 	unsigned int new_space;
@@ -1581,12 +1582,15 @@ void gfs2_rlist_add(struct gfs2_sbd *sdp, struct gfs2_rgrp_list *rlist,
 	if (gfs2_assert_warn(sdp, !rlist->rl_ghs))
 		return;
 
-	rgd = gfs2_blk2rgrpd(sdp, block);
+	if (ip->i_rgd && rgrp_contains_block(ip->i_rgd, block))
+		rgd = ip->i_rgd;
+	else
+		rgd = gfs2_blk2rgrpd(sdp, block);
 	if (!rgd) {
-		if (gfs2_consist(sdp))
-			fs_err(sdp, "block = %llu\n", (unsigned long long)block);
+		fs_err(sdp, "rlist_add: no rgrp for block %llu\n", (unsigned long long)block);
 		return;
 	}
+	ip->i_rgd = rgd;
 
 	for (x = 0; x < rlist->rl_rgrps; x++)
 		if (rlist->rl_rgd[x] == rgd)
diff --git a/fs/gfs2/rgrp.h b/fs/gfs2/rgrp.h
index 0439fca..0e886d8 100644
--- a/fs/gfs2/rgrp.h
+++ b/fs/gfs2/rgrp.h
@@ -60,7 +60,7 @@ struct gfs2_rgrp_list {
 	struct gfs2_holder *rl_ghs;
 };
 
-extern void gfs2_rlist_add(struct gfs2_sbd *sdp, struct gfs2_rgrp_list *rlist,
+extern void gfs2_rlist_add(struct gfs2_inode *ip, struct gfs2_rgrp_list *rlist,
 			   u64 block);
 extern void gfs2_rlist_alloc(struct gfs2_rgrp_list *rlist, unsigned int state);
 extern void gfs2_rlist_free(struct gfs2_rgrp_list *rlist);
diff --git a/fs/gfs2/xattr.c b/fs/gfs2/xattr.c
index e7bf0ea..71d7bf8 100644
--- a/fs/gfs2/xattr.c
+++ b/fs/gfs2/xattr.c
@@ -1356,14 +1356,14 @@ static int ea_dealloc_indirect(struct gfs2_inode *ip)
 			blen++;
 		else {
 			if (bstart)
-				gfs2_rlist_add(sdp, &rlist, bstart);
+				gfs2_rlist_add(ip, &rlist, bstart);
 			bstart = bn;
 			blen = 1;
 		}
 		blks++;
 	}
 	if (bstart)
-		gfs2_rlist_add(sdp, &rlist, bstart);
+		gfs2_rlist_add(ip, &rlist, bstart);
 	else
 		goto out;
 
-- 
1.7.4.4

