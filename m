Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754607Ab0FXDQg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 23:16:36 -0400
Received: from cantor.suse.de ([195.135.220.2]:48447 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754144Ab0FXDPr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 23:15:47 -0400
Message-Id: <20100624030729.071474440@suse.de>
User-Agent: quilt/0.48-4.4
Date: Thu, 24 Jun 2010 13:02:34 +1000
From: npiggin@suse.de
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: John Stultz <johnstul@us.ibm.com>, Frank Mayhar <fmayhar@google.com>
Subject: [patch 22/52] fs: dcache rationalise dget variants
References: <20100624030212.676457061@suse.de>
Content-Disposition: inline; filename=dcache-rationalize-dget.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dget_locked was a shortcut to avoid the lazy lru manipulation when we
already held dcache_lock (lru manipulation was relatively cheap at that
point). However, how that the lru lock is an innermost one, we never
hold it at any caller, so the lock cost can now be avoided. We already
have well working lazy dcache LRU, so it should be fine to defer LRU
manipulations to scan time.

Signed-off-by: Nick Piggin <npiggin@suse.de>
---
 arch/powerpc/platforms/cell/spufs/inode.c |    2 -
 drivers/infiniband/hw/ipath/ipath_fs.c    |    2 -
 fs/autofs4/root.c                         |    4 +--
 fs/configfs/inode.c                       |    2 -
 fs/dcache.c                               |   34 ++++++++----------------------
 fs/exportfs/expfs.c                       |    2 -
 fs/ncpfs/dir.c                            |    2 -
 fs/ocfs2/dcache.c                         |    2 -
 fs/smbfs/cache.c                          |    2 -
 fs/sysfs/dir.c                            |    2 -
 include/linux/dcache.h                    |   15 ++-----------
 kernel/cgroup.c                           |    2 -
 security/selinux/selinuxfs.c              |    2 -
 13 files changed, 25 insertions(+), 48 deletions(-)

Index: linux-2.6/arch/powerpc/platforms/cell/spufs/inode.c
===================================================================
--- linux-2.6.orig/arch/powerpc/platforms/cell/spufs/inode.c
+++ linux-2.6/arch/powerpc/platforms/cell/spufs/inode.c
@@ -160,7 +160,7 @@ static void spufs_prune_dir(struct dentr
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
--- linux-2.6.orig/drivers/infiniband/hw/ipath/ipath_fs.c
+++ linux-2.6/drivers/infiniband/hw/ipath/ipath_fs.c
@@ -275,7 +275,7 @@ static int remove_file(struct dentry *pa
 
 	spin_lock(&tmp->d_lock);
 	if (!(d_unhashed(tmp) && tmp->d_inode)) {
-		dget_locked_dlock(tmp);
+		dget_dlock(tmp);
 		__d_drop(tmp);
 		spin_unlock(&tmp->d_lock);
 		simple_unlink(parent->d_inode, tmp);
Index: linux-2.6/fs/configfs/inode.c
===================================================================
--- linux-2.6.orig/fs/configfs/inode.c
+++ linux-2.6/fs/configfs/inode.c
@@ -251,7 +251,7 @@ void configfs_drop_dentry(struct configf
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
--- linux-2.6.orig/fs/dcache.c
+++ linux-2.6/fs/dcache.c
@@ -287,29 +287,23 @@ void d_drop(struct dentry *dentry)
 EXPORT_SYMBOL(d_drop);
 
 /* This must be called with d_lock held */
-static inline struct dentry * __dget_locked_dlock(struct dentry *dentry)
+static inline struct dentry *__dget_dlock(struct dentry *dentry)
 {
 	dentry->d_count++;
-	dentry_lru_del_init(dentry);
 	return dentry;
 }
 
-static inline struct dentry * __dget_locked(struct dentry *dentry)
+static inline struct dentry *__dget(struct dentry *dentry)
 {
 	spin_lock(&dentry->d_lock);
-	__dget_locked_dlock(dentry);
+	__dget_dlock(dentry);
 	spin_unlock(&dentry->d_lock);
 	return dentry;
 }
 
-struct dentry * dget_locked_dlock(struct dentry *dentry)
-{
-	return __dget_locked_dlock(dentry);
-}
-
 struct dentry * dget_locked(struct dentry *dentry)
 {
-	return __dget_locked(dentry);
+	return __dget(dentry);
 }
 EXPORT_SYMBOL(dget_locked);
 
@@ -534,7 +528,7 @@ static struct dentry * __d_find_alias(st
 			    (alias->d_flags & DCACHE_DISCONNECTED))
 				discon_alias = alias;
 			else if (!want_discon) {
-				__dget_locked_dlock(alias);
+				__dget_dlock(alias);
 				spin_unlock(&alias->d_lock);
 				return alias;
 			}
@@ -542,7 +536,7 @@ static struct dentry * __d_find_alias(st
 		spin_unlock(&alias->d_lock);
 	}
 	if (discon_alias)
-		__dget_locked(discon_alias);
+		__dget(discon_alias);
 	return discon_alias;
 }
 
@@ -571,7 +565,7 @@ restart:
 	list_for_each_entry(dentry, &inode->i_dentry, d_alias) {
 		spin_lock(&dentry->d_lock);
 		if (!dentry->d_count) {
-			__dget_locked_dlock(dentry);
+			__dget_dlock(dentry);
 			__d_drop(dentry);
 			spin_unlock(&dentry->d_lock);
 			spin_unlock(&inode->i_lock);
@@ -1349,7 +1343,7 @@ static struct dentry *__d_instantiate_un
 			continue;
 		if (memcmp(qstr->name, name, len))
 			continue;
-		dget_locked(alias);
+		dget(alias);
 		return alias;
 	}
 
@@ -1593,7 +1587,7 @@ struct dentry *d_add_ci(struct dentry *d
 	 * reference to it, move it in place and use it.
 	 */
 	new = list_entry(inode->i_dentry.next, struct dentry, d_alias);
-	dget_locked(new);
+	dget(new);
 	spin_unlock(&inode->i_lock);
 	security_d_instantiate(found, inode);
 	d_move(new, found);
@@ -1629,8 +1623,7 @@ EXPORT_SYMBOL(d_add_ci);
  *
  * The dentry unused LRU is not updated even if lookup finds the required dentry
  * in there. It is updated in places such as prune_dcache, shrink_dcache_sb,
- * select_parent and __dget_locked. This laziness saves lookup from LRU lock
- * acquisition.
+ * select_parent. This laziness saves lookup from LRU lock acquisition.
  *
  * d_lookup() is protected against the concurrent renames in some unrelated
  * directory using the seqlockt_t rename_lock.
@@ -1767,7 +1760,7 @@ int d_validate(struct dentry *dentry, st
 	hlist_bl_for_each_entry_rcu(lhp, node, &b->head, d_hash) {
 		if (dentry == lhp) {
 			rcu_read_unlock();
-			__dget_locked_dlock(dentry);
+			__dget_dlock(dentry);
 			spin_unlock(&dentry->d_lock);
 			return 1;
 		}
Index: linux-2.6/fs/exportfs/expfs.c
===================================================================
--- linux-2.6.orig/fs/exportfs/expfs.c
+++ linux-2.6/fs/exportfs/expfs.c
@@ -51,7 +51,7 @@ find_acceptable_alias(struct dentry *res
 	inode = result->d_inode;
 	spin_lock(&inode->i_lock);
 	list_for_each_entry(dentry, &inode->i_dentry, d_alias) {
-		dget_locked(dentry);
+		dget(dentry);
 		spin_unlock(&inode->i_lock);
 		if (toput)
 			dput(toput);
Index: linux-2.6/fs/ncpfs/dir.c
===================================================================
--- linux-2.6.orig/fs/ncpfs/dir.c
+++ linux-2.6/fs/ncpfs/dir.c
@@ -370,7 +370,7 @@ ncp_dget_fpos(struct dentry *dentry, str
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
--- linux-2.6.orig/fs/ocfs2/dcache.c
+++ linux-2.6/fs/ocfs2/dcache.c
@@ -160,7 +160,7 @@ struct dentry *ocfs2_find_local_alias(st
 			mlog(0, "dentry found: %.*s\n",
 			     dentry->d_name.len, dentry->d_name.name);
 
-			dget_locked_dlock(dentry);
+			dget_dlock(dentry);
 			spin_unlock(&dentry->d_lock);
 			break;
 		}
Index: linux-2.6/fs/smbfs/cache.c
===================================================================
--- linux-2.6.orig/fs/smbfs/cache.c
+++ linux-2.6/fs/smbfs/cache.c
@@ -102,7 +102,7 @@ smb_dget_fpos(struct dentry *dentry, str
 		dent = list_entry(next, struct dentry, d_u.d_child);
 		if ((unsigned long)dent->d_fsdata == fpos) {
 			if (dent->d_inode)
-				dget_locked(dent);
+				dget(dent);
 			else
 				dent = NULL;
 			goto out_unlock;
Index: linux-2.6/include/linux/dcache.h
===================================================================
--- linux-2.6.orig/include/linux/dcache.h
+++ linux-2.6/include/linux/dcache.h
@@ -306,23 +306,17 @@ extern char *dentry_path(struct dentry *
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
- *	needs and they take necessary precautions) you should hold dcache_lock
- *	and call dget_locked() instead of dget().
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
 
@@ -336,9 +330,6 @@ static inline struct dentry *dget(struct
 	return dentry;
 }
 
-extern struct dentry * dget_locked(struct dentry *);
-extern struct dentry * dget_locked_dlock(struct dentry *);
-
 extern struct dentry *dget_parent(struct dentry *dentry);
 
 /**
Index: linux-2.6/kernel/cgroup.c
===================================================================
--- linux-2.6.orig/kernel/cgroup.c
+++ linux-2.6/kernel/cgroup.c
@@ -880,7 +880,7 @@ static void cgroup_clear_directory(struc
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
--- linux-2.6.orig/security/selinux/selinuxfs.c
+++ linux-2.6/security/selinux/selinuxfs.c
@@ -950,7 +950,7 @@ static void sel_remove_entries(struct de
 		list_del_init(node);
 
 		if (d->d_inode) {
-			dget_locked_dlock(d);
+			dget_dlock(d);
 			spin_unlock(&de->d_lock);
 			spin_unlock(&d->d_lock);
 			d_delete(d);
Index: linux-2.6/drivers/infiniband/hw/qib/qib_fs.c
===================================================================
--- linux-2.6.orig/drivers/infiniband/hw/qib/qib_fs.c
+++ linux-2.6/drivers/infiniband/hw/qib/qib_fs.c
@@ -453,7 +453,7 @@ static int remove_file(struct dentry *pa
 
 	spin_lock(&tmp->d_lock);
 	if (!(d_unhashed(tmp) && tmp->d_inode)) {
-		dget_locked_dlock(tmp);
+		dget_dlock(tmp);
 		__d_drop(tmp);
 		spin_unlock(&tmp->d_lock);
 		simple_unlink(parent->d_inode, tmp);


