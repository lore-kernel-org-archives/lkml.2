Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932377Ab1JXMri (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 08:47:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60415 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932288Ab1JXMrf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 08:47:35 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 07/24] GFS2: Use ->dirty_inode()
Date: Mon, 24 Oct 2011 13:48:21 +0100
Message-Id: <1319460518-9046-8-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1319460518-9046-1-git-send-email-swhiteho@redhat.com>
References: <1319460518-9046-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The aim of this patch is to use the newly enhanced ->dirty_inode()
super block operation to deal with atime updates, rather than
piggy backing that code into ->write_inode() as is currently
done.

The net result is a simplification of the code in various places
and a reduction of the number of gfs2_dinode_out() calls since
this is now implied by ->dirty_inode().

Some of the mark_inode_dirty() calls have been moved under glocks
in order to take advantage of then being able to avoid locking in
->dirty_inode() when we already have suitable locks.

One consequence is that generic_write_end() now correctly deals
with file size updates, so that we do not need a separate check
for that afterwards. This also, indirectly, means that fdatasync
should work correctly on GFS2 - the current code always syncs the
metadata whether it needs to or not.

Has survived testing with postmark (with and without atime) and
also fsx.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/acl.c b/fs/gfs2/acl.c
index 34501b6..65978d7 100644
--- a/fs/gfs2/acl.c
+++ b/fs/gfs2/acl.c
@@ -82,7 +82,7 @@ static int gfs2_set_mode(struct inode *inode, umode_t mode)
 		iattr.ia_valid = ATTR_MODE;
 		iattr.ia_mode = mode;
 
-		error = gfs2_setattr_simple(GFS2_I(inode), &iattr);
+		error = gfs2_setattr_simple(inode, &iattr);
 	}
 
 	return error;
@@ -160,6 +160,7 @@ out:
 
 int gfs2_acl_chmod(struct gfs2_inode *ip, struct iattr *attr)
 {
+	struct inode *inode = &ip->i_inode;
 	struct posix_acl *acl;
 	char *data;
 	unsigned int len;
@@ -169,7 +170,7 @@ int gfs2_acl_chmod(struct gfs2_inode *ip, struct iattr *attr)
 	if (IS_ERR(acl))
 		return PTR_ERR(acl);
 	if (!acl)
-		return gfs2_setattr_simple(ip, attr);
+		return gfs2_setattr_simple(inode, attr);
 
 	error = posix_acl_chmod(&acl, GFP_NOFS, attr->ia_mode);
 	if (error)
diff --git a/fs/gfs2/aops.c b/fs/gfs2/aops.c
index f9fbbe9..212fe74 100644
--- a/fs/gfs2/aops.c
+++ b/fs/gfs2/aops.c
@@ -787,7 +787,6 @@ static int gfs2_stuffed_write_end(struct inode *inode, struct buffer_head *dibh,
 	u64 to = pos + copied;
 	void *kaddr;
 	unsigned char *buf = dibh->b_data + sizeof(struct gfs2_dinode);
-	struct gfs2_dinode *di = (struct gfs2_dinode *)dibh->b_data;
 
 	BUG_ON((pos + len) > (dibh->b_size - sizeof(struct gfs2_dinode)));
 	kaddr = kmap_atomic(page, KM_USER0);
@@ -804,7 +803,6 @@ static int gfs2_stuffed_write_end(struct inode *inode, struct buffer_head *dibh,
 	if (copied) {
 		if (inode->i_size < to)
 			i_size_write(inode, to);
-		gfs2_dinode_out(ip, di);
 		mark_inode_dirty(inode);
 	}
 
@@ -873,10 +871,6 @@ static int gfs2_write_end(struct file *file, struct address_space *mapping,
 		gfs2_page_add_databufs(ip, page, from, to);
 
 	ret = generic_write_end(file, mapping, pos, len, copied, page, fsdata);
-	if (ret > 0) {
-		gfs2_dinode_out(ip, dibh->b_data);
-		mark_inode_dirty(inode);
-	}
 
 	if (inode == sdp->sd_rindex) {
 		adjust_fs_space(inode);
diff --git a/fs/gfs2/dir.c b/fs/gfs2/dir.c
index 2045d70..898e62e 100644
--- a/fs/gfs2/dir.c
+++ b/fs/gfs2/dir.c
@@ -1681,7 +1681,6 @@ int gfs2_dir_del(struct gfs2_inode *dip, const struct dentry *dentry)
 	const struct qstr *name = &dentry->d_name;
 	struct gfs2_dirent *dent, *prev = NULL;
 	struct buffer_head *bh;
-	int error;
 
 	/* Returns _either_ the entry (if its first in block) or the
 	   previous entry otherwise */
@@ -1710,22 +1709,15 @@ int gfs2_dir_del(struct gfs2_inode *dip, const struct dentry *dentry)
 	}
 	brelse(bh);
 
-	error = gfs2_meta_inode_buffer(dip, &bh);
-	if (error)
-		return error;
-
 	if (!dip->i_entries)
 		gfs2_consist_inode(dip);
-	gfs2_trans_add_bh(dip->i_gl, bh, 1);
 	dip->i_entries--;
 	dip->i_inode.i_mtime = dip->i_inode.i_ctime = CURRENT_TIME;
 	if (S_ISDIR(dentry->d_inode->i_mode))
 		drop_nlink(&dip->i_inode);
-	gfs2_dinode_out(dip, bh->b_data);
-	brelse(bh);
 	mark_inode_dirty(&dip->i_inode);
 
-	return error;
+	return 0;
 }
 
 /**
diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
index 9d12286..4416a1c 100644
--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -802,7 +802,6 @@ static int fallocate_chunk(struct inode *inode, loff_t offset, loff_t len,
 		from = 0;
 	}
 
-	gfs2_dinode_out(ip, dibh->b_data);
 	mark_inode_dirty(inode);
 
 	brelse(dibh);
diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index 044efe2..a0b53d3 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -729,8 +729,8 @@ static int gfs2_create_inode(struct inode *dir, struct dentry *dentry,
 		gfs2_inplace_release(dip);
 	gfs2_quota_unlock(dip);
 	gfs2_alloc_put(dip);
-	gfs2_glock_dq_uninit_m(2, ghs);
 	mark_inode_dirty(inode);
+	gfs2_glock_dq_uninit_m(2, ghs);
 	d_instantiate(dentry, inode);
 	return 0;
 
@@ -926,8 +926,9 @@ static int gfs2_link(struct dentry *old_dentry, struct inode *dir,
 	gfs2_trans_add_bh(ip->i_gl, dibh, 1);
 	inc_nlink(&ip->i_inode);
 	ip->i_inode.i_ctime = CURRENT_TIME;
-	gfs2_dinode_out(ip, dibh->b_data);
-	mark_inode_dirty(&ip->i_inode);
+	ihold(inode);
+	d_instantiate(dentry, inode);
+	mark_inode_dirty(inode);
 
 out_brelse:
 	brelse(dibh);
@@ -949,11 +950,6 @@ out_child:
 out_parent:
 	gfs2_holder_uninit(ghs);
 	gfs2_holder_uninit(ghs + 1);
-	if (!error) {
-		ihold(inode);
-		d_instantiate(dentry, inode);
-		mark_inode_dirty(inode);
-	}
 	return error;
 }
 
@@ -1026,8 +1022,6 @@ static int gfs2_unlink_inode(struct gfs2_inode *dip,
 		clear_nlink(inode);
 	else
 		drop_nlink(inode);
-	gfs2_trans_add_bh(ip->i_gl, bh, 1);
-	gfs2_dinode_out(ip, bh->b_data);
 	mark_inode_dirty(inode);
 	if (inode->i_nlink == 0)
 		gfs2_unlink_di(inode);
@@ -1565,21 +1559,10 @@ int gfs2_permission(struct inode *inode, int mask)
 	return error;
 }
 
-static int __gfs2_setattr_simple(struct gfs2_inode *ip, struct iattr *attr)
+static int __gfs2_setattr_simple(struct inode *inode, struct iattr *attr)
 {
-	struct inode *inode = &ip->i_inode;
-	struct buffer_head *dibh;
-	int error;
-
-	error = gfs2_meta_inode_buffer(ip, &dibh);
-	if (error)
-		return error;
-
 	setattr_copy(inode, attr);
 	mark_inode_dirty(inode);
-	gfs2_trans_add_bh(ip->i_gl, dibh, 1);
-	gfs2_dinode_out(ip, dibh->b_data);
-	brelse(dibh);
 	return 0;
 }
 
@@ -1591,19 +1574,19 @@ static int __gfs2_setattr_simple(struct gfs2_inode *ip, struct iattr *attr)
  * Returns: errno
  */
 
-int gfs2_setattr_simple(struct gfs2_inode *ip, struct iattr *attr)
+int gfs2_setattr_simple(struct inode *inode, struct iattr *attr)
 {
 	int error;
 
 	if (current->journal_info)
-		return __gfs2_setattr_simple(ip, attr);
+		return __gfs2_setattr_simple(inode, attr);
 
-	error = gfs2_trans_begin(GFS2_SB(&ip->i_inode), RES_DINODE, 0);
+	error = gfs2_trans_begin(GFS2_SB(inode), RES_DINODE, 0);
 	if (error)
 		return error;
 
-	error = __gfs2_setattr_simple(ip, attr);
-	gfs2_trans_end(GFS2_SB(&ip->i_inode));
+	error = __gfs2_setattr_simple(inode, attr);
+	gfs2_trans_end(GFS2_SB(inode));
 	return error;
 }
 
@@ -1641,7 +1624,7 @@ static int setattr_chown(struct inode *inode, struct iattr *attr)
 	if (error)
 		goto out_gunlock_q;
 
-	error = gfs2_setattr_simple(ip, attr);
+	error = gfs2_setattr_simple(inode, attr);
 	if (error)
 		goto out_end_trans;
 
@@ -1697,12 +1680,12 @@ static int gfs2_setattr(struct dentry *dentry, struct iattr *attr)
 	else if ((attr->ia_valid & ATTR_MODE) && IS_POSIXACL(inode))
 		error = gfs2_acl_chmod(ip, attr);
 	else
-		error = gfs2_setattr_simple(ip, attr);
+		error = gfs2_setattr_simple(inode, attr);
 
 out:
-	gfs2_glock_dq_uninit(&i_gh);
 	if (!error)
 		mark_inode_dirty(inode);
+	gfs2_glock_dq_uninit(&i_gh);
 	return error;
 }
 
diff --git a/fs/gfs2/inode.h b/fs/gfs2/inode.h
index 8d90e0c..276e7b5 100644
--- a/fs/gfs2/inode.h
+++ b/fs/gfs2/inode.h
@@ -109,7 +109,7 @@ extern int gfs2_inode_refresh(struct gfs2_inode *ip);
 extern struct inode *gfs2_lookupi(struct inode *dir, const struct qstr *name,
 				  int is_root);
 extern int gfs2_permission(struct inode *inode, int mask);
-extern int gfs2_setattr_simple(struct gfs2_inode *ip, struct iattr *attr);
+extern int gfs2_setattr_simple(struct inode *inode, struct iattr *attr);
 extern struct inode *gfs2_lookup_simple(struct inode *dip, const char *name);
 extern void gfs2_dinode_out(const struct gfs2_inode *ip, void *buf);
 
diff --git a/fs/gfs2/quota.c b/fs/gfs2/quota.c
index 0e8bb13..3a9a974 100644
--- a/fs/gfs2/quota.c
+++ b/fs/gfs2/quota.c
@@ -638,7 +638,7 @@ static int gfs2_adjust_quota(struct gfs2_inode *ip, loff_t loc,
 	unsigned long index = loc >> PAGE_CACHE_SHIFT;
 	unsigned offset = loc & (PAGE_CACHE_SIZE - 1);
 	unsigned blocksize, iblock, pos;
-	struct buffer_head *bh, *dibh;
+	struct buffer_head *bh;
 	struct page *page;
 	void *kaddr, *ptr;
 	struct gfs2_quota q, *qp;
@@ -736,22 +736,13 @@ get_a_page:
 		goto get_a_page;
 	}
 
-	/* Update the disk inode timestamp and size (if extended) */
-	err = gfs2_meta_inode_buffer(ip, &dibh);
-	if (err)
-		goto out;
-
 	size = loc + sizeof(struct gfs2_quota);
 	if (size > inode->i_size)
 		i_size_write(inode, size);
 	inode->i_mtime = inode->i_atime = CURRENT_TIME;
-	gfs2_trans_add_bh(ip->i_gl, dibh, 1);
-	gfs2_dinode_out(ip, dibh->b_data);
-	brelse(dibh);
 	mark_inode_dirty(inode);
-
-out:
 	return err;
+
 unlock_out:
 	unlock_page(page);
 	page_cache_release(page);
diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index 9961de7..b05fa59 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -752,47 +752,15 @@ static int gfs2_write_inode(struct inode *inode, struct writeback_control *wbc)
 	struct gfs2_sbd *sdp = GFS2_SB(inode);
 	struct address_space *metamapping = gfs2_glock2aspace(ip->i_gl);
 	struct backing_dev_info *bdi = metamapping->backing_dev_info;
-	struct gfs2_holder gh;
-	struct buffer_head *bh;
-	struct timespec atime;
-	struct gfs2_dinode *di;
-	int ret = -EAGAIN;
-	int unlock_required = 0;
-
-	/* Skip timestamp update, if this is from a memalloc */
-	if (current->flags & PF_MEMALLOC)
-		goto do_flush;
-	if (!gfs2_glock_is_locked_by_me(ip->i_gl)) {
-		ret = gfs2_glock_nq_init(ip->i_gl, LM_ST_EXCLUSIVE, 0, &gh);
-		if (ret)
-			goto do_flush;
-		unlock_required = 1;
-	}
-	ret = gfs2_meta_inode_buffer(ip, &bh);
-	if (ret == 0) {
-		di = (struct gfs2_dinode *)bh->b_data;
-		atime.tv_sec = be64_to_cpu(di->di_atime);
-		atime.tv_nsec = be32_to_cpu(di->di_atime_nsec);
-		if (timespec_compare(&inode->i_atime, &atime) > 0) {
-			ret = gfs2_trans_begin(sdp, RES_DINODE, 0);
-			if (ret == 0) {
-				gfs2_trans_add_bh(ip->i_gl, bh, 1);
-				gfs2_dinode_out(ip, bh->b_data);
-				gfs2_trans_end(sdp);
-			}
-		}
-		brelse(bh);
-	}
-	if (unlock_required)
-		gfs2_glock_dq_uninit(&gh);
-do_flush:
+	int ret = 0;
+
 	if (wbc->sync_mode == WB_SYNC_ALL)
 		gfs2_log_flush(GFS2_SB(inode), ip->i_gl);
 	if (bdi->dirty_exceeded)
 		gfs2_ail1_flush(sdp, wbc);
 	else
 		filemap_fdatawrite(metamapping);
-	if (!ret && (wbc->sync_mode == WB_SYNC_ALL))
+	if (wbc->sync_mode == WB_SYNC_ALL)
 		ret = filemap_fdatawait(metamapping);
 	if (ret)
 		mark_inode_dirty_sync(inode);
@@ -800,6 +768,64 @@ do_flush:
 }
 
 /**
+ * gfs2_dirty_inode - check for atime updates
+ * @inode: The inode in question
+ * @flags: The type of dirty
+ *
+ * Unfortunately it can be called under any combination of inode
+ * glock and transaction lock, so we have to check carefully.
+ *
+ * At the moment this deals only with atime - it should be possible
+ * to expand that role in future, once a review of the locking has
+ * been carried out.
+ */
+
+static void gfs2_dirty_inode(struct inode *inode, int flags)
+{
+	struct gfs2_inode *ip = GFS2_I(inode);
+	struct gfs2_sbd *sdp = GFS2_SB(inode);
+	struct buffer_head *bh;
+	struct gfs2_holder gh;
+	int need_unlock = 0;
+	int need_endtrans = 0;
+	int ret;
+
+	if (!(flags & (I_DIRTY_DATASYNC|I_DIRTY_SYNC)))
+		return;
+
+	if (!gfs2_glock_is_locked_by_me(ip->i_gl)) {
+		ret = gfs2_glock_nq_init(ip->i_gl, LM_ST_EXCLUSIVE, 0, &gh);
+		if (ret) {
+			fs_err(sdp, "dirty_inode: glock %d\n", ret);
+			return;
+		}
+		need_unlock = 1;
+	}
+
+	if (current->journal_info == NULL) {
+		ret = gfs2_trans_begin(sdp, RES_DINODE, 0);
+		if (ret) {
+			fs_err(sdp, "dirty_inode: gfs2_trans_begin %d\n", ret);
+			goto out;
+		}
+		need_endtrans = 1;
+	}
+
+	ret = gfs2_meta_inode_buffer(ip, &bh);
+	if (ret == 0) {
+		gfs2_trans_add_bh(ip->i_gl, bh, 1);
+		gfs2_dinode_out(ip, bh->b_data);
+		brelse(bh);
+	}
+
+	if (need_endtrans)
+		gfs2_trans_end(sdp);
+out:
+	if (need_unlock)
+		gfs2_glock_dq_uninit(&gh);
+}
+
+/**
  * gfs2_make_fs_ro - Turn a Read-Write FS into a Read-Only one
  * @sdp: the filesystem
  *
@@ -1578,6 +1604,7 @@ const struct super_operations gfs2_super_ops = {
 	.alloc_inode		= gfs2_alloc_inode,
 	.destroy_inode		= gfs2_destroy_inode,
 	.write_inode		= gfs2_write_inode,
+	.dirty_inode		= gfs2_dirty_inode,
 	.evict_inode		= gfs2_evict_inode,
 	.put_super		= gfs2_put_super,
 	.sync_fs		= gfs2_sync_fs,
diff --git a/fs/gfs2/xattr.c b/fs/gfs2/xattr.c
index 439b61c..695304c 100644
--- a/fs/gfs2/xattr.c
+++ b/fs/gfs2/xattr.c
@@ -1296,7 +1296,8 @@ fail:
 
 int gfs2_xattr_acl_chmod(struct gfs2_inode *ip, struct iattr *attr, char *data)
 {
-	struct gfs2_sbd *sdp = GFS2_SB(&ip->i_inode);
+	struct inode *inode = &ip->i_inode;
+	struct gfs2_sbd *sdp = GFS2_SB(inode);
 	struct gfs2_ea_location el;
 	int error;
 
@@ -1319,7 +1320,7 @@ int gfs2_xattr_acl_chmod(struct gfs2_inode *ip, struct iattr *attr, char *data)
 	if (error)
 		return error;
 
-	error = gfs2_setattr_simple(ip, attr);
+	error = gfs2_setattr_simple(inode, attr);
 	gfs2_trans_end(sdp);
 	return error;
 }
-- 
1.7.4.4

