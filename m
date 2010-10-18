Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932096Ab0JROhh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 10:37:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46370 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756203Ab0JROhe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 10:37:34 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Benjamin Marzinski <bmarzins@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 05/22] GFS2: fallocate support
Date: Mon, 18 Oct 2010 15:15:29 +0100
Message-Id: <1287411346-17855-6-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1287411346-17855-1-git-send-email-swhiteho@redhat.com>
References: <1287411346-17855-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Marzinski <bmarzins@redhat.com>

This patch adds support for fallocate to gfs2.  Since the gfs2 does not support
uninitialized data blocks, it must write out zeros to all the blocks.  However,
since it does not need to lock any pages to read from, gfs2 can write out the
zero blocks much more efficiently.  On a moderately full filesystem, fallocate
works around 5 times faster on average.  The fallocate call also allows gfs2 to
add blocks to the file without changing the filesize, which will make it
possible for gfs2 to preallocate space for the rindex file, so that gfs2 can
grow a completely full filesystem.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/aops.c b/fs/gfs2/aops.c
index c92f36b..180ef8a 100644
--- a/fs/gfs2/aops.c
+++ b/fs/gfs2/aops.c
@@ -36,8 +36,8 @@
 #include "glops.h"
 
 
-static void gfs2_page_add_databufs(struct gfs2_inode *ip, struct page *page,
-				   unsigned int from, unsigned int to)
+void gfs2_page_add_databufs(struct gfs2_inode *ip, struct page *page,
+			    unsigned int from, unsigned int to)
 {
 	struct buffer_head *head = page_buffers(page);
 	unsigned int bsize = head->b_size;
diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index c119717..578234b 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -571,6 +571,7 @@ struct gfs2_sbd {
 	struct list_head sd_rindex_mru_list;
 	struct gfs2_rgrpd *sd_rindex_forward;
 	unsigned int sd_rgrps;
+	unsigned int sd_max_rg_data;
 
 	/* Journal index stuff */
 
diff --git a/fs/gfs2/inode.h b/fs/gfs2/inode.h
index 15ff4df..6720d7d 100644
--- a/fs/gfs2/inode.h
+++ b/fs/gfs2/inode.h
@@ -19,6 +19,8 @@ extern int gfs2_releasepage(struct page *page, gfp_t gfp_mask);
 extern int gfs2_internal_read(struct gfs2_inode *ip,
 			      struct file_ra_state *ra_state,
 			      char *buf, loff_t *pos, unsigned size);
+extern void gfs2_page_add_databufs(struct gfs2_inode *ip, struct page *page,
+				   unsigned int from, unsigned int to);
 extern void gfs2_set_aops(struct inode *inode);
 
 static inline int gfs2_is_stuffed(const struct gfs2_inode *ip)
diff --git a/fs/gfs2/ops_inode.c b/fs/gfs2/ops_inode.c
index ee6ffd5..f6da0d7 100644
--- a/fs/gfs2/ops_inode.c
+++ b/fs/gfs2/ops_inode.c
@@ -18,6 +18,8 @@
 #include <linux/gfs2_ondisk.h>
 #include <linux/crc32.h>
 #include <linux/fiemap.h>
+#include <linux/swap.h>
+#include <linux/falloc.h>
 #include <asm/uaccess.h>
 
 #include "gfs2.h"
@@ -1277,6 +1279,257 @@ static int gfs2_removexattr(struct dentry *dentry, const char *name)
 	return ret;
 }
 
+static void empty_write_end(struct page *page, unsigned from,
+			   unsigned to)
+{
+	struct gfs2_inode *ip = GFS2_I(page->mapping->host);
+
+	page_zero_new_buffers(page, from, to);
+	flush_dcache_page(page);
+	mark_page_accessed(page);
+
+	if (!gfs2_is_writeback(ip))
+		gfs2_page_add_databufs(ip, page, from, to);
+
+	block_commit_write(page, from, to);
+}
+
+
+static int write_empty_blocks(struct page *page, unsigned from, unsigned to)
+{
+	unsigned start, end, next;
+	struct buffer_head *bh, *head;
+	int error;
+
+	if (!page_has_buffers(page)) {
+		error = block_prepare_write(page, from, to, gfs2_block_map);
+		if (unlikely(error))
+			return error;
+
+		empty_write_end(page, from, to);
+		return 0;
+	}
+
+	bh = head = page_buffers(page);
+	next = end = 0;
+	while (next < from) {
+		next += bh->b_size;
+		bh = bh->b_this_page;
+	}
+	start = next;
+	do {
+		next += bh->b_size;
+		if (buffer_mapped(bh)) {
+			if (end) {
+				error = block_prepare_write(page, start, end,
+							    gfs2_block_map);
+				if (unlikely(error))
+					return error;
+				empty_write_end(page, start, end);
+				end = 0;
+			}
+			start = next;
+		}
+		else
+			end = next;
+		bh = bh->b_this_page;
+	} while (next < to);
+
+	if (end) {
+		error = block_prepare_write(page, start, end, gfs2_block_map);
+		if (unlikely(error))
+			return error;
+		empty_write_end(page, start, end);
+	}
+
+	return 0;
+}
+
+static int fallocate_chunk(struct inode *inode, loff_t offset, loff_t len,
+			   int mode)
+{
+	struct gfs2_inode *ip = GFS2_I(inode);
+	struct buffer_head *dibh;
+	int error;
+	u64 start = offset >> PAGE_CACHE_SHIFT;
+	unsigned int start_offset = offset & ~PAGE_CACHE_MASK;
+	u64 end = (offset + len - 1) >> PAGE_CACHE_SHIFT;
+	pgoff_t curr;
+	struct page *page;
+	unsigned int end_offset = (offset + len) & ~PAGE_CACHE_MASK;
+	unsigned int from, to;
+
+	if (!end_offset)
+		end_offset = PAGE_CACHE_SIZE;
+
+	error = gfs2_meta_inode_buffer(ip, &dibh);
+	if (unlikely(error))
+		goto out;
+
+	gfs2_trans_add_bh(ip->i_gl, dibh, 1);
+
+	if (gfs2_is_stuffed(ip)) {
+		error = gfs2_unstuff_dinode(ip, NULL);
+		if (unlikely(error))
+			goto out;
+	}
+
+	curr = start;
+	offset = start << PAGE_CACHE_SHIFT;
+	from = start_offset;
+	to = PAGE_CACHE_SIZE;
+	while (curr <= end) {
+		page = grab_cache_page_write_begin(inode->i_mapping, curr,
+						   AOP_FLAG_NOFS);
+		if (unlikely(!page)) {
+			error = -ENOMEM;
+			goto out;
+		}
+
+		if (curr == end)
+			to = end_offset;
+		error = write_empty_blocks(page, from, to);
+		if (!error && offset + to > inode->i_size &&
+		    !(mode & FALLOC_FL_KEEP_SIZE)) {
+			i_size_write(inode, offset + to);
+		}
+		unlock_page(page);
+		page_cache_release(page);
+		if (error)
+			goto out;
+		curr++;
+		offset += PAGE_CACHE_SIZE;
+		from = 0;
+	}
+
+	gfs2_dinode_out(ip, dibh->b_data);
+	mark_inode_dirty(inode);
+
+	brelse(dibh);
+
+out:
+	return error;
+}
+
+static void calc_max_reserv(struct gfs2_inode *ip, loff_t max, loff_t *len,
+			    unsigned int *data_blocks, unsigned int *ind_blocks)
+{
+	const struct gfs2_sbd *sdp = GFS2_SB(&ip->i_inode);
+	unsigned int max_blocks = ip->i_alloc->al_rgd->rd_free_clone;
+	unsigned int tmp, max_data = max_blocks - 3 * (sdp->sd_max_height - 1);
+
+	for (tmp = max_data; tmp > sdp->sd_diptrs;) {
+		tmp = DIV_ROUND_UP(tmp, sdp->sd_inptrs);
+		max_data -= tmp;
+	}
+	/* This calculation isn't the exact reverse of gfs2_write_calc_reserve,
+ 	   so it might end up with fewer data blocks */
+	if (max_data <= *data_blocks)
+		return;
+	*data_blocks = max_data;
+	*ind_blocks = max_blocks - max_data;
+	*len = ((loff_t)max_data - 3) << sdp->sd_sb.sb_bsize_shift;
+	if (*len > max) {
+		*len = max;
+		gfs2_write_calc_reserv(ip, max, data_blocks, ind_blocks);
+	}
+}
+
+static long gfs2_fallocate(struct inode *inode, int mode, loff_t offset,
+			   loff_t len)
+{
+	struct gfs2_sbd *sdp = GFS2_SB(inode);
+	struct gfs2_inode *ip = GFS2_I(inode);
+	unsigned int data_blocks = 0, ind_blocks = 0, rblocks;
+	loff_t bytes, max_bytes;
+	struct gfs2_alloc *al;
+	int error;
+	loff_t next = (offset + len - 1) >> sdp->sd_sb.sb_bsize_shift;
+	next = (next + 1) << sdp->sd_sb.sb_bsize_shift;
+
+	offset = (offset >> sdp->sd_sb.sb_bsize_shift) <<
+		 sdp->sd_sb.sb_bsize_shift;
+
+	len = next - offset;
+	bytes = sdp->sd_max_rg_data * sdp->sd_sb.sb_bsize / 2;
+	if (!bytes)
+		bytes = UINT_MAX;
+
+	gfs2_holder_init(ip->i_gl, LM_ST_EXCLUSIVE, 0, &ip->i_gh);
+	error = gfs2_glock_nq(&ip->i_gh);
+	if (unlikely(error))
+		goto out_uninit;
+
+	if (!gfs2_write_alloc_required(ip, offset, len))
+		goto out_unlock;
+
+	while (len > 0) {
+		if (len < bytes)
+			bytes = len;
+		al = gfs2_alloc_get(ip);
+		if (!al) {
+			error = -ENOMEM;
+			goto out_unlock;
+		}
+
+		error = gfs2_quota_lock_check(ip);
+		if (error)
+			goto out_alloc_put;
+
+retry:
+		gfs2_write_calc_reserv(ip, bytes, &data_blocks, &ind_blocks);
+
+		al->al_requested = data_blocks + ind_blocks;
+		error = gfs2_inplace_reserve(ip);
+		if (error) {
+			if (error == -ENOSPC && bytes > sdp->sd_sb.sb_bsize) {
+				bytes >>= 1;
+				goto retry;
+			}
+			goto out_qunlock;
+		}
+		max_bytes = bytes;
+		calc_max_reserv(ip, len, &max_bytes, &data_blocks, &ind_blocks);
+		al->al_requested = data_blocks + ind_blocks;
+
+		rblocks = RES_DINODE + ind_blocks + RES_STATFS + RES_QUOTA +
+			  RES_RG_HDR + ip->i_alloc->al_rgd->rd_length;
+		if (gfs2_is_jdata(ip))
+			rblocks += data_blocks ? data_blocks : 1;
+
+		error = gfs2_trans_begin(sdp, rblocks,
+					 PAGE_CACHE_SIZE/sdp->sd_sb.sb_bsize);
+		if (error)
+			goto out_trans_fail;
+
+		error = fallocate_chunk(inode, offset, max_bytes, mode);
+		gfs2_trans_end(sdp);
+
+		if (error)
+			goto out_trans_fail;
+
+		len -= max_bytes;
+		offset += max_bytes;
+		gfs2_inplace_release(ip);
+		gfs2_quota_unlock(ip);
+		gfs2_alloc_put(ip);
+	}
+	goto out_unlock;
+
+out_trans_fail:
+	gfs2_inplace_release(ip);
+out_qunlock:
+	gfs2_quota_unlock(ip);
+out_alloc_put:
+	gfs2_alloc_put(ip);
+out_unlock:
+	gfs2_glock_dq(&ip->i_gh);
+out_uninit:
+	gfs2_holder_uninit(&ip->i_gh);
+	return error;
+}
+
+
 static int gfs2_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 		       u64 start, u64 len)
 {
@@ -1327,6 +1580,7 @@ const struct inode_operations gfs2_file_iops = {
 	.getxattr = gfs2_getxattr,
 	.listxattr = gfs2_listxattr,
 	.removexattr = gfs2_removexattr,
+	.fallocate = gfs2_fallocate,
 	.fiemap = gfs2_fiemap,
 };
 
diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index 66b6d4d..f9ddcf4 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -589,6 +589,8 @@ static int gfs2_ri_update(struct gfs2_inode *ip)
 	struct inode *inode = &ip->i_inode;
 	struct file_ra_state ra_state;
 	u64 rgrp_count = i_size_read(inode);
+	struct gfs2_rgrpd *rgd;
+	unsigned int max_data = 0;
 	int error;
 
 	do_div(rgrp_count, sizeof(struct gfs2_rindex));
@@ -603,6 +605,10 @@ static int gfs2_ri_update(struct gfs2_inode *ip)
 		}
 	}
 
+	list_for_each_entry(rgd, &sdp->sd_rindex_list, rd_list)
+		if (rgd->rd_data > max_data)
+			max_data = rgd->rd_data;
+	sdp->sd_max_rg_data = max_data;
 	sdp->sd_rindex_uptodate = 1;
 	return 0;
 }
@@ -622,6 +628,8 @@ static int gfs2_ri_update_special(struct gfs2_inode *ip)
 	struct gfs2_sbd *sdp = GFS2_SB(&ip->i_inode);
 	struct inode *inode = &ip->i_inode;
 	struct file_ra_state ra_state;
+	struct gfs2_rgrpd *rgd;
+	unsigned int max_data = 0;
 	int error;
 
 	file_ra_state_init(&ra_state, inode->i_mapping);
@@ -636,6 +644,10 @@ static int gfs2_ri_update_special(struct gfs2_inode *ip)
 			return error;
 		}
 	}
+	list_for_each_entry(rgd, &sdp->sd_rindex_list, rd_list)
+		if (rgd->rd_data > max_data)
+			max_data = rgd->rd_data;
+	sdp->sd_max_rg_data = max_data;
 
 	sdp->sd_rindex_uptodate = 1;
 	return 0;
diff --git a/fs/gfs2/trans.h b/fs/gfs2/trans.h
index edf9d4b..b849eb7 100644
--- a/fs/gfs2/trans.h
+++ b/fs/gfs2/trans.h
@@ -20,6 +20,7 @@ struct gfs2_glock;
 #define RES_JDATA	1
 #define RES_DATA	1
 #define RES_LEAF	1
+#define RES_RG_HDR	1
 #define RES_RG_BIT	2
 #define RES_EATTR	1
 #define RES_STATFS	1
-- 
1.7.1.1

