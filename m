Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756171Ab0JROhc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 10:37:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46230 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755932Ab0JROha (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 10:37:30 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 02/22] GFS2: Remove i_disksize
Date: Mon, 18 Oct 2010 15:15:26 +0100
Message-Id: <1287411346-17855-3-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1287411346-17855-1-git-send-email-swhiteho@redhat.com>
References: <1287411346-17855-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the update of the truncate code, ip->i_disksize and
inode->i_size are merely copies of each other. This means
we can remove ip->i_disksize and use inode->i_size exclusively
reducing the size of a GFS2 inode by 8 bytes.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/aops.c b/fs/gfs2/aops.c
index f687f25..c92f36b 100644
--- a/fs/gfs2/aops.c
+++ b/fs/gfs2/aops.c
@@ -800,10 +800,8 @@ static int gfs2_stuffed_write_end(struct inode *inode, struct buffer_head *dibh,
 	page_cache_release(page);
 
 	if (copied) {
-		if (inode->i_size < to) {
+		if (inode->i_size < to)
 			i_size_write(inode, to);
-			ip->i_disksize = inode->i_size;
-		}
 		gfs2_dinode_out(ip, di);
 		mark_inode_dirty(inode);
 	}
@@ -874,8 +872,6 @@ static int gfs2_write_end(struct file *file, struct address_space *mapping,
 
 	ret = generic_write_end(file, mapping, pos, len, copied, page, fsdata);
 	if (ret > 0) {
-		if (inode->i_size > ip->i_disksize)
-			ip->i_disksize = inode->i_size;
 		gfs2_dinode_out(ip, dibh->b_data);
 		mark_inode_dirty(inode);
 	}
diff --git a/fs/gfs2/bmap.c b/fs/gfs2/bmap.c
index 20b971a..04513e9 100644
--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -131,7 +131,7 @@ int gfs2_unstuff_dinode(struct gfs2_inode *ip, struct page *page)
 	if (error)
 		goto out;
 
-	if (ip->i_disksize) {
+	if (i_size_read(&ip->i_inode)) {
 		/* Get a free block, fill it with the stuffed data,
 		   and write it out to disk */
 
@@ -160,7 +160,7 @@ int gfs2_unstuff_dinode(struct gfs2_inode *ip, struct page *page)
 	di = (struct gfs2_dinode *)dibh->b_data;
 	gfs2_buffer_clear_tail(dibh, sizeof(struct gfs2_dinode));
 
-	if (ip->i_disksize) {
+	if (i_size_read(&ip->i_inode)) {
 		*(__be64 *)(di + 1) = cpu_to_be64(block);
 		gfs2_add_inode_blocks(&ip->i_inode, 1);
 		di->di_blocks = cpu_to_be64(gfs2_get_inode_blocks(&ip->i_inode));
@@ -985,7 +985,6 @@ static int trunc_start(struct inode *inode, u64 oldsize, u64 newsize)
 	}
 
 	i_size_write(inode, newsize);
-	ip->i_disksize = newsize;
 	ip->i_inode.i_mtime = ip->i_inode.i_ctime = CURRENT_TIME;
 	gfs2_dinode_out(ip, dibh->b_data);
 
@@ -1051,7 +1050,7 @@ static int trunc_end(struct gfs2_inode *ip)
 	if (error)
 		goto out;
 
-	if (!ip->i_disksize) {
+	if (!i_size_read(&ip->i_inode)) {
 		ip->i_height = 0;
 		ip->i_goal = ip->i_no_addr;
 		gfs2_buffer_clear_tail(dibh, sizeof(struct gfs2_dinode));
@@ -1167,7 +1166,6 @@ static int do_grow(struct inode *inode, u64 size)
 		goto do_end_trans;
 
 	i_size_write(inode, size);
-	ip->i_disksize = size;
 	ip->i_inode.i_mtime = ip->i_inode.i_ctime = CURRENT_TIME;
 	gfs2_trans_add_bh(ip->i_gl, dibh, 1);
 	gfs2_dinode_out(ip, dibh->b_data);
@@ -1219,7 +1217,7 @@ int gfs2_setattr_size(struct inode *inode, u64 newsize)
 int gfs2_truncatei_resume(struct gfs2_inode *ip)
 {
 	int error;
-	error = trunc_dealloc(ip, ip->i_disksize);
+	error = trunc_dealloc(ip, i_size_read(&ip->i_inode));
 	if (!error)
 		error = trunc_end(ip);
 	return error;
@@ -1260,7 +1258,7 @@ int gfs2_write_alloc_required(struct gfs2_inode *ip, u64 offset,
 
 	shift = sdp->sd_sb.sb_bsize_shift;
 	BUG_ON(gfs2_is_dir(ip));
-	end_of_file = (ip->i_disksize + sdp->sd_sb.sb_bsize - 1) >> shift;
+	end_of_file = (i_size_read(&ip->i_inode) + sdp->sd_sb.sb_bsize - 1) >> shift;
 	lblock = offset >> shift;
 	lblock_stop = (offset + len + sdp->sd_sb.sb_bsize - 1) >> shift;
 	if (lblock_stop > end_of_file)
diff --git a/fs/gfs2/dir.c b/fs/gfs2/dir.c
index b9dd88a..c1042ae 100644
--- a/fs/gfs2/dir.c
+++ b/fs/gfs2/dir.c
@@ -127,8 +127,8 @@ static int gfs2_dir_write_stuffed(struct gfs2_inode *ip, const char *buf,
 
 	gfs2_trans_add_bh(ip->i_gl, dibh, 1);
 	memcpy(dibh->b_data + offset + sizeof(struct gfs2_dinode), buf, size);
-	if (ip->i_disksize < offset + size)
-		ip->i_disksize = offset + size;
+	if (ip->i_inode.i_size < offset + size)
+		i_size_write(&ip->i_inode, offset + size);
 	ip->i_inode.i_mtime = ip->i_inode.i_ctime = CURRENT_TIME;
 	gfs2_dinode_out(ip, dibh->b_data);
 
@@ -225,8 +225,8 @@ out:
 	if (error)
 		return error;
 
-	if (ip->i_disksize < offset + copied)
-		ip->i_disksize = offset + copied;
+	if (ip->i_inode.i_size < offset + copied)
+		i_size_write(&ip->i_inode, offset + copied);
 	ip->i_inode.i_mtime = ip->i_inode.i_ctime = CURRENT_TIME;
 
 	gfs2_trans_add_bh(ip->i_gl, dibh, 1);
@@ -275,12 +275,13 @@ static int gfs2_dir_read_data(struct gfs2_inode *ip, char *buf, u64 offset,
 	unsigned int o;
 	int copied = 0;
 	int error = 0;
+	u64 disksize = i_size_read(&ip->i_inode);
 
-	if (offset >= ip->i_disksize)
+	if (offset >= disksize)
 		return 0;
 
-	if (offset + size > ip->i_disksize)
-		size = ip->i_disksize - offset;
+	if (offset + size > disksize)
+		size = disksize - offset;
 
 	if (!size)
 		return 0;
@@ -727,7 +728,7 @@ static struct gfs2_dirent *gfs2_dirent_search(struct inode *inode,
 		unsigned hsize = 1 << ip->i_depth;
 		unsigned index;
 		u64 ln;
-		if (hsize * sizeof(u64) != ip->i_disksize) {
+		if (hsize * sizeof(u64) != i_size_read(inode)) {
 			gfs2_consist_inode(ip);
 			return ERR_PTR(-EIO);
 		}
@@ -879,7 +880,7 @@ static int dir_make_exhash(struct inode *inode)
 	for (x = sdp->sd_hash_ptrs; x--; lp++)
 		*lp = cpu_to_be64(bn);
 
-	dip->i_disksize = sdp->sd_sb.sb_bsize / 2;
+	i_size_write(inode, sdp->sd_sb.sb_bsize / 2);
 	gfs2_add_inode_blocks(&dip->i_inode, 1);
 	dip->i_diskflags |= GFS2_DIF_EXHASH;
 
@@ -1057,11 +1058,12 @@ static int dir_double_exhash(struct gfs2_inode *dip)
 	u64 *buf;
 	u64 *from, *to;
 	u64 block;
+	u64 disksize = i_size_read(&dip->i_inode);
 	int x;
 	int error = 0;
 
 	hsize = 1 << dip->i_depth;
-	if (hsize * sizeof(u64) != dip->i_disksize) {
+	if (hsize * sizeof(u64) != disksize) {
 		gfs2_consist_inode(dip);
 		return -EIO;
 	}
@@ -1072,7 +1074,7 @@ static int dir_double_exhash(struct gfs2_inode *dip)
 	if (!buf)
 		return -ENOMEM;
 
-	for (block = dip->i_disksize >> sdp->sd_hash_bsize_shift; block--;) {
+	for (block = disksize >> sdp->sd_hash_bsize_shift; block--;) {
 		error = gfs2_dir_read_data(dip, (char *)buf,
 					    block * sdp->sd_hash_bsize,
 					    sdp->sd_hash_bsize, 1);
@@ -1370,7 +1372,7 @@ static int dir_e_read(struct inode *inode, u64 *offset, void *opaque,
 	unsigned depth = 0;
 
 	hsize = 1 << dip->i_depth;
-	if (hsize * sizeof(u64) != dip->i_disksize) {
+	if (hsize * sizeof(u64) != i_size_read(inode)) {
 		gfs2_consist_inode(dip);
 		return -EIO;
 	}
@@ -1784,7 +1786,7 @@ static int foreach_leaf(struct gfs2_inode *dip, leaf_call_t lc, void *data)
 	int error = 0;
 
 	hsize = 1 << dip->i_depth;
-	if (hsize * sizeof(u64) != dip->i_disksize) {
+	if (hsize * sizeof(u64) != i_size_read(&dip->i_inode)) {
 		gfs2_consist_inode(dip);
 		return -EIO;
 	}
diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
index 4edd662..daadcd2 100644
--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -491,7 +491,7 @@ static int gfs2_open(struct inode *inode, struct file *file)
 			goto fail;
 
 		if (!(file->f_flags & O_LARGEFILE) &&
-		    ip->i_disksize > MAX_NON_LFS) {
+		    i_size_read(inode) > MAX_NON_LFS) {
 			error = -EOVERFLOW;
 			goto fail_gunlock;
 		}
diff --git a/fs/gfs2/glops.c b/fs/gfs2/glops.c
index 49f97d3..621d80e 100644
--- a/fs/gfs2/glops.c
+++ b/fs/gfs2/glops.c
@@ -262,13 +262,12 @@ static int inode_go_dump(struct seq_file *seq, const struct gfs2_glock *gl)
 	const struct gfs2_inode *ip = gl->gl_object;
 	if (ip == NULL)
 		return 0;
-	gfs2_print_dbg(seq, " I: n:%llu/%llu t:%u f:0x%02lx d:0x%08x s:%llu/%llu\n",
+	gfs2_print_dbg(seq, " I: n:%llu/%llu t:%u f:0x%02lx d:0x%08x s:%llu\n",
 		  (unsigned long long)ip->i_no_formal_ino,
 		  (unsigned long long)ip->i_no_addr,
 		  IF2DT(ip->i_inode.i_mode), ip->i_flags,
 		  (unsigned int)ip->i_diskflags,
-		  (unsigned long long)ip->i_inode.i_size,
-		  (unsigned long long)ip->i_disksize);
+		  (unsigned long long)i_size_read(&ip->i_inode));
 	return 0;
 }
 
diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index fdbf4b3..c119717 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -267,7 +267,6 @@ struct gfs2_inode {
 	u64 i_no_formal_ino;
 	u64 i_generation;
 	u64 i_eattr;
-	loff_t i_disksize;
 	unsigned long i_flags;		/* GIF_... */
 	struct gfs2_glock *i_gl; /* Move into i_gh? */
 	struct gfs2_holder i_iopen_gh;
diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index 08140f1..06370f8 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -359,8 +359,7 @@ static int gfs2_dinode_in(struct gfs2_inode *ip, const void *buf)
 	 * to do that.
 	 */
 	ip->i_inode.i_nlink = be32_to_cpu(str->di_nlink);
-	ip->i_disksize = be64_to_cpu(str->di_size);
-	i_size_write(&ip->i_inode, ip->i_disksize);
+	i_size_write(&ip->i_inode, be64_to_cpu(str->di_size));
 	gfs2_set_inode_blocks(&ip->i_inode, be64_to_cpu(str->di_blocks));
 	atime.tv_sec = be64_to_cpu(str->di_atime);
 	atime.tv_nsec = be32_to_cpu(str->di_atime_nsec);
@@ -1055,7 +1054,7 @@ void gfs2_dinode_out(const struct gfs2_inode *ip, void *buf)
 	str->di_uid = cpu_to_be32(ip->i_inode.i_uid);
 	str->di_gid = cpu_to_be32(ip->i_inode.i_gid);
 	str->di_nlink = cpu_to_be32(ip->i_inode.i_nlink);
-	str->di_size = cpu_to_be64(ip->i_disksize);
+	str->di_size = cpu_to_be64(i_size_read(&ip->i_inode));
 	str->di_blocks = cpu_to_be64(gfs2_get_inode_blocks(&ip->i_inode));
 	str->di_atime = cpu_to_be64(ip->i_inode.i_atime.tv_sec);
 	str->di_mtime = cpu_to_be64(ip->i_inode.i_mtime.tv_sec);
@@ -1085,8 +1084,8 @@ void gfs2_dinode_print(const struct gfs2_inode *ip)
 	       (unsigned long long)ip->i_no_formal_ino);
 	printk(KERN_INFO "  no_addr = %llu\n",
 	       (unsigned long long)ip->i_no_addr);
-	printk(KERN_INFO "  i_disksize = %llu\n",
-	       (unsigned long long)ip->i_disksize);
+	printk(KERN_INFO "  i_size = %llu\n",
+	       (unsigned long long)i_size_read(&ip->i_inode));
 	printk(KERN_INFO "  blocks = %llu\n",
 	       (unsigned long long)gfs2_get_inode_blocks(&ip->i_inode));
 	printk(KERN_INFO "  i_goal = %llu\n",
diff --git a/fs/gfs2/inode.h b/fs/gfs2/inode.h
index 300ada3..15ff4df 100644
--- a/fs/gfs2/inode.h
+++ b/fs/gfs2/inode.h
@@ -80,6 +80,19 @@ static inline void gfs2_inum_out(const struct gfs2_inode *ip,
 	dent->de_inum.no_addr = cpu_to_be64(ip->i_no_addr);
 }
 
+static inline int gfs2_check_internal_file_size(struct inode *inode,
+						u64 minsize, u64 maxsize)
+{
+	u64 size = i_size_read(inode);
+	if (size < minsize || size > maxsize)
+		goto err;
+	if (size & ((1 << inode->i_blkbits) - 1))
+		goto err;
+	return 0;
+err:
+	gfs2_consist_inode(GFS2_I(inode));
+	return -EIO;
+}
 
 extern void gfs2_set_iop(struct inode *inode);
 extern struct inode *gfs2_inode_lookup(struct super_block *sb, unsigned type, 
diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index 4d4b1e8..5b5c87d 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -586,7 +586,7 @@ static int map_journal_extents(struct gfs2_sbd *sdp)
 
 	prev_db = 0;
 
-	for (lb = 0; lb < ip->i_disksize >> sdp->sd_sb.sb_bsize_shift; lb++) {
+	for (lb = 0; lb < i_size_read(jd->jd_inode) >> sdp->sd_sb.sb_bsize_shift; lb++) {
 		bh.b_state = 0;
 		bh.b_blocknr = 0;
 		bh.b_size = 1 << ip->i_inode.i_blkbits;
diff --git a/fs/gfs2/ops_inode.c b/fs/gfs2/ops_inode.c
index 1d3f2fb..ee6ffd5 100644
--- a/fs/gfs2/ops_inode.c
+++ b/fs/gfs2/ops_inode.c
@@ -406,7 +406,6 @@ static int gfs2_symlink(struct inode *dir, struct dentry *dentry,
 
 	ip = ghs[1].gh_gl->gl_object;
 
-	ip->i_disksize = size;
 	i_size_write(inode, size);
 
 	error = gfs2_meta_inode_buffer(ip, &dibh);
@@ -461,7 +460,7 @@ static int gfs2_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 	ip = ghs[1].gh_gl->gl_object;
 
 	ip->i_inode.i_nlink = 2;
-	ip->i_disksize = sdp->sd_sb.sb_bsize - sizeof(struct gfs2_dinode);
+	i_size_write(inode, sdp->sd_sb.sb_bsize - sizeof(struct gfs2_dinode));
 	ip->i_diskflags |= GFS2_DIF_JDATA;
 	ip->i_entries = 2;
 
@@ -990,7 +989,7 @@ static void *gfs2_follow_link(struct dentry *dentry, struct nameidata *nd)
 	struct gfs2_inode *ip = GFS2_I(dentry->d_inode);
 	struct gfs2_holder i_gh;
 	struct buffer_head *dibh;
-	unsigned int x;
+	unsigned int x, size;
 	char *buf;
 	int error;
 
@@ -1002,7 +1001,8 @@ static void *gfs2_follow_link(struct dentry *dentry, struct nameidata *nd)
 		return NULL;
 	}
 
-	if (!ip->i_disksize) {
+	size = (unsigned int)i_size_read(&ip->i_inode);
+	if (size == 0) {
 		gfs2_consist_inode(ip);
 		buf = ERR_PTR(-EIO);
 		goto out;
@@ -1014,7 +1014,7 @@ static void *gfs2_follow_link(struct dentry *dentry, struct nameidata *nd)
 		goto out;
 	}
 
-	x = ip->i_disksize + 1;
+	x = size + 1;
 	buf = kmalloc(x, GFP_NOFS);
 	if (!buf)
 		buf = ERR_PTR(-ENOMEM);
diff --git a/fs/gfs2/quota.c b/fs/gfs2/quota.c
index 1bc6b56..9bc6dd9 100644
--- a/fs/gfs2/quota.c
+++ b/fs/gfs2/quota.c
@@ -735,10 +735,8 @@ get_a_page:
 		goto out;
 
 	size = loc + sizeof(struct gfs2_quota);
-	if (size > inode->i_size) {
-		ip->i_disksize = size;
+	if (size > inode->i_size)
 		i_size_write(inode, size);
-	}
 	inode->i_mtime = inode->i_atime = CURRENT_TIME;
 	gfs2_trans_add_bh(ip->i_gl, dibh, 1);
 	gfs2_dinode_out(ip, dibh->b_data);
@@ -1190,18 +1188,17 @@ static void gfs2_quota_change_in(struct gfs2_quota_change_host *qc, const void *
 int gfs2_quota_init(struct gfs2_sbd *sdp)
 {
 	struct gfs2_inode *ip = GFS2_I(sdp->sd_qc_inode);
-	unsigned int blocks = ip->i_disksize >> sdp->sd_sb.sb_bsize_shift;
+	u64 size = i_size_read(sdp->sd_qc_inode);
+	unsigned int blocks = size >> sdp->sd_sb.sb_bsize_shift;
 	unsigned int x, slot = 0;
 	unsigned int found = 0;
 	u64 dblock;
 	u32 extlen = 0;
 	int error;
 
-	if (!ip->i_disksize || ip->i_disksize > (64 << 20) ||
-	    ip->i_disksize & (sdp->sd_sb.sb_bsize - 1)) {
-		gfs2_consist_inode(ip);
+	if (gfs2_check_internal_file_size(sdp->sd_qc_inode, 1, 64 << 20))
 		return -EIO;
-	}
+
 	sdp->sd_quota_slots = blocks * sdp->sd_qc_per_block;
 	sdp->sd_quota_chunks = DIV_ROUND_UP(sdp->sd_quota_slots, 8 * PAGE_SIZE);
 
diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index 171a744..370c29b 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -500,7 +500,7 @@ u64 gfs2_ri_total(struct gfs2_sbd *sdp)
 	for (rgrps = 0;; rgrps++) {
 		loff_t pos = rgrps * sizeof(struct gfs2_rindex);
 
-		if (pos + sizeof(struct gfs2_rindex) >= ip->i_disksize)
+		if (pos + sizeof(struct gfs2_rindex) >= i_size_read(inode))
 			break;
 		error = gfs2_internal_read(ip, &ra_state, buf, &pos,
 					   sizeof(struct gfs2_rindex));
@@ -588,7 +588,7 @@ static int gfs2_ri_update(struct gfs2_inode *ip)
 	struct gfs2_sbd *sdp = GFS2_SB(&ip->i_inode);
 	struct inode *inode = &ip->i_inode;
 	struct file_ra_state ra_state;
-	u64 rgrp_count = ip->i_disksize;
+	u64 rgrp_count = i_size_read(inode);
 	int error;
 
 	do_div(rgrp_count, sizeof(struct gfs2_rindex));
@@ -628,7 +628,7 @@ static int gfs2_ri_update_special(struct gfs2_inode *ip)
 	for (sdp->sd_rgrps = 0;; sdp->sd_rgrps++) {
 		/* Ignore partials */
 		if ((sdp->sd_rgrps + 1) * sizeof(struct gfs2_rindex) >
-		    ip->i_disksize)
+		    i_size_read(inode))
 			break;
 		error = read_rindex_entry(ip, &ra_state);
 		if (error) {
diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index 77cb9f8..e031fa4 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -342,15 +342,14 @@ int gfs2_jdesc_check(struct gfs2_jdesc *jd)
 {
 	struct gfs2_inode *ip = GFS2_I(jd->jd_inode);
 	struct gfs2_sbd *sdp = GFS2_SB(jd->jd_inode);
+	u64 size = i_size_read(jd->jd_inode);
 
-	if (ip->i_disksize < (8 << 20) || ip->i_disksize > (1 << 30) ||
-	    (ip->i_disksize & (sdp->sd_sb.sb_bsize - 1))) {
-		gfs2_consist_inode(ip);
+	if (gfs2_check_internal_file_size(jd->jd_inode, 8 << 20, 1 << 30))
 		return -EIO;
-	}
-	jd->jd_blocks = ip->i_disksize >> sdp->sd_sb.sb_bsize_shift;
 
-	if (gfs2_write_alloc_required(ip, 0, ip->i_disksize)) {
+	jd->jd_blocks = size >> sdp->sd_sb.sb_bsize_shift;
+
+	if (gfs2_write_alloc_required(ip, 0, size)) {
 		gfs2_consist_inode(ip);
 		return -EIO;
 	}
-- 
1.7.1.1

