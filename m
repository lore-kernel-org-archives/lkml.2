Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932702Ab2K3KXv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 05:23:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9244 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757138Ab2K3KSY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 05:18:24 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 06/16] GFS2: Add Orlov allocator
Date: Fri, 30 Nov 2012 09:52:11 +0000
Message-Id: <1354269141-3311-7-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1354269141-3311-1-git-send-email-swhiteho@redhat.com>
References: <1354269141-3311-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just like ext3, this works on the root directory and any directory
with the +T flag set. Also, just like ext3, any subdirectory created
in one of the just mentioned cases will be allocated to a random
resource group (GFS2 equivalent of a block group).

If you are creating a set of directories, each of which will contain a
job running on a different node, then by setting +T on the parent
directory before creating the subdirectories, each will land up in a
different resource group, and thus resource group contention between
nodes will be kept to a minimum.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/aops.c b/fs/gfs2/aops.c
index 01c4975..30de4f2 100644
--- a/fs/gfs2/aops.c
+++ b/fs/gfs2/aops.c
@@ -643,7 +643,7 @@ static int gfs2_write_begin(struct file *file, struct address_space *mapping,
 			goto out_unlock;
 
 		requested = data_blocks + ind_blocks;
-		error = gfs2_inplace_reserve(ip, requested);
+		error = gfs2_inplace_reserve(ip, requested, 0);
 		if (error)
 			goto out_qunlock;
 	}
diff --git a/fs/gfs2/bmap.c b/fs/gfs2/bmap.c
index 1fd3ae2..de70e52 100644
--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -1178,7 +1178,7 @@ static int do_grow(struct inode *inode, u64 size)
 		if (error)
 			return error;
 
-		error = gfs2_inplace_reserve(ip, 1);
+		error = gfs2_inplace_reserve(ip, 1, 0);
 		if (error)
 			goto do_grow_qunlock;
 		unstuff = 1;
diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
index e056b4c..dfe2d8c 100644
--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -432,7 +432,7 @@ static int gfs2_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 	if (ret)
 		goto out_unlock;
 	gfs2_write_calc_reserv(ip, PAGE_CACHE_SIZE, &data_blocks, &ind_blocks);
-	ret = gfs2_inplace_reserve(ip, data_blocks + ind_blocks);
+	ret = gfs2_inplace_reserve(ip, data_blocks + ind_blocks, 0);
 	if (ret)
 		goto out_quota_unlock;
 
@@ -825,7 +825,7 @@ static long gfs2_fallocate(struct file *file, int mode, loff_t offset,
 retry:
 		gfs2_write_calc_reserv(ip, bytes, &data_blocks, &ind_blocks);
 
-		error = gfs2_inplace_reserve(ip, data_blocks + ind_blocks);
+		error = gfs2_inplace_reserve(ip, data_blocks + ind_blocks, 0);
 		if (error) {
 			if (error == -ENOSPC && bytes > sdp->sd_sb.sb_bsize) {
 				bytes >>= 1;
diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index 749b05a..ef3ce00 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -385,13 +385,13 @@ static void munge_mode_uid_gid(const struct gfs2_inode *dip,
 		inode->i_gid = current_fsgid();
 }
 
-static int alloc_dinode(struct gfs2_inode *ip)
+static int alloc_dinode(struct gfs2_inode *ip, u32 flags)
 {
 	struct gfs2_sbd *sdp = GFS2_SB(&ip->i_inode);
 	int error;
 	int dblocks = 1;
 
-	error = gfs2_inplace_reserve(ip, RES_DINODE);
+	error = gfs2_inplace_reserve(ip, RES_DINODE, flags);
 	if (error)
 		goto out;
 
@@ -560,7 +560,7 @@ static int link_dinode(struct gfs2_inode *dip, const struct qstr *name,
 		if (error)
 			goto fail_quota_locks;
 
-		error = gfs2_inplace_reserve(dip, sdp->sd_max_dirres);
+		error = gfs2_inplace_reserve(dip, sdp->sd_max_dirres, 0);
 		if (error)
 			goto fail_quota_locks;
 
@@ -650,6 +650,7 @@ static int gfs2_create_inode(struct inode *dir, struct dentry *dentry,
 	struct gfs2_glock *io_gl;
 	int error;
 	struct buffer_head *bh = NULL;
+	u32 aflags = 0;
 
 	if (!name->len || name->len > GFS2_FNAMESIZE)
 		return -ENAMETOOLONG;
@@ -685,7 +686,11 @@ static int gfs2_create_inode(struct inode *dir, struct dentry *dentry,
 	munge_mode_uid_gid(dip, inode);
 	ip->i_goal = dip->i_goal;
 
-	error = alloc_dinode(ip);
+	if ((GFS2_I(sdp->sd_root_dir->d_inode) == dip) ||
+	    (dip->i_diskflags & GFS2_DIF_TOPDIR))
+		aflags |= GFS2_AF_ORLOV;
+
+	error = alloc_dinode(ip, aflags);
 	if (error)
 		goto fail_free_inode;
 
@@ -897,7 +902,7 @@ static int gfs2_link(struct dentry *old_dentry, struct inode *dir,
 		if (error)
 			goto out_gunlock;
 
-		error = gfs2_inplace_reserve(dip, sdp->sd_max_dirres);
+		error = gfs2_inplace_reserve(dip, sdp->sd_max_dirres, 0);
 		if (error)
 			goto out_gunlock_q;
 
@@ -1378,7 +1383,7 @@ static int gfs2_rename(struct inode *odir, struct dentry *odentry,
 		if (error)
 			goto out_gunlock;
 
-		error = gfs2_inplace_reserve(ndip, sdp->sd_max_dirres);
+		error = gfs2_inplace_reserve(ndip, sdp->sd_max_dirres, 0);
 		if (error)
 			goto out_gunlock_q;
 
diff --git a/fs/gfs2/quota.c b/fs/gfs2/quota.c
index c5af8e1..6bbf64f 100644
--- a/fs/gfs2/quota.c
+++ b/fs/gfs2/quota.c
@@ -816,7 +816,7 @@ static int do_sync(unsigned int num_qd, struct gfs2_quota_data **qda)
 	blocks = num_qd * data_blocks + RES_DINODE + num_qd + 3;
 
 	reserved = 1 + (nalloc * (data_blocks + ind_blocks));
-	error = gfs2_inplace_reserve(ip, reserved);
+	error = gfs2_inplace_reserve(ip, reserved, 0);
 	if (error)
 		goto out_alloc;
 
@@ -1605,7 +1605,7 @@ static int gfs2_set_dqblk(struct super_block *sb, struct kqid qid,
 		gfs2_write_calc_reserv(ip, sizeof(struct gfs2_quota),
 				       &data_blocks, &ind_blocks);
 		blocks = 1 + data_blocks + ind_blocks;
-		error = gfs2_inplace_reserve(ip, blocks);
+		error = gfs2_inplace_reserve(ip, blocks, 0);
 		if (error)
 			goto out_i;
 		blocks += gfs2_rg_blocks(ip, blocks);
diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index bdf3e64..99a6197 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -16,6 +16,7 @@
 #include <linux/prefetch.h>
 #include <linux/blkdev.h>
 #include <linux/rbtree.h>
+#include <linux/random.h>
 
 #include "gfs2.h"
 #include "incore.h"
@@ -1763,6 +1764,15 @@ static bool gfs2_rgrp_used_recently(const struct gfs2_blkreserv *rs,
 	return tdiff > (msecs * 1000 * 1000);
 }
 
+static u32 gfs2_orlov_skip(const struct gfs2_inode *ip)
+{
+	const struct gfs2_sbd *sdp = GFS2_SB(&ip->i_inode);
+	u32 skip;
+
+	get_random_bytes(&skip, sizeof(skip));
+	return skip % sdp->sd_rgrps;
+}
+
 static bool gfs2_select_rgrp(struct gfs2_rgrpd **pos, const struct gfs2_rgrpd *begin)
 {
 	struct gfs2_rgrpd *rgd = *pos;
@@ -1784,7 +1794,7 @@ static bool gfs2_select_rgrp(struct gfs2_rgrpd **pos, const struct gfs2_rgrpd *b
  * Returns: errno
  */
 
-int gfs2_inplace_reserve(struct gfs2_inode *ip, u32 requested)
+int gfs2_inplace_reserve(struct gfs2_inode *ip, u32 requested, u32 aflags)
 {
 	struct gfs2_sbd *sdp = GFS2_SB(&ip->i_inode);
 	struct gfs2_rgrpd *begin = NULL;
@@ -1792,6 +1802,7 @@ int gfs2_inplace_reserve(struct gfs2_inode *ip, u32 requested)
 	int error = 0, rg_locked, flags = 0;
 	u64 last_unlinked = NO_BLOCK;
 	int loops = 0;
+	u32 skip = 0;
 
 	if (sdp->sd_args.ar_rgrplvb)
 		flags |= GL_SKIP;
@@ -1805,6 +1816,8 @@ int gfs2_inplace_reserve(struct gfs2_inode *ip, u32 requested)
 	} else {
 		rs->rs_rbm.rgd = begin = gfs2_blk2rgrpd(sdp, ip->i_goal, 1);
 	}
+	if (S_ISDIR(ip->i_inode.i_mode) && (aflags & GFS2_AF_ORLOV))
+		skip = gfs2_orlov_skip(ip);
 	if (rs->rs_rbm.rgd == NULL)
 		return -EBADSLT;
 
@@ -1813,6 +1826,8 @@ int gfs2_inplace_reserve(struct gfs2_inode *ip, u32 requested)
 
 		if (!gfs2_glock_is_locked_by_me(rs->rs_rbm.rgd->rd_gl)) {
 			rg_locked = 0;
+			if (skip && skip--)
+				goto next_rgrp;
 			if (!gfs2_rs_active(rs) && (loops < 2) &&
 			     gfs2_rgrp_used_recently(rs, 1000) &&
 			     gfs2_rgrp_congested(rs->rs_rbm.rgd, loops))
@@ -1871,6 +1886,8 @@ next_rgrp:
 		/* Find the next rgrp, and continue looking */
 		if (gfs2_select_rgrp(&rs->rs_rbm.rgd, begin))
 			continue;
+		if (skip)
+			continue;
 
 		/* If we've scanned all the rgrps, but found no free blocks
 		 * then this checks for some less likely conditions before
diff --git a/fs/gfs2/rgrp.h b/fs/gfs2/rgrp.h
index 2407795..8421858 100644
--- a/fs/gfs2/rgrp.h
+++ b/fs/gfs2/rgrp.h
@@ -39,7 +39,8 @@ extern void gfs2_rgrp_go_unlock(struct gfs2_holder *gh);
 
 extern struct gfs2_alloc *gfs2_alloc_get(struct gfs2_inode *ip);
 
-extern int gfs2_inplace_reserve(struct gfs2_inode *ip, u32 requested);
+#define GFS2_AF_ORLOV 1
+extern int gfs2_inplace_reserve(struct gfs2_inode *ip, u32 requested, u32 flags);
 extern void gfs2_inplace_release(struct gfs2_inode *ip);
 
 extern int gfs2_alloc_blocks(struct gfs2_inode *ip, u64 *bn, unsigned int *n,
diff --git a/fs/gfs2/xattr.c b/fs/gfs2/xattr.c
index db330e5..76c144b 100644
--- a/fs/gfs2/xattr.c
+++ b/fs/gfs2/xattr.c
@@ -734,7 +734,7 @@ static int ea_alloc_skeleton(struct gfs2_inode *ip, struct gfs2_ea_request *er,
 	if (error)
 		return error;
 
-	error = gfs2_inplace_reserve(ip, blks);
+	error = gfs2_inplace_reserve(ip, blks, 0);
 	if (error)
 		goto out_gunlock_q;
 
-- 
1.7.4

