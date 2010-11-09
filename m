Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752153Ab0KINBm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 08:01:42 -0500
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:3844 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751202Ab0KINBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 08:01:38 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAHDU2Ex5LcZK/2dsb2JhbACiH3K/QYVKBIUQilQ
Date: Wed, 10 Nov 2010 00:01:33 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Al Viro <viro@ZenIV.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [patch 4/6] fs: d_delete change
Message-ID: <20101109130133.GE11477@amd>
References: <20101109124610.GB11477@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101109124610.GB11477@amd>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Actually this change is required for basic dcache scaling rather than
rcu-walk, but I think it's a good one anyway. Should be easy to merge.

--

Change d_delete from a dentry deletion notification to a dentry caching
advise, more like ->drop_inode. Require it to be constant and idempotent,
and not take d_lock. This is how all existing filesystems use the callback
anyway.

This makes fine grained dentry locking of dput and dentry lru scanning
much simpler.

Signed-off-by: Nick Piggin <npiggin@kernel.dk>

---
 Documentation/filesystems/porting |    7 +++++++
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
 20 files changed, 43 insertions(+), 39 deletions(-)

Index: linux-2.6/Documentation/filesystems/porting
===================================================================
--- linux-2.6.orig/Documentation/filesystems/porting	2010-11-09 22:11:10.000000000 +1100
+++ linux-2.6/Documentation/filesystems/porting	2010-11-09 23:22:51.000000000 +1100
@@ -330,3 +330,10 @@ namespace).
 to be reinitialized before it is freed, so INIT_LIST_HEAD(&inode->i_dentry)
 must be done in the RCU callback.
 
+---
+[mandatory]
+
+	.d_delete() now only advises the dcache as to whether or not to cache
+unreferenced dentries, and is now only called when the dentry refcount goes to
+0. Even on 0 refcount transition, it must be able to tolerate being called 0, 1,
+or more times (eg. constant, idempotent).
Index: linux-2.6/Documentation/filesystems/vfs.txt
===================================================================
--- linux-2.6.orig/Documentation/filesystems/vfs.txt	2010-11-09 22:10:59.000000000 +1100
+++ linux-2.6/Documentation/filesystems/vfs.txt	2010-11-09 23:22:51.000000000 +1100
@@ -841,9 +841,9 @@ the VFS uses a default. As of kernel 2.6
 
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
 
@@ -904,14 +906,11 @@ There are a number of functions defined
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
Index: linux-2.6/fs/dcache.c
===================================================================
--- linux-2.6.orig/fs/dcache.c	2010-11-09 22:10:59.000000000 +1100
+++ linux-2.6/fs/dcache.c	2010-11-09 23:22:51.000000000 +1100
@@ -446,8 +446,6 @@ static void prune_one_dentry(struct dent
 		if (!atomic_dec_and_lock(&dentry->d_count, &dentry->d_lock))
 			return;
 
-		if (dentry->d_op && dentry->d_op->d_delete)
-			dentry->d_op->d_delete(dentry);
 		dentry_lru_del(dentry);
 		__d_drop(dentry);
 		dentry = d_kill(dentry);
Index: linux-2.6/include/linux/dcache.h
===================================================================
--- linux-2.6.orig/include/linux/dcache.h	2010-11-09 22:11:10.000000000 +1100
+++ linux-2.6/include/linux/dcache.h	2010-11-09 23:22:51.000000000 +1100
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
Index: linux-2.6/arch/ia64/kernel/perfmon.c
===================================================================
--- linux-2.6.orig/arch/ia64/kernel/perfmon.c	2010-11-09 22:10:59.000000000 +1100
+++ linux-2.6/arch/ia64/kernel/perfmon.c	2010-11-09 22:11:10.000000000 +1100
@@ -2185,7 +2185,7 @@ static const struct file_operations pfm_
 };
 
 static int
-pfmfs_delete_dentry(struct dentry *dentry)
+pfmfs_delete_dentry(const struct dentry *dentry)
 {
 	return 1;
 }
Index: linux-2.6/fs/9p/vfs_dentry.c
===================================================================
--- linux-2.6.orig/fs/9p/vfs_dentry.c	2010-11-09 22:10:59.000000000 +1100
+++ linux-2.6/fs/9p/vfs_dentry.c	2010-11-09 22:11:10.000000000 +1100
@@ -51,7 +51,7 @@
  *
  */
 
-static int v9fs_dentry_delete(struct dentry *dentry)
+static int v9fs_dentry_delete(const struct dentry *dentry)
 {
 	P9_DPRINTK(P9_DEBUG_VFS, " dentry: %s (%p)\n", dentry->d_name.name,
 									dentry);
@@ -68,7 +68,7 @@ static int v9fs_dentry_delete(struct den
  *
  */
 
-static int v9fs_cached_dentry_delete(struct dentry *dentry)
+static int v9fs_cached_dentry_delete(const struct dentry *dentry)
 {
 	struct inode *inode = dentry->d_inode;
 	P9_DPRINTK(P9_DEBUG_VFS, " dentry: %s (%p)\n", dentry->d_name.name,
Index: linux-2.6/fs/afs/dir.c
===================================================================
--- linux-2.6.orig/fs/afs/dir.c	2010-11-09 22:11:00.000000000 +1100
+++ linux-2.6/fs/afs/dir.c	2010-11-09 22:11:10.000000000 +1100
@@ -23,7 +23,7 @@ static struct dentry *afs_lookup(struct
 static int afs_dir_open(struct inode *inode, struct file *file);
 static int afs_readdir(struct file *file, void *dirent, filldir_t filldir);
 static int afs_d_revalidate(struct dentry *dentry, struct nameidata *nd);
-static int afs_d_delete(struct dentry *dentry);
+static int afs_d_delete(const struct dentry *dentry);
 static void afs_d_release(struct dentry *dentry);
 static int afs_lookup_filldir(void *_cookie, const char *name, int nlen,
 				  loff_t fpos, u64 ino, unsigned dtype);
@@ -730,7 +730,7 @@ static int afs_d_revalidate(struct dentr
  * - called from dput() when d_count is going to 0.
  * - return 1 to request dentry be unhashed, 0 otherwise
  */
-static int afs_d_delete(struct dentry *dentry)
+static int afs_d_delete(const struct dentry *dentry)
 {
 	_enter("%s", dentry->d_name.name);
 
Index: linux-2.6/fs/btrfs/inode.c
===================================================================
--- linux-2.6.orig/fs/btrfs/inode.c	2010-11-09 22:11:10.000000000 +1100
+++ linux-2.6/fs/btrfs/inode.c	2010-11-09 22:11:10.000000000 +1100
@@ -4127,7 +4127,7 @@ struct inode *btrfs_lookup_dentry(struct
 	return inode;
 }
 
-static int btrfs_dentry_delete(struct dentry *dentry)
+static int btrfs_dentry_delete(const struct dentry *dentry)
 {
 	struct btrfs_root *root;
 
Index: linux-2.6/fs/coda/dir.c
===================================================================
--- linux-2.6.orig/fs/coda/dir.c	2010-11-09 22:10:59.000000000 +1100
+++ linux-2.6/fs/coda/dir.c	2010-11-09 22:11:10.000000000 +1100
@@ -47,7 +47,7 @@ static int coda_readdir(struct file *fil
 
 /* dentry ops */
 static int coda_dentry_revalidate(struct dentry *de, struct nameidata *nd);
-static int coda_dentry_delete(struct dentry *);
+static int coda_dentry_delete(const struct dentry *);
 
 /* support routines */
 static int coda_venus_readdir(struct file *coda_file, void *buf,
@@ -577,7 +577,7 @@ static int coda_dentry_revalidate(struct
  * This is the callback from dput() when d_count is going to 0.
  * We use this to unhash dentries with bad inodes.
  */
-static int coda_dentry_delete(struct dentry * dentry)
+static int coda_dentry_delete(const struct dentry * dentry)
 {
 	int flags;
 
Index: linux-2.6/fs/configfs/dir.c
===================================================================
--- linux-2.6.orig/fs/configfs/dir.c	2010-11-09 22:10:59.000000000 +1100
+++ linux-2.6/fs/configfs/dir.c	2010-11-09 22:11:10.000000000 +1100
@@ -67,7 +67,7 @@ static void configfs_d_iput(struct dentr
  * We _must_ delete our dentries on last dput, as the chain-to-parent
  * behavior is required to clear the parents of default_groups.
  */
-static int configfs_d_delete(struct dentry *dentry)
+static int configfs_d_delete(const struct dentry *dentry)
 {
 	return 1;
 }
Index: linux-2.6/fs/gfs2/dentry.c
===================================================================
--- linux-2.6.orig/fs/gfs2/dentry.c	2010-11-09 22:11:00.000000000 +1100
+++ linux-2.6/fs/gfs2/dentry.c	2010-11-09 23:22:50.000000000 +1100
@@ -106,7 +106,7 @@ static int gfs2_dhash(struct dentry *den
 	return 0;
 }
 
-static int gfs2_dentry_delete(struct dentry *dentry)
+static int gfs2_dentry_delete(const struct dentry *dentry)
 {
 	struct gfs2_inode *ginode;
 
Index: linux-2.6/fs/hostfs/hostfs_kern.c
===================================================================
--- linux-2.6.orig/fs/hostfs/hostfs_kern.c	2010-11-09 22:11:10.000000000 +1100
+++ linux-2.6/fs/hostfs/hostfs_kern.c	2010-11-09 22:11:10.000000000 +1100
@@ -32,7 +32,7 @@ static inline struct hostfs_inode_info *
 
 #define FILE_HOSTFS_I(file) HOSTFS_I((file)->f_path.dentry->d_inode)
 
-static int hostfs_d_delete(struct dentry *dentry)
+static int hostfs_d_delete(const struct dentry *dentry)
 {
 	return 1;
 }
Index: linux-2.6/fs/libfs.c
===================================================================
--- linux-2.6.orig/fs/libfs.c	2010-11-09 22:10:59.000000000 +1100
+++ linux-2.6/fs/libfs.c	2010-11-09 22:11:10.000000000 +1100
@@ -37,7 +37,7 @@ int simple_statfs(struct dentry *dentry,
  * Retaining negative dentries for an in-memory filesystem just wastes
  * memory and lookup time: arrange for them to be deleted immediately.
  */
-static int simple_delete_dentry(struct dentry *dentry)
+static int simple_delete_dentry(const struct dentry *dentry)
 {
 	return 1;
 }
Index: linux-2.6/fs/ncpfs/dir.c
===================================================================
--- linux-2.6.orig/fs/ncpfs/dir.c	2010-11-09 22:10:59.000000000 +1100
+++ linux-2.6/fs/ncpfs/dir.c	2010-11-09 23:22:51.000000000 +1100
@@ -77,7 +77,7 @@ const struct inode_operations ncp_dir_in
 static int ncp_lookup_validate(struct dentry *, struct nameidata *);
 static int ncp_hash_dentry(struct dentry *, struct qstr *);
 static int ncp_compare_dentry (struct dentry *, struct qstr *, struct qstr *);
-static int ncp_delete_dentry(struct dentry *);
+static int ncp_delete_dentry(const struct dentry *);
 
 static const struct dentry_operations ncp_dentry_operations =
 {
@@ -163,7 +163,7 @@ ncp_compare_dentry(struct dentry *dentry
  * Closing files can be safely postponed until iput() - it's done there anyway.
  */
 static int
-ncp_delete_dentry(struct dentry * dentry)
+ncp_delete_dentry(const struct dentry * dentry)
 {
 	struct inode *inode = dentry->d_inode;
 
Index: linux-2.6/fs/nfs/dir.c
===================================================================
--- linux-2.6.orig/fs/nfs/dir.c	2010-11-09 22:10:59.000000000 +1100
+++ linux-2.6/fs/nfs/dir.c	2010-11-09 22:11:10.000000000 +1100
@@ -1091,7 +1091,7 @@ static int nfs_lookup_revalidate(struct
 /*
  * This is called from dput() when d_count is going to 0.
  */
-static int nfs_dentry_delete(struct dentry *dentry)
+static int nfs_dentry_delete(const struct dentry *dentry)
 {
 	dfprintk(VFS, "NFS: dentry_delete(%s/%s, %x)\n",
 		dentry->d_parent->d_name.name, dentry->d_name.name,
Index: linux-2.6/fs/proc/base.c
===================================================================
--- linux-2.6.orig/fs/proc/base.c	2010-11-09 22:10:59.000000000 +1100
+++ linux-2.6/fs/proc/base.c	2010-11-09 22:11:10.000000000 +1100
@@ -1744,7 +1744,7 @@ static int pid_revalidate(struct dentry
 	return 0;
 }
 
-static int pid_delete_dentry(struct dentry * dentry)
+static int pid_delete_dentry(const struct dentry * dentry)
 {
 	/* Is the task we represent dead?
 	 * If so, then don't put the dentry on the lru list,
Index: linux-2.6/fs/proc/generic.c
===================================================================
--- linux-2.6.orig/fs/proc/generic.c	2010-11-09 22:10:59.000000000 +1100
+++ linux-2.6/fs/proc/generic.c	2010-11-09 22:11:10.000000000 +1100
@@ -400,7 +400,7 @@ static const struct inode_operations pro
  * smarter: we could keep a "volatile" flag in the 
  * inode to indicate which ones to keep.
  */
-static int proc_delete_dentry(struct dentry * dentry)
+static int proc_delete_dentry(const struct dentry * dentry)
 {
 	return 1;
 }
Index: linux-2.6/fs/proc/proc_sysctl.c
===================================================================
--- linux-2.6.orig/fs/proc/proc_sysctl.c	2010-11-09 22:10:59.000000000 +1100
+++ linux-2.6/fs/proc/proc_sysctl.c	2010-11-09 23:22:51.000000000 +1100
@@ -392,7 +392,7 @@ static int proc_sys_revalidate(struct de
 	return !PROC_I(dentry->d_inode)->sysctl->unregistering;
 }
 
-static int proc_sys_delete(struct dentry *dentry)
+static int proc_sys_delete(const struct dentry *dentry)
 {
 	return !!PROC_I(dentry->d_inode)->sysctl->unregistering;
 }
Index: linux-2.6/fs/sysfs/dir.c
===================================================================
--- linux-2.6.orig/fs/sysfs/dir.c	2010-11-09 22:10:59.000000000 +1100
+++ linux-2.6/fs/sysfs/dir.c	2010-11-09 22:11:10.000000000 +1100
@@ -231,7 +231,7 @@ void release_sysfs_dirent(struct sysfs_d
 		goto repeat;
 }
 
-static int sysfs_dentry_delete(struct dentry *dentry)
+static int sysfs_dentry_delete(const struct dentry *dentry)
 {
 	struct sysfs_dirent *sd = dentry->d_fsdata;
 	return !!(sd->s_flags & SYSFS_FLAG_REMOVED);
Index: linux-2.6/net/sunrpc/rpc_pipe.c
===================================================================
--- linux-2.6.orig/net/sunrpc/rpc_pipe.c	2010-11-09 22:11:10.000000000 +1100
+++ linux-2.6/net/sunrpc/rpc_pipe.c	2010-11-09 22:11:10.000000000 +1100
@@ -438,7 +438,7 @@ void rpc_put_mount(void)
 }
 EXPORT_SYMBOL_GPL(rpc_put_mount);
 
-static int rpc_delete_dentry(struct dentry *dentry)
+static int rpc_delete_dentry(const struct dentry *dentry)
 {
 	return 1;
 }
