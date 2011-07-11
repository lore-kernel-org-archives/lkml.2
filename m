Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757788Ab1GKOui (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 10:50:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63839 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757753Ab1GKOuf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 10:50:35 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 1/2] VFS: Pass mount flags to sget()
To: peterz@infradead.org
Cc: dhowells@redhat.com, aviro@redhat.com, hch@infradead.org,
        hramrach@centrum.cz, ikent@redhat.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, jmoyer@redhat.com, miklos@szeredi.hu
Date: Mon, 11 Jul 2011 15:49:48 +0100
Message-ID: <20110711144948.17985.33525.stgit@warthog.procyon.org.uk>
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
index 16b02a1..45ade10 100644
--- a/drivers/mtd/mtdsuper.c
+++ b/drivers/mtd/mtdsuper.c
@@ -62,7 +62,7 @@ static struct dentry *mount_mtd_aux(struct file_system_type *fs_type, int flags,
 	struct super_block *sb;
 	int ret;
 
-	sb = sget(fs_type, get_sb_mtd_compare, get_sb_mtd_set, mtd);
+	sb = sget(fs_type, get_sb_mtd_compare, get_sb_mtd_set, flags, mtd);
 	if (IS_ERR(sb))
 		goto out_error;
 
@@ -73,8 +73,6 @@ static struct dentry *mount_mtd_aux(struct file_system_type *fs_type, int flags,
 	DEBUG(1, "MTDSB: New superblock for device %d (\"%s\")\n",
 	      mtd->index, mtd->name);
 
-	sb->s_flags = flags;
-
 	ret = fill_super(sb, data, flags & MS_SILENT ? 1 : 0);
 	if (ret < 0) {
 		deactivate_locked_super(sb);
diff --git a/fs/9p/vfs_super.c b/fs/9p/vfs_super.c
index feef6cd..0d163c5 100644
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
index 356dcf0..3c859b9 100644
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
index 0bb4ebb..c6d6836 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -808,7 +808,8 @@ static struct dentry *btrfs_mount(struct file_system_type *fs_type, int flags,
 	tree_root->fs_info = fs_info;
 
 	bdev = fs_devices->latest_bdev;
-	s = sget(fs_type, btrfs_test_super, btrfs_set_super, tree_root);
+	s = sget(fs_type, btrfs_test_super, btrfs_set_super, flags | MS_NOSEC,
+		 tree_root);
 	if (IS_ERR(s))
 		goto error_s;
 
@@ -825,7 +826,6 @@ static struct dentry *btrfs_mount(struct file_system_type *fs_type, int flags,
 	} else {
 		char b[BDEVNAME_SIZE];
 
-		s->s_flags = flags | MS_NOSEC;
 		strlcpy(s->s_id, bdevname(bdev, b), sizeof(s->s_id));
 		error = btrfs_fill_super(s, fs_devices, data,
 					 flags & MS_SILENT ? 1 : 0);
diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index f2f77fd..82710f6 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -823,7 +823,7 @@ static struct dentry *ceph_mount(struct file_system_type *fs_type,
 
 	if (ceph_test_opt(fsc->client, NOSHARE))
 		compare_super = NULL;
-	sb = sget(fs_type, compare_super, ceph_set_super, fsc);
+	sb = sget(fs_type, compare_super, ceph_set_super, flags, fsc);
 	if (IS_ERR(sb)) {
 		res = ERR_CAST(sb);
 		goto out;
diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 35f9154..834367e 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -679,7 +679,10 @@ cifs_do_mount(struct file_system_type *fs_type,
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
@@ -690,10 +693,6 @@ cifs_do_mount(struct file_system_type *fs_type,
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
index 2f27e57..4154d08 100644
--- a/fs/devpts/inode.c
+++ b/fs/devpts/inode.c
@@ -369,15 +369,15 @@ static struct dentry *devpts_mount(struct file_system_type *fs_type,
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
index 9f1bb74..46ac2b2 100644
--- a/fs/ecryptfs/main.c
+++ b/fs/ecryptfs/main.c
@@ -489,13 +489,12 @@ static struct dentry *ecryptfs_mount(struct file_system_type *fs_type, int flags
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
index 8ac9ae1..80f24ce 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -1278,7 +1278,7 @@ static struct dentry *gfs2_mount(struct file_system_type *fs_type, int flags,
 		error = -EBUSY;
 		goto error_bdev;
 	}
-	s = sget(fs_type, test_gfs2_super, set_gfs2_super, bdev);
+	s = sget(fs_type, test_gfs2_super, set_gfs2_super, flags, bdev);
 	mutex_unlock(&bdev->bd_fsfreeze_mutex);
 	error = PTR_ERR(s);
 	if (IS_ERR(s))
@@ -1308,7 +1308,6 @@ static struct dentry *gfs2_mount(struct file_system_type *fs_type, int flags,
 	} else {
 		char b[BDEVNAME_SIZE];
 
-		s->s_flags = flags;
 		s->s_mode = mode;
 		strlcpy(s->s_id, bdevname(bdev, b), sizeof(s->s_id));
 		sb_set_blocksize(s, block_size(bdev));
@@ -1352,7 +1351,7 @@ static struct dentry *gfs2_mount_meta(struct file_system_type *fs_type,
 		       dev_name, error);
 		return ERR_PTR(error);
 	}
-	s = sget(&gfs2_fs_type, test_gfs2_super, set_meta_super,
+	s = sget(&gfs2_fs_type, test_gfs2_super, set_meta_super, flags,
 		 path.dentry->d_inode->i_sb->s_bdev);
 	path_put(&path);
 	if (IS_ERR(s)) {
diff --git a/fs/libfs.c b/fs/libfs.c
index c88eab5..130d4f7 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -220,15 +220,15 @@ struct dentry *mount_pseudo(struct file_system_type *fs_type, char *name,
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
index ce03a18..322888a 100644
--- a/fs/logfs/super.c
+++ b/fs/logfs/super.c
@@ -541,7 +541,7 @@ static struct dentry *logfs_get_sb_device(struct logfs_super *super,
 	log_super("LogFS: Start mount %x\n", mount_count++);
 
 	err = -EINVAL;
-	sb = sget(type, logfs_sb_test, logfs_sb_set, super);
+	sb = sget(type, logfs_sb_test, logfs_sb_set, flags | MS_NOATIME, super);
 	if (IS_ERR(sb)) {
 		super->s_devops->put_device(super);
 		kfree(super);
@@ -563,7 +563,6 @@ static struct dentry *logfs_get_sb_device(struct logfs_super *super,
 	 */
 	sb->s_maxbytes	= (1ull << 43) - 1;
 	sb->s_op	= &logfs_super_operations;
-	sb->s_flags	= flags | MS_NOATIME;
 
 	err = logfs_read_sb(sb, sb->s_flags & MS_RDONLY);
 	if (err)
diff --git a/fs/nfs/super.c b/fs/nfs/super.c
index ce40e5c..4d2ea32 100644
--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -2250,7 +2250,7 @@ static struct dentry *nfs_fs_mount(struct file_system_type *fs_type,
 		compare_super = NULL;
 
 	/* Get a superblock - note that we may end up sharing one that already exists */
-	s = sget(fs_type, compare_super, nfs_set_super, &sb_mntdata);
+	s = sget(fs_type, compare_super, nfs_set_super, flags, &sb_mntdata);
 	if (IS_ERR(s)) {
 		mntroot = ERR_CAST(s);
 		goto out_err_nosb;
@@ -2362,7 +2362,7 @@ nfs_xdev_mount(struct file_system_type *fs_type, int flags,
 		compare_super = NULL;
 
 	/* Get a superblock - note that we may end up sharing one that already exists */
-	s = sget(&nfs_fs_type, compare_super, nfs_set_super, &sb_mntdata);
+	s = sget(&nfs_fs_type, compare_super, nfs_set_super, flags, &sb_mntdata);
 	if (IS_ERR(s)) {
 		error = PTR_ERR(s);
 		goto out_err_nosb;
@@ -2629,7 +2629,7 @@ nfs4_remote_mount(struct file_system_type *fs_type, int flags,
 		compare_super = NULL;
 
 	/* Get a superblock - note that we may end up sharing one that already exists */
-	s = sget(&nfs4_fs_type, compare_super, nfs_set_super, &sb_mntdata);
+	s = sget(&nfs4_fs_type, compare_super, nfs_set_super, flags, &sb_mntdata);
 	if (IS_ERR(s)) {
 		error = PTR_ERR(s);
 		goto out_free;
@@ -2923,7 +2923,7 @@ nfs4_xdev_mount(struct file_system_type *fs_type, int flags,
 		compare_super = NULL;
 
 	/* Get a superblock - note that we may end up sharing one that already exists */
-	s = sget(&nfs4_fs_type, compare_super, nfs_set_super, &sb_mntdata);
+	s = sget(&nfs4_fs_type, compare_super, nfs_set_super, flags, &sb_mntdata);
 	if (IS_ERR(s)) {
 		error = PTR_ERR(s);
 		goto out_err_nosb;
@@ -3010,7 +3010,7 @@ nfs4_remote_referral_mount(struct file_system_type *fs_type, int flags,
 		compare_super = NULL;
 
 	/* Get a superblock - note that we may end up sharing one that already exists */
-	s = sget(&nfs4_fs_type, compare_super, nfs_set_super, &sb_mntdata);
+	s = sget(&nfs4_fs_type, compare_super, nfs_set_super, flags, &sb_mntdata);
 	if (IS_ERR(s)) {
 		error = PTR_ERR(s);
 		goto out_err_nosb;
diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index 8351c44..1a36d5d 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -1290,7 +1290,8 @@ nilfs_mount(struct file_system_type *fs_type, int flags,
 		err = -EBUSY;
 		goto failed;
 	}
-	s = sget(fs_type, nilfs_test_bdev_super, nilfs_set_bdev_super, sd.bdev);
+	s = sget(fs_type, nilfs_test_bdev_super, nilfs_set_bdev_super, flags,
+		 sd.bdev);
 	mutex_unlock(&sd.bdev->bd_fsfreeze_mutex);
 	if (IS_ERR(s)) {
 		err = PTR_ERR(s);
@@ -1303,7 +1304,6 @@ nilfs_mount(struct file_system_type *fs_type, int flags,
 		s_new = true;
 
 		/* New superblock instance created */
-		s->s_flags = flags;
 		s->s_mode = mode;
 		strlcpy(s->s_id, bdevname(sd.bdev, b), sizeof(s->s_id));
 		sb_set_blocksize(s, block_size(sd.bdev));
diff --git a/fs/proc/root.c b/fs/proc/root.c
index d6c3b41..e393f12 100644
--- a/fs/proc/root.c
+++ b/fs/proc/root.c
@@ -49,12 +49,11 @@ static struct dentry *proc_mount(struct file_system_type *fs_type,
 	else
 		ns = current->nsproxy->pid_ns;
 
-	sb = sget(fs_type, proc_test_super, proc_set_super, ns);
+	sb = sget(fs_type, proc_test_super, proc_set_super, flags, ns);
 	if (IS_ERR(sb))
 		return ERR_CAST(sb);
 
 	if (!sb->s_root) {
-		sb->s_flags = flags;
 		err = proc_fill_super(sb);
 		if (err) {
 			deactivate_locked_super(sb);
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
index ab3d672..1a36e98 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -41,11 +41,12 @@ DEFINE_SPINLOCK(sb_lock);
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
@@ -72,6 +73,7 @@ static struct super_block *alloc_super(struct file_system_type *type)
 #else
 		INIT_LIST_HEAD(&s->s_files);
 #endif
+		s->s_flags = flags;
 		s->s_bdi = &default_backing_dev_info;
 		INIT_LIST_HEAD(&s->s_instances);
 		INIT_HLIST_BL_HEAD(&s->s_anon);
@@ -311,11 +313,13 @@ EXPORT_SYMBOL(generic_shutdown_super);
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
@@ -345,7 +349,7 @@ retry:
 	}
 	if (!s) {
 		spin_unlock(&sb_lock);
-		s = alloc_super(type);
+		s = alloc_super(type, flags);
 		if (!s)
 			return ERR_PTR(-ENOMEM);
 		goto retry;
@@ -730,13 +734,12 @@ struct dentry *mount_ns(struct file_system_type *fs_type, int flags,
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
@@ -797,7 +800,8 @@ struct dentry *mount_bdev(struct file_system_type *fs_type,
 		error = -EBUSY;
 		goto error_bdev;
 	}
-	s = sget(fs_type, test_bdev_super, set_bdev_super, bdev);
+	s = sget(fs_type, test_bdev_super, set_bdev_super, flags | MS_NOSEC,
+		 bdev);
 	mutex_unlock(&bdev->bd_fsfreeze_mutex);
 	if (IS_ERR(s))
 		goto error_s;
@@ -822,7 +826,6 @@ struct dentry *mount_bdev(struct file_system_type *fs_type,
 	} else {
 		char b[BDEVNAME_SIZE];
 
-		s->s_flags = flags | MS_NOSEC;
 		s->s_mode = mode;
 		strlcpy(s->s_id, bdevname(bdev, b), sizeof(s->s_id));
 		sb_set_blocksize(s, block_size(bdev));
@@ -867,13 +870,11 @@ struct dentry *mount_nodev(struct file_system_type *fs_type,
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
@@ -896,11 +897,10 @@ struct dentry *mount_single(struct file_system_type *fs_type,
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
index 529be05..d628df8 100644
--- a/fs/ubifs/super.c
+++ b/fs/ubifs/super.c
@@ -2142,7 +2142,7 @@ static struct dentry *ubifs_mount(struct file_system_type *fs_type, int flags,
 
 	dbg_gen("opened ubi%d_%d", c->vi.ubi_num, c->vi.vol_id);
 
-	sb = sget(fs_type, sb_test, sb_set, c);
+	sb = sget(fs_type, sb_test, sb_set, flags, c);
 	if (IS_ERR(sb)) {
 		err = PTR_ERR(sb);
 		kfree(c);
@@ -2159,7 +2159,6 @@ static struct dentry *ubifs_mount(struct file_system_type *fs_type, int flags,
 			goto out_deact;
 		}
 	} else {
-		sb->s_flags = flags;
 		err = ubifs_fill_super(sb, data, flags & MS_SILENT ? 1 : 0);
 		if (err)
 			goto out_deact;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index b5b9792..602167b 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1840,7 +1840,7 @@ int set_anon_super(struct super_block *s, void *data);
 struct super_block *sget(struct file_system_type *type,
 			int (*test)(struct super_block *,void *),
 			int (*set)(struct super_block *,void *),
-			void *data);
+			int flags, void *data);
 extern struct dentry *mount_pseudo(struct file_system_type *, char *,
 	const struct super_operations *ops,
 	const struct dentry_operations *dops,
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 2731d11..916924a 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1499,7 +1499,7 @@ static struct dentry *cgroup_mount(struct file_system_type *fs_type,
 	opts.new_root = new_root;
 
 	/* Locate an existing or new sb for this hierarchy */
-	sb = sget(fs_type, cgroup_test_super, cgroup_set_super, &opts);
+	sb = sget(fs_type, cgroup_test_super, cgroup_set_super, 0, &opts);
 	if (IS_ERR(sb)) {
 		ret = PTR_ERR(sb);
 		cgroup_drop_root(opts.new_root);

