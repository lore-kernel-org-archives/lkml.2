Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932385Ab2BBVYU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 16:24:20 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:34455 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757255Ab2BBVYC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 16:24:02 -0500
Date: Thu, 2 Feb 2012 21:24:00 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [RFC] killing boilerplate checks in ->link/->mkdir/->rename
Message-ID: <20120202212400.GR23916@ZenIV.linux.org.uk>
References: <20120130222717.GA6393@kroah.com>
 <m18vkoirv9.fsf@fess.ebiederm.org>
 <4F27C6EB.2070305@suse.cz>
 <m14nvc82jo.fsf@fess.ebiederm.org>
 <CA+55aFwZNdoAA9iPMiEp8-+ndgV+CtSZO4neSh_L+gd77k7-vg@mail.gmail.com>
 <m1wr87ywex.fsf@fess.ebiederm.org>
 <m1ehueyz20.fsf_-_@fess.ebiederm.org>
 <CA+55aFyNQnXrL7fWhBt4LYBuoHD_x+j=Af-N=ueFMBkymy9Rnw@mail.gmail.com>
 <CA+55aFzZX544ZDN9vN3jWMWZ=_9ZtpZ9cR6gNEzUnx9RCqR5LQ@mail.gmail.com>
 <20120202012258.GQ23916@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120202012258.GQ23916@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Linux implementation of link(2) had exactly the same bug as that of v7 until
> 0.98.3 (for link(2)) and 0.99.1 (for mkdir(2), rename(2) - didn't exist as
> syscalls on v7, but had the same problem as soon as they made it in kernel
> at some point in BSD history).  Note that limit for minixfs remained
> ridiculously low until '97 or so; for ext2 it was 32000 from the very
> beginning but note that e.g. ext had _not_ acquired fixes for link overflows
> on mkdir() at all - it had that hole all the way until removal in 2.1.26.
> Of course, there was a (completely useless) POSIX-mandated LINK_MAX, but
> since the actual limit depends on fs type, well...  the checks remain
> in ->link()/->mkdir()/->rename() instances and IIRC I've caught a bunch of
> overflows in those circa 2.1.very_late.  

FWIW, there's something we really should've done a long time ago: putting
that limit into sb->s_max_links.  With 0 meaning "leave all checks to
->link/->mkdir/->rename".  Something like the following would make a
reasonable start - just the conversion of obvious cases.  As the next
step I'd probably initialize it as ~0U instead of 0 and let the filesystems
that want something trickier (reiserfs, ext4, gfs2, ocfs2) explicitly set
it to 0 in their foo_fill_super().  That would take care of a bunch of cases
where we forgot to do those checks (ubifs, hfsplus, jffs2, ramfs, etc.) and
it's probably a saner default anyway.

Comments?  Boilerplate removal follows (22 files changed, 45 insertions(+),
120 deletions(-)), but it's *not* for immediate merge; it's really completely
untested.

diff --git a/fs/exofs/namei.c b/fs/exofs/namei.c
index 9dbf0c3..fc7161d 100644
--- a/fs/exofs/namei.c
+++ b/fs/exofs/namei.c
@@ -143,9 +143,6 @@ static int exofs_link(struct dentry *old_dentry, struct inode *dir,
 {
 	struct inode *inode = old_dentry->d_inode;
 
-	if (inode->i_nlink >= EXOFS_LINK_MAX)
-		return -EMLINK;
-
 	inode->i_ctime = CURRENT_TIME;
 	inode_inc_link_count(inode);
 	ihold(inode);
@@ -156,10 +153,7 @@ static int exofs_link(struct dentry *old_dentry, struct inode *dir,
 static int exofs_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
 {
 	struct inode *inode;
-	int err = -EMLINK;
-
-	if (dir->i_nlink >= EXOFS_LINK_MAX)
-		goto out;
+	int err;
 
 	inode_inc_link_count(dir);
 
@@ -275,11 +269,6 @@ static int exofs_rename(struct inode *old_dir, struct dentry *old_dentry,
 		if (err)
 			goto out_dir;
 	} else {
-		if (dir_de) {
-			err = -EMLINK;
-			if (new_dir->i_nlink >= EXOFS_LINK_MAX)
-				goto out_dir;
-		}
 		err = exofs_add_link(new_dentry, old_inode);
 		if (err)
 			goto out_dir;
diff --git a/fs/exofs/super.c b/fs/exofs/super.c
index d22cd16..6cafcad 100644
--- a/fs/exofs/super.c
+++ b/fs/exofs/super.c
@@ -754,6 +754,7 @@ static int exofs_fill_super(struct super_block *sb, void *data, int silent)
 	sb->s_blocksize = EXOFS_BLKSIZE;
 	sb->s_blocksize_bits = EXOFS_BLKSHIFT;
 	sb->s_maxbytes = MAX_LFS_FILESIZE;
+	sb->s_max_links = EXOFS_LINK_MAX;
 	atomic_set(&sbi->s_curr_pending, 0);
 	sb->s_bdev = NULL;
 	sb->s_dev = 0;
diff --git a/fs/ext2/namei.c b/fs/ext2/namei.c
index 0804198..dffb865 100644
--- a/fs/ext2/namei.c
+++ b/fs/ext2/namei.c
@@ -195,9 +195,6 @@ static int ext2_link (struct dentry * old_dentry, struct inode * dir,
 	struct inode *inode = old_dentry->d_inode;
 	int err;
 
-	if (inode->i_nlink >= EXT2_LINK_MAX)
-		return -EMLINK;
-
 	dquot_initialize(dir);
 
 	inode->i_ctime = CURRENT_TIME_SEC;
@@ -217,10 +214,7 @@ static int ext2_link (struct dentry * old_dentry, struct inode * dir,
 static int ext2_mkdir(struct inode * dir, struct dentry * dentry, umode_t mode)
 {
 	struct inode * inode;
-	int err = -EMLINK;
-
-	if (dir->i_nlink >= EXT2_LINK_MAX)
-		goto out;
+	int err;
 
 	dquot_initialize(dir);
 
@@ -346,11 +340,6 @@ static int ext2_rename (struct inode * old_dir, struct dentry * old_dentry,
 			drop_nlink(new_inode);
 		inode_dec_link_count(new_inode);
 	} else {
-		if (dir_de) {
-			err = -EMLINK;
-			if (new_dir->i_nlink >= EXT2_LINK_MAX)
-				goto out_dir;
-		}
 		err = ext2_add_link(new_dentry, old_inode);
 		if (err)
 			goto out_dir;
diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index 0090595..9f6766a 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -919,6 +919,7 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
 	}
 
 	sb->s_maxbytes = ext2_max_size(sb->s_blocksize_bits);
+	sb->s_max_links = EXT2_LINK_MAX;
 
 	if (le32_to_cpu(es->s_rev_level) == EXT2_GOOD_OLD_REV) {
 		sbi->s_inode_size = EXT2_GOOD_OLD_INODE_SIZE;
diff --git a/fs/jfs/namei.c b/fs/jfs/namei.c
index 5f7c160..07c91ca 100644
--- a/fs/jfs/namei.c
+++ b/fs/jfs/namei.c
@@ -220,12 +220,6 @@ static int jfs_mkdir(struct inode *dip, struct dentry *dentry, umode_t mode)
 
 	dquot_initialize(dip);
 
-	/* link count overflow on parent directory ? */
-	if (dip->i_nlink == JFS_LINK_MAX) {
-		rc = -EMLINK;
-		goto out1;
-	}
-
 	/*
 	 * search parent directory for entry/freespace
 	 * (dtSearch() returns parent directory page pinned)
@@ -806,9 +800,6 @@ static int jfs_link(struct dentry *old_dentry,
 	jfs_info("jfs_link: %s %s", old_dentry->d_name.name,
 		 dentry->d_name.name);
 
-	if (ip->i_nlink == JFS_LINK_MAX)
-		return -EMLINK;
-
 	dquot_initialize(dir);
 
 	tid = txBegin(ip->i_sb, 0);
@@ -1138,10 +1129,6 @@ static int jfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 				rc = -ENOTEMPTY;
 				goto out3;
 			}
-		} else if ((new_dir != old_dir) &&
-			   (new_dir->i_nlink == JFS_LINK_MAX)) {
-			rc = -EMLINK;
-			goto out3;
 		}
 	} else if (new_ip) {
 		IWRITE_LOCK(new_ip, RDWRLOCK_NORMAL);
diff --git a/fs/jfs/super.c b/fs/jfs/super.c
index 682bca6..4661ad7 100644
--- a/fs/jfs/super.c
+++ b/fs/jfs/super.c
@@ -441,6 +441,7 @@ static int jfs_fill_super(struct super_block *sb, void *data, int silent)
 		return -ENOMEM;
 
 	sb->s_fs_info = sbi;
+	sb->s_max_links = JFS_LINK_MAX;
 	sbi->sb = sb;
 	sbi->uid = sbi->gid = sbi->umask = -1;
 
diff --git a/fs/logfs/dir.c b/fs/logfs/dir.c
index 3de7a32..4aea231 100644
--- a/fs/logfs/dir.c
+++ b/fs/logfs/dir.c
@@ -558,9 +558,6 @@ static int logfs_link(struct dentry *old_dentry, struct inode *dir,
 {
 	struct inode *inode = old_dentry->d_inode;
 
-	if (inode->i_nlink >= LOGFS_LINK_MAX)
-		return -EMLINK;
-
 	inode->i_ctime = dir->i_ctime = dir->i_mtime = CURRENT_TIME;
 	ihold(inode);
 	inc_nlink(inode);
diff --git a/fs/logfs/super.c b/fs/logfs/super.c
index c9ee7f5..b1a491a 100644
--- a/fs/logfs/super.c
+++ b/fs/logfs/super.c
@@ -542,6 +542,7 @@ static struct dentry *logfs_get_sb_device(struct logfs_super *super,
 	 * the filesystem incompatible with 32bit systems.
 	 */
 	sb->s_maxbytes	= (1ull << 43) - 1;
+	sb->s_max_links = LOGFS_LINK_MAX;
 	sb->s_op	= &logfs_super_operations;
 	sb->s_flags	= flags | MS_NOATIME;
 
diff --git a/fs/minix/inode.c b/fs/minix/inode.c
index fa8b612..62c697c 100644
--- a/fs/minix/inode.c
+++ b/fs/minix/inode.c
@@ -190,24 +190,24 @@ static int minix_fill_super(struct super_block *s, void *data, int silent)
 		sbi->s_version = MINIX_V1;
 		sbi->s_dirsize = 16;
 		sbi->s_namelen = 14;
-		sbi->s_link_max = MINIX_LINK_MAX;
+		s->s_max_links = MINIX_LINK_MAX;
 	} else if (s->s_magic == MINIX_SUPER_MAGIC2) {
 		sbi->s_version = MINIX_V1;
 		sbi->s_dirsize = 32;
 		sbi->s_namelen = 30;
-		sbi->s_link_max = MINIX_LINK_MAX;
+		s->s_max_links = MINIX_LINK_MAX;
 	} else if (s->s_magic == MINIX2_SUPER_MAGIC) {
 		sbi->s_version = MINIX_V2;
 		sbi->s_nzones = ms->s_zones;
 		sbi->s_dirsize = 16;
 		sbi->s_namelen = 14;
-		sbi->s_link_max = MINIX2_LINK_MAX;
+		s->s_max_links = MINIX2_LINK_MAX;
 	} else if (s->s_magic == MINIX2_SUPER_MAGIC2) {
 		sbi->s_version = MINIX_V2;
 		sbi->s_nzones = ms->s_zones;
 		sbi->s_dirsize = 32;
 		sbi->s_namelen = 30;
-		sbi->s_link_max = MINIX2_LINK_MAX;
+		s->s_max_links = MINIX2_LINK_MAX;
 	} else if ( *(__u16 *)(bh->b_data + 24) == MINIX3_SUPER_MAGIC) {
 		m3s = (struct minix3_super_block *) bh->b_data;
 		s->s_magic = m3s->s_magic;
@@ -221,9 +221,9 @@ static int minix_fill_super(struct super_block *s, void *data, int silent)
 		sbi->s_dirsize = 64;
 		sbi->s_namelen = 60;
 		sbi->s_version = MINIX_V3;
-		sbi->s_link_max = MINIX2_LINK_MAX;
 		sbi->s_mount_state = MINIX_VALID_FS;
 		sb_set_blocksize(s, m3s->s_blocksize);
+		s->s_max_links = MINIX2_LINK_MAX;
 	} else
 		goto out_no_fs;
 
diff --git a/fs/minix/minix.h b/fs/minix/minix.h
index c889ef0..1ebd118 100644
--- a/fs/minix/minix.h
+++ b/fs/minix/minix.h
@@ -34,7 +34,6 @@ struct minix_sb_info {
 	unsigned long s_max_size;
 	int s_dirsize;
 	int s_namelen;
-	int s_link_max;
 	struct buffer_head ** s_imap;
 	struct buffer_head ** s_zmap;
 	struct buffer_head * s_sbh;
diff --git a/fs/minix/namei.c b/fs/minix/namei.c
index 2f76e38..2d0ee17 100644
--- a/fs/minix/namei.c
+++ b/fs/minix/namei.c
@@ -94,9 +94,6 @@ static int minix_link(struct dentry * old_dentry, struct inode * dir,
 {
 	struct inode *inode = old_dentry->d_inode;
 
-	if (inode->i_nlink >= minix_sb(inode->i_sb)->s_link_max)
-		return -EMLINK;
-
 	inode->i_ctime = CURRENT_TIME_SEC;
 	inode_inc_link_count(inode);
 	ihold(inode);
@@ -106,10 +103,7 @@ static int minix_link(struct dentry * old_dentry, struct inode * dir,
 static int minix_mkdir(struct inode * dir, struct dentry *dentry, umode_t mode)
 {
 	struct inode * inode;
-	int err = -EMLINK;
-
-	if (dir->i_nlink >= minix_sb(dir->i_sb)->s_link_max)
-		goto out;
+	int err;
 
 	inode_inc_link_count(dir);
 
@@ -181,7 +175,6 @@ static int minix_rmdir(struct inode * dir, struct dentry *dentry)
 static int minix_rename(struct inode * old_dir, struct dentry *old_dentry,
 			   struct inode * new_dir, struct dentry *new_dentry)
 {
-	struct minix_sb_info * info = minix_sb(old_dir->i_sb);
 	struct inode * old_inode = old_dentry->d_inode;
 	struct inode * new_inode = new_dentry->d_inode;
 	struct page * dir_page = NULL;
@@ -219,11 +212,6 @@ static int minix_rename(struct inode * old_dir, struct dentry *old_dentry,
 			drop_nlink(new_inode);
 		inode_dec_link_count(new_inode);
 	} else {
-		if (dir_de) {
-			err = -EMLINK;
-			if (new_dir->i_nlink >= info->s_link_max)
-				goto out_dir;
-		}
 		err = minix_add_link(new_dentry, old_inode);
 		if (err)
 			goto out_dir;
diff --git a/fs/namei.c b/fs/namei.c
index 208c6aa..45f953c 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2545,6 +2545,7 @@ SYSCALL_DEFINE3(mknod, const char __user *, filename, umode_t, mode, unsigned, d
 int vfs_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
 {
 	int error = may_create(dir, dentry);
+	unsigned max_links = dir->i_sb->s_max_links;
 
 	if (error)
 		return error;
@@ -2557,6 +2558,9 @@ int vfs_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
 	if (error)
 		return error;
 
+	if (max_links && dir->i_nlink >= max_links)
+		return -EMLINK;
+
 	error = dir->i_op->mkdir(dir, dentry, mode);
 	if (!error)
 		fsnotify_mkdir(dir, dentry);
@@ -2887,6 +2891,7 @@ SYSCALL_DEFINE2(symlink, const char __user *, oldname, const char __user *, newn
 int vfs_link(struct dentry *old_dentry, struct inode *dir, struct dentry *new_dentry)
 {
 	struct inode *inode = old_dentry->d_inode;
+	unsigned max_links = dir->i_sb->s_max_links;
 	int error;
 
 	if (!inode)
@@ -2917,6 +2922,8 @@ int vfs_link(struct dentry *old_dentry, struct inode *dir, struct dentry *new_de
 	/* Make sure we don't allow creating hardlink to an unlinked file */
 	if (inode->i_nlink == 0)
 		error =  -ENOENT;
+	else if (max_links && inode->i_nlink >= max_links)
+		error = -EMLINK;
 	else
 		error = dir->i_op->link(old_dentry, dir, new_dentry);
 	mutex_unlock(&inode->i_mutex);
@@ -3026,6 +3033,7 @@ static int vfs_rename_dir(struct inode *old_dir, struct dentry *old_dentry,
 {
 	int error = 0;
 	struct inode *target = new_dentry->d_inode;
+	unsigned max_links = new_dir->i_sb->s_max_links;
 
 	/*
 	 * If we are going to change the parent - check write permissions,
@@ -3049,6 +3057,11 @@ static int vfs_rename_dir(struct inode *old_dir, struct dentry *old_dentry,
 	if (d_mountpoint(old_dentry) || d_mountpoint(new_dentry))
 		goto out;
 
+	error = -EMLINK;
+	if (max_links && !target && new_dir != old_dir &&
+	    new_dir->i_nlink >= max_links)
+		goto out;
+
 	if (target)
 		shrink_dcache_parent(new_dentry);
 	error = old_dir->i_op->rename(old_dir, old_dentry, new_dir, new_dentry);
diff --git a/fs/nilfs2/namei.c b/fs/nilfs2/namei.c
index 1cd3f62..fce2bbe 100644
--- a/fs/nilfs2/namei.c
+++ b/fs/nilfs2/namei.c
@@ -193,9 +193,6 @@ static int nilfs_link(struct dentry *old_dentry, struct inode *dir,
 	struct nilfs_transaction_info ti;
 	int err;
 
-	if (inode->i_nlink >= NILFS_LINK_MAX)
-		return -EMLINK;
-
 	err = nilfs_transaction_begin(dir->i_sb, &ti, 1);
 	if (err)
 		return err;
@@ -219,9 +216,6 @@ static int nilfs_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
 	struct nilfs_transaction_info ti;
 	int err;
 
-	if (dir->i_nlink >= NILFS_LINK_MAX)
-		return -EMLINK;
-
 	err = nilfs_transaction_begin(dir->i_sb, &ti, 1);
 	if (err)
 		return err;
@@ -400,11 +394,6 @@ static int nilfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 		drop_nlink(new_inode);
 		nilfs_mark_inode_dirty(new_inode);
 	} else {
-		if (dir_de) {
-			err = -EMLINK;
-			if (new_dir->i_nlink >= NILFS_LINK_MAX)
-				goto out_dir;
-		}
 		err = nilfs_add_link(new_dentry, old_inode);
 		if (err)
 			goto out_dir;
diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index 08e3d4f..1fc9ad3 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -1059,6 +1059,7 @@ nilfs_fill_super(struct super_block *sb, void *data, int silent)
 	sb->s_export_op = &nilfs_export_ops;
 	sb->s_root = NULL;
 	sb->s_time_gran = 1;
+	sb->s_max_links = NILFS_LINK_MAX;
 
 	bdi = sb->s_bdev->bd_inode->i_mapping->backing_dev_info;
 	sb->s_bdi = bdi ? : &default_backing_dev_info;
diff --git a/fs/sysv/namei.c b/fs/sysv/namei.c
index b217797..d7466e2 100644
--- a/fs/sysv/namei.c
+++ b/fs/sysv/namei.c
@@ -121,9 +121,6 @@ static int sysv_link(struct dentry * old_dentry, struct inode * dir,
 {
 	struct inode *inode = old_dentry->d_inode;
 
-	if (inode->i_nlink >= SYSV_SB(inode->i_sb)->s_link_max)
-		return -EMLINK;
-
 	inode->i_ctime = CURRENT_TIME_SEC;
 	inode_inc_link_count(inode);
 	ihold(inode);
@@ -134,10 +131,8 @@ static int sysv_link(struct dentry * old_dentry, struct inode * dir,
 static int sysv_mkdir(struct inode * dir, struct dentry *dentry, umode_t mode)
 {
 	struct inode * inode;
-	int err = -EMLINK;
+	int err;
 
-	if (dir->i_nlink >= SYSV_SB(dir->i_sb)->s_link_max) 
-		goto out;
 	inode_inc_link_count(dir);
 
 	inode = sysv_new_inode(dir, S_IFDIR|mode);
@@ -251,11 +246,6 @@ static int sysv_rename(struct inode * old_dir, struct dentry * old_dentry,
 			drop_nlink(new_inode);
 		inode_dec_link_count(new_inode);
 	} else {
-		if (dir_de) {
-			err = -EMLINK;
-			if (new_dir->i_nlink >= SYSV_SB(new_dir->i_sb)->s_link_max)
-				goto out_dir;
-		}
 		err = sysv_add_link(new_dentry, old_inode);
 		if (err)
 			goto out_dir;
diff --git a/fs/sysv/super.c b/fs/sysv/super.c
index f60c196..f467740 100644
--- a/fs/sysv/super.c
+++ b/fs/sysv/super.c
@@ -44,7 +44,7 @@ enum {
 	JAN_1_1980 = (10*365 + 2) * 24 * 60 * 60
 };
 
-static void detected_xenix(struct sysv_sb_info *sbi)
+static void detected_xenix(struct sysv_sb_info *sbi, unsigned *max_links)
 {
 	struct buffer_head *bh1 = sbi->s_bh1;
 	struct buffer_head *bh2 = sbi->s_bh2;
@@ -59,7 +59,7 @@ static void detected_xenix(struct sysv_sb_info *sbi)
 		sbd2 = (struct xenix_super_block *) (bh2->b_data - 512);
 	}
 
-	sbi->s_link_max = XENIX_LINK_MAX;
+	*max_links = XENIX_LINK_MAX;
 	sbi->s_fic_size = XENIX_NICINOD;
 	sbi->s_flc_size = XENIX_NICFREE;
 	sbi->s_sbd1 = (char *)sbd1;
@@ -75,7 +75,7 @@ static void detected_xenix(struct sysv_sb_info *sbi)
 	sbi->s_nzones = fs32_to_cpu(sbi, sbd1->s_fsize);
 }
 
-static void detected_sysv4(struct sysv_sb_info *sbi)
+static void detected_sysv4(struct sysv_sb_info *sbi, unsigned *max_links)
 {
 	struct sysv4_super_block * sbd;
 	struct buffer_head *bh1 = sbi->s_bh1;
@@ -86,7 +86,7 @@ static void detected_sysv4(struct sysv_sb_info *sbi)
 	else
 		sbd = (struct sysv4_super_block *) bh2->b_data;
 
-	sbi->s_link_max = SYSV_LINK_MAX;
+	*max_links = SYSV_LINK_MAX;
 	sbi->s_fic_size = SYSV_NICINOD;
 	sbi->s_flc_size = SYSV_NICFREE;
 	sbi->s_sbd1 = (char *)sbd;
@@ -103,7 +103,7 @@ static void detected_sysv4(struct sysv_sb_info *sbi)
 	sbi->s_nzones = fs32_to_cpu(sbi, sbd->s_fsize);
 }
 
-static void detected_sysv2(struct sysv_sb_info *sbi)
+static void detected_sysv2(struct sysv_sb_info *sbi, unsigned *max_links)
 {
 	struct sysv2_super_block *sbd;
 	struct buffer_head *bh1 = sbi->s_bh1;
@@ -114,7 +114,7 @@ static void detected_sysv2(struct sysv_sb_info *sbi)
 	else
 		sbd = (struct sysv2_super_block *) bh2->b_data;
 
-	sbi->s_link_max = SYSV_LINK_MAX;
+	*max_links = SYSV_LINK_MAX;
 	sbi->s_fic_size = SYSV_NICINOD;
 	sbi->s_flc_size = SYSV_NICFREE;
 	sbi->s_sbd1 = (char *)sbd;
@@ -131,14 +131,14 @@ static void detected_sysv2(struct sysv_sb_info *sbi)
 	sbi->s_nzones = fs32_to_cpu(sbi, sbd->s_fsize);
 }
 
-static void detected_coherent(struct sysv_sb_info *sbi)
+static void detected_coherent(struct sysv_sb_info *sbi, unsigned *max_links)
 {
 	struct coh_super_block * sbd;
 	struct buffer_head *bh1 = sbi->s_bh1;
 
 	sbd = (struct coh_super_block *) bh1->b_data;
 
-	sbi->s_link_max = COH_LINK_MAX;
+	*max_links = COH_LINK_MAX;
 	sbi->s_fic_size = COH_NICINOD;
 	sbi->s_flc_size = COH_NICFREE;
 	sbi->s_sbd1 = (char *)sbd;
@@ -154,12 +154,12 @@ static void detected_coherent(struct sysv_sb_info *sbi)
 	sbi->s_nzones = fs32_to_cpu(sbi, sbd->s_fsize);
 }
 
-static void detected_v7(struct sysv_sb_info *sbi)
+static void detected_v7(struct sysv_sb_info *sbi, unsigned *max_links)
 {
 	struct buffer_head *bh2 = sbi->s_bh2;
 	struct v7_super_block *sbd = (struct v7_super_block *)bh2->b_data;
 
-	sbi->s_link_max = V7_LINK_MAX;
+	*max_links = V7_LINK_MAX;
 	sbi->s_fic_size = V7_NICINOD;
 	sbi->s_flc_size = V7_NICFREE;
 	sbi->s_sbd1 = (char *)sbd;
@@ -290,7 +290,7 @@ static char *flavour_names[] = {
 	[FSTYPE_AFS]	= "AFS",
 };
 
-static void (*flavour_setup[])(struct sysv_sb_info *) = {
+static void (*flavour_setup[])(struct sysv_sb_info *, unsigned *) = {
 	[FSTYPE_XENIX]	= detected_xenix,
 	[FSTYPE_SYSV4]	= detected_sysv4,
 	[FSTYPE_SYSV2]	= detected_sysv2,
@@ -310,7 +310,7 @@ static int complete_read_super(struct super_block *sb, int silent, int size)
 
 	sbi->s_firstinodezone = 2;
 
-	flavour_setup[sbi->s_type](sbi);
+	flavour_setup[sbi->s_type](sbi, &sb->s_max_links);
 	
 	sbi->s_truncate = 1;
 	sbi->s_ndatazones = sbi->s_nzones - sbi->s_firstdatazone;
diff --git a/fs/sysv/sysv.h b/fs/sysv/sysv.h
index 0e4b821..11b0767 100644
--- a/fs/sysv/sysv.h
+++ b/fs/sysv/sysv.h
@@ -24,7 +24,6 @@ struct sysv_sb_info {
 	char	       s_bytesex;	/* bytesex (le/be/pdp) */
 	char	       s_truncate;	/* if 1: names > SYSV_NAMELEN chars are truncated */
 					/* if 0: they are disallowed (ENAMETOOLONG) */
-	nlink_t        s_link_max;	/* max number of hard links to a file */
 	unsigned int   s_inodes_per_block;	/* number of inodes per block */
 	unsigned int   s_inodes_per_block_1;	/* inodes_per_block - 1 */
 	unsigned int   s_inodes_per_block_bits;	/* log2(inodes_per_block) */
diff --git a/fs/udf/namei.c b/fs/udf/namei.c
index 08bf46e..38de8f2 100644
--- a/fs/udf/namei.c
+++ b/fs/udf/namei.c
@@ -32,8 +32,6 @@
 #include <linux/crc-itu-t.h>
 #include <linux/exportfs.h>
 
-enum { UDF_MAX_LINKS = 0xffff };
-
 static inline int udf_match(int len1, const unsigned char *name1, int len2,
 			    const unsigned char *name2)
 {
@@ -649,10 +647,6 @@ static int udf_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
 	struct udf_inode_info *dinfo = UDF_I(dir);
 	struct udf_inode_info *iinfo;
 
-	err = -EMLINK;
-	if (dir->i_nlink >= UDF_MAX_LINKS)
-		goto out;
-
 	err = -EIO;
 	inode = udf_new_inode(dir, S_IFDIR | mode, &err);
 	if (!inode)
@@ -1032,9 +1026,6 @@ static int udf_link(struct dentry *old_dentry, struct inode *dir,
 	struct fileIdentDesc cfi, *fi;
 	int err;
 
-	if (inode->i_nlink >= UDF_MAX_LINKS)
-		return -EMLINK;
-
 	fi = udf_add_entry(dir, dentry, &fibh, &cfi, &err);
 	if (!fi) {
 		return err;
@@ -1126,10 +1117,6 @@ static int udf_rename(struct inode *old_dir, struct dentry *old_dentry,
 		if (udf_get_lb_pblock(old_inode->i_sb, &tloc, 0) !=
 				old_dir->i_ino)
 			goto end_rename;
-
-		retval = -EMLINK;
-		if (!new_inode && new_dir->i_nlink >= UDF_MAX_LINKS)
-			goto end_rename;
 	}
 	if (!nfi) {
 		nfi = udf_add_entry(new_dir, new_dentry, &nfibh, &ncfi,
diff --git a/fs/udf/super.c b/fs/udf/super.c
index c09a84d..8d8b253 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -75,6 +75,8 @@
 
 #define UDF_DEFAULT_BLOCKSIZE 2048
 
+enum { UDF_MAX_LINKS = 0xffff };
+
 /* These are the "meat" - everything else is stuffing */
 static int udf_fill_super(struct super_block *, void *, int);
 static void udf_put_super(struct super_block *);
@@ -2042,6 +2044,7 @@ static int udf_fill_super(struct super_block *sb, void *options, int silent)
 		goto error_out;
 	}
 	sb->s_maxbytes = MAX_LFS_FILESIZE;
+	sb->s_max_links = UDF_MAX_LINKS;
 	return 0;
 
 error_out:
diff --git a/fs/ufs/namei.c b/fs/ufs/namei.c
index 38cac19..a2281ca 100644
--- a/fs/ufs/namei.c
+++ b/fs/ufs/namei.c
@@ -166,10 +166,6 @@ static int ufs_link (struct dentry * old_dentry, struct inode * dir,
 	int error;
 
 	lock_ufs(dir->i_sb);
-	if (inode->i_nlink >= UFS_LINK_MAX) {
-		unlock_ufs(dir->i_sb);
-		return -EMLINK;
-	}
 
 	inode->i_ctime = CURRENT_TIME_SEC;
 	inode_inc_link_count(inode);
@@ -183,10 +179,7 @@ static int ufs_link (struct dentry * old_dentry, struct inode * dir,
 static int ufs_mkdir(struct inode * dir, struct dentry * dentry, umode_t mode)
 {
 	struct inode * inode;
-	int err = -EMLINK;
-
-	if (dir->i_nlink >= UFS_LINK_MAX)
-		goto out;
+	int err;
 
 	lock_ufs(dir->i_sb);
 	inode_inc_link_count(dir);
@@ -305,11 +298,6 @@ static int ufs_rename(struct inode *old_dir, struct dentry *old_dentry,
 			drop_nlink(new_inode);
 		inode_dec_link_count(new_inode);
 	} else {
-		if (dir_de) {
-			err = -EMLINK;
-			if (new_dir->i_nlink >= UFS_LINK_MAX)
-				goto out_dir;
-		}
 		err = ufs_add_link(new_dentry, old_inode);
 		if (err)
 			goto out_dir;
diff --git a/fs/ufs/super.c b/fs/ufs/super.c
index 5246ee3..ec25d09 100644
--- a/fs/ufs/super.c
+++ b/fs/ufs/super.c
@@ -1157,6 +1157,7 @@ magic_found:
 			    "fast symlink size (%u)\n", uspi->s_maxsymlinklen);
 		uspi->s_maxsymlinklen = maxsymlen;
 	}
+	sb->s_max_links = UFS_LINK_MAX;
 
 	inode = ufs_iget(sb, UFS_ROOTINO);
 	if (IS_ERR(inode)) {
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 386da09..1e49554 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1459,6 +1459,7 @@ struct super_block {
 	u8 s_uuid[16];				/* UUID */
 
 	void 			*s_fs_info;	/* Filesystem private info */
+	unsigned int		s_max_links;
 	fmode_t			s_mode;
 
 	/* Granularity of c/m/atime in ns.
