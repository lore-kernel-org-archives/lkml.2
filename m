Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755515Ab2BUSSV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 13:18:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4301 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755424Ab2BUSRl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 13:17:41 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 05/73] VFS: Pass mount flags to sget() [ver #2]
To: linux-fsdevel@vger.kernel.org, viro@ZenIV.linux.org.uk,
        valerie.aurora@gmail.com
Cc: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
Date: Tue, 21 Feb 2012 17:58:01 +0000
Message-ID: <20120221175801.25235.29100.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120221175721.25235.8901.stgit@warthog.procyon.org.uk>
References: <20120221175721.25235.8901.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pass mount flags to sget() so that it can use them in initialising a new
superblock before the set function is called.  They could also be passed to the
compare function.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 drivers/mtd/mtdsuper.c |    4 +---
 fs/9p/vfs_super.c      |    4 ++--
 fs/afs/super.c         |    3 +--
 fs/btrfs/super.c       |    4 ++--
 fs/ceph/super.c        |    2 +-
 fs/cifs/cifsfs.c       |    9 ++++-----
 fs/devpts/inode.c      |    6 +++---
 fs/ecryptfs/main.c     |    3 +--
 fs/gfs2/ops_fstype.c   |    5 ++---
 fs/libfs.c             |    4 ++--
 fs/logfs/super.c       |    3 +--
 fs/nfs/super.c         |   10 +++++-----
 fs/nilfs2/super.c      |    4 ++--
 fs/proc/root.c         |    3 +--
 fs/reiserfs/procfs.c   |    2 +-
 fs/super.c             |   22 +++++++++++-----------
 fs/sysfs/mount.c       |    3 +--
 fs/ubifs/super.c       |    3 +--
 include/linux/fs.h     |    2 +-
 kernel/cgroup.c        |    2 +-
 20 files changed, 44 insertions(+), 54 deletions(-)

diff --git a/drivers/mtd/mtdsuper.c b/drivers/mtd/mtdsuper.c
index a90bfe7..334da5f 100644
--- a/drivers/mtd/mtdsuper.c
+++ b/drivers/mtd/mtdsuper.c
@@ -63,7 +63,7 @@ static struct dentry *mount_mtd_aux(struct file_system_type *fs_type, int flags,
 	struct super_block *sb;
 	int ret;
 
-	sb = sget(fs_type, get_sb_mtd_compare, get_sb_mtd_set, mtd);
+	sb = sget(fs_type, get_sb_mtd_compare, get_sb_mtd_set, flags, mtd);
 	if (IS_ERR(sb))
 		goto out_error;
 
@@ -74,8 +74,6 @@ static struct dentry *mount_mtd_aux(struct file_system_type *fs_type, int flags,
 	pr_debug("MTDSB: New superblock for device %d (\"%s\")\n",
 	      mtd->index, mtd->name);
 
-	sb->s_flags = flags;
-
 	ret = fill_super(sb, data, flags & MS_SILENT ? 1 : 0);
 	if (ret < 0) {
 		deactivate_locked_super(sb);
diff --git a/fs/9p/vfs_super.c b/fs/9p/vfs_super.c
index 7b0cd87..347034c 100644
--- a/fs/9p/vfs_super.c
+++ b/fs/9p/vfs_super.c
@@ -89,7 +89,7 @@ v9fs_fill_super(struct super_block *sb, struct v9fs_session_info *v9ses,
 	if (v9ses->cache)
 		sb->s_bdi->ra_pages = (VM_MAX_READAHEAD * 1024)/PAGE_CACHE_SIZE;
 
-	sb->s_flags = flags | MS_ACTIVE | MS_DIRSYNC | MS_NOATIME;
+	sb->s_flags |= MS_ACTIVE | MS_DIRSYNC | MS_NOATIME;
 	if (!v9ses->cache)
 		sb->s_flags |= MS_SYNCHRONOUS;
 
@@ -137,7 +137,7 @@ static struct dentry *v9fs_mount(struct file_system_type *fs_type, int flags,
 		goto close_session;
 	}
 
-	sb = sget(fs_type, NULL, v9fs_set_super, v9ses);
+	sb = sget(fs_type, NULL, v9fs_set_super, flags, v9ses);
 	if (IS_ERR(sb)) {
 		retval = PTR_ERR(sb);
 		goto clunk_fid;
diff --git a/fs/afs/super.c b/fs/afs/super.c
index 983ec59..be87270 100644
--- a/fs/afs/super.c
+++ b/fs/afs/super.c
@@ -398,7 +398,7 @@ static struct dentry *afs_mount(struct file_system_type *fs_type,
 	as->volume = vol;
 
 	/* allocate a deviceless superblock */
-	sb = sget(fs_type, afs_test_super, afs_set_super, as);
+	sb = sget(fs_type, afs_test_super, afs_set_super, flags, as);
 	if (IS_ERR(sb)) {
 		ret = PTR_ERR(sb);
 		afs_put_volume(vol);
@@ -409,7 +409,6 @@ static struct dentry *afs_mount(struct file_system_type *fs_type,
 	if (!sb->s_root) {
 		/* initial superblock/root creation */
 		_debug("create");
-		sb->s_flags = flags;
 		ret = afs_fill_super(sb, &params);
 		if (ret < 0) {
 			deactivate_locked_super(sb);
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 3ce97b2..650b5ca 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -961,7 +961,8 @@ static struct dentry *btrfs_mount(struct file_system_type *fs_type, int flags,
 	}
 
 	bdev = fs_devices->latest_bdev;
-	s = sget(fs_type, btrfs_test_super, btrfs_set_super, fs_info);
+	s = sget(fs_type, btrfs_test_super, btrfs_set_super, flags | MS_NOSEC,
+		 fs_info);
 	if (IS_ERR(s)) {
 		error = PTR_ERR(s);
 		goto error_close_devices;
@@ -975,7 +976,6 @@ static struct dentry *btrfs_mount(struct file_system_type *fs_type, int flags,
 	} else {
 		char b[BDEVNAME_SIZE];
 
-		s->s_flags = flags | MS_NOSEC;
 		strlcpy(s->s_id, bdevname(bdev, b), sizeof(s->s_id));
 		btrfs_sb(s)->bdev_holder = fs_type;
 		error = btrfs_fill_super(s, fs_devices, data,
diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index 00de2c9..2bc74f5 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -860,7 +860,7 @@ static struct dentry *ceph_mount(struct file_system_type *fs_type,
 
 	if (ceph_test_opt(fsc->client, NOSHARE))
 		compare_super = NULL;
-	sb = sget(fs_type, compare_super, ceph_set_super, fsc);
+	sb = sget(fs_type, compare_super, ceph_set_super, flags, fsc);
 	if (IS_ERR(sb)) {
 		res = ERR_CAST(sb);
 		goto out;
diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index b1fd382..64a15b7 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -632,7 +632,10 @@ cifs_do_mount(struct file_system_type *fs_type,
 	mnt_data.cifs_sb = cifs_sb;
 	mnt_data.flags = flags;
 
-	sb = sget(fs_type, cifs_match_super, cifs_set_super, &mnt_data);
+	/* BB should we make this contingent on mount parm? */
+	flags |= MS_NODIRATIME | MS_NOATIME;
+
+	sb = sget(fs_type, cifs_match_super, cifs_set_super, flags, &mnt_data);
 	if (IS_ERR(sb)) {
 		root = ERR_CAST(sb);
 		cifs_umount(cifs_sb);
@@ -643,10 +646,6 @@ cifs_do_mount(struct file_system_type *fs_type,
 		cFYI(1, "Use existing superblock");
 		cifs_umount(cifs_sb);
 	} else {
-		sb->s_flags = flags;
-		/* BB should we make this contingent on mount parm? */
-		sb->s_flags |= MS_NODIRATIME | MS_NOATIME;
-
 		rc = cifs_read_super(sb);
 		if (rc) {
 			root = ERR_PTR(rc);
diff --git a/fs/devpts/inode.c b/fs/devpts/inode.c
index c4e2a58..b596698 100644
--- a/fs/devpts/inode.c
+++ b/fs/devpts/inode.c
@@ -367,15 +367,15 @@ static struct dentry *devpts_mount(struct file_system_type *fs_type,
 		return ERR_PTR(error);
 
 	if (opts.newinstance)
-		s = sget(fs_type, NULL, set_anon_super, NULL);
+		s = sget(fs_type, NULL, set_anon_super, flags, NULL);
 	else
-		s = sget(fs_type, compare_init_pts_sb, set_anon_super, NULL);
+		s = sget(fs_type, compare_init_pts_sb, set_anon_super, flags,
+			 NULL);
 
 	if (IS_ERR(s))
 		return ERR_CAST(s);
 
 	if (!s->s_root) {
-		s->s_flags = flags;
 		error = devpts_fill_super(s, data, flags & MS_SILENT ? 1 : 0);
 		if (error)
 			goto out_undo_sget;
diff --git a/fs/ecryptfs/main.c b/fs/ecryptfs/main.c
index b4a6bef..99c273d 100644
--- a/fs/ecryptfs/main.c
+++ b/fs/ecryptfs/main.c
@@ -499,13 +499,12 @@ static struct dentry *ecryptfs_mount(struct file_system_type *fs_type, int flags
 		goto out;
 	}
 
-	s = sget(fs_type, NULL, set_anon_super, NULL);
+	s = sget(fs_type, NULL, set_anon_super, flags, NULL);
 	if (IS_ERR(s)) {
 		rc = PTR_ERR(s);
 		goto out;
 	}
 
-	s->s_flags = flags;
 	rc = bdi_setup_and_register(&sbi->bdi, "ecryptfs", BDI_CAP_MAP_COPY);
 	if (rc)
 		goto out1;
diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index 6aacf3f..0528e2e 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -1282,7 +1282,7 @@ static struct dentry *gfs2_mount(struct file_system_type *fs_type, int flags,
 		error = -EBUSY;
 		goto error_bdev;
 	}
-	s = sget(fs_type, test_gfs2_super, set_gfs2_super, bdev);
+	s = sget(fs_type, test_gfs2_super, set_gfs2_super, flags, bdev);
 	mutex_unlock(&bdev->bd_fsfreeze_mutex);
 	error = PTR_ERR(s);
 	if (IS_ERR(s))
@@ -1312,7 +1312,6 @@ static struct dentry *gfs2_mount(struct file_system_type *fs_type, int flags,
 	} else {
 		char b[BDEVNAME_SIZE];
 
-		s->s_flags = flags;
 		s->s_mode = mode;
 		strlcpy(s->s_id, bdevname(bdev, b), sizeof(s->s_id));
 		sb_set_blocksize(s, block_size(bdev));
@@ -1356,7 +1355,7 @@ static struct dentry *gfs2_mount_meta(struct file_system_type *fs_type,
 		       dev_name, error);
 		return ERR_PTR(error);
 	}
-	s = sget(&gfs2_fs_type, test_gfs2_super, set_meta_super,
+	s = sget(&gfs2_fs_type, test_gfs2_super, set_meta_super, flags,
 		 path.dentry->d_inode->i_sb->s_bdev);
 	path_put(&path);
 	if (IS_ERR(s)) {
diff --git a/fs/libfs.c b/fs/libfs.c
index 5b2dbb3..38eb46d 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -222,15 +222,15 @@ struct dentry *mount_pseudo(struct file_system_type *fs_type, char *name,
 	const struct super_operations *ops,
 	const struct dentry_operations *dops, unsigned long magic)
 {
-	struct super_block *s = sget(fs_type, NULL, set_anon_super, NULL);
+	struct super_block *s;
 	struct dentry *dentry;
 	struct inode *root;
 	struct qstr d_name = {.name = name, .len = strlen(name)};
 
+	s = sget(fs_type, NULL, set_anon_super, MS_NOUSER, NULL);
 	if (IS_ERR(s))
 		return ERR_CAST(s);
 
-	s->s_flags = MS_NOUSER;
 	s->s_maxbytes = MAX_LFS_FILESIZE;
 	s->s_blocksize = PAGE_SIZE;
 	s->s_blocksize_bits = PAGE_SHIFT;
diff --git a/fs/logfs/super.c b/fs/logfs/super.c
index c9ee7f5..deb2798 100644
--- a/fs/logfs/super.c
+++ b/fs/logfs/super.c
@@ -521,7 +521,7 @@ static struct dentry *logfs_get_sb_device(struct logfs_super *super,
 	log_super("LogFS: Start mount %x\n", mount_count++);
 
 	err = -EINVAL;
-	sb = sget(type, logfs_sb_test, logfs_sb_set, super);
+	sb = sget(type, logfs_sb_test, logfs_sb_set, flags | MS_NOATIME, super);
 	if (IS_ERR(sb)) {
 		super->s_devops->put_device(super);
 		kfree(super);
@@ -543,7 +543,6 @@ static struct dentry *logfs_get_sb_device(struct logfs_super *super,
 	 */
 	sb->s_maxbytes	= (1ull << 43) - 1;
 	sb->s_op	= &logfs_super_operations;
-	sb->s_flags	= flags | MS_NOATIME;
 
 	err = logfs_read_sb(sb, sb->s_flags & MS_RDONLY);
 	if (err)
diff --git a/fs/nfs/super.c b/fs/nfs/super.c
index 3dfa4f1..925ef28 100644
--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -2265,7 +2265,7 @@ static struct dentry *nfs_fs_mount(struct file_system_type *fs_type,
 		sb_mntdata.mntflags |= MS_SYNCHRONOUS;
 
 	/* Get a superblock - note that we may end up sharing one that already exists */
-	s = sget(fs_type, compare_super, nfs_set_super, &sb_mntdata);
+	s = sget(fs_type, compare_super, nfs_set_super, flags, &sb_mntdata);
 	if (IS_ERR(s)) {
 		mntroot = ERR_CAST(s);
 		goto out_err_nosb;
@@ -2376,7 +2376,7 @@ nfs_xdev_mount(struct file_system_type *fs_type, int flags,
 		sb_mntdata.mntflags |= MS_SYNCHRONOUS;
 
 	/* Get a superblock - note that we may end up sharing one that already exists */
-	s = sget(&nfs_fs_type, compare_super, nfs_set_super, &sb_mntdata);
+	s = sget(&nfs_fs_type, compare_super, nfs_set_super, flags, &sb_mntdata);
 	if (IS_ERR(s)) {
 		error = PTR_ERR(s);
 		goto out_err_nosb;
@@ -2645,7 +2645,7 @@ nfs4_remote_mount(struct file_system_type *fs_type, int flags,
 		sb_mntdata.mntflags |= MS_SYNCHRONOUS;
 
 	/* Get a superblock - note that we may end up sharing one that already exists */
-	s = sget(&nfs4_fs_type, compare_super, nfs_set_super, &sb_mntdata);
+	s = sget(&nfs4_fs_type, compare_super, nfs_set_super, flags, &sb_mntdata);
 	if (IS_ERR(s)) {
 		error = PTR_ERR(s);
 		goto out_free;
@@ -2906,7 +2906,7 @@ nfs4_xdev_mount(struct file_system_type *fs_type, int flags,
 		sb_mntdata.mntflags |= MS_SYNCHRONOUS;
 
 	/* Get a superblock - note that we may end up sharing one that already exists */
-	s = sget(&nfs4_fs_type, compare_super, nfs_set_super, &sb_mntdata);
+	s = sget(&nfs4_fs_type, compare_super, nfs_set_super, flags, &sb_mntdata);
 	if (IS_ERR(s)) {
 		error = PTR_ERR(s);
 		goto out_err_nosb;
@@ -2997,7 +2997,7 @@ nfs4_remote_referral_mount(struct file_system_type *fs_type, int flags,
 		sb_mntdata.mntflags |= MS_SYNCHRONOUS;
 
 	/* Get a superblock - note that we may end up sharing one that already exists */
-	s = sget(&nfs4_fs_type, compare_super, nfs_set_super, &sb_mntdata);
+	s = sget(&nfs4_fs_type, compare_super, nfs_set_super, flags, &sb_mntdata);
 	if (IS_ERR(s)) {
 		error = PTR_ERR(s);
 		goto out_err_nosb;
diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index 08e3d4f..4c81adb 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -1288,7 +1288,8 @@ nilfs_mount(struct file_system_type *fs_type, int flags,
 		err = -EBUSY;
 		goto failed;
 	}
-	s = sget(fs_type, nilfs_test_bdev_super, nilfs_set_bdev_super, sd.bdev);
+	s = sget(fs_type, nilfs_test_bdev_super, nilfs_set_bdev_super, flags,
+		 sd.bdev);
 	mutex_unlock(&sd.bdev->bd_fsfreeze_mutex);
 	if (IS_ERR(s)) {
 		err = PTR_ERR(s);
@@ -1301,7 +1302,6 @@ nilfs_mount(struct file_system_type *fs_type, int flags,
 		s_new = true;
 
 		/* New superblock instance created */
-		s->s_flags = flags;
 		s->s_mode = mode;
 		strlcpy(s->s_id, bdevname(sd.bdev, b), sizeof(s->s_id));
 		sb_set_blocksize(s, block_size(sd.bdev));
diff --git a/fs/proc/root.c b/fs/proc/root.c
index 46a15d8..eaa5164 100644
--- a/fs/proc/root.c
+++ b/fs/proc/root.c
@@ -111,12 +111,11 @@ static struct dentry *proc_mount(struct file_system_type *fs_type,
 		options = data;
 	}
 
-	sb = sget(fs_type, proc_test_super, proc_set_super, ns);
+	sb = sget(fs_type, proc_test_super, proc_set_super, flags, ns);
 	if (IS_ERR(sb))
 		return ERR_CAST(sb);
 
 	if (!sb->s_root) {
-		sb->s_flags = flags;
 		if (!proc_parse_options(options, ns)) {
 			deactivate_locked_super(sb);
 			return ERR_PTR(-EINVAL);
diff --git a/fs/reiserfs/procfs.c b/fs/reiserfs/procfs.c
index 7a99811..de42b03 100644
--- a/fs/reiserfs/procfs.c
+++ b/fs/reiserfs/procfs.c
@@ -404,7 +404,7 @@ static void *r_start(struct seq_file *m, loff_t * pos)
 	if (l)
 		return NULL;
 
-	if (IS_ERR(sget(&reiserfs_fs_type, test_sb, set_sb, s)))
+	if (IS_ERR(sget(&reiserfs_fs_type, test_sb, set_sb, 0, s)))
 		return NULL;
 
 	up_write(&s->s_umount);
diff --git a/fs/super.c b/fs/super.c
index 6277ec6..f343eda 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -104,11 +104,12 @@ static int prune_super(struct shrinker *shrink, struct shrink_control *sc)
 /**
  *	alloc_super	-	create new superblock
  *	@type:	filesystem type superblock should belong to
+ *	@flags: the mount flags
  *
  *	Allocates and initializes a new &struct super_block.  alloc_super()
  *	returns a pointer new superblock or %NULL if allocation had failed.
  */
-static struct super_block *alloc_super(struct file_system_type *type)
+static struct super_block *alloc_super(struct file_system_type *type, int flags)
 {
 	struct super_block *s = kzalloc(sizeof(struct super_block),  GFP_USER);
 	static const struct super_operations default_op;
@@ -135,6 +136,7 @@ static struct super_block *alloc_super(struct file_system_type *type)
 #else
 		INIT_LIST_HEAD(&s->s_files);
 #endif
+		s->s_flags = flags;
 		s->s_bdi = &default_backing_dev_info;
 		INIT_HLIST_NODE(&s->s_instances);
 		INIT_HLIST_BL_HEAD(&s->s_anon);
@@ -414,11 +416,13 @@ EXPORT_SYMBOL(generic_shutdown_super);
  *	@type:	filesystem type superblock should belong to
  *	@test:	comparison callback
  *	@set:	setup callback
+ *	@flags:	mount flags
  *	@data:	argument to each of them
  */
 struct super_block *sget(struct file_system_type *type,
 			int (*test)(struct super_block *,void *),
 			int (*set)(struct super_block *,void *),
+			int flags,
 			void *data)
 {
 	struct super_block *s = NULL;
@@ -449,7 +453,7 @@ retry:
 	}
 	if (!s) {
 		spin_unlock(&sb_lock);
-		s = alloc_super(type);
+		s = alloc_super(type, flags);
 		if (!s)
 			return ERR_PTR(-ENOMEM);
 		goto retry;
@@ -924,13 +928,12 @@ struct dentry *mount_ns(struct file_system_type *fs_type, int flags,
 {
 	struct super_block *sb;
 
-	sb = sget(fs_type, ns_test_super, ns_set_super, data);
+	sb = sget(fs_type, ns_test_super, ns_set_super, flags, data);
 	if (IS_ERR(sb))
 		return ERR_CAST(sb);
 
 	if (!sb->s_root) {
 		int err;
-		sb->s_flags = flags;
 		err = fill_super(sb, data, flags & MS_SILENT ? 1 : 0);
 		if (err) {
 			deactivate_locked_super(sb);
@@ -991,7 +994,8 @@ struct dentry *mount_bdev(struct file_system_type *fs_type,
 		error = -EBUSY;
 		goto error_bdev;
 	}
-	s = sget(fs_type, test_bdev_super, set_bdev_super, bdev);
+	s = sget(fs_type, test_bdev_super, set_bdev_super, flags | MS_NOSEC,
+		 bdev);
 	mutex_unlock(&bdev->bd_fsfreeze_mutex);
 	if (IS_ERR(s))
 		goto error_s;
@@ -1016,7 +1020,6 @@ struct dentry *mount_bdev(struct file_system_type *fs_type,
 	} else {
 		char b[BDEVNAME_SIZE];
 
-		s->s_flags = flags | MS_NOSEC;
 		s->s_mode = mode;
 		strlcpy(s->s_id, bdevname(bdev, b), sizeof(s->s_id));
 		sb_set_blocksize(s, block_size(bdev));
@@ -1061,13 +1064,11 @@ struct dentry *mount_nodev(struct file_system_type *fs_type,
 	int (*fill_super)(struct super_block *, void *, int))
 {
 	int error;
-	struct super_block *s = sget(fs_type, NULL, set_anon_super, NULL);
+	struct super_block *s = sget(fs_type, NULL, set_anon_super, flags, NULL);
 
 	if (IS_ERR(s))
 		return ERR_CAST(s);
 
-	s->s_flags = flags;
-
 	error = fill_super(s, data, flags & MS_SILENT ? 1 : 0);
 	if (error) {
 		deactivate_locked_super(s);
@@ -1090,11 +1091,10 @@ struct dentry *mount_single(struct file_system_type *fs_type,
 	struct super_block *s;
 	int error;
 
-	s = sget(fs_type, compare_single, set_anon_super, NULL);
+	s = sget(fs_type, compare_single, set_anon_super, flags, NULL);
 	if (IS_ERR(s))
 		return ERR_CAST(s);
 	if (!s->s_root) {
-		s->s_flags = flags;
 		error = fill_super(s, data, flags & MS_SILENT ? 1 : 0);
 		if (error) {
 			deactivate_locked_super(s);
diff --git a/fs/sysfs/mount.c b/fs/sysfs/mount.c
index e34f0d9..a6674da 100644
--- a/fs/sysfs/mount.c
+++ b/fs/sysfs/mount.c
@@ -118,13 +118,12 @@ static struct dentry *sysfs_mount(struct file_system_type *fs_type,
 	for (type = KOBJ_NS_TYPE_NONE; type < KOBJ_NS_TYPES; type++)
 		info->ns[type] = kobj_ns_grab_current(type);
 
-	sb = sget(fs_type, sysfs_test_super, sysfs_set_super, info);
+	sb = sget(fs_type, sysfs_test_super, sysfs_set_super, flags, info);
 	if (IS_ERR(sb) || sb->s_fs_info != info)
 		free_sysfs_super_info(info);
 	if (IS_ERR(sb))
 		return ERR_CAST(sb);
 	if (!sb->s_root) {
-		sb->s_flags = flags;
 		error = sysfs_fill_super(sb, data, flags & MS_SILENT ? 1 : 0);
 		if (error) {
 			deactivate_locked_super(sb);
diff --git a/fs/ubifs/super.c b/fs/ubifs/super.c
index 63765d5..c3488d7 100644
--- a/fs/ubifs/super.c
+++ b/fs/ubifs/super.c
@@ -2141,7 +2141,7 @@ static struct dentry *ubifs_mount(struct file_system_type *fs_type, int flags,
 
 	dbg_gen("opened ubi%d_%d", c->vi.ubi_num, c->vi.vol_id);
 
-	sb = sget(fs_type, sb_test, sb_set, c);
+	sb = sget(fs_type, sb_test, sb_set, flags, c);
 	if (IS_ERR(sb)) {
 		err = PTR_ERR(sb);
 		kfree(c);
@@ -2158,7 +2158,6 @@ static struct dentry *ubifs_mount(struct file_system_type *fs_type, int flags,
 			goto out_deact;
 		}
 	} else {
-		sb->s_flags = flags;
 		err = ubifs_fill_super(sb, data, flags & MS_SILENT ? 1 : 0);
 		if (err)
 			goto out_deact;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 69cd5bb..d851be9 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1864,7 +1864,7 @@ void free_anon_bdev(dev_t);
 struct super_block *sget(struct file_system_type *type,
 			int (*test)(struct super_block *,void *),
 			int (*set)(struct super_block *,void *),
-			void *data);
+			int flags, void *data);
 extern struct dentry *mount_pseudo(struct file_system_type *, char *,
 	const struct super_operations *ops,
 	const struct dentry_operations *dops,
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index a5d3b53..d51bcce 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1522,7 +1522,7 @@ static struct dentry *cgroup_mount(struct file_system_type *fs_type,
 	opts.new_root = new_root;
 
 	/* Locate an existing or new sb for this hierarchy */
-	sb = sget(fs_type, cgroup_test_super, cgroup_set_super, &opts);
+	sb = sget(fs_type, cgroup_test_super, cgroup_set_super, 0, &opts);
 	if (IS_ERR(sb)) {
 		ret = PTR_ERR(sb);
 		cgroup_drop_root(opts.new_root);

