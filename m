Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753554Ab0K0K1Q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Nov 2010 05:27:16 -0500
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:6979 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752345Ab0K0K1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Nov 2010 05:27:11 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAO1p8Ex5Lcx2/2dsb2JhbACjC3K9doVHBIUUhU2FFA
Message-Id: <6b7bb969c1c12e4462e7a9ebad98a205fa3496fd.1290852960.git.npiggin@kernel.dk>
In-Reply-To: <cover.1290852958.git.npiggin@kernel.dk>
References: <cover.1290852958.git.npiggin@kernel.dk>
From: Nick Piggin <npiggin@kernel.dk>
Date: Sat, 27 Nov 2010 20:45:09 +1100
Subject: [PATCH 39/46] fs: d_revalidate_rcu for rcu-walk
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This seems to be the best way to get filesystems aware of RCU walking
in their d_revalidate routines. Needs more documentation if it works
out OK.

Signed-off-by: Nick Piggin <npiggin@kernel.dk>
---
 fs/dcache.c            |    2 +
 fs/ecryptfs/dentry.c   |   15 ++++++++----
 fs/fat/namei_vfat.c    |   14 ++++++------
 fs/fuse/dir.c          |    7 ++++-
 fs/namei.c             |   56 ++++++++++++++++++++++++++++++++++-------------
 fs/sysfs/dir.c         |   18 ++++++++++++--
 include/linux/dcache.h |    7 +++++-
 7 files changed, 85 insertions(+), 34 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index fa6e7a5..67a08d4 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -1243,6 +1243,8 @@ void d_set_d_op(struct dentry *dentry, const struct dentry_operations *op)
 		dentry->d_flags |= DCACHE_OP_COMPARE;
 	if (op->d_revalidate)
 		dentry->d_flags |= DCACHE_OP_REVALIDATE;
+	if (op->d_revalidate_rcu)
+		dentry->d_flags |= DCACHE_OP_REVALIDATE_RCU;
 	if (op->d_delete)
 		dentry->d_flags |= DCACHE_OP_DELETE;
 
diff --git a/fs/ecryptfs/dentry.c b/fs/ecryptfs/dentry.c
index 906e803..f9a8be8 100644
--- a/fs/ecryptfs/dentry.c
+++ b/fs/ecryptfs/dentry.c
@@ -30,7 +30,7 @@
 #include "ecryptfs_kernel.h"
 
 /**
- * ecryptfs_d_revalidate - revalidate an ecryptfs dentry
+ * ecryptfs_d_revalidate_rcu - revalidate an ecryptfs dentry
  * @dentry: The ecryptfs dentry
  * @nd: The associated nameidata
  *
@@ -42,7 +42,7 @@
  * Returns 1 if valid, 0 otherwise.
  *
  */
-static int ecryptfs_d_revalidate(struct dentry *dentry, struct nameidata *nd)
+static int ecryptfs_d_revalidate_rcu(struct dentry *dentry, struct nameidata *nd)
 {
 	struct dentry *lower_dentry = ecryptfs_dentry_to_lower(dentry);
 	struct vfsmount *lower_mnt = ecryptfs_dentry_to_lower_mnt(dentry);
@@ -50,13 +50,18 @@ static int ecryptfs_d_revalidate(struct dentry *dentry, struct nameidata *nd)
 	struct vfsmount *vfsmount_save;
 	int rc = 1;
 
-	if (!lower_dentry->d_op || !lower_dentry->d_op->d_revalidate)
+	if (!(lower_dentry->d_flags & DCACHE_OP_REVALIDATE_EITHER))
 		goto out;
+	if (nd->flags & LOOKUP_RCU)
+		return -ECHILD;
 	dentry_save = nd->path.dentry;
 	vfsmount_save = nd->path.mnt;
 	nd->path.dentry = lower_dentry;
 	nd->path.mnt = lower_mnt;
-	rc = lower_dentry->d_op->d_revalidate(lower_dentry, nd);
+	if (lower_dentry->d_flags & DCACHE_OP_REVALIDATE)
+		rc = lower_dentry->d_op->d_revalidate(lower_dentry, nd);
+	else
+		rc = lower_dentry->d_op->d_revalidate_rcu(lower_dentry, nd);
 	nd->path.dentry = dentry_save;
 	nd->path.mnt = vfsmount_save;
 	if (dentry->d_inode) {
@@ -91,6 +96,6 @@ static void ecryptfs_d_release(struct dentry *dentry)
 }
 
 const struct dentry_operations ecryptfs_dops = {
-	.d_revalidate = ecryptfs_d_revalidate,
+	.d_revalidate_rcu = ecryptfs_d_revalidate_rcu,
 	.d_release = ecryptfs_d_release,
 };
diff --git a/fs/fat/namei_vfat.c b/fs/fat/namei_vfat.c
index b721715..a169f24 100644
--- a/fs/fat/namei_vfat.c
+++ b/fs/fat/namei_vfat.c
@@ -31,7 +31,7 @@
  * If it happened, the negative dentry isn't actually negative
  * anymore.  So, drop it.
  */
-static int vfat_revalidate_shortname(struct dentry *dentry)
+static int vfat_revalidate_rcu_shortname(struct dentry *dentry)
 {
 	int ret = 1;
 	spin_lock(&dentry->d_lock);
@@ -41,15 +41,15 @@ static int vfat_revalidate_shortname(struct dentry *dentry)
 	return ret;
 }
 
-static int vfat_revalidate(struct dentry *dentry, struct nameidata *nd)
+static int vfat_revalidate_rcu(struct dentry *dentry, struct nameidata *nd)
 {
 	/* This is not negative dentry. Always valid. */
 	if (dentry->d_inode)
 		return 1;
-	return vfat_revalidate_shortname(dentry);
+	return vfat_revalidate_rcu_shortname(dentry);
 }
 
-static int vfat_revalidate_ci(struct dentry *dentry, struct nameidata *nd)
+static int vfat_revalidate_rcu_ci(struct dentry *dentry, struct nameidata *nd)
 {
 	/*
 	 * This is not negative dentry. Always valid.
@@ -81,7 +81,7 @@ static int vfat_revalidate_ci(struct dentry *dentry, struct nameidata *nd)
 			return 0;
 	}
 
-	return vfat_revalidate_shortname(dentry);
+	return vfat_revalidate_rcu_shortname(dentry);
 }
 
 /* returns the length of a struct qstr, ignoring trailing dots */
@@ -175,13 +175,13 @@ static int vfat_cmp(const struct dentry *parent,
 }
 
 static const struct dentry_operations vfat_ci_dentry_ops = {
-	.d_revalidate	= vfat_revalidate_ci,
+	.d_revalidate	= vfat_revalidate_rcu_ci,
 	.d_hash		= vfat_hashi,
 	.d_compare	= vfat_cmpi,
 };
 
 static const struct dentry_operations vfat_dentry_ops = {
-	.d_revalidate	= vfat_revalidate,
+	.d_revalidate	= vfat_revalidate_rcu,
 	.d_hash		= vfat_hash,
 	.d_compare	= vfat_cmp,
 };
diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index c9a8a42..e409185 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -154,7 +154,7 @@ u64 fuse_get_attr_version(struct fuse_conn *fc)
  * the lookup once more.  If the lookup results in the same inode,
  * then refresh the attributes, timeouts and mark the dentry valid.
  */
-static int fuse_dentry_revalidate(struct dentry *entry, struct nameidata *nd)
+static int fuse_dentry_revalidate_rcu(struct dentry *entry, struct nameidata *nd)
 {
 	struct inode *inode = entry->d_inode;
 
@@ -169,6 +169,9 @@ static int fuse_dentry_revalidate(struct dentry *entry, struct nameidata *nd)
 		struct dentry *parent;
 		u64 attr_version;
 
+		if (nd->flags & LOOKUP_RCU)
+			return -ECHILD;
+
 		/* For negative dentries, always do a fresh lookup */
 		if (!inode)
 			return 0;
@@ -225,7 +228,7 @@ static int invalid_nodeid(u64 nodeid)
 }
 
 const struct dentry_operations fuse_dentry_operations = {
-	.d_revalidate	= fuse_dentry_revalidate,
+	.d_revalidate_rcu = fuse_dentry_revalidate_rcu,
 };
 
 int fuse_valid_type(int m)
diff --git a/fs/namei.c b/fs/namei.c
index 717ab13..d8f7ece 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -519,10 +519,30 @@ void release_open_intent(struct nameidata *nd)
 		fput(nd->intent.open.file);
 }
 
+static int d_revalidate(struct dentry *dentry, struct nameidata *nd)
+{
+	if (dentry->d_op->d_revalidate_rcu) {
+		int status;
+		status = dentry->d_op->d_revalidate_rcu(dentry, nd);
+		if (!status && (nd->flags & LOOKUP_RCU))
+			status = -ECHILD;
+		if (status == -ECHILD) {
+			BUG_ON(!(nd->flags & LOOKUP_RCU));
+			if (nameidata_dentry_drop_rcu(nd, dentry))
+				return status;
+			status = dentry->d_op->d_revalidate_rcu(dentry, nd);
+		}
+		return status;
+	} else
+		return dentry->d_op->d_revalidate(dentry, nd);
+}
+
 static inline struct dentry *
 do_revalidate(struct dentry *dentry, struct nameidata *nd)
 {
-	int status = dentry->d_op->d_revalidate(dentry, nd);
+	int status;
+
+	status = d_revalidate(dentry, nd);
 	if (unlikely(status <= 0)) {
 		/*
 		 * The dentry failed validation.
@@ -545,7 +565,7 @@ do_revalidate(struct dentry *dentry, struct nameidata *nd)
 
 static inline int need_reval_dot(struct dentry *dentry)
 {
-	if (likely(!(dentry->d_flags & DCACHE_OP_REVALIDATE)))
+	if (likely(!(dentry->d_flags & DCACHE_OP_REVALIDATE_EITHER)))
 		return 0;
 
 	if (likely(!(dentry->d_sb->s_type->fs_flags & FS_REVAL_DOT)))
@@ -582,7 +602,7 @@ force_reval_path(struct path *path, struct nameidata *nd)
 	if (!need_reval_dot(dentry))
 		return 0;
 
-	status = dentry->d_op->d_revalidate(dentry, nd);
+	status = d_revalidate(dentry, nd);
 	if (status > 0)
 		return 0;
 
@@ -994,10 +1014,11 @@ static int do_lookup(struct nameidata *nd, struct qstr *name,
 			return -ECHILD;
 
 		nd->seq = seq;
-		if (dentry->d_flags & DCACHE_OP_REVALIDATE) {
-			/* XXX: RCU chokes here */
-			if (nameidata_dentry_drop_rcu(nd, dentry))
-				return -ECHILD;
+		if (dentry->d_flags & DCACHE_OP_REVALIDATE_EITHER) {
+			if (dentry->d_flags & DCACHE_OP_REVALIDATE) {
+				if (nameidata_dentry_drop_rcu(nd, dentry))
+					return -ECHILD;
+			}
 			goto need_revalidate;
 		}
 		path->mnt = mnt;
@@ -1050,8 +1071,11 @@ need_lookup:
 
 need_revalidate:
 	dentry = do_revalidate(dentry, nd);
-	if (!dentry)
+	if (!dentry) {
+		if (try_nameidata_drop_rcu(nd))
+			return -ECHILD;
 		goto need_lookup;
+	}
 	if (IS_ERR(dentry))
 		goto fail;
 	goto done;
@@ -1247,12 +1271,11 @@ return_reval:
 		 * We may need to check the cached dentry for staleness.
 		 */
 		if (need_reval_dot(nd->path.dentry)) {
-			if (try_nameidata_drop_rcu(nd))
-				return -ECHILD;
-			err = -ESTALE;
 			/* Note: we do not d_invalidate() */
-			if (!nd->path.dentry->d_op->d_revalidate(
-					nd->path.dentry, nd))
+			err = d_revalidate(nd->path.dentry, nd);
+			if (!err)
+				err = -ESTALE;
+			if (err < 0)
 				break;
 		}
 return_base:
@@ -1566,7 +1589,7 @@ static struct dentry *__lookup_hash(struct qstr *name,
 	 */
 	dentry = d_lookup(base, name);
 
-	if (dentry && (dentry->d_flags & DCACHE_OP_REVALIDATE))
+	if (dentry && (dentry->d_flags & DCACHE_OP_REVALIDATE_EITHER))
 		dentry = do_revalidate(dentry, nd);
 
 	if (!dentry)
@@ -2021,10 +2044,11 @@ static struct file *do_last(struct nameidata *nd, struct path *path,
 		dir = nd->path.dentry;
 	case LAST_DOT:
 		if (need_reval_dot(dir)) {
-			if (!dir->d_op->d_revalidate(dir, nd)) {
+			error = d_revalidate(nd->path.dentry, nd);
+			if (!error)
 				error = -ESTALE;
+			if (error < 0)
 				goto exit;
-			}
 		}
 		/* fallthrough */
 	case LAST_ROOT:
diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 3e076ca..c3fff57 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -237,12 +237,21 @@ static int sysfs_dentry_delete(const struct dentry *dentry)
 	return !!(sd->s_flags & SYSFS_FLAG_REMOVED);
 }
 
-static int sysfs_dentry_revalidate(struct dentry *dentry, struct nameidata *nd)
+static int sysfs_dentry_revalidate_rcu(struct dentry *dentry, struct nameidata *nd)
 {
 	struct sysfs_dirent *sd = dentry->d_fsdata;
 	int is_dir;
 
-	mutex_lock(&sysfs_mutex);
+	if (nd->flags & LOOKUP_RCU) {
+		if (!mutex_trylock(&sysfs_mutex))
+			return -ECHILD;
+		/* ensure dentry still exists, now under the sysfs_mutex */
+		if (read_seqcount_retry(&dentry->d_seq, nd->seq)) {
+			mutex_unlock(&sysfs_mutex);
+			return -ECHILD;
+		}
+	} else
+		mutex_lock(&sysfs_mutex);
 
 	/* The sysfs dirent has been deleted */
 	if (sd->s_flags & SYSFS_FLAG_REMOVED)
@@ -272,6 +281,9 @@ out_bad:
 	 */
 	is_dir = (sysfs_type(sd) == SYSFS_DIR);
 	mutex_unlock(&sysfs_mutex);
+	if (nd->flags & LOOKUP_RCU)
+		return -ECHILD;
+
 	if (is_dir) {
 		/* If we have submounts we must allow the vfs caches
 		 * to lie about the state of the filesystem to prevent
@@ -294,7 +306,7 @@ static void sysfs_dentry_iput(struct dentry *dentry, struct inode *inode)
 }
 
 static const struct dentry_operations sysfs_dentry_ops = {
-	.d_revalidate	= sysfs_dentry_revalidate,
+	.d_revalidate_rcu = sysfs_dentry_revalidate_rcu,
 	.d_delete	= sysfs_dentry_delete,
 	.d_iput		= sysfs_dentry_iput,
 };
diff --git a/include/linux/dcache.h b/include/linux/dcache.h
index 3c5cafc..72f5f32 100644
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -132,6 +132,7 @@ enum dentry_d_lock_class
 
 struct dentry_operations {
 	int (*d_revalidate)(struct dentry *, struct nameidata *);
+	int (*d_revalidate_rcu)(struct dentry *, struct nameidata *);
 	int (*d_hash)(const struct dentry *, const struct inode *,
 			struct qstr *);
 	int (*d_compare)(const struct dentry *,
@@ -184,8 +185,12 @@ struct dentry_operations {
 #define DCACHE_OP_HASH		0x1000
 #define DCACHE_OP_COMPARE	0x2000
 #define DCACHE_OP_REVALIDATE	0x4000
-#define DCACHE_OP_DELETE	0x8000
+#define DCACHE_OP_REVALIDATE_RCU 0x8000
 
+#define DCACHE_OP_DELETE	0x10000
+
+#define DCACHE_OP_REVALIDATE_EITHER	\
+	(DCACHE_OP_REVALIDATE|DCACHE_OP_REVALIDATE_RCU)
 
 extern spinlock_t dcache_inode_lock;
 extern spinlock_t dcache_hash_lock;
-- 
1.7.1

