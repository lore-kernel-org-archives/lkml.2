Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757391Ab0FOSqS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 14:46:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18696 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932211Ab0FOSmT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 14:42:19 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Jan Blunck <jblunck@suse.de>,
       Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Valerie Aurora <vaurora@redhat.com>
Subject: [PATCH 21/38] union-mount: Support for mounting union mount file systems
Date: Tue, 15 Jun 2010 11:39:51 -0700
Message-Id: <1276627208-17242-22-git-send-email-vaurora@redhat.com>
In-Reply-To: <1276627208-17242-1-git-send-email-vaurora@redhat.com>
References: <1276627208-17242-1-git-send-email-vaurora@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Create and tear down union mount structures on mount.  Check
requirements for union mounts.  This version clones the read-only
mounts and puts them in an array hanging off the superblock of the
topmost layer.

XXX - need array? maybe use mnt_child or mnt_hash instead

Thanks to Felix Fietkau <nbd@openwrt.org> for a bug fix.
---
 fs/namespace.c        |  231 ++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/super.c            |    1 +
 include/linux/fs.h    |    3 +
 include/linux/mount.h |    2 +
 4 files changed, 235 insertions(+), 2 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 7a399ba..9f3884c 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -33,6 +33,7 @@
 #include <asm/unistd.h>
 #include "pnode.h"
 #include "internal.h"
+#include "union.h"
 
 #define HASH_SHIFT ilog2(PAGE_SIZE / sizeof(struct list_head))
 #define HASH_SIZE (1UL << HASH_SHIFT)
@@ -1049,6 +1050,7 @@ void umount_tree(struct vfsmount *mnt, int propagate, struct list_head *kill)
 		propagate_umount(kill);
 
 	list_for_each_entry(p, kill, mnt_hash) {
+		d_free_unions(p->mnt_root);
 		list_del_init(&p->mnt_expire);
 		list_del_init(&p->mnt_list);
 		__touch_mnt_namespace(p->mnt_ns);
@@ -1334,6 +1336,193 @@ static int invent_group_ids(struct vfsmount *mnt, bool recurse)
 	return 0;
 }
 
+/**
+ * check_mnt_union - mount-time checks for union mount
+ *
+ * @mntpnt: path of the mountpoint the new mount will be on
+ * @topmost_mnt: vfsmount of the new file system to be mounted
+ * @mnt_flags: mount flags for the new file system
+ *
+ * Mount-time check of upper and lower layer file systems to see if we
+ * can union mount one on the other.
+ *
+ * The rules:
+ *
+ * Lower layer(s) read-only: We can't deal with namespace changes in
+ * the lower layers of a union, so the lower layer must be read-only.
+ * Note that we could possibly convert a read-write unioned mount into
+ * a read-only mount here, which would give us a way to union more
+ * than one layer with separate mount commands.
+ *
+ * Union only at roots of file systems: Only permit unioning of file
+ * systems at their root directories.  This allows us to mark entire
+ * mounts as unioned.  Otherwise we must slowly and expensively work
+ * our way up a path looking for a unioned directory before we know if
+ * a path is from a unioned lower layer.
+ *
+ * No submounts.  We could potentially mount over several read-only
+ * submounts, it's just more code to write.
+ *
+ * Topmost layer must be writable to support our readdir()
+ * solution of copying up all lower level entries to the
+ * topmost layer.
+ *
+ * Topmost file system must support whiteouts and fallthrus.
+ *
+ * Topmost file system can't be mounted elsewhere. XXX implement some
+ * kind of marker in the superblock so subsequent mounts are not
+ * possible.
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
+check_mnt_union(struct path *mntpnt, struct vfsmount *topmost_mnt, int mnt_flags)
+{
+	struct vfsmount *lower_mnt = mntpnt->mnt;
+
+	if (!(mnt_flags & MNT_UNION))
+		return 0;
+
+#ifndef CONFIG_UNION_MOUNT
+	return -EINVAL;
+#endif
+	if (!(lower_mnt->mnt_sb->s_flags & MS_RDONLY))
+		return -EBUSY;
+
+	if (!list_empty(&lower_mnt->mnt_mounts))
+		return -EBUSY;
+
+	if (!IS_ROOT(mntpnt->dentry))
+		return -EINVAL;
+
+	if (mnt_flags & MNT_READONLY)
+		return -EROFS;
+
+	if (!(topmost_mnt->mnt_sb->s_flags & MS_WHITEOUT))
+		return -EINVAL;
+
+	/* XXX top level mount should only be mounted once */
+
+	return 0;
+}
+
+void put_union_sb(struct super_block *sb)
+{
+	struct vfsmount *mnt;
+	int i;
+
+	if (sb->s_vfs_union_mnts) {
+		for (i = 0; i < sb->s_vfs_union_count; i++) {
+			mnt = sb->s_vfs_union_mnts[i];
+			if (mnt) {
+				dec_hard_readonly_users(mnt);
+				mntput(mnt);
+			}
+		}
+		kfree(sb->s_vfs_union_mnts);
+	}
+}
+
+static void cleanup_mnt_union(struct vfsmount *topmost_mnt)
+{
+	d_free_unions(topmost_mnt->mnt_root);
+	put_union_sb(topmost_mnt->mnt_sb);
+}
+
+/**
+ * prepare_mnt_union - do setup necessary for a union mount
+ *
+ * @topmost_mnt: vfsmount of topmost layer
+ * @mntpnt: path of requested mountpoint
+ *
+ * A union mount clones the underlying read-only mounts and keeps them
+ * in its own internal list of of vfsmounts, hanging off the
+ * superblock.  The first underlying mount (at @mntpnt) has passed
+ * check_mnt_union(), so we know we have at least one layer of union
+ * mount underneath this one.  We union every underlying file system
+ * that is mounted on the same mountpoint (well, pathname) and
+ * read-only.
+ *
+ * XXX - Maybe should take # of layers to go down as an argument. But
+ * how to pass this in through mount options? All solutions look ugly.
+ */
+
+static int prepare_mnt_union(struct vfsmount *topmost_mnt, struct path *mntpnt)
+{
+	struct vfsmount *mnt;
+	struct super_block *sb = topmost_mnt->mnt_sb;
+	struct union_dir **next_ud;
+	struct path upper, lower, this_layer;
+	int i;
+	int err;
+
+	/* Count the mounts to be unioned. */
+	BUG_ON(sb->s_vfs_union_count != 0);
+	this_layer = *mntpnt;
+	while(check_mnt_union(&this_layer, topmost_mnt, MNT_UNION) == 0) {
+		sb->s_vfs_union_count++;
+		/* Where is this layer mounted? See if we can union that. */
+		this_layer.dentry = this_layer.mnt->mnt_mountpoint;
+		this_layer.mnt = this_layer.mnt->mnt_parent;
+	}
+	BUG_ON(sb->s_vfs_union_count == 0);
+
+	/*
+	 * Allocate an array of pointers to vfsmounts.  We use this in
+	 * deactivate_super() to free the underlying mounts when the
+	 * topmost layer of a union mount loses its last reference.
+	 *
+	 * XXX - can't we link through mnt_child or mnt_hash instead?
+	 * Neither is in use when a vfsmount is dangling off a union
+	 * mounted superblock and therefore not part of the vfsmount
+	 * tree.
+	 */
+	err = -ENOMEM;
+	sb->s_vfs_union_mnts = kzalloc(sb->s_vfs_union_count *
+				       sizeof (*sb->s_vfs_union_mnts),
+				       GFP_KERNEL);
+	if (!sb->s_vfs_union_mnts)
+		goto out;
+
+	/* Clone the mounts */
+	mnt = mntpnt->mnt;
+	for (i = 0; i < sb->s_vfs_union_count; i++) {
+		sb->s_vfs_union_mnts[i] = clone_mnt(mnt, mnt->mnt_root, CL_PRIVATE);
+		if (!sb->s_vfs_union_mnts[i])
+			goto out;
+		inc_hard_readonly_users(mnt);
+		/* XXX set mountpoint or otherwise manipulate cloned mnt? */
+		mnt = mnt->mnt_parent;
+	}
+
+	/* Build the union stack for the root dir */
+	upper.mnt = topmost_mnt;
+	upper.dentry = topmost_mnt->mnt_root;
+	next_ud = &topmost_mnt->mnt_root->d_union_dir;
+	for (i = 0; i < sb->s_vfs_union_count; i++) {
+		mnt = sb->s_vfs_union_mnts[i];
+		lower.mnt = mntget(mnt);
+		lower.dentry = dget(mnt->mnt_root);
+		err = union_add_dir(&upper, &lower, next_ud);
+		if (err)
+			goto out;
+		next_ud = &lower.dentry->d_union_dir;
+		upper = lower;
+	}
+
+	return 0;
+out:
+	cleanup_mnt_union(topmost_mnt);
+	return err;
+}
+
 /*
  *  @source_mnt : mount tree to be attached
  *  @nd         : place the mount tree @source_mnt is attached
@@ -1411,9 +1600,16 @@ static int attach_recursive_mnt(struct vfsmount *source_mnt,
 		if (err)
 			goto out;
 	}
+
+	if (!parent_path && IS_MNT_UNION(source_mnt)) {
+		err = prepare_mnt_union(source_mnt, path);
+		if (err)
+			goto out_cleanup_ids;
+	}
+
 	err = propagate_mnt(dest_mnt, dest_dentry, source_mnt, &tree_list);
 	if (err)
-		goto out_cleanup_ids;
+		goto out_cleanup_union;
 
 	spin_lock(&vfsmount_lock);
 
@@ -1437,6 +1633,9 @@ static int attach_recursive_mnt(struct vfsmount *source_mnt,
 	spin_unlock(&vfsmount_lock);
 	return 0;
 
+ out_cleanup_union:
+	if (IS_MNT_UNION(source_mnt))
+		cleanup_mnt_union(source_mnt);
  out_cleanup_ids:
 	if (IS_MNT_SHARED(dest_mnt))
 		cleanup_group_ids(source_mnt, NULL);
@@ -1490,6 +1689,17 @@ static int do_change_type(struct path *path, int flag)
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
@@ -1527,6 +1737,9 @@ static int do_loopback(struct path *path, char *old_name,
 	err = -EINVAL;
 	if (IS_MNT_UNBINDABLE(old_path.mnt))
 		goto out;
+	/* Mount part of a union mount elsewhere? The mind boggles. */
+	if (IS_MNT_UNION(old_path.mnt))
+		goto out;
 
 	if (!check_mnt(path->mnt) || !check_mnt(old_path.mnt))
 		goto out;
@@ -1548,7 +1761,6 @@ static int do_loopback(struct path *path, char *old_name,
 		spin_unlock(&vfsmount_lock);
 		release_mounts(&umount_list);
 	}
-
 out:
 	up_write(&namespace_sem);
 	path_put(&old_path);
@@ -1589,6 +1801,17 @@ static int do_remount(struct path *path, int flags, int mnt_flags,
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
 
@@ -1753,6 +1976,10 @@ int do_add_mount(struct vfsmount *newmnt, struct path *path,
 	if (S_ISLNK(newmnt->mnt_root->d_inode->i_mode))
 		goto unlock;
 
+	err = check_mnt_union(path, newmnt, mnt_flags);
+	if (err)
+		goto unlock;
+
 	newmnt->mnt_flags = mnt_flags;
 	if ((err = graft_tree(newmnt, path)))
 		goto unlock;
diff --git a/fs/super.c b/fs/super.c
index 6add39b..2ade113 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -197,6 +197,7 @@ void deactivate_super(struct super_block *s)
 		down_write(&s->s_umount);
 		fs->kill_sb(s);
 		put_filesystem(fs);
+		put_union_sb(s);
 		put_super(s);
 	}
 }
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 32e6988..cc2934d 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1396,6 +1396,9 @@ struct super_block {
 	 */
 	int s_hard_readonly_users;
 
+	/* Array of vfsmounts that are part of this union mount */
+	struct vfsmount **s_vfs_union_mnts;
+	int s_vfs_union_count;
 };
 
 extern struct timespec current_fs_time(struct super_block *sb);
diff --git a/include/linux/mount.h b/include/linux/mount.h
index 0302703..17d3d27 100644
--- a/include/linux/mount.h
+++ b/include/linux/mount.h
@@ -136,4 +136,6 @@ extern void mark_mounts_for_expiry(struct list_head *mounts);
 
 extern dev_t name_to_dev_t(char *name);
 
+extern void put_union_sb(struct super_block *sb);
+
 #endif /* _LINUX_MOUNT_H */
-- 
1.6.3.3

