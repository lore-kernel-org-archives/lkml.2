Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758833Ab0KPOYK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 09:24:10 -0500
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:32788 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758582Ab0KPOYD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 09:24:03 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AiQJAKMh4kx5Ldur/2dsb2JhbACVYYx9cr5mhUsEilg
Message-Id: <20101116142030.415925841@kernel.dk>
User-Agent: quilt/0.48-1
Date: Wed, 17 Nov 2010 01:09:23 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [patch 23/28] fs: dcache rationalise dget variants
References: <20101116140900.039761100@kernel.dk>
Content-Disposition: inline; filename=dcache-rationalize-dget.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dget_locked was a shortcut to avoid the lazy lru manipulation when we already
held dcache_lock (lru manipulation was relatively cheap at that point).
However, how that the lru lock is an innermost one, we never hold it at any
caller, so the lock cost can now be avoided. We already have well working lazy
dcache LRU, so it should be fine to defer LRU manipulations to scan time.

Signed-off-by: Nick Piggin <npiggin@kernel.dk>

---
 arch/powerpc/platforms/cell/spufs/inode.c |    2 -
 drivers/infiniband/hw/ipath/ipath_fs.c    |    2 -
 drivers/infiniband/hw/qib/qib_fs.c        |    2 -
 drivers/staging/smbfs/cache.c             |    2 -
 fs/configfs/inode.c                       |    2 -
 fs/dcache.c                               |   34 ++++++++----------------------
 fs/exportfs/expfs.c                       |    2 -
 fs/ncpfs/dir.c                            |    2 -
 fs/ocfs2/dcache.c                         |    2 -
 include/linux/dcache.h                    |   15 ++-----------
 kernel/cgroup.c                           |    2 -
 security/selinux/selinuxfs.c              |    2 -
 12 files changed, 23 insertions(+), 46 deletions(-)

Index: linux-2.6/arch/powerpc/platforms/cell/spufs/inode.c
===================================================================
--- linux-2.6.orig/arch/powerpc/platforms/cell/spufs/inode.c	2010-11-17 00:52:37.000000000 +1100
+++ linux-2.6/arch/powerpc/platforms/cell/spufs/inode.c	2010-11-17 00:52:38.000000000 +1100
@@ -161,7 +161,7 @@ static void spufs_prune_dir(struct dentr
 	list_for_each_entry_safe(dentry, tmp, &dir->d_subdirs, d_u.d_child) {
 		spin_lock(&dentry->d_lock);
 		if (!(d_unhashed(dentry)) && dentry->d_inode) {
-			dget_locked_dlock(dentry);
+			dget_dlock(dentry);
 			__d_drop(dentry);
 			spin_unlock(&dentry->d_lock);
 			simple_unlink(dir->d_inode, dentry);
Index: linux-2.6/drivers/infiniband/hw/ipath/ipath_fs.c
===================================================================
--- linux-2.6.orig/drivers/infiniband/hw/ipath/ipath_fs.c	2010-11-17 00:52:37.000000000 +1100
+++ linux-2.6/drivers/infiniband/hw/ipath/ipath_fs.c	2010-11-17 00:52:38.000000000 +1100
@@ -279,7 +279,7 @@ static int remove_file(struct dentry *pa
 
 	spin_lock(&tmp->d_lock);
 	if (!(d_unhashed(tmp) && tmp->d_inode)) {
-		dget_locked_dlock(tmp);
+		dget_dlock(tmp);
 		__d_drop(tmp);
 		spin_unlock(&tmp->d_lock);
 		simple_unlink(parent->d_inode, tmp);
Index: linux-2.6/fs/configfs/inode.c
===================================================================
--- linux-2.6.orig/fs/configfs/inode.c	2010-11-17 00:52:37.000000000 +1100
+++ linux-2.6/fs/configfs/inode.c	2010-11-17 00:52:38.000000000 +1100
@@ -252,7 +252,7 @@ void configfs_drop_dentry(struct configf
 	if (dentry) {
 		spin_lock(&dentry->d_lock);
 		if (!(d_unhashed(dentry) && dentry->d_inode)) {
-			dget_locked_dlock(dentry);
+			dget_dlock(dentry);
 			__d_drop(dentry);
 			spin_unlock(&dentry->d_lock);
 			simple_unlink(parent->d_inode, dentry);
Index: linux-2.6/fs/dcache.c
===================================================================
--- linux-2.6.orig/fs/dcache.c	2010-11-17 00:52:37.000000000 +1100
+++ linux-2.6/fs/dcache.c	2010-11-17 01:05:38.000000000 +1100
@@ -389,32 +389,17 @@ int d_invalidate(struct dentry * dentry)
 EXPORT_SYMBOL(d_invalidate);
 
 /* This must be called with d_lock held */
-static inline struct dentry * __dget_locked_dlock(struct dentry *dentry)
+static inline void __dget_dlock(struct dentry *dentry)
 {
 	dentry->d_count++;
-	dentry_lru_del(dentry);
-	return dentry;
 }
 
-/* This must be called with d_lock held */
-static inline struct dentry * __dget_locked(struct dentry *dentry)
+static inline void __dget(struct dentry *dentry)
 {
 	spin_lock(&dentry->d_lock);
-	__dget_locked_dlock(dentry);
+	__dget_dlock(dentry);
 	spin_unlock(&dentry->d_lock);
-	return dentry;
-}
-
-struct dentry * dget_locked_dlock(struct dentry *dentry)
-{
-	return __dget_locked_dlock(dentry);
-}
-
-struct dentry * dget_locked(struct dentry *dentry)
-{
-	return __dget_locked(dentry);
 }
-EXPORT_SYMBOL(dget_locked);
 
 struct dentry *dget_parent(struct dentry *dentry)
 {
@@ -495,7 +480,7 @@ static struct dentry *__d_find_alias(str
 	struct dentry *alias;
 	alias = ___d_find_alias(inode, want_discon);
 	if (alias) {
-		__dget_locked_dlock(alias);
+		__dget_dlock(alias);
 		spin_unlock(&alias->d_lock);
 	}
 	return alias;
@@ -526,7 +511,7 @@ void d_prune_aliases(struct inode *inode
 	list_for_each_entry(dentry, &inode->i_dentry, d_alias) {
 		spin_lock(&dentry->d_lock);
 		if (!dentry->d_count) {
-			__dget_locked_dlock(dentry);
+			__dget_dlock(dentry);
 			__d_drop(dentry);
 			spin_unlock(&dentry->d_lock);
 			spin_unlock(&dcache_inode_lock);
@@ -1224,7 +1209,8 @@ struct dentry *d_alloc(struct dentry * p
 		 * don't need child lock because it is not subject
 		 * to concurrency here
 		 */
-		dentry->d_parent = dget_dlock(parent);
+		__dget_dlock(parent);
+		dentry->d_parent = parent;
 		dentry->d_sb = parent->d_sb;
 		list_add(&dentry->d_u.d_child, &parent->d_subdirs);
 		spin_unlock(&parent->d_lock);
@@ -1323,7 +1309,7 @@ static struct dentry *__d_instantiate_un
 			goto next;
 		if (memcmp(qstr->name, name, len))
 			goto next;
-		dget_locked_dlock(alias);
+		__dget_dlock(alias);
 		spin_unlock(&alias->d_lock);
 		return alias;
 next:
@@ -1579,7 +1565,7 @@ struct dentry *d_add_ci(struct dentry *d
 	 * reference to it, move it in place and use it.
 	 */
 	new = list_entry(inode->i_dentry.next, struct dentry, d_alias);
-	dget_locked(new);
+	__dget(new);
 	spin_unlock(&dcache_inode_lock);
 	security_d_instantiate(found, inode);
 	d_move(new, found);
@@ -1755,7 +1741,7 @@ int d_validate(struct dentry *dentry, st
 	list_for_each_entry(child, &dparent->d_subdirs, d_u.d_child) {
 		if (dentry == child) {
 			spin_lock_nested(&dentry->d_lock, DENTRY_D_LOCK_NESTED);
-			__dget_locked_dlock(dentry);
+			__dget_dlock(dentry);
 			spin_unlock(&dentry->d_lock);
 			spin_unlock(&dparent->d_lock);
 			return 1;
Index: linux-2.6/fs/exportfs/expfs.c
===================================================================
--- linux-2.6.orig/fs/exportfs/expfs.c	2010-11-17 00:52:37.000000000 +1100
+++ linux-2.6/fs/exportfs/expfs.c	2010-11-17 00:52:38.000000000 +1100
@@ -49,7 +49,7 @@ find_acceptable_alias(struct dentry *res
 
 	spin_lock(&dcache_inode_lock);
 	list_for_each_entry(dentry, &result->d_inode->i_dentry, d_alias) {
-		dget_locked(dentry);
+		dget(dentry);
 		spin_unlock(&dcache_inode_lock);
 		if (toput)
 			dput(toput);
Index: linux-2.6/fs/ncpfs/dir.c
===================================================================
--- linux-2.6.orig/fs/ncpfs/dir.c	2010-11-17 00:52:37.000000000 +1100
+++ linux-2.6/fs/ncpfs/dir.c	2010-11-17 00:52:38.000000000 +1100
@@ -400,7 +400,7 @@ ncp_dget_fpos(struct dentry *dentry, str
 		dent = list_entry(next, struct dentry, d_u.d_child);
 		if ((unsigned long)dent->d_fsdata == fpos) {
 			if (dent->d_inode)
-				dget_locked(dent);
+				dget(dent);
 			else
 				dent = NULL;
 			spin_unlock(&parent->d_lock);
Index: linux-2.6/fs/ocfs2/dcache.c
===================================================================
--- linux-2.6.orig/fs/ocfs2/dcache.c	2010-11-17 00:52:37.000000000 +1100
+++ linux-2.6/fs/ocfs2/dcache.c	2010-11-17 00:52:38.000000000 +1100
@@ -178,7 +178,7 @@ struct dentry *ocfs2_find_local_alias(st
 			mlog(0, "dentry found: %.*s\n",
 			     dentry->d_name.len, dentry->d_name.name);
 
-			dget_locked_dlock(dentry);
+			dget_dlock(dentry);
 			spin_unlock(&dentry->d_lock);
 			break;
 		}
Index: linux-2.6/include/linux/dcache.h
===================================================================
--- linux-2.6.orig/include/linux/dcache.h	2010-11-17 00:52:37.000000000 +1100
+++ linux-2.6/include/linux/dcache.h	2010-11-17 00:52:38.000000000 +1100
@@ -317,23 +317,17 @@ extern char *dentry_path(struct dentry *
 /* Allocation counts.. */
 
 /**
- *	dget, dget_locked	-	get a reference to a dentry
+ *	dget, dget_dlock -	get a reference to a dentry
  *	@dentry: dentry to get a reference to
  *
  *	Given a dentry or %NULL pointer increment the reference count
  *	if appropriate and return the dentry. A dentry will not be 
- *	destroyed when it has references. dget() should never be
- *	called for dentries with zero reference counter. For these cases
- *	(preferably none, functions in dcache.c are sufficient for normal
- *	needs and they take necessary precautions) you should hold d_lock
- *	and call dget_dlock() instead of dget().
+ *	destroyed when it has references.
  */
 static inline struct dentry *dget_dlock(struct dentry *dentry)
 {
-	if (dentry) {
-		BUG_ON(!dentry->d_count);
+	if (dentry)
 		dentry->d_count++;
-	}
 	return dentry;
 }
 
@@ -347,9 +341,6 @@ static inline struct dentry *dget(struct
 	return dentry;
 }
 
-extern struct dentry * dget_locked(struct dentry *);
-extern struct dentry * dget_locked_dlock(struct dentry *);
-
 extern struct dentry *dget_parent(struct dentry *dentry);
 
 /**
Index: linux-2.6/kernel/cgroup.c
===================================================================
--- linux-2.6.orig/kernel/cgroup.c	2010-11-17 00:52:37.000000000 +1100
+++ linux-2.6/kernel/cgroup.c	2010-11-17 00:52:38.000000000 +1100
@@ -885,7 +885,7 @@ static void cgroup_clear_directory(struc
 			/* This should never be called on a cgroup
 			 * directory with child cgroups */
 			BUG_ON(d->d_inode->i_mode & S_IFDIR);
-			dget_locked_dlock(d);
+			dget_dlock(d);
 			spin_unlock(&d->d_lock);
 			spin_unlock(&dentry->d_lock);
 			d_delete(d);
Index: linux-2.6/security/selinux/selinuxfs.c
===================================================================
--- linux-2.6.orig/security/selinux/selinuxfs.c	2010-11-17 00:52:37.000000000 +1100
+++ linux-2.6/security/selinux/selinuxfs.c	2010-11-17 00:52:38.000000000 +1100
@@ -1154,7 +1154,7 @@ static void sel_remove_entries(struct de
 		list_del_init(node);
 
 		if (d->d_inode) {
-			dget_locked_dlock(d);
+			dget_dlock(d);
 			spin_unlock(&de->d_lock);
 			spin_unlock(&d->d_lock);
 			d_delete(d);
Index: linux-2.6/drivers/infiniband/hw/qib/qib_fs.c
===================================================================
--- linux-2.6.orig/drivers/infiniband/hw/qib/qib_fs.c	2010-11-17 00:52:37.000000000 +1100
+++ linux-2.6/drivers/infiniband/hw/qib/qib_fs.c	2010-11-17 00:52:38.000000000 +1100
@@ -455,7 +455,7 @@ static int remove_file(struct dentry *pa
 
 	spin_lock(&tmp->d_lock);
 	if (!(d_unhashed(tmp) && tmp->d_inode)) {
-		dget_locked_dlock(tmp);
+		dget_dlock(tmp);
 		__d_drop(tmp);
 		spin_unlock(&tmp->d_lock);
 		simple_unlink(parent->d_inode, tmp);
Index: linux-2.6/drivers/staging/smbfs/cache.c
===================================================================
--- linux-2.6.orig/drivers/staging/smbfs/cache.c	2010-11-17 00:52:37.000000000 +1100
+++ linux-2.6/drivers/staging/smbfs/cache.c	2010-11-17 00:52:38.000000000 +1100
@@ -102,7 +102,7 @@ smb_dget_fpos(struct dentry *dentry, str
 		dent = list_entry(next, struct dentry, d_u.d_child);
 		if ((unsigned long)dent->d_fsdata == fpos) {
 			if (dent->d_inode)
-				dget_locked(dent);
+				dget(dent);
 			else
 				dent = NULL;
 			goto out_unlock;


