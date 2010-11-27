Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752776Ab0K0K0K (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Nov 2010 05:26:10 -0500
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:34785 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752564Ab0K0K0C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Nov 2010 05:26:02 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAO1p8Ex5Lcx2/2dsb2JhbACjC3K9doVHBIUUhU2FFA
Message-Id: <5d48d9adef04dd18342f3f2b5746d1bcafcb3ab4.1290852958.git.npiggin@kernel.dk>
In-Reply-To: <cover.1290852958.git.npiggin@kernel.dk>
References: <cover.1290852958.git.npiggin@kernel.dk>
From: Nick Piggin <npiggin@kernel.dk>
Date: Sat, 27 Nov 2010 20:44:35 +1100
Subject: [PATCH 05/46] fs: change d_delete semantics
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change d_delete from a dentry deletion notification to a dentry caching
advise, more like ->drop_inode. Require it to be constant and idempotent,
and not take d_lock. This is how all existing filesystems use the callback
anyway.

This makes fine grained dentry locking of dput and dentry lru scanning
much simpler.

Signed-off-by: Nick Piggin <npiggin@kernel.dk>
---
 Documentation/filesystems/porting |    9 +++++++++
 Documentation/filesystems/vfs.txt |   27 +++++++++++++--------------
 arch/ia64/kernel/perfmon.c        |    2 +-
 fs/9p/vfs_dentry.c                |    4 ++--
 fs/afs/dir.c                      |    4 ++--
 fs/btrfs/inode.c                  |    2 +-
 fs/coda/dir.c                     |    4 ++--
 fs/configfs/dir.c                 |    2 +-
 fs/dcache.c                       |    2 --
 fs/gfs2/dentry.c                  |    2 +-
 fs/hostfs/hostfs_kern.c           |    2 +-
 fs/libfs.c                        |    2 +-
 fs/ncpfs/dir.c                    |    4 ++--
 fs/nfs/dir.c                      |    2 +-
 fs/proc/base.c                    |    2 +-
 fs/proc/generic.c                 |    2 +-
 fs/proc/proc_sysctl.c             |    2 +-
 fs/sysfs/dir.c                    |    2 +-
 include/linux/dcache.h            |    6 +++---
 net/sunrpc/rpc_pipe.c             |    2 +-
 20 files changed, 45 insertions(+), 39 deletions(-)

diff --git a/Documentation/filesystems/porting b/Documentation/filesystems/porting
index b12c895..6d9d6c3 100644
--- a/Documentation/filesystems/porting
+++ b/Documentation/filesystems/porting
@@ -318,3 +318,12 @@ if it's zero is not *and* *never* *had* *been* enough.  Final unlink() and iput(
 may happen while the inode is in the middle of ->write_inode(); e.g. if you blindly
 free the on-disk inode, you may end up doing that while ->write_inode() is writing
 to it.
+
+---
+[mandatory]
+
+	.d_delete() now only advises the dcache as to whether or not to cache
+unreferenced dentries, and is now only called when the dentry refcount goes to
+0. Even on 0 refcount transition, it must be able to tolerate being called 0,
+1, or more times (eg. constant, idempotent).
+
diff --git a/Documentation/filesystems/vfs.txt b/Documentation/filesystems/vfs.txt
index ed7e5ef..83c42d0 100644
--- a/Documentation/filesystems/vfs.txt
+++ b/Documentation/filesystems/vfs.txt
@@ -841,9 +841,9 @@ defined:
 
 struct dentry_operations {
 	int (*d_revalidate)(struct dentry *, struct nameidata *);
-	int (*d_hash) (struct dentry *, struct qstr *);
-	int (*d_compare) (struct dentry *, struct qstr *, struct qstr *);
-	int (*d_delete)(struct dentry *);
+	int (*d_hash)(struct dentry *, struct qstr *);
+	int (*d_compare)(struct dentry *, struct qstr *, struct qstr *);
+	int (*d_delete)(const struct dentry *);
 	void (*d_release)(struct dentry *);
 	void (*d_iput)(struct dentry *, struct inode *);
 	char *(*d_dname)(struct dentry *, char *, int);
@@ -858,9 +858,11 @@ struct dentry_operations {
 
   d_compare: called when a dentry should be compared with another
 
-  d_delete: called when the last reference to a dentry is
-	deleted. This means no-one is using the dentry, however it is
-	still valid and in the dcache
+  d_delete: called when the last reference to a dentry is dropped and the
+	dcache is deciding whether or not to cache it. Return 1 to delete
+	immediately, or 0 to cache the dentry. Default is NULL which means to
+	always cache a reachable dentry. d_delete must be constant and
+	idempotent.
 
   d_release: called when a dentry is really deallocated
 
@@ -904,14 +906,11 @@ manipulate dentries:
 	the usage count)
 
   dput: close a handle for a dentry (decrements the usage count). If
-	the usage count drops to 0, the "d_delete" method is called
-	and the dentry is placed on the unused list if the dentry is
-	still in its parents hash list. Putting the dentry on the
-	unused list just means that if the system needs some RAM, it
-	goes through the unused list of dentries and deallocates them.
-	If the dentry has already been unhashed and the usage count
-	drops to 0, in this case the dentry is deallocated after the
-	"d_delete" method is called
+	the usage count drops to 0, and the dentry is still in its
+	parent's hash, the "d_delete" method is called to check whether
+	it should be cached. If it should not be cached, or if the dentry
+	is not hashed, it is deleted. Otherwise cached dentries are put
+	into an LRU list to be reclaimed on memory shortage.
 
   d_drop: this unhashes a dentry from its parents hash list. A
 	subsequent call to dput() will deallocate the dentry if its
diff --git a/arch/ia64/kernel/perfmon.c b/arch/ia64/kernel/perfmon.c
index 39e534f..d39d8a5 100644
--- a/arch/ia64/kernel/perfmon.c
+++ b/arch/ia64/kernel/perfmon.c
@@ -2185,7 +2185,7 @@ static const struct file_operations pfm_file_ops = {
 };
 
 static int
-pfmfs_delete_dentry(struct dentry *dentry)
+pfmfs_delete_dentry(const struct dentry *dentry)
 {
 	return 1;
 }
diff --git a/fs/9p/vfs_dentry.c b/fs/9p/vfs_dentry.c
index cbf4e50..466d2a4 100644
--- a/fs/9p/vfs_dentry.c
+++ b/fs/9p/vfs_dentry.c
@@ -51,7 +51,7 @@
  *
  */
 
-static int v9fs_dentry_delete(struct dentry *dentry)
+static int v9fs_dentry_delete(const struct dentry *dentry)
 {
 	P9_DPRINTK(P9_DEBUG_VFS, " dentry: %s (%p)\n", dentry->d_name.name,
 									dentry);
@@ -68,7 +68,7 @@ static int v9fs_dentry_delete(struct dentry *dentry)
  *
  */
 
-static int v9fs_cached_dentry_delete(struct dentry *dentry)
+static int v9fs_cached_dentry_delete(const struct dentry *dentry)
 {
 	struct inode *inode = dentry->d_inode;
 	P9_DPRINTK(P9_DEBUG_VFS, " dentry: %s (%p)\n", dentry->d_name.name,
diff --git a/fs/afs/dir.c b/fs/afs/dir.c
index 5439e1b..2c18cde 100644
--- a/fs/afs/dir.c
+++ b/fs/afs/dir.c
@@ -23,7 +23,7 @@ static struct dentry *afs_lookup(struct inode *dir, struct dentry *dentry,
 static int afs_dir_open(struct inode *inode, struct file *file);
 static int afs_readdir(struct file *file, void *dirent, filldir_t filldir);
 static int afs_d_revalidate(struct dentry *dentry, struct nameidata *nd);
-static int afs_d_delete(struct dentry *dentry);
+static int afs_d_delete(const struct dentry *dentry);
 static void afs_d_release(struct dentry *dentry);
 static int afs_lookup_filldir(void *_cookie, const char *name, int nlen,
 				  loff_t fpos, u64 ino, unsigned dtype);
@@ -730,7 +730,7 @@ out_bad:
  * - called from dput() when d_count is going to 0.
  * - return 1 to request dentry be unhashed, 0 otherwise
  */
-static int afs_d_delete(struct dentry *dentry)
+static int afs_d_delete(const struct dentry *dentry)
 {
 	_enter("%s", dentry->d_name.name);
 
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 558cac2..e134e80 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4127,7 +4127,7 @@ struct inode *btrfs_lookup_dentry(struct inode *dir, struct dentry *dentry)
 	return inode;
 }
 
-static int btrfs_dentry_delete(struct dentry *dentry)
+static int btrfs_dentry_delete(const struct dentry *dentry)
 {
 	struct btrfs_root *root;
 
diff --git a/fs/coda/dir.c b/fs/coda/dir.c
index 5d8b355..4cce3b0 100644
--- a/fs/coda/dir.c
+++ b/fs/coda/dir.c
@@ -47,7 +47,7 @@ static int coda_readdir(struct file *file, void *buf, filldir_t filldir);
 
 /* dentry ops */
 static int coda_dentry_revalidate(struct dentry *de, struct nameidata *nd);
-static int coda_dentry_delete(struct dentry *);
+static int coda_dentry_delete(const struct dentry *);
 
 /* support routines */
 static int coda_venus_readdir(struct file *coda_file, void *buf,
@@ -577,7 +577,7 @@ out:
  * This is the callback from dput() when d_count is going to 0.
  * We use this to unhash dentries with bad inodes.
  */
-static int coda_dentry_delete(struct dentry * dentry)
+static int coda_dentry_delete(const struct dentry * dentry)
 {
 	int flags;
 
diff --git a/fs/configfs/dir.c b/fs/configfs/dir.c
index 0b502f8..1001557 100644
--- a/fs/configfs/dir.c
+++ b/fs/configfs/dir.c
@@ -67,7 +67,7 @@ static void configfs_d_iput(struct dentry * dentry,
  * We _must_ delete our dentries on last dput, as the chain-to-parent
  * behavior is required to clear the parents of default_groups.
  */
-static int configfs_d_delete(struct dentry *dentry)
+static int configfs_d_delete(const struct dentry *dentry)
 {
 	return 1;
 }
diff --git a/fs/dcache.c b/fs/dcache.c
index 9d1a59d..14e0564 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -446,8 +446,6 @@ static void prune_one_dentry(struct dentry * dentry)
 		if (!atomic_dec_and_lock(&dentry->d_count, &dentry->d_lock))
 			return;
 
-		if (dentry->d_op && dentry->d_op->d_delete)
-			dentry->d_op->d_delete(dentry);
 		dentry_lru_del(dentry);
 		__d_drop(dentry);
 		dentry = d_kill(dentry);
diff --git a/fs/gfs2/dentry.c b/fs/gfs2/dentry.c
index 6798755..e80fea2 100644
--- a/fs/gfs2/dentry.c
+++ b/fs/gfs2/dentry.c
@@ -106,7 +106,7 @@ static int gfs2_dhash(struct dentry *dentry, struct qstr *str)
 	return 0;
 }
 
-static int gfs2_dentry_delete(struct dentry *dentry)
+static int gfs2_dentry_delete(const struct dentry *dentry)
 {
 	struct gfs2_inode *ginode;
 
diff --git a/fs/hostfs/hostfs_kern.c b/fs/hostfs/hostfs_kern.c
index 2c0f148..cfe8bc7 100644
--- a/fs/hostfs/hostfs_kern.c
+++ b/fs/hostfs/hostfs_kern.c
@@ -32,7 +32,7 @@ static inline struct hostfs_inode_info *HOSTFS_I(struct inode *inode)
 
 #define FILE_HOSTFS_I(file) HOSTFS_I((file)->f_path.dentry->d_inode)
 
-static int hostfs_d_delete(struct dentry *dentry)
+static int hostfs_d_delete(const struct dentry *dentry)
 {
 	return 1;
 }
diff --git a/fs/libfs.c b/fs/libfs.c
index a3accdf..b9d25d8 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -37,7 +37,7 @@ int simple_statfs(struct dentry *dentry, struct kstatfs *buf)
  * Retaining negative dentries for an in-memory filesystem just wastes
  * memory and lookup time: arrange for them to be deleted immediately.
  */
-static int simple_delete_dentry(struct dentry *dentry)
+static int simple_delete_dentry(const struct dentry *dentry)
 {
 	return 1;
 }
diff --git a/fs/ncpfs/dir.c b/fs/ncpfs/dir.c
index f22b12e..d6e6453 100644
--- a/fs/ncpfs/dir.c
+++ b/fs/ncpfs/dir.c
@@ -76,7 +76,7 @@ const struct inode_operations ncp_dir_inode_operations =
 static int ncp_lookup_validate(struct dentry *, struct nameidata *);
 static int ncp_hash_dentry(struct dentry *, struct qstr *);
 static int ncp_compare_dentry (struct dentry *, struct qstr *, struct qstr *);
-static int ncp_delete_dentry(struct dentry *);
+static int ncp_delete_dentry(const struct dentry *);
 
 static const struct dentry_operations ncp_dentry_operations =
 {
@@ -162,7 +162,7 @@ ncp_compare_dentry(struct dentry *dentry, struct qstr *a, struct qstr *b)
  * Closing files can be safely postponed until iput() - it's done there anyway.
  */
 static int
-ncp_delete_dentry(struct dentry * dentry)
+ncp_delete_dentry(const struct dentry * dentry)
 {
 	struct inode *inode = dentry->d_inode;
 
diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index 8ea4a41..0f7798a 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -1127,7 +1127,7 @@ out_error:
 /*
  * This is called from dput() when d_count is going to 0.
  */
-static int nfs_dentry_delete(struct dentry *dentry)
+static int nfs_dentry_delete(const struct dentry *dentry)
 {
 	dfprintk(VFS, "NFS: dentry_delete(%s/%s, %x)\n",
 		dentry->d_parent->d_name.name, dentry->d_name.name,
diff --git a/fs/proc/base.c b/fs/proc/base.c
index f3d02ca..866a41a 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -1744,7 +1744,7 @@ static int pid_revalidate(struct dentry *dentry, struct nameidata *nd)
 	return 0;
 }
 
-static int pid_delete_dentry(struct dentry * dentry)
+static int pid_delete_dentry(const struct dentry * dentry)
 {
 	/* Is the task we represent dead?
 	 * If so, then don't put the dentry on the lru list,
diff --git a/fs/proc/generic.c b/fs/proc/generic.c
index dd29f03..1d607be 100644
--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -400,7 +400,7 @@ static const struct inode_operations proc_link_inode_operations = {
  * smarter: we could keep a "volatile" flag in the 
  * inode to indicate which ones to keep.
  */
-static int proc_delete_dentry(struct dentry * dentry)
+static int proc_delete_dentry(const struct dentry * dentry)
 {
 	return 1;
 }
diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
index b652cb0..a256d77 100644
--- a/fs/proc/proc_sysctl.c
+++ b/fs/proc/proc_sysctl.c
@@ -392,7 +392,7 @@ static int proc_sys_revalidate(struct dentry *dentry, struct nameidata *nd)
 	return !PROC_I(dentry->d_inode)->sysctl->unregistering;
 }
 
-static int proc_sys_delete(struct dentry *dentry)
+static int proc_sys_delete(const struct dentry *dentry)
 {
 	return !!PROC_I(dentry->d_inode)->sysctl->unregistering;
 }
diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 7e54bac..27e1102 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -231,7 +231,7 @@ void release_sysfs_dirent(struct sysfs_dirent * sd)
 		goto repeat;
 }
 
-static int sysfs_dentry_delete(struct dentry *dentry)
+static int sysfs_dentry_delete(const struct dentry *dentry)
 {
 	struct sysfs_dirent *sd = dentry->d_fsdata;
 	return !!(sd->s_flags & SYSFS_FLAG_REMOVED);
diff --git a/include/linux/dcache.h b/include/linux/dcache.h
index fff9755..cbfc956 100644
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -133,9 +133,9 @@ enum dentry_d_lock_class
 
 struct dentry_operations {
 	int (*d_revalidate)(struct dentry *, struct nameidata *);
-	int (*d_hash) (struct dentry *, struct qstr *);
-	int (*d_compare) (struct dentry *, struct qstr *, struct qstr *);
-	int (*d_delete)(struct dentry *);
+	int (*d_hash)(struct dentry *, struct qstr *);
+	int (*d_compare)(struct dentry *, struct qstr *, struct qstr *);
+	int (*d_delete)(const struct dentry *);
 	void (*d_release)(struct dentry *);
 	void (*d_iput)(struct dentry *, struct inode *);
 	char *(*d_dname)(struct dentry *, char *, int);
diff --git a/net/sunrpc/rpc_pipe.c b/net/sunrpc/rpc_pipe.c
index 10a17a3..a0dc1a8 100644
--- a/net/sunrpc/rpc_pipe.c
+++ b/net/sunrpc/rpc_pipe.c
@@ -430,7 +430,7 @@ void rpc_put_mount(void)
 }
 EXPORT_SYMBOL_GPL(rpc_put_mount);
 
-static int rpc_delete_dentry(struct dentry *dentry)
+static int rpc_delete_dentry(const struct dentry *dentry)
 {
 	return 1;
 }
-- 
1.7.1

