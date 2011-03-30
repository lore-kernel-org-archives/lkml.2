Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965452Ab1C3WDf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 18:03:35 -0400
Received: from cobra.newdream.net ([66.33.216.30]:43168 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933313Ab1C3WB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 18:01:57 -0400
From: Sage Weil <sage@newdream.net>
To: viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, mszeredi@suse.cz,
        Sage Weil <sage@newdream.net>
Subject: [PATCH 3/7] vfs: push dentry_unhash on rmdir into file systems
Date: Wed, 30 Mar 2011 15:09:24 -0700
Message-Id: <1301522968-4382-4-git-send-email-sage@newdream.net>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1301522968-4382-1-git-send-email-sage@newdream.net>
References: <1301522968-4382-1-git-send-email-sage@newdream.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Only a few file systems need this.  Start by pushing it down into each
fs rmdir method so it can be dealt with on a per-fs basis.

This does not change behavior for any in-tree file systems.

Signed-off-by: Sage Weil <sage@newdream.net>
---
 fs/9p/vfs_inode.c       |    1 +
 fs/affs/namei.c         |    2 ++
 fs/afs/dir.c            |    2 ++
 fs/autofs4/root.c       |    2 ++
 fs/btrfs/inode.c        |    2 ++
 fs/ceph/dir.c           |    3 +++
 fs/cifs/inode.c         |    2 ++
 fs/coda/dir.c           |    2 ++
 fs/configfs/dir.c       |    2 ++
 fs/ecryptfs/inode.c     |    2 ++
 fs/exofs/namei.c        |    2 ++
 fs/ext2/namei.c         |    2 ++
 fs/ext3/namei.c         |    2 ++
 fs/ext4/namei.c         |    2 ++
 fs/fat/namei_msdos.c    |    2 ++
 fs/fat/namei_vfat.c     |    2 ++
 fs/fuse/dir.c           |    2 ++
 fs/gfs2/ops_inode.c     |    2 ++
 fs/hfs/dir.c            |    3 +++
 fs/hfsplus/dir.c        |    2 ++
 fs/hostfs/hostfs_kern.c |    2 ++
 fs/hpfs/namei.c         |    2 ++
 fs/jffs2/dir.c          |    2 ++
 fs/jfs/namei.c          |    2 ++
 fs/libfs.c              |    2 ++
 fs/logfs/dir.c          |    2 ++
 fs/minix/namei.c        |    2 ++
 fs/namei.c              |    1 -
 fs/ncpfs/dir.c          |    2 ++
 fs/nfs/dir.c            |    2 ++
 fs/nilfs2/namei.c       |    2 ++
 fs/ocfs2/namei.c        |    3 +++
 fs/omfs/dir.c           |    2 ++
 fs/reiserfs/namei.c     |    2 ++
 fs/sysv/namei.c         |    2 ++
 fs/ubifs/dir.c          |    2 ++
 fs/udf/namei.c          |    2 ++
 fs/ufs/namei.c          |    2 ++
 38 files changed, 76 insertions(+), 1 deletions(-)

diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index b76a40b..eb83ad1 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -731,6 +731,7 @@ int v9fs_vfs_unlink(struct inode *i, struct dentry *d)
 
 int v9fs_vfs_rmdir(struct inode *i, struct dentry *d)
 {
+	dentry_unhash(d);
 	return v9fs_remove(i, d, 1);
 }
 
diff --git a/fs/affs/namei.c b/fs/affs/namei.c
index e3e9efc..d087153 100644
--- a/fs/affs/namei.c
+++ b/fs/affs/namei.c
@@ -320,6 +320,8 @@ affs_rmdir(struct inode *dir, struct dentry *dentry)
 		 dentry->d_inode->i_ino,
 		 (int)dentry->d_name.len, dentry->d_name.name);
 
+	dentry_unhash(dentry);
+
 	return affs_remove_header(dentry);
 }
 
diff --git a/fs/afs/dir.c b/fs/afs/dir.c
index 20c106f..9a7f414 100644
--- a/fs/afs/dir.c
+++ b/fs/afs/dir.c
@@ -845,6 +845,8 @@ static int afs_rmdir(struct inode *dir, struct dentry *dentry)
 	_enter("{%x:%u},{%s}",
 	       dvnode->fid.vid, dvnode->fid.vnode, dentry->d_name.name);
 
+	dentry_unhash(dentry);
+
 	ret = -ENAMETOOLONG;
 	if (dentry->d_name.len >= AFSNAMEMAX)
 		goto error;
diff --git a/fs/autofs4/root.c b/fs/autofs4/root.c
index 014e7ab..64415f4 100644
--- a/fs/autofs4/root.c
+++ b/fs/autofs4/root.c
@@ -600,6 +600,8 @@ static int autofs4_dir_unlink(struct inode *dir, struct dentry *dentry)
 	if (!autofs4_oz_mode(sbi) && !capable(CAP_SYS_ADMIN))
 		return -EACCES;
 
+	dentry_unhash(dentry);
+
 	if (atomic_dec_and_test(&ino->count)) {
 		p_ino = autofs4_dentry_ino(dentry->d_parent);
 		if (p_ino && dentry->d_parent != dentry)
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 9007bbd..bd3527b 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3005,6 +3005,8 @@ static int btrfs_rmdir(struct inode *dir, struct dentry *dentry)
 	    inode->i_ino == BTRFS_FIRST_FREE_OBJECTID)
 		return -ENOTEMPTY;
 
+	dentry_unhash(dentry);
+
 	trans = __unlink_start_trans(dir, dentry);
 	if (IS_ERR(trans))
 		return PTR_ERR(trans);
diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
index ebafa65..c1d9d6f 100644
--- a/fs/ceph/dir.c
+++ b/fs/ceph/dir.c
@@ -824,6 +824,9 @@ static int ceph_unlink(struct inode *dir, struct dentry *dentry)
 	int err = -EROFS;
 	int op;
 
+	if ((dentry->d_inode->i_mode & S_IFMT) == S_IFDIR)
+		dentry_unhash(dentry);
+
 	if (ceph_snap(dir) == CEPH_SNAPDIR) {
 		/* rmdir .snap/foo is RMSNAP */
 		dout("rmsnap dir %p '%.*s' dn %p\n", dir, dentry->d_name.len,
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 8852470..cee5896 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -1461,6 +1461,8 @@ int cifs_rmdir(struct inode *inode, struct dentry *direntry)
 
 	cFYI(1, "cifs_rmdir, inode = 0x%p", inode);
 
+	dentry_unhash(direntry);
+
 	xid = GetXid();
 
 	full_path = build_path_from_dentry(direntry);
diff --git a/fs/coda/dir.c b/fs/coda/dir.c
index 2b8dae4..9f72b75 100644
--- a/fs/coda/dir.c
+++ b/fs/coda/dir.c
@@ -336,6 +336,8 @@ static int coda_rmdir(struct inode *dir, struct dentry *de)
 	int len = de->d_name.len;
 	int error;
 
+	dentry_unhash(de);
+
 	error = venus_rmdir(dir->i_sb, coda_i2f(dir), name, len);
 	if (!error) {
 		/* VFS may delete the child */
diff --git a/fs/configfs/dir.c b/fs/configfs/dir.c
index 90ff3cb..468c77c 100644
--- a/fs/configfs/dir.c
+++ b/fs/configfs/dir.c
@@ -1355,6 +1355,8 @@ static int configfs_rmdir(struct inode *dir, struct dentry *dentry)
 	struct module *subsys_owner = NULL, *dead_item_owner = NULL;
 	int ret;
 
+	dentry_unhash(dentry);
+
 	if (dentry->d_parent == configfs_sb->s_root)
 		return -EPERM;
 
diff --git a/fs/ecryptfs/inode.c b/fs/ecryptfs/inode.c
index b592938..6f8a00b 100644
--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -556,6 +556,8 @@ static int ecryptfs_rmdir(struct inode *dir, struct dentry *dentry)
 	struct dentry *lower_dir_dentry;
 	int rc;
 
+	dentry_unhash(dentry);
+
 	lower_dentry = ecryptfs_dentry_to_lower(dentry);
 	dget(dentry);
 	lower_dir_dentry = lock_parent(lower_dentry);
diff --git a/fs/exofs/namei.c b/fs/exofs/namei.c
index 4d70db1..0697175 100644
--- a/fs/exofs/namei.c
+++ b/fs/exofs/namei.c
@@ -227,6 +227,8 @@ static int exofs_rmdir(struct inode *dir, struct dentry *dentry)
 	struct inode *inode = dentry->d_inode;
 	int err = -ENOTEMPTY;
 
+	dentry_unhash(dentry);
+
 	if (exofs_empty_dir(inode)) {
 		err = exofs_unlink(dir, dentry);
 		if (!err) {
diff --git a/fs/ext2/namei.c b/fs/ext2/namei.c
index adb9185..23aa4b3 100644
--- a/fs/ext2/namei.c
+++ b/fs/ext2/namei.c
@@ -296,6 +296,8 @@ static int ext2_rmdir (struct inode * dir, struct dentry *dentry)
 	struct inode * inode = dentry->d_inode;
 	int err = -ENOTEMPTY;
 
+	dentry_unhash(dentry);
+
 	if (ext2_empty_dir(inode)) {
 		err = ext2_unlink(dir, dentry);
 		if (!err) {
diff --git a/fs/ext3/namei.c b/fs/ext3/namei.c
index b27ba71..3256f48 100644
--- a/fs/ext3/namei.c
+++ b/fs/ext3/namei.c
@@ -2074,6 +2074,8 @@ static int ext3_rmdir (struct inode * dir, struct dentry *dentry)
 	struct ext3_dir_entry_2 * de;
 	handle_t *handle;
 
+	dentry_unhash(dentry);
+
 	/* Initialize quotas before so that eventual writes go in
 	 * separate transaction */
 	dquot_initialize(dir);
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 5485390..39a93c2 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2122,6 +2122,8 @@ static int ext4_rmdir(struct inode *dir, struct dentry *dentry)
 	struct ext4_dir_entry_2 *de;
 	handle_t *handle;
 
+	dentry_unhash(dentry);
+
 	/* Initialize quotas before so that eventual writes go in
 	 * separate transaction */
 	dquot_initialize(dir);
diff --git a/fs/fat/namei_msdos.c b/fs/fat/namei_msdos.c
index 7114990..0c25cea 100644
--- a/fs/fat/namei_msdos.c
+++ b/fs/fat/namei_msdos.c
@@ -326,6 +326,8 @@ static int msdos_rmdir(struct inode *dir, struct dentry *dentry)
 	struct fat_slot_info sinfo;
 	int err;
 
+	dentry_unhash(dentry);
+
 	lock_super(sb);
 	/*
 	 * Check whether the directory is not in use, then check
diff --git a/fs/fat/namei_vfat.c b/fs/fat/namei_vfat.c
index adae3fb..d7b9383 100644
--- a/fs/fat/namei_vfat.c
+++ b/fs/fat/namei_vfat.c
@@ -824,6 +824,8 @@ static int vfat_rmdir(struct inode *dir, struct dentry *dentry)
 	struct fat_slot_info sinfo;
 	int err;
 
+	dentry_unhash(dentry);
+
 	lock_super(sb);
 
 	err = fat_dir_empty(inode);
diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index 8bd0ef9..4459fda 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -667,6 +667,8 @@ static int fuse_rmdir(struct inode *dir, struct dentry *entry)
 	if (IS_ERR(req))
 		return PTR_ERR(req);
 
+	dentry_unhash(entry);
+
 	req->in.h.opcode = FUSE_RMDIR;
 	req->in.h.nodeid = get_node_id(dir);
 	req->in.numargs = 1;
diff --git a/fs/gfs2/ops_inode.c b/fs/gfs2/ops_inode.c
index d8b26ac..6baa30f 100644
--- a/fs/gfs2/ops_inode.c
+++ b/fs/gfs2/ops_inode.c
@@ -572,6 +572,8 @@ static int gfs2_rmdir(struct inode *dir, struct dentry *dentry)
 	struct gfs2_holder ri_gh;
 	int error;
 
+	dentry_unhash(dentry);
+
 	error = gfs2_rindex_hold(sdp, &ri_gh);
 	if (error)
 		return error;
diff --git a/fs/hfs/dir.c b/fs/hfs/dir.c
index b4d70b1..616cfe0 100644
--- a/fs/hfs/dir.c
+++ b/fs/hfs/dir.c
@@ -253,6 +253,9 @@ static int hfs_remove(struct inode *dir, struct dentry *dentry)
 	struct inode *inode = dentry->d_inode;
 	int res;
 
+	if (S_ISDIR(inode->i_mode))
+		dentry_unhash(dentry);
+
 	if (S_ISDIR(inode->i_mode) && inode->i_size != 2)
 		return -ENOTEMPTY;
 	res = hfs_cat_delete(inode->i_ino, dir, &dentry->d_name);
diff --git a/fs/hfsplus/dir.c b/fs/hfsplus/dir.c
index 4df5059..23451a9 100644
--- a/fs/hfsplus/dir.c
+++ b/fs/hfsplus/dir.c
@@ -370,6 +370,8 @@ static int hfsplus_rmdir(struct inode *dir, struct dentry *dentry)
 	struct inode *inode = dentry->d_inode;
 	int res;
 
+	dentry_unhash(dentry);
+
 	if (inode->i_size != 2)
 		return -ENOTEMPTY;
 
diff --git a/fs/hostfs/hostfs_kern.c b/fs/hostfs/hostfs_kern.c
index 2638c83..73ea3ba 100644
--- a/fs/hostfs/hostfs_kern.c
+++ b/fs/hostfs/hostfs_kern.c
@@ -683,6 +683,8 @@ int hostfs_rmdir(struct inode *ino, struct dentry *dentry)
 	char *file;
 	int err;
 
+	dentry_unhash(dentry);
+
 	if ((file = dentry_name(dentry)) == NULL)
 		return -ENOMEM;
 	err = do_rmdir(file);
diff --git a/fs/hpfs/namei.c b/fs/hpfs/namei.c
index 00c8218..c6674ae 100644
--- a/fs/hpfs/namei.c
+++ b/fs/hpfs/namei.c
@@ -462,6 +462,8 @@ static int hpfs_rmdir(struct inode *dir, struct dentry *dentry)
 	int err;
 	int r;
 
+	dentry_unhash(dentry);
+
 	hpfs_adjust_length(name, &len);
 	lock_kernel();
 	mutex_lock(&hpfs_i(inode)->i_parent_mutex);
diff --git a/fs/jffs2/dir.c b/fs/jffs2/dir.c
index 9297865..4619ee4 100644
--- a/fs/jffs2/dir.c
+++ b/fs/jffs2/dir.c
@@ -610,6 +610,8 @@ static int jffs2_rmdir (struct inode *dir_i, struct dentry *dentry)
 	int ret;
 	uint32_t now = get_seconds();
 
+	dentry_unhash(dentry);
+
 	for (fd = f->dents ; fd; fd = fd->next) {
 		if (fd->ino)
 			return -ENOTEMPTY;
diff --git a/fs/jfs/namei.c b/fs/jfs/namei.c
index 5a2b269..32eebe6 100644
--- a/fs/jfs/namei.c
+++ b/fs/jfs/namei.c
@@ -360,6 +360,8 @@ static int jfs_rmdir(struct inode *dip, struct dentry *dentry)
 
 	jfs_info("jfs_rmdir: dip:0x%p name:%s", dip, dentry->d_name.name);
 
+	dentry_unhash(dentry);
+
 	/* Init inode for quota operations. */
 	dquot_initialize(dip);
 	dquot_initialize(ip);
diff --git a/fs/libfs.c b/fs/libfs.c
index c88eab5..1e2ba5a 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -311,6 +311,8 @@ int simple_rmdir(struct inode *dir, struct dentry *dentry)
 	if (!simple_empty(dentry))
 		return -ENOTEMPTY;
 
+	dentry_unhash(dentry);
+
 	drop_nlink(dentry->d_inode);
 	simple_unlink(dir, dentry);
 	drop_nlink(dir);
diff --git a/fs/logfs/dir.c b/fs/logfs/dir.c
index f9ddf0c..9a77518 100644
--- a/fs/logfs/dir.c
+++ b/fs/logfs/dir.c
@@ -273,6 +273,8 @@ static int logfs_rmdir(struct inode *dir, struct dentry *dentry)
 {
 	struct inode *inode = dentry->d_inode;
 
+	dentry_unhash(dentry);
+
 	if (!logfs_empty_dir(inode))
 		return -ENOTEMPTY;
 
diff --git a/fs/minix/namei.c b/fs/minix/namei.c
index 6e6777f..091626f 100644
--- a/fs/minix/namei.c
+++ b/fs/minix/namei.c
@@ -168,6 +168,8 @@ static int minix_rmdir(struct inode * dir, struct dentry *dentry)
 	struct inode * inode = dentry->d_inode;
 	int err = -ENOTEMPTY;
 
+	dentry_unhash(dentry);
+
 	if (minix_empty_dir(inode)) {
 		err = minix_unlink(dir, dentry);
 		if (!err) {
diff --git a/fs/namei.c b/fs/namei.c
index 316e89b..fbbc6d7 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2842,7 +2842,6 @@ int vfs_rmdir(struct inode *dir, struct dentry *dentry)
 	else {
 		error = security_inode_rmdir(dir, dentry);
 		if (!error) {
-			dentry_unhash(dentry);
 			error = dir->i_op->rmdir(dir, dentry);
 			if (!error) {
 				dentry->d_inode->i_flags |= S_DEAD;
diff --git a/fs/ncpfs/dir.c b/fs/ncpfs/dir.c
index f6946bb..57336b7 100644
--- a/fs/ncpfs/dir.c
+++ b/fs/ncpfs/dir.c
@@ -1033,6 +1033,8 @@ static int ncp_rmdir(struct inode *dir, struct dentry *dentry)
 	DPRINTK("ncp_rmdir: removing %s/%s\n",
 		dentry->d_parent->d_name.name, dentry->d_name.name);
 
+	dentry_unhash(dentry);
+
 	error = -EBUSY;
 	if (!d_unhashed(dentry))
 		goto out;
diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index 2c3eb33..78cdbdd 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -1668,6 +1668,8 @@ static int nfs_rmdir(struct inode *dir, struct dentry *dentry)
 	dfprintk(VFS, "NFS: rmdir(%s/%ld), %s\n",
 			dir->i_sb->s_id, dir->i_ino, dentry->d_name.name);
 
+	dentry_unhash(dentry);
+
 	error = NFS_PROTO(dir)->rmdir(dir, &dentry->d_name);
 	/* Ensure the VFS deletes this inode */
 	if (error == 0 && dentry->d_inode != NULL)
diff --git a/fs/nilfs2/namei.c b/fs/nilfs2/namei.c
index 161791d..87dddb1 100644
--- a/fs/nilfs2/namei.c
+++ b/fs/nilfs2/namei.c
@@ -334,6 +334,8 @@ static int nilfs_rmdir(struct inode *dir, struct dentry *dentry)
 	struct nilfs_transaction_info ti;
 	int err;
 
+	dentry_unhash(dentry);
+
 	err = nilfs_transaction_begin(dir->i_sb, &ti, 0);
 	if (err)
 		return err;
diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index 849fb4a..65e4dfd 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -812,6 +812,9 @@ static int ocfs2_unlink(struct inode *dir,
 	mlog_entry("(0x%p, 0x%p, '%.*s')\n", dir, dentry,
 		   dentry->d_name.len, dentry->d_name.name);
 
+	if (S_ISDIR(inode->i_mode))
+		dentry_unhash(dentry);
+
 	dquot_initialize(dir);
 
 	BUG_ON(dentry->d_parent->d_inode != dir);
diff --git a/fs/omfs/dir.c b/fs/omfs/dir.c
index 393f3f6..3cc7e89 100644
--- a/fs/omfs/dir.c
+++ b/fs/omfs/dir.c
@@ -256,6 +256,8 @@ static int omfs_rmdir(struct inode *dir, struct dentry *dentry)
 	int err = -ENOTEMPTY;
 	struct inode *inode = dentry->d_inode;
 
+	dentry_unhash(dentry);
+
 	if (omfs_dir_is_empty(inode)) {
 		err = omfs_unlink(dir, dentry);
 		if (!err)
diff --git a/fs/reiserfs/namei.c b/fs/reiserfs/namei.c
index 68fdf45..c2d2412 100644
--- a/fs/reiserfs/namei.c
+++ b/fs/reiserfs/namei.c
@@ -831,6 +831,8 @@ static int reiserfs_rmdir(struct inode *dir, struct dentry *dentry)
 	INITIALIZE_PATH(path);
 	struct reiserfs_dir_entry de;
 
+	dentry_unhash(dentry);
+
 	/* we will be doing 2 balancings and update 2 stat data, we change quotas
 	 * of the owner of the directory and of the owner of the parent directory.
 	 * The quota structure is possibly deleted only on last iput => outside
diff --git a/fs/sysv/namei.c b/fs/sysv/namei.c
index e474fbc..fac64ac 100644
--- a/fs/sysv/namei.c
+++ b/fs/sysv/namei.c
@@ -196,6 +196,8 @@ static int sysv_rmdir(struct inode * dir, struct dentry * dentry)
 	struct inode *inode = dentry->d_inode;
 	int err = -ENOTEMPTY;
 
+	dentry_unhash(dentry);
+
 	if (sysv_empty_dir(inode)) {
 		err = sysv_unlink(dir, dentry);
 		if (!err) {
diff --git a/fs/ubifs/dir.c b/fs/ubifs/dir.c
index 14f64b6..c2d0756 100644
--- a/fs/ubifs/dir.c
+++ b/fs/ubifs/dir.c
@@ -674,6 +674,8 @@ static int ubifs_rmdir(struct inode *dir, struct dentry *dentry)
 	struct ubifs_inode *dir_ui = ubifs_inode(dir);
 	struct ubifs_budget_req req = { .mod_dent = 1, .dirtied_ino = 2 };
 
+	dentry_unhash(dentry);
+
 	/*
 	 * Budget request settings: deletion direntry, deletion inode and
 	 * changing the parent inode. If budgeting fails, go ahead anyway
diff --git a/fs/udf/namei.c b/fs/udf/namei.c
index b7c338d..45d1c99 100644
--- a/fs/udf/namei.c
+++ b/fs/udf/namei.c
@@ -783,6 +783,8 @@ static int udf_rmdir(struct inode *dir, struct dentry *dentry)
 	struct fileIdentDesc *fi, cfi;
 	struct kernel_lb_addr tloc;
 
+	dentry_unhash(dentry);
+
 	retval = -ENOENT;
 	fi = udf_find_entry(dir, &dentry->d_name, &fibh, &cfi);
 	if (!fi)
diff --git a/fs/ufs/namei.c b/fs/ufs/namei.c
index d6f6815..a430d7b 100644
--- a/fs/ufs/namei.c
+++ b/fs/ufs/namei.c
@@ -259,6 +259,8 @@ static int ufs_rmdir (struct inode * dir, struct dentry *dentry)
 	struct inode * inode = dentry->d_inode;
 	int err= -ENOTEMPTY;
 
+	dentry_unhash(dentry);
+
 	lock_kernel();
 	if (ufs_empty_dir (inode)) {
 		err = ufs_unlink(dir, dentry);
-- 
1.7.0

