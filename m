Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756485Ab0JROjO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 10:39:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56690 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932335Ab0JROht (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 10:37:49 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Benjamin Marzinski <bmarzins@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 15/22] GFS2: reserve more blocks for transactions
Date: Mon, 18 Oct 2010 15:15:39 +0100
Message-Id: <1287411346-17855-16-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1287411346-17855-1-git-send-email-swhiteho@redhat.com>
References: <1287411346-17855-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Marzinski <bmarzins@redhat.com>

Some of the functions in GFS2 were not reserving space in the transaction for
the resource group header and the resource groups bitblocks that get added
when you do allocation. GFS2 now makes sure to reserve space for the
resource group header and either all the bitblocks in the resource group, or
one for each block that it may allocate, whichever is smaller using the new
gfs2_rg_blocks() inline function.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/aops.c b/fs/gfs2/aops.c
index 180ef8a..1bf1788 100644
--- a/fs/gfs2/aops.c
+++ b/fs/gfs2/aops.c
@@ -663,6 +663,8 @@ static int gfs2_write_begin(struct file *file, struct address_space *mapping,
 		rblocks += RES_STATFS + RES_QUOTA;
 	if (&ip->i_inode == sdp->sd_rindex)
 		rblocks += 2 * RES_STATFS;
+	if (alloc_required)
+		rblocks += gfs2_rg_blocks(al);
 
 	error = gfs2_trans_begin(sdp, rblocks,
 				 PAGE_CACHE_SIZE/sdp->sd_sb.sb_bsize);
diff --git a/fs/gfs2/bmap.c b/fs/gfs2/bmap.c
index 04513e9..5476c06 100644
--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -1151,7 +1151,7 @@ static int do_grow(struct inode *inode, u64 size)
 			goto do_grow_qunlock;
 	}
 
-	error = gfs2_trans_begin(sdp, RES_DINODE + 1, 0);
+	error = gfs2_trans_begin(sdp, RES_DINODE + RES_STATFS + RES_RG_BIT, 0);
 	if (error)
 		goto do_grow_release;
 
diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
index daadcd2..237ee6a 100644
--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -382,8 +382,10 @@ static int gfs2_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 	rblocks = RES_DINODE + ind_blocks;
 	if (gfs2_is_jdata(ip))
 		rblocks += data_blocks ? data_blocks : 1;
-	if (ind_blocks || data_blocks)
+	if (ind_blocks || data_blocks) {
 		rblocks += RES_STATFS + RES_QUOTA;
+		rblocks += gfs2_rg_blocks(al);
+	}
 	ret = gfs2_trans_begin(sdp, rblocks, 0);
 	if (ret)
 		goto out_trans_fail;
diff --git a/fs/gfs2/ops_inode.c b/fs/gfs2/ops_inode.c
index 98a94cf..fba0017 100644
--- a/fs/gfs2/ops_inode.c
+++ b/fs/gfs2/ops_inode.c
@@ -219,7 +219,7 @@ static int gfs2_link(struct dentry *old_dentry, struct inode *dir,
 			goto out_gunlock_q;
 
 		error = gfs2_trans_begin(sdp, sdp->sd_max_dirres +
-					 al->al_rgd->rd_length +
+					 gfs2_rg_blocks(al) +
 					 2 * RES_DINODE + RES_STATFS +
 					 RES_QUOTA, 0);
 		if (error)
@@ -884,7 +884,7 @@ static int gfs2_rename(struct inode *odir, struct dentry *odentry,
 			goto out_gunlock_q;
 
 		error = gfs2_trans_begin(sdp, sdp->sd_max_dirres +
-					 al->al_rgd->rd_length +
+					 gfs2_rg_blocks(al) +
 					 4 * RES_DINODE + 4 * RES_LEAF +
 					 RES_STATFS + RES_QUOTA + 4, 0);
 		if (error)
@@ -1481,7 +1481,7 @@ retry:
 		al->al_requested = data_blocks + ind_blocks;
 
 		rblocks = RES_DINODE + ind_blocks + RES_STATFS + RES_QUOTA +
-			  RES_RG_HDR + ip->i_alloc->al_rgd->rd_length;
+			  RES_RG_HDR + gfs2_rg_blocks(al);
 		if (gfs2_is_jdata(ip))
 			rblocks += data_blocks ? data_blocks : 1;
 
diff --git a/fs/gfs2/quota.c b/fs/gfs2/quota.c
index 9bc6dd9..58a9b99 100644
--- a/fs/gfs2/quota.c
+++ b/fs/gfs2/quota.c
@@ -815,7 +815,7 @@ static int do_sync(unsigned int num_qd, struct gfs2_quota_data **qda)
 		goto out_alloc;
 
 	if (nalloc)
-		blocks += al->al_rgd->rd_length + nalloc * ind_blocks + RES_STATFS;
+		blocks += gfs2_rg_blocks(al) + nalloc * ind_blocks + RES_STATFS;
 
 	error = gfs2_trans_begin(sdp, blocks, 0);
 	if (error)
@@ -1586,6 +1586,7 @@ static int gfs2_set_dqblk(struct super_block *sb, int type, qid_t id,
 		error = gfs2_inplace_reserve(ip);
 		if (error)
 			goto out_alloc;
+		blocks += gfs2_rg_blocks(al);
 	}
 
 	error = gfs2_trans_begin(sdp, blocks + RES_DINODE + 1, 0);
diff --git a/fs/gfs2/trans.h b/fs/gfs2/trans.h
index b849eb7..fb56b78 100644
--- a/fs/gfs2/trans.h
+++ b/fs/gfs2/trans.h
@@ -26,6 +26,14 @@ struct gfs2_glock;
 #define RES_STATFS	1
 #define RES_QUOTA	2
 
+/* reserve either the number of blocks to be allocated plus the rg header
+ * block, or all of the blocks in the rg, whichever is smaller */
+static inline unsigned int gfs2_rg_blocks(const struct gfs2_alloc *al)
+{
+	return (al->al_requested < al->al_rgd->rd_length)?
+	       al->al_requested + 1 : al->al_rgd->rd_length;
+}
+
 int gfs2_trans_begin(struct gfs2_sbd *sdp, unsigned int blocks,
 		     unsigned int revokes);
 
diff --git a/fs/gfs2/xattr.c b/fs/gfs2/xattr.c
index 776af6e..30b58f0 100644
--- a/fs/gfs2/xattr.c
+++ b/fs/gfs2/xattr.c
@@ -734,7 +734,7 @@ static int ea_alloc_skeleton(struct gfs2_inode *ip, struct gfs2_ea_request *er,
 		goto out_gunlock_q;
 
 	error = gfs2_trans_begin(GFS2_SB(&ip->i_inode),
-				 blks + al->al_rgd->rd_length +
+				 blks + gfs2_rg_blocks(al) +
 				 RES_DINODE + RES_STATFS + RES_QUOTA, 0);
 	if (error)
 		goto out_ipres;
-- 
1.7.1.1

