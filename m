Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752955Ab2JFKqs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 06:46:48 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:45560 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745Ab2JFKqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 06:46:43 -0400
Message-ID: <50700A83.1090708@gmail.com>
Date: Sat, 06 Oct 2012 12:40:03 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120825 Thunderbird/15.0
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, linux-kernel@vger.kernel.org,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>
Subject: [PATCH 4/8] fat: drop lock/unlock super
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed lock/unlock super. Added a new private s_lock mutex.

Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
---
 fs/fat/dir.c         |    4 ++--
 fs/fat/fat.h         |    5 +++--
 fs/fat/inode.c       |    5 +++--
 fs/fat/namei_msdos.c |   26 +++++++++++++-------------
 fs/fat/namei_vfat.c  |   30 +++++++++++++++---------------
 5 files changed, 36 insertions(+), 34 deletions(-)

diff --git a/fs/fat/dir.c b/fs/fat/dir.c
index bca6d0a..2a18234 100644
--- a/fs/fat/dir.c
+++ b/fs/fat/dir.c
@@ -571,7 +571,7 @@ static int __fat_readdir(struct inode *inode, struct file *filp, void *dirent,
 	int short_len = 0, fill_len = 0;
 	int ret = 0;
 
-	lock_super(sb);
+	mutex_lock(&sbi->s_lock);
 
 	cpos = filp->f_pos;
 	/* Fake . and .. for the root directory. */
@@ -693,7 +693,7 @@ fill_failed:
 	if (unicode)
 		__putname(unicode);
 out:
-	unlock_super(sb);
+	mutex_unlock(&sbi->s_lock);
 	return ret;
 }
 
diff --git a/fs/fat/fat.h b/fs/fat/fat.h
index ca7e8f8..623f36f 100644
--- a/fs/fat/fat.h
+++ b/fs/fat/fat.h
@@ -71,8 +71,9 @@ struct msdos_sb_info {
 	unsigned long root_cluster;   /* first cluster of the root directory */
 	unsigned long fsinfo_sector;  /* sector number of FAT32 fsinfo */
 	struct mutex fat_lock;
-	unsigned int prev_free;       /* previously allocated cluster number */
-	unsigned int free_clusters;   /* -1 if undefined */
+	struct mutex s_lock;
+	unsigned int prev_free;      /* previously allocated cluster number */
+	unsigned int free_clusters;  /* -1 if undefined */
 	unsigned int free_clus_valid; /* is free_clusters valid? */
 	struct fat_mount_options options;
 	struct nls_table *nls_disk;   /* Codepage used on disk */
diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index 76f60c6..5bafaad 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -673,9 +673,9 @@ static int fat_write_inode(struct inode *inode, struct writeback_control *wbc)
 	if (inode->i_ino == MSDOS_FSINFO_INO) {
 		struct super_block *sb = inode->i_sb;
 
-		lock_super(sb);
+		mutex_lock(&MSDOS_SB(sb)->s_lock);
 		err = fat_clusters_flush(sb);
-		unlock_super(sb);
+		mutex_unlock(&MSDOS_SB(sb)->s_lock);
 	} else
 		err = __fat_write_inode(inode, wbc->sync_mode == WB_SYNC_ALL);
 
@@ -1268,6 +1268,7 @@ int fat_fill_super(struct super_block *sb, void *data, int silent, int isvfat,
 		b = (struct fat_boot_sector *) bh->b_data;
 	}
 
+	mutex_init(&sbi->s_lock);
 	sbi->cluster_size = sb->s_blocksize * sbi->sec_per_clus;
 	sbi->cluster_bits = ffs(sbi->cluster_size) - 1;
 	sbi->fats = b->fats;
diff --git a/fs/fat/namei_msdos.c b/fs/fat/namei_msdos.c
index c1055e7..e2cfda9 100644
--- a/fs/fat/namei_msdos.c
+++ b/fs/fat/namei_msdos.c
@@ -208,7 +208,7 @@ static struct dentry *msdos_lookup(struct inode *dir, struct dentry *dentry,
 	struct inode *inode;
 	int err;
 
-	lock_super(sb);
+	mutex_lock(&MSDOS_SB(sb)->s_lock);
 	err = msdos_find(dir, dentry->d_name.name, dentry->d_name.len, &sinfo);
 	switch (err) {
 	case -ENOENT:
@@ -221,7 +221,7 @@ static struct dentry *msdos_lookup(struct inode *dir, struct dentry *dentry,
 	default:
 		inode = ERR_PTR(err);
 	}
-	unlock_super(sb);
+	mutex_unlock(&MSDOS_SB(sb)->s_lock);
 	return d_splice_alias(inode, dentry);
 }
 
@@ -273,7 +273,7 @@ static int msdos_create(struct inode *dir, struct dentry *dentry, umode_t mode,
 	unsigned char msdos_name[MSDOS_NAME];
 	int err, is_hid;
 
-	lock_super(sb);
+	mutex_lock(&MSDOS_SB(sb)->s_lock);
 
 	err = msdos_format_name(dentry->d_name.name, dentry->d_name.len,
 				msdos_name, &MSDOS_SB(sb)->options);
@@ -302,7 +302,7 @@ static int msdos_create(struct inode *dir, struct dentry *dentry, umode_t mode,
 
 	d_instantiate(dentry, inode);
 out:
-	unlock_super(sb);
+	mutex_unlock(&MSDOS_SB(sb)->s_lock);
 	if (!err)
 		err = fat_flush_inodes(sb, dir, inode);
 	return err;
@@ -316,7 +316,7 @@ static int msdos_rmdir(struct inode *dir, struct dentry *dentry)
 	struct fat_slot_info sinfo;
 	int err;
 
-	lock_super(sb);
+	mutex_lock(&MSDOS_SB(sb)->s_lock);
 	/*
 	 * Check whether the directory is not in use, then check
 	 * whether it is empty.
@@ -337,7 +337,7 @@ static int msdos_rmdir(struct inode *dir, struct dentry *dentry)
 	inode->i_ctime = CURRENT_TIME_SEC;
 	fat_detach(inode);
 out:
-	unlock_super(sb);
+	mutex_unlock(&MSDOS_SB(sb)->s_lock);
 	if (!err)
 		err = fat_flush_inodes(sb, dir, inode);
 
@@ -354,7 +354,7 @@ static int msdos_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
 	struct timespec ts;
 	int err, is_hid, cluster;
 
-	lock_super(sb);
+	mutex_lock(&MSDOS_SB(sb)->s_lock);
 
 	err = msdos_format_name(dentry->d_name.name, dentry->d_name.len,
 				msdos_name, &MSDOS_SB(sb)->options);
@@ -392,14 +392,14 @@ static int msdos_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
 
 	d_instantiate(dentry, inode);
 
-	unlock_super(sb);
+	mutex_unlock(&MSDOS_SB(sb)->s_lock);
 	fat_flush_inodes(sb, dir, inode);
 	return 0;
 
 out_free:
 	fat_free_clusters(dir, cluster);
 out:
-	unlock_super(sb);
+	mutex_unlock(&MSDOS_SB(sb)->s_lock);
 	return err;
 }
 
@@ -411,7 +411,7 @@ static int msdos_unlink(struct inode *dir, struct dentry *dentry)
 	struct fat_slot_info sinfo;
 	int err;
 
-	lock_super(sb);
+	mutex_lock(&MSDOS_SB(sb)->s_lock);
 	err = msdos_find(dir, dentry->d_name.name, dentry->d_name.len, &sinfo);
 	if (err)
 		goto out;
@@ -423,7 +423,7 @@ static int msdos_unlink(struct inode *dir, struct dentry *dentry)
 	inode->i_ctime = CURRENT_TIME_SEC;
 	fat_detach(inode);
 out:
-	unlock_super(sb);
+	mutex_unlock(&MSDOS_SB(sb)->s_lock);
 	if (!err)
 		err = fat_flush_inodes(sb, dir, inode);
 
@@ -606,7 +606,7 @@ static int msdos_rename(struct inode *old_dir, struct dentry *old_dentry,
 	unsigned char old_msdos_name[MSDOS_NAME], new_msdos_name[MSDOS_NAME];
 	int err, is_hid;
 
-	lock_super(sb);
+	mutex_lock(&MSDOS_SB(sb)->s_lock);
 
 	err = msdos_format_name(old_dentry->d_name.name,
 				old_dentry->d_name.len, old_msdos_name,
@@ -625,7 +625,7 @@ static int msdos_rename(struct inode *old_dir, struct dentry *old_dentry,
 	err = do_msdos_rename(old_dir, old_msdos_name, old_dentry,
 			      new_dir, new_msdos_name, new_dentry, is_hid);
 out:
-	unlock_super(sb);
+	mutex_unlock(&MSDOS_SB(sb)->s_lock);
 	if (!err)
 		err = fat_flush_inodes(sb, old_dir, new_dir);
 	return err;
diff --git a/fs/fat/namei_vfat.c b/fs/fat/namei_vfat.c
index e535dd7..ac959d6 100644
--- a/fs/fat/namei_vfat.c
+++ b/fs/fat/namei_vfat.c
@@ -721,7 +721,7 @@ static struct dentry *vfat_lookup(struct inode *dir, struct dentry *dentry,
 	struct dentry *alias;
 	int err;
 
-	lock_super(sb);
+	mutex_lock(&MSDOS_SB(sb)->s_lock);
 
 	err = vfat_find(dir, &dentry->d_name, &sinfo);
 	if (err) {
@@ -752,13 +752,13 @@ static struct dentry *vfat_lookup(struct inode *dir, struct dentry *dentry,
 		if (!S_ISDIR(inode->i_mode))
 			d_move(alias, dentry);
 		iput(inode);
-		unlock_super(sb);
+		mutex_unlock(&MSDOS_SB(sb)->s_lock);
 		return alias;
 	} else
 		dput(alias);
 
 out:
-	unlock_super(sb);
+	mutex_unlock(&MSDOS_SB(sb)->s_lock);
 	dentry->d_time = dentry->d_parent->d_inode->i_version;
 	dentry = d_splice_alias(inode, dentry);
 	if (dentry)
@@ -766,7 +766,7 @@ out:
 	return dentry;
 
 error:
-	unlock_super(sb);
+	mutex_unlock(&MSDOS_SB(sb)->s_lock);
 	return ERR_PTR(err);
 }
 
@@ -779,7 +779,7 @@ static int vfat_create(struct inode *dir, struct dentry *dentry, umode_t mode,
 	struct timespec ts;
 	int err;
 
-	lock_super(sb);
+	mutex_lock(&MSDOS_SB(sb)->s_lock);
 
 	ts = CURRENT_TIME_SEC;
 	err = vfat_add_entry(dir, &dentry->d_name, 0, 0, &ts, &sinfo);
@@ -800,7 +800,7 @@ static int vfat_create(struct inode *dir, struct dentry *dentry, umode_t mode,
 	dentry->d_time = dentry->d_parent->d_inode->i_version;
 	d_instantiate(dentry, inode);
 out:
-	unlock_super(sb);
+	mutex_unlock(&MSDOS_SB(sb)->s_lock);
 	return err;
 }
 
@@ -811,7 +811,7 @@ static int vfat_rmdir(struct inode *dir, struct dentry *dentry)
 	struct fat_slot_info sinfo;
 	int err;
 
-	lock_super(sb);
+	mutex_lock(&MSDOS_SB(sb)->s_lock);
 
 	err = fat_dir_empty(inode);
 	if (err)
@@ -829,7 +829,7 @@ static int vfat_rmdir(struct inode *dir, struct dentry *dentry)
 	inode->i_mtime = inode->i_atime = CURRENT_TIME_SEC;
 	fat_detach(inode);
 out:
-	unlock_super(sb);
+	mutex_unlock(&MSDOS_SB(sb)->s_lock);
 
 	return err;
 }
@@ -841,7 +841,7 @@ static int vfat_unlink(struct inode *dir, struct dentry *dentry)
 	struct fat_slot_info sinfo;
 	int err;
 
-	lock_super(sb);
+	mutex_lock(&MSDOS_SB(sb)->s_lock);
 
 	err = vfat_find(dir, &dentry->d_name, &sinfo);
 	if (err)
@@ -854,7 +854,7 @@ static int vfat_unlink(struct inode *dir, struct dentry *dentry)
 	inode->i_mtime = inode->i_atime = CURRENT_TIME_SEC;
 	fat_detach(inode);
 out:
-	unlock_super(sb);
+	mutex_unlock(&MSDOS_SB(sb)->s_lock);
 
 	return err;
 }
@@ -867,7 +867,7 @@ static int vfat_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
 	struct timespec ts;
 	int err, cluster;
 
-	lock_super(sb);
+	mutex_lock(&MSDOS_SB(sb)->s_lock);
 
 	ts = CURRENT_TIME_SEC;
 	cluster = fat_alloc_new_dir(dir, &ts);
@@ -896,13 +896,13 @@ static int vfat_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
 	dentry->d_time = dentry->d_parent->d_inode->i_version;
 	d_instantiate(dentry, inode);
 
-	unlock_super(sb);
+	mutex_unlock(&MSDOS_SB(sb)->s_lock);
 	return 0;
 
 out_free:
 	fat_free_clusters(dir, cluster);
 out:
-	unlock_super(sb);
+	mutex_unlock(&MSDOS_SB(sb)->s_lock);
 	return err;
 }
 
@@ -921,7 +921,7 @@ static int vfat_rename(struct inode *old_dir, struct dentry *old_dentry,
 	old_sinfo.bh = sinfo.bh = dotdot_bh = NULL;
 	old_inode = old_dentry->d_inode;
 	new_inode = new_dentry->d_inode;
-	lock_super(sb);
+	mutex_lock(&MSDOS_SB(sb)->s_lock);
 	err = vfat_find(old_dir, &old_dentry->d_name, &old_sinfo);
 	if (err)
 		goto out;
@@ -996,7 +996,7 @@ out:
 	brelse(sinfo.bh);
 	brelse(dotdot_bh);
 	brelse(old_sinfo.bh);
-	unlock_super(sb);
+	mutex_unlock(&MSDOS_SB(sb)->s_lock);
 
 	return err;
 
-- 
1.7.3.4
