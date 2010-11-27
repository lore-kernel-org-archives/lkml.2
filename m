Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753084Ab0K0K01 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Nov 2010 05:26:27 -0500
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:34785 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752824Ab0K0K0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Nov 2010 05:26:15 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAO1p8Ex5Lcx2/2dsb2JhbACjC3K9doVHBIph
Message-Id: <fc3560560f2b735d411391b6598577e31b45791e.1290852959.git.npiggin@kernel.dk>
In-Reply-To: <cover.1290852958.git.npiggin@kernel.dk>
References: <cover.1290852958.git.npiggin@kernel.dk>
From: Nick Piggin <npiggin@kernel.dk>
Date: Sat, 27 Nov 2010 20:44:54 +1100
Subject: [PATCH 24/46] fs: dcache rationalise dget variants
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
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
 arch/powerpc/platforms/cell/spufs/inode.c |    2 +-
 drivers/infiniband/hw/ipath/ipath_fs.c    |    2 +-
 drivers/infiniband/hw/qib/qib_fs.c        |    2 +-
 drivers/staging/smbfs/cache.c             |    2 +-
 fs/configfs/inode.c                       |    2 +-
 fs/dcache.c                               |   34 ++++++++--------------------
 fs/exportfs/expfs.c                       |    2 +-
 fs/ncpfs/dir.c                            |    2 +-
 fs/ocfs2/dcache.c                         |    2 +-
 include/linux/dcache.h                    |   15 ++----------
 kernel/cgroup.c                           |    2 +-
 security/selinux/selinuxfs.c              |    2 +-
 12 files changed, 23 insertions(+), 46 deletions(-)

diff --git a/arch/powerpc/platforms/cell/spufs/inode.c b/arch/powerpc/platforms/cell/spufs/inode.c
index 2662b50..03185de 100644
--- a/arch/powerpc/platforms/cell/spufs/inode.c
+++ b/arch/powerpc/platforms/cell/spufs/inode.c
@@ -161,7 +161,7 @@ static void spufs_prune_dir(struct dentry *dir)
 	list_for_each_entry_safe(dentry, tmp, &dir->d_subdirs, d_u.d_child) {
 		spin_lock(&dentry->d_lock);
 		if (!(d_unhashed(dentry)) && dentry->d_inode) {
-			dget_locked_dlock(dentry);
+			dget_dlock(dentry);
 			__d_drop(dentry);
 			spin_unlock(&dentry->d_lock);
 			simple_unlink(dir->d_inode, dentry);
diff --git a/drivers/infiniband/hw/ipath/ipath_fs.c b/drivers/infiniband/hw/ipath/ipath_fs.c
index 925e882..31ae1b1 100644
--- a/drivers/infiniband/hw/ipath/ipath_fs.c
+++ b/drivers/infiniband/hw/ipath/ipath_fs.c
@@ -279,7 +279,7 @@ static int remove_file(struct dentry *parent, char *name)
 
 	spin_lock(&tmp->d_lock);
 	if (!(d_unhashed(tmp) && tmp->d_inode)) {
-		dget_locked_dlock(tmp);
+		dget_dlock(tmp);
 		__d_drop(tmp);
 		spin_unlock(&tmp->d_lock);
 		simple_unlink(parent->d_inode, tmp);
diff --git a/drivers/infiniband/hw/qib/qib_fs.c b/drivers/infiniband/hw/qib/qib_fs.c
index 49af4a6..df7fa25 100644
--- a/drivers/infiniband/hw/qib/qib_fs.c
+++ b/drivers/infiniband/hw/qib/qib_fs.c
@@ -455,7 +455,7 @@ static int remove_file(struct dentry *parent, char *name)
 
 	spin_lock(&tmp->d_lock);
 	if (!(d_unhashed(tmp) && tmp->d_inode)) {
-		dget_locked_dlock(tmp);
+		dget_dlock(tmp);
 		__d_drop(tmp);
 		spin_unlock(&tmp->d_lock);
 		simple_unlink(parent->d_inode, tmp);
diff --git a/drivers/staging/smbfs/cache.c b/drivers/staging/smbfs/cache.c
index abae450..9a8267f 100644
--- a/drivers/staging/smbfs/cache.c
+++ b/drivers/staging/smbfs/cache.c
@@ -102,7 +102,7 @@ smb_dget_fpos(struct dentry *dentry, struct dentry *parent, unsigned long fpos)
 		dent = list_entry(next, struct dentry, d_u.d_child);
 		if ((unsigned long)dent->d_fsdata == fpos) {
 			if (dent->d_inode)
-				dget_locked(dent);
+				dget(dent);
 			else
 				dent = NULL;
 			goto out_unlock;
diff --git a/fs/configfs/inode.c b/fs/configfs/inode.c
index fb3a55f..c83f476 100644
--- a/fs/configfs/inode.c
+++ b/fs/configfs/inode.c
@@ -252,7 +252,7 @@ void configfs_drop_dentry(struct configfs_dirent * sd, struct dentry * parent)
 	if (dentry) {
 		spin_lock(&dentry->d_lock);
 		if (!(d_unhashed(dentry) && dentry->d_inode)) {
-			dget_locked_dlock(dentry);
+			dget_dlock(dentry);
 			__d_drop(dentry);
 			spin_unlock(&dentry->d_lock);
 			simple_unlink(parent->d_inode, dentry);
diff --git a/fs/dcache.c b/fs/dcache.c
index 6fe387d..9231748 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
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
@@ -495,7 +480,7 @@ static struct dentry *__d_find_alias(struct inode *inode, int want_discon)
 	struct dentry *alias;
 	alias = ___d_find_alias(inode, want_discon);
 	if (alias) {
-		__dget_locked_dlock(alias);
+		__dget_dlock(alias);
 		spin_unlock(&alias->d_lock);
 	}
 	return alias;
@@ -526,7 +511,7 @@ restart:
 	list_for_each_entry(dentry, &inode->i_dentry, d_alias) {
 		spin_lock(&dentry->d_lock);
 		if (!dentry->d_count) {
-			__dget_locked_dlock(dentry);
+			__dget_dlock(dentry);
 			__d_drop(dentry);
 			spin_unlock(&dentry->d_lock);
 			spin_unlock(&dcache_inode_lock);
@@ -1224,7 +1209,8 @@ struct dentry *d_alloc(struct dentry * parent, const struct qstr *name)
 		 * don't need child lock because it is not subject
 		 * to concurrency here
 		 */
-		dentry->d_parent = dget_dlock(parent);
+		__dget_dlock(parent);
+		dentry->d_parent = parent;
 		dentry->d_sb = parent->d_sb;
 		list_add(&dentry->d_u.d_child, &parent->d_subdirs);
 		spin_unlock(&parent->d_lock);
@@ -1323,7 +1309,7 @@ static struct dentry *__d_instantiate_unique(struct dentry *entry,
 			goto next;
 		if (memcmp(qstr->name, name, len))
 			goto next;
-		dget_locked_dlock(alias);
+		__dget_dlock(alias);
 		spin_unlock(&alias->d_lock);
 		return alias;
 next:
@@ -1579,7 +1565,7 @@ struct dentry *d_add_ci(struct dentry *dentry, struct inode *inode,
 	 * reference to it, move it in place and use it.
 	 */
 	new = list_entry(inode->i_dentry.next, struct dentry, d_alias);
-	dget_locked(new);
+	__dget(new);
 	spin_unlock(&dcache_inode_lock);
 	security_d_instantiate(found, inode);
 	d_move(new, found);
@@ -1755,7 +1741,7 @@ int d_validate(struct dentry *dentry, struct dentry *dparent)
 	list_for_each_entry(child, &dparent->d_subdirs, d_u.d_child) {
 		if (dentry == child) {
 			spin_lock_nested(&dentry->d_lock, DENTRY_D_LOCK_NESTED);
-			__dget_locked_dlock(dentry);
+			__dget_dlock(dentry);
 			spin_unlock(&dentry->d_lock);
 			spin_unlock(&dparent->d_lock);
 			return 1;
diff --git a/fs/exportfs/expfs.c b/fs/exportfs/expfs.c
index 53a5c08..f06a940 100644
--- a/fs/exportfs/expfs.c
+++ b/fs/exportfs/expfs.c
@@ -49,7 +49,7 @@ find_acceptable_alias(struct dentry *result,
 
 	spin_lock(&dcache_inode_lock);
 	list_for_each_entry(dentry, &result->d_inode->i_dentry, d_alias) {
-		dget_locked(dentry);
+		dget(dentry);
 		spin_unlock(&dcache_inode_lock);
 		if (toput)
 			dput(toput);
diff --git a/fs/ncpfs/dir.c b/fs/ncpfs/dir.c
index e6d5153..6ecc33a 100644
--- a/fs/ncpfs/dir.c
+++ b/fs/ncpfs/dir.c
@@ -399,7 +399,7 @@ ncp_dget_fpos(struct dentry *dentry, struct dentry *parent, unsigned long fpos)
 		dent = list_entry(next, struct dentry, d_u.d_child);
 		if ((unsigned long)dent->d_fsdata == fpos) {
 			if (dent->d_inode)
-				dget_locked(dent);
+				dget(dent);
 			else
 				dent = NULL;
 			spin_unlock(&parent->d_lock);
diff --git a/fs/ocfs2/dcache.c b/fs/ocfs2/dcache.c
index 76f2170..8b26b54 100644
--- a/fs/ocfs2/dcache.c
+++ b/fs/ocfs2/dcache.c
@@ -178,7 +178,7 @@ struct dentry *ocfs2_find_local_alias(struct inode *inode,
 			mlog(0, "dentry found: %.*s\n",
 			     dentry->d_name.len, dentry->d_name.name);
 
-			dget_locked_dlock(dentry);
+			dget_dlock(dentry);
 			spin_unlock(&dentry->d_lock);
 			break;
 		}
diff --git a/include/linux/dcache.h b/include/linux/dcache.h
index ab07ed8..e31fc9a 100644
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -317,23 +317,17 @@ extern char *dentry_path(struct dentry *, char *, int);
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
 
@@ -347,9 +341,6 @@ static inline struct dentry *dget(struct dentry *dentry)
 	return dentry;
 }
 
-extern struct dentry * dget_locked(struct dentry *);
-extern struct dentry * dget_locked_dlock(struct dentry *);
-
 extern struct dentry *dget_parent(struct dentry *dentry);
 
 /**
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 845dc23..6e34f75 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -885,7 +885,7 @@ static void cgroup_clear_directory(struct dentry *dentry)
 			/* This should never be called on a cgroup
 			 * directory with child cgroups */
 			BUG_ON(d->d_inode->i_mode & S_IFDIR);
-			dget_locked_dlock(d);
+			dget_dlock(d);
 			spin_unlock(&d->d_lock);
 			spin_unlock(&dentry->d_lock);
 			d_delete(d);
diff --git a/security/selinux/selinuxfs.c b/security/selinux/selinuxfs.c
index 2285d69..43deac2 100644
--- a/security/selinux/selinuxfs.c
+++ b/security/selinux/selinuxfs.c
@@ -1154,7 +1154,7 @@ static void sel_remove_entries(struct dentry *de)
 		list_del_init(node);
 
 		if (d->d_inode) {
-			dget_locked_dlock(d);
+			dget_dlock(d);
 			spin_unlock(&de->d_lock);
 			spin_unlock(&d->d_lock);
 			d_delete(d);
-- 
1.7.1

