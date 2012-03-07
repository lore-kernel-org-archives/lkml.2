Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758072Ab2CGVYd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 16:24:33 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:37696 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030233Ab2CGVXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 16:23:36 -0500
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, Trond.Myklebust@netapp.com, sfrench@samba.org,
        sage@newdream.net, ericvh@gmail.com, mszeredi@suse.cz
Subject: [PATCH 23/25] vfs: remove nameidata argument from i_op->create()
Date: Wed,  7 Mar 2012 22:22:40 +0100
Message-Id: <1331155362-11132-24-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1331155362-11132-1-git-send-email-miklos@szeredi.hu>
References: <1331155362-11132-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

The nameidata argument is no longer used by any filesystem.  Any information
that might be necessary is available in i_op->atomic_create().

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/affs/affs.h          |    3 ++-
 fs/affs/namei.c         |    2 +-
 fs/afs/dir.c            |    6 ++----
 fs/bad_inode.c          |    4 ++--
 fs/bfs/dir.c            |    3 +--
 fs/btrfs/inode.c        |    3 +--
 fs/coda/dir.c           |    4 ++--
 fs/ecryptfs/inode.c     |    3 +--
 fs/exofs/namei.c        |    3 +--
 fs/ext2/namei.c         |    2 +-
 fs/ext3/namei.c         |    3 +--
 fs/ext4/namei.c         |    3 +--
 fs/fat/namei_msdos.c    |    3 +--
 fs/fat/namei_vfat.c     |    3 +--
 fs/hfs/dir.c            |    3 +--
 fs/hfsplus/dir.c        |    4 ++--
 fs/hostfs/hostfs_kern.c |    3 +--
 fs/hpfs/namei.c         |    2 +-
 fs/hugetlbfs/inode.c    |    3 ++-
 fs/jffs2/dir.c          |    5 ++---
 fs/jfs/namei.c          |    4 +---
 fs/logfs/dir.c          |    3 +--
 fs/minix/namei.c        |    3 +--
 fs/namei.c              |    9 ++++-----
 fs/ncpfs/dir.c          |    5 ++---
 fs/nilfs2/namei.c       |    3 +--
 fs/ocfs2/dlmfs/dlmfs.c  |    3 +--
 fs/ocfs2/namei.c        |    3 +--
 fs/omfs/dir.c           |    3 +--
 fs/ramfs/inode.c        |    2 +-
 fs/reiserfs/namei.c     |    4 ++--
 fs/sysv/namei.c         |    2 +-
 fs/ubifs/dir.c          |    3 +--
 fs/udf/namei.c          |    3 +--
 fs/ufs/namei.c          |    3 +--
 fs/xfs/xfs_iops.c       |    3 +--
 include/linux/fs.h      |    2 +-
 ipc/mqueue.c            |    3 +--
 mm/shmem.c              |    3 +--
 39 files changed, 51 insertions(+), 78 deletions(-)

diff --git a/fs/affs/affs.h b/fs/affs/affs.h
index 45a0ce4..e0fca52 100644
--- a/fs/affs/affs.h
+++ b/fs/affs/affs.h
@@ -156,7 +156,8 @@ extern void	affs_free_bitmap(struct super_block *sb);
 extern int	affs_hash_name(struct super_block *sb, const u8 *name, unsigned int len);
 extern struct dentry *affs_lookup(struct inode *dir, struct dentry *dentry, struct nameidata *);
 extern int	affs_unlink(struct inode *dir, struct dentry *dentry);
-extern int	affs_create(struct inode *dir, struct dentry *dentry, umode_t mode, struct nameidata *);
+extern int	affs_create(struct inode *dir, struct dentry *dentry,
+			    umode_t mode);
 extern int	affs_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode);
 extern int	affs_rmdir(struct inode *dir, struct dentry *dentry);
 extern int	affs_link(struct dentry *olddentry, struct inode *dir,
diff --git a/fs/affs/namei.c b/fs/affs/namei.c
index 4780694..3ad7695 100644
--- a/fs/affs/namei.c
+++ b/fs/affs/namei.c
@@ -255,7 +255,7 @@ affs_unlink(struct inode *dir, struct dentry *dentry)
 }
 
 int
-affs_create(struct inode *dir, struct dentry *dentry, umode_t mode, struct nameidata *nd)
+affs_create(struct inode *dir, struct dentry *dentry, umode_t mode)
 {
 	struct super_block *sb = dir->i_sb;
 	struct inode	*inode;
diff --git a/fs/afs/dir.c b/fs/afs/dir.c
index e22dc4b..ea254ab 100644
--- a/fs/afs/dir.c
+++ b/fs/afs/dir.c
@@ -28,8 +28,7 @@ static int afs_d_delete(const struct dentry *dentry);
 static void afs_d_release(struct dentry *dentry);
 static int afs_lookup_filldir(void *_cookie, const char *name, int nlen,
 				  loff_t fpos, u64 ino, unsigned dtype);
-static int afs_create(struct inode *dir, struct dentry *dentry, umode_t mode,
-		      struct nameidata *nd);
+static int afs_create(struct inode *dir, struct dentry *dentry, umode_t mode);
 static int afs_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode);
 static int afs_rmdir(struct inode *dir, struct dentry *dentry);
 static int afs_unlink(struct inode *dir, struct dentry *dentry);
@@ -948,8 +947,7 @@ error:
 /*
  * create a regular file on an AFS filesystem
  */
-static int afs_create(struct inode *dir, struct dentry *dentry, umode_t mode,
-		      struct nameidata *nd)
+static int afs_create(struct inode *dir, struct dentry *dentry, umode_t mode)
 {
 	struct afs_file_status status;
 	struct afs_callback cb;
diff --git a/fs/bad_inode.c b/fs/bad_inode.c
index 22e9a78..9fc0eab 100644
--- a/fs/bad_inode.c
+++ b/fs/bad_inode.c
@@ -172,8 +172,8 @@ static const struct file_operations bad_file_ops =
 	.splice_read	= bad_file_splice_read,
 };
 
-static int bad_inode_create (struct inode *dir, struct dentry *dentry,
-		umode_t mode, struct nameidata *nd)
+static int bad_inode_create(struct inode *dir, struct dentry *dentry,
+			    umode_t mode)
 {
 	return -EIO;
 }
diff --git a/fs/bfs/dir.c b/fs/bfs/dir.c
index d12c796..e9a3937 100644
--- a/fs/bfs/dir.c
+++ b/fs/bfs/dir.c
@@ -84,8 +84,7 @@ const struct file_operations bfs_dir_operations = {
 
 extern void dump_imap(const char *, struct super_block *);
 
-static int bfs_create(struct inode *dir, struct dentry *dentry, umode_t mode,
-						struct nameidata *nd)
+static int bfs_create(struct inode *dir, struct dentry *dentry, umode_t mode)
 {
 	int err;
 	struct inode *inode;
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 892b347..a5b0fb5 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4694,8 +4694,7 @@ out_unlock:
 	return err;
 }
 
-static int btrfs_create(struct inode *dir, struct dentry *dentry,
-			umode_t mode, struct nameidata *nd)
+static int btrfs_create(struct inode *dir, struct dentry *dentry, umode_t mode)
 {
 	struct btrfs_trans_handle *trans;
 	struct btrfs_root *root = BTRFS_I(dir)->root;
diff --git a/fs/coda/dir.c b/fs/coda/dir.c
index 1775158..e8d02b9 100644
--- a/fs/coda/dir.c
+++ b/fs/coda/dir.c
@@ -30,7 +30,7 @@
 #include "coda_int.h"
 
 /* dir inode-ops */
-static int coda_create(struct inode *dir, struct dentry *new, umode_t mode, struct nameidata *nd);
+static int coda_create(struct inode *dir, struct dentry *new, umode_t mode);
 static struct dentry *coda_lookup(struct inode *dir, struct dentry *target, struct nameidata *nd);
 static int coda_link(struct dentry *old_dentry, struct inode *dir_inode, 
 		     struct dentry *entry);
@@ -188,7 +188,7 @@ static inline void coda_dir_drop_nlink(struct inode *dir)
 }
 
 /* creation routines: create, mknod, mkdir, link, symlink */
-static int coda_create(struct inode *dir, struct dentry *de, umode_t mode, struct nameidata *nd)
+static int coda_create(struct inode *dir, struct dentry *de, umode_t mode)
 {
 	int error;
 	const char *name=de->d_name.name;
diff --git a/fs/ecryptfs/inode.c b/fs/ecryptfs/inode.c
index b6d0d69..8371f06 100644
--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -240,7 +240,6 @@ out:
  * @dir: The inode of the directory in which to create the file.
  * @dentry: The eCryptfs dentry
  * @mode: The mode of the new file.
- * @nd: nameidata
  *
  * Creates a new file.
  *
@@ -248,7 +247,7 @@ out:
  */
 static int
 ecryptfs_create(struct inode *directory_inode, struct dentry *ecryptfs_dentry,
-		umode_t mode, struct nameidata *nd)
+		umode_t mode)
 {
 	struct inode *ecryptfs_inode;
 	int rc;
diff --git a/fs/exofs/namei.c b/fs/exofs/namei.c
index 9dbf0c3..570845b 100644
--- a/fs/exofs/namei.c
+++ b/fs/exofs/namei.c
@@ -59,8 +59,7 @@ static struct dentry *exofs_lookup(struct inode *dir, struct dentry *dentry,
 	return d_splice_alias(inode, dentry);
 }
 
-static int exofs_create(struct inode *dir, struct dentry *dentry, umode_t mode,
-			 struct nameidata *nd)
+static int exofs_create(struct inode *dir, struct dentry *dentry, umode_t mode)
 {
 	struct inode *inode = exofs_new_inode(dir, mode);
 	int err = PTR_ERR(inode);
diff --git a/fs/ext2/namei.c b/fs/ext2/namei.c
index 0804198..a39f4c4 100644
--- a/fs/ext2/namei.c
+++ b/fs/ext2/namei.c
@@ -94,7 +94,7 @@ struct dentry *ext2_get_parent(struct dentry *child)
  * If the create succeeds, we fill in the inode information
  * with d_instantiate(). 
  */
-static int ext2_create (struct inode * dir, struct dentry * dentry, umode_t mode, struct nameidata *nd)
+static int ext2_create(struct inode *dir, struct dentry *dentry, umode_t mode)
 {
 	struct inode *inode;
 
diff --git a/fs/ext3/namei.c b/fs/ext3/namei.c
index e8e2117..af7adfc 100644
--- a/fs/ext3/namei.c
+++ b/fs/ext3/namei.c
@@ -1701,8 +1701,7 @@ static int ext3_add_nondir(handle_t *handle,
  * If the create succeeds, we fill in the inode information
  * with d_instantiate().
  */
-static int ext3_create (struct inode * dir, struct dentry * dentry, umode_t mode,
-		struct nameidata *nd)
+static int ext3_create(struct inode *dir, struct dentry *dentry, umode_t mode)
 {
 	handle_t *handle;
 	struct inode * inode;
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 2043f48..20f9a13 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1736,8 +1736,7 @@ static int ext4_add_nondir(handle_t *handle,
  * If the create succeeds, we fill in the inode information
  * with d_instantiate().
  */
-static int ext4_create(struct inode *dir, struct dentry *dentry, umode_t mode,
-		       struct nameidata *nd)
+static int ext4_create(struct inode *dir, struct dentry *dentry, umode_t mode)
 {
 	handle_t *handle;
 	struct inode *inode;
diff --git a/fs/fat/namei_msdos.c b/fs/fat/namei_msdos.c
index c5938c9..c854101 100644
--- a/fs/fat/namei_msdos.c
+++ b/fs/fat/namei_msdos.c
@@ -264,8 +264,7 @@ static int msdos_add_entry(struct inode *dir, const unsigned char *name,
 }
 
 /***** Create a file */
-static int msdos_create(struct inode *dir, struct dentry *dentry, umode_t mode,
-			struct nameidata *nd)
+static int msdos_create(struct inode *dir, struct dentry *dentry, umode_t mode)
 {
 	struct super_block *sb = dir->i_sb;
 	struct inode *inode = NULL;
diff --git a/fs/fat/namei_vfat.c b/fs/fat/namei_vfat.c
index a81eb23..39e810f 100644
--- a/fs/fat/namei_vfat.c
+++ b/fs/fat/namei_vfat.c
@@ -782,8 +782,7 @@ error:
 	return ERR_PTR(err);
 }
 
-static int vfat_create(struct inode *dir, struct dentry *dentry, umode_t mode,
-		       struct nameidata *nd)
+static int vfat_create(struct inode *dir, struct dentry *dentry, umode_t mode)
 {
 	struct super_block *sb = dir->i_sb;
 	struct inode *inode;
diff --git a/fs/hfs/dir.c b/fs/hfs/dir.c
index 62fc14e..ba125c1 100644
--- a/fs/hfs/dir.c
+++ b/fs/hfs/dir.c
@@ -186,8 +186,7 @@ static int hfs_dir_release(struct inode *inode, struct file *file)
  * a directory and return a corresponding inode, given the inode for
  * the directory and the name (and its length) of the new file.
  */
-static int hfs_create(struct inode *dir, struct dentry *dentry, umode_t mode,
-		      struct nameidata *nd)
+static int hfs_create(struct inode *dir, struct dentry *dentry, umode_t mode)
 {
 	struct inode *inode;
 	int res;
diff --git a/fs/hfsplus/dir.c b/fs/hfsplus/dir.c
index 88e155f..bfb2ad8 100644
--- a/fs/hfsplus/dir.c
+++ b/fs/hfsplus/dir.c
@@ -453,8 +453,8 @@ out:
 	return res;
 }
 
-static int hfsplus_create(struct inode *dir, struct dentry *dentry, umode_t mode,
-			  struct nameidata *nd)
+static int hfsplus_create(struct inode *dir, struct dentry *dentry,
+			  umode_t mode)
 {
 	return hfsplus_mknod(dir, dentry, mode, 0);
 }
diff --git a/fs/hostfs/hostfs_kern.c b/fs/hostfs/hostfs_kern.c
index e130bd4..a3d2242 100644
--- a/fs/hostfs/hostfs_kern.c
+++ b/fs/hostfs/hostfs_kern.c
@@ -551,8 +551,7 @@ static int read_name(struct inode *ino, char *name)
 	return 0;
 }
 
-int hostfs_create(struct inode *dir, struct dentry *dentry, umode_t mode,
-		  struct nameidata *nd)
+static int hostfs_create(struct inode *dir, struct dentry *dentry, umode_t mode)
 {
 	struct inode *inode;
 	char *name;
diff --git a/fs/hpfs/namei.c b/fs/hpfs/namei.c
index 30dd7b1..3129925 100644
--- a/fs/hpfs/namei.c
+++ b/fs/hpfs/namei.c
@@ -115,7 +115,7 @@ bail:
 	return err;
 }
 
-static int hpfs_create(struct inode *dir, struct dentry *dentry, umode_t mode, struct nameidata *nd)
+static int hpfs_create(struct inode *dir, struct dentry *dentry, umode_t mode)
 {
 	const unsigned char *name = dentry->d_name.name;
 	unsigned len = dentry->d_name.len;
diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 1e85a7a..00a60dc 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -545,7 +545,8 @@ static int hugetlbfs_mkdir(struct inode *dir, struct dentry *dentry, umode_t mod
 	return retval;
 }
 
-static int hugetlbfs_create(struct inode *dir, struct dentry *dentry, umode_t mode, struct nameidata *nd)
+static int hugetlbfs_create(struct inode *dir, struct dentry *dentry,
+			    umode_t mode)
 {
 	return hugetlbfs_mknod(dir, dentry, mode | S_IFREG, 0);
 }
diff --git a/fs/jffs2/dir.c b/fs/jffs2/dir.c
index 973ac58..099dd6a 100644
--- a/fs/jffs2/dir.c
+++ b/fs/jffs2/dir.c
@@ -22,8 +22,7 @@
 
 static int jffs2_readdir (struct file *, void *, filldir_t);
 
-static int jffs2_create (struct inode *,struct dentry *,umode_t,
-			 struct nameidata *);
+static int jffs2_create(struct inode *, struct dentry *, umode_t);
 static struct dentry *jffs2_lookup (struct inode *,struct dentry *,
 				    struct nameidata *);
 static int jffs2_link (struct dentry *,struct inode *,struct dentry *);
@@ -170,7 +169,7 @@ static int jffs2_readdir(struct file *filp, void *dirent, filldir_t filldir)
 
 
 static int jffs2_create(struct inode *dir_i, struct dentry *dentry,
-			umode_t mode, struct nameidata *nd)
+			umode_t mode)
 {
 	struct jffs2_raw_inode *ri;
 	struct jffs2_inode_info *f, *dir_f;
diff --git a/fs/jfs/namei.c b/fs/jfs/namei.c
index 5f7c160..423c520 100644
--- a/fs/jfs/namei.c
+++ b/fs/jfs/namei.c
@@ -67,13 +67,11 @@ static inline void free_ea_wmap(struct inode *inode)
  * PARAMETER:	dip	- parent directory vnode
  *		dentry	- dentry of new file
  *		mode	- create mode (rwxrwxrwx).
- *		nd- nd struct
  *
  * RETURN:	Errors from subroutines
  *
  */
-static int jfs_create(struct inode *dip, struct dentry *dentry, umode_t mode,
-		struct nameidata *nd)
+static int jfs_create(struct inode *dip, struct dentry *dentry, umode_t mode)
 {
 	int rc = 0;
 	tid_t tid;		/* transaction id */
diff --git a/fs/logfs/dir.c b/fs/logfs/dir.c
index 3de7a32..33556ae 100644
--- a/fs/logfs/dir.c
+++ b/fs/logfs/dir.c
@@ -501,8 +501,7 @@ static int logfs_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
 	return __logfs_create(dir, dentry, inode, NULL, 0);
 }
 
-static int logfs_create(struct inode *dir, struct dentry *dentry, umode_t mode,
-		struct nameidata *nd)
+static int logfs_create(struct inode *dir, struct dentry *dentry, umode_t mode)
 {
 	struct inode *inode;
 
diff --git a/fs/minix/namei.c b/fs/minix/namei.c
index 2f76e38..2ec09bb 100644
--- a/fs/minix/namei.c
+++ b/fs/minix/namei.c
@@ -54,8 +54,7 @@ static int minix_mknod(struct inode * dir, struct dentry *dentry, umode_t mode,
 	return error;
 }
 
-static int minix_create(struct inode *dir, struct dentry *dentry, umode_t mode,
-		struct nameidata *nd)
+static int minix_create(struct inode *dir, struct dentry *dentry, umode_t mode)
 {
 	return minix_mknod(dir, dentry, mode, 0);
 }
diff --git a/fs/namei.c b/fs/namei.c
index 4207e4f..5c95ce5 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2066,7 +2066,7 @@ out:
 
 static struct file *create_open(struct inode *dir, struct dentry *dentry,
 				struct opendata *od, unsigned open_flag,
-				umode_t mode, struct nameidata *nd)
+				umode_t mode)
 {
 	int error = may_create(dir, dentry);
 	if (error)
@@ -2081,7 +2081,7 @@ static struct file *create_open(struct inode *dir, struct dentry *dentry,
 	if (error)
 		goto out_err;
 	if (dir->i_op->create) {
-		error = dir->i_op->create(dir, dentry, mode, nd);
+		error = dir->i_op->create(dir, dentry, mode);
 		if (error)
 			goto out_err;
 
@@ -2100,7 +2100,7 @@ int vfs_create(struct inode *dir, struct dentry *dentry, umode_t mode)
 	struct file *res;
 	unsigned open_flag = O_RDONLY|O_CREAT|O_EXCL;
 
-	res = create_open(dir, dentry, NULL, open_flag, mode, NULL);
+	res = create_open(dir, dentry, NULL, open_flag, mode);
 	if (IS_ERR(res))
 		return PTR_ERR(res);
 
@@ -2467,8 +2467,7 @@ retry_lookup:
 		if (error)
 			goto exit_mutex_unlock;
 		od->mnt = nd->path.mnt;
-		filp = create_open(dir->d_inode, dentry, od, open_flag, mode,
-				   nd);
+		filp = create_open(dir->d_inode, dentry, od, open_flag, mode);
 		mutex_unlock(&dir->d_inode->i_mutex);
 		dput(nd->path.dentry);
 		nd->path.dentry = dentry;
diff --git a/fs/ncpfs/dir.c b/fs/ncpfs/dir.c
index aeed93a..34eeb46 100644
--- a/fs/ncpfs/dir.c
+++ b/fs/ncpfs/dir.c
@@ -30,7 +30,7 @@ static void ncp_do_readdir(struct file *, void *, filldir_t,
 
 static int ncp_readdir(struct file *, void *, filldir_t);
 
-static int ncp_create(struct inode *, struct dentry *, umode_t, struct nameidata *);
+static int ncp_create(struct inode *, struct dentry *, umode_t);
 static struct dentry *ncp_lookup(struct inode *, struct dentry *, struct nameidata *);
 static int ncp_unlink(struct inode *, struct dentry *);
 static int ncp_mkdir(struct inode *, struct dentry *, umode_t);
@@ -979,8 +979,7 @@ out:
 	return error;
 }
 
-static int ncp_create(struct inode *dir, struct dentry *dentry, umode_t mode,
-		struct nameidata *nd)
+static int ncp_create(struct inode *dir, struct dentry *dentry, umode_t mode)
 {
 	return ncp_create_new(dir, dentry, mode, 0, 0);
 }
diff --git a/fs/nilfs2/namei.c b/fs/nilfs2/namei.c
index 1cd3f62..ebde465 100644
--- a/fs/nilfs2/namei.c
+++ b/fs/nilfs2/namei.c
@@ -84,8 +84,7 @@ nilfs_lookup(struct inode *dir, struct dentry *dentry, struct nameidata *nd)
  * If the create succeeds, we fill in the inode information
  * with d_instantiate().
  */
-static int nilfs_create(struct inode *dir, struct dentry *dentry, umode_t mode,
-			struct nameidata *nd)
+static int nilfs_create(struct inode *dir, struct dentry *dentry, umode_t mode)
 {
 	struct inode *inode;
 	struct nilfs_transaction_info ti;
diff --git a/fs/ocfs2/dlmfs/dlmfs.c b/fs/ocfs2/dlmfs/dlmfs.c
index abfac0d..aafd800 100644
--- a/fs/ocfs2/dlmfs/dlmfs.c
+++ b/fs/ocfs2/dlmfs/dlmfs.c
@@ -525,8 +525,7 @@ bail:
 
 static int dlmfs_create(struct inode *dir,
 			struct dentry *dentry,
-			umode_t mode,
-			struct nameidata *nd)
+			umode_t mode)
 {
 	int status = 0;
 	struct inode *inode;
diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index a9856e3..0ef9de8 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -617,8 +617,7 @@ static int ocfs2_mkdir(struct inode *dir,
 
 static int ocfs2_create(struct inode *dir,
 			struct dentry *dentry,
-			umode_t mode,
-			struct nameidata *nd)
+			umode_t mode)
 {
 	int ret;
 
diff --git a/fs/omfs/dir.c b/fs/omfs/dir.c
index f00576e..d1aa51d 100644
--- a/fs/omfs/dir.c
+++ b/fs/omfs/dir.c
@@ -284,8 +284,7 @@ static int omfs_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
 	return omfs_add_node(dir, dentry, mode | S_IFDIR);
 }
 
-static int omfs_create(struct inode *dir, struct dentry *dentry, umode_t mode,
-		struct nameidata *nd)
+static int omfs_create(struct inode *dir, struct dentry *dentry, umode_t mode)
 {
 	return omfs_add_node(dir, dentry, mode | S_IFREG);
 }
diff --git a/fs/ramfs/inode.c b/fs/ramfs/inode.c
index aec766a..f08381d 100644
--- a/fs/ramfs/inode.c
+++ b/fs/ramfs/inode.c
@@ -114,7 +114,7 @@ static int ramfs_mkdir(struct inode * dir, struct dentry * dentry, umode_t mode)
 	return retval;
 }
 
-static int ramfs_create(struct inode *dir, struct dentry *dentry, umode_t mode, struct nameidata *nd)
+static int ramfs_create(struct inode *dir, struct dentry *dentry, umode_t mode)
 {
 	return ramfs_mknod(dir, dentry, mode | S_IFREG, 0);
 }
diff --git a/fs/reiserfs/namei.c b/fs/reiserfs/namei.c
index 1463788..044120c 100644
--- a/fs/reiserfs/namei.c
+++ b/fs/reiserfs/namei.c
@@ -572,8 +572,8 @@ static int new_inode_init(struct inode *inode, struct inode *dir, umode_t mode)
 	return 0;
 }
 
-static int reiserfs_create(struct inode *dir, struct dentry *dentry, umode_t mode,
-			   struct nameidata *nd)
+static int reiserfs_create(struct inode *dir, struct dentry *dentry,
+			   umode_t mode)
 {
 	int retval;
 	struct inode *inode;
diff --git a/fs/sysv/namei.c b/fs/sysv/namei.c
index b217797..9fd62a4 100644
--- a/fs/sysv/namei.c
+++ b/fs/sysv/namei.c
@@ -80,7 +80,7 @@ static int sysv_mknod(struct inode * dir, struct dentry * dentry, umode_t mode,
 	return err;
 }
 
-static int sysv_create(struct inode * dir, struct dentry * dentry, umode_t mode, struct nameidata *nd)
+static int sysv_create(struct inode *dir, struct dentry *dentry, umode_t mode)
 {
 	return sysv_mknod(dir, dentry, mode, 0);
 }
diff --git a/fs/ubifs/dir.c b/fs/ubifs/dir.c
index d6fe1c7..90adfaf 100644
--- a/fs/ubifs/dir.c
+++ b/fs/ubifs/dir.c
@@ -253,8 +253,7 @@ out:
 	return ERR_PTR(err);
 }
 
-static int ubifs_create(struct inode *dir, struct dentry *dentry, umode_t mode,
-			struct nameidata *nd)
+static int ubifs_create(struct inode *dir, struct dentry *dentry, umode_t mode)
 {
 	struct inode *inode;
 	struct ubifs_info *c = dir->i_sb->s_fs_info;
diff --git a/fs/udf/namei.c b/fs/udf/namei.c
index 08bf46e..c96f1a7 100644
--- a/fs/udf/namei.c
+++ b/fs/udf/namei.c
@@ -552,8 +552,7 @@ static int udf_delete_entry(struct inode *inode, struct fileIdentDesc *fi,
 	return udf_write_fi(inode, cfi, fi, fibh, NULL, NULL);
 }
 
-static int udf_create(struct inode *dir, struct dentry *dentry, umode_t mode,
-		      struct nameidata *nd)
+static int udf_create(struct inode *dir, struct dentry *dentry, umode_t mode)
 {
 	struct udf_fileident_bh fibh;
 	struct inode *inode;
diff --git a/fs/ufs/namei.c b/fs/ufs/namei.c
index 38cac19..ca6c710 100644
--- a/fs/ufs/namei.c
+++ b/fs/ufs/namei.c
@@ -70,8 +70,7 @@ static struct dentry *ufs_lookup(struct inode * dir, struct dentry *dentry, stru
  * If the create succeeds, we fill in the inode information
  * with d_instantiate(). 
  */
-static int ufs_create (struct inode * dir, struct dentry * dentry, umode_t mode,
-		struct nameidata *nd)
+static int ufs_create(struct inode *dir, struct dentry *dentry, umode_t mode)
 {
 	struct inode *inode;
 	int err;
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index ab30253..66810ac 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -231,8 +231,7 @@ STATIC int
 xfs_vn_create(
 	struct inode	*dir,
 	struct dentry	*dentry,
-	umode_t		mode,
-	struct nameidata *nd)
+	umode_t		mode)
 {
 	return xfs_vn_mknod(dir, dentry, mode, 0);
 }
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 23268f4..ea9282d 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1637,7 +1637,7 @@ struct inode_operations {
 	int (*readlink) (struct dentry *, char __user *,int);
 	void (*put_link) (struct dentry *, struct nameidata *, void *);
 
-	int (*create) (struct inode *,struct dentry *,umode_t,struct nameidata *);
+	int (*create) (struct inode *, struct dentry *, umode_t);
 	int (*link) (struct dentry *,struct inode *,struct dentry *);
 	int (*unlink) (struct inode *,struct dentry *);
 	int (*symlink) (struct inode *,struct dentry *,const char *);
diff --git a/ipc/mqueue.c b/ipc/mqueue.c
index b31b495..d757ebb 100644
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -294,8 +294,7 @@ static void mqueue_evict_inode(struct inode *inode)
 		put_ipc_ns(ipc_ns);
 }
 
-static int mqueue_create(struct inode *dir, struct dentry *dentry,
-				umode_t mode, struct nameidata *nd)
+static int mqueue_create(struct inode *dir, struct dentry *dentry, umode_t mode)
 {
 	struct inode *inode;
 	struct mq_attr *attr = dentry->d_fsdata;
diff --git a/mm/shmem.c b/mm/shmem.c
index 269d049..28d63b1 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1524,8 +1524,7 @@ static int shmem_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
 	return 0;
 }
 
-static int shmem_create(struct inode *dir, struct dentry *dentry, umode_t mode,
-		struct nameidata *nd)
+static int shmem_create(struct inode *dir, struct dentry *dentry, umode_t mode)
 {
 	return shmem_mknod(dir, dentry, mode | S_IFREG, 0);
 }
-- 
1.7.7

