Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965123Ab2CGVYG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 16:24:06 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:47153 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030242Ab2CGVXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 16:23:38 -0500
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, Trond.Myklebust@netapp.com, sfrench@samba.org,
        sage@newdream.net, ericvh@gmail.com, mszeredi@suse.cz
Subject: [PATCH 24/25] vfs: optionally skip lookup on exclusive create
Date: Wed,  7 Mar 2012 22:22:41 +0100
Message-Id: <1331155362-11132-25-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1331155362-11132-1-git-send-email-miklos@szeredi.hu>
References: <1331155362-11132-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

NFS optimizes away the last component lookup for exclusive creation (create,
mkdir, mknod, link, symlink).  It does this by checking for LOOKUP_EXCL in
nd->flags and skipping the actual lookup in that case, leaving a negative
unhashed dentry for the create function to fill.

Move this logic into the VFS which can be enabled by a filesystem flag.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/namei.c         |   12 +++++++++++-
 fs/nfs/dir.c       |   22 ++++++++++++----------
 fs/nfs/super.c     |    9 ++++++---
 include/linux/fs.h |    1 +
 4 files changed, 30 insertions(+), 14 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 5c95ce5..3e3652c 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2709,6 +2709,7 @@ struct file *do_file_open_root(struct dentry *dentry, struct vfsmount *mnt,
 
 struct dentry *kern_path_create(int dfd, const char *pathname, struct path *path, int is_dir)
 {
+	bool need_lookup;
 	struct dentry *dentry = ERR_PTR(-EEXIST);
 	struct nameidata nd;
 	int error = do_path_lookup(dfd, pathname, LOOKUP_PARENT, &nd);
@@ -2728,10 +2729,19 @@ struct dentry *kern_path_create(int dfd, const char *pathname, struct path *path
 	 * Do the final lookup.
 	 */
 	mutex_lock_nested(&nd.path.dentry->d_inode->i_mutex, I_MUTEX_PARENT);
-	dentry = lookup_hash(&nd);
+	dentry = lookup_dcache(&nd.last, nd.path.dentry, &nd, &need_lookup);
 	if (IS_ERR(dentry))
 		goto fail;
 
+	if (need_lookup) {
+		struct inode *dir = nd.path.dentry->d_inode;
+		if (!(dir->i_sb->s_type->fs_flags & FS_SKIP_LOOKUP_EXCL)) {
+			dentry = lookup_real(dir, dentry, &nd);
+			if (IS_ERR(dentry))
+				goto fail;
+		}
+	}
+
 	if (dentry->d_inode)
 		goto eexist;
 	/*
diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index 887226d..2b91cf3 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -1286,16 +1286,6 @@ static struct dentry *nfs_lookup(struct inode *dir, struct dentry * dentry, stru
 	if (dentry->d_name.len > NFS_SERVER(dir)->namelen)
 		goto out;
 
-	/*
-	 * If we're doing an exclusive create, optimize away the lookup
-	 * but don't hash the dentry.
-	 */
-	if (nfs_is_exclusive_create(dir, nd)) {
-		d_instantiate(dentry, NULL);
-		res = NULL;
-		goto out;
-	}
-
 	res = ERR_PTR(-ENOMEM);
 	fhandle = nfs_alloc_fhandle();
 	fattr = nfs_alloc_fattr();
@@ -1612,6 +1602,9 @@ nfs_mknod(struct inode *dir, struct dentry *dentry, umode_t mode, dev_t rdev)
 	dfprintk(VFS, "NFS: mknod(%s/%ld), %s\n",
 			dir->i_sb->s_id, dir->i_ino, dentry->d_name.name);
 
+	if (dentry->d_name.len > NFS_SERVER(dir)->namelen)
+		return -ENAMETOOLONG;
+
 	if (!new_valid_dev(rdev))
 		return -EINVAL;
 
@@ -1638,6 +1631,9 @@ static int nfs_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
 	dfprintk(VFS, "NFS: mkdir(%s/%ld), %s\n",
 			dir->i_sb->s_id, dir->i_ino, dentry->d_name.name);
 
+	if (dentry->d_name.len > NFS_SERVER(dir)->namelen)
+		return -ENAMETOOLONG;
+
 	attr.ia_valid = ATTR_MODE;
 	attr.ia_mode = mode | S_IFDIR;
 
@@ -1771,6 +1767,9 @@ static int nfs_symlink(struct inode *dir, struct dentry *dentry, const char *sym
 	dfprintk(VFS, "NFS: symlink(%s/%ld, %s, %s)\n", dir->i_sb->s_id,
 		dir->i_ino, dentry->d_name.name, symname);
 
+	if (dentry->d_name.len > NFS_SERVER(dir)->namelen)
+		return -ENAMETOOLONG;
+
 	if (pathlen > PAGE_SIZE)
 		return -ENAMETOOLONG;
 
@@ -1824,6 +1823,9 @@ nfs_link(struct dentry *old_dentry, struct inode *dir, struct dentry *dentry)
 		old_dentry->d_parent->d_name.name, old_dentry->d_name.name,
 		dentry->d_parent->d_name.name, dentry->d_name.name);
 
+	if (dentry->d_name.len > NFS_SERVER(dir)->namelen)
+		return -ENAMETOOLONG;
+
 	nfs_inode_return_delegation(inode);
 
 	d_drop(dentry);
diff --git a/fs/nfs/super.c b/fs/nfs/super.c
index 3dfa4f1..41ec94b 100644
--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -279,7 +279,8 @@ static struct file_system_type nfs_fs_type = {
 	.name		= "nfs",
 	.mount		= nfs_fs_mount,
 	.kill_sb	= nfs_kill_super,
-	.fs_flags	= FS_RENAME_DOES_D_MOVE|FS_REVAL_DOT|FS_BINARY_MOUNTDATA,
+	.fs_flags	= FS_RENAME_DOES_D_MOVE | FS_REVAL_DOT |
+			  FS_BINARY_MOUNTDATA | FS_SKIP_LOOKUP_EXCL,
 };
 
 struct file_system_type nfs_xdev_fs_type = {
@@ -287,7 +288,8 @@ struct file_system_type nfs_xdev_fs_type = {
 	.name		= "nfs",
 	.mount		= nfs_xdev_mount,
 	.kill_sb	= nfs_kill_super,
-	.fs_flags	= FS_RENAME_DOES_D_MOVE|FS_REVAL_DOT|FS_BINARY_MOUNTDATA,
+	.fs_flags	= FS_RENAME_DOES_D_MOVE | FS_REVAL_DOT |
+			  FS_BINARY_MOUNTDATA | FS_SKIP_LOOKUP_EXCL,
 };
 
 static const struct super_operations nfs_sops = {
@@ -327,7 +329,8 @@ static struct file_system_type nfs4_fs_type = {
 	.name		= "nfs4",
 	.mount		= nfs4_mount,
 	.kill_sb	= nfs4_kill_super,
-	.fs_flags	= FS_RENAME_DOES_D_MOVE|FS_REVAL_DOT|FS_BINARY_MOUNTDATA,
+	.fs_flags	= FS_RENAME_DOES_D_MOVE | FS_REVAL_DOT |
+			  FS_BINARY_MOUNTDATA | FS_SKIP_LOOKUP_EXCL,
 };
 
 static struct file_system_type nfs4_remote_fs_type = {
diff --git a/include/linux/fs.h b/include/linux/fs.h
index ea9282d..4a5e0d3 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -183,6 +183,7 @@ struct inodes_stat_t {
 					 */
 #define FS_NO_LOOKUP_OPEN	0x10000	/* fs can't do atomic lookup+open */
 #define FS_NO_LOOKUP_CREATE	0x20000 /* fs can't do lookup+create+open */
+#define FS_SKIP_LOOKUP_EXCL	0x40000 /* skip lookup for exclusive create */
 
 /*
  * These are the fs-independent mount-flags: up to 32 flags are supported
-- 
1.7.7

