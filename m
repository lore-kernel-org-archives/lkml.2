Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933300Ab1C3WDe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 18:03:34 -0400
Received: from cobra.newdream.net ([66.33.216.30]:43177 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933263Ab1C3WB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 18:01:58 -0400
From: Sage Weil <sage@newdream.net>
To: viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, mszeredi@suse.cz,
        Sage Weil <sage@newdream.net>
Subject: [PATCH 4/7] vfs: push dentry_unhash on rename_dir into file systems
Date: Wed, 30 Mar 2011 15:09:25 -0700
Message-Id: <1301522968-4382-5-git-send-email-sage@newdream.net>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1301522968-4382-1-git-send-email-sage@newdream.net>
References: <1301522968-4382-1-git-send-email-sage@newdream.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Only a few file systems need this.  Start by pushing it down into each
rename method so that it can be dealt with on a per-fs basis.

Signed-off-by: Sage Weil <sage@newdream.net>
---
 fs/9p/vfs_inode.c       |    3 +++
 fs/affs/namei.c         |    3 +++
 fs/afs/dir.c            |    3 +++
 fs/bfs/dir.c            |    3 +++
 fs/btrfs/inode.c        |    3 +++
 fs/ceph/dir.c           |    3 +++
 fs/cifs/inode.c         |    3 +++
 fs/coda/dir.c           |    3 +++
 fs/ecryptfs/inode.c     |    3 +++
 fs/exofs/namei.c        |    3 +++
 fs/ext2/namei.c         |    3 +++
 fs/ext3/namei.c         |    3 +++
 fs/ext4/namei.c         |    3 +++
 fs/fat/namei_msdos.c    |    3 +++
 fs/fat/namei_vfat.c     |    3 +++
 fs/fuse/dir.c           |    4 ++++
 fs/gfs2/ops_inode.c     |    3 +++
 fs/hfs/dir.c            |    3 +++
 fs/hostfs/hostfs_kern.c |    3 +++
 fs/hpfs/namei.c         |    4 ++++
 fs/jffs2/dir.c          |    3 +++
 fs/jfs/namei.c          |    3 +++
 fs/libfs.c              |    3 +++
 fs/logfs/dir.c          |    3 +++
 fs/minix/namei.c        |    3 +++
 fs/namei.c              |    5 +----
 fs/ncpfs/dir.c          |    3 +++
 fs/nfs/dir.c            |    3 +++
 fs/nilfs2/namei.c       |    3 +++
 fs/ocfs2/namei.c        |    3 +++
 fs/omfs/dir.c           |    3 +++
 fs/reiserfs/namei.c     |    3 +++
 fs/sysv/namei.c         |    3 +++
 fs/ubifs/dir.c          |    3 +++
 fs/udf/namei.c          |    3 +++
 fs/ufs/namei.c          |    3 +++
 36 files changed, 108 insertions(+), 4 deletions(-)

diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index eb83ad1..7ce3619 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -756,6 +756,9 @@ v9fs_vfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 	struct p9_wstat wstat;
 	int retval;
 
+	if (new_dentry->d_inode && S_ISDIR(new_dentry->d_inode->i_mode))
+		dentry_unhash(new_dentry);
+
 	P9_DPRINTK(P9_DEBUG_VFS, "\n");
 	retval = 0;
 	old_inode = old_dentry->d_inode;
diff --git a/fs/affs/namei.c b/fs/affs/namei.c
index d087153..03330e2 100644
--- a/fs/affs/namei.c
+++ b/fs/affs/namei.c
@@ -419,6 +419,9 @@ affs_rename(struct inode *old_dir, struct dentry *old_dentry,
 	struct buffer_head *bh = NULL;
 	int retval;
 
+	if (new_dentry->d_inode && S_ISDIR(new_dentry->d_inode->i_mode))
+		dentry_unhash(new_dentry);
+
 	pr_debug("AFFS: rename(old=%u,\"%*s\" to new=%u,\"%*s\")\n",
 		 (u32)old_dir->i_ino, (int)old_dentry->d_name.len, old_dentry->d_name.name,
 		 (u32)new_dir->i_ino, (int)new_dentry->d_name.len, new_dentry->d_name.name);
diff --git a/fs/afs/dir.c b/fs/afs/dir.c
index 9a7f414..2c4e051 100644
--- a/fs/afs/dir.c
+++ b/fs/afs/dir.c
@@ -1148,6 +1148,9 @@ static int afs_rename(struct inode *old_dir, struct dentry *old_dentry,
 	struct key *key;
 	int ret;
 
+	if (new_dentry->d_inode && S_ISDIR(new_dentry->d_inode->i_mode))
+		dentry_unhash(new_dentry);
+
 	vnode = AFS_FS_I(old_dentry->d_inode);
 	orig_dvnode = AFS_FS_I(old_dir);
 	new_dvnode = AFS_FS_I(new_dir);
diff --git a/fs/bfs/dir.c b/fs/bfs/dir.c
index 685ecff..fb71de1 100644
--- a/fs/bfs/dir.c
+++ b/fs/bfs/dir.c
@@ -224,6 +224,9 @@ static int bfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 	struct bfs_sb_info *info;
 	int error = -ENOENT;
 
+	if (new_dentry->d_inode && S_ISDIR(new_dentry->d_inode->i_mode))
+		dentry_unhash(new_dentry);
+
 	old_bh = new_bh = NULL;
 	old_inode = old_dentry->d_inode;
 	if (S_ISDIR(old_inode->i_mode))
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index bd3527b..9b48003 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6823,6 +6823,9 @@ static int btrfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 	u64 root_objectid;
 	int ret;
 
+	if (new_inode && S_ISDIR(new_inode->i_mode))
+		dentry_unhash(new_dentry);
+
 	if (new_dir->i_ino == BTRFS_EMPTY_SUBVOL_DIR_OBJECTID)
 		return -EPERM;
 
diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
index c1d9d6f..06524c7 100644
--- a/fs/ceph/dir.c
+++ b/fs/ceph/dir.c
@@ -866,6 +866,9 @@ static int ceph_rename(struct inode *old_dir, struct dentry *old_dentry,
 	struct ceph_mds_request *req;
 	int err;
 
+	if (new_dentry->d_inode && S_ISDIR(new_dentry->d_inode->i_mode))
+		dentry_unhash(new_dentry);
+
 	if (ceph_snap(old_dir) != ceph_snap(new_dir))
 		return -EXDEV;
 	if (ceph_snap(old_dir) != CEPH_NOSNAP ||
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index cee5896..18546b7 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -1571,6 +1571,9 @@ int cifs_rename(struct inode *source_dir, struct dentry *source_dentry,
 	FILE_UNIX_BASIC_INFO *info_buf_target;
 	int xid, rc, tmprc;
 
+	if (target_dentry->d_inode && S_ISDIR(target_dentry->d_inode->i_mode))
+		dentry_unhash(target_dentry);
+
 	cifs_sb = CIFS_SB(source_dir->i_sb);
 	tlink = cifs_sb_tlink(cifs_sb);
 	if (IS_ERR(tlink))
diff --git a/fs/coda/dir.c b/fs/coda/dir.c
index 9f72b75..a46126f 100644
--- a/fs/coda/dir.c
+++ b/fs/coda/dir.c
@@ -361,6 +361,9 @@ static int coda_rename(struct inode *old_dir, struct dentry *old_dentry,
 	int new_length = new_dentry->d_name.len;
 	int error;
 
+	if (new_dentry->d_inode && S_ISDIR(new_dentry->d_inode->i_mode))
+		dentry_unhash(new_dentry);
+
 	error = venus_rename(old_dir->i_sb, coda_i2f(old_dir),
 			     coda_i2f(new_dir), old_length, new_length,
 			     (const char *) old_name, (const char *)new_name);
diff --git a/fs/ecryptfs/inode.c b/fs/ecryptfs/inode.c
index 6f8a00b..ea221bf 100644
--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -610,6 +610,9 @@ ecryptfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 	struct dentry *lower_new_dir_dentry;
 	struct dentry *trap = NULL;
 
+	if (new_dentry->d_inode && S_ISDIR(new_dentry->d_inode->i_mode))
+		dentry_unhash(new_dentry);
+
 	lower_old_dentry = ecryptfs_dentry_to_lower(old_dentry);
 	lower_new_dentry = ecryptfs_dentry_to_lower(new_dentry);
 	dget(lower_old_dentry);
diff --git a/fs/exofs/namei.c b/fs/exofs/namei.c
index 0697175..de252e5 100644
--- a/fs/exofs/namei.c
+++ b/fs/exofs/namei.c
@@ -251,6 +251,9 @@ static int exofs_rename(struct inode *old_dir, struct dentry *old_dentry,
 	struct exofs_dir_entry *old_de;
 	int err = -ENOENT;
 
+	if (new_inode && S_ISDIR(new_inode->i_mode))
+		dentry_unhash(new_dentry);
+
 	old_de = exofs_find_entry(old_dir, old_dentry, &old_page);
 	if (!old_de)
 		goto out;
diff --git a/fs/ext2/namei.c b/fs/ext2/namei.c
index 23aa4b3..c2b209b 100644
--- a/fs/ext2/namei.c
+++ b/fs/ext2/namei.c
@@ -320,6 +320,9 @@ static int ext2_rename (struct inode * old_dir, struct dentry * old_dentry,
 	struct ext2_dir_entry_2 * old_de;
 	int err = -ENOENT;
 
+	if (new_dentry->d_inode && S_ISDIR(new_dentry->d_inode->i_mode))
+		dentry_unhash(new_dentry);
+
 	dquot_initialize(old_dir);
 	dquot_initialize(new_dir);
 
diff --git a/fs/ext3/namei.c b/fs/ext3/namei.c
index 3256f48..1b3f814 100644
--- a/fs/ext3/namei.c
+++ b/fs/ext3/namei.c
@@ -2305,6 +2305,9 @@ static int ext3_rename (struct inode * old_dir, struct dentry *old_dentry,
 	struct ext3_dir_entry_2 * old_de, * new_de;
 	int retval, flush_file = 0;
 
+	if (new_dentry->d_inode && S_ISDIR(new_dentry->d_inode->i_mode))
+		dentry_unhash(new_dentry);
+
 	dquot_initialize(old_dir);
 	dquot_initialize(new_dir);
 
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 39a93c2..90cf091 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2356,6 +2356,9 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
 	struct ext4_dir_entry_2 *old_de, *new_de;
 	int retval, force_da_alloc = 0;
 
+	if (new_dentry->d_inode && S_ISDIR(new_dentry->d_inode->i_mode))
+		dentry_unhash(new_dentry);
+
 	dquot_initialize(old_dir);
 	dquot_initialize(new_dir);
 
diff --git a/fs/fat/namei_msdos.c b/fs/fat/namei_msdos.c
index 0c25cea..c3eccbd 100644
--- a/fs/fat/namei_msdos.c
+++ b/fs/fat/namei_msdos.c
@@ -459,6 +459,9 @@ static int do_msdos_rename(struct inode *old_dir, unsigned char *old_name,
 	old_inode = old_dentry->d_inode;
 	new_inode = new_dentry->d_inode;
 
+	if (new_inode && S_ISDIR(new_inode->i_mode))
+		dentry_unhash(new_dentry);
+
 	err = fat_scan(old_dir, old_name, &old_sinfo);
 	if (err) {
 		err = -EIO;
diff --git a/fs/fat/namei_vfat.c b/fs/fat/namei_vfat.c
index d7b9383..e2466b2 100644
--- a/fs/fat/namei_vfat.c
+++ b/fs/fat/namei_vfat.c
@@ -933,6 +933,9 @@ static int vfat_rename(struct inode *old_dir, struct dentry *old_dentry,
 	int err, is_dir, update_dotdot, corrupt = 0;
 	struct super_block *sb = old_dir->i_sb;
 
+	if (new_dentry->d_inode && S_ISDIR(new_dentry->d_inode->i_mode))
+		dentry_unhash(new_dentry);
+
 	old_sinfo.bh = sinfo.bh = dotdot_bh = NULL;
 	old_inode = old_dentry->d_inode;
 	new_inode = new_dentry->d_inode;
diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index 4459fda..8e20db1 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -693,6 +693,10 @@ static int fuse_rename(struct inode *olddir, struct dentry *oldent,
 	struct fuse_rename_in inarg;
 	struct fuse_conn *fc = get_fuse_conn(olddir);
 	struct fuse_req *req = fuse_get_req(fc);
+
+	if (newent->d_inode && S_ISDIR(newent->d_inode->i_mode))
+		dentry_unhash(newent);
+
 	if (IS_ERR(req))
 		return PTR_ERR(req);
 
diff --git a/fs/gfs2/ops_inode.c b/fs/gfs2/ops_inode.c
index 6baa30f..3fd5a31 100644
--- a/fs/gfs2/ops_inode.c
+++ b/fs/gfs2/ops_inode.c
@@ -743,6 +743,9 @@ static int gfs2_rename(struct inode *odir, struct dentry *odentry,
 	int error;
 
 	if (ndentry->d_inode) {
+		if (S_ISDIR(ndentry->d_inode->i_mode))
+			dentry_unhash(ndentry);
+
 		nip = GFS2_I(ndentry->d_inode);
 		if (ip == nip)
 			return 0;
diff --git a/fs/hfs/dir.c b/fs/hfs/dir.c
index 616cfe0..1cb70cd 100644
--- a/fs/hfs/dir.c
+++ b/fs/hfs/dir.c
@@ -286,6 +286,9 @@ static int hfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 
 	/* Unlink destination if it already exists */
 	if (new_dentry->d_inode) {
+		if (S_ISDIR(new_dentry->d_inode->i_mode))
+			dentry_unhash(new_dentry);
+
 		res = hfs_remove(new_dir, new_dentry);
 		if (res)
 			return res;
diff --git a/fs/hostfs/hostfs_kern.c b/fs/hostfs/hostfs_kern.c
index 73ea3ba..e6816b9 100644
--- a/fs/hostfs/hostfs_kern.c
+++ b/fs/hostfs/hostfs_kern.c
@@ -738,6 +738,9 @@ int hostfs_rename(struct inode *from_ino, struct dentry *from,
 	char *from_name, *to_name;
 	int err;
 
+	if (to->d_inode && S_ISDIR(to->d_inode->i_mode))
+		dentry_unhash(to);
+
 	if ((from_name = dentry_name(from)) == NULL)
 		return -ENOMEM;
 	if ((to_name = dentry_name(to)) == NULL) {
diff --git a/fs/hpfs/namei.c b/fs/hpfs/namei.c
index c6674ae..04713f7 100644
--- a/fs/hpfs/namei.c
+++ b/fs/hpfs/namei.c
@@ -562,6 +562,10 @@ static int hpfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 	struct buffer_head *bh;
 	struct fnode *fnode;
 	int err;
+
+	if (new_inode && S_ISDIR(new_inode->i_mode))
+		dentry_unhash(new_dentry);
+
 	if ((err = hpfs_chk_name(new_name, &new_len))) return err;
 	err = 0;
 	hpfs_adjust_length(old_name, &old_len);
diff --git a/fs/jffs2/dir.c b/fs/jffs2/dir.c
index 4619ee4..80879d1 100644
--- a/fs/jffs2/dir.c
+++ b/fs/jffs2/dir.c
@@ -787,6 +787,9 @@ static int jffs2_rename (struct inode *old_dir_i, struct dentry *old_dentry,
 	uint8_t type;
 	uint32_t now;
 
+	if (new_dentry->d_inode && S_ISDIR(new_dentry->d_inode->i_mode))
+		dentry_unhash(new_dentry);
+
 	/* The VFS will check for us and prevent trying to rename a
 	 * file over a directory and vice versa, but if it's a directory,
 	 * the VFS can't check whether the victim is empty. The filesystem
diff --git a/fs/jfs/namei.c b/fs/jfs/namei.c
index 32eebe6..d213b62 100644
--- a/fs/jfs/namei.c
+++ b/fs/jfs/namei.c
@@ -1100,6 +1100,9 @@ static int jfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 	jfs_info("jfs_rename: %s %s", old_dentry->d_name.name,
 		 new_dentry->d_name.name);
 
+	if (new_dentry->d_inode && S_ISDIR(new_dentry->d_inode->i_mode))
+		dentry_unhash(new_dentry);
+
 	dquot_initialize(old_dir);
 	dquot_initialize(new_dir);
 
diff --git a/fs/libfs.c b/fs/libfs.c
index 1e2ba5a..91a3710 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -325,6 +325,9 @@ int simple_rename(struct inode *old_dir, struct dentry *old_dentry,
 	struct inode *inode = old_dentry->d_inode;
 	int they_are_dirs = S_ISDIR(old_dentry->d_inode->i_mode);
 
+	if (new_dentry->d_inode && S_ISDIR(new_dentry->d_inode->i_mode))
+		dentry_unhash(new_dentry);
+
 	if (!simple_empty(new_dentry))
 		return -ENOTEMPTY;
 
diff --git a/fs/logfs/dir.c b/fs/logfs/dir.c
index 9a77518..7409059 100644
--- a/fs/logfs/dir.c
+++ b/fs/logfs/dir.c
@@ -624,6 +624,9 @@ static int logfs_rename_cross(struct inode *old_dir, struct dentry *old_dentry,
 	loff_t pos;
 	int err;
 
+	if (new_dentry->d_inode && S_ISDIR(new_dentry->d_inode->i_mode))
+		dentry_unhash(new_dentry);
+
 	/* 1. locate source dd */
 	err = logfs_get_dd(old_dir, old_dentry, &dd, &pos);
 	if (err)
diff --git a/fs/minix/namei.c b/fs/minix/namei.c
index 091626f..f60aed8 100644
--- a/fs/minix/namei.c
+++ b/fs/minix/namei.c
@@ -192,6 +192,9 @@ static int minix_rename(struct inode * old_dir, struct dentry *old_dentry,
 	struct minix_dir_entry * old_de;
 	int err = -ENOENT;
 
+	if (new_inode && S_ISDIR(new_inode->i_mode))
+		dentry_unhash(new_dentry);
+
 	old_de = minix_find_entry(old_dentry, &old_page);
 	if (!old_de)
 		goto out;
diff --git a/fs/namei.c b/fs/namei.c
index fbbc6d7..17de6ab 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -3244,11 +3244,8 @@ static int vfs_rename_dir(struct inode *old_dir, struct dentry *old_dentry,
 		mutex_lock(&target->i_mutex);
 	if (d_mountpoint(old_dentry)||d_mountpoint(new_dentry))
 		error = -EBUSY;
-	else {
-		if (target)
-			dentry_unhash(new_dentry);
+	else
 		error = old_dir->i_op->rename(old_dir, old_dentry, new_dir, new_dentry);
-	}
 	if (target) {
 		if (!error) {
 			target->i_flags |= S_DEAD;
diff --git a/fs/ncpfs/dir.c b/fs/ncpfs/dir.c
index 57336b7..e3e646b 100644
--- a/fs/ncpfs/dir.c
+++ b/fs/ncpfs/dir.c
@@ -1141,6 +1141,9 @@ static int ncp_rename(struct inode *old_dir, struct dentry *old_dentry,
 		old_dentry->d_parent->d_name.name, old_dentry->d_name.name,
 		new_dentry->d_parent->d_name.name, new_dentry->d_name.name);
 
+	if (new_dentry->d_inode && S_ISDIR(new_dentry->d_inode->i_mode))
+		dentry_unhash(new_dentry);
+
 	ncp_age_dentry(server, old_dentry);
 	ncp_age_dentry(server, new_dentry);
 
diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index 78cdbdd..2520def 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -1879,6 +1879,9 @@ static int nfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 		 new_dentry->d_parent->d_name.name, new_dentry->d_name.name,
 		 new_dentry->d_count);
 
+	if (new_inode && S_ISDIR(new_inode->i_mode))
+		dentry_unhash(new_dentry);
+
 	/*
 	 * For non-directories, check whether the target is busy and if so,
 	 * make a copy of the dentry and then do a silly-rename. If the
diff --git a/fs/nilfs2/namei.c b/fs/nilfs2/namei.c
index 87dddb1..b0ec307 100644
--- a/fs/nilfs2/namei.c
+++ b/fs/nilfs2/namei.c
@@ -371,6 +371,9 @@ static int nilfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 	struct nilfs_transaction_info ti;
 	int err;
 
+	if (new_inode && S_ISDIR(new_inode->i_mode))
+		dentry_unhash(new_dentry);
+
 	err = nilfs_transaction_begin(old_dir->i_sb, &ti, 1);
 	if (unlikely(err))
 		return err;
diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index 65e4dfd..68dccef 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -1067,6 +1067,9 @@ static int ocfs2_rename(struct inode *old_dir,
 	struct ocfs2_dir_lookup_result orphan_insert = { NULL, };
 	struct ocfs2_dir_lookup_result target_insert = { NULL, };
 
+	if (new_inode && S_ISDIR(new_inode->i_mode))
+		dentry_unhash(new_dentry);
+
 	/* At some point it might be nice to break this function up a
 	 * bit. */
 
diff --git a/fs/omfs/dir.c b/fs/omfs/dir.c
index 3cc7e89..08e7c60 100644
--- a/fs/omfs/dir.c
+++ b/fs/omfs/dir.c
@@ -394,6 +394,9 @@ static int omfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 	is_dir = S_ISDIR(old_inode->i_mode);
 
 	if (new_inode) {
+		if (S_ISDIR(new_inode->i_mode))
+			dentry_unhash(new_dentry);
+
 		/* overwriting existing file/dir */
 		err = -ENOTEMPTY;
 		if (is_dir && !omfs_dir_is_empty(new_inode))
diff --git a/fs/reiserfs/namei.c b/fs/reiserfs/namei.c
index c2d2412..fee5284 100644
--- a/fs/reiserfs/namei.c
+++ b/fs/reiserfs/namei.c
@@ -1230,6 +1230,9 @@ static int reiserfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 	unsigned long savelink = 1;
 	struct timespec ctime;
 
+	if (new_dentry->d_inode && S_ISDIR(new_dentry->d_inode->i_mode))
+		dentry_unhash(new_dentry);
+
 	/* three balancings: (1) old name removal, (2) new name insertion
 	   and (3) maybe "save" link insertion
 	   stat data updates: (1) old directory,
diff --git a/fs/sysv/namei.c b/fs/sysv/namei.c
index fac64ac..e2cc675 100644
--- a/fs/sysv/namei.c
+++ b/fs/sysv/namei.c
@@ -224,6 +224,9 @@ static int sysv_rename(struct inode * old_dir, struct dentry * old_dentry,
 	struct sysv_dir_entry * old_de;
 	int err = -ENOENT;
 
+	if (new_inode && S_ISDIR(new_inode->i_mode))
+		dentry_unhash(new_dentry);
+
 	old_de = sysv_find_entry(old_dentry, &old_page);
 	if (!old_de)
 		goto out;
diff --git a/fs/ubifs/dir.c b/fs/ubifs/dir.c
index c2d0756..d5dfd6b 100644
--- a/fs/ubifs/dir.c
+++ b/fs/ubifs/dir.c
@@ -996,6 +996,9 @@ static int ubifs_rename(struct inode *old_dir, struct dentry *old_dentry,
 			.dirtied_ino_d = ALIGN(old_inode_ui->data_len, 8) };
 	struct timespec time;
 
+	if (new_inode && S_ISDIR(new_inode->i_mode))
+		dentry_unhash(new_dentry);
+
 	/*
 	 * Budget request settings: deletion direntry, new direntry, removing
 	 * the old inode, and changing old and new parent directory inodes.
diff --git a/fs/udf/namei.c b/fs/udf/namei.c
index 45d1c99..f9729a2 100644
--- a/fs/udf/namei.c
+++ b/fs/udf/namei.c
@@ -1083,6 +1083,9 @@ static int udf_rename(struct inode *old_dir, struct dentry *old_dentry,
 	struct kernel_lb_addr tloc;
 	struct udf_inode_info *old_iinfo = UDF_I(old_inode);
 
+	if (new_inode && S_ISDIR(new_inode->i_mode))
+		dentry_unhash(new_dentry);
+
 	ofi = udf_find_entry(old_dir, &old_dentry->d_name, &ofibh, &ocfi);
 	if (ofi) {
 		if (ofibh.sbh != ofibh.ebh)
diff --git a/fs/ufs/namei.c b/fs/ufs/namei.c
index a430d7b..85a2204 100644
--- a/fs/ufs/namei.c
+++ b/fs/ufs/namei.c
@@ -285,6 +285,9 @@ static int ufs_rename(struct inode *old_dir, struct dentry *old_dentry,
 	struct ufs_dir_entry *old_de;
 	int err = -ENOENT;
 
+	if (new_inode && S_ISDIR(new_inode->i_mode))
+		dentry_unhash(new_dentry);
+
 	old_de = ufs_find_entry(old_dir, &old_dentry->d_name, &old_page);
 	if (!old_de)
 		goto out;
-- 
1.7.0

