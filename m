Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753626Ab0K0KaO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Nov 2010 05:30:14 -0500
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:34780 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752886Ab0K0K01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Nov 2010 05:26:27 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAO1p8Ex5Lcx2/2dsb2JhbACjC3K9doVHBIph
Message-Id: <e91032e0381508474ccd23e944146528c76fc8c3.1290852959.git.npiggin@kernel.dk>
In-Reply-To: <cover.1290852958.git.npiggin@kernel.dk>
References: <cover.1290852958.git.npiggin@kernel.dk>
From: Nick Piggin <npiggin@kernel.dk>
Date: Sat, 27 Nov 2010 20:45:06 +1100
Subject: [PATCH 36/46] fs: dcache reduce branches in lookup path
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reduce some branches and memory accesses in dcache lookup by adding dentry
flags to indicate common d_ops are set, rather than having to check them.
This saves a pointer memory access (dentry->d_op) in common path lookup
situations, and saves another pointer load and branch in cases where we
have d_op but not the particular operation.

Patched with:

git grep -l "d_op =" | xargs sed -e 's/\([^\t ]*\)->d_op = \(.*\);/d_set_d_op(\1, \2);/' -e 's/\([^\t ]*\)\.d_op = \(.*\);/d_set_d_op(\&\1, \2);/' -i

Signed-off-by: Nick Piggin <npiggin@kernel.dk>
---
 arch/ia64/kernel/perfmon.c    |    2 +-
 drivers/staging/autofs/root.c |    2 +-
 fs/9p/vfs_inode.c             |   26 +++++++++++++-------------
 fs/adfs/dir.c                 |    2 +-
 fs/adfs/super.c               |    2 +-
 fs/affs/namei.c               |    2 +-
 fs/affs/super.c               |    2 +-
 fs/afs/dir.c                  |    2 +-
 fs/anon_inodes.c              |    2 +-
 fs/autofs4/inode.c            |    2 +-
 fs/autofs4/root.c             |   10 +++++-----
 fs/btrfs/export.c             |    4 ++--
 fs/btrfs/inode.c              |    2 +-
 fs/ceph/dir.c                 |    6 +++---
 fs/cifs/dir.c                 |   16 ++++++++--------
 fs/cifs/inode.c               |    8 ++++----
 fs/cifs/link.c                |    4 ++--
 fs/cifs/readdir.c             |    4 ++--
 fs/coda/dir.c                 |    2 +-
 fs/configfs/dir.c             |    8 ++++----
 fs/dcache.c                   |   25 +++++++++++++++++++++----
 fs/ecryptfs/inode.c           |    2 +-
 fs/ecryptfs/main.c            |    4 ++--
 fs/fat/inode.c                |    4 ++--
 fs/fat/namei_msdos.c          |    6 +++---
 fs/fat/namei_vfat.c           |    8 ++++----
 fs/fuse/dir.c                 |    2 +-
 fs/fuse/inode.c               |    4 ++--
 fs/gfs2/export.c              |    4 ++--
 fs/gfs2/ops_fstype.c          |    2 +-
 fs/gfs2/ops_inode.c           |    2 +-
 fs/hfs/dir.c                  |    2 +-
 fs/hfs/super.c                |    2 +-
 fs/hfsplus/dir.c              |    2 +-
 fs/hfsplus/super.c            |    2 +-
 fs/hostfs/hostfs_kern.c       |    2 +-
 fs/hpfs/dentry.c              |    2 +-
 fs/isofs/inode.c              |    2 +-
 fs/isofs/namei.c              |    2 +-
 fs/jfs/namei.c                |    4 ++--
 fs/jfs/super.c                |    2 +-
 fs/libfs.c                    |    2 +-
 fs/minix/namei.c              |    2 +-
 fs/namei.c                    |   31 ++++++++++++++++++++-----------
 fs/ncpfs/dir.c                |    4 ++--
 fs/ncpfs/inode.c              |    2 +-
 fs/nfs/dir.c                  |    6 +++---
 fs/nfs/getroot.c              |    4 ++--
 fs/ocfs2/export.c             |    4 ++--
 fs/ocfs2/namei.c              |   10 +++++-----
 fs/pipe.c                     |    2 +-
 fs/proc/base.c                |   12 ++++++------
 fs/proc/generic.c             |    2 +-
 fs/proc/proc_sysctl.c         |    4 ++--
 fs/reiserfs/xattr.c           |    2 +-
 fs/sysfs/dir.c                |    2 +-
 fs/sysv/namei.c               |    2 +-
 fs/sysv/super.c               |    2 +-
 include/linux/dcache.h        |    6 ++++++
 kernel/cgroup.c               |    2 +-
 net/socket.c                  |    2 +-
 net/sunrpc/rpc_pipe.c         |    2 +-
 62 files changed, 165 insertions(+), 133 deletions(-)

diff --git a/arch/ia64/kernel/perfmon.c b/arch/ia64/kernel/perfmon.c
index d39d8a5..5a24f40 100644
--- a/arch/ia64/kernel/perfmon.c
+++ b/arch/ia64/kernel/perfmon.c
@@ -2233,7 +2233,7 @@ pfm_alloc_file(pfm_context_t *ctx)
 	}
 	path.mnt = mntget(pfmfs_mnt);
 
-	path.dentry->d_op = &pfmfs_dentry_operations;
+	d_set_d_op(path.dentry, &pfmfs_dentry_operations);
 	d_add(path.dentry, inode);
 
 	file = alloc_file(&path, FMODE_READ, &pfm_file_ops);
diff --git a/drivers/staging/autofs/root.c b/drivers/staging/autofs/root.c
index 0fdec4b..b09adb5 100644
--- a/drivers/staging/autofs/root.c
+++ b/drivers/staging/autofs/root.c
@@ -237,7 +237,7 @@ static struct dentry *autofs_root_lookup(struct inode *dir, struct dentry *dentr
 	 *
 	 * We need to do this before we release the directory semaphore.
 	 */
-	dentry->d_op = &autofs_dentry_operations;
+	d_set_d_op(dentry, &autofs_dentry_operations);
 	dentry->d_flags |= DCACHE_AUTOFS_PENDING;
 	d_add(dentry, NULL);
 
diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index f6f9081..df8bbb3 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -635,9 +635,9 @@ v9fs_create(struct v9fs_session_info *v9ses, struct inode *dir,
 	}
 
 	if (v9ses->cache)
-		dentry->d_op = &v9fs_cached_dentry_operations;
+		d_set_d_op(dentry, &v9fs_cached_dentry_operations);
 	else
-		dentry->d_op = &v9fs_dentry_operations;
+		d_set_d_op(dentry, &v9fs_dentry_operations);
 
 	d_instantiate(dentry, inode);
 	err = v9fs_fid_add(dentry, fid);
@@ -749,7 +749,7 @@ v9fs_vfs_create_dotl(struct inode *dir, struct dentry *dentry, int omode,
 				err);
 			goto error;
 		}
-		dentry->d_op = &v9fs_cached_dentry_operations;
+		d_set_d_op(dentry, &v9fs_cached_dentry_operations);
 		d_instantiate(dentry, inode);
 		err = v9fs_fid_add(dentry, fid);
 		if (err < 0)
@@ -767,7 +767,7 @@ v9fs_vfs_create_dotl(struct inode *dir, struct dentry *dentry, int omode,
 			err = PTR_ERR(inode);
 			goto error;
 		}
-		dentry->d_op = &v9fs_dentry_operations;
+		d_set_d_op(dentry, &v9fs_dentry_operations);
 		d_instantiate(dentry, inode);
 	}
 	/* Now set the ACL based on the default value */
@@ -956,7 +956,7 @@ static int v9fs_vfs_mkdir_dotl(struct inode *dir,
 				err);
 			goto error;
 		}
-		dentry->d_op = &v9fs_cached_dentry_operations;
+		d_set_d_op(dentry, &v9fs_cached_dentry_operations);
 		d_instantiate(dentry, inode);
 		err = v9fs_fid_add(dentry, fid);
 		if (err < 0)
@@ -973,7 +973,7 @@ static int v9fs_vfs_mkdir_dotl(struct inode *dir,
 			err = PTR_ERR(inode);
 			goto error;
 		}
-		dentry->d_op = &v9fs_dentry_operations;
+		d_set_d_op(dentry, &v9fs_dentry_operations);
 		d_instantiate(dentry, inode);
 	}
 	/* Now set the ACL based on the default value */
@@ -1041,9 +1041,9 @@ static struct dentry *v9fs_vfs_lookup(struct inode *dir, struct dentry *dentry,
 
 inst_out:
 	if (v9ses->cache)
-		dentry->d_op = &v9fs_cached_dentry_operations;
+		d_set_d_op(dentry, &v9fs_cached_dentry_operations);
 	else
-		dentry->d_op = &v9fs_dentry_operations;
+		d_set_d_op(dentry, &v9fs_dentry_operations);
 
 	d_add(dentry, inode);
 	return NULL;
@@ -1709,7 +1709,7 @@ v9fs_vfs_symlink_dotl(struct inode *dir, struct dentry *dentry,
 					err);
 			goto error;
 		}
-		dentry->d_op = &v9fs_cached_dentry_operations;
+		d_set_d_op(dentry, &v9fs_cached_dentry_operations);
 		d_instantiate(dentry, inode);
 		err = v9fs_fid_add(dentry, fid);
 		if (err < 0)
@@ -1722,7 +1722,7 @@ v9fs_vfs_symlink_dotl(struct inode *dir, struct dentry *dentry,
 			err = PTR_ERR(inode);
 			goto error;
 		}
-		dentry->d_op = &v9fs_dentry_operations;
+		d_set_d_op(dentry, &v9fs_dentry_operations);
 		d_instantiate(dentry, inode);
 	}
 
@@ -1856,7 +1856,7 @@ v9fs_vfs_link_dotl(struct dentry *old_dentry, struct inode *dir,
 		ihold(old_dentry->d_inode);
 	}
 
-	dentry->d_op = old_dentry->d_op;
+	d_set_d_op(dentry, old_dentry->d_op);
 	d_instantiate(dentry, old_dentry->d_inode);
 
 	return err;
@@ -1980,7 +1980,7 @@ v9fs_vfs_mknod_dotl(struct inode *dir, struct dentry *dentry, int omode,
 				err);
 			goto error;
 		}
-		dentry->d_op = &v9fs_cached_dentry_operations;
+		d_set_d_op(dentry, &v9fs_cached_dentry_operations);
 		d_instantiate(dentry, inode);
 		err = v9fs_fid_add(dentry, fid);
 		if (err < 0)
@@ -1996,7 +1996,7 @@ v9fs_vfs_mknod_dotl(struct inode *dir, struct dentry *dentry, int omode,
 			err = PTR_ERR(inode);
 			goto error;
 		}
-		dentry->d_op = &v9fs_dentry_operations;
+		d_set_d_op(dentry, &v9fs_dentry_operations);
 		d_instantiate(dentry, inode);
 	}
 	/* Now set the ACL based on the default value */
diff --git a/fs/adfs/dir.c b/fs/adfs/dir.c
index a098bba..ee00001 100644
--- a/fs/adfs/dir.c
+++ b/fs/adfs/dir.c
@@ -276,7 +276,7 @@ adfs_lookup(struct inode *dir, struct dentry *dentry, struct nameidata *nd)
 	struct object_info obj;
 	int error;
 
-	dentry->d_op = &adfs_dentry_operations;	
+	d_set_d_op(dentry, &adfs_dentry_operations);
 	lock_kernel();
 	error = adfs_dir_lookup_byname(dir, &dentry->d_name, &obj);
 	if (error == 0) {
diff --git a/fs/adfs/super.c b/fs/adfs/super.c
index 47dffc5..a4041b5 100644
--- a/fs/adfs/super.c
+++ b/fs/adfs/super.c
@@ -484,7 +484,7 @@ static int adfs_fill_super(struct super_block *sb, void *data, int silent)
 		adfs_error(sb, "get root inode failed\n");
 		goto error;
 	} else
-		sb->s_root->d_op = &adfs_dentry_operations;
+		d_set_d_op(sb->s_root, &adfs_dentry_operations);
 	unlock_kernel();
 	return 0;
 
diff --git a/fs/affs/namei.c b/fs/affs/namei.c
index 91d5dcd..b69ba2d 100644
--- a/fs/affs/namei.c
+++ b/fs/affs/namei.c
@@ -238,7 +238,7 @@ affs_lookup(struct inode *dir, struct dentry *dentry, struct nameidata *nd)
 		if (IS_ERR(inode))
 			return ERR_CAST(inode);
 	}
-	dentry->d_op = AFFS_SB(sb)->s_flags & SF_INTL ? &affs_intl_dentry_operations : &affs_dentry_operations;
+	d_set_d_op(dentry, AFFS_SB(sb)->s_flags & SF_INTL ? &affs_intl_dentry_operations : &affs_dentry_operations);
 	d_add(dentry, inode);
 	return NULL;
 }
diff --git a/fs/affs/super.c b/fs/affs/super.c
index 4c18fcf..d39081b 100644
--- a/fs/affs/super.c
+++ b/fs/affs/super.c
@@ -482,7 +482,7 @@ got_root:
 		printk(KERN_ERR "AFFS: Get root inode failed\n");
 		goto out_error;
 	}
-	sb->s_root->d_op = &affs_dentry_operations;
+	d_set_d_op(sb->s_root, &affs_dentry_operations);
 
 	pr_debug("AFFS: s_flags=%lX\n",sb->s_flags);
 	return 0;
diff --git a/fs/afs/dir.c b/fs/afs/dir.c
index 2c18cde..b8bb7e7 100644
--- a/fs/afs/dir.c
+++ b/fs/afs/dir.c
@@ -581,7 +581,7 @@ static struct dentry *afs_lookup(struct inode *dir, struct dentry *dentry,
 	}
 
 success:
-	dentry->d_op = &afs_fs_dentry_operations;
+	d_set_d_op(dentry, &afs_fs_dentry_operations);
 
 	d_add(dentry, inode);
 	_leave(" = 0 { vn=%u u=%u } -> { ino=%lu v=%llu }",
diff --git a/fs/anon_inodes.c b/fs/anon_inodes.c
index 57ce55b..aca8806 100644
--- a/fs/anon_inodes.c
+++ b/fs/anon_inodes.c
@@ -113,7 +113,7 @@ struct file *anon_inode_getfile(const char *name,
 	 */
 	ihold(anon_inode_inode);
 
-	path.dentry->d_op = &anon_inodefs_dentry_operations;
+	d_set_d_op(path.dentry, &anon_inodefs_dentry_operations);
 	d_instantiate(path.dentry, anon_inode_inode);
 
 	error = -ENFILE;
diff --git a/fs/autofs4/inode.c b/fs/autofs4/inode.c
index ac87e49..a7bdb9d 100644
--- a/fs/autofs4/inode.c
+++ b/fs/autofs4/inode.c
@@ -309,7 +309,7 @@ int autofs4_fill_super(struct super_block *s, void *data, int silent)
 		goto fail_iput;
 	pipe = NULL;
 
-	root->d_op = &autofs4_sb_dentry_operations;
+	d_set_d_op(root, &autofs4_sb_dentry_operations);
 	root->d_fsdata = ino;
 
 	/* Can this call block? */
diff --git a/fs/autofs4/root.c b/fs/autofs4/root.c
index 3eaa251..5b0421f 100644
--- a/fs/autofs4/root.c
+++ b/fs/autofs4/root.c
@@ -571,7 +571,7 @@ static struct dentry *autofs4_lookup(struct inode *dir, struct dentry *dentry, s
 		 * we check for the hashed dentry and return the newly
 		 * hashed dentry.
 		 */
-		dentry->d_op = &autofs4_root_dentry_operations;
+		d_set_d_op(dentry, &autofs4_root_dentry_operations);
 
 		/*
 		 * And we need to ensure that the same dentry is used for
@@ -710,9 +710,9 @@ static int autofs4_dir_symlink(struct inode *dir,
 	d_add(dentry, inode);
 
 	if (dir == dir->i_sb->s_root->d_inode)
-		dentry->d_op = &autofs4_root_dentry_operations;
+		d_set_d_op(dentry, &autofs4_root_dentry_operations);
 	else
-		dentry->d_op = &autofs4_dentry_operations;
+		d_set_d_op(dentry, &autofs4_dentry_operations);
 
 	dentry->d_fsdata = ino;
 	ino->dentry = dget(dentry);
@@ -845,9 +845,9 @@ static int autofs4_dir_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 	d_add(dentry, inode);
 
 	if (dir == dir->i_sb->s_root->d_inode)
-		dentry->d_op = &autofs4_root_dentry_operations;
+		d_set_d_op(dentry, &autofs4_root_dentry_operations);
 	else
-		dentry->d_op = &autofs4_dentry_operations;
+		d_set_d_op(dentry, &autofs4_dentry_operations);
 
 	dentry->d_fsdata = ino;
 	ino->dentry = dget(dentry);
diff --git a/fs/btrfs/export.c b/fs/btrfs/export.c
index 951ef09..19ff716 100644
--- a/fs/btrfs/export.c
+++ b/fs/btrfs/export.c
@@ -110,7 +110,7 @@ static struct dentry *btrfs_get_dentry(struct super_block *sb, u64 objectid,
 
 	dentry = d_obtain_alias(inode);
 	if (!IS_ERR(dentry))
-		dentry->d_op = &btrfs_dentry_operations;
+		d_set_d_op(dentry, &btrfs_dentry_operations);
 	return dentry;
 fail:
 	srcu_read_unlock(&fs_info->subvol_srcu, index);
@@ -225,7 +225,7 @@ static struct dentry *btrfs_get_parent(struct dentry *child)
 	key.offset = 0;
 	dentry = d_obtain_alias(btrfs_iget(root->fs_info->sb, &key, root, NULL));
 	if (!IS_ERR(dentry))
-		dentry->d_op = &btrfs_dentry_operations;
+		d_set_d_op(dentry, &btrfs_dentry_operations);
 	return dentry;
 fail:
 	btrfs_free_path(path);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index c704fd1..aab3087 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4084,7 +4084,7 @@ struct inode *btrfs_lookup_dentry(struct inode *dir, struct dentry *dentry)
 	int index;
 	int ret;
 
-	dentry->d_op = &btrfs_dentry_operations;
+	d_set_d_op(dentry, &btrfs_dentry_operations);
 
 	if (dentry->d_name.len > BTRFS_NAME_LEN)
 		return ERR_PTR(-ENAMETOOLONG);
diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
index e42d2a1..5c89989 100644
--- a/fs/ceph/dir.c
+++ b/fs/ceph/dir.c
@@ -41,11 +41,11 @@ int ceph_init_dentry(struct dentry *dentry)
 		return 0;
 
 	if (ceph_snap(dentry->d_parent->d_inode) == CEPH_NOSNAP)
-		dentry->d_op = &ceph_dentry_ops;
+		d_set_d_op(dentry, &ceph_dentry_ops);
 	else if (ceph_snap(dentry->d_parent->d_inode) == CEPH_SNAPDIR)
-		dentry->d_op = &ceph_snapdir_dentry_ops;
+		d_set_d_op(dentry, &ceph_snapdir_dentry_ops);
 	else
-		dentry->d_op = &ceph_snap_dentry_ops;
+		d_set_d_op(dentry, &ceph_snap_dentry_ops);
 
 	di = kmem_cache_alloc(ceph_dentry_cachep, GFP_NOFS | __GFP_ZERO);
 	if (!di)
diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index 5227626..966f58c 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -135,9 +135,9 @@ static void setup_cifs_dentry(struct cifsTconInfo *tcon,
 			      struct inode *newinode)
 {
 	if (tcon->nocase)
-		direntry->d_op = &cifs_ci_dentry_ops;
+		d_set_d_op(direntry, &cifs_ci_dentry_ops);
 	else
-		direntry->d_op = &cifs_dentry_ops;
+		d_set_d_op(direntry, &cifs_dentry_ops);
 	d_instantiate(direntry, newinode);
 }
 
@@ -421,9 +421,9 @@ int cifs_mknod(struct inode *inode, struct dentry *direntry, int mode,
 		rc = cifs_get_inode_info_unix(&newinode, full_path,
 						inode->i_sb, xid);
 		if (pTcon->nocase)
-			direntry->d_op = &cifs_ci_dentry_ops;
+			d_set_d_op(direntry, &cifs_ci_dentry_ops);
 		else
-			direntry->d_op = &cifs_dentry_ops;
+			d_set_d_op(direntry, &cifs_dentry_ops);
 
 		if (rc == 0)
 			d_instantiate(direntry, newinode);
@@ -604,9 +604,9 @@ cifs_lookup(struct inode *parent_dir_inode, struct dentry *direntry,
 
 	if ((rc == 0) && (newInode != NULL)) {
 		if (pTcon->nocase)
-			direntry->d_op = &cifs_ci_dentry_ops;
+			d_set_d_op(direntry, &cifs_ci_dentry_ops);
 		else
-			direntry->d_op = &cifs_dentry_ops;
+			d_set_d_op(direntry, &cifs_dentry_ops);
 		d_add(direntry, newInode);
 		if (posix_open) {
 			filp = lookup_instantiate_filp(nd, direntry,
@@ -634,9 +634,9 @@ cifs_lookup(struct inode *parent_dir_inode, struct dentry *direntry,
 		rc = 0;
 		direntry->d_time = jiffies;
 		if (pTcon->nocase)
-			direntry->d_op = &cifs_ci_dentry_ops;
+			d_set_d_op(direntry, &cifs_ci_dentry_ops);
 		else
-			direntry->d_op = &cifs_dentry_ops;
+			d_set_d_op(direntry, &cifs_dentry_ops);
 		d_add(direntry, NULL);
 	/*	if it was once a directory (but how can we tell?) we could do
 		shrink_dcache_parent(direntry); */
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index ca901f0..76677de 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -1314,9 +1314,9 @@ int cifs_mkdir(struct inode *inode, struct dentry *direntry, int mode)
 	to set uid/gid */
 			inc_nlink(inode);
 			if (pTcon->nocase)
-				direntry->d_op = &cifs_ci_dentry_ops;
+				d_set_d_op(direntry, &cifs_ci_dentry_ops);
 			else
-				direntry->d_op = &cifs_dentry_ops;
+				d_set_d_op(direntry, &cifs_dentry_ops);
 
 			cifs_unix_basic_to_fattr(&fattr, pInfo, cifs_sb);
 			cifs_fill_uniqueid(inode->i_sb, &fattr);
@@ -1358,9 +1358,9 @@ mkdir_get_info:
 						 inode->i_sb, xid, NULL);
 
 		if (pTcon->nocase)
-			direntry->d_op = &cifs_ci_dentry_ops;
+			d_set_d_op(direntry, &cifs_ci_dentry_ops);
 		else
-			direntry->d_op = &cifs_dentry_ops;
+			d_set_d_op(direntry, &cifs_dentry_ops);
 		d_instantiate(direntry, newinode);
 		 /* setting nlink not necessary except in cases where we
 		  * failed to get it from the server or was set bogus */
diff --git a/fs/cifs/link.c b/fs/cifs/link.c
index 85cdbf8..fe2f6a9 100644
--- a/fs/cifs/link.c
+++ b/fs/cifs/link.c
@@ -525,9 +525,9 @@ cifs_symlink(struct inode *inode, struct dentry *direntry, const char *symname)
 			      rc);
 		} else {
 			if (pTcon->nocase)
-				direntry->d_op = &cifs_ci_dentry_ops;
+				d_set_d_op(direntry, &cifs_ci_dentry_ops);
 			else
-				direntry->d_op = &cifs_dentry_ops;
+				d_set_d_op(direntry, &cifs_dentry_ops);
 			d_instantiate(direntry, newinode);
 		}
 	}
diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
index ec5b2af..9d5b00f 100644
--- a/fs/cifs/readdir.c
+++ b/fs/cifs/readdir.c
@@ -103,9 +103,9 @@ cifs_readdir_lookup(struct dentry *parent, struct qstr *name,
 	}
 
 	if (cifs_sb_master_tcon(CIFS_SB(sb))->nocase)
-		dentry->d_op = &cifs_ci_dentry_ops;
+		d_set_d_op(dentry, &cifs_ci_dentry_ops);
 	else
-		dentry->d_op = &cifs_dentry_ops;
+		d_set_d_op(dentry, &cifs_dentry_ops);
 
 	alias = d_materialise_unique(dentry, inode);
 	if (alias != NULL) {
diff --git a/fs/coda/dir.c b/fs/coda/dir.c
index 9e37e8b..aa40c81 100644
--- a/fs/coda/dir.c
+++ b/fs/coda/dir.c
@@ -125,7 +125,7 @@ static struct dentry *coda_lookup(struct inode *dir, struct dentry *entry, struc
 		return ERR_PTR(error);
 
 exit:
-	entry->d_op = &coda_dentry_operations;
+	d_set_d_op(entry, &coda_dentry_operations);
 
 	if (inode && (type & CODA_NOCACHE))
 		coda_flag_inode(inode, C_VATTR | C_PURGE);
diff --git a/fs/configfs/dir.c b/fs/configfs/dir.c
index 5825780..8cd00c3 100644
--- a/fs/configfs/dir.c
+++ b/fs/configfs/dir.c
@@ -234,7 +234,7 @@ int configfs_make_dirent(struct configfs_dirent * parent_sd,
 	sd->s_dentry = dentry;
 	if (dentry) {
 		dentry->d_fsdata = configfs_get(sd);
-		dentry->d_op = &configfs_dentry_ops;
+		d_set_d_op(dentry, &configfs_dentry_ops);
 	}
 
 	return 0;
@@ -278,7 +278,7 @@ static int create_dir(struct config_item * k, struct dentry * p,
 		error = configfs_create(d, mode, init_dir);
 		if (!error) {
 			inc_nlink(p->d_inode);
-			(d)->d_op = &configfs_dentry_ops;
+			d_set_d_op((d), &configfs_dentry_ops);
 		} else {
 			struct configfs_dirent *sd = d->d_fsdata;
 			if (sd) {
@@ -372,7 +372,7 @@ int configfs_create_link(struct configfs_symlink *sl,
 	if (!err) {
 		err = configfs_create(dentry, mode, init_symlink);
 		if (!err)
-			dentry->d_op = &configfs_dentry_ops;
+			d_set_d_op(dentry, &configfs_dentry_ops);
 		else {
 			struct configfs_dirent *sd = dentry->d_fsdata;
 			if (sd) {
@@ -447,7 +447,7 @@ static int configfs_attach_attr(struct configfs_dirent * sd, struct dentry * den
 		return error;
 	}
 
-	dentry->d_op = &configfs_dentry_ops;
+	d_set_d_op(dentry, &configfs_dentry_ops);
 	d_rehash(dentry);
 
 	return 0;
diff --git a/fs/dcache.c b/fs/dcache.c
index c25be71..879e5b3 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -322,7 +322,7 @@ repeat:
  		return;
  	}
 
-	if (dentry->d_op && dentry->d_op->d_delete) {
+	if (dentry->d_flags & DCACHE_OP_DELETE) {
 		if (dentry->d_op->d_delete(dentry))
 			goto kill_it;
 	}
@@ -1234,6 +1234,23 @@ struct dentry *d_alloc_name(struct dentry *parent, const char *name)
 }
 EXPORT_SYMBOL(d_alloc_name);
 
+void d_set_d_op(struct dentry *dentry, const struct dentry_operations *op)
+{
+	dentry->d_op = op;
+	if (!op)
+		return;
+	if (op->d_hash)
+		dentry->d_flags |= DCACHE_OP_HASH;
+	if (op->d_compare)
+		dentry->d_flags |= DCACHE_OP_COMPARE;
+	if (op->d_revalidate)
+		dentry->d_flags |= DCACHE_OP_REVALIDATE;
+	if (op->d_delete)
+		dentry->d_flags |= DCACHE_OP_DELETE;
+
+}
+EXPORT_SYMBOL(d_set_d_op);
+
 static void __d_instantiate(struct dentry *dentry, struct inode *inode)
 {
 	spin_lock(&dentry->d_lock);
@@ -1651,7 +1668,7 @@ seqretry:
 		 */
 		if (read_seqcount_retry(&dentry->d_seq, *seq))
 			goto seqretry;
-		if (parent->d_op && parent->d_op->d_compare) {
+		if (parent->d_flags & DCACHE_OP_COMPARE) {
 			if (parent->d_op->d_compare(parent,
 						dentry, i,
 						tlen, tname, name))
@@ -1780,7 +1797,7 @@ struct dentry *__d_lookup(struct dentry *parent, struct qstr *name)
 		 */
 		tlen = dentry->d_name.len;
 		tname = dentry->d_name.name;
-		if (parent->d_op && parent->d_op->d_compare) {
+		if (parent->d_flags & DCACHE_OP_COMPARE) {
 			if (parent->d_op->d_compare(parent,
 						dentry, dentry->d_inode,
 						tlen, tname, name))
@@ -1821,7 +1838,7 @@ struct dentry *d_hash_and_lookup(struct dentry *dir, struct qstr *name)
 	 * routine may choose to leave the hash value unchanged.
 	 */
 	name->hash = full_name_hash(name->name, name->len);
-	if (dir->d_op && dir->d_op->d_hash) {
+	if (dir->d_flags & DCACHE_OP_HASH) {
 		if (dir->d_op->d_hash(dir, dir->d_inode, name) < 0)
 			goto out;
 	}
diff --git a/fs/ecryptfs/inode.c b/fs/ecryptfs/inode.c
index 5e5c7ec..f91b35d 100644
--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -441,7 +441,7 @@ static struct dentry *ecryptfs_lookup(struct inode *ecryptfs_dir_inode,
 	struct qstr lower_name;
 	int rc = 0;
 
-	ecryptfs_dentry->d_op = &ecryptfs_dops;
+	d_set_d_op(ecryptfs_dentry, &ecryptfs_dops);
 	if ((ecryptfs_dentry->d_name.len == 1
 	     && !strcmp(ecryptfs_dentry->d_name.name, "."))
 	    || (ecryptfs_dentry->d_name.len == 2
diff --git a/fs/ecryptfs/main.c b/fs/ecryptfs/main.c
index a9dbd62..3510386 100644
--- a/fs/ecryptfs/main.c
+++ b/fs/ecryptfs/main.c
@@ -189,7 +189,7 @@ int ecryptfs_interpose(struct dentry *lower_dentry, struct dentry *dentry,
 	if (special_file(lower_inode->i_mode))
 		init_special_inode(inode, lower_inode->i_mode,
 				   lower_inode->i_rdev);
-	dentry->d_op = &ecryptfs_dops;
+	d_set_d_op(dentry, &ecryptfs_dops);
 	fsstack_copy_attr_all(inode, lower_inode);
 	/* This size will be overwritten for real files w/ headers and
 	 * other metadata */
@@ -594,7 +594,7 @@ static struct dentry *ecryptfs_mount(struct file_system_type *fs_type, int flags
 		deactivate_locked_super(s);
 		goto out;
 	}
-	s->s_root->d_op = &ecryptfs_dops;
+	d_set_d_op(s->s_root, &ecryptfs_dops);
 	s->s_root->d_sb = s;
 	s->s_root->d_parent = s->s_root;
 
diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index 8cccfeb..206351a 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -750,7 +750,7 @@ static struct dentry *fat_fh_to_dentry(struct super_block *sb,
 	 */
 	result = d_obtain_alias(inode);
 	if (!IS_ERR(result))
-		result->d_op = sb->s_root->d_op;
+		d_set_d_op(result, sb->s_root->d_op);
 	return result;
 }
 
@@ -800,7 +800,7 @@ static struct dentry *fat_get_parent(struct dentry *child)
 
 	parent = d_obtain_alias(inode);
 	if (!IS_ERR(parent))
-		parent->d_op = sb->s_root->d_op;
+		d_set_d_op(parent, sb->s_root->d_op);
 out:
 	unlock_super(sb);
 
diff --git a/fs/fat/namei_msdos.c b/fs/fat/namei_msdos.c
index c5f32db..83ac1ba 100644
--- a/fs/fat/namei_msdos.c
+++ b/fs/fat/namei_msdos.c
@@ -228,10 +228,10 @@ static struct dentry *msdos_lookup(struct inode *dir, struct dentry *dentry,
 	}
 out:
 	unlock_super(sb);
-	dentry->d_op = &msdos_dentry_operations;
+	d_set_d_op(dentry, &msdos_dentry_operations);
 	dentry = d_splice_alias(inode, dentry);
 	if (dentry)
-		dentry->d_op = &msdos_dentry_operations;
+		d_set_d_op(dentry, &msdos_dentry_operations);
 	return dentry;
 
 error:
@@ -674,7 +674,7 @@ static int msdos_fill_super(struct super_block *sb, void *data, int silent)
 	}
 
 	sb->s_flags |= MS_NOATIME;
-	sb->s_root->d_op = &msdos_dentry_operations;
+	d_set_d_op(sb->s_root, &msdos_dentry_operations);
 	unlock_super(sb);
 	return 0;
 }
diff --git a/fs/fat/namei_vfat.c b/fs/fat/namei_vfat.c
index 6e4d02d..b721715 100644
--- a/fs/fat/namei_vfat.c
+++ b/fs/fat/namei_vfat.c
@@ -766,11 +766,11 @@ static struct dentry *vfat_lookup(struct inode *dir, struct dentry *dentry,
 
 out:
 	unlock_super(sb);
-	dentry->d_op = sb->s_root->d_op;
+	d_set_d_op(dentry, sb->s_root->d_op);
 	dentry->d_time = dentry->d_parent->d_inode->i_version;
 	dentry = d_splice_alias(inode, dentry);
 	if (dentry) {
-		dentry->d_op = sb->s_root->d_op;
+		d_set_d_op(dentry, sb->s_root->d_op);
 		dentry->d_time = dentry->d_parent->d_inode->i_version;
 	}
 	return dentry;
@@ -1078,9 +1078,9 @@ static int vfat_fill_super(struct super_block *sb, void *data, int silent)
 	}
 
 	if (MSDOS_SB(sb)->options.name_check != 's')
-		sb->s_root->d_op = &vfat_ci_dentry_ops;
+		d_set_d_op(sb->s_root, &vfat_ci_dentry_ops);
 	else
-		sb->s_root->d_op = &vfat_dentry_ops;
+		d_set_d_op(sb->s_root, &vfat_dentry_ops);
 
 	unlock_super(sb);
 	return 0;
diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index c9627c9..c9a8a42 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -347,7 +347,7 @@ static struct dentry *fuse_lookup(struct inode *dir, struct dentry *entry,
 	}
 
 	entry = newent ? newent : entry;
-	entry->d_op = &fuse_dentry_operations;
+	d_set_d_op(entry, &fuse_dentry_operations);
 	if (outarg_valid)
 		fuse_change_entry_timeout(entry, &outarg);
 	else
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index 44e0a6c..a8b31da 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -626,7 +626,7 @@ static struct dentry *fuse_get_dentry(struct super_block *sb,
 
 	entry = d_obtain_alias(inode);
 	if (!IS_ERR(entry) && get_node_id(inode) != FUSE_ROOT_ID) {
-		entry->d_op = &fuse_dentry_operations;
+		d_set_d_op(entry, &fuse_dentry_operations);
 		fuse_invalidate_entry_cache(entry);
 	}
 
@@ -728,7 +728,7 @@ static struct dentry *fuse_get_parent(struct dentry *child)
 
 	parent = d_obtain_alias(inode);
 	if (!IS_ERR(parent) && get_node_id(inode) != FUSE_ROOT_ID) {
-		parent->d_op = &fuse_dentry_operations;
+		d_set_d_op(parent, &fuse_dentry_operations);
 		fuse_invalidate_entry_cache(parent);
 	}
 
diff --git a/fs/gfs2/export.c b/fs/gfs2/export.c
index 5ab3839..97012ec 100644
--- a/fs/gfs2/export.c
+++ b/fs/gfs2/export.c
@@ -130,7 +130,7 @@ static struct dentry *gfs2_get_parent(struct dentry *child)
 
 	dentry = d_obtain_alias(gfs2_lookupi(child->d_inode, &gfs2_qdotdot, 1));
 	if (!IS_ERR(dentry))
-		dentry->d_op = &gfs2_dops;
+		d_set_d_op(dentry, &gfs2_dops);
 	return dentry;
 }
 
@@ -158,7 +158,7 @@ static struct dentry *gfs2_get_dentry(struct super_block *sb,
 out_inode:
 	dentry = d_obtain_alias(inode);
 	if (!IS_ERR(dentry))
-		dentry->d_op = &gfs2_dops;
+		d_set_d_op(dentry, &gfs2_dops);
 	return dentry;
 }
 
diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index 3eb1393..2aeabd4 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -440,7 +440,7 @@ static int gfs2_lookup_root(struct super_block *sb, struct dentry **dptr,
 		iput(inode);
 		return -ENOMEM;
 	}
-	dentry->d_op = &gfs2_dops;
+	d_set_d_op(dentry, &gfs2_dops);
 	*dptr = dentry;
 	return 0;
 }
diff --git a/fs/gfs2/ops_inode.c b/fs/gfs2/ops_inode.c
index 12cbea7..f28f897 100644
--- a/fs/gfs2/ops_inode.c
+++ b/fs/gfs2/ops_inode.c
@@ -106,7 +106,7 @@ static struct dentry *gfs2_lookup(struct inode *dir, struct dentry *dentry,
 {
 	struct inode *inode = NULL;
 
-	dentry->d_op = &gfs2_dops;
+	d_set_d_op(dentry, &gfs2_dops);
 
 	inode = gfs2_lookupi(dir, &dentry->d_name, 0);
 	if (inode && IS_ERR(inode))
diff --git a/fs/hfs/dir.c b/fs/hfs/dir.c
index 2b3b861..ea4aefe 100644
--- a/fs/hfs/dir.c
+++ b/fs/hfs/dir.c
@@ -25,7 +25,7 @@ static struct dentry *hfs_lookup(struct inode *dir, struct dentry *dentry,
 	struct inode *inode = NULL;
 	int res;
 
-	dentry->d_op = &hfs_dentry_operations;
+	d_set_d_op(dentry, &hfs_dentry_operations);
 
 	hfs_find_init(HFS_SB(dir->i_sb)->cat_tree, &fd);
 	hfs_cat_build_key(dir->i_sb, fd.search_key, dir->i_ino, &dentry->d_name);
diff --git a/fs/hfs/super.c b/fs/hfs/super.c
index ef4ee57..0bef62a 100644
--- a/fs/hfs/super.c
+++ b/fs/hfs/super.c
@@ -434,7 +434,7 @@ static int hfs_fill_super(struct super_block *sb, void *data, int silent)
 	if (!sb->s_root)
 		goto bail_iput;
 
-	sb->s_root->d_op = &hfs_dentry_operations;
+	d_set_d_op(sb->s_root, &hfs_dentry_operations);
 
 	/* everything's okay */
 	return 0;
diff --git a/fs/hfsplus/dir.c b/fs/hfsplus/dir.c
index 9d59c05..ccab871 100644
--- a/fs/hfsplus/dir.c
+++ b/fs/hfsplus/dir.c
@@ -37,7 +37,7 @@ static struct dentry *hfsplus_lookup(struct inode *dir, struct dentry *dentry,
 
 	sb = dir->i_sb;
 
-	dentry->d_op = &hfsplus_dentry_operations;
+	d_set_d_op(dentry, &hfsplus_dentry_operations);
 	dentry->d_fsdata = NULL;
 	hfs_find_init(HFSPLUS_SB(sb)->cat_tree, &fd);
 	hfsplus_cat_build_key(sb, fd.search_key, dir->i_ino, &dentry->d_name);
diff --git a/fs/hfsplus/super.c b/fs/hfsplus/super.c
index 182e83a..ddf712e 100644
--- a/fs/hfsplus/super.c
+++ b/fs/hfsplus/super.c
@@ -419,7 +419,7 @@ static int hfsplus_fill_super(struct super_block *sb, void *data, int silent)
 		err = -ENOMEM;
 		goto cleanup;
 	}
-	sb->s_root->d_op = &hfsplus_dentry_operations;
+	d_set_d_op(sb->s_root, &hfsplus_dentry_operations);
 
 	str.len = sizeof(HFSP_HIDDENDIR_NAME) - 1;
 	str.name = HFSP_HIDDENDIR_NAME;
diff --git a/fs/hostfs/hostfs_kern.c b/fs/hostfs/hostfs_kern.c
index 861113f..0bc81cf 100644
--- a/fs/hostfs/hostfs_kern.c
+++ b/fs/hostfs/hostfs_kern.c
@@ -612,7 +612,7 @@ struct dentry *hostfs_lookup(struct inode *ino, struct dentry *dentry,
 		goto out_put;
 
 	d_add(dentry, inode);
-	dentry->d_op = &hostfs_dentry_ops;
+	d_set_d_op(dentry, &hostfs_dentry_ops);
 	return NULL;
 
  out_put:
diff --git a/fs/hpfs/dentry.c b/fs/hpfs/dentry.c
index d7f1cbb..86f573f 100644
--- a/fs/hpfs/dentry.c
+++ b/fs/hpfs/dentry.c
@@ -64,5 +64,5 @@ static const struct dentry_operations hpfs_dentry_operations = {
 
 void hpfs_set_dentry_operations(struct dentry *dentry)
 {
-	dentry->d_op = &hpfs_dentry_operations;
+	d_set_d_op(dentry, &hpfs_dentry_operations);
 }
diff --git a/fs/isofs/inode.c b/fs/isofs/inode.c
index 9813d54..dc9505e 100644
--- a/fs/isofs/inode.c
+++ b/fs/isofs/inode.c
@@ -945,7 +945,7 @@ root_found:
 		table += 2;
 	if (opt.check == 'r')
 		table++;
-	s->s_root->d_op = &isofs_dentry_ops[table];
+	d_set_d_op(s->s_root, &isofs_dentry_ops[table]);
 
 	kfree(opt.iocharset);
 
diff --git a/fs/isofs/namei.c b/fs/isofs/namei.c
index e7768ac..2736046 100644
--- a/fs/isofs/namei.c
+++ b/fs/isofs/namei.c
@@ -172,7 +172,7 @@ struct dentry *isofs_lookup(struct inode *dir, struct dentry *dentry, struct nam
 	struct inode *inode;
 	struct page *page;
 
-	dentry->d_op = dir->i_sb->s_root->d_op;
+	d_set_d_op(dentry, dir->i_sb->s_root->d_op);
 
 	page = alloc_page(GFP_USER);
 	if (!page)
diff --git a/fs/jfs/namei.c b/fs/jfs/namei.c
index 7166a1b..50d6b8d 100644
--- a/fs/jfs/namei.c
+++ b/fs/jfs/namei.c
@@ -1466,7 +1466,7 @@ static struct dentry *jfs_lookup(struct inode *dip, struct dentry *dentry, struc
 	jfs_info("jfs_lookup: name = %s", name);
 
 	if (JFS_SBI(dip->i_sb)->mntflag & JFS_OS2)
-		dentry->d_op = &jfs_ci_dentry_operations;
+		d_set_d_op(dentry, &jfs_ci_dentry_operations);
 
 	if ((name[0] == '.') && (len == 1))
 		inum = dip->i_ino;
@@ -1495,7 +1495,7 @@ static struct dentry *jfs_lookup(struct inode *dip, struct dentry *dentry, struc
 	dentry = d_splice_alias(ip, dentry);
 
 	if (dentry && (JFS_SBI(dip->i_sb)->mntflag & JFS_OS2))
-		dentry->d_op = &jfs_ci_dentry_operations;
+		d_set_d_op(dentry, &jfs_ci_dentry_operations);
 
 	return dentry;
 }
diff --git a/fs/jfs/super.c b/fs/jfs/super.c
index b715b0f..3150d76 100644
--- a/fs/jfs/super.c
+++ b/fs/jfs/super.c
@@ -525,7 +525,7 @@ static int jfs_fill_super(struct super_block *sb, void *data, int silent)
 		goto out_no_root;
 
 	if (sbi->mntflag & JFS_OS2)
-		sb->s_root->d_op = &jfs_ci_dentry_operations;
+		d_set_d_op(sb->s_root, &jfs_ci_dentry_operations);
 
 	/* logical blocks are represented by 40 bits in pxd_t, etc. */
 	sb->s_maxbytes = ((u64) sb->s_blocksize) << 40;
diff --git a/fs/libfs.c b/fs/libfs.c
index 28b3666..889311e 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -59,7 +59,7 @@ struct dentry *simple_lookup(struct inode *dir, struct dentry *dentry, struct na
 
 	if (dentry->d_name.len > NAME_MAX)
 		return ERR_PTR(-ENAMETOOLONG);
-	dentry->d_op = &simple_dentry_operations;
+	d_set_d_op(dentry, &simple_dentry_operations);
 	d_add(dentry, NULL);
 	return NULL;
 }
diff --git a/fs/minix/namei.c b/fs/minix/namei.c
index c0d35a3..1b9e077 100644
--- a/fs/minix/namei.c
+++ b/fs/minix/namei.c
@@ -23,7 +23,7 @@ static struct dentry *minix_lookup(struct inode * dir, struct dentry *dentry, st
 	struct inode * inode = NULL;
 	ino_t ino;
 
-	dentry->d_op = dir->i_sb->s_root->d_op;
+	d_set_d_op(dentry, dir->i_sb->s_root->d_op);
 
 	if (dentry->d_name.len > minix_sb(dir->i_sb)->s_namelen)
 		return ERR_PTR(-ENAMETOOLONG);
diff --git a/fs/namei.c b/fs/namei.c
index c48d208..717ab13 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -543,6 +543,17 @@ do_revalidate(struct dentry *dentry, struct nameidata *nd)
 	return dentry;
 }
 
+static inline int need_reval_dot(struct dentry *dentry)
+{
+	if (likely(!(dentry->d_flags & DCACHE_OP_REVALIDATE)))
+		return 0;
+
+	if (likely(!(dentry->d_sb->s_type->fs_flags & FS_REVAL_DOT)))
+		return 0;
+
+	return 1;
+}
+
 /*
  * force_reval_path - force revalidation of a dentry
  *
@@ -566,10 +577,9 @@ force_reval_path(struct path *path, struct nameidata *nd)
 
 	/*
 	 * only check on filesystems where it's possible for the dentry to
-	 * become stale. It's assumed that if this flag is set then the
-	 * d_revalidate op will also be defined.
+	 * become stale.
 	 */
-	if (!(dentry->d_sb->s_type->fs_flags & FS_REVAL_DOT))
+	if (!need_reval_dot(dentry))
 		return 0;
 
 	status = dentry->d_op->d_revalidate(dentry, nd);
@@ -959,7 +969,7 @@ static int do_lookup(struct nameidata *nd, struct qstr *name,
 	 * See if the low-level filesystem might want
 	 * to use its own hash..
 	 */
-	if (parent->d_op && parent->d_op->d_hash) {
+	if (unlikely(parent->d_flags & DCACHE_OP_HASH)) {
 		int err = parent->d_op->d_hash(parent, nd->inode, name);
 		if (err < 0)
 			return err;
@@ -984,7 +994,7 @@ static int do_lookup(struct nameidata *nd, struct qstr *name,
 			return -ECHILD;
 
 		nd->seq = seq;
-		if (dentry->d_op && dentry->d_op->d_revalidate) {
+		if (dentry->d_flags & DCACHE_OP_REVALIDATE) {
 			/* XXX: RCU chokes here */
 			if (nameidata_dentry_drop_rcu(nd, dentry))
 				return -ECHILD;
@@ -998,7 +1008,7 @@ static int do_lookup(struct nameidata *nd, struct qstr *name,
 		if (!dentry)
 			goto need_lookup;
 found:
-		if (dentry->d_op && dentry->d_op->d_revalidate)
+		if (dentry->d_flags & DCACHE_OP_REVALIDATE)
 			goto need_revalidate;
 done:
 		path->mnt = mnt;
@@ -1236,8 +1246,7 @@ return_reval:
 		 * We bypassed the ordinary revalidation routines.
 		 * We may need to check the cached dentry for staleness.
 		 */
-		if (nd->path.dentry && nd->path.dentry->d_sb &&
-		    (nd->path.dentry->d_sb->s_type->fs_flags & FS_REVAL_DOT)) {
+		if (need_reval_dot(nd->path.dentry)) {
 			if (try_nameidata_drop_rcu(nd))
 				return -ECHILD;
 			err = -ESTALE;
@@ -1543,7 +1552,7 @@ static struct dentry *__lookup_hash(struct qstr *name,
 	 * See if the low-level filesystem might want
 	 * to use its own hash..
 	 */
-	if (base->d_op && base->d_op->d_hash) {
+	if (base->d_flags & DCACHE_OP_HASH) {
 		err = base->d_op->d_hash(base, inode, name);
 		dentry = ERR_PTR(err);
 		if (err < 0)
@@ -1557,7 +1566,7 @@ static struct dentry *__lookup_hash(struct qstr *name,
 	 */
 	dentry = d_lookup(base, name);
 
-	if (dentry && dentry->d_op && dentry->d_op->d_revalidate)
+	if (dentry && (dentry->d_flags & DCACHE_OP_REVALIDATE))
 		dentry = do_revalidate(dentry, nd);
 
 	if (!dentry)
@@ -2011,7 +2020,7 @@ static struct file *do_last(struct nameidata *nd, struct path *path,
 		follow_dotdot(nd);
 		dir = nd->path.dentry;
 	case LAST_DOT:
-		if (nd->path.mnt->mnt_sb->s_type->fs_flags & FS_REVAL_DOT) {
+		if (need_reval_dot(dir)) {
 			if (!dir->d_op->d_revalidate(dir, nd)) {
 				error = -ESTALE;
 				goto exit;
diff --git a/fs/ncpfs/dir.c b/fs/ncpfs/dir.c
index 6ecc33a..0494dfb 100644
--- a/fs/ncpfs/dir.c
+++ b/fs/ncpfs/dir.c
@@ -655,7 +655,7 @@ ncp_fill_cache(struct file *filp, void *dirent, filldir_t filldir,
 		entry->ino = iunique(dir->i_sb, 2);
 		inode = ncp_iget(dir->i_sb, entry);
 		if (inode) {
-			newdent->d_op = &ncp_dentry_operations;
+			d_set_d_op(newdent, &ncp_dentry_operations);
 			d_instantiate(newdent, inode);
 			if (!hashed)
 				d_rehash(newdent);
@@ -911,7 +911,7 @@ static struct dentry *ncp_lookup(struct inode *dir, struct dentry *dentry, struc
 	if (inode) {
 		ncp_new_dentry(dentry);
 add_entry:
-		dentry->d_op = &ncp_dentry_operations;
+		d_set_d_op(dentry, &ncp_dentry_operations);
 		d_add(dentry, inode);
 		error = 0;
 	}
diff --git a/fs/ncpfs/inode.c b/fs/ncpfs/inode.c
index 60047db..0c75a5f 100644
--- a/fs/ncpfs/inode.c
+++ b/fs/ncpfs/inode.c
@@ -717,7 +717,7 @@ static int ncp_fill_super(struct super_block *sb, void *raw_data, int silent)
 	sb->s_root = d_alloc_root(root_inode);
         if (!sb->s_root)
 		goto out_no_root;
-	sb->s_root->d_op = &ncp_root_dentry_operations;
+	d_set_d_op(sb->s_root, &ncp_root_dentry_operations);
 	return 0;
 
 out_no_root:
diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index c03f2d1..2388032 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -443,7 +443,7 @@ void nfs_prime_dcache(struct dentry *parent, struct nfs_entry *entry)
 	if (dentry == NULL)
 		return;
 
-	dentry->d_op = NFS_PROTO(dir)->dentry_ops;
+	d_set_d_op(dentry, NFS_PROTO(dir)->dentry_ops);
 	inode = nfs_fhget(dentry->d_sb, entry->fh, entry->fattr);
 	if (IS_ERR(inode))
 		goto out;
@@ -1198,7 +1198,7 @@ static struct dentry *nfs_lookup(struct inode *dir, struct dentry * dentry, stru
 	if (dentry->d_name.len > NFS_SERVER(dir)->namelen)
 		goto out;
 
-	dentry->d_op = NFS_PROTO(dir)->dentry_ops;
+	d_set_d_op(dentry, NFS_PROTO(dir)->dentry_ops);
 
 	/*
 	 * If we're doing an exclusive create, optimize away the lookup
@@ -1343,7 +1343,7 @@ static struct dentry *nfs_atomic_lookup(struct inode *dir, struct dentry *dentry
 		res = ERR_PTR(-ENAMETOOLONG);
 		goto out;
 	}
-	dentry->d_op = NFS_PROTO(dir)->dentry_ops;
+	d_set_d_op(dentry, NFS_PROTO(dir)->dentry_ops);
 
 	/* Let vfs_create() deal with O_EXCL. Instantiate, but don't hash
 	 * the dentry. */
diff --git a/fs/nfs/getroot.c b/fs/nfs/getroot.c
index b3e36c3..c3a5a11 100644
--- a/fs/nfs/getroot.c
+++ b/fs/nfs/getroot.c
@@ -121,7 +121,7 @@ struct dentry *nfs_get_root(struct super_block *sb, struct nfs_fh *mntfh)
 	security_d_instantiate(ret, inode);
 
 	if (ret->d_op == NULL)
-		ret->d_op = server->nfs_client->rpc_ops->dentry_ops;
+		d_set_d_op(ret, server->nfs_client->rpc_ops->dentry_ops);
 out:
 	nfs_free_fattr(fsinfo.fattr);
 	return ret;
@@ -228,7 +228,7 @@ struct dentry *nfs4_get_root(struct super_block *sb, struct nfs_fh *mntfh)
 	security_d_instantiate(ret, inode);
 
 	if (ret->d_op == NULL)
-		ret->d_op = server->nfs_client->rpc_ops->dentry_ops;
+		d_set_d_op(ret, server->nfs_client->rpc_ops->dentry_ops);
 
 out:
 	nfs_free_fattr(fattr);
diff --git a/fs/ocfs2/export.c b/fs/ocfs2/export.c
index 19ad145..6adafa5 100644
--- a/fs/ocfs2/export.c
+++ b/fs/ocfs2/export.c
@@ -138,7 +138,7 @@ check_gen:
 
 	result = d_obtain_alias(inode);
 	if (!IS_ERR(result))
-		result->d_op = &ocfs2_dentry_ops;
+		d_set_d_op(result, &ocfs2_dentry_ops);
 	else
 		mlog_errno(PTR_ERR(result));
 
@@ -176,7 +176,7 @@ static struct dentry *ocfs2_get_parent(struct dentry *child)
 
 	parent = d_obtain_alias(ocfs2_iget(OCFS2_SB(dir->i_sb), blkno, 0, 0));
 	if (!IS_ERR(parent))
-		parent->d_op = &ocfs2_dentry_ops;
+		d_set_d_op(parent, &ocfs2_dentry_ops);
 
 bail_unlock:
 	ocfs2_inode_unlock(dir, 0);
diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index ff5744e..d14cad6 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -147,7 +147,7 @@ static struct dentry *ocfs2_lookup(struct inode *dir, struct dentry *dentry,
 	spin_unlock(&oi->ip_lock);
 
 bail_add:
-	dentry->d_op = &ocfs2_dentry_ops;
+	d_set_d_op(dentry, &ocfs2_dentry_ops);
 	ret = d_splice_alias(inode, dentry);
 
 	if (inode) {
@@ -415,7 +415,7 @@ static int ocfs2_mknod(struct inode *dir,
 		mlog_errno(status);
 		goto leave;
 	}
-	dentry->d_op = &ocfs2_dentry_ops;
+	d_set_d_op(dentry, &ocfs2_dentry_ops);
 
 	status = ocfs2_add_entry(handle, dentry, inode,
 				 OCFS2_I(inode)->ip_blkno, parent_fe_bh,
@@ -743,7 +743,7 @@ static int ocfs2_link(struct dentry *old_dentry,
 	}
 
 	ihold(inode);
-	dentry->d_op = &ocfs2_dentry_ops;
+	d_set_d_op(dentry, &ocfs2_dentry_ops);
 	d_instantiate(dentry, inode);
 
 out_commit:
@@ -1794,7 +1794,7 @@ static int ocfs2_symlink(struct inode *dir,
 		mlog_errno(status);
 		goto bail;
 	}
-	dentry->d_op = &ocfs2_dentry_ops;
+	d_set_d_op(dentry, &ocfs2_dentry_ops);
 
 	status = ocfs2_add_entry(handle, dentry, inode,
 				 le64_to_cpu(fe->i_blkno), parent_fe_bh,
@@ -2459,7 +2459,7 @@ int ocfs2_mv_orphaned_inode_to_new(struct inode *dir,
 		goto out_commit;
 	}
 
-	dentry->d_op = &ocfs2_dentry_ops;
+	d_set_d_op(dentry, &ocfs2_dentry_ops);
 	d_instantiate(dentry, inode);
 	status = 0;
 out_commit:
diff --git a/fs/pipe.c b/fs/pipe.c
index 4ae1d76..e964d09 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -1004,7 +1004,7 @@ struct file *create_write_pipe(int flags)
 		goto err_inode;
 	path.mnt = mntget(pipe_mnt);
 
-	path.dentry->d_op = &pipefs_dentry_operations;
+	d_set_d_op(path.dentry, &pipefs_dentry_operations);
 	d_instantiate(path.dentry, inode);
 
 	err = -ENFILE;
diff --git a/fs/proc/base.c b/fs/proc/base.c
index 866a41a..116d4e9 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -1969,7 +1969,7 @@ static struct dentry *proc_fd_instantiate(struct inode *dir,
 	inode->i_op = &proc_pid_link_inode_operations;
 	inode->i_size = 64;
 	ei->op.proc_get_link = proc_fd_link;
-	dentry->d_op = &tid_fd_dentry_operations;
+	d_set_d_op(dentry, &tid_fd_dentry_operations);
 	d_add(dentry, inode);
 	/* Close the race of the process dying before we return the dentry */
 	if (tid_fd_revalidate(dentry, NULL))
@@ -2137,7 +2137,7 @@ static struct dentry *proc_fdinfo_instantiate(struct inode *dir,
 	ei->fd = fd;
 	inode->i_mode = S_IFREG | S_IRUSR;
 	inode->i_fop = &proc_fdinfo_file_operations;
-	dentry->d_op = &tid_fd_dentry_operations;
+	d_set_d_op(dentry, &tid_fd_dentry_operations);
 	d_add(dentry, inode);
 	/* Close the race of the process dying before we return the dentry */
 	if (tid_fd_revalidate(dentry, NULL))
@@ -2196,7 +2196,7 @@ static struct dentry *proc_pident_instantiate(struct inode *dir,
 	if (p->fop)
 		inode->i_fop = p->fop;
 	ei->op = p->op;
-	dentry->d_op = &pid_dentry_operations;
+	d_set_d_op(dentry, &pid_dentry_operations);
 	d_add(dentry, inode);
 	/* Close the race of the process dying before we return the dentry */
 	if (pid_revalidate(dentry, NULL))
@@ -2615,7 +2615,7 @@ static struct dentry *proc_base_instantiate(struct inode *dir,
 	if (p->fop)
 		inode->i_fop = p->fop;
 	ei->op = p->op;
-	dentry->d_op = &proc_base_dentry_operations;
+	d_set_d_op(dentry, &proc_base_dentry_operations);
 	d_add(dentry, inode);
 	error = NULL;
 out:
@@ -2926,7 +2926,7 @@ static struct dentry *proc_pid_instantiate(struct inode *dir,
 	inode->i_nlink = 2 + pid_entry_count_dirs(tgid_base_stuff,
 		ARRAY_SIZE(tgid_base_stuff));
 
-	dentry->d_op = &pid_dentry_operations;
+	d_set_d_op(dentry, &pid_dentry_operations);
 
 	d_add(dentry, inode);
 	/* Close the race of the process dying before we return the dentry */
@@ -3169,7 +3169,7 @@ static struct dentry *proc_task_instantiate(struct inode *dir,
 	inode->i_nlink = 2 + pid_entry_count_dirs(tid_base_stuff,
 		ARRAY_SIZE(tid_base_stuff));
 
-	dentry->d_op = &pid_dentry_operations;
+	d_set_d_op(dentry, &pid_dentry_operations);
 
 	d_add(dentry, inode);
 	/* Close the race of the process dying before we return the dentry */
diff --git a/fs/proc/generic.c b/fs/proc/generic.c
index 1d607be..f766be2 100644
--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -439,7 +439,7 @@ struct dentry *proc_lookup_de(struct proc_dir_entry *de, struct inode *dir,
 out_unlock:
 
 	if (inode) {
-		dentry->d_op = &proc_dentry_operations;
+		d_set_d_op(dentry, &proc_dentry_operations);
 		d_add(dentry, inode);
 		return NULL;
 	}
diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
index 34f1fc5..a07d7f1 100644
--- a/fs/proc/proc_sysctl.c
+++ b/fs/proc/proc_sysctl.c
@@ -120,7 +120,7 @@ static struct dentry *proc_sys_lookup(struct inode *dir, struct dentry *dentry,
 		goto out;
 
 	err = NULL;
-	dentry->d_op = &proc_sys_dentry_operations;
+	d_set_d_op(dentry, &proc_sys_dentry_operations);
 	d_add(dentry, inode);
 
 out:
@@ -201,7 +201,7 @@ static int proc_sys_fill_cache(struct file *filp, void *dirent,
 				dput(child);
 				return -ENOMEM;
 			} else {
-				child->d_op = &proc_sys_dentry_operations;
+				d_set_d_op(child, &proc_sys_dentry_operations);
 				d_add(child, inode);
 			}
 		} else {
diff --git a/fs/reiserfs/xattr.c b/fs/reiserfs/xattr.c
index 5d04a78..e0f0d7e 100644
--- a/fs/reiserfs/xattr.c
+++ b/fs/reiserfs/xattr.c
@@ -990,7 +990,7 @@ int reiserfs_lookup_privroot(struct super_block *s)
 				strlen(PRIVROOT_NAME));
 	if (!IS_ERR(dentry)) {
 		REISERFS_SB(s)->priv_root = dentry;
-		dentry->d_op = &xattr_lookup_poison_ops;
+		d_set_d_op(dentry, &xattr_lookup_poison_ops);
 		if (dentry->d_inode)
 			dentry->d_inode->i_flags |= S_PRIVATE;
 	} else
diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 27e1102..3e076ca 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -701,7 +701,7 @@ static struct dentry * sysfs_lookup(struct inode *dir, struct dentry *dentry,
 	/* instantiate and hash dentry */
 	ret = d_find_alias(inode);
 	if (!ret) {
-		dentry->d_op = &sysfs_dentry_ops;
+		d_set_d_op(dentry, &sysfs_dentry_ops);
 		dentry->d_fsdata = sysfs_get(sd);
 		d_add(dentry, inode);
 	} else {
diff --git a/fs/sysv/namei.c b/fs/sysv/namei.c
index 7507aeb..b5e68da 100644
--- a/fs/sysv/namei.c
+++ b/fs/sysv/namei.c
@@ -48,7 +48,7 @@ static struct dentry *sysv_lookup(struct inode * dir, struct dentry * dentry, st
 	struct inode * inode = NULL;
 	ino_t ino;
 
-	dentry->d_op = dir->i_sb->s_root->d_op;
+	d_set_d_op(dentry, dir->i_sb->s_root->d_op);
 	if (dentry->d_name.len > SYSV_NAMELEN)
 		return ERR_PTR(-ENAMETOOLONG);
 	ino = sysv_inode_by_name(dentry);
diff --git a/fs/sysv/super.c b/fs/sysv/super.c
index 3d9c62b..76712ae 100644
--- a/fs/sysv/super.c
+++ b/fs/sysv/super.c
@@ -346,7 +346,7 @@ static int complete_read_super(struct super_block *sb, int silent, int size)
 	if (sbi->s_forced_ro)
 		sb->s_flags |= MS_RDONLY;
 	if (sbi->s_truncate)
-		sb->s_root->d_op = &sysv_dentry_operations;
+		d_set_d_op(sb->s_root, &sysv_dentry_operations);
 	return 1;
 }
 
diff --git a/include/linux/dcache.h b/include/linux/dcache.h
index 2fd0b45..79a89af 100644
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -183,6 +183,11 @@ struct dentry_operations {
 #define DCACHE_GENOCIDE		0x0200
 #define DCACHE_MOUNTED		0x0400	/* is a mountpoint */
 
+#define DCACHE_OP_HASH		0x1000
+#define DCACHE_OP_COMPARE	0x2000
+#define DCACHE_OP_REVALIDATE	0x4000
+#define DCACHE_OP_DELETE	0x8000
+
 
 extern spinlock_t dcache_inode_lock;
 extern spinlock_t dcache_hash_lock;
@@ -233,6 +238,7 @@ extern void d_instantiate(struct dentry *, struct inode *);
 extern struct dentry * d_instantiate_unique(struct dentry *, struct inode *);
 extern struct dentry * d_materialise_unique(struct dentry *, struct inode *);
 extern void d_delete(struct dentry *);
+extern void d_set_d_op(struct dentry *dentry, const struct dentry_operations *op);
 
 /* allocate/de-allocate */
 extern struct dentry * d_alloc(struct dentry *, const struct qstr *);
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 6e34f75..afab372 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2237,7 +2237,7 @@ static int cgroup_create_file(struct dentry *dentry, mode_t mode,
 		inode->i_size = 0;
 		inode->i_fop = &cgroup_file_operations;
 	}
-	dentry->d_op = &cgroup_dops;
+	d_set_d_op(dentry, &cgroup_dops);
 	d_instantiate(dentry, inode);
 	dget(dentry);	/* Extra count - pin the dentry in core */
 	return 0;
diff --git a/net/socket.c b/net/socket.c
index 425da53..2d8b4c8 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -368,7 +368,7 @@ static int sock_alloc_file(struct socket *sock, struct file **f, int flags)
 	}
 	path.mnt = mntget(sock_mnt);
 
-	path.dentry->d_op = &sockfs_dentry_operations;
+	d_set_d_op(path.dentry, &sockfs_dentry_operations);
 	d_instantiate(path.dentry, SOCK_INODE(sock));
 	SOCK_INODE(sock)->i_fop = &socket_file_ops;
 
diff --git a/net/sunrpc/rpc_pipe.c b/net/sunrpc/rpc_pipe.c
index 2899fe2..09f01f4 100644
--- a/net/sunrpc/rpc_pipe.c
+++ b/net/sunrpc/rpc_pipe.c
@@ -591,7 +591,7 @@ static struct dentry *__rpc_lookup_create(struct dentry *parent,
 		}
 	}
 	if (!dentry->d_inode)
-		dentry->d_op = &rpc_dentry_operations;
+		d_set_d_op(dentry, &rpc_dentry_operations);
 out_err:
 	return dentry;
 }
-- 
1.7.1

