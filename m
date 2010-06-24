Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754565Ab0FXDQc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 23:16:32 -0400
Received: from cantor.suse.de ([195.135.220.2]:48439 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754063Ab0FXDPq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 23:15:46 -0400
Message-Id: <20100624030727.667309230@suse.de>
User-Agent: quilt/0.48-4.4
Date: Thu, 24 Jun 2010 13:02:25 +1000
From: npiggin@suse.de
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: John Stultz <johnstul@us.ibm.com>, Frank Mayhar <fmayhar@google.com>
Subject: [patch 13/52] fs: dcache scale d_unhashed
References: <20100624030212.676457061@suse.de>
Content-Disposition: inline; filename=fs-dcache-scale-d_unhashed.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Protect d_unhashed(dentry) condition with d_lock.

Signed-off-by: Nick Piggin <npiggin@suse.de>
---
 arch/powerpc/platforms/cell/spufs/inode.c |    3 +
 fs/configfs/configfs_internal.h           |    2 +
 fs/dcache.c                               |   58 ++++++++++++++++++++++++------
 fs/libfs.c                                |   29 ++++++++++-----
 fs/ocfs2/dcache.c                         |    5 ++
 fs/seq_file.c                             |    3 +
 security/tomoyo/realpath.c                |    2 +
 7 files changed, 81 insertions(+), 21 deletions(-)

Index: linux-2.6/fs/libfs.c
===================================================================
--- linux-2.6.orig/fs/libfs.c
+++ linux-2.6/fs/libfs.c
@@ -16,6 +16,11 @@
 
 #include <asm/uaccess.h>
 
+static inline int simple_positive(struct dentry *dentry)
+{
+	return dentry->d_inode && !d_unhashed(dentry);
+}
+
 int simple_getattr(struct vfsmount *mnt, struct dentry *dentry,
 		   struct kstat *stat)
 {
@@ -100,8 +105,10 @@ loff_t dcache_dir_lseek(struct file *fil
 			while (n && p != &file->f_path.dentry->d_subdirs) {
 				struct dentry *next;
 				next = list_entry(p, struct dentry, d_u.d_child);
-				if (!d_unhashed(next) && next->d_inode)
+				spin_lock(&next->d_lock);
+				if (simple_positive(next))
 					n--;
+				spin_unlock(&next->d_lock);
 				p = p->next;
 			}
 			list_add_tail(&cursor->d_u.d_child, p);
@@ -155,9 +162,13 @@ int dcache_readdir(struct file * filp, v
 			for (p=q->next; p != &dentry->d_subdirs; p=p->next) {
 				struct dentry *next;
 				next = list_entry(p, struct dentry, d_u.d_child);
-				if (d_unhashed(next) || !next->d_inode)
+				spin_lock_nested(&next->d_lock, DENTRY_D_LOCK_NESTED);
+				if (!simple_positive(next)) {
+					spin_unlock(&next->d_lock);
 					continue;
+				}
 
+				spin_unlock(&next->d_lock);
 				spin_unlock(&dcache_lock);
 				if (filldir(dirent, next->d_name.name, 
 					    next->d_name.len, filp->f_pos, 
@@ -262,20 +273,20 @@ int simple_link(struct dentry *old_dentr
 	return 0;
 }
 
-static inline int simple_positive(struct dentry *dentry)
-{
-	return dentry->d_inode && !d_unhashed(dentry);
-}
-
 int simple_empty(struct dentry *dentry)
 {
 	struct dentry *child;
 	int ret = 0;
 
 	spin_lock(&dcache_lock);
-	list_for_each_entry(child, &dentry->d_subdirs, d_u.d_child)
-		if (simple_positive(child))
+	list_for_each_entry(child, &dentry->d_subdirs, d_u.d_child) {
+		spin_lock_nested(&child->d_lock, DENTRY_D_LOCK_NESTED);
+		if (simple_positive(child)) {
+			spin_unlock(&child->d_lock);
 			goto out;
+		}
+		spin_unlock(&child->d_lock);
+	}
 	ret = 1;
 out:
 	spin_unlock(&dcache_lock);
Index: linux-2.6/fs/seq_file.c
===================================================================
--- linux-2.6.orig/fs/seq_file.c
+++ linux-2.6/fs/seq_file.c
@@ -6,10 +6,13 @@
  */
 
 #include <linux/fs.h>
+#include <linux/mount.h>
 #include <linux/module.h>
 #include <linux/seq_file.h>
 #include <linux/slab.h>
 
+#include "internal.h"
+
 #include <asm/uaccess.h>
 #include <asm/page.h>
 
@@ -463,7 +466,9 @@ int seq_path_root(struct seq_file *m, st
 		char *p;
 
 		spin_lock(&dcache_lock);
+		br_read_lock(vfsmount_lock);
 		p = __d_path(path, root, buf, size);
+		br_read_unlock(vfsmount_lock);
 		spin_unlock(&dcache_lock);
 		res = PTR_ERR(p);
 		if (!IS_ERR(p)) {
Index: linux-2.6/fs/dcache.c
===================================================================
--- linux-2.6.orig/fs/dcache.c
+++ linux-2.6/fs/dcache.c
@@ -46,6 +46,7 @@
  *   - d_name
  *   - d_lru
  *   - d_count
+ *   - d_unhashed()
  *
  * Ordering:
  * dcache_lock
@@ -53,6 +54,13 @@
  *     dcache_lru_lock
  *     dcache_hash_lock
  *
+ * If there is an ancestor relationship:
+ * dentry->d_parent->...->d_parent->d_lock
+ *   ...
+ *     dentry->d_parent->d_lock
+ *       dentry->d_lock
+ *
+ * If no ancestor relationship:
  * if (dentry1 < dentry2)
  *   dentry1->d_lock
  *     dentry2->d_lock
@@ -334,7 +342,9 @@ int d_invalidate(struct dentry * dentry)
 	 * If it's already been dropped, return OK.
 	 */
 	spin_lock(&dcache_lock);
+	spin_lock(&dentry->d_lock);
 	if (d_unhashed(dentry)) {
+		spin_unlock(&dentry->d_lock);
 		spin_unlock(&dcache_lock);
 		return 0;
 	}
@@ -343,9 +353,11 @@ int d_invalidate(struct dentry * dentry)
 	 * to get rid of unused child entries.
 	 */
 	if (!list_empty(&dentry->d_subdirs)) {
+		spin_unlock(&dentry->d_lock);
 		spin_unlock(&dcache_lock);
 		shrink_dcache_parent(dentry);
 		spin_lock(&dcache_lock);
+		spin_lock(&dentry->d_lock);
 	}
 
 	/*
@@ -358,7 +370,6 @@ int d_invalidate(struct dentry * dentry)
 	 * we might still populate it if it was a
 	 * working directory or similar).
 	 */
-	spin_lock(&dentry->d_lock);
 	if (dentry->d_count > 1) {
 		if (dentry->d_inode && S_ISDIR(dentry->d_inode->i_mode)) {
 			spin_unlock(&dentry->d_lock);
@@ -457,15 +468,18 @@ static struct dentry * __d_find_alias(st
 		next = tmp->next;
 		prefetch(next);
 		alias = list_entry(tmp, struct dentry, d_alias);
+		spin_lock(&alias->d_lock);
  		if (S_ISDIR(inode->i_mode) || !d_unhashed(alias)) {
 			if (IS_ROOT(alias) &&
 			    (alias->d_flags & DCACHE_DISCONNECTED))
 				discon_alias = alias;
 			else if (!want_discon) {
-				__dget_locked(alias);
+				__dget_locked_dlock(alias);
+				spin_unlock(&alias->d_lock);
 				return alias;
 			}
 		}
+		spin_unlock(&alias->d_lock);
 	}
 	if (discon_alias)
 		__dget_locked(discon_alias);
@@ -750,8 +764,8 @@ static void shrink_dcache_for_umount_sub
 	spin_lock(&dcache_lock);
 	spin_lock(&dentry->d_lock);
 	dentry_lru_del_init(dentry);
-	spin_unlock(&dentry->d_lock);
 	__d_drop(dentry);
+	spin_unlock(&dentry->d_lock);
 	spin_unlock(&dcache_lock);
 
 	for (;;) {
@@ -766,8 +780,8 @@ static void shrink_dcache_for_umount_sub
 					    d_u.d_child) {
 				spin_lock(&loop->d_lock);
 				dentry_lru_del_init(loop);
-				spin_unlock(&loop->d_lock);
 				__d_drop(loop);
+				spin_unlock(&loop->d_lock);
 				cond_resched_lock(&dcache_lock);
 			}
 			spin_unlock(&dcache_lock);
@@ -1788,7 +1802,10 @@ static void d_move_locked(struct dentry
 	/*
 	 * XXXX: do we really need to take target->d_lock?
 	 */
-	if (target < dentry) {
+	if (d_ancestor(dentry, target)) {
+		spin_lock(&dentry->d_lock);
+		spin_lock_nested(&target->d_lock, DENTRY_D_LOCK_NESTED);
+	} else if (d_ancestor(target, dentry) || target < dentry) {
 		spin_lock(&target->d_lock);
 		spin_lock_nested(&dentry->d_lock, DENTRY_D_LOCK_NESTED);
 	} else {
@@ -2046,7 +2063,8 @@ static int prepend_name(char **buffer, i
  * Returns a pointer into the buffer or an error code if the
  * path was too long.
  *
- * "buflen" should be positive. Caller holds the dcache_lock.
+ * "buflen" should be positive. Caller holds the dcache_lock and
+ * path->dentry->d_lock.
  *
  * If path is not reachable from the supplied root, then the value of
  * root is changed (without modifying refcounts).
@@ -2059,8 +2077,9 @@ char *__d_path(const struct path *path,
 	char *end = buffer + buflen;
 	char *retval;
 
-	br_read_lock(vfsmount_lock);
 	prepend(&end, &buflen, "\0", 1);
+	spin_lock(&dentry->d_lock);
+unlinked:
 	if (d_unlinked(dentry) &&
 		(prepend(&end, &buflen, " (deleted)", 10) != 0))
 			goto Elong;
@@ -2072,7 +2091,7 @@ char *__d_path(const struct path *path,
 	*retval = '/';
 
 	for (;;) {
-		struct dentry * parent;
+		struct dentry *parent;
 
 		if (dentry == root->dentry && vfsmnt == root->mnt)
 			break;
@@ -2081,8 +2100,10 @@ char *__d_path(const struct path *path,
 			if (vfsmnt->mnt_parent == vfsmnt) {
 				goto global_root;
 			}
+			spin_unlock(&dentry->d_lock);
 			dentry = vfsmnt->mnt_mountpoint;
 			vfsmnt = vfsmnt->mnt_parent;
+			spin_lock(&dentry->d_lock); /* can't get unlinked because locked vfsmount */
 			continue;
 		}
 		parent = dentry->d_parent;
@@ -2091,11 +2112,14 @@ char *__d_path(const struct path *path,
 		    (prepend(&end, &buflen, "/", 1) != 0))
 			goto Elong;
 		retval = end;
+		spin_unlock(&dentry->d_lock);
 		dentry = parent;
+		if (d_unlinked(dentry))
+			goto unlinked;
 	}
 
 out:
-	br_read_unlock(vfsmount_lock);
+	spin_unlock(&dentry->d_lock);
 	return retval;
 
 global_root:
@@ -2147,10 +2171,14 @@ char *d_path(const struct path *path, ch
 	root = current->fs->root;
 	path_get(&root);
 	spin_unlock(&current->fs->lock);
+
 	spin_lock(&dcache_lock);
+	br_read_lock(vfsmount_lock);
 	tmp = root;
 	res = __d_path(path, &tmp, buf, buflen);
+	br_read_unlock(vfsmount_lock);
 	spin_unlock(&dcache_lock);
+
 	path_put(&root);
 	return res;
 }
@@ -2186,7 +2214,9 @@ char *dentry_path(struct dentry *dentry,
 	char *retval;
 
 	spin_lock(&dcache_lock);
+	spin_lock(&dentry->d_lock);
 	prepend(&end, &buflen, "\0", 1);
+unlinked:
 	if (d_unlinked(dentry) &&
 		(prepend(&end, &buflen, "//deleted", 9) != 0))
 			goto Elong;
@@ -2205,11 +2235,17 @@ char *dentry_path(struct dentry *dentry,
 			goto Elong;
 
 		retval = end;
+		spin_unlock(&dentry->d_lock);
 		dentry = parent;
+		spin_lock(&dentry->d_lock);
+		if (d_unlinked(dentry))
+			goto unlinked;
 	}
+	spin_unlock(&dentry->d_lock);
 	spin_unlock(&dcache_lock);
 	return retval;
 Elong:
+	spin_unlock(&dentry->d_lock);
 	spin_unlock(&dcache_lock);
 	return ERR_PTR(-ENAMETOOLONG);
 }
@@ -2250,12 +2286,17 @@ SYSCALL_DEFINE2(getcwd, char __user *, b
 
 	error = -ENOENT;
 	spin_lock(&dcache_lock);
+	br_read_lock(vfsmount_lock);
+	spin_lock(&pwd.dentry->d_lock);
 	if (!d_unlinked(pwd.dentry)) {
 		unsigned long len;
 		struct path tmp = root;
 		char * cwd;
 
+		spin_unlock(&pwd.dentry->d_lock);
+		/* XXX: race here, have to close (eg. return unlinked from __d_path) */
 		cwd = __d_path(&pwd, &tmp, page, PAGE_SIZE);
+		br_read_unlock(vfsmount_lock);
 		spin_unlock(&dcache_lock);
 
 		error = PTR_ERR(cwd);
@@ -2269,8 +2310,11 @@ SYSCALL_DEFINE2(getcwd, char __user *, b
 			if (copy_to_user(buf, cwd, len))
 				error = -EFAULT;
 		}
-	} else
+	} else {
+		spin_unlock(&pwd.dentry->d_lock);
+		br_read_unlock(vfsmount_lock);
 		spin_unlock(&dcache_lock);
+	}
 
 out:
 	path_put(&pwd);
@@ -2359,13 +2403,16 @@ resume:
 		struct list_head *tmp = next;
 		struct dentry *dentry = list_entry(tmp, struct dentry, d_u.d_child);
 		next = tmp->next;
-		if (d_unhashed(dentry)||!dentry->d_inode)
+		spin_lock_nested(&dentry->d_lock, DENTRY_D_LOCK_NESTED);
+		if (d_unhashed(dentry) || !dentry->d_inode) {
+			spin_unlock(&dentry->d_lock);
 			continue;
+		}
 		if (!list_empty(&dentry->d_subdirs)) {
+			spin_unlock(&dentry->d_lock);
 			this_parent = dentry;
 			goto repeat;
 		}
-		spin_lock(&dentry->d_lock);
 		dentry->d_count--;
 		spin_unlock(&dentry->d_lock);
 	}
Index: linux-2.6/arch/powerpc/platforms/cell/spufs/inode.c
===================================================================
--- linux-2.6.orig/arch/powerpc/platforms/cell/spufs/inode.c
+++ linux-2.6/arch/powerpc/platforms/cell/spufs/inode.c
@@ -165,6 +165,9 @@ static void spufs_prune_dir(struct dentr
 			__d_drop(dentry);
 			spin_unlock(&dentry->d_lock);
 			simple_unlink(dir->d_inode, dentry);
+			/* XXX: what is dcache_lock protecting here? Other
+			 * filesystems (IB, configfs) release dcache_lock
+			 * before unlink */
 			spin_unlock(&dcache_lock);
 			dput(dentry);
 		} else {
Index: linux-2.6/fs/configfs/configfs_internal.h
===================================================================
--- linux-2.6.orig/fs/configfs/configfs_internal.h
+++ linux-2.6/fs/configfs/configfs_internal.h
@@ -121,6 +121,7 @@ static inline struct config_item *config
 	struct config_item * item = NULL;
 
 	spin_lock(&dcache_lock);
+	spin_lock(&dentry->d_lock);
 	if (!d_unhashed(dentry)) {
 		struct configfs_dirent * sd = dentry->d_fsdata;
 		if (sd->s_type & CONFIGFS_ITEM_LINK) {
@@ -129,6 +130,7 @@ static inline struct config_item *config
 		} else
 			item = config_item_get(sd->s_element);
 	}
+	spin_unlock(&dentry->d_lock);
 	spin_unlock(&dcache_lock);
 
 	return item;
Index: linux-2.6/fs/ocfs2/dcache.c
===================================================================
--- linux-2.6.orig/fs/ocfs2/dcache.c
+++ linux-2.6/fs/ocfs2/dcache.c
@@ -156,13 +156,16 @@ struct dentry *ocfs2_find_local_alias(st
 	list_for_each(p, &inode->i_dentry) {
 		dentry = list_entry(p, struct dentry, d_alias);
 
+		spin_lock(&dentry->d_lock);
 		if (ocfs2_match_dentry(dentry, parent_blkno, skip_unhashed)) {
 			mlog(0, "dentry found: %.*s\n",
 			     dentry->d_name.len, dentry->d_name.name);
 
-			dget_locked(dentry);
+			dget_locked_dlock(dentry);
+			spin_unlock(&dentry->d_lock);
 			break;
 		}
+		spin_unlock(&dentry->d_lock);
 
 		dentry = NULL;
 	}
Index: linux-2.6/security/tomoyo/realpath.c
===================================================================
--- linux-2.6.orig/security/tomoyo/realpath.c
+++ linux-2.6/security/tomoyo/realpath.c
@@ -17,6 +17,7 @@
 #include <linux/magic.h>
 #include <linux/slab.h>
 #include "common.h"
+#include "../../fs/internal.h"
 
 /**
  * tomoyo_encode: Convert binary string to ascii string.
@@ -92,8 +93,10 @@ int tomoyo_realpath_from_path2(struct pa
 		struct path ns_root = {.mnt = NULL, .dentry = NULL};
 
 		spin_lock(&dcache_lock);
+		br_read_lock(vfsmount_lock);
 		/* go to whatever namespace root we are under */
 		sp = __d_path(path, &ns_root, newname, newname_len);
+		br_read_unlock(vfsmount_lock);
 		spin_unlock(&dcache_lock);
 		/* Prepend "/proc" prefix if using internal proc vfs mount. */
 		if (!IS_ERR(sp) && (path->mnt->mnt_flags & MNT_INTERNAL) &&
Index: linux-2.6/drivers/usb/core/inode.c
===================================================================
--- linux-2.6.orig/drivers/usb/core/inode.c
+++ linux-2.6/drivers/usb/core/inode.c
@@ -351,10 +351,13 @@ static int usbfs_empty (struct dentry *d
 
 	list_for_each(list, &dentry->d_subdirs) {
 		struct dentry *de = list_entry(list, struct dentry, d_u.d_child);
+		spin_lock(&de->d_lock);
 		if (usbfs_positive(de)) {
+			spin_unlock(&de->d_lock);
 			spin_unlock(&dcache_lock);
 			return 0;
 		}
+		spin_unlock(&de->d_lock);
 	}
 
 	spin_unlock(&dcache_lock);
Index: linux-2.6/fs/ceph/dir.c
===================================================================
--- linux-2.6.orig/fs/ceph/dir.c
+++ linux-2.6/fs/ceph/dir.c
@@ -135,6 +135,7 @@ more:
 			fi->at_end = 1;
 			goto out_unlock;
 		}
+		spin_lock(&dentry->d_lock);
 		if (!d_unhashed(dentry) && dentry->d_inode &&
 		    ceph_snap(dentry->d_inode) != CEPH_SNAPDIR &&
 		    ceph_ino(dentry->d_inode) != CEPH_INO_CEPH &&
@@ -144,13 +145,13 @@ more:
 		     dentry->d_name.len, dentry->d_name.name, di->offset,
 		     filp->f_pos, d_unhashed(dentry) ? " unhashed" : "",
 		     !dentry->d_inode ? " null" : "");
+		spin_unlock(&dentry->d_lock);
 		p = p->prev;
 		dentry = list_entry(p, struct dentry, d_u.d_child);
 		di = ceph_dentry(dentry);
 	}
 
-	spin_lock(&dentry->d_lock);
-	dentry->d_count++;
+	dget_dlock(dentry);
 	spin_unlock(&dentry->d_lock);
 	spin_unlock(&dcache_lock);
 	spin_unlock(&inode->i_lock);


