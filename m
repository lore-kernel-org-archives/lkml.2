Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932615Ab1J1MQb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 08:16:31 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:33215 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932511Ab1J1MOC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 08:14:02 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: hch@infradead.org
Cc: viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, jack@suse.cz, akpm@linux-foundation.org,
        toshi.okajima@jp.fujitsu.com, mszeredi@suse.cz
Subject: [PATCH 09/13] filesystems: add missing nlink wrappers
Date: Fri, 28 Oct 2011 14:13:28 +0200
Message-Id: <1319804012-16346-10-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1319804012-16346-1-git-send-email-miklos@szeredi.hu>
References: <1319804012-16346-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Replace direct i_nlink updates with the respective updater function
(inc_nlink, drop_nlink, clear_nlink, inode_dec_link_count).

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 arch/s390/hypfs/inode.c |    2 +-
 drivers/mtd/mtdchar.c   |    2 +-
 fs/affs/amigaffs.c      |    2 +-
 fs/affs/namei.c         |    6 +++---
 fs/binfmt_misc.c        |    2 +-
 fs/cifs/link.c          |    2 +-
 fs/coda/dir.c           |    2 +-
 fs/devpts/inode.c       |    2 +-
 fs/ext2/ialloc.c        |    2 +-
 fs/ext3/ialloc.c        |    2 +-
 fs/ext3/namei.c         |    2 +-
 fs/ext4/ialloc.c        |    2 +-
 fs/ext4/migrate.c       |    2 +-
 fs/ext4/namei.c         |    2 +-
 fs/hfs/dir.c            |    4 ++--
 fs/hfsplus/dir.c        |    4 ++--
 fs/hpfs/inode.c         |    2 +-
 fs/hugetlbfs/inode.c    |    2 +-
 fs/jfs/jfs_inode.c      |    2 +-
 fs/jfs/namei.c          |   10 +++++-----
 fs/logfs/dir.c          |    8 ++++----
 fs/logfs/inode.c        |    2 +-
 fs/nfs/inode.c          |    2 +-
 fs/nilfs2/inode.c       |    2 +-
 fs/ocfs2/namei.c        |    8 ++++----
 fs/proc/proc_sysctl.c   |    2 +-
 fs/reiserfs/inode.c     |    4 ++--
 fs/reiserfs/namei.c     |   12 ++++++------
 fs/ubifs/xattr.c        |    2 +-
 fs/udf/namei.c          |   11 ++++-------
 fs/ufs/ialloc.c         |    2 +-
 mm/shmem.c              |    2 +-
 32 files changed, 55 insertions(+), 58 deletions(-)

diff --git a/arch/s390/hypfs/inode.c b/arch/s390/hypfs/inode.c
index 7ae0d0d..baa82f8 100644
--- a/arch/s390/hypfs/inode.c
+++ b/arch/s390/hypfs/inode.c
@@ -359,7 +359,7 @@ static struct dentry *hypfs_create_file(struct super_block *sb,
 	} else if (mode & S_IFDIR) {
 		inode->i_op = &simple_dir_inode_operations;
 		inode->i_fop = &simple_dir_operations;
-		parent->d_inode->i_nlink++;
+		inc_nlink(parent->d_inode);
 	} else
 		BUG();
 	inode->i_private = data;
diff --git a/drivers/mtd/mtdchar.c b/drivers/mtd/mtdchar.c
index f1af222..61086ea 100644
--- a/drivers/mtd/mtdchar.c
+++ b/drivers/mtd/mtdchar.c
@@ -1144,7 +1144,7 @@ static void mtdchar_notify_remove(struct mtd_info *mtd)
 
 	if (mtd_ino) {
 		/* Destroy the inode if it exists */
-		mtd_ino->i_nlink = 0;
+		clear_nlink(mtd_ino);
 		iput(mtd_ino);
 	}
 }
diff --git a/fs/affs/amigaffs.c b/fs/affs/amigaffs.c
index 3a4557e..8f12723 100644
--- a/fs/affs/amigaffs.c
+++ b/fs/affs/amigaffs.c
@@ -316,7 +316,7 @@ affs_remove_header(struct dentry *dentry)
 	if (inode->i_nlink > 1)
 		retval = affs_remove_link(dentry);
 	else
-		inode->i_nlink = 0;
+		clear_nlink(inode);
 	affs_unlock_link(inode);
 	inode->i_ctime = CURRENT_TIME_SEC;
 	mark_inode_dirty(inode);
diff --git a/fs/affs/namei.c b/fs/affs/namei.c
index e3e9efc..780a11d 100644
--- a/fs/affs/namei.c
+++ b/fs/affs/namei.c
@@ -277,7 +277,7 @@ affs_create(struct inode *dir, struct dentry *dentry, int mode, struct nameidata
 	inode->i_mapping->a_ops = (AFFS_SB(sb)->s_flags & SF_OFS) ? &affs_aops_ofs : &affs_aops;
 	error = affs_add_entry(dir, inode, dentry, ST_FILE);
 	if (error) {
-		inode->i_nlink = 0;
+		clear_nlink(inode);
 		iput(inode);
 		return error;
 	}
@@ -305,7 +305,7 @@ affs_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 
 	error = affs_add_entry(dir, inode, dentry, ST_USERDIR);
 	if (error) {
-		inode->i_nlink = 0;
+		clear_nlink(inode);
 		mark_inode_dirty(inode);
 		iput(inode);
 		return error;
@@ -392,7 +392,7 @@ affs_symlink(struct inode *dir, struct dentry *dentry, const char *symname)
 	return 0;
 
 err:
-	inode->i_nlink = 0;
+	clear_nlink(inode);
 	mark_inode_dirty(inode);
 	iput(inode);
 	return error;
diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
index ba1a1ae..1e9edbd 100644
--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -521,7 +521,7 @@ static void kill_node(Node *e)
 	write_unlock(&entries_lock);
 
 	if (dentry) {
-		dentry->d_inode->i_nlink--;
+		drop_nlink(dentry->d_inode);
 		d_drop(dentry);
 		dput(dentry);
 		simple_release_fs(&bm_mnt, &entry_count);
diff --git a/fs/cifs/link.c b/fs/cifs/link.c
index db3f18c..d02e2ff 100644
--- a/fs/cifs/link.c
+++ b/fs/cifs/link.c
@@ -424,7 +424,7 @@ cifs_hardlink(struct dentry *old_file, struct inode *inode,
 	if (old_file->d_inode) {
 		cifsInode = CIFS_I(old_file->d_inode);
 		if (rc == 0) {
-			old_file->d_inode->i_nlink++;
+			inc_nlink(old_file->d_inode);
 /* BB should we make this contingent on superblock flag NOATIME? */
 /*			old_file->d_inode->i_ctime = CURRENT_TIME;*/
 			/* parent dir timestamps will update from srv
diff --git a/fs/coda/dir.c b/fs/coda/dir.c
index 0239433..28e7e13 100644
--- a/fs/coda/dir.c
+++ b/fs/coda/dir.c
@@ -340,7 +340,7 @@ static int coda_rmdir(struct inode *dir, struct dentry *de)
 	if (!error) {
 		/* VFS may delete the child */
 		if (de->d_inode)
-		    de->d_inode->i_nlink = 0;
+			clear_nlink(de->d_inode);
 
 		/* fix the link count of the parent */
 		coda_dir_drop_nlink(dir);
diff --git a/fs/devpts/inode.c b/fs/devpts/inode.c
index 2f27e57..c196e54 100644
--- a/fs/devpts/inode.c
+++ b/fs/devpts/inode.c
@@ -549,7 +549,7 @@ void devpts_pty_kill(struct tty_struct *tty)
 
 	dentry = d_find_alias(inode);
 
-	inode->i_nlink--;
+	drop_nlink(inode);
 	d_delete(dentry);
 	dput(dentry);	/* d_alloc_name() in devpts_pty_new() */
 	dput(dentry);		/* d_find_alias above */
diff --git a/fs/ext2/ialloc.c b/fs/ext2/ialloc.c
index ee9ed31..c4e81df 100644
--- a/fs/ext2/ialloc.c
+++ b/fs/ext2/ialloc.c
@@ -601,7 +601,7 @@ fail_free_drop:
 fail_drop:
 	dquot_drop(inode);
 	inode->i_flags |= S_NOQUOTA;
-	inode->i_nlink = 0;
+	clear_nlink(inode);
 	unlock_new_inode(inode);
 	iput(inode);
 	return ERR_PTR(err);
diff --git a/fs/ext3/ialloc.c b/fs/ext3/ialloc.c
index bf09cbf..835d4ea 100644
--- a/fs/ext3/ialloc.c
+++ b/fs/ext3/ialloc.c
@@ -621,7 +621,7 @@ fail_free_drop:
 fail_drop:
 	dquot_drop(inode);
 	inode->i_flags |= S_NOQUOTA;
-	inode->i_nlink = 0;
+	clear_nlink(inode);
 	unlock_new_inode(inode);
 	iput(inode);
 	brelse(bitmap_bh);
diff --git a/fs/ext3/namei.c b/fs/ext3/namei.c
index 0629e09..8a60e33 100644
--- a/fs/ext3/namei.c
+++ b/fs/ext3/namei.c
@@ -1833,7 +1833,7 @@ retry:
 
 	if (err) {
 out_clear_inode:
-		inode->i_nlink = 0;
+		clear_nlink(inode);
 		unlock_new_inode(inode);
 		ext3_mark_inode_dirty(handle, inode);
 		iput (inode);
diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 9c63f27..ecc55bd 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -1084,7 +1084,7 @@ fail_free_drop:
 fail_drop:
 	dquot_drop(inode);
 	inode->i_flags |= S_NOQUOTA;
-	inode->i_nlink = 0;
+	clear_nlink(inode);
 	unlock_new_inode(inode);
 	iput(inode);
 	brelse(inode_bitmap_bh);
diff --git a/fs/ext4/migrate.c b/fs/ext4/migrate.c
index b57b98f..667cc88 100644
--- a/fs/ext4/migrate.c
+++ b/fs/ext4/migrate.c
@@ -507,7 +507,7 @@ int ext4_ext_migrate(struct inode *inode)
 	 * Set the i_nlink to zero so it will be deleted later
 	 * when we drop inode reference.
 	 */
-	tmp_inode->i_nlink = 0;
+	clear_nlink(tmp_inode);
 
 	ext4_ext_tree_init(handle, tmp_inode);
 	ext4_orphan_add(handle, tmp_inode);
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 1c924fa..4623c08 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2539,7 +2539,7 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
 		if (new_inode) {
 			/* checked empty_dir above, can't have another parent,
 			 * ext4_dec_count() won't work for many-linked dirs */
-			new_inode->i_nlink = 0;
+			clear_nlink(new_inode);
 		} else {
 			ext4_inc_count(handle, new_dir);
 			ext4_update_dx_flag(new_dir);
diff --git a/fs/hfs/dir.c b/fs/hfs/dir.c
index b4d70b1..bce4eef 100644
--- a/fs/hfs/dir.c
+++ b/fs/hfs/dir.c
@@ -198,7 +198,7 @@ static int hfs_create(struct inode *dir, struct dentry *dentry, int mode,
 
 	res = hfs_cat_create(inode->i_ino, dir, &dentry->d_name, inode);
 	if (res) {
-		inode->i_nlink = 0;
+		clear_nlink(inode);
 		hfs_delete_inode(inode);
 		iput(inode);
 		return res;
@@ -227,7 +227,7 @@ static int hfs_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 
 	res = hfs_cat_create(inode->i_ino, dir, &dentry->d_name, inode);
 	if (res) {
-		inode->i_nlink = 0;
+		clear_nlink(inode);
 		hfs_delete_inode(inode);
 		iput(inode);
 		return res;
diff --git a/fs/hfsplus/dir.c b/fs/hfsplus/dir.c
index 25b2443..4536cd3 100644
--- a/fs/hfsplus/dir.c
+++ b/fs/hfsplus/dir.c
@@ -415,7 +415,7 @@ static int hfsplus_symlink(struct inode *dir, struct dentry *dentry,
 	goto out;
 
 out_err:
-	inode->i_nlink = 0;
+	clear_nlink(inode);
 	hfsplus_delete_inode(inode);
 	iput(inode);
 out:
@@ -440,7 +440,7 @@ static int hfsplus_mknod(struct inode *dir, struct dentry *dentry,
 
 	res = hfsplus_create_cat(inode->i_ino, dir, &dentry->d_name, inode);
 	if (res) {
-		inode->i_nlink = 0;
+		clear_nlink(inode);
 		hfsplus_delete_inode(inode);
 		iput(inode);
 		goto out;
diff --git a/fs/hpfs/inode.c b/fs/hpfs/inode.c
index 338cd83..dfe800c 100644
--- a/fs/hpfs/inode.c
+++ b/fs/hpfs/inode.c
@@ -53,7 +53,7 @@ void hpfs_read_inode(struct inode *i)
 		i->i_mode &= ~0111;
 		i->i_op = &hpfs_file_iops;
 		i->i_fop = &hpfs_file_ops;
-		i->i_nlink = 0;*/
+		clear_nlink(i);*/
 		make_bad_inode(i);
 		return;
 	}
diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index ec88953..0be5a78 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -970,7 +970,7 @@ struct file *hugetlb_file_setup(const char *name, size_t size,
 
 	d_instantiate(path.dentry, inode);
 	inode->i_size = size;
-	inode->i_nlink = 0;
+	clear_nlink(inode);
 
 	error = -ENFILE;
 	file = alloc_file(&path, FMODE_WRITE | FMODE_READ,
diff --git a/fs/jfs/jfs_inode.c b/fs/jfs/jfs_inode.c
index 2686531..c1a3e60 100644
--- a/fs/jfs/jfs_inode.c
+++ b/fs/jfs/jfs_inode.c
@@ -157,7 +157,7 @@ fail_drop:
 	dquot_drop(inode);
 	inode->i_flags |= S_NOQUOTA;
 fail_unlock:
-	inode->i_nlink = 0;
+	clear_nlink(inode);
 	unlock_new_inode(inode);
 fail_put:
 	iput(inode);
diff --git a/fs/jfs/namei.c b/fs/jfs/namei.c
index e17545e..94b0a62 100644
--- a/fs/jfs/namei.c
+++ b/fs/jfs/namei.c
@@ -172,7 +172,7 @@ static int jfs_create(struct inode *dip, struct dentry *dentry, int mode,
 	mutex_unlock(&JFS_IP(dip)->commit_mutex);
 	if (rc) {
 		free_ea_wmap(ip);
-		ip->i_nlink = 0;
+		clear_nlink(ip);
 		unlock_new_inode(ip);
 		iput(ip);
 	} else {
@@ -311,7 +311,7 @@ static int jfs_mkdir(struct inode *dip, struct dentry *dentry, int mode)
 	mutex_unlock(&JFS_IP(dip)->commit_mutex);
 	if (rc) {
 		free_ea_wmap(ip);
-		ip->i_nlink = 0;
+		clear_nlink(ip);
 		unlock_new_inode(ip);
 		iput(ip);
 	} else {
@@ -844,7 +844,7 @@ static int jfs_link(struct dentry *old_dentry,
 	rc = txCommit(tid, 2, &iplist[0], 0);
 
 	if (rc) {
-		ip->i_nlink--; /* never instantiated */
+		drop_nlink(ip); /* never instantiated */
 		iput(ip);
 	} else
 		d_instantiate(dentry, ip);
@@ -1048,7 +1048,7 @@ static int jfs_symlink(struct inode *dip, struct dentry *dentry,
 	mutex_unlock(&JFS_IP(dip)->commit_mutex);
 	if (rc) {
 		free_ea_wmap(ip);
-		ip->i_nlink = 0;
+		clear_nlink(ip);
 		unlock_new_inode(ip);
 		iput(ip);
 	} else {
@@ -1433,7 +1433,7 @@ static int jfs_mknod(struct inode *dir, struct dentry *dentry,
 	mutex_unlock(&JFS_IP(dir)->commit_mutex);
 	if (rc) {
 		free_ea_wmap(ip);
-		ip->i_nlink = 0;
+		clear_nlink(ip);
 		unlock_new_inode(ip);
 		iput(ip);
 	} else {
diff --git a/fs/logfs/dir.c b/fs/logfs/dir.c
index b3ff3d8..b7d7f67 100644
--- a/fs/logfs/dir.c
+++ b/fs/logfs/dir.c
@@ -197,7 +197,7 @@ static int logfs_remove_inode(struct inode *inode)
 {
 	int ret;
 
-	inode->i_nlink--;
+	drop_nlink(inode);
 	ret = write_inode(inode);
 	LOGFS_BUG_ON(ret, inode->i_sb);
 	return ret;
@@ -433,7 +433,7 @@ static int __logfs_create(struct inode *dir, struct dentry *dentry,
 
 	ta = kzalloc(sizeof(*ta), GFP_KERNEL);
 	if (!ta) {
-		inode->i_nlink--;
+		drop_nlink(inode);
 		iput(inode);
 		return -ENOMEM;
 	}
@@ -456,7 +456,7 @@ static int __logfs_create(struct inode *dir, struct dentry *dentry,
 		abort_transaction(inode, ta);
 		li->li_flags |= LOGFS_IF_STILLBORN;
 		/* FIXME: truncate symlink */
-		inode->i_nlink--;
+		drop_nlink(inode);
 		iput(inode);
 		goto out;
 	}
@@ -563,7 +563,7 @@ static int logfs_link(struct dentry *old_dentry, struct inode *dir,
 
 	inode->i_ctime = dir->i_ctime = dir->i_mtime = CURRENT_TIME;
 	ihold(inode);
-	inode->i_nlink++;
+	inc_nlink(inode);
 	mark_inode_dirty_sync(inode);
 
 	return __logfs_create(dir, dentry, inode, NULL, 0);
diff --git a/fs/logfs/inode.c b/fs/logfs/inode.c
index 9abb048..7e441ad 100644
--- a/fs/logfs/inode.c
+++ b/fs/logfs/inode.c
@@ -93,7 +93,7 @@ static struct inode *__logfs_iget(struct super_block *sb, ino_t ino)
 		/* inode->i_nlink == 0 can be true when called from
 		 * block validator */
 		/* set i_nlink to 0 to prevent caching */
-		inode->i_nlink = 0;
+		clear_nlink(inode);
 		logfs_inode(inode)->li_flags |= LOGFS_IF_ZOMBIE;
 		iget_failed(inode);
 		if (!err)
diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index 4dc6d07..1fc715a 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -320,7 +320,7 @@ nfs_fhget(struct super_block *sb, struct nfs_fh *fh, struct nfs_fattr *fattr)
 		memset(&inode->i_ctime, 0, sizeof(inode->i_ctime));
 		inode->i_version = 0;
 		inode->i_size = 0;
-		inode->i_nlink = 0;
+		clear_nlink(inode);
 		inode->i_uid = -2;
 		inode->i_gid = -2;
 		inode->i_blocks = 0;
diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index 666628b..08ac272 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -354,7 +354,7 @@ struct inode *nilfs_new_inode(struct inode *dir, int mode)
 
  failed_acl:
  failed_bmap:
-	inode->i_nlink = 0;
+	clear_nlink(inode);
 	iput(inode);  /* raw_inode will be deleted through
 			 generic_delete_inode() */
 	goto failed;
diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index 0181f63..ea0ecbd 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -1377,7 +1377,7 @@ static int ocfs2_rename(struct inode *old_dir,
 	}
 
 	if (new_inode) {
-		new_inode->i_nlink--;
+		drop_nlink(new_inode);
 		new_inode->i_ctime = CURRENT_TIME;
 	}
 	old_dir->i_ctime = old_dir->i_mtime = CURRENT_TIME;
@@ -1385,9 +1385,9 @@ static int ocfs2_rename(struct inode *old_dir,
 	if (update_dot_dot) {
 		status = ocfs2_update_entry(old_inode, handle,
 					    &old_inode_dot_dot_res, new_dir);
-		old_dir->i_nlink--;
+		drop_nlink(old_dir);
 		if (new_inode) {
-			new_inode->i_nlink--;
+			drop_nlink(new_inode);
 		} else {
 			inc_nlink(new_dir);
 			mark_inode_dirty(new_dir);
@@ -2280,7 +2280,7 @@ int ocfs2_create_inode_in_orphan(struct inode *dir,
 		goto leave;
 	}
 
-	inode->i_nlink = 0;
+	clear_nlink(inode);
 	/* do the real work now. */
 	status = __ocfs2_mknod_locked(dir, inode,
 				      0, &new_di_bh, parent_di_bh, handle,
diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
index 1a77dbe..b441132 100644
--- a/fs/proc/proc_sysctl.c
+++ b/fs/proc/proc_sysctl.c
@@ -39,7 +39,7 @@ static struct inode *proc_sys_make_inode(struct super_block *sb,
 		inode->i_fop = &proc_sys_file_operations;
 	} else {
 		inode->i_mode |= S_IFDIR;
-		inode->i_nlink = 0;
+		clear_nlink(inode);
 		inode->i_op = &proc_sys_dir_operations;
 		inode->i_fop = &proc_sys_dir_file_operations;
 	}
diff --git a/fs/reiserfs/inode.c b/fs/reiserfs/inode.c
index 9b0d4b7..c425441 100644
--- a/fs/reiserfs/inode.c
+++ b/fs/reiserfs/inode.c
@@ -1444,7 +1444,7 @@ void reiserfs_read_locked_inode(struct inode *inode,
 		/* a stale NFS handle can trigger this without it being an error */
 		pathrelse(&path_to_sd);
 		reiserfs_make_bad_inode(inode);
-		inode->i_nlink = 0;
+		clear_nlink(inode);
 		return;
 	}
 
@@ -1987,7 +1987,7 @@ int reiserfs_new_inode(struct reiserfs_transaction_handle *th,
 	make_bad_inode(inode);
 
       out_inserted_sd:
-	inode->i_nlink = 0;
+	clear_nlink(inode);
 	th->t_trans_id = 0;	/* so the caller can't use this handle later */
 	unlock_new_inode(inode); /* OK to do even if we hadn't locked it */
 	iput(inode);
diff --git a/fs/reiserfs/namei.c b/fs/reiserfs/namei.c
index ef39232..6ce3328 100644
--- a/fs/reiserfs/namei.c
+++ b/fs/reiserfs/namei.c
@@ -622,7 +622,7 @@ static int reiserfs_create(struct inode *dir, struct dentry *dentry, int mode,
 			       dentry->d_name.len, inode, 1 /*visible */ );
 	if (retval) {
 		int err;
-		inode->i_nlink--;
+		drop_nlink(inode);
 		reiserfs_update_sd(&th, inode);
 		err = journal_end(&th, dir->i_sb, jbegin_count);
 		if (err)
@@ -702,7 +702,7 @@ static int reiserfs_mknod(struct inode *dir, struct dentry *dentry, int mode,
 			       dentry->d_name.len, inode, 1 /*visible */ );
 	if (retval) {
 		int err;
-		inode->i_nlink--;
+		drop_nlink(inode);
 		reiserfs_update_sd(&th, inode);
 		err = journal_end(&th, dir->i_sb, jbegin_count);
 		if (err)
@@ -787,7 +787,7 @@ static int reiserfs_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 			       dentry->d_name.len, inode, 1 /*visible */ );
 	if (retval) {
 		int err;
-		inode->i_nlink = 0;
+		clear_nlink(inode);
 		DEC_DIR_INODE_NLINK(dir);
 		reiserfs_update_sd(&th, inode);
 		err = journal_end(&th, dir->i_sb, jbegin_count);
@@ -1086,7 +1086,7 @@ static int reiserfs_symlink(struct inode *parent_dir,
 				    dentry->d_name.len, inode, 1 /*visible */ );
 	if (retval) {
 		int err;
-		inode->i_nlink--;
+		drop_nlink(inode);
 		reiserfs_update_sd(&th, inode);
 		err = journal_end(&th, parent_dir->i_sb, jbegin_count);
 		if (err)
@@ -1129,7 +1129,7 @@ static int reiserfs_link(struct dentry *old_dentry, struct inode *dir,
 
 	retval = journal_begin(&th, dir->i_sb, jbegin_count);
 	if (retval) {
-		inode->i_nlink--;
+		drop_nlink(inode);
 		reiserfs_write_unlock(dir->i_sb);
 		return retval;
 	}
@@ -1144,7 +1144,7 @@ static int reiserfs_link(struct dentry *old_dentry, struct inode *dir,
 
 	if (retval) {
 		int err;
-		inode->i_nlink--;
+		drop_nlink(inode);
 		err = journal_end(&th, dir->i_sb, jbegin_count);
 		reiserfs_write_unlock(dir->i_sb);
 		return err ? err : retval;
diff --git a/fs/ubifs/xattr.c b/fs/ubifs/xattr.c
index 16f19f5..993adc8 100644
--- a/fs/ubifs/xattr.c
+++ b/fs/ubifs/xattr.c
@@ -558,7 +558,7 @@ int ubifs_removexattr(struct dentry *dentry, const char *name)
 	}
 
 	ubifs_assert(inode->i_nlink == 1);
-	inode->i_nlink = 0;
+	clear_nlink(inode);
 	err = remove_xattr(c, host, inode, &nm);
 	if (err)
 		inode->i_nlink = 1;
diff --git a/fs/udf/namei.c b/fs/udf/namei.c
index f1dce84..e8d61b1 100644
--- a/fs/udf/namei.c
+++ b/fs/udf/namei.c
@@ -577,8 +577,7 @@ static int udf_create(struct inode *dir, struct dentry *dentry, int mode,
 
 	fi = udf_add_entry(dir, dentry, &fibh, &cfi, &err);
 	if (!fi) {
-		inode->i_nlink--;
-		mark_inode_dirty(inode);
+		inode_dec_link_count(inode);
 		iput(inode);
 		return err;
 	}
@@ -618,8 +617,7 @@ static int udf_mknod(struct inode *dir, struct dentry *dentry, int mode,
 	init_special_inode(inode, mode, rdev);
 	fi = udf_add_entry(dir, dentry, &fibh, &cfi, &err);
 	if (!fi) {
-		inode->i_nlink--;
-		mark_inode_dirty(inode);
+		inode_dec_link_count(inode);
 		iput(inode);
 		return err;
 	}
@@ -665,8 +663,7 @@ static int udf_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 	inode->i_fop = &udf_dir_operations;
 	fi = udf_add_entry(inode, NULL, &fibh, &cfi, &err);
 	if (!fi) {
-		inode->i_nlink--;
-		mark_inode_dirty(inode);
+		inode_dec_link_count(inode);
 		iput(inode);
 		goto out;
 	}
@@ -683,7 +680,7 @@ static int udf_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 
 	fi = udf_add_entry(dir, dentry, &fibh, &cfi, &err);
 	if (!fi) {
-		inode->i_nlink = 0;
+		clear_nlink(inode);
 		mark_inode_dirty(inode);
 		iput(inode);
 		goto out;
diff --git a/fs/ufs/ialloc.c b/fs/ufs/ialloc.c
index 2eabf04..78a4c70 100644
--- a/fs/ufs/ialloc.c
+++ b/fs/ufs/ialloc.c
@@ -341,7 +341,7 @@ cg_found:
 
 fail_remove_inode:
 	unlock_super(sb);
-	inode->i_nlink = 0;
+	clear_nlink(inode);
 	iput(inode);
 	UFSD("EXIT (FAILED): err %d\n", err);
 	return ERR_PTR(err);
diff --git a/mm/shmem.c b/mm/shmem.c
index 2d35772..cc87192 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2497,7 +2497,7 @@ struct file *shmem_file_setup(const char *name, loff_t size, unsigned long flags
 
 	d_instantiate(path.dentry, inode);
 	inode->i_size = size;
-	inode->i_nlink = 0;	/* It is unlinked */
+	clear_nlink(inode);	/* It is unlinked */
 #ifndef CONFIG_MMU
 	error = ramfs_nommu_expand_for_mapping(inode, size);
 	if (error)
-- 
1.7.3.4

