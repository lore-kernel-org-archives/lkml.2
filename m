Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933089Ab0KPO0Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 09:26:24 -0500
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:32788 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758165Ab0KPOXy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 09:23:54 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AiQJAKMh4kx5Ldur/2dsb2JhbACVYYx9cr5mhUsEiliFEA
Message-Id: <20101116142029.433551838@kernel.dk>
User-Agent: quilt/0.48-1
Date: Wed, 17 Nov 2010 01:09:13 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [patch 13/28] fs: dcache scale d_unhashed
References: <20101116140900.039761100@kernel.dk>
Content-Disposition: inline; filename=fs-dcache-scale-d_unhashed.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Protect d_unhashed(dentry) condition with d_lock.

Signed-off-by: Nick Piggin <npiggin@kernel.dk>

---
 arch/powerpc/platforms/cell/spufs/inode.c |    3 +
 drivers/usb/core/inode.c                  |    3 +
 fs/autofs4/autofs_i.h                     |   13 ----
 fs/autofs4/expire.c                       |   21 +++++--
 fs/ceph/dir.c                             |    5 +
 fs/configfs/configfs_internal.h           |    2 
 fs/dcache.c                               |   83 ++++++++++++++++++++----------
 fs/libfs.c                                |   29 +++++++---
 fs/ocfs2/dcache.c                         |    5 +
 security/tomoyo/realpath.c                |    1 
 10 files changed, 109 insertions(+), 56 deletions(-)

Index: linux-2.6/fs/libfs.c
===================================================================
--- linux-2.6.orig/fs/libfs.c	2010-11-17 00:52:37.000000000 +1100
+++ linux-2.6/fs/libfs.c	2010-11-17 01:05:45.000000000 +1100
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
@@ -259,20 +270,20 @@ int simple_link(struct dentry *old_dentr
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
Index: linux-2.6/fs/dcache.c
===================================================================
--- linux-2.6.orig/fs/dcache.c	2010-11-17 00:52:37.000000000 +1100
+++ linux-2.6/fs/dcache.c	2010-11-17 01:05:45.000000000 +1100
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
@@ -337,7 +345,9 @@ int d_invalidate(struct dentry * dentry)
 	 * If it's already been dropped, return OK.
 	 */
 	spin_lock(&dcache_lock);
+	spin_lock(&dentry->d_lock);
 	if (d_unhashed(dentry)) {
+		spin_unlock(&dentry->d_lock);
 		spin_unlock(&dcache_lock);
 		return 0;
 	}
@@ -346,9 +356,11 @@ int d_invalidate(struct dentry * dentry)
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
@@ -361,7 +373,6 @@ int d_invalidate(struct dentry * dentry)
 	 * we might still populate it if it was a
 	 * working directory or similar).
 	 */
-	spin_lock(&dentry->d_lock);
 	if (dentry->d_count > 1) {
 		if (dentry->d_inode && S_ISDIR(dentry->d_inode->i_mode)) {
 			spin_unlock(&dentry->d_lock);
@@ -448,35 +459,49 @@ EXPORT_SYMBOL(dget_parent);
  * any other hashed alias over that one unless @want_discon is set,
  * in which case only return an IS_ROOT, DCACHE_DISCONNECTED alias.
  */
-
-static struct dentry * __d_find_alias(struct inode *inode, int want_discon)
+static struct dentry *___d_find_alias(struct inode *inode, int want_discon)
 {
-	struct list_head *head, *next, *tmp;
-	struct dentry *alias, *discon_alias=NULL;
+	struct dentry *alias, *discon_alias;
 
-	head = &inode->i_dentry;
-	next = inode->i_dentry.next;
-	while (next != head) {
-		tmp = next;
-		next = tmp->next;
-		prefetch(next);
-		alias = list_entry(tmp, struct dentry, d_alias);
+again:
+	discon_alias = NULL;
+	list_for_each_entry(alias, &inode->i_dentry, d_alias) {
+		spin_lock(&alias->d_lock);
  		if (S_ISDIR(inode->i_mode) || !d_unhashed(alias)) {
 			if (IS_ROOT(alias) &&
 			    (alias->d_flags & DCACHE_DISCONNECTED))
 				discon_alias = alias;
-			else if (!want_discon) {
-				__dget_locked(alias);
+			else if (!want_discon)
 				return alias;
-			}
 		}
+		spin_unlock(&alias->d_lock);
 	}
-	if (discon_alias)
-		__dget_locked(discon_alias);
-	return discon_alias;
+	if (discon_alias) {
+		alias = discon_alias;
+		spin_lock(&alias->d_lock);
+ 		if (S_ISDIR(inode->i_mode) || !d_unhashed(alias)) {
+			if (IS_ROOT(alias) &&
+			    (alias->d_flags & DCACHE_DISCONNECTED))
+				return alias;
+		}
+		spin_unlock(&alias->d_lock);
+		goto again;
+	}
+	return NULL;
 }
 
-struct dentry * d_find_alias(struct inode *inode)
+static struct dentry *__d_find_alias(struct inode *inode, int want_discon)
+{
+	struct dentry *alias;
+	alias = ___d_find_alias(inode, want_discon);
+	if (alias) {
+		__dget_locked_dlock(alias);
+		spin_unlock(&alias->d_lock);
+	}
+	return alias;
+}
+
+struct dentry *d_find_alias(struct inode *inode)
 {
 	struct dentry *de = NULL;
 
@@ -759,8 +784,8 @@ static void shrink_dcache_for_umount_sub
 	spin_lock(&dcache_lock);
 	spin_lock(&dentry->d_lock);
 	dentry_lru_del(dentry);
-	spin_unlock(&dentry->d_lock);
 	__d_drop(dentry);
+	spin_unlock(&dentry->d_lock);
 	spin_unlock(&dcache_lock);
 
 	for (;;) {
@@ -775,8 +800,8 @@ static void shrink_dcache_for_umount_sub
 					    d_u.d_child) {
 				spin_lock(&loop->d_lock);
 				dentry_lru_del(loop);
-				spin_unlock(&loop->d_lock);
 				__d_drop(loop);
+				spin_unlock(&loop->d_lock);
 				cond_resched_lock(&dcache_lock);
 			}
 			spin_unlock(&dcache_lock);
@@ -1797,7 +1822,10 @@ static void d_move_locked(struct dentry
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
@@ -2476,15 +2504,18 @@ void d_genocide(struct dentry *root)
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
-		dentry->d_count--;
-		spin_unlock(&dentry->d_lock);
+ 		dentry->d_count--;
+ 		spin_unlock(&dentry->d_lock);
 	}
 	if (this_parent != root) {
 		next = this_parent->d_u.d_child.next;
Index: linux-2.6/arch/powerpc/platforms/cell/spufs/inode.c
===================================================================
--- linux-2.6.orig/arch/powerpc/platforms/cell/spufs/inode.c	2010-11-17 00:52:37.000000000 +1100
+++ linux-2.6/arch/powerpc/platforms/cell/spufs/inode.c	2010-11-17 01:05:42.000000000 +1100
@@ -166,6 +166,9 @@ static void spufs_prune_dir(struct dentr
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
--- linux-2.6.orig/fs/configfs/configfs_internal.h	2010-11-17 00:50:50.000000000 +1100
+++ linux-2.6/fs/configfs/configfs_internal.h	2010-11-17 01:05:42.000000000 +1100
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
--- linux-2.6.orig/fs/ocfs2/dcache.c	2010-11-17 00:50:50.000000000 +1100
+++ linux-2.6/fs/ocfs2/dcache.c	2010-11-17 01:05:44.000000000 +1100
@@ -174,13 +174,16 @@ struct dentry *ocfs2_find_local_alias(st
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
--- linux-2.6.orig/security/tomoyo/realpath.c	2010-11-17 00:50:50.000000000 +1100
+++ linux-2.6/security/tomoyo/realpath.c	2010-11-17 00:52:37.000000000 +1100
@@ -14,6 +14,7 @@
 #include <linux/slab.h>
 #include <net/sock.h>
 #include "common.h"
+#include "../../fs/internal.h"
 
 /**
  * tomoyo_encode: Convert binary string to ascii string.
Index: linux-2.6/drivers/usb/core/inode.c
===================================================================
--- linux-2.6.orig/drivers/usb/core/inode.c	2010-11-17 00:50:50.000000000 +1100
+++ linux-2.6/drivers/usb/core/inode.c	2010-11-17 01:05:44.000000000 +1100
@@ -348,10 +348,13 @@ static int usbfs_empty (struct dentry *d
 
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
--- linux-2.6.orig/fs/ceph/dir.c	2010-11-17 00:52:37.000000000 +1100
+++ linux-2.6/fs/ceph/dir.c	2010-11-17 01:05:45.000000000 +1100
@@ -135,6 +135,7 @@ static int __dcache_readdir(struct file
 			fi->at_end = 1;
 			goto out_unlock;
 		}
+		spin_lock(&dentry->d_lock);
 		if (!d_unhashed(dentry) && dentry->d_inode &&
 		    ceph_snap(dentry->d_inode) != CEPH_SNAPDIR &&
 		    ceph_ino(dentry->d_inode) != CEPH_INO_CEPH &&
@@ -144,13 +145,13 @@ static int __dcache_readdir(struct file
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
 
Index: linux-2.6/fs/autofs4/autofs_i.h
===================================================================
--- linux-2.6.orig/fs/autofs4/autofs_i.h	2010-11-17 00:50:50.000000000 +1100
+++ linux-2.6/fs/autofs4/autofs_i.h	2010-11-17 01:05:45.000000000 +1100
@@ -254,19 +254,6 @@ static inline int simple_positive(struct
 	return dentry->d_inode && !d_unhashed(dentry);
 }
 
-static inline int __simple_empty(struct dentry *dentry)
-{
-	struct dentry *child;
-	int ret = 0;
-
-	list_for_each_entry(child, &dentry->d_subdirs, d_u.d_child)
-		if (simple_positive(child))
-			goto out;
-	ret = 1;
-out:
-	return ret;
-}
-
 static inline void autofs4_add_expiring(struct dentry *dentry)
 {
 	struct autofs_sb_info *sbi = autofs4_sbi(dentry->d_sb);
Index: linux-2.6/fs/autofs4/expire.c
===================================================================
--- linux-2.6.orig/fs/autofs4/expire.c	2010-11-17 00:52:37.000000000 +1100
+++ linux-2.6/fs/autofs4/expire.c	2010-11-17 01:05:45.000000000 +1100
@@ -160,14 +160,18 @@ static int autofs4_tree_busy(struct vfsm
 
 	spin_lock(&dcache_lock);
 	for (p = top; p; p = next_dentry(p, top)) {
+		spin_lock(&p->d_lock);
 		/* Negative dentry - give up */
-		if (!simple_positive(p))
+		if (!simple_positive(p)) {
+			spin_unlock(&p->d_lock);
 			continue;
+		}
 
 		DPRINTK("dentry %p %.*s",
 			p, (int) p->d_name.len, p->d_name.name);
 
-		p = dget(p);
+		p = dget_dlock(p);
+		spin_unlock(&p->d_lock);
 		spin_unlock(&dcache_lock);
 
 		/*
@@ -228,14 +232,18 @@ static struct dentry *autofs4_check_leav
 
 	spin_lock(&dcache_lock);
 	for (p = parent; p; p = next_dentry(p, parent)) {
+		spin_lock(&p->d_lock);
 		/* Negative dentry - give up */
-		if (!simple_positive(p))
+		if (!simple_positive(p)) {
+			spin_unlock(&p->d_lock);
 			continue;
+		}
 
 		DPRINTK("dentry %p %.*s",
 			p, (int) p->d_name.len, p->d_name.name);
 
-		p = dget(p);
+		p = dget_dlock(p);
+		spin_unlock(&p->d_lock);
 		spin_unlock(&dcache_lock);
 
 		if (d_mountpoint(p)) {
@@ -324,12 +332,15 @@ struct dentry *autofs4_expire_indirect(s
 		struct dentry *dentry = list_entry(next, struct dentry, d_u.d_child);
 
 		/* Negative dentry - give up */
+		spin_lock(&dentry->d_lock);
 		if (!simple_positive(dentry)) {
 			next = next->next;
+			spin_unlock(&dentry->d_lock);
 			continue;
 		}
 
-		dentry = dget(dentry);
+		dentry = dget_dlock(dentry);
+		spin_unlock(&dentry->d_lock);
 		spin_unlock(&dcache_lock);
 
 		spin_lock(&sbi->fs_lock);


