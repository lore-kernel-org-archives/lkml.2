Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757966Ab0DOXHo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 19:07:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55894 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932283Ab0DOXHC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 19:07:02 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Valerie Aurora <vaurora@redhat.com>, Jan Blunck <jblunck@suse.de>
Subject: [PATCH 21/35] union-mount: Support for mounting union mount file systems
Date: Thu, 15 Apr 2010 16:04:28 -0700
Message-Id: <1271372682-21225-22-git-send-email-vaurora@redhat.com>
In-Reply-To: <1271372682-21225-21-git-send-email-vaurora@redhat.com>
References: <1271372682-21225-1-git-send-email-vaurora@redhat.com>
 <1271372682-21225-2-git-send-email-vaurora@redhat.com>
 <1271372682-21225-3-git-send-email-vaurora@redhat.com>
 <1271372682-21225-4-git-send-email-vaurora@redhat.com>
 <1271372682-21225-5-git-send-email-vaurora@redhat.com>
 <1271372682-21225-6-git-send-email-vaurora@redhat.com>
 <1271372682-21225-7-git-send-email-vaurora@redhat.com>
 <1271372682-21225-8-git-send-email-vaurora@redhat.com>
 <1271372682-21225-9-git-send-email-vaurora@redhat.com>
 <1271372682-21225-10-git-send-email-vaurora@redhat.com>
 <1271372682-21225-11-git-send-email-vaurora@redhat.com>
 <1271372682-21225-12-git-send-email-vaurora@redhat.com>
 <1271372682-21225-13-git-send-email-vaurora@redhat.com>
 <1271372682-21225-14-git-send-email-vaurora@redhat.com>
 <1271372682-21225-15-git-send-email-vaurora@redhat.com>
 <1271372682-21225-16-git-send-email-vaurora@redhat.com>
 <1271372682-21225-17-git-send-email-vaurora@redhat.com>
 <1271372682-21225-18-git-send-email-vaurora@redhat.com>
 <1271372682-21225-19-git-send-email-vaurora@redhat.com>
 <1271372682-21225-20-git-send-email-vaurora@redhat.com>
 <1271372682-21225-21-git-send-email-vaurora@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Create and tear down union mount structures on mount.  Check
requirements for union mounts.

Thanks to Felix Fietkau <nbd@openwrt.org> for a bug fix.

Signed-off-by: Jan Blunck <jblunck@suse.de>
Signed-off-by: Valerie Aurora <vaurora@redhat.com>
---
 fs/namespace.c        |  130 ++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/union.c            |   63 ++++++++++++++++++++++++
 include/linux/union.h |    4 ++
 3 files changed, 196 insertions(+), 1 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 5e4b27b..e19a432 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -29,6 +29,7 @@
 #include <linux/log2.h>
 #include <linux/idr.h>
 #include <linux/fs_struct.h>
+#include <linux/union.h>
 #include <asm/uaccess.h>
 #include <asm/unistd.h>
 #include "pnode.h"
@@ -157,6 +158,9 @@ struct vfsmount *alloc_vfsmnt(const char *name)
 #else
 		mnt->mnt_writers = 0;
 #endif
+#ifdef CONFIG_UNION_MOUNT
+		INIT_LIST_HEAD(&mnt->mnt_unions);
+#endif
 	}
 	return mnt;
 
@@ -492,6 +496,7 @@ static void __touch_mnt_namespace(struct mnt_namespace *ns)
 
 static void detach_mnt(struct vfsmount *mnt, struct path *old_path)
 {
+	detach_mnt_union(mnt);
 	old_path->dentry = mnt->mnt_mountpoint;
 	old_path->mnt = mnt->mnt_parent;
 	mnt->mnt_parent = mnt;
@@ -515,6 +520,7 @@ static void attach_mnt(struct vfsmount *mnt, struct path *path)
 	list_add_tail(&mnt->mnt_hash, mount_hashtable +
 			hash(path->mnt, path->dentry));
 	list_add_tail(&mnt->mnt_child, &path->mnt->mnt_mounts);
+	attach_mnt_union(mnt, path->mnt);
 }
 
 /*
@@ -537,6 +543,7 @@ static void commit_tree(struct vfsmount *mnt)
 	list_add_tail(&mnt->mnt_hash, mount_hashtable +
 				hash(parent, mnt->mnt_mountpoint));
 	list_add_tail(&mnt->mnt_child, &parent->mnt_mounts);
+	attach_mnt_union(mnt, parent);
 	touch_mnt_namespace(n);
 }
 
@@ -1025,6 +1032,7 @@ void release_mounts(struct list_head *head)
 			struct dentry *dentry;
 			struct vfsmount *m;
 			spin_lock(&vfsmount_lock);
+			detach_mnt_union(mnt);
 			dentry = mnt->mnt_mountpoint;
 			m = mnt->mnt_parent;
 			mnt->mnt_mountpoint = mnt->mnt_root;
@@ -1139,6 +1147,12 @@ static int do_umount(struct vfsmount *mnt, int flags)
 		if (!list_empty(&mnt->mnt_list))
 			umount_tree(mnt, 1, &umount_list);
 		retval = 0;
+		/*
+		 * If this was a union mount, we are no longer a
+		 * read-only user on the underlying mount.
+		 */
+		if (mnt->mnt_flags & MNT_UNION)
+			dec_hard_readonly_users(mnt->mnt_parent);
 	}
 	spin_unlock(&vfsmount_lock);
 	if (retval)
@@ -1490,6 +1504,17 @@ static int do_change_type(struct path *path, int flag)
 		return -EINVAL;
 
 	down_write(&namespace_sem);
+
+	/*
+	 * Mounts of file systems with read-only users can't deal with
+	 * mount/umount propagation events - it's the moral equivalent
+	 * of rm -rf dir/ or the like.
+	 */
+	if (sb_is_hard_readonly(mnt->mnt_sb)) {
+		err = -EROFS;
+		goto out_unlock;
+	}
+
 	if (type == MS_SHARED) {
 		err = invent_group_ids(mnt, recurse);
 		if (err)
@@ -1507,6 +1532,77 @@ static int do_change_type(struct path *path, int flag)
 }
 
 /*
+ * Mount-time check of upper and lower layer file systems to see if we
+ * can union mount one on the other.
+ *
+ * Note on union mounts and mount event propagation: The lower
+ * layer(s) of a union mount must not have any changes to its
+ * namespace.  Therefore, it must not be part of any mount event
+ * propagation group - i.e., shared or slave.  MNT_SHARED and
+ * MNT_SLAVE are not set at mount, but in do_change_type(), which
+ * prevents setting these flags on file systems with read-only users,
+ * which includes the lower layer(s) of a union mount.
+ */
+
+static int
+check_union_mnt(struct path *mntpnt, struct vfsmount *topmost_mnt, int mnt_flags)
+{
+	struct vfsmount *lower_mnt = mntpnt->mnt;
+
+	if (!(mnt_flags & MNT_UNION))
+		return 0;
+
+#ifndef CONFIG_UNION_MOUNT
+	return -EINVAL;
+#endif
+	/*
+	 * We can't deal with namespace changes in the lower layers of
+	 * a union, so the lower layer must be read-only.  Note that
+	 * we could possibly convert a read-write unioned mount into a
+	 * read-only mount here, which would give us a way to union
+	 * more than one layer with separate mount commands.  But
+	 * first we have to solve the locking order problems with more
+	 * than two layers of union.
+	 */
+	if (!(lower_mnt->mnt_sb->s_flags & MS_RDONLY))
+		return -EBUSY;
+
+	/*
+	 * WRITEME: For simplicity, the lower layer can't have
+	 * submounts.  If there's a good reason, we could recursively
+	 * check the whole subtree for read-only-ness, etc. and it
+	 * would probably work fine.
+	 */
+	if (!list_empty(&lower_mnt->mnt_mounts))
+		return -EBUSY;
+
+	/*
+	 * Only permit unioning of file systems at their root
+	 * directories.  This allows us to mark entire mounts as
+	 * unioned.  Otherwise we must slowly and expensively work our
+	 * way up a path looking for a unioned directory before we
+	 * know if a path is from a unioned lower layer.
+	 */
+
+	if (!IS_ROOT(mntpnt->dentry))
+		return -EINVAL;
+
+	/*
+	 * Topmost layer must be writable to support our readdir()
+	 * solution of copying up all lower level entries to the
+	 * topmost layer.
+	 */
+	if (mnt_flags & MNT_READONLY)
+		return -EROFS;
+
+	/* Topmost file system must support whiteouts and fallthrus. */
+	if (!(topmost_mnt->mnt_sb->s_flags & MS_WHITEOUT))
+		return -EINVAL;
+
+	return 0;
+}
+
+/*
  * do loopback mount.
  */
 static int do_loopback(struct path *path, char *old_name,
@@ -1527,6 +1623,9 @@ static int do_loopback(struct path *path, char *old_name,
 	err = -EINVAL;
 	if (IS_MNT_UNBINDABLE(old_path.mnt))
 		goto out;
+	/* Mount part of a union mount elsewhere? The mind boggles. */
+	if (IS_MNT_UNION(old_path.mnt))
+		goto out;
 
 	if (!check_mnt(path->mnt) || !check_mnt(old_path.mnt))
 		goto out;
@@ -1548,7 +1647,6 @@ static int do_loopback(struct path *path, char *old_name,
 		spin_unlock(&vfsmount_lock);
 		release_mounts(&umount_list);
 	}
-
 out:
 	up_write(&namespace_sem);
 	path_put(&old_path);
@@ -1589,6 +1687,17 @@ static int do_remount(struct path *path, int flags, int mnt_flags,
 	if (!check_mnt(path->mnt))
 		return -EINVAL;
 
+	if (mnt_flags & MNT_UNION)
+		return -EINVAL;
+
+	if ((path->mnt->mnt_flags & MNT_UNION) &&
+	    !(mnt_flags & MNT_UNION))
+		return -EINVAL;
+
+	if ((path->mnt->mnt_flags & MNT_UNION) &&
+	    (mnt_flags & MNT_READONLY))
+		return -EINVAL;
+
 	if (path->dentry != path->mnt->mnt_root)
 		return -EINVAL;
 
@@ -1641,6 +1750,9 @@ static int do_move_mount(struct path *path, char *old_name)
 	while (d_mountpoint(path->dentry) &&
 	       follow_down(path))
 		;
+	/* Get the lowest layer of a union mount to move the whole stack */
+	while (union_down_one(&old_path.mnt, &old_path.dentry))
+		;
 	err = -EINVAL;
 	if (!check_mnt(path->mnt) || !check_mnt(old_path.mnt))
 		goto out;
@@ -1753,10 +1865,18 @@ int do_add_mount(struct vfsmount *newmnt, struct path *path,
 	if (S_ISLNK(newmnt->mnt_root->d_inode->i_mode))
 		goto unlock;
 
+	err = check_union_mnt(path, newmnt, mnt_flags);
+	if (err)
+		goto unlock;
+
 	newmnt->mnt_flags = mnt_flags;
 	if ((err = graft_tree(newmnt, path)))
 		goto unlock;
 
+	/* Union mounts require the lower layer to always be read-only */
+	if (mnt_flags & MNT_UNION)
+		inc_hard_readonly_users(newmnt->mnt_parent);
+
 	if (fslist) /* add to the specified expiration list */
 		list_add_tail(&newmnt->mnt_expire, fslist);
 
@@ -2267,6 +2387,14 @@ SYSCALL_DEFINE2(pivot_root, const char __user *, new_root,
 	if (d_unlinked(old.dentry))
 		goto out2;
 	error = -EBUSY;
+	/*
+	 * We want the bottom-most layer of a union mount here - if we
+	 * move that around, all the layers on top move with it.
+	 */
+	while (union_down_one(&new.mnt, &new.dentry))
+		;
+	while (union_down_one(&root.mnt, &root.dentry))
+		;
 	if (new.mnt == root.mnt ||
 	    old.mnt == root.mnt)
 		goto out2; /* loop, on the same file system  */
diff --git a/fs/union.c b/fs/union.c
index 5011d26..8ad9de7 100644
--- a/fs/union.c
+++ b/fs/union.c
@@ -114,6 +114,7 @@ static struct union_mount *union_alloc(struct path *upper, struct path *lower)
 
 	atomic_set(&um->u_count, 1);
 	INIT_LIST_HEAD(&um->u_unions);
+	INIT_LIST_HEAD(&um->u_list);
 	INIT_HLIST_NODE(&um->u_hash);
 	INIT_HLIST_NODE(&um->u_rhash);
 
@@ -274,6 +275,7 @@ int append_to_union(struct path *upper, struct path *lower)
 		union_put(new);
 		return 0;
 	}
+	list_add(&new->u_list, &upper->mnt->mnt_unions);
 	list_add(&new->u_unions, &upper->dentry->d_unions);
 	lower->dentry->d_unionized++;
 	__union_hash(new);
@@ -373,6 +375,7 @@ repeat:
 	list_for_each_entry_safe(this, next, &dentry->d_unions, u_unions) {
 		BUG_ON(!hlist_unhashed(&this->u_hash));
 		BUG_ON(!hlist_unhashed(&this->u_rhash));
+		list_del(&this->u_list);
 		list_del(&this->u_unions);
 		this->u_lower.dentry->d_unionized--;
 		spin_unlock(&union_lock);
@@ -383,6 +386,66 @@ repeat:
 }
 
 /*
+ * Remove all union_mounts structures belonging to this vfsmount from the
+ * union lookup hashtable and so on ...
+ */
+void shrink_mnt_unions(struct vfsmount *mnt)
+{
+	struct union_mount *this, *next;
+
+repeat:
+	spin_lock(&union_lock);
+	list_for_each_entry_safe(this, next, &mnt->mnt_unions, u_list) {
+		if (this->u_upper.dentry == mnt->mnt_root)
+			continue;
+		__union_unhash(this);
+		list_del(&this->u_list);
+		list_del(&this->u_unions);
+		this->u_lower.dentry->d_unionized--;
+		spin_unlock(&union_lock);
+		union_put(this);
+		goto repeat;
+	}
+	spin_unlock(&union_lock);
+}
+
+int attach_mnt_union(struct vfsmount *upper_mnt, struct vfsmount *lower_mnt)
+{
+	struct path upper, lower;
+	if (!IS_MNT_UNION(upper_mnt))
+		return 0;
+
+	/* Make a union of the root dirs of the upper and lower mounts */
+	upper.mnt = upper_mnt;
+	upper.dentry = upper_mnt->mnt_root;
+
+	lower.mnt = lower_mnt;
+	lower.dentry = lower_mnt->mnt_root;
+
+	return append_to_union(&upper, &lower);
+}
+
+void detach_mnt_union(struct vfsmount *mnt)
+{
+	struct union_mount *um;
+
+	if (!IS_MNT_UNION(mnt))
+		return;
+
+	shrink_mnt_unions(mnt);
+
+	spin_lock(&union_lock);
+	um = union_cache_lookup(mnt->mnt_root, mnt);
+	__union_unhash(um);
+	list_del(&um->u_list);
+	list_del(&um->u_unions);
+	um->u_lower.dentry->d_unionized--;
+	spin_unlock(&union_lock);
+	union_put(um);
+	return;
+}
+
+/*
  * union_create_topmost_dir - Create a matching dir in the topmost file system
  */
 
diff --git a/include/linux/union.h b/include/linux/union.h
index 681b472..189a84d 100644
--- a/include/linux/union.h
+++ b/include/linux/union.h
@@ -49,6 +49,8 @@ extern void __d_drop_unions(struct dentry *);
 extern void shrink_d_unions(struct dentry *);
 extern struct dentry * union_create_topmost_dir(struct path *, struct qstr *,
 						struct path *);
+extern int attach_mnt_union(struct vfsmount *, struct vfsmount *);
+extern void detach_mnt_union(struct vfsmount *);
 
 #else /* CONFIG_UNION_MOUNT */
 
@@ -60,6 +62,8 @@ extern struct dentry * union_create_topmost_dir(struct path *, struct qstr *,
 #define __d_drop_unions(x)		do { } while (0)
 #define shrink_d_unions(x)		do { } while (0)
 #define union_create_topmost_dir(x, y, z)	({ BUG(); (NULL); })
+#define attach_mnt_union(x, y)		do { } while (0)
+#define detach_mnt_union(x)		do { } while (0)
 
 #endif	/* CONFIG_UNION_MOUNT */
 #endif	/* __KERNEL__ */
-- 
1.6.3.3

