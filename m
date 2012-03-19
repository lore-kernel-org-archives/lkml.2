Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030647Ab2CSKxC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 06:53:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41836 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932177Ab2CSKtp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 06:49:45 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 03/12] GFS2: FITRIM ioctl support
Date: Mon, 19 Mar 2012 10:25:19 +0000
Message-Id: <1332152728-4027-4-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1332152728-4027-1-git-send-email-swhiteho@redhat.com>
References: <1332152728-4027-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The FITRIM ioctl provides an alternative way to send discard requests to
the underlying device. Using the discard mount option results in every
freed block generating a discard request to the block device. This can
be slow, since many block devices can only process discard requests of
larger sizes, and also such operations can be time consuming.

Rather than using the discard mount option, FITRIM allows a sweep of the
filesystem on an occasional basis, and also to optionally avoid sending
down discard requests for smaller regions.

In GFS2 FITRIM will work at resource group granularity. There is a flag
for each resource group which keeps track of which resource groups have
been trimmed. This flag is reset whenever a deallocation occurs in the
resource group, and set whenever a successful FITRIM of that resource
group has taken place. This helps to reduce repeated discard requests
for the same block ranges, again improving performance.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
index c5fb359..310f2fb 100644
--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -313,6 +313,8 @@ static long gfs2_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 		return gfs2_get_flags(filp, (u32 __user *)arg);
 	case FS_IOC_SETFLAGS:
 		return gfs2_set_flags(filp, (u32 __user *)arg);
+	case FITRIM:
+		return gfs2_fitrim(filp, (void __user *)arg);
 	}
 	return -ENOTTY;
 }
diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index 5698746..c98a60e 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -1036,7 +1036,7 @@ static int gfs2_unlink(struct inode *dir, struct dentry *dentry)
 	gfs2_holder_init(dip->i_gl, LM_ST_EXCLUSIVE, 0, ghs);
 	gfs2_holder_init(ip->i_gl,  LM_ST_EXCLUSIVE, 0, ghs + 1);
 
-	rgd = gfs2_blk2rgrpd(sdp, ip->i_no_addr);
+	rgd = gfs2_blk2rgrpd(sdp, ip->i_no_addr, 1);
 	if (!rgd)
 		goto out_inodes;
 
@@ -1255,7 +1255,7 @@ static int gfs2_rename(struct inode *odir, struct dentry *odentry,
 		 * this is the case of the target file already existing
 		 * so we unlink before doing the rename
 		 */
-		nrgd = gfs2_blk2rgrpd(sdp, nip->i_no_addr);
+		nrgd = gfs2_blk2rgrpd(sdp, nip->i_no_addr, 1);
 		if (nrgd)
 			gfs2_holder_init(nrgd->rd_gl, LM_ST_EXCLUSIVE, 0, ghs + num_gh++);
 	}
diff --git a/fs/gfs2/lops.c b/fs/gfs2/lops.c
index 8e323c4..fe369bd 100644
--- a/fs/gfs2/lops.c
+++ b/fs/gfs2/lops.c
@@ -76,7 +76,7 @@ static void maybe_release_space(struct gfs2_bufdata *bd)
 	if (bi->bi_clone == 0)
 		return;
 	if (sdp->sd_args.ar_discard)
-		gfs2_rgrp_send_discards(sdp, rgd->rd_data0, bd->bd_bh, bi);
+		gfs2_rgrp_send_discards(sdp, rgd->rd_data0, bd->bd_bh, bi, 1, NULL);
 	memcpy(bi->bi_clone + bi->bi_offset,
 	       bd->bd_bh->b_data + bi->bi_offset, bi->bi_len);
 	clear_bit(GBF_FULL, &bi->bi_flags);
diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index 49ada95..1446b4e 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -327,23 +327,31 @@ static inline int rgrp_contains_block(struct gfs2_rgrpd *rgd, u64 block)
  * Returns: The resource group, or NULL if not found
  */
 
-struct gfs2_rgrpd *gfs2_blk2rgrpd(struct gfs2_sbd *sdp, u64 blk)
+struct gfs2_rgrpd *gfs2_blk2rgrpd(struct gfs2_sbd *sdp, u64 blk, bool exact)
 {
-	struct rb_node **newn;
+	struct rb_node *n, *next;
 	struct gfs2_rgrpd *cur;
 
 	spin_lock(&sdp->sd_rindex_spin);
-	newn = &sdp->sd_rindex_tree.rb_node;
-	while (*newn) {
-		cur = rb_entry(*newn, struct gfs2_rgrpd, rd_node);
+	n = sdp->sd_rindex_tree.rb_node;
+	while (n) {
+		cur = rb_entry(n, struct gfs2_rgrpd, rd_node);
+		next = NULL;
 		if (blk < cur->rd_addr)
-			newn = &((*newn)->rb_left);
+			next = n->rb_left;
 		else if (blk >= cur->rd_data0 + cur->rd_data)
-			newn = &((*newn)->rb_right);
-		else {
+			next = n->rb_right;
+		if (next == NULL) {
 			spin_unlock(&sdp->sd_rindex_spin);
+			if (exact) {
+				if (blk < cur->rd_addr)
+					return NULL;
+				if (blk >= cur->rd_data0 + cur->rd_data)
+					return NULL;
+			}
 			return cur;
 		}
+		n = next;
 	}
 	spin_unlock(&sdp->sd_rindex_spin);
 
@@ -810,9 +818,9 @@ void gfs2_rgrp_go_unlock(struct gfs2_holder *gh)
 
 }
 
-void gfs2_rgrp_send_discards(struct gfs2_sbd *sdp, u64 offset,
+int gfs2_rgrp_send_discards(struct gfs2_sbd *sdp, u64 offset,
 			     struct buffer_head *bh,
-			     const struct gfs2_bitmap *bi)
+			     const struct gfs2_bitmap *bi, unsigned minlen, u64 *ptrimmed)
 {
 	struct super_block *sb = sdp->sd_vfs;
 	struct block_device *bdev = sb->s_bdev;
@@ -823,11 +831,19 @@ void gfs2_rgrp_send_discards(struct gfs2_sbd *sdp, u64 offset,
 	sector_t nr_sects = 0;
 	int rv;
 	unsigned int x;
+	u32 trimmed = 0;
+	u8 diff;
 
 	for (x = 0; x < bi->bi_len; x++) {
-		const u8 *orig = bh->b_data + bi->bi_offset + x;
-		const u8 *clone = bi->bi_clone + bi->bi_offset + x;
-		u8 diff = ~(*orig | (*orig >> 1)) & (*clone | (*clone >> 1));
+		const u8 *clone = bi->bi_clone ? bi->bi_clone : bi->bi_bh->b_data;
+		clone += bi->bi_offset;
+		clone += x;
+		if (bh) {
+			const u8 *orig = bh->b_data + bi->bi_offset + x;
+			diff = ~(*orig | (*orig >> 1)) & (*clone | (*clone >> 1));
+		} else {
+			diff = ~(*clone | (*clone >> 1));
+		}
 		diff &= 0x55;
 		if (diff == 0)
 			continue;
@@ -838,11 +854,14 @@ void gfs2_rgrp_send_discards(struct gfs2_sbd *sdp, u64 offset,
 				if (nr_sects == 0)
 					goto start_new_extent;
 				if ((start + nr_sects) != blk) {
-					rv = blkdev_issue_discard(bdev, start,
-							    nr_sects, GFP_NOFS,
-							    0);
-					if (rv)
-						goto fail;
+					if (nr_sects >= minlen) {
+						rv = blkdev_issue_discard(bdev,
+							start, nr_sects,
+							GFP_NOFS, 0);
+						if (rv)
+							goto fail;
+						trimmed += nr_sects;
+					}
 					nr_sects = 0;
 start_new_extent:
 					start = blk;
@@ -853,15 +872,108 @@ start_new_extent:
 			blk += sects_per_blk;
 		}
 	}
-	if (nr_sects) {
+	if (nr_sects >= minlen) {
 		rv = blkdev_issue_discard(bdev, start, nr_sects, GFP_NOFS, 0);
 		if (rv)
 			goto fail;
+		trimmed += nr_sects;
 	}
-	return;
+	if (ptrimmed)
+		*ptrimmed = trimmed;
+	return 0;
+
 fail:
-	fs_warn(sdp, "error %d on discard request, turning discards off for this filesystem", rv);
+	if (sdp->sd_args.ar_discard)
+		fs_warn(sdp, "error %d on discard request, turning discards off for this filesystem", rv);
 	sdp->sd_args.ar_discard = 0;
+	return -EIO;
+}
+
+/**
+ * gfs2_fitrim - Generate discard requests for unused bits of the filesystem
+ * @filp: Any file on the filesystem
+ * @argp: Pointer to the arguments (also used to pass result)
+ *
+ * Returns: 0 on success, otherwise error code
+ */
+
+int gfs2_fitrim(struct file *filp, void __user *argp)
+{
+	struct inode *inode = filp->f_dentry->d_inode;
+	struct gfs2_sbd *sdp = GFS2_SB(inode);
+	struct request_queue *q = bdev_get_queue(sdp->sd_vfs->s_bdev);
+	struct buffer_head *bh;
+	struct gfs2_rgrpd *rgd;
+	struct gfs2_rgrpd *rgd_end;
+	struct gfs2_holder gh;
+	struct fstrim_range r;
+	int ret = 0;
+	u64 amt;
+	u64 trimmed = 0;
+	unsigned int x;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	if (!blk_queue_discard(q))
+		return -EOPNOTSUPP;
+
+	ret = gfs2_rindex_update(sdp);
+	if (ret)
+		return ret;
+
+	if (argp == NULL) {
+		r.start = 0;
+		r.len = ULLONG_MAX;
+		r.minlen = 0;
+	} else if (copy_from_user(&r, argp, sizeof(r)))
+		return -EFAULT;
+
+	rgd = gfs2_blk2rgrpd(sdp, r.start, 0);
+	rgd_end = gfs2_blk2rgrpd(sdp, r.start + r.len, 0);
+
+	while (1) {
+
+		ret = gfs2_glock_nq_init(rgd->rd_gl, LM_ST_EXCLUSIVE, 0, &gh);
+		if (ret)
+			goto out;
+
+		if (!(rgd->rd_flags & GFS2_RGF_TRIMMED)) {
+			/* Trim each bitmap in the rgrp */
+			for (x = 0; x < rgd->rd_length; x++) {
+				struct gfs2_bitmap *bi = rgd->rd_bits + x;
+				ret = gfs2_rgrp_send_discards(sdp, rgd->rd_data0, NULL, bi, r.minlen, &amt);
+				if (ret) {
+					gfs2_glock_dq_uninit(&gh);
+					goto out;
+				}
+				trimmed += amt;
+			}
+
+			/* Mark rgrp as having been trimmed */
+			ret = gfs2_trans_begin(sdp, RES_RG_HDR, 0);
+			if (ret == 0) {
+				bh = rgd->rd_bits[0].bi_bh;
+				rgd->rd_flags |= GFS2_RGF_TRIMMED;
+				gfs2_trans_add_bh(rgd->rd_gl, bh, 1);
+				gfs2_rgrp_out(rgd, bh->b_data);
+				gfs2_trans_end(sdp);
+			}
+		}
+		gfs2_glock_dq_uninit(&gh);
+
+		if (rgd == rgd_end)
+			break;
+
+		rgd = gfs2_rgrpd_get_next(rgd);
+	}
+
+out:
+	r.len = trimmed << 9;
+	if (argp && copy_to_user(argp, &r, sizeof(r)))
+		return -EFAULT;
+
+	return ret;
 }
 
 /**
@@ -1008,7 +1120,7 @@ static int get_local_rgrp(struct gfs2_inode *ip, u64 *last_unlinked)
 	if (ip->i_rgd && rgrp_contains_block(ip->i_rgd, ip->i_goal))
 		rgd = begin = ip->i_rgd;
 	else
-		rgd = begin = gfs2_blk2rgrpd(sdp, ip->i_goal);
+		rgd = begin = gfs2_blk2rgrpd(sdp, ip->i_goal, 1);
 
 	if (rgd == NULL)
 		return -EBADSLT;
@@ -1293,7 +1405,7 @@ static struct gfs2_rgrpd *rgblk_free(struct gfs2_sbd *sdp, u64 bstart,
 	u32 length, rgrp_blk, buf_blk;
 	unsigned int buf;
 
-	rgd = gfs2_blk2rgrpd(sdp, bstart);
+	rgd = gfs2_blk2rgrpd(sdp, bstart, 1);
 	if (!rgd) {
 		if (gfs2_consist(sdp))
 			fs_err(sdp, "block = %llu\n", (unsigned long long)bstart);
@@ -1474,7 +1586,7 @@ void __gfs2_free_blocks(struct gfs2_inode *ip, u64 bstart, u32 blen, int meta)
 		return;
 	trace_gfs2_block_alloc(ip, bstart, blen, GFS2_BLKST_FREE);
 	rgd->rd_free += blen;
-
+	rgd->rd_flags &= ~GFS2_RGF_TRIMMED;
 	gfs2_trans_add_bh(rgd->rd_gl, rgd->rd_bits[0].bi_bh, 1);
 	gfs2_rgrp_out(rgd, rgd->rd_bits[0].bi_bh->b_data);
 
@@ -1567,7 +1679,7 @@ int gfs2_check_blk_type(struct gfs2_sbd *sdp, u64 no_addr, unsigned int type)
 		return error;
 
 	error = -EINVAL;
-	rgd = gfs2_blk2rgrpd(sdp, no_addr);
+	rgd = gfs2_blk2rgrpd(sdp, no_addr, 1);
 	if (!rgd)
 		goto fail;
 
@@ -1610,7 +1722,7 @@ void gfs2_rlist_add(struct gfs2_inode *ip, struct gfs2_rgrp_list *rlist,
 	if (ip->i_rgd && rgrp_contains_block(ip->i_rgd, block))
 		rgd = ip->i_rgd;
 	else
-		rgd = gfs2_blk2rgrpd(sdp, block);
+		rgd = gfs2_blk2rgrpd(sdp, block, 1);
 	if (!rgd) {
 		fs_err(sdp, "rlist_add: no rgrp for block %llu\n", (unsigned long long)block);
 		return;
diff --git a/fs/gfs2/rgrp.h b/fs/gfs2/rgrp.h
index ceec910..b4b10f4 100644
--- a/fs/gfs2/rgrp.h
+++ b/fs/gfs2/rgrp.h
@@ -11,6 +11,7 @@
 #define __RGRP_DOT_H__
 
 #include <linux/slab.h>
+#include <linux/uaccess.h>
 
 struct gfs2_rgrpd;
 struct gfs2_sbd;
@@ -18,7 +19,7 @@ struct gfs2_holder;
 
 extern void gfs2_rgrp_verify(struct gfs2_rgrpd *rgd);
 
-extern struct gfs2_rgrpd *gfs2_blk2rgrpd(struct gfs2_sbd *sdp, u64 blk);
+extern struct gfs2_rgrpd *gfs2_blk2rgrpd(struct gfs2_sbd *sdp, u64 blk, bool exact);
 extern struct gfs2_rgrpd *gfs2_rgrpd_get_first(struct gfs2_sbd *sdp);
 extern struct gfs2_rgrpd *gfs2_rgrpd_get_next(struct gfs2_rgrpd *rgd);
 
@@ -62,8 +63,9 @@ extern void gfs2_rlist_alloc(struct gfs2_rgrp_list *rlist, unsigned int state);
 extern void gfs2_rlist_free(struct gfs2_rgrp_list *rlist);
 extern u64 gfs2_ri_total(struct gfs2_sbd *sdp);
 extern int gfs2_rgrp_dump(struct seq_file *seq, const struct gfs2_glock *gl);
-extern void gfs2_rgrp_send_discards(struct gfs2_sbd *sdp, u64 offset,
-				    struct buffer_head *bh,
-				    const struct gfs2_bitmap *bi);
+extern int gfs2_rgrp_send_discards(struct gfs2_sbd *sdp, u64 offset,
+				   struct buffer_head *bh,
+				   const struct gfs2_bitmap *bi, unsigned minlen, u64 *ptrimmed);
+extern int gfs2_fitrim(struct file *filp, void __user *argp);
 
 #endif /* __RGRP_DOT_H__ */
diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index 4553ce5..f3faf72 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -1417,7 +1417,7 @@ static int gfs2_dinode_dealloc(struct gfs2_inode *ip)
 	if (error)
 		goto out;
 
-	rgd = gfs2_blk2rgrpd(sdp, ip->i_no_addr);
+	rgd = gfs2_blk2rgrpd(sdp, ip->i_no_addr, 1);
 	if (!rgd) {
 		gfs2_consist_inode(ip);
 		error = -EIO;
diff --git a/fs/gfs2/xattr.c b/fs/gfs2/xattr.c
index e963659..2e5ba42 100644
--- a/fs/gfs2/xattr.c
+++ b/fs/gfs2/xattr.c
@@ -251,7 +251,7 @@ static int ea_dealloc_unstuffed(struct gfs2_inode *ip, struct buffer_head *bh,
 	if (!blks)
 		return 0;
 
-	rgd = gfs2_blk2rgrpd(sdp, bn);
+	rgd = gfs2_blk2rgrpd(sdp, bn, 1);
 	if (!rgd) {
 		gfs2_consist_inode(ip);
 		return -EIO;
@@ -1439,7 +1439,7 @@ static int ea_dealloc_block(struct gfs2_inode *ip)
 	struct gfs2_holder gh;
 	int error;
 
-	rgd = gfs2_blk2rgrpd(sdp, ip->i_eattr);
+	rgd = gfs2_blk2rgrpd(sdp, ip->i_eattr, 1);
 	if (!rgd) {
 		gfs2_consist_inode(ip);
 		return -EIO;
diff --git a/include/linux/gfs2_ondisk.h b/include/linux/gfs2_ondisk.h
index b148087..fa98bdb 100644
--- a/include/linux/gfs2_ondisk.h
+++ b/include/linux/gfs2_ondisk.h
@@ -168,6 +168,7 @@ struct gfs2_rindex {
 #define GFS2_RGF_METAONLY	0x00000002
 #define GFS2_RGF_DATAONLY	0x00000004
 #define GFS2_RGF_NOALLOC	0x00000008
+#define GFS2_RGF_TRIMMED	0x00000010
 
 struct gfs2_rgrp {
 	struct gfs2_meta_header rg_header;
-- 
1.7.4

